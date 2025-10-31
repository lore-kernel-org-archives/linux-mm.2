Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC23ECCF9FE
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 10:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 321298E010D; Fri, 31 Oct 2025 06:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F8A78E0042; Fri, 31 Oct 2025 06:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 235D18E010D; Fri, 31 Oct 2025 06:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 11C068E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:35:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 94FE3881F2
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:35:46 +0000 (UTC)
X-FDA: 84058053492.14.2586080
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id A3374C0006
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:35:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c0ufGMqi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761906944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hA88PfMvT7s/ypjD/Vu1krMCrweTiktQkOm7yWYdPeo=;
	b=kmC1yW1mSjH5mxpBEvX+TgBOHg8wfGQzlDSP0MvHTriW4nxwS+X10VRboemo9ay+wmtUqY
	Wh503xr3LVgYTQds3AnMKeXI7NiSI77r7Ybx9EE/NiELo25SXZT6cTIypaxjFvr4qpWwq5
	llVte/s3fcNsZNK4x3a+a5bxvPv0qFA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761906944; a=rsa-sha256;
	cv=none;
	b=csyOhNse2rx30/oE8MzeRMDx2yW/C8eeQxBOo4bN9jvjSPPAkhGUmjf5kTedd5LQhRzgDc
	2GUM6hbEla2dmk+Pz7iARK0Um3ryYNPB7H8ONoKS+cDx/LvQ+0dv4UzZG7hL3PnaqEQe2B
	tcXaFBAxx71IYcxg1/P7ba5RCFst5X0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c0ufGMqi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <4d2006d5-01c1-4bea-9071-7827b1fb2c85@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761906942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hA88PfMvT7s/ypjD/Vu1krMCrweTiktQkOm7yWYdPeo=;
	b=c0ufGMqiRA30r8ZbzAxJk1JAjkGhKvS/qeIRy1TZUJGI65clbzcFx2MprvLinIt5BYTd9f
	QjWF+cBAlAOor3mB5p1sRWmdG3/CORLLMbRRPWHVmyUC4UqxkcIuyLS9hOoNtxRdBg2dJG
	felui++sKubhXXBzfiguWtQNc5NtW2U=
Date: Fri, 31 Oct 2025 18:35:32 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/secretmem: fix use-after-free race in fault
 handler
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, big-sleep-vuln-reports@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, willy@infradead.org, stable@vger.kernel.org,
 Mike Rapoport <rppt@kernel.org>
References: <CAEXGt5QeDpiHTu3K9tvjUTPqo+d-=wuCNYPa+6sWKrdQJ-ATdg@mail.gmail.com>
 <20251031091818.66843-1-lance.yang@linux.dev> <aQSIdCpf-2pJLwAF@kernel.org>
 <38f0ff98-3dcd-4dc2-87f1-3ea34bb9935a@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <38f0ff98-3dcd-4dc2-87f1-3ea34bb9935a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: ctwjsu8erua65sbi4oj9kckr5ysx1pjn
X-Rspam-User: 
X-Rspamd-Queue-Id: A3374C0006
X-HE-Tag: 1761906944-583910
X-HE-Meta: U2FsdGVkX193DJWX1TLbZMYWWhes1gfYzPxanbbFXIv/cr3AnMCB8ah5l/ecR2VY1qRHY+4Qkg6VEl8XBWHBX1MIFIP+jz4OyzH6K671vFeagH4YpOnuxbVKYVp2c3JNd4KxWJg6jfnJ6e52Ja2Cd2qBSPICMOQzjMgDjaRGy6+WqoiS2AXMo4+0ic+sKXQYV9CJJXduQljcI8zGIO6B1GL7WUBdLxe4rPq2mOrhdCGkD4/O+JYcc2sQ7e/1xi2Ib2z5kdigISFXEmpCHf+N7BS2I0ZNKxYv83ZePitUER6PB0QqIBwLRyW4Ty3YH97LJ62zlu5rPLW22cHFCtP9ff+XTvZN9KFZjnSzzFcplsOtlPXRg7XnjtxEw/pvwm4GFYWbUAqdAPD++9rJufvCvnosWvLq31AZbQaBw3haOcaOOGkFh6J0wln/uiXKutsTUV1zX3L0wgeLCBNZ0mkcaAZBWXtrDQYyCXtrX2nAKUWs8AHlDT1i2qa3HC+4eC4meb/W2YtYuxyKYolKuU0WprEXHE2dGGCcyUYBtq4Z0I7WdYBwL0ihUa3dQ0cCZLH9pI7LlD69NWXx7L/B4FYLA8wuUQzVFenrfFBHiHd7SbXC6ClgwIaU4mVIwjiPJJYSJ7STszUrmsZM9unS4bajw20aqlyHaR27lsYvQlb1VfoYPEA30qJyVf+ve9ZBk6ldrAlEWfmolQl40D5wRsdWszdnHsC/Z4++kw2v/+6PMIMIOSf7MLoXmmLieCM8+ZKtDqRmzMxIb82SbDLCxCVoFukuadfvdVfWS8aG/W3gbQKJUXXxyGkTa1dGtrrEg6xKuLEnnz2dy/x6ARtrZWFCy/VAAizKX4UGWDpb+OeyBgyNevahKyLv1a1Onipcn4XVR+irBwtIRlA/DHqpJwEEfZH2afT+czpvm+nUnOei34v2uPzrU5SbdEfCcYm0EkfYVEGZ/QNZ46OWylEQbXP
 PmX2m/7r
 s0eebtYsWpdAAdnsZK4RTKa+vdZZKbLfNP+WEcfdf5QJh5Q2o3Owmi29BBRtKzW/qV0UpaxR1oOF4FEsWSOOJP9bxEbqS5DZEgtltKq2HXvF28uDcYjPqlVu1V4TPV0YihqJrLrJAHepvf3TRN1w8jJMsCmRNVX0zWJU25gO2dPWOoG+j4xp9dpu0NdqdUgv+vZ5AhxpMj2/BGK/nPGwsSOuAcIzuJafkdEkLRc3QEzVWDLNHnlZAbpwko7GgoOJ+Ieiz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/31 18:19, David Hildenbrand wrote:
> On 31.10.25 10:59, Mike Rapoport wrote:
>> On Fri, Oct 31, 2025 at 05:18:18PM +0800, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> The error path in secretmem_fault() frees a folio before restoring its
>>> direct map status, which is a race leading to a panic.
>>
>> Let's use the issue description from the report:
>>
>> When a page fault occurs in a secret memory file created with
>> `memfd_secret(2)`, the kernel will allocate a new folio for it, mark
>> the underlying page as not-present in the direct map, and add it to
>> the file mapping.
>>
>> If two tasks cause a fault in the same page concurrently, both could
>> end up allocating a folio and removing the page from the direct map,
>> but only one would succeed in adding the folio to the file
>> mapping. The task that failed undoes the effects of its attempt by (a)
>> freeing the folio again and (b) putting the page back into the direct
>> map. However, by doing these two operations in this order, the page
>> becomes available to the allocator again before it is placed back in
>> the direct mapping.
>>
>> If another task attempts to allocate the page between (a) and (b), and
>> the kernel tries to access it via the direct map, it would result in a
>> supervisor not-present page fault.
>>> Fix the ordering to restore the map before the folio is freed.
>>
>> ... restore the direct map
>>
>> With these changes
>>
>> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Fully agreed
> 
> Acked-by: David Hildenbrand <david@redhat.com>

Cheers!

