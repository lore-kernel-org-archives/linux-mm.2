Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEE18CD4F21
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 04:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 952416B0088; Sat, 16 May 2026 00:06:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9038C6B008A; Sat, 16 May 2026 00:06:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818E16B008C; Sat, 16 May 2026 00:06:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 74E556B0088
	for <linux-mm@kvack.org>; Sat, 16 May 2026 00:06:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AFFE71C0D48
	for <linux-mm@kvack.org>; Sat, 16 May 2026 04:06:42 +0000 (UTC)
X-FDA: 84771946644.27.50CC604
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id BE804A0002
	for <linux-mm@kvack.org>; Sat, 16 May 2026 04:06:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="m/T4jWUy";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778904401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=csEBmhV4pBMWZ2fB04greY5anYTJC5J151pnKD1dZ50=;
	b=7eYy/8EHZCu4s0A2GQ385RkwrxB2RBdbDRU3xi9HXy4mPf2rAb2qf+xZE5QQzlmkBUwt9w
	MLnz15Hra1zdHHZ1hh9sqVYx3Ui5WOLXXfagMZYoJmZCSGa4AW5r9UHKLHiFBeaI7TXc0b
	XQ0nHM2QxE6da/Pj0aLlrwn55NkmQtw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778904401; a=rsa-sha256;
	cv=none;
	b=ErKHuV3iq0xzAcyhd22aWnXejzJJxQq8vcnNzW7daow/x5f0VGaWj/4hpYVQvtwbXaM/hy
	c9U5KoZWIhTUHNa9hUhO1rBHdJDB9IEzxAQM+W7g7TVEN1mfXp+C0pECvHruee9+7CFyRL
	gRhzfhLSkQP2aYHgAGEUYg7rd4IWvv0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="m/T4jWUy";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <f76b79d3-080a-4931-873e-99d4b3e1020f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778904398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=csEBmhV4pBMWZ2fB04greY5anYTJC5J151pnKD1dZ50=;
	b=m/T4jWUyKVPBrEtgI+LssBYE8Jr1JtMKr0LC+7/kLTiQQ5hs1U9JvcXG/ff5kGZB9kDH8j
	yfg3OKQY/qc5xL9N70vxIHxOISGzjIXPdS29DbHnveiqosMrQEKPuglL6ufFzM10cY/+yN
	CEhCLgcRYDzRn7tVG2TNL9cq+EyTS8I=
Date: Sat, 16 May 2026 12:06:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v7 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>
Cc: linmiaohe@huawei.com, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, nao.horiguchi@gmail.com,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 corbet@lwn.net, skhan@linuxfoundation.org, liam@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@meta.com
References: <agXcPleVC9LGVCmj@gmail.com>
 <20260515070353.87244-1-lance.yang@linux.dev> <agcbfLHT5ZWnNeN0@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <agcbfLHT5ZWnNeN0@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BE804A0002
X-Stat-Signature: ofgui3ghky9c81iid7czceu5c4qrf3q7
X-Rspam-User: 
X-HE-Tag: 1778904400-147959
X-HE-Meta: U2FsdGVkX18Y7KAuUNuVf2DwLmJ3sQLZu9Lla3H8Ne786T82ST6Swgx53dgcdTDWuSrZXodzDR+dQWbNpCcjeJbDUgXje0Now1PF2J70OIHuMR2uHQNHFIFuk57DDyc/BIRcHC8pxNlpT6saaJZUBcaHQ9I72lZm7g9QfhXrdiikCtonLQsvwr6LvqO54g/jZ/NajE7TVsuImuo9Ng5aiUxIz4wIz8pEc55ui3Rlfr7xmu8hL6ArvMH0/owUASm00CRJh0ukj9kwzVbOockZs0BoCjptbIPJpxvxL/+8IM+7oPb+VSSTiCYXXuOcPTptQI38/Ontect23KCgKXdmI4gAjrBu9Cj1sRa2q37J3jI/Wez+4KBtBCcwKR/eUtH/ge9cfXmEmEFTW0JHsuhLBpl2x1vZ1rMci7ebpe1wGKYmwKMxMkE3ZNNjuAYkPwrvBZq2wYs1muud4wlY8yhmfokaiUt0S1AoQu6WFzh3gAoJnK8DI7XOPWD7vQ/pJWJ4pZb7grLSUMBQnWOF50cMdYCdTggIoQnysSu/AapgouDu3wdWAJTidmQsG6vwkFZkl809/EFMH2Dc3NVnsC2HIt534sOxv2CHMnt3yKzqDMd/XrabQRcoy7lohG97H2mLPN6ctaMo8VirJHLLtqGDbpFIaMgQVJOmCOrBUxOwfyGBGTi+pZsYDzpAq0Y3ML1EXQhU2ejgP7Py4RRoXyTb9XCtNxA/Kroi+AJwkIUbIf5IVAVcwYPA6GjGLxDsTG8BUqIlZWUiIJDiIvZe7YGxbhuVRoWzFSRv4fzIYA6ubAkVsHYZRk8KqtkzXX/9aTTMpEbQZLp/aal8T/gYbT6dhqRTMS3q5s/FDEs5b0Md7JF13ODcKt0KR6lePvVLzHk3B2iX0fGvJVaNHEDYdZd09axQfmAZxE7Iv6KVK8eSqjUWPBb9XKnEGSJBSPVJ+FVBl/9TvEDayl74V16z69+
 TgXdd2OH
 dCHRUK2bT9Gg8oSiRAr6kdUc3rNfq/o8xeF+F2jQfUD50iMNBAqE3CtzRQZPFxgJ7Cvmo+OoQHeyGrODajv8/GgqV4YDx5ykkoW04vC80A6fDKLk63TgDJhwEBJ9L1Ya5eCNHxPZgEdwV0LyarDma+4whrUlQNt8sK9D3q3vGW1sxubFsqcTFbnFKZ+z87dTeQNK7O9YNkM7MYCO105XBRyKtPeD2J9M/f46zAedRWvLDwx6EK4xsQNPXp5TBR8wsqQJugmJvMWe+mRAIUft8HWT7AQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/15 21:13, Breno Leitao wrote:
[...]
>>
>> Wonder if it would be simpler to just do a positive check near the top
>> of get_any_page() instead. Something like:
>>
>> static bool hwpoison_unrecoverable_kernel_page(struct page *page,
>> 						unsigned long flags)
> 
> Ack. We probably want to call it something like HWPoisonKernelOwned() to
> follow the same naming sematics of these helpers, such as HWPoisonHandlable()
> 
> By the way, I will re-include the self test back to this patch series,
> In case they are not useful, we do not merge it.
> 

Sounds good :)

Can you also test the relevant page types if possible, especially
the ones the new helper is supposed to classify?

Cheers, Lance

