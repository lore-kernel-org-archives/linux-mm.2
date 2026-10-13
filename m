Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55C09CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 06:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 213816B0088; Tue, 13 Oct 2026 02:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C5206B008A; Tue, 13 Oct 2026 02:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08E696B008C; Tue, 13 Oct 2026 02:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD5366B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:34:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B6841A0AD7
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:34:13 +0000 (UTC)
X-FDA: 85316638386.21.08CDDED
Received: from mta0.migadu.com (out-239.mta0.migadu.com [91.218.175.239])
	by imf06.hostedemail.com (Postfix) with ESMTP id AD7E5180004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:34:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jPEz53G9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.239 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791873251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x3TJ+nLYXw+aqTgNhbnY0u+0hp8FGUc5AIcm44+MuiU=;
	b=0ymAuRqRx9zf6r+EetsQDYLYvOmal54mPC8hhOm+jjIqoUGp59H5Fj+1Lcahz+MPTvlt+S
	1NOGmafTCVQK+gxSYuTWtt9fuyDj6zBIuMbKGqbpOW6/rk3zKWan903wHG/gFA0OXYtlSo
	F0GciU163B1qmH7tQcH9UcjaF09OJsc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jPEz53G9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.239 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791873251;
	b=Uc2usV5SWWOsLTrhzNXzbrbCePFy0opWxknwDA+cXKZz1J2zRo5HaVgXSmg7NqP784bqma
	b8CNpukhDUdNQ4EZyntRM0VHhyVoqhr+JRQX0vQ9N3JlsG16gcIUC51jOgaCCBrQo84vCB
	AyEved/cnsOCsmvZRE6TwMqJIH8vBz4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=x3TJ+nLYXw+aqTgNhbnY0u+0hp8FGUc5AIcm44+MuiU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791873249; v=1; x=1792478049;
 b=jPEz53G9zFtMf7S7MMA3ep20v99EcICky/EP9W6meqhELt5OpbuudGf6WopZUAQNGX9cbUKp
 oL5ue2WlC4wtiqVIRa6KGdXuVmtzRp5adDL+7FzQKnKieXPXu4d223bjJvrQA680vlem2AgFhI7
 Sdrm3rr1ohq7fHe9xPgdcgq0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4af039548b386c01;
	Tue, 13 Oct 2026 06:34:09 +0000
X-Mizu-Trace-ID: 4af039548b386c01
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 1/4] mm: fix missing page-table destructor in
 pagetable_free()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <3ab63358-8bbe-4457-b21c-bb81bca804cc@gmail.com>
Date: Tue, 13 Oct 2026 14:33:49 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Dave Hansen <dave.hansen@intel.com>,
 Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>,
 =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Alistair Popple <apopple@nvidia.com>,
 linux-mm@kvack.org,
 linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2B2F2818-9309-450B-A2A4-9F53D802F1C6@linux.dev>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
 <20261010112457.49485-2-songmuchun@bytedance.com>
 <asy-b7_C3SjnmSaS@gmail.com> <145CD5DC-6457-4E1E-8B9D-AE7D1EDB0AB8@linux.dev>
 <3ab63358-8bbe-4457-b21c-bb81bca804cc@gmail.com>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: AD7E5180004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: poajnbajx1jxxtk88m5arhnpumw7ifrr
