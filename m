Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F605CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB65D8E0085; Wed, 15 Oct 2025 14:39:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8E328E001D; Wed, 15 Oct 2025 14:39:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA3CC8E0085; Wed, 15 Oct 2025 14:39:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8F388E001D
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:39:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7AC0C140282
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:39:45 +0000 (UTC)
X-FDA: 84001212330.12.EA7DDF1
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9CBC54000B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:39:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xBrMecK8;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760553583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oblg0R0ccBxtMNIXCr7M4Sp9kMpHmHDbv49DnKelLKY=;
	b=izvFGla0FvLb59OrUq7fIybyfTsLLlMY/3kUSIKHyCUjYS5iMZoFHNP2et3NdSQJDZcyMC
	VqD6aWmZQcXKd/Olo946tzfUcMHA9hXnvmSkd9s/oI3JtdyAtyhhhbqnymSsa9D2eval/e
	xZXN5lXM81mE7lWxb7zBMhBn+3gYXkg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xBrMecK8;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760553583; a=rsa-sha256;
	cv=none;
	b=3RxuEYvHmCsR6pNYY0Y1loOfMRQ5mctR/8PgDUVCsYZurcjMtN7MYXDVvxwALz8T8WgHZp
	GpiMhZZ15SoG9Fr59oHUL+IaUZTyR1gBKFZ5V4VOwd+jsGDEqqKwDinES2ZDylhdnQruAC
	AeEsfBnkgv6HWjWt5qvMRiTilmVKulA=
Date: Wed, 15 Oct 2025 11:39:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760553582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oblg0R0ccBxtMNIXCr7M4Sp9kMpHmHDbv49DnKelLKY=;
	b=xBrMecK88RlyCjYmuhCquUFna3t95yMcfcJHi+PbM+XKpyzNvHP9UHwn6FB7oHM2BdAVjW
	bb2BzGz1BdhNe3t0TD4v/Pkk7OAfREX0mklQVRPXGSoMS7z21I0qt0Htudxk5Dekc0Nqly
	wY+Z05WK7ZIwPTN+TEVuJrbvdvSneO4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v5] memcg: expose socket memory pressure in a cgroup
Message-ID: <cfoc35cqn7sa63w6kufwvq7rs6s7xiivfbmr752h4rmur4demz@d7joq6oho6qc>
References: <87qzvdqkyh.fsf@linux.dev>
 <13b5aeb6-ee0a-4b5b-a33a-e1d1d6f7f60e@cdn77.com>
 <87o6qgnl9w.fsf@linux.dev>
 <tr7hsmxqqwpwconofyr2a6czorimltte5zp34sp6tasept3t4j@ij7acnr6dpjp>
 <87a5205544.fsf@linux.dev>
 <qdblzbalf3xqohvw2az3iogevzvgn3c3k64nsmyv2hsxyhw7r4@oo7yrgsume2h>
 <875xcn526v.fsf@linux.dev>
 <89618dcb-7fe3-4f15-931b-17929287c323@cdn77.com>
 <6ras4hgv32qkkbh6e6btnnwfh2xnpmoftanw4xlbfrekhskpkk@frz4uyuh64eq>
 <CAAVpQUDWKaB6jH3Ouyx35z5eUb9GKfgHS0H7ngcPEFeBdtPjRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVpQUDWKaB6jH3Ouyx35z5eUb9GKfgHS0H7ngcPEFeBdtPjRw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: fgreufwz8n3s5nrw3wjx9974ywj73h6j
