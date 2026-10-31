Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0A77606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=en+lj1NQ
Received: by kanga.kvack.org (Postfix)
	id CF0CF6B05C1; Sat, 31 Oct 2026 05:42:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC85A6B05C2; Sat, 31 Oct 2026 05:42:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8FC86B05C3; Sat, 31 Oct 2026 05:42:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9565C6B05C1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:42:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A2261C42F2
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:42:31 +0000 (UTC)
X-FDA: 85382431302.12.D52ED73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 629FF20005
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:42:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=en+lj1NQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/PCDHcUm/I8NCWuhaHFB37jNQYROPtkNduDPTlhiyE=;
	b=gUzROtyYLy4JL2OW2j5WIlk8l3hfjgYFDcxI7GBCNeVkM/XPhbVZXMqhdhMtFGmgPfQEYa
	ucgqB8T9q5/sjbQWXeDBeNRElAiOX4qYuc184WC6TyKS4GS9RsrVtdgATpG3xpkWFE1kk2
	5lCQNOsWZcRfcT4uP3GjrrD0AipVjGQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=en+lj1NQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439749;
	b=j2H2dDB4unVZa5pn2MvREjjNYbyp3SHGCjvx4P2BM3rpdjeRY4jrpnnSRE39e7DwjmVn11
	ybnQ0kBwGuGRX6joj7wtz8j41KOFZjlZyI4YjFJn8VZdfQBHrjUsfb4s5nri+5yI7joFTN
	LQXT6goWwijFoMM1CXCl+U0iTDVnWRU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EAB6F600DA;
	Sat, 31 Oct 2026 09:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664441F000C1;
	Sat, 31 Oct 2026 09:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439748;
	bh=i/PCDHcUm/I8NCWuhaHFB37jNQYROPtkNduDPTlhiyE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=en+lj1NQyU2riV2YMG3OrBAZImNntuSsETLs3TvxmI0ve6b5krVTdewONMfFCpdg1
	 lKoBQo+6FLdXvJoi3OYuNi8OQDUAm7//l70JQ1u8ENmM053tdaY+Riek//GGNSS6LO
	 wlbG+r3mrA+oBtaF+ovFjO8rqp8GXZKRE5ZRs+plwgDlHn+fpmWV1cPz54HaqreYST
	 wIeb7uyyLB5ACr+QNT6OG1vDZm8hBIQVi326j5VK73/4bQyoqTLOQi8PYovn9HOy52
	 Ah0MSUR4c7oOamuxxSg3ppzUIT4s2Y27x7vRJT3VUnTfFxVxKTFgfLFRBlHJcqduoP
	 qIQ7PnTr5BnRA==
Message-ID: <a704d458-ad60-43bf-a0ce-3b128b218d88@kernel.org>
Date: Sat, 31 Oct 2026 10:42:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/47] mm/mglru: don't use stack pointers when walking
 PUD and PMD tables
To: Lance Yang <lance.yang@linux.dev>, muchun.song@linux.dev,
 kasong@tencent.com, ridong.chen@linux.dev, baohua@kernel.org, sj@kernel.org
Cc: hannes@cmpxchg.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, ljs@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
 baolin.wang@linux.alibaba.com, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, kees@kernel.org,
 peterz@infradead.org, jannh@google.com, pfalcato@suse.de, hughd@google.com,
 pasha.tatashin@soleen.com, pratyush@kernel.org, willy@infradead.org,
 jack@suse.cz, ziy@nvidia.com, riel@surriel.com, harry@kernel.org,
 apopple@nvidia.com, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, usama.arif@linux.dev, kas@kernel.org,
 matthew.brost@intel.com, jhubbard@nvidia.com, peterx@redhat.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 osalvador@suse.de, minchan@kernel.org, xu.xin@linux.dev,
 chengming.zhou@linux.dev, chrisl@kernel.org, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, youngjun.park@lge.com, gourry@gourry.net,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com,
 jgg@ziepe.ca, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, josef@toxicpanda.com,
 stable@vger.kernel.org, usama.anjum@arm.com
