Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 463ECFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE3286B0088; Tue, 28 Apr 2026 04:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A948D6B008A; Tue, 28 Apr 2026 04:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 982B86B008C; Tue, 28 Apr 2026 04:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 863E56B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:16:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 26DFA1404DF
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:16:48 +0000 (UTC)
X-FDA: 84707258496.11.5F55DD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 24234C0003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:16:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PKyVwkOQ;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777364206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztRiYqyO3M6ha+WMYxGHx4m0P2O/TEO0i21LNk348rU=;
	b=IUNlcV7W6YE4YlSfoc/IXdE85XKq9GPQgwFFxK1mPTWHr60+K061B1sQSSdC+mge1cpBOU
	2ca5OyBSQ4wPOfrzEBKGbC6sMk6m9l9RMlAl0tzf2GsWja79r8ikbMhqs9dNtLWjb07/+T
	2oO0OSUDE60wVtRkiTHnCVzmWfmsaGc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PKyVwkOQ;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777364206; a=rsa-sha256;
	cv=none;
	b=b3tYGNW0LyNAJnUt1eJ75cQ6nzxa/EECzWtDDK5/Y2zj/Z4pW3Q0uhoYUD9uX2+7Idc+Gx
	4Erdm1UezkGRlJ/dWj+i3moao5ZRbyhJeRCfRfERigc+64Qoxhpt5QHIXnuqhLUaZZeD8U
	2/XfEsQwWYKtwuOAXKl9jSLkRpcv2cM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 19F9740112;
	Tue, 28 Apr 2026 08:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CE9C2BCAF;
	Tue, 28 Apr 2026 08:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777364199;
	bh=8AlrguaazRg8WqpeXcLGIY23fI/h23c2cdRwp/9a1k8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PKyVwkOQIDc94xOW0GulTQ5LSUfSMJABGPdm1wupXTlvPNzIMkBFW3Yj9KJOnWMjS
	 ZzgXT+Yc6lIFlhkdOfz9iUSt4D1XicuxmJom1apMcAAjea/f9lNeCu4IuZ9K+69K9o
	 axYllYt7Rr7KQyCI3u2TuGJkxfp2QMbZ8ZhbkWCZq2XjXyABa41xPRYFjxms12Asup
	 4c0uKzfLOZJPhcO8AuYf4008tqs4ltgcrZhu+2j8UObP8EM/6i4y/io7Wg2K5gwxxE
	 G70hucMUhNIWrkfwzYUBOLjfKuTdh5to/hZkIBj/aLkmfh3z5GrBk9oG843CnQq7gl
	 +1hpoWv+5Og1w==
Message-ID: <2b2eecf0-72f9-4959-9663-c80e3cd0c517@kernel.org>
Date: Tue, 28 Apr 2026 10:16:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] bpf: arena: use page_ref_count() instead of
 page_mapped() in arena_free_pages()
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Matthew Wilcox <willy@infradead.org>, "Liam R. Howlett"
 <liam@infradead.org>, linux-sh@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
 <20260427-page_mapped-v1-2-e89c3592c74c@kernel.org>
 <20260427051758.e1b714a4b567917971920eaa@linux-foundation.org>
 <CAADnVQJ9JXrtAnFgE8UFK=W1GDeT6T6Wi5zB7g0AfRjU8M4=bQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAADnVQJ9JXrtAnFgE8UFK=W1GDeT6T6Wi5zB7g0AfRjU8M4=bQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 24234C0003
