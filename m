Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D224606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 06:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=aX1xXnjj
Received: by kanga.kvack.org (Postfix)
	id 15B7F6B0AED; Fri, 23 Oct 2026 02:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1328F6B0AEE; Fri, 23 Oct 2026 02:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06FCB6B0AEF; Fri, 23 Oct 2026 02:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5D126B0AED
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:34:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D9BAA7D70
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:34:42 +0000 (UTC)
X-FDA: 85352927604.18.0433693
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id C272940006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:34:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aX1xXnjj;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792737280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=64tBqhaCstcvhuNkWvz0hImiXE9PsoHY46iN8B5GY0M=;
	b=V+HFy4IzhkBhDarcMDdYFLa1P41zpEGCq9zlsyLyoVNeRFtPASDcbMRKkL5n3kJ0M1F0aG
	B6CaF3dNgaO2kLYUYqfrLIgBd4fZiSiWopmwIg932mkyXKIM6XbtuuFHbbC/+GLWIAUIJg
	fBO60Gcwqf5mYWrfQJblynQALRRTlY8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aX1xXnjj;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792737280;
	b=KeN8+xbP1RpqgcTMsuptz50p3v+dYfeEsDQj1rbcj2EQWyBq7AkWqD7y36FKc+Ygl/mqKg
	6+SE9aNPCdOzPaBNqUOvqr9BRmNQ4eoSrXBXS+5xvk4wpgajM421A01C8go+T9388b0cZu
	x1UiUbpXe4A55gqCw6K2y5AuJZCBtMM=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3adc4590de4so433324a91.2
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792737279; x=1793342079; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=64tBqhaCstcvhuNkWvz0hImiXE9PsoHY46iN8B5GY0M=;
        b=aX1xXnjjuovbdqqj80M/WVR7c4LnQTH1Lf+NazbB9gEuhGjADCmOiYjq0GVthbkz2z
         FCEIuh21VDI98eOPhlptEv4i0ok8uPA8bwsyzk2Ho67zL+r4bA2b0RdnMwQXtUl8XWAN
         qiU3+Ly52xUQpjTOrZJ/K+UfhmDBqAg+XnqYMXpq9fH/n/+8wcKbtklqlzOrJSEoJFFh
         7KMiJRs+6gxJsIi9QZF2A9Bpi6TsmCEyyct/gbQSMVZ4Z7XJNYPxGUFskzwLqZy87XjV
         TFzvgKJAvUecwQvQi8V9YorxysifSfv6+oUcVgOE74Fa9ndSaZ7y1r6Rgh7Fgli3KMw5
         k+xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792737279; x=1793342079;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=64tBqhaCstcvhuNkWvz0hImiXE9PsoHY46iN8B5GY0M=;
        b=o71tdaIbibS0dNSkzhR6DdKSvi3I3wl7hZp+QDSRYmechnRjWAvJVNAiH48Ip/RQlx
         cCRYt1D0kub5+uzeiAz4ZzwQifJyQk5OE5DgWYEDHLxWARhv5k7N97WtgCQDVg4McJUS
         HaCm8JSd/rCtVB7XgPb/GTs5avX3cjDdiRT5o7GSqCjdHXBeLVsTHxwdle3/FAwj12G2
         B62Z4ieTays83PcUO2th/2vygQOP6gJN0n6AgYCUSY+e021XbYSAzOCEW0Cym1TxhwUy
         yprWNBJNtA6g85G25TH8Dk1NdfdW2BHNgPsrYFIqWv5pMSj1BilvvNPNhrxbw2Jr36Q6
         yZaA==
X-Forwarded-Encrypted: i=1; AKwUvBxc2MOSGvNp9lXUukkiC9oH7urktQyGvkjQuyhtz7nMxR9BRsU3o5fv+Jdx8yBdFxq+4kxwMuGbhw==@kvack.org
X-Gm-Message-State: AFq9FYKHj/SlOpxTHXS9HdmsGPBOmtS35zc4GD+oaWLLG/XMVzy4uiLO
	NHebzpbeAN+4Y7WJGwWTyIeIe87rKlvbCxigG15pPi7XmhzXSgt2m/au7k/eeDal4mU=
