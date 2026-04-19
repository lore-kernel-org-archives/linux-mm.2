Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51942EA719B
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 13:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A97D76B0309; Sun, 19 Apr 2026 09:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48E06B030A; Sun, 19 Apr 2026 09:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911206B030B; Sun, 19 Apr 2026 09:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8E96B0309
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 09:17:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1104F13B921
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 13:17:27 +0000 (UTC)
X-FDA: 84675356934.04.3F5BD87
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7B9FE180006
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 13:17:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CTB/pcxt";
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776604645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUN93fAuzeZFXGV4K7vMRkWt69B+yFoAaqCdR3Vjac8=;
	b=FTdFY+ujqhxpcVlwdUedD/IwbmEsJvc927v5gODglaWyPKSK+V5lbDGzO3FKb/bgI0+Mwg
	cjLMg/8RUZH2FGE5Tot8tHxkWGpAMP7PEmNasLkHSEp4WtSxtOHeRBasLug9fszSg/rppm
	lzM5RQnw+nX0zqYs+R604clOqIXRj0w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CTB/pcxt";
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776604645; a=rsa-sha256;
	cv=none;
	b=8f96dVhdPrr1zQnehZZVwDojEmbSjMABhcLzADzofLeFHXHKdamABOFYMOuUyoN0nTuaGx
	6s+bP6wWYTEb3ulRAJ4jQNoHKlzhDweaJhoeYPAxuVDHm2zjq4OQNBULQxyLKXlXoQIs3u
	iRKqVNyUw+zWO4D+i3gvrbduuE2bKQc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BEC086013B;
	Sun, 19 Apr 2026 13:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB1DC2BCAF;
	Sun, 19 Apr 2026 13:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776604644;
	bh=ohdmWo16vNUrAsv5m1BvZ6YSb/zDYTUqhQnVl/n0QOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CTB/pcxtd5Y5AgVqa7kH0u50Yh0y17fIweATDD/xLjI/qILdgtSPZ0hb6RwRNrCVu
	 hP2RTuD8ab8cDa/jxzv9WHZToe0EH3B5htkqov1Q+seanVeW9ut+L3c7F+lqyLXK4d
	 q4FNrUG+lY9nrb0BXTdN+05RDdP3eCw6iILObkGjIKeVWr3yebJ/2jctVJLFM5vA+n
	 GwDCxCgUaT3EMQHkUekg423BeMvL+r+WfM/b3LlGJfDr1/ELSg1NRiSy2tyoy+m1bD
	 RfAz6QZjRHZUtxjqVJXlZNILuwSdK6tB5BwcVlhNjJ08ZEsFHsn999hHuKL8lWeuoe
	 w6++5U6ZGrVhQ==
Date: Sun, 19 Apr 2026 14:17:17 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Nick Huang <sef1548@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: Add overview and SLUB allocator sections to slab
 documentation
Message-ID: <aeTTw4gziJigaNbU@lucifer>
References: <20260418000635.17499-1-sef1548@gmail.com>
 <aeNGbNyPxJssnkbO@lucifer>
 <aeOuCH8ydw_yzdXZ@casper.infradead.org>
 <c113f667-f897-42cc-a0e5-b8a0bbd91be3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c113f667-f897-42cc-a0e5-b8a0bbd91be3@kernel.org>
