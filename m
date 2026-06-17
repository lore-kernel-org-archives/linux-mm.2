Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06035CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 16:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E46046B0005; Wed, 17 Jun 2026 12:12:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF7086B0088; Wed, 17 Jun 2026 12:12:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6336B008C; Wed, 17 Jun 2026 12:12:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A039C6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:12:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A0D91204DE
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:12:51 +0000 (UTC)
X-FDA: 84889898142.05.F8D2F4B
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1A5E540013
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:12:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ey4BzZsm;
	spf=pass (imf07.hostedemail.com: domain of julianbraha@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=julianbraha@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781712769;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0zBBw2mHLX44ib/ur8vL9yTzE1JcardieVVBx4eSzY=;
	b=62LA+FbNDIBZVQ1O1qrWm0fLfGO064+RlfB5FHoCPBeD/O+sm/COFjl7D4/TrKeXV0Ldtb
	gzaVz2p+NcIL4ijOzgAQAjcUZILOYzzTGXzUxNBTFaDcTcev8AUb3UrU3ee6g609N1fR+E
	UIheFFAPbpgz2IOpiVkhVMVAAIguoAU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781712769;
	b=cpz+07YxAmciid/jY/jXNsKPPR7JptM7ijNfuqqNCDcGgxDgjYb4bTrjCB6mXwfbUqupn6
	38oeCAacvgR1u3q2Mgl8u+LNXsJOxZB9m0kokR9sFc3pmcM0njqozqDf4Z39lfYdwgdf+/
	fnjwPbUt9HMP3116QIwqlJlcLaJjUtw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ey4BzZsm;
	spf=pass (imf07.hostedemail.com: domain of julianbraha@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=julianbraha@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490b12270b3so36853135e9.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781712767; x=1782317567; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=X0zBBw2mHLX44ib/ur8vL9yTzE1JcardieVVBx4eSzY=;
        b=Ey4BzZsm0LOlummuG8lvznpQlb1ACaVIV6h+2lw0zCadvP3Vr5vIqKIUxktSIDWWz9
         91U8bzE4a0ikdflGaBbgKTtdxbXfYSyPtCCAsNJGH/VGJ2wmipzo/z+k7guFjYEoKxv5
         /rI/RlnXAg14Igrf6NreHWmocQrirD9i8Ff3+rL853dn2xKveSspkJRGHQ7Whaj3zDU/
         UbIL3he4jmSFrrW/pL86MDUqlo8qnBRViAvXWKkFhi/su2RxUOoER6VdyuvS1+w4b4NS
         835/zyV704LY4HBp8KPljP1c6HvGB/1m41FPcnrl8uie19A+MtbiA1RC3Y8mdR3Thgt2
         My7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781712767; x=1782317567;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X0zBBw2mHLX44ib/ur8vL9yTzE1JcardieVVBx4eSzY=;
        b=sJQXTac/tw/H+QL0JZhj0JJEPiaiv3Gi66y0EvwAwYLnvh1FKsFWhBKdNAHJLclmcs
         /tvOCp17mPHxwcMQOz8WXWtxM44gw6Eg3sQGUaAzCpwWWtWsMPk2LIpG/YDCjhAhHEcP
         S8IzRnB9RZ84dEeOiLs2iEwV1fUTjHFVGID4C56AavVUzUhpEwDATWp7qBBfemS/DryY
         ZA5vd7epxH+W9XDmQpBcgsTXiYY0BSSR0iZa/lOOiHrwPZg5MZEfzvB3gm1XrI7TqNTT
         0SYhn+wY2LtRMTkqrgBmPkhl5SMFDzwDtl7JjQLt+gWpsx0eHiu6S2TYtfCHvmQ/jssp
         RdJw==
X-Forwarded-Encrypted: i=1; AFNElJ+q5tmmzDBvbiZJFVOsiJcn5eJXsqfr4vULQm11YTcJ+KNjLjJ7bmPEQI/IB93Xk8MYNt7gukQFBQ==@kvack.org
X-Gm-Message-State: AOJu0YwvllO5R1SbyyfvzZ6fuGx4YdVWI0p1lZ3lOqOKMJhY3mldTf1D
	5bOPAlsGVerG0qqfgIEoTP8y5r69I69M9JJQdeduKCBZOH7bXVuabXvVn5iTO7cTcjTEUg==
X-Gm-Gg: Acq92OFGssmdgAH3pVFMpdnXDlQCCSmidWPli7/wqFfTySO59nSx/nnint9OUrWszqS
	5UO5BexpmMLF/2g+i++MGWAtDNQa3aysQUlLJ7cZWr6Ui82XBrcDIXxrG2udwy5BJ14u/RmHWux
	SQZ8Ou2M8OGjoQIOYN/bMnnzQxwUU73OAluYOp6gwFXXPZ434hVmHUL4ORAi48JqgXBF+wmEule
	usTFm3gtaD16aJd1Do6A4dRHfDf3OjFMN/bJUzD4E4sEao4EKVNpGiPkB86EuaN1I84yCyluq+U
	zyNmQ9tHoQnQMydXpNP+106X1/ofJd3QnVXppLw2xWeYIXTJk6qdGg4WD/mtudPo64SJOep1Lok
	pcGkAsP1GTCjJbBO/uv9RMMmseNfPVtiBLkAqeitbOygdke9EMOKNofRjKGa7u/VxCy86lwALE2
	hnTAvazhG7jhmFqfl3q+0EvDZYnB8IfudZv1P4ZifOyTdFr+tpqCcyeS2FbfRdr7CRkVJvifb1k
	70ERRwbpkKXzR2qDw==
X-Received: by 2002:a05:600c:6b69:b0:490:a1dc:e542 with SMTP id 5b1f17b1804b1-49234100c1fmr46844735e9.6.1781712767174;
        Wed, 17 Jun 2026 09:12:47 -0700 (PDT)
Received: from [10.128.11.42] (195-23-151-163.net.novis.pt. [195.23.151.163])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2ce361sm52357251f8f.31.2026.06.17.09.12.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 09:12:46 -0700 (PDT)
Message-ID: <39bf837e-d3c3-4b9b-b118-063caadcb700@gmail.com>
Date: Wed, 17 Jun 2026 17:12:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] mm/damon: introduce DAMON_HUGEPAGE for hot region
 hugepage collapsing
To: gutierrez.asier@huawei-partners.com, artem.kuzin@huawei.com,
 stepanov.anatoly@huawei.com, wangkefeng.wang@huawei.com,
 yanquanmin1@huawei.com, zuoze1@huawei.com, damon@lists.linux.dev,
 sj@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260616150316.580819-1-gutierrez.asier@huawei-partners.com>
 <20260616150316.580819-3-gutierrez.asier@huawei-partners.com>
Content-Language: en-US
From: Julian Braha <julianbraha@gmail.com>
In-Reply-To: <20260616150316.580819-3-gutierrez.asier@huawei-partners.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1A5E540013
X-Rspam-User: 
X-Stat-Signature: fqkwaomktd8g6q89ieekt1b8nr4xwjc8
X-Rspamd-Server: rspam08
X-HE-Tag: 1781712768-210664
X-HE-Meta: U2FsdGVkX19442oJwuYeiPMFccMbd9u48FGDCt9Bi50Dt24ZfhuZqzYVTbJkfminQB/bSQLPCbaNo+gkVyfpnV2nBpYX4W2kOs4NBNSVTUPfG2L3CH+giEYTdFWMoLxEBexFTTC9TLMlgiQ3ytLLPIA39Q+UjwAVwHZtiIIeLlEOi7dup5TjMZNuTBhErf94qhRgjib5Y9ulqbwtFwgaoJVOfHxKsFfyo/RJqCBcAJYMoYY2iY3QFJEphG65frjCuAhqUg3yYQRDLmGPHIoQmzm+LEZ8x2+Nwz9lwNsZUOSMhvo/8wp4j09o0Dsssfnk9bo+9AB4lOpWj4Pi65xVC4BRwX+fuzpI1sILs+Kf1UoHGZJVfx+OMbuIsv9IpfBj0whsSWNx1GIvXv4ul651hkLS+WxPwbO8aGikTAk7p/9ms8KzdXe1MPBugUaeKYGtaRzA5M/1bghx9sQJUD7+CYdTyouEk8zaRWJ7XOilCP19cDwVmFilvBD+9RCASC47dmF0eR4zUUxDPIVL2KvcYE5b7QvCDSw9Tz6Lbo2BeS68M1noC1yNtqcmWCExm6E+dYajXk/W3IOsrvH9oiKebl8BpjMV5LFOxLznJswu7B04mLQNfnbcgdyLLBpD6oDFaICjuN1wIsNhoG3fSKQu6CqJ0bJk7fZo7QXzphStY13wS2d0YE9aNaK3RnaoyTzRhVtjeK6LUbfnQS0NIMo8B+w/nwodJqfoXq59M90ik2tuvuk+6hPR0s23UvHJGLaXpITzSwIYzMSL5W49efvJt61qULQ2PX+ctmNwbrUXPPCGFsqhFdiPmnx9IXH0hOAVBa6kc8gGat9HbSzwEwxxa4z73VpyJIxiM9CWqhHRSSfxdyUCAb6wpkNMNgin9GwlyRR3Bu2mwE1MjNceFv61HjtcnM9QO1EktqnViGIpXcdJJKZSD9zPI5PH9Vd4B4PqrLm69InB92Mkk5dgIxK
 5KJjESPn
 zXiaIVwu03rz+oYN+XYZOj2dTFNu9kXW5GuHq5fx9Dv0yl/ldg2b9viq3/zLvRNVFMsYD7k1gR/VjL+JPOb0q1or4Pk+VedBSTerWfKHCLOy3FdXuuKZVeTHijizkttv2rJm9WGMZfMXHYVLIaPfLgvtfYJYxR27x3ISE8NdFJLeLp+3pRTWfQA60ZeRboxUhgUOFC9JrZVJjreRPCmkrg9cO4hliSc0419d4E0J1n2fg0KBKQt4VjHQf3Or518XPQF1/X3AbhjDtFLVj+veILpbU4umHY+7xeM8XgZW+sx12tQl7/wIk8qbtyMq6A0mWhU+udzb489BjOnmet++KVAmnUviuPgNbB347samyTvBE9IKhwB1fNf/GOjvk+5XF2fCHETN+WAF50XSUnsvEoCcr7XHEuH89ulXnCP2DVkXDHRNQdESU9uZnKI9hlz2+56IO2IlY21FbA8jLsksxycClOm41ugn1/snKJtv1PglEUE7NY5iz5k1LslFbtUvxs4AYUx7lrk5wynCkKFgyNsYL5zGlAaGEx4k1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Asier,

On 6/16/26 16:03, gutierrez.asier@huawei-partners.com wrote:

> +config SAMPLE_DAMON_HPAGE
> +	bool "Build DAMON-based collapse of hot regions (SAMPLE_DAMON_HPAGE)"
> +	depends on DAMON && DAMON_VADDR && TRANSPARENT_HUGEPAGE
The dependency on DAMON is unnecessary because you already depend on
DAMON_VADDR.

- Julian Braha

