Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A92A1D2F352
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 19:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F97B6B008C; Tue, 13 Jan 2026 14:16:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199E66B0092; Tue, 13 Jan 2026 14:16:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CCD46B0093; Tue, 13 Jan 2026 14:16:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3E516B008C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:16:07 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C60AD1AAA4
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:16:07 +0000 (UTC)
X-FDA: 84327895974.26.59DB8FF
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id D1EC54000F
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:16:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZvpLEDqd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768331766; a=rsa-sha256;
	cv=none;
	b=Iku/6U8LHE4yxEMa7wy8HVB7KMD1m+SedwX3c1N7l9iuVPkwQ9jHtlknFpZCqMZjNG/9+H
	FY4if94cKv3RDoVoUm8mge8QylQmBlmJMocw8Vf5n1pHd3YEilIkXt6kC1Acm4ZaCY2x68
	asALojxMslh3+oqQ7jOT1z32IQ5EQHI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZvpLEDqd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768331766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ScbrhvmjweTqkN3+3yPcwAeK769lF/fHEHFkP4nsS9c=;
	b=bBnYnbVwgGwJuBFmWefbTB6GcjkA9HdzeHU3una/H1RIbtuSdBhtl0IOgxrtYHJKCdXfw+
	Jx9NHCGDIGLISdCiQ0xrg9yIpPqMNhA5nx8DTmzGC1OKGI+dajie5z+yY6RtxP8rfyy0gS
	QWRg4rZPHFMx/M9iA+Ti6ztjf+g4h7U=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-59b717b0f80so517771e87.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768331764; x=1768936564; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ScbrhvmjweTqkN3+3yPcwAeK769lF/fHEHFkP4nsS9c=;
        b=ZvpLEDqd3R4B/n7sxGaMIMRIBgoU+7AMDq3VMQ4JzAjejWd4i9DTFbFgkvCMkKygP3
         0iNK4m2zn0XjKIVQ90eYShpXtgt1c2fmiU7y2qylcqXA36cKPFlvxKr3SLICCXvRgqCg
         aXhL9Wlqtc26PFj2tztBWtWvXmrsjEttp5y2A6KsAJbHl1AvmqJQp9uhJgMBMb6Yus90
         HcnjyKc58igGQN1aouuZpU64Ty0JjT06rxnRUg8qTVNN2SJOU+jdXWSscCx0mjz+ACFx
         9UV3PLPIcoYwUC1vYck8H0gXLJGQ5cGmSgwB6aOr3zo4Zy//TiP5jEDHCgwJZU8eBgmi
         loOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768331764; x=1768936564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ScbrhvmjweTqkN3+3yPcwAeK769lF/fHEHFkP4nsS9c=;
        b=DdXPHZvrpMYLNPJ4dTF/ifYAOO8cWKcMvbbIJK2oUyNaFlhGa3Rp+oYQqlnz0kxb89
         nHm67baUYWfVczv7gMHJ1aVcCu4p+5OYiN/kH33JAxQYoTo1r7RVpTQiBoZ1LDi+SnL7
         m5L7tk4WJxgOzLJLf70yJ2o8M2bnF/Hpytz0PAM28NsVGjWFiIHwtX3ykWkXi7MqSFNT
         ZYgcX+Rbd4UXIie8lFXhnoi4Wa+eDhGaIjBKnf9eQKFKiTPx4hAip6nkcG7g1oStabAq
         oOpAKOmuQVhcgWQeiokWgYQE1KRPH/S4xIAVi5+XUd4n6q/AUlMA2BAwSxdoL6krT7zY
         Z4tA==
X-Forwarded-Encrypted: i=1; AJvYcCXVkltYbQ+HOvzqAetlOoI5aUami5A4pB6a0SFD45ifDTgqV3tZI67RVFS57/kpBD9HREI7AyGULg==@kvack.org
X-Gm-Message-State: AOJu0Yxdo6eCdky2r1aGNDyj2IuNuyv5VdvbgixsUuZTSG9XtTqc4oHY
	Luu4pAl9ouMjerTJ/vxyHfRlaWHtkOsB/FU0AsKdkHktkkuR2zq0OxWM
