Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7846ECD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF32B6B0092; Fri, 29 May 2026 10:48:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACAAA6B0093; Fri, 29 May 2026 10:48:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E0B16B0095; Fri, 29 May 2026 10:48:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9636B0092
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:48:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38B0DA01A3
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:48:20 +0000 (UTC)
X-FDA: 84820737960.03.A503EDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 130BA1C000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:48:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="B/D6PTyn";
	spf=pass (imf20.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rDYAlmQq2lyT0mKI/5jPVDdXiqH331Ok6KPFJGIkolA=;
	b=LhWLzf/c+zIVwoBSrvLD72RepBiwjR5UtPCbAtcsScDxzuLxnkRNMNt1d3lV4qky3pBwEy
	BkisbT8LXQ1Kjhyxb90JuZpKF8o1G0rSQfiQofNlWZHzekRAvTI3wRvD4+iGS9a0BElR5l
	1lyvUlir9e0vAwP1910TOj3BBNNBmKk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="B/D6PTyn";
	spf=pass (imf20.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066098; a=rsa-sha256;
	cv=none;
	b=epZ3Pvf0qsCWlL9LMBzJLdRwN9Rj7WFClOywq2MI1jM1QQAHD1J1EwfEpE5qHseChuv+Pn
	LvTlGYnsybiBZ2Is8tK0/s3f4ezEPqqYHJQYRQAl+sWokEgFl9kGCESgaXI068Vsrae/3H
	yuSFuYeGtjx3WsN18Vpbe5nkeZ/jeoM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0006A43965;
	Fri, 29 May 2026 14:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C111F00898;
	Fri, 29 May 2026 14:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780066096;
	bh=rDYAlmQq2lyT0mKI/5jPVDdXiqH331Ok6KPFJGIkolA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=B/D6PTynJnQoiv5UGY84Nxeys2XekviBCPy1tBM1oZoNcAiD64YXYcPbgM6mQ8r6j
	 Ju1Yszpm1IU+sDUTCsAHUupVz3c6LFjjSOxh6ZgC+NNKAcUYs7+WXyb6WLpp38882V
	 h2KchIcNii6iBq1jm/M4xT08IolsroFxcQsYL7a/wkIBzBe1a7g9hGS9ZqQj7KYG1N
	 gQICg8IZifWWVQJXVlRM4Zpy+QJTLsQSROGx1qugSXXGuszEK6z9AyhrrYMyAcRPUP
	 m6Q9q7gzhRbAGekyaQeeeXxToVJmDdYGA95NTpiDs/C+zVHTNTz9OvRjzaO6OL4R9a
	 qDAyOY9RfsG7A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9B26AF4006B;
	Fri, 29 May 2026 10:48:15 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Fri, 29 May 2026 10:48:15 -0400
X-ME-Sender: <xms:L6cZalvqhsB-aHhaRkze_h7UY2ABhSZeFnZ60Q3_IKMDCODR4iuKzA>
    <xme:L6cZapRecgER7059-g_h5SmbR74_rDZdbLKHp8wKImrL7GCvJSuQ-czyG9PRHVNgX
    LodoT-OBe61zEkLfQ414HQKZYu3vF8l4Y7Vj5axhKW3qvVV9XuVlw0>
X-ME-Proxy-Cause: dmFkZTGt+msDe027/QMow7WM2h4XBrXubrUHHx9XVuKXNuewjeECntXEkvpZpwjkpuwWEv
    A+IG7AeFN5owfWzwbPO9CjcB7TRAAsY44WxF7zXFXy6LoVGUAKFH2Bx1eeqBPzIerpvVjv
    ELx4NQx0XG6whtq/UTw90jigQlW4j18Zh0Zt1+paIGSTOJ9ku9oHpPkPFvh0lxBxqNkgBT
    FnRPsw9ol+7BaTbq+VC3GgNlb/hfOhjgLaPfDPKB8smIObxRKijH1R3rHFi8eHD+NkkdLJ
    A7LUeOTltjqUyU3MM5Wv53HhVF64Qimbf03q9/pBfm6OGXhfkEoLOeymapiGYXWuW7kwNp
    ckYNzIG87pXFDqxBpRSEjOxQSObcP/T++yyH1GkG3YItNvgZi8BW7YZJf0oLK1Eiu9ctpj
    e/Qrzm63c6EjvCPOKuUOldqVtQ9ZHP5SjAUyNeaZsq8FP10znmcrDkJjKhmkqvgalMjmqj
    5yI6GJ6yQK3gJ/0sFlH1xfNMM7hLe/tXPVaeY8cRX+7fv6nhbeMCau2aQ4gfKKOCQInygr
    DX9MXYrq5o/uY7i19kTROhADx/RRu9bkIc+kVBeOktIvcQ1AMx9acT0YqOTPMhDzC2jr7R
    qbv5MzK1kh98MwYu6S2aUc5FDL3Tal9kQVrQ86RuzLjlmuBz9HkOhgZjLFug
X-ME-Proxy: <xmx:L6cZanX74O-bar_jLvxjWKCnp-Ih7O5QrV09suBOhbCd2rIrR9xQeA>
    <xmx:L6cZamrF7UpYic3Pul9sEvDf0nlILb6aAYq-n3JKJgUil7UpBZORtQ>
    <xmx:L6cZarFrHHphMz_k0i3sOdMq0fdtjxTfs29QHz9bIdolxCo5oEEGVA>
    <xmx:L6cZaouUFRbFWAprH-4qWiANOmu1DUXbhNuFie1nlzyqPUFP98ZCWQ>
    <xmx:L6cZauQug8MFn_HvWRIXz9IpPD4mlQQP6iSw5xCI5jVhcTfQZiXZW5o_>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 780D8182007A; Fri, 29 May 2026 10:48:15 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Fri, 29 May 2026 16:47:54 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Kevin Brodsky" <kevin.brodsky@arm.com>,
 "Ard Biesheuvel" <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, "Will Deacon" <will@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Rutland" <mark.rutland@arm.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Liz Prucka" <lizprucka@google.com>, "Seth Jenkins" <sethjenkins@google.com>,
 "Kees Cook" <kees@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "David Hildenbrand" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Jann Horn" <jannh@google.com>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org
Message-Id: <feab72b8-2961-4145-ac5c-80e820bf1ce9@app.fastmail.com>
In-Reply-To: <b76b327f-612e-494f-b8d3-44108aa73d2a@arm.com>
References: <20260526175846.2694125-17-ardb+git@google.com>
 <20260526175846.2694125-26-ardb+git@google.com>
 <2a6f9f05-ac57-4ef8-9328-74cc8ccfea16@arm.com>
 <96a8b6b9-71f2-4550-bbbb-fbfa146f4e6a@app.fastmail.com>
 <b76b327f-612e-494f-b8d3-44108aa73d2a@arm.com>
Subject: Re: [PATCH v6 09/15] arm64: Move fixmap and kasan page tables to end of kernel
 image
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 130BA1C000B
X-Stat-Signature: tog1ueikxdrsw591ndyuo5wfsti53r93
X-HE-Tag: 1780066097-664498
X-HE-Meta: U2FsdGVkX1+iDtmKMMh1f4hzdJgaSkRDK4R6JIMldzs7yqSjEl0cEpR79abSETrpr0o9ML0tMW80L+wMUSnXCC5z/sC5Z+GqWSX6GZ4ZjAr9D4bblun6l3VudYG/A4+srZrZ3+SnOvJH5McPoZohlvrHso7snt8F8h3NSeSDSaBjcQ0dLCnlJFPM8/f798CAuRBrCWguliT2/N9pqH2QXtlsUpPR6C5DupvxmRy2PYSiOMdkOEUkE9Mog93Ntid1pFfRHvcE4yut0kyVkQ3TBRpcEq3AjSoTsqNkDbPfdYB4Nmj/xM8oOy8XVcm2kmfZ4mu1UzUnPU+SYPA2zYrkPFPQWftIsEfCnTnHx5yQP/BB/RF1yH9MulcZpFWgbnIJNaUssMHFGrY8qdHVtFyWAR7N5merAODoqz4zG2D5hNwC4WNkIYx620kyNpD8JYPCealLwHKufOYqZmpJNPIEQq02/M+4FLI2akKLN18vXa83lHd0f+4vKia1PwJu8IXhbD2F/4F9k8dxKeLBmEn4kciWcuJQJ2ySnm66n0UFL9wWB/7TjtpFA3vItbq8NCgLgD4tmny7YKYsDIi9elHPsaClon0hiMPBJIH4JSx3x1JUpHF41oWINOzqeldOmlNNpVhXVP16KVGc3g76hp2gmQgRqbkmyxofH+ouK7n8Z126xJYcvLH0iYiXTTr3xPVlo3JR6oJ1QIOmupGpdnWrftzkZXAXHVRhPqU56vYN6l6MQm/stdyUDsAq3x95nSOeCryorQOLYP/WhdiVftKDovdKcEFEBvkmRHLXFd6HvomEw6S7orh5ydHvWD3lelgJO6QBCHWC0rcvlksxVkxhRlyPO6m8nlVNU2eVY2+x4dRLZzPqXIB38AZnIwATrcYNRRcXzVW4gtDiHbg2mQi4AcpcWtfIXbEwjIgL7b+G4eS23XEvjmHtmtUMOk2vml3TArmda61WhZGXf6QJdpe
 sBfwqiER
 n5VWnaxDRW+OnwGe1lPeFTuiyQ5jN5JUTKs4OicatGIdPoB3EGjg/F5jLqX4OVT643AhKpd6OSMp3lfx4CAxnSL3E0PQGkb0o5Jq/LD7Fer727ZaGOUyK2gaUITzu6qEFZ+JKINVUrvESgKhJ29MVn1ZvIDt1AYlDsVH5RetjWrX0h5HHPXgShkg5/rkUhefdnMuA+fvwS1FVjyWEZ9YNzLpz4unswz60OzuXkBQe50GF5hX8O1q+zKMIFhoEbGea6YckXY/S4JYnGbXkcX2r3K0jnWgug1KMx0pa5SDiR7JPtHVqoFQJHDRXZQtzIafF4GSKsEeKteBGIRcjWCKpb1wL5TWG47MzzX6m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 May 2026, at 16:42, Kevin Brodsky wrote:
> On 29/05/2026 13:19, Ard Biesheuvel wrote:
>> On Fri, 29 May 2026, at 10:27, Kevin Brodsky wrote:
>>> On 26/05/2026 19:58, Ard Biesheuvel wrote:
>>>> From: Ard Biesheuvel <ardb@kernel.org>
>>>>
>>>> Move the fixmap and kasan page tables out of the BSS section, and place
>>>> them at the end of the image, right before the init_pg_dir section where
>>>> some of the other statically allocated page tables live.
>>>>
>>>> These page tables are currently the only data objects in vmlinux that
>>>> are meant to be accessed via the kernel image's linear alias, and so
>>>> placing them together allows the remainder of the data/bss section to be
>>>> remapped read-only or unmapped entirely.
>>>>
>>>> Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>>>> ---
>>>>  arch/arm64/include/asm/mmu.h    | 2 ++
>>>>  arch/arm64/kernel/vmlinux.lds.S | 8 +++++++-
>>>>  arch/arm64/mm/fixmap.c          | 6 +++---
>>>>  arch/arm64/mm/kasan_init.c      | 2 +-
>>>>  4 files changed, 13 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
>>>> index 5e1211c540ab..fb95754f2876 100644
>>>> --- a/arch/arm64/include/asm/mmu.h
>>>> +++ b/arch/arm64/include/asm/mmu.h
>>>> @@ -13,6 +13,8 @@
>>>>  
>>>>  #ifndef __ASSEMBLER__
>>>>  
>>>> +#define __pgtbl_bss __section(".pgdir.bss") __aligned(PAGE_SIZE)
>>>> +
>>>>  #include <linux/refcount.h>
>>>>  #include <asm/cpufeature.h>
>>>>  
>>>> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
>>>> index e1ac876200a3..2b0ebfb30c63 100644
>>>> --- a/arch/arm64/kernel/vmlinux.lds.S
>>>> +++ b/arch/arm64/kernel/vmlinux.lds.S
>>>> @@ -349,9 +349,15 @@ SECTIONS
>>>>  	_edata = .;
>>>>  
>>>>  	/* start of zero-init region */
>>>> -	BSS_SECTION(SBSS_ALIGN, 0, 0)
>>>> +	BSS_SECTION(SBSS_ALIGN, 0, PAGE_SIZE)
>>>>  	__pi___bss_start = __bss_start;
>>>>  
>>>> +	/* fixmap BSS starts here - preceding data/BSS is omitted from the linear map */
>>>> +	.pgdir.bss (NOLOAD) : ALIGN(PAGE_SIZE) {
>>> Do we actually need the NOLOAD type here?
>> Yes, otherwise it is emitted as PROGBITS, resulting in all of BSS to be
>> emitted into Image.
>
> That's rather strange, aren't the .pgdir.bss input sections already
> NOBITS since __pgtbl_bss is only used on default-initialised globals?

Not sure why, but the section was PROGBITS not NOBITS before I added the (NOLOAD)

> Also AFAIU NOLOAD does not prevent the output section from being emitted
> into the ELF file.
>

NOLOAD marks it as NOBITS, which means there is no data in the file that should
be used to populate the section in memory.


