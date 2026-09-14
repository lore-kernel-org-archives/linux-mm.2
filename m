Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A89EFC88E65
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 03:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 555906B008C; Sun, 13 Sep 2026 23:34:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DE496B0092; Sun, 13 Sep 2026 23:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F57F6B0093; Sun, 13 Sep 2026 23:34:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 111646B008C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:34:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83967140F7B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:34:15 +0000 (UTC)
X-FDA: 85210949670.23.42901A9
Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	by imf23.hostedemail.com (Postfix) with ESMTP id 52181140008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:34:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=frhkQO5L;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=frhkQO5L;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789356853;
	b=CRhUZRrYANiXQDoMyVcjr56vQfg8DvQ4OV+es5b4QwKRw89ymIJYd6Y4rIulvkSAKH9k0Y
	6hC6pXlNzU7Blsb/+r5G9cVa9ocM0LneJq2qe3yF5YZ1QYyOo9VJxT8g1bYkdxTUmq3GTt
	3isOwft4vehYMdg3axumh97uUtlcakQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789356853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i0olC3sddbUYH4r4fEmZAnViCYxNOnstF/A7G/8yUnU=;
	b=DfsWAmcmsnuKA1DFd6ojLVF+OyaTbccc2lT+trcfzjJsgy/XogvfFfxlGtWuKTbV1sMqQI
	mMbmluXLXwPPw1qYoHtHtM+qUS0h2uW7u92L3rSGG5PC+uVlItwx1L0VEK4Ay4zNhuigbB
	kZfdF6lSxi1uLLp0K9p2C1HxkKKryEA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0ZUsP0LswRkkip9tShGsyYFmjM0FkrhaBvJDLod4oH4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789356851; v=1; x=1789961651;
 b=frhkQO5LtdWunzsKyZlnoLMs62oBHjdMfCTPAklKUW5P9QGe1PVHKCnRQ3OpsYzBIJIX3VT3
 1SHlrmu4hxM7kWsm1SwvExnH9b4UderxbW9qC/bHHvrByOJnXBVEQ/5oQsBurL1fJI6OYtz96qN
 2Ik8uet51XreKvmvdSPAwpNI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 57ee228aeb5f01e7;
	Mon, 14 Sep 2026 03:34:11 +0000
X-Mizu-Trace-ID: 57ee228aeb5f01e7
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Mon, 14 Sep 2026 11:34:00 +0800
Subject: [PATCH 1/3] mm/vmalloc: group xa_init with vbq field
 initializations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-vmalloc_study-v1-1-526f68559706@linux.dev>
References: <20260914-vmalloc_study-v1-0-526f68559706@linux.dev>
In-Reply-To: <20260914-vmalloc_study-v1-0-526f68559706@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Queue-Id: 52181140008
X-Stat-Signature: m65hs5mxj5b5p3iboit5ekw61rbxeofp
X-Rspamd-Server: rspam01
X-HE-Tag: 1789356853-130451
X-HE-Meta: U2FsdGVkX183P59/dJzsj4e3ifrBCQapNt6am/xF0rLOKu+jgXDlR1tKQXfxsgWchSZfqVBlV13eGKcDM1seVZfunTY5cXShRMGduSWdoGv3NE7GVVhOXl1O71kqHQ3zs2vca1UqFA0w1/pMZpQ0fQWgrxhb+0RNx+zxQZEIvL+X4fvLdBu/nhmxOtVRjS2dDs4ZjHjW/HL2yXyS0c+kuBZATrqINa4HlR+tgReUHSVaBFsrBiMBERmiZ/bZ00xx3/iYgrfU6n/kROtW4h4wRALl7/Kg062umR4f5u62t1aCApoLFRKTqg77TGf1CSC3j1KEA7vSZ9iuN3C8Aq1lFECayIDw52Ol3Bs+vkEXM6ZWZykE7seUV9noeHrwHMYFiOhdz4CwFLGiM3obQonObcaTHMJmab6zoO5fC0bq45AF058Gwj6RQ/kCqTrRyeOjlQmWYwdGLBOV6pVQpV5cEv9+PyiR3iNfMLnLZpzaibwCG2oWQBVUPAuVOgcILa6ARmu3tHzFUkEkb6IM9jBU3Dee+1rhaonAgxAN3QEyS4ef6r1On9T3gGWuNkLWUAAdVMdUJ+MJugy3EM5DuMrhxRC3X2Oy7EduQnbqxn3m/cOVopA/65QMKoWpXVLnEmnEKKbUJ2l70U4nDfDa1IhSc2C0LdsY3IrxBl7s9M1JNjlq/Awvf3iMdYtU69+FoqKWllJvN01+FByP6p3HyOgtTaFkGlChRYTfkt99oS/1ZUSglj8/P5Km+vbKBXJwy1FLGpkyFvxkwBClaSKRsQY3r9HHiEhY1q+N+w8mLMQq1v9FlLIxpn2L6n5BDfkRd89d80oJsqcBmKR0CLuBIGf4JYanpcCFkGyZTQf1PUjhEL1oRqWTjSPU8mjATP9Qvfz978rD66Qn1nsY1YmIC8RUN+dmYz9of56eU0VxQ4HLt1O3ECRfxP8SX305B8ATYG2pGCzImiYApRbkeT3Dqs6
 AjI7+BEZ
 07RimSkxifIbY9xNm3bYp+Ot39tJdFuoSZfz3tHIpMTNf6WvonqnO2wyb/M/oC2VZHmkoz66gQJw3sZFGsaGasn0G6BWPeC63v2LeBVrFhV4DC+bR0XaRBpuISzhi9jvK4PK2srhdECvWkmLMz3BnJTYIGyN8Sji1JIygaJ06aQoBXM1yn8ySu1Wxo+Gx11YBHGxfyobAvb+IbE37jkU4WdTUs8smYCfNyZsmS/gAjaTm8pxOl/3U3zGYFvQUg02AE8ZsCmkobofxzB5beI7u9vYNdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Move xa_init() next to the other vbq field initializations instead of
after the unrelated vfree_deferred setup.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/vmalloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 859e6d2d57a3..117483dd048c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5585,10 +5585,11 @@ void __init vmalloc_init(void)
 		vbq = &per_cpu(vmap_block_queue, i);
 		spin_lock_init(&vbq->lock);
 		INIT_LIST_HEAD(&vbq->free);
+		xa_init(&vbq->vmap_blocks);
+
 		p = &per_cpu(vfree_deferred, i);
 		init_llist_head(&p->list);
 		INIT_WORK(&p->wq, delayed_vfree_work);
-		xa_init(&vbq->vmap_blocks);
 	}
 
 	/*

-- 
2.25.1


