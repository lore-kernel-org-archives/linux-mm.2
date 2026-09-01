Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD82AC624CF
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 10:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21596B0118; Tue,  1 Sep 2026 06:35:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD0D26B011A; Tue,  1 Sep 2026 06:35:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC18A6B011B; Tue,  1 Sep 2026 06:35:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9C9F46B0118
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:35:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22ECB1202AD
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:35:27 +0000 (UTC)
X-FDA: 85164836694.22.AF0BDE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1F57E180005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:35:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oXuSImGD;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788258925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcCpSEftgA430RoM1FBDWtUuyGK8FaBAzL5tRn5s8zM=;
	b=coGYIAFRoWiIZE2oJix4pbyWTKPOrKcwP/lJrK+zRTwVbZhI9pAHseQ/fD06+v3nPk50DY
	dDEZIS5o3Qv92pj+/jNxkWDmqgUAi5E14pLr5NjIhODKlyRfr3Vme6xZC4OH2K1lvrq/OE
	bQfBRpC6gLRA5p0jvcFxykNhlL+3icI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oXuSImGD;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788258925;
	b=Ov8XJdP4Ts0OykO32J51ss/GNunM0quhXd79t4ZR/lwGLeMLcSVbVKniqGM4FqcNgjcSHI
	u78foWoTM2bCOAkd4Tim26MEoiytpoUA+kFBM2xIWTs8Van8mZLHlBZEI7nQyu6Tqad5St
	4MvzbSaMFtJcsTwrTn54GjEJKznmjaM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C44D41792;
	Tue,  1 Sep 2026 10:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539491F00A3E;
	Tue,  1 Sep 2026 10:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788258924;
	bh=vcCpSEftgA430RoM1FBDWtUuyGK8FaBAzL5tRn5s8zM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oXuSImGDshsC4cMw06Og+zCSkRUrxIotWKrIurPV2r5a//sQklqZqXJ2pQnRp/NGJ
	 eHpbL9vnBaHsA+RUhHdpCWd6M8gZJdYoSKuoco+SwglBa32xOOPPXWMOP48TsaBOql
	 3rLj2othD9ZBlqSH0QGklrOg3xCfjm/pE6hw52OPHWQpTjGXCbtxORz6TuuUj/1eRw
	 5eQX2nuIcnUF5oTCEOPUPf5pnnpXamchYWVRyryc/i1OccBRTask/gkmpD2KqsPaQj
	 +t2hE/0gwVxIPo/ifZCo1td+HYFneUJyROwonZEblR3RkcroOr9riQoERgEU13vAo0
	 F2kU2R3ymXfkQ==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id A5ACC1980070;
	Tue,  1 Sep 2026 06:35:20 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 01 Sep 2026 06:35:21 -0400
X-ME-Sender: <xms:aKqWagsNt5TTV4gNgXZv315Lf8cdhJW2t8g3ySjbdpuhAarRq_jl6Q>
    <xme:aKqWalA_Xq7_s3fbgnGzaZWx-otnKzHgXcPY1as0MbtgFyqa35LmwaEfrtGBb4Hbh
    OupnuQVrPdKjdQy5QGcEWiGgbnPSb34i4pXkjnw6poAYqrEFRBROLGW>
X-ME-Received: <xmr:aKqWarbfbcPjzbzfKU3pkfrtXQfEiRUzWDmJ1hxPJ0os5et-UQQn2RUlvZc>
X-ME-Proxy-Cause: dmFkZTFiNb433Q2Ib/Q2x5Tb/4fJV8R4aY9r3SmdNboMtRz6Yw9Dgi3VJue9v5So8a+3MX
    c8D5JOWRer9UtNw34dj/pFkuNTqEx574YOQuIJnWF1VTpPE1UxviOWyB/6xe9WD02Vwldw
    JlDOX17LoDRvA8e2NUMfZpnZMzDayPynx8l8SHwrlGTrs4F0UwLCyL9ROUV9+XC3gpMpMf
    /yFsNvsuUyH1amP65pfRfAGTMrIcTnRl8ZGqeI38P4WJ14uOAMw1z8CCC+CEk0eInXqQsC
    OdH8W6nIHpsooSUt7rkU6agVnxag7Ep7LfdC9ruY0VEnlLLkrKHevYBMy7v0U422JUJkr6
    ga7jPiK3xF2RTpK0L5Wp6bZN/7855JjuBlsxScXRS66u8fe0eSaw+Fs0dwqtQv1PY+2DaW
    Kh32s9Ae+8h4FerOMfa31kCiJT9bGNunOe8k6onHLb9vCWueohqLVm0dqGxa/wmqw1ZmCt
    gfXVfB8UmAh1iP5Q3JKn7YBFWGMczIi7l/6rEa6tDxQymL/IJwRLysGrn7Gs266djH4NaH
    rCOaPVYQ26pwBxQ31eB2DWmhTVnyj/DYVcMNCet/D8mtOaHcEJJ1uwzMeOKRcjToBWjOZK
    OJ9P52T/v+4Ml2vpzQ6FX1Iss19dPN7mKpHXv7uSue01Xm2m3Dlky+YB906Q
X-ME-Proxy: <xmx:aKqWav8jQbCBf0d0UbO-aeNLn7jzbvgdFa0O-lizsk8U2TkuGzjtMQ>
    <xmx:aKqWanj1ePc6ksqrncvGqdGffNYL0t-qljzEnBot__oZhMnP8JFBZg>
    <xmx:aKqWaiiSMEXjcRacLgnTDvj_3pWhpdSFxRh_9k22qkxdBaZ5nvm2BQ>
    <xmx:aKqWat5G2vtz8fwGPazKHNlBrNvQiPmivEKQCTs-_WcBJXUQT4sUjA>
    <xmx:aKqWakTsqQHhDVe1-YddCq2AA021DMF7cbP5ZdE14e9nKjgS7ImAxnP->
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Sep 2026 06:35:19 -0400 (EDT)
Date: Tue, 1 Sep 2026 11:35:18 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/gup_test: prevent overflow in GUP batch
 calculation
