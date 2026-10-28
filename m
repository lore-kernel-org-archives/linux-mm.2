Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E3D606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=MBJTGDAn
Received: by kanga.kvack.org (Postfix)
	id 5985F6B05BC; Wed, 28 Oct 2026 13:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5489C6B05BD; Wed, 28 Oct 2026 13:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4373C6B05C0; Wed, 28 Oct 2026 13:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C16F6B05BC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:21:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B497D40192
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:21:28 +0000 (UTC)
X-FDA: 85372701456.26.6E1121E
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id D8834180009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:21:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=MBJTGDAn;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793208086;
	b=XdD6SRLk/X+pDVTh/uFqAbOOHbvPMD49MGIZxhAL/EDfVo3HwKym6qu4pm7xA/qBo69ro7
	6whGwlBTMar/mnp+H4+O4GatiwExGJrZb04z8oEXozY1pbN24LA0uUq3oorGx5bqW7SLtY
	ZTum00mW0qGcxRlEow8jBdo65gCU9l4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=MBJTGDAn;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793208086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gKWv/vfGN+v0zoryVVsOrqbU4hq0g1uoOUtfYF5rLd4=;
	b=tnTVg8VvfQAQ17LMnwSy2MavnfWQFpauvj8tmMv64ywl40eErMFB6vooi58p0sRtphDwXG
	tFfmFGXsBqiF9sQODEhWUCqK8+xL7jp725J+LxFozhY+GtAh/JtchnaW0XstYdri7JOiOk
	lMy9ZKYU8kEgukQnWP0pcQuYQukJ3bc=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6774639a8a4so1186403d50.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793208086; x=1793812886; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gKWv/vfGN+v0zoryVVsOrqbU4hq0g1uoOUtfYF5rLd4=;
        b=MBJTGDAnHD+inRwqwntNNJApandYul40r1MAQC0EKopFJdT2EMvSZEeuE/mO7oKRdl
         sD5YgSl5iF8Yr2x4TsxapCTSwnXQAKH9mZCQ1rwPgiacGbFw4GdhXfo/EN1LhpMMSLaO
         Nd6lbUjViE0VOkdlpd8HqKKsaqbhtChwr2NGcQ8dTnZbapMqrqKvWKix6pKuGjRW/AyG
         bAFmBCJvs4PNnAtt0z2UI/t0600EMboofC5d9b418mX+mqA7F/06gZbCY4/Bcb2OYRCk
         oLs3LEvUmxHkcs+8r1Ze6bS8k3KcLl7QfRXM/wFH++1dr5KdrR449UzN/yTqKCUQjNsw
         MWcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793208086; x=1793812886;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gKWv/vfGN+v0zoryVVsOrqbU4hq0g1uoOUtfYF5rLd4=;
        b=fNGSRjdUuN276qGrWwqR+7uVhipQJIKY1kyn+hA/nEKJEacVoJHITIvaUgGdiULdZe
         vnFDtplb8e75hk+IKhOloQ2xzRFdK8rb7NpWMiQVqyvTrhBl8/4lmO/rxvPKQijw9QHO
         DVUiMZzwOXAkkL6yoxTK1JWsFjcY3E4YaE0dY6ZN3+MG142aYmxZ8I+G7NPhG83QmeYz
         qaH43995cT+zxjXw5+oWvzrrOlBoF38WUAZp9xeaOiKoQJ5Ny2csWOQ86apy9PWZMHzg
         S6ZylPUbJGNhkTrsHqfLiyJxiegyZxwYvlxqi00n3RFwsWkQMfzVHhXPF9IbtoY/EzJz
         MazQ==
X-Forwarded-Encrypted: i=1; AKwUvBxBeDFwX1nx62Jt5uWoeoJLvYbP5CZGsaBnOh3kpXEuaHE+VI5Yjc5eDLd2KJD5dyrTZJkuhEP8Ew==@kvack.org
X-Gm-Message-State: AFq9FYLFNC3LTedgo/5mKbpA+T6r7fTRM3LEUna1LO+gEEVhEo+VV/TU
	8i3LLXq8PJ3VLHtsnTNRip0l2zFZIDZn02dlgMjGyVCB4xOLutsJrC0ydyJWZDLuOwI=
