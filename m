Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F902CE7B0E
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 13:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4152D8E0008; Fri, 14 Nov 2025 08:50:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ECD48E0002; Fri, 14 Nov 2025 08:50:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329F38E0008; Fri, 14 Nov 2025 08:50:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 236D58E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:50:52 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF2564CE61
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 13:50:51 +0000 (UTC)
X-FDA: 84109348302.04.5492DAD
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id ED733C0011
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 13:50:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="So2HB/Hk";
	spf=pass (imf10.hostedemail.com: domain of 3tzMXaQkKCMoq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3tzMXaQkKCMoq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763128250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aRrI+zvBboCdfdse/X2BfoaixhuDzfAQTP9joVyOmZM=;
	b=dq6l3M/049RpwdWCYR/EvQ0D8HsM/PuiqJnrB13F9daxJa5i97MAwe0GXl1QbZ6pya+VYm
	o+1BsTrO6jm27BufJ5KCtPdF9R0x1OmsMApn1Oy5CJC3xOOgBFWYFNeO0TFGaSUbdWrsD4
	ekpnXzsynRH8ej9hU/0oxxS6ADl3VaE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="So2HB/Hk";
	spf=pass (imf10.hostedemail.com: domain of 3tzMXaQkKCMoq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3tzMXaQkKCMoq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763128250; a=rsa-sha256;
	cv=none;
	b=dGlhQWINfSgnA2EkivTcM5GtkAsh6y7PYdzFzLx7W/7Yw96U+vrVpIZhjr0ijexUv/fCPE
	w4t4iKFW7RwpeEqiZLPyLjWjUpzw89aj5jH7zbWGBauLO69pdBjqZm1TYEn4Bw8w5nHIsx
	TgN+heqWB/N9GRYn86nUu+jrx+C8J+g=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b30184be7so916344f8f.2
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 05:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763128248; x=1763733048; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aRrI+zvBboCdfdse/X2BfoaixhuDzfAQTP9joVyOmZM=;
        b=So2HB/HkFL1PtBE0xoJsvSBCyRSWY6Nxp56sQx3uEEKuOcbTlYSWUuWrNGTplItLaW
         R4HzC5TDbHxQkO+sj1xHkrJyRi+wocZpNNFLHxPXnvMM5Z3m+kobcynPZYAXz4Pz5QW6
         dXTN3k33HfSxl8S099FbcbTsEUfTvMxNSWxSErJ2zlkOA0WvR7ppl5OvrD+3WxWU+OH1
         m2oxX2oPB099oPDC7VCO6LAJbvYNx/S3PobSCmyXGkJ7hGDJ3ySj/w9Xj5XaqlyF+apc
         mFuPlvxZ4zSdqO7JETEZUdgmN6XncE1TEjb4xpHMiVv1EPhsjTlxFH5tKgoeAPvT02xh
         XBtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763128248; x=1763733048;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aRrI+zvBboCdfdse/X2BfoaixhuDzfAQTP9joVyOmZM=;
        b=Bw6GS0MsU0xnlhUk2ALprd1qBGoABFs1NiEo3wY92mWAbWn3a+usrqsOk7Dpe3cRuP
         UJPFBPwnc8gv2AwzjqAg5JcupQs/Hc7CNwxcHScm48pY0f2MHos1Da0j/BDVHzc3rSzk
         ypzP/C9aCuUYmPOF4VkVa127+2iEiC7KF4RGrGb2Z+UxWatRiinYij+35KqFG5CVH5jd
         buX4d3d1Se7KKTpBSPLhz1+xHNxqwHXF4MEdAHLFYwGK3vQnMOAI/9stBKueaI5FvmV7
         4o2qisUKZJ6pwxHkF4pm+GrcOJGd8aGQblZmJrzfinAu12JtBXqvZCT8eb2UZ9GS0YRL
         jWlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQVakt+XIUF/+Py3UCe9rmoSt9vZa+f3lWMl2WfaeN5MfvmDWCu9T5HI4csXWkvy9UGGiPPp7SNg==@kvack.org
X-Gm-Message-State: AOJu0YxzX9wYngrzsbooCcaqdvot6bQBzEFOYup2b0Bhn0GBdEIa2IPd
	/ZFDlnT2W+CWs/YyxHxZ7ZXz7FMUyPEJ2+HL80YmqC+cikgP8Csmr23uO+uzlSk/SWoRtQ1LggS
	6LN/g386kX0vPdgKxIg==
X-Google-Smtp-Source: AGHT+IEy1IzfqWatibDXEefRnIBkZupbkLV4W34pV9YXz3HKgkrUUbyPksPnt2imV3NkIkiiyQrvQWIxaug0o/A=
X-Received: from wrrn3.prod.google.com ([2002:adf:fe03:0:b0:42b:585e:3ca8])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:144c:b0:42b:39ee:2889 with SMTP id ffacd0b85a97d-42b59374c26mr2988918f8f.48.1763128247691;
 Fri, 14 Nov 2025 05:50:47 -0800 (PST)
Date: Fri, 14 Nov 2025 13:50:45 +0000
In-Reply-To: <6289d60b6731ea7a111c87c87fb8486881151c25.1763126447.git.lorenzo.stoakes@oracle.com>
Mime-Version: 1.0
References: <cover.1763126447.git.lorenzo.stoakes@oracle.com> <6289d60b6731ea7a111c87c87fb8486881151c25.1763126447.git.lorenzo.stoakes@oracle.com>
Message-ID: <aRcztRaDVyiDO7aH@google.com>
Subject: Re: [PATCH v2 1/4] mm: declare VMA flags by bit
From: Alice Ryhl <aliceryhl@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Kees Cook <kees@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Pedro Falcato <pfalcato@suse.de>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Rientjes <rientjes@google.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Bjorn Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ED733C0011
X-Stat-Signature: gnw9bmsek6utk5hi9cwg8ebdpd7nu4zr
X-Rspam-User: 
X-HE-Tag: 1763128249-797740
X-HE-Meta: U2FsdGVkX187mh0pQ2j5GeEXG1VWi/LGdOAKx9tfpyPSbmMaMKdoEciDP7arFbtcPqk+B47zSWzH/+nl1egOJ2vLHJEp2ELfTnfD+aNJLt462j1NCGOPGNS4IuXpuLEJkd44I5Fo+gJVug6r2dIARlRuANbkQfYqIus6uYLaNCV3aLYk4yx14ruu1GlTcNS1v4vdfw+PMoBeeKLa5JIhw03XOJ35U70eGXOOqbge+Q2tco1899Mv9l9K3o448hWOb8kbJKgW7bM5q/0lZiXTBWyC1+ouKha3McU+vQbmB9kbHGKGpKwh5Jep6+tcz/kVY1P1DQWybFSdYjvrLIPVUCVrFdEsDlkU0OfqTpPOHJSz7vxa/jp+GdHcI18rDlKiNNLXmTBbgF/hVJRXMXbFJCHL/Y0NjbVZsY7Q5mwWeGoyZXx44pa1aE2YKWipZ6leyMCCqwxxN/i631MDmbgwpWTR2fcECF5g23EKtOJLKvtKnIdbd7I2UYy3Md3GPiMNUO/b8Wj4gZmchJU3TG0xbxk1QcUmiM8Po5HwIRNzxm7XrTQM5gItV3KdUCKK/bu0eRzpimW4YXBKmVXWGtNPWgR+di0vBnyKJ0l+157vCPunfU5RU8uk4D/yPpSFqjw23VbNmy5CivGrNxft2G64by5zCnmwAGL7nq8cnghiT8XWshdqMSuYgNkz4EzUSlcyZmSqGaJroaxERjnURekZgg/RP7jcRRkgIJgX06Mnk6lLFoF11/zTYGvGDgF39ooX4WRxY001FsqdmKxY/Ax+IW3gsOU8vBQpfv5Lg1hPyTfiJ+BfZT0ZdVCV+2gb3eTRmEDtWtri1hqqw5EFyrgpLk8fuLgdtSfprt1nd47+h6rF49cEUjcFgUXFFwHk5rXvi51+/MSpTOPJzYQ9RvuGm+UnZCkXqbdlahkYt8c7Jx2+Qqjrt4eb8mH47Rj8988vo+VaD6qCfcTq0+zhG6g
 NCt6njNd
 rTSvRGshEHNRzo9blzE0Fdji/6uEJ0Jzt/H4/+xQsEmtSNAu2AnGphD6tvuO2G1PwHQvxDg7m4LjjWHUTvxux7kufyiwLm/3SvnlkMtwsTdtjsbSikHv/lUo4C/p6Aun8RYTWO2tyODXwdBLewjEFRNltsHTusSiZNLo6m2nPt03zN76Rr+GBtRaCzJyHJZu4qdF5jMYAblcf8nH2kOEsRqUYXBrS4zMhP1Hu+CQrXYGkAWX8Ps1mzE2JkX89rRUCQSYfvVXmvzGyRIaqYVTDzb+jWC9uvr4Qf/pgDbsvwYZ1has/4dyyfLWVuDTX4f8F0of67auRi+GlabVBsncjtCdnhX1JlWAQeS1g3j9JHLWhZHFrGEqQu2jKlZ1fPu6wTIbTcrygOAhZ7E4yFISUxra5VyaVOHz6Fw8a23+zPcNzeAFyMM4JNeSm0amkwVbK7g+NiQTd8hWsRkpwSgOeJGoQdtmSR3ZqsDxx4j0J8nqkAO7CW/pB7cmlpxb1JXfOTH2/04MDaewPa0Cuz0b6HxxX+mc940k1oPt3NW3lIAL1Gib01dYZA0HhYFsBgINiPHzEetn1LOYoHIUwxhssc2skntUazJMyuVvI2qgejfJl1KL6sdQosyPqlxgVAcJ8N1AbQFlceNfy+Jc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 01:26:08PM +0000, Lorenzo Stoakes wrote:
> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
> index 2e43c66635a2..4c327db01ca0 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -108,7 +108,32 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
>  
>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
> +
>  const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
> +const vm_flags_t RUST_CONST_HELPER_VM_READ = VM_READ;
> +const vm_flags_t RUST_CONST_HELPER_VM_WRITE = VM_WRITE;
> +const vm_flags_t RUST_CONST_HELPER_VM_EXEC = VM_EXEC;
> +const vm_flags_t RUST_CONST_HELPER_VM_SHARED = VM_SHARED;
> +const vm_flags_t RUST_CONST_HELPER_VM_MAYREAD = VM_MAYREAD;
> +const vm_flags_t RUST_CONST_HELPER_VM_MAYWRITE = VM_MAYWRITE;
> +const vm_flags_t RUST_CONST_HELPER_VM_MAYEXEC = VM_MAYEXEC;
> +const vm_flags_t RUST_CONST_HELPER_VM_MAYSHARE = VM_MAYEXEC;
> +const vm_flags_t RUST_CONST_HELPER_VM_PFNMAP = VM_PFNMAP;
> +const vm_flags_t RUST_CONST_HELPER_VM_IO = VM_IO;
> +const vm_flags_t RUST_CONST_HELPER_VM_DONTCOPY = VM_DONTCOPY;
> +const vm_flags_t RUST_CONST_HELPER_VM_DONTEXPAND = VM_DONTEXPAND;
> +const vm_flags_t RUST_CONST_HELPER_VM_LOCKONFAULT = VM_LOCKONFAULT;
> +const vm_flags_t RUST_CONST_HELPER_VM_ACCOUNT = VM_ACCOUNT;
> +const vm_flags_t RUST_CONST_HELPER_VM_NORESERVE = VM_NORESERVE;
> +const vm_flags_t RUST_CONST_HELPER_VM_HUGETLB = VM_HUGETLB;
> +const vm_flags_t RUST_CONST_HELPER_VM_SYNC = VM_SYNC;
> +const vm_flags_t RUST_CONST_HELPER_VM_ARCH_1 = VM_ARCH_1;
> +const vm_flags_t RUST_CONST_HELPER_VM_WIPEONFORK = VM_WIPEONFORK;
> +const vm_flags_t RUST_CONST_HELPER_VM_DONTDUMP = VM_DONTDUMP;
> +const vm_flags_t RUST_CONST_HELPER_VM_SOFTDIRTY = VM_SOFTDIRTY;
> +const vm_flags_t RUST_CONST_HELPER_VM_MIXEDMAP = VM_MIXEDMAP;
> +const vm_flags_t RUST_CONST_HELPER_VM_HUGEPAGE = VM_HUGEPAGE;
> +const vm_flags_t RUST_CONST_HELPER_VM_NOHUGEPAGE = VM_NOHUGEPAGE;

I got this error:

error[E0428]: the name `VM_SOFTDIRTY` is defined multiple times
      --> rust/bindings/bindings_generated.rs:115967:1
       |
13440  | pub const VM_SOFTDIRTY: u32 = 0;
       | -------------------------------- previous definition of the value `VM_SOFTDIRTY` here
...
115967 | pub const VM_SOFTDIRTY: vm_flags_t = 0;
       | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `VM_SOFTDIRTY` redefined here
       |
       = note: `VM_SOFTDIRTY` must be defined only once in the value namespace of this module

Please add the constants in rust/bindgen_parameters next to
ARCH_KMALLOC_MINALIGN to avoid this error. This ensures that only the
version from bindings_helper.h is generated.

Alice

