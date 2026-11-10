Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0073D606A331
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=ganFkmH6
Received: by kanga.kvack.org (Postfix)
	id 1FA376B05B3; Tue, 10 Nov 2026 07:45:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 184926B05B6; Tue, 10 Nov 2026 07:45:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04CA16B05B7; Tue, 10 Nov 2026 07:45:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEDC06B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:45:49 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F9DD1A0764
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:45:49 +0000 (UTC)
X-FDA: 85419181218.08.BA66631
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6905A40009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:45:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ganFkmH6;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794314747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/n0bim+DZunsCFW3lXGEDWBVlO3l7mvDuQoSVxWJW/Q=;
	b=bb9/C1sWIcuW0y6f5qwwAj8YC0ABlVjP+9BsPHbJBTWKJKB/K42E/LtFavkt11TUWIk0qS
	9qsT+3YpCWfrLmokOVrKwrSi1JLtgeDp9bv9Ojm9fQzVEzuPuPqOKsfLM4KRe/NGh2Cvje
	LYWvyduJ9WZXyzLShpYHsto0imHzksg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794314747;
	b=wUSYXqyZvVfIGTJlGmpQWHEGj72ByzKjgncLFMagGyFokyrPTrQ9h2cZGWlNeYMrWTgFti
	RBX/TtJqaQd34ba+f3hlhDjBTV2fJupnvkvRg0Zl9T6CmlDkj+WEg/nBJ4WpeueHbbdt6N
	hpmepYkkSuyT+vKy2xCJj1rIz0mtZls=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ganFkmH6;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93a40a9a01aso249184685a.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794314746; x=1794919546; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/n0bim+DZunsCFW3lXGEDWBVlO3l7mvDuQoSVxWJW/Q=;
        b=ganFkmH6QWYEZ8P+bLvxohY69358h0hqgz0zJuaHmu2J6mvxdU4DsqieLrfVKPdFeu
         eDCAe2l9PANts2HzRXGCvwIJNcVDetB1WebKN/Q4DqeX/n7KpTdC63j+UWgqc/UxudzN
         TK39qQWGpeV1qFEgGtik6MH7GD/N6t+SKThi9VXHcYwQcSunMa4VYBUPKGg10Z8owJ2j
         we5igmfmED/sGEbxG1RMPosH/48NAP76iw7aHe9HSPb7HiuPJBpSMGjvapRwl1nLwF9c
         MNILa9dIlrNuqypFl8EO/i+o9zeTs0BRHvWqX4HUWG3JtnaQEyZvabXmz8j+ymOGbp17
         msgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794314746; x=1794919546;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/n0bim+DZunsCFW3lXGEDWBVlO3l7mvDuQoSVxWJW/Q=;
        b=qmoaGaRjAaWxg1FRV1i0wru7Q9AZGHgDtcxW1OFm+XPLSbDQaa4doHBj4R6LPodoGv
         hgGBlgFH138Cmffi8ueDW7NxEvz5DurJ3J+C7zbjdtE1fmO/g0XP2/bBXZOScjV5BBNF
         VnPu0Hmd7k7x+GFS229JUvY8nnJyDSWbh+O8uZU7XMlJQoyKF2LgDs1BQfR8bASmh0YT
         aFnWWvC/DLgWX8IjD4gj/9uTtoirMWw+y2bY/BivgzODfhHXvMKoQX6Deoe9uTotYzcr
         fAP/h9mPj8cIDJNOsjGBNntI6ulQ/UXQ+AU7yFfa3xZt91pR7M/P5t4dGdLKuRNljRZA
         wgyQ==
X-Forwarded-Encrypted: i=1; AL+hErHMCDO2CgpeILeRi71jugQ9xl42LlmKT4uit+g3MJhcP0TRpNbjjSAJ9yOdOp4s0nL5mzSTMrJ8Uw==@kvack.org
X-Gm-Message-State: APuU4Z8NnZfy1Dqph+ZD1dabQu1wTdfrxBH8qqlpxxVpGvUTPl2rzonj
	a2q7vml/AcBH8PH2UEUFbscLMIMPgaVlAkZC38ZrkCXb5sg6hXBuPDUSzfgFwh3lqTE=