X-Gm-Gg: AY/fxX6Cj4Q/AzuUqC8aon0X5CokKfpLyUCL0FhAEAygxhrcnQ5df9LOowqn3e/+VUG
	dzGt85uqi/iO05m2ocHhqbG1VDQb7lk8KAYsUaK/6AQu9vt3zCElnGY1SAHhlG+eDwuiE0m2ZyI
	P9GL8+DRMeh6zJfykkeYZKWHfeLnLQumrK9g6h4i0rW5eRI114SiULaBsMAa7/V17iF/26ldRhd
	D0YTTjL/8sOD8qDKygX+TuDSx3wmawOzJC76Kq939EaSYoGU7P0Y3h4lJaS6YknQrnnuPdeHT6v
	SLTrgNXhV4w3GQ9J9NXPrJYRXmD7BMEGupxhZfQiaM8HAV6Wk8isKFyqebS5NJ9o8Exbrkn4IC1
	7ii3XjRCN4oL7VxIXhys0k8LfTr+OvqwqkDJc2wemUGe1xNgPGZkV5UBOZPMH/ASLZkHjfY29NZ
	2gzmRgyTOXXks6/2ONa74zA3Occ0EvXFkuyQ==
X-Google-Smtp-Source: AGHT+IGGXqubwqWQvOxHpPijFjOtSWMATnTJiIx5uzDa1+KnveMhOStwFWx7plRcy0RaT4bsGUqVWw==
X-Received: by 2002:a05:6512:3b83:b0:59b:7869:b9d0 with SMTP id 2adb3069b0e04-59b7869bad0mr3414712e87.3.1768331763812;
        Tue, 13 Jan 2026 11:16:03 -0800 (PST)
Received: from dellarbn.yandex.net ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b6a97e94csm5568773e87.91.2026.01.13.11.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 11:16:02 -0800 (PST)
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	Maciej Wieczor-Retman <m.wieczorretman@pm.me>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	Uladzislau Rezki <urezki@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: [PATCH 2/2] mm/kasan/kunit: extend vmalloc OOB tests to cover vrealloc()
Date: Tue, 13 Jan 2026 20:15:16 +0100
Message-ID: <20260113191516.31015-2-ryabinin.a.a@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260113191516.31015-1-ryabinin.a.a@gmail.com>
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
 <20260113191516.31015-1-ryabinin.a.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: c4pkg3enatmysyiibpb69wjdkog4qb69
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D1EC54000F
X-HE-Tag: 1768331765-720641
X-HE-Meta: U2FsdGVkX1/ZgQKdy90EP7qASTzereGyBqLoeM/ZFH6ZrTcBLtCw7mLkqUw5TJUefnfrlt4dWGtQddeZirgf8T4hZUXKW9Lpf1lY/xQOYkT3dXbO8GKaa331YzOuf9A3fKnQGL8Ssp0M2KTc5tdJNjcyTqYa4DonxUggLbcZUYj7h2WGr9uwusD+cudg+/CH84CtXbaf5GFv1kVbzmFggMcmN8CoWbv3Ipl82um14TrPNYVu9KcVdcXw7Cz3qarjL9EKdfjoL48rHQ5V/B9c3PeSRWwvI/3ocas1TpMTCw2OsuJwuzgrewgyaUbMgeL9msbVhD3o59Al3VPHQPfz/62robCsKnUMeLZmQrlXr/CEt+iNuohzAxXTSY+y8/WnnNa0vb9l+KauGSsPiUeOKJqXSmzx4WWsh+aLYvqJvDkmYCmFNwbdc0S3QXjN3pJ4ELDSw7lzl2nvs0kYQAzAHD0tkgLzkzMN76+Tp84OeWDD9U+W8uNsLHaGdpJjpn8A5fcQkrJml2sB1oSzvevq3IJ5Uy3oTLGCgIflaIn8WTrJRJkC3KbTgowZFuYKKXG9V1zTU6CP5Ih0tPZkrcwal1igEWYltnZZ6xF4mNYJAJN2N4sTB2Sx8AW4uGjIbLhRlj+e+LWnqDsvWivv33hlGLsNpcspVX0KMgXQNrkWoBoJQMf0L2TRAPZXiLG6flWKvK1iYl/UZ8x4kiDQ0YZ/ZOMQJlqiR3ibdMgAAwGnb1XhmDrf01XkkVMT6PsxB83IZK30Ob4NUxnaBLqHthoTBPw7QAHo3jc0VfIeVCc/p1n2LXJfbmBf+0OH3ZJjpfSt8zo48wE/8txt7T2S9CqC7cg3NB+eyxXRLskNi79F+cx3sNf2d68uoLn1qmor3XGaPL+k+smptTBq2yLJb6HDlVvxLshQSlYWuOZmrWtxD4ep3EtlAGdADCZ+LOChlZi6Zsc7o5qtTm47Q3tV7KK
 7oaaIIXY
 GBpRatH5PV8J4/9Ly2j64GYMOYuJPBkmNeGHCfdpGvSTX6oJd1g5FXZJSXfbSZZ8Q+zla1cRiQu8pRVzE9bvgcH58o2YFwWRgsuPLQLsPZFu4d3/TZvKCx4zVpZUE8j3cN7V2DdbWTujj4z5Z7+x6GzsXGsZqF4YtI5JV+NnN1/ytmy21ywD6vtjauYeZZxE/8KwpIbrZoZRpZ0dxbSUHgQL6pxemcf0mI5TdRPqbn21+8FPABZLeryZ0G/N69svsnvOn8ql6Fsq+KmVtsbImSrEbDOxE083zJ0mdqz6/R5dBUDBMwbXIJiwaF92+PKiCmyCtIQRGFXxeoPp4/scYE0GqUg6nqNXznPfFmRPsiK2aA40k3N2vLjBQf/1IYvziakA+F2YeehRa57z+tF8ugzpceaZFuEMNF0AnrTuPQKbA5x8fj3AMoRiUpFqyp0v7/pYF0XvpKO5xea4ICBJzmYkICcG2vfqNKSAr4MgYJzcRLaLyA7u4OsR86nYnpwmFElNUYalr2KfeCno=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the vmalloc_oob() test to validate OOB detection after
