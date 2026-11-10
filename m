Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5E53606A9AE
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PvPHTv4u
Received: by kanga.kvack.org (Postfix)
	id DA62A6B05B8; Tue, 10 Nov 2026 06:54:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56126B05B9; Tue, 10 Nov 2026 06:54:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4C6E6B05BA; Tue, 10 Nov 2026 06:54:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9FCA26B05B8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:54:28 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4818D1A03B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:54:28 +0000 (UTC)
X-FDA: 85419051816.10.11FE4C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7BBAAC0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:54:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PvPHTv4u;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794311666;
	b=kpH17+QMNG1Pyt0CCiIhfarPdUKBYb1WgcYA7pFd4RGNMznCSXGXV30h+WwghZxlqiRaYu
	phDUfYjOFdrule5Mjtjtpwaw834gtA47oEuuZrqAFEG9lhEb22+ScuznGzhgZQVXeAxTcO
	5oGQLWhJ7dWklrfuQ1SwAZgn+qxhBxw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PvPHTv4u;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794311666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WXfVCVuf8uXYy2DZQnojC5ljvRy+PP3sdHEmJdjQAk=;
	b=LYbDpu4Cr716emkJopEHbj/CuD8vUiwX8WF5tkzqaar8gLnqpprzsQznP1+CXr6qwmLJWr
	Qww3Do9H6mp5tjy9THGCIHGBx8BXP7K7rvIDVc7f9kQ3cqJmXSXXTHgMSk3Zv7wZLP8VJe
	flg2Sa1fkMQ0KBchADruoTf4rxEBOcg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A86E046A38;
	Tue, 10 Nov 2026 11:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC03D1F008A1;
	Tue, 10 Nov 2026 11:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794311665;
	bh=7WXfVCVuf8uXYy2DZQnojC5ljvRy+PP3sdHEmJdjQAk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PvPHTv4u5XDMIkz+tNdsAkpxlI2GSaLdB22KQ+CkbqmoSCOTtaX4li1Civgvbq8Da
	 5H3WjEDe60cW/mOlTXgGA+4yAPTafLe/cRIi7Qh3X13H3heCRD8AMdPo68Dh60az+Z
	 NAYSda3bbR01apCSJ8seyXFtpysD41xR0nnbz4luv02FolbQOPXoR9jPsBYPpuujY6
	 n5B0C5fCF3nlI1iLxaQLsLH6ViDBFWsAJX1VaZVAbhDD1+ULOBrrIwHSz6HNYboTZv
	 BX5keLxP55jUMWXuESmgjQV1fame0xkhVbDp/iL+5WeYpPiYzWyunb5LynRubfkCpQ
	 2uLi4apjTLjRw==
Message-ID: <c092dbef-515b-4575-8669-efef8ebb6e29@kernel.org>
Date: Tue, 10 Nov 2026 12:54:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH resend] ksm: add merge_only_zero_pages to merge only empty
 anonymous pages
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: g@dgvxl46587.localhost.localdomain,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Lorenzo Stoakes <lstoakes@gmail.com>,
 "Liam R . Howlett" <liam.howlett@oracle.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, Huan Yang <link@vivo.com>,
 Wang Xiao <xiao.wang@vivo.com>
References: <20261106034841.233085-1-xu.xin@linux.dev>
 <899b1b2b-4f6c-45e2-abd6-a333ac77b23b@kernel.org>
 <avEkWyGoKsVlCCRG@dgvxl46587.localhost.localdomain>
 <3e126b7a-d7d9-4a8c-9c83-b6fbf5bf1539@kernel.org>
 <avJ0p8ZfjZc9EewW@dgvxl46587.localhost.localdomain>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avJ0p8ZfjZc9EewW@dgvxl46587.localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5wy5npb8nrnxwgdo1uka7i9e87m49yy6
