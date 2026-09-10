Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C603BC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC9F26B0092; Thu, 10 Sep 2026 05:15:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA1C46B0093; Thu, 10 Sep 2026 05:15:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B6C46B0095; Thu, 10 Sep 2026 05:15:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5EEF36B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:15:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCC531C23DC
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:15:13 +0000 (UTC)
X-FDA: 85197293706.11.D471874
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0E10640008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:15:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DKBE+jV5;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789031712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xvdr6aBrr3NW0+VKdXVqJoJPkTnZau8BUc7nDTK8Om8=;
	b=06wI1YWNSqGVuuBRjNI5KRWA8QO6H+zB6JTnDtCP1cWbI+7uUkd/H58OzUcA2grpYHMuax
	gMQaj5eIEKgoiflK7gxdg9GXaYc+zfx5KW6dPiPpdGrKa+L6lUY2gGg5ZXbt3P27LzRqIz
	OZMWA4fakg6mGQtUMbOLaCacnHVmplI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789031712;
	b=it3yCCK0ddCgwd5/9B+yuI7uK8OMR+erPAHv1lj+y28KBZGKDFdhInDkJbH3BJL4hQuOIe
	uErUuln8Z2m4XOkn1viww3AOOc8dACVSqIoUyNhwDcMkSw/1GQkJZ1NnaeeBWTtOc1fQ2G
	8+Qp5JG2k6G944OsnH1HndmDcT5QTmY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DKBE+jV5;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CA32600D4;
	Thu, 10 Sep 2026 09:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691F11F000FF;
	Thu, 10 Sep 2026 09:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789031711;
	bh=Xvdr6aBrr3NW0+VKdXVqJoJPkTnZau8BUc7nDTK8Om8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DKBE+jV58Feen3qb+8pVGNdW4Mh2Jbn9vbS/1rTFybOAtOcLn9OHKaspPdWYX2+aq
	 0ENYp04ugOo1z+ccGmKYHYmsKhD8vQNrRg1oNXuPdtVoCbYsYr06vb5WgjoiST3OVc
	 AylqoSykdy/LrYaLVX9QpuDWSPwOLZocjAV/F2bGB9VmYsyxyNeh6oqkUqO+Sa14Zh
	 y5ror0yvSrPaJNbmbdscJVuSJ0NGhWo4sFAlnknnfEvLS7EAHUJHRG5XLD58dcmqAL
	 oVIWRxpfGjOyZ/dBzugZZJwPN+TP70JryTiP4XF+AZCj2zkQHLn8lDd1mofK+Dh0iA
	 s1Hju/RFgOnoQ==
Message-ID: <18ab9827-9e10-4360-a1d0-3b25d86a71a9@kernel.org>
Date: Thu, 10 Sep 2026 11:15:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/14] f2fs: stop using PG_private
To: Chao Yu <chao@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>, linux-f2fs-devel@lists.sourceforge.net
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-6-6ae22f9d9272@nvidia.com>
 <e5792e81-e8a5-42e1-aafe-58dc603f4968@kernel.org>
 <7e11c56d-05e6-48f0-b5b8-b4a0e18ddc1d@kernel.org>
 <520b6aca-b515-4720-977f-1adb484f2e08@kernel.org>
 <d700c4ea-b54e-4195-b124-3c89177ee49e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d700c4ea-b54e-4195-b124-3c89177ee49e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0E10640008
X-Stat-Signature: xyw6zuezzzwbzg7z1f57wauqnkzdeybd
X-Rspam-User: 
X-HE-Tag: 1789031711-113609
X-HE-Meta: U2FsdGVkX18jPeaa35Gzc7y1g1XFMF7uPYTsx5OPJcxCjiOPktyhYP7ZqVm17SMtjc8PqZQlITqFHuJOOA0BAL0YFPJhAxKpmrfbbbDrWxPHqVgQTSE9zreucp6cLjjccaleADTtwkmJ83o/biTP1YY/1wpBF+fW65jrTTkQFLV9k7ah3FmvI82N7jDGt5tUt2uYcYcDUrsekwm2vC5SgFIcTwF6fv7kRYLE/KSfrLcJ4ipvM5kw5N079/86B4IhubOvpBGWL+mX2/aKlW30Q7s8LKDy+r6vinIsRFQp5PaHu+l0G2iokrPqSx549VmY0YRPUFY+LkI0Rh6pgLL8Gct0KRaBjU3VaFQqsFnPRbY+L7Und6fyWcNS3ZNKqYues51fjyZHWYZb2/YLm4gbOCan5rx5ww8PVftXPkwj6CfKk5NkWqCcb615FHt/m8rDCnLSxSQsk+lmM8e2SLz3NSoay0bV9GnDtrY0PRDGqBQYs6TEKga7KPMpMSDLDDavIASd0zdYn5FoIhxi9ONaA6Ym4TJJwIILd8CSRnjA7EqWBvQEufNjzPujB9f8pwPfxcrsiRVEHsQn6OlPqmlCuLBgJ2pfUeAdo5jZHQo5H4IvagJ7NrGXrOQKjnzEGOicC9COJ+HQ4Q7G4PdSPR2s0vDuUj+6f8IXwTRxjXUw9hfQPQGIkWWHy7ekDp28U8Qb0VKyrFfyEN1ghicMCUj3h/8egcjl54re3Of3cup08WC13R9x8P2PYcys9uEk+4TdE7OJypvPadjefG4XVgY4QYCjrN5HdqDUIGoIhKtPw3eE7fOKBIntJQ9AB8lp6d7Ys6uTXKPcV/iUDXi5x4BIbu9V+noFRL39sPUiJ+Hlfti+z779Lc262Dn8P3g1KbatMVCraFsA9mikc/avQYXgN2kXnmBlNbxFM8FK0jxvUEz/NCHfzp9kUvtQNWyFsrHK1enlFFfeMTyGXCqeXgi
 r7HGdiOp
 SMn4lAFgInvB3X7uinBA1Cwb/fNrkBvqwc6eFp0lQMPVz6+WXGI99R4XOG1xz5UeVCxnK+JHzljG8Rhby17aL93gHnCSvncSSkh08DvDuaVBkdz6uNlxKgs7jzLC0ULQ2GQe4DcZNrVoATpDVC4vh5biEd6GP+L4IxDexz2hvNUVKvaoYDP0KHASwzPq5Yyr7rWlBX/T4RElOiShskqoZY1SPNcMyJa2CSOMUBa0xLzCw/nBRgILUzij2AVz+1u/ctgywnHL5UbkokznY9gY3OpmS7mvi6YeClKkP2RFOSAjzO8KD+FoOjqmYhs0lJi0MO+WxwX3avjb58qA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 10:43, Chao Yu wrote:
> On 9/10/26 15:34, David Hildenbrand (Arm) wrote:
>> On 9/10/26 04:41, Chao Yu wrote:
>>>
>>> David,
>>>
>>> Thanks for the patch, at a glance, it seems fine, can you please send
>>> a formal patch? then we can apply to dev-test for test.
>>
>> I'm hoping Zi will drag that along as part of this patch set. Is this fine or do
> 
> Oh, I see.
> 
>> you want it sent as a complete standalone patch (will make merging Zi's series
>> slightly more complicated :) ).
> 
> I think sending as a separated patch based on Zi Yan's patch is fine, since the
> purpose of this patch is a little different from Zi's one.

I'd prefer this patch over of Zi's patch.

> 
> Note that: ("f2fs: stop using PG_private") has been merged in
> https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git/log/?h=dev-test
That just a testing branch, right?

-- 
Cheers,

David

