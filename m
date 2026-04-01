Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C98661076361
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 04:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED2626B0089; Wed,  1 Apr 2026 00:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81496B008A; Wed,  1 Apr 2026 00:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBE606B0092; Wed,  1 Apr 2026 00:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6A466B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:40:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 75BE41A05ED
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:40:00 +0000 (UTC)
X-FDA: 84608734560.11.A0BFDD7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E68A7180003
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:39:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wzt4JxZl;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775018399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4Xu5UDoEoQVThkSf9xyrh7LejyElGJ/H6CVv/YRoL7o=;
	b=jH1f+n28IagOD3HkBUr81IDmG5PF3x6gv4To4W5uhvkg8zAMh82h3hY5aO+sx4fnojF+WM
	fDMjuhDVQFxIUQ11FL2vxwt3DIDHBWaqJ46IfGAvMFkKpr7/LoeplPynVUyA1T+3Jh4KL3
	m11eZUjm1BNDxWmmAhMF3/0t6yT0l/M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wzt4JxZl;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775018399; a=rsa-sha256;
	cv=none;
	b=zvqqY0AScKzCu4X/Vk5aP2WVCQBfGLCXiIHvPwnhax0QxcP1Di0/70wxpW9QoYSlK0iqBD
	zyfiqXlpPO9nQtuqHq/JXrv3wexYPRjfxiD1OqPon+TNEk4NRolXv1Iu2v59kAKnt/i5od
	tGkVX11ofLYgsMZgZl+xZ8fWpzqsIG4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D3F6600AD;
	Wed,  1 Apr 2026 04:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A601C4CEF7;
	Wed,  1 Apr 2026 04:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775018397;
	bh=SbLMjYDrxJO2kzvnOLYoQMT8kDx45iCj5BMoIr3x1IY=;
	h=Date:From:To:Subject:From;
	b=wzt4JxZlDPaSYVAQTUJ6gVztIyhNOrnrxV4T2PrR244DFa/S6TM6ohPTHeG9ZA1LZ
	 1RwHQR8QpcVXRGscU0MJnl5TpabEX+UZn8qUVHLAj6RvmUH2BP2Sis2s2nF8lCUVLG
	 GrxLIszwI9ZjCZP2oAzVvk93L9xAxncDbFjdzvSI=
Date: Tue, 31 Mar 2026 21:39:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Subject: mm.git review status at 7.0-rc6
Message-Id: <20260331213956.2f3925ff0dd12eabf55b7c37@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E68A7180003
X-Stat-Signature: jarhwcdm5kfesh5ux31ihhasnij8y4eq
X-Rspamd-Server: rspam06
X-HE-Tag: 1775018398-511509
X-HE-Meta: U2FsdGVkX19FO3UYRUQvSZhWAoNONGE5wQVWdXn2pUl3jAew6dM9xUsqXFPwByQRMLzxyjywp5ifdeWlj9yQoCClcIj39iIx3ndchHeWO3oQ5Z65AC84M4D+We43mvq+7/Y5n+xvLu0Urk6ToArYdkqNfHFL9016jsfjh1WmslAv/vjsUD+NsJTrhd3w9EYrZYC+vkIyZf6OfYHkgGor79dlNbQZzNj1fyK33T+tCkXdFtkM3J4rEA0ED3PhUuzljFTkR+pew+/GI+wWOLAiuhfWYbJ3KJl1L8KoSeASc9VUU58/Ru7F8PurrDaq5kVJQ3DlYynDocFa+dwkBZy4c2tZcqCH/VhXUcOA26Sfsvvtt1CJe3Ofeguv1+FK2g435UlRRdTHFj4LwC9lgthUQrniWkQyPcmBz/ikr0p8xQrRhTjTbcV6MPEzJYW/bGDWYjRZaOVfFQn43imvRdVv8z5jyZsF6t8qaVuBd4yCMyAhtbg7IMTZ2+9gU4D61ufSRmck9XoGoi7XD0a3Id/RkPfsz8UPzknW8/9hwFEO504hhaIYY50AN6HW3aw2nopA8lCmqee7SjJ2qh+EcJzj4BVAKAaAWUTw9pDcu2qU9qKJFDlfR10OGVkwSj6bWyzphKoj/q99/ge78MvxTcXgt5dx7LpjtGpfQi+9tSg3YRnjhMPV73fyfo/6wMdujP2k2pLIgIsBjb2UTaMqZQGK/blYKPv/n9sLv5Kp/KFvpdTAfgkPsOzG8hDslsgFsHWS7HfRwPu5QICf+fIOOPPvOt6xfuavDoy8wzC/4icbxjSjw8zBQTXRZgH/mkCz9qkU+pt3PbSFC2sru9qIwI3rMsHSZCz2a3IxJug30204PKqdsmO79LiljwNJGbMBPWZ/yp6doeAFmUSuEy9M089bX8YSRSq1Zqn3OaQcvrpVfeDVMOpfkOlOKB/Xto9SPg7MNsCUuLmZ7R68Khaad3M
 WFxYP2xr
 R66fokbUyUvqXS43JZQq2hW6RmmiS00EFSNGrIdFf/zbFWBUtNRnj1YoAnwxZYSfQ+p+E9AllIacCEUIjtZcGqC3K7OPfMojtfGvd64e93T28P6SpjRZm4Wme+kz/AefE+A6gWmKZ+3w/YKTb4ddNo0EjOZzDEfcGVDLibLCzhB0B6dXsbIuyw89YkrGMUQ2sLTkv32E9ENe6OJXOKhcMcPmGK1RQ1G/gUsf5Tl2axQEJxdRC49BpAPF3xdt76UTFgB1t2xdy7EniL9WjXYcCd04BdtdEbA9iKcy07HZ2uh//guMirsRaOE56YwFtWZNFzu4QAg8zcmR0iNLEBWXep7+k23Fa3mCY2lSj9gKWqKhgtNoX/0uXEQBhZHl6zrO2SAMBp6/++h2XtTU7rWckYehYYmVMTINTtIC8IYNKMUzWTe3UL/K/m8NhYq8tqSwAqUay/Nz2oEomstHZjVA+h47/y7eU393xPGq75ZhxPgEX5roiM6KjwLdLlPe02UcwV55tLzllnl+Glym7ralrdeI7mqgziqUflLfIbsUEDzjB3vaVsDy3ao4SfUkVAq3V007hY/zT2KqsXGY6lcuQKnJw0G4s5lCaXUNaYFOo5eEI7GY1TXSOgyjUR9qU2+vLLLNW0f9902VW9N+ycQA3hNmK1JSC+BaEPEg0UDcJsgr3q5hue5zepMipclZ+oucCjS/C1FKpgiM+GoWNgCEZ3e0XMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


