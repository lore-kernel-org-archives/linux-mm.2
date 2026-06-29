Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC327C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 04:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D3176B0005; Mon, 29 Jun 2026 00:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 680FC6B0088; Mon, 29 Jun 2026 00:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570DC6B008A; Mon, 29 Jun 2026 00:39:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31DE46B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 00:39:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 87E92120539
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:39:36 +0000 (UTC)
X-FDA: 84931696752.30.BDE0E53
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 894E3C0007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:39:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=wdatYWDu;
	spf=pass (imf10.hostedemail.com: domain of viresh.kumar@linaro.org designates 74.125.82.180 as permitted sender) smtp.mailfrom=viresh.kumar@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782707974;
	b=2+QTtiMLNIsXFnkJY93OIHfAjkVQGuJ4I3zi+YbgLVrSwrqqUpwVUbbAvm9vliiGeJdK6L
	rEZf35POFzoQ8kYccQQeuhxPrguS7OvVNvblRVvnmNOpp4/KCX1lT6X4p/F/SngDjhLiwA
	sP72LztR3X7SCvb2JdmCoXyNqbR236k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782707974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tAkDY+MQvqYfr4IaXyrXZrjWk09q7w3/qlUx+mpeOiI=;
	b=ZSCdHpwTl72oyzStNtl623GAj4PYV4pXlMJ9EAylr6xElZiuE4kcZ2OxYseRbzLqJi9GqX
	U9B1CjffE+L2k+9OWc0rw3wbsip3yR+lkYopuhoMvYLHV2EQRv00Tx9tlEmKqJEnWRr8sF
	crcva5HTbzxaUs9K9jRJd0N3ZZoCKAg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=wdatYWDu;
	spf=pass (imf10.hostedemail.com: domain of viresh.kumar@linaro.org designates 74.125.82.180 as permitted sender) smtp.mailfrom=viresh.kumar@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-30e18c3e0b8so1381669eec.0
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1782707973; x=1783312773; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tAkDY+MQvqYfr4IaXyrXZrjWk09q7w3/qlUx+mpeOiI=;
        b=wdatYWDu6SelYv2O7jKYGltpm6RP5MMqNBka18KGrgS3XSXQ4ek1z86CoA+w13hghC
         NXzB2aR58Fusg5nXHMlKX2hrkf+xa/ke9HshO6RmmtOV5E41Owi+W7TKNkMnZy2rm2Dm
         e3oon3hWsf1BU9i9zTfjt+hD+RgW8C4gmM87CilpNOVQg1wmZHRr63QIKRSQV5haXP8A
         2CTqdIsyzSi7sa+Cb72K5UhjkQ4FI60NMPT5R68LGl8DWyHHSUYnzh46K6gqtdnb+9Kp
         c9PmCRIyGCcQ80mPyrFW/mePMXMtr0dvi+7O539pHYL0lPEMjRMlSELW7nQW7m1oZYQa
         lW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782707973; x=1783312773;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tAkDY+MQvqYfr4IaXyrXZrjWk09q7w3/qlUx+mpeOiI=;
        b=Ng2eDmDgCjwMykVYhh4NaA9oO2hzgo5c4CLgwT/UmhKDjxYeLTl4MEJ/0uGI4t2FiW
         R/Wgf0MpZlG0OfV4BcSsaj7sQA/ENUfw04hz/NqKZOrf5ZEgREubXzeZOup1+knMruUI
         SXNGp5eMQzSQMvwgGttWmgFH1wHbRUAMHPJufvJR9heIlSbkUDqdx9qwoHMkuTBSDGAS
         F2WwYsGAcwkqF0uVnVq787y0UNO8Zzb7382N/omj2Jt0giwlo7iMVUr+n4rYpWoVSDoH
         p1MU7xcp6GyXt3F9vYCkIN+LqYkch+rwqOfIKhTZ5ARVaR0T1dsiobjUjmKLX0Z+19D7
         xycw==
