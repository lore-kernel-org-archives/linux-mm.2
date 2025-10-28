Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13D66CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 18:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5F4D801AC; Tue, 28 Oct 2025 14:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0F9880199; Tue, 28 Oct 2025 14:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE96801AC; Tue, 28 Oct 2025 14:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 99A6480199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:29:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3DA1A88597
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:29:46 +0000 (UTC)
X-FDA: 84048361572.12.65D5F1E
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4D1941C0004
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:29:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qIZ8AJBK;
	spf=pass (imf21.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761676184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3zBQtGS5UGvIEBLvL9hj21lqEc3c0qUJSEdistyCuk=;
	b=iGF6DWHZ561W8PHmT9GAu07hZmBp+4D9SNU7PmvxD5ONLY6v7D3UNLV1cSNLvkykY5zgrC
	VQnKW/HaYQo0hVyRL6/7WUWgYALfsz6D1xnzYnntpzevBMuojUQJvGO+q5LTB9R/6KZqoq
	bfwFGUqlddSNKUAxTtsMcAHyZQhlwOU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qIZ8AJBK;
	spf=pass (imf21.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761676184; a=rsa-sha256;
	cv=none;
	b=dL1RRqDiT45GnDd+haXrXPDuxrHZ5Oyti8FMIMz7wzCQ6mo3scWskR86vDOSQJDXW6B6Yl
	XaEMGAeESFe2okyMKFSzFbE/3wo4emtDSV8Hmb1obrYNia6FNorGWmkF9c7Wd+OVBA2xtD
	gQr5eCVdaVYh5N6XtSeleqDPHJIXTGA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761676181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l3zBQtGS5UGvIEBLvL9hj21lqEc3c0qUJSEdistyCuk=;
	b=qIZ8AJBKRpTsZhTVBX8Edr2jXIPkePuHpcUP4LnnxeBhbhURlb4AkazZHMqQhbdA2iIIxP
	KRw0KGEq1ug/oVFhgFOLfS2wCTV82FJpYM1jDV8hQSXhoAPOr/oTSGvz9Dks/cFRIhcqcy
	9NxQ5iQmyVGPw2BuwK2GE9tZg3xm9LM=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Andrii Nakryiko <andrii@kernel.org>,  JP
 Kobryn <inwardvessel@gmail.com>,  linux-mm@kvack.org,
  cgroups@vger.kernel.org,  bpf@vger.kernel.org,  Martin KaFai Lau
 <martin.lau@kernel.org>,  Song Liu <song@kernel.org>,  Kumar Kartikeya
 Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v2 20/23] sched: psi: implement bpf_psi struct ops
In-Reply-To: <aQD_-a8oWHfRKcrX@slm.duckdns.org> (Tejun Heo's message of "Tue,
	28 Oct 2025 07:40:09 -1000")
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
	<20251027232206.473085-10-roman.gushchin@linux.dev>
	<aQD_-a8oWHfRKcrX@slm.duckdns.org>
Date: Tue, 28 Oct 2025 11:29:31 -0700
Message-ID: <877bweswvo.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4D1941C0004
X-Stat-Signature: 79rf3dcgm9oeijmme3zwhaf4ua1tj5f8
X-Rspam-User: 
X-HE-Tag: 1761676184-918766
X-HE-Meta: U2FsdGVkX19zYjF4i7o/WBL7OHGXJSe6f4k3kLzCco9ngg1mKB3QXe4WGW9rBFSV66CyeQ1cxC+6jxpmhn3wyHbdZeF1aQDctViqps92WpChd1QItqGexxeyAlcqEgxOAhznwJAO7c51qVGO8RyZDOJiUlABSNl148femIg0KCmwDZjZU92g3r+7Vsmw8pFW+jCDRISfgTTGchC9+qw0BnKc/nK/wma5pHDu5Z6uiABA3hjd3BiSbaIqEOjvAQXxgmKqmD4ofmXLcVh1gByRlqwjeByjVknI44sZu9QuN2ua5O5ttYuorGDsndYD34rFEelg7wBRf6FKMn/nEhK2B12tlmDz7rJ+N+cbXgqtik7utUW1+bqAIADjlKZzmpj4skh247yRHzoS9KFLdeBnsO3uwZIZR9+sgMVHCyKyZF4cRHEcoW2Rr8zWHD4blEAUcKnfrR3+J7tZO5GVWgS1hE/YAVWgqvY4BNn8fqBotm6kuejUCjazjjzatVk/vLK8X8yZhZB5EYLZ8zNTH6egTdN5ZfcFU66uJs4pzWfcNq6YnWPj+Ql2ITCT7j8LVm8Hw047dkkHJQ+xyzFbX3/me5oxFCPb/JwQ/5g2Fd7YQYft6c5BjQ8R8oi47luT7TtotnSFk2rhbmoxG0ftjSxLJsz4K4FPyFBew7d6RZiZv4LlFHifrl4Q1CdPQZNeEihKXIzNSnhIa9aJjxMQWGXLeH0wbl9++XWgMWLoCNvMxy7iecAFDpGFx1uwPEZv4Qd28+SzIYAPjw7bGgsXOHNwr5jN9CU8MN5xfIUYGH67hQgkAYAoqBL8+8mP785PTk85DjkS0i6GtzCHK3rmMnbNWZRrlM8c+kKWccLr6h7EqOIwdI6z6UEhMiz8I8Xe1RAxahHdXfAkdhN0nd1oF1mxEAZrwVTFHqJRrsfFuRO/EYxPVpf2m2DQOhQfPfXaIuRNZYSIpw0bn7T//02a+y8
 E8D7Cg+h
 TKKE1zbRVS4CX22Q6j92/kfKclQ7Kxnae9zuRTl9soG+AdYS6AvjCImVhgLjt9ekRFSXW055UySwl/acYZ76sJBynvvYHXY5NWrlSRJxotYwo0pa5m45Pji7m1pe2I8hZK3n46THDtxck12E4arYAjTafeED5NZ80i/HonYH5A3D1eHVF2dL08742GveDzsXufaJSh1L4TLihO94JS5N/pIJLHY+9sTS/32MdnHPrSnsvN3s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> On Mon, Oct 27, 2025 at 04:22:03PM -0700, Roman Gushchin wrote:
>> This patch implements a BPF struct ops-based mechanism to create
>> PSI triggers, attach them to cgroups or system wide and handle
>> PSI events in BPF.
>> 
>> The struct ops provides 3 callbacks:
>>   - init() called once at load, handy for creating PSI triggers
>>   - handle_psi_event() called every time a PSI trigger fires
>>   - handle_cgroup_online() called when a new cgroup is created
>>   - handle_cgroup_offline() called if a cgroup with an attached
>>     trigger is deleted
>> 
>> A single struct ops can create a number of PSI triggers, both
>> cgroup-scoped and system-wide.
>> 
>> All 4 struct ops callbacks can be sleepable. handle_psi_event()
>> handlers are executed using a separate workqueue, so it won't
>> affect the latency of other PSI triggers.
>
> Here, too, I wonder whether it's necessary to build a hard-coded
> infrastructure to hook into PSI's triggers. psi_avgs_work() is what triggers
> these events and it's not that hot. Wouldn't a fexit attachment to that
> function that reads the updated values be enough? We can also easily add a
> TP there if a more structured access is desirable.

Idk, it would require re-implementing parts of the kernel PSI trigger code
in BPF, without clear benefits.

Handling PSI in BPF might be quite useful outside of the OOM handling,
e.g. it can be used for scheduling decisions, networking throttling,
memory tiering, etc. So maybe I'm biased (and I'm obviously am here), but
I'm not too concerned about adding infrastructure which won't be used.

But I understand your point. I personally feel that the added complexity of
the infrastructure makes writing and maintaining BPF PSI programs
simpler, but I'm open to other opinions here.

Thanks

