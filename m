Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DACBD606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 19:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XpQze/+2
Received: by kanga.kvack.org (Postfix)
	id 2444C6B05B1; Mon, 16 Nov 2026 14:30:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F4AF6B05B2; Mon, 16 Nov 2026 14:30:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10B026B05B3; Mon, 16 Nov 2026 14:30:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD1F46B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:30:12 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1CC51140277
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:30:12 +0000 (UTC)
X-FDA: 85441973064.26.895F54C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 38AD918000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:30:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XpQze/+2";
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794857410;
	b=FLvHvuVyTpk50NohI3aB5p8IT3g1I/6GFRUvvthS4D2pRaKW4YhsUK3UG5s5R7jqbaeR43
	jEbcx/aA7uoLSH1DTDtIRysDR75URuuFX4e3qh6Dx9LGEtGNaCYrnXA4PBWAaaFJXlH7If
	UvACzcRPtgCQFn4FLfCz7KnqSpoq5GQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XpQze/+2";
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794857410;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bo/CR0SsELHFfPRDIloEEvLL0kxbrHtpD01b5Y9R2Dk=;
	b=jpUTy34yKb0eyElwUa1teki1m2yDmioQbx3wE2Azwl3+Q4FiaCLYS1dUaOt7IJiuGaLa6Z
	NjDuPOiAgJMsGHWuS/EnYMciG9S2wTEmSzlm2XacURdZVWKleQpWW12kDPSnxi5rlVJcWc
	L+8Bwol92ZrMhT6lDb35EOqVtsnLuDc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 288C942E82;
	Mon, 16 Nov 2026 19:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986BF1F000C8;
	Mon, 16 Nov 2026 19:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794857409;
	bh=bo/CR0SsELHFfPRDIloEEvLL0kxbrHtpD01b5Y9R2Dk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XpQze/+29bH6dcz7C0L8T+YU9J/gAOw6GMnnw1ho4vBXuIFcuO7JnbLkj2Q+Ilmci
	 0nUGb4Zq+Z3Rm6pYKRew1ufv4/xwbtsWBOH2BdxvRKdqKsyVPyG/mYSchZ09JCMBgJ
	 sSyUriTXykQZu0wrW7Ky99Zr2JMmGiQJx8GjaypGr57RqAqvAoOoiLeIPm55Ury/9t
	 bKYLOJyke/Rrexv8b9lL1UKM7PHOHnEA9gMUkB3EAIdwAuro6YHgsVXdN0ra9VaG7z
	 7Uhbh2u/AX9UXPsWcQkIpLgnJMu6DoQsSVK0VHrgVaVv5Q7pG8uXPhYscpzcizHthG
	 VQIk+JqslgYzA==
