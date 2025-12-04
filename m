Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EA7CD2168D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBE806B00B1; Thu,  4 Dec 2025 10:04:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D481B6B00B4; Thu,  4 Dec 2025 10:04:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5E406B00B5; Thu,  4 Dec 2025 10:04:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B446C6B00B1
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:04:47 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4F8D1139A40
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:47 +0000 (UTC)
X-FDA: 84182110614.26.8541E8C
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3DB95140018
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Sn2xOGuT;
	spf=pass (imf23.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764860685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LX7F8EnGPs4lEcXvyS5uWsAw+PN9HNPUTl46be39l9s=;
	b=M1O5Ub20CD/1jHPgOMm90ZkkLqQamMBnhzcp9lWRmltJAVIVZ4rXseNOQh/oalS7DHlcgW
	hOVHPPW7RMUSXMY2kT+gSy52n9bWd/eHTGTD0ltbgMJ0lnWaQX2yMffoQen6o0drc467dp
	kY7K+LD2MMSPEJkb78CBG2FE5sHa/9g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Sn2xOGuT;
	spf=pass (imf23.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764860685; a=rsa-sha256;
	cv=none;
	b=AtX0irLvqMVZOzK2z1rC4qwfSZBrUzEO/fgO5wmFfHqJ6WGMTDTSLiD2ULfOcUJsLtbSg8
	M3egzhJk4ure4xRuMkKluZf2QCZ353U8iqjwVSP/kN6NSBe/xCqKCQbZsqX9K7ZObRAj5M
	7Yc19NZl2Y3GH9Knm4LPS54EW6wmxjY=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-477b91680f8so10495595e9.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764860684; x=1765465484; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LX7F8EnGPs4lEcXvyS5uWsAw+PN9HNPUTl46be39l9s=;
        b=Sn2xOGuT298iVGuJNoJXq+n4k7H+owPa3joiy4+Kse61qVNHFhreuadn68dBMQQh1U
         psYFovCd442JW5iuLgMxkggcqolkP0Dh9+g1UpUhKtXQDXI18ADQOY1Phna/Dkl44zlV
         g/aK0EH51A7iYyWbBl7Bx9cnCVy+B4uQH5CzGRrQ3N6wtn2iQ/WEgN4v9VocMZVF/33L
         MWXiRptXOr8gbWHM4tBcFKwg5Ta+DVp8q6hQeVd+JfQkBeYCe7v7GXTTY7inYvU67Iez
         jv6Z+tyNYPMhRsPTzbDn3wt0gHv0ThYV88+ddhLZ9tYvRQ3g0UpHIb4EduMWgcg4LQri
         uMmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764860684; x=1765465484;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LX7F8EnGPs4lEcXvyS5uWsAw+PN9HNPUTl46be39l9s=;
        b=JEwBYDXnPDZbwz7QQRVKxq+iqhdM/e4jPZsK2ZJCnP5GZYT22A0m5SuBIh2LrkB0Uj
         ctKm8CrZ/m8vFjYnuW80heB7zgDjApCJX3drzz0+CLyEQvF8J7kCj3Ipl7plzS4ouUwG
         1gecfEHIV4yBMEXcbNHDgdh/bGLmjgzbPpRNCxrIWX/GegDx4eFiAiIcGSBm0jL5cp77
         57nhpY0hv5SVTxdaE09KLf0/XpYIro0+ftWuK0IQQ0Iz2uUIwaInNn+axiMfWn4YxLfv
         iPgwHcIDtL7i0d2NbzQ/yjDU8Vt/mans2cAv3nyQfUsp4Zt+lRxghrxI96Z/M8UdwiiW
         rbAw==
X-Forwarded-Encrypted: i=1; AJvYcCVS6haXGTPbhfOwug+4R9Xi3xgfCm7qWAdUQjVU3EczFtcwiA+mURcafwib2xvhpRSFj1qGRfEjDg==@kvack.org
X-Gm-Message-State: AOJu0YzyvJPtGhVFCRGkSCCO6inY9p4wCLRVl8AKLrmkcST1m3ObnaZ6
	DquAmmXHQpZqE9Z3S/xZJTzUdYVMUzFRpXIe8ntDS6Ne46tGmCUmGqMFRHmpx6Rlmvs=
X-Gm-Gg: ASbGncvhC/Tlp31uelKGNNYzbY/5ser5VEkPO3rn/g/W4APFnzDdl2HaK17glyGsZAR
	p0kDgxLXXcSd6IdElmFM/upabDiPJxhIjhQRxs3oUOIztZHIxACIiWET0nHbIGpsn6zpOcKp/H6
	BteIVcqpJCjK8rb0s7VCB0BQbsVBT/zwjiycBO/KjDRIlQXnhQNcvXOcUSZSMtJyO2Xf0MwT3zE
	oQPWkB83OHKUW1ggGTXH00EuQQxUzzU9wWt63N/93EG+wca/mEajeq5H7N0SF8kULqn4EP1u4kG
	8FsYODOHGuSbMzypIsw9JXsBdNaTJJMRlTYEMXCDBRWk4EK4DKBZs6mRRoDA5gOhCSJPDWGNZmJ
	swYoFEdrmpbCp4UZei8+ijxlK7zEJYnAxSF0RBSn8wWepbZbrGPPRN4r8DkdiIQkHst+R2XWZqG
	YKNQeaaGjfqT6nPzGW5HZThJSqPQwjgXo=
X-Google-Smtp-Source: AGHT+IFnyscrwkzl65AaAi4UQZiDJKmqiyXsvifrqrv/e75ucjpUSFJYwRcAP12w9MJC6xJxQ7PXLQ==
X-Received: by 2002:a05:600c:1907:b0:471:131f:85b7 with SMTP id 5b1f17b1804b1-4792aef70bbmr86623265e9.15.1764860683713;
        Thu, 04 Dec 2025 07:04:43 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b152a68sm38677005e9.15.2025.12.04.07.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 07:04:42 -0800 (PST)
Date: Thu, 4 Dec 2025 16:04:41 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: tj@kernel.org, hannes@cmpxchg.org, shuah@kernel.org, 
	roman.gushchin@linux.dev, lance.yang@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] selftests: cgroup: Replace sleep with
 cg_read_key_long_poll() for waiting on nr_dying_descendants
Message-ID: <ud6wzhszf5jwg23c7wtq2wfhwann2c3uuib2bsx2ty7sd6x6ym@3admzvaukqq4>
References: <20251203115631.947908-1-zhangguopeng@kylinos.cn>
 <20251203115631.947908-4-zhangguopeng@kylinos.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="254t2h75sguwzjq3"
Content-Disposition: inline
In-Reply-To: <20251203115631.947908-4-zhangguopeng@kylinos.cn>
X-Rspamd-Queue-Id: 3DB95140018
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: nrzn59yum8aow94m11y8yhczse3pq1du
X-HE-Tag: 1764860685-443284
X-HE-Meta: U2FsdGVkX18M386TxB+WD0W2w+WMkb/KUdngjWln8UM4+OwpNhlK5RMNMM31k7YdQpbDPOyQw+3rTMjJITpYLNW12XI4AaptePeuRO7Nd/WniBvdpTNQIzvQY+b+KNjPVG+TNI2FAqFTFHuy91LVtY1mc1aok3QPM7zN45ylUGyi4+gvQ7rrRA1pOpSuGvsA82MKEPszqhy0TslEBXv6y40NDfhEAcRNEfXBqO76sdNj8/U+saAwChrc0Ps0qYw5KjdeVktBizRP47HusKmXcMmkLSJWLKyxRWSvad9ftAk3LIh24BpViiUqKdvJePOFhnJxfpu46x68B07DZBYF783euYNslqzNzvYkiFpl4w7LGEahrWSE+zclumemWxezY9VIelhmCroxf4CksuEZQGk3gcGfo1T4AjPGrRDuI7MGUy8WIU+494ghQbD8NYlpTZtZTkWF2o8xuwQb9rYyW1TJY40kW+LZK5DdUSlQtHZjgwuW4GIhrCBMUPw4Ip6gHwBbQQZPYh5f7SPFmjp0t5K4V/12huNcVV7vYYZqOyghUz7AejVScZVGwe4AgEkWCD+jwVwrtZsa+o7nel8KOXepVNt0t/s9ts9Cj/fYoRfOWis5KkOtI9anvMrXGZrA+P4rOanOu8gE/nSFtn0zDw7LXvorU0o8QkLA/ypEkncqM+h9n4WZyri4agBPjWeXSlX7XlKY4I244xt1Rfw8GKmXfQoiuCWAXDanumwDI1iiLnhD25YgWa0UuXgH+6UPy7JKE2BEGOAiFN2R3XXlfIABOq4ujvWEhxx3YqnA91Fp1zD0h7v54mn454SA0Lq4FhMkw9uXNKXODgfSpE8B/wizyHxzcgGDQGtJpjaowDidEu7WQx8ZJV9SiFo6aqSu9qX2Lz/zPkAu0DxrJVD7xxgHyhBceYc1sSn4mKCHP2nexuvFwe2OkgEgttoC1zSRAHP98q/S7nDuNYeFb8H
 hFIqJt6C
 nhD7XiLqH7lLkz9tzOhHZLG+rC60govUq+PFJ9EtyUI4t5QSuRZ8QOjGIK0yurXEfdjEPiMU4hdrSjvfsOC6JElZ9/X1vVELal1pasMAK0Q8CpWcV8lGpT7JnHw5Xj0t971ET3KTId+LWi9nYqYCvuWnutfBgQIVN+KkVdAhBytmg96OkaWV1fD2syqJ2WWlHKkrM2p28Bcid9UIxAjc8xeeq/YEh0nomstR7z8Y4+r0rlmuka6HFerg2Gs0arkEDrHrquRFPTl4TfRRkiIstOlx3YyILoXFseCOrVAfHU+apyuLn7/14f3f9xhPkd0iiingH1KdPJF1QEc/QXnGxwNoI3UiDLZ9fpnyPtI3zwKJO2Ab7GNvfWADXfMtHdPoF39vZhvL/WtQdalhqlGbBhnJelCcscAWx77NIaNymQh3nqtVdKwQrR/DqTF8j9Qv78Ufa4OUh1D76O5elmTZc4xuMqJL+iZTWA02/D3pyDKW5gxDMLhA7EinTGzSjsyNpGSVlHtY/ILNU/xppDFxBx/YMUr2ETqygw2xC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--254t2h75sguwzjq3
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v5 3/3] selftests: cgroup: Replace sleep with
 cg_read_key_long_poll() for waiting on nr_dying_descendants
