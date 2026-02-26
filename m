Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF08DFD8FF6
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 18:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AF586B01F2; Thu, 26 Feb 2026 13:25:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 487096B01F3; Thu, 26 Feb 2026 13:25:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B41C6B01F4; Thu, 26 Feb 2026 13:25:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 249146B01F2
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:25:01 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D9412C18A9
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:25:00 +0000 (UTC)
X-FDA: 84487434360.06.FEBEF43
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1A7D14000E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:24:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tXMPebF9;
	spf=pass (imf27.hostedemail.com: domain of 3-Y-gaQYKCO4iUQdZSWeeWbU.SecbYdkn-ccalQSa.ehW@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3-Y-gaQYKCO4iUQdZSWeeWbU.SecbYdkn-ccalQSa.ehW@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772130299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X3CnbC2LzEBnADf0H4jNpgSa/BKh2OZoa8tvpC3rGZ8=;
	b=MH0fDBZl/IiNIdQRYb7joldi+afJdYsq8sbUXS7YhCd1bpfnO0ZINPLJEGHaKkKuSo4haZ
	gBK85HKYqyJek7BQNf5oFJtVtVvEv6iLruwjyi5rhCp4yVNECuShgj3cjtgQfbBNwixcwp
	Ovc7AZrtqklxPDH7KltNUZno3Zxsvbg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tXMPebF9;
	spf=pass (imf27.hostedemail.com: domain of 3-Y-gaQYKCO4iUQdZSWeeWbU.SecbYdkn-ccalQSa.ehW@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3-Y-gaQYKCO4iUQdZSWeeWbU.SecbYdkn-ccalQSa.ehW@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772130299; a=rsa-sha256;
	cv=none;
	b=I6L5HfR44dN5wJd4uFJPGXx0yx0qnorqjmjkLd5+l4IH4CaLJHOJP6Q0wb44HH4WALAIsQ
	KVxkY3mhvGXW/WmeWgUrbi7SgYUbMe7lVKXE7AookZ1hFDNKzWqzfag859dxK6ZN23RBAt
	zCtHkfP2cqi5cEXB/GXw32GG5OK3BTY=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2adae76a9d0so13200735ad.2
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772130298; x=1772735098; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X3CnbC2LzEBnADf0H4jNpgSa/BKh2OZoa8tvpC3rGZ8=;
        b=tXMPebF9aghwzOxBMzHwN5VJt9OZtn/RujRQEwlF2VgtTg7fo8HcgOC9H1bBNewl24
         tKlopm4UKyszXss46lFulnrDdl5kJ3jRS6nzzj2iuwZjUaOqiCII45NOvv6POX5PEfRn
         yaS9+YtahRRI3WOwKCdLzSt8zZ4BX4BZuMWuiY0TPY3AvTSd7H6cpt8voX0XzoMM2VJw
         JLDEkASCUOPdunqDo4HHqjf7wiZb76OnmjvCpE/cPzAvEGje8WfP9oAWjGMBiy6UXBJK
         ij8raa3s61ZSYkOz5X/WPoosFwO7+BgJJ52mofWp2pVuhIYLjUY5FOmqJO8zAJfU403G
         qcSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772130298; x=1772735098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X3CnbC2LzEBnADf0H4jNpgSa/BKh2OZoa8tvpC3rGZ8=;
        b=GdoqlePWGU6yPZjuHX7x7k43M0EpFeVHko5i/JVkfbdXqHyVsfbKFCRtZfVJk5Rp7m
         KpKOh2u5zXpHeQB1d9v58w849V68inu8vuvEnnkwI6p70m+cL5dzKZN7uePtAlVgd7Cu
         8c3JAkEN1KFT8kmvvOCUGasYa+nb5+w3klp1lEa0p4t7hexnKRpOpWWEvs2UCfl7sKgJ
         y3wEEWyaCcxyvWdiffvXaIPQ3Qd3gpssKdMYGxCe5I4WqKkf28EpXcGlOvbZCsxqiOHC
         fTgG2XTPE6W5wl6dC3CO6/N3OrYzZY9VeHjNx4KsAjom62Sv85jNAQM+hQHKCBJTrvzH
         Xl1g==
X-Forwarded-Encrypted: i=1; AJvYcCV3ZtG7a1DxrTc7AyX34TG3iRmAORRKj07ltlhbWBB9JGE+i9cTI1JCp5eGmN4zfWSR5d9v/zgezA==@kvack.org
X-Gm-Message-State: AOJu0Yxtf4ysOY6X6PmBcHCIn9ZEM+AUKvwuSqrdTfeUJ1j1pYe6moWt
	x0Xy2h2iNxoFDTjbb6kB9iemYo2kHEARU6Fe5/8DY6O0HWwCq/J1z0imuSPfYFQ/z1UhN7BVtZe
	qQpHoCw==
X-Received: from plau11.prod.google.com ([2002:a17:903:304b:b0:2aa:e682:e951])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e849:b0:2a7:d5c0:c659
 with SMTP id d9443c01a7336-2ae0305efc8mr36873085ad.5.1772130297522; Thu, 26
 Feb 2026 10:24:57 -0800 (PST)
Date: Thu, 26 Feb 2026 10:24:55 -0800
In-Reply-To: <e3cdcbfa-525d-4e0d-885a-8f7d69a7ee3d@linux.dev>
Mime-Version: 1.0
References: <20260202074557.16544-1-lance.yang@linux.dev> <20260202074557.16544-4-lance.yang@linux.dev>
 <aZ9Xcgxa0_ouGr31@google.com> <e3cdcbfa-525d-4e0d-885a-8f7d69a7ee3d@linux.dev>
Message-ID: <aaCP95l-m8ISXF78@google.com>
Subject: Re: [PATCH v4 3/3] x86/tlb: add architecture-specific TLB IPI
 optimization support
From: Sean Christopherson <seanjc@google.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com, 
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com, 
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com, 
	peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	x86@kernel.org, hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com, 
	pbonzini@redhat.com, boris.ostrovsky@oracle.com, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ioworker0@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1A7D14000E
X-Stat-Signature: j4ynn3iuiz1x7ysmakn46w3nwrim9uch
X-Rspam-User: 
X-HE-Tag: 1772130298-183753
X-HE-Meta: U2FsdGVkX1/wXTrmmxIL1YQoJgy2zbyQH0w4eVv8dtL+XapYds9izcOZXDMSv2w2XnlRX4ST3jtFZrUaMywXGBulwf1J1f7lArosU7Ihnaan/9avT1wiMwK8PTuxRULzbrXR9kBYbrqi0sMNEkThxD55PRrg2Sk1ut6HFiiHpOfDPdB2conSF5i1SkfC0OPBZ68JD+spXdWfKn9TjSU22wAmMg+1sxcvLPqK211HGUBB6JdEFjiB1heHENkhYbTISBTt6cEI0fCT0bDfyHbEEDV/+8dxjmb60+rWUoHD9IqYfDXW8uDkMoIf6ejdVqXXdfBhM4PnKolycwTnzCkqcfkiZ0kvLoe5iRzLxPfiJas95QCNQ0Mt1BfllDfvo3pv3cFgyyWhmUp9X0jOcXQOdOo/ckGMPfTKcKCl1J8eyR8XbCfmXJ/Nq9qvOTSakOiet5iI6AjvAFIEa4Yreum/ReYATGVjgL5J0s5wMD3qFLth4PGlLY4dqQtHSxCShS4i3gBA7Ysvq/E3HEZys1mwG7zlYOzPEQSmeF6FqLa7iWs20g7REJeof+BDtpkMY81UL6iHfK/G4J+ogEGVrSv5pSFLtI/vyRVD/wwVD8iuFnVKBUqh3uhFulbtcgmWqXyonCVP8MdB6tzcz4Fw4m6K7M2w40zExFG8cEt9avFlCALFgrCV+aclMSMouQFUsnIm3RbEgxDcwNih93Fusog3zxmaL0Lb17s22Hnp5F5Ka8FRTsOYwxfQvsoK4Cn6QYIkIaDE9c0VyACdiRmVWOPm6wVTbIOcCeEmAfnPiAly3wTyJhrpBGBiMQ7/h5EXzLH74853gs3+UiFRlMl1Wu05uFUYZFzsU2bVUNOemxXd8iCEepByOuNFIzKbDtBCYh63bR2JLmSBrBvfXTv/5JA+cFSFFI/C5hGq/k/bzRcH4cUMaFTRQBLlrTYT0OuOnDfCGGuW5qjsux6iu/Gqgcg
 0VoM2quF
 AH/ERcFpZ/5tv0Vljhs1MujrnTLm9K4e+0AMxL3juFaVrAsx6J8301f+uWJ6be/QUpFFz+RflM1ONLCW4lGl3WVqv6oDOCybQ1wqzNqlCwhgtjk5CyVZgUGKZn/iRpZuEmLteDJzgsAoa197XgXpbIQm8MvQzfhIP2Ss0B5USWclShZmtm0qSvs4/ZzjNXamMpDS5LRHDNV37ZdcrKinYDUEiVQPMhAYrhvxBKAM1GW4+l4SACjbH6BiiN6icc4bjfw93vj0WF9CaYZGwvZZtMlTS83WLDokboDvSHV7+BCWgSp8hHJKe8oKHFD+RLwYGYhnzdKGlO+b3yqMEHlfP3ziN4GJljOQgVMdl9Ju8h72PSlxnTNsZWXjegKwck/f2yLrqsoAeUlkoWMU0jzKSxx4SKLuWpWCjEfHF4pzOhmatvhnDuqv2vZqtRFhRLdTBjGhlE6LFCYqUenYMlsUoKlM+/d0zV9+o5Si2Vp+Ha8+kPInXhflCCi5k0mHaMM08aNBcuqaOuII2o2dg2kdxJvpWbRIcxrf5IBHqLXeSTjfKMY1bZABLDXjz6XDBMyWQuq5juN1+z8yKvJbOeNruNg7E4mT1YCWarlhIo0nhMEyZbWEKQjsks3oRvZXn1iitQGzsSDr6jrBznTjoeT97OZLS4qQbSl/zGYi0QLHnb80smO8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026, Lance Yang wrote:
> On 2026/2/26 04:11, Sean Christopherson wrote:
> > On Mon, Feb 02, 2026, Lance Yang wrote:
> > > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > > index 37dc8465e0f5..6a5e47ee4eb6 100644
> > > --- a/arch/x86/kernel/kvm.c
> > > +++ b/arch/x86/kernel/kvm.c
> > > @@ -856,6 +856,12 @@ static void __init kvm_guest_init(void)
> > >   #ifdef CONFIG_SMP
> > >   	if (pv_tlb_flush_supported()) {
> > >   		pv_ops.mmu.flush_tlb_multi = kvm_flush_tlb_multi;
> > > +		/*
> > > +		 * KVM's flush implementation calls native_flush_tlb_multi(),
> > > +		 * which sends real IPIs when INVLPGB is not available.
> > 
> > Not on all (virtual) CPUs.  The entire point of KVM's PV TLB flush is to elide
> > the IPIs.  If a vCPU was scheduled out by the host, the guest sets a flag and
> > relies on the host to flush the TLB on behalf of the guest prior to the next
> > VM-Enter.
> 
> Ah, I see. Thanks for the correction!
> 
> KVM only sends IPIs to running vCPUs; preempted ones are left out of the mask
> and flushed on VM-Enter. So the old comment was wrong ...
> 
> IIUC, we still set the flag to true because only running vCPUs can be in a
> software/lockless walk, and they all get the IPI, so the flush is enough.
> 
> Does that match what you had in mind?

No, because from the guest kernel's perspective, the vCPU is running.  The kernel
can't make any assumptions about what code the vCPU was executing when the vCPU
was preempted by the host scheduler, i.e. it's entirely possible the vCPU is in
a software/lockless walk.

