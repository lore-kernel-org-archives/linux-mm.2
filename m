Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E265EC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 23:42:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 005B46B0093; Tue,  4 Aug 2026 19:42:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6F86B0092; Tue,  4 Aug 2026 19:42:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBF786B0096; Tue,  4 Aug 2026 19:42:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEE326B0092
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:42:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 31BF51602EF
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:42:39 +0000 (UTC)
X-FDA: 85065214038.30.BFC0C55
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 383868000D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:42:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=l69+uLQL;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785886957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NBd1rwNWfwuAmmO/dMbZ4a3bEEwd3WjdrKV1S3LKHaU=;
	b=cmT7lcheS9IAO/2O+w8AuuH9AgMxRTu1aNIZQkmJju+PJxFmCw5ER8gQZMwFaK52YzbdaZ
	ivmtf/4to7kKwb3L2CV27e2Eip8rvRwX5ih+5T/wId+sVYEV83jRMVftC32mjudT+uA1W4
	58cKmCLEYaVXB3o85R4ucqFMkG915wU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=l69+uLQL;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785886957;
	b=ZhIuoH6yenZORdG6vQ1zBngcmIrDCN+i6FY+FI8LF/SrkrL8ngc293eYluJr1N3cRBZOxl
	JJCzgvWzZsRJwuME3Do5cJarxi1qzca+VRTqsJ7wwoJtc1EoKQLL+mvh+SEr5tOr6ARUd9
	OqxzxQLMT745BXK1F2zluzIg4TdrcQ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 55FE8600AA;
	Tue,  4 Aug 2026 23:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78631F000E9;
	Tue,  4 Aug 2026 23:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785886956;
	bh=NBd1rwNWfwuAmmO/dMbZ4a3bEEwd3WjdrKV1S3LKHaU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=l69+uLQLaueo+kUy81oaqCg604IuBYcBj99+Xa4QOJ3UnC7oPzW++BUGer7yFKkpL
	 NQBTuh8fnTX5w4DYSlrEC62FZwYfCEujKbH3nRAKcP24mseR/14c2EsGT5neIfwdUC
	 40xG9LMtdeH5dWu58QdOLFCSEhpEq3Wm3qONH9Ss=
Date: Tue, 4 Aug 2026 16:42:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH] alloc_tag: fix undetected compressed tag overflow when
 profiling is disabled
Message-Id: <20260804164235.69c9473cf00ac70cd2e7ed4a@linux-foundation.org>
In-Reply-To: <20260804064408.105033-1-hao.ge@linux.dev>
References: <20260804064408.105033-1-hao.ge@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 5hamjq7zx5adbxbjha9ip3a9zspt91dh
X-Rspamd-Queue-Id: 383868000D
X-HE-Tag: 1785886957-138852
X-HE-Meta: U2FsdGVkX19LeQwAbDxANivODgYjBWS55wio0QWPZ39HJyIVJOzw/OPPaCw5gsW7GrauXAiubOl7SKf/Dnl+bNMiKOFWNUBPscD98ytFgwNA5jVQCxPG15h7hbwZZ4sulNofMfm0DreE43716GncFbqLCfTdHVqSKUAhBuF58NJhrd+1Tva/B3HJXNlgSxLAkXJU5RtjjhXlNRxivtsmxFRfhsv8GL/QS1EY7OY+ixGednAolfK0s4FkyUhrR88VM/0ZGJGJ2sAvMUrHCm1KIRF6l4cIh2VSqdwiLSQfC+inqtFSpBF3/2ianukaqiCjjmmW/qd21ZUBQcF9Vne2QDseicq8V1hZyqjf2HjH2eI4SMs69TZ+WxBw//WGgQVELr41H6dviipM+C5+/6B9QYNUH8FlVQfxNa9iaGJKhmGpMsNb9f3fwOjhj++Lfpxhp90ID/u1nyx7wOOXbwpSFOyfmJXPI01FGTOnNT//CJYx83LsnrSo37UPxaMQGINLu10dUZsgDmrrkNA2xVSumg8SUhzlkD4LBCo83XttnUeQaiboGXQalS9dVYMahFppFdlmNUuRApsbtHd19S4243S6D/B9HefJAfv1OFWDotAisU6JCIn2gOlg0fhM8MOawkNgVxGPoA+GrUBd0A1MjH+Ka38rrPz38gJUz09Y7bZeMmXTaJpGAxjQlXfB/fGKr5ZFaVnj2eRDjJoBqYIAITsqkKHk58RGTx7/mT6bL0q25BwpgkQZieCZIOG1nL+8dlmlORxgHJSD2dSjdr1rYCjdadDFLcmRPHvu3FB4LewIDKj8bSsVb9uNNl7qa4merDoFOkma0OMOpkFdXrcBCI3TA9dcIB0YchcRcLhTo+5of6XzgPdOVOYnMcqIbW4c6ApNvc+j/ei6rk+iRYkn4hmlUVJCXfUxsJMYNDIrB6R4hOems6e4qiSkyCBkAe5Gtf98tIKrEZ2f0Qt7tW7
 TFy6Td2D
 fwwAkKOHHi7cEhlomZGMME1KCz3XOYJu9zt0glG8bDvvrhYw4mWRvFME1m47upMYf8VZ1mN0K42qfTAJh8QummMrZ+PJ7M5zC7gDD1SLS2ro8aQQr0YwENzJuheUjj2cNQXrC5Md+rjZ6XtOL+W5Rv/6VKcZGedQYZVLAGUou8Vcu4dWehyoq7FVjzweUNVWGIyUbZdHRcx/+7pQE0OwLAKCvVW6tJ6Naf0X6ItC/rucTebz8j23SrF9cxOPsM4+T7DGiwBjcuQnGlbltblIGfDLy4VN64T4sBmJEQ/OLbpmkoq+7NOKOQNXM3OH51px7nuiftquVrCpxHj1jXXCgHhZSVyQFy7VjaIrt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  4 Aug 2026 14:44:08 +0800 Hao Ge <hao.ge@linux.dev> wrote:

> In reserve_module_tags(), the tag overflow check is gated on
> mem_alloc_profiling_enabled():
> 
>     if (mem_alloc_profiling_enabled() && !tags_addressable())
> 
> If profiling is toggled off at runtime and a module is loaded whose
> tags exceed the compressed-mode limit, shutdown_mem_profiling() is
> skipped. vm_module_tags_populate() still maps memory for the tags and
> the module loads successfully, but the total tag count now exceeds what
> NR_UNUSED_PAGEFLAG_BITS can address.
> 
> Once profiling is re-enabled, ref_to_idx() computes each tag's index
> as its position in the alloc_tag array. update_page_tag_ref() masks
> it to alloc_tag_ref_mask before storing in page->flags. Indices
> beyond the mask are truncated and idx_to_ref() resolves them to wrong
> tags.

With bad effects, one assumes.

When fixing a bug please always include a complete description of the
userspace-visible runtime effects of that bug.

> mem_alloc_profiling_enabled() and mem_profiling_compressed are
> independent. Once compressed mode is established at boot, it stays
> active regardless of runtime toggles of mem_profiling.
> 
> We therefore remove the mem_alloc_profiling_enabled() guard.

It appears that AI review has found a pre-existing error-path cleanup
issue:

	https://sashiko.dev/#/patchset/20260804064408.105033-1-hao.ge@linux.dev

