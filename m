Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC1EACD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 14:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22ABF6B0088; Tue, 19 May 2026 10:13:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2022A6B0096; Tue, 19 May 2026 10:13:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13F176B0098; Tue, 19 May 2026 10:13:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 04F2C6B0088
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:13:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2814C1C66
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:13:09 +0000 (UTC)
X-FDA: 84784361298.12.47AAE38
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id D94F5C0002
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:13:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GtTFVOQu;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779199988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0sGtfsMt+NWWfWgP1GuryhPZenTz+43P15Viqh/cz5I=;
	b=CSq/qE1rQrgvIGQh1sGGtg7KKPK+IdCM5/0AyVRF8rtR6GYab2V9RUb9lq0ES1p6zPiCiH
	A9Q32GRpvoU3EtrwC9STM2FjdEaF06IlBiEJYYvdyN/ujRpMqdfN0WureWVKcn1YXPw64y
	jpwGe3knPMv8E9GoEkiNrDBYrJ2BcRI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779199988; a=rsa-sha256;
	cv=none;
	b=4rAOQaTsnNEwAEclzCVJK0+MBbzNQ5taUJlkUNOqqGB4QA+fRQgTevBTzGT/qMhum3BQvB
	oku6wbetgFxh4vvF7I7Jv9ZJLmO1RyJdTyNZubsCUUExBU3+dITtOeaeaD4vIvKqRh4ah+
	Cd4FS6oRGh1oymGDE/VfCDZFx85VE/4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GtTFVOQu;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8be236ce888so38049506d6.3
        for <linux-mm@kvack.org>; Tue, 19 May 2026 07:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779199987; x=1779804787; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0sGtfsMt+NWWfWgP1GuryhPZenTz+43P15Viqh/cz5I=;
        b=GtTFVOQuETw32npsaVjQt6gVFrWAiw/GnYEkq40sL+qFoD/vhWv7iDRXdAI0+hnTS2
         gfZDVlQzWyVAT3tproWC3dnTfxXTq1qisCZmRhDaAsH9P5xTSRBCJ66tC52s8WBYWdsx
         n5ipql1wSPRbne0M6O4xxK3bGOTObHZA50tpJ6rvebtfwb+TqP8S/kvKzZPCicMYGBvx
         EmQKHYyFeLIehkqq2qXF9xjf9c8cSEiYPETS94dmphQT5b+RCK5s426A0ZB/JSJAqObn
         94DP2BN81ftKC6OVEx1pZZyoh4QHR7YNsXhj50nO7xYvgbHIrn6aPOJP1EVc9ic54clH
         9oMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779199987; x=1779804787;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0sGtfsMt+NWWfWgP1GuryhPZenTz+43P15Viqh/cz5I=;
        b=o2RV0LOCC1wsA12NVggp5EwGwtUXOhXtuprQONo4VzkVH4TURVbE24LVMaLRoeKpgE
         o3lsFAjos8PH6bdMKz1LWKU4MsmDn9DZbgyq8PMyCpwwQbdstWqjAcWn5oWRK6Iu2vk3
         bT9BrMUzw68Gopp8dT/TnsomJgrTrUQON210CihgCbVRkEnEfRH35lX+C9Hp1DjMdRv9
         lmOJ/1hPfTp1Pz0dutWr3y3dskfm4nhrNYzoac1E5i2gWgN/0+RmTAO/Ifb4AABMe2ZA
         lzEPWUBNtXWew4XbBIhstK/suQ0fruHbDXECoAg8nrfoYqXkgiAMYQYHZ9X1mf5BvSB9
         U6wg==
X-Forwarded-Encrypted: i=1; AFNElJ8pp3cTZonGNllWmXF+xrHs5qb8feTQE3vb6IP8A0ReC38wDrqcMZiD9X+I8p8fYIbUtucdt6VuZA==@kvack.org
X-Gm-Message-State: AOJu0YwgVudqP0z1boK8Qipn1LG1Qnm2v/63fp835ByGLSj6HlXQHepR
	Fpl6KWc0cdGJnp0mFOiWPpc69ycsI+1BfYJ7ofunIKce88cUqikdm6/mX9gz1P+nX9g=
X-Gm-Gg: Acq92OGr1TuvsYto+kiyUS4IJ5WHlTCUIYeNiZP/c4p2T66uZyFwvQ8XxJMyypfBTRT
	BoS06levgbtZjoUrRpCt6ZcV14819XEK1JxBFj0taKK3iTLLSfLZBOz5fbTHUUq3/CaBVlJrMZe
	4n4oQh7Jhf6Gux4oQMjor7A/GpX09PfUUnk4Mo8eXEuU9kEc7bN7osn9hFa8DtrKn+5rM7Pq1Z9
	xR81PWM+VUkFBrOoJf5wDp7VEvLwhvW0hEBVODML4kUW+++e9QpF/Kitv1OyHdXP9Dnudv2Gr72
	58g9pLB7UoY3JSZfY/fUS5yzmjUh0k7Fj9HwqENgvMGZuCO2q7a0PGDp68BQNkv6ysOUCefLfYa
	FFQWusJ1psU/lT2iOz6iWkdEoos+PEz9k+w7Vzhpd2OuPfAA1nX2Bk/0Ey3UNccPJX4wDoy50HP
	ROFFxF899c6sUMeOtPZ/TcK1r6Jxpx4ySNJGNYhRJqfdLTbHOwaCA=
