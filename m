Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EAC9C982CC
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 01:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4236B0092; Wed, 16 Sep 2026 21:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1752C6B0093; Wed, 16 Sep 2026 21:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064B06B0095; Wed, 16 Sep 2026 21:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4BF36B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:24:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD993801E6
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:24:30 +0000 (UTC)
X-FDA: 85221509100.23.72EE349
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 24421100002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:24:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IlX87D/L";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789608269;
	b=uG7MdeqlGafs3RNc23CjfZqcd5fjPIfIVmFjCWL6qcuGNi1Bkb4jLLiNKgGioFWMlk+I3O
	abk5h19fjeO7lZtOnSxNeXjxjomHxi5+74B8lTlhIbm65OsdETeZKsKDkUSDRo3VqAM/tK
	rcO38pbFnU28FRz3bfKVqMYJUzJSDX0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IlX87D/L";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789608269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lZ1/JqShDzbJ7IZu7QOMEIySEk70KUHs+UhoEK32jik=;
	b=c63TNyWFYmH3XWDy4Ptn/S75OYMaPlN4L9EboHz98XLSXx/0hLKYDk3FwgzZoGtBsbrv2e
	kxdy789ni5ha8jUqqM3qDHrVz4dTG6t0hmAs9iJ4pwiQV9uMbKqUk3gJ430+vFrUJs64MS
	IlzX2ClTqgchmB623g/ExiSG2VRp4qs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EBEF601EF;
	Thu, 17 Sep 2026 01:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BC61F000FF;
	Thu, 17 Sep 2026 01:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789608268;
	bh=lZ1/JqShDzbJ7IZu7QOMEIySEk70KUHs+UhoEK32jik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IlX87D/Lq6R17YTQTyg93CU3XzxNg0LyM3R516eJBKICYpiceSdQBusGt9JxbwAEY
	 Oetopq4JPfNlc51yws7g3VFOllGU7RnvGvMJ/IDBbvF0s1NwRFdxsHETeTVJwcPfz4
	 kBf7PsyHKeql9NIFUHUuzLd1iVk/zA2+RDkeRcpVToRyKEQRgo4L+KHWhMbocTLpwP
	 iZLmKnR0prC5s0ikktVP/0z/7YoHQquIEdNsZ53gQRgE5ooCJnRNHiJeW8QTXZzCQx
	 jnjAhSzs4eBYFKatCXzMxLp0tr9uMUlNhdNx+YiOZx09TPEy72jGOXhM4pcmoirpqC
	 dbtTtVxXSbeBg==
From: SJ Park <sj@kernel.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/damon/core: charge only the part of a region the filter left
Date: Wed, 16 Sep 2026 18:24:19 -0700
Message-ID: <20260917012420.101087-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917003553.2465523-2-donggeunyoo.kernel@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 24421100002
X-Stat-Signature: iy86st6ejc9nd3nfknprykdkrsfr5359
X-HE-Tag: 1789608268-215105
X-HE-Meta: U2FsdGVkX1/04acEi1kTQj7zppYt5wIRL5Yg+PZd6cmvajZCpDnrGOJ0vPpWgkvUEBCm4fQhj87TgbbVE6zGk863IRRbJC2LgLvS1oaqfONhsk5S6y8hyxFzwa9q6T9JDTmqiO2dF8z4FYAmhcPC2AdYg1qXXmyVJSo3zjx8Y+FMECjPV6FhiTsM+dfusoeS52ejmsGo7Y3Vd5G/4FRAHSJUpHOAwNlz2QdigHjq3sHSr+Xj68a4+s7if86skiQVLzYMZBrEc/C8g6YqDv7LQlXGkLPfHFhlPr9tt6SFpJiqAcYsa1h1LvubAClulnoaclZYKQr+XREK6Mngsp9EakqX1LyFrO0M1WhZytnEEIJYVxXFjnmrkPT9XX7QgaUEB1UKLOzkF1mMAYGr9EPlFnZzx2pPNNaBpwHTUyt45iA4iKSaeVhR62qQIS9Z4sTqLAvfhIuO7y8aExcGAq4kY7SfERCERrh7r43vJrPZS7PGUbehFK+KB9iTYtE20WsSZN5jMgeebBaexyUpxjh9fcRG9nro7w2fXL8gky/BB/Wzq+CB+qIFKgCBRmASKohUrB6WKp8sMuGNQq2LVgMVejeQHxFg8wMwOvFWCexJpuKGBdOCIFJtSeWOQqDPB9SrMVmSR1YUHevFcIUohAOkCn5v1ZZ/eukPyCQVnMWKhkDFainTYfXV7COxOYfb3NpQ9ZE6tRmcl/Ejj2BJZNzhEGJegubpui9CcfU/MQZ0YcAiVDG3qeikw4++HK6Vx8DAXGjYpgEkK9e1XO55VuMFhvAdqWCHKDRHP+ilBAt2w2HD9//avDT5SKtCQBrEZIC51N2+fxJtQHhIZWBBrBf8JC6/8UsZqKzHF9AiXza4px7HJfQ3JZ3T1K5pQw8F+FasQZjAhoDRFM84IKSpxVRPgCu/etCVdn93KgWRvDUfOv9f2sSsaRITwLAPUjAn1n8Erxcs9Z/Ltq+jyEomlSy
 dLdFrOBt
 qkBl8+kbatIf0eZkHvYoYAJERhWQMUdER5gbrzxNpov45LSU1QWp4P+ov7VYtoKHpfx2ef0wQ+aK6yZX+3BJ5fQlnts4W/tsP5WirHFkELifCTWVejKSSLatzJ5OOooWcHOPxeO4uX+NWA7pQPbvLWbSdkWy7UpZ3tVauwbmzr0QeUuFuc2vHx3uE1eIeX4qMA2+4MkrekhWisURSnvtHQqSKz7Rwdd2iV2Y7qnErjdvn6WTL0ImP8mI5ECtulMOkrHgYDgg1628SWqcwD24csROmLwtsjkLQUfohfeY0mqIaqu8GEqJDpMPZDBDtaRqpvcW3KgFr4kvy0t4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 09:35:52 +0900 Donggeun Yoo <donggeunyoo.kernel@gmail.com> wrote:

> An address range DAMOS filter that partially overlaps a monitoring
> region splits the region at the filter boundary, so the scheme action is
> applied to only one side of it.  damos_apply_scheme() reads the region
> size once on entry, before damos_core_filter_out() performs that split.
> 
> The quota charge and the statistics update therefore account for the
> region as it was before the trim.  schemes/<S>/stats/sz_tried counts
> memory the filter excluded, which Documentation/mm/damon/design.rst says
> is not counted as tried, and with quotas/bytes set the excluded part is
> charged against the budget, throttling the scheme to a fraction of what
> was configured.

The user impact is that DAMOS could work unexpectedly slow, due to over-charged
quota.  Also DAMOS stat could be confusing.  No critical events such as crashes
or leask happen.

If above is not incorrect, I will add that to the commit message when I add
this patch to damon/next tree.  Let me know if anything is incorrect.

> 
> Re-read the region size after the core filters have run.

Thank you for finding and fixing this bug!

> 
> Fixes: ab9bda001b68 ("mm/damon/core: introduce address range type damos filter")
> Cc: <stable@vger.kernel.org> # 6.6.x
> Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

