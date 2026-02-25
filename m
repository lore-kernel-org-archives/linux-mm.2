Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E37D3FD45E0
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 19:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD4076B0088; Wed, 25 Feb 2026 14:22:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81A86B0089; Wed, 25 Feb 2026 14:22:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8DC36B008A; Wed, 25 Feb 2026 14:22:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B27506B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:22:37 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4FACC1C91A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:22:37 +0000 (UTC)
X-FDA: 84483950754.15.1F7F266
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2B4BF18000F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:22:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VkbCfb+2;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772047355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZE3SCr1J71Zf7ijSjOgv70RQ5IlZZe/EDYwe69yiQk=;
	b=JHrxnb3B7avJRAaJj8kTDGpYPKWtLbpikWBLqFhrNHoSjAlKTxXbPTPagEaphERSKhP6UY
	KJGtNxL612o3y1Y2eeJgEI1QY+n1pFiiP3w7KHSuXXK+Oca3N16+0D6N271DZnjjsJX3Kr
	9WVy9sxnXTP/E3IUe9acpnnZXK6PXlg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772047355; a=rsa-sha256;
	cv=none;
	b=cfgMczwmetL+o+Xtd6dyUBbM+4lmDA8OWvSo/MxJ3/3YluQK2WcNITclxYHxUKixx5jT22
	6rVAgpj4l84277Lutlk63zaB+aHRGfCtuH+xTbK+mOfudQzN34/PpTyRHIZNjxU2xx1YE2
	e54xWz00oQDgY4Iqz/14vdy9QZpMLMI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VkbCfb+2;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-896f632d206so14824346d6.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772047354; x=1772652154; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yZE3SCr1J71Zf7ijSjOgv70RQ5IlZZe/EDYwe69yiQk=;
        b=VkbCfb+2dK6CNNR1Bb+uz2Wf15NK8bkuVZUKaU3UjassEB/px8nTqpspcRSaTGV+Dt
         s2bEJx/ZDnwBZaNwa/9yGtGlK0QeEG2U3ruya9vdBP/KHElxuli7Jzp9l+cohWz9lFJV
         jKwtnMhnGDhrVj/OApkX1fNH1CQK8xhSWdDQI894Buiz8xVqIzJIL3CYaGn0TBtHtcpz
         0N882sWVVUPTb9C6BhRrfJP4/CNh4Obchticm442HSRKp00IXDn2ka0Nan+ZJEst8vZn
         3R1xtvMQ70La3ZQEhz1viqd65vTKXQl0m0DzWsoTCqoY94xb91/0RKuMRHrcPrWaVkE+
         teUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772047354; x=1772652154;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yZE3SCr1J71Zf7ijSjOgv70RQ5IlZZe/EDYwe69yiQk=;
        b=FUkkUkZYb8Ue6wHTX2lrFLfQYWeuqWclK2swqrmqsyTH7b1XNC8iGfNzV4bruD5aho
         We+sOzmILsuGBJmDsC4AhONdVY5RJbs4whOpQZ4OBqJbZIzuWu4LJZyoVMKlIUspPvBz
         NSLHavchB7fAFfmw52btUWF99SIqRVysXtbxh7WXflhdWBCuakO2R1jCw8Qwoo4e0Fr2
         NUd+3hnVW809L3E35/bIuZgjPZYuzNqVzABEoMlr5puuFVg5IBiWdq8q0loBYCmE15Jb
         udLGdyJoUx/CHTXZFuE3VuJ+lcp9R7Fo261SiL4/VhiSZ5PP5hcIWgQy/TijUcoLfXGE
         QKFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyekIK/8tIN3zIe6kfz5TUrbAFN+MgK5gbYjmNTRA7208cPRjdYPLxVFaG0RF675AK5unLZyTxrw==@kvack.org
X-Gm-Message-State: AOJu0YxkH3x8gn/Ugbn4HSv2vcXz+DJwrTLGMGToEtXVl3nYepmW8lC4
	arSmYhRfq5QpELCndV+9FU3v/+R/+Vmm4JKZZ8yyiSaDx1BHz7y854mHbvTEpweHp4E=
X-Gm-Gg: ATEYQzw+i4ZVb1IC80lg4H6JuoVsQzAq0Uza58yXOXdh7vI1hztVS4QSmuHDziQMgmg
	FKlLtpyf5XFe4KfRNxQlGugkKMJGN05T6n68RRKiKXf8TOxTx/vBeFTV9OK2aDJHiyCCShJUTMk
	BrFFULpopGS4zPAAnpfJ9eAP+KK29bG5dn89wthJNe7QCDPx+xugC3de6aUj7i25KPqB9hd/Kgh
	2HHrASv0DC40nveTG/5Xzhp5+cVRNheE3SNqLIqHMEKmXmuAfqCyhB59JCZffPKMraqMUpC5/61
	9W+EzDO5xKYNUpFGG2tJoE/WfjwCPa0QSAw8lAbWSTY7Qf7pKoHK5b6oIruEr1zy5bBT6CIKPuc
	LZiLFBIp3jx6WvPNq1V2wcFIzZFDXm+PpOIULtWGCR8oC2l5WINvnsmuET330h3pDxNdbRElfxV
	HNmG/fcWjRaxYXDF8YOkZLog==
X-Received: by 2002:a05:6214:c29:b0:896:af07:a50b with SMTP id 6a1803df08f44-899c6817de8mr2664606d6.25.1772047354016;
        Wed, 25 Feb 2026 11:22:34 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899b3fecb32sm33790086d6.5.2026.02.25.11.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 11:22:33 -0800 (PST)
