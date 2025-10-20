Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BEBDCCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 10:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D41328E000B; Mon, 20 Oct 2025 06:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF1EC8E0002; Mon, 20 Oct 2025 06:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB8E38E000B; Mon, 20 Oct 2025 06:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AAD408E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:32:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54D8DC07BD
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:32:06 +0000 (UTC)
X-FDA: 84018127452.05.A0ACC70
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id D15AC120004
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:32:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WaHmBe7Z;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aarrovnk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JYMcYo1p;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QHzhkXy5;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760956324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OOdR9pfKqPD0a3Q4nBDVe6mStJO4QAAfwM2KqhG51tQ=;
	b=uy5ol5OkutTH4JEGq1XzN5ptjwiOg20/U+KhFIcdmS9vijJa/I9VkjFUUtdfr13yaRgqDw
	1bUAnMLxfoZ+hjyaWHl52jBOubIPHefeUVFpZ6jcq1U8Jwy+89x0HP/3nbYUB/GsEXJjAe
	8a44pvxEk0nXqBPfiaAlttWOXO0yzBk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WaHmBe7Z;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aarrovnk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JYMcYo1p;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QHzhkXy5;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760956324; a=rsa-sha256;
	cv=none;
	b=2gMKe6wv4w6l75Ezwko3bHQsmY056NNnPQzPEE2ZkWamWpIMVorSyO44770PIaDS9m3AnS
	8tzfzYyaDTK400FgMJkM+dCoadDOkzWmVLZImnG9oTV5Pc1W0KC+XNxJWxeiJrEsYrbXoU
	SQWg19IygREnqvxZmOJ6e3ONBTRdEJg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0DD582116D;
	Mon, 20 Oct 2025 10:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760956318; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OOdR9pfKqPD0a3Q4nBDVe6mStJO4QAAfwM2KqhG51tQ=;
	b=WaHmBe7ZE1oJC86MBJcU6qbFI1t6s0YSn+Hvy5Dr6UwidJ621G/9W+vP6cfXoy6/iLzVhV
	fMqWPjZqprU7o5rNuYvYRAn1yjZ4AN9mHKnTQPD3V0q6Z9Nng2Byn+HmmNyJjC/kX6G4Cq
	PlKuYg38J9Ut4e4M2uJQSZzs65cnVBw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760956318;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OOdR9pfKqPD0a3Q4nBDVe6mStJO4QAAfwM2KqhG51tQ=;
	b=aarrovnkqkw5FLzzdsHl2oHIZF/qYCrKhaisXTJqGY9bTW72ZRb/7rsQHXKpO4MFfPeaJa
	by0irXzlOjq3EjBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760956314; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OOdR9pfKqPD0a3Q4nBDVe6mStJO4QAAfwM2KqhG51tQ=;
	b=JYMcYo1pjH+WrBomtcKOa/dnrmp3Lum/8QPJVBri8WA6XC1QlQvslYWlIUYqDepToviVk8
	paKTyBlTA1JLo44wXV8S7CyDMSj6g8+Fi9dTYsnO7KJbGCIP8yhtln+uvsP5u4MtSkVXbS
	Xwp8cfV623eV8S8nhUNj+9ZpV9MUxAU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760956314;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OOdR9pfKqPD0a3Q4nBDVe6mStJO4QAAfwM2KqhG51tQ=;
	b=QHzhkXy5c1nUyHDTNV5oqoiXtTtzQf0C2dGRNcH38mhJjJ8NJedTpE4Zv62kFVJohLM9wU
	CoHatHszYU4pzpAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE8D113A8E;
	Mon, 20 Oct 2025 10:31:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Kqu3KJkP9mg1QgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 20 Oct 2025 10:31:53 +0000
Message-ID: <48a24efa-a326-4cca-ab28-50c6251bf03a@suse.cz>
Date: Mon, 20 Oct 2025 12:31:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: treewide: make get_free_pages() and return void *
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>, Jiri Slaby <jirislaby@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Julia Lawall <Julia.Lawall@inria.fr>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251018093002.3660549-1-rppt@kernel.org>
 <aPQxN7-FeFB6vTuv@casper.infradead.org>
 <3e798b9e-4915-404f-9197-ed3c32587141@kernel.org>
 <85707316-3f2b-4e29-b821-a32f9097244e@kernel.org>
 <635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com>
 <3b97b754-890a-46c6-b892-a0324d529a3d@kernel.org>
 <a95df2f2-5ecc-4d28-9bcc-1f9b457b04a5@redhat.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <a95df2f2-5ecc-4d28-9bcc-1f9b457b04a5@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9zunxcotzieyp9qmm9p4gz9ihj4mzexj
