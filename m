Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88EC0606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Uqhq9h3k
Received: by kanga.kvack.org (Postfix)
	id C09BA6B05C6; Sun, 22 Nov 2026 13:45:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B940A6B05C7; Sun, 22 Nov 2026 13:45:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A34506B05C8; Sun, 22 Nov 2026 13:45:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD156B05C6
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13E30806F2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:21 +0000 (UTC)
X-FDA: 85463632842.04.2116254
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf10.hostedemail.com (Postfix) with ESMTP id 53EC3C0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Uqhq9h3k;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3PTgDawoKCBo9J7EK67JED6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jthoughton.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3PTgDawoKCBo9J7EK67JED6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373119;
	b=k0Ojux7CeeIeuaFKaIwXEt9cGvCyRJQ3j50r3ACBVamouHxCFCg8LUip3z9hZWnRFvBS12
	A2PGrCWY2dSH7dm0BBaHtbLieKzQo6aGpcXN4doV3EfNINMCoNBsmvOAlzgWC+3nGRgwDg
	FT2yh23sXTwnn8408eJzqmk7nWFkKP8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e4YD2Qkz46kmJnaOLt6bMlNGRTvVnPoZLyisE+0GvOE=;
	b=PNv1DM0NngFyBsV+zDyQxpyyTdAB/Uld+NNvIE3tmMFvS6Yx9UK5kAIC6CdOMTaK4saV+B
	ghp+9D1UlfTnCXpqzcX8i/iBSTy4r/mqgAoH9ZSSyp1MbZggWaXuFXNaABZq34M7r+wwD8
	oewM4E+W+EUOs5TPuUVM3PgoSlV0fa0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Uqhq9h3k;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3PTgDawoKCBo9J7EK67JED6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jthoughton.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3PTgDawoKCBo9J7EK67JED6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jthoughton.bounces.google.com
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3b45655b428so1441114a91.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795373118; x=1795977918; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e4YD2Qkz46kmJnaOLt6bMlNGRTvVnPoZLyisE+0GvOE=;
        b=Uqhq9h3kvyTYaBjvo4x0BScLxPEqwam9uIK8qe2yypneIRaIYYBFFxthqR0x3KOCw9
         xcynU6+lK7Nii4uBDgLsJwVkINye21VbYq0WVUHrfkktXYGhQJIFm+xDT2bA1cntFFYJ
         TtMjsEYogvWe6iXQmYZaF5QZbB9a4/LxdwUo6NZMbMWpaePnOPIQfFFDRPzpvJY13ljY
         DO6qXUVwmFoCirrc6oZ5pl9SvyUb2KQSMklVi2/V+gSXME/dleSujo8yqG9thcoBYOUf
         8CcJoAijmC9XExDHr42oVxFiDGCTucgF2/n/J2HkaHnqoZ5tgfI1koVI4nQ1tchBjogQ
         4F1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373118; x=1795977918;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e4YD2Qkz46kmJnaOLt6bMlNGRTvVnPoZLyisE+0GvOE=;
        b=t+buz/j3O1Gmzrvx1WZF+fPHMdK0PSpzhQzKbQogb3i9gV+8qub1nXeK8ZrNUY3RWE
         0joPZ7uutuVgJEaEpDHnmMMs8OZGaLSKryKMqjgXtPI10T9XfGXwuKYVGA/2HUjmOaJk
         Qr6eam0IyjkuPCdKOqunrefgRErzdtZD5zAU1rbfkDaR0FuX7KX3r787Bxed3rvUvBzo
         9hLlSbic6e+5APRai6cWZR1dctXn89wNu8Tzt03CITiNG7AqE/Vqay6t1cwgdthhNb7U
         TgPKQ17vA8spqbvchfh/s4FEBKIjtf5urSycLP17j2lfd9sKl03ySiFIagSEQHFu2UnC
         Deng==
X-Forwarded-Encrypted: i=1; AL+hErFdrzQfD3U4KiYRc4/h/CxXXw7rHGreEehNanGLFKRrOeEII3Cf1k/K+r9qtnKerl/d8Y5FWqpkKg==@kvack.org
X-Gm-Message-State: APuU4Z/P2iK7CUa1r7SmGFubU1RmrxTAfDuQYA2pOc+0Vx6rp1mIqigk
	18WucJiTevOV5ILN71y2cFvNFBLyoThImMW+l+oyFbYNzKYVSqp8D+EJyEC99ws/PS4svToo2hi
	zsAB0xb8ZEuNmkaVXW8Re/Q==
X-Received: from pgdo12-n2.prod.google.com ([2002:a05:6a02:620c:20b0:cdb:928c:57fa])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2f8c:b0:3b0:b556:ba9b with SMTP id 98e67ed59e1d1-3b41c9b227fmr8076249a91.23.1795373117646;
 Sun, 22 Nov 2026 10:45:17 -0800 (PST)
