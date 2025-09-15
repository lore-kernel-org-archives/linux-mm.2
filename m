Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94D26CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 21:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89BEB8E0003; Mon, 15 Sep 2025 17:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 873948E0001; Mon, 15 Sep 2025 17:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 788F98E0003; Mon, 15 Sep 2025 17:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64AE88E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:26:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 053C8C077D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:26:15 +0000 (UTC)
X-FDA: 83892767952.11.957E5F5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id C74E418000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:26:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VqL9b1NW;
	spf=pass (imf24.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757971573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KM4RQD/H6XgF3hQHay54Rz4wcT8Td67zLaIIGzgIOjc=;
	b=7sLkjrAI00prYR5AqcT/pLIckhcRJvwLnNYhaoHzqjCtrOABmEmwaDlEteIjwPmImD1/QC
	kCjYUENPsplRf6DOFq4qdpBlU/yLHYx/Vfnvf0tCMaouGta2uM3oJQGc/WoLalZjPXTMo5
	9gAvqbAtHlojQe+GP/ryFndRHL2yYMY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VqL9b1NW;
	spf=pass (imf24.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757971573; a=rsa-sha256;
	cv=none;
	b=EXVQOQk45SnLu0XEFn9J5UrMQvoon5fYYitWFLrEmqiZNJZT9UDiCTgXMOAQ41UawyKczu
	8uENgPgBe4rlVwkUWqMZON+OVsXuGLnISTXllGqVLzpahyGkH+MxvsKnZwryPpilorgxuV
	DYI1YWIf0464NGBzeaG9mnxDDVaQ/r8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757971573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KM4RQD/H6XgF3hQHay54Rz4wcT8Td67zLaIIGzgIOjc=;
	b=VqL9b1NWQ0WussgNB3M6/5DEeTKPkt2riW+ZEDXT1eWDrs8Co9WiZO5mgZmuD+OobVNULa
	zTdWRX7VTFzfTJT5uAcvGiVNxfUJ5Tb2ga7RbP13+oMIz8hEmjidkNjVhZlQGMowQPIOxg
	yry0S9DoDx5MBN/ypLIuIE2yswCuKoE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-WgGMIMnbM5qcpU9pACn8Ww-1; Mon, 15 Sep 2025 17:26:11 -0400
X-MC-Unique: WgGMIMnbM5qcpU9pACn8Ww-1
X-Mimecast-MFC-AGG-ID: WgGMIMnbM5qcpU9pACn8Ww_1757971571
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-770c244009aso53329196d6.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:26:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757971571; x=1758576371;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KM4RQD/H6XgF3hQHay54Rz4wcT8Td67zLaIIGzgIOjc=;
        b=pCHVtJSUj3Y5ISwg7Uay7b0Q+yc/XFdtqCAzTdYU9ZxMxdv1JQgLDCCe+lS3D67C27
         PMaOc7AggE3LDEcCfbZbZCRavziww3v6PRYAS1QESBMcVFUH8F2+xuoCq8ftg8u2d0qC
         7fFd1pENeyuVqqjwIXmgnFgEodm++JrqfIg9AslhqvxQ66DwC4sM8Pthi1aamjJPBOQt
         4WAOGVJn0a8HclD54wGwv8JX3/xLU+c3raCdRa9Ny282fz7fKiUO/ELOAsqSPmR8q2ae
         jguKAhM/IUMLRBHYcaoxazbjbcF8wk7DvkurjHsx7TvZISAMqNEUHJDNrIwu95dOiRDa
         3KYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWviYyepdJ3l2rHkMUkSpPe0Mds8EPNtiTkSs295tWggy36rj1KRcgsEjxtZdl9XMgWSTbQVaxYng==@kvack.org
X-Gm-Message-State: AOJu0YwYxCAUzD/1Sa+2ETtNxc1CJDVgqupaVQ+uf7YCXjxYpTihpBSY
	3N/n9Z3DE7vL7fzesG1PAyjoaZ8LVWlpBHZ04qbMqrj1Kn9GCaUsZeWSRhGopT80WdvTIFuAEhV
	DdFQjgNxnm/cpqWp35+y7fHaL0fm35B50kKe80yAWi1YPRoR5+aTz
X-Gm-Gg: ASbGncuIzGNMzznfw7zIPoeS8sAP1aKbbc+q/4i0x/QGYlRVwSFlwFe5ICpChppaXkx
	SkpB9TuAnd96YnkB7GOIS9LkcvJmij9NGi92SloU6q5ocIZNCXCqUiph4++4wBFQ5YypQNvjqZY
	L2x8zunOzM6I+WOWSXwXTVK5iHS2jI6YzgfjjsshtTXsFVA+f4nRnlaV4c78v55w6WLYeBvttS/
	m9ZSnqa9Ahg4K6vc9A0xyp3Z1+qgHpqcgKnJE2R4+4eoO14dVW03w7Adk7yTchwN/484udVF0Aj
	9SMa16igsGGfSJxHAxLymxtqciM26Hnh
X-Received: by 2002:a05:6214:3c85:b0:769:cd09:9d77 with SMTP id 6a1803df08f44-769cd099fafmr170285266d6.4.1757971571191;
        Mon, 15 Sep 2025 14:26:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkORZIzaSeYsztcwaPnCJ3V7jNeNP5xXWbRprE054mUcehDj+b7ToSI1uNg2GLUniMgON4ow==
X-Received: by 2002:a05:6214:3c85:b0:769:cd09:9d77 with SMTP id 6a1803df08f44-769cd099fafmr170284896d6.4.1757971570738;
        Mon, 15 Sep 2025 14:26:10 -0700 (PDT)
Received: from x1.local ([174.89.135.121])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-76e576ee0fcsm60107386d6.69.2025.09.15.14.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 14:26:10 -0700 (PDT)
Date: Mon, 15 Sep 2025 17:25:57 -0400
From: Peter Xu <peterx@redhat.com>
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"brauner@kernel.org" <brauner@kernel.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"willy@infradead.org" <willy@infradead.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz" <jack@suse.cz>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"jthoughton@google.com" <jthoughton@google.com>,
	"tabba@google.com" <tabba@google.com>,
	"vannapurve@google.com" <vannapurve@google.com>,
	"Roy, Patrick" <roypat@amazon.co.uk>,
	"Thomson, Jack" <jackabt@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [RFC PATCH v6 0/2] mm: Refactor KVM guest_memfd to introduce
 guestmem library
Message-ID: <aMiEZfkx5sRMU7it@x1.local>
References: <20250915161815.40729-1-kalyazin@amazon.com>
MIME-Version: 1.0
In-Reply-To: <20250915161815.40729-1-kalyazin@amazon.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wTuS6H-Uj4L0S2a_4f_DEeLWUb-JwcQ9FR4GREzgKLI_1757971571
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: yiyg36c5grod6ciot5akrd4p73u8bwrs
X-Rspam-User: 
X-Rspamd-Queue-Id: C74E418000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1757971573-343869
X-HE-Meta: U2FsdGVkX19oPZTaz1wReZyj9KsrntsRFFsums8K1q/xVqK4r7YZ7Y4JGrbHMsxnN3PolUVfBmFvAmuX/MmZMZv1mvfa7Hhc5e+TA99UbuYtgyWWepjR7h2nEkJPeunBeVO82RZIdDH5nZy36sykJI3QPLbwqHyR+TpNfp4T//UeYayNuwHFTdLyjx55nBLkSEC1NB1RymSFQOQp50cDfmbBqf7GtKUoLjW5F0wzh4Xxjl+P4JW2iyaqLorEAjI//ab6TscbIi1HPDvga2WVv/x/1kIkgAMJK4tJpq2Zs/RC9Nzh0wqaSUEgY6xETrH/E3WEyJcn5EpqAt0gpRHZzY0vY1eAYX2yux0rSqNnG/fG18VP615JwMJHZ0Ub2cvgSbL1zlD0maNPdxjhsoXgZDaIwY0GuaGrc+qm33kFuCglwjGZdJzPkKxMIspizpEGzneM9EIddnDK1BcRZbujEaTLyNtL5mMRUT097d4sZiq+n7VGLfg07CcXud+9v+DNATngc/YtIzVZNSVzQ9qm2LeKAw8KluL9QwLfdQQ5KiWRGiqAhKlXVJcjrIZ2ddTtBfcpxIuMGG1A/euxzvuQiEpbiSHm9+CBaQq6BIk8LC5J5Lc/tZL3mY+t0W6aIiXO45Eym4I4iTqcRY+WtpgvhQNRoX4gqr7LT0p4LI5c3K8mAiEXOTrQBqAHpeOLR+qmcBWD7cCh/JQYF+Vvstr7DxCw9z/hi3cj+0k1fkZCZqHBdTyvewF+KWXJk0zJ9z8OnaasqVN/q7ClSsNkMYrwx3kT5gopylEoLI/n9ifr/kPtk2mTgo7W2lbgw4XBIUM4eDFbHKPdP/59mROKI4C4fhv2r0eLv6GzEMCAqZpbFSbWc2u0ODIvoA5giYBxTJmEyOOoU0myX7BkZTLxnCjqBC/d6NI2vpyLBYImPOR4eniK8wPB5Iz0iPM9ah2qOQhhnmfeBESHCsKUtAgfXwl
 0j0agBgI
 BwQMBQvHCzd1hGdxrNkcmkgbpaOPQBh0Gm3NOaDlOEWt6KdeVyDbR3gA6kgobdWvBe9O+uAy96Ihhd3BJDgrjYAuY3A9jIKATH8J8DUJMpcgDijPq6Kgu3sjBNdC03tPdMtb29CqoYKKltsObwa2gLhb5+kUXHv4/QjZ9Pju+ATD8jYOFO+yoJzA4vC2b5T5CNePvUvvj1RcSvzoY13zBgmTArVMO1hT1bLFnO2OnbG1uikP9/7DAoQ0dj5+wRRO0FrwW3YyXJCU5h6MbkbS2Uj3Eq5p2a6aeXiX9+SCTrsv9xJOoHZ2LEdrKwkrbFELB+KbBTS15huDzZDve73i8IQWUmM8UvdzeA1gTcy9fg83syZt47S3JblCl+ow3vZj4iqcqiMHZ2m6/OyGqf/EmqXnchxJqoCGFM1gv50padGzUZxl1gFPM6VvWpi7vPhmOPbrNAi9kGf/UCDZqFGAOMSe0I7d/otaA7ZVPzTCQzoCXq/0CSsxWk8cekrv/QQZDn8bCpKvnQhICSnqpv5CIYlVkKmo0F8jZZvEuK7K0GWQHdNsOgN5G4qA0OEaFlFSddHlR5znrZdZF+XniTF00GMRmUijclg6PI2febxExVPg6mbvd+6SBs0IkVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Nikita,

On Mon, Sep 15, 2025 at 04:18:16PM +0000, Kalyazin, Nikita wrote:
> This is a revival of the guestmem library patch series originated from
> Elliot [1].  The reason I am bringing it up now is it would help
> implement UserfaultFD support minor mode in guest_memfd.
> 
> Background
> 
> We are building a Firecracker version that uses guest_memfd to back
> guest memory [2].  The main objective is to use guest_memfd to remove
> guest memory from host kernel's direct map to reduce the surface for
> Spectre-style transient execution issues [3].  Currently, Firecracker
> supports restoring VMs from snapshots using UserfaultFD [4], which is
> similar to the postcopy phase of live migration.  During restoration,
> while we rely on a separate mechanism to handle stage-2 faults in
> guest_memfd [5], UserfaultFD support in guest_memfd is still required to
> handle faults caused either by the VMM itself or by MMIO access handling
> on x86.
> 
> The major problem in implementing UserfaultFD for guest_memfd is that
> the MM code (UserfaultFD) needs to call KVM-specific interfaces.
> Particularly for the minor mode, these are 1) determining the type of
> the VMA (eg is_vma_guest_memfd()) and 2) obtaining a folio (ie
> kvm_gmem_get_folio()).  Those may not be always available as KVM can be
> compiled as a module.  Peter attempted to approach it via exposing an
> ops structure where modules (such as KVM) could provide their own
> callbacks, but it was not deemed to be sufficiently safe as it opens up
> an unrestricted interface for all modules and may leave MM in an
> inconsistent state [6].

