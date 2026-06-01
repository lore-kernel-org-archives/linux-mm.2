Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF4AECD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 300F56B02DD; Mon,  1 Jun 2026 04:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D8426B02DF; Mon,  1 Jun 2026 04:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6F16B02E0; Mon,  1 Jun 2026 04:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0BAA46B02DD
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:49:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6246A05CA
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:49:30 +0000 (UTC)
X-FDA: 84830720100.04.849A4A3
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id B71F140008
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:49:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AYtaNYJl;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780303768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zs9Ftk//Eli+AipH1EmAF2SPdnVVPcjuiC9Ml1N6W44=;
	b=4lfDAMoL64OyqKZOpBOmgvzwOtn31GmEsK3W15dDSugv3Ncaid7F6Is0G/RsmfaCyKFCBP
	4TLllGtN9Alku7xa8mjHDBnbPiNNul5hPXvp6qvFZwImv53gsTZ1VdSJJuyjgJkl951VFQ
	kGl+LX60OW+zhMQ47x5oTzTFJjn/VJU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AYtaNYJl;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780303768; a=rsa-sha256;
	cv=none;
	b=Ydcn500dsUryu8XB7vb+kr8b+s3Og4Nn3VXOKoOLihvH3Ipj5Qs+u0AeRL4A5um9YSgoca
	CjnsOCS1jwFf0TgyCW25UhadXUESSIcRomwoEzjYwmD0Nl7uls5H7lXSH9J55yd+soLNhS
	gy9cXheaq0lQoBQz8NjNMLjn566/0cA=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8423efad617so429292b3a.0
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 01:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780303768; x=1780908568; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zs9Ftk//Eli+AipH1EmAF2SPdnVVPcjuiC9Ml1N6W44=;
        b=AYtaNYJl7p3WN6zijji1zdo4GE2TpMNrell87jg3+JybWx3TTIarfB0C/9kHeVRjKy
         T59fB3xUaaArB+zWIhw2kdyUJ2hxJtf7RZTM9QRdVWHyel0tUiEfKrbCTy33kxR7o73R
         dq/vGF+UD0hIHa8TYbWLXsbYR+oVY0serk07MsqcChrVjlO9QdqUWMIayWbAbO6EUeJD
         rwrMI/Flcu1/06x8B+6eNVhAupEqClONlU+6Z4wGtIjaUxvM6O3NslmVoyvMdeTj2El5
         E6fFAnB2DXPycKNUfGmmDNNGOjKf7dWs1RgDwktDhwtqgzdSbIJ20wPEf3B9Fb0yOMMZ
         uVNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780303768; x=1780908568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zs9Ftk//Eli+AipH1EmAF2SPdnVVPcjuiC9Ml1N6W44=;
        b=bNO9Sj/LFB9icRxwDLV9HTSCpKksCpP0a33PUQTL62+/+IIAqaTEYn3upaYKawYeWl
         cWAvDGI5NqhuWYM8/f9AbDu1A/LZgu11wY45nZF5UqDkZgQ35tSVZDbMObv2ulMIDJRf
         kh5XSfGJdxx9HaeMN4xLhxcRusHmt24Py+VNRmu1FraepS1TMcyToYEZOY9Vnby5zU9A
         ky972gEvhWWcrQemJG5Big303GClGMKKdJRj5M31V09d0p6BI8oRIje9TZ03oRWRopwo
         qmwWCA1np5Mo7c2GnF9wKKsi+NGa3vs8fy2ZHXN9c1hXmPlwsG96mZM36E9MC6Rw2044
         3vAw==
X-Forwarded-Encrypted: i=1; AFNElJ+axgJqczgIWlbTcNi2jFncaXWYOP+HaNahmgMWN0c/nx03RkdABJErZldl+OGBHT0Uh5LPpOul8w==@kvack.org
X-Gm-Message-State: AOJu0Yys0X1AaqJDfWTOLRupuZ4pqsjLcPwRJudV8m6CeVJLzXa91qhS
	f+rSG+FmGeHF3V9xQg+CC/H4LvEkFg6iark0nBiW7Y33Q305IFGsmHCw426LQ4U9C00=
X-Gm-Gg: Acq92OFdhHY6uGWXQ5qT9vMfyzQNvFcGSDvJjg6UkEjyjtWA44D3/0EZQx61AIczlSc
	oDGZCgZbi+uyAHFQUFse/twFxgQFqwMiKmJSYOl1ayTBOHCjf7VdIXQdvefJT7WpkjElForej2S
	xwUBgdgM3fYoO1aH8n1GK6juOD0xreXvRlyaH8rjKdWrdLEOsBjAfryPmm9s8uuHhpfU5GfuKgj
	ORVWP9yxMixBhVaTPp2BqesICiS5wYQTlel/4UiTwEd3wry5x5soYDzdmIPiVOWVlWbmOcx5VlJ
	3loDedeDqbY3/gbjsbtoN5iIIWcDYQsqAUxyBArIjd2d/1AsDDwnMSvp7ZXikkSJLIiEhmd3o9I
	phTi/qJgI5hVIsFZgccbMCk5VGBie7m+HGcjwcXZQDs4SXVZG6lYh3Nr4EegtzW3mQxsDjsNWea
	yQDQN0OlDK1L/9nXq9eQYLdtaNe5twNIY+MRPLnOlqyJ2hucxcIJjZzw==
