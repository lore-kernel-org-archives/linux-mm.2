Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52806C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 07:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082D96B0005; Mon, 13 Jul 2026 03:42:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05AFF6B0088; Mon, 13 Jul 2026 03:42:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB24F6B008A; Mon, 13 Jul 2026 03:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1A586B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:42:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4BF0040A57
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:42:25 +0000 (UTC)
X-FDA: 84982960650.11.A8BD3DB
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf22.hostedemail.com (Postfix) with ESMTP id A128AC0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:42:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ufoX6hFM;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783928543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6yoLIAxyc2K4qHLq/6jmB6EcYdYLRcJ9qmXi423/+Yo=;
	b=IxmvRIOkVnzeDy1aMiadgEtsVGABpsF2zQ0una7nweD6tZutXUdXwgS1Pv1/5H/iO38jZu
	08yq6nJ+BiKsVJLammf33keVZ/ijUw/HAxA2QCcWnJuv0Y7Zz7qHJJ57Y2ftqcJYmOzUKX
	KgZKAVajGzPAkHE682/JSxHv//pfnhk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ufoX6hFM;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783928543;
	b=Ct9SzD6PiLSwmalLvefuOi0ggnpKWEXCGGUMCg5FMJenjkr+AJfkIebGwqNlU6nvr9TF2p
	SFh3omoSaIJEgNdxkkbtaRZSBw6ld+vgmTBXEusAfb0UcyBSMmz+gN0C2TpX55mokOuNAi
	1Oq1pHqWzlHEkHdWbgDxafA8b3jdDRo=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783928536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6yoLIAxyc2K4qHLq/6jmB6EcYdYLRcJ9qmXi423/+Yo=;
	b=ufoX6hFMdIyLPO8Bw5rY8zTYrpNA07qYpWVfVGzOWth22H/31rETGvgoTniThRqaviyYjp
	htnItLldN4JOMquRcrdmPsuHj2DOHOcAm0DNHDeMEhGdqp39vxpUiAkeDe6HylLlexVVjw
	HCSJeSNqf3qY+mgdiIs8xFbCmBLuGPs=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 00/18] Another attempt at HVO support on arm64
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CADrL8HXNoRA_cnR7KVPwN6zA32E744OKOfTmDMReoykzR39H8Q@mail.gmail.com>
Date: Mon, 13 Jul 2026 15:41:35 +0800
Cc: Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oscar Salvador <osalvador@suse.de>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Linu Cherian <linu.cherian@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Nanyong Sun <sunnanyong@huawei.com>,
 Yu Zhao <yuzhao@google.com>,
 Frank van der Linden <fvdl@google.com>,
 David Rientjes <rientjes@google.com>,
 linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9C56FB0F-AE0E-4975-9D89-AFF110433C49@linux.dev>
References: <20260708031129.3503195-1-jthoughton@google.com>
 <3B2B37B5-16DE-4DB0-8A78-4CB8636C1A86@linux.dev>
 <CADrL8HXNoRA_cnR7KVPwN6zA32E744OKOfTmDMReoykzR39H8Q@mail.gmail.com>
To: James Houghton <jthoughton@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A128AC0005
X-Stat-Signature: o6ssrzjan75fod6jb9tpohd93ykt6yhr
X-HE-Tag: 1783928541-446082
X-HE-Meta: U2FsdGVkX1/fVz8QdArC95QcKuwDBiVf71uKK9o8n8NR1OHGWePH33UZu+y8XlzAd8rcvOtEGOENNmVbFUggyU5G+/qg40wh0nny/Syp+LT9GmZR/b+V6xYYqWaww5mslxWvg1lZA8GHhlMXRqezCYrfb6P0JV0Huv0v/GNC+HkK32S+hCeWXZBLqEctiDQJHgBpIpjAjYL4UZ/vC1/vaoJW83az9RCsNbX7U2H+0LCwbd3RUrmWrLp8iLxYDZ9eiqsgRnYnJ1WeHKTioQmX5stMS7DHBk/aLy53CHka/3iokiksZcu9mF/bsf9qKgVDCCCvoRSiITmAeDLOP3Dw3LZNXWVVuZsTI/C3eER9Oo446quFJA3KUM3p/ixC8MKBDakLHd4mNZzDNKPbt97/lkvDUP7X+klPQxduI8JLaO6eCxhXbzZUirX51B9mfqkNg0REAa34hmdBdCRhPCjAFhZjzYpznugYoNfSG1sx+Hdv+3g3tsay8bK5JejhgB3LtAfevBuPoGAH4Wbjh/MKj4yuU9+6feGMoXhDmkRZVcBDPhYy2PHhvTVaWOPh8feVwc3d15uRU6WHfq7FBzsGVWGuceM2/1yn+L9zesR8ffYt2F7qZchio+34WkU9iBpYCltEZ2OUqUKzyfwu+T/DuTbYAMIHPoQkUrfemGkbzstkSDa1roZsOg5QP2WAoatl+PZu/uKqCePxf8VU6uCwgAJpJYXkqzUZTgg2CoMCSpmJc9CRcaVs0SC1ZDD6EE1WVVGuyZS6KsJlP/HEOX4OFn8mHEKpPSR+XJvhfTL+RDwa4V5StCUDdQqQIHYqoNpoQIpt1J2437XsRgFJJPX7ANRzj+ZPnr4v4FXB6irC0exbTvf8Twf/opSfEX4lN5hrw/6Cwxp5EjaLR4jNYNm4lf2vAfEUv+yw2vkuwvNvV59cafNLRN8J3MsFyuqJrFgs7cI31fdWSbfm5vA8A7R
 MEpPlRwm
 M25gtQ/LiUxEjv/1ehPFUGQkyjy7BAX5EmbX1QjbYPuRQrIbtwqSUj2Jz/t1NBIetrLnvdr2UACNoTYRw5yybxvC6jDHRW1y6JL+FU1xAYh0zZ+j3AeN21HCSahRsv+uZzyWF9M5f+K0giwCdFfu2Skwg5KyQrW0RhNfuq+hJf3fXwb03G2WpNfU1rukYeQ9DkZZUpV8PN2kgKQkQWmDZZi/eKeujompjgiW1DGXnmVWsywXi7obxFRUW9fIsHCm2VpOreZ7kQ82viao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 13, 2026, at 12:59, James Houghton <jthoughton@google.com> =
