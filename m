Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B257E9A04A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 05:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87E0D6B0089; Wed, 18 Feb 2026 00:01:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4716B008A; Wed, 18 Feb 2026 00:01:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D5BD6B008C; Wed, 18 Feb 2026 00:01:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 57ACD6B0089
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 00:01:30 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 053E8C1AC9
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:01:29 +0000 (UTC)
X-FDA: 84456379140.30.EA169A8
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1498C4000A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:01:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=SuWzdFNz;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771390888; a=rsa-sha256;
	cv=none;
	b=oTDZU/rm9jTxyE0A8vhbrmKdxAnNx5XsJhYB0NvLwZcVVxbwmiIbG970zAt5t58MFNO1dO
	925zAt+3rp83Bu3aB5sfDhGJdBBFJ6xOJFctzvnY8tf9LWiDnX9MvdUmYta5+ifC+3zN9D
	2FGT51woL4UW7uVbW/wwTX6I52r6+iA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=SuWzdFNz;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771390888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3H4nq3Df138xPIb+CW5WPH+Xa1TG6l1z6Jt8/bJGeFg=;
	b=corE8gSCkrqZ+qeo4VXgslqArDLZdYFgiDaiBGgEi6CqvCBvQ9R/L0npr6HZw82A99uHCg
	Bio7ZOTFFf3xotQSpcXZA/Zfa+6vC+hOQ/UosME3auYmkDLbChO8SCVxrxU7PaWlFyr8kM
	CRCQDBlQ3Z2DB5fYYR+pisUxHSLAs1s=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c6e1dc5c5edso2049806a12.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1771390887; x=1771995687; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3H4nq3Df138xPIb+CW5WPH+Xa1TG6l1z6Jt8/bJGeFg=;
        b=SuWzdFNzDbsdkUgoyMv3pdE61H219AmI1eK3gL8sN7PKzFs0rsXl629pPjkOP9K0Dn
         ah/xLTxB66GRootnmkGLkz1eMGCki7hJca7smtbf872Kyf/R8Ktd8r7nTJdlde5w0AyV
         FAAyavHRvNeKor+WzLOLIrRTjNpf44YmIy+JM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771390887; x=1771995687;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3H4nq3Df138xPIb+CW5WPH+Xa1TG6l1z6Jt8/bJGeFg=;
        b=DHF1m73YB3FJH0LT+Dk9yGu6cAzdwy/M6p5Gl/T8AzfUhLYoAEv+03/YFd/VImeSkv
         45ty+7tkfrxm5GtsJO5vDyAi8El0yb/LMPlGeGGGeCLhbiyVU0K8sIgDaCtb7ZZCuJju
         0MR5lam0So0/t+j2RJeqGLbrNvaKn80+rgrls1u2NniKHINWBkzxouMfoeCL91SsjJJY
         3uzdDvOmpK+FMXO2YLtpVHZa5CTqt/XXA+plJp8oFdchaeTCu2hMdS9NopZXuZzrRQM9
         2+1QjjdcdxRjhznw3QCRl7Z/qhIobX9D4h+6RBwwL05ZUUP2pq4qMfBFiDdDAu0cc7ae
         6nxg==
X-Forwarded-Encrypted: i=1; AJvYcCVjyejOLOUEt31rcz3xseR0clqpJhm3ojnVXpqTJ0zPZvYY5L3X67tyeIhau1DdKZVyUBIu+lijQQ==@kvack.org
X-Gm-Message-State: AOJu0YwQJHDd8N05mQVxwBJXvI646wNnlSQJOHZ6SeG40nEdT6Ae+41U
	q1L9dECUK3p4jNtl1J1dL694uZpT1302INTpq4yRlHEPB3FFCRj/krxh5LaulLWMyQ==
