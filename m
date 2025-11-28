Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAA47CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 04:01:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2546B0088; Thu, 27 Nov 2025 23:01:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7A406B008A; Thu, 27 Nov 2025 23:01:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB6836B008C; Thu, 27 Nov 2025 23:01:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B90EC6B0088
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:01:09 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3EB225887A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:01:09 +0000 (UTC)
X-FDA: 84158665458.29.F003A11
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 77981C000B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:01:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vB1D9fKm;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764302467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5oGBUHafluPLdmYib2oQJbp8WO0WnnDAQ+rvwKsvUDc=;
	b=eW45v9AYKhSHc89S/V0z6DNVk56NDSZrMxAvPgOFVDeVH40s4aevGj1CVGT4TnZ3v3rWqe
	85Y8uxtNUlZv3OzbWST0nTT+/wWYlqjefLVS+gHH7vwkw6mjQFBzDT9YjpcoHIwnT3z8U1
	SqFdlpOjJ5xqJPfcBH5CYJQUbrxCiiA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764302467; a=rsa-sha256;
	cv=none;
	b=t3iHsJkidRrpSla/P79vyfZrjea6ML8/tRyv/eWXU7LJ2ufFOYxs2WoR7NBlujMrpx323+
	BpwAIQs8o0PRbtwmlv2IOXPLB/gRMIDyIU3diTC+vMJ8wN22b0WWpwQxvWLBr+e1gYU+YJ
	ROHsu4393lU9FMrXQ7xqj7de+0wqjJU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vB1D9fKm;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=5oGBUHafluPLdmYib2oQJbp8WO0WnnDAQ+rvwKsvUDc=; b=vB1D9fKm2K0JHUugVRen9BxN+2
	m/Y3NlT00JsDCdedm7CXZIc1aBXzhagSGTkyXYsABWcrR7eJUHEs762d6qWgaajac9d5qzF93tlkP
	lYAXNY2m5GJcAoEf69ygDrYwrPk/tMySB7N/P33R/zQu+OylSpR+s816Uqj2QK5Tdci1oTKKWOBN4
	fVT4gNkMBqAvjEBFl4th0yM1YXFrP5Oq0SKKXcmJazd40iAc4mPETxhzBMeXr1PFj9viEKun1kTSX
	6NL3Cuwl7EdpcZ37gZBWWSxEaJEgwLyAuJXpO3RsHJ69r0V+BycltxT0iKOcgBWV/+cchi1mY/4Ls
	r6V6/dNw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOpfK-0000000CgJo-2RPI;
	Fri, 28 Nov 2025 04:01:02 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3] mm: fix vma_start_write_killable() signal handling
Date: Fri, 28 Nov 2025 04:00:58 +0000
Message-ID: <20251128040100.3022561-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 77981C000B
X-Stat-Signature: 4anugxepmpnde9bbai3c3ui3exj71g9g
X-HE-Tag: 1764302466-87711
X-HE-Meta: U2FsdGVkX18B14uG/cB/sgHGWQICmlhbkvpMWHqNic3X9xCNjVHIu23kxHR4X1ek/m+O3xBuZZrsbJKPGEsDugN4dM6AnlyJIjY+uBENFKkjVJTUE2RredAhtTebtpTkzlKA8YUp7EgCtwon0IjzxTDhbnwyM87+Wz/omek9cldkXq0DLdxUJGtfyEm6kB0jFxryyEi/IHWgDBzToMqocB+DSde5GGPO+n79Za2KWqLeU6g7ERDnZe4W1Dv33tbhuoUr+qSVDMVOcFKtMs5GrypAM5zJTf/m1kUXnSFPBxPfN8R5SuZZ9n4FPCfK31pIjUpFCtnZ/kIVZ6ewFahCWxjJIAEDt4uKY68XxbzwIhDnmbQeMYQj8LQRN2FDMCpmy312YM1JPIRzIdBEp4nqj/oMSjWB8Cf0aTcHyu73EAncMtr+qCToQIKhExBPMs5Vp0YfwOSSkY19CnsdQdbBNezmYHXaLsDtFqh8xJFbUvgUkFt2gjV2wGIRUxeieNpOlLOGdW9h81AzPOH20Tq4mBBmZpRyn5NNGIG+KPTkasNSsOua9zG80QERicBFzSYSJneQBGXV26T5+g+D/CWxzyiOtX4VAPldV2/XVrRhYzcfKEk36qIF145y2DpzlkgWKcRU/2SDY+VDTQDtCPMWHy9at0gwEPxcvVGDSPgEJXQa5/bujenZQgfvc7ZenC7ExenNT4C/4yJQlwopOS4dO92w/h5jv2VVsNdwjbtnAwnNRVAIa/vCASX7LVk9FAzzt6ym7CfYYDtxqT8iSCss+niowtgMxDvoIo6jkHqBchWszfvRfwcPhPFYViRp/BiyD+ektiboJxgNkoV48PMmn5w0o6Dtx2sL3e9TWZF5uIK/KMU5+LfL4AIwVuRq+0MBawHmtORUAtYbPQm2jMX2yejWEMJkKNW6EgyBUg1Yi9zKT0vqPrSBgX/kfUh8KWuVHGJ8dXw+RpVk332zi1C
 lCbx5PPJ
 34S6EUGx+dDEJUMsX42ZUByj6hvlp8QT+4dhHvXbpHKCDsGroozf+XK2yHGa6R2X9g0TmB5QF2GX9g7OrR9Cdqb/IuJTT42Jyz+Sh3iIHPukad3yWzSw4ZsJxv42DzjT83Pks+F4tFxIV30hb4FlpP9CMDtu7ozl6KfMaK9PwaqAJ9Q3nsA/OFQcxcILDhUW9BbyzrxJcgRe//D6b+/JC9B2lcrxS52VL4So2fEsPujczhKoP0NNQ4XQzIYpGImPHncp4yyAQjVZ1m6M5XRJ4lIW09o5OqlhTlD1rtNkB138mi433Dyl4fCMy5D9/rEN9Chez1pZ2UWItWQEEoaJzKv8Gu9l7JdYfHOleQt5s6CG0AdprSkDFy5Hnng7ITjj/Wk7ea6OCRvXZZpv+ByP/CfAwIw8y2gOTMFWBY3uSvR+ozmwyuNLVf1U2Otu05A5iI2cd2P+p02k0j0SQtSI51sVUWmp5CcJPzJtk2wjTdlH0j66o4em/oYNY0hhD3fkHMwih
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If we get a signal, we need to restore the vm_refcnt.  We don't think
that the refcount can actually be decremented to zero here as it
requires the VMA to be detached, and the vma_mark_detached() uses
TASK_UNINTERRUPTIBLE.  However, that's a bit subtle, so handle it
as if the refcount was zero at the start of this function.

Reported-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com
Fixes: 2197bb60f890 ("mm: add vma_start_write_killable()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/mmap_lock.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index e6e5570d1ec7..7421b7ea8001 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -74,6 +74,14 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
 		   state);
 	if (err) {
+		if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
+			/*
+			 * The wait failed, but the last reader went away
+			 * as well.  Tell the caller the VMA is detached.
+			 */
+			WARN_ON_ONCE(!detaching);
+			err = 0;
+		}
 		rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
 		return err;
 	}
-- 
2.47.2


