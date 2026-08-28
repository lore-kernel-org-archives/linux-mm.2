Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C48E1C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 19:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CE4D6B0092; Fri, 28 Aug 2026 15:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67F126B0095; Fri, 28 Aug 2026 15:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5964B6B0096; Fri, 28 Aug 2026 15:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3CB776B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:55:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E12681A053A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:55:12 +0000 (UTC)
X-FDA: 85151732064.27.9ACFE22
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2BFF5C0003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:55:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0mAyBXDC;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787946911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RxINNOOACjMYXoYatrs0c86mnfYNcZa83lnprus68gY=;
	b=ZEj/YmEYEUxMBgeiGweWiHDFI7Tkqg2CLVxXG1mvJGkuNA8P5QWUHQznoac3mJQMrazwjl
	uQWQDtksH1Zpd9W+2CSZD3QH9Wybo+ZTuh4luRmhqSxAlLZMkquPOQYZlnwGPljgpnI4lr
	PohNNdkW4CH/bHiz5/CD/xrHRrXk6bw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0mAyBXDC;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787946911;
	b=P2BXICfniWZhOt0jATAC5gE0kXdx+4FPaB7trpY5SRWFGXmDQgwpU62Vurj0S/qSKf1XUi
	UoGlgbzQt6rO+/M/ADQ5kseljQXpAKis1y7q+PKTBgCn0/QVSCl9DHWanSlXELcyw7KMV3
	4wku8ow55sbkEwn345F9wb92YhCV8Yw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6131A60052;
	Fri, 28 Aug 2026 19:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A951F000E9;
	Fri, 28 Aug 2026 19:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787946910;
	bh=RxINNOOACjMYXoYatrs0c86mnfYNcZa83lnprus68gY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0mAyBXDCnNaw5HLncu9rKGdX9UpyZ+k1g/LvILACWZs2IKSyNRxxNjw6X5jUh9cDn
	 ZoJYwVqp74Dx8dniGuBKTe3SXugx9wK7K2Ilkq/uvFfwM/JGiiTrLdu1kU8xef+l0C
	 ASoR6UIQen/UL8X/ITMZ12tA3xD2zYqbddoZresU=
Date: Fri, 28 Aug 2026 12:55:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org, Johannes
 Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman
 Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit
 on isolated cpus
