Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F026C5516E
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 18:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 198036B0088; Thu, 30 Jul 2026 14:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149396B008C; Thu, 30 Jul 2026 14:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010DB6B0095; Thu, 30 Jul 2026 14:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C43A16B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:12:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 557BA140243
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:12:59 +0000 (UTC)
X-FDA: 85046239278.15.966F5B7
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5E598180006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:12:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="kHc/hsq0";
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785435177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YghvBOxKZj6r8MAI+WUSEYlYQEu1XclpHCz2MD6Rx8I=;
	b=uqjctP/OyU5DocYzs3Le+bqQClV3FW7g33LFWxYR7I4/TpBKPy8mrJQeOmTsZy0uOrrVue
	jU7j6MKD0zVDvXehRQ9nFQlTKIPTDX4fBi0OjduABcosEeEKZm1AMXb/dny7UsZz3scWpt
	Cs8T02asFMtu/lQJ1UI3yC5qdLF47SM=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="kHc/hsq0";
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785435177;
	b=zKfQz/zH6eNmGTefumeAKh/52P0DEsPdioYN2zL0o+H+rZFv6eEs3igUFsKlRFmC0c7+Ue
	nLtuVmmZp3lnGz3gdhjINonpGkpMjTbsxSDsO7bJtveH1ai403KjvI10WX2qdemhcF91Au
	sVvwLWnWPXygA7gvSGDDrG1eXz5xnqc=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38125cebfdaso233684a91.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:12:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785435176; cv=none;
        d=google.com; s=arc-20260327;
        b=V/azFGIuWUO7qvp224scV/tlY/OVmhs3jt0OH8ETU0BKtYsjlVJ1XsHfRuBGkpLP9m
         1CVTW692s9xMp9O0CAMIyw6kTAMfcDbsZjIsRLnFKvB/jeL0VmHiAB2ZnoWIBdx0vgXQ
         0xlubVE9LI2KgbzBUiFJi4fGnAOy/33eWlIBPc5qynZI4iWofSqXQ0d6jfZdWZuGk8Ip
         yZNiFMOavog35ud67Z+77g01vHTOIvk4GI/MG2Sr9xsnr0vmJXyh177I2rBf2K1osU5m
         JJr1lWWgzAI9gnojnv5OQRwJWzTwnZLgrflXgnOdRI/BqvThClGduntzDyxJ1xHGxLs2
         +3VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=YghvBOxKZj6r8MAI+WUSEYlYQEu1XclpHCz2MD6Rx8I=;
        fh=GGnW6FXIYVqny/Zl35QDiq6axIiwcu7piwMC0Qx+Oh4=;
        b=GKtWN8B3uO3emfDNQm8hBUkdS3PGBOmqeAsA/2wxSI+VYR1o88PGKK2hcprNxAipXF
         ItmAuG4fAtdSNdRWn+Ba0r+ZKsjLwMz5QFTzi1To9lsoOIruerxdv/Qq2ub+W6QhU4ht
         L7gwpWMYTovh0S1MZ2ZGBHfw354dwfILxxdWeu9OT4WBVdqbssi75x3FS8Xf55FBqhYu
         VnP/fOApmk1XgSur8QIZYvapZQdAcWXpAzFaH1AjhGtU92c1xCTOonXl76pyvfcs9W0D
         1xZX6xVTPCMGNyEiTzxCG59FEJPpoajrfVVkwB+MZnf5aQmsBEuoiXILAHXFVGmr5rei
         hX9g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785435176; x=1786039976; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YghvBOxKZj6r8MAI+WUSEYlYQEu1XclpHCz2MD6Rx8I=;
        b=kHc/hsq0zIdAguTKWRYwQRQVh/02YlvPAuRzrY7XFiV2gs5066JFFVlmOuDDlN/BcD
         iy+I8BBmL4bxLw4VS1uc3BAvv6DmzvJYuQMAn3od40pU7zqEHW8az6SBEhpdQh5PSBxD
         OV4EOovYBIkm7VYmOC9qxxUhhfUACjXJsSORxn1y4s4rDqOuwx6RnteNYtlIiVXFzXwD
         vDhL5dWcLPU6FIrOtQvNG5qHHfUOhtjscBhWws3p6ohGyugHwRWmqp+Rhm1eVKqwdG1x
         aVcaQLlo+wb3Rmni8Ux1ZEqm4vKuTi0hTB+oYLysIFtCki1EwpTIk5yD8IRE9hWX+YMw
         jEOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785435176; x=1786039976;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YghvBOxKZj6r8MAI+WUSEYlYQEu1XclpHCz2MD6Rx8I=;
        b=PNxuyT8t6DYDCSFcuQpzGx8VO9dAt9LNm2hRj2tByVUUJPcxJGljpGY79wSjcl1jZz
         gJzhxMJ8zM1wW5aOaWwesmCctZPp7E97E2OD9ZWUKIsedGbEvUkxcguxlxgQLHvILJf2
         kiuEOrq4IJasRd5gBNbtCsKq9tmeC30FMSfZxWRysDQsCVdvkM1TrxQNTz51r9f5vsRa
         uukQBGrL1+16fam1DKZTz3qN9XJtRYp3G0KQdW+FhCRe6ebxCtK0nAvzS22SI0EAY/yN
         Nt3igx0FFmTj2xBArSz1Em4ilebX3WSKT0VVpnNc+43+R9TAXFltvi87OHlwhhovg3Bf
         O7pg==
