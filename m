Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 084A9C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 21:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E67376B0095; Tue,  4 Aug 2026 17:41:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E18BA6B00C0; Tue,  4 Aug 2026 17:41:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D069C6B00CA; Tue,  4 Aug 2026 17:41:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7310A6B0095
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:41:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F074780303
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:41:46 +0000 (UTC)
X-FDA: 85064909412.19.71731D6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id D41D74000F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:41:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GpnaBe0o;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785879705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2h3LEx1KaIT/loCgvty5FB/wHBm0C/mgl7hraJJXnUM=;
	b=BW52eMEo/sDHQhkasXcg/Ja1NOWNbS2DmXP5t1UOO9qqw1p1uiw0M369p6J4XaDwsuRMQZ
	ODbNPVQOJepUOHKL+3rLwlh38N9OirAzzHOTca5y1bF36yksLKd5SmQfiqCeGNSsJSrsjW
	VxI3S/apZ5MrssGXHdM2zLPs8j0mXQE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GpnaBe0o;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785879705;
	b=7CqBEg08wlGG7dc6oTp9kLOP3sSDoDeA6I4QuiMOflVvFhkp+wKNC4v6MTZriC4GR2mkkq
	CE5DqUJ7Y91qkQWQEoUtK0oRxAFEursOYZSQgQz37t/8MaDZu4iNm4XbyssgKdi61287zB
	dO3MsFtWF9bPa1hbZ/jGVDo41bYJND0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD671153B;
	Tue,  4 Aug 2026 14:41:39 -0700 (PDT)
Received: from [10.57.44.180] (unknown [10.57.44.180])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B4F683F632;
	Tue,  4 Aug 2026 14:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785879703; bh=2Ets6xUSgF2SvIGIzBCZqUPBNHDHIma+VZOjrRyJNng=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GpnaBe0oRUi1e8OuPU/5aYQXeTdrEzXqu0/FDRYf7ykUgZXs+paTXrrfiAVn8Hkw5
	 LMwuQUvxHsifZW4EMq02B8DUyiI19RuVa4iKcmQB7tjvv33kge4/oNppTpQO0LrYrq
	 cT7nX4IefFiL3fVJDuKi78qo87B3182Np0ul4upg=
Message-ID: <de780cc3-8c43-46f8-b8e6-3ddfe93d753d@arm.com>
Date: Tue, 4 Aug 2026 22:41:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/41] mm: swap: Introduce lru_add_drain_progressive()
Content-Language: en-GB
To: Sean Christopherson <seanjc@google.com>,
 Ackerley Tng <ackerleytng@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 "hughd@google.com" <hughd@google.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-coco@lists.linux.dev
References: <4460e252-b6de-4df3-bea8-0368a9d0f4ff@kernel.org>
 <CAEvNRgEUQSju2tW_1zMk2=QmveZNtmkjjCZdqVBgBD2JPh0k4Q@mail.gmail.com>
 <a823e3d2-8acf-49d9-a812-ac1bb2136d7f@kernel.org>
 <edc3566b-370c-41a0-a71d-2e4a0e1a94f7@kernel.org>
 <CAEvNRgEas_9BEV-cNxXu4_wQx8sR2M4_OaW6DEd4=fszALMV0w@mail.gmail.com>
 <60552bee-3326-4917-b00f-5fb7ba3b8adb@kernel.org>
 <be77c2cb-6e41-4382-9d2f-cd299f634196@kernel.org>
 <anCtzQrUkFSSq8De@google.com>
 <99037993-ee13-4160-8c87-b6642faea554@kernel.org>
 <CAEvNRgHYhKACDfx9ZZy4a-TTS4yWzEJt=Jc92=eXxS15LPnTYg@mail.gmail.com>
 <anJbMf5GBe0Pxh_x@google.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <anJbMf5GBe0Pxh_x@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D41D74000F
