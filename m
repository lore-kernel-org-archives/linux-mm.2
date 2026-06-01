Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 972E4CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D11D26B02D3; Mon,  1 Jun 2026 04:48:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9356B02D5; Mon,  1 Jun 2026 04:48:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFF4B6B02D6; Mon,  1 Jun 2026 04:48:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAC216B02D3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:48:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A9698FCC3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:48:58 +0000 (UTC)
X-FDA: 84830718756.16.14CCC97
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf19.hostedemail.com (Postfix) with ESMTP id 09EE01A0007
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:48:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fNozesy2;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780303736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1haIEjJUB66z54EoqIjtLZBJBg9TY7RS+jT0B9dn0/g=;
	b=yCXasux35moZ060oZftFdCEJhZYm8divw7nvYDWpUcaZHrJJqH/JyRKYem8GtYI3kNYkXG
	X/t/zZadxVPARIuRBegaL5VA8IwAprGw+FsLWRHpy70zyg3agRdDm1V4aewFB/Pp08z9dX
	nr1S7cGBGiqqC3bEOvcHOu+1+twa5fI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fNozesy2;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780303736; a=rsa-sha256;
	cv=none;
	b=DOLbusiRNYetYEVOyQDuX9wLMWAF0qfRS/1LobQAlma2Hodlnj0GNbZOjlokDxAtTfD//c
	2CoqP0BU11RWNj/9h5YSO3ck3hSGvhVc4cEEKFSBsTVx+XmGgFSgmfgGRYmnHv6LA0ZG++
	EoVzP7mA+k/LvaIA4XJUZ1GBbXDRZNc=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8423f53332aso322337b3a.3
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 01:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780303735; x=1780908535; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1haIEjJUB66z54EoqIjtLZBJBg9TY7RS+jT0B9dn0/g=;
        b=fNozesy2iNjCs1b310f7EZxUl/NfyABgsK4cRJ6ecHaB9b7Kh+SVPnHYhGZdHc6U10
         sXE+nWY+3fUFWqGqeA+VpFFzWz6c8XYk+63M+JsVi6T6+1lI2sGmCFMoo+1XEdug4bgZ
         R34ZsfJPO2vS7v+G1IUenEhiKBeHqCANO7zV5IprrnLZA8iNQqEe73CtpIMrROIrbAdW
         YOYy05Qoj3jVgQ3k5DzIMnrLHv3tdz8K+BOZlii9UfLisT2wpPfA+bEJFK2ZWCNdH5Di
         tB50OONZPaNtgzV3zuYbot3DI/lwbJDAK9m/zZW5dBgz42zWxqdlAvxzkRH8pcCCGuS2
         01Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780303735; x=1780908535;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1haIEjJUB66z54EoqIjtLZBJBg9TY7RS+jT0B9dn0/g=;
        b=hV8Oh0AlIekLtP7G5CZzTvGQyoSOTwSFoDdXohAB/+0IDsrTM35fAbcOZe57REp0g4
         p38yM58pU0eCjttRNf+7H8BHYzYF44XXEnwC57cUE+SLxWhScRbXYFhHCxonSuex8B9K
         L4jQkj1b7YyPshLnBQNg28Tk+a4t9CkztpcYW58WzmdEAH6+9WticmnUJPMNipWguYJk
         sJvZpaviqbW9lhpvR/NP4Ero6JR3QLDpYijFhs+O1OMbE7O/lGgDuMvGZLefM09iSJcj
         VzOAnaZoyNUiQwsiJoO03YWZSIaLmZF0Fj1L0+HhUWst2DKHn7yvrGbF50IJkhFtyQHV
         2rPA==
X-Forwarded-Encrypted: i=1; AFNElJ/jKh95u+AjmVZUrhI45L4q5zov+eRkSRIVMuclJKhzAYUctEKp1A05Ff/QggaA+1ckYDJQvzDDGA==@kvack.org
X-Gm-Message-State: AOJu0YzLTfCZRUYEXmSALuv5/maw4a6Nk/TJrAwaWIyVA/OVbRaqEBNE
	2NB05osqEES62/4F2C7cJW+3kTYkGtfPTe6XJICiu+ROK+wL9ALmyVtuz/vxKNElD5s=
X-Gm-Gg: Acq92OHLKJmimR3Fyr/2b8C89hR/xhBxey4OWFzDAXV5lDkoY8jfX6jTADpm65NbFyv
	ZyW09gyJEB74KSLtjzcrWu4qSey3v0PzBpuyO/qvhnodSzRQ28NhtK2kYEfPkQOM12peQcmpQfm
	NFDmFNvh3ol5/yLc+AfuhejaKn3aVBfcz2EhIMopYejoB3DoeZC9cuPFFyun82SYfmBJTjw8geK
	NZ9D1cUfCqgHvHYpLyeHekxJkCVPq377u7jKuaro90USoQd2uDjm/+vqNO5UOUnmIjeDNceXvNA
	ijjRi4tPnMddV7ALjj3baeyirOHKqbO+CyEZCvPU197UOj3iGFS2N6nQjST/uDXDTuyUpM7Y7qi
	/Vy0vQJ2GMAPPAYoqYyOXp0ftb7kd2lmFwzh0oOAlfy4u9Yv8+R281RhCT37gjGFN108OwrE7U/
	VknHNgK6ECWVZpx3oR5jz/yxk+L02skEbKqCc+Sb6wQ2Cm/g8OnRFGSQ==
