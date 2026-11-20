Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55F9A606A60A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 01:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hjAiVonU
Received: by kanga.kvack.org (Postfix)
	id A15B16B0733; Thu, 19 Nov 2026 20:07:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ED4D6B0735; Thu, 19 Nov 2026 20:07:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5046B0736; Thu, 19 Nov 2026 20:07:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0DE6B0733
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:07:29 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EFC1240C1E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:28 +0000 (UTC)
X-FDA: 85453709376.19.F1A966F
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3AC8C140008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hjAiVonU;
	spf=pass (imf26.hostedemail.com: domain of 3TZ3_agYKCOQRXOffUMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--lrizzo.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3TZ3_agYKCOQRXOffUMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795136847;
	b=sdkBKaZpfynSRpH4vrpbyc14+wkmjPxIKs3SIpJGG7a+wakw9Jq73TspTefR8jj7UfyGiz
	MLRxt8fr0honAxElie3SYF6tgWVal56eW9f0tTTs/Sv0DFdnSUHUcbXBz+uswCWSWtb5O0
	LhXXAkjNmjby7Iksc2+nPM5dOYyjjZU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795136847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G58QRfdEQzG7y46akZhuXorptjXMkpo3OuC8LCJ2NV0=;
	b=K4jh87HxNcXytXu48vEG4mXTWma9oixu9I+mNBv13XQGcQwnJHfq0956SaLpqswcUPDkoC
	KRKza+lYrgemswwUVseBt3tBbfZoOLqUaUpNMysyMukIkxZza5H6Tnq0L0TYI+LsD3+Bnl
	n1ysG65PNMQ2B+eYv/TXlA/eXi3YEY4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hjAiVonU;
	spf=pass (imf26.hostedemail.com: domain of 3TZ3_agYKCOQRXOffUMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--lrizzo.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3TZ3_agYKCOQRXOffUMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6b586b0a795so256104a12.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136846; x=1795741646; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G58QRfdEQzG7y46akZhuXorptjXMkpo3OuC8LCJ2NV0=;
        b=hjAiVonUTC76eR2PChogoPfQwDGepWYDxSZp70NjXArGic502PlM8ITVqEr0QOCuE7
         BnmsSrrjULAgZ7oatg+ZZVTcRaGlmAo2TJ7K6FYL0GXVGwzPuuVJCd94b5UD+ua5t0xR
         AvXGSyc+yv1E0570p/psTBmuZeZ3UzkDE6mcWAAB2bNMLaOIFJU65NWMTnwKrTKgRIcK
         lepeKSjPVzUEYL71WEE08o0W9OcpWO2Vjbh1c5wJD7eGHwX27H4cIhMpBeLzG1RYGBkK
         247M/eEvmaoXlOjFCpnDth6CyU7iaBR42r9ujvFyi9ks6wQa1gmogV9PecsT48qXuF13
         sduQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136846; x=1795741646;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G58QRfdEQzG7y46akZhuXorptjXMkpo3OuC8LCJ2NV0=;
        b=AaFzWCLQtcfoB7XgkG2v7tf5i3FKjnISJhP37obz4hw01vbBHmjAO3THVHgnQg1l4F
         C9Fp2k99MsO+liPnhwTFp2koA6k+FBCEkLXb39VTED+uftUBLhI0/URJrbAFt6LixYTc
         /UjDRdDTeG7Xe8AV3Fk/LaTp4owySwmIYqMDdqjFqrptW5ZSaWgAyLIOTisywGq8iIrO
         HCc0WWvuh9MuNjQSrymAgwO082nSdrvuzG7Hlqwn2jKb3lAbE0s+JlpBJpvowzDZr5fP
         zWe8TYYFIXLsiFbbDqtqFOj1bePAUw/sAL6A8XdLla+xjXxYO2BcKPEBgiVreCNIC15+
         G0kw==
X-Forwarded-Encrypted: i=1; AL+hErGzx/nMlgMIYEESY1jJjO4waj234LoijvY7KyNzooUhr4RKn0/g5M3d0FHJJGRcT8PE96hhGMbbTw==@kvack.org
X-Gm-Message-State: APuU4Z9/W95HVeL6QA1jPROPmZ+TWuC+/otB0Fzn54xYgU65ave52zqj
	eyF9NOKkHW0UP/CmvyFBZ5JTNWsiUrzS4jPsoKSdIn9LrIDSHs9YIsowW4yJry8h1HwjR2d4KCA
	cZvvf5w==
X-Received: from edag35.prod.google.com ([2002:a05:6402:3223:b0:6b7:7926:2af4])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:1c05:b0:6b9:c43d:892
 with SMTP id 4fb4d7f45d1cf-6ba37c7bebdmr666829a12.1.1795136845436; Thu, 19
 Nov 2026 17:07:25 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:52 +0000
In-Reply-To: <20261120010655.467825-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261120010655.467825-23-lrizzo@google.com>
Subject: [RFC PATCH v3 22/25] net/libeth: Use GFP_KERNEL when pre-filling RX rings
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3AC8C140008
X-Rspam-User:
X-Stat-Signature: tgkbrasbuza8t3cwm8oxh86q8u1m1z3f
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795136847-329939
X-HE-Meta: U2FsdGVkX18FTZNfglSAoh7pVBlZVF9jHLt44LTmcyR0L54YcWMS5uBo13TOHTTmC3SrDC18k0kdT5yDloBZGGVFCOWUkQpLgyimkKeb5NtDt5VFvQQ8Y87lH1Ch4lH6aiq77DmWPbKid33aaWSrAAs9vGC/j4YmItGJNxcK89NDAuMgX67CQwXUG/fZElS+PjKTECImXsqNIbW0PJvgXqOjFN7mva2NX1nqvTtDi4Sohr0WjTW0xlVqYW8RP0u0nESIjyymMzHAe5OhZuHCDrqf89gggpYa4ngB1+2+TfqFD0nHl7aIvCVYHjvvTgvWXnJOTKREBbsfSAEDm0/WMUn/pZe22YE5IZqKSvx2vaqm48oncYwjBubm+EnP9KHhaP0IpA8dr9iqLNSEOdM89PCF01L/iy5Qd7fmjOKRzU27sBUGJqxPe21wF4k/Vu/0wRdlrTyMMHs8NVznvK2ylzawJwRCvSlijCKoznVXbUI9IdWD+2efR+oqOsSOLwrV8elvDyQJ2B0cVNKRdcbre+vsd5yjOmqgFxNnvCmwyyiXKHDKEy10eMZFgHkD7KNCjMtcnNEl8dn83CqXpJNpapgMpltMX0e/rsnZ9QIK5s2fECDFo4+spOH7+SA6dnm25qPnEOol35/jUWWQsiQgYBEEK5uvVmU3f2GbPniPTHdwZxRGEEn5Lc3pTr4p4lVMjxyDlkBRJuMJu5tOr1Z6JUHnVEg1RUH7raT6cX/tIrLzTfITh4dPVrsTcMuRnulc2Oys1UdiG4HZi4TEhx4NvJyIzLuqMkzCbY48VoPM4plDAepI7I0m29zLnoZGDxVFJK3mI1roQwq+9E66vlBHHM7Xh7weYSmNbHz6Rbrdo+mB1n5iDgZDPWJNBeFDOxWm8slcvuNcIl9vKzsyJuZWnyIv+3CdJqGVo9JklQZOwFuOV1Dm/CejwgQZv5Lz7XWQeqxxYSceP7nn6DU8fwR
 crMRWhJ4
 CbkQ2Cie+Z//YWYSekaQpbF48X+YC4HaPpxoXcneU0DX5Hj1hiwh4sZPL6Iw0PZT9Bz7vthTjmHTPSNkZdobpBN9vmN+Faa5g3bKjcVlYQgpXkaZN33Q4kpEorgJ1i4yghPDzAwn8IThu1VQxDYMxD6ZnO77NJSO/2DfY01JwN9LV7oZ0bdffTl65xURxrsFzTBZ3wAPKMhG2zycGT9bjZDv+AkS2fAqe+PiQnrLi1dhgWW7H9+bU9LfbJntYRYCf9dpQMiem/P+QN1PlSL6mfMvQL/ZGm6pWc1HrnQrHJeF12elY0Lx+CYbPZpW8Fk23hxEDMAgTvZQAWguXIx5EsUQDEaKeC3p5XSj6pRj8TJnITPlfjGLO79xdxd5dbJsL+79sdkv3sHL0SF7G250ZdNZlPmikx6vXH8t6gTnoWYp2yR1UIB73SncwpN6/mevp5oLVHxjHc0PefkgF3HifA3vRNigrT83fDztKQESj7lAf5dSC+MiJUo85/vXeYuXFAIqHA1Epz1XRxPuOojo+NflnGmlrMvtnIY7Og6mns8WnVfLr6Hn8N0OZYrv96SxfACQyw6z6JMUALTW/0ovUl3nOakGoeqIengolmr5fSh0yXWScLn7+i7LhpXS39vpq4C67hKP9qK1sfpuJef0+rDMeZH2l5VJxTmiJ+IGntMPt/sRW6yFqBxMY8jXUrxqR7KF1B76L2v0GfRgBz2NN0wFnxp9i83iWbL8QrVwXbCsJLKQ8baUl57KGpimqltQ4XqoU9AH7dZxOl7U4s+KN0MxeD6RlQ2NZZAzrE3/CQnhamwbLknXnTw66ioHIXt/8ZMpwmuMstrImBff1YtzrBw1PNPHwEs8m7dz9pU5ckukE82LPq0cBWRH8JmBb8IJBVGn0SKjzd+o+f3M=
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
index 0e736846c5e8a..4361dbcf03cb1 100644
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
+	gfp_t gfp = (buf->truesize || i == fq->count - 1 || in_softirq()) ?
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
2.56.1.809.ga0b61035b5-goog


