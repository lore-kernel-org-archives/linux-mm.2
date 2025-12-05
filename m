Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6437CD2F7CC
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 10:15:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC7EB6B0127; Fri,  5 Dec 2025 05:15:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78956B014D; Fri,  5 Dec 2025 05:15:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8E316B014E; Fri,  5 Dec 2025 05:15:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 916D56B0127
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 05:15:44 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 09EC25930F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 10:15:44 +0000 (UTC)
X-FDA: 84185011008.05.7AECF2B
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf17.hostedemail.com (Postfix) with ESMTP id CB90140005
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 10:15:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764929742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wPVkxjSKwXrWKwhm0njnWtOWl8v517bZpAW2zk4b3Ag=;
	b=UnvnR0qR63htDCGooUXuJ/xBI5HR1vYWw0Y5Ae4YADRIrdoXmOTFnZhq5SFM3EtGz9wDjO
	7FbRBDttLRZY2QOuR3qlHSr4VfOHOkr7PKJufOvfEJQNb7YvGMgZuEIfzZQZfsoCSKAc+j
	UNJKlP7Pm4h8g1soEfTFgeg9y4SjfJ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764929742; a=rsa-sha256;
	cv=none;
	b=0DizJG7sRd+ewctKqm9FSQtwAV5asbXX37Lm2vxE68TLpkbWAftCMKxYP7umUITrkhsxqO
	L8B5ywDQ4PcOPfpn9xqyLAF/ifhhCSXmpZKjC5UIFK6UpMPAGqgliRhBXslAXLHB+9hESs
	XvDDeq04bOmJF4/kD+dndNkjcGJjHGY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
X-UUID: 535366cad1c311f0a38c85956e01ac42-20251205
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:955f59a5-3b4b-429d-bd7a-dea09183ef29,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:955f59a5-3b4b-429d-bd7a-dea09183ef29,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:8a994e7d01d71d9bcc814bd90862e641,BulkI
	D:251205181532NSGTDAPV,BulkQuantity:0,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:
	nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR
	:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 535366cad1c311f0a38c85956e01ac42-20251205
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.160.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1541234963; Fri, 05 Dec 2025 18:15:29 +0800
From: Enze Li <lienze@kylinos.cn>
To: Jung-JaeJoon <rgbi3307@gmail.com>
Cc: sj@kernel.org,  damon@lists.linux.dev,  linux-mm@kvack.org,
  rgbi3307@naver.com, enze.li@gmx.com
Subject: Re: [PATCH v2] mm/damon/stat: deduplicate intervals_goal setup in
 damon_stat_build_ctx()
In-Reply-To: <20251203080440.16096-1-rgbi3307@gmail.com> (Jung-JaeJoon's
	message of "Wed, 3 Dec 2025 17:04:33 +0900")
