Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6980D26284
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 18:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 171A66B0495; Tue, 20 Jan 2026 13:56:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11FBC6B0496; Tue, 20 Jan 2026 13:56:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055AA6B0497; Tue, 20 Jan 2026 13:56:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E53C86B0495
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:56:22 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8FC4E1606C7
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:56:22 +0000 (UTC)
X-FDA: 84353247804.02.A6609F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A38B78000B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:56:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a5PDQPI4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768935380; a=rsa-sha256;
	cv=none;
	b=H1SE7l4nXkMUXBc6vAmYr51tJ7fdbSiiZg6XFBxXbJ2fezPJKJclRHIfmU1b82y1HmAxth
	sJcrREBy4afD+wstVtmlVlkSdy597kh7n5Z0SrNCqDn0wnrm3n8lkZQJ57oEmoHxkcnsul
	6GCuprxAVqc+EJeDMMUyjtc9bdP6RIU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a5PDQPI4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768935380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OFnwDkZU7Jyj9BN+wJryS5fMKIElBRiPVeTddDtgh1w=;
	b=ie178AMiXoZxW5PjMYOoua8pUqTz9Eq6weAwS57UT2AAPbcYnBminKdP51f56f1yT+AVWZ
	CNdTnNgpBr8epNjcyq0yMWlgpNS6jM7lajjhM+0oOIivVSPu+56fKNHAUnn86Q1KNRRJK+
	1P5ELGowcOTOh2Bj5Y4spD78Sw6lV3k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BCEE438E3;
	Tue, 20 Jan 2026 18:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A84DC16AAE;
	Tue, 20 Jan 2026 18:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768935379;
	bh=NXgqW8xOX8NnK1Jm5wywr5UqQugivqCTFBrNxOL3X9o=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=a5PDQPI4CaRseh0D+/3F6Ex115b3FY9vj36ryNtZS+MfjEwSdXipBJo3n9LMFULYx
	 JspPLSyiE46U5m4JWjjmsxPwhYXpAqnDX8l83Uqezxi497ThDqickWfFFV7KBUjzg/
	 IGIOcSf6ucIMXtt7ddriGQY2zFdfBJEpKDg36vP/pKaDRG9BYduuKbzeOSkhYjvmIc
	 2ODsi+ype4fBmrSJNDAPiQMbUoDOWXftp5Xjbfw8E2aYNGA8pK+h8A/N+ifPyly8K3
	 DwzprpcHZkOyMly23EdJhxlrGbotqeCVhYiPYpgwioayp/INcxmby38um4ghp+yQlc
	 uKF//m23MJqSA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Alexander Graf <graf@amazon.com>,  Jason Miu
 <jasonmiu@google.com>,  Jonathan Corbet <corbet@lwn.net>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH 5/6] kho: Relocate vmalloc preservation structure to KHO
 ABI header
