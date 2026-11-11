Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 399DD60A382C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=R63OEoP+
Received: by kanga.kvack.org (Postfix)
	id 1ACD26B05D8; Wed, 11 Nov 2026 04:38:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 184236B05D9; Wed, 11 Nov 2026 04:38:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09AE86B05DA; Wed, 11 Nov 2026 04:38:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9FA46B05D8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:38:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BA2816026C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:38:00 +0000 (UTC)
X-FDA: 85422336720.27.28E5165
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id ABC7320002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:37:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=R63OEoP+;
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389878;
	b=GnC5c6Gs0QuVQeTEqunHUaUphHEOFE7fax5D6aVt6Nm7aJEHx+YiWENM6gJndphABdTP4m
	CvccOpI/L45S8kx/0FtZueJDvAIHnDomQqpr0GqHPhoFMhGe341HjQ9jfnBNVPcrefuk2B
	HReZKI6D7580+1DI3wIcCyX/2VdjT9Q=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=R63OEoP+;
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4WFlRFgv8TN9OKHijNxwxQB3kN5BVJ5WPlpTjOw36aM=;
	b=vBiL/BSgZJYp8/1m1WYWxomYqWMBOXr88JIQM606NfT9A0/sWQf6Ubcr+n3rQK7n4EIt/U
	efCPv0K0jMgwwW/yAMWeXeF0jeDpzCmPc424OI9fm63uuiYr5iGdfhXMjxDj+s9ilyFCJ/
	fgQE3jTxcnWsv/4IytwGH9OgI3Y+pZo=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-36eb1cb7aabso4559378eec.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794389876; x=1794994676; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4WFlRFgv8TN9OKHijNxwxQB3kN5BVJ5WPlpTjOw36aM=;
        b=R63OEoP+u79S1EO3RGiV8ouSx6CuIVhCbCARbwE0IVL/SFjWqucJegW1iPsJSUbYA2
         2Sav3YlzU1reGg/nmq8yN6/UCvWn0ZM3aDGQYW7tlcHoLmq+MEmeSbUTgYNAZqAHF+wM
         2t+vNYnwPe66rkbk/lDEq8dn2wR7D8uPLvlsViEan/jgk/9aK79nkmHHCHuZl6B0LUXA
         oZhXP7SFzSOjw6g0ItznxB+C6np/Bu9UTE00AGHjYOUSnG0HPwmte94o0WIrV9zQJDC1
         xOb6yaafO1c0riLe1TdAX1l+NPZVXHiT7HkZ4Zk79ynGT54ZrueyJe0Cij5AYJ7gch08
         MZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794389876; x=1794994676;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4WFlRFgv8TN9OKHijNxwxQB3kN5BVJ5WPlpTjOw36aM=;
        b=oS29kRhTRCtvL8WfoHl1MQyqwcdcsNoQYVbRAZH9Ii7f6ckNqHeJFAV3Qqofkzjn0M
         lMpe+Mjr1RCBS0ddwn6yNzvTuJQLT6uuzsXpl9UnBUmuZbLANby3bpgjv8CaUmo6ePDp
         om+q3QbTCPIH4WDdxDclCbL4CvFxBrmC2KgYxTMPTERkcBMKSt+QjkVs07SFdHuF3mXf
         esXFrmqynRhHETOXMrUq5lDgz5TeDC2taAorWLdw86t5ptYgq305sT0JxRmnbzDBSdjK
         +qLIK1Yzl4PVXW3XbKnDaEq9EOJ8nlRrWaXJrjwDIdh66cfHjYfYNas1JM9tT6jQrRYa
         Ig7g==
X-Forwarded-Encrypted: i=1; AL+hErEtUkbuRfUQeX6iecucxUM+RZ0sbrnWxt+srLkzV6NXID7528EE/TbUUXUHJwC6vUXRU4IDdVD73A==@kvack.org
X-Gm-Message-State: APuU4Z/jLAIb76AoBtBepjcqhat5ggGHHjc+eA8VSZ8qn1KnxGRzozUm
	rdP+ZKpnq3pO62ZlAyCbfF7YdvpLl0Wx2b7vcQiPckrOPTF4lrzsrXxBtkrmTt5TlSA=
X-Gm-Gg: AYBFou28dt1Lmaii5/t1bM41b1sBtjt0TKOreqR9wsag7b/MvUGNVkEu09NR7nZCYY8
	oYXMhpJTALKk1zL0Y5WCEkZxZsRmzxm2eHsIKxoSwE1kpH/AWN3XJ24d3IX8+S2iviIySOd1x6X
	4aP8Cr7kBDh/HgDNZrKm1PoFCUjs3Mj2QVRO2WEb5Nw+bu1cJIN+5UcN6B+DYAP7a77HMaUfqKT
	GHKDOE+9mPTL4eEUBOrGy9joBDWHOfeJL+mJPVfTWqDOi3TXxlwAeb2YhbSpawPazyVpLBObgTG
	Jh3bRrCQWHQT4XidTV302D8FXdjq1MOtcnsm7YrK+O7L4HwPddGvvz1HOh8r9RwntTwliYzIqxF
	louypMvGHziVKZobdoIMRn8ZTKGx8qCsuETXELwCwdosP5oX2RfFyvrof7dnm1z5WqWixgCeTFv
	km9giItnIRHM7nY4T3bJOZCpncyRixLoceJNIeJqO4zW6HqyizWYFictNfILkDDijL5YxUU2o7e
	KCnph6YxlyyRlYg0cbQkrTTSSKSK5PMQsHVcsUAvJD1OMJuZYORKo4tDiA7FzSxFh1h6UYCjSIz
	mUVHonX7AKJGFchB1boM0Q/h9fefn/ZHoyz+gbgoO5cTR8ZT0Tt9EabJ5NO5lA==
