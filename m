Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9883160A382F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gRdhtVPR
Received: by kanga.kvack.org (Postfix)
	id BEFBD6B00EF; Wed, 18 Nov 2026 12:04:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8646B05C2; Wed, 18 Nov 2026 12:04:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADE4E6B05C3; Wed, 18 Nov 2026 12:04:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83D476B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:04:24 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B0BD16081E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:04:24 +0000 (UTC)
X-FDA: 85448863248.03.2B343A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3E66F14001A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:04:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gRdhtVPR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795021462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hn/h1bRzbBm5D3N53UiS46oHXc8DeYJZVEs6ylWsGuM=;
	b=hypLDhWdpFk5ErDXf644WpVR8A+19TkDE252nRY8eQRY4n+0cXJ1pkJyf8lLvzboCQIkcR
	wvlFVxLAT0L90CVoz5CTbl2gRpNBXLm6/W3qWnQggQwDjH1Zr2VgbgdJbqBDhBiZR4Blzn
	jeGHffSU+jcrLhLBPEH99PXyUVzNMvk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gRdhtVPR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795021462;
	b=G9kUw59GG0Xn31vmXCNlJGwmeQO8e/a9aXF12/nt2xBhfjcIiANMZRjyE4m4LzHD2TyveD
	vM72QH0y9T5dxmEeSiYcR1BKRkOH7+jRWJKQPHtZa6Fg9suJCTUt4N8LyB8OBAqjZNGOoE
	0tRFPJr4n3ZWcUmWT0da86mIai+DS7w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id B33B461EEC;
	Wed, 18 Nov 2026 17:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B9B401F000C6;
	Wed, 18 Nov 2026 17:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795021461;
	bh=Hn/h1bRzbBm5D3N53UiS46oHXc8DeYJZVEs6ylWsGuM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gRdhtVPRVGpWi7iegmc9niJiev9/dezHn8c46qqykKLiB9HRwZZzGoHpH1vyXv2KW
	 WFMn4B83h6Gbp8NrCYOounPjZeu44Vsk90yF7oCuvfSeoxCz+waTCkalOLGF+SWHWW
	 PiZ/vuDcyF2asBN+6a0Zoq9n6AenEf1JpvjbIDqdtDcITPLZ0ntxQARKal2cwpCd8M
	 uWfRzMzyXcBAErCbYnj7156qfhH4uPAv5yDtMjXycJxYWAAtl2wkCzmORf+I4Fb1v0
	 F9yGOFTnVyWDiF1irHNxmq0Znq85hxojQ1sH1hokHi8fYRnupxH1MmQt6M7ItYPqb6
	 g0SKocHpDEQ/w==