X-Gm-Gg: AYBFou1yUOBP/3OLEM+zEWAZAEWRVz2tQ9wD3CeKnV81rSHBAeoox4+RGUOuev5P2VO
	nXyy5e3yZv+8gkSikU2KEYb4K9xj0XTj4uSbkiLeOge0EBC/1nix/TjHDOJznJbkO5hcBzOO3J8
	e+5Tn+uEAflYzt/o0r+kfLobaUUz/KhvrscjSRXpm9UDTvqETybbyGfj5VjxhjsdbwudDT57GI1
	VuYWvZdTz8zX33CCjKepJMJrze5JvonyXZhOObhmTq02mf95zYGpJdgdXeja82/ZQZ/Oz7KdUxh
	C4Nk6eLa5t2o0MDSVuEemhYyPQ7o+OCTgifCpla3OI40okqWcMOpcyx4XKJC/UxXRUuu5DvSkAe
	H9DD5yMzLLXMposiXfMEsVg7ZnKhsjWLcoBoSNGPAk+E6JtudJro0xouIDwd9BAMu2SqpQj3/EV
	2b/fYCc960ZRvAl+xW3SYRfEmVQiMctBl718km6jPhIfrAoQ4wktkTLPdhKWPZMDBk/sfx/3emq
	6Q8aadsxL3rALewmjDqyMGEIbzIbmaRUeG7ltsry/lv9dhA+cg9I+oaK88T4GEB0uq9f504Dp9o
	P8QiC8TylGtlmmn7zWwo3c6KYbtW
X-Received: by 2002:a05:690e:1183:b0:678:fa71:301c with SMTP id 956f58d0204a3-67a7b992b9amr1910178d50.7.1793208085931;
        Wed, 28 Oct 2026 10:21:25 -0700 (PDT)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a7a0c31cfsm2144554d50.9.2026.10.28.10.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 10:21:25 -0700 (PDT)
Date: Wed, 28 Oct 2026 13:21:24 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: abuehaze@amazon.com, akpm@linux-foundation.org, alisaidi@amazon.com,
	blakgeof@amazon.com, brauner@kernel.org, brendan.jackman@linux.dev,
	david@redhat.com, dgc@kernel.org, dipietro.salvatore@gmail.com,
	djwong@kernel.org, hch@infradead.org, hch@lst.de,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	matt@readmodwrite.com, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	vbabka@kernel.org, willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking
 requests reserve access
Message-ID: <auIvFBlNU5N_PVyd@cmpxchg.org>
References: <arFBr22V60BMmVpl@cmpxchg.org>
 <20261027150002.318916-1-dipiets@amazon.it>
 <auISZ5w318zwUZuc@cmpxchg.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auISZ5w318zwUZuc@cmpxchg.org>
