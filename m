Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46573606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 01:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z8Bu8fNF
Received: by kanga.kvack.org (Postfix)
	id 3A0A66B05B2; Mon, 23 Nov 2026 20:05:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350006B05B3; Mon, 23 Nov 2026 20:05:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267006B05B4; Mon, 23 Nov 2026 20:05:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E15116B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:05:19 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B6C8F120A2A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:05:17 +0000 (UTC)
X-FDA: 85468219074.16.86FADF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 22E248000D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:05:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z8Bu8fNF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795482316;
	b=47tDldGBSj+1+U3yk09k0l0Cb1sXNxSUeWCgVM2nuQrS0F7iwyk7JtPM8TMx6NNlGDkxd5
	ribl01lYHHPtcEbypBoSrUfSDwnwLPi02d9ut7lm+4QIgXusBjxWcB5lBwN4PmUEH5DQ0c
	Dt5BNVFD+mu9imsROmU0zKvri8u3Exw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795482316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KENda9nYN/y7XIiHiZ/NO1fdbgQMsJasxhpRCd9Tv5c=;
	b=lVe2C7kgiXJV7HvQOvWtJMC5cKuUpaoHQT4skbEKToj/AM7WPiKFMo3ErKj6FWul4dDOxN
	u4K/nHv8i6U850vErG9+OMjmh4aazU8mCTDiVyp8Uv54v4wJTxhtNPqqPRepIjg6PV6rH3
	QI8m4jMso30hIEsbPSExmhty/h8jdqE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z8Bu8fNF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 87061611DF;
	Tue, 24 Nov 2026 01:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969EB1F000C0;
	Tue, 24 Nov 2026 01:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795482314;
	bh=KENda9nYN/y7XIiHiZ/NO1fdbgQMsJasxhpRCd9Tv5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z8Bu8fNF+KXKJP9X9cs7klKU/PMw6iRImxz2/KDQQ5DvZBSk9iTuE3dOl3FlZ2FUJ
	 CZYSElfbv9T6BFnFm15N5jNkoDXCPRxffVy+zmyWsdS/kqOdnAQWNql1NTW6fthNvR
	 kWracD8cuMVhdssm/s270lZU9L7lzPgD/xcAuwmRnA1oQ5YTum3gzgi4YVqeokZO0N
	 92ayQ26WsGGVRFiPYD8xzyMdhopNVfSyMTORqWis2lFLrNCprDvhtcg68sN04+rC3V
	 wPfkhjCtGapWX3+iur44c8F5rAb7ysYTr804cCxGFxf0CbtIrY4ysWm02xs8V7O/H6
	 gI/bZE3WdhI6g==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	sashiko-bot@kernel.org,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH 14/27] mm/damon/paddr: support REPORT_MADE type probe filter
