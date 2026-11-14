Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A03D9606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 11:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=eMDs6JIn
Received: by kanga.kvack.org (Postfix)
	id B69F36B00EF; Sat, 14 Nov 2026 06:25:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A826B05B0; Sat, 14 Nov 2026 06:25:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09566B05B1; Sat, 14 Nov 2026 06:25:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 723C76B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:25:55 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D9750802D2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:25:54 +0000 (UTC)
X-FDA: 85433495028.19.267CF95
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7811A40005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:25:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eMDs6JIn;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794655553;
	b=0u4f4VziaEgjZd0/E41CfQZIlHeMntC6kSse/nZPI8NcAndKd6//n61B2ehpCMO4Kq+acr
	2tV7POFcJX8HbOcB7xm374FyruzDVloVnL3Ol/mYqeZG8MsSB1oClZj1sxp73BYYI6PAVx
	m5q2ZYjKr01TFiElJ10Q9HwqWb/fdMg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eMDs6JIn;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794655553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YbMVc5P0tRqN8v0ioLIphiBpTqOVDwdaBT3lngdtRCc=;
	b=S+3umg36xbzmFtiC54qcUtEvz7C30YkEmIPW6/WbtZwVIhWr83gF903h5I0v2EjgPjqEiI
	6sK/LbdEarFUjcnnDMYrKszONp9b5PmXpVB/+zZIsnMIb6CdRG7EsiikJrG662iUdegRdB
	2FmXTycjbfXKFHPv6X/NrQpc0QAPWR8=
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-372bdb942dbso1998361eec.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794655550; x=1795260350; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YbMVc5P0tRqN8v0ioLIphiBpTqOVDwdaBT3lngdtRCc=;
        b=eMDs6JInqIvzYSUQ7Q3d5bg1nJYi5fn5Vp+7EIxZz57HpfiHJB34sUT9v/Ba7LEcxG
         zQBwaSAMMDwVSKPJMjoNgazZc3CYV/1vIAQUTooaF0ChBhRUX/0QaidQwa6efxGa+6MZ
         zAV6GhsAaMA9JiOKV1vRO5bL2bOlFbUb6aHlXw/BzcpGHW0lFUjF5yZ1XZR3y7ayPAxS
         fmTpCr4ICXkaaxWR7qGjj6f54kzAPc++7kVj7Oe136PKvPH12cEY3Q/XeGVk11C3IAlX
         PMw3n2VY0043rlpj2o7axuQtXrQE1QbdgkNmpvj12vRFrJ/f/MG3qr1sOkjgGGztyJDq
         RqrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794655550; x=1795260350;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YbMVc5P0tRqN8v0ioLIphiBpTqOVDwdaBT3lngdtRCc=;
        b=u0l5R8v2FHI34jDfSZ0RPLPME3joQNY+8MD9zGpOSjONjcnuwTK3ggL6IYLBjsSSv2
         YHGJNHak7gwEj2x8ZCmLMytAu/1jNGAQ8nZCDihVOjSf1894UjJ0gNfmXfaay7+OzrOa
         z2+RWeR7w6RcxoqXt/9Wa9c95YvD4Td1dsK1VVo29qq3SANBhT+K8yny/oPkqL84/lHY
         w9rS7GlnR6VMe11mdCRj29XxhCp+Gf/qHkyWVuZOivP3p9VSq942nDPQt6o+F7tEdIE2
         JYXlU87jhacHizbpalfYh5AWtuPMsfZwPDnjIDk04XWmlb9LadklQ9dBitx0G9Qr68Wl
         ewnw==
X-Forwarded-Encrypted: i=1; AL+hErE40irWppbrhKW9Rvwj2cDRW2D/cyC3aSDcMNGP64CJSJ+rcn+95AH0jPRnZRVGGfda8Yw5wxEhmw==@kvack.org
X-Gm-Message-State: APuU4Z/tlJxDhjCP/7dz9aSsD0qZyVY2xuQPH3ZFni3AGdc5uQrFcb6k
	gHih/gFSQXBGz5e69KOeZLQCp547GLz8ShYxcvNbJUt/bw5WRry186bWmY4GR0WFmjM=
