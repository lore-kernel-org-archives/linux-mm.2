Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04528CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 064736B009F; Tue, 13 Oct 2026 23:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015976B00A0; Tue, 13 Oct 2026 23:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E476A6B00A1; Tue, 13 Oct 2026 23:59:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C560B6B009F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:59:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6699AC0409
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:59:21 +0000 (UTC)
X-FDA: 85319876922.07.A5575BA
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id E9EA440006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:59:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NqEjKQQ6;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791950359;
	b=mE9bDQf5oExbmr512NwwjXIzPnTEkbMezJVEEK+58t2nUw23lA+fzLFgKBgu4vrBUkbpMx
	dNLJmGb7TCgDYqlohiZ+jHvlj4snqi+F0pcGd2H6hCnn0peFDVvXsy1hdKfoJnYOg742M1
	Xdp/JV0lSjtCboQ6m2faEO/7O5i6I1I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NqEjKQQ6;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791950359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5STA7RRpF0bZE7yNESPvMRAN/jMwPnFqOs2b9BGo7gc=;
	b=E1GIpqQeDv+J/xuXItPGTJ3w5mexiRikTZqaKaEkDpiHCsnUuTXnLIJMX+0KGsIKFoDkmX
	l1TEB3FV09If5RL4gmlY3KYjxKmmOM8xr40rae0UZT2afPXYDkVtLA3WZ7kNpDNrtWXHkb
	LSPU1V/YAFpM2jzmJ92UVOZIe3RnnTs=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ab450c0873so3030390a91.3
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791950358; x=1792555158; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5STA7RRpF0bZE7yNESPvMRAN/jMwPnFqOs2b9BGo7gc=;
        b=NqEjKQQ6iWt4JpIVBh7lWsYT01HEMnoPGdFeTiqqrX3HY+vru1kMlHelu/LklES6o5
         CLZW6bdvSnLqCgjPjC3IC7/eFudV8FKYA6QH9JLUGjB8i42UjcQ7PTESes2WiT1RLxCh
         kaNfsQJXjXG9pIqs0R2x4RzP75nP3trt+FwOWWrNZb/H8n9JzXGTwcdI3AHQkK+nTKfu
         y64UtMRXyy8/lMYAce/vPai6KINkdn5xOi+USyodAB6hjQqBb+zJIBS9xgGJvTVxgM4y
         Xz5XOnEUIBfk60+mfCHZDlOldhXr2vhXLWyb98QwoO3iLr8Zsk/vQZteF5ZijRFrYp0Z
         vtrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791950358; x=1792555158;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5STA7RRpF0bZE7yNESPvMRAN/jMwPnFqOs2b9BGo7gc=;
        b=O/SRMR8MC2Pa30s5kj+2dUd44Lwa97P1lXK0rDTBtzoAnSr8yFXUNi1EhYo/Qdx6X+
         7OxGJxtRSVQfZo1L0rvem2Y+6h/UyHNg4byhvMPkqfunJwcbLCJtubYLhaZz12W8L6G4
         RWtfbGJKq27MaLOBHoKbjCn4nfWLdqd/AH+16A+0k2+PfnQIL9/07uk5JXB6/OKrfyzn
         bPc5OyoOZmRmZmJesJryJKQuowWMaRuESj5XVup1qjbDyTzDlj1ibBJz4Bj48LeRDAI4
         zE4ZU9EeKLC8wP9f3yllCvcvMaZLXU8NODOigwfy4sGJym/pNwDNH2L7+rhN+gLA+eK7
         skog==
X-Forwarded-Encrypted: i=1; AKwUvBy00ULd0Gbibgt8yVri8SehNlc9w22Lz5plp6O/s1R0MHb4ykIFP9k3BOQu/Tt/fZ4oH8jQfL4Chg==@kvack.org
X-Gm-Message-State: AFq9FYJzuWinI22yARveCV4zlMD3H1O/VoZIeF+NtBe8iGbkH2gc35jz
	GoAoQGoegQcvokRJp3x7uCHkdDKqNxQJrOz1LJ8azkAl25lcW7UmjwOuVfU373cQGUA=
X-Gm-Gg: AYBFou1mMXdcFKvunMzb4WYfh2y+5cqUx44F/FXG2Hybe0DQKrzFeA0duVgFttWjhED
	lX0ZrxQcM/e8pKMBh+hMC6kdLxxKK3yePwBqB1VwOwQcXWjeOyUWESSlwlgSvGM/xPlgDTs8gsn
	6Da1da8sHBWARWG/0tlAUTeOJlGCIdipF1aGxZxiEa74PaFOenAxIf1Zt/Cat4tLFsIZetGAi1b
	r22R7MqLpNoMogm/R8NQ9hHOrEMYmnb/Tbmctix3bfohciGcL0iKpzoiZRGmIFmuXYE4pGhKoVy
	VcG+VFK3lXLWA0BabxCErD2CTxKJOglAa1AmFZeDrBeJSxkz5kzFP9S9qu0fXNJCudhn0xMz5N7
	fhaUznwh1nwUAnuGPhpYKfd1yzUXuFoSnBGfivpCuBsdTCSHQRc+bZp64AFjV1bys9s5TmSjMnl
	tVjFmjfoA96LulsavdUipxwYu8LlNE8dJETc562yCH6D6x2NtIaPH7gZx5r+dPP3ivX9EF74NvJ
	brp6nq057K1tqdKOgLF
