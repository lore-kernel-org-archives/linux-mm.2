Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF26CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 20:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C0FB6B0005; Wed, 10 Jun 2026 16:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3720B6B0088; Wed, 10 Jun 2026 16:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2617F6B008C; Wed, 10 Jun 2026 16:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17DBF6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:13:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9AFA9A02A1
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:12:59 +0000 (UTC)
X-FDA: 84865101678.27.0882670
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id B4A4820004
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:12:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LHWCYphz;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781122377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/w5IO6RWAJnNghyz7HGZ8KjTibYl6mxc1wTK9gnS8M=;
	b=mnWA6e2CR2zHqmwnllkai9RsmSNMTwgc2Opwn3LVhQ3wnwMyhnBHWfzsQ9KkoBfh2rlRLd
	bgJd0R30MTDdMAyxkLOaBp4tjSabP+jI4NqvLZom3yZyzWwsZoQU2oBDCv/aptQttyEkAc
	cs4PQ8PY+nqaBBMtbavqj/mZ09oU4mM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LHWCYphz;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781122377;
	b=8OK9IDqhh/HoZsnqr4HOkJMd2qixey93npiF5KbF1hkqriniUcJetljcJNRhcpcyhZ5LaW
	CAgwOnGHbCWc+DHGe98vcAj9/tWSILVAwnqCOTrRDBktGZbO2Z1F6WGzuueeEW1QH4XzjL
	n+tV5vp/fm3V7uBFajl4N4Q98ya/BAc=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8ced8f44da0so78490856d6.2
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781122377; x=1781727177; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5/w5IO6RWAJnNghyz7HGZ8KjTibYl6mxc1wTK9gnS8M=;
        b=LHWCYphzce9RU8i85Zxtu0OZ7i11IIN38Ke2LdGgfF0AL9MFOtH+0rxGy1hDXwqdtG
         KQQOb4UA6cafrBFJ9Eay9uNadjag2X6PeOpv7n7pzoL4hyAmCI+iptG//PgqHmWzSPHy
         sknETl1RPQuJMlVTW84kzREyyRbFmwdSjvQKo67+CgYqmP/Dy2Q1pZTszlnYQDbBuWYd
         Qp+Mn42EmuJTzqLhEkE4G93DJez74qQSFZllFUPibosBedIUMFJzdsHAbhvqMWjSmUl1
         ZbfUbiYTNgOxTFVtyKWCUhW9IF8jXEcdeXSrlI7CFWSiaPGDwIamIEFUQZwvC0jW6/Rb
         Gznw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781122377; x=1781727177;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5/w5IO6RWAJnNghyz7HGZ8KjTibYl6mxc1wTK9gnS8M=;
        b=sTq0CGchrqxKaK4JD+vp0sPEOY+JBBu0nxkkKY56l7nHaaAlqpFIvJ9YnwXSvKY/RL
         O2P4QTx28w4W+IE2V3MjpLuwGtRt0tTjwaFtG2uGDRyc4ZAMN8pvp5rmY3xNXsNATyUO
         d45YpjTJGLGjtG8jt32AV12dib9GbKDxqNETYUkC2cqy+fp1r8yKls9Fq8uOOydOyTU8
         2p2obTx2UEDc/7if7MxhXX4TSsnql6txosLFQe7cZ8GV5dyCt1oxliY7oX1F0lKHSMA+
         hYgsKz1WL7aGeI4EgB2Dby7QGib0pPEy6gRbtU0Z0O3ywPoH9rDkoJqZ8X10Kxwi0u5O
         LbCw==
X-Forwarded-Encrypted: i=1; AFNElJ++YtqWqPl6VFt5BlwsMxLQGOT8+qRrYvUl5PSgaPpicD8LSNmBiUCtO8KAH3sFzc1uVwqNDqqnmQ==@kvack.org
X-Gm-Message-State: AOJu0YxT/TnXbRvPOxLG3V7M47cPRmt2nfp1xBzB+0WQmhowj58sW1zF
	mjlSA2KAC0Ny/jp6MQnwxK2YfN5LOeD5gVF+5hbU57qNnldW9DpbfgVnUAf2zIHXcQg=
