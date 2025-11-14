Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CD2FCDE021
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1A88E0007; Fri, 14 Nov 2025 03:11:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA21C8E0002; Fri, 14 Nov 2025 03:11:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A948E8E0007; Fri, 14 Nov 2025 03:11:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9431E8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:11:49 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 31B5D88529
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:11:49 +0000 (UTC)
X-FDA: 84108493938.25.D77ECDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8E3FC20002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:11:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MT9IHfhL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763107907; a=rsa-sha256;
	cv=none;
	b=aj63b72OJ7ECv5Z23HPZxWmAFLbOM955wfUs79Iod48zk7koKKUMLX3yKnQ+PU04E5Vqss
	nGqfg6HcolAMivniRHszhjdHsYQZ+uYeFxbPRw5kjz2fcswa7wo/IbT1wmj+thn3RoP0Wx
	Ltdr3+2ve6TTWMRfkdKa4XL2nVSk7zw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MT9IHfhL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763107907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A1F9g0B6grh1pyEbdws2Ys5lAC9QN1XTCTeZvmfIvs8=;
	b=RALBYueAaSy/ZQbcaKQallNdI2TWVl/P9JPlyL+ua+HUwtjBIYb/LHKjAnzx8Os5TBaXjp
	+uqF2Wc9XkxeE50N93LkYghtASB3GkcXxHgLR1hYMlfT4ztAjVmgm2VOHcoHwMrrveRPVP
	eLmNRykS4Fqu7yj1cfBHM7MGQ4Fe8gY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 657B243F09;
	Fri, 14 Nov 2025 08:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39037C19421;
	Fri, 14 Nov 2025 08:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763107906;
	bh=OhGJvBDuLbsZuOLjHyEX6xIRl+rLMcdKrk/4+J4TeoY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MT9IHfhLgZNygWpWG+dIRg6p7RUMUEJnK40W4JZjMG0Yi6v+emGp8fU39Dv5V938i
	 RfBl//v9Ge3H/xItQ2DqNjBiq9ZOnM4UIPaxoDcfBXafM4kkEDITA9SSqc2sSdXGVq
	 o7Hu4mvfGFxlFKsWc/nNdJvQQlg9sWoXCT9DHE3oYDYq6WZMkCe7PG6unlXomQBHHk
	 UaXZwAnG6UHtepYc44yd4I52ghf1b8H64CrQCGiRPzXDn9UGEQmvBdJZMaPf1ClPot
	 aPgBmOUnsHTiqmRoTeu8rOVEFVk+Rd+smmC0ATKdv/AoT0lOdj+uCLIh1F+0T5pdCu
	 oCyn+0Y2SCsIw==
Message-ID: <9d30836b-9ddb-4432-aa39-85e32c2ea645@kernel.org>
Date: Fri, 14 Nov 2025 09:11:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix division-by-zero in uffd-unit-tests
To: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Carlos Llamas <cmllamas@google.com>, Peter Xu <peterx@redhat.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Ujwal Kundur <ujwal.kundur@gmail.com>,
 Brendan Jackman <jackmanb@google.com>, kernel-team@android.com,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 "open list:MEMORY MANAGEMENT - USERFAULTFD" <linux-mm@kvack.org>,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
References: <20251113034623.3127012-1-cmllamas@google.com>
 <e0be6864-4260-4843-a432-d47437b5d43f@kernel.org>
 <4a60a703-d9c2-46a8-83b4-a7ecff7f6ba2@lucifer.local>
 <aRXyxWeh81-aTHaC@google.com>
 <b4291d0d-b913-4e61-9f9d-fbebd1eb4720@lucifer.local>
 <20251113153205.6507ecb308e7d09362905da7@linux-foundation.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251113153205.6507ecb308e7d09362905da7@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8E3FC20002
