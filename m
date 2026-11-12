Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E014606A335
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Nu/oJH5Y
Received: by kanga.kvack.org (Postfix)
	id E08096B05B4; Thu, 12 Nov 2026 13:41:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB9356B05B7; Thu, 12 Nov 2026 13:41:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCF2A6B05B8; Thu, 12 Nov 2026 13:41:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A36FC6B05B4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:41:21 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 185A84084F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:41:21 +0000 (UTC)
X-FDA: 85427334762.25.8C4297B
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1E5C0C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:41:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Nu/oJH5Y";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794508879;
	b=vhNEMNlLY5kKFvq37nnulSpDv3pm1kGJJ2BaHxD1aa9aCjWhyAy5FWN+Zt7eTKyrJQuK7R
	YjKZNjhYIhHEbttGs5JheO8D7OHRGx1AhE88mN6LCNNA/vRtiSb8XhRUehAND10wbaq42B
	NSK19tf+/FCRBiU0vJkBPmu4qOQxX4U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794508879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UiA1ssc1fM8eBuo2DnRY95RNeWhnyd0r69dfKPpEwvw=;
	b=tznSbFun0CENbjyHL1BPJlTbp37DAHb4jPjgQV+QX59b7G8tziiVdAeNXtWUli7dJ/CpSj
	ooW+7vxiUmMfjBXOhpHMsZMW7Bl1AXuAC2AUcdGK/lasMfWggDuYb8gf9vpLUcE8pYmapo
	wdbu9Bs/TkJbh9H1SRqolTmR/ow/Usg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Nu/oJH5Y";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93f3c8958d5so5258385a.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:41:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794508878; x=1795113678; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UiA1ssc1fM8eBuo2DnRY95RNeWhnyd0r69dfKPpEwvw=;
        b=Nu/oJH5Y+Ywo4sNgVhYIcWVZnsoZStaPhPZCUxJjHd2G18m4yIrk5S28HIqcQnNpu7
         Ta0jgZn34CryglTOEcox1u8+Q05wK5vx7yn1n932nP8R5DsJs+1k/VyyUiYW7wpCmshn
         CdCdDtNrIKZJJbAgi3Lr1igOrCsHO8Eq3kEwZKGOgkQ+hnkZf9SjH9us6fEFhqqvfmio
         FgkxuJqAB1KBSrxXBOoRa9XJ7j35POXTY5Ph2CGS1tYbs6oGpcLbiV7BeSFwUybYFsgz
         E4mRfPckPjawWbzOfUZlR72og3JW8Df6GIY6MrF966HCGwB/kJcoSucaR7b74zJgPe57
         KZhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794508878; x=1795113678;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UiA1ssc1fM8eBuo2DnRY95RNeWhnyd0r69dfKPpEwvw=;
        b=ubASWfRh6I+crFB1yqxkenky56WU8wwzpywUx/Tiwg/CFjXUffl0DE3nnKaFpZZ2Ci
         h0FYaWq20QBOsSc+VQv18o8ldler8Ws5LDXeUdRu+Cs9rzKF7Rhg4PhlRYINv1ErOrJL
         rBVKWMn9lK8O9wzUsb5usqmrJrYXq3UtBLizgcBzHzWeCuROWP6nncsyueE8nQSILA4r
         WKG531wjQpQsXeOBvRSxI0UfVrZ0tFVoqUnfk8Lv/jPAZ88ir3uSl3puBBeHDdntrAhl
         4GgxsAl8ZLscsMt2REAJCynQuJatlR9Pa7F8Sl684b/AU00WG2q4iyl0cC3PiEhh+C8b
         8nyg==
X-Forwarded-Encrypted: i=1; AL+hErF5I1tzWgBuiMyNXzPR3vml4kbXYxAesGW6glLepAXmX1Hmm9xNddjzrMYBxZFWfLBJK+Z0e21Xpg==@kvack.org
X-Gm-Message-State: APuU4Z+8Z2wXYa8B9KmcrFfQXH265KjnFDCp1Nt/ri6+msX9lvOH8pyI
	i/A204f+BlfQc5OUvndASzqDwqHF/CwDuNazgtZ+d+6ZCKALRtPDp6/TzFRL1pji/R0=
