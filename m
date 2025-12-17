Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 503F4D66B85
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 21:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E3366B0089; Wed, 17 Dec 2025 16:13:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53C336B008A; Wed, 17 Dec 2025 16:13:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D32E6B008C; Wed, 17 Dec 2025 16:13:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 287246B0089
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:13:51 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DEF801372A9
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 21:13:50 +0000 (UTC)
X-FDA: 84230215020.20.81C1609
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 04139C0019
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 21:13:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HmL0ottM;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of grovesaustin@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=grovesaustin@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766006029; a=rsa-sha256;
	cv=none;
	b=xiyvHnR/K/3Dx58DtX9/GApkNIg0BlyxhqpQp97ouaov7rGawkCWStzCpamBy9lVOOtgTz
	/sCledbSf6/jeOYcjG+ISPc1WRQW1Ry9oDyDMhs6HaOro5n/4LLsOy0KNVrM9NrNoPZICb
	aE2wPx9BoDseRuR2ZB6VOE9nOGQJbYs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HmL0ottM;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of grovesaustin@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=grovesaustin@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766006029;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WykdBCYT8yJh4sQTY3N188JsaYBSsyfv2BDjqpmbRM8=;
	b=11S64vDUAtUj0y/wooFw/Xt57rTd6jYcfpFq9ZZOfsJUmhINxLTYK3YcuJ33gTuujBXJOZ
	XiPs5JApbxVgdcqUTmCnOMaK0QmxDdDr6zh9g5NrcmW8wY324DEFRRPuTaALaInN3ixyDi
	wrzWPYrpm2wtm69MtwZjOZUsx3Im4yo=
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7c75dd36b1bso4986326a34.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766006028; x=1766610828; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=WykdBCYT8yJh4sQTY3N188JsaYBSsyfv2BDjqpmbRM8=;
        b=HmL0ottM4b1JpbQxzeuOUy9am2fQTLGS39n7IAo5l3VHnpTV5wk+mNVWbXfhnYKUXt
         rngACwhFXn8x8l2sp4nc26CIa4BGlHUk/D7G6W5fn6zq5vjAbZUZhf/TlZH3FKFcheJk
         LuPhJmrmrBxCAUXSVZZwk95fi6feBmRiEB63Z2w8Y9EA+eJe1mBORSdBVpWjkG1dzw4d
         asef4/lcWm0q83H2EeaPSIdceBCfcO3BYwg4TsGL4F0wvNWgq/MdxUpDyzJVHfKDLbgw
         TxIv1588MoA+zQgLe3XgBpmT4JJ9eLuKsBW4s4jNNedFuxVvUViNEpldEqENZiJqTf++
         dwLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006028; x=1766610828;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WykdBCYT8yJh4sQTY3N188JsaYBSsyfv2BDjqpmbRM8=;
        b=SUjwIiWLLkniuebaeYisYxXcqJbBf7gQwFUGAImrVyENjf6YFq8Mp00cGpJEsjlKgi
         CUqPogWGIqV97gMUE6AFvQiZENsZNGU4J2X0fksJt9xTIyfoHoO+QvbmhE6VTErWS29B
         pedsyoUQdKjWYFE3lfLDECdBzCI8VK4sdsQYWMqQoDEVZzp1IZWDfySDkj97NgUW4zy/
         B0BZZB1niJEue/uF7ks+2zhTXiFTB5cUmRKpOjtEq9Ghmm+DyNCe388a0P8RNG/fd6IB
         Cgijkhb/Dv9M3ANL3IFpWBmkDzLQFGZetKgUJARmGYAwKYgJWlZTskLMH75YGY4+FNQw
         jHDA==
X-Forwarded-Encrypted: i=1; AJvYcCWI9MlrnfvVxdYfNcgl+PiQpovgFXvbfGiK/qEVcJahlHgvNrX+mVa7jTmosYIqs/wlf10pAZv2ng==@kvack.org
X-Gm-Message-State: AOJu0YxiCMZuNiRkDvYleKxxBZe7Q0dRVGBL0UECEXe4l4Yj1Kb+WiDh
	D4gTGG2Z1+E+m6B07ZfNKsj4fNV+swycnSFUWwMAuxA6jM9gZPs1ycoy
