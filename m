Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33202C44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 21:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45576B0005; Tue, 14 Jul 2026 17:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF7266B0088; Tue, 14 Jul 2026 17:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE8156B008C; Tue, 14 Jul 2026 17:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 907366B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:34:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0849A1A04F8
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 21:34:00 +0000 (UTC)
X-FDA: 84988685040.04.7A244B6
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 40A4D20010
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 21:33:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BwR+S5wC;
	spf=pass (imf03.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784064838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zebbIro5mkXbuDBJ5TKnPBr9hFGew4CMfA/H27lS0KU=;
	b=RiB2hNirjUfsuPZkl8tyLHFfa0Y3JTu7xWGGtzYKzuG95wjDTSz571ilF9p03yYFF1GYRQ
	eIxZU1sSRfgjGdxBZpggn48aKbYO6fG+CgY0UQFN8ahrd8ZnvehXa9EQecdJSVxVvqrqEt
	aIsF2wlamTOEaUqLJkpngzFTEaQFwKc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BwR+S5wC;
	spf=pass (imf03.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784064838;
	b=WGvVIM3D07reKqEIv6xL3ZBccSEz8UbKWM8fBBHMvmTc04wqe86YB/m2dsc01SViWfXvru
	AUefMyk85BKHT9tPZ2Vv9hlCA3KOkyJ9xmH708d9hjcyEsJUg8nu35XqYfp4SvkrkVXhOJ
	MmCLiozj+m1JX079ZAE6NlUxrMh1OGo=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cacf197759so22305165ad.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784064837; x=1784669637; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zebbIro5mkXbuDBJ5TKnPBr9hFGew4CMfA/H27lS0KU=;
        b=BwR+S5wCl8JSutwdWGTSsjNZf+0YTccnMc2AzxY3BAxEHTWwEIgNWmjXgJVAodx3kr
         OFVTMWj6uWwLwLvLkxkiIbFmS8Gj7ysF7PxBcalVaN/j3SCmRtVUK9HbwtDWAzZySW1y
         EDAnbEUpepsX5ZsuSUXM5OZlp9dCms+s/ohYdEnwVkXoM/sZ/7YM4EPgWlBT80W43Qjr
         0ZPoKMsAT/tTXpsyG799DCIHzxfz+Azs8a85JfO3n2LjvSPonnHDzn5G60R6KsQWyg3S
         QcC99Mres6CjK/WR7P7WjCk11kRZFz3Jt2QRkLJA0NWPpiS1Lx35wIO4qWkDLv2F+wEa
         0eGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784064837; x=1784669637;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zebbIro5mkXbuDBJ5TKnPBr9hFGew4CMfA/H27lS0KU=;
        b=jB8Pl3OsI+V/L14cemnYXwJQKGVIZjMSRPDHsvZzVmKeb4YY35O5psugC26aIBBftV
         K12QnBinMfASxS1Zjfyrv4lhq99pwU9QbeRl3e89/V3s1UchneapiVKuKg4yzgzLO4oB
         uuJVgNE5E+uLm3IMCNQfOw2ZHyh3Ar3ocyvyrrnVw2Ir5sgD9nZN1Mq4543Q3EkA6ZkT
         T2/92lgcQ4fPldfIVQ4xtow46Awu9cd7A8iDEZ/XitPNtORZvSXVQaJlzpeHDZ6vurf+
         Q0IPkxiOxWrldC+jrhnoPytFBliYonSNwgX9tvyo/bMpQ8N6AfmBxyUv8ef+J+5/3PwH
         ubtg==
X-Forwarded-Encrypted: i=1; AHgh+Rq7QOfJF0I/dKUxGyInAVYuZSXmEpWPi6iuyJ5vvb/Gqv2JRK79IrIYO49vkQ68vREqkE+IQBgRmA==@kvack.org
X-Gm-Message-State: AOJu0YztNZiCRuMo5T45ZrHwJQZKPbROwMh1Q52+xCaWFEqaK7qTXlXv
	279MYUlRqhcBafonFEnEOm0vJJOpvF6/GNCwmlJuAqRZJQItIYxF7Ml5
X-Gm-Gg: AfdE7clepyFb1QOso/xk3Uy0ey7w20ZxsLgXfphzJideIuzM/kmWkNZrw1lQb7qMHeU
	FWwi8Xisjj3ZOKc+nECDOWHuG9ijcfjWEXdAtHQDA1iH3IpuZ6h7/Q12VK8d1+sDXzvASxsOJaF
	4WTbkBzP5yL8pTsyTf3+GXqXe+ezeEeGLXtaZYKi92O833QcEOw6QbqUgb0pmku20lAjdli+Knk
	FU+Y+7HPtYXovsLUEIVsgMHhEW2Z3Zc/5sVOjpsBrO/cAMSopiwLkSzol6XO7+FeOl6PQ4jk/Sd
	5mK79dHhTG2v0hnGJ+hgE7mo6nLrWfvAYv8d8tqV+D7I6KccbY5qR5OSwUA/ON5IheQAzQcMVib
	PxVAH3B46MMtmSgnFEeNpZKtUnxklxE8gAAqHPGiC/hp8LJQfyIepnrvb5w1oPHlZ2J8jg0Q2VG
	EntPRVCwyYPNLPBe9NCY7gUHH6vnGQ3kb81QEjjbJsK5AgdIu7t8MoZvug5sJLskuj/g==
X-Received: by 2002:a17:903:240c:b0:2c8:1c05:16bb with SMTP id d9443c01a7336-2ce9ec0f108mr142192545ad.24.1784064836947;
        Tue, 14 Jul 2026 14:33:56 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cea6507b5csm55058005ad.72.2026.07.14.14.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 14:33:56 -0700 (PDT)
Date: Tue, 14 Jul 2026 14:33:53 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, david@kernel.org, jgg@ziepe.ca,
	kees@kernel.org, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, lyude@redhat.com,
	maarten.lankhorst@linux.intel.com, mamin506@gmail.com,
	mhocko@suse.com, mripard@kernel.org, nouveau@lists.freedesktop.org,
	ogabbay@kernel.org, oleg@redhat.com, rppt@kernel.org,
	shuah@kernel.org, simona@ffwll.ch, skhan@linuxfoundation.org,
	surenb@google.com, tzimmermann@suse.de, vbabka@kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 2/4] fixup! drm/nouveau: use
 hmm_range_fault_unlocked_timeout() for SVM faults
Message-ID: <alarQbmnjwtgdBUB@skinsburskii>
References: <178405975214.1082778.5193079941156341151.stgit@skinsburskii>
 <178406001808.1082778.17299764648397654220.stgit@skinsburskii>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178406001808.1082778.17299764648397654220.stgit@skinsburskii>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 40A4D20010
X-Stat-Signature: kzo1k1qw3gg1a9handeeez6jui6p1ghi
X-HE-Tag: 1784064838-216232
X-HE-Meta: U2FsdGVkX19br6yElaTo+03NyCA+Pe1zKUiuOPvKbbvybBKSWyoGG89hlI0WWJRjXuZjqt9bQ5pzS9SYvVLB8Pls61ErJLfjv5rDxdmyWGBlwFWN2RrPmi877YvDtnEgwXX0W8EQsUHlZktN/kB9uUDvYbgjRS10wwNl3dF77SA/+v42xGQAiy5JhpQ/qA1eZusnyrW3G2cP8V9my+dEu0oKosxObswTBCucyXpdZgTWfSlJlPiwdxtpIn7MTC9nXURxCdWMmlVFLH46R0Wp2mMdty4UsBG+Dwih5+EFLmI01MCXntxVG+rWSBSIQ4ASmYvRdDgzmuyjNO0vyG11TeMVgnlct21d94MPG6YJkkqFB/nIhuQmyyG3KY3ASfnrOaRy9Dp1zKx2Ooaq9243OuJSXgONWQb0Yr/pR9HOqeDfxV4GrNPKDssSh5xzbSEkGCQ8+t2BZ4koPb4K82fb7UdoWvDOtzah1PRhn5oT/ehkH2miyLdec9b38obcEPizh3+zI2xz7J/aE6u6DZN5UbMV0BbIHuZ5BSvudC0gwO2q7eK2uLwDk4oYXBLJLxJntbA5hJoAkBcnbs1NP0Zgrn5R0XYT6bApxPrnUKjzSu6UJhF2x6tbFMDaF7KAk0JPV0cfSDPc7uYb0/n/1ieZsyZuUZyfwZ01p/nd4UXxzrygyYD6Z2JUtgeOvG+uWF11Jf7EV7/JAK0u68aOgsEQTBeHDQPIWO8P9M/zMFqBHk92N9jfFQkOABIVSkC0TLrnM38fMSqGXKOtepehzUCrsVgh/vMZypr5OLe0h7J3Fc5wauC9r1jpQxCtGxS5O7J0zW4qF4QXoQTKtPB5W4XMRKWNMlh/PNA/a6IDTDZfXCDvWShREE6lP8e7YppM2PGrmgnlaM0HPby+dY/UPmuuMptVTWt7pj8HtdIa03Fwpeglk+4FL8+xS1H5LNvKjy7CzpMOhpT7UMCVJfHO6hN
 07FRcl+j
 skmncEFiJccPjZ2kyFWDp/hHTgFepIUSwyhCT/zg73HOhimxrJ9YBeBkiS+PRrND5kJWGu0zGA+KKoZbsjZ8IUMecvBhuqeRuphNtqELEu62/b0mqDn1H3IHNBZ+dAKbQrTEE80VX0YA8QjnsccvNkuTffadlJIynaY4QgYrQtSu3wQ81izQkW7dDzjfwi8P3RM4Mo3cnCYeNjkOzn/7vFd4TXOdkaaT4+lsuRprPiVcDMpy0JfL0zeyjJAokyHUQOFdo1t7QJ42WxzgImIQdOTvopbdh5/lFN2l9D8YxgHR6WvAbpipk/RTFMJKf9jYWGGx2+hzQEZP2HdBtNHIW7sya9r+ow58nvJNbYxUtoOyWbkIOlDB5bFSl66BHvBTOHxzG9KBnjpjbcFvWQeg5WPPdr/zWtf1087VeCyVktAfx+t1wkousCmXsT4Qf9anh87AJG49gyZDACOUMynnY2PmSBxDa5lTEkl3fV48U6+m6FlRCZRkTcGrP1bp4z1eqGDvD2LGqpeQ8Oiu0jsJKzkGzLd69GhraNdFmhWBcuxDGuSqt0YoDKcomDXcpZIO/EYsw/kaA6z7q/LpBNh4HT0lpVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 01:13:38PM -0700, Stanislav Kinsburskii wrote:
> nouveau_range_fault() now uses hmm_range_fault_unlocked_timeout() for
> the HMM fault path. The timeout passed to that helper is meant to bound
> HMM's internal mmu-notifier retry loop, not the whole nouveau retry loop
> around mmu_interval_read_retry().
> 
> Pass the full relative HMM_RANGE_DEFAULT_TIMEOUT value to
> hmm_range_fault_unlocked_timeout() on each attempt, and retry from the
> nouveau-side mmu_interval_read_retry() check with a fresh HMM retry
> budget. This lets HMM continue when it has made progress, while still
> preserving a timeout for repeated notifier invalidation retries inside
> one HMM fault attempt.
> 
> This also removes the open-coded absolute deadline and remaining-time
> calculation from nouveau_range_fault().
> 

Sashiko is right. I'll need to do it differently.
There will be a v2 of this series.

Thanks,
Stanislav


> Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
> ---
>  drivers/gpu/drm/nouveau/nouveau_svm.c |   30 ++++++++++--------------------
>  1 file changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
> index 4cfb6eb7c771..b1415c2e49fc 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_svm.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
> @@ -655,8 +655,7 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
>  			       unsigned long hmm_flags,
>  			       struct svm_notifier *notifier)
>  {
> -	unsigned long timeout =
> -		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> +	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
>  	/* Have HMM fault pages within the fault window to the GPU. */
>  	unsigned long hmm_pfns[1];
>  	struct hmm_range range = {
> @@ -677,25 +676,16 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
>  	range.start = notifier->notifier.interval_tree.start;
>  	range.end = notifier->notifier.interval_tree.last + 1;
>  
> -	while (true) {
> -		if (time_after(jiffies, timeout)) {
> -			ret = -EBUSY;
> -			goto out;
> -		}
> -
> -		ret = hmm_range_fault_unlocked_timeout(&range,
> -						       max(timeout - jiffies,
> -							   1L));
> -		if (ret)
> -			goto out;
> +again:
> +	ret = hmm_range_fault_unlocked_timeout(&range, timeout);
> +	if (ret)
> +		goto out;
>  
> -		mutex_lock(&svmm->mutex);
> -		if (mmu_interval_read_retry(range.notifier,
> -					    range.notifier_seq)) {
> -			mutex_unlock(&svmm->mutex);
> -			continue;
> -		}
> -		break;
> +	mutex_lock(&svmm->mutex);
> +	if (mmu_interval_read_retry(range.notifier,
> +				    range.notifier_seq)) {
> +		mutex_unlock(&svmm->mutex);
> +		goto again;
>  	}
>  
>  	nouveau_hmm_convert_pfn(drm, &range, args);
> 
> 

