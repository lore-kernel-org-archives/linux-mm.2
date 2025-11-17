Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43A21CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 16:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787D18E000A; Mon, 17 Nov 2025 11:02:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738198E0002; Mon, 17 Nov 2025 11:02:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626BA8E000A; Mon, 17 Nov 2025 11:02:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 49E408E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:02:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F362D1601E4
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:02:38 +0000 (UTC)
X-FDA: 84120566796.19.4E44273
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2D5B1A0026
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:02:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HRN9ah8J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of hawk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hawk@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763395357; a=rsa-sha256;
	cv=none;
	b=aOnfpjObp+FGTP6ojYV+y+4ZOfsgehIOe0JAQ+LJgqBPOh8yOj2tiFNFfKfcj14irLEDiM
	tu24OKRol9ebppyIUcORJcQ1UJ7zKoq//1eVICgvST4S2JxTOGE/KkFzuAunkuEQTnyXqk
	Tvthw3Wwmu7nKgzA7jfpzpDZs73Lqo0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HRN9ah8J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of hawk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hawk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763395357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZ9Aw/vmbvj9qem/CjLaXhZ6Qaj0b8os39s1Sf9cBYI=;
	b=csdV5xlBbhT/RNowYOGea+VWPYo0vfa3ASmbr5DAG6YB1cktfqvtrHkzLGpaBJj2XzG1FI
	rrR/UmvBJMUTohet5XWsLUNP5UcXPxwR/Q+6xb+Vf10daaBD9/DZcHWU0HxmGefW/HeQN+
	yZVu5wbwtlm8/sh8+/b4tgZvqnYr64w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2826840294;
	Mon, 17 Nov 2025 16:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B502C113D0;
	Mon, 17 Nov 2025 16:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763395356;
	bh=Jkvmu4Q+7pA4zSpi9OFk7bJIcNsGVtBgomWoRKHdM8A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HRN9ah8J0i3UDd6igt5wSrmwF/x03+POYYvvNYin0MqGa7LWADEznY83zaPtwUDRs
	 ScnopSM94D7deN4mSE1KVPZzP934yzIg+LXrta6j2nrouhyFH8av2u/a0qRtna5hcS
	 25x8yxJl/uczThIH67MpaOJdwwfBJbiJeFru+UKaP8JGt3PlkKh4hRQ652Cb9cKrPs
	 E2r8M8rZOR3hxKd5EgzdfshSFNvH8gXZCEuOUMYRte20uezKAeZzYovSXDLoq6Ifp0
	 HcHsxX7esNJloZeJSP6iRggCBQFjamV20khnzZ5sVK1x/n1QLcw8tOqAiGCv274hvX
	 8cuBHc5tDmKWQ==
Message-ID: <f25a95a4-5371-40bd-8cc8-d5f7ede9a6ac@kernel.org>
Date: Mon, 17 Nov 2025 17:02:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC mm v6] mm: introduce a new page type for page pool in page
 type
To: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, horms@kernel.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org,
 kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 baolin.wang@linux.alibaba.com, almasrymina@google.com, toke@redhat.com,
 asml.silence@gmail.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com
