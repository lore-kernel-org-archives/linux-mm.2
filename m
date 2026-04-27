Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE414FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65E2F6B0093; Mon, 27 Apr 2026 11:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635846B0095; Mon, 27 Apr 2026 11:53:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5729C6B0098; Mon, 27 Apr 2026 11:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 470E86B0093
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:53:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1252E1A0B8E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:41 +0000 (UTC)
X-FDA: 84704735682.25.5CEE0D8
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id EC6ED40003
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=STR9NMxH;
	spf=pass (imf11.hostedemail.com: domain of 3SYLvaQgKCGIARDB+GITGOOGLE.COMLINUX-MMKVACK.ORG@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3SYLvaQgKCGIARDB+GITGOOGLE.COMLINUX-MMKVACK.ORG@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wc51wPzk67h/KJWuIdvgej4c5wVXm+tSlcwLrREqPXw=;
	b=Jfe7WCDCMv7vCJlQQCgIc9fao8826Tgax47qFtb4pyHsq0YisVh0TlkQ7UpOLm5xG622wB
	U2S2I99pA1s8f//fkKXdDUrFlRR4Jh7mJ/sUwnuaS25bScZEEtsvOYOJ+QMeEDuMzPdrla
	kT9aIvKCeS7tL+f6KrYFR/FsgU2IscA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=STR9NMxH;
	spf=pass (imf11.hostedemail.com: domain of 3SYLvaQgKCGIARDB+GITGOOGLE.COMLINUX-MMKVACK.ORG@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3SYLvaQgKCGIARDB+GITGOOGLE.COMLINUX-MMKVACK.ORG@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304139; a=rsa-sha256;
	cv=none;
	b=dvcWxQQV9Vm5YHZa+hoezbmFSsrdAJJ6nTzoSsCGKb962H/SP7HhS4GPrkztz0C9Lp1r/p
	tLOOA3diTQBOy4fT0Dn1hSMuNewIE5OHfbVBbYAJoMTa+GC0ai+MHBcO6jsPC0cpcQmjCE
	2qy4v4sd0M+UWyyBHfK2j5/0pwvDL7k=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837b6f6b93so111412235e9.3
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777304137; x=1777908937; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wc51wPzk67h/KJWuIdvgej4c5wVXm+tSlcwLrREqPXw=;
        b=STR9NMxH57sdHQOqNS7jMkYByv6yee1i32NftmLGFZOvX+aEKOak9lUaykqRGwOO+I
         JIVtpc4OtkWOwH0t7Y+E6AzM5H0ZP0BDBoGUsNE4jVu5C45J1jccwLcapCE57a/jEY26
         CWBPx5p+kSZyVVSqM4RFqjQSXi8Jp42RGohopLDKhemhjPG9nm81PBFzjCMGGxKkAUxJ
         COAAtEgNJJK3VAhvwj8FH8ESv5JHy/9lY0UmjU6Dl/XIS/FL9xMq7/p+7NhVc/a+QfyD
         qaUepdMNKMuadg3Qo1Vu+e9Bu6QULQArH+14xvqDm6M+geX/Q3u8dfiC/T5F/T3nMqSE
         K1+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777304137; x=1777908937;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wc51wPzk67h/KJWuIdvgej4c5wVXm+tSlcwLrREqPXw=;
        b=iohsUthwYlOI17C3kjCmEgAlHZOBC6cmGR4s8lQTG0kWjqZOKQLhUKUfq3FhWsIN8R
         EmhAX63mRRx3hf5YOLQUcEIeAqq4OPJJuBZeeuvtxcbXO6EFc7a+ndwJ1IooI9KUjwr8
         fwM+VxxUfNnosvQW1Mi6lh9XvfzPesqaac8MBvvhHlEHsbVELfYER4b5pBfKbE/MQZFB
         /6juwmSSwq9IK84NiYvAtmxGP0edhfuJhfGeN012gn6E/IBglLmaO7NkcE0SfCbJeZZA
         0wrSCxPf32NRNPDb1CNLQIOeTSLMNKkHqRT9OW7Uii3eZXDYKokSuqf9C2YhR5yFSLdm
         QV2g==
X-Forwarded-Encrypted: i=1; AFNElJ8mQPudaZl/1W1aX5XvoBKxH807Y0Z/QO9d/jkR2HZupON78Y7pB4sMgE8d+cev+7NUVDKM83juwQ==@kvack.org
X-Gm-Message-State: AOJu0Yx6iYjp+dmZUrftoUxzqy9K1buT58PXP30zCdH0HPoi2pP/AQwn
	kJJizBllfmHwPAhb2HYKqki8VuR971BooKbbCc26fqXdfSmGVBg7UoFFyW2uDFeT0G81vP1Ffw=
	=
X-Received: from wrrf15.prod.google.com ([2002:adf:f98f:0:b0:445:9b34:32eb])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b14:b0:48a:52d9:54ab
 with SMTP id 5b1f17b1804b1-48a52d95604mr460176645e9.30.1777304137397; Mon, 27
 Apr 2026 08:35:37 -0700 (PDT)
Date: Mon, 27 Apr 2026 17:34:20 +0200
In-Reply-To: <20260427153416.2103979-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260427153416.2103979-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1344; i=ardb@kernel.org;
 h=from:subject; bh=GHwWYq60lqNuozERz0S434bqDfMxYbnUraaeSVA3Tn0=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN947/7X8wOXuLePiOp7MONnvXiUl5NBamL377hk804c
 tjhpENeRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjI+npGhoWiYueTlCv3njc5
 eKI4u3WiW9EuwdunmA+vma0g5vHDOoKRYavEAeGovTdWuwnO7aw0j1t2v8qU20TqZU3o42gvDsX t/AA=
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260427153416.2103979-20-ardb+git@google.com>
Subject: [PATCH v4 03/15] arm64: mm: Preserve existing table mappings when
 mapping DRAM
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: frwqapm3gxdsddcixidiz6qf5q4nighp
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EC6ED40003
X-Rspam-User: 
X-HE-Tag: 1777304138-312735
X-HE-Meta: U2FsdGVkX1+fSLYlPTwpj5W3Nde+61csMVWs1IEouycJOdSfkL7SF72P2he82YxIb2bF49aIoGElyMzh2JsAe+wd2CkNpS5DWnO0IYtpqdilIgGMzfpuZz2tsB/UtacEncv3+sXzszV1KPLATH78sOJ9Uj/nfaLRf+9t3lNWhtLd300JNG94DU27XQwPqmwCNlnbSrCBzX6lytPROIvxYXLOMkWP4qm5OR3kKSXsYBOSvPRJH1slL3Z5YdPpXNJB0Kn9L50fNchDc25b4s9rFpjhLylSjP8QVPf/wVHy7+GoKtkLgUN+IzkLlo4rWTKm/qzDDYNFtUdObdTQDRftKSODREnqoV1WyWywr5OQRlPjE239CnWcoN0OpLFwbTGc1KTV1xtV7OnKjvm1NKy2llhbVaU7sxE7K88MMlKsBa7+1Fnwu+m4VxlUdgvkQwKF1Atdj6NN+xmEVNttQ/s41958iVjKWt939oFtSH574ZucJzM/l/8OnKj6f+H7ZKi/UrNBxv4xyIsaeeX9d1cjWj4n1YOlYsz//bpzn7iVV4so+Bs7MFGszd0brMfmRVAWw0br6uoee7Ti2Q6mQIqhfR+p4d6f5/EANpaKVgtIMndq3Hq4kNlpTzPIJzn62gbQHsVn7aUp/kxOwoA0Ov5HwZKGK5Pfu4Nb9kjVHW4tbEe5ENH3P6P/HOBPTE/WX4+L+8TiUzxk3kPVC2R4bGNFvDq/+UVxJrgDP3CKeQYQh8LPjQ1EBY6DJ3l4gA9JMfxYd2Gl/1cNF1JPOrsH6/cDYIgvUoHrhezWXPNXEwNkQmZOHEV2nIke4QzikNOA1rnh4kwm3JtfQqSWD+xvmOA+aalf82CKKa76PZAsA5O/h4/TPcLT12q6zWNZKZwvQJbYYRSFrXN+UyT3T5+dnorovYwEbsRydrtXg82fKbXs4eys5DI9/F4Qz7M7G3vA0PSotmwnf7Rb36zgBjqnRma
 a1tfWX09
 fLaLkOLF+AHdcGD1o1yaWF6SgQgHRNvCYcKSreXbQ4+G4I0Ie9mLMy5bhcWFua07AU1Ej0b5NEekExRtTbS8BgOzMRh/W7Ja3EB5NcQwsXWrdaiiy0oaxzBJjH9GmvKGq9S+t9XcJDT087xeVIpdPDcSaKUSEpSuj07ZX4IdVddU94BpQrDhjwdeaLoC9CDMJjJ6Ykfoum4dI3evgUmxEYoUXu9Ws66At7hzXXc8WwkixIVo8wETkrCuKvTjkFr5W6UBf+r7zTBTWavDruU3WHY+dGc7eKpCL0hkS9Hhv4AgJ+SjENDolT2zRIiBmKtEDS4LgqBLbpEj8/hce1kMktn58ljahYwZoqUdRFV6op+DZh78QiFjS8ZLK+fmSWUEV46KKopMhdERFRaU1pV+kXrT7G7lhkm08xRezuiAQjMhzGO98FFixWUwONuPOlhXY51Sb9bFgM146tOoHQk3w31vp0n3h32CqmqIRgDStUBiT2Af8/xNJFWJ3v8Mc9ZLM8BcDX2Jn/deT6RN0wDjqSl9dOKt2DZRpAHjoy/ZdWrxVSlGQEBZjeqbgSxeNFTMMjcvRnXh70a1sk0MZk1TsuX+9OkrH5/AlWhObaIHgoiuufJeCj+EmA3YBWwFbERatERv7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Instead of blindly overwriting an existing table entry when mapping DRAM
regions, take care not to replace a pre-existing table entry with a
block entry. This permits the logic of mapping the kernel's linear alias
to be simplified in a subsequent patch.

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index f084993024ab..801a54ade76f 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -256,7 +256,8 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 
 		/* try section mapping first */
 		if (((addr | next | phys) & ~PMD_MASK) == 0 &&
-		    (flags & NO_BLOCK_MAPPINGS) == 0) {
+		    (flags & NO_BLOCK_MAPPINGS) == 0 &&
+		    !pmd_table(old_pmd)) {
 			pmd_set_huge(pmdp, phys, prot);
 
 			/*
@@ -379,7 +380,8 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 		 */
 		if (pud_sect_supported() &&
 		   ((addr | next | phys) & ~PUD_MASK) == 0 &&
-		    (flags & NO_BLOCK_MAPPINGS) == 0) {
+		    (flags & NO_BLOCK_MAPPINGS) == 0 &&
+		    !pud_table(old_pud)) {
 			pud_set_huge(pudp, phys, prot);
 
 			/*
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


