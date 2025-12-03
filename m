Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DAF9D1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 08:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A812B6B0030; Wed,  3 Dec 2025 03:21:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59166B0031; Wed,  3 Dec 2025 03:21:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996C86B0032; Wed,  3 Dec 2025 03:21:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B7676B0030
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:21:13 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 58ADC132FFB
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:21:13 +0000 (UTC)
X-FDA: 84177464826.04.306D4E8
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id 38EC520007
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:21:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=QYH2FpOZ;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764750071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w1dLNcTc0WsXx7l6OsEeGvLH7CXI+zAatkWMkXFDSV8=;
	b=yy6edyeUg2F57zCH98eovCID/NyhqL+rOZTH117rAkIEPnfnlutRJtAqVgNCIzDbQYlTtM
	/pOxazx8GQjicZ9mj/D4V/RLWA/R/NVQyGliYr3imzlLNgBjwBWdo6gdTZ5aaI2XTdDT4Y
	folTFFxtDc58hAASSPeFAAM6jzzufco=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=QYH2FpOZ;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764750071; a=rsa-sha256;
	cv=none;
	b=u1V8SjGvTTCY1nTG/rXUi8JcS7+cjHICx2hQuQeF5K77NPQLlde2kb6i5fgmmh4iNAax+R
	kgT8azHz3WYpJSthE5DjrN+wB/n/fxwX5GD0cDjJGJj/9DC1YXmmpI9BIaMNDO63IoZJyW
	QXjXVFis6mSVQypheJSw6SlAjAGuCJA=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64175dfc338so11730884a12.0
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 00:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764750069; x=1765354869; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w1dLNcTc0WsXx7l6OsEeGvLH7CXI+zAatkWMkXFDSV8=;
        b=QYH2FpOZ7mlGPhOXO8uahe1rJ39dQqgjFTLcTNifU5+Vbu9+OAn2Btiimu1ki+tpb1
         e4DiQVWzGb0wGUvEpuadbWlbQ42hrl8CYCVyEDiqgrsaz+VkVyCsBAfanqFW2YoARZpe
         SgAlZF8pq9Eoxeszs0oaTq1kWXvkpG+gXG+WnKSGhmUFv4fOqNevgWPNuKgx5qRAed+R
         ifU6N9NNCyMoPyqeiRZ5FwKmTtYw1d8faVBiNJNXy+E7/+/YoHZu8tL59Fo9MptT1QED
         1Q4ZbJ37X4l4YliCw1uvgrqpG00eOu/ok/nE8rryKVGmH3pqhwHDNGO8SMilgxfnPHr9
         kRfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764750069; x=1765354869;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w1dLNcTc0WsXx7l6OsEeGvLH7CXI+zAatkWMkXFDSV8=;
        b=luYk1MaR0jK1zoiCO1Z0QHUx2iJsHsPlN9o6ssiAjm2f36aj50KjTKnqEzhXnSwFz7
         U0WbRQtsgoG8UEZ6X9x5PTM4/6ry1kvI2THcO2Gl/fbpbNSyzEISRPtqTFZ7okA0aClk
         ib9RGwv7nT26xeILWP2dmxrgv8vXL76bIdSm4r2ZvWocFjqQisnnRha3xFFadmWLNKWh
         gc6TdTzYx4EXRQeXlvwQhEOpQ6vT+ifKpusRqBX7L7OT5O+0rLN8dECo9ONu974ccXI4
         vrXbLGgxD5Wf0FhZ7LyZdY+2H/ueBE6+KD//YX9/9uCXPo2r3VcK6W5G7+0/3iwj0g4R
         Ekjw==
X-Forwarded-Encrypted: i=1; AJvYcCXhRWyJSBbySJvwDSs6zQ0JU/LWH4kA6heJAZOsBFgK1+2IXrnExUBs4zK47KJV2A0C2bkWpe+CYg==@kvack.org
X-Gm-Message-State: AOJu0YzepNTtolEwjw5rfjqStix7EKpGT5HRoV81jYOvUkFM9EbtrIcD
	ekzk6Wd2mlbSvXHEfxY7V5j9G03DdBG4STPuzQOlojomCLznsCsDEg0mhPIx62R5eU4=
X-Gm-Gg: ASbGncskfdmOF+dcQNi4sVHE2AXb76VMYzNh9csKhFH859ifkfd+BR4xkwUw/MSO2jZ
	5DzWF5C66xBcTAL2L7izN5URHU0momOa+8o2izPkoy306QKWipjBGAW1bNI+diMSubKvSp8+qGg
	T/jL5Bq7fwnJqmlsl467zm+Lx5LzeyqrsO1t1Bz9HkbJkCeTS8hpcurHFPyQQYigR/oVA+uJz6Z
	wsh5gT7NXf+f89ZeJYsQf/wVU+7bXoPyHXtAQa5DFpVFUdoyQkVaJNO6BGWAKzX6eG50K4maTCp
	8chgLtJkCBAPsTUoj+XhN8Ua8vUMPRZaRbsVzgwje7KppUC9j2orLBdcxizQkeYLRC71o3kQ+UL
	Nr06ufM589TA/cjWgUzEnRuQYFYCDuyb9nwTwh267oGCP9yssK7vN0rQmPCoBIEEQezeizAC65A
	544/+25nCpqA+hiCWDeTAktZ6M
X-Google-Smtp-Source: AGHT+IGL3Xuzk+IvWUMZdZA8ZVMxU5aMmnQFc2PSzerP9aVtIfX3EYJ1y4dwSSvhYTBRlzUbv5/axA==
X-Received: by 2002:a05:6402:26c7:b0:640:bce5:77a9 with SMTP id 4fb4d7f45d1cf-6479c4c1998mr1077640a12.32.1764750069559;
        Wed, 03 Dec 2025 00:21:09 -0800 (PST)
