Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2FACE88D80
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 12:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC80F6B0005; Sat,  4 Apr 2026 08:21:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78F46B0089; Sat,  4 Apr 2026 08:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B677D6B008A; Sat,  4 Apr 2026 08:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8E7C6B0005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 08:21:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DEB5EBB597
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:21:21 +0000 (UTC)
X-FDA: 84620783562.10.19856DF
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 85BD816000A
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:21:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gpBSgGj6;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gpBSgGj6;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775305280; a=rsa-sha256;
	cv=none;
	b=33FJ8kfqtoD8mrAXB3RjeBtqL5aGRDQP+S4PEZDs2q8cvSsCX1vx4AasmrlEJX+figMMZl
	UAVeootMI8OlidFgjBf3XKQLDzg71tKFoZbBdXBwHViopCmHPbmQI3uYe4oBDkNliU7obm
	1cA28gUvSt47+R5KkeGo+vGNUmKllko=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775305280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XmD+wUZmRVhtkrDT5Nt1vWAFME2ljMO3CvkEWHIVAgE=;
	b=G3wosGY0ZXtVuYugd7vuNhLHy9RfwZjWD+grGfUyk2oWN8Po123bYPU4+aYAIzCl+oRR3/
	wcofVVojhE4UX8E/gBwcQDPEiyl11snicCXNsLtphc/5odG/1HQLfmCd5DVcknxuA14yj/
	tlrXhziqqdcmVemiQPfUirF4zRkr2kg=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82cf83bf375so1058386b3a.0
        for <linux-mm@kvack.org>; Sat, 04 Apr 2026 05:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775305278; x=1775910078; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XmD+wUZmRVhtkrDT5Nt1vWAFME2ljMO3CvkEWHIVAgE=;
        b=gpBSgGj6swRCTj/D7qoDxLyqYvqI5fvSmQ3/gndy3y8lutoBTpzXAE4g5wl+gUMQzD
         7Kjn/fRuKmS+AQO4UBVLdAO6vIollc57daXP1Ycc1p6YJerLwpF+o2lWvf7oEfRbQtZe
         aqRHN9O8SxW06Luqr86Gs6L7AsQluhN2R6MRdbRe0VA4VpFUkvV40gjaN9dTFoivsYZ2
         wqkFU90/YO2cWohW+PAR+AOB8Db+oPb0E6eNlFCcUKs7LiVmdkt6L3NcNDJ4chGm8Ih+
         Caerj2YfZut41wsSpC6PzvGGTDtc/UKlKMuvjlbHkWFcU25fRXrTNeHwoV+84ljXuhFI
         ppbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775305278; x=1775910078;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XmD+wUZmRVhtkrDT5Nt1vWAFME2ljMO3CvkEWHIVAgE=;
        b=A4u6Y5wrIImGe7SMeJgeCOL5QHRFm9tGgQ6MjCNb6QAOcJdd6eBvjSwq95xwjpHTHx
         Cga0xfKbYRlN8fc14U6Ih66Nn1593fHCnvUvXoBBki0Ga+sryjmaqS5Bd1z2RzNunJD8
         Ne5a85PMDcmddbpd6p8cp0D3MRUJHefuNx5MPS1S41pI2ZmG+5QQorHtgwSHyXFZkrnW
         IRBnMQPWmqRAEX1Zo8sByJClhLMWQYn9NGprdhY663M9lCn4Z88y98sS2LV4OqgL/GKc
         n4+s31O4FXS6b6aeuhEnc3DCCRd9/Rm+/JOkFlNIeCazSu00k+bCljNENxsM3Oyux50y
         PnHQ==
X-Gm-Message-State: AOJu0YxTQT8PV4erieTA1S2YIojDJ/7wLf+Z1qk4HzCZLLaF6kKbV4UD
	knHcP+FLnb/vbHGr5wZqYsQpFvOYzpRn5lI4yldaouFYvzR1l3jFxbezmHfnqP+VZVw=
X-Gm-Gg: AeBDiesY9Jr8y0AG7DXvmQ1ERwhCgKCzXA3iCDpI6xTwusN/N1Qpk+QEFzNKP3n/bPB
	NRfmeXFOHw8eJxaVca0WrqoSjMCnZo+VNkSbdCAsVMO7WSeu0i6TJ5Rkj1bnvgBoKRR7A6WHRm9
	qneaSHaoEMn+Pnx4JNXq3meAJ88BHghNu/Kw3+W2nC7YSENtk4suOM4Tvgf2+bx1jxppxYInvQm
	gyxEToURKsCSNyGVTAk3vv33OF0fe7chmpIKabsTniYgPyAZazEc5h/dSkStPLz7b/Bk9MWftS7
	tlJ3oANHTUzaQTawuX2J89qs36D2Ic4x5bBJ8Smg+C1FBIE/e1/1+qifzV1l3hz5Go5zT/EPVoZ
	RFJpcza9XcFM1KU6Lnx10uLFDn2vVt3iJ0t1wqLRLBiztNPmMrGqqSx/zEL9HMG3TFpDbeybfbp
	fkeKsNdTDUCYdYmLZjgDxxcxZqWNgviCWppj8XgYoDs7Qe8FMZ4pVI1g==
X-Received: by 2002:a05:6a00:ab87:b0:82c:24a9:d5f1 with SMTP id d2e1a72fcca58-82d0db3f376mr5931662b3a.30.1775305277918;
        Sat, 04 Apr 2026 05:21:17 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cfebe5b23sm8327063b3a.59.2026.04.04.05.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2026 05:21:17 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	WANG Xuerui <kernel@xen0n.name>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Chaitanya S Prakash <chaitanyas.prakash@arm.com>,
	Petr Tesarik <ptesarik@suse.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	Austin Kim <austin.kim@lge.com>,
	Chengkaitao <chengkaitao@kylinos.cn>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Alex Shi <alexs@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	sparclinux@vger.kernel.org
