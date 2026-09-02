Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E539DC624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08EB06B0088; Wed,  2 Sep 2026 10:07:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066256B008A; Wed,  2 Sep 2026 10:07:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBED06B008C; Wed,  2 Sep 2026 10:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEC206B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:07:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 787F21A0238
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:07:26 +0000 (UTC)
X-FDA: 85168999692.12.D1EB438
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id A4F8516000F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:07:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cNDe4sQB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788358044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cu79MV34wPsRG2WV//Qk9X9lwsBT7aOPE1XdtKONwGs=;
	b=uYoNXcyzN8Z/xNdW0rxbGvaz1ngjJGVzDBrCKRwC79CumaSIJOjOE2hAITwssuZV00Nobf
	1kBQ22qjhxUHOa7exIsWUYq95MevydhXLkHOlyXFM0oUyFfdf5qQdc0TBdSHFU86mvKtG0
	geQvd4uPHOR6ox2ogbmNfzNyhsX2UTY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cNDe4sQB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788358044;
	b=qS9zMdlWxSNk5HnYBAq5bsB0Pa7RgVRmw2kA+PcfQiNGBYy1j7gg6bejZ1+Jgr/E2as6D8
	xiHu60qzNY/VsKz3+tojL0eFnSqwWz5r93uLoV5rV8dOWFl3rDi/LeJa1Lry5uJTtiiW7Z
	AnHBg9Az6Th64l1RUF4dXyIluhSU5u0=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2d72ae08fa1so9312005ad.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 07:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788358043; x=1788962843; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cu79MV34wPsRG2WV//Qk9X9lwsBT7aOPE1XdtKONwGs=;
        b=cNDe4sQB2wC1rKYwGr3qzvQkM4DmN4q9RIYbBGoIYwZz+c0if11I/O9yCoFG57sW9i
         DzTwMRJ8woAZcdHrrfrp5QNt9ND6u1iWEg8HR+lWowdQ5KdJlqUt4E5ZISzy5IbAPmcb
         MzKtYpcDg35rFfmn8AvE1PyXUUZrSiDwESdmsla24FF5Vubzdpr4R9L1BqEUQMRJXjhs
         gp3x3KoJ7k2OpDz2A0hzKoKDtjyn0ebeV98zmjt9LbgTqxNgcLftqA4/xSP53kumrzKd
         +1STdJw+j0DdYcKvEw/V4q2sjqBZ2xrjwpOtpdmLakHOGVJcZ9Kw3pcfmRTOR8TDO464
         6gNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788358043; x=1788962843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Cu79MV34wPsRG2WV//Qk9X9lwsBT7aOPE1XdtKONwGs=;
        b=NizT6Qf23oL81j9c2mZglt4luv38kd2NGjE3qHGuIracsUb++azG1ns16CnoOicaMO
         jKnNB5c39MANuAAzqZ8wXHI+/XUhUugBEZ52DisP0h7PGHEypvPPJLNWelTQOyz4Bxqp
         QFIbbvaTTcaGU/63fupGOoD1nBZUHkl1rIZPAGxdEVvbQ9q957VsyCE4F5flDGt5KQsO
         2ecRfKBzsdOjuBd7YEgymZUNbusuU8fonsWg9ZPShgyUctr3RT5u5ypEtqPS8UU4LPmb
         UJdMgZZbVO7Ux7iYxzuMa5gVd0JMu0Mwv/sqytOkjSJygQHMz/MTdk6C8BtrX7uAlM5r
         S3Dw==
X-Forwarded-Encrypted: i=1; AKwUvByzfg2OZoYQjpPeVqMx++GMKXVr/wyDCf+FbQkJv8K/idmuBbwJSzLXfJZrdFWYH2SR4JgKegyBPg==@kvack.org
X-Gm-Message-State: AFuF++kUwea6F4ynX5ZXcsMeE66CTRqv3Rlrop+PYGnibMzYGad3FB0r
	qSZQLDGEOMrSIBOjJk8CJLNBuVHqHNKEy/kwkCOBzMR4PyoTVzNonyD8
X-Gm-Gg: AYBFou2CVDOLy6PEkmv1MQDP2zPEjOhz4XDtLyTysjjEirCw9RDcbZgWCsviWhxcqov
	DZXPjwv2M7F+ldDfupz4ZSDLnvve+Fzodr44z9tayagAWqItdvPgH1402STbKogbD4QiIEqQycd
	Q5V3LGJqNB2MShLVq58/dfHPNkim/8e7EbhrRMxC8Xl1QYuYfFkWSlKT5VhiA2D1EnJWRAWiQvc
	vHlUzksiSMN4osFc1uwzWfduoyXNayAkNGpTs8D0L6ZiXxDQYym06mFo2vTY+iC55EuI+uElSfI
	qjCB0BbMBeWNNeFrMsGmmLdxqP8K2re/SNpW5r8RRTooN/7d7GvHDJ01Ibi6Rlg8dP3Klk2cl7z
	aKEt22Zze4ks5MAy3l7kQoM5UBe5scUkEWs/+94uPlmDup09X2I8CImpVALpRrZCs9s5q+aDpAe
	UUXxh+8Zt5s5c9L+c0g8iTtsL0W1X1RmyPGeh1VCA3Quv28hvrbnCFny5HzrU=
X-Received: by 2002:a17:90b:35c8:b0:393:194d:5366 with SMTP id 98e67ed59e1d1-39aedf43130mr7799632a91.10.1788358042526;
        Wed, 02 Sep 2026 07:07:22 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae380d7a9sm5579972a91.12.2026.09.02.07.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 07:07:22 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 05/12] mm/damon/sysfs: remove probes number validation