wrote:
>=20
> On Thu, Jul 9, 2026 at 9:59=E2=80=AFPM Muchun Song =
<muchun.song@linux.dev> wrote:
>>> On Jul 8, 2026, at 11:11, James Houghton <jthoughton@google.com> =
wrote:
>>>=20
>>> Hi everyone,
>>>=20
>>> This patch series uses a trick with the Access Flag on CPUs that =
support
>>> hardware update of the AF to update vmemmap page table entries =
without
>>> introducing a time window where CPUs accessing the vmemmap might =
fault.
>>=20
>> Hi James,
>>=20
>> I was just looking into the Arm ARM specification regarding the TLB =
caching
>> behavior to better understand the "AF trick" used here, and came =
across a few
>> sections that got me a bit confused.
>>=20
>> Specifically, Section D8.5.1 [1] states Rule RDWZCQ:
>>=20
>>        "Descriptors with AF set to zero can never be cached in a TLB. =
For more
>>         information about when translation table entries are =
permitted to be
>>         cached in a TLB, see Translation Lookaside Buffers."
>>=20
>> This indeed seems to support the core assumption of the AF trick. =
However, when
>> following the reference to Section D8.16 "Translation Lookaside =
Buffers" [2], it
>> defines the following rule for permitted caching (RSQBCS):
>>=20
>>        "When address translation is enabled, a translation table =
entry for an
>>         in-context translation regime that does not cause a =
Translation fault,
>>         an Address size fault, or an Access flag fault is permitted =
to be cached
>>         in a TLB or intermediate TLB caching structure as the result =
of an
>>         explicit or speculative access."
>>=20
>> This is exactly where my confusion lies, as these two descriptions in =
the spec
>> feel directly contradictory when FEAT_HAF(hardware management of the =
Access flag)
>> is enabled.
>=20
> I don't think it intends to say that "translation table entries with
> AF=3D0 may be cached" just because they don't cause Access flag =
faults.
>=20
> It is likely that this clause was written before FEAT_HAFDBS/FEAT_HAF
> existed. Re-reading it with that in mind makes the meaning clearer:
> PTEs with AF=3D1 may be cached if the architecture otherwise allows =
it.
>=20
> There is another clause, in D8.5 "Hardware updates of the translation
> tables", I_RGQLZ: "If hardware does not update the AF from 0 to 1,
> then the descriptor is not permitted to be cached in a TLB." I think
> this supports my interpretation.
>=20
> I am convinced that it is impossible for an implementation not to
> conform to Rule R_DWZCQ (PTEs with AF=3D0 cannot be cached) while
> supporting HW AF correctly. Let me try to explain why.
>=20
> For HW AF to function correctly:
> 1. Setting AF=3D1 must be done atomically, otherwise hardware could =
set
> a bit in an invalid PTE. (This would break Linux swp_entrys.)
> 2. The AF=3D0 translation cannot be used, otherwise we could
> potentially drop AF updates.
>=20
> If an implementation used the translation before coherently setting
> AF=3D1 to perform an architectural memory access, then it must choose
> either to set AF=3D1 on a PTE that may have since changed (perhaps to =
an
> invalid PTE) or drop the AF update entirely. Either way HW AF is
> broken.
>=20
> Please also see I_GXGPN: "When the translation of an architecturally
> executed memory access occurs, the architecture requires that AF is
> set to 1."

Thanks for your excellent explanation.

>=20
>> On one hand, Section D8.5.1 [1] explicitly uses the word "never" for =
AF=3D0
>> descriptors. On the other hand, under FEAT_HAF, an entry with AF=3D0 =
does not cause
>> an Access flag fault anymore, because the hardware is capable of =
updating the AF
>> automatically. This technically makes it eligible for speculative =
caching under
>> Rule RSQBCS in Section D8.16 [2].
>>=20
>> My question is: which part of the spec reflects the actual =
architectural intent
>> when FEAT_HAF is enabled? Is an entry with AF=3D0 permitted to be =
speculatively
>> cached in the TLB by the hardware under FEAT_HAF, or does the "never" =
in RDWZCQ
>> still hold absolute priority?
>>=20
>> Please let me know if I have misread the specification or missed some =
overriding
>> constraints here.
>=20
> Thanks for making me look a little harder into this; it's a good
> question. I hope my reply above makes you more comfortable with the AF

At least to me, what you're saying makes sense.

> trick. I also hope to hear more from the Arm folks as well.

Yes, it would be best to have an ARM expert here to confirm that our
understanding of the manual is completely accurate.

Thanks.

>=20
> Thanks Muchun!