X-Received: by 2002:a05:6a00:1822:b0:81e:f1c3:89df with SMTP id d2e1a72fcca58-8422575fc22mr8798151b3a.50.1780303734571;
        Mon, 01 Jun 2026 01:48:54 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84232ef8172sm6316230b3a.12.2026.06.01.01.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 01:48:53 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>
Cc: Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	WANG Xuerui <kernel@xen0n.name>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v3 0/5] mm/sparse-vmemmap: Provide generic vmemmap_set_pmd() and vmemmap_check_pmd()
Date: Mon,  1 Jun 2026 16:48:39 +0800
Message-ID: <20260601084845.3792171-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 09EE01A0007
X-Stat-Signature: 6rf5psxfirwmhwzqgdoxb6qixcaxb3a8
X-Rspam-User: 
X-HE-Tag: 1780303735-132400
X-HE-Meta: U2FsdGVkX19PaPTSmhWOM6gsB2zuCeh8e8G8Pkci06PDTcnTB/YNN0VIo7WziiqzPIFalbVQLSkaOY1jvwpFB/0NkhAjKyxJNYaAUQlljQXRWrBUDldfSYuIx8t+75u92fbysghIAEyRGoDMPuhYb0uvzFf1PaoLV1Uioc7GI2ku0DE0WzIRHpvMHYDaUdHQ69WUlb4/VMfQkQimQD24nfGd/KCMVwsxu8+dOJ5QZLyJUcO5ooS/gUEFeLUJI1blJhrxOCs20vha6a0iC2NnqdC3kGXplTOhp6LI/rxy9Bk1+vT2/tLZxXjEX78fSbdVKsweGmmgLSiimpqUd7dCV/yho0dH6Qw88NXzjpwhJRrGfLjmGv9u+6YJZAHrQka3Bu9IECI4Kdb2aeRmklm0rjIY4x1tpjMo90AqIa826MGwAFEtOMAR5/1USBFV4T84GQgIImTaBFWt9/L5iowgB27NkeaPk83vVZi+GJZeMAtFQ4mNFFv0uV3Azl/Z73Jd8gs27sfVye5LbpPur+ey0wFWVeMuvUw+1ZMj3N37YMbhvVj00fwD+ohqdOopyf1mNFhptQ8OelILDqXIJGVRde5o0merdzUtWB8WgsJI0T4TRw/Quk77hdW5HoOFu3sYM4xCCqufX6CfZttdoy7nezYp0qnGFWwKvAqVjWFKSN766O/K1iekpIM/FFRMvb+uQvYhdZLiaGHTF8x9V1v9gPShZZZW3E7KD5Idb6SjOMdiINmOi1j0VTIOrN+WyMBTYuexwfLgoH2ByfdSZ8E26qmLXpoS7j2PEOs5REzYyYSCZx7E8Jnq0G/XnI4DAzDkb/0hggUTAXIXXD+q8xyQXTkIgIy6eMbVClBov8MpcOmZYuhe7TQNAj97nn43DRjtjXSHNicwN9BAjUBzlv4HmHy3KNFraOHEh4q6gCAMukdk7j1AobLaQIkJYbak9TR+9AAGm0UK401zATTyFpd
 V79mRaF7
 sBEU/TVKpBerT+YUE6VefeJ88MobzWZUms3ELyidMOOwExUDR+hkdoFMPLBmLJxLBabCrATqJ+51tB+ecpK0njOA6PZHJ+CAG4YsclfGkdlnDBoYi1L4dbY11mcrneaW9N4CEbMDalBE+Bq5YPb37iEdpcf96mY1RBf8TjpPUdn2Tc1uZ8OKaOxa9PQRrtVhKtsJ9ODLjyrdVgZw12FVGxRWgDuS8vHqsWWoeZCy5A4URh3QV3I7H2UF+y/+7+Q7GCEbA8WRcBLgrxPeV5keeaj9v41RIBjpiX9Coxj9SwqN+dWRvgXwjEorNVCNt4a+KKTVTDpdWGq6MuKI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The weak vmemmap_set_pmd() and vmemmap_check_pmd() hooks are
currently no-ops in the generic code, which leaves architectures that
need PMD-level handling to open-code the same logic locally.

This series provides generic implementations for both helpers in
mm/sparse-vmemmap.c. vmemmap_set_pmd() installs a huge PMD with
PAGE_KERNEL protection, and vmemmap_check_pmd() verifies a present
leaf PMD before reusing the existing vmemmap_verify() helper.

With those generic helpers in place, patches 2-5 remove the now
redundant arch-specific implementations from arm64, riscv, loongarch,
and sparc.

v2 -> v3:
- Replace BUG_ON() with WARN_ON_ONCE() in patch 1
- Add Will Deacon's Acked-by to patch 2

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


base-commit: 7da7f07112610a520567421dd2ffcb51beaefbcc
-- 
2.54.0


