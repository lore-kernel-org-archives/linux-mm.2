Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4AFCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 16:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E087E9001A5; Thu, 14 Aug 2025 12:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB964900172; Thu, 14 Aug 2025 12:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA8979001A5; Thu, 14 Aug 2025 12:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B39D4900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:24:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 640CE1A0742
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:24:52 +0000 (UTC)
X-FDA: 83775886824.27.02453BB
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf26.hostedemail.com (Postfix) with ESMTP id 67E58140012
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:24:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="a/SCaoyo";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755188690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=daL1ydrlIa2uJjdib/75Q05PSAxoGggNa+MCdc76D4g=;
	b=ttqvgDJE9o8YCpHffIzBxQoscMwujI3HUdiSfBA9+QfgS0+F/di2fDcyhLCD0dBXwWVxJc
	mGVYavNSGOsQuTjgeC6+2SltHNvGiTrAztNUpX0RM1TucNbvSbS4VnS9GFVCXTjlSbBnCB
	67y91VloEbenAXVfZmNE7BBVG1iwIDc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755188690; a=rsa-sha256;
	cv=none;
	b=Zav02ZIi0kwn7gdiJb8Z98Rwfr7x+/YVh/W6Ja5W/5LQ4mj2prvLhjOB+nXiiIMTI4xmaI
	tKV2T35a8OPQr/9095g/5q++MHcFbyq7VanLc+Mt+hg9TM38N+2kibKaI76gvY/6R56iKA
	smxHTeJyBlSbwVWjCMkWgL17oZ9oqD4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="a/SCaoyo";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 3B7F15C63E7;
	Thu, 14 Aug 2025 16:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA653C4CEED;
	Thu, 14 Aug 2025 16:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755188688;
	bh=/90Iz8vIooGO4iCtEcpK2bvDlLQw9crMvQb8eGHP9hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/SCaoyohj7uAQ7Iach6v/htYHMaejdrTKYIDnnI0wmUitztRMj/XZuoAXteiL4zM
	 ImqrFe2UmxWjTtyNdsT4l832yJ54+O9qZpT5LIzOyOPcOe1XDwwZZLtqHq21c15kTI
	 FHvysF/jUVh2pIc2GkjO484NGWW2iLg8ee4+5+CNOLa/antE/1Hnv6jYFyHgu1ZBAp
	 RB8eU+PXbLXXXsWFXtlxJ3+bblt0poVl3ayDO7pJ0oCFx9a4FwXgc+xHWqIerNw3ZF
	 0XwuC6oGvfEPLB2Zp5z2qRFcQ5668C3vDHmXIRezYiQFMZ2U+es6p6njZHCvKKBfBS
	 7zA7I9opp5Sjw==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH] mm/damon/Kconfig: enforce DAMON_STAT when DAMON_STAT_ENABLED_DEFAULT is selected
