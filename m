Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56AACD10376
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 03:44:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 760F86B0008; Tue, 25 Nov 2025 22:44:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711E96B0011; Tue, 25 Nov 2025 22:44:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627D56B0012; Tue, 25 Nov 2025 22:44:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 48EF66B0011
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 22:44:12 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C25241602AD
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 03:44:11 +0000 (UTC)
X-FDA: 84151365102.25.1C34859
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 26AA8140005
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 03:44:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=k4m6BbEa;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764128650; a=rsa-sha256;
	cv=none;
	b=tVMNCVXayx5E6+zbcqvNekCB0w1UGvcHZljhODfil5byzHVSKF5lcngyoc9NXAvMZhjlIN
	VjC5N9cnBHv8zCM2Ej2HLBfPlgsPJxdjxnjrxThLr4ZTbc0rhL22o+pPoFiBc6BePovZkB
	8DwFupB6lVtRjHFJfit/Xhwx5i3aiuw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=k4m6BbEa;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764128650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vp1DpLgt+L5h1yfE1IIZjFDPdLKVI6pbtrBVCtvb2As=;
	b=z9XwJRjc+DOG5Rvw/dCFroelQdHNfIhuAqGKCsi+XZix0yDxFXKmCHSiWp9sXTgOTHeZJq
	DbldetiqyfckN3j+r7NX5G4xIKQFOAWEbmpECyOmvOBkTHiBnruaDBDIh2YV1NFg9NbnU3
	CklxxGXTPj3RyFJUNmlqE0RphmwICJM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=vp1DpLgt+L5h1yfE1IIZjFDPdLKVI6pbtrBVCtvb2As=; b=k4m6BbEaiRPniFk/2EPCeCmj9x
	JjjByVPL7bBFdBch+mt/CBEdlZCAuoLzPDuwC0KB51QPU1F0U+2mRtBpTRnHaCgsVpTNlIWz5i6vU
	ZJTzuGCIg98ercoCcdZ+LXcehWbPDofrS4FfkRIFHJFfyDX8hyBGBe9H8+D73570JWXY/9Rwt2q1k
	qDaJMBNUJSmbyYmo+FPXOjZzkGLO3RiOfgxFgVb5RHUTdi74625K75AbsPqel3yW6HNYlTOH3tZ7l
	JZ+qo3OBB8S61DdgVvhvcI6cT3Jj81kV+DORZOlebY6/IZor8AgXKlxiYKS4pUHeAPdBLxJb181SX
	H9Xwt3Hw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vO6Rq-00000009V53-19Nv;
	Wed, 26 Nov 2025 03:44:06 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH] mm: fix vma_start_write_killable() signal handling
Date: Wed, 26 Nov 2025 03:42:57 +0000
Message-ID: <20251126034404.2264317-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 26AA8140005
X-Stat-Signature: 58harof8uz9sdqaetz3xqphk3q88ifwf
X-Rspam-User: 
X-HE-Tag: 1764128648-784521
X-HE-Meta: U2FsdGVkX1+fC2B8aySB+rlO95cwYROPNWOX8L9HSWIuFvGG8eF1OlbLwrv6kN0grwl95DeFHiEb3pE0KUfudPfTn2rYOKxtEcEBFtTvtjCRW8zNY7jtMixSjGNNEr0hQcqcHsUJituclFASEZimRb3e9kfh6oFhel+sQK5myXa5cIO+hkHSuj0CWZJJL81ZkdfrS+UUQXzDisWiaVBGOzn4cCObS40GHPTeO9+cpa8NFCN/8ngzhyZ5klykGjkdS/WcB8UiNI1/9/fvq35TIA9LjRG/bX/EoQQii75qNlREBD9KTb6X8FBXCSBkZMq1bcG6YsNZd8TdVxeHrr39NQ9jNN7ZzGR2D8ctR2y2n+NATSCHB/nQW4nvQLveKEH/j92viUGOVwWRMYGonCo4KO35dUjAd2SYLKGXtKtB6n2LaBnRPgHEFTy2i9e55RRAikm6WEJwHQ/vNH2OGAKnZr2JBXr7vjCNaoLZnf4P4vEVGM+7gbSlEmhKkMPZcX62oV+lk4IbUYEzPt+jgjS4V4sKmExgK8U6zuZbOAIo+0A7t8pcMMz7KGR4ROOwP46TRK9WCBy+ZZ1DnLQS0x/9vFdM47J0YZiPRcGeCI92zGzm2bCGuVTQ5c2HoSfRSri/Ve1hNnZYAjAN0BwX2dwawssXQWmz9qV7WmI3ryCiRZqPIsGF4/veLh4EFa6hBv3RCpPhV55CFobOk5aLFtnPvHIi2QzcvgQhJGFVh+IAmZuOFyuhjFVJARxSjvXVRv6cipcoPrGgzjiMr7GuxFen33B7jnb0krhoycjGSdMeYjy5TN+333mUDq5pHfuUR/dYkjUpEXUhN5PcG8mMU/ZcpRiecRuHR374xAlYFCQfSYt81k+dhnXzmzHfTTYfganABtgQRydLDQrfeMoVZArY2kUorrbewZpOVwJSHzyIO14xqK3EpABeVD2Dv94riKebYgo0r5xUwMMUw1hQSt8
 TYhacqnC
 EWtnqnpelL7wPyJO590aIylb4BkqGqkO58SnMkbovYnfh5oF1KpPEi7SrMwcGtjTJYbN/w1uCLtZbxjNKG3GSvoXiJ8E9dXEB1m4rQEXkqbWSPTiz9WYyAi+1rkXeWhAE2+GColqLSDLa//KgnUltcpmeIF5sYQ6OD09cZL2pPXjmM/Sg3G4WLlZ2qXQDNyLHkJ3g/O8cL7vocpSVmegddu8bG8ujhmTHKCjjr0ybko+PFl39B6s8kFNZeHpBzK9Gm1GcWB7VqZ98WUUKi5WMP0e5LAgBYnt0OctLKdaSHvwWqARM00MJxe7NiGkfRjh+CxwjsfqgaoUfqY82yo8adjm218y/oHLQnzAlXbsX+BSxvwZUdDXR+FuDQ22/JnEtKaqkQ20BHblI3Sn1Lqvl6EDf6k2hGDZc4uGzHQwXch78++3EAXzpQVzaumMAHSX6fHsCWchqAnUI8vKDR+kzr8zc8O1i8KPrPjCBAhEBUXOFFdutNsKegglls4kUXKapX31r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If we get a signal, we need to restore the vm_refcnt.  The wrinkle in
that is that we might be the last reference.  If that happens, fix the
refcount to look like we weren't interrupted by a fatal signal.

Reported-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com
Fixes: 2197bb60f890 ("mm: add vma_start_write_killable()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
Andrew, since the vma_start_write_killable() patch is in mm-stable,
I don't think you can put this in as a fixup, right?

Suren, Liam, Vlastimil, Lorenzo ... none of you spotted this bug.
Any other stupid thing I've done?  And am I doing the right thing
with refcount_set()?

 mm/mmap_lock.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index e6e5570d1ec7..71af7f0a5fe1 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -74,9 +74,18 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
 		   state);
 	if (err) {
+		if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
+			/* Oh cobblers.  While we got a fatal signal, we
+			 * raced with the last user.  Pretend we didn't notice
+			 * the signal
+			 */
+			refcount_set(&vma->vm_refcnt, VMA_LOCK_OFFSET);
+			goto acquired;
+		}
 		rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
 		return err;
 	}
+acquired:
 	lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
 
 	return 1;
-- 
2.47.2


