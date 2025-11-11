Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41D0BCCFA13
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 03:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E3258E000D; Mon, 10 Nov 2025 22:04:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96C8E8E0002; Mon, 10 Nov 2025 22:04:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85B408E000D; Mon, 10 Nov 2025 22:04:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 700A68E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:04:31 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C20F16034E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:04:31 +0000 (UTC)
X-FDA: 84096833142.22.47B1A54
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id B3FB04000E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:04:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m1VOnbj0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762830267; a=rsa-sha256;
	cv=none;
	b=0G12y/UAb8Md/YVSTDe1MBkWUl1IKCzCeJ2Pt66zXju6ArhsSUGfj6WJ6ygcT+Q4XMFm9d
	Dduic+7N5vfwsS1oO8pCvse0MD0PnhjKsYIPMs16gOPgkYu4S+VIQ71sqPvscesYXCp9Oq
	BeEsAho+1uo2dWnou7tK8Fo6aiu3upQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m1VOnbj0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762830267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V5c8zazQymbCh3EJOF0KTydVfHgB+HL63txNkj2DBcg=;
	b=YZX6BG4OGl5jlQm/OlO07AGtCpx0gmz05hnzFpntGkoew9wmaXSnAtu2QlbCu8csMnYP5u
	y6beiRqP6HaArPf2fWDN9fPk+9TZjHAj2fDAjAAONKIezv9Xa61bfwS28SaF0imQ7VtKxW
	4bGe35HhHM4ziS6e1D/sd57rIWKxN6o=
Message-ID: <8d6655f8-2756-45bb-85c1-223c3a5e656c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762830265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V5c8zazQymbCh3EJOF0KTydVfHgB+HL63txNkj2DBcg=;
	b=m1VOnbj0B52FF5eqkgvxn2ibcAZ2AlUdQ2OpPrHQmPQeylgDhQJZc44smuZ/tFwxYYmsLz
	MO94ShQBlC2V/Nu2D3aYvij6xrHH3NeUozTm0MkGI8F9M9YBE2vzLtaW4CW2d3AV3LqiNx
	ieAfXns9GSZy2EFyQl44C+OKbFBoyNc=
Date: Tue, 11 Nov 2025 11:04:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
To: Shakeel Butt <shakeel.butt@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@redhat.com,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>, Qi Zheng
 <zhengqi.arch@bytedance.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 linux-rt-devel@lists.linux.dev
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <97ea4728568459f501ddcab6c378c29064630bb9.1761658310.git.zhengqi.arch@bytedance.com>
 <aQ1_f_6KPRZknUGS@harry> <366385a3-ed0e-440b-a08b-9cf14165ee8f@linux.dev>
 <aQ3yLER4C4jY70BH@harry>
 <hfutmuh4g5jtmrgeemq2aqr2tvxz6mnqaxo5l5vddqnjasyagi@gcscu5khrjxm>
 <aRFKY5VGEujVOqBc@hyeyoo> <2a68bddf-e6e6-4960-b5bc-1a39d747ea9b@linux.dev>
 <aRF7eYlBKmG3hEFF@hyeyoo>
 <aqdvjyzfk6vpespzcszfkmx522iy7hvddefcjgusrysglpdykt@uqedtngotzmy>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aqdvjyzfk6vpespzcszfkmx522iy7hvddefcjgusrysglpdykt@uqedtngotzmy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B3FB04000E
X-Stat-Signature: ubuz5gt39genj89pny7cbk8jasq7ayb9
X-HE-Tag: 1762830267-606479
X-HE-Meta: U2FsdGVkX1/0EFdWKc0g/zQaLHXWSMWLTOPVxZj9qQnhZqKZi3YzNY4dV8Kzni6UnDHmevqM/cPU6SVXYZKPw+UJL9t1Wu9I3RvCoKA4eyt/vybUjYV7cqXd4ZtzTD1mrk2yht6DbEhZUUxhr4w7U/2mkCA7Xx1wKc9BNZHvgPeB1KUeiHgt0JWjuUcVUMVL+P+J8oSyMlJtDmZOofAqN5oU1dXHHlEbQ8sLnHvyRAqFWBZwDHE2nMk9LXrqMYgOznyiAtzuzZk0DwDMO7PCX6d6BDpKPDOxG+C1Zcz0Oi4jcahH4t+9qYO4RSv8W8CW0acppPqF3DwBshmvL3OmdTIadMEQMMR/OshD1hTmjI7f389yFq6k4v7M5MkQgAbvFOn81T5PgGCAA00gBijaroe3J8vUXOQ0VLSasrGTuOxL6tt6OQoAnm3qanHKT3ihXcroYQfryONaFJ8k+6GSsifiUMeIZsLgNninEUFqrPht2l6r3N3naveIA07bs2kXEgG6/QiIbbxJnRGltK7elHNE6aejTMH03DtNKEbXg5WlecV7GdVmz8jLda9V6sKP+ryXCYhfI0GwlBfWCacm95LYsfTkfNDWio/myf0hKof9efru3w9Wz56HxqR9toyH1h2edPQmiU+889c2zD9kEDtuh3QpE690OEIltEm+UlYPUnzV267Pe8ZN7t8g+tzPEYdiWRXpwk5Ni41F4VHqv7F/IOgdmyKL5np52amtN3WK46rykk15vfwd7K2OHMjyOuwDCI3GQSB1tAjprANNkLMroUDwfJS4eWMn2xo7CvH+twkJImB3VCbSGgFF+v08YPsh3II0MmMYeDsJom9YW1uc7cT65SWMgLWjzDseFpuMbyOErv3WZ1tqRomySukcrY0EpjIj9kZD2jU8XWUuJ4mA5C0pjOYwJGNkjXGToJVmIaBZg5JSW1Wp7FQS2W+HbvZhLNZVCCzFapvGDys
 iWH2M37i
 YWPG10keJFfx+EapN1YERAc8L4O80ol9TOVZM6E1SCLOS9CKxB0IU3Iz5IIF3vwAwmbx9LCQJ4WwPH39HfhkrKQJwPfsABD14BziG1v2OQ1WyMlA29Ie8NRYuBeVOvNf9gHZTz0m8uGRqA02SOhVjK1Ep2y17q+5IG/h1VcRc77fEjLwsbnjd9kloKZ49aYRSFBkh5UheCXIm19ts3VuYhSc+lXenr1qkBttubFHFlP8S1paA4fjtwAvkHQ896Cr3RiYv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/11/25 12:47 AM, Shakeel Butt wrote:
> On Mon, Nov 10, 2025 at 02:43:21PM +0900, Harry Yoo wrote:
>> On Mon, Nov 10, 2025 at 12:30:06PM +0800, Qi Zheng wrote:
>>>> Maybe we could make it safe against re-entrant IRQ handlers by using
>>>> read-modify-write operations?
>>>
>>> Isn't it because of the RMW operation that we need to use IRQ to
>>> guarantee atomicity? Or have I misunderstood something?
>>
>> I meant using atomic operations instead of disabling IRQs, like, by
>> using this_cpu_add() or cmpxchg() instead.
> 
> We already have mod_node_page_state() which is safe from IRQs and is
> optimized to not disable IRQs for archs with HAVE_CMPXCHG_LOCAL which
> includes x86 and arm64.

However, in the !CONFIG_HAVE_CMPXCHG_LOCAL case, mod_node_page_state()
still calls local_irq_save(). Is this feasible in the PREEMPT_RT kernel?

> 
> Let me send the patch to cleanup the memcg code which uses
> __mod_node_page_state.