X-Received: by 2002:a05:6214:590a:b0:8ae:5fcc:8069 with SMTP id 6a1803df08f44-8ca0f62bc61mr376033696d6.22.1779199986811;
        Tue, 19 May 2026 07:13:06 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ca3608c424sm92013666d6.3.2026.05.19.07.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 07:13:06 -0700 (PDT)
Date: Tue, 19 May 2026 14:13:05 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] kho: fix order calculation for kho_unpreserve_pages()
Message-ID: <agxv3w--GPrc85De@plex>
References: <20260519133332.2498092-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519133332.2498092-1-pratyush@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D94F5C0002
X-Stat-Signature: oj397q56remzbe1sc8tfopmjpyjmcarn
X-Rspam-User: 
X-HE-Tag: 1779199987-893438
X-HE-Meta: U2FsdGVkX18Y3CMoeU6fStAzfomk5FOtw0inPXSUoMKlShZZd8sNgHzttjObq7MD5o9HG7So6Mk7sy2NSwI4MQmp+94KQbKCCHdYy16saWixTAUbKUMv7sUcM4jqSj/khjGDFnywQ52pSxj7DlM7+K0ADnnehUX7K+U0BvIY/D9EZ6wx1EgB9+NbXDhZQq84XVRlrHZjvf6mmFQOHr9svDk70/wDvPwdZLGb9IVaQqOjzhMmmK1jMCnWrysnGvctZLxiLxhIxem/0uif7zcPnKCcil5wbWneyOl5vk1kTLpT2+dKLy6zJmXkBUDY9K2+XOOrnl78jSRWz/SerW5LUTmOFZUK4/3/OxMdRsDyOC36q1qJnFMRse74OqiwIRzXsRQDf4Ftb6wJIv0l36gijeJLc+LvM+KnFC6wcX3vkdmxY6v5JobIWt9wyCMhR5Jywv71UwFM823edCNu7PPYoYWWIT7a7VLazaieNvxJCYI4azXzhDUqSn+oW0AxA7dE8arjupZk/Cj3uof6UU4JiIAtd6n5GrFgUQLvGfnE0U4QLoKfuXAJm3Bap3Q3jpQGlmClihryLnIXQ4apZ2QbOhCT+e22J6J/T2n4mA4dVYEJ8IxJTki1jNkCpSVt3X8MeHLj9PFJVXW2EPAQIEnY4oLRGDrDFN/dL7YTqlgw7qL/+2zg0MR2F63JJCEztM8nD9HfHM9kP/qEif5tGIPTPgtRGmtyw8WoZBOLL0wbAJ6KmkPir5zzR1kDUwq9ZZOUMkODxQhBm911aS9ciGuYvCo22aB2HnWLxseWVbzw4JOSUCkCyx0x69QafPn8+AgSuOGIkShS9UM5+54P9j+GfmPQcRu4QV/4asM1VwDLxwoB4MszFxZZkSlBg/zTCVvg1nVmaChgQg4vPHRRpAbEVqB+jao1m4wwrhlUobMCI6DCgok+4bk7WSS9s2aDpQzAlIBIzDsLMNqIg0vN4WC
 V/tQu8TQ
 MyxeY0rJ5zSv27vVsSIXct9TCZM0oRRNrXsb0sil5n1RXjobUykDsjIyuAZpvOELu1kndKdePm1TDS/HyLKAwFrYsvPaUqehu8+wudMxkgeF1cPkhj8D69Ja2UxW0AO40WEsdHrNjawO3+FcXNjIrNatLg7Bs85o4UmB9q5JWPALabPgAqnBAae2ZCcRp8pwu5EUGCMmJnhibdL8y8DiAmCwng0w/7OG11xPSe9CMRN/DqfqoFr4RmDWl2yvnO50tZJblD2gWElfs4xM9MTSLsbeAAZH1BAVxC+81K/fE0GIMJfMQpwiEnnGiv3QOKtORKGtYT54cROOcPL3iLndSHVjMid2MVFhrINnm0p18qsQ7tfhnEzkkgu4MAOYevCutrXlsK0kX7zZtN4J1Po4Nhf4cWrgWau84lONB6YU6G7pQJhDDljbVtQVSeKyZPlUACJcMjbvXaD14vo/6GnsCEXGxy9Y2NYYphn9e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-19 15:33, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Commit 91e74fa8b1bc ("kho: make sure preservations do not span multiple
> NUMA nodes") made sure preservations from kho_preserve_pages() do not
> span multiple NUMA nodes. If they do, the order is reduced and tried
> again.
> 
> The same logic was not implemented for kho_unpreserve_pages(). This can
> result in unpreserve calculating a different order than preserve, and
> thus not actually unpreserving the pages.
> 
> Fix this by moving the order calculation logic to
> __kho_preserve_pages_order() and use it from both preserve and
> unpreserve paths.
> 
> Move __kho_unpreserve() down to avoid having a forward declaration. Its
> users are further down in the file anyway. Also, it results in grouping
> for all the page-level preservation and unpreservation functions. This
> unfortunately makes the diff hard to read, but the main change in
> __kho_unpreserve() is to call __kho_preserve_pages_order() instead of
> open-coding the order calculation.
> 
> Fixes: 91e74fa8b1bc ("kho: make sure preservations do not span multiple NUMA nodes")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

Pasha

