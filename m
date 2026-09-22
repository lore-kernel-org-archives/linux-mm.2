Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9B62C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 14:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9BB66B009D; Tue, 22 Sep 2026 10:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4C566B009E; Tue, 22 Sep 2026 10:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3AD46B009F; Tue, 22 Sep 2026 10:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 85D336B009D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:30:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 021D3C01CA
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:30:23 +0000 (UTC)
X-FDA: 85241633568.04.E1A5AAA
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf11.hostedemail.com (Postfix) with ESMTP id C8EE940012
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:30:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=H6bICUac;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.204 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790087422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2iBGnLzdAMS3zz28wNn4T4QYEjtnJw6MpoH+sl86c/8=;
	b=jr6tiObG01Wg1fMiq74VnssSHTSFuUSiAQ06z/KXz2K8IDelrfOolqRqLgfLfcJuMqlQDm
	v5hlc45zBKWmPUUH7EpqhAzl/PArrlSRq11zoJBLhKo9bV7G/umrERKtSGTehuLtgAWMWH
	wFdkRGRu4zTYFSCXE74hbuAk+kNlWmY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=H6bICUac;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.204 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790087422;
	b=3DHB7kj8W/rVH5rcfAtK1n2/Q3Mb9Y7Ts4/VjtULQsWvrqVMbCdXT3JmuoORatlJXulPtw
	xF0u4mehm9+Lr7k+KKRwx4M2Qcc3gtF/c9axA/wB9Dw36ZMa4IRKXCyZEKNL0vyFkeue/x
	vaZvTFYu5RJRekU1zNm2C03JtSETFdw=
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910c3d02aso173861185a.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790087421; x=1790692221; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2iBGnLzdAMS3zz28wNn4T4QYEjtnJw6MpoH+sl86c/8=;
        b=H6bICUac3ooqvDRSiPyixS31Trt6wP1IK8M0Rf52cOAcJI4RKmJhD3m4h40wRtmWmb
         YrJfCsQZb3FOgDBy3yriXMOH5cmXKNagmuP/x7q9w7O067rpTUzBnmqw5Yn0rI4Rt9/9
         LjUQmok2OD4scxBjyQnMqSScwa/6TZoA+D2LezkST9H+42q0qJ5/SbNrzeow1JwNUFQx
         n8AYgbJkvbAj/H5nqO9CUhYBSsAo0YwE1V8M0Aywg671ATtM++NQQzuxv5iffjtRsbCY
         kqguHQGT5RVW8oBFn+yT0/XQXZAHNOLSbm/QVXIo4pC8hPGAKv2E3OVAFrN2mFAO82Us
         nSRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790087421; x=1790692221;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2iBGnLzdAMS3zz28wNn4T4QYEjtnJw6MpoH+sl86c/8=;
        b=k4qZbcUMx5+X/wTEt2hcgjdhyZMXhztZ3C9D2R64ORlXw5wWjNYuMXAK+iQHWUW2GS
         sBj16ptVsuuWkD8n28juXu0ktcJp5jr/dJnuQp3fsjGFy4jRsKa3bJRaUK1MvOmL7hw1
         xN4OndJt1QL/TBmWfLelaw8iNtFFtV293kKROguJP/Ow8kfVG+X/2bBr8F2vagwhMZki
         wlpMuZieR43hndjf+cN9AeCT1iOkqiVZFdVkBuVsYiAsPhl8a7HWBpiq3avUPRJMnTAP
         n5B8f4Lzbu5RCESa6SSdz9xnZDyRC5IlsVuNIfTSuAQwK3Sl4kqvhEMAQqQb0IAXET+j
         k9cg==
X-Forwarded-Encrypted: i=1; AKwUvBxE+Nft0qbNtqQfdptg1qpsPAOcd1rPxOmT7I46k9hp7YRkNBOeqV4GQVDgLl/YGnGoWHN8Mcf55A==@kvack.org
X-Gm-Message-State: AFuF++lwpWlfvXSvKZWSDD2cWq+L/JG4xNf7OdvKXT8BYPdGMJ/ccAt5
	h+8y4s5l6GqcutQQWY5NRrwGMvbRPPnPrijDzfBucFNxUPzEQjlPD99jQiUzCtgoipw=
X-Gm-Gg: AYBFou3Ic0eYhhlOKTF0GW88d0Ju03Jb400KTvBhWxurpHCj197Z9EhYMXFbz4WZIj+
	5Q8SvSmR4hG966+WYSICZ4oZQokMxi6JKuFtVuSR7aliVazhuBoLnJfg7j1uo+jd1zB8raS75M8
	FZOWnsc14dL+CxN6cJJk9omFSH52t3cKfaJECffVuVYdVnuIHW6ryN6Iy8O6MIjf6WOx3rLM+W+
	Ez9oFLG1YKmARC9A3iZwQfgzXNnDVskAGVTi+E8GcYUixRe2Wlnm0UZUeYUdqX89NDNKwzorbR5
	JFpqLAqzrq1MWP0Dc7rJsfQl7exUHeMKbprqz1zBPjI6RnBQ5fW00+MsqauR0vVRNW9NMd78hD5
	yof8w56ehnP/Bau7XD6tokmoh1zz7RdPEy1cEzbmmX0iXcm7EorZhaUlAd0XqsKMqzo2UagC4GB
	modqTQRstVbmE19m+51Uh/w3kzqeUZWcIbI3r8noCHDH0GRDtl9GYXF9f82SssO1YvJEyc5zY/G
	njiIS0=