Message-Id: <20260828125509.83d2e242534c2209ca253504@linux-foundation.org>
In-Reply-To: <apHgs2ZAxAdy8WIH@linux.dev>
References: <20260828135036.7d44361f@fangorn>
	<20260828122018.1a3b3be204212837fcda8e50@linux-foundation.org>
	<apHgs2ZAxAdy8WIH@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j5iheca3u66886yd7jb44kec49r3haub
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2BFF5C0003
X-Rspam-User: 
X-HE-Tag: 1787946911-286437
X-HE-Meta: U2FsdGVkX1/2m0jzD1VM6wu3bpTPNhsBSjEQdLKXS49SOrcK5PkTZ6karRhtwAoTlnvTY2kHtLPa6hJ8fK35LxsmzgVjngHBIDmYi8XukPihdqLUXAQie/oQEihjuY2Lall+dGZIJk0dkdgpyhBqDJJGzmA9tC4pL9VjeZ1c05N1k/cZliNA0QOwlYBnGLDp8sVkPBjKSFnD43XFw9TQ8B8mv79Dd7k3iQYfPKOhbIVFtgfyt1Ozq8VETfohFK7+St5OdYCfFoIzEeAvonU33niLyg/f1kjYs6XtNYFZnzXstH/3QnHdSrNEV2lxf0M0WpxXFxClpVhZOI+FtBKoK/YFsQE4RHc2Msa5CGquAnOAikgYOv6fYiu/ggYGQMZggtQRAglhJTIQaRJLXN/a4qMRJiGbfkJlpxGc6ky3kXqZFrbz3dNkfTsdZsI+NQOOgQGCfC+++UKRAVtHMBeZpNmWbZ+Ba1YJedbA9o8SR7Hy/U1uY/DH2GN0MXUOCc79UI6A+0sOgRq5hrxKO28D1ctvH/MPJ2FHSVeJVsb+1myr+5ZlX7iShn9hH1afBks33/RFj+FTMLyMi1oT+v2u/02lbyjmodvVQEEYNWHRGrokksPaq7A8FKXP0t9+hMO08TYGC0uoMfFRYmopoX0t6SvYcuC+rxjkV5AQ6Xc+WetN4fzxe1cOm6rRULXnKS1OrHm0uT6Qz7e82kLk9Gh9TLLgXuOqc5KyzHMfewp3YY6P9ziUMhmLc0ZzItEQbXTJ3hYKfzQrl76X2+r4ogXm4Xj/lNEyw3iSmuj9Twh7jdC9iDRPANJBrqaKOY/SyeYjDjgEyTQR65uhgl4vBt+LNiO7QzYQ+L2b58XUexz4Ebhv0yf8Z6Iio+Bf6EAbz2Lo6LaiEn57ieXHxM1rhCVkhOUq8zCotvLsv4g2dfl9AFSm1qjJs/9nkt2CFu3T8ztnhvOefvzxIDAJ5zKK/Qe
 VNqV/D5v
 JxjjAJLt1C/i1CUfx5vFiIyHf+ET3jiyU49nHkH8RMvxkBRxDLiKQ8BiKAhKESUgSnzu3LrQhr6NrqCr3HIP30UxgGz6tv7hJbBtYr5kB5XNY4KL3Tzet65jojwwAVmu53IfnzuMWL50Xf1RiXKc9iUxC/Bzw+msq/dzQqn2B7hUp+zRlTpx9hp2k0jFTG8qFjV3hl32NH+ns33RMuVjNHdKIABmDGf0CHAmpRJTD3d2/I/noh0McO1AdpTp4KgZdo85Ogn238jGKZlDpjyzO+clIkMoKb1xbl/S1SAJnNYbCGf/9834jc133WeOKDi+rS1Shs3iuotDyavhxyLyXt/79S6yxLIp9B1++IcRxKdh6iKGaVIu3ySzWTtj76M0XvWNSL2yyBruXxRYBnqOGcekbnZBLiwWYlj4EoGYNK9f6SWfxDPJIFQThaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 12:26:15 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> On Fri, Aug 28, 2026 at 12:20:18PM -0700, Andrew Morton wrote:
> > On Fri, 28 Aug 2026 13:50:36 -0400 Rik van Riel <riel@surriel.com> wrote:
> > 
> > > When drain_all_stock() sets FLUSHING_CACHED_CHARGE before checking
> > > isolation, schedule_drain_work() can drop the work in a separate RCU
> > > critical section, and housekeeping_update()'s synchronize_rcu() can race
> > > that second check, leaving the flag set.
> > > 
> > > drain_local_stock() only clears the bit for work that ran, so the flag
> > > remains set and the stock is never drained again.
> > > 
> > > Have schedule_drain_work() return whether the work was queued, and clear
> > > FLUSHING_CACHED_CHARGE in drain_all_stock() when the remote CPU is
> > > isolated, so future drains can retry.
> > 
> > Is there some Reported-by: or reproducer for this?
> > 
> > Given the complexity of the reproducers which Gemini developed for me, I'm
> > suspecting "nope".
> > 
> > > Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
> > > Cc: stable@vger.kernel.org
> > 
> > Why is a backport being proposed?  How does that benefit those we
> > serve?
> > 
> > Sashiko suggests that we ain't done yet:
> > 	https://sashiko.dev/#/patchset/20260828135036.7d44361f@fangorn
> 
> Haha we are never done. Just sent the fix for this new report:
> 
> http://lore.kernel.org/20260828192419.3057939-1-shakeel.butt@linux.dev

Cool.

And... guess what?
	https://sashiko.dev/#/patchset/20260828192419.3057939-1-shakeel.butt@linux.dev

