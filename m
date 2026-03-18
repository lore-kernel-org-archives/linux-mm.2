Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02AAC107760E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 19:50:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FDBC6B02F4; Wed, 18 Mar 2026 15:50:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ADD66B02F6; Wed, 18 Mar 2026 15:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 376586B02F7; Wed, 18 Mar 2026 15:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2310A6B02F4
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:50:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFFF4B6855
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:50:10 +0000 (UTC)
X-FDA: 84560224980.14.E403F39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0FAB716000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:50:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YxGhvUaN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773863409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ZjkTn0FnWHfbUkl3qnH+kdn/idocbYUcBK3yPgV8ic=;
	b=eX6N2zbb7SlnbgwBKBstMCN/rkmpRAORaOsXtYBVBAzstj9Hi8VnUzVGADKJt6H22Q+p90
	qixJ6yX+cWgcz/ssbw+QuRZnTWGQFc8F3IVZcPyqRmv0LG22pRSFFhArR3mI10Z0fHVHgS
	gA9qNrcCvv6BHVa9iB8iruGs8y6E5y4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YxGhvUaN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773863409; a=rsa-sha256;
	cv=none;
	b=NDPuE71Q6UG++/Bo8Se8Fp7h63ttEeaklvktsDPzdFcsThDXxkGay9vIbN+j3h1U53qYFn
	aAgNQiDgJzJP5jraY5DQkrKQZGX+MLU9g2zXIkE9puZX/Nd6fko66QjFSGKtf/gQXbJjsg
	Q3iF1YUKwVEAMg0qmts0EYZVFBk3h1A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 09A9640A40;
	Wed, 18 Mar 2026 19:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18B2C19421;
	Wed, 18 Mar 2026 19:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773863407;
	bh=aBpoyvqo/+v2d6P9WhuCifdS3XmIawtvNpv71rMyyaA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YxGhvUaNTocIkJZunC5vXUOgkTErMFxp4CbFY9jx7JCWxCeQGIz8HJ2OUIUkqOhL7
	 ZrORxqhDaEfi/u7zp0r8Jp9kQE/5XTZw6dOVmgOgig30Bki736Eqm4VevTIvfmshNT
	 rWzMFyDljK0zd+qeMwbmCx7UFJJVLB3Uc+4Vmy2JGjBm6DeGabx+2QDPdTGIdfUw1z
	 GeSfSbMYsmoORs88eAwr00VM6k1dGtQH0GPTiRcF6Xz546K2rFrS96tWARQzwin49e
	 T2kaf4E+NAKEUVKe3hGLybUcHNEoOE4QRgASXtYf9xUVlUD0HUIbFteFN5m2NI9cA0
	 Sx26EqYHO3Fog==
Message-ID: <5ecb772b-2f2f-4010-aa6e-8894d188ea10@kernel.org>
Date: Wed, 18 Mar 2026 20:49:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 13/13] Documentation: mm: update the admin
 guide for mTHP collapse
To: Nico Pache <npache@redhat.com>, "Lorenzo Stoakes (Oracle)"
 <ljs@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 Bagas Sanjaya <bagasdotme@gmail.com>
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032706.234519-1-npache@redhat.com>
 <638caee3-af71-47c7-bdc8-a905d3143387@lucifer.local>
 <1adffe75-cc91-4c55-bde7-9406bf656c72@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1adffe75-cc91-4c55-bde7-9406bf656c72@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0FAB716000C
X-Stat-Signature: z1z81mouz8jbraahdfx776bpa91u5jqy
X-Rspam-User: 
X-HE-Tag: 1773863408-90887
X-HE-Meta: U2FsdGVkX1/nNGvqxLkRSkK74QOI6AAEdKFPgj/n5o+88AhUVuChFwlOfyQB0nfLgCYs3KmqqI7jcitLEWnKUfud0u6hamdXMRByscXKo4+WRmUsn5JcVkh2aBDpn0aJLvRoThnBSMVvh6mFuOrEy23MpX9cU8oMdtho9r5qttUchaPi590ajkc4lQUcK+jDZPs3z+klxHaYgR6JHICxEp79y+RZC/RxPZKhcwBCCIBh3wEod6Ep1R255RdaCe3ASiXbPUpdJMnxHefof5Sy9ff4+qCMZP/5TdhpHsEiQe+0mZ6EUr843o17aWX+t3XnqR1bav1BSgiFDMXEz/V8j38jL09mkmECUsm1MFHQKYHExtbVvxxlDLTOcRWptfCHV+mf51m1Tcj97tuo2Q4lvErReSFTYZq0ZyWl+HrVVmKxlI50Fe+RQYek+/X6VhrAvh+LeYeOM5wVHEY3wIj4oiHT+KC8pymFnK0Rl/aa7kqPLjN49KU24ZVYUoNw7PWzIIqr7h3xnqmRT0Cm0jIZdzbClnyaOqCNzI/5UsTmRxEfRfiQ/57ak/CmvPSzgrPCiIj3iAEGAPZAXWWezvp61ecJh64qnpnUpg5RDTwOJxpVW2GniMLN47d2NvmmFZm5+bd+PTVElhLH1lKjSIvOAJ5KYyQWyyjpWw4TlnZ2+0pWWNg7QRy6ovWyj4SykZKGkq685YiKrveqOrX7DQznknyj6ULNIPGUPdAE9si1ioy3pDyXu/KeOxby5hu4dDynTk+32WY/EYIQTu/a0uE8bD4IRhXpK0NSCLKHJbGyueIG1kOCAAyZlDydrthvkwOWpKG6B8Tb9iWtie+80uFD/qd8FchslWovcOkvDAQHQpuhLZckTTSHYJnqZEMEy1/fh33TPtv5v9YqEptag9epDFHP8HMGiZ0jUsCxjJV0YknN5W0c+1XdSwLTrKOTJhN4f7hSYn7APGDaNpg8bsB
 KA+ZZwKm
 lAb18+Wul3kISTw4Q4JYhDJdXzXTgLzVuGEtH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 20:08, Nico Pache wrote:
> 
> 
> On 3/17/26 5:02 AM, Lorenzo Stoakes (Oracle) wrote:
>> On Wed, Feb 25, 2026 at 08:27:06PM -0700, Nico Pache wrote:
>>> Now that we can collapse to mTHPs lets update the admin guide to
>>> reflect these changes and provide proper guidance on how to utilize it.
>>>
>>> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
>>> Signed-off-by: Nico Pache <npache@redhat.com>
>>
>> LGTM, but maybe we should mention somewhere about mTHP's max_ptes_none
>> behaviour?
> 
> IIRC we decided to strictly leave that out of the manual. I used to have it in
> here. @david?

I think we argued in the past that we didn't want to document the weird
scaling part.

Documenting that only two values are currently supported (no scaling)
makes sense to me.

-- 
Cheers,

David

