Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 443CDC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 11:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13C2C6B008C; Fri, 28 Aug 2026 07:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C6176B0092; Fri, 28 Aug 2026 07:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF78D6B0095; Fri, 28 Aug 2026 07:38:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C91406B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:38:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6727B1602D5
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:38:35 +0000 (UTC)
X-FDA: 85150480590.18.2126637
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf31.hostedemail.com (Postfix) with ESMTP id BFEB620005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:38:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=NX3QjcS0;
	spf=pass (imf31.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787917113;
	b=GY9BzxjOxAwsA7atUCOztoOYzSkd7vsLw75c7xPOBJA+D4Xt14KFhjx8GndlzKky7JUEcX
	awQ3/1WH/IBTYxo8jqokEX3mT7vKZCwMQfuIFk+RZyMoLWSQ7fMCZMXVqNfehYAsODZsXB
	sa4fB77G+OdP4H6MhsiPeQJSr0GvBew=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787917113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mWvkv1gXixD35dUHWDVPL9AMqhXosTe2vU5Bagz9kRg=;
	b=X8XbPdxUyzeZmMeg2HsAg8e7jrGTF50hFn7S1S1pLQgQ5o69bn/dAWaPYDsFGFdlyeKg+g
	fiHCmzLYa07OqcwpPGyZu4k+9kXza7Afwwx1VYK7eun2mlHM2nISZO9cnOfUh0+rsCTY12
	tFbPzxhxSNt33hVQv33zqKwi7TJIXRs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=NX3QjcS0;
	spf=pass (imf31.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mWvkv1gXixD35dUHWDVPL9AMqhXosTe2vU5Bagz9kRg=; b=NX3QjcS0O4SGaZOva7cdBY44Wa
	P6A9dALxNoWTjzuFHufaCZdlPjA3g4pe72qxdtaHrApnZviRcWlSsXw2PAYiLYsHL87x1F102uoFU
	zvBuYZ2hPJmwaR2BPbUSX+hBaXoRrirk+E9eq+jfP0n1u1ZSg8Avyw3JED5Hq3dCHXYSkTD2DRv9h
	Xoe4yhLvd84o9ut90CmJ0w23otmAbQeB32aUULhyEJhIR72slYHYq8ywb1BILmIMTvbSnQ8RG/6jN
	wfYgCeZdbn3Q7CNWZkG2ERabClUno+OM1dmECeBEwZq1V5MricEXcfKFQY6BralhqNu2LiKkjUsAi
	iYpQsuZw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wzuul-00GkGk-0y;
	Fri, 28 Aug 2026 11:38:31 +0000
Date: Fri, 28 Aug 2026 04:38:27 -0700
From: Breno Leitao <leitao@debian.org>
To: Guillaume Morin <guillaume@morinfr.org>
Cc: linux-mm@kvack.org, rppt@kernel.org
Subject: Re: [PATCH] selftests/mm: hugetlb_madv_vs_map: add underflow test
Message-ID: <apFy8_4AnXJcfaHc@gmail.com>
References: <apB7UWfLAzCvSCss@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apB7UWfLAzCvSCss@bender.morinfr.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BFEB620005
X-Stat-Signature: yz7mdi85cuze7dmehu7uyfnx4e137p4r
X-HE-Tag: 1787917113-646573
X-HE-Meta: U2FsdGVkX1+JfXnPW1d/OFjLrKbSunwFnG0qn6Bf+B7T4+oEO8nLkfBao6jVfR274WPDO7DBnwxPpyz+OnMw8RNWxDooqOMBMYMslF6ZnvS+jkOR+R8/BopC3glUDzpvwvFEUUN3HFm34GqZ7mYVrm4NROG0D1ylgMI/qHRBKXmHxZxEM+0q9QPmmIREOnC53rnO/YSG9svY7j8dS0DBun43cVC8g0eumkpPEDb3sSNkSZ1pDRTKKSClDvMfjBelMmzUH1IOfNrrWsYueDqDEfMNpDallM4Neved+YHjbCLo7SDx5ucYoOx41NRBTi79D+LGnEDZSSb/dMkXCynS+jf1ZCyBO4XYtTgyXqic6UXx81PjDdeHPdCwD7+q7Jp+mkaoBZUGOCg+TGGqasVgTJGFZ0KeguLq03zVV1cNC0JrCwQW9kaOOI7yRH2hlL9edRbfvbNqx5z6XTeyC4OYlKVc2qoM3Pyg17Xc1J85t0AXHCXlQHGPV44PXHUKlJGYk1JyvqWP+NpBp79wl27lLPfDcBQ/NrKH2Xx4yJkEiQsEkHlZx6C9MJCU3PYqLQPfnTX4tbA4soGldhemO5V9Ox2qgAk5W5AgHOdx7uuvOexniOq7pEUONqKzUg0YdJ0sY3GJvtAjobrzEBEomEukEW0FmaPoL/44EyZ7sFQf1P2jnY7+zFb701fajoc37qCPMcbC7zPQwsrphIOlcp4Y8TsAOpxmXpBpgxgphu4Bfl5G+u/h6TgzmIkjF8b/HicyUOZUSS11YrSxH6QLRaOjyOb9ujomvft/oURsendeIPzTsGb09I3748+WaKFD8TGHIRd99CVeWCGxK3cF1PcvbAuL6/FsKpI5HpCUw5ahigWAQgTS1YRhJ411HZtCDyTKA4ucnxmxc6aWpIKS3wYlkwc6G/4U7sZzu/3+Ngej49FlKTB7GmVpJ4Bhn0/fELTxfeXhSjH2QWjQXkr3s4o
 dngErtlJ
 DxZWHY3GOp/SCQ1jN2G5tjrqEwoWbA/voRvPLSsucdg4fVmUPzLs2fhUZ8d+XPTiG3Oc68tFJ15ITHfqDha0QiHnlnH7PUVs9glK1b49huva+ur+xN8aIKVD7ChfKSa9PdWQpXycwcYH1blA9EuwrqE5AGgsvmH4+9FS3Drox9xIEmNHX0ACZ3iJ8pN/36irxzMpsDootmY3WY3zd9B7jZes7YGndobnKmBmeYObav8zZvB7eSixUmDLLrCRildJ5nDeBgC36GmguwocNE29K1+zcOKfrvbaT5w61k5Lxkvnx48s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 08:00:49PM +0200, Guillaume Morin wrote:
> @@ -120,5 +127,80 @@ int main(void)
>  	}
>  
>  	ksft_test_result_pass("No unexpected huge page allocations\n");
> +	huge_ptr = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
> +			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
> +
> +	if ((unsigned long)huge_ptr == -1)
> +		ksft_exit_fail_msg("Failed to allocate huge page\n");
> +
> +	{
> +		pid_t pid;
> +		int pipe_fds[2];
> +		unsigned long nr_reserved = 0;

Why do you want to start a C block "{" here? That looks like a bit
weird. 

Also, please factor our this new code.

Thanks for the new test,
--breno

