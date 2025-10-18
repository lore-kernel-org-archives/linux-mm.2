Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E072ACCD195
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 17:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9B0A8E0012; Sat, 18 Oct 2025 13:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E24A58E0002; Sat, 18 Oct 2025 13:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02A08E0012; Sat, 18 Oct 2025 13:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A34EE8E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 13:18:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C6B8119857
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:13 +0000 (UTC)
X-FDA: 84011893266.29.7AF3700
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id AE52380005
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ii5Ku7vi;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760807891; a=rsa-sha256;
	cv=none;
	b=7XsZRnSPAQwQFhEnbCLQR+mJlf+qSnNRNLosXclavO3MBr45dFRUuEFvUUfYsaLB8aW1mb
	5iKYH5i6Wmt4SkoFzkOpnuadKK3iZdGUf0fC5pI1E2l8N+ZiRZoN1ubOZeGxsqggTsqA2l
	YBV9Wj7/YFgvu8eyL5W6zXY8Npmookg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ii5Ku7vi;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760807891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFLCF5XN9yDZ1vXn52PKQdU8GeSc6NQJh3Hjw9F38C4=;
	b=pxQHyssk778sFwKfurcyuDdE38NUayCoSnztfldmV87azJ+3TTpsZhJN0DX9asqSnehdy+
	hMYDxbSpht29d2D8QdS8XJwcU1f86OPTV7JPpHuvsMtLuSgsVyf7bUpIXuIkcPZpfT3B9D
	4QIEXwM0Be/5gbS6fpYMAt4TDUeIq7k=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-87c103928ffso45175306d6.1
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 10:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760807891; x=1761412691; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QFLCF5XN9yDZ1vXn52PKQdU8GeSc6NQJh3Hjw9F38C4=;
        b=Ii5Ku7viHpjHBQu4sffOcUc/r+2gVskMkKvgwDZQUW1se1yE8zsj55HlCqoCuarBS3
         OmTO77KloOQ9NtXLXnMgmFAb4viefSclfNppiuDfW/sLcNR5adchVKb6K62yP/VE58A9
         g/9/ymaAV82rouS2Q+vP+FNBx0IVU6Y8/fLO19j4MYUt8f35eX2E1R0/r17bcF0IUfYF
         h+jrO2i8C+96ik7gQkP8lP+o4Z0dSn8GnR5hND9dcILOa7f23y6FLRpBjwVPKvdK1mle
         oRBcPoyA0/uNemdqzuFwvccQbMsH6G+a56mlioTVzCSMF+tdyvHcV5QftaGlt6iVlihh
         z7vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760807891; x=1761412691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QFLCF5XN9yDZ1vXn52PKQdU8GeSc6NQJh3Hjw9F38C4=;
        b=ozd9pI40yEOF8gv40kdnMJYq9iMOEM44YY638fdyL+snUFxWz6+/3zKzEX4dEbFUTC
         xtH8TK9JfY52CRmaR7fHADFxe3j2J+D4Xtbmr5bLFGLtbg4VEqEkEOPv6Nm66Hh88MQm
         XqCYf3hpMiv7/oxNXBH47olprgEVF+ft13IHof8HuVWaPhf3ykkpzGn+iSH3ny6i5qcQ
         gsr4ypHsbSquQFNecOmgfHk5tDDteaCGtgfBh2GIEwYqXWKyv5I8uIQ0A+Aw71xlIAYv
         ob9T0Qi9lp+0f5qmNt735nhoa86a/46cG057UTw6tgTOTWswa0ZjQLLXaUwDCn4rTTBY
         QCrA==
X-Forwarded-Encrypted: i=1; AJvYcCUujuGIFuw7CEJdcouuyjmZdr4VrTxY+vSS7FAb5aRTWF5Xbh2VLiC+N2HqrwHBSsv2mXVJ+NpiTw==@kvack.org
X-Gm-Message-State: AOJu0YwixEdWmT6u/bhpDe4T9viYOGWip6Mb45fQfKq7TOiyMQGkx460
	q7t6b+uuIlCfZL2/sOgi1qAlJg11m0iDTEgcdOgohc8JlAKZKZG2Jm3kc5vn7PfHzFQ=
