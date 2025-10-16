Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D12ACCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 20:11:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98C748E002B; Thu, 16 Oct 2025 16:11:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963FA8E0002; Thu, 16 Oct 2025 16:11:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87A818E002B; Thu, 16 Oct 2025 16:11:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 795D58E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:11:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF76A47284
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:11:02 +0000 (UTC)
X-FDA: 84005071164.12.8D7C1B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 58F0540013
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:11:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y75nDUjd;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760645461; a=rsa-sha256;
	cv=none;
	b=Cc88lqbRRKucep4DvnEbOJUUFLQ0Ao9m5TH0YNe+5mrhK8EGtGGDByoe52kigGkCjiUvn0
	sPUCy55r2ApheotY9OMIi1wTiw0nYSX5LfPBtxfl/GGD8pOvtv6zYOaM9kiFx/CNcxoIGw
	tnAIO3t4s6edwi7Z5lDnd8e8t0/iPWw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y75nDUjd;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760645461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bU3K0yW+jv1iK/mPhuZC5FS5fgWbSBBOSYIxV8EYFAE=;
	b=uXtLqxtwsHvXgsVy17mBhPPJGR/BaR7vuPSD98kzuJxSe6CTxsD58pLyoPDzzEkr8IN3WZ
	cRfvsyXggP/iyCDCv2VqD/ki0C3QT9eb/PB6sKB/ot8IDH9NOGvI1WLjPSwdH13xisaJIW
	OH5W2j7lpsVewJYNHOZjH75UjB+j5Dk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6216F601A6;
	Thu, 16 Oct 2025 20:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E356AC4CEF1;
	Thu, 16 Oct 2025 20:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760645460;
	bh=DmixuYzuaZh+vDqNf8iPdkYboIVzZSEBrk3DHQ8wFQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y75nDUjd0IwxG53dgKRoCIDiU7AV4ZnxtAUXX5XiBhXIT/Do0a0KMhRdK3gZLQe/s
	 CrKjDZKsCCnP4vye/0V2OLYviivfQXSc4HkvMZRN0+9DPMt65KhQq0W163WDEdlyM/
	 el92QSTcIcFDAlHSgkivQvvZGMy2IKVKzaJQ3E6TBuL+mZPQSLi51povt7p+j4ftJu
	 ArE3h29lOK5fOBLFt8ukRBNyumw90ngOIx7QeijmN9lJO9Aq6sraLISkHMrH4oDB/i
	 12QTDM4Cfa4XKZvecGsifr6zyQsakt3ti98PbAhmZ/qu8KQ7EY3LZyqqQt85Y7D53U
	 jdJT0VUxA8F2Q==