Date: Sun, 22 Nov 2026 18:44:51 +0000
In-Reply-To: <20261122184453.2668189-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261122184453.2668189-18-jthoughton@google.com>
Subject: [PATCH v3 17/19 DO-NOT-MERGE] arm64: Drop BBML3 requirement for HVO
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 53EC3C0005
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: a91fijnynujfde9b5mfj99qdjdc34cf7
X-HE-Tag: 1795373119-336670
X-HE-Meta: U2FsdGVkX1+mFJTEe9bzK0/YTc0q2LF69hl+yGUsVsk8yFUpKrxx7XE13KZibSJY0++w9kvqp/PhX4iwwo8BKxyyc7m2asbFbGJsDekTzEqvMFZ6o4aqqjIJmsHsw8lIg19NO+Jj6eQWaMnZsxSYZ9yFM8ulN5jsv/B+Z1P3Teniux6Yirnlv14l9zgtP6jIKHESpudL2W/Zc+BaslN1rQAHqYpc+BFvzLxQOLfIgqLNVOnVkJiSeHyfL9pbeHKrzVhEhIOqOMhmPJpEcqgBy7KpRzB7/JTOM7W7yNbFqH91d8TPNvMQirgEDpB4LE682/QDUdg5qR6l+dzrzwG6nbTTf6Zo2+eEL3wL4KV5mzNgiLavRL0rqVhBB++Zu/t9dU3T3XMCxDBBiYvqM4XTQpG591KVRtsy10YIVXb9hfB9WqRPZTBzRl9u2rgCI9xIXQyccjmH8t6+g9AhQ2/mtGCh9nbnPwwhLTOEqUPxQjSh2VVbNm6N/yirer/E2vEs6RNImty2YquWWav0xDq9fs5Hfk3cGut7jaD8T0nEFTP2v4xReVebE3tichLYVmZqG55Aq2Z7hwoQamLqXFvU9I4YwmVL3qCS1krvwfHUNDLfvXB8fdiY/UX4qOv/jDxI3YYzS2loj58PNeGeTZPJIPY1hse+xlMZW2gmzHfb4XBGgghwO1Cu7BVyvsp/08sd2uTkhdwv1ckBx9wlhV3aXN5Lo0AAYVi/Hk888CT91bnkm+nBuHnWuhIHfQqERoybYJf3T8pSO6r2BsOWH0cNHSK8HtcVUUwwH7ElrlgbX5PiZoQgZJUU3RbyGdBkTYSeLODRlNQlL5TGlEs8EIvTAD/HPmD7gRoc2ZX2uatOSPXLa9qa8/GdIzMnImvghNqF03X6P7uAXZqZOQK3VD+KKP8g/whiidV7JZ+w5Fw27p10AXH8OioegV/YtVQd9r5NmcEp/+KCTEe5Ddlg2js
 4hfVZlLV
 vi+9Nx3noUUQh6Y6WaQrcsNqf3hDL3ZEd+Qe627kvU6k1Hm9EbFvLBnMKksqPIJ2vRxcOr8DzESuTBvBjmjWkixtFZRsPx4iHWtlYtug0GYXZhIz5Ov1GSJMkahu3UK53ebL5YYa0zjTd2bO2WuiPgjDh8F23V4d6c2h8N1Z/0M/wETRc393A9zQFwrO3v4HhG9lkvx/cV9Zkksz0eYchZpJ5CDL0OUd+l1F6WUcChOsuP8Kjml13IPXhkBd+X6/9i1Y03yRMOaGaLG/+r8ObT5+JJ0+gPjkVAdWrgrDo4XS2xas1WcwpcSpGfC4MWpR8Ta/h2GRQSEVIgMZGH8PGfNL7VPEDnQveUBFqrbN+FeHHTqoFf6FMLDNyE3cq+jP6MpKhMmY2Jpnpk3aO1GzfyRPxq1+z28XAZWEctl4q2C87QQuVWltNw0kEBtbric2MTmRK5tQJ9kTU/tauKjPz6C35IYNPJoG1E1GR6wzeBjzEsEaSNAxjXbANRkgrhyuzj99ZVSVPS1CVW3pAXw77WMHQMjtIT4aIVxjy0JOCYY8b/o1/156H3ZbsxgTBwuamDBJt9os2IJDweYo71Ws5lRIy3nkKrGDnE0lv20T2qW1HbncneQJwAk3QUfR0n3XTGv7i/CzRwRVObSEdkVW2ojSUSxt2szxgkKTT68cv+GJUhICfxRHrTmu3QhbQkdSsb3mxGECanyrssWjfpBFXnZlD9yS8/cbAotg4p9EgIibXRYMWXNwIA2d5lDhNH26Kyp4ATUbIpNZ3IEFvvyS0aBS8UmG5Y4UUBXY8oBBImylLRVs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With PMD updates being done with the Access Flag trick, BBML3 is no
longer needed.

Dropping this requirement vastly widens the pool of systems this
optimization is valid for.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/kernel/cpufeature.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index d241638b5143..6281769f4df9 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2062,12 +2062,11 @@ static bool has_bbm_through_af(const struct arm64_cpu_capabilities *caps, int sc
 	}
 
 	/*
-	 * We need BBML3 to support Block -> Table transitions without taking
-	 * faults, and we need HW AF support to support changing the OA without
-	 * taking faults. has_cpuid_feature() checks HAFDBS >= AF, reading the
-	 * local CPU's register when verifying a late CPU.
+	 * We need HW AF support to support changing the vmemmap mapping level
+	 * and OA without taking faults. has_cpuid_feature() checks HAFDBS >= AF,
+	 * reading the local CPU's register when verifying a late CPU.
 	 */
-	return cpu_supports_bbml3() && has_cpuid_feature(caps, scope);
+	return has_cpuid_feature(caps, scope);
 }
 
 static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
-- 
2.56.1.809.ga0b61035b5-goog