If anyone wishes to be Bcc:ed on these little missives then drop me a
note and I'll add you to my list, no probs.

mm.git's mm-stable branch contains 358 patches and that's a wrap.  This
is the material I intend to send into Linus in the first week of the
merge window, April 14 seems likely.

The mm-unstable branch presently holds 135 patches.  I'll move some
subset of these into mm-stable after Linus has merged batch #1, so
maybe Apr 17.  I'll ask him to pull this material in the second week,
maybe Apr 20.

mm-new presently holds 10 patches, the aim it to keep this "empty" until
we're all merged up.

I'll be spending the merge window getting dragged around Roman ruins
(please save me) while laptopping over the hotel WiFi.  Responsiveness
will be slight.

People, please let's not see an enormous flood of patches the day after
-rc1 is released?  If you have new non-critical patches then it's best
to send them out when they're ready rather than buffering them up. 
They won't be applied to mm.git and they may not get 100% attention but
it's better this way - spread things out, at least give others a view
of what's coming up.

We still have ~38 unreviewed patches in mm-unstable, listed below.  We
have nearly three weeks to get everything nailed down.

Thanks.


mm.git review status for mm-stable..mm-new

Everything:

Total patches:       134
Reviews/patch:       1.52
Reviewed rate:       66%

Excluding DAMON:

Total patches:       125
Reviews/patch:       1.62
Reviewed rate:       70%


Unreviewed patches by author:


Andrew Morton <akpm@linux-foundation.org> (3 total)
    "liveupdate-initialize-incoming-flb-state-before-finish-fix"
    "shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix-fix"
    "selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible-checkpatch-fixes"

Chunyu Hu <chuhu@redhat.com> (2 total)
    "selftests: ksft_exit_fail_perror: support printf style arguments"
        Link: https://lkml.kernel.org/r/20260330151503.670415-5-chuhu@redhat.com
    "selftests/mm/vm_util: robust write_file()"
        Link: https://lkml.kernel.org/r/20260330151503.670415-6-chuhu@redhat.com

David Carlier <devnexen@gmail.com> (3 total)
    "mm/hugetlb: restore reservation on error in hugetlb_mfill_atomic_pte() resubmission path"
        Link: https://lkml.kernel.org/r/20260322052120.14021-1-devnexen@gmail.com
    "mm/page_io: fix PSWPIN undercount for large folios in sio_read_complete()"
        Link: https://lkml.kernel.org/r/20260323231315.240137-1-devnexen@gmail.com
    "mm/userfaultfd: detect VMA replacement after copy retry in mfill_copy_folio_retry()"
        Link: https://lkml.kernel.org/r/20260331134158.622084-1-devnexen@gmail.com