Message-ID: <apaqJk91uAN-zD66@thinkstation>
References: <20260901083452.115365-1-sarthak.sharma@arm.com>
 <20260901083452.115365-2-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901083452.115365-2-sarthak.sharma@arm.com>
X-Stat-Signature: c7pokoe85wqy5ooe6jid4mqpd71kft5q
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1F57E180005
X-Rspam-User: 
X-HE-Tag: 1788258924-67835
X-HE-Meta: U2FsdGVkX19ae3lrp9rg+a1u1hxloIFvRtgk76t1qd16rO+KECVGKCUtB8vzFbnh7ukOR7BjGzlB6i9wme01EDEFRkmdtpUHInUJ9snxfFStCVzblzV7x6JphgnqDOvoP4gP0/hcndA7ziNgqCXS3yXFX6lSw5bMF/2jh0wh80EZZNwLpljDG2IxPYlVaicG1cyV4ljh/mjNhP79Qcpy1VgPKafCuD2I05jnYkRTyocDCIyw3yeO3qFASTdmqU/ppvCZmcqKNYJX/fAGjXtwXWBvQr2qLU3rTihmqn995uZW1aPWIgbown1e90bPNCSE2fv9x3mUmPIuzbeZryGtJDwcLGilaPGX2ApM/QdVWkA/Za6Aw4YHwZx6giBvPS0jHtOBy4igK68PmIpdlCuG2pjoO89Zc2CSK6qNU4SEyVHocE8n6k6vVZHf7NbShY3MWZhZHan+0SuuY08jNQaCW2qNpLd39NgP8JDSxjtY+cbgeqMPcDZHG5AL+ExQBWpCDJ2rB9lp8b1tep54peaVGeYSaFSm1VLtn6TWV2DqUZzK4hDKgjGMVNibKp+uVUFJzPb4IpzZOoyooX+ZlfMiOST1sn+YolEcePWJQAurkwos5W9Gvbl8pur2AKreTRG6hCvYHvfH5mRp2dI2dLTUITiJRd58bqHW/XTmWhAafb/U0+yc7tNnf21E66zoYvhYsm8K3SPmFqd2zPcO18nAmLBjZ2QO6fnodmjhdyeX6Eyq7OBHNjsq2749K9mi/yH4p3DByGEnZJA2yS3d4xIShDUtuqgpmuZ7xVWVx5PHu6gBKlpQm4JOkwXRbRQd9MeeOKjgxQfYkvOp4IhtcC+As17oJ7e3TQVX2MPUfj2HeFXptES/sgjt4T90ZBZ4Q/QwTbX/1qUmOMlhXLuPQMVQdAFgC0ljC6fu+TmONCPSI1vus76cTrxyAK4gj4f1DzmrcHGpBSDUEdiUD6jMx5H
 wEvrON4d
 SidPOUwizAeEVVYD7/67/zlOVMBozdIKgTPhA1OizZeGrhU9Zypwjr2PfHIWJtjMd2cbAui9oM87g0DFLDCD0AnXJeNEtx+RM49M3/3EVPZKDHX+L2WLWMg6+DhoRiWYnL9rQeWNmyvbP59HLZmzQADuWOgBzzm8w6p2QR5HHOtenJAnWWPH/RUqOVa9ZVsO5NmBjqwQDKeuLCZ5N8XRTVuzOis5JB0T/Lc8zXo5D1J1xMExh07r5CUaFQ+tyaPGT7wSIK33Dc1hHeEOOf+rNbqj+GJ+mKtoKIL8SuEAGfhnUqDRdduAKgbwVIBJDapDGW/qs2MKwogUf7CHz5klD/hrIWnp2cMB+6L5nw5oU0nddCMRnYOq0zOXme8SwKcyH2N76
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 02:04:51PM +0530, Sarthak Sharma wrote:
> __gup_test_ioctl() calculates the end of a GUP batch using:
> 
> next = addr + nr * PAGE_SIZE;
> 
> If nr is too large, it can cause the next to overflow and wrap around.
> If it wraps, the next > end check is bypassed and a large value
> of nr is passed to the gup call, even though the pages array was
> allocated according to gup->size. This can lead to out of bounds writes.
> 
> Compare nr with the number of pages remaining before performing
> the multiplication. Clamp it to remaining range so that next does
> not overflow or exceed end.
> 
> Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---
>  mm/gup_test.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/gup_test.c b/mm/gup_test.c
> index 44c1cdfb9c37..910cbef709b4 100644
> --- a/mm/gup_test.c
> +++ b/mm/gup_test.c
> @@ -139,10 +139,11 @@ static int __gup_test_ioctl(unsigned int cmd,
>  		if (nr != gup->nr_pages_per_call)
>  			break;
>  
> -		next = addr + nr * PAGE_SIZE;
> -		if (next > end) {
> +		if (nr > (end - addr) / PAGE_SIZE) {
>  			next = end;
>  			nr = (next - addr) / PAGE_SIZE;
> +		} else {
> +			next = addr + nr * PAGE_SIZE;
>  		}
>  
>  		switch (cmd) {

What about this:

              nr = min(nr, (end - addr) / PAGE_SIZE);
              next = addr + nr * PAGE_SIZE;

Seems to be easier to follow, no?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

