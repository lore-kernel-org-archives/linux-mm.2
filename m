Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1105AC982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 15:57:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF7C76B008C; Sat, 19 Sep 2026 11:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B396B0092; Sat, 19 Sep 2026 11:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D255C6B0093; Sat, 19 Sep 2026 11:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A50476B008C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 11:57:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D1B2A55A5
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 15:57:26 +0000 (UTC)
X-FDA: 85230966492.10.26A2E70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 627AD180004
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 15:57:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n1CP6FuF;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789833444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vMQb7udZL3y0xIqeUPoqQ6nfJil4eFetW2PhuHVfyU=;
	b=KTb1ZRo8Slg7K/RwjSxHom0amRtBEOmme2d3U4/I1wQtF4LwQX6yCA6hZxPdTn72NBJmdK
	V+iF9lpDjNCcQLBaPjRr3ciWShbx8yrRULMgeRA6zy5ZMYgyuLMVB6sMMxoOOgrkx9VjOK
	1hO/EXwJmscdqUQrrXS9Jsi33OpLVc4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789833444;
	b=Kby/3BgbwbubOrY+BDZXOkDh4wGkPlM05sHV11WOXArwESe5koatEeBTcQKki5SKXPGsMp
	3g1QwOtCrj6BFpFhPbwcG5jqaaFt0JMsrqC/d08Xs7OGoYZe/rkWb6Y7OYCguD1a3fCE2Q
	yRd9GlVtsD5F0Wpev4p1HI+HdxYM7vM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n1CP6FuF;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2AAB400E6;
	Sat, 19 Sep 2026 15:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513441F000FF;
	Sat, 19 Sep 2026 15:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789833443;
	bh=2vMQb7udZL3y0xIqeUPoqQ6nfJil4eFetW2PhuHVfyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n1CP6FuF2cU0FlyUyib3oHPT683ZPiPqR9rhrCDfPrg8Deubd+G/PT/8nTq3Lfayv
	 7kcbNB1Zu8NbnX2vLjqQKzU3FbOo6dfTrClsssGwSNRtSkkK0GlnY80TPzSjjkMrFa
	 W1TA1ppchwCwcI8Wa52Qd873vEd6nf7rcrIHavL6IACVUZ8qJBDs7BcjbspI7LaL3W
	 82CWe561q16aaLbPgwpYy83sbtVaN5DFD4NxIPUnU98WUaBwC67mj/FGRHinqV/UF5
	 TkQijl3pGqjEj1hD296ajuoHzlLh0AAeYRV3NXTAOrY5yiUiIQQV4KP++ILXesX06X
	 aJI6y97UVboYA==
From: SJ Park <sj@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 01/10] mm/damon/api: remove NR_DAMOS_FILTER_TYPES
Date: Sat, 19 Sep 2026 08:57:15 -0700
Message-ID: <20260919155716.86019-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ae900f5b-7f00-4c48-8097-f2f836c09f60@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ty7doxzwxu45xbmazrjtaxd78816g54h
X-Rspamd-Queue-Id: 627AD180004
X-HE-Tag: 1789833444-364777
X-HE-Meta: U2FsdGVkX1/Xux521p/sFg/uyAA/I5EhMOc0BTFXmIisONM+8EBoKowSTD9eeALNRffOPP6O+/LCLQd44SelLipUTtczs8DDnRLEzme36BaPTn1ihMByXxXC6Uthk9xpOKBDX5wd1CGF9w98YOXfyINk0UqlNEYz3JGRGKHFIhqW6FfSQU3ImoLhyENHf0ZpCR1flDTUf80HMa/xWmDVhgCQra2WZVdDQSFkojmsxNA+h8NkZ1ly8kNNKaOP0rOK/Q/lGTtayAvjGjvZH+YclYqkQfRGm/hghEVmISt4ggygwMGrs9V2c91J62KWt9d3IxSU+zzQVpYf1U7Fab1VKt4E//xZQZ3Pm1Fh9fqTnz2gfeXooZzY33rY0lgTTZIHNCOXQA79ZFJOnCFK1P66hoicehQkQYYjdFqMa5AcVxFijGIUsN3pBMowat62jtsOoMjnytBZCmseS9RYnMUUMcef8IqjVNYe+vKE9Ac5K68C4N9NukAs+CS6A7HqUDRFv8TdWcT9snaZrR4hJj/YbnG0ULXm2leDvCN1ouLEFWQExjL5xxQQvdDq57wyCzoHpUCQeowgwhAwcmxhxTlUPTez5Keoc0SPJHkfg3sTSQovmiaWOyti0bl7H/wPwoM8kIiyi4nB0X0/NpuKm+4l7mJTM4+G5k57a9zasdjYijkl7v03SjIaSbPIp+D0+kYTX1W49wyDGkR0u0jdWxi3sV+jwhf+cE5FHLAPmPDgPUI3WbpdiB5TQ4XUUN194jPkmiCyRcEJRCpcq/uGRiVLkr0uPw4rXJkNd2WlTcYCrYJ7W4QFdMHOwCz2zzYFl5U9GJFdi67PptR+j3y+q94RJjjRAWJt1+Sn9Du7PgGDOiFWQmPR9t6TqZcWRLWEVXl+3qpBSOU+uxHLJsv4AHc16Hskt+owLGC97rpzxo1Hj3aKDdfTTXYwH/7BWjxtyyiJVf447onZj+5iXl46jSR
 Jz7IdJUD
 wuUSdVbF9gYa7cVxnHn5G5Cz8MUek3VlcJaomzOMVyucfp6NNsP+SdGZmoRaIuluaPOs+Mq7M3FkOgKYA4f0rEhvUTorxmIqH5cC0GEw3OYHujHhtb5pUOidPrAiCodu2gZS3sJD8hIUKnYys/F2Wq2nzkVBX3Me9JxU9ay/UKruB22tPC3ZqjNeCCgBXInigqWbGs//7j5bQ9qsWYt065X1wPA0+BlkDPKR3Ue6wpUyjelGxpL60d7KU1R+TpVgZkVCx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 19 Sep 2026 21:02:30 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> On 9/17/26 10:21 PM, SJ Park wrote:
> > Nobody uses NR_DAMOS_FILTER_TYPES.  Remove it.
[...]
> Similarly we have more definitions of NR_foo in damon.h:
> 
>  * @NR_DAMOS_ACTIONS:	Total number of DAMOS actions
>  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
>  * @NR_DAMOS_WMARK_METRICS:	Total number of DAMOS watermark metrics
>  * @NR_DAMON_OPS:	Number of monitoring operations implementations
> 
> and only NR_DAMON_OPS is actually used (I checked mm-new).  If the
> preference is removing all unused macros, we should probably clean them up
> as well.

Nice findings!  Please feel free to post a patch for cleaning those up if you
don't mind!


Thanks,
SJ

[...]