X-Forwarded-Encrypted: i=1; AHgh+RqqSXPMb2NSCD9zrfNZ1aDP0ku70Vm4kcb9Q0dsAuTMUXeBeAMs8ri4uTOKYKsDczeK7rEl0gkNxQ==@kvack.org
X-Gm-Message-State: AOJu0Yxd1/mXlRUQA0E5CnJoY8oe0tsi0pWlvJzLB5iSSfKgkR6gQ/DP
	JisAEAsxi/x8P/hNy9dKqDHDt/XboX9/+ftjgk5HipHAuCeLku3dNfm33WedoHdalreCEs3nEhw
	48KwK/aAklJgqJi4i1d1sOHL6U6vkJCrNFERGDWUl
X-Gm-Gg: AR+sD12XzX3bfuCmRrGrs/jbYxhJGN/wp2u+m8FuinGpcF9tJ+022MBzrmkKBVBIF61
	B+NmPcoLePvWYI+503Q3RAyX3NWGXa52/+f6w8R/7AUljS/txiOv3Xi55MTDWtQ2b3LQL+CEG3E
	/Hns4sfZAhPCYkEia4TZkvrtKCK/FFFp2bQkhdCBPkS0XYh+JqWiN1Y6Bq3bEi80Tzbakso6a6x
	4WsqrMAAgL5uqQYgjjZMwP0SJDrO7dNolqFEVpYXh9PeXMZNI5VvdplJcn8BYTdTzJQgEidT/UN
	V/SgaazGo6ZPc2d1wJ5/D8Fms9MHGlvGdWuRQlxIb5qal/NaLfCBaXLiIYKPQruCpqM+hL32TlD
	j/aqSKl6OizCuo7WI9D8jkJEJ9OwqumfoIQ==
X-Received: by 2002:a17:90b:582c:b0:380:fead:448d with SMTP id
 98e67ed59e1d1-38f9bdaf33amr3348945a91.13.1785435175540; Thu, 30 Jul 2026
 11:12:55 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 11:12:54 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 11:12:54 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260728121138.1103610-7-tarunsahu@google.com>
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-7-tarunsahu@google.com>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 11:12:54 -0700
X-Gm-Features: AUfX_myTOZtTYgrc2JARzoakReAlBZfwUvudyD8fyzAtRRNHq5OayI8CE2nMNDE
Message-ID: <CAEvNRgEVxQS2r0_iPHciV=NEKFzwnrfitp-QdP1keAg5Ud7-TQ@mail.gmail.com>
Subject: Re: [PATCH v4 06/11] KVM: guest_memfd: Move internal definitions to
 internal header
