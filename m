Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03B63CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 698236B00C3; Tue, 26 May 2026 08:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66EF56B00C6; Tue, 26 May 2026 08:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ACD96B00C8; Tue, 26 May 2026 08:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4490C6B00C3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:50:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5A49C19C7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:50:52 +0000 (UTC)
X-FDA: 84809555544.06.8B4C2D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2BFCE100009
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:50:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kzRvk5e2;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779799851; a=rsa-sha256;
	cv=none;
	b=RkNkjkrrwXABv1MnP1skisV2VfClSt/QS1kqSCmmv5845QYJDr5qFnGbRtHrnuWdsqhKx1
	GVtmWg3GX74NaT5Ufc7z0NMP/N6rN+RFd0kqXbULlo5LUVMIHTaLeq3J3hmAZQl3zsv+JG
	GEE9IX1Tx79q/MyZQrxQ1WTFl1yQPwc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kzRvk5e2;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779799851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gG3agpilQ4MpstT87zE1nTk6qyo1jydMxmD6GEu/XHw=;
	b=rhByyY4/7nJ+ubcqV3gYmjwiolWklRKVrUH664sWwOUDD40rLgiibr7bOvMsoxyZ3UL8ig
	cfrG0Arz7uIU2+uhuyosRTug2U5iQAcoAsDpW4lgfEVAWc598ojBrZT1DBvr6ea2enFyT5
	a7hgwcaK5do2MDAvd0gT9/mr8TWeBeM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B3D0060210;
	Tue, 26 May 2026 12:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322511F00A3A;
	Tue, 26 May 2026 12:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779799850;
	bh=gG3agpilQ4MpstT87zE1nTk6qyo1jydMxmD6GEu/XHw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kzRvk5e2BuxIoYvQBIBHk0zrhimZ69ezYEbWKQnDRvl+hWoHZlCvC1utbNfSVFlDg
	 g+gt5jlLpowccZktUJNPftQgbnlbbYSrRqSxf4BHHILI2oSn5goR7MuohL6wIqpngL
	 /uDAi9axGu4c4o92x8enOa6G028OeH1L8T1pxnWiHD9Yn3lzuKREi/sp1xo2BuSxFL
	 M/UBFB0KeVeioL7xSQeU290fo4vNvp23LGZjEELBmWydJuc+Kn2zwZsaH9UjvVlw6l
	 AiaN5Rpd2gAiV+mGetKbZwGx6Bxi1PNhxwienG7NUc7I+FMAG1ktlZq/qwPMvFiY+g
	 XKIZeEkADdl2w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 26 May 2026 15:50:39 +0300
Subject: [PATCH v2 2/2] lib/raid6: use kvmalloc() in raid6_select_algo()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-lib-v2-2-ca3f0fc24b14@kernel.org>
References: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org>
In-Reply-To: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai@fnnas.com>, Li Nan <linan122@huawei.com>, 
 Xiao Ni <xiao@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-raid@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BFCE100009
