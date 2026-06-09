Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAFFFCD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E25E6B0098; Tue,  9 Jun 2026 07:59:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1929D6B0099; Tue,  9 Jun 2026 07:59:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CF9F6B009E; Tue,  9 Jun 2026 07:59:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F06466B0098
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:59:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 970BDA04E6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:59:41 +0000 (UTC)
X-FDA: 84860229762.07.1771AAD
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9BD4EA0016
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:59:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cIpcJ107;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781006379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PsVnYhIRaQyLsI7wGZnt+j8rEmItGadYiQfITht1l40=;
	b=tTYaRkAoUANG/sCdRkH1wbv/gy8eek+GLt17LI4d6lBgyZYqwv6RK18thCSFFlqBIFLfqq
	Z3E8gsSnuQBxZBt0xfb+0sitRW7ei+iR0yfjx1cqYdyetiFiCV1qcc/9L1YmkXSrmPqA2q
	565SjuTNhfNV0gLNQaHJ7SObeJgTb5Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781006379;
	b=SWQdawevgdPa51PoXSLGQCccnVF8s9G23a3w2N1rjNRtj0QTGvulJDoHjOoU0BRsJl+N9E
	9M7q5iYOrZgB4DMhLPaemhIIEY5CCPsUnqhxJecLfJz1d7ONzsZBcn9sO/9gULeLPerI/8
	5/vDsFuMJpYgDf3Uj7tldUSmIb6K7Ew=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cIpcJ107;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <20a5a752-3ed6-4fde-96c9-e8369b15524c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781006377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PsVnYhIRaQyLsI7wGZnt+j8rEmItGadYiQfITht1l40=;
	b=cIpcJ1072g3I1dKqv0Ca69HML96nJElqAoZ8z4AVUqYSYFsvIBHxr8BwtOAlSIVne2rW75
	zDmSS7paluzm4H1qdvSGWBUv8bkZydbVqTI3ymojalBokgUP0npFKUnkHRUhjh7GR9hvBo
	DpSns+Pw7KvtyFE+ixabb6PtUYL0TQk=
Date: Tue, 9 Jun 2026 19:59:28 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 5/6] show_page_info: Remove printing of page index
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260608210618.3437216-1-willy@infradead.org>
 <20260608210618.3437216-6-willy@infradead.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20260608210618.3437216-6-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9BD4EA0016
X-Stat-Signature: umrh7ezkcpsnpki931mgzjr9sgeqzxht
X-HE-Tag: 1781006379-969357
X-HE-Meta: U2FsdGVkX1/62tm2LqqgQVLesLaDeTbLn+Oq7ZO7iYdTBSgISLnVTMRSFHToUexokzk7XXQlICK7LUm8M03IQ+0T42fGZTsn8NKQWtLT/DEDJzcs+lhNn6jNcrbVPUVvnquexS1sEaAyZ+yYRYhXCaY/HAyUV6iPXUtmG2nesqW2kzOaKRg58A+UGRaWI3Yq1FCe2YGQkMper08fmvKe/Imhm3YlIwSbaur38ZgNp9PhKuXXFiSIGDlKr8pMitKseREbhO6n7gIcHq2pdc2YMZ13acjOj/BglsA6d4JubmplDwNPnd6nXlGjM8sXDMxe65sTp1nYl9TvrjLOwhTrkx0osZqUWii//kIdM/BN69E39hCshtmE4ixCUD7ivsZVd2mwEde5AzohNe1FZSaIqifoAhWc4XZu3ZTHBvt9Dgl/FDx+VcSGjdEx+Zaa3XAIrWO6FcnqvPovkFYCuR7YByxZt96+PwLHIfTKTLJVQWJnHhGMnndvHX37fBUf56SpFCMYkMiB72jycuoaPlUcjevZ04TA1gz358Gpjw0YFIb+QvGWmfejfydvx61FhLYfNikjp+bupwwPYvbVDvhhf06DG+IhV7a4rylYZ5ZYoi2FIALptKL6ImX9iF2x0szuAj3YvponFFzgLyh7LsUj2dX2uidlYZkyR4tjtTX6oCFOv6+0GHgO54DkES3NZKSH23qh2uj2BLfU47AAjB3nL2nwgbz1lAUlBlJVp81tnF0gXKEB9JSDQeiTpsO6Zl/VtNgZWX7qEd6wee3DUHNbFftWf/MH14METwg70qTigsO2ftyCxOOEO3By6O0zV0bPzHpAb1vAKSGhvcvuRLe/reKC7K5RPYMcQYzDQAkBg09kHGbqkAv2RPNEQEa9Vb934r9lFgDpSTaOE0FsBblFMC8axq4VGirOE4lmdBJiFF57u8WRNYshOQJEwFHWK6UhILbJQQ2u8+GAVdExn0Q
 46/Y6PiA
 OC7lHfj7VJ+vhqp+O+aA7+2aU5rQz6c0Z5GkeoFgt/V8e4offl/gqhTUglyHp1JU8D1E7+Gozc9KYqzBK0feDSN7SAqHaRz4jKi7n6z8vzqUiSDkR9HdpyklCrZmV+j/IH4dz9ATODGbzi6wO0aOJk9mIZXXoArKUsDDM2Vu6uNi0fkb50i3Wm0kahLBM12UEAZRQzeFHS4jxnG6hLkXa5u0nQFjVddmio9iX8SvZqpHBf3gCE4SSH2fPgykTv2pNf/pzvJWVlMzWPDUdRu89jpxKbhvqvGAPGWN/1jM1oEI7xmgPbxN+96QBzS0sqah9XmqQChwYtt/F0r1HtWz6HgrEqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/6/9 05:06, Matthew Wilcox (Oracle) 写道:
> Pages don't have indexes, folios have indexes.  Just delete it.  This
> script is going to become increasingly barren unless somebody steps up
> to maintain it.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Ye Liu <liuye@kylinos.cn>
> ---
>  tools/mm/show_page_info.py | 1 -
>  1 file changed, 1 deletion(-)
LGTM, thanks for cleaning this up.
Reviewed-by: Ye Liu <liuye@kylinos.cn>
>
> diff --git a/tools/mm/show_page_info.py b/tools/mm/show_page_info.py
> index c46d8ea283d7..69094ef50719 100644
> --- a/tools/mm/show_page_info.py
> +++ b/tools/mm/show_page_info.py
> @@ -91,7 +91,6 @@ def show_page_state(page, addr, mm, pid, task):
>              "Page Virtual": hex(page_to_virt(page).value_()),
>              "Page Refcount": page._refcount.counter.value_(),
>              "Page Mapcount": page._mapcount.counter.value_(),
> -            "Page Index": hex(page.__folio_index.value_()),
>              "Page Memcg Data": hex(page.memcg_data.value_()),
>          }
>  

-- 
Thanks,
Ye Liu


