Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B779D606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 00:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CLNCM00C
Received: by kanga.kvack.org (Postfix)
	id A5B506B0BF2; Fri, 23 Oct 2026 20:43:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0CF46B0BF4; Fri, 23 Oct 2026 20:43:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922086B0BF6; Fri, 23 Oct 2026 20:43:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 642B86B0BF2
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:43:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E1BDF1A016F
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 00:43:01 +0000 (UTC)
X-FDA: 85355670162.01.F3E78C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5AB9D40008
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 00:43:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CLNCM00C;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792802580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80H2lZ/+xPdhTPazfU9LTQ5TA67GAupaXXZBnmrhJik=;
	b=J+UVTpW1GzxlrS+rRNaJnghVy4wnOhv+qKoBtkt2+cd6CFJR+DDScdq04Hr2g6ftsvvTQ2
	Pc1fWVf5QvVVZAdV6DazKytqBL+qVKCxAllMvWmh+d8+LRiYyZvtqibinSVt/0uf1lavZW
	mrVN8ZDz4pCk3bzMW6lkA6jw15e7mkQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792802580;
	b=FZzw/mEak8CM99mvb9s8FkC7nZ0MUUi2zNIGzEj5w6xzbTh+jCvLhvOrOqcfFczF3zT4tE
	7HHgQr8Dgskuq5+EXqMB/pOrdXxEH0zzpHriL9lQ9On/scjoxVjRsh5P8N6pNRVGVOvgBo
	VtJuf5XSG0FXWp6+iAAh8cdA65ruExo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CLNCM00C;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84F6D6022A;
	Sat, 24 Oct 2026 00:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8E31F01825;
	Sat, 24 Oct 2026 00:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792802579;
	bh=80H2lZ/+xPdhTPazfU9LTQ5TA67GAupaXXZBnmrhJik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CLNCM00Cgw3YHxikMpZ2wacAXPGQowY94cvy7BRdu1M5I1GGPmhVpvy+FkBA/VWJ2
	 Qq9hXIMXkNmmDr80GccmDklzMalTR2UTrVHZcqpi38PlXQEoFZtK8AEtmt0IgvkB8D
	 Oy5ahhndGyQbSy3OOcQjRgmZt/z1BypSPvpu4hEy5CHmjyFM1bwXLJdjk7Gd9wTDOi
	 FyMnfBDGLgzRxHPhrSPwh0+Ajuuj7cXyeD47NkOGFeLeMyoYZsLOLwH8gzjsfn7Hs0
	 A7vOD8d/6zLSxDl+fM3AoufwoVAXRoMvY1kIVZgPQ3cOchRv48ZhINyAMDLzZdtAUm
	 dKbVN3IFCTMhA==
From: SJ Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	corbet@lwn.net,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org
Subject: Re: [RFC PATCH v0] Docs/mm/damon/design: document data attributes report infra design (beyond page table accessed-bit milestone 2)
Date: Fri, 23 Oct 2026 17:42:51 -0700
Message-ID: <20261024004252.87352-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023195122.2481-1-ravis.opensrc@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5AB9D40008
X-Stat-Signature: 7peycqhhc9kgchiy7czm3i7o53q3d11p
X-Rspam-User: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792802580-558568
X-HE-Meta: U2FsdGVkX1/ucNBCYtOfHHccKbe/3wfN8XPZZhhrPdhU61ZLihkIznQLyuXzrmabI6EzU+pGqoykRtlTZzxFlcz2kofKWbg+E2wJDSqM0DhukDkpTn5GSqnKLbKAEL12I9m27s/Z4qGywgY0Exu1TWL3NqZrf1CZNJHLq1+3njw3BIW02Lc2m3a6M/RFww+X+nQsnsTNLVH+mp6wR2B5HML5uLzhMP+4R6MD6mtZzdTHLZA1fb7TbPIhMXompkQ4Nv44lkXREXK70q+22x4dtqLuLLkx1wN9Jm460FQXLiHru6dWg5V75UT/4nU/39/IDdHSrU1HoE8yenCEmxZ8ZV9AVyMXH3VSARVrivuebj0l4DvvKShdIcdcjMvRIqp+qYNc0u9S8FvG5PyZ45RGi6i6KJR8TMGp/9/3nfF9xoyGJyh3l9ojynyr+ffyVdU9QR7XdfiqNHdkw0swCYUwQJF9waUFm08bV//Nk611B4Z+BfoO3L7yv0OQyiFbjKsE10zfeO+pp2G56PK3ah1BLkHKaRIRi5g31pIgGWO+9YyA35/dCx29EHy+2OXStYLw5sGKwrCsAQQWveBTXAOU2IHqBNDC2TPHn80AZ25tdq7ZoXlIfTQHSp4w5hpil4+rjLdgbJ2LDur2bZrNwzgONLamJtdehQSmoVTPDbfo3IG4U7WGMz20wh9gw4b6BxSthEWYXHQ1LlnGbqliGvO30oz/5phiieNYQXfzWn25Kdj8LSe+kTo/lKkO+30jOcnUfBstosPqNRc8hRB99YRZQmYuKBPb89kWlaYVB3w09J8vEyatifoq4lh+64mhE5xPxCAe4GC82wtn3GEoMXetgCDIC+PD9TqIx45gkNEK5YjeRK1oAsMwp6uB3dDOzPFGCWfvuCylnFpevrRV8H5tk5gnDwOD6o+fNOb+3u57uHou/vSXSmkhZkUQCqvZrpBaYNlC+5CJPudCY9FlEVh
 flZ1ojlp
 rA8oLIPiHMpRVWJ1buTxF9m4urKfLkkIV4dGimYW11Hh1eQCGU/3NP5ji9jxkKzCuSny/VBgSEFotwTlMyFafuSlbk/P772umanHSP9cplVIhkFxsWDVsrHCCiqB8BVGfEzPn7ZSM8FfQUEsg9dC3F/LLUYDjlZnMot01DVoZ5ia2SfyJJBXJPROfNdmlmoROXTluzOdKpCzM8XJk8unNzF+VC5bE4xYO0TiffrWdXbLIV+VYj5oyPxu1HAYgymXYG0nh7C5r1aXLcahaWMpRCJENqzNI6DvbJ2U3uAaATAXWgzvED6Q+uGyUj07UeJM8vxWfaZW/yE0/RmI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 23 Oct 2026 12:51:22 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> Hi SJ,