X-Gm-Gg: ASbGncu28RXyaGapoeTRw8f7ZSkIro4IVunAfV25FpulThvQkP4vMebTnfsv0cABOGM
	edabgVDhykhFyFFgyvGIJj2Yzi3NsZa+5fAWgAEv2st1ZnGAKRWZi9Lf79eC2uk8kCUFRNJe1ck
	xz/pdkNWJOyjjbNVZlDmVvU1zFK/ext8Kbb31bXQgoQtyPYqLKrB0k6/jb5gPOYHjt06hXPe1hm
	mbdW27WL4YKbr5pNCSAn7+EoP0+yAHsZCe1VINb5P8SaPDTatinqakKMWHhKmHV6txKPh5Dt1vl
	/IixWdt2Wqa00rxjhumvKdM6+UbOll5cj7H234l79shCWhEjzYuy/cnmDdsqCbSzNuS6prtpFm5
	0JpUM8gS7BoCrnRd3cSf/+2qdyCZB1jMr6ima68EUqIm5SjLIAIMJ8QeswojPd51bihVlEZ2n9z
	cMVgoVDuteJYC26pC45T4d2T5iV1AIcou5hwU6rBvUfJVc9enD9H9V6kmvwT0loA1tFTAKmIVGN
	V5BPiRrqt9+r6mcWKfLctwQVIxiDEaI
X-Google-Smtp-Source: AGHT+IEbH67r1bkBBr2fGDtH2iJYzk5qXpz4ZuAYuqM7y3IYRwB0Hgi7HzGfKIjAQO2jFT0oN/PwUA==
X-Received: by 2002:a05:6214:8017:b0:87c:226f:f5c7 with SMTP id 6a1803df08f44-87c226ffc83mr105442856d6.38.1760807890764;
        Sat, 18 Oct 2025 10:18:10 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d02d8e909sm18478116d6.62.2025.10.18.10.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 10:18:10 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org,
	jasonmiu@google.com,
	dmatlack@google.com,
	skhawaja@google.com
