Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40FFEC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54F9C6B0092; Mon, 14 Sep 2026 09:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F90A6B0093; Mon, 14 Sep 2026 09:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C06B6B0095; Mon, 14 Sep 2026 09:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 120106B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:39:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 25F8712016F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:39:11 +0000 (UTC)
X-FDA: 85212474102.20.D5BD54D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6DBBAA000A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:39:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QbM1o6vT;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789393149;
	b=3Lp3AHsNJUA4UYZdor/HLZvDMjgXqu/zsao/TSqEAmF4m/WfesjNBbeterxvjlAKVJwiLv
	MiDe4+/FfPVIIVNQXXNQqjsQfhCj22MeD6sS959ah/omteHmW2M8U7SF+wyrvVNaPR9bMw
	D/AZzOHosnUREfTChLIKLecajZHMd8E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QbM1o6vT;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789393149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9BCqD8kAZuJn9pHsxZwwfpeEhm7EpPULp00Tm/xS4r8=;
	b=Jx8v2wpagljwLhpxHSUkApzRR63b/tYZCvI5ysTVWJ8/GxIsRQmkFQH4WYXVj3Gvu4zNWb
	k880bZ+e97qpjruYgeiBSGaksj1ZJAUZ7xAQM+Xpq2qBNlZvSs4EpbjNEYgeUM8CawEiJc
	KvdrUpdf7EHfsMe2tOhcb65l/+GRr9k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EEBEA60120;
	Mon, 14 Sep 2026 13:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0AC1F000FF;
	Mon, 14 Sep 2026 13:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789393148;
	bh=9BCqD8kAZuJn9pHsxZwwfpeEhm7EpPULp00Tm/xS4r8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QbM1o6vTrDEZV6964roF4n6AhcrTROnyGsSuuU07RFZAt5GA0529PbdCzvBeerMPP
	 dSXsFcCmoiGOIJ9z0rdabhNGzfShcpecqZa792W8o53k1tNCcxbKMYTIn76NlPYivS
	 o6lNDIpaoY4pSXfq84dX3tgv4rzDYcq/oivh1LMOc+h5jcsT6fxNz/kcQ9s6wAEREs
	 c6ehcEF/Vx42vqZaLgOSZ9pL/yopB6aAiEYwqR0LdkCDaakbCzQpTp33BHJxMppKGm
	 9guiCSmyCYsCh4oinrfdMK2WTTZgm5S+2CSEaxCKN4lZYkmGVMLt1tLKR5UkN5r4hT
	 uZV8w+oGxTQqg==