X-Stat-Signature: u5pnixs1eucub353zfc34xp7ph7em4dc
X-Rspam-User: 
X-HE-Tag: 1785879704-292535
X-HE-Meta: U2FsdGVkX1/B99oNMVQI/LJU7oJ/HmaElVxnEAFDNQif6YPJkC3OvPzRSVxMkTyTLBQ8f/kom+nADwA/GnJu3Z+VsntXztqtlJRHC3gRxM9U1UD8OE+g/cRPOa9kjtCQWve6WNBlcuhKAeHUzqWt7LR2kmvmwg0oaEmydR/h7tSiG3Bz+Aru9jCJffa/Uw/qUdMWSI7R0qLTa4Wi57kLJOoSgMLODJ5ffCZuYQufeBoX3RcqQevyz+DPqvxzmjYISP23QgohMUU2IYPihjm+NOHNo7V05totSbiJ/dgghL6VMmSKKVcKvc++BRFFvo6MjlYNpNPsuAz1BnqPoiZ83JrYiDXVszJsP+/jB8uv4/Gl1bdPALjya1HYfsYcTgbgwD8n/nd3ObWOEwijcZ8vTfRFAAXaPmZDDCInRC+WZcop60p2CR6wYiaJGjFOzxoLk31l+XNtW08ZtMIo4FCKw7rNHAXelf9CFT16WV0MTtzuymxNXusRuArnBEkAaOocR2L/XWkQZ/sxMtZYBu7BKPnm8XF8HLgwNgjIlDr+cFMeoko47yq7WV2IgJnlHQ6wQteXa9iwkqibj/4bphs9HYvFEVWglnvovT6mFbijq5VCT4nCDP5N3vBqePSsRxGFzkJTTsgjv+oYsp9NnEqio8AMrWNYs6khvniXuufOacDypUcFaR3Qzq65jgNZWyBNNfyIx0piQrjQ/4olgtA2/2RPF4BpOIVXq5hDZ6OtHExsR+4NmR6p2rIPfKWz/EOB9ier6l3//7AtkM32kBG8N62m587SLJIbVQsL+7rE1SQDUIS/xf29doLcsawbufQjNLpe5w88Y6mSrSyy4OUVtSXD+VvJqKRwqZsbiBNIsWft3zCkrcYbgrUbrmWrnwUtUEi05yeHyB1RMrTS/+jGxr+zCj6yXlKmbYgjX1hsCjCzB8hsdXJ9uL7X7iA7TbzNJDXmviipGdX17w3W6R/
 U4tnA4vk
 L3xqG8Nx2OAF3CEOhN663xCu0Gs+BdPuy6T0PGKfS26XJZNyRdI7nQVNJKieDCDGPMG0iq/mUweS5jIjM+qxZuypYNLLLEInqq8dvFm/8OcoHSqORn3yL4H8mPU8ucMeym5ps7yVPlUhhdZwPmLLk7RNzPtkOy1/XiSMjE6yb6edZsT6iP5XVNXdpsOZ4pXFeJarBV1iQazoeHP9jSwr7i4cIuo/tEjn1o1f5HzRqFW4ed6vPMS19TgRoUvffw0bhJeoBDzAP5aArEtm9B5Mv0stA16Us5aafALocBWeUHmVzAjshNLld9f798ajqDIjA+tXU1edz042met5ewk2+/KChnKJDry3JzgDm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/08/2026 22:35, Sean Christopherson wrote:
> On Tue, Aug 04, 2026, Ackerley Tng wrote:
>> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>>> Andrew wants to give it some more time in -next, so I'm expecting it to
>>> land for 7.3.
>>>
>>>> 7.2 or 7.3, then I would strongly prefer to base v10 on linux-next (where
>>>> the fix will presumably land soonish), and target 7.4 for in-place
>>>> conversion. Then v10 can be applied against an early 7.3-rcN and we don't
>>>> need to juggle branches (assuming Andrew is ok taking the proposed patch
>>>> through the KVM tree).
>>>
>>> Agreed. We'd also have to get the actual preparation patch into 7.3. I can
>>> send it out and coordinate with Andrew.
>>>
>>
>> Thank you!
>>
>> When we were discussing this earlier at guest_memfd biweekly, before
>> deciding to refactor out a function like lru_cache_drain_for_folio(), we
>> did say that the likelihood of actually draining in practice is low,
>> especially on a machine with heavy load making allocations all the time.
>>
>> I think the threads with Xiaoyao have resolved, I can put v10 out
>> tomorrow. Would it be okay to go with the following from v8, and then
>> clean up later when lru_cache_drain_for_folio() is available?
> 
> No.
> 
>> I'm hoping not to push this back by a full cycle to 7.4,
>   
> Sorry, but we've missed 7.3, irrespective of the lru_cache_drain_for_folio() fix.
> Even if v10 is perfect, applying tomorrow means it will get ~3 business days in
> linux-next before I send pull requests to Paolo.  That's just not enough soak
> time for land a 40+ patch series, even if half of those patches are selftests.
> 
>> and also hold back other series dependent on this one.
> 
> Eh, I don't think there will be meaningful impact in practice.  If v10 is good
> to go, I'll get it applied on 7.3-r1, and will also get an early pull request
> over to Paolo (probably around 7.3-rc4).  I.e. folks can start posting against
> the landed series shortly after rc1, and I'll have a set-in-stone base on which
> to apply more stuff around rc4/rc5.

For the record, Arm CCA KVM support depends on this series and that
being a big series (around 40+ patches), it is an inconvenience for the
Maintainers to make an effort to review the series.  That said,  we are
happy with the way this is progressing and next cycle merge for this
series would be perfect for us.


> 
> And if v10 has issues, then *not* rushing it into 7.3 will likely be the fastest
> path forward.

Absolutely !Like any work, if it is not ready to merge, it is not.

Cheers
Suzuki


