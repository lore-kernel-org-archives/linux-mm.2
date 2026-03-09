Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0649F41807
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EB316B0088; Mon,  9 Mar 2026 11:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B61E6B0089; Mon,  9 Mar 2026 11:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CCB16B008C; Mon,  9 Mar 2026 11:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE4A6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:08:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C18C75739A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:08:32 +0000 (UTC)
X-FDA: 84526856064.24.50D152D
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7D5D54000A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:08:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XscvnJC7;
	spf=pass (imf01.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773068910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mjuuwRMRXMuBEkBAokG0kVZoWPUDTpeuLcxt/9gKsig=;
	b=VwZmku477sxDZgCidWqfWUxNc7D/ApyR0Htqvb3LapA1BMZvbMb7TCduZCgxbNy44ERzzP
	B5elZ+YQGkAEQ5rD7xi8BKq6wtEgWu9hUQtjGJXZxtceaqjbAJPfqHmaSWuedzkdhYIn9+
	VMnvpUQozdwVITZhdQK8ghDz26m1vjo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773068910; a=rsa-sha256;
	cv=none;
	b=phsDg/bZDrOXMq2Gii4F2PaQXe/+8MyOgCNSuZmdG/2dgO64kQB9CUqLvr9sEGAUvRsI/T
	SqdLT2ya46l/mDzOb9tC6E45QeDsnL7ApzJWwME+29xeecnr1yTGnR+kI7A7LPwi/RHIuM
	rYaMWWJH1U0dE4wM2LhlKzaHdvwoWLo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XscvnJC7;
	spf=pass (imf01.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48540355459so5340375e9.3
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 08:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773068909; x=1773673709; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mjuuwRMRXMuBEkBAokG0kVZoWPUDTpeuLcxt/9gKsig=;
        b=XscvnJC7k9OnomiCvfD/aji3paKJTQ4DSYV0rkEvOXOzVausrAa55/ry0hJgvDPJpB
         Mgq68ZnTOuoyiBlY/PIU2pPD9Vc9PiCzmnhGzJ3zNeGAJPeqjWkDckTLHwAJibXhI3QC
         XwyzFM7aI/r6lpynT1gzdPcrLGw/m2fDOzOm5taWJA9sR3Em/uGh2WVJGugTtszLKq2P
         ZLdAPtH2BJ9StvLZwA4jZJnkrh/7I6bm/uu4yo6DSQ5ln9hHsywbNBug3PrKE5CUjWSI
         DB2U8BsxIDAHA2XXxcd4cxenDZDvGO5gXWFxqGFnUa3bhMMjFTdqM5oz+sJsyVn2Zdu3
         To5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773068909; x=1773673709;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mjuuwRMRXMuBEkBAokG0kVZoWPUDTpeuLcxt/9gKsig=;
        b=RCR76kfMGe7XMPSjgwnIxCrVcbN7cPuMIsvn91VRqTS9+Fw5nxrkh9jTTvNQG0mswq
         bX4/df1MFXcp/Gutw3R4mhmuKsFua8YStZI4sf57TXaIKmPodpESDjlaP4J9oP3/CKmu
         YUvoj+C9lCO7V7CCBXyXtje8pJw5pg2V1TaNFmXbZKF63N7ANxZoqEp11948hn7roc8D
         aiYf6P+JBh45WQeBQDfrbfHHmGhigRWDZnvebfDsajT6GAdWijGqng/rpMFcYbLaBqih
         VzkfNGPCvuziFKKIIOoboQcrNA5lS/hs1rFlMmD8z73rlIhFLvnpbH9yOG9x0WlQZEJj
         inLg==
X-Forwarded-Encrypted: i=1; AJvYcCUjct2wRilyqg9eZ0vufBmlzggXiDJjiVGhWDcrJGY1BOmhobk9R5t+UJXGmAjefawIWMfLUTDY4g==@kvack.org
X-Gm-Message-State: AOJu0Yy/Z0zZm6D78inShsg+i+s3IImlI7iotFno82G2mAdLlyVhWJaK
	MyYccT2XlLUwWNYmT60bMGlITD1x99yzc8zuy5JBoCY0JMsZ/efLFtKP7ZBnUSpIPbwEsjmnugI
	0krvO
X-Gm-Gg: ATEYQzyUdFomYu0/vxxC+fmc9PlYoeX/mv4zItBC9y2lnPE+DMKLaZfc0gsofFQu/Xl
	KxUoorj/8Kf3RxtC9uqu+uYVTa1QyfcQMuRi9s51fXy4hyeI6zVn3FdumMuCMiJdINCQRLJJUrr
	aJvNrevy6+J4j7xoBP+8crvhKD+UfDL0QNevS4mRpK0yjf8cooXxw8btuu5P026doIg5Lm+DSJB
	klyVXAqeeArGD2rJUG/ReM0E8iaT2vhXG8PTo7K4J71Vzl/m/WruO1U+6ZmQQ4ydMVQzR0mehLF
	KLjftwVnjyr2JreeUUUAeh6naqnX+KSNiOqOQID7B8C6/hBaJqOutjxZQh6EoXJP1/AsLnF4D3O
	wAJz2NYzPr3gtZ4efhCIgR5P9Xa7IAAeWqbFmijCztIJUSX44uCT2LMC2pI29JKR4VtWytzRVgk
	gxG63kQbI2AH4gZzDw3mllyZ928KrOtnTnS1zEcDrNJ6c=
X-Received: by 2002:a05:600c:6306:b0:485:40ed:2d1 with SMTP id 5b1f17b1804b1-48540ed03fdmr14531205e9.17.1773068908685;
        Mon, 09 Mar 2026 08:08:28 -0700 (PDT)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dad8da01sm28684927f8f.1.2026.03.09.08.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 08:08:28 -0700 (PDT)
From: =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Date: Mon, 09 Mar 2026 16:08:08 +0100
Subject: [PATCH v2] mm: Do not allocate shrinker info with
 cgroup.memory=nokmem
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260309-cgroup-ml-nokmem-shrinker-v2-1-3e7a7eefb6c9@suse.com>
X-B4-Tracking: v=1; b=H4sIAFfirmkC/42NTQ6CMBBGr0Jm7RgYfwBX3sOwgHYKE2xLWiEaw
 t2tnMDl+5LvvRUiB+EIt2yFwItE8S4BHTJQQ+t6RtGJgXK65kQXVH3w84T2ic6Pli3GIYgbOWC
 p2zOZTpnKEKT/FNjIe3c/msSDxJcPnz21FL/1H+tSYIG6zE9VXXc6Je5xjnxU3kKzbdsXp5Wol
 sEAAAA=
X-Change-ID: 20260225-cgroup-ml-nokmem-shrinker-7da42fbcf8f2
To: Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2455; i=mkoutny@suse.com;
 h=from:subject:message-id; bh=PF7PEPuBVFEev9rRlZplgRHqFt2dHhMGKiCN80nPSv0=;
 b=owGbwMvMwCVWZ8v0fMrtHxyMp9WSGDLXPUo7IhO6X+rd1bAl3syOVw64fv6zKWBh/qo13sXl2
 6vcH/y075jIwiDGxWAppsjiJJzHOv+DjJvl6a4vMHNYmUCGSIs0MAABCwNfbmJeqZGOkZ6ptqGe
 IZChY8TAxSkAU11jzvCH33/risv7sgOdm590TbQulDR4aWJVzntyxapwKVtTtrQ1jAxnmvhWXne
 JPlO8YcG3+bcyo89Fl7ryq23ZtJlH+uLaR1XMAA==
X-Developer-Key: i=mkoutny@suse.com; a=openpgp;
 fpr=9F2AB6F1F2BBEE7621C1B620CFDED9A2FD1314F0
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D5D54000A
X-Stat-Signature: pnyzq9ahmykodg1oedc6q5n66amks7n4
X-HE-Tag: 1773068910-905144
X-HE-Meta: U2FsdGVkX1+qljSjQA5HfFwXPSBYTx3HBUg8CXpj/x1RCJSZCPAdcASdqc3zB6Mhk4B3NNTbt5DVLc96x334HiB6yM7R+xp3GUS8VjlD2F9rNRdlglbOkZarhFGcFQaPWBUTEveX9zWeNbsCMlj9x6/YqDc3uCvd1q2mWV9QOKWA6fsJ4mY49uJuZ6ScRkUrFq0YdW64sXdTAfLJoKYrYewhtztqDkAYMMjb2wwFVlDOS8KM1T2d9/XNdwhvr+2SkFMJ7XMJ1YlSQGDbQ5ST6LAnxq3NO6KssYliuAARKc6Aj2WLF6ym57U2Yl3bQJZgdXQUVj75IZkkOAZ/AGN1NqUAJKwFEyOF08VCncAuh2NgkKAny3HkN649GaskMmtMlBh8YBZTdFba3np7nZW54tBSgridg1OChXz0C6Ud9gQSjfX7d0H4IUB6CIfIVm47UcNxy8FqSyOLmp8S3bsT7d4xEPTzHi+oBMMM+0npawZAoy3C9e2D6Q4q4TWjz/9qGuQhfccOsl+082xb9uXugG+5Ptw0StXfl69pvBYfx/DUEuqHFeRWm2DNZBYvSguRARJ9GmcYHYUv4VPrQnerXOutuMRYS4IxRih/G2Rsd0gOjCb4m83QLSm7HiULWL0twICBUvZQCgK2wzJqFrJBB/n+GrVPI8RW/KVSxPFJfLQiw3h9gKi1VbzpKQ3Q8fP8IiwD9Pmkj3YGT0ZWhjvfmgKeHH1hFXDxQfWwNegYnAgnyb4ZYYNFzdSBbuqFW4bf7NiK9CpORm3ZMhKUzn2m7/CIIWVs2t6MXSd1wjGKNp0jQQMoAWjpTZhQc97XFiuyHaa/vdt4xAiuY5dAh4+SH+UT2sI+DMLQgyLSk66ciPw9ZApLCbsr5BbVKn7DsNlKSDPOYG3Fd8aUdbJ2IC4SZB8Aw82v0VerMkiYUttbLigPjBNUeyH0xl9x7RwHMLtoeHWkAV5oTVvxsKaVpqL
 1QHGJnCe
 vYmEeBnCSNBg8G9YQiMHfWihL3KPFseKMcusPO1ifc/SJTUKfqlE2jmnG4rcF8XVPYB38jUHMZpiUAA0UtuOnq6KHoan7/TkoPhdFPWdzUmVjT6nmJYb3ulRxcGu+oi4uGVznAkYlHPTf34IfiYgNap/aHmKpdI0HuqxTdJVgbbwWuddDHHSg94rgim6eG4tg/o+6QSRmaNTAdvb9L5sr2deJ7ubju79XUL+9lDnMFLRq3MIdFU1/vfgn6DqnVwNd+OMsCi7RLCA5ahVpnWRd7SYIac6A/a/3dDBYTAS486B/7EJ3DbJDd7CMb4taMY/WfLSuQktySse4KsfRDX39zXHj3w36PtisDvF0zWV+knF+NcmK8/vwGjsS52Z2R1LMCTITNVTaYog2UPKpAnTdbPPBOwwE7qc4rHfj4O1cPhPAsnBDPf7c4rizvC65/T4f9I/MEjnoNJHQMkR/2Jaez2lgf00LAh95lAx4WosxmE4VXAwQYtVuvJZzk9xfB2klFjoeYuPBfkfrfGo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There'd be no work for memcg-aware shrinkers when kernel memory is not
accounted per cgroup, so we can skip allocating per memcg shrinker data.
This saves some memory, avoids holding shrinker_mutex with O(nr_memcgs)
and saves work in shrink_slab_memcg().

Then there are SHRINKER_NONSLAB shrinkers which handle non-kernel memory
so nokmem should not disable their per-memcg behavior. Such shrinkers
(e.g.  deferred_split_shrinker) still need access to per-memcg data (see
also commit 0a432dcbeb32e ("mm: shrinker: make shrinker not depend on
memcg kmem")).

The savings with this patch come on container hosts that create many
superblocks (each with own shrinker) but tracking and processing
per-memcg data is pointless with nokmem (shrink_slab_memcg() is
partially guarded with !memcg_kmem_online already).

The patch uses "boottime" predicate mem_cgroup_kmem_disabled() (not
memcg_kmem_online()) to avoid mistakenly un-MEMCG_AWARE-ing shrinkers
registered before first non-root memcg is mkdir'd.

Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Michal Koutný <mkoutny@suse.com>
---
Changes in v2:
- update comment (Qi)
- collect trailers
- rebase on master
- Link to v1: https://lore.kernel.org/r/20260225-cgroup-ml-nokmem-shrinker-v1-1-d703899bdda4@suse.com
---
 mm/shrinker.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index 7b61fc0ee78fb..167cd70ae4918 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -219,6 +219,8 @@ static int shrinker_memcg_alloc(struct shrinker *shrinker)
 
 	if (mem_cgroup_disabled())
 		return -ENOSYS;
+	if (mem_cgroup_kmem_disabled() && !(shrinker->flags & SHRINKER_NONSLAB))
+		return -ENOSYS;
 
 	mutex_lock(&shrinker_mutex);
 	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
@@ -716,6 +718,7 @@ struct shrinker *shrinker_alloc(unsigned int flags, const char *fmt, ...)
 	 *  - non-memcg-aware shrinkers
 	 *  - !CONFIG_MEMCG
 	 *  - memcg is disabled by kernel command line
+	 *  - non-slab shrinkers: when memcg kmem is disabled
 	 */
 	size = sizeof(*shrinker->nr_deferred);
 	if (flags & SHRINKER_NUMA_AWARE)

---
base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
change-id: 20260225-cgroup-ml-nokmem-shrinker-7da42fbcf8f2

Best regards,
-- 
Michal Koutný <mkoutny@suse.com>


