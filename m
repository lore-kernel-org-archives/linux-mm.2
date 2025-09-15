Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 164AECAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 14:52:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 724D48E000A; Mon, 15 Sep 2025 10:52:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FB5C8E0001; Mon, 15 Sep 2025 10:52:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611248E000A; Mon, 15 Sep 2025 10:52:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2BB8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:52:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 069B313B840
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:52:03 +0000 (UTC)
X-FDA: 83891774526.30.D1C15D1
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2759C4000A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:52:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="kPN/GG70";
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757947921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qAlpp2q6p0FpxveyekskbKJV1WmCNzmzFjExvczEyQ=;
	b=HGVVT+sonP4iOKxRCHncwyCnZHUK233vs27Avmp2s9R2LTyTPaY/tG8lqsmeBzFENFHBUm
	HR2UqVmPbMJEbzzO19Emr1nVx9//oiEouPWsFcYHZMToohTYbRmrr6pa/SZgMNviuF03Uo
	nZuU0RPtHeCjwQH5AgUe6x4iDdgQ2Vc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757947921; a=rsa-sha256;
	cv=none;
	b=SyvtEx24kcv2urvw1G4TAvUwoooeneJDL5T4TX6aPPAMvy8Ypux+up6bNaEsoyp8fxvhk5
	Qb2VkPu35Fl0VXCGn/Oh55AIw56wrooDdDDFVjttNnA09QoODVGG8+nGcQ5xDf9LzPInrm
	fao+apO03J9iQ+uYY66LZL+9puJ0thM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="kPN/GG70";
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-63289cc1785so315927d50.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757947920; x=1758552720; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8qAlpp2q6p0FpxveyekskbKJV1WmCNzmzFjExvczEyQ=;
        b=kPN/GG701PK/Y23QoEvdEF8KwVK0AselkK5+ukIWKPlmULmKizJUkB3JiLE4q5rCsh
         o62775inZbN76QyClJV9sztdbSV+1S1/mjsw8y1xr7ciLxwrcJJsVReQfSAtakDf9/dW
         f/aSkHYEktfz3MNAQSUPLm3Y2aPoKtXNlXU6mXOzHg1N51LLJy7z86h5ixTDEp53cwm1
         ygZkRTYSjVJh+6jms4q48XRhM+bA1Ou0R68nXa1Zc1Q+r+xKqAfkKNBjY7n3gknqJJ6a
         R4dltwmYUCUT1sych2oGtysLlTTlZ05isu13GGKAXJpF/q/5xmbOAvQau1xzMk4/gEbc
         NpaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757947920; x=1758552720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8qAlpp2q6p0FpxveyekskbKJV1WmCNzmzFjExvczEyQ=;
        b=RG01QjTkjUQu0qsZRJ2g/58D4spoHgQpA4OZdh58ZjcQKNNALX6H5jwHTnheDq5Iit
         /+N+vel13+oYY8bqLNk3PthA8lFVwhzYXXQnJ9BVzlGIwazVJJksV+IcshOu07LFz5BQ
         IXYCjxfSjO8OqFZQ5Lz6x0dl3HHIJELEshDw5stUvVg164YdIt68D0msT1hT2NTPWHWD
         idRsExLeeGnrhV7N8vqgZcCl36em8ul0K/7lzPqhT9NKiBfT430WthtAPf0VBDLF4eR4
         epkNP+l90hVytzWtmY8jHlhYUgCbyzGx2gQR3STOZQ3Fk56SH4ehLzCXridSpAT36GyI
         qA0w==
X-Forwarded-Encrypted: i=1; AJvYcCUYJ0RlIae+l5yf1TZCkdnCnT5W4El75OiGy/b1pIAc5sb9yfWtMgl2ZSXi82cjGBKiRbN9fNapQw==@kvack.org
X-Gm-Message-State: AOJu0YyNCAML0VRu6luMp19eo4DSCHf8cVoA1Q+LdhQIbdvU6vF4ML2d
	WZG6PR0g34m/pSyyc8daqqxUxonrY62Dl1C/Fj9wrnKKXsPdqfw+yV+W
