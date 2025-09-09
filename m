Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13BD4CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 16:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D9158E0015; Tue,  9 Sep 2025 12:43:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488CF8E0001; Tue,  9 Sep 2025 12:43:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 377658E0015; Tue,  9 Sep 2025 12:43:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1FF428E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:43:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B31571A06CE
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:43:42 +0000 (UTC)
X-FDA: 83870283084.19.5BDA865
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id B34341C0008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:43:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=odigRXg1;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757436220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X9zR1ns6r4tli6kgpMkZXeVyHg9onE4yZmroH/q5x2E=;
	b=E0MkX05KiwolFao46WZZpM4QsoFPA62vGSu4/DEgBcy8p0D/M7cIB6CLInkqpfBuHN6MOK
	6P7QWT1RJ+yJC8n4Gxdvt0Q2qqUkLeVi5bKr8yGGAtWBflM15O2Qdjw+6Ms+IoZRscwl1d
	UOAcqxV/yJZgg912FicTGFQWBnAL640=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757436220; a=rsa-sha256;
	cv=none;
	b=Y+RS7Po/4jeYZpZnRcQa//u3hfIyrQt/YCDZS7dkNqD6pH4ML1w66sQgkUDseHN5j7ybwS
	cYwQIZnF96de9EXjQX1TZ0mdsgpAaON/kQy3R36udnT8V7novzwDpZ1CPPE2Vy+wuTH9JJ
	S2p0tcXqiGzlT0xUskibTrYH0NxL/3s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=odigRXg1;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-61cfbb21fd1so219a12.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 09:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757436219; x=1758041019; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X9zR1ns6r4tli6kgpMkZXeVyHg9onE4yZmroH/q5x2E=;
        b=odigRXg1yBseoWdstIm5ivkXwqgtnbTXtMSYXlfTwXiczJHc2h3x8hK22Ngs3ykL/7
         3W48OmwXz2QGCktKILkVenuajfpttGRw5XiyxQAVx9f7ucU8h9Oz30aCiivOBBCF4CT4
         2vG2jsy/OFGbcPdf8Od/Otot4Rc6+kxmjo2/diBKCoGnHesvS/vDELTWHrzI4If0MMxD
         +3RQXXFXS5GmMOku46z2yaz3+EzpCcJu5Kkr+1fnRqMP1u1YmK8yFEA53NlSqNc9fzFm
         d8JNicATvQ1JycTfEPB2aQDxLB/BP6TKwi58rVQLli4mhhLEORn0SGD+RLFTHUg7K2Fi
         gGwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757436219; x=1758041019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X9zR1ns6r4tli6kgpMkZXeVyHg9onE4yZmroH/q5x2E=;
        b=RaDWqsQpXhvjGBolqS8j4LBAyIdaE0tBjGknOe7i+QdqIV4aZcEybiKUL7F4gevTic
         h5gXahI/2ECWRPqV6ZYHJI6k9FljTZnP9YpPjDhxXyyi3OjEGnEkWKcx3l5cdAlhTrAw
         uhe4jKiJSC9YrgeC8vT1VFMKXQScJ0PExX8TLyPx9k0+JHv/5NvPsAxDhRObxu7Rji0l
         2n1WCVdWQrtbRp7/4RuQpauAuGSlDpDpsHQQupLv+wfS2YGcnJGBqlthJ/bYWQSIFg0m
         g8uJMMOMXfj67KidkfQ/CPO6mzskSMTp5SZk9I7XU4BiYa+9HhEP86SsvYvmksLHE+Qu
         GvzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUS2PTPNjW9R1oMNw57zOgNbU1Bxkh1yPYXr3d1XawtNT6LoVAAr+O8D7+F4cgCsXHATMNpNS0+4w==@kvack.org
X-Gm-Message-State: AOJu0YxLTP6uB/Tg++NLdzwoFry5+8sSm6XQ73UGbhYEKvfE9BfS++dX
	6aPhbq0P1+xFfiVN1TZbsTCu42uRt0a8FvuVQuv9551wpcnC4824bxFRTCXA2enL4rXUv0kQ0HK
	inRRWGQXnTm9Nu7YDB9X4USfTRjGWvYwTgb4qfVnB
