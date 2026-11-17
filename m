Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61770606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=aMlwB31k
Received: by kanga.kvack.org (Postfix)
	id 6CB816B00EF; Tue, 17 Nov 2026 00:07:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67CAB6B05B0; Tue, 17 Nov 2026 00:07:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 545146B05B1; Tue, 17 Nov 2026 00:07:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 314A76B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:07:37 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 96B611A0331
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:07:36 +0000 (UTC)
X-FDA: 85443428112.19.E38BB6D
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id AD55C20003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:07:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=aMlwB31k;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf13.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.173 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794892054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OTaK1OORIix+uAUUdAoZK7UrfRWre+LYMnS9mqriEQs=;
	b=qYZ3w0aW3+WDguHRqfomeKbTS85sWn6GCn8lJ7umMNTIpxbHxGvuQkwauTwdRUvYrFtC34
	R403vWDFDl5wBmC0bNGBdMBrwOu3qVwCd6g7tFaoREWOu4orkMHSSTH//lhHUNDi/Zh6Nm
	30aj8Y8HQI16t10282lbpHU30zP55ZM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=aMlwB31k;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf13.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.173 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794892054;
	b=K7kE8lrRJbk+AwaKMFNGgHVb/ds8ML0wZnXzDmFpf3gvndyZc0d2wUMGRx2J0PYthQBFJH
	WvWYNV5X4sYmS90mdkOCRhkJ5IphLc1ptzmGi9PcPAq+ecYGAvHhJOwgVcOKEIDfUGmRT/
	iYChM4z0WGIP7AKx1x60RiTGinAeUXM=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-36e99cf7bb3so5508608eec.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794892053; x=1795496853; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OTaK1OORIix+uAUUdAoZK7UrfRWre+LYMnS9mqriEQs=;
        b=aMlwB31k9B3e0jkPydptk/W6B1NshARfYNB1W7usylAW+SPBI2d2NlqoLpGIgVdaBA
         C4rgwjcLP6inE/mudXz5NmeP/eLY+XBupg8diUm9wziPHDRmwoow0qWPhozPvU0Dy0yn
         NX6vTUB0VOxrFKMfIU71eS6WJAdq6OsyEs4Cg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794892053; x=1795496853;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OTaK1OORIix+uAUUdAoZK7UrfRWre+LYMnS9mqriEQs=;
        b=s+WO3KJW8ZWxfh6II9bl2GaNuWKaq9gsDSMKIT0RwNNoDNY/DOoctIYIdfpGD9R0ns
         MeL1EISJgf15pKnYE64nhW57SJjrK7yDh/WEnF/5lgbgkMUEyui2Va6Jkc90IDrM1YEa
         f/8JRbc9/JlRTySn+EUuqo7NRFTrHCpkpDbjeADhaUwcSX0bQBZ0OSe6eNIwuKjnyBH9
         OkweFI8ohLHh/yz3dkcmp5AYJiHMa9jfc33q/VZv2Byfd4FuUcW0oyeKOzDlFuvcnOXd
         vodBhgIUeB80mzJRuY9dpz9ogJ4twGGjWIECxfou/1OyGr7S4Z3NUapVpdFXvMiiVixd
         7zcA==
X-Forwarded-Encrypted: i=1; AL+hErG56nplAJMz0uqBsiUS5vGw9zbz8YKAknJeuHiEqTq2emywp3le+QlkZoxl7d6T8itm3bls281c5g==@kvack.org
X-Gm-Message-State: APuU4Z/kERGMgHSKh/Xle/7biVMFkurDxynrm+ZI1WGTyQM5I1s8OmIC
	X6U4f4dmmkqMP7vifyjxbg6EX7MRc16Ve4/OTo8D+Vh0zhIB5AnRPUOfNrJdQ9y7yJ4=
X-Gm-Gg: AZFdTZf7K2Amnx6QzVUJ/1qCCGllSzFP59DHYHt5busUSexUevXcN+G2MwR3f1+z/eS
	jjxQYwkLSz9/r0vug59dqpVPnzfIXSkhn5lFXZPYdGcBEbry6FHrsdwCbmCTnrTlKF8NW3pLZ+P
	2Bb4pHswbyFcgyuGPRO099X37FDScDoxOZ/HA0kvvD25DmglD8HEOGhFYC4PB1VugTK7YCev3UF
	NhQ4t81s/NjLoUPmqSF9p5qgcFHY2xptRE5n085wHeWB9aDughDUmlmGFDyTbQii53/qg8OSCZQ
	KEUMgJKSFiFJVRzox3FzAJN8I59LerhGUMB9zV07PBgvS7VkDCABxui9MIQo9zEk07fBi5Oyds4
	bB2Mh3VxXwsgk/RhMeG0U5+Jovm0SwxPtuSz5a+Cd6Jz5HurNcJgXg5p2C+zCB7kPLxt8bZfebA
	t+237SqnTzIE4+u5p0Rwf78Ig5SN+K/64cCKZSFNell/av/egUEhq8Ch7z/FtaWM8NZ6cI/MUsp
	kz0/TMJXbH4l3fhEAf1wzoY2xDKF6Leu+cI9epIMe7d4YyW/K/Ufuvle0nwoDSS1uw7vSRSOXy+
	lWa1WEC+UoFgp3KOhmAc6vUeqF/XBld9V3HNkJMuhl6+HJkXbEQ2D8aDdfoQkx+YPQJpcgKxu2C
	kAz9R0IAeRpIkrFcGDEU2yHnfKdMEFZrg2TRsRctDaYViBTrrtLxDtBNuCSbfESEZzvLt3dbToP
	Nbj6FYg0vXCMfCU2d7O3e0Bd7UOYpbQrePfdElXQdkMlD9AXhNwGpAwKkMs95UtIGv
