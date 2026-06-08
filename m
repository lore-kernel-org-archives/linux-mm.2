Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57656CD8CA7
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 22:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7590D6B0005; Mon,  8 Jun 2026 18:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730FF6B0088; Mon,  8 Jun 2026 18:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66E226B008A; Mon,  8 Jun 2026 18:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 572F36B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:27:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0164F1A0311
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 22:27:22 +0000 (UTC)
X-FDA: 84858182766.15.989B84F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 35A1F180003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 22:27:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MvpMmVGo;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780957641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZnzXMKmNNQcMAsK3GQJoXlxxelkBmMuFNwdAjWqeeDg=;
	b=vWzVBgHTHEud++EWE4d8qctH7H1SmcPSHSxeE76ASMmdUAlK9+kQx+bWsOSmJjgTpeY5TP
	YZaenZiRvfveIk+koBOpIZBtuQw5+LX54fqv+mgsHRa2zb8M3svlVvKcGGESfwhQMfjn7D
	Dokv6ka6pXtb95rBXTZa/Z3L4dgPbU0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MvpMmVGo;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780957641;
	b=QUHwpVybpC+gm6UQE89sN6jBDcV3a2IRlvohFz/qEqf7Xyw8pKh+Xu+UiQ2tKbBNcd5AK6
	fTV7ycnBdUNwLiF1Bnw9wVpbP7Iu8qZqsYalwzwmobkd9D8p65TrxugVk5fte20UIzj7tf
	bwv01XNJVRepH9VfOdy6R8nQuDnE9Yc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B0D03601D8
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 22:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675A71F008A0
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 22:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780957640;
	bh=ZnzXMKmNNQcMAsK3GQJoXlxxelkBmMuFNwdAjWqeeDg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MvpMmVGoRMm3zfigrF0uV+iRgX42h36CoAm4KPvTx70waksQrU19h5rGcqgk1CPug
	 Bopifo2qojt34FmwIkzh2ghSJjAiUNaqXroRBUWNx0Hs93HFkIbvjjV51NNzVV5KLc
	 2y/MuzC032dWidywn7akmnTutYBP7iqrA0pBW+dffg9t7jLYMQr+dDRwCTzc7Jgyr1
	 Ibxb+R8UVC3j3qzBqej09gIOZB11mgKUZIt0wUawHHLZ824KQ1h3aHhKsn+QVGClm8
	 R5nAuFpmgu1ZN93yc5fFyliPwzqwrskQX1rHU7SCOklp3a8k0KKF/AAE7PeSkd5FFw
	 mondi24qgGMxw==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bf046d4da1fso493572966b.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 15:27:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8KsBKJ1wVF61dvqASvZJATpWX4lenLoy9qU92LAxbdikKOyLAb3ERTTMlbini6HtT2Jr7UZaYMRg==@kvack.org
X-Gm-Message-State: AOJu0YzMxGofq6W81u2LAgVBhOfiTi06arKDD8F6x9wc34aplwCWvDGA
	IqCxwxT4KQxjpJhKDJWZy9SSWqJ3W0bglyvRo/groc6WqW1lZ0nqOSi3qPj8+ReGYRV62dectjK
	/cbwkkfg527MwhVeA3s+CMOZvow7x6og=
X-Received: by 2002:a17:906:d552:b0:bf1:1d19:cf95 with SMTP id
 a640c23a62f3a-bf37077232cmr900655166b.12.1780957639295; Mon, 08 Jun 2026
 15:27:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
 <aho_VtLCmIRsNyvO@google.com> <6deeaea7-3cd1-4403-29fc-d2dc55c297f8@gmail.com>
 <aiBqzOtEv5iAC_qC@google.com> <CAKEwX=OhxUxRCEfvZMnWzXy=Fa4jgzL3DuP-RmaVzdK65m4bew@mail.gmail.com>
 <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com> <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
 <aicJBVT4pBvmyooT@linux.dev> <aicZ-5GX9De3MAU7@linux.dev> <CAO9r8zNBJ-BsXyKFveA92jbwMu63uFVTY5CuT4fRHTBVcOjhPw@mail.gmail.com>
 <aictKA0XWMWbxFdN@linux.dev>
In-Reply-To: <aictKA0XWMWbxFdN@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 8 Jun 2026 15:27:07 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
X-Gm-Features: AVVi8CcbjjP-avdNaGSAeiW9slgw-LB5QMjLbgQUyQtJGqfa4iRAJG4WdDe98uo
Message-ID: <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, 
	tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev, 
	Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, chengming.zhou@linux.dev, 
	muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 35A1F180003