X-Rspamd-Queue-Id: 9CBC54000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760553583-640964
X-HE-Meta: U2FsdGVkX18clcov/S4DlbcQH86q65QB+KnyPWVhfSAM+4qUQ0SpGfaN+fws3A3BAQ782oDrmzFErZANiuPllRpbO8IbORIY2SWLA4EL/WS9S37Elz7etSOrnchtN4RscwhwdWVhtIITNAhy+auaxXxp6y53fUBDm3Sp07xNrNClhr9jdXoAsdZHCswGArLIjcyNAz9Y/0aTfMSSNHZUJoXvk8J4uU594VHlm4cNcFGHll/idrOPvUg2Uvq72UxTV0kibqwFFOxCGoJxxPLiWULTzd3VNADeHvpyGpN6yv4YX64d6cYSpIkkwiFNaFwkY/7U+qktI5/7vLms1sKKwzMwhE0wZCLMzv7NvTydNDL9FXwEX84akLG0X/MZ8cNKCRp00yKQjZrDz46A55Fq4ziMzlGqcDmI31R5tJB4nYMJWGDacJqg4piiuRCp3diQndhQzLk6fdQxvr9OOEK9ZXNfENvR7eH7zZ06FEdNJKoiDPo/kG2VWE5E2SFLw3WtXDs/28iLQQyEtaBzbrBQBptqlA6Snz474hEGHtUPRLoy0tqUPJAwgUr8QEWdwn7sVaILX9wEEKAGONxgDhPq2rtM/txaff2IGoW8tOyHyKkvowtLAF05q8WenmLQR8r582AHJVKaPJRhbo3ajN7f0dt8ncZcNDFG2PkDu/s4s5cHuw9gYMWAQO2TOEVtgVcHuQj4lU1uKmGzmT03FLumE7s2SblxKoPxbWiRzsV0hSiYOiL+kligA6WPC7H36ikexrP/R48p2/sTLh6Urh75mWY+JhcE67uCFp1hQOjNPZO5lGc+XqUiC1OlBmY+1mw83SENavk8QnvLkhQcECG72qdfQtUzGfGlJOELS5HtXGNAVUDrIIXXJagXM/fjYac92Nmku5qMfLRLvFTQDO+WzjKAwsG4G4r5ug1XfpEOK4RDZY2jM6Q7FsBKZkkkQZrjhbQxU06Xz8vauevBafq
 ntO0Ft02
 mupasw9XeI4m/YqWIH1Ov3DVVdzK6yWJY60t7MAeNJFafAuidbUxovkmuRm9fMwZs3jbZk0rlz/GLLWB05vybjNMhs2L6ruWq+ElM4mM2UwJRT13l8bkchZqQFm3f4j5LHAMIc/b8ZnnUSN2XIpTZSF2zGw6/OddFspbGz9bs1tqfKs7aiY9Ujah4DalI6jyLEFKpbblwfPBmCPt/Zn+2Nueti/Ymr8oTgqSmDiHJ3Sv3Zf8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 11:21:17AM -0700, Kuniyuki Iwashima wrote:
> On Tue, Oct 14, 2025 at 1:33 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Mon, Oct 13, 2025 at 04:30:53PM +0200, Daniel Sedlak wrote:
> > [...]
> > > > > > > How about we track the actions taken by the callers of
> > > > > > > mem_cgroup_sk_under_memory_pressure()? Basically if network stack
> > > > > > > reduces the buffer size or whatever the other actions it may take when
> > > > > > > mem_cgroup_sk_under_memory_pressure() returns, tracking those actions
> > > > > > > is what I think is needed here, at least for the debugging use-case.
> > >
> > > I am not against it, but I feel that conveying those tracked actions (or how
> > > to represent them) to the user will be much harder. Are there already
> > > existing APIs to push this information to the user?
> > >
> >
> > I discussed with Wei Wang and she suggested we should start tracking the
> > calls to tcp_adjust_rcv_ssthresh() first. So, something like the
> > following. I would like feedback frm networking folks as well:
> 
> I think we could simply put memcg_memory_event() in
> mem_cgroup_sk_under_memory_pressure() when it returns
> true.
> 
> Other than tcp_adjust_rcv_ssthresh(), if tcp_under_memory_pressure()
> returns true, it indicates something bad will happen, failure to expand
> rcvbuf and sndbuf, need to prune out-of-order queue more aggressively,
> FIN deferred to a retransmitted packet.
> 
> Also, we could cover mptcp and sctp too.
> 

I wanted to start simple and focus on one specific action but I am open
to other actins as well. Do we want a generic network throttled metric
or do we want different metric for different action? At the moment I
think for memcg, a single metric would be sufficient and then we can
have tracepoints for more fine grained debugging.


