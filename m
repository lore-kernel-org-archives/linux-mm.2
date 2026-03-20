Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62CA61098782
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA7E16B014C; Fri, 20 Mar 2026 10:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58C06B014D; Fri, 20 Mar 2026 10:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95636B014E; Fri, 20 Mar 2026 10:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9F9D6B014C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:24:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0BD961CC09
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:24:43 +0000 (UTC)
X-FDA: 84566662446.25.8D98C22
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id E375E8000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:24:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=c476tgvl;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774016681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30KemMRkEtWLEEtm+zy29OVZD4hupOCTeFDDhcAE2FU=;
	b=y9T3qyIE6esXsC/gfPHEHoEuf76/nnSFXOB20Ju2zzVnsdWjwfxytf8RdrJI2e5YOdpTOi
	K/gz4cYDYtRV0T9qtifkq+bHmeAW/1rb60X5/osZTv46woAZHV7cU+hGjFWKNRd1G5bQsM
	2wL5/njgvDpQvFb298L+oTti8v4ZHX4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774016681; a=rsa-sha256;
	cv=none;
	b=mZn84Rc8FZKbqDl2ebHETrXZYkSHdzxMGjSX8ZmMbch93gMD+vl0XbYrObhyUQLK3os5Cd
	sGhIO0f1iVc+YoQlVRM63SuFIJCD69djz/BkYki2M7+lezChANjQucJifxc0TmZwrHEuqK
	KyaNZRQrGOGiaGQ2a/gKSTMnP4ixPXY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=c476tgvl;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-899ed41208fso9714846d6.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1774016680; x=1774621480; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=30KemMRkEtWLEEtm+zy29OVZD4hupOCTeFDDhcAE2FU=;
        b=c476tgvl7iIuNlOcT3jOYkwTmV+KbJLmCjkFaVPeePStqlT9iAfzSnU96g3S+9ZawY
         BQx8xDEGPgGzUAyQDJaPkhmucA30J9t4G6fOaT9bUJ+fzCQPsgDVm1tza0sqBxZU+1r8
         YcUOPz5uDjVAO8t9Smn24pQ9g56V5iSf1BG6EpT5eJJGZzXLpOAp8mzwyagX/zVRn3l3
         sBuhGnutH9m6KdAUUx8HCZioe2Z8/HSH7DsrVmAe5Y5fc3feHUb+7aXPw35ypDMxXNqx
         Lb5GhVM0QF7/4Py9EPigxXZx4vHioPeX2YE2BOuAl/0f8IygD27ilqIH6ewi20Av0lDY
         EupA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774016680; x=1774621480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=30KemMRkEtWLEEtm+zy29OVZD4hupOCTeFDDhcAE2FU=;
        b=qKxdE0+a7TNkvHZnVfAEFscPhZAoiDA4CCRGwp8sZRQ3gbU8Urs7y3b3sozt+MOgqI
         mVouUvC7PguHg196if7Gw9oeDfB04d3/1KRImQup/n+SxuKyHoovHjar1uR+mqMM55BM
         1rSi1tjJY38erKcWBqmhKL1+vL+EdNHCl40KMNvDFBQQP933ea85qY1JdaxitakJS5dd
         8mlgMR7FYXLgwzVtFPBJ0gk04IFKgvatJDD/8PcJmcufX9T/vThOAPOPzQfqASwyluqd
         1xmAEn65F5Eq9wPHR8ASpdkuZHhnTlcrxctfhLC19D25zcWqjIJYctWBEByI8tB7061u
         BI3g==
X-Forwarded-Encrypted: i=1; AJvYcCUaBasjFOedRqVc5WihLWAE6/Mtxilu2VI8MFyzYaolOQEkdzRYnLuQKKWii3HhkBN9hdginu7XPg==@kvack.org
X-Gm-Message-State: AOJu0Yz4PkjeDPWONUeSWwnGNxj694hPXyP5Baxw8jKppMEOaYMnIri8
	yeK0m35+MJT3G3zmX50dxaGT1dttt9ctuhsiWQcHexhP2YfEpFKvfSroWfWZ9uFChj4=
X-Gm-Gg: ATEYQzynmR3BhfZvoZD44An2OQw4obUddhqbu0R23vqOc1DcUovPRHjqYTt9jsEHt4J
	KQhIFTVXodNe5V+F84CIGFcRluB6Cj5Yyn4XYVv+GbF/679gp7nXBhbhz9QaTN1UfUVm7hdMYb+
	0bBaz5dbVab7twELR4z9a5/LtqKMU6gH/w1NMVbFN4JNimBmU9dbvJZXiRcwqA1TSxLavI3gjhH
	XQDBEQI5pAJbzqVKeehhZI/XWGtrN7WGKrxFHBBlh5Q7H1U7P2fSApdWquS7JlaZtw84UD3qO7/
	5uBVHeOHr6BZcpkUj2vwhERAzbk/vxEl1IPqxp11Zt+m1ufd30J6Ym/RcMJS/Ovu9eqHNX1BtQN
	FCRvWKUe7uE7tqEY2fK2MeV49QW5JJabhZOqldZti/VIW5p6bIp4ZVD6pG/iMkZbL+qu4N+2hmt
	UoyynwkctuCTCXEjtAeE7WPQ==