X-Gm-Gg: Acq92OH1kjqOqVpHW2Lsrqhe4YhsyEWNhA9EukB4EDbgwljqNbpwN17xAJMvXa4NsAM
	WAspPwmE1BVYbt8HrkMw730ELEMd2uhWxSePmG1gmvax2k1xZtvj4/Pusv7i6LY+a5gCMMwAcm3
	SWFkYwfSL//fmIgICWcDOig6Ayh1a0y4VxkyVQ3ZW5fsJKzDOeZcU1WU+lG8iHozKK9WiL3tppp
	0O1W4UpIsQft7BhpI//Kz89WRPcys5P7cVMHyhYse2KH/2+AjBuHboWr72rLwCkVkkzgrM//8K6
	u0IWZF7T2pFPx7INsyqNqqwcG86Jq6I5me+lnVVLRLetWaxKFZpCfWYTgWk8uVG8xGjBPtF1uns
	+Be3TToryNcJxFYw7bH5msxpq82XnkT7iDL04dzpfyoMxsIicVNJfCyB+KWp7UINSoPbAU61cKO
	wwiprHst2Hh0ZxNEvdgIhs289rOT8j32fFu/cwbNWkCHejpur0dvx6QeOm2UClc3Tlo5G1/qPw/
	iIA/1/zrTcp1A4OhA==
X-Received: by 2002:a05:6214:4586:b0:8ac:a6bd:503b with SMTP id 6a1803df08f44-8d187aef6a5mr16950546d6.15.1781122376601;
        Wed, 10 Jun 2026 13:12:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd0535b0sm241706096d6.28.2026.06.10.13.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 13:12:55 -0700 (PDT)
Date: Wed, 10 Jun 2026 16:12:52 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>, lsf-pc@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	kernel-team@meta.com, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, osalvador@suse.de,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com,
	sj@kernel.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <ainFROZ3WrGioyuY@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat>
 <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat>
 <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat>
 <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
 <c1b66e7a-bb95-4295-8193-55ceadaaa578@kernel.org>
 <aimSzvoJDrpeQsmM@gourry-fedora-PF4VCD3F>
 <d01fb1ed-2418-42ee-aea2-37f9a5c5729c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d01fb1ed-2418-42ee-aea2-37f9a5c5729c@kernel.org>
X-Rspamd-Queue-Id: B4A4820004
X-Stat-Signature: qq3xwuowf7u6536so5dob3rqg97yrg8e
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781122377-431033
X-HE-Meta: U2FsdGVkX19n2JnDSV9k+2I8I23xUdn7/KsszT51FjsoHTaWaOPLBJ+yThgj5rMZnMvIt7yQd2EZTUftY+Bm8Lwamh26sSytplL410og5mhdg5rnAfBFVd7FANqpFLP/urG/dJlEOsoCnd60J5Z7TrVbyKbwCPdvM2YNQwMC+ky01RQMCB8dWSlBDsiZ/1aLfus0b+9EnL0oXnhXBqyp9kFragGj9bFradp4+J0WZUUp45731YyP0aX4iOmfqcmJWv98jmdxpjLg2DKOlYKxNZQQ43QzwUekhRRaU6EnbalqRHPZE/gsAlAkOMe0rxR9pkfHZzRxau7uKY5++XFTlC3LoQr8hELLNcfanZS7MlCcCoE9+JaAyUC/rSakMrdbArpbcxgbrD/o48+3AOVgTyl89vQSR7XY9tdws45X5uJQCv5P4l7eC9x2lPi0xZ7+Oo9s3qwUGVvvHaGz3D3LfxkOXhF8C54DDfWQRPccu7Gj4jwG1k3f6c0sQZKRiEHs0IPMV4uJQ6xk6UyGJ05MMQU8ULtwaH51j+SuYc6aZkDO6f/OUmBBRb1r/ncZTv6VcdTu5YbtHbqJ9e6mHuCMndxjOc2mN4aTIG33E6oELlz8/71nmTj2Z4/PffcPSPTBa0qOe4/2hSclofjvDdLH12Ig4rji1b47hrKQmYpYkuhLmAvYswj3mLtNrunMB+ayMAET1hoVi3gsmWBmcfCvbBXXwm+uVSDvTGDYx6o8N5ZNuh/zQgSNy7SlK2/iku1e7mNiiq5UzfMvRzmq1CIiiSC3catACc/7JVAAopjnGB7ExCF0nDyDZdJojos7y1w2vu6tSbuOn3QPfJPv5I3JVWTxSa4n73NelNqs4UOq6Jade/Bv6EwxXxecOq0F8RcabVNJPb7Q4vVt1ChHJAdaOOLy005ksMqdKJ2Mpu8DR+aaSQ1tDOKs4Mpe/T7lME2Vdi1QsFaCbUVI7cQoRPr
 eZ83ZDAr
 pk+UIofA0hG4aehznaGcWhwykFWVKYsRcnZjVPQdoXvNTmlfsUOKCeYig8fp5PQCemU14dc0eKuOxL1dxDfufaCo5SFGBnBN8cngIV3AO0LEbP+esh1w0qHGRGwZbSVo1V/QnFn4+yLF2fekl+tZ+GObxWhbd8Gq8Ni+54q49L6U4JTvOLsjeZc+n+Ec3PZDBfGjKIqa+UeIz19CPkRdTYVjZ8t1Uu4T3s6i2DX0CzHgzigDqMIh5aWO3FNnOk4ASRFlrQw4T/SGUaHgpv1GU67B7ro5NPag/8jVSznSaKaJjSRcYXp4xA4qAqzRONSyGfVRisqBRSfBwWJxBj+QyPtJVjFPMTPw7039yaHCTbpRd+E5Q0DWFmMUntZ6jFfW5MjV+e5bu25rMsk0unFWOPERQsJ/WwGzzrXZAj8HHAWMyHRk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 08:59:59PM +0200, David Hildenbrand (Arm) wrote:
> On 6/10/26 18:37, Gregory Price wrote:
> > On Wed, Jun 10, 2026 at 05:00:33PM +0200, David Hildenbrand (Arm) wrote:
> >> On 6/10/26 12:41, Gregory Price wrote:
> > 
> > So, I remember this being asked, and I didn't fully grok the request.
> > 
> > I'm still not sure I fully understand the question, so apologies if I'm
> > answer the wrong things here.
> > 
> > I understand this question in two ways:
> > 
> >   1) Can we disallow PAGE allocation and limit this to FOLIO allocation
> 
> Yes. Can we only allow folios to be allocated from private memory nodes. So let
> me reply to that one below.
> 
... snip ...
> 
> At LSF/MM we talked about how GFP flags are bad and how deriving stuff from the
> context might be better. I think there was also talk about how the memalloc_*
> interface might be a better way forward. Maybe we would start giving the
> allocator more context ("we are allocating a folio").
> 
> The following is incomplete (esp. hugetlb stuff I assume), just as some idea:
>

Ok, the mental gap I have is not knowing the full context behind
memalloc.  I'll take this and do some reading / prototyping, but
this looks entirely reasonable.

I will still probably send the next RFC version tomorrow or friday,
as I want to get some eyes on the __GFP_PRIVATE-less pattern.

Also, I made a new `anondax` driver which enables userland testing
of this functionality without any specialty hardware.

tl;dr:

fd = open("/dev/anondax0.0", ....);
buf = mmap(fd, ...);
buf[0] = 0xDEADBEEF; /* fault to anondax driver */

static vm_fault_t anon_dax_fault(struct vm_fault *vmf)
{
        struct dev_dax *dev_dax = vmf->vma->vm_file->private_data;
        vm_fault_t ret;
        int id;

        id = dax_read_lock();
        if (!dax_alive(dev_dax->dax_dev))
                ret = VM_FAULT_SIGBUS;
        else
                ret = do_anonymous_page_node(vmf, dev_dax->target_node);
        dax_read_unlock(id);

        if (ret & VM_FAULT_OOM)
                return VM_FAULT_SIGBUS;
        return ret ? ret : VM_FAULT_NOPAGE;
}

With:
  qemu-system-x86_64 -m 5G \
    -object memory-backend-ram,id=m0,size=4G -numa node,nodeid=0,memdev=m0 \
    -object memory-backend-ram,id=m1,size=1G -numa node,nodeid=1,memdev=m1 \
    -append "... memmap=0x40000000!0x140000000"

