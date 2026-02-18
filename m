Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78F84E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 05:46:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B55C86B0088; Wed, 18 Feb 2026 00:46:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8EC6B0089; Wed, 18 Feb 2026 00:46:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BABD6B008A; Wed, 18 Feb 2026 00:46:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85DC56B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 00:46:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 282B51C35B
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:46:38 +0000 (UTC)
X-FDA: 84456492876.19.EB61C63
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 39F284000C
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:46:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bZAUdPAW;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771393596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NrIgBUHCt5CwI7FAQlrmHz7F+fF5gar5WUaO3VV0dmI=;
	b=NqXeFW65XTpuTCNh6nQfujdfsvH8hHbCkxngnPDw0zexdzROEYjLI0rV0nLtAqGRhV2ZZB
	woNBXYC55F82PoIAh8z3jBuJwSftao3bL6JlQp7hHGuXnnrQSmRiK8wdB9WT/JOe7u8906
	Kg8ej0wbzjHUEeI6y2sF1BeHz4wXis8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bZAUdPAW;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771393596; a=rsa-sha256;
	cv=none;
	b=32lhdL/cU5km8eTmkeI6HsZYsetKrfejt5wWgQHxOEPvzJpDULoRwd78wEq6JT/MU+xmuk
	CUvot3hht7N77bk/IqyvQ1YslEhLqHAO7t1veURkfHnjXvFxs3hTPp7Zurx1zaIdrzW48N
	ZK/apAAZF5GB1JXSZEiPLUJCkOrqeZs=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-824a6f2d816so2361527b3a.3
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1771393595; x=1771998395; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NrIgBUHCt5CwI7FAQlrmHz7F+fF5gar5WUaO3VV0dmI=;
        b=bZAUdPAWV2eQP+BVCo55rmFvDSgg2XD3rGhx5uvw0N3FCXyP55k522Twv64mZW8t6o
         7arGK6nnnOzqb0//1N1wLOUdOuFxCTyt7s1PTeUX3j9xpGm4U0NoDGUyP2GMP6kNU2jl
         tjsa0TYUf04+KcFLFuHCRW4wjmADPbcCWFx9s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771393595; x=1771998395;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NrIgBUHCt5CwI7FAQlrmHz7F+fF5gar5WUaO3VV0dmI=;
        b=SQIUQ3l5OLN4WnPOhMZPRSb4op4X8EB3NuONAHSynohnwMmiIc+UsLCLGYYQfkdWeI
         09RjJ2J0io8/0w50i9L28e/m286dIRTcGp0GY0XY2vfao7PQKxcpR0dDQipgIj6UvHFm
         NvFRWxitHO6zY+54l87m7qbPg3F2Aq3AroS2rpMKNzICGdUU4V8hE+ukJrGjfocqU7iq
         peaIcLyKkyHR5o3Cuclsvbn3sAb6ZLpc9xKX1SZfDxXKreA3GmLOWsEOvqZUNmXXVszq
         Bjg0LhdvLHfQliXiVNfYS1Iq+pur/q4eU5Ptf0c+Zp9cpRfLtkt83QDJ4ebCZWJnKNJV
         PCdw==
X-Forwarded-Encrypted: i=1; AJvYcCXNXxsQmOXbLewuQ6yZp/+EdulQnhwI94sMwBRtM2oibYKRSW8Xkpj/CyxSWXYDElk9fC/Anr3kcA==@kvack.org
X-Gm-Message-State: AOJu0Yx95A3SujBlMofhh/iK7vns8nrg6nhow+Vd1d2Mp0fXib/fnk8L
	5wiLP4yf0GRS2SK+GY6UCcWmG8uoMx7QaNhhDZ1SekcMcR4DLtSV5MQFdXM6riNhrQ==
X-Gm-Gg: AZuq6aIXlF9/okRtWfRFpR3tvjvtNHlAlpxJD6hKX4j96UvOefiaxUq5Te5SnZOFtyr
	y/iXb0hfL6hUKOXrKT/zU0Zv0O/Jd2t7AyI41IImZFpHWgIcR7GTKsFg/dwZgdMgvFPYA5bGv7M
	fUYnv/fBfiLZDj1TDIuDlw39jeScXlkusaZhqLReHoWnhm2uKgDAS2XHL2dE+2Z6tUBaDcmBs+j
	+SpbPBnaQZB2/W7txaXvw+iQJ0QJEZKUCv5wXCfpxVxQWwFoz/emXrWbAEgloc2rzxJ1GrQCGwL
	vCfL6Qq4zCtd09iXmRkaxcKSwkAf7Mck8osHgozUvoQ+nqAZ6Bo/NZ2Xf4bWVVhYqCiCuyF4+ww
	ZDt8R7Z96Z6CaEhp+1kjCbhFl1YxyUVuEaQhAsxzOXvYgdBJ/j0HHbqjzsjs9qmp+802CLpD02G
	UXCzKpqQGSyOLFgDY+bFhI/0ynnNw0HeE7bPvdCPsPBUL/Dq/LqFWX0A5onvKtbyijfo0W3nEdj
	g==