> 
> On Wed, 21 Oct 2026 22:29:12 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > Hi Ravi,
> >
> > On Wed, 21 Oct 2026 21:17:24 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> >
> [...]
> >
> > Thank you for your detailed review and testing of the first design!  I'd still
> > like to try decoding idea first, mainly for quick prototyping.
> 
> Sounds good.  Starting with decode makes sense, especially for VMs
> where hardware address-sampling PMUs are often unavailable; some tips
> for the prototype are in the other reply [1].

Thank you for confirming and the tips!

> 
> [...]
> > > Yes, if the report has an address field with a validity bit and carries
> > > the producing report-type (attr) id.  Then IBS, PEBS, Arm SPE (through
> > > an adapter, since SPE uses the perf AUX buffer) and device-side
> > > monitors all produce the same report, into the same queues and probes.
> >
> > Thank you for confirming.  And yes, I think we can add more (union) fields to
> > the report structure.
> >
> > However, could you further clarify what are the validity bit and attr id, and
> > why those are needed?  I'm still newbie to perf event, please bear in mind with
> > me.
> 
> Neither is perf-specific:
> 
> - Validity bit (or union tag): a way to tell whether a report carries a
>   virtual address, a physical address, or both.  For example, a decoded
>   sample has no physical address if the page is not mapped.  If you use
>   a union with a type field, that already covers it.

Thank you for clarifying.  Yes, it may have a union with a type field.

> 
> - Attr id: an id of the producer (report type) that made the report.  If
>   several producers later feed one queue (e.g. perf sampling and a
>   device-side monitor), a probe can filter on, or weigh, reports by
>   their source.  If each queue only ever has one producer, the queue
>   already identifies it, and the field is not needed.

Thank you for clarifying.  I agree this kind of information will be needed, and
I will make sure it is in the report struct.

> 
> [...]
> > > 4. Binary search over a sorted region snapshot (your todo in
> > >    kdamond_apply_access_report()) beats a linear walk from about 2
> > >    reports per interval for 1,000 regions (a model, to be measured).
> >
> > Yes, this efficient region-report matching would be important.  We could also
> > consider starting with linear walk and later optimize, though.
> 
> Agreed; starting with a linear walk for the prototype is fine, and once
> it is out, happy to measure where binary search starts to matter.

Cool!

> 
> [...]
> > > 5. Samplers can stop silently: in a report on the v4 thread [1], IBS
> [...]
> > Unfortunately my understanding of perf event is not yet good enough to
> > understand this in depth.  I will revisit this after starting implementation.
> 
> Sure.  The one part worth keeping in mind from the start: a sampler can
> stop without any error, so a counter of reports received and dropped
> helps tell "no accesses" from "no samples".

Good point.  I will try to make it at least easy to debug.

> 
> [...]
> > >   - The queue: the per-CPU seqcount design in note 2 (suggested), or
> > >     ftrace's ring buffer with one iterator per reader.
> >
> > My current plan is to use DAMON's original simple lockless and global queue per
> > report queue.  Let me know if the report queue design is not clearly explaining
> > what it would look like, or there is a clear problem.
> 
> A global queue is fine to start with, and the design is clear.  One
> thing to keep in mind: perf writers run in interrupt or NMI context on
> all CPUs at once, and an NMI can arrive in the middle of another write.
> So reserving a slot needs to be lock-free, and a reader should not see
> a half-written report.  If the design already covers that, there is
> nothing to add.

Design is still in progress, but definitely this should be covered.  Thank you
for calling out!

> 
> [...]
> > As soon as this design discussion is completed, I will start prototype
> > implementation and share it as the next RFC version, as soon as possible.  Your
> > review and test of the version will be super helpful.  I may also ask you some
> > questions for perf event and your prototypes.  Thanks in advance for your help.
> >
> > There are competing works, though.  It would take time.  I expect about one
> > month at minimum.  It might take longer; Thanksgiving holidays could be helpful
> > to give me a time to concentrate.  Please bear in mind.  But once the initial
> > prototype is implemented, I believe we could quickly iterate and meet the ETA
> > (LSFMMBPF'27).
> 
> No rush on the timeline; that plan sounds good.  Please feel free to
> ask any time, and I will be happy to share the test programs and review
> and test the prototype when it is out.

Appreciate your continued support, that will be super helpful!

> 
> Thanks,
> Ravi
> 
> [1] https://lore.kernel.org/r/20261023194848.2449-1-ravis.opensrc@gmail.com


Thanks,
SJ

