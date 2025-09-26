Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F279CAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 11:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96FF48E0005; Fri, 26 Sep 2025 07:40:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947A48E0001; Fri, 26 Sep 2025 07:40:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85DBC8E0005; Fri, 26 Sep 2025 07:40:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F1528E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 07:40:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AF488160472
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:40:01 +0000 (UTC)
X-FDA: 83931207402.08.EDCB005
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3B72F180007
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:39:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=biKy1hZY;
	spf=pass (imf16.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758886799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AtJ/1mk75ioxBq+kB3S7YkMI6itFh86Ny1CHtMfezGs=;
	b=6dEWYzAt7Yq/Vgs1xDjuatHUKAeiwOnLQc7jAQ3MM20rkVRKGUuyGR2946TvVC5ybIjfas
	BkSgq99WjTyTJsGtCwM2J/36ad8ntPblPnirIqk1t7Kcteni2ijsfXXbN+1vrXNTsAS4zr
	73otOq+6uyh5XHfbmsBf5q7H+NV2C8Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=biKy1hZY;
	spf=pass (imf16.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758886799; a=rsa-sha256;
	cv=none;
	b=YrGl+cr1ILddFhD8kjFqLcIFMtLA+MvEyuCGmEeteymzP0gi7jZX9yljThc501lxrwO8Hb
	6nDWcwaJdOOJX8x+zUu0jIXx7gHCvihcBnfEE42QENbYqvIYuIlzduFAq7sIcsxWBdcyBi
	pigSpA6BdoLY72cRN+vkfMlETE/fNcA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758886798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AtJ/1mk75ioxBq+kB3S7YkMI6itFh86Ny1CHtMfezGs=;
	b=biKy1hZYpnY47+S1IwfCHnYdgx6yuwU8IfShxUtdBQDwNHWx6O/70aPHYhA0+J9JSYceQr
	k1ESpg82kbrnr6qBiAkWobou5B3hmx+OC1QUoLy2I7tXSgC/Hibn83nQanBwJbRG0+P+H2
	8IQcmoNad9qK1ctaWcS6iEbRQU2TIT4=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-301-GWdhFJrlNCeTuujUoLVhYQ-1; Fri, 26 Sep 2025 07:39:56 -0400
X-MC-Unique: GWdhFJrlNCeTuujUoLVhYQ-1
X-Mimecast-MFC-AGG-ID: GWdhFJrlNCeTuujUoLVhYQ_1758886794
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-57a31c382b8so1470254e87.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 04:39:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758886794; x=1759491594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AtJ/1mk75ioxBq+kB3S7YkMI6itFh86Ny1CHtMfezGs=;
        b=uh65TsI3WonBYGIXbs2Li0S4jCIa7/JBPtlkOEDaTUR+RXJTGA/37/15Zr7UWiiySM
         OdHmpwrJlv6j4LUypuwgMfRntHzzOl8GkZ1NHMQw6TG3vNHVZPYy+5/f3fmeBmOGi/j0
         ejx/GI0paRX29c0HkqydjcssKSzFFHIIL2078qEkF34XyfwqjRkKnnFsQHic4OjyeksO
         oUTRdnghY3g4MJkttEl/XylDG34YOM54GBbsj1EfftAyAkgBsCGeYxA4kYYKfPI0Tr9a
         g6l7bi3G/CqK4EQBc6LJT0OfSqiY194OWZ1LdBNGsZqoypntBO23WM42B8MnwwxuD4h0
         bBmw==
X-Forwarded-Encrypted: i=1; AJvYcCWcq0ONwOx7Z0X/eCBi1WrLmGTBDZj2K5JDb3kkqZ9PLMo8A1+4cO6osqocIVmazWUDws+rCIHoFA==@kvack.org
X-Gm-Message-State: AOJu0YzAptkRDsVlXPg2w+UVPaVUhCe1jx9P5I4nIBNHGsD3kuTRq3aF
	stlLsodkUzkp5F35dIzd9chKcHXku0H0cbo5aWeWqkGHZzgNcQh9wiR4defmEQ5tBUZFIgBP1Ak
	H+ghybIds0KeQwFbpukjz98P3bS50gv8KG3iiGePhOx6smRCk65Dy
X-Gm-Gg: ASbGncuhSV2Ec8ySCI9Dzm9B8No2jErwcAZMzBMLbID5wp4SvOBgZIWprjpVBhgH5mU
	kwUh60C+265yRgHla+X2DktJz1vc5PVJoMYP0cFN7P8MgvtmfTNuoiHpIddWt1OqrxL2V9udMDi
	pJya7ll31ROlJkK6tt3QLxfjo56U5y5xnQm+4kwAhrmxzP6nMS5yJLm7TNsn0aNkOxewFPEX+6m
	IwnSCWAzC6d2JGY6CEHCflgSs+kvzw+gAzam9R1gTp0wOABNpfyCPsdj3Srfar0FBIFd39bbMKI
	Pu25mngDpFqTe0NloGn0txAAlSyGMLCwIcu2QA54TrDrZJXwMlgH+mPSNNRVLOQPQxU=
X-Received: by 2002:a05:6512:39d1:b0:55b:842d:5828 with SMTP id 2adb3069b0e04-582d2f2796emr2598433e87.36.1758886793734;
        Fri, 26 Sep 2025 04:39:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOkzLCVigWsLXFz4HKYVY99wW4ETi6/xnHL05Mfvqi+0yC4WxRRgQmbTgHpaOV9jp1BFmI0A==
X-Received: by 2002:a05:6512:39d1:b0:55b:842d:5828 with SMTP id 2adb3069b0e04-582d2f2796emr2598408e87.36.1758886793243;
        Fri, 26 Sep 2025 04:39:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.borgediget.toke.dk. [2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58313430dd5sm1751076e87.24.2025.09.26.04.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 04:39:52 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id F014F2771C6; Fri, 26 Sep 2025 13:39:50 +0200 (CEST)
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Cc: Helge Deller <deller@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-mm@kvack.org,
	netdev@vger.kernel.org
Subject: [PATCH net] page_pool: Fix PP_MAGIC_MASK to avoid crashing on some 32-bit arches
Date: Fri, 26 Sep 2025 13:38:39 +0200
Message-ID: <20250926113841.376461-1-toke@redhat.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kfBoFAkw6j5Y0bGrbh2FMZKRjO3JHm7MwDIhDmLepK0_1758886794
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3B72F180007
X-Stat-Signature: mq1onarx6esqim9bbmrhdfew67hzti8r
X-HE-Tag: 1758886799-109738
X-HE-Meta: U2FsdGVkX1/eFWUWP8B4A5wNx4XCyBp2vIkGI7iP4wBx5PxSpKmeiDltl7sc6SkkMCIfLsGPCVVaIfuY44KI2PIriBmaot+Jv8ld4trooHMjINDNo6Ajbi4chaaGkEsmGnTzyVIpVjFdayeGXbwP7Btul3eJdnfA3bitnLzgkNCxymz+xY3iCDa/nZOqWo7VXB0KwtyztOiZnyCbiTF61jibSuAOzWF/nsJgIojcqLlkGT2wXnA4BMpcQIppIQ3DMb+wcFZWdEF5AIT3Gb6YSvpP5fJesC7MLx2kQw4ADYXz3Y+9X/uV0i7Eg1EWRdEUcVO3kTeMlgoRFw2NZHmWKUILWMOYXyUcArOfqXT+qQy/oJDeJFw90DVyzv3x2DyiKqoFx3OcGL7+YpsgJoZF05dR05+veYxnMmVIH+MpoG1ZjMjGfvUiujjEboDAzZulrWEqKGLuoTooMkmW85pN6A9BK9z/J4uXYlzoOZ1N/Le01T2Q5pi+XwV+WlNRLXyTEnTN36jZfq3d7jdZqiYD60rYE6KzfVwY2UsxCw+ioVIZdiQoKeqMr7wK55aRHzNc/L937ruvZlQUNxh/Kboml8hgPjKUyj4mReBB7pdVq+pkqSg4tUVLv1wj7L8T6nxHOqhn+XrTdh2PobbRXFsF+T21AMjzNMys/HlKr3b4/YnPuoVjTDAiVqI472s1topmr+KqjlNd3Qtb78aIHyqQDClqgUOj35Nv4xZkFwCOM05aLITueF0X5XlFnB1PNa3hfL7CLc2Zkgobt8x1e1yk3WDbDmf9JkXPBf2KRcTN0W7RkuLxAMJ4M8S4doCr+ORf8K9wVnKCRPU8lX68U9+PiAZj3/hVOvlgR8hKDHhpMVZYhgL0kUa28sDKzQDRd07zf6W+rxO551Fq0Vh+c61ZeyNfY05Izkg9Xm3BrT1IeBlgUMCj/tjskS5+dEhfGRG9Sr9Yd4BLKJP7jP5qfKL
 wicrt236
 hnM0w+j2h4k390wSCEofHJkV0aZiJGX1yO9AcRKSJ0HLneXK/0P8yEuleP2CM5Qp/wYBPqE5PXW1NB60LnB0WFYHb56z0ceneWHkrPZwmCN5CuFZHbFGLnkPxGUfCvb42Ml4wLPnw85e41vBayKq3LVZz9/Ndls+BetZSwYDholJwFbLzENk7QbpUbk/054RfLjolKcrdG+NU47cXkvQ1eSi2GZ7AABwzPKk9LN5+8XA1rvhFQbSh4er1JsWaqZE47E/bGehGn2RIoKhp8DhJjJiyI1QTA6yP5PHEAXW1/aGMzX0aMy9mUAsTotvXeah8zwB9Rlx4lFw2zAoL/ek+N8iw1OE3xF/3tuLLQLuZKm/qVJV2p7pFkG0pWVrIkVNIuQP9sZWrWQ4Qp9I7JxhECs0DwkK2Gig7PLc8yjgLUPLWQoXG0eUbNvfKq6HAQ3a6Il4d5ehwZ3PbmXn8nT6Ri4oMqNx5JuQBxeKOhLbG7dwAiAuKl6S5R4DUnA+982pj42tvtk632TKrAMOHJdKW4pWurk3olUXksQny
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Helge reported that the introduction of PP_MAGIC_MASK let to crashes on
boot on his 32-bit parisc machine. The cause of this is the mask is set
too wide, so the page_pool_page_is_pp() incurs false positives which
crashes the machine.

Just disabling the check in page_pool_is_pp() will lead to the page_pool
code itself malfunctioning; so instead of doing this, this patch changes
the define for PP_DMA_INDEX_BITS to avoid mistaking arbitrary kernel
pointers for page_pool-tagged pages.

The fix relies on the kernel pointers that alias with the pp_magic field
always being above PAGE_OFFSET. With this assumption, we can use the
lowest bit of the value of PAGE_OFFSET as the upper bound of the
PP_DMA_INDEX_MASK, which should avoid the false positives.

Because we cannot rely on PAGE_OFFSET always being a compile-time
constant, nor on it always being >0, we fall back to disabling the
dma_index storage when there are no bits available. This leaves us in
the situation we were in before the patch in the Fixes tag, but only on
a subset of architecture configurations. This seems to be the best we
can do until the transition to page types in complete for page_pool
pages.

Link: https://lore.kernel.org/all/aMNJMFa5fDalFmtn@p100/
Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when destroying the pool")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
Sorry for the delay on getting this out. I have only compile-tested it,
since I don't have any hardware that triggers the original bug. Helge, I'm
hoping you can take it for a spin?

 include/linux/mm.h   | 18 +++++------
 net/core/page_pool.c | 76 ++++++++++++++++++++++++++++++--------------
 2 files changed, 62 insertions(+), 32 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec7..28541cb40f69 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4159,14 +4159,13 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
  * since this value becomes part of PP_SIGNATURE; meaning we can just use the
  * space between the PP_SIGNATURE value (without POISON_POINTER_DELTA), and the
  * lowest bits of POISON_POINTER_DELTA. On arches where POISON_POINTER_DELTA is
- * 0, we make sure that we leave the two topmost bits empty, as that guarantees
- * we won't mistake a valid kernel pointer for a value we set, regardless of the
- * VMSPLIT setting.
+ * 0, we use the lowest bit of PAGE_OFFSET as the boundary if that value is
+ * known at compile-time.
  *
- * Altogether, this means that the number of bits available is constrained by
- * the size of an unsigned long (at the upper end, subtracting two bits per the
- * above), and the definition of PP_SIGNATURE (with or without
- * POISON_POINTER_DELTA).
+ * If the value of PAGE_OFFSET is not known at compile time, or if it is too
+ * small to leave some bits available above PP_SIGNATURE, we define the number
+ * of bits to be 0, which turns off the DMA index tracking altogether (see
+ * page_pool_register_dma_index()).
  */
 #define PP_DMA_INDEX_SHIFT (1 + __fls(PP_SIGNATURE - POISON_POINTER_DELTA))
 #if POISON_POINTER_DELTA > 0
@@ -4175,8 +4174,9 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
  */
 #define PP_DMA_INDEX_BITS MIN(32, __ffs(POISON_POINTER_DELTA) - PP_DMA_INDEX_SHIFT)
 #else
-/* Always leave out the topmost two; see above. */
-#define PP_DMA_INDEX_BITS MIN(32, BITS_PER_LONG - PP_DMA_INDEX_SHIFT - 2)
+/* Constrain to the lowest bit of PAGE_OFFSET if known; see above. */
+#define PP_DMA_INDEX_BITS ((__builtin_constant_p(PAGE_OFFSET) && PAGE_OFFSET > PP_SIGNATURE) ? \
+			      MIN(32, __ffs(PAGE_OFFSET) - PP_DMA_INDEX_SHIFT) : 0)
 #endif
 
 #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 36a98f2bcac3..e224d2145eed 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -472,11 +472,60 @@ page_pool_dma_sync_for_device(const struct page_pool *pool,
 	}
 }
 