From: SeongJae Park <sj@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/mm/page_owner_sort: add help option support
Date: Thu, 16 Oct 2025 13:10:51 -0700
Message-ID: <20251016201051.67097-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251016054927.138510-1-ye.liu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xmmg8tb9wtc3esd6cy4ppjjbinhnis5b
X-Rspamd-Queue-Id: 58F0540013
X-Rspamd-Server: rspam09
X-HE-Tag: 1760645461-672800
X-HE-Meta: U2FsdGVkX1+NG3LvtTxRaudedNuNAYVbAxvczmZfSJhR7/Kd7zBVTxU+Z60Njc7NB/+Zz5TWSpIJl7XC9LD6mXxchVLONWxTRhLzCT1tbeyHgoyrk12nJThK8lRTb+QmK6lGPXSLrdXgP4Uqovy6v1hQ7ZNjrGxwyKiC4hl8pcLvQwic7K4mJDhrJ8cxY1gWpH926xSTHUo6BfO6FYy+tK1yHE1clkaExuFypi2y0T6sE+KMfszdeXXsePhLAWrQxKVQAUKnnZ/9rSWqhjekiZyBS9hrMaKItPh8NNZe7NZhjX2SXcIwCajXhLlvJiwyPr2hVVyig0ZFeiZ55PqWtNW8kaSLaj2Vnomp+7AM5o/XUkN+dAV3mn60Xu0KhmfPb40Kouxe9o9kP1GnzbXv7YOX8NqZ336DERPHHrV4gX0Jtf4Ey5UYCzPJZ50eO2EuSijH0gAzrxQQt2IsXhiLfyq5clAOleMC1Lk4/s4lgoMHl+efDbnrUcuWZ2hSkOVyNkUiFZDmcmUVXmZQ96tQTLHYlPxmXiDTKSxe+iFvadzZuHJOByWnjtDz6ffECC7+F1p9wb5Fk4+7RkpEWFLgYn07cXvH+aAXyYTheAK4pFo2GH7PAxc1ccyqpDvdyBtMbv1zNNKevatDWX30Ge82GRs7PN5y3I0xSJMunE4yfjUAhhW4mX+jthVA2/RnmJcDsS+x6pl7VSEMVZePboxO9gAq8UvMDMnnxzf29RHLn54t9nWjEnZU1c9oVamf/OuSiZ0Svvkn7o6v0eKAFd1L7i0R7fH7J7uyttYay2Bdsl136E3QlKjprCxoOFN3PwOMRl22STesQZWaan4+S0R3cRa8rIPb6vyGW/+c6mCslXIjq/DOcKhkzGQyL8IbuoZFl4jCMrL7ZxyfricqamQTce8TQM1wkccFmO/aLXDisycbcx5nYaZFiCM6Zp8Lh5/0XQvtA0chLLipmELlEIq
 zNbK3SD1
 0OXP+8Y+TD2s4sxNY8utwgO4TQwbFGIXH4gBkNEXbbKbNiFlXNCLIa2DZ0UBPJ5JOscflVQrH43Cn0ZaXsP0qI5x9s0E27Rhv59uJADhPE06RaaMJOU9T+ZI7ZUWCBji4ixFwi9odPD/nyTCDZOS/LK7yfQiPIEZvo9QjaA3NpQAdtdFp/3zDFHcUrH9QMOaOUQZUiDCcE2OrZOUoaljEfxzEHW6hKLchxBPDsVM8P9Js3UvBTtmeKht018oxQ8uSZ37E8dz+UeFOB86+PaS9OYFv4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Oct 2025 13:49:25 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> Add -h/--help option to display usage information and improve code style.

Looks good to me, though I have a trivial comment below.

> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  tools/mm/page_owner_sort.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
> index 880e36df0c11..202eafed66a9 100644
> --- a/tools/mm/page_owner_sort.c
> +++ b/tools/mm/page_owner_sort.c
> @@ -669,14 +669,15 @@ int main(int argc, char **argv)
>  		{ "pid", required_argument, NULL, 1 },
>  		{ "tgid", required_argument, NULL, 2 },
>  		{ "name", required_argument, NULL, 3 },
> -		{ "cull",  required_argument, NULL, 4 },
> -		{ "sort",  required_argument, NULL, 5 },
> +		{ "cull", required_argument, NULL, 4 },
> +		{ "sort", required_argument, NULL, 5 },

Seems unnecessary changes.

> +		{ "help", no_argument, NULL, 'h' },
>  		{ 0, 0, 0, 0},
>  	};
>  
>  	compare_flag = COMP_NO_FLAG;
>  
> -	while ((opt = getopt_long(argc, argv, "admnpstP", longopts, NULL)) != -1)
> +	while ((opt = getopt_long(argc, argv, "admnpstPh", longopts, NULL)) != -1)
>  		switch (opt) {
>  		case 'a':
>  			compare_flag |= COMP_ALLOC;
> @@ -702,6 +703,9 @@ int main(int argc, char **argv)
>  		case 'n':
>  			compare_flag |= COMP_COMM;
>  			break;
> +		case 'h':
> +			usage();
> +			exit(0);
>  		case 1:
>  			filter = filter | FILTER_PID;
>  			fc.pids = parse_nums_list(optarg, &fc.pids_size);
> -- 
> 2.43.0

If you remove the unnecessary changes, please feel free to add below:

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