Message-ID: <a4132624-c602-4d93-86fb-7d9369646223@kernel.org>
Date: Mon, 14 Sep 2026 15:38:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 16/16] mm/page-flags: remove PG_private
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Baoquan He <baoquan.he@linux.dev>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Jan Kara <jack@suse.cz>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dave Young <ruirui.yang@linux.dev>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 kexec@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260913-remove-pg_private-v4-16-848550f7574e@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260913-remove-pg_private-v4-16-848550f7574e@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6DBBAA000A
X-Stat-Signature: qumhxywdab8kbgbozfnbna4rewkqamj1
X-HE-Tag: 1789393149-568134
X-HE-Meta: U2FsdGVkX18ykXYhb5YLzpIjEU8lw2vwvJD4yIKxWTzCELbTFa3ygRdoSGnn9OkcRkmm9f1JolciBsNZurXfB5z8oqU+k3oMFVmQS5rfujVuQCQxryU6qwERPi64ekZnew3rn27xr3Iv0WwKdB9StzV6l3w+QVQRkU4EodL2HWemq31C3pstFi5W5ojpl/GW8oFtaWrrt3RQ4RebSni03RdbURPIe149Sc1tRQPs9mCy8eJTAy6GPlJ9rk46b2nQ2/6sIRQCLWgeNkPFbjtmigHchLc/a1kWWFX3HZ9AGVjZrSYSsJajQfirBmQTEWuPHiUJN9QxdPpNptyR+Mu6JdSh5RprQ7djB9kUcJJaSeGJlc1k3vMJvJL/R1vBWrNh/TuTabWhrllQDnyFy3rA69iY4oOq73f25NerZTSiPRBzILWnUvQ/qOrh2NBLGgfn4vcB3sNSaRRIRElU0V5JK76ZZMao1fVYlCAy0byGa8ec+vEW5AQ2Q7Rvc1UDLCxVcanvXfpfFSlBGjB24LaP+nUbT6faCuykgxKVZ31kLdoH9Yn1LAVABH+ET4KsEBY7F9bKJe0KTSjhEcFdiSc6jtjFKwI2pO4buYp+btyWiDC1BSAjWzCJldc6TjC1pe1AhVMNZ+Khw1XkjgcQX3scokkVigpHEYVfOK/VjgFf3STvRZzUPFkyoE+UJhWWdKaqeOLiWZJSOreCbilMHOfjwBTzTdVOFym5R8LeI+deNQRW+ybPAN5XUdZ2M3FDSG4uN/pZJMaARFW0aAl2RjN/99wW2VtdLuEfe/PcNj4Tgyi0Zdq2gW67ayyjAVseEezpJk0eB5DLfZuAikREOIVcSrur4kE1iVa5knfqtJRz4hOgQyOIzUoFIsnjMY0TBh3Mww7ME6EwHAClY5CoZDTqWLH2IBJheJmmlNhmcBQoVv69tpFxqXrNJIAikwo++YJvLI2mcdAa1rmocnoyiq4
 fvS/epME
 bj507XJFTO/zfGX587rZco9JuiXe6i1GgBnM8WIPyn2yPmOfYZ7kTFP0s6pS4mZ1s0xbvRgeaJrUBpoRY49dDLCUdDjY1K5BQ3yAK3buadf67pVmbo6jSvm0Crb/YwLNAlMezcviln3QZbweSpLx73Obf6PMnCAx4vC6ZkW0Rv2xV+GD8Gn3jvUYxwqmMrndmNVjQjeZyUs8YPtNtMIFAg3wrMd45Ok4RdLERFvv5dtE2DW0QV056GPifjjI154ltS6B7zXCuxtbb5K+BfBGEsnhPyXdY3LJCPH3d8TpGy498R5p+sVzaBdURDHqO/qDyrFFHfU6IKmxqlPUcBAWlRn9ZnmCDwrmLm1Zxt1ChYN360B89lRZy8dZfYi/NExDX2oa/uzR9vof+hgSWRdhSIf2iUmqgZ5K/WNgQAzeLMTrIN7lYJqxPfhMznY/qcm7hfVE//iwJSw/A6D/KBCifZIFBI6n4P6G2AD0WSxnnfUYSeQ5dSNNeTT3omdGu6QMAtPeCE/OqHF5VcDyFZfrArJFS3FsoCzNk+1pzptxONU6hncNkCf1gigTzl2coxYjlMmJ/Ly75I0zriYLlHMFoW7CVh8ShSTCFolPglSr3ykKXzbsR/afOD4xaZf4nDAw8MNU6ZpVhgciBayvVBaQvZDz99xqVE2H3nkG8dAO8xP1axEg79YKVp3Vgfs0vrbENNJHRXLTNjTEWxPTMpLAlqovzDGILwIflN/34wRZyOZHC/n3XvFeEIhwD8I9s7bWEfUfRdjdIfbiwJnyz7Uc7oZvvZZvZaWv6RR/uU8GlPtRRXM8VDCBJZd6IDa42JpUMrtllaXm2Mvyncbu4wPvoLG72W8IYFU3hW8IlD3SgIN0WB3B5LfKW62RFnWksA6ojn82rwvUhZ1BmWPQ7htpA5LG07g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 04:24, Zi Yan wrote:
> folio->private != NULL indicates a folio carries private data, replacing
> PG_private. All PG_private users are converted. Remove PG_private and
> reserve the space as PG_folio for future use. Unused PG_private functions
> are removed too.
> 
> Assisted-by: LLM
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: Baoquan He <baoquan.he@linux.dev>
> To: Mike Rapoport <rppt@kernel.org>
> To: Pasha Tatashin <pasha.tatashin@soleen.com>
> To: Pratyush Yadav <pratyush@kernel.org>
> To: Jonathan Corbet <corbet@lwn.net>
> To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> To: Jan Kara <jack@suse.cz>
> To: David Hildenbrand <david@kernel.org>
> To: Steven Rostedt <rostedt@goodmis.org>
> To: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Dave Young <ruirui.yang@linux.dev>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: kexec@lists.infradead.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-trace-kernel@vger.kernel.org
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

