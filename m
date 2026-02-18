Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A2F8E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 17:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABA296B008C; Wed, 18 Feb 2026 12:15:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A30F26B0092; Wed, 18 Feb 2026 12:15:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889A46B0093; Wed, 18 Feb 2026 12:15:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 700D46B008C
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:15:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 355981A025C
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 17:15:10 +0000 (UTC)
X-FDA: 84458227980.11.DE435B5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id DECBAC000F
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 17:15:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fzbSjLq4;
	spf=pass (imf10.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771434907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RWROfJdWhlgxA5rcp8Pj9VJ7m2fa4/nREAlFrPf4oa8=;
	b=gAab+Gr5ERdumkyE714Ph483ZbtV1dpvWzMBl8nHXGy6PZCDeLgmobgqaZeRqObJ3zgoJR
	bkhp6aGtJmWPSdA75be3YVoQTMstwAQc48UwWVuEWhy04Q4eKhlvdgp5eUJfubR17sYP6Q
	Uy3Uwus9hBl8SKybgo846R5sNWC9sQY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fzbSjLq4;
	spf=pass (imf10.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771434907; a=rsa-sha256;
	cv=none;
	b=4GjcIOX1LsYUIvlKVAlRQx5C0rQ1tNOcexsvCUDa1PSGvN7IKtYksctuFNh5kVCEwseuGk
	9SFV7wG7ANUWpKtmWeL2PuDYhOuJzxi+tWL9Tzao0lFPVJWhK2+UyW70c9ivnIpkb8+YqN
	ydfG5TQmnD4lmYzUjvdhgWLC5K/YYnA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771434907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RWROfJdWhlgxA5rcp8Pj9VJ7m2fa4/nREAlFrPf4oa8=;
	b=fzbSjLq4lXnacQ+1YA/iPnHiyi7FSx11zMdLy5NgMBB8pv0bYGUvxtupzrDdXT8Eifwn2G
	xF1+MYpGRBLoqpLapqNuhOV/3XtCvxQCZW5fUflPDgsV4tr8GrV23qLlRFMbpiFdKXVVaw
	T//WJG7nnYG5O+LZxw62AYbH0EXT42I=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-wwi2qfVPNNiKhl8m_OoNsA-1; Wed, 18 Feb 2026 12:15:05 -0500
X-MC-Unique: wwi2qfVPNNiKhl8m_OoNsA-1
X-Mimecast-MFC-AGG-ID: wwi2qfVPNNiKhl8m_OoNsA_1771434905
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-896f4dcef67so2034006d6.2
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:15:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771434904; x=1772039704;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RWROfJdWhlgxA5rcp8Pj9VJ7m2fa4/nREAlFrPf4oa8=;
        b=mQ1tvJyKRXfEu8nLO234eqsqZBovj6mcqXBl+4kdT8Qio8g6JKhv71vTjdd4xLhpty
         a6j9TAzP8Ps9A8gvJXF++J+MyT6i+n1B6rugGtdXrYTWdmwb7Ws5qUzdsSCZKL7CQAIU
         FFMA/EcK65mrytamBR4E3XIAm3slk9oWACso6n/QI6ozaUgG4Ka/ogZVrj+LINHKM2qP
         HqC+D2eF8tJSh2IczcIZlDlvIIlHG+0EH2ZvAh85ejscDD5kEFLZV7YPrYri7NjOCX12
         a2vOFJPPv7RkunPzWt/rC0h8tubSrZkwRxzE9fJHUfciQnCR8QdfUbDmW/ueGdIYgD3U
         8Kfg==
X-Forwarded-Encrypted: i=1; AJvYcCU9qAOgMUG3NsuzzDAn75GAGRLUk0xogmk7EDdLwyqG0JTtkaasPJ4Y67krL731cPhxuhfmnZ7FfQ==@kvack.org
X-Gm-Message-State: AOJu0YzfgUkXKyzPDUsAOal4TOxCkYKutu/qiP2pR8/tXlSq/Aj1LYvv
	jjADX2aXdzX1ZXP/OgNucXX1ocl8OLENeLnPG3kRrtVRd5v3RYFXCqom4iIDOLosZNMsbcA8O0g
	VTBrqxRAmJOU/qp2zf/6wfhiV2/agVx1WcTYUMSq/Nj3qc2EoTk0PhZhAjyb3
X-Gm-Gg: AZuq6aJ3g28wIu9FWrpZ7DZvwrfOlUpu1dT+KgxDz+Cr+wKeLg54j6JY+4FU87692k8
	L/DChlI/o7eh4U0X0yYJohOjweesGcA6tgwQYWcnWenEX/pBSfKfWmb8gkyCLkUe8ryqa1PbFag
	KgZFTgqAbuvOevYMkAPJNUcIClsMlVM1fdYY8Wn1n0o1/Nd8egDUHzEFdYr/c/Zu21mvCy6465P
	VQp+KeYjsKEwmTzJ7IF0X09tPhDYxLtechxs+wCG1gESV9d0aTgWlU9UCUkwgkpBIOCxevl8NR/
	DsKC1WqqQQiGwqbmL8704n2nO92K0tuBI0oNcRulCYxwN/AkydUpaDN/CZCrhUQDQ1iDx4+0DsI
	HE492hf2lz922/xx3e8jdUX5VRu+2xqPzPiX1qf6W4EdTEPjqB/UL8kFki3xk54g=
X-Received: by 2002:a05:6214:5194:b0:895:d652:e3a5 with SMTP id 6a1803df08f44-89957fd539fmr37373496d6.23.1771434904520;
        Wed, 18 Feb 2026 09:15:04 -0800 (PST)
X-Received: by 2002:a05:6214:5194:b0:895:d652:e3a5 with SMTP id 6a1803df08f44-89957fd539fmr37372786d6.23.1771434904004;
        Wed, 18 Feb 2026 09:15:04 -0800 (PST)
Received: from localhost (pool-100-17-19-56.bstnma.fios.verizon.net. [100.17.19.56])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cc7f82csm195307856d6.4.2026.02.18.09.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 09:15:02 -0800 (PST)
From: Eric Chanudet <echanude@redhat.com>
Date: Wed, 18 Feb 2026 12:14:12 -0500
Subject: [PATCH v2 3/3] dma-buf: heaps: cma: charge each cma heap's dmem
MIME-Version: 1.0
Message-Id: <20260218-dmabuf-heap-cma-dmem-v2-3-b249886fb7b2@redhat.com>
References: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
In-Reply-To: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
To: Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
 Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
 linux-mm@kvack.org, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.2
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pvFpFSwD3gDNc1lsGrXo5yb8fyw3zjSxmFHBFVGmxck_1771434905
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DECBAC000F
X-Rspamd-Server: rspam02
X-Stat-Signature: hrtwk1z568sizatyz4qkt561bd34gka8
X-HE-Tag: 1771434907-557513
X-HE-Meta: U2FsdGVkX1+oToG8180+iSNNh0fmnWz2/1h7B1BRI6g8fErKi57IBOy6gKPDvthAkcbOvZ/fdVqwyFLjRMLYbv+SngAMaiEV1JW2dM/jGOwg/eHvNAoNYv9gVTo3FqkkmKNAze0DBQrnhbHGIkJPSZUJ1/Ndm2z7+ST1ZhvNBn3KtErT8/GPLaKoP7bH1R4hh4kygdHf7lKPZSadhmNigIydonD+o1HRLYnyfFm/RCsEBzBPXBI5jbIKbi/8eJW6P6/DmtCdCyoSOYBJNjQZ9etWy7Y69xmEkc2d7VzitSdMXDHGJMjYIr1qW1xPejYAxEqDib4w6clvBP54gdIGIydAGlVatGZFSHDEpW3YZl7zm3FxvIkHZcjLxttm1hmChtK/o7/xrd60O59PyoIzOqg7Gr3vircaubJmSCdDhXwKctY6Ez3ziOUYecABbXM560KynzdX1OCs1u566pzqH3MRpWlKZxA5Ft3rKoo01tNCEiD2Eh5mVoVZJBcyuXMnC0HIKvrSWYP6BD0iRnK7t/0RylTippEUsexXn9rFBg0mlzhqShh0g9+I0m/kcLpyX1wBaJOQVhM9RukrGBKIayjlrxoV8rUXxtowRAoVgg8cu3iCLfYygVL8SO8w0rK+pWuWOyeEFOLtpc0p8xjTbd3xbFTYJkaj+Tg0Bf4QwwrPnoG965pQ3J2zs87VkejcSl4O0LZwZiseCkU42LTQPfVqHbd2dCC1aZI9VmDeM9taJRJKZeCXm78E62MPiwv34II34qblZaC8koXNjuF4QLWfa88qH8hVEm9cD14flZQ1EHW298F4g1Oib+JHrXiYfbdWmwj2BueKgSfDImE8yECj4UdxgU6kY4s9xgoXY3JeLQiebQ+EMa+V4GJGA/5wAMlbYn7I5SA49vKOIpjGPKFmub6EzP/dmxgtO6AkaUr2UlACSaIgV5yX4Sp2iIylgoJMGo3da4nzb+8FOxk
 TrzVA6N0
 fn692h2RU+NrAFGYTLK8zIVHNLP7Jz+m0FagzElBvQESZ55xqCu9qPZ9jWZ5pHHuOTzPUKO9r2lPYpNEb1JIVNbf/WOuZONqrwZjKLDFzSe/65aHJ0a/VVPGemGGQHVIdRzgNBK75tQWR4lDBipiyZJmuSKQyUKuXUyVKTbPhwHqqmVgbKTh2vcHpOmrsphUxoMQKoj3Q8cZQTRDhgrgrMUBwF8Hwo9m58Ntziavquwjxg7xLC4332lQFulh4u0aFyxZJvU/wNC8j3TkEHrJKK3vniQDXI4qWF6eOdW0GshHy9sIlcarC9sMx5QgSkQDpxJ+oumHAoficRpFp/K5l5HPS/CPEQoDwMpjLgpDF3+XAtUl9GnWbrRtrl9sO6qHkpFFo0ZSoVzKeayYYrCZh4hUz+QoX3MmnqXRfCH8N6vyS4l3G9SLQvuG9D11kPPEteLFTvccCJTTSEHlvTTqaCb0oV5DJXiTNXcwgdL/U/edTn6OsGcxVQFqBIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The cma dma-buf heaps let userspace allocate buffers in CMA regions
without enforcing limits. Since each cma region registers in dmem,
charge against it when allocating a buffer in a cma heap.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 drivers/dma-buf/heaps/cma_heap.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-buf/heaps/cma_heap.c
index 49cc45fb42dd7200c3c14384bcfdbe85323454b1..bbd4f9495808da19256d97bd6a4dca3e1b0a30a0 100644
--- a/drivers/dma-buf/heaps/cma_heap.c
+++ b/drivers/dma-buf/heaps/cma_heap.c
@@ -27,6 +27,7 @@
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/cgroup_dmem.h>
 
 #define DEFAULT_CMA_NAME "default_cma_region"
 
@@ -58,6 +59,7 @@ struct cma_heap_buffer {
 	pgoff_t pagecount;
 	int vmap_cnt;
 	void *vaddr;
+	struct dmem_cgroup_pool_state *pool;
 };
 
 struct dma_heap_attachment {
@@ -276,6 +278,7 @@ static void cma_heap_dma_buf_release(struct dma_buf *dmabuf)
 	kfree(buffer->pages);
 	/* release memory */
 	cma_release(cma_heap->cma, buffer->cma_pages, buffer->pagecount);
+	dmem_cgroup_uncharge(buffer->pool, buffer->len);
 	kfree(buffer);
 }
 
@@ -319,9 +322,17 @@ static struct dma_buf *cma_heap_allocate(struct dma_heap *heap,
 	if (align > CONFIG_CMA_ALIGNMENT)
 		align = CONFIG_CMA_ALIGNMENT;
 
+	if (mem_accounting) {
+		ret = dmem_cgroup_try_charge(
+			cma_get_dmem_cgroup_region(cma_heap->cma), size,
+			&buffer->pool, NULL);
+		if (ret)
+			goto free_buffer;
+	}
+
 	cma_pages = cma_alloc(cma_heap->cma, pagecount, align, false);
 	if (!cma_pages)
-		goto free_buffer;
+		goto uncharge_cgroup;
 
 	/* Clear the cma pages */
 	if (PageHighMem(cma_pages)) {
@@ -376,6 +387,8 @@ static struct dma_buf *cma_heap_allocate(struct dma_heap *heap,
 	kfree(buffer->pages);
 free_cma:
 	cma_release(cma_heap->cma, cma_pages, pagecount);
+uncharge_cgroup:
+	dmem_cgroup_uncharge(buffer->pool, size);
 free_buffer:
 	kfree(buffer);
 

-- 
2.52.0