Voila - buddy-managed private anonymous memory (1G region)

No need to reinvent page_alloc.c or fault handling :]

This can be used to hammer on reclaim/compaction/whatever support
without needing any particular hardware setup, and in fact it gives
some memory devices a path to support in userland while standards
get worked out.

do_anonymous_page_node is a bit of a bodge right now but I just haven't
fleshed it out yet.  The idea is - don't reinvent the fault path, just
provide the appropriate context to memory.c to do the right thing.

If this is acceptable, I imagine whatever interface gets implemented
will carry an in-tree driver export only, similar to hotplug/kmem.

> From 64aaff5f40497201ecc089c3339df6576184c433 Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Wed, 10 Jun 2026 20:55:49 +0200
> Subject: [PATCH] tmp
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/sched.h    |  2 +-
>  include/linux/sched/mm.h | 11 +++++++++++
>  mm/mempolicy.c           | 14 ++++++++++++--
>  mm/page_alloc.c          |  7 ++++++-
>  4 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index ee06cba5c6f5..9c850b7be6bf 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1778,7 +1778,7 @@ extern struct pid *cad_pid;
>  						 * I am cleaning dirty pages from some other bdi. */
>  #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
>  #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
> -#define PF__HOLE__00800000	0x00800000
> +#define PF__MEMALLOC_FOLIO	0x00800000	/* Allocating a folio that can end up on
> private memory nodes */
>  #define PF__HOLE__01000000	0x01000000
>  #define PF__HOLE__02000000	0x02000000
>  #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with
> cpus_mask */
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 95d0040df584..2101a447c084 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -471,6 +471,17 @@ static inline void memalloc_pin_restore(unsigned int flags)
>  	memalloc_flags_restore(flags);
>  }
> 
> +static inline unsigned int memalloc_folio_save(void)
> +{
> +	return memalloc_flags_save(PF_MEMALLOC_FOLIO);
> +}
> +
> +static inline void memalloc_folio_restore(unsigned int flags)
> +{
> +	memalloc_flags_restore(flags);
> +}
> +
> +
>  #ifdef CONFIG_MEMCG
>  DECLARE_PER_CPU(struct mem_cgroup *, int_active_memcg);
>  /**
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 36699fabd3c2..a78b0e5a1fce 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2506,8 +2506,13 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned
> int order,
>  struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
>  		struct mempolicy *pol, pgoff_t ilx, int nid)
>  {
> -	struct page *page = alloc_pages_mpol(gfp | __GFP_COMP, order, pol,
> +	struct page *page;
> +	int flags;
> +
> +	flags = memalloc_folio_save();
> +	page = alloc_pages_mpol(gfp | __GFP_COMP, order, pol,
>  			ilx, nid);
> +	memalloc_folio_restore(flags);
>  	if (!page)
>  		return NULL;
> 
> @@ -2588,7 +2593,12 @@ EXPORT_SYMBOL(alloc_pages_noprof);
> 
>  struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order)
>  {
> -	return page_rmappable_folio(alloc_pages_noprof(gfp | __GFP_COMP, order));
> +	struct folio *folio;
> +	int flags;
> +
> +	flags = memalloc_folio_save();
> +	folio = page_rmappable_folio(alloc_pages_noprof(gfp | __GFP_COMP, order));
> +	memalloc_folio_restore(flags);
> +	return folio;
>  }
>  EXPORT_SYMBOL(folio_alloc_noprof);
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ee902a468c2f..37434b37f7af 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5345,8 +5345,13 @@ EXPORT_SYMBOL(__alloc_pages_noprof);
>  struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int
> preferred_nid,
>  		nodemask_t *nodemask)
>  {
> -	struct page *page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
> +	struct page *page;
> +	int flags;
> +
> +	flags = memalloc_folio_save();
> +	page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
>  					preferred_nid, nodemask);
> +	memalloc_folio_restore(flags);
>  	return page_rmappable_folio(page);
>  }
>  EXPORT_SYMBOL(__folio_alloc_noprof);
> -- 
> 2.43.0
> 
> 
> -- 
> Cheers,
> 
> David

