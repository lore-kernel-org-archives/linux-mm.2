Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 774C6CCF2DB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 09:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ECDF6B017D; Mon, 19 Oct 2026 05:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59E0B6B017E; Mon, 19 Oct 2026 05:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C726B017F; Mon, 19 Oct 2026 05:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3A66B017D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:08:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B125280625
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:08:44 +0000 (UTC)
X-FDA: 85338800568.12.D4F6559
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id 53891A000C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:08:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HEiUblOZ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792400923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/pB41CYmMwKsKbqW1foc/PLT2lTdajoPoPYMHSrvZcM=;
	b=V/DBz6n8TV4a4EGXYTLQJnbQgqXjzxY06hlxyKAH+LVqR7TfQgsTUDQh/R7Z8frq7tOtKr
	PrAS6Dgv4tg6Y2JfWXnhKIBzPFnK1dmHe/qR/ccrqitrWdxldiv9fDt0/JvlKXgMtFN4q7
	pI4PYlu05rr7uGHqMs1mPWr0QoXd9Rs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792400923;
	b=iWeqfxHFRtfVirfvUw218NU3YX8SGsZhzV2A63KGjqpbb1ccxtlLkAJTcNpeNlOn0F3sWn
	AwVn8bD55TM/1zbXs1wKDdPnMjDnHkGfUzV4qCVwSTPaMRh4lsRn7grTrDxApTyrakE0HB
	tC1pLozZyGlS4TY6l1JWcwWfICwImDk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HEiUblOZ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2e901e114fdso8018415ad.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792400920; x=1793005720; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/pB41CYmMwKsKbqW1foc/PLT2lTdajoPoPYMHSrvZcM=;
        b=HEiUblOZkkaCcnMXZYXTNuBtcuS/FrJOEpoFB4XtGxkw4mmacyVlOUVD1j4+XfN8JD
         fNAv58TLpj7YB/fRgvghBJ0oJ4h7SnPwGyy2Z7lGUEdCVIXPvimdwfpMiWNf9hkXyuB0
         cBqh2K+Z9jNjGAjmFha2g0H/j8ef+3GfPvy0a40ARqMfr0s2RcM9RbBqlQY3EufdXuhz
         j0u5JhVMx7Ba0SjRzXYQXinIDV2wWfyS7QkynPX5bdLb69AaOsiP1loKohNRGkUUnBIX
         8cpcKAY6z0a6dP3SiMMupI7SI/uHmYvqmrN0MtPa7rLCGT4XU6dgQMY7so2gNJvbSfHB
         PVFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792400920; x=1793005720;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/pB41CYmMwKsKbqW1foc/PLT2lTdajoPoPYMHSrvZcM=;
        b=EwfubGFBSS51lIjhfad50j+yamZpyM92zylWbWTqnnPCeXccd4n1lodGSYJesGhY+N
         g89NeeyGB30tXCOQDjH6anXkmi0dYx1nrl/XmdKNthcpNTVBIGzWMKhlqB7zTirE5V6m
         9qD+uskEvpojCUXVb6rDEinINb9NKZ0F4/D3IdonT2DZ4uothtHXKFgxoHcU3rTOvM+a
         TbXwZQRC0pwY5kuc7aAa7YLfk45cyaGexZijmpA/a4+551TX5OjVassmlfkO9gqcsOPE
         PcI6wIQR9R+eXSOJMGGhJ/gltkR3ekbt2ByzLSPc2WGegcw2+pkswXDa+5JivsW99N8b
         4QHw==
X-Forwarded-Encrypted: i=1; AKwUvBxQcI3vzXBhsE9mfuASOOT1eoJ//qN476SxQX8YX83Ww/RNBLnUf7k0ze5bnyVORqJ2Qo9giGAU+g==@kvack.org
X-Gm-Message-State: AFq9FYJnqG/cE5to0HconTl8US7Zh13diFCY7+5/oaVn/8jO2kIxZKta
	yNqCPILzruDvR01v08I7y36bEq3DCXtZdgZogUpTfLjqP/mwSHSH0erHHvZSaF36M+Y=
X-Gm-Gg: AYBFou2rB35uDCdICzpgJfpGKRpxPB+JuJGDpUAy1z2GpVkd2BgIIvBPlUiTJVRdpyM
	8WH59p4dM1/7GyXFGCaO1W40Ad+cbmD3zLw47zsOrHlviHx/GuzEPMdL0nFXG7cXZtaffhOXpHj
	DGlxuKeCUGwLcjALs5MCNCj8bd9lKoBvpiMj+hMezn46BKJMlLhF9WMy/aoYTMuiVOyydu0UhDN
	fNsqwa7Z13mtblvw2AOZZC4vGdoD0RvfPMhHBIN+4ajlOl6HbThIRAIq6hOLZq4WHE38UV3jsXt
	TCo9mH3254o4TedenSRBywmFY8PBJd/fFoZ0cm46EbWT9H5oAFED1QtU4otSK6ZqUZQEu1wnmJR
	TKXbyekQah+/MKUcUysDry4kQ9ymcoG0yf/cjQleJ+F9XJ6J996A9SjmOzLvWrclHSuiK9UQcpX
	Cib/+roaZlcGivPcQ6KB1L1eb08HBb21cEXraja3z63g5477UXMF5V6yY681HSuvYrdVWFpGVAG
	yNMo/VF+aKdOM3qOUtr
X-Received: by 2002:a17:902:dacf:b0:2e9:9f14:c44 with SMTP id d9443c01a7336-2e9a6d38bbamr62890025ad.49.1792400919921;
        Mon, 19 Oct 2026 02:08:39 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e305f1dsm36707595ad.0.2026.10.19.02.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 02:08:38 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 0/4] mm: Enforce read-only shared vmemmap tail mappings
