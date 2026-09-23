Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C1BEC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86EF6B008C; Wed, 23 Sep 2026 09:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D382F6B0092; Wed, 23 Sep 2026 09:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02B76B0098; Wed, 23 Sep 2026 09:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87D7F6B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:37:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C25D160808
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:37:32 +0000 (UTC)
X-FDA: 85245129144.17.6C73E5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2FE84A000A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:37:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OYKKX16e;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790170650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LoOuDRGVtcin4lz+35JXooeq4HMJZWCeB4CFS2sN82w=;
	b=mbkUA/DoHP7aXMr0sqWgFmXOPXWy5Tjr5nBontp+nVIROTbpg6h7Olc/F/trReSdiXkhn5
	w9FOFJi+JniPvbSeGDMfZgqgJ0Kr9YY4ozy4X1nZ8DUvwn5ncAR0NHuj0zdXzf/qt4JbXt
	LSx2Z0pfAexBhIfAgMpAh2ZYN6rf6Kc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790170650;
	b=rGkUFu+/yxkXMLzEcUn7y52QmDNS5pq7iwogcxAo5Z9kAf1L5TUQo9F9J0ZKcpPJDEi3vl
	Z2OoIqO1YwhZ6Uq0JVE6vTEKUT9+6PEFxfeq+8U8fgnFz36UTXRoWVVs/6eRUsxGTVmaw5
	k0M+RCmIRaIQU2DHxATSNY7veB8RHVU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OYKKX16e;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 605914351E;
	Wed, 23 Sep 2026 13:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB681F000FF;
	Wed, 23 Sep 2026 13:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790170649;
	bh=LoOuDRGVtcin4lz+35JXooeq4HMJZWCeB4CFS2sN82w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OYKKX16eY3t1xaXCZTv38418gdMGxdTo9ZtAW/Kg+f8pRevCHjHtOK0VhJEG+UxZQ
	 Hamy6AOqoQ+Z3e2DsJQxZIDhWk+P1jD9YzhnWqSA9cAJ6NfhPRcZGHNPRToTu3sjng
	 OLvyRdio/Y/CAGYTOKdFBJ2DXeyNhCj+D4MZeiSkTMRhhZTJafYAnEAQycArREQ210
	 9O+YfM3bLFzb76jEYgXNesAWBUEk905Xv6Gi8UkCX5Ezsv7omCIQbJrfUnDoyN6vlY
	 JsXEIFcFdOMizU3Yjnr+gWdG6KtzcR6I3NZTwxNLjddDjeZhW06cev2TYhsSeNLtLE
	 STLNckEd3pR5w==
Message-ID: <42221bdb-44f9-4c86-a572-1d1372026836@kernel.org>
Date: Wed, 23 Sep 2026 15:37:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] Linux MM Alignment Session on Hwpoison on Wednesday
To: Harry Yoo <harry@kernel.org>, David Rientjes <rientjes@google.com>
Cc: Amit Shah <amit@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>, Aneesh Kumar
 <AneeshKumar.KizhakeVeetil@arm.com>, Christoph Lameter
 <christoph@gentwo.org>, Dave Hansen <dave.hansen@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>, Hugh Dickins <hughd@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 Kirill Shutemov <k.shutemov@gmail.com>, Matthew Wilcox
 <willy@infradead.org>, Mel Gorman <mel.gorman@gmail.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <mike.rapoport@gmail.com>,
 Peter Xu <peterx@redhat.com>, Raghavendra K T <rkodsara@amd.com>,
 "Rao, Bharata Bhasker" <bharata@amd.com>, Rik van Riel <riel@surriel.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Shivank Garg <shivankg@amd.com>,
 Sterling Alexander <stalexan@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Yang Shi <shy828301@gmail.com>,
 Zi Yan <ziy@nvidia.com>, William Roche <william.roche@oracle.com>,
 linmiaohe@huawei.com, ljs@kernel.org, osalvador@kernel.org,
 nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com,
 jane.chu@oracle.com, muchun.song@linux.dev, liam@infradead.org,
 shuah@kernel.org, boudewijn@delta-utec.com, linux-mm@kvack.org,
 Breno Leitao <leitao@debian.org>
References: <45af1b22-49d4-5d60-e7ad-14a1a33c8dc9@google.com>
 <arPElEV0zDhXrteb@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arPElEV0zDhXrteb@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2FE84A000A
