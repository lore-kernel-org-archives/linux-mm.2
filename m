Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C21B6082BCA
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 15:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YQIAAqGT
Received: by kanga.kvack.org (Postfix)
	id 14EE16B05B5; Sat,  7 Nov 2026 10:37:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D9AF6B05B6; Sat,  7 Nov 2026 10:37:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6DB46B05B7; Sat,  7 Nov 2026 10:37:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2F166B05B5
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:37:25 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 563D91C3AE1
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:37:25 +0000 (UTC)
X-FDA: 85408727250.02.87A1AFC
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf16.hostedemail.com (Postfix) with ESMTP id 89A12180009
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:37:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=YQIAAqGT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3sUXvagUKCFgFJEI86EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ptosi.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3sUXvagUKCFgFJEI86EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ptosi.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794065843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lNlRk5+oFZ111i0wzJnmLszJVAJnN8GZxBjHa+ttev0=;
	b=fDX0EZF2Aq6HZp5Cm2uCrc+CnUubxZoUatfXvHk3SHks7/BdnA3aSyNC8Mt99j0J4nwnoY
	U93FWn2c1OekI1sKoHqwQsg/bEKT4xQSI1bGjVVAOOY4nNzEOo4hCg0EdAlZfFXXnjNRDT
	3NPNug7w4sJk0rGTCOo6to4PH1Ramqg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=YQIAAqGT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3sUXvagUKCFgFJEI86EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ptosi.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3sUXvagUKCFgFJEI86EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ptosi.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794065843;
	b=BHK6DIsZxEjj6DWfTv+/L8BT3FbUH6yfH/aSx/plSLN5sooFEg5hBaO0R9AoE8XfkhsASb
	rzYz8n61/B50Sopc6bXaCbpBNVJb97hhtrGMby071kXdHviTgHRIVkETsJ/HSoLUPXogHy
	Bj+I0OSpwTttw6y57mmwfG9jXWYwY0k=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c49df8fe86eso115877266b.2
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 07:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794065842; x=1794670642; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=lNlRk5+oFZ111i0wzJnmLszJVAJnN8GZxBjHa+ttev0=;
        b=YQIAAqGT847z6CftW58dZXZyLNXuAFm0ERxAE16P6Lq6xXIuqAtzRWadISG6u7YaFk
         ayYvvtV1bXTR3L44ShT6p4hZEWZcoCXn4zSMuqL2PVhQZZnOlO61i19N28TkSLWy9c1Z
         ldR5B/xsD4Yrpf8g/X8I2A3f3qHGZXRAgaDikcxVl4pekREvu+ikKWrWV12LJ9xV6SiV
         GcWseb6OkiZMgl/6bvb50YXE/BguDOBJKYOexd3iQavj0K9vcU00f2MkdbiVlp2LrPyH
         F9gQwY8XdPKOKdeW0wAJPV7iZRXM1VpeYsWdZBLN0wqz2RPuSzKA6Ot9iJVqgIliEeMU
         gitA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794065842; x=1794670642;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lNlRk5+oFZ111i0wzJnmLszJVAJnN8GZxBjHa+ttev0=;
        b=F2QDAtXeBuCI5bjPzGWowfapq94mORYe5BqQDV+0+IL3G35hyi5xOa64Al29RzdCpj
         vts7YKArpAwPTpOul9RtzBzLxlArPmlGto5S6cL09fxygcg4F2LxudfFcllktImwa1QN
         Y3auBRVGG9CeB4D9HPIxqNX9qO+97JHE3jbBR6t4qrPWk9+hI9tzmOGGgGo7tPlHUOxG
         WfmzD63j0iQt6HgKJxU/KJnav+OS154sMbQB9wBDZIhUq5l8Xn+cLlE2ALEB2yUXtmGw
         G/sl693LYszCDUQpjbTQfyQg/tzzBf9squQXyWdQQzGemhbvenZSeEgmK2zLLYTyCPb7
         a0Nw==
X-Forwarded-Encrypted: i=1; AL+hErEPtVmNh2N9x3FUgERoTNpx2Dv5uYOyh59w+uwB3klR+VR37msL8IXiHmNqJ5CHV97c9xBeJ8opFw==@kvack.org
X-Gm-Message-State: APuU4Z+tgOXb9iNVT+31XhPy1/BusaJVD2gK89I00/w9VjMRBRMrPT6R
	wWChQnb8k8QQ4Gxvch4njoUWKIvlzy0BDnOMqemkgjts5GilovtxxPANuDaeq+LkbKLDYbaGRN1
	Rhw==
