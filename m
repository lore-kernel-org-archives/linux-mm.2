Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14947CA0EFC
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 06:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58FD36B00A9; Sun, 24 Aug 2025 02:53:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53EAA6B00AA; Sun, 24 Aug 2025 02:53:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4547A6B00AB; Sun, 24 Aug 2025 02:53:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 362F06B00A9
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 02:53:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E07331A080D
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 06:53:32 +0000 (UTC)
X-FDA: 83810735064.06.71CC6F4
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id E8694180008
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 06:53:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c4NxNn7q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756018411; a=rsa-sha256;
	cv=none;
	b=d+f4tbkc9gVQ1ze+s7DKiyIHjtY+D1WMdJ6NQNZ+viPb+cZ7Nn86RCj5bkkirGcyVsv7xf
	5SWv5lYelB1jS8GCo8O3/s7agKaMXy20eAiHryPon9TKo74ui8f+fD3wjDCi7KZHxGD4N+
	tLpGhqu5YxXEO12FJiE2xiFpRE1sfII=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c4NxNn7q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756018411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/bXdnPZsdYDL296YXs8gclNDn06nl0Bznj+TQgOZaAc=;
	b=ECsBwcJbGwXYio4OpgxEFrzq0k7gXDs9lVk3zBx6XaY/09WSAoSGRvd6fTFSA+rjlFkiy6
	8cDoHdHzkBCNkep/XgNaTiv2d78SDHaYMbEZEvyhDDeMVq/t2Kju42IwkOJmGLO4JmJx/n
	KpuduXp3oNxLc/W/a4yU0sBNVmLxfoQ=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-55ce508d4d6so2737466e87.0
        for <linux-mm@kvack.org>; Sat, 23 Aug 2025 23:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756018409; x=1756623209; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/bXdnPZsdYDL296YXs8gclNDn06nl0Bznj+TQgOZaAc=;
        b=c4NxNn7qC4Dzcd5Xi/7X/FiZ4BswBxKNlEi71gJcO4dAw3MCxKfHDkvRj/3o8BJjYJ
         ii09pdjCf/7cJfbZQpgzutDpgwVGPXu0okcGWjPe/dx9N0vpTTwWuxQkq+vLqan3blWq
         C7JIVJ8YHqspWCIRt5E93K8ZKHLNmRgM3golsggvUp4jO0EdMlUXH7EZumeqfjqn+Eam
         EnztBepXeEzBa/OWhqug823DxHegjFE8sNFk4DzuD4z+H9E86uz7L+n8oZgijGSojfxf
         pnU4ZA0dvpPo+M4tjHb90/l3GDGV1xvDVXZVnPlAafY/GgxBLW/E3Qr/UmJkajZWExlw
         9CdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756018409; x=1756623209;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/bXdnPZsdYDL296YXs8gclNDn06nl0Bznj+TQgOZaAc=;
        b=WBnFR6rNNN79v+4WOdTlDL3KLW4MZw3lMTiv0wCP+giUW+zpX8k/UioFOcg2kjcYVq
         ZtcAtDPeoBWhRyynUIMmtI9gB0QVqW0nId+xmmWGP8E0Q0fgmZ7xPanSftXInV+q637s
         /zPE+4sskPD8JcQwe2UcGgqRzuwAAT2LzuiF5uuMY2I0YN2RsZE0pVRtYvvJ1sBen5ii
         +nBug/KhmfA00MsHl22XjDSko0ybVDaSa7OLFcuKiumIUxBsEpmHorQARwWgyTQl+3rz
         ml4jMKhoD25PnAWnpmeTykeIt6ax3XVypXh5m3MBSK7fP5+QhIISfIvMT5m4gWmXOtKO
         /3MA==