X-Received: by 2002:a17:90b:4c8a:b0:39e:6a80:b799 with SMTP id 98e67ed59e1d1-3ac63bfe81amr1395913a91.41.1791950357376;
        Tue, 13 Oct 2026 20:59:17 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac5f24a538sm2492305a91.9.2026.10.13.20.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 20:59:16 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] mm: Generalize page table allocation helpers
Date: Wed, 14 Oct 2026 11:59:07 +0800
Message-ID: <20261014035910.687847-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q1nobof539tintkwjxski5pjrukgafjq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E9EA440006
X-HE-Tag: 1791950358-262618
X-HE-Meta: U2FsdGVkX19H9R3VRWLcV5ALmcVo2Chv3L5LaRPD1tOKVMbwA5gmXrOMsUxnVovAc9KNvMSzJT9PnLGlP+9VRD5lXCkm4Ly2Lt1k2hKI9rbjMzI51iGwUn06ana+c7S0tEpQ3iudPodNtjltNmIh7N6o1G+ijZ7b2/x5KoONiFebzG6DxRA5tbaN+nV3wsDnubxFIPEzLf6IaNmznZ4j4KBNXojQ0scCNrtG1UsX/7t8Ue+Vk2eni7mBbkKua3LOCnle+8EO2xuCPfhT3QUMhYfryZ44uGPs722VU37juXpuGWFZ0VKFkUECRfG/ikitlm+0fK9T8kNYAtnEFY69R+5qJ/CUO5M0QCKn0kexwoMRf2K4ydQ5FP7cu4w07PJl43JeS8bH06eXAC78+YGaU3AUlMZ3rWBa8o0yUjMhj2WOe2mb6NP/qZ8PASmbEouNhXsq26nP+/I+jwY2DXCGlGuHQdOwgc3sgBf89iV1ZWu3GQlF7pJ6FXEd4LlmsOR3fWkcEkQuwB++KPp9dOV7dxajyFPEp4/cR69xUc1kWtTOs/y3LybvEmm37bQEi4b7VC92ho1R8mlPd8sswhyylYJJey4Cmtpk4kncFSOiQqN1fdwgzRXMoa13dceo5FPhU/ypBr90kIE/NUJik0Y4GKIrmRGT8eNXsODPL5PMZ4v4pV9cqnAEPHGLK7jaWXkI6rsP7KDG4edQV2LTPZV/CRV5nOpV+lOYFXnh4aXpPz8sQgD1wUh8zgyFnmuTJLsdzXFQsfvKguJQc7ARe+lb2ZHZvsHDxhgxGy/bH9GstIm92gwWHEfI5pziYY3VkrzOYXGykcxy2g1RV9o+Ez3g4FrbOAMw2CZa70mWeUctFpCqmYztzkeQzIAzUivpGjlm/Z6qA2PUUQ/giyuVrMyi11hIa1HFUJvZsmhuhpVe09F0J8m0DFavh+ggZqnT14nu3B4xJjYxS/qnO5ozkl8
 DQ04CwzE
 BNtCVURVOin2gsIGZiYrN2ZxI9M0CDShxCxRI9rKUyIRVXKDq/NMTmj7JioeJGQ7hIniAp7ElvJIS5Pe78ZeI8Ve3fiyKrfSe4LEGX5KeWj7/MC59ZYYY+EcPl/AjZkjFv3GxCcAICMhglFtQE6g/ZWIbYLKuu4+51E2rm5c1GmWR18gWrFiLEh4DwWnJzNQaqCj+g3yQiJKS076f+YLokejs6eQ0xxpP3StN3pm3+fZsGGV9b4FKxdR9Ii1ygAJFMOCv77lSg2oZ1cWkW4gP3hTwaMK+5qfIYEM8CMrUx5vEBASfRyutEhSf+YHNyBtAo1gAkZXAR+xo582c1lrlEsPIIeevKqtaK3gbwbzeDXKDc1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A subsequent series will switch runtime vmemmap population to the
generic page-table allocators. Since vmemmap tables belong to init_mm,
the allocators must select GFP_PGTABLE_KERNEL and mark the ptdesc as a
kernel page table.

Some architecture-specific allocators do not preserve both semantics.
LoongArch and MIPS choose PMD/PUD GFP flags without checking the mm,
which can charge kernel PMD tables to a memcg and leave user PUD tables
unaccounted. The private PMD/PUD allocators also omit kernel ptdesc
marking.

Rather than duplicate this handling in each architecture, extend the
generic PTE, PMD and PUD allocators to support architecture
initialization hooks and non-zero table orders. LoongArch, MIPS and
parisc can then drop their private allocators and inherit the generic
GFP selection and ptdesc handling.

This series only prepares the allocation interfaces; the runtime
vmemmap conversion will be submitted separately.

Muchun Song (3):
  mm: generalize kernel PTE table allocation
  mm: generalize PMD page table allocation
  mm: generalize PUD page table allocation

 arch/loongarch/include/asm/pgalloc.h | 48 ----------------------------
 arch/mips/include/asm/pgalloc.h      | 40 -----------------------
 arch/parisc/include/asm/pgalloc.h    | 17 ----------
 include/asm-generic/pgalloc.h        | 29 ++++++++++++++---
 4 files changed, 24 insertions(+), 110 deletions(-)


base-commit: ad9f2d463666c64e94b04be5263c9bf8f9f96fb7
-- 
2.54.0


