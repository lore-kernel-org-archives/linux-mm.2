Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF5E606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qz5K2L2q
Received: by kanga.kvack.org (Postfix)
	id 6E0B76B05C2; Mon, 23 Nov 2026 07:03:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B90F6B05C3; Mon, 23 Nov 2026 07:03:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 597F06B05C4; Mon, 23 Nov 2026 07:03:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 393F16B05C2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:03:23 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE8E616085C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:03:22 +0000 (UTC)
X-FDA: 85466248644.18.B721EF7
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id D78E2A0019
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:03:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qz5K2L2q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795435401;
	b=CrKenbUdH1jbM6GI2OdPhDEXvJ8uedqu51Gvi1J2ae71g0ugrzAIHLG+8e9W0dU9Adv7Tl
	B9E8MXCjss2sLM6kT+MZDoxx4TiR8H5x82HOUryRTbeQGzNDswZC5R+gGQhpQCOZ7i+ynv
	vVeN/p01jMuvIZzkrxyL3amE49k3lPg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795435401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wF2BrtRxuWZRCxFUdbfJu7L6nOWBrpCm7Go7waMKPQs=;
	b=SL/8o11xPFjAtv9I/QxQPIpq4MsVhaxgm2mrhlHGdGk1KCwX1EvBGl+VTAc/tx7U5WNKy0
	nE2bl/1mZaf1hDDWKQ7eg8h5ngar/UXa7xujVL0IsDL6ha0otHEZAyAdjSibQ1wB2gOb+i
	FcurwycfT7nyguKCjWQZJmPquyPslww=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qz5K2L2q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1b3b4944a0eso2156960c88.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795435400; x=1796040200; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wF2BrtRxuWZRCxFUdbfJu7L6nOWBrpCm7Go7waMKPQs=;
        b=qz5K2L2qCRbhWeewQEIt8a+zve3nAtXL4rgXCeylsnJwpnJ/FpSq3Ppv8cnTwhHnVV
         q9PaUWN5HX6Uo84p/guR+5shP1OZQhtwHMfJP+oV8JOb8ZAj3AmABmnCt3UfzivgohiP
         3WgO8Jczt4fxq3r8jPpqlLdxKjqhYXAUMcYYyzkekBcnAwtv4F/2ECJxGjtV9v5ANFA3
         74GkGRgDAzI9OC0A1D8KmlHR5KaiwS3l3cPin/NZrKTa23l34eb6x+sT40Em9D2VIOiY
         stWAJWDZVC/uaVmyvoDx0dHtJKhJpOF6M77GK3EiwHwGy1i1mmL3mHGA7x2EbCTDjmXO
         5eYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795435400; x=1796040200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wF2BrtRxuWZRCxFUdbfJu7L6nOWBrpCm7Go7waMKPQs=;
        b=0SIkgJ7vh/GBLCWaPDsB8gi8X7hNBQwJOk6KXivTTc3yOgHj60L2vTQ6Z4uVdB0HTc
         T/Q19MmThrZmguHD25RIJiIDD0U585/9Q+YQ5fhB29eBDvAYbr5IpWHSOS3JUCqKJJ0v
         lJuzPutU2LBO5l/ZIGHCRhRK4NXljz2EBfrUb9prWmQ9LXsQ8KNNjzOvujCVPio/xnUC
         j9o1ITvUzrZIRn6EtT+UXE9TtvDwe9Eihn1BE0PE7zhdy95qx4CfA9B1icjaQ1qQFrbs
         AZKTRnWX8GH2dazBiWwlDnkiJmZuEHRRFz9wtN7ZQ++A3Kx4F4etV5PkhuO9eepv1gvT
         e1sw==
X-Forwarded-Encrypted: i=1; AL+hErGP5epDqPdHjYCdlQHXDtb1yk0fXqgVqggXVcLZQNcJW1DThH4cL0MnA+zkSLt11sQXSy8+SYXYQA==@kvack.org
X-Gm-Message-State: APuU4Z+qK2flJObC2OE6JwawKReewyRbk0GRI7gVle4BT+s9d1WLnw2e
	VG+6T1qW+44E5YUXvcQB2nfiZzwCgD8qE68vuym1lLmkr1L06PhgLuRgQpbro17VVGE=
X-Gm-Gg: AZFdTZeMlemKHOKhza1YU6TmDrsCcKtrl3j6jItXacygYPbQx0cJpw3gyUan8nBUtkU
	MmIdfoCbBdIlQbEf1q8D2nyL33vmvmZgleu+/5W1QQBnL8zziuhxfF9ecd252OCi88qLsRNVsjs
	guE5WUVUzdP70Ihcr7WW9nanQEDzw/O6NnGZuujjmqQsRFz7vTpOj/MX80PVMzNhcvM0IA+gr0n
	dHrGQGy+UKjpdBLZjwLg/zTS+wpFiybe50V/m1Yytf6YiS8JlRvSahUxsFSSWatBO7bpZplnsur
	/sHismjZzYmWWSYKKIeU0oicaMSqPCaj6rtcn0aygoanGigc5Bnk8/oqfy+VcGxlXnVudj/PPq/
	7Ixe5Nu4fBltRXIgDf84TsqDxmdKNrw0IPyI1r/0IOa2kuf8UDEoMARg8JB3vRz5aQRoS6MKDIy
	QjqTu1wXRTtCr8YFDRKfBKJMzmFN+BIxTznJwiwMTIKaH6s6qqi1tkZ2Sjn4dqtWRfEgS8TsFfS
	B9GGnNYs/fuxYYuTsDCPr1F1osRGH/Dk4gAKARP3Xkv4VFvLwqEU8WKxjyEGBrTIso8IEBQqGMi
	JSv+Fa5upgjWS8EQ1gZMqkiG7ZMiCJ+R4q6Z/wIdAdrCKnXludN3ykVdoGKJyIILxJUu
