Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81055606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 01:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YHHlgFoo
Received: by kanga.kvack.org (Postfix)
	id 6D25B6B05B1; Tue,  3 Nov 2026 20:37:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AA3E6B05B2; Tue,  3 Nov 2026 20:37:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7FD6B05B3; Tue,  3 Nov 2026 20:37:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 400166B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:37:34 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BDEBC1C3E87
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:37:33 +0000 (UTC)
X-FDA: 85395724386.05.9DC6B06
Received: from mta0.migadu.com (out-150.mta0.migadu.com [91.218.175.150])
	by imf12.hostedemail.com (Postfix) with ESMTP id DEAF640002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:37:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YHHlgFoo;
	spf=pass (imf12.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.150 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793756251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CE0t5hOROhr+8knZGqTWCAomcPgxGmzw+Md6f9Efdfw=;
	b=p0Uvj25liCu36J8BhEbbXOXaPfR6bHI9In7yPxw3qRM1eDCvezBpTP+nqlpTuuGMcGfUGp
	QAJuBcJlZa2BF1CROqtsk64DEHeQWOt3ePwEsurYsmvfVgD+8VRbo+z+BuoOPmvPjpYJMo
	SKUP2nV/EJ1EI3/14NEvFdZDjsydMFo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793756251;
	b=AFtW+LsFUrOH1cBFFOCTesqGhzCs9hq2lGTusvZ631/LuIV86dLr3bvxM1c5F64pK3aBRC
	7XHNi4T9tbqWa+lpbT+nwQ38MjyosO2azP6GPUiMYBDsH/wFwpvm2KXijEbis/4kuSAOv6
	t8i5ClpmF3qXAf616MvPLtO6uBf1xGo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YHHlgFoo;
	spf=pass (imf12.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.150 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QwlcNBQAVDxk0/AvVL+NWkQwGw6IW0hqKl+WZhIVwVQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793756248; v=1; x=1794361048;
 b=YHHlgFooJxLI/QTInDGkRd8mSsRkK5MsDSo+rgkKwy6Wjg8bt7dHgt89V+qmL75uMJH2src5
 X++s8TOD2o8R/6K8UMVopRaNZzh+yGX+TofEluy/elXwCh66mlLt2hjcJpJ7qcyV77cYpwj5Uog
 bEnvSITVLkj0IKYblWzOdE/E=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 59a6eb213e4c26de;
	Wed, 04 Nov 2026 01:29:25 +0000
X-Mizu-Trace-ID: 59a6eb213e4c26de
X-Migadu-Flow: FLOW_OUT
Message-ID: <dd07c949-eb56-425a-8b1f-ceda118d3a5a@linux.dev>
Date: Wed, 4 Nov 2026 09:29:17 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/7] mm/mglru: add tracepoint for inc_max_seq()
To: Barry Song <baohua@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 "open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
 <20261103025610.3738894-8-ridong.chen@linux.dev>
 <CAGsJ_4xCTSctcPcC7X6Dx4zYaOycaPqs0DG7AaxB55wx1Afwpg@mail.gmail.com>
 <9cabcddf-d807-4a36-84f1-5bb06ea72aac@linux.dev>
 <CAGsJ_4xXDZjhN+NkvtN+vAp8Bokack_JdNgP=nGPQtHUX8_rqg@mail.gmail.com>
 <f5137dbb-b0ed-44ea-a23f-5c848315a68a@linux.dev>
 <CAGsJ_4zNZynkZn1mb+nT1n6dq4n399VC8Lbo5Sv92gioDfPxUg@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4zNZynkZn1mb+nT1n6dq4n399VC8Lbo5Sv92gioDfPxUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DEAF640002
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 5hewfwfzi9z3qexmqjxfdtncgmgnb8bn
X-Rspam-User: 
X-HE-Tag: 1793756249-421477
X-HE-Meta: U2FsdGVkX1+j5WQ8MeScmDkAehQTQwBtZkWOVUILIT9+QgM94acKYPUWHM8QIvbCtUgVjAOn8nkE0eeNLD7dAD6W5EmolK4H9/XzfJjUR6MAKooxi3687Fq/s6nf0A+m+ONZ7eIEbSIdX2VV5HBkl/DkHPxyB2S4qs7ghF0WCL9PsabOu3Fdr5OnA0dtGByIzPqtDfmkWYBfjz18K0+x0alubNrhkgXnX9y1Ior0tcK9B4DRu72MVEcYn/+e6fgaw9YKKSDsWzkO/HsmjpwFXEIXjTKHgVKMsCzEAoIw9na23rOw+5rYJohmYTGhtQV49Ohpo0KaYWX0K+5Rb84r3MBfZ+TnfF6lpvQNP84iJaLSdYdabzSfujaQcmknWxfYAZ7nzq5W4AvmdD89W0KHIJA0CTlTv71k42V1FlBAy39b2jwI5FoVu36v4xwTAxmwz+1yD0aDRm5V+/hikk583vFSOymegiO6vmRXMc/GUdRrFwxlfkkmGom6AfQX8qZLqierTa2B/CxeZILJMpCx8dWvn2fWYN0J2yol0DDCK78mkhzsTzD4uGOEEy6iKvzsV+CLMErvD85B6VbVW9p0MYC3Rgj/S1QAkk9c4NNw2zh8M6uMjIc18b30OhmR2KYsIjeVn4Qvbo7lDxfZ+z5UGg2T2fm564WTJTEcIkEOP2PVGkzeWKe8ym74byHEbkEmni5RodkuhY6Vgu1uQzfUQlx8vrA2/4a4itgjEfK1PhU/J9F0jG3thfrmucsu7DLLgheShGA1Cjy9R1m6hOZeOFhsV9AOfNxb4ckiGOtKJFfS714xIrptTbbZ5wSDvqHb/AubJa75U1mDYcuhwqo/Pku6clDeM7S4LeyoAX1xZcq6KgRL2vKWoRw6DLq8OeM+sPb1Vo0jvTwfCYSoUXV4p/qe+pG9zABv8TlcDwbA//thJHkjbm6Gi8WRHV6ivUDboFyTxLNuRVOc7doAmMA
 DE/g90NY
 KqsSBVwn+fc9fpCqIPsx2mNJY1riQGjFD6ak7hnQ0aQxklZyhMc9K/XXJdPoshsOVjPPRGsex2buHZR/WCJJeH5jo80RPH78VuhEVGfMWrOFZ0e5mq/0mvEzqzp0LJguBRI+6Czm2uFCC8isUFPquCZ01nO3ynGI2LHK6uYOsXIQ7e6jQUCudlxUXB3dIA5J2P/5hs0xRnuZVXf+BIPkSTl1pahw/gcowbXk2xhvZZ9Z9AU2mHPJsyH0oI9WaSCdwMnpE/nI0ryKIRYWgu3KocT1cnblEJsEHB+7DrlBAkyZwEH36kGlbLi2IEZyfPJNTKtLlP14aoexTNv3MJbK2ldsoiYwCH15MuTxb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/4/2026 2:28 AM, Barry Song wrote:
> On Tue, Nov 3, 2026 at 8:23 PM Ridong Chen <ridong.chen@linux.dev> wrote:
> [...]
>>
>> Hi Barry,
>>
>> Agreed, I'll go with option 2. Two things I'd like to confirm first:
>>
>> 1) To report the reason, should_run_aging() would need to return it
>>    instead of a bool, e.g. an enum like:
>>
>>     enum lru_gen_aging_reason {
>>          AGING_NONE,
>>          AGING_NO_EVICTABLE,     /* eviction is not possible anymore */
>>          AGING_MIN_GENS,         /* better to age, eviction still possible */
>>     };
>>
>> Or just report sc->priority, swappiness, max_seq/min_seq and the
>> per-generation nr_pages, and let users derive the reason from them?
>> The former is more direct, the latter keeps should_run_aging()
>> unchanged.
> 
> Right. We can let users infer the reason from max_seq,
> min_seq, and nr_pages in each generation. This shouldn't
> be difficult, especially since should_run_aging() may
> change. We don't need to spell out the exact reason.
> Just present users with the overall state of the lru_gen.
> 
>>
>> 2) try_to_shrink_lruvec() has changed quite a lot recently, e.g.
>> Kairui's reclaim loop rework, and your swappiness series also touches it,
>> including the aging part. Is it stable enough now to carry a tracepoint there?
>>
> 
> Yes, I think aging will always be needed, regardless of how
> we change the code, so this should remain stable.
> 

Thank you for your patience. That makes sense to me.

Will update.

-- 
Best regards
Ridong