X-Received: from ejebc11-n2.prod.google.com ([2002:a05:6938:e08b:20b0:c41:2fad:5f39])
 (user=ptosi job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:dc8b:b0:c49:cdc8:10cf
 with SMTP id a640c23a62f3a-c4d35531e7fmr425425766b.40.1794065841807; Sat, 07
 Nov 2026 07:37:21 -0800 (PST)
Date: Sat, 07 Nov 2026 16:36:16 +0100
In-Reply-To: <20261107-mte-kasan-split-v1-0-d84ea5f30f94@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261107-mte-kasan-split-v1-0-d84ea5f30f94@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20261107-mte-kasan-split-v1-10-d84ea5f30f94@google.com>
Subject: [PATCH 10/24] kasan: rework hw_{get=>set}_random_tag()
From: "=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?=" <ptosi@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	"=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?=" <ptosi@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 89A12180009
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: csfou9ksj4gfgfbrkf7wrmf9dhcduu48
X-HE-Tag: 1794065843-355881
X-HE-Meta: U2FsdGVkX1+Dmjt2zYFWP5I28PVfTfdDKdbD6IdTKKHx4htLtEdDv/Hf4dF2Pgw+CUCkx+cKslPyDl9jaDM7J/N/GXHOP9FpFG5j87T1F5kzdE+pXS5pLiKHuOzvC8DdnJsqp0ytIpIOLJOJHebzTe01LqTmtA9TTYZSHLV/eHkUljthXYSGb+NIDGE7gmcu7zGJSKhbAILBErhcmT1OWw4g5IdJe/8LIRp9zP9x6LtOP8bXmbBXB+RstZXF7PiKOu+nJUodd+AyHnKjbE5keumzqIk1yiEc+8ja5a+UwwDDBRfwS9EB0E24q1BM8BgA8OAjNxQKTrrtYlLgVTYPXpEspDif4DilHMQ6RyA6pHCuW2NAPTHhC7T2EEkzEtDd2iKV9zcFjnQBsvK+sYA6gVT/ANVwsOVgMX45bO6bIE16ADNCtWia6ubWyEuKj3ywZN6NYAAVy3XJo94pUDXLH3rLD0lULopR0nuRNlJIena7mbKabrwOiwjWkfZKlgYSjprb/1X8EgIbLtntajDi0teFSMkBmcDKWUN5pK4DcBibXYCYCY5MB6yA6ihj9ReDQHG12TKc7jNWBQoNhZ97zb8EOmcVIYsyE9FC6MwnyuVpFNN4re1gVGgk54cd7IxIy5ms5sUq2RK75i6w7XjcoQPwtAQZ5AzV89xyVhHMIszOA9IfP7G6WkqTq0JRiN2SAYtBXJ3XZU7+z8AjfE/9CQtxmEI5q08w5OWfwZMP89ZLImU6LechRoUJ8DmMXP+73L1TxKdJEKQ5Jecudsvf/MOdExEvRtt8VW5qVb4bGfEt5seByQI1OeDKzTzxDRU7EWETsg33AI2kTuCncJsR7mgP1PltAXNF7ckV0kzBYot/TVqKkslcq5luvT0gAix740lBhhvVd+9mwevBp0Lj4PL4Juwmki5vM3uDb++EVH/cpqw5ZF0eEKNStfem06dn9LSJ+tnoshmej6ahNZT
 8QIfY7uM
 AymXSe8/LNm6Z8CIIRww50igYOA7TD/a/cocp5VEIU8VCWox/kAdLaA3EdCRsRRaMgxF6w+eNHPmbj37jK7DXflyUl5X3lGk/Goe5h+HQdeOoohwc1nWRqV7d5xsxcdvwJW9LEOesA0YmhklRrcCz94s2RIgC7VGI3cUBbvVyDwFQnz8KtIOnbDRC9V7S6KQekbekfq9YKXSyfdn/Wq/cMgje63fCzi2DVNWzXkPTOcx81z229BCnN71qzTyyEZTinVp5pllVqZ4pfDO1e8lc9eirNpRGrZIrXBQ28xpFE9zH2+GSf9BvjqZC218XI2PavgiqdkF85hxn1MzjDUs0NWHOPF+qA1SLAho5YutPKC56Xch5MdnVVfzAvk2No8TaCuBWI/nTVdWTLEfXWzC1wsQ7XluE40V5s62D9tHP80Bdahbho5VSB7mbBByOquce/ZI3AYy2OluSWZXirXZSQDS4sRRih0GHiEd8D4WSdDHyK+BX1E7PQgxMbFnOaVACcYih7LG60NZbaDo3ppYUanjvJzu2+O3Kc/baRIb5MzaT6HlZnbO+pm1vf1yrTYkN3v9HrXVHcieI6xU00E9epgMibiZBNR47lme8/Gx0k1Bu1dLJj0KSzH3ljsSDjO2mAV5E/182ALBXIvfy9PlqV0CU8dix18p5243UOVMupFKI51uAv+Vh2ga44NsQc40jfw62rco2d/0Q1Gmx6wCltg+dMEiOIRHT46bmaV8vmHB6deanHdTVyfZF7jw4chm4cdce4sUZaDLOv3OLqsfpBWHMRv0rjw80pRKdH1BSfTOi0Iqytl0MZXmq+xQvUAamRCuuqnYp92WMKfcFsWLR+G+pZCaWUIC61aJ/UcPAA1RILUeayXgueDP090vY2DhAGDGj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With MTE, the IRG instruction tags a pointer in-place, so that

    set_tag(ptr, hw_get_random_tag())

can conceptually be synthesized as a single "IRG %[ptr], %[ptr], 0".

However, with the way the API is currently defined, we confuse the
compiler into generating a random tag with invalid address bits, to then
bitfield-extract the tag and shift-and-mask it into another pointer.

Furthermore, every single (indirect or direct) use-case for a random tag
in arch-agnostic KASAN ends up passing it to set_tag(), which likely is
an indicator of a suboptimal API design.

Therefore, make the function clearer and more optimization-friendly by
directly taking the pointer to be randomly tagged.

Update the only definition (in arm64) accordingly.

Intentionally keep this patch minimal (and limited to KASAN_HW_TAGS) to
reduce its associated risks and make it as uncontentious as possible. A
future patch will refactor the arch-agnostic KASAN code to enable the
optimization mentioned above.

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org
Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/memory.h    |  2 +-
 arch/arm64/include/asm/mte-kasan.h | 14 +++++++-------
 mm/kasan/kasan.h                   |  7 +++++--
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memor=
y.h
index 8e751b56d20c..29e7537f5e58 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -317,7 +317,7 @@ static inline const void *__tag_set(const void *addr, u=
8 tag)
 #define arch_suppress_tag_checks_start()	mte_enable_tco()
 #define arch_suppress_tag_checks_stop()		mte_disable_tco()
 #define arch_flush_async_tag_fault()		mte_get_reset_tfsr()
-#define arch_get_random_tag()			mte_get_random_tag()
+#define arch_set_random_tag(addr)		mte_set_random_tag(addr)
 #define arch_get_mem_tag(addr)			mte_get_mem_tag(addr)
 #define arch_set_mem_tag_range(addr, size, tag, init)	\
 			mte_set_mem_tag_range((addr), (size), (tag), (init))
diff --git a/arch/arm64/include/asm/mte-kasan.h b/arch/arm64/include/asm/mt=
e-kasan.h
index b474fca3ea56..17e4155781fc 100644
--- a/arch/arm64/include/asm/mte-kasan.h
+++ b/arch/arm64/include/asm/mte-kasan.h
@@ -73,14 +73,14 @@ static inline u8 mte_get_mem_tag(void *addr)
 }
