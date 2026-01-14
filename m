Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E39ADD31A0E
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 06:28:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3438D6B0089; Wed, 14 Jan 2026 01:28:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7A56B008C; Wed, 14 Jan 2026 01:28:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8F26B0092; Wed, 14 Jan 2026 01:28:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 072776B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:28:10 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 99E4D16039C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:28:09 +0000 (UTC)
X-FDA: 84329589498.18.09B5140
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id BFAA91C0003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:28:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Zm0z/qkC";
	spf=pass (imf20.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768372087; a=rsa-sha256;
	cv=none;
	b=wU/eUzFENNyrLElun8Oekw1vyXK0dEVWj3ZQtysxTd+zVw9DiuZQAliwcGgB3qWWv8WAyO
	mF50SZqaop9yU38viUSdBMXe82JE4lNqrT+7IpNvZeYAkamt1aXYEOdovYbAwTU6C5xjC7
	v/o3YZWipOa3f8MHEm1xCPba8/m1+r0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Zm0z/qkC";
	spf=pass (imf20.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768372087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wiYiHrNDixSxXYp6RTyIy2kKNtBFyrMlCzB+T+XzHow=;
	b=41xPQB5udh+W63zIfa7UyEwqadfzH6l2YuRZcVZ+2eTt0m+wtWmp66t702FUbcF5O6/+fD
	I43UNAI97oGWBp2U6uqh2itwwloURWk6NIvyr2TW8Sa0SKMVg4thrAmaE/m1G850ZpwgX6
	GlJx2xL7yOaxZbxIsfm0qrQdKP8esuw=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2ae57f34e22so9116698eec.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768372086; x=1768976886; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wiYiHrNDixSxXYp6RTyIy2kKNtBFyrMlCzB+T+XzHow=;
        b=Zm0z/qkC65P2LYS6opRxEee0aP4SeHN75BE5kVBgEMXfE2iPHsmCE8gA8408NdYe0L
         nPLwrO46qVSt3eIPMzcNwRWy470vJxWrTW4eqa98TaS9V6ntIJvPnp+7+A2/1z+VacXB
         bhiel3OYU+ZGfilzBvqu6lZASp2xIWW3e5LGoUpqyiRh0Br9y9tavVm5ZxLAAXzjMnDk
         mF2Bm+zQlAaSEhTsfZDyHDq1HFArSZcELt3Q8L2U48IndGVISo+zRasmynxTv/BpJDeV
         gQwXEatR+cJ8QfcsTiVvDA7zIZWM+KFBrLcATDbvvN8Th2QrufjmUGx2blIZKnn9kKIL
         WoTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768372086; x=1768976886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wiYiHrNDixSxXYp6RTyIy2kKNtBFyrMlCzB+T+XzHow=;
        b=Gk77T+/5BKFQg9RilJQ5uI3lCuuKyJ3Y/hpOQ4CjA7vGmFWQ5Y61SJasCDHpT5UgMY
         Z0vSiB+7ErHGhHYfNuj6bhhRqxGqSFxwu6xiue2exUl4YBwHxbRl4EwlLqQ1jXB1KpQH
         bCF+DtYkJHTXrGdrsOkhJaG39wIyd1PUW+buZ8Q8ldFcCIdOKo50Q3sZfED6pHbi0Rf2
         VE8SGT868L6rDBD59JwMZFN2QNFt37pLDroeUIqCUPp6iPVMAZSXsRgeV58iG1io7wbB
         tC7t+fsUOndoaJ3dRUYpMUkARYBm9yX1rPCwSLMGWXaHz5D/4GMjMJOquWsPPh7G5G37
         l6Xw==
X-Forwarded-Encrypted: i=1; AJvYcCUz8Bfz9UVHtQZSOoiYxdUEmGkA1pLgmnGAkazybjpBmsPDx4zwGtXa04cQ2xAJhxJmDSdQ+nrCcA==@kvack.org
X-Gm-Message-State: AOJu0YyJOXMs7EdhjqcCS6/Q44bF1NPb9I7tQ1Z2yhRzqVgxUCYqIK8M
	5voRnYRmQvJKaRgO1vlEPtYVU55Hny1Sfgntv9G1AzARpDl0us0aGhWg
X-Gm-Gg: AY/fxX749B+nD9UL4w061P12MfplebmtxC+xl/lwpZ61mpssDoPrOpFyT1g3ORv+JcG
	SKmCbp6KdeqHrg6u4cHOpQj2YqKqRzq/VAKNjkWPNHLxvx0whZdwKbwF6EcMVx30lOWqOE1p6Jw
	bDwHPCTlapjTXTnGwvLgjE63g1Io1J5fO21ZUh6x0MXSiRGofsYZjbiUKCfbuukScdCROd7h1BR
	Lvg4sxxInjr6ls8iIpU8CWm6ImryhxmpzXomwehPcH6Svggy+b1GGw6+7RdjwKkSUD385nEX6o8
	Yd+viidUi4OeQIbIadsNIPngLuNZ7mWoJ79IolBC2rQVKezhKwyz/fcZjTpBjco82iHiTRWpkyc
	D04VRgQv9KqfzVaYVpb4QlnWizphl1F6mjC0+z9wyPv5nZdiKZaQFENDwxhq9AMO77KHM5f5EPE
	XH
X-Received: by 2002:a05:693c:3948:b0:2ae:5dc2:3b08 with SMTP id 5a478bee46e88-2b486cb6438mr2174383eec.18.1768372086378;
        Tue, 13 Jan 2026 22:28:06 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121f24984a3sm30586990c88.13.2026.01.13.22.28.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Jan 2026 22:28:06 -0800 (PST)
From: wang lian <lianux.mm@gmail.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [PATCH 10/11] mm/damon/lru_sort: add monitoring intervals auto-tuning parameter
Date: Wed, 14 Jan 2026 14:27:53 +0800
Message-ID: <20260114062753.88080-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260113152717.70459-11-sj@kernel.org>
References: <20260113152717.70459-11-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b5jm4xoh9egywei5wzpdfxtqit19a3b4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BFAA91C0003
X-Rspam-User: 
X-HE-Tag: 1768372087-589603
X-HE-Meta: U2FsdGVkX18lPOq0av/1gM1jAhvEvJ8NbOs04wrzdHxwdIo3NHdvFWtLxyfJWaFABXxoyzoxN5AWldm785JjTCgodCoKJIr3OKz2noY+mV/+zHynxVSV9mjUBtjW0rugqSeXMEr2ny8kZe+IYlu6jAUNqVll+jHoxbXhiou9EYDOaEWl20Wid98XoxaGQgFbDuhclgux/G+OpHXVNsIqARm0TyVXzpP9a4u9ILSt43IYW8ND8WTZ/RQmlGMG3MRCPZNWJU0tmlbrPVLueDE7yxPhykdeT83+H6K58tdSzI5la96FvyDqp0IhBHh/ifZzgNBgmYKT3ea1LVk2//lkmfU/PFcnU8iDy2zD9p0m5XlDSH0hV1WHbPCtA4Y0pETAA4G9Tex7NAVt6pYumJGb5h8xcCrgZPVMvVc1GpZtrD9W+EEfjPaGko/PmksSRROF/xg6qTkmObEG15lU3sLITo61+SMWzJ705FlXDXHooE95vxSS4apDKavIJMi1zZDGaT7Y+wmzxTChvWI3pI+vlwG+mxH+4/SiXuFs76FK38rJCe2sOPXPJfwNmQOIuu5Pma6gsBfMhN3+IMvFbgKpAHq2OZhAs0u1yPHZn6iDQFNr/y2iBVmOCZmTXPWqa71w/ks+qpfgoQCi4mDOobzqv2gXEuNr98mUh10o9hHseiyTgN+YiwtraYIjPg8j/rfc9SDHi2oPFWu6jFRtQRpHomgSfvQjZhgKVfD6/W1aVzz37EUYtLluIv12PYr/h4K/Gfbe8yl9AgZjWFkjX4vcmBaNt1OUw6c3z7OmYREv9SCxyjis3sIuYoxO2k179cCcjaHMY1H/ZFpwx5ZFYHUjRgj0ALjRPgdGZVReb1EibB9vdP21yZOm1g6VCOFflAHPEr4l9kJ668XFw3xSBo9fRXZxUhjvIKiah96sNUkS1hPLZSRsreUTCGgGD9Q1fhojMKf4IydfTPNi2l6eaKH
 OAaL3Jro
 YuGvSEgOnD39EjXA6jjqkFNnqH33AcQfe94Ro0JGOZcNVccCkv/z16pb7XNZbrTiLBRsI15EY2whNHMAFQ2e8OHqwYG9dU0LUwjozyyDtvZJx9J2lw8GOqxRWrFmP4Ui1R86aAobWlu++cs4IE7lEWAd0qPgqHUmIn02FTzDoJgggB26pqNTWnThzeA+ywdxoXLBrIyKvCKLAi1URUEBgxOgnKOcLIM7Gjmf9BaQr0dn5MW3bFBOpAG/E+6nl5bg+NulMUdztb92qww3iaGhb6AY2Aft0OnivZjpwzFKOkI+IqsHObg8CN5X/OMFVErXKfuVTAEvTn8lqE1y6yU5gKgSxp+e2TktWK4Sr7IQorjQbMNfDeNWB9Mr1q9hgnQckvM2anGLSDXAjaRLzbJbI2Z5MwTqheLnVUzhAZNWzr0MvtHYBDQlDVmSSvejejvyPf+czw+dy2cWxjJGiymrNM5Oz66BiOwWNO5EHmA3C0OvO5+CjpJUtbDRTDLn3DBi6ugk3n4BOvYf3FkfjeuK+UEZL5fEjImjH5Hnq2VJYCy0JeRe2Lv8lFgWA3wLuFxjWb5FTl4aogkAOckVfGCZgX440J75TRwW68hOaJ0kugMpEI44EJ3YHGzoKgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.007424, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> DAMON monitoring intervals tuning was crucial for every DAMON use case.
> Now there are a tuning guideline and an automated intervals tuning
> feature.  DAMON_LRU_SORT is still using manual control of intervals.
> Add a module parameter for utilizing the auto-tuning feature with a
> suggested auto-tuning parameters.

> Signed-off-by: SeongJae Park <sj@kernel.org>

Acked-by: wang lian <lianux.mm@gmail.com>
--
Best Regards,
wang lian