X-Forwarded-Encrypted: i=1; AHgh+RoxAYil6y91pIEwjPksLVUgoOSg2fndWFwBdec8G9/RyyZl9S9JwfOHY6qZPMnNYdMGHoan/alfjQ==@kvack.org
X-Gm-Message-State: AOJu0YzMNVFM0yB0bHsny7Lz84SrgCqv9dTLPcbat/bfq3BMkiPRY9/8
	UHUhMXObIGZi53y1VxwUGFn6AVPUXjg/qUmvUxmMblpb2hOZz9qdmcNCtSmEr3w+MMI=
X-Gm-Gg: AfdE7clgYjh3Kgun5FdQozJ5evg+ioQ4Tcqbdq8oOEk2By4Ny0xPRVIx0FPziNf6liK
	ELmRHhpOXVvHL+F6hT5TmxvDHPAZz0SN5QDu4HwfocTwqeAn/pGqmes+TF3eDT1MrklfR4pdBM6
	Djuh6d2Z1+7aA2zGhJ2C3rR/T0d3xAiY+o49A5CGsxRksFvACS3d7VxcOw+Xqi+vn+nhDvDCdvd
	qBWGbmqThISKVa+mJbK66XQQKNsjAG3OyKZ46zcUAkUcbW1LFCRFfiZzlLG91OCea4aOxgsq2ae
	U38tyvBqgP92md15X6LKVcqX4pGCZ/pbp38wWrQ3Q4SwUvkRCRBgsXRwCsHf7AEoEauR8Qf8IQJ
	q1zV7dzj+F/th3QVZ3vM2Me2/fzvjN+v0Z28CrbnYUDQ24voAhqWajCF0YFl9LHirzNVJWVE/pK
	9z4iHRYVYxB+kW
X-Received: by 2002:a05:7300:5341:b0:307:d4e7:b177 with SMTP id 5a478bee46e88-30c84f3cb8emr16773092eec.16.1782707972936;
        Sun, 28 Jun 2026 21:39:32 -0700 (PDT)
Received: from localhost ([122.172.82.94])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30cac1b9751sm23319860eec.3.2026.06.28.21.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 21:39:31 -0700 (PDT)
Date: Mon, 29 Jun 2026 10:09:29 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Trevor Chan <trev@trevrosa.dev>
Cc: gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, 
	ojeda@kernel.org, a.hindborg@kernel.org, paul@paul-moore.com, aliceryhl@google.com, 
	airlied@gmail.com, simona@ffwll.ch, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	igor.korotin@linux.dev, vireshk@kernel.org, nm@ti.com, sboyd@kernel.org, 
	m.wilczynski@samsung.com, boqun@kernel.org, gary@garyguo.net, axboe@kernel.dk, 
	daniel.almeida@collabora.com, shankari.ak0208@gmail.com, lyude@redhat.com, j@jananu.net, 
	lossin@kernel.org, acourbot@nvidia.com, markus.probst@posteo.de, 
	driver-core@lists.linux.dev, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
	david.m.ertman@intel.com, iweiny@kernel.org, leon@kernel.org, bjorn3_gh@protonmail.com, 
	tmgross@umich.edu, tamird@kernel.org, work@onurozkan.dev, sergeh@kernel.org, 
	matthew.brost@intel.com, thomas.hellstrom@linux.intel.com, jack@suse.cz, ljs@kernel.org, 
	liam@infradead.org, bhelgaas@google.com, kwilczynski@kernel.org, 
	ptikhomirov@virtuozzo.com
Subject: Re: [PATCH v7] rust: aref: make `AlwaysRefCounted::inc_ref` an
 associated function
