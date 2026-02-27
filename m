Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F04C81039895
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62C8B6B00E4; Fri, 27 Feb 2026 15:39:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FAA06B00E6; Fri, 27 Feb 2026 15:39:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 503DD6B00EA; Fri, 27 Feb 2026 15:39:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C82E6B00E4
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:39:23 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E180114092E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:39:22 +0000 (UTC)
X-FDA: 84491401764.07.0C9243F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 05674180006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:39:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CesjGCgp;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772224761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MEydnCTGp1+mN3RamvP6sTGGXtWmTaRxD2brmbuFi1Y=;
	b=dpyz171kBA55WWdKPk5omPELS8nQksYkYrogH2ELdeCFqv2MoBEHIJP7HqoVXeohjuzRbl
	JuhrtnBJXXsRUeDHsQW4whmd6uyiLybTzJb61k++xy56n5He+WZcGgcxai/apDwpYK1cBt
	9rh+v9rivtkIJK2HCTx+RCToqNGRhNA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CesjGCgp;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772224761; a=rsa-sha256;
	cv=none;
	b=mYRsxCZHEeVz4L7QegZRp4nHhHzIZYUkEXijhEUUKF0YFJckafkeCyzzqysy7josgLpsBP
	vbxKQWhgYUlz5hPT0ghSHrJ5ST87XW8SBqDofCZJuGpY+Xde5TZ0vOe7nC7sZNaVB4zk8R
	ugc5Ms8apKHLUcw/e+VI0EJ4l5I2lo8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E9F3E40245;
	Fri, 27 Feb 2026 20:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3D0C116C6;
	Fri, 27 Feb 2026 20:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772224759;
	bh=C0JYE9g4fNlb54nOcYXLDnmpOOfKqRtc3+52X6TvFkI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CesjGCgpHbnBs+6sVaZ1GtPvtTHPtngBOYi0yU7cJOzflnqlkNKD1zRkmSQtRHvuf
	 6RzAWIzv+oglcgdELZAMMmLzdYi0OniFpNcJ7DvoeUrxBveINOzXB19noW0WPaJNxm
	 7smt+degjri7ytTbnFLOLsDx03xtp2ABokJlba8Ifr1d1lWv2GatQUS2NJxcy5WIQl
	 MG3ZmSXyib5rydb/zPJc7Zy+vvDD+K7hXdh6GjT59/YHHwXwPUWqhqOSjaVkNWnmu8
	 33uOroiy7FwbgRu2ld9UOJHpsY/sIMZ3aSL9CQY7NjHhlsf/w4SnwmaQVVhWLc+beN
	 Q+UM5TNtP5H8A==
Message-ID: <7e93021d-53dd-4162-97e6-3bca1f46a0c6@kernel.org>
Date: Fri, 27 Feb 2026 21:39:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/5] mm: convert zone lock users to wrappers
To: Dmitry Ilvokhin <d@ilvokhin.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
 "linux-cxl@vger.kernel.orgkernel-team"@meta.com,
 SeongJae Park <sj@kernel.org>
References: <cover.1772206930.git.d@ilvokhin.com>
 <d26a43ebed2f0f1edb9cfe4fbed16dd31c7a069c.1772206930.git.d@ilvokhin.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d26a43ebed2f0f1edb9cfe4fbed16dd31c7a069c.1772206930.git.d@ilvokhin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 05674180006
