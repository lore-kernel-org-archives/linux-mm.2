Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE1A0606A8A1
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 23:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NGjNS7Fq
Received: by kanga.kvack.org (Postfix)
	id 7FF256B05B1; Fri, 13 Nov 2026 18:52:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D6B06B05B2; Fri, 13 Nov 2026 18:52:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69F2A6B05B3; Fri, 13 Nov 2026 18:52:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 396BB6B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:52:42 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A17A880186
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:52:41 +0000 (UTC)
X-FDA: 85431748122.13.B8FD8C8
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id F0BB680003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:52:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NGjNS7Fq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794613960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qsdtOD00VR6ePwSdlnMVKGKaa+UhD0aTv2SSqisGmSc=;
	b=rQ7Edpdp/fk1IewGINNmPN5hxg1nqODM8DSHbGTLDx7KNqXNJeqFvqJX5e49sc1Pfb13nF
	TgVHWZdt++0PBufuskmNVV7RmfT84N/QMymtbCoKaC02pIgk/htBaXXikvpE+zeoxdKSJE
	G1XoAjY3vVLuETUNQa2A201q5cRUAmI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794613960;
	b=OwTEpPNsIzzn//FaCVeg8SdKjVRSk/E58zxT9dOucCPeY7jEAjQxErBc1e7VfrOs8ZCY0z
	LfnKYDym4a8zkDzhlm2vTSBCz3P/jqcOy4112cGUIrm+8/E5IqHvx0/7XuaECUNfTv/cH8
	mAK1U5KVHcuZWNeViYourn5D4owhrAM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NGjNS7Fq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6798eb0d190so1252758d50.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794613959; x=1795218759; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qsdtOD00VR6ePwSdlnMVKGKaa+UhD0aTv2SSqisGmSc=;
        b=NGjNS7FqZQ5W21WiN7K+nxLVeAdhKKj52hh8zj66X/Bcc/k4ATkZhpZO1pJM8OUuVF
         T45s/FIiVkB1ihkznNTqIzAw8dE5GNKCkhiknK6KcBF9apWbJXGKbR5jofV6PxKldoaw
         EEzSKZ95EwhBtkyHi3IJfvwblLDxdrJYnosek8ellyrf6/QnQTxMItNdw8FTNsUiIsxQ
         thk7omgczJQ7I84PFmgCBfXRaPt+kwI6MBtzL2ddx95Dbpjsa9hKHQHpejxHNykG7Gdh
         GfRCCKE1jE68ahqrcD7fgaAKM1ZfAF5AUKkzCvV+lH3YFUv3TpBVQKEPfL/t31BCZuKS
         H8qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794613959; x=1795218759;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qsdtOD00VR6ePwSdlnMVKGKaa+UhD0aTv2SSqisGmSc=;
        b=SsI5Ml9eG1kiZnRwZZBitWr1ZFg5yQbhhcNe9pNPB7QSKWWx1xmFCOP2I7NDn92MU0
         32PPf59Y222+KqM2EiYF7ULPKEYl5uBXioXFnw42Tiul3aKniPx6Z6LKPL61pnOX91qT
         BjHveA9hfU9gqDKLEAOp+eNhezu60gUGkOOITk6rAwD4gOQSXrladOZxPaFydQXFoOV3
         5N2O3luRiuNk1ZhfXCfWB1N8P1/CdMX3Wlg/IiAQwOcV/zIfmEDNNHubGPOjgNLEVwat
         IdO2HsMi7tMC4d4W55lTiJ3xIWb6oJAweBOVPQ7YytvA/pJ5atQGfx9v21EilX9EKYPv
         7m1g==
X-Forwarded-Encrypted: i=1; AL+hErETobx0574KxVOUGP8XrPueAgaVpsBWO/OPZIDYjyuhebGT29HUxxgOEGn5EkokPrVBQA9PIyZeTQ==@kvack.org
X-Gm-Message-State: APuU4Z82KFfEnX3ewbulJGE52Bo0IfwtA0x5LJuD6YN7q4dVTdoSJVg6
	YAY491wjdovorP1SOL97bdekvoQ2/5BPW4I/2dd4X0EGGs5rRT6jxes7
X-Gm-Gg: AYBFou3+DJnoyZ/RiVBsZjBUHUrzEFWjfTZlQH7lgV4lBV6Dq6N2Hr8huf3GrnAK7MF
	t/x7TZjJ8Wsdw/sAKH5ZZJsPZhp6T8AvWUiV/On5sZvft+D6fmUa5nzNpqwZCtGE42I1AhXMGBH
	62jfjz4RQpWIAm7WJWtewJMBzCnCixI4sa1mhCeuOCSaKoco+JXZdJ7k+EvrPdJ2XLCZnAXMStv
	Yu4xcQk+SjxQ4X3xk7OhZW79RckXyn+Wz8wFIlko3OGdE6/IaOSTju5w6CnZZjIWsNfcZJPOvTO
	WsKSm1BGhQfNeeqCDjgtkJ24El2yMY0bOzXMB1oBBefcvKhwZf/TsnpAVr+sT93vl1KMm4nCsBX
	T5euZXUs8PH8ZWWRLhcKFyDt2+hLydTwlOKjqyE2ZyPzgehnWbHCx/Hu3jUwMXfS1ZToRtnlh7y
	NuIvuCAuUgr9nEjXmXIl8nVqM8puz/+91pOu/VuLol63aY09j9DwBI2sY4qrGAawZexl+r+MHfH
	Aq+Dbihfs4brlHJrubYBBB9VIQZoPzsbb63LwlDH6+cR0+hp1FYW/+4LMKWVyFRHIgeODCVZhJO
	/Kh4eGyOMVVfV9bND01Wts/c3DBELq/qKopfjPq/ZnWSmcI/vmaHM9G/egIr
