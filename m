Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36907CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 08:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15A6E6B008C; Tue, 23 Jun 2026 04:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10BE06B0092; Tue, 23 Jun 2026 04:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3D526B0093; Tue, 23 Jun 2026 04:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6FCE6B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:16:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4C9AF8DCD2
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:16:01 +0000 (UTC)
X-FDA: 84910469322.25.3B422C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7A9701C000A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:15:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gb/n3uJE";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782202559;
	b=BAZMf0BMIL4qh9EnxYtL7SyFiNfObvIFcdlUan/hQgRqvN9ebc75BiHBI2KRIwJCY05WxJ
	poKr3UNeGeJYw9SyNp+o8sn9wsTQCR5Hobo0v2lhvvYMfEfIT3I1vdUNosRHU/CVf6Ew9h
	U9a0K+OYfvsG0JwHW54zhcoVr8Ih3S0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782202559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kqRuB/Vj2Q/v7R+2z0gF31Rqvkx71DYA4rE3F/kz7ro=;
	b=dKsH50aNTRveipFgBKdFlAXqBQdNgu0hQXirctVCT9cwiP/p1Jgqi6QHkSSV8zWPB+c4MM
	q6z4rwwQtJssuaTJVJub77pGbreFqbqIY45VlbCqxqPw7LZJQzKXu1Bl4ubqbC+Geexn3z
	2EsGtHUWyRmTEo+CmGaKiVfw+duuULI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gb/n3uJE";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFC52406D9;
	Tue, 23 Jun 2026 08:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8796A1F000E9;
	Tue, 23 Jun 2026 08:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782202558;
	bh=kqRuB/Vj2Q/v7R+2z0gF31Rqvkx71DYA4rE3F/kz7ro=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gb/n3uJED2LlHAm1mGoSXJt5h0csRmPinx3JXk7XhkIj0PvkjtChUzDNkvII91cjn
	 i3iljyrG0DEqIH4vQVqPmvYz9hgLB7E8/lLWbF9N2Oi6lsJpeIOuQ3xfgMbmkzi/xL
	 0IRjmVeUw3LcT+a3h5f5DnF54HAzP8o119SxgbZDDBKiELPPBLHhUolyaMzKM8v+Is
	 ZmXJveaYGZQCto3cbObI8vCEr5TM0vnIdJjS/hIyY0aYual7s4qbo1OUSjyS/evc0o
	 9A8bZKdegcEr/Pxh09vIw1b6VpmeKtuNdikNkFoRHxpLAJQmp/qCdhxmwGc4z6yVkm
	 fed/cfeocTlLA==
Message-ID: <d421c081-8686-4d46-8452-e543401b0503@kernel.org>
Date: Tue, 23 Jun 2026 10:15:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs/mm: clarify that we are not looking for LLM
 generated content
To: linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Matthew Wilcox
 <willy@infradead.org>, Harry Yoo <harry@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7A9701C000A