X-Gm-Gg: AYBFou05YAvanIjULj/7ds+UD/gaDtEA66sfxCnA/iATCQPiFLzPF+zPYpv1eScLRv5
	Wg1R4IIqVRIuSlIc3nDSYdB3c/H5p7NJLkeoivDOs323p2zgsb3cnpJ3SDM1pgUH6o/9//lTczR
	NmqHjcTUUDPidAO7ca+h9NnF+ddjOvUnomEN0c+OLsc0RzuYZmgi4BMyIBYhz4la9z1FHC83Hsr
	5iMcFyVoZlWzph7lqBx7OHDXh8qheXFor9Fw7/fV2JftebzKe4XbmAyiKWZ21hUUJlmXb1tTLdw
	TB8HwKMevMBfRkTxRvredhawubZouLylX3qZG9o5dtCyX5ypXoZGBvXovrIcRxbPLVn0HYi4Mwu
	JB9aPSXcAg7eD0RsTmtjSg1kYfsHzATSnGwjrFd69CpU93c5xKgoB2qFueyfgSYyoSizwqhx/ou
	brfZAV5b4IcsEQjxq7+U3O39duF3M0Dr3o94fVIs/lDUNStN7ZcqS5T1tJ5q/UJ2LPRdyv8kA6h
	nsZqSnBu7p0tDImoe4srOulcuwk6VGDWeaW2lxrH46ODgNXNiJ9P95RCkBNXspNKRdaZyIvIvVO
	HjQ0VRz5d3GLDRqirpIZfcb/iDkJgT2GsNCeTYTd6Cy/ca2ujNyLyWsC5X8sX4TvA8RKgi6AmKh
	Ygg0Zt9c=