Donet Tom <donettom@linux.ibm.com> (1 total)
    "memory tiering: do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled"
        Link: https://lkml.kernel.org/r/20260323094849.3903-1-donettom@linux.ibm.com

Chenghao Duan <duanchenghao@kylinos.cn> (4 total)
    "mm/memfd: use folio_nr_pages() for shmem inode accounting"
        Link: https://lkml.kernel.org/r/20260326084727.118437-1-duanchenghao@kylinos.cn
        Link: https://lkml.kernel.org/r/20260326084727.118437-2-duanchenghao@kylinos.cn
    "mm/memfd_luo: fix physical address conversion in put_folios cleanup"
        Link: https://lkml.kernel.org/r/20260326084727.118437-6-duanchenghao@kylinos.cn
    "mm/memfd_luo: remove folio from page cache when accounting fails"
        Link: https://lkml.kernel.org/r/20260326084727.118437-7-duanchenghao@kylinos.cn
    "mm/memfd_luo: fix integer overflow in memfd_luo_preserve_folios"
        Link: https://lkml.kernel.org/r/20260326084727.118437-8-duanchenghao@kylinos.cn

Nikita Kalyazin <kalyazin@amazon.com> (3 total)
    "KVM: guest_memfd: implement userfaultfd operations"
        Link: https://lkml.kernel.org/r/20260330101116.1117699-14-rppt@kernel.org
    "KVM: selftests: test userfaultfd minor for guest_memfd"
        Link: https://lkml.kernel.org/r/20260330101116.1117699-15-rppt@kernel.org
    "KVM: selftests: test userfaultfd missing for guest_memfd"
        Link: https://lkml.kernel.org/r/20260330101116.1117699-16-rppt@kernel.org

Breno Leitao <leitao@debian.org> (1 total)
    "kho: fix kho_in_debugfs_init() to handle non-FDT blobs"
        Link: https://lkml.kernel.org/r/20260316-kho-v9-4-ed6dcd951988@debian.org

Jackie Liu <liuyun01@kylinos.cn> (1 total)
    "mm/mempolicy: fix memory leaks in weighted_interleave_auto_store()"
        Link: https://lkml.kernel.org/r/20260401005702.7096-1-liu.yun@linux.dev
        Link: https://sashiko.dev/#/patchset/20260331100740.84906-1-liu.yun@linux.dev

Lorenzo Stoakes (Oracle) <ljs@kernel.org> (2 total)
    "tools/testing/selftests: add merge test for partial msealed range"
        Link: https://lkml.kernel.org/r/1c9c922d-5cb5-4cff-9273-b737cdb57ca1@lucifer.local
        Link: https://lkml.kernel.org/r/20260331073627.50010-1-ljs@kernel.org
    "tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix"
        Link: https://lkml.kernel.org/r/1c9c922d-5cb5-4cff-9273-b737cdb57ca1@lucifer.local

Muchun Song <muchun.song@linux.dev> (1 total)
    "mm/sparse: fix BUILD_BUG_ON check for section map alignment"
        Link: https://lkml.kernel.org/r/20260331113023.2068075-1-songmuchun@bytedance.com

Pasha Tatashin <pasha.tatashin@soleen.com> (6 total)
    "memfd: implement get_id for memfd_luo"
        Link: https://lkml.kernel.org/r/20260326163943.574070-3-pasha.tatashin@soleen.com
    "liveupdate: remove luo_session_quiesce()"
        Link: https://lkml.kernel.org/r/20260327033335.696621-7-pasha.tatashin@soleen.com
    "liveupdate: auto unregister FLBs on file handler unregistration"
        Link: https://lkml.kernel.org/r/20260327033335.696621-8-pasha.tatashin@soleen.com
    "liveupdate: remove liveupdate_test_unregister()"
        Link: https://lkml.kernel.org/r/20260327033335.696621-9-pasha.tatashin@soleen.com
    "liveupdate: make unregister functions return void"
        Link: https://lkml.kernel.org/r/20260327033335.696621-10-pasha.tatashin@soleen.com
    "liveupdate: defer file handler module refcounting to active sessions"
        Link: https://lkml.kernel.org/r/20260327033335.696621-11-pasha.tatashin@soleen.com

