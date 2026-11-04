Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C920D60A2610
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Z9tZ01LY
Received: by kanga.kvack.org (Postfix)
	id B2DEE6B05BD; Wed,  4 Nov 2026 10:38:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE2246B05BE; Wed,  4 Nov 2026 10:38:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1C8E6B05BF; Wed,  4 Nov 2026 10:38:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B4446B05BD
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:38:52 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A004714079A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:38:49 +0000 (UTC)
X-FDA: 85397844378.11.991A11B
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf10.hostedemail.com (Postfix) with ESMTP id CB82BC0008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:38:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Z9tZ01LY;
	spf=pass (imf10.hostedemail.com: domain of 3hlHragYKCDUjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3hlHragYKCDUjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793806727;
	b=MFGJy+F1GBZRHF83DdsV8xuvP0xIIRaHI+16XQKABeDUsit4qJhkEu35UQ5TYEh0lACvp2
	bksjWp7rhs9TP6lbEmU0prhcnuDADYrhVxjz1itNv9rko+nwmgXVAeo0ATsOmLrCo4syK1
	6r0DgdKVT1e1vlD/UgqMfSV2hmbwTlM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Z9tZ01LY;
	spf=pass (imf10.hostedemail.com: domain of 3hlHragYKCDUjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3hlHragYKCDUjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793806727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BgXz8h+/nQ9U/ZFrmreR3nTmSbeRNY7GAtat9khBnZw=;
	b=ZGZ3EgX8ig1KVugvGHahmN7QSffS51XQl3xuIm8VXZXvUxEUqJe/4JPB8NCgmPO625vLqW
	WNs/GWosfSl5PT22+YZMsdI0dGrD/MHzauIznxV4jknD3XZh3kRVV2AW6EdfCLjgTJk8+G
	fl3wdi/gNXY75RBzaY9RJLnXIYO/TRc=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b0ac277beaso164590a91.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 07:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793806726; x=1794411526; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BgXz8h+/nQ9U/ZFrmreR3nTmSbeRNY7GAtat9khBnZw=;
        b=Z9tZ01LYnRYIA8YLBFWfs+Orov0gLN+G/4GevWwwxFUOs6RyiJWlzXSC8tWRfTSqSV
         MqQ8s+oa4UY+dcHtnqRFDUq5pWanG7NpB4KEnUn7G/o5AidPeml5+RcnTmCo925r1LCv
         nRSHHSUDxNVKrMyk9bEctFpfNIZOOv4kBnsPfik2S0Qr73PY9GI3VAwJbXH47OPmEcTS
         pQgVrhvxGPj2sAPk6AoIVtcTdHTVG8lin7PGrTC4Wg/guxpFrKvhIZeOWIKHDBnOahA2
         SZ3+I9SIcOAnC5xc4X7i3baLcDJmms3teYQlkFzykfQf22sGy6zYCobK4lzozJeu3sUi
         O0XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793806726; x=1794411526;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BgXz8h+/nQ9U/ZFrmreR3nTmSbeRNY7GAtat9khBnZw=;
        b=hpBtJrjQH876d29HThmjQ8ArWyA3TXPc0KRQzyAWCgXs7exsCGBn2N2c60PoKJVh6q
         GGO46ZjRp662xhar9a47lQwNk7vOf35y/wb/97icJtpAGm53ZXtPqGkMwpNTPIkS1Ypa
         lAqpiOJpsElViQ+71ehtJcM6U+R0t2BUcOJ3ASWOF7kggkXyIW+BWfrYKoXryr7STK0r
         nZqEgTL4RICj3iawAMSPvh+uV/TFgFE2/gguyF2fKo6V4QOiY12vnjctfTC7DtMuEhjr
         KnsHrpzGGM690i6RCbOYQ8aUoDS3MPWw6DifCWOgdhF3ZYFCmUOGSEAohJCmjI0fR8W4
         n9Ug==
X-Forwarded-Encrypted: i=1; AKwUvBzsLvFgUCiWbL5pBbaar9+SO9dDPsAOX6koNK2KrzX9tw1FcAQ+PRrEQuE6iSigIHY9nUV5KLGFjw==@kvack.org
X-Gm-Message-State: APuU4Z+o34HVu2paV1gSH+fMKg/QyeRUyeUfdxsU8Wjy5LoWxvwKaPDa
	EbNadUSvN3rAF/dR54wR08GqKOI+hdhbzEguuFPYPlKDF64f9gVSlXsZfTBUoGt5p4OafRg/W/J
	5AtHpYg==
X-Received: from pjbnc12.prod.google.com ([2002:a17:90b:37cc:b0:3ab:5803:73a5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3806:b0:39d:f08e:e6e7
 with SMTP id 98e67ed59e1d1-3ae89574d67mr12860378a91.9.1793806726299; Wed, 04
 Nov 2026 07:38:46 -0800 (PST)
Date: Wed, 4 Nov 2026 07:38:45 -0800
In-Reply-To: <7ba2ca65-1eab-40fd-ae4c-f7cd9e156d8c@suse.de>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261029143336.390231-3-clopez@suse.de> <20261029175203.5bdd51d7@p-imbrenda>
 <df9dc526-4275-4784-8a0c-2e4fa8e96402@suse.de> <20261030133939.630e29af@p-imbrenda>
 <auis0SaMkRB6odsK@google.com> <b9ed9dd4-a1d0-466b-a6cd-89a4e70abed0@suse.de>
 <aun3w8gxwlmRy-GW@google.com> <7ba2ca65-1eab-40fd-ae4c-f7cd9e156d8c@suse.de>
Message-ID: <autRhZjOfLyw2OXo@google.com>
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: don't zap secondary MMU on
 permission upgrade
From: Sean Christopherson <seanjc@google.com>
To: "Carlos =?utf-8?B?TMOzcGV6?=" <clopez@suse.de>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: tesa5o8b7faxkny3hwhwq15qqfw3xu6y
X-Rspamd-Queue-Id: CB82BC0008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793806727-589484
X-HE-Meta: U2FsdGVkX1+X+IFGYvIS/8gWLulq9FKkc5X6El2J/qg8SmwUkHKUbr+4c0Ggpm1ZveJEzn812SetJ/MRaVeO49EJh30+Mub/6Mp0lGPWcmRH1m4huiWKhw3oDDjc1rSTQJybAHbSq5wSLMFe911BDRr92jqxlcEBV2q3zw2vzkw77eeMsf9/HHfXoREAowA5nqLKzt4lz8ccdO3sic3q9sIfCGdp8lkPEfYK4ifrOKZyfH3gPsigEuCOzhZ+h7DcV8JnM0zAW1KtikiBrdMmUMREyqkQG8yAf6TQEeRsBEz00hIHduVGOPoClmlxOfxgNSiaq4avV4/b3Y8NZvF+UYwu/RUyWxQV4ptlJG+gh58qAwbNQrw3SNT65BWm2b5pt8WlZFdr3S1RzD+t1A9pMFvqS6rHC0ZB92exk/0eLORdrpVyFXXj0wX/I4QyqrCHev2tGjy+2CmRw8eAyjfhJMB1aAOm4hYPO9c8CQaRly/Gq+ZW1iDtW+eQAleFKRk0UCD9+HRf+17eGifs3Ir8USBXWhOMT2qaooWqo/Ykd2Mmt+DuCtgLEGBEvKJDE6g4KGKqGyXbPP7VUnRj/7+dQjloi58kVN4OYg1WEguwahPMkqjA+pq9uOEVmHgtEL0m93rUxfrXiBWrBZWCP466wuQBEteHhUaRD2OhAd8fNFby2F6OE8WRoYDQkPSQvkdrvrxKJ86rtQDKI2PvlAF2ngW+opBjg6uYW1nzMfXbM0spUVYDfRvtuz4EIK4IBkW2bVed84j2iZWLEugHkjJrJWSCrH0S1rpoQGFCnZrmajmezCifKzaxtoRJPbMxqpsOVr1JAj9Z3lWlp1nBZnVCEZlx/lCT+0lW4lDaMIEPpdeKMiWPA78vz0ueIdpi55xzybOrvuA0HoNwgoZTN9XTjE6Xy65MamUs0bVTGF83/pCugRHk3BVqFnme8Vd6HCJWf2oJrMQZrqvL4lke4kE
 dLwvf7Zf
 vdLwej9ZsgPkFXQsxnkulHQJnP+k02MrYpe93sd5oFfDRlTveFUOd6tSO7sUr06bPyZO1WFo6+vWoXFj0znsliWGLGAtVzqBCwvnX+G6+RmUO3fEYyylwQg/psbaXc/DiGsX8uer7122w+8HUpzD5qwlb8XVGhb8a9SjlOw1w2TULV9XXKie9T7Svi0aeyDMb/NHmZA8lh7u6JAzY3wX53/7kRRf9TwGsqZLiNoojL7VVS6x7zYy/kyELtN3EB68lIOLy+qZIrO9v82kzgY4fQKPLRGHXgjrYEZPDlkbMYHLUM75gSddfCPwY7DhZvkFXjQ7gCYIBNgoUoqLSPP5OaNS4l05SYxBp1KKfx0saahMAiwXs1H2h3ZG+GNSblHTE4paW0K5a9jkYjvK9ElhkAVls7woSp6Ihx623w5mnPPv81IojZaATqQJyg672cuNeuM60Sm8DqPJgqwNeWkd5kFnd/0//f8aK9tFR9hNx82jKMlcIvbSIyVkNPVswPFXWwD60Po4yy4oGSEUq80J+BiI0KxSUsLKICpgGJ0XNjB4i46LV2EUWxxnVsdTdMcyRFP5ddMqmLJGE/gSdFQVC0y6Vpuu7OKll8BN7lct61pujpQbm6RPvb22nUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026, Carlos L=C3=B3pez wrote:
> On 11/3/26 4:03 PM, Sean Christopherson wrote:
> > On Tue, Nov 03, 2026, Carlos L=C3=B3pez wrote:
> >> On 11/2/26 4:31 PM, Sean Christopherson wrote:
> >>> On Fri, Oct 30, 2026, Claudio Imbrenda wrote:
> >>>> On Fri, 30 Oct 2026 12:11:07 +0100
> >>>> Carlos L=C3=B3pez <clopez@suse.de> wrote:
> >>>>
> >>>> [...]
> >>>>
> >>>>>> regarding this series:
> >>>>>>
> >>>>>> on x86 you don't care what the new permissions are, because you're
> >>>>>> updating when re-faulting (if I understood correctly). =20
> >>>>>
> >>>>> Correct.
> >>>>>
> >>>>>> for s390 it might be beneficial to know what the new permissions a=
re;
> >>>>>> of course we could look up the vma and find out, but since you are
> >>>>>> already checking the permissions, maybe you can find a way to also
> >>>>>> convey the new permission bits?
> >>>>>>
> >>>>>> that would make our life on s390 easier :) =20
> >>>>>
> >>>>> Right, getting the new bits from vma->flags should be trivially don=
e
> >>>>> from the MMU_NOTIFY_PROTECTION_VMA callsites. There'd be no users i=
n
> >>>>> this series though.  The rest of architectures still need the notif=
ier to
> >>>>> tell them if the change is an upgrade, since they don't have an eas=
y way
> >>>>> to grab the old RWX bits. Passing the old RWX bits from the MMU not=
ifier
> >>>>> does not seem trivial to me either.
> >>>
> >>> But why is core MM even doing mmu_notifier_invalidate_range_{start,en=
d}() in the
> >>> first place?  I.e. why add MMU_NOTIFIER_RANGE_PERM_UPGRADE?  Just ski=
p the
> >>> "invalidation".
> >>
> >> I briefly mention this in the cover letter, but in short, denying othe=
r
> >> users the notification seems like an overly intrusive change for KVM's
> >> benefit.=20
> >=20
> > There are all of two other users:
> >=20
> >   $ git grep -w "\.invalidate_range_start"
> >   drivers/gpu/drm/nouveau/nouveau_svm.c:  .invalidate_range_start =3D n=
ouveau_svmm_invalidate_range_start,
> >   drivers/infiniband/hw/hfi1/mmu_rb.c:    .invalidate_range_start =3D m=
mu_notifier_range_start,
> >   virt/kvm/kvm_main.c:    .invalidate_range_start =3D kvm_mmu_notifier_=
invalidate_range_start,
> >=20
> > and AFAICT neither of them wants an invalidation even for protection up=
grades
> > either.
>=20
> There are more users that register for notifications via

Ugh, I didn't realize we gained a variant of .invalidate_range_{start,end}(=
),
I thought those were for what is now arch_invalidate_secondary_tlbs().

> mmu_interval_notifier_insert():
>=20
>   $ git grep -l -e "mmu_interval_notifier_insert(" \
>           -e "mmu_interval_notifier_insert_locked(" -- drivers/ | wc -l
>   12
>=20
> I haven't audited all of them, but I'd say that at least amdkfd relies
> on the invalidation for upgrades. Without XNACK, GPU page faults are not
> retried, so the driver maps ranges up front with the VMA permissions
> (svm_range_validate_and_map()) and relies on an invalidation to remap
> them when those change. So mprotect(PROT_READ) followed by
> mprotect(PROT_READ|PROT_WRITE) would cause the GPU mapping to stay
> read-only and the next GPU write to fault. Unlike the APIC access page,
> this is the application's own memory, mprotect() should be perfectly vali=
d.
>=20
> This is the kind of subtle reliance that I mentioned before, and why I'd
> rather not open that can of worms.

Yeah, agreed.

> >> A flag allows users to opt in instead.
> >>
> >> It is also not clear to me that secondary MMUs are not relying on the
> >> notification in some subtle way. In fact, Sashiko points out in reply =
to
> >> patch 4 that the notification lets KVM retry the APIC access page relo=
ad
> >> in case userspace shoots itself in the foot by calling
> >> mprotect(PROT_READ) on it. This would require a really weird VMM,
> >=20
> > s/weird/misbehaving
> >=20
> >> as it would need to go looking for the page's address, but breaking th=
is
> >> would be a "regression" nonetheless. I will address this in v2.
> >=20
> > Nah, there's zero chance any real VMM is doing mprotect() on the APIC a=
ccess page.
> >=20
> > More importantly, doing nothing if updating the mapping fails and APICv=
 is enabled
> > is wrong.  KVM needs to ensure vmcs.APIC_ACCESS_ADDR is fresh when runn=
ing a vCPU
> > with APICv enabled, even if that means putting the vCPU into an infinit=
e loop.
> > VMX doesn't support "inhibiting" the APIC access page, i.e. the memslot=
 can't
> > disappear while the VM is alive, and if userspace mucks with the VMA, t=
hen KVM
> > needs to prevent running the vCPU until the mapping is restored, irresp=
ective of
> > mmu_notifiers.
>=20
> Fair point. Should I just carry the diff below in v2 with your
> Signed-off-by?

Nah, I'll send a standalone patch.  It doesn't have a direct relationship t=
o your
series, and the bug is pre-existing despite what Sashiko thinks.

Thanks!

