Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E83DAD46C04
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 21:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A299E6B0005; Wed, 28 Jan 2026 16:47:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0876B0089; Wed, 28 Jan 2026 16:47:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897B46B008A; Wed, 28 Jan 2026 16:47:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79D036B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:47:55 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1E9E71A07D9
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 21:47:55 +0000 (UTC)
X-FDA: 84382710510.08.0157F64
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id 13BCC180005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 21:47:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fKp0J8aO;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769636873; a=rsa-sha256;
	cv=pass;
	b=2H21HEvUM/MQ0Lh/Esas2oTTDVIkSgHVOehCsqs91fuHFgdDELuan0HODF+jVe8oUogiVj
	EFovpVAN4EWNxHciDHfmT1s8OeoX+oqBDCdVWxqNE8EdXRu0urU9a9/XwDbFAADhvbvPO/
	eS6ief7u008QUv91agrg7mlWqFxC7C8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fKp0J8aO;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769636873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8KRtsUWTPrRQfD/St3Ag63nt0POKWslcjlDyzaxfyec=;
	b=nVZwX3u60cNL6c/F4HhNbTLtENVjnxHb08dG7Pn60qwTP21fVq9x0v/wIWZ5F48p7LXBUU
	CPZaNhpWiKckcGjHJTz8NUOxIyJr6IuGnjgoWX6dwbZXJ8pxkkLqoI0ebzi1i8vTaaYUt5
	TEZNtclgFPJ+RFwuFQMv7S4KuKzp1YQ=
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5665171836cso200787e0c.2
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:47:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769636872; cv=none;
        d=google.com; s=arc-20240605;
        b=fESNZGtWJrX3F1cHlhQ3/y3iOcymyBUjNunoALZ7LoOyBXY/VY/CEIBUaTDSF38YDM
         bYvtHfXjsNL5v6ieBflCOqw4mC+cQTzvXZRggh9U9F14S46BnLxwMK0YBDc6MfD5XgAu
         a+gr0gGzCsSlaBVTyXgjcyNER349QBbG5bT8nNNXQ1Oc/iKfFf2phOHmHZXHUIurscfp
         Cryq5rYhhtWkJvkcEHqCmDss5sjq1/q0Fcy5Ou8Q91EhuDLc8sJMV6/ATM8+J/yathAD
         H+4x/aU7syQZMmFIdcRItTaSQYe9uReUzYirJ+vU88hUeFVmP9IHZT1Pz8U4tR/uzlY5
         Z26w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=8KRtsUWTPrRQfD/St3Ag63nt0POKWslcjlDyzaxfyec=;
        fh=EnPWsx4aa3lY/xG8SxYYJfJ6ktRZ4DOVdPelmXypFM8=;
        b=XDFmqu87Ekvhif5kthD9KmVGq3brvpP5ykbaWE34eCPI+8xgLFGs8qfZ5mjGU6U5sL
         JiOM0aqRj+yrhi2kUONvLkW92o7/8KXET5ZwtKp2+jihgVLdUnYNDYbNWYnovtMFp14i
         dh0Xhooe4DNKrUuZEw8GB7ASTgXECLPGk7hpaZNMLWCJU2lS70GZ+psx8MA0up4B6GAk
         XE1dTeZQITwWAaPBoQCDgeUSOWMfDDROtXBMGI4XUPgmIPYFrzWr10pSUyBsd0iJJEMO
         GY2Bm2ZW7C1/9+6IBB3sYrsEilv3QDolQl/s+MHOHTgywV659qTC1HBPr0j6mEMBVGk7
         knpA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769636872; x=1770241672; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8KRtsUWTPrRQfD/St3Ag63nt0POKWslcjlDyzaxfyec=;
        b=fKp0J8aOnqdpt9I1zqRK+4/M+nrfsfYOGWoRtuMdiOu1MCHEJRRNEfg2hEjYs1pb58
         BmfZ51yfhGLEmWhKQ5DveR3J7QmKp8l4KF2Jwap6zPMeJ78TE3ygL5/8ZXRKaKXAu1Ce
         n4VXEYnKiLWYX4HYZYkzSmsFo7lLtUvwo6deLgDcSOT7QH9LJFJcopatZ/LTwoiL/Tzc
         hlejSOopP5modfv+juI7eEXxuhEAH0l1i9n0EpTiHrLsgC6pn5Jq9UynWtDSLPX0fxbf
         xbyJS3K53vrfs9ouv9f8EWJ/amHEDufSfCA5CmjxElMbYHuhQLOm8Q/qlL87JROL/pCX
         TtNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769636872; x=1770241672;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8KRtsUWTPrRQfD/St3Ag63nt0POKWslcjlDyzaxfyec=;
        b=Ml333PIhQBIGDhzI6Yd1IgvqrVB1eQdgPfTrV+yKo4zW564euPceumMxTr6OzQs3ch
         rXcbdn4OpYMZsVjIPQZmKqs+iWeTRnMAEDmoAmruo+KGhW0DSv05ZxPL/ktDtqMVe5oR
         LyPf0/+rCn8UXLIKbszr0Ki54ohePT7CTHgwaRZgaXmgF0h5RhfxtMAwLtI/oiAWwmjt
         cgEwsioTeNbpnTULy3rTr+bS6KfWZpxPEgbrAVJgxRFH9yi/UhHiDKQ5FZpXmTONo4/H
         kIc4v12ocphV+V6ptGPTxxl0ciFzDYv3xfPoDW5zoRwx68h6j6VSCJVYhemBEX9tDDhJ
         E0XQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlkX53JvAcfrBL9YCAEJbjDQ09S8jho+RdfoGJyhsCR9C97cqVAm2a9YM/AUU9XT9j8OjOOQr3yA==@kvack.org