X-Gm-Gg: AZuq6aLOJQh99u3XAi+1o7RFZcJqF+m02CAvMMq5KCXv5H5r3ma/Q4ivGYDugiVA+qR
	6cRCuwo15r8gJG5xpALOfGp/dVl7DTbyZTdiVhNgYnC9QvBr6yWNCNuAzwVbDif61Z0nScTmWRu
	EYvmKlGPMKQ2eqqQ6SwSevu7UGnqDM7ZeYkzG5w6Mbwek/CLOz8vTC5osWuVj6+/fmwt4kzKKTl
	EMYnp3bnBnhKanMJ0Y295ke5FP1hPZH9ui6i6cX58K3yS48/mzHv1ujG7lg75y1fVt+KlhctAjD
	TTDR15lhXC7+TGhzSFMU0SY7KvwlKuPLkg6M6GGmCayImwhZeaLmJuSZ7+c/SYI4B2kCui4G0/6
	FUgq44IIugNZOAQEXJzONCVTVDieIvg5B6MG40HBd018wb0db/hpCIeGHIMVwKHxY+TnYb1KnCA
	HiIpNwUR1GPs0cneMJKmttPXVkPaik1S5jlJEW9jGSiyf29zw4HjhH/BCfMkKjY8czAi9gDlvGS
	g==
X-Received: by 2002:a17:902:f68d:b0:2aa:e6fa:2f6c with SMTP id d9443c01a7336-2ad50ebcee5mr7341485ad.24.1771390886770;
        Tue, 17 Feb 2026 21:01:26 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:7f05:129a:91dd:6ce6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1aaddc46sm120117805ad.73.2026.02.17.21.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 21:01:26 -0800 (PST)
Date: Wed, 18 Feb 2026 14:01:22 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Michael Fara <admin@windowsforum.com>
Cc: senozhatsky@chromium.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mjfara@gmail.com, 
	Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>
Subject: Re: [PATCH] mm/zsmalloc: fix NULL pointer dereference in
 get_next_zpdesc
Message-ID: <xdxeirrwcmxxue2wha5vkqfle5q56mkuifv6ovunrimbz2b3ws@yq2ww4e3ub63>
References: <20260209193708.69454-1-mjfara@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260209193708.69454-1-mjfara@gmail.com>
X-Rspamd-Queue-Id: 1498C4000A
X-Stat-Signature: 5gq7df419a1w4dsh71u976x8xhmmoxp9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771390887-958546
X-HE-Meta: U2FsdGVkX1+nXrothiiezAS2HSJwpiha0Zah7XOSoUnOio1fsrCWihspUBJ24szNnM3guTEbCWJx8ogf6dcxbhO+0bf694UHYcTQYtopk1vf03nqsmUYeYqoQtBxNU1bX3XX+XWw+DlH699XarxnjDmLZth3cyGkafYC1eugDaPEcMRpoo9TfVlFXJ4xMKzhXWj6dimZPuzytT/cVvoVf+ycvkt8oCHOiI2OOrvMd7GjmhHweNpmH4rbQCACr5AS4FXvJg5WkbC11vih0SGfCdo+kqfg9cY6WkncOcusaYYNmMpfmjoK29hMV86h2fQ9WwAyhoffwTDorCPCHloK4t91NrzJsO6LfafhViwsQj0fRGn6+Wt23k+z5jIuOEUMpVRveOjYB70kOM0qEYmLOfgOQqJLnhwSYqP4SVkCrVTAXz+j1c6sAaISZM4jMNX2yVy0lu3tDIgInNkm8RO/UrpWtX/9M0zvwqmGqL5xZUSm9jwbW4lrPxAINtCp7C5P1FbgdMW5bXpicXPekWOSqknqTqWpoT4S2iKlLfKt5FJKvOqNTZ1ycCWfBD3Cia2jf4umoeuU+IPol//XfNUZrfwqWSd5ZZWOpU5NKYidG/g5uPu7c59YZc7+NsDb8K2CacoJWKM8e4RxZW/vTGM6E1o94EmbRDMGgBzXvjH5GGZzla0F/XPbZqi5xLUda96Xcd7Q59JU/aPHKIsElHZsJx+vKXtNHlm8c4uZChXVUUxgKWsmE73/9yFYNzpGFJR58vDAyMF0pmkh0fxcs6leCS9sJSENUexH+DcjYoXBTrppGT4PHciStz18BtAgjDerC2CH814s1F9GKjHy7kFNhhuz9fU5FKmF5CYeQlfeq746QT6ETt0Xvnxq/+JHV2yEqLWvXMj4GMM9IYRa4aJWWfEheSZejEEodSwjV5/vkW3ScXZyn4H8tAWyzI7kAVu09h0oJ3Q4CS6FKuDKxjs
 OYjBV9Ky
 wM7wx5w/tlDi1jwf0KchQXTBcuKZ/v61S3SUQgiuIMkbhFpdLuYByR5VClPbcB7eNVh2w7JMsCL45Rf+86Q7EOy+lHHcLtv8vXU4eElKQBRwrtAObi2xLUQhzK4igEIXO0m4fNuV03hUoFh7zplHJzpHWZl2Ti/8tAfGEAgHOjmzbZui8fWyr4J5nI8a02SSf5+QmT78YEMmRu2B58K1w2ZWYWEOzOFg1zvxtmPlH4j3ER5kcAX/2ed75B/5wofEg0IC67cA0I5bR1u1EYWNG+pTRRfQ6Z0xJS10UR6qqezAsCVBspJpW/Hwe9VLvxxd1vqe65XS5pQ0e1B+c0pqjCcI+UfV0cB2ByTUXzudWG7yCkKDSJwBWaM0YFBI/6+wsYJIZZLGtxZvdLUKPwD56ym9u3nwacVITJKfBBoJFsDqpaco4OGUWtR5rP1EI/ytRq+uYXtSJ7/Q/C0I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cc-ing Minchan and Brian.

