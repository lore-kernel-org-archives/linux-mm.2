Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 637EBCCF9EB
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 03:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A58818E01BB; Wed, 29 Oct 2025 23:07:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A09348E01B2; Wed, 29 Oct 2025 23:07:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1168E01BB; Wed, 29 Oct 2025 23:07:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 748288E01B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 23:07:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B0DD1A018A
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 03:07:40 +0000 (UTC)
X-FDA: 84053295480.14.B66844E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id ADBAA1C0007
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 03:07:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eaz064tm;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761793657; a=rsa-sha256;
	cv=none;
	b=DwK6z9Zy94bYsF1wOfLiZOgyp3Az0Bk7hyetCva5/6r1gME2dx2T5MZk0pLnhDMp4L/bqB
	hHfNgl1auvZMdzXopWQ7g+vxZrxzi2uL4McQLk6skcvEjn+YkrNvN38BEomv02Zp90Bg4e
	pnrq3y2x9qTwzGkeMXGn395Cans6phI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eaz064tm;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761793657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wN0XWQ1N0rtxB4cj1GaEpvY3UQhVabXBsS/QmbEqpk=;
	b=PrBsRtxGvBeiEF4WwNY+P7sZ8Awxf7oNaSsePluxVATKaYCY9onCGPSjqXqtEfihBa3/4F
	OfjnNINzbf0kDjICpC9mTF+6j8eDKoylmyG3wtj3BD7OPUn1SOQvQaqXBnRwOFTd67Ir7z
	tCHSgzb7z1RhKsM6swJvRlxV/7kqles=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761793657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9wN0XWQ1N0rtxB4cj1GaEpvY3UQhVabXBsS/QmbEqpk=;
	b=eaz064tm7hYNBF30k+bmcWVMkSqIpsiyOJ+nmTwIGUYBdXJ930DGjyjTJPakHuV9W5LZZt
	tlSuho9V5X1DvpfwqnqkzTnd1ZhQz8wfF2Te04wt1MqpJxvWr3RROtyCGnW0ZTXprtZVSg
	StefAhGuVfiMqRd7SGQYQLBcUHT9Pqo=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-sNAlZ7QKMKOfyhr6X243_w-1; Wed, 29 Oct 2025 23:07:35 -0400
X-MC-Unique: sNAlZ7QKMKOfyhr6X243_w-1
X-Mimecast-MFC-AGG-ID: sNAlZ7QKMKOfyhr6X243_w_1761793653
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-7848b193cc5so32232077b3.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:07:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761793653; x=1762398453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9wN0XWQ1N0rtxB4cj1GaEpvY3UQhVabXBsS/QmbEqpk=;
        b=RXUV9Qck/FPRlg1OFylQzlPwP93FI7wkfNarpZ1nxs+qkMrFqpszchO0dlCyNZPkLg
         MUSHXG2R/4xtwUQC3HN7YmWYfz2pQpxQBfvoyL6k407h5K1PTkdj3TP3FYMAsPlbLW0l
         0KbddjeA75SdlNxYDGQ0IVHZqhCVuqovqAk4WljnBkrY0+T0Gndwpzu0W3Qh+l0FC4T5
         tPsOsBjPUE8pCaXYR95XPC0T+dJbBfF+nv5NV2AjJpvkX1BxwVyiq9sH39pTQC/wJtKN
         UYwwA0qDHT8agJZo/FIbxrKaVOtca07i9W7Et/x2DktWIs4yLYipO4Pe+PiYbe7cz1/b
         k/6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWwhgE0wI1jKinc3SNlEtDmEnmSJyzXgAK8LbTCibxktkpXk9LnBjXmL97PUsqRpOkcvgg+m9d/Zw==@kvack.org
X-Gm-Message-State: AOJu0YzKZfwuOUZqfn5OdhazoRYsqpzDxyvQKbidB/gaZLRxsdjdi85U
	J7S01uV0POyMURamt4R1+phOmIrZCjDRBFcBJHCmdI/3/AWC4YGAMSp74Vf55Yv4mwoaunMoqXv
	WAzKlG0lHi4ETaH0nAa+pVnvdI+kvY+ncLmKYF0sRKed3hOVmBowR72yhSRUn8GiUSDfmr+GHWF
	jr8V95SKS5DeNDiziW4bT5YrkVbjE=