X-Forwarded-Encrypted: i=1; AJvYcCVDejXOcTybIGqLgGEaJlwpkGmQJfnEpQLJszVBEQoCkVXe3QSE3Kkb3GnqoCroLpv1mRYtPjdXIA==@kvack.org
X-Gm-Message-State: AOJu0YxzrxjmGBWj8+kpExYVmuV2KMhdYWlWfJiwkOk3BSHK/ysOhYMz
	AzPSZch0CPE83JO/9dXr1wMH7v7sEMy9Uwf20xHqjnz2DPxiqcXlkrEt
X-Gm-Gg: ASbGncu3dNUH85p4JvzvEP0KPtuajrF/32f/KI0ahWlEWqxior6Ws2226mo+bYDQ7co
	vSZ0NzReuevgoV7vuy4dkadTGh/rr9DnclIAVwAzvKGgtxP6pTwqBanNPNl+oOGYEPrnyS6hwFl
	O87CFcFLGoIml3hxj9FTOWcL2FLDnllR8cQ24Y39Ykl9Un3VfiZ5SXFyKDf64wkJoDmxtoen56G
	jGkTxfHmV3r2dCdDZdB9s2G4ymlKZrElIwCDNX+b0SHs3bI0N9wz0IxgM5OkRikvJnNNGasx3Pj
	gEC8qwpjmnPvU1oVW5w49mF7iQ+Z4g9SFWwwsGZ25P6VMWAsqAWlSWYxBbR8/0Mg
X-Google-Smtp-Source: AGHT+IH/HPvnrblsXaSYujeCUTXfUVCuyyVcsNVaDSTH8D8zOs9u2C0kscdWCGCLeYgjhPWllLFAgA==
X-Received: by 2002:a05:6512:150b:20b0:55b:8aa7:4c1e with SMTP id 2adb3069b0e04-55f0ccfdfcamr1678570e87.53.1756018408643;
        Sat, 23 Aug 2025 23:53:28 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55f35c8bb59sm902838e87.91.2025.08.23.23.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Aug 2025 23:53:28 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Sun, 24 Aug 2025 08:53:26 +0200
To: ally heev <allyheev@gmail.com>
Cc: skhan@linuxfoundation.org, akpm@linux-foundation.org, david@redhat.com,
	shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kselftest: mm: fix typos in test_vmalloc.sh
