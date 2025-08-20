Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F026CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008D58E003E; Wed, 20 Aug 2025 05:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23138E0002; Wed, 20 Aug 2025 05:20:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E394B8E003E; Wed, 20 Aug 2025 05:20:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D1A488E0002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:20:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38A8413871E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:20:21 +0000 (UTC)
X-FDA: 83796589842.09.B8F9EF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A3A96100008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:20:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CAAWiZLL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755681619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qm9a6vCCf4U6Ex72R79uDSmc/i9OPqDGXgysZ/9ztA8=;
	b=NL6hbThsVrVQSKZ5ajqN1IzlXdIQNgvuKJ69uqFs3w8f9iZ6/Wwg6jG0OaWmPeDVOYwKyC
	t3Lnsqsiox92Bkg4WzzlWZiM6FFlsx8NVlhJvd39lyapZorb/Q64vP/1KKrjFipubVhrXp
	/QUadJv+5e+J45mXHqttmtbhJvd4rds=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CAAWiZLL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755681619; a=rsa-sha256;
	cv=none;
	b=rFhYX2ChsYH16ssHRxiOPesR2KPhAw2TFlNifmrcPv/8xBm9uyD+JOI7y9QceS1j0bM33P
	opFyFMrIVdLBe5IQWnz1we3CfeQdR7JO8gkabwuUGT4ludqw8wlzgcZJo1u6TLYbiSgVGu
	dJn4HNPCyaQy/3O7Thld5IhHlcJ/J4k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E95BF6142E;
	Wed, 20 Aug 2025 09:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD27C4CEEB;
	Wed, 20 Aug 2025 09:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755681618;
	bh=Nl938A6iJK6CdtuEzfY9cpcmFgz8OpuOP7GsG6dKCOg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CAAWiZLLuG/fhxkWeWfHkjBqB++AaNSHLweBGuZodrxUvH6ox+e8OM0FPBmAY3Mi9
	 y+ay84T0sxd8wwQITOrIXvJDTFKw9B8XYisORKO3SD1y/EkzzjxCSmVw09zFFZC0/I
	 eOpcYMILUzpCDnMmkZibCZgn1BHxlZQvnlcO4zAhC0TJ2kP7aixdHG5qfCSU2WIERw
	 QXalWSW7YLhZ32iJ0PlLCtpfOeCZRXKahYZDfvx5v94NhCpEE6IWHqap81IQ5eLkmf
	 +MfpktHllLg4AMAfHb1QPf7ZTqkXAXU+c+c4bsc3BkGQlskl/nKWWLUtG9msgTAISB
	 liz+11mSpVgWw==
Date: Wed, 20 Aug 2025 12:20:10 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 1/4] mm/mm_init: use deferred_init_memmap_chunk() in
 deferred_grow_zone()
Message-ID: <aKWTSq-JcTviuGlU@kernel.org>
References: <20250818064615.505641-1-rppt@kernel.org>
 <20250818064615.505641-2-rppt@kernel.org>
 <20250819095223.ckjdsii4gc6u4nec@master>
 <aKRX9iIe8h9fFi9v@kernel.org>
 <20250819235158.mgei7l4yraheech4@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819235158.mgei7l4yraheech4@master>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A3A96100008
X-Stat-Signature: 7pnehbgi9tunfoqcdb7h133abojps78i
X-Rspam-User: 
X-HE-Tag: 1755681619-585842
X-HE-Meta: U2FsdGVkX1/CiEwEe4h1kKi8KSNC5E++P8bt0oLv0i49h1kflSaaeFrsL8itR68nJ07H3HXFrspsGFVNFfwoPtXy53ygmtflQyc5FSy1uCn2ddEEGza3/3I6bal3qEdB+fcqrFVp/klcFqrfUSV3ZvoOIZ163GzfDpmSZNgvon719senDAQY7a08nmh9DmNxNE4CdCE82H9uy6Hvew/G5lnrE4EQ28MLiZVvhMaB0QX3OfOGU0Y5Hj3L1IhrqKHdXGWuCLiB4fPp0VbzBiXgqmxB2qRWRWmi57eV1BVSe9LlgLsTM6VwsXKMfH1qgM4se8o1ftPWc8P85HNcNvRqanoSKtPAbBibnhBn1aAm5ZofAmlzMhxgLV6lU2DkUf7GGY8+n1VouI4Zem7IXCnBDWcbITuaZZ8aR/gUxlhRT+vlf9G3jBdUgB8DDyTLvZQOuf1gG1CMnlfwmnbB+exJA7zMBoj2Akg81h9ZHDfUQ5Nypp4c30MKO8P2cCqBh+Mb4d7SM142Vu75s96Y1ENVvs33W5Z0Gzz+y2RyjItfZCua5YgluFa4YM5TLAX128fnTp63Ym5p7l1hm5ERxriLpbKOTZVRDQOdpbX5S8Dn4uxZcVPiOPlNOJ1dIozcBKkYOmIA4hO1+kuXfm2Gojpf0TDcmrifFrhGX2opOXeWH7KxguyLfJYFosLcZjG8HUi5cmi9l7viSa8SRI6DRzPPnO2hZCoHss0DdsEtFEI6BMOCyLwSDLSV4cJL54tSBUo6t7Ul9Z/h5ETsdZMyzkTSLIWMY1/H2ioQwGQurQVDE5/9BSkMP+7Wto8hGooW8J7fyRt0l0AYao4kZBYjmXEupfVsOu3tqt08Td0TV+6LtKGd6DO+5azJLf42PGabDPm932qDGmrgIadQjPVqCKPPHiqbLHLwFiAdkgPdCZdIuCmt0ofOBdMFNqJa4riC0S9qtzJDCr2JzcFFmNXo5Gu
 7Elj95U/
 e8DXmZN6jTmEV2ri7QBswTLLzHixd+7gakzgmVwvc53GEruKRxOSD0zUmFyNfZOEukxXv4XWNK9TF3X/FrvdTWx5Nq2sPK2ox6xTyDP9EDtt+UdUV5PVwBdF87oD+JCBn19QGtAcDCsPIWvQO2mQrf1BP/IGOOC4EbTrAshww5f1yLyOZEqhZjGAGLoLAoUQY0PLmUIkVU92ALwALlnnr2fI9xjJWduAIcJwo7kocdrtqPHHOqIEDTJOH+2TVVRJ/dlR1uQblwP6hebfobkgsdFlTajgR+fzSSczEt3FDWS8iMnqTw6QQfvZBtZzDQ+PsXLsTd77/9BCirPv9L87hsw0IRO+nTndSVlqdgAbs8MXlwtRdLJG+4hBBDudBaYz+5kBg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 11:51:58PM +0000, Wei Yang wrote:
> On Tue, Aug 19, 2025 at 01:54:46PM +0300, Mike Rapoport wrote:
> >On Tue, Aug 19, 2025 at 09:52:23AM +0000, Wei Yang wrote:
> >> Hi, Mike
> >> 
> >> After going through the code again, I have some trivial thoughts to discuss
> >> with you. If not right, please let me know.
> >> 
> >> On Mon, Aug 18, 2025 at 09:46:12AM +0300, Mike Rapoport wrote:
> >> 
> >> In the file above this line, there is a compare between first_deferred_pfn and
> >> its original value after grab pgdat_resize_lock.
> >
> >Do you mean this one:
> >
> >	if (first_deferred_pfn != pgdat->first_deferred_pfn) {
> >		pgdat_resize_unlock(pgdat, &flags);
> >		return true;
> >	}
> > 
> 
> Yes.
> 
> I am thinking something like this:
> 
>  	if (first_deferred_pfn != pgdat->first_deferred_pfn || 
> 	    first_deferred_pfn == ULONG_MAX)
> 
> This means
> 
>   * someone else has grow zone before we grab the lock
>   * or the whole zone has already been initialized

deferred_grow_zone() can be called only before deferred_init_memmap(), so
it's very unlikely that a zone will be completely initialized here. We
start with at least one section with each deferred zone and every call to
deferred_grow_zone() adds a section.

And even if that was a case and first_deferred_pfn is ULONG_MAX, the loop
below will end immediately, so I don't think additional condition here
would be helpful.
 
> >> I am thinking to compare first_deferred_pfn with ULONG_MAX, as it compared in
> >> deferred_init_memmap(). This indicate this zone has already been initialized
> >> totally.
> >
> >It may be another CPU ran deferred_grow_zone() and won the race for resize
> >lock. Then pgdat->first_deferred_pfn will be larger than
> >first_deferred_pfn, but still not entire zone would be initialized.
> > 
> >> Current code guard this by spfn < zone_end_pfn(zone). Maybe a check ahead
> >> would be more clear?
> >
> >Not sure I follow you here. The check that we don't pass zone_end_pfn is
> >inside the loop for every section we initialize.
> > 
> 
> In case the zone has been initialized totally, first_deferred_pfn = ULONG_MAX.
> 
> Then we come to the loop with initial state:
> 
>     spfn = ULONG_MAX
>     epfn = 0 (which is wrap around)
> 
> And loop condition check (spfn < zone_end_pfn(zone)) is false, so the loop is
> skipped. This is how we handle a fully initialized zone now.
> 
> Would this be a little un-common?

Why? The important thing is (spfn < zone_end_pfn(zone)) is false, and I
think that's good enough.
 
> >> > 
> >> >-	/* If the zone is empty somebody else may have cleared out the zone */
> >> >-	if (!deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn,
> >> >-						 first_deferred_pfn)) {
> >> >-		pgdat->first_deferred_pfn = ULONG_MAX;
> >> >-		pgdat_resize_unlock(pgdat, &flags);
> >> >-		/* Retry only once. */
> >> >-		return first_deferred_pfn != ULONG_MAX;
> >> >+	/*
> >> >+	 * Initialize at least nr_pages_needed in section chunks.
> >> >+	 * If a section has less free memory than nr_pages_needed, the next
> >> >+	 * section will be also initalized.
> 
> Nit, one typo here. s/initalized/initialized/

Thanks, will fix.
 
-- 
Sincerely yours,
Mike.

