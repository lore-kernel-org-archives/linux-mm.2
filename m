Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDC6A606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 01:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Ma5K6Loh
Received: by kanga.kvack.org (Postfix)
	id 0ECFB6B072A; Thu, 19 Nov 2026 20:07:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C5096B072B; Thu, 19 Nov 2026 20:07:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6576B072C; Thu, 19 Nov 2026 20:07:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0D16B072A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:07:21 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D5FB5120CD7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:20 +0000 (UTC)
X-FDA: 85453709040.15.31F2205
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2A08D1C0007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Ma5K6Loh;
	spf=pass (imf20.hostedemail.com: domain of 3RZ3_agYKCNwJPGXXMEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--lrizzo.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3RZ3_agYKCNwJPGXXMEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795136839;
	b=eYbAlx+P7icuIf+ky4jPW/6dYS3SnFZmaTzYQXeLPgh9o+EKCE0VK3szWGV+kBmCB1kGjo
	rW9sKSwS/3rrmJD/SI028Ff3paRODB4NmWrNIhVcbTnCMn/uGJ9S2oAwt/RDNraxEg/wAk
	vaew8w8VA1FgPSakVI44xxzQ9U6tub8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795136839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXU5FE3T392RxN9QNel254D35psegmPr29XGG2IaIcw=;
	b=JxJItcnLCdtK2g/oUVy00OdNMLtvow5OzaTr65OzGaagaYdhue0zUMoOCza7yFE3HqFyhW
	H1lExqfsIXBXy+z8fOPCTRnYCeXc9Z1i/X8FDDfWCS4dGuv0qPiV/sH9jhCDj0MUGdt0Gi
	IpAy5iaSxSBn4qPz9HkikAnuZJwuhw4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Ma5K6Loh;
	spf=pass (imf20.hostedemail.com: domain of 3RZ3_agYKCNwJPGXXMEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--lrizzo.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3RZ3_agYKCNwJPGXXMEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c505f26e9e1so24315666b.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136838; x=1795741638; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vXU5FE3T392RxN9QNel254D35psegmPr29XGG2IaIcw=;
        b=Ma5K6LohYgP4m+YWyXLcg28yDXBOBMCGvsZu/OwzDeVkdlHoV9F5rBS/I47GIp31Lc
         58CJmbc8aHZ8SS5+f60yCzjzmmZM2mT+SpOIIwUj4CT/GfBy/Ep029IeBVgsIF/tgJvz
         05CD34iqEfqUCAuloLsQN27PwasnXP5QzKoqwTo4AZChoayUyQ/VbPGd39ONdsEoyhmi
         iPrH1FYPhNVIns0WBnQywizxLMFDSw9oGrIpLIwCpMJ66pvQI9gVu4RdDecnn95cEbKQ
         tJGq22ObcnDuLqpa7Vx60jEJzhRpSs1w64cJPipAt+Ec9DfJHKjuaWIphUyDG94Vp0Wa
         n5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136838; x=1795741638;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vXU5FE3T392RxN9QNel254D35psegmPr29XGG2IaIcw=;
        b=C18KBpxkz6FpH5Y8+D2Ix1CMvbxoylb7dzYM1WhfIWs+aMLfCGbTmHMq+84av6hwMy
         CETEoAGvReYXtCDj3bqYYEgs2tDEBPC9z4m9A0QI7/hZZkHEPazT9nXh2IBXPXOQdUTU
         cOlyBzlKP3ckktQd1XfsHVIMRe5BWfba/tDJPiR8Se/1nndMEeM4YKnQZi0Decbg6426
         jwflGIUi3fJK0e51+K+mnvtyZeC/LBfczC6avoYC4GulWGTPkBfCTevc0rE3YiUGg/Ln
         nVNpPtdE9F8L/TZ0WEMrAMJd77B7AgySzmVwdkYmt+/StJ8/EHI+xUPmtsi7j2SKNfR3
         bnUA==
X-Forwarded-Encrypted: i=1; AL+hErFXs4lrR3PlKyU6Y3GSCRL7T5esw8+N4LH+VPVqkMJi4Si11OuaLWOjWIdG6V1srm3cCSyc84LZRQ==@kvack.org
X-Gm-Message-State: APuU4Z8UwAGoyBYXNAhvISTdkhModtjf2sGf2wRQzFG/44Em3S+bFTE2
	Aoev8HT4P4bvZT5udQ1h4ik9cFEDbf+2w96LR5g6ZC9rzqdKK60fxEv553Rg3K9wHU0HpVmn79J
	HF8h/RQ==
X-Received: from ejdlt17-n2.prod.google.com ([2002:a17:907:c651:20b0:c50:cd62:3dd0])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:4fc4:b0:c2e:62af:b6fe
 with SMTP id a640c23a62f3a-c513a5e62e7mr135377366b.8.1795136837193; Thu, 19
 Nov 2026 17:07:17 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:45 +0000
In-Reply-To: <20261120010655.467825-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261120010655.467825-16-lrizzo@google.com>
Subject: [RFC PATCH v3 15/25] net: Use PISA for page_pool memory
From: Luigi Rizzo <lrizzo@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Simon Horman <horms@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>, Dragos Tatulea <dtatulea@nvidia.com>, 
	Naman Gulati <namangulati@google.com>, Pranjal Shrivastava <praan@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7ifueqfmyga5rq6btcreuep33hz1fgbg
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2A08D1C0007
X-HE-Tag: 1795136839-52313
X-HE-Meta: U2FsdGVkX1+BqHvDIR8jZzvzF5quWqH/ZkwspyJCCVEv7jtdeminhV41Ecj5iE8qNaF8VCh+Eo1gAEiCaHENLIe4FPZm0RgJOa5BZ4U8ybPkrHOUvwT18fSDlZXfNvtZoFMW8j49kI99D5K3GJxErcvTqLnAzBFOUeIiWJ2S5mHGZi1yPgsFAa+8B14nul6nEqyej9F2aAkcbZuopIx9jw50kof06cQOHCqtkAsHxT0ygJU6PrGBBN6U2eOa5PEdwWAfmFs/LkbyDegAVEWZNoopXaYm+G87+BGta7430VtN6PMO+W+usarpMbOunjRa9JDwBolN/buXHmh+kpo0mONlqqy8UPvascUh7F95ecjatR6f2BtZpd4YqHPq18gpgn4NxZj1axiHFo6+Cy+7G3aFIqOkJwDvhuVRV6/LfH7X+HGB5iOi6tetUikwPL6Upe+T5EnEQjqZ7Gxz6hJqcjx/PY7l+w2uc0LRjmVVektM/dAN68tnf47RKj37aOu55zKAWlHwF+XqScUh7z4vrM5I6IS1BP3Dszi60OUTdRgPYP0/ZDhWEK6kgeqqVWLGvRoksxt7RPnp/jka55rezRquZtzeHbYkpFInjdAtTTsc9VXbr9geaDlBMXog61/1FSW+p2PyOTJjV1mWkj0xr5k9jj9A+desttco2LliaIFkJHH2ac4aA3hqaDy05criqjyy8s3DLyY3fMceji3vKH4EqYRxg04PtcP9CVDgQTDuFwEz+1gNaQUmOYQea4pcOL19CBaJ0YAmqtDQmQXSI/OPUPDGuWFajx96WR2mlih6fYXeFIK5BXdqCjA6UUKMOmSp04lWdeGaBFHnoMVBmkOAxT3jVZ6BeObCsruxjvepDmqHANVKWytV0r7FHEHb91GhjBEQAHc4KGVTaJ3tGgftSLgztvIf+XA/5VazagVELZEs5nG3hUG2SU9qXaSiD7X6ZSPXWBEdFYyUccK
 n42YMEi4
 9t41f9CI03hVdK4XKPinMSciK6k3yOa1FdYohPJliUpszkLSlJgi3cm4zXcCrIDGDq6hbqEqVjiwtWRCu95w2IfwWGnCyWOe2noxH26J/B2qKFy+TPNINcFtIYirsObXP/9QT3iqJ3ofqwiaSzwQcSqS8+joI5LsttuURhHrzWLHcSopmfhPV+tH8PUJCK4DQGQLKhnuVD62ok3vs8HV6vFr7h23oJkLC5jHRD5dXM80YUoHD3vEju2/9MGc9BX7STFxuVlZHUB6QhaowUCql2vqH/VN884f45MVP1AnBT5kYQOKA5XCJR4Q27c5HjCsVWtMxEL1a6/hQsCabfpDIiEHNGb+bCf2suNg7AnD3nBSVrJm5Z5zqPEeS5laDWkVSrQ0SukRAF1tezOG9JyvFeBKuepJoKDr5B2oDB03lRc6/NJkEQoaL4FfSjuJnzoctsbE95BoVG0LL+TKn4xJV9NIZD0P4Yff+GcPnNVVXOlRxajYtHxL9O4wMKEiac0E7kfo6H52fx/nXsr2ZeEHIvj4voJj8RtHj9gIIXM6GjWkvLau8//M4a9o7H9ygr3aKD7KUxHZ1UdflJbbsu3jivKnYBPFRyUjacjuNMdPaxdjKJQuSAGs7masb3Lfw+BKyjIm5R5v/wHRH1HskeVRmY7x1jLScynnKCcKp3bCtHkZlyJ6b9izokvEJq7q+U3+FTyGRpavNVL/XXpZWztMzjtNHMfS7wsT9g8Dp7GKNkMGDIUC5iGj+nO4BzLQrxnfYDjfBFQ2WLdqXifanWF0r8AHYGPZvvVl+dyhvyf6Ex3zvGAeg9If37ymqdZnXDAI3Uw/wycS+4F4M5kUgQG//zvO3A2+IDEIrMAW9ZqL9WZ0/M5X83O8ULqZt70JbcTnRUV5ozja70eHnNNa/07IYBhlsV1XjvcPH71UzbePpimRIfT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When a page_pool performs DMA mapping (PP_FLAG_DMA_MAP) on a device with
pisa_rx_bufs enabled, pass __GFP_PISA_RW to use PISA memory.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 net/core/page_pool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index d7c88c0b67e53..91cae5ba78373 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -16,6 +16,7 @@
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/memory_provider.h>
 #include <net/xdp.h>
+#include <linux/pisa.h>
 
 #include <linux/dma-direction.h>
 #include <linux/dma-mapping.h>
@@ -622,6 +623,8 @@ static noinline netmem_ref __page_pool_alloc_netmems_slow(struct page_pool *pool
 	 */
 	if ((gfp & GFP_ATOMIC) == GFP_ATOMIC)
 		gfp |= __GFP_NOWARN;
+	if (dma_map)
+		gfp |= pisa_rx_gfp(pool->p.dev);
 
 	/* Don't support bulk alloc for high-order pages */
 	if (unlikely(pp_order))
-- 
2.56.1.809.ga0b61035b5-goog


