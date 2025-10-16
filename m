Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2EF1CCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 19:46:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5428E001E; Thu, 16 Oct 2025 15:46:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29CE18E0002; Thu, 16 Oct 2025 15:46:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D9C18E001E; Thu, 16 Oct 2025 15:46:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D7A28E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:46:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0CBCB9791
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:46:14 +0000 (UTC)
X-FDA: 84005008668.06.8C21B14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D4CBDC0005
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:46:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="eV2n/1Eh";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760643973; a=rsa-sha256;
	cv=none;
	b=zFeSgoJqsiA7/4bQCrSmQ/QC/l5bU7U4QOw7jv5K8BzxMEZKwuovNZHHvn0I0346OSBxSH
	3sZY1CSRNYV24bx5qSlXkCJ7TNfFHuwpGH3ZO/eLHsaXE7nS9+hYzi2mGPdu7bhDUBYnpb
	BV5OhkBdcQk1eQ2N7ggbn8zlSRBM/LI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="eV2n/1Eh";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760643973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wmeUViBXVVeE/jX866+HvZyBvtiemf4tBbijSinCOgE=;
	b=CFeLCGYcPr+M44QorsPknox10mmmUn188X/ll+y2/+g3u5Jg8Xw+V4BvFZtghmhsYqmaFH
	YhVucJpMiPJbYOYexFWgCbpe1juO+QfokwTeQF7cZmX4aIbajJYYHbFMWGl5LYqDN2OvJA
	gKxu5g2Jl1MmbeaMmCoaovxu0P1U2ww=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 88D6E443B6;
	Thu, 16 Oct 2025 19:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5791C4CEF1;
	Thu, 16 Oct 2025 19:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760643971;
	bh=lL6q+PP45aV1hUhjB5GLRugpFv1HA+TwJ5wUIHf5o2U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eV2n/1Eh/uFNVs+bGO9Yvu9htxPiA2g6EXrUM4r/6gZB/TFZ2H4XBCoTWctusvFMy
	 UuHjsTss+DPW+AMx5q+KHEZJfXXijavpQTPVNVCXIQg4ECkUhKv/2WMh9fFCSJ70DO
	 yLKuLj97eF9hCyLCK70GYYzSFGnqQrNgAxLbr/Jc=
Date: Thu, 16 Oct 2025 12:46:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, Eric Dumazet
 <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, Jakub Kicinski
 <kuba@kernel.org>, "David S . Miller" <davem@davemloft.net>, Matyas Hurtik
 <matyas.hurtik@cdn77.com>, Daniel Sedlak <daniel.sedlak@cdn77.com>, Simon
 Horman <horms@kernel.org>, Neal Cardwell <ncardwell@google.com>, Wei Wang
 <weibunny@meta.com>, netdev@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Meta kernel team
 <kernel-team@meta.com>
Subject: Re: [PATCH v2] memcg: net: track network throttling due to memcg
 memory pressure
