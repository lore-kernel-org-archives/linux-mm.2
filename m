Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 500C8E91297
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 14:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852D26B0089; Thu,  5 Feb 2026 09:31:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844606B008A; Thu,  5 Feb 2026 09:31:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 767AF6B0092; Thu,  5 Feb 2026 09:31:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66E856B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:31:55 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA05359592
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 14:31:54 +0000 (UTC)
X-FDA: 84410642148.20.998B3A1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2DBB3A0009
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 14:31:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770301913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fJlqPGsXf0b6vIU1M2K8abKxS0u2azgZ2Z3SVu6tYY4=;
	b=RfBOSqrjpjkDi2U71aKwG8xu8HpoLo8IIlUXkRfJPz7gQ382ZNJa7GvCNFtqQXh8KnJ5WF
	TTikOwBicJbnQBwVExA+5uRxgEU62bufu+8ESoTJ9JI6Xx6U+jQ4jsN/N5tXk80U5176/4
	I6a6Ia3enLuJAUMbz//r7WtYHYCILuY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770301913; a=rsa-sha256;
	cv=none;
	b=MpHTPaEv4B0Xvr0AUHSnbFgAZXFjIk83kVE64a89Bl0FAPNH8yWRsWEuYF4+xawwodAKEn
	b+12PUAW03HQq6IaIw4/IN44gsQNZ8S0zsfU+THGtMkrpmNc9jlAiOvFn0y8o9gRyyseEL
	1RNxO0Nh0S+7c9JZGC2tVhLRYOielNo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8E54339;
	Thu,  5 Feb 2026 06:31:45 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 460083F73F;
	Thu,  5 Feb 2026 06:31:50 -0800 (PST)
Date: Thu, 5 Feb 2026 14:31:47 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Will Deacon <will@kernel.org>, akpm@linux-foundation.org,
	david@kernel.org, zengheng4@huawei.com, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, wangkefeng.wang@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] arm64: mm: fix pass user prot to ioremap_prot in
 generic_access_phys
Message-ID: <aYSp0--x_QgyiUWL@arm.com>
References: <20260130073807.99474-1-tujinjiang@huawei.com>
 <aYC6_lSm_eJeKIcn@willie-the-truck>
 <73396cda-e12c-484f-ab84-b09e7aab8bb0@huawei.com>
 <aYG-dGzR6MuPSQBK@willie-the-truck>
 <a4ee7faa-5b0d-4ffa-bc06-939d95ef7680@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4ee7faa-5b0d-4ffa-bc06-939d95ef7680@huawei.com>
X-Rspamd-Queue-Id: 2DBB3A0009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: fjhbdq9qbtaw45c4s6583dxg6itoq7ck
X-HE-Tag: 1770301912-793135
X-HE-Meta: U2FsdGVkX18p/gpB+JbCdv+1EG2SwGwtdAbt/3SK17wyyeCWWJ/eUHCQL5BkndZnH0OrVsDhO1scBUDkVtUye8CiGxtGh5W8OZvbryERTyPzgxYfx2hRtu62f2QeFRBfKhSkbMPNg1NTwvOtyIjrPPpMcecCFnXQNFdfomrZGzbtl4s5dciZNGEqA5ecdz6S4Kscs8gcD4I5wiznsyU195CpDb8AuBgMgj/0IbGPwlIb75m8145zEs4kuQhvFKiDyvPxZrYiz4INS2aflsReiDSEW3KPkGK46waP29gyVG8A/XbyV5xppCtOM0No1MEiMd3dVR35NpqzsuyJqR5Mb5neQbOjEPjwI2/SvHUbiVh5VM1Su3pB2KOnE/MgOajtskIOrBsaEFJWqx7asGGA2thAyc2L8wgoaAKKkjMkgQGdk6AYsG5O8jw+Oxi8M3O6PAotijSjbwqVuPL5bB1YztO9+X4y+ZYpHYiwL5Abqqk0CK7F1qbx2lG1yJFeYZ4QgeW4ZP5kcav+OwyhH3NPvplCop0Z8dHVMkel2FvYAGvPtI6PbqdL/zINVfXnfD5aDOLTtxfWFtMfMrCc6D9MGxLZvLJYOpJ1Lrj7dH5FaMFNDDfmhp9HDp+DNRWxZ5vPTOHEKnsk4wbvqCQZKQfzdBrwJg4bie9DfcXSADCCNqOznpR9pbgxb5beMqKKIRw1Yw+cu3/PfJDHtshDhnoi4hSp0x7V4SSXc4k5L4rC9OdUNGDsNf4SuEKoxBR0qt0h3bcTbGclN6WDMGLo+qqK0SPN2qIW0Odeh9XUn9Mmmqm/h9+u9OOnJ4Yopf59af7FSnIIeRQUC3hdzOGfKEkFppmufQV7mmigBp+kFEeZZxhP1QgtvISnzzv6WX0At7/FQmoRaBV0mW6Ecc6RWVmEDhNQpU2aA2BwbvvnIyKx5qQqzV6Mh75EASLtago2U7CpzOrZggHYnuMHKu5TGH2
 9DVZcI3Q
 yjPlTF2ZralUdIVJ2TOKDZHboTWndNQbdZsPzxxAi8ZWBahC5wCZgrBvEBIo9pxnhxU3OS75TtCGtoGatPQcvtST7gFSGJnDuHyxRfCCB3Vs6LwzpunG7SPTuPZJ19e3DCqvtySRFi+H9lbXyLaW8rILqFaNnXkSmtOUgylp4eNvzWfa+euvfACO2M5hL3TQRuowPotQWzxSUe7CsIxorpCjJlw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 03:23:27PM +0800, Jinjiang Tu wrote:
> 在 2026/2/3 17:23, Will Deacon 写道:
> > On Tue, Feb 03, 2026 at 11:38:15AM +0800, Jinjiang Tu wrote:
> > > 在 2026/2/2 22:55, Will Deacon 写道:
> > > > On Fri, Jan 30, 2026 at 03:38:07PM +0800, Jinjiang Tu wrote:
> > > > > +#define arch_mk_kernel_prot arch_mk_kernel_prot
> > > > > +static inline pgprot_t arch_mk_kernel_prot(pgprot_t user_prot)
> > > > > +{
> > > > > +	ptdesc_t mem_type = pgprot_val(user_prot) & PTE_ATTRINDX_MASK;
> > > > > +
> > > > > +	return __pgprot_modify(PAGE_KERNEL, PTE_ATTRINDX_MASK, mem_type);
> > > > > +}
> > > > 
> > > > Do we really need another arch helper here?
[...]
> > My point is that we already have the helper: ioremap_prot(). Just fix
> > that for arm64 and cc the other arch maintainers if you're not sure how
> > to fix it for them. What we don't need to do is add an additional helper.
> 
> ioremap_prot() may be called outside of arch/arm64 in the future, and I think
> most of the cases will not pass a user prot to ioremap_prot().
> 
> generic_access_phys() is a special case, so I want to limit the modification to
> generic_access_phys() only.

Or we can just have an ioremap_user_prot() (or some more meaningful
name), defined by default as ioremap_prot(). It's still introducing a
new macro though, unless we go and rename it on all architectures.

-- 
Catalin