To: Tarun Sahu <tarunsahu@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5E598180006
X-Rspam-User: 
X-Stat-Signature: xsqp8jr915d5mpqiwsrc1p1fm73wdame
X-Rspamd-Server: rspam04
X-HE-Tag: 1785435177-893843
X-HE-Meta: U2FsdGVkX1+MItp5o/LVYFPxlmz1+CNuzmIrREYpdI+9bf5rHJR33ONzJyjQ9szGG1qropNL63rH1FV7q+F53mJLoMEO6aOnBTma2dYWZvc1069imc/MxZiWx9tr6EuOeJp7IL7ISr/Au4ijlCFFT0RXFGZ9hxCkU5Tj7LjvrCEBF/7ENHWzcdTlb91dNOCWgCpr3epqpotZKEwNc+P9UmPZcuMDfhaBEvlDXluRTLcDKYvE5ptoLxpJlQ4ru+x+GSbC2Wl7BHR4cf4KDFfyskgXCVJVxKJgJ65hc+Dm1IsuPd5AWVeJA+6OeJz+pTTbaJPMwtB/q9uU9zd0Q42sRQJWy8XPQXa4qIVkyiBOiWumh+OGQfxQ6gZPVTWE+CP2nr9M4TQvDsNkMjdxjNmn4Q+4LqV5f0JjOwkklWu//vuZlZauuKyNXaIrl7eJgTcMvTkg7zGnoGO7IjZopRcCldtSmyoXvqMZ2LzeQm/mm1/jT/Uf4bBOp+ddiwzOVdekqr1vRNjDiu8S6xJKfAq10MpzkEMImt4GVSDYghm/0JjaVq/8SWaSX9ImZAEtui1u952ia6uWNMhSzY4SalD8a2LPdqlZImTx7fyC25gJHylIRXq9iuSv9+/CZHKNcFhRjj4eeCRqRYqls+U1FX5LQXzhsH3LCldgconAMEMDmYxQJMT2xhvLjBU/oS/zm9QSsKcJlZorMXGye2LDm5GSzVmAB1Vu3aS5ovZNAgQB93ruBOu2015YTHsM0z/2UeoLlaVyzmn7zhfrHByisbXBCSR8/zQTApyI7Tv0e2HcMr+XCx6mT49dHtGhmYSh1jgDlDVe7Hy/BHQO1l6LyqNKP1SvnLlbdndkAvWgXLei8bxs9Iundz/e4j8YHU/WRm3ZQ5O3NMlpdmxnyeWcjDgY8pRsBdY9GCWFDLfBipj1F+Zrhu0044BE/ic8FByFZCpmGDTH6PwKwU1dGYmT4+k
 bhchFdvJ
 B1tih4jByPrgXg902Sr6cyQPcLMm75tW7aNDBDPlpANVFt8AnaZLi8BNGZngeETWu2vUeLEWPcJhRW37r+84DGo6oX+E3PrAPsU89RqbG2rYFeq0NlSXoojgvu+SL5aH7afL3KLpqRjiRPqoEdn6jI32jpd5qhNC8tmQm+5IbkZpl054jVe6ECDFVhcPBGGaQE1QX6JABwRq6i3uKlGK3Y/dWubbKadIcUxjH2pz7poSkm5CRudAdRwAHMa9cRzEbLQbQ0EAGZ//6wgHBXMkEhO8ICFEs3WIU5aBGnF2Lb0hMabA6sn7t3gsOUfAcPuUSk3udPlwYwnDfp6UKAr2YAx+seipQ2rMTW8R4UO2dsISttl9IrrjislKUwpuVBBZD07DyN4PznSZ9tperOq4Q4O2+SQ2jLJVOev0p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tarun Sahu <tarunsahu@google.com> writes:

> Extract 'struct gmem_file', 'struct gmem_inode', and GMEM_I() from
> virt/kvm/guest_memfd.c into a new internal header virt/kvm/guest_memfd.h.
> Also split __kvm_gmem_create() to expose a non-static
> __kvm_gmem_create_file() helper that returns a 'struct file *' instead of
> an fd.
>

This is done basically to support a new virt/kvm/guest_memfd_luo.c
file.

Would like to know what Sean thinks of this! I'd like to know for future
guest_memfd work too.

