Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C49BEC5DF70
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 08:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFA1F6B0916; Mon, 17 Aug 2026 04:39:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAAC06B0919; Mon, 17 Aug 2026 04:39:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBFD36B091B; Mon, 17 Aug 2026 04:39:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99C5C6B0916
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:39:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BF761A06C8
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:39:17 +0000 (UTC)
X-FDA: 85110111954.03.C1C7DC6
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4CAAE120003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:39:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=By2ePWa8;
	spf=pass (imf29.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786955955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BEZ0rkuHQPQIomuCaD3mvVzCje7AyhhS8fXashblHp8=;
	b=jreJUnZemQiwJpmOIhTVSj6Z4UKFE4TifMKFg1RaYTW2Sb6jlqcJ1CWWGVA/A/TeI4jlLT
	b40z+j+XVpFXbH0qoJjLoBS+sRu9tjGDBpPCJAAXOUUMVscewkvmuyJ0WUQYZG1Etb/B1F
	W1X3WV99cq+WP6DrMaA/gNjN3157HLM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786955955;
	b=PxZeSBaZ07lYl+WsqBvmLFRAYAamoh6cUgdqnfQ8rL2WE3hAeuKLPSX9EksWY11wkBQG8/
	6LubFWOF8f2EldTeOQfoIdvAZ1fyX+wAA1HqaPi9i6DSpZNR9DnzmAVO96smp3w7tgUPsD
	WREdGB49r0tvRkAsVATMz5b3zp6dQBw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=By2ePWa8;
	spf=pass (imf29.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-383cb94f742so3785949a91.3
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 01:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786955954; x=1787560754; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BEZ0rkuHQPQIomuCaD3mvVzCje7AyhhS8fXashblHp8=;
        b=By2ePWa88jRXN7gDEepPIOxreFZ/Ydl59z65s8Rer9Y1Hjx4KpAzgE9m2RPOr8IWTW
         1MxcoEuqs0RejF152opFKlWXj6oWqodQbY/1OD0JS4lNuHLb8XDY+V5MvFDp8A4TK6Zg
         kukUAMU24pEjpdj1hWH3YVjnCvSh+1RknjeAcZn4yDwhCwyZLjPQIrhzR9YEslD+Pcyh
         uacogTO6fpxl6ckdh7/LGdv1629+joaAlXbKw4D8vashwArmeDBETwDjTkAILrykASGl
         Udb2Dq4oGokK/zuC/W9UOQp+bZ+Z139m792WCtxASME1GH0F+gZnHpXc1pjbMinzdR44
         ZVcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786955954; x=1787560754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BEZ0rkuHQPQIomuCaD3mvVzCje7AyhhS8fXashblHp8=;
        b=KiBvZ16PgVydCmmi90bba4NbRFpwhDQh8cUr7GKiOACoKxosL+a69oPykikbb8p03I
         fZ+diTl6FXLkCZFUlXJWRiaMmgKTxqHpR8loQni5s/0hqV626PPsQFDqJDFNcg8+jEz4
         CkWWD/El4euged+tuL4yMNUX5H7JS6b7VKFdEyItwmD1o4m9oKH8ZZqp+ciZEoKN70He
         ucOtRSTFpxc9lemn59gAVSdFOUVF+p4IvwuZbIMYqXBtdm6b5ejjN56W2daQbqZkVZig
         beLE3NILSvbpiN/6nASCdunLG2FO1qwW7tPSpk4NHfeo9MATHtTzGo3wCraijT4Peywk
         tSeQ==
X-Forwarded-Encrypted: i=1; AHgh+RpB3hjAGlx4pv0PYEGK/c5z8laXuNVDB2gnPgCsMEQRs3AUjkEE8ckraeREiFcdTbb9IWkz1QlW0g==@kvack.org
X-Gm-Message-State: AOJu0YzeeXjoJ1iQUCtRYbCNAbqylSLdxW9vyC73yh6JvNLeWBVCcRO0
	qSeD+Rmf4izdhtAZMORIsE1t6/+NwxkyEUgxtUuyus1UH9/KBuKX858q
X-Gm-Gg: AR+sD11zbyluUH4pnlTnhAy/9olCItK5rSdtXq7GceHrulUHMgAP24BqEIw2OtTnsSs
	nNuwAWjH8RfgfGmn2w+/zrKeUQR0z7wciYb1H9RNg4Kg01or0erpnRTPgtzC4ea3gY/K8/TIEUG
	GsCfatzSrEPaYUEEYgrZjEF1wO0n0KWBPpb3q8l/fk/fnt9pc6g0fCAqzO/Wt0mrDfR0u2nZzJQ
	ii80d6UseyjwGsIb+FyIZZ0mPO2ZvnGjUsiLkpUJmoROGJK7mzR04lAg2Cs5biUbUawOVr36XNw
	oCRq+rf0vcqiLNrdPLFbL7YfmzOOsRHT/K8IzA3l4E81cpm+Af+SKQYOqxrYcMBJwvd3RxjzqMK
	IeC4hFMTbT8bAjRFErTsyR7qY73zhzjcFdqP3tXfuFsJy81u9P6SaOCMKgM/XVxBZjdzTUbuESM
	XDeLOowcHbTImbbQQ67GmH2vKBJp+oMC9K7omGFc08E/bPxuly+DScZ4WrMwfaGt7fGw9YS0UL2
	SdN6ZWaNs4A4su+Mg==
X-Received: by 2002:a17:90b:3b42:b0:393:19a3:4e5 with SMTP id 98e67ed59e1d1-3933e638862mr21181094a91.16.1786955953953;
        Mon, 17 Aug 2026 01:39:13 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:89b:69e5:1f8d:8b25:88b8:b9fa])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39531e8904dsm4086253a91.8.2026.08.17.01.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 01:39:13 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	gutierrez.asier@huawei-partners.com,
	linux-mm@kvack.org