X-Gm-Gg: ASbGnctvqinBFLrWxXnmpylK/1WuhuhdxPtCbRHsax+JMSBK5duaDRMXarDc5NLOIzl
	Qp/dmfVj+lXSDOqdis/RKyRDnA+9UOjUl6WoNjSY+cZ4CywRgO0w+Nlj8bQDTrPxOdqIZbg5jLw
	hiCVULTB5VeDrbx1Zpus+Vf27Bc2ZyL+kQ2yJoEuYSmVSx0AIZJq48lOT1sqKhsbR55Z2N8A==
X-Received: by 2002:a05:690e:1248:b0:63e:1521:c29f with SMTP id 956f58d0204a3-63f829a2809mr1659577d50.17.1761793653277;
        Wed, 29 Oct 2025 20:07:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEC5CkcBnh/sb8uhkM3WgOJU7Y4/I4RGXP2TJxmJQ2XYo9gh6ekWqrMeIKQHHjyKjrwn97kwUnbrionRddMKeM=
X-Received: by 2002:a05:690e:1248:b0:63e:1521:c29f with SMTP id
 956f58d0204a3-63f829a2809mr1659506d50.17.1761793652731; Wed, 29 Oct 2025
 20:07:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1761757731.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <cover.1761757731.git.lorenzo.stoakes@oracle.com>
From: Nico Pache <npache@redhat.com>
Date: Wed, 29 Oct 2025 21:07:07 -0600
X-Gm-Features: AWmQ_bmIFH7DQx94H00ZendIrBM5Leqedwdezzz2vnEqWrhrlST8xh1cZBn-MjI
Message-ID: <CAA1CXcCiS37Kw78pam3=htBX5FvtbFOWvYNA0nPWLyE93HPtwA@mail.gmail.com>
Subject: Re: [PATCH 0/4] initial work on making VMA flags a bitmap
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
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jann Horn <jannh@google.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Pedro Falcato <pfalcato@suse.de>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Rientjes <rientjes@google.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R5mLtxWdlYJ7Kj1AmmxbFKjZq9KxJsGKxq6VTU3Yrlw_1761793653
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 7rh5ffh16yf8m7cb66nr48jx8psy4dsp
X-Rspamd-Queue-Id: ADBAA1C0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1761793657-281598
X-HE-Meta: U2FsdGVkX19W3HaBm4dVImTaaN7DgCX5k0MXc5LUTz+QJxgdtxW97yT53DsU9wCPrgg6rWH/0PsJK95r03UoUHH3ywXIFEigq5vaxGu92dv1uFXMNdPv3Tr+XW55ORhZtoeK2jvgroPxw4G02Ja1gKkcp4rYN/uIcvN6LxrxENMxDYEecmYS96fy72pRm6qZY6zLAY9Smqa2vr2TWvH2TR+CiyGWDj3KUGgy0+2AXCW10XTeiXHpbjkl6/g+4zm+CMirsIOeJ4vARrSAnrWxBGeDGZ+VfOezZ8T7IyDOl39AuNwyGOrjXze70fkPXd5aAyrP2Xti9f5zk+dMpG1ZwfZwY1Yvdfdv896LfCzJN6y9X/Krxk2/dI+1pQQyxZXmedFgg1ZDpfKsREAg+946l0VdujRtPnby82iW/dm+IubHZiI42Vds/BIVl0SVWrKrUHhgOzcHsbubG3M7cPDHa/PqbW+4CSQMWWpdF8IJQcpbS8hmU4fiBoxFYC+DkR3FOfBpiL97G+ugJ1SjIeRzOeiYAWiudocCpRuC5+0QR0bC7rUWBWsJYOLFPBb4uRE9ut1lvClEehtAoe/S7ek9NXqM57m35CF2rtAhDubLXirFzNrjYSYoqN+G3dtElqSUNBSEt79kSAMF8nyN0Gi2mD9vVKX0GjOsHQ7cNusI5UXuqLKUKYLhtl1fqEBiidZBji6f3ckl2NC3X8C8RwKpl9U4iURQ/QIqlcCsrqFwrW0VMW8ymbwKzPjEmdELtkA/I2BolKhDgZliyHgWfBNG6AIz8FhYlcIAB0vriz2ml4SUXEvyzWHz2iGRCr4gmqDjKrbm2RWkJXy5IvoXBTtkZJC3PBThvOZerInW00BUNsnnfoGmhHxYuBURuvW9bCSHQg06J3eqJhbVMjGU83d4WTWLeNqd5p6JrKM2cBwURDYx2klshxZzM9UTj+JhG35Dt210ziwM8ycA75TJbuo
 bGF8q7WG
 pBbbTRGHKaSUn3Bb+hvUaTYUnp5Y8Cq3mrcJQ97SVIKNYJOPrQoMr2/EnhB/idBDqv6dGSGnOkDcg13R88Nki1PfvL1zy/E8xzR1uZp2aO+1eeCRkSkF9d/nOh3HQUMNWfbuWlVnS4L+CXoGhgs0HZPlcSGCkVMOWOU6HpJLM8lRPGwNQoY/ey5mU34UWzEUenea0sCjprQCGN4Fm0/mvzvxFgCxF7FIP1k+2W+mET74KLhKUVrvxWFBdJjGyLktrmk53Oq7xwv1QwUJKO8tcD50ANUoAAlTqcVOPkqDxCD9smdA7CFMu9mh3CNTw7EKatxvDh3bmMpGrxx/bFee71quVG7Ni8GRellewrcUkjrlnfXb1cgHKgC49d+7rueJvvKn7TnFq1iGr3gI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 11:50=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> We are in the rather silly situation that we are running out of VMA flags
