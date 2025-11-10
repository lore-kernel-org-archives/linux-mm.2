Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4EDFCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F099B8E0035; Mon, 10 Nov 2025 11:48:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBA268E0003; Mon, 10 Nov 2025 11:48:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7418E0035; Mon, 10 Nov 2025 11:48:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D05948E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:48:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 956371A0172
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:48:09 +0000 (UTC)
X-FDA: 84095279898.04.029AF51
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf06.hostedemail.com (Postfix) with ESMTP id BDB0B180005
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:48:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Op1P68AK;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762793287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xd3QhG39y54BYRm7BE+GdV6fPsrzgc5k/otRLVZG40Q=;
	b=arQGAbn5RrbvDwQocsapbosjzowO7NTTX0mJEubKfx9Pz8Lh+On4JjFXdyoVkMNaDWa2Nb
	fBZWQHWa7biSDMQKNT6RO9Y4QIaX8XsM8UBU94Sm723V8rHV1mS1e6xrPUqFHVV4p3bukL
	O6y9RGUvMDYOqgcN6IzJnI5v36dq+5I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762793287; a=rsa-sha256;
	cv=none;
	b=vf9TWCvl7Y8uL4qlV3pX49wh/+2jVnWChuRNcJtj7u/YTrBPtFRAEoVN8BXKu7wRPGpldc
	oobzjHVWaTVOBQfpvvYlBZndykXtwBOgRjFDcUv7wrCQhxHJACTkSWXhCTomLaGLFsQ49P
	1ZTGDPxAxfZaXzr+Lt5t3Wc7pXF7OU4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Op1P68AK;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 10 Nov 2025 08:47:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762793285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xd3QhG39y54BYRm7BE+GdV6fPsrzgc5k/otRLVZG40Q=;
	b=Op1P68AKP718zvoxiL1HqKGS4nBheJkeq7JhxPVCOxpu8rVb2yLWW0mPcsf8NnNVNKG7gx
	61esQYqXGExt2UH/pe2AHZyPCmZmyZu2DROK3PSsjbECpfaOfWaNKDCsLjMQS2xsYBb3O2
	pPuA297SZhouAMdmqFt+sgt8zY8Z7Fo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
Message-ID: <aqdvjyzfk6vpespzcszfkmx522iy7hvddefcjgusrysglpdykt@uqedtngotzmy>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <97ea4728568459f501ddcab6c378c29064630bb9.1761658310.git.zhengqi.arch@bytedance.com>
 <aQ1_f_6KPRZknUGS@harry>
 <366385a3-ed0e-440b-a08b-9cf14165ee8f@linux.dev>
 <aQ3yLER4C4jY70BH@harry>
 <hfutmuh4g5jtmrgeemq2aqr2tvxz6mnqaxo5l5vddqnjasyagi@gcscu5khrjxm>
 <aRFKY5VGEujVOqBc@hyeyoo>
 <2a68bddf-e6e6-4960-b5bc-1a39d747ea9b@linux.dev>
 <aRF7eYlBKmG3hEFF@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRF7eYlBKmG3hEFF@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BDB0B180005
X-Stat-Signature: ip7nmn416h13457i6saa5nto9do8qny3
X-Rspam-User: 
X-HE-Tag: 1762793287-30346
X-HE-Meta: U2FsdGVkX19+Vy2Rl032As/NJXxBD5kS/mNQBD10/RNoH80TDilXLwYEIt1zEBli6DzPSI1IA23gUNOyKqvUtYSzYpx5HyracxvmOwg+cDl3+9kxucjXzF/IDtd5VDodbsUb4I9KmcpM6RdtTYPSpn4PrPB6VuCDaMgx2slP1ASWW6+w3xb36hCOknOqIbqGI3pavZ/f7YjiSzsGOxwZuYL5BeNyUpXMeqqlkI5Az53sZk+aFjSln4Hy6VivNd1FOAhZ7nEfp5cHAnHt2zq1+IFeKXsRC35rA9GkxrKijkMITYK53AtP2cTQEZWBp8s1Badpo3DRkcNVeizGWFpQDqGZ/Jx2ZP871wxjAqwmxDvrqqv/dK+L6lgKFKzlarosKS2xJ7eNFjohOxUeb2hky4Eh3LkuDU5sqUHE58tpjyEIhHH3zJnMKENc8hOpgLvOJZJiWWg0TJ9ogd/mebZs3ygshyWK/svR7Vp1IU/UvDPpd3AxVX4psJpAerTUsrNz5ORhOhC/ELxOHAuMGgQNVRkHisUyrK/mUoKyTR+J2T0UVqX/t0wX3pusfjOJPs9ipApb6PrT4KNUU329zaAYcj9mXICjkI0vWTaRCgBNKOZG5/tb6Z1mGjmsydqWCH4NuOpL7Nx3sYNOiqImjyS01LAh/IMUDzrT6jFwiHhC1cOt2rJI/MVVB4SBlDdSmF6uRnxqsd446bWSYnzNUMZj857wnVx598mqs8W6r5/C9y5yX2wmtPuqqgZdGm9K5EF0zXEoyImgTSYDDu9UtosB3dEsbVN5Q8IHoq7d+WR1SEUovkhvUtUNwQ1g2JSkQM99iUTzRD1gXAD2gBQz2c4VPethMUlO1+Nmjf17fW/nE4xZ2YnLq5UJRR2gM4ufQudAx/sYaZBbSG69nsJML8f7Frip2nGGSNzOI0t9160XT7onDaVibS+rHFALudGfSlj2qajAKGXQjvfo9Z/v7SA
 oJfdwuCf
 0kZdJ1ONJK0PPpPNNw+ZXa2OHYoqwSM/Fm7Ugl0cUaZeHxjT92EDeNl4AA55sr1TXuvIMR4jrAmYjwTsBiE7gg21yc48ek5ADbclkfsl8ySbeyWMT+17EYmDoM/y8/4Wya9/elTIGs4ckkSTsTUvlOPoYo1fk2s8uBN7VWpurkhSzYTvIOtydiUOmcEPtCQZugWmFameffTw/xzXuwmC8rQmoGczpqNuSLH8tnf+hgaSIGFI5dbo/e/++POWun0sRfUat
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 02:43:21PM +0900, Harry Yoo wrote:
> On Mon, Nov 10, 2025 at 12:30:06PM +0800, Qi Zheng wrote:
> > > Maybe we could make it safe against re-entrant IRQ handlers by using
> > > read-modify-write operations?
> > 
> > Isn't it because of the RMW operation that we need to use IRQ to
> > guarantee atomicity? Or have I misunderstood something?
> 
> I meant using atomic operations instead of disabling IRQs, like, by
> using this_cpu_add() or cmpxchg() instead.

We already have mod_node_page_state() which is safe from IRQs and is
optimized to not disable IRQs for archs with HAVE_CMPXCHG_LOCAL which
includes x86 and arm64.

Let me send the patch to cleanup the memcg code which uses
__mod_node_page_state.

