Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11859E83043
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 02:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 773516B0093; Mon,  2 Feb 2026 21:46:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72AC66B0095; Mon,  2 Feb 2026 21:46:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F5DF6B0096; Mon,  2 Feb 2026 21:46:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 494D86B0093
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 21:46:13 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8A60D4AB7
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:46:12 +0000 (UTC)
X-FDA: 84401606184.01.ADE0520
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 19CC0A0008
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:46:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hkATduCB;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770086771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3D/9r/AVEV5IrRNPbE+cI91aN7BigHURAxu2wCS2Nzs=;
	b=2E5bMDdYGW6LrJCieNlQKcSo9yFPVRPVaFKcgyVzybPeTGolHZkjml4tx1XyQPjpBCETFP
	S0HEbJyRQWrf9sD39TiupehvxySmivf/vhZ9p8u/pH/rd0zgoUAvPeKTIyAaw5HeMnuGz+
	L6hrb3fbJz+HBNgz3u5eivyb3bUFjRk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770086771; a=rsa-sha256;
	cv=none;
	b=aWjoT6kjGksGIDe0H3Ckq9lk3u1kNV6WgCGFOuwUnyQyqEAjIq5hEahVXeYvuuxYpZq/2g
	uu/64m207TE4/edgpuJtcdeP9VD9NyQwsHQgdJ6N6d4z/sr+Q0SBdf/eknuoeWih03+6qO
	kcLlSrCNQTDjajAdd15fqEzuh+Z3Z/k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hkATduCB;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46FF3401B5
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C08FC116C6
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770086770;
	bh=+BWcGwTRXj91nnzXz+rBLuj/uHTPJswtnSCdZ1A16bQ=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=hkATduCBMdPAT4MPO+UGPhQgkRHEHJLWXuKAORbUZYgXLrpb8awa9mZgtzWVbUgdp
	 tJk1Jv/dzaYNcGOTkIyOPcpH7Gdw7s82Jig0viUoES9dPlblzlvHWzopPlXBuZ5Kac
	 MqdAYAVV8Pj7nUmRZLCKmyfUJSUn/x8Kuvjnd1Mo=
Date: Mon, 2 Feb 2026 18:46:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Subject: mm.git review status (6.18-rc1)
Message-Id: <20260202184609.7c922fdb9dcf59195ef39335@linux-foundation.org>
In-Reply-To: <20260131151416.91ae6852d912c6effedd202e@linux-foundation.org>
References: <20260131150936.3b0a5b3f45f6ea5f9930099d@linux-foundation.org>
	<20260131151122.32fd05d3b8460c614f26f195@linux-foundation.org>
	<20260131151416.91ae6852d912c6effedd202e@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 19CC0A0008