X-Stat-Signature: gzhcci38cue766w3rmmdeoqnwfne8q4r
X-HE-Tag: 1777364205-207157
X-HE-Meta: U2FsdGVkX192yhOoFbKPtShu82cB49H5DMcKDgVMH3n3qgK5r0Wjze0z7WPLokUra48naxE1zIFC9wntZTNn0NLvel2T0sMAQ8iYIJY+QjOvg+kji/l4xOKNrI6w1oLoAkEmc+E4BaUSlswbDnm0HD7a1POM0xe2HY+vx1QLJQTHFtVHeSEukHhiEi7qXSe7YnYff77ms5A3OqgSWrJ7unMDeK0ORyqMOjkUiGEsZ6YOG+oSJypw53rbxn0BH/q73zsetN1HpcnzcUYqkJ8MEBtaWiHOltaLDVlEFZzbwmxbCXCQnpYiqpB+/JNmJwpMsWIjDzflD5n1i49MTRRUivkE5Y8tFI+18AxHAOVbayV7lWBGDsJRr5+qn9G/TW6IDE788+kh6pFjlrYSLW1Q+IPyWrXblnwB/7cPuTJCdYQQqeL+V8x+XmSN9Ik53JZ15o80xmbGbpRkfocPxpQOiI/7PQDJTABMDwUPZkM+Rs+u1oxJGutuZIaRjNIy2i/+VsLo5B6/I5vd9vCAy1MlngCJlpVU4w0G6hDivGqjTC/wQcW9sEsKsMnrl64kWrm8h1mPsmu+/dHZeYFUkag23l2h0G9JmhJIeGITCbxtPgAlhd238/Ln6K/Oz3G3SpCjtk3gkYccKShc7Zi2Rzh0+oQ9Y7MoVqlV9kZvksB+ZtxRX0wEGwhRrZCC7E4V0caktyVgvwvR8P9qYpwIISZYnNltbUVSActMpXOeytowCILScCFzyeTq94Vb0aPGRCuYI33WwXTGNl8N9aLwgZekAGD+xlaJFznPSc70q4Z5DOCAo272xs+bG3QFrx9X24GVcgQSSTPGL/1HNEzVyTWaO2rRMMNWrQNKGrb4/z/HY90xEcxVj6DxFiy7yVb15Nqv2Nkv2TJXHAf8I9hGZuY0bpV9/zKY23YgxVehDHUOJwLoG7SwNSGI48oM8kpcGbdYf+eC3wLHRDEfih3QnPe
 wYCV8e/l
 c6SKaCIOzgSSzTMjWAJbhRqT7WyrY6QGBieIHUr6SPqYxXyb+1eHuzHrJZJqv9YQCPhmMQMLXwf4Qkao+BJAk640ns84KXF+s2MBFnC1nXRC3E1Tj8JSA4xa9JHuaG2P93PEbPLdpUPGcsA1b2P3q8YE/4zxZyCSHNqrXK6gfDLuOAZEomnyFm2CRyuxQ8g/r7+2sIsVkKYwUJmeuA2JjInoyYH6ZCz6K+MVlxF7iTQIWkEegh3OXFEi/1irMvOZ1RgPJ3vklZUW/Q2n2Uu+hcujGyf9fqoIk5L9+iFIJ5fm+xLYvBZBiv+KeOLDoT0fBztYiNQIeyrmBZt1oTCpnIcTbgJb+IUX4KDOVnPj6HU5ThDk7TSF2G+74ONc3/cDyrdmzKGa2zbfvYEK9k2OzS0aJi+nKYADFXVZdf9Cp4TbOsuOvZeLXnb6bxFNCkI4UUCjOX4lKdkfs7tc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>>  kernel/bpf/arena.c | 2 +-
>>
>> BPF maintainers will probably want to carry this in the BPF tree.
>> That's fine - please go ahead and add it.  I'll carry a duplicate in
>> mm.git so it compiles.
> 
> We cannot carry the same patch in 2 trees.
> Sooner or later it will create problems for linux-next
> and issues during merge window if more changes
> are done in the same area.
> The only way to share a patch between trees is to
> create a stable branch and pull it into 2 trees
> then sha will be the same,

As lack of stable trees was raised a couple of times in the past, once we're
done with a transition to a fully git-based mm-next workflow [1], we should be
able to provide stable trees.

[1]
https://lore.kernel.org/r/20260421094216.8dfe14a8c62f2420fa5aace1@linux-foundation.org


-- 
Cheers,

David

