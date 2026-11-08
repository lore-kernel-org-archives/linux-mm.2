Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63BB1606A320
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 17:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FbgV3wVs
Received: by kanga.kvack.org (Postfix)
	id 4BE7E6B05B0; Sun,  8 Nov 2026 12:00:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4960D6B05B1; Sun,  8 Nov 2026 12:00:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B1956B05B2; Sun,  8 Nov 2026 12:00:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 163BF6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 12:00:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 963E1A80DA
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 17:00:15 +0000 (UTC)
X-FDA: 85412564790.22.9D21EDC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0B0D314000D
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 17:00:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FbgV3wVs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794157214;
	b=xDxvxmIcI3msjDSm5APNcIWJhkKaLnXMkALy9CZjTGYWZe0+ORUCdvK2JyFtLXFL/Fi8yw
	R6jpvStFgW1i4PH++uLO7cx2wUbUlEbe0DT1d1uIb7eSqbgPJtJCkHucCkmsqCUKGiB5ru
	o+2Topq5lh9lSevckW70AKRsqNYCxYw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794157214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cn29Cz409bAkUNu2nlc09QH3V1QgnP/zwgBADo3882E=;
	b=JCu9l7xPZ+zgq/pQxF+mBefthiqJLdcl/s+h+kjiaYC8GgpRrvljWcMYYMG5InuzKXayDI
	37Psr3cBjswcuyZnNovbQLY97mDza8MQ5o3+5Z/u9XWp+pJcpOadDUMQ/kplOGMmxcNqRx
	JS+L4zl26TIYDtgO8d815DA218+hTHs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FbgV3wVs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 725AC611A9;
	Sun,  8 Nov 2026 17:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A1D1F0089F;
	Sun,  8 Nov 2026 17:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794157213;
	bh=Cn29Cz409bAkUNu2nlc09QH3V1QgnP/zwgBADo3882E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FbgV3wVsZqo9w2ruVmy8VP2xJrKH6PVVF1CJzV0hBpuSGPDuVaZTvJqv+3/KgVK1E
	 GwIFHt80Cl8diJF4uGxipeEOrdoCYI01B26PI3JZzll56seXCbv1Rmogw2MAxtmTL9
	 sf53K+UkCoJGXPSUs5G8CqLU87xbFewtkQcsC+zCFi2349cpdk2WAja/4gvQ2K9lW8
	 cTkvwAM5VlV3QGG6zKNHGWJIZ0EQvEzeJa2wJZsqG1J7boGyWoCtWr+C0xQddg74FN
	 pLj88z6UjrCUNEUJOmwAlORhFochQSTEon3QbIPEcvjypUMRxoqTLfV2bdLM8KoLTh
	 ENe5yePI5pbYQ==
Date: Sun, 8 Nov 2026 17:00:11 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Conor Dooley <conor@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 05/10] mm, slab: rework KMALLOC_RECLAIM handling of
 SLUB_TINY
Message-ID: <avCo3RiQS4MN3nny@minisforum>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
 <20261105-slub_tiny_rework-v3-5-0484ce59eabb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-slub_tiny_rework-v3-5-0484ce59eabb@kernel.org>