X-Received: by 2002:a05:690e:12cc:b0:674:1576:d1a0 with SMTP id 956f58d0204a3-67d8972abf1mr3144701d50.76.1794613959114;
        Fri, 13 Nov 2026 15:52:39 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:52::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67d8a5ea356sm3386767d50.17.2026.11.13.15.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 15:52:38 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 0/3] mm/page_alloc, vmscan: get_page_from_freelist cleanups
Date: Fri, 13 Nov 2026 15:52:33 -0800
Message-ID: <20261113235238.3595412-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ji1ffxadwb4rjq8igj3mud3w7t1ojfon
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F0BB680003
X-HE-Tag: 1794613959-300698
X-HE-Meta: U2FsdGVkX193TrVoh4qac9JIR7aQXgjTfbfpRuiqbwlNnMLC7r0FwekjHbOfd/HAIJi1AzQ068ULFulTUEf6khxJ1KLUqV9eESxo81poL0ryi8uQ7I1KIEJhKG/aOHCCR9gtx6ZzPgEvEbtiMa/B1w6gHnRxHlaECg+Isp6xC00c4hytimuPxfADmTN+UZJ0py3sIg0rk/xCThVj5ZpX9JJTpy001KvRNL/lBf5heBQ20R1znAT7rHmuHhK+sCHLez8li534Z2/AOkg6WarQystzCstm4tfjPO92hWahtp2rf35iEdY6rLpCGRPx5s8SHgHw44VzgPtCxSYDO95nLxLhvy63dm+7K77ayh055L0GAsN4GMT0MxV68BLziFJhmk0HDAwoAZ0owG3qANmQtTOSr+hOfnkgX7iRGcLkXchEYPX1asyy9Jlzt9cgDlW5uQXh2QOpqIONIqIj7xWiz6o7TNcd8p1dB5ZTafM86dPAEe3ha03BsHtmUJ6lQVWn2D7uMwX0uK2n6qVaPwZfzwROTUUOc7rObrBeDwMAKDS3VuSj/SVKZznyq3BxSb/grXnw57Vuad1xPeSnQf42PN1l7YMnTT0EJC0Brn8KHJkdGRvquVnPGHVuo7lrtYjA60BlUSf8lgF4JprDALSWKHzV/ArLUGxLf4mVdfnSv3CBgXctmrbrQ76nARRD4zqGevuVYfR40rnk4dviSt0pLlVA97w+3kHLU4EGPEwHGgW3KkIDGEnSKsSBWHfWlhYwJTXvZ01lf4eCLX1oTtaMCiBKxcVS8WjEiIigmeQ3+jYFX/f0TG2HmBO6pxtiqcZyZW4nx3ZV1iO3VWOWF24eUGN6dfhLOuJqrBladZrEM11x3fKS1bsdVxBV11+G/BJmqfo5oIT4Y8u9y0mMoQ/KCb2G76N6DZmZ/4NFMxhHwY9V9tCQypBnMZHu/BBYvrQElcALcd6bBif/VL7rKko
 5/dX9M7a
 qIN5i+rf1bcFQMCdIWWOYwh1o1q6OdRYCI/0OtBvCAonwaZL77UJyOwpv5rACkwzXURN0db4bga7A/aUFIAXvotdIcoKkY5+jZRJUa4jtQ3ap021qmcSE9Mn1YMC2pwVW4QgO+zpZoyII6ZKBEHbdGyhg5XdAPp9hm+NeRoHfw6gCGLjSK1koKf2m2JTE6TW+KUGwUYCYxFnXUyX5mV11uDS+y4NCA4S2Ejs/1VGe0N36dPiNv14XMcWLLyi2XLMWvRd2oRSJIyDbSUQSuBd64+HiMcTz7vW55nx3DRbgDzj9njf2GtKNw+GXn5GuoM2EfUZ7nCb7XD0xQpRG27VW+qy6sdHvJp4xzoUKgB1cuXyRLtTG0Mycprp5/ul2HjXP0i3+BaqJVhMyqcI/5URXhjnKNxHpVPo879aMg64lw3BKy+8Z9q0s4JP8A0Vv0Wb1ORROmRI0M5PiVljGOjbdBqiX9K5pPBsCOC0ra3vtyeD0B09I5dqpch0wrPuQRDDoDZf/uJ3irrvXxB1ZvcsF+6GE6fGUBRu2ACz9J2ziHMGk5+PzpZ/Gefgea/OI1RDAU92o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

3 cleanups for vmscan and page_alloc code. The primary goal is to make
get_page_from_freelist a bit easier to read, especially after the new
kswapd zone skip conditions [1].

1/3 is just a nice cleanup that I found along the way.

Based on the latest page_alloc/for-next branch as of 11/13/2026.
Notably, there is a dependency on the aforementioned kswapd zone skip,
677dfdfad244a "mm/page_alloc: only skip kswapd nodes below their kswapd
watermark".

No functional changes intended.

[1] https://lore.kernel.org/all/CAN+CAwNsqWpPoag_XE6bxbrfi6m71xw1NS_wc3h_ShZjNspSjg@mail.gmail.com/

Joshua Hahn (3):
  mm/page_alloc: drop unused gfp_mask from zone_watermark_fast()
  mm/page_alloc: move the kswapd node skip check into a helper
  mm/vmscan: consolidate promo vs. high watermark checks

 mm/internal.h   |  1 +
 mm/page_alloc.c | 52 +++++++++++++++++++++++++------------------------
 mm/vmscan.c     | 22 ++++++++++++---------
 3 files changed, 41 insertions(+), 34 deletions(-)

base-commit: 3a99594e62fce8c646e8aac01d38af16d6833a40
-- 
2.53.1-Meta


