Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD161C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 04:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3808A6B0088; Mon, 29 Jun 2026 00:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331756B0092; Mon, 29 Jun 2026 00:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 222016B0093; Mon, 29 Jun 2026 00:03:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E184E6B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 00:03:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 61D1A1A053A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:03:52 +0000 (UTC)
X-FDA: 84931606704.22.AE2F405
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8A2FD180004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:03:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EUBX1LDb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782705830;
	b=zpUylMF+QUXcLGdMabL+xOqBiSWchANmm/o+MEE2MNgi5B93YX0vvosZUyTtTc7s1clTaC
	Przq4osJtucolpZEX+g1TQP4VvH/voscEFxMrmXvWW5zpF2APg/oW/ndfKM/jWBkMNON16
	nJ1IfC2+ma5B/suXT2wzmA/R9WulzUo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782705830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qWOyOOefL1L0qpTT6Ovn6IvrZReT+icTWgiUMkImrG0=;
	b=QKXtXYEdW0VGtjmq7kVOjIfICIg5GyL0fhtCckxrXzAcypDL4RVEBg2WOnZHJs25XgcOyZ
	dCsGn/9K9Q79vLz0BowFEjQFn3DLcmsOlG/s7LxkcbvtiYzoo+FUkf4k5zfqbVk8fMH3i1
	fZuA9db2l/SYkgYpzOw3Zxig4qlq8d0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EUBX1LDb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4938d5f86f3so8943705e9.1
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782705829; x=1783310629; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qWOyOOefL1L0qpTT6Ovn6IvrZReT+icTWgiUMkImrG0=;
        b=EUBX1LDbIgsNgTJaFTpB9RzBpx5mV1gX/Q+oXZ5Zc7d6qvR4xV3BAKoQJ8ICrcXJmL
         4YyVjKjYyjMdLXhLGADS6KSgA4BzcGTU0RKAC226Ar7pEz8VwcDdyT2ozh62HltAalP7
         ZF1bencRsVhy6D1uAsRXyslCE2mlnvyOxcQLvD/kVFNENBVWxtkSjepaMJjN8iqPeUDw
         8EClUmwCSIRz5BzUNsqsELqDJP9xYQjHm5gcBQ9L9fDY3kUiD0h4jVrMgApxMnR0Auz0
         +lDROD3VB09nmxMPVabf6GnEr/QmHbbjr13SB81HuIbxpd+XNhHe1kvH0KAHXQcuCuso
         /jzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782705829; x=1783310629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qWOyOOefL1L0qpTT6Ovn6IvrZReT+icTWgiUMkImrG0=;
        b=a3WeXP3eN3j6OQ773aTdK23d77pvgR5kyXKNazmbQfDJiXKyVmrVo4Akt0qlAgtXGc
         ZnmgrGTdCdjHGuHCRAAxslpcnJt0wvlODIU2Hd6mOftB5/PP+5LbOckc41AysqnpKG/t
         H7KbHk/EGL1wu/nzCwVY3djr292T/avPKTCU63YLMt6kzyAn+P99bY3LwsCPx2ALF8j0
         4/1if3gkz2tuwkJlvSPNT8vGEBA/Go3oKJbYuE6H45BPWzril25PHeVlcHXdigmpe8XP
         ez0OoaqxIr4y9NhO/EsFWhwfiqv7THit9W8R8v/AIHpF2Vcqxxr6U2jsbfYAEiVkTDG9
         zFzg==
X-Gm-Message-State: AOJu0YwLSDCUxPTibnlvPY/lRhhz8mn/vYFidlZK0FWHRVX6h7Rgnv6s
	L/UTP3ltdvLlDUdawedIXl1Ld1CQTOaNIQyOBzMKsnlpNlm4/fH4c4TN
X-Gm-Gg: AfdE7cn29nXKJfnHM5MOpoJAGxy1LhOPAKAyPxmsnZYfb+6I6DFHPQFY8wQHbe3qMqO
	LRIgFK3dqYhlBlv316X8JihuApgbntw0bN78q8SityadrsZvrEMwzBPbhi7DelWrRQNAAwrZwk2
	47Ai6y7CvMO3TO/5Ek+rBz1vJ/3qJJjMY4Xm60hBe+uD5mpqF/RZJWg9gRM7V2m90/9oY2qw2F4
	Us2+ESSFPqRVPzKE/J+VAOgvh+mdIzpv4hMIE+MpG+UjvLBhRL6HeLxNXSm3MTnWH4hPG18hzvp
	fRICTqvPVZarW+ZFADNWQvWHLHFQ3u4S5Tw+BIn3P3xvew3jy/mKJwq37pswkbaIUe8JCBIUq2u
	vJ5JXZ2GV45COc/FHlobaF2f0eoH9uRxEV9MHoar24nSWWWMOtZhVkqaZvGYarl6Tb45V4q4DdH
	JB+yNeaiqa9VM=
