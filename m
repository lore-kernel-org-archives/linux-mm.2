Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5227ECD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 09:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F5C66B02FF; Mon,  1 Jun 2026 05:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A6876B0301; Mon,  1 Jun 2026 05:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795F56B0302; Mon,  1 Jun 2026 05:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 679106B02FF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:43:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08CC81C0799
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:43:13 +0000 (UTC)
X-FDA: 84830855466.17.338047E
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5745240008
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:43:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p86NKhR5;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780306991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZFkDlb0M/DK/+4npGDmhkRBwuIrbB14olid11Coyvg=;
	b=OJE1T8JIxjwvb+auLGrnkIWpJp2WCYTICZeynSVTrX3e7kq8otL9d9o3uJ2SLt0/UVNda2
	SxNQXNOsXayngw1DfbVvH0ZypggX31ox5dYcwU1y9zN0OGC82N3j7nod9bN7gUBKuwznov
	KEKVvGavAOVxeS80DivXclBAiK183Zw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p86NKhR5;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780306991; a=rsa-sha256;
	cv=none;
	b=L6gtVRkHalf/8zaxBxRiSq529MIzUgOHQH+WS3/cS5WhYIdRv517kfP+NuflOtXd//csPE
	igg5HFravLCNkhCJHXChzf2nuJ6r9WmAg3jeVZxY5Q1/wIgWVN3e938lOWyTfGCpK3YIW8
	jeBn0tqPnWTFd0w4v7VeS0RQTs9Dn3k=
Message-ID: <d144b0a1-acd5-4d08-aab0-5b2dc8219219@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780306989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gZFkDlb0M/DK/+4npGDmhkRBwuIrbB14olid11Coyvg=;
	b=p86NKhR5i/z2Uh1CGWtYdPqyJsB+l0ogupMPW57FzLrGY97HrT45jbXoDRvfhPQV6Ko/kB
	2hro5IL7lC1A5P78SDTfsqD7kOeIkD0+PPOkCGMw6SlHX/T7JIK1pyusIGtQ8D3kehnye3
	M7VgyTjtAKFZd3DPmFiYvQRNTNJOE8E=
Date: Mon, 1 Jun 2026 10:43:03 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/2] mm: use mapping_max_folio_order() for
 force_thp_readahead order
To: Jan Kara <jack@suse.cz>
Cc: Pedro Falcato <pfalcato@suse.de>, willy@infradead.org,
 Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc,
 Andrew Donnellan <andrew+kernel@donnellan.id.au>, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
 catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
 kevin.brodsky@arm.com, lance.yang@linux.dev,
 "Liam R. Howlett" <liam@infradead.org>,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, wilts.infradead.org@pedro-suse.lan,
 ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 kernel-team@meta.com
References: <20260528165635.2068012-1-usama.arif@linux.dev>
 <20260528165635.2068012-3-usama.arif@linux.dev>
 <ahlh2vdHEGo6ZSot@pedro-suse.lan>
 <cc9a1cf7-7b96-439a-b0be-ecdcf27b5da5@linux.dev>
 <ahmSolHvUChl-3vM@pedro-suse.lan>
 <185f1caf-b33d-4467-beb5-51bd8520ac78@linux.dev>
 <u52xvwk2fjjk2izdb4wvuqq2zhc5neb4q6usimcxejluuyngxw@d64sc6rvojyp>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <u52xvwk2fjjk2izdb4wvuqq2zhc5neb4q6usimcxejluuyngxw@d64sc6rvojyp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: gi7q4tmf5bq9dcgfzqutbwgicqy4nax1
