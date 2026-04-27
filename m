Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD688FF8862
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 08:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CCC26B0005; Mon, 27 Apr 2026 04:13:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4CD6B0088; Mon, 27 Apr 2026 04:13:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0FF6B008A; Mon, 27 Apr 2026 04:13:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1B77D6B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 04:13:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B21511607C3
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:13:27 +0000 (UTC)
X-FDA: 84703621254.17.BE7038F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 19E081A000C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:13:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=seMxTGJN;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777277606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+LlbafF3EmC7ODCERbNe6jrsO190zmkzGMXWzcltIk=;
	b=ad4d6shWG4mfdz85KVQqtGI/6QR6X6/gSl3yQLfGZAOUaHColi1QfR7nVBY3MK3ecGpT5c
	arD+wvtk8cSLpAisLx+VYinu4bx+TSAaH3FiAcoCRM+xyYgWuJ2nRlzuTam2VvPYQQxrLZ
	rDClfVPwa2MHJcLUInAHsQEDC68gb3A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777277606; a=rsa-sha256;
	cv=none;
	b=A+5Y1VA0YoCx+zRCgwoaqb4fIqTxe17Po8AQ5esc2geAhs5gN7xZGEjTVMZBeugyrN/4lA
	MLpjDCyvRjfbqIGiLmPerzEQwdiUt11/PIn9qMUUBU7yI4PotfvODIsLlFaeMkl55jkHyx
	94pwgTOJE3A+JeGsTGWWfq/eqYKxGyE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=seMxTGJN;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4362760145;
	Mon, 27 Apr 2026 08:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980A0C19425;
	Mon, 27 Apr 2026 08:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777277605;
	bh=WmHusDz6RAwttLki4w/qj6U6yTjKSQFS4mC/99h4CTE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=seMxTGJN4uv6l+RdFXYx1uMxe4oufBuf9DmTpU6mefMKEkq+nUS6OyD2tYH7tZSaL
	 1vn27hcMwt7dXLXkBuElGqXmIzggyVJ6sdLXMnWiu/H6CE12CIjmUjzrmx0LtbjQmq
	 jI6yj6Ssost+fkqK/jzHRdUeyG6QZSTsWSohW5PyHVuHQpq0FKcSd41j00KlT+FWcx
	 7D24Iw8X+d33WTN9Fe0+BYDDpEp6Ouhn65cgeU/Q5uwPqJWAyTZOyvwtNEGazy6MAN
	 YUhOGaOVGw+W5rh4DGRABMMv/aiCeR4u9gTptrIF/+5l5aKNyptCW21EF6AMac48Yd
	 6hRJnhdAu3tGQ==
Date: Mon, 27 Apr 2026 17:13:22 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes v2 0/2] mm/page_alloc,slab: return NULL early
 from *_nolock() memory allocation APIs in NMI on UP
Message-ID: <ae8aojxbv4PHq_C3@desktop.tail10959e.ts.net>
References: <20260427-nolock-api-fix-v2-0-a6b83a92d9a4@kernel.org>
 <c3f7b8e4-85ae-4e80-bb02-a7b205cec88e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3f7b8e4-85ae-4e80-bb02-a7b205cec88e@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 19E081A000C
