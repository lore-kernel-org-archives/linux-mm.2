Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6247F4BB75
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 18:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30E846B0088; Tue, 24 Feb 2026 13:49:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292076B0089; Tue, 24 Feb 2026 13:49:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16AB36B008A; Tue, 24 Feb 2026 13:49:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3D416B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:49:27 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 965301A02C0
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 18:49:27 +0000 (UTC)
X-FDA: 84480238374.28.BD1DED4
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 685B740012
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 18:49:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DToD0e2x;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771958965; a=rsa-sha256;
	cv=none;
	b=tUGY2ftk2YfByXjQyBLTXr+wsHlsL00+6apCYkgbKg2kSElvFz8Hmy09FNf2/nuxP2yNX2
	yBDVyAFZexx8Erl5NefRLbofVWtUN0VJyZ2byxMCjCLp4KqbWOsfHRkk6BSML8C0UgvlQZ
	gwhvZZPIZ0pD8ybyXy09mbK/HgXyYKo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DToD0e2x;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771958965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jVC2sVLMOxnBh5X5m0M42esgcaqLVi1+yt0xbhnz3dk=;
	b=v9oqoeiFK6ya2RBr6ya6OCc9+AO2TCCkyf8xcV+0bBaSPzgbh/QtnKNbrnYNUaelKboYEV
	5xzGsd5sKQqWEHYr8mvU6MPt3SDGuXxSDP52O8M1vQJeXwFD8kK/BZEjEltvOd53GRw9RW
	jVXdnD1jfJ8f9nk/S/2UxQwNXPk7x70=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8cb38e6d164so718527185a.3
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771958964; x=1772563764; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jVC2sVLMOxnBh5X5m0M42esgcaqLVi1+yt0xbhnz3dk=;
        b=DToD0e2xirVj3EI1YX8XubSxWcwgUXnIFWDP+/ZnF1gnX+3sdUvsv9Yg1zdjUCTFc5
         G18RFiLjEdD8g1V3OxZ/lK0ZZK/1u6yAaOe1/uAmU6aKMX7epkZRteh/f2A/jNuid3Jz
         S3iIJVRE1QemGcrU8RCQdq1K8099sEKhwwz9BtnonoHeL0koYj7hmfrRgl2O8d8DKPYW
         R5NXptCyWElH1vxTsTeppfZH13pkZvqJpzjnit0S5ONJxMT/TZX4k3nz5PVcVTfpwkvD
         vhLVW7XcqwveXJkAfPa2sq3wjUggQAl+GAdFx5HdQj5pK3wSs5ACrYxX9oHuXmnJjUud
         5IYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771958964; x=1772563764;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jVC2sVLMOxnBh5X5m0M42esgcaqLVi1+yt0xbhnz3dk=;
        b=o9RS5VsvL7T1WFbUCUWM6B8LgKywzk2QEcv26FLau+z0rEr0v1Zy96oOOE3VMn3zNe
         lSBpGCeY9I20NezbL3XGhpn05obehEOCAZZBiA0SCOMsH0t93Nx1+MMoCx01+WHiBEl0
         vvh3t66EKYqFhhCqBq9Jib/ThfpX9xoh1h93VBTsDRe7dMshKrmBpPma/alrZxvVIyOk
         dtsgqOmSiLQwFIxkRzPmtm13OpZzbbSzt8tlyPbSx+O7GGc8vc5SCpdFbQlQIjDCB9N9
         z/yRwngZ63+rgJBq/t2ITMGo8MOS7eYqhjflgHWAeq7iMvBPQwwfrs53uxClLUsaLlOU
         S+ew==
X-Forwarded-Encrypted: i=1; AJvYcCXJtmM7wdBvvXxphQD9Y+0t+XQHcUcNpPwiyAq7IM+inFZIsNX0RYx6q2seupuSuareuQfkSueXoA==@kvack.org
X-Gm-Message-State: AOJu0Yxdc6QuT1EnRwT5Wlk87A9HvcCqpWO2qLrHrpnJ/RVicIuYR1Qy
	Ax4oH4Btfs5bqaVLFIifwkx6Lfpp4ovtIN1U8zID5u6HYPmx1ureRua1wwqMUdTrhXo=
X-Gm-Gg: AZuq6aLds9zyp9jp13Qi66E5o3MWeU2musO4Mg1Mbf0iKQcuu8W5QdhS/hhc71tLsZM
	KAw27gYvV2oXk3YeclgEB6owtArwTit5WCZN5XEiZWLetvxf5nfxtVhtbLSr5pGNMXNZEAoMg/N
	F8uamKi8HYPogb38r0hWuUpiJ2ArXH/LNIvV74+0rmni5Xctfc3Qg40mIZmPZ3re6szq0GKumBX
	J2EKmX6HnTlerCNTszFL1Pw5v+g7U8VaPwJ91e5iwXJ/JK2ziUVMXUR/uxMmmviBTnD7BvA+VV7
	uj1ctvbqkdnhEWt6Z3PwhOnZF0W3hptrmtwroCuhVsyjPMzkC4JORSsO3loXYNF0J74C0wGG8wD
	A5wSlvL86ROUKp35hxtHFhsVw/3zfbiT8AoQKoRAjTzcHPHC8KRyDu+MwrNAzmMPee5tRcuRRSF
	GYZroSvkB+ZA3UuipwoXUE4NVzwwkeMgY3NYjcT66x2fUb8CWgtbXKu75hmrLAYkzqqtaNbuRAd
	GoiVQsJyg==
