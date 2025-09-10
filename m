Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 349B0CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 00:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CCB98E0005; Tue,  9 Sep 2025 20:33:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D2A8E0001; Tue,  9 Sep 2025 20:33:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BA488E0005; Tue,  9 Sep 2025 20:33:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68B8D8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:33:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A6FE867FF
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:33:24 +0000 (UTC)
X-FDA: 83871466728.28.3E9D343
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9813F40004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:33:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=bZ+cfOkj
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757464402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7i6AL/giGG8sDoDggEW2tn65nUMUUOKofKssaLcy1w=;
	b=pXotNYZJScK8WdX3dzeJOnyUCIHGY8n/XKi1Pa3qDTjnosWszhrWvS+k+7VUqq39tcuuBP
	Cs++ZBPpVb5RVNRerUjqyKLr8qLuWa9O4TYceMsRUMTG9YvV7xP6wDIWqnJ7vd3FZ9QdKZ
	04Os8/aWOq9WgIYuaHqhhdNAfekyrX0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=bZ+cfOkj;
	spf=none (imf01.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757464402; a=rsa-sha256;
	cv=none;
	b=H0kXTRoLEZonromEXBQG4bQUqs6BhUDa0x9IEXVOyS/kTR5UK7frXcqODvNZpln8bxnnCD
	yYBmklLEWEEQKMJFmXUALFVgSSF33AZ1N/YVa0AkgyP0hmeSsGcaqEiw1gitGrLjEOP2Q0
	rUYIuY/lyxi1Z+wrvqLtm4xJoZMQz+8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=+7i6AL/giGG8sDoDggEW2tn65nUMUUOKofKssaLcy1w=; b=bZ+cfOkjVovEqOsNsAmbzO+jK3
	ZC+G754RaEYlFk7SYJTZu4IivuxnzmWpDq92c8U8z9pZT/sQOKtfHTlKqbSqt0HCu+b0VSx4WKc2x
	+bVpliaDB4NlawCwjgjl0bDWflR0IoIHGYPD0Qnf7EogwXtQx3zSpeow6CebBT5SkF8jfxtqLX8Bz
	ghXIvhvFmKBUDO5NX5OzFEQr0TMfd2KFwTD7iZ3oCPmDudEZyCf+zxHDMeWqNMkf+he5zk51h+eN3
	e+ODD2EaYuKh2EGsIG1BeqOAExdofpHYTBkhvDSasvKMu0BqJovXiJwl5GEdF47eUeq2WNnBSDlYs
	+DRsEQNg==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uw8lw-0000000BBNh-38jX;
	Wed, 10 Sep 2025 00:33:16 +0000
Message-ID: <1c79b3c7-5847-4960-9454-0c70d02a6441@infradead.org>
Date: Tue, 9 Sep 2025 17:33:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/7] kstate, test: add test module for testing kstate
 subsystem.
To: Andrey Ryabinin <arbn@yandex-team.com>, linux-kernel@vger.kernel.org
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>,
 James Gowans <jgowans@amazon.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Baoquan He
 <bhe@redhat.com>, kexec@lists.infradead.org,
 Pratyush Yadav <ptyadav@amazon.de>, Jason Gunthorpe <jgg@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 David Rientjes <rientjes@google.com>, Pratyush Yadav <pratyush@kernel.org>,
 Changyuan Lyu <changyuanl@google.com>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Chris Li <chrisl@kernel.org>, Ashish.Kalra@amd.com,
 William Tu <witu@nvidia.com>, David Matlack <dmatlack@google.com>
References: <20250909201446.13138-1-arbn@yandex-team.com>
 <20250909201446.13138-6-arbn@yandex-team.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250909201446.13138-6-arbn@yandex-team.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9813F40004
X-Stat-Signature: dmx8o5p75ccuug4157x7n7bbwjkq4g9y
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757464401-94827
X-HE-Meta: U2FsdGVkX1/2bOTqcyRglxL1nT3fiqxZWctZwI5G2h3njN1Qoq1pC4MSBHYFFaF3Dt4uFAoBShN+Jzc0pG3+aEJ++qVLSASAC3c8xAMJj2nrjSWcqOQdxI5K5CJuDR5+Leq3JqKN0ra0wG9QMbd1ellCsG2OAMtne5HnoT9qj+splFFMVltdDvaxJPzAdmuLQ56pVhU4y35StUALX2FeRKMKIg2NpDa9OJVq/R4eF0HKamwgGQ/Is4OsNagszl9H8I/T8ET8tocwG4nUsOpSpLDLcluIPGz9kfXPvHCqs/8wwLjSOfqju88d01UScz0WeEdNvvfp9+60vNwowRrAvEgKgHkA71k+lyYi9yad04oC2U3MrLI6jI5D3+JB1J3Ty6RDqL66ctFdhp5epRE9AD7f+q5Z8vI1dysL0GyaDLog+49ve3tkjob/g0nWia62RxNewFC/tm0GfSYOPtvxfKTwnXP/zq98mvcCq1eNM1BlWYsqY7Pa2zlRl+KbGF8rrTaiytw1xKZLMnBprzU/KPLPrdr+xieVHrPwwhhoVCRlq0ji5iiNJZlgiIVbTJySBt1uzTnkbG7czTQmakkV67F2Mubl7MddO9IoL/GCRFakbmP2+SYzoeLgVOK9OClSPtPJ+dOuytXog1MZKXvTZZ/3WDAFO5/kohVwGUKHx1axpg1GudhOLM7u22PbUTrUG80YDo72kTiT96mevZtTqbiSyAjmz9oAynt2XDA/8rtaiw+hFMzBpaqW+F15x3Pzw/xOxdLvGlJXKwA892ToMZyH0B4t0dk3gIsbIpgfEGqUMQgZ4Y0N7FwkhwnmHiTy0HKTRCISS3Toq0cJWTXaQYCK/eHrnY364BNAbBtLPx+ZQyC389HIMH6CaldI6g01Ynj+FHZe05aHm2NuQ6nRLox2EU40vFNWsVHGigWn6g5JM9H9W2RICE9n+783YFG+kwFym40bCQg7JqVWvF/
 uNaxGByT
 9vLHWKV481m7+HQG2nvHG/15SYZ9fJM+3A9qel73EdK0zqoNAJoVlWnX7758wZzVRBOBycBq5xEi2irkRtmANKjANgV2OtrsZSe+QhUjXWRqtlDAEZC73qq4wbTJENskw03wiJ9cOI8eNUV2ZBQHNuwMOJMMv6N+N8Sw2pvwpwIUDQ8oGosvE0tamOAz7ssmeoS38pbV2vbKmMxCwGK3Xp6m3RWos5ijdjvWchriUGwN92PQQE/U4x2ngPNCloIJbvmjmveqkTYs8aEpz3MJU9BBg/Fu5wiJTEs76
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/9/25 1:14 PM, Andrey Ryabinin wrote:
> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> index b6ea861006bf..af9a25bdcd6e 100644
> --- a/kernel/liveupdate/Kconfig
> +++ b/kernel/liveupdate/Kconfig
> @@ -69,6 +69,14 @@ config KSTATE
>  	  state, save it into the memory and restore the state after kexec
>  	  in new kernel.
>  
> +config KSTATE_TEST
> +	bool "KSTATE test code"
> +	help
> +	  Build a simple test/playground code that is useful for kstate

	  Build simple

> +	  subsystem development. It contains some structure with different

	                                          structures
?

> +	  kind of data which migrated across kexec to the new kernel

	  kinds        which are migrated

> +	  using KSTATE.
> +

-- 
~Randy


