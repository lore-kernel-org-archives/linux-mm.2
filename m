Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B86C0606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i4DZdJMk
Received: by kanga.kvack.org (Postfix)
	id D7DE46B05BF; Mon, 23 Nov 2026 11:26:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2E1C6B05C0; Mon, 23 Nov 2026 11:26:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6B626B05C1; Mon, 23 Nov 2026 11:26:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A55296B05BF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:26:05 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 342F4C097F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:26:05 +0000 (UTC)
X-FDA: 85466910690.29.846056A
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4449340014
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:26:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=i4DZdJMk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795451163;
	b=ZF1WaekNBtPOSVT6tw9JBOkRKYQBmmuLjPUCmzvyYnif93qMFUwuME1Xu5PEbL6zGXe40t
	6F/S7AFb9HIciW7zSAIX/0m05qWmVt49GQXQTx1WVBtFjg80baGcICqSnfKY91nEXrKzlW
	sEGP7Dtet6FrJLhLEL8Z8rRTqdVho3c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795451163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXMlsxyqdad5mAbbeiuLC7iCnHn5yFgQtBLitgMhw+s=;
	b=AS+GtHLPnQQGqIMe5DTAIYgZxr9cxvn2gWKoF1r31uMRMa6jQG+3gG29Rj10E/+WswxueF
	q6YSTalMtUblwZQcx/RefqV3wMDbcIhqU2b9cdyH7WMxjpnY+o9c/krGwI+YGsAy0fMkn9
	kaSc0nrdgvBL3nx+fpazgnS220pFtS8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=i4DZdJMk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-5641f26ce05so1784528b6e.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795451162; x=1796055962; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NXMlsxyqdad5mAbbeiuLC7iCnHn5yFgQtBLitgMhw+s=;
        b=i4DZdJMk9Wecm0kyldfe/DCsiF+ImnqoqXDSQXQN6cul+wvJqfWJ95Xi2WaGPZW6+R
         o/tPUOgLC1hMTBPgP3uoWf8JlR2UcjRdUtDty/jOj2wILRzVMceWwYRK5t1aQeWqOErl
         mq9vmlDkJWpbFxzsGEAJ6xsQbNJj0anFDeTOfoCPoEBwfcbRFZGKBQiJHfPrRyQsXdiy
         UT3uUwJqbGYtFpeYBArtH6o7f9mf0wYAf0o2nHhuKN3apS1TKIj8XlWwiBk303DixBLR
         MpcrM43ULLkNluDo63yr0q2lc7xT1t81oXUyVMsM33auWMuckO40OQWUxV8TTFTgHkEg
         zk0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795451162; x=1796055962;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NXMlsxyqdad5mAbbeiuLC7iCnHn5yFgQtBLitgMhw+s=;
        b=my3w15XMVLxEQWIpOHqaP2f4wxNhRv5huMbC3jq49otZJKaNzZsjYtKp0+UAzqR4EX
         RRSf7kendvO0VGCOG6TFfOi6fzmAsZ3fHmqZHAFk4CIwDvqeM1JjmJvOVUZ4gjJ1yWTv
         3lPVgSqA5EEhqAun1keDtrtDC07XUnUePLbnRJQnoC2gfUgwQbsMyR7wjaKgUT3YR5GD
         UR1CGGcgwc5I3ax+u2IT/qeyZzn6aJ7YYh3L8nY5AMvaXGKz/HZhFg+RSvswvKmmAjTH
         r1SKbN7LUxUcJhxUYe+FiSNXzjLvHZlMuQC9t+KNuKafBSjeFHrdY4gw3dhv0azmTuZZ
         W7CQ==
X-Forwarded-Encrypted: i=1; AL+hErFSyHPl3V9/TGeUXYa+eJDRp5Q0VO2bPVNZTpv4pnPnwq/R8yU94F/OezCXNjHTg1sCVlV6PJZMKQ==@kvack.org
X-Gm-Message-State: APuU4Z9UQX3TR55pVATEmGNsUm/A/FtAX8QohI8SWV5AtzRUqFC2cC7I
	JQg8b+0J1rtiXkPjsPGDNFLLa4s/viN8DMNbswZ0mypWOXr/cEYrhMY1
