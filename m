Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C0FEECD986
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 16:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B25EF6B0089; Thu,  5 Feb 2026 11:46:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFD856B008A; Thu,  5 Feb 2026 11:46:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09796B0092; Thu,  5 Feb 2026 11:46:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91DA86B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:46:32 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4B88EB9A89
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:46:32 +0000 (UTC)
X-FDA: 84410981424.11.0A45055
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6996240012
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:46:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YJCyzbg2;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770309990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hsyV0yR7OwVe9TJAhuO4aXNabbuTYZCogUyzopylZ3c=;
	b=P/OMYTMdNZOv2g+CxIjsipKwAR+v/xM10SCmJZuz/QevfSVaXJtzBXev0Q3TSupgaIyxFs
	NF10DWc0pAyiycBpQ77hUHBHbVKLCuw+hq7JUZKPUgafNLCQgcsyWiujnGjrnWhHoRCOT0
	MBQKNjWkmBq17SHNkChSuLGxUpZ5BCc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YJCyzbg2;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770309990; a=rsa-sha256;
	cv=none;
	b=ON/ahT8adZxxXExpaM6ppkIOrAGBDzdhmun3IdcycnI1Hy4mjVp70a0uB41uqwoGkCiOPG
	AJ9NQDwv0pedu+US2+4cJSzKvbQJEwHseIi6Ljowb3vHO+sGhWuu3gbSGQHpen0McSnyRx
	2TH+cc5Cr6K+ggwZ0TJJuKZAkSp8gdA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46BC54012D;
	Thu,  5 Feb 2026 16:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36EEDC4CEF7;
	Thu,  5 Feb 2026 16:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770309989;
	bh=xZ40A2XkLWxNuM0wtPdSv5FXxZ2RAwf3Y0brB27dkCk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YJCyzbg2VBKutZnbfY5RGMyskD50lSS2TpqXqwLIjEQMZfJ1jHKWwl3AaxAi20GLL
	 VsGf/m0Hd/URQaPfrKzsixUikbp0H2YSTNHc21IbAiVac7NXyTxzw6EzMAIj4PRCC1
	 IndCBmMBh777Pe6GqDfPwzb/JEaGHX4ZnkELgAgNN8DyDWkaVFMsLJZWHO2m6tNS+2
	 kTKs4EMqZxe9hCk3CmYekOfAHv1ElOEFy6WWzpQOgbFY+fkp4al9lyra46gHKRJY6h
	 up9qpJfI5r2ydgFJqHfE3VchHNqJ7eQFa7A7bcQQumBV7jsWqu38n/x4dSFyI+6Su0
	 Az2gcwSK0iYSw==
Message-ID: <8fcfe565-4371-47ee-a0de-a9d3e1efa0a1@kernel.org>
Date: Thu, 5 Feb 2026 17:46:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
To: Lance Yang <lance.yang@linux.dev>, Dave Hansen <dave.hansen@intel.com>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, boris.ostrovsky@oracle.com, bp@alien8.de,
 dave.hansen@linux.intel.com, dev.jain@arm.com, hpa@zytor.com,
 hughd@google.com, ioworker0@gmail.com, jannh@google.com, jgross@suse.com,
 kvm@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mingo@redhat.com, npache@redhat.com,
 npiggin@gmail.com, pbonzini@redhat.com, riel@surriel.com,
 ryan.roberts@arm.com, seanjc@google.com, shy828301@gmail.com,
 tglx@linutronix.de, virtualization@lists.linux.dev, will@kernel.org,
 x86@kernel.org, ypodemsk@redhat.com, ziy@nvidia.com
References: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
 <20260202110329.74397-1-lance.yang@linux.dev>
 <20260202125030.GB1395266@noisy.programming.kicks-ass.net>
 <c6fda7c2-ad54-416a-a869-1499c97c7bd7@linux.dev>
 <4700e7ba-8456-4a93-9e28-7e5a3ca2a1be@linux.dev>
 <20260202133713.GF1395266@noisy.programming.kicks-ass.net>
 <540adec9-c483-460a-a682-f2076cf015c2@linux.dev>
 <20260202150957.GD1282955@noisy.programming.kicks-ass.net>
 <d6944cd8-d3b7-4b16-ab52-a61e7dc2221c@linux.dev>
 <06d48a52-e4ec-47cd-b3fb-0fccd4dc49f4@kernel.org>
 <3026ad8d-92ad-4683-8c3e-733d4070d033@linux.dev>
 <64f3a75a-30ff-4bee-833c-be5dba05f72b@intel.com>
 <c985a8ed-37ad-415e-b7b4-18a66b4da3fe@linux.dev>
 <647cbe2e-a034-4a75-9492-21ea1708eccc@intel.com>
 <99237729-f2b0-4a7a-8213-65a2f1c57744@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <99237729-f2b0-4a7a-8213-65a2f1c57744@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6996240012
