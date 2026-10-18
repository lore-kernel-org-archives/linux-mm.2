Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB06ECCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 17:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA2F6B0088; Sun, 18 Oct 2026 13:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8B736B008C; Sun, 18 Oct 2026 13:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A08E6B0092; Sun, 18 Oct 2026 13:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB226B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 13:10:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D4A01C3C5D
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 17:10:02 +0000 (UTC)
X-FDA: 85336384644.05.A5744F9
Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	by imf25.hostedemail.com (Postfix) with ESMTP id B962CA0007
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 17:10:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rEWiYn9o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792343400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+WJ/hu/3Wga52spo7IQdSXB7WSieQhEpzGVW/oaXQhc=;
	b=npObSmrb2SPS1niuDIPgyBsidDlJwkEH0pCj+ES3kuNUe8RQFuvhRbMIk2g5uxsZCnfR39
	K2xq4XI2yo5Tr0CCevy6MoM0650dW1G+COqqD47XeYnHIRQHvbhlnp4K9NfwWMDxzPtllT
	7CQ6f9sHcVOguOpeIQc9P3pGR+c554U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rEWiYn9o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792343400;
	b=HzONcreTBtrVcLGhoecV6xpNLaff1il/V92RJyZqlHoxloxhXxvLUYbYnHzN5BA/rHuhT/
	wN/+HFsrd6VJmzwySH3wsAg17ciTfJAyQ2b9tW7OFy1oi1kHdB9ff48cBcUld/qC1atzNS
	EjBZidS1n22IC5Nq6KH4bSaRRkBenkY=
Received: by mail-pj2-f8.google.com with SMTP id 98e67ed59e1d1-3ac749e0719so464259a91.0
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 10:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792343399; x=1792948199; darn=kvack.org;
        h=message-id:date:content-transfer-encoding:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+WJ/hu/3Wga52spo7IQdSXB7WSieQhEpzGVW/oaXQhc=;
        b=rEWiYn9oDuFAC68N1hik+JvnsahJtPHSl99UIjgJxnnyl+K9+NBixbPk1/WDw7e2Jb
         XkHoF4MbFHJSalGmzgYCOhIhT2A0yPopLTCfv+Gt9bNU+MdG0kghZmRjtpYUCeZTrwmF
         wOEXKJmEFLNDy3AyUpyfjHFdLe2ThnU91349Jf5a2reDKod6CwuTv1sBWfKlyelZzJ+S
         Wnd+U1R3sX9ZJxTVjQxIpEhT2YuG3EfILXw+BsuVRVd8d2zsuQzl8F1xYGc9TVx+zYXc
         Me5jmqRHdM79ev+IuTPNg/UoXQDyv9HlIQu673/OMAT8ti4uMtM4URZ2zYqjvKG2nXdX
         8muw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792343399; x=1792948199;
        h=message-id:date:content-transfer-encoding:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+WJ/hu/3Wga52spo7IQdSXB7WSieQhEpzGVW/oaXQhc=;
        b=rshuzb+nJUbuzR2SAr4MOv21fB191r7c/uvEcLxtofdGqUkc3/MO6G5kTL0JhnOgfp
         Kr1AiHK5GR3lutTbCjcp+kUb8+pBBrRJnu9gUmB0G8p1+S3sgBnKcNgjRv2TFkG0IyPJ
         6AGur2x5Gg5Ty3td2MaTsiwzANKr5H7ujAGkAgowbKdXyyrOB8qbTklwnkLD7vgXQlgS
         7pchGOOqmoWMbGGOXr+qMuvmVVl7xjORqs7JK8TyDMQLHTjBmhy7xOdoZAsMs4p7Xnpt
         c+tlBHfJE+sCiH1o33GfMB4SBrNLV42udS2mQcdngzHsF16kjGsgU6uzLj187OHpx5Dh
         6UPQ==
X-Forwarded-Encrypted: i=1; AKwUvByX49lWtIyb/s28aROGeUTqTyb4eXT2wQY7VthGEaMqOwSnqQWCNvJbzxor+dnCg4hDWiRjFAeezg==@kvack.org
X-Gm-Message-State: AFq9FYJj4L7eNEcACjMrnCaTXr9Qozq/oLUwTmff7L4nNKt0LbeqXfeh
	VwlwtVJeFR6svklfhQuNcWYpXgz8eBtwIvRpgVrzJlHtDEpa7UCCu5fX
X-Gm-Gg: AYBFou3TPFgmcI6mwULzw5UlBbe0tVl7E6o+clz6ZfK3i3zhv4dyhlkMZUzTBgcr7AW
	PT2EGgWrVo9B0W7cfNvEiVLtBlWEIUcFBh01lanowcA+Xt0UJZvFX3lYDT3wCWLi9il0R7SeEe/
	YkabVa0xgxJymRaVCabhlulN2haumb/Rtlc0l1M94ZuVDwW7EKKAPRWkqQ62xCd/2PAbKIMUrev
	/ywe8k0iO25iL5HL5evmCzeqihNgccug0U2NxFzFGOuuknT1E+z3u/eJRDp1WuRjqUpXXuc5HPI
	V6mOQh3LLxV7TBgvc2fijnHjXCjWJmStax1FcG/RbjRX9lLMdMSWSTS5Q0zvGBdMiJCX2qq4Vm2
	4WbPZphnLcnheLKBOSssnSo71S5Ca5HWZhi2cXJDz56HHBQwaxfoOYSCNQGfFWOSA1EJYsOUDr1
	wKUagyxXO4ii0G0m85DI+0BBQyjy6+AfvpH4iIYKPcmChGLfsK44g2nlNrHVnhbXksDTrboZmqy
	5i281EKB14TZ+aJA2CmST9txEDbmsX+gnxwSfonP7IUNys5fFXIVAG+Tu5vpRtatbtQb+gjigdw
	ffo=
