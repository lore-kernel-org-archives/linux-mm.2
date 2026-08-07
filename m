Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB7D3C5AC67
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 00:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F95D6B007B; Thu,  6 Aug 2026 20:02:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A95B6B0088; Thu,  6 Aug 2026 20:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 670F56B008A; Thu,  6 Aug 2026 20:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CEE46B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:02:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 986091C00CB
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:02:54 +0000 (UTC)
X-FDA: 85072522668.16.283F986
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf26.hostedemail.com (Postfix) with ESMTP id DB6C0140004
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:02:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lyMxAsuS;
	spf=pass (imf26.hostedemail.com: domain of 3qyB1agYKCBwK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3qyB1agYKCBwK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786060972;
	b=VeUI6xfyPgCPfpjfnSczwBi0r5f5LS+W+qnNzVeF4j+iI2sAfpWxzURpAS8Bh975j22oaI
	YyhSAWYwgDUXtB9r9JucR3lpson7inSWbhPGHlpZYgk8K3rwoeJiW4f5taZmZQg6mlUUc2
	CvU+tXr5ME7WLXj5KkOcsGB+yo+aDvA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lyMxAsuS;
	spf=pass (imf26.hostedemail.com: domain of 3qyB1agYKCBwK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3qyB1agYKCBwK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786060972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uHDxEiric74Ood8IcxlMwgt128fT9/N03w/mVBGilVY=;
	b=Ay81kKajEGykUUWmsbYLIP4Yp9H1ypk5PxcfqITf4GgtoZUFZRVL0k4fa3o/vZtlA7s4KI
	r4ishPcjZweWwSRgWcunzUGN2MSavAYi3jVhZ8rY6bzBNhlmTjZDC1yC94vCzaAm0QQYH6
	cf9ZLPNDryJpZVII0nMmIq7Q8YSoTZE=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d02df2bf09so33435765ad.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 17:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786060972; x=1786665772; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uHDxEiric74Ood8IcxlMwgt128fT9/N03w/mVBGilVY=;
        b=lyMxAsuSPu8UChQt0tsAW5yjDiy8FUNd7Ope3mTGAd6kClhpwtrJsWPnNCZeH2vJ4u
         PUG7PVN8UoiTLRvVCy5aPGRov1HBim5qirtidM4G2bKPmD6L0iWC6HsSgHsob5tBEk6x
         HA7sJXpptsMXsY9O4W6ElSRL3pXcUUNQXrDVL8a7oUPTKv3JnzTiUB1Nm73NR7lOuss1
         pryft+J5DVKFHtGS7OJRqUB4VUbYl5sBtQ6zqRoXcOqdIhtrzEIUKaeRYxnQLgzVdpsW
         oNqHR42ypgDo8jtHQLf4HJUcWcnp5jxDT38ia+GcErilomJKnOxB13fnWz52maLcUKgD
         xllg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786060972; x=1786665772;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uHDxEiric74Ood8IcxlMwgt128fT9/N03w/mVBGilVY=;
        b=Hq1IKW49mgMWv6k7Nt+N2iILpwqoe/7QLQBcvq8CWYcZmcxzaOPsawsrdg8o9pOBMl
         ++e5bc3W5QoPcj2jEqRdKcOVDORvDtDYBv1BYUS0zWPtZp/xq/8qtN3xAZqDTDinaNNe
         7Dih/zar62ocGLR9nzxocK2jMW6P6/IiBw3KA1HpP183CxYrv8yt/EBUEMHwy0qHgz8S
         9bFGVTMrIBVNjQMVoixDS9Ll3m6Zv0sq4rJJEZyF3mipDAPcb1t6guOcWjlLwJmzGUJW
         6qIn0zNbPkSTmIfg62wv/EyPko3Mg3LgfaqNPALlL4hSQtJLGzgwsLprmvZ7EHslf3Bj
         5wgg==
X-Forwarded-Encrypted: i=1; AHgh+RqyZQF3EPuLnXOINHoyGiRfyjMEowU0EYfvAJS4KuNphtxc68iyyAo3YbcaPAh00vMxajI7uDv6Nw==@kvack.org
X-Gm-Message-State: AOJu0Yzh2k/amXzLi9+/i89K+m/Rt8l+5ODflgEiWRQmzStEqin49JRd
	Rg1vmHbUbuYhsxNybkXBg0ynh1ou3alky3yF4hkfHoUyFKKSFllu0sIAc2x8FMwJpVV27jH9hVR
	r77ByLQ==
X-Received: from pljf2.prod.google.com ([2002:a17:902:ff02:b0:2ca:f374:c62e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce84:b0:2cf:9f0b:b562
 with SMTP id d9443c01a7336-2d0ca9904b7mr198998005ad.22.1786060971371; Thu, 06
 Aug 2026 17:02:51 -0700 (PDT)
Date: Thu, 6 Aug 2026 17:02:50 -0700
In-Reply-To: <amz0jzVPZo_eBeRV@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
 <amu5v-e39GKpgFG4@google.com> <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev> <amz0jzVPZo_eBeRV@google.com>
Message-ID: <anUgqnHKShicIK7C@google.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>, Brendan Jackman <jackmanb@google.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, 
	rientjes@google.com, patrick.roy@linux.dev, 
	Takahiro Itazuri <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Nikita Kalyazin <nikita.kalyazin@linux.dev>, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DB6C0140004
X-Stat-Signature: bcb47wx4r78hudzh7zbaqd55s9cmu51i
X-Rspam-User: 
X-HE-Tag: 1786060972-664924
X-HE-Meta: U2FsdGVkX186W+JIMAHve1TjERTM8V1mBPnDznRJzrf/MlPpcZLX007knPnhTZW+xLP/URdMXbqlqjsb9cLl5h/CI3SF7DEnH9tDWsJ/dHil1sx7Q+bBeM8Hy2ro2kWwViUq/27P8ZMHoo2Hi1/dvacbGsTTwDKNjOAdIer4ep/gJ/YLO2AQUqtD90HpwdVpLGtw3w5O2CuvWj9oGzCQpbQCuyhMilripU33V5mIfdv0kDp4e/PzSN4/Z5dbYHJJjx7rXqseITOdKwTOIC8BGKM03g6/vnOFZpFKLcYzNzF04ynCVvJHR5ZLhsg5PdHRprSEk9HAn3jloWrdizmImmKq8UjHQAm3FFaR4tEQvihUeABz/SLsuxlsqnwlepOWKqZ+1DlbD3cwSwlYAJA3q3ndTVsHNHsmCWOBP5RnOvIs1t3xV+dQVO6a4wpDi10r3HHja854KhxD/S9UVNQGiVndk/QmR5e5dinBLotfYBdMAUQVsvwFNSjeHJEYCgzRNd5u2ts4QA+Ua5jX3wEx9OhsAScdKzxZ/6KOzs62Y+yQALJIo0w8nqXRk0XVQPsqZtjvYWQcobKdOqf0uEMRfLH3LKDqQMM2fB21MQiYmggWD7Utnpamz2YFBFLhwzHaUQAgiL3yxXDnWwfD8JHzdLLX476lfEDTp+kpXhWr+pli/SmK6r7MWoTUGjBVE/ywq4v7kSQGsOeLCb8WJG4HSHzS+YSS8OGLHmQRtAwFeuDfslWMUn+x22paQUVFDIC3q/wwJk38mr6EfglP5oZpeTYsN2Y5ij1Ejn/h7qD1NZ4mCznRvMn8mzzFvmnVfG3/Eyi4cYUOD4GQM1GapanDESCVVhljFyoHjknkkOo1qi/trgLs7c6iqt9z24U98UKwE2c5o7WuhpA+VHufxmLYH8xCoby5LMcbHpxW7FuJ8A9z5DmxdbR4TfGosjiWrwQrvw3HoRNGOAXZYCsZ/3P
 soSGKcCD
 uERqNzvQ0fV4pUQSCdfNmLxZ8H+nldvJxU104mFjnemFvIBGL1sCK1HXNWXpsx5w7tA438raE2l7MyCI0ibeYoT63odY+IU8hScEMT50Vdo2uhNh0TXvY+PgGEo7Ts6rXJsv8/xFbOOyBRIQRJWHSBmM/afOEfjyY1DL0wYERHis+TVeeOdoRN7hPFkK7RnKXy3ltRKsHew3v67HFDqPkaGdpFQNz62YU5q2WTQO1ipvZGvdcKOg77MxzWB7J2L972iMVeTn8kzjeSrf7plex8r+BxDig7clBpZZaoyhAt2so5T9ta7XemVABTA8RrOtfnJeWkvCsc6FC16BOfCLPuYgZtc31YHnnq7/BT8dimnmqNakWBMcN0L74JQhIgH+WwsKTr6ZTJaLgYeo8MbMzGiwL1BYCORgUfIS7wfw3dXd7b7s0aJXJm34Myx0SJ+N2xcKIztvmj0FC9I6HY1ntq+WCeXs+IRQQBNmcw9epvGjY0bZaIk9fo8P8dRmpchXS9FASXseNWB1a+GRFl4fQvqOH4OxVZO3zArKlfi4NS8WC1XOjgn5iS5pspN8m8ictpawbmunIzwdQpVt1Nb81QPe0HbbZnsBi9IWJT7K2Q0dBVr6H9ApPEQK3NAvA+lqdrXIOFO/+QVF8aZKfiXB2jZ1INg3Zmu7yeqA99waxsfxIYU0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026, Yosry Ahmed wrote:
> > > [..]
> > >> --- a/mm/gup.c
> > >> +++ b/mm/gup.c
> > >> @@ -11,7 +11,6 @@
> > >>  #include <linux/rmap.h>
> > >>  #include <linux/swap.h>
> > >>  #include <linux/swapops.h>
> > >> -#include <linux/secretmem.h>
> > >>  
> > >>  #include <linux/sched/signal.h>
> > >>  #include <linux/rwsem.h>
> > >> @@ -1216,7 +1215,7 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
> > >>  	if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))
> > >>  		return -EOPNOTSUPP;
> > >>  
> > >> -	if (vma_is_secretmem(vma))
> > >> +	if (vma_has_no_direct_map(vma))
> > >
> > > Same here, and for GUP in general. For example, KVM uses kvm_vcpu_map()
> > > to map guest memory and access it (e.g. when running nested
> > > virtualization), which uses GUP under the hood AFAICT. So KVM will want
> > > GUP to succeed, and probably create an ephemeral mapping as well.

This has actually been discussed quite heavily, on multiple occassions.  Once the
direct map is obliterated, there are basically two options:

 1. Establish ephemeral mappings (for a fairly loose definition of "ephemeral";
    some of the mappings would likely exist for the lifetime of the VM).

 2. Always access guest memory through userspace mappings, i.e. through uaccess.

#2 sounds nice, but the problem is that it effectively requires hand-coded assembly
sequences for anything more complex than basic load/store operations.  Which isn't
a complete non-starter, but it's a pretty big blocker.  E.g. see the mess that is
record_steal_time(), and then imagine trying to convert something like
nested_vmx_prepare_msr_bitmap() to use uaccess.

So, unless someone comes up with a clever idea, KVM will need something GUP-like.
Strictly speaking, it doesn't necessarily need to be exactly GUP, because KVM could
poke into guest_memfd directly; KVM would "just" need to manually track its own
mappings.  But on x86 at least, that's not really a viable option because it only
works for map-rarely, read/write-many use cases.  For one-off accesses, creating
and destroying (very) shortlived mappings would be too costly, and so we'd want
those to go through uaccess.  At that point, userspace is basically required to
maintain mappings for all host-accessible guest memory, and if there are userspace
mappings, then not using GUP doesn't make much sense.

Note, I called out x86 because x86 has the most extensive emulator and shadow
paging support, which is where the isolated, one-off accesses happen in spades.
Other architectures might be able to squeak by without userspace mappings, at
least for now.

So, in all likelihood, KVM will want GUP.

P.S. In theory, there are other options.  IIRC, arm64 hardware provides the ability
to access memory via stage-2 page tables, but I also recall it being broken and/or
having severe limitations.  Using that also seems like it would defeat the purpose
of nuking the direct map since the host would have a full view of guest memory, so
long as it had the right "key".

The other crazy hair super theoretical idea would be for KVM to hoist part of itself
into guest context, but that would be a hilariously costly version of uaccess, and
would never fly for CoCo VMs.