Peter Xu <peterx@redhat.com> (1 total)
    "mm: generalize handling of userfaults in __do_fault()"
        Link: https://lkml.kernel.org/r/20260330101116.1117699-13-rppt@kernel.org

Mike Rapoport (Microsoft) <rppt@kernel.org> (4 total)
    "userfaultfd: introduce mfill_get_vma() and mfill_put_vma()"
        Link: https://lkml.kernel.org/r/20260316173829.1126728-1-avagin@google.com
        Link: https://lkml.kernel.org/r/20260330101116.1117699-5-rppt@kernel.org
    "userfaultfd: retry copying with locks dropped in mfill_atomic_pte_copy()"
        Link: https://lkml.kernel.org/r/20260316173829.1126728-1-avagin@google.com
        Link: https://lkml.kernel.org/r/20260306171815.3160826-6-rppt@kernel.org
        Link: https://lkml.kernel.org/r/20260330101116.1117699-6-rppt@kernel.org
    "userfaultfd: introduce vm_uffd_ops"
        Link: https://lkml.kernel.org/r/20260330101116.1117699-8-rppt@kernel.org
    "userfaultfd: mfill_atomic(): remove retry logic"
        Link: https://lkml.kernel.org/r/20260330101116.1117699-12-rppt@kernel.org

SeongJae Park <sj@kernel.org> (8 total)
    "mm/damon/sysfs: dealloc repeat_call_control if damon_call() fails"
        Link: https://lkml.kernel.org/r/20260327003224.55752-1-sj@kernel.org
        Link: https://lore.kernel.org/20260320020630.962-1-sj@kernel.org [1]
    "mm/damon/core: fix damon_call() vs kdamond_fn() exit race"
        Link: https://lkml.kernel.org/r/20260327233319.3528-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20260327233319.3528-2-sj@kernel.org
        Link: https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org [1]
    "mm/damon/core: fix damos_walk() vs kdamond_fn() exit race"
        Link: https://lkml.kernel.org/r/20260327233319.3528-3-sj@kernel.org
        Link: https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org [1]
    "mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp"
        Link: https://lkml.kernel.org/r/20260329043902.46163-2-sj@kernel.org
        Link: https://lore.kernel.org/20260325073034.140353-1-objecting@objecting.org [1]
        Link: https://lore.kernel.org/20260327040924.68553-1-sj@kernel.org [2]
    "mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp"
        Link: https://lkml.kernel.org/r/20260329043902.46163-3-sj@kernel.org
    "mm/damon/core: use time_in_range_open() for damos quota window start"
        Link: https://lkml.kernel.org/r/20260329152306.45796-1-sj@kernel.org
        Link: https://lore.kernel.org/20260324040722.57944-1-sj@kernel.org [1]
    "Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race"
        Link: https://lkml.kernel.org/r/20260329153052.46657-2-sj@kernel.org
        Link: https://lore.kernel.org/20260319161620.189392-3-objecting@objecting.org [1]
        Link: https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org [3]
    "Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race"
        Link: https://lkml.kernel.org/r/20260329153052.46657-3-sj@kernel.org
        Link: https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org [1]

Uladzislau Rezki (Sony) <urezki@gmail.com> (1 total)
    "mm/vmalloc: use dedicated unbound workqueue for vmap purge/drain"
        Link: https://lkml.kernel.org/r/20260330175824.2777270-1-urezki@gmail.com
        Link: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com/

Youngjun Park <youngjun.park@lge.com> (1 total)
    "mm/swap, PM: hibernate: fix swapoff race in uswsusp by pinning swap device"
        Link: https://lkml.kernel.org/r/20260323160822.1409904-1-youngjun.park@lge.com
        Link: https://lkml.kernel.org/r/20260323160822.1409904-2-youngjun.park@lge.com

zenghongling <zenghongling@kylinos.cn> (1 total)
    "mm/percpu-internal.h: optimise pcpu_chunk_struct to save memory"
        Link: https://lkml.kernel.org/r/20260305073043.571691-1-zenghongling@kylinos.cn

Qi Zheng <zhengqi.arch@bytedance.com> (1 total)
    "mm: memcontrol: refactor mod_memcg_state() and mod_memcg_lruvec_state()"
        Link: https://lkml.kernel.org/r/7f8bd3aacec2270b9453428fc8585cca9f10751e.1772711148.git.zhengqi.arch@bytedance.com

teawater <zhuhui@kylinos.cn> (1 total)
    "mm/memcontrol: batch memcg charging in __memcg_slab_post_alloc_hook"
        Link: https://lkml.kernel.org/r/20260320020745.833792-1-hui.zhu@linux.dev