X-Gm-Gg: AY/fxX6v7W/vxe//VFoBpIGipmy61OhogqXqF5M5ZQYDHlEfSFTXfg6Qj2+N1rX/QHN
	AMq6F0cKYQzAeeIfw53iat15AqTNoHPUJcRK8lCHXd2J5A1N2swVO0IAkuq0L+o8Sk5C7oB7GLS
	cXvVjJHl8NawWI3mVpR+VLPEINEZXA5flPdcg+pyEVLhACCR9xtEMTF7ACZa/O0N30OMkcURZf4
	XVuns3cQ9ItF8NrIRkVP/XfWKV5d7QSCuvjTohApIBSxVYN9rzyxZJB1VunMrHs3DxmZISnQBmB
	Tke5toQMsup9BSV0ImXGPFMAex6xB8+DBYBEtO9eCNVWJIbNMqSFadiQzbVOyHgfM7AfiR7209J
	318Ges9jN/zqCkN+jQdsaDpOe/o3Zixike2gNUq12p93U3jzE7w2Pss0IPRNpbjfGX3LrObSJ1J
	xb6O+aVN2Yxah5GKM4TNHlZJ/og3BYsq2UwwZFEAB93so=
X-Google-Smtp-Source: AGHT+IEJ79LfZmTkRRoNE6whe1Hjdhe/lgdvw3Z/AFdcRJKL1VDs0J2lLY280PufpqnuhZpriR704A==
X-Received: by 2002:a05:6830:254a:b0:7c6:9d7b:b033 with SMTP id 46e09a7af769-7cae8355339mr10935440a34.22.1766006027800;
        Wed, 17 Dec 2025 13:13:47 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a468:73ca:1f36:d52])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3fa179f3a71sm354640fac.0.2025.12.17.13.13.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 17 Dec 2025 13:13:47 -0800 (PST)
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: John Groves <John@Groves.net>,
	John Groves <jgroves@micron.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Price <gourry@gourry.net>,
	Balbir Singh <bsingharora@gmail.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	John Groves <john@groves.net>
Subject: [PATCH] mm/memremap: fix spurious large folio warning for FS-DAX
Date: Wed, 17 Dec 2025 15:13:10 -0600
Message-ID: <20251217211310.98772-1-john@groves.net>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 04139C0019
X-Stat-Signature: 758an6y7c9163qe43da3p83934b649yj
X-Rspam-User: 
X-HE-Tag: 1766006028-707122
X-HE-Meta: U2FsdGVkX1+qEf3yEvxRKaaG7+CZJvrBgsur789zQ0FfQn4b596U539HUxXy9ko0NUskB/cpzw4gLzPcksfnpCRlz+iMOjAsrp0sJmpexSpSjRR1sMWrVNwagIWo7uHCLLtwkpRaJtyPaTBgKKgbFPTXI1y+tcqpfDieVUrti4XGe3iihemjXLi11XiffkyLLdRaWj0HNY5F9Cc8451UYu2kLAej9xn09ZEb/KFKQ3bBrBrG0ZKkK2hUtoFxMA00a5HrMcTrw1ux7LtoNHWgLNrreiUxIbea59SQaVo/br7jM58xJZJYMIoRtEuOVCB1H7oiTbBVvGuPdvpGCY0aa0JW7gE2AKYFRvcO22j8UE0F1/PU0IuRuxLfGid63KRC9ejIkL/yMSA1/0ArmXuqfdS1ZM2GchXuvcTm5jJh3QCK20NDn7eOZTJRyVTNf0zJ9i/UhrjMGxJJwFkAdHur+NkHw1mCCu23fWTvgZ2OCF038FiPFdELDQ49hbh0w7nUUHCsXtgpfd7AFMp73tC1xtm0S1XZRhrFEzTud2vTHicTfDmDszRlRGOd1tE4W0OHxSJ9/ydPxl7JX4gGT9TEw4ONgWZy/uQUVhjLjv9Oc1pZA86LRdariPSCHWPx+gk6OrySpH45JInY6jMLa2qnyP4FxAbiWXm9eoMfc/R2/a/Ko2ctbpLcMRlpF4EMe5sNAjHXjEK65+DtXGbyP5FIszRsqbx8XC16HDpNLSsCxO4si5J6wwgqlPRdaFNr6eaW8GVxHeNpyZVaIoLbYEC5JSC1LJaZ0YpzsIFldNUk2UKahif2rwf32ij+IafU5oH3ip5pygrn/OlFABNyg0LINEsK0cS/8epskv+y0+eIKVkDQCnA4q0VJLI5bVAtugaHzGYGsLyri6lfe3tpp2dmF96UdeOfgVPVqM+2CcjzbMjzbw196MtPZ8WNpObgE1WUrKWdF+MJpkhBAbOnL0F
 SyoN9skV
 IoBT+VpydopFNvqVbfexC08TowSqqgWg4FqJCoHkYy1Fk43xhqRITfbRRV7s/q0ttj2c+z2/HrUIrUYDIDNDuuMrZd7zULgq2/KlD1eq66jdWlkoKm5g7FbkQWVvl7aApCRW0ujkt0jGdt8sKDOz4NNOaaNem4ERo6aImExEpIVcmF/8vNuKWEGXhwWx4R3Bc162cyBqvxS5FHJgeABcw7IVAZFwEf6es/OVYxAoxDTYemyzJjgyiBRpX0Wz8BZCZpwBmQ7pNJg663xR/14Am65CcKw0bk9WFun/i7aZPrA1OKnf44CX0xhBmVGBkoxPIdQItUsKFbjfHW1WJ4H4kJPqZ1zDIGY15TyHpyD4QW2Pkin2VzcIbxUATkHu2hhx9YjoZJ0G3Dqdh+kU/3DEO+0Ft8zsIvAFbFVZt8RaFc+i8ADyMKX+Nx3NyRrfJ2gVWHBUGW0fhwcyxFLwVy4Q/jJ71NBAwrbRcAqQZlYaMp2uAilY1DPathlRExh4YclOuT55+BAlxPOs6xjAclAkJwf9viuNcEDzrvbY4yjxEzEW4yOI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: John Groves <John@Groves.net>