I apologize when I was replying to your offlist email that I'll pick it up,
but I didn't.. I moved on with other things after the long off which was
more urgent, then I never got the chance to go back..  I will do it this
week.

I don't think it's a real safety issue.  Frankly, I still think that latest
patchset, as-is, is the best we should come up with userfaultfd.  If people
worry about uffdio_copy(), it's fine, we can drop it.  It's not a huge deal
at least for now.

Btw, thanks for help pinging that thread, and sorry I didn't yet get back
to it.  I'll read the discussions (I didn't yet, after back to work for
weeks), but I will.

> 
> An alternative way to make these interfaces available to the UserfaultFD
> code is extracting generic-MM guest_memfd parts into a library
> (guestmem) under MM where they can be safely consumed by the UserfaultFD
> code.  As far as I know, the original guestmem library series was
> motivated by adding guest_memfd support in Gunyah hypervisor [7].
> 
> This RFC
> 
> I took Elliot's v5 (the latest) and rebased it on top of the guest_memfd
> preview branch [8] because I also wanted to see how it would work with
> direct map removal [3] and write syscall [9], which are building blocks
> for the guest_memfd-based Firecracker version.  On top of it I added a
> patch that implements UserfaultFD support for guest_memfd using
> interfaces provided by the guestmem library to illustrate the complete
> idea.

