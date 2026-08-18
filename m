Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74FA1C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:41:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EA126B0177; Tue, 18 Aug 2026 06:41:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49B206B0182; Tue, 18 Aug 2026 06:41:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D79C6B0183; Tue, 18 Aug 2026 06:41:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1DE2E6B0177
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:41:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B37201C2081
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:41:23 +0000 (UTC)
X-FDA: 85114048446.21.BAEE2AC
Received: from mta0.migadu.com (out-216.mta0.migadu.com [91.218.175.216])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1DB6740003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:41:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wCVUOdIN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.216 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787049682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZqfPL3hNqg3DzUtE1/bsgEXNW88LJZK7YVvpHIcXso=;
	b=ClLJMJeUfD4Li8qf2Jzx/y1b6Ufe2pnHHLpjff3wD1laAN8huSsEgyYSInRnyznO8+BSqB
	kNr9YRVtIGwKARm4kDJ7qfune8VIHSK4qT3519yZt7DFqHyR2wCbrUO9G4c/ZcJnKDh2U/
	ZBe29Herwxax9EqRCj43U10R8vjdfIU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wCVUOdIN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.216 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787049682;
	b=JBkh3gCkYOmUkLJOWwbRxVRsbCoY94Hwf0FxaBKlChpUVoXJMIh0W852vC+184Ze3Kl1a0
	DUPQIpigoqSVq7ZCuRMXAEq0bO8l+Vuw/JIEwfimVn3eexzLv1+omNz6ODXE75Ly/hK9ZS
	61fxlJAkt9Z6dGV2fgV37AenLA3/Bxg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AdNpCvXjbRVRUh+sR7PvZD45HE1LNZ7V1IsV7Ihzn3w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787049678; v=1; x=1787654478;
 b=wCVUOdINJQTLXwyskRvhWPRVfs76ENUBMeuuA+RGJOtcFf2H4gt4XjPTEQpDvGsnFpcoq3nA
 /cECqX9KGxAKbag8GMQy8h2lxO0WBRLyJg9GUuhPfbcBvXE7VKQLynVgea8yMZuFUNKG1DFyUtg
 Wooiendw7xG0GVSOdzl+mzZY=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a02:168:f6cc:0:a69a:f3a4:8fdd:3332)
	by smtp.migadu.com with ESMTPS id 675f5a73bd14fb8f;
	Tue, 18 Aug 2026 10:41:08 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 18 Aug 2026 12:41:07 +0200
Message-Id: <DKS08JR4HOB1.340HF6V5WFNSR@linux.dev>
Cc: "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo Stoakes"
 <ljs@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <x86@kernel.org>, "Sumit Garg" <sumit.garg@oss.qualcomm.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, <patrick.roy@linux.dev>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, "Andy Lutomirski"
 <luto@kernel.org>, "David Kaplan" <david.kaplan@amd.com>, "Thomas Gleixner"
 <tglx@kernel.org>, "Patrick Bellasi" <derkling@google.com>, "Reiji
 Watanabe" <reijiw@google.com>, "Sean Christopherson" <seanjc@google.com>,
 "Nikita Kalyazin" <nikita.kalyazin@linux.dev>, "Ackerley Tng"
 <ackerleytng@google.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Yosry Ahmed" <yosry@kernel.org>, "Brendan Jackman"
 <brendan.jackman@linux.dev>
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
 <amu5v-e39GKpgFG4@google.com> <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev>
 <amz0jzVPZo_eBeRV@google.com> <DKNXALH7DITL.349JD9B5RM4EH@linux.dev>
 <aoOoAYNxCX0dmJn7@google.com>