X-Stat-Signature: 868exyozewixi5a119zm46u9rdoqr436
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D8834180009
X-Rspam-User: 
X-HE-Tag: 1793208086-154256
X-HE-Meta: U2FsdGVkX1/9FWmOvH4WZk+L0frNCjj/QX/WG0FW0gc9i19GVoVA6pLWX5FstCgPMbu3+NSmOSq8N12KguhIrW6xpxVQMqOW+9yzH+KHoJJjEbdeL1HbqUwMZQHg1EZlJNfnkMMkgVETJZ9NHqUfrGY4X7y/zhX9V9DhIrWVXj5ugGjmi/xY04OPA3EcLvbdM5oYyVf2Z22WCOV/cWcm2ulfxS8HI/OFHbBXuE1my8ErT121d8ID46CnwgP8ldBmpSveleAtF5J5YKIY2tKUhz+Yn1aqbIVMsW4urCZAdC/OA+sUxHt9QHbtzogZjhtgN4Ro0vY0rq0PvxYuA6yZ31ESuR+BZbEoCvmrsAqvnBPFI3ljVEZp9+PMmb3VTWsu+GVKwdGpYmQV9xU7uehp6LNL/3c41GMOu/vfLJYhZn5U1hnKftlI1tsFPqn2DZGwf4etWR4VW0CMpnGRYkJXV4yaQMgKi0V2WyI3IBmQhR0ctFjcbobmGN7hfO19cUZL1XAhyHU5QJi6cD/9DjuLmvoSkJpnbBdRWJmQMmML6mo6T3An8LtDIiE9Y86W+FhCsE1kMJojWAbtdAHsDRNtWdDvh3s24dMSlw3DD3P3XEEGTlyZUQSrydB35zn6au7l1lZyurdtnLH+qqA5GoY+WGJiK0ehE5Ude7Li2LGkOmYnhvZonSdtvgGh2NuVXLSyg121VsslR8PZEyZCdD4rtj/gJrgJShEh1NBmBde5esCLjIGn0niDYxFV9729q+jy4w9oeY8ScDr83cDpxa/knButWWJ4MDmvuFZW3DoqJ7O1aRkRWzt5Qx85GrLE0yzNNkd6VTtkqDMNyonKz+66/1fKI2ozh5/JJfKrex4ue/6R3aNg6oWwlYWPYMH2UKFLhuQS9MkmC3OlmYveK3F5U/X/6jJvidQwJd28eQ4ZjqU5asfPSn4KsbIO39Y173mXAaY6bITQkj/ezMKpsZH
 MisPm5d2
 oOnRJowMI8jZ5/Bvsq8UYNC8hy/QUsDBEiK+urCCzv3V5P+/2HkbprteIrbDfFzwHzPFQKIpSjKWDXsv/Vp8jLQf4YIi49OjJ5+E6HJ7uhE/ffpRPoIkN20ffOMd7AFDcHun7lV8ELrRJ7FPeVX4Thdwqdw4RqZNTjESPdA/34lHkQ0K3mvrMDywf1XKIylXJd/Fxj3rY84fC701ATFVE75cIYtE0k3DnojDEKZdiLGvBjWbsarIoPC4Mh+Wdn9puu2MILU7w9N1tFui60d2WiVDAhZvhCr4rb6+1r6rbAKtXOODVFTxIi+GIPFym1lMeM6M4wb16tup1okrLa5rG6IFLYLHZchD5UeWs1c+T4SKnZVgurO7j2bkZf0rNSzX7mNyNTis09chKbeO6Yp9tftqqhDWV3p0moBwQ41T2I2sGhrLO0cFnOMS3qKBXCYhZCRsxuFllBqcmQxNJbVusd8/VfkMtwkw+OWeHC4a68nNXNN2mkiQUTV8if8k4Y7gBMehQNZKZrr6lvOppWdCgmfNIAM2CcPj6lnwh1Cfhkx8QJOdnswpsTxNVuKzWB5OgO1rk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 11:19:08AM -0400, Johannes Weiner wrote:
> On Tue, Oct 27, 2026 at 03:00:02PM +0000, Salvatore Dipietro wrote:
> > 
> > Hi Johannes,
> > 
> > Vlastimil asked that v6 of my page_alloc patch [1] not go to mainline
> > before these two patches land, so Andrew parked v6 at the tail of
> > mm-unstable and dropped its Cc: stable until then.
> > 
> > Are you still planning to work on 1/2 and 2/2, and if so, do you have
> > a rough ETA? Or would you rather post them as a separate series as
> > they are? If anything is needed on my side to move them forward, I'm
> > happy to help.
> > 
> > For what it's worth, I ran both stacked under v6 on v7.3-rc1 and saw
> > no performance difference on my benchmark with or without them.
> > 
> > [1] https://lore.kernel.org/linux-mm/20261001082152.2879289-1-dipiets@amazon.it/
> 
> I'll work on this today, will have patches before EOD. Sorry for
> dropping this.

https://lore.kernel.org/all/20261028171719.2043421-1-hannes@cmpxchg.org/