I hope patch 2 exactly illustrated on why the uffd modulization effort is
still worthwhile (to not keep attaching "if"s all over the places).  Would
you agree?

If you agree, we'll need to review the library work as a separate effort
from userfaultfd.

> 
> I made the following modifications along the way:
>  - Followed by a comment from Sean, converted invalidate_begin()
>    callback back to void as it cannot fail in KVM, and the related
>    Gunyah requirement is unknown to me
>  - Extended the guestmem_ops structure with the supports_mmap() callback
>    to provide conditional mmap support in guestmem
>  - Extended the guestmem library interface with guestmem_allocate(),
>    guestmem_test_no_direct_map(), guestmem_mark_prepared(),
>    guestmem_mmap(), and guestmem_vma_is_guestmem()
>  - Made (kvm_gmem)/(guestmem)_test_no_direct_map() use
>    mapping_no_direct_map() instead of KVM-specific flag
>    GUEST_MEMFD_FLAG_NO_DIRECT_MAP to make it KVM-independent
> 
> Feedback that I would like to receive:
>  - Is this the right solution to the "UserfaultFD in guest_memfd"
>    problem?

Yes it's always a fair question to ask.  I shared my two cents above.  We
can definitely also hear about how others think.

I hope I'll keep my words this time on reposting.