=20
 /* Generate a random tag. */
-static inline u8 mte_get_random_tag(void)
+static inline void *mte_set_random_tag(const void *addr)
 {
-	void *addr;
-
+	/* Writes the random MTE tag in bits [59:56]. */
 	asm volatile(__MTE_PREAMBLE "irg %0, %0"
-		: "=3Dr" (addr));
+		: "+r" (addr));
=20
-	return mte_get_ptr_tag(addr);
+	/* Sets bits [63:60] as KASAN expects. */
+	return (void *)__tag_set(addr, mte_get_ptr_tag((void *)addr));
 }
=20
 static inline u64 __stg_post(u64 p)
@@ -190,9 +190,9 @@ static inline u8 mte_get_mem_tag(void *addr)
 	return 0xFF;
 }
=20
-static inline u8 mte_get_random_tag(void)
+static inline void *mte_set_random_tag(const void *addr)
 {
-	return 0xFF;
+	return (void *)__tag_set(addr, 0xFF);
 }
=20
 static inline void mte_set_mem_tag_range(void *addr, size_t size,
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index be5dcf6b052c..0df7daee1864 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -433,7 +433,7 @@ static inline const void *arch_kasan_set_tag(const void=
 *addr, u8 tag)
 #define hw_suppress_tag_checks_stop()		arch_suppress_tag_checks_stop()
 #define hw_flush_async_tag_fault()		arch_flush_async_tag_fault()
 #define hw_enable_tag_checks_write_only()	arch_enable_tag_checks_write_onl=
y()
-#define hw_get_random_tag()			arch_get_random_tag()
+#define hw_set_random_tag(addr)			arch_set_random_tag(addr)
 #define hw_get_mem_tag(addr)			arch_get_mem_tag(addr)
 #define hw_set_mem_tag_range(addr, size, tag, init) \
 			arch_set_mem_tag_range((addr), (size), (tag), (init))
@@ -469,7 +469,10 @@ static inline bool kasan_write_only_enabled(void)
 #ifdef CONFIG_KASAN_SW_TAGS
 u8 kasan_random_tag(void);
 #elif defined(CONFIG_KASAN_HW_TAGS)
-static inline u8 kasan_random_tag(void) { return hw_get_random_tag(); }
+static inline u8 kasan_random_tag(void)
+{
+	return get_tag(hw_set_random_tag(NULL));
+}
 #else
 static inline u8 kasan_random_tag(void) { return 0; }
 #endif

--=20
2.56.0.455.g6c5a503b38-goog


