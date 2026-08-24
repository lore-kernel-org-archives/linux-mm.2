Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4559FC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6692A6B00A0; Mon, 24 Aug 2026 03:59:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640786B00A1; Mon, 24 Aug 2026 03:59:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555DA6B00A2; Mon, 24 Aug 2026 03:59:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 336E56B00A0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:59:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B976A1C191F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:59:50 +0000 (UTC)
X-FDA: 85135414140.17.4BB685B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2FCD31C0003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:59:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EPIETBtP;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787558389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V3rQKObuy+xVLTlhhjHDCPVzJnAVCXtIbfvg8Aw6pM4=;
	b=yScIA2Q+7Es9Ve6cUCrEhhIoyTARmzd68tdFRm60asZlzt5UVPRn2xAIXLmVEr5GMJD6Ss
	KZoQlsHT4FUIlligpwefrUD7g4tqx2eXlU1T/FUnIT0/rVq2uw84TBT6If8EYDFREnAc9D
	e0X2SN+m8pcKMw+k0o0uBm8V+0A1sn8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EPIETBtP;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787558389;
	b=c6LQBeoha0VeYfb0b/Zul43yMQsTNi1OgE8NPrs+7O7RGRXmslCYpYiwyIXYydX9Y8Ub5f
	x9r8IC1JT4vIHNk8/kt730FEv1b63ge8KHXvcWLMjnE16ZD0gtwpP8aG+XIqbes3ZTJ3VF
	yhTxD/bnN8nD9UpfeYGA1e+CrcE7wrs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C5992600C8;
	Mon, 24 Aug 2026 07:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3051F00A3E;
	Mon, 24 Aug 2026 07:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787558388;
	bh=V3rQKObuy+xVLTlhhjHDCPVzJnAVCXtIbfvg8Aw6pM4=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=EPIETBtPAyDvnpFyv/9nLIXNQF02shqJxO/4kPQLxrhMTs3g21WaXi+Qq400go5U3
	 GcstiR975UrlG4GmmYi0PsHDz8o5o5laYnDW0z9dgTUOc/ZlE353p8pGu0eMUPcS3r
	 UvRxQ0+eZKW4f+Jpofd078vojErLyu9pBxyJziPG3OPLTKAcI3PjfVGatIYDZ4TuNl
	 ZXBzTS/EpdAP5koC2+RK5F4lV04wah/y3PsgBwmde2vR7P/3QacHEv+MX0S7fJpIAX
	 tvMn9Sihh3XFFQYmGcR6oly0P9AZy54Nk7sZhhsfwkBjvqtMrWJsJtFZRrsmmWExrB
	 33v58UOtuLxdQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 6/6] selftests/mm: add a GUP selftest
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Mark Brown <broonie@kernel.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260813181230.483746-7-sarthak.sharma@arm.com>
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
 <20260813181230.483746-7-sarthak.sharma@arm.com>
Date: Mon, 24 Aug 2026 10:59:05 +0300
Message-Id: <178755834511.3606540.7162032713017782533.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: opdmwd5abynpktu8j4yai76i1dw8mtcn
X-Rspamd-Queue-Id: 2FCD31C0003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787558389-690457
X-HE-Meta: U2FsdGVkX1+6jz4uwa3Qjwt5ovVsahPTzKlraerDwkWQUgsGpNwueqk0o/scLB37kZYU4p9e1N5E6s+TyuSA28F7lwgxcodWDN2+CJ3VonmY5t1WOtLdSEKNfqhNsko1jOmDhXBy29JfgA3jtmhNdms7xBj4XuKNLG+pQIPC023B5m3fDbEx5xm1vjgTx2GfVHrViidJs4bJHrjaq+OE1bYhWFuZFjynsPM7aJGuUIvS608zLTr2hpygliGP36hrgp1N9fLTkCMWTI9BpM+pLNmfzE/yTETA9ICO+ZIbu5b3dw5O0nFpOdYcyOxEn9/AsX1JIIYw7/o17KBUQrQMJP0LVVwrd2RTjluObAC+ZaTO945PiQ6qaI2EqBvUHODlTxdZiHQ5OmKKh+GOIwqAegepIDky8whZYd3QYWlaYcMQP2J8Zi4RSEFwHkmlfC5qeEMSVLGe1HlyVNWJTrHNUAlwTJj0v8ZNvDr+edx7XsMg8wfHsrS04k/YSDSfM+0XU7hw5S1UIxjnH/vQ9IgcrKr9y96PepapGOU/2KP0AaND8cEVyjBFmSQrl4Bl7QYjzQ8/UzWcUovzyj08n/TA1sJZWpVmwh8NU2lD8QFBfRIlWqnrnt8/vdDYRyvbXnXUo/lQk3oi2nbnys6Tf3vEXoZ3y8CTjw2d5agDR/fVTQisMaOOSWnp6m1X8CM5o0h7f7JV4VfqdM8tSf2Ats8Q7+yHxu81T7wXg6ZCvC2W4PEnZF0sjzS/eGFprG+7hAdsuWaeDUvHOtgHnzhsBdUShio0uKtcmu7S9LNECrfMJ4k+ySOS18uHGVRkW282mnsoiYCyF+VusrRMXZzZz/buTsHm/bjLgKrYcRO/4T30qE4MUDnS8MAv+2VVK6Mor9cTfCo+yQRfeLsgG/yntQEeAm8uBf+hfZOdN/rEtEkd4KSOg3uUq8vuHILp7ptcMapj2yzaRPMYM4eg/aUK2Bg
 agizh53p
 zImrTlpxlEcRHZqxllGVhcBxPHpuaCAdApVqzTCpjJoXbm7eTbvP7KmfffN0Uvl2E9oALAc7l6QcHALJWxDQBmhiiGDpIKr0uHUv48cw/IlIbVEZklfMQDIB/oTn6GARwL3oQOIO4Co2A7wDmB6MqX5fVbhKfzy3OW2nduzcsFvFl/rNrJytGDy+XtxK7aoO5iwWEvD+ZZhrB8l1sBKzM4LpNgxIWu9034ATz0DbpfTSVDbgY+pZzwGstmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add a new GUP selftest which uses kselftest_harness.h. Cover
> 12 mapping configurations: THP enabled, THP disabled and
> HugeTLB, each across private/shared mappings and with/without
> FOLL_WRITE. Run 7 test cases for every variant: get_user_pages,
> get_user_pages_fast, pin_user_pages, pin_user_pages_fast,
> pin_user_pages_longterm, and DUMP_USER_PAGES_TEST using both
> get and pin.
> 
> Set up 128 default-sized HugeTLB pages once for the HugeTLB variants
> and derive their mapping size from the default huge-page size.
> 
> Sweep four nr_pages_per_call values for each test: 1, 512, 123 and
> all pages. This preserves the coverage previously provided by
> run_gup_matrix(): 12 mapping combinations x 5 GUP/PUP operations x 4
> batch sizes, for 240 ioctl calls. The two dump modes add another 96
> calls.
> 
> Preserve the previous sparse dump coverage with a standalone test for
> pages 0, 19 and 0x1000. In total the selftest reports 85 TAP
> cases and issues 337 ioctls.
> 
> Add the new gup binary to the selftests/mm build, run_vmtests.sh and
> MAINTAINERS.

There's also ksft_gup_test.sh ;-)
Other than that,

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


