Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D39FCAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 10:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90B8D8E000A; Thu, 25 Sep 2025 06:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E2CC8E0001; Thu, 25 Sep 2025 06:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81FF38E000A; Thu, 25 Sep 2025 06:50:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71C208E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:50:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1900D160451
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:50:59 +0000 (UTC)
X-FDA: 83927455038.22.E41313A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 582B7160009
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:50:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758797457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=As5jknfM5N/aviudcY4xUYvETW3cjcJBpuV7gOfO4iU=;
	b=sMd6ym41DGm5yHYogAsWZyspOBvFt4bw1U0/JPzIGj9+f5KsmL9d43hH6E5wKUMG2VReDa
	apaE4lqcLzq/nQM/wAujhyGLMCcsnUlr21A+9B3usxtoBBBL2hLE0dpNGvFo0iMJ4EobEb
	Ul/nezMTIdeCRRpaLE41nXP3yFLhEDo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758797457; a=rsa-sha256;
	cv=none;
	b=1J0pgxJC0QsWEfYkI4zvDKilztmoOFjZpA1Y/395AYUuBy/5X4LDmyGAnFnt+IT9e4JckW
	k040Eas0AVpJdAoNRHNmAOc2Vz0n66E5357fx9HtH3tnT8Odq9XVf0Sa2e8m10AqUQ2dF3
	9t5xfT5yI6xHN+4wC3VH6DmmqmlLZ/Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 011731692;
	Thu, 25 Sep 2025 03:50:48 -0700 (PDT)
Received: from [10.164.18.52] (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46D123F694;
	Thu, 25 Sep 2025 03:50:53 -0700 (PDT)
Message-ID: <26ca0d6b-5fd4-42f9-b985-936d9a72d307@arm.com>
Date: Thu, 25 Sep 2025 16:20:50 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: move rmap of mTHP upon CoW reuse
To: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lokesh Gidra <lokeshgidra@google.com>
References: <20250925085429.41607-1-dev.jain@arm.com>
 <072b8684-47fe-4a2a-bf69-f6d348f0489b@redhat.com>
 <45e08ee0-c85e-469e-a3eb-4ca2e8b7ec0c@arm.com>
 <462bb4e3-7a38-4155-9f95-52fbb4b6d464@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <462bb4e3-7a38-4155-9f95-52fbb4b6d464@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 582B7160009
X-Stat-Signature: gn8zomcco75sdxb7ypr1k7s9xgh8care
X-Rspam-User: 
X-HE-Tag: 1758797457-836274
X-HE-Meta: U2FsdGVkX1+Vc9BcfB/Dy8dePB4vU3cocgiNkdyqu4NRkWYft8kFKtlsVzJwOSf9s+jBvyXf1oymQIFNN1Q7ae4JwqXFdiBAi2m0amFGDy4PtA/D6D60GWX/tkBZoEUtmXUx7ST8YbN+ccSJkqwhXstXxUIs8WukCsKYkfV6IUHEZgpz/6mTi7rQoPdhOEGrrlCMR9l3PXys+UoDK7wPNBpe6iUqRNP/2ekDiXE6oNpHwUylR+VstvcHuzDbsYVf3NH5nXxDPReJTf3nzcjiH/zTsPW3c6mlEmNA10hYu4kezHer1gOtS0KuTnCl/A4rHqF+8Vnxy++nPtrivybLXKDeU59aKYcwc4702lxmeYvG3AjLoimlvT8y5pNNUHsV+PAP3nKKc7821Iv7fN9VbOq7sMwEIyQpVHOiPYc+kg3ESJ9IcR6Hf0jBKKVjj/JvKdUOnJ2hGb6uPnePoHbTH4CwwTJNeSFn9IkVjIr1j55GFogDDnTHwGOI8Sg4vu6SrizQQ4MJkf0qYgY+VNhuuuFJB0THRFQBPfuwZ833rKBHtgip44tzS4IE/YwCNlkropWgIPBSJ0Tl0OAN5wpfxLNjjuoc8Oq4ZQI9OYVWHWhn7Wor+AD38zXpjCkI2nMfO1qTE+23lU/9JnCsizCIsqMwXGoX3JXLt9PlA+EynOpO5Zl5EJz/EE3fi1Y5WzmNWDmPAMbVPPbMmlxmlCgjFaS+7a0Ftja0bM6HkTV8cqdsdZnTpng99L9QMboOpXxDT3wRB+NmgO8E198kbuSJY21JGpJy+/Z/vzRfgym+SCyEKTjqf3QwSQARDvIyhF+GslMnzIYBxTKsgw7TFKPXWryPXpyGIaj9k2ebUCRatOHJdUAIetOueEWwmoXdCGVv4Ghogs73bP6IGux62hy+Fl9UkomMyBXe81nfYE8z+3PoqJsygWkZVMAurFhsT9IIE73noo5DIsgaWnZOfKw
 sOf+1w38
 rzeuuOv4d55qVzxDIWANzkUkiN/6UDD2zWX1qZHLzUf5mbJ5+eycDv3R0AKjbqSNGZEiY3q/ClMOaML8FSlqt6I1s3LOJuD01Ajb3JDPEmJ8IEKUCckpSNL9amDavvp2PF0MDWexKnxoaZI4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 25/09/25 4:07 pm, David Hildenbrand wrote:
> On 25.09.25 12:33, Dev Jain wrote:
>>
>> On 25/09/25 2:46 pm, David Hildenbrand wrote:
>>> On 25.09.25 10:54, Dev Jain wrote:
>>>> At wp-fault time, when we find that a folio is exclusively mapped, we
>>>> move
>>>> folio->mapping to the faulting VMA's anon_vma, so that rmap overhead
>>>> reduces. This is currently done for small folios (base pages) and
>>>> PMD-mapped THPs. Do this for mTHP too.
>>>
>>> I deliberately didn't add this back then because I was not able to
>>> convince myself easily that it is ok in all corner cases. So this
>>> needs some thought.
>>
>> Thanks for your detailed reply.
>>
>>
>>>
>>>
>>> We know that the folio is exclusively mapped to a single MM and that
>>> there are no unexpected references from others (GUP pins, whatsoever).
>>>
>>> But a large folio might be
>>>
>>> (a) mapped into multiple VMAs (e.g., partial mprotect()) in the same MM
>>
>> I think we have the same problem then for PMD-THPs? I see that
>> vma_adjust_trans_huge() only does a PMD split and not folio split.
>
> Sure, we can end up in this reuse function here for any large anon 
> folio, including PMD ones after a PMD->PTE remapping.

Ah alright, I was thinking that something may go wrong through 
folio_move_anon_rmap() in do_huge_pmd_wp_page, but

that case will *not* have the PMD split guaranteeing that it lies in the 
same VMA. Interesting.


