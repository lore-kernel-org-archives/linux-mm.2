Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E68B3CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 17:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 306E88E0017; Tue,  9 Sep 2025 13:18:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B14B8E000E; Tue,  9 Sep 2025 13:18:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19FDD8E0017; Tue,  9 Sep 2025 13:18:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0482F8E000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:18:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AABCE140609
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 17:18:35 +0000 (UTC)
X-FDA: 83870370990.13.C098FED
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id AB34D1C0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 17:18:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=LM0krupU;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.41 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757438313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jj/bcWBxZVXsXKGTYOIPhiO8Lo/tl7Dho+q4t8Y0/8A=;
	b=J4v2BirEEZIV++lyLosV1XoG1m3lTYH7zHngX2xX8mn5F98Bbcz9NnjNCr8efkFmQoBEmI
	pWs2LxLsGE8cLNRDX+RajSPl1fcFD33LkMxANEJ3zoDzy1OAvhMyN8IJmU/Q7ZdqHTSdW9
	IQZ0y0Q2YhXYCHCw7j6NNWXBVE19bk0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=LM0krupU;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.41 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757438313; a=rsa-sha256;
	cv=none;
	b=kHZzxZBzi6SLu722kdnsF2WI4QSVOyluV8I28YwA9e3HM/H+VNmMC5POjuD4F3c62gwb95
	GOXgjczXblWUWzH2G10HqEFG7o8Mx2sqIbJ9wC6CLBoCzJP0H54YAt3/NbDZQ9OnhWobEW
	S/ko8o6AmBPa6wvUv7GvCfPrQWclp6Q=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-7209bd264f0so71880376d6.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 10:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1757438313; x=1758043113; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jj/bcWBxZVXsXKGTYOIPhiO8Lo/tl7Dho+q4t8Y0/8A=;
        b=LM0krupUeELCDhfx7OgdzhkTdo7C3RLM2mDPntsVS813A2GyIT95SanYtly1Sf8jDT
         MQUepRVlKX2Fa019kbWkkt1MS3h2jCnoPqP/56ti6/r1RJBjr6/eASPEC5QZR8TIdKlf
         4SVQkR+DjSBnk75ceLqBet0whYpK8UVc0/F0Zg/jeKPNKPKuqpTbdS/wubEn+pGFtdyG
         5gSGhdmdkHUVIxOkPVQd5aCIma8LwM818kj3rTUhrwgh3T0DCqTT/ubNueKvwcDqwf03
         eZ47dEUScUYh4kl0/f6ucdXEhddJy9li1qhAx8a720VLHc5xqCmuBTIEokdRrUnQAe4v
         IWzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757438313; x=1758043113;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jj/bcWBxZVXsXKGTYOIPhiO8Lo/tl7Dho+q4t8Y0/8A=;
        b=miQBZOrzKA8RMgIgtROW9t0Tz5x0qpJomdQGW3xUy0SYa5E/xg8TN0WHcdqKMI5chC
         rmxRIp0G7FFPcz0W4ZxKbWF6lOssF65F3glZT7jljTKTQBZzpWzKok+jyXfaZrWuDd/d
         NRFrKci72lp6Y74e66zkyR2fTyMXrT5gQzIrKljqEuad+L2yFkwdK2n1BBffrvJzV3jZ
         jmDVMBeRYEd9VG5GoLLfqhpF/ZnKRPTwr+u3zqDy/1ODVXlSCmQ6HH33mpsoVfFUGscg
         WWNbY9DSdCLAEjmgBxqiLezZpv9evU0q1mREWprl+6DQQ1tbtSJQon15X9043ke3qnKK
         uCsg==
X-Forwarded-Encrypted: i=1; AJvYcCWho2H6H3x0qHesnIJVtDNg5S3/HX/M3+WQo3ZI2L6lQMj6ZtlhZ1Z63szb37itufVR96lH4AX4MA==@kvack.org
X-Gm-Message-State: AOJu0YzZdDxEmCUrrI8Zr69qP2RuHRy2q37664s+TYCEL+tnTyg/6DOv
	u0R/4JjtNntbwjjXV4OQziDUPtwatSBqU7g9jdJbM2e+ddyZNBmmlr+ofTUwOMdHO/A=
X-Gm-Gg: ASbGnctp+j7ZKqsQD+4yuzrhhbavW7yKDa1G/6pS7Xq9lya6q5Io7hgZd/PgrpX0qd0
	dB0OCCKg7XjP7Nmw8zApoqLXUBdfCOmGUnnatozvGnVEHIsM7w/s2rjjnqb86+TbGZK8IU4X89W
	iEW9W+6V5bo9g1XLOzcPxbBXHRYSjkSgRg1SwqHdhfR0Sc3qfMGsunY7/6ZJ4v2pQNeqq+UkV39
	WUVJo9+TnNexJzWAyX434KurO92ESuGsg7Px7x1UDIYknhTD20Cx+DjQ/b4BCagEfhFRE6iAt/u
	wG+FTM4gMzKdAog2ywSjCozWiv8XyzOezSIqF/qUp+tkzutrgzAy9Y8dGXWcRsMMO3dvfqY045w
	oHXIuRbZ0cRgLEP+KLAfG6/XGWIRljO/d3LAl9mWC2P5FDrVoL8Cpbt9Ncu0VOyA7iUHMSX1Xuj
	fEbmE=