X-Gm-Message-State: AOJu0Yy7E02jHLqCZbbTvPFnGhDP1fc78PsuYLWEb1wenwNRZn1se2F1
	30sheuTnAyiwX82GTsl+PayoND1Io7x5Sg8lU3/ycBN0B4GUW12kZ/KjiOLfswHcJ31aHBK5qBm
	IajrinfXRaQ371HH3QV0VzuS3tLiWSyk4oAecURJ/
X-Gm-Gg: AZuq6aK/E4wYChGxJl0tje+VPMrM+jZXAqDNnd0R9DOrqA+NDlGdNywCAnzBxQYCP/m
	PPfyeNbP8ItJrU5bTp2Y6Q/ozVYc8uC9FUIrw7B5jllYvcRsmB+4O0HEFqHvKs9KCaLPoeb6DcS
	sTYwbYFAHGaRbF+USI12/vdUFqm6CKRuhJ9kq/UPTeg74/uzVscU92zDqyZHkd4NjynKDwkiGU5
	PyzVUYb28Qh8PO0RA6ZCm9uY6JkVwz6S9LxmQHNdweFHrxRGviM4b9xqh19ZiOXsVkY2PvI3vse
	d5Hb0q2mTU9frMNAh+mBtl4EnA==
X-Received: by 2002:a05:6102:144b:20b0:5f7:24e9:ece2 with SMTP id
 ada2fe7eead31-5f724e9edc6mr2295689137.28.1769636871290; Wed, 28 Jan 2026
 13:47:51 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 28 Jan 2026 13:47:50 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 28 Jan 2026 13:47:50 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <07836b1d-d0d8-40f2-8f7b-7805beca31d0@amd.com>
References: <cover.1760731772.git.ackerleytng@google.com> <071a3c6603809186e914fe5fed939edee4e11988.1760731772.git.ackerleytng@google.com>
 <07836b1d-d0d8-40f2-8f7b-7805beca31d0@amd.com>
MIME-Version: 1.0
Date: Wed, 28 Jan 2026 13:47:50 -0800
X-Gm-Features: AZwV_QgPf8aOvxqDX4gr94R7SzOt27JuvroRVjSaL4ACWGO_5lJuitif3BKdULg
Message-ID: <CAEvNRgEuez=JbArRf2SApLAL0usv5-Q6q=nBPOFMHrHGaKAtMw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 05/37] KVM: guest_memfd: Wire up
 kvm_get_memory_attributes() to per-gmem attributes
To: Alexey Kardashevskiy <aik@amd.com>, cgroups@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com, 
	mail@maciej.szmigiero.name, maobibo@loongson.cn, 
	mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org, 
	mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, mpe@ellerman.id.au, muchun.song@linux.dev, 
	nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev, palmer@dabbelt.com, 
	pankaj.gupta@amd.com, paul.walmsley@sifive.com, pbonzini@redhat.com, 
	peterx@redhat.com, pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, 
	qperret@google.com, richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, rostedt@goodmis.org, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shakeel.butt@linux.dev, shuah@kernel.org, 
	steven.price@arm.com, steven.sistare@oracle.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@linutronix.de, thomas.lendacky@amd.com, 
	vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	vkuznets@redhat.com, wei.w.wang@intel.com, will@kernel.org, 
	willy@infradead.org, wyihan@google.com, xiaoyao.li@intel.com, 
	yan.y.zhao@intel.com, yilun.xu@intel.com, yuzenghui@huawei.com, 
	zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 13BCC180005
