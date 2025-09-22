Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37521CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 23:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 862898E0012; Mon, 22 Sep 2025 19:43:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83A3D8E0001; Mon, 22 Sep 2025 19:43:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 776F88E0012; Mon, 22 Sep 2025 19:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 667088E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 19:43:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D936114028F
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:43:32 +0000 (UTC)
X-FDA: 83918515464.02.ABFAC48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 33FE3180006
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:43:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="tiQ2QQ+/";
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758584611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1YaHtUXGOR43bIGiROeRX/ukwDqjrvyENl8VFBSfxmc=;
	b=YqwYjb30lbo7M4PRFKqnURu7DrYJ2fBq+2Tag1lceQzIixIIXr56R/3yymFjNZibdg6wEU
	EYbx5EtFjl3znc4DA72jsJBWlTL32nRPxRWiItujsQJYxTq6G65fnjV4B7k4As7xGXgZmj
	BGukjHsiJdPo1ubQao7+I5BjiIf+znw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758584611; a=rsa-sha256;
	cv=none;
	b=hJLZRaGhrcWMru91Sg4Mqu3McURFhSOsE8e/a6Q5CrHgxzN28r/CMZFJ/gXtSpXYdqnWow
	nU5+sKGpu38Apo9juz0qg6sRaxYAX6W/Ro43lNy8LZFDFEJQrM+zsVks52TamiY5GobBGy
	dMVHz8/pyNIRCoDPzxGonwzJIQqM9Ks=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="tiQ2QQ+/";
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 760B66025C;
	Mon, 22 Sep 2025 23:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B3CC4CEF0;
	Mon, 22 Sep 2025 23:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758584610;
	bh=+DoS20lbklC1Eq233nF5tfa9Kd7uyFIHyukV3z8UGtM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tiQ2QQ+/tugRqJGTfepSFY1hDwW/i74IZieK5RoR+GP4YTR4Cb+1Zc4bBqSBS1N0P
	 LLnVNlvDIlQuGY+Rnz1AHWQZPuHeCjCgtjRK/zgILMh6FIAbuJ6POUDrIwljrgWgyM
	 5JdqQ24zfkvP7xBXYQ0/nsfVv9cNv1URigg1cYfc=
Date: Mon, 22 Sep 2025 16:43:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal
 Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
 Peilin Ye <yepeilin@google.com>, Kumar Kartikeya Dwivedi
 <memxor@gmail.com>, bpf@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Meta kernel team
 <kernel-team@meta.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] memcg: skip cgroup_file_notify if spinning is not
 allowed
Message-Id: <20250922164328.0d766c95f9c15330e99514bd@linux-foundation.org>
In-Reply-To: <nzr2ztya3duztwfnpcnl2azzcdg74hjbwzzs3nxax67nsu6ffq@leycq6l5d5y2>
References: <20250922220203.261714-1-shakeel.butt@linux.dev>
	<20250922160308.524be6ba4d418886095ab223@linux-foundation.org>
	<nzr2ztya3duztwfnpcnl2azzcdg74hjbwzzs3nxax67nsu6ffq@leycq6l5d5y2>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xnejwp11t13jde41wxq1txdkdqf96ers
X-Rspamd-Queue-Id: 33FE3180006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758584611-686059
X-HE-Meta: U2FsdGVkX1/3o11/MdeY3WP9O+J1HGOZVgLdDza4kgkSPgaxny83oAJ8yykxG8H7vlxUXCQjyZNnCnwEiGiOJigB0ipKrc7ZBuR6o2/t/Tzbbm7bZlRTIRG7xG+UAppbwIPt/sFUZHoV/qoWVuQHCuWrucMU/vJrvAjd/6IvYZkUYO46lr1Cs4n1gEzppwEkPnc38NL99gqBXkxU8tiK8LZ+sPbnn5zJH6I3a1h9V8zEO0fCUg2EQttHLuayRpbwTnf4RiucDk+N9yxfWYVJVNJsW4s11pl0mRFCiVf+D6sOL3MAIOzDmxHklVotjvERhQFFcPh7f24wA8tw+qACTlr1J6aScEjvsXlMtJU3riV6QxR+oN8b6lFAMkWUsZ4G8kesJSODvnVM5su3lxQzV4bW8MQ9nbSGWfdPJIBiKvV3CX9ifHw07gWIU+30lVhFA+/PsjDt5K/vDHpYtlWXHLduYu3M4PdgEZTonm/pRKLcmL4EDamynrui9RyMEy0TAGFaFDlhyXhNq/bU0G8M/50kr8LNAmtAW0U9sG9YPNfwYe9IAzwbv2bqP6vfitemjN0OS9bSb7yJksImdKL8q2zzeFQqv6niEwTe+nRMCHbrw8v1aDXlDOrPMrNotWnWO0R1v0BooNFMNQwkVL+xbB3V/bX1ZyyJ75pxvtc1FhP7vhAnHla0g+qCtWhXVlrNrZxq6A5/JwjLFlzi37qovFOPyyjjf1N0SpNBll3k+r2TCmTOUUeeP7+ePSNQz7vF6SuCGkEMVCnCTY7pD25q9IkTfG63JtPEtNdxtDiXbpDylnCvBhgdVJz8znShv9IC3aYaGFSlIESRdFZaLwLy8mDbrH00zgobJLJEwHyjYjhDl2kyWdSYyTDCq3EpaKRgjXs+cEgLUKEr/8GSJvs/fV7t8kLIOQ+nK5HQU9Q5p1SCtwDzaG6TBBEPqxFJJIZKYg+q/dr9pxVmTE+6HsL
 B+/k1Fq0
 IdcPW/zsdA0aEmz4iMEz3BCyp00k/k7Wgkm5DWm/iJVKG8TOxuVpoBXmA7DKICRQs9eIEJYE7JkZ/IKB/LiQaA1XRHmgJRWymBtWzdMHH/ePt6cYAw82PrRvoGFQ7YX4+e+vQVVuayWEiqc5coIQBbT0VYrBiTyJ4a26J2q442JRznqEQrZKdoVhKT+MJDT4xSGsZCaQu6++R7ufFijiFniuS64ttBauFCtoZRHOeQnw6I3651YX5MhmRwHzawxjij4A5Q19BsfRqHmZ4O5dIUoiu801pQXuf8FWM0ppNydRXPBI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Sep 2025 16:22:57 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> > 
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -2307,12 +2307,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> > >  	bool drained = false;
> > >  	bool raised_max_event = false;
> > >  	unsigned long pflags;
> > > +	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
> > >  
> > 
> > Does this affect only the problematic call chain which you have
> > identified, or might other callers be undesirably affected?
> 
> It will only affect the call chain which can not spin due to possibly
> NMI context and at the moment only bpf programs can cause that.

"possibly" NMI context?  Is it possible that a bpf caller which could
have taken locks will now skip the notifications?  Or do the gfp_flags
get propagated all the way through?