X-Received: by 2002:a05:7022:ea8a:b0:1b5:3819:f8a with SMTP id a92af1059eb24-1b5569050demr11450885c88.38.1795435399661;
        Mon, 23 Nov 2026 04:03:19 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5566c3052sm27944108c88.1.2026.11.23.04.03.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 04:03:19 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 21/27] mm/damon/sysfs: add user_report support for report type input
Date: Mon, 23 Nov 2026 20:03:02 +0800
Message-ID: <20261123120310.9444-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-22-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-22-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D78E2A0019
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: tt9seiag9fq8dy99pkgzhgbn8pgn313t
X-HE-Tag: 1795435400-990473
X-HE-Meta: U2FsdGVkX19RxYUZLyHw9h/BKUReNeO+3Lk8i+lYJTfhe21j7vcx289kxabSY4V39DPdB4LfHbH45k/AMcYatASeCEjieXoduiRMwQA0FkIn3Dbux/QGq79gIjFGkSlZUwNjEpawkZwLp7OujgCx8zmKavYPdK8qeKi+p3efCeuVoTXEY5zLhz4xt2WI795joQOFpH+8EI/zms9F3GUhdpmgCJc96NXmToRW1J20H1Fd5PukPYYlyQa8vye56j5KReBkeM0RshQGU0J30oLDREO2EoycZ69bY6cIFpmCCnjCbc2lSLSAzVCRD7Y+jvgF5QOcswZUlZTOf5XxWLYApQqbduSPilObEZ/QvC0d2fpmzJRvUcyqwhI1Z3SryqUyHNJ8FCEnb9RfoSte8f98ncgjF+jskjwOWzec3oaOFTnd37PTOv9f5LtPBNatHd9SdOZZFqkw4fDMato7qFcEZUoKyOCYEZTIrhxs9NKQ/+/nk61Erh7qLUZeMx0jZgxNqlPKpGXkx2V35mD9KigWS4KkS+xMLQKQlmGwXUhVU0Cw0tT7wb401SKuQ77Ta658ruFMFpNJJqUyDNVk7sQI27bJkVMdqvsH0P9dWjXYd5wjOYKC3WFZ9Tv0JAvn2RNiYczSkqcPnPsP6XGlI5w/MDowqjvRC3/WKb1xp+E8NJykboDZtqv9mI1ByD0hem0Dqlf9L9kJ102Y8plS1Wzh+/gIDMOOvM2ZNaF4AsxhibSDw1J+UL4sbM8+rf54OOx2fvvL5QcsyRPGViCtr/ir9wOLZTsXAjKdCrUhC7mn95rLEmB9CRZls2KzRc06O6FoNxOCfkQBgGxlrk6O9XgldmqvrHJ2eAk1NTu5jUzf6XpG0nEhumn4URDcXbF7OefDsd1ZwvNpCEKe0cYVKcQTgFhgC+cznk3yBGioIqizQAKNNGeSUPf2vDuuuWU+2M4BvvUMs6uVV3H5zZBdfNa
 4BhodaMv
 grmtdfdFrEbjQSmKqqXGsCXFTzVc1eeclxNft153tXDpRBntdnRZHWcOVaxka4gImMd/NFR/ItY/02llgO6zX+cdffln2KGmJEEBtbvGwrxxdrj9m7ICszRqrJXC89k+qvZ8mCFaGNXM/amFQZq29cil4iK2gl/SBMOwFWgqvqippEVKegfUnEKSfabQnKrLVkNb8NSDezGwYqcQg19qQ5TzNvhARgOJW6uR+mfNLfKad1rrZKOuU3Jnd3xkOjMMXlSBV7KiwdrJ8TGZOd+pSYi0pKKq4lP4spdu01uxV11cb5dBQQLPb2c1s0NWwlYJL657YRvpBsbH/0Ze5WZoSYnxzAd/KsGlJRYJP7Ro1lgW7qyAt3+VPPhmdbg3q62zIToqrB+OKosnN3oa9sOlOBWa8x+ElfbpMmU0FC1Z2WP4kNf314Y7PUDTkNL346EGRzK7Eaf94tB6Q7KiiDADAa07nB+FQSBEnw1lRF0j1PV8CRfPqNWGy13x6ds511vsL+ei+MfhpZGLgvYAlim9gNCmO6N09QAsOj7B6TBx1m+9qBHpSACnQQ3vjgFtmd3tPJyS8kwBBglObLSo9s+myHBXd/qyGLo+93mFzHvk9/lQmAnpIMw4O4dC2+vNsvexvZuRcgWGAGVA9v+F+zofCsJN/tes1KINZueNZwOx3EF4k3fOJKoaapeCi+ZBVzzL0gsUB1eAWRqgeYP69GN+LCodFQP5zBHzABo6Q/zwdY1FgKm0B6wj1tdsNXpsN5Me8EODwz+Rbnalxz5H36HEhXIEDAUj37Ija7GBk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 13:00:05 -0800 SJ Park <sj@kernel.org> wrote:

> Extend the mapping list for data attribute report types and user
> keywords, for the USER_REPORT report type.  Use "user_report" as the
> matching user keyword.

Makes sense, so LGTM.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

