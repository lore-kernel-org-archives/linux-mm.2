Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855CEC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6DB6B00C3; Wed, 23 Jul 2025 10:59:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BE906B00C4; Wed, 23 Jul 2025 10:59:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AE0B6B00C7; Wed, 23 Jul 2025 10:59:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 077696B00C3
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:59:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD808C06A0
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:59:31 +0000 (UTC)
X-FDA: 83695838142.03.8A2EA13
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id CCE9F180009
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:59:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=olo7Hkyg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of jannh@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mrUzeAqJAgSJcs0yfhfK8Cv47SEHn3fw+SKS6td8SA0=;
	b=vJIY1ArEmB/VwaCH1XP5w+4tnR5IhCRsRRPl+kvzI+uNE9j2vR1A18rdqmON1v5hCl/ijG
	Gh+9fqaM370hhCd8zKXPPQR2K1S1z+VBsCDqEMmikGxLT0c5S2fypledNJIEsCThRqYEkq
	+ZeAq4kyIlxhqxoGc0U2/SvzyOhb0cs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282769; a=rsa-sha256;
	cv=none;
	b=ErGvLqfrw+mIH+ELU6w2IoBoWKsgHpbi51RIOshXwskOgOwRFcd2GnykU2f1uSVlwEEuu9
	Wnx1o0c7Dlw9UUWA0Mx5Uok5ex1pfuVu7hc/BGhL9Oz7T97kc1+ji+ndWJOFNsk26kHei9
	UZzipsh6e68J8YvEwSCeJnCT4wj2P8s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=olo7Hkyg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of jannh@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jannh@google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-456007cfcd7so83625e9.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753282768; x=1753887568; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mrUzeAqJAgSJcs0yfhfK8Cv47SEHn3fw+SKS6td8SA0=;
        b=olo7HkygBvtGOHbf8vOCvrqRj5i37yt8Bf9MuYlJsnOENWcBXDZVRCZeB9aTpLT2aX
         FUbWqg808ueC6s+OKjq3th00LJqjVM7u5J6vSS0fDYnqQAMNi8+vuxSbGRCY/wXOrXTv
         thZJoOafLPHOuKh/cMQ1kXhduekjLx5Ry8JlxZu8TpFfyyZFzcRp/maQJu2ikXm8K4r1
         kgeuFk0KAwT5kTQk6QL4DD3ugDg4Ooj+RERwUoAm7kQeTRU+OBKW5PVWBnxSuYOk7+ZA
         DrjAOK1RqLcA3QNq3xIkdK6hxEajD8An4inPEgNZFAZE4wYWq0mARbmhAf9+YUGyOg8m
         ue+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282768; x=1753887568;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mrUzeAqJAgSJcs0yfhfK8Cv47SEHn3fw+SKS6td8SA0=;
        b=RouFa61RmXPFkCEAjj8gzSOsfMG9JklvcLsCeUF8Q5t0rjjnda7Uoq+HVWwjNruiMX
         FSy5zB8tZftO4ZtoHQHUuZwlg0aJfDc99mQnRY+U88hKb4H0Elun6Dr4sDdjkLkKBjT5
         FzqglicSnGwM0t8PAF6txCOWLddaDT/Thg/peQ3n3I031fMfvfRukXSpvwecwZtrS8yw
         7FmpT5IdXApwQscpm0Y/LpPmWHPxXuxvLOEuK7R8HfHif+3zqsu1q1jr/t+ZNXjQ85om
         zceEJFH5hEfbMHTyHHhJfSSTPSW4I60ga/OIUTZSdn/F2+8m+TB9I+fsPxxPKwwf6/5w
         5kzg==
X-Forwarded-Encrypted: i=1; AJvYcCV/+SFpElDPBOx3fjXlmIQE/iClfn2ZVZAu/CEhoj9semLEUEG42UBzyN7oLup0HSG+zUpwa7aIzg==@kvack.org
X-Gm-Message-State: AOJu0YyIskcVfXOJnicoZLyQuzBCXIooECqa1WOXfyAOgoPyeQ0S6jJk
	p2aS3xWd6PcJFAQ6DLbvM8iV9B6qIPABL/JBrJx1Nj2CZ+CO/JFGB+OKeqEHk3PGcQ==
