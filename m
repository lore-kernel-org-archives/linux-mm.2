Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F2D0C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 07:47:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813F26B0095; Thu, 27 Aug 2026 03:47:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EB896B0096; Thu, 27 Aug 2026 03:47:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7287D6B0098; Thu, 27 Aug 2026 03:47:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4618A6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:47:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A16F41A0345
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:47:16 +0000 (UTC)
X-FDA: 85146268872.15.CCA163E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D780FC0008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:47:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jXJQAfnV;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787816835;
	b=C1iKfOdg+gV2dsToKNaZd0PRLOswwCAC7qfRGirHL7+WjnYgwnCAkp4nO4b0Pnj60Q1M5I
	RHuJ3ukF7KDTYxXgJAz88xLXV36lIF7+CfsS66L/8AdrcbZ8/wjbnxccF5e3GP4ZpYm+1i
	9KvkIiANvnK4NjrcGjS1alksEQy1xfU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787816835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HAx27bjYWIezR+l7iw/n59Tjpp+JZqYjQalST4GROaY=;
	b=Xf7v9dST7HNR6SH2PHjltc5SVbMvNQVUxP++RNC1C0sJ7eLje/79wpVUMtcIM6zIKgKJLq
	h1yUYFHMgG0LkyJnbTt6EUVxi56ysZUkeu/43SflVUMFeoV7FX3kq9H6uWvz/dGzdz65Mb
	rCgbkLi+KB7ii/mzkek/0TheHHCrjt8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jXJQAfnV;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FBDE434DE;
	Thu, 27 Aug 2026 07:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4451F00A3A;
	Thu, 27 Aug 2026 07:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787816834;
	bh=HAx27bjYWIezR+l7iw/n59Tjpp+JZqYjQalST4GROaY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jXJQAfnVvTVWEWNE4VPcqMrW72bz1eQ9s0q/9pxGB/zaGdI3wBRdVVIhDL5nvhCmY
	 lC3j0jOHD+sfzJqcAIE01FVPTZ5zMFBDKqvdCxB4RdEUGSVHfsxj9pAUyDem3DiiDc
	 Cs/0u+1y1bxBZ0NGH32qI+TEeFnu2EmwnR4ii55QrS9wtra/TlmA1P96dBkZ2ounLw
	 KWrarGBk+zvC9/3bFuYSbxLGuHNb/v8r0LAC3s1+v8nHQmhrn8SW4gcaOnq9pU2cJ/
	 y0Lk4h7yDpuPuQXAVg9pKeTOuPqRAwSr8o0SOA8bMx6ZPREh+zz8paYvSEhJSAIbRr
	 KJlwyQO2cFMPQ==
Message-ID: <c4684212-f44a-4aff-a02d-f3f26095ebc1@kernel.org>
Date: Thu, 27 Aug 2026 09:47:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: reject unsupported kmalloc sizes
To: Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 syzbot+805630f1453e490427fa@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20260817-limit_kmalloc_size-v1-1-5bef487701cc@nvidia.com>
 <82f138f5-11d4-4839-94a3-c226fd982715@kernel.org>
 <ao9dPUpHxP5uOOcw@MacBook-Air.tail10959e.ts.net>
 <DKZ7J9HNUDR6.BP9KG5Q7HYMJ@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <DKZ7J9HNUDR6.BP9KG5Q7HYMJ@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D780FC0008
X-Stat-Signature: ixmfqgnxhsredowcnhuwhuz31a3smkoj
X-HE-Tag: 1787816834-486877
X-HE-Meta: U2FsdGVkX19yMvwMNHutfW0AB2PHQwofYUrtf4baNfMAvB/wdmP3WeaOwwdzJnp/DpenM7bUlCwkcLqv05DkpFvjCEDqWdphmN+Ov9cIlacn1EftdOFUTSlTQrnew5A+1vlVYGQwBLyVX8bRnm0MIa4WB2CCcFPT0uH1vRTLkNja9xiraOxhLEMuk/deMJNdLd7Je8MBA/AXDXDlPduhUsxlzGYPRmzLY9J9KItiRnZMK3isvLhj5J+eETXOtV2oiGACW9D95/yUaIJ/OyquZmeuJyr9SrdYcJxKLGKXEpBWZH9S7H0HFR9D6OORwwaup2dWO7fZ4R/fRmPM1Jds1AnOHHMleCLv3tbscUrrD0GxoJ5g2VX9pwtDn1sd+OJsmpsOR9Cy6sLyPYjtR1eOq1bdgn3z+K/cADANKQhEC4FSE+qF8H/Cjqy4ImEmeOk8JY5j39WSksXDiW/hjLqSQNTEuOmEIhTPU0Zj1Iz5DA9ivPi9KHh6TecANYIwgDmUeLshzDKJHiaU28GeNkl6Msch7OI7c/3FaPbCBYguNJULj+b9NXNfXYYEsYCMEZBtiBu+Wc7gO/0knYGLsGP1SFlJpbku1+9X0kfOBF0aOwiKjRLXTHRmPMsMi6B/ArleyXGVkwBpCbyZmq77AnBCpF1G3L+Z6GTSY7sNSmUGdTqvlwWHkuYCil4P3s7mMMRZRRNCmb7sdoKSST66JDANnlN+lhruDsIMqI9LAuq8JrkpVhLI6sHb4Bh4sczbDOA2RRc/gX6nh57owprTXmU6Ic1a8TW0itcaZ0gOLdN4ND3KIjSOMRgpsVKtPfia0BLxvbq2NiFJqYE4FqI0NnN2rRP8OcTy7T2vurTz3KKKJjHCriH4pESG7xprkRxsEAfpno58hdagUrxfOebQZeKtAtZm7ZcpjTKS0Vw0rDSK/0iWuiadKWb1/u9EcQtpkBUK2qZISJY6iZescE4Fnf7
 QdnV0u83
 qpKJ8as0eoikg4kRCpth9NrqsmoZRwOHlP50WZK8zLTRBgcw8hV9HkvXlURWL/IJj2B5Yhfjr6us6EQp8+gHiVXPenL1Punhuqt/ye+MuZhPG3IUFCN2W5o3fU0QjuwHCd/+0BtTJZ5LGJ532uvIdrGMSb4Yd9vpKvB16IYbsx1r/QA2C5h9ZoFG+teDO3l2bfoQN5MX0ZyWmZ30ODTaWquL58TqDYEuP/6qFt1nQWQxIbzBZZzsiKdEg0VmlkeD/U5IhGKYzaBsXtONObzES+2jFhdqZnELLdOuT/I1Gufep/dPi8A+b+d/9Kc09biHjVfZ2OtFIHWSIo8Vv48OPn54UstHIrqbkfcowWwCgcS2l0CPaLGQMv5SLqhMDpxaik9/c+6ZylNhdzoDTcmmlPiH6nnuX9GKDtFQGV3nqVmwDqN8UopbaK/vfNSUpW86quiivz0HvI7RhTuQH4BCUrjtEk4elz4mM7FwrRtdXujZS53G/zpgh8rY/jDmw3sCeMwVJtIvyyXIS9ExkM/QKQHyaJdpW7vyNxTSf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/26 11:52 PM, Zi Yan wrote:
> On Wed Aug 26, 2026 at 5:47 PM EDT, Harry Yoo wrote:
>> On Wed, Aug 26, 2026 at 11:28:12AM +0000, Vlastimil Babka (SUSE) wrote:
>>> On 8/17/26 22:40, Zi Yan wrote:
>>>> kmalloc is used to allocate physically contiguous memory for kernel
>>>> allocations. For requests larger than KMALLOC_MAX_CACHE_SIZE, kmalloc uses
>>>> the page allocator and can only support up to KMALLOC_MAX_SIZE. For request
>>>> sizes bigger than KMALLOC_MAX_SIZE, the page allocator can emit a WARN
>>>> because kmalloc allocates an order greater than MAX_PAGE_ORDER. Systems
>>>> with panic_on_warn=1 crash because of this WARN. Fix it by rejecting any
>>>> kmalloc size bigger than KMALLOC_MAX_SIZE.
>>>>
>>>> Fixes: aadb4bc4a1f9 ("SLUB: direct pass through of page size or higher kmalloc requests")
>>>> Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
>>>> Closes: https://lore.kernel.org/all/6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com/
>>>> Tested-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>> Cc: stable@vger.kernel.org
>>>> ---
>>>> It fixes a page allocator warning (order > MAX_PAGE_ORDER) when gadgetfs
>>>> requests excessively large memory from kmalloc. Instead of adding
>>>> __GFP_NOWARN to suppress the warning, as was done for usbfs[1], change
>>>> kmalloc to return NULL without a warning for this specific issue.
>>>>
>>>> [1] commit 4f2629ea67e72 ("USB: usbfs: Don't WARN about excessively large memory allocations")
>>>
>>> So I checked and for kvmalloc() we have in __kvmalloc_node_noprof()
>>>
>>>         /* Don't even allow crazy sizes */
>>>         if (unlikely(size > INT_MAX)) {
>>>                 WARN_ON_ONCE(!(flags & __GFP_NOWARN));
>>>                 return NULL;
>>>         }
>>>
>>> This comes from Linus in commit 7661809d493b4. I'd do the same thing here
>>> then.
>>
>> But the purpose of this patch is to avoid the warning in the page
>> allocator. Should we fix this in the caller (gadgetfs) then? 
> 
> It is fixed by: https://lore.kernel.org/all/20260820223719.A4A3C1F000E9@smtp.kernel.org/
> 
> Please disregard this patch, but we can keep the discussion going.

I still think this patch has some value if done as proposed above. Yes
in practice it will just replace the page allocator's warning with a
different warning, but IMHO it's "nicer" if kmalloc() sanitizes its own
requests to the page allocator, using the KMALLOC_MAX_SIZE value.

>>
>>> Thus there would be a useful warning for e.g. development mistakes
>>> resulting in the size to be unexpectedly high.
>>>
>>> Callers passing size that comes from userspace or similar untrusted source
>>> can either pass __GFP_NOWARN or sanitize the size to what they expect to be
>>> sane (which is context dependent and I assume actually way lower than
>>> kmalloc limits in practice). Note that passing even sizes within but close
>>> to/at the limit, trusting blindly some external source, can succeed the
>>> allocations but effectively DoS the system with heavy reclaim/compaction. So
>>> caller sanitization should still be preferred IMHO. Some of the recent
>>> arguments from Linus [1] would apply to this too, I think.
>>>
>>> [1]
>>> https://lore.kernel.org/all/CAHk-=wiSmgwwLKCqJwGS-dVHnSLU8W+7q1UQq-G9=TBGGZbuhQ@mail.gmail.com/
> 
> 
> 
> 