Message-Id: <20251016124610.0fcf17313c649795881db43c@linux-foundation.org>
In-Reply-To: <20251016161035.86161-1-shakeel.butt@linux.dev>
References: <20251016161035.86161-1-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: k84nq88wrpz4r89n7g5nsiw15h58dqhj
X-Rspamd-Queue-Id: D4CBDC0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1760643972-606173
X-HE-Meta: U2FsdGVkX1/kjNt8+pRI03VGZomrv9//No3CcrZi3ihiR7HDlMaIIls3aG4gzYs8nbOpqYNHJz+4RMz7QsSs5pmCNNuG2h8m8KSI3K/l11YT2GEaq9SKSj6Fy45bbBcFK8l+l0tGZeEjoxLkboQr2hCXcg4ZPZ+MDADhkucVEGiN/lXzu7R1o+xekH6YGirPWChgG4zOm1wIvpPulkCxV4G2kdvfD4+4pQ9UrvSNE6O83N5u7iAS0XNJDNV/8gR4vaL5NWkk6NEhf+WGOlhaVzRhV934mXdvn9idRAQiZsDPp87e5A4I/Q4rKXya64VD6/6TrfnARSTJ2QomfZTWWERxGV4lBSD1ZWj39bB042zZ7T6CBEl5xYCIcUVpqyNBQwW1tjIMdDlmi5ugkAp6y9E7Qj0CPEr+hSnsaBJna5vLCN3JqXG+KBvoqS1ayVhptlEFRNtjQBpvkF3blkgEmHFKEQfivGjbOB8szZRyKWNtSe9DoeUzOlHTrMxo2cuC/tD9b4XawA/BIlevwHx5o8riQQAJWRY9r0VyBRJ8k4D4v9Nuvo5L1Wf3HIMa5HMr/Vbkpq2+dCv6eSGyWI69vRvC+RoyOf5d60L+p8f7dDDD2P1CQfOVCTdwicDpSwtcpBGi5gqml+szehMbYKxI9AqIL23Pd+rfSzvvM/s+TYeev8jS73I0Hlp8kClwerbK6If0x3TxlArl3Cye1BcHq2q4ITjifpaBIFZ4We+pDfZuiyTuD2F1lCitBBUoAqMV2KWhtT3NJxfwWur67QhQ1nN0NhIoDnSb6UTgQujbowA3kjMvJqJFPhNJGzLGBva72Hvb6ZBhvYtThzpxJ2rSCJmEPfq7hbhOeYVaOx6O61rcr33z6ApbHdofEiZg0Opv0ln0jwT4FKQLoCc+RP14qXA0w2L2dxqsb+YqKb3bbAo9Z4kPsz/bz2iNd2zlpFyvNyuj5dp1x1tmfxidAps
 RXhwh4bF
 971sCAuWud0xyyYQVFS2B3xWMtxfZJC7Ww7cHi4KeeZwUSghLuTquv8x5OqAy76RHyJSF2xEzOsFfKN1Jf9qMdlBgq7FCeX0zhJDdVc0961brc243A31BCndxjaWs442HA+oB7YTgccJ0c4XzPS4M3FBzpdVXx/RAZiXnHYk3uyKQePGHPYFa/fLHqjEPAbNNS2NuOCxC2XjwnmVuDSms9uZwgbefFCTQf5ZfhW4bNLyuPQ9PsKWCh6wVab0zwMCiBVHO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Oct 2025 09:10:35 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> The kernel can throttle network sockets if the memory cgroup associated
> with the corresponding socket is under memory pressure. The throttling
> actions include clamping the transmit window, failing to expand receive
> or send buffers, aggressively prune out-of-order receive queue, FIN
> deferred to a retransmitted packet and more. Let's add memcg metric to
> indicate track such throttling actions.
> 
> At the moment memcg memory pressure is defined through vmpressure and in
> future it may be defined using PSI or we may add more flexible way for
> the users to define memory pressure, maybe through ebpf. However the
> potential throttling actions will remain the same, so this newly
> introduced metric will continue to track throttling actions irrespective
> of how memcg memory pressure is defined.
> 
> ...
>
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2635,8 +2635,12 @@ static inline bool mem_cgroup_sk_under_memory_pressure(const struct sock *sk)
>  #endif /* CONFIG_MEMCG_V1 */
>  
>  	do {
> -		if (time_before64(get_jiffies_64(), mem_cgroup_get_socket_pressure(memcg)))
> +		if (time_before64(get_jiffies_64(),
> +				  mem_cgroup_get_socket_pressure(memcg))) {
> +			memcg_memory_event(mem_cgroup_from_sk(sk),
> +					   MEMCG_SOCK_THROTTLED);
>  			return true;
> +		}
>  	} while ((memcg = parent_mem_cgroup(memcg)));
>  

Totally OT, but that's one bigass inlined function.  A quick test
indicates that uninlining just this function reduces the size of
tcp_input.o and tcp_output.o nicely.  x86_64 defconfig:

   text	   data	    bss	    dec	    hex	filename
  52130	   1686	      0	  53816	   d238	net/ipv4/tcp_input.o
  32335	   1221	      0	  33556	   8314	net/ipv4/tcp_output.o

   text	   data	    bss	    dec	    hex	filename
  51346	   1494	      0	  52840	   ce68	net/ipv4/tcp_input.o
  31911	   1125	      0	  33036	   810c	net/ipv4/tcp_output.o