X-Gm-Gg: ASbGnct3y8SDAtm1EW+yCOQffomQaUR0kWtx/igsgTurLCO5Lk+zm0kXn9VBaHLTL/T
	adoHeAfytD2Be2sqmXGEGRccocwNEZyBCyHDnfS/KULu7itcXYfboIYKcz+yE6Lo8/Na0bQKbfS
	4Ph997tHEcdZOK9FWLV+6REOGREBGeTKrvSB0n7EnUOrjY10932Rj7BU/YRGyf4uWP/k4YZzLlA
	cFjiJAVIFgYmpSWm6vwc0e9CPvGDjF/Jbz2KyZ0MPxudrcOw2iqesF/lHK9Lwc4pkA2ne6DEw0q
	Pw9ad/amPimFKEkGQNFp1eN+tYEg3nzLFNyNqYTzLGCOrc/DeR6K8hIDfKrixuIdjx4x+0OJvXi
	9RFpWAyplA8hy/y68FFALmN78HmRuejXOYEzoPz2rDgEnzjjvbNR/20ShAHcWue0=
X-Google-Smtp-Source: AGHT+IG0/Tp3b8E0G2GYoA6L3RRR00/SCKeeLmJaTBzviTCWD28HNMqArXMoHbpYGOzCSnzzapPt8w==
X-Received: by 2002:a05:690e:1651:b0:628:10ee:ab85 with SMTP id 956f58d0204a3-62810eeb27amr7094360d50.3.1757947919804;
        Mon, 15 Sep 2025 07:51:59 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:2::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-72f79794201sm32181467b3.62.2025.09.15.07.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 07:51:59 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/6] mm/damon/core: reset age if nr_accesses changes between non-zero and zero
