Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43540D26284
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 18:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B6596B048C; Tue, 20 Jan 2026 13:43:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3E76B048E; Tue, 20 Jan 2026 13:43:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD0A6B048F; Tue, 20 Jan 2026 13:43:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F20BC6B048C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:43:00 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A2E1313B921
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:43:00 +0000 (UTC)
X-FDA: 84353214120.21.590D364
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id ECC601C000B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:42:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SjqiEUIQ;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768934579; a=rsa-sha256;
	cv=none;
	b=A07QI5BN3fGGuLDuL+KwShm4scup1HaKx35R1Qp/oayQQR73p4nj6SrzGW0tcPAX7Va7yB
	dUmru5CMIf+hxD5Q+Xfd0o6ut1xGeWzM9TjCBDEsSNdRXOR7MRfkT7ruG4YptWOUEhO+Ky
	HY0J/mXuyVaeZAH6ufAaoLHPk+lHvWQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SjqiEUIQ;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768934579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4X3p1hsMbO1Gjz1e07Um2YapRO5gCA5rv2LgEFafNKo=;
	b=38E99DU2aCw3MWPJafxD+ktQFLXa9pclBg0LAR2PcciiHeiiNN6cAO3A/G+AK3IFT4zueO
	qxCMZItN6jTN4Fs//tb37kJqcbNP3tnIdpZ6MsngkDQCSS92W5q19id08R9R8H8C+ND8yQ
	8SMs0oIwnuRxf+G2+iiId78KC4uY9iI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E98B3435B4;
	Tue, 20 Jan 2026 18:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABADC16AAE;
	Tue, 20 Jan 2026 18:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768934577;
	bh=9asjItjUuW66QRWbqI3QXT7hKg9DauBgryF6+gZ2LNk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SjqiEUIQDfHO6Y7G/RKwZ5STzyAI3pmHlAXYrmpO177JUyGX8ZQ2arH5agwQ1mIQF
	 06Q/WGxNJm5wqvx44LsUPycGl7t9/iaBz6ay83UeQystb/yWY8U5aE4cXTa2HhvIId
	 p4g6qBLQjwFsPg9ld8SgZeCG1wtu8ENI6AGo/S1AMjok8WBwK8v+/JCidE2dfZW40v
	 yiKeRoX1WOHyN6rAKE0zpbSZ6yubd6llKtUZQKTOs5NrqUFsfflDd+ffq/YnzWu5bn
	 +ZGUcPE8CUQKafbu7zRgvs4L01dfbNM7AsTbpwQjfSHIFqzE+m6sm4biqw7EOiKZ/d
	 /qsbKT+M1zyrA==
Date: Tue, 20 Jan 2026 20:42:50 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Jason Miu <jasonmiu@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/6] kho: Relocate vmalloc preservation structure to KHO
 ABI header
Message-ID: <aW_Mqp6HcqLwQImS@kernel.org>
References: <20260105165839.285270-1-rppt@kernel.org>
 <20260105165839.285270-6-rppt@kernel.org>
 <2vxzy0lscks4.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzy0lscks4.fsf@kernel.org>
X-Stat-Signature: h83pb6q6e6ra78nryytxhr8xa7dqhegp
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ECC601C000B
X-Rspam-User: 
X-HE-Tag: 1768934578-15359
X-HE-Meta: U2FsdGVkX19ly5bgcZAPPeW+5V0ttUMR0EnvDANomOZK8iejr8+PixJgAUbY0kmIuZ6tVk2win4zrMu4bMOYPtJHTX9vZdJTA+xpihfPaD2UJ5f3Zwj9uMhm5TIQRK5cDN2pj+K/mF0QNQQrC6gK+PO+GDWgs20WweuF4gKa5Pq8o7CqCXNeEZQasb4MPl+9TfTDok/2mvIvrO4ISUizifoXhdwewbRqFQdrT+h2BMBDBhpAQ7wg4Gz2his2KeAYa5nsAksox9KHM207/H/jSv1SQW7rLdh/buJA5p+GYlQ79EYDXOcRl6/EIdA3O5kKyb32OhBE10VuDyq9PhLC1vHon64HhELYQ0x7pFTzwdmuRlFMnOi67+2N8m5emKShHodAL9Oe+BqLY1PnUbUo7CdR4N43WMSiilLJqoQk9fml9VCfeeuB3k1nUjyvmw6Y3JNWz836JpiOEvOOYp9tM50jTnVCQ0NOH6Uq7Z2kB8CWIwb7ocJUUQf2GvwpHEsK4w2/KiuD0FX1BbboZ7JsCkyaW7+ym46keSX1SG1Tt4qLae5aXe3GxaMHBGniPHC6ZHtTNqTOcDrEdpKjdLigeKP5XHJLvKtx2k+g7TQ6ljkFIHhUJIwNXhGX7aWdvUdjBO7sTpC6DS33ezCYyZAs1Bt5RGFS1r+Bgh8iR2TVpujP0tEH5AOJY30VDufQmcrASi6CvN7r/9yWWr5AI8jMpZm9TGi4DIbRdSP1p7IF6epALDO3OcFcU5DEvDeNR2cv6h6v0q/eHxpCo00kR+ogAwIaZYKluxKmeMSENnJ8E82NwpaITgM7c1pNTM7eVEJD6KhNAbtjmIQU1dTKRNGNQ5k/644bfUJqaOu62eRjoRJ0QcAruXlTdv8qVUBdHjOfyBbhZPz8FvqAxm7LYzmHO+ME/XrAAadW4gn6V0Y06PLNeF5VUDBkK0mGj/TXaD3OSowQTJVKJNPpgOczVO0
 YAbpRIHP
 BD91mqHRE2rszt/eZXU8M11afzYM254qs1cHsfzXoxJ5Zi0L+kAqTCpw4d1VEhc6cLRgM1VegOsv+xt4lr9dGUotJc2iD0tsVC5C0ghY5fCUokovpzk/rX3mpvIYeJE2R3lNbvPKq/PWIpDf3RIxi1hKGSITGhZ6uc1gs2NzGLqe7k+mOJ336amrwq8IS4rZxjNVzHJkUVCZ/viqaXtt0BUsTeGbsu1kDPv3mjDogd0Eij3Rv1wSd1gy5M2rFXAOkayqthTptfSSQkM2UZp6nQyrrFtb27f5arLKw8TgOmxjbzmk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 04:26:51PM +0000, Pratyush Yadav wrote:
> On Mon, Jan 05 2026, Mike Rapoport wrote:
> 
> > From: Jason Miu <jasonmiu@google.com>
> >
> > The `struct kho_vmalloc` defines the in-memory layout for preserving
> > vmalloc regions across kexec. This layout is a contract between kernels
> > and part of the KHO ABI.
> >
> > To reflect this relationship, the related structs and helper macros are
> > relocated to the ABI header, `include/linux/kho/abi/kexec_handover.h`.
> > This move places the structure's definition under the protection of the
> > KHO_FDT_COMPATIBLE version string.
> >
> > The structure and its components are now also documented within the
> > ABI header to describe the contract and prevent ABI breaks.
> >
> > Signed-off-by: Jason Miu <jasonmiu@google.com>
> > Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> [...]
> > +/* Helper macro to define a union for a serializable pointer. */
> > +#define DECLARE_KHOSER_PTR(name, type)	\
> > +	union {                        \
> > +		u64 phys;              \
> > +		type ptr;              \
> > +	} name
> > +
> > +/* Stores the physical address of a serializable pointer. */
> > +#define KHOSER_STORE_PTR(dest, val)               \
> > +	({                                        \
> > +		typeof(val) v = val;              \
> > +		typecheck(typeof((dest).ptr), v); \
> > +		(dest).phys = virt_to_phys(v);    \
> > +	})
> > +
> > +/* Loads the stored physical address back to a pointer. */
> > +#define KHOSER_LOAD_PTR(src)						\
> > +	({                                                                   \
> > +		typeof(src) s = src;                                         \
> > +		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
> > +	})
> 
> Nit: not a fan of exposing code internals to the ABI header. But without
> this the definition of kho_vmalloc_hdr won't make any sense to someone
> reading the doc without looking at the code. Dunno if we can do anything
> better though...

These might be actually useful for other KHO users. 

> > +/*
> > + * This header is embedded at the beginning of each `kho_vmalloc_chunk`
> > + * and contains a pointer to the next chunk in the linked list,
> > + * stored as a physical address for handover.
> > + */
> > +struct kho_vmalloc_hdr {
> > +	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
> > +};
> > +
> > +#define KHO_VMALLOC_SIZE				\
> > +	((PAGE_SIZE - sizeof(struct kho_vmalloc_hdr)) / \
> > +	 sizeof(u64))
> > +
> > +/*
> > + * Each chunk is a single page and is part of a linked list that describes
> > + * a preserved vmalloc area. It contains the header with the link to the next
> > + * chunk and an array of physical addresses of the pages that make up the
> > + * preserved vmalloc area.
> 
> Perhaps also mention that the array is 0-terminated?

Yeah, sure.

@Andrew, can you please add this as a fixup:

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 285eda8a36e4..2201a0d2c159 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -138,8 +138,8 @@ struct kho_vmalloc_hdr {
 /*
  * Each chunk is a single page and is part of a linked list that describes
  * a preserved vmalloc area. It contains the header with the link to the next
- * chunk and an array of physical addresses of the pages that make up the
- * preserved vmalloc area.
+ * chunk and a zero terminated array of physical addresses of the pages that
+ * make up the preserved vmalloc area.
  */
 struct kho_vmalloc_chunk {
 	struct kho_vmalloc_hdr hdr;


> Looks good otherwise.
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