Message-ID: <sashiko-outbox-217563@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/6] mm/damon/tests/core-kunit: test
 sz_ops_filter_passed_last
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mattathias Pinchover" <mattathias.pinchover@uber.com>, "SJ Park" <sj@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Jonathan Corbet" <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Randy Dunlap" <rdunlap@infradead.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261116-damon-sz-ops-b4-v1-3-1cffe7227e6d@uber.com>
References: <20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.com>
 <20261116-damon-sz-ops-b4-v1-3-1cffe7227e6d@uber.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 19:30:08 +0000
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 38AD918000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: pd9rsgj8xrheuzsh4necsh13fz5juzb5
X-Rspam-User: 
X-HE-Tag: 1794857410-572337
X-HE-Meta: U2FsdGVkX1+rZn2OeZQDB6831skBECUrcFbNNrDnXJRHqiphY5LEcAS1T8U8DhtsO7ggTXVe2kaMDPHiMkISUdxtBYf9lArOmbShZDSwih+xQ7fFGplBTr+0iSisncw5s5oVIFx149OaC7IrRM+lAGVBoXldXXR3DsR98MqnH/GMgy3U5I8K9WpLCOGoGE1mTZMH/CjIjBciflGVuCvedhm4bv7zrABaxtVFCN6bLnHRXbi2ErW/n7aL4ysW8n/6D2kOEheoR2GiGxgOPzB0jfkQIA53Wqmi/YXSShsSIWVR7+iY9rAm9SNNdPozmc1pIKShA/bs23h2RP83H20JkbMxzRcTSQJAH41/B0SotYFSP5NUnRNvqO8f6D1ZwbtU2EVfHApp26TukdwL4nBck0vPC5xDl/I79I2j4OshGQSNAXWMOCEM+xDo9pUa9EPIWIfpJNpIoYRnYvOzoN32gZasJ1goR78/7xOMp9b84mJ0YA3DLIC0tHQcrxF57TnkO15H6HIkjGamAVXSf4Lxj1QUayEhh0sIp1DpqXZMHNV6GAsKvtuhJvXEiz4BEPgRIeBOMceljFCD/Tv35yAiB4VHk8PN2t7MRSGEf6lKOehDEhkkmx7KfSgpVmqnrzLSHlUUvnczzbiF1qs8ycf/+6JWNMnTY0DxANMazxQyot5P0Y9nEAKDePf7UvIJ3nN65yya2ZKjF0uUPG3ujmjSumV+9/nf2t59hyzsmYaRvtP//VigSpp2uID35jo1YwsQoajf0CUczXBqdH4os58nkjzpvIIkxHEHoEHNv3FiHtGeiThb/zi3iSbPOaACVW75Hdcvmty2LY5h3MV6+Bckb+aVenECvKYyt+up0iuCIma6mTDTskI/JZ+sp4uWiMs/Roj19NgHRX2/SJp2MQJ2zNg8+XawjIlRJtxI2nOhLbvR2n5Z4y6pK7kK/Y6TdwVh6X3k+m1j65ttAzzSC4X
 rCClIhof
 ztFrtSUX2C2SAGJ1lN/vJy3/vJeCSkq7aY9ydLAHalfAsaLmt/UuNGIBhpGw4Fduy4zNbld5ocT0PcAio8MjM0SZzy0hgxHuuprFJXkfd67Dk1A14aJeMas89NGN5t9iqNZTrxirpgLRRkuGKhQh/6etIm6SvjuTpsPsqWjE49OaqhBfBSj343kddRJ8b1PCFNy87sKOlWaMu6W3NKPBnYj6go20bwdFocITShRI+FAcXz5FJer4I1TWGG7R+JwIhoFbqMYLd2S47EA5Vd4Xs5tQDIQcBizGa+dgcFuammtD6bGhKmjvZBMoSk+F2Q4q3KthwF2ZCPrE/q1WxL/eHBbTN61Mebt04uOKEUt12pogic+MCPVBDGwAPFD3KrYnjFvK8DXNolBlZEy2YJDVeklt8RsxhUSqnciB7xbKIPgZ70r4iqb50OeRbcNhaBHav3XZSj/oXoSPIEJuWp2Pn8KSnJ2QfpK1lHrY1xkMT82I339IgX3d9of5tyh2ZDJV2pIKII3toJjwgDbtG2dZIqB/EsyHJPXrs5RmFRAhCG3S16F0qfY1U/yqtMsL1uUHoi7gLWBanKLu8/GdLflpCnRvjL2rfSbav6pDqg9ROBIyWLTV5PweIyVw107QjYFOkremY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/damon: uninitialized core_filters_default_reject read in
  kunit test
--

commit 64315024865456d25a50aac3fbbdfa4d480bec80
Author: Mattathias Pinchover <mattathias.pinchover@uber.com>

mm/damon/tests/core-kunit: test sz_ops_filter_passed_last

This commit adds a KUnit test verifying that s->stat.sz_ops_filter_passed_l=
ast
records the ops filter-passed size for the last apply interval and remains
unchanged between apply intervals.

> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index a5ca4bfe2f0db..ec83598fff0e6 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -2541,6 +2541,97 @@ static void damon_test_last_region_quota_reset(str=
uct kunit *test)
[ ... ]
> +static void damos_test_sz_ops_filter_passed_last(struct kunit *test)
> +{
[ ... ]
> +	c =3D damon_new_ctx();
> +	if (!c)
> +		kunit_skip(test, "ctx alloc fail");
> +	c->ops.apply_scheme =3D damos_test_apply_scheme_passed_stub;
> +
> +	s =3D damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
> +			NUMA_NO_NODE);
> +	if (!s) {
> +		damon_destroy_ctx(c);
> +		kunit_skip(test, "scheme alloc fail");
> +	}
> +	damon_add_scheme(c, s);

[Severity: Medium]
Does this leave s->core_filters_default_reject uninitialized before
kdamond_apply_schemes() runs?

damon_new_scheme() allocates struct damos with kmalloc_obj() without
initializing core_filters_default_reject, and damon_add_scheme() does not
set it either.  When damos_test_apply_interval() runs
kdamond_apply_schemes() -> damos_apply_scheme() -> damos_core_filter_out()
with an empty s->core_filters list, damos_core_filter_out() returns
s->core_filters_default_reject directly.

If that slab byte is non-zero (for example when reusing a struct damos
freed by an earlier test in damon_test_cases[] that set
core_filters_default_reject to true), damos_apply_scheme() filters out the
region before calling c->ops.apply_scheme(), causing KMSAN/UBSAN warnings
and false test failures with s->stat.sz_ops_filter_passed_last remaining 0.
Calling damos_set_filters_default_reject(s) after damon_add_scheme(c, s),
as in damos_test_apply_scheme_quota_sz(), initializes the field.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116-damon-sz-o=
ps-b4-v1-0-1cffe7227e6d@uber.com?part=3D3

