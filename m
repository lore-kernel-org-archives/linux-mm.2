Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3389BCC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14D166B0096; Mon, 12 Oct 2026 23:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 125376B009B; Mon, 12 Oct 2026 23:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03CE26B009D; Mon, 12 Oct 2026 23:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D32DA6B0096
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:26:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA5EB40A43
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:26:34 +0000 (UTC)
X-FDA: 85316165508.29.7B9191B
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	by imf07.hostedemail.com (Postfix) with ESMTP id D1BB040008
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:26:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b="ts/HmB10";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=sM+lC7VF;
	spf=pass (imf07.hostedemail.com: domain of suhaas@s-joshi.in designates 103.168.172.145 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791861992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EiTz+HuScl259OHLsG+bik5/yWrC5KLt65qfVg2oAYE=;
	b=Dtvj3LXvlZbGtid6RS2wFXOTVk8YM7YmdT/ZL9ZRGz3ST/by2SZlCgQTMvi+XD9gLdspUS
	VQIb+4McqCHCZneaguyT8iEit46jaf9+4ZiJdOerUi69VAF83INgOVyGBWbOT+vzNWdDI3
	MmClv3o0+cNk/GY8NTcHe8OfxOw5qtg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791861992;
	b=bjniSrnd7qsBLmXkTPz7TSH8bS1irVownGs3Cf/JxxG2N9UWN0a3Vt36sRDwYU765cdinS
	iroRgRFXZJ+MZhl56p82mw0IfKuxkaq+he8mjGlXhtam6GNAqtJaDNlKuFV7+TQamco+7i
	YhBiOCS3X33OYT7rdiw5MI6v34vUKao=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b="ts/HmB10";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=sM+lC7VF;
	spf=pass (imf07.hostedemail.com: domain of suhaas@s-joshi.in designates 103.168.172.145 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in;
	dmarc=none
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 9246CEC0197
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:49:20 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 07 Oct 2026 11:49:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s-joshi.in; h=cc
	:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1791388160; x=1792252160; bh=EiTz+HuScl259OHLsG+bi
	k5/yWrC5KLt65qfVg2oAYE=; b=ts/HmB10EZBAD+KkRRtqOx7nu01FDPfCQNBQ8
	+iXUQKAqQ5K+XQLO84W0SPoFOPcsaADC3kPrBsBZLVb4dsP1kyjfiqB5ek9ig7hb
	bQlwCkzwrSyx138SDQZIsoAUzjumX/vx9/a93oKiZHqbDeUNbyS4WIjsylb3p513
	gqz+ddZ7UVnF69OjDCuejMmG+09FiowreueqnXjqEOwPRzS1zS4XlLCzz+JI97lB
	Lp9JidRGEfC7DYE2XWZtaW7X9LVNYFKk40gBFYCs43Kp3BLVf5Uw7fD4UErJC++a
	0FNO27cQNvyTD1R4yiNsb6ZpT7ZMMCYWzNcKYTvFOPdV02wzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1791388160; x=1792252160; bh=EiTz+HuScl259OHLsG+bik5/yWrC5KLt65q
	fVg2oAYE=; b=sM+lC7VFEOo4IvpMIjrXIXaEDWpVB5XNkHJMjULeJYHkGi8jDx4
	OtpmxjdBg2nHyFDZm87G80C/bzDjlWA8psLluSMeQNKIzA6sr0zp3vFQ4crMopo0
	ymTMrKEXoPYf34BnIcN7GTpjG3UzQGVnJID1TaXR5ueZSvha/UJTl5K9E+ldtNSG
	Z2epzFRuP9lwFWvlD0NPsvzAsCPDJrndLvSQFZGMe5BkXdUNfKazvi32Ay8YHP6U
	9S463+7dZ7FyTNPxymfBnlj999gBu+M8vbMvSgnkjHNg6oWPgaTIRpVfmbLCLqdk
	sQT+ouKHL6AIzORzAy5tItx3RauqeKBYHsw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=s-joshi.in a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791388160; d=s-joshi.in;
	mf=PHN1aGFhc0BzLWpvc2hpLmluPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:BOMbGAgiMDFBfojexsQQzgyuEXsJZBEmFUqeq2eIHDk4spV
	EsYgby2e8mWTZgMjYdkR9qV3VQwzO3PmCazBbg9qvGYRnpFWGj2GxRUJT1F8uPmb
	a5p6MVrnWa1JyZIhO08Sl5vMCTVDSmQUepMhfFQFGr649dFSvfP+n7pP9X5NpwRo
	jx/2n27IDDDPR3BW9S/GLP8+Ihed1Bln0O6tGgKx0px/Y0PC+MJ66huoCsmBSxgr
	xUdQTJxvW2H3+vMv1roRwfcfkWVfibVTjlGtABmml/1psEOmAr/lI50QFf26hht8
	Jj7YBKhi//zuvjjNppZyQJEE48dcPVB/jtiH8sQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:oVV34Oz0tZFdkamMwKRLCQvXLTY7P21irI3X3GKRZBM=:xRqHXRWy0wT5sO5hNhnUFechofQOXVJZ6pLGdNXUvo8=;
X-ME-Sender: <xms:AGrGaptX7i0dbchw5uiCS6H5jjpoIKubRJkKNGegv5nmFB2-kay3sQ>
    <xme:AGrGarz-AcJmL_aSKHhdw9uJdWN7LW8U5d8yQm24ouwdD3cZyXNesxzsV2HmMGoIn
    iJo0HK3r5J9qhsbKrIRD2jzAy8yiBgmMX7s_3Xq3Z8HcZY6vIU5ogkF>
X-ME-Received: <xmr:AGrGakAtfKnDhJUvH4CFBVf1UfZcdI4t-B9dkm95tVb8VgcPrif0UlcBRQ>
X-ME-Proxy-Cause: dmFkZTFDtuNAgEWw3iwOyCspoiF8PrY8fLATvghLsLPuIs1EaXXtyY9GaBQwxa+cvT3/64
    ZzU5crLqxDSa+VpXAg6ZA6X4jQSkEEuNvSoiilmFl3CBqGj9KrpuW8CLbonP4MWUX2yA3Y
    /zOymznOoqNhSC7D4cMsfoHpry2Qy8ywZbQZewwdHkIaxzw4E+wS2UzJiIPfibADXmhJaE
    PBXoN9z8/esl0+ItKkuxL+PsVQW41CKw0oQxty17YZ7Uj8lmt6HVAwwqJynqWEHygDIeGZ
    AyRy3Iv7QnrVwRvQQ+hm7Cb7cBBUw/xVVcZy0Gm1lFG+R/fasNHDjxXjjgX4jiHbNX+BDB
    FNxlP8JSKs0JEnI/QedM25V5h+Dd6rbBCYU8ZUMnpvMFbGXwBGSQSTKMbOUA5Dwm0jIAtu
    9zbjskuj+ZUg7DtVy58QZJQYdGTbpn2Qauqr6boeMQjnfAcGLZiXKSp1G3lFPO4i8OEqoo
    udOhN4NHYt7BptthDSpGfXA9D9uM7+7vGouIBMxUtZGgdmYnCWCe4WWNg5suPo1BxgP2lr
    3RCO0Pet7Q9LwtfaUPOUlYOWYYufmW25iR2/zhOfa1RtckPaESi+H5/QEmlv+rIoU9z67a
    wFerjwFvM+kZORzirbiXQtB3No5x2CZr4hW5+M6LOgrm0ljb4706tCI2tMww
X-ME-Proxy: <xmx:AGrGahfjtoDp3ZQ9-bGhc08-Vu6y2SeHAp7-SgOJuno46k31DwqksQ>
    <xmx:AGrGamnRIXfbSytF_YGv-z4FXE8Oitq4yNZJKyX2tSdNtdL6wKqw0g>
    <xmx:AGrGagGEJDXTcqK4euYSuFgtgKlL570nIq4kiijUrpzvTmZNP1g5eA>
    <xmx:AGrGam72VOmvzpPU0asl1z1lOTS8rNrkmRq5Lh6m6TKy8bvXqgUrTg>
    <xmx:AGrGavVEFi0crCK5Xx_UhKQ8WPge2Jzr8s2LsRtYMlz4PevTUte2QIP0>
Feedback-ID: ia9504abf:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Oct 2026 11:49:19 -0400 (EDT)
From: Suhaas Joshi <suhaas@s-joshi.in>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	suhaas@s-joshi.in
Subject: [PATCH 0/2] mm/damon/core: Iterate over installed probes instead of DAMON_MAX_PROBES
Date: Wed,  7 Oct 2026 21:18:44 +0530
Message-ID: <20261007154851.45368-1-suhaas@s-joshi.in>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D1BB040008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5xo7ntfuroh43nuj8mbaut6ahngqz4yf
X-HE-Tag: 1791861992-877838
X-HE-Meta: U2FsdGVkX1+xljusz+cpu416d+svLGjvWFcVAJ7aEHLfk7/xh5M/fPQ7wjCOuhUpzprvQQ8c1H9m464XWlrFC9qnqsWt1peBctSoREalBwMHMBy+RTraJ5ETHJrX8uAkQMInZC75jVR+DU8/MN4XH58nV7p7AUrQKnMrUTZ2O6X1hO8tFhphfUr7gPGIt9/MDv+sK1GeKBLkCVsXgNlKDocG2GfTbNDOOeh6D/gkdTSyHHS1HIgK7NiryQZrSITw3N5WBcZtbngCJfhnZamb+lWrMGXb05wc4K0bBQZfemFRGlBKZv342UD0fsM5eE3pnnVm9Fcpty3f/BW3aNWnbd6CbdLFmbKv7+no55Y07kxozCX3Hseqo+W+7kxzw2DNzMnfnYzikwH7oSdXVe5gN/D3EJXTg3DKiUCEEN4kbVBE4n69ZpqEMPaJiOZ8AUT8EC6dVpGvBwsYEuVyNlr9O/IYzas1ANhez1CL9MmBymX42QzwOpPWGavlh1p3RBcuXBu9enJ/J7dQ1zx8RgsAzingYCMI2oolBxZxb4XUCprxBrom5ZR10ol9r9kojqzFzWJCcueueDrOy5iwrUzTx/5T4YiMr6bAGdm42lCGAylNvAJ+R2XR28F8fp7MmY110jIBYWQH7a5JNh2fgD6sPPzjm2KiCe6tVOgOo0s4Q70TL64ydQdZ4/BRK9+B5XrDjvVSZy5U2lXw5QI84QWedhCoom6eELsje5917e3WxRpR7s/pEJeS3oydU7KSlA8i4v3ETqnUTLlodUIYAD6LB/sbQKXftHgx1srAQ5Kg/aXoLQvGuT6KTXgBNbzQVDevJvvRDyzFVVJymwD1rB4UF8zCOY5BzKctnIiCsqVRWuz8qQrKX07V7yO/y11JTjWDd7+VGLIANfF4uOtlTFriDAzPLz8A9BQLUy4EIyNIAxKDtk51Qyu73mQEEVQfuEzS/+wCgerfG36/SXrC4Sx
 9vpmdCzd
 auxUT3diku398CZlKF9Hvp6jeiD/DUAYV3j9gLbjZXRYQwJEPkL0ufDRalKsHPZ2IbQRtqZQxZZZs49GHX8io9B8wvN1GitTK2vqPLhUgmAXMMTlFFDy+NYbVuJg6q5fe8QpzEAqwRcw/OJeswXpxLFPk5F34KCB5Yl3tbPEcpDyusH8SP36vKANg5GvQacJgL6Q3WO3j8+MJ0i47fhyLU4EsLisENCU3Kj128fR/CVXe+wkGprF46ULaWQga918xqJpC7bCCGA3E4YaOgtF6OZ8jxeps3iDrNYNbShU/jMcwL/sOQpjDruDPk6mTqJDyv5f9eLO+jdLYRdUV9XrzV48R1HGuK28dqX7HLZ2RA2emwaAAIA0o24opXXjHFguyR+p2i0R8o0gG0qT8v69iZeSfHV1CSaRMSS0Ol+zG2JN0Mp9GzB1s8ROBCTGFCZo1ksgl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

There were two "todo: " items of the same nature in mm/damon/core.c. Both
of these suggested that we should iterate over only installed probes while
updating (last_)probe_hits[] during merging/splitting regions, instead of
iterating over the entire array, which may have empty/unused indices.

So this patch series does exactly that. It replaces the for-loop over
[0, DAMON_MAX_PROBES) with a damon_for_each_probe() over the probe list of
the context.

These patches are based off mm-new. They pass all KUnit tests related to
damon. I have boot tested (but nothing beyond) on qemu-x86_64. Please do
let me know if I should do any specific tests and link the logs here.

Regards
Suhaas Joshi

Suhaas Joshi (2):
  mm/damon/core: Use only installed probe in damon_merge_two_regions()
  mm/damon/core: Copy only installed probe in damon_split_region_at()

 mm/damon/core.c             | 56 ++++++++++++++++++-------------
 mm/damon/tests/core-kunit.h | 67 +++++++++++++++++++++++++++++++------
 2 files changed, 89 insertions(+), 34 deletions(-)

-- 
2.55.0