X-Google-Smtp-Source: AGHT+IHZ7ehKhGwoOV2AVu3CuGxNBX69anZHCiUiB8Z3pbd8TMRLoLOZKTs2avizfffj+d8ABXY0HQ==
X-Received: by 2002:ad4:5ec6:0:b0:728:fe3b:756f with SMTP id 6a1803df08f44-73a1bd67b1dmr120979546d6.5.1757438312609;
        Tue, 09 Sep 2025 10:18:32 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-750486ce544sm28863796d6.71.2025.09.09.10.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 10:18:32 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uw1zD-00000003j9A-1xOT;
	Tue, 09 Sep 2025 14:18:31 -0300
Date: Tue, 9 Sep 2025 14:18:31 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: intel-xe@lists.freedesktop.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	Alistair Popple <apopple@nvidia.com>,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Matthew Brost <matthew.brost@intel.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Subject: Re: [PATCH 1/6] mm/mmu_notifier: Allow two-pass struct
 mmu_interval_notifiers
Message-ID: <20250909171831.GC882933@ziepe.ca>
References: <20250821114626.89818-1-thomas.hellstrom@linux.intel.com>
 <20250821114626.89818-2-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250821114626.89818-2-thomas.hellstrom@linux.intel.com>
X-Rspamd-Queue-Id: AB34D1C0003
X-Stat-Signature: 1zdc785cz9hxsymk68e3qeu6euamtkqz
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757438313-806280
X-HE-Meta: U2FsdGVkX1/kwBARVPre2js7I4DBeA1EUoCIlFpDEGSJmyPQww3x/0kwimdFDhSLY8WVvU4h21tVl4YK+LUHk5nqt7XAfXZz9CvYPlmBPAn4shaxGB4cjSfA/3bl+SI3ApMRvFJHRELSEuvf47utOZPfbN7gy4S0A7w9DRS5nvHvrkTAwYl/Xz4aqvOOIcxXIROni3NrxmIhefqGyhXIT/WOakdSDVJAhUrXUlVYW+e3S/bck1O/HOD7QMSpTVKEb2eRDRiqd97Cx9wCn4/ZbpN8jKK0bh80MpU7UVD/joUIfrclOendrm59yOOPuYq0J04T1dCtSWbNgbhhx6vHNUAnQwjAQw3NxmtVmbBfJPDs/koasCWONs+awoD5jTyNoZgyf2ksnvRuqQ6A6ucsoBrv4+RN5oNGZOa3F5Yzu9vCN3DkmkcJhTdvQZudVK5qucVlhTamA2tdv0zvbYxAC5LzDE+La1BQMvskiL89cL+0iG4/Obi0EPryujqJca0/5hoqe/FHZH2CP4fC5ndKEVE3RaEPtcv849ZG90NYx/EOXjelJRPdSsu1fhpIO9Kk7e6KNpz7/mURIeUUgKd+1Yri2c4xNCW8+IRcnORqI/kVGSS8i1I2PCwXxVet2EhGdYismyuNpKi7YniSfunbJUrETEHH99bbq1HgVWaIXxPaaCku3AMHfPHTu7jEP2H1GZadD/O+YpP+ZAziBTTnLrmVE1n0SDnRRdoQUeLlHU7wat7/Toso9EhN/WluR06CGYuJ2TB9+lV08whX4/80K0avOiNTq3++3i9IlG1BATm6yaOd/Wuba4StNTDaa5PyaTGggWa8b29E3k239nzSeyxFZBOLwTih65DY7YyC/OnVcrx0clHZC8N6ciyiilablMofYRHr6PxJ/JmtlMHPYM+N+ZqnN08CwhmiZn8XI+LhruMS3nBS7aVcu4FaDJ8zfqAQy+fWkyPtryNBW30
 v/jEjzJw
 A1a7S53x5LApCcCoU4qYDk+q4WPEK6Y1HuD+OlpOx77A2wKQHreYED9WflQF/L5gVpJn1GGY37mhfMmrbPpHgBionpBf9QZjAdqa12VSYhi1kpWh21OQre1OqCM1bv9e2vb2rN0RJJEK0iNHjiph/bbDTvXCXFZu/QrHYa+7kdGLpI5K3E8i2xuGJZgIwgGwbyXalCVNnh9LAhbmIH+rX/mZ5reQK5rXI9NjumwZZ8rMtmwJWJtjrUauCbs2CrM+6pF/JLFt6/D+QMjWI4ZW2ZUWcd7YI/0beryQ+U2V1qfTGRknFQiSb+axgghMjz7hu9fZaX4A6gCkk1UNWInwgCckrWd8a/ZXxt8iUW6qBoDFpC9gKz18KufnoeyRGlWnUI+ed/coEoPEQhUCt3NXf52J7+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 01:46:21PM +0200, Thomas Hellström wrote:
> +struct mmu_interval_notifier_finish {
> +	struct list_head link;
> +	/**
> +	 * @finish: Driver callback for the finish pass.
> +	 * @final: Pointer to the mmu_interval_notifier_finish structure.
> +	 * @range: The mmu_notifier_range.
> +	 * @cur_seq: The current sequence set by the first pass.
> +	 *
> +	 * Note that there is no error reporting for additional passes.
> +	 */
> +	void (*finish)(struct mmu_interval_notifier_finish *final,
> +		       const struct mmu_notifier_range *range,
> +		       unsigned long cur_seq);

I would rather this be in mmu_interval_notifier_ops, though I guess I
see why it was done like this, I don't think it is a great idea for
DRM to wrapper the notifier library with yet another library :\

Regardless

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

