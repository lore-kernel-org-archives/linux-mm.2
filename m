Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED7B5C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 18:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A457C6B0579; Thu, 13 Aug 2026 14:02:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F6856B057B; Thu, 13 Aug 2026 14:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5FD6B057C; Thu, 13 Aug 2026 14:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B41A6B0579
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:02:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 164F0A021E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:25:54 +0000 (UTC)
X-FDA: 85096923828.17.18FFD40
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1327B40003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:25:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q70Fuf9P;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of ackerleytng@google.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786641952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQD4DScbN7Dn7ZOZ3yL42S+2QtwhJGEcy/WFLg1wRr4=;
	b=j7quc2F3UE5OPCuB8fGKBJ4TbBintQLX9RuK7Sh2un/P2mFC2uReme9uBnVIFd77jT0Mt0
	9y6YBVTc4CkC009SHKnSLR9cfwk07sscGUS5kMCJ6YfGXFmJNsgBe2AlWHHVfmYQFPLG/W
	EmyXb7V0PS4NxysWg99Z88m2Za4zDnM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q70Fuf9P;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of ackerleytng@google.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786641952;
	b=jXbFZ7wTUVONPAOQpEkClkOlQIZuFOmqVkBLCSuAn4KVk1VuBZ6elUZRqoi1CSLVVRvqtW
	u9c7j6PIlQt8+2A+guPnIIv2dbI+FxzThaCpQlyzdbuFcx0mF0Y/M+0oyoK99Jd2svPC19
	I9hFddeaSF48RNCgjQbeuF07SGM72Ss=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c20363107f4so19117866b.2
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:25:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786641950; cv=none;
        d=google.com; s=arc-20260327;
        b=muZOcoE1K7AHrGIn6IqzDHmuDBaLWxojmf5IyY4wHtCC2MiegJe8Q9/dcx44yf8LBV
         1tzQgfLIvZl9IQ+peCBJKxI8GaPGHU3d5R31rR4ZNpl4BerH1Mw5lu/DlVWx+bbXt94i
         mZiegkg4AWnuaFJKwnC9ljIIBgEIk465x593+Sak+lwF2q1kaMrXYrXqJI5oycr0Wdo+
         QRmPzCPrq1d+AwmF5ve39txedXWZiHaA1Hf7jJpKfVRWoMi7INapLNBD8bmy0edQPLnB
         nVMGekM2yR2Ne3EEALthlhKfQl6POvBsKmV8neOL2eum8kECZKO7pzwQbPYCWUPn6eKm
         jlvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=WQD4DScbN7Dn7ZOZ3yL42S+2QtwhJGEcy/WFLg1wRr4=;
        fh=cD8OQ3u9tna2D76GATv7stbbfFdkT09rMQWzrhyq5qU=;
        b=T3vZ9TqfYV6N+opvun4bNsgMOJxAwGWUsHgD9/vOSa0DYFpJhJor07tDya/5snE3bE
         /S+xKoPxUJcxHzr1gPSZnsoKd4C2BVdVTPbbGQWOIV47yylmGPK90KUC8bom5NtxjGLp
         /ibHeyGMUGxfXvQKu1Sffj5YwRQb57XpMcUqo/xEze7bp9wFcuZWrrtOjr9NQdnb/IHA
         RPq0sQPY4O0P14TdjQFbPCQkc1WYYZDcUu/ewQnnFJL62WxEobCI/2gCwlv3LkvtTQIo
         8iR8l0bUszN+IyV2q3tMT1evyaXCKGo0Ic1tfY1r/FbZIOy5CnAs2wbEx6igk+PUwiuR
         3/VQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786641950; x=1787246750; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WQD4DScbN7Dn7ZOZ3yL42S+2QtwhJGEcy/WFLg1wRr4=;
        b=q70Fuf9PUOTgI7xCzw7DkRQW2A1FE2yGC51KsI41qskF7z2L2vi3bc3UvRz7N4Vb1z
         4giDjnCqIYEClS0x40U2o8TBz3j3jY57NkceI0SEqeETacQeiiPpPWXqInajE4Y/iBpC
         Hn8+3phxGJuTEFgGbmxskKo+2ns4swxjn4OqCfP/BPq8CMVHAjqmFkw3hXIJAIzEhDMn
         QPWZVYJfra7r6digPTa+OUHaMCZrTF5P0sm2vF7blNf6whtaCxXpaS0Jv5EdtSAXijCa
         1B+gmpT/31Q0tdH0bGNd2C84u/8vljHY1IZHW8OWeotGqeaq5tgj+Y15p6rvmHwmQMNq
         DWqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786641950; x=1787246750;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WQD4DScbN7Dn7ZOZ3yL42S+2QtwhJGEcy/WFLg1wRr4=;
        b=siLdgrlpb7kF37b0mPNhTIAHJOLyYR6Qf0MVj7WkuNI3s7tD0qVNeIMuAB7gDCoql+
         RHSEYxWGdr/OQPPwHPLWfRUxuYR0nBbZjLROu+Iftv3zdpcYJQjAFuWD3OjuuWuVaYhf
         y4MUxbu/0jOj8gCblTY/IkR7oBA1I/c5MKef0W2aMsrujLV4HNM+0lAkYG8SNOCw4Mv+
         mX7MxU5L3j5MOSjYplXkj2xJanSw3bz7HK4isgRSQ5cL4uXo4k9U5O1Kobc5eMlIlob+
         6ZRB+VuTiSFGsP6u9aCe/Grdl2EOGZdlz0ONX+AZC1unGjUzxXgWRCl4z0XpR1pWBFkr
         GWkA==
