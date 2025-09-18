Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4862ECAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 07:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A25A98E00C8; Thu, 18 Sep 2025 03:38:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD528E0093; Thu, 18 Sep 2025 03:38:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 913C88E00C8; Thu, 18 Sep 2025 03:38:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E1F98E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:38:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1FC095B63E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:38:11 +0000 (UTC)
X-FDA: 83901567582.13.4242F44
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5666414000E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:38:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TLNjkH66;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 34LbLaAsKCMkprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=34LbLaAsKCMkprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758181089; a=rsa-sha256;
	cv=none;
	b=fjqZ/p9I7c7pc5lTT2x+eKlv6dFXLHSJ2dH0Jp/umvdIUc9m9DYv9CruMWWkC5ooBCYXXP
	q63yMqHA1tPBkhMhrpe9YK04BWaOHGB3IQOQyAyHn7h4QB2RdsRytcl/kWpt011f5fHH2D
	mOEIo6aU0M+F4Sr7en7hEPycJ40C1+A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TLNjkH66;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 34LbLaAsKCMkprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=34LbLaAsKCMkprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758181089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QlTsY5GbnDLA8PNX/Abx8RaC8EAugacckjHGVY6QHnc=;
	b=FeSw8wn+h3oeUH70WZmuSgSmTVsn9ZDKYGSNnt2UJr/ZDTshGvDt18Kldyqagk8gX4KoSY
	J3jslJItxpEHe926PYm09hrkOOVXURVmqd47+dYwfFI5XJO+n6nuS+pv7XTVoxqBdB7DLS
	0aTjLVxAaO+6hGzT3E1IkM4TQ6Yf9CE=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-25177b75e38so9349515ad.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 00:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758181088; x=1758785888; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QlTsY5GbnDLA8PNX/Abx8RaC8EAugacckjHGVY6QHnc=;
        b=TLNjkH66yI+ypUK7x3vLefSBI7OxXAFX1qw+JYwoJo2pz+d7EdraKjnifXCRkWLhil
         z7IOKo+vPr8T2qxXCj81mVkobphi4K/EHrUB0Z1YjCY4GYdh5ju1XBhHHMSUJPLEVWZ8
         PJOt8QNwHFkCeTUXSW/psWOmZi9wxBhxwJ+1Jq7PtvFfGXQvk+fB8m1yT4W1uHktTKui
         AMu0wHxXhjl5w/m2398LVeYfkrJ835kEmdTe4uXNLV25SfraG6P4h+nJjLKNueFDzChD
         r2sUKiJCMmb7hQeHPx2gRF1TFqoEyBGDzT1jEvG0zUsBxraZS17rYfzZk/P5O/h0bPKs
         mfKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758181088; x=1758785888;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QlTsY5GbnDLA8PNX/Abx8RaC8EAugacckjHGVY6QHnc=;
        b=s9FW3nS7CVxFUiIAhorS2AUSsP45wptCgHNPD8v0sP1moQLW+E4VMMueYjBCsCioel
         TZBqv80w4jRpXxrq41iwgtQT2NiRdM6Y+kAHa/tD7xO/pSrzzit9rKG3SfickyinHKiu
         80ENjv5ajpjH2d6ilEISer9sxoJdcpvAQDhYAdd863JE4nVubxphAQYdcZCSbs6zbwNm
         YadX0oQa+VCRN5RLxvqhF2FJSfHYbUBPwaLbcDOHm2lRhTR+9+DkAOJh58XtYMq/ihoD
         3cejSot8YxDGHwFRENvUwlnpdL8uUQUQ8NhYkeDrDdfFm6yMy0rCTYdI9FhU43e0JTe8
         ocCg==
X-Forwarded-Encrypted: i=1; AJvYcCW88W0qLgR5s4lcdeLdJ2eVMEMmHlxfz4epBmgeRSKJbdj1k2EJAgB9GGXirCdJKSvGvJBsg6lW1Q==@kvack.org
X-Gm-Message-State: AOJu0Yz9WfWtCeT2zy4xOn/sXoZawZA1012ktqrPFSIkNX+GNPmslu5X
	KumW+AJxVhy1RGOSzL2DOXa61SrOiJC17KwjnXIJPsAg3noRWQGr8QMwki34RxYMnZlikuma4+Y
	qrW6/b4+nALHRDYAJeR40og7Law==
X-Google-Smtp-Source: AGHT+IFWHyiMZiyuig5xhyHRANmmixX2X7Nu3qdKOzaiOgRWeSBFWgY0P+tpsX/S7el9mJRQJfrg8QP8Wiu7wsmEUw==
X-Received: from plsl15.prod.google.com ([2002:a17:903:244f:b0:267:d4d1:98df])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:144f:b0:269:874c:4e48 with SMTP id d9443c01a7336-269874c541emr20143955ad.47.1758181088219;
 Thu, 18 Sep 2025 00:38:08 -0700 (PDT)
