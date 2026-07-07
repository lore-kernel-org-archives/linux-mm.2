Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C0EAC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 17:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DBD86B009E; Tue,  7 Jul 2026 13:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B3406B00A0; Tue,  7 Jul 2026 13:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A2116B00A1; Tue,  7 Jul 2026 13:10:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D69746B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:09:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B379401A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 17:09:59 +0000 (UTC)
X-FDA: 84962618118.12.927A805
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A2BA3100015
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 17:09:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ilfmc06F;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783444197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6CUF4r7uPib5/E2O+eq3hGHhL62QsV+tEaoDwEyllTY=;
	b=qN6wbu+h+C915zejbAQfdhG0N1sWCWU9WPRMo3P4YKxz8lizZZfk/mMo7b6cScqpYBUP+P
	3EbD+7sOLtABRi0Kc9vyEMbGZLSoZxEIbZdVtQDcFc3lzwaY88LcGm3nykDroF8M7rfQYg
	SH1Ti7L+fhVl6g+7ZSC7zDXwf95SBcs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ilfmc06F;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783444197;
	b=FALgJz9q2A1JAUAV6s3bI2JB6bWZPl7RGj19VMjdLzOY4d9ziyZfGsboqnmw8v0CW/L8Ht
	CYNNpylNhqvKGsSJewNggkYMkhFThTG6KxR5BkOv7+ZfzD2di13ERTAcfdjVLlmAxTrNS7
	QxPCGaTfRaxE5i+lhw5HvGpRl2M7tTs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01BFB60018;
	Tue,  7 Jul 2026 17:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A401F000E9;
	Tue,  7 Jul 2026 17:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783444196;
	bh=6CUF4r7uPib5/E2O+eq3hGHhL62QsV+tEaoDwEyllTY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ilfmc06FAFeATNBCfn3m2SaaaswmEuje9O4YPqE8sB9iRfOk/k8OX0VfmqDNRhP6F
	 qm33s5+R7gsznyaFV/hM/pgRlfTDt3Z5jY6ANbJ7DBq5ynoVzGPdeFfGkXQP4pXSrB
	 nWYyaG7n4i/eZatWysf8ih7R/aI/s3c1kJKNe7LDPMlBRhSSK5Ld4oVqd7IEFI4TLX
	 7Rp0AfrrEN8+4u0LSC6IFY366eDcJHezNpreBLRis6DlGPQK9ZkiLGZKI9RbUnWxA1
	 XuS7ffBN/zsdFdZHlfNUkcXDKGYn3JQ0nX7QDgtQcuuTL7P8NC8klsHAiXAkzBvuVn
	 k6Dxp4ektc7ug==
Message-ID: <66e8d008-5eaf-4a9a-9cca-e9b2bd8c9f9a@kernel.org>
Date: Tue, 7 Jul 2026 19:09:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/13] mm: rework anon_vma and remove
 anon_vma_chain
To: wangtao <tao.wangtao@honor.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "willy@infradead.org"
 <willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>,
 "kees@kernel.org" <kees@kernel.org>, "luizcap@redhat.com"
 <luizcap@redhat.com>,
 "zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>,
 "kas@kernel.org" <kas@kernel.org>, "ljs@kernel.org" <ljs@kernel.org>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org"
 <liam@infradead.org>, "vbabka@kernel.org" <vbabka@kernel.org>,
 "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
 <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
 "jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>,
 "harry@kernel.org" <harry@kernel.org>, "jannh@google.com"
 <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "npache@redhat.com" <npache@redhat.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "dev.jain@arm.com" <dev.jain@arm.com>, "baohua@kernel.org"
 <baohua@kernel.org>, "lance.yang@linux.dev" <lance.yang@linux.dev>,
 "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>,
 "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "baoquan.he@linux.dev" <baoquan.he@linux.dev>,
 "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
 "matthew.brost@intel.com" <matthew.brost@intel.com>,
 "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>,
 "rakie.kim@sk.com" <rakie.kim@sk.com>, "byungchul@sk.com"
 <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>,
 "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
 "apopple@nvidia.com" <apopple@nvidia.com>,
 "pfalcato@suse.de" <pfalcato@suse.de>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "damon@lists.linux.dev" <damon@lists.linux.dev>,
 "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
 "ryncsn@gmail.com" <ryncsn@gmail.com>,
 "jparsana@google.com" <jparsana@google.com>,
 "dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>,
 wangzicheng <wangzicheng@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
 <08c001ab-320f-4676-830b-8e4ba6a05dee@kernel.org>
 <b00a03d62c53430ca22b3f3c5e5327b5@honor.com>
 <0e8e5a28-1111-4b81-b04f-b81e749eb3dd@kernel.org>
 <f640c89d9722462098bf1b7a0a6854c2@honor.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f640c89d9722462098bf1b7a0a6854c2@honor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aw8k6qg6sq1nczq57yc85nh538xxfemm