> as they are currently limited to a system word in size.
>
> This leads to absurd situations where we limit features to 64-bit
> architectures only because we simply do not have the ability to add a fla=
g
> for 32-bit ones.
>
> This is very constraining and leads to hacks or, in the worst case, simpl=
y
> an inability to implement features we want for entirely arbitrary reasons=
.
>
> This also of course gives us something of a Y2K type situation in mm wher=
e
> we might eventually exhaust all of the VMA flags even on 64-bit systems.
>
> This series lays the groundwork for getting away from this limitation by
> establishing VMA flags as a bitmap whose size we can increase in future
> beyond 64 bits if required.
>
> This is necessarily a highly iterative process given the extensive use of
> VMA flags throughout the kernel, so we start by performing basic steps.
>
> Firstly, we declare VMA flags by bit number rather than by value, retaini=
ng
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
> system word size meaning there is no functional or data type size change)=
.
>
> We update the vm_flags_xxx() helpers to use this new bitmap, introducing
> sensible helpers to do so.
>
> We then provide vma_flags_test() and vma_test() to allow for testing of V=
MA
> flag bits, and utilise these across the memory management subsystem.
>
> Since it would be entirely inefficient to do away with the bitwise
> operations used throughout the kernel with respect to VMA flags, we permi=
t
> these to exist, providing helpers for these operations against the new
> bitmap.
>
> These operate on the assumption that such operations will only be require=
d
> for flags which can exist within a system word. This allows the fundament=
al
> flags to be used efficiently as before.
>
> This series lays the foundation for further work to expand the use of
> bitmap VMA flags and eventually eliminate these arbitrary restrictions.
>
>
> ANDREW/REVIEWS NOTES:
>
> Apologies, but the nature of this series is that it's going to be a littl=
e
> painful, I've based it on [0] to make life a bit easier. Let me know if y=
ou
> need rebases etc.

Hey Lorenzo,

I put your patchset into the Fedora Koji system to run some CI on it for yo=
u.

It failed to build due to what looks like some Rust bindings.

Heres the build: https://koji.fedoraproject.org/koji/taskinfo?taskID=3D1385=
47842

And x86 build logs:
https://kojipkgs.fedoraproject.org//work/tasks/7966/138547966/build.log

The error is pretty large but here's a snippet if you want an idea

error[E0425]: cannot find value `VM_READ` in crate `bindings`
   --> rust/kernel/mm/virt.rs:399:44
    |
