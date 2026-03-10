Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24BBBFD2D70
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 12:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5297F6B00E6; Tue, 10 Mar 2026 08:57:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D6B06B00E8; Tue, 10 Mar 2026 08:57:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402CE6B00E9; Tue, 10 Mar 2026 08:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31F466B00E6
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:57:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 019191BF3C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:57:16 +0000 (UTC)
X-FDA: 84530154114.04.862A87F
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf23.hostedemail.com (Postfix) with ESMTP id E0637140004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:57:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="a2kd/i/Y";
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773147435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Dsx/NIR1ZjMoRUA7M7tJHIHKo4GMgmcMyESER1ysIg=;
	b=lPT5MCbK5cNrFHutmWjYmvARkNANKC2eltsrzp05F0Teclm67gdKrgwyocfeuUtQF03uIt
	GE2+ow9bKYErqlzB9bb+2lZTlEWoCStY3jnNjAc/DlVrh+l7dpqIyVa0Lc2uXozXi8g5u8
	rkfflEWqVLZ3MG4ojyu8Dadr2uRqcgU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773147435; a=rsa-sha256;
	cv=none;
	b=so7I2cSbmlIWkPAbYQRgIt5kECo3GEL+qn6wPoN1wOOQ2vSNbZVrVveQ/JNHTwRhB32xCh
	PvVIIJzZIGSX80pYLtCxacMotYRQ2Sf/XsYAMFUz1j1roXecwoSjKSxEPmT1ojRKV9VeCa
	suaYC6yOh4a9D68PjpDxexKcy1yG8Zg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="a2kd/i/Y";
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 1B045B37E4;
	Tue, 10 Mar 2026 12:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1773147433;
	bh=9Dsx/NIR1ZjMoRUA7M7tJHIHKo4GMgmcMyESER1ysIg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a2kd/i/Yun5wM8r22ArXCh/GVja74SfYxQceck3++kZb7gzOLl32pLcBci+sQ2WWB
	 drpUHLTxedU9rNPgGo/oSSrhQNC1Hj0HKfhkZTFc1m3bHCY5AMFyA2KNOfjPjMAuda
	 Qze8HryB/aUeTNI9W25L3urO4X+cJLS4EasKHNzU=
Date: Tue, 10 Mar 2026 12:57:11 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: dan.j.williams@intel.com, Vlastimil Babka <vbabka@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 1/8] mm: use zone lock guard in
 reserve_highatomic_pageblock()
Message-ID: <abAVJ0hosm0jGHOX@shell.ilvokhin.com>
References: <cover.1772811429.git.d@ilvokhin.com>
 <cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
 <20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
 <20260306130052.7da8eab3@gandalf.local.home>
 <ce0e53e4-52e2-4e56-889b-adb01ede6fe7@kernel.org>
 <20260307131641.GX606826@noisy.programming.kicks-ass.net>
 <aawxpQDPpqX2k5z8@shell.ilvokhin.com>
 <20260309164516.GE606826@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309164516.GE606826@noisy.programming.kicks-ass.net>