Message-ID: <xak7wil2w2wdnmkfh4e4ijhlgnudzuh5y3ltlo72454e52tocv@434kdjz2eupv>
References: <20260628100731.64885-1-trev@trevrosa.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260628100731.64885-1-trev@trevrosa.dev>
X-Stat-Signature: wcniye5d5j1r8hc1kokfzzi6i81iyzsn
X-Rspamd-Queue-Id: 894E3C0007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782707974-894841
X-HE-Meta: U2FsdGVkX1/bn9TAaiF0P+ulA1HWXGbMV4JhaOg355dmtilzEkpbw4w8jk9UjeupS5jMdxPlw1I+ymsAC8Gk+jKKCxr6zZcOzzHNqk69Uv3nbdJfTWY3Alu3Zptfq8sN0Z+iqHjPkObUeDCN9oivmHWwCzG/u1Jap8V42Vr6ne1KRdlED02yosOsavL4/D02b/sJLSKa7927ts/zU4Hl4qFzpTj8wrS7oZEyBQUQvNC7hp4wGDUfzaP+k+EgzU6gTnqiXeu/mqOVG7jCKTQ1z5dH/LDGoUbzMCfCFsG9mydJL99U/B35+OwDEPDA+OmLFHXZkGjHXuFax9k4RKAQXT9lxUj6dyogZakSzPi3YpYDuP3FpEAXdvlQgHNfSB15XKZSI68WeaAfLMIIo6VaKwl9QAoBiileSHIQJs4pSMCYz95XOQwTVAcr+KLQ7T/GtXv8Ec9Uial8Dz1YWCZFGu8GnjQ4o/q6aEOaOEe7B0u+2JBnB2g2OacvN3dD9CJ8BqpCnx9UtucOzMAhRcJM2laG9zvVl288senNPMKE8LbgOGI51gWesWkvT+qw1fUKQuEpyC7vhSv+haHj4mNc4AeOORn7CwomuPEExh2/F5yGn50MnQrOLJit+DKB3qp0bu8YE/vJbvhTPZxxnmuqkKdaF5z7qikoUqVWKhPWiRAszQ8MmiAwCvv9YC4YKCYbiCfWqE77dp+rtoRCWj1pNHlNYzuMqNGf88ls2TNJUpUSl72L+e3gZl8HyZBrQYa2qdLqS/QnuAX4Sm4mHfzyP7u+XVe7IznXode84CPA+KFczho+7zMDJ8LVeviSDKZqQxE+uv828BBVYPi4JVvih+9WUV54MefZlQo2eA4SgcVZJA3t8LspO1yzn81oVutL2vnOfIcoLuBWUe2DQj+cF39qgUqIHJkM6SJ6HluLWy3C1XBzyT4hE+uLcZwdpOL2dszN2WOGCkUq0t11LAF
 netyeo5R
 lDV2YKdI8nfKmPILJDrFei5qUhJFfBzohXVS6qbyNN3Mp2EB1rOR+CPz5L22vd0O+4zeCuqN3tZ+YTzmvoV7eXjGe4Cksz6iVC7PhMYjY9A7h9WtAqsWVlZ0NfWdFwgjKvFZz8ZSiVseq5d5pTNy6zz2+oda/Xz/Ak48xWkmXRWr6g1eX4zoQ6R9gf8RFAnMUeMduhrHmxkeqLkBoe6sYO22bTrPyfNmfoQMTnv4VCpjAr1bPet/aylz/bv5fx7NhRe/YQwYvzbTPBjgdR49xVH9Dr2gZAMOKyawNJyubTm7M9xoj4BElXauzOOsKMTAo43jH8SaO3zykNeAPYWHWC7DI1/t6/A9a8rvj3OyaLkeDzuSqYu+hn4e+EDLx56jwOjxC1VWMRTT7dT1MOheqGYtD6DtHi2vz6tvdjNrbsA+DsYoXTL0EZhsasfAjR24ObvhrjvZjtnGJOG8uSlxkri3WnvPNlZDrP5ZJBVNwj6sbSJWCYcbumehAdrPB6GyW1wD0LGlfsadkoPg0rW6ymyuz5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28-06-26, 18:07, Trevor Chan wrote:
> diff --git a/rust/kernel/opp.rs b/rust/kernel/opp.rs
> index 62e44676125d..84802f22b652 100644
> --- a/rust/kernel/opp.rs
> +++ b/rust/kernel/opp.rs
> @@ -1043,9 +1043,9 @@ unsafe impl Sync for OPP {}
>  /// SAFETY: The type invariants guarantee that [`OPP`] is always refcounted.
>  unsafe impl AlwaysRefCounted for OPP {
>      #[inline]
> -    fn inc_ref(&self) {
> +    fn inc_ref(obj: &Self) {
>          // SAFETY: The existence of a shared reference means that the refcount is nonzero.
> -        unsafe { bindings::dev_pm_opp_get(self.0.get()) };
> +        unsafe { bindings::dev_pm_opp_get(obj.0.get()) };
>      }
>  
>      #[inline]

For OPP:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
viresh

