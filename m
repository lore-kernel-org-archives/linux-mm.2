Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57DB9C9832A
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 23:03:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02DFA6B0088; Fri, 25 Sep 2026 19:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21206B008A; Fri, 25 Sep 2026 19:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE8636B008C; Fri, 25 Sep 2026 19:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A510B6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:03:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C2CD51C34DB
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 23:03:05 +0000 (UTC)
X-FDA: 85253811930.09.1CD6757
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf18.hostedemail.com (Postfix) with ESMTP id 01B441C0007
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 23:03:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pxzfeEGJ;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790377384;
	b=Sqi0pNa3dOztF98Ng/3kq4YRX1yhlpptFxbIqMHLXWcnaQ1W4rvfL3LBzn4oCW5iAEFyx5
	Ow9xLPFeTYQdxn1z4QuzvUjiXU3CldrFW8wEg6W7B8g7ffRjHlwCZwwDc1M4XtsNBupZu/
	QIFIxz0EbhmcEwoDnXHQ8RZAdcdAIQg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pxzfeEGJ;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790377384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PiEVC1BfM3JbJHmz6IrQSpeOS1QFhfgMFnl3j26Htjk=;
	b=HGcJSf6ikE40ic7zxkkAoKna3HKsl4mQc4Pk4bSh1F5/pewcX7n7aQh57Lyy8PzW/vo9tC
	hHIsVaJyaburIZg+joOMOaNywTcyJGzLp2c5SyZMfH59Eesa2qWL3XekkFDrJ513Y3gWqD
	jQYwRB0GYjRAGWWF4IvbkS/XPKkSWBE=
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93910a0cefaso131113485a.2
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790377383; x=1790982183; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PiEVC1BfM3JbJHmz6IrQSpeOS1QFhfgMFnl3j26Htjk=;
        b=pxzfeEGJsfcKOn59Rdp0lHXqpopD6FJGVdSE9+m5Grn7s6Sz2YK+9YZ+urB0VbS/Z2
         ahuLe0xEOF+8ksGcqyQ7ArQDajwSjc76C9NzTqFRJXNXeW33Bk60u8cdHSM1vsgkYSDa
         w8mgPXcQT59mf1ySGyxEJuSUHsun5JYRk+elfzfonDPNJXH2ITEZdfXE86dPmrK0C1/z
         NdSAzSH/1ArFKBIOiQHWJF/RGSxwSr3N+iGoRf3hEd5wSTWp3+R0rfimyZFOxxN2b2IQ
         kuNLHuQDPSPZDymj5faOjjfSthbnEEqrDE0wAiUwyVyBmwxEZ2zkahxOFmJZK18Ox9y7
         zUmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790377383; x=1790982183;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PiEVC1BfM3JbJHmz6IrQSpeOS1QFhfgMFnl3j26Htjk=;
        b=K+gii6H9neHjPoslaJNioTfa3MzrcnuOPS30v64Ch9u7e4Mgj+VRVcAqNyKzdXQU1m
         R1jMUBQY/AEZYBrwi+yIHWwWUVSZzv8YvfTZx7RAEBYqW5ZBvWXNcaniNjwIjMfoOM+Y
         HwPQBMGLhUOV5j3yQwrmFK2W7cUpp3nPKcFVxl677TPIohB9Axe2MtL9rJcI5xgYHYLs
         LhKWYEjcJXVJrkZQy715Bteif3lQoOEHYbejGyPIli9KK8t28DLkAVsc7bnb9yUSDalP
         2NG7cO/A5vaRz1F+VXAK2V4BzO3KETE6HYMP8tn4qq2y0cXwvwzZGEoolDeTld74MRjd
         bkdA==
X-Gm-Message-State: AFuF++mixTqCPyq2b14rOjeBlKbTEFgrbIdH6wUYOqvGmtiFvwR3VGrc
	cZpN/WZhnWSRfuzDtGdPZtzQpLJrX0giTXmfLsF25Mb9iNzJ925d54QL+LayeRhE1FXE2aIFkWK
	BIyvd