X-Stat-Signature: h5a1ij5nwmz7a7nbc9bidmt69uarkxz5
X-Rspam-User: 
X-HE-Tag: 1777277605-57924
X-HE-Meta: U2FsdGVkX1+L4ICIVh8roYmTbAItRtIWYyYIBQAJMhoYyhazDxwf89rK8zkVvYgVyGRNh6EwFSwOmoRWBkPl8kpJIBsud5o/lEWniUDTv1FdDpqPd8F1mOvrRs+FEVes1xJ6zh8wJ0olLM05+248JQRy8TMpD5gq8S9tOH6mECcgMQuKgqzlUOVY9uTl4/G3rQp8g5C0mU8Vuex+UlUJOh5oyWLEst9srKiG9lMx/8rsx/L0WB1xwHmq76vgeO51mpNQQmDC03oHEzjtOQEiimrzvo7M5it3KqCU7l79DJBFU5DweyMDg6Y0GMEnoj6RlM8bYONEjV1tm03NQnNn+Nnvp7TG/fiSve5XL92yaoK7LiapHwab3i96ju3bfch3adBZwmaL8ydsjCNesfSd1cHeUgvuLMo1ZarJi57YIy0UlVGegRJv68+f7EQ1AWc0+jjfY5tJ/SHykWFaxQz65wD5adNqpMe0MfEtibklsPpR8GTfxyQM12bIzbeZtOgOx/iMd69JGkT2GKFq7CdUmioQBW8mP8vqT/ST5BBgndji4yB5T57ab02/AOFMtteV6N11x5Fl2LOwdiDAw/gVP1bvln0IbTnvtUWt7UxSj1h8HrAkmQ++sXHVgTCfp2lci9j1+iUtmwSJRPQZGVnP/ULMtYiEJT3uACT51fgodrMIIRwk4UL3QaAQusOKolVs4SGBjxEwzIZ/CvmtiwJzw+DxFmb93DPNwfr4y89P0updKvWGK3RkUHy5+oMPQ4XXLOFfimijS32PjOzWBWWCBMbmBd41wNfHI0FUeMN/TnUR5PU3wsX1hTymYUVcasCOzubq7ltPYLpOrPD9/LYBgULTUWPJn+5x5myBc3EHgcEzEbPsz4Zm4Gc9TLVIh4QkXWQ1ig+jlWG2ixC4aJXwOUP5BPaRWH6qDtW+cfGgR1Hf0sEudJ4u/Ue/EsVYoMZ3Y6JVqc59aj4B3o4LuYM
 WsrMcbur
 MnEGhJW/0k2zNpAYs45xA4EOSC8qt1ztwzc3hMERwBKTypapWJw2aJ8ODBgzjFx2u/xdfhtGwEprPDms/5fnAfU63xSloM81/73ThZmbOZhP22gos6lULLlBh3HFpWm5IkvFzRKNQgVd89Ypa+eRK3GrYvS8FphxaYxcuyPSQD82au/ska358GaVGi5HOsfWqrY6+4ch0UIEOwISxVPfwUDPdcr0GjSt9kO6mL/8D45m6sRvDBBhy9KSc+7rtApwS+OCjLMwJ1/vJpbo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 10:00:16AM +0200, Vlastimil Babka (SUSE) wrote:
> On 4/27/26 09:09, Harry Yoo (Oracle) wrote:
> > Due to my mistake, V1 was sent twice w/o proper cover letter and
> > Cc: stable. Please ignore V1. Apologies for the noise. 
> > 
> > Changes since V1:
> > - used b4 to send patch series (w/ a proper cover letter) instead of
> >   my broken git send-email script (Thanks Vlastimil)
> > - added Cc: stable to patches 1 and 2
> > 
> > On UP kernels (!CONFIG_SMP), spin_trylock() is a no-op that
> > unconditionally succeeds even when the lock is already held.
> > As a result, alloc_frozen_pages_nolock() and kmalloc_nolock() called
> > from an NMI context can successfully re-acquire the lock that the
> > page/slab allocators are already holding (no deadlock because it's
> > trylock,  but leads to e.g., allocating the same page/object twice and
> > causing use-after-free).
> > 
> > It was discovered while testing the new kmalloc/kfree_nolock() test case
> > in the slub_kunit test module with CONFIG_DEBUG_SPINLOCK=y on a UP
> > kernel.
> > 
> > Patch 1 fixes alloc_frozen_pages_nolock() and
> > patch 2 fixes kmalloc_nolock().
> 
> Thanks. Given the problem exposed is in a slab kunit test I think it's
> better to handle this in the slab tree.

Ack, I'm fine either way.

> The page_alloc change is small and
> should not cause conflicts.

Right.

> So I've merged both in slab/for-next.

Thanks! (I see it's been added to slab/for-next-fixes)

-- 
Cheers,
Harry / Hyeonggon

