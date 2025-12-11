Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D0D4D3E786
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 08:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758DE6B0005; Thu, 11 Dec 2025 03:32:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731976B0007; Thu, 11 Dec 2025 03:32:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66DB56B0008; Thu, 11 Dec 2025 03:32:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55FFB6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 03:32:27 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0AE0F1607DC
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:32:27 +0000 (UTC)
X-FDA: 84206523534.01.ABC914F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2049D100005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:32:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765441945; a=rsa-sha256;
	cv=none;
	b=h3oVknyDeNQjQ0YXjtbTgCb+3rRhZDHIvH9KBIMNBv+oE4H2s3M5KH/nH26BXg5mp6Ie8U
	3o8hKMFVydxVI4gHVHesKM/8AG0TkEzQNunC63PsOhYptuq/BzQPtVYnA0YeBMzxDDCdZg
	+twlBXxRpZkdfTgiQ9wyaok3khAOjZQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765441945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gFGKwQFZhAgj0vZg0JOnKWX4eBi96ftbchr15dmFnoU=;
	b=FnhuqtJWnznjY7DeRT2nNClhyxGdE6ghjXVazlYIpPsLDOwYhi6BYK0z9f5aEHms3TY36o
	C+MRlIjne6l3OZ/yVYP6IYJaVb3QvNEoL1YSQMC5nSqFbOKrGN4jXAOole5Xm08Rn6nPM+
	oiM5pJxVKIaeNR6GwUZ9F7Fsygo+Rq4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AC7BB153B;
	Thu, 11 Dec 2025 00:32:16 -0800 (PST)
Received: from [10.163.80.88] (unknown [10.163.80.88])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 80A7F3F73B;
	Thu, 11 Dec 2025 00:32:21 -0800 (PST)
Message-ID: <e896d23d-53ee-4fb6-8951-427d2210a0df@arm.com>
Date: Thu, 11 Dec 2025 14:02:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: zswap: delete unused acomp->is_sleepable
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251211025645.820517-1-hannes@cmpxchg.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251211025645.820517-1-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2049D100005
X-Stat-Signature: kxbfx8o8fh1mxaimdtz9116aq36p6o75
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765441944-158527
X-HE-Meta: U2FsdGVkX19v1iUSPrMRHEImuEVlbKCuARMRZrsNlTxzjneEoEzpH13DFQAtrun9+hrYbiHDTy5eCmtLHZuxw07IyZsDrlPMpajP+HQlO3yLkn8QjBpTiZS2Ui5HzWzBwhmtITY9AjnEhQikp2ufOS8IjccSbtlGH0CU1eV/bD9ImL81FKe5HiGnPhlxtGBaOIrhkvbrUOmhnHTOl+9mOKKbGwx6p1WGIgo8Rf2bzS8bTzRc+0Cjj/r80OBpmj9IBO8ZMOtTFuoKb26atSr+9TMI+Hr1SqvM0kOG38Uorr+r6T6TlAvxcPg4y6FPAidG/7ZQy5A56VUttgfNiT8gXcsq0hg4X7/BAeivuvTkxUY26PU+wfQSfcAhkREZUz3tSoRv01qZgjNPaWaVjNDDHc9aBg8yAI6ObHJr3hxwG4byKOTmcgzTO0Li/ncFcRJ6vKQK9TbVnBO17CevXlXNNTAnTFAffVEUeHSEczZtYKzPG1AAYsndqqOBfO0ACMlpE8ddWqueNG/1MujVghl2+Pu7vDplYMjs8fV4z4imG1m+JPZv0Xama1CZQMfjyttuh6eW9smEN4Wrbx91JOtipMehceGvGTjYyfVdpGt8rVL3y34n6xpQBkj+A85C38KvcXRSs+aMn8PDX0NCTaoCDHrVdFf3Ozk8Pkneo44yzDxeeT6CglvbSTwlgWEbc8WophPCwO3Nf9u7WmasCgbNAscUSPek/Xkr0GLIR1OxCaJTaD8gz+/CuUGU6ewuDN+zZdmf77QzoyDz/Zj4w/0H5cwnDDeVmW1ia5LeWU538j04HN38E7TkbNG/HKwNDZF+gq7Y88oZNcqDpzVuPe7wMXUibwci8s5shQNX8SbycgudA7/jId9gCDbkcOM0N+/LEAGU04/yavQEscHILmEJ2HuloG2enYaMps5tqgsG+3X1+YQ/XP3yebOAfDwUDTxR2iprPYh7Qfjn/NqNBNK
 +XhKpDof
 p83kwrbuUoWYo7r2XLnCPiU2CfP5KAiJ8Z1kOOmVdxTrb0PhOFKEPdZ6CW0G8D/YQNApW9iex3VrRDRid/rKDbQJuUc7SIcB5pS8YazC5faLNi8ozxOBZJtlk09B+1MOcE+n/1uHXw4idfKxVCq3weXgHxom1v6H6/xsS1KYHnt+ScFEgPceWljFBIbv+kvQ1CwArly4jLnm8nkOMNZCLQ8mVBe5cqN7tYFqHT4hx5+ssrkf4SbwRXlYLftbqc59sJ9XzMCf5Fg9op4KgpXKh+b6xgbBCooq7uuh0P7QkUml8vt7vyCVOFmGNfa0gROi34mLyTNLNvHd5p0hu+YnP+HPEKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/12/25 8:26 AM, Johannes Weiner wrote:
> This hasn't been used since 7d4c9629b74f ("mm: zswap: use object
> read/write APIs instead of object mapping APIs"). Drop it.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/zswap.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 5d0f8b13a958..84797ed4d3f5 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -141,7 +141,6 @@ struct crypto_acomp_ctx {
>  	struct crypto_wait wait;
>  	u8 *buffer;
>  	struct mutex mutex;
> -	bool is_sleepable;
>  };
>  
>  /*
> @@ -781,7 +780,6 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  
>  	acomp_ctx->buffer = buffer;
>  	acomp_ctx->acomp = acomp;
> -	acomp_ctx->is_sleepable = acomp_is_async(acomp);
>  	acomp_ctx->req = req;
>  	mutex_unlock(&acomp_ctx->mutex);
>  	return 0;


Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

