Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C7CD606A322
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 08:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Wf+70cOG
Received: by kanga.kvack.org (Postfix)
	id 6D2AB6B05B2; Fri, 30 Oct 2026 04:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6840C6B05B3; Fri, 30 Oct 2026 04:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571C36B05B4; Fri, 30 Oct 2026 04:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5E36B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:38:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 893EFA0659
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:38:15 +0000 (UTC)
X-FDA: 85378640550.26.6621388
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 173C2140002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:38:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Wf+70cOG;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793349493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ml5g8GJyiKqZW7cPKgtShDnwVwZ+S7TeGUyvRqBFqBI=;
	b=a4v9psWDKWQfSKezj/htqoaeC2OqlYe9HfQMXkS3kMXQS4kierIY/p6DNrFRYqN0bpPcLy
	bn4dQ8lCuw+qfTcCCDjBzP0kLkeGUfYsfHDFtJpBcc20lCLJP9sAVFEHjlD/XlH/gx0wbx
	jOPmVIEn/y43WiU/EE8HJhh06AoVLr0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Wf+70cOG;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793349493;
	b=AoEJI0K06PmIjS/o18IktwnHEJn9acH1+wn89RX0SW55t39yocSQmksgHuHD9gWlaqwxpI
	cDPZhFFGDaFRvFBB5nwkRDQKEndeaOrJPAbY6s0e8yLHZnGMjtkphnsyI7XZ7ocA1pVTPQ
	O3KPA9vmGGL7wPRLdMnL67LlgVvYalg=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc758830601so284961a12.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 01:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793349492; x=1793954292; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ml5g8GJyiKqZW7cPKgtShDnwVwZ+S7TeGUyvRqBFqBI=;
        b=Wf+70cOGGHklFdTif2LTNrIOcBtOp00VTJWBjtfHSKYlYGh9LfVf/Pq+Sn56sXIevh
         M43hHYHY7ZVxlb9UBzoweypL53o/ItDt0ciiMQYu7Agd2C08/V0VmptCKi5F5xwegGJR
         MEQG1uyp9Wosy57YcrW83f262wwDuPWnRVHBP23Xvm5xbsnOJ+ELe0Njckno6AbenIaO
         hY1KBGlYjsRC2eK8Z0Y/5DfykKl6bYA+fPHkXcGAwgEikHDJyahACiXkbX/EWFw7zmNw
         XbtRVxqyJec8ziJQxPznImXSygCBgoSxgikB17rSMWjgR6ez+T0oDFwLUmG+IGtrkOUn
         u0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793349492; x=1793954292;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ml5g8GJyiKqZW7cPKgtShDnwVwZ+S7TeGUyvRqBFqBI=;
        b=AjJcr9gayEdGmphQDmsvtX17ZqREEGkh1W21tyLdoETfvNBHZ19gQQgmyIRqCygncB
         Zelk/UGIXIeZUQBQ3PTSfe1L9VXwcxojLDAFka96i0oAx7WgjSXoO5dHa9ONJgNLRy1/
         C4sXuC3U2G9IwyIN0W5RXm74x2jmYgDf4G5UnDOzbDyxogWUybAoMriX9EOZcVjlDHxT
         CpwOjKIXPWGfes7+nnhzrL5EguSH8yhXUc23sA5OGDLGjOarLrwvFQqNH2tixAcGyNBx
         bch2re2T9bQgzThqhZ2Tv/RXvNO3Wu4ycVqkZ8FgNgYO2XmeJy/bw7nheYSa0QtUi61i
         QyWA==
X-Forwarded-Encrypted: i=1; AKwUvBzQkKFzKYv3d8rbldMWzPOPT7/YMIyIfkQc93ht2JoEuhYnpkT7lY8BmMDYTIIjUQzFAcVDmXtmDA==@kvack.org
X-Gm-Message-State: AFq9FYKNpcXRSSCDoXxsyYK0PFEF6sL3b1j3fTVw5DT8erDFzXi/dbsX
	maeSLHnnqmHT8qRKGcWdfbVsGyBUmzghg6n9sowPhgbHZzNNQi0tHEBbtmi7crDduTQ=
X-Gm-Gg: AYBFou2zNhy+DNgURkdSbZ9cRsfUSQOTWQDH9Bado8P92KvMtC34VfG2kqHLMFFLnfD
	hZASbt/O61H6wqps6RL8Vf2x7wDPCKwhRi+qn4vLfVKrW21oZO1xm/w4w9uEkk6YIW0endNw72I
	BD7fpZw9gWONlhkMGtlYGzHmRp/Xe7ZA/ToARMlhFYvckuHPBnmdBBxOSZxGVS1HODjgM1YKWVC
	47PqDzhXbKi4SfgYz4DXlvu1Cb2r9du7Ml2542p8fkKICoNbgIROR5z9vzv2FTpifnW0/Y+gwxp
	+ZAj6QgfZfQypaNVaue9KExtvmyo+R0Nb6XhSl59xjYhx18wM2JqVoWfuCMQvivxpLh037twLEG
	n1qG+HfUiMFOKojkr2TAB9RPbL9Ad07swPY7UExTJjrtO5HqD63ZB57p+wjQhWvUm/eydLrAMwX
	Vgbs7TSgIg04Hiabj7aCJkAs7mutiaX2es+oCnf/zBvQnTWPmiFQJeRfsojuYyGFeVrNiGvaLiO
	MD3ffEU5tr2wjZJYRKTBWxoSUXyNyW2Cd+5WLpsYsgff+JjCBeIMn7H9J6JO6PKWFFhMltxaEc6
	NYx9ve5A3Q7U3jKphp/W9F9NpcgNsgg0qQI7OHb5yEaQosY27Yo=
