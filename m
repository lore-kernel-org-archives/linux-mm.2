Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AF1BC5DF81
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 00:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 196866B00A0; Thu, 20 Aug 2026 20:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F90C6B00A1; Thu, 20 Aug 2026 20:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29736B00A2; Thu, 20 Aug 2026 20:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA14C6B00A0
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:58:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38F7A1602E6
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 00:58:01 +0000 (UTC)
X-FDA: 85123464762.12.1112A36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 875D040008
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 00:57:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=glQuFr0r;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787273879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ObRKkCAoD2p4iL57DuvF+TiV2Q0N0ZNrXB+qHqHujtI=;
	b=RPsqwfn4XIhno7HkcwvUZdxHmOPJon14frTmh1qrWJpJCovtad2fzmCqAgyIVljtKTddHj
	/RR/yg8ARFGswloIhy7fAOk2NNAQRg8+pXdMQjp/7Pi8RJrpgj2TFZaKG/ze5q1FA/FfLN
	MNWbAGrcKyZrH+VV/5NheM7XNcSEW7U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=glQuFr0r;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787273879;
	b=ivQm5R6EEuMrWituG0DGlbrCO8E/8BgKPVsOeZydfbhTWt0nO9kwAECorItx1wTJQ19Mwo
	FnpZ2jns6gPYXM5DKM6hMmg0lq575IkL+VDnOVXGg6T6Tv/1Z8K+e5EnRLHlqahE/MwVHC
	UCDfSIoQ+inbnlfI+8jbiIbC+4R/ECM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 23C1B43358;
	Fri, 21 Aug 2026 00:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA50B1F000E9;
	Fri, 21 Aug 2026 00:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787273878;
	bh=ObRKkCAoD2p4iL57DuvF+TiV2Q0N0ZNrXB+qHqHujtI=;
	h=Date:From:To:Subject;
	b=glQuFr0rcPkTOGS/GAkD0OHBHovgSmLWaQTJOpDxLUghoMzdIpoVY4WfioehIdvvv
	 qmxEj30PGJMkDceYg/v0hxmGd0TWvbcUZg2+s5PrlV5iHIZTg65y+P9fI5wZl5iZPR
	 YJKf5+an3Fc4ba7D09YZvuFDDBgkWRDoRK/ary2M=
