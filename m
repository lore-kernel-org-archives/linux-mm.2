Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10789C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 10:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FFF16B0092; Mon,  4 Aug 2025 06:55:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D71A6B0093; Mon,  4 Aug 2025 06:55:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ECEF6B0095; Mon,  4 Aug 2025 06:55:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DBDC6B0092
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 06:55:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2B1EEBEB9E
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:55:02 +0000 (UTC)
X-FDA: 83738767644.27.0E4F1F7
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2A52A40003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:54:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=DkrhuTxF;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754304900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jTfwzKdFO4Billpr1agzWiIuczhIZbl+uk2TO52W1Ms=;
	b=wnoGPfBVVDWhWtEm8g/WHou6GCU95kzEt6hqdJwX0gKG+SxD0I8egdHobXESPu/TspS/S4
	1VlOZHsPpvDJ5MB8605OoqzY4MaGlSX5aC98ILEv68v6l5MIKoROhY2HOITUnogccPg27K
	rEsRVpSHenn6IlrJV2LpBa5acNQztjY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754304900; a=rsa-sha256;
	cv=none;
	b=Y0ityn5PUm5lyhrjASuRCJf41gWccBU38W1iITZ7sXzlxVvDrDkbGD5DK0LIjPlL2AWHq8
	ATOScpru/oQigXCawb8xBk/JaCgEKXG6TJ9QHEi7qSuZmIv+A20ZU9SIHeU3qz81/ohwZn
	iMIn2yHfkVpJ79jrtRgd0WR7FYANmYM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=DkrhuTxF;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-45994a72356so10241555e9.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 03:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754304898; x=1754909698; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jTfwzKdFO4Billpr1agzWiIuczhIZbl+uk2TO52W1Ms=;
        b=DkrhuTxFXAqMeArR7nY4U6Lf4V/SXwx+o1h3KZFREWyE+uJ/g35Oh17ZA0nkmSAeaV
         s66LPkp5j+q8OM5E+y1xMl502CRAa5u8ae8BG9jelx2rCKeUPM0+B6G9NCx7XIk9IZVw
         7kv2zAzKQTgStzE/0R/t70WJcjjVDZbKO+nGgUYDqKhRFJRZwraKqfFjJFt0K5DLbQYC
         Rmdxk/Gh0aPuntNySkcSwTApyeqnt5Ufbe1vvcgyeu8ZVm2y7ZVloLd5vpnWHULhLJg8
         kpYGlxY53XQyT6RcchtgOK1a38M8vyv8W2lJ4t4f+VkWeWKs+YYWv0B1IV+DEkFfU90E
         kq6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754304898; x=1754909698;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jTfwzKdFO4Billpr1agzWiIuczhIZbl+uk2TO52W1Ms=;
        b=w9ra9Wa181q8sLIdKZ6nwM19761twn7TcCETrh+6Eq0Pn7jcZH8h3uU0sV5GXfrFoA
         4VojTDiZT8ybpzDOuulKL7HkBrAG3Siz3YAbZNgDORbFilEwUNA7Ilw8pRodrwF0wSPH
         gy/iemkj/6kRUVEVSbgNN7metGzdzVxkFQogsidcqnLr/r9+sw8pp4yXIP8+GX0wVrDZ
         nbH0D4MzbQrn+5klQ0uI0G9B+rccWpFfhNRuCA4KVIrRhM99bZv1TaEt41NqpECQlo01
         7gwaCEM/9pHYUfzIOkj/F2o8LrITWTrMbfaI822bbQKQ9VIP2c2tbPvH+WycxbD50reN
         3lvA==
X-Forwarded-Encrypted: i=1; AJvYcCUJUWRUxaSjtKUUq3qLv1CyR9KC2/HVine1mtuVQUSfemVP3whSN4y9+D03P1uNhLb4dnGxDORsBQ==@kvack.org
X-Gm-Message-State: AOJu0YyZnnQ3ykFh86LyEnhAW12SkPt261AsgaeAev0s7mxl9p99vibQ
	OovGJnQoPh2s9NTLdX5clPaMuQv6wZi9ezPR3ApVaH5p0CzM5KQBdc3t1GcVu67CH/E=
