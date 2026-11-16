Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62EA8606A333
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 21:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=ahT4tc8U
Received: by kanga.kvack.org (Postfix)
	id 5724A6B05B1; Mon, 16 Nov 2026 16:32:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523076B05B2; Mon, 16 Nov 2026 16:32:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39CD96B05B3; Mon, 16 Nov 2026 16:32:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17A486B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:32:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9391F1A023E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:31:59 +0000 (UTC)
X-FDA: 85442279958.24.9701F75
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id B076D1C000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:31:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=ahT4tc8U;
	spf=pass (imf21.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.171 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794864717;
	b=yTnzns4xRfnYwa2ypodWbnDpomIcSt8FOlp8w/iaZ61Zho2DJ/SOSvE9zbRkyCfAbfvI+U
	NvDs+yjkSdFb/36llRH5FeMKvZtt+lilYTX2A6KsIBuoHLPkO+yc2rGoDWCxw6ng8zPSii
	2JwqwzvW1VmsMY6oITpBmoi8fGiH6FU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=ahT4tc8U;
	spf=pass (imf21.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.171 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794864717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sPk0pn9cbo9uW3HmYfUN1NlNCSOlhfvfIq6E+7rjiI4=;
	b=B9QkIYDMxrMSPfBxxvPgFBmZfQvR6xXxfSNLnnrYoox4rU6mN0Q60bNv3Zw8VSJwvPgtQG
	UCEwyWrEIH+wVQI7UOYi49BWvz2kyzxTkU9nNAxu/eSWRgEfY+SKQRbX75X3PTj9M2FeSs
	0Qma6BqUFuXaS53F1LsibMfOLIKWoKg=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36f6295304dso3363433eec.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794864716; x=1795469516; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sPk0pn9cbo9uW3HmYfUN1NlNCSOlhfvfIq6E+7rjiI4=;
        b=ahT4tc8U0VdANjcB83l9F7RVwsMzIZ5QTDquYddu6uNGdubmxKXb6YECY3dzpfTk39
         ZLLgA/AnrfnncW4QvfdWwkSPfHpA5YU81ZCTMFyUMHHvQ8bDq0u1EkdZMvbHH4vQjk2m
         QWJf7CJjGp6Kow8ch5CGdH+6AQSVjQcO1aZsI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864716; x=1795469516;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sPk0pn9cbo9uW3HmYfUN1NlNCSOlhfvfIq6E+7rjiI4=;
        b=iP2cPAcQJssmd1SevzMthRj38JeI+Dz3IMLn7jMnTM8yzMQB826H1FOk6o6SBAeFxo
         hAN4yTYQXGSg+9yD/TgUHWs4AxJWTlcYYKxzrflTYDu1pXIxTX1Ql/nz6yNAIM6f0R3C
         rCn/h+AGn9ejeIYZ6c6xrun7nh56O+oup1w6+5cgpOg8mPU2/ukEJo6/T0vbnW6r7GQz
         Fsqlwl+Zthp9LhLCeEw5CoCpslFXSRdiXVaDw+C5BWuFjQc++0TxLSQIo3od278aJUOA
         EYnwPuE2th8zPHUe1ZbIv3rc4jGhLGMWe9sOvLFkBV9xfr+bUTUAjDfaTJ5XbL//Ukl0
         wt2g==
X-Forwarded-Encrypted: i=1; AL+hErEqJsTVzEFrM/lUZ0Ky2pM5O4S/NLB6vjcdEwZ75Ejg52BE7CCLMAAyc0m7t9HqKBv4H8noi4h+aA==@kvack.org
X-Gm-Message-State: APuU4Z+uU3l1V2t8Yscth6P40uYyY8rfwKavHDABYmscdpLSTix4IDWB
	vkopNqvt85RhxMtSYdqyrR9wf5SbPlb9J3+y9mUGZIfpT6eXWU4JsXh8hlaZ/qpjaL2dSibXnWg
	aK8iXT7eihcjX
X-Gm-Gg: AZFdTZecuquXIeLEbkVQB0NrpdhtroSEUqUnMwOpYJ7hdIzJTn0BprWU5CicWQzBE5S
	dOFwmgGA1NdnENaWH5ZoVDKnAyjo+N/LMXFkgwuhQBIaYgptJneh+Jl6BGdkaNiQ5CUW8PPdFw/
	A5GEKtuLofeMURuhvSO6uIjMqOlpjCGo6Bj6N8C2gZXgDpzhh4+RWM+6nLmBEnAFrLGI3f4ju8i
	dOyKA5dQNk47SqPtmdT6fB3fiONHTW19oB90gAPVhMqHbQuYMDiagDbpC72tGIbIHfTM+pqZYhl
	AW0dgfX94TWPPg8nhxPGKN7F6yEpEIp8VWX2RkXu4PIhF+3NlS1SgIOOgqsH4qXCd/MdPxUdcNl
	Gamn8a8mceUQo39WibkgmULGzYUGNRygFbA+CEm7JhGPM8BbfRq7nWfAa+iRLbHn3yYsNmCtTCp
	LVV2WFvTg3EJCoMAeIOYL0T6ezb9rLyoBNVnpEDmvlVFJaab8kWhXe+HPMylMWqArZppdkQVH6f
	IIqk09K6cscJMmhzcpwH/Q2KSnoqNALgikJlrfg+1mHTKyE0UUHI5dFKSmru8+oAeyar3j2JSh5
	4BGYB1JBB/Ph9PecL2AJxjQBn+KbYjnCH1Ro52pxdM22mmumWnEQg4qIXTFsmyk4ubDf27ZkbQr
	gzYMyQd/cT9KlJCswkp2mTfY4a76b6cjcriAC4DGjYUCC3yAMksnxtEuokrcrUOTO4eW+mj3xvf
	DVL811Fx2dQ2rX6uLcX110aDs1EAQfjStSdlEioe9e0reuOZJSo/4lVgUIB64EoFv+
X-Received: by 2002:a05:693c:2a18:b0:36c:a44c:1763 with SMTP id 5a478bee46e88-37967316347mr10092163eec.32.1794864716454;
        Mon, 16 Nov 2026 13:31:56 -0800 (PST)
Received: from [172.20.0.3] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379563df84fsm72572464eec.20.2026.11.16.13.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:31:55 -0800 (PST)
Date: Mon, 16 Nov 2026 13:31:52 -0800
From: Chris Down <chris@chrisdown.name>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 3/3] mm/vmscan: consolidate promo vs. high watermark
	checks
In-Reply-To: <20261113235238.3595412-4-joshua.hahnjy@gmail.com>
References: <20261113235238.3595412-1-joshua.hahnjy@gmail.com>
	<20261113235238.3595412-4-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <avt2SHfo-qowULkB@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspam-User: 
X-Rspamd-Queue-Id: B076D1C000B
X-Stat-Signature: i3uapamx79qkuu8bg7cy81s4xccuzg7d
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794864717-820917
X-HE-Meta: U2FsdGVkX1+N8GGIhQkgsNQHEaN8vKGFc1FB6Ksgm5GKfwQN/Y/1HDijiORFGojn+H09FN3y83MAro4N0VhOpWgxB+vHoPL2iMJds9pJ9MY9VUcQKtHeOsO4cDNpiSvz011zqoV5c0vangtULjRfSM/qlUpRrPe0z2nPoNyndCyHXU+XyOWt0b4wALGZ07OXrcg422DfOci/umE/DgzQNWy+TTlsQEMENzTZ257+UFnRWHw4OJ5HPLSPl6lHmrPSc02xus6cir7JjjqCZ0T6zJZoHGOpNEhb7z7do9SM9yv4+WGnviXbb+3AdU9pG8JHh9trne7OQMtHc9LUtYyBP7xG+HHeiCl6CgDSJx7ozxbqL78EJTDkkY/vpqxRXO/aa4ruInCFd4H8M1sc4odhnL+HiPekwwCuVwlgA3t8fvo/uzA5l+K10gRjPHIZ3YMpOrRHEJJFP1BIbbv0IKpm6idJf+onjMGRSabuJHkEojy12WF447Gw6BOS1jA7hSDjXG0d1W9q1Xxz/qZ4LvlcEpJHUAgPBHzENuGOdYIspNYH2MK+eQZ3mpHaYkXtsyA0EzL5Ovpb+Wag7UIEysl+msARbFoPc2j29XsxZIw/Rf/ziTtp+0Mnar/VR3PLnbSCIJ1moyhf+HYgafs+fqrjO8iEZgIvxJvNK+BSQC0qZ7grtf3BLBKjCNkLZK9Z9r1OUOzYgPWN5gzF1MoKTdK7Nll3yIMOmpeFC1XC6yKM+/h9L8wBHj9j58iHLZUCfyjwttorXNPKQry8+HtSM2OJ497Mp0SEXG5NmBHh94pTnwHUGaECBHTyBmxVlt5f/qd2fqo5DyZfexBHWKIfG20AuO1uaXi+Euo1CPZQalNE8+fg9olzqxr5SJa9iwRDNXBIUNu0MLgblboWbb3+TSgqy5m+rK0ym7a4gqjb0uxSDOAb3wuBOXAw/V4OWl6qEVIlVXDa9xdrWEluscRvMzV
 K4cuQ2Ji
 +gt3VmVFbINLYA5kGgZv7P15VmkeaSjGB1m+50wB4MpGhy+B+aNFbfuFyFO1mSWK5412RzNafVSZ5C5oLgg53XWc4X7sZC3bbyZsnxASVlWt3oTNGBd/OESzprhIrWGWqNwk//7ykqOG0I+riGiACMQxQODVSPbbl7PnBWDCKNDQJ7ibRPfzA08C44lnojj8ecxktzP//J8VxqWKV9Lf3jDiJhnK3lmH33vqW3z2Bvsn661Hoa8QoxhW5RWYcJV8ifRa1Wh7N5jWXJOYtc9XgsiIoTWZGOI29Dlkn2d5Tm10g4j8HgPz4RjzaxKjhnfARd15S4XLZt0by/8N2UkatXZCWaCRhR0UExuAGnaV8Ns6TkFd+8SVYitUfCtfcRfKDKt6uKQ89Wkmh1bs+mzDDIWjwWtkIDO25NMKzjHjej5mSD0M+NCPxuSm6oPKPl3Ax8fTJ3uL8oOfdVkujIGECeliwnx4PRhGpuMdTrX13Ag4cTcfwDLH0QsY/gNPTW+5+w1y/IZh+CIHD4u6Y40NXQ2rocQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Joshua,

Thanks for the cleanups. I've tested that this works well.

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Chris

