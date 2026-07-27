Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E3EBC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 17:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CACBE6B0088; Mon, 27 Jul 2026 13:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E2C6B0095; Mon, 27 Jul 2026 13:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B27316B0096; Mon, 27 Jul 2026 13:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B4AF6B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:49:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A3A51A0155
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:49:17 +0000 (UTC)
X-FDA: 85035293154.02.44A0958
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3201320008
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:49:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IeYO0KT0;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785174555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H01NrCuzhYN6GF6uhnNDmJjIoKVi3JaIjksshzwjifs=;
	b=c4xudnVL2Hy/Sg31BACxSJEoiv/dRHQ1UoMSeaGg8rqfDPmqxnPvQwZCNM3GAdepaK9S33
	qoAulrwE1HmbJMZV0PcSlmg1iZgDkJGZ3Jah637003GIsBAC8i05/kThBHA//z9+ciGkE6
	8G8rtoMk9XDMRCXADb43LrgdvnFnCbY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785174555;
	b=GhUzw4ENcoIxcut6jTQo3ecAQMoSg9hCJ8LetrPv1vJCD9Py6Rolp6d36D3w1fv3ssJhJ7
	Ib7rnTJhlCPfNfJcnox66RkBLD8rblCxiCn2GOMg09pJIVu/4FIR8vjsbVxPzPA2gFPi9X
	F8Xy+qFEhZtFCCDesunnOxfTjVWZfgk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IeYO0KT0;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5417C41B0C;
	Mon, 27 Jul 2026 17:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AD31F000E9;
	Mon, 27 Jul 2026 17:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785174554;
	bh=H01NrCuzhYN6GF6uhnNDmJjIoKVi3JaIjksshzwjifs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IeYO0KT0SctMH51xOZU7pRvklsBKJYhY00KwUtctIjeqmUFhr7XT9MM5mtG2tbPHC
	 CziSKojecODvhUGUua6JLKUSa+NRtzQ+ssXCL6ohWdsq2q/iy5alu1f1LBqkHbXdlb
	 XNuBCLpcjFp2t8tSFPYMv1j1/4Ji+0ab9iP6OXj9uvye+7N68bllI6+9EJWRTJQhzt
	 gS307vRLTob9+Aa4ucFerFvHhfFE5TBukEcLljN9syXYnQUzug7tx4S1JlqZPqol02
	 bpDHeWvTrG1EDi2uT9gvTDcPfXmHMceXjPvr7hXTQ+av06jFsogDgk+cFp7j8PNxgd
	 vecS4ZkAmTMzw==
Message-ID: <2f0eded6-5885-485e-baad-01d13080dc76@kernel.org>
Date: Mon, 27 Jul 2026 19:49:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] selftests/mm: make file helpers return errors
To: John Hubbard <jhubbard@nvidia.com>,
 Sarthak Sharma <sarthak.sharma@arm.com>, Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260716123226.197736-1-sarthak.sharma@arm.com>
 <20260716123226.197736-2-sarthak.sharma@arm.com>
 <b66c233a-7956-461a-a3d8-3421c76c937a@kernel.org>
 <004e11f5-ab21-479d-80a3-64ab89465b85@sirena.org.uk>
 <cefe62b7-0167-46c1-9fe3-fe7efee90a7e@kernel.org>
 <cd539861-5f98-4906-8e36-f2a5a70687a5@arm.com>
 <4ad4c2f0-aa6b-435d-b649-a8320a418730@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4ad4c2f0-aa6b-435d-b649-a8320a418730@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3201320008
X-Stat-Signature: n6qeuxdu9nxqqq9grhgrk691j9uzk8et
X-Rspam-User: 
X-HE-Tag: 1785174555-662893
X-HE-Meta: U2FsdGVkX1+Ar+WEG/qBml4B//Dfx487Yodpy/SfuXyeGHrj/qBrC9T956a2EsiiIQHILP3Su+Y4UQF69wyfkEOKpL3G1GKGD9vju9VpvVZ6mI5hXAd3V4AsFbrB2QwNDwbTltm1Zc69P7eyNhyT9FBnkPNFPutuIrKv19IN0Q+KV1+dmxZRtoa32+A1k8UOeeL7qjinik2IXcc6bhcgJ0cwEmGNu85dWX9tANviTCScU/qsYwKhPD+upFxWrxqtnPbtE+LP56cE021vIkfK194rwI11ZG0l/g5aOkA0IPoos6Db8whFyeiCYlOJJMCA/AY8+J2RposWRxW5EmU2YOYaRYt4ibHG/LBtfh5OujXf23nibxAr1vUbX10gfMiKwNjs812f7NxhOOVszaeWv1d/zsHVclZsvTBdQBTjOnoZVss0yxP2zaljJqc2JAuoyJaV3M30oEYBXXBKG6KzqOPvs9NeOWz+1cCTRg2dJORiNE82ckGgIREa8jnnHo3t6lTFTMBdfH6VLVb8L4Y1stzS1N0cn+RDH1Tsw7sy+oO6tw/eQvVQKOcu97JHdj67qZHDbUAwyALr0rV2LxDN552bH8v0bubBuICrBxI/crvDJMFq2VrS0sxaeJi9OVjJAe8fbndzwh5pJJS99GhmyabjPWUsauelHFlilXx0mOA8aE5DoXWC3oq8lkfNZiDLmXRtUUNmJhA4V/NlbOjOTznjdVFvhSX5yz6/2yIOay92a2ddvXNqJhd19JmgC6OHc8JxHvO4uA5SMgLCDTPmUndQ4HZ1JwUxCBogK17R3KWMajmLLArC4Kf46VOXjR5r7sw3xkX7iqneGdjo0nW3UzTQJp43Cs/Ka1zICWJqmgjXRuxVAwaryTQcE3gkZZ2LvVUYVFB3EdUgxoMZ0zNT/+MQ3OFMRlcTA8b8jckhD8akobcMeH/0HxkT5wcXEmitpxZUzEY/fUPqqrEc6+E
 quueONYC
 JwnoWWic8YPgrWf3K3d9ks9J5AwDoa3qy1b7tm4TxDtdL7R7dQiW9ivrPWKo5lCPuIx7zWumiz7BI0dIwUdG4U/7Qng7GKSMb2uC7HkQUsASmXWHuQpUuI6xwCLUk5Wmsi1bPtOIfJ2UpmkfEDZmHTKmiEmsTW02Pi2MyXQDhIT745mW4EexnJwZWGc/yHrJJ/LbIA8VMzGxdRsz03LtkqwPnnkHfj5C6bVb7t6nYMSsGaxgnB71pvb5XSFjwc57xDGyDIzkxnT6LqwnOGEqGKyi23XV+bEcEF2cR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/26 20:57, John Hubbard wrote:
> On 7/21/26 10:24 PM, Sarthak Sharma wrote:
>> Hi David and Mark!
>>
>> On 7/21/26 8:24 PM, David Hildenbrand (Arm) wrote:
>>>
>>>
>>> Right, and if we want to move this to tools/lib/mm later, maybe we can just not
>>> print anything and instead only return expressive errnos.
>>>
>>
>> Yes, we are not using ksft_* prints here because these functions move to
>> tools/lib/mm later in the series.
>>
>> Printing errors from the helpers was suggested by Mike [1]. I also think
>> this is useful since the diagnostic handling stays at one place, instead
>> of duplicating it in every caller.
> 
> This is a common pitfall. In fact, the lower ("leaf") routines, *especially*
> library-like functions that are called by disparate callers, should be
> usually be silent. 

Yes, agreed!

-- 
Cheers,

David