X-Received: by 2002:a05:600c:8b23:b0:493:a43d:6a2e with SMTP id 5b1f17b1804b1-493a43d6b59mr68551165e9.8.1782705828974;
        Sun, 28 Jun 2026 21:03:48 -0700 (PDT)
Received: from user ([104.28.154.196])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492690100c7sm310404035e9.12.2026.06.28.21.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 21:03:48 -0700 (PDT)
From: yahia <yahia.a.abdrabou@gmail.com>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	yahia ahmed <yahia.a.abdrabou@gmail.com>,
	syzbot+76cc716982cf0254f302@syzkaller.appspotmail.com
Subject: [PATCH v3] mm/shmem: Fix data-race in shmem_fault
Date: Mon, 29 Jun 2026 07:03:45 +0300
Message-ID: <20260629040345.13138-1-yahia.a.abdrabou@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <8b6aecca-c4fe-441b-b0f9-fff10f7b43af@linux.alibaba.com>
References: <8b6aecca-c4fe-441b-b0f9-fff10f7b43af@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8A2FD180004
X-Rspam-User: 
X-Stat-Signature: aoua8wuks8k4g14xuhtzu5pnfurj4378
X-HE-Tag: 1782705830-263043
X-HE-Meta: U2FsdGVkX19sQ1WfsxINVal4aFM9sccHNe29pEUbVWKcXArud6gy+0nMugcBXIYfdyLEx+PMUo/J5HzXX/yLJVJ5+5kCvD9EJa0QXk3asNvgX4EIgwj1nAIgBRfDmoO4fmK9IP+UFngkUPsdRgo8vAgj1wgn+SJW31EViBUfiVhi/l+07//wLctTVn2u7tfzZfXngdq2NwfkitMeqLWm6YcNZbFSGYshV5vb4JSNnIjGDZALCDWfOQ5mJlM6j/YaZ/w9kJg9V573nujQ5UJ/pBRapPermuHhhaJ6fsaFMCbyI/tMuVxACby4ovYZg+w1a64uxCq8iKv8gUmhGogSLl98cfZ+112nYBBiSh4kkAGsxMwYtNOIa4NICPk6EGjGOAZ2F4SuwuldWAJPUIhHIZy55bT72BYF8TtSjWlvyuYvGIpE2RAPm+LRUIDWvFKuEzaBAcDaKUs3sFaUjdmTMsZ7k0yR9Dt+hJSi535MZrp4uBCX8FaQLMVBkKTEdNzlwvIXLk8xbscZZOJLSl1QtLao2akC7lZe9jEUAnfjnjnCXOcEJQ2St/5XvdQNTUbzZk6ZwnJRE/Gqbpv2PEk9X0CZhcrTTKnYhwxTjIlj2PjGvdqHgxkYF55l3l5FRGvpiQiYNxHqWU14wYO7tVDnSJ5MbEkq4e3RHo1jx3od+a/WRdj+aNXPwb6K+tHRJe4Z9Gp9DfPkahPzLgFuXZ4og/PCz6pj2T+bgHNZDhiT1pXGEEHJKweAt9X1z3WtbpXi7rtk2CV/JqdePsEX8F6rCBgzBKa665vlA1cVxxvJpBSMsueuyw9zm7bg6XrH8yP/lzsyUV4STC6DToAqMav7z4ylPeIGdIc8gDNl1PNZns2ZEBqsZOROthx/b0WzJWqbP2Yt1tFU6t5Klw82NW24iS2kJvUByTyzJrakoaWKQDtpCCKoex+KrSmUHls7wcB5o1aIuft7739khIN82N6
 kh0Xa6Q4
 ocHbv3AD9zrGHGNmEk+TrAx824Q99vr0gAlF8sK54jNwNplu82LXQK4yuKU3C6jr4QhDD6CSoAqfjEyj3GlM5JrcReCknBSqDaB/6eYROOV0+F0EAYpV2dQZk6xkaa9+mFzxJh+0RlMShe4lfBaYVKIEgdxPFvgc7h0apngqqYl85J5cpR4SxgBqGnaQ4JcpVdTbejtaMor8Or5jVp2ScLoxMfZBfxlNgvFwk/ptiYjmC/YvcZ29IDNUMDAUw4K6BTc9crwlhp5UipYQzw8ZIY/kfK1Rv9gB/2Uk5akZYPvW7azXZfVaY8CGOf0KQL9UDvAympStT6WNfsO5jUgRjB9XjSx5SR9WsAQfaqYcUzpI+Kfwoh47djtX97bkYOsEsjI4Ogb3vetXUIpv7qTixKX5CgZQRXcI0LQ+2yOXNeF8z0xJB+DSOLE9JMXtOEt5W/Hg3tUqy7rEXcUptYVLjex6/tb+YR7UV8Fg+Kc/H9IQ/kB9159XHxX6RezAQrKHloJrOWZFMLgyqrDqYi9q4vn7gIjVqGgvdfzixOWNl2RzOTsM7UcGdCA8OqgVrLMam3A1AT84WWIx1sO9XcEuxqWbYO0PYzjagxcAIE7jZCrKN4TlBiZdNIlanj7GPzjiz6oDxvaNW9VILY+WS/MGbx9hYgQWRWUY37NciGVnydZPDFI5u5rn36WAPAyLH/i67fQ9csWAqUnJKJ6Kwdg5mAlH3eXrrWxzF3ausgnyOCQ+dXC/nBnvbGTaWiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: yahia ahmed <yahia.a.abdrabou@gmail.com>