X-Stat-Signature: fi1ukxqejr4aqfbk5px8j44jzrwgwint
X-HE-Tag: 1782202559-875924
X-HE-Meta: U2FsdGVkX186tZr0Qsjl4Ul0suMXsuHNUEMG25VBAOVP6HZ+UdvF0c755cwLsh4Z+ZqGQic9hZmBWmKipPdxBY2mg8d64CJ4frHNQMExjr93qN6fgGRTszvG/1T7SjSfIY2u77OCvXY/m9z6F/OPRZC9pkCHh7IRnT+XZWHf5doqXXQPefU6oO06YhtSoz22q6i8yvSb/EPbGrnOf3lD6FI/Cfde7gzHfgJH0HZ6sNL0t784UBkn+fLMb1jrtZpyTPoQXk0oIBMM3Lj83ALKRMVChvPoE2wLpMQdsTqmoS1m8ur5fV5+562Vj3UZ6LY1p5k6KwNu7VvcpvqwDvuMBjGFZvdhzRvEQn5rg1o5ODRZoEjpAg60P5G9ZptH02AoJuPOgU1L6njBYKz7ZTkFfZ0tpiSKruZumruUy6OEcAsPSsiknn8fFt/ne4BHrXadF5rTmCTHVCRiGbFOP/rFKlVz6DfflQ6SLXdpmJo+OilJLhAjxWy5jt3Gu2rc7nxZiIxACxDD3kDqh+bKd76BRFVMdp9MKgKjhM7ZdYGkBEBbEa047sPbdonm/8DQTA2E3v5Nwu9dmcp/W7nwYmqWlsjkfMRx5+TRVjluOeSTSlQeSrnbTm7GoTqi2dLjAghK1kTbMq1iP6FbWJhHQkWcw0VY277RZmyBQwzdAJ5OmC29JHY7L6fkYb58G++XsGteX4Zux/2yTAg09u4QeyP8ut1TkAGwWLP3ZD3NeLbImrAkYbG4TFJ3qrzEozDqvOtolsU/FtAnbSGtDbpemHxu3ERqPpzFysFWf37HSgWZeTbf4QzHyoE77Q9Ih4DYJ+k/MhMoZaY5ql6Uq/Mch9FPjFATl4SkUfI5FDuDfhj8BQ9jfbteRWdZbsWg1zDms6kHslXQaIFDwtsUqEMr9mhuLR5ItKn+zMeIWuFq8Ygl5SPFuMkaNmS5721BIUxZ1q1Oq4+CepOaGUtT1tndJDe
 pJXeI41x
 WsjcyXlxOfTrRe85M2rC5yPTvMwPq4qk7LD8zWenH0l8+tuMTS1RGU6lMtA2vFpjBVux/rMq7NNijd9rIPVfS4mxIWswxOmaic6X+VScedSJMo2tXopThX4zuVQbX1XSmLCnNLNudQkDM9BTmRs3++hp2TdRAwSNt5zyra5ucxBOJNwc9Q9mVhf949JkaAl599NYNfe1arjoNnbXPTnC8PvD5wZ4R3q8YjdUCUHPuAej8H9iKJ6aGNE2dyLCo00HI6JHZ9535YYLcw6ft8cPkVBgvHKlbXgclRSeC7tHeIIbVYXszNjXYPJOizg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/20/26 23:03, David Hildenbrand (Arm) wrote:
> Let's make it clear that we are not looking for LLM generated content
> from contributors not familiar with the details of MM, as it shifts the
> real work onto reviewers.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  Documentation/mm/index.rst | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
> index 7aa2a8886908..13a79f5d092c 100644
> --- a/Documentation/mm/index.rst
> +++ b/Documentation/mm/index.rst
> @@ -7,6 +7,19 @@ of Linux.  If you are looking for advice on simply allocating memory,
>  see the :ref:`memory_allocation`.  For controlling and tuning guides,
>  see the :doc:`admin guide <../admin-guide/mm/index>`.
>  
> +.. note::
> +
> +  Unfortunately, parts of this guide are still incomplete or missing.
> +  While we appreciate contributions, documentation in this area is hard
> +  to get right and requires a lot of attention to detail.  New contributors
> +  should reach out to the relevant maintainers early.
> +
> +  This guide is expected to reflect reality, which requires contributors
> +  to have a detailed understanding.  Documentation generated with LLMs
> +  by contributors unfamiliar with these details shifts the real work onto
> +  reviewers, which is why such contributions will be rejected without
> +  further comment.
> +
>  .. toctree::
>     :maxdepth: 1
>  
> 
> ---
> base-commit: da6b5aae84beb0917ecb0c9fbc71169d145397ff
> change-id: 20260420-llmdoc-21bf5fadbd6f
> 
> Best regards,

I assume this was not picked up yet? (via documentation or mm tree?)

-- 
Cheers,

David

