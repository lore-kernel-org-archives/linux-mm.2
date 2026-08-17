Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 055ADC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 11:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8F5C6B00B8; Mon, 17 Aug 2026 07:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66EC6B00B9; Mon, 17 Aug 2026 07:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA35B6B00BA; Mon, 17 Aug 2026 07:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B73676B00B8
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:29:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4FD56A074D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:29:58 +0000 (UTC)
X-FDA: 85110542076.30.2AB75B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B8B6A18000C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:29:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ORlYguyd;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786966196;
	b=6lE6k4y6jyQ31rS1IfqNyKtV1rV88J4htjfMxBA+4DZa0wfB5KzU/LYQyN/WFLGeDhAQlH
	/U2xxGTdLdMLFTtMaf5yhB9UIrAvnCBKgi2VHyNBmox9F6bxmmGdvDB2QHc1khRQhoBune
	VCjE25sbSWNZd/ciTKbiCr56rrd/G8k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ORlYguyd;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786966196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wk6/msOLkPqq9kd6J2GOV67X9aJwFjjT0QFc8AOwr5I=;
	b=UHNtYbIE04LRoleuaspZMmQ2NuOhFkyXKMEXBcHO4JBGkuluYrkmdKJSmkW0KwI+a02/AX
	+s8mm+2hOZWjdWGoQJkZusmWT0jkcBX4rl0+jiYPRWw98HUp4vazwQ31FN6FHbgpyJdODw
	P0GSHCamCNCYW4XWbMg06kCw38TYkog=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC0F0601DE;
	Mon, 17 Aug 2026 11:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FAE1F00A3A;
	Mon, 17 Aug 2026 11:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786966195;
	bh=Wk6/msOLkPqq9kd6J2GOV67X9aJwFjjT0QFc8AOwr5I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ORlYguydCtGjM0ZGc6Q37mpzAF8U6ZpfF5KNK6tAUxrSoOhX10STX+1skMKZKDm5i
	 AGfIQVHAYoUq8epEvTMX+9yWs+FxIvy06zE61Q2ZlgEsH7qhw7uiMY5uXGyETfEijJ
	 q+yzVFoClbd+qo5oaaJmCQaFtpebVobItsUPgwf+3N2uqcvgQnklIRZaCYIZJykJri
	 cH/4BKJUQELV/aMGQv/o8En9kGTirvTnV/5PLtmZJ5y3WHsrfeyckejvXaIIt92Bo7
	 VtagPINO1BWPjZiN3XatD6BIh6SGwpnph88kJi+/xCohJC+5uSzVfItOfAm6hrI+Qo
	 9GSDpHINrfJXA==
Date: Mon, 17 Aug 2026 12:29:36 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>, 
	Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: Re: [PATCH] selftests/mm: Drop redundant open() in mprotect_tests()
Message-ID: <aoLvynyoJ9RKRIMk@lucifer>
References: <20260817080616.52946-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817080616.52946-1-hongfu.li@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B8B6A18000C
X-Stat-Signature: 4p71tosy5hcjsoixjrubpax331b53go7
X-HE-Tag: 1786966196-238048
X-HE-Meta: U2FsdGVkX197LSjeULyNlnMmpowvBLbGVtqe+FHAuOYr9GlDZzsFW6jJ6/Zs/IhRuUuFF+4VkOVFti4F5s8/KeJRqnK+XMnZOr9XyQgJ8zvRSkt9z56UuhlenHjmVjhw64nxoAWflkYfI/CqgxNxFmlbln2LDfq0+BQ08Yeoy3v3Vb+nIY3dozavYwd8T2vvA0fEC52/4WWhsI7K5nuogjFxP9k0RvD2XJ0RxatqtlhxvyXWLSCIjIFOir/yBdHiREkS6Ka0SNM/pt7a0t5X8mOY5NXqsgD9W1xOPp1aziuWMxSFStsdwCRVD5FCTZPyA9zl3oUXTJi4kwgkKS9NPhqVnI7I1BDDkd9LafI1YgHg2ZPrWUV6D7pm0bxnsuFBFPD8SxrgWwH3cbhwjRsQfxQr/sitotsHL7CVHAVKS8NQQA0LgPir04js9be2KHt2wmw2t/MLVFkw3D+B62urCVX0gvCMhm+1M9wOoYb5VkNrYgA2bh0RLEro5c12brkm5vK27gQ4fskbSqQ/t+2kUu7qNzA6JykfW7x5KECp0aLuq1I48PYopuJ9fPCkgWgjnpmJfz1AaHa8ATOJtt6Vl3Om1rtwrA2xIG2O+lyolw/CXZaGIZGXAi/Vzo6AGjRi7OkffeaYRscK1Sw7OMR0D93bgBBEnf880OuFnDdIj97sbxVz6QWbpSSboqV7k+2OGRtCRqhvIcbdzRQ5bOhO/JTP051MlqiPV9MIhZxvJTjdNe65SGKyTQY6vXBRCmeK4uowUQyssWPkkFELTP6jH2Eppz0iwij/jJSeEd2A3BpQfRyd94bXCYQffdXwiAc6HuwghWc/22i0zMH3SPoTCza/EcGopQiCWCzFqukMQnQhJ6hGb54N02fL54zJPBimZdxbzfHoJdq7d61GFYx2Xn9xAh41yMHV+gK22w8CbC8ucUKQSh2dgir7ar5eBTVWQyTRs3ulJGppT2t/UNw
 2Arzpx3c
 zpUmse9G3qacSz7L7dZlMPOGpU3VQqnUpJ2udVMHIRJ44vv4wCmQW4EsW21w9Rv8d2jpONfgLFVS+mZmJCUAu/U8U+LjryR+F66j1GQfz12HP5iHl9Trc3ETwSPEjONTXjWbtz1jiw8zw3cztcLixsCwX1Txe36Ou+LmzxhlPmU5z4rB2nkw/XSCuUk2SlaMF87AYAp5ePM56aV8VISEPn+Ha6S/DzMP7tFcOKsCDv0jRQ6mVgvF9dBkL1xg0Kc6r6DbdVhMmIHTMwbFOXETQ0hm5va9Yz8kXhxy5MykCcvcded8WDRLb4PaZ9dYjbXpwmkSr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Muhammad

On Mon, Aug 17, 2026 at 04:06:16PM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
>
> Remove duplicate open() for local pagemap_fd in mprotect_tests() that
> shadows the global pagemap_fd already opened in main(). The local fd
> is never used in the function.
>
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Hmm yeah it's not even closed either...

I'm assuming this was an error in the origianl tests, Muhammad - I'm
guessing some artifact of a previous approach or similar?

Anyway, LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/pagemap_ioctl.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
> index cfd1987339c1..eadc7159ca5b 100644
> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
> @@ -1332,12 +1332,6 @@ int mprotect_tests(void)
>  	int ret;
>  	char *mem, *mem2;
>  	struct page_region vec;
> -	int pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> -
> -	if (pagemap_fd < 0) {
> -		fprintf(stderr, "open() failed\n");
> -		exit(1);
> -	}
>
>  	/* 1. Map two pages */
>  	mem = mmap(0, 2 * page_size, PROT_READ|PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
> --
> 2.54.0
>

--
Cheers, Lorenzo

