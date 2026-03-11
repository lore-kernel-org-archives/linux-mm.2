Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8156FD065A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1524F6B0098; Wed, 11 Mar 2026 04:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10A106B0099; Wed, 11 Mar 2026 04:28:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00C6E6B009B; Wed, 11 Mar 2026 04:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB7476B0098
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:28:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A7B51A05D1
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:28:01 +0000 (UTC)
X-FDA: 84533104362.16.8BBBB84
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6C1591C000A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:27:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YCimT57N;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773217679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wb54AwpsvRCk6MTGz8qZOYDRcryKsG+hshWt3zYfQ00=;
	b=7Zjzcp7u1xxd994ONo1qGW5fRQGP5/D/pK+y9cMCeqXEOqbE2Uk+PgNZn4h8/TsTl2sVsG
	yDrkHEGi+jGVrHxptD6erXkJlNgDI0igX7KLPMhwa/TUgG6jHacwHp36nj70/VF3QkbCO2
	pDw6fWgq9M3R4eHySxF743OeIESw2/4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YCimT57N;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773217679; a=rsa-sha256;
	cv=none;
	b=RZ1ogLTNO9eeO/QjtrryZEfe4rNyEfIwXKhmwGdRCcahFjCqOwKStnjAdhcJhMoL09bOvF
	i38JGCy3Jo1SmbXXnSWE7zqCnrtuGituvQ6JBE3ZNSkw0v02CGJ5GlC65QSfKy8T5l50Va
	aHDIFB8WiRBiM9bovmI0fywzpP2lPBc=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-35691a231a7so8666207a91.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773217678; x=1773822478; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wb54AwpsvRCk6MTGz8qZOYDRcryKsG+hshWt3zYfQ00=;
        b=YCimT57NHwVNEpUZrQcHK2Ix6pOknq4BB/oFqJc88t6KOJaobadP3uC56iciFFnrSU
         yAiSIdsa2NzcAoQIZct/u2ClNVsH52IqLWKYeq5Dxa4U05tPaQpSzI/nwatq1rJG5Q3y
         sXA0YhOYz0/zYy+1N5lAho+S0Ts79xF3CuYRE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773217678; x=1773822478;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wb54AwpsvRCk6MTGz8qZOYDRcryKsG+hshWt3zYfQ00=;
        b=nxIWaJNROVcsk8uJh6E57tXWR8kfzSQq1uVf8u/fxnDpJAWSXCmd/GOTOXJgqDD6DF
         Fjlsdkq5Yi3CGj7a9MB7BLAyAXvkfzfORvMzMimx3FBImKysXohRfQdnNZQ6Vgo6BCeC
         jjVErwM07w7KMsaM/AmJ9KVZxLZ/S4GWQZjJ5ctR3NS5tqrxpTzqkDPIsH6GWxoWtn7Y
         NZGF2oNgGWa43RP+IG+dwy0PFV1ap5F6JmW/lC1vqYduNqVJaxsFGQGzxsvrG1YSDe1c
         XsCUca2XXOehqDU3QjnGgnVGIkfrPlS2r9bDlJvYwUQsXUQvzIr4T8IcKFu5ViS/AUH2
         3Unw==
X-Forwarded-Encrypted: i=1; AJvYcCVnfvbYLLuphikPPjWnmZ7FDXEJha8bOvD69Bcu4bzTNWTBcBLD9E2L+UqfQGin6XTGy5kEPjBzNw==@kvack.org
X-Gm-Message-State: AOJu0YzidxmurEIrSPBJ9Xt5sAkl1HOXujkoZ+yp+Yf05Z1n7XQzq7BF
	sVTHa77qBcrfIHde/3JuWIcAX1B0kOhg5RHUFLzIAbGGRnYwW+tGhdkUkZi8z2QWHA==
X-Gm-Gg: ATEYQzxx8q3gSNJ8qneiKbPsHgwhFpXkN2VlLvGw6VHVfdu/6UfAuHRtQsraAsBEdB0
	xMXoqvztZ9ZV/JWQrZ7Z8ZHQObezq/DjM+oPh1exja/TwyIYB3ov0DSwbZENI6C7ytsC+QtaElt
	/fshnFL5vJgWWxCtJ0Yddy1iubpWBdYwIclpXRjHT77mF9zQkZTDPpprLjT4GX8Uf1M2NTfmnuc
	DHdgHX12tNGT9ItFjblBuAzkNgLmUnjeIdbaayi41oCO1+LT0okdWH+W4g2Cd6t6fR1KOOees6S
	yWqE0fBjleqvU9dEUc4PRu/TDn9lqUAB1rix1gVU5dgVfaKJXyCmMR5+0IaEkrB1WxGUfUWtFtG
	bvQLDw8iKgeQ4A5Od7MmtN/1CL4fk7UdzbFfzyfSWSSVWwqhvhsNwlU+nduJDZtOI9VjLAYIDi8
	+GGzGW8yyHSGTGI/VlordzsS2yU8gZyVf2y7zqVf6b024een3ag3Qtoe0n5JsirpU=
