Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD85410F92E6
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 17:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 249476B0096; Tue, 31 Mar 2026 13:45:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 220A76B0098; Tue, 31 Mar 2026 13:45:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15D0E6B0099; Tue, 31 Mar 2026 13:45:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A1236B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:45:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 90725585FC
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:45:25 +0000 (UTC)
X-FDA: 84607085010.02.2D383CD
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 90C6CC000F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:45:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sH4tIoUZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774979123; a=rsa-sha256;
	cv=none;
	b=Gg1kc67GQzebqg0wkCTSHvJH8q+nOHwVHhs9JWZFv7QaQOw6lt4BHmnkenyWUOL+kqSc3/
	dijaNCJImCJ0rzOkIzUhVP7ZOXqQ7In7jx46fdC3xSIB9A3MTMrniQ7Tx3pbbeCJ2y/zka
	aLyIuAsYZWOTP3ONWlidinChA3O/LTM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sH4tIoUZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774979123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6FXrG475cDPtduYVwRttERvMXjCgD4c7f7JNUYgbB8=;
	b=UAM7zpIwjXPxdqRNOXxxiytP5NvU5s2oMFy2MF/LQH+ZtejAdA+pX+RJWQFm3KmjHJV+7v
	v5VfYC8Q/2Zeve+G7Q7jeOoOg0TvEsafSRPW+ykGv2mHpiLEpLuA33Fkc37z+DnJFZiog4
	+lnOsdsAcvjV2J0LmHgiuZ5v7gaL0Fw=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5a133b686f7so6954141e87.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774979122; x=1775583922; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N6FXrG475cDPtduYVwRttERvMXjCgD4c7f7JNUYgbB8=;
        b=sH4tIoUZteQuqA6GkzhJF04tK7Lg0AD613v2IWuQxyI5SvVFDOp+W/wWSH0gHAHok3
         OGXwc62c+Q3Y+oMv6TbtTmu5FfbLWzasEnasdpJSoO5J5wskd7h1FeTSOyERmFnEZ7BH
         Mx8wJP5So+SPlPtIT4rNM1XpWYDhQGdLHU71NWeY669hfX8Ciu5a1Pt4BDWIT3LNOVV2
         Fz7kL5/jwDlzEa3BuxOy0Uh7PMDoe1W55wIze1e3ISsw8Gm9JDpX4+ntEi2w3BC0tUzb
         QZQus4yl9Cks/gYSZsQ+CZcvMNW67SeE+X+FRcS7LMG0toEpoaOduxqmEF3ajf9w8+AV
         RM4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774979122; x=1775583922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N6FXrG475cDPtduYVwRttERvMXjCgD4c7f7JNUYgbB8=;
        b=XZ1ODE6jvliyEHTWZd8CQHrC2nlTD2UggCPU/GmX8ACURv6H16BITsLV+9YU7Ka86l
         RMPPfb/54ZuWVPc/UjOAOQ/zvBI8YsgdH9+FTE0ge7F8ywyOVo7dBkEFQK2zvZEcBLjH
         askK6FPND3ROSAQJ86AcgJRXxOIM1GiCpzkcqI3HXMgrTAvqI/qVkYqYwxyfjGwNnOG+
         x2GsVBqGXJ88rYEfLXkdaVCU55lA6Qm3LXz206MRwve67+SOwPAUeb+GK8e4yud6RVHB
         t9NoFwfi2JBFYP4LfguhW0u5ubb4iYx248vw7tuxf3Orj6esaUE5553mIC8o2ecNSYvA
         xAFA==
X-Forwarded-Encrypted: i=1; AJvYcCU8NKRv6MV+cfeeTo8JKPDNZHA+AqIRsc2YRcM37FOgo/WisP0ON2D0g3msm7FZddK4UY9Op+Ph6g==@kvack.org
X-Gm-Message-State: AOJu0YzCKbaE1fIFqOCIY39RO0nn34of+E/WEWCvVsAlMoT97TfiFVPu
	iJzlvBJC9jMftj00Pv0h7qKwNQOM1BGr08lzUWq+5rC0VwFo2q1mpms4cFxX6/cA
