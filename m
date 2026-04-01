Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99EE5D35171
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 11:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C57A6B0089; Wed,  1 Apr 2026 07:08:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09CCB6B008A; Wed,  1 Apr 2026 07:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF47B6B0092; Wed,  1 Apr 2026 07:08:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCD2B6B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:08:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D1AD13BACF
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:08:14 +0000 (UTC)
X-FDA: 84609712908.24.CB1E047
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4A89D40006
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:08:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Lm1/Oucy";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EZIpCN9Y;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q3ydXVuF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=INUdjBYh;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775041692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gyTjX+7gYFGs/V0ReF4YKYRShc/UaAx67M+99AWTHXg=;
	b=E9tBRNgI8qmgrff0VcUb8bXRwBljg7z6qe8+icfIMCxhW7bBFHwu2gMuUxY/Tpi5sPHiMx
	xqyxI/rgi/zmxwJ6H09u6EA6mK4O/D6RMNRbh0JOIvVF6fzp1CGo2e/5HTI3HHJH9/LlNV
	5AfEjunPHmkE2RT6f26fFa6is8589qY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Lm1/Oucy";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EZIpCN9Y;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q3ydXVuF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=INUdjBYh;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775041692; a=rsa-sha256;
	cv=none;
	b=P6/KPINxQUoGx0QpCgG0gityRy5oRB2IFoH6kC5wR1fNI+mzaTq6eDrEOZKTK+EKTh1K5d
	0qx+qWpMOp/jXvi5r7N9gnEo2w4GIZiIYtGsyZF4mBIkTGkfhf9zwPKtVRWx01FbAtbWhi
	11zydpDLdKigWjBCNiOJ3iMyfmWJr8Q=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 68DBD5BD9B;
	Wed,  1 Apr 2026 11:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775041689; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gyTjX+7gYFGs/V0ReF4YKYRShc/UaAx67M+99AWTHXg=;
	b=Lm1/OucyVPxvlpIQSHxeZ947XENpxtQcrAJMPYNwo0OqfFUO2LLVvYjgeOoo3CK3spVh/h
	3keGC+MCrp3EVKI3Y8DRfxGKzdloMVSZy3DXu16AP2OBlxzXvTdWgcXrbxbVkjWytIUPc9
	svJPxLATcfPQ73QtX75AY4zobDjaJ+E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775041689;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gyTjX+7gYFGs/V0ReF4YKYRShc/UaAx67M+99AWTHXg=;
	b=EZIpCN9YL7pYI06K2vgVPcVWxoXWOAb8I6kfU+P+anC7WiLahUBYKqRP2PActbHiQbglA/
	m85o2xRw81mMUICw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775041688; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gyTjX+7gYFGs/V0ReF4YKYRShc/UaAx67M+99AWTHXg=;
	b=q3ydXVuFVxfH8iEkkfH8BtFtNcXz63n4VgJmlyPpSpUOxGHACUrfdme9DuvfTMHWOKu/PL
	ze1ks8WiQEWqah46R37DHTlN1qtlf8V/sP8LYw1GXCQRqp/M6rfOX8SCA4L+sghn7zEPFN
	4oFT42Xh3KjZoCEYjhnHh+2pw+jVOSQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775041688;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gyTjX+7gYFGs/V0ReF4YKYRShc/UaAx67M+99AWTHXg=;
	b=INUdjBYh8tlcTC4rUTQza3BTc0IwPuKHOjU3huRK9bSLq8naJWkk7te6DcxkJQBYXYDSvn
	wvkjrT5rKA5RBtAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A78104A0B0;
	Wed,  1 Apr 2026 11:08:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Sm16JZb8zGnULwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 01 Apr 2026 11:08:06 +0000
Date: Wed, 1 Apr 2026 12:08:05 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Harry Yoo <harry@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Muchun Song <muchun.song@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Petr Tesarik <ptesarik@suse.com>, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] slab: remove the SLUB_DEBUG functionality and config
 option