X-Rspamd-Queue-Id: A2BA3100015
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783444197-459493
X-HE-Meta: U2FsdGVkX1+kspgGSt/j93mrSh0OHJeZfFjRkuzICV68eR98uhaG1Fls7HcwPsQPH/yH19ivGbQYHkKmA7/gzevWU/rKGenM5jWHJgqF/8BhR3V+UPYB1UcN79VE8egNcKT1eBSqDtAU8nwZfsj/Z/jMryYx+Vfb1Y1wBYm8iZSFJB7zO3PzyNNDh/JpuFBzjTdcBH2fc+pnbwdoxnjw6pmIXxN+NdXBRToYraVLIWhNrWtt7g5xW3OiCtwRgdNP2arMDEmmDQGkXvaoCdCNrFKjUSUVv+j+v5777nhDRC4UAhetY36OgcB8y/VtVxfo7PMQXvSlzuvNLoq/MNYRResjcA5IGfaqp2vfkZG9SZTqbk7pUMoAm3js+GGreaXl9sTAvl9hnSMeLZtH2Potu8rTUoTVY3xmXp09rj5/JIWXGqGBX18k4Uf+LKXWrfBQd+MRFAXcsU4h2l58j5/gmQGVBZu+HVkmr4ZH2Mr3hkiijgKjdKYui273f19urt4YrBHMMX7vmuSkbJKliyD5ZjOXb6X45O92x0FeHPeELdOAZ5SzbH2vTlSfZJHujDxYthyKkNNByo5fw84v8PqFr66MtaWVNDeVIwUQCbzQ/IiAm84RlKEpM7arfnuWmGmJF6au6etzvCSko/7K1c7oVbS0KToWpaywwvCDru7Ba1KM9fNJsyhxQF9BN0o81+itD+R5YrQRECDyzacI9s0golXlXz5OqGV0KeKuLH+HwbDKCS7wrVF8jWxZdw/1QIVC+lgEoaqaW/lccunAY07j1BLi0CpQ1nhifKvH1nDMa5bsy6pGui3P+IXolNRrLqxWk4/pBE904QXztVlYxp2Y439mRtWBoFlA5rMptUVr3uWMJCaR7GyrZ9dzVYQ/t6FtD0JL/netaHGC/NnaPUZA6PA30ucw1qivElMd3oQGhUD0Px2CI4eMqA1iheyB2hpTig95zCoQ99onE5/LBKd
 mxchjixg
 +px8Qs62+7F4e5YriEC0oAvut6mYrtNvj5V5K9UaJxOBt7OrHFfwDICQ2XTKwzJ/Oww+dr6dku4ittaLLQZKHDFuN1AurxaBAKhsy9U2WI8kK53Gk5zZcrjrCVAnlcQaOSM7I4wHAJISENdeAhCmZTO3fXp82e6Nmla62AX6Xn1Bkx/hhz8FfB+8u9txEnCSPCFtTpWQWhoP1QH+91p8hQyt5RfVdthtbybFfeyeg+V8gEMF031ehu7sDRCJoltmXiN4jN8jWfxCDeP/n7iEVWdaNYKNewMwEG0ak8vxb+Ib8sO/rZWYwieLaYmkRbaNsFgzNa8utFglM8IJypW6v+d+2VDTrfiMtvb+OhNjZbfUY9gu4fppSDBi15zeJjFgORxm0r+uFxsja4GVeRdROgtJ5mjsbze9m1F6cBp6do+gHT9OSBNwOFt5AgJZWl6cAtVcABUb8h1J68gVXGQ3fY6FZIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 11:20, wangtao wrote:
>>> I saw it, and I’ve waited for a while as well.
>>
>> Apparently you saw it but you didn't read my reply about slapping more
>> complexity on something complicated.
> This v2 is a complete rewrite replacing the original anon_vma and anonymous-page
> reverse-mapping traversal.

Okay, it leaves the old code in place for now. Just as a general node without
going into details: that won't fly. We don't need another MGLRU.

> 
> The new anon_vma hierarchy is represented using a simple doubly linked list with depth information,
> replacing the complex topology of red-black trees maintained by each anon_vma in the original design,
> and also removing anon_vma_chain.

Okay, but anon_vma fundamentally remains. Using a lipstick on a pig.

> 
> Excluding patch 11, which optimizes leaf VMA rmap with PVL, and patch 12, which optimizes memory
> usage through shared semaphores, the base version contains roughly 800 lines of code, including the
> compatibility part replacing the original anon_vma implementation.
> 
>>
>>  12 files changed, 1056 insertions(+), 54 deletions(-)
>>
>>>
>>> If there are technical issues, please point them out directly.
>>> Or is this simply how technical discussions are usually conducted in the
>> Linux community or the mm subsystem?
>>
>> I suggest you go back and read my email.
> 
> At first, I thought I was the only one who found anon_vma hard to understand. After reading your earlier email,
> I realized that many people also consider it difficult to follow. 

Right, that's how Lorenzo started his work, trying to replace/remove anon_vma
entirely.

So I tried a different approach and implemented
> anon_vma rmap using a simpler doubly linked list plus depth mechanism.

And this is what I don't understand. You were told that Lorenzo is working on
removing anon_vma, yet you decided to work on + send something that reworks
anon_vma?

Also, I am really curious about your expectation: not having a single patch
contributed to MM, even worse, not a single RB tag or anything, yet you rework
one of the most complicated part of MM repeatedly using other complicated
approaches, and immediately start demand technical discussions? After sending an
absolute horrible v1?

I really try to be a nice person, but really, am I dreaming?


Obviously, Lorenzo is still working om his approach, about which there were
discussions at conferences and LWN articles.

Stating "that you waited for a while" is ludicrous given that your old patch set
was posted around one month ago, and a complete redesign -- moving away from
anon_vma -- is not expected to be a short-term thing.

Meanwhile, Lorenzo is sending real cleanups [1] as preparation for bigger
changes. ... which is what we usually expect on such fundamental reworks.

I'm really left clueless here why we anyone should spend time trying to thing
through yet another data structure and yet another locking scheme, for something
we want to remove entirely?

Again, I really try to be a nice person, but something here just doesn't add up.

[1] https://lore.kernel.org/r/cover.1782735110.git.ljs@kernel.org

-- 
Cheers,

David

