Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0815660A260E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 15:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Owkv85d4
Received: by kanga.kvack.org (Postfix)
	id C9A3D6B05B7; Sat,  7 Nov 2026 10:37:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77916B05B9; Sat,  7 Nov 2026 10:37:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B60706B05BA; Sat,  7 Nov 2026 10:37:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9213A6B05B7
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:37:28 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 285381C37A0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:37:28 +0000 (UTC)
X-FDA: 85408727376.16.9745120
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6A714A0006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:37:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Owkv85d4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3tEXvagUKCFsIMHLB9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ptosi.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3tEXvagUKCFsIMHLB9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ptosi.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794065846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dKqRRHhy6BHS4ck54ga2pt3P+7mkrZNg70kpGu+nmOs=;
	b=cGEnM/eLrnLfAPzv164nZ1xMxwzcZ2HCvAmUoJySG5pHpR/3m2gYcXIAlWPsGFLcg8fi8y
	LChn9VrGDu3fv0RKnpJwIEv5FoYSgMNvofsYZ6Wxmce07imWvqB0k47i441dhC0lkVzSI6
	pAzeUwv2LP6TMoGhU+I5Dlox1Z+Ajo0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Owkv85d4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3tEXvagUKCFsIMHLB9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ptosi.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3tEXvagUKCFsIMHLB9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ptosi.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794065846;
	b=MEM9Bqm8MJ4Ri1k5x8EweXPqJbiWHmmWHPF3caMwFlLQGFJx8DTOTzFX/whkWXEsPHndrn
	ezBF5N0O+W3PSDUpS0xXkkNOig8RDUYfK9FuNouutOW6hYogxV5IA5qhtH7v7ArAxwkrcA
	Bsn77N2kj1QolCXG7ok+kVpm6mgLdEc=
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c40285df2a0so102666466b.2
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 07:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794065845; x=1794670645; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dKqRRHhy6BHS4ck54ga2pt3P+7mkrZNg70kpGu+nmOs=;
        b=Owkv85d4rwZfY4LENZDkGc9Hb66f7fIZpiG28a8rNxV72K5Ca8NWtrrsAJTzpbQkLm
         7acPDgdvDlWh503JBCo+VmDmgWZROxVK1G1aeqvwI9Fc60mV29+UYxYbpvMckof0t9bV
         D675zSeGAvPcPqfAiR0mozWJBuWB+Ln+CMg0V2+b8qDx9p2m9sW2EdKX362m5pw7aquW
         d6dklUj1O5wjdvUFkjq3Ewtd0cA2Tna4CUuKfAo6LHcOqkmkZRtoirbEfsn/BUlbcorU
         WNh7XdbZaVs1wudCy32XA4EsVFzLgwdZ6gEf4aNlQFOdcIckoCRnzY8cDTZk1Bl0wa+p
         nk8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794065845; x=1794670645;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dKqRRHhy6BHS4ck54ga2pt3P+7mkrZNg70kpGu+nmOs=;
        b=PNSwxLz5a1r07t/PaQ3jYO5zLQnQVIYKPqdMgmM2pd9QhtMQWNNsR12LhOORg32LiN
         Wa68BWUbNx2iULBB273AG1vgJeLkNEEEjLdgp27jB3AJ/dtd2+mOCihCjRxOwAa2Lcy7
         Qa+mjklcxO7TPqEjfp8fm3hadue1zC74rOCCnbxWgPWqOeoa8IPih571+rjNz84togxZ
         Ts+HxRQXtcE0vYLgUP0BTIW9KIVvS4uz9ltBpuRd5QuyoWuYuvj6sfHIjntrwIxWhSzn
         DUuJBJowfUS8v2OoxUGYKzIGRYcUW/IcXAZyb/1V000ueXmEw+KgOUMQS8AOXOOaPmQH
         Xr5A==
