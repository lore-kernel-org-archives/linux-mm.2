Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FDD6F4613F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:27:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ED526B00A0; Mon, 23 Mar 2026 19:27:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19E5A6B00A1; Mon, 23 Mar 2026 19:27:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08D036B00A2; Mon, 23 Mar 2026 19:27:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EAF006B00A0
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:27:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93561C3AC8
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:27:42 +0000 (UTC)
X-FDA: 84578917164.28.933214F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4242040006
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:27:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Qu/rA8bV";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7GAOUZ3V;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Qu/rA8bV";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7GAOUZ3V;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774308460; a=rsa-sha256;
	cv=none;
	b=S8g6vu2a6H1N4OknSMAvlmotq4GwtDNo36UTUzz0pRUYgY8o7cg0vEQwD1hF8rGU3fwf5v
	p+BnRJNmcir3+wGnddsUTenxoY+CTDRqLhP9SqLYFveITaWPc5CWARw4Mg84GUNMu8cmSb
	vtftIOtiWTzzxxNH/h3OC6U2Y3z18tI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774308460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/zF3xE0y1iqs5uLOvtmvLPWoyGX4X9RYzF41VgVZI70=;
	b=br96qjx90l4aSyOsfzhk+VZv0dktfdLIMF9JBLfFyWl2wKieEBV1aL6VCNAdrptc0tpC9B
	WP1n5ZaxApLo5dOVeCTsPdj4jBlyNboBZyzOWwLLTqtDmRujm6QrijNkdqH+bHby0FhHiw
	8XHnjrXRNwe+NKLOQg9nqQUKcsULYn4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Qu/rA8bV";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7GAOUZ3V;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Qu/rA8bV";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7GAOUZ3V;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6488F4D364;
	Mon, 23 Mar 2026 23:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774308458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/zF3xE0y1iqs5uLOvtmvLPWoyGX4X9RYzF41VgVZI70=;
	b=Qu/rA8bVWG6KgePJ7BYojI4sLxKtGfG5w8mU9SgvEWmJctaSkfe2a7zUZCOsBKZDsPoAP6
	CHdZBA4WN6hovbVFizIkR7EvcFiaJwrruVU6/swcQDdODgEnYo1AIRuoNHD4ZqA8dIIRqk
	98FmWcQSQ9Y8AOem9LgUO3tXkGcqefg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774308458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/zF3xE0y1iqs5uLOvtmvLPWoyGX4X9RYzF41VgVZI70=;
	b=7GAOUZ3Vu7v8ty/xDH6vK8+HBXhzZ3VOkQNJ71nhv75+luZKEXUs/tacOMbHoZDy10koWJ
	v5I8DVpyqGpVMiBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774308458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/zF3xE0y1iqs5uLOvtmvLPWoyGX4X9RYzF41VgVZI70=;
	b=Qu/rA8bVWG6KgePJ7BYojI4sLxKtGfG5w8mU9SgvEWmJctaSkfe2a7zUZCOsBKZDsPoAP6
	CHdZBA4WN6hovbVFizIkR7EvcFiaJwrruVU6/swcQDdODgEnYo1AIRuoNHD4ZqA8dIIRqk
	98FmWcQSQ9Y8AOem9LgUO3tXkGcqefg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774308458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/zF3xE0y1iqs5uLOvtmvLPWoyGX4X9RYzF41VgVZI70=;
	b=7GAOUZ3Vu7v8ty/xDH6vK8+HBXhzZ3VOkQNJ71nhv75+luZKEXUs/tacOMbHoZDy10koWJ
	v5I8DVpyqGpVMiBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B28043B23;
	Mon, 23 Mar 2026 23:27:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nBWPBmnMwWmkSAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 23 Mar 2026 23:27:37 +0000
Date: Mon, 23 Mar 2026 23:27:35 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
Message-ID: <4fb7fzdf4uirsxlxiwd4arbhlezgrawb72nm7sl2slntvxlng7@kimmnebrr4c4>
References: <cover.1773924928.git.ljs@kernel.org>
 <20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
 <87tsu9kgv3.fsf@linux.dev>
 <20260320203311.715ed75bcd84c18d24894324@linux-foundation.org>
 <20260321171530.8b3e8207f89d5a7384b9f01f@linux-foundation.org>
 <5cd57c69-7193-422f-b6b5-75bb5234e5f3@lucifer.local>
 <j6hsn4mxnzoukebcdggu6ojkyaj54joohocbbkrzksm47km7ni@zzp7aurwmto7>
 <20260323143604.603b20aec4e3ab77cabec107@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323143604.603b20aec4e3ab77cabec107@linux-foundation.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4242040006
