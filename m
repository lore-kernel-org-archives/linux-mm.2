Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 309E0CD5BB4
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:53:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92D076B00C1; Fri, 22 May 2026 11:53:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DCFD6B00C3; Fri, 22 May 2026 11:53:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756EB6B00C4; Fri, 22 May 2026 11:53:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5CE4B6B00C1
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:53:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1EB5AC2671
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:53:22 +0000 (UTC)
X-FDA: 84795500244.25.5DAF1EB
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4823F180008
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:53:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MuXsjjQg;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779465200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AwTt7VfN0tnXd1ZqN8u19c+a+Qxdue+k49zPjLSV3ZY=;
	b=JVh2IDA/ZLgwmpS26GIAUbIt5/xJkrpNf1UMSicnQZU1HiLe6yc58pYF5dwDMjbS5kjnsD
	WFGt6nDiHrClZsSoqL6pztEOBEkusZRlWEw51MibxrEjCpdPCsx2JO2JbhO6gMPgyV9lv+
	E/0IF65sWlhy6QPj6eYNdxTJLP5ADlQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MuXsjjQg;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779465200; a=rsa-sha256;
	cv=none;
	b=IlynVWnweHVzs9s5vA48BtnwokPj/3gNS8eJE1ubeYFTYMZAXpR0OC1xyfqe1CPP0CS23a
	zPP3++WkkmZEDLD7QQw0IrjUvDrB4TjnzKBQ8x2OpwKYls7d6yefiKJa6qZqMEwLp1b8R9
	bCTphK/8RTv/thXuWJOoOVAt4ep82Xs=
Date: Fri, 22 May 2026 08:53:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779465198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AwTt7VfN0tnXd1ZqN8u19c+a+Qxdue+k49zPjLSV3ZY=;
	b=MuXsjjQgauUbq6p7cS5X7gF5Z6HEZ2T6QHo3Z+tfEZAPeGfOfiun15kqxaardGLnl0Zz4b
	mTHGPWLoISi8nc4sgxwqejS7QzEnX572JGU6D0A9CSPWg7wtkhV/8dnteZkKgY77lgztYK
	TMV+2hhiahKs40JSX0J9m6xncftzo8k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Eric Chanudet <echanude@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Maarten Lankhorst <dev@lankhorst.se>, 
	Maxime Ripard <mripard@kernel.org>, Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
	Dave Airlie <airlied@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/memcontrol: add dmem charge/uncharge functions
Message-ID: <ahB7pCu_G4vuswc0@linux.dev>
References: <20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com>
 <20260519-cgroup-dmem-memcg-double-charge-v2-1-db4d1407062b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519-cgroup-dmem-memcg-double-charge-v2-1-db4d1407062b@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4823F180008