X-Gm-Gg: ATEYQzxPusTjb9eXP21Q5D2n5j9vwq8Kc5lmV0X0BWHBx21urYPz7H8yE1WgmouW1Wn
	Ki7tmCtYVvJZkNapY4kyXF77qiiXMuxpj8dpGyJcq+RT/seFgBPjtWN9t1kOSiERJhg/fAvED3T
	qltNk6mCD9GTiWimOcHgedAvNZv2rvQQDbm8+wOGViIwGEsbATzJGLTN4ozhHtwR0sR1FPYRPiB
	IaM11NXeZg90ke2HtnT+7fEnkebkxtgWtMECxS8KA1JM5if8mTkTMajQJtyUIwyvVwyArPZVAML
	T3w9nW0eESbiexJYLlB9zkl1f6lBxl237J7q93K3ptITBtElkzTnx0z4vSkD9KtyJ8yiK8WMqtZ
	0xAz5enPWvcBgCbncja64UV3DuNtj3w0eRmYqL1uG0XMDVUIDvB6K0odrJMFv4/INlRl1R6hey0
	4=
X-Received: by 2002:a05:6512:1282:b0:5a2:7ba1:493e with SMTP id 2adb3069b0e04-5a2c1f0d4b7mr160277e87.13.1774979121746;
        Tue, 31 Mar 2026 10:45:21 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2b145f145sm2594562e87.78.2026.03.31.10.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 10:45:21 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 31 Mar 2026 19:45:19 +0200
To: shivamkalra98@zohomail.in
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v8 6/6] lib/test_vmalloc: add vrealloc test case
Message-ID: <acwIL5BkeZ8IpgWx@milan>
References: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
 <20260327-vmalloc-shrink-v8-6-cc6b57059ed7@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327-vmalloc-shrink-v8-6-cc6b57059ed7@zohomail.in>
X-Stat-Signature: kyic4569n6m4sjk1o4rh9gneat8uxtye
X-Rspamd-Queue-Id: 90C6CC000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774979123-413429
X-HE-Meta: U2FsdGVkX18SnXKilX+tY1s6cOORHs4mnKWnz0Py0gfqjDk5Wv4Zig3Uc/9K9Nh61+BY/q0s/R8xWGB7xM0+vsFqZe4gKh7016pSeJhiXcbN9GBR7RorGpn5dYtdB4hArsT9jRK8/Xq3ou/tUlYsM7TeJDYezIGdfiduQfFYuGqtLWHiX+TswK4HMGmunJF4S1x9IWxrSYbORY6st//KXyB6JcTsrjfNEmpulsQbr70dy1jCzGkJsEmKsVt/QzXlW5FhYMUtcov+iZOAslCq1wxsavxUxLcHK8o0cWA2HPnh8WCe3U6qVaR2+xV0qP2UzP555VUjKRXaalAmEm/HXdRpqLuJNH9FQXkXn/Hn7uopfNKW+xIDle06qvZ5IH5n4W0yzcsT/9UUVfFNcWOIsMSJX7Ro5bjdEcMV3mc6uUJ0iNDa8ulHvfa+espTZGmQesGv9J+qqcElkSFkPlBMmhnPE9jg65rZTcGvy0Nipj+1fBdK2xCnXhHLXnPEEW998SHsa5TL16keMk2q5DaTSIHDOjZo9YI7Dj7XHrOvkg7D3xZslzx+HJN38rVWsaJ7/SuANuP5fH3A0A2bOvv+mCxSjQW7WJm+vE9DeahG3Y95hk31UHQWKUtvdivF5+ML7rPM5L7XLITM6e/PZDF5EEkDN8PH7hEbzHwA4YChapvcZdLnNQh7AnkAsTCOYHwsmeIwYdrHtFFhuB5UGv3rsLKrVGmY8xcTm8hCw7YvZ0gMct6jw4fJFJtU32NhuhimS23Ut92InnxvTEjM4Nj380XmZUjJvZRdjfDRnm2vtHyIZoL2d9N+S7Rg10gZEZbxFgD4ewoj05BzHJiZwAs2fUutVnhhA9diSJdqX2JyuVDYxNLOV6ysrayxuQq4HaXWcwToVfmyWv29NNM2pABtrXJE8PB1TN3qlROgbNHW3wDCZPLUXidVc4U3HWTyurZhF5Q6ga4eK10UaGDQY0k
 CBr0ENta
 PbIYwH/sVuKWmq+VccL/p+R4AJApLXFGf8WaUNJqs1bFqpOVY1UFLcDcXGji5NRO3Xhd3+X1pQuit81BNe6fJ6uWYmydbdDrafK6EIUSFZaWm0yCFd8jZvGwANZA6JEd3fqzoGZTR/qyevr8BobW3RnmYc9hEs2yvR+MvRJsqEj8JjSuYizwLGZHX1ztT+P+UjxIaH7uQH0r4ly5ddhFfB2+LrDyHRnDaCUCxVCo4tlCzmqs9/rg/Gy+hzQaZyk6cXspiup1TcxNMSWPtSbPP5WysKo4FB2fW0+6rsiQ6MKDcQqasa4Z6tAo1CwgQdHLPzVjZdUCqsZXNYz4LldldnUyY5JNd/T+8s1JkV8w2Br6QXHYO8J9VOHeBIeP2JvMzXpjBFy6AerbZwws0ivZRKxFXvkYRAWRJ0qCDdtvkI4IhgaQUMoJPdCHe5kJSH0o/WVsgghgNyrXl+FhlVEA1J7+haswMXhA4fW9UhOw0yMBkkekOFKogh8KkV6RvNFzyvX1xtbM8wbv18S+TRTIQ8TEdPMz7Q8m6lk6L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 03:18:42PM +0530, Shivam Kalra via B4 Relay wrote:
> From: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> Introduce a new test case "vrealloc_test" that exercises the vrealloc()
> shrink and in-place grow paths:
> 
>   - Grow beyond allocated pages (triggers full reallocation).
>   - Shrink crossing a page boundary (frees tail pages).
>   - Shrink within the same page (no page freeing).
>   - Grow within the already allocated page count (in-place).
> 
> Data integrity is validated after each realloc step by checking that
> the first byte of the original allocation is preserved.
> 
> The test is gated behind run_test_mask bit 12 (id 4096).
> 
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
>  lib/test_vmalloc.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 62 insertions(+)
> 
> diff --git a/lib/test_vmalloc.c b/lib/test_vmalloc.c
> index 876c72c18a0c..b23f85e8f8ca 100644
> --- a/lib/test_vmalloc.c
> +++ b/lib/test_vmalloc.c
> @@ -55,6 +55,7 @@ __param(int, run_test_mask, 7,
>  		"\t\tid: 512,  name: kvfree_rcu_2_arg_vmalloc_test\n"
>  		"\t\tid: 1024, name: vm_map_ram_test\n"
>  		"\t\tid: 2048, name: no_block_alloc_test\n"
> +		"\t\tid: 4096, name: vrealloc_test\n"
>  		/* Add a new test case description here. */
>  );
>  
> @@ -421,6 +422,66 @@ vm_map_ram_test(void)
>  	return nr_allocated != map_nr_pages;
>  }
>  
> +static int vrealloc_test(void)
> +{
> +	void *ptr, *tmp;
> +	int i;
> +
> +	for (i = 0; i < test_loop_count; i++) {
> +		int err = -1;
> +
> +		ptr = vrealloc(NULL, PAGE_SIZE, GFP_KERNEL);
> +		if (!ptr)
> +			return -1;
> +
> +		*((__u8 *)ptr) = 'a';
> +
> +		/* Grow: beyond allocated pages, triggers full realloc. */
> +		tmp = vrealloc(ptr, 4 * PAGE_SIZE, GFP_KERNEL);
> +		if (!tmp)
> +			goto error;
> +		ptr = tmp;
> +
> +		if (*((__u8 *)ptr) != 'a')
> +			goto error;
> +
> +		/* Shrink: crosses page boundary, frees tail pages. */
> +		tmp = vrealloc(ptr, PAGE_SIZE, GFP_KERNEL);
> +		if (!tmp)
> +			goto error;
> +		ptr = tmp;
> +
> +		if (*((__u8 *)ptr) != 'a')
> +			goto error;
> +
> +		/* Shrink: within same page, no page freeing. */
> +		tmp = vrealloc(ptr, PAGE_SIZE / 2, GFP_KERNEL);
> +		if (!tmp)
> +			goto error;
> +		ptr = tmp;
> +
> +		if (*((__u8 *)ptr) != 'a')
> +			goto error;
> +
> +		/* Grow: within allocated page, in-place, no realloc. */
> +		tmp = vrealloc(ptr, PAGE_SIZE, GFP_KERNEL);
> +		if (!tmp)
> +			goto error;
> +		ptr = tmp;
> +
> +		if (*((__u8 *)ptr) != 'a')
> +			goto error;
> +
> +		err = 0;
> +error:
> +		vfree(ptr);
> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
> +}
> +
>  struct test_case_desc {
>  	const char *test_name;
>  	int (*test_func)(void);
> @@ -440,6 +501,7 @@ static struct test_case_desc test_case_array[] = {
>  	{ "kvfree_rcu_2_arg_vmalloc_test", kvfree_rcu_2_arg_vmalloc_test, },
>  	{ "vm_map_ram_test", vm_map_ram_test, },
>  	{ "no_block_alloc_test", no_block_alloc_test, true },
> +	{ "vrealloc_test", vrealloc_test, },
>  	/* Add a new test case here. */
>  };
>  
> 
> -- 
> 2.43.0
> 
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

