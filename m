Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F54C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 209C26B009E; Mon, 31 Aug 2026 04:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BA106B009F; Mon, 31 Aug 2026 04:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0506B00A0; Mon, 31 Aug 2026 04:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E02776B009E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:28:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 65AC9403BC
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:28:02 +0000 (UTC)
X-FDA: 85160886804.06.B822C00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id B5CC318000D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:28:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CFigFzSX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788164880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDLOrEWk8s8P9NPs/hJ9ReKcQQKs4DBoKeRaLa6eCp4=;
	b=6uS6HCHm5HejhzIASF3EIuXvyMxq1KSL0UeH+DZTYxCm4b77nnkk61L2Oiv5ppHXTqXU1o
	nPtOTagEV8jUyk88XDb0iZrilOcL2Yg7VZWJnUgRvChnJuiqyfdl9vRgZBY+c71JJzEBYM
	/vml6lYcqfDjWOGvtxcDxw1fvcAS708=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CFigFzSX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788164880;
	b=YM+2g00eckVhrP1kdI1AutpUhY+ej0Fs/+6Ix8LSSYujbGGMiaf09K5BIaJGgr0fUmCN0L
	2hQw5Kb3gl7uu1SvHM9LoHpbvbfKGnQuXlEuacv5bSRDFg+JntkXqweh7UHKkGu+9wJqzK
	+2LxgkGavZdBSOXrDAbb4uKmuRks4gI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 45EFC6013A;
	Mon, 31 Aug 2026 08:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C251F00A3D;
	Mon, 31 Aug 2026 08:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788164880;
	bh=UDLOrEWk8s8P9NPs/hJ9ReKcQQKs4DBoKeRaLa6eCp4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CFigFzSXaYQh2+i8PwAo/W/QAkG/+QNSnIqgZ9uo6Z81XZPLznd8ZqutwbhR4DpQK
	 9kjtCiNQ3KnSwEBxI6ZijIBbLCjxEwXge/vi7LM/J0iLgdXtwg6rx+8Rc2FBmCOTyf
	 aSAnFL3rVGi88PgnzHO4Tt4XG4Zo8LByhZUhUAqvNBaS3UH0/Br64p8EBAYfyS1ywi
	 hykMJYf6b69ZxGswHh2qHgsLNdqp0XcZT/tBcEhyMw8BemGV26GLtUoMVrc1PVOwg6
	 IwcPobyIcnYYdgvmTsH6+qp22iSImRew9B4QAJqbH9ikBFYeSogG0srG6SPwZRu6JH
	 ftcvtOvQ09eCw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 31 Aug 2026 11:27:45 +0300