References: <20251203080440.16096-1-rgbi3307@gmail.com>
Date: Fri, 05 Dec 2025 18:15:24 +0800
Message-ID: <875xal44lf.fsf@>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CB90140005
X-Stat-Signature: k4fbcwm8y3wd93jsn9nkjnu9fdad68q8
X-Rspam-User: 
X-HE-Tag: 1764929740-394690
X-HE-Meta: U2FsdGVkX19nOtL85cgOQdAVWq5shMFug5x/hutydpkOqbRyGPwTXYk130HHg1cU7RdvnRyMp78xT09nLnYj+9pFawQqtrHuZMVZMXe1PO9h9BMjS5rtzobazSK2WXe1ijF7Vq/o8sK+tcTvJVkMLUnBFOnWb+xdYLpo9PL1VJwn/3v9mtjd9wmJFbX/iOtEJehuNbjyeiyPwbnNcDlQFfiBOQtQ2SF4lwjKYMl5YkRM4w3TZ5Mu+P4YRo4/z+9OIZ4MnGVR5yqs5OzstsvzWoHL+m1jZ7JdY1DJRRQKsGzXJ4rrIX6g7nzJxeSdUDToqecIlflDX5zeimvoMHS3XIBW0W3hXZkrSmtJNQVBJwgzYfhhUs+QN/VVIYdIlyxlZrCpg/4t4/CHOz9U/tXV+bk5TgQMN4nlAYrDFEGf6BEHD8YbaJo24vhkTuwBDdT0j6JpBcrkBDtdsmFEgR/2uRKxIsBGrlrxBwIGqdpVme6R2eZzXMKNCQRlIpLDrQOc0MSUlqTeudMlmPuL//O3XU6B1guQ0DYoTm+qsRZZ71H8332Z6AgyXnMFEArhQSFpLvJ8qH9B9jbNKKqb9RXzu1kbtJ/22j/tepOoAxxzb4wE8pAXE386uLJWjfSdKyt0fLBMK+KbHcXyX9UjAqltQPRUBS+JD0HWCnZyU9+/ydDD3Ptzv9Vl73QPM+RemYYbtJCbsnQ40y/E2YlX4t+Ntu9fPSJRn03/vJ0GuMQ7UKdxGyxUeRn9tMZPVN2hJBO0dC6Rc3LSWGD+EgL0y6He4cbg9MifX0dNfYs6hkBTYW7dO9EHUK0aclikz9oZUGW6huHxfpYbn70926c9dG0Ys+JxFy/sMU+QN9YatX64ueF01VpzrJDj/NMYbaoleo/oazdQdHz2/Y/9pMDC2re3tUHvURlS85fhvCHEjtx/fa99Q+3cJPMgmB1BEUd3r0r8nuBIh6w40qTYEgY9tIj
 IuxXKB8s
 u3a86lSku9/+H9OTDTGKzETe9ZHsxv/62oTAuvXcbQASlNEKhxdLg5cm6oNoI5lu8gS0Q/XRajhapEnwKwxxuthB3iItkSGwcP1Vq1FgIJ2jMhjxOLtqhszkYxvwXP0FrwDBUadmzG9E+hHSvs3LjU+QBR1CpRtNm246ZKVJhVwCAkGg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello JaeJoon,

Thanks for your patch!  I've a trivial comment inline, see below.

On Wed, Dec 03 2025 at 05:04:33 PM +0900, Jung-JaeJoon wrote:

> The damon_stat_build_ctx() function sets the values
> of attrs.intervals_goal structure members.
> These values are applied to damon_ctx in damon_set_attrs().
> However, It is resetting the values that were already applied previously
> to the same values.
> I suggest removing this code as it constitutes duplicate execution.

Would you mind reformatting the patch description?  The kernel community
documentation recommends wrapping lines at 75 columns [1].  While the
current length is within the limit, adjusting it for more balanced line
lengths would improve readability.  Also, I suggest using two spaces
after a period instead of a line break.

[1] https://www.kernel.org/doc/html/latest/process/submitting-patches.html#subject-line

Thanks,
Enze

>
> Signed-off-by: Jung-JaeJoon <rgbi3307@gmail.com>
> Reviewed-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/stat.c | 8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> index bf8626859902..51dd29685915 100644
> --- a/mm/damon/stat.c
> +++ b/mm/damon/stat.c
> @@ -173,14 +173,6 @@ static struct damon_ctx *damon_stat_build_ctx(void)
>  	if (damon_set_attrs(ctx, &attrs))
>  		goto free_out;
>  
> -	/*
> -	 * auto-tune sampling and aggregation interval aiming 4% DAMON-observed
> -	 * accesses ratio, keeping sampling interval in [5ms, 10s] range.
> -	 */
> -	ctx->attrs.intervals_goal = (struct damon_intervals_goal) {
> -		.access_bp = 400, .aggrs = 3,
> -		.min_sample_us = 5000, .max_sample_us = 10000000,
> -	};
>  	if (damon_select_ops(ctx, DAMON_OPS_PADDR))
>  		goto free_out;

