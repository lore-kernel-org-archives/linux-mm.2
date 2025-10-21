Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02C10CCD1AB
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 13:00:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00B78E0037; Tue, 21 Oct 2025 09:00:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8A3C8E002F; Tue, 21 Oct 2025 09:00:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B51BA8E0037; Tue, 21 Oct 2025 09:00:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC188E002F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:00:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7201E1A04C2
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:00:07 +0000 (UTC)
X-FDA: 84022129254.29.7B2AF0E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 42C8612000A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:00:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X2/Qt5Jd";
	spf=pass (imf29.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mx8PDzlnYvvbZ0yUyMmWAvQGgV0mnv7F+nCFHBKHb98=;
	b=lIb9uP91SZnXBA8lbNpCPLTNWnKgEJyuI5R1zZAYwiBSYPj2k94TVwpJ5PVh2fDex5NqqK
	4wwcSbY730mvc4pf47al0aW5rwla+PS+jmqS1yABZD3Q1L84Cd6tBvXtcAhBZuzp88PKc8
	tSpZkcocM+eo4xOVZ1IszR87E5Cwfv0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X2/Qt5Jd";
	spf=pass (imf29.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051605; a=rsa-sha256;
	cv=none;
	b=szpTVOcvjelnE2szvKiiLiSVz/LQz/9WwFlipZ+cjfrvUjcPvb56LpfOe/dwPWd9/APH5c
	lHQdZ/Nypz7oOXafo5zKN3BBE8fylLrdbVe7zKbCWd+My7uJ3C5qR753uVaKYmQv7RDBGq
	D6GslfModVawwCSclBwa20Y++zUrSJ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761051604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mx8PDzlnYvvbZ0yUyMmWAvQGgV0mnv7F+nCFHBKHb98=;
	b=X2/Qt5Jd3SK/wlavqeFpoXhG9OjgmmbKCd1oR7s1fJ93UBxJFDV9pHDUfnrxWYX/hD5Azg
	GPzVBWUSyEYft58iLLlk8yXdaRLLgqadlg/u9bA9hlZUgh9IFzjeihl3IqLFc+iy+1bGtD
	DfBUeZegGLkhv4PPN+tJNqRx2iNPe6c=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-9PHD67kCMT69qmnNk1hQHg-1; Tue, 21 Oct 2025 09:00:03 -0400
X-MC-Unique: 9PHD67kCMT69qmnNk1hQHg-1
X-Mimecast-MFC-AGG-ID: 9PHD67kCMT69qmnNk1hQHg_1761051602
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-427060bc12dso5744538f8f.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:00:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761051602; x=1761656402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mx8PDzlnYvvbZ0yUyMmWAvQGgV0mnv7F+nCFHBKHb98=;
        b=Fe3FGlSYHkVGn0bGw5W7/0y1zyXS0v71jjJN223yLmLoPD+ptnt3/UkIm6Ma6mrfaE
         jybRDKiCwpy1zPFhvfjDJ3CZtwdFuOIyYkH8pi8yh6Yk7jO+hwfisLbI55AlsGc+cQoh
         H6V8XIuWembXjK42TjuMi/o98saLbvF/OCXEbKeRSywNx6ZEY/uAVXAuKBSvMiZqSMWa
         PXqr0mdWxeG1Sl36wFyVkxEuAWFbR4FOoheRu8ERNykFskVCeAU4T1z0fNsm5tjgoIvr
         7/WvfrfJrLNiD5rbfbwTfXhMjhnTUF9HFZ6kjImfk4+wZhkdUtV6FsIH9ICDboDXf0pH
         wllQ==
X-Gm-Message-State: AOJu0Yw4L/cNu85Yg3v/NJWIrRU04MEnO72kYshVUcQXwyiJ/319d3wM
	ZLfqMb/owrw3TuX3pk0f08Dm9SYqUFKGbCutpuUcM67oRXujlW++KyTfOpOqU3VSyFYKnSBLMDh
	qsvib1Hy3T8I7EF8zR22NNutZih9UFcKedTKPKeGDnrcTnYaf2HmP
X-Gm-Gg: ASbGncti4YB4xOiJWX2TxyhRX7VTsmbgQ0E4J9VSKWADnK2ulFFBZwFq0gwqYX6afag
	hT+e5eOMyi6gieG3deKxT93dSxpWoUgJhDMHuuKtMG9rkxb8YTmxFzp8cAFKap2m0gxLHW5Z1hU
	y7NtZQPlxh1mEsYTw/Tmt4XkypP4lZ9+Ixuuq+k1CG0NzLZleHfxFTARR62rkcwkiGHvyPnYdle
	I8uVeVZvXd1KnX5QicewyfDV5Nk4TeGNrt0Yx9SVo6vqtpO5agUNtiBhEZBq6Wid8jSII9fIphk
	MY0EMY9ObDM77G7UqWd9RQKJ5w2p2knWn7EUT5uwp2w6dBzsXATxxjrc3vsd/Q0Nlpmf3A0XjFS
	zof/BS1A3btFfVV/tJJ4EJ2zLumc6R18XKJM1ufRFXdFacDNwocSrqA5pAoRM
X-Received: by 2002:a05:6000:2010:b0:426:ff7c:86e4 with SMTP id ffacd0b85a97d-42704d8df97mr11013364f8f.19.1761051601979;
        Tue, 21 Oct 2025 06:00:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQe2AF3cxcaLPsgMe+jA1+DvC9OUXEqv94FS7Gua6OqWlPAIEXZjpDAmImXhD8jvhjJ6PszQ==
X-Received: by 2002:a05:6000:2010:b0:426:ff7c:86e4 with SMTP id ffacd0b85a97d-42704d8df97mr11013339f8f.19.1761051601543;
        Tue, 21 Oct 2025 06:00:01 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-427f00b985esm20896549f8f.34.2025.10.21.06.00.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 06:00:01 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v1 13/23] mm/balloon_compaction: fold balloon_mapping_gfp_mask() into balloon_page_alloc()
Date: Tue, 21 Oct 2025 14:59:18 +0200
Message-ID: <20251021125929.377194-14-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021125929.377194-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xPPRblGKC8b7nTBZ5YHPYUTiQbgavqIwfmomeIJdQV0_1761051602
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 42C8612000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: i3xt8hkop6toj1dr5nnp3dqobub5bagr
X-HE-Tag: 1761051605-162148
X-HE-Meta: U2FsdGVkX1/MV2wKUj7NIDyVY0Wza80yn+I7F+nGALoqblTa5BMsApFlyFxKVx/a3zuULbl72lMwXuSERmb5nfxaCDeD/prKiclDrZmJ5L6R42LHBXLLNsbtD9jakIYqLwS9Z/sE6o2KP5cw5vjs6+nMKbUALcRfMJ59BlDS77oD0HAlY/QROS9CenzQ+7jx0aqsUOXQlOvtUhhBimm8CLnUICD8rJA6N29bCDidRyYr2eL/8ci0w5LyeRhz0qwCe5r9C2ZsfvoL5uL1AVxMcFreU0/mJ6hPhYf/L2p/RIit+yw+r8rnMR5aBssSk8bn2iC4r4U9/co1vTfzv5IDqGrDXjX1e0axoadc1tvA4WoZD07Iz/4tXqP04+UpgkClg7b7ercY7Nql6tEjQLBMg9qEtUEwTafvCVXYJ7NCfVkZWFDnP0vmuXcciAq7D7n/d4A7Unbwn/C3CxSHU/lWBwDkO21gEJOgy/p5tFIIPamly/PlomSysnwpZz94j+Z+lauy2J06vyRLXvamIVgT77VyTRqhVdNe+/DNeEz31Su/QrtI2j/opZxM3oG4GribAH8OuYr/sCGi3GFK3Z125VbIHdIj83C5S5B9Mdrs2TFvNuBmp6YHZXEpo/lr8Zn6eQJe3rv7QIWgxLGG3fxcfeUIU5H/9SPsd96PuyX/is24V2T/bD0S8rYYoddEmw9bECCMKPUTKbGh2zpLaFZWh4NFBXYXac6FHw9N5J0sYrP3xUjIS3ZSI0rdCoja2rN8X7RG9aeDbSc+Ob0TG4QiKvcuSLxCkZKDINPIPwtkgNIvpzmMk7ZBQt/owYuHwhlAKd3EGGsj8c2mAIFyVsktJh+cxmH5N5wnr9tjDdlfdGcwAUlQaIFGU2X1jpf1+DuaCH9Hzd1CMTSnM2UkE5Pz4JitoWiYjRYeOL6ItwfC9WqbJlSGyYLk/rJwb933tBONIC/6OKMr1LX3r0VwoPy
 EKHb4sJQ
 qrQvYrTXUOzp/sIgDPW5zF28p6uJqKyT1QcJePEzYZKcIdl34abiIaVURWI7daf2ubY/Eg6FnUgq31dn+A8mszBpfK3/E7JTjmQ+wo1bhDDLOz4tzICYFVoSdDmtsDuXfq2vjrv388ouNntlu55L9FBbdaucnaWF24UWG1B7tVxOIG6gzz2oDOU4EW/TGAQvOkZw2UwgfnBM2Axy16Q8QGzhAzLObZjDR5MeO5mAh/z3VAywk/6mdqGUgn8/cvJblfpoCN3OiV6iQNv4Cb/JJnULdSL+bOj8nnoysM5cY3lRinAtm/jPHG4Ay/DW7f/jk9XhNy9ZTu7P02ccCW6iqfEScsXGzua4802i1uhPKjOdNblZClKd6VKdXgFgzFIC1MUfGRG9lxLa0q0UG2Lq5XBHdLhl0HWNUqY96LoXxFWGa6iAyuDj2NPIYHA+qdWdG0tXa8JyFzCheK0hur2QqQUBl98FokWwbuiYapKl999gWtZ8rhlyS1ZX52BEshvsPe4/9kNt5u0U1XTkALqXvoGijf0Vx5wKOlwG0nmKCUx3n5E7kwVUcAvxlztryw4Z/XrYzPAnpdpUhw2KyGIxIQxUzLtz2GXvI5G/jgWHTT23l+5UkHprfHni7KXl2N+iXpbzm8vQHcs/4jsWku/5x3Ja+GtXUlloHbv6UzFrSp0NnoWh55E5AZQpoLA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's just remove balloon_mapping_gfp_mask().

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/balloon_compaction.h |  7 -------
 mm/balloon_compaction.c            | 12 ++++++++----
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index e5451cf1f6589..d1d4739398978 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -106,13 +106,6 @@ static inline void balloon_page_insert(struct balloon_dev_info *balloon,
 	list_add(&page->lru, &balloon->pages);
 }
 
-static inline gfp_t balloon_mapping_gfp_mask(void)
-{
-	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
-		return GFP_HIGHUSER_MOVABLE;
-	return GFP_HIGHUSER;
-}
-
 /*
  * balloon_page_finalize - prepare a balloon page that was removed from the
  *			   balloon list for release to the page allocator
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 90b2d61a593b7..709c57c00b481 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -112,10 +112,14 @@ EXPORT_SYMBOL_GPL(balloon_page_list_dequeue);
  */
 struct page *balloon_page_alloc(void)
 {
-	struct page *page = alloc_page(balloon_mapping_gfp_mask() |
-				       __GFP_NOMEMALLOC | __GFP_NORETRY |
-				       __GFP_NOWARN);
-	return page;
+	gfp_t gfp_flags = __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
+
+	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
+		gfp_flags |= GFP_HIGHUSER_MOVABLE;
+	else
+		gfp_flags |= GFP_HIGHUSER;
+
+	return alloc_page(gfp_flags);
 }
 EXPORT_SYMBOL_GPL(balloon_page_alloc);
 
-- 
2.51.0


