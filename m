Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 777CACA1015
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1F7C8E0012; Fri,  5 Sep 2025 05:16:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF71D8E0001; Fri,  5 Sep 2025 05:16:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C33DC8E0012; Fri,  5 Sep 2025 05:16:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B01308E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:16:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 543731DEE30
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:16:07 +0000 (UTC)
X-FDA: 83854639974.08.A8C01EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B200540009
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:16:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RH2fU4i+;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757063765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=muouU2oolOGeWfJrs+B67NjgZRQgR5BDRY56klj/YaI=;
	b=PL6ZoxPZ/EQVBffE9Inu+aX5+nb7qEQ50/TQV7No4iatYkO8YFmmWE/lm1ODhJlVANHTU3
	yUndlnoJ4jXPN+B0Cn7f6+dgYIKJoGFUFtsHXqVlhDj2BE1+WXFFUXNerWiob4Xee9gDcf
	pP9TC7n2U28ySAPDt7Mc/ntTEb2NTDc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RH2fU4i+;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757063765; a=rsa-sha256;
	cv=none;
	b=vwcuVXrkNlbgKJkLG8vqi4u5s/y+wGGa/y2YY0oS0MMZZw2kccdXYPQ5U5GnBZy3brShOF
	2JkapzxwQm/SZcuczIAVuZGhbboqWiTBbSWMStjA9bj2Or3b4nAkxbDtP7D5srYyF5o8pw
	Ce4Dd7qWxdM2pI5ZZyYjoOFYtry0xPg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BA5144B60;
	Fri,  5 Sep 2025 09:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B41C4CEF1;
	Fri,  5 Sep 2025 09:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757063764;
	bh=1IU8iNPFjdRTUgrA68VBqcClGn/H7DOAUdL3G8nHiEs=;
	h=From:To:Cc:Subject:Date:From;
	b=RH2fU4i+rv4uBB1kpIVm1bYvJqfpTgq1mvrYU17shyK6Sf2Z/EyJSai2etoAfntXT
	 hYhnnQrCjBFh4uy4CmvjyrKy/gYiLSVchS5LsY+OQDGcpxuDanY37txyCDlJPr3/Ha
	 yBZidrkmtw24376FgGbffA0fdBEAco4DoiiG5nM0ikvCx6LbXMq3aIq0ct4Qje6B8B
	 7qHS7n7pEPt7oe7ZY3RVmmSpAYl2TvRVNv5d2hqXk4xLmSWXRYZZWQABTa2GQuFJtq
	 dZAhk0mvbwItXTPYVSr3VdGyPVZLcdcms6GWDIH8cGJSRhbWJtF5SV3Iy9FFu/Xlx6
	 jKqtgtZVFW4Xg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] MAINTAINERS: add tree entry to numa memblocks and emulation block
Date: Fri,  5 Sep 2025 12:15:57 +0300
Message-ID: <20250905091557.3529937-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B200540009
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: w14qz4nno3wpdsbqqb6thm55uuu8frhq
X-HE-Tag: 1757063765-485898
X-HE-Meta: U2FsdGVkX194wW4DtWAENzvtTNtZYnbh23CqPX3t370QnCYrqwNeMEY8WI6pgShaqaQe6oiFj6TiDzUUYNxpZ0sHHBAHUKFVj/Yz3rpm4JblgLbW4DjgWCB6He71sT+NKJFgFJMqSGRJJc1EsDlAOXljt2sCzG/tXN6hPMaeZiknp2eOPm/NkZ9WXoh4CDMKDp0C0/BENlW/srP6UGR8OUwIFjpnfYwy7w52wMsUEZvfoHOZ50MS8QKQEcRBYkSMedlsZwn/4C11rXTNsZMZiIaofpkIEM1XqzAoBbx9NDc6Dx0Tj6WSx0+5peuzDHVkjzaA7/ty8uZjZRESa67/iL4jWExFT9q9Dj7paDK81TlxYUS/ncADa/lFSyPDOsl7Nff9mdxgvyScW8aWonFpIb2pnLyrikQDA651H1djVkMskXKlOPHZcSfGLglmeSYy2ddCqJVLYYmT8nf9Q2qiXztlsul9ubA0PZYCKp+dQHgQbafMiUhx/q4RwE+7VFLzBcJFfTsxN2KPCHuRJhvfNtTN1KvzVQjmpr0ZCPxLr8BYr7j131gDfywKH7jB46IBi7KDYCyOxmxh1PL9tpbr4IX+w/LB0jo4vRgdXdSK9pGFeWLWfbVK8reMSkOG2ws+17+L+BTtlupnHg3m7UEsR9kYv4zxsMwv3gQMfxIt9ycQQ9LD9qQkxLqMMyCUVwCfNO/lK6xJz+GWLZWWVCRqMkfxSwtgW79/iHTSqZk0yImyWUF1KuChVI1xhE9kvuaOSSIs/1g1CZnBzmiinm0mGXsNFX7XGfQk7GVdCl//zVmTUAa/dg25DVPIK4Xon9ePTSXaiBqkpyjsFpL/TTNfrBM1uy+Mb/gUIC1SiX059IfF4jdqEf0VZuxJydEpRCc50Yl5CaeqYC/0ca/4Rjwhp0ZN9D2kc3g+f/wMACH2d8ANcHFKdMq8jlor45pxtIElSLnwBYnglUbHZwE4mQX
 q5dYcoWG
 AdPfOpaw/sbcPe5xjcYBYA5XWlNJy+CJQM0kwtpp+syGJkh77/rKpPW/VON7JuGwSyqjVQWj0SA2JNXtxM65AOKnETptNOZHnLAe5cM6naB/TlBW9uYr6tDirjJqkENLNVutUEnm5tdyzi2N+uHgq80SdxSEJnQFKknw8KUUYaRFeYt1RQiqMJEEVepz+Dm8SP1CWv98QKgtiWIeRCeJDFuN5Qm5HORtIZX20dhYFp+DFiohf1CHZRvdbNzcmljQ5CD4MqLMmav8GojgFbF08zcMXd/HA1tMyA8hO9WBI0wFdMWwmPuhDmSCmww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dcfbd11efef..fbdbf7c012a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16127,6 +16127,7 @@ M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git
 F:	include/linux/numa_memblks.h
 F:	mm/numa.c
 F:	mm/numa_emulation.c
-- 
2.50.1