Subject: [PATCH v2 3/3] tty: hvcs: replace __get_free_page() with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-tty-v2-3-88cd58c3c640@kernel.org>
References: <20260831-tty-v2-0-88cd58c3c640@kernel.org>
In-Reply-To: <20260831-tty-v2-0-88cd58c3c640@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: kgy5xdnki34fx3f16cpoqdju8s36zf5n
X-Rspamd-Queue-Id: B5CC318000D
X-HE-Tag: 1788164880-667655
X-HE-Meta: U2FsdGVkX19oWoGYEGF9ATGYJBn3INUArzqAzKE5P+hcocRO3Lkns8aqVNoYR0lHAc1pPFTuN8CabfM4F8SFQ6ZCzkwZ73KZnEXUvDCOV/QZZPeVHwmwM4nhln0LihfL64Ib4XG95rVVyh5KQe5Api2tO6RTfanxOj4AlgwTrgC0KGTsSVGc4cqstDyjccKUBNnMSRYGbQImaGfvV6uHoM4CJk4GbvS8v43sMd8P2ZyAS/QFpLxaWKO63ePCATOF4atlt6LKLKSVzPUF6hL+jEvCZmClzhyRb/dXVTJZmy18tGNUhF2SgZ1Zp5ytjTjuA3gvJqC7cvsQ0UATCUZAXdNkkJdl2qwR+prCqzeVAT9j97jLVEiFSu/nsk2BeSxtkMFIs7Z826d1/p8sMl0D7mWR+A9X2QWUmRnWd2pINcv3cKaUewSCyGS3hw8yOYJqR/JdF4C2VrQGZTRkuFiAqWe6XdRFaElwJqnP+OLvPGalNs1P379krHOkoUer6rFyNHyfOsW0FMUnkLfWPdKvYAX9H8g/RXehNPOFdM+iEomHMzdTx//Hn6xT4m8nf7EL8s6sDC9EAB+nOu4/6BMxPG7up4ah5K4gYpmPdq71eyc6yu2gdHcz9Bs8+plYeeWERYEd1Zz2teehtQ3AcoPlDzmglvr2hj+4/sTw8RTWP6Z+wy95iyDxZMprjmma1XU7D0glKay1vHuoPfxny005tYzDhIt5muJCaS48q/YqN+QcPSaJB6dXyArZ8cbQI2A1HHx16lmQ994RhKy4tZvE+EOiETjenz13Lfe7v5VEyM24zofsaLUISzwqnodP9sPTjpAy0hp5AHzsDqaUv+HkUGCxQClVwhk1ycOqgfru/hCrRbIVigJ9jIUi4X9ySEP9mCazv9q2y443ubgPQZ7yPUgeANKKHZ7yF2nXTF1ifOGSfEqT0BtjWnhFdH5tzA9igOUnEipGXmGOqFiifTX
 NwFpvm3t
 B+IKhNBeh/wwinLkslI/DWmA4f5UPnP/Vl4I2Zx9090UidC3zx77FQxVIp4Vzy+bDnlQmQw7COCTpesNqP4VeVq3rwXNotgqYDWn9U3ezvoOwYmmQzoYbuNR36h+bKlTK5pM8xowW+NLM3XXjzpnRCWy3g3BNyvi5KH+ITzSl4rilK9IcyaA55Q0YTfZp/2LPkADwmmgI0eNtq4LPowZmSbpeJsLLC/WIanRgnEjBK0L3zuNxjsJrkJSBpACS2M8NgcnOfIT/KgKdR3jWMKhlVMjVTDqxAervnWkdRsFi84OSQ5aBtxRnW/bPMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hvcs_initialize() allocates the buffer that receives the partner info
returned by the H_VTERM_PARTNER_INFO hypercall. The buffer is passed to
the hypervisor as a physical address and it must not cross a page
boundary.

kmalloc() guarantees that a power of two sized allocation is aligned to
its size, so a PAGE_SIZE allocation is page aligned as well.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/tty/hvc/hvcs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index d32b1e3c50bfd..b94d59fa36274 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -1470,7 +1470,7 @@ static int hvcs_initialize(void)
 		goto register_fail;
 	}
 
-	hvcs_pi_buff = (unsigned long *) __get_free_page(GFP_KERNEL);
+	hvcs_pi_buff = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!hvcs_pi_buff) {
 		rc = -ENOMEM;
 		goto buff_alloc_fail;
@@ -1486,7 +1486,7 @@ static int hvcs_initialize(void)
 	return 0;
 
 kthread_fail:
-	free_page((unsigned long)hvcs_pi_buff);
+	kfree(hvcs_pi_buff);
 buff_alloc_fail:
 	tty_unregister_driver(hvcs_tty_driver);
 register_fail:
@@ -1528,7 +1528,7 @@ static void __exit hvcs_module_exit(void)
 	kthread_stop(hvcs_task);
 
 	spin_lock(&hvcs_pi_lock);
-	free_page((unsigned long)hvcs_pi_buff);
+	kfree(hvcs_pi_buff);
 	hvcs_pi_buff = NULL;
 	spin_unlock(&hvcs_pi_lock);
 

-- 
2.53.0


