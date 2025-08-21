Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA30CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 13:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 480D56B0005; Thu, 21 Aug 2025 09:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E2F06B0006; Thu, 21 Aug 2025 09:29:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F9936B0007; Thu, 21 Aug 2025 09:29:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA0B6B0005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:29:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3DDD11796E
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:29:53 +0000 (UTC)
X-FDA: 83800847466.07.2AFB394
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id E79C0180011
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:29:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uTYp8Ndy;
	spf=pass (imf16.hostedemail.com: domain of 3Th-naAgKCHUcTVdfTgUZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3Th-naAgKCHUcTVdfTgUZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755782992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DegyuwYleM4jZaA29537JxprXH96T1dxgET4m+CA/9w=;
	b=k51djJMBMN5+4fHahkRMNKhuRgaNU4WhXqCtUBsUQbmuH4fCF3+uccS94ISk508YeP/SOo
	2QaoPR90+uLKNV2dhQlPUH/Qs2pZHZGfc7HYV5yy8ra2IUaOIpB7CZUSMr4EEP3W0+JfXK
	EI0DAntCoSZgLsSpxKvL5n0Mp89e868=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uTYp8Ndy;
	spf=pass (imf16.hostedemail.com: domain of 3Th-naAgKCHUcTVdfTgUZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3Th-naAgKCHUcTVdfTgUZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755782992; a=rsa-sha256;
	cv=none;
	b=rbFcHCxQeuCr7W9Yb0mUH7LPnWnE5jop/KZ/bjeqmwukbJBBFhHoaqi36fP7OcO8f2Uipe
	niICGKZDVqGzq5rbsOl5sQ5hO7DOL19bKu0xBRo4kyFcSWGlvWJZkwfEDRPgL0KY0e/45b
	0hIgTURUcZn/2tI8yMQlw0flFhXzAn8=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b9e41037e6so659588f8f.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 06:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755782990; x=1756387790; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DegyuwYleM4jZaA29537JxprXH96T1dxgET4m+CA/9w=;
        b=uTYp8Ndy3TZQT/TonxP+Cyq824fboo2eXdizyzMdqjOXgmeUiuf7a+libk0RpgL21/
         3rHLSd2b4RSX1ZlbenQRRx+tSapMEXC9jN1H2ZKeFg2kVpqjqbjK8pUi0mIVJDceTzJL
         2/fRoCLNexxaxtEJh7rMxmIUayAlQ9Em86/QwS4r2rHvTdt1Nxg7wN0r1h1CCKJgIfo0
         Jvtvi/3weXz/7FCuLe4jwb4zKAyt5iS0s3nyzF7rY8eGMDdbONTaZIEfnpiTKzhvFCd+
         ndED+j5q3REoVUUr2jhJem8XxumIbtUhcl0PLoz5rEMpV7iIL6MfYa6hSuBRQ53G7da6
         4Kqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755782990; x=1756387790;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DegyuwYleM4jZaA29537JxprXH96T1dxgET4m+CA/9w=;
        b=MPB1C++J1EgpaUNjpCKppebir4yoju9HN4F4+uZ3+KcAcKp/iFLuyMZPwTI4iAEFLT
         6g/Gu4pYkf0gTH7emEpEs1MKY3+Mb4Pd4THQ4tjHSuRI8a38tmkL4xdpGpZ8QYYXD5WJ
         xjAVkb+CHkI1NTDPp0Sg8fBIeBr6cbsQ2t2rXjFMwgnJXHXToDDVLNaUIXukdQk6MSmZ
         DCn3bCFR0HSHxG6NNMOVRI/bmHjIAO23GHNmxqJeD0S8wwasgpq8tSAgtUzQdvzNIz4g
         TqX/XOLrxDeIt5JjzoYrso0LIwon2XgDjJHEqWfboh77uFGW0/av1Pu36LO0D18udA0F
         op8g==
X-Gm-Message-State: AOJu0Yya0qw84RjuqATiHSDxwM27bDaax8wZ7ho4r1zMmhr0vb/89fDl
	ZfcKyHQLoFuaTeJTblxdYUfoyRmsQtuMha4j+39eEUEJG5t+NPVJ+VA9ujmrRYk4XOOpFK3jBi7
	mM4BjglToCwyMww==
X-Google-Smtp-Source: AGHT+IHeCbM6UzDocrt4nYe7pS4UHPtBeM7I5iTp4f8ugtwZCLnKyV8JeFtfE5g/7O/wy8nfgW7hflIeEVDT6g==
X-Received: from wmbem15.prod.google.com ([2002:a05:600c:820f:b0:458:be4f:f5e5])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4011:b0:3b8:f8fd:af5d with SMTP id ffacd0b85a97d-3c494fc60e0mr2056119f8f.11.1755782990192;
 Thu, 21 Aug 2025 06:29:50 -0700 (PDT)
Date: Thu, 21 Aug 2025 13:29:47 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAEofp2gC/x3MSwqAIBRG4a3EHXdBpUjaSjQQu+o/6IFGBNHek
 4bf4JyHimRIobF5KMuFgn2r0G1DPrktCmOpJqNMr6zRjMIrYnancEJM7txXeLaD9ioE1TvbUW2 PLAH3/53m9/0ApkhCV2cAAAA=
X-Change-Id: 20250821-is-migrate-highatomic-871c0ff05a84
X-Mailer: b4 0.14.2
Message-ID: <20250821-is-migrate-highatomic-v1-1-ddb6e5d7c566@google.com>
Subject: [PATCH] mm: Remove is_migrate_highatomic()
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E79C0180011
X-Stat-Signature: izd4zdy4jktfdtaejgjcydxkmyqze515
X-Rspam-User: 
X-HE-Tag: 1755782991-925001
X-HE-Meta: U2FsdGVkX180+ydWQwTHhfqvpinKbD+Cl0PumVGeTrbAR9vkZ8oTelyqEQgZNpYnjxPTXTFYfUOFG/TYminaNf4HE8F/6RAHFuO3foAMN4wqQUAi141hFKYT6mT/5A33d4+7fqFaqEMK9uW7ik3Clg2t9hIKbzTT+/4si/RMLTFf2b9latgKvgArD9DU5r/Wl2LDv8Wdq3bmu+HtMeE/ap7xGGbCzv+6QBmNJbIHxmgANmnj7EURmkmENoWOH1QB/AQxFc1pNvPdNzNC31jrJ1vXt8qaSUZyNgEZb3fjgu+uEKH+O/nFw1GNAW8gJjFv7AwTQqkEcYJtTjosZqJdyop1kNLDEJhDTHbMfH1F2mC6EVMHF6iA3M7VMJMBQz+m0IashTZ2qbvAiXqtBgaysvOsM8W7/vgr0C0p1nnx15bSXVVYLoQu6w10YOQ+pJwECsuKLaBA6i3M1KkbWG0h849HFfzl3EcUnp1MozTiPcuuCEvwrhAPuGRxUujdFTdwh5bFZ1g7hktC1cc7SbFfBgXQAnZtCeQUjH5SNH/xIULSbpY3/6d5EKkep+1vKS3McoI0urilkcxKt/nhnr8tPrja9F9WKGT7E2zKwhv7S5KvN3UG2a+n67Y27A1090XL6gXPNNzUdfx1TbxWAgTlb6LkxvsEAoCavSb6A3DKflhRUQ45rUTrOiEFCxiulLCTOoByrQdA3g+wO1prbWT5p5Q6jyLFVjAeoq4QxXsZQwwhvJDR1VRztW46HM8f1cjZVRxrBoSxaNbiu0N/T6GHV48cU0I2Y+wB6c773nQFpqXvHmxEDzCNeT7xizG4VBlgzmaWD3ue9NbRi6kEIn0mVYvpg1mfv+tnB1cH4izQ8mdjNPgW839gkUecY6MgCMbu+XNBd06eoiCmcgMwn60HUYu1g+3NsyxqyOg1vHMMe2LTSTW9W0om0VBlCwxF0hspJLRbUTYfDlnHlllRhOl
 EnZc6dxh
 Xkq90TlVZphZZMotBZXFt7QH9HM78XRpHQYBe899mP7SdmM44CCj2aZajrLsd80jreZJ6OXdGOqky2VtL4nevqMRq3k1FbFCrqgSYJaKsOv95YkWBubJ4y/dz602aPEh1hZrAqPyodDI6HezXwOBdVDCmVFTGWtVi04oG0zfjjjY0DrVzeE0Ar43Maq+zqet6LOFbcqEDOeGfkDxX0qkg1SmZ1KPnVv5z99bpfEOzzY4dCjCv57hAAjTjWusFbKrjhxhq4kbC7qQjqWNfhWvVu4Lzi3+OQVJJTXGNphsS5kNst45ckyVMjMmSftekPnbtT3rWD4+BCfpTlxG7wPB1JyYZPs2bok8dPb2PCRricDd7ixFQXbPFppvHFrYYG1GX9VEX8SRFrguh5tIvIq4U0oc9LJ6jfS8oaBpUarKdOwgs4d8wAfBE8YiAyRTPTDnRE+9mNkeBTk/CgIg8ZAfKRZ/s1chf63LFAcf5C1QgbpuTpFxwWJEajschSVPOoIJ5/E25pix4bRX0aje+zrwVKrfaKgOOGsr7A1GE/if6KIVhl2cm9uipwELLOQT/y89C2O8RSvIkcOIfnx5FpTbjVmYbGFOFcTVKEujglPCRmCLoQfTo4AZgg4sVbqVbCuMkDtJgyjZPnVKNN54=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are 3 potential reasons for is_migrate_*() helpers:

1. They represent higher-level attributes of migratetypes, like
   is_migrate_movable()

2. They are ifdef'd, like is_migrate_isolate().

3. For consistency with an is_migrate_*_page() helper, also like
   is_migrate_isolate().

It looks like is_migrate_highatomic() was for case 3, but that was
removed in commit e0932b6c1f94 ("mm: page_alloc: consolidate free page
accounting").

So remove the indirection and go back to a simple comparison.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/internal.h   | 5 -----
 mm/page_alloc.c | 2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc030cb22a3cb0ddb262b6300e65ed5a..45da9ff5694f628db18f740718f0a7a06c4548f0 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1333,11 +1333,6 @@ extern const struct trace_print_flags pageflag_names[];
 extern const struct trace_print_flags vmaflag_names[];
 extern const struct trace_print_flags gfpflag_names[];
 
-static inline bool is_migrate_highatomic(enum migratetype migratetype)
-{
-	return migratetype == MIGRATE_HIGHATOMIC;
-}
-
 void setup_zone_pageset(struct zone *zone);
 
 struct migration_target_control {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ca9e6b9633f79ff28448a6008749fa6ca2696332..baead29b3e67bb3ae2291b00d7632aaf87ebcc4c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -797,7 +797,7 @@ static inline void account_freepages(struct zone *zone, int nr_pages,
 
 	if (is_migrate_cma(migratetype))
 		__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, nr_pages);
-	else if (is_migrate_highatomic(migratetype))
+	else if (migratetype == MIGRATE_HIGHATOMIC)
 		WRITE_ONCE(zone->nr_free_highatomic,
 			   zone->nr_free_highatomic + nr_pages);
 }

---
base-commit: 5654520c361a6638f9d9e889257dfce38c83f653
change-id: 20250821-is-migrate-highatomic-871c0ff05a84

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


