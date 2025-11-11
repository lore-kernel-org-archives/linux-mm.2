Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3233CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 462AC8E001F; Tue, 11 Nov 2025 13:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 412BA8E001B; Tue, 11 Nov 2025 13:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3285B8E001F; Tue, 11 Nov 2025 13:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1C8308E001B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:59:09 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D12FC1A0113
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:59:08 +0000 (UTC)
X-FDA: 84099238776.13.14E9239
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3278AA0005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:59:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YmQ8Ols3;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762887547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RDEhhL7l7kPj/j5hoC79iose1GSDWYP+9pR26ZYBlLA=;
	b=KCfQPWffGiuozjoxGMKeALGv2x0B5BZlYK5qmLd1z5rVinzsGCt3g4bdwi8yb99npE/xp3
	mrg95ie7EzHrYeEuqVLmyTHUOBfm6j6qbfM58ROUeOiTY1Ier/ZP56XgHALUkPaHgK+nB1
	T/dSKgl9Y0VI4kh2n2lYgYc9LdjEbCI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YmQ8Ols3;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762887547; a=rsa-sha256;
	cv=none;
	b=6PCDWELf7kRLHfv3eifv5eMMOKhH9LcJ8g1vCYzyiJxqPfaVAvaLdREicnfBWK/pT66rbk
	r32IZv2hv0/S0T/inXwY0LJi+Rq2T4E9JOZtJy2zVUBeulN5KMlrNqqvz+3Yg5Z0H3uTAX
	H7uUobZVIKZ8fi8pD42j6wPY02BG7wg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762887545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RDEhhL7l7kPj/j5hoC79iose1GSDWYP+9pR26ZYBlLA=;
	b=YmQ8Ols3UwpD+qPU4OHg4WNSQibssV+Bra+pUVk0AXHSFzDthAXR7uBayhKd7t4NXw/F0A
	vBWsRP94pm9gc7xNRHdoNvpQ3RoM9ZJtxn012NB5lkbdl43KyFbCWIkYnMiwP5omqyQgpS
	DyM9vrgkaAuqAc3E+PgBPP8AExMdPmA=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,  Muchun Song
 <muchun.song@linux.dev>,  Harry Yoo <harry.yoo@oracle.com>,  Qi Zheng
 <qi.zheng@linux.dev>,  Vlastimil Babka <vbabka@suse.cz>,
  linux-mm@kvack.org,  cgroups@vger.kernel.org,
  linux-kernel@vger.kernel.org,  Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH 3/4] memcg: remove __mod_lruvec_state
In-Reply-To: <20251110232008.1352063-4-shakeel.butt@linux.dev> (Shakeel Butt's
	message of "Mon, 10 Nov 2025 15:20:07 -0800")
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
	<20251110232008.1352063-4-shakeel.butt@linux.dev>
Date: Tue, 11 Nov 2025 10:58:57 -0800
Message-ID: <87fraks8em.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3278AA0005
X-Stat-Signature: rspqp14pemnkerhxf3q8wzg5cj463uej
X-Rspam-User: 
X-HE-Tag: 1762887546-226933
X-HE-Meta: U2FsdGVkX19pHDph5fsOx8xPaOCeTCWPvng+Of2ihgMm/z3fVrHKsQVtosYNCc/2T1M0KHgCjNlEFGjV16Y4m6U7fvoSY7e6A84JWIDShpIE7VJls3Q6ux6YHvAJNJ9jtWkAnKbF86qjGk75Y4f3NIxKmRGBBt5y7T5cOgNMMbouXtyIMSG1jR/HNN30bhz0a2Zr5CGYIkoVfzPhpOBUg7vJtzshQ9v4E1t3sbKVaabBI0dpHNgalpdaXHwnYGSZHpBfiETi2Dm9p7lbcwO8/sl0KBV+C/qMGTKouM2WkIrT/7jyYc5+J9CIYsmZf9RGZjmqFS6vYx/7SHFjTxr+9K9crfe3xGXbTLVDPoWwXxWGyhz/pweLhl5VfjzEpp77ImkRq7/7esep6JB8/LVZuJH2xj0K6kCD4eoSkm9dKcnW6MiEHZjkOjBqd6RDvDOR/E/CCclbJ9LbsOgC6NwY0uHndTAE1k/qgW/tvah+DPwpHahcLgJIqzKTsYCVmVIeKvOAPaqRIdTqIVIosR5VoX/HaQdpCr2XoFeQ11WqxsrIsNymdJYZJ7GkyljkZHs53mh0/kAeAAYF7FMBCHPlUUPfhhXl/M3gQs/AmKD8j+PId5B/EOLHfaTo/Eo/xUgDnFVpyUYzT6tqDJkMQddR2tPtjABtRlzkNclXDwPKhFaSUdbP4N01WY8PtaMvK/eRYZCctNTurux5+E2OXI+VxND9NfF+bJM6KFB/9UHw3eV5mk6PYXAWfzp0Fws/jXoXLAbR6G7gxTi4gVk8SsJpvaNrelqPB2w8vWhlu/hpgBQyOC9/vjIcPWASxwU2oTP1URhGy3U/SYoMYEEVZUYCgaSHlgHYdWc0M+Z3S4OoiWKZvnAe97DWzWJ4W1KleQQbHeLNNMz6+r+XG9eTFv5zkavCPraxC0W6LjAkwlX60zH6sP0ThPkI30KZIIX5OqZ7QB7QG/g+g9A2gs4KsVE
 EzQqlvAB
 yIAjSrbmaAsmhwi2m72l3+YG9m4/oRFDy70k1E8ftdPDuKR3J0WVuwMBp7X7NsD0F60gvB/jE9aCGm0mjvt8uRZgSO9Ozwe6465LdhIZGAP8yQsaQL+2hYkJRMVgzRZKqfdEcix7Ls4ke2v2SBal52pLaax5VX1SqsKDh1wUoXSlaxOwaKJ652lZ8YNN11A9+Fvl6vl6e/EdOmF0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> The __mod_lruvec_state is already safe against irqs, so there is no
> need to have a separate interface (i.e. mod_lruvec_state) which
> wraps calls to it with irq disabling and reenabling. Let's rename
> __mod_lruvec_state to mod_lruvec_state.
>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

