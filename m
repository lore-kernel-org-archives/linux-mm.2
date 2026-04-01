Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF88D35162
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 11:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0813C6B0005; Wed,  1 Apr 2026 07:15:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0325D6B0088; Wed,  1 Apr 2026 07:15:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89956B0089; Wed,  1 Apr 2026 07:15:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBBEB6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:15:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A3F71B69AC
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:15:14 +0000 (UTC)
X-FDA: 84609730548.06.2BADC41
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C1BC4120011
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:15:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K32yyvLf;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775042112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rjZVgB77RsRkWf06+levwA6ayx+NXXNkjcv4qhUis68=;
	b=QSh1RPaqBMt0IXzy5QLE4jc0YDvSyxoAYhgXW2wnxvrNco5ajNeCFgMY8r0mbMPZSiYthU
	EVv7J8K6TbSbHOKHREcjJo0s6lUBPZYEmQ1XnfDy4+XQ4Iw1pHoCH1EipCqFeF0aZPSMNt
	OnuugK4Vjq3XYouQoeI4EoU439wZ6Wo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K32yyvLf;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775042112; a=rsa-sha256;
	cv=none;
	b=Su61fC3xhoIlAZU9H5cmlIpTlFs922UkvJ9uIs8NXQcKdLzyKhbD8j6FTOmj0ladDpnquJ
	OwNqCTV6MBbyH7LzUGG2ah8YvbI1KrXmolwReBdyfGEKuA+iqqube0CyliBHv8UBCcx9o6
	//EMb8kgKI3UivaC97ZlNYxqV6KcXlU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E2B160131;
	Wed,  1 Apr 2026 11:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93246C4CEF7;
	Wed,  1 Apr 2026 11:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775042111;
	bh=dewT5thds98VTAImtEDNC0EfFTjUiz4qEvaiq2jKju4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K32yyvLfMjplva3EkWRS5sBRxaNW5h2A8wKlmF06k1twv/MTgVWjsJ2N6yJsDwD1a
	 n7q5yhqJY+3pjT3mB2tlgJkWYrzk2VOIKX4Q7RrzFCCNHmFEMM8uCyvKjmjjDS+cGi
	 NDlCoGWWo+vsO4zkGxbNjF5zPDkMW9zqBpwMx+JvyYOH9IOVa0pxnygel68fOHRVJ8
	 7BJV3MuB1GZ5vcBs7XjJibMa8uJPrd4YGaHF/Uhwcht5rMTomukjzwWoNnzERVvWyB
	 KpxZZlQN9veszefrADFZNEA1ZF2sBYwbiJQEZxfnfj4IKu7ZUSiHRR3rq+y70noYel
	 8+OWFV/nITe4w==
Date: Wed, 1 Apr 2026 12:15:04 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Harry Yoo <harry@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Muchun Song <muchun.song@linux.dev>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Pedro Falcato <pfalcato@suse.de>, Jann Horn <jannh@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Petr Tesarik <ptesarik@suse.com>, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] slab: remove the SLUB_DEBUG functionality and config
 option
Message-ID: <cf2f7892-9ae0-460b-9c71-ca5b5d3697db@lucifer.local>
References: <20260401-b4-are-you-serious-v1-1-dcacda70647d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401-b4-are-you-serious-v1-1-dcacda70647d@kernel.org>
X-Rspamd-Queue-Id: C1BC4120011
X-Stat-Signature: ucn53g39bby8w87ansq8mmwmaq33j8gy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775042112-112737
X-HE-Meta: U2FsdGVkX1/3RhYQtxdiCEuKDunaoeDzeZB+KIlVim/D6fRNh+tz2PL2h7oFt7MtqahUEPSwMWaBlt1PJATcgA+UoSVw2TClyUKm+58AuWmczHQsL16Z8nDWCRTcq9XTzbVXzQBk7RVsFkruUdnGl1+0wnJXJ1/sY0QvGqmoY7ZJHUWRmrMDl9J9yqs3n0/cqToBMWY7CSdrdevJUAV9ewa8ypOR5TmtXJRe9X/sGY9AwbkGNof1CYo9/h60XbV/0CLR/ge57DDAXn+0E4j33qikRpblptgNkKatjLZNIoxaj75+U4ROWJsiWT9oJwvapZLoO8TROmmlx6CU2kGg5pCGXErwfi4PhM4l557q3ypvQfPb9DHA/lKd5+326HofkIrWOrEy0CzK04UzkMdU4L63g1ArI5BP/aYq87a80nF4pnbzfHu7CdJFroRpBLjOmll/LQG1yn1ucw4hIIrgNaXc9sPor0fyR9xq07kkbQIkgj98D+8xJeuXP/6BIK7TJwz4Jusa6zY1GbeOsuTYBguEKekgNolr4EdTbNnU/aZ7LqUkKYndGkmUL/j6Gs67d1/tsHldxTTA6Fk9PWAyaLUQ9J8xhRuE649O2JJOdonJISlG+znfTXwNTm3I4wflvSWaWpZ6p0ObaazXqipIMukzlP02c+NOAiQmF09Ko8oD0G+IeCdErQ5Qw9mtk6zP8uwCt99g44mEHpMyLRp9ACwrgT3Y/ehF0f0aAdfaKOcs4Y7xDm488AaypV77fVWk7CeupJ2auRLll9ofOhC4HFUg6diRTFOdppK++ePnBOxEcQf3Xc9XNIsqvHZc5ggCZrUVKLRDYYyJKyj+l4E905sHzacVTzr4EffDUyRnloNr1ir7S58rC2qHQcCdrvAgswCW768sqhBEJ7AQenLhEs0TWo8uViedmN4UbDVTbnm9je3esZFWms9pvg2UYNq2oxJM98TbExsTH0VGWl5
 N1jUXiaR
 MI6xKOkqnyunDf/3k6rG4tSVFd4k02AIy9UUV0VK2sFrFPkjhftHUayLBnwMiY8cmi8o5DM9HeNWYcnOqdMxAqAq+IwpOEaGSHWwpiXx621b4n6rDY+lCf8NOBo5Shd/ghPOSUz6qO30iUoH6Bf+Cd2JZ3JfuOq9MMmNELaASY0vtQMcnxuvn/ysAksfkfcJ4VdtmJEzxUOuWyoEN9MA1OhItAztbTcbr9LvC0XqClgm1jrUiwiTpcqv71muYmHER5p+lt9UrGbZJTi8C8bWYHmEGTbhtSd7g3M/UdPadfuWtvu6axHja6Zpf88jFc45IyuGWeHbuc7fXWGRHpyLumR98LuPnvGYKsq7N
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

Honestly you're making me look bad because mine is so 'positive' (I SWEAR IT IS
TEST CODE AND COMMENTS) so this turns me against this patch...

>
> Since the slub kunit test depends on SLUB_DEBUG, remove it too. It's not
> a big loss, see the first point above.
>
> Singed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

...but because you're removing clearly useless and superceded debug code (I mean
hello, we have people using openclaw to automate all this unnecessary kernel dev
stuff):

Reviewed-by: claude-opus-4-6[1m]
Assisted-by: Lorenzo Stokes (as per the register) <ljs@kernel.org>

Cheers, Claude