Subject: [PATCH v2 0/5] mm/sparse-vmemmap: provide generic vmemmap_set_pmd() and vmemmap_check_pmd()
Date: Sat,  4 Apr 2026 20:20:53 +0800
Message-Id: <20260404122105.3989557-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 85BD816000A
X-Stat-Signature: 5xdz6oc64jspbqny6qw44arc1hw7eth5
X-Rspam-User: 
X-HE-Tag: 1775305279-487432
X-HE-Meta: U2FsdGVkX1960Sds66TfiJXijK7yvaPXhRmcIPu6a/AM7hALQjtkWkGglmdtZvpuoPil6tu89Zr3mlFMJFlLcH2lIRjqXkPeTtylLZeUegWwTuL6gBNGyMh5CZciWQWt9kx6wejtu/t8NtbdKFtwQbgSUFtLrrtfXg9+TAQZO+MZblb5EN1vJxThlsul7mhMUnFNT2ZlgIqISe9eQCS5VMAYg6zgxCSVrryELgSAYEfj7WGtc4poYZdsoSNSONVN3MaEcDUuOgzCRzdg1IsLz9ryTPucsMVzzXyZ4/Sa05pk39lq0TgRlyWnvknFG13vvq8GLkqaEEE66KjoNkYy1HpxsP0V0Gp6mwHtrMm9kSB2HiTaJQe1qL3BWa0MMcCI1wlRUEaIZd+5axCSQ5W/IgBqSv6bPVZiZ7ICe2KrsYVji590piV7MwFRTBKS4+FuiWdINyD3G37R/gS/RAfcASFzQNi7tfBTXkgoNZilHq0zfAkcq+tj4za9f1GF9H5yxCW270L3iv3UW9RhlkBiI5c7/DgYcUEUWLcbmOEihukOM3HhP6PDwWNuwmr7X+u7Xh0Ur/bd1d1S/OfXxfCf2rqv3EzDeF1yC827vnFfhUE0wh21ebnaKNdwv6C46SnYmOIa8DhEL3zpYoGHMh/zn2pWvLvtfSEG0pzSXAZz3IOAiRBX3bF+ZXE5QPPUVe67eUb3BCu2HqhN1At4XY+6oTsFffOak2dnQzM37A/DwY5djnXOtF4+7BeEiLuA1Kfm/UsRVFk9Q19VvS0V0kQOi7IV87cecmMZLghbp3+GzNviCnCNfepwPlvprJ9hElt5JoMJwa0vw1qS6QX0mQQSt18SUS2LYxbqQVcz1dAVkN2di1zTdaIGPTd+o6m5i26/GQfp0xT/MSm5J5JMfgUV6nsqv06OIm2UgK8yvfBWSW9HKJwQ+EM8q1EpTxRmMa4H6M2VWqGiyYlh5aT5288
 bkX3sdSE
 +Itx5fa7AlLef1Zec6CcDIRUWZNcoaZHB+eiIUPSgd7JDzHu3gNZqXWwHbiUWccfsvgnxYK7fvCmnFYf6ti0fpLP4dkhx8QBoQOyeWXSl2ddUi2KvhiUooiS1ZQpMJ+Pe7wkFeuRvsb6r8l/LB7g9yDkxg6lvFS2K0V5C1I96RMEkIJgVaWHED2U1PflqYhDIQjq3GRqZKj3t1osuGYu2H3ZoEKzjtMk9f4+8soOg3JuJWvP/9zRIe3CXPxcLUwYuwI7p7ZEE2aKXUBX2zgsWolOLrBI7JyYH08kKya9ND+ny96o9oPszOR4Vhv1ILuKeUb13837cTcs+4UcAtxHTEoke6Bjf3KOzp4YbWHh25SAMOW242H7UNMedR+ft2IoNTPlWaH/XvVDY4P2r/5TjiTl0wA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The two weak functions vmemmap_set_pmd() and vmemmap_check_pmd() are
currently no-ops on every architecture, forcing each platform that needs
them to duplicate the same handful of lines. Provide a generic implementation:

- vmemmap_set_pmd() simply sets a huge PMD with PAGE_KERNEL protection.

- vmemmap_check_pmd() verifies that the PMD is present and leaf,
  then calls the existing vmemmap_verify() helper.

Architectures that need special handling can continue to override the
weak symbols; everyone else gets the standard version for free.

This series drops the custom implementations in arm64, riscv, loongarch,
and sparc, replacing them with the generic implementation introduced
in the first patch.

v1 -> v2:
- Fixed a tooling issue in v1 where duplicate/conflicting patches
  were incorrectly sent to the mailing list. No code changes compared
  to the intended v1.


Muchun Song (5):
  mm/sparse-vmemmap: provide generic vmemmap_set_pmd() and
    vmemmap_check_pmd()
  arm64/mm: drop vmemmap_pmd helpers and use generic code
  riscv/mm: drop vmemmap_pmd helpers and use generic code
  loongarch/mm: drop vmemmap_check_pmd helper and use generic code
  sparc/mm: drop vmemmap_check_pmd helper and use generic code

 arch/arm64/mm/mmu.c      | 14 --------------
 arch/loongarch/mm/init.c | 11 -----------
 arch/riscv/mm/init.c     | 13 -------------
 arch/sparc/mm/init_64.c  | 11 -----------
 mm/sparse-vmemmap.c      |  7 ++++++-
 5 files changed, 6 insertions(+), 50 deletions(-)

-- 
2.20.1