+static int page_pool_register_dma_index(struct page_pool *pool,
+					netmem_ref netmem, gfp_t gfp)
+{
+	int err = 0;
+	u32 id;
+
+	if (unlikely(!PP_DMA_INDEX_BITS))
+		goto out;
+
+	if (in_softirq())
+		err = xa_alloc(&pool->dma_mapped, &id, netmem_to_page(netmem),
+			       PP_DMA_INDEX_LIMIT, gfp);
+	else
+		err = xa_alloc_bh(&pool->dma_mapped, &id, netmem_to_page(netmem),
+				  PP_DMA_INDEX_LIMIT, gfp);
+	if (err) {
+		WARN_ONCE(err != -ENOMEM, "couldn't track DMA mapping, please report to netdev@");
+		goto out;
+	}
+
+	netmem_set_dma_index(netmem, id);
+out:
+	return err;
+}
+
+static int page_pool_release_dma_index(struct page_pool *pool,
+				       netmem_ref netmem)
+{
+	struct page *old, *page = netmem_to_page(netmem);
+	unsigned long id;
+
+	if (unlikely(!PP_DMA_INDEX_BITS))
+		return 0;
+
+	id = netmem_get_dma_index(netmem);
+	if (!id)
+		return -1;
+
+	if (in_softirq())
+		old = xa_cmpxchg(&pool->dma_mapped, id, page, NULL, 0);
+	else
+		old = xa_cmpxchg_bh(&pool->dma_mapped, id, page, NULL, 0);
+	if (old != page)
+		return -1;
+
+	netmem_set_dma_index(netmem, 0);
+
+	return 0;
+}
+
 static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem, gfp_t gfp)
 {
 	dma_addr_t dma;
 	int err;
-	u32 id;
 
 	/* Setup DMA mapping: use 'struct page' area for storing DMA-addr
 	 * since dma_addr_t can be either 32 or 64 bits and does not always fit
@@ -495,18 +544,10 @@ static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem, gfp_t g
 		goto unmap_failed;
 	}
 
-	if (in_softirq())
-		err = xa_alloc(&pool->dma_mapped, &id, netmem_to_page(netmem),
-			       PP_DMA_INDEX_LIMIT, gfp);
-	else
-		err = xa_alloc_bh(&pool->dma_mapped, &id, netmem_to_page(netmem),
-				  PP_DMA_INDEX_LIMIT, gfp);
-	if (err) {
-		WARN_ONCE(err != -ENOMEM, "couldn't track DMA mapping, please report to netdev@");
+	err = page_pool_register_dma_index(pool, netmem, gfp);
+	if (err)
 		goto unset_failed;
-	}
 
-	netmem_set_dma_index(netmem, id);
 	page_pool_dma_sync_for_device(pool, netmem, pool->p.max_len);
 
 	return true;
@@ -684,8 +725,6 @@ void page_pool_clear_pp_info(netmem_ref netmem)
 static __always_inline void __page_pool_release_netmem_dma(struct page_pool *pool,
 							   netmem_ref netmem)
 {
-	struct page *old, *page = netmem_to_page(netmem);
-	unsigned long id;
 	dma_addr_t dma;
 
 	if (!pool->dma_map)
@@ -694,15 +733,7 @@ static __always_inline void __page_pool_release_netmem_dma(struct page_pool *poo
 		 */
 		return;
 
-	id = netmem_get_dma_index(netmem);
-	if (!id)
-		return;
-
-	if (in_softirq())
-		old = xa_cmpxchg(&pool->dma_mapped, id, page, NULL, 0);
-	else
-		old = xa_cmpxchg_bh(&pool->dma_mapped, id, page, NULL, 0);
-	if (old != page)
+	if (page_pool_release_dma_index(pool, netmem))
 		return;
 
 	dma = page_pool_get_dma_addr_netmem(netmem);
@@ -712,7 +743,6 @@ static __always_inline void __page_pool_release_netmem_dma(struct page_pool *poo
 			     PAGE_SIZE << pool->p.order, pool->p.dma_dir,
 			     DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING);
 	page_pool_set_dma_addr_netmem(netmem, 0);
-	netmem_set_dma_index(netmem, 0);
 }
 
 /* Disconnects a page (from a page_pool).  API users can have a need
-- 
2.51.0