X-Received: by 2002:a05:6a21:1391:b0:32d:a91a:7713 with SMTP id adf61e73a8af0-394fc2e2cfcmr703976637.40.1771393595014;
        Tue, 17 Feb 2026 21:46:35 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:7f05:129a:91dd:6ce6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35887a3e929sm396640a91.13.2026.02.17.21.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 21:46:34 -0800 (PST)
Date: Wed, 18 Feb 2026 14:46:30 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Michael Fara <admin@windowsforum.com>
Cc: senozhatsky@chromium.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mjfara@gmail.com, 
	Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>
Subject: Re: [PATCH] mm/zsmalloc: fix NULL pointer dereference in
 get_next_zpdesc
Message-ID: <pkyw3y4yd5a22hr643mf66zsfo5slmmsgzov6a673ag3gbfcfa@bz2vx4h5mw4x>
References: <20260209193708.69454-1-mjfara@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260209193708.69454-1-mjfara@gmail.com>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 39F284000C
X-Stat-Signature: dr7obnxwiwhjduntceagm1raahsmdt4i
X-HE-Tag: 1771393596-701298
X-HE-Meta: U2FsdGVkX1/ACxUkAxy+pw1ZyMcmF9LavXJTMu0/Onj2ZjT2CMYZuYy3McJuZdzY1vqpSicm3aaP79GGcoaoiXqV7oUF0c7H/2sqtbsqgio7rM/KuOACDMcSNpIDEpL3+m3Nqb2tvzK2l/h9gnW+dYQgupk06mum7fmSgdhWSIoaOUk0cEmAjg3wVwHdTSLXb45VbPnTM134xyP4d3UtqcQdfr3CoZ5m6S+RH415rbu5CWQGx8ZzRI6EA2GKaOK+nVBOcr7Ks0cFDc8kotKv0Xcje6iuouOygwQlzhKix66CcM4b64tfJ5cx7I1M2pu2y7W4LVS+EUDjqMo8EHGcAdl8jUJwW0OE0zlUGtVIwSVIh1EEEeVW3of2FjHsjXq9Aj1sISGcwyVhI+m5kxzFqTmHQ6K8gsRzcoZVJ1TVe9O7SB5E21dKsfvSWShj7A7IK8xFhz5dixzJ8ctsBfZSUmcdcAQ7Gx6TZ9F7WT10GCqY340WEqVsZdehsO1pJqpnsZffSc88K6RgSQu5fLxKuMwtSE3iUSPyRlPjAG9bB0x27YxCYzatZGRqw2mW0/78C/LoIxzN1TVUAd9vA7Nb8XJvsWT3wqkp2DeLETUqtSkwbXVjdHQOBL902YPuy/ml5HI+TAXY5cMHU0jjVcTDoK+L3W1TjRRt61s2e1kiOAwBJ0Ob7OsJrvzWK2LZbeeaVXEF1xcQuKyd8TE/i1o456fKB9MNKyctMsZHiiAEocDErC2n+k5RAgcsomPSd45lOFLqcftBGYiskQ0iad6XC6QgRBU5rXk7CC+iL439GQzEJzFnX1JNWi5zwTzcG8UGB1qFyYInzf12VFIgMcjaRART5rb1yO62VLnw+3GcBdRcHE6IhKtRQj0hwq2wp9/D8bBkm25lUK2RWZcGeyo7rWyfACqrYHkiR49f/xGQ5/hlbI575NqGI887MR5Gw91bdMXZJgwM+xzF8lvPWJU
 hgtoBP7R
 HB24+Mfjd/9zuABIfGHdrcqK7suVIVUesmdPvs+luq/PquifDnAIg3/2/ImLnTk9kzLEX/qpGciMRcgMoTE1sUeUgecWzN0YASFObiLAR2Z9Eva9OQbmjKsAchhPZwB8IomXLb2RWwpAG0M9LeLN5fcp7oEfmukWJK2v1jA14MLQuT4wJpCsmU3xMF2PgBOGYMpu4zJwgDm3kaJrjzqYXGBgNA1+sQTiLge/43KjxErTklFLN5Li2GHb6FpbTKkpzss9LGd6FtnyP+wIfAFiYep7/vgpKybOubz6+BZgU2RFDwt8Wz1TnsHdldozd+Eh+mMyL13c4njjnJC2b5Z3oYbyujarPPYczB9YbY0jhKXZxOZ0ldTyjDYNNMDf4HsMglEt+HRwbZAwFsG6ZQyANNoVFJXo0/ga4QX2O78aAB8UubxbjLBnAQsNP3bnA4m5Ub0ttGarCkdbeJQM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/02/09 19:37), Michael Fara wrote:
[..]
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
> ---
>  mm/zsmalloc.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
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
> +		return NULL;
> +	}

I need to look closer, but the quick glance suggests that this is a
problematic approach.  We can't just return NULL from get_next_zpdesc()
because this can potentially cause issues in the callers.  E.g.
trylock_zspage() will treat NULL as the end of the page chain and
return success, which is clearly wrong.  We also have a bunch of
other callers that never expect NULL from get_next_zpdesc().

