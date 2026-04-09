Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72EBFF364AF
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 18:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3B8C6B0005; Thu,  9 Apr 2026 14:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13B46B0089; Thu,  9 Apr 2026 14:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A29126B008A; Thu,  9 Apr 2026 14:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 924756B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:35:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B083140177
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:35:59 +0000 (UTC)
X-FDA: 84639871638.24.B7BA8D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 374E040004
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:35:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ayPWzMwr;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775759757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3mNVgSGdbNdDlSRaVclt79VJ6PhUPbY5ouT0uV9aEu0=;
	b=3Y+jK/nt3CN3EXn49XrBytND26arAh9vMrvvtYPVMjOAl48FyXX2pP9v6H779lVXsOQP9r
	6wGvlGyY0dXTWKkDSBa4xkFoazBt/shJ85CaAPB1Jy6wGKdv5tE2l09ialTm/uZAGWq5zJ
	W9muCIz+nU2wPltfx/hpvlmRr3Faps4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775759757; a=rsa-sha256;
	cv=none;
	b=Vmhp+yf8wdHtUEeSUVUWkF9iMujmyVdJPSJvujEb/r3LARs93NGG9DeUL3g3YzeVlfolST
	l6Ng8QIJiLGYCKqqKA/VUeRezkhD4dj9qseiAn+q7JguNuvYvaYFlOCCr5IZ4ecqxENnTN
	cJjQhg8YT/eWBoG5Bc0jD9AbZ11RjnQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ayPWzMwr;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 424CF4386A;
	Thu,  9 Apr 2026 18:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3276FC4CEF7;
	Thu,  9 Apr 2026 18:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775759756;
	bh=C83VW7E8/gl6WDv7/vpndeE32VsJX3FXGM/BP11pjuo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ayPWzMwreOLvA21im9dtVCWWgMMb6FL06aDWSybg0HVRHAbh3jUpJIqIPiqMAiZsa
	 bPsyWiM/RX+f+ocH6KAk70rxEKIKjsRAP7Za2sQNmt+1zIhwx/kmKIrnFKvB6AZQid
	 jFSrc3nQFkJn7UlAECBKAS0BD50Jz1+I1zZGy+/vzFiQoFXvYKlegZU8+J8yjmJe0Y
	 MY/vIk5sg1NQcCTH2Fg6GMIWHI7/uO5us+0gGmHUqZyETzbBV0XKh5dfoRkdGb2CxU
	 s/X0Pn4jBoNdLPvq+MMmMPksj36Y+Q4NpJp/bXyD65TjfmATEpCbkr+fNet5scb6em
	 WmIYE/lstz+FQ==
Message-ID: <2c1fa4d8-d236-4abd-8437-b21d9edad2e1@kernel.org>
Date: Thu, 9 Apr 2026 20:35:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 03/13] mm/khugepaged: generalize
 __collapse_huge_page_* for mTHP support
To: Nico Pache <npache@redhat.com>
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
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032347.232939-1-npache@redhat.com>
 <8a4568de-e0f9-471b-bc94-1062d4af3938@kernel.org>
 <ee39e605-0d9f-433b-9dfa-f70fd92edfac@kernel.org>
 <c4e80668-9018-48fc-883c-5d52a5950065@kernel.org>
 <CAA1CXcA8nE2PZrB4J1gV5v16PeQ7X2AiwjJ3gO1Q8hW7tyTtPQ@mail.gmail.com>
 <2e3f7c8c-c443-4e71-ad60-36c5203de09b@kernel.org>
 <CAA1CXcCNLkdjMt=WXgJ1QYSn9WTgN8FVZDQk8E9P=S54sFDSDA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcCNLkdjMt=WXgJ1QYSn9WTgN8FVZDQk8E9P=S54sFDSDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 374E040004
