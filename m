Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 440E6D4A601
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 05:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41AC46B0088; Fri, 16 Jan 2026 00:53:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8306B0089; Fri, 16 Jan 2026 00:53:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AA0E6B008A; Fri, 16 Jan 2026 00:53:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1AB026B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:53:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5BCB1BD9D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:53:02 +0000 (UTC)
X-FDA: 84336758604.29.A2E140D
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id BFC72C000F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:53:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="OvVHg/OZ";
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768542780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ug224Qb3vKSCQofyknZA/E8Q4LTRJDPS+QLswzBuzyo=;
	b=OEUVCukNKh3211rngvH727ZWLneSOoKcpLHlQEiru2QjJE0VJo1KF52AEWMz3awRwql7b8
	DJjJ7c3Bkvj1wQQ8erY5DPth1LtKHsx/O2/oa2pqI98PSXhV2yjoD3rcTaiRHo1j0VlzCH
	MDB5mgmPcOH2CEwFmhJ0QA/ssaxZcss=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="OvVHg/OZ";
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768542780; a=rsa-sha256;
	cv=none;
	b=fbC2rx9hyzAkHD3QdQ0HuaLryF+U9SpbcAqwJ++D9g+UN8BSOJNSFRR4+Wsn6aazUvomKj
	1rNZoSk8JaE1xpe7DG2TP2zHqSZxdimkBokS+liI77dES6tWiUueHetTLvR0bCS2/UqbOb
	n9rP/o/BZPWxxdxqg/VuOEvxK3xeup0=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a0d52768ccso10589035ad.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768542779; x=1769147579; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ug224Qb3vKSCQofyknZA/E8Q4LTRJDPS+QLswzBuzyo=;
        b=OvVHg/OZYJtuymB2YQ3zCL0ddPWBaEeUvvFDUJVmyVpCr+ikcgLWiHHKH+PcB/2MFQ
         9/58W6CXir5tj7d2L5ZoytsoBRTcGVjQZ0u3z4vb1xeA2NJOp0cU0WKhGV6GzXw9Ky3E
         7AimPInp0KmOoCGVD0gPNMhglxVk9tdgeMETg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768542779; x=1769147579;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ug224Qb3vKSCQofyknZA/E8Q4LTRJDPS+QLswzBuzyo=;
        b=tohvf8MsRz3qGQ/kGXdtuvN/eQRtJ31QYBnjYu9ekTFLjxh2FBiZbLB334pPEbJ69s
         0flxM9epP4lK6jHe2rvkmp9npnjche3ggIgcoftMBCd6bH2B5eay6GHuOHICx9PYgBLk
         j4GKboBEsNNtBEnyyZMS93aZgSgXDFYkLsoW3ttdGwHlRH2poxWIlstgQQ8LHtIR2PZ6
         i0RhCPw7vySBxM9F57sy1ewnC5jXRzW0D8TbI+CWNokioZEKIf7cUza4KBACPz6luiWP
         kBYqaf5E6saZDuTxHkAHykCBgp143fnEMMDURvjmGuLMhWZzl8c8A5chiA8iDs+DVXAI
         vQvA==
X-Forwarded-Encrypted: i=1; AJvYcCXK8YsaqFGQmbZNrMR60Ipy+0l5pzwr4r9VzEK80iw9LeGa7nDswV8Y967UaY/cE3qT6kYkslMVyw==@kvack.org
X-Gm-Message-State: AOJu0YwNQ18xznkfnWMFuqX80Kv6zsIBz3fAdSHTDvRPWAf0Fx1xcJOP
	Q3DA3GqmYJMLuMl2HKhiXeg3zfrCsjYwil3cL3qtXOaM3JbnkMv+RS2upW6t43o1Jg==
X-Gm-Gg: AY/fxX4R5Qhx/Yv7nQFw6RMcy7m5NP5vFZYJDZ2iKbOQGgLvTAqgZPDJqayaOlmQ+Qu
	cKcbnwgDGjD8iHki5gPCMASg8rX8i5YkgEJFtDyKY8JTxCVh0opjwriz6RpE1FhyVokBFMt4MVX
	eVru+ZYX90MgA+Ok083QbvVJGjiAR9gDbgQDMJZr5HTwmj/mjcmb175jSVUqJl7W+613PIGmW5O
	XowsU8Afoq7r1Xm0DYgK5LDfWVBCbHDQHgXf2SCC68xTnVfGQsagTxrjOmtlb48vySsPw+do74X
	kYztu+aL1I9SUN/IM8AOxiJ52xKE0VdwBNgKzJfV38whcbGs2MyVaVNzhjACzPcAl6EmaHqLuk6
	JYMTjCIGN/GjphkwyRJZt4/8vN0rOYY+7rSD7tYBi6PTnhkhYClcivJ1kSCIPF7DfcXqCB6bTnQ
	MDCk4c7NQn28c8QsQTSy869VQXLkCYkSDu/6/G1WsZCZssXjZBntBsACwTcnY=