X-Gm-Gg: ASbGncvhfuicD1CXUMNQwEuC1yGksWHLq7qSQX1mLT5hb68INJq2xZcocxGEQTHp2Nd
	Sr4y3khVIBnG5PHBPOyw257q3svwyDS4tW7mMbRaivgyDoTUspXz8lV1qqz39ptOUkaZ+V3CAKG
	4iEV+2uHUYMs5MN0b4ssGCIQiuLRXfpNNZDhmAbg7EkTSHr/1tW8YR3Zv9QCKLdx8d0tdgFjEAS
	nDq3PByT9FgJTn9Exi6iK6Iu0QVTVFVpzp6mahOnVlr3lnGrwPQgIEZiwwhVw6cFIDhIhG+FEqT
	SHrAqflchT+Bju00ou6G3gy5xBXk6ookdhpNgPh48rrkvjtMCTxr2imG/oWTbAAh3/lwHkKNwVK
	w2WTqQOgrKs0wac0Vafqz
X-Google-Smtp-Source: AGHT+IGbQfy//Qbfm8JE9/qvJe3eag1FupMKSbzpYIXiaLPU6nQJNskytzV7WfCUGDyDxN7sWJtAkg==
X-Received: by 2002:a05:600c:c04b:10b0:442:feea:622d with SMTP id 5b1f17b1804b1-4586947515fmr1001615e9.1.1753282767736;
        Wed, 23 Jul 2025 07:59:27 -0700 (PDT)
Received: from localhost ([2a00:79e0:9d:4:8af4:48b6:182f:2434])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b61ca487fdsm16553683f8f.48.2025.07.23.07.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:59:26 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Wed, 23 Jul 2025 16:59:19 +0200
Subject: [PATCH] kasan: skip quarantine if object is still accessible under
 RCU
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250723-kasan-tsbrcu-noquarantine-v1-1-846c8645976c@google.com>
X-B4-Tracking: v=1; b=H4sIAMb4gGgC/x3MQQqDQAxA0atI1g1M0xbRq5QuMjbVIMQ2URHEu
 3dw+Rb/7xDiKgFttYPLqqGTFVwvFXQDWy+o72KgRI9U0w1HDjacI3u3oE2/hZ1tVhMUSnXOTZO
 E7lD6r8tHt/P9fB3HH18ZYKdrAAAA
X-Change-ID: 20250723-kasan-tsbrcu-noquarantine-e207bb990e24
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1753282763; l=3240;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=adPHI4t4JoxREbQY3IlmOrd4nE1YbruoXqCJg1mANYY=;
 b=Z83uOcvUi20dyNI/jDIxgSTZANRZyssbbsESb040Fl+CVwwSVB63M3K9wCM+YfaV/mMVv1/Uq
 PqVrnmlmqnlDPPlzwpQFvrT3yOjtJkds8+j17a6WtMFj7gTR0flqjSV
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspamd-Queue-Id: CCE9F180009
X-Stat-Signature: 8fr3n94hh6ej4u54j1pypi8x9n7453nb
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753282769-657650
X-HE-Meta: U2FsdGVkX18IFHewHvnsuTchI8NUMw7bqAeV5ZhVJRq6K+/JHOw9RJ8Bbr8Dxk5NDbDHMR1BgCkLeKxwyCKv6tDy+059PhBWIp1t8zGmc8HiifORZZHzc3zIcOcvjJKOASDec9i7VQDGTSfSkj6Oql0PyW5urVc7VLSNflFenYmTyO6XOn+qIxaZeEwMsJp22rwjnhQsiyWUgWgn0DSi/3rPRcMTIn+mcKgomtZ/Z/0YKDNVBryFZEsyVZuNhL6n05nUVELSEOjq7KPrFt1D4BCDXt8RTcSdvZXf1Cwy3aeHSZj4dSL1J1ze9rwesyLiF5IHAgMv4E4ODX5L3SdIoDfAbcXOItXZ+aU+BSOAgQPu5qcsaOZJkbjb+Esmayahb5E9kfu91yGZMBHQWmGPL6mEWZ6/jEGY/jh0e+6P9D74DCLPQpkf8GejMrePDfEqw9Zf0WaxopgzDoCv5+jzcwn1FnZaAlCZsvcFautBQiOId9kpo06pLHYl6HcsYTlWwRkWA7ryEi6+y7mxeTkWweUjWpiG8pAiu9QVxbdVz7lZI/2rh9vmcwt74uMEo2eHv4Bgtikbz29XvbqznXycxOtAagIwBRVkOXPJeKRNNxS1JPhJXjomDnK7cETmnK1/05lyb6BbTKkqli7kli6lAJl2GMYmOJMeKpZ3ihsU/J+wKax6/HrgfnHUaL4OXUd2DGScqBjcRd1aSZY76oHtHNKBhpkYz0FknrLp8gW5g+x8FxmPv+AiyZPAQkUZ4CVkaXsAevjjo67emqmXpDjPP7p0L/nIlIIXw3DpKtGIt72n1lIcfUHXxnjUDBrc5451alITADgEt7kka87UzVKKZKcI8xjixym3urSAJ2udBJIei0WZU9TLacqWAqDUABVm7oylBsXz99+3z/kDJdiw6SdSJOJnHgetXhohM00NDH9zPVXIYwrfmxsw9RFQgjx+JY6nOMJVZgnKudrDZ6w
 FKoGtbU3
 GFO6Nkhxtq3NJMXDKy4LJCdrb4WOoPlWltRVozZcllfJCrxGIbux9WStrx7LVB2+plSku
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, enabling KASAN masks bugs where a lockless lookup path gets a
pointer to a SLAB_TYPESAFE_BY_RCU object that might concurrently be
recycled and is insufficiently careful about handling recycled objects:
KASAN puts freed objects in SLAB_TYPESAFE_BY_RCU slabs onto its quarantine
queues, even when it can't actually detect UAF in these objects, and the
quarantine prevents fast recycling.