X-Stat-Signature: q37exmwpkx8k8cwm5bnqp8ee4xh35ruf
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770086770-51718
X-HE-Meta: U2FsdGVkX1+izoxteNd71jBC0aqh0/DhZzZ0M/Nx5DejB8NT6K4deXYSktZ7qSwhONd8T9m4u4i4eK7mUn8JBfuJuSJ1MMuiGkS+lWtVlkiW4f1aR3LxSpOUKRSAaa3YW8sMbhlcMxXXtWL2sc1Aa2+w3D5cWip1UvOMI2d/MV8hRT9WMBnQNsrGfMwBwPt8qWk27DnMmqxe8zNhnR6FLBsLZn12axNIqkuQ+0hhjBqjVqgJETOX4DapuXWBsAWVYt3PoUJTfF9mso9rf8En957XUbYxJI8T9kYdrTMdxIsVgBUpPDq+o9pVr2oF2tChy5JuiLrG0Msfc/OuTjYTWrBY08U4a3o45EmHu53etvAMWUmJQmHTAHYMM/4vA/g43yDMeH86+i9mPepbIMAuAHXqEhZqRGKlbG7SdFNgVJzYNOCcSSyMdZtb4pvA7P5sjQWY1I+T9DyszZcN/IJrhAET3VL3euPL7qKGR2HT4QnONifkNpjtP9Xl50f7FIA0mFcAVmOmx8lIw9fwjPEfLtKnW8GVzka32pYV4XeYi+s686IZ2vuQOJjR1DmDRSnMHs/EaxhJllyUas2C8NhfASDjuda9VPStRs3UE0kRGM4YBebv5Th+dGGfOT+fIWVDcPRjlVatcx2onLl69mc4rwXAc1Xn3tdI+QT+ZpDg1/+tNV87RVARDr9sUlCEoD5lDrmiqdTpHelU/guk/kPB7MA1nOTgva+qiR/hhcQNCMnBt4pcAJv+o8YjoA1SzlNE95NonT0h4cuyLvGQQSr8IIWqlt/2MmL/YGqEKeEzvDwS07fKCoNoTrHg+Bp6rZO5yCxJDba/ct+GrV+j7nYKNcelCpzDqWEm5uHXj5cO2oyBIDwEHK/qtsgDs5SWDNpg9YywpAV49cckgH3aNaee9ql+Jas+QtMTKO47nNFHP6LADhzpIZD4jx4dFbFAx4HF7b5HGkTCdGO9UXhGsU1
 TVayYCyZ
 DhZDtukDO1pjCQ7D4Vgc8dDQ6nKpt/7UhVAUNFQ+dpeDk5nhnqEODQND5JZhk1jObtC1zcRRJQj7AvWx8l8I+ygL3UFZLNAt1dlfzhqQSMa5DF/oz3ivHsEmmmERDAQHVNkdjJWCW7FfhYHnrVUu+Yk0nOKx+xQjNwUFtaygIBjP61xfkbfwZml7sAsIvT4IXhtMMUbohqohYzZWS+YGK/yyapmpc3SJwRToXB/HLi2Dr+Ju39BpTHO6iGaWQzn1+CLneeYeg/cEbGRsC5VSAMlCrpNSv10nmPBiVPFbfdnABh5FbNBffE3/u22cuIm5hyReubKKukWjED2S32RWthWnI8PZCG1hofl0n9Whu/8mD9egsjqHuzOo30dnyS5I2h6AAkt2gUMhe71KM70fNaniQoWY8jlLIBlpgCw1/KCIK2ksXvTfAK1MUfJFXAyZGt+j2EGHKgJT4btHPCQ+GiuIQBiwJDxXzOvt7dIRv4R//oqzxTKlosmo5FjeADVG4tQQdadsmw8qFMqhVPolFBCfvp8VluXI5emP+LMxpfs/CnQCjsr9g6LPAVSdkMGGIo48dShwgYD2Lzkr0Z+GMFpgQFUiWGRBs55Zdhds5rQBQT8QPL5GOfjCVCHbcrJn/qZOT+jtXLR4Kk4AZLrIv7NU9H6fX0fIwShd8CXIQBJ4oRxGaDNw5KcQxQaX5XuHPmmLmORKV9bnkePZhsjf3lIfGenYcouxSjwpe4c9HquZqy1KHRurU83eiP8XEjMr0Db1TgxWU4p7VRJf5iGe4kGHPMwRB9Lx87M8SaOyIAWRf/+sAy/wQ0s5Ik9P5fxLETSX0KesCH8I2sqNai0jouTbnier2XbSa2YpHku4zaf2ZxX4S9JwLb0in1ZdCaa6jUwheg2xuvwP4j/5Vs8IJc4Vfl0qR/TyrkstB7ZIrBs3QPrQSsQIBrH3Uw34EurXMotWVjGCUdHqjBlWAYwPG9CJs/BO6
 EpsU6nL9
 4I1Hw+uk5+qrMuaWma5ZD9bLrAWZTB66gQ558hsYu2hrVsRwMKJYsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The main mm-stable -> mainline merge for 6.18-rc1
