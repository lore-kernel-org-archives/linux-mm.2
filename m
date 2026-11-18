Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B51160A2629
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QL9BK19y
Received: by kanga.kvack.org (Postfix)
	id 931136B05BC; Wed, 18 Nov 2026 10:39:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9088B6B05C8; Wed, 18 Nov 2026 10:39:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81F896B05D2; Wed, 18 Nov 2026 10:39:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 62F9C6B05BC
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:39:50 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED65EC07AB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:39:49 +0000 (UTC)
X-FDA: 85448650098.25.CE790CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 414C714000B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:39:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QL9BK19y;
	spf=pass (imf26.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795016388;
	b=3rH3X7ojwqVPQpKe8XBFaHKxwABfyH/vDt8Wk3zu7Quy7eberjBxXT7fBJXXaAibOKhvhY
	lWqLWgfGld5xMn3fzsfRsUsQtm2oLBvuvv7n1GaS4JTClUjgEF4wvUnc7iNnyKWiAhH7BV
	18z6hpNxMJelwWEK/Dh0TN9JzaskKOc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795016388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+05d7QYBTtK1JZ1EQU9jtzeT6f65KemfkCy86aAw/hc=;
	b=6xhL8Ky5ftzSXVwwm3TcwOgsxMNHdCzZ2wah31nPm1g+2TQNotqBwyJ4A8yWqWJS5osnQQ
	Qlin6mp5q4OCbbhm9svxNViiTbR67kLn3UUOmnSCOlxjq1+4dwf9GUg57KtD0yHaNkEtKp
	A3d29RT5w9xJXNmhwJrcplB5sJxxjbA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QL9BK19y;
	spf=pass (imf26.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 7E6F043733;
	Wed, 18 Nov 2026 15:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A1F7F1F000C8;
	Wed, 18 Nov 2026 15:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795016387;
	bh=+05d7QYBTtK1JZ1EQU9jtzeT6f65KemfkCy86aAw/hc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QL9BK19yEFO48QBM8Oed0W9oi92dO17PMdCUfI4Ave2mN8VCby8UeUADTDtlBlnhl
	 8956S5U32BRlMxLcxEy6IAMqj9bT2tV2nflNwCBhCavrWkNEoQkheI2gLQvRKTpI8D
	 OZYSUCXLOErgiBwyPwpylot9xQFP/t/vCgNg8r4flgC0gqU4eMWbyhVsOGh1EyDmdT
	 AturQVWjzfd6JHA+/q4WxYoguSu3eaa6rEnmd+YHCgTTQhv/n26rd7Wd7ZKXXpuZ4A
	 bPwYGWM6BkAgAblBCTxgHP1gaY/o5KKvkEmIc2++SxtdNNn83/E5nsgC10+wJUhAdr
	 VrrU/x5wTXzoQ==
Date: Wed, 18 Nov 2026 17:39:43 +0200
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
Message-ID: <av3Gv3MwP40bqvnG@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <wdwc3b5edgtgvrgqfhlzhrachr5hrqb7ahipcuqdz5pffxlc5b@662cpwhxwjer>
 <av3EBpSuzn_TcrDk@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <av3EBpSuzn_TcrDk@kernel.org>
X-Rspamd-Queue-Id: 414C714000B
X-Rspam-User:
X-Stat-Signature: fzuaeh3gbgej16xj7mo1nwntbggpm7s1
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1795016388-386348
X-HE-Meta: U2FsdGVkX181DGgBffKLc3NrtsucIHOOgCGFsOKs0mejjCLN6ZTBLYzZg9Rwky9gM8g83SOw8f0XZULZNMXVONQHgI58ysNWWfbLBxDRactBWwvkJMKmaVBDdniN7wTo50fssyhnV/p/UDY+fff1Em+mF2DLYWCKp9t6D0XwunYkpAkuidfN4/mD4Wo+S7o2QBb5CdslMgEs/ZD5j+cBAqKU24Eg2GH+VzyanE1N++vsvONyVdZangys1o6MswF/6a39nxF3rI2wfTw3i/p36ZBYgWtP+nw9SDOY1ZMhzjI86wHZTjfv6cgdw/e4Or/E3MprdW0MzeTZSVZDYCXIm5bWGZC272f8T+EU0qy560QUoD6OyWZ7DOp1kA8OslzTD01nGV7+mDgMbcQdrPFlC5yinpWlRPB9a/QwdVgEp4Mfgm4SG5ZONbEuFasbBG9y/woU4HsWyEL9tOSr2UYKj2QtxwzNKsk1TOl6gvjYD4sBe0U7zSWNefvdvkFYLeIM+HAyeOCiFCh1GtNvGytrUUBZrSDCobHlWYeIidgyDIM6LBfEg9PxDf5t1M4bMIJ344KI0doGhKfr8YWU4+AojMeO1nnCW0EsZRzHwEayGfGGbgj3otMLFFEbeSbWRCxXhiF/kYzypzj6Nl6gQZKku8qfH34UpOYUCQtGCpI52J1ADkKgmJQgYHJAVjEpzKC7FptWjNxBk84hCw4KhP5fUTnYBRm1jnSCgEsANrvou2S2XEPAS/7CDQGvfRTVl+fNm/5vT58JSZc7Xkx6OjpFnug+bJGp6T7q/CHxNKY6aY9bt8KX+DiAjmSO0mQj796AxQaY6dU52ASstK/dtBmzlgfADZaqI1n0+jtdsfX0Pgk9FDgCiQH0HeRmMJxIyb1ryPUvXeCRv3abuM4po5a7ieqDeaQsJ/cNyuKBEU4/epFzVkjWM0IWSrosf5NZMe545fCi7CgCg2gTiy2rEfL
 7KoVGgYM
 blEl9z4H5Y67wvpLAJt7JGDkAK0sXtbhRP2IuxfXoTSwOWQ/aTecpKkeXbahnaw3pxW5tAwMK5XtPCMTPrSYsaOyqSS0aGK/PRrP/ScjJ7OnYtizRSYmEFgoDKua1rKwi38Rn3Dl9GEsacn6ojfSW58HU6uv3J1/GuuX331fy4dRG203tovVldr/ceDLyzDjjEvfa6HaHhnVReL4vjP/zpgV8M6VXygAAcE5suAPRGjvP6FWGh/eb6AD9h07s82xG79jKkb6zd3p34L3nc0KKpVu9Wd5c2LmyZD80ZFhclsx4+BlIIdHHU4Y6otknxyU/gi6lmJrOGHiDxrmL+vrWXcFb06KzQ/vk2haoqLQgl+dE4J733DaRUDp4++pU9iCQFoAM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 05:28:10PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 18, 2026 at 02:47:34PM +0000, Josef Bacik wrote:
> > On Wed, Nov 18, 2026 at 01:13:39AM +0200, Jarkko Sakkinen wrote:
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
> > 
> > This is what cells is doing https://lwn.net/Articles/1102593/, you may
> > want to take a look at that work. Christian, Lennart, Alex, myself
> > and others are working towards this in a more wholistic way. There's a
> > lot more that goes into this outside of just the object itself. I've got
> > my version deployed inside Anthropic for securing containers and I've
> > tripped over a lot of pre-work that needs to come because we can tackle
> > this. Alex has my rough outline for kuid64 for example, which is
> > necessary for making sure we don't overlap UID's on the system and
> > create holes this way. The cells work/anything that wants to have clear
> > security boundaries is going to require that as a pre-requisite. If
> > you'd like I can include you in our planning so we can get something
> > that will solve all of our problems. Thanks,
> > 
> > Josef
> 
> No it's not doing the same, and this why I sent the patch set.
> 
> I don't see cells fighting with rootns and given that rootns has a small
> surface and it leverages already battle-tested code, instead of
> reinventing the wheel, it also has benefits. It neither doubles the
> number of container frameworks in kernel.
> 
> What I'm not claiming is that this is better. I just wanted to fact
> correct "this is what cells is doing". It is not true. It could be
> better solution but still that statement is untrue.

For better or worse, cells does a lot more; just looking at the patch set
size.

For rootns one can point out with a finger its possible problems BUT here's
the thing: it does not haven unknown unknowns. Even if cells had less
of known problems; we have zero idea what will come up if that ever
lands. The possible consequence have less predictability.

Also, as per integration, they actually are not fighting features, as
they are in different layers. There's no same thing at all.


Br, Jarkko

