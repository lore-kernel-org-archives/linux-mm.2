Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB538C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 16:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A0446B053A; Thu, 13 Aug 2026 12:10:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 930E46B053B; Thu, 13 Aug 2026 12:10:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F1856B053C; Thu, 13 Aug 2026 12:10:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 509176B053A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:10:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB4F2801A7
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:10:45 +0000 (UTC)
X-FDA: 85096734450.21.07D07E6
Received: from mta0.migadu.com (out-102.mta0.migadu.com [91.218.175.102])
	by imf11.hostedemail.com (Postfix) with ESMTP id BC13640002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:10:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PXJUZmtJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.102 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786637444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lobHVeCQHoGypxlv8jFldfFY/P6VmVVnvWmD09v0io4=;
	b=v2G7tbthBolDzaOOfyDTURhja6kUB5aI6zOgWl7UzvvY643cS83R4aG+yJ7Hvp1DAFwU84
	LhX3FcDNwokD6VLw4hIT+99+JJWSOcuUjXkSHmKul1SJ2hKjz+iUPIM+CQTHXESXIo6rHr
	5By6tcwzTXB7wjz4DGZIyw103t5dU4A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PXJUZmtJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.102 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786637444;
	b=OYYow6c2m5CSrOm9HjQclLhEyVm2zbzOoRt28yvpQDHWV/3o/8C5Mo7+Pn1exwaSiZ2lvp
	Oc4wQhmFu41vhzlxH7mfx3zfgveWyZ9BjOJyBWA7sECU96LreWpaMZHHy/7CyB1OQhO8G2
	JejB1hNkWHmwoUqwl6F20IZcnVHxYCI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fw0pOBNF7/8wD8xBIHeT0X9Z9PJ+9rMt7Vt2Uw6EE9g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786637442; v=1; x=1787242242;
 b=PXJUZmtJRnmTqPXYc8rpD6GhU5eqS3Qk1TsXYGr0IY8aNIhSUFrpS8tRWSigvzbumPWpDcne
 hIiJLOg3cgSQwXvb7k9NhM6nmc0Fp4nGE3Watzkif+agymK8wATy8zVFbiS90htDEUTDx9ptkNf
 mMUIuoTjxUcCj4tiCxvhyWro=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (77.97.51.77)
	by smtp.migadu.com with ESMTPS id 487cbfbea8bd0349;
	Thu, 13 Aug 2026 16:10:32 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 13 Aug 2026 17:10:26 +0100
Message-Id: <DKNY3Z1LJ90W.121VFSVFAG28G@linux.dev>
Cc: "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Wei Xu"
 <weixugc@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan"
 <ziy@nvidia.com>, "Lorenzo Stoakes" <ljs@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <x86@kernel.org>, "Sumit Garg"
 <sumit.garg@oss.qualcomm.com>, "Will Deacon" <will@kernel.org>,
 <rientjes@google.com>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 <patrick.roy@linux.dev>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, "Andy
 Lutomirski" <luto@kernel.org>, "David Kaplan" <david.kaplan@amd.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Yosry Ahmed" <yosry@kernel.org>,
 "Patrick Bellasi" <derkling@google.com>, "Reiji Watanabe"
 <reijiw@google.com>, "Sean Christopherson" <seanjc@google.com>
Subject: Re: [PATCH v3 07/26] x86/mm: introduce mm-local region
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Mike Rapoport" <rppt@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-7-6f5729aa9832@google.com>
 <am9v2bAyhWXgv4Dd@kernel.org>