(https://lkml.kernel.org/r/20251001190218.f33f695b869696c2df9e841d@linux-foundation.org):


mm.git review status for ce4be9e4307c5a60701ff6e0cafa74caffdc54ce..1367da7eb875d01102d2ed18654b24d261ff5393

Everything:

Total patches:       372
Reviews/patch:       2.08
Reviewed rate:       83%

Excluding DAMON:

Total patches:       333
Reviews/patch:       2.24
Reviewed rate:       85%

Excluding DAMON and zram:

Total patches:       332
Reviews/patch:       2.24
Reviewed rate:       85%



Unreviewed patches by author:


Andrew Morton <akpm@linux-foundation.org>
    "include/linux/pgtable.h: convert arch_enter_lazy_mmu_mode() and friends to static inlines"

Alexandre Ghiti <alexghiti@rivosinc.com>
    "riscv: use an atomic xchg in pudp_huge_get_and_clear()"
        Link: https://lkml.kernel.org/r/20250814-dev-alex-thp_pud_xchg-v1-1-b4704dfae206@rivosinc.com

ally heev <allyheev@gmail.com>
    "kselftest: mm: fix typos in test_vmalloc.sh"
        Link: https://lkml.kernel.org/r/20250823170208.184149-1-allyheev@gmail.com

Baolin Wang <baolin.wang@linux.alibaba.com>
    "mm: shmem: use 'folio' for shmem_partial_swap_usage()"
        Link: https://lkml.kernel.org/r/a2d39608d99cba1130cacd9cffbafc6949193c08.1756200587.git.baolin.wang@linux.alibaba.com
    "mm: shmem: drop the unnecessary folio_nr_pages()"
        Link: https://lkml.kernel.org/r/67c80182ebd949e3894908e01e224697c143aabb.1756200587.git.baolin.wang@linux.alibaba.com
    "mm: shmem: fix the strategy for the tmpfs 'huge=' options"
        Link: https://lkml.kernel.org/r/10e7ac6cebe6535c137c064d5c5a235643eebb4a.1756888965.git.baolin.wang@linux.alibaba.com
        Link: https://lore.kernel.org/lkml/0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com/ [1]

Charan Teja Kalla <charan.kalla@oss.qualcomm.com>
    "mm: swap: check for stable address space before operating on the VMA"
        Link: https://lkml.kernel.org/r/20250924181138.1762750-1-charan.kalla@oss.qualcomm.com
        Link: https://lore.kernel.org/all/20250815191031.3769540-1-Liam.Howlett@oracle.com/ [1]

Chi Zhiling <chizhiling@kylinos.cn>
    "mm/filemap: do not use is_partially_uptodate for entire folio"
        Link: https://lkml.kernel.org/r/20250728083952.75518-1-chizhiling@163.com
        Link: https://lkml.kernel.org/r/20250728083952.75518-2-chizhiling@163.com
    "mm/filemap: skip non-uptodate folio if there are available folios"
        Link: https://lore.kernel.org/linux-fsdevel/aIDy076Sxt544qja@casper.infradead.org/
        Link: https://lkml.kernel.org/r/20250728083952.75518-3-chizhiling@163.com

Chris Li <chrisl@kernel.org>
    "docs/mm: add document for swap table"
        Link: https://lkml.kernel.org/r/CACePvbXjaUyzB_9RSSSgR6BNvz+L9anvn0vcNf_J0jD7-4Yy6Q@mail.gmail.com
        Link: https://lkml.kernel.org/r/20250916160100.31545-1-ryncsn@gmail.com
        Link: https://lore.kernel.org/linux-mm/20250514201729.48420-1-ryncsn@gmail.com/ [3]
        Link: https://lkml.kernel.org/r/20250916160100.31545-2-ryncsn@gmail.com
        Link: https://lore.kernel.org/CAMgjq7BvQ0ZXvyLGp2YP96+i+6COCBBJCYmjXHGBnfisCAb8VA@mail.gmail.com [1]
        Link: https://github.com/ryncsn/linux/tree/kasong/devel/swap-table [2]

Chunyu Hu <chuhu@redhat.com>
    "selftests/mm: alloc hugepages in va_high_addr_switch test"
        Link: https://lkml.kernel.org/r/20250912013711.3002969-3-chuhu@redhat.com

David Hildenbrand <david@kernel.org>
    "mips: mm: convert __flush_dcache_pages() to __flush_dcache_folio_pages()"
        Link: https://lkml.kernel.org/r/20250901150359.867252-22-david@redhat.com
    "selftests/mm: gup_tests: option to GUP all pages in a single call"
        Link: https://lkml.kernel.org/r/20250910093051.1693097-1-david@redhat.com

Dev Jain <dev.jain@arm.com>
    "selftests/mm/uffd-stress: make test operate on less hugetlb memory"
        Link: https://lkml.kernel.org/r/20250909061531.57272-1-dev.jain@arm.com
        Link: https://lkml.kernel.org/r/20250909061531.57272-2-dev.jain@arm.com
    "selftests/mm/uffd-stress: stricten constraint on free hugepages needed before the test"
        Link: https://lkml.kernel.org/r/20250909061531.57272-3-dev.jain@arm.com

Chanwon Park <flyinrm@gmail.com>
    "mm: re-enable kswapd when memory pressure subsides or demotion is toggled"
        Link: https://lkml.kernel.org/r/aL6qGi69jWXfPc4D@pcw-MS-7D22

Francois Dugast <francois.dugast@intel.com>
    "mm/hmm: populate PFNs from PMD swap entry"
        Link: https://lkml.kernel.org/r/20250908091052.612303-1-francois.dugast@intel.com

gaoxiang17 <gaoxiang17@xiaomi.com>
    "mm/cma: add 'available count' and 'total count' to trace_cma_alloc_start"
        Link: https://lkml.kernel.org/r/8a79284879c529f467478552825154b018076e95.1755729178.git.gaoxiang17@xiaomi.com

Christoph Hellwig <hch@lst.de>
    "ntfs3: stop using write_cache_pages"
        Link: https://lkml.kernel.org/r/20250818061017.1526853-1-hch@lst.de
        Link: https://lkml.kernel.org/r/20250818061017.1526853-2-hch@lst.de
    "bcachefs: stop using write_cache_pages"
        Link: https://lkml.kernel.org/r/20250818061017.1526853-3-hch@lst.de

Jan Kara <jack@suse.cz>
    "readahead: add trace points"
        Link: https://lkml.kernel.org/r/20250909145849.5090-2-jack@suse.cz
        Link: https://lkml.kernel.org/r/20250908145533.31528-2-jack@suse.cz

Hao Jia <jiahao1@lixiang.com>
    "mm/mglru: update MG-LRU proactive reclaim statistics only to memcg"
        Link: https://lkml.kernel.org/r/20250717082845.34673-1-jiahao.kernel@gmail.com

Joey Pabalinas <joeypabalinas@gmail.com>
    "mm/memfd: remove redundant casts"
        Link: https://lkml.kernel.org/r/efbbe6093b64a5b19f974871d5262d6e75dff2c0.1756639225.git.joeypabalinas@gmail.com

Deepanshu Kartikey <kartikey406@gmail.com>
    "hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list"
        Link: https://lkml.kernel.org/r/20250926033255.10930-1-kartikey406@gmail.com

Kiryl Shutsemau <kas@kernel.org>
    "mm/filemap: map entire large folio faultaround"
        Link: https://lkml.kernel.org/r/20250923110711.690639-6-kirill@shutemov.name

Kairui Song <kasong@tencent.com>
    "mm/mincore: use a helper for checking the swap cache"
        Link: https://lkml.kernel.org/r/20250811172018.48901-3-ryncsn@gmail.com
    "mm/page-writeback: drop usage of folio_index"
        Link: https://lkml.kernel.org/r/20250825163721.17734-1-ryncsn@gmail.com

Miaohe Lin <linmiaohe@huawei.com>
    "Revert "hugetlb: make hugetlb depends on SYSFS or SYSCTL""
        Link: https://lkml.kernel.org/r/20250826030955.2898709-1-linmiaohe@huawei.com
        Link: https://lore.kernel.org/all/5c99458f-4a91-485f-8a35-3618a992e2e4@csgroup.eu/ [1]
    "mm/hwpoison: decouple hwpoison_filter from mm/memory-failure.c"
        Link: https://lkml.kernel.org/r/20250904062258.3336092-1-linmiaohe@huawei.com

Li Zhe <lizhe.67@bytedance.com>
    "hugetlb: increase number of reserving hugepages via cmdline"
        Link: https://lkml.kernel.org/r/20250919092353.41671-1-lizhe.67@bytedance.com

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    "mm: specify separate file and vm_file params in vm_area_desc"
        Link: https://lkml.kernel.org/r/cover.1756920635.git.lorenzo.stoakes@oracle.com
        Link: https://lkml.kernel.org/r/3fa15a861bb7419f033d22970598aa61850ea267.1756920635.git.lorenzo.stoakes@oracle.com
    "mm/oom_kill.c: fix inverted check"
        Link: https://lkml.kernel.org/r/3b7f0faf-4dbc-4d67-8a71-752fbcdf0906@lucifer.local

Manish Kumar <manish1588@gmail.com>
    "mm/memory_hotplug: fix typo 'esecially' -> 'especially'"
        Link: https://lkml.kernel.org/r/20250918174528.90879-1-manish1588@gmail.com

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    "scripts/decode_stacktrace.sh: symbol: preserve alignment"
        Link: https://lkml.kernel.org/r/20250908-decode_strace_indent-v1-2-28e5e4758080@kernel.org
    "scripts/decode_stacktrace.sh: code: preserve alignment"
        Link: https://lkml.kernel.org/r/20250908-decode_strace_indent-v1-3-28e5e4758080@kernel.org

Pratyush Yadav <pratyush@kernel.org>
    "kho: make sure page being restored is actually from KHO"
        Link: https://lkml.kernel.org/r/20250917125725.665-2-pratyush@kernel.org

Wei Yang <richard.weiyang@gmail.com>
    "selftests/mm: put general ksm operation into vm_util"
        Link: https://lkml.kernel.org/r/20250819080047.10063-1-richard.weiyang@gmail.com
        Link: https://lkml.kernel.org/r/20250819080047.10063-2-richard.weiyang@gmail.com
    "selftests/mm: test that rmap behaves as expected"
        Link: https://lkml.kernel.org/r/20250819080047.10063-3-richard.weiyang@gmail.com
    "mm/khugepaged: remove definition of struct khugepaged_mm_slot"
        Link: https://lkml.kernel.org/r/20250922002834.vz6ntj36e75ehkyp@master
        Link: https://lkml.kernel.org/r/20250919071244.17020-3-richard.weiyang@gmail.com

Qianfeng Rong <rongqianfeng@vivo.com>
    "xarray: remove redundant __GFP_NOWARN"
        Link: https://lkml.kernel.org/r/20250804130018.484321-1-rongqianfeng@vivo.com

Mike Rapoport (Microsoft) <rppt@kernel.org>
    "selftest/kho: update generation of initrd"
        Link: https://lkml.kernel.org/r/20250811082510.4154080-4-rppt@kernel.org

Sergey Senozhatsky <senozhatsky@chromium.org>
    "zram: protect recomp_algorithm_show() with ->init_lock"
        Link: https://lkml.kernel.org/r/20250805101946.1774112-1-senozhatsky@chromium.org

SeongJae Park <sj@kernel.org>
    "mm/damon/core: set effective quota on first charge window"
        Link: https://lkml.kernel.org/r/20250916032339.115817-3-sj@kernel.org
    "Docs/admin-guide/mm/damon/start: add --target_pid to DAMOS example command"
        Link: https://lkml.kernel.org/r/20250916032339.115817-5-sj@kernel.org
        Link: https://github.com/damonitor/damo/pull/32 [2]
    "MAINTAINERS: rename DAMON section"
        Link: https://lkml.kernel.org/r/20250916032339.115817-6-sj@kernel.org
    "mm/damon/core: implement damon_initialized() function"
        Link: https://lkml.kernel.org/r/20250916033511.116366-2-sj@kernel.org
        Link: https://lkml.kernel.org/r/20250916033511.116366-2-sj@kernel.org
        Link: https://lore.kernel.org/20250909022238.2989-1-sj@kernel.org [1]
    "mm/damon/stat: use damon_initialized()"
        Link: https://lkml.kernel.org/r/20250916033511.116366-3-sj@kernel.org
    "mm/damon/reclaim: use damon_initialized()"
        Link: https://lkml.kernel.org/r/20250916033511.116366-4-sj@kernel.org
    "mm/damon/lru_sort: use damon_initialized()"
        Link: https://lkml.kernel.org/r/20250916033511.116366-5-sj@kernel.org
    "samples/damon/wsse: use damon_initialized()"
        Link: https://lkml.kernel.org/r/20250916033511.116366-6-sj@kernel.org
    "samples/damon/prcl: use damon_initialized()"
        Link: https://lkml.kernel.org/r/20250916033511.116366-7-sj@kernel.org
    "samples/damon/mtier: use damon_initialized()"
        Link: https://lkml.kernel.org/r/20250916033511.116366-8-sj@kernel.org
    "mm/damon/stat: expose the current tuned aggregation interval"
        Link: https://lkml.kernel.org/r/20250916183127.65708-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20250916183127.65708-2-sj@kernel.org
    "mm/damon/stat: expose negative idle time"
        Link: https://lkml.kernel.org/r/20250916183127.65708-3-sj@kernel.org
    "mm/damon/sysfs: set damon_ctx->min_sz_region only for paddr use case"
        Link: https://lkml.kernel.org/r/20250917160041.53187-1-sj@kernel.org

Sumanth Korikkar <sumanthk@linux.ibm.com>
    "resource: improve child resource handling in release_mem_region_adjustable()"
        Link: https://lkml.kernel.org/r/20250912123021.3219980-1-sumanthk@linux.ibm.com

Uladzislau Rezki (Sony) <urezki@gmail.com>
    "mm/vmalloc: move resched point into alloc_vmap_area()"
        Link: https://lkml.kernel.org/r/20250917185906.1595454-1-urezki@gmail.com

Wander Lairson Costa <wander@redhat.com>
    "kmem/tracing: add kmem name to kmem_cache_alloc tracepoint"
        Link: https://lkml.kernel.org/r/20250825125927.59816-1-wander@redhat.com

Matthew Wilcox (Oracle) <willy@infradead.org>
    "mm: add folio_is_pci_p2pdma()"
        Link: https://lkml.kernel.org/r/20250805172307.1302730-12-willy@infradead.org
    "mm: remove mlock_count from struct page"
        Link: https://lkml.kernel.org/r/20250903191041.1630338-1-willy@infradead.org

Zi Yan <ziy@nvidia.com>
    "selftests/mm: add check_after_split_folio_orders() helper"
        Link: https://lkml.kernel.org/r/20250818184622.1521620-5-ziy@nvidia.com
    "selftests/mm: check after-split folio orders in split_huge_page_test"
        Link: https://lkml.kernel.org/r/20250818184622.1521620-6-ziy@nvidia.com





