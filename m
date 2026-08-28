Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61646C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 04:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 466B96B009B; Fri, 28 Aug 2026 00:20:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4176E6B009D; Fri, 28 Aug 2026 00:20:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DFE26B009E; Fri, 28 Aug 2026 00:20:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0646D6B009B
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:20:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8726216033E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:20:01 +0000 (UTC)
X-FDA: 85149375402.06.4DB98E4
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 94B3A1C0002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:19:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NTYsN8Fz;
	spf=pass (imf20.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787890799;
	b=XWc0xoCZ28R9HtC3PGpkZEtJsih4yHMSbMiKKdlk7xZpnkAbVsJ04RtSFXfAS2P26wT4YZ
	XdtZLWcJdGOCl2OTqEzpMOxgFQkDGmnvHyniwT278yjHVi0BKRCrRa9OgtepwTjOfXGYE+
	iIN63Iaq0yWAyoaJ0Qg7VhPdnmM3/PQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787890799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCDy9v0wvCJe6b4tDkyj5x2hkmiUIAeHKOf5Q690ANY=;
	b=KonarNXoKrdNeAewQ6WjbajLssQ2zJs2Vxa/QEbeqiXpfw/ktpvaSerqdhhvOA1mmpvpht
	Gw4v1nGGMzOtrcztTTeoqyAYWORYQMZeadM6a658vFJ844zQpjO8dRx9J+Xp35FSOXUtXD
	sKb2EtYEXJ4p9Y1VIta1jvyNrk9sAGQ=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NTYsN8Fz;
	spf=pass (imf20.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-90cbff85fa9so2543436d6.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:19:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787890799; cv=none;
        d=google.com; s=arc-20260327;
        b=JSDEHVJ54VCOsW2LjefwA8tYAEg3DQYnbJrCDW7XpOdWbcpQBznL3XI/i8N5I6Tz0H
         Bn9a9YFCMEiZYodVY3gNeMwkx9q+8b72icsFbs9rmZ2T2vp9l7K3liWXqruyuGV3K3ko
         PQTbELVuMJthgkUwQ2orKdROcQoNy9w9ErVQbzU2PFkF0EJ2zBsm/CtIRWPcSn6pP7Af
         3VQYJyFHSNwB2CdGLA+h0sqPoHYuXzB1IocyX2RMdxA/gPNIpP4Wzb/FK2MNCc+j1gMk
         BTpdaqlW4QETLFL63CKlBdnBKV7nxfBbdCi0v7cnKLX1H8Qy3pHxAQMSRB8GbnyzSgPD
         jrSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=QCDy9v0wvCJe6b4tDkyj5x2hkmiUIAeHKOf5Q690ANY=;
        fh=4ycKK34rfICDBOHgo+BR1Kdzi0BwMrcT0Gk74ZkOTwY=;
        b=MNiYwBoL8fXsiZ6sLuptNEmF1rD/fOW5/Zz/A0i77xJp27I98w08A/7C/ZEr2hDPxN
         PA4wbfl3e2AC/RpTXLf363+u5FDz+VAART8rWyuzZrX8Q5ST4QQqynxryYKzTZk2ZawL
         zXBrjntq9XDAoAy7jI/cbGd+UJvtY1riX2+XGZLRoIZ3atElEVQATjTjQguP7SAb19py
         3Ij5ymmNLXd249l3cvGIdK0eQ/FgaWbgP0IQYakp9uvzCWEmQuErjFn3yC9xRG3kegHs
         UKM4WKR+CPv5ZFKzRV8zXb7joFTwGj0ek0vyLnl5QM+tBxL+l4NNa2mT89Ft+gK0XjaW
         chCw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787890799; x=1788495599; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QCDy9v0wvCJe6b4tDkyj5x2hkmiUIAeHKOf5Q690ANY=;
        b=NTYsN8FzmH1kt3CHRGgeeenKgz0PhzeLCCS8frTVv1qY29Wzsz9CapE0mzqIanTIoe
         yzTyRScOt8mFwiJ3GznasjgbgNaLooYNO8E7lCac/JjYqNniR9RkYkENKxJqPdOecVOb
         A4P7/raDsduTwMZU6v70mdIxKwKFFpJCvE72Wj7gqm6RCW4/ch7+bzl+8zXq4a+ocAUk
         rbK/XnEV45QLYiZ7SrB1lNFhilR7RK3atwXZOqC39AX4S2rCdcuz+QN+qHzqFcGI5mtB
         D6/oRQETTiiYFzm05EIxt1HU/YiITomX1h725S3wgMi8UwWo09Mcc8Gx2XlrFWF/KTeT
         1FZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787890799; x=1788495599;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QCDy9v0wvCJe6b4tDkyj5x2hkmiUIAeHKOf5Q690ANY=;
        b=bkIENb8fuOouo71SJUGjNn37W4uyW8RRgWhckKpsE++QEw7FSUzmgv2qeOfdzJRO9l
         atBZdAdkSjCZL+Lu4LzsBgsQCIjeAi/oR4or7rt7ZzHFvOiarUJzP3a0y0fed+wf0iPS
         +Iar21pcIBcgl+Ki3mDF2wg78dSvYvm8shwAXZynXD/ysGfGdbPmjFIFIzg+LB5ORKso
         mTzeQlXEKAUr8U2dv7BWSgijBu4IAuV+9ahrshRJa2mo2s+UQoS7TKFNHMit2gGoHrI4
         4GNIf0r/dTIUc9iORSPiuT0srmOkBKgA3y5KDyi+srbngmSjGiq0TGRsgsoPykXv3emk
         bDJw==
X-Forwarded-Encrypted: i=1; AHgh+RoSoYrcuK39aYe1HBYdWp15IUfCxncl0OHq2wY3KymJJwiQ4kNnobbgjAFo1/93O5flssvSf/deJg==@kvack.org
X-Gm-Message-State: AFuF++kRYUpJeimCcAO9IzMzv8l4+Ew9X8iL6paRrrj7oE2D1vvW7m7+
	l9nFAZZe7jcrM6iNpgI4WKS1rxLZjPWmyLjDWQ0wGtBQRpa7SXPm8VUWHQk3JoYjT44HMWFVvVR
	42Y3i8u0EwWatCcHbi2+SofERMEkuA5veRLdlKNOQ
X-Gm-Gg: AR+sD12bK2aLC6zgLb0NuQfwAEpHkRmhEABBHs++yHlWul//z3/kR+edQYAQ7A73E6u
	RGRQn3huN4iFV/kuqD7PJ9k4R/yNatBBwoQlpbm8gUyi0R+cw5ea5kigZZQFdD5eX8MVTzYkK/5
	NCKTT1x9mNTV5JXZ1wqBNd3Q1piHOlKmqscCjfRQSH2XpNHECtmRckFoFFzvwZmg/GVtf1zbHtE
	YQ/l4+sYpqxUSCtlCLHHS7Ybdu4eHL2Y5oISinRjN92CmiqliZg4LsRoIb7W3B625V9q5U+FB5I
	FMIzdPXj/2X6ncyemlozxClFu8HweevNlODHwx50Zw8q2akuW+GGJ/dh19/fSlmfnGdTGqZ5aST
	pyqvrSe7QgHruSYplq1Q3gQyE3HfmoHEW8myi/YB+eA==
X-Received: by 2002:a05:6214:212b:b0:90c:4e5e:754b with SMTP id
 6a1803df08f44-90ce0f45ea4mr46165856d6.28.1787890797765; Thu, 27 Aug 2026
 21:19:57 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 21:19:56 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 21:19:56 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ao9CKMXAX-hScRSa@google.com>
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
 <20260826-gmem-inplace-conversion-v11-15-0a15d8a799aa@google.com> <ao9CKMXAX-hScRSa@google.com>
MIME-Version: 1.0
Date: Thu, 27 Aug 2026 21:19:56 -0700
X-Gm-Features: AcwNN1UAGJ-fGOM9zD_UvTf06ZrP54h7-np3dJjD_6mMPjXqsGS1LGYTBF7LEzg
Message-ID: <CAEvNRgG7n6F=dW9V_QqQPDDgLiZ7x08uLDanJgSzerNtN8sqBQ@mail.gmail.com>
Subject: Re: [PATCH v11 15/46] KVM: guest_memfd: Call arch make_shared
 callback for to-shared conversion
To: Sean Christopherson <seanjc@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 94B3A1C0002
X-Stat-Signature: p8mdnhjjkmfufwcatfdcnpbaniqk6skp
X-HE-Tag: 1787890799-190552
X-HE-Meta: U2FsdGVkX1+9aa77mV4oyOngosytYRd4KidaO12DiXjOOT8VXe64Xjy3Hfvm8rIIM8ZGWidKvID9vlH3nFysNAKyaT1aGbCiWuYbVKLJ7VsrcG/gs+wm+5sdRiEs/dlwoEFJef1PhoLgkyAz9sZKZc9M8nBc3OInqVNeMgB/DbdrHOPz1GErVZuIzmFAkgMigyS4R6Ils426FKhR2kITwWv86updkLI+xg0KttaHWjRWYj4+OwNWNESj4P845RTttiNo5x8ol3R/+UG6pClNS1Qr4pQ8nD4VjtouN0OAHylM+kjNEe+/zy3ujvWgKaCTmLhAhfywn3L8Tlt1fAs92qc0f9A/htVwgd2htCewUHjDHySGpDRGIl38wVak5gOvBZ5cabUCgXUC7Ixw6yjLYNorCxsTKHfRYBznry7uvFN4txuvESJRs0uPUKfeuGYb5UzdcaKWbpjNtAFo6+bzLNKNsuL0+88bUtaJR/UhWrShUuZoB3z0OD2K5CWFe4IEOAzkoY0khLwD7SRD3JmN3hwSR4amMjzK7G5ummECTj/7neQM5IRg6FMzYuBNY1V7zkqoS7dLCfLNC0sWs9mc3fELgjPavWIYqWp5R1m4CVQ/JlOJ4gidR9BK2lHzM84V2Rb3Lu+c5wHC0Jq5FDC9QNFB8DT+jLyi+VAYqlTO8LxuoWgP6Mye05HNFk8Fkoc9yDW4zoCWGAQw+FSFIXsWYrbchUXGN2P2x2LCLZYmuLvZ6HIVrlDmOE/BSTyG5F4KrGuHBvGES9gheNxTg1Wx0CmE83+xl58oX/rtmS7ibPCS+FGg0FXVFgNRJj64prMKHtHN6BfnZGl+nkmLc3mbmcO87kJ1pdaMlZkiyyTh9fqkUJYVJi2cbf2mbdXrdNdkqF0F8AijqJAW6XPaWwjcJgwViCoHyURgF5dOtLI+nXJJsUIgHyxJqBhh2D8JW1vrrkY3zj9+CrdGST0BJCw
 lcPpGaQ2
 I5XsUGOHDpmAL8U9QIHvBI52QT8pTKeeXZyiHRpvfEzR76FSjjymnyquQufZi5r+GCoFHfg9EvKon3ZoT2gdZYUTFN1/qMRsii2/lMsNu/Mr+7HRjg/fZ3lyS04IRT3Mq0/GBwnmu1XwNqP6MFxvJyu9gSv8Ns4wIpc0liaiyT5OvGU5A7NiMgBiYYU2R/QAxP3K5BowW12LNmZqxd9rGeLpv6XCt2JDkFwFtZq0qbGUg1oO91v+YIScRdLyyaAU5NMu1YLjb9iPzPZlz4bowF3b9nF9Gs7ZVI1i+pzo3dBjHRbP3GEffcqLB5s2utYW+obeD9Dt2ExDfbAk1GYNBM39Or9g4RxLSSPje/VL+aZJuD9/qrqgEAHgDkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Aug 26, 2026, Ackerley Tng wrote:
>> Omit support for calling the arch hook to make private, since SNP, the only
>> implementer of the arch make-private hook today, would actually prefer
>> making private only just before faulting memory into the NPTs.
>>
>> Calling the make-private arch hook would require iterating both bindings
>> and the filemap to find the intersection of bindings and allocated
>> folios.
>
> Why would KVM need to iterate over the bindings?  Only the RMP needs to be updated,
> whether or not the RMP is currently reachable is irrelevant, no?
>
> Subsequent calls to kvm_arch_gmem_make_private() from kvm_gmem_get_pfn() would be
> superfluous, but that's already possible, e.g. if an NPT mappings is removed for
> whatever reason.
>

make_private takes a gfn and pfn, so __kvm_gmem_set_attributes() would
need to iterate bindings to get gfns and filemap to find folios to get
pfns.

>> On top of that, SNP would need to figure out whether to actually
>> make private based on whether the memory is about to be faulted, or
>> whether it is a conversion.
>
> This is a non-issue, no?  As above, sev_gmem_make_private() already bails early
> if the page is already assigned in the RMP.
>

I'll remove this, you're right.

> I don't care terribly about how SNP handles this, but I do want accurate reasoning
> and justification so that if/when we revisit any of this in the future, we can make
> informed decisions.  Because unless I'm missing something, this is an optimization
> choice (eager vs. lazy to-private conversions), not a complexity tradeoff, and it's
> not clear to me how we decided the lazy approach would provide better performance.
>

How's this, to replace the entire commit message? I hope it captures
points from this discussion:

  When memory in guest_memfd is converted from private to shared, the
  platform-specific state associated with the guest-private pages must
  be invalidated or cleaned up.

  Iterate over the folios in the affected range and call the
  kvm_arch_gmem_make_shared() hook for each PFN range. This allows
  architectures to update hardware metadata or encryption states to
  transition pages to the shared state, instead of leaving hardware
  state as private while guest_memfd tracks it as shared. Transitioning
  hardware state ensures that guest_memfd upholds the guarantee that
  userspace only maps shared memory.

  Invoke this helper after indicating to KVM's mmu code that an
  invalidation is in progress to stop in-flight page faults from
  succeeding. Calling the invalidation helper also calls the arch
  invalidate hook. For SNP, this kicks any vCPU with a registered VMSA
  within the range being converted out of the guest. This ensures that
  make_shared never fails due to the VMSA page being in-use and is
  important because if make_shared fails, the RMP table would track the
  page as private while guest_memfd is unaware and tracks the page as
  shared.

  Omit support for calling the arch hook to make private during
  to-private conversions. Making private lazily at fault time aligns
  with how it works on other platforms like TDX.

  Furthermore, making pages shared only requires PFNs, which are
  obtained by iterating folios in the filemap. In contrast, making pages
  private in the RMP also requires the GFN, which would require
  iterating bindings to get GFNs and the filemap to get PFNs from
  allocated folios. Deferring the transition to fault time avoids this
  additional complexity.

>> Calling the make-shared arch hook and not the make-private arch hook does
>> leak SNP-specific details into guest_memfd (as in, why only make-shared
>> during conversions but not make-private?), but the additional complexity is
>> not worth taking on until guest_memfd has a user actually requiring an arch
>> make-private call.
>
> [...snip...]
>