> These internal definitions and helpers allow upcoming guest_memfd Live
> Update Orchestrator (LUO) preservation code to access guest_memfd
> internals and reconstruct guest_memfd file instances from preserved state
> without installing them into a file descriptor table up front.
>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  virt/kvm/guest_memfd.c | 68 +++++++++++++++++-------------------------
>  virt/kvm/guest_memfd.h | 39 ++++++++++++++++++++++++
>  2 files changed, 67 insertions(+), 40 deletions(-)
>  create mode 100644 virt/kvm/guest_memfd.h
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index db57c5766ab6..dd84bba8974b 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -7,38 +7,12 @@
>  #include <linux/mempolicy.h>
>  #include <linux/pseudo_fs.h>
>  #include <linux/pagemap.h>
> +#include "guest_memfd.h"
>
>  #include "kvm_mm.h"
>
>  static struct vfsmount *kvm_gmem_mnt;
>
> -/*
> - * A guest_memfd instance can be associated multiple VMs, each with its own
> - * "view" of the underlying physical memory.
> - *
> - * The gmem's inode is effectively the raw underlying physical storage, and is
> - * used to track properties of the physical memory, while each gmem file is
> - * effectively a single VM's view of that storage, and is used to track assets
> - * specific to its associated VM, e.g. memslots=>gmem bindings.
> - */
> -struct gmem_file {
> -	struct kvm *kvm;
> -	struct xarray bindings;
> -	struct list_head entry;
> -};
> -
> -struct gmem_inode {
> -	struct shared_policy policy;
> -	struct inode vfs_inode;
> -	struct list_head gmem_file_list;
> -
> -	u64 flags;
> -};
> -
> -static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
> -{
> -	return container_of(inode, struct gmem_inode, vfs_inode);
> -}
>
>  #define kvm_gmem_for_each_file(f, inode) \
>  	list_for_each_entry(f, &GMEM_I(inode)->gmem_file_list, entry)
> @@ -557,23 +531,17 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
>  	return true;
>  }
>
> -static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
> +struct file *__kvm_gmem_create_file(struct kvm *kvm, loff_t size, u64 flags)
>  {
>  	static const char *name = "[kvm-gmem]";
>  	struct gmem_file *f;
>  	struct inode *inode;
>  	struct file *file;
> -	int fd, err;
> -
> -	fd = get_unused_fd_flags(0);
> -	if (fd < 0)
> -		return fd;
> +	int err;
>
>  	f = kzalloc_obj(*f);
> -	if (!f) {
> -		err = -ENOMEM;
> -		goto err_fd;
> -	}
> +	if (!f)
> +		return ERR_PTR(-ENOMEM);
>
>  	/* __fput() will take care of fops_put(). */
>  	if (!fops_get(&kvm_gmem_fops)) {
> @@ -612,8 +580,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	xa_init(&f->bindings);
>  	list_add(&f->entry, &GMEM_I(inode)->gmem_file_list);
>
> -	fd_install(fd, file);
> -	return fd;
> +	return file;
>
>  err_inode:
>  	iput(inode);
> @@ -621,7 +588,28 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	fops_put(&kvm_gmem_fops);
>  err_gmem:
>  	kfree(f);
> -err_fd:
> +	return ERR_PTR(err);
> +}
> +
> +static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
> +{
> +	struct file *file;
> +	int fd, err;
> +
> +	fd = get_unused_fd_flags(0);
> +	if (fd < 0)
> +		return fd;
> +
> +	file = __kvm_gmem_create_file(kvm, size, flags);
> +	if (IS_ERR(file)) {
> +		err = PTR_ERR(file);
> +		goto err_put_fd;
> +	}
> +
> +	fd_install(fd, file);
> +	return fd;
> +
> +err_put_fd:
>  	put_unused_fd(fd);
>  	return err;
>  }
> diff --git a/virt/kvm/guest_memfd.h b/virt/kvm/guest_memfd.h
> new file mode 100644
> index 000000000000..c528b046dd69
> --- /dev/null
> +++ b/virt/kvm/guest_memfd.h
> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __KVM_GUEST_MEMFD_H__
> +#define __KVM_GUEST_MEMFD_H__ 1
> +
> +#include <linux/kvm_host.h>
> +#include <linux/fs.h>
> +#include <linux/mempolicy.h>
> +
> +/*
> + * A guest_memfd instance can be associated multiple VMs, each with its own
> + * "view" of the underlying physical memory.
> + *
> + * The gmem's inode is effectively the raw underlying physical storage, and is
> + * used to track properties of the physical memory, while each gmem file is
> + * effectively a single VM's view of that storage, and is used to track assets
> + * specific to its associated VM, e.g. memslots=>gmem bindings.
> + */
> +struct gmem_file {
> +	struct kvm *kvm;
> +	struct xarray bindings;
> +	struct list_head entry;
> +};
> +
> +struct gmem_inode {
> +	struct shared_policy policy;
> +	struct inode vfs_inode;
> +	struct list_head gmem_file_list;
> +
> +	u64 flags;
> +};
> +
> +static inline struct gmem_inode *GMEM_I(struct inode *inode)
> +{
> +	return container_of(inode, struct gmem_inode, vfs_inode);
> +}
> +
> +struct file *__kvm_gmem_create_file(struct kvm *kvm, loff_t size, u64 flags);
> +
> +#endif /* __KVM_GUEST_MEMFD_H__ */
> --
> 2.55.0.229.g6434b31f56-goog