X-Gm-Gg: ASbGnctNowqs8c+5n/YJUXfLbgYywO53Bp40TKpB84qqnlkX5F/qgTlSmLfdAJuB2sn
	8kW41CKThJB8c8GiTHW2XgwHCq5Xfs3YzknxFrtJ7fBdQ7fzlJ0twh+WvHfmmBQHtWOQ8G7IRt+
	pX2Zr0vlpe0OsGPc41yjyZkWWzuFiioaPSp7RBomVCouLXPk+tuHYuxhvDeLD80GwVDE1QxCSUx
	7a04wHmfq6BJBFDHbdA9AHPP5JQVRNIYK5eHcgk7wDwVTfY3UsQp75sFdCvH6IbEfFsy6CQF5Ai
	nEDnv3ycmwQHbft6dSGZzu28JHl0I03YGl3G9jcxPBuBqDncQAvP/wirxKnAk5MNVBh4uIwan7z
	B91g7CiKHAp6P5biD9QkK7s9XhRUX15CsSUru9f+wZQ2rV5t9qqqaPA/BijaMTOUlr5t1BdZs9+
	Gjizv7gO8ZZA==
X-Google-Smtp-Source: AGHT+IHolr1jpSS8jZ3V5wzzwBRxkUohemu1Nv4CGTNmDUpUc5jSaT3JjX0JSbIFj/1+2LYoFZrMMw==
X-Received: by 2002:a05:600c:5246:b0:456:1281:f8dd with SMTP id 5b1f17b1804b1-458b5f190f6mr71240945e9.12.1754304898475;
        Mon, 04 Aug 2025 03:54:58 -0700 (PDT)
Received: from localhost (dynamic-2a00-1028-8394-58e6-9e1a-64e5-71bf-cbcb.ipv6.o2.cz. [2a00:1028:8394:58e6:9e1a:64e5:71bf:cbcb])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c453d6esm15241180f8f.37.2025.08.04.03.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 03:54:58 -0700 (PDT)
Date: Mon, 4 Aug 2025 12:54:57 +0200
From: Michal Hocko <mhocko@suse.com>
To: David Hildenbrand <david@redhat.com>
Cc: Eugen Hristev <eugen.hristev@linaro.org>, linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
	pmladek@suse.com, linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, corbet@lwn.net,
	mojha@qti.qualcomm.com, rostedt@goodmis.org, jonechou@google.com,
	tudor.ambarus@linaro.org
Subject: Re: [RFC][PATCH v2 22/29] mm/numa: Register information into Kmemdump
Message-ID: <aJCRgXYIjbJ01RsK@tiehlicka>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-23-eugen.hristev@linaro.org>
 <ffc43855-2263-408d-831c-33f518249f96@redhat.com>
 <e66f29c2-9f9f-4b04-b029-23383ed4aed4@linaro.org>
 <751514db-9e03-4cf3-bd3e-124b201bdb94@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <751514db-9e03-4cf3-bd3e-124b201bdb94@redhat.com>