X-Rspamd-Queue-Id: 5745240008
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780306991-341228
X-HE-Meta: U2FsdGVkX1+AMaIjQGgk1QlmLGbChqQjWK4V+Z5+7jVSJFdNoMio9tFw840WHdvNgilC9G9TqiD3tG+BJWhqpH0fsg/xuA4zEdxmIaqyPMHC5QO/XSOVNJdr++2QWmYYevsz6Bvo91BzDmYV7A0p8V3FO7Jy9WZ7q526aZoK8NfFTmXWHDwRPKZ9pXgH8tq6B2BncLOSwjXoBARt16BZo2Sqdo/TcnPrvgZkXq6t8A87SHUzHPNARF+5/xUvLiy0Cm6VBE7OX1HjPGb86RJgS1XqBAMVSq9AnUdige6OzAnfjYJW38xZiyJT0cVIx+ZJJLW0pJ/mWYhDl5a0t3XNPM8ZsbQ9FdUqoDI118AN0GhaV7nsg0hRv4SYTq8WtRsGcY6Xku724uyZffg5Qv0lHht6i2t20sKCUaB4z4zfmb+HFGG/OXYLdazjcT/0LlXXBYZJaKk9S+oYh+QdVmur5BYhFCgp34QGGtvGkzLCsisP92Hd/w+V+tJyFNxqeU6lQzhVg1mz93Zh5iWvKNoRKYptbIkcoaeMKv4lSrA0GeRfgM6eDIreQm5J0b1/p1I3XWfg+WEI5e9JaMNrweLAYXyP3HigF7DODWCtDzKCyADLc8yY5EPWbs3wAL6xybonxkjDilLt6iSrW9sxA1LEfaYhM2PAGo1FoZ0/5l8ucTBJaLnw4FQD0/elmTADImz8PTD51kzT2W0z7liExWrV7WF4psVXwODXgV8bY+yFeZPgDJm5KGbkRL0qxImX70w1IShvyGmcq35paKgjViqqH85X7uZSGPrB+3hvJi7ECaqCULdMU6j33yboNqbUQexfc70X7bAnFcmQkbQ1bCli2DHlcpdFHyxVsUn5nKhPKXQh6vzALh4GJB+aRgKO2k9P2SPnDKcpTzMzHTv/XZGa37UDKJv53S2wIgiD88MDbuev9fa4J1fxUT76mi80Da9R30v0spPzP2T0twLgEMY
 4Y3E3Cvy
 77Y+F3XwQANa9BYs1MmCNqG81FSmiW0Bd/ACXr41hmnAhmD43FT+tCExoklsUT5EK43MhAouI3GysGAOpcPnF5JRl6HKxiBWISZaLDk4fJzmU06frUdo8N/R6My+zZFapxRs3n96X9Bz5qOIDTik1pEeGnCIpSYfmD+bkxyagQCIWxZCrApw2YILjtSPb/MKjdzJUhsOqqg+UjkSbdmyKqY9/5uRVeZRBenXSwLSZIB0e/kctXcFakms7PmdmOqM/5quui582fJruuNoknsNSo9taGL5lXIH6uMRcFJuxxCKUmB4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 30/05/2026 16:16, Jan Kara wrote:
> On Fri 29-05-26 15:11:54, Usama Arif wrote:
>> On 29/05/2026 14:40, Pedro Falcato wrote:
>>> On Fri, May 29, 2026 at 01:19:03PM +0100, Usama Arif wrote:
>>>>
>>>> which means mapping_max_folio_order(mapping) <= MAX_PAGECACHE_ORDER <= HPAGE_PMD_ORDER is always
>>>> true, and you dont need the min3(..) in your diff.
>>>>
>>>> Now the question is if then why not just do:
>>>>
>>>> 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
>>>> 		if (mapping_large_folio_support(mapping)) {
>>>> 			force_thp_readahead = true;
>>>> 			thp_order = min_t(unsigned int,
>>>> 					  mapping_max_folio_order(mapping),
>>>> 					  get_order(SZ_2M));
>>>> 		}
>>>> 	}
>>>>
>>>>
>>>> This is because this will regress the 16K ARM case where we already got 32M
>>>> folios. Someone might upgrade the kernel and start getting 2M folios now.
>>>
>>> So maybe limit to 32MB? It's still arbitrary but at least you get simpler
>>> logic. If the architecture does not support 32MiB folios, it will clamp
>>> the maximum folio order to HPAGE_PMD_ORDER, and you get the same result.
>>>
>>> Does this sound correct?
>>>
>>
>> Yes, so if we replace it with SZ_32M, it sounds correct. I just think
>> the 32M size is too large. But as you pointed out, even 2M can be too large...
> 
> So AFAIU the practical discussion is about two options:
> 
> 1) limiting at 2MB with a slighly more complicated logic to keep mapping at
> PMD order for 16k pagesize on ARM but use 2MB pages for 64k pagesize on ARM
> 
> or
> 
> 2) limit at 32MB with simple logic which results in larger (32MB) folios
> with 16k and 64k pagesize on ARM and thus larger memory overhead.
> 
> I'd like to maybe offer option 3): limit at 2MB with simple logic. This
> will reduce folio size on 16k pagesize ARM compared to 1) but do we really
> care? I.e., is there big enough practical performance impact with conpte
> and other tricks ARM is playing?
> 

I think the logic isn't that complicated for 1, but I am happy with option 3.

>>> Bottom line is that changing things will always affect someone :) Particularly
>>> since the logic we have is not too careful at deciding what should or should
>>> not be a THP (both in anon and file cases). And if (once?) we make it smarter,
>>> it will surely also regress someone!
>>
>> Yes completely agree on this as well.
>>
>> So personally I do have a preference of keeping the cap at 2M atleast initially
>> while we currently try and solve the issues we see with 2M alone. As we are already
>> seeing reports of thrashing and compaction with just 2M, I dont think the logic
>> in this patch with just an if else is that complicated.
>>
>> Matthew, Jan, do you have any thoughts or strong preferences on cap size?
> 
> Frankly, no strong opinion. I'd think 3) is worth trying for its simplicity
> and seeing whether somebody complains, otherwise I can live with both 1)
> and 2).


Thanks! Yes, let me send this. 

Andrew I will send this as a new and hopefully last revision as I am not sure
if you would like another fixup on top of this series! Thanks!


> 
> 								Honza