Message-ID: <vjwodyrd7h72xutanjmgeriu37gwp5ooqakimaifk33347ka7g@adlojotcd4j3>
References: <20260401-b4-are-you-serious-v1-1-dcacda70647d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401-b4-are-you-serious-v1-1-dcacda70647d@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A89D40006
X-Stat-Signature: j5qe65ey9hycsn11zfojzhr6efqqxuaj
X-Rspamd-Server: rspam06
X-HE-Tag: 1775041692-335911
X-HE-Meta: U2FsdGVkX18+T8Lc8QmEBGzVszGOVYPWkSJJSKmcuoYC23UjZR+aaS3wEhVAE+OgVLuoc15kVdEPLuwHTu/4QnXoIGRFL/LYxBokMrOMhpQN96lDkOwU1UjjtfFCb3aB2rbBAjTvDWDLd19h2mqubXDUathk8Amqkc47GBj5Wk5+I3E4t+GLAbtocS+5oT36FeUSf7i6kUcjEPCQKJ+FZJxwueFWbaK4+z8XRhwVkdpc/RIfnaIueQITNA+tkKe92DqCkIXeItRR4A2QPIcc9CnAVd5H89iv+rvWb74oeVYjJOQccLRxhxytjB1RScB4nlWfLL/lEHR260RIbtoKQmgKYcjqeTFn1b6mBY8PKd8252MftaoXNtDpESKD6f/uLjKb08zPyvWrmA3XaUPBq8rBQ/rLLS26XAVROO/qCAg2YYT5bMfNQmmblW0bfLar/UQZ+kDpUQ6ZfKiDtzRiG6saNJbgOyUCkua4v6heByoOqzOg27VGpJJWaviNtGeiZzoDQIBTwJDoHZFBv1Tm7/p2UaWzbRnwjAINfYHodLSElvW/e6PkeDtJH1yYsBAv0tAq8hJDaMT/VIstSNJVlXk07XGKK3vrtBrwfyIW7ZYxguYZnixcDtMx3GC4P8FptwdBL8Y6PtDSWEAyF4ubmwTAa4peYF8xm4m/hYF5tFvUG8UHoulQObmO/GQclvEXoGjAB4JYsmuv3fmxUCaRN8u6ukhDgMLC54psqwwVAZdkn1EcKLCwPrwSO+24TRJiOuz04grPar0qR1ylcnjiobjoqH0swral7UTtIXFf5gxPy5WVz2uMgh3eHfYzYN2FGDsWtcqiIYmWeFM7p0S8Fsqq9sFA8dpPk0PXycouFgXvp4oGMk0X+u7LnS9ph6yfDhlViBJsbbZuEmGjAJ90XJypbfCU7tUSwBhzNphPxABzKd9UqZS+dz2jcjI7WEWem1A1SO+nVwZoKGLT4zU
 TubZA0ue
 I/QKNlE+QCJgYFfwaPgdzkh4xD3asjqqmvK2DP2EKO/B/iaJZYzI7pDuXcqdAnyUmVDGJvKIHqUEn98fFqd4rZqQdeafuyDXz5fQGKeh7UEW8AYP1G2WNKUs25nN+PjmQnKx4B4w4MNn/yuA33EyRCOhDNBdRzHTvfml8mzVj5P48ELe9Lx7G0IcjzSOPCc5zFRGImAizIcg5oMBAjMpCnowFT406Ou3hHNP1EaAfhBG3RWmw2A0o+q9E868J628dByAIKPvKASGsC5cVXcAui8DmD5FxFgZ+kA44IHlfxYiWTUygQnfods04PxEp9NGKXTT+kiAkzBv6YKi+foD9YwZlveUWATakrTIPlnqbaRYkvsot3YKnIBgsXw6Uebp2Oiu2ecbCUEKAl8gSKIb9Qzxgxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 12:59:29PM +0200, Vlastimil Babka (SUSE) wrote:
> The boot-time enabled per-cache debugging has served us well in the
> past, but it's time for it to go, for the following reasons.
> 
> - It's a debugging feature. However, thanks to the advent of LLM-based
>   reviews, we are not adding bugs to the kernel anymore, so it's
>   unnecessary now.
> 
> - KASAN is more powerful anyway for the classes of bugs that SLUB_DEBUG
>   can catch. But I suspect KASAN is likely to be removed soon too, see
>   above.
> 
> - SLAB never had no such dynamic debugging functionality. With the
>   introduction of sheaves percpu caching, we have turned SLUB back into
>   SLAB partially, so this just follows that direction.
> 
> - It's removing ~2500 lines of code and I want to keep my overal
>   diffstats negative. This adds a nice margin.
> 
> Since the slub kunit test depends on SLUB_DEBUG, remove it too. It's not
> a big loss, see the first point above.

Did you check if there's a performance regression with this patch?

> 
> Singed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

LGTM, thanks

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

-- 
Pedro