X-Rspamd-Queue-Id: D15AC120004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760956323-88560
X-HE-Meta: U2FsdGVkX1+hzBzwXthjtF+f7k8INeIHTa86PgPKSsCc1uu6VfN4xL/RE8dsxFt2eefCHsXx4ztjHTlUj3ATd5AokWmAUZ3Wpt5hj3Auz66Xo48jmlNJjrC1cR+Y/OkAL4olQzcAbVM05pmjfcPsj33AKn/q1X+Pd/epRwHi5gtcxVgUf8k4PT3flCnn7Av/WEM0rpiuvwOXPdSo7OGSxUDXBR+TCCMgp+EYIwZVT6e8hda/mSeIfeP4ERTSvQJUwA7rF8AbCy5r8rTaZI9/H753lPbve2rYw7b6k/svyiwr9yZjkK3ZjXLiXdsqzTb0q4OGLHxZqYM4NQGG+F35rdQ1eb03VtBgaJxcCp0n6VjrQW0IwddrH5PvOf7xDYD6kmuM0ocLIdSaeBSfSjBvq13mJ3eJ0L3Mm/4jXD1e5cwHWZExKze3DLsnfbWDLp1AR5VmCTtYb4V7j333AsuhA5+T1YkAvu4tWdBbuuf/QvC14ylXSaMwwQcviPmcTVmmAxKFbgRjrgvHowqRBJCDkaIxPRhIkFXeApwFrOLh9uYD7qyznprYn2zMnHx1hMpJKYl5OzJU7bDRh9HuRc90Z1eHRdOhzb2xOGNNsINngBuKjQ6WiilIlqbPnBsT9wPN5CGXX5s290PS9fkaL/3qtU0O8/1fQGC7ZLcnUjcG+bjDPQGzjw/j0MlOXl+2oZMJzylANsMope5PbAF+4c5xABYiL/ocuxOHtQ8p/P6CYLkW06m/e8eXWVU8VXuPg9VQgkUNgpMyug3Yh8xyNKG063CAljFKABzHwh5D1dyX95mybdWaXOhr9xdt+5wlCj5qtPh57lvWEo2FCQZ7cE2ksTsrBiPv/qSaKa1Er4sJmC4M+7w4x2mKQJ636U0HUt5PuvIKD4kFR/JU6uEBCa0IPkClQ/i/M7QBV9vd0x/DQAaLS7EsaOTOdngDAwtmo6bqB21b1kFMF452X2ZB9KW
 /g+FCqj5
 xPQJ9h8cuwTWJaXCidXPhSw+wlNJTKkDBiSbCoefWkYfsUNFS8RT5Ukw6oipZQxutkv7E/+V/5lhMtua4UV9TcqNxvFL98P3ljDDBO9z+dEYvCPbxwOHm0sIQ4C5EKEvRz40sU/HKzKSrdFv6WM7sPc7/STqCySJsHesGnjeyTiuDu9xTGyqWwHGobHZCXsWu+XTT7PPX5U3J8klT1VFqvdS/XSjh0Gj0PxsfnXqi4aFcxSY+SoGisrsg7MZ0r/oD6V7qxaUUQ97E5g8wizFpZL2MHcw05r/IGa0CAJe52UdUXvkm0BRV0jbtjVP6qnUv9jHd67I8DqKl11c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/20/25 11:13, David Hildenbrand wrote:
> On 20.10.25 11:08, Jiri Slaby wrote:
>> On 20. 10. 25, 11:02, David Hildenbrand wrote:
>>> Regarding the metadata overhead, in 2015 Linus wrote in that thread:
>>>
>>> "Long ago, allocating a page using kmalloc() was a bad idea, because
>>> there was overhead for it in the allocation and the code.
>>>
>>> These days, kmalloc() not only doesn't have the allocation overhead,
>>> but may actually scale better too, thanks to percpu caches etc."
>>>
>>> What's that status of that 10 years later?
>> 
>> AFAI skimmed through the code, for allocations > 2 pages
>> (KMALLOC_MAX_CACHE_SIZE) -- if size is a constant -- slub resorts to
>> alloc_pages().
>> 
>> For smaller ones (1 and 2 pages), there is a very little overhead in
>> struct slab -- mm people, please correct me if I am wrong.
> 
> If it's really only "struct slab", then there is currently no overhead. 
> Once it is decoupled from "struct page", there would be some.

Yes, but there's potentially better scalability and more debugging
possibilities as benefits.

> IIUC, I'm surprised that larger allocations wouldn't currently end up in 
> PageSlab() pages.
Can you elaborate why surprised?

