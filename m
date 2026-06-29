Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD40AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB4C66B0118; Mon, 29 Jun 2026 12:38:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60946B011C; Mon, 29 Jun 2026 12:38:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978306B011D; Mon, 29 Jun 2026 12:38:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 738E56B0118
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:38:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7CD1C10BC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:38:01 +0000 (UTC)
X-FDA: 84933507162.15.ED1CF04
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 108AC160018
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:37:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E7RFQJrP;
	spf=pass (imf08.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782751080;
	b=tY5o0vA4/odX4Envo8eHgoBdCoqXX4/2Xxq+n77GjNwWm9+MSY/GVNPzGAqETTelXZGYOn
	jBAXs5rV9yJC2ci5Pv7evnwOWjOBy70HaYcuGrpDkiHpJLjRy5XcqlcAMbNcntS5oHAiav
	4P/qjG5afYiNsc8QJYIaR6AJGf49fFg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7qMl6JaTusMjQ71t10D/Z6xyVtqjy476HmM+ncXIDo=;
	b=c6rW5jT3zkyGZFI7sKOKRld+vIJtqgJxTE2wmaNcrOiGT0F+1wqfky3HdkQVnWZ7wibwkj
	zP8PLytsKh0IMiDiwXqTTMzCVcYns6rnoTWu74CvGPa/gq0cyTFdE1XBP9TKd/QRWdv4fn
	HvHEI/nOqDeFlxHvY5+4rDG1J/jZQWg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E7RFQJrP;
	spf=pass (imf08.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8478fe07f0fso791299b3a.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782751079; x=1783355879; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y7qMl6JaTusMjQ71t10D/Z6xyVtqjy476HmM+ncXIDo=;
        b=E7RFQJrPdr9PckJBMqyU+K6Qse2VBN3jmPbfMZiLiEeURi5yjhKJwLxYgsOeokH9/S
         8MEvjDmvN7SpXGOuf0Z4EMOAoDU8MIilWS2yelGgLTjsy7XUPNmwBCrvyUwlcd6LcNY8
         oupXpwY9FTg3aY74xdDOgCHira1FLMdpG+mkeaVW1OJBW59f7iwh4+N5H6MFcuMCP0SF
         NImAvIqYHHVx7M1vB0dOGDDP41H6PB0jy6lFtQAxQvqfyRzC9/O4KUK1J08SdBJt3jXT
         Y63h65btpVE27j/xJqlOOAE8DLgbuTvUKsGmF2i1HKYdB0oU4ur1ByrEaNo0J6YuTBgv
         fBmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782751079; x=1783355879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y7qMl6JaTusMjQ71t10D/Z6xyVtqjy476HmM+ncXIDo=;
        b=bLUCW9pSMZElKumH2k8jDmSdWO0XdkGrC02omqeu1zZF5DIEgcFir9gmuVNokv2bd2
         dGo8B/1dYyE7h8KyaPCBOSPEWumYqPENwY1e5QPQzVwhf5VwN3uspOeReMDp7KaFXYAo
         nF+5ikC3DyscoutdISFpfaMxKztGJCYl2wJPQyoOM66/XtMyJAqGn2gzQheEcAtxvmSm
         nPEJGCjNsdG+sQWe98ngCE6YADimNf/C+cYEBgeoNxoOTYerSsdx/2iV/GxlvV49hMUw
         4K5yd08pTMc3Y2TDP0l2iTT6/qM7fB/1rCiZpHt1HWcGj8F0HN5q6dJ6P6hyEZ49nR0p
         VLLg==
X-Gm-Message-State: AOJu0YytGqZ3W15hEvL5HPdlvpgKg74GUy5PzJR/voihKRwFi6kFwfaS
	MFfKwwofIf+UVGnJsDWNTV5Gstvgr6lzDi/WF9HA0RRD8y/UM0MmMtBS
X-Gm-Gg: AfdE7cnXepXHMRkt+2KmCdq+LfqOfUFQUIkU+nFpbVFwT8HM8mqHm4RI9rq7ps/X95f
	Mt0kFlwslsO+5ARIgOdXsO5NhHD/18RPe1ratsyM8A2wzAwYg0yphdeh+/dGlq1zBNCuWuSgbBM
	YApgBQs5dHCPXu3oD9ROy+FOFg3bMyw9ZLw272L3eDmnnaYzanqEUQPCtRGFwK03c0x42GpFPBS
	2GxPzC8pdSt92BL8UwW0o/9nO9s9AmbotanAxNfo+bZc3cvDhjNrEGQT9Ws5YsfswP/dgNyW1y4
	ElajV+BATyA7jU5hSpTVtMGHuFQ0DaYdFwT6EcmZcQLwzberX6PeDZDKjX6R93re6nOdShWsQrT
	mk/LZ+gzfXKGr95Lgvlm1ShVEx6WqdOz1RZiArJ9a+kRDe56hkAdWdk7KFXF8+t70D/OCzXuskP
	MUgCTwizU=
X-Received: by 2002:a05:6a00:3d55:b0:847:926c:5837 with SMTP id d2e1a72fcca58-8479efe8fcemr225164b3a.11.1782751078897;
        Mon, 29 Jun 2026 09:37:58 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847a02d41c0sm18474b3a.33.2026.06.29.09.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 09:37:58 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: [PATCH v2 1/8] arm64: mm: remove unreachable invalid range check in kasan_init_shadow()
Date: Tue, 30 Jun 2026 01:37:29 +0900
Message-ID: <20260629163736.1606688-2-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260629163736.1606688-1-ekffu200098@gmail.com>
References: <20260629163736.1606688-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 108AC160018
X-Stat-Signature: 55jyyji6ep8k8p5putcj7o9pqghyhbfw
X-HE-Tag: 1782751079-592550
X-HE-Meta: U2FsdGVkX1+0ov8KWRBBo33lZWnFEIZ+ihB9Fyu/X+1wOuxzooFL69HsSP0DHpzFVazcBH8YiXSAJvh02cHSvSh5NsrEdnl8g6FsNpO1EatxEjEVZBEuTcVyNIRGvzwWGq5XjqBiMU8HeLiZBTuJ24qUE/fmivyOyKOHJ9WRRiUO//2KfXv5+ninG7DmBkliYgOMDF8RXBYyKByk/RvyCplh+JruUprHM4RyzetFlFbb29QFBIMCUIwivyq0jMCPEWXZsGe7Evs8H/oopqhIpZO3o4VwAW7UTuNMNKS9Vhs4bVndTa+d01oQUI1mbnzlWEQG6Bpiw46kX0JGqOneocsjYzMDKVdoAJ3kmKPNjE6+O9RF43RXJzRFEKlLDrow2835gSxw9IZXpQ/DJXWUA22A1u8aloPpIUatZXwJeB6RYslRZYFU/HsANAbJxivotxfVaHbCK+eIqRIgVobpozUcngQw0Tj+xdIaQiWX7AOWSWlfpk9d6BAu+quGg/rYVs+4WQO1gxM2hk9caRPBgvYvW2BUaoxh5DlfzfeTBOWxO+WehH/8O8i0s7ateRhfescpf58Gn0YjYNeXbuS+6UCD8ByMNygf+7bvTL2WsvzM2ZhuKXXrDceJmbKteec9Cb3Q2fvZyZtPO26Rgvlp5oB3gt1V8x/hTt0PsauEy1OYCGUwKkCh1ph15lT0jOSEyR5woMcYHpEoeyLFimAt0WcqFGk4fUTDEigDRd2WGzwgmXzGuw5M37nl5sQQF9uaKDuAMHOq3+aywe+rchpX6BB6EwbnlUeKytL5fj/dR9po2TcDJr8VZS94kjY8hRZgepCjol8Nl7rGxbT8aJUuO5x5SXAsiUH71D75yoeO2WNJnME8ReLIBcWNE3M5/Clv+YTahfn0vLyn8G8bHkfJ2SG4qWby5VIqucVFPHLzIIpRe6ADtVdf6Oodh8ULfB3QxXBz8loK3jBeXfTo9gT
 wpnXltrS
 /xDgCaZUvmGi+KAOT177cjzc0ZIY+q9p/ILF2coek7a7lZtCZlRCeT1lAwZ3lNHsUOGLxlRi92uXXkuoNkrf47fRo6fyuqKc1Teyww3HbqrQCxrQAB/fFT3f8a4gpEYtGssAsAafA12myIyKJpYh0CPQObXfiMkUQCP4kVDdaPyqo1g7gyIWWfh18btOamli/aa6M5S1PKWN6fbtUxxWenCZI3ArHLXUiodS1JOYRk+PXQOiLy9wQ9bbjTUEtj1B/rbjb76omRdyER4OJD0fGQcXgZALnCpbRTLjwT+tu7q3pu3DiirFjjpdZT0Mi4RLCpzOZGr/k1v5cKjANZrkdfazM5DGsn0fgp6gh7C4LzE/Mj65GK0nPK6AIqIw17KdAYdFY8/jrgP4QVZ9J2sMo1jUBL7/CAoOZlarBVeIQ3h0kpSjSJ4hK8SeJKCe6J0DO5k/FyUboErgs/YzLGTTtE/dvKD5XKblMMJAIJpwRw2EJ5x1AZRGeljH6njjwnNlu+wv0s5m1Z3yW4J5YxvqyUDPomT5u1FGtx7/ihzGAzfKxdTc+fzbxMeIKrEIsBwVif9ay
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_init_shadow() maps each memblock region with for_each_mem_range()
and breaks the loop when start >= end. for_each_mem_range() never returns
an invalid range, so start < end always.

Therefore the start >= end check is unreachable, so remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
 arch/arm64/mm/kasan_init.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index 3fcad956fdf7..45fbdce684c8 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -353,9 +353,6 @@ static void __init kasan_init_shadow(void)
 		void *start = (void *)__phys_to_virt(pa_start);
 		void *end = (void *)__phys_to_virt(pa_end);
 
-		if (start >= end)
-			break;
-
 		kasan_map_populate((unsigned long)kasan_mem_to_shadow(start),
 				   (unsigned long)kasan_mem_to_shadow(end),
 				   early_pfn_to_nid(virt_to_pfn(start)));
-- 
2.43.0