X-Gm-Gg: AYBFou2dbNUoR43L/7TUKs4UF15/s4tpMB5ogbRGj/RYGpTS8RQwifUCn+Ps43NBrDB
	MFmra8Ke6wq1jtCMBWTj6TlJPSnjTd+QYJQPmd0i+BM9cCcglG04MODioQ033QRsLraN/CMcdVD
	sNWfu6YT9aHPQWv2eLJetREUuxibi605bzsBYkcMB0QWyzKt4J51cTMu3ltKTOj9bwvu28q7hQ+
	P4qF7Z3v9jcL8jATsIYii2PVOVJUPwQSfnuFuZv8rm/MUGCS35bDdKVACjVvZJQ+21JmKgfZXhC
	uDXnC5f/M0eRX52ixwzLO8qt+pZE6BYNj6+1uEywSLSskPaqXITFwKClFvlnkbreFRZ167cT0Lb
	uAXiIEhoY+cV4Gir9oLXAmaJHCBLzzj4Nazm1TXUPrk1JlQh5AyUeeHPxIAy8JQ722Jdy/TOvmz
	Oivgr2NpiGWEhAQWtC9pHPuDlUAWgvmx1j+nAtvDxEW+QAvhl3lc06d4v7x1frWDvf/bMZj015S
	nn/2M3v3uhOdd8v4yHO+YPIP4TUhIJoVapm4QKHzPIkgXpELE4CsYxxqfkBv71tjH57q0W+ybAZ
	FwvBgLr5UjsULj7R31m41f++MGgA+NieUiIC6B08Mgd2wNV5ai1D1FnUVFphc5fzuIO8rhmEvMu
	Ya1u3Y+4=
X-Received: by 2002:a05:620a:4055:b0:93e:7ec5:2cfe with SMTP id af79cd13be357-9479f4b6e59mr357636485a.28.1794314746577;
        Tue, 10 Nov 2026 04:45:46 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e73c3ddsm215618585a.15.2026.11.10.04.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 04:45:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] mm/hugetlb: charge hugetlb cgroup and memcg in
 alloc_hugetlb_folio_reserve()
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Gerd Hoffmann <kraxel@redhat.com>, Dave Airlie <airlied@redhat.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
 Daehyeon Ko <4ncienth@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>, 
 stable@vger.kernel.org
