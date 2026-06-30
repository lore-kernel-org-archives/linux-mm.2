Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C39B8C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CC5E6B00D8; Tue, 30 Jun 2026 00:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77F7A6B00D9; Tue, 30 Jun 2026 00:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692796B00DA; Tue, 30 Jun 2026 00:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 460356B00D8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:26:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BAF23A038F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:26:25 +0000 (UTC)
X-FDA: 84935292330.04.8A90ADA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2C97D100002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:26:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1Seo8Ff;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782793584;
	b=s9/1+M3O3r1v/asa67V6NiAmaNYncocgLByy0MheDfWK3Aow+JNo48id5dD1ZqOPGx/ezH
	1kwjHeKhNb40yJusB1gODgLA7STTsHk0GA5+yI/K+gWlNmbisVuCvRqfBGX470yxgDmIcE
	BqWadnRvIbtRsRVZcP5Xk+PmSR5A3+M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782793584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ae8t/Ilc5afoONBuaiJzpXJpdh+evRAuQt8lBfqqfFc=;
	b=zhMOpqS+ChZHuNbmA7jQm6fhVOPaMhwTi7UxkTlbwWjc0PDlF8980UTajTav0dU0WSxgYr
	8nrbpFwd/GSbbCzQQZD38qCcRTYmqrVOWHz3gyFwhnKhZJaFaNW9SVSka4f7fWMGv9zZBi
	vWuKedPbwlcrlEPNtbwuA7UDp3k1vh4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1Seo8Ff;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5649F419C5;
	Tue, 30 Jun 2026 04:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E081F000E9;
	Tue, 30 Jun 2026 04:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782793583;
	bh=Ae8t/Ilc5afoONBuaiJzpXJpdh+evRAuQt8lBfqqfFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q1Seo8Ffs3lw+ArmCzrhd6+ZuK+vKuYMzCkkcKrKjxwuJT0X3+DzQ2Awmfl08SI72
	 pIaCRoLbGkSpScHQFf3cHZXrZE7SX8T6cbsPSJsSdCA7QOZOubFE3WbK9N5Xuflktj
	 AUJUIUfPmRsOkDNkIW5rAeKIPjhWe6T3AqAhXhyUDW3MKKKBHcUL5Zn9r+nkRAKn8a
	 cz2W203yWDri1oey6bDLcrkSeF3Qd4TFZcPAaHcbpp/K617KHHh/uLB6HIqMIxCDeR
	 aePKtHaldDnUpqJJIdXc+G7FPb6/UPvk5ym6qX9YRCVuERqhXrbxn4qBoJd4AWPoOe
	 owd+xm28QDkmA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: validate ranges in damon_set_regions()
Date: Mon, 29 Jun 2026 21:26:12 -0700
Message-ID: <20260630042612.151351-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630035221.146458-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: uhg9ay6p8jndz48ezuf46rk84hgzby9n
X-Rspamd-Queue-Id: 2C97D100002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782793584-976106
X-HE-Meta: U2FsdGVkX1+MGoL22WXk9carQkL4gFOFZ8lh20/i01K3NesjHbaY7z7jkMk5BHJWMSRaIqwRdrg9KVmUq72/6TtRIXKwjbWdd+em+2xM0jIqPozV6oWQcD+JMBBMq5mcQTh9HAMUF6LSWYmsXGEqa6qdtUXwfy9305Opha8GZdWzK1hgsKpXFRpeizmEdUp7Agc/qrFBT1SFk2q3G17kOyCAWoH1UxTZkjDU34wMXPdA+hfQn1KqeAXq7YCnC3VaaJdRscEAWdV/4NDwaMpeElIaB7giQi6fcqmxPvdLSG0C07f+9LlAJ8JSGtW0j974IO+Ze7qAFHeMGOPFPt/rwogu22vqLAyeKeT3ZdKA93La28xqsFMrqTQ68HWecuvWHCjySFIHwgv7/5tu0Fg3cWuqdSb+aN5/9+emONT2/jzxwoNqsdDwYj9YD3BT+iAPSxOmc0t0lKj+9quPQceTwS41khX6hs0YZn1mT6j08+FyXvc0l2UFuU5u4T7HkP9o5Mc0fDtd3ZsZvLaSQwCtbPd8oiAFfiVk30gRUIbb7Sa9t3Gnrc6sWO9pvNi+gD15f3MywcXTdMoNqxZdbQ9xqjjKgiMLCZU+9gAN6F0E145YXgO6JYq8r9OzCrKQndyWwXhywgCAHe+6bhP2xT5b2ZZNeZw/LkgsgRXJrRxslMCrzufm2+BVJrxzo1zrDe3UUjPOQLbFdvzmSJbcfUytMVXy5hcFU8v2LdUWhST+egJZmwDgudIhU8xYbAPcvtmJnAlhpxDHb15BecNjyQENBqa/3BjqvtfsQ02+ZJ4kdMHsAldhP5yZLwM99mldH+A3aQEiHq9P2PmeBfHQ/Ns6icXXiFn9eWEqqaOsiiNSou4Zd5QWfMu2eoqxm5eKRv/Vxh18avK220r4WveIDkOWEBikmlCsCRUmToJ6/sNUZp+7PunlVhFa6fSoXo6dKSB/ozDXmBB/YnKdWJVCs1P
 Fs8jUzzm
 501Fk8RQB8l4/VE6zcoCMuPBCx9YeelbXVWNLLQTy1D1cO5Z8CngX3rlmPwjBAE7zDc/y5wcxuNw+7fHZzhqGMcGKpQO7L8v8eDOCU72kub6izRfgTNmbwWYHePIL6itXj9SwMxpmF+zdh5vbEg872nr/a5V1dFNW6naCh/ZbNZNh/4jzW3+cvgIReGmUxBAx9W1P6e4wLs68p8bGsORlra32m9SkuZrbdMPKlk5LUMBWzWV2OtmKID9GV3yFbLEBN+/MySZkHfyhX4VWrVkFKjQvvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 20:52:19 -0700 SJ Park <sj@kernel.org> wrote:

> DAMON core logic assumes zero length regions don't exist.  However, a
> few DAMON API callers including DAMON_SYSFS, DAMON_RECLAIM and
> DAMON_LRU_SORT allow users to set empty monitoring target regions.  This
> could result in WARN_ONCE() on CONFIG_DAMON_DEBUG_SANITY enabled kernel,
> and divide-by-zero from damon_merge_two_regions().
> 
> For example, the WANR_ONCE() can be triggered like below.
> 
>     # grep DAMON_DEBUG_SANITY /boot/config-$(uname -r)
>     # CONFIG_DAMON_DEBUG_SANITY=y
>     # damo start
>     # cd /sys/kernel/mm/damon/admin/kdamonds/0
>     # echo 0 > contexts/0/targets/0/regions/0/start
>     # echo 0 > contexts/0/targets/0/regions/0/end
>     # echo commit > state
>     # dmesg
>     [....]
>     [   73.705780] ------------[ cut here ]------------
>     [   73.707552] start 0 >= end 0
>     [   73.708452] WARNING: mm/damon/core.c:359 at damon_new_region+0x6e/0x80, CPU#1: kdamond.0/758
>     [...]
> 
> All DAMON API callers eventually use damon_set_regions() to setup the
> regions.  Add the validation logic in the function.

Sashiko found a pre-existing issue, and it is not a blocker of this patch in my
opinion.  Read my reply [1] to Sashiko review for more details.  So this patch
is good to go.

[1] https://lore.kernel.org/20260630041806.151124-1-sj@kernel.org


Thanks,
SJ

[...]