In-Reply-To: <aW_Mqp6HcqLwQImS@kernel.org> (Mike Rapoport's message of "Tue,
	20 Jan 2026 20:42:50 +0200")
References: <20260105165839.285270-1-rppt@kernel.org>
	<20260105165839.285270-6-rppt@kernel.org> <2vxzy0lscks4.fsf@kernel.org>
	<aW_Mqp6HcqLwQImS@kernel.org>
Date: Tue, 20 Jan 2026 18:56:16 +0000
Message-ID: <2vxz5x8wcdv3.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A38B78000B
X-Stat-Signature: d4uid4o7s9ye7u9cpwg53i46ipoeegoz
X-Rspam-User: 
X-HE-Tag: 1768935380-252497
X-HE-Meta: U2FsdGVkX1/bEXStVtCZdKZWU9YUQVwU6EVRLPJ6tdVNnywWYL3HDIdDy9LI70AX5b6mG5BEALsn4/QRyDsXtEdLHCniOIMG3ZxwkDOEJvH0NUeWliE7UFeXXaLJSmV/aqc2pbiD3E6mFrh40RdWVzHa4e/axEyVWB2knmYDO+O0ZP6rNL/MVZZtLVNJyLZasGkZMMKQSWDVVL3wGZ7J31Ga5lgjbBI8QdXyaLOVmIaRqjXQhm8P5k+Uf+494ydwPDYpaxH1CeUIaoM4ojZxphSmOKS480JcLMVkVmP0m02UR7G30s7Gnl7CLP9nBfax0hv/pQzWHqHq5pB5ZgAFJ/7KaYhONOCPvym4Rli9zmss7E879/lBPdnt66C8h0C2KhB2H39HIPNRp03r4eQFib0l3EqMDssfnpo02ipNkTiwyg0Cx4Y+5creRVbQwA+Gcug9y7+sdhlrxD9cnTC3Dtfb1Akz2lW6h1qs+l5Gv9O3lDDo1cMWFwtoOHqn1LIk0nx68zY82YEFFHHNNl8VESQsfdWhaviBrcECvMGcX6GIdheEODdv8xW/9xEUNh27yV8Qb2GuC+i7a2nOG+LjtFpmgfyNyeZS34ryDQlQnqwUH0DAmDjl+qRRAE4vt58UFDwAq2OAo0r6xQw7lmXNmQmLl5xxE1rDZrPI4Ss3dv2HBmS32EwCU79rzOFdNmZH/ZalX7o2+KQcPQ/e6rrJgcf0LY+nKHYkF2298kWslq/o5PqumTkRn4BFwXgef6Nkbp9E03i8ZdWzqBuU+JBaa/UpPbBQ6CIVJ6+hQV8xw9kgG+wrVlg6PwXR5Popa74DAG5Tw+R0dHGRhXD0r+NQuc1gP2ittHTt8hNaefBN5JpR3GKQrFpA0QvoUIMf42ZpFFucyYfrQFILNFmbV4PUrvnKv2jUqPgvDpU0X6Icjq1yfO7zjRDbCqvyjpwaXir6aY3XjIjjbbA2gLykE9K
 H1K8M1l5
 2sO3OriiEyq3NCyQLmsZnt/SktxNx8nFSnO3C1ZiYIyTgqsZWFbvl/Xyg07Etx9z4mEBLT6KBpfLWivr4YpTbxR/y9hyREQynquYmFMWa9ASjZS5Q7nPhPI1NYqEMm+sR5G8JPyZoSFqR9JViCJFSdGQEM3PfbpTUkWzFF5+wV0ZHtARlSeyIfTbw7mFfO8Yy1omQG9SAgQgIj3G8rs5rTKibVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20 2026, Mike Rapoport wrote:

> On Tue, Jan 20, 2026 at 04:26:51PM +0000, Pratyush Yadav wrote:
>> On Mon, Jan 05 2026, Mike Rapoport wrote:
>> 
>> > From: Jason Miu <jasonmiu@google.com>
>> >
>> > The `struct kho_vmalloc` defines the in-memory layout for preserving
>> > vmalloc regions across kexec. This layout is a contract between kernels
>> > and part of the KHO ABI.
>> >
>> > To reflect this relationship, the related structs and helper macros are
>> > relocated to the ABI header, `include/linux/kho/abi/kexec_handover.h`.
>> > This move places the structure's definition under the protection of the
>> > KHO_FDT_COMPATIBLE version string.
>> >
>> > The structure and its components are now also documented within the
>> > ABI header to describe the contract and prevent ABI breaks.
>> >
>> > Signed-off-by: Jason Miu <jasonmiu@google.com>
>> > Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> [...]
>> > +/* Helper macro to define a union for a serializable pointer. */
>> > +#define DECLARE_KHOSER_PTR(name, type)	\
>> > +	union {                        \
>> > +		u64 phys;              \
>> > +		type ptr;              \
>> > +	} name
>> > +
>> > +/* Stores the physical address of a serializable pointer. */
>> > +#define KHOSER_STORE_PTR(dest, val)               \
>> > +	({                                        \
>> > +		typeof(val) v = val;              \
>> > +		typecheck(typeof((dest).ptr), v); \
>> > +		(dest).phys = virt_to_phys(v);    \
>> > +	})
>> > +
>> > +/* Loads the stored physical address back to a pointer. */
>> > +#define KHOSER_LOAD_PTR(src)						\
>> > +	({                                                                   \
>> > +		typeof(src) s = src;                                         \
>> > +		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
>> > +	})
>> 
>> Nit: not a fan of exposing code internals to the ABI header. But without
>> this the definition of kho_vmalloc_hdr won't make any sense to someone
>> reading the doc without looking at the code. Dunno if we can do anything
>> better though...
>
> These might be actually useful for other KHO users. 

Hmm, okay. Let's keep them here then.

[...]

-- 
Regards,
Pratyush Yadav

