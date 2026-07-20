Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5CA7C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 02:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 903626B0099; Sun, 19 Jul 2026 22:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B3A46B009B; Sun, 19 Jul 2026 22:39:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4456B009D; Sun, 19 Jul 2026 22:39:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53C316B0099
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 22:39:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CEB2B120751
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:39:31 +0000 (UTC)
X-FDA: 85007598942.03.C443AD7
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf30.hostedemail.com (Postfix) with ESMTP id C22A480003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:39:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jRIcjr/U";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784515170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NRngtLPWkQ7+WF5w95aCgY6CpKHiVyh4kOZhXjYGgs0=;
	b=ab/lmhlJDPeQQm2zN7e1rBTE9BGfXKI0g8sAwNuqCUWbcjzrJ59loSMJXC1NlnE7uUm/rp
	u5OdtRzKBwSpzNVF7fVQTUDFbonhlmGu2VqP6Ls/OXPYTqx2F/ya3RsrSI6US2s1wSfkuj
	ErGFQIplksO7wdUBuksIGNLqhn26jDg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jRIcjr/U";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784515170;
	b=RLkC+YBNgbiXlb/YSR8NRMJtKz5jSyOCnXhFpuqP2AS8Javaf2gCiNIGw6HdOL0EkmVvst
	pcybBAEsI3chKzP9WIhTc8BUv6HwCAd61VFIgiqF6Sd69iWoVQR6x4oSskGLaokI1dvl1W
	ou6UACaOQqDASrng8lQ8RcPDRM86a+0=
Message-ID: <89050232-0371-48af-9a3c-a9ab2b535c15@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784515167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NRngtLPWkQ7+WF5w95aCgY6CpKHiVyh4kOZhXjYGgs0=;
	b=jRIcjr/UmTbgoPYTP9G2unjyvVNk+HGHShAGAuNuOPyqToAyb9ldEWWyq4pfmd+fR6DW51
	dEse5qnVORb02DfEWKNr2UTDHSh/ghhY1n3EoY0+ncdCU42WtKV0oGKhD7NuncMfpTZKn9
	gm+lvAChMqskhcRk/4Xk5eHb8askwK8=
Date: Mon, 20 Jul 2026 10:39:17 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/9] mm/page_owner: add MR_NEVER to enum migrate_reason
 and use it for last_migrate_reason
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>,
 Kieran Bingham <kbingham@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260714015117.78351-1-ye.liu@linux.dev>
 <20260714015117.78351-3-ye.liu@linux.dev>
 <9e0db1c2-06ca-4dba-8fb1-552fab91cb02@kernel.org>
 <037d58c6-de55-4b69-bb71-905e03985657@kernel.org>
 <9e9345c8-30a4-4f78-ba55-d7fa073b82d5@kernel.org>
 <2911979b-193c-4cbc-85ed-f1d04a9977f0@kernel.org>
 <86ce288c-f82f-4d73-ba51-4d4f4a6ef1e6@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <86ce288c-f82f-4d73-ba51-4d4f4a6ef1e6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C22A480003
