Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C1B5CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 20:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA628E0015; Mon, 15 Sep 2025 16:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6A538E0001; Mon, 15 Sep 2025 16:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA7A48E0015; Mon, 15 Sep 2025 16:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A90238E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:15:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CADF160736
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:15:31 +0000 (UTC)
X-FDA: 83892589662.19.5B7003B
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf19.hostedemail.com (Postfix) with ESMTP id 72F451A000D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:15:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ESdlTdOP;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757967329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fiu+/JsF0ratR6bMwfydxpKbaWu9OWoA9n/p9dm5StU=;
	b=dgKta2ZHk0+wzuIm7zqhwomDSAf9E3keE4m3AUeWY8MA+/nWqMKB/w1ZvstKeWNlfPITGe
	aUkW/psjFcnBRRga4cAK138Fojn13JHz5/v0aif3Wp7ecolAbLVHjAtT3qM0jo4g1QJddZ
	x1xK4WaETbDL+f6o0qJbdh6t69fQ1yk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ESdlTdOP;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757967329; a=rsa-sha256;
	cv=none;
	b=5tf02pDYHkSPaw3P29onlZkjLnJNAiLZbUyISz/fxK8ZalY6zF/8nSkc6XRLwJCfC1c9k+
	5ERQuHYqvV3qH6ysfam0MGbmLFenCOzhYECgAk0Cbtfbi1a8+6FiEoN6WBsVrB08hwb61g
	jSMoJbatvAlLgiesUhF8lyx1/qupGyE=
Date: Mon, 15 Sep 2025 13:15:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757967327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fiu+/JsF0ratR6bMwfydxpKbaWu9OWoA9n/p9dm5StU=;
	b=ESdlTdOPYdfNqWIXfz9dOUsepNFdwyUi8hsnxPSA4jzzwt1/+IicKrIvaTZyo58cSDjp7v
	vLhvniA7lUfOvs9uDpqIKunxfeZSJiNTuqJi9pMf6mnpDEhOQ6zuXn4rLbKQMlyH3kbN0O
	XD6cdBVT1FMy7xAivKX/c8lF4xAQR54=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com, 
	alexei.starovoitov@gmail.com, usamaarif642@gmail.com, 00107082@163.com, souravpanda@google.com, 
	kent.overstreet@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 2/2] slab: mark slab->obj_exts allocation failures
 unconditionally
Message-ID: <dia6xv4liysr54vdjfpw3bucbvg3eqh4nn4jh57h5htxev2zy6@rtnakdtz7vjb>
References: <20250915200918.3855580-1-surenb@google.com>
 <20250915200918.3855580-3-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915200918.3855580-3-surenb@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 72F451A000D
X-Stat-Signature: uffpgnq7njd4g6wtrqmjenxym3ptt3rz
X-HE-Tag: 1757967329-22691
X-HE-Meta: U2FsdGVkX192PfMeC50wqpfk5YlEVMjLLqIepr61UP78rJsaPVRd/uO2E0W/T0ZLs6KZFt9kDx74y1l+LX+7+Our8e03YFqmH4ZgyfKQrqP0zq6Qt/tRbtKYwWba3yyL/LW1FkNkhjf2RXMhwuv+38Le6U+MPLLGdRlXdxNsq3n3V5h5BVregHqtdKbwhM6w80WnSDfogn9yk0lmWD9ahWOaIjxOc0dMwt0Ii7roxZjOjHNpMOM9qJMPi9UFNdPamP/0RZFH2R7+3rxXrzpzqhrgVUtCLpDmI7VPUiG6ojwLO0auI6MEQOXqnxZWWdUKT7FZfzNqZvv6hCzP1NRODXW9Uwe2zUsOlcZCNJgtKJuVWsz9pWNne/YFZLzJ3OcTwU3ZHONH7sUe7BHjTQSX4wwvamRXI5jtcU1VI0B+hGqAmAys4nOCufUbBXruaZPfOUVf/8zEDHv1fINl4y9+TO4lFkVV4EANuRi3wOK/N4Ne7J4n7bObv7QU9HmZ0utwpQoXdSkGBppuiMvJoEkg04gszc5y09bt3mEBBHn6V1XZRaH7v84YHiQ+WI2tkJOUAmGzRkyO8Cg4ClVn+dzM2CagDnDI3qw3C/bzLC6Ckp8djcx3Qa/PgXRTVmL0UJJiF78RoKC5zbfT69m4F1IiXJ26S6d6s5v1V6QQ0FsFker4WfP/Ag1vlwWuiHVv9a3HNhJj0/YsurrrVZsWfAnclqjd0lV8LjjJVVQEEVtSov101mbw19aMyDx/B6yha74LCeHZmPdm5KaJZ2Us4BEcKTeABZ9aTTbAeEyIvEUTrAETwyisCUFpRmfYbLu7uiJBcUxD7Bv6ajwNpFAi/3z/e4hjKZpjcXuKMRG9ZdKDZSTLqHPKz1Tx3f7eB0kj/hWGiCs04JROq1wA5/LL9IDpHp6ghbGszDA5RmiET/FE8HIW0cC0amfE/Gh2zfx5H97RacXbGS12jKRLeWQnnv+
 w00ncvav
 wOODrhOs7mEKp4BSXAatkhHTAH5/v2pUbkIGWtXyTTWcffqsKwz8QSn7cp+AR12DFSFHDDZbR1qL57Ow1rE5HRvGnzJvYdK9hZc0J9ON2XTBZhCXq1fZMCddcOFDRa8LzuBKqPqzqJCTPCcHZs61j7/qHYT35E28t0JkYyKy+DSYl/uy9/odXGsVUiiNwQtjVWXd3gGDIKJ1XpodNU9lhtK1z1pE1eSq7ea+JVcgl3XGmOWFwdkI0FeTLfiDHxUFWhspWUZqpAetwpDuJtQUEFDaahX1UK55wYLUkHCTzm1mYALxZOm3r0Bgd5IMo+CQvbsiSayLPvXZSc9rQoHiQaCrJN7xwT1pe4waqV0xKV1e276ZjDMqhuPx4gw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 01:09:18PM -0700, Suren Baghdasaryan wrote:
> alloc_slab_obj_exts() should mark failed obj_exts vector allocations
> independent on whether the vector is being allocated for a new or an
> existing slab. Current implementation skips doing this for existing
> slabs. Fix this by marking failed allocations unconditionally.
> 
> Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark failed slab_ext allocations")
> Reported-by: Shakeel Butt <shakeel.butt@linux.dev>
> Closes: https://lore.kernel.org/all/avhakjldsgczmq356gkwmvfilyvf7o6temvcmtt5lqd4fhp5rk@47gp2ropyixg/
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Cc: stable@vger.kernel.org # v6.10+

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

