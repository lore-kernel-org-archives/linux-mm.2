Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A6EDFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 04:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE3926B00A3; Thu, 30 Apr 2026 00:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABB396B00A5; Thu, 30 Apr 2026 00:05:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7CC6B00A6; Thu, 30 Apr 2026 00:05:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF3D6B00A3
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:05:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 55DD61403F1
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:05:22 +0000 (UTC)
X-FDA: 84713882484.01.1761E4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B4886140009
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:05:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ocBfK8O4;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777521920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+yWwHlIWL+l+Dg90SDWHd1+WqElaJbqvcRn9WxFEv1Q=;
	b=uSvdt0K95igJtGs4Bs4e5JdmPoUwpaBR4sD1IcGDjOskXYluFJLhCebPq+Ig4Ep4pTSeQr
	3nSELE/W03fYV6NgXxVY53dybmsO15xhpb3YUD8atD0g6Qj8XOITJfsYFk+LxQF6mDcddQ
	/eqzGqFIHgG+kVhgR5BAKdoIpRNRKxk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777521920; a=rsa-sha256;
	cv=none;
	b=OWKv1vYJr78STL+DM8UKe3yN+YuyS2DsQ43V+CGO/1mXIOn4zmhRHp9pOahpDVyhfpGQ1A
	pbW1VWaOcHRTkuJKad983VjueNwap6Rou+QTaaBHVdX+tlve730odz1YhsrqorA22gozJm
	8Z5NK0yXLD2iLbw3pp+N5F/izKILQ+Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ocBfK8O4;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D4925435B9;
	Thu, 30 Apr 2026 04:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6E6C2BCB8;
	Thu, 30 Apr 2026 04:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777521919;
	bh=pbXcAk16+rZv3mixELQ0Ipha1GpoRaVFtegxsWu8Zqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocBfK8O4Ywas1DnfVulkPf8JAygFLLLSXfSSIhFab5aPydgPGyQRMZl4VC0fcDxzh
	 ZSF8ZjBo9bGMKXhwl/M9RckUdNTcuoEDs1sQYC8HxwbacO47214ueIB5PuN5R9qPyl
	 7/vXQCjK6DhEeLKCFGPA8mBl5pi8Xir7/uhc151Nze4/YpDG2oez+rIhbMYqevbaCB
	 eLjkznrbZrf9uMIIMqF0/apYtZGMqURcRmb3l4AFBitMcYEDgyMeHrj8n9yVB0vf4O
	 no7KHvYOh/5gIxhaiyHe3dpMaQbh59rmzxY6J3CuNafpQ/IRafc5BIkfCVPTmXqOYt
	 bTDK/08BVuABA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	willy@infradead.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jack@suse.cz,
	pfalcato@suse.de,
	wanglian@kylinos.cn,
	chentao@kylinos.cn,
	lianux.mm@gmail.com,
	kunwu.chan@gmail.com,
	liyangouwen1@oppo.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v2 5/5] mm/filemap: Avoid retrying page faults on uptodate folios in filemap faults
Date: Thu, 30 Apr 2026 12:04:27 +0800
Message-Id: <20260430040427.4672-6-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260430040427.4672-1-baohua@kernel.org>
References: <20260430040427.4672-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B4886140009
X-Stat-Signature: paed4krdpr8y6gyy8oibtdhz19pbfpd9
X-Rspam-User: 
X-HE-Tag: 1777521920-819053
X-HE-Meta: U2FsdGVkX1/2g3jNfdrWfP2m3KYqswlOLzcm9AGCXid0H/RelI3F6g3tQwJk4sjRHfiye3eCvDXGZVqixiWupbDQuyM//SouuVorUD9yqQltaALrKtkW/mhDLEBWCkAPV7yUPzijjCD5MzO4YzQtROGwIo4rJJVGtOeVow05VKLS1yQbCY48E8C9D1kV6Ik8fuxjCA2Pls+g1XLHH0F0PeUtLKTWLZiPkdIaeNxaUzUDz8tOfIcM87mSQJb6w+tE6LKrlyfO/xlbZL078fGyK6m3cJgGUr9MfGouPUxMUscWNbPpLqEoJTPJhNgycOFgPIgf51E4mfM28YUAJYbHhzQjLDFwUY4oPnqNF9QjwOBreuxGgel3kPZwBM/wlH7f1bixopUFlMq8+bZdjK3+dMcu7qAiNe+hkmPDwQFUnP5bSfRJy7DJoAIzUzAaA0AVqIW14BQvDBSM6eTXa/GPcem8Kt82NvUwlIgER+P1oy46NbP5ZThiegqZuM1NLrtcBuRV7crQnA0HCXFzE7x0FszknYsmtH3p64wO8pTe7kHcNBL95cWSbqLiA4s0nwBeifXMS4343vd6lu7bFRrKyR/FUMRpjmqiDMrFiXyl7L7jXXEpBpvRi/2rxMsoGnvfAhfedzkt1o8+FVdst9Hw7PnRQ0aANTHfnKJQC1e3zRni/cR6ynlIUiGGJEe1yc+TocUaIhvrRqSLIPEMSo16q5IgjNGIroSg8UprXi3OE2akonmziKO307SYll0qxebkC7g7SQEXTeq4sK2KimmPqTCE11Gj0/FzorCyyVexmXARTrgqhhVV71C/Ygyi4Qh2P8pBVLm4Wxb7NiX0cMf7Kp7/asgFaqsGPZc562Gkhk6nH1sevngi9euqtbNWsDD/4hpHI88BrPJo8tqXc6C5LF037YfmCXmUc8u9Pmrp8utJR2pySI+g1mzWnXsbdRzThxIZj1e/kbBJd+u8Xe7
 mmKMvzYJ
 m3Vn5h84QUpatm6qF3LRodG+fb4pgwU2z1azW6mdyK0DxjDNVDlEBJcxB3OrKcIGOg32M9PDlVhAS1W3z17fprXyWxpibf7sguDVYJXSCcHQ8e7rJr+hAyR7U7b1j6NuJZsX0FgjV9aUgLM78UvoNC4134vcrQvuHZTFmE6L3ciSweGc7lT/gV13oCOzejmHtL/DzJJSnPGrQkdwx2ndGUntEYSTzNjlESHdQ16WE3/tzosKA1TOxOv8QHWCpAwixqfnz2tYVgfF9SImP6XKzGCW/9mj3c6tD21CY9W6Qoqq4rQhKned1EhthBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For uptodate folios, we are not waiting on I/O. We should
be able to acquire the folio lock shortly, so there is no
need to drop per-vma locks and perform a full PF retry.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/filemap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index b532d6cbafc8..0d2f6af5d0fe 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3533,6 +3533,13 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		}
 	}
 
+	/*
+	 * If the folio is uptodate, we are likely only waiting for
+	 * another concurrent PTE mapping to complete, which should
+	 * be brief. No need to drop the lock and retry the fault.
+	 */
+	if (folio_test_uptodate(folio))
+		vmf->flags &= ~FAULT_FLAG_ALLOW_RETRY;
 	if (!lock_folio_maybe_drop_mmap(vmf, folio, &fpin))
 		goto out_retry;
 
-- 
2.39.3 (Apple Git-146)


