Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 234ECCAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 14:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4232C8E000A; Thu, 25 Sep 2025 10:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F9AC8E0006; Thu, 25 Sep 2025 10:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E8358E000A; Thu, 25 Sep 2025 10:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C8FA8E0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:17:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C49FC1DF2A9
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:17:05 +0000 (UTC)
X-FDA: 83927974410.01.9FA8F7B
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf13.hostedemail.com (Postfix) with ESMTP id EAF3120010
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:17:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HfG47CEl;
	spf=pass (imf13.hostedemail.com: domain of 33k7VaAYKCB8N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=33k7VaAYKCB8N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758809824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q01z2q70uBCSgJYAVR+vis46yH2U6fCb9IpR1jV5kvA=;
	b=UaxF8npIGFbkd3hYvFymO/yFAnDKSHfwHWgPM92bKbERBmO7ahxIVnMDOrm6qvl+p2mqE7
	hvpaMlJgy7LV/Nxwz93VUvgxnJMmPexH02BDCd7KwoXMBuAiodTGzAU5dlA+qaQt0Rg4vi
	EJaY/idk9bZ+cywM0Rh+meKHvul2vuE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HfG47CEl;
	spf=pass (imf13.hostedemail.com: domain of 33k7VaAYKCB8N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=33k7VaAYKCB8N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758809824; a=rsa-sha256;
	cv=none;
	b=i6o8n4JrdssN+8J/jF+vH6mQZ1QF/ONQ5xkKdcWMX65S+v5hMJG+dhDLCdem5wk38M4K5G
	VyD/TCoNZAZHEM+yxxgjcebeKLtryb/qlDm9bd1Ndj5wb7uv9U/vwE8L2hqNZ7IORT46zs
	lWnBjA6dD6JYzDWN18rdsVjM+GJ1wjU=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b5535902495so865948a12.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758809823; x=1759414623; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q01z2q70uBCSgJYAVR+vis46yH2U6fCb9IpR1jV5kvA=;
        b=HfG47CElA4BRluUHWS696pTvhlAAzjD7rqTzr9nn7Tr2soekA0NY7TyW0WwTKGCLls
         JIkMTA4wUH7Jn99E8SjcSLgFNSsOIzrZH9185lJ2oGCJIiDWbtTiL0RYr7g5Vk2R38zq
         d9IsKgotJwLeuV40Wv2C5okUFvGtGJsUgowBBiGwX0m2ghYZp01mapMKhe0PBo45nAPq
         XC1JtZBm/Gc7zSUKxaGcyXpcoUC7C8c1U8vOfo7uT09ZHoL02OzzRs2cRwXgCnpN1ImQ
         Ch8ymxNMLnW1NC7FlOHvoeDplxHMaEsnSCvEZNwmfsAnU4DExXBWS32Gt7vmyaN0dAh9
         V8YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758809823; x=1759414623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q01z2q70uBCSgJYAVR+vis46yH2U6fCb9IpR1jV5kvA=;
        b=n3a0MuWAjHU1UhgtTjsJg6ZYBkZmU54ozSD58muNXSK1/et9QL+Lz/r9taZ/yzXQVQ
         XwTjueG2D/9LZ6WGhgTxELgikvrKGxCddFZe6bmw+b45TfrYVRLC4KX22EJuHiqRN5Qg
         k0d0jFpNCWaDaF1dX6xNrYPmONopQHRks5JkF/m7D4Nuj4R8Nj7RpoXxjleW000wBQdC
         fNL1FBqdgkdnK/lgj3U5zJVBcZRmTnj1W3aNdXdmhF3KRTZLjnKrhmvnilpjn4FMBnMF
         Dyg1uhbY++NFnfRbdmfET+tlNGsTnDlOlCeiunBz4pQ/QdKX7K/ZrfOetiVUXrpDd0WK
         bDIw==
X-Forwarded-Encrypted: i=1; AJvYcCVoKGrXyf5EZ/D715ClGQTWN1YAdLnb5Vu/9kUx14Uuo2ytXJoS/2W9RzyX7ausfdreq9LwZIhKkg==@kvack.org
X-Gm-Message-State: AOJu0Yyl5NldKrmZNbv8NBHBJAfZUZjmkJz2uMlIv17MSbrm6Hn4LdOd
	7uMLkc4jNybC3KzpWXNbThUirDlQ5W4VQaOf96zPtgjb7WoGwxrbQnwFQbqM5XZzsT1za5ttN3+
	THQzpPw==
X-Google-Smtp-Source: AGHT+IGC7UvA+zy0Lzxdig1u574Z6HM9V6jNvtPYVpQ99Zo3hDJZ7LLoK6uH5QRKE/XipBEFnMeanJ3T9fg=
X-Received: from pjbon17.prod.google.com ([2002:a17:90b:1d11:b0:32e:e06a:4668])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3143:b0:32e:1ff5:5af4
 with SMTP id 98e67ed59e1d1-3342a2fe9ddmr3876418a91.35.1758809822200; Thu, 25
 Sep 2025 07:17:02 -0700 (PDT)
Date: Thu, 25 Sep 2025 07:17:00 -0700
In-Reply-To: <aNVMIRels8iCldOj@google.com>
Mime-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com> <20250827175247.83322-8-shivankg@amd.com>
 <aNVMIRels8iCldOj@google.com>
Message-ID: <aNVO3Lr-_U5Bmvem@google.com>
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
X-Rspamd-Queue-Id: EAF3120010
X-Stat-Signature: 81zhfgg17as5xih86sfksys5az5xbem9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758809823-927524
X-HE-Meta: U2FsdGVkX1+0cCCLEIDZjCKp2U0BvyFxqZE8ubNMJXXPxppd9DczJmkOP6l+BO+xXsGlcf7lbx+3w0RKsRe24uctC+1GdYDJ0htRUGSdQzmotd1Qkd57h2HtxrpKthWLD2wi2DYyEs6B04e+yoLq8B0GSZGo+65ZxFfvPDJIkKR2kxRPp0rlV5hniPmLPwgHJLCVhC9jDo7pPNGHfPrT4F3VoQ+SglkSa3/IoNP7Bi+dTzoAN3QNkPaFULa80oB7AhzTjL8/vn4d5V++rDpTDAYOuIOt7hREGrKxSoPdO6DxKRbS4Sx200UeupK0PdwTpKcRp5KRfKqK20/x1uDN5VJ7F9mB26k4jFMtRXJdeVitx0/udXSyvnU/mggyI5wRbg1iwQWVVwS2ju7+QXhqf5HtRInPKL6xEzFIxEdcx53NeS7v8jr+1Ffo7AG1K+rS4xCq67Y+TfC6n9I+G6s+AAPYyn0Y1wUna6XIcCIpDDicg6PSKmw3wBh4IMtKzYOJWT97RSEsW4+tpn9HLCsH0NMdqM5Pik8DHcI4ekx+z2WHR3cYD76I3BnmKGQgLyOg5z7CXU9+kyMh3ldBFlKmWXQSle07beKTaaNBrXwpTEmss169l3zWPhJqwx/POI+nsR3QYemHVLUfuqzn7oE8gi4OW++06Ikc2jBX+4MvMLmT74hNbdE6uVEzwG8ldJvgTI2wtkwriAw1R3Mwa4iGa/xYCNx/kyRdhYa8ikmuxUYdrE1XPqAvrBeIXMVYtNLNymrpIGD3q4uNIIAiCxA5p/OlCT6CVC1MJItRZ6wReSjuEj/Qj70IeI8NRkx1Y761AlzIZTe98rz+b8fj3CgQyXkOm8/ZSs7iYqoNfQ46L8W9SvHZLvaXe0XYtQXSPRkyW2TlGM+fhoJ88mfUh6Po6Vah46/PrtrKozviq5eM1XVOorg4rOwoEWRT4RFiLOxoUIGVvxHcKEUJEJ/tKHe
 0vAoYiHT
 oL7PyIDIRJdZ2pcgIKGXy7R16VCDAzGZvW01dBXLgaf/sdXRhhqsHJj9HUYWM0u5783I4HIeHq5fw0S8h4QRMzX19mvhHfBQlemeeRmL+tFGlTKwDS0r133fPKdT8+dWyFsrgJDL8RvXdijXGdkiZmMhCWuGq9CV6diLE6Ttq2ta6InM5NdthRuLc5eqiQnFkhzk4ui43WyApHO7hNcSnd6meFd9Z1/KXXmhm/sgocCKVeFnn8wzI23wyx+9eFGMoSbr332SLIZQTI/4ygd6E9zTSxugSjt6uGtPTA80DsdXhX9hWO+E3Kek9a5WkhWpmGWGAtfFiIiBGMklC/v26lWOpEPM8cQEeug7s1b6PodU3JvqStg2sjt4ZWDVlPC3H/BKG71d5pQknuS8m8repK1bqAd40bgqwtaNp0pPELNWVrI9jVHWi2GkX/PakjIqAc+nGLCSpy304y5i+0alTIIUZdHlOYC5puGZaNka6EqXD3F4KYS1LkdP7nHW4Ldeg2uqY5ziY+ssQKRTekWG/9Xwcn7GWLSoxX1RglrPwGkNEVYvDFC1HHpcwUjexHZYL9eczZDr9u9j8cnMNpgGffspIkSrooWZ+WRRsLVrjZeEYUGw+lLofAdRyjnlLIA/6OWfb9oC9OctWXoT3RhFnUEeziwy99LrVoRgR0q76NKICJ62+C//l5fxWYyFU1V4VJcXOOPeLQYlZPcAyNbW3gTonkX5AtsX1D4KFO9kvtSSksLY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025, Sean Christopherson wrote:
> On Wed, Aug 27, 2025, Shivank Garg wrote:
> > Add dedicated inode structure (kvm_gmem_inode_info) and slab-allocated
> > inode cache for guest memory backing, similar to how shmem handles inodes.
> > 
> > This adds the necessary allocation/destruction functions and prepares
> > for upcoming guest_memfd NUMA policy support changes.
> > 
> > Signed-off-by: Shivank Garg <shivankg@amd.com>
> > ---
> >  virt/kvm/guest_memfd.c | 70 ++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 68 insertions(+), 2 deletions(-)
> > 
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 6c66a0974055..356947d36a47 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -17,6 +17,15 @@ struct kvm_gmem {
> >  	struct list_head entry;
> >  };
> >  
> > +struct kvm_gmem_inode_info {
> 
> What about naming this simply gmem_inode?

Heh, after looking through other filesystems, they're fairly even on appending
_info or not.  My vote is definitely for gmem_inode.

Before we accumulate more inode usage, e.g. for in-place conversion (which is
actually why I started looking at this code), I think we should also settle on
naming for gmem_file and gmem_inode variables.

As below, "struct kvm_gmem *gmem" gets quite confusing once inodes are in the
picture, especially since that structure isn't _the_ gmem instance, rather it's
a VM's view of that gmem instance.  And on the other side, "info" for the inode
is a bit imprecise, e.g. doesn't immediately make me think of inodes.

A few ideas:

 (a)
   struct gmem_inode *gmem;
   struct gmem_file *f;

 (b)
   struct gmem_inode *gi;
   struct gmem_file *f;

 (c)
   struct gmem_inode *gi;
   struct gmem_file *gf;

 (d)
   struct gmem_inode *gmem_i;
   struct gmem_file *gmem_f;


I think my would be for (a) or (b).  Option (c) seems like it would be hard to
visually differentiate between "gi" and "gf", and gmem_{i,f} are a bit verbose
IMO.

> > +	struct inode vfs_inode;
> > +};
> > +
> > +static inline struct kvm_gmem_inode_info *KVM_GMEM_I(struct inode *inode)
> 
> And then GMEM_I()?
> 
> And then (in a later follow-up if we target this for 6.18, or as a prep patch if
> we push this out to 6.19), rename kvm_gmem to gmem_file?
> 
> That would make guest_memfd look a bit more like other filesystems, and I don't
> see a need to preface the local structures and helpers with "kvm_", e.g. GMEM_I()
> is analogous to x86's to_vmx() and to_svm().
> 
> As for renaming kvm_gmem => gmem_file, I wandered back into this code via Ackerley's
> in-place conversion series, and it took me a good long while to remember the roles
> of files vs. inodes in gmem.  That's probably a sign that the code needs clarification
> given that I wrote the original code.  :-)
> 
> Leveraging an old discussion[*], my thought is to get to this:
> 
> /*
>  * A guest_memfd instance can be associated multiple VMs, each with its own
>  * "view" of the underlying physical memory.
>  *
>  * The gmem's inode is effectively the raw underlying physical storage, and is
>  * used to track properties of the physical memory, while each gmem file is
>  * effectively a single VM's view of that storage, and is used to track assets
>  * specific to its associated VM, e.g. memslots=>gmem bindings.
>  */
> struct gmem_file {
> 	struct kvm *kvm;
> 	struct xarray bindings;
> 	struct list_head entry;
> };
> 
> struct gmem_inode {
> 	struct shared_policy policy;
> 	struct inode vfs_inode;
> };
> 
> [*] https://lore.kernel.org/all/ZLGiEfJZTyl7M8mS@google.com