X-Rspamd-Queue-Id: 7BBAAC0005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794311666-8661
X-HE-Meta: U2FsdGVkX19B30Cvf3coUtasY8ZFPYjxRJ+ZN2cCfoLimgoMaRL9pdGSu5UxvOFeeO2XRaqofMmc5osvuMI6/yywiieqnHvWeAhi2FqRnVYMmHBlwStTj7jLrwNQ/VuU5DH0duDT9wXVDcFiesQYyS80t8QyvYBauCy7XFx0q7etwCntBd5jsUUAHd7/Py989PEjdeouVffwa8Fts4pUhzJLGYf9yR8Lc/ee/qtkTq4QqR91AkvJEJImdnixdzw+rRwn/cmW8SI0oMQnq0CI7vn1TWRYoUwgTOVGhCazTi/v3XBOAzU5A7jy4EciuIhEw90lLMVGhjXp2oZ+04uJuv9M/ZrweikdOgeUpUSpsyPlC2EKnJoWXSgD4Q8Z+RrcwCh9lBHPngoG85T+OP/9bsQRytXeuyjrf8IRlwnrt7ROBY2C/M1Z9n3Y9sVXlhmVxHXmkMtTzPfReNCA5CzC5SXiTHK0kSaNOmvS9r1m5UnLPnW1+I1XemmXosTEtRSbS0Ql5v9ULRdgjrpOoqV1DIDRluS052bJg0I3QZIEqVMPoBncNEC3ABW8/77Mc7wWmhRKYAgUgEj9JBkNqrVi9oII16jAv7XBht+kIJ5A6GYgzT6rwLOwqYG5X9g/hYdSt2ufMIQDLhY2ivQb03Oh79ufhiJzhNXMTx3Faenn2XAhzf1LLN1ANTpofiL1HSz6lpOtZvjJ42PCueyKgKZBM/+huiLfObV20Fm3beI/6UsxwmOQA6qz4lXUZahyBZOBBhLWyJRy6vK/yvptuGS6JOFL0as+RoOTVmyyT/x5LQcukGNJOOlZFNWCTasYC2gs6TzHRTwgjAhBbzx4B4xTMe7BFcPWGKG7Lvyxh7uINQz8MuF8gCyMeHMbuUs2NIefRVeZgOrVgd4aw+f34YCcI5lVhA5U4TfI/g0R5s7wkV39qF2vKKnt/KVg19POOVW2CWdMUeWOHVgFwwh+MEv
 hxzvfU13
 +Y1vRayimwXYOIj6nEdUrZ/t30q6kXp7rAKGYaKJhvticOTsmYpkWszXzvhPpB4vOaztt1ZERYYwxgtFrYqI0LRGaKNDORIS6anhkJAFZ3H/zWiy0hCx/0BRgAKTlHNCsmYWzINuADeCZ2msv27/VzauxOcGXuGFM8BQL0fjgG1rScgnU2pnaGmNMWdfhEb/o5C2oqRFHN1pTi0EDQiaw7Vvt8nAWFDlP8bGpQ9+rTnkYestm2U2+6IiXc3Iasw0SjfzROIUPip3NydZDit2mu6MEplYnH+A0XgLhoNG8lGUlSPqspe0YjwmvPeiftvSdKuWlOkiyRGB173Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 02:34, Xu Xin (vivo) wrote:
> On Mon, Nov 09, 2026 at 06:41:39PM +0100, David Hildenbrand (Arm) wrote:
>> On 11/9/26 02:39, Xu Xin (vivo) wrote:
>>>
>>> Ha, fair question :) This came from our own investigation. We were looking
>>> into whether KSM can actually provide benefits on Android phones, and this
>>> observation came from real-world application workloads. To be fully honest:
>>> I did use an LLM to help polish the English wording of the commit description,
>>> but I carefully rechecked and verified every sentence myself..
>>
>> The reason why I ask is that this effectively disables most deduplication where
>> KSM was originally invented for: VMs running the same kernels, libaries,
>> executables etc.
> 
> Yes, it closes the original scenarios like KVM, so I wrote a Note to say that in
> commit description and Documentations. But it opens up some new application scenarios
>  — scenarios with high security and low cpu-consuming requirements, where merging
> zero pages alone can already bring benefits.
> 
>>
>> So yeah, disabling most deduplication shrinks side-channels ... by disabling the
>> core functionality of KSM, to dedupicate pages with the same content :)
>>
>>>
>>>
>>> We still keep the stable/unstable tree data structures, but zero-page merging
>>> does not participate in the stable/unstable tree search path. One more reason
>>> for keeping them is that merge_only_zero_page is designed as a dynamic knob
>>> that can be toggled at runtime, so when it is disabled KSM can fall back to
>>> the traditional full KSM behavior.
>>
>>
>> What's the memory overhead from keeping these datastructures in the
>> merge_only_zero_page-only path?
> 
> In the merge_only_zero_page-only path of current implementation, the main memory
> overhead comes from the ksm_rmap_items for non-zero pages, RB trees of stable and
> unstable, and mm_slots.
> 
> If the allocation of rmap_item can be avoided (following Tu Jinjiang’s idea), then
> only the stable_tree and unstable_tree remain, which are basically empty, and these
> overheads become so low that they are negligible. The mm_slots are essential so can't
> be avoid, but won't take up much memory.

Okay, so that's the right approach then.

-- 
Cheers,

David