Date: Thu, 20 Aug 2026 17:57:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Subject: mm.git review status at 7.2
Message-Id: <20260820175756.92d666dbf36bdb6f13f1e7eb@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 875D040008
X-Rspamd-Server: rspam07
X-Stat-Signature: o9u9f36b49cyr35z6zu4168o7tdchbwh
X-HE-Tag: 1787273879-625337
X-HE-Meta: U2FsdGVkX1+R7TS1cKPrYRo/Mjt71uZmPWuhe8VR7/rZEaQ/nyKC3mv4gFAnHtothQCo3axWUyMjScFCYCpD0afbDX3OgPp3fAR3caaL3laiW/Ir5Wwxd/sTZsaeQNnt6gtStcFvpmElJYzfCtzDuvk+red7LogFDy83ZguG25NXNrjGc/dleaGnm2XebZQS9P45sWaDxUBBQ/6NiPjDHvntb855jKwkIj1t7VUPNvR5c1rr+Ty/Pqv09opym+VWuRd2zuVqtT0aUP0zno8DRsMw/+Ud1wwJXNmyTRQh5ZNvuXho9ntXa9eUrYg1T6yE5TjovtJnz0CWX4IrnLyqZJQJkaYCdD32dZmAT16lAcEFbuUtljxSUN/FHyWsTW+F340va3E3eboFDVk2uBDDQhe3OWi604MTEQXTfFECwHpGaQXaogdhxMjHX2tN3g99knkve1QsuEWlc+GIM+kzUx17+l3qfujKdWBMh+DtoVOXw9QRqd9CpcTWr8aGkqEloVpfELk28cEtWvT0mDt4YvK0qAaKwSOpNgDOXrb3G0zMPqzQykaHLgBazUNjDpUQlS8keIDXcIkCig53iCFy+l08M+XBe6OOqp63pCaUYAkwK+qEuFZvRKswx18NEh2i6USlnc/QQkI3cSchK5sbsYG1nJPdX1Z5090dHftGNFfJcyPjNzyLhqqkoEgc9NK3bAQk9vjzpy5yTnTbvbsm2NW+I1BLQ0jNXO5SaZTpdca5Hnqb74GSZHlq3ZfG5DJ78MfSaRXLHCD0/oqzMnmTfgEfuydtqAXEJD6HYrgEsKBcU9y0gAbAF/chI0EWyCBeI1p5JZmfF4AZ+e8dCtFtGbobN/FtyzDWz9FAbwmEAoKqVybJtgUC0PdfwTIvFHpnU99TiTEIl7xP4H2eMUY1Y3LW+1gpNOlvS7yHI4trZgISjpwGz9vBOjBebA8THAUsKRtpUX4NSt/+mwS9LkR
 nc07hui+
 TybwqVxWTDFXHhXzIm7SC2s5Mf76zVy2Wj/TdWyunSnWEC9380N+4KOLPDt2epMtwqg2d0fWBMvVB8W2wVKr9OSJjuwQA24Vbkq5seBUwTtXCYHZm9b+PSFd6+wyHRtRJrOUr1wxLrGcxGUnkNdQWUDF08ukPf5zhyRG4ZySHi5lw/f5a/toak8K0WwS7wS/xB0C6X9mZRyVtbwHnLsHHObrqPfK7DqjUp1n48XxFuEDIYitaU6AbhllFDrC2kfRd2jNXIc1BNyMDwr6YU5+IQ2kPHpjTDx8TA9DrLsb/K8MiIh7tt6sAAK1R+hxgfjhlHa4tvE2FVqZwWZUihmXwC7i+U/RHB4PdfKHdsvffmZ7ihfuoG9NSPDxKhUJL/gqC/Qf3/8grmQawPsIKtElDF3dcxLcuxfTPRqtwPPXS1M9MZ9ZsX8yc9dVL114VmQbjarOP0B+rlbcDmpRIuXY+g2Aa0bZ0Eh37la0GjaQB6KgB4IahHjtE57cnvcZ7/ZaCYv3ohKWhnd1wu7SL28CbdijKroHHaxUw7rvEKXSAsoht/HCaysqjkm67b/sJH312qbQN3XEKJoZWBehy1gjlwTWSk5Sw6vwJ59dc11EdVXOB5iKFptLJ64Bb/ELXlp/kA67boXHSDoNeRJt0zzkxgPeGq74k4+iO9VSzJ7Sl4T5no8UsYPzt5hkrarU2AiXZPbg588pgX+6P0So6dlyYB8LBNGCotP12yI2xiUFJ9TH+Mzy3FoIDRmc5hjslxeUP48ddf/fgyXp4vM148gAhaA1xHkbV2cZORz8sHobqIW9kzvoA8dUtmMM3xXpcmBCC6D+79NTMGDNdpTm3gROA3EGaqTBGQ1sJ8D/ABTUcoMX27+IwPGrnJ87H2kpGFfKHE5GXnfxC81e5jGmWWu2uwA0uIBRv/92tgn/XrjJrX/lABNTtyGu/owYi25F8CnahvNCW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


~500 patches are in Linus's inbox.

This is the review status for next week's batch.  These are presently
in mm-unstable so I can still paste in any ack/review tags.  I expect
to move these patches into mm-stable on Monday.


Two patches stand out to my eye:

	mm/hugetlb: fix missing migratable flag on same-node hugetlb migration
	mm/migrate_device: avoid out-of-bounds writes for compound folios

I'll chase those down in the relevant threads.


Please scan this list and decide if there's anything you'd like to check
out.



mm.git review status for mm-stable..mm-unstable

Everything:

Total patches:       206
Reviews/patch:       1.69
Reviewed rate:       77%

Excluding DAMON:

Total patches:       200
Reviews/patch:       1.74
Reviewed rate:       79%

Excluding DAMON and selftests:

Total patches:       177
Reviews/patch:       1.70
Reviewed rate:       77%

Excluding DAMON, selftests and maple_tree:

Total patches:       156
Reviews/patch:       1.88
Reviewed rate:       85%



Unreviewed patches by author:


Andrew Morton <akpm@linux-foundation.org> (3 total)
    "mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix"
        Link: https://lore.kernel.org/aob1goSSPH6sTN9y@gremlin
    "selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix"
    "mm/hmm.c:hmm_do_fault(): suppress sparse warning"

Catalin Marinas <catalin.marinas@arm.com> (1 total)
    "mm: kmemleak: confirm suspected leaks with a second scan"
        Link: https://lore.kernel.org/20260713-catalin_pto-v1-0-5b93b1131089@debian.org
        Link: https://lore.kernel.org/20260713-catalin_pto-v1-1-5b93b1131089@debian.org

Danila Tikhonov <danila@mainlining.org> (1 total)
    "mailmap: map old addresses to Danila Tikhonov"
        Link: https://lore.kernel.org/20260801153333.296218-1-danila@mainlining.org

