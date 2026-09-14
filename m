Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AD74C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09776B0093; Mon, 14 Sep 2026 11:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB84B6B0095; Mon, 14 Sep 2026 11:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD1306B0096; Mon, 14 Sep 2026 11:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A28A16B0093
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:57:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2AF4A2F34
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:57:41 +0000 (UTC)
X-FDA: 85212823122.21.3D4B5DB
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2EA4A20002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:57:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KoIGiBxz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789401460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uLQyzx/jS9wKpt8k6euuDCFOGH2TJfuVVKt6HxhJ5XY=;
	b=V60XsiYJ3aH5AOccD/X709EfWTpD68DdepaOBKXh7G4oECOnVy8oqhjmcCmcdIeOw5u1L4
	TQTug0sJbQVyS0gBORrXYDCZ7tfE646Bg4AMW5jv2SvMrAJfEE7LZgCB7/DgX8bPv2EdXp
	GjbyWLbxzdZx7Z8widQ1wVFq8iTQ178=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789401460;
	b=qzeSv6os5nkIZUPCu++EL65XqSvyCEMjR8Ic1G6KWFCgL/BytRxkiTivx7/BIKwcpRC9YJ
	IXeCleaqDz358yu5EsuTOib/47horoCWCmhtBIK/6pNGepFzKIdPN5Az0UVkT63FKvMaaY
	rp4GSliWq9Q4OCdgrmuCsWJfcHqvxOk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KoIGiBxz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39b2ad83dc6so2351849a91.0
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789401459; x=1790006259; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uLQyzx/jS9wKpt8k6euuDCFOGH2TJfuVVKt6HxhJ5XY=;
        b=KoIGiBxzpkDXAcvFm0/uqAFpVinJAWFJYiI3FsLR1R9txTVm6P9cW1M/7OdQteX8bo
         qqrZl6LuSXlKehiivoJp/LQjHjn2EkgapnzzVS19vcnBXUpNtUdCTryxr37Kl26h5sCA
         LLEYVRfCLE14clBTcx4tJ3QbXvN2zV307I/1WZlNEJzUtywr+CDebQqUzdDRIeKhYevU
         5TEJpJB+2JxJpkGEvW4iNwkmiwEakaTnyQve2qwnXKEil21zdMLrBqEUTbx6s4odeJjP
         lVm4yd2+pNYUD/ReZdX4P+o6WY+tpDL+yg7BN4U7Aq98filhnpSZdnDrFGS+k6dDSXkp
         PRhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789401459; x=1790006259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uLQyzx/jS9wKpt8k6euuDCFOGH2TJfuVVKt6HxhJ5XY=;
        b=p+2lsUs1iD8tA2qDfng47UhrJZLrLagPC8pIbF1r8i1Y607WtNDKh+GdPXtoPpY2Mg
         So7ORVa8zzS19ain+oQQc3VaJVN9MPYgLDJIlp+RDOJ+fpDZyn1n1tXj777JP1rjJ0JN
         9KLYFQScDTR6AnR+H3C32g24sbi99mgAOhasoZMW1c0HyayfDS9+faObSwNfwNIr6d8J
         uG9tT9/cwSLRrnwjpW+7zYgayCwvQBJfZ6shIdqPWQxoS/DSejTjct5Pfn/3Um4rSHBr
         /nRAaPixV7CYvKmiPg81Vufo5QhEP9PRBGeOpXaa5dx9BTlO8yPMCUyVJKtih5CuI+wg
         6cnA==
X-Forwarded-Encrypted: i=1; AKwUvByBznZ0+0K/eIn8xAr+VC8DZzwa4mkqfQLZaUIdwTjNm4wPDWN+VEkKfMU//+qtJcuOe1TW6H0e+A==@kvack.org
X-Gm-Message-State: AFuF++n1SN8Y07dJJrpYHZNUWpn1V/5vn89zBiMn9jFXZdppm92KAKv5
	S59KJuwbpvZMPAHAbHQ+MiVHAMAnY7rSWjfDfOBwr6Bdz8p6fYv6jtlo