X-Received: by 2002:a17:902:e551:b0:2a0:f0e5:9468 with SMTP id d9443c01a7336-2a7175c1dd7mr15411895ad.32.1768542779592;
        Thu, 15 Jan 2026 21:52:59 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:ba7a:360:116f:dac])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7190c9e85sm9784395ad.26.2026.01.15.21.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 21:52:58 -0800 (PST)
Date: Fri, 16 Jan 2026 14:52:54 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Minchan Kim <minchan@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] zsmalloc: make common caches global
Message-ID: <zfmvd2oogwtx6mbavyjgwxralsvrd576ye6jnscfwvqy4u4ayp@q7qpxnyaxb6f>
References: <20260116044841.334821-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116044841.334821-1-senozhatsky@chromium.org>
X-Stat-Signature: sd7f6s8ibrm19y1rcc65ims8dgfsm169
X-Rspamd-Queue-Id: BFC72C000F
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768542780-837707
X-HE-Meta: U2FsdGVkX1/jYSO4b6Atawb0MS8chhVK9c31cU/E2CH4cvjrIN4zX3i3ngpaHd+cpov8R4R/NW3Dgd9lgF/3TMJ5qjtj1cthLLa336D8gksWdiNJDjUY+G3xa/diWLgTzKelhAlzfnS78ItJFFjzeZ3f4lSSQhgLZ6ymxfdRHTUKFl0ufP9/wgl4Xqq4o3lz50AnGMlJCxCPEiqvowNO3ZJuTKgJdSSzrNhJ1BX95d5xrmcD2MxzCcr8meJd+cS7iMSHz65rCpjrry3V533a8BP8BzxxEYj/S0lxxVNJdGrChCo0LdozbueqMwddUeCnUzjz+igXf/yaKIcPlROah/1p195I5gVcmeJmLcnefSCnkoMJSPZAGde4BctC1tsQMHSYLjAJOkaHE2V8brFNqF4EFcoPhG7QNri0fyOylHXflUFWPE6a/bugiDxabUMiuVMV9Qq3fQjA2xU0FcBOdZfz7yI1LnX7K3csQQV3hcbJph8yrSV0kiCnKrbTQ4wW1la5l7WKrZpduv3P3Yu8eEOoS8ODMXfCY6NAUjBWpLAQquoWWS3A80GKvaqaHrtEIzNbzoqZ/KD/VYWh/kCUkMjBh5gDP2qOZ994sF07tTCgs3N7aLug0KG5col/V0iP+g7avl0QRn40uOYGRGtiPLp/Qg1T76Xf9uN+MyAT81J6SwYsCTvWn21opZCjocgSV9sHMmO975OsyH0v18T/mQtm0Y6Sk6ClaRUM5a9cWrSMZPriQ/ZtXJtV1qIa8kXKV0GHWjk8FSCnfEW8IfSs0LsEkr2vFM1mNeJUxkq6/g9QB0meKBsg1NXHpdS0SDrsv2s56nXeIyT1seu8+9g9P7UoOOiAMRXrGouocmwCD/aNRn8trGEjMYYyPiZHvNQw6iCkfGsOMvnyqNGjFmld7BmMsyZQgR3pR0Gpu+9MEW16rIizriqgwCk8uTig1UqxS6OwyinA8P7RYdVVFZf
 /ePRhuuC
 oG0Lwtjd/mHmpy1hgGuxyj4IqHdHPVzeqgSZ2McMvbndC9GL9Ho/OEgvqDO//8SITy8xW0+ynZ0uV3eCcZhbE3aZOXHR/MzuJmBEdY0zEF6WvlCjGz52PFUW2GG61r58ImMKDIZYTIxJR5hO8T6GcztZZu+demMX+nr6nhoNSXDf4qtnW6H0/f7lrUSV1rXj9rWzwXB8ThorpZqlUa0HzazN+Cusfu7XU3akMpowLUqk+FNp2OeK2GyvTJ/JhQbltFRL/UQdhgG5QS4B1NFH2cnPGMTITGTmg6HdCWxsvw8aOLKqBLlSzFItVCrWpYoSTZJUnRO4w9AIlk1rU1N8N4j3xwcGMWnn/zzvosHRhyTtP4IQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/16 13:48), Sergey Senozhatsky wrote:
> Currently, zsmalloc creates kmem_cache of handles and zspages
> for each pool, which may be suboptimal from the memory usage
> point of view (extra internal fragmentation per pool).  Systems
> that create multiple zsmalloc pools may benefit from shared
> common zsmalloc caches.

This is step 1.

Step 2 is to look into possibility of sharing zsmalloc pools.
E.g. if there are N zram devices in the system, do we really need
N zsmalloc pools?  Can we just share a single pool between them?