X-Rspamd-Server: rspam03
X-Stat-Signature: hrcn64htaiyhwczwsf33xis3ffc8m64y
X-HE-Tag: 1779799850-964192
X-HE-Meta: U2FsdGVkX19q9yWnrnpFNtyBmwgUwg/y7NYp+4UnxgujDZ27trUESPwJNdao8fa+ENoB5beyyumD/Z6RvRk8xm4x3mUkmL13f3oIsBx86KzKXIqz14xlsvhNN0JUQTmLfE0/O445WSR7w2FbbLY+ydIIS3SCqzmoKYmV6TvAgUGmo5CBHUgo66Dy0qPsF1+qFKVA4E0GyXrmjbSiGAWoAq6GQfpj06lgKOLmHwIh74phlly1pGcNEndvLa+Fjaq0m1Z8RAvCmf3PI81vBhUNAu3fwZM1ILuSvK6Km1RDkecWhFIZE+zhS869206ogl4o64CYg7pLx+AetYTM1fsaTC/ezTtoIq1sQcNerv6vQ18qBLrnEDGx4fIL8DsYNc8QlWLBDTOEe9/D74LkUO6YOEgGsY4zOJuYqYhfO2LWO7SZ6Q7vABitCnjxSVenIsok4ux3NRTG8sAJUQ/IMRTHFa3cU8dTjvaaeGy2/j1CZ6YiSzCEBGPB5xngelP58ifEiOIYhJrbpOXYKUBz/cenpsCfQSqpxRJPecP7AKb+3pHHLKLPbNP7W2DVn8GoyGih7qT7wEWTRX6xmGzDVcAAjVF51nMixrd3t9uNzBwl/K1ELwxX0BW5vL+AyqqDH98PfDuM87PhnnuOje13/NlHxxfIUE7OFt6svTY7oitMqJff3v79B4t+9fylLFfWstuSeAgbaYEHT6Ar+e4+G6Dfe/S4qdvfdoI4fu7NS8Gi0lArPq/V4ChbyGc+31bawpXtrPvqW1qbp81ulMGN2xMO7IGMWR8OAUBGVYszMhjARcOPNeLva179YLVPFYdG5/TA+BCH5YJFKMROl79n7sVpNs7rvfcqbZ8xj7Fibs+sJR5cXO7W8RkNKhB7oNMuSHZG85wDACWa24zJUnmx6M3pEWtceJy+rU8bw+NAhFZ+MNkoAgYjz/pcd88JGDvBbzMt/4mjyClyFKzWpIaR9wI
 3d34i4hI
 61LzRrxKOnX8CDQcdb09IEVayWehbqJH+oS5VggTeAYl8+SQyuFaNKaZx7b7A5Yksk7Aby3iUjPfeX63NsQUolKnAxNid3AB7IhPyRieY2ql2FZuh17A+Kgn0umGZ1l8QN7wcuctVkMYe1jsPhT8h2m+edT4dHRd/Tdm5Bk1KGrpHh8AP1W9QkRZo2P/rjP1HepLU+o8394nm0mIAaUIkbS0/D3uBOMpN8NLLdlCk5QNdATTcDQaFB9Akt8dT/EYVLdRKvCdUeRtogtc6vN0XGjIUmvSbqvJ/o348Vgq/pGLBuL1TgnosqU+3NxJQjij7GxCm/WKw9AhXMQSLa9/msO05nrXfasy0j5+PVVlUJ2Dh+Wm2n7A/7LrDEYmukSnd29x1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

raid6_select_algo() allocates an order 3 (8 pages) buffer that is used
as a scratch area for selection of the best algorithm.

This buffer does not need to be physically contiguous and can be
allocated with kvmalloc().

Replace __get_free_pages() call with kvmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 lib/raid6/algos.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 799e0e5eac26..1f565c3b63ce 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/raid/pq.h>
+#include <linux/slab.h>
 #ifndef __KERNEL__
 #include <sys/mman.h>
 #include <stdio.h>
@@ -129,7 +130,6 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
 #endif
 
 #define RAID6_TEST_DISKS	8
-#define RAID6_TEST_DISKS_ORDER	3
 
 static inline const struct raid6_recov_calls *raid6_choose_recov(void)
 {
@@ -250,7 +250,7 @@ int __init raid6_select_algo(void)
 	int i, cycle;
 
 	/* prepare the buffer and fill it circularly with gfmul table */
-	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
+	disk_ptr = kvmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
 	if (!disk_ptr) {
 		pr_err("raid6: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -275,7 +275,7 @@ int __init raid6_select_algo(void)
 	/* select raid recover functions */
 	rec_best = raid6_choose_recov();
 
-	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
+	kvfree(disk_ptr);
 
 	return gen_best && rec_best ? 0 : -EINVAL;
 }

-- 
2.53.0


