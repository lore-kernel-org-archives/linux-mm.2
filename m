Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCD0ACAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 14:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 457778E0008; Thu, 25 Sep 2025 10:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42EB58E0006; Thu, 25 Sep 2025 10:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36C278E0008; Thu, 25 Sep 2025 10:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26A298E0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:05:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0B561602F0
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:05:25 +0000 (UTC)
X-FDA: 83927945010.04.11FBDE8
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2E670180011
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:05:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T160NZ0Q;
	spf=pass (imf24.hostedemail.com: domain of 3IkzVaAYKCF0N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3IkzVaAYKCF0N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758809124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3Nb5Uy/w9+ATOrN88r3+4hXRo3JqcPtuKmPJ0+uxMw=;
	b=k20ym21MFc/a9/H9CO46eYN3HcJSpGVfhLicgss4+pQ5WPNjMG8SLvqSkz2lNxQINLojMY
	n3DOubS1TEbTmhbHOaqGaDYkCb+BedniYmq7zF5xoyVoQe6KXhAm/C/im35zwh4a/TKmbu
	WcQ61KYC5Hjqs3Wue5QjboRwiCSOBdE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T160NZ0Q;
	spf=pass (imf24.hostedemail.com: domain of 3IkzVaAYKCF0N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3IkzVaAYKCF0N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758809124; a=rsa-sha256;
	cv=none;
	b=gS9jcZ+vLuJSaLFu+ZbQyihQmCeyD0rOHaEYuwJ6NJhLJ12vioa6QuhdZYBBKU8C7E+WH/
	VPL00Mh8JZbBt7kUnLecS8p6OC6GUK6w/vhouoLOLcKr7ruEX5pi58t8kfWEjeGoOsdsjG
	Mk0l56o0ADYfSziPCwKRHnnNI3pqig4=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eae48beaaso1058164a91.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758809123; x=1759413923; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K3Nb5Uy/w9+ATOrN88r3+4hXRo3JqcPtuKmPJ0+uxMw=;
        b=T160NZ0QACsa6N5O4R3ri1mxiZzwNNkh7je6p/R78T6m6GM5E++xsjASwIu7RU4y2e
         AN5jML0BVzZnH5zxhCvWw/HFiFyZNhI9vjC+zQqSRkwZZbMnP2RtV93CvboevjMW5t5K
         j+wUAIo7gY1DaFm0QxI3iG/RJJDAYZqjCQeQAdnO1Zc7lO5JRBUDFFwDWi/3UMuuqCAH
         Nb8+b8pkL4JpNjJoe37P45koVeJJfYJdSS/1kct4+cn+VdXa7dYidWHamG8n+R5qpUsY
         ulJE/oBT2Nun3YJ50FOLCvz5+qerLB4Tg2RQKxH6+JJ/YAa7tqIL3YaoKXtDULXpUsRb
         fSlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758809123; x=1759413923;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K3Nb5Uy/w9+ATOrN88r3+4hXRo3JqcPtuKmPJ0+uxMw=;
        b=gb4/cXfh/QUGVxPD06ZGWDCv9xRk5tulF06/V00gSydB/gZLo/jhQN+kHDdHOt/PvH
         XImUuCbiI3rlNvpy6aETk4Zev+uo4UKXQL52vYF/NXVIQzLse1Ynp4iMn+vM1F+WCOrR
         XsjySF5B4xheGZhFiyWOQF67MBQmbViK1aVFoKK4K2Jjd3hlLQxIpBtYWV1+cWg7RBgk
         hWkBIRMKXy+TP0LMXhjGonaGaMAIdgQz6/dJ1IsxOSytymuXcRKCotkHiRz2cUoqqMDM
         YBc5LESlSH+uCVFvkk2urvq5VFxfn1FWlFgzxH3PsFFdOa2B0HYyKigNYTcpm/N373B2
         zPaA==
X-Forwarded-Encrypted: i=1; AJvYcCWu7F5q/Q3HpeEIgVmpSNsbFk1g5hJWqysxBOfZluj5oeJ+IFqIBqV6+UhSF5tP/kHKHbmPm3norg==@kvack.org
X-Gm-Message-State: AOJu0YyAYO/O0CLy/Z0EZJy2UlJoutQNuQTtPch8cLcb+6q57vg5Fjny
	XFYUpbQvJzCjOPa7UB8EzZELWwD5JG4kwDltLrkJ0nWpJ7zvvETQByKr/qhCHUGgkoDtVBHva7G
	Sinat5A==
X-Google-Smtp-Source: AGHT+IEkjjemcop0vI/vs3xI7IyH1QWjecMMGslQWYv6HGbBMSaTE77RWNjTkPN4A7aBZK5WeU4rCe73+w4=
X-Received: from pjo9.prod.google.com ([2002:a17:90b:5669:b0:32e:e155:ee48])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f8e:b0:32e:7270:94a4
 with SMTP id 98e67ed59e1d1-3342a22f5c5mr3557648a91.14.1758809122488; Thu, 25
 Sep 2025 07:05:22 -0700 (PDT)
Date: Thu, 25 Sep 2025 07:05:21 -0700
In-Reply-To: <20250827175247.83322-8-shivankg@amd.com>
Mime-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com> <20250827175247.83322-8-shivankg@amd.com>
Message-ID: <aNVMIRels8iCldOj@google.com>
Subject: Re: [PATCH kvm-next V11 5/7] KVM: guest_memfd: Add slab-allocated
 inode cache
From: Sean Christopherson <seanjc@google.com>
To: Shivank Garg <shivankg@amd.com>
Cc: willy@infradead.org, akpm@linux-foundation.org, david@redhat.com, 
	pbonzini@redhat.com, shuah@kernel.org, vbabka@suse.cz, brauner@kernel.org, 
	viro@zeniv.linux.org.uk, dsterba@suse.com, xiang@kernel.org, chao@kernel.org, 
	jaegeuk@kernel.org, clm@fb.com, josef@toxicpanda.com, 
	kent.overstreet@linux.dev, zbestahu@gmail.com, jefflexu@linux.alibaba.com, 
	dhavale@google.com, lihongbo22@huawei.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, tabba@google.com, 
	ackerleytng@google.com, paul@paul-moore.com, jmorris@namei.org, 
	serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com, vannapurve@google.com, 
	chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com, 
	shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com, 
	kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, hch@infradead.org, 
	cgzones@googlemail.com, ira.weiny@intel.com, rientjes@google.com, 
	roypat@amazon.co.uk, chao.p.peng@intel.com, amit@infradead.org, 
	ddutile@redhat.com, dan.j.williams@intel.com, ashish.kalra@amd.com, 
	gshan@redhat.com, jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com, 
	yuzhao@google.com, suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2E670180011
X-Stat-Signature: zzjknboytgpbs4b5fzcn5okbibdkyjtt
X-HE-Tag: 1758809123-979552
X-HE-Meta: U2FsdGVkX1+JLH+yjM+nU+OLG4Y/5jqhck3pQjb98ad6UfZx1vP+TiewK87UDZX1/8ovtWgbBBqanlIC/eGMWDW8Htcx9PHHaTW24Oi3GKoJ1mhG4TCdvPhhGkw/P+Y2Mg0oOE+YtgW/4Xg5USTA4jiRSloaTrmQz6nJeZu5LdLa1T95GSupyFHeu1utZYYCJdeSKmhlHHWuYfLiinOyxcwwAXbLHKXrZOaDNuOWjfuw61F2ACIHV8tJBK+QVyfR6zzHIgDFOHgQEmYUotuw6jIFVQbVOGn3nPstVZjPpaYSxDYczeKCmBlurD+46Xr0LxbZNo3TvduRBpFIAQkFO5RdHe1QztvI4UL1M3QgGqmGQUpi7rPxQwtc1N0q1hWJQxcrQJ3t7ys9se5+6EPABNmkcEDGR2DPXVl5Bywcz1SgBCVxCjQFhorV3b2eYEVaJwuXNIh0xLyF/c8b/zAEZ/OiVPBK6GMJYQkMeeme7E22vCicsJyvjUImCkbgprl+xq84UkeigMKYoWaMcLYdz2C6UPvd8Fox350rqNC3yHucI+vS6GnDk4DDJddTpIA+SLN1u4TP1SqRrDRZFQ/ck7e7I/sl559TI4WCcclc/FfCsNb/FzF6vWgCy5qDtRrPV/t0QctXvKEXAokZFysAiUV5KCAna6DeFT+1xCkScL7+84AQNZY1z1/dL8jg1dkvNuymx3F2FSl6JguDryaeIPCfa8yHKcJAH3wts70QzOBRFdDQpQdTK8TJxcn5RK+NawNO23jCyzhjiUgkNCrvBW6usQb2ENqJnvzJEzNUgglL9WZn9WreJnNyNvGNMkvudQeuwSwyG6zFNWqfB/pwkz2C6QSBvJ9VlUhR6TcslLx+JgiGECoD5fS7cMfj5YuY9PHlbuf98mVcRRrwtDEEzBWl0gZj8uPs9ebNa2pHURE9BxIxG/1Y/3YH9qCEJnUvn4FskO+x3AlNIHeXLyA
 ewP3IISa
 oJZftbxpsz1l4Rdl9Bzyscb+1zSwTD7C4WNq7mBpx8xpv0lMAQgG1GBgyxAc067oJR+YEAG7cYlYe90oEdan+T3AH6HA/JeGd6obxkuyGXCQKOBnbWEISHhS88+2aAI6SCtbq3rND1ACIXwi7mcGxy5kIDWHHqLhLYCfGNNDJvbcVxokojxBdlUnxNOp6l0Em9mSTw72Sv/eBHoDtPmZTS+a2p8YOLGsMlBTVAgbF7gJWtnXvso1UwKBjPm6WY3uqHmxyChtT7wAtPH61+feZfwITk0OGPepp4jXpYJJZGCI9QQUjkbjEDz9Kp1UMbwxTeOmdWB5dcGa8bHTuHZiJAgO59dX5iZ4chMOsh7wnpQByWDMVgehORulCRH/91vXkrLbsoUhz9SqCfqKE1bgQ1GSzkqEXm9DQkbU97xU8FiIjUWEetVGEMuuk7l/Ckkreb+GUf4I4UImavBo7txpfDpeGVEWNSW/DdAld5QWQH1kyHMkfQasGAvhVgObroSzvKiaWSAxw3kbGApPrNSZsNb9zhTQnFSauz077GRyzeOMF6Ky5uPZiMvxBC2+eYfMdYDRSaMS7Lf+VorMpZdMYJUDDSOtxfN4UiIH6Piqr13dkv60wOAC4Qu4f+wIyQNGUXCxT7gepBnCf5sseEPaAV+FChzYkDJBJ9hTDU7jrw+9K6H3zKWXApEwNlKL39KLjpz6YJ2sHXu1MBBKRyC/VSuZ5bfUxXwoaQD43tUP5TNVczuw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025, Shivank Garg wrote:
> Add dedicated inode structure (kvm_gmem_inode_info) and slab-allocated
> inode cache for guest memory backing, similar to how shmem handles inodes.
> 
> This adds the necessary allocation/destruction functions and prepares
> for upcoming guest_memfd NUMA policy support changes.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  virt/kvm/guest_memfd.c | 70 ++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 68 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 6c66a0974055..356947d36a47 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -17,6 +17,15 @@ struct kvm_gmem {
>  	struct list_head entry;
>  };
>  
> +struct kvm_gmem_inode_info {

What about naming this simply gmem_inode?

> +	struct inode vfs_inode;
> +};
> +
> +static inline struct kvm_gmem_inode_info *KVM_GMEM_I(struct inode *inode)

And then GMEM_I()?

And then (in a later follow-up if we target this for 6.18, or as a prep patch if
we push this out to 6.19), rename kvm_gmem to gmem_file?

That would make guest_memfd look a bit more like other filesystems, and I don't
see a need to preface the local structures and helpers with "kvm_", e.g. GMEM_I()
is analogous to x86's to_vmx() and to_svm().

As for renaming kvm_gmem => gmem_file, I wandered back into this code via Ackerley's
in-place conversion series, and it took me a good long while to remember the roles
of files vs. inodes in gmem.  That's probably a sign that the code needs clarification
given that I wrote the original code.  :-)

Leveraging an old discussion[*], my thought is to get to this:

/*
 * A guest_memfd instance can be associated multiple VMs, each with its own
 * "view" of the underlying physical memory.
 *
 * The gmem's inode is effectively the raw underlying physical storage, and is
 * used to track properties of the physical memory, while each gmem file is
 * effectively a single VM's view of that storage, and is used to track assets
 * specific to its associated VM, e.g. memslots=>gmem bindings.
 */
struct gmem_file {
	struct kvm *kvm;
	struct xarray bindings;
	struct list_head entry;
};

struct gmem_inode {
	struct shared_policy policy;
	struct inode vfs_inode;
};

[*] https://lore.kernel.org/all/ZLGiEfJZTyl7M8mS@google.com