X-Gm-Gg: AYBFou3ggvrNhxhdl0kFEzxhOEcj8HbJSad7cLpTuwNAXKv2Bke3Tv/05/PA+Yh9ibv
	qbrbz754/VCXy9fCGmK1UZkcXD7uwHH/9jJrpH/fGVPKlnKDoTRTauoyDDVTByGCH3LT+FS58n9
	upyWd8YAHZ5Oi/IiETeXGKtI/goapOr5J5o16rqQD8aVE22PFZyk7USAK1HV94+6tqFw22zxUqI
	ZISZ/j+X6LZovDMtRxVN9Hit7TKRxL1vdzWwF10MHxpEOZtwaD2sbyS8Iy1kIQ2cmSzJ/JI+aEc
	JeYit5LmU9wO83ak532jTrRANsxNsV5xC9PBaWlu0r8UXMK0shqTJL0HhjW3LIOE9plMUOZ1GxP
	B/ApF9An79dIUMltrHkON5k1Fb8yYVgLWrfRITvymMTzcraWU8MmIJ4AN/Dakrs49r8Dubgdltv
	g3Gcp/vkNDTip5KrBqN8tJ7oSzXKCYiNe7FZuHdNqMufD37Q8Nz/23pfexljlmSK2rLj77UiRCU
	s23CyOZ1LJ2gQ8RkPKkgvIwslS4dJFXWhj0gEfQS0WntGx3Hq5AZjZsM7vEu137KD3pTwIGPTFY
	qOG1nn3xaHMMxdCgGt5t0O8hDpgMzWd8t2bK37Svk1t13OIWe5MYrjF9WfIQVfLF6bOq3gXyg5m
	QiVXgeQ==
X-Received: by 2002:a05:7301:90b:b0:34d:755b:d60b with SMTP id 5a478bee46e88-37968b8a031mr4631308eec.34.1794655549376;
        Sat, 14 Nov 2026 03:25:49 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:9d36:3b30:f4a3:7b5f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379553316fdsm16190627eec.5.2026.11.14.03.25.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 03:25:48 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Sashiko <sashiko-bot@kernel.org>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 0/3] mm/hugetlb_vmemmap: Fix HVO races and deadlock