Subject: Re: [RFC/Discussion] mm/damon: Helping with alternative for watermarks
Date: Mon, 17 Aug 2026 16:39:23 +0800
Message-ID: <20260817083923.4374-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260814145414.91204-1-sj@kernel.org>
References: <20260814145414.91204-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: x97gjzhidbb51k6rff8n8ij5hx8e4fya
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4CAAE120003
X-HE-Tag: 1786955955-372549
X-HE-Meta: U2FsdGVkX1+9S3hwSs5gQfGlLiqGewzHzDjW+zVsPA/JR1Cgr+sibcVvnFqunt3uLrSHbElZl7MKBs2ANKdfele+oPplHIpIfv1zQmOvFlIybf+b5vizfrO6as9Zp2QukKO9M1XBKDSnRO9DBYXEH/59J8RRCx+LvnYxbyDQ5YHFwD0dk2JBcGMWv0GD5Lc6+ezfQLtnGTJyJ0/aezgpFMsy67lFqFm7/lYb3e7QjVOcmjteCm4ErIq08cX8RiyJZyyRPC6nKY6jWH0b7XHkmg5cqsZ0nYRVPczDai7BVQmH5W7e421or4jkM0hjlLqzxjNiIHhDMBrWINdxBtAQpbFZ8xXqhFX+UZemWKRbYc7SJ4u0pNwSHktjH0w+I1/1acHRASG+nd0TkBm51cB1P/7d6bRLPoIpIzbrZc8y6MX1TNXzOvF34VIeUL8q9pFtrgNRBf1SBKis/sLzaRhmSi4av15AYM9B8Uats6NtdDRbdK3P3X7uGPgkvk28+Qf15WaF45AxgGqP6GwUs1GhX7fyd8n89o8VQIV8/5j5FRCwTl5DGHwI1ELzAVqDWEA5gfFV5rWcLpimQNGQUNamOu9SaymrjvxXTQ/TQ/SqRmE0QuON3EuhEfhWqaQlWwsoptvWWFtW0FQizBoHyFyZwcl7M0PCqFj+2zEt8lEWhk55tyfQvMbkOK3OP0UWfV9UHNdrKnGl2eJl459Kjx4ZNWoUivCMLUJdcbR4kdQCfByPRw5wjDnWGiJoz0HlDACsboYPlHPmxA++DBS9HHmP+Kp1InLQJegMD2yu8sFpdp3WK5WeQ+HIEhbdfIn7tN6gjwd6CkcGXZqqgn0b9tpVmhAhDh545J+CQPb1W9u/Q/9DQEFmUK4tGiuXcBmgAF7tLpoyH0TKm5L3Arjj8ZRILRNGPhFOp7xQV9s164G40PNcSPrzWFtQO2WDTcYOXSH7VENEMtZ5jRVrYZVDuSI
 ejWXn64G
 n2EBQXOuv1fIxej2OnWw3skeVSsKApMnCzjTIb5jmDLoiQByOoXbw8tssDLAfaXKMK8wOkgUABcgrw9nhiH+K2WIMPFdCJ89napYLkLbXSHLNfc/r3j4IiUNI0JsLgPvltTlkBtSceru4m4lLKnksFdps+E6mYRihE8VMFl8SJUorFt/nVlhgTbWA5r09HofxCWt7hrJqNKVQuIkmfzH+Zew9cwLuq1ycsHfA81zkCVXGCqtc4ZIrq2wDh9IZlEcjIfKa/S//QuA6k4/k0ZOjR7zqtE/MuWs+qSC99Q8SXHfjgraqQUf3qvETr1gZ6g0ubcFEKknEQHQ2xwg5CL5EajvCCt+UdFmS9qJw49COutYL+MhXW9eEi82d/+tR1O2KGlZFQ6ivuKn1wmLON7wpfZhQOAdpNl2j0uLK2G8LiY60fU8J19mW+enzDGRUQd31VKr5A8Ot0FhHxsE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 14 Aug 2026 07:54:13 -0700 SJ Park <sj@kernel.org> wrote:

