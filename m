Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF696C982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D620E6B00D3; Fri, 18 Sep 2026 20:39:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38F16B00D4; Fri, 18 Sep 2026 20:39:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4EE86B00D5; Fri, 18 Sep 2026 20:39:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A44CC6B00D3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:39:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A3C540151
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:39:44 +0000 (UTC)
X-FDA: 85228653888.10.3414990
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7FB9380002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:39:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YxswELzG;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789778382;
	b=vXqbBvCjDNxtRwFJ+wDGyKkXcWL12n0DIQRti8HlsTE0gVeG91xL1BiZtd1+GsbJsO1ea1
	LDF9Wu2ZupXJ9J7U7/XC1nRfihYlocososEhl1pT8sSdpYJpvGb9P/1hijf3Wp6eN3vcI6
	KVT97gGPYsQ7eZ4grOFwR0CGpck+2GQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YxswELzG;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789778382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CC3PdNBrxK34qSjQLT4O1R4qqqd64RoBJ3Qvdxwx02w=;
	b=18HJRXR2mQpb98p0wXPbRt5w/Gq+9gsD82gtRI+9NcxgtJI0865J3b47LhoXmLAL7iVNBr
	ri0T4FFGzZ+dqgGpEu9I6UThv2Hi1XxD/FjWNWY1yx04vP8/NzUDWpegRrUQof3T5L5GUP
	FGAC459qpdSXbB9T9+N3BiZgsG+Mmyg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A0B7243AC2;
	Sat, 19 Sep 2026 00:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446AB1F000FF;
	Sat, 19 Sep 2026 00:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789778381;
	bh=CC3PdNBrxK34qSjQLT4O1R4qqqd64RoBJ3Qvdxwx02w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YxswELzGeJ59W+XHmOUpf6T6ZhmtLAHeROAGRpgwvBCV9Fw2v7en9/kaOdtdBIjZg
	 /fpkHfgMqnAcTkMY+kWWYpT/gZXyl5n20RB+fed2k73taVhyzEoZ079yQyij/J7tzO
	 z14lIZaJR0kYR6hIHcCJ7/YX6w6KvVDulqnZ19GaSvSQBojIzDf7ejKB09ep3damgN
	 a4UtQKKU5E79iU0HSI5d/zxkkRlUSp7Ml8fHAnAbtEs+O0OPjSa8aEeplOwp9RssUh
	 YLW45dJhA/1sFDY1VHEbHSvgMIu1bud0+QqT84G2S5UkXmCbTKPZvmx2qKSZqa2oWo
	 HBcOhowqO3lLg==
From: SJ Park <sj@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: Re: [PATCH] mm/vmalloc: Use %p for pointer formatting
Date: Fri, 18 Sep 2026 17:39:33 -0700
Message-ID: <20260919003934.86889-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918105013.UpdykT6j@linutronix.de>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7FB9380002
X-Stat-Signature: fmx9gyshcseuutogbgndn5q34ycp9ehh
X-Rspam-User: 
X-HE-Tag: 1789778382-379049
X-HE-Meta: U2FsdGVkX19MtiI7VmZhgMWSG3tjkgEyYgROqncfhCvtyTT97KNf5/C5AjzHlIo53A9rAMmKUFfsXwY/zW274lg+V/gXD/UuQqIqox4CvuS8TeG0X2cZzjBfWqek7za0IjnNzBf9SeelnzNDhK+dseAmFBwEwjXoC1Y2/VsNg9T5zX8PmzgzY85LKXE7YEydrTCq23aP31ov6Nmw3i1q3RxeapAsqEaxtvFnoj2dGE/roWAtF35NH6SPWxSsz/3JXdKjnd4TptLhbtwKOL3l+8itt5zRI9TU6XcvjqosTqRGTCyBKzxluzgsLcjZuZNMyswCEp5bm7HxLWREJHNrHd1L6prZcDycc1VQOGgh8P21+n4jzSBPM/m9EXcittq9GzsB2eTHcQrHBGbi2oc5RU/ABGbuZFQ2O77CL5+XkmbUm04Yenv08XGmDWdKphC9PdcSnecudmmooQcf/g13+NXV8EQu2+QBTBLLNqvysbWDC1nX1QY7PQYVY5NeGrz1DWB91I0RCkg0cu8DMv5QlIZ8Qe0nSAflGd+NVGhtw0U5fYXR1zKaZfuLuxShH3Djy7dMpkthy9+s835xc0gkIhSW334i4CiNHs/3ARKzOu/MaXDObHaBEtH/zUZAX4Zn/rMb1v96e7E9WwVYVzTLadoMmNIz1ZMkbw/K7KcVTIOTvOEZwF9+0pGaxizb1BYr8Y/E6phKjyOz1s4U/a1IGRfYL7cOhhE+1mYKsP43FrSv8lIxbORzuBTyNC5YQq1sd/w8Z5dGUCzZSMq/goEmcb6Fc403H/VmLBYcmXIygma7Cw0Ehlzbv5pO4IecEwp/Kcg9cQ1cgwSRuGSSi54gF74ajq21i35w0jd44/coC8koMtCczx58tni5gwJs4tcTU+6JFDq6/Um2TM23Iakj8slXqolaFlshDyj4wKYjizm0hs9b+BnS3384E0Gkf1YvgmMlsZpK1BXVvq3kWYm
 2vQdzDYW
 JwY6rE97gJyKyOB87pm3JBTx2TxFpkDF8I7bSRbPmMbh9qk2MaN3ax/Bvje9bsqtP1DM9Z9qiH5btorCtnX7JJM8D3UXrPk/rNJF4cttXzm/rhhKkFwmzhKTL0gwiunPq9YTIk+j5tj6AINPoy/kJqtpJ9iM+iNTgxjiSOT8nZsmjiakqpRl0V+nYlegvz94IvmAlW3oS3IB877MbUeARwRMoFCw6f+6/UyG3owNy2UmGjmJT853UujmLEnVOzGlHNnE/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 12:50:13 +0200 Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> Commit 45ec16908e84e ("mm: use %pK for /proc/vmallocinfo") introduced
> the %pK in order not to leak kernel pointers.
> Since commit ad67b74d2469d ("printk: hash addresses printed with
> %p") pointers are hashed by default and the behaviour can be controller

s/controller/controlled/ ?

> by `hash_pointers' boot argument.
> The policy on %p is to not introduce new ones.
> Removing %pK makes it possible to remove its handling from the library.
> 
> Looking at the output, having the pointer in the output makes it
> possible to distinguish the individual entries.
> 
> Use %p instead %pK.

Makes sense to me.

> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