In-Reply-To: <aoOoAYNxCX0dmJn7@google.com>
X-Rspam-User: 
X-Stat-Signature: ok3nppfb8exddo949ofmq9jwun97aq9i
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1DB6740003
X-HE-Tag: 1787049679-669006
X-HE-Meta: U2FsdGVkX18JsBrDh+kUtqgymZmHHGPF4Mmf3pgtudr1WhDwS7WKvBhPy+BwkLIrWVOmIzyf2tn1Ry1dlCijYYj1ZokSPJ0TiEypwy7g9R9lML4VrJRiPDSreJg+ggxduBKjY/uIbB9igx1gNF51WIawtrKrEE12sQwywtFYFDteR87lhRkX8oykFTyRxm86zPLL5KZaxPmYSTgWZ5lzgns/ofDWXNDdJipeQlfBE5bVAgU8BIMufA7F6WTAxKkX5hQPDqfV9CnSCt3t52ftEfqgjGpejjvNg9ElT26OeOPNj6qt+F0BbFU8XDJdvZ7Bf0onJ5dOFqDeGX3kjIrywUAZW88XRk76WWV2wJVo/mu6+Ymmze21LN2HDQi9j1zc/YwgfZXfqHtTXtUON3WEEV7BLpJ5uxxZNcYzZVfZDHJWnAtREXVBhGQqUNCmOI4In8HGa/hXzTakf5c2AHgGTQPRoX9H0uPmeGWhJPWgAASH9Muqw/5te4tiBCs0hPRSCOJEuya+Tu05xLCCuDudqcwoPBr5xHsJzsaLEThSc2aVvX+ozHK5IfPyacDTzRIuhneFw4NlhKYwIPmXiZUjpfYKygYMhT9oDipmvAxGk8zXVQCoFCFG1xj6YS1mP57BbJZSzHcLapZu1mBy2usTPi8wDllmPMt0Fm9KmhDbN3lRZjxuzZXQnlc1g2ZXzWqkHeTgLcinmZm0PQTS3RlVBSfpE+7+9CIw2xiAZM54Xdn8rqSJVjGhuFwNR+VKx4GtFiiKiy1quV7Y3FENGopxJO6MFY5Votb5nGyLf4tjjw0C3w538yFcODbsbA4r1QeesGbtmZmIpyVjDXDGu2ox3rN8P+aeY0+NjdeIwhWf9IWwmBRNDY+LjIBL4lyN3qpl8eebBJQF4+6+eTs9TsFn+OpEOP2xSzqj8RWa0VW0SzhmDw9IuhsoRAHty7dwjOx17BWVVpFiPAHT7cJIwhb
 8JZnEnx/
 7CzBPNK3qvH4UsyJRzBP07FPzIMSogCzEnUmsHdGg3NjyxAYKu7m78abKRjElnhofwiKO19Ni0XKwf9u5SoyOK0AJ1dmGJRLDEyRkCd530J4Orn7VI4Rrpy98oiwIGxc/NT+gzZpF0YzeLOt4GF5rhfg4XKWCQLJ1Pb2yWQlqfHP7dSwz3Y8kreRb9VrU8riy3OqUP15/DgfyTrWCGgKk3ZfGQfI7pSFcbR7SxgPcIjX9ZV3DCsuJ0liUqbPC8QbR7Gqx2Lnk7v9tPRfGlZFd1S4S1nx4+si67bkkx1FPBC0MGhkSHvuag7wWfBO9YW+ID0+ZUYcGN3+RRqXcR7vFxQaD0f7nkuvEAi3AQhnBrkRnwVQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 18, 2026 at 2:32 AM CEST, Yosry Ahmed wrote:
>> >> >> diff --git a/mm/mlock.c b/mm/mlock.c
>> >> >> index efa6716e4dfbd..045b6779440b1 100644
>> >> >> --- a/mm/mlock.c
>> >> >> +++ b/mm/mlock.c
>> >> >> @@ -474,7 +474,7 @@ static int mlock_fixup(struct vma_iterator *vm=
i, struct vm_area_struct *vma,
>> >> >>  	int ret =3D 0;
>> >> >> =20
>> >> >>  	if (vma_flags_same_pair(&old_vma_flags, new_vma_flags) ||
>> >> >> -	    vma_is_secretmem(vma) || !vma_supports_mlock(vma)) {
>> >> >> +	    vma_has_no_direct_map(vma) || !vma_supports_mlock(vma)) {
>> >> >
>> >> > I don't think this one is correct. From commit 1507f51255c9 ("mm:
>> >> > introduce memfd_secret system call to create "secret" memory areas"=
):
>> >> >
>> >> >   Since the secretmem mappings are locked in memory they cannot exc=
eed
>> >> >   RLIMIT_MEMLOCK.  Since these mappings are already locked independ=
ently
>> >> >   from mlock(), an attempt to mlock()/munlock() secretmem range wou=
ld
>> >> >   fail and mlockall()/munlockall() will ignore secretmem mappings.
>> >> >
>> >> > Seems like secretmem pages are just mlock()'d by default, hence the
>> >> > check here. Maybe this also works for guest_memfd, but I don't thin=
k
>> >> > it's a generalization that any pages without a direct mapping shoul=
d
>> >> > receive the same treatment here.
>> >>=20
>> >> Ack, yeah this sounds correct to me.
>> >>=20
>> >> I guess you could argue something like "the reason secretmem is
>> >> implicitly mlocked is that it can't be reclaimed, because there's no
>> >> direct map". But that doesn't generalise IMO, you could imagine letti=
ng
>> >> the user say "remove this memory from the direct map, but I trust my
>> >> swap system, you can swap it" and then use the mermap to implement
>> >> reclaim.
>> >
>> > Exactly, I don't think no direct mapping implicitly means unreclaimabl=
e.
>> > I don't think you actually need a direct mapping to read/write from
>> > disk to memory?
>>=20
>> Oh. I never thought about that! I suppose the DMA is gonna happen via
>> some other address space, either it's via an IOMMU or it works directly
>> on physical RAM.  So the kernel's direct map is irrelevant... Is that
>> universal though? There must be cases where the CPU's mappings still
>> matter...  Umm... needs more research!
>>=20
>> (Don't think this blocks anything in this series though, let me know if
>> you disagree...)
>
> I think we probably just wanna keep the secretmem check here instead of
> generalizing to all unmapped pages being mlocked?

Oh yeah I think so too. The above is all just pondering longer-term
questions.