Date: Thu, 14 Aug 2025 09:24:46 -0700
Message-Id: <20250814162446.69575-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250814121703.648925-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 67E58140012
X-Stat-Signature: pe3pb9z98o7xq1ekef1ta36q76j1ytj7
X-Rspam-User: 
X-HE-Tag: 1755188690-743756
X-HE-Meta: U2FsdGVkX1/amB3+8Jzz8ro3sgWG9Fo6oSUhkwPGEl+Rkud4k2L3j7comrD9BMmtgKxKekXofoYcZobbiMveO/10hVO3qCv4E6cEHmIPkqD4shK8G5R6txjg/4h+dDNh2LID6S4+8rmgJGBtsJzDhNNnOqWa22YDG+tHxi5xNnsQOuAVsLnGskSkgA8HPsdYF5SfufS+Fh3MIU9SezwsYOkz/FikUc+XcdykfL6+lDmu4yK6wF0jUVFwqUA4RMlotZxwX1MOJsZ6Yn9F0FhoHhH6O3hdD7AZXYhq6uSrbhbQkAzLc7QuztCyF5JIxITDOv5DtXUQcQ2jrqUv/hgBUuiso/eH/Chxg+qmPIxs+kXLA303ZV911tCWMkd8U8CisT8Ni5Mm6jjsDvBkb4bAAnIE1Jk/1QCT+YfnUnvnyXWJlKqaMa1853OX3hERMYLGGuEyUEw/Lroh5+HgsNKA+6heINbxhlU6C28trVeCD/nE3SLo1icfvQiCkGhsaP7E4dWrKoPXMt8anAm7ikXbefmVyJSnequnZ+m4XSCwFkSvKOJG0OVuPdz7zd6+Q08k1j8NNB85MpabNcHrklzVZDrSTgFJUCw1wsilTfTceBSM6FCLK7GV8bdW47PlGMoZrAOrMtjYga9W7l0Q7njYSsUgo2u6OxUKFg+i88gTgvwI9RBLY9xEWmg42BFh20piFEAyX7/aT1DgGnCftEglLqI5SQseRHEnyOlqnLuwFF8T8SZzRt+B8InXeugi/OaLVdatiZzG/IOL0yZPcOCxPZwQdpJ42Yr68XaGj52w7bwqm1W/MPedYOQzh8gTFdt2fc0XrrogL+rG725DO/W0Z3sgvn4AzAad9+BInG3ewqqH65Qvc2lLpSbbxbq+xkerwjzsPc+4x6QALZ5PaYqWv+CLxeCgMhdT8s9pmGeWj5BN5+l9+Hk7vWXxqf1pSbDUy4JhyGh4zMmJHzv0Kdc
 QnI/2MY8
 65tZaSfkd+MwBC1YVQiIP0Bo6tkR5Pkxoeuvc2U38yQNZqj+WA3Ictoz6/UlmsmlU6zGwc0QhRPIh23XUm8lq3UqKFr+Pr09favKNSROG5t2t3vdRR15sRJaydh/a3H7HUu2EYvflnnpNgDLEllyVP9TeEHtrJtzxuBZU1K+qZwOWpONf4eRKizEjXD4APdrDNxzqKpZeS479azJE1RE+pKpOh3VNRgAYUhMaBIUqL9hnoMdtwQFcmWfAxlimm6zPY9JUi+S+oFvWFtlkPDZgfoxqE68L8i7f42SC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Enze,

On Thu, 14 Aug 2025 20:17:03 +0800 Enze Li <lienze@kylinos.cn> wrote:

> The DAMON_STAT_ENABLED_DEFAULT option is strongly tied to
> DAMON_STAT -- enabling it alone is meaningless.

Nice catch, thank you Enze!

> This patch modifies the
> logic to automatically enable DAMON_STAT whenever
> DAMON_STAT_ENABLED_DEFAULT is selected, ensuring functional consistency.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>
> ---
>  mm/damon/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
> index b3171f9406c1..5bc71354e6f3 100644
> --- a/mm/damon/Kconfig
> +++ b/mm/damon/Kconfig
> @@ -105,7 +105,7 @@ config DAMON_STAT
>  config DAMON_STAT_ENABLED_DEFAULT
>  	bool "Enable DAMON_STAT by default"
>  	depends on DAMON_PADDR
> -	default DAMON_STAT
> +	select DAMON_STAT

I don't think we need to drop 'default DAMON_STAT', though.

To me, it seems the problem is the wrong dependency.  What about making
DAMON_STAT_ENABLED_DEFAULT depends on DAMON_STAT, like below?

"""
diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index ecbdb3e2ae58..d5f8db812dd3 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -104,7 +104,7 @@ config DAMON_STAT

 config DAMON_STAT_ENABLED_DEFAULT
        bool "Enable DAMON_STAT by default"
-       depends on DAMON_PADDR
+       depends on DAMON_STAT
        default DAMON_STAT
        help
          Whether to enable DAMON_STAT by default.  Users can disable it in
"""

Also, the subject sounds like a bit strong tone ("enforce").  How about

"mm/damon/Kconfig: make DAMON_STAT_ENABLED_DEFAULT depends on DAMON_STAT" ?

>  	help
>  	  Whether to enable DAMON_STAT by default.  Users can disable it in
>  	  boot or runtime using its 'enabled' parameter.
> 
> base-commit: 0cc53520e68bea7fb80fdc6bdf8d226d1b6a98d9
> -- 
> 2.43.0


Thanks,
SJ