X-Stat-Signature: 4wr93yyf47do7kj6d633wdf3qqi4ddgz
X-Rspam-User: 
X-HE-Tag: 1784515169-48752
X-HE-Meta: U2FsdGVkX1//2ho4BtSlay1zzWPyLMwgmp+/fq52CwtUY4VtJRl/L/jPJjC6vPe+Pm5Zc5wb8JceZsrgsyCz5BD2uf1fnWRTpKP/nj5AfXHwo4nO65qiSGDhCg+n0KYgrMEG9SUgDcZ0ABu41AX5bqVxHBpgjsf/IlC5QviJ15TihtOCSrPgQD7XmCowhG/Js4SfeM1FRCAQn4090ZTw6fTX7MzV4nKGL6HfSa9fQVWPUzoTNOlMOIvjAtVFFLu3QCPOI3psWxfW+iAwXcA/GBvlSzMgyuR0v7vpI1z2v3AvblIT049JdKshNRvHR8Bw7DpW+4n972Z9CdyNHczEqfaR2XZmY3zW+0yl+0ohN1Woeyb9yOpVyJAeiyuadITcE3ivKzj+QQWaLCbEqmFObgSrk+4mXiLFp+9SzeNerdB3Zb2jYdsRyFbGopfSoOjnefi9/kSkDSjFyqRyKroBlILmOoPbTBxCDjpHJIlFsYBqRvwC02VXJoNwg7gq898U/JosyqpVsuougfCz0ZHNIkNoZh9i0ZJGRoANW7mQ7jYcNmBXXHUCt00TGHillMlx8Or5PkLWoN7HmFotEtPSX+9gzSKjzwbJS20ZoPt/9XsTud9azoujn1LyPm8tABb3NEQSEdH7lLA494Kex75Y6JTkw33KTj4IAu9fTzOvV35BA/AYjF8H86aNWczKdDL/dvs77aeZubM5KvoLpBWEOkHX7GZDKMymsfzsvYAzONQxkOOu7xn0zDWzbRNPrREotnJbEtSz6eKbDLLl4jp8O4JbjlsObd+ZQhJj2UksN8jJPAgja37hD/yBuUZXfx5deEKw4vKVnwrdoxc/SxDUIbTvhHBDjYMo7x1ermeSqP3U0TZvVNV0hsnZUvtqZdRwo8svyPL4hx+9MSvLDcboBrkVgsMUuhaGukqo4fiUYv8+AcZZJYBXWBirbrE3fljVPU9jFB9WBHx+WWDFGIG
 hSRKX44S
 dDvbu2czml2ivCwiOu6KLymTKmFIk5atTZAhIKVvKy5jvxmUnLZl53wxjB6W1fZmX0lf4DfK3dLA3MzvnuIANYiLeOlBz6guo3CxnfHNg7k4M2y4TrGfKis4Zlx+3616zfPVe9DmwC8iPhXO99nsHyRxPWUPVnGHnDDiSxCodeFS8Hk8/SlAfSpmiImrr+TJDvoR1ADUeDFqVXh1QutUEYRve8IRq9KPD6ln2vvPJp9ViKeI2mkNBC7fFNCrw62NE27fwxuNrUMSIp+3yJs+RhmZJnRhx15H/g4zTuzzWcfg/Oy2anxIJx1hYmWq1VdinMtURhYn2CJUSELuLqVpuIamytYz689coSBb6vVE5WVwY0hk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/14 22:44, David Hildenbrand (Arm) 写道:
> On 7/14/26 15:49, Vlastimil Babka (SUSE) wrote:
>> On 7/14/26 15:22, David Hildenbrand (Arm) wrote:
>>> On 7/14/26 15:09, Vlastimil Babka (SUSE) wrote:
>>>>
>>>> It's not used ever as a reason that would be actually passed to migration.
>>>
>>> Right, it's a placeholder for "there is no migrate reason because it is unset"
>>>
>>>> So I think the name is more descriptive this way.
>>>
>>> Not sure I agree. The usual translation of -1 -> unset is NONE or UNSET.
>>
>> (note it's no longer -1 after the patch.)
>>
>>> At least I was confused by "NEVER".
>>
>> I won't bikeshed this, so whatever.
> 
> Just to be clear: if everybody here agrees that MR_NEVER is the right thing to
> use, fine with me.
> 
> I just stumbled over it and it caught my attention.
> 
>>
>> Just to avoid another extra respin, please also say how the following line
>> should change, as if we only rename MR_NEVER to MR_NONE, it will be:
>>
>> +	EMe(MR_NONE,		"never_migrated")
> 
> I would probably just have use "not set".
> 
> And if "last_migrate_reason == MR_NONE" that would imply "never".
> 
> Ye Liu, feel free to keep it as is if you agree that using NEVER is better here.
> 
> 
Let's keep things as they are.

-- 
Thanks,
Ye Liu