Date: Sat, 14 Nov 2026 19:25:20 +0800
Message-ID: <20261114112523.75208-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7811A40005
X-Stat-Signature: z7wrehdo9egsakqhww8tobqgm4jsicgw
X-Rspam-User: 
X-HE-Tag: 1794655551-541295
X-HE-Meta: U2FsdGVkX18Q1QUHmuT/5BddVLg/Kmh8w2lX8A3Ar1w/fsW8f9DPHiNoem9GV58BM3lC+0QykCxbNJHrsa8lvWf5Bzt8ihkUUj2uoJmxOdI05Zy6En8r+ca86lG3SCByBqP/JsFpl0AipIyQCAP6t+5tjQgYGcvq7P2bTFNe00aMGpkDktq+9Qg56ZwzQPvmTwecIjy2QbVKxFTxjq7JpLfsPDwvauqrOdjdOfIxcRIxL53e56V5Bh8Cvi7crssVdrsgbpq2dfLrMRIBodKEn+p7iCs52Vr/lk6tWa6518OpLFaAY57f8N89usE+bzSYKCsjCcPROEKbI9H6FjoNR4L+7jggA9r9VmBlfgW2yaK375jGbFakm1zStiPv1gCiLip9UNgBQkDV+lvbozMwLklM52a+O3BCoGs7K4UPR+LF8edstN3FtAPmtH1MrdSBCoTHQZja7ydaq2f0khji35poZkCBifbDJ6bStCVKSNoQiWSsFYz3TJuXJT0veEHZj91fzjr+0wrYNGzLRrOLwqtn/YYxtPvEVUwVRAdpmIYtcji/Kbh5dBiU7rqmCpMezO3Ghyv+n41nYoH5JmKTFdhVnDS84wcwCBocy0EFiIYgd9n3IGStm1H50o4+EUjGX/jVeEI4pu3grJe50acXeRkpaOYywaDLmHe4V3q4lPRNqzKkOA6IVVbwSzATMYONN4JBD5V25gdgkSCUM36W2H+IuU1scS9pvueJkHJPWIS0sBh6RfQNuiQgal/4pz/77Aa0md9vHsEYrUlTn/gYxHO43IeeM050tv4B92fG4BFR7WNkzXBHH1wou8jGxPVbZgdSopb4+DCOYCD1F9r9G0ln4aeqCBov/scDVLc1n0T/ZJa76wLlzOuYfYdrI/dLJEW6ZqQ8SLktgfgGgz06GpmkMNFw09T2L2AC3/FLjkGmf0lP+DdgdfoTecBGFQXULW0Pt18RITeDGOEdnCt
 ljJ08opy
 U0JD4QSlL4mMFbA8Ppxjo/4Qu9iwdU4fjCUjUV7mzvNH6M8bGgC4xuzKQH9lfBwg4m1YK87s4rRMgTYtGQNZQpX2ZPZZLlBENVplQFKwbYEUBlCYm5RsziE0YWkNWPB6WLS/+E7cNXgVDLKEtWfDnhOMledfLNtbxgOvQrdwd6lnd+sWnOmbfqUdv97LTkRVkycX0aNSeKnOfBORbsDcK5smLSGtmvElXDWBINEC8dEWjNQJo3CSjc76X9n60PXpGbnCywpLi3A+H9DwThBr7p1kj4yiC7UTyaBLy4StQLV3hC16Th8mCwC66nsHIB2N1pWNSSZGFKBifKxfMhFYKU5oVWQzODYIl8vY9KitChtQ7WPAzE4RiyIG5H3UaUljLZaQxrWOeCIrBLSvnOWSuIUeWx+JdEgtQD+b63PCuTHneUjkmH75+BRMcy5GL6pJmucNeIPoX/GGBTcU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series fixes three HVO issues reported by Sashiko.

The first patch serializes HWPoison updates and removal against HVO
remapping so raw_hwp_page state cannot be lost or freed while a
replacement vmemmap head page is being installed. The second patch uses
an HVO-private rwsem to prevent deferred PMD splits from racing with PTE
remapping before the TLB flush. The last patch switches the vmemmap walk
to the lockless walker so a PMD split allocation cannot recurse into
init_mm.mmap_lock through reclaim.

v3:
- Serialize unpoison_memory() against HVO head remapping.
- Update the first patch subject and description for the unpoison race.
- Collect Reviewed-by tags from Jiaqi Yan and
  Jose A. Perez de Azpillaga.
- Rebase onto mm/mm-new.

v2: https://lore.kernel.org/20261111093747.50048-1-songmuchun@bytedance.com/
- Add the HWPoison serialization fix reported by Sashiko.
- Use an HVO-private rwsem for deferred PMD split serialization.
- Add the lockless page-table walk fix for the PMD split deadlock.

v1: https://lore.kernel.org/20261110112456.62827-1-songmuchun@bytedance.com/

Muchun Song (3):
  mm/hugetlb_vmemmap: fix HWPoison state races during optimization
  mm/hugetlb_vmemmap: fix PMD split TLB flush race
  mm/hugetlb_vmemmap: fix deadlock during PMD split

 mm/hugetlb_vmemmap.c | 28 +++++++++++++++++++++++-----
 mm/hugetlb_vmemmap.h | 24 ++++++++++++++++++++++++
 mm/memory-failure.c  |  3 +++
 3 files changed, 50 insertions(+), 5 deletions(-)


base-commit: 6ec534d64f85e949a5d58070678dcd7711875a7c
-- 
2.54.0