X-Gm-Gg: ASbGncvkA5eT7Yqh6VhPDLSl56UzMVMqXlKRK2hovNNyC4mSs9N6fEGV3WW9WoyC87a
	kfNKMmvREw+CUX7WvONGdVFezxqhDETaVDvAhUQDn4IRRLErAbAe+UPH+G2L63yrXfMcFWE9Jx5
	BTJUPxlXHokh7nmO1zzmEntKKQS/isoOJxlWKaSG4VToTEGx2Yjc36E6hqqhIMIN6btJDwZtkhH
	zB4ic5hSpbkDNK44uKezkq1hdy5qP8U5FPpD2v5N1E1enL99dwMPdo=
X-Google-Smtp-Source: AGHT+IELrtj08JXZeKFczydeIaWz+ZDdGREnJhxstnY5vYYsKxfzgQANvCdFJ1mjoGgstj0WHnOScZjfoo2Pzh65Zfk=
X-Received: by 2002:a05:6402:4024:b0:61c:c9e3:18f9 with SMTP id
 4fb4d7f45d1cf-623d2c4dda5mr356673a12.3.1757436218862; Tue, 09 Sep 2025
 09:43:38 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <ea1a5ab9fff7330b69f0b97c123ec95308818c98.1757329751.git.lorenzo.stoakes@oracle.com>
 <ad69e837-b5c7-4e2d-a268-c63c9b4095cf@redhat.com> <c04357f9-795e-4a5d-b762-f140e3d413d8@lucifer.local>
 <e882bb41-f112-4ec3-a611-0b7fcf51d105@redhat.com> <8994a0f1-1217-49e6-a0db-54ddb5ab8830@lucifer.local>
In-Reply-To: <8994a0f1-1217-49e6-a0db-54ddb5ab8830@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Sep 2025 09:43:25 -0700
X-Gm-Features: AS18NWB56jIrhZDM4c-qSVZLOkH6X6dA_iJA_IjgEAuDFh14nG2Q8lK0Ov1ujjQ
Message-ID: <CAJuCfpEeUkta7UfN2qzSxHuohHnm7qXe=rEzVjfynhmn2WF0fA@mail.gmail.com>
Subject: Re: [PATCH 06/16] mm: introduce the f_op->mmap_complete, mmap_abort hooks
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, Guo Ren <guoren@kernel.org>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	"David S . Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Baoquan He <bhe@redhat.com>, 
	Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-mm@kvack.org, ntfs3@lists.linux.dev, kexec@lists.infradead.org, 
	kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B34341C0008