MIME-Version: 1.0

On Wed, Dec 03, 2025 at 07:56:31PM +0800, Guopeng Zhang <zhangguopeng@kylin=
os.cn> wrote:
> Replace the manual sleep-and-retry logic in test_kmem_dead_cgroups()
> with the new helper `cg_read_key_long_poll()`. This change improves
> the robustness of the test by polling the "nr_dying_descendants"
> counter in `cgroup.stat` until it reaches 0 or the timeout is exceeded.
>=20
> Additionally, increase the retry timeout to 8 seconds (from 5 seconds)
> based on testing results:
>   - With 5-second timeout: 4/20 runs passed.
>   - With 8-second timeout: 20/20 runs passed.
>=20
> The 8 second timeout is based on stress testing of test_kmem_dead_cgroups=
()
> under load: 5 seconds was occasionally not enough for reclaim of dying
> descendants to complete, whereas 8 seconds consistently covered the obser=
ved
> latencies. This value is intended as a generous upper bound for the
> asynchronous reclaim and is not tied to any specific kernel constant, so =
it
> can be adjusted in the future if reclaim behavior changes.

Great!

>=20
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  tools/testing/selftests/cgroup/test_kmem.c | 33 ++++++++++------------
>  1 file changed, 15 insertions(+), 18 deletions(-)

Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--254t2h75sguwzjq3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaTGjBhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+Ag4/AEA8vnYZURHlpYUdZIwoG6K
cj1NLOcwOwt2c17lJN9cY3gBAOy6FJ7n6hKdI/nDTvB65mNiVjVrKrmHDFdRgBX1
GTQL
=2g5W
-----END PGP SIGNATURE-----

--254t2h75sguwzjq3--

