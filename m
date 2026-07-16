Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0B7DC44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24D226B009D; Thu, 16 Jul 2026 10:47:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D67F6B009E; Thu, 16 Jul 2026 10:47:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09E266B009F; Thu, 16 Jul 2026 10:47:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1DDD6B009D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:47:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB3921A01D7
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:11:43 +0000 (UTC)
X-FDA: 84994828086.27.1D08F35
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 01D691A0008
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:11:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dHTMWjZU;
	spf=pass (imf19.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784211102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ND1Mlfnj//sueUdP3Rtl6TIXHHpQPflpRLRpL4+r6dw=;
	b=VItcTDfNcfqTlNJ+LsFxYU+9CWVSkErkCYdUcCZ/M6H1iV+IPKZ4BnhVdK7zR1dkBe1q8G
	/sEhi+KAG5+HvutLzUNSFV5AhcCFWZROZKRl1Wg2l14D/WBRn/dmXHCCzMS7RgiUwNvgv9
	nWcWYfesaDAQ5D9utAp4RnIvWUHAtIY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dHTMWjZU;
	spf=pass (imf19.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784211102;
	b=uUk0H/jv2YFPvAdlSsQNyFRRIiBZvSSFQfhO56lkn1yPinfsCgjBCXkEDzPiHgW44pgKJO
	elHMuqN0JpnODvkzvTsI8qPK2zkgBu8EKfPHGmSO9iSMIyFHDzM4RcNqGms/iYlbniXxbq
	pGeJBz2/WTVQKEPT+X3oy7hKu41r8Gw=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47362928f65so6032957f8f.2
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 07:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784211100; x=1784815900; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ND1Mlfnj//sueUdP3Rtl6TIXHHpQPflpRLRpL4+r6dw=;
        b=dHTMWjZUeoscbiIYxHEBfV3navdlp1K05koGKFUf4kkv5NMfrPNPpqrpCM13BLv+Rf
         eBNduny33SpqnTkE/vw1WJIIs9JXczP1c0sWON55o+4ulvCAjTNs7P7IIGDMWzsIsix4
         Vqa0s+aUExKHYTeZubCsDWOjsV/JgMMHUgpP93xYVM1Z5lygVrFpYIM7iwD69TwlhUfr
         fIleOurALseHg2izvjspR/rRuQf0PLR83HzXADKIoQJ2gpDhrJshAT2NsUm6V4XPVZ91
         +CxlvwsMB24EJcG4cn+ZbNHH/UNlQxfwjt6Cnjpr/PBFJ0euHmaVzKqcUR960btK2c+k
         OXQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784211100; x=1784815900;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ND1Mlfnj//sueUdP3Rtl6TIXHHpQPflpRLRpL4+r6dw=;
        b=FoNmXJRL9PgKtnXNBZnX31xt/pEFw5z1f2HBQiaq9l3gMyaD7UWRRbAwFv8PaRfhVd
         U63HzpIzYbmmaFJf8BOQ0uK2rhKgwzPiUBnjhZ4cpSEGYIUmRhdrDGqV6jashTyRGK2/
         1WPnhKD0rWoO+w/Lq+DMwAfHxSeo+LnH+uq45mOZ+SI808kZH0c6HbAD/T/zMSQ0HCt1
         gfZ/jKlSfJ4TZMQMWvGlLH+kHVT0o+KWupRrNokup8uHYrcNZa3PQa9/Ue8OrSFtkTSt
         iGOFbEFURLCYQ+2EU69R06Yrk+grp4bBte1j4mgMZOioRXxC62iNgeDqyDJlzNePPs/s
         XJEA==
X-Forwarded-Encrypted: i=1; AHgh+Rp3aic91spKZJf98YLyE7oek1r3fowb0u36tNEGakz9XXQhMBCYiZDikX41gjh6L5QOZfMQnLoMRg==@kvack.org
X-Gm-Message-State: AOJu0YwIjDX001FqKYQDhzDGUsbOB+WuSCdMwezen+jWRAfN6zi+7yCs
	AmgS9+NsLvVe49fG7Db6wHk/Ei8AM5ZgvZfU2fE6VKY2XnTY1CdhytWY
X-Gm-Gg: AfdE7cnT+Lz6VvVaTJUxI4AGEREaUtC/jscKq/Td9OPz60ni4UMV9WfGKHxjnvIzz4e
	vBrtpXtBnlFU4R/BmygRA62xGycnZr7+xthfZ/MUD0hlkRRFOo0P6HDIZqJfmGc1/gmTL3603SG
	7lJm8HOzVoRjDQ+VNq9U8H4eyd5jznNEhYLirXrIpN87p2VCIX2syT4YmOeneFGwkuF+uFcdhfL
	M369cJmjSQNHZePPyeTHPqQl1z6OFpHxvCioIx/wsGkt3NDvvKW0pCkqg3hgmO7OmbqhbwWmER8
	MxXKtvFDXunDisdDMhRkBCspW0/ss+eS7zrSq/OliZs3R6KmTiwK/gywOTJcMeIpVHrF6TdMOqW
	Sh4bphQ+HYY8V/IjEE1sDAcPiLCpwiOfYO/EbCmv64nhiUFers8eF6wiYJYATyyCYlt7976WEGK
	pi+C2dlHw3qWK8in5mN5TsHzyDFAgJL9j5M5Ss+oMZl9bSKrsPcpZB
X-Received: by 2002:a05:6000:310b:b0:46f:5d62:d914 with SMTP id ffacd0b85a97d-47f488488b5mr15090426f8f.12.1784211099956;
        Thu, 16 Jul 2026 07:11:39 -0700 (PDT)
Received: from f.. (cst-prg-85-255.cust.vodafone.cz. [46.135.85.255])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464a973fsm26631643f8f.17.2026.07.16.07.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 07:11:39 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [RESEND PATCH] pid: cosmetic changes to alloc_pid()
Date: Thu, 16 Jul 2026 16:11:30 +0200
Message-ID: <20260716141130.2573188-1-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 01D691A0008
X-Stat-Signature: dzx94tc8nxhtypgxs86gtjgkgbwwwcqm
X-HE-Tag: 1784211101-728625
X-HE-Meta: U2FsdGVkX1/53aYUuVGZ5FIqlyyulrDZjWcmPcb1UA/z72Ln2n+R5ZuiuMMXIl1vG7alrAmFLl/te66/Ib43Eosg0rmG83VKNMqqXwgtOABtoGJWDYotxCwUTPmkWDP+ZAR/r+X7RE456sNsyMnqZzoG3GWMLVcNpZ1bGd4ZBzQnI4ro1YeHyUXD9TJLuTlnvw/q+NZbKviR+KrUtnExNvHOsSRM1R2nGn7qM649g1iUP2u0CDMjuCTtp+qVdc+AhB1vqN5S3wAcGVQrTTU9dh9LZeuWZTxecZO4Lw1ovojg6qujpQ1Per/xrCaj6mDLfBxUkvQVGgzXQqTMgDISDOeJFd6OyjUj7ykt/FB8rK4oRQBBG6I0i53nerxuPzEnMmbMaExc1xdowvdnIEfvXBXkGTWiBZMAyTRYErY5pS7jH3gzaNxKH3d2fzGM+zl4cczSyHkNCOoZXQ3dmTAcbfvq8jmhrjCQ25la2T7Pe4ZM2NtO8Vc3VA5Iqk4qHyns560XR+/Ueakpwria9xO7KeZZ+IbOuFtabK7gQnbv5NyKxrU+S6CXjVywIShbKDfAdrkSx2uB6X2LiFXcT7MPQNf3C++/I98Q32ZgB/9VDFRM8/eSHcYe5UDesTAhs8T6Ry5sXDrn8rnRTgNuyQYFlyqkdi10B6THww1yRaNcvOnH+TXrz6gOqGyO4/qKWoV/xvD5OzgOYYwB3CNqX0aaJI7d9XYa67nzaEASx9G4yhNPuGYdyuajgW0Ilp1Mh+12hIQ1mKTnuYom+1eWdA3swpGaaneeLD2eHMxJQ5CBtZ8cesw25hiJHuJIIjKZogEaqWc6qItG27vC5bbmqCN2yMEoIRxCpcZbnaCjLI4lUcvOb9aRjsipt6o71kVE3j3HgpFMGHkEH8nZUTPhmGATeUHuigbTcO9b6cAvhGfPQtlEriHgEc7tqnG8tlYx9oh9kjZqqJXquIm87K0J4DE
 hLNlTsLO
 eDk3X5jv4jtyj9aTRfNW9QH2wfAqlOVy/YD1LupVgB5RUVMrVR8DpmwHnRfybQyLSqeb2lT+UnV5ZcH1yxjLQMRcGGfTrzXAUeKE+/3FkwCgiwc5+FNzY6Tup7/I4oB9UbAS1EIUnaMGrizqsWLJ0FjCSuMviy5RdjIkRadAbCyauOBJInCl+7Gk4XaZd/MZQzBj/EqIFmAjpP/cOSzfI/CDEkqvzwQCMYOhwR63MqQ5HxpfIFIjlgiv22TLSsUcWV62zOCy6aztQUyxc5U5AoeQHgRp+9Zr7g/GBNOhKGz8GEiBNeGS6IA2NNs35A3f+goX7LPUcSe6cqt27TPdBBVS/Bt21d5iVlqxJvbUX4Tvw5CxZ1CsxIHR/AQOK5lyl1b/vKIpuYAarcK4QWBOpnyoMKD3SAUlVyOzfXLws8yGReyoEodtoSqRD+HierRpJhgAjZKKA3Rn6XhI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 6d864a1b182532e7 ("pid: only take pidmap_lock once on alloc")
landed v2 of the patch instead of v3. This patch remedies the problem.

No functional changes.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---

Hi Andrew,

this is an old & uncontroversial patch which fell through the cracks.
Would you mind picking it up?

 kernel/pid.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index f55189a3d07d..3f58635a9b08 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -177,7 +177,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 	 * for a process in all nested PID namespaces but arg_set_tid_size must
 	 * never be greater than the current ns->level + 1.
 	 */
-	if (arg_set_tid_size > ns->level + 1)
+	if (unlikely(arg_set_tid_size > ns->level + 1))
 		return ERR_PTR(-EINVAL);
 
 	/*
@@ -186,7 +186,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 	 * 1. allocate and fill in pid struct
 	 */
 	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
-	if (!pid)
+	if (unlikely(!pid))
 		return ERR_PTR(retval);
 
 	get_pid_ns(ns);
@@ -205,7 +205,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 	 * This stores found pid_max to make sure the used value is the same should
 	 * later code need it.
 	 */
-	for (tmp = ns, i = ns->level; i >= 0; i--) {
+	for (tmp = ns, i = ns->level; i >= 0;) {
 		pid_max[ns->level - i] = READ_ONCE(tmp->pid_max);
 
 		if (arg_set_tid_size) {
@@ -221,6 +221,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 		}
 
 		tmp = tmp->parent;
+		i--;
 	}
 
 	/*
@@ -241,10 +242,9 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 				       tid + 1, GFP_ATOMIC);
 			/*
 			 * If ENOSPC is returned it means that the PID is
-			 * alreay in use. Return EEXIST in that case.
+			 * already in use. Return EEXIST in that case.
 			 */
 			if (nr == -ENOSPC)
-
 				nr = -EEXIST;
 		} else {
 			int pid_min = 1;
@@ -270,12 +270,11 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 			 * Preload more memory if idr_alloc{,cyclic} failed with -ENOMEM.
 			 *
 			 * The IDR API only allows us to preload memory for one call, while we may end
-			 * up doing several under pidmap_lock with GFP_ATOMIC. The situation may be
-			 * salvageable with GFP_KERNEL. But make sure to not loop indefinitely if preload
-			 * did not help (the routine unfortunately returns void, so we have no idea
-			 * if it got anywhere).
+			 * up doing several with GFP_ATOMIC. It may be the situation is salvageable with
+			 * GFP_KERNEL. But make sure to not loop indefinitely if preload did not help
+			 * (the routine unfortunately returns void, so we have no idea if it got anywhere).
 			 *
-			 * The lock can be safely dropped and picked up as historically pid allocation
+			 * The pidmap lock can be safely dropped and picked up as historically pid allocation
 			 * for different namespaces was *not* atomic -- we try to hold on to it the
 			 * entire time only for performance reasons.
 			 */
@@ -299,7 +298,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 		/*
 		 * PID 1 (init) must be created first.
 		 */
-		if (!READ_ONCE(tmp->child_reaper) && nr != 1) {
+		if (unlikely(!READ_ONCE(tmp->child_reaper) && nr != 1)) {
 			retval = -EINVAL;
 			goto out_free;
 		}
-- 
2.48.1


