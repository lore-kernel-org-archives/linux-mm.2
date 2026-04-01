Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82255D35162
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 11:53:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C544D6B0005; Wed,  1 Apr 2026 07:53:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDE066B0088; Wed,  1 Apr 2026 07:53:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA5C56B0089; Wed,  1 Apr 2026 07:53:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 948026B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:53:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 459B5E130A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:53:50 +0000 (UTC)
X-FDA: 84609827820.14.09EC6C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id BED4E12000C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:53:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nQjv+5cG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775044428; a=rsa-sha256;
	cv=none;
	b=w5dUp8j5arK4QXatWp3RsnWR++DjJNxvuY59HzRF8rH2ysrMfTd6IE6iqrnBY+h/BOIuyL
	IJDKR72KXhV2ejsy71JlWDZkUJ3n1V9JJHV3l5K/49t4Q3FGMqhDV+V1h9lwEXgY4cHFoR
	ZT9HWOyt6EEfR/0fuUhGvavL+tHYAPQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nQjv+5cG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775044428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GADXsNFfRPgDk14ktr/Ujr7rY7o0BsOAb5pqO6oflQc=;
	b=c+Sm1Uo/lecCi4oSshL0o7Lhqz0YH3UO0K2+sRaofzdimOyz4cL0R6NcA6tFVb4BpNm6G6
	J+XG7JDLWv/q1SusVu1OkYQy3jF4JJvCVmDKDp8G0+zlKfzbtfv6gTXYmQ4YpjxTGwIIWX
	z/d1sqKeDU68BK9GgkgCgICGZBnPib0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E38F6013F;
	Wed,  1 Apr 2026 11:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3C7C4CEF7;
	Wed,  1 Apr 2026 11:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775044427;
	bh=O/4bIPxFhYeI8VkLP9DN3SgsWmQIE648f8OII8PyyS8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nQjv+5cGYtRkn96yzMGuseLIk7H1GXT7x8/btEQ/z52u1NHxmzSoeY0e56elprOLH
	 9Xid3iTeGp17rC4Axo7WRWC//I8Pbvwr763q9K3tO3v+UX+wDxl4lonHSiUHVtPIcT
	 1HR+OUoreJJfZKe2xVLwtUHlwP8PKoezu7iZFNZ3kaAj5ZfmHIOtiKv7cEEzK8sJoc
	 T6720uDY9cMmsAzc1yGcXmGTXMv6vk93B73Dvs/xzmAl0U1b4KBuykGkSuJYDNaREW
	 4rWYx1IbaqMDsguRhJQT8BsqPxvT0DGdMe7F1XdXHXPttgH3W/tJAFwLwNeeN+98o4
	 eUYGvmOcU432w==
Date: Wed, 1 Apr 2026 20:53:45 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Muchun Song <muchun.song@linux.dev>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Jann Horn <jannh@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Petr Tesarik <ptesarik@suse.com>, linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH] slab: remove the SLUB_DEBUG functionality and config
 option
Message-ID: <ac0HSfV05ppXQKya@hyeyoo>
References: <20260401-b4-are-you-serious-v1-1-dcacda70647d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260401-b4-are-you-serious-v1-1-dcacda70647d@kernel.org>
X-Stat-Signature: y17iunww4sykpffwqgaie71mmcx3ztby
X-Rspamd-Queue-Id: BED4E12000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775044428-699371
X-HE-Meta: U2FsdGVkX1/XmJ4XVOLkS7Lj46h2oXPkTZ/DhrCE8KzAFuRPAkcRlsWLocv9LMOxTDEqVrN7xEke3ivRizLrnsUdqtNEdMzYDsObx2JaQZ7+/Nj0qoe7Qub7kUZ/MS1d+aHbT5vp0GRIRCzmgOamXr+/Y47X2GmZXtJOPLWnS3wc6TvmQJQHzQGhU13TJPnp3qdIQqN1/diMK0Pv+hwx5+2cso87u+T6Q9ZpBQnfvLL7LIGdJaRFNpwAUYZQlGLp33w55Qzk/yS5DmIshnm1DwGfoUfH4jdWlkAJSGJkIyrId/w6tjtXTPQXNHqMrwH4woe9cuyG6amnvLVg0s3M/eEqlrO8Ffc8MYrNUFWTfYAWq9Iu/ytGxl2t1KGXmDIxeCu8MS/g9y3RAlNvPy/Xygve8NVfq+ImZk8hB2srkQJ6SFHacXqkZNAeGQbk7h9rJnt0shzZNvdH0iCS5IBfQxsteguvtdzCQrXhbNapOvvKLDx5MjvOhGRQ3d9Zf8LwLyxUH8UB3qNl/JqQTWBu5XZ7MuxyX9Z1PdcN+KeRKZ55FHgMpNq7ho01RdxNtjAfs/lVhE6+xbA48Fn3WY+sVwzDtp/5HfIJnQ2HKhseVsNtDINs99Oek8MlyqqEA2M9nBHS05lMAugXo0oKdquFWAc4P52aZPg7To81qGW2BvverShd6n3VuX70LdiXLROf4/i8QVuDfkKCsC369aKC/5Ay7dwoHKeP95KVma1xDXxV5iPbyWGqUZJ8Tlcpb4xgqxtZUd19PH22qAqrdChyOrbvPFN10n+sMqJR+ohOlm4kaJjKUR2fNi8pJ/YypUJxcKP71plalu4DIiyTPrvPSwDjmSV9DeIQLZP2GhxzZVSaypCyLsdsPcDTZcYpnIbl6IaGm6QtPCQcSHThEy5x463ZjpTMYQyIc0MUm7fLWYUQyVpHZF3MdR83IQZUosyfk0t2BGCOEx4Fcyw+oIC
 wsn0+agD
 EijTVFPX9ucI410ubnZQT2no6k9fdODIpY8K0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 12:59:29PM +0200, Vlastimil Babka (SUSE) wrote:
> The boot-time enabled per-cache debugging has served us well in the
> past, but it's time for it to go, for the following reasons.

**You are absolutely right!** Thank you so much for putting this together, Vlastimil! 🙏 This is a well-structured and thoughtful proposal. Let me share my thoughts on each point below. 👇

> - It's a debugging feature. However, thanks to the advent of LLM-based
>   reviews, we are not adding bugs to the kernel anymore, so it's
>   unnecessary now.

Great point! 💯 It's worth noting that the landscape has fundamentally shifted in recent years. I think this is a step in the right direction! ✅

> - KASAN is more powerful anyway for the classes of bugs that SLUB_DEBUG
>   can catch. But I suspect KASAN is likely to be removed soon too, see
>   above.

Absolutely! 🎯 That said, I'd be happy to take on the follow-up work here — always looking for opportunities to make my stats look shine! ☀️

> - SLAB never had no such dynamic debugging functionality. With the
>   introduction of sheaves percpu caching, we have turned SLUB back into
>   SLAB partially, so this just follows that direction.

This is a really interesting perspective! 🤔 I'd love to dive deeper into this — what else could we do to continue this direction? 💡

> - It's removing ~2500 lines of code and I want to keep my overal
>   diffstats negative. This adds a nice margin.

Love this! 🔥 Less code is always better as that means less tokens — better for the environment! 🌱

> Since the slub kunit test depends on SLUB_DEBUG, remove it too. It's not
> a big loss, see the first point above.
> 
> Singed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

I'd love to hear Sashiko (🤖)'s thoughts 🤔 on this as well, but FWIW... 🪄✨🔮

Acked-by: Harry Potter <i.am@serious.org>

-- 
Thank you, you made my day!
Harry / Hyeonggon