Date: Mon, 15 Sep 2025 07:51:57 -0700
Message-ID: <20250915145158.1425390-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915015807.101505-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2759C4000A
X-Stat-Signature: 9mein88a3ifzi6udq5o4pmz7ha6ojrtk
X-Rspam-User: 
X-HE-Tag: 1757947920-642553
X-HE-Meta: U2FsdGVkX19mUwOMihdFU3EfA0441BIPyUJgTPp+pu9HIqc7ltRcHXFnaW9ye9cD8ofT2a+BkMnvBYRIsSTdwDtZ+Gb15wuiI7WV8ThI6MvTTLm+3W2+ZaLbKNPXErCTGonrurWKAU3DUZ6LlBjk7eF3n8plbbtpmh1NexeKkwIZNTTVph6o9uNp6rr7lYW4mQoum/k06S5FelA9HWyzr5kgAjUz8wztUcDI1pd9OkqgivjiRDMA86hjNqjBz3t+gy9hsdAAub0fjuwBpPKDStUUDu0SEqB/O7oebMAFO0Tw9MxgfM36iUn5nI42loRUyHkF1ImoaJaDRjlZPQkcpnJnGUpj3cVHAd5tytX6eCKmgMPVEyY4SpOSTpKccB/FcpwQEDA96ekaz8jLte+H7ky53v8Ev0+koSVra71c0vq4f6XHkoGUN5AachXCqPbHvCBicKIk/YykgMLlhaf47V7R56HXQYIIJB0+rW+HvYZp5zMurimFiBMTWWHMX946dh7tLWDM+9oQ9j6o6EljuE048xGEvvRKarB1MZWxxAyJfZGsvn2MjcYMnvMaZUekgRTW3ewFb/Wm3IByCsqElgOlmUQOG6DFpxY9IHWgeCwwNUZQ+6xrB17aFei0OiOTmDDm9qmgCOp0deHlrWek4itGVBI+vNqQosboSU4FDpxB2Ubt9Rt6JHL2jdo9MrEcGfpGKGSEytX3CqLUhoKgjvxYzawoxNju/R221vdCyrh0HwVh7SAsOgjE6b6OvQuhIjMIAPjiHeGiLM3y+xULiIJ3UNIiaTqJU44eeSBKUWSr5snUpEg+UI0+6vJke9dtmYHU/9NeooXgkFfUjBCGEXPZ4ricFCFV4nmLFxjRfhZlwK92YahAiAMj1YMjUTKUuVJoXSCbUOCnz14C0kmvIZav6WzQHdewjNcdopRO9kYDuCh0nRBn7czr5LjpyX1d5yL95DzyoC/MCldYcHK
 s1VbHDCr
 q++HUIrhdAmkgvWd94J/+O2wzFGmQBGpu+n69L+EKtQZ8Ttd63RR3nHT9TH+YHiX4mxEjQ1SSUW7s7twwVj6YG523i2uGWTAfwpAOfX09U4Rat6uPnAQQs17vhW+/XpquCYh4hw3tnXm34fJC8WKMlLzrmQu0v2510a2p0c9YvFcki/+SnitRGisyZ5ofMnbAsZ9tq0ML0D0dzyiF31lsH5mczf6Awxh3IvcH6nKtvzhnzrX1otu6rj8WihUmF78qqhDGOZPpVCRofn0P5Hp1f5AemyFAMx2lBaLtbDHmVWv71wj9c4upSFlDpAVGBgae/Tb20FU4NhGLYTPGu4Cp/k4Mthku7fCM42+hzplID2U6M7lYlh6LhMwMramrz5sTXITqeBID53Y7M8+UVL5Rl+BSXhYyVm1/hPfWX9MUT1hSPQdF+ll/twAdgWpvq5yKU0LrZDvvtECTYGbL51xAUMbe38Asz5WdlEUOkPoiIttb+PUkEFbxEUg80OmE2wuBJH+TB9ivDNZ2JtmMaxp+jtVRZ+M1xuIa5/49JqFVmJpLPYq2RLivs1IDfk4YkbfNnFS4ysI373GMSVU2FNYtDZjJqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 14 Sep 2025 18:58:02 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMON resets the age of a region if its nr_accesses value has
> significantly changed. Specifically, the threshold is calculated as 20%
> of largest nr_accesses of the current snapshot.  This means that regions
> changing the nr_accesses from zero to small non-zero value or from a
> small non-zero value to zero will keep the age.  Since many users treat
> zero nr_accesses regions special, this can be confusing.  Kernel code
> including DAMOS' regions priority calculation and DAMON_STAT's idle time
> calculation also treat zero nr_accesses regions special.  Make it
> unconfusing by resetting the age when the nr_accesses changes between
> zero and a non-zero value.

Hi SJ,

Thank you for the patch, I think the goal of the patch makes sesne to me.
I have a small nit / idea which I think makes the code a bit clearer, at least
for me. It seems that we basically want to XOR the two values's zero-ness, so
maybe something like 

(!!r->nr_accesses) ^ (!!r->last_nr_access) or
(r->nr_accesses == 0) ^ (r->last_nr_access == 0)

Can achieve the goal? I know bitwise operations are sometimes harder to
understand, so I am just throwing the idea out there : -) 


Anyways, the rest of it looks good to me, please feel free to add my review!

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index be5942435d78..996647caca02 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2261,6 +2261,9 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
>  	damon_for_each_region_safe(r, next, t) {
>  		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
>  			r->age = 0;
> +		else if ((!r->nr_accesses && r->last_nr_accesses) ||
> +				(r->nr_accesses && !r->last_nr_accesses))
> +			r->age = 0;
>  		else
>  			r->age++;
>  
> -- 
> 2.39.5

Sent using hkml (https://github.com/sjp38/hackermail)

