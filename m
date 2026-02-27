Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5629AFEFB51
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3666B00EB; Fri, 27 Feb 2026 15:43:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6A696B00ED; Fri, 27 Feb 2026 15:43:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D276B00EE; Fri, 27 Feb 2026 15:43:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85FC46B00EB
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:43:22 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 559E11B8343
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:43:22 +0000 (UTC)
X-FDA: 84491411844.22.E5EB3C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C3AD4120007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:43:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZUXdrWcy;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772225000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s4vAXpGLDQ59CKjdi5/XjsqP9csroGw2rRXY6YQw6rU=;
	b=67ToGMl+P27t6LrxzMlQ1ZlNfo13aQKlqsayqC8CreJd7RlQMiodXjZZrB2N//zUsKQR2P
	xvaGRP1kFUUM8J7JKGLBvVxVoNFbBGp5/h3TaGXAKh2ID0BktKqjz19Deus9fIZIbcJiN2
	6Ye1Fdq3Xp+DOBXv0jQoL+lfmkR75NA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZUXdrWcy;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772225000; a=rsa-sha256;
	cv=none;
	b=BRz30gHM+hEE207M8cRREdsD0ZbEpcUlwumUobm8MLJsKYfwhDsme7Wlj0k0oigCRqvaPB
	8Mgo3lV5J89ahqplMTOs8jrTrD5tbdO9BNUOFS4Ha6UG0IPBzQLpFBx7Bfj/X8xOFUE59O
	ntne0wLwHLctw+GtXowrbyFuJSdEwbU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 204AB60141;
	Fri, 27 Feb 2026 20:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A74C19423;
	Fri, 27 Feb 2026 20:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772224999;
	bh=C5BQtFO6OyplUBcKY6HfwUHgCQXnt44u+6kJv+UGBZ0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZUXdrWcycn9HDQGAt6dye4JUyNJBbLMu5XaFxuDIw08FKKSW4VKOKdc3x+Bd3/Uau
	 IlJFrfPsZot75XBx1PKjmd5nwWgPB3ex6Ex3t3Ehp6vWDzzvn3QeyCclaSvrl2T7F4
	 tWxoFkYagImEIgDHF3tdL+lGU84oA6uS7SqeMwQpSdwVI2WNUPwoZufWwfDPSktMxM
	 wnPfATuJVBJ0ze8wVi/VROUhytYoqrvA75fib0rawNsT7hnC//NfRQxqv0ND26d9T0
	 srY0tY7E0q8QSfFpZ2a/VKR+MWSCImCpNQvFMkeHCGwUJcu2IyugZRiLJiHVBQincx
	 dAg45c0Z/o9vQ==
Message-ID: <ca2ada49-08cf-43e6-a857-85994374549d@kernel.org>
Date: Fri, 27 Feb 2026 21:43:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/9] mm: cma: Export cma_get_name
To: Maxime Ripard <mripard@kernel.org>, Sumit Semwal
 <sumit.semwal@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org
References: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
 <20260227-dma-buf-heaps-as-modules-v2-6-454aee7e06cc@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227-dma-buf-heaps-as-modules-v2-6-454aee7e06cc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C3AD4120007
X-Rspamd-Server: rspam08
X-Stat-Signature: xuoj79uqzs75ycjzos3xwpkuiuh3ff9b
X-HE-Tag: 1772225000-989407
X-HE-Meta: U2FsdGVkX1+WL06QEEPvTnyhyAp5+r/q9XtK06PnPtG1pOUYMJhQ5cqGE2RcJH5rR4VCcrh0Sn0WFKyWiSz0+hEATBqBrPumd5atNi7ud1WSPg1lcrku3jYuOi9KGJMDNCFCzbQjEgWOwTEO5aD7x0t8W3kuJOAftD+CuraLqRyXstPYA7ueYGk2Z4z5ru0OKq3q+Q0BxBtrwXJgFaVq58x6VhRMpCPn17YPE2r/Jq6mgtlgcXiyk5i3+Yf5UQz6oanuZF7Rfuo8MjTpYlv/ZnD2Qb466CvcgTzwXlKRNCYA7ybLv14d1wntVrckcRAMuegeKnevOJv8CMWV/ewzhezm5v3Ln2uGdevw3ZdXVNTy4ARba63OfR12TqKMek3ksLYAD6rkjzpeUq7Ns7ybPT0kEzmjps/sbLwdI/6HDd9MCa2kB62Ei0rXI/YhLo0sLRGgFa32bdrU5gxAhRuzoaJFuBjRrLpLvwh4vpU89UFMVKaoYf7P7u8y/v9vrwFcTmLh39XAQfzp5HL6jsdzT9fNbOg3/5bjNLoe5lQLa4k/uQHIGEvCl6iTITqtC2s4aT6vKa/ucvI7Ay5DGk2kusvUkDcfNlOlMtEcRxskodRQcQUIv1r5mbK43078Lhqti23oqpwBvqPbKOcFxHy7Ngnmk3qJnMb6K1FuYPOJ4cJ8tl+T6k/qBJt8V8Uyv4COgybIEPNsKZtmOyGZtEwD0hUtr5eSlKGel0b6L47g+iKcCpDb1ym20FuzuWu2nK3maGWxeC5ACrGN/pCM52GfjL7l0iO/3HDT/BBWLXQstj82xAIWtKEwcCCR/QGG6QWJ7sQx/EykeFsZP0DE0Nj1UEyWyAKBWF+0TeklhcruDx3XnHUwu0BZKCBIvbh+Fm3zaYwhpvJ6cyJsJrJx1plMCYQWrJQNrplbFwuIVkRYPmmd3vbgbaeDPKKZWlphed/BuVuN5igvVMC6HC1Z0HG
 Ho7+IhId
 X/bYzV5Ygo1QN+Xc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 14:15, Maxime Ripard wrote:
> The CMA dma-buf heap uses the cma_get_name() function to get the name of
> the heap instance it's going to create.
> 
> However, this function is not exported. Since we want to turn the CMA
> heap into a module, let's export it.
> 
> Reviewed-by: T.J. Mercier <tjmercier@google.com>
> Signed-off-by: Maxime Ripard <mripard@kernel.org>
> ---
>  mm/cma.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index be142b473f3bd41b9c7d8ba4397f018f6993d962..550effb9c4e01cc488b5744fe61d55a5b70a6d6c 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -50,10 +50,11 @@ unsigned long cma_get_size(const struct cma *cma)
>  
>  const char *cma_get_name(const struct cma *cma)
>  {
>  	return cma->name;
>  }
> +EXPORT_SYMBOL_GPL(cma_get_name);

No real reason to not squash this patch into #5, right?

-- 
Cheers,

David