X-Rspam-User: 
X-Stat-Signature: otjeseuay6exwm64wi3ojrqqmqah9474
X-HE-Tag: 1779465200-909836
X-HE-Meta: U2FsdGVkX19xNzRo/yGuQH+3n7z8yC9YAuux4r09WE0rcEi64YRamsurrOQ1WfU77D0yZWLjnVjAk/BSF3X2eJfTqtw61D/OB4dM7wdKcK5BmSp+1BvFaqGCu6lTloAoQ88aX2myo9cmH3V2zoXh9UUtQmIJmp4VW2yy7KAArpEBhJJqx9jBFLZybpl0cD1lwV6psk+bVYQsOVSRoAQmGOC11OGchfwtANkkkSsDEKmPrVmZCtrTZPKtlHpZuAap1zE35ayxEWtM+J6BoeFL5tAkm+3xnEVQp1+yVvwjLQrJeVHdBH89oGaBH3bhZYC3dIPCD2xIDxEEQi4fxEvYk3zj5NXdJK+Bu/Ps2CIun7RgmRPEfUBbbON3xIt0yzX1dBU7v/3dQlRcO6tr9kmIQZdz6k4b4YHAAL8PvAxgzihkm3l8myuWEKHaCwil719iqC+o0ZQwmV6kdGrgnkfQi/5C7Nqt7O/8PXjzfUFoabt789M0igfC+5Wuu1j6GTWflv98UMX5vnTeTFyi817MxTS40kgVv6MkTSlJSYNOUg9Uqladr+D9D15XxfKnAE6IPdR8Wz1g42ZiYqdeFjqgYHdyCVBehv0avGWBM6Dsb4khS6/XEhWmCwrP2MDtoEt4Gnd9beTFwZ3AZVvpg/AiODNtM28kLdt1m7e8HyGTNt12E3/Fu8Et7oyKYK2trw0J+8o+WJrUhdsc8nFHY6YK/dih55zRlGLt9ln/kACbapzzHQ75edZ/llUo+zUjsP4T3+9Yf9XFQcd4uaHiLDWx1EXVH7YvnxitbnW2J8uHnh/NMXyJKeBXEFg4kZytn5MFUQu8LFjkZ5H+mGWO83jSVOMoHvhMJOB1nLeohWdBWcHt8wZ2u2/VD4YKxNKR0kEoUev2tk56MKfv5VN0LPfxl8diQfBMtx3YoBmviAlV4MNrKyRcGG7OUByZzm4KfPqSCrjfdLl88L9gJgdB1qQ
 y1dxZOB1
 pJTLeV7xTCvE5y944Id7WPbqUK+DoT5n35AOvhqwEpAusygapgigtrur/U36Gy2Hdkv2oHv8lBwnHjc66worBh8g9MvGLlIY4Hzv0DUaENh3GD7KSZdfu4K5DqjnTFMYUUKXtbninT8GaL0rKxaj14ZvSP9ygUTl5WMXzryqVG9GddAJJEMKJGyffb6b2ab9nOl9HA5RS1EBetWAwRnwDNOuThw2m/C22pvMR9n0JS4PUtnM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 11:59:01AM -0400, Eric Chanudet wrote:
> Add mem_cgroup_dmem_charge() and mem_cgroup_dmem_uncharge() to allow
> dmem pool allocations to optionally be double-charged against the memory
> controller. Take the struct cgroup from the dmem pool's css as there is
> no convenient object exported to represent these allocations. These will
> resolve the effective memory css from that cgroup and perform the
> charge.
> 
> Introduce a MEMCG_DMEM stat counter to memory.stat to make the cgroup's
> dmem charge visible.
> 
> Signed-off-by: Eric Chanudet <echanude@redhat.com>
> ---
>  include/linux/memcontrol.h | 16 ++++++++++++
>  mm/memcontrol.c            | 65 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 81 insertions(+)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index dc3fa687759b45748b2acee6d7f43da325eb50c1..8e1d49b87fb64e6114f3eb920293e14920290fe7 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -39,6 +39,7 @@ enum memcg_stat_item {
>  	MEMCG_ZSWAP_B,
>  	MEMCG_ZSWAPPED,
>  	MEMCG_ZSWAP_INCOMP,
> +	MEMCG_DMEM,
>  	MEMCG_NR_STAT,
>  };
>  
> @@ -1872,6 +1873,21 @@ static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
>  }
>  #endif
>  
> +#if defined(CONFIG_MEMCG) && defined(CONFIG_CGROUP_DMEM)
> +bool mem_cgroup_dmem_charge(struct cgroup *cgrp, unsigned int nr_pages,
> +			    gfp_t gfp_mask);
> +void mem_cgroup_dmem_uncharge(struct cgroup *cgrp, unsigned int nr_pages);
> +#else
> +static inline bool mem_cgroup_dmem_charge(struct cgroup *cgrp,
> +					  unsigned int nr_pages, gfp_t gfp_mask)

Please follow Johannes's request to pass the actually memory object instead of
naked numbers.


