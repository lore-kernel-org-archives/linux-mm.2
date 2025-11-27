Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDFF9CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 20:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214DA6B0027; Thu, 27 Nov 2025 15:37:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C5936B0062; Thu, 27 Nov 2025 15:37:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 102896B0088; Thu, 27 Nov 2025 15:37:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 035136B0027
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 15:37:42 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92C9B1402B5
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 20:37:41 +0000 (UTC)
X-FDA: 84157547922.21.2CCBC67
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id CB3621C0007
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 20:37:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nAukmps+;
	spf=pass (imf20.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.161.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764275859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1a/BMT+uDicgbgvpTyKzKILNUrU1wfRLK7WqswvzcdM=;
	b=wWFo0bTgMPzj0Qb9C7yy/ECic/dkeG6kSIUh7svb8LIpCUM0Yj6xuBspwwZYbLIBv1gYPW
	N2VLJtcCq4fxq9ALhpCZD9udA7E7XgjQoqiXC53BjMKYra/EwSmXPrLyv7UCEl2gSk7llU
	Uy/9vs9z+yPyNQrkxD/CRYS1Q2T5li8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764275859; a=rsa-sha256;
	cv=none;
	b=42sSS4T+BSzVJsSB9l/ybxoMwCaDsNb/isjYi28H+rf9BFTbiS7gRgr3l4itHE8qFhchcH
	5GYSxqDyrz/HrKbfeLHPg7ZaNG9c7nJgH8Zb2Ju0TeM9t7fxDdQW+r8grwTCIPZo6UC+WR
	BvjwK7MeT1D/fjZH7fQZnOZQIVhMtQI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nAukmps+;
	spf=pass (imf20.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.161.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-6592f1f55a8so225330eaf.2
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764275859; x=1764880659; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1a/BMT+uDicgbgvpTyKzKILNUrU1wfRLK7WqswvzcdM=;
        b=nAukmps+W9ldFkZKfLhzD35s35yPR7lS3XhakxEoEICCSPJvCsI71Qr3+gBng6YArE
         8O/CWsGfTIF8b5KdoGx4BSoIv2SD3ztNkiVUJ++7wYMSYp3y3rWANtboBNXlgf1Z/asR
         wkwdYK3lKuTtSbgW+Cl4AzriJhanY7ScuJnP3Ewm4Bzgl5PZVdSq7yqBU5EGx6oC2lUd
         7NJTDzS+HwL4r5ZblfDtRWOcOi5wPvFqadF+8434PIjKAg6Y+eLsHTJj2Asg1dUTDATJ
         GQLUdsaO3+FTW2yEsfeWLzIh/gbS58IIHsDN3X7EUlPvr0yXWlnYD1mekFdnKUd93juK
         Y83Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764275859; x=1764880659;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1a/BMT+uDicgbgvpTyKzKILNUrU1wfRLK7WqswvzcdM=;
        b=qZOoWk07ECgr0GU3NIDOAWUPsAAAmjaaN334NdSXTV0YMWCmsp4+p7Fc8jjJa0PP6W
         dXKCpj09OwtWo3lXDAPXmNM6Zl1YaBa1uD6b111QhYBAcztle13zeNs1gBCzODqIFo0O
         vrW8xVsRs6thtNbmxEscVu9qvgCmWlBMsUNAa49jfhN2+qVrYOSxPIcx+sMRYVIeUYeM
         Wyjo6bd4oHucPvvu9YgzT0uJHGL5ksnSeL48UJVTJ8Z2jO+IMUNWY4t0SuRvRVijT22j
         YBJqGdjgTh4y+WAFJRdVP2d0i6xm7yRuW8p6VUFIXA4ZWHP7iHDB5Zlj25TQ7lDDhtBY
         Kugg==
X-Forwarded-Encrypted: i=1; AJvYcCXZhG5GcBoJuJN8EHZCOzXz2sqrFxvfy65jNrhh6+XsUoJ+HFtGEhQVj/QC4rifJvIvrKl/s2cj9A==@kvack.org
X-Gm-Message-State: AOJu0Yz/RbNTec0rGBpNOUaGG4fVSPNDYUWP9AEopA2EgZWeEAZwIoSZ
	V5VS0n4miA98pCRPZFfP1VjZ7Grnqb7HoogpYbjbCJfJEko6G1iAzs0e
X-Gm-Gg: ASbGncvSl6PHHyVc99fzTi4J0qjxZGlPj698yibMC3AJ9l5fEcA2tZfgyvoCqRxmsUg
	OPw6ZR++qK1Reo6LaF2TGH7qd5d/gR//8HLEn2FioScVdlG3WUWLawBPBPN2/DZyweZQwwuO5Aa
	d23P+zCvYL9OLr4+tdvP1lpHs4DwT4ZLquhPI3pwvVSAC1LCc0AqNHC8qZbEWBLk3fyHdb6Q37E
	uS0LYRdNAOUIa0x3bEPcPlQdgqQCJXMhrJ5ND3E+pBOvuTbtxI0dQve6QcwXPO8nyxe+7zWC6KA
	Djbw45P+fTB1GcRl3uxO9vQpLJ4xMeKsC16zliis52l3EVxzHK5QcyQZEOWO8fbfQLW6Rv0+Amv
	ahuqPVkYIuKD9IfxhFzTxyb4TKBQ1L1AqQJtcLskVmLgVNcDyhHXk0GXsmPdRe73R5GeXcowXm/
	5+XihNPOMe2SZBbNuUB3KN
X-Google-Smtp-Source: AGHT+IHjdOurYebJtEdrfpegOfcNT/l2/IV9xPegjpplxDV/HVoEfD0Dw7ORk9l1fi2QZ9k0E0B6sw==
X-Received: by 2002:a05:6820:4cc7:b0:657:5723:76c8 with SMTP id 006d021491bc7-657925458ecmr9232978eaf.6.1764275858739;
        Thu, 27 Nov 2025 12:37:38 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:5c::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65933cf5846sm533873eaf.15.2025.11.27.12.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 12:37:38 -0800 (PST)
From: Usama Arif <usamaarif642@gmail.com>
To: rppt@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kas@kernel.org,
	changyuanl@google.com,
	graf@amazon.com,
	leitao@debian.org,
	thevlad@meta.com,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v2 0/2] mm: only mark/clear KHO scratch memory when needed
Date: Thu, 27 Nov 2025 20:33:18 +0000
Message-ID: <20251127203724.3177621-1-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CB3621C0007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: p8zrrabeoo17z3kykh6oqopgiz4e39mz
X-HE-Tag: 1764275859-597486
X-HE-Meta: U2FsdGVkX19kFytTecFpzmemyU4WzL815LbsYpGYdcRgEOdE5qQD5GO/psTWJGeLU7AYmESwL5TDWMT4n0Vn0h9pWB/WDznsoUTnoD9xU+utXZ/i5VR3FkPoLQO5kIpQXcBfcUxcn5yuVgX+vatkb35nZVpBIxGet4M5nsmbo+6EEpl+zZy72EUaqmEZjgj0/D/MzmJEjaP0ZlL9ZTu/GALXNPHAKebOCQNwOkUvD0gRI9P8UtYMc7repG9qwsZ0n8ngAK5kiiyBRm0JZN2tqaSWgh+qi+J+PkfiPA37EtTZhL2J0s1jwg5LscmrvrmgF8AjvbEqEIsS4e6Ki2ylN9JtaX1qZDtQGs+HGhZ1CYygBhwPm9pEsc7qwo0K8+QsxjaOPyu2ZFJ7Oaw07Oa9gdQ1v/aiC1vvsNADKGMF0PozW2AcVSXJJmj0SqdzJv0zJt426grjUAeEkKNWGkkLRiAX3n+XOV4FZp5rdRwX8GPbfzHlRT6UEBjbLxq37No7x4QjadBCdlrnjQgWo7mkoLK4JLiqYjYwGE5dP8MruF0/ElspeuMQxrywPfHE+PDFyscH0aghzvxZu4VvaM7KxB5uUGs34NqagdlDFLVMBlU95HrnOLrNCNl7pdtaKScRRW3jej8dBhuDorckPgflQf+q847zmzLkAY54P32uqTZNQwmyVpR+N0IpyQXPhYa5aTOSv1LQkO2ZuTSTKaDXGTv7xLpzJCLm1su3Lg3ItqdmtMRiV2b6P3D7FcjjB30YEWDH3LS3q+igGSNwIY3AAyMFm3E5a/jdRtXNCSS3+539ORuBA9Q2fVW4+wgcHDR+WoXsyWXPBbkPcG8pw7osnKumcO5VIWdj1dbe2m0iSZQKqrpnZJY49I/mVmnTSikZOiPejPVzPetD0HRhnZIv9au1umfaMs0mXtls/DiSHhQ33fMWNfIFzSjGR5phMo1FeH37VvjqArASIr89/p/
 R4Q6K3gv
 RXC6XdOh5N9T3LfJ3XOU9CudGFwqmknL5NzgAhQulrpjqhFWke5W83yhGJOuzOmPVfcCdyW96KEiLoH48hs6IiRIbtnXB//3gwiJkfjk8AigG7RdTgz56ZGkBB/0swaGaW4cKukTG0pAQO9Clll0+DErrLUJGqgfYGl9WGNRSQ2+ETUwC0hB9hKsNZbCPpm+5ax5fDxeBkiq9+7bVbGp6kUg1PiObGejnc2JEzKoM4WTmP13Dm1ZkXhB1k8EWGCsX0Kz/f2I5JVLU0mcawa7Hz+elSM/igwc4d1ix95UansHIz6EZNlhrA1xC03kambWQtx80r6qmAtXwDTWJwR/FoR8Y4KV16+Ia7S9hy0yjmrLwijerO/ZbGloEHkAf/AVj5MpQ8gp2yY8VmJ90+CpsQl+yjbN5sG1QMb1olx0Yu5PLDymx1mhowiWKOWup7+N4ySoonF4TSkt20SaikvySR3Lsn0IxiQzGNxkfxDRUtHBa49RaccpmkDIppUbkiHznojyO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The scratch memory for kexec handover is used to bootstrap the
kexec'ed kernel. It is only needed when CONFIG_KEXEC_HANDOVER
is enabled and only if it is a KHO boot. Add checks to prevent
marking a KHO scratch region unless needed.

CONFIG_MEMBLOCK_KHO_SCRATCH is also removed as its only selected
by KEXEC_HANDOVER.

v1 -> v2:
- Remove CONFIG_MEMBLOCK_KHO_SCRATCH (Kiryl Shutsemau)
- Move memblock_mark/clear_kho_scratch under alread existing
  CONFIG_KEXEC_HANDOVER in memblock.c.

Usama Arif (2):
  mm/memblock: remove CONFIG_MEMBLOCK_KHO_SCRATCH option
  mm/memblock: only mark/clear KHO scratch memory when needed

 include/linux/memblock.h |  2 +-
 kernel/Kconfig.kexec     |  1 -
 mm/Kconfig               |  4 ---
 mm/memblock.c            | 78 +++++++++++++++++++++++-----------------
 4 files changed, 47 insertions(+), 38 deletions(-)

-- 
2.47.3