X-Forwarded-Encrypted: i=1; AHgh+Rp0ez9rWx8F1c7fK0yvMSfB3IxRjL1hT9gvYaFPZwVm5kEITGq1KJmNSTDm+GxZt9M10GhUH+Ut6Q==@kvack.org
X-Gm-Message-State: AOJu0YzbXQRvjLUhBUwe5lhdnH4v6sCWX6RJs8i/PMzDjDhCdpHsrvo/
	LIcnm9tMZJ1cDW/e/pLTeyVBBXfYPVag39H4qjOQi5SCCssI2fxo3NG9Bopi3vwKO7KMKRrjTGQ
	9htUwvMhohtAM5QXFpx80+QafvfeBvs/YREaZQiOF
X-Gm-Gg: AR+sD10HuP+ByL0bngfqZWewd260dVRq6rYrBCrk1Tneaqp60MNAfXmvl7I01twkBgu
	60EUnBP7fmd/I9W+w7FQVGWiYSl0N1X1cnbKlt7H+5FjomuyAbIqPJdrghr3qjjNim3fKWtmNOL
	Vp/PXHHWrFIZ0HT6yqP/RocE+ZYSj2ibkPcK0Oiw22U7pgWQ/d+njZVPZze472DL5B085UzOm8+
	BFSa0D7obBiLSqaLntOhZa7IdCfInpayH+XMBCEWunJzAwl47A/ogVwmMvbWh0wnPwanw2nGtOv
	Xm8rFxhi3V6XT2D+XpINNJrcYc035hUfqgNQ9Vmu832nC0Y2rDvH7BdvFaQKJbzvvW4noX79Ogx
	7GfnddvRoXxJCnPE0+ODbEv8Cb58roMI=
X-Received: by 2002:a17:907:3e9f:b0:c20:5213:56f1 with SMTP id
 a640c23a62f3a-c2108e7b362mr382033766b.13.1786641949818; Thu, 13 Aug 2026
 10:25:49 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 13 Aug 2026 10:25:46 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 13 Aug 2026 10:25:46 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <DKNXALH7DITL.349JD9B5RM4EH@linux.dev>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
 <amu5v-e39GKpgFG4@google.com> <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev>
 <amz0jzVPZo_eBeRV@google.com> <DKNXALH7DITL.349JD9B5RM4EH@linux.dev>
MIME-Version: 1.0
Date: Thu, 13 Aug 2026 10:25:46 -0700
X-Gm-Features: AUfX_myHzFXQ11qerQ_pnZtcdCXfP-acUpeNKAjBby0SldBbCj-SHFwOvPNPMEM
Message-ID: <CAEvNRgHvbfiyLQ6za_DRmJcRBzNe2rg3Xf=wx0=4nMvkc=2neQ@mail.gmail.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
To: Brendan Jackman <brendan.jackman@linux.dev>, Yosry Ahmed <yosry@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>, 
	Nikita Kalyazin <nikita.kalyazin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1327B40003