X-Rspamd-Queue-Id: 2A52A40003
X-Stat-Signature: qbnnkr1fm7933c4eybemgus56mgjrs4u
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754304899-974951
X-HE-Meta: U2FsdGVkX1/brlT/LXn+v+px5owle7GpsVTk4oaVtm50Wm1CxZdsGy7snAOX/JqW7sdDNX9VyVhDNuaO1alheV78dGJkQ9dDpSrANgj+ugNE0sOnfbblbVweQ9OmPfopCKp6sD6zJPo6rEEJx9DuSM1s8wkJOKciqdoXMf0ULpD/ld9b7c08v0RjzaNwq1FhYGlzDaDZO1KYPF5J7AyQIe9Sp5HZuwhdN8hL6OueA+F9M/RoMILkJOFJGbs4cPvZ19v4IQNz+sejJyG+JTbNBdMnjH3ewWuGfPkZNVwhlfIzY1UMHCXNlY6+hAWjCi6I+UIVpj9TI/3jgeaJEoEmK9K4AEnAVw4bkM7S6NKtP46ewpTpLqq8um8kCbuB7H+iHcZSy1FdhtruwuwIB7ZkKCVWX4kLgIDifSyYKdWvA4iQ+V3V/7ed/QYMkIjmTg/JIz97z3GGuQMdGNzwiUKSjjAf6ztql5CEQP+5ni788wqgGQbZOiGNrtZUpRho04t6tsuCasb4+fHwIY56nKlAYvTuYAs6lPQA0pWodlXHiQgzmwdMMXpcxb6MTBRxrkN9Q5FAQU652PKGKRSvvIkYC+u0lCPxSvIma71gP2JKLivxuqdakcM4DyU0MSZlV1PcJy0mdtlbs15UtyG0/zDLA4aEO+AcNVlL4h0jxwnrcrTPwW6CX9+hChUvq0klW+hexEiawZOvQ1eTyS8IJuFFQeoS81Wgn2R6lyU9yyLCcD9uJ+jS9JUQ/j3hwvDJgz3aq1TH/1+QTXZ0DrYGoB7WseXLDmMjpAIFYUsso1nCos70SOKXyXHi4CqGfIHgxTRCuu+TJhdAaZR6h7wGXzTHB+sLkIiGGEBJm14tPpokazua0ZUm0fX7TT0ZL6urU7YdNzbvGI5vRYVm21dSpi12gL3mOZz8iLB4ORVYnV/qd6K3BkfmP5QCKGMk2Za+bG3RVT9n5fQpaX+U7fgKZnj
 CSEt97bh
 wDbK4tj8D0kDsCzhW6qkL1LSIyzuOEDJgkWvsaZg5wq1ELYdqhkd8D7jyUZ13+dJMBLf95F69ZKZ0a5A5W5nxaMu/BCVXcvIKmH+BQEhX7xgmHFxhHL3s9mQGjGfcNltYPSTde0rwg3tJKlQWo2ar1Llh+O9LkvxmIO2C0VPHbpXaCKaPERfMlmeoBmOrlid6YRV9wwoBgv31IZTNg7yCtrWmrcSzxdFTVZc5IN4nqsb68qS4SpbdMjcojZmRBRL3zsIOqUcoQ9wtRGse6IZxt6cnu7JwyA7tGdgdDGmE6GUurzxGuK1Mz8tAmh5UA9CGHjmGjfIiOM4UKb8bhJytbavgN4PTB9gPAkCOMQLulQAtoG/rlv290C3kqcSFwEw9KXU47rVlKj+048/1x4M9PYDw95Uo6V1AFHHSGBrrD/j07lwWH2QM5CnIsXfCJ77xl4aPBY66P0MkI7K11ZhwMY1cTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 30-07-25 16:04:28, David Hildenbrand wrote:
> On 30.07.25 15:57, Eugen Hristev wrote:
[...]
> > Yes, registering after is also an option. Initially this is how I
> > designed the kmemdump API, I also had in mind to add a flag, but, after
> > discussing with Thomas Gleixner, he came up with the macro wrapper idea
> > here:
> > https://lore.kernel.org/lkml/87ikkzpcup.ffs@tglx/
> > Do you think we can continue that discussion , or maybe start it here ?
> 
> Yeah, I don't like that, but I can see how we ended up here.
> 
> I also don't quite like the idea that we must encode here what to include in
> a dump and what not ...
> 
> For the vmcore we construct it at runtime in crash_save_vmcoreinfo_init(),
> where we e.g., have
> 
> VMCOREINFO_STRUCT_SIZE(pglist_data);
> 
> Could we similar have some place where we construct what to dump similarly,
> just not using the current values, but the memory ranges?

All those symbols are part of kallsyms, right? Can we just use kallsyms
infrastructure and a list of symbols to get what we need from there?

In other words the list of symbols to be completely external to the code
that is defining them?
-- 
Michal Hocko
SUSE Labs