X-Gm-Gg: AYBFou2t2dVYxeHRLo7OSGgVyZh+J9JUr7Fd15mZKknOMQIm4N1BIT8C1KYTh9QYSMc
	ZHEQWOYruLFF88tbTyo2qjiwoNS3IU/DOrMSwdd+s1KV4SquuitNmtkS1AoJH4QKrdqPpyCTtr7
	O7CXK813MvYPRTVrKYxxUkPADyuGETs66xgn0sDYbeICERHLZu6BvmMNbou1DoT+P+dlb8S/lSA
	bkZNZ0Nlyryd4at+1T6YRCNSAJZSGFzpJI/Bm8xlxQD8Nm4iBxwOj3YzeQHvpX9lqTEV/uyCX0/
	3LrXUJYMskKhSEj1jNhATBIWVVMJQA/qEbcSYNHEeLbw0DI6hPFT5+helhrc/WVfI62KCio2OiR
	Fux2lW25w8jR3YE3dGyzpKWlqO4NGSnot5ZyDXtKPqQq9uq7bJRvkibwNrVHxkx925NuxLgRvVs
	2q2mLXElF19lldrt0V7b/RDrR6tvBE+ZpN9/4YoBOh4j1ylu4BC121+2r017z61CbpofXzUeVFF
	P8GB390cFsoq4xSsa/LAHpTKyWq9VnSLGoFgOtY8zXbI+ptflAPmcU=
X-Received: by 2002:a05:620a:2614:b0:93a:2bdc:cd57 with SMTP id af79cd13be357-93c43b7f72amr755724385a.2.1790377382584;
        Fri, 25 Sep 2026 16:03:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c4493af29sm290317085a.28.2026.09.25.16.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 16:03:02 -0700 (PDT)
Date: Fri, 25 Sep 2026 19:02:59 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com, arun.george@samsung.com, balbirs@nvidia.com, 
	brendan.jackman@linux.dev, yuzenghui@huawei.com, apopple@nvidia.com, alucerop@amd.com, 
	matthew.brost@intel.com, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, 
	vishal.l.verma@intel.com, dave.jiang@intel.com, alison.schofield@intel.com, 
	osandov@osandov.com, jannh@google.com, pfalcato@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <arb0mV23QmRVDtB3@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
X-Rspamd-Server: rspam06
X-Stat-Signature: httoifn4cb7sii676nuhyuz1axjnh1qn
X-Rspam-User: 
X-Rspamd-Queue-Id: 01B441C0007
X-HE-Tag: 1790377383-860382
X-HE-Meta: U2FsdGVkX19p3Hq8z1Wboa/thuyZcNmjvug1iKHQygX/9nO5lA7gsXtaBNRDQmfzBwU80q/APEjbHdeAUxS+FjM3AO3vskT7Tlpm674S4t4oWpikggHaEVKT7cZLsTYjAdkLsaetkFFsfHgoxZ3nYRxeZ643xG4qjdFeY0Ow41iBiXD99s5UbirqvUAAHlxT3WC4y8onIvAE/0jaXOrFdgx0ik6UQj9Mxc98hl5LAVfxroRRraoRYLaR9+psCEVHnIn0OWsQ8sFGLiGyczIyOceE0IGDKXHCfJ0k6e0soO/EvsqWYdrLvJuH4nkKJgleQu5aEQmZs6rX2Rb9dXYkmxFY0DAfkArCpCADx9T+jTiSwnaLNiba+JkuxmI2sk3ivOsADhRTYdULcgEwaOpaRxI8SIkz55wSkkGHAaVr+1H61AddqsktSGkT6EaCKB4hyfYNNJ0wxHJfI5O5DnCyE7LGc49D7HfptLau8jg75zFhq8K9je+74bYq9oCgyIkk8NblUwtFz/PwHrGDJ/cRKILCGvm86Htcwn08FdVXp7/AQzjwcrcxnJEHR+6jmAOCzfkp+TQD4GDTM2GNze5tBYlgd5ipI+NnU0Gr1S7uH6rCwc8Bdhlmo2/SvxPgatcsM2cKnHtx116Ss5wo2R4/MSvma6WamdygqKyBA0OMhHf6+dCwdQV3iCzg2rDJN5OYOCt2mN2u8r98jxC02HrCPsKdcdRQu71jUrWowMFyJ7G2OIYGDCbY6xQmAcGgf636bjN1kMqIoIHvTAG5JvZzYjGcJ9/D0bPwKyWwfLPyTdkoT5Ewyv1GLzZX3SjzaqGopWTcCjzeLpILCKnMlDS8x4CbYxxsGcwHMzaGTiBsvIZTfctJJl5pVfDofXuZWYiwYquDjTkeASpEqkmMlGCQ8BrhdAMYfHct1soOJQ4fl3ckXMTj2dhQHT9rGkVRmz+EIFePvuCmYerbTbnkr7v
 mkvAovA1
 UOtVforX0RTs91V+DywdvYJ8EIgAvQyL8UEtFYJDKJ0h7i05K5MJ31snOumYzaNQUK2FF4yprIezTKYdWBHz0MrEgXmiRz6yKGx/ELNnrAsheEp0KUFaKZkkHWpY6kVfYPaQLAuxKVASBJmdCRmmZNRx7ztdB8oe8H/VSE+JeizW2fLokaooymp6wRUzC5z9J9qfo4HsaGW+y0FERqibOcmhlmA87hezXPrR5v1/kDlQRn6Lys9/vV62RQpn3h4e+8HzPOYeJYWNTsBY5IF9nImHGn5bxlgeNy1Q/637k11U40esNN1aLHGZM01YgtW53ySvGU8O82lDzxNHI055GBO7j0CnvvCyIeBRkRzrvdc4R9tjyF9/T6U0d4Bvb+6H4zU75o5mVxozqFv4rwTvNOKsshLa2S8N+Nv+Z9JWFTsANSnw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 03:33:54PM -0400, Gregory Price wrote:
> This series introduces the concept of "Private Memory Nodes", which
> are opted into two basic functionalities by default:
>   - page allocation (mm/page_alloc.c)
>   - OOM killing
> 

All, I wanted to preface v6 with an update, I probably won't be sending
it out on-list before LPC (i've been a bit noisey as it is, I'll give
it a rest).


But I would like to give you the highlights for those interested.

The latest working branch can be found here:
https://github.com/gourryinverse/linux/tree/scratch/gourry/managed_nodes/rfc6-nonuma

You will find the following:

- There is no depedency on exported alloc_flags (willy, i found a way),
  but there is a need for `folio_alloc_private()` to explicitly ask
  for the ALLOC_ZONELIST_PRIVATE.

- feature bits have been converted to node_state[] bits

- N_MEMORY_COMMON was added to mean "common memory" - i.e. the existing
  N_MEMORY set.  A private node is now defined as !N_MEMORY_COMMON.

- opt-out sites no longer check for !N_MEMORY_PRIVATE, they instead
  iterate over node_state[N_MEMORY_COMMON].  This is *much* cleaner.

- opt-in sites get to define bits in terms of their own service, e.g.

  /* for each reclaimable node */
  for_each_node_mask_state(..., N_MEMORY_RECLAIM) {
     ...
  }

  Or maybe even:

  for_each_reclaimable_node()    :)


- There are only 2 node features in the base set:

  N_MEMORY_RECLAIM    -  generic reclaim runs on the node
  N_MEMORY_COMPACTION -  compaction will run on the node

  You'll notice there's no userland numa control support, more on this
  in a moment.

  This is all you need to have functional device-private coherent
  memory that uses the page allocator.

  Disabling N_MEMORY_RECLAIM does not necessarily mean you're prevented
  from using vmscan.c and the LRU - it just means we'd need to expose an
  interface for a !N_MEMORY_RECLAIM node to explicitly ask for reclaim
  to operate on it.

  Tiering (Demotion) *to* a node is not supported.  We can probably
  debate whether this should mean tiering *from* a node should be
  supported or not as well.  This is easy to change.


- The working branch also includes a minimal compressed-ram service
  that only supports anonymous memory.

  Supporting file-backed memory (and shmem) is a whole different can
  of worms that deserves its own discussion.

  I will post this as a separate RFC from the base set, but it is
  available to play with on my working branch.


- I ship a basic dax driver for the base series, `anondax` which allows
  existing devices to online a private node with both compaction and
  reclaim support for testing.  This enables this use case:

  fd = open(/dev/my_device, ..., O_DIRECT);
  buf = mmap(fd, ..., MAP_SHARED)
  my_file = open(myfile, ...);
  read(buf, myfile); /* fault directly onto device memory */

  With swap (and no tiering), this gives you a private over-commitable
  node for which aspiring drivers can use to implement their own
  mmu_notifier callback stream to manage device page tables and such.


