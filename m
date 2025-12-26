Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3159EE8FDAA
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 18:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9203A6B0005; Fri, 26 Dec 2025 13:58:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4246B0089; Fri, 26 Dec 2025 13:58:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 785FB6B008A; Fri, 26 Dec 2025 13:58:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6449B6B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 13:58:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC3E21A0202
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:58:51 +0000 (UTC)
X-FDA: 84262534062.06.6E74269
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 20E38100006
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:58:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DaDZV1ur;
	spf=pass (imf14.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766775530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhlrA5UD6vYZ+x3JcTWZGMJmIRFbEcfDotqJPwZRBT4=;
	b=itkYdv9jWUbeSLUDxZ6pdYxC9GcJLrLmOrrEYK5iB0vKKrr7PzsqkH+uAgCGVapCUSjnSi
	lTWcBqA4NSFsIRhQaAxfGScnNkyPGhSdQy9cB9vBSHraPfHEEFrAdf3eq+IJVL68KhxUWf
	PrAuiSpd0ALCisC1SRdeWwIFl6eVT1s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DaDZV1ur;
	spf=pass (imf14.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766775530; a=rsa-sha256;
	cv=none;
	b=W60lz7zpx5XKFeku87l8uKy2j2x6PQSHPb4B+uhuUwUs/NqhyBf7HZFBqiJPCbB33JypTh
	W3CHylmWmGIDt/eTCDyWJaTpPxMEuv4XkQJIOVsgqN5CLPvX2pEMYyj5G5iESoMUzSOsBd
	blgmGr0TCOsX4tbt2eTwKXmYpGd+M0s=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a0d06cfa93so1097375ad.1
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766775529; x=1767380329; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uhlrA5UD6vYZ+x3JcTWZGMJmIRFbEcfDotqJPwZRBT4=;
        b=DaDZV1ur4cLRqF0LhVjBQWdJvNFa0fXikly76677v+zUrRG8O2G7exWR28DTbufojm
         0xaFVeGCSHAjLKBYDqQujq+XmZwjXFI2PVabK5cM2nEmCBMeo24VpJAfRUtGxZNiErZr
         MNHkjwRaa9H5uWbCvRi+gqCXQbb2GGcGuQ/cNYWEbAbFqjlasJRGgZiFFoe2xTpniL8N
         dybx+IwZ/g5ot8S+apLO5I6tJUqPw3zmBY+0bk0STjYdf5qJBldArDv/fHd7gSmLq4hs
         ol1KoJv8v0Sr5HLcAnufn9w4I957T5Wa30GrwsL/cFd7+K6oIIjWZZiLuS3AvhzCvqMW
         Nk+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766775529; x=1767380329;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uhlrA5UD6vYZ+x3JcTWZGMJmIRFbEcfDotqJPwZRBT4=;
        b=opXGfnYWuFx+WKv0+EX09SlzCaACXM4MsQocZPiwMsb3ZszantXmvMXEkKDOiEqwhi
         bZWJRyTGY8ZD9rOgdtEUGjHpshUjZHa0Y1enjp9q7mDTTikWdlbIAMh0XbTpxTPpDYYx
         tDJhiJqA7Yf0H1wavOAKUS0mDC1POUJHyrn7aaJLPWCHwIj+ZIpXYPKItMaStTETqq8C
         riuNQ44seF7YKeyeuFcjzFKQHKAvW9DMf3A/V1lhqNlmliaVUb0/ACD/X9NTA8K3z2Nq
         7MFpAaK0a2+duOEF3QcM4le/I2TI5ue/keX1jsS5SAWaLcqmG7jnDFOO1y5y5XiBfLwB
         himg==
X-Gm-Message-State: AOJu0Yzm9KTtHZ30CxgZYGA/MNIOnkcRvRkgai+HlRLEoSQ5ZtcHk+nT
	FWqqPgAsTB3Swjq6veq9OVO0gDf1baBTBircQOhrug57yv8ztvvU3b8vdBAQ+FMkig==
X-Gm-Gg: AY/fxX4+7eCBeteWFFdrjLj+/Wp+CkUVgnc3bzES2ClxXm+6eUYx0NV7D5wPKu9xwms
	ChIcY+PdB7dvcMZGKaa1J4LrjQ5w7aUwBLjn7jfp2u5jrxVAzbVHuCmSRfN3mNjoGX5UgM2Zhgh
	HSKN8GDMMkKvq5t33M7ysbWU5ZX2ZH/1+VPKTib06tnlzfpTkKHqjTOozxLgiIhkChjwQb3GYoe
	UyALUl0zFFZFYtePJKjm8PepL4ZKKEtyet7v55p2d3SthLI22IynTE9X5P4QELbO0Xr6MuxC3ov
	mfeQeJJijp+jsGoIeXTeRM54t8z0msuisKSzmugNmZDttNk+QyqOY5jWwQUlzUnvLFPVpcBf4pv
	YJKOcJXehDUx75KD/KFRq18iQKcEKGOtbkS/LJNGj9/eDR79fQaAAZ3XVcHrli+VRO7dBGbhLbK
	zCutTei9sy2ZU05cUwAq/oHF5ckaLuCUGFyDmUbdzCFfQgIzF4UJiv
X-Google-Smtp-Source: AGHT+IGQFAd8PfbkonRWK/eILNYIR1fN8cIZOU37eemTt6WBkj4X56w0kou5ks+d/BcUYUIqHdofxw==
X-Received: by 2002:a17:903:2c06:b0:290:cd63:e922 with SMTP id d9443c01a7336-2a353a4e3fcmr4253275ad.15.1766775528500;
        Fri, 26 Dec 2025 10:58:48 -0800 (PST)
Received: from google.com (248.132.125.34.bc.googleusercontent.com. [34.125.132.248])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c87845sm214750925ad.39.2025.12.26.10.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Dec 2025 10:58:47 -0800 (PST)
Date: Fri, 26 Dec 2025 18:58:42 +0000
From: Bing Jiao <bingjiao@google.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, gourry@gourry.net, longman@redhat.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, tj@kernel.org,
	mkoutny@suse.com, david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, cgroups@vger.kernel.org
Subject: Re: [PATCH v3] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-ID: <aU7a4t8ncmBAqjSf@google.com>
References: <20251221233635.3761887-1-bingjiao@google.com>
 <20251223212032.665731-1-bingjiao@google.com>
 <646ee1fa-edd1-4588-9720-c3c1df8ebce5@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <646ee1fa-edd1-4588-9720-c3c1df8ebce5@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 20E38100006
X-Stat-Signature: aawzbdpdjd71hmepdyk74ahm34rt7tnz
X-HE-Tag: 1766775529-29769
X-HE-Meta: U2FsdGVkX19zdgHd6ynU2cCAgpvbTXmtg2LpZ4RVZbiLsp69WPzT14U5efuhM8QjoOG0+29vAeXYlV0xCxLlT3VWJhOI6lXd49Gf34lKfuq0YeuKM5rrINuGn+O77FveQPMPWSdfkvJc/x43fw1JGCbFqQrc+ZYOlcBl1j4d0ld76Fe3gRMiZskmczO1gHHmBRmffKTqLuoQWiqzsk2EmzVNw377wA1iZaKUDOoHuzbZPasQhzaXs/3xt6OSIG+rVjFYvHuJ4uue6DaO/etq6j+RiP5KV/4UBaED7sNmTwkAgfsyd2HZTsWlLg5IOvL0AWRq8Rtl2Fp+Z1BcpBddM516HTvtk3e+S6QLLBcpt5g3GuJEQN2XyBG7Cg13aEYhl6toML5ZrLpr6uPHWt8UfbJz96fRbDbPVwjFmYOw0TDVu9/kNpPqqSdTcTbGNvrSAbkTcEzms97mo3xzAjiTL+iJWTGn6ixZgj194Mmgly/QEFBYejzR/sMhR0k/8Jaq21v/tajwwPH0n0VbF25+BeWqYTF8zHQJQExW82PiAZiKr3n/mzMi4ZFV4hZrqD0JS+4Bxn1cRiAGLlR33NgxxFJILtlWEuqPOe//SZ25ZuTs8rcIJUWlnchBs2BwCIDoq/x+0IKYo/PBvPHsKV0OujwGHRnaFEMz7NoJQ2OwyYyTO92U5r+g4sKayNwH8CjBknzcfo71Co8twUD7kOH2NPSDUxPJX5HAlKmKGBK8Y3MX1nUszqIMicvgS05IOYljsjCmR8oZZ9Q2orHOAb1CrGQ5PbsrlLJCuRVUD+GfQqlV3bIIWYAiRyvIfUEeXUrTqM+ABQTzfWbgg90/yPL64s2h98B+GTWGBhrNK+heExuiF3gnJvDteG1l1aREOfkmDffnR1dEBZ9Cj+gkfphpKYhMAoHzJfi7B1B0SL2YPX/soxw/uAEoe2WtT3/1e5AjIyB6Rj+2I4FbAOX7lAm
 HeWc20H6
 pmgPZjT1Flp6YipnXa9cdD0oxQslS4k637tasCPOLwjq7FrAf5IN0WYWYPYVFokvnRHcsbSMEhtzzM3Amvv3osH54xeaDwyBsCWodpVyZZSJ6BSj3awgm6AR5F4dtaS4JxLB0dwXBLmrk3nAhsgecnuxn1jt2TR4xguvEVBr79ml6Vgzm5qBROQ+iMnJVG3GdlreUKstnYsPwigk/2ROZOn9uQwu+i9cmeWe1o0ZXRODdjI2MDdSAGTIwfxvkTuF/xxJtuayLw1RQtrSxrUI5qhXXCB1nSIZOFfqBFQqz+7mtu/ZOvClyCzcrB/NWQCXLMWi725qhiAf435Z6p9OMRIfBVGgL2Mq262EuohjZgQ7wGWU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 09:49:38AM +0800, Chen Ridong wrote:
> > +nodemask_t cpuset_node_get_allowed(struct cgroup *cgroup)
> >  {
>
> Could we define it as:
>
> void cpuset_node_get_allowed(struct cgroup *cgroup, nodemask_t *node)
>
> to align with the naming style of node_get_allowed_targets?
>
> > -bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
> > +nodemask_t mem_cgroup_node_get_allowed(struct mem_cgroup *memcg)
>
> void mem_cgroup_node_get_allowed(struct mem_cgroup *memcg, nodemask_t *node)

Thanks for the suggestion. Pass a pointer is better.

Also, Gregory mentioned that the stack size may be an issue if
systems have many nodes.
Do you think it is better to use mem_cgroup_node_filter_allowed()
to keep the stack size smaller?

> > -	demotion_nid = next_demotion_node(nid);
> > -	if (demotion_nid == NUMA_NO_NODE)
> > +	node_get_allowed_targets(pgdat, &allowed_mask);
> > +	if (nodes_empty(allowed_mask))
> > +		return false;

This is a fast-fail path. When the queried node is the farthest node,
allowed_mask will be empty. Thus, I would like to keep this check
before mem_cgroup_node_get_allowed().

> > +
> > +	allowed_mems = mem_cgroup_node_get_allowed(memcg);
> > +	nodes_and(allowed_mask, allowed_mask, allowed_mems);
> > +	if (nodes_empty(allowed_mask))
> >  		return false;
> >
> 	node_get_allowed_targets(pgdat, &allowed_mask);
> 	mem_cgroup_node_get_allowed(memcg, allowed_mems);
> 	if (!nodes_intersects(allowed_mask, allowed_mems))
> 		return false;
>
> 	Would it look better?

Yes, nodes_intersects() is better than logic-and.
Will update in v3.

Best,
Bing

