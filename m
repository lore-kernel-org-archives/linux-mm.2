Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6C63606A321
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 00:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DduHRuPY
Received: by kanga.kvack.org (Postfix)
	id 931336B00EF; Thu, 29 Oct 2026 20:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E31C6B05B1; Thu, 29 Oct 2026 20:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D3E46B05B2; Thu, 29 Oct 2026 20:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58CD46B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:34:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E378BA81D9
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:34:45 +0000 (UTC)
X-FDA: 85377422130.08.97F96B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 45A3440003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:34:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DduHRuPY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793320484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J6qvhedKX/gt9L39bpVgRBd7A0g16i9D1HZNiTvqkfw=;
	b=oisN1mMpGHIoFKWfOwt+wNKsJ79f21d4fgHkne/YUoOuZ0F6dkX2+R2eFVjWynwWB1Q7/i
	u9b9y1yZB7r2uFID8Hs3p4m8rtwLmFb+W2NEDnhm5M4iYDAPEGKXISAt8mowt4Myy8IzZ3
	70zLWlB3VL9x7JYgSaTu08nha3dRfzQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DduHRuPY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793320484;
	b=oPhG5TzoWyRF/KVW2+FfEoh0VLYie2pKgLgHDSb27jITng2udTwV0LCf/OO9XUYrp19SXe
	z2yhC3GvG8S3jryxiSjTjuOTfQF6eFT7bBuzyZ0RVQlfJQdJk4wlgV693x3FbqCdynqyK2
	c1hmZt43myLDe3az+lCsx5FwFqoIKKo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F6AC438A6;
	Fri, 30 Oct 2026 00:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BF11F000C1;
	Fri, 30 Oct 2026 00:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793320483;
	bh=J6qvhedKX/gt9L39bpVgRBd7A0g16i9D1HZNiTvqkfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DduHRuPYmFLQVXIsNcNjApO97/T8X2q8UAfCyYP1FbDA55gYCiFqIxgKlBRMzDPCT
	 Eqs2Hx8NW5JNHHOwoaWAREmZ9P3g0DpqSD6ZIAALIBan8uNdEC7bloNBM6ojVGEYVk
	 FENFOG2Gdb/Pe7A0j+ozRR73EUaDH16qGjtXlvUo9kWAgkt1QHi+VdagnEw8C8T74j
	 Yr8bysC4D0OxTeYJFfW5QuO9Da+Ehdf3XvdtWlh8G5C0H/tFFCwNzQnltS9dLOayxj
	 OH44Anbtpxbx/w1SEQjMZhJc6+ynBnLLft0fXjVDgMDV3v73CICkPnVUjb7wRDMMx3
	 S8ms98yTtaxtw==
From: SJ Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kees Cook <kees@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	stable@vger.kernel.org,
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v2 02/47] fork: take mmap_lock before copying mm_struct
Date: Thu, 29 Oct 2026 17:34:33 -0700
Message-ID: <20261030003434.154864-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261029-fixes_core-v2-2-a64ce7f83abb@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 45A3440003
X-Stat-Signature: uhc893w9c936i41p9gewbrqawogx756r
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793320484-787589
X-HE-Meta: U2FsdGVkX18ulJ5R55Ys6zR2DynfktRE/DfPJyeKt3CXD5FpPj41MpLtEhr00Ao/OYL1VImjmX2Kab1Up91ZfiPO5bgtashmVzKVYcNOMaRFYKP+Xji4vPbUn5q7wN+PhuBLBrjaSXGpZ3Vu1oI7ESKFLKoQND8jLO1GRE4ROA6ksta/VabfwqcUm40b+C/ZaMtfxEfJ8jZL4Dl8Y261RhIDYiD1l4iMoYvYVFJveyOPEh35rhbBSXS47uSynKx713apcMYakKUKF/RS7ISZUARcKs5GauRrPGaMh5sckIWRlJg+8H+NRxVoKS7wWuhIg/jpk546juUk+vregZrhnWvp6+yahRHcXsSdsPpnqB2WJn0oqC78IkerfV3jeMIio3VRwUjgEwfbRmOCxR4egYqmIZN8bqggerBBdGBNJ0DfNv91tutbLs9NbWBaLsA7/LyvFUeqC1Ux70YXmaBvcmqnYEacUg4IWgFZWU/yu5hi5Dy/1iWgFrpkuunFQ26w7Bs1aLaik149rQ12aNk1zjzFj12synKUjfyu974+O6qCncupY8lEfLFf1JxnBpO82xexhEdmeqOxQCNI7Y1Ee0nXDXH06hdCi/ya/AZVQdN/2aNPkyC39PVF5XQrBJrdJEHlFzcFF5ekR8KJDKT33nJhD/R6AkrIlndUiAQAWwVeTi4ppEmDCuOn831edO/z0iDN9lUxkEtPR73q/UPmMMkcFyCdVCseTArak7c/RGUzqoB2sXtUKS/ZL+SNrsDNAERmYiy3RJnvDqr9M1VpvkmmZMWxBavjJAOqZEmEVuwBg3H5GMVKgJrkaMyXqH94e+AWLtEyKzGQTVK9/25IimvAbagsCKh4uBHRzqaGf3+mDoegrYphd/+tVYl6cz4ofYqyesAbFyTXjcfU5L1ds+PSmnbIwFxYEM7CvkNLRGUGDURyE+8yt4mLEJnGclfp0o3gaFT1EvEzOzdB36W
 ecaJeJOC
 cZRdxNXrL1gMvcj/xZYlK8wlKlLB5pqjD08twNSvg5BKgkA0n6iPVMDG6Gb75ObPmCisWoTa8enRzZn2dQVVGSAqsstnS4kkOc+asPFJt15M0XclHGIBF1LBd3z5om5+lPAu5Jyj4U4BRhVhqaoJVLXeX63aHY5+pEgMRwn3juV9XeQLAdPFE8/OYAYPhKydsySS8BP5fNXv3PiE1nfgtXB9UOsBcpjPYuRhQCCrl6ZY11cpdLMhvAKTz7b/cogDMA6QaIt2/GsgZuvwGdaPp5vZ6TL9ZCEiwq2FxiYEvai6NYJXDl+iQ4sP4axR7Ht3DQBYdn0eBJ8RA5PfY2rD8e5FcGS2uxgAGCKlD7+UwCiHfwaoGn+C2CmVTX5867zpXJEbHIsqN/plt6eHnt0D9UN3ZeAGRMqDzzqR6APd0l7+2Spshz2VY1/OTNq+1HnD6vngQOPRKGRsSrWyAXfcSXoLN+oejj2vn1gOE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 29 Oct 2026 21:32:57 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> dup_mm() copies the parent's mm_struct before dup_mmap() takes the
> mmap_lock. A concurrent brk() can leave the child with a stale mm->brk
> and newer heap mappings, causing later brk() requests to fail.
> 
> Other operations (e.g., PR_SET_MM) on the parent's mm_struct can similarly
> cause inconsistencies.
> 
> As a simple and robust fix, grab the parent's mmap_lock earlier. This
> way we don't need to update individual mm fields in dup_mmap() and
> keep missing ones. Stop updating the 4 existing members (total_vm, data_vm,
> exec_vm, stack_vm), as that is now no longer required.
> 
> Keep releasing the parent's mmap_lock in dup_mmap(), before
> userfaultfd completion, to avoid moving the userfaultfd handling into the
> caller. This should get cleaned up later.
> 
> Move uprobe_start_dup_mmap() to preserve the lock ordering.

Looks good and makes sense to me.

> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Rik van Riel <riel@surriel.com>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