X-Received: by 2002:a05:6a00:4c8b:b0:842:43d1:4b41 with SMTP id d2e1a72fcca58-84243d15007mr4884011b3a.47.1780303767463;
        Mon, 01 Jun 2026 01:49:27 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84232ef8172sm6316230b3a.12.2026.06.01.01.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 01:49:26 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>
Cc: Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	WANG Xuerui <kernel@xen0n.name>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v3 5/5] sparc/mm: drop vmemmap_check_pmd helper and use generic code
Date: Mon,  1 Jun 2026 16:48:44 +0800
Message-ID: <20260601084845.3792171-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601084845.3792171-1-songmuchun@bytedance.com>
References: <20260601084845.3792171-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9npo1uau9dtqqwn3uxqus4b98kjwt1ig
X-Rspamd-Queue-Id: B71F140008
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780303768-328319
X-HE-Meta: U2FsdGVkX18k2iiKl/ggkHz5Yc5zVP7QzFVS8uW+BpR82TlyqFdBGOOtzcAAH+veq0e1HBinEeLfc9nvN8/5XcDn6idx8/LlgWqqB/M+KsmhwJYhbf8F+Mr5/IlfmpJwfDRhX+sA2YOqk5191oUuYdwWh5K1p63D4m9Qo69cVfvL/32zsYqaey5GwMl7gncUi5P5nidqXVZMaOx74ueu/OqePW7ZcAA5cj6hcc51YbFTp2crCkzK7W108wPt8Ug7wQ7in1ftlLLnUVe+6IXjg8gecQ5z9L1UZPDeKb2ldxusYhDQ70zvUd8s7j67+GcjQRDEF+YRgYeDFbKaCobTu3kmiOVRwA+HALTuTGkA73IryDooWFXotR+1Yo1WgB+/WQN6cCzHuJS9pfa2RzyMF00+soolXEXuht8rKpmXZnpugNwfIaEZJP5zfHad3qtZ8kv9CW3T+1Dp7IIj8oQS2mbpS1A5UY/Qlq2hrDAxPN4fQZr2yeYiEActKr5gRLflRk4N0T7DMqTO2Y4vHXS4Ij1pIRV1ErUh4u2/nl5D6vD3EJAVWzLWwAYacHRuquYKNr5MRJ+WPzX2v1uUCXz9WALeescnQCt9iaKSEVtS3rfzGBhie/58BOcZnWNwlrQiFJYWRDfcMDww4quIxiQ4rHzeb7TWIbWAawFLOFBL00TO63aG3O91e5XLo68z9DIPMHlSh6ZM+dgBLnvfutTq1xfoivL1kUrbXLF3ZyZU2YXHa4Q13bFJIBge9TrDRF5Y8X4BLpT5fW+YtlRjjdFLWGHgOc1YtxkGDpSe7cJx5IAEma7l0z22+vIMjya1e+1hBoQi/5NylMZBOlhPNtaFpf+ObVNA7rRhZRW24/0nHffc7UHAbg30roNwpPX0jg+nsSI2JUeIlas1rkv/klHl5beqfvt1pb6utJgH8jcZi7UoOLfmSpVFJKMIDsSKFi+IS6t7w1HoXBoFrO+0dRu
 nSY723Qu
 dsqq1c9pNqsmC5wMDz2//vgBG92FCvKljF56xKJRFe5L88l2QOrHD6lTcSgcgORPbHM6MbyZWKNmGgt+jGT9qtb6Htj0HjTNliT3jR6w9PlLZ91uM1bgX/jombzhUYA0HFjge2khwoXf5cXFfJ0jM7bxMqbDASXt/gZle99eIehvTU88RzSJ6dQjocHmiF1Otb5Wj4w1EitNDpN13hQoj1giC4DY/DvyGkbnX+v2W2T0gEtILFiH+erFep4rdCtJe19/tprX5YimiRE+5KYzCLBpNMircikafVV+1/MnrUFl0F14V4dbf1VJNofx9V83fH4ElIHxoV6VWcuHnLRE3qh0PQAXVUprUoiIRDIuZOouAjDU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The generic implementations now suffice; remove the sparc copies.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/sparc/mm/init_64.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 3b679b1d1d72..103db4683b16 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2559,17 +2559,6 @@ void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 	pmd_val(*pmd) = pte_base | __pa(p);
 }
 
-int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
-				unsigned long addr, unsigned long next)
-{
-	int large = pmd_leaf(*pmdp);
-
-	if (large)
-		vmemmap_verify((pte_t *)pmdp, node, addr, next);
-
-	return large;
-}
-
 int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
 			       int node, struct vmem_altmap *altmap)
 {
-- 
2.54.0