Subject: [PATCH v6 10/10] liveupdate: kho: allocate metadata directly from the buddy allocator
Date: Sat, 18 Oct 2025 13:17:56 -0400
Message-ID: <20251018171756.1724191-11-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
In-Reply-To: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AE52380005
X-Stat-Signature: uitqb5g1eath8rgm5pabjb3yujxodruh
X-HE-Tag: 1760807891-333517
X-HE-Meta: U2FsdGVkX1/Rqx/EX1a2VmeZ2Fp8EsERZyUpn1BEuNQUPVIWO8ntGjWV6hxeo5nvnebrj5kTLDRPC9GmWnU52lDeJBo1hj4/hbRd/CxXq9Fq6urg8JSdHn3SjuWyFhIWxRBkc5MpkyEsCquu6RINy5rbn2UJceD/UwCEUBMHjiXFVG9Pg5Z+a8XdNZRq7FXmAHT5rdPZmN4vhze1Pf3zfP4FuMwBTVIGNtZzrS0zxLFpAnuXch7/j79zzwxUwnTql4kE/74TAQC9qYGXM/n3lZtLlgXCsQ6QepHboLXUioxvYPyxu/qFxGzDG/mWjwrcvkyR3YpkU+KoAMPMukQW7NMyxQpyiXQxCGZhV1yoDHw84Qj5v0UqFIU84Rl4dcxXCI2UlWX1+qzcstQOWoHYESjeFOl2Gm5kW0QW/E7HWsQx2Y7mVxL1IHE+L7/Lo3BAebTJJLmgleZvuIcWlWs1z4z/F58F8NhCi4riNRC+elD/97fA2i7/GJPsuo5nJ3XihZiX61n3Rw/KdLjSIFftE/UvlfZTlt+HEfX4B2CoW041H7j05u6vb6TnN8LnoLwNDcCZ81uId50fq4eoivvcOrGcVsVahozncUOCRJ3KqauJ6eL8I51taYCO0ToxE53a9I0v97RF5agaU8ITgD1fPZLmTD+tpfghtf3ypNlgpt2N1vUEVGQKhVGiOQ2ybPmPNB8FYfbiVw9MXyE9HcQpkVfV1+Ni9XLQE3e6+yY8N443bsgiHggdgfqPHfXDzq0P01TgQkZIkQ/KCU6rSjzzjMn8B4BZi8ewgAFEgIpNmdEXlkVq7PnF/8xGM9L4/FHKcSXK6DPqKQYy5QgzcSHzZmdYnULKx4dGQiJ+BvbW9Y92RwGpT4aFPSi5i1kJTMmyxnfbpIB66I5MCdnoVRn3VEYtfHdihTlzYqJpfPCio6i4H75ckLqux3HseOUj5rd3dDshJhoPBNuj+FWpAXF
 i3RavcCR
 XpdabrQw0ANfATyGYqAfsAMSsFNE+gf1Ffit3EX2HT1npTB6pv5m3sA5joLW8T8ANuVUveLi9jJj+3Q+imGhDLylM+tOp0TeGnoGvW8UWK9yigfhSkNJ0DMXL6NCrXCrwFkLTl3ELbNNM38PNnbX9FkXOjUxYolH4pJip8+FSVI/qHKFivqedlejqHrtswV275YWl50iNCpAgk3102pK63l+LuhABe74Vq5kBxZ0p1GCLBgL7KwHCGZQ4YGLanwELqoK0WxL+mp1NIPEWsIOnhi4x+FQbQS0r1R5LsAWGLn+sSjeXVIHYErRSn+mhX6tEXRZ8PLZkdxAERERZx5F3ZPm+jF1MxEYIZbmx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KHO allocates metadata for its preserved memory map using the slab
allocator via kzalloc(). This metadata is temporary and is used by the
next kernel during early boot to find preserved memory.

A problem arises when KFENCE is enabled. kzalloc() calls can be
randomly intercepted by kfence_alloc(), which services the allocation
from a dedicated KFENCE memory pool. This pool is allocated early in
boot via memblock.

When booting via KHO, the memblock allocator is restricted to a "scratch
area", forcing the KFENCE pool to be allocated within it. This creates a
conflict, as the scratch area is expected to be ephemeral and
overwriteable by a subsequent kexec. If KHO metadata is placed in this
KFENCE pool, it leads to memory corruption when the next kernel is
loaded.

To fix this, modify KHO to allocate its metadata directly from the buddy
allocator instead of slab.

Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 7c8e89a6b953..92662739a3a2 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -132,6 +132,8 @@ static struct kho_out kho_out = {
 	.finalized = false,
 };
 
+DEFINE_FREE(kho_free_page, void *, free_page((unsigned long)_T))
+
 static void *xa_load_or_alloc(struct xarray *xa, unsigned long index)
 {
 	void *res = xa_load(xa, index);
@@ -139,7 +141,7 @@ static void *xa_load_or_alloc(struct xarray *xa, unsigned long index)
 	if (res)
 		return res;
 
-	void *elm __free(kfree) = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	void *elm __free(kho_free_page) = (void *)get_zeroed_page(GFP_KERNEL);
 
 	if (!elm)
 		return ERR_PTR(-ENOMEM);
@@ -352,9 +354,9 @@ static_assert(sizeof(struct khoser_mem_chunk) == PAGE_SIZE);
 static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
 					  unsigned long order)
 {
-	struct khoser_mem_chunk *chunk __free(kfree) = NULL;
+	struct khoser_mem_chunk *chunk __free(kho_free_page) = NULL;
 
-	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	chunk = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!chunk)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.51.0.915.g61a8936c21-goog