X-Forwarded-Encrypted: i=1; AKwUvBx4Ij+kaj5uPOY02wQYsAPviN2jY/98Jj1bg+3tOXSEYXBXgPgdIS/Aw0rFRKwmMkaB0UbL1Quo6A==@kvack.org
X-Gm-Message-State: APuU4Z+gHwl+fHeMth1M7/A3jBkSNkKSRes+xXoVp6PVE9+CToeBtE09
	jrJoE/ZHY2GS2mox1hDX8mBMB7XGwrF7rXPwt1XYSc6EdlriP9NH0GKiPkkmLZjhJejR/epCab/
	hGA==
X-Received: from ejcyb22-n1.prod.google.com ([2002:a17:907:e0d6:10b0:c4d:32b9:af48])
 (user=ptosi job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:9c05:b0:c41:cf68:bbcf
 with SMTP id a640c23a62f3a-c4d34c42700mr430478966b.32.1794065844907; Sat, 07
 Nov 2026 07:37:24 -0800 (PST)
Date: Sat, 07 Nov 2026 16:36:18 +0100
In-Reply-To: <20261107-mte-kasan-split-v1-0-d84ea5f30f94@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261107-mte-kasan-split-v1-0-d84ea5f30f94@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20261107-mte-kasan-split-v1-12-d84ea5f30f94@google.com>
Subject: [PATCH 12/24] kasan: drop mte-kasan.h from arch-agnostic header
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6A714A0006
X-Stat-Signature: qbjnfkmmh9py85kfe4uuxcxn6jd9i4ez
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794065846-544518
X-HE-Meta: U2FsdGVkX196a3up/tkEKUwd6HhxNiFFgcKFNaNZxlSghFi5cWwGGIrLoC0sAgCTkQwrHAY7zRw/10ikDuEqFHv8ZcithlFy1y8kkiyis0XK9cEE4mih26LNxqqhhIEa7sPAdCVRtrbRDYiDAKl6LVAYHdL1W4Vjxr3vIT56fs+Fvin9NX1ws8KJVnGa9h/2b6v6Add5q01xmuq0Iu/jKftGjWFWXJCnHwSobQ2P3U50cveZIFNTDHrzk5AO3WabypujZlPZ5z3D2BPsxr9r1FL5Hn/aGPzlHvalxUFJSrFU/pr82GqG4uHn2DwW64K0lutPjEL96nDqNg7iCfb4gwZls4s/pCygnzc/TiNOai1fQ1IDA/CCHNCd80Q3yekhXJAj31Vlik8tHwSzsDCW7roMLDjA7YzAihmIRCsFwWvC9Q3YK4O9iegCDMVhIDSJgUYLs3x5jSzCzePuwTfUBaioHGxpbxZNyCfqBYAH+HwRjYXIadZpFnbFBlN4trmCe/ypPR5mGXFukwgx0OEmaW2DT1EhDAyTAr8TiaDUXr6HxQRPHEAbE0on/7Pkalg9yp1Y1Y/E+1TEyYnoUYC0Bxp3o4Y6dTG7LBtLnulIicwl7M8Nx4DGSIt8QmiIPJOFht8Eres8+ewB1VJEp/x9yX6MekOWG+1n0aFo5p/Bx9dvwvsqE/t+E69aAtM+j0uvsPItz4gcaGaMw4d6M4okibGvGQs9ZmaamW8yiLsF1Cdlq/8Rx4mRM170i/OfEZT5AaCWu/vzj8o7I6jMSQTiT5C+9P/vh1cfkCB9KecDTM3hFrfi7H7y2nhK62WWu6xMD4b6OMmFI4JJkyXrCzqJkCgyq08XsoA3L1XbEt3xXyboV6lrpBc5oJ5s69uK0HzJm3A77P6MFJpIhg2AN0zOPBYyAU1T+bZSalDRjd6KvXSh4f/JEeC8GwJsYO8d2X1EWrtsnoV1y5sx19/aVKE
 GZFMEc/M
 7fqhrXSI/bzt5m7gqeglhi5o5HxhoZelwa82WjsVONr2zxV/fHMSln8iKxbPzoT1OOLMl+NCF24AjI4hF0173xq8XdcAT5pPF4Z89AL3+L8MBkh5EfSOdE9gk8592+MV6YaozbxDXhJQJoT/iDmf50RjVM6eeSR72Lc4uaOo7ZtYx9F6HRcOFsMGVT7B6X2EQ3x06g+8FxsSCvFMGKuqnhOfx00sZ+EEh6lSPLDiR8vERMm1E0jDEwcHQ1TRsQTwIDw0JEMUcFLRIO2D4aT4nhDZf/ANkFn5JkmNZhU3a5nOUOGBQG7SCW3B75OdfYKlq9bS7MzIs9s7Ei3emVMJzpgUsjSoC/JQ549spDeGM77oH+SUvYeuGsDX2P6RzsmPf4/XwL0UgtDkMIXvD+q2Aed+r6MxacJtaA59P/DPOjPc0COHsi5gRuswWvtWgLYbUFJuH81azJSXUVENOInVtmul2JnZmdehCct4q2FLqR7dKHmcsUjaryoE979bEIEq/cOn/vg5QZb33JKeaOSw5AJ6y/ax+gURSWekdOSIo8hNYbTfBnEgbqUIq0DQVNJqRt9XlB9PSReaGMy61bp0ufcG1xaf9LzXAE+jJaygT9dWedo6E9s4Wjw0tEl7S+FK59+Z+1gO2WteXSXxz7O4xS/qpYE832bvAv9TqXQ04utHV1tV4Q8cfLUGTCC4MB5Etc0xoPqAw+1BnkT9ZlX+FtqrZOH+ctDw3EctGGV/5T8eLXhoGy6e2yO02XDr+d8TdtlsA5NaJtG+FgjZidelcU2PLv16bKFAeJuyHnky4nNZvu/Qk0CpLsC8pglCfjq1X+ZT1hkMXEo4wOAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The inclusion of <asm/mte-kasan.h> (only defined by arm64) is based on
the brittle assumption that KASAN_HW_TAGS is equivalent to MTE, which
will break as soon as another architecture supports it. Furthermore,
exposing the header's contents to common KASAN_HW_TAGS code risks
spreading this wrong assumption further.

Allow KASAN_GRANULE_SIZE to be arch-defined, with a fallback.

Define KASAN_GRANULE_SIZE in arm64's KASAN header when KASAN_HW_TAGS.

Remove the #include, which is now unused as a result.

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org
Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/kasan.h | 5 +++++
 mm/kasan/kasan.h               | 5 +----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasan.=
h
index b167e9d3da91..3106a2271781 100644
--- a/arch/arm64/include/asm/kasan.h
+++ b/arch/arm64/include/asm/kasan.h
@@ -6,6 +6,7 @@
=20
 #include <linux/linkage.h>
 #include <asm/memory.h>
+#include <asm/mte-def.h>
 #include <asm/mte-kasan.h>
 #include <asm/pgtable-types.h>
=20
@@ -22,5 +23,9 @@ void kasan_init(void);
 static inline void kasan_init(void) { }
 #endif
=20
+#ifdef CONFIG_KASAN_HW_TAGS
+#define KASAN_GRANULE_SIZE	MTE_GRANULE_SIZE
+#endif /* CONFIG_KASAN_HW_TAGS */
+
 #endif
 #endif
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index 0df7daee1864..52c2e7dca739 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -128,11 +128,8 @@ static inline bool kasan_requires_meta(void)
=20
 #endif /* CONFIG_KASAN_GENERIC */
=20
-#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
+#ifndef KASAN_GRANULE_SIZE
 #define KASAN_GRANULE_SIZE	(1UL << KASAN_SHADOW_SCALE_SHIFT)
-#else
-#include <asm/mte-kasan.h>
-#define KASAN_GRANULE_SIZE	MTE_GRANULE_SIZE
 #endif
=20
 #define KASAN_GRANULE_MASK	(KASAN_GRANULE_SIZE - 1)

--=20
2.56.0.455.g6c5a503b38-goog