David Hildenbrand (Arm) <david@kernel.org> (2 total)
    "mm: standardize printing for pgtable entries"
        Link: https://lore.kernel.org/20260709044334.1741263-1-anshuman.khandual@arm.com
    "mm/gup_test: keep longterm pin state per file"
        Link: https://lore.kernel.org/20260810-gup_test_data-v1-1-fb1d41be5bb4@kernel.org

Guodong Xu <docular.xu@gmail.com> (1 total)
    "mailmap: add entries for Guodong Xu"
        Link: https://lore.kernel.org/20260807-b4-mailmap-guodong-xu-v2-1-f7c71bc6bd9f@gmail.com

Christoph Hellwig <hch@lst.de> (2 total)
    "mm/swap: also use struct swap_iocb for block I/O"
        Link: https://lore.kernel.org/20260713093350.2154226-4-hch@lst.de
    "mm/swap: remove SWP_FS_OPS"
        Link: https://lore.kernel.org/20260713093350.2154226-7-hch@lst.de

Song Hu <husong@kylinos.cn> (1 total)
    "Docs/mm: fix outdated "radix tree" in page_migration"
        Link: https://lore.kernel.org/20260812075739.325441-1-husong@kylinos.cn

Karl Mehltretter <kmehltretter@gmail.com> (1 total)
    "selftests/proc: make proc-maps-race work with READ_IMPLIES_EXEC"
        Link: https://lore.kernel.org/20260808200312.6326-1-kmehltretter@gmail.com

Liam R. Howlett (Oracle) <liam@infradead.org> (17 total)
    "maple_tree: add rcu locking check when LOCKDEP is enabled"
        Link: https://lore.kernel.org/20260630190843.3563858-1-liam@infradead.org
        Link: https://lore.kernel.org/20260630190843.3563858-2-liam@infradead.org
    "locking/lockdep: add sequence counter to held_lock"
        Link: https://lore.kernel.org/20260630190843.3563858-3-liam@infradead.org
        Link: https://lore.kernel.org/all/h3tpnj5kzcrxms5picmimtkpg4aypcpip5wbd6bt2rpdj5k7eb@nhtzs3lefrkq/
    "maple_tree: add write lock checking with lockdep sequence numbers"
        Link: https://lore.kernel.org/20260630190843.3563858-4-liam@infradead.org
    "maple_tree-stop-flooding-logs-when-debug_locks-is-set-to-zero-fix"
        Link: https://lore.kernel.org/fo5r2xl3fql6gyvjasfvfu4ftugjti2vxg7zskdw7hjeo3xvqm@kk66qmsf762s
    "maple_tree: drop dead code from mas_extend_spanning_null()"
        Link: https://lore.kernel.org/20260630190843.3563858-6-liam@infradead.org
    "maple_tree: drop MAPLE_ALLOC_SLOTS"
        Link: https://lore.kernel.org/20260630190843.3563858-7-liam@infradead.org
    "maple_tree: clarify comments on mas_nomem()"
        Link: https://lore.kernel.org/20260630190843.3563858-8-liam@infradead.org
    "maple_tree: use prefetched value in mas_wr_store_type()"
        Link: https://lore.kernel.org/20260630190843.3563858-9-liam@infradead.org
    "maple_tree: optimise mas_wr_node_store() when not in rcu mode"
        Link: https://lore.kernel.org/20260630190843.3563858-10-liam@infradead.org
    "maple_tree: micro optimisation of mas_wr_store_type()"
        Link: https://lore.kernel.org/20260630190843.3563858-11-liam@infradead.org
    "maple_tree: add bulk parent set helper"
        Link: https://lore.kernel.org/20260630190843.3563858-12-liam@infradead.org
    "maple_tree: WARN_ON_ONCE when allocations fail"
        Link: https://lore.kernel.org/20260630190843.3563858-15-liam@infradead.org
    "maple_tree: document erase and allocations better"
        Link: https://lore.kernel.org/all/20260617180419.GA231643@ziepe.ca/
        Link: https://lore.kernel.org/20260630190843.3563858-16-liam@infradead.org
    "maple_tree: change two GFP flags in tests"
        Link: https://lore.kernel.org/all/d9cbb89faa5bdb71d451781d214a51ce8923a83e.camel@perches.com/
        Link: https://lore.kernel.org/20260630190843.3563858-17-liam@infradead.org
    "maple_tree: fix argument name in header"
        Link: https://lore.kernel.org/20260630190843.3563858-18-liam@infradead.org
    "maple_tree: avoid extra gap calculation"
        Link: https://lore.kernel.org/20260630190843.3563858-19-liam@infradead.org
    "maple_tree: add helper mas_make_walkable()"
        Link: https://lore.kernel.org/20260630190843.3563858-20-liam@infradead.org

