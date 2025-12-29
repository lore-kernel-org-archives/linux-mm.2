Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 808E1E92FDE
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 21:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFD666B0088; Mon, 29 Dec 2025 16:21:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DABD96B0089; Mon, 29 Dec 2025 16:21:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D1E6B008A; Mon, 29 Dec 2025 16:21:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B8ECB6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:21:42 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 290071A6215
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:21:42 +0000 (UTC)
X-FDA: 84273780444.15.6B338FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 98859180010
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:21:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bnicmMwn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767043300; a=rsa-sha256;
	cv=none;
	b=FVaiEjxOAeO+LoGwAVYR09R3m7BaN4lXKU4XHENbw/+Q8Joo3hx2BIfXliMsJ0ggTCvEtX
	R38Y5TQ8WjefzTNtK4Mh/Ed2T1aLEkKXKy1qkO62Fs96O2857pC1T8E+Fv0Kg0ikz7FsTf
	clfGaQLHyxflSbrKzZSi3FyWKqvqsI8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bnicmMwn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767043300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZdbrUESDGegj1EpDSVze6upNzve1+O4BQD6xug9By4=;
	b=8g83SnfSGDSLehFk+T9Jsvoa4O5mrpEum3cj76fkfVEx1DlyVte7pC+MeUyo5v3D3SVjz8
	rqIat0s5Si7mXyTFXvWYYlOtX1sdX2nTseic4de0/MnfGK/HZ3MJrCT2/zBCDZxPwNRW1B
	UqY++2rfGJhhQNQ1yHHXu0E/xDYPrmM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CC92B6000A;
	Mon, 29 Dec 2025 21:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B153C4CEF7;
	Mon, 29 Dec 2025 21:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767043299;
	bh=Fy6E0Djyl440LbC4IsN3A4KkNoyDnp/oyxzUqc5PaTs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=bnicmMwnC8Hz+Av7KUh2lvvxIjCzkBDY/wzSKfrzAyvWuKx1NSG9v8jBEtVzSsX3w
	 rwdxxewgywMsoi1ZrGqKx7F7AikHrXQOnfXgj7xngJrBzXoBO4L0Yiu8vkGfpHHjPR
	 3aF0hR53w77goVJU+qbgq+wJL8JUqj4vs3mfxermslBt/VCOrYeFStvIc9Un7/Aa7L
	 3dgAwFcsTgU7uKfxheS2cHtjtYbURNI/oaSs90kbX/FvpZa2wNQTL/0JTextbhpjZn
	 JMvHCDLcQwJSdwx3dOqwIZ1A0xUryUeCx+BbhDS7BMH50ZX358EnPNpat75V81nPY3
	 CZPwpD4Tn3v/w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,  "Liam
 R. Howlett" <Liam.Howlett@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,
  Jonathan Corbet <corbet@lwn.net>,  Thomas Gleixner <tglx@linutronix.de>,
  Ingo Molnar <mingo@redhat.com>,  Borislav Petkov <bp@alien8.de>,  Dave
 Hansen <dave.hansen@linux.intel.com>,  x86@kernel.org,  "H. Peter Anvin"
 <hpa@zytor.com>,  Muchun Song <muchun.song@linux.dev>,  Oscar Salvador
 <osalvador@suse.de>,  Alexander Graf <graf@amazon.com>,  David Matlack
 <dmatlack@google.com>,  David Rientjes <rientjes@google.com>,  Jason
 Gunthorpe <jgg@nvidia.com>,  Samiullah Khawaja <skhawaja@google.com>,
  Vipin Sharma <vipinsh@google.com>,  Zhu Yanjun <yanjun.zhu@linux.dev>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  linux-doc@vger.kernel.org,  kexec@lists.infradead.org
Subject: Re: [RFC PATCH 06/10] liveupdate: hugetlb subsystem FLB state
 preservation
