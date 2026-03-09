Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D0EFEFCD7E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 10:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 925946B0088; Mon,  9 Mar 2026 06:14:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A8C56B0089; Mon,  9 Mar 2026 06:14:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B5086B008A; Mon,  9 Mar 2026 06:14:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 67D846B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 06:14:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D6241CA7B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 10:14:31 +0000 (UTC)
X-FDA: 84526115142.23.D1D5D4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 64DF3180007
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 10:14:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="L/PqedoS";
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773051269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r1A/B2V9oYwqQeNUfJ3xgxA3sYULf5R7588uiOvgxvg=;
	b=2zb+YUr2RgPawPwA583F9iss2LlqDapVWPje6pDvhoRFVdKB020P0Y6eJGuvyZn0sDZfWG
	FOvOniJkweloxysaedTDriO4HEJ9B4XeUnWApGYIifsgQXT922/ygIh1iGFfD4SWC9Xw1C
	g6y9MI35LAXdZZHOpFFccqGYtpMUr5A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="L/PqedoS";
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773051269; a=rsa-sha256;
	cv=none;
	b=nfRjFlU9eJBufhAJxhhdbrE2YkGpeTohnHbZVbLfdDw7/QY94fchIB4h3rbb9AiToLIuhG
	Tr5/8jBkab5p/xClNjoZSXT2j6hi58VZL1w+Jrf7ToxZOP9cvD31d6X0jDGdukHyu7T+iP
	TydQs64dRsr93Wsszae/U4krshGlDgc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B522860121;
	Mon,  9 Mar 2026 10:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7951C2BC87;
	Mon,  9 Mar 2026 10:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773051268;
	bh=V662xA+76lB3fhjzpS5QjhyPX6dzFJKN5cNCAOQWGYc=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=L/PqedoSDMQ56DlVwOPbKyWJmuZXVfQzdQ6S3EjyXnTLEvJczQj8WtTnQkuumA2G9
	 FO3CWvW1HPa9fvZcJAf5j+cQ5/2ZBnPh3/8YyWE/9Cz9e1i4U71+Yy/Tq5Q+RLPdro
	 +vbbob63qYLKQ57uWIq5U/W5Eosy4ZRks0UG6CXWpuYcZlxSRy+DCCZtfJVtwQrTuN
	 xIVpf1ymHHCZVsjVzwC/tDL743H9+4GuWkEw0VyGdXAK6x1NnS3eaZKkwp7khHz4Li
	 G5bmvSDFoswoQCW/e8Mh8xlljz9V7DlBPtFuZ2wRq1+jVjNbHTyQdg41PIWj2quyt4
	 O07R80xUObGKQ==
Message-ID: <477bf592-489e-45e6-a386-6b3fdb289c39@kernel.org>
Date: Mon, 9 Mar 2026 11:14:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH v2 2/5] Introducing qpw_lock() and per-cpu queue & flush
 work
Content-Language: en-US
To: Leonardo Bras <leobras.c@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>, Waiman Long <longman@redhat.com>,
 Boqun Feun <boqun.feng@gmail.com>, Frederic Weisbecker <frederic@kernel.org>
References: <20260302154945.143996316@redhat.com>
 <20260302155105.214878062@redhat.com>
 <682380ba-c8f3-4023-928c-2152e934f8db@kernel.org> <aacGBc9x+zn1tluU@tpad>
 <aa25OmY7HlbU5kDV@WindFlash>