Qiang Liu <liuqiang@kylinos.cn> (1 total)
    "lib/test_hmm: fix garbage pfn and wrong direction in devmem fault debug"
        Link: https://lore.kernel.org/20260812092856.55296-1-liuqiangneo@163.com

Lorenzo Stoakes (ARM) <ljs@kernel.org> (1 total)
    "mm/huge_memory: separate out CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic"
        Link: https://lore.kernel.org/20260730-fix-refcounted-huge-zero-v2-2-c5d8a41b317f@kernel.org

Wupeng Ma <mawupeng1@huawei.com> (1 total)
    "mm/hugetlb: fix missing migratable flag on same-node hugetlb migration"
        Link: https://lore.kernel.org/20260707110254.3147686-1-mawupeng1@huawei.com

Phillip Lougher <phillip@squashfs.org.uk> (1 total)
    "MAINTAINERS: remove git URL for Squashfs"
        Link: https://lore.kernel.org/20260806181916.617881-1-phillip@squashfs.org.uk

Ramin Moussavi <ramin.moussavi@yacoub.de> (1 total)
    "microblaze: restore the page alignment of swapper_pg_dir"
        Link: https://lore.kernel.org/20260727215823.1422701-1-ramin.moussavi@yacoub.de

Sergey Senozhatsky <senozhatsky@chromium.org> (4 total)
    "zram: set default primary compressor in zram_destroy_comps()"
        Link: https://lore.kernel.org/20260729045745.775973-2-senozhatsky@chromium.org
    "zram: validate deflate params"
        Link: https://lore.kernel.org/20260729045745.775973-3-senozhatsky@chromium.org
        Link: https://sashiko.dev/#/patchset/20260728092935.31139-1-haoqinhuang7@gmail.com
    "Documentation: zram: correct algo parameters configuration documentation"
        Link: https://lore.kernel.org/20260730075158.1339787-1-senozhatsky@chromium.org
    "zram: switch to unsigned long indexing"
        Link: https://lore.kernel.org/20260806031640.536615-1-senozhatsky@chromium.org

Hui Su <sh_def@163.com> (1 total)
    "mm/migrate_device: avoid out-of-bounds writes for compound folios"
        Link: https://lore.kernel.org/20260817120758.669807-3-sh_def@163.com

SJ Park <sj@kernel.org> (5 total)
    "samples/damon/mtier: error out for zero quota goal target values"
        Link: https://lore.kernel.org/20260803134034.15217-1-sj@kernel.org
        Link: https://lore.kernel.org/20260803134034.15217-2-sj@kernel.org
    "mm/damon/lru_sort: error out for >10000 active_mem_bp"
        Link: https://lore.kernel.org/20260803134034.15217-3-sj@kernel.org
    "mm/damon/reclaim: skip damon_call() if ctx has not started"
        Link: https://lore.kernel.org/20260803134646.16640-1-sj@kernel.org
        Link: https://lore.kernel.org/20260803134646.16640-2-sj@kernel.org
    "mm/damon/lru_sort: skip damon_call() if ctx has not started"
        Link: https://lore.kernel.org/20260803134646.16640-3-sj@kernel.org
    "mm/damon: adjust isolated pages stat for DAMOS_MIGRATE_{HOT,COLD}"
        Link: https://lore.kernel.org/20260728140404.94476-1-sj@kernel.org

Hajime Tazaki <thehajime@gmail.com> (1 total)
    "mm: nommu: point to the write iterator upon split_vma"
        Link: https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/mseal/mseal02.c
        Link: https://lore.kernel.org/20260702012546.665383-1-thehajime@gmail.com

Muhammad Usama Anjum <usama.anjum@arm.com> (1 total)
    "selftests/mm: retry migration failures for the full runtime"
        Link: https://lore.kernel.org/20260727095225.372655-6-usama.anjum@arm.com

Zhiling Zou <zhilinz@nebusec.ai> (1 total)
    "mm/page_table_check: skip special zero mappings"
        Link: https://lore.kernel.org/cover.1784717203.git.zhilinz@nebusec.ai
        Link: https://lore.kernel.org/e94478e4fb7912fb7e8ebebed5ce85d00dc9a69d.1784717203.git.zhilinz@nebusec.ai