X-HE-Tag: 1791873250-992120
X-HE-Meta: U2FsdGVkX1+oP4F1xLgINObVAgX0hisXs2Yr4wsyN+tHlZZezZtZvDbCqyBd7t8qNHUHQzdKGoLIcgi9lQMXcMTiCvAA1ig5o01VR8efDUAI8bus9lF/RPLcSSUyAgLIl5F9aiXy704iSFiKveV6zfHFdEMqA+dFIKiDzJZ/hiIi7Fwc5YjNTX0dV7W3o+7Ue0pCGVInUsppNS1goPVXK5uBawe3jGGMWrL9sXO+4DWpmSXSDWVpfnXcW9aXxrGDqBbTyD6YS3hA5XZDX2tLNCEoe7vQCo/S+CmXY56N/iI1rbh4tG6Wb3UuB5j8CFo0/8eBkqYXUI5RPGPXdGJ8a3HKcUUxM5MatOYgIDnF0+N/eGh60OdTAl9MpkrhwKfAvRT30bvQGVMPk3UcMS417l/13cGq1FqSEl2HW3Du+fPH9XtptomJZ42ZDfsfR62VeRO0691Em4uhjtwyAqoTGHHQSi2kkDjzFebthq96VD9YKbZHZL5aWTtAJs85gBGgNKdD687U8sxCt+4F9D/44ABBTy57RjbHN62wMU1lJX1J9XMFvBOOCGuH/NJfDG4C07FeTLwpluR93b34r4s8ESuQzoAHOJYHJzL9R26s+YH2ZIVgqxwy1wu4ndSX/QAO5KFrrGwrDCXkHxBYz9GRPdYGn4EiVlUqRbjhHSrbh66izkpopaIwc3tp2zgmLV7cRmYOkzEFj56Kwnal2K6fsVQjuqdN9qPnh4Owe33C8OqqFdZEzTzOkAO6yRTIgGvzrk85TshC0Ffv5ZqFSi1/AzM4pDK/vPlukVQdY5Bd49+55E4n8uliZE4oBTKAyBjQgi5juIGfoyGR21rQUEHlLwEPeIIbApHYm0ZsupxElY1FRWeWZd7XSObGVh1QQxLP1vK5fgz3p3fV/InacUpXc2nF2Dcncl+/uYnmJ52N6HPnj2/VjDCdNR81zwakosF2b2t+WwXaF/E4fp34GI4
 6xdomy0h
 vBrk9+ZK7Sw2tDeb6Vd1bMyMNrm12XmQ7m/kZT+wrKBmVnHgBvGQrO+3kxHsSH1vcVicpx7qJGr0fwdO54CjOAR2BuQkFRUngfAeBzokgWGOsNcEeDQ3BBQg7RqmqPiRyLTySneSihh5fG4cPWwQXPSuSbNNxveCUm5ORUKOrWiEXt0Lvyj9f2iUOf3saGwJf7oSBE+q4BkEn7w55VBlpTBh/uXfi19SyemcFhC2/xHNseyeDNegk+itR5Xhh1lJAcmZag9T9j5XOVuKYkrkeWmTertVubvdHRUVvIYWvQX1PnNhqD3KyYpj8qpOs3scoYKf9dBRYTW0QDrHbPHadmYIZwrbkP+LGktvuOCK8E1jrfxo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 13, 2026, at 01:21, Jose A. Perez de Azpillaga =
<azpijr@gmail.com> wrote:
>=20
> On 10/12/26 2:55 PM, Muchun Song wrote:
>>=20
>>=20
>>> On Oct 12, 2026, at 19:15, Jose A. Perez de Azpillaga =
<azpijr@gmail.com> wrote:
>>>=20
>>> On Sat, Oct 10, 2026 at 07:24:54PM +0800, Muchun Song wrote:
>>>> Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
>>>> pte_alloc_one_kernel() runs the page-table constructor for kernel =
PTE
>>>> tables.
>>>>=20
>>>> HVO (HugeTLB Vmemmap Optimization) uses pte_alloc_one_kernel() when
>>>> splitting a PMD. Restoring the vmemmap backing pages does not =
collapse
>>>> the PTE table, so a later memory hot-remove eventually frees it =
through
>>>> pagetable_free() on x86-64. That releases the page without running =
the
>>>> matching destructor and leaves NR_PAGETABLE elevated.
>>>>=20
>>>> Make pagetable_free() detect constructor-backed pages and run the
>>>> destructor before releasing their memory to fix the problem.
>>>>=20
>>>> Fixes: 49f599666420 ("mm: call ctor/dtor for kernel PTEs")
>>>> Cc: stable@vger.kernel.org
>>>=20
>>> is the x86 case covered for 6.16-6.18? as far as I can see, x86
>>> free_pagetable() only uses pagetable_free() since bf9e4e30f353
>>> ("x86/mm: use pagetable_free()") in v6.19, so the backport wouldn't
>>> change anything there. or am I missing something?
>>=20
>> Yes, you are absolutely right =E2=80=94 thanks for catching this.
>>=20
>> I double-checked and indeed x86's free_pagetable() only starts using
>> pagetable_free() since bf9e4e30f353 ("x86/mm: use pagetable_free()"),
>> which landed in v6.19. So for 6.16-6.18 the prerequisite is not =
present
>> and the backport would be a no-op there.
>>=20
>> The correct trailer is:
>>=20
>> Cc: <stable@vger.kernel.org> # 6.16-6.18: bf9e4e30f353: x86/mm: use =
pagetable_free()
>=20
> also, bf9e4e30f353 alone leaks PMD-sized vmemmap pages on those trees,
> it needs 39406c05f8f1 ("x86/mm: Fix freeing of PMD-sized vmemmap =
pages")
> as well :)

Yeah, you are so meticulous.

>=20
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
>=20

Thanks.

> --=20
> cheers,
> jose a. p-a