399 |     pub const READ: vm_flags_t =3D bindings::VM_READ as vm_flags_t;
    |                                            ^^^^^^^ not found in `bind=
ings`
error[E0425]: cannot find value `VM_WRITE` in crate `bindings`
   --> rust/kernel/mm/virt.rs:402:45
    |
402 |     pub const WRITE: vm_flags_t =3D bindings::VM_WRITE as vm_flags_t;
    |                                             ^^^^^^^^ not found
in `bindings`
error[E0425]: cannot find value `VM_EXEC` in crate `bindings`
     --> rust/kernel/mm/virt.rs:405:44
      |
  405 |     pub const EXEC: vm_flags_t =3D bindings::VM_EXEC as vm_flags_t;
      |                                            ^^^^^^^ help: a
constant with a similar name exists: `ET_EXEC`
      |
     ::: /builddir/build/BUILD/kernel-6.18.0-build/kernel-6.18-rc3-16-ge536=
42b87a4f/linux-6.18.0-0.rc3.e53642b87a4f.31.bitvma.fc44.x86_64/rust/binding=
s/bindings_generated.rs:13881:1
      |
13881 | pub const ET_EXEC: u32 =3D 2;
      | ---------------------- similarly named constant `ET_EXEC` defined h=
ere
error[E0425]: cannot find value `VM_SHARED` in crate `bindings`
   --> rust/kernel/mm/virt.rs:408:46
    |
408 |     pub const SHARED: vm_flags_t =3D bindings::VM_SHARED as vm_flags_=
t;
    |                                              ^^^^^^^^^ not found
in `bindings`

In the next version Ill do the same and continue with the CI testing for yo=
u!

Cheers,
-- Nico

>
> [0]: https://lore.kernel.org/linux-mm/cover.1761756437.git.lorenzo.stoake=
s@oracle.com/
>
> Lorenzo Stoakes (4):
>   mm: declare VMA flags by bit
>   mm: simplify and rename mm flags function for clarity
>   mm: introduce VMA flags bitmap type
>   mm: introduce and use VMA flag test helpers
>
>  fs/proc/task_mmu.c               |   4 +-
>  include/linux/hugetlb.h          |   2 +-
>  include/linux/mm.h               | 341 +++++++++++++-------
>  include/linux/mm_inline.h        |   2 +-
>  include/linux/mm_types.h         | 120 ++++++-
>  include/linux/userfaultfd_k.h    |  12 +-
>  kernel/fork.c                    |   4 +-
>  mm/filemap.c                     |   4 +-
>  mm/gup.c                         |  16 +-
>  mm/hmm.c                         |   6 +-
>  mm/huge_memory.c                 |  34 +-
>  mm/hugetlb.c                     |  48 +--
>  mm/internal.h                    |   8 +-
>  mm/khugepaged.c                  |   2 +-
>  mm/ksm.c                         |  12 +-
>  mm/madvise.c                     |   8 +-
>  mm/memory.c                      |  77 +++--
>  mm/mempolicy.c                   |   4 +-
>  mm/migrate.c                     |   4 +-
>  mm/migrate_device.c              |  10 +-
>  mm/mlock.c                       |   8 +-
>  mm/mmap.c                        |  16 +-
>  mm/mmap_lock.c                   |   4 +-
>  mm/mprotect.c                    |  12 +-
>  mm/mremap.c                      |  18 +-
>  mm/mseal.c                       |   2 +-
>  mm/msync.c                       |   4 +-
>  mm/nommu.c                       |  16 +-
>  mm/oom_kill.c                    |   4 +-
>  mm/pagewalk.c                    |   2 +-
>  mm/rmap.c                        |  16 +-
>  mm/swap.c                        |   3 +-
>  mm/userfaultfd.c                 |  33 +-
>  mm/vma.c                         |  37 ++-
>  mm/vma.h                         |   6 +-
>  mm/vmscan.c                      |   4 +-
>  tools/testing/vma/vma.c          |  20 +-
>  tools/testing/vma/vma_internal.h | 536 +++++++++++++++++++++++++++----
>  38 files changed, 1037 insertions(+), 422 deletions(-)
>
> --
> 2.51.0
>