X-Stat-Signature: 414187na5hduz8mos8i3ojp87nw38e57
X-HE-Tag: 1769636872-867388
X-HE-Meta: U2FsdGVkX1+AztpURpehDouvXTWgeBjWtF3WHHDjd2hW9qrH185JG9JCxlntsJh40QQCWdalxddrwA13s2w+JWq8mi5uUPh+CFezzkeedtNecj6d/XozaJw0BN0L1Th0LV2RcIaOAlo0dXkkaflXB8jklAOcCswJ/dSwzbN0/ViWhXultAy1I2MsMg1wFlyjO48k+1gkLBDt91YxrR+xhAT+ShYmgi2G7Vu4hQvbR1US9nlHgITliUhe6yltX0KN2SddMVt/pP7cvTL1Q1KPP9ptNGEnIhFT/ad9QfqYCqK1hqZpBCtMvfZzkChPYC81e3OlJZyKJf/BkvxSzL8CDGDu+eUoNaOiCGx9O/yroZDjDvNwkRPhURDPC4oKX+d8vQCUz35ies/oYOz2+is5PRjPyS8G5ezpFwLvkKmjlCu/6A8Koi7Zo+avhQrWT6d2FkKiXy5DCpjxMi4zH80kK7QgkK71a7H5ecMDLgglLy9UDxlizpvwfcGfKsWOfbFy55FXxKVQqRQXszRhzBhpbhbk2DW1ovdt1zZi+ExxNtjSxegGO4o+wG65aZgeeCpsOFKe7jpXoSIBcXITvP1S15jRtUb18pb6xLAXd0an6ElilsWYByYcu9c4/JD2LFf2JIWjPQTWB+osNJmoA2W/cismF9rXkwDoTjCiaaQpFF9m31weTqpmc3XQJUwDwrA/ukKOYPw3xDhX7G8aLkVj78oUemlFjk4ejI2qyXj99fmCHmC/IB5B+8BqPX4axqHNmiLnKQ/7WKUlfUFT1nay0f5PHlMJxZfcRp1tClB7QF8N976PJU8vxizPB3M1qpKTVkFmlx0hwuQtJiz4nKaDvwdiYy/ckcqeREx4tgAnpGxsSaSea3uP8NrLTX7XYlCvvj7OC+cWQvzJtVUl15/Ua7gl+jufB6lQBrjVhuwoQ9h6yxDNVoxfH/unsJlH1LHdGlC5gPnwy9jojdU8y8y
 W1YLjJ/x
 AZ4DzuvFe8Ujz9m/dF6VI6Hy0ZkYqL6pfjim52V2nXlMXiQ9kujOtmkapmpM9ZhsbJrHKYyb64yOx4Op6mzKiUZb6tXsbJdk6kmVa6NDbOdGR5QEuDsxw4u4tt45Pnvi2Mj0831pFOOJgazyevgrJxBkaOfJf27xZfmw5ONT41QMYtfITze1Uzbyrufd/RLZLqrDRLoUMBay5CnH3dn+cAjl+xaikh4oypde+NLpiUtgQDw4JFdsNIjG6gNb1o2KmvrZKDpOy8MEy4hXVTGPjZ3jn8rwOST3TiIEJOpeKaE8mNwuPdywDoH69evFnuVeEHiMfazrL83KPeZCwWt3VaWXnhfbRhEARvrgaMCTCpeaj6h5a+BFQ3+G5P2b2XpVouZcbBO4EjPx44pPkX6TC0RTMivKaZ/phDINiVL0uy8DtIMyjajtYAkxz4qN0FBJA3X18ZBvt4uXCubP7fEq+IeRuHQL6md36l4Aw9QOQobHdH4RkcN+Evzz6QojrrAo1vOdIpO7Woj6PpuqwCQUF0lXAiw/bDbeTDn0V8b9EHkWiXKWwscxuoU5bQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alexey Kardashevskiy <aik@amd.com> writes:

>
> [...snip...]
>
>

Thanks for bringing this up!

> I am trying to make it work with TEE-IO where fd of VFIO MMIO is a dmabuf=
 fd while the rest (guest RAM) is gmemfd. The above suggests that if there =
is gmemfd - then the memory attributes are handled by gmemfd which is... ex=
pected?
>

I think this is not expected.

IIUC MMIO guest physical addresses don't have an associated memslot, but
if you managed to get to that line in kvm_gmem_get_memory_attributes(),
then there is an associated memslot (slot !=3D NULL)?

Either way, guest_memfd shouldn't store attributes for guest physical
addresses that don't belong to some guest_memfd memslot.

I think we need a broader discussion for this on where to store memory
attributes for MMIO addresses.

I think we should at least have line of sight to storing memory
attributes for MMIO addresses, in case we want to design something else,
since we're putting vm_memory_attributes on a deprecation path with this
series.

Sean, what do you think?

Alexey, shall we discuss this at either the upcoming PUCK or guest_memfd
biweekly session?

> The problem at hand is that kvm_mmu_faultin_pfn() fails at "if (fault->is=
_private !=3D kvm_mem_is_private(kvm, fault->gfn))" and marking MMIO as pri=
vate using kvm_vm_ioctl_set_mem_attributes() does not work as kvm_gmem_get_=
memory_attributes() fails on dmabuf fds.
>
> I worked around this like below but wonder what is the proper way? Thanks=
,
>
>
> @@ -768,13 +768,13 @@ unsigned long kvm_gmem_get_memory_attributes(struct=
 kvm *kvm, gfn_t gfn)
>   	 */
>   	if (!slot)
>   		return 0;
>
>   	CLASS(gmem_get_file, file)(slot);
>   	if (!file)
> -		return false;
> +		return kvm_get_vm_memory_attributes(kvm, gfn);
>
>   	/*
>   	 * Don't take the filemap invalidation lock, as temporarily acquiring
>   	 * that lock wouldn't provide any meaningful protection.  The caller
>   	 * _must_ protect consumption of private vs. shared by checking
>   	 * mmu_invalidate_retry_gfn() under mmu_lock.
>
>
>
> --
> Alexey

