Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60FD1606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=HS19O8HA
Received: by kanga.kvack.org (Postfix)
	id CE6546B05B1; Tue, 17 Nov 2026 00:07:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBE0C6B05B2; Tue, 17 Nov 2026 00:07:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B87116B05B3; Tue, 17 Nov 2026 00:07:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85DA36B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:07:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CAB0A80306
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:07:41 +0000 (UTC)
X-FDA: 85443428322.11.6DF011F
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id E4964A0004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:07:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=HS19O8HA;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf25.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.173 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794892060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ADwlNPhiE/91inMKJBN21Al9f4VOhautzJBcYAYagsw=;
	b=gFqyf7MVWz/e5/8ViVfDsZdmPbqFSuDqaFeIFHmK8sMaNPIHUvtrwyCgIpkyQVWetrKe02
	L5KDsrGdjP6xEK8VSDwKa23nTa/ExCWH/n0hBjQi/GVAZ0XPxKQX3gzKI6aO47Yd1KXccV
	Gzf0VmLkkMX2bAusMRb2EK1CgnNnlkw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=HS19O8HA;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf25.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.173 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794892060;
	b=BR4Z8ufTRAGct6dxRV7p6xCdnD4s87Nwb3stf61e+5m+oe5iT4ldHS6jgeW0QNFT+KizgN
	6QySjRTzoZB639exh38beVjIq+XdmZepp8gebhnkFMioooaBDhRrpdf1GifIIeIFjxUCaN
	KwiGKF8GhH27aV0hpGHGMM5qbb4z4wU=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-36f8cdd30beso7053033eec.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794892059; x=1795496859; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ADwlNPhiE/91inMKJBN21Al9f4VOhautzJBcYAYagsw=;
        b=HS19O8HA/wxXa4WSKhcBjSJM8OcUuK51RUgqnH5S32lUAq5qtQIKSN4LkoX2fqEPJi
         cGdgR847LuHNTaHaszeHKJxHLElL9NjkCAxy1hxAKC5g0U1GuaGL9N5zi7U9/SaSdhzi
         Bwly4FZfmf4U/masWrj1evd0IMrFj9s5SfVO0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794892059; x=1795496859;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ADwlNPhiE/91inMKJBN21Al9f4VOhautzJBcYAYagsw=;
        b=RfkPwrILGxFnzAGwUPluo3c/x5JM3w40+K81HV39lyaQay8+VCbUU+iQi74HBhe+Kv
         7uVQYU8KGp9pOexuXyVV8KA+59rNFuKy1llam3WIqWpy2V6rkXmsI6YYM+t0GenCcRKL
         ABAtkjkn7kqF9X2pOeDjivtX3slLLP6n6TfPEYPXZ3DbnpSS0azAKVqY0MuwJhEhgH4A
         UqX2YK0yYwfgx+3b4Z1n5r/DpK5qv1GsXpGzW2Ulm4BiYB4etuQcXzyAF0C8ww+d7AtX
         i190ADDfvHvoDGakQcjjGF+yy0NbnSk5A2caPwRNzWzVXz3+lSGSffDOda5yI4zpgzQM
         UKTg==
X-Forwarded-Encrypted: i=1; AL+hErHLlMh41vU0OL6hW+0Wn5fXP8Hq6SlrEXmHg3V0Af2S7y1Lz0g7461x8zDRuZm3GLx7xD83dVc/zw==@kvack.org
X-Gm-Message-State: APuU4Z9WicKI8u5UM1phT6eA+c4Buw9qSnAbfgRyqx7W1DF0KI33hmhO
	hWlycgN5zXsvYKtk5UlnV7iSnyKBVF4NfWdbdlBULk0/dJI2W/6AVxUCU6QJ/Bws9/4=
X-Gm-Gg: AZFdTZe9xcLYopPRIZ96OBhegAs1xlzZgGIpMJfr7lGLIuKJSkUVgSNrYiNSx1l+Y67
	NBBzKAF/7kl2Cl/Bqdbcbic2vLFdMQNgjxmBppoJhKJeueOxVxQaVMeFa2irWKIsmngFd0sx6A8
	FPlyV7F+xocXI7EGemyyGT27DFGW/5V5Pj0IDqVcm1Tk1HDTGZ1MXD2pe1F65utPrW6lwcMIq0y
	RVA+EORhNMoneQGlMp4Azm7C/EMKgUNShK+HR9iCi1H0C2aWXJV3uvloS51sxkqJ4ix7A2nUleq
	t76Np2xl8GxLDOgHGTSYWtovF8nWvzNopkAlloIzJqJqTYRUmZyen3TjbZGsvW22rtYpTeVJTpB
	fjjfxCvK8a8kSjzZj9Lj+9r6i05K/GKy55dio7Fxv60jiGtJ0tECyTHj5lFRJjov6rpI5otCmo/
	JG0KO0d54f/S+CXIY8L7tgIX0SARJ02lZD698XzJ64qKWgD29f30qVCJ5uVxhDuHGVCDWkbu2bJ
	w5m9vrQHs+MlVCv6U21iZlHflYjXOGLID4un96VSW6dqvefAylwGEp3aXSVrmDEcSJJZfKv15wH
	z31BzHY7zflozWSzI9G9GBg9TwtILAXm9h1jBztDb6xYHSFPDLFltCUCeF87k/Gl0x3fINMq6nF
	u3qstyoydUFFNZRz1iuo+5em/aIGYogOHEi59og6Qj//YJyt740xXgyi0Wqu5pADWang2T43Gh1
	lmSf/nxkAsL4suFgCV2Lk/q1rb8IrJ47IWDNkdFqaaJVgsECsomqojiueNSceRmhRW
