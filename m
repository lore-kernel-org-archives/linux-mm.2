Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A9A6C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 15:55:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 602B86B02A5; Thu, 13 Aug 2026 11:55:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D9896B02A6; Thu, 13 Aug 2026 11:55:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C87F6B02A9; Thu, 13 Aug 2026 11:55:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1166E6B02A5
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:55:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 882C4801D0
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:55:18 +0000 (UTC)
X-FDA: 85096695516.25.3473278
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf13.hostedemail.com (Postfix) with ESMTP id A2B5520008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:55:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="as6eTx1/";
	spf=pass (imf13.hostedemail.com: domain of 34uh9agYKCAczlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=34uh9agYKCAczlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786636516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NWd+efJbNRhMQi4tFuFF6oho5IzekPVE1UiVHSpD6zk=;
	b=M/sOsQZ58BAHu2BvrHGynk8HV9EbBg0mIYazGgorRgkT0fCBwRYqRuR4I1/7joWizmJ9Rd
	aGxTjaP+D5oD9bWu3JIoEXss0UmVpZ1drHhr9tKXLF8UDQEpOfa6v+d6x3vPhLteS05J6A
	JfvhN6l7fjGKfFVwZ6TGNC+bk3fuTDE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786636516;
	b=7E4RzVXQkZD3pQ1rrjh/XBOoND1p0MJqSVsBe+OVxKjyyrMWSyVb+80PYZM192oaEWIP/y
	kBXEi74inceliRk8F5ki75HAWXK/OH3D5U3Tzce8ZudEbPKREwGYmyfYmPCTFrYjuAeWWN
	glkltj8eziCyHi9EtG+OzWFbV9RoScQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="as6eTx1/";
	spf=pass (imf13.hostedemail.com: domain of 34uh9agYKCAczlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=34uh9agYKCAczlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-388b404eaa4so1229032a91.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786636515; x=1787241315; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NWd+efJbNRhMQi4tFuFF6oho5IzekPVE1UiVHSpD6zk=;
        b=as6eTx1/1/kD4cV+kI+hSHP13l80fSAftdnJ/ELbTzXyeHTnuRyQLhn7sOKSpgz7j6
         2h83b/SQq5ul/kmjRSqMcoLkahWa/CYk5Ce+ZXMOiJIAEwRaRaqtMR3E6ITZJYWmiV0e
         5DRBV+oddA4WKabpmiAilDJkQQ4PTipj871FzTApHEr4k+Jyvrw7qzV8m5mnlh6vn0oe
         C0wp1AyEtcgP/gNfUhipx9xmuUtioCp7idZHhOV7Yd2WEUSwOxb9eMSxvASP7dnooFVz
         U12qL2x8jCE4denu4yTl2EUrSjziHhk4gyBfsAKmQoWesZ8dHrhJgdYBElLhROn59E3x
         hQbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786636515; x=1787241315;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NWd+efJbNRhMQi4tFuFF6oho5IzekPVE1UiVHSpD6zk=;
        b=Mv1ame3DYPsjVCmZDkqE8lZZCrhcagBiTjDIoUUcFTGZh/ohYRUgCajB3IkODsMLoI
         Dvs1MXBN5rlJmebE6joouvIvnrEwrVOycfuXXF2+GzuNO5DfIkVuRsEWkP4nVHVzCtJI
         p//kRWMdiLGX/IsCWn4qkZmV4sWiQa6wCEexszBzv65QHfV+n8VKmodL/wovtmCTm2oh
         wpJwtzllzN8RsIRy8sa6xgyly/gtgInbH65Ee4cO9exKS+/rw5Xp/Bpb25KOOtzP9fHx
         T2ntPXKD5ntSksWtcRE3dL2bK283YxOCQgInubKmkqDk6dSn8gcRRRXt/DFk7d1tbOqc
         EYTA==
X-Forwarded-Encrypted: i=1; AHgh+RpO708PSkW11Z1vF2qCqsibR85DFMR+Fyo6KUFY8TgVeNblTqz7wug2wPd/f37/+HYUggIr/ic98g==@kvack.org
X-Gm-Message-State: AOJu0YxNmUomgQHOuO9pR4rCO9WIe6RDUUHB7zBOqG3QfjWR87NW8Qs+
	qGpJRW76vdJ9+qaVAdOS1aO2pfglTIxEVNjQaS75FfnTZAK2fBrKq7L9G/G8ICVVGLHtD6W65IX
	2kWaKuQ==
X-Received: from pjbmr22.prod.google.com ([2002:a17:90b:2396:b0:381:1d7f:b8db])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a8d:b0:36a:8240:2477
 with SMTP id 98e67ed59e1d1-3931e31a6f4mr7349226a91.19.1786636514937; Thu, 13
 Aug 2026 08:55:14 -0700 (PDT)
Date: Thu, 13 Aug 2026 08:55:14 -0700
In-Reply-To: <1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-12-2fc18ee6d3ba@google.com> <1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com>
Message-ID: <an3o4h-E8mj6CUaM@google.com>
Subject: Re: [PATCH v10 12/41] KVM: guest_memfd: Call arch make_shared
 callback for to-shared conversion
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: mmm4fg6gzcbu7kq1y6ufa66wz7xd7k59
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A2B5520008
X-HE-Tag: 1786636516-558875
X-HE-Meta: U2FsdGVkX18+uwiatTMU6qeqA1PBcelGxEGx2ZgNsQyzCYBMh1UJ8XJGYpCR1wvbUTTDvPJPhR9Q1q5iRX8nKOMozAtk3KvNbHu9OVKxgc1cxpKN/4/93iwophIkUnxLAgpayFjBZRT+QgwhWStPagPYbJGjQolJqyHB0qxk5d/XCxeeasFkAJipsaiaYW9aVEpyUJrQobrpKydExaj8cUvvfkacYE7Ul6SxZX0zjFNr9BDC1NUyRtid6UuonZ2/xO8/jfoAXZCQDrpdSzJGmsaPNaGEHYCRu/XU8LjKtlOsUCpZsBcv44CoTt4n6zSb6lBi4M14z2fb35krTToT7/29cRk2Pmz0kzGY7Qn77fe3CryI2r01/DyYPtn33ijy4QIe59AMbImjqA7ASN82qa6JdeNBOY3X4J8o9fvl8bDcHeXvrT5jjpTfpo1y5WSWtfrWBPgC2KKNfh2s84HMe/IZwHP9lXKzipy3tlIQFQ+M7wcs/ob6AYjOeP2XpVkwmLNnx/FriU3QGXYJZWD7SuGtH3Q+ytvrzK81KR7/YcZIz599Wa7mwxtSmkGROJgqS99KblskmwY7+PhFatwWVpAzFqHeAyIbzqXEjDrF07FPO4UXiKR7l51JVyLdQc7z+r/6EvNAmulnopH6x3zokz0TQuo5FaoKUfO+tU/NbIGeaj50I2CpTR2g6g8lGSN9crhY/HgnmcmKilwfqijsXPyE/z6M2qLIDy5cEGelZCGKdb8l846Mriv1NFpLpEoVpI5avEOlYTT2PC1B70DIUeYoyebcFPTUqWEZB0KSAmdKPYFy0okaCwkJ6JEfJa/dfJQUli4/QG082EvRriXHIphvMEgy5TZ6l74IqBVs9qkH0XY5LTXI+eNKrbikvgX3cVBLS3miZ99jm/XlowU7y6z0WHYXIthTkEjQ57/Mbl4u3d1TsxhkC33MHN1L9jdy+rl6ZQbyfkZVqCtInqb
 SLU9pOk/
 NNyU+TvKqDylITy+8fhqVYFpya1yI+0VYRZEHBP5AucfBuz8ZeGeMFOYr82Z0NOFiiOwsteX5P1ZFSbGhplEriLMhk6Xbwd1gIWBG7r0jdOxva3Qn5kUHEVqQ9aM3h3+BRmfOd1bYr8r1XakKUhapFP76PvR5dDNHIqGj3BBPFquJw5n0ugQMC0ligX5Oj8UJFXl6LBLft2j6BgQdW4Gq9X1IuZtkPdWS/TGrt6uWi12nq4dCUWJNz/QgUV06j7iIJldcHyNfgEHhQ/wVITpm2D/Ny3xFPazrqboZuWx8yIdLN1TSHsn9auXKPxggjXlXTMpx4jddHpodbLdoLDd7Kxmqx5HOoVP0HUyhRpGf5Buo9pGczcFSiEEJ5yyNb0yYfiuHIsOqh3ImBIPpsB2o6oMmHfiCR+/NFvTd/f3HiAcHHSNQXosiYX9gSVjOVhyQEGplnmMkU2belw6c4IuGuoOfHHQVDu12sUih8+VfFhNDISc5MiHa+EnZSiFE5lPKQYHDGbr274av9mU/JdlF6ur07LoS9Su/bzxThTelNQezd19iw0l2yGSf8cJCIHwWwOdiP5flZ9HhzYERIQqT+rg4DtkZhjgr9fRCB3hwg1goyIfDd8yOXeqPEgNXfBZtpaRxTstUe4pC+ZJ5uow4z8OxDMmi8uoRrQouVL0bQlpj7/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026, Binbin Wu wrote:
> On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> > +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
> > +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, p=
goff_t end)
> > +{
> > +	struct folio_batch fbatch;
> > +	pgoff_t next =3D start;
> > +	int i;
> > +
> > +	folio_batch_init(&fbatch);
> > +	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch))=
 {
> > +		for (i =3D 0; i < folio_batch_count(&fbatch); ++i) {
> > +			struct folio *folio =3D fbatch.folios[i];
> > +			pgoff_t start_index, end_index;
> > +			kvm_pfn_t start_pfn;
> > +			kvm_pfn_t nr_pages;
> > +
> > +			start_index =3D max(start, folio->index);
> > +			end_index =3D min(end, folio_next_index(folio));
> > +			/*
> > +			 * end_index is either in folio or points to
> > +			 * the first page of the next folio. Hence,
> > +			 * all pages in range [start_index, end_index)
> > +			 * are contiguous.
> > +			 */
> > +			start_pfn =3D folio_file_pfn(folio, start_index);
> > +			nr_pages =3D end_index - start_index;
> > +
> > +			kvm_arch_gmem_make_shared(start_pfn, nr_pages);
> > +		}
> > +
> > +		folio_batch_release(&fbatch);
> > +		cond_resched();
> > +	}
> > +}
> > +#else
> > +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, p=
goff_t end) {}
> > +#endif
> > +
> >  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t star=
t,
> >  				     size_t nr_pages, uint64_t attrs,
> >  				     pgoff_t *err_index)
> > @@ -599,7 +636,12 @@ static int __kvm_gmem_set_attributes(struct inode =
*inode, pgoff_t start,
> > =20
> >  	filter =3D to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
> >  	kvm_gmem_invalidate_start(inode, start, end, filter);
> > +
> > +	if (!to_private)
> > +		kvm_gmem_make_shared(inode, start, end);
>=20
> If both KVM_AMD_SEV and KVM_INTEL_TDX are enabled, HAVE_KVM_ARCH_GMEM_CON=
VERT
> will be enabled and the logic in kvm_gmem_make_shared() introduces unnece=
ssary
> overhead for TDX.
> Not sure about CSPs, but in a standard distribution kernel, it's very lik=
ely
> that both are enabled, right=EF=BC=9F

Yep.

> Should kvm_gmem_make_shared() do some optimization or the overhead is rel=
ative
> small in the conversion to shared path so that the optimization is not wo=
rth it?

I assume it's relatively small, but it's probably a good idea to gets numbe=
rs so
that we can make a semi-informed decision.  E.g. if processing 1GiB work of=
 4KiB
folios is <100 cycles, I think we generally don't care.  But if it's more l=
ike
tens of microseconds, then I think we do care enough to optimize the walkin=
g for
TDX.