X-Received: by 2002:a05:7300:cc82:b0:36c:9b35:5d46 with SMTP id 5a478bee46e88-379681c811dmr12718279eec.26.1794892053330;
        Mon, 16 Nov 2026 21:07:33 -0800 (PST)
Received: from [172.20.0.3] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38116afd7f7sm3833544eec.17.2026.11.16.21.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 21:07:32 -0800 (PST)
Date: Mon, 16 Nov 2026 21:07:29 -0800
From: Chris Down <chris@chrisdown.name>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, yosry@kernel.org,
	mkoutny@suse.com, shakeel.butt@linux.dev, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, ljs@kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v3 1/4] mm: zswap: fix shrinker count for the root memcg
In-Reply-To: <20261114002822.1043378-2-joannelkoong@gmail.com>
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
	<20261114002822.1043378-2-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <avvhESdjPdJ2lDlf@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: zpxg594zmce75nyy49yqr1ok4fwup3hb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AD55C20003
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794892054-222524
X-HE-Meta: U2FsdGVkX19VYseVXDRICG6Nfjl/LFumYB0dt5ovTLqdntsSqBItWvbenUNaKZFkHqCheuWhkcun/stfFoyPXxQeGFzKMStrgCeDl93oG+Y3zXrA3olEb6AfjCrfgwvFysNAZhfkWmo56qjdBlhV+F1z6pr4IUrlbJhWpCI687dovqnR4+a/39KXdfqNr4QkE6ZyMNEfE1wSgyAZ0TKIfAflJq4v4wqqbUICQt42B/cKW9l/r+WXhurzAUTdh8R3RaUugLmcw3Hg849ljh52VIZTVGo1n6DZPgywpKMkf7BODMbd6TAKLNQA6neuxQys8PPioIpJXQ7+IxOjzR4twVqZ7pKOmU3kYF7s3G1TZQ5v1kzglqLbhBO9+O6wF2rf7aPYlHg1jSYDNdtFQH1BP7E2RHLXqk7EPVMcQV3+tUo3d3JmPXyVBkuB2/r3I2ndgaVZZXRbIWAkMgC3x9F0dwHCasXeb7hxHjQHdPOq512YJ6xN8Lbm4UO6I2s88OG/iq5QgNuScRUldib0P8aeNjEIlwJtuxJkiI0AT1P4fQI22DNktrCgQrgHG6lylWUjR5e9yEmaDIVu6mpfQHwqufU74qhRdjkdvHzWjUtCV9Yg2mTyxrJ0vntU1Iyy4VtbKOKoveQEWzKezZuqSNYGI9EdKntPB5NccUuGwAnFcsN5Si/NSyRvBjAo4+HQt33/RDqEP+/bzXOSP2AhXzyE/i2aH+9rJlEfRG10uujhzPEG7z51HiHr7hBOQWws++/R9c3sbwb+/j8bkAmFNjp0UhA5stQYZ8CeyFsdR1pj9yWFSFJrj82aitjPDLUNv1kSIHH3JywrOcEmNJKUX83dUe0Y4wrgfxiHLAa96/d+Dt7zBTxJezdcL04XsO22kBqi2ccyZH97U0l+7xkTrA1O0a/F67G3ur0/Z7FnU+iUQ5hFz8Ot0f/3Ul7UptmYkhYTPFCLYD5OhaOV2div1m7
 y1J56gMQ
 aRTQ8nQ2K68mgp56yu5e1O0RzPlSD1ZNK5WNfxv1GRbP9+NsRisLT4yCl55XRXvRBVf96nwzVeBheMGC4McMj3aURQiZ5wZO9bMbwrKTRQyMdIxG9LFdndKy08C6tm8hDhRekr34mjgo3u4Jk4ebTtO7JB0AFVnXaZrbGdrHMOkDNh2DUp0k0hSRQva0wbu4zaZuYOHqL8DUQK97u3hMNQZCl3WwvPmJg/9xurVtrbttqdf09UrOTut8i1H3sWcTesRoxrpbyAHLe5SNYii2n5AYo8gs7l8nyUscw/OFH9ZzNKEUVkSeDQmrjfR37Dvhv2734PJmkdNFFgYW6BEswYE6QDlOWUDNGWtp5mfXSeprjw4K4DVVbSzh3mTYdaNSNruxbQfpnUnk9BDqfCpiNA2PN2VDY2UX4UcBzTmWi3E3xpu1TGHk7ro4u4A/CjwLbQU0gY6Sdf20I0QE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Joanne,

Thanks, I've reproduced this and the results are definitely much better now,
in that with this patch it now writes back pages for a workload in the root
cgroup under memory pressure.

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Thanks!

Chris