resizing vmalloc allocations with vrealloc().

The test now verifies that KASAN correctly poisons and unpoisons vmalloc
memory when allocations are shrunk and expanded, ensuring OOB accesses
are reliably detected after each resize.

Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
 mm/kasan/kasan_test_c.c | 50 ++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index 2cafca31b092..cc8fc479e13a 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -1840,6 +1840,29 @@ static void vmalloc_helpers_tags(struct kunit *test)
 	vfree(ptr);
 }
 
+static void vmalloc_oob_helper(struct kunit *test, char *v_ptr, size_t size)
+{
+	/*
+	 * We have to be careful not to hit the guard page in vmalloc tests.
+	 * The MMU will catch that and crash us.
+	 */
+
+	/* Make sure in-bounds accesses are valid. */
+	v_ptr[0] = 0;
+	v_ptr[size - 1] = 0;
+
+	/*
+	 * An unaligned access past the requested vmalloc size.
+	 * Only generic KASAN can precisely detect these.
+	 */
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
+		KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[size]);
+
+	/* An aligned access into the first out-of-bounds granule. */
+	size = round_up(size, KASAN_GRANULE_SIZE);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)v_ptr)[size]);
+}
+
 static void vmalloc_oob(struct kunit *test)
 {
 	char *v_ptr, *p_ptr;
@@ -1856,24 +1879,21 @@ static void vmalloc_oob(struct kunit *test)
 
 	OPTIMIZER_HIDE_VAR(v_ptr);
 
-	/*
-	 * We have to be careful not to hit the guard page in vmalloc tests.
-	 * The MMU will catch that and crash us.
-	 */
+	vmalloc_oob_helper(test, v_ptr, size);
 
-	/* Make sure in-bounds accesses are valid. */
-	v_ptr[0] = 0;
-	v_ptr[size - 1] = 0;
+	size--;
+	v_ptr = vrealloc(v_ptr, size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
 
-	/*
-	 * An unaligned access past the requested vmalloc size.
-	 * Only generic KASAN can precisely detect these.
-	 */
-	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
-		KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[size]);
+	OPTIMIZER_HIDE_VAR(v_ptr);
 
-	/* An aligned access into the first out-of-bounds granule. */
-	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)v_ptr)[size + 5]);
+	vmalloc_oob_helper(test, v_ptr, size);
+
+	size += 2;
+	v_ptr = vrealloc(v_ptr, size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
+
+	vmalloc_oob_helper(test, v_ptr, size);
 
 	/* Check that in-bounds accesses to the physical page are valid. */
 	page = vmalloc_to_page(v_ptr);
-- 
2.52.0


