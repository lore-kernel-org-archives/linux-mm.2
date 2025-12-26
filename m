Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC8E3E7AD74
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 06:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21196B0088; Fri, 26 Dec 2025 01:39:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCECB6B0089; Fri, 26 Dec 2025 01:39:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDB166B008A; Fri, 26 Dec 2025 01:39:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BE6B46B0088
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 01:39:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4C2438C21F
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 06:39:02 +0000 (UTC)
X-FDA: 84260669724.12.AC0603C
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf22.hostedemail.com (Postfix) with ESMTP id D8DD6C0004
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 06:38:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CD8TlUev;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766731140; a=rsa-sha256;
	cv=none;
	b=N561XVUnIElcokXOmMoWinGVBdRJb0iWxXvPKNcGrDFKN0FqTCJI1YVq7BhoMnxW7P6oIX
	2Hx1oOvZgOAEaZt3OmP5L8UYMxph3TFJQdYuB6Q0M0JIR56ivlU4Wkh4SMc5cIwaLlLVBu
	ONXnDmkNRcO13mok60PivxU3aIHD4Ag=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CD8TlUev;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766731140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7W6lTO5HqhdsUdqMUK0JVCIeu7zAS4i6K6mEqBoWdOw=;
	b=G8lEv8S/zzdmIs7FVMolopufp8cWd0oyNjBGZ+Jn7MniHzZSUagkI1F3kSNjN5LztaZFyF
	QAHckjqs3GWscQOrOY3Px/dh52IkSiK4WTVfOfqtRbFbfR3saHNqxuqXZaYxIhC8sEZNeS
	e4T5nXj28xP0thJyegzRf54sbAjVo7o=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766731136; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=7W6lTO5HqhdsUdqMUK0JVCIeu7zAS4i6K6mEqBoWdOw=;
	b=CD8TlUev+TLWHv3DpGXzCaimcmdx6BevOAOUhW8Aj7XtCPBOs14ivT2mFl4k6v6yPB46X5JRX+6sYSH6TAn0Y6LDd5bmIbFA3MTDgVeY24BxkQVJo+HeVAXAeUyJjlb9DblieyA8AltDJaUlKe4qOn/CJOvk5BvSI/9YsVF0UM8=
Received: from localhost.localdomain(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0WvgaM6Q_1766731125 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Dec 2025 14:38:55 +0800
From: Weilin Tong <tongweilin@linux.alibaba.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	baolin.wang@linux.alibaba.com,
	Weilin Tong <tongweilin@linux.alibaba.com>
Subject: [RFC PATCH] arm64: Kconfig: enable ARCH_WANTS_THP_SWAP for all pagesizes
Date: Fri, 26 Dec 2025 14:38:00 +0800
Message-ID: <20251226063759.4020782-2-tongweilin@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D8DD6C0004
X-Rspamd-Server: rspam10
X-Stat-Signature: hgbdocgp3z3kzp6kbbeen3gmmg9ijwei
X-HE-Tag: 1766731139-941429
X-HE-Meta: U2FsdGVkX18UBsCEolQAoUl6oMrpNg5Ys7f0xICmBRK2btrx8RlvNNeb41oQ6IsLsce40IzW+qrpquHSogXnwSKqpUSLhQeeoXcAJ1Lun94G9E49Thehd3JmdaPpmV3zIwmbSZIhtyNOTucXE26Nq5PteTAIkSGvhB5jOVpfj+geFVDWY5nkrdSZ9+tOqSMq7cFjfUlX8Tk6akdZZ8X18d5zVb5tDISz7QnHl5FMrq91ES+HLauA5vitRBhW9XDkrkfT/2efQ2lpFajbhBZT9jp5rcC0M5dQZwDJ+8MQ+s5rK5+J5IU0HlUh5JZ18+pztq9fGupChqpTSoyTdf9lRv57eGC/zaTurayNhxTG22ZWm04IxNIkJQdMS3CQAZl+9mHFTatRyN+/D81lFJXBIthn5xh0pMR5EaZt3PFhBhsb+n+F8NwbSbAcjJ3QMKGl7kZa1Z2ADaF9DASmQi/CAiUh0tBtyLy6GdG/f+OemNpHTfdrzGjAdvn2tep205b26aviT9dYwnFCzObLnD9vfpxyMpQNy7nNmEJlwZzw9tXS/6cPAn54NZTHteBQrtD0RgS7K36iPsxYHbV2FWA3mfmyyFY4G2HSVb4JR46rlwb823a02i25R8qASCSMFgjRf+dZYpUiXgqCBkGTRkvO05fh8fTQKDExDVh0dOSwm6km8BJAgdFXvBz83XeUvnW7IJVpMhFz4fWWmoF3YgKHXUqpyhYTs3Ev7H8RCBo3mCZZa36aqk4jtcqTNA/5ATsnkeoGV3odX7+uxvKa38gFdzfEzDSLuCOfwSetbIxsqBmtCggYo8MCkcr/mhZwUwNCcVMZy5+SgfUB6Z0WNAHnvGlMET6PHt0bWdgqalwzeBkh81DAnOGWrWtbFTMzOudfrEqwSDEx91eIKb2OG6JZ+mOuXmeFK+JjIC/JjqzE9NaQs+racN8cKY1WQGvWUVdiv+GOpOXTDmhERKtz7FR
 XWkFdP7S
 1sy+g9b32cqeUxsIAUlWgKdbDY1jporqzW8AAAGGH+iW86dPLisNEo5Q15tA/YuMeBTDSEGTt5gjTqQnS1p39+QqLc74WXfYzzP2P7EojGy+f3wn8BUpBzHLLPRdHFJtPZql7sRbWcv5sDwLUwWs9CZQGcK6UbekhyBbRu8xui52zB39qz/DAhB7YzqnQPSbijJqRJ/V65GuZDlx1k8Gm3/IxbnT5AtqE6KMTo63PDy+yDau7ZGFK5VXX0Q61VuAcVQFMt3phEHYu4kY8Y1aqXe6eHeo0CEmDkYZP3LXW3QikzDod+mhEXB5cVtCi21m7H0JYi7S+VB3htX/cn/c0TrEGKfY+1heOiEMv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, ARCH_WANTS_THP_SWAP was limited to 4K page size ARM64 kernels, but
large folios requiring swapping also exist in other page size configurations
(e.g. 64K). Without this config, large folios in these kernels cannot be swapped
out.

Here we enable ARCH_WANTS_THP_SWAP for all ARM64 page sizes.

Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
---
 arch/arm64/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 93173f0a09c7..58f7b4405f81 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -120,7 +120,7 @@ config ARM64
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANTS_EXECMEM_LATE
 	select ARCH_WANTS_NO_INSTR
-	select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
+	select ARCH_WANTS_THP_SWAP
 	select ARCH_HAS_UBSAN
 	select ARM_AMBA
 	select ARM_ARCH_TIMER
-- 
2.43.7