X-Stat-Signature: k95uxajwkf4ozhg5h1rubix48kg31fkg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7B9FE180006
X-HE-Tag: 1776604645-398341
X-HE-Meta: U2FsdGVkX1/k/isoEqAp93/qDd3Me6x5Uq2KW+YWUDN+42cIvgzzas38zg9J8x8KtyAgNs5tFuGLLoE+Yyd/ucHZjcA/vz3evT1jONj57yIK2bZIYHqxwWEvKysPDrVh9bjql/ANdw6KmHI2muX36hAIosstNVZ1hwldKTapUsM+efoO7IGn9SDoivqzrL3kleoZuleR1WB/Hq4I8xaux5I21HI5PeWjJq0GT+n2RI2Y7Kuqb8aUu8S5vcusfR2KuHNFLy0I5MHugrFHo4b1+YtBsGgXHKQRebclplm7XOI2PpHCY42A6/cgL30lt92Txhn9rLv+jJepWu+ruD1nPVmytZbRd+sCueH8H3HlJ4816/xpaO4fA8gA/4Gaym+OfCdj1n3ZdCjGZXoHNyoGjLT2535eXwGyxOJUYfxJbFw+NO/U5ZgUbn8ryJVXNN6ELfrKEDyYNYpnxwp6ZpMAp5rMA7UmRVuqMyN3df/nmnBe/jCz7f00mNMMC2zqmaPtq/xQQcDw+sNDen75rAKFdrhWqJJ2R2A5dPIe4dVEx6oiZLlo8cE7d9XdkoOD+ebqKFPFJzNs/snbsVK9SH67rnxU1Ldt3C4OQlxU05poYM6A1FnFBTWqw6oYmHrBAIwwU+gO6qSo69B+Zt84D2IhmtJvntbdDFnS8V0pvECu6B8iBcvesJuaPMj27wq/XHow3eUmunHlSy8xkmVWR6PtCZnWbhF3Ter2KyD2jBOOhPWG+QGiIfj4Kmx1pGtZIn6FpSpHN8O6sOVviPExlv0XdreLmVRXKCCwrIYgaLX8SMaGeGs0zaWrWwXVFWEhtjISJ+ejzhoxoE8eOTFiT1shvKOG7LOYccmcZd9Vyyi3WbEXtLKm9jXy2c08oi9XfmgSLS8bz0DrQotuWBGr/dD29qwZ0jT+qzoLhSyBukOjM3ATamohS42cjMVYFv8Fs+KSs/imDDJ69cYi+6F+2Z9
 IvS9eRzy
 m587pCa0iz46GQCIFfjg8eSBByvX4cYiIGGmnbG9MoJUsODRxUaUpqs6rfP/TXcvXmZW5+xN3WsniUg9WFlxCpcDSfn7rtb9k8k9CVrdYGxpaGsHxun2LpCXyvVI3CbTSh62up7fu3U2Z7HtJzsM+S6wv0Jc/Y/ZZVi/FuSNqyN+jRrI01ap2fh8dkJRHM4u4auWCFRMNQxX/yF4pYpk4puesT9Jv/IyW6knoaH1qxKsy/6ePcSuGaxfRct/LWyvCTOs1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 19, 2026 at 10:35:44AM +0200, David Hildenbrand (Arm) wrote:
> On 4/18/26 18:15, Matthew Wilcox wrote:
> > On Sat, Apr 18, 2026 at 10:07:22AM +0100, Lorenzo Stoakes wrote:
> >> On Sat, Apr 18, 2026 at 12:06:19AM +0000, Nick Huang wrote:
> >>> - Add "Overview" section explaining the slab allocator's role and purpose
> >>> - Document the three main slab allocator implementations (SLAB, SLUB, SLOB)
> >>
> >> The fact you're insanely wrong about the current state of slab only makes this
> >> worse.
> >
> > This is actually a new low.  We've always had to contend with people
> > putting up outdated or just wrong information on web pages, and there's
> > little we can do about it.  Witness all the outdated information about
> > THP that's based on code that's been deleted for over a decade.
> >
> > But now we've got AI trained on all this wrong/ out of date information,
> > and, er, "enthusiasts" who are trying to change the correct information
> > in the kernel to match what the deluded AI "thinks" should be true.
> >
> > Let that sink in.

Ugh ye gawds. My attitude is nip this in the bud early.

I'm very harsh in response to these things for a reason - firstly, it's rude,
obnoxious + disrespectful, so a negative response is wholly appropriate.

But more importantly, I want to SET A PRECEDENT that if you send this crap
you'll get a VERY negative response.

Clueless but good faith or bad faith - it's straight up plagiarism and that's
totally unacceptable.

> >
>
> I think we should make it very clear that we don't want doc updates from someone
> that is not a renowned expert in that area or wants to become an expert in that
> area (and already discussed working on the docs with maintainers/experts).
>
> Otherwise we'll have this same discussion over and over again.
>
> diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
> index 7aa2a88869083..8c5721001c8bb 100644
> --- a/Documentation/mm/index.rst
> +++ b/Documentation/mm/index.rst
> @@ -7,6 +7,11 @@ of Linux.  If you are looking for advice on simply allocating
> memory,
>   see the :ref:`memory_allocation`.  For controlling and tuning guides,
>   see the :doc:`admin guide <../admin-guide/mm/index>`.
>
> +A lot of documentation in this guide is still incomplete. If you are not
> +a renowned expert in the specific area, but you want to contribute bigger
> +chunks of documentation, talk to the respective MM experts first. LLM
> +generated slop from non-experts will be rejected without further comments.
> +
>   .. toctree::
>      :maxdepth: 1
>
>
>
> LLMs are just the tip of the iceberg. It will all be developmend-by review with
> inexperienced contributors. And we are only willing to put in the effort to
> teach contributors if the contributors are not actually worth our time: i.e.,
> LLM kiddies that will actually stick around and help the subsystem in the long run.
>
>
> The whole doc update stuff is similar to people just grepping for TODOs in the
> kernel and then using an LLM to produce code they have no idea about.
>
> It's the evolution of typo fixes: review load without any benefit.

Agree with all of that!

Let's do that, happy to give tags on a patch for the above :)

>
> --
> Cheers,
>
> David
>

Cheers, Lorenzo

