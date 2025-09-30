Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59750CCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 11:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 696098E0005; Tue, 30 Sep 2025 07:43:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66D368E0002; Tue, 30 Sep 2025 07:43:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C348E0005; Tue, 30 Sep 2025 07:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 414288E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:43:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CAB2B13B957
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:43:56 +0000 (UTC)
X-FDA: 83945732472.12.4D04D49
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 77A45A0005
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:43:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CAldI52l;
	spf=pass (imf15.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759232634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DCufy65uAGFvGM422HmSOUaLbZSyia38lvC3FYRKqcI=;
	b=O0mr7zgVMl29NANA5vOcyldlM2IlwaVrg6/mfgKIFcDClL12h3wBmHaDJo81NL3ZBvJ3eZ
	y08OSpNIKvLvntQjZSsw2TZqKZ0kjaYNeH4+ni/jsi5DQkSi0hGrnDgVvL77LG3MzRvFLT
	KhzL3e0UTXjevRBhtslxqgk1hErbbCw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CAldI52l;
	spf=pass (imf15.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759232634; a=rsa-sha256;
	cv=none;
	b=G+YpNvx0Ozjw31JoyynOA08jPCz8MvE6ZOTSjQVm/sl5fPYt413oHZi3eoKiuQRiBKMmjo
	IqGgA2HV0M2NtgyYD7HZDPdYqI9Gp2R4H0ceIu9x5NeXLmWDo1elJ57AR6kk8By18c2L99
	eAHoNll86HwHPN0qOht6f5zVNsD6o6U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759232633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DCufy65uAGFvGM422HmSOUaLbZSyia38lvC3FYRKqcI=;
	b=CAldI52lN+RuwE9uW3bqEs7XEvgKICrOIijfRUHyiIFUyD2ybWykzQmte7Wdf799LZaZ5c
	tuJM4fu/fKfMTyaaPAdu0SPGU6AJghOdlnE3bD9G+SvHa/1/UHLtHD7hJRgmFfmxxoGmj4
	mVIvIkkirmeIIewwUIOWz5Xb3UhAihY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-OMzObt9rMy-mkb0uTX16jA-1; Tue, 30 Sep 2025 07:43:52 -0400
X-MC-Unique: OMzObt9rMy-mkb0uTX16jA-1
X-Mimecast-MFC-AGG-ID: OMzObt9rMy-mkb0uTX16jA_1759232631
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-afcb72a8816so553660666b.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 04:43:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759232631; x=1759837431;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DCufy65uAGFvGM422HmSOUaLbZSyia38lvC3FYRKqcI=;
        b=vjjvHzOVkMIys20MGGyNAUZicgRVmXDfEQ+QIv04LLM7jLfjR82f2nM05lUd4rk2X4
         7p4uAKcAH9IZM16sT87kfVPKTEOox3XYMuDc+0APMuGh68b+pklAVW5zx+apW4txMvzq
         KuMXgNvgnENPy7ohL3SMxdGl4AUOQ28jslIIdu0gHrzOLiRhxTXAm+nTxO1GYDS9AGAj
         0GafmF1LgTsT/YnwB6kts1D8GJJyeo6S9J3Nn3GbBQBtVrFrPckal68noR1EFiPNKEGl
         7w9xJPcWDvkesc/v948nPBDoUhX3kNWIAmFkn4/iy/+RBJYlTM3dkW+jvxE0sSl+OSA+
         d65Q==
X-Forwarded-Encrypted: i=1; AJvYcCWjvXD2fA8lLNrWMsCOCkl96MQFxLf77D4fGrSgrtmitS4Yc7DfbH8w8GGJmHkokndNLHFERvsWuQ==@kvack.org
X-Gm-Message-State: AOJu0Yzen2Cc/kBkmAA7UW269OkQxsoEUGsRQicbkpB0G17ggOHG7bsl
	uDaDgy3jfjQkJ5/J6V1rLCnloLhKq1RULTBzz00r2z6Od5ionQs07GmjQ1pc+qctkDTtZm/iyZL
	nmd+zg0O2tbW2QYXTaeP2n/ZZtgRoH/896ryVljdEJtsJoDExL1ZW
X-Gm-Gg: ASbGncs44RLTvsvPpSI4ZdWqcbRCkQVFrT6NaHoEQgf41HmM2szbwxMFQ5LsF+Onlbn
	k0isWmsyC+CCfxu1hQxj//V29kGHvvWAf6dNPJiRHW65RUc4jUBWf+DwXfSuZypjisXFCQ8Y+HP
	un+PMWvCEKa2cDgCBQDs4AVTV6nIfTTcaw2cAz3ZfnGkSHlaVLpE3BPhzJl+LVjAwz/G7EsDSXO
	dg6fJXR8NHhP2UZ7CMfdnrSD1C/W2yff8XMCCflrmF8YRp71/sKfjxWdX2n8PcyvOv8CmEXtzo9
	6C2qGxxurnbTK8fHl56abR0jlCa6GlaS4aCcha0lZ81QD4DjX/gfQbv96KkccM61R7C0ZkyR
X-Received: by 2002:a17:907:e895:b0:b3f:f6d:1d90 with SMTP id a640c23a62f3a-b3f0f7cbd87mr600068966b.11.1759232630849;
        Tue, 30 Sep 2025 04:43:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFHhdlfo70y+N4yKgHnnC+e82yqT8ByRohQadZ6Z8uJEwP7JjzeerbeTRrtvCy1hIRO79Au/w==
X-Received: by 2002:a17:907:e895:b0:b3f:f6d:1d90 with SMTP id a640c23a62f3a-b3f0f7cbd87mr600065666b.11.1759232630334;
        Tue, 30 Sep 2025 04:43:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.borgediget.toke.dk. [2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3544fd0a9esm1148965566b.84.2025.09.30.04.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 04:43:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 9A6012777FF; Tue, 30 Sep 2025 13:43:48 +0200 (CEST)
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
	Jakub Kicinski <kuba@kernel.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Mina Almasry <almasrymina@google.com>
Cc: stable@vger.kernel.org,
	Helge Deller <deller@gmx.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-mm@kvack.org,
	netdev@vger.kernel.org
Subject: [PATCH net v2] page_pool: Fix PP_MAGIC_MASK to avoid crashing on some 32-bit arches
Date: Tue, 30 Sep 2025 13:43:29 +0200
Message-ID: <20250930114331.675412-1-toke@redhat.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: n0amcu9La0AKJafppvzvIIsvRr4zv8T55t7gQt0WJPI_1759232631
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 77A45A0005
X-Stat-Signature: shj7nt6ecxeatg5ffoc8bdede8eqnoqj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759232634-157273
X-HE-Meta: U2FsdGVkX18aSFK+ny/r3eBs1NRXVKLCqk0tNpEPVclCnebgPSy36mDYarQzqi7tA1h4QNF7hTuvxsiMhkdtH2UFebfFVmAVkrtxqmyFuS1w5+wnuE3S55LTcbJP/iDCHd2NATbf3S+3K6Sf2jn3mFQ/KjVex6fUYUlW0FN1ajUdswj0fJzXZnkPamoktbpUa0dwREsubf+81jMBW6ZnX6NqBLwCr9pCk2rjILhx48wOwX0qWnIHbG1Y6GcFB7wWDvSkrFzo+KDnAzhAtBmNq+GttCxdcQhO8Pf2ufPSfuKUAdl6h0ARTWMqzHKezjVVumIEXb5zj60Wwi0eAFPcI7ggx0B9pwXaMKx5EHlbzDi6v3Rf/UlgN/QQM509j3ALWcLMTD1JSvUne53uRnSna88oGSJaSltvNglaYIZDCitmOCkR/3Ht01MuER50AUqw23/+ScrSFKij6ktPO2HauqWDTeIUzHnJW7bKfkbJ7FvnfWvQohJGhPjkBa2GJgcow9GH19RoiwNTvr77Jw+h4gQXLSFrf489S65WDtUhcZHq5PdhRtOE5rWoN4L52E0Qq/5sQ1cd+Z8ooAYuBjhw0Rv25KJU9WEeCK3JKcGWcQxA4M3Ya2WwN57r2jii4FcGRhRTbSA3X3yaWnXP/B/2/y4/rATYjvOOGB/lmtwEUCYLpbAkGEhHe4so+Id+vdFou5ooqCJmZZiaMtYJM+ik2lh2i+a6bKgVPOgJeRvoRFXfD0Ca9RUREHNXwmrO3bC9OfjEtqF7nLj5rS8+wW0TzBxuOJNNNteJNbVxY7XaAcdcbgT3RvskZpmtV3bjQdb6UyEgRy+psCvOJhpcgS2eVi9yZY/5h6P4EYZ3p4HBJ29vbhweHFiZxZqdmhcyz+Ksi4vYU34w8yLNvALhu+KXxSj1cY/jPapQeyvE2sINKlOZj+IkyMVGoTFjQHqq7tHhQ7uvQxW53w86lpzuIv4
 4FNn5P5G
 7RP9TVqzaSfiBR67oGj4bqnLHtrfMMvNZoJ5xsRZwE/4Z9uWrCmxQKvIUhz+VJ6EkEFe1vzutrRh2Z+RJz9+HRGPe5Z9imUAU/EI11TijFw5GEmai5UTNFTnts8SXaVg7N4t48Zmyv0InoXGCNKIULJXbutpTrBAgdKrLfVso2FJWEsZkWGr/7NuKj6WjLLUiRFtiRouewOXRy9HUhoYusSZkSeRcWvsMb+pUcTwyWfAgj2kiVcfHjOmoLDiZ1bdnsajwiakOf34FQQzRaXei1PlrdjkcBxKgtEtlNO5rbXdCaC776Q6MTieWM0k62wlL7h56NpNn6CuHvNrAfMnEGnHMdqGBBbvKsTWNuS4zmZlnjupckuQ0Pvi7SCKiCooIoouFd7LlHwWhW4kKrn4AKRGWiQXeWT7dc3ff9wRohjrcBotuKvNRKk75qQSDrVigQrdE+qfN/LrxUAmmewhWjvfDI90Ph4mnVZqSdWO8MvrrPKPRnO7bQxpF4i70E6zGe2Nu5qgMKpwMpj6m3Ot5Ib6qYkB/EYXizFBS
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
dma_index storage when there are not enough bits available. This leaves
us in the situation we were in before the patch in the Fixes tag, but
only on a subset of architecture configurations. This seems to be the
best we can do until the transition to page types in complete for
page_pool pages.

v2:
- Make sure there's at least 8 bits available and that the PAGE_OFFSET
  bit calculation doesn't wrap

Link: https://lore.kernel.org/all/aMNJMFa5fDalFmtn@p100/
Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when destroying the pool")
Cc: stable@vger.kernel.org # 6.15+
Tested-by: Helge Deller <deller@gmx.de>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/mm.h   | 22 +++++++------
 net/core/page_pool.c | 76 ++++++++++++++++++++++++++++++--------------
 2 files changed, 66 insertions(+), 32 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec7..0905eb6b55ec 100644
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
+ * small to leave at least 8 bits available above PP_SIGNATURE, we define the
+ * number of bits to be 0, which turns off the DMA index tracking altogether
+ * (see page_pool_register_dma_index()).
  */
 #define PP_DMA_INDEX_SHIFT (1 + __fls(PP_SIGNATURE - POISON_POINTER_DELTA))
 #if POISON_POINTER_DELTA > 0
@@ -4175,8 +4174,13 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
  */
 #define PP_DMA_INDEX_BITS MIN(32, __ffs(POISON_POINTER_DELTA) - PP_DMA_INDEX_SHIFT)
 #else
-/* Always leave out the topmost two; see above. */
-#define PP_DMA_INDEX_BITS MIN(32, BITS_PER_LONG - PP_DMA_INDEX_SHIFT - 2)
+/* Use the lowest bit of PAGE_OFFSET if there's at least 8 bits available; see above */
+#define PP_DMA_INDEX_MIN_OFFSET (1 << (PP_DMA_INDEX_SHIFT + 8))
+#define PP_DMA_INDEX_BITS ((__builtin_constant_p(PAGE_OFFSET) && \
+			    PAGE_OFFSET >= PP_DMA_INDEX_MIN_OFFSET && \
+			    !(PAGE_OFFSET & (PP_DMA_INDEX_MIN_OFFSET - 1))) ? \
+			      MIN(32, __ffs(PAGE_OFFSET) - PP_DMA_INDEX_SHIFT) : 0)
+
 #endif
 
 #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 492728f9e021..1a5edec485f1 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -468,11 +468,60 @@ page_pool_dma_sync_for_device(const struct page_pool *pool,
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
@@ -491,18 +540,10 @@ static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem, gfp_t g
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
@@ -680,8 +721,6 @@ void page_pool_clear_pp_info(netmem_ref netmem)
 static __always_inline void __page_pool_release_netmem_dma(struct page_pool *pool,
 							   netmem_ref netmem)
 {
-	struct page *old, *page = netmem_to_page(netmem);
-	unsigned long id;
 	dma_addr_t dma;
 
 	if (!pool->dma_map)
@@ -690,15 +729,7 @@ static __always_inline void __page_pool_release_netmem_dma(struct page_pool *poo
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
@@ -708,7 +739,6 @@ static __always_inline void __page_pool_release_netmem_dma(struct page_pool *poo
 			     PAGE_SIZE << pool->p.order, pool->p.dma_dir,
 			     DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING);
 	page_pool_set_dma_addr_netmem(netmem, 0);
-	netmem_set_dma_index(netmem, 0);
 }
 
 /* Disconnects a page (from a page_pool).  API users can have a need
-- 
2.51.0