X-Received: by 2002:a05:620a:472b:b0:93e:f9ba:690f with SMTP id af79cd13be357-9494bc84c75mr45006885a.73.1794508878117;
        Thu, 12 Nov 2026 10:41:18 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c3600adsm4935085a.42.2026.11.12.10.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 10:41:17 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 13/13] percpu: queue the balance work on an unbound
 workqueue
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-13-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-13-3d2454362e8d@kernel.org>
Date: Thu, 12 Nov 2026 13:41:15 -0500
Message-Id: <179450887590.482102.12180028123925629664.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 1E5C0C0004
X-Rspamd-Server: rspam12
X-Stat-Signature: bqk4cnoz1jtyossbqmetoii79g7on7jb
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794508878-291264
X-HE-Meta: U2FsdGVkX1/OKoLIuald+bX+ERDGfKvDY1Q4Dhtbch6l7pmLxlgueUoU+8Lt42O2v/tRvfz5WrxHJWD0bOVTEK/zxI2tstNwVEEAgT9WtLciMjXseKChtuNqpf2UfnHJEipHwRs0M74xmEyRG37ahBD4m+glPvpBWRCCHtgy/3Z8tZTdupqTDh+8AHHVFVxPgBb5n4613pHwAU23H2I4y4YwXwH5zQg/vuVc/csm1QyDSsovGGawp+/dhe7SDKRNVJO8qkFth0sG+llFGOOaIdm8JavlXmJ8gM6DnwJuVgXHJPxPbDIfZjME7Qbzjr2j+2YXvonfqUuq1AjxIjcZI9MXkiW06zvc6cw+0Pcxab+18GMe/hKf+KZq/DCtMstP0nVmjYDzykVj+BkyW7eXLzjMW1ZbinshqJwNGyCd9si6GCLXwX69Mm0dfdCGYDjrqMptkZL9EbwTMXjK0tB7gCH0R1/Rw3mKG4iyps5lhaClsdaVbMa/10a0vis+Nxdf9GD5+qR3Clfj+T1731AR924HPNflYiGOa5gPFmF9ikpu1ScFTZe6fIYdgGQLQTpCuUxP9GX4rvuM9UGCmjGZlEj+egBi5w+wcmDXVwTxk/D+Vc4MGNVqmX1uAx/rZzfypwd9DinvdDuVAaTKE6CdeMBY0/pP5lls+Q4Q+JfYVijdm/LdELJ+V8XlC/8EkjtH5x0I7gJhBiJT3i6nLWYafEDQyiXDSLLNzThhumk6wOUpSG7/zCa8tgFq00nE7s0A4qbeU+wIfgholOzdzPpYSFlJg5VosWT6p0AGRp61iMRCr+GgZzUwrmlo6+mrhn4syqrdWnH7w2UAFL0NA743S/8wNPifXqIyXeEZmQu7CqreDudc1aNQkrPMbivv5el6GxIonOR+AeanNBnyolfCp99w2PrDTGidC1iWOG37iSEkUL4fIhJWC8Wf04WaFU1LQs47dct8wqv2r1PrtUo
 kofmjcBS
 o38vPWP34K0bxJYlGenyLKmsBJSzQca3MbHJnRcFpzuYJG8MSn3pWdKjMhPfdviRKYrurCRrgXvzLL8PJyIrAl3E68Gjp8hUTJw6rkBYAP8SQOsD+ztc7sC9AZ9cb1gporQuhreeJaEQvFA2Locn6QktoAqb3rEKxjxxLifsL33Lm564DMNFI0j67Kv/+DlzAq5Hm3A1O97/fTexd7dTzbUhuaNMwqKKqfrefy5U7IsIwNbBjWyUsCKexMJYmJP/NB17P6IxMgl0FrZqSqKNG1dl6njOO2m14dOZyiYntcxzQALp5PzmtJKFt02aW3CDhRZWubdF3GYWb8JWPnO8LDB1gXAI8zCeNbFQFBWOvFETV382mOUEwo6zrqt5XMlTJsz5ho7kO6yuC5fuVERXbIxJovvrmX1TT2qyUqhg3cbotxR+JWCKTrz1XKEMQRtW7fZDUBoF18+vnt3LUgkTq4Z77iGZZwYTxl3ZdG4pQgWTHqPRG9CeDwl5vcmd1KA4aI80aFbg/Xk3ODXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 18:13 +0000, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> A burst of small atomic per-CPU allocations can fail with -ENOMEM while the
> machine has free memory and idle CPUs, as atomic per-CPU allocations are
> only served from pages that are already populated, and those can be used up
> before a worker gets to populate more.
> 
> Consider:
> 
>     caller on CPU 1                     kworker bound to CPU 1
>     ===============                     ======================
>     allocates 8 bytes, which leaves
>     one empty page and 4088 bytes
>       schedule_work()                   woken, waits for CPU 1
>     allocates 8 bytes, 1023 times
>     next allocation: "no space left"
>     gives up CPU 1                      populates pages
> 
> The allocator keeps a few empty populated pages in reserve, and the work
> item pcpu_balance_work refills them.
> 
> pcpu_alloc_noprof() queues the work item using schedule_work(), so only a
> worker bound to the CPU of the caller can run the work item.
> 
> The issue is that the caller keeps that CPU - a task keeps it for the rest
> of its time slice, and a softirq keeps it until the softirq ends.
> 
> In that time the caller can use up the reserve, resulting in an atomic
> per-CPU allocation failing.
> 
> Fix the issue by queueing the work item on an unbound workqueue so that
> another CPU can populate pages while the caller keeps allocating.
> 
> Fixes: 1a4d76076cda ("percpu: implement asynchronous chunk population")
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: tweaked commit message, comment ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reproduced with a cpu hammering atomic percpu allocations with preempt
disabled. Results are pretty cool.

In about 1 second of hammering allocations with the full 13 patch series:

                        Base       Patch
Successful Allocs      1,188      131,072 
Failed allocs          4,097         0
balance worker runs      0          169     
successful retries       0         4,096

Micro-bench obviously, but pretty stark difference.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


