Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04BE2C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:04:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC8996B0115; Tue, 30 Jun 2026 11:04:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0016B0116; Tue, 30 Jun 2026 11:04:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDDB86B0118; Tue, 30 Jun 2026 11:04:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B6C866B0115
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:04:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48C3AC2365
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:04:44 +0000 (UTC)
X-FDA: 84936900888.11.0DA4013
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id 59E98180017
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:04:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PiTEfM9j;
	spf=pass (imf16.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782831882;
	b=b36+jE1umLKvYSvQf0Kj0X/S/u2a11871dBN5f93ZRJBDV+NOavmNMApDlqa58Fmg1pkzp
	irFKrmskkWzlFRnU5zPib3683MEfvzGUKMmIzpQom4j9wQHkUXqlp/Y4FliJxuE7BjPuev
	R3ndfBZsbLjpGaac6QQz0CjzyxiZvVI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782831882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xo8uO5n6psQwUEUWovccxe/ZWX+n25l9kiG0x3jxhi4=;
	b=ApeTuNumbrkNNO8pax2QwlWHe8882jFw22V3Vr8T7qZ7IJWZoMGJ88w5jOFLdun7hA9fx4
	ZLK8IHvKpIgUGw084/54A3JhWpfDn68aWR5kA4oeY//FJbDwMf5JD2BV+nKZmMnz2GpLUX
	GFMMYIQoNP7jLq9zclNK4R6gq9CVJpA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PiTEfM9j;
	spf=pass (imf16.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2c82538b6b0so32769145ad.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782831881; x=1783436681; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xo8uO5n6psQwUEUWovccxe/ZWX+n25l9kiG0x3jxhi4=;
        b=PiTEfM9jD2uE51yvPyRX0HI0cyv4lf+v5wnQoj4qPM+v3clOKP3/YyeEr7bcX88lW9
         DaYtjfcv1VxNy0Y+TkoDNtulE+MAOctdTvUwDpINpI3daDWMQCZhgluwZx1RSunMFzYm
         OWss4TFPDMbAO4gWToAZGWaU9J4jlSuWzXL+PlbePUzEopL4fDrbiyKp20zMTnHZDj/p
         D+EOTH2BKYSkNBxCqfZFLArV4MGXG40q9UyBTTWNHboR01sgDlUorYxu38PgZM5ewWkG
         RONqwrZpYA25TyycVZPM5Y32Qxkm2bYFZmn9sp+4QezZ//RjePNuO+j0Ykt44+vPkkmF
         BG3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782831881; x=1783436681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xo8uO5n6psQwUEUWovccxe/ZWX+n25l9kiG0x3jxhi4=;
        b=h4tFPy3l8QxWzOoIqK2XhTx33GYRxQFR5BI3ENUSOeqoME2ImrRSTOPIAvvJHvCnZ7
         I/Jv6hpuf6xcdZiam/GREiOnW/lLaotfZLZIqgx82WzuVkXbxgd5qDHtC+ObqcPUzBe9
         FDsCGml8uXwUYc3zmBSAzlOMsnyqTnwQ/l007S45T+QLRkb4tX3t6byuNTCU1iUVJWiF
         mpKBc8wHS3crSWAsA9e9dcnrS3CSuSKeQiQqlOuy/VE58RlUxMArffICZc7IwT8lSRne
         U2enjAB266ZTAjKm5L7iy/nA3iOvH+YSPZKH0nMneDNQszfAW6VCsGb14D+dcl+Zcx/A
         2NQA==
X-Gm-Message-State: AOJu0Ywnt+ijKxRyva65r8DZNvIOvEGMZpwCpAtjW1onT6VGpIF11J4i
	7FhndIxgNcVnaU0+eEuQFABmEq3S30rKbP4W6aYv30CV3Ifp8oFYcVdgNhbF7CNq
X-Gm-Gg: AfdE7clQI3dXrb2qd3xkXpzXNFXV3Nb4wUjD5KvmtNvs8OtEF4oDWiIOMqv/+1i1Q0m
	0zq98Sr2N9lcSmaCxNzShEFBPkC2LGR6sytG/w37FuBf4knkk/OY9KuMPFfWujH9KChVIHgLigq
	7/xsi8sji8dcFypCX2Ka2TTVNmXvv1MKLcXaSYV0TT8TyL1m51TwXpEGzICerF2E59xFq373s4k
	FF/onlBoFXJ9K6FeiYomGZg6FbmsA8TzLIWTquk41piiETx+tcFOVohTBQFa9fee5OYrOUVsUPU
	AGgqRjuwoapd5xxOlr+D71k9k1z/HbLfZ4PwZuoL9NQOqM8qdD7kl74I96BcpR7fpJQOvbwlgVO
	jAMWRpCJoKWORPz/lRRncwpM4XFRXbJl7bZVxhEkXXJRtbISJoqLEMSEVB5k0O+ju67HyfX3egb
	Rta2ZDOzg=
X-Received: by 2002:a17:902:f788:b0:2c9:d8c6:1dc3 with SMTP id d9443c01a7336-2ca5a449b1fmr7709675ad.0.1782831881138;
        Tue, 30 Jun 2026 08:04:41 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37a70bc0sm16250465ad.10.2026.06.30.08.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:04:40 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	WANG Xuerui <kernel@xen0n.name>
Subject: [PATCH v3 2/8] LoongArch: remove unreachable invalid range check in kasan_init()
Date: Wed,  1 Jul 2026 00:04:07 +0900
Message-ID: <20260630150413.1718632-3-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260630150413.1718632-1-ekffu200098@gmail.com>
References: <20260630150413.1718632-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ny4ynrda5so3ayxfir6xgy7bto3f134f
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 59E98180017
X-HE-Tag: 1782831882-875790
X-HE-Meta: U2FsdGVkX19wDyYPOzf/j4zGEdGQ59DCarJZRka2ZBodQV1PSmXm7OLa5EuS2h7CH8dyFi4raf44GqniP//WazKuuFu3P5DHGK+RjpPX92qcMemlFi/L+AOpNG8Du4xw0XMOjae3kz/riM+CWWfRdEQtJDD4zF2PEa5g22aoJX8TZXvwZvCw9jDpqQ43Lvyv0gdol/VX8zgeMf2+gOluc9UXnGelbazduHxbwMMfW0jdXAZH9m1wetvHS4wcjWnCh0LXbtDClrN53TrpeY+4Y++BtSaZVbvj7YyihU0GiWTvypj14aZM0BNwzRFJfqwovFyuxy3yYfG4OH87JiVynPiKRkhQawhlnOZRMUcTDMsaUco3Ks3XPx4rg2wmoAQWaanIPDXpyulnjy37cUKp/FQSaJrc4Pt5fm4sILfTWsdCIKdzgyC1zamndP7mG8pIkkr1Sh1UBxsxnK/n9cgpyMRXg8Zgztqvw5J9ZiN+RvZnnNCgLyhalbtu6hfm3g+FurKsrW8ybTs1DZfSPPZnoGcVxJFC0olbi/iL32dvEbNN5B7D4YKM9aM2rgVvJQZ+KhlzuVIaYz6FUMTAhKTSeLpL8Q9Jjv0M2Xfy+LxtS1HfiXQnFp9dYniN1Q5Ipm1JHBw9k9PFpdy7gync1VEuNDeNlr4u2adMJdugmc7iJPV8rGqVS/g/3EbVXCkamWZxfT89veTWaWqz+nukiruMIVHbl/Tb/1BOAE8ixey5wZQNOMw/8VYaNTPVXwRxCgccBz39THRFbJ/K+djWY0oIiW/YMxl5/IJJiDXR8bLAcwOoRBKzYuCA6osKT5q0mYkcy8D6Z2BNMVuHhe45eREdav+MIZ+tfGmie/McWw4H19oddvSFT/dyO/DKP27Ms2IavR0lc6R4jVXmxDptLGDfIK797sIkzAryRn1Ae9aHOkgdzy6XjUt8dUUOlYGK/2RGNyGvPJlRoaKWQJc3U1J
 ukj7CQwt
 Ic04HbiCP4pHhBek6nP9VVUmLvgkfA0nuLpDRjM+H9soRiVQ5eupEX8ZvklfcAFQHetN3q2EjkY9WxYB82o2DB72QjmOXWJo667yzC7Uzu+DgYVPzix/Rvcocm0FijiCSn4V+0HrIRySH7aTpX1AIhPWjxHWPP+evYkEYBPC4Ci/cmZZQm0ypSwA7VkNkkS/fKEve11HPnSIKE+deRxqCjXkQR1Ml0TfSwZGrrinS2ba1l5fjPRlIVnfsxyzKDRub2NMxUcIMlxUY0WU7JOhrH/jeM6EzbeaSI0PKaxIKzHJFN2lNkYlM1qmUb/THWtw5wOdBOKLm+OpxBcZL8QBJ5bGpS0tHjUU9YM5imdfb4dmqvrEN1JnPkQug8w6+hDgerCc+JhUFLZjlu/McxUZweyNZvvOXV4JI/e9tv/+UApLwpkcHJTbtsZ6utVij+BDx8UEdSDo1frc7POXWIk91gDOJ7UPoh+EtKtSNlFf+tvb/33ZKfp5zw12H+zgZu8ZNpKd9EF0oAOugeJt6wSz361aYN6eLy+od13a48JLDR1E3VJn/hcUfMDG9NRsTKOmrmkrO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_init() populates the linear mapping shadow with for_each_mem_range()
and breaks the loop when start >= end. for_each_mem_range() never returns
an invalid range, so start < end always.

Therefore the start >= end check is unreachable, so remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
 arch/loongarch/mm/kasan_init.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/loongarch/mm/kasan_init.c b/arch/loongarch/mm/kasan_init.c
index 0fc02ca06457..92ca0ba86406 100644
--- a/arch/loongarch/mm/kasan_init.c
+++ b/arch/loongarch/mm/kasan_init.c
@@ -305,9 +305,6 @@ void __init kasan_init(void)
 		void *start = (void *)phys_to_virt(pa_start);
 		void *end   = (void *)phys_to_virt(pa_end);
 
-		if (start >= end)
-			break;
-
 		kasan_map_populate((unsigned long)mem_to_shadow(start),
 			(unsigned long)mem_to_shadow(end), NUMA_NO_NODE);
 	}
-- 
2.43.0


