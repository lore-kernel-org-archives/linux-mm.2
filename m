Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48290CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86F376B032A; Mon,  1 Jun 2026 07:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846736B032B; Mon,  1 Jun 2026 07:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B8A6B032C; Mon,  1 Jun 2026 07:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63D486B032A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:14:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0BF3A120642
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:14:02 +0000 (UTC)
X-FDA: 84831084324.11.7928531
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 48594140002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:14:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JI/ED0+I";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780312440; a=rsa-sha256;
	cv=none;
	b=IuC1H3yXTDR3Qps3vdSzngdjObsExlGnc4JigxM3qJIOqINhyYa/QdEctE03AulxBDy0/G
	Gl5w+mDgK21jmnZjo7rWH7vZAnjRcBm3ZVw4dhCAlk8RCUwQwFWHhovWStU5V3mveekegZ
	wCDKOinFY5/UM61sMvCoCn0T8i/2uEk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JI/ED0+I";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780312440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MU9TAz0HXMedTgLQwpQphoQUdyRWB1XQN6t0YBVfU+c=;
	b=7bqE35uy2KRqZ8MQjrVJBSFq7Olx4abcv178jl6uORdOFTT153lQ5WcHCp442X4V62afVf
	p4KndKtZqw4mIBpU6MfTYFg9QpMbdbh/l4V+5uLb340X7wBkxCbKy7OVfFyEp07UkCdX3J
	wfxEmeHcvjZ4bI3YVgUbwObwwikYils=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 820B160018;
	Mon,  1 Jun 2026 11:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30A91F00893;
	Mon,  1 Jun 2026 11:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780312439;
	bh=MU9TAz0HXMedTgLQwpQphoQUdyRWB1XQN6t0YBVfU+c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JI/ED0+Ie/4RvUtVTeagEIBW0222r6wWcagxIo5iAb+ATF4U9PqUYo8PhF/kAnH9/
	 N4J/moLBgYh3DZ9fKmp5qDPXuW+Z14iZrbhXIOaskN9IVCFkZbRp1+mKWkEzO+AAhw
	 PKkoWfULx7CIcCTq9slqn2ZFkqDXVoGrT27O2Ug9OLn65ozq1kN4kbNBsNAt7w8XcT
	 9FDn77vct2dYjJHQ72b2Vpb5cbCYOakXA4BXJx6xIk48K01RIZz4oQ022/nKCT+/LV
	 EvU89ul2BRBAYsd7opuWp9JfjmF9oIGR6SFoSyMEdaRUUlsgq7EgXz7k6+RpHyU+X5
	 6Jhe2Kdi/YLUA==
Message-ID: <06d9b665-945f-4967-9ed9-b06514478996@kernel.org>
Date: Mon, 1 Jun 2026 13:13:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: Lance Yang <lance.yang@linux.dev>
Cc: npache@redhat.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 usama.arif@linux.dev
References: <2024af56-5e99-4799-a586-e9ba756cecb9@kernel.org>
 <20260601032804.96122-1-lance.yang@linux.dev>
 <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
 <616de1a8-1cfd-40b8-b04f-7b324be40bfd@linux.dev>
 <6b11bf0a-769c-4ef2-ac6f-2af38200a6bc@kernel.org>
 <baa0a462-46e0-44ab-b583-c722ad253afe@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <baa0a462-46e0-44ab-b583-c722ad253afe@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 48594140002