X-Stat-Signature: n6qaqnhf5e6eiogjmckywutw79qm545b
X-HE-Tag: 1774308460-799263
X-HE-Meta: U2FsdGVkX1/QZ5val5TZIeCaDhfBahFD9+tWm2QVw+qO/Ms3hajQMUnel6p/geWIoNoxW89ZWbtBY54zd9uxXNv0nakpFPYn7Ujp233zpsUN9OS5cEnrRhAHVFdh54RHvmG5R5p64fe/Bxq5LJXHeXXDnEqUz/HA35Mdh+K6hfimXIP1NmHJ5fJo28xvkplzmuOkSQ3auKzVhAL7BaAvwtETelBuVq+GjRh0/gLFD445Fk5BMyFPH1wkxqwljoaaCLSsWo3kzvih9YqvIJVdcD5aam0OcImidVC2loNPNHR/U7lHZc/M7FxQ95pOrbu8ru+ZOp4Pzhwyl71PPkN3C/KK3b92Qm0O2ZjHOzOjaKi2T85kxfjatieebsaBIkKyZM4dZEMgaTf3BMJS+w+s0ueQfrVJBwAjDIg1vtBWcQ2wWPo1cUH5vRO2BZ41Xd7ZbNSGSmYijQaJ+Jg4qT/89wp1dpaWcJflRCEWC+kJvWGId7pWVB3CPHyVCJ6LQGM4GVId80/zRp355ztjL1spFkw51PF3KR3/U2aPfdFavQEXm7PdzVghMtNp0OPXYamwb9XaBXD/tLasB01OsM9X/Loe01dzJqL5RLdhk54W2aToiINQv8RKEoDtkVEFssbxjLrLSRzOtaVTK4oYtre+OtNp34wcXsjpL++jORUC0+n+i4LRP17gXAZJqSoQK1G8ocPj5bDa2jSfCtnN0uGZTwCFv2WB5Kb9VihMs6WLMdOr7MpFUmkNdDDrVTNJZXrga+HTB3Fx8SdcHp8z9StgNJYDIwf5/N9r87BuNSJj9sRliu0JcZ8/H3lmmPSKY2Tq1UMYLPDcq7gYh6ZaVEcnP3b/ojOqoDPxrWLs/dJyBKXsob5dg70VhQ6igBrfhdmH2XenTrgznHM4z4VmK9f4ah7ekXS7FmTcmDbp+COL/ogexM6gplP5g+MK3FiMowCjtwp/Z3J3MHL/XOzYEQ2
 Vh53sk2v
 zAqYlx8UwlWLhVHF5WAsbX0JXhquleMvZtLKYBnbasuHLiJI90xM8HpcQJehO8suukNBvDGcNJYbRqhvTsS3IF6XFiY3kPKm6va80+wGSM0hwBTBSWBEIXiaypScoqSTqw+hnXj49RSAH5uP6pmNcTLVcgGpl9yulVOwWcQLMl5W+FF4+JicEJN0wG/OEGTs7LjL2QIFGFPuD/yxm9SxyBuxgKaYXV6XKsaa/N1/ZXxnl5NZE0VAxAO0xHWL0oB7yoOg1vcjf+KuXzSXBVPzqKqiUl5S892LcxItnExRc5TB6gzwbAi8CICql3pYnhgp9tR74sld2Yp+3CF+Y3l1hGziC4HPG2VsZyMyRPN8olcMOq1rhMaT5GSH3AcTOEY96hYcFemV2yVZMbKhgg83iwR9ezlv8GZY/wfXnTS1Zz+gW2X4OKPJmsTF2I3I6t/7XfdxKrHXpmB3wg4E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 02:36:04PM -0700, Andrew Morton wrote:
> On Mon, 23 Mar 2026 12:34:31 +0000 Pedro Falcato <pfalcato@suse.de> wrote:
> 
> > On Mon, Mar 23, 2026 at 11:31:29AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > > On Sat, Mar 21, 2026 at 05:15:30PM -0700, Andrew Morton wrote:
> > > > On Fri, 20 Mar 2026 20:33:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > > >
> > > > > A lot of patchsets are "failed to apply".  What is Sashiko trying to
> > > > > apply MM patches to?  It would take some smarts to apply the v2
> > > > > patchset when v1 is presently in mm.git?
> > > >
> > > > ?
> > > >
> > > > The way things are going at present, I'm just not going to apply a
> > > 
> > > 50% noise vs. signal?... maybe wait until we're in the 9x'%s?
> > > 
> > > > series which Sashiko "failed to apply".  And that's cool, I'll just
> > > > wait for a version which Sashiko was able to apply.  And then not
> > > > apply unless all Sashiko questions are resolved or convincingly refuted.
> > > 
> > > Andrew, for crying out loud. Please don't do this.
> > > 
> > > 2 of the 3 series I respan on Friday, working a 13 hour day to do so, don't
> > > apply to Sashiko, but do apply to the mm tree.
> > > 
> > > I haven't the _faintest clue_ how we are supposed to factor a 3rd party
> > > experimental website applying or not applying series into our work??
> > > 
> > > And 'not apply unless all Sashiko questions are resolved or convincingly
> > > refuted.' is seriously concerning.
> > 
> > FWIW I wholeheartedly agree. I don't understand how we don't require proper
> > M: or R: reviews on patches before merging
> 
> I wish people would stop making this claim, without substantiation. 
> I've looked (deeply) at the data, which is equally available to us all.
> Has anyone else?
> 
> After weeding out a few special cases (especially DAMON) (this time
> also maple_tree), the amount of such unreviewed material which enters
> mm-stable and mainline is very very low.

That is not what I said. I said "we don't require proper M: or R: reviews
on patches before merging". Which as far as I know is still true when it
comes to the process. If I have this wrong, then I'm not the only one.

The fact that the end result is still high quality is a result of your work
(diligently tracking down review states; yes, i've seen your quilt series file
and its annotations) and every single one involved in the review process.
This is not however codified into the process.

(note: the fact that DAMON and maple tree both lack reviews from !authors
just shows there is a very low bus factor at stake. we should fix this...)

> 
> > Like, sure, sashiko can be useful, and is better than nothing. But unless
> > sashiko is better than the maintainers, it should be kept as optional.
> 
> Rule #1 is, surely, "don't add bugs".  This thing finds bugs.  If its
> hit rate is 50% then that's plenty high enough to justify people
> spending time to go through and check its output.

I agree. But I don't think it's flawless enough to become mandatory.

> 
> > Seriously, I can't wrap my head around the difference in treatment in
> > "human maintainers, experts in the code, aren't required to review a patch"
> 
> Speaking of insulting.

Then I sincerely apologize. I see how I was brash. I did not mean to insult.

> 
> > vs "make the fscking AI happy or it's not going anywhere". It's almost
> > insulting.
> 
> Look, I know people are busy.  If checking these reports slows us down
> and we end up merging less code and less buggy code then that's a good
> tradeoff.

Sure. But I'm thinking about the human factor - I simply don't think either
contributors or maintainers will be particularly less stressed with the
introduction of obligatory AI reviews. Maintainers are still hardpressed
to review (as is their function), and contributors need to go through the
tool's output and figure out what's relevant (and _true_) or what's not.

IF we were able to codify the MM process like in (https://docs.kernel.org/process/maintainer-netdev.html),
with things like:
 - NO patch is getting in without being 1) written by a maintainer or 2) getting Rb's and Acks from M's and R's
  - Ideally both, but maple and DAMON need special casing for now, I guess.
 - NO -next content is being accepted during the merge window. straight to /dev/null.
 - review state for each patch is <here>

it would already be a huge, palpable win for everyone involved. Some of
these have been asked for and discussed by people that are much more
load-bearing in MM than I am, for longer than I've been around. And would
make more of a difference than making sashiko (which is not reliable,
experimental software, etc) load-bearing.

> 
> Also, gimme a break.  Like everyone else I'm still trying to wrap my
> head how best to incorporate this new tool into our development
> processes.

I understand. Ideally, sashiko would be a tool that maintainers and
reviewers (and submitters) could use to help find problems. I don't think
having you check every AI review scales. But I also don't think we should be
treating LLM output as if it were a normal review from an expert.

-- 
Pedro