X-Gm-Gg: AZFdTZe7drBK8BIGYpmqDHIQaXr3/zRI8rFrl3bW4m9YEde5fND1PRrZKMMpj8EHgIF
	6r6ITBlqODlb0oBrEUHDUuUj3vccsJEPYyHMQeVA6mdUOHhgRdZ1SyC0SU7pi/JWfLMBGKx9HxQ
	C8F+Nec+sVyCk8NTkHC/UjnjLuiyPG2TLZXoe5wR6ut72WIS4r9JMFhz8qNtmyMbAhkZ2QFw7MP
	DOpPh74MaINfzNjqvjm5pnHwIbrOAw5lvm0/d3L78U80ttkB2i95xErpVrO8mBFwY8L+nhgChMt
	x7IFsrnrPlzRrVMRVuMjoYwOZs5/c4LPf1uyAaVf4FmfRLbQshUqh3m7zOPANbuO/Cr3RRE3t5O
	DdrSXdfzQQrN1fZ9u3m1t/5Se0Dgcvx6sMTzyKnnsSJMwIweHnRHJ0SoUZBW7LP1y8F2MUp8vmP
	F2xb84lwafE/ws8aYjBkMXfc/kc5g1d6RBPgGwkVbd3tEkJfr2s/pDuHAtrYu5JpUH7AOfT9V9e
	pFskY6M5Qv1+BWEh8nG9DNaprP955SQE9Fxiqfo8TAvx7YWYLJpNhVNVwl8oH630FSULyJiLLkP
	qLUyOBAqZcdRyJHGpOVTQyGD4kJvJ5xZLeONmrkivZ3Jak4fvRUnxO0fyiOqADiHdv0nnS5R7sH
	YTDHcZg==
X-Received: by 2002:a05:6808:1814:b0:4cb:f21c:a79f with SMTP id 5614622812f47-57a0b946d49mr13307390b6e.39.1795451162238;
        Mon, 23 Nov 2026 08:26:02 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:15::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-57a35055486sm8872729b6e.12.2026.11.23.08.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 08:26:01 -0800 (PST)
