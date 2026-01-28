Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFE8CD3F099
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 17:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA96D6B0005; Wed, 28 Jan 2026 12:07:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57576B0089; Wed, 28 Jan 2026 12:07:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2C396B008A; Wed, 28 Jan 2026 12:07:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE586B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 12:07:09 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A01A1B0556
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 17:07:09 +0000 (UTC)
X-FDA: 84382002978.14.2D8ACA6
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0F61314000B
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 17:07:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UuY3jSmO;
	spf=pass (imf26.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.177 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769620027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQ2ByvmYGALpHjwu0udZOzYr4BMUegwRg7Tc5bSaMn8=;
	b=tj0KxwHbVNFGgd/E6IDghbbuJwH7lYGe8PbeHGrURwYuqVBCnCgXuQxb0/3by4cB6oFYA6
	2IsCq4Rs2m37WGohCqAX5AjwFX01ane8eLP7F+XEXJIc2rWQcczVxPCb1Y+VaNi+cTC/9t
	5gsjZBTpzo3DkplhSX4xSTvZ9tvryhg=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UuY3jSmO;
	spf=pass (imf26.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.177 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769620027; a=rsa-sha256;
	cv=pass;
	b=2yc6Yr/YlAqlwcMH59kKked3D6BmUvuRX+ut0GhmLroly/MCQmjbz9QjEjh2JT5PLdASoh
	CK/454mbqqu1cqbmDnj5xXdkWFZpjPzPKNj5/2LU6QvFg3JROqm5a4giNG+ll6tGUsp/Ur
	5RLqXGf3y74GiJC83xguwiK+Ud/uloU=
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-56373f07265so35226e0c.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:07:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769620026; cv=none;
        d=google.com; s=arc-20240605;
        b=C8ilrfToZcymC1ZqmGIzwmmiOPKA5gzNxxdHVdBfkst++QeT0qIs512CCKqsMBmoFG
         Pk1CZA6b8ZcpENfwSQTlJ2IB4g6sVsqHE4hTYA4LMsgWYOjh4MbExK9UzsNNh4BJ8Cg8
         IcH5vwtbyUyOzHl1ArYE7jMXwD1g0U5Bn4KaVnGMoxpZttTRlY81zi7kihlJ9bY25QKC
         QlOkadmplWSpca975nsKBvebuDdKTr/O2sAaoCIoWF2Gqtu2Dj1kToUi/MgPhWzkOzcz
         8h31LJ+678tl0MWgNsF30tH64CIH6Hl2Vv3Oep92+C8Gk9jPt5BBIvKwmrMUs2jRZN73
         IDGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=hQ2ByvmYGALpHjwu0udZOzYr4BMUegwRg7Tc5bSaMn8=;
        fh=TOeWD9XsWEoPL4tjUt3ix9zEbZplbeExaTntTKNslW4=;
        b=NTCLJrVIjQmjBuzqvalJnRRrhV+EzEPiyeb6dK37s4l3/PTvDFLBO66AiAUF7G0TA8
         EfZhaLJ18u8e+VEkOMvjt7IePI2l66kne1H2GlFOY8sEQsIInlqcMWKmE44bJotf9XPg
         Hs3692kx9HKAXsf22SED5jweUHchsQdA8OFvFskiD+YK9va03wP2KmkeQmjoZ+apTqqR
         iX9eTqwE7MOEKGWaQdK0tqzVF7mL9AszUubOMFjMFKb0GNhOG+9nWXvSEqOUO79lWZOS
         pYSiVsv0dTyRZ2xwC7VVFYJdyTwGW7zQmH8WFW2fONKlx9tAqacHQXL4IBTNR39Zn+Ne
         IcSA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769620026; x=1770224826; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hQ2ByvmYGALpHjwu0udZOzYr4BMUegwRg7Tc5bSaMn8=;
        b=UuY3jSmO29Mn+E62GDC5yOS8/HDw0w3XeuYwX23vgTh8ClAm81bBfC5WlS4LF3iAiR
         /COVGKRK/oyENKDoOme1tmrlDknaPJ+mrKYGByWxAjHSWIPsDz3p8nabMtYnW3f71Ou9
         5szn19FKnlcP6PK6vcXcW8s4CKFnaCjxkccBpiuHWgt/duG3PxWBIdXdIDJC4MlJ82zd
         kAGGTAsu0jYFy1hYzcOhx60GbFgBkJOTijn2oujYY5VsnNg6aNKyYz8JoPRCYbRlFB6u
         m97SFS0d6rAvqx/0tYN61kvlwFqDZ5v4cbo80hPukqJy9YizHbtFA7Wd9Ww6H6lchCIv
         X1Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769620026; x=1770224826;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hQ2ByvmYGALpHjwu0udZOzYr4BMUegwRg7Tc5bSaMn8=;
        b=JMkDvUa6n4nPRaAySpFInR1fZr0qSXPoDT4Vi8+HbxbWq56qPtf9133qODrrktr/Ck
         3qVk7y8dREXev/bXiCGeabqliBgcAMpI9dk8/gmLE+M0eq2ffh2htXPfGSmuukPeWzAj
         FPcyw7/s65qs5f0/CPmKSIPBkQePKyZ7I5/H8TFlI+eqtoeCsCr9vu8SQLQ5xkO7Wrin
         K0nKi1h4lZQkEMQ5O2TTt6g7PkGjPwTY3IAHR4rGUpj/owxWgpBzcyemWgIclYi3eQ+W
         Z7EhNjzL6cy5Nygv/oBvAhcUrE3uFrTCaS8B0CjP0QIiOAnC/rVQq73tFK1JYTQ3nBBi
         XoPA==
X-Forwarded-Encrypted: i=1; AJvYcCUaMmrgg/CdUCxNQGFnnW8uWFnQL7+AAIx4GwU6/Wv406aU808wQ5QgSAbcNp9CgIov6VJ+qV0Cgw==@kvack.org
X-Gm-Message-State: AOJu0YyVg0Abg5YqH3ZssgbiH5kYsgxaWUjrpmuxkPyvzAzIZrdA63Tv
	9FdMrLZLhzJfNfXUBO31Uz0TeAqoBq7yRd5ZFr72MdNF1Wbh+36sURECBDiD3xcnlPxqNfQ2pu5
	1+TxuIML7/C2y4QNzxAsrWSQ1waxtxLDNB4jrNpwe
X-Gm-Gg: AZuq6aJbgzYtnXm5xUcFSVejKV6l2Cm64aZqPj26fqjazvZEHZX5C8EGEY5+hhC7AT0
	K4jmnbPedLDUeXXZzZ9sbquKhqJK601ETWTgRKEbb8b0xJq8HKco9X0uTgCgJ2p3mtITeDxhDJM
	m/Apy6/kXgX+35ieDe/2X13sGTmB/RDukghXR2WX72zKNGLDJ/gNuKuoviaHkKpDXOu4cHKxUI4
	cjgYpq3GLsrTWAxbaJmTGC04pJjpA7C/oMa2/KOXdy/q4rlwNxjhL8GOxZAM9RZsNYelJ9Xphwf
	jY/xcbkrCfHTx4qMHywmC5l+K6Im5/WmZ1BU
X-Received: by 2002:a05:6122:ca5:b0:54a:992c:815e with SMTP id
 71dfb90a1353d-56679502f80mr1751301e0c.8.1769620025275; Wed, 28 Jan 2026
 09:07:05 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 28 Jan 2026 09:07:04 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 28 Jan 2026 09:07:04 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ab3f297e-44d5-4f42-aa17-f2e7c135580e@linux.intel.com>
References: <cover.1760731772.git.ackerleytng@google.com> <638600e19c6e23959bad60cf61582f387dff6445.1760731772.git.ackerleytng@google.com>
 <ab3f297e-44d5-4f42-aa17-f2e7c135580e@linux.intel.com>
MIME-Version: 1.0
Date: Wed, 28 Jan 2026 09:07:04 -0800
X-Gm-Features: AZwV_QhaOE_wJlLL_hX7tpT0otF_GVqIj23tN-vGGdhqYGAPjKuSGPxvod54AXo
Message-ID: <CAEvNRgEo2UZ63uv0F7Pv8VfeJipyu82b=Rgiz2gnttdRu9aEPQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 01/37] KVM: guest_memfd: Introduce per-gmem
 attributes, use to guard user mappings
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org, akpm@linux-foundation.org, 
	bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chenhuacai@kernel.org, corbet@lwn.net, dave.hansen@intel.com, 
	dave.hansen@linux.intel.com, david@redhat.com, dmatlack@google.com, 
	erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, 
	hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, hughd@google.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: cfad5yxz4dyewgkr9n7tb6c8fo5pohbr
X-Rspamd-Queue-Id: 0F61314000B
X-Rspam-User: 
X-HE-Tag: 1769620026-700184
X-HE-Meta: U2FsdGVkX1+3Q0TNpusmpCVFmFKTZM0lO6uyjaQUsmIyek9zzh6mUqHgtOuJJoLQcwHHLThppInaJhK+Z2VzSPiAahAJ7PBc8e8amk35lslLY1ofcAY6E/eg/frCV1RIyiNwVgFEFfRVxPzJ9xOLEcPRVfAoF2Orq1sFB7RALSx7T74+BzF3uFjcZNShy8MZZ2hfbYIT2YQ063PmQ7lPBkaH0t6GZaJ3UJ2a/fw7TsuRXZhx3ljiBaEHK8SzJZOR71tdVEQQcRdEad6yx5l/bugfegVvM2bfevO4ySnsyhSKhDUfFl5QevGHdYSc8FoUqWbncO49+opdCGEoW3EpyeO5KHw2KiCI3Kk5Xhc9peJnsu0EVls7GUInzlJQ0Rw3DXXPRgxZs+NJ1MzDCZhY7e9TWNDAVzyrdYVKpZP3JWDHWfxR5UzcbK/SW5WWfPmCEDIAWIKgSqGCqk0r/sHLdb8pDBdc+IVvRXDhAaQLEc1s4IR6HFZaGBuxyGcz/s5VuMYqc/M99a2U+K3g4BbwuFU21ScqE/Feb1FhOUU3FT2xSUI8/pNNNx15K6sNBafMiOhJwuj0MKDirSkZ81xiHkYQdc/0CnRxurQtOMIZ6ABVWHyJYgzE577v1HfQxLzTsEjNNn1iMOFb/yJmyZmEy4JcQMq/jEOFQocN9ds94bm4CSIdKvXeKtxpcuDO89Hh1SUjb0Rdql/5W+gcY/ukJe3NaP1GdL8FlMuWUNchJqbu4dWaldwPcCzedVdQ1IX0Axts012gfRFyY9zBSejiKzzyRBWApzgFM3jwFlAWonjdFBPdqh1GN+HXdDjxohCOTJaix0F0pJ+H4TaHzeLieTy1Ayr2vjmZThwSvgYO90PX0oR4yTFrql8tCxVouBbi2im1q/7titBLqQveZ2hhYWFAj45gA3kxSzLkzCMJJV7/fG6t9pA008BSozok92UUH1zFsRowCNpewEzGZvy
 iIvhf54R
 HA4xIP3YJTWCJu5YPhdMGBjpDBQzTR3tDp8+vcaALTZl2n3Pb0jAShwn946zIfhozs7w/ujgoLwyR0a7b0CMdN34c7SZ/S4PXIQcykKHXVwGHflIMKHtZeMDX29/6bsylUac7mA8/wRrUBNdwCNZkmLj5SWZRn9tinNnTtzQAntc9pomPCPPsvLDuMLsGNHolASTlL6At6mvaKfe8yrbS+8sadIhiqnf3T+bdHtYhhxWkhNjtntW7fuvafu/zqFtz2mMu/3/Yl2b2SoSCyOKJBxYgGUx7N1XezFJ0jJjO2zvhy6wLHjpqrgeeMH0yRJLUALHw+2zGhiXdyct86BMPmr0ohXZ2/gCvzTKyE1rciQu3Fw2yZzcCCdjz8bZ7NjUWrNbviLCqcPx9QxMSltRt/Cogrv2HmzWNzMfMqUysvVfyf8/D38p/sbbUpbOPbkr85MmMRmJbV+5xvUlUq/iDE7s0cxyaUpxKBjTa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Binbin Wu <binbin.wu@linux.intel.com> writes:

> On 10/18/2025 4:11 AM, Ackerley Tng wrote:
> [...]
>>
>> +static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 fl=
ags)
>> +{
>> +	struct gmem_inode *gi =3D GMEM_I(inode);
>> +	MA_STATE(mas, &gi->attributes, 0, (size >> PAGE_SHIFT) - 1);
>> +	u64 attrs;
>> +	int r;
>> +
>> +	inode->i_op =3D &kvm_gmem_iops;
>> +	inode->i_mapping->a_ops =3D &kvm_gmem_aops;
>> +	inode->i_mode |=3D S_IFREG;
>> +	inode->i_size =3D size;
>> +	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
>> +	mapping_set_inaccessible(inode->i_mapping);
>> +	/* Unmovable mappings are supposed to be marked unevictable as well. *=
/
> AS_UNMOVABLE has been removed and got merged into AS_INACCESSIBLE, not su=
re if
> it's better to use "Inaccessible" instead of "Unmovable"
>

Thanks, will update comment as follows:

	/*
	 * guest_memfd memory is not migratable or swappable - set
         * inaccessible to gate off both.
	 */
	mapping_set_inaccessible(inode->i_mapping);
	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));