References: <20251117052041.52143-1-byungchul@sk.com>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <20251117052041.52143-1-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2D5B1A0026
X-Rspamd-Server: rspam07
X-Stat-Signature: 39xdxm61pfcadjdjpfxisczb64fdn8q3
X-Rspam-User: 
X-HE-Tag: 1763395356-831618
X-HE-Meta: U2FsdGVkX1/jbRuHiU0F+mW/vIoS1m45zcPXM+DildCENf7n0Fhl4fn/cXDND40R0LfygFmh4DOjOm+Zfv9u6ddM0C0Uer32+ZnWXVUOwRkuWUxKM7aTjOb01B29RCldcQfEwiFVKecJww67HKAyNfP6G6t/tQT0WPr+4scvyFy02T+KuYwPOAaGCv13B9Xw+bcLvtqh5Xn2OfKxtGW2n3ZtBxfByo7xTzN+pn3KA9eI0jM+PxOOoqElpZ+/vNMNjFl8QZabLRqY91jh6pc8RQZJbDWu3+QGbkssUdgniYj1afssSBomL5O+eEGxtz+KOBtGl31fZb0CLRUk59UNLTQldIZNNcd+gD0Kl7A12bORrrWD7EcZhCHR/ieLkQo9qfY9/b3NA2PY0QRvW/FxG74vMX+hF+Eui7zFwzgiL3hEKXWKYWbHhfdXxj6JFNGzT3PdObrmjsP70Rny4PtPhTdfVeXo5f8iyIlYfXrjgw485XJHgJ03TdsKiKur2kO4fFRTh17+XdwPLculWc3su15K6ii4L1xE2PtghDeGyB1ji9Ox2EYBrdCH6J7oyGSpW8BnHEfurLwomV+vmnL5U1bgOesK9TLH1XROXjGAEOc1GOfwVG0ZN+1u7sBJWwlKi/YvMwgsdGunHLF0DSpPmPqyZYY9Yb8kZuCMGK8Je3rlxJCIqDZJiOc2CgR2wwSPs9qB8sqnUwfmLAWyGRGiAQTqfIBpsrOdwtQ80pPb/goUV0s1Q/SruJNZFde53HWE+yEI7L1a61bLWCMLRbmP9YH0uuuvbdRXQeuM9ylDBPZCw15fLGLovcH8K7QPXqUQqCggoEDL6rXCcXOJqkWJT2z7haACof374wdlLfB/upY2b+BQB05xtsW2lGMaAJ8pAMgFn6NdR5s9hAS5mZdzCuarmcWPsxwx+LRA3R5uPABLSyp8NFune6/vJaF1TqLLze+kODPDZjN3twmtBj2
 NaQW5+X3
 hf/CwTQinLdNOW4Uyn3a4gxbFADRMfaLUMbzJmH2cv0urwyKpKdLRz/nodxkzkqTmKbq1zacGc1geHKOiEp1Ep9eqO0zlsACwYElVL73j0I89WI14T6P0Je3slf63czUOqWvSred74P+vdclDXuPr/7Kbh0UnghjDSrO1DKYKqoj9yzLPUN0oQFUlLUgBvou8d7fzWZP4VbOyrCeVdba9/LswZMglYQliwWK6b/+2dKQxdxxPPhIfJvxWhMqrne97NjMKjxVJHhSC3wdVLBvNW1YWL8AdzG5lC8ajlEQfD8dDZpMy0VXEDzbf21oMEv3OxGNbNvYs8c5BAJA+vId+tzwAbr/vgCG9H0jPYp4xs7CFCI3nI9tu1U18Sw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 17/11/2025 06.20, Byungchul Park wrote:
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 600d9e981c23..01dd14123065 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1041,7 +1041,6 @@ static inline bool page_expected_state(struct page *page,
>   #ifdef CONFIG_MEMCG
>   			page->memcg_data |
>   #endif
> -			page_pool_page_is_pp(page) |
>   			(page->flags.f & check_flags)))
>   		return false;
>   
> @@ -1068,8 +1067,6 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
>   	if (unlikely(page->memcg_data))
>   		bad_reason = "page still charged to cgroup";
>   #endif
> -	if (unlikely(page_pool_page_is_pp(page)))
> -		bad_reason = "page_pool leak";
>   	return bad_reason;
>   }

This code have helped us catch leaks in the past.
When this happens the result is that the page is marked as a bad page.

>   
> @@ -1378,9 +1375,12 @@ __always_inline bool free_pages_prepare(struct page *page,
>   		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>   		folio->mapping = NULL;
>   	}
> -	if (unlikely(page_has_type(page)))
> +	if (unlikely(page_has_type(page))) {
> +		/* networking expects to clear its page type before releasing */
> +		WARN_ON_ONCE(PageNetpp(page));
>   		/* Reset the page_type (which overlays _mapcount) */
>   		page->page_type = UINT_MAX;
> +	}
>   
>   	if (is_check_pages_enabled()) {
>   		if (free_page_is_bad(page))

What happens to the page? ... when it gets marked with:
   page->page_type = UINT_MAX

Will it get freed and allowed to be used by others?
- if so it can result in other hard-to-catch bugs

--Jesper


