Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E631C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7AA6B0088; Mon, 14 Sep 2026 09:57:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431546B0095; Mon, 14 Sep 2026 09:57:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FA106B00A1; Mon, 14 Sep 2026 09:57:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 01DBF6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:57:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4587A16011C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:57:18 +0000 (UTC)
X-FDA: 85212519756.02.CB32681
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 59CCD80002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:57:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K20TONwx;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789394236;
	b=jp105rwie5pOfu0mqBWq8KgqxOQTzwO0oW4dCfRi06yMMuqJogQ30GQWEXRFTiWNaCLh53
	ZX32E1KoRC5JSp3L5oISfINgWG+hX717kLCzXhwHzgPjp4LFszlB9RaIDnaZdNQbLuFBMZ
	iNaMK7WVoszxoFclAx4fEKjs+h2Ye2Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K20TONwx;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789394236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q3jTCo5Zrmr3wVVQs4J2MuJx8Av/2jYs7lg8QKqp49E=;
	b=G7L8lqzVS4BIjAScK5VAO2GOeDmY7go3r1d3nusCmbj1NSI3IwkQp/hQKtEa8o3xKhY0VE
	7W03pTe18I7o+CwFH2m5ykdI/OFNDjYFNJL5IZyg2fN2awLN98fkeNSNFkWA+20/cAXruy
	YxUc4NQJdAJEUS2SwNG6YSJ8XEc9+Ck=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AB574034C;
	Mon, 14 Sep 2026 13:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49541F000FF;
	Mon, 14 Sep 2026 13:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789394235;
	bh=Q3jTCo5Zrmr3wVVQs4J2MuJx8Av/2jYs7lg8QKqp49E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=K20TONwxzBEU1Zu7mkOTxd5YED8e+Y59q7/Yo0oiBrkANvddumCkJS+TvSxyNaeIF
	 H45l9C8qjM7zl5GyjASyOdXb6m8/wN+FaFnD2IaNwzKJOyajVYG3F8spJMUf2M/1oc
	 yE1+/JgGFYg5HMgg1xYmgJ2j3Am/tt+OrGB9kq9EG/CU6kFxYHpCzaEPe3qRa+EZSx
	 eHv08z08nJgSYyJ3itkk5py9mOenvfgjWjLJ4vwXKO3M90FrXVf1oz0280tjyTghcA
	 AixxEX7dmnMCpPNluxp6KPGtAoYGKi8oG8WkCbbWBEO11HtFE/kEFNPxuHOyZ/UB4q
	 5Q6xl0UDo3zMw==
Message-ID: <9f28f634-9015-4b62-a197-0414122ddd4c@kernel.org>
Date: Mon, 14 Sep 2026 15:57:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/12] mm/sparse: rename __highest_present_section_nr to
 __highest_used_section_nr
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-6-008fc8d579fe@kernel.org>
 <178937914266.4188640.6188797346240816067.b4-review@b4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <178937914266.4188640.6188797346240816067.b4-review@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 59CCD80002
X-Rspam-User: 
X-Stat-Signature: xfhim4tx74expmagh3u8m8rh6ap81btm
X-HE-Tag: 1789394236-453161
X-HE-Meta: U2FsdGVkX1/tChinGXBuutlWqc0hKgGCGWVuJI7f/Ot3khEF8WujosFQF0IC+s7tOwg7umTEnXoXda1awz8HxSLbIoCk7nOxfd9z+rKTj68FNbpexkHnbWglboo4OXMIpBvItRU2g4ZkvFO17nQNojabHcnkHtH9L1bZRPkVqtKmVavFj+jePrqbrSa/89yZYRXgj22cvDlyuVwgFEnt/QsrZOyKqglV7O4Fb6nkA2yyuwT94ZO15epoao7raK7xY8QSJC+OIboMOn7+pi1o6jQkQTyuAUHGssijH3cL1lGYKiR3LBBUZBlYFMdkqewsVwnVcg7neIYT9dJV9LMZC4+agDDKjR8Qmexo9lsnF3ajTWDaGc0uLJ/XRBHGf9P2/fSH+lEUF4XQzK0DkFn+FMZGv4fikXgs4zcBQXRn6j+JRgXyKY1gbIorD1koWCSuKbCj16X7+y0jv7lxQuEVHaBBtr6fxsmM7jFxX13idCZcCc4kzjZ1MEv8Vo0JJIbxYNC9J6AxDv+LesEc0KbeMYfIP1fwojgIwT4v8hUqOxDoJBxxoqw9AQz+LluKcM1gfflTGT+fohR+uZ6zS9Ad1YMrpukv8OiKxoFoqPLLJsZXmDvNdwowvDDYeO7DnnG/3Vd+bOUUZo/DHlTMy2ARO71i5lhyiiAg1XaYobeeL6FzLIW4F5ldmcl50gg5E/n4Nh0hv6KHmn4QEgWlVo3gQGm3KhAkjJSPvqVw6RuQApnTiJBbN5FrXP7G90AhoP1bCVT6X4t2WgMAzSSUTz2Y/N3pyz5Jf6VLRQT5N96rD5kXuaW9B15qVTAHC1JWSqEktYbadchUFxkkb/JqO4KW9QszJueViSCCuOjWqSiOlotVYfhz3qdQa5BiaiNRu8frC+xA2OICx+OhfICA01GOeie0vLQmA1FCfXw0M3u495ecORyT/11KeWY0EA8vig79MLJeUzjavMFoOvKWGor
 V5BMkMK0
 YhaHdbA4nhrl+C45Cat+zhomcGdoT+bpaYVAqDX9c++CDrqtkdiZ1mUMER9o1V+fM9BbW35p6zGlzjivQL0AA9CjsKXRK1EGL5j6wQLOaTRvAt+RuNS0in+q1aL9GFdhuJ3bk2PwrrObQ5Sc6DJF0GuGW4cT/Rg/onR73xv0J5f4KWRAZ2M/1Tc8lknfLCHBJTlLejNmEeo6t4N8veWOiEIFhMKWueEDl0sSeRtRRgSsm+abDOLLy9wTvCyXyD2ZvDdjQT6kYO4MQUjMYXpU9QiUrLvDY+zNBBNfC/Ke06FtxUc/UZlQ268d7Yg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 11:45, Mike Rapoport wrote:
>>  /*
>> - * There are a number of times that we loop over NR_MEM_SECTIONS,
>> - * looking for section_present() on each.  But, when we have very
>> - * large physical address spaces, NR_MEM_SECTIONS can also be
>> - * very large which makes the loops quite long.
>> - *
>> - * Keeping track of this gives us an easy way to break out of
>> - * those loops early.
>> + * Looping over all memory sections is expensive, especially if NR_MEM_SECTIONS
> ... all possible ... maybe?

Ack, thanks!

-- 
Cheers,

David