>> +	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>> +
>> +	gi->flags =3D flags;
>> +
>> +	mt_set_external_lock(&gi->attributes,
>> +			     &inode->i_mapping->invalidate_lock);
>> +
>> +	/*
>> +	 * Store default attributes for the entire gmem instance. Ensuring eve=
ry
>> +	 * index is represented in the maple tree at all times simplifies the
>> +	 * conversion and merging logic.
>> +	 */
>> +	attrs =3D gi->flags & GUEST_MEMFD_FLAG_INIT_SHARED ? 0 : KVM_MEMORY_AT=
TRIBUTE_PRIVATE;
>> +
>> +	/*
>> +	 * Acquire the invalidation lock purely to make lockdep happy. There
>> +	 * should be no races at this time since the inode hasn't yet been ful=
ly
>> +	 * created.
>> +	 */
>> +	filemap_invalidate_lock(inode->i_mapping);
>> +	r =3D mas_store_gfp(&mas, xa_mk_value(attrs), GFP_KERNEL);
>> +	filemap_invalidate_unlock(inode->i_mapping);
>> +
>> +	return r;
>> +}
>> +
> [...]
>> @@ -925,13 +986,39 @@ static struct inode *kvm_gmem_alloc_inode(struct s=
uper_block *sb)
>>
>>   	mpol_shared_policy_init(&gi->policy, NULL);
>>
>> +	/*
>> +	 * Memory attributes are protected the filemap invalidation lock, but
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 protected by

Thanks!

>> +	 * the lock structure isn't available at this time.  Immediately mark
>> +	 * maple tree as using external locking so that accessing the tree
>> +	 * before its fully initialized results in NULL pointer dereferences
>> +	 * and not more subtle bugs.
>> +	 */
>> +	mt_init_flags(&gi->attributes, MT_FLAGS_LOCK_EXTERN);
>> +
>>   	gi->flags =3D 0;
>>   	return &gi->vfs_inode;
>>   }
>>
>>   static void kvm_gmem_destroy_inode(struct inode *inode)
>>   {
>> -	mpol_free_shared_policy(&GMEM_I(inode)->policy);
>> +	struct gmem_inode *gi =3D GMEM_I(inode);
>> +
>> +	mpol_free_shared_policy(&gi->policy);
>> +
>> +	/*
>> +	 * Note!  Checking for an empty tree is functionally necessary to avoi=
d
>> +	 * explosions if the tree hasn't been initialized, i.e. if the inode i=
s
>
> It makes sense to skip __mt_destroy() when mtree is empty.
> But what explosions it could trigger if mtree is empty?
> It seems __mt_destroy() can handle the case if the external lock is not s=
et.
>
>

Hope this updated comment clarify the explosion:

	/*
	 * Note!  Checking for an empty tree is functionally necessary
	 * to avoid explosions if the tree hasn't been fully
	 * initialized, i.e. if the inode is being destroyed before
	 * guest_memfd can set the external lock, lockdep would find
	 * that the tree's internal ma_lock was not held.
	 */

>> +	 * being destroyed before guest_memfd can set the external lock.
>> +	 */
>> +	if (!mtree_empty(&gi->attributes)) {
>> +		/*
>> +		 * Acquire the invalidation lock purely to make lockdep happy,
>> +		 * the inode is unreachable at this point.
>> +		 */
>> +		filemap_invalidate_lock(inode->i_mapping);
>> +		__mt_destroy(&gi->attributes);
>> +		filemap_invalidate_unlock(inode->i_mapping);
>> +	}
>>   }
>>
>>   static void kvm_gmem_free_inode(struct inode *inode)
>> --
>> 2.51.0.858.gf9c4a03a3a-goog

