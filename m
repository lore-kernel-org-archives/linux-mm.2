Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E2ACCCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 03:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F4818E0016; Mon, 17 Nov 2025 22:48:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A5178E0002; Mon, 17 Nov 2025 22:48:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E2838E0016; Mon, 17 Nov 2025 22:48:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D1518E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:48:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B8ECC035F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:48:20 +0000 (UTC)
X-FDA: 84122345160.17.0C92F36
Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	by imf16.hostedemail.com (Postfix) with ESMTP id 41822180008
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:48:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b="A76Ho/Av";
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf16.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.64 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763437698; a=rsa-sha256;
	cv=none;
	b=yiLV21Xhycay7UA1JQbQk6eylBP8WHZa/yxGNM5EFhkbh3KdjZzGOYgGo2Ckj4tmMU/yBM
	XtsgtFhRtgvn9RiY/T4Tnke84HREkqk25thKyben+lBP0vnTBb/H2Mq4J8hYyYnrS6xKGP
	s+dDRV91B6rr4DN4I8AO5f3U6aWB/mg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b="A76Ho/Av";
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf16.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.64 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763437698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9aRquP0k0CRuXMKjlC/JUHDjx6y/fzBBaTS0hUFw9zo=;
	b=tJzHcCH0EBO/sA8ef2vZ6SpUWs4GmMRb0nSP+BfnZz2UAVAT6ZgZ+NCDXghWj1VVNxMJhK
	hV/szpJ/NvjnYdDCNhA5fqhfBcvW+AJJkd+CVCOMZ+iKFJCAp4oCqMNdrPniJAFk7/CTPj
	l4eHWyM5Ye+alFFJztFN1VpVcxBOAu4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1763437691;
	bh=9aRquP0k0CRuXMKjlC/JUHDjx6y/fzBBaTS0hUFw9zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A76Ho/AvuqUMurzKjrXb7KO6fp+MPTsHH9N0meWtZQaAothlKhh3iODPn0ydupTkk
	 qE11LFYKhBS5nHrxtT4O0hcs6aZeiXwMtRDbNm8jWqa8pBTY3vwINH2Ve8t9AJ4n6O
	 b88ZSb8bQeGDTu9W+/o3vMZ6ymHjRzcFX9vvt3kQ=
Received: from meizu-Precision-3660.meizu.com ([112.91.84.72])
	by newxmesmtplogicsvrsza56-0.qq.com (NewEsmtp) with SMTP
	id C07A8C22; Tue, 18 Nov 2025 11:48:07 +0800
X-QQ-mid: xmsmtpt1763437687tw5mmd9sa
Message-ID: <tencent_3E9743D12F77CFF8B8EBDDB9529EDA975306@qq.com>
X-QQ-XMAILINFO: MZtEYADUG4Ag7myerlRVic0qoCY5DlUrDcjqxj2ytor3y1jT975wl9ilILPS7d
	 mAAByoXzaYGiVr/mjqgPuKntmIzMBp5xrlFTKgCQVMb7s7RtU8MlS3QdVSzwaRqghmi2k0IqyKEx
	 EbObugFHd84YXzikQxBmsq7SeXUf2kg3iNSJEH4enrQEmDMDsGgqPZT3SyGFWFgxuiEDYkJHoJJt
	 2I9WW77thHAPls+llTWYu8ZOwES+hVjhdniMYITEcSqpVh3ePLcF58bN4vETagcaAmZQ4+mt3gYp
	 pdat+MjK5ORcsUFzhiRnoOXQ1vmLUXmUdkXQxrK2l6tgWq3SssV/PdFygne/25tK81vVmRG8WxT0
	 XTbRqDH7bhrUqFEoc5MN5Lk0I1YxbGzFy3gUXCeiijzgpSIQYfQYUi3puW3hzkvFKWXwUGVdxEbV
	 3KlIaNLz+laETZfO1JGJ/KZuWGaOYV8KAQgkLzuTZq/nKLbrNVj1V05zxgtTD4d1SQXhn1Ih8J3U
	 bIVB1hArlG0D1TSMWzkbLolS3sKVuH0JS6AdPkde5XCEjvpP6R9wuircNu385+8OHJ9BRrA7tBQH
	 Hi1JSIyI8gpgI2hY5iub4A8zjXj26LZnJAnZWGPZIoeR/9T5wl1IwU1XjrDkfHiE0Q0VhCFzXM4o
	 d6tjXuxe1WIZxZ1yj0UzL51kFt03sy8SPyZfqpgzwYB7rcyq8i2wzJc658JmtMy+6SULLChE09j1
	 PGCreKBUTQJ5RZbyS5ykAp8X+GRlUu44dSSyl057fMbgCGY906xb5gFA6nPY3Pb6t6hZdIB42bVo
	 2+oo0VxpfKCTJ8LBpgDMKuft0lSTAaebtJjzWL7KbNeEns0NJ/aGH3JIjZei6EE+c7+Hc3fpRuSN
	 NUMIwDVSCuwHVVv30Ew26G+lFYmVzdQyNSL6B/lb+HQEDALYFD7uar87GSE6Jqx7/ZGu5QjKYMVj
	 IMtJMhPykSCfgH9XeW01JYT/D/ySE1n/0NQYe+abhXV0pxyhdPsCDCFhe8ZAX5QpRHnjWIntbmXs
	 nIwvsd2Oc8ohRYAKhXzxpL3gE3/41+kmFAIx2XaTFe1HdY1yDutAXhQwIz+q9/8vnhKri/xjt74C
	 dd050/
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: bgeffon@google.com
Cc: akpm@linux-foundation.org,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@google.com,
	minchan@kernel.org,
	richardycc@google.com,
	senozhatsky@chromium.org,
	ywen.chen@foxmail.com
