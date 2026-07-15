Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A64F1C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 04:46:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069556B0088; Wed, 15 Jul 2026 00:46:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0F426B008C; Wed, 15 Jul 2026 00:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1FC6B0092; Wed, 15 Jul 2026 00:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AAB5D6B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:46:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18F141605C9
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:46:08 +0000 (UTC)
X-FDA: 84989774016.02.B805635
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 62DFF20004
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:46:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=q4O8mCN2;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784090766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yPSXgtZyZUjPzhY0+tGPbfG3fWnFA8alzR4dcKz8MY4=;
	b=T+VH4ggMdMqBzEiSMMPa7LvSVqj5UmBGbbMFDF9qys+ddgG64nJS9bjjpIXsjtDt+G2IkZ
	zK/ONpbonAio5KH/fEwAeOo4Rh/BrSsYwtQ12lw0CKmCTvWDDMJaNSwbjIGodg0LQ0zaU9
	k8n49PX0gz5JS8TEpkM2Z1B5BNVK1wg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=q4O8mCN2;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784090766;
	b=gnS95iP2SO8T6ZWYVdYNkFV8K/YgWZdi41BTEOMpwIe/LGimo+44BIdBDg1diUsQ5Z6WYy
	fdeHZEkW5G8wVeFDnAjMJFe21FUEmRj+DOQTpV0BSyEVXbuyPuON30HY6um+Sq4v6mHXcx
	B+BrsK9fkbEqJT1JnXomi6t6Rmbb11k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 57E62600FF;
	Wed, 15 Jul 2026 04:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0311F000E9;
	Wed, 15 Jul 2026 04:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784090765;
	bh=yPSXgtZyZUjPzhY0+tGPbfG3fWnFA8alzR4dcKz8MY4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=q4O8mCN2Wldnjn2dROG4NkiHVkge2rzmi9u30M/YOygz85Hzobi2j0PY1EBOS2f75
	 vi70A6NF+w51j7g7FpFqmM30I7/b33bWqJk8/OxKpLUoeJsckqqCxZDh9FyRENit/G
	 2LV3lx5ZSMX8q/wLIeXQU3jBZd3EuN/KTX5kh49I=
Date: Tue, 14 Jul 2026 21:46:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SJ Park <sj@kernel.org>
Cc: stable@vger.kernel.org, Brendan Higgins <brendan.higgins@linux.dev>,
 David Gow <davidgow@davidgow.net>, Fernand Sieber <sieberf@amazon.com>,
 Leonard Foerster <foersleo@amazon.de>, Quanmin Yan
 <yanquanmin1@huawei.com>, SeongJae Park <sjpark@amazon.de>, Shakeel Butt
 <shakeel.butt@linux.dev>, damon@lists.linux.dev,
 kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1.1 0/6] mm/damon: unurgent fixes for infinite loop,
 NULL de-ref and races
Message-Id: <20260714214604.10fc4c786277eaed523d0724@linux-foundation.org>
In-Reply-To: <20260715031002.108504-1-sj@kernel.org>
References: <20260715031002.108504-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 62DFF20004
X-Stat-Signature: an3a9t7htk184aat7hwazzwroxf7hrx9
X-HE-Tag: 1784090766-905823
X-HE-Meta: U2FsdGVkX19+9qB9xOl2oNX76AGuISSmioONr11GRA0EUrdeRfkAvkFrdCIT7qoz8YaoumtyXV+JuvSlTAyRGJU0aPx6VCsBzx+zKZE0trnsgaRW/jW3pf0R6cKZszta2/d5R0/Xr61dBwKdT0hO0/AsF0af+aC/MowO/LqwtD78hbzGhU+f1X3y3bA4PzPLczsfLPdxNJQ+afiu5RdaD6pPkn7yPOZBkbHjA+pSkUnajL8sbZTGsxbIwXzd9OjsoRqnEPhiyhn8JVqS4MyfV05lJnf8XRns89c5hsdaH90165FxAoLJ6QGPW5KYd1mbkbiuQITzRx5yzgKHImG9W3DD/NpDbLAFcrlOUr9Mw6KhoFTOiCWD/JraHX5vTj4YxRY4caLdpaO1OCPfMy7BbrOJqpQOoJm0iFoc1za+CEPPAO4mDdSdDLBKNUxib35qVXkbEbivmP1wfdBVUPQZdonmtH9rA5fnHzYx73mKnGUQI388t20ptlbjUq8SAJ/rozQ5oJzC42/XXUgv4nNgk0pZK35SaCu0qu8USS9oD/dSZpaLIc/wm6Jp8Zl5cJvvTAIxq6i2mYKqBXQf6ILxio+SYNwLGOJWnyhDiXa6bhvW6tVK5IUwoIYBW+699g+E5791RuTAijWkKsrzeQeeHiBB9d462aEuTY1i2jlE1gEb/0a4xlg6V9gD6HP0dCMnkQJU8fvjCuAPIEQ5uYGSFuTycReStzSkld0V3qd6+Y+r2S+jb/N8lpciWmFCNDBjBFVlvl+qIp648C91SDUVSsj4/8Per/oPXTUJZCcEpskaC1++A6mU0UIEYlInawF9BkMXf0UDkm4aGU7/4+a35pGm32SVWXxnwlcJuKloUnoi0TaMO4ZJXeO8TF/2226mRIOiLHmRXSFFa83HVzhes19kmE+OM3FxvF+69ntdb6EfGWXC0T55x9V/YhW5/8ITtHSWhLVbYUhZMQKVhWq
 7Wn7I3mM
 dBmdHy1k4oNFKw5/Yh4ZGo0uabUxALY1i4+MZVdj7R4BbnWqU/BQCfDuXudkzECzBWDJqi4xOaO08inHKHKZgKVwNvJpwkZtTRgSmcp0fbf8hTxvHJPqLEZq9udf/6UyKj3njMxHmm9h6b6rWAyw7r3J7F6uqGL9A2//i3oYOF8MEPpggbThgyv0Xm2duFxDLu6cxeo6WQuyRApg95ScDJ19UDKKniS1kTPySCPxLzh2sVaQu/HilV0i1hWAidFv9WkvrPbOPz2AobZnIstB+EoEHxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 20:09:55 -0700 SJ Park <sj@kernel.org> wrote:

> Sashiko found a few issues in DAMON that could cause infinite loop, NULL
> dereference and monitoring results degradation.  The first two sounds
> scary but the infinite loop happens only under unreasonable user setup.
> The NULL dereference is only in a unit test.  Monitoring results
> degradation is trivial since it is only best-effort, and those happens
> from only unlikely races.  Still those are bugs that better to fix if
> possible. Fix those.

> Subject: [PATCH v1.1 0/6] ...

So... what is the significance of "1.1" here?