X-Gm-Gg: AYBFou2xaRuLSALpPmGGMk7fKJVeGgk+y/I1eAXoJkpTjmrJEWiFtvXPPS+s/zz+ClP
	ccoTtHa0aB/BdxqjYf/vwwpV8Wv3FmVlDQuURAMKgGu2xGhhcqLyK23vyq1Ltpm3YtR9pSu4uCX
	mWQCFaANZoD7xCzozcrl38Bzz9c90+71Mhw6Iu8TqkrZjSGGs2gVzsVzc3AeH5HovTFgn81+jke
	oEU/yX/Pgg1wlXs0qSwzOM9B5EXjalfMmGkTphkw9zIRnSL5mm22t/r49cILiRjEESh1v9LWyQr
	gqgEDlJYaZRPnpEfIx3LJMRIYmcRQ+EIjjHNeSETFFWGtXB3CrGg/0PQrHX4lAVjZlZhEeMebAW
	fC5WOnAmoLjKLTlFYrRL2fmKhZBdOD/41nZUUlrGcSBLemJv8T2vdpsC3CCoyJ2m3hjS+pWrXIi
	LKWaP8nGsilFdGE16xUFik8LxPvbMXycV9118dO9h5t6Nom+O+oVSrcNk9ZW/Lt8zXKlNzl7Jf1
	BXaiinLnnzyhhjcB/TJzzq5ROLjxWBfIteEpS2cxp4iHb3wCjw68dPQowWvRcCFTahXUqCWGp0v
	nQ==
X-Received: by 2002:a17:90b:1c82:b0:3ac:a7ee:6770 with SMTP id 98e67ed59e1d1-3adce0ccd3dmr1138974a91.7.1792737278490;
        Thu, 22 Oct 2026 23:34:38 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3add246f308sm575202a91.0.2026.10.22.23.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 23:34:37 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 0/4] mm: Fix page-table teardown during memory hot-remove
Date: Fri, 23 Oct 2026 14:34:24 +0800
Message-ID: <20261023063428.3658761-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C272940006
X-Stat-Signature: xf1t7cyn68wu7dbf4ackkuasjneuu45u
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792737279-327987
X-HE-Meta: U2FsdGVkX1+f+RCLr5r8q5R6gZbSrGL3q+j4OHyT5b3w1fjn5wbAPHe8xlIdWCrNoN2x8EZcsopfUIFCjg2UaMGwmmK7RhwEAX5j6QZffGvnltoD6S0/a7fKvMuYlZKd/9VFza4eR/OQyUfzgVejdHLjwBoE2Uq4biGa2oKSIvLPhRHF82peNAJWpT7wCBbY0OhD5MjJ5oxkTtERu/bimcPS3dAsaKtNcCXUGwq76bBURGV4cjBgmg35fO7sEpjhvTXaVrnSJlTKQ+gVmhdHPflzzSb3Ioiag68n6cR3yLTOxumLagNG3c6qREtnN1gMqXPfL5RdhakDfrkucFEokIsB1aaG7TsWJ20xrdFD62R/UJ8OlELr/0iBVdvb4B2mRX5YipEXj/ObY7IW+EhqirPrgH2FErLOZ05Aac+lKs+ELtv5zMOOhWi+fy9xky6+0nAyU9lB0dvIp/1+kMczvLJn9WuEchtsgauxhFd/alMR4NJ9XNblLJoDagwPT6PeFsRHr4whwd/mifncEuCDujNxLdg24vgO6MyKGUgHZugBBgRC6Nb64iHGj5Aqb2zJayrk4F2JPYUNm0rlTge9r5kYpTJX1kYmlxFvE+tkWK0bstK/609MdLxmegK3tz1U82haAbQj/coAWrMXDQ+q/j7vyF5m1w/ClXs9XRHnAwgOXaEWlM1C+LGibhB5tN4Fzqx8YaxcITFeP0RZRKbemxfqI/WxajBkjJI+lCPSwU4sJ+58fkyRirsrSHN7XvxFgnfBMXaDH787TnFPUbfAOrB0QIsSg1WkJXqEH3/QczaY5s1Zz9/yie9H7iBuPGkkBgRwa57Z37keuhgstuhNe0J3YzUb8l0dI/pcpg8c2wvn4kDmA2d+aTHhu3sWSErG+9Dz2n9OgIyue19XJrVdVArIVB0V7puEHVGQKvYjARW1H/ydmoMiIOBlnrt/+3cBV5LKviOmg7me9WamXLn
 qpCItOrx
 kZwaRx68vJSGxAgHIHBCbdzydvSq4uuCsVt7ByKtALMbon/blfWp+lkN0qgl1wCbFpF4y2XL/tB9g5xZFA3+nJj1rxn4Rl+DhoIM5TRvgkkJeyUAcfl7uZddfHEQSecAP34xwR0eCdCw4atbGU+Lz0TjJbtoPO6kFIXB3dd7ogcplh7OuJhb4NIHM+QpF4P1ePqNeQC/vq0fp1Dq2/nfsoqU3iQQrxAZfJuacX3kgFEbXl6VmLuvE/cNc7A1l5X43MF5tCq8Nbti59jy0+mrJbO7lW0K36mt3nt8XwTK9ZJj32+jYEH4N0EPzGOEb+90EB6NrfSkBvg3Q3G1QfoX77VVd4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Memory hot-remove can free page-table pages allocated through paths with