Message-ID: <aKq25rlqbyYDaWVo@pc636>
References: <20250823170208.184149-1-allyheev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250823170208.184149-1-allyheev@gmail.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: E8694180008
X-Stat-Signature: 839jng4agnq3e93m8c3y6abw4tt3mmdh
X-HE-Tag: 1756018410-916764
X-HE-Meta: U2FsdGVkX1/iE+YupVTmtT0P+8iSsf7X8WinhKY64L226LBOOBL8mBz3rNV4YSC/vmLbRTGV0JABbZaVeMSqLiOo0DZLF4gTr/0w7HLmUB4+7mHpIJBxz6DJ/8zMbYPUHwZpo1Sf6krS+IctdN2MaUU5jAPRKSYOPkHQQvv43B93D+fiiVFw/VVoyZxJr6QxMkZCDHOzCQ/dnQjfN/C36tZjUYcR3Rx7g3F3wzQjpGCEg/duuBNmvTXPSv7BQ07JFVPA8ewqQYkis8o1nl896dA9DQyIcXlmhm/+9MiS7al7orWwg4CUZAi9mwbj9gU3GHmj31aTJFa0jjXbTyIAJFiDFg2pbER52WvDewSvl2F9ui6mlQwDaDCKB+rZlkRPuzbcvfjPiECiTvuHES2I0wzQSfPnH/L1Ii+4IL4kd/c7QkRKym8xBFOvmM2w/3lJXLQm59EHJZXQwxKcjLcakdGsGTRDzdbIKd/w/cQjonHuJv1ZgSk4uZki4rC2zPJhnVMDmHNRXUSJg+r8pHE4zntTYP/2TAMxBQ/16avdEO0l0wK4wRYnMrUtliiDSql79sYYjGPQHE7uXX2bgQeFhEXPc0bLFVZa9iNmKwSHcq8ZKzFIAMm88pxbLgTa17ddCsUrLs2cY8B151ydlrqvTmZTlMSAyb+FF/Z9TieRt3UnEzYRy61vIYEWIzPu9IpRULjIHvwu2weU2smReukawzYUQvugF0katUOJ6i45NWvQsTs/F4JwKWuBStNQsfAf7b+pCerwHtmes55nH0ViutBxQSfO+a7/1qdchuv/mhimFeHCDMChwgHt8v2nAtUfiivvKoxVRkBT6jJsBVyg35Z/jpYlPjwc46J7oZ+A/NbkghbZTKMERIzw5dU+vfMempX6q4wIezdJdq4gwslz8NNmHow0xZFH3MotqxhRuxhPqlgBiXTytnkVot5aSUHlZLuFr+M5ZXXkfgBCgF7
 1k5wPXR9
 YN+w/UhUE1J44dRTkyEQc6+Gb0MUWiLFLXHPDRzaI+GRmJaTBpOAnlYwli8Zza0xNPx4CPSFIgQkWDXWa0mL5TPXX6xQynSeJAss4VcmabtJbKxqvz4h/grfZ2N8zSg3+gI9vO32qw39kQIMuZuz1WhG8k+LIjUQbBJYHpPr22jq7qlem/IJ58iGIYl/jaZsho6hFvqwGHdhqrdM4e5Xl3cAuKyouQU0TtvFHOHJt+Eiux8RmInA5nYAk+Put5lpRE0LLhxCfhNdXrqaGpxjrEPe/b2RXyM66NySdL/4sx57anGuR+DAo42yYjXQSZDwPGEqDO0zv2KaFB2vZBzExaLHC2KE8DW0cAgu5/EtKfhHxYy1F9H2DKYUHEnhwB+K0+FwHeb2rpHl+cfYrDrqHHO8777MeYyrO9ezLkbVr/uWCqygRuAqkbrOrmExcvqtMr0l2bkMju4n7EZ24VzqjRH8WymsYDkqb/LTNvmhmBCePoDcWeAdk0Z7trvqnlSp8rfHO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 23, 2025 at 10:32:08PM +0530, ally heev wrote:
> Signed-off-by: ally heev <allyheev@gmail.com>
> ---
>  tools/testing/selftests/mm/test_vmalloc.sh | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/test_vmalloc.sh b/tools/testing/selftests/mm/test_vmalloc.sh
> index d73b846736f1..d39096723fca 100755
> --- a/tools/testing/selftests/mm/test_vmalloc.sh
> +++ b/tools/testing/selftests/mm/test_vmalloc.sh
> @@ -47,14 +47,14 @@ check_test_requirements()
>  	fi
>  }
>  
> -run_perfformance_check()
> +run_performance_check()
>  {
>  	echo "Run performance tests to evaluate how fast vmalloc allocation is."
>  	echo "It runs all test cases on one single CPU with sequential order."
>  
>  	modprobe $DRIVER $PERF_PARAM > /dev/null 2>&1
>  	echo "Done."
> -	echo "Ccheck the kernel message buffer to see the summary."
> +	echo "Check the kernel message buffer to see the summary."
>  }
>  
>  run_stability_check()
> @@ -160,7 +160,7 @@ function run_test()
>  		usage
>  	else
>  		if [[ "$1" = "performance" ]]; then
> -			run_perfformance_check
> +			run_performance_check
>  		elif [[ "$1" = "stress" ]]; then
>  			run_stability_check
>  		elif [[ "$1" = "smoke" ]]; then
> -- 
> 2.34.1
> 
> 
./scripts/checkpatch.pl ./0001-kselftest-mm-fix-typos-in-test_vmalloc.sh.patch
WARNING: Missing commit description - Add an appropriate one

total: 0 errors, 1 warnings, 24 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./0001-kselftest-mm-fix-typos-in-test_vmalloc.sh.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Can you add a commit message?

Thank you!

--
Uladzislau Rezki