X-Received: by 2002:a05:6214:8110:b0:89a:250:767d with SMTP id 6a1803df08f44-89c85a99c60mr40131246d6.55.1774016679860;
        Fri, 20 Mar 2026 07:24:39 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c85233ea6sm20900116d6.11.2026.03.20.07.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 07:24:39 -0700 (PDT)
Date: Fri, 20 Mar 2026 10:24:38 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, kernel-team@meta.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/swap: fix swap cache memcg accounting
Message-ID: <ab1Ypl69CTLA-nR8@cmpxchg.org>
References: <20260320050601.1833108-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320050601.1833108-1-alex@ghiti.fr>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E375E8000B
X-Stat-Signature: tw4csakwh8pwcxgkprd7j68aerp6bdao
X-HE-Tag: 1774016680-930544
X-HE-Meta: U2FsdGVkX18ze8FVigqiTMOpZHhdVZivp8myG0s9Mq5nMvdrBLOUjULX1FmBtl7h+sBH+04wWShDRGju0u6iPFsvfRic+xyyc0cn166kNVTKF6neDwuIBPG2+WHErbckyYl3IjQMgb8/VNE+58kpT3+w1MOiScwz16MGFwUg9oq8ifVy2sHog68xHfLF1Vgxj1VfmGqWDU6v9nDFQzZqfHTgdpO54fbMcXlXnpRx0Tk2k7mzQYhexWqjyVPIJWjUQWl4ECY8C3CBG1pdRJ/9fCN35q2O9O7b1NnZa7s9odsYa9fEIAEAG4UtfSYFBqvX3oRQ154ezXYFpWoyWrj1LI46dEfdHm1+TjqaC8u97Jn/j1FxydIM7yokHztm9B99QiWrGWu7lPpttEu4mP2ZeERDGio64X2FkExLzwMQYHZycglSqWG9sDahlj/bXQa7qniokeakkafJAFI9IZuaDuKybTUHSMGWEOQGizdDcsMocHO2N/NLFL+ly32bYMM1VWpYH5lAad4fS2vxx707CcnHFzLnfUWRY9MA49kNaM84PN2Ad1tPbB+bJAplLj7lXFZxzda/Ia2FIvtE4KdAd3hWv6bpO4zyBgG2oWLb+wECYYKt0RFp3IUxh/6yYSq2CCUIAJ+wcU7Wtyf7SYVHsgClZ3aPvdm6wrcgKQ0lFWVzn66i2Y8AMcoA2fnmhsOVyF24P7+Bu6XmyziT/E4xCXdb0L+X4HlLoSYkVS8IuPTVC0emRoDpYhFA5qQu9CBYfNFYaEIXopNDQNCECMFPxHeVLXBMcbL1XjnvvKe4w50joRwQ63wTMnLixBoXH+/0KQhA24Q9fkN0Sc+sfeGZAM6+rCL32to+VoJrzsLnodzZzYv9bIQEur6BC423RZ4GvKzVoRk4veqLEpxOqWrQczuE5w9aNP1ffpIGrLquDbi2ZEZ0EaJHD7OPJGh01cyEs3rAg1oknk9Onld9zej
 KATs4ZZF
 1Bad5X96Jm/6zdKkBT+C9G8X28TRtPlGcvZW8sXybwHM0Dk52yh2cvfUEQtDGhAoc4mpaYHLG41PQrGBHhrEcm5SfA+JmmY7h1UxTmRDbrzGdT2WuJE2+ran1F64nhs1W9H79iRksX17FNwqGjgmwuCkI7xsAVAHyuUlAKPPa3Mz1OUT6dAdHaKB8wNabB8jOuvwMjCODTgWnR5lj5blHxgbmsCgO+/A/P9DMDYkmCj6TZlnxKemphUjUeXVjhWKcalif4kyJUXB3JOV3Ws7RwDKOAUFzYb0mhSh8hB5TcRtm9OWxg8Fzqbr1wqJXCGH4NAv0VaZLguqcivL/rd3863WZhTJvs8MURukNio7KDRxCWlP3ThEs0NQXQiXQu3z/QIyTk5QHhlu5GNzW0FOGIeXEnSFdqKEOY/qRuO0N1OgtLtY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 06:05:59AM +0100, Alexandre Ghiti wrote:
> The swap readahead path was recently refactored and while doing this,
> the order between the charging of the folio in the memcg and the addition
> of the folio in the swap cache was inverted.
> 
> Since the accounting of the folio is done while adding the folio to the
> swap cache and the folio is not charged in the memcg yet, the accounting
> is then done at the node level, which is wrong.
> 
> Fix this by charging the folio in the memcg before adding it to the swap cache.
> 
> Fixes: 2732acda82c9 ("mm, swap: use swap cache as the swap in synchronize layer")
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

