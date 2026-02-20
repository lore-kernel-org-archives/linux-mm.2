Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BEC0C5B568
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 22:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C9136B0005; Fri, 20 Feb 2026 17:16:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0AE6B0089; Fri, 20 Feb 2026 17:16:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A5146B008A; Fri, 20 Feb 2026 17:16:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DB1AA6B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 17:16:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 89EBB8B04D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 22:16:05 +0000 (UTC)
X-FDA: 84466243890.11.74038B8
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id B3FA6A000C
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 22:16:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vViFFMUV;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771625763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oN9Hwb2fDdGaeGEROxnaLAHfHNiKuB50PSAzDDIdOn4=;
	b=UJNbCFCt2He0GwO8BvVH50dQmItJNWaMRkymKb9hCESS1Jj9a7l0R6zLqyM1EeDMDtWkUo
	kn+YFSbkaYYg/ZgwE3WIULqFhZfbTmYzAGWly4otIgWjBtvg8DcP5xYCxa0X9mNFsFeO84
	UovoMOgufsSmAn7YWHskHa3UdOUIb/w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771625763; a=rsa-sha256;
	cv=none;
	b=UbYl1iiv0qm2xnGjHotmGDm8SS+mly0gmXL42R0G3qj6YFa2CsS8KygEaVBQFbjoex8HQO
	cJzjLSa+PCN0dQbFpg9xKMQoL9aQZqopOzwz3ubaO6Od+7XovA+2KLopfA2vh4a1zQIiQN
	OUrem7TNXhQ/TMvRAFTqRBzqm+dktuo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vViFFMUV;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 20 Feb 2026 14:15:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771625761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oN9Hwb2fDdGaeGEROxnaLAHfHNiKuB50PSAzDDIdOn4=;
	b=vViFFMUVuOkaJ4qMiikS9Cp26Jq4iqN+qAgwNc1HT4UH05JIwJ6izCa70vjKe5e9a8B5Zf
	mmIWVE3entV0vscEA6V2Z8FpPLkKK5BwW1t9eDq5zpMU1kmAlva21vEMYXZ0E8VjjCE87c
	5qbt1YjED4y4hF5dW/yET5fssFrUge0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memcontrol: switch to native NR_VMALLOC vmstat
 counter
Message-ID: <aZjdCfE1tww_WKwh@linux.dev>
References: <20260220191035.3703800-1-hannes@cmpxchg.org>
 <20260220191035.3703800-2-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220191035.3703800-2-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: aapaq578ey95dcxrxsbupcc6o9azphn9
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B3FA6A000C
X-HE-Tag: 1771625763-878236
X-HE-Meta: U2FsdGVkX1+R2TMXbGs6svHh7UpACa/7oxz4HfhqCNoJTA2KzaRIojSWTHXzgkPqdXff5ofCWfdHD7+BBRohdzSP9Ox+FQoRgniJBqttb28jCGvt/sbwlKmSys22CtCteo7nD+Kf4cfAvJ5iDL4XTPyO3//mJZfv2pMNtaGzPCs5h9NrYm+b64dz4dI6AIS79KxsxqZ3iKDM+iEA3D8cLM1rTIN6a09WM5gUmE/eNQm5aY7W4Lq3C7DaQyq6HCMAanV1Psk3Ke4KJQZclTmvZFgwnXefSHle4g8eKDgtTrBQ89zTUD4ufnkGxm8EVQ3li/f89KbokNlW7grXNl7fdT5wslPS2tuX/9h9LO7hudBRlJR4uwbsG72z6AgTAvk50XIsjhWkKA1PCPazkbBAmE/78TurdpGlBYe+g8cyb6bThBGgXPt1dTMGHVhDXxvEjjI9szYZ4z4LHZiovT1FP5bHiA+tm3R+lVmyMaKAeP3EHCpJ5qk+Uqrrxq7wKmdzvcGtoFhOc+/bnJVx91mvY9hRxHP5UQYMyiOjVB8l9CTT6y68z56CL9d7Hf3GSWR0A77quujqXI6xhPu+OFfWdJ9lmHpbBJP7V52VX+r7WFgCVa76MgW2KPUP/JNCcF+tpHXXUIq/QDbT9rrTa20QcpyyAtLHieh2o1lvtJZg8vrnQp6e97MajlqpqVtHa0KKkaEf0PQDy2PhcUQNVDS4kQzm9xHoz3uvV0TDrl2bMOSCvDABhhidynifi0fvVz1et4hGVwSajH6wSuDjkwSW24f70GzKy+oWczBMrZI7xEsY6KYcXqUQa186WLxIPg2Ot2bxQ0iftCUQOqeqTQTJpSocXwbbkgoDccG/zUUVytSKRETiKcUk5G60YOIzaO0HYgw3LpYf/ltkJFqhtfV00gpXo2r6ITP4p7o9X8LoVpJ5+AAHBKI60eRq6Ylte+cMLZnW0PhH8EhoR0M47ii
 u7znO+/c
 OWS+Tq/Sbs529yCNssnAREqneJ3vtKAWKL1zlll5RxQ3yH6oAv28tqp+bHYuk5x2GiScs7MFUqHAW/CG6H+unofks1sPs6QgxoFBQjNVsTRnXCDajuASASAUuYnO7CJragkCGmeUkUA1dk1LzRPM1TwhXiOo3/sIN0KaXaF7DGFFMocRpm0A1qkJGvEg6VreYeSRNwLsHBi/dUbGwaa4QhQFrnHo6OsBp4+BcsI8QA/TwkrHxZ86H6Hntfgvr1Vlyo8khrrh40+dYzyndGZHkl36diDhZMNgU6LG5AIJArVVE3w9WdsKti6K82KnR84WEzVJEZHogMg8zByPq6FtcJs5cU+wUF3nryhS5JhYi56ykPTgUVQq6cYG3iBWN1T0w1nUuupRGD/QwhXAKSI8xfoe1Voy8cdU2mFg6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 02:10:35PM -0500, Johannes Weiner wrote:
> Eliminates the custom memcg counter and results in a single,
> consolidated accounting call in vmalloc code.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