X-Stat-Signature: bjur8e53cyrsbxuo31sn47wc9ugjcixh
X-Rspam-User: 
X-HE-Tag: 1780957641-504241
X-HE-Meta: U2FsdGVkX19woBv63QPTgwhqVPd+H22XAMw2tk8QN5GY5HFa/7DRLtEbiZUSCsP7qvlSGxII3UBOnQYUgWP6ANbYAhnerZW6l3xpPSfkoQXLUFbTsw5xWwQhhPt/QNF7HHVg0lxg81XqVHKskRW3Vw4KMjAJNkhvQJfLnotjH2nubFABSB4Vm4v9ytqdK71Yv/WeipKGzv7xnh2h6WuI6FsZsKO7p2o3Hg8TDUIBjSDz2ze0TREfnnqUVLBlLNKhs6UNKjJBMGz7Jsm8bcRh4gx8+an0iQ8bSkIXNHzH3xca417cRG9HohlxRcMqzj/OgLuGjyVNOgKYpvixkb4hx52vqL6bl/DeJzYMQvsCOazkM17/Jve60cd27m8s+d5HDexdvcbySqLjG0B650ga/QkDWQD5nPdNQ/7UpUj8rZWXgmPf2EIsLiWYiEcdj9T9vWjwct2i7XQhrOqu4Ie/TEbEpVD8L7I/H28oRRYNunlJQqe110lfq9VpkZHtvIXKP/A7FXJgC5P1MM9VXyuDOZomkNb26UmwhPFxOqbDHYKbos0Y/w/42sU9/cpRO+yFR+XPpLWbVmpw9UTfJUbrmSzSrAw0YWFHcYxOhVQHnhAUDMAyqe1VfgoHio5Jhc62Q+Ax0MtryR/Ps/qbR5mGfKC3VN2Dy/PXF06xSySn8hWOv2Wg7K+UmQcld4UoW5qcCHZlOFICcoRRKuScp17hcTh8OCbT5sKx8W9qThj56PYQBR+IvKW1wrZpoMeK4J4N/T14C/j7EFdTirfnu1/kYtT1dwnRFIB2bAB9uWfpCb+8mBZ0POFqOgf6vtqHPq4jaBe0hY+c3++WkEGCtNgXBPiLYstJHAvdAMrNty04OFytTyEvixKrixoEU+ZiGKU1l285AOG2fOYGXHDjWYVY2St7OtznQUFDoL7JxRdJrMOfZwhSiyx3oPOL/JuDmvkTgvafOSSLoDp+TU35idz
 5krEwIvh
 MODSQhJwPirvqrvWNyyDz/1RJLI+OmWk0y5y3ZqYdLEQhHzmNgIyOWOWgJni24c8GDhP5HoyUAsLuIkp3B7dMU3HK4EPnBLtjCPU+86I/DaABZGVIJ6yAsCpcvAAdvDfi7Cgwd1uhfaWXZm9EAE1JW/7YCePewO2oHjTMnvpTEUrSk4iyTN8uhGULApDXJs7/vGjt3msgA1w+/duYLuxz+S/rM8mhvmLVvMXxqNU+fHn0K+cWmNe9bKVXDF7A5QesNO/LUjwpTayfw3p+RWTQV6vNny4SdJGWnT51RIhqJQUwC+3+bgW6VgjVKdZtJ+In45kDgC9b1SiI6VcvMRCZiijKxwDguk4tqbCCPCroGlIoSZo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > Youngjun is working on swap tiers. At the moment he is more interested in
> > > allowing a specific swap device to a memcg or not. I can imagine in future there
> > > will be use-cases where there will be a need to demote data on higher tier swap
> > > to lower tier swap. What would be the appropriate interface?
> > >
> > > BTW does zswap folks think of zswap as a top swap tier or something different?
> >
> > I haven't been following the swap tiers work closely, but personally I
> > do think of zswap as a top swap tier.
>
> Same for me though I imagine swap tiers would introduce some duplication i.e.
> different way (interface) to set limits for swap tiers for a given memcg.
>
> > Things will probably get more
> > blurry with memory tiers and compressed memory nodes though.
>
> I think there will still be distinction between byte addressable and fault on
> access devices.

Yeah, I think it makes sense to define "swap" as fault on access
(zswap, SSD, etc), and memory tiers as byte-addressable (even if you
put an SSD behind CXL and make it byte-addressable). But I also
remember seeing discussions about unifying memory tiers and swap in a
way, and it makes sense from a reclaim perspective (swap or demote
first?).

