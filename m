Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A725CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 19:28:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14CF66B0088; Mon, 12 Oct 2026 15:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FE9F6B0092; Mon, 12 Oct 2026 15:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 013BF6B0095; Mon, 12 Oct 2026 15:28:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9E906B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:28:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E5B6A955D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:28:47 +0000 (UTC)
X-FDA: 85314961494.03.CC110B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D7E4940002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:28:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A+npfRnE;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791833325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F6YTrWlSG0KaQsqoHz1caRKOr6WL1WTGFAkjWA6v6qY=;
	b=Hmggh0XkztFGamxv8y8LCpK9GTFsU2672FpAy+Kdrv7MA9OfxP0KJhej0IKLmnb/QOluLf
	nlv8KhinUoBGRmsUEIYPpy/IK4awrKuAxZe5R3xbjuwY7MW85yoPrad9cccRRep6KpkCSG
	kBY2IV0IWb6tzM8feoiVxB32eG4yglI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A+npfRnE;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791833325;
	b=Vp7eHnIh1wwXq8/+pTHJJtQQVvlEaA2tXPzvuF9fO9pnaAOQ35i/AaHwiqyWqFB32g+OzK
	2thgxX6WP2X3ZDGlSoMoLmRQjV4MHVMPt4z0my1PnPDc2nwDePeu8JYIN4tWgMyx9CHAgO
	ejf6SJ2FgH0wmQ3ivd4Tcu/laOENfIk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A63860142;
	Mon, 12 Oct 2026 19:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C001F0089B;
	Mon, 12 Oct 2026 19:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791833325;
	bh=F6YTrWlSG0KaQsqoHz1caRKOr6WL1WTGFAkjWA6v6qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A+npfRnELjBsUDLIhxTkqxZ8gm/uEOEFphgjCwggWLJnw0L5Y1qRAlSznGTo9iG60
	 GunbIzKq6zeGkcUlIwHYCthRy8FuUCeKZFfDet2V0OesAeFRlkm+QBKrHBExI9a9ZY
	 Nz2WKfZv4LQh+AZ49NtbO13DlNba2fTxZ/fqtff6rhB4JsImOpmJFwlR0y1ES4eoxl
	 OQzHz6riQtQDVXrp2lXh0yX07wcQ7Xs9t/WpM02B08yH9LyB51/EID7TBvyII4q39c
	 7aut7npgKDhOaBK/XGHf9KDYfVq+UkSkRbeW5i9ZnsWSXKylYb2hh4rBLreyiA9e6g
	 aAld2D14AufvA==
From: SJ Park <sj@kernel.org>
To: Suhaas Joshi <suhaas@s-joshi.in>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/damon/core: Use only installed probe in damon_merge_two_regions()
Date: Mon, 12 Oct 2026 12:28:37 -0700
Message-ID: <20261012192838.372841-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261012150045.169377-1-suhaas@s-joshi.in>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D7E4940002
X-Stat-Signature: 8aaz4zkw6xi387odf93z9maz5xtpyi9f
X-HE-Tag: 1791833325-269618
X-HE-Meta: U2FsdGVkX1+QeHS28xsDXCwe5ikHI32Cx4ixXCRCzBJhs8x6GfSIEMxtNmZfXpI8t7+fOCjZoVb68GPW2dLWHvlS2xOsszVbNVugZudFXIfR6p31cDQvknzAiSTO7gPgpVvFyvOB/06QGmx0nIqfgKnO5cdA+sy3zzj6seOS1v6AZ90SyROm/VLrOj8c8VxELYaAlsQmZF68yeIJkpIBCGSCaPq/GgQegXHEuW5AsZQ/tmTgKWsaGNkZAIDI4Z/6g9jMBTIpvwRbfii50hlB/HxL3vodoqY+HJXC2GJprnhYeAaZUAP5/BbdHvrz0G6pmxsmymm5VPSSCjHtu9wqgAbuRgsu8exc5KY/3erOgKNczd9cBjx+5xd+5l4t1YBEYnt4xMQTbT2sKveFrzvdScV7bK+tdbDpc4RMz5PRkpadWJhEggh3B/QoxqaDc5ptxTjcM9T5dQzud8nw9OXVpCHJOGGinSbMay7lO5NgeaH252qJ+Z/+exdBD5D5gkyfCOCY76uYNIebaQzoOlUrRxFLlOz/97kIX1JnhLEU553Cjf64LZ8BqzxEYWEAq5Lx/L3DNiv31Cz+UWDztGDPV/jM7G5zrkdtbnqXpcH1WrLauL3/kWn/UfMhjWXN73NX8ZBn/AXa6vmZToGMYUwNwmFu8IEro5q8KnJX42HiEwN+GaViVIUJIG1veBQ6k6UOmdlWDoxoVEkKk9L4MRrdhPz4ORpibIWMx/JIkN+BDfCJ9wrdQx1zVbGkbaYkOIiJ8gM3+Wid0i/iib1COreWCMqv1ZFgE0qVSLfDDGyPHpR81ehYHtHpiw31eYd8voh/RxAbB+15rpILBEdbiCdvGLOAJoqXT9fLpoXRzbmVB296pOBdrmI3VDnaSc/qCa2VxxBPzVNwJ/BG/nv18TSh+DGCJXeDe4N77OZ20gCqz6QxaaqivXGzlsU/uD/CZdHPx05r5WmEh4SGpbfwVBu
 M6BiFYHj
 E98R4OZeIoelF7X/j6a4bQE1MACHePW25ic0qFUsayO2DNPT47uPTHpeQ4AtKg5jAGgjNUgxtw38cYWZR22owA1GjP9nFL62t5Te/dpVVJaJEGRA65jhac4XRTnXtKhoL9GYq2EnxQ2bkt2t+0UPLLrUeF/As1QTTrrh/72MlQxP5dhyLwrxwBpuF8impa2bOdJENW5Th1BUqByvq/TMcUHMboFWd2mjKM19kApPeMpmtjfNFDQcVI0VOQG/iu5TfVsFXZSVBnl0ELxRNTYoUg21eow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Oct 2026 20:30:39 +0530 Suhaas Joshi <suhaas@s-joshi.in> wrote:

> While merging 2 regions, we iterate over the entire probe_hits[] array,
> whose size is determined by the DAMON_MAX_PROBES macro. However, it is
> possible that we have fewer probes installed than DAMON_MAX_PROBES. In such
> cases, we end up making redundant iterations. Therefore, to remedy this,
> iterate over the list of installed probes instead of iterating over the
> entire array. For doing this, start accepting a struct damon_ctx in
> damon_merge_two_regions(), and update calling functions to pass this
> argument.
> 
> Update the damon_test_merge_two() test to use this new signature for
> damon_merge_two_regions() as well.
[...]
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
[...]
> @@ -206,7 +208,21 @@ static void damon_test_merge_two(struct kunit *test)
>  	r2->age = 21;
>  	damon_add_region(r2, t);
>  
> -	damon_merge_two_regions(t, r, r2);
> +	p = damon_new_probe();
> +	if (!p) {
> +		kunit_skip(test, "probe alloc fail");
> +		damon_free_target(t);
> +	}

As Sashiko also asked [1], shouldn't kunit_skip() be called after
damon_free_target()?

[1] https://lore.kernel.org/sashiko-outbox-168320@kernel.org


Thanks,
SJ

[...]

