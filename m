Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73DC8CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 13:34:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694046B0005; Wed, 20 May 2026 09:34:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66C3E6B0088; Wed, 20 May 2026 09:34:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 580BF6B008A; Wed, 20 May 2026 09:34:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 466D96B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:34:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 010D41C01F5
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:34:34 +0000 (UTC)
X-FDA: 84787892910.01.8F46A38
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id F1EF14000D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:34:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NxjpNELz;
	spf=pass (imf04.hostedemail.com: domain of tabba@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779284073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gg6EIejukVN1UskEcFFGr4CnqhwTYz/FF3EfBDzQQN0=;
	b=GxEKCq7vG5NtKBeie+7E1CtOsukvV9GBd1c0et0kf/EQlM0YNJcbYQcWttQaBf2a1NwL+X
	rXu5ShuU5i735EFFoRzPQUvG7J86bRkNVzAW4VD6irNqE7Qlt2tfTRaOgPaZJIc6Ax/hVH
	oMQYDwYDmmP3i90yQdIIFfHavv7+VKE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779284073; a=rsa-sha256;
	cv=pass;
	b=lC5H88lbwohNUN3bSKMliduBdZaYWUCRRxPJjmrB95LHVIArtfCdbArzzQGZSfimto7Uog
	kaVVh4MsvoT99z+EgvDYxDVUKs3blVCCq4l5sediDDN4d1gDutb2r9zcIP0b8yswZKz/L2
	DxqZuhfdAJqf4y9aiD0t5jSnRueVRXo=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NxjpNELz;
	spf=pass (imf04.hostedemail.com: domain of tabba@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50e61648f10so10211cf.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 06:34:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779284072; cv=none;
        d=google.com; s=arc-20240605;
        b=SzkNNqYzkw+HnX+CEiBUEw2jEsFVCWYJGeRiGg06o39Q6vLd7HYIZobgnPyanGnjk0
         NqfkPx7Snk5SbDApDc71r4Gv/2ESnkQ8VN74fa9wEWRz5NGzCnAvBqxqmZ6ysaglq45N
         IaN0GVcj6h6xEKqVVwDkLr4PW+eFbyVLSUnIHfuSo6KlUD1F+fSzFgRMx4q/VsYKdyqN
         DJz7uAdAFnPEGZUQNJq9WZIG9IR011ecuh6V6QdnEffOg4sV0UQmmXF7l1TJpmCnC9/7
         i4ZkMD1PylFGUEoQD+NgdQxMGe6bWE2HlmadDDFfel/wDwDd+6oMJN7x4FI7s8b1Nr9a
         XuBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gg6EIejukVN1UskEcFFGr4CnqhwTYz/FF3EfBDzQQN0=;
        fh=Nw/nln0oG5XcWUMC+BAHbBhk/jlGvgIXEpbwZcy0TkI=;
        b=TLw7Xbm91Wr4USG4e7bbYLZ6Zie8aPD9CUpF1gnI8y1HjLxOslFQa1t8Z++Yo42vAS
         AVVHb0FzNZoENvmn8TcEY8JXstXJrj9ZfmZgTUgrD+HWwaVycsE+J3IOhIpNAm0lb9vt
         7dfgSD27NnzZZQHMG1/wxUzxtGCWcyS04+sWQj9ScQzdVPbXomu5cTUKYh+ky4Yd5Vnq
         /ORZkBu1YrLEXUYXgKTHOgAgFkyNezQfuHQyDeSny0k8dv0+eFtv/xnLTYgmJAWS7xW1
         rabWzbRuMZhQfiKH2XGxsBe+LZRmFUDG2CKso0YOBy2Ac1QHgG0mU++bub4tPzm7LnzS
         u8HA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779284072; x=1779888872; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gg6EIejukVN1UskEcFFGr4CnqhwTYz/FF3EfBDzQQN0=;
        b=NxjpNELztF+Ago9wGCBWtLiSH6WxiG+f43kOlUPVtTLtBml/Sy9/aFIAxkOLW5GFdQ
         MhawpneHuevOCaZRPhZpgUuCIC9WIAHIy/PHMvSkU+sORdNRCCXi9cO100QDfbLvsIto
         BYJUrxepJw277cPGxzC7tLmShW0J2yA3Z8AbTb3GIWIrTWE0a7c53nhzWA/KsmsM3WSY
         tYhhJnb0jwB0/ZCbdjz48ML/+teBI3V7X3WLhLJ7HoFc8GzJ5gzPV7Z2+EN9wn6UEowo
         /AW47YiP7+zdtcIiOMuXltVarEIFmnY7nGh4J2ZVhVZDhezxo+NzBUWKMB/x44QtRoWn
         Wpdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779284072; x=1779888872;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gg6EIejukVN1UskEcFFGr4CnqhwTYz/FF3EfBDzQQN0=;
        b=q2c6dlQZmIvttuMQ0n+oAFx+GZXtO4NZJT1UHSgGEj4ERk7x1jjdKNg70R7g2KZOwS
         L+0IisX56Zy6Xho5J2RuNNO/fXlaXmPjY9TPIfZdiCthb14ufezkZ+AQsZEuf2izAbcf
         925jso/qWXGJ4zn08Wz1ggLn+M6QTTcnrr3x9iXbi/6LXrQCAuSLz16L60VE/PFzDfao
         dkHmEl8xLA0Pu3BoOrYDr8f1ng416FKHaLmk2mKcx0wykLxn2hGPmSJ0QpHWz0H7A7uF
         3DwTqLXYoep2OfOhiCpmg42+GcZCijgTYuHC/0pBXDqzySRXjJfG3jj5ytI3Cn6LDYhw
         N5/g==
X-Forwarded-Encrypted: i=1; AFNElJ/KY/rhBzdXebnDEFsY60uuKyD5DmVXr0gMZX3C06jFTqjITrAYdBzsm/FFpD5dmM/EZLLBGqNSZA==@kvack.org
X-Gm-Message-State: AOJu0YxsyIkpZOLkeOkXmu0Wh4i1ZuEN3IqifbmzTOnPE4iDLoq8Plyc
	DfEjTUvLHJSUnKsfFgYZpbJRA7YZJbay3bAiCvgtleWEppPzC+ETbP96epn3K7Ac9BTbighm06A
	kZoPslAUdghyo5JMbuSQc4M69vPUc2jv1EN0qhqdj
X-Gm-Gg: Acq92OFrRHfNz2VLAdghtwNGBrqqnG8vPWAomAnqQ43XFw9hGPZ397gZ1DE8wM0ZU1Q
	O1IFl1OpQy+hGEKQkVegs77G4olsrFI7tU9myY0x3aOqX6HdThYR6g0niR0fJLKumEIT/EFhl5P
	Gd5IiCuM65URgeRyPHiIrOie9wsMksdbPno1Fc2ArwyApDY0M3P2iOpcBFQfo8NbQtw/UZ1avie
	qhrL7FKHEgtB2SQ9lG9y49HgOfIprx58mNAIdC3xa7QItw9lurNflDl39MWrE4q6IRL4BeT6Vv+
	TYASyPqIrptxOx4sB50=
X-Received: by 2002:a05:622a:1f18:b0:516:5709:45e5 with SMTP id
 d75a77b69052e-516794404famr42713051cf.14.1779284071144; Wed, 20 May 2026
 06:34:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-6-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-6-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 20 May 2026 14:33:54 +0100
X-Gm-Features: AVHnY4LNSFj0RfEZst7XJ-H9igWv5oxnJFnr1A0Uux_hrTg7SmxNRLrzDdjcxpU
Message-ID: <CA+EHjTxvLU4XDPXDXYXXWJES1OFQgN8VTRLMgCCNMwBE6Hk8tQ@mail.gmail.com>
Subject: Re: [PATCH v6 06/43] KVM: x86/mmu: Bug the VM if gmem attributes are
 queried to determine max mapping level
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F1EF14000D
X-Rspam-User: 
X-Stat-Signature: y3399pnnf1guxbrbmmaqnfx6mfdbe34i
X-HE-Tag: 1779284072-462977
X-HE-Meta: U2FsdGVkX1//wnI/tLb3fB/VxDuVujRR4SK+o6oybstTqhsz458ubD/dhfegfZrIOFM7hC+51cvBFtH/bXaiWNhKcMRcy6Sajg/p2qcjFO++mn06ZDKJgEWHZq81elLdJyYgLE3qhLSS18mAXubraIFBmw/GE4GgyPx2gAsddZipAeYa04i373wd3jidlhvLKvQDof+dA+5elBxI7QXt/71YvKcXbBt0J9X4wlfRHe/2Qh3Hqo+A1uFxTD+e05dzjssof6jPG7hOjbf/MQ3HOjYfxVMETDsu51JN2A5x21dUCUO8zTP56bWA7ju/ESHX1KGGRw/VQkHCQaBbtWChP6Q7HdcEmEuxsSHViBGctptPkRlYyHEgI1vt2TUAiiQYTVf6oZZPUs7CElVVH6lUBOdxmkBTsjWqRA7/bZquHtfZce9S9VUdlfs1Nd40tlpgLDiJA0qzU3IOFw/tC6GEbCCp0QG75FJtyx4Pzqbngh2aE2tRTphxq27/rW+3kJYky8zIOL4QYdFH2Pq4qpkqtK4zLxkFztgBgDfLyrMkKKcQyK1bhHUwwBv55RFid0YsaRwTCFRgP2dDqNbm8whqGO79F4l/CvWqxJZSwrUS+8MyY2Lbh98QnxZSlyOR1yPR/nd3wXax/FKfTKBLAsu1JapxyoRbOiB58VV1Enl1rfC1jFcN/qNfxn4hop/lEUFM0mH479QXfWyltREM3SrlZ6jzPNOozz8k7nlmCxDnfGynD65cX81iBbFNDLt8geIpuE2+oNWFxXX7sVQbKTzaZ/sfavNM4bN0P8jKJZd7qQ2sU4I3TPk+h+59b/5Y/bCse7CIlHkt4+ywE/04BGdMWPdUvBRy96H7ly+TKq8bhW5FvqMnVMEFOwNr1myWQ0FIreMqm8U3lM4xm87AfhpIpUgBPs4CylJYmN/hpdWGf7v5rfPPrMWmcL9QjugHam9zh03cV5PNRLmkNNPiChW
 EWXG3vnd
 gSEZXm/61FL26JVLwXbHnXe7l5Lh3oQtbXTlJTlG+0M7gSGJm3znVXaVPtfvsco+oLLEkabhIKmMX7kYCyVA8GfLZ8cYY+/U4oq/a1CQunw6Y9Yl6tmuONcBS8MF/OvFUpfZdYQFhrn8JktplP2GiW8Lyt05MFPvGHu5hpuRPNnWV1o6LoUtDFd7PjPW97D7nnAS4lvCqfhM0hTPw0tuWW3YZx2pXvYoIFQqBIbyiSo4McfVdWYXXqVXMCgRIeIfXcchbQsk9UR5r0iWOyJi6mKcgtHFSEfCLDKJu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> When the maximum mapping level is queried, KVM's MMU lock is held, and
> while the MMU lock is held, guest_memfd cannot take the
> filemap_invalidate_lock() to look up the current shared/private state of
> the gfn, for these reasons:
>
> + The MMU lock is a spinlock or rwlock and cannot be held while taking a
>   lock that can sleep.
> + In guest_memfd's code paths (such as truncate), the
>   filemap_invalidate_lock() is held while taking the MMU lock, and taking
>   the locks in reverse order would introduce a AB-BA deadlock.
>
> Currently, the maximum mapping level is only queried from guest_memfd in
> the process of recovering huge pages, if dirty logging is disabled on a
> memslot. Dirty logging is not currently supported for guest_memfd, and
> guest_memfd memslots also cannot be updated.
>
> For now, bug the VM if guest_memfd needs to be queried to determine the
> maximum mapping level. This guard can be removed if/when support is added.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a80a876ab4ad6..153bcc5369985 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3357,6 +3357,15 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>                 max_level = fault->max_level;
>                 is_private = fault->is_private;
>         } else {
> +               /*
> +                * Memory attributes cannot be obtained from guest_memfd while
> +                * the MMU lock is held.
> +                */
> +               if (KVM_BUG_ON(static_call_query(__kvm_get_memory_attributes) ==
> +                              kvm_gmem_get_memory_attributes, kvm)) {
> +                       return 0;
> +               }
> +

This directly takes the address of kvm_gmem_get_memory_attributes,
which is only compiled if CONFIG_KVM_GUEST_MEMFD=y. This breaks
ARCH=i386.

Cheers,
/fuad

>                 max_level = PG_LEVEL_NUM;
>                 is_private = kvm_mem_is_private(kvm, gfn);
>         }
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

