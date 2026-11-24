Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17402606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=syQfXiBj
Received: by kanga.kvack.org (Postfix)
	id 35F716B08A8; Tue, 24 Nov 2026 18:28:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 310076B08A9; Tue, 24 Nov 2026 18:28:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FFB96B08AA; Tue, 24 Nov 2026 18:28:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F08046B08A8
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:28:47 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7DA59120D0C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:28:47 +0000 (UTC)
X-FDA: 85471604694.12.B634B87
Received: from mta0.migadu.com (out-219.mta0.migadu.com [91.218.175.219])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2D8A840004
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:28:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=syQfXiBj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.219 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795562925;
	b=Bvsc63ms2D19G8MsZVrolf9iLP9YM3T+eMuXnWwTPHnnsfrNE2xZpaA8bmD+mJ5FvcC9ac
	7YFDDaZydwh/hfILUqr8IYu1oGKuzwa7OkK94qB+4qa1vDPw8vzmKb2JnSj58TBLDA2ahs
	dGpqfaDTiP2oxbghJCIj8BWtRxDzJKE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795562925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bp7vbYZqgnJSbea341jrZg5sveSuhCAR0xNbFY7zOp4=;
	b=mUz1XOnO0jkOrYElHUQqWusD+cAlLaJNROPVWnmPJocWlCNPOkKdDUYV+w/M7jALRqdk8S
	skb46Ezi0xk+soEV8YTZh5TH11R+4ufm5HJ+bChgXpyDY5kLm/3DsxHr4RiOw/RgxtI6WR
	Pr40xiJCGrpVCLEVazV4Ojg5kGLIKhU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=syQfXiBj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.219 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nPjM6DQ6Wy2VgjwnrWH1igbk+eR6QyexaJnli8SHASY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795562922; v=1; x=1796167722;
 b=syQfXiBj57EY+cQrf8V92spq9zo2wnqIJX3uBOnTpFR7q/y/FC1Nz+3Bmn0MnLs7twWrb+7Y
 7ODGDdVK5Flln4Ug4NCcW83SN62IL43KPoRCdmEeqbSLACoIah0XIOcJPhrYY+xrsmpe3XXi13w
 txZvcrxHC7yabQql4KWIjW1Q=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a5687cf46e03fba8;
	Tue, 24 Nov 2026 23:28:42 +0000
X-Mizu-Trace-ID: a5687cf46e03fba8
X-Migadu-Flow: FLOW_OUT
Message-ID: <b69a5619-87bd-41bf-9125-95f17f232c62@linux.dev>
Date: Tue, 24 Nov 2026 16:28:38 -0700
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/ksm: prevent zero-page remapping during
 ksmd-triggered THP splits
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usamaarif642@gmail.com>, aarcange@redhat.com
References: <20261122-b4-ksm_fixv2-v3-1-f78ea7779746@linux.dev>
 <27c7a176-cd38-4e2c-b2e6-ad63b79ffc07@kernel.org>