X-Stat-Signature: 7xropfeywd1j3e4iy1hcp86djent3smo
X-HE-Tag: 1790170650-444533
X-HE-Meta: U2FsdGVkX18G+lAiVLp20KnZtEaALYvg6vX6XKE57nJrDFwDRFMZ+xkCu4vRZrXR6SXs4/hv9nM1GCTGZ1fW1lypadD8UkXgkA5uNwy8vCmjwewewgFqkirnamr+Up0J50+fU9NirojX6lnqrk6XuS1tt2yhtGAA+KOwq2WrhOY1DWnKXUrUcBJAlcxf3QnzVoXGIon0qGPq1o+n4vr4sYc47xedu1MEz66/TR6qWKKCbFhZ7aaSeDLW/IAGfiUYuEJLS9EuNEeRwYdxVNS5sNUtjrj0l9tlXtvEC8twNYcXl5dBa5cw2cZNMLbIUmFw+tcfX/HhpUBPm0c1K45+tgAOtvfrQ1VqkiLpTvKGlgD0TfyDYGf5OXL4Kwk+awu+paiRO2YbgW+GtNJiAmwrzYdCSCA74yq35gEb/sQBUrcYWAv2Pi7OkaXXrLUX3suPPSxy8uLA5xfmpVWtz07FhHQkHdeVHnNNsYFwwvvqiPzVNZmJDRVky9zGhjvP8mkOYyKja3aFxz+EOkmNcgsnneeZRnFUrpmkm1l58Qd3Sbc1jtLH05eZgGkk0kIowSwr7/R95BuGTsKHzFN0Ns/6v3GgIqn27idxXGbQtATgVah5xpYOMYiosB9d7KX3mvAgxCIB53pfoQvClyjNi/u0H0qhjf7RKtXuW9cxXf29t7AXO9CpsrthH9nXOpB4DOagukfy1i26Uy7JOIcW5FrE//mJhDxCYqm3X/OSTzI0Km90kRdLiPBusqDl9fsOKpeezrS3j3bLpAvhJvzZgoIlXVDuItx3f2XvnhlyQ0OrK9CTqC6Nz6f4XknTs4KbXvbp566mCfRA43BdB3SEgJzjUiFI0FBDRObupijCUmGLVycyrwBebCBEmaFlcRpmXFgpparcrF0zc46YS6eOqxuJQ4vQ+uc2QzVx/oaVAWzKxOBxtlJt/GhaFTtdmmE1/7EeUuWtVHvmLduQ5bb/mNr
 4OAkq2xT
 U6LjtUlX1tVA33fnzhDz6iCEqRIM1JYn6K66m7Kerj1sAIvZAcyWChdKSc0lbV56sJvVOCGV4rGEUMayp1BkCn1f1NdbCIVapf7jJqzgQxnW1j7QSQJkznNHgeVuqz/fHUr1iNCfvMdhcOOEyZO0Syb/xRc+aHMTO4KRwJKTAHLjHl/orzrlvcPLVq/wPrWyBMttQapmPV9lh7JqlRDJFMd4gv5Mzs52JCcKZFEk9rKYkoHIZSjsFIY3Pd/r6VROBcUqMpxykh9wAylLEF4RW3uJogQTyr/dx4EyeJcVFXDs6bMp2j5znoJM72ds5YYguSHV4J6ypzQOPBJCP4p3sbTRoYm2dHhFCYjm9YHB0m7EIxdsAVPsTqeeJ28yYmWO6TXSI3TsAWZLo6jKSHfpEbN385Qt5QZluWpr8M4I1KG71RrZ5gmyhwF8BYc29VOgT8FiPS61Qyo0oUomAib1ZL/on9DkoGoNV7NPV48mU4g1qArN6ZGTrBItRlq5QGWkRX/Vaz7C0nsmDJ/0akTRds/EEyaLZNwIZDWHs5gxk7Wnih3tS07wbm2RloyHTz7Qvnq76
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 14:57, Harry Yoo wrote:
> On Mon, Sep 21, 2026 at 09:26:22AM -0700, David Rientjes wrote:
>> Hi everybody,
>>
>> We host a biweekly series, the Linux MM Alignment Session, on Wednesdays.
>> We'd like to invite MM developers to attend and will announce the topic
>> for the next instance on the Monday prior to the next meeting.
>>
>> Our next Linux MM Alignment Session is scheduled for Wednesday.  The
>> details:
>>
>> Wednesday, September 23 * 9:00 - 10:00am PDT (UTC-7)
>> https://meet.google.com/csb-wcds-xya
>> backup: https://tel.meet/csb-wcds-xya?pin=1301132214803
>> doc:
>> https://docs.google.com/document/d/1QQfZFPHa-pGEGf4A06cSqS0jdJwuZ8ro9JU5H0YSUQ0/view
>>
>> This week's topic will be Hwpoison, see the discussion in 
>> https://marc.info/?l=linux-kernel&m=178796007385067&w=2
>>
>> No specific agenda other than to gather core MM developers with hwpoison
>> developers and discuss:
>>  - where validation should live, esp with regard to the page allocator, or
>>    strict invariants in the page allocator
>>    + implications for the fastpath
>>  - handling for folios of arbitary orders
>>  - handling partial folio poisoning and split failures
>>  - race conditions between memory_failure() and concurrent
>>    alloc/free/compaction
>>  - soft offline for pages in the pcp lists
> 
> [+Cc Breno]
> 
> This might be worth some attention:
> 
>   [PATCH v5 0/9] mm/memory-failure: keep hardware-poisoned pages out of the next kexec
>   https://lore.kernel.org/linux-mm/20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org/
> 
>   - The question: How best can we pass information about poisoned pages
>     across kexec when the kernel accesses a poisoned page, panics and
>     calls kexec, so that the next kernel avoids hitting the poisoned
>     pages again?
> 
>     One challenge here is introducing another source (a new EFI bitmap
>     that represents poisoned memory, in addition to existing
>     PG_hwpoison) of poisoned pages adds complexity and confusion.
> 
>     David Hildenbrand suggested that we should simplify this as much
>     as possible in a way that we don't have two sources of information
>     w/ inconsistency between them and using memmap as the only source.
> 
>     e.g.) By consuming the EFI bitmap only once when initializing
>     memmap (to propagate poison information to not just free pages
>     through __free_pages_core(), but to the all pages on memmap).
> 
>     Another challenge here is that we don't have functionality
>     to poison pages early in the boot process before memmap and buddy
>     are ready. So any allocation before initializing them might still
>     allocate poisoned pages.

I've been thinking some more (and will reply in detail to the series), but I do
wonder whether memblock should actually be thought about poisoned ranges and
refuse to hand them out (reserved/allocated).

So we'd use the bitmap only to feed memblock, but not for anything else later
(if possible).

-- 
Cheers,

David