X-Gm-Gg: AYBFou0eF3ZVbQA2vEMJRThcVLZeMRUsVlrJj7JOmyAsP1agV2JhDyCoOrvgyp+MvrB
	XXaI+KofxlFAYJuCuZ3lUKnQU6xdCcK1wf9eecVC64IdYLykx8IwRPahxB4da3F6j8lKgR1ziSl
	E2atwQNEPej6f76QvcBhgdYeYsQou6uxkZRvcjZHB1VtOmuAtkGeDTJCAjEvp5p2rx0Iu6OGd6j
	Uk2O5va02htdJnbtjAsRJwJBE+5gFOquLjHoC/LEtGz2pk7+Bc0GyfraNfNMG7x4tPa6xuOAWUI
	qUL3s2rPLTLE5efT9A14z/e3442vC5pTENU5KNzWyY8QHYcA+akk0xUaLRbiZ8AFnI+dLIqm6bC
	czTWcie+5LQOJyAFL3JnTVoIAM3OPSWflaHiGg4ajNN9fgTWr0ARBH+Nl5WRwXrAPT7CQ5qBVvW
	q/IXm8V8H16v27+G0hMjPePL21/hkOwl27hORIjy6fpBAXesXKv3dXnvqWhtWMi1qPeLaJRQ==
X-Received: by 2002:a17:90b:3c47:b0:393:19a3:4f1 with SMTP id 98e67ed59e1d1-39debf8d92cmr6628202a91.6.1789401458739;
        Mon, 14 Sep 2026 08:57:38 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39dfda8bdf4sm141419a91.12.2026.09.14.08.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 08:57:38 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 8/8] mm/damon/core-kunit: test invalid damos filter commits
Date: Mon, 14 Sep 2026 23:57:27 +0800
Message-ID: <20260914155729.1518105-1-kunwu.chan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260912191807.138502-9-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2EA4A20002
X-Stat-Signature: 4bopiajq53pkuw7fucdphweqpyt45155
X-HE-Tag: 1789401460-138788
X-HE-Meta: U2FsdGVkX19FS7CH26XKqr1Ospzt5VjnIlhwctHuUMNNy2Pb7jdiEKBHlJaxsOvPMyloXD5U5BrrvcmrjyTenEx6R7dH3VLO1mglpefOwB8HKN9ELTTMGan36PGPixW7CFlLeO6e11ReomrENjIMuFTvOwzeVvza/rzuDzDXjz2z1pMSbiW5iLO+83AXy1v+xxVVkmVTEMM7iQEEr2BpjyDO9RUC6FpVFAeCJkWYqReFFXVLKGYjXv/4RdV3yADxrOIJsXPDpn+gXH3zggEAvm7sYErEo2FjuOpO5mIa9KCEQ0245r/Eq8DzMnVzARXz9akBRpDvnPJF9ZE+tCcmmUcgxpR3RFrV/gT/8NDmq7N9vU1wP+T569elfx4sqxOcLzUyC7Za1xc6PCnWaJPcnorkW0w0UCU23+BkUY8FLnlMlj9jtpDhZifblyO58r+fJExsJdyQgrgp7EAH0fgmTGu3jzizryhtOdqTGPFL5KsniR0OjB1eG+ZwJXKMAZuyMAYS7Ym/Gshv10rJSMJhgPVhj4udK7R8aVuuf8UjHkv7UCNIpY8SmTnr+wUhqczoEjt7Q6pTFZhEBLXE7QwMpmvvZJ+yk/QE85bvd2zETCtKkFl3lViBClKap1Hm5YJtvdpXr+XuG+Sovj2xPdZJ5Thq3AGHdk9IZhZPdZJ1EpEF96JiQH6IoFkNXjGpzjcFRtX729EP7HD/DMlhC62DuVuRZgqr4W1huko6Ke4aWuiUFkwUMGonGW2v6yu8bus33X2JHJKLGdn8oYgC2j3lSyRcY5TgzslL5OUjgNUzzlMTdKWmrcR/mnqTPK1mvH/tXe+kcGQccRWKIgNv4nWMGu95bYrQkXPDlHNfDNNsLk/LIsm2iVisaH+eq02D1rK5l5/LaT3lXXdTjs8V+8pNKUZDSnDyVEAcGtQIJYWS2kG3TpeIXhgbcB3L87Rd57Z2JzToRBruNGXss4WFXbR
 GFptav+O
 0swqsGQcKK3Bx2l4itU7nwmQ2W/VvmM0tsHzMYvzRw3xpZyUUatmERigIWF8jq6o/kZhz2u3XAd/8I2T6BGkQH2rrTAPs1mGdT1ZEx/duwS/xF8k/4ZdQaZLlUAsH6aDjisWHgjGqXSv8rvP1j7Ft3R6eCm7jYBX36fu5ozWsR5gcsd1GZDraogflYiN3I4WcNZ53xOVCepF7wqKyafaTiztJyGfqxNXj4KCx7ZyZ3KoK3x9xXjM7ip/4ZXnN5ecY6UZ2FjOMjOtxC82X6SFRmcqttWtxXwhDiCPizdvs37VfH9GIwInoHVGaSJ64Rh7QKCU8U4MlmhzUSM/+JKExcbI9yEK4LhOkk+vVqhD/u0M6tMw6LQ3/F6tx+auWEG5FsK9cli9Um1BwqNrVZY8zaYVAG/jKeLIkWNkSjfViojkek42aO4cqTtuhgpV4FPK5IS12emxlIQh0wJZLK18yoeMmuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 12 Sep 2026 12:18:06 -0700 SJ Park <sj@kernel.org> wrote:

> Add test cases for testing the validation of damos filter arguments in
> commit time.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/tests/core-kunit.h | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index c9941f3bfb42b..5da84caf4124d 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -1195,6 +1195,13 @@ static void damos_test_commit_filter(struct kunit *test)
>  			.allow = false,
>  			.sz_range = {.min = 234, .max = 345},
>  			}, false);
> +	damos_test_commit_filter_for(test, &dst,
> +			&(struct damos_filter){
> +			.type = DAMOS_FILTER_TYPE_HUGEPAGE_SIZE,
> +			.matching = false,
> +			.allow = false,
> +			.sz_range = {.min = 456, .max = 123},
> +			}, true);
>  	damos_test_commit_filter_for(test, &dst,
>  			&(struct damos_filter){
>  			.type = DAMOS_FILTER_TYPE_UNMAPPED,
> @@ -1208,6 +1215,13 @@ static void damos_test_commit_filter(struct kunit *test)
>  			.allow = false,
>  			.addr_range = {.start = 456, .end = 567},
>  			}, false);
> +	damos_test_commit_filter_for(test, &dst,
> +			&(struct damos_filter){
> +			.type = DAMOS_FILTER_TYPE_ADDR,
> +			.matching = false,
> +			.allow = false,
> +			.addr_range = {.start = 567, .end = 456},
> +			}, true);

Could we also test an invalid PROBE_HITS_WSUM range here?

Patch 4 adds the same max < min validation for
DAMOS_FILTER_TYPE_PROBE_HITS_WSUM, but this test only covers
ADDR and HUGEPAGE_SIZE.

Thanks,
Kunwu

>  	damos_test_commit_filter_for(test, &dst,
>  			&(struct damos_filter){
>  			.type = DAMOS_FILTER_TYPE_TARGET,
> -- 
> 2.47.3
> 

Sent using hkml (https://github.com/sjp38/hackermail)

