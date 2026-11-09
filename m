Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06534606A335
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YOVULh/z
Received: by kanga.kvack.org (Postfix)
	id F40A86B05C8; Mon,  9 Nov 2026 13:26:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECA8B6B05C9; Mon,  9 Nov 2026 13:26:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB6B36B05CA; Mon,  9 Nov 2026 13:26:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A2FE26B05C8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:26:01 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2981A160786
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:26:01 +0000 (UTC)
X-FDA: 85416409722.24.A257B3B
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5221810000B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="YOVULh/z";
	spf=pass (imf14.hostedemail.com: domain of 3NRDyagYKCHwqwn44tlttlqj.htrqnsz2-rrp0fhp.twl@flex--lrizzo.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3NRDyagYKCHwqwn44tlttlqj.htrqnsz2-rrp0fhp.twl@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794248759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+CkU7K8AN4V+yWUdhaz7RzC7M7eZI1Az06smW8kAgic=;
	b=PYA6OmTOzA3C7tV6h/JHGyBYP6OmNvA3BJiqg/XWmh8iFD8vg9iZlYIOIgYC5xgoApkiJi
	ZacJ8pxuEf7GNwrxvVahlmFOfy5jWm2/xGeRggdN8a3SyH8BY9iPv0CWsc99W2L80yzBTo
	sWNybNmYwe6dixHZy6v8P12asZfy9EM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="YOVULh/z";
	spf=pass (imf14.hostedemail.com: domain of 3NRDyagYKCHwqwn44tlttlqj.htrqnsz2-rrp0fhp.twl@flex--lrizzo.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3NRDyagYKCHwqwn44tlttlqj.htrqnsz2-rrp0fhp.twl@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794248759;
	b=6WyYKR5x7Sr2sjLRovzWtP2UXP2qGGPDO1JkQuBwEnJIsGdtO/pI2gKarHm6S1kiDJt5SC
	ZUm9iFlHdiV1Q2d7WLXqmNijA0xgfuFB18jhGYK1C56PXGB4w/3XzGTXmF/MFFTyaAUYjX
	kygCkItBmKMe2FgbXOAI/d9lK/1dveQ=
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6a5d57a8d51so1402197a12.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794248758; x=1794853558; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+CkU7K8AN4V+yWUdhaz7RzC7M7eZI1Az06smW8kAgic=;
        b=YOVULh/zUV4ohRXp4dBSGALz4ZdFlikJLxwkSFUzqKaO8sTOxNl9/b7aK8TZtoWZZU
         egp4dqG4ehcSYy49tiy0OqwRn4ssA/ssBi8Cpw4rc5oSHx27g6geUGmPum5ayknUbH7S
         RAL2NW5dy3ec2SeRZ0RBJ/A2Ua5B6jRpRtOuOU1lpEOS4tYC2zMeK3MmwsGR+m/fQzem
         qVLYDKIOQHRXnaRJUPvY7CbYhbKMrdabqzQ66J8bt1jDaSsAD3jD4+hJ3C0N45D4H5yO
         wdYkfbRrDXCRm7W+131StlUXH1ANcVVigKtCby5VJ+AUF4dVYS126OmC7XMXsyZxz/rQ
         D7dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248758; x=1794853558;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+CkU7K8AN4V+yWUdhaz7RzC7M7eZI1Az06smW8kAgic=;
        b=CvTScVGMDT4g66WlK7w4HHET9W1eifDFoIT+VcU0jonvqLg06pdhQz3Infylp1FHwQ
         +GJuq+Ek2gK9MSDT7cMzQJfz9s68T6FeiWhq4tGXymQrF9dFhk4TQUqwkI9pXhk8wgOI
         MoXUDj7E25vh5u3+Sw9ufC/zzfQ9dhs9ZOSi9sSAPzZC3lNa/6wh2rvCtB0ik5Vrr4B1
         PBsJ0Xl1D7rXnb4ss2/bYuqaIN47UFrusYg9YAPbkXHlDiWhfba49lPRiIGxExsT2L6o
         jEaIn6DqYJyF9KEpFkg3Z4j2qvvn4w1ecQzpJdE2dhGPKFK6y6is2T8UhAE5SO3mld/p
         ncPQ==
X-Forwarded-Encrypted: i=1; AL+hErFGTCJMSfJIIkkF31S2vtsQteLF1/yxT011UwNAyjOqc3eMKEKr04yTTbfTRzvt1Sa/Jx5ystr6Nw==@kvack.org
X-Gm-Message-State: APuU4Z+IM5kDGZic0GUDAOxoBaxur+zKKrIEsa8UXV+N6KxApiTgHKKv
	U5AoxQ/+g03DHP1MiCoAUO28quj5iV5vKM2SiXOcygqHk43qafeEF0BmxhR+F2wEnivasx4nEmG
	pVpg8Bw==
X-Received: from edqs3.prod.google.com ([2002:aa7:d783:0:b0:6b6:fa4d:3bb9])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:1f05:b0:6b5:7872:3905
 with SMTP id 4fb4d7f45d1cf-6b756afbbd0mr357136a12.31.1794248757581; Mon, 09
 Nov 2026 10:25:57 -0800 (PST)
Date: Mon,  9 Nov 2026 18:25:28 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109182533.3594984-21-lrizzo@google.com>
Subject: [RFC PATCH v2 20/25] net/libeth: Use GFP_KERNEL when pre-filling RX rings
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: yksboxfsyh57za4wx4keimuaxiztjy9t
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5221810000B
X-HE-Tag: 1794248759-88736
X-HE-Meta: U2FsdGVkX1+XUUaVt4M6nrXhMR3hztQ3bohaNs8AGQFpmAQ9tj67UE836thhxGLg/ImOBDHNBqTrm5hI/h8FIL7MxU/RrziJPjqpe9IAoFZHULlsEAlsyW0ibsCNz/k8ndU38xzB7qDbNeQU57XrpGMrSYgKwjYGpSuUX2bwaNoBe+rDhcZDtKBpZDMshnQ/7F00QJRAK6eAAZkdO90KkxivonBALIzQHMj/J2JWosuWSd8csZ6SuGO3i7/7TwmMmIpZgEPcqcyllHIhMZJakxEYZFRtoAgVDAO9/Q/kNtQ+7cH31ullWFaWD9qrQNFp6zvjIbHKDvsABIiAdk4Vq5anKIEbergIjtrYXFV14ImPpQMAIMs6bmMpbSlFh0eLbTJoS6B/ADsHmLL+YzsNz5F/gKXxVTkRhw2U5jiXR99y5R0laF4DY9LAnL3hQ2z25IK6eQaAt1GTgrZcznHVZ0zrnBI3t+krnPXmkw1pSxYav0ZFfFJ+wVXTpH1NNkvxb+r0nejX1h9sA3KgCATG8/VjtSxwjQdAW07lYYnS06KM8EdbzpPayk9TxHq4+nMzuAPfgB772ClchvQ7iQBx+mvemFFcef+sdGq91P5f0AE2rIc/aU3Cpeu8qQNCuFRd1JKF8MOD1NT1Rd0NqRk3J/HrLgTLEB5UxWOenO8s0etbjK0wcBXINyiqIp4RWFAtgQPq3kknfYgbsg25x3+gk0ZbiFO+cdEqdBgyI32cOmO94+vix3780H31x2Zh0mqILdcp+w4qXgdYht2mfYFJc2gzKFAIoxFhBTX2DtD8Oz+uRvjXiGMXFi0NRZIhgIFeYvLyjRPsxnL5g7Bda+QkXv69kEhRz4ysbKD2uZ3wtIligPSZbvytyw1dmpw76yIfo6hbfn9S/c6pGjINsGY70sROlVFMMFSSnEl48wknGu6f7Ar1gdMOBr5rzWCMPVFE0YDdwSgWIjWgzie5b5+
 2bp6MpbN
 AdOA+l1LjSU4j7/3bypa+o/7kjgjl8QntCySwZ5DK9BsCoiVvEXqmou1g6e5fQt62y9w2ZyhLcJcNxIETAnNz6lxqf6NhSj+Yp5UtvGH2HXMyC2TGIoSB350KG742e4VHzKGyYWeVbcpUTpDxqvqqOIK4gPQXDUpJAi2h3U/wy0o5NvZVeX0Js52tHwckLPpj7E35KNPpIJ8+QcJAj0KruadovdlBcpc7nhvBYYzyL0xQYkosw4gb9qcMswY9jym6CcOtCxOydNZCakksu2Oza2miLilTw3vPiuQBDkLO4iJzDwiHGcCSRsgMEyD9IXMq+3E6CBUxEyQpw/WNipIJWxpRo50uWOR2C3WAACXQJhAxsqK4P3hpTJpDBfx0f7qGGy1xwUuqsSp3ccWDh3oYBLRUv4zYWqjP0MAgs8rf5jn9u9XC48odZe/3ulMKk2Yg8HF84lf87IXEYYEM7iAIDbZw35z6i6ulz4G30+QgYrZ1EQWCSTV9ydgJ0Az5Bk6BrnPVLppm2VZcxiq/yXboqYiXh1KlNZgd833Jsbl29p2IHz7+fyWDDXZtTgJGDYN/s9xXo52S0w7SsyIjfTdVKWqNzbUANBL06qfCtvbDlh2e/EsIJU4yrM/sQo7R6lVd8LYPSC7ID9Kmj8N08PVm80qss06UYhyz4foB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

libeth_rx_alloc() is called both when pre-filling RX fill queues in
process context (for indices 0 .. fq->count - 2, when buf->truesize is
still 0) and when refilling RX buffers from NAPI softirq.

Use GFP_KERNEL during the initial process-context ring fill so page_pool
and PISA page allocations (including set_memory_decrypted() under CoCo)
are not forced into GFP_ATOMIC context.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 include/net/libeth/rx.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/net/libeth/rx.h b/include/net/libeth/rx.h
index 0e736846c5e8a..de1e5fe44aa40 100644
--- a/include/net/libeth/rx.h
+++ b/include/net/libeth/rx.h
@@ -106,10 +106,17 @@ void libeth_rx_fq_destroy(struct libeth_fq *fq);
 static inline dma_addr_t libeth_rx_alloc(const struct libeth_fq_fp *fq, u32 i)
 {
 	struct libeth_fqe *buf = &fq->fqes[i];
+	/* fq->fqes is zero-allocated and pre-filled in process context for
+	 * indices [0 .. fq->count - 2]; slot fq->count - 1 is first allocated
+	 * in NAPI. Use GFP_KERNEL for initial pre-fill and GFP_ATOMIC after.
+	 */
+	gfp_t gfp = (buf->truesize || i == fq->count - 1) ?
+		    GFP_ATOMIC : GFP_KERNEL;
 
 	buf->truesize = fq->truesize;
-	buf->netmem = page_pool_dev_alloc_netmem(fq->pp, &buf->offset,
-						 &buf->truesize);
+	buf->netmem = page_pool_alloc_netmem(fq->pp, &buf->offset,
+					     &buf->truesize,
+					     gfp | __GFP_NOWARN);
 	if (unlikely(!buf->netmem))
 		return DMA_MAPPING_ERROR;
 
-- 
2.56.0.542.g3ef89b7020-goog


