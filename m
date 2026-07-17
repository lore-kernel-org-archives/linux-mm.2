Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CC89C44507
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 07:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600EC6B0095; Fri, 17 Jul 2026 03:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D87C6B0096; Fri, 17 Jul 2026 03:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CA3E6B0099; Fri, 17 Jul 2026 03:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 248D26B0095
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 03:07:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9AE95120492
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 07:07:21 +0000 (UTC)
X-FDA: 84997387482.25.6AA3373
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3942A180004
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 07:07:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FYcbXjoS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784272040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F0VorFQubA72e/tCA00Fb2KLrFZdh25LwjH5MvlC2w0=;
	b=C5rn+huftJFzXRbSDu+sE9QnmPbaLnIsq8DG8Imwjl70x71Sm0OchYkoP/KB/dIFgIsA6X
	SWHrohEJgsyS36JCwtdC9kRAWLIyoXVoMZI71d+5ejzOJkZRt7k0tm/VL87lLTiR+YncUw
	Se5isBJH+dB9Huz/q8VTnjivb36ii7U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FYcbXjoS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784272040;
	b=VUwrk4Thl2gqF5L/e8vCrwckVNoDvjECPp5sDJX5SHj4Td+xrjn4O18nEYb9mHYF2bCUps
	80t5sVytNJGWOWgEn6GRkGqpI4v5FqYu8BVUdgLqTHC516DZKEW48ZMdm5xK2tACwb1gNS
	WqJrJtizT6Qf9dsmW+N6HdVOYG4IlJE=
Message-ID: <4d7ee6c9-ea5d-40d5-9af0-5c15b3c2cab0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784272033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F0VorFQubA72e/tCA00Fb2KLrFZdh25LwjH5MvlC2w0=;
	b=FYcbXjoSXSnpuaPUdr5wOGZcmcE+/jk7JT8DQzKA+ZKQFQ3nafMenU+ozew9SvtnyWa6w6
	oFfczig9lfYag1nidAQh9OO0xfrwQnRNPSZGoO12c2OuAUHUtmIEy36w1Z/wAV/XQiD3u5
	/aKrCXzpCOj80LUY8XMujoxAlc4X86g=
Date: Fri, 17 Jul 2026 15:06:52 +0800
MIME-Version: 1.0
Cc: hongfu.li@linux.dev, david@kernel.org, osalvador@suse.de,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm: add missing alloc_percpu() NULL check in hotplug init
To: Mike Rapoport <rppt@kernel.org>
References: <20260717052938.58447-1-hongfu.li@linux.dev>
 <alnPz-r76FU6t5Uc@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <alnPz-r76FU6t5Uc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3942A180004
X-Stat-Signature: 6fmnwp5x59yy7163y33r611fza88mecx
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784272038-167357
X-HE-Meta: U2FsdGVkX19uQliQ6bV8WhAmin+bW+qyyDu3R+BfCdt0NrlNiECIF+gJxSLj/RHdNB4jQ11ZY7rB9SyNKsIXHuYMKDUVTZusMVP39BA/UleB2xZ1gvJToC76pVw1Jc5Pqt4Qb8jthSUbSBS3zNBh0Hqi9ItiQEK7lGHmvJz91WzLaVHC7WOPtxQjIbfNO+8LxPjKzyIyHMmkuSmd2G1JD8WqZ+HJakog61Q83DezW7ElyFqsOjBFZh9ymMR3GvdDl8XsHGpTa6xYbv/ThG613LLoOctBAhNuqUWkR7TuSaPtTf9IWlbngHhN9/bzJhRJ3M9zQCCC/NIP+F9kEF+QWdRV63aHY179JCIN9fx1AFYWb9gu2nvnK28KZU2WHdiqQuq0MxnAO5ip3qWOFHM+SwfTvyWLeuebzQb15eYDokPiSdaLC153QF3qlbExRK4Zo1lTcDvSGVnHASU5Vi3FyEqSPd8E8pTz7sUr9pwwD464pBR2AL2FTsnhEImYyDYA9+ZDnksR6EPMTuAn33OYNqQ468BJTpnZhC6ngiPxviuRPSwu6SCXJ7fYGJimimEI8sBd8/cn/76GYhpN1wxBCmBYrbZX3Ot5I7pK/LHkFFSm7gvwInbnPQrQxQd+FKxj0YAK2IXBrXWBbeyVXZOxn9bYQaImbzNWmtVIetQO+5IOgPzziV69YLyLz1mIAb7dB/q24WKwTrBEY9cTnXkpRUm1/cW2rAPtM3rG1fbwRCxUIZ/4PNUaRZZCgG3mGVfdpdD8Q2UmRcIuFJ3QU8kloVyOjuN1pdBFIQR37VCdrDbZPdxUCvJMpc0l781hMpHbwLwCOaEWaKbwMtZjIg2bUclDjw21b+lppbRvEjivfyZCs/ktlDkrcv85AhijqR+b5ykosxyILw/8m+3Gx+eA6zjMzNLxnRgY9iZk8+G/M1J+RH20tL90YpHDzNev2FwpqhXFhpT8g/FI24SSZX6
 M+9Yimxy
 lyQHcqwTIzekQSdkgI/cjyZP+bbpEBk1/xguClakoTdvbO8y01QIG0AHUA1lYMHFo+EQd330ph9yauQ6DXNTQuMP0J3cPV1qMFj0sHPjmI8XwM9AZ35TcKQi0K4usAWaHPJJWLvpGyGXm2eNd9cY2tFlLi4nEAhA1iy02mFouM+ZaKuKUGED2pV2PsetzXCTc5b+ovrrbg4i2jvJlm2xP+p/K948N+UkXobbF/OpZZINPH2TLgxLIMnjLCakxNYaX2KzwDZ3nUxsrP9QSXkJGvNREjzHAwILSMqU+aWhbFmRfhLk8Q3IljDoT45CXPPdeiZ+n/S8uprGaGZfFFeXGquU1fqUY232gDhV1UN5VAnQ0F2RnVHLrQupVjkJG1Fps8yfKz6qjZEjk6+0N845KjtzgDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 7/17/26 2:46 PM, Mike Rapoport wrote:
> On Fri, Jul 17, 2026 at 01:29:38PM +0800, Hongfu Li wrote:
>> From: Hongfu Li <lihongfu@kylinos.cn>
>>
>> No NULL check is done for alloc_percpu() when initializing per-CPU
>> nodestats. Allocation failure leads to NULL pointer dereference
>> during later memset.
>>
>> Make function return int, check alloc_percpu() result and return
>> -ENOMEM on error. The caller chain already propagates this error
>> correctly.
> I already applied a fix from Gregory:
>
> https://patch.msgid.link/20260701221613.2818148-1-gourry@gourry.net
>
> It'll be unstreamed soon.

Got it, I'll drop this patch as Gregory's fix is already on the way 
upstream.