X-Stat-Signature: 7rqq7erp6c1nqhukfodqpb7ay7uiebmb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775759757-681000
X-HE-Meta: U2FsdGVkX19jML45H5ewRz2ib36nVgJAhxtP2NdvUbHsVoiK5fYbhh1Ay1ezdZbMLRsIbuEeWy/VwX28MrUXWxMrhMzFa8UiPUnaYQ/pptXH5/bzz5Y8gIiUTCDRaCBS9FqU9RXLwV5bDU84OzOS9o/m0X+dzbKPeWL+Fx9diMij+r/BR3YqxZiokD+5AJ+GfxMdNa2bxHcSjl3YdBuLbR/DbfeuEgL7DKTxbiFNGzPMuaKIMH2xIf/3L3tk0XC/x6fDzAOJRSGKPUl/DfGp+2WIz8zqiUuqpqWatof1+LmzdbFJ/H7lqH0HM63DuoUEqMqvNjzq6Lzq59E0X6gpu59tvKDtcomAAFxCxVgmziHdcaSbj9WwFHpzx/Bm1e/+u98/jrJTlMjoXJtJMdnnA23DBVGUolSPhNnVf4VNau5AF5IgajNOXKkNnv1wcD8nm09Y07+3ERfOjwS/xZm3nZMGsswj3EfjBj3UDd7m/Z+t99iNCQeK2ksOUuwzjCB21SihsHUBdLEq9mwolf1P3Oir7c0btUDQrec1xqLefoJbNsSXLU26mlMRyIPb0lsFd+x9tcz6SZox+gUpOvn/pbxDFGD/ZKIYhe8Hf2gvQbhYrB+N1QCwviVgKYE13GnaSlEksBjiQvhgT8/FUsi9cntEHxv7mn/RI2Det6A7kpFZz6/7rzKF+7PAI83jkSzg9/8iIqFRSGRApZBBPKKjxV6jgwPLqwcq1xhQfLysF1ZkhekjCNeUsVv3D7Bh+1CtiPTNs7XOpNtY5J/VsH6tL5JfRwfTo/rOq1pA5W4q0lnuJ0etMMzgsgf7wWKn8X9Ysms7EBB9CFkTNQZBYzGSMrUeqXQr7TQY+3whf7qzmFAALkufydIFRsn2Ned8O0URiTkJWfNFzUj7nb61OS9nj79r5Pf5LNX/xrR2514PzrzfSMAFRJSlVQ3mIPr/YTw3wTDZ9yT92ntbsgnx4QL
 VzdRnlvo
 Uix/brL+ueCRFniJebb3AoyxN4+CN9LqnXORu0kVuQvvlImIaf5cY3IzosN58HW8iZ1iyya85q3vpcbB0HRfeIKYO0lUtpx5N+shxerDRUbi1yKzYWM3+ioDuBqm5i65FwZxQMcCGc4Q6F6ps2EDAx0nju0e2WE3jwdDEax9D/T3bHgCTpx5af3N/Tya2yUktbyb33/KIDQ+nS/mOt8c2Ws67QqJyhT2dHoFfO3m+LJJoK9XjOjBQhVfLMOuVfvHJBmI7IAW8UThJtnFYyQ6reKR58BGHV/OQcGX7Tdb2/t2boOZRxu5g/hmO3tlZqBbLV6xBnAIPts/53F/RxK/4z2pfRfAhlkxFzXtEtwM+/JsrkXsm/5+3eyH+1LjLNsUsXSWJorqQwmKKREXXFITso9C779SBe/1VOXZ7TKAOjjUw3YM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 18:17, Nico Pache wrote:
> On Thu, Apr 9, 2026 at 2:14 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 4/8/26 21:48, Nico Pache wrote:
>>> On Thu, Mar 12, 2026 at 2:56 PM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> Hey! Thanks for all your reviews here.
>>>
>>> For multiple reasons, here is the solution I developed:
>>>
>>> Add a patch before the generalize __collapse.. patch that reworks the
>>> max_ptes* handling and introduces the helpers (no functional changes).
>>
>> I assume that's roughly the patch I shared below? If so, sounds good to me.
> 
> Ok cool! Yeah very similar. I was just making sure you weren't dead
> set on it being squashed into the other patch.

Oh no, it should be a separate cleanup without functional changes!

-- 
Cheers,

David