In-Reply-To: <am9v2bAyhWXgv4Dd@kernel.org>
X-Rspam-User: 
X-Stat-Signature: ici8ip3t5yjs7p6rq6codboc5hhio4w6
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC13640002
X-HE-Tag: 1786637443-455574
X-HE-Meta: U2FsdGVkX1/IID9+fawjFmzun0q0SvvVFuyLq+hXKoyYQKFoUZIT/ruxe/mr7Frr2ogOv7WpxI6nwcVoWPEgKpQKPqupbFplGrCrPJL/Sm82ec6Ob3yXTflXtpj58kpzGpDAgrfRNfYbixDOvQO5sxnk/W8lceZ6cwqXwq+nroYv2Cy32bvbzJFVE52UHQS+rlWS0uoyRxxJqhHstnQiTwKyZmxQqiwwgOu5Mzy5HcbTcesYmUyy7rMbbcFFX9evGFtmgxbZsH+iTsBu0ZIRHCuoHOnBWunub0qnsSpT2DCUsOkpDdPUaRFRLU9PaeChP6QsheOt0ikBXqJrRaO+2wCB7jRILQRual8ymoSCA0IlXnP8QrNOtvqYpCUICLSexubb3ImuuLsVP3ROC8K0orye07bRZ8/NQtlZBicSzczIbHgUGiBwT9vVmXz2gSp8zFIboBXXJRZfr66ZqzrjgwG5j4pz/eaB02OgftHXp+hELkAC/diCCWCPcCTwc6581FBhgStG5t9BRnDoPkdgxFP2+EDn53b0qoWSNVQxyY+xkS7OXyTdCZwu1qEiSH+7Tgu6QZshs5I23Islllbd3I7AzTjuLvYngR06J/voGW6G0dtfyIiC3xqPWAN9CuIE/X388ZwUzrjqevgr7vdw2l+vg1ZERzjw3/I/qbB7d7Ceb8mg6O6bBzesaFMQEPW/89Kw8+oPA1HcS76jcCxmtPorsvnrHXohpT/a883HJk+Ebq3o+5JhY9nxKj3XdPwUXd8zGAnE7ObQz5+sC6hmjUVQ9hx9j08l7vkjUCP/EOVc7ZplFmWkV4IIOMwMoSuTSBrRWoFMxO3ULh+vu6gWXXFHEpoj+clfztI6+OeWN0B5UpkeD7upZ6ZPK9EqPVMaBAZjNzfi/25VQInOFObyOZPL3YKJUJg5sLZ1LP8+gtVEfyWODyssOdm5JbwL5nXOVLircWUaeomQ/aTX1T1
 B1Qe9/oA
 SF8jfFVW9JW7Ct4/+xXtLs5WRUwmawO1REWQkwp/2Z3hYKiB0vJOTb55ME9CwC2bHlndOnkFulaMIBAbK8H1QkfhYmuZNe/HwMEqid/Aq5gVFZ2hPKkDBXWhMUO6n5cEXhMShS2d9G2qFK6AAReQo79o1rRUkBzkuIQ/BsGvWVyTeVwEYVGoi/xNnNfsEnglZa0neztoVlbreIEKn6XBw4AQbTow/utDxABp24wBuf/byh4jThN3zIicKvkr9r5TvBhm/tJ/Ny94vz+r0mIgzAHw0/b9kSkhUuKAKT3EfRJcuH8eMzhuACHBR8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 2, 2026 at 5:27 PM BST, Mike Rapoport wrote:
...
>> +#if defined(CONFIG_MITIGATION_PAGE_TABLE_ISOLATION) && defined(CONFIG_X=
86_PAE)
>> +static inline pmd_t *pgd_to_pmd_walk(pgd_t *pgd, unsigned long va)
>
> There's very similar mm_find_pmd() in mm/rmap.c and I bet a bunch of othe=
r
> places walk from PGD to PMD and return PMD in the end.
>
> Can we put this function into, say, mm/pgtable-generic.c?
> Finding all the places that do such walk and sticking it there should not
> be a part of this set IMNHO, but having it in the generic code is a good
> start for a future cleanup.

Yeah, this is the kinda subtlety I always run into when trying to play
with pagetable code, and I end up being timid. The thing is that
mm_find_pmd() bails when it finds a non-present entry.

I think in this case it's fine, so yeah we could at least move
mm_find_pmd(), change the mm arg to a pgd_t*, rename it, and call it
from here.

>> +{
>> +	p4d_t *p4d;
>> +	pud_t *pud;
>> +
>> +	if (pgd->pgd =3D=3D 0)
>> +		return NULL;
>> +
>> +	p4d =3D p4d_offset(pgd, va);
>> +	if (p4d_none(*p4d))
>> +		return NULL;
>> +
>> +	pud =3D pud_offset(p4d, va);
>> +	if (pud_none(*pud))
>> +		return NULL;
>> +
>> +	return pmd_offset(pud, va);
>> +}


