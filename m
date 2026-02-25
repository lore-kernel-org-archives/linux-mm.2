Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92243FD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 17:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66636B00A7; Wed, 25 Feb 2026 12:06:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A147E6B00A9; Wed, 25 Feb 2026 12:06:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91FFB6B00AA; Wed, 25 Feb 2026 12:06:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D1B56B00A7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:06:08 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F0F41606D7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:06:08 +0000 (UTC)
X-FDA: 84483606816.27.8BD2012
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf18.hostedemail.com (Postfix) with ESMTP id 274281C0010
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:06:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FfNuS6nP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3-yufaQgKCCQJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3-yufaQgKCCQJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772039166; a=rsa-sha256;
	cv=none;
	b=wjjgyXlewkRdu93mUG2Kh67E/Zx55M8lUJ1MxTdK7xikIS6i3SbS+/E3KKvIMlcd9QyW4f
	Ws9CxFGaROrCoc6FDaw0Q6Ag0hxfZCgyU3Nfx6dwwNgnj6cyyP7wslDmYaZdvG3Sl7q5Ka
	D29mkaw9t3sTpdQi17s3cha1Aq+n2aY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FfNuS6nP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3-yufaQgKCCQJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3-yufaQgKCCQJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772039166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r/+3U+XCgmmbvjLeHr/Z5ntfc4OUh36dNRN4Xn5wsBg=;
	b=wjKJcuPZwAQrpD57W56wc0PbGqD6QDmpPNhaGuswE1v1LyurkDOrigmfHIuKNcKhy0sP+D
	zC0aaxjaf9u47Ul/sZJ5fhVJQlLKTblpbpI+WjuRI23g7jCJf753uvOSmeZn95TLnujpfJ
	8EMaJe31crE+JwxDaZk8kyNTPrtGz9o=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b8fa5744b82so229694666b.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772039164; x=1772643964; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r/+3U+XCgmmbvjLeHr/Z5ntfc4OUh36dNRN4Xn5wsBg=;
        b=FfNuS6nPgSc4eSxJ1V/XdqTATaLojMyE06IUMTzryOKZq83Scu1inN2nEr3ASmhIba
         3x64KV9Kt/B/5qJS1RvtUQ6foEivu8kkANoRJRORX0lOxyKIjKJq11vsqZS8y+VDADSJ
         ntse6uysfXUzehMU8O8ALQ/FTfDZ61g94NrM5ko8qVoEtt9lQp2sO2MmDgX54STrfITh
         uLwPopyojWLLA16N9Ds7gwg8t1HXaUcNPwgDLX8zPc0qLs9fNwLPaGNT1benc25hmTlL
         lwmVSyaxwW6qOi2/7EGMFKwxWoUmal5xT/oHPg02L8rnotrew5oY8CQLuC0lh3Fmk9e4
         lT7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772039164; x=1772643964;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r/+3U+XCgmmbvjLeHr/Z5ntfc4OUh36dNRN4Xn5wsBg=;
        b=STWS2Fv9vNezvtqAs8Cy8ixAaxJA9jpIQ22b1xO/J8jsj6qpvorJUIsHKzke4U33tG
         z6Fe11buV83txmtgtXW8sY5EWCWt7CpYNKp8NwpQSsb+vPOSCJCt8NZNptI3h15XVbBi
         ua3HpFMSqHTwmlsU/RDXAzbV9X5Ct88sw+2NkEEMP1hhKv4T89GAbRNwPBWFNKTMvt2G
         NdmYM+xHQ+tyDC+ZKnD9xIdVNASinc13lP5bLFeftqm9JbeNmmv1wwltrtLjrDV/gj2M
         /lr0/PL5vQ4XnatUX2FnoB/RliX9RT3SXPd6a0n4bJsEeF8qdWHyR0xk/BAHU1BL6opD
         Uo3g==