Date: Wed, 25 Feb 2026 14:22:29 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/3] memcg: Add memcg_stat_mod()
Message-ID: <aZ9L9Qty5Mr6440Y@cmpxchg.org>
References: <20260225162319.315281-1-willy@infradead.org>
 <20260225162319.315281-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225162319.315281-2-willy@infradead.org>
X-Rspamd-Server: rspam09
X-Stat-Signature: u3hwierboi98j5amw7fdkkpcgxapk9nn
X-Rspamd-Queue-Id: 2B4BF18000F
X-Rspam-User: 
X-HE-Tag: 1772047355-732680
X-HE-Meta: U2FsdGVkX19ddjQZAoDfXZQgMCfRI5JvmZhnriKuv6olmuxCzxVgV6eoig7iQ/bACMgABLzrCnxTzdPAG7wvW0Sv9IJpSvjfkBy7SyNvs/xe7wCmQFo/nu4x1Tg9bGcCEMiFB1ejfLaGZLFMRPCjJUNxNz9YXNq+DgiuXxk+fI6Uh354/JYESeKfgvAfnTtV6Ruu/JyTz/WSNeCPSmg98wKblKLH/0LS3Yd1KBFlzcDSdkt/mYfTcww7q7ezGHJVcA1VmDfN5gIxhzfYJYlfyO4AiuJwpJjL6Pa8gQxFL+0sXWMhtw4+CHqUidQ1KxyXl0DT6+PkC5W6S/M+fXbb48gtXnBYEP6fQbgiBggjUF6G1cltFuSYGJwtnvzvP4Y8xIoSLK3zwo+WzrRxTtToM8N903rz2xLoa/bujW/86exq6VCNW4+nSZDYL684Ya8+8A4VkgZOOeq63xMvYzpvufBYvaXmpaMd3CQ2P8arr6XGfM6gruJXP/88kAAuyT0NWoU8tfoW2D/EDjge1BWx35fq9bM75JOwSpEqNWYG3MylOK2ovbmOxWM29sttvcwhVhoHP252fuLrRFneN/432GBdgg3KHhTGS+8bp2P8Twrd8Sv5fWYvDg1Ra3wV5RleQF3cUwjIbIe8/iIXu+xR35Hkaw7fNZJRKg+bY9YpYoa8nvonyYpie/s6iPcsIFvDsn4PyovYF8rL5Ej7PAPJKS5pCguFqwuYPXPGTJMiRjYcTVJleFJhxzjJyP73xDdGc2gIueCs8vPywFGSGzI56pEYTyByOwz6QktnCL/ZbLQ+JWV4NOgXjglZPqBixNzbyTeBWgDB4ybwpeivloSBZbO2IhZCE13r9ZACsHs70D5gTLu9v1AMNP0fmrfpGW4dIgHJD2fVlNiqUHlpqzurkxUI9NQzlEE17Miid34/t29Ym8OCktlbpxMbRxf1KrnFz/zHdOWpRgqlh2YlZmX
 CrQ0EMp8
 szxof6keKZ/I30Xhj36hEs/GBwsftxK6pDzj/PaeJKRGGoRQae5mObZNjEVRBuHLiJp60WzLkqsPm12lUpbCI0SUmFPtiEsMAUGhG4sVEWSpZC+LutrL8K13MbLyjkT6+1GQ4c7YGHm3rLrHrfkLLq1HMVupHFmx9a4oZi1dVbuSpzT3/CtWshPo53gdU5UCqdngoCV1nGZfDUEfYS+CAbrxCKUkRWoZwuLLuVde56TKGRr28RwF7oJECr9vsjkaK5q8EnQS1AS8bJonqjIm7irt1PKsOwv4Es4hnLjupIIg9uExGG8DVmXm91AwiW3IS+C4UpqXkpbD68OSX6Q9iEdsY9mhM9KlYpyB30+tHH2uiF5B3+5n4WEX9a6D7VKBD4boh3tLisfqwajqgxK+cfFK56+O/cawiBKw2tuxm2l3gL3dIyVHrch5R0P+X5PRUwZ6yNj9XxHOWKesrimDykix3nUN2P0xbnSTffs7pi8QrCXaOmIqc/BADH08GkI5p78Zp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 04:22:15PM +0000, Matthew Wilcox (Oracle) wrote:
> This function lets the caller find the memcg somewhere other than
> page->memcg_data.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

> @@ -787,24 +787,27 @@ void mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
>  		mod_memcg_lruvec_state(lruvec, idx, val);
>  }
>  
> +void memcg_stat_mod(struct mem_cgroup *memcg, pg_data_t *pgdat,
> +		enum node_stat_item idx, long val)
> +{
> +	/* Untracked pages have no memcg, no lruvec. Update only the node */
> +	if (!memcg) {
> +		mod_node_page_state(pgdat, idx, val);
> +	} else {
> +		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
> +		mod_lruvec_state(lruvec, idx, val);
> +	}
> +}

The refactor (and the one in the next patch) looks good to me.

But we already have a mod_memcg_state(), which genuinely just updates
the memcg counters, and memcg_stat_mod() makes it a bit non-obvious
that this is a "core" stat accounting function (that happens to do
memcg when compiled in).

Can we go with this instead?

	void mod_node_memcg_state(pg_data_t *, struct mem_cgroup *, ...)