Date: Mon, 19 Oct 2026 17:08:26 +0800
Message-ID: <20261019090830.1917657-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 53891A000C
X-Stat-Signature: jdoq6y169ujidtqgbwcf7s36jygsxrbk
X-Rspam-User: 
X-HE-Tag: 1792400921-597736
X-HE-Meta: U2FsdGVkX18MyDMJ8Pwp3C1pde9pDfY8sNt98jaEhQZrxioQyVK9ujOIjU/8xC2mnUPXAAN7HM9AaBQQVTvYFSa0CK1QedglF/0knPyfJ7PzNwF7b5C750nA4o6qT9XxDMe9U5j3MKIY5uo7iKKy6aIspckrXC4tc23n7xQSA+cIHFpzegPHj45SIizQ0j2HK82pQtrK/L87PCdebMM7pv3Vnzv+B99IuhaghvLL83X1zFYyZhRs+CVv1DdsU2WZjsbxXNOWn3ulwI9zAhtu6VmiRhno1n2flfK1rtBmyB+SUrTpiAE79fP7cAWcF2/cvvwRv3THy+ifYcEYuaezJakK2iURLJ7EY4aQdFUhq8lKv6OzHkOb6f+a7+gwLTFKbUxVMqMELW862QxdwD2O3A5hM2k/cNSUNRS7M98g4umWspVivDsrMcMu3t/KWxpvY0bm1ixSso2iLfR++uvrVJzfYuxy8pkhGWhzW0Q95fK0A1BRrx72h69bJwyxazRPN+5agnfO7q+MeG2zolMJStmPd5VAb501COPJc7ixcNuayIlcYrmbgZu0G9xbN2bKf4ILyUjdXgdcglWmGOIGX0HeMrF0E9B3IQuaIEuG+0VkV3VWtZs/W1+yb5vyK2IlCZB6lkgIbIfBOGoR0awsRlw+WSGfX/DjKSEvC6SCHzvBjTeCA506Agww5Uxi1VgUVB4xUJ7WxjhNkHR+/mnqZffr2poHcQ/bKxpSoT6FP3cRwyf7Ha0aqBcEJAxQ2NTlHEAJhbhvqf3P9x/9CfvAsZUA7PlFgf7Mq0XenReu00AwqyvUTxMnOx17JtETX3w45tnTC9LYNiLCPFuNLeXkyj27qEMLoA82hs+VPVX2bgssv9DMj+79rlMYycBmrMsarH5itI9H7fAo9WDQ3MNc7U/jOre8a0iCSGEwsntIfkaNx57HkwVOtyEDQlu8CxDRK88JgCESRHOgRf3DYyZ
 tjW2nUDu
 tHtQSfglkcOMan6ZifngXQSFOeYclqrsp7ipaaY+R8UUs1LIuKTxJVwok52Y8y4zE66KUnuS4mAz5Rod6VFnz/eRMpXhIGsWQfdLAOs3DGQOT3zM9GKEv62IBdrLMOPgQDO3yhwA0NqrmfU+gk+NNHupl/oW0rst9TnBumT/M3FFTfHmZ5pEBVpxaSvZpreizFIlFDYYVn/nOSnv1KwasP/hopBvJ8VPYDEwW7FN2atCBGQnwbKHjwQOOmus5CFNdkeBLzNERFw2G4BrotlJgUKtuOifczHUa+F3i+EZ3aPeUY84aV86udq2Hx/2Kn58F9+CudmAkv9D79j54IWX+Qx2JF328CN8iw7HDN0XTz9x79BHjVgSYcC4JNnqn/V7UwR9nTPPnPsii1Fym/jMJsYiuQBuJ0IS09to6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is split out from the earlier, larger series "mm: Generalize
HVO for HugeTLB and device DAX" [1]. While the parent series generalizes
vmemmap optimization across HugeTLB and device DAX, this subset addresses
a single, self-contained step: mapping shared vmemmap tail pages read-only
at population time.

After the previous HugeTLB and device DAX conversions, both can install
optimized shared-tail mappings during vmemmap population. These mappings
should be read-only because each shared tail vmemmap page backs metadata
for many tail pages. HugeTLB applies this protection in a later,
subsystem-specific pass, but device DAX currently lacks it.

This series moves the protection into the generic sparse-vmemmap and
powerpc radix population paths. This protects device DAX mappings and
makes the HugeTLB-specific vmemmap_wrprotect_hvo() pass redundant. With
that pass gone, the bootmem-only optimization wrapper has no distinct
work and is removed as well.

This is intended to be the fifth smaller step toward the broader HVO
generalization. The remaining HVO naming and enablement consolidation is
left for follow-up series.

[1] https://lore.kernel.org/all/20260513130542.35604-1-songmuchun@bytedance.com/

Muchun Song (4):
  mm/sparse-vmemmap: map shared vmemmap tail pages as read-only
  powerpc/mm: map shared vmemmap tail pages as read-only
  mm/hugetlb_vmemmap: remove vmemmap_wrprotect_hvo()
  mm/hugetlb_vmemmap: remove hugetlb_vmemmap_optimize_bootmem_folios()

 Documentation/mm/vmemmap_dedup.rst       |  3 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c |  3 ++
 include/linux/mm.h                       |  2 --
 mm/hugetlb.c                             |  2 +-
 mm/hugetlb_vmemmap.c                     | 45 +++++-------------------
 mm/hugetlb_vmemmap.h                     |  6 ----
 mm/sparse-vmemmap.c                      | 26 ++------------
 7 files changed, 17 insertions(+), 70 deletions(-)


base-commit: 2887e63d2e8e0cf55402612d8996ce955a2c3e55
-- 
2.54.0