Date: Wed,  2 Sep 2026 22:07:13 +0800
Message-ID: <20260902140714.4023700-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902054747.99370-6-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A4F8516000F
X-Stat-Signature: djxkdptc1qq5m6bitf9xkd3dotsq6jpz
X-Rspam-User: 
X-HE-Tag: 1788358044-489226
X-HE-Meta: U2FsdGVkX18VuGnE93dzVmlx1Ez6CHnkPCVYDwPDn5qpgxG3q0rePD7qHio6UxpwsGKwpGsr0CSPlTTYrG6G1E/htSBtZkgpIPN8mWzQGH+7aAP1HcD+WgK9ApAuQea4F76UMO68GPvx151rJT8hAzyOTvFwu25CqloRDCSM8HwyTor6xirx0dILJ7E9PVJs5KXnq7Lrs23VNmB+2yOnKt0NT6UBt6dgZ5Wwc3+cyHEwuGqM9JX9N+os2t+yF66bLPzj29zZfFJozsDHvCDWoAw4UX02ubKyTnAPB5hi7acdDFSyfAxmZAMbMFbitz6o1bLB4+RqfIDzsWvGhyjrz7tPDFtEgIEd+gFtjqeBAH1pEyCiqKMzU0zsdczM3R4rGCuPAnJhfJj0FJEP1256zj+OMIlBqKiYOMdkfRY0zaMFmO4U9/nVBOVgOoiD9hPtUBD1hQ9QYYE5tptkHTHt+W/Sh/8jVgXNUAsM0cqB9ETc0DKFHlBvP+4mwD/T4rxh7rwheMRbUWPxAozPHVpt+y+XWVp32gfesZVSXZ9Ya5OzZOEuMbyfCGt6u2n4K9TveM1Pt7lTWgsJuhStQKy+Ucvg/1hVSn3Tv30AGkrn6teTqfTj1XkiE8Xfg/UiJC8ADJN4+QdP3oTjM1mfoH6HEHFlDNCBhtl8ngireDLcbziVrtZdWzGfPgRP4wSKQYQgdq0ddCB/aGErtdTdhkmssWH0RpkT4MI+l4r+ayNWGOna5H4A5hhI8hLouhwQ7+npeSB/KARoCCgYZnuZlu6+7w9b3GcxOpp5bsz1Ev9LzcvwFV5yD6og9Ee3zi4RJPmeNT+d3jFpmD3kd3XEhoPsPK1OATpU5W0rmkL78rU7FEVyrfAsvpahcADy+CH53xd/571zHkE+xQD54xRNFtlS6ugkRKjcCtOglwTBwyfTJXlA6mpx09/VaWZSbki1GX6fJfPxmCEo75+nwEWXoK+
 UrTfLWpT
 +zYLLce4o6ZQt7e5akguMsvOP+ReaCpSn5bTly01ox5LPleIFHkK0u0cZ7/mIVR4VB/1uAqJIKGy0assGFmNfH310PTfh2sGH6pdttHRQrox6XxO+JiHRSPQpc6OmZ0RoxurIWVY13C7iRZ2K4m8SSWCK7/1D1RnbHgWY9h/nAjm14RIbBSOK3pNB+J24k4dGYo1PPQVVb6maZ+k1kM29zEHrJZ+lLh+YBqHpnbdkeB0ugrm1UImsalK3c3tdX6AzuXt7QbELSlOGK6joKsgugG9jGUp/nOFl/bFCYxb3OYFYkzMa7Jd/ecivvOOLul2PUoErn4L/RpLTuvvYyF3Px2c2EANveCF8Oyn96nbhUSI2TRx6LBme6YOfptVP63+VK9ZS4mXuRyhj3gQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 22:47:38 -0700 SJ Park <sj@kernel.org> wrote:

> DAMON sysfs interface is disallowing >DAMON_MAX_PROBES nr_probes input,
> since DAMON_MAX_PROBES is the upper limit of probes per DAMON context.
> The core layer is validating the upper limit again, though.  It is
> preferred to let DAMON API callers such as sysfs interface to set
> parameters in flexible ways, and do parameters validation in the core
> layer.  Drop the duplicated validation in the sysfs interface.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index 7ec14f48d157a..b576e97cbfdb8 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -1479,7 +1479,7 @@ static ssize_t nr_probes_store(struct kobject *kobj,
>  
>  	if (err)
>  		return err;
> -	if (nr < 0 || nr > DAMON_MAX_PROBES)
> +	if (nr < 0)

Hi SJ,

Thanks for the cleanup.

I was wondering whether DAMON_MAX_PROBES is purely a core invariant
or also an interface constraint.

With this change, sysfs allows nr_probes larger than
DAMON_MAX_PROBES and damon_sysfs_probes_add_dirs() will start creating
probe objects before the configuration is later rejected by
damon_valid_probe_params().

Since nr_probes directly controls the number of sysfs objects created,
do we still want to keep an early check here?

I agree that the core validation is required for non-sysfs callers,
but I am not sure whether this particular limit should be duplicated
at the sysfs layer.

Thanks,
Kunwu


>  		return -EINVAL;
>  
>  	probes = container_of(kobj, struct damon_sysfs_probes, kobj);
> -- 
> 2.47.3
> 

Sent using hkml (https://github.com/sjp38/hackermail)

