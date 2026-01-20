Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B549D2ECE9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 12:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39136B03DE; Tue, 20 Jan 2026 07:30:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F111A6B03E0; Tue, 20 Jan 2026 07:30:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47906B03E1; Tue, 20 Jan 2026 07:30:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CF7446B03DE
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:30:19 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7735C1404E0
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:30:19 +0000 (UTC)
X-FDA: 84352274958.18.57EC697
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8C2544000B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:30:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NI327+VQ;
	spf=pass (imf01.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768912217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U0l4DlrcsAB29u1FZ8RfgxXvBj6CMA+nJmNa7xiJio4=;
	b=CxNwE1SNe9hUg+cW2RgadL9S4DuKJaZW7oriGldUEb5ivebcXTCdacL4lxu1Z49YDSR+KZ
	RQPElw1cnl2Z7jSba0r5lYhhcHpaM8pFg5eXjjdz7tukv80jS+uloh4UA/Y3p32Xjll6/s
	XtEtONQa5ID2O9S/nN6zycaqm5D5gfk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768912217; a=rsa-sha256;
	cv=none;
	b=jXQNjvHzayqUVy8QPzsD1SF9CSJx3MzxjStKLkc+rFW3022cLHYO8DLLa0cSZqvg5JSBTd
	jgthKeoeV4yDp+gtBxK1Hc80yfL5EoukklSomtsZqU+n5QvpoAJ77hKYIMrzfDhHMywKqj
	fbRq5dxr4cGP2hPbWzP3eSTs6gKYTm4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NI327+VQ;
	spf=pass (imf01.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 20 Jan 2026 20:29:56 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768912213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U0l4DlrcsAB29u1FZ8RfgxXvBj6CMA+nJmNa7xiJio4=;
	b=NI327+VQJIHG1zdsqPYDP34eJKeq1vGM3Imfe1ya5cYV9LGeL4FNkuH5xbaO5h1Tle7MYg
	1SaP3y8IfLINQWehfNv+OPn1a19C/9NcyKahvpWb1Pi60s5n6vjTliZ/0U0hVwwe00fbbO
	1xrFwiCqzk9HWXoIAM5hvVr8G5ARbzc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 12/21] slab: remove the do_slab_free() fastpath
Message-ID: <yejhiw37av3o23z6s4oewlmhip3iqxxkkfcjp2jhlo4qf7nm23@hojkan5ym5cv>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-12-5595cb000772@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-12-5595cb000772@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8C2544000B
X-Rspam-User: 
X-Stat-Signature: 7htm58nn9xszbmbqwan4ibfhpt1xcuaf
X-HE-Tag: 1768912217-365084
X-HE-Meta: U2FsdGVkX1+RVjSpbsStoJimSxZhhkCTbv/B+L4Kibg73tYJwUB50FRPbqiymhvg5lB5at2pc8BO2C3BKAimgKR50YDj4Ik4RaEg78i2+IGw6d83RPe8lbSRMzOLjZF5iY0TmpqAjLY8eNRZljJ+Usop2DjKIJWLhg1KImlKrQBM/WjgZ1ob6ADfXusi/ubiQ0WOMhEr+qOstXm7yBZJNSPpuGGD8OnNcB8o/k1JLketjRtxNCMzNSNoRYVgSU2h2MkJZ8dZs+ViURUscw6uN1GZDP880F2PvImUFPLL1STBOE3HQ6k/Hb9ljFztzwCVq8zJzjm+uvqVzN/QzUPqn5+oSLKIXba59KdCzWqJciVBonstL+xRzbOImnqyhHdYVUCOGkBxt11EgmSYh0opWzURRTvKGLctMzEfaf5+nf+VAk0Sb7+uQJtu0WeRgTfp4gIaL4TL8wP4Qokz0M8oF73OFn4+MrVyDg4V6kBP7OMDvjfW6jU7nWSrebvgBzh7iBsLSAQshLC3ERefhEjDewMlrytAJU1uYJ869ZBDmH85RqXobHbqIYpiZNDihKWdGG6YhDbjQvk4v2/7KNkBOier9vShc+U+2cycBCizI/1fFidiYF4LYgBbVn6nAu6UrkR1crgxcEHx5oRMuwUUQRSYOJdV1MvfLp2dbZ13eyuAljozaceZ7EdR2Yl/yERtHPbM5OSpf2WoLy7cX6MmNiGuu2phfNHQqS4CPongWiFbhLVLxpuWBWTr1sBrjAWWyqMV5eipkJkiGN70wdao7hlHcZpeLFrcchtYpobmKnToT2F6aSttRReuYn9GuMKlDqXJDYTQEh5Da3QoWNeC30vxBKo/pzY5tTZ+SgS0N6sqIODmU+8Fsm2Rz/P1Dj69CF6l44rzb/jFZ82kz5niRB5aOWTEEa7rekY4H3Od41Kl38t/Dm9uxfgjGcKBS69lETK6HKoyyK9cFc8m9NM
 wJS0CTTJ
 bCgQ210BPf4wtE2fJVgGEg+eQLSQGkZm3xPzQghyfn+0X+aFQNIwRmstkArbpOoA2KWvvV3TKQr5a/NBBBGM+CJQJSOqbR4CK0+9XQRAJEWHyYTtCCOhhsKVP6B5lOQ09Eb2dM18UImbBjOI7mdfPLmBnsCSKeDsHcEcabb1vU3y154UvPTjxr+qe7Ze4kJVejDaezGvZKRpqVtdXEGYucjsE6mfgPBa52E4hFx0RQJjv1msGzJ4sU4Ko1nALUO8GDoFeEmjCSHHc+QIVkUCTa+ywTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:32PM +0100, Vlastimil Babka wrote:
> We have removed cpu slab usage from allocation paths. Now remove
> do_slab_free() which was freeing objects to the cpu slab when
> the object belonged to it. Instead call __slab_free() directly,
> which was previously the fallback.
> 
> This simplifies kfree_nolock() - when freeing to percpu sheaf
> fails, we can call defer_free() directly.
> 
> Also remove functions that became unused.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 149 ++++++--------------------------------------------------------
>  1 file changed, 13 insertions(+), 136 deletions(-)
> 

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