X-Rspamd-Queue-Id: 0B0D314000D
X-Rspamd-Server: rspam12
X-Stat-Signature: 9dndnnnsbrmpieim6jxm4hxhrunnzn33
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794157213-809943
X-HE-Meta: U2FsdGVkX18yrKNu7qqmgorw0AsbcG5jsWkEw0d3T3UGygcHDbgmmYiE/G0ax4KQiNqL0CdBIk04SXNnejPZJnisbID++K1IyN7QHysgwhsftl6n5bjnHgS/zYNDr51HigyzdQrFu0ZE9+ssLU5WLfqe9rmgQFFx/Mi72BXCXcmMTaLHXdgACszfL7XjDrOBcwM+m1r9utfLQDAIam3qLZaGjGMcC8oI5mgRgLfe5ZrO0wkvZVCyMiMDygAVkAG/BCS/C9DB0HzDO252Yn1tZ0Cwr0eJN3jffP7Q3RRtjmeu2NoWna1n4+LQOjXgrolzKUItgoKpOFnNlNA9QRdr7WAbLcGd219F5w/aJaqhjZOlWBjjl+yddjLeJzWT+vq/155QktgNB4gIj15DwtBdoXR8NL8XdhMAnQpBtTxS/7VPSKNZuaBlX3D/FYXvBHfTYMA4OO5FN6v3WKTNv5bTfTWvWzu1ggWgFFNJorC71KtIKzXreSIfGdA+jneWMQs6cYnEoi4bhJxfENOiF0ri5g23LUTKqedqQsa+vwux56EdMvUnwBDMSmiyu6ykxoLiUhXvVPPQzIpsOQA93ZnKTtW0WCZiKUUpm0VZlKSFRizGFo9k8MuKLGWPHWBU8cS/twDbN/c4opzYAavhyqQuVPp5RLPMxvXv2qpT3yxSUc9SmIsKdQ5im+uZwChD/YAA9Br92ezX9+Z54EbnWy/auQRaEVe6bcnrOXSAMwMuC44dqk0/PUje+aMrzZglGRD+kAgNjevVNcxH2HdhX0sTlUfgfNVDgPa6yRGvj8Imkxx6lAI2ViJ5OEgiCRdJrpLwn97XJ+DsJLIAfseItxbg9z5ydkeFCNnueTpZhQJXBbh5xVmqAc3ZKyWfU0SuN/4U7CrNXgcgjpEJrxNNQH3/JZq3EslcGb5UXKpYmy4SdT4n4eXWLnkxN6nqG+cuat/ofkDz0Wpq539gMeAeijq
 aORE360M
 9boKynwNbmL7YeppfoySeHVQekG8guvqgHNstHEXGh1bAYTN0EFrdFRCpgoFqFFglC//wIKCQRLdXsb4ElfGh5S1ohuqbC3Qs7DCI43AD+Le2ehO5AHGkXBGp49N84SWX1WyoB7ogZHMECHBamqdn14xt5N3ltx6q8Q+BUxqQXmJhoeMvhIvXo/VBP7zenTkFXiiocOJ3P/3KE8xWQwN4YzK8/UrpTu6gf7RD6nU6n5d4+uQi9ogR/I5V60U2XKa/wBRJjFSwH1iZWuZkjiMloFRilyRSOuV6QpByDDXWCCRtnUX+0lcu0YybHj69TXTwSN8buHcVQkAQS3AX96WGKY/JjOeBvrvEHGfF5mibn4fvMz0hoYf65uFyfg58Y38KS8lc7uHx+vwibziwGjNXjXDVhqoFjQ4q/CXm66bP5fxlB3CRQne/nGnyaTWdp1TV9xVF4i2agyiwn2meuZqvpEUEigwguIzDgF3oNTb0EH7lNE8BEFaqL2wmc7yq6lfPYKLO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 09:43:54AM +0100, Vlastimil Babka (SUSE) wrote:
> One (relatively minor) aspect of CONFIG_SLUB_TINY is the assumption that
> letting reclaimable and non-reclaimable caches merge will save more
> memory, which is more important on small systems than the page allocator
> level fragmentation (where distinguishing reclaimable slabs should
> help).
> 
> For now that has been achieved by #ifdefs that result in making the
> SLAB_RECLAIM_ACCOUNT no-op and aliasing KMALLOC_RECLAIM to
> KMALLOC_NORMAL on the enum values level.
> 
> With the goal of converting CONFIG_SLUB_TINY to a boot-time decision,
> rework this so that SLAB_RECLAIM_ACCOUNT and KMALLOC_RECLAIM are
> distinctly defined always.

Nice!

> Now, creation of kmalloc-rcl caches is
> avoided by assigning a pointer to the normal kmalloc cache on the
> kmalloc_caches array level.
> 
> To prepare disconnecting of this boot-time decision (and the evaluation
> of the need for kmalloc_no_objext) from CONFIG_SLUB_TINY, introduce a
> slub_tiny_enabled variable that's initialized to the CONFIG_SLUB_TINY
> state.
> 
> There is one minor functional change for CONFIG_SLUB_TINY=y. Since
> SLAB_RECLAIM_ACCOUNT is not 0 anymore, caches that differ only in that
> flag will stop being mergeable. If that turns out to have a noticeable
> impact on memory footprint, we can adjust the merging decisions to
> ignore SLAB_RECLAIM_ACCOUNT when slub_tiny_enabled is true.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