> I think watermarks is bettert to be deprecated due to following reasons.  First
> of all, it stops monitoring.  It means the converged region age and addresses
> information is lost.  This is the biggest problem.  Secondly, we already have
> similar and better features including DAMOS quotas.  For your DAMON_RECLAIM use
> case, I'd suggest using it without watermarks but quota_mem_pressure_us.

While quota_mem_pressure_us may not be suitable for my use case, I
realize that DAMOS Quota does meet my needs - only proactively reclaims
memory when 'MemAvaialble <= 30%'.  I used it on my machine by
implementing DAMOS_QUOTA_AVAILABLE_MEM_BP, which can also be achieved
through the user_input of DAMOS Quota.

I think DAMOS Quota is indeed similar to and better than Watermarks.
The main drawback of DAMOS Quota at present is probably the lack of
wmarks.low like Watermarks, but this can be solved by adding a parameter,
which might be called fallback_value or some other better name.

Therefore, I agree that we should improve DAMOS Quota instead of
Watermarks, as it is indeed much better than Watermarks.

> 
> Hence I want to deprecate watermarks rather than improving it.  If we need a
> better watermarks, I think we should improve/extend alternatives like DAMOS
> quotas, or implement a new one.  But, we should first understand why we need a
> better watermarks.  You mentioned you want to use DAMOS watermarks with
> DAMON_RECLAIM on your laptop.  Could you further share why you want to use
> watermarks, and what was the problem?  You mentioned it was problematic due to
> page cache, and you implemented memAvailable based watermarks.  Why you use
> wateramrks?  How exactly the page cache usage becomes a problem for you?  Has
> the memAvaialble based one solved your problem? 

1. Why use Watermarks? And what was the problem?

I now understand why we do not need better Watermarks, so my answer is
based on my previous thought.

I used Watermarks primarily because it is the only mechanism I know for
stopping/running a Scheme.  The problem is it can only monitor MemFree.

2. How exactly the page cache becomes a problem for you?

After prolonged computer use, the page cache can become full.
DAMON_RECLAIM might then mistakenly assume there is slight memory
pressure and reclaim those cached pages.  Unnecessary page cache
reclamation can incur unnecessary overhead.

3. Has the MemAvailable based one solved your problem?

Yes, using MemAvailable as a watermarks/DAMOS Quota metric can avoid a
lot of unnecessary memory reclamation.

Best regards,
Rui Yan

