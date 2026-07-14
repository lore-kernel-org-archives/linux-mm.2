Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88F14C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 09:48:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906996B00A0; Tue, 14 Jul 2026 05:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD596B00A2; Tue, 14 Jul 2026 05:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F30C6B00A3; Tue, 14 Jul 2026 05:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E07F6B00A0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:47:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC00E1C02A2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:47:58 +0000 (UTC)
X-FDA: 84986905836.20.B6BA9E2
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf22.hostedemail.com (Postfix) with ESMTP id 25181C0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:47:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=2hWoWkG4;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=LP96mIHU;
	spf=pass (imf22.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784022477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bsoTcN4gOIUfOGf3p48bZzeZDJjL/YfjT1YTWmmpNPE=;
	b=2Knb/DaqAzNK/+Nf3WEmzCWwRPM/dlzPnFwoN16xqrQGTzWHVSouYpvdSEm8vCQwvNRs+0
	2Ah54OaojIXzQHnPgDyV0WF5z5HFM3OXq8XAwb3qvilfNPcZ3lAwWLSzpd9n5NEPfbYt/c
	qtgXwTBcMXPnz27idIBrof6epuCzdCg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=2hWoWkG4;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=LP96mIHU;
	spf=pass (imf22.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784022477;
	b=aL52NekVxkUMwCMRCxx4c/wcjEeUxBPYz9ajGVQW8iThopWRnGwEJpLinO8xWirJog1Qsq
	zWDMqnU0WxrI63Khk7zxYG6bR++VIbi6yLZS4gZ7YjLRT4RTWq8SbG5aOgVU6fVEELQkYG
	khCHqcjAOz7abGAlMB0ANbnxcyzs6+Y=
Date: Tue, 14 Jul 2026 11:47:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1784022474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bsoTcN4gOIUfOGf3p48bZzeZDJjL/YfjT1YTWmmpNPE=;
	b=2hWoWkG465yKctF00Mw9KQ6sYZmw5YgJznP4SIGc5ImYPXmIYeS6IbfXVTCZTHv/KI4E2U
	f8Bk6aFvBq49FugZVTn/t+nTwVk3uOjUb+xLzqQ1ylaI4YuaVeQfW1h09gVtK/zATFk1TZ
	KoCxwcqYpF9YJ4jj1zLGKjJeoB4MSxGtc7Va4jbCSzz0ouoQjupqRadMZCq1GBawg720Bl
	pdo2Ck6m0mFasT7WVF1Iqf3WadNyYaLzwhhBu6WdOkok08jY6fpQ8fFG0EBD9iG9UOgs41
	BW39orBcuHa6++UhOEQPMc52HNKuWtZFgfJ6Oa6qJIbZP2toU8fOyfn2K8UUUQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1784022474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bsoTcN4gOIUfOGf3p48bZzeZDJjL/YfjT1YTWmmpNPE=;
	b=LP96mIHUFuA16DNuxJK0oAMY1HLEt9nhBrM68LGoz5RXQeqSK/DTieqKA8U5nLiTSEr7Ea
	k0NF1Gm40CLZW6Bw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Leonardo Bras <leobras.c@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>, Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Coiby Xu <coxu@redhat.com>, Masahiro Yamada <masahiroy@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4 4/4] slub: apply new pw_queue_on() interface
Message-ID: <20260714094752.1Vi-C4fe@linutronix.de>
References: <20260519012754.240804-1-leobras.c@gmail.com>
 <20260519012754.240804-5-leobras.c@gmail.com>
 <20260520145308.nay9zt6r@linutronix.de>
 <alQWr2L_Kn23pxd9@WindFlash>
 <20260713073634.3Hrxpfcx@linutronix.de>
 <alVbaf-UVMNaEtvk@WindFlash>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <alVbaf-UVMNaEtvk@WindFlash>
X-Stat-Signature: 43csotkny7y9bup4s7xgw8f4j71o6c67
X-Rspamd-Queue-Id: 25181C0005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784022476-539713
X-HE-Meta: U2FsdGVkX18Exz6UC76zRnK41Ui8qA1fAvuWQGBw6RQNlZm+juacV8MUO6svQ78WR9VbX6cUAIepVH2sovLrIRUsO1Y4dLTglXokPMKWapCJaciVz9+ZsIuWPn3X2WAk1dEwoR+xunDtxiMx4ebSXFZoOwV5zD39I5prFzxc5lyIN6vX6MkocRr/QVb9HZNZvfXHjTqwWGNKIZ6xyemK/nFzFudukjJP/pOwWiOx9V+YWNO+GUZNrB6upsySZFR7083j+VabOc9d4YooIffeUdibqG0KKYjUaWsVDyy4bkVXVdv+ckXPOgCStRw7i9X4c7tcBNjMsCvdtabFoCPl/1FM3KP9x6CQg/Q93JqyZmfgLjZ6TxcEombEtA9gOCtuC4mMnsqzdDcFhKP7AZ9oyRKujK7WDxf95HivueTbDKawouv+W1qVZC8GMeMv+cyV3IbTms0A+oK4/QThCluQpJ9FZZXcq26QH7iwCu1YrBuKEavhyWp59QCcKe7VH9S4CCIOSqaR9IPtx2KsOCWIm8ods4poKGYifHYksnH42wNvH3y9nk23rL4OdINLBTknmalyg5Ls1ZYlVUomIpcAmE5U4uAN3NlgihTeINRq+cnP+cDqOCDIOLhgWGtXV83nSitsIRzhTsJgRgc/cShu72Dghxe9W9AkTCzInxPj13F8M/WF9oCJ7nIKtG2HB27X8qk8E+s1u5lkZ6RdSIPh9dgPLMDkO1RA0QfjCU0Ed96MUaytqmUuZlWP8a752XpYLOl32uV0XVQmnXnZonulheyUhXT4fC4ZN8QBqJUvzxkQQaPxejvdW+8hhIw4USf2ssF9wiuIZuaUhnFpQZW+cu1zb5eJVe8x0Orb6zNZVkcToDABHzEWCmT5fKcS1kfyKi6Fm0TxFOS3r+bk+VLcFudglSmFS5PO0Mh3sNhO+XRWRVGvAtz9kzuNDe8oym8cMPK4sU0H50XF20LHj2Z
 i7AMHk2F
 BRBjFhh+C4GtiJb+508Xf9+ExGlstPtxaRZcP120Q90IUwdL2t+Sn7FZSHblojjtcuKsP6Ir2J/WLUIBVB4KqUVKZBHby1yRxEp4Cb+iFLsQ7HqWg8qCH5JRCwUXdkvqoKEkJYG72E5TngFu5R0UUU57rBy4hPRMHPEvIwOo4Ggy0BYCjC7/vWvkW10k1Zq8MgbtY0B620dfRrgj3cAADNon+iP6/LcGTtuysYshiR2mdxw+r9NUWAk5rlfmBPyhTZ7Zh91KbOEDm9cTM//RWmc5Nm1ujA410LKLsIfq6hxWcrPyiainzAngcMyQAVTXMSAOK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-13 18:40:57 [-0300], Leonardo Bras wrote:
> On Mon, Jul 13, 2026 at 09:36:34AM +0200, Sebastian Andrzej Siewior wrote:
> > On 2026-07-12 19:35:28 [-0300], Leonardo Bras wrote:
> > > On Wed, May 20, 2026 at 04:53:08PM +0200, Sebastian Andrzej Siewior w=
rote:
> > > > On 2026-05-18 22:27:50 [-0300], Leonardo Bras wrote:
> > > > > @@ -4733,121 +4735,121 @@ void *alloc_from_pcs(struct kmem_cache =
*s, gfp_t gfp, int node)
> > > > > =20
> > > > >  	/*
> > > > >  	 * We assume the percpu sheaves contain only local objects alth=
ough it's
> > > > >  	 * not completely guaranteed, so we verify later.
> > > > >  	 */
> > > > >  	if (unlikely(node_requested && node !=3D numa_mem_id())) {
> > > > >  		stat(s, ALLOC_NODE_MISMATCH);
> > > > >  		return NULL;
> > > > >  	}
> > > > > =20
> > > > > -	if (!local_trylock(&s->cpu_sheaves->lock))
> > > > > +	if (!pw_trylock_local(&s->cpu_sheaves->lock))
> > > > >  		return NULL;
> > > >=20
> > > > alloc_from_pcs() can be called from kmalloc_nolock()/ NMI context.
> > > > I don't remember why exactly local_trylock_t was introduced here in=
stead
> > > > of a per-CPU spinlock_t.=20
> > >=20
> > > Probably to save the cost of using atomic operations on locking, and =
having=20
> > > about the same restrictions that would allow using local_locks
> > >=20
> > > > But there should be nothing wrong with a
> > > > trylock on it from NMI as you do here.
> > >=20
> > > Awesome!
> >=20
> > The problem is always the unlock which requires full locking and is
> > usually the problem from NMI.
> >
>=20
> You mean, like, the trylock succeeds in the NMI handle, does the per-cpu=
=20
> operations, and then unlock()s?=20

Yes.

I'm not sure what I was thinking when I wrote it back then. Try lock
with local_trylock() might work under RT from NMI. However the unlock
path (which needs to follow) requires an unconditional lock of the
inner-lock plus a potential wakeup of the waiter.=20
:
=E2=80=A6

> Thanks!
> Leo

Sebastian