When I introduced CONFIG_SLUB_RCU_DEBUG, my intention was that enabling
CONFIG_SLUB_RCU_DEBUG should cause KASAN to mark such objects as freed
after an RCU grace period and put them on the quarantine, while disabling
CONFIG_SLUB_RCU_DEBUG should allow such objects to be reused immediately;
but that hasn't actually been working.

I discovered such a UAF bug involving SLAB_TYPESAFE_BY_RCU yesterday; I
could only trigger this bug in a KASAN build by disabling
CONFIG_SLUB_RCU_DEBUG and applying this patch.

Signed-off-by: Jann Horn <jannh@google.com>
---
 mm/kasan/common.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index ed4873e18c75..9142964ab9c9 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -230,16 +230,12 @@ static bool check_slab_allocation(struct kmem_cache *cache, void *object,
 }
 
 static inline void poison_slab_object(struct kmem_cache *cache, void *object,
-				      bool init, bool still_accessible)
+				      bool init)
 {
 	void *tagged_object = object;
 
 	object = kasan_reset_tag(object);
 
-	/* RCU slabs could be legally used after free within the RCU period. */
-	if (unlikely(still_accessible))
-		return;
-
 	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
 			KASAN_SLAB_FREE, init);
 
@@ -261,7 +257,22 @@ bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
 	if (!kasan_arch_is_ready() || is_kfence_address(object))
 		return false;
 
-	poison_slab_object(cache, object, init, still_accessible);
+	/*
+	 * If this point is reached with an object that must still be
+	 * accessible under RCU, we can't poison it; in that case, also skip the
+	 * quarantine. This should mostly only happen when CONFIG_SLUB_RCU_DEBUG
+	 * has been disabled manually.
+	 *
+	 * Putting the object on the quarantine wouldn't help catch UAFs (since
+	 * we can't poison it here), and it would mask bugs caused by
+	 * SLAB_TYPESAFE_BY_RCU users not being careful enough about object
+	 * reuse; so overall, putting the object into the quarantine here would
+	 * be counterproductive.
+	 */
+	if (still_accessible)
+		return false;
+
+	poison_slab_object(cache, object, init);
 
 	/*
 	 * If the object is put into quarantine, do not let slab put the object
@@ -519,7 +530,7 @@ bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
 	if (check_slab_allocation(slab->slab_cache, ptr, ip))
 		return false;
 
-	poison_slab_object(slab->slab_cache, ptr, false, false);
+	poison_slab_object(slab->slab_cache, ptr, false);
 	return true;
 }
 

---
base-commit: 89be9a83ccf1f88522317ce02f854f30d6115c41
change-id: 20250723-kasan-tsbrcu-noquarantine-e207bb990e24

-- 
Jann Horn <jannh@google.com>


