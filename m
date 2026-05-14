Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF9A3CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 16:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6176B6B0093; Thu, 14 May 2026 12:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EEDD6B0096; Thu, 14 May 2026 12:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52C4D6B0098; Thu, 14 May 2026 12:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4079F6B0093
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:00:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7792C20D0
	for <linux-mm@kvack.org>; Thu, 14 May 2026 16:00:12 +0000 (UTC)
X-FDA: 84766487064.13.B5E4C4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 04D1F40012
	for <linux-mm@kvack.org>; Thu, 14 May 2026 16:00:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BOO8mr+K;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778774411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=29c0cX5HMt8AmpUVJYpmIi9tIJNOHtDanl73N5eTX/M=;
	b=qx8hSIpdhaJhC5uAzq80qQRPyssmFhChXxtXnKDTjPtM9Bum5eaQCIYLkf8/Uh3sX0ro2n
	nALTSpvDNAoSrZYmLR+woM/MLq0npVhUKUEUrUxFkzz2NqkxAv880itZ86n/6yrDQndnkA
	idf1hGrzORd+K32miUdRcuuQODmb7rg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BOO8mr+K;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778774411; a=rsa-sha256;
	cv=none;
	b=GMKKr0aaKfVRhDtYfsZoHe0zEW4WcA5BNyFgmm6u0MF0mBaVUR11wR5Hg1m6rAbOQ85z2u
	x/P4N2MPLjCvCfVFL00EcJJ4Az0M5MYvP6JOrrvfSkCn0qBsltz1u6cTNGQ7IORBPlNff0
	H+6GsUePM+JHMlcm974sfe0GBVNRE8s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 43F6260139;
	Thu, 14 May 2026 16:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18F9C2BCB3;
	Thu, 14 May 2026 16:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778774410;
	bh=y2mTi9xPIPosO+HuxrzTRbnF1NgRnzpHJowd/IMQlyQ=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=BOO8mr+KXgLD5vOFopSdSqQmPVPMqQixeSWn9ammwAxW10qXGrLRzOvCc53rBbFDk
	 yiEtT172Lvfllx1jQJbtEjdxQutXpK6P5tm3ZJf6JoQfIxrWABiH0ajqRfoxCbThvl
	 aE5KqK0Rxn2+YMJeqJYgX5QcUJ9yqm5tb5PVCXy1y5q/7rkHJjMw0sg3ypOCCIeEs8
	 YAKECPLIOb8v97UHaVEzoVqZW2gyo/WOuVlOp22Ay9cWqwx0OHMUd9lz7YW3JnaD2J
	 9d9txktlBFl/XJMSg4sa1GvdZ2t7TYO4PIomKmOweW3jeX/+qZCyD6GQxn+1QHQL2d
	 /xEaFbsOx7UIg==
Message-ID: <eda98e7b-67fd-4a36-9d39-3de26827599b@kernel.org>
Date: Thu, 14 May 2026 18:00:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [mm, slab] 298cdbf5f7:
 will-it-scale.per_process_ops 6.3% regression
Content-Language: en-US
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
To: kernel test robot <oliver.sang@intel.com>,
 "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, Hao Li <hao.li@linux.dev>,
 linux-mm@kvack.org
References: <202605112204.9382cecf-lkp@intel.com>
 <90bf195e-45fb-423c-b686-49be9cadbd11@kernel.org>
