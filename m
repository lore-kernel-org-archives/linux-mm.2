Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5550D606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EXUa+MkZ
Received: by kanga.kvack.org (Postfix)
	id 6CCBC6B05BB; Wed, 18 Nov 2026 10:46:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A7876B05BE; Wed, 18 Nov 2026 10:46:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BCE66B05C0; Wed, 18 Nov 2026 10:46:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38AC26B05BB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:46:54 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C12AE1C3CB1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:46:53 +0000 (UTC)
X-FDA: 85448667906.06.B00F8C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2BD331C0006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:46:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EXUa+MkZ;
	spf=pass (imf20.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795016812;
	b=TulRqm4bRJ9VWfhkP6Csa3J6unWF+3Zw1HSmVVr69CNzEGRHrebdxy0/8r+dM9z8lHd/HH
	C1KyyXLGcEGp3N+ObReqUNIPq6aprlRCSxirbxpY68xa48Ot0XcZgIJ8hliJ8N+J1X/zBW
	pbK9aRKHHPpsuf7kaLvFUtrAuNI84Ts=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EXUa+MkZ;
	spf=pass (imf20.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795016812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yq7h0/bdeIgVdHwxIZvW/WAXXX6JzsrZsXwYUvWhQj0=;
	b=aEQ5STCJ/DizPJ72OVdQkshGMBzXYi4KZRiENiOPlcbZkI3VPHraXOXiPflDO5vQjuAVUm
	hek/LgVAeOOKZQQJQIrWqkwrlrLFLVx3G5dTAkF0gE60BcPpp2/5VE85D2531MCw+LG8gW
	NsJ8VH5M3LdA+JSAMu/EilP0jbanJQM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id A526F62586;
	Wed, 18 Nov 2026 15:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AD8611F000C4;
	Wed, 18 Nov 2026 15:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795016811;
	bh=Yq7h0/bdeIgVdHwxIZvW/WAXXX6JzsrZsXwYUvWhQj0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EXUa+MkZ8fF06bmTmwLNd20zxEY9MBiiXX3/inLnec+f3eiqv7AFpfp0RH1t8WMYg
	 07CRxJbvqQzFs79L2fxYmiB+GR4+a2juvf3E/xr2joNJED6DqFsGIRBDrb6+B2ex4E
	 sg6324IqU/NJun40bRWU9DIoQ3Mo45I4I9aqgNnl26gSlTAwOU2rfIBT3J7mwlm413
	 UJVrWzSWKUooQDs+lkwH4rZclpp4/PrgxpZq4RUvzVBa9Zs21JNDTqT58QxIZiaVTm
	 FXz1sMD+7Og8a/cFS0ljKI59wReWg936/UQp9l6X3OLAdeUDi4zCHOdxxm9cSZA5GW
	 Ra3dfEdI9ZjQg==
Date: Wed, 18 Nov 2026 17:46:47 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>,
	alex@amutable.com
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
Message-ID: <av3IZ_ZXKJWHdAl0@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <wdwc3b5edgtgvrgqfhlzhrachr5hrqb7ahipcuqdz5pffxlc5b@662cpwhxwjer>
 <av3EBpSuzn_TcrDk@kernel.org>
 <av3Gv3MwP40bqvnG@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <av3Gv3MwP40bqvnG@kernel.org>
X-Stat-Signature: pq5fnbhimm6garr3o4yc8b45y56q3fkr
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2BD331C0006
X-HE-Tag: 1795016812-546413
X-HE-Meta: U2FsdGVkX18KFXxcXhDFN2IBzlxAKnyjEAGh7cGzzqU9AQGubPO6uTYYcH+fjtZM0vfFw38Hq6cLY1dZpy7EEqhW5WzybCQtQHk8G/8M7C51M3aPW3T5Sw61x+qE4NX4uK4nqDFVQOkur7haZBQSaEHHLeOf/bY3hz4eWRemhq9WPkBgyv5b0Zx7DL7in1Vxskv9u2ED9cxAnlc7jW/CouKKELWocoZ7l19x6cm+7Ka5TplgIe5wkFCyidfpO0olyxsgxvP1k7/bMeTJDIOb5KQW6l5RDRQoEoOfx9lSnVNloDSbSto5Vwk8+QnSJqd9mTYmOIS462U2mLrJAkkbe3wD+OGNQiyLi4+LTEKfu2jRW5uwJYdnjbU6jEmzjmQmNKlWX5uuSGDWcEEMns/K06vGUwnQ8wJsTQdYeKl02kmArcmftpZHloJnnf5a4s2Y5yxU3HpI57VKLCtUm3bmKuvfBR6jSQL0GMevFbfj3Oi2iX7O7eO5UPYU5/OXQBaIVbWpSmi/qnRYx0TaFYEj902DPAyoY/WE4T6A5fSFWyhNsegC7FjeGv6OMfschiGQsQtxP8K5C8Af0iH05G3CFfXhcFvoupYr1dTAll/onKSL5iT4PhmuDs/ps1/iYGubP/h/Fn8AhMOWQKeY/ktWDjhIPEH41FTILDKqqkuCkKr5ci59MGaS5K4r2uU5h++2h8VrisPEVHpKvgg5h157/RAg1OynqILjo/O/aLH7hn769v7pCFnIbdgC/tyE+gWCdSqxZvhaynlh+AYGeBB7e8HekvRsW+CBkj/RCB+SPrG3rKAAGm8bCjq2NNfh3MTDpNyJ6ADch+Kd9/aD3pXkRa/2ucnIWEfoVvnTr8RGAFp6r67nWQTZCnleUnKei6fIfxoaHX7hu7+jpMcTsVq46+P2WTz6h95v7Nx4Ullp3JdU2PRZfU1nkQH44gEe4DW4Jw2Kp12kVkaWhl1+Yyx
 ULtY/X63
 gWRtf+sbz4cLR8yXR1aOFKdarN8d82Uq/KLRmc26kf1S7GoPXGYtwb8SI6qj1K26PrZtrwUEsYeBaAX3PQPi/tRGqzZnAWcUqep41jtkyAnAhTGl9m5UztwhdUPykc+KKr+XHJRN0gY6GTg83RJ8PV96odGIu4ZAB5xODIESy5hC9xaxPGvuP/+k31MrYwNPin8ZDg8S1CIDvfwaYgWBW96hqtqbJb6K5Fl95+u/B2SFW30PaDaBtHLPR2GxrXXXbd7Qu2eA6PE+hnu9JapMbk07npw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 05:39:47PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 18, 2026 at 05:28:10PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Nov 18, 2026 at 02:47:34PM +0000, Josef Bacik wrote:
> > > On Wed, Nov 18, 2026 at 01:13:39AM +0200, Jarkko Sakkinen wrote:
> > > > OVERVIEW
> > > > ========
> > > > 
> > > > A root namespace (rootns) is a kernel object backed by a file descriptor
> > > > that binds together:
> > > > 
> > > > 1. A full or partial set of detached namespaces.
> > > > 2. A dedicated PID namespace for spawning processes into, signaling
> > > >    members, and polling or waiting on PID 1 exit.
> > > > 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) that must be
> > > >    populated before going live, without inheriting host mount-tree
> > > >    ancestors.
> > > 
> > > This is what cells is doing https://lwn.net/Articles/1102593/, you may
> > > want to take a look at that work. Christian, Lennart, Alex, myself
> > > and others are working towards this in a more wholistic way. There's a
> > > lot more that goes into this outside of just the object itself. I've got
> > > my version deployed inside Anthropic for securing containers and I've
> > > tripped over a lot of pre-work that needs to come because we can tackle
> > > this. Alex has my rough outline for kuid64 for example, which is
> > > necessary for making sure we don't overlap UID's on the system and
> > > create holes this way. The cells work/anything that wants to have clear
> > > security boundaries is going to require that as a pre-requisite. If
> > > you'd like I can include you in our planning so we can get something
> > > that will solve all of our problems. Thanks,
> > > 
> > > Josef
> > 
> > No it's not doing the same, and this why I sent the patch set.
> > 
> > I don't see cells fighting with rootns and given that rootns has a small
> > surface and it leverages already battle-tested code, instead of
> > reinventing the wheel, it also has benefits. It neither doubles the
> > number of container frameworks in kernel.
> > 
> > What I'm not claiming is that this is better. I just wanted to fact
> > correct "this is what cells is doing". It is not true. It could be
> > better solution but still that statement is untrue.
> 
> For better or worse, cells does a lot more; just looking at the patch set
> size.
> 
> For rootns one can point out with a finger its possible problems BUT here's
> the thing: it does not haven unknown unknowns. Even if cells had less
> of known problems; we have zero idea what will come up if that ever
> lands. The possible consequence have less predictability.
> 
> Also, as per integration, they actually are not fighting features, as
> they are in different layers. There's no same thing at all.
> 

Yeah, and there is no obvious causality either that would result a
zero sum game. Rootns is something OCI runtime, any of them, can
quickly adapt to the existing framework. Cells takes longer, but
could be very worth of price. It's called "defense in depth".

Br, Jarkko