Date: Thu, 18 Sep 2025 07:38:07 +0000
In-Reply-To: <diqzo6r8p90a.fsf@google.com>
Mime-Version: 1.0
References: <20250613005400.3694904-1-michael.roth@amd.com>
 <20250613005400.3694904-2-michael.roth@amd.com> <diqztt1vf198.fsf@google.com>
 <20250916233335.wv2lf4fiejlw53o2@amd.com> <diqzo6r8p90a.fsf@google.com>
Message-ID: <diqzcy7op5wg.fsf@google.com>
Subject: Re: [PATCH RFC v1 1/5] KVM: guest_memfd: Remove preparation tracking
From: Ackerley Tng <ackerleytng@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@redhat.com, tabba@google.com, 
	vannapurve@google.com, ira.weiny@intel.com, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, joro@8bytes.org, 
	pratikrajesh.sampat@amd.com, liam.merwick@oracle.com, yan.y.zhao@intel.com, 
	aik@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5666414000E
X-Stat-Signature: 89uoyers1kcfymojnchac9jakhtbzuo1
X-Rspam-User: 
X-HE-Tag: 1758181089-331056
X-HE-Meta: U2FsdGVkX18SHBKTpTmSaesXuYNK5i3kVe/297mcQ5TQKZ4RebzvIa826MKf9N9xeGzptS1fugVefPrBYZNLQrGNsHEC5wJBXmrbam0CELz9Af2H+Ey5ARu7jPiBeFqPVQyIYmNfDAkRsNOWCjfbngLWk5KBf92D9R4geeRuFTD7P4ID+/EbnURXc8lKLjRYrRPcqHA7iflF2JHz6JxdgHwRIpS/DlUgvNBE9DP8WcODZaZQBqjfheJZF96RfG/Ij5nxwff0GC7yr5o90o+6rCwNiydxMlxB6hth77aRLD8CcOo87RFoez2Qq66khaE9l7NhN+mDUBbx5g/tnLNdp6FpcTZSeQP4sK/Go72TG2/iwl8fco6DZ0UEcSE7mfjn34bqJcMqBLBBQjEfbxRufuyzbs7kJmjBbdCa/ZwYAFgs4CBjrQcv5A70PTIEvs4VWnDXzJ6dYS/QNizKe3TcgDmFmUryIKbDQSbzKvYFVyN1ClkBelSvu0FFxD4GmUQd55SRMvLrDB3s2bPikKyVmHD7NQNpEAxbGCTsxBKiUGkFCnyRzmMpNwKFs98yNlIWZFPSWL9lY7zbhtDRyCC++3g2BIyTrvpF/X0iOxFjzWg6NHd4tToO5DbN6/l/fBCxf9wBiNigzn4xcRAc0fkAPvfarNBEgQkf7AxISQYEDyQMlGkiH9wj67IVokjsM9Loxu4C0ixjOVrijfKgxVoHX5Rfd2EbT+2httSwppGut5jE+fBiiTQQ2/OBUzCm2FZmHmH40BNyYN9J8a0M0T4lxsBK0nLEwMnRnEMrco9hT8tJwxB2dCzVpJCRx6GnqEjjnefeRo4aOlqbYLIJCksREycfyi4EkbJVawblhbqURzbLTsutZ+q13zrjEdyyZuZoYr8GJnfuX5djt8pze2+gZPQ0Vy5gyuKL5z2B/0bZ4AkZ/uk31Sg/e4UdAXjc6iIEaFXa/OADXVfu0kj8I1n
 j6ltVG+z
 0CmkavdZA2f9DqZGIknsPuXfLX8Ft+QkhdTjmWmQAn6BMLDiASQn5O3OVG4N2uS7zpLsOZPpiGOunND3ak5ctN9h9jbo9AgpYBkxyJ6+tOVgLoLlUpItStfq+7cEIF4J4zLzOQIDIJzCdJltqSRqrjFo0jBjqfQL5GWXLD0HCM+NCUCtx4dQ4yokxhPZXdh8w9QtcyWp7lN6tbdlqWpRP6HYHTgylcOE4Z0jvukrr8GHDAOn0Kf4+CvICoHslvUINpdUiDBrhYe8cj9nGSyfnv/8IuQu/zBGGtHemDeoY77y+DUbtDJSOwkbJAU4Duw7tHy+4Plx7ssyqSD7TmuOmSevMqJ7J/ztb2G6qqecCxTManELFL4Lnm1V3lpBJeDfH6llU6P+qBHm6l9ijiCzFrKNy2DS+RNHsbbJ5NmGBSS53426dOAqy8p8WisVYmVxjLj/gDHnMWziKWKuFr8rUBgR1iZA7LGCnd7NERlpYS1Jb4pXdkJHAMgKhyaKKo/suIpIt9rbg99R4h5eheZAGwtzQQoOE2CUbabNSXdU0Ur7lIvgJ1bAPvYPG79+Hem5uvW3+QabM06PCmM+ldatwHUZXQ2YwYp2bCzC3jra4FJtgJyop90b9c5MPwEw0UJqlfMPClGWNiAidmlU6E4maftRRzsS0GwDuGu30cjhA0Mrn7jf4D5wV+rhL9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> Michael Roth <michael.roth@amd.com> writes:
>
>> On Mon, Aug 25, 2025 at 04:08:19PM -0700, Ackerley Tng wrote:
>>> Michael Roth <michael.roth@amd.com> writes:
>>> 
>>> 
>>> [...snip...]
>>> 
>>> > @@ -435,13 +430,7 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
>>> >  static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>>> >  				  gfn_t gfn, struct folio *folio)
>>> >  {
>>> > -	unsigned long nr_pages, i;
>>> >  	pgoff_t index;
>>> > -	int r;
>>> > -
>>> > -	nr_pages = folio_nr_pages(folio);
>>> > -	for (i = 0; i < nr_pages; i++)
>>> > -		clear_highpage(folio_page(folio, i));
>>> >  
>>> >  	/*
>>> >  	 * Preparing huge folios should always be safe, since it should
>>> > @@ -459,11 +448,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>>> 
>>> While working on HugeTLB support for guest_memfd, I added a test that
>>> tries to map a non-huge-page-aligned gmem.pgoff to a huge-page aligned
>>> gfn.
>>> 
>>> I understand that config would destroy the performance advantages of
>>> huge pages, but I think the test is necessary since Yan brought up the
>>> use case here [1].
>>> 
>>> The conclusion in that thread, I believe, was to allow binding of
>>> unaligned GFNs to offsets, but disallow large pages in that case. The
>>> next series for guest_memfd HugeTLB support will include a fix similar
>>> to this [2].
>>> 
>>> While testing, I hit this WARN_ON with a non-huge-page-aligned
>>> gmem.pgoff.
>>> 
>>> >  	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));
>>> 
>>> Do you all think this WARN_ON can be removed?
>>
>> I think so.. I actually ended up dropping this WARN_ON() for a similar
>> reason:
>>
>
> Thanks for confirming!
>

Dropping this WARN_ON() actually further highlights the importance of
separating preparedness from folio flags (and the folio).

With huge pages being supported in guest_memfd, it's possible for just
part of a folio to be mapped into the stage 2 page tables. One example
of this is if userspace were to request populating just 2M in a 1G
page. If preparedness were recorded in folio flags, then the entire 1G
would be considered prepared even though only 2M of that page was
prepared (updated in RMP tables).

So I do support making the uptodate flag only mean zeroed, and taking
preparedness out of the picture.

With this change, kvm_gmem_prepare_folio() and
__kvm_gmem_prepare_folio() seems to be a misnomer, since conceptually
we're not preparing a folio, we can't assume that we're always preparing
a whole folio once huge pages are in the picture.

What do you all think of taking this even further? Instead of keeping
kvm_gmem_prepare_folio() within guest_memfd, what if we

1. Focus on preparing pfn ranges (retaining kvm_arch_gmem_prepare() is
   good) and not folios
   
2. More clearly and directly associate preparing pfns with mapping
   (rather than with getting a folio to be mapped) into stage 2 page
   tables

What I have in mind for (2) is to update kvm_tdp_mmu_map() to do an
arch-specific call, when fault->is_private, to call
kvm_arch_gmem_prepare() just before mapping the pfns and when the
mapping level is known.

The cleanup counterpart would then be to call kvm_arch_gmem_invalidate()
somewhere in tdp_mmu_zap_leafs().

kvm_arch_gmem_prepare() and kvm_arch_gmem_invalidate() would then drop
out of guest_memfd and be moved back into the core of KVM.

Technically these two functions don't even need to have gmem in the name
since any memory can be prepared in the SNP sense, though for the
foreseeable future gmem is the only memory supported for private memory
in CoCo VMs.

Also, to push this along a little, I feel that this series does a few
things. What do you all think of re-focusing this series (or a part of
this series) as "Separating SNP preparation from guest_memfd" or
"Separating arch-specific preparation from guest_memfd"?

>> 
>> [...snip...]
>> 