On (26/02/09 19:37), Michael Fara wrote:
> get_next_zpdesc() calls get_zspage() which unconditionally dereferences
> zpdesc->zspage without a NULL check. This causes a kernel oops when
> zpdesc->zspage has been set to NULL by reset_zpdesc() during a race
> between zspage destruction and page compaction/migration.
> 
> The race window is documented in a TODO comment in zs_page_migrate():
> 
>     "nothing prevents a zspage from getting destroyed while it is
>     isolated for migration, as the page lock is temporarily dropped
>     after zs_page_isolate() succeeded"
> 
> The sequence is:
>   1. Compaction calls zs_page_isolate() on a zpdesc, then drops its
>      page lock.
>   2. Concurrently, async_free_zspage() or free_zspage() destroys the
>      zspage, calling reset_zpdesc() which sets zpdesc->zspage = NULL.
>   3. A subsequent zs_free() path calls trylock_zspage(), which iterates
>      zpdescs via get_next_zpdesc(). get_zspage() dereferences the now-
>      NULL backpointer, causing:
> 
>        BUG: kernel NULL pointer dereference, address: 0000000000000000
>        RIP: 0010:free_zspage+0x26/0x100
>        Call Trace:
>         zs_free+0xf4/0x110
>         zswap_entry_free+0x7e/0x160
> 
> The migration side already has a NULL guard (zs_page_migrate line 1675:
> "if (!zpdesc->zspage) return 0;"), but get_next_zpdesc() lacks the same
> protection.
> 
> Fix this by reading zpdesc->zspage directly in get_next_zpdesc()
> instead of going through get_zspage(), and returning NULL when the
> backpointer is NULL. This stops iteration safely — the caller treats
> it as the end of the page chain.
> 
> Signed-off-by: Michael Fara <mjfara@gmail.com>

JFI: all of your emails ended up in the SPAM folder, somehow.
Recovered.

[..]
> @@ -735,7 +735,19 @@ static struct zspage *get_zspage(struct zpdesc *zpdesc)
> 
>  static struct zpdesc *get_next_zpdesc(struct zpdesc *zpdesc)
>  {
> -	struct zspage *zspage = get_zspage(zpdesc);
> +	struct zspage *zspage = zpdesc->zspage;
> +
> +	/*
> +	 * If the backpointer is NULL, this zpdesc was already freed via
> +	 * reset_zpdesc() by a racing async_free_zspage() while isolated
> +	 * for compaction. See the TODO comment in zs_page_migrate().
> +	 */
> +	if (unlikely(!zspage)) {
> +		WARN_ON_ONCE(1);

What is the purpose of this WARN_ON_ONCE()?

> +		return NULL;
> +	}
> +
> +	BUG_ON(zspage->magic != ZSPAGE_MAGIC);

We can't add new BUG_ON().

>  	if (unlikely(ZsHugePage(zspage)))
>  		return NULL;
> --
> 2.39.0

