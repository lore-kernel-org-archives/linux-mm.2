Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B342C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A86AA6B018F; Tue, 18 Aug 2026 12:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5DC96B0488; Tue, 18 Aug 2026 12:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974256B0536; Tue, 18 Aug 2026 12:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CC396B018F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:11:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 151C78011B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:11:18 +0000 (UTC)
X-FDA: 85114879836.06.B72CBF1
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf30.hostedemail.com (Postfix) with ESMTP id 542BC80014
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:11:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wb+uQEdD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3IoSEagkKCJcK1ILEJ18L7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3IoSEagkKCJcK1ILEJ18L7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787069476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gq4c916t8aM4R9/gOTYj07vE672c6Dn+UdOcLkpJL3k=;
	b=18wLOP2/7QQbFFOprvC25RTJSTdgz78hjvXpLez4mvk/ze4Muhmg2Z2Booh7H8vPpFUkvu
	D2KBBtYy4PrYXD4XLEMZEOykx7nUDJuXnUOcsxMONJJ8OTEARf1VirqQJoCi8ug7v1q18+
	toxqISrRiBCJTJfedfBzBwLu0FEWqo0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wb+uQEdD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3IoSEagkKCJcK1ILEJ18L7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3IoSEagkKCJcK1ILEJ18L7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787069476;
	b=1rSpWiiwnCY0fvIWdPPpXS75BccaH9eLbg5a9LQDkseJh8/bV6wEbLavjmzUobOajq2vCl
	98n0hgUsaD5KzEpeMFUksussDkNyhQZRa4TRZtUbTUTDZEFOg463Xxa3T7+d8ZMRtzo8sL
	hc6U32D/dMTOjrdqCSpGcZLARn/FVt0=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c1c4715cf0eso422232066b.2
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787069475; x=1787674275; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gq4c916t8aM4R9/gOTYj07vE672c6Dn+UdOcLkpJL3k=;
        b=wb+uQEdDB8Dm1rgeIwtk0Bily9TSb0Joq15+oT6MKmYJAsnNXR/eKq+rUwdvZCuwru
         HJG3RQ/3v1dA+o3s7CXEdbvQNFlydCfWyg+FdWdUFHILt32QakvwRAWwzuA6q2zGbc9x
         UBPuJ+wbNLTeLwNsFYjiVqRaldFoo13U7VR8c0MeEM51+G4Bq/tAcEWwXdBWW40TMI4W
         w2RTx71rofcM/j31+zJtwi8xYeEw3mU+pe5O6VEMK5LkKyGjSpRBr5UT169kJfN2pr50
         GmqFSg23+6OrqtAuMTebqrVKCgQh4ThiWz6WOMyFLqg9Nviv5xmcwqE+Cj8ckYdR/skR
         MTRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787069475; x=1787674275;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gq4c916t8aM4R9/gOTYj07vE672c6Dn+UdOcLkpJL3k=;
        b=NwFI/ALUsZpTgLdEk4fckLQuZga1SjISh6MuG9hjGAF4TzjG1Ctz+su5+8c3yS1DWi
         d4XHaYNS/0/0H8HfbsGMARMDWaqxyAssvs+hG2xZDRJonIka7zdQIV+uGZsxGJFojss6
         g+RPNcJWmU3huyUDHd+kkRzEdRYr5gdmHb6T64srsiG+RV5GEXur2doLTuXH+saI1gay
         O0I4F6Ru9j2Df8ZNTAHhhGWbN8gzVCrQAq3wcoH2enjlDo0xAsEB2uwzTR0T60v/v6Tk
         uWOe2ha9MVJmRFnoKykcCHLVgfn6Bsx73aRPvIjNeh01TCsLIj9pY5Intv60W3bNV+u/
         0EPQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr/iLim9fdB6UwKvAoq2cyNQs803MUOT0WZTYPMKt53pACX1FfKRelyK2NJ0BAwWBKWB7MqqdC7kw==@kvack.org
X-Gm-Message-State: AOJu0Yz/5Rx2HcE0+livro8rovi06yD+tEzm3npgW02FdwI+M8Rnj9Te
	MYatcFJCyHeK9PSkpxoolXn6x2Qgi8VqDpQkMIYDCzLmoOhE2hpghYf4hVHMPDyoBsyvlQC4DjT
	rSWhotBmyZxcCTc/gxA==
X-Received: from edrs9.prod.google.com ([2002:aa7:c549:0:b0:6a3:6b8a:8011])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:434c:b0:69a:928:9405 with SMTP id 4fb4d7f45d1cf-6a38a8dbbefmr17632626a12.1.1787069474414;
 Tue, 18 Aug 2026 09:11:14 -0700 (PDT)
Date: Tue, 18 Aug 2026 16:11:13 +0000
In-Reply-To: <ans2Qvo0453cc_DD@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-2-tarunsahu@google.com> <anpXjM_lg_UTpl0q@google.com>
 <9huzqzk4zt3n.fsf@tarunix.c.googlers.com> <ans2Qvo0453cc_DD@google.com>