Date: Mon, 23 Nov 2026 08:26:00 -0800
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: chengming.zhou@linux.dev, yosry@kernel.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: zswap: remove dead length check in zswap_store_page()
Message-ID: <awRoyv7oqW3e3DG3@devbig011.atn3.facebook.com>
Mail-Followup-To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>, 
	chengming.zhou@linux.dev, yosry@kernel.org, hannes@cmpxchg.org, nphamcs@gmail.com, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261123032512.6119-1-raizudeen.kerneldev@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123032512.6119-1-raizudeen.kerneldev@gmail.com>
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 4449340014
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: rbn65gih66ekjcpgr7hx1wxi79htdqiu
X-HE-Tag: 1795451163-393979
X-HE-Meta: U2FsdGVkX192dbZdW3c7AZ0s87C0VtAeYmMngc/Pe3QFCYint9LfbA88cQh5d03SKI0JwaLl7km5XGPJcYgID5DQGiQ6ZtS0qUzmofoSq7H9QPm74IkFR6oJut3UMMRpdW8WrhyPgYiixa2A6ZCR7I0amjW471DvBpmcn33eLZh4rFnkxSu6m30BL4AaPp4G1DjatYiC+Xe8F6sZPS3tRWnDxzy2vDiBwQEqtngO3JI+XSgf1y69gwf3qoYsnAzlMUf1MCoK38LljL7fTaQg/pOA0Y21w+9KpxRwiVgDMQNIrHJ49R5AMcW8ugc2nGZESXhQ7fynUIGOWfM/SQPSHst3hjVPkbRTpVAJwHfVVQ9o06Lyt5EsPZ/czxJMIZceN8Uw3sqrrsi5785Xe3TE04vbN/yh6UZVOUbg9w9/NITBa4j+r3Ar/pusfgS+9MBWWHaHqU6SAIH16GQlCgF2lDohGIHYz2hONBVMQ2Bd6MBCRRyEyyXYmAvz8LZ/Z0JsnAOH9RaAFg7WP/dPiKgJdsB9VL5DoqXdV2gW8RC8IxqfMGLJ0h/O9LPhnDIGT9c3ko59KyJVIa3InWbZQaogkfvJLifq50PFjciBeIelK1BVhfm/CK8rBewgwvtprqEvtNZJOcCu3rdHdjRfgpvoXdkZvLZM7LCbwAwdl3z7sStjTCBlthFNgSRyciOFTzWmKiYyMexYGATCydLIbwoh0tcrRAC7MW+TI/gfsni+CKQ2lzOQOBfdXBXdKQWR6ZmmfhcewXysWs6Zl027WWUCRMujJMsDh+yWGSBtU35J0QCT9DOMF4GaDSLmylckd/O03433EOZ7KbOl1KQc5vBvZHYWRrD4pRiJprdDnAQb4zGH0rfgyRf5aYF4TOmxq3GW3M9yshGmA+MX5PdchDD/roUQ2+k7dMwmYVNS2z4a3MSy1YNRgeWAIIKPaUmSYZTuntHAr/tvTcBvfhTmzjf
 4hIUFXyM
 H8pGjeC6LjfS0RhqbtWF996MigEd3HwXCx8GDqHIqGfD0HVvnyyQ4hRVimcx2yqQyNb2J6E3m0odYdrdu7rAuE82x64RjM9iejWRIAZv4aBx8QC0JnN+yRUgmpjVcMuT+G+nVYpxI7DWQw5PNT9lOgqBG1FF5PqSQegagXPuOVwnL/H6jxAYE8B+IVwNJTlQhyIvJ4hHsBd8UGG4KixlEw5uCWb0egDf+PYok6XL9b5LDO3moaIfIacGjnumFotRGEvzNoyHXHLY0f2XpGW93xCJpQyZ6KZKkG/YgZEJ/g0cqsCsqYGHbCtGvtha0V6Bi+kC59P7qC986r/n30S8yHgNysIIjIe6UYW1iOtpBLaLDaOkvOjI4mPxqTi1PHqVP9Eul3RNAeg3je1pqwWNKLrf7s34J38R7VjFe9OewYQ9kadE8+ScZiyPrXqOU5PhNhOlTCRpKduBa43NdPXmt65UhDOSxQ9zT5ArxeNzj/6jbAI6aZZkkh+3uEC27ofO9tqf6SAjAGFpF0/lsIbOAks3v7xy3D1Q+Nmu5PPgG4oXRvcUzddF622Zf2PM6WCkWBG1uuT7z59p/IPW5mpHp6pVJEInazdfMMErVwEackr7as/TSDrVLIPfZdcp9cokI6c2bpRN9m9c3KTzia6c61dRo2I/rk6oydx6vKZxUYPksIIcBgYcC03vu9QGqaUfsCCVoUCfqZRzC+6PSNDaUiks+D/NJF7PcCAUY8p+fLkgChjDwsg/+aX2eWGxfUv7VFqQ1IqE5sleRrRJ3C+HsDlPP+VqhgISQl/KnAULBxkzFGlau62Ub1UzEJHxeRRmTYpnZwZzvt/VD9J0ipDSZy3fWkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 08:55:12AM +0530, Mohamad Raizudeen wrote:
> zswap_compress() never succeeds with entry->length == 0, so the
> condition is always true. Remove it.

Hi Mohamad, nice catch! Looks right to me:
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> ---
>  mm/zswap.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index ae19e301fced..9590f333d83f 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1509,10 +1509,8 @@ static bool zswap_store_page(struct folio *folio, long index,
>  	entry->swpentry = page_swpentry;
>  	entry->objcg = objcg;
>  	entry->referenced = true;
> -	if (entry->length) {
> -		INIT_LIST_HEAD(&entry->lru);
> -		zswap_lru_add(entry);
> -	}
> +	INIT_LIST_HEAD(&entry->lru);
> +	zswap_lru_add(entry);
>  
>  	return true;
>  
> -- 
> 2.53.0
> 
> 