X-Rspam-User: 
X-Stat-Signature: 5ydt1npxso3xnbq48pjqh84mh1y37u3q
X-Rspamd-Queue-Id: E0637140004
X-Rspamd-Server: rspam03
X-HE-Tag: 1773147434-211892
X-HE-Meta: U2FsdGVkX1/o5MBEH8w6+P9xFhAUE842G81xMe+NXopB9gXFXFu9x+p+2ia5GuTuQdffB4HEk51WOlUanQQDGAPZtWJjmGG3npva/iyHDDi1acvmH0KwWoTMZAQDMBODCJ89sDnsy4M0ZwrLONOxJq0AcD06BcCYyFHZjD0kpYfXtLUUQK0KAHzIpVt8iA9cAzrPaPGl1vCJnQnr7GMbd2K6nWtj68MQriIaFUblOORFRbW2i6jXbPZZcwkEq248U+RwpLb6EzfNli0CY9kxVFpz6HqlGibWU7TYrHGAppgcQKVbqpSAvDd3oyX78Ll22R51h17mKJRwBD4pBI3af431vkgeCY1H9ZGOZb/HhGE8f1rsGf0HRF1b22MnJ/gvLjtVjOj6nDrlRvwNnDNYg9CHQjkuGHVw2mVnQzBRrIv+awE/jLn9tPbV+oZxxjOUhZyPxG0hhn+qtyXxLEY0QjqA6jJiU9FA7kpuTFXV8G8QQKLUVOrG68DDU5myD848aFKg5DjDwi9yVAJb1MyU/vQBC9ikF5kqRTdYBV3z0tdcSBwHiHAXtj2TITMz2ctqmlbhsi9GUyI3fw9wPvKWQIHfNLxcxlZtID0eiZpIWLdPxnSfvEqUA0Nv7gAzKxdpse4c7k0Iir2VHjmmYM/eFrpcGpk0FVXGBcBISCSvGuQnrvn9funp0j7ITOyVdK6038OR3J/eUlaZvcWe4aMiEvAAEs/d5bP8tL6E0PP/3XT4zjKH9/BnDyh3cSC8bS0ckkbU5sSyUq4Qp8hTL5tV8gH0/rNZvZiCgG9V2r/xbZU8SqNMOgUz3HniHTAWFfdsCKDExz4ynhPfIFC4owJeJMyHMXzYw8AONpqygESEeJeqhTOqcGNTSwIMT09rpURJyf33OJ0pO99NN5jrTU3O3bxAFqEwyMeseH9JxJNx6T0WdfhawrJgdhNg1YcGA6UJvwEx9Il+0EXbutMrNId
 XTIsfWf4
 me8bhlCn8cKRTDFyyp5gVWoil85aoLlfLewu0Po8La0N4g8/eIY/gCkpwDjCTW0Q8wATnA5cW97Hh05PN8umo9caX4kfSLto5eWlyRXERAFa9/I0hUBJ4WUMAdFzlgy2wMFMOiVM9KKUOdWqdUvj47VNZPbKCcYI07byDFOLMuZ2j/aqIubh5iS4vP0bog4Coy3XCsRd8S6G0dh8Lut2D64G9r0FQWOJ+CmsxGcBnXJaiCGCQ+uQZrOxJqETJWXr4YufyEkbjcrQTkiCICallt8uSThZyjS7InJ3yqKk+JjTtaoneA+vP/7rz5VIBu/jK6yF9lQlwRWfKm792+Rvu/fJZ6zP0ixbK4ihktSalnrATDM/IBVbRoelgNQFuIEzOpOJEzpD9ciz6jVEV32Q2W3/9XFTsfehH/IC1syRcWX6odvWfFdJJ04rcuKti9kbGZaHve3Cf8sVSZB8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 05:45:16PM +0100, Peter Zijlstra wrote:
> On Sat, Mar 07, 2026 at 02:09:41PM +0000, Dmitry Ilvokhin wrote:
> > On Sat, Mar 07, 2026 at 02:16:41PM +0100, Peter Zijlstra wrote:
> > > On Fri, Mar 06, 2026 at 07:24:56PM +0100, Vlastimil Babka wrote:
> > > 
> > > > Yeah I don't think the guard construct in this case should be doing anything
> > > > here that wouldn't allow the compiler to compile to the exactly same result
> > > > as before? Either there's some problem with the infra, or we're just victim
> > > > of compiler heuristics. In both cases imho worth looking into rather than
> > > > rejecting the construct.
> > > 
> > > I'd love to look into it, but I can't seem to apply these patches to
> > > anything.
> > > 
> > > By virtue of not actually having the patches, I had to resort to b4, and
> > > I think the incantation is something like:
> > > 
> > >   b4 shazam cover.1772811429.git.d@ilvokhin.com
> > > 
> > > but it doesn't want to apply to anything I have at hand. Specifically, I
> > > tried Linus' tree and tip, which is most of what I have at hand.
> > 
> > Thanks for taking a look, Peter.
> > 
> > This series is based on mm-new and depends on my earlier patchset:
> > 
> > https://lore.kernel.org/all/cover.1772206930.git.d@ilvokhin.com/
> > 
> > Those patches are currently only in Andrew's mm-new tree, so this series
> > won't apply cleanly on Linus' tree or tip.
> > 
> > It should apply on top of mm-new from:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> OK, so the big problem is __GUARD_IS_ERR(), and that came up before, but
> while Linus told me how to fix it, he didn't actually like it very much:
> 
>   https://lore.kernel.org/all/20250513085001.GC25891@noisy.programming.kicks-ass.net/

Thanks for taking a look and digging into this.

[...]

> Anyway, if you all care about the size of things -- those tracepoints
> consume *WAAY* more bytes than any of this.

That's a fair point, but as I understand Andrew's main concern, the
guard() usage becomes part of the code unconditionally, with no way to
disable it, whereas tracepoints can be compiled out. Any overhead
introduced by guards is therefore carried by all kernel builds.

Given that, improvements to the guard infrastructure itself seem worth
exploring regardless of whether this particular patchset ends up going
in. If the overhead can be reduced or eliminated in the common case, it
should make the trade-off much easier.

Thanks again for investigating this and suggesting a possible approach.