shmem_fault and shmem_writeout access inode->i_private
without holding a lock, while shmem_fallocate is modifying
it while holding a lock, thus a data-race is created.

Fix this by using READ_ONCE and WRITE_ONCE, which provides
an atomic, lockless read of inode->i_private which prevents
compiler optimizations such as caching in registers and add
writing to inode->i_private with WRITE_ONCE to prevent the
compiler from writing in registers.

Reported-by: syzbot+76cc716982cf0254f302@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=76cc716982cf0254f302
Signed-off-by: yahia ahmed <yahia.a.abdrabou@gmail.com>
---
v3:
- Fix lockless read in shmem_writeout
- Apply WRITE_ONCE and READ_ONCE across all
  locked instances of inode->i_private
v2:
- Add WRITE_ONCE to shmem_fallocate()
---
 mm/shmem.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb..1c39e9dfc524 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1657,10 +1657,10 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 	 * reactivate the folio, and let shmem_fallocate() quit when too many.
 	 */
 	if (!folio_test_uptodate(folio)) {
-		if (inode->i_private) {
+		if (READ_ONCE(inode->i_private)) {
 			struct shmem_falloc *shmem_falloc;
 			spin_lock(&inode->i_lock);
-			shmem_falloc = inode->i_private;
+			shmem_falloc = READ_ONCE(inode->i_private);
 			if (shmem_falloc &&
 			    !shmem_falloc->waitq &&
 			    index >= shmem_falloc->start &&
@@ -2647,7 +2647,7 @@ static vm_fault_t shmem_falloc_wait(struct vm_fault *vmf, struct inode *inode)
 	vm_fault_t ret = 0;
 
 	spin_lock(&inode->i_lock);
-	shmem_falloc = inode->i_private;
+	shmem_falloc = READ_ONCE(inode->i_private);
 	if (shmem_falloc &&
 	    shmem_falloc->waitq &&
 	    vmf->pgoff >= shmem_falloc->start &&
@@ -2693,7 +2693,7 @@ static vm_fault_t shmem_fault(struct vm_fault *vmf)
 	 * Trinity finds that probing a hole which tmpfs is punching can
 	 * prevent the hole-punch from ever completing: noted in i_private.
 	 */
-	if (unlikely(inode->i_private)) {
+	if (unlikely(READ_ONCE(inode->i_private))) {
 		ret = shmem_falloc_wait(vmf, inode);
 		if (ret)
 			return ret;
@@ -3630,7 +3630,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		shmem_falloc.start = (u64)unmap_start >> PAGE_SHIFT;
 		shmem_falloc.next = (unmap_end + 1) >> PAGE_SHIFT;
 		spin_lock(&inode->i_lock);
-		inode->i_private = &shmem_falloc;
+		WRITE_ONCE(inode->i_private, &shmem_falloc);
 		spin_unlock(&inode->i_lock);
 
 		if ((u64)unmap_end > (u64)unmap_start)
@@ -3640,7 +3640,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		/* No need to unmap again: hole-punching leaves COWed pages */
 
 		spin_lock(&inode->i_lock);
-		inode->i_private = NULL;
+		WRITE_ONCE(inode->i_private, NULL);
 		wake_up_all(&shmem_falloc_waitq);
 		WARN_ON_ONCE(!list_empty(&shmem_falloc_waitq.head));
 		spin_unlock(&inode->i_lock);
@@ -3672,7 +3672,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 	shmem_falloc.nr_falloced = 0;
 	shmem_falloc.nr_unswapped = 0;
 	spin_lock(&inode->i_lock);
-	inode->i_private = &shmem_falloc;
+	WRITE_ONCE(inode->i_private, &shmem_falloc);
 	spin_unlock(&inode->i_lock);
 
 	/*
@@ -3747,7 +3747,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		i_size_write(inode, offset + len);
 undone:
 	spin_lock(&inode->i_lock);
-	inode->i_private = NULL;
+	WRITE_ONCE(inode->i_private, NULL);
 	spin_unlock(&inode->i_lock);
 out:
 	if (!error)
-- 
2.54.0


