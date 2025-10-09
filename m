Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7CF0CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 15:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 229698E0095; Thu,  9 Oct 2025 11:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5238E0008; Thu,  9 Oct 2025 11:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1F28E0095; Thu,  9 Oct 2025 11:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E6DD28E0008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 11:54:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D4F95C08E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:54:20 +0000 (UTC)
X-FDA: 83979022680.26.93F6657
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 668D84000B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:54:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vd1WT8zK;
	spf=pass (imf27.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760025258; a=rsa-sha256;
	cv=none;
	b=LEAExc9eOBzBxxCXHS0ZR69G3lJc/9791k75KGEYF1KdOL7XZdRIiBqoB7wqbJvOsDEWIT
	VSPX59DBCOnoXCIGakXuQQgHWwQpKCGDuy5I3DK2PjbSjInQuJIn6ZeEDYpwl6kSQK2vQy
	bD8MfkuzKqWZexUjVjXb5biV1GoPicg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vd1WT8zK;
	spf=pass (imf27.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760025258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7fCQnX2ZVKzE0uz1WnlkQnY2HwKIpXcbR9mszFR+OOY=;
	b=evfTgiLt08Pw6/YKd2pYMK6WWHgMPzs6Jtm79TZRFVVQnm3OFThEB2IwgM/SjnVepIAmEl
	iCDCEae/Anv2idgzpKOqUBFOPLLLujF9F8rDAp+fCbu+GGj2Qq4hGJYFxC5J3hWITIM37K
	WhqphjqYf0c2aD/D8FFGDAOJuVHsJC0=
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-373ac916b35so17586631fa.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 08:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760025257; x=1760630057; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7fCQnX2ZVKzE0uz1WnlkQnY2HwKIpXcbR9mszFR+OOY=;
        b=Vd1WT8zKEiR3nZ1Eg5KRDyy+EKQGpU7iM9nb3R2uvHAsxcsU5D3ugSb0/P9asWPAXD
         F480PfeM3/vPF4xjvQOPcIYOTT28qXBqpHDU9qr/2TJujwhBy/G79XK9vbq6SnIfn2bx
         CCVeNBNLnFzxOiQmCDU4XLM24km6jyLbFQcBvLxWbW+FNI1UGwFUM/EhBg2FRE4f55y0
         Ua84HIBwQt9Q8tvHaQDFP56FlXjkwDqqU4fup6X5846mU4LggnuaNDatNzy2ieN0jtUf
         Mfm6PPDVtUM35JNqGAQf5W6gqeB18KVdbOUf7Sys98fAht9N7MhKvO5VzLkZmFMgzdiM
         LtiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760025257; x=1760630057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7fCQnX2ZVKzE0uz1WnlkQnY2HwKIpXcbR9mszFR+OOY=;
        b=jMynZBxixNanCWNrV9MV/xbhTXnLjIwU5wsl8fl98i5A88sHcJhmKdGWeA3rraYg9l
         j6u0ew4yCerEvqTE0M2f33cPXhR/1BCmF5rXNTKdZDczrmDGSjG6l/RtAtxHcJ6QcMER
         hp8CZBLXN0tzbGcICnA3D6ApBYmyx2OOJ/39YCqEzxIKhhZmsoyL+suzt/z/rzOxim1b
         F0NWYJSUnGc6VABRvcMDGZJMr0d4tY5P5xtw+A6KaNq+MlUM3gokDNMAuTvq+OzyOaTZ
         4eYJaTwQ1XnNGrDWjc4XLWYd1djT7uLHRkEGKl2horeuZZZ0mXNKtH5E4qUun4prkmg6
         ATfg==
X-Forwarded-Encrypted: i=1; AJvYcCXnkrceAjfjCkZW0HFdZIkEGOZtVBkw1sXvWjtVxeI2tb5nsCP1/tpCMlX9T5bZO3bJHGey+Sgi+Q==@kvack.org
X-Gm-Message-State: AOJu0Yw0yzcDohRx+INKR/HD3Cql65NlV4Or546PgVaZAG7Szu1jYN9m
	LUN4WY4OoLRoKXEHUM8KXuSVOKW71Q7tBykJD8mF8v+MibRIRtl63V5/
X-Gm-Gg: ASbGncuwid7iHb1eUdt61XHo6LNhP99C4V07KC5vmAIp54HGV7Rtz8yO66f4UT1qhn5
	lpRXC3IiWzGu1FLjiRsYtSPzeUAtYU+SxJNe96P73I54h81uls2Bxr72F/i1wgTKNlEUrjIMKNC
	Zs4wW8ZgTQdI/zAwuoulW4VrSK2f99rK6AFpIcK41nvxnsbcNw9ZgtFSc4dcMdJec75ee8rF/vO
	RjdEzQYHFDbJ5WmhZoJHmE0nJeWivhKO9KfdkMeRw4Vkc7yfRdQp9ARr1VwGoaVcBFj5tF3RGs/
	ky1eHGWRGQI1/M/i3cmV7XTc106Yl9bRwI2LKLAm6urqZYeb3iEtrjDcMS5nVo8SfDlch67daJv
	63wDd4IZMeTnp1A/g++hw8nbW8bX7D3+k/ANBf6Q2g2omlLvcBHziVSkgSv2Sp5UvsELbegjoLG
	dUlzyqsC9g
X-Google-Smtp-Source: AGHT+IG5zD/iaWcaQEpSQxQ0CS24v+eDZidfw5pMSXEN19I74TQY1ivV+1T/jtwqPwPDcSEDgzcY8Q==
X-Received: by 2002:a05:651c:1509:b0:336:d0f8:5a7a with SMTP id 38308e7fff4ca-3760a2f9e1dmr20889251fa.6.1760025256534;
        Thu, 09 Oct 2025 08:54:16 -0700 (PDT)
Received: from fedora (178.90.89.143.dynamic.telecom.kz. [178.90.89.143])
        by smtp.googlemail.com with ESMTPSA id 38308e7fff4ca-375f3bcd2a8sm29499831fa.55.2025.10.09.08.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 08:54:16 -0700 (PDT)
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
To: andreyknvl@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	bhe@redhat.com
Cc: christophe.leroy@csgroup.eu,
	ritesh.list@gmail.com,
	snovitoll@gmail.com,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] kasan: remove __kasan_save_free_info wrapper
Date: Thu,  9 Oct 2025 20:54:02 +0500
Message-ID: <20251009155403.1379150-2-snovitoll@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155403.1379150-1-snovitoll@gmail.com>
References: <20251009155403.1379150-1-snovitoll@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: oeyrnkc5fr7mq3n4orm5pa39xz5sk6qi
X-Rspamd-Queue-Id: 668D84000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1760025258-641551
X-HE-Meta: U2FsdGVkX1+RsaWnqov5545UIm58wxwCl95ucWHsw1lcpfvB2dolex/xibDjCH8aupTqHvfSb5zEZvgVope1CUTN9ESYL+qceZW/q8ppSJGtxsE0qKuGrBtbELtC5D5K5Mis5ZK39tnhzGl0zRfZDETuYi9RXhNQz0qnaqVw2NiEHEutTM8rwREhis9ZgQz+/lZsG3kThMjUs75DwloQHZTYisol3eXCjvz701dvVgg/2pq8NX6EIjCcQiDICc7myp/85F3IN6N7Csr9Urlmgc0GnvN6xefkRwxX/3/vQYW+L5X6n9ySTgzv2GMbMjNMyFGjEg1bgh7FHnEKAqCl2UAgzoQGaLlZK7WuUZmgx7Zw9cZNUqPKBbB+3td8sXP6BB3kCNRJIKohGdugmcc6OwGUswJyJkIdBZIhY4KtII7FxPG9TFQUK2QAa+lNaC4vnudJDQq4lRAzF8F3w/YYf7wmz5APz1p5QL3+hhtGBsDVtC3iIQXKMGgN2GvvS0KS/lIjITpLbRtOibK5IrizDUmrJvYlaPLDMcFKHk1GDSz4i80KsDNmI0+n8p7AO7rKF1ma4OmPDn/pTIX0WKh5KGGz3RN0lt22U7czBkbbYuVVPJY7K2F2ExF/BDmDE4Dv0Y2zAv5qrbZq9+0ay1c+fwKXtIZF2zaERA29Tr93qofyERIysh09CVLu8F6SpEMvx8D7slW3QkYc7lF6PG3WgJAvkFunozIqWUc8+sXn6oUXwT8o7ak8u9PruRsytX0168E2JADsiCYhaZbjOTMXZHrMvPZGoghmfxY3ClBnGeHstp/4UOm4Ra/1StAQ2DZw3UdA3sxE0JvAgdMeLOoW03GWTBSSgOTh2I4Yc/9hta8ytA2krRBT8auqUijjCrP5VSt3V2iYbAQrV5oVaAj7v/SCuF6xnNArzhVjMUrQGeAe9WT68LQi78O0LsjOKlNyxY6FLclJCnTryOe9YDk
 jcuw4wBU
 rVDpZIikzh2fjPEAYRCSLlYpFEMz891wCc5OXNfNLOsYwaAEhH3eAb+HgdGgSPue5wAdJQYWMX3fZ4Vkmg6qampcjt72XF+0BZ8OhESqu+NajClXSIPXRMFK3rzrwHIhCV4dzbxeC5oAUQm4ecCt/Ym33gPV6T0cugnRBbICmw/JhIqbI4j4SI7ar1TUWEKsw9nUIANjc+3w7mnxQdyNSMXWg3IVK18VRBYUmSCS8erE9M7oAK8ENeCPQs96DK6cOTPfurUxTHZo+Kp4vzsUakn1xMpuYKqM+zhfmqo5+qqtl7ycCoHU24IMQeProwWorlA2WZqElfBISCapUM+N/k3NlOFMZ3j9hyz4RIZp58BC3trLdMQ1n07lPZ20sOK4XrMrkcgeC1lR4T+tE5s430JhLHIh33iZqOUkJ6VqvohnVGnehH58MKNBEs+P/AF2jjIqioYtZNbVj6k2ze/1IZFQ++1KZ7r7jI+EZnvqK61Ow1F0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We don't need a kasan_enabled() check in
kasan_save_free_info() at all. Both the higher level paths
(kasan_slab_free and kasan_mempool_poison_object) already contain this
check. Therefore, remove the __wrapper.

Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Fixes: 1e338f4d99e6 ("kasan: introduce ARCH_DEFER_KASAN and unify static key across modes")
---
 mm/kasan/generic.c | 2 +-
 mm/kasan/kasan.h   | 7 +------
 mm/kasan/tags.c    | 2 +-
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
index b413c46b3e0..516b49accc4 100644
--- a/mm/kasan/generic.c
+++ b/mm/kasan/generic.c
@@ -573,7 +573,7 @@ void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
 	kasan_save_track(&alloc_meta->alloc_track, flags);
 }
 
