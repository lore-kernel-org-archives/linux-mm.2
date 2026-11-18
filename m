Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D24C7606A335
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=djw2K2od
Received: by kanga.kvack.org (Postfix)
	id 00D356B00EF; Wed, 18 Nov 2026 12:30:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F015B6B05B0; Wed, 18 Nov 2026 12:30:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEF516B05B1; Wed, 18 Nov 2026 12:30:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAE8B6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:30:29 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD4BF16081B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:30:27 +0000 (UTC)
X-FDA: 85448928894.07.DFE9740
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id F3ACD2000F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:30:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=djw2K2od;
	spf=pass (imf13.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795023026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AXyr34eZLB1bS8MATPL8FPR/LLqo+MrnU3tB91TSYQo=;
	b=Bc1uYv76hcUeB3rPRdOWioL9WvwLDHWm/y8Iw/Y1UGkFbbwxosF94ATqNjd5jEAacJiesq
	t2EsenIdsjES8nHSRJ72BTA7ncEV3Nl6qNohma1LYLvzbiBG2E+jpVpSHPisA2ZY2pwcxy
	ugZPKIAg5UW0ntTxmoINeX/QjRDt/to=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795023026;
	b=yXRk070tsCLq5+RC1gcvVYA0Dn4sO5bzQZs5GZrB2ZsVOjUCauk6x26XqdKQWD4rYQnqpp
	2TxZwraDG6ms2BE0uXcmSSojPkR1yrP8tPCAJKnv9YliRrZdUtmJKOknF++Yw8zqt+aTCp
	rSIh9mPw0b8D5xvzshOuqfahEC/61I0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=djw2K2od;
	spf=pass (imf13.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id E1D8B40E5D;
	Wed, 18 Nov 2026 17:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 142AF1F000C4;
	Wed, 18 Nov 2026 17:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795023024;
	bh=AXyr34eZLB1bS8MATPL8FPR/LLqo+MrnU3tB91TSYQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=djw2K2odyCnHPUAoZZ3QMzDgwKhcnKfCVolEDh7zqTyPwLHrWwWgrXoaKOMifxeQB
	 PgA8i2s3h5GY9GH6UgyJRCnufAKqxM+DK7OrqT6iwZZayXJSuMLirY6EZLYMetmPZP
	 xHwqm2IO9NHoInWN3XwvKTAuj4wPHcJw+Rz48D7XjH7KB1TAck71C0Awt/Oofy0Tqy
	 +TMVLuo0zS5w2qngKq6+nTM7SmxR+FenCGhNkse+bueiZMaT+cpR4UM8EMprS6IO/s
	 V9Cw1fpesTrfw+QK3tQlIs2+d5U6WxpY/Iaqw0nIvP08ZxP0ZlS9mSoa5MHbLW2qSI
	 1k7w52jwbTcvA==
Date: Wed, 18 Nov 2026 19:30:20 +0200
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
Message-ID: <av3grNWlMRsZrqaq@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
 <av3akYFOYaeQZauZ@kernel.org>
 <av3bkDnwmjunTleX@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <av3bkDnwmjunTleX@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F3ACD2000F
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: nrj7sq7q1ctbebizrfrg7sstp9utbc8e
X-HE-Tag: 1795023025-243762
X-HE-Meta: U2FsdGVkX18273/FNXE2MKggCACungKsIzYZ9X+a9ezXfR0+9mauzpL4y46utjHxo49RRTnAa/qgbQdHYI8Q613PRu+GxArvYi32fN+YxYM8DaaIBb9Eyrf1LKDeowrVt3gxEe9kPM1b2Ed+fqfCUpjulg7HfiQgLL40dDlYOcV6wyoW0gWTYjGXqdWGjtFvS0vNidc4CX08MKz8AGs4fTXNGCjUgyT23eNbmRP1jyoRxbvTizkYSa53fqILBDgc7EEvyMlcxrQuf5cRUevN4SZRdEEytusDBqjhbNULPJo1EVKDdIcS+YeCI+s6rFiPLpiLHOHxG29Bzoz1z2VAyUkAT0k//Ya4VIvIcvmoVqk0p+vcM7xiYWZJFhb5KJciyUn3UgCLT/tyFxTU+cREL/Enio95PBFDht3ymH5OtAXGXR5ApN4G1P80zi1rxuv9f1UZZl8El+96t9pqbGWXhMAGnal51FZN6tEHJHZwYBrm0feUO3Ph9obVDCuCCkx39+lx+e+TVgonZR2Z1nZ6FeKeIXo+sWmniUZDUID5+0loyhY/lsepy25CyC8fsdfMSINe5YAjhVIuXLIf2bkuaTerLw2BIQlfD8RKJZjI0w6BNv+M+ZM0rDe8gbMBcc3ayMHJGMrmoqdc3X0WOf5J/zUB/20RdoxBsCRuQbTynH5SV93bBKopJcwbl26vGSiVIIh7CNLLBPTsmZRHBdXf+lUJuYkYZP4YGhVR7GYpZf9fSP9AYK6aWZrmQcrkvRIUBaCeKMMvrpOuMYw2rUBGwdQlU7LNPrfxG1AP4s5GxCmB2eW75kXfoFXUPvz9n6oG2eT0SVy45Tmv5kt3DOBD60YZXnOWriOh75EaPKUUEKFxlaIPBCBzDlUE4EE5rNkLdeQbbAb7KlZVYD78x7sBzugJR2FSYNLwun3RkqUJAVvl2/sinYV6vJZTZo6QRVNeBPSb2KU3kSXj8eKnVr+
 sEE7W6gK
 jtfdC7GWNsvxDZdt2kBlmuxle/hXQuYoXrQ6p3msm1PQHhvANoBlBztiMDnmb9Yu+BWwsMsO8MfZpC1Gr6e3sHHqgoeZUGc/GQMJgzcqm6EcuEub82QurBJ4n9jnPLSJBhN5tdrfnTb/uvgYGRAT3n+qQOluO6Yujm9bXJhIdcQPX2iLxmQue3Gf++ifQEosdRup0ASpklOEZr2t4EFsZCau7WOy/HY6sVUkGrQVW49W+eDoZHri3WGo8vviJrDu7bo1FZeVwzdFgSDw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 07:08:36PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 18, 2026 at 07:04:21PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Nov 18, 2026 at 08:59:39AM -0800, Andy Lutomirski wrote:
> > > On Tue, Nov 17, 2026 at 3:14 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > > Would it make sense to come up with a patchset that does *just* the
> > > configure-a-namespace-by-fd part?  It seems to me that this should be
> > > an easier thing to agree on, and it's a big part of the complexity of
> > > all of this, and it solves a real problem even without
> > > cells/rootnses/jails/whatever.
> > 
> > Is it  more accurately scope the part that is "just the fd-part" and
> > what you consider as "extra cruft"?
> > 
> > I.e., where do you draw the border?
> 
> I'm asking this because I had similar thoughts when I started this back
> in 2025. David had some good ideas but it did more than having a fd
> that does not go live before everything is set up properly.
> 
> Then I thought that, I guess people who proactively on the topic do
> something more lean and compact, and never sent roonts patches.
> I'm not seeing anything more lean and compact.

What if "A full or partial set of detached namespaces" would be changed
into "full set of detached namespaces"?

That would simplify the patch set a lot.

By pratical means we would take this:

enum rootns_flags {
	ROOTNS_CGROUP		= 0x00000001,
	ROOTNS_UTS		= 0x00000002,
	ROOTNS_IPC		= 0x00000004,
	ROOTNS_USER		= 0x00000008,
	ROOTNS_NET		= 0x00000010,
	ROOTNS_KILL_ON_CLOSE	= 0x00000100,
	ROOTNS_CLOSE_ON_EXEC	= 0x00000200,
	ROOTNS_ALL_NAMESPACES	= 0x0000001f,
	ROOTNS_ALL_FLAGS	= 0x0000031f,
};

And outcome would be:

enum rootns_flags {
	ROOTNS_KILL_ON_CLOSE	= 0x00000001,
	ROOTNS_CLOSE_ON_EXEC	= 0x00000002,
	ROOTNS_ALL_FLAGS	= 0x00000003,
};

If I was using this I would at any time just take em all. "Partial" is
just something that I've been just carrying since probably David's
original patches i.e., it simply has not been considered that much.

Br, Jarkko

