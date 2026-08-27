Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65E59C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 654796B009B; Thu, 27 Aug 2026 05:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62C3A6B009D; Thu, 27 Aug 2026 05:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 542A66B009E; Thu, 27 Aug 2026 05:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 32DDD6B009B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:21:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C194EC038D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:21:42 +0000 (UTC)
X-FDA: 85146506844.29.855E1F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 38674180003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:21:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jpAIlQkz;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787822501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4z9h38OfpEH2Q8HujaPpay0A2etD00gYp/7BjEfmXg=;
	b=erIfj5Cz1rqUPTnqvDQmyTZbIdUpTuensj9TcfY1v3IhpawPHIWDUac6U+6aS9Ml7Z5ldj
	UneeONPYr2ne3xe1Qsfg6gKymplK+CBP9Pwm3xW6W5r0i4LvxmwPjaJgBr6b2qPsDW1UbR
	pzdv7TsFtmtDuQ17kB3UokhlG/pwJOU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jpAIlQkz;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787822501;
	b=BPvi3u/Ndmblr34iC96o5DFiyouAmgaN6fNvdGOBPYkdBMZ97A2fxssNGVaS5hdwraBZYV
	3uUQxaIcU1Y60MI41whcEGYQXE0+CdfzfElj5m0UFyMgwWQsggp68eaYxi3AZH9rDOQ1M1
	qdtYXivt74ahRQIwuuzJwVmw9ua+0aI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8929600D9;
	Thu, 27 Aug 2026 09:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA07E1F000E9;
	Thu, 27 Aug 2026 09:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787822500;
	bh=n4z9h38OfpEH2Q8HujaPpay0A2etD00gYp/7BjEfmXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jpAIlQkz8SPDBEHr/++so/yIfXSgHbjIgfwBjM0AnESqfPxYYIyw7mOcf1VeWz7H7
	 dWc4G8Vcvna7EtYgW14PuMnBFfwaPSUMhDnXDNvcmrutWQ7/KBlDuNTWG6SGTzAs1f
	 bgtSdTc44WUrqbLs4fbf5ciNiUUewPvph2b9Jd+E2+wDZbdX5GUlbjgb1jL5QIYFBu
	 cdgtM2FcQ73fbrZ0kcJCIslqpAVgKKMSGrnLPhHpzWPpatzuBD1YjPnbvVMgQVgEc+
	 csnfU7xXh4lo7wlNL/iEsZ9D+OX4gQBBv/Z/FxAM1NFJ19iVi9bi9ALqP+KcOBEFB7
	 4CHak9EewcvJQ==
Date: Thu, 27 Aug 2026 10:21:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] userfaultfd: decouple fault reason from VMA flags
Message-ID: <apABifdLFy3ct2IN@gremlin>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-5-3086981b33cf@kernel.org>
 <5bb86e34-6196-4b50-b553-be2ff7c1fa32@kernel.org>
 <ao_sCh5zP0IC9H2S@kernel.org>
 <e8aaddde-0a07-4197-9874-5ca0ea8af43f@kernel.org>
 <ao_-uZrrsVX9lzbz@kernel.org>
 <01aae5b4-ee10-4601-8ddd-c9428e11d651@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01aae5b4-ee10-4601-8ddd-c9428e11d651@kernel.org>
X-Stat-Signature: ts1ty5j1i1zss7nhard9bg4g9j5y8p5w
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 38674180003
X-Rspam-User: 
X-HE-Tag: 1787822501-559207
X-HE-Meta: U2FsdGVkX1/73IGSG1al9ELpqtm1xaBcjGuxwUathrTgkZgriytKNCQnRUL7rC7wxIblK3K5P7KsEboqZCfk97gV2DnatBzqmof8Gm43UaTlyI1OH2AsuTpXLm8OVtz868Aa7Lc64QMoS5GYH78nf5VTO0nnAZY9pXV7HMplrIAn84yPsnZBjRyexPkNyAXtc6Bke1jA2DubrDtbIRvM0DCePpnPUZnXJkSmzj5Xb3+ELnuG5gJy8KipXT0i49xPg893WFo4dZd7M1hlWPx+ptIVazxzFnD/3Lp7x9MWhKLs0mORxlayRE+RfMy0T5sz0uzj4/udfwPJFqQ0+UnZQ+fZv7klSJ5+CQ5HvnHMXcdvh4BnLGFLp59y22ZJv1erZn6OsXSSYJYF9l4upexeYmMnq3GyHjAZ/95VHrfDyD5/1CSLcNCeJuXYXfE/tK+lvYRNOgopwEUkpDuxwQEFyOvrazu7O7X9sV37vHwV2/XRCBP53SzCvyv6awSwtchjzjsYUowCS67iTtR09tnFJiczdpp1lkALkb4yCtoF82d8i4mGtPJ/2xFEwB/LnOhX58zu7XxzvfXrHDu2bPQrmuM6wMXLcEYUUEd8JoOvLwvlyj40n0oS3PR7BRZEDfPxUM3Ye044Yxk6lEQc1aXlkGWSB/GmdsUIuQwLB4hmVEvms3ZvjUfzQM3/S8Qht6GE/St7I1xLPTO8mzDXfO5bWkP0R0RJMsk1jfjf8JHTCFZ+dzJb+AxVZSRVjNta7yrRubzx0UarD5P7fHGf2BMJYxLMWumhwGy0brHGJbUgH1CP35ur46eKawmcPmKurRNaoMGLcMizTvD2rno4umUi8q5y8b/4rusUzUoHMBJYqXq4FwJCJaoRLf9pfaPeCFc7oWYYRDJOE6YWEbfiT1eYWvAgE64B5iteoYNGdURy2DsPw57sg3lGr+lf/BE9NEVUQc6YMKe0u4a0AH9K3OW
 maEa3nvY
 AHGRcj+5uwNXsu3y90LP9G+jIll8sd50uIKpbsOUGhZtHyZreyRkQ8YBfsu/CG5c81Uqig3jBJmtx8vEJYvnTeXtBpXZ9gC4UQT3zvFsPzey7TkbGhUuG3LYmnkCp+WilGkPjO309bNrMcbpXVwyQa4nldNCHONMbCoCBWL83kdaLZdOh43UMv9qNosq+NuUNytiXGywQ0s8GnrlLj/1qhST+Dd3RnYl0O4H9ADb8/lQM5//nJhUV+qrzkWHpX7by5DhA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 11:19:01AM +0200, David Hildenbrand (Arm) wrote:
> I lean towards just calling stuff uffd consistently might be cleanest.

Agreed. Let's use the same naming everywhere please.

--
Cheers, Lorenzo