Received: from localhost (109-81-89-155.rct.o2.cz. [109.81.89.155])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64751061e14sm19789035a12.31.2025.12.03.00.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 00:21:09 -0800 (PST)
Date: Wed, 3 Dec 2025 09:21:08 +0100
From: Michal Hocko <mhocko@suse.com>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction reads
 lock-free
Message-ID: <aS_y9AuJQFydLEXo@tiehlicka>
References: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
X-Rspamd-Queue-Id: 38EC520007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 9p1pw45tbw8iy8eqwrixkp6usc6u6afm
X-HE-Tag: 1764750070-548917
X-HE-Meta: U2FsdGVkX18hDmeOrunnJBCmlQuv7889vUPyhXI/q95Aj9mVB2ExgY38KWjDulRxMGimhBQlSG11u3jAyYgx952QRYwqUpGMHtNlRMUlyRGD7Fakb5pSoi/5+tAWuJqeo2Ws0cZdhH+/2ELcuLcUfVDmpa+DqQX3My/FUuoaP3uLTD69mhPLAKpcDMtyW3G4tW8N7ZTVZ6acEtTk773n18t8JnU0Ku1uouRSHr1CC1rgojAUVFr1QiyM6RCxCHlgiETlgO8Q8j3gdECqnSTkfwdR4xmMR99SJ5i08+kAmtELzJ2wlXeXQFkKXD7LaEJPFpxijQPexs59rFARcjeqojZai5Ixnas2dN30RSe9NFxuhAXDXYXMC0U1N86YsuP8gnD7fE4Vf74cpq1VPBPXULzrcJlLTd6xE9KNiZcV7fd2l+YrsowtBfkGYeWYNerOLmnXxn0DryU+K3m/yV7XKo5qYW3ojE5an5q0VhjElxMd65j1erfxfpDR9yJBsjstT5cL6Rp9YvLKqGkgMquSvDY/S8Q9nJLD/pbeOkYyiWVxyHGhWWGNfNsYRXrw3bwt76RN2qdyxllaTzEdPmkIPvIXsOtxMhx/qVUoEkk+bzSYpe4bPLetpWkYTVQidPvElsZ52m6Ruu1NDy4gV55RTmQKVdRLghixn8BOhN7JUazPJTTIZPIijioygBbqKsP7tIKxrQKHoKiLHZwnbLKIL9jQs7kJRYUtI053e4EcZ6ZRJLHEch20J2/Kt0fVpMeLO661hNw455ZNH++nTKVhmU/cfpAKXF/MTZaO9xY3dMAtP+0jEKkDuuBfW5JFyv+6yf1KakLOc9zFywsv+RPNLumGxH82DK9qQkyfwh7jtK5IKaX6IkEQLMYLM5QWPZarArFjv5XBp6Qd7cgrijFjEEnk+x3aYbAyv0vPbr70LRCxb8XjVgO/+mpidC3L0fFvcGUCeT5/b6ghkW81drt
 nv1fv4ke
 fbfWfv8wMdPDoouH68ddAzDeobZqCA3kPcnJq2Isw86zQZvTzjBz4gpPKGuczJE++VxNDb7Dwj7zxGGmq6sJnASsZ8OGCpH9uDJRCYHGd0Ii/cCTxQvppZtBN12uhDv6EPuta6nKQFq4c5FaeUJs5YaXAG2RW3vo/tW6jGBbE5eyhhhv6ABVG0vs0iXODOvlHP8Imq/w7HPNBmh2jtuDcNVXPBR5/Ab3nezhXU6Zqov4SQu/LdT0qyXlNQ8nWkQhM/JUaiSkx5M4qAWJgYBxNIwesLEri1uMj8hzlJAgE2DdjOHp53+s7YLhPy4DsDc2KBNwEzwjYz99NAgdqL/cwIeTgxEjp8m3tVZedHLzKC2HHi/NwRphC08KfyoqdHk1joP37HYGYXGsVO2tj5/eawl0CEj7SoyJMUaSttf8XTh5lRLFCax/pPrNEs5upRSVqSWHf0CrWUQHS+1CHPPQfzQfrUPmeS+p512G+6Wc/6UYGalA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 01-12-25 11:30:09, Aboorva Devarajan wrote:
> When page isolation loops indefinitely during memory offline, reading
> /proc/sys/vm/percpu_pagelist_high_fraction blocks on pcp_batch_high_lock,
> causing hung task warnings.
> 
> Make procfs reads lock-free since percpu_pagelist_high_fraction is a simple
> integer with naturally atomic reads, writers still serialize via the mutex.
> 
> This prevents hung task warnings when reading the procfs file during
> long-running memory offline operations.
> 
> Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>

Looks OK. I would just add a short comment explaining that in the code.
See below.

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/page_alloc.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ed82ee55e66a..7c8d773ed4af 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6611,11 +6611,14 @@ static int percpu_pagelist_high_fraction_sysctl_handler(const struct ctl_table *
>  	int old_percpu_pagelist_high_fraction;
>  	int ret;
>  
	/*
	 * Avoid using pcp_batch_high_lock for reads as the value is
	 * read atomicaly and race with offlining is harmless.
	 */
> +	if (!write)
> +		return proc_dointvec_minmax(table, write, buffer, length, ppos);
> +
>  	mutex_lock(&pcp_batch_high_lock);
>  	old_percpu_pagelist_high_fraction = percpu_pagelist_high_fraction;
>  
>  	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
> -	if (!write || ret < 0)
> +	if (ret < 0)
>  		goto out;
>  
>  	/* Sanity checking to avoid pcp imbalance */
> -- 
> 2.50.1

-- 
Michal Hocko
SUSE Labs