X-Received: by 2002:a17:90b:5147:b0:3ac:97bc:4c7b with SMTP id 98e67ed59e1d1-3ae897c7c28mr1424866a91.14.1793349491405;
        Fri, 30 Oct 2026 01:38:11 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.100])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e9b1506sm7542122a91.15.2026.10.30.01.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 01:38:10 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Alistair Popple <apopple@nvidia.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH 0/2] mm: Remove pagetable_dtor_free()
Date: Fri, 30 Oct 2026 16:37:58 +0800
Message-ID: <20261030083800.599152-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 173C2140002
X-Stat-Signature: ar1kgk9xetsmzwd8ey17hurwzgdxcyen
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793349492-642248
X-HE-Meta: U2FsdGVkX1+lNchRSh05bqOwsJFHavPDdpFzKqcAucOrHb5Dmz5TuzcdCVqzo5dqG06vYnFl+GAjfJXnhQYdgl3RkvdDBnRTizov0bMDggahLtiuWlFXMy0q+LbKkciAKHygCLY4JK/tzjtuBIqWdCmK5u4R59enjf88D4rKAYj34TMcyrQNmahUqp8OZ1da/MKcMEFjZhLG7u/NgcdTmC9uRNmF+G19PWbSUjO2PPyd/BkO51YRqWhC1mqO9Vbcs7IwuF7PWVDnjAICOPJxampuDt37dVe1c55PT/6ga5vgwXTY0e+P0HBziPmfAjcXwMoy0Cy+1AGbKHzoIJf2XG7wkGTxAuBffxBl2ZCGmDHAzHqH1FknFXbLPNIyj1UnntQJIm7HsCiQf5vnGGvWZpIsoXy9yqSmYcU8uAoiT8rFb6V3IxRqj6uK2GUozNLoVnm/xzTYizNkz0EcLLAgxBgvAe4vqpk8m7YivFBgFVQOtnqyok2K11MlAOz+dqSjPjBcTaITxbw8sBllmUXI3gb9EH8QVses0En+oKUJxRGH2gQfaftEIIzJJ5na9JsuV3M7h05zC4p875eAKrG70/VDKX/FojNnyYlofqV6P0KlFyNtle3xMyzXxc1NQONni+tMBSpKV2bLl53uwP+onGCLDU01XX/t4+Mjnc+RhHWZKeCdXd2WvwDGV/fg2LUXpWdEc52UxxssDAXOtDs3YQJKuB924dSA0ogYuojH1UidfHifabLzPKRUD1f7nPeNzcF0M6HcoaLl1ckCldSgg58g5tKWeiunhL2sEpU03PJ47OaxpS8u0yHsVvkSBScN3kAPQ9x8W0qTPFipKQQT59P5SWTM6NSL10IQhKZyujlnatefoAOVbvsdpcIV9v4n8GZMNioBznjO/BcBq4ITYhWwPiHcfmH3kYqqIUYA4nVnRgEo7HsXoiFeuOL1xPTR/C/vVfb9DwJBTwDNuX7
 DYBzf5Eb
 l4ZezhGPWDLL1a36Z6VYn/7JWiG2B0ELnqotxy/a/WNIRhTTlAWWc3YTB6kGgPLLN/c1QipGpCLDZ6SfrYLR/B8bMzhEZlE7J4TYKs+7mS8KXbFQkEsRlOqKrkW8/sENHSmWwLDNciTXkr6lBE0nEPzOYpRAyIL3Cj/R/NcUWcKbFMhOHx2tBdLV6+oepRSyrMY1lCphm3Omk/3zZd/OO3Umb9u0lgA8P3ihv4zmfy/UBgo8Y1Wq3IKbA/otNYXTLM/XQ6zsK6ln9OwokFeOqX5fnYmlyaxZayw1cmUGRr+3pEddn7SH6UR9SjlXw2Y1KRo7yCXl5w1yea26+6z6ehC2zKz7851fl6/VcsN7JQI7z0J2PJxffY51qS63PI4gc2Awv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is a follow-up cleanup to the page-table teardown fixes [1].

pagetable_free() now invokes pagetable_dtor() for constructed page tables.
This makes pagetable_dtor_free() redundant and leaves explicit destructor
calls immediately before pagetable_free() duplicating lifecycle handling.

Remove pagetable_dtor_free() and convert its callers to pagetable_free(),
then remove the remaining redundant pagetable_dtor() calls. This keeps the
destructor decision in the common free path. No functional change is
intended.

[1] https://lore.kernel.org/r/20261023063428.3658761-1-songmuchun@bytedance.com

Muchun Song (2):
  mm: remove pagetable_dtor_free()
  mm: remove redundant pagetable_dtor() calls

 arch/m68k/include/asm/mcf_pgalloc.h    |  5 ++---
 arch/m68k/mm/motorola.c                |  2 +-
 arch/powerpc/mm/book3s64/mmu_context.c |  1 -
 arch/powerpc/mm/book3s64/pgtable.c     |  1 -
 arch/powerpc/mm/pgtable-frag.c         |  2 --
 arch/s390/include/asm/pgalloc.h        |  4 ----
 arch/s390/mm/pgalloc.c                 |  4 ++--
 arch/sh/mm/pgtable.c                   |  2 +-
 arch/sparc/mm/init_64.c                |  1 -
 arch/x86/mm/pat/set_memory.c           | 10 +---------
 arch/x86/mm/pgtable.c                  |  5 ++---
 include/asm-generic/pgalloc.h          | 12 ++++++------
 include/asm-generic/tlb.h              |  2 +-
 include/linux/mm.h                     |  6 ------
 14 files changed, 16 insertions(+), 41 deletions(-)


base-commit: 9c449f885765cf8d80b2c60b1971e774bba51a3f
-- 
2.54.0