X-Stat-Signature: sjed3cfp3noka3amcrua543fsuxwddqh
X-Rspam-User: 
X-HE-Tag: 1786641951-625726
X-HE-Meta: U2FsdGVkX197v/2mQ6nTOQvqkqKdKNeV1ATGer8J4zA+wYIgANfVIg0hZahFr3GjAdE0GzzKutcAxsuq6RU43Hcjfc5TWD+BaQXoE7Mt37TqLUT53IPE60Xme8B8N8ufsWwH0Ugr62/qPfPrMySOqgGmeBoLiBIpH572WzzCPQeWt4b8foFhWZh0piBq2GEUVKXq0X31xcFPqyvMJtYKjutP5c+O3XAQIlj+RdR6SFZRKcdY/Smn7cE650vhvdLq5os/Eyypglt/i3I8Cl36ElBLaszk2bB9XJxU1WMPsoSgJIbvusI/3H96izCXMadeNZIIZHBFK7ZFWdI8Z4Ku14CPNDiF/oFhXrIjJdnBqP1vhRSQQjfzAQfQyrsLQA9WyA9lk1pc08ENSevntzB+0I6oOAd2CEGI3kDoPEjzubPTJxJ5Up657yNljx6a9Xt9/vmR6Xosw5vsb58DDtVsY0+7+HKdqoQnPb7Hb8MLPrIuQvxkqTkMTe0MOrpn5q+fgI9LIWhx+wIhX8Blwrs+1O+1nmz9yDcBRfh/QS8duh2eTxSM6iUDX/2KrQQsGSMpLNPqriBvbx52alfPIJ44coIEa7+fuWEkntllJ84w8aA3aSN4/oMn02MnHt2SxHLlsz66JwEXxMEq251YcM/DT76TbWcJ+tFKMpGabWEK8QQl5OnTTtUuRyJhZQzGRSUpenFu//bxwH3T61FfoVL8OBgyzW+BQIb7ALT4ApNlp/0NA9S6NjoVOwj6Td78Wf3h0e9UAzLX/aB0rZePR93Lp7bYuPApwV4jRmyc61LZedcpUP/4MQavq3Arby9jnaKFG0qmVOu3NZn3eHC4guSDBRpvP1TuDqGQ97DLVgspsewVu6wxgy7HrJGzR1T6ROEXEqkZ2keRYCoLNlK2GrJdiUF8EB/mpdUzj12JgHYZy9nWhmTxMKNHA6J1JRVYDBjdSf4F1kXHN2c3/gKR/5T
 RS9uzh8r
 v4ij801cVVFKOA+JFLGZ88FQGtVHV6RLF3GOmyAmYNe6IbtEHsSQAxqDPkRRnxTPBtKG/OtBcZFmvhQwLseRXPojLo60N+bq447V3QDt52YeEVRG+ARqAr0ySDh7rQ6r+BPWKAvRDRmaVNlwww0IYh0O3/1F+DRh2lUec8mR3lC/Jg9Nu4NFRn23oeX+Ohf/YVxWD1Sn9eIcRrQcS3C4WhLmMRMHf25tWPi9EnHxpZaFtcOemFuUT7IDdI5Sen2lBk3DG6+ctggqPBfUGwp4XJ7llXScOCTGTcuGGYyIOpAECeIWJ0FcnoRXrZDlJYPmLDVCumdvM1rTyvXnHxZUNpiHNBTJOc4fDfLJ0NzIhagFacz2mc7UPtiocuCsvZ9VV2YgR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Brendan Jackman" <brendan.jackman@linux.dev> writes:

> Right, attempting this again now I've fixed my mail setup.
>
> I've no idea how that other "butt-dial" mail got sent, I was not able to
> sent mail _deliberately_ during that period but I guess somewhere in my
> setup I still had a copy of the password somewhere!
>
> On Fri Jul 31, 2026 at 8:28 PM BST, Yosry Ahmed wrote:
>>> > [..]
>
>>> >>  		return -EFAULT;
>>> >>
>>> >>  	if (write) {
>>> >> @@ -2731,7 +2730,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
>>> >>   * This call assumes the caller has pinned the folio, that the lowest page table
>>> >>   * level still points to this folio, and that interrupts have been disabled.
>>> >>   *
>>> >> - * GUP-fast must reject all secretmem folios.
>>> >> + * GUP-fast must reject all folios without direct map entries (such as secretmem).
>>> >>   *
>>> >>   * Writing to pinned file-backed dirty tracked folios is inherently problematic
>>> >>   * (see comment describing the writable_file_mapping_allowed() function). We
>>> >> @@ -2769,7 +2768,7 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>> >>  	if (WARN_ON_ONCE(folio_test_slab(folio)))
>>> >>  		return false;
>>> >>
>>> >> -	/* hugetlb neither requires dirty-tracking nor can be secretmem. */
>>> >> +	/* hugetlb neither requires dirty-tracking nor can be without direct map. */
>>
>> Is this necessarily true? I know there were discussions/proposals about
>> using some of the hugetlb infrastructure for guest_memfd. I am not sure
>> if those folios would remain hugetlb folios though.
>>
>> Adding Ackerley here.
>
> I think Google might have a bunch of patches for this, afraid I know
> very little about it though.
>

We do have guest_memfd HugeTLB support (I'm gonna work on upstreaming!!)

When guest_memfd gets direct map removal support then at some point
guest_memfd HugeTLB is going to have to respect that. For now, I'd say
we should write this patch series assuming guest_memfd doesn't have
direct map removal support or HugeTLB pages.

>>> >>  	if (folio_test_hugetlb(folio))
>>> >>  		return true;
>>> >>
>>>
>>> [...snip...]
>>>

