Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67494C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:12:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 293896B0163; Tue, 18 Aug 2026 05:12:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 244B56B0166; Tue, 18 Aug 2026 05:12:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134156B0167; Tue, 18 Aug 2026 05:12:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC7BC6B0163
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:12:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 69A1F40B33
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:12:04 +0000 (UTC)
X-FDA: 85113823368.13.37457BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id CD6AC120003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:12:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FSHHqjX1;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787044322;
	b=3kpcRErO4+VBGr/TkMx1rMj6E9bz30rRM8ZI1c7JKWBiNhElHTB1tK/fxQ/X/cEAAtwxkp
	cknNhTaQ0ABEG7kwrBXch2cLTzs8t1hkxWO0HPtWecTrG/P6qsLZgOIdKGb8of4q0MYpK/
	ryLTJwoAJn0HHgOEZWvItyqqYNME6tk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FSHHqjX1;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787044322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BclwZjJy/b/hd4HsLT9ylg+oFGDYStXss7i8/P8OB1E=;
	b=KqoR/hhPJvk3/3ciTTy4ZUCxHNtqnjP+S06K0U7xEUyuebbjwCESWkQQiUC7XOUccjMuyZ
	wWs2gcXv9VApxjxkUaTTmtkey/SQIZzmfb6KvHCxDhIc2BvYyNM1gTsOKQDD1gb8jNW+V+
	a5wGFCG1rZA+3MVpiyj/50bnPxYUBvA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B029E601DE;
	Tue, 18 Aug 2026 09:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D0E1F000E9;
	Tue, 18 Aug 2026 09:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787044321;
	bh=BclwZjJy/b/hd4HsLT9ylg+oFGDYStXss7i8/P8OB1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FSHHqjX1A3kmPL6OA5NK7FhO/kc0UXcu2qV4JqvQ8kaIvCBFhbv2rMpsn+YGxL58b
	 iUGfsIZ9xvwlz+3y9TGSYH/iXvCEZQO1baf7k/I4YE2GUV5vTCQMxfPyXLHGglvaAE
	 42/Zcr9ygLkaOdWepPzploaAJbS+U8LFTkcqR7F1qBOpAXEKKmc93+jKUs/2K9mGMm
	 w/4B/abZukMeiZxO5S3LPdpM190H1C0OsNvdwyjPvNZ6/o23rISFtqFwCSMCRCabQE
	 G7LK1+dd/4EhZD0Z+tfLwOU/wdY52so2/2kM8UYks17+3e6qPoqyKFec/dE6lB0E83
	 JQzhisgz0UN7A==
Date: Tue, 18 Aug 2026 10:11:40 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kas@kernel.org
Subject: Re: [PATCH v4 01/19] selftests/mm: raise the khugepaged test-case cap
Message-ID: <aoQhxXxatSHKEknn@lucifer>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-2-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815015901.1236937-2-kirill@shutemov.name>
X-Rspamd-Queue-Id: CD6AC120003
X-Rspam-User: 
X-Stat-Signature: 9wpfuoiwcttjbksbjryybj5tm9ac367e
X-Rspamd-Server: rspam06
X-HE-Tag: 1787044322-766425
X-HE-Meta: U2FsdGVkX18FWEuaJjzmHSvSu3V6JwIotOB1lYr4pjc1pImzAbVADwsAyndUdOLJCkM5kFOvkft8inD+qancB01M/NicY8uwNB+hn0RnmmkRxmwAHbKTkm+q1qrX1tt4s7vybbEFA/XlxkasJ/tKDEV8vARhimcNZc+o0Hm7AQFNuArDOPRrX1FHGJgYJXrskc/StZtU4DtrIrsl/9++MNPEryMxBDF7C9jeSkAy7p1sh0oTnEaaeqK1zF/r9czrVLirhroCp1l+szYA3mBsXUQtYsWzc3wlGQ2kCCgEnh1T9tRFaAmMhTqrjjmSlmDmdp5CB/S9AzvuBPnWg53JOaP/+azvav/4evG9s87/XHI9Wbl0EBY+PRU77noCpmKdrdlr1vciBrq4D2/Lr0I1eP5o4DqfT+AJpJ8QB2Ml1vIbWlLJmHEPoBAbpGmDp1L/wAxh9THywQo2cdNUlJX453XmyRwjOBcECHbJnfEXBPxyYnRPT5t0iDizf251+vYrxr/Etgg7iED4Pljp2fWQgNe7HmfCx/rA6aY2vbCyDZzzfKiO/HOJzHCD5gYW3B0m0TErMon0cy1pHMBX3AsVCiYjjX3y5GBiS7aB3K+lawJWHi2bX1IGJbUDulC0gCQlfUhWJR5sh91DZID8cxxF6oHHX8sLMAO2MdNL0AMxNEUOvJEvLj2IWb7Ej/DkJTByJLFyU2dcWgzoqHw4z0dsz7pso6Cf6sMUI9Lu3SwIQd//vZeqLMOiK6J/Ffkoc0BAdOPSQyBVv6nRmAJ1oWipuNw94WPRXtuXVkQr2yxZ0L2tF6f8Kh2nRSyIijSmYFbhihr3f8H8wX6W27nDXImd+HjG91EKsfRD32NIMQ85W76XryuNXdawEFxL0Qv/EvZwzrV4qRk+XC4jHzc7zi+rEsOK0AZkMNNQaPIZCBBdHmE17OZ3fnEYjx6e8IN3BUPSvqn5y/ZnhOSNa1SHTET
 azgXFRQG
 lh7oOIYp6wPZbKKRCJXDZ/u6YTZdjiDoE4dOcUbISJQAfUsUGIYM0p3q/D+sZSXj2L8g7XUURQa5sJvD5mzGUa4FAfP+SEtp3z7JRJVRkDFIlpFBzv95TCZP2tgr8vXRaVx1lixOmNkjFsYDx1lyFztIBxSezQZBYRTEZ/sVbn9xaWFPlxHz9SwBN0yYIqbN+kHvumyxTnX3LqnDWb25HOmDenC/ruzgFf6OlXSvqBKSerG8kxjCwvZAXpXnrOTNzFRjM8ekrMS8RxJpGK/Ke+MvotpPaTzK6JvBiOqA4/HOJ40zFd7rnETOCbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 02:58:43AM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> TEST() ends the run with "MAX_TEST_CASES is too small" when the table
> fills, and the table holds 64.  A full invocation already registers 63, so
> the next case added anywhere aborts the whole suite before a single test
> runs.
>
> Raise the cap to 256.  The table is a static array of small structs, so the
> room costs nothing worth counting.
>
> Assisted-by: Claude-Code:claude-opus-5
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/khugepaged.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index d3a53673e1f9..6cfec2b940ac 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -1290,7 +1290,7 @@ struct test_case {
>  	test_fn fn;
>  };
>
> -#define MAX_TEST_CASES 64
> +#define MAX_TEST_CASES 256
>  static struct test_case test_cases[MAX_TEST_CASES];
>  static int nr_test_cases;
>
> --
> 2.54.0
>

--
Cheers, Lorenzo

