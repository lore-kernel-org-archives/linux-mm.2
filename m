Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13573CA5FEC
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 02:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3C236B0005; Sat, 17 Jan 2026 21:31:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF456B0089; Sat, 17 Jan 2026 21:31:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCB586B008A; Sat, 17 Jan 2026 21:31:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA9666B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 21:31:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10C5013B062
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 02:31:35 +0000 (UTC)
X-FDA: 84343508550.30.28D13B5
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 23E974000D
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 02:31:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=alEnM+zJ;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768703493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HVyrnUL8zuFDrB2yKHZ5XxjKgpBYjM8YXHosymhizjo=;
	b=I7LAcuaO1s1V7e2szQXvzcibcunrUfwqmG2/5SuMj7uYfwnay/taPtt18StXlsH6bq92xy
	54lFT/FlUhmGZe8QhdluBwNMbzIkFBnUKXIH7oiW7pbpp8khdbyq11txyAz5PEZUQRVI5u
	BWNWyJ2nrr7Uk2oM8W0NI7yiuMhNAd8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=alEnM+zJ;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768703493; a=rsa-sha256;
	cv=none;
	b=eV2an8bp8XY20vm9HPqLc6TneRaZZhCMvD7Qh6S7rd58uKBgzRlPInwjCVhnYzLXer6WTx
	IxuKRmwrtw4KvgTGlbiNocprfiPbJ9+ynW/TfeS6mokAniXrWnXLT0TLOUBIaXwo0TEg5E
	VSCr8aSz091gn4Hn7MRNV9SJlAYF64c=
Date: Sat, 17 Jan 2026 18:31:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768703490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HVyrnUL8zuFDrB2yKHZ5XxjKgpBYjM8YXHosymhizjo=;
	b=alEnM+zJduTMngpocxLdYSYNEc9ZNL1G28Wafkqo9SGq0U0J0dBta03kWy/eI497f77MwY
	PYny9KNxs8pvp7CGAs8BUt5gDOf80wx93mTyrB8JOocTCbPoqgwee+p8M925dvlyE1NPts
	iI2lITI4Y2mtuAZHqDIeLVi/i7scHUo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 27/30] mm: memcontrol: refactor memcg_reparent_objcgs()
Message-ID: <2xkuf2k4wex6esebked3ic75gxqgqduxoy2ujdouyd6neppp4n@srl4nhxvxvlk>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <843e9537bf6b99cc7f19744a6f53b92338c96bfe.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <843e9537bf6b99cc7f19744a6f53b92338c96bfe.1768389889.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 23E974000D
X-Stat-Signature: gd4qhywhkxrs5tdushmmsnf8g9uz4m46
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768703492-818045
X-HE-Meta: U2FsdGVkX1/prf7Xod69lN0vy317TIuxvomfH/xlrKB0v1Oxfxy8XKZ0SvAmOnRIJqzJTvCWjdnZ17lLsdCnqVPvmTgtWoQg6mb3nvFatI3/hcNtyTT4EbJohpTdOg7PsfD1ZdPv0bppfShu7XQMVjGMWs3bpoZ9J21/3LG4ct+ZQjbdpfBFmBpqu7BXVhxLsupoQWm7rHISHBWcE6dy+gYkDuDLdXBQNah7T9auINdluym4j7U5sd+plCcge5CBCcN0dMG3H0069pNABsCooaT8JD08RwhuQ/zzlf7LFZFATs38c1mWQrxqP2QNbblZHqCIg4Qe3fD2LeWBPv74LMFhMpTKw5UvzCi46CL7EM9+Xj4bNFcLu99CSl76rL4jHN97ODJfpWIig1iBBuD3YY75DycoCiWeCcmoe2nQi9RMU+jn3bOIATYzJY38JtqMCJGNzV45Ms5TYk/MObXpn+L2M3Wzj2OfgQEOG0m0LcXo4k2S1aY+TAQ1+UoW2/v0zR4DtPDN2PMeRp9gbO5CGLB/QAnEaTVlYkJ2RCFBuH0YoFxNrKqbByJuvet6i2KpTGi9bmlBNiVT+E3rbbx8193QTaBhQidcJll0C7KVuX9dA9r2t9GzBiO5VLTwQY7fAW+Nqi8QHZks5id+r608QMQ+m1dRntACIDfKi2HeXq9FKGn0BwkAA3SvZ0L0HXD9Y5SCYG6cyNwMUA3HBBPUQR1ijcLExhiErxKmXZlWSkUBzxBZTctEGX7ka04lM8GsuImfVRcmfh8nULfiZJB+1snDwWor1yeK9UIs5It5WY5c0Olo3wwKlXDOV4I0wbIYIvkAAvlPK9dfJrOGtspJpvww3RFomX9J62DouUsCQtScdFJaS9ddjPRMyTdLOatAiq5xiC6ILEMB9Z3hUEGh9SMzskJCutL1h3KfP/8oCh47ajjFiag7gPmhrKwHl2op5vLXBs8coH6qNmYT9KD
 CggmwuUo
 DwXVKa0c+g16D9LdkaOadmUp7XJIcut7EWIIB9joV0Ul0XOaMWFHZwgdkWvwk+0XKPyvSrvAklgzxaLi21RPEBO6Zxy/CjYZcSD4Jo8iAAQ8EJSwuELfItVTjhja6rtn0Mc9A3ki+hqgI1+oLA4Q87mWuXVHPFfgQSbuiW3hsdHOMW5LJKK44jiREfHedlavEak6mNNWThuhuZSpbBJOLO15ri531VuGIOmAAJ+/2suP8peHk7JIHvG4rMCAmktIazulEYnGHsI9qCqalX9f0h4/Sw57/BKPKvyYM+DjadQ7gDU2csgtvqC/a2yis9dih7cMfSWA2gB+NyUKYupIu0vDaog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 07:32:54PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Refactor the memcg_reparent_objcgs() to facilitate subsequent reparenting
> LRU folios here.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