X-Received: by 2002:a05:620a:280c:b0:8cb:5442:d537 with SMTP id af79cd13be357-8cb8c9e005dmr1650957585a.12.1771958964121;
        Tue, 24 Feb 2026 10:49:24 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb8d122906sm1023135085a.51.2026.02.24.10.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 10:49:23 -0800 (PST)
Date: Tue, 24 Feb 2026 13:49:21 -0500
From: Gregory Price <gourry@gourry.net>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Kaiyang Zhao <kaiyang2@cs.cmu.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Waiman Long <longman@redhat.com>,
	Chen Ridong <chenridong@huaweicloud.com>, Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/6] mm/memcontrol: Make memcg limits tier-aware
Message-ID: <aZ3ysV-k1UisnPRG@gourry-fedora-PF4VCD3F>
References: <aZ2LC0KPF0xsAwAL@tiehlicka>
 <20260224161357.2622501-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224161357.2622501-1-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 685B740012
X-Stat-Signature: e1nf8ia8731rm9ns8fm4p3a8fg7cj91p
X-HE-Tag: 1771958965-768836
X-HE-Meta: U2FsdGVkX1/4VdDpHe3jwa3672yWJ0JEedG57cwBQDDNqoB5QKXENorO5Xo8HKPxjkToc2iYXvine0oc63pTOvUGFmldYWSoTxtvEdQHaVZDzMfD/MJmi5vAbxpRk+q5aPskia251PKbZtoeI4NLUhWcauMhoECIJwa/Fxd8GbjN9xuKjM4aMOzfEi7OKDVlAqBA9rOGsdlwDFPrjIioVB/fAxQuSkm26iDv0mJx12Fn2gePIWTYh/W11BSCXfOTtjgouOs6KA/4nSbtDZskZIir4b6xBdbNPGJK1dd+3BVtjH6/ZmLcH/RvjUpG7JXAPqNmie4ky/YeWCL6zv642kClIf3mMoOGeyfTwObqS/31DqNbgYnYg5AaWAwUmgPNzYkGKNkqwuJm5rs1e9hqeq6rh2/5TGC50SuK1vue+5qkQJ0E8QDOLRjOVUEoLR/pOCAvDHwnMvoboy1N1vOEn03iQQlCIfrVe4cj4fpcYFsWZ6kYnIDmqeng7lEiCITgggH2JQDfh11I9BB6KZrzQsiRUg+//vyv7Azhsgk8Vv8QBivLCNsTj0nyBX08dVgyA9Ki3wrrPisnpCV+jDNmfkofaSmNMjBxtqq/wERAlc6rA7kkiU+e1/kfctJABCpr5ZFsPPdLtETo2zL6JrntTQ8zSFKB0R9s7ACXabIhwkF2D7QBaSdZtiauhIxIdCI9yK+15maDAfOfvzVkVbxQ2mGXvxOZmPzow7uXUO2SUjV7qK4fU3QpEiqBwwdiaFfRHwBQeUNwrtF4UG9b44ni8Bth55cwKaoU0zmGbA4DgPqQtu8L4g3cbqhGgoDZSsOgg65JkCh27hIsbP7pqA90taPftypTeujruDdRxqw4xZ0sGyjdyPMgDG2Zw/qYefzI1G3IwkdsnzEFx8+hzRpYPefCfEP77Y/g8p52kGI2nZ1Q1UDIfLXfAflN0WO5TqaQA+Dl8/eBsSVw2A16+/0
 XhDwZszX
 iFicGnh0BVOrpZv9/M3eGz4DoM9AEkOI9BULF67ABcnpZh+PIKtL/aenXdMoa5Xj4EifykilOIySmopUG8oliCD4bQqSJEntazGbW5pdEGCNUXodNTdNWLxXreSjBuQldjKfkyZoTd6dxmPk/X2AANiAPRPKX+b/Ki7w7gMRKBGvW1xZXQTvqYhmIT2+Xtu65RU4EHztdGtc2ZxSpTusyWG1HQYa57qRCYLnlVURy55xiY65htE3uvqkGBTqBCYnYykoaE8t6PfD9ZbcpLBYi8gJ2/XKZNW/CXzg4BxdocpHEwHVotfAcK5xrVBtLHlNRkv/anUVa7opsef0SVyNzSg8arrgxw5zIagIeYAHSbEAIOnVTwQJeOS9pWk5VxeX5mxutPnrLkoM/ydHLffhq8+yLRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 08:13:56AM -0800, Joshua Hahn wrote:
> ... snip ...

Just injecting a few points here
(disclosure: I have been in the development loop for this feature)

> 
> > Otherwise promotions would make sure to that we have the most active
> > memory in the top tier.
> 

Yes / No.  This makes the assumption that you always want this.

Barring a minimum Quality of Service mechanism (as Joshua explains)
this reduces the usefulness of a secondary tier of memory.

Services will just prefer not to be deployed to these kinds of
machines because the performance variance is too high.

> 
> > Is this typical in real life configurations?
> 
> I would say so. I think that the two examples above are realistic
> scenarios that cloud providers and hyperscalers might face on tiered systems.
> 

The answer is unequivocally yes.

Lacking tier-awareness is actually a huge blocker for deploying mixed
workloads on large, dense memory systems with multiple tiers (2+).

Technically we're already at 4-ish tiers: DDR, CXL, ZSWAP, SWAP.

We have zswap/swap controls in cgroups already, we just lack that same
control for coherent memory tiers.  This tries to use the existing nobs
(max/high/low/min) to do what they already do - just proportionally.

~Gregory