X-Rspamd-Server: rspam07
X-Stat-Signature: 91raic3ikzs8rq6zgzc4mjaue6ppbjfb
X-HE-Tag: 1770309990-530814
X-HE-Meta: U2FsdGVkX1+yrA/0QrrYxCAAjr43LwpdHtfypTqcmoQKyM/WckZyMt8WwaVaN5YPB+SPR2cOc+QrFIA7KzTc4GxAVwEUQDnAxGBNl7Fy+Lj8tSCsjof922qByCBA7YhJrnXCVZr59Gv4TRHiMcQ+I376h9/ufiK8oJ8NfB+UEhGKUceoClSQJCziEoht/ubFeAULiUTsZQkOp2LQCJkLiuzACi9bCclqWGfTiiLK8L+m3Tq3A/PqKkF2YjObaZkYbDZjbmXtsxhrPdoKSArCh/0DQZUgrW1xRLbyBTmb+81vsXiCHCUz7BxXBuLMp75yVfatgNkENYI3agtZT04M5aIaVMLKujeeteTCkfTQ4302ANj+2ylqjYKsbVUNsVOD9/D0FnGYqs/5x7+7mwR/HtuB1mSSfGRqy1h5AXarhPfeofcClotorH7TWovb8WE66w/9/e4NnV+VK4xKyb3N04VuVMTgRAUUhzuSPKiJCajs1Gvp1A4wxJPy81W29PWJJ5etYb5a+E7up332UyUT+bdEW9pZO9vs1Ue9T4lF6D8T9wSALyk4ktJK2ke0++bU0P80671Tgd+GzIt98gIWp6IgXm2o+0RMRUihNc23Umq4rLwD+4jtDKnJPNePSbn6J0hS+85EBqOi8A1dMkzjE+UvD9qBACxYgTwRL6/xGnqJGL5m0HLQ5UVi9hqHqiWYRNF0Mdmc1S7uKccHau0TRMPAgeNGbOstZsXydgHS1vAUJjqnjJjk68E7+J9bphi1akfv9WUUHdLfPhu50QDkAtDRZtD7SBGubOTMuxjwB4UhWR+qWPa/fEoMlsUulHiMPh5xkqvAGy5GNYE8/+VbGqOMXZLEZkYhCpJjCHkQq3Fy705wK//PHUsyZTM3Tsxxfu6SsdDAWCyBGEsuUKaN9U48FhEE1pz/daTz2L+YAjM18LP6s96tTh9/27mEg61fm0ApFMoH5neptiKQ24q
 CWZr0wPe
 1ae2C6Em8p1m9fxEMMCgzYekY4xJw//PQ3cSK819DGNrE1lDbN4hHtisgbfCLYATfz3y4BYDIAeKRBDtJRABs+w+FnCdZmboN2q1uNvY3GYFf0URqLL33Wm0q/LZWLOqXXCn6dLBvQrkA32CkRjK9/IY1xm2hAmspA39NjIBMzdSezBju2vJzDkMOla1F5gmJuoXayqlJMK76GPmNsmVzlpqOZOR7uLoRzxsGfpihvgcPYDutLaNLL+31YQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 17:30, Lance Yang wrote:
> 
> 
> On 2026/2/5 23:41, Dave Hansen wrote:
>> On 2/5/26 07:31, Lance Yang wrote:
>>>
>>> Without IPIs or synchronize_rcu(), IIUC, we have no way to know if there
>>> are ongoing concurrent lockless page-table walks — the walkers just 
>>> disable
>>> IRQs and walk.
>>
>> Yeah, but one aim of RCU is ensuring that readers see valid data but not
>> necessarily the most up to date data.
>>
>> Are there cases where ongoing concurrent lockless page-table walks need
>> to see the writes and they can't tolerate seeing valid but slightly
>> stale data?
> 
> The issue is we're about to free the page table (e.g. 
> pmdp_collapse_flush()).
> 
> We have to ensure no walker is still doing a lockless page-table walk
> when the page directories are freed, otherwise we get use-after-free.

Right, and walking a page table that is suddenly no longer a page table 
is the real fun :)

... or trying to lookup the page of something that is not even a page.

> 
>> Don't forget that we also have pesky concurrent lockless page-table
>> walkers called CPUs. They're extra pesky in that they don't even stop
>> for IPIs. ;)
> 
> I assume those walkers that don't disable IRQs only read the PMD and
> don't walk into the table; otherwise the current sync wouldn't work
> for them.
CPU page table walkers are much easier to control in that regard :)

-- 
Cheers,

David

