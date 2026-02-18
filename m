Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAB95E9A04A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 17:15:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 466BC6B008A; Wed, 18 Feb 2026 12:15:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 359B46B008C; Wed, 18 Feb 2026 12:15:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17F5D6B0092; Wed, 18 Feb 2026 12:15:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 015756B008A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:15:07 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A518F1B4827
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 17:15:07 +0000 (UTC)
X-FDA: 84458227854.25.190AB04
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 511AD40015
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 17:15:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IUYGgHHC;
	spf=pass (imf11.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771434905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=42FtUK8DRzgqq7HgnylfgEXKEQfWmOW3Tw8CmlqQgJI=;
	b=QBfwvAnuCC8fJ53wgpSKqZhLtMv8vgbuUZHWzR5VIdJu1mJpf+r+Ki4VN+NQLNEtVO4UVO
	MV4NyxlsmSgHXebU4k0AcH6bp5q6yOXCM7IEYiRvNFdaHuY0rIvZDAuUHPWoaGM8LbCa7S
	2/H537c9L+2E2JG081mvqE3nL15kSK0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IUYGgHHC;
	spf=pass (imf11.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771434905; a=rsa-sha256;
	cv=none;
	b=w0ZXM/Zn9phbpxGNui4kF3iLA48By7PRGT+Z2Fn+U0URVGxmSarX8bsTviQGtzQJVG8RSA
	xwQQSsUuLHgAiRTGk3JKXALCX7JJq1uDIaugHAn0uALvERE7/RFv1b2CamEqaP5KkWNAdH
	iIX5heIWfSQHnAibiuIQ7PhCJBsUhCY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771434904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=42FtUK8DRzgqq7HgnylfgEXKEQfWmOW3Tw8CmlqQgJI=;
	b=IUYGgHHCy36LGtPIudFHAmrLD5P/hAFxd0EXCCklHj7xF80ceN6eobU5zsoBd96uBJZvqL
	LArhMJHbz4g3SJf1VIripW36Ju/vSLQGl5k3ZLSxdWOLX6SsC6slDl3vwTx5cVtVEbu+0R
	T/HBjaZbtyiwSKTvT6U87cXSLi0j5M4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-AXyUU0DePWKUKt2XfTnPIw-1; Wed, 18 Feb 2026 12:15:03 -0500
X-MC-Unique: AXyUU0DePWKUKt2XfTnPIw-1
X-Mimecast-MFC-AGG-ID: AXyUU0DePWKUKt2XfTnPIw_1771434903
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c71304beb4so8682985a.3
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:15:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771434903; x=1772039703;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=42FtUK8DRzgqq7HgnylfgEXKEQfWmOW3Tw8CmlqQgJI=;
        b=nPUbQUf2a7SN//GC7DCgTaiVnUk5Qv6ueLaJq7IyiewAyyf2MA4m722Vykg5gIDupY
         sZY/0/zO51HczE0ngjehpbnHd8eDCszzFGqvlc1aUKfveSuW3xWQ0r63YpN9/EQe8NFc
         7P1PQMd4gUXbeIFdBF+Ic8Gt/b2ZYcHFoeRMNGaG5Znq3BFxO/KzFhEYlRs9k3T81ayJ
         zUE9jO/gk6nq3C2xdt4hwhyCgDBa/PpMa43cZwLOuAZfvgbM7iG4s/uQSmHhtuRUiite
         qu2bsDRAecL45YG6847wLsQ5/1NjXJYhwDINIwVrMMNMAQGjE71MGv+SaiLGfXcKpupa
         qTIw==
X-Forwarded-Encrypted: i=1; AJvYcCXi+J4GoCzY/PVmACCEnoDVNsOKxRG/KBI727aPi21/tjlxucFdU0/BeV5pyUEd2kIiZPAhN0HwwQ==@kvack.org
X-Gm-Message-State: AOJu0YxpG6IbdP8UFwoAtmx0z5WjAs9Ny+r+ypSh5/QRbjXjaPicZNz8
	+997Cz2gA9hQBo2fU+x+0JxzYNiviRH+f/8EPgoY7ZHTW+PhfErUpv+9lzG8w6FpiDF4eLo5ESU
	YzWZ0K8+/7uWdl0fSnSBDHyA/S1CvkPWq/5HXpCiJh3VRcWMbyDpS
X-Gm-Gg: AZuq6aJekzvN7SkAhN3K+D31j9gW90aB8umZKHuej7YPHs9r2gScrhlFoDJSRivj+kA
	pr7ixiIWDVLwawW5QD2+n7QHn5vDIt1NNNyVRnpjt7z3WKWtzYgIUKN3pPlKg7F3TyZQhWLQW/a
	+ioz1jqlNrtJTiRLcJBIRRDvpQpfKBrcZClbZcTZa7CSrkNIo3xr3mDh8aqlPiqlz+ld0b1fxoR
	93er9xnIM/JOekExYIDSVkAe562c7LA9n2y+swn2qTROIsAvrKCseandBPoq6+Zjtx+xdBVdJtt
	9PJWErBWunhKfoSW0YYoazGQFMr0uXZFDxT7Ct0A+W9nFAVU64xgy1nQp9GySXyXHbVCu8OxHZC
	VX8q3urPQusnsFRPnisGmZPoxidqXLqGHWPud5YeEnUnIsEr+wIHWwebTq90Lgsw=
X-Received: by 2002:a05:620a:294b:b0:8ca:2cf9:819c with SMTP id af79cd13be357-8cb423c2500mr1979540985a.40.1771434902636;
        Wed, 18 Feb 2026 09:15:02 -0800 (PST)
X-Received: by 2002:a05:620a:294b:b0:8ca:2cf9:819c with SMTP id af79cd13be357-8cb423c2500mr1979531285a.40.1771434901901;
        Wed, 18 Feb 2026 09:15:01 -0800 (PST)
Received: from localhost (pool-100-17-19-56.bstnma.fios.verizon.net. [100.17.19.56])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb3a3e9adesm1523117985a.49.2026.02.18.09.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 09:15:00 -0800 (PST)
From: Eric Chanudet <echanude@redhat.com>
Date: Wed, 18 Feb 2026 12:14:11 -0500
Subject: [PATCH v2 2/3] cma: Provide accessor to cma dmem region
MIME-Version: 1.0
Message-Id: <20260218-dmabuf-heap-cma-dmem-v2-2-b249886fb7b2@redhat.com>
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
 linux-mm@kvack.org, Eric Chanudet <echanude@redhat.com>, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 35r0PEk1gYwG41s16aZNdTlhVvJHPXf7nKRXnrItaOw_1771434903
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dpdtpd4wp8thfhkpbjocmpsi7kia4j14
X-Rspam-User: 
X-Rspamd-Queue-Id: 511AD40015
X-Rspamd-Server: rspam01
X-HE-Tag: 1771434905-880486
X-HE-Meta: U2FsdGVkX19zBr8YS4evdfGvPhUWRzVxkOMOjWhwDK85ycpOoXb5+qBuAXxuQWUB0j2PaQmUIfVw3RJfrZffq9DcSfjLj8+V8fgzuuHzKaHID7KhMwUi+rb+gZCjn3DBweLimSRh7BBBPpo2mbFvTiHw2c1ElhpvGtrQDMpP2C6dtPsswCmcZcqoGbIWKQez1RTeSWB6ARSFgg0OFLh+CGD2jdzMHfbCy1syi7jK2hViLbG4dz8Gsm+lAUcEKEdJyDzfzpRwqhil6YawBvrmlR51AjC5/yKZfgopyQhnkcJtbprmIcqAEYbFNXfeFok41WDhAccmPkG0IBgKvIXZfQ3ecKdpqk2724zRKWUjaK+mQ/PhWArvPuZdGCrbU85FhFacvkDRBQN36rkCFNQ4CJ0Kf3gdsNpefqHhJ58/YAVPAv2P+rzNnrUqBNEN1jD6xtmDUrA8cMUgaWEKogkeD73QG5AAxv4i8n+81A4er24i50PTSvbS96/oXts744tqFPTQvrsqSlQAEPYlXgaFuVkaUmYAD3Tj+y8hTSev/P5qH1UEmX21ww+drwQsHT5QS1ThtIe5R38BRKhycL0uB17ExGHcWAQa6/ZjuRGDpec1hDiCE8CNO2D2QXZtlwM/sXdVg7wGteKvOOAA7BIIS7FvhYXTYfu9c85SNpRHTqXNPnJJ9OZWrbvVUmCh/m7P8Dzo7/fi/0tzx8+wIN6v6hQuWKOWza5msUr8oxAYBOLruCtwdnGpDBIlDoROp0w6Lb1uGet2Ms8v/SD961PAFwq6ICQL8WQQHXu2uz0VUVXlQ+5DfVVRtyIakQd66z8SZ+ZP38nWS7qWKg2yzgTt6+gKsHsh9XAGz06gAUL75dT3YeJDK8Ycd3xt+gT3ES7PHX1A3g6iOlTvlUkyLSiAPJt9yLNP/ttf1DpPzHtqq6WSXKNviRswtR4rsSzOQtD20xZFC5kC9eR4ly/1Skf
 9XUm4Av6
 nqW1sbRl1qYYOSUhb9v7FUhI7CXCWQ12RMPxCWftqUD/RDmrk3w/goy7GJnIQTKjxzvRpMMjMkcuopDDtXWbsvfUK/7EvpUhd1UfCXv0XdmoQT0UDYPdPmcqYvtKaZD1h5ILihCy0E1nC3FUzwqd3jGtEYmWM1n+k94rHgkDD1VaWPBuoaxKJiYdZL/BntgGUZiayxanVSDHs2WtkFLC2Catp2nLVDL+3gcBQmHSSyd4wASKxfcEsKmOmaDyk4UmCKzveFFx1+aZ3ic+xr/lRA/d3fYbIN1FPbRaAfUuZn4QMiEIguRRkxOyDguyxpbuP0Wb/MialuyIqA5sk3Tg7+jXIexr4NqkOX3mJNfO4oPYPd3zAAHLx5fc1BLnyHvF/6zBszyOXq9Tu2p7RCajp9RhP83FB3n1Hwg00cMSgrMeaJ5FzKO4YlvFXIubvw1Nd149uintB1iiozPdtBNiv9o6aH0oj3accLAYko+nCRYCuKvs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maxime Ripard <mripard@kernel.org>

Consumers of the CMA API will have to know which CMA region their device
allocate from in order for them to charge the memory allocation in the
right one.

Let's provide an accessor for that region.

Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 include/linux/cma.h | 9 +++++++++
 mm/cma.c            | 7 +++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 62d9c1cf632652489ccd9e01bf1370f2b1f3c249..8ece66c35e9e640b98db4b24a9bd118ad07ec082 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -77,4 +77,13 @@ static inline bool cma_validate_zones(struct cma *cma)
 }
 #endif
 
+#if IS_ENABLED(CONFIG_CGROUP_DMEM)
+struct dmem_cgroup_region *cma_get_dmem_cgroup_region(struct cma *cma);
+#else /* CONFIG_CGROUP_DMEM */
+static inline struct dmem_cgroup_region *cma_get_dmem_cgroup_region(struct cma *cma)
+{
+	return NULL;
+}
+#endif /* CONFIG_CGROUP_DMEM */
+
 #endif
diff --git a/mm/cma.c b/mm/cma.c
index 78016647d512868cd87bc2c1a52dd2295acaaf01..c8b0de1da3e71bd6b8ab749ab58eb27446a1657e 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -53,6 +53,13 @@ const char *cma_get_name(const struct cma *cma)
 	return cma->name;
 }
 
+#if IS_ENABLED(CONFIG_CGROUP_DMEM)
+struct dmem_cgroup_region *cma_get_dmem_cgroup_region(struct cma *cma)
+{
+	return cma->dmem_cgrp_region;
+}
+#endif /* CONFIG_CGROUP_DMEM */
+
 static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
 					     unsigned int align_order)
 {

-- 
2.52.0


