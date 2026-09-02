Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6086EC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:41:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46C936B009F; Wed,  2 Sep 2026 06:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41A9E6B00B5; Wed,  2 Sep 2026 06:41:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3314D6B00B6; Wed,  2 Sep 2026 06:41:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F59F6B009F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:41:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85644C016C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:41:53 +0000 (UTC)
X-FDA: 85168481706.28.8E429F5
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf05.hostedemail.com (Postfix) with ESMTP id CD184100005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:41:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="3aLE5/+J";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=o0FH9ot0;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf05.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788345712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gE3q2mnuqp4VNjrudaIOU10zmf2ptLy8FzzNkjTFj80=;
	b=qlUGzugxIP25zQ2gKJiCC6bP0MSRNx4cYspDKkB0FjgBSDSTWPhRxyFupCoQ4MqJqqfjXP
	xbvJv4wrC89Mv0uTz1WL0+L37mjPW4lO7Rct5mgnlHUFS3oQwydD0IRu8sYjYXLQgqj82q
	B7VGmHJ9AXkVTzrv6d6fhckQf0bEjK0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="3aLE5/+J";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=o0FH9ot0;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf05.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788345712;
	b=Xfqob6pya1y6DKdnP0pjA9jKMCczzgjmj+Mlxu7XETieEEeEvk1612k/KkZ+VkOa9pmc1Q
	Aq0GlTVVJ7yJqlGU+la28M3vJf4lLa94sRhfldCsn1YtlROvPxMOks+0emuY+w5jGKRpLg
	gzx4mk35jRw8AsbSNKQveUXmJ0asgR8=
Date: Wed, 2 Sep 2026 12:41:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788345705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gE3q2mnuqp4VNjrudaIOU10zmf2ptLy8FzzNkjTFj80=;
	b=3aLE5/+Jn9kHSSfphKTcjdpJgFAAB6ldENs61d6YnWSU8O51QNwxrMJa5Ci6jfH13Y07DW
	o2uKkK9kGBynnpJyOAT1VjJpQ0v776RTbgOPYLzB72bhe+86ECX5LQnrxT3mTDflE9meAI
	UiaztD/cdw472KOdFUhLLWjFGjLzlu4Y/3Dc02wMttwM38daq0htwYk05M5t1185Ys9ui7
	LbAHj++23iL41iFHD2FLXgeQUQyrc2SDaBzKG/w2344Zz4ezWKt4sJokS4QtWunqJf9Hvd
	Tuj9a/lmZiujhoXkNsufwdBzuE7+IaAmNTCiGC4QmxuaIsUK9s13sZUzs8IZ9w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788345705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gE3q2mnuqp4VNjrudaIOU10zmf2ptLy8FzzNkjTFj80=;
	b=o0FH9ot0MYitBBSOsIppqZaOeaITX1sSjB7A4OqOE6H7yx2LjGC2RoL6OZjnJeFkz527zD
	6+Ku5WZ/S/jm1WBw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	syzbot+acf142088e0182172e58@syzkaller.appspotmail.com,
	ThangNN99 <ngocthang2710.1999@gmail.com>
Subject: Re: [PATCH] mm/slab: disallow kfree_rcu_sheaf() on PREEMPT_RT again
Message-ID: <20260902104143.j8BXrjKq@linutronix.de>
References: <20260831-b4-kfree_rcu_hotfix-v1-1-4f0fb882638b@kernel.org>
 <20260901073339.uyKHXWCX@linutronix.de>
 <47aa459f-27d5-4b2f-9eb9-36ebca63d890@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <47aa459f-27d5-4b2f-9eb9-36ebca63d890@kernel.org>