In-Reply-To: <90bf195e-45fb-423c-b686-49be9cadbd11@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 04D1F40012
X-Stat-Signature: md9oskt3ysrba85dcaj6xkbztxpjxnrf
X-HE-Tag: 1778774410-783471
X-HE-Meta: U2FsdGVkX19GtnooqNXtb/nsiOmZeNdAlztTF0M+FYbSxOaHUA8h+ugSNoyOq4r4HPZtfhKGlxlgFAiFVCju9bbMt+Y56+GuAmI7FDN7z9rtDD0ZwAXJkRPmzsuCByLmbofOVyenpYCJPT5P7PUOOvnSiK3pk3RGtWYmAuP81AJAd6B5MIBINYVAhQRmj1IDTHeaM1P/EaUu9qhrsaOSML0NYRrpY7YOBz9N9LyzgcC2uzsluxT4ztBY2O5PwQLJpGQqGJ5prveMlvGvHpYgI+4wHSLAStnBHFbKe4u5UgvSyj/MKSozEs5Y+UfX/zQGygBBDnQdtUP8Aqun/GPOora5uzGnaAlzCY6PZ4RIyzH5R5q/aipIsV7/IEcdZ1G2dP4JORqgPRFl3qKVMq7GOdDOky7UtMr4Cx8WBRf2Me8K+Cm1w+4gzGlDB3WQRC+P1GQzeq76Sm0wXVVjna6PfyBqyUkZZlZFS4kHTuZFcE3iPGzH4QnPol8vPNeX2rKi1JPLAW8WMOei1WqdPnkvKdBPwrdJnQnE9J6Qtf+1WgxIAdrZOkIbY78I+SP1t5spvg1sOYc1lDqBx/pJDD3zTp5aS9wqpjjW7zvmtbfh5m0fkq48aALlNeWlDPyvBzmXJwl4aRBWlznxsnM9I3dV7cgsi3sUpueHbdi9bhLStc4Vrc8qlBcrdErUi1xjG3vzpujnPZTUqZ9fNsjyE7PUPWYb6eFKDfAkjtH0+1X+hnBiNVQv/1OW6bIjOpgD5ROpe6rQ4g+TiFsyojQuW0A+RxwPttqBMERm1iuA0wWpGIG/ptRGT/5+g5FYABmcwT6GyKrRdLtcf1MIzvxdEOehPFDi4bujbUuEWqdYjaveBhDxdgfPFvAzDWrxj+C9KIr8puGbdyH3Uj/1WuK874k1EWRJbZMs2Y5AQ0iwO9ykIOInQMWsP/o6e/hOYUUYpvaQo4I0VkREEVy6UJ2qOW+
 sYa+jKQ/
 lvMzk+/aROv3pBUCYzAXFJSU8AdsWQ0tbS67wbqxRAt/bIaWFSsr1KnuhoLyWINgLKyfXzNKXp8W2aFTO3pA3maBkP2KHII64aVzgGx5XXaGLugEChrmimFrnre8/bH2PFB/1pOP09U+SfUj4iwev1chp5uyGNDMAFcXFjDfnYNYD1kKesfHubO0J8SMZZjRn6MAKyFFq6o4kQq474u0V3lW/xf+vZBl9xNfYEinP1lDAxY38t37cXzHTGXoJUdoDZqzW6zcEuvkTaXNAm1aG68H7HA44bMOXL7i+hVWUSIl7IK9HaJpjvEexZ1g4iVErVHe7t71gvmBR/+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/14/26 16:45, Vlastimil Babka (SUSE) wrote:
> On 5/11/26 16:45, kernel test robot wrote:
>> 
>> 
>> Hello,
>> 
>> kernel test robot noticed a 6.3% regression of will-it-scale.per_process_ops on:
> 
> Yay for an optimization that was supposed to have no tradeoffs :)

Does this help? I don't expect much, but perhaps...

- list_empty(&pc.slabs) is no longer unlikely when it can likely have a slab
where we returned part of the freelist
- let's ignore s->min_partial when returning slabs, we just pulled them from
the list, it's unlikely there are too many free slabs, and unlikely we have
free slabs to return. Maybe it will reduce the page alloc/frees and the code
is simpler

From 761946747d53b880855ac1e795ae0627be416c3e Mon Sep 17 00:00:00 2001
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Thu, 14 May 2026 17:55:31 +0200
Subject: [PATCH] mm, slab: simplify __refill_objects_node

---
 mm/slub.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 5d867349912b..0cc6c88f11e3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7187,26 +7187,16 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 			break;
 	}
 
-	if (unlikely(!list_empty(&pc.slabs))) {
+	if (!list_empty(&pc.slabs)) {
 		spin_lock_irqsave(&n->list_lock, flags);
 
 		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
 
-			if (unlikely(!slab->inuse && n->nr_partial >= s->min_partial))
-				continue;
-
 			list_del(&slab->slab_list);
 			add_partial(n, slab, ADD_TO_HEAD);
 		}
 
 		spin_unlock_irqrestore(&n->list_lock, flags);
-
-		/* any slabs left are completely free and for discard */
-		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
-
-			list_del(&slab->slab_list);
-			discard_slab(s, slab);
-		}
 	}
 
 	return refilled;
-- 
2.54.0