X-Received: by 2002:a05:7301:4d16:b0:36a:1d6a:596b with SMTP id 5a478bee46e88-379675feb32mr13056956eec.29.1794892058695;
        Mon, 16 Nov 2026 21:07:38 -0800 (PST)
Received: from [172.20.0.3] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-381a55555dbsm1325716eec.10.2026.11.16.21.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 21:07:38 -0800 (PST)
Date: Mon, 16 Nov 2026 21:07:35 -0800
From: Chris Down <chris@chrisdown.name>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, yosry@kernel.org,
	mkoutny@suse.com, shakeel.butt@linux.dev, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, ljs@kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v3 3/4] mm: workingset: skip the root memcg flush in
	workingset_test_recent()
In-Reply-To: <20261114002822.1043378-4-joannelkoong@gmail.com>
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
	<20261114002822.1043378-4-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <avvhF41RlOQSYFq6@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E4964A0004
X-Stat-Signature: ih5mjho671fe3f9pzha7hha1u1hytxda
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794892059-928519
X-HE-Meta: U2FsdGVkX19T7CFOTDILrQ8i438pq2x7/CEHdXlGDK0sWNoAwk+YXwxQlhrTZnufje/4ijyw6j5W7+0ESB6ugnWKGcN69kiPuROHDPZrHOZEhKnrCrS9BEzLyvOx0RZ7xDqv/rl6A7oMppOxfDEncdgGGvaw8SBauSkNJ8jvPz9I0/kC4TM2mBrjPi6HtGpmuFl0vIflu253fFiyCJOmKN3tR6nQSiHw+ifhNQIlYesACF/9bflH4kD4LLK5Fg18Pt4uRymjKR7VBlX8XPDSp52ywoTAvubr2xZR0zbVrDEK4SW/yT3SiZi2XUUVruU+T/h63wmU+DqPo0aDGVAYuuzVlNEZTxpA8UwDVZV7sSbRnnQvD3bsjkiH/ycKG0FF4S5JTP3uAikBsPSqCLevb9XcMgt9yZwGr+S4UW2wZHM2pnVn3J98A3bVkFqhhwWRpCSbKYCl9YQrhPs8P8PPFOVGIXm0zo+p4hoR4oXYXd/oIdiX/0PcSecxEJsn+CxjvzCQfZeG+c8vkVq/isjLppgHEBQa39tsg8e4bmRblN5f4PX7J4Ptfj08NGSSvS2psBniYU58lR5/g6oK7nMbRzF2q5yXNr56Kg3nKLMxRnHjRfncTY66jzNseosjWN2IoNYLeYRwdPYt+ekMQMzGz20nalXnhQu8ZPDGjAwm/0jaJb+GimhxjrRHRcZTjNtkIKEqFq66qyGiyKcIiDQxyQBxjtfQ+ELfKBvrgDfcRzrdueILloyt+9ndg5taJJs/aP1Miyvt0xfdF7mYE9n2CizSase7VeXijFYh1Uch7tGlJxQmrOu6A69NDk5nsYSD0PLD7q2OosfXg5mQfjyZPEs8lr0jo2l4ddF6e6/GIAxagkjG2BZ4Ao3WmxbSNT1MO+SvczmNkq/0xl8hqIdWu0H1ajS+aqfpFzTwaPL2msQ4y0CRCGVeVUFMM576Sudaj6LHZ1atxeyQ4VjVsLi
 9Je9e23A
 esljd/SIEuWxVDfGSJEojCIHExCF0E1KFYnkWaRu6gUoH/kedbNM7cryi4HMtv6TvUFPtqSOg0kpyPxit1FPZ5bKT15diHJ4iDeBOhH5K3Cjr6CXN4xMP7OKKVkCtekq9Zcz+xYXFdTkE/+Qs1yhF3M7pyQe1lFyPTAX46rXb8K3hTiBFrghCmr9UjtDipPCPTDmTZwX9LDGwtrByCGunQ+jN8KWZNOXcLDx+QwL8eP0iuXp0vzaI3C4JmsKWT88Y7naEdT22r/yIlU05H/1mvbfMWPuOc0KJCCTOYOSaCA28EHbyfu26jjst4hWH+vXdB24omMyN8jLhYIb1Ek7CtAa1mYzlPmvsNmGf2g9w/M8p4jCBXjeXPTVIUGMtvXMUK4S23rWW9NsGK3/GzeVdV8h7VnEGFqKVKeb/0G2AxO8wlTJJwLIGghF7m/VbHmblb9jnrvCWQAVMbVloQ4PVKRRKm1od5kUA3wqReGyfpR+q2Lc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Joanne,

Joanne Koong writes:
>-	if (flush)
>+	if (flush && !mem_cgroup_is_root(eviction_memcg))
> 		mem_cgroup_flush_stats_ratelimited(eviction_memcg);

Not a big deal, but in the v2 thread you mentioned you would try a
mem_cgroup_flush_lru_stats_ratelimited() helper for this, per Michal's
suggestion. That still seems like a good idea given this skip and the one in
DAMON rely on everything read after them staying in lruvec_use_node_stat(),
and at least speaking for myself, keeping the root check close to the list
in memcontrol.c makes that easier to see. It doesn't need
to hold this patch up though, and I've tested that refaults in the root
cgroup no longer flush, so either way:

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Thanks!

Chris