- The reason mempolicy (and user numa in general) is not supported is a
  critical relationship between the OOM killer and page allocator.

  In trivial scenarios, if a consumer of a private node overshoots and
  causes an OOM - it will be the largest consumer and be chosen as the
  victim.

  If there are many consumers - what actually happens in practice is the
  oom killer attempts to select a victim based on *task* policy... which
  makes every task a candidate.  This leads to, among other things,
  either an OOM storm and/or a full blown panic because a victim cannot
  be located (depending on the constraints).

  I've concluded that as-is, this is not tractable. But also, it is not
  actually needed if the devices provide their own chardev to provide
  a basic wrapper around folio_alloc_private().

  This unfortunately means potential users like guest_memfd are unlikely
  to be able to use the nodes without hard-coding the allocator
  interface, as opposed to a mempolicy.

  I think it's possible instead to *maybe* add N_MEMORY_USER_MIGRATION
  and allow for explicit movement between nodes, but not full blown
  mempolicies.

  The relationship between page_alloc, cpuset, mempolicy, and the oom
  killer is just too tight to allow allocations without the use of
  __GFP_THISNODE - which the private allocation interface will enforce.


As it stands, the series has been heavily minimized in both line count
and patch number.

The base series is ~22 commits with the scary diffstat below, but many
of the core mm/ patches are similar to the patch below - with nearly
all of the real complexity happening in reclaim and memory hotplug.

despite the branch name, I intend to drop RFC from here-on, everything
else required for the base series is in mm-new.


See you at LPC
~Gregory

-------

diff --git a/mm/migrate.c b/mm/migrate.c
index 7bdcdb57652f8..cd61566b44fa1 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2266,7 +2266,7 @@ static int __add_folio_for_migration(struct folio *folio, int node,
        if (is_zero_folio(folio) || is_huge_zero_folio(folio))
                return -EFAULT;

-       if (folio_is_zone_device(folio))
+       if (!folio_is_common_memory(folio))
                return -ENOENT;

        if (folio_nid(folio) == node)
@@ -2390,7 +2390,7 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
                err = -ENODEV;
                if (node < 0 || node >= MAX_NUMNODES)
                        goto out_flush;
-               if (!node_state(node, N_MEMORY))
+               if (!node_state(node, N_MEMORY_COMMON))
                        goto out_flush;

                err = -EACCES;
@@ -2475,7 +2475,7 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
                if (folio) {
                        if (is_zero_folio(folio) || is_huge_zero_folio(folio))
                                err = -EFAULT;
-                       else if (folio_is_zone_device(folio))
+                       else if (!folio_is_common_memory(folio))
                                err = -ENOENT;
                        else
                                err = folio_nid(folio);


 Documentation/ABI/stable/sysfs-devices-node |  21 +++++++++++++++++
 Documentation/admin-guide/cgroup-v2.rst     |   7 ++++++
 Documentation/mm/physical_memory.rst        |  15 ++++++++++++-
 drivers/base/node.c                         |  67 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/dax/kmem.c                          |   2 +-
 include/linux/gfp.h                         |   6 +++++
 include/linux/memory_hotplug.h              |   2 +-
 include/linux/mmzone.h                      |  45 +++++++++++++++++++++++++++++++++++++
 include/linux/node.h                        |  12 ++++++++++
 include/linux/nodemask.h                    |  53 ++++++++++++++++++++++++++++++++++++++++++-
 kernel/cgroup/cpuset.c                      |  39 ++++++++++++++++++++++++++------
 kernel/sched/fair.c                         |   6 ++---
 mm/compaction.c                             |  21 +++++++++++------
 mm/damon/ops-common.c                       |  15 ++++++++-----
 mm/damon/vaddr.c                            |  20 +++++++++++++----
 mm/huge_memory.c                            |   2 +-
 mm/internal.h                               |  22 ++++++++++++++++++
 mm/khugepaged.c                             |   9 ++++++--
 mm/ksm.c                                    |   8 ++++---
 mm/madvise.c                                |   6 ++---
 mm/memory-tiers.c                           |  25 +++++++++++----------
 mm/memory_hotplug.c                         | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------
 mm/mempolicy.c                              |  51 +++++++++++++++++++++++++-----------------
 mm/migrate.c                                |   6 ++---
 mm/mm_init.c                                |  22 +++++++++---------
 mm/page_alloc.c                             | 115 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------
 mm/page_alloc.h                             |   5 +++++
 mm/vmscan.c                                 |  31 +++++++++++++++-----------
 28 files changed, 585 insertions(+), 157 deletions(-)