X-Stat-Signature: kigf5s8j9h3zjx3zi6dm34hs797u9fps
X-Rspam-User: 
X-HE-Tag: 1772224760-838714
X-HE-Meta: U2FsdGVkX19yE6RlZU16TOPOXVVJNIHqRtXDdxXo2DMCn2Y3YDQqO6ap2r8R+/KiZMtKJCstZfFFYeyfGw+8/aXFMjniI8pulE06qmSIQLhs46Eoo+Doxhy97fFtS+3MTRPrvT+reJ1OBvsfjqnsKcGMywzTpfb+TEuhZqUvNgmRSoOmUnjg39JC8L0O0SE9eJRywsCbcrXxbzF5cNkpqzxKvqUkdro6C72+/dgSx3/cx5OVSy57hj+bp31x62NBr/P4kFiIulB+hnRyRwyM0sK4yhke+W4udvapIP+tXt+t80YIP2GokXEq2rrMYCcOSxVclRBaA0S0CIw8Nh3gIV6PWoE5gwi+7zpny9LKufRjSzyhc6FOA3JC1o4DJusRuqvvgrTayu4nnS0SNVsGLBOKPYsHK4bonmpZdRfDY3ZBHwgxXpdkxGOgw/oe0fxuWkhZpBY/L6DdKhOzMuZ1as0cqUa2MGQwfhLTha8gtnMsD0Y0Hsa9lF0xHwvv7NHYyS32cXkINDxYRALkqYmWHqNuCQyE71KzZ1GJFG+ftsQu/zVNRCV8NWr8/LTh9ulyZ6+Mcgo25ZP/ygZWvzXfTu2/iViJL95u0zV2HApj9pZLCvlpV0THFRVUjMpUEEzjdKarJY+3bFiRjMJkQIAk4PPY53k76tDbbK8CXjghUPIC0ZNrlled3W/EwuwczEf2AEveGh+zvP7aGl6xiLD5cQS0oj6wTxtG50fpwDSKjnmwwpySctKbgIXbpfSyZJy3qK/BVWvRJ7dSBMxmlEBsoV0lptO1IuOgWZX0SQFJlCEu4KY9hczZ3SPL+CjqFoJINNqD14zs51ygnZ9vVBxLzDKFAHWn8rjWEIhpNJsXePp3SwfURnG1DswiriyH7m6iWsHTDrl0u2oGIzbSQqd2LZo7GQLmoB3waV0Jc31ePazmIc0OtHeZ0ZsJyKzKomY/WsT7eW90YjxrvB8ODqP
 teBqe8mN
 HNcWo8MwWhehqFk2CltB4ZvACz+j0DXEuUxQWPMaKVbJkbbjUAy5kSORTy8GE+xi3g9yGMojs2LkHvfaCHLfndNkxjCkOVWNdo8LKngg6ne5jGLqoDlFwx53ZT3KjK2CKQMQbMGv01KPfk68a+AMsdg7AUmLrg/dxr/1NBy/QhUAgfJ2W2d+e3yhGOlYH1d0EByS+CW/zL+q2Gqrngp5X1KVq2oLEb6X5pigQhcUi+06p6XQyJKB+tNM7qnhA3zYjLFe5gqEXsCuLlb/G0mAwvNbsDUK+pf6dpcVFxrb0dT+Z2V6u8xyVDFwrkp5SIIzg6qV7k3dGcAhMxjIWfSXS7xpQaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 17:00, Dmitry Ilvokhin wrote:
> Replace direct zone lock acquire/release operations with the
> newly introduced wrappers.
> 
> The changes are purely mechanical substitutions. No functional change
> intended. Locking semantics and ordering remain unchanged.
> 
> The compaction path is left unchanged for now and will be
> handled separately in the following patch due to additional
> non-trivial modifications.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: SeongJae Park <sj@kernel.org>
> ---

[...]

>  #ifdef CONFIG_COMPACTION
> @@ -530,11 +531,14 @@ static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
>   * Returns true if compaction should abort due to fatal signal pending.
>   * Returns false when compaction can continue.
>   */
> -static bool compact_unlock_should_abort(spinlock_t *lock,
> -		unsigned long flags, bool *locked, struct compact_control *cc)
> +
> +static bool compact_unlock_should_abort(struct zone *zone,
> +					unsigned long flags,
> +					bool *locked,
> +					struct compact_control *cc)

We tend to use two-tabs on second parameter line; like the existing code
did.


Besides that

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