Content-Language: en-US
From: Nico Pache <nico.pache@linux.dev>
In-Reply-To: <27c7a176-cd38-4e2c-b2e6-ad63b79ffc07@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 2D8A840004
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: z8s5gjafad7ah8gisyabh8uhtoekwhpj
X-HE-Tag: 1795562924-737379
X-HE-Meta: U2FsdGVkX19kxIOJF/QADcEL86tnnBS/oejklLp4D3/EOOls1QIa7mRSPWI05Oq440fZBOAzFoFF9mtCQ2pFlHC66RoiRq0EGgnZT/GYhdj6bOov1NzCfv2GjXv3yVe269uWbQ8+8ICpFLrpMlOhMRKYYS9bB2tmsVtrZ3yw1x1DRIVPGBmiekdkxBuLH3BAyzqVWZDS07zm8qQXYmH0HzDFL7D6/PGAYhKOpxLiCq0onu2VzEHbRJ6HPeRblNFospag+0B8FzsjGZzIyLVir2iv5QshXefsSqadNGVTZiGpvCjs8WB2S2wn12auKzV5MMnpZ1rJEZAZBEtrQJGiLNj/ZXv/kjxBO9cY5GsEral8rhcmdsVZ3i+1KQkb1jTevpdD0s6Ecp3TuBpvrXWp2BlqsfJMwmryLj4OM2lW5B+/EwXdyM9ub0VHtMgqxbYyD6stF21v/B1lx7SHnNRi5y5rvVGdGWeVVUE8uQNdLwc7Ynkmd9dc2ZwuIQsXAGGQb54zfSKLE9TXDhj7+vvwT1hVcDcuVP9DH0fxJHuUHGeSRhwJ1vFlAUMjzYaVK4wnUNiERKJ0rbe1F6Qe7SaHMm2tjaH3LO9Qgu5Ssplf64UFhvoZj2hFeWbNFO1lLjQ1zdoqZbqppLqwRWL0RDq97j4Mt1eHEgXo/qY3T9vHU5dNPwje9yTT7xqzKVIpvNsXKIWQwAVr0MxVN/jAv8KDm1UysZ2SX6rLgFYeTTocQ/p9EmzKgp8+JuncRLdc0FWTEJKZGCHkyg/7qolU/UOLvEwBtP6XAq5hlSpg3Liw4WQWDSo4ClBlA/mWSuc+o7+1s8T/YoULmUvLGXCxzsTccWwVZdcOiSB+g8/lzQYUvk5oj0q1J38an4eLUzMeM/J++z3c2rteL132oRaaiy2dKbXJVX4TzTkRsPPwNIc+83Uok5gEPiSvT6vMtbMA0KpOyHQ0Fa60nW22+83FYTm
 xQaDTqc6
 ficlP/ZZlJj7RIR5Nb7DfvhEhhgZRjvd9ahrdJaQEhpYgvLCWs2ORZIWzqpijJ0WA3lEUTUvQJdeSx91PwoRibB96KwIrSJC62qzGu7DHfoW4XMhGmmEfeWIrwQSRgKzpRCvLoEQC4owfweG4cR2bL/hhWm100zhjyv8oszBOHVNGQBkx8NKmtvwVp0GPxIdWV5Lpr0OwYM44X9C31nr0ZLlgpl9wRNPXOR/UuXVgqzF4TRtn+iEIp/uJcybmFEPRjgSlFDqwA27gMl0ZfEQc815ms80qCHpPaEfhpZUmYDHmits89WxYjKY8sYqhXQo1Ca++j6gBhIXioAEBCxQwbp3k6YfTgcwAW1UbB/jzjYCV5mUTxiPlP2d3N3zpIQv5M0AIAzFBdGYP48tq+0hLUlbqsndyarBBS8ODvCFUFJ4bsFCMi5ATcu+EHXzoBz0eNf/flEbXHvvdqm4Yr9BMT9WjnD0izdpdw/DyAxVUf4TYW9mTb1wo64sM3TQbnJ42r5Wtr5O3Gg3JL1LJI29GUCyYfzA+tRS0oG1p/SwwYJfdGDNUH6a1tI62JgGw321Wvv+TOyvNdUHpqWJueWQ2hvwEeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/23/26 9:33 AM, David Hildenbrand (Arm) wrote:
> 
> [...]
> 
> 
> 
> I do wonder if we wan to make this an inline function to not require a function
> call just to check this.
> 
> Thoughts?

we would have to also expose ksm_scan_thread; tbh im not sure what the 
impact of that is.

> 
> 
> Probably helpful to throw in an unlikely() and to to reverse the checks
> (checking the latter is cheaper than the former).

Sounds good! ill send a fixup once we determine if we want to inline the 
function.

> 
> In general LGTM.

Thank you!
-- Nico

> 