Thanks,

>  - What requirements from other hypervisors than KVM do we need to
>    consider at this point?
>  - Does the line between generic-MM and KVM-specific guest_memfd parts
>    look sensible?
> 
> Previous iterations of UserfaultFD support in guest_memfd patches:
> v3:
>  - https://lore.kernel.org/kvm/20250404154352.23078-1-kalyazin@amazon.com
>  - minor changes to address review comments (James)
> v2:
>  - https://lore.kernel.org/kvm/20250402160721.97596-1-kalyazin@amazon.com
>  - implement a full minor trap instead of hybrid missing/minor trap
>    (James/Peter)
>  - make UFFDIO_CONTINUE implementation generic calling vm_ops->fault()
> v1:
>  - https://lore.kernel.org/kvm/20250303133011.44095-1-kalyazin@amazon.com
> 
> Nikita
> 
> [1]: https://lore.kernel.org/kvm/20241122-guestmem-library-v5-2-450e92951a15@quicinc.com
> [2]: https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
> [3]: https://lore.kernel.org/kvm/20250912091708.17502-1-roypat@amazon.co.uk
> [4]: https://github.com/firecracker-microvm/firecracker/blob/main/docs/snapshotting/handling-page-faults-on-snapshot-resume.md
> [5]: https://lore.kernel.org/kvm/20250618042424.330664-1-jthoughton@google.com
> [6]: https://lore.kernel.org/linux-mm/20250627154655.2085903-1-peterx@redhat.com
> [7]: https://lore.kernel.org/lkml/20240222-gunyah-v17-0-1e9da6763d38@quicinc.com
> [8]: https://git.kernel.org/pub/scm/linux/kernel/git/david/linux.git/log/?h=guestmemfd-preview
> [9]: https://lore.kernel.org/kvm/20250902111951.58315-1-kalyazin@amazon.com
> 
> Nikita Kalyazin (2):
>   mm: guestmem: introduce guestmem library
>   userfaulfd: add minor mode for guestmem
> 
>  Documentation/admin-guide/mm/userfaultfd.rst |   4 +-
>  MAINTAINERS                                  |   2 +
>  fs/userfaultfd.c                             |   3 +-
>  include/linux/guestmem.h                     |  46 +++
>  include/linux/userfaultfd_k.h                |   8 +-
>  include/uapi/linux/userfaultfd.h             |   8 +-
>  mm/Kconfig                                   |   3 +
>  mm/Makefile                                  |   1 +
>  mm/guestmem.c                                | 380 +++++++++++++++++++
>  mm/userfaultfd.c                             |  14 +-
>  virt/kvm/Kconfig                             |   1 +
>  virt/kvm/guest_memfd.c                       | 303 ++-------------
>  12 files changed, 493 insertions(+), 280 deletions(-)
>  create mode 100644 include/linux/guestmem.h
>  create mode 100644 mm/guestmem.c
> 
> 
> base-commit: 911634bac3107b237dcd8fdcb6ac91a22741cbe7
> -- 
> 2.50.1
> 
> 
> 

-- 
Peter Xu