This patch addresses a warning that I discovered while working on famfs,
which is an fs-dax file system that virtually always does PMD faults
(next famfs patch series coming after the holidays).

However, XFS also does PMD faults in fs-dax mode, and it also triggers
the warning. It takes some effort to get XFS to do a PMD fault, but
instructions to reproduce it are below.

The VM_WARN_ON_ONCE(folio_test_large(folio)) check in
free_zone_device_folio() incorrectly triggers for MEMORY_DEVICE_FS_DAX
when PMD (2MB) mappings are used.

FS-DAX legitimately creates large file-backed folios when handling PMD
faults. This is a core feature of FS-DAX that provides significant
performance benefits by mapping 2MB regions directly to persistent
memory. When these mappings are unmapped, the large folios are freed
through free_zone_device_folio(), which triggers the spurious warning.

The warning was introduced by commit that added support for large zone
device private folios. However, that commit did not account for FS-DAX
file-backed folios, which have always supported large (PMD-sized)
mappings.

The check distinguishes between anonymous folios (which clear
AnonExclusive flags for each sub-page) and file-backed folios. For
file-backed folios, it assumes large folios are unexpected - but this
assumption is incorrect for FS-DAX.

The fix is to exempt MEMORY_DEVICE_FS_DAX from the large folio warning,
allowing FS-DAX to continue using PMD mappings without triggering false
warnings.

Signed-off-by: John Groves <john@groves.net>
---
=== How to reproduce ===

A reproducer is available at:

    git clone https://github.com/jagalactic/dax-pmd-test.git
    cd xfs-dax-test
    make
    sudo make test

This will set up XFS on pmem with 2MB stripe alignment and run a test
that triggers the warning.

Alternatively, follow the manual steps below.

Prerequisites:
  - Linux kernel with FS-DAX support and CONFIG_DEBUG_VM=y
  - A pmem device (real or emulated)
  - An fsdax namespace configured via ndctl as /dev/pmem0

Manual steps:

1. Create an fsdax namespace (if not already present):
   # ndctl create-namespace -m fsdax -e namespace0.0

2. Create XFS with 2MB stripe alignment:
   # mkfs.xfs -f -d su=2m,sw=1 /dev/pmem0
   # mount -o dax /dev/pmem0 /mnt/pmem

3. Compile and run the reproducer:
   # gcc -Wall -O2 -o dax_pmd_test dax_pmd_test.c
   # ./dax_pmd_test /mnt/pmem/testfile

4. Check dmesg for the warning:
   WARNING: mm/memremap.c:431 at free_zone_device_folio+0x.../0x...

Note: The 2MB stripe alignment (-d su=2m,sw=1) is critical. XFS normally
allocates blocks at arbitrary offsets, causing PMD faults to fall back
to PTE faults. The stripe alignment forces 2MB-aligned allocations,
allowing PMD faults to succeed and exposing this bug.

=== Proposed fix ===

mm/memremap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/memremap.c b/mm/memremap.c
index 4c2e0d68eb27..af37c3b4e39b 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -428,7 +428,12 @@ void free_zone_device_folio(struct folio *folio)
 		for (i = 0; i < nr; i++)
 			__ClearPageAnonExclusive(folio_page(folio, i));
 	} else {
-		VM_WARN_ON_ONCE(folio_test_large(folio));
+		/*
+		 * FS_DAX legitimately uses large file-mapped folios for
+		 * PMD mappings, so only warn for other device types.
+		 */
+		VM_WARN_ON_ONCE(pgmap->type != MEMORY_DEVICE_FS_DAX &&
+				folio_test_large(folio));
 	}
 
 	/*

base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.49.0