X-Rspamd-Server: rspam07
X-Stat-Signature: e7tsjzanx4jdwxxkaejnfpm7usdrndrc
X-Rspam-User: 
X-HE-Tag: 1763107907-57582
X-HE-Meta: U2FsdGVkX1+AAZpWHSK22in5G+bHapa3WbE6TAZQzcqIc6Bczc5E9N/AhOVuiZiL3/2viA53K8LgI942GoTg8VVHMGLW8ZjmlMrVVGkgZHXzO0utVWBUoUkGbZZDiXWre0hlXTrAb53CFusQnpKGtsGDnEmGjhmtP5IFMysjk9tSGKfDAYqexQ9HKictgfVJ85QFQpm7ynz4+2f5rKqpOP7++tXPqw2qwd+a6j3zmzxyWngfPJE/28Z3M6S1hSdpmUMZbbcuVwbtmOCnH8nQnuDoNpjQG3IkZFD6t7BRb4yLc8rCbRi/7ruFzfTwZCbM1GRk363P0oZ0YV82ZHsLYIP9N8Nayea4IA+ASnR3QNskQN+Ohe/Ebeu0RpkFAwcEi2yktEOtuEMjXipjG0IQ9tHdgONasLpsSOieohYlNF5jyWYNItFnNYRYWDPYlZ9PVusXHj3r4RWgeX+PXgLBo/oQ7mmNCQlSDxTN832lJjuZNihg1rA/XxNBOnTQ3+p4Omf71Ao9ugyYs0CvwIokq/hVlbUGOR09VulzSq+scPpK5zchjN306uELVCSbGOkH2+dtFIAhboRbD63maxicaxGxrsNU9tfqqbg49AnIGMHcNPhMXTrB59dRSE36ZxGjXzcyzTkzFt9RtU3W2oEaWIESTJKeJkRkQuzQgiTt/UIDK1KBG3eQO2KHVnPB5yt0/AokiFG1l2TBisqcyofr1uGQBzO5fmJ4wdGiVQt0mC2zyoKTqkfB9BUJ1uAYsqHYkLucsKvMwi5gKCY9smd7RLi7qubCga7eCtj0AKmYDf0BDslw+AYPSGpzQmc5jI2aXf9CUQoOQhXzxwOmPaqoyuP1Wov2+WXJ4B4Sr4GY2LLMbGVqnN+DpaZQATwPCteolqcoq1ETbPKOpowQZuwDOo7L4zYzQKX/AIqJj8hQFwWXAH14ztkUaWKQb/Sr/p2LJi1gK2B42rb7n1voP3d
 COnjfV7F
 /luqBcXX9IUvZS+WxXqa3HmPaCWtHx3mVl9mz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 00:32, Andrew Morton wrote:
> On Thu, 13 Nov 2025 15:03:06 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> 
>> On Thu, Nov 13, 2025 at 03:01:25PM +0000, Carlos Llamas wrote:
>>> On Thu, Nov 13, 2025 at 09:54:37AM +0000, Lorenzo Stoakes wrote:
>>>> On Thu, Nov 13, 2025 at 10:06:42AM +0100, David Hildenbrand (Red Hat) wrote:
>>>>> On 13.11.25 04:46, Carlos Llamas wrote:
>>>>>> Commit 4dfd4bba8578 ("selftests/mm/uffd: refactor non-composite global
>>>>>> vars into struct") moved some of the operations previously implemented
>>>>>> in uffd_setup_environment() earlier in the main test loop.
>>>>>>
>>>>>> The calculation of nr_pages, which involves a division by page_size, now
>>>>>> occurs before checking that default_huge_page_size() returns a non-zero
>>>>>> This leads to a division-by-zero error on systems with !CONFIG_HUGETLB.
>>>>>>
>>>>>> Fix this by relocating the non-zero page_size check before the nr_pages
>>>>>> calculation, as it was originally implemented.
>>>>>>
>>>>>> Cc: stable@vger.kernel.org
>>>>>
>>>>> Do we CC stable on unit tests? From my recollection, no.
>>>>
>>>> Yeah please let's not.
>>>
>>> Oops, I keep getting confused about this Cc stable thing. Please let me
>>> know if a v2 dropping the tag is needed.
>>
>> No need, Andrew should spot the objection and drop the tag :)
> 
> I actually add cc:stable tags to selftests fixes!
> 
> Because why not.  Why leave people running known-to-be-buggy code when
> our backporting processes are so well-functioning and lightweight?
> 
> I'm not getting the objection?

I thought we were so inconsistent on that that it ends up being a wasted 
effort to even try taking care about stability of selfests in stable trees.

-- 
Cheers

David