X-Rspamd-Server: rspam03
X-Stat-Signature: b3hyonddimbd4j138p5hsgzwhgking69
X-HE-Tag: 1780312440-45472
X-HE-Meta: U2FsdGVkX19oI9A3G9TuaQs1igck5H03XT/bqX6+6m3cNk+O5Aslw+wNC0FzK3zMkMRF52aHh8ppHKVeBY3q6zM6hS2AscRokPhiAZw+z4+e6NEXu3MlhHFB0QuUw4AQxFzJqzCLrhZ12f38NBRBX1X64fplv5nsBXUYvciwufGsVSKhLVBysU+KxZ+OsNYsVcsSgGT2onMFGc4ukhVRdtgTCP1rlF/vArTpV/pJvJpgAPBdhgrJiOaAbaKj37uCmlvcdn2EU+bogHyq303REwDEg99WfQANM4aZPvaTcsqwur1cLtX7Po5lzYpaaYdolijQQlVwBOwKjQ9lhs0BxamO5h7jbIo+dzo23+2+QY3OHUPi3BYhjDGNfW55ckWLwxZPU6d+8oRKZt8zyJ0hJppl0JRwgs7PZO26Goiqa6JAKIkXuG7inPIv/fm2UgA6HbqejD3v39uj+gPi678kl9bGrsQEtAUFCAZD+9dthzMQVudwGjw73/oWyg3ferAAHbzjvLpOwXzmd//m9h1Cx7j/ehXZb0SXA9lIxGAZkuEHNZ2UG9ctjsZrDGFnVqESh57iK0ZzPH/ugmw3UTLLgwYw6JH5SrlI3eR034LezQhaW+twnPO/G8SFdArTHVJufO3uEapVbZ9SbTgDFzU8ym7nInsoLJyLmIASHCx9BEfpdf+8gZVTcGRi2fAc9sr+ka45OAY9H5i8AexERmH5/QDWRPufodrM+QWA7M3bZVAXtoU1Vh9Cm7WsBUZ3IE4mLZP1rK6NOJgE7qkSuMb7iuajyuQi+by2gk/9eeJ6Nvg3N14C5BgdXikUYuGHQia3tgchOPV2ZOiXWxfvzgtfA7fUskJcVM+AQ/lWEfcZZXbQe4cd7HdmLrPbUif+5lXaZ1jucQZ+iujoCkCaCiq5aU5EyUJtm/v9Skw08x4QY4M6KOlvmAbf6nOYxUyKvv8lxjNDU5ZgPjqTXuEk1mP
 JyYkk54+
 5tK94DMHCzF/QV/JXt6dtnk2IDAiOGt/mGFiUw8aP1fDN4DPpZVyb2XJ5IQqtTfxNh64c7oRweP/otJpaPNF3P2RnSKIjya9I+b7MRIJ1fyx8KwVwTBzanAesZp/EVWhEy3U3c1uRmxc58U6Z0cq9uJC8TF4rHcf/sr0vR70+IwQZFrvubQD7emJAYsfKyeCv6trAhWblIjhxB7YxfBAelnFJJMV5RFO9NZGA+3aYpKjFlAzHatHF8fzCyT+hTe5VrYHHDx1pFBWwhP4lg90YBA0VMkRByve4dcYrVFl1GX+e/WFwUlUXEjDUpvo7LxaHhRzPkcec3O3ccY1svjl7uGlzLOtmYzrjrozcOVzw5cNhOrZ9eR4plbcOwmPCddL1tsI+08Jquql2lSITfIOg1J5pMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 12:47, Lance Yang wrote:
> 
> 
> On 2026/6/1 18:23, David Hildenbrand (Arm) wrote:
>> On 6/1/26 11:08, Lance Yang wrote:
>>>
>>>
>>>
>>> One small thing, I think we should probably keep the smp_wmb(), and just
>>> move it before the earlier pmd_populate().
>>>
>>> IIUC, the ordering we want is still:
>>>
>>>    clear old PTEs
>>>    smp_wmb()
>>>    pmd_populate()
>>>
>>> so another CPU cannot walk through the re-installed PMD and still observe
>>> the old PTEs, right?
>>
>> There is a smp_wmb() in __folio_mark_uptodate(), that should be sufficient?
> 
> Ah, cool! __folio_mark_uptodate() already does the job :P
> 
> So yeah, no extra smp_wmb() needed here!

Yeah. BTW, I think we'd need a spin_lock_nested(), so @Nico, treat my code as a
draft.

-- 
Cheers,

David