X-Forwarded-Encrypted: i=1; AJvYcCVgLc/qpMzByOwCYOPxqNliUatJSGm0fxvKnm54fFG5prZG3b7G2znY1sn19+Y5pp/w0chlj946cA==@kvack.org
X-Gm-Message-State: AOJu0YzkK29hH6rWsGbCrzVU+lsUhmWFpA+oNt8ZfNVLRnB5qAkTxTEe
	fN3SuLoZ8/2WwKffpmoNnnrF1g7ZHY8B5HByRQpbVVoNRuC7witzE7v5PLPG0LiHxw/0SaIapaL
	t98bUsXb8ow44Og==
X-Received: from ejckl15.prod.google.com ([2002:a17:907:994f:b0:b8f:97d4:bb37])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:478e:b0:b7d:1cbb:5deb with SMTP id a640c23a62f3a-b935153c292mr79665166b.27.1772039163861;
 Wed, 25 Feb 2026 09:06:03 -0800 (PST)
Date: Wed, 25 Feb 2026 17:06:02 +0000
In-Reply-To: <aZw5z5Ti-gH3bDUL@kernel.org>
Mime-Version: 1.0
References: <20260219175113.618562-1-jackmanb@google.com> <aZw5z5Ti-gH3bDUL@kernel.org>
X-Mailer: aerc 0.21.0
Message-ID: <DGO7GH6XSF27.2ZHEU51SRDLJA@google.com>
Subject: Re: [LSF/MM/BPF TOPIC] A pagetable library for the kernel?
From: Brendan Jackman <jackmanb@google.com>
To: Mike Rapoport <rppt@kernel.org>, Brendan Jackman <jackmanb@google.com>
Cc: <lsf-pc@lists.linux-foundation.org>, <linux-mm@kvack.org>, 
	<owner-linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 274281C0010
X-Stat-Signature: 88nbrr1edbpdy4s3idhoigjx5b4xhm9r
X-HE-Tag: 1772039165-960554
X-HE-Meta: U2FsdGVkX190fEalN0HCPxacWhNC+7GeGPmqTe/Q8eFnBlpuMDr7g/LMq/FvQsN37Z9SYWnv9d7BuVCYY2UcfQdN9AzX9+orBp3HhXozOBxhovqAjzulf3K0GDpZvCYNKiE2EdNwp5S3k+YJiK0/lQahort8BtlxGJ83FcWzvkvCwjUZviPwaZvr+Y0QKFe0g8q0ucoK66DPC517ZroevLPaCKdgA4/Dn+v3e2GzgWTmzVzar/JfRBLY7jy/cTbDefreXrFec5ZjZL1BF5Da2JaFwdn/IFR2TZZiBoYPyKGLp32tAyPZgLYs2KWV/eSweKNtnowAIQucJm0i0apj/sGYBsuWdwCObY83Uo432C01uwzwLouYbBibb9akzwdm4Kh65TbvEF1d4XeQkhjRWnzA3YkcECD/06JVU80prTgQGJ4f0iIEIoQ2iSQQDtohtPNCK5buEfPZfJIDC3M23SHcKC5oYi0jlJM14jXgfmnsIunumRARFN4PdGvjOOYl3HpESrCf5KPzuqu92GpgK9AFFq48nwARdmq8ZP1MdxIGhq50aSsfYOyghNoMsuAE0QEdtl1CIf64leJHFeLTg9oRnHGWp137j20Z7he0xa4t32nKGtQts6pSbYVznzCeCfP4XyJwQymfC4oRkrYXmCninxSxuBXeuZBCjpmnZTlovU4pQMSQw6pw96IW1/sxNLu++au5BTF01kGrymFCHwJL/5vacdfq9ujqzmNjt45RV7VuKCXVE63s/jHJyK6n4uA7jZVxe7fBK3OZoI56CLqlrF+lsv2YXxr6AT4aupRPXS+pMoMWvRC8Atn+YfcxUS5TaaLezi1Asq6PAU+IiOaPtSsQ0WmKLP2+U68vS/utNlkAZhXmc9B8Oju7AYul401LHaaD9JqPx4DSnJ9eJaRC51i2+FWs/F5TrIyRg4IM10jGmdXFg2Eh1IpCpmwxOl5PmI4VntiB9VY6G9R
 ZVOLhYez
 UkG+33D2vit2QOWYZbZzrWJYgiMKF7RcuxJfwYyG9THrbTOnTipm0Q6koz3pTQk1uugA6ktAdlwKwXra88/+pgPzxSXV7YSoty94N+5mN16MyNcyuS3rCIaXPQWlNmrOKAxhoscg9nhIFmrd//3azRllMGGrhrTwgr3AtCtZogsrFo0MBHAlWC0dtAY48ddnOlcE0X5fAzLSoKHAphAhW/cShcwXDF0eK4/vhhAiBRkKkin1MKNyjC/+/uXOdK3RBv8azFDJB3ZwioTkG5qIduDaLAfHE/XHj3hbr/7X/5OUglt2HDpSPe3i2KC0FC+ZOmz2zgGoeMf693b+uO4Tf+wf4c4iWqNU7ZnNAMzUa/uFYXkXgQclNbQrliNnNGDOq3gz3oKeyJaKJUOJWfdiXn3n96BIr7PSKZkB+YOGmOX46GckPLx29AjfuEQey68Bx3lC33bWR/7Tck8XrKeoZfSpm9Ovj/EXPy27EQf0h/tTZpGv5jO5H2LPTkWsIfWdaC3sbsMVeBUldzS0UoOBuB0V/tq/TTFeuOG/w+6ZU9eFsXdJ9dAbmZKuxI0QjcEuIq/tmPVhVnYJXuNAjdupNR5cM/xrQXjnT0+iM2zGc+xn2l5y7fyjIyLEPErDMzTUrqN0+C302pm32Xl4nf+TejK2P/kvWChZyIEDbopz9uac86j4PphqhHjOwFWkWoNLCGfhetQqZxm9c5WsuE9K27/0mDv6Oi7d2WLyVEaOqVZSy9z0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Feb 23, 2026 at 11:28 AM UTC, Mike Rapoport wrote:
> On Thu, Feb 19, 2026 at 05:51:09PM +0000, Brendan Jackman wrote:
>> As work on Address Space Isolation [0] trudges slowly along (next series=
 coming
>> soon=E2=84=A2... I promise... some details of the plan are in [0]) I've =
been running
>> into a common issue whenever I try to do new stuff with the kernel addre=
ss
>> space: We have too many sets of pagetable manipulation routines, and yet=
 we
>> don't have one that suits ASI's needs.
>>=20
>> Similarly, I'm currently working on support for efficiently unmapping
>> guest_memfd pages from the physmap (an extension to [1]) - in this case =
I've run
>> into very much the same issues as with ASI.
>>=20
>> Here are some areas of the kernel that manipulate pagetables:
>>=20
>> 1. The collection of APIs that are specific to userspace pagetables: mmu=
_gather,
>>    mm/pagewalk.c, some vm_fault logic, all that good stuff.
>>=20
>> 2. The set_memory_* and set_direct_map_* APIs. (Which are implemented pe=
r-arch).
>>=20
>> 3. Some non-userspace-specific APIs in mm/memory.c, such as
>>    apply_to_page_range().
>>=20
>> 4. mm/vmalloc.c
>>=20
>> 5. Highmem logic such as kmap_local_*
>>=20
>> 6. Boot and memory-hotplug support code (your architecture's version of
>>    arch/x86/mm/init_64.c).
>>=20
>> 7. x86's KPTI
>>=20
>> 8. x86's LDT logic
>>=20
>> (At LPC I started enumerating these off the top of my head and multiple =
people
>> spoke out with more examples I hadn't thought of - please join in if you=
 can see
>> more!)
>>=20
>> By and large, these components are designed completely independently fro=
m one
>> another. This is made possible by the smart design of the low-level help=
er API
>> (pte_present() and friends), and it does lead to nice explicit coding st=
yle.
>
> By and large, lots of functionality that deals with kernel page tables wa=
s
> added ad-hoc, like e.g. adopting set_memory() designed for DEBUG_PAGE_ALL=
OC
> for protecting kernel and modules code.

That makes sense.=20

I've also just posted an RFC that does more awkward ad-hoc manipulation:=20

https://lore.kernel.org/all/20260225-page_alloc-unmapped-v1-4-e8808a03cd66@=
google.com/

This might help illustrate the kinda thing that we could benefit from
with a more general library, besides just deduplicating code.


