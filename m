Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B2A4CFD36C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 04:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48AE86B0028; Mon, 24 Nov 2025 23:27:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 440B56B002A; Mon, 24 Nov 2025 23:27:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32A386B002B; Mon, 24 Nov 2025 23:27:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0BA6B0028
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 23:27:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1BA01A04BD
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:27:26 +0000 (UTC)
X-FDA: 84147845292.16.FC58EA7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8D4C640002
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:27:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pDROx3U+;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764044845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nETtmOazMk8q5bK36CAyeBJ2Wh5i5mbm/naGgQItvz4=;
	b=zVc9FOtKGlrmXKqfYl4Utxi5dXMA1+BzNYcwRa8grn+DsHoRGo5nTtXneizXDzC4/llboK
	D+bLJH0iRFXJzuqwTx3pyT4wlJxQSYdWAOTXzWzk9b3RUTBB7wWBjy2J+VQKNuQjA5l3aY
	O6oibVodUVSf027GeQUAqRJCs3GVZWA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764044845; a=rsa-sha256;
	cv=none;
	b=iD8lsoYUVJ2XwwJUaqrAYg0uLiPCksfUejVfN9HAtoJgIkvIveVGGJDFLUAAr0un3bDlBU
	/0ujRoYH4XvTRuNgJVCPT2hJoCR6OIMX8sXH8lABLbYqIvLe5rae7tEToZQDXt7RKLDr03
	WEis4RPlKuVbBLJ/GYmWKFsqAXfSem8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pDROx3U+;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nETtmOazMk8q5bK36CAyeBJ2Wh5i5mbm/naGgQItvz4=; b=pDROx3U+76x7CWF1RqpD+nR/db
	jDnWA/BImv3oPDRAfy4FBEaMhBOPZVNcdyGc7EQZmH1Dau8kKwWoH07vCbcAcuTx2xi13Gxux97T1
	xa6RYHt8qxjZE4JG+erltQa5Yy7GR+ocLM7Qe6a0pxi+C2kV/bvC31kB8A7xQ8ZKRj5RcQvLtQb9j
	ku5RLGYhm/Gq9GDY9YnqFOz2OoHFNz1jXw0/A4CBVj2YqVgdQSHKNR2nqnkV5IMS/9nI1Rs+pdrOs
	Wm/jFmQbLPtd+VECwIOKxGm2Jx1aBIMZJjrPatP870489XnkAo3we/+D7RbB1Q+SQwGXI/EO4fb8J
	5MXzK6BA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNke8-000000080je-34Bu;
	Tue, 25 Nov 2025 04:27:20 +0000
Date: Tue, 25 Nov 2025 04:27:20 +0000
From: Matthew Wilcox <willy@infradead.org>
To: syzbot <syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, shakeel.butt@linux.dev,
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] WARNING: refcount bug in __vma_enter_locked
Message-ID: <aSUwKBP97nd4kpjP@casper.infradead.org>
References: <69252076.a70a0220.d98e3.009b.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69252076.a70a0220.d98e3.009b.GAE@google.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D4C640002
X-Stat-Signature: dwnsaah8bo5yko9nhkekpwsrt3s71oyp
X-HE-Tag: 1764044844-337320
X-HE-Meta: U2FsdGVkX19RYsPtWWVZ2cV6154R2iv0JLZ1aS82nLoxb9+b7A+9AEb3NkvPSGcMu9lmYOI1OUujbDkYSi/0gMqyVoTdGC2exsO6DoGWX/iCJMwlE6vm8DFa4rPZYGck7vYKr9QeocN3pxk+FsV7qr20QBszEFyM4vlO97Vn9vGHBYmcXxr6rs3uSbfKQMM6gnPyxiZrauzBrNDYPnHNTg6Xzq3b7m99xdg8XeSPzXs3hQKGC4sWVnJ2x11oxVZusOcCcqkgGR7yrT6UrUnIw29lEMIBzikKj4IzOzFoXZSAODYc1vZYWPuV6arRSzkpu39c09Dw4usRMl5IQNnRKZ4MHV8oq7USG2O1p9sUHRhxBFZKP8TYrOqq7WU2JCmAEz11FBy7vGCE760ZcUtwaOf+nuMEMEGQerDqXWn9Mbi6weq9ssRF9WjTxed/ZSvDuTxxv1/W1gtzgpIEVczDMEG9WWZndw8QMC3mm5aMNezZ4478fqksn3zShL4cqDvlHIGYO8kLckmeQeBFKDRwhF6yaqF3+LfrhjJPC3TwRC5b5puGMbtopCVQaA5Vk5p9a2X6N8/9am8KLr2BR5TbQQF+4IO4iklP18sVvqP8bXzcm+kakT0cEdDcQgkqpxwWTbBaR6EBEfs2d75hW0sSG7blyZv/qzke1TKuDYmiZZDQe4S9O4cr7PNJsl1M99dPWSCrbUY9JhDrV12vrNrnqLeuS+csKDQXqCVtrlkbIPGDDUppLmYwWsXcW88qMaCp7GnbMt8JDHkTk2gVY/qhS/ec1QVUo0SMjfIufoCZudWVlAx/rWPVP8xHI3V+p8V0YbceDZflwywJfafZo8DoRnL+O3RoV/kIvTHVQ78dS5mpMzHjSqDAfTCufYyGEZ18oyplPHlllT9SIgC1vtNnCaIxfm2ZiPMkJ51/INE1l/3566UnPlT4HeBhjKrLgAQEyKjie2APN+JlfGU9Xkh
 4wVp/clQ
 qAoMuzwjAt/5FKcLkaSMud2UBcrOE/Na1wsu7VdSryGhJbZTPMtSM07PeVpAjlSOIJken3LtsKbadeUSKLo0o9pMxKgfF1cwQbKxXgS2JKknenyJc1KqcI7/0yN464q0VYEoBsguLWh9ReALIl3H9NmKuuyV9WZP6BXG9qjHGhr8zRQr2Bg4nPLR1kgaWf9stLkrmVaCq4mX6Ho7ZRRnv+KnHlT0GkraAhWN41TErBgBkfujLwSJvRbvTDUrUmPTTyiZ8O0clTYY8wf91OcrPboDRoLymLAQAiPWvZ1r00ptVbXYNTaGHctwQ95sXsR9uca5snX2I5w2Dpd6k7rK0YnUCiVLh/+IHb3saEYaoTu8Zu2l5+e96HATeQfOy4Degry0hDtLG/KOQWzuypgctZsfLENE0OMP+CfHIUgRCugXUYs7WKklyZITkBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 07:20:22PM -0800, syzbot wrote:
> refcount_t: saturated; leaking memory.

Umm.  Something like this?

#syz test

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

