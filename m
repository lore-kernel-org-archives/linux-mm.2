Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E262606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wfbnQF2h
Received: by kanga.kvack.org (Postfix)
	id 946986B05B1; Wed, 28 Oct 2026 06:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F68B6B05B4; Wed, 28 Oct 2026 06:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5196B05B5; Wed, 28 Oct 2026 06:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52A926B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:47:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FEC140C44
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:47:05 +0000 (UTC)
X-FDA: 85371707610.02.12B8483
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6670340004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:47:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=wfbnQF2h;
	spf=pass (imf11.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793184423;
	b=aMKyEM2En2mVvroOwCuIOf7GJ3MbU/4hVpHbKUyQ78ZtblX1NDPzFQRJMLKq3InBWFyjsl
	DIbY4/37XtkWLQNb8nCZiwVlKs18gOb5ySnIciXzFqib0rp5F/KNTM6/vJ1HVYWtK0rQIN
	peq/bGNtgtoIq/+oZXNGC1R1ujcLlW8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=wfbnQF2h;
	spf=pass (imf11.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793184423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QtJgRxvzKAXyLcWV37WI7jPRIzFywEjZjOEQjPn90QQ=;
	b=LNjc/zHmy4/LKqZw1w1mc/DGMjsF0Up9sp6+WIkEnDMjibCKKC/f2OBDx9WM3bUhN3wPmE
	Ki/RdAQSsLMNdkhZ7G0gReRFuDvHqusfDYEC61SiHGi+XBNKZANM4L2QWTmLPcQnlZeAKb
	qS1EBN/IvB3DqpVwIVcfvPwSAfdTjHw=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a7992e2f7dso6776045e9.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793184422; x=1793789222; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QtJgRxvzKAXyLcWV37WI7jPRIzFywEjZjOEQjPn90QQ=;
        b=wfbnQF2hYDFSGIq8qIKEUUHjXVLI2hAWEFamUF/SUInzDIVnfOxpwhtXyYOcEJsPPm
         2xWzRc1O3tmvUGEvkASMVARDZ/nuLvvaqd/MfhPQnIm9al41Zh1lOkNaaalOOoMo0ESs
         K7wNd1vJ2W9ChRylqeGwuIdQ3nk0PRBPu+//0BiF9sEp2WkqA3M3XirqbABaAnnqUJQm
         8vW96/uqFpDEqdAonGkcYvquuL5PeKGbpzzgHEfyYN5frQ6nSAvNkcNgfG3xtD4KTTbC
         9FgkgSV19CuZ54UJ2MjOS8TP07aYs8eyGS407Ezf6FRoDliFIqGGIGqFkJwgiUQC65xJ
         eZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793184422; x=1793789222;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QtJgRxvzKAXyLcWV37WI7jPRIzFywEjZjOEQjPn90QQ=;
        b=0gCaiYpAkPsY+E7Nrbfkomh14/xC3BkKc06FvZv1BWZuPKZVFjxiJjsObGzbkamklU
         h70bQPvIqlbJ69k0sLFAF8Lux7a7Uu/FcqRuJnjF8o0obStICSiFVb2619XjcOOaBSiZ
         md8d/k4eYR7SksY9U21yHwhmxMCW8bDf8UNwu/tkL86mEK8I2EI3J4cAI/uUC1BBYdRO
         t7dCAcZKq4OCLL/c8Qzk0cEgNTcypOFZKFV6vCY3cdRrKTbAaFxT4Csc3S2qLVzSdjQY
         e8Ek4aRjdqoRh4kVT6yTVLowoZwVrzyu4oaPvNnCj8wKDHdHdqy4QmPUGB2WkOvUJtwO
         FGpQ==
X-Gm-Message-State: AFq9FYJxNsa9o4pQLv2KPkElrAJfItkdxAK/i/uE71CevQK/Eo1vhwZC
	wla4iHce1Z/yGJl9Ra8Mf7OIr3BGKnYIfMohbDMP4uTxVAZ+HjXgeul/
X-Gm-Gg: AYBFou3QL4YZmjDFMsesobU6MMP5dWsa6yth1XwTi5InCIZ7JDGXlGSzw+eHCH9SVcz
	quJUyt49R963B3ncEevxkvEzVoVDU7oi65NNoRvrNvfCus60Ag+G1PdGJAbrFBB7aVDbwTIwxIa
	LXwFztVH2pt4QXRUtHS7LTx5ELm4E0FWGL03H18YdmB45Mv3UvnmmYCNIS5KCLrslJG4+cuvvVW
	thBoQarfaUhqV/ExPJAEwj9JadogvTEqW7UwzHI+twTz6n9F2lZTmv19VxA8C3cR4SJYe+2JoLr
	37jdUrvLwHY6rImj5/FP3Ay/RtnoX+k+A/XVmqzRpSu1IiI1N9IfbVGZBO+zTXiyt7GyEwWC6v1
	r1GI9+4LMZ+Ah3bEPRmrh8AaY+WsEUU5xC+qSa6PkRB9Pa+jBpNspH9ng14XkDGA3nRECqQ0jj0
	p7F9FHk40IHtgcFfLvRdbaf8R/Gs6ctKrqDOzfJzXzgUsZeJfGK/VRAziEP+Z9uKwaYdN5mnXtQ
	Qazw4iwh6nVWo91x/V5i1FuUa2GWe/WpDa7R0b6Q4KrvsJYsD7doLOKcINKJmKM/9gXm0VhErUX
	+NOuxfmJ8GyQcEO9X5oLV2Vf
X-Received: by 2002:a05:600c:354f:b0:4a3:2f35:38b4 with SMTP id 5b1f17b1804b1-4a965ec95f6mr41130905e9.10.1793184421788;
        Wed, 28 Oct 2026 03:47:01 -0700 (PDT)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd39a9sm28645811f8f.46.2026.10.28.03.47.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 03:47:00 -0700 (PDT)
Message-ID: <df9b55ea-7068-44c2-bec9-6c2fbfd4e06b@gmail.com>
Date: Wed, 28 Oct 2026 11:46:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/vmalloc: drop VM_DMA_COHERENT from
 remap_vmalloc_range_partial
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ye Liu <liuye@kylinos.cn>
References: <20261026-vmalloc_remap-v1-0-b7a907814e90@linux.dev>
 <20261026-vmalloc_remap-v1-1-b7a907814e90@linux.dev>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261026-vmalloc_remap-v1-1-b7a907814e90@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bn3hziqfonjbd86wnqwdkdwd4okd3pyc
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6670340004
X-Rspam-User: 
X-HE-Tag: 1793184423-975276
X-HE-Meta: U2FsdGVkX18NAAd93Gshpyq8DOMIrrcipC0WpdZiWKzlj0+JWoxT/wsZjz/RKXqBUTRNg22dVoI/mgqWNhzOWO5yCWfKzUeTx4naIu/DeESRbf6AYPwmf4NbIEIu8RpJPGzD5UwEBEWq++SCIEdPTHp2kejBBKgD94h98HffWMQQsGw/lYrQsBjAQ3fXPISpgc3WI6M2qzlh5ED9w8VBdiCFv0cCI/xOreEiMd9j0RaM/PQ2qUqPDAHodHmaOu10P/9AD7Cz1Fwp8O00dqhdPw2690ULUQ1IgLrpFQ5KD23hXFxipUCUxh05G2OQzbzlHbhDV5U1gquhP0qpPmuJqKeC1q7ZfywVczKLD8saCOpq6rPCClnIqh5lZy/r6dpl/SEaIbTgTk9nuNJXgMEh3JfXzu4O5FXWhLP7szslUj6YPE8j2hQS6Nke+0SROOJZgUg5qFgzrub3Wullupxi7aA/VrZPuV87J8Ah8r6TzWekMwn2ZqEhrhAxLlxmd6iX+YKqUk9haaS8cUSTD1tTX2nPuu6P15+T+ZDUK1CAW+a0lrHR9WXon0FJMhp/m4xe9/9Br3kN1kyBBvvwt42JE+hkUNZm5OA07ZqttAZCrAsicVXAX6VwoRdr563y59vMgwC2hxplKdcMH8JO2Ye96UFFGVyGmq0By4kq2mUbRWcbo5yF+yAjYWGuZs50FlQhR6Vn3VugU8FNVzpDLUr2Ph8lJT0RKw8VnwzDmjue5iFqR7mRjj4tEpU+o15GMxefNLMkXqiQQcUMOQJ8rRAB0C0QIJ6HZD5S8BWNlk/e+PNT90jGT3UeCsn8EwWJvB7U9dXDgyRGcKrLVi1DFHdh1WzfI8p4bm7k0xsHidRxRJFaBrd395WEVIKibmomy6q3+kkWJg4Y9NHww3dou0zJdael1XfcFEkenEJZpCUImCdg9FD8pv90E3NSbjH5e/WMpHDWY/V1cP6mqHbMGt3
 Nl+XBsGt
 0jT4m62mTuXpQhITQIM+vC7zMiAw67/9poZOV2sKV23+jlmTL/vbzOg3+Vht9nDYdDNCnLg5EASgZ9eoNvinebfay31/EX91AdbRq89Qx6sUObIq+mLBnCXyyOrgU8mSrMbk5oWLh103xp1Gv4AwHvTZ8HNTblsBkHZ/XeDVLmYTLEvYtcg+yGH2gYy6bkimglAMir1aXEJkDKvfFqy2ZDNZuB7zE35aAHkUY0Lbpv/bBuJ2xXr9kaQqy2aLbOSv2anbCiU1YjPtdagHTQ1Pw6OmG2DbvVwqGGmN8FRfRZzrEVxzrVlC5l813Br9PX2kzaSk8uPkVaiwDXeY4nfVa0vGr+Ao99j+ctHzS8D7/JnZJcT14A7oPll003aroeW5Vs3QCqDmcKu2Tu1kKobaKJwFW12q1PF2SKdNWnBKLylBP5X2XnnWNRUdH+mFJ4uCqgkQkFGJAmk7D/ji3NVkWCC+CKbkMVBh7xA/LMw2wySPndiY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 7:09 AM, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> No caller maps a VM_DMA_COHERENT area through this path: such areas
> come from dma_alloc_coherent() internals and are freed via vunmap(),
> never through remap_vmalloc_range[_partial](); all 13 callers pass
> vmalloc_user()/vmalloc()-backed addresses.
> 
> The flag was added in commit fe9041c245196 ("vmalloc: lift the arm
> flag for coherent mappings to common code") as a mechanical
> translation of ARM's VM_ARM_DMA_CONSISTENT. It is also unsafe to keep
> since commit 5ea8ec74c57c0 ("mm/vmalloc: free unused pages on
> vrealloc() shrink"), which frees tail pages of non-VM_USERMAP areas
> (VM_DMA_COHERENT is not in that skip-list): a shrunk-then-mapped area
> would hit vmalloc_to_page()==NULL and vm_insert_page() would
> dereference it unchecked.

this isn't quite true, is it? the dma remap helpers vmap() without
VM_MAP_PUT_PAGES, so nr_pages stays 0 and the shrink never frees
anything there.

> 
> Drop it so DMA-coherent areas can never enter the path.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/vmalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index db669103dc66..a888eca016a8 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4894,7 +4894,7 @@ int remap_vmalloc_range_partial(struct vm_area_struct *vma, unsigned long uaddr,
>  	if (!area)
>  		return -EINVAL;
>  
> -	if (!(area->flags & (VM_USERMAP | VM_DMA_COHERENT)))
> +	if (!(area->flags & VM_USERMAP))
>  		return -EINVAL;
>  
>  	if (check_add_overflow(size, off, &end_index) ||
> 

the change itself looks fine to me.

-- 
cheers,
jose a. p-a