In-Reply-To: <aa25OmY7HlbU5kDV@WindFlash>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 76mnqrtxkrz1uezsd4trs7x3r1thkbid
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 64DF3180007
X-HE-Tag: 1773051269-555992
X-HE-Meta: U2FsdGVkX1/ghUgMjuDjGuMNpymlTFFiWadkzch6h5OQjp43mlXdYU9eyq66otP6pGzZj46IV2HFIBsoXVi9Ye7g8EFIW7NMl6XtUphgWkCf9ovOH3p8XyveWdpfLGvxoXwjxyG5/5Ik2x0f5LS5e+AnablyUFcjZP92sNcTihHQ9fMkefrgKd5vLwZPsSpmyeaGVzEhNXu0JZxHEmkf53gtt+SfQIdpwFexDmj52+wvxo2We0u1HpRwEwIB701D5Ezg+TxuW7Sfk4CpBhhXNONU01jsf49b0lTz75iNFMLLwDGdGrFfQHPGQ/tdL45UziGT00anTAsM9V9gDX6hAtsSV0HaITFP//Q8FDUMBWGbnpEiWuS1N5uhHX/NTIsttxHQdx8j4qERraAXsbX57T49Ew6NCfelQx8ljwK+VUPrxFt/oN/zSGfERKeTPl7GTBwz6D7+1RY55SwPW01JHoOekcudIGLOzULww7ieJw/Qnyu/hNx4K5fCNKh9R12fmdbZF8dWkPQNjaI7DDWqfJRyTJxDUD8EBCuC4g6Fwxr6DSvmoCjX1gzXlCPuskPYiOEMy1PafKL94fbd4Xn5llvOcFFgAknMwBbeRcZofA31cq5PDyiE7u+iXkfOfPdxFj450QlpVX1eG5RBqOXRLDoK1VOVaJcx4Brtz6gEL7GHiVgGp2O4Q4J46RP5N4YuGiMp3/NwYhhCFpuK0rEz0Vp00K/mp3j2HoPnu2F/bxPanYHngEfr5bVKPv7W4HFgP1g3O5AB7MFtexTC3X7RW/qzpaaW4/4NaWGzRhlQBko2TpkdGhaSv+lPsz+eQ1hvi4UO0UPqeOk4BNpcEML3RRsgQxrUvP6s0h3kf+/anTwQxxo/P7WQ7XB/8d5dvKrqYhJKf/2rC7/Iy2pxzoSflPHqy4ovAuupBe3C0jqx8E1WMF5BbNu7afRx6xY+jM9lAF0lVCWR2iL+eZCW80A
 NRukJljz
 nJAgaiD4E+R53aEcsRkM5D4Fvdum3ut5Efcqs8MIAE1kVlHnHbHGnvgVnp6OP7sv9vZqsSfJZjw444YMXZ68dFv+hu+A28wGPUnUlulh3FgRIgwtRpKmLY1Vex2jB93Fy9EmlZpBfrukTVTeVY4dG8betm5nLq4gF5YLdDnA8TN3KjaS2UHY1m33xc4U66juxbBTB0wja9MOFK1DqfclKm8eGM6nBOn88K06gMve1iKtJKr5v95ay4q9FZR8FL/mGOqc/vWufAbD7LAGDKtRgAzWYuaoYWhliPvs/VJqkLLkcuchJvhM1ahSqIgjcFXRatGuzoPmUyVYpvWDzEqESzM7zgrVtXgFdp7C5VvFGS5myEY6UeBW4k7ZI+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/8/26 19:00, Leonardo Bras wrote:
> On Tue, Mar 03, 2026 at 01:02:13PM -0300, Marcelo Tosatti wrote:
>> On Tue, Mar 03, 2026 at 01:03:36PM +0100, Vlastimil Babka (SUSE) wrote:
>> > On 3/2/26 16:49, Marcelo Tosatti wrote:
>> > > +#define local_qpw_lock(lock)								\
>> > > +	do {										\
>> > > +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
>> > > +			migrate_disable();						\
>> > 
>> > Have you considered using migrate_disable() on PREEMPT_RT and
>> > preempt_disable() on !PREEMPT_RT since it's cheaper? It's what the pcp
>> > locking in mm/page_alloc.c does, for that reason. It should reduce the
>> > overhead with qpw=1 on !PREEMPT_RT.
>> 
>> migrate_disable:
>> Patched kernel, CONFIG_QPW=y, qpw=1:    192 cycles
>> 
>> preempt_disable:
>> [   65.497223] kmalloc_bench: Avg cycles per kmalloc: 184 cycles
>> 
>> I tried it before, but it was crashing for some reason which i didnt
>> look into (perhaps PREEMPT_RT was enabled).
>> 
>> Will change this for the next iteration, thanks.
>> 
> 
> Hi all,
> 
> That made me remember that rt spinlock already uses migrate_disable and 
> non-rt spinlocks already have preempt_disable()
> 
> Maybe it's actually worth adding a local_spin_lock() in spinlock{,_rt}.c 
> whichy would get the per-cpu variable inside the preempt/migrate_disable 
> area, and making use of it in qpw code. That way we avoid nesting 
> migtrate_disable or preempt_disable, and further reducing impact.

That would be nice indeed. But since the nested disable/enable cost should
be low, and the spinlock code rather complicated, it might be tough to sell.
It would be also great to have those trylocks inline on all arches.

> The alternative is to not have migrate/preempt disable here and actually 
> trust the ones inside the locking primitives. Is there a chance of 
> contention, but I don't remember being able to detect it.

So then we could pick the lock on one cpu but then get migrated and actually
lock it on another cpu. Is contention the only possible downside of this, or
could it lead to subtle bugs depending on the particular user? The paths
that don't flush stuff on remote cpus but expect working with the local
cpu's structure in a fastpath might get broken. I'd be wary of this.

> Thanks!
> Leo