In-Reply-To: <CA+CK2bAVuHG1cVPQz8Wafe8o2TtitrqJjqfHOT7Xun=zWMoo2Q@mail.gmail.com>
	(Pasha Tatashin's message of "Tue, 23 Dec 2025 13:15:31 -0500")
References: <20251206230222.853493-1-pratyush@kernel.org>
	<20251206230222.853493-7-pratyush@kernel.org>
	<CA+CK2bAVuHG1cVPQz8Wafe8o2TtitrqJjqfHOT7Xun=zWMoo2Q@mail.gmail.com>
Date: Mon, 29 Dec 2025 22:21:29 +0100
Message-ID: <86qzsd7zmu.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 98859180010
X-Stat-Signature: jk68n6qit4r6x8e39y68qingare9d9zx
X-Rspam-User: 
X-HE-Tag: 1767043300-264951
X-HE-Meta: U2FsdGVkX1+cfdZHKEVGN4jpXxXeBieIFcCv6UT1c8mqM4xeP7nTU+efMsiohE5kOrE+gDUkIHTu57k9izSUFR794v+MkLUuwgbBDDI2DPlEQ1KExU6RYeF7KedKeW4xMyQYGhrcQRISq9R55vGw2fpPbgAYpHBn1bHS329wGflDyMTxJaEW7vhq8OjzXRjhnvkdZv0Knka7cE8/E/Nd76di9/IvDN/4FIvJs6bHaTyrA0oOkqx8Z1Idvd4niLanQHirXV8KU+Zjpmvnac0GByBGwqffHDM/6IzxwVL8mOq5Z43tkkCRKgsQ2K7mMKNcux3MvjgxE6XWy+VJ3LOmNYs+m6kpFriK+fIGKUt3nFPQoVNwGkDgFeQL+glWjb7eRpKyCzjR+r1dWSkbZK0ko0luWeNNuiAszKR8Vsk7aFqcwP43v54cUromB4Sz+RLHFLnQ8zQHOSxZczOJEr0dvJ1+tyPderWtkABJl/XrxlIpJSABmFY8ccDg81lP/3P+00G3y3PsOIL4r8gitwwZi9aeeXUhVTCLK8FQny1nuieNOC0q76wj1zi0pIZ/3qi0RVqvSlrEWGPs/XFAiiD7L5e2zLpwIQrMr/2CGb6mdQaHcSLe0kT/kjSyfcSZQjP4QfNrV2siEqQV5it5MyPKmJfAz2n2+ec/xm6zvMD0tV5+4S1HWKH0+k2IcwkNJhENI4/bIfnGsRt9uCzPx2JmYpt4bsnhbRRxSFiHE1Ns41YbxUoz6HqUxvTyV1gz8ZcgzXCUcAG+aMK6PB6DtWPImRjajIAtIwFWETPXtDWhoi1Vy2mzHpcPVKD02unXBOw8tv9VP6YVPa1DtDcuTAwG3P2BfKXnZDywPWgETjO64ZtvVRdS+G5ETjn1LtDU5T/h0QTJDSbAJwGLqgEzFDp/syAMy6ocPKNRvY4OgQw258hwUszNBzKn4HKGO5O3bzak1LFzgF3kCl1+Tfcjeik
 H9iqwDkn
 UoRmbsemCmtrUu3AWEMGfzmKjazewlaKTlQR2B5Mm0DkOmbo4aWGipc7/KSP77G6Y0QbWvu7zLjRMhZXTYuocK4Ndg4jzQbcwzQ/Xi1NbcdgUhXWpy6wh1q7xQenP7vXeba+5hAt/8eB9E/3AH3fAXtK1t6M+D5ugKIN8BLZfgXFmjHj/fH2dUKK4bxCM2ZG2QHooVQHZSki7nQRKl88cit5dLUT0BiK++fcV6cbIO/TXnrRvkWJM+bQBrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23 2025, Pasha Tatashin wrote:

> On Sat, Dec 6, 2025 at 6:03=E2=80=AFPM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>>
>> HugeTLB manages its own pages. It allocates them on boot and uses those
>> to fulfill hugepage requests.
>>
>> To support live update for a hugetlb-backed memfd, it is necessary to
>> track how many pages of each hstate are coming from live update. This is
>> needed to ensure the boot time allocations don't over-allocate huge
>> pages, causing the rest of the system unexpected memory pressure.
>>
>> For example, say the system has 100G memory and it uses 90 1G huge
>> pages, with 10G put aside for other processes. Now say 5 of those pages
>> are preserved via KHO for live updating a huge memfd.
>>
>> But during boot, the system will still see that it needs 90 huge pages,
>> so it will attempt to allocate those. When the file is later retrieved,
>> those 5 pages also get added to the huge page pool, resulting in 95
>> total huge pages. This exceeds the original expectation of 90 pages, and
>> ends up wasting memory.
>>
>> LUO has file-lifecycle-bound (FLB) data to keep track of global state of
>> a subsystem. Use it to track how many huge pages are used up for each
>> hstate. When a file is preserved, it will increment to the counter, and
>> when it is unpreserved, it will decrement it. During boot time
>> allocations, this data can be used to calculate how many hugepages
>> actually need to be allocated.
>>
>> Design note: another way of doing this would be to preserve the entire
>> set of hugepages using the FLB, skip boot time allocation, and restore
>> them all on FLB retrieve. The pain problem with that approach is that it
>> would need to freeze all hstates after serializing them. This will need
>> a lot more invasive changes in hugetlb since there are many ways folios
>> can be added to or removed from a hstate. Doing it this way is simpler
>> and less invasive.
>>
>> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
>> ---
>>  Documentation/mm/memfd_preservation.rst |   9 ++
>>  MAINTAINERS                             |   1 +
>>  include/linux/kho/abi/hugetlb.h         |  66 +++++++++
>>  kernel/liveupdate/Kconfig               |  12 ++
>>  mm/Makefile                             |   1 +
>>  mm/hugetlb.c                            |   1 +
>>  mm/hugetlb_internal.h                   |  15 ++
>>  mm/hugetlb_luo.c                        | 179 ++++++++++++++++++++++++
>>  8 files changed, 284 insertions(+)
>>  create mode 100644 include/linux/kho/abi/hugetlb.h
>>  create mode 100644 mm/hugetlb_luo.c
>>
[...]
>> +static int hugetlb_flb_retrieve(struct liveupdate_flb_op_args *args)
>> +{
>> +       /*
>> +        * The FLB is only needed for boot-time calculation of how many
>> +        * hugepages are needed. This is done by early boot handlers alr=
eady.
>> +        * Free the serialized state now.
>> +        */
>
> It should be done in this function.

The calculations can't be done in retrieve. Retrieve happens only once
and for the whole FLB. They will need to come from
hugetlb_hstate_alloc_pages().

Maybe you mean getting rid of liveupdate_flb_incoming_early()? Yeah,
that I can do. It will make this function a no-op once we move the
kho_restore_free() to finish().

>
>> +       kho_restore_free(phys_to_virt(args->data));
>
> This should be moved to finish() after blackout.

Sure.

>
>> +
>> +       /*
>> +        * HACK: But since LUO FLB still needs an obj, use ZERO_SIZE_PTR=
 to
>> +        * satisfy it.
>> +        */
>> +       args->obj =3D ZERO_SIZE_PTR;
>
> Hopefully this is not needed any more with the updated FLB, please check =
:-)

Yep. IIRC when I sent this series the older version of FLB was in
mm-nonmm-unstable.

>
>> +       return 0;
>> +}
>> +
[...]

--=20
Regards,
Pratyush Yadav

