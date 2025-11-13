Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57470CD4F35
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1978C8E001B; Wed, 12 Nov 2025 20:47:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FFC68E0014; Wed, 12 Nov 2025 20:47:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3BB8E001B; Wed, 12 Nov 2025 20:47:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF1228E0014
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:06 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E49613BA81
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:06 +0000 (UTC)
X-FDA: 84103895652.11.FA9A424
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id A01D980004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=O6DuErU4;
	spf=pass (imf30.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+yqNsk4liq+0TyYbfqqqgCxYeLqjkF7jXxObMUTUHM=;
	b=XAhFwutuzsNteMoGGk4KdYNFNtkOODRqtT1vUc+L8+Hy1c+2scWaMPPqQIFr3VKjdDct2k
	xdIAeP3VzHu3yhdjrZsWSRqBP3NsW1YrdymU4+o6y2mMvHts4AdbkShpDGoeLriFh3cm0s
	/44MCBVli/6M7gnmYWV/lte7QkAttwU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=O6DuErU4;
	spf=pass (imf30.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998424; a=rsa-sha256;
	cv=none;
	b=pYU8J7J34xocD93STYO0EY6+jmrPtvSh4848hWBSCDykXTx9GmZLiPJEiklKl8MBukp6zt
	NyKFYIs7EgXYazaRhJwsIxIfG2FilSm2y0wq3WtDkvGM0YLosYAv/Z1YWk1Kthqw0XZc0E
	YxQnMM0NkbzqXXbwhTfY7P9g8vcyofc=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-297f35be2ffso3843025ad.2
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998423; x=1763603223; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V+yqNsk4liq+0TyYbfqqqgCxYeLqjkF7jXxObMUTUHM=;
        b=O6DuErU40Gws6wt6Xa2Co6VzhXmNkHAG6ne4fd3/vNXWZmmIuJfgWGgylCvx+0uqh+
         10LpDSpwYZtvf0MsYLvJAkHrcYLhqTauNxTDtsUwTn5QE5w/dYjPuUo2VuC1icSoVKnI
         no/CEDI5QggzwFbb/mAZ8zVcguaZvNPptVR69cSgbiKVMd2SFDANGiLJR58uxf1de/u0
         bpsG9klB7mrIpkMCmhSri/tf4ghBw3zazxBP7+35EWItv+RHQnviftI8jqzUq8s2fJll
         U8mXP2P5ESbc6bjPxuCdj4PrM6r6q7wXILOdBf13Hqto75fb7LE2eH/plQPFO9UDI0C3
         h5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998423; x=1763603223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V+yqNsk4liq+0TyYbfqqqgCxYeLqjkF7jXxObMUTUHM=;
        b=vojVe5x6I8qHk9eh7Ie6nbk/G17cU3ilifcBN9QSzZGUD4nMBKL5sSKZI0Rt0db+Fb
         FoSkUbhEgSHTG8u30yGzguoYAx8jNacvJRpQnKdeIUSB+32+emeYdWVNRnzZ2gLMnPZk
         qwdnDA1Vb0CTbnjzSt4dxK6HUFpS3Oz4a3roosVMdE5nNTw88FvH2yngGM5De1Q4XVli
         dPLkQm0/qkpfLmYYNPem9M97SjYIlZcgTa6KkPXa8VaaGFEICC6V52gGs2zqb8W3nxDb
         x5P/ZaUM5NWqbESfNhEvPT9Q5hT/hjb8cgMr+vkJBrxZ57X1/3k1vxxik0WYX34tJcHS
         +lgw==
X-Forwarded-Encrypted: i=1; AJvYcCU5W52k1FedtlqCEEI6hD5J6GYAfCRD7Hv8Qktt5sEvkQXqBjjLmbghEKEuzQ+6/fvb2p6ak9USwg==@kvack.org
X-Gm-Message-State: AOJu0YyA7MIiuYZWSbDstvi3csveDns5SwRQRVhtRcvVH037eHQ7ZJel
	lvIMCuOU+yKI5IqxBWXfTVhcMvPiLwpuxauW+lL/cCXD/6YL+z6Cn60ygpg9TLOjF3s=
X-Gm-Gg: ASbGncv8xG2oZ7/vMSEfyj16v9q5DgZfIrdn4itK1i94oRTGTRqsMv+R6QlDVYg6geB
	F2nkOsiQo4eWP1bC3oyZ9nouSqK3bNNJVZ7o5DLXWwT1gXTz64BJbxwhMmw/1xABfhAmiTiewDO
	zXGfIZR7/uriax1bsiCnxEqkEhi4NC0NaJlCfXbaFchRN6EF+/Q8+mKqiscNfELS4FeYh1SQp+9
	vLhVb0ZDBefNDsaWHYls0YdmZwVEu151rDOQvYZtazUQOmD16gSLu+8uCQoztA4feTtkfO8a6P7
	l2m4rXGaKdqzE0n4uZd4wJaDBqe4R/z9vTS1Zr/6ZxA5Skbu+w93RalDMjklgajpR/IH6TfO5Lh
	PEQLqToLv83OLiDKWGQ52mvZglwygtAHxVrI3t69uzDh6YskbXJ+egfnD4ZDDseKBl/3nNWPOIk
	YkKIGZEFTORK5yREKvNAghsvZsznq2vomY
X-Google-Smtp-Source: AGHT+IE5/byJkN6PUIJz0PFtm0m4DzcmYy5ZdKT+rzV4QNwdcHdn7EgBhDmqTxsB7L2xrr78NQwjSQ==
X-Received: by 2002:a17:902:d4d2:b0:295:1351:f629 with SMTP id d9443c01a7336-2984ed328abmr54095875ad.9.1762998423477;
        Wed, 12 Nov 2025 17:47:03 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:03 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: devicetree@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 03/22] mm/dirty: replace READ_ONCE() with pudp_get()
Date: Wed, 12 Nov 2025 17:45:16 -0800
Message-ID: <20251113014656.2605447-4-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A01D980004
X-Stat-Signature: dcfrr1qhnw5e84sikq9gffuaerktucja
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762998424-444059
X-HE-Meta: U2FsdGVkX19WRsNAjjQv2bxnBB5E39caeWGH8CDNOLvV4VnMqHr/jBGkkpZH/s93NlBRLDScIbpLsSQHr/DQVgqOKPgjCgXuB47dbN7U1DKXf9UCYIlu8htNaTIxQr0oAJ2WWhvn3cFhJCKcWtss4Ejya21yjAE7i69I8tTAEzMaITCGhf3tejnTvAVaUj4GIjWiOZX5qsIpRt7dHU+XsoPx8zEWPOinv/xqhPZIxPbHS8HOoshBFp168kbQ07IvBVwxCv7SPW/R6epG3H9T7+TSsDJZAfILQfV3WA/pAGdmokpBtWiYZKP/vkatHjvLoT/ppyckRzshz55vev2fZu0RJCH5VJabO9n7z3mx1/L1U+L/WGjFeGz7Lh6uRS+mUdEUmZfQsHpqKNkm+kgtqbzK3Qm2rtCqUa2vwoMYN1zi0xsrInESu0jt1y4AcdTjzbsWhi2seybg0/btT/anxXWTtMB2z3Q6peasDxjIJj4myT9SJrDHnKDwSaGR3dz7AnT9keyruJZ13p+Ia7DDB+VplHul29vfUg1d7SQV4oa8GVMuxwBoEgCEoVsFAgEdYbhw50r4ffaNyntFulWnaDYQ+aNM5JWERIqFnwAwC6nVARObd9cKdjE1HEjXB3ChpNVVugevxYS0NGyTor67VM8hDHIz+rNiuEmkEP388U9Wn9AI1kpM+oiI9g0QBMnayIljhFxl75mt07ZBtv+nVhVnfY9QKahk1iqgShcp/75tEpRRSs/YZ160Wy9BNvIT+Kg/T/dAt5GS1eVGkVesLq0Kl6GCTf32iBJGEI0AhuLkFxQZTqXMiBkUlFJdDGQ0RNsT0jbgZiL1aRqSHCwCZLb8iNdDqbza5nhM9ROEA88jMlsbSPfPBvlMxAnMeAK9Q8jxr2WQSebuPtg6cGs1HLgwxCFzq8Ld2qqECcU2zmZdd+bGczyfIGo30BvCZtzwcpgMSU0h7MOUiIuT6AX
 BqX0KusK
 xpqc/ghsks0ABrGhBORX5s2iQvYNFwgny+5TJvkh56iZemKgYybh8z2rAt+31jzeHIO+nSLupOWjt7U++Lw9sOFR8ArKszK8FpWcdEcVRKcVuwS41P2yuI+/LQAaUV7B944lYX0+MIs6gSXlVWqkB7KOifYuCFXKk2EaPE/pWOJ4aeAP2ABrNOESEIiyjhApLIITJfem3TzOSQRCshMQXO1KPyFG+3Z0OuskZ2LdiHEyBxho8oeJdSKw0yiEZN8STBcGZRpkso29iaD0h0LLSsqtumGyleAv/JHfCmtYu4udVuKT5+vPeseRyzHjJl/6GTnHpcjAeMb1CEhwJfZBOLkJBy/sWqbcEOgmJJ2ICg26M53gTdNEqhmMRBy/NjB5DA4tNeRmJhadek+MpSp7D9BzZUsMBerTK03cECnv0HaxUm1kB3m6+vA8cdGaIXNffWzBodSfNTFXvXPVlAdnQjsrWeSCIb+IoLn81JxZvDSlxbyie0C63csSAepHjzz6aPCtP9vnzquDig+Tag5t+Ruk4rGNbqutuxEzho0+J5OX8eCkGDfPGLpONWVIL2DQEl1Lcey9RfZj/UDvvg94+30ARMJOpVoYVtBDvL8JIRaOnEt9RA/kRs6Mtt5v4a3zeA7sFZhSjuS+IUSc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Anshuman Khandual <anshuman.khandual@arm.com>

Replace READ_ONCE() with a standard page table accessor i.e pudp_get() that
anyways defaults into READ_ONCE() in cases where platform does not override

Link: https://lkml.kernel.org/r/20251006055214.1845342-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v3:
 - New patch for v3 (cherry-picked from linux-next)

 mm/mapping_dirty_helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mapping_dirty_helpers.c b/mm/mapping_dirty_helpers.c
index c193de6cb23a..737c407f4081 100644
--- a/mm/mapping_dirty_helpers.c
+++ b/mm/mapping_dirty_helpers.c
@@ -149,7 +149,7 @@ static int wp_clean_pud_entry(pud_t *pud, unsigned long addr, unsigned long end,
 			      struct mm_walk *walk)
 {
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-	pud_t pudval = READ_ONCE(*pud);
+	pud_t pudval = pudp_get(pud);
 
 	/* Do not split a huge pud */
 	if (pud_trans_huge(pudval)) {
-- 
2.47.2