Date: Wed, 18 Nov 2026 19:04:17 +0200
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
Message-ID: <av3akYFOYaeQZauZ@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
X-Rspamd-Queue-Id: 3E66F14001A
X-Stat-Signature: 8c84jks48y8oq77ia8fij6wzz1r6jjgy
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795021462-530232
X-HE-Meta: U2FsdGVkX1+EfY5Oy2+fmdmE/xrC/YIeJiXyzRpWbiTFSx3aN4+H+mSnHNOR9YB/qfpV/qX56ROdHYzvgbgEOQoElOQdlN91fnT9CqR7VFIDL/pjC7/bbiHwKD1TqJYiCwmcK0Vg3ltMnkvBqqDS9BoUGzuUq7FCHLKrK0xu86H+SDu0u7tPQZLhCkq0UN6HW7q9ni3IRzLnVLOAhCUwIdIK9qM2L/CLRI11hwJqwiwyzi+GTSgyalDKhXYBgYNhQwVsRgR4/hM0vcEfLxevCEjpD7sztAKp/0hQFXuUqtp7v8gYZjdloCs6erl/73ZGUZiyLt9uSyM7ayNWxA8fb9v/MYUp6Ly4ewryVb3SPOS9De30Gb6zOtBVQzTbOLRhIAuKqWcHExz2hgmOf8LQKP48wHXemwBYcXOvpWr2MXzK1yDxg9l1RUarJuoqNGtIG5WSsiyAeTVPGjyE2YMkfQlL3/IcUktSv7/VYJ2W81UPfynhtZJbKIY8KMyMfTATHEzD0pbzUqPOXVnkcGyTkoEznhuoCt3Vc17QuvVb1H7iTypdo3PBDr+DUaceOHtAWu4JywRGx877LYbBp6Vgxq1atFc3P+O8ls/4OLB4hEw0ARrHLROHupZTdgCC9pu2MRk5d12i0NozBmO1iTcJwSYKFN5LiSiWJs371dzoghbiDa1uf4mcLt2UscDDz+6lodyqJ1hk9Bipa/U0tMdfcaLPIXhRHvY0040hHxcRV+QRxlWNAfogwbWsOikqkREGmN89w8vCjJJ4zva0ieg++Xaq26hINA2QHlzIQ7CG6mqVFQ7XbLeVkDIPBLqkG020nnI/Vo+DJ1k++TprNrLkNRhiRbl9T7azdYNYEtYshws6cuP4Sz1u8403brQoDRJ9RHaJnCVSMi+O+No2SO4A0NyZCbeb88t9xWzWbLydIn/YFcOy9K5aqGVOycBFAe2uUObFe0CrMlthHxk8xYx
 HNfMQFyq
 CQg/kYVR2WcOBSzyJQBoYBNlBAXIMEXjgGK6tvwuN/QbYetAmqBjUdHxtrxuh91kHg8o8pmvPYMr+cbn7qzL+Jt/J0zVo5BrRFrNZX7pl9gxqKmVTXigGmRGcbYjSBUVLhipik0Sa28xMzPYkM/nC2TzoYGWZdWMeAMnmSUdGlGzY6s223KkJFP/p8G5LmaHrtQXeXfvNIcstIcGtqbrQjdCQWs06kuEBoGd/P4zK9fkH3vW5hfn04V0Ll2HFKBmGJ9c6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 08:59:39AM -0800, Andy Lutomirski wrote:
> On Tue, Nov 17, 2026 at 3:14 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >
> > OVERVIEW
> > ========
> >
> > A root namespace (rootns) is a kernel object backed by a file descriptor
> > that binds together:
> >
> > 1. A full or partial set of detached namespaces.
> > 2. A dedicated PID namespace for spawning processes into, signaling
> >    members, and polling or waiting on PID 1 exit.
> > 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) that must be
> >    populated before going live, without inheriting host mount-tree
> >    ancestors.
> >
> > Work on this feature started in 2025 from David Howells' container object
> > patch set [1], which I turned into a namespace for namespace roots and
> > rebuilt around that premise.
> >
> > While the patch set is manually written, the original motivation came
> > from isolating LLM agents. Running untrusted agent workloads made it
> > clear that OCI runtimes need to minimize their live configuration
> > surface.
> >
> > Assembling mounts, credentials, and namespaces inside helper processes
> > with a half-configured container is what I see as the main challenge,
> > and the existential debate around namespaces and container objects is an
> > unfocused discussion topic.
> 
> 
> I've skimmed some of the series, and I see a bunch of good ideas that
> involve using an fd to manage a thing.  But I'm wondering how much of
> the value is added by that and how much is added by having a new
> *type* of thing: the "rootns".
> 
> How much of the value comes from the rootns vs the new APIs to
> configure namespaces without entering them first?
> 
> For that matter, the cells series also seems to contain a (possibly
> very similar) variant of the same thing.
> 
> Would it make sense to come up with a patchset that does *just* the
> configure-a-namespace-by-fd part?  It seems to me that this should be
> an easier thing to agree on, and it's a big part of the complexity of
> all of this, and it solves a real problem even without
> cells/rootnses/jails/whatever.

Is it  more accurately scope the part that is "just the fd-part" and
what you consider as "extra cruft"?

I.e., where do you draw the border?

> 
> --Andy

Br, Jarkko