Subject: Re: [PATCHv3 1/4] zram: introduce writeback bio batching support
Date: Tue, 18 Nov 2025 11:48:07 +0800
X-OQ-MSGID: <20251118034807.2801578-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CADyq12zxzi+t727B5sm5z-z3SmRQyMDOmr_tTG1GaMVh6VTWbw@mail.gmail.com>
References: <CADyq12zxzi+t727B5sm5z-z3SmRQyMDOmr_tTG1GaMVh6VTWbw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 41822180008
X-Stat-Signature: cabewea7x7urnacc4ohq4rj6ijz838tt
X-Rspam-User: 
X-HE-Tag: 1763437696-460342
X-HE-Meta: U2FsdGVkX19bvnaLqtNSbWgkA+O7lyRjx9uqQ0V00DaG8QwMhVKOUFveQ/OvJGKqZM6JFPWOnfcDhQ2yF9GBKUvB821Q5kinG2J8XZ4M6fKP1Elo1BCZYe/o244JjBd9IOELgCsbmlJwM+rnvAJpTVEKzWC9sKQv7xjnU9CwRdlSdrNZmdKk5EQwPS7TuvU74gapXs1UjUiq8lW3oGzem0nR3t/49UQjrkaDEfa5d+2h42beVixg95w/z3YIoLM2j8NQn2KF7xKgAeBjLATU1fVqIORSrZHZGq9LlHRTLX+axPPzLzQ+AzdbWOeeABdwCAoHSxu+q01sMZ4XgnpVCvg9PPyjGtnPOzOE18NSPaRBS6Je2gIBU6eQGbx+htPP75XsR9RDCSQSNtlKLDOU3DFavTlh1c0QFzFjKoXWs51EJfs//24d2AEESN/RIwyD4Q3mMEAUl0xKmJEyug278CLjfTb6mwtVProh6v4cI8Eb+olme7qq6LBmUh/Ibzv6iy0UPCISL+72bWdpVgDDKy6FHNY5mK+cSqGvckG0vATomAlftd3UmhI4Rr9MotktvIAFgbaubkYJzJ5esa6hi3T6RNm8W4o35ODBr05dyQWaiIxNBS37cGqwndFBej52d2VjPGX71TCebBDW0rx7Maw99MbSdIEJBN1Vl2uBwXkXRsNNno6sqEKX830IfEXS4At9LNuLE7ouH9EnENUObn3mJwkVqLjSNueZyG1pWJaIUUnN6ObW70HyOpAS6xDrD39HcFTaUR32cLzPSx8lnFLyIUg0JXIUUFieR9aXwnkdhXF5FDeqZOvHjihHwYECS5TexCOMQHA7jjxK89RM4phMIpaEe2WifM5iRU0q0lHPhWyRIPEnFg7/E7ekQyupNXZuap7q6NGEXzqq5yWVCmGdIXBUNQ8iY52wyNIQdCjvs/8tFAmQyoZGMoaMKm6VIRX3p1939d2tMIMjiti
 SvvcqBGB
 p6qufrUtCLSwHbPSGKgsKvJdobwEJt15RVTVWaa3uEayUa6NwAsBmuCX8QbSNicBPTGk/1XlLaVoNXFV9NxhtRAdtKEKnnAoQAnPQCfjtJxXZrmR4NoKZxCBgbrNKDtjHgXk514vyYnQuDu0NVPtYE46avA0edqHVSNKPE7VI/eUhQrgRn8zp8Iq019YM+00UAtEhYiRVOFHfm0rkTROadWgGvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Nov 2025 10:19:22 -0500, Brian Geffon wrote:
> Out of curiosity, why are we doing 1 page per bio? Why are we not
> adding BIO_MAX_VECS before submitting? And then, why are we not
> chaining? Do the block layer maintainers have thoughts?

Mainly because the zram backend device is quite special. When
performing the writeback operation, the probability of continuous
writing is relatively low. If BIO_MAX_VECS is used, it will make
the logic extremely complex. Thank you very much!