different constructor state. Some paths run the page-table constructor,
while generic sparse-vmemmap population may not. The x86, RISC-V, and
arm64 teardown paths did not handle that distinction consistently,
leaving constructor/destructor accounting unbalanced.

Make pagetable_free() handle any remaining constructor state before
freeing a page-table page. Callers that already ran pagetable_dtor()
have cleared that state, so the destructor is not run twice. The RISC-V
and arm64 fixes then use this common helper for their memory-hot-remove
paths.

The architecture fixes depend on the common MM change in patch 1, so
this remains a single series. I expect it to go through the MM tree,
with review or acks from the relevant architecture maintainers.

v3:
- Explain why pagetable_free() does not run the destructor twice.
- Add the x86 stable prerequisites noted by Jose A. Perez de Azpillaga.
- Collect Acked-by and Reviewed-by tags from reviewers.

v2: https://lore.kernel.org/20261010112457.49485-1-songmuchun@bytedance.com/
- Move the destructor decision from x86 into pagetable_free(), as
  suggested by David Hildenbrand.
- Use pagetable_free() for non-reserved RISC-V page-table pages and
  simplify reserved-page handling.
- Collect David Hildenbrand's Acked-by on the RISC-V PUD fix.
- Use pagetable_free() for arm64 intermediate page-table pages, as
  suggested by David Hildenbrand.
- Trim and update the commit messages, as requested by Dave Hansen.

v1: https://lore.kernel.org/20261008073021.2512665-1-songmuchun@bytedance.com/

Muchun Song (4):
  mm: fix missing page-table destructor in pagetable_free()
  riscv/mm: fix hotplug page-table destructor handling
  riscv/mm: fix missing destructor for hotplug PUD tables
  arm64/mm: fix destructor for unconstructed hotplug page tables

 arch/arm64/mm/mmu.c  |  3 +--
 arch/riscv/mm/init.c | 32 +++++++++++++-------------------
 include/linux/mm.h   | 37 ++++++++++++++++++++-----------------
 3 files changed, 34 insertions(+), 38 deletions(-)


base-commit: 26d7e34b4226709084461a07bf28d9066fa96d8c
-- 
2.54.0