-void __kasan_save_free_info(struct kmem_cache *cache, void *object)
+void kasan_save_free_info(struct kmem_cache *cache, void *object)
 {
 	struct kasan_free_meta *free_meta;
 
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index 07fa7375a84..fc9169a5476 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -399,12 +399,7 @@ void kasan_set_track(struct kasan_track *track, depot_stack_handle_t stack);
 void kasan_save_track(struct kasan_track *track, gfp_t flags);
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags);
 
-void __kasan_save_free_info(struct kmem_cache *cache, void *object);
-static inline void kasan_save_free_info(struct kmem_cache *cache, void *object)
-{
-	if (kasan_enabled())
-		__kasan_save_free_info(cache, object);
-}
+void kasan_save_free_info(struct kmem_cache *cache, void *object);
 
 #ifdef CONFIG_KASAN_GENERIC
 bool kasan_quarantine_put(struct kmem_cache *cache, void *object);
diff --git a/mm/kasan/tags.c b/mm/kasan/tags.c
index b9f31293622..d65d48b85f9 100644
--- a/mm/kasan/tags.c
+++ b/mm/kasan/tags.c
@@ -142,7 +142,7 @@ void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
 	save_stack_info(cache, object, flags, false);
 }
 
-void __kasan_save_free_info(struct kmem_cache *cache, void *object)
+void kasan_save_free_info(struct kmem_cache *cache, void *object)
 {
 	save_stack_info(cache, object, 0, true);
 }
-- 
2.34.1


