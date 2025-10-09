Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4DF5CCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 09:46:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 128608E0073; Thu,  9 Oct 2025 05:46:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D9B18E0002; Thu,  9 Oct 2025 05:46:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F31488E0073; Thu,  9 Oct 2025 05:46:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF8D38E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 05:46:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8634B5AEFB
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 09:46:14 +0000 (UTC)
X-FDA: 83978095068.04.64536D8
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 901EA4000A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 09:46:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HxMGoY8o;
	spf=pass (imf17.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760003172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2ege6p4pcLOxc2jHHJkbOlbvAgh1MwdywY3Y/8BKGY=;
	b=Ey0qFNNFz0vQeardKwRy/F9CKJiWK6+CFatzHq7QntugG3tfkUg+k9JR2sTU6mXTig8ZKc
	GosmWN/XHLB3gug4EyQrZ8sWrAg/xzEH3y2MOchUyqSearEFh+ZFqHAJF2wtGOROD9S6Eu
	64/0+m3FQcnJffG0w01tcMrmjBMr1cA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HxMGoY8o;
	spf=pass (imf17.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760003172; a=rsa-sha256;
	cv=none;
	b=gW0GExKsxo0BRSEeyJkCHlovut9Cg6tf6UOPmtX5xpwAmNuh54gohY1JRsMGf7ItOCKiC5
	SSKy5hkQ8QthKUrdG6SNJxVFGdqcVdBfxEOHtUpjhUJDnJtAACfi38XZRSkOHQRU0NPrC+
	sfcKfaQDCWSoz0UT+IeNUxzv8prMWE8=
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-362acd22c78so6120661fa.2
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 02:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760003171; x=1760607971; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n2ege6p4pcLOxc2jHHJkbOlbvAgh1MwdywY3Y/8BKGY=;
        b=HxMGoY8oxq8q2cg0u84rtihBxv7iP4atK9c2wacOGBs40nqAeHmo3Nq+mf7sXAJNSO
         SUY7DDPKtxCHxKJoet5cNk5l2XlPdANN86hxX5aRsKHc7055LIAGJGvLqATtTH8+6Q0o
         FtpUQpgYOK92JLDCF1QCpJPlHr4cc/JHZ8Vcgabw7JAWfcmC1TmKh2OWmTK5gC+Uzyj/
         4g/lrewAfGbjKCoqj+AsYHx/O0BhS+714CMnPObGyZUZGyyp3u4wTCd8vuzBBbQADst3
         g+y+bY9h0tG/TX4KZoBU2UU4pCVeTicjFmAiAM2XbaMPazCJqDzQVTAS4B0mXloQY65I
         BRWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760003171; x=1760607971;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n2ege6p4pcLOxc2jHHJkbOlbvAgh1MwdywY3Y/8BKGY=;
        b=Kq0te96NSD3GKCi/JX7f4rfNRivwMKjmxDrQy0mgLYgmD2QB74z5FDbbbw2p+2A0F5
         AaeKekyZAtDEj1Z2Hjk0Up76AKuamzYIo0dcE/THqEp8ZG+L44iUjtW/+Jozu5JqZA3f
         Wlfzzxl2cC7NRNaDt4VhHUuhwBalyIb5ctoHCZF3p/htchTtRxhdS8h12MfSQHLFcHu6
         vSBnCEEbkJS9ckEus5en1FplQYTFDd5gdorlwAtSxUCvIiOSVzAPFNkBwO4GTHdFWsIh
         l7VSOk3JL199F9OyCLTMzRe0O513aNqcqTnIWODpsRZUNHeF/JIsAaMhmdDcvF4DWbG9
         /mgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQaL0VRs95pBvSYlnAjoeKCKEL3+Ezsube2lzqF9UXbSw4ChqhcFev8W3bSwwE5ZcybcTHFquDwQ==@kvack.org
X-Gm-Message-State: AOJu0Yz+YIAFqDDvICg0nkKO8t6ALyUodCLdWZTyDCLcHbJ8DCv+nWRG
	GuLh9hXsymfNz5iNwqUClA2IEe4YzJUgofwg6QWS1Ip2FuFt9avGKu3/
X-Gm-Gg: ASbGncuPZm0br/BW9yss2iH9jHINJiXf0jGG0y5X1IztXrObobOHSDBYkUv+ALLdqbb
	32qMHzpzca781TTVx15Yt6L8MaIerHn8m+0CE+51NYVFw8FfmUBi07U1JxARA8HFOB9iD4zudVP
	0Ks6qy58Wv2tj7x3lEi+Z/bQSfpoqjiwsbi+eVDVHA4E7Q1pTmg37Jmpg8ntywhBZhevy1kZbW0
	t/L703Z6ccv7ntJOlYktzdjyXOSKw+SPyOm6kgtyPsRdDMOvhNhS+T5Tv+z8ZrdasyzXVi4Owe7
	decs8htedj4ktVFXk8aAdxu3dgAaZhew/TOivAfsuqdrplKwib69ATtX15C4Xh+dMnGgBPCL0Bq
	Jys94T71WW+KaKg==
X-Google-Smtp-Source: AGHT+IHIGQmG8W0O+2Vu70RarOUbKPKl/GJ5/m7NuOCVAVqJsmpKi2KtI5lu/0gEjf9/tM0Q/oJFGA==
X-Received: by 2002:a05:651c:984:b0:372:8cce:2360 with SMTP id 38308e7fff4ca-37609d685d1mr14651341fa.14.1760003170463;
        Thu, 09 Oct 2025 02:46:10 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5907aeb6b29sm857369e87.130.2025.10.09.02.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 02:46:09 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 9 Oct 2025 11:46:08 +0200
To: Yadong Qi <yadong.qi@linux.alibaba.com>
Cc: akpm@linux-foundation.org, urezki@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ying.huang@linux.alibaba.com
Subject: Re: [PATCH v3] mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE
 aligned
Message-ID: <aOeEYHzXUVOpu174@milan>
References: <20251009093707.868-1-yadong.qi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009093707.868-1-yadong.qi@linux.alibaba.com>
X-Stat-Signature: tpoc3ad85diuh8j1dtskfk1m9zp3i7w6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 901EA4000A
X-HE-Tag: 1760003172-589854
X-HE-Meta: U2FsdGVkX1/aAi9klOx8NWIA4ZMygXxglISJpz4aBY6n7ghYUF+qea+3UFapun2ikFsqPyHRHusooeloTQhY686rIjIcA2aub2ksv9A1+1EOhcg3j1tHRrmrLZR8Safb5+OecC1qpZeh9xXAsVnsM/thn09ebceLUnDLSqyJEq+9XBGfQBWjAf65eRAGTJTt84T/XjUn4V0w5RtHfAxRF2DiI2HZ6ddOqlcPU1rEnW/lvGYrwrgqdWagffbcVqGCY49cOJak91Zv7Mv1KGK8AOlSuJFFNTUx6UboM5bF1YHSFbkI4nv7AYut0O6UV4G6AOLcFHI7DzaCxdZ6VbngLXtDpwKGHkZpZsAy/pYTKxWamk6kB3QBc1/YEqvTx0ABLQzQovCcsG4zjPD1RmNcLAzlBe/FWQK5L7EtG/SZJKooAhKvRVcF5foHr+ROyyOepkmYC+HT/88t9D/2hpwfJfBH2Am5IHLss01a8BoH93dD4P1ShHSgKzcZLCuke2TXwhpcTm4DBl3Pq7n3Q3T8rmEZjwP6spfU61INaFnidDwd8pbnO4isA/Jw+fTGvldVY01FHh1UF3vhghQK9mqLXaXfyfUl0kcgHKIV9bTNXDJ9wYw57c23FT9DQsdrTooQcDFC4ZzppXF/lBg7+nMltJGLye3J7LAb6avsM2OWOGBU3WD9jZXi0Q7anNLY44ug0nR7WLGTaP0GZg6U0s0M+gW6zuiagkHqDDC5lRmqiGXvqT87DkfjSXhxAX6JspOhvvkqefIJdcKr5FObS/6XJ+mhYG8Z0Wm7//Xn/jA+hUykozTqyZ0t5FpAY9rFm6mVeUody4rZbwS2rtIDYI7T1obIHDD4RL6jlFaebkErTW05M0wXoKr+tIP3mcFVf7OZK9/UPB8P8RN0BAeYEpKQZ6itQjD6wriuVOkH+fgs13ei5UEE9HIvHUPwYlL1Le5UvxbtLV9JBD2reDisTHt
 mChRnfbp
 b5wH3n8dKl7wdGxHbebNTKMeBEDMlJO9lGhbYkgqdVSNvl1T7rCNZ5eCkicnQSxnZKj456Ek0btPeFloxfRYn0r1rb3u4JATceos8D7lDaYClSFBJH8TGfqO2IDwpw6eTUJtEccz0k5ClKjc1cxOMivAiljobIo/veRNoyXf4kRbRNeVjq6mg7n2B7zn7uIde4geN6hSJyGiS/6Tbl4su80KDBoSc+ShlAjsL//ufa974b50zEa7Co/0VKkqIBsoSkONsArd/h70aZCEsxBZVmkVXNulTt25mS4XVQG6/MhWQrpMpDM4sDNx2Kd8BnszRPhPdM5EtNup4QqIJdcldZBP9iIhit+Tpgv7OpuYVHz2/LFXaji25urrLvD3q2kYcfsl+mC9trcacDTPSwW/HbSFzqP9rB3fnlNyDZsPsX9dLIewI+QGvFtERNAKsKsP9GJVYAjwfub83/nQbrJauQAG6fQQoAolE4vRziexpePNOErcGQXkd4+earv8JrQOFiEpN9fUaEvM5i7NUKNzo/b/DCV67WCqMUtzq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 09, 2025 at 05:37:06PM +0800, Yadong Qi wrote:
> In mm/vmalloc.c, the function vmap_pte_range() assumes that the
> mapping size is aligned to PAGE_SIZE. If this assumption is
> violated, the loop will become infinite because the termination
> condition (`addr != end`) will never be met. This can lead to
> overwriting other VA ranges and/or random pages physically follow
> the page table.
> 
> It's the caller's responsibility to ensure that the mapping size
> is aligned to PAGE_SIZE. However, the memory corruption is hard
> to root cause. To identify the programming error in the caller
> easier, check whether the mapping size is PAGE_SIZE aligned with
> WARN_ON().
> 
> Signed-off-by: Yadong Qi <yadong.qi@linux.alibaba.com>
> Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
> ---
> v2 -> v3:
>   * change error code from ENOMEM to EINVAL
>   * modify callers of vmap_pte_range to handle return code
> v1 -> v2:
>   * Use WARN_ON instead of BUG_ON
> ---
>  mm/vmalloc.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 5edd536ba9d2..1fa52f203795 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -100,6 +100,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	struct page *page;
>  	unsigned long size = PAGE_SIZE;
>  
> +	if (WARN_ON(!PAGE_ALIGNED(end - addr)))
>
And it might be worth to use WARN_ON_ONCE() otherwise there is a risk
that a kernel buffer would contain only such warnings.

--
Uladzislau Rezki