Date: Mon, 23 Nov 2026 17:05:07 -0800
Message-ID: <20261124010507.90151-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179545322647.4.683470932650691650.b4-reply@b4>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 22E248000D
X-Stat-Signature: r3hssasno7jfr4gu9n6i7gj3y5dnaq16
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795482315-875393
X-HE-Meta: U2FsdGVkX19H+pU6WS7geLZBrVf8i505YoBmoQcHxOInOnI3ynb9g6FetT0ICoaHjtuRzZ4Xs1wdxtbPD60+93zxWhGJRZZGGJba5gWr2/+DF8heC6Jdn+6I42ZEcYkgfMlsK+WDv31Pcr/fPWZJ/LbErq01Fu8+S8cik4naS1/tmz8vB1zFbHL9yh9G2nw5SUMiJRzXGNSj5QH4nunnaJcV7o4N5rtCavPf0dTkiGCkQYC6DOlJznY+620boQMGrzuvlV/iSUf4iDYmjPbX++MjHuPEzhssxwpqYkQiwzl4sWFB5wLcJnXxeLYT2TNNSK4YHevmzYBOFgLg+6e+IFAbvMKxu2cF7d1NiW4sMWfKNVZMWb7bHbDeIJKIvPZzy81F98wVbh9GN19vqrWeI4i1VRuv7DVUdyT1G2hiAl32zF9hD5UYyUWj+SSEY0bM5wHmDeVLzEoTYLX7lWNK4ksZZxSOngCyEOxnOqi5m0MPraN/JlV+6HKb/XCbZFmL80rvGvibkZTyXiUDmHqqc08ZHGXMPMS6Dwg4kztbYtRHdgqPkXxkvzB8cLIOBIbbkcsLiXpgnJIQ09uKTci4/3HjP/GFFeowdxO50w7qmNkCaIBZ3yWYGwIAxoGNDrI673+spB6LvViS8AYBsE2TIO1IP1WBkja2Oal2ji7E007p6ZjpzZTNacP2HpwVXPMXvPMnrROtbdN/mOi2tOn4OBTUey6sAxUiRn6i/LC71cCVi30nzxZM1K6n0hChkufOoxLbP/zOphORiQ66pIkcKXy1X5stJ0rRH/0lLA3xNrh/qpqmqDVdd9hPJ633KZEJ+rV9pDTN8v0ASp+JzNfCOBAyJgXRHfvOaASJ7NvRovRoQXegBHthKiPqpa5/3+5QFtxs+RoPOo3s7Ut8MKkIgpGc6oJTB/M7YUV94tKbXuFK2w66JY83H5jJSIDwKr9rYzXsWY+6R05b6idFb0b
 I3fGe806
 1P9S1pSpLh5RlS3F1IhOgZ8DbAdDqV+h6CfBuULZAG6dbaBVX3eNRHCkt2IoXSmN/m6xbtRL3ECig+Uu1A9U+/ZR1TIaHbnYADDPfPtffVX/P/A0kGga0qcusrtWCYf0oazESrLQvM3AnFlk3SLGuevSQ9i4SOWkeZoAyMKMxXnFetm9i2bJJdJ59pRpY4you0RUTTXyQGcXqpN3dPMmN7aZ27mYyCpEOleGwgnf8AwFw1xtypEX9/6c34+2Jd/pIjgVyQ59LBss7MZC2IVAPxUCFjwzaL2hoE2UChKYxm9N+YOtmYpj2+QXAlAI27oYeRR304JVCLobsKEAcsnRE1PetNcYYtODE2wwh5dnz2MmV4nkWzIuPZPtts1dNi9HYSrJC78maAK+GgRywuN/YE4+KvmTf2R1QFnUM287k/fDLMkqpOcb+jAQ6Q31mMva+uRP6QuxZfQzLaklgfGHRHzN6TEPuEgGJjypUqe+pws96CiDVIiBh7fjNEOIGAP3+oUBMTzpApDyYIhFihQPV1bPAkfpgOqAfYUGBFUZWLFcJi9Mfcei70EUuIOB1THWxsoD993RlnVZQRoU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 24 Nov 2026 04:00:26 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi Lian and SJ,
> 
> On Mon, 23 Nov 2026 20:00:02 +0800 Lian Wang wrote:
> 
> >  		addr_range.start = damon_pa_core_addr(pa, ctx->addr_unit);
> > -		addr_range.end = damon_pa_core_addr(pa + 1, ctx->addr_unit);
> > +		addr_range.end = addr_range.start + 1;
> 
> With this conversion, each paddr context looks up reports in its own
> addr_unit. Producers submit to one global queue, so two contexts with
> different addr_unit values can interpret the same report as referring
> to different physical ranges.

I agree such interpretation will happen.  But I find it is hard to imagine a
purpose of such setup for real users.

> 
> Could we define a common address unit for reports and document it for
> addr_start and addr_end?

I'm afraid if that will add something that we need to maintain long term,
without clear use case.  I think we could revisit after we get such realistic
use cases.


Thanks,
SJ

[...]

