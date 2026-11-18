Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8256C606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ai7InkSx
Received: by kanga.kvack.org (Postfix)
	id 6A06E6B05C2; Wed, 18 Nov 2026 12:08:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678616B05C3; Wed, 18 Nov 2026 12:08:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58C746B05C4; Wed, 18 Nov 2026 12:08:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2ECC26B05C2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:08:41 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1BE15407EA
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:08:39 +0000 (UTC)
X-FDA: 85448873958.23.123962D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4CB4014000B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:08:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ai7InkSx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795021717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zINOi7QPXEvi98cbqP6TjwwtqfWoUArKawL5JYAavAU=;
	b=T9rwQ70wOOlNVLIiBH5cbMQYiSGZZvE4nbgrnV33e/RUrqmL8RkQ2HUAfNIEeyubaby2j0
	d82Zbogxr3ZryYMCtqEp/h+OP1M5i0zV62Z+MUZ4qN8pAvxQRLWBoA5i0NPMN9QwDbYPla
	lDMKj5dyMpi8vfPpS2KW1BBenAqRZEs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795021717;
	b=7Yof9RkcYS8TdjyVhvafauy+GgmARPqFpWffqE+C+GLYLgZtAJ8AlWdR0+UHKPJA2hbqxh
	46LIw2oUPsrrEKVuyQUGFa00TiFXL6OY2Ay1oRgx109ow9eAFvtoDkLsODdX+73kHWGWXI
	0xMR2bDxBzLUGTa6lrv/WVDpcA+pNGw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ai7InkSx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id D3BBE625DB;
	Wed, 18 Nov 2026 17:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CEC651F000C6;
	Wed, 18 Nov 2026 17:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795021716;
	bh=zINOi7QPXEvi98cbqP6TjwwtqfWoUArKawL5JYAavAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ai7InkSxjpjgivgeXU6eK1BzM9SMFaBHZ97FKtVTgzZrgbTvyMLm/yoQ5iDK2F15o
	 iTRkDOM5FMMC7Su4PQB1NNwWaeJVN/3Q/mYacYUCeTZRfLZiNbc0Psa/woPxI9priV
	 o794AiIxzMMqwmGdfxK1sVY51lnnoLeRxopyMxm3Fw2Wn75jZxgMjWDWGbfvJwR/F7
	 55uapbzqrx1sE6psi4VAyHUC+D/mArx5ooB7wwR90Jm3Q5Q2x2m32mx71CpDNud7Ql
	 0+EGSljYTSewzaz+DAbOKH8by3wxtDmKxsjPI2frMrPXcPdOdqYqLiNXz6oTJsS+vw
	 QjKJcR1CdMiUg==
