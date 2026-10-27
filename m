Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5603B606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 21:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YXwtVjEW
Received: by kanga.kvack.org (Postfix)
	id 5B3926B08FA; Tue, 27 Oct 2026 17:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58BE66B08FB; Tue, 27 Oct 2026 17:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8996B08FC; Tue, 27 Oct 2026 17:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3EF6B08FA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:30:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ACEEF140B06
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:30:07 +0000 (UTC)
X-FDA: 85369699254.21.08A41EF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf01.hostedemail.com (Postfix) with ESMTP id D13B240008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:30:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YXwtVjEW;
	spf=pass (imf01.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793136605;
	b=Mz/vLD3yfW0m90ZIt2x/BZPLCgj5ukseBEF04Xrp9EdDDZKSTr72v+jJdqvGD9cekZ4fPg
	DAeMRpXOjbjp9FOZTD21mFzm3qNIjq4l3lss0cuBUQBaZj9HXFzUoKWIyZh/MO+1Djyjif
	dyVMlQ79tfiP8eIfuYpRNOLopAXn28A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YXwtVjEW;
	spf=pass (imf01.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793136605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h62RQbHCN4jYYnI4HCsDoNJhT/SvAu6VniCIwMUQi1c=;
	b=EH+msKFF7tkTA510dweRUXYRS0vIkTGfqdXrtsZW8M9SGXZbigGx033JK17IjTQCCjrOjj
	h+qUXVy/BHa1e4KeYNjQ5v03hpSSaTmv+DrKmY0W+0Ipi2xHBrzazyalcXOp7j6gSo+Dcp
	ZoXsKqg1TtSrW6evBn+1IF1e7bz1AUM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793136605; x=1824672605;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Erwsend1mndK0SW1NuLrrKcjtadjWzVZXkakCqhyDRI=;
  b=YXwtVjEW8VxbxTzGfht8nnT1feiKXvoIBeFannW8Vqj5ISJ06gwXzoX9
   6OBnSYO3R+zjyRhTbQf/M+zbizvp/qnBlmk7MmaHkce6Y+J84efNnBozd
   UAragf528ra5jxkJwKCtIpitdEYpoogLFrP/ATE5K2uNpuPKvQP/MJdVC
   yFcJ4ez4BZSBn31sDO3YoSHK1BLfm9nlHFdWye+MVB6ZZOvl5bpQv5o82
   n5eXCMgrCu8QcHvcHrS02kS2x+LuQ7S8/oZgNCBLE48EdsmBBWtQh34Ob
   gYOb1jMznEI+gS6licd8+5opAXXzsdWjro4e2v3WoXa2ZxtQmxAHdpdHr
   w==;
X-CSE-ConnectionGUID: QE0yMTIWQ6ueCSCiLHqjaQ==
X-CSE-MsgGUID: Xyns7Mk+RBudyOHTk2Bg3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11948"; a="1881255"
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="1881255"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 14:30:03 -0700
X-CSE-ConnectionGUID: zA0JgX2tQuy+3qz4O3YUeA==
X-CSE-MsgGUID: EeGVrouuSUaELzegzYgTfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="4651688"
Received: from unknown (HELO [10.241.242.209]) ([10.241.242.209])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 14:30:04 -0700
Message-ID: <361569b659ccb6aae7c0d9935f65e16f472eb2b6.camel@linux.intel.com>
Subject: Re: [PATCH] shmem: clamp negative used-block samples in statfs
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Hungyu Lin <dennylin0707@gmail.com>, hughd@google.com
Cc: baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Tue, 27 Oct 2026 14:30:03 -0700
In-Reply-To: <20261027163653.82661-1-dennylin0707@gmail.com>
References: <20261027163653.82661-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: wwe4m4n6htqwy4iqdos1jkpkku8uzkos
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D13B240008
X-Rspam-User: 
X-HE-Tag: 1793136604-848734
X-HE-Meta: U2FsdGVkX1+gOuMykHHX7S2HvyL7hkixM9kR15gg8gbu4HPgTRkpnR+ZnG3+CAPKX+w3zjgn31tTEykR7/FL70QrJYEH8zT6KZhrIXRzZtvosHhQGo/820Vu9ducHGgmLOmKPQ6Vtf3wIohA00+Ea/IMBZz1TxexI3UTmIETHKjsvrWAd90J6YTHCNtGCDKdFK8+oO0KvN1W6z0SJGB1LoanBVvx+2a42GQqVkvdbBqnJtd/dwbEw8yIdUiDSQDPYNyenaS4iDIGisDoduBxplOlPa77xdwB67IizAka5u9LzVhHK2GE1ye9eDyel/qZANkLj+aZNDZnzH1j7PMLT0q5MDS0oLAOjPKKeuSEIfTZu88ZNcCJEHXV7Y/b3pfvwFWpiZI2BtjpNe0wecDwyPu3jS3s5STcQhAgZ5bs5MJeabKi/VxvfIDjUIWn5ylPKq2V6vkKXceOsUA5w+5qZxU0HJz4J3bBZsX6dYdf+ReAHY1K8KAeCmbwWEOqhoysmhyid3UVcDQ2F/i/+q8F2PSgO8gVzbt3pnSYNHYtub1RSAeW35D9SDE1aVPxeGmcO9kmHTFVSq+GHy75eYJ0Olcfat8zYSWIUqoVyMMYtOoXbTjc8cCTJ6qvrRNqJMZZVmulFFg0+vnNkebgstIzV/Yrjoo5xCB6CIPszcSS/tKDJRnln0mibZ/bibcH29HJJFNUxyG1t1jOCvapf6sF3OYYXiEDyslDhM5Mz1puUJXo3riL+XiLvcSvRn0rpDqUv+fBpCt1dBR+5EXPUcX0pKg+dOClNSmcP5PKfsviQMVS7TsyLBu0BVsyLzUX1u8XEKVhbZk3CChnwI+aNWLqHyY5/0TH7QpEwuyF3v8hh0PxcMNUtK3+waWbt0l+GrRZ52dTun3r5IRQsmWD/Gd5Npepl2UUs43RTXwvPXINdb0vdMfeu1jLgevr1wFnGwFLM+vKPGjdDUk50Ma+wEP
 Vu2QqlKs
 80y61y5/82xT5v8in0Wj2NLeGcGAhxTFgE7LUkh+D4VwnZ9Hr57KreuUwpa1VZ+l0l8SM2a6Nq8qwDBG2UPY8faJa+odKVvllAhaAfSkoGrHf7oMyoYwF0q/3lgjuO6SLRHaX8W/XBpIw6DSyzMcq98Q1ZM4JZ+GB874HepBt7G/zt13F5otYAT4/6wyuAyFCFyWPlPQ+X+363GTS43y5mNilVslHrfsLB4xUptZuXD8YNyBD+5Z4gLcpjI7Z4/de5KTo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-10-27 at 16:36 +0000, Hungyu Lin wrote:
> percpu_counter_sum() holds the counter lock while scanning the per-CPU
> values, but local updates can still proceed. Concurrent allocation and
> freeing on different CPUs can therefore produce a negative sample even
> though the number of used tmpfs blocks cannot be negative.
>=20
> shmem_statfs() subtracts this sample from max_blocks, reporting more free
> blocks than the filesystem's total. With a one-page file being written
> and truncated on separate CPUs, GNU df reports negative used space, for
> example 67108864 total bytes, -28672 used and 67137536 available.
>=20
> Use percpu_counter_sum_positive() to clamp a negative sample to zero.
> This retains the approximate accounting and does not change allocation

Nit: I wouldn't call this "approximate". percpu_counter_sum() is the
best-effort accurate variant: it adds up fbc->count and all the per-CPU
deltas under fbc->lock. The lock only excludes batch folds, though, not
the lockless local updates, so a free on one CPU racing with the scan
can make the sum briefly dip below zero. If an approximate value were
fine, percpu_counter_read() would have been used instead.

Maybe something like:

    This keeps the existing best-effort accounting in statfs and does not
    change allocation or limit enforcement.

Otherwise the change looks good to me.

Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>

Tim

> or limit enforcement.
>=20
> Fixes: 7e496299d4d2 ("tmpfs: make tmpfs scalable with percpu_counter for =
used blocks")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---
>  mm/shmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/mm/shmem.c b/mm/shmem.c
> index d97fc32e7c94..092bb45a076c 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -4005,7 +4005,7 @@ static int shmem_statfs(struct dentry *dentry, stru=
ct kstatfs *buf)
>  		buf->f_blocks =3D sbinfo->max_blocks;
>  		buf->f_bavail =3D
>  		buf->f_bfree  =3D sbinfo->max_blocks -
> -				percpu_counter_sum(&sbinfo->used_blocks);
> +				percpu_counter_sum_positive(&sbinfo->used_blocks);
>  	}
>  	if (sbinfo->max_inodes) {
>  		buf->f_files =3D sbinfo->max_inodes;