X-Received: by 2002:a05:7301:795:b0:36e:1fbe:357a with SMTP id 5a478bee46e88-37685a8396amr2265557eec.13.1794389875856;
        Wed, 11 Nov 2026 01:37:55 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-375212e9e03sm29016749eec.23.2026.11.11.01.37.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 01:37:55 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Sashiko <sashiko-bot@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 0/3] mm/hugetlb_vmemmap: Fix HVO races and deadlock
Date: Wed, 11 Nov 2026 17:37:43 +0800
Message-ID: <20261111093747.50048-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: otejuwhjje3jz5o3byhe8z5qo63zrbj5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ABC7320002
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794389877-952654
X-HE-Meta: U2FsdGVkX1+qz4culsWdMSn3hzkxCAbVrSUYWPn8OH9KVhkjRVNswPtMo1WQGMWgxYiHKhY6KYAG7nFiiolnjfG5fsF1ll15QWUWoSp5bumsVAFq6oHcUgbvCKBQq6AKglJv6Izk9O7+pYPiUHkMu4v3xHlgjggaZeuSCuJaNREMm/ADg8z1fDA/1/LGihRyWoHG3GUtfHGpgI3YOhadsUn1cE66LqHoVHsJvzWJOiHXl17+xr94VmDabvNBJocBP/IayHShhIeLJI99ngE52OPfe5BKZ217GY7yi7SN4+u62jg/9JhroHfG3KefA27+PZER4DN21un5taMO2F+n9RXisV88+419jbuTTgF2A9zfRvTLHJhzcgs70QK3HQtwBfkmpy4llr8nOgRwVznsZcPlegXgMaJMq8GkG7Fv60qsX7sygZ0XSmeAw2KyBzyPd2/WXyALLRrmby31wHWNjouYiKHka7YG7elQi+DJi2SyiS5XiRsQpAmpW5oFOSyDxHjHRMOsP9vPsF0KLabzC2ECGHaRacDuBhFmiI/mkfO9+mRKp0RANhxRwoDMlkDlTJMQ26u/lMGIkDc21/hyNXGl14CXYDcJujAmRabfo6WEJtBWJIzcIrBbYpBF0yLVVFckKH1ieQcMxfGfkpDr4rt+kZcxrmKeYpsdd3+WNWvPdDmwf+iaZj7V15Mh+TvMkMexYph4FicTfmmOBjpA9bHKrb9ytzrJxBFdNCxqnOAY9ieKxQZcdXtnj9MtFg8AwwJmSikjZVbFJImJqEUuAgwjmMhXWMm3/N1f+C+lWIRVOz5PqNKb2igOSl6BG4OWuxXYi+9CsxXRDLrb6gI+F4H7ezQntKyEgGHU6MchyO/UNEw19VHQwibZM4XLiCoNaas83ulxFKWW6TGExlLEpmiQhgiE2EhYj9lnEn6HYz5g2tERRyYCWm2/gUX1DFDy49VC0aRxeBqj6FdLw/S
 zCwYNWUw
 qg+AqGO324cO+jv4za2Xv5uDbYj3iKfWSIZ1N2vf6lEssAC06eWszldSFI/tU98kFVZKXrUyF1r+Dw/QbI95NgorVsqtF6cLoIrz+En8s/vHUmQ1/kpXne6YGj1YfbOONJY/3/gOIWJGo0LhxFjrztxrCTVP9OEQJbZJBguymEUw/hqXD2Xh6kJLysHE1KRUtSr8RJsuIPp7aZwCPbR4vXQdYwCJn2B8AfM2sZ7V8ESAbZkFbUNBWoX7ezoIfg7CkcgBDg9kT/H6ajdD64zQQ+X8bNgKJ6bIcONCPmYj7Fha5cySRtAn3WNqpyZBZhfh82oNErveHButOHMUj474mvCKxMllCD9Tmuauc5XJxmWOj6HhNsHfDRUhNbpE45vGnBBXRvSH0kza+mFCEmyePqSXmoSbVYlZ/OPuxlKouu6GC0J6vsiIvnTkXXENxc+5Wb9cnNrvGod6ulqM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series fixes three HVO issues reported by Sashiko.

The first patch serializes HWPoison updates against HVO remapping so
raw_hwp_page state is not lost while a replacement vmemmap head page is
being installed.  The second patch uses an HVO-private rwsem to prevent
deferred PMD splits from racing with PTE remapping before the TLB flush.
The last patch switches the vmemmap walk to the lockless walker so a PMD
split allocation cannot recurse into init_mm.mmap_lock through reclaim.

v2:
- Add the HWPoison serialization fix reported by Sashiko.
- Use an HVO-private rwsem for deferred PMD split serialization.
- Add the lockless page-table walk fix for the PMD split deadlock.

v1: https://lore.kernel.org/20261110112456.62827-1-songmuchun@bytedance.com/

Muchun Song (3):
  mm/hugetlb_vmemmap: fix lost HWPoison state during optimization
  mm/hugetlb_vmemmap: fix PMD split TLB flush race
  mm/hugetlb_vmemmap: fix deadlock during PMD split

 mm/hugetlb_vmemmap.c | 28 +++++++++++++++++++++++-----
 mm/hugetlb_vmemmap.h | 24 ++++++++++++++++++++++++
 mm/memory-failure.c  |  2 ++
 3 files changed, 49 insertions(+), 5 deletions(-)


base-commit: 2dc0136b1fdac153434ab02778fcdb32db5d0dae
-- 
2.54.0