Message-ID: <9huzlda3v272.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 01/11] liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
From: tarunsahu@google.com
To: Sean Christopherson <seanjc@google.com>
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 542BC80014
X-Stat-Signature: mroie9k3p8w6wt1nyud9ar5mmba4kgd5
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787069476-254913
X-HE-Meta: U2FsdGVkX1/jCxWVo24DBQu/CU4kwxGG0JVDEfBfk46O4qxFeOn4BGByxXhtjHL/QZyq1tOhaN3MhGWp1DkDvXpwZo+gh8Tx+PtJwKsZTz/XcSYLijIIP9/o21hj0xh/UMVHG9mXQ9PZWsRSHPi1EK6PKLWRUJJyX127Scj8OM379QbupwGL+nNwEwZx33W3lIFUCysi9fh4PwMh6qZ6gPkpx26Nj1TFqBTmT3MZwzTyIXQebNwWTPtdXGpPDW8wmbuRKDbnvPa2Fqr99RdYVeOBIxJ8fAhksho3bfVmeuwS1FSiC0XuD7OtdC+2XYy8m4qA1yaUNbLb9Z1UstqZXAm4fGnulJieXLYHFe6rvQSR0ujm/BkP/96ZXXvLdY1W0sAbwKmeuaUACyftpFcBvUgJX0gFemo5k/bZnyOOItSbQB4bIJqD6cgdGDjzAtpCAJL+LAS+OnfL6Flg39esf5lWyNXRXzOEByAg9yTkYpx1rkO18Li/d30BrUhEaK7AWj01rRWCqOld9GH/CaDNHgc+x7nUl5SEP+zlabZmjdfvwhBFylWPbt4C92dYkyS25V4KfrJua0Ry0xO42ZDPesAfJFF/K9WwgJnIms2Z8nrpStFILDICUIBlPRkvDdVt8VaSOcuC+fDOWtzTgxP26KDmvp0QpfApHQ6IfKWOH8lTaq0FDsz3DqeaxmNODM7pbfYTvV/H9OXOS6+YictAOFRFbU1AIEJ0zzhDVNjbQvUU7kn8II/DPWG27vvJYUM/PcomhXNGEBW+pDzwLLHS6s7iQ9i7RajpQ698XeST6lTKsXVwAKc0+nHFVMLu0lnX8L5JAM+nMBBvHnx5HoVYtwjIUCHXS/gui43YMSwr9oFZ1U/prEyYgnIMHwjlXxMEYS9BMn3atM7Q6h1PUYF3hEoNhFurA4FxJx+yyQevTZlGbixZ5a6oK5D9IkQvpLLBv6Abn79d5WO9JTfs7Uh
 ZmFXZ/hX
 2l2FmsxXc6xU7ET4gpsZXCAwbC8tEugirGFaOwj3ZjfqJjB/RCh9wYXy/PYdDjyyO1NhFOyBP1NomyukUajAxR+3pjKh6Z8T9+PpT8WqPPzlQPGd6aW5CeVOJxFtHT1w1yftc31ab8AfGCmhlf9P1cWqJ4D+lLIlHuljivtd68KYzu8U2ESiIe9GzsRfAr75FReBVqoJEOJmisrFLOp2r5KaL6gTW2MNoXYEuwpo5qBvJ55UxAooTw1QFDnR+B/1nFKbj52ZfIx10pdeMdBCInSQNCuNfwxl6E8hXRZAumUX69h0afGtksWDdqIGsLAuiAFUc8iYdG8zzZPHMzMKVviVeqKyZ3ndWYeOZG3JLmP/kYFnNtbt7B5Hf3dSOsakoRHD3GbTlr97jcH6Rw8zweK20O1GfhbbJlTNrvXbjYqIWR2DkhLXKsO3pZmXMeozphGfYAEcTKeLh18Ub0ypGjtkNDvDm5BGqmW25P3bnNKDtUvP9BButf++aFXSaOTDTCrvZY4eOQzVVQQfZibvDECxrYRNUGneWoFy8pTWljB3x6W8wfBjiEYIb3+qlxHNBA3muMxRUOyny9vgDugfAa1iQ1cxkJ2GN9W++lN3jLv0lTWJolg8bTQCYRt4bJbVnBdxJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Aug 11, 2026, tarunsahu@google.com wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > On Tue, Jul 28, 2026, Tarun Sahu wrote:
>> >> Introduce the LIVEUPDATE_GUEST_MEMFD Kconfig option. This option
>> >> enables live update support for KVM guest_memfd files, enabling
>> >> guest_memfd-backed memory preservation across kernel upgrades.
>> >> 
>> >> Currently this support only guest_memfd files that are full-shared
>> >> (INIT_SHARED and no support for private_mem).
>> >
>> > Why?  Specifically, why do we need/want a separate Kconfig for guest_memfd
>> > liveupdate versus KVM liveupdate?  I can _maybe_ see a KVM-wide Kconfig, but
>> > even that seems like a stretch given that (AFAIK) hypervisors are the one and
>> > only use-case for liveupdate.
>> 
>> LIVEUPDATE is used in many subsystem. It is possible to enable
>> liveupdate and kvm without enabling KVM_GUEST_MEMFD. So GUEST_MEMFD
>> preservation must depend on CONFIG_LIVEUPDATE and KVM_GUEST_MEMFD both.
>> LIVEUPDATE_GUEST_MEMFD Kconfig is wrapper on both of them. It need not
>> to be visible in menu, So I can make it hidden. WDYT?
>> 
>> Also, KVM VM_FILE preservation and GUEST_MEMFD preservation both depends
>> on LIVEUPDATE_GUEST_MEMFD in this patch series. [PATCH 05/11]*
>> Which is wrong. So I will update KVM VM_FILE preservation to depend only
>> on CONFIG_LIVEUPDATE.
>
> Or just handle it all in the makefile?  E.g.
>
> diff --git virt/kvm/Makefile.kvm virt/kvm/Makefile.kvm
> index d047d4cf58c9..e6f098498795 100644
> --- virt/kvm/Makefile.kvm
> +++ virt/kvm/Makefile.kvm
> @@ -13,3 +13,8 @@ kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
>  kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
>  kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
>  kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd.o
> +
> +ifdef CONFIG_LIVEUPDATE
> +kvm-y += $(KVM)/kvm_luo.o
> +kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd_luo.o
> +endif

Sounds Good to me. Will take care of it. Thanks.


