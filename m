Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D378DCCFA18
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 02:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AB018E0009; Tue, 11 Nov 2025 21:11:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 382B08E0003; Tue, 11 Nov 2025 21:11:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF7D8E0009; Tue, 11 Nov 2025 21:11:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A22F8E0003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:11:27 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A2B1312D05C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:11:26 +0000 (UTC)
X-FDA: 84100328172.08.809E22D
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2C7821C0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:11:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A7XRRi4j;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762913485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uriJ/UZtbFIWJHYtkqAM7/7gRRqxwaWIv7KjAJwxh2s=;
	b=hqDa7EJTJvXCUqoJyU2m1dPwN8hi34zFl1Qd5V+J3GUWzHNSyfeXS3vV7iOoIRwMDqsGS4
	CO18g3KudrdM8sHt4+gx3KdR+xv5xSv3LsqvaQiAAgy7tNtbRhuLgXlr0D93UGjSJQn9VH
	v8Yrl/Hdm0N01YI1LalM2xFDRtjeVKk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762913485; a=rsa-sha256;
	cv=none;
	b=oGTKs97NRN7Gbn2nNbHfaia8gjBNQojjyBjUMCKwG1wb6Rr/FrHRVKRXCmA1SAs5CwmYhN
	uIDAkyDJf2w8ILj3Rq69B2XDbQ6+YrFQmVNRTZc0TLIRcTdBFdrjJ8P6RatHyh8zbhF+Gx
	CpoIn5MFCtUgG7cgXCVCKrA2qY3kHBE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A7XRRi4j;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <b3ba7892-ed5e-45bb-9b1c-e901b622306d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762913480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uriJ/UZtbFIWJHYtkqAM7/7gRRqxwaWIv7KjAJwxh2s=;
	b=A7XRRi4jm9+2dng+brC/ULaeX9wZNMw/VzLlf/tyUGMqCUfZ2beqnlyFDHJ5onqOe9qT/x
	+xVpymK38zhN1SdT+9T6nvNkJhJWwRUumKKTdfvjlk+gOa4GWGWTPF5Gmf3ZhCEuJaIj/S
	4caHjsnL4DfoYVhD3xw/wxg9bXoNT3k=
Date: Wed, 12 Nov 2025 10:11:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] memcg: cleanup the memcg stats interfaces
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Meta kernel team <kernel-team@meta.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <0618ea79-fed3-4d4d-9573-2be49de728cf@linux.dev>
 <xjwmyqdjynpeuqtgxiz3igynjl4ywopdc33lteidgmp5yez2ed@pbdfsekytezn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <xjwmyqdjynpeuqtgxiz3igynjl4ywopdc33lteidgmp5yez2ed@pbdfsekytezn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C7821C0003
X-Stat-Signature: naaj8rh8e1sgste6pdzqpdiupj7dfaes
X-HE-Tag: 1762913482-94916
X-HE-Meta: U2FsdGVkX193spMlaomjMkzdEJ76RotiuRwv+UFx4BA61w7XgQKEfxS6SXspVBE90XEzOySqk/FcPUSWGPZBYOHJG7V6BX6OrIwX+RP3wn4kVH7e4a+NYoWPHm9AR7tNIshC7oceYW5Nj/DD7uNeFlHg28jQ1PuCskx5h6sW8oCDqM9jTN+GTW/qX6c/AUAtGRLaNwsA7yORCuVGs4zVFO0Lubl1kfliM5/coF2+cp6ebaLqaufTAELPAS19QI4mmCWAn9R1fszidXjRF/BEjsn6V7SiGkaiEGvr+P348oaBH1KQsPo2z+iEQCSqdRyaj26XvJsOvHs42tWzqyAmoHDlUNUCH0hOGvVonpx5svS35s0Nvn2NmvX/PKIGqUKXAPN4rhhufVXERnUu6oldceQK75AlHho1jiToO7EHiBAgMMUWMBVyTSYJr3SDMe2IHu29I9BTnSvA4FgABUGJtHcccMRPP8WMFJD+6UPwWAAuFcP4Wtp3viVKlt7hch9XqkzWEwVlW/7NRzojHkAkp6rYzzLPyzifqNCXHmz4JWCHllmQ9HphmR1loB8WaDzjNlJ9HG/FyqW6Z7w5p4nL4zc3+xZ0mvNOaORpa4/8Gnj1djrvbhiqnvH1xw33OXi5qiSmJqrwCLVEbK+TuKbv7JPWf6sOz5cppVIi9+hvDr4DnphwtqFwZmwxzdbj8MvLKMq5o0taeKy/ltAD875oUpQKx1LPKKO+9Z3C1sP0LM8XnF97A00oUpdLHTQh3uSDoom+Jrcp3xX8aaE1uUX1heZLzlceEUp7X4MRFYTZq2MlN8Q93I8Qp4f7CLepJKnQXz4bnP9ZaV8d+6NZ9UDIh03yNL6cpf56O+9wzCx5zmWqKUlAuKtT0WBB0WTjuhFQtzgd+dzAm9fnbM5OlgugqQy0GkBvIlYXZ0fIbGWAf3VwCp2EpQ+dFP2nytsdeS2WeUeQ0eisF6mqnuxr3Tv
 IgUXkJur
 swESt/LbRWMplkzmDiN1siswxu8JgIwMjlR8QLaegt19eTAOM4oKKk20p36UpDoZUXbL/bsSs1gg22W82qtbmlhRgQE+Y8WOEfk6ecpIw12ytUsPZoVcw13yogxcPj8CB6JSEiXRXdEl9RuNSv4almsQiuAFfbO5FLcSSbJ317aMn0yAymDICPwt20na4GX+ru5rsJCaHE01s94r5GgBRmX/47A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/12/25 12:45 AM, Shakeel Butt wrote:
> On Tue, Nov 11, 2025 at 04:36:14PM +0800, Qi Zheng wrote:
>> Hi Shakeel,
>>
>> On 11/11/25 7:20 AM, Shakeel Butt wrote:
>>> The memcg stats are safe against irq (and nmi) context and thus does not
>>> require disabling irqs. However for some stats which are also maintained
>>> at node level, it is using irq unsafe interface and thus requiring the
>>> users to still disables irqs or use interfaces which explicitly disables
>>> irqs. Let's move memcg code to use irq safe node level stats function
>>> which is already optimized for architectures with HAVE_CMPXCHG_LOCAL
>>> (all major ones), so there will not be any performance penalty for its
>>> usage.
>>
>> Generally, places that call __mod_lruvec_state() also call
>> __mod_zone_page_state(), and it also has the corresponding optimized
>> version (mod_zone_page_state()). It seems necessary to clean that up
>> as well, so that those disabling-IRQs that are only used for updating
>> vmstat can be removed.
> 
> I agree, please take a stab at that.

OK, will do.



