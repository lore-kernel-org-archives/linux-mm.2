Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 867D6CFD37A
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 10:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4E2E6B0062; Tue, 25 Nov 2025 05:13:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C247B6B0098; Tue, 25 Nov 2025 05:13:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B146B6B0099; Tue, 25 Nov 2025 05:13:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9E3236B0062
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 05:13:14 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A7954FD9D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:13:14 +0000 (UTC)
X-FDA: 84148716708.19.89FF21D
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7C8A8100002
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:13:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NzTa9Myi;
	spf=pass (imf14.hostedemail.com: domain of 3NoElaQkKCB85GD79MTCGBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3NoElaQkKCB85GD79MTCGBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764065592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b/erQEEZyPzxAtDWVJKBMClg46msX9PfsRuYGXr+zPI=;
	b=wqzX2TIAtUBy6n0qcDtncep3d4kDsLAPsxKhT2RCbtVIW+Gpg4HeRzLR6OPX0h7rpSY0Yg
	dJRKWgJne4VcEZaqvMtuoOhszkjllQzjZ5+eNmQECv59XAagN4Zz585912TNaZwuW3+soy
	LVIeh/BYFe0JM73AGqn6VWVKx90n9/A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764065592; a=rsa-sha256;
	cv=none;
	b=FYWydu9dzfdKjJWxjZES/L/IEXQrFEf+LAcZW2YAnEhS3J2vlb/181h7z4ddMl/fPQq/zE
	ZF4BETlfBDN0n5jpb8AhBPYekjS+3bCpnfHv/CGKVEByBOVciRq4mIrUrLgtJRAGlS+uaR
	Aw9aC1XbDvrLVaj1LoTqHjEC1ehAO9w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NzTa9Myi;
	spf=pass (imf14.hostedemail.com: domain of 3NoElaQkKCB85GD79MTCGBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3NoElaQkKCB85GD79MTCGBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-42b2ad29140so3024208f8f.0
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 02:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764065591; x=1764670391; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b/erQEEZyPzxAtDWVJKBMClg46msX9PfsRuYGXr+zPI=;
        b=NzTa9Myi0iDQwbxq2cW1nRQ7r4IOiqYpftww3vnYgBSoDrTDa8s+dYa5cmLCIFbTk0
         qbps8V+2T+m6EDfvJd77lRvMcIInWyHi/+v08sob/+VaIyxJmqJYDsiw7pQZDjwwNxI+
         2Y1sjsgyXK75FBN0V9e4QOnmjanQgGf6FdIzSsFBqx/2V2ofCgxOhXdzTX40PUJNdU9T
         kJFFIADabBSwp31T1AyG3MSr0E2Q6oCBXrTd3YDNukxpFr85dIHIEKuLYnJp4xBqUubv
         TF9m9+GGNaBW872XJXZnolqhCKX7jiSUfTRVjeIe2euSC+LXTzZEzsVjvxjYCxXQHzJU
         i/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764065591; x=1764670391;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b/erQEEZyPzxAtDWVJKBMClg46msX9PfsRuYGXr+zPI=;
        b=ZxSPA4OgTVMHV3a5Wk0koOSdoQf10orsX8cHaBa+VQ1c9PgeGFLN1xC5+qg2UaFJdk
         HceTJfSofE5ZBI82wFn6UFRUfOAYhJcfOBw9pPDM4PGK0l6wBj5TDxRcpNUXVXcf/t5A
         w1nsSTquslexg1WISxhoecce/5ySf/980KjSXPXs8bcARmxWjA8R7q1N8UcZyX2Y5Ti9
         fz+yGJZZLCsCAwY/Ky9920o/o1FYSAetbGdwha9YO0p0leQam+scIXhGIkULUMOLQMrd
         VzkL5zHDHlqFmr/IECeUSK2SK5N+0eFKjF71fgLB/V+uB5rCPEV4ijfvLsi0Re68eZwZ
         upZw==
X-Forwarded-Encrypted: i=1; AJvYcCV20c4+fyVSarjal2MwOIdoy6AiWS/x2JSyC+jWyIgcFOWx/pb1OPS+jGFx4MqnUw1Ce968p50Lfw==@kvack.org
X-Gm-Message-State: AOJu0YyfpLBHy5uAQNqwwQhLCZ01qA/F+/TeYaxtF5Z+U2DNuXsLtz0d
	u6Oz1i8Ve96sJDWd/M8836vOm/gpZEVmc3JnxZUfqHPhq32DgycFsCJVqZXEe8eKIx1gOZOsWhL
	XzJ5FnznxkCv7HD634A==
X-Google-Smtp-Source: AGHT+IHsGtiL+iNDNVV1EqqG8i9Q6opGUyl7TTE27f4MhISajHThGLKjh7t7VU/7sKSZKE4kViLCm6zohC53wBY=
X-Received: from wrno15.prod.google.com ([2002:adf:eacf:0:b0:42b:31d0:1334])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:26c4:b0:42b:2f79:755e with SMTP id ffacd0b85a97d-42cc1ab8874mr14661798f8f.3.1764065590345;
 Tue, 25 Nov 2025 02:13:10 -0800 (PST)
Date: Tue, 25 Nov 2025 10:13:09 +0000
In-Reply-To: <cover.1764064556.git.lorenzo.stoakes@oracle.com>
Mime-Version: 1.0
References: <cover.1764064556.git.lorenzo.stoakes@oracle.com>
Message-ID: <aSWBNSbXrWJnpsRl@google.com>
Subject: Re: [PATCH v3 0/4] initial work on making VMA flags a bitmap
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
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C8A8100002
X-Stat-Signature: ox3fiw6rochbydj11ozpng7ses78tq9j
X-HE-Tag: 1764065592-585909
X-HE-Meta: U2FsdGVkX197ZRIXzEhw+kM2xLuAmMWiuIxjXzgb5ifHh1H0D33j5LZO65sLTsQltfZJjkk8O3NHeMCSvlyKTo1uW8iydcrysuMd7tGIecNXBcsDhe+U34gDH3yRibnyhM42VWa/BMDsjfApyc50+VMWglOJctHeHaxGISQ4zO8clQeJHJ1JKixkfcNVx7MmNTUtgARqSh+1hIOw4Wf60H6K6rZxtmGtAAoz6kRRB5iEGE5EENUJZ5z7uAwMC00rc6O+j5jYrIzbusr1+D6i52JfAdOG91TYEtl5cexBsGxxvbLuzEzuR2w4Dr0am8sJfJxN66tBLTWxP8IVhCRkwQpVvr8l21tpJGg3jpvn5628lo8G4npqz/oKq98O9Pp/snkXwT0ZrPj1nXIhLBKUY+f3uXydDxsL+LNJrM4+1pJTDPgy6/UPcNWT9Ynh4K4kZ4c/Ahh1+O5igAQwvi6A9JrTkkik1hsPHaAT9EXTjYsA+J7fTl2QGF3G+xWvKDHEmoJs+mMTpzZo9SOodkP8Fi+47d1E4HiDHZYdJypnBA70lRhqNNSPmjnga1ufpNr3qpm/7bqrsdYacqgja8zHjYFwasKGVPqmjsjqYfBGEOsBIFSAQTYlmOPmCxidvLZ9c4pSy9dFK63OatZJsXS0aCt4UIep1gRyEnu+ytUpMhOl87T5bXXIEh1xMtuBHzXCb6Z+SvTS523FMEt2Lukwpb6VUFeuXL3z/DcLjYThZiikGCsNNfCRmZokWImeE7vnbiqO1OIva0kRZ+LDCHQ2PTaQG4YgFMmsfDhui07whuc3TGBASGR81NmH4gch8BrWGLmT+aW95cBmQzHlsOwwOnvEiQ+bHbqk5W+MCYfIw7Ld1yERa9aNcCeLWFnhts9ikOuwtNsQQnAaqs9jIyKCG1jm8p7xfW4e/ty/6Bisa8SB3RKJx5Ls391IurQLH0zr/s7X1HcyBEPZOgEg5wj
 PkLdbA+z
 jhdOiio0jxCe6YpzogfgYZEGF1pF888y5/H/BttU6xDe5mIeVVmIb4b2+n2825as3qu/uNtNtk1yQkTxjPgNR8KxIVv1dcbfhJ4XqEUPn9otPIcozU6tow/ZWNU9zd6Je87e73/qPGQPFLXmLgsEcEbJ5Ba1ihAwoGoAWS95vCIbZNpPsNOJa5nGbwY0phftubdQrkht4/pUZXrFDcvn1/n46q2Eh21Le+PgJnuQbjcrPQF6t2QpP0u3vPeuhrzQYht3C/AL/+3IRR4lc9/td6otoSSj/nfQitVE5Ovio+G/CphWyct4aRU25bmwKWC9DnOIhwCJc4fqJwFNypW7f1ZihFbbpL+RxeCQPQRoByfk0xwwPMLCKA+luc2JHvnuDC0ByIvzFNTzdv4p493H4gHgvakrf/+XMcRAtcmDjifRQknZnhkhoQJSdIqFY1m09mCy8JH1u79LBm87oSWPucfrrwpDe3R9GB14Th7n0TO2/LmnP0yi27rWS+2BWzrJVpiXfJxYgqjE/Q3kE6R+aL0jvgX8fDNtsdFqCBQJ9kkf9bxuEWEp7z+AI3xeonzlrj3TFSXkvS9Kn8TdQweBpWFTDHhBWFgnMLtzSJHFtSC95REX4i5ufoqzBdcrmrDd4z/Yf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 10:00:58AM +0000, Lorenzo Stoakes wrote:
> We are in the rather silly situation that we are running out of VMA flags
> as they are currently limited to a system word in size.
> 
> This leads to absurd situations where we limit features to 64-bit
> architectures only because we simply do not have the ability to add a flag
> for 32-bit ones.
> 
> This is very constraining and leads to hacks or, in the worst case, simply
> an inability to implement features we want for entirely arbitrary reasons.
> 
> This also of course gives us something of a Y2K type situation in mm where
> we might eventually exhaust all of the VMA flags even on 64-bit systems.
> 
> This series lays the groundwork for getting away from this limitation by
> establishing VMA flags as a bitmap whose size we can increase in future
> beyond 64 bits if required.
> 
> This is necessarily a highly iterative process given the extensive use of
> VMA flags throughout the kernel, so we start by performing basic steps.
> 
> Firstly, we declare VMA flags by bit number rather than by value, retaining
> the VM_xxx fields but in terms of these newly introduced VMA_xxx_BIT
> fields.
> 
> While we are here, we use sparse annotations to ensure that, when dealing
> with VMA bit number parameters, we cannot be passed values which are not
> declared as such - providing some useful type safety.
> 
> We then introduce an opaque VMA flag type, much like the opaque mm_struct
> flag type introduced in commit bb6525f2f8c4 ("mm: add bitmap mm->flags
> field"), which we establish in union with vma->vm_flags (but still set at
> system word size meaning there is no functional or data type size change).
> 
> We update the vm_flags_xxx() helpers to use this new bitmap, introducing
> sensible helpers to do so.
> 
> This series lays the foundation for further work to expand the use of
> bitmap VMA flags and eventually eliminate these arbitrary restrictions.

LGTM from Rust perspective.

Acked-by: Alice Ryhl <aliceryhl@google.com>

