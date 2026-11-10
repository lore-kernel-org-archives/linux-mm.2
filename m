Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C658560A260C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Xe34Pdrc
Received: by kanga.kvack.org (Postfix)
	id E4BFD6B05B0; Tue, 10 Nov 2026 11:53:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFB2B6B05B1; Tue, 10 Nov 2026 11:53:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D393A6B05B2; Tue, 10 Nov 2026 11:53:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9FBA6B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:53:19 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5CBEC409F5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:53:19 +0000 (UTC)
X-FDA: 85419804918.03.E98CFD6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 715AA80004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:53:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Xe34Pdrc;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794329597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i2VJTtYw7p41+nbQfzio+hE0iHbWtKdnYrR8e4ZzrjQ=;
	b=35lSFSs4lk3xiuidkQsFPLsB2TVf7+faSB8ESumNNcmXqOoWktSbEXYI6LaPkqKGZR1SsC
	Eg0di3mt6LS6xYsr1mffkmMlneUN5uZ1HnFNAyI9h+TKXvO0EFVJT1pasg96qE1EuVlMPj
	0yVtb8xSHIJHob6zZ6x0HIXWu90Gf60=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Xe34Pdrc;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794329597;
	b=tZOhWOS5c5Zt3YyAgYVS3NFRKWnF1DIjsgTjbdFBidBtg5ce8GgyZTzLomyrhp6IdZXbAk
	wV0s+mm28ZIDrHMtejGK1E9hbrYzZuo/XLFt/ugmXJ5V+l8hkF2405IObEOSOjoWymQaRF
	l/CEsRqZp8+fOtN76G+4tTfAoKITTpQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B9151477;
	Tue, 10 Nov 2026 08:53:13 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3ACC3F85F;
	Tue, 10 Nov 2026 08:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794329596; bh=GKYJeH4RqLoW0npt46xF2JW0pmyqRHWIS4lSVGmTTLk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xe34Pdrcs5eclzRe8DMJrEqP7QHEqI+DtkZ3gnyOAg7F6rF0Xiw5kfgu4ab3VztSF
	 jFiJfejd7smBSDUHt/QND1knom/6Y1EEUnOrwv0lbN5Sh48Z/C4YFmV9rWZQaDwQ7d
	 HKB6i00WeQPP4tIsQIf15BcO38OAy9sNM0ITSV5c=
Date: Tue, 10 Nov 2026 16:53:13 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Weilin Tong <tongweilin@linux.alibaba.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: kmemleak: serialize disable-time cleanup
Message-ID: <avNL-a2YoZ3zqnoi@arm.com>
References: <cover.1793871596.git.tongweilin@linux.alibaba.com>
 <149d93f2cfe20d355f4d9882ce2bf99030217772.1793871596.git.tongweilin@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149d93f2cfe20d355f4d9882ce2bf99030217772.1793871596.git.tongweilin@linux.alibaba.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 715AA80004
X-Stat-Signature: tjqxrcb9ubpjc3hgwtyoxw1ntzgyqxfe
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794329597-847521
X-HE-Meta: U2FsdGVkX1+7782TGeF+0w0Z6mmRiml25Jo1WTfgJDjhAgseP+CDjEHhMrPUbY3cyEpMyNznSkQZ/03l7u+hwHIrtQTnWsHQZGF0NCFlZJidndhyxY6MdHQveOgAwWm65NThb5jcaSfUrO1wIypom6rNwqa7Aqb8NjZzIehvg4d6lr/j6eDmVTjpj5gqNGzr6/uACUayIyZdHeEGT3x6rLhFRt6ojYnXFaUh/9MmylBPBs9PL9BhEXh5bme/xVzBdFQdAsWrZs3Eg1orhzjGtS/MYyb5XuP6hxv0dlAR5D65OM0GS4JpEKfCQu7bFzIw99ftwur2jWPbWuiqXHbzj0LLt4UJmGvNH/b+desLCziQfPxxV+rpDutNKVgPfAAAKefc+AcPxDMOBRqL+tcgf/95Xmc0rrbi9fk62ANXPaUWRh4oAggisGhC9zWJUi2bN08QosTaQOCSNj61PYLFUPxWA8DU/LmpC29ILP53Os8LdhepwIj9pHZrVe+gtOWV5fNad5FMwZxf5yW+ktPrUfPnmKx8h+r+7HYGnA3+X1vGuMbakQ1TrE8htrfzSi2TKLgWf1KQT8Gc9r72wgJclEW9K6DiXodLOz/OxmaDlYZv/my/9PUoEkrIcgxI38L8/0I6zJKb0uhLse4lLJUYmZpIDyBPcnGasa0ThIochB4lMV9AFVczSdm4/3nsB7Bg3Ye8Le7TUl1BJ+M+Agui5H5SjxPGRntfjg+51auKbmpihfpSR9JiVwsfrqO/aKwCPNV6t/rd5oeINBBB/IxPozmTYrO3kmAMVIrKLDxcBBRKaaEIwiOG59IBMp/uxWi3l+3E4dnaA1gieIOnM+v0bvhGAbtZr3qq9LEKxrDZ1/DRe6YQK0kJ8wjNLtWPB5oFtL8p9dx44eYig1QQXjtufUxX5rmMT3/QO62P0j6HWwpRJ0gLI3RTLoW8OuxvnFaJXGihAnsz+YSyTRXrmi+
 grNon1R9
 DWt0M+f7wFu8DpEOdTtjC3UQdefMc8jqO4+Zn/0zXrbMYNs+O3B5vivK6U/L/A5oTfWgq6Cvh29jaWLAY+ocfF5PMknz4oPWig9rK0hkEqR2rwf6TmebHE+1kozb8OSeEQF3R76CE6plN5A8z0IBiEA+TkNDLw41i/7J6WrG1x5Ryh6ryV2E3C3IogqWpsmb9WA+rjwkr4Hr+4O3Mqm6JpD7s3EdZ1W8zrqIR6E1ONhkSfeA1sNwUKPO6fxHPSmVg5Cbvje5NYmJ/ivNK1gKD7Av5+uInaTcsNsLHh8WEI4yQy5Oi2shnfDbiCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 05:52:49PM +0800, Weilin Tong wrote:
> kmemleak_do_cleanup() drops scan_mutex before removing tracked objects
> without kmemleak_lock. A concurrent clear command can therefore start
> another cleanup while the background cleanup is still running.
> 
> Keep scan_mutex held until the background cleanup completes, serializing
> its lockless removals with explicit clearing and report readers.
> 
> Fixes: 2abd839aa7e6 ("kmemleak: Do not corrupt the object_list during clean-up")
> Assisted-by: LLM
> Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
> ---
>  mm/kmemleak.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 20c0eb41c..d959d11f6 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -2507,12 +2507,13 @@ static void kmemleak_do_cleanup(struct work_struct *work)
>  	 * function.
>  	 */
>  	kmemleak_free_enabled = 0;
> -	mutex_unlock(&scan_mutex);
>  
> +	/* Serialize the lockless cleanup with report readers. */
>  	if (!kmemleak_found_leaks)
>  		__kmemleak_do_cleanup();
>  	else
>  		pr_info("Kmemleak disabled without freeing internal data. Reclaim the memory with \"echo clear > /sys/kernel/debug/kmemleak\".\n");
> +	mutex_unlock(&scan_mutex);
>  }

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

-- 
Catalin