References: <6FACF8FF-F943-45C8-BDFD-3AFB5C060E0A@linux.dev>
 <20261031055838.60138-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261031055838.60138-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 629FF20005
X-Stat-Signature: 1g4w15uix5y1u7pjscq8kok4s7b4gq5a
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793439749-73782
X-HE-Meta: U2FsdGVkX1/kwnBS1q28UKSjg8N0wdeMPO6da787DbLj8YpXvH1AmKuyIBU/SxOYZtmcpUD52n5grqsWHVogFWNX5AD071QZM2A6axLvQEc1rqcLj8e21k0+kwP0wwUiroT/ATy3tLfgpuQXmtjSWMkF8o8iYlrYd4VCSDAoCF5RcPxZZbf58a4+ty8LjW7saP7y/5A9RKIRGo2t4rt6tI2F+1JWDS4SPsqr5FjW82kAef7YGb7aVMNthLDcZQWkX7zlMeSWu8tSCJl4EOoIhm53uGCCxh8XBKeJanCmrqNzEbplRvivOFch/8I0tm8new5Z11joX2MP7cqloSvZ4YrhfCFThH1oovhfswxe4wTQnL3R8yEEDgXuVZLhnvy/+kc5pHnkS2R13DR+IK7KJTTJRvR3uf/fTR5DmyO2s5ihL0jCzHih6Lf3d6FHimJB+b8YhjdWZuMhIoug4XpJBMgd36654quiMjcrbDBBRj26gCEGqOvUPnbp0gCuexIY0BlwwVfoJ6nYhledIRy+99uxSF9FTg6cX6h9ckPIN4saqB/KcYUSq9br1Z7jH/8xju70P9pVvTuLwozKXVQ1z2MYjtFldLJWnFshPg1v2PUENiRLSJSzM5jf/O/Nmm+hVYrLero3aoGXfuCk4RXICfmRs0L+knz+XHU2fze/BOywb8euVjlIbE5OFoDEoLI0vI6jwFcKzyuoUEqosjD2/rNFOrnqn+AHfiObfFZHic/FfP1varTJZI2fBCCN/OAA4n8QxPt6HbrZl6CutRpLdKy6JYqrc0cCnShoCXlCs6bwz74GosKJw4PpTTJZPH/c2EktcUigqiilOV/bf2B0JV9zwtXb1nIcjuKETY8jKTadwgyzeyerfZcVs6qJU/qPYrkFSaLbTlVlrxPvR9hhiJ418YyaWEKu3XcL1GCcPrzr/aN2/QrnggAbBKEfPTs2A+nsGPURhj+9WBQnz4E
 vC2Z+T0p
 TMSkZtuwKfOivMgzCsMKApHCVmD6cL0JFL2koj2fBsx8RorJ6DEePi/XEft+qs6/syHbEd576Yxlsa1HA98DRAeawTMsh30ZYh5E8igbK29e4XHh8DTsexq3/N74RNvhw1jB55bJiHpQsrKN//MdRxsv9TnMT1qh/bal93+6ZD6lXmib8jLOcwj0m02BAPQUnjEYXchkSY5Ra7KAEDxpxhhXZglOvVbKdB0tdJALKwFMsbFH9x3xmBbKYy3ESSG85pQniDiFknTxJpEJ+bqU8Tf0anMj0XnCvQxsJ88rJarRT6qSYre/CmKiymwsVDZ7nDWzgJMMN8wk7SzQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 06:58, Lance Yang wrote:
> 
> On Sat, Oct 31, 2026 at 09:46:37AM +0800, Muchun Song wrote:
>>
>>
>>>
>>>
>>>
>>> Agreed. FWIW, I think Barry Song and Kairui Song would be good candidates
>>> for the maintainer role.
>>
>> +1
>>
>> It would be great if they could take this over.
> 
> +1 from me too ;)
> 
> They both have been really active on MGLRU and doing great work for quite
> a while. No doubt they'll continue to do so :D

Fully agreed, we really need some people familiar with this code to help
maintain it, and Kairu and Barry have most experience on this.

Just a note that I also don't want to pressure into such a role (which comes
with responsibility).

-- 
Cheers,

David