X-Received: by 2002:a05:620a:8014:b0:939:4baf:5b99 with SMTP id af79cd13be357-93c17e7d4bamr491449885a.18.1790087420769;
        Tue, 22 Sep 2026 07:30:20 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c22922e6esm34144885a.26.2026.09.22.07.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 07:30:20 -0700 (PDT)
Date: Tue, 22 Sep 2026 10:30:19 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, kasong@tencent.com, nphamcs@gmail.com,
	baohua@kernel.org, youngjun.park@lge.com, david@kernel.org,
	kunwu.chan@gmail.com, baoquan.he@linux.dev, gourry@gourry.net,
	riel@surriel.com, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Subject: Re: [RFC PATCH 00/17] mm, swap: xswap writeback to a physical backend
Message-ID: <arKQ-2fXDOyQzbZC@cmpxchg.org>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
 <CACePvbXiUmGV920BM58FKuP_iuvhRuoSZrGrrS53rLctJd5uVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbXiUmGV920BM58FKuP_iuvhRuoSZrGrrS53rLctJd5uVw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C8EE940012
X-Stat-Signature: kkf3ugrgx4o47ociaxjdk3nmmbed4kbt
X-HE-Tag: 1790087421-191118
X-HE-Meta: U2FsdGVkX1+eM5cysyDxLDS2fizsK1Jw7h+oP3VBWmhNnPVZlaNXx84at5k2z8dIKJHe/ngOkUbjkOwjreluSU0lHWj23rw8U2Imx0DYBAENss8H4SdvrCtbW28XDIg6DcDjgNPh+RotnznPPDPhs1gVuAAeELzOCe8DClENDOjs/A7G3w5o//KwT1qN6NKRXXOeghHI8jsv0+IFpXVQXhyKyAq56S31dRp9NesD8xBwnVu7iB6WpkoD2WL+jXPsikLCkrF5HwT9nNbGwBUEhLtqMQlAuJfWZKP6t7Y/doLWSrfRIK7vgloPwsf2tRuPCczDADSm0MTzYLljbKKIPf7688iSh/yHIHYwmq8Ai/pu/kIUv0TSHMOY6P0fo5sumcTw1ulTqfdieSO/SoJDjuR59gdCO5ovm/VCi3ggPnu5EjL9o2YwsDMYMWgvkAycLsV1UK39oJXEhV8kfB2WiuK5mooMMGCmZhmtpqG99F0kgux44LFv4d3w56kWv7GGCMrRjKqhep7I/BTTd/xOGb8wnJLwvJxxDjn23cRHBBdguGr3zaCO9Kb72PcS8rcinTGalHVQ/+2hawirHQciutGqLMx9QdPPB0w8zbIEQUDDYj3tI3Om5G8ovGdnDsJIR+Hg60iOrFZkMbPkCgx3cH0TAEWhOMzUXiQWTEP3S1IdVUCHaBNQaSblTVh88fOR92lVutTP9t6A8gMxW1HspTWCKTtKflR1gSJ26DTiJf7UAzvLrMjwNe3yYwobopISxG+NSzHJcApBF4rSA4kqW/gIVc0jlHZv3aN6np/BDpfmQsys0nw8sYwZLOVpb3QhNfQZ3fxjuF7lXrid07uX0hZduyF3haRp8ZMFwtohnQ8+hjugc5SZPDQr3AJAMXnei05rbeKd9zAQ8zZ0JfUSYx3I1Ox5OMhqLZshmNLja8XBoRwrgkkkpodmz/aY10nTFhaeZHcuC4EkVBcKkva
 SqEqElSd
 DIRTdJWQUQYn4GwhZzLQ18Itl7/gzBbTBdLQTabcV14gnfr7jfQJhmY5KHEjVJwkxWn51yM90DMCRRaFcj0qr0Dmij3CJFe4BDCMudBBGukz7eQuxQq4A2AM5BD/lpeOZMxFHqnvxoCW15nA8VKQV/m4s55U8ruTd6jnP/FDsf+gP+zeZs7MMBKpqac37ntOEZO7oa1LWHlq+nGwBhDxsmCLdKXOXfrblIy70Gccs8NqoYTTiBnLUaiFnjUXCD2hbpHHcvwlPv89RjyXvCj1rZ10EZOf5gfHy+mlqiggDMue9bWD/XW/WhRCJbXSg5mC9UfYeYnpIdlbVVWJ7crBz2oQqERHBEE+TMqrOu+uSpxUZjZQ8fsyKjU/Bp6Kef+R0ryQPAGyLqoQkBCfu4y8O6hmia3knm0bz7busW8V19gZX3AnbuTv/bLPy6lxhVruqO7QwcTxOiqxXeRpY/DwpnAc1l96/fDhHAt7dCgc0KAozqCS7JVgA6agNNbf0OoykIqdF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 04:22:51AM -1000, Chris Li wrote:
> On Sat, Sep 19, 2026 at 9:20 PM Baoquan He <hebaoquan@kylinos.cn> wrote:
> > - Charging: Record the owner at allocation but do not charge. Take the
> >   charge when the entry gets a physical backend slot, and give it back
> >   with that slot.memory.swap.current then counts only real on-disk swap
> >   usage, and a cgroup with memory.swap.max at 0 can still swap out through
> >   zswap.
> 
> I want the old swap charging behavior back. Please don't change that
> behavior. That behavior change should be a separate discussion and
> split out from this series. BTW, I am against that change.

Charging the swap counter is a hard NAK from the cgroup side.

The reasons have been spelled out over and over. Feel free to engage
with those. But what you're doing here is not productive or in good
faith.