X-Received: by 2002:a17:90b:4ec8:b0:356:23be:7ecb with SMTP id 98e67ed59e1d1-35a012cce45mr1850888a91.12.1773217678148;
        Wed, 11 Mar 2026 01:27:58 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:93a4:8281:fe98:426a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35a02e19708sm1947257a91.3.2026.03.11.01.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 01:27:57 -0700 (PDT)
Date: Wed, 11 Mar 2026 17:27:54 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, gao xu <gaoxu2@honor.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH] zram: do not permit params change after init
Message-ID: <abEnBEPQDpF6Sgpv@google.com>
References: <20260310060407.1133800-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310060407.1133800-1-senozhatsky@chromium.org>
X-Rspamd-Queue-Id: 6C1591C000A
X-Stat-Signature: wq1gfwusicygwhpqsgnxfhmgo9fgrpsi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773217679-846593
X-HE-Meta: U2FsdGVkX1+b2natiIfn1aCSfI9zo5O7WAtFWn9kV55Jf/aueHpJ0py31Fle4rvuSbpwBXmwqfYYqDPiHOGx44v68Ay13Vhhfqju4ltw6hzHeaYKVzM3vaBQDDQ9PJX3NVyUq//iFXSM2GsY4Kdr05M+G094l6jS9lwdQepdDdoL2b0AiQ2dmX5DIaX9UAtrkQRci4ZNwO56RTQ/xMlJoL+Sjj6q6Mjp1DH86m0za9+IBRYvE+vm0dTjyPVIds6ylFvCuxEJ2JFAio1M8tPiPJiIg5vhbO0IwlvK9VKRCElkzLKVmkLMDzkJFi90yP4Xwab9V3oh5lBfmAMTdtkV4KzQyF24Gr5CUHKY3BQq84mEs9yOwHF+uiSGUvkPFOv+lwxXeBXXF9kW9J1KWfO6LLfh6buN2gjkS2mlV4ikBJ32D7ePwETK94GrvpCzQIzoBsOdyzG/wVeV7FxVfK85QfRktS/7nsKuhmYqZwHZ2bezeXcscMJw+7QE7emboWoPIhjEuwFzwB8JY5DhE4q2RPnZhesPYeMS3ZfQaRKSOuWQBHjPPbstavBpL3vt5ZQlsXVU2f0lYZv9S4pgT1I9/cLv4loi1CIFiHSTPxUuNP4Vl94KQrXvw3ltwxPeyq5WlO39lzRlHyc3B8Stk9n/GDoSMRc2g2z+UlIOm9GrNQtuNxs3zN2jKxmTPTd5hdXLfJFZkRB+hMhWkfmRdJzhJ72Dyo4FOvf/1b7WIWwBKKH3TwD+lPX3NQAEv0uAt9YUg3Zriwxt1/8UUVSXpaj1ABr/Oh5xwHVGjInCW5yqGHo4GYgHkEnygZCH3jy3CYSi1Jc3oOBWx2ZPpoxROU+urrgpJgmedDEZYCv4edIDX50sZ7V4rX8mf0RGSqenPuuFObBgWK8N8G8+0xY6t+dI/G0DXbh6XXsXuxHzT4lSadcFxC9PtbZufcCAPaMi0kmsz84kNS6B7BuFjRsR7Li
 zRgDJPZe
 MmtxjvQvJTbpoaubYf6qgVP/m0SlBcXSsQSzkrfaK9af6P6QYnFIRp8XCEuvsyXAIYERBjV8pL5sTJmxkd/W+hePWsCHfUomaQ4+i0fSOrMQhR9pHBuX+JeI2Kmv0XJRNMuoOs+ROQJXx7jB2ojwLGpcTm7cI5j4UviBmFDxCsJem1ScA0rbWhlG6+rFFY+4+gNEhXcnYQ3CjiRk08lpRkl+UaL857uZRqn3+JPdJdcKhj8ylrfqzZS7m0GPojf8wQgPWCQpVmjTWRX+3Pmhtf/2TAImtISvoJm+hfWh1WugnNwe88TA805K64GnwYlyWKg9+Vb/NSRzlYorFKUUabwwmlon4YE/KTtfg6k10JURYDVbWXWd2wt0+EIO8AMv0Jo/QGmWvqkjsgCCsHv+yEaTORw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/03/10 15:01), Sergey Senozhatsky wrote:
> First, algorithm_params_store(), like any sysfs handler,
> should grab device init lock.
> 
> Second, like any write() sysfs handler, it should grab
> device init lock in exclusive mode.
> 
> Third, it should not permit change of algos' parameters
> after device init, as this doesn't make sense - we cannot
> compress with one C/D dict and then just change C/D dict
> to a different one, for example.
> 
> Fixes: 4eac932103a5d ("zram: introduce algorithm_params device attribute")
> Cc: gao xu <gaoxu2@honor.com>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Andrew, I will include this patch into v2 of the zram fixups,
can you please drop it for now?

We need to protect algo lookup path as well, which accesses
->comp_algs.  I'll fix that in v2.

