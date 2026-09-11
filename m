Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DA8FC88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 21:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8EB6B008C; Fri, 11 Sep 2026 17:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859316B0092; Fri, 11 Sep 2026 17:00:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748096B0093; Fri, 11 Sep 2026 17:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4387C6B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:00:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3B29A03A0
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:00:36 +0000 (UTC)
X-FDA: 85202700072.25.F396E12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id EAE9B180004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:00:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ScS+ytAz;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789160435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0v5qDdlZ+UMhSmAlZv+vR0W72nkytSOWSkoGTQSfXo=;
	b=5rJy/SsoaVWo6KglNdRQygV2mbmsPlPrGArcZ0O+BfWtrTkD4tjSImaj/pHqXZMEwCJAda
	IU4qzAagblvYc8KebDpjEpmEwlaCufzHUMNCEqBWCVfFIaiykiumjNq/zUVFrveZE54DNm
	GU3FbghU2mY7rgMQchao4tgcKETmEPs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ScS+ytAz;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789160435;
	b=LHOj1EMLqMVTcv/haYgXy0FwL+esUvhugLa95zeE/cyrUEaf2RkWmjdA+zOmj1jp1Q/N7h
	IotWlQ0BsBBRaNCQ4C+5g0O/rynrhf2J1VxX2d9Y6DdmgdQRCbH9mC2TeJhCPzFb+IwbA1
	iHy8mX6l9EeZh3gD6KTujTtMBgnHdiE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2111940F53;
	Fri, 11 Sep 2026 21:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9741F000FF;
	Fri, 11 Sep 2026 21:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789160433;
	bh=X0v5qDdlZ+UMhSmAlZv+vR0W72nkytSOWSkoGTQSfXo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ScS+ytAz2/iqKxGyKZ4ZZFeYhfiolHMZ2vEn52zhAVtWOO2y6FJUvzBacDbEkZKAg
	 Z3g4BgDynUOde7Bm+tHrzeM+B3dAR3vKS0XQYC3qlvjSlf3/LLMw6TT/vjNSJKdC1i
	 VxuQb+YObH6HyAmfvN5KjpnnXZMGwNt/hX8mZOV+uKw2wlUU0YPBU/dpKzSQuJWzK4
	 g3hIfFW56a5OPtAeuHWuBwdQ6VFik6nDY0kWEnG6Jn+v/ceRsQCxncMk9LKmMWiKUZ
	 u/zlAm2VNQk3oqO03MR0eU2DJsX5pQMCb24YIULWjHGAwvZ+9vp2Z1qO8T9UXMP7ZV
	 OMbfLuyTZq7Lg==
Message-ID: <8a5abc5a-bfd4-4fc3-aec2-a567ef5c409a@kernel.org>
Date: Fri, 11 Sep 2026 23:00:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/7] proc/task_mmu: clarify shmem mapping walk
 conditions in smap_gather_stats()
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de,
 xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260911194145.1781926-1-surenb@google.com>
 <20260911194145.1781926-4-surenb@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260911194145.1781926-4-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EAE9B180004
X-Stat-Signature: uqurco4fdp46f6e67mxbxhy1kwtk47ha
X-Rspam-User: 
X-HE-Tag: 1789160434-654797
X-HE-Meta: U2FsdGVkX181QF7DY9vb5Lw4sxedk5XL4RnV8ngt8HYzNTUxzXl+4Fuy5gFGvB6wE3zKZCLwnd/YYdf/QgH9STncCwEFU2W9tggY7bX2iDoN8cQR2XkaU5VPSVit6WlcP+2e7Ht0cz7s5xc4avqUBk7dMr1bLzAIIW++L2ZBd4YdnPJ8TR239+bYdtXNCkw8PguYRDyPLg5FfHOPknZKyhGqM/h3DPbzWG63la6N83QQFiUkv6cqrQTfoitS12T4sH9KwHeKCXRSVx7lQxofwJbWUEAgKrIW1TunX3xbkvgSTtX++oIz5MZVH2LhS9ScElrp17vPlKjFEXD0XkYScZbiNw92vV1dZHi9gw/GMEhc7E0tXzrpG28Mpllt6MUExGpbckz+r3Qt4QsQkS/OpoTaXDZRODL+zVBuFdnWi2RQ8yIpROEbSw3QyhR7p76Sru2F3JEyayWIK5bdbshE3rJJ3OIdzbcF02E9N4LrXzVPyLY/qopG1v1nujQq7iuA65/xD2cA/hgEJCx/UauImXlQ2zGbkacBi68OqSdANlce69fz97EqQWxR/ns8cp+jD6EEQHG+exRIi/OuKaRu1Wyozqkzb+4fWgv7tVOfAg+WQCYU1HFN1vtCQuT6jGkr3XLKZIO4KrGzgsvihZKoJCmwCfRws5+KRAAgfOl5HJEWRmwcJ2AjrE81oqDgvU0C+PmPI2jJNbUQHgxauQyxb6y/Ae6e5jTdKOjKpMYFJlKTy/bRzgDFkeQbVHQD5RgGxxlQaa/wBriwDryeSmXmV+O5BBz+/Z9cwtXSxHd+/QAGv9SAkFeEI3tsofXFhsh2yA0KzCsRyoA+aA1waiJ93TmrHGWZEo2nV0oYPJ/5YeuVmpzL+JZymfG01seFTadjvJ9yoDLQVqPy6kAuehrZGIZ91yFSyhwGdfPaRGns8Nj3AeiEpsMzYmjCwKIqNoensQ/1uhJHVeJNYdoH4+D
 7Tkgs7oH
 mmySfNS3hu67M69CqiXvTlJOtls9bXmN9Ke6WgEC4cTnu1wWrx3uGsu5YPdjA6JyTPytIsdXnKP16xkt+i4XaPcQilgv4bKR+xFi20nuvTz1FnOlP5vU7yO8oP8mO7VSCXrdg34nRa4ZdWzzh4XoorcM1xgJbUznWpP0Vamrlxol9BKainM2pqP9E11m+7thFQEdIULRy3ouyXGn78Ji9yZJh3/UI9hkYdzSRu9OexhpWnA5n9lwkHxCo7XoTJXYMZzimYv35RIqdA/yItnlUR2NdxN7tt/+OD5qkSrheXsiycj70Ec1FPAVnFT+Oz1ngIGFoFrN2DJAy09lNZN9SPhPYYMoJF8r/UvZdCCVf4f9G9R/fDc5jg+9kTQ2CPvBIsGvdt+9XZ21yTpikhEfcRl6Q7a47TZhnCnbZflLeQwvCI+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 21:41, Suren Baghdasaryan wrote:
> smap_gather_stats() optimizes stats gathering by skipping the walk for
> shmem mappings in certain conditions. Update the comment to clarify
> these conditions and use vma_is_cow_mapping() for CoW identification
> instead of open-coding it.
> 
> No functional change intended.
> 
> Suggested by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