Date: Wed, 18 Nov 2026 19:08:32 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: josef@toxicpanda.com, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
Message-ID: <av3bkDnwmjunTleX@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
 <av3akYFOYaeQZauZ@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <av3akYFOYaeQZauZ@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4CB4014000B
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: gop5gwmdmeyhcwh5qaxur6z44at3u3zw
X-Rspam-User: 
X-HE-Tag: 1795021717-222537
X-HE-Meta: U2FsdGVkX1/EpEiZn2G4SMn6FE00qNQXb7AhuOryRChVIJIcWoYQXXqGb36U5N9l35Mz2SUkuaGSnGn6S9tf0647teeCpJlTVE2EyGfQaOQPNxPrPHnMOZj9Tx6eWdM+Q4V31ltKuBU/gsJWH7A2bWpkMN9r8UCBQchz9/IVusFHqyfjX4/lL8MJh7NaAyhvxnzgGQxfkWuSUruEn5Ee2rrJ+2z02OunJurw8bvuFb16BZmQ0SfNXTXrp5WxeKUWcPRuXuhgGz4Tf0cyU6YxFTI7Y+vM+ORhnaOTr5MU33lU6uSRr5atz23WslTUyrfKKh4nZ2eotRLOw1Gsn/m3IdKcEkRqsmlW1RDM2oADLTW8fGGRHxtd+OwrKWs1qOcnnmlVwyeT/xo/b/5AkOdEXZn3+aE3Ufc5ybpKPwa+LPFKlqQNOD4nnsKKd29SYMFFZ+DGPwUE4xXVizyj/6yNdfweDhIbScNJg2ztBdt0MBQHqR8ZEZBHrHx9T3W/7fNdjuThsfil7Xdldr1hkZTaxis3+weJVe6o7ACQchx3VNpunDz3xtYRQZY81AiRNnVjVgUisuVz6GYnQR5nqG2CD+mp1YZSuEafTIKc5Tbbe/uEEQKhfUtp6JKHDLU+cDMCWaS2TffLhvsLNlHS9bxgrIcSii/EXa1LhgNQD5afSVZXuS18Sp7IK2YA9WiMPgfAcjTYlOcOp97+eCURNIaq65Wy+VDG3O9LDQi+BSaw204Hb2AjWE+zKmwy53QxQTFU+ieMW0vIdr6L/3v4Fbo6+Jfya424MwIANKUJG+41sCabs1gP7+6MIOkAYn1PI5mBIdI9fyglRch8gAxdVnfpH4ICwdo5uTw9Ee/TFFvfgJC+SZFS7hmykCUO1Z12agUOnmptWgOXm9RfmrwdR1jWbw9XUhadL2jG0s6wHSLQ0T9MMkJZPxpQtHp3WnLlmqa1vhcx6YSLQxHbzpjc94/
 C3VMpxiB
 iweSMR4L2Xqrn3qfpCOn0Kx3wOYLOcUD0H8/gzcB/XguhY1RAqPdptRS9SEOu2oCSput6UjP2otb36vpZZJ7i9J81LTgPSiOBss5nngg+lPFy2yziROqQevSShOcKLfZaCJ54Pd3neQy3F1erMRRsbNnG5amWDTuWXPOJeP+J3Ducw5SMAcrSycDyvgaxJCwCj5V2D62sxLrBrRfguPn8PgpWLHTi0zt25wjPyCMB2lj8HcYcA3F2QE1knV5F7uUCS/KC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 07:04:21PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 18, 2026 at 08:59:39AM -0800, Andy Lutomirski wrote:
> > On Tue, Nov 17, 2026 at 3:14 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > >
> > > OVERVIEW
> > > ========
> > >
> > > A root namespace (rootns) is a kernel object backed by a file descriptor
> > > that binds together:
> > >
> > > 1. A full or partial set of detached namespaces.
> > > 2. A dedicated PID namespace for spawning processes into, signaling
> > >    members, and polling or waiting on PID 1 exit.
> > > 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) that must be
> > >    populated before going live, without inheriting host mount-tree
> > >    ancestors.
> > >
> > > Work on this feature started in 2025 from David Howells' container object
> > > patch set [1], which I turned into a namespace for namespace roots and
> > > rebuilt around that premise.
> > >
> > > While the patch set is manually written, the original motivation came
> > > from isolating LLM agents. Running untrusted agent workloads made it
> > > clear that OCI runtimes need to minimize their live configuration
> > > surface.
> > >
> > > Assembling mounts, credentials, and namespaces inside helper processes
> > > with a half-configured container is what I see as the main challenge,
> > > and the existential debate around namespaces and container objects is an
> > > unfocused discussion topic.
> > 
> > 
> > I've skimmed some of the series, and I see a bunch of good ideas that
> > involve using an fd to manage a thing.  But I'm wondering how much of
> > the value is added by that and how much is added by having a new
> > *type* of thing: the "rootns".
> > 
> > How much of the value comes from the rootns vs the new APIs to
> > configure namespaces without entering them first?
> > 
> > For that matter, the cells series also seems to contain a (possibly
> > very similar) variant of the same thing.
> > 
> > Would it make sense to come up with a patchset that does *just* the
> > configure-a-namespace-by-fd part?  It seems to me that this should be
> > an easier thing to agree on, and it's a big part of the complexity of
> > all of this, and it solves a real problem even without
> > cells/rootnses/jails/whatever.
> 
> Is it  more accurately scope the part that is "just the fd-part" and
> what you consider as "extra cruft"?
> 
> I.e., where do you draw the border?

I'm asking this because I had similar thoughts when I started this back
in 2025. David had some good ideas but it did more than having a fd
that does not go live before everything is set up properly.

Then I thought that, I guess people who proactively on the topic do
something more lean and compact, and never sent roonts patches.
I'm not seeing anything more lean and compact.

> 
> > 
> > --Andy
> 
> Br, Jarkko

Br, Jarkko

