Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04165F9D0D6
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 15:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E2976B0088; Tue, 14 Apr 2026 11:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 593A66B0092; Tue, 14 Apr 2026 11:47:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 482A36B0093; Tue, 14 Apr 2026 11:47:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 355736B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:47:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C42B855DAD
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:47:09 +0000 (UTC)
X-FDA: 84657590178.18.10CAF66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id CE43310000A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:47:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h1wVR/cz";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776181628; a=rsa-sha256;
	cv=none;
	b=ZApJ8rMhCbjViVkcJCvZ5IUMikKMJA1ewJZ/f/QzMBgE25AI1PDWI378t8mt3KBw0PJaHr
	PCxZxc98OuJof3ojWc5Ts4jonJ8APV2Mkt3ureZsqtmTSc3Me1D+YZq1H/mk7bpuG5wqvO
	xr14WPHZ4Xr/N8One8P/6Sha1ABk/pc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776181628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=klxfbC7zyYmnU3s42+u0p5uxUIWCmE5WYZXejDh/+/A=;
	b=YNFKqjtcJYfU3mSYQMa4D908GhFyCbdweJJYFL8fdzqdr+ojzAmJsM8w97kyMTmiLwm726
	zl+i0oDpH3ZCeWTclbJLr7fCBJ/18gn6W29qYMpptq2nNUN36J/sds9r5+G4aS4FgSKo10
	9nV7qDblFXNzh5lx61Ffi/JSr/1vuoo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h1wVR/cz";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B5C58417D8;
	Tue, 14 Apr 2026 15:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2578EC19425;
	Tue, 14 Apr 2026 15:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776181626;
	bh=bFYymnGKlPpXMQOtr4KQ9ZRTIC572uDtmfpvEZBw97g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h1wVR/czaDhbpEeVeiwjZpMMV7t4hPQCFRB/51dSknKVBFIecdQMJeoohxonXeh2w
	 v/X3IOhaYRKLnCXmvxL9aiVsNdLaz9uBM77mhNA85RVxKI4DWsEC26mfH+AbRNLNEf
	 T4+8WL99tDJp+r3aWL5ETSj5BeR3ZAH8V5R9fBOp9LTVlK2K8S0I357X5ZpF70aCis
	 374M101RO4IaxXuM+hRwXWxytG03t9Lp/3rdUN9dhqWJjl1EVP0PjBDI8+jYkkdk+5
	 9MLJILqotDOgaQXqKXvFgmSKXNPwCFiinz8DA++WnTXW+pbIYgaENp2ipBSUSPKamw
	 SsRPub/s5kFEg==
Message-ID: <6fc307da-72b4-4d07-9e34-5e6c0563124c@kernel.org>
Date: Tue, 14 Apr 2026 17:46:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/9] mm: add __GFP_PREZEROED flag and
 folio_test_clear_prezeroed()
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
References: <cover.1776033471.git.mst@redhat.com>
 <b21b0ba353330f24b9e10ee5bf01b60f32043327.1776033771.git.mst@redhat.com>
 <b258160c-5287-43dd-b56e-268c403b85ea@kernel.org>
 <20260413163644-mutt-send-email-mst@kernel.org>
 <da935245-9c75-4cf4-8a42-2c6328bd93f9@kernel.org>
 <20260414062524-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260414062524-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CE43310000A
X-Stat-Signature: jztcycmkns6wt4x47dwurj3gwyffk75g
X-HE-Tag: 1776181627-578685
X-HE-Meta: U2FsdGVkX1+e4a4lkiT3z8YeRdomre6612DsQQGZNBU47FAvfD3WvcSuxOG5u2rwjD5Wqe81JCVvWzJr7wZr6AWI3QukigzbX9PLxxllnlZqyFixYbTNrb8x55ic+hTCxn5MlP2tKYYMwNCAxsw/OLjxfi2iyP0aJMDWXcqUiwtk04RZY3WaPvu+6LPscxF0RRJJJHiTE7Jy57plFWIMnYFEL0+To8/MamGoyopYCl+sXkHRxN06iVbVsB0IiRE9HkPujrdTZhG5rXW1sk/4lsuzvtF53U/GAsU1Bi2FchlSQYQntuGPaIc9wDQbJ9yjLOYYMG28IR7cLJFDn6qI1fJGtU29NxuIFHihvk4qyEzOHxqvHC2wl9bVIjb91qOjKQb36gbpUcjwI9506v/ADFDZVwc+/EPMRnbp7DMD+G7NYvTcxe0Y8zlW+c23VjhpE5caBh4xyuyCw+7V4iVy9vffIrH4yAT52bO1g7XswaXlF2DtetJXOLwTOx/vxU/NXD3+WjUhgBvkj70RbMkd0qrQyWSkicPCLGBZeqvOpEjrgs+1KzXz6dZTS1xicaBOO8poLWgZuh6GrCT/NTs9h5Cit/II+MA/JfvsDPBhYlZOBcsa276OIVDwMgWyiS7n21ttS4lvmKmUsY5fberL+yx1U/W1NXnJB16NvE0pmdaBqTtG/AsCyUUBieix9Zx1Hlt+1/lV/jO3FOTojKr60Lyd7Qts/ocPhVN+y0R8bh8vfIDSCQGOKz/t9kDHmp0dBSEDV55t5IrMNk60O+2TUU1uoCGn938Kr/08PinoSstbsdtgf2oiWAencGDtQTadjl7oARnQD4pUWzUVzSRUwj+MwEmNWZsLuMDgGaE2srX34T0HYBxvQFexYe/impW9RZUtosXcweyd5tGDOjLX1cZsWyiBcVGhF/E3t9+EmSNK+bVhiL+gNnqtpQqv+ynfXx38x3M/Gk9l97lPNW5
 e4kcPiL2
 imQv+iMU8TXKmjbGBr2xhhFthh7mIfBmKoY9Rv3XqxorDYSghtYcWC1T3HiKxMNxmNxE4brmugPji6DnC3IWc8dP/rK29YbADPht9sZGODdw+ro+M31HwL+cQvXYnK4NVsq3Lu8TN63EzSN4QopLDK81mh3nCh8p1FB+VTYU61RVm0cvxI5JnBfMB5fX/aCKfe7ufsbnq5kGJak6ZVS7bzu1TKS/AAY3SOrSdur/THBMR3xe8zsxxJQTOkha3I4P4RmCUIm56t03/WKEUO6S8P48hVhWFNTDK1AJDpQ3ZVxIk+808ZqRCnCEUnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 12:29, Michael S. Tsirkin wrote:
> On Tue, Apr 14, 2026 at 11:04:04AM +0200, David Hildenbrand (Arm) wrote:
>> On 4/13/26 22:37, Michael S. Tsirkin wrote:
>>>
>>> I admit I only vaguely understand the core mm refactoring you are suggesting.
>>>
>>
>> Oh, I was hoping claude would figure that out for you.
> 
> We figured it out together)

:)

[...]

> 
> 
> Pretty much what I did, except I felt it is better to change the
> existing APIs. A bit more churn, but in return there's less of a chance
> we forget to pass the user address.
> 
> Because, if we do, the result works fine on x86 but corrupts memory
> on other arches.

Converting everything is probably cleaner long term, But there are many
instances where we just don't really have an address, or the address is
irrelevant, because we wouldn't care about the difference when zeroing.

vma_alloc_folio() is the API to use when we have a VMA + address.

But yeah, something that is harder to mess up would be nice.

-- 
Cheers,

David