X-Received: by 2002:a17:90b:57c3:b0:3ac:8ee5:e007 with SMTP id 98e67ed59e1d1-3aceec24801mr4102774a91.20.1792343399360;
        Sun, 18 Oct 2026 10:09:59 -0700 (PDT)
Received: from [10.20.15.86] (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac94798212sm17396301a91.14.2026.10.18.10.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 10:09:59 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: SJ Park <sj@kernel.org>, Shuah Khan <shuah@kernel.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/damon/sysfs.py: stop obsolete_target shells
 hanging the test
In-Reply-To: <20261018020415.35567-1-jaeyeon.lee.dev@gmail.com>
References: <20261018020415.35567-1-jaeyeon.lee.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Date: Mon, 19 Oct 2026 01:09:02 +0800
Message-ID: <179234334286.2.7819752603607417566.damon-sysfs-tested@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B962CA0007
X-Stat-Signature: sxf8wtc37u4kwwf8ywmb8r8mee85k4nx
X-Rspam-User: 
X-HE-Tag: 1792343400-75964
X-HE-Meta: U2FsdGVkX1/U8upkltXcPR/EvZBv9Eko8oiCIFlQJZsozQxXWII5KztLRF0l5NrU1tmBgBa1JJz0jaPK7FzsXQOCFTnWHT82YF/X+1lh9KuhRN4buxCDJkbv4Fs320vQ3LTEwNS5niSMUVMOKX4ckUKGiaIfnv+W4DkfWBNaIJWeOHjJM6eYi696KnLV31+hcGVmEjArtcYhZuace9xyLtclTgBjP1/tGaj9huy98LNNA0zs4ojPyMmccPKtrDgbA/L+j4jv5Q4O+eUtUvc5ZQfkvqXInMxDHay0WZSGYfj4uXMULkn2aNrQvmCyXmPY7w9ykQekDscpOPQe+2LBj7GtROg1IfEAPwjuijXAJUF5G4AHknVKt+n9OD3FfR509bsqweYJJhnU/cvLQix2ZS3tQw4yj7lg/gL4ISWOOiGG9gP/qTtiHiBCNbhcEVhlaoahhyZohSQ0RmvJXWW+IzpHwt8AkXmEt6zhnU9eXnAGNrqU8Sd9Fsg2V22G57Av0nAiWSpE/a70E8ga3oabDdjepeAfvRTc6SsdCmpobHmVNfkz9vAwS8BPhcx9tykjMvO5gs6Lp6Pqyp7ScmGFFUTSymWpOMTJUuykqMUJ04SnPae7UeIsShyn0gwxyiK59e6OXvVWb1+1jE57PVgprKOOtPSWQ681+a4qciu8woHfXDP/lWH4zfK993b8IVHnq3vDomutv5pNian2JwXSrWy9tAZq7wo2Fex8ymWkBy5CvhqIF1TEnB9dBLMZDxFpINxHLA8yP4mRFAI0y2du1iNdOK54KU2uYfWJo8Fa1v3xpMv9PYD2tZyi6SVLr15/7GL8mSs/ztD5dU0vxUigwaHQEcHiq40AU04puqMb2uvW4gil4WaddSHa5O827Qz1XA10T3c8iHSqGPthNhTZ2uaL+7wHrFQqxFkPM7HXUGbpW56Dsf5qXv+XrLNFcMCKWKTfJcxplcnqsZnjYUq
 KtC49exP
 doUx+9afQ90yqD4nqsdkUAz8ywVosyo1moLMIpFwbdqe4OrnZzH7Z2FDQ83Ajl8d0yeZph4rnpAXKJYFb+sQkAcW+pf5GvuvhVCFbu36I4kDdQmyCk/JwqISHeJgJXExq42LcUL5yWPjhBV5T/hrGY1hpqju8ly/Vvfv+DYq00t8su2d8IZEVcBWO3aoMSfqnjmR8nHT07P50K2ya0VtsQ9kN5umXe73qFUJwDa4P0Ay9aeQJ8UBcyTvj4DGf6Sr4Fb4+WTiO7fQWdKu1xOQJe+Zh6G6Hm2mjoicxnaDPLQyZSYbjcRFpqKNtL12EpksWfyN3wR0+sg3MrR6qJMG3V/Hu3nnXdALMiTMi8VYfQIigHnURFAPPEaXgQJxH+Fd4OTCCPNXtsQgAe51q47nAkMgCjjmhetknWclCQIqcOEO3qLEjJqMTGkhmR9lxZOni5VkoVimhOYGzYCU+NCPbx7IjH2JnR+Q9aqchJ8Pz/99tmgBs+CCpnyJZldsNmaYDT2a/rwF/9vDhuJX5DAMrPzfAH05b/IxpYmBdpM5Ps+qY6k/ub1iZAKapgM8vWgDmH8Og71axeKBFZqHxkEdcORo1ayApFsVlllbg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jaeyeon,

> Fix this by passing stdin=subprocess.PIPE when spawning the processes.

Tested on x86-64 KVM, works fine.

Tested-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