X-Stat-Signature: 755ohk8cjy9gjnctg9pg84mmgxpxuztr
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CD184100005
X-Rspam-User: 
X-HE-Tag: 1788345711-627939
X-HE-Meta: U2FsdGVkX19u1ZsuRRRhYnpiZznLRXbOIjTbMdUZX2ENWxrw3sgNymkmQqcAGw/KGvzpBv672tnknaof+1ZxhaSiUdRKpQaT+vSnrowTQ1YGvZA2mNy0c53v6zo1dfOtXahwTzvoJRztxqHBfFodbeuQUqj7EMe9IuG/rrtdeuGJTR/jREWINg6EJJihigyybFMeUUw4o+TfverzDoyo7E9oxEr0IGyAZobnDbXY1FfXun5OgzIE2b9SI9SLmBTwMYn2KF7YZ07I6aIpQ0phgPZBtcY9NCguXg2sCZcbySVkeHM4DLxa8StYw2zcHB96esZXYtHqi1oWXTrUMOvCGe6U6NsqhDDAXF0IAPbGX8TVYZLq7DWzIJMXoQ9fHRPb7uO53m7AqPsn9aqbWUVXHIAetYCrFRmzy6hv6nTLpCAoVjU6vI81c/1VJRjWUQC5+SvhKSA3F4WfdP2rmfpvLD2hfiUmO8YsNdlJ22pIFGKh7n6jQmmjwGTJ/p9FsdUKoF5dtfsd3ZPUUT3czBXW0G6gZw8Ztf6g6iTK98l0Asu7d3iPn1jOlL0yj5BC57yno5NnfS8yw/xyjjzJ3jqWasgnwDDItWLOOmySwxp+e8qBJvIbRa5UVrkPv21tdULYalLX4N0oLQi0r0Ot8egW2Z80xhFwJqhe3oAjnRHzN6tqQSF+eTajUF+dxBVRjjePGb/yI+ykC7LfHHp8aadzFva5Lp7jLQRqk26H7XVx56HMSCrRjscNlzzi4h9h7Ns2NjEp+OHaltR7reEEEJ/u421mCxZYpIJI91gwnCO+sNz+IXcm0p55cL00b0R1Yh3BlGSVmXYxKQAD4l/XSZz7Gmkt+s2/eb/hCjRFDB95rhBqa/LEqh/bGwq8PLXCW6eV4AiIr3Tp3BwZVyJwRVibdkdkZ2UA37qJp+CesF9XjyCxv9c/R1ssD4aGXQPPjYbY4e/ecDPu5OlSE5PUF86
 EtYLnLfO
 cpQa5jE9TeWsizTYk8jteYyTUfeeUjbF2zOTclSRdAFzuNGXFOhOMbZ4zjrx9iIlLafMP8Wy38HguOgwDLM4Tlp/6cmM4DJW7PVfZQOMSjGuWFxrlcFpqtCpg7qZJpv+lu3M3g3T20pocyin+JiJZIBRzqSIU+vImNPgyFCtDOIBmxishv0j0qpCOz3pyZlj/RypJFse8tUtEF/8inktaQA7hJ81BmxTG/zjiIOYPstltk93DvzcqLWzDXhC0IkXYYN4FRmlLxSjDi9GePEP38JngP8t1KK17Qrv1nJ0DiEhAby2aPnvLMDfiOx2UZ+6MyPIOgeuMn3LTRIJerrij2gWszZioxqZS+b+sjrwD6olx2SE1fqam3Gpp1qK+6eWlwzrILc7S5ZQKt2U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-01 15:59:09 [+0200], Vlastimil Babka (SUSE) wrote:
> On 9/1/26 09:33, Sebastian Andrzej Siewior wrote:
> > On 2026-08-31 18:02:38 [+0200], Vlastimil Babka (SUSE) wrote:
> >> This partially reverts commit 2a8bb29ec9b2 ("mm/slab: allow
> >> kfree_rcu_sheaf() on PREEMPT_RT"). It was based on an assumption that
> >> local_trylock() is safe on PREEMPT_RT from any context.
> > =E2=80=A6
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> >=20
> >> ---
> >> Incidentally I have posted a RFC [1] that leads to replacing that
> >> kfree_rcu() from set_cpus_allowed_force() but now after back from
> >> vacation I need to check the feedback and based on this bug report I c=
an
> >> already see it makes the same bad assumption that trylock is fine.
> >=20
> > free_to_pcs() has still this trylock.
> >=20
> > What I am not so sure how good is that kfree_rcu_nolock() may allocate
> > memory for the sheaf if there is none around.
>=20
> Per sashiko review it's actually bad too under the pi_lock, because
> GFP_NOWAIT means __GFP_KSWAPD_RECLAIM which can mean wakeup_kswapd() and
> thus also need scheduler locks. And it's not a PREEMPT_RT-only issue...

\o/

> > It could have a pool of X
> > and if it runs out, it runs out and waits until the clean up process
> > feeds the used sheafs back. There is fallback and the run out is not the
> > usual case.
>=20
> I'd rather not invent new pools, since there's fallback and the sheaf+barn
> is already a pool. Could be enough to make sure the allocation attempt is
> safe, i.e. use only __GFP_NOWARN.

So we avoid the allocation and just add it to the sheaf+barn and this is
it?
=20
Sebastian