In-Reply-To: <20261110-for-alloc_hugetlb-1109-v2-1-25795ce44f80@kylinos.cn>
References: <20261110-for-alloc_hugetlb-1109-v2-1-25795ce44f80@kylinos.cn>
Date: Tue, 10 Nov 2026 07:45:44 -0500
Message-Id: <179431474443.789062.10429880669466859032.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: kudka6owxwododknq7e3ztzfgcokib6m
X-Rspamd-Queue-Id: 6905A40009
X-Rspam-User: 
X-HE-Tag: 1794314747-946475
X-HE-Meta: U2FsdGVkX18OLWq4/HJ/RBpYFO+bKIWpktmw77+iOBT0py5lfdWMia6cSgg7GYRg85HGuPPQGYd1deIPHwurZVmlDSEns9JfOy8ZyqedesPvS4PMvU4+0gIybwqYc1MjqKlEFqxPNQxQ/XzFVqkDT6AGUQaNC+r4XKYWn6tCj29ZsnClxs++F7Xa30hflBQuKo7MrdfzapO4nxLDlXc3VuZy9S9tEWAUwldB28ezlwawTZpWIuQ2XIlwwtJ0rhcR/0gHOyx4HOLIdFYgbfxxK+FEJD2S9agMzLKzDKQd/5qR75ZMzfb9cMT7iKblTto10i8f8M0+xkItxtMEuZFbaUQ7d6B6P6s/XYR7uskTJSvD+SUMeO0/T2HaDCD4Blp7yejmyEvqkd8JBZf3YSBw2GPl3H7Vsc3Lgfeh9bEcrcMvd0yBXlvLweNXwPoTLYA40kMEr2SQuDOyIWwIC3e5CIjVedUIEyGL6jqyuy1MY97jl9uly/Tp40W7s8ZAnFU4I5VF0ae0vgLbG8Uk5H99DsRV1Jo44FlxNOsw6/Zii7IL399pBTm2zym41X6U1Q7zOVVslchnr51IBl8RV5BqmU/AhsnPVUnR7TvSF8ShhqzRh/8TdKzyJpdWMqM3yRzPMBPdRgLLE/IAvqUeqd2m9qSUcFg+Yf11Y6RoHhCuPnTO7HRt3DpoCyiOCDTJDk8naDUM1Mvub+rr9/PC0DBTNZnSoY0tT0mbdt+Pig/ahpWIY+1RMHSfQU1zf0EjSv+I1xWBW80b/BipjRl91WZ5Njvkty1OXH4EDcKRgbxqKCf5WW1cnxcvEH3enX6BamaNg2K3ijiLEo1Bo9D68jD8m+oFqD3PF6rJZJMVauJqIABk0B7eXZrCLmtrAS87E+3m4ald7Nj6gol53cRNtdS2HoNpGlVv4uVlPMXZkP2BLPhF2MSR9CEoNuYWER++wgyGwQeQiNoPgvKR7oN/EXE
 hyiT59Vu
 jyqcWkho4L+naYedzkuDxD4JfnjQOjOfXduZX+UEDo4gGqCK+kY4gLVYNXTdqadnmWNLe3xloZ8HwI7RVa9TRKwhNnlKg6WSkbAwx66GSZqtkr2ixP70w1etfG5DI5F63et14LhcqWzT3gje14Rwie3/eR4Sj/eWpqOcmzPZ3sdz6sKh4dHAArjUhKVOl0bZusofezrjECyAbD0qFFRoqJQD6NLruwZabYeQWxDssq1FbO838MSuAnAS0Qg7hflDrn1kw1LskRUhoEIXxrpg5O38TX7EILqXJcmO7UjQg8tHjYHkOi4QLU3UCZGCbVUvvjk2RDwsOURaMQF9KKqRbgE4QQq4bsEpiWnXj91xotsrdfvaj9YgVZ6dxeDAtGBVwnUN2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-10 14:05 +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> alloc_hugetlb_folio_reserve() hands out a folio from the hugetlb pool and
> consumes a global reservation, but unlike the fault path it never charged
> the folio to the hugetlb cgroup or to the memcg.  Folios allocated for
> memfd_pin_folios() through memfd_alloc_folio() were therefore silently
> bypassing the accounting: they are never charged to the hugetlb cgroup
> usage counter (hugetlb.<size>.current or hugetlb.<size>.usage_in_bytes),
> so the limits (hugetlb.<size>.max or hugetlb.<size>.limit_in_bytes) are
> bypassed.  In cgroup v2, with memory_hugetlb_accounting enabled, these
> folios are also not accounted in memory.current and are not bounded by
> memory.max.
> 
> Charge the folios to both the hugetlb cgroup and the memcg, just like
> hugetlb_alloc_folio() does.
> 
> Test with a process that creates a hugetlb memfd and pins pages through
> UDMABUF_CREATE. The counters were read while the folio was still pinned:
> 
...
> 
> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>

one note below that is worth assessing but maybe not a blocker.

> +		ret = mem_cgroup_charge_hugetlb(folio, current->mm,
> +						gfp_mask | __GFP_RETRY_MAYFAIL);
> +		if (ret == -ENOMEM) {
> +			folio_put(folio);
> +			/*
> +			 * Skip uncharging hugetlb_cgroup since the charges
> +			 * were committed to the folio and freeing the folio
> +			 * would have cleared those up.
> +			 */
> +			return NULL;
> +		}

This adds a new -ENOMEM condition on stable which may race subtly on
two tasks allocating against the same memory.max and cause failures.
In testing, it doesn't cause splats or anything, it may just cause
spurious allocation failures that fallback to other paths.

This implication may be worth a comment in the changelog.

~Gregory

-- 
~Gregory