X-Stat-Signature: 9re9676jazthgz3dakjg1gkfihhzi8w9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757436220-866609
X-HE-Meta: U2FsdGVkX18PiXrezIOXsDE6/wUIegdbXkmjbc0Pctsm3VaJ6wSytlP/t06bCot97Zrku8B1uHC+NtF+RsFzTj+e4PItIDeCIFoFXl3TCIbHx+8eQi+WNpvb7RejuWBvNPx5w6iN4zuQ78ZyZ+DjK6CLV/jiR4Q3FzuvcCCERV1lwTu9YF8/pEZ4vhUAhTYvZZep/ig8tGunc6BrN2eoXKiUGwxnimMqzIkrSmjqQiVMIeO1Bx8uVTJZ3W8uLSrlxbgGZEwGEsLSKm6d5qHrjM5Ybd1CbXVwqaWGSjHMRGSb9JYd2lcZSLlPx8vGtUU8Gl5WPi3g28My4nlNh3lFlskoSBOXeIekgTG1izkYmeOvcBPbXWzodZGa7/hohpiUj17CZ/DOLvjBPPa/qN6KlEICorumB/306dVxKsmkTDykYcNeDILtExfuKULh16eoSbH5FEZG29b2mEwxMiKC3Wzs8qyL0wTPu210lyL8Px7INCi9XoEZhpRg96NsOye9t6kgpgudPqCqSld0JuGWR3xVGa+Jo+rrx09vus3Ibr5i4UrD61nLoLgZIvW7e3B9xvK3ceYb4BE5Dk+2ss6Zb7m6xIP1mFseSNNyodSmLt9Cx0sa+CaGyZgSajnnhpM3zafxKGaKniQ6LchUJKWljaeghstvmCAIKr9jjarrKwOsRx0Gb+C5a3kJnjM99B2No5YuotGjmA/w26GvGSyQw20O+y4C22CvNDvH/JEqu1RukjztfRTqg2uiPT7XOqXyExJJwfNP1qgRX8ze1hiudp5Hj7nSBJh/ja5JFKvpDH4PoSFbM+tJMwyBZcoV0IWbFPsb8r9Bids4IEk0ZnCrJ6nlCu/idmuvd1EoBJuWpULZxeeXhbx+Kj3ZVP+ByozYrxl8N6YEVlnZlUVtYw0k+B0Jk4ai8lXLGDf2bk1Y/saYjx5BLe/7PtzddEfoe2JXWWiia3Su1rjOBQoLwTz
 9zquIfr1
 xQHmI2yHZ8/9S6YYRIfXPPxWYuRqBH638Q22s275aebulFOJwD/omR/WpV38SEKD+43pazzFkrUJZBy1MDTUn4UjKPXMSLU8HGVxMwHXjPIMTGH+mh+gI6IamQDtVRxWx+P/9xgrvL1ETJChJQAgQ2Xsq3PwENaLaO4ky9pNHnNYmTBPAUMBqFgdOVRsnRtVs+C5+AtfVHAPPej+khtmgB4Z1f8ILF+oU+t4wg0SKiKXj8APFevdI0CNZGh8qGEBSBhu+dvMHc8JWbyJ+oZ8LV9hiXyDMDLHuOu2CIiFM4URs1ux1Ba0SyXP6dg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 2:37=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Sep 09, 2025 at 11:26:21AM +0200, David Hildenbrand wrote:
> > > >
> > > > In particular, the mmap_complete() looks like another candidate for=
 letting
> > > > a driver just go crazy on the vma? :)
> > >
> > > Well there's only so much we can do. In an ideal world we'd treat VMA=
s as
> > > entirely internal data structures and pass some sort of opaque thing =
around, but
> > > we have to keep things real here :)
> >
> > Right, we'd pass something around that cannot be easily abused (like
> > modifying random vma flags in mmap_complete).
> >
> > So I was wondering if most operations that driver would perform during =
the
> > mmap_complete() could be be abstracted, and only those then be called w=
ith
> > whatever opaque thing we return here.
>
> Well there's 2 issues at play:
>
> 1. I might end up having to rewrite _large parts_ of kernel functionality=
 all of
>    which relies on there being a vma parameter (or might find that to be
>    intractable).
>
> 2. There's always the 'odd ones out' :) so there'll be some drivers that
>    absolutely do need to have access to this.
>
> But as I was writing this I thought of an idea - why don't we have someth=
ing
> opaque like this, perhaps with accessor functions, but then _give the abi=
lity to
> get the VMA if you REALLY have to_.
>
> That way we can handle both problems without too much trouble.
>
> Also Jason suggested generic functions that can just be assigned to
> .mmap_complete for instance, which would obviously eliminate the crazy
> factor a lot too.
>
> I'm going to refactor to try to put ONLY prepopulate logic in
> .mmap_complete where possible which fits with all of this.

Thinking along these lines, do you have a case when mmap_abort() needs
vm_private_data? I was thinking if VMA mapping failed, why would you
need vm_private_data to unwind prep work? You already have the context
pointer for that, no?

>
> >
> > But I have no feeling about what crazy things a driver might do. Just
> > calling remap_pfn_range() would be easy, for example, and we could abst=
ract
> > that.
>
> Yeah, I've obviously already added some wrappers for these.
>
> BTW I really really hate that STUPID ->vm_pgoff hack, if not for that, li=
fe
> would be much simpler.
>
> But instead now we need to specify PFN in the damn remap prepare wrapper =
in
> case of CoW. God.
>
> >
> > --
> > Cheers
> >
> > David / dhildenb
> >
>
> Cheers, Lorenzo

