Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72CD8F30280
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 20:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5EFD6B00B2; Sun, 15 Mar 2026 16:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0C626B00B3; Sun, 15 Mar 2026 16:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B18A16B00B4; Sun, 15 Mar 2026 16:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A00E36B00B2
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 16:00:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4319E14084D
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:00:03 +0000 (UTC)
X-FDA: 84549363486.22.47D6EC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A83C11C000A
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:00:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rtbiXdLB;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773604801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0f+hfUgStiz1f2izB4RXBtzLgu2bNEZ2vyk1FR/K9Fg=;
	b=x2LI+6oceLC+Mk3oxCk/DEEc2HN/NCxBFw2mmFux+PJA5IEEBU9b4jVPWE94fkJhc7G35X
	MJfOg83memj1Yz9m3Bjal+fsgi/T+9Ih45KNCJpelJ6JsToSoVmYl60UencM2klH0dwXx1
	kOvjvgtZf5iry1xjkfEDSZHc703DAVI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773604801; a=rsa-sha256;
	cv=none;
	b=tPE0lPDq0xv8Zjkp+OiWQ0PdFfpxfzEEUra0ehVYFeUev8jMpZ+kuiywIJMxs9jHDeTuJ3
	EI4mz3a/6NRSIds6EXkbiQjeg+BCV7jVJO0lsdvO2JzspwyKXDdd55nb8RGYo4ev1Vf1XN
	Le4d8jUqLysVPrLosJ6UE9QijeM5YIU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rtbiXdLB;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D31560008;
	Sun, 15 Mar 2026 20:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4FDC4CEF7;
	Sun, 15 Mar 2026 19:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773604800;
	bh=Lexcg6in9cL69Um5lcDqZOQOEWOAZje/HOO6t2WUtxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rtbiXdLBft0fHSp+v9cU4W79wZryD1X4oWd9cNE7ywjnFTUV2reSvAk2A/IFmC6lq
	 Kik8SaPvxx1yMNEc+UhfeRMqHsRoStzk1SjU+CZRJlVA3BVkw3OcJLJlrmT3Ehxuvh
	 nxbZp+lCa0+ZnPo/eWENxmIva/buR8zQyULtSWjkQUivYDeBYDDxXyrAzNqMz0c96S
	 0FEG0VnhD1Q+j7XIStDST58545vdZi11zpY/QVoh4G5qN7UbEre0y2ejjWNcHu8q8y
	 atf4K3zRjXog0QoVLsC1rHMF8yQ5AvSAtSjozN6CUC7E7K+4qZEtTammLVBiOoK+44
	 lj8+v9i9QbsoA==
Date: Sun, 15 Mar 2026 21:59:54 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kit Dallege <xaum.io@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH] Docs/mm: document Shared Memory Filesystem
Message-ID: <abcPusHClDoCeE4Y@kernel.org>
References: <20260314152538.100593-1-xaum.io@gmail.com>
 <87ms0ajtvy.fsf@trenco.lwn.net>
 <CAAZVx98Sz1MknCcMpQXxeGpUjXBDyz+0KyRuUiCXsM+3qzqpeA@mail.gmail.com>
 <20260314111757.2a17c3acce8c3a1eb68ed209@linux-foundation.org>
 <09920346-0caf-466f-9c12-5f086d99411b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09920346-0caf-466f-9c12-5f086d99411b@kernel.org>
X-Stat-Signature: tgragt1bfktg84x5xf54jzna6g85wpax
X-Rspam-User: 
X-Rspamd-Queue-Id: A83C11C000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1773604801-291875
X-HE-Meta: U2FsdGVkX18VBRTN5bcAVUr24jCJyGfSaff6X1X3cx6mm9j/aYd6QovFj9MCEPB9xfEoqr+WzqLvWWvKOBKIZGBGONxxvjh3qGtRB75FXKvZKMqkSSmyWND8X2SA5tAe8L749/4/4Kbik5sneuNvIdo/ymmHGRQZXJQf5KH9AHW9/7skZFOPwbQ01OZ1o0QRKwnaQVqcQtlrJ+ZyEdimAKKqg43GBQYryOoWaOKMAtWW2DbaV5JsTy8fKCsbwgJjbwibbWQc/OKGX52STN3HZjU051qlqYpM2Mi1xYwfknGWHMQLr90C3BVW0Vs3u5PqfybcmywkGnHb+iMQ/jJOdNb0uyuMtyGR7UPPMbOecXvRMybI/8/0yXE6liLiYoSZznYNcu53WFqKflByRBy7R118fjodT636erhF1pT8HAotsidVAKFhSofsumz5qxoAr4sg3OlmIum/abXhDNAhFK3Ly1ySS9x/h0bbVAAunvISi/eET8w2q1PLUL5Je7eHRsFPKqyzzeKXy/03eqDjqFTyR1/RL93nsaiXgLRSdmGEuehgx9aZs/Boff82frx2IN4Z8baLZt0lI1qpQWwPa4mTMkrY6E9D2Uw2V2a89Qo1/IuMRXqCmimjE6LbuluJRqxbb4n70KcPcnFc0tAmPvGPUY3Ao8NtIpk9BJoP+KiDEKiNqo7k645pchxbxf1IZiJR5dNDpQP4NfOhZYD8iSiJXzhJjdEotJxhTfTJBOX0PAqW3f58lc36/RvpDpKy6LFWZqs9PKqdvRJsx+WkH5H9/H+3q8tyUd3ZiPLwf51l26NrRW4GIz2W4dhlW/hQeBCxifJ80K+e+jnt0VCqdVKMSlkipvrXPjcQj0aWsC4/OlriKxmyhj3iKt3raQUfv10QKYq2MEnydspaS4yQkJOpWZjhuPFYFLHte5W/zPq2Id05KJ45IyJ+dLy4C1gUh+LYr+1gtHMyjicHuHB
 meIZ1ixj
 ACjfIw6Bm1OPd4NJ7p7HnoOQMjPcZ+Jm89q7BuMUYQAIo0ZlII+cM2nPpX7l4D5a3Y+lECK3I9nBN8W5csZJRnisZZxptLU1u1QBMMF45K7LkYDAxsa4VgoltPY6/2PyvPERIjBuKCwMtoRayaSD6fKvM2u2CxWa27p+gtP1f05f8m4MpKcMh/xOjmem3w82PdKb0m3mAlejYHrhUSp5j1BOyonkyUr0Fhir4g7FPNW/TBDPb1YZfSpoo5uIaWZEcvgZ+1ho7x/AS63WtAjI6FNZSgPn89v0q+odLhD8F5nmTqEPAWDIYZD8ktua23PX6cIDr/3pU7/lPGTtJTMWfvb4nyxsLNtU00YDcbfEFJUWq3K4H+c7HLOkjzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 15, 2026 at 08:50:04PM +0100, David Hildenbrand (arm) wrote:
> On 3/14/26 19:17, Andrew Morton wrote:
> > On Sat, 14 Mar 2026 17:02:47 +0100 Kit Dallege <xaum.io@gmail.com> wrote:
> > 
> > > Hi Jon,
> > > 
> > > The material was written with AI assistance (Claude) and then verified
> > > against the source code in mm/shmem.c. I read through the implementation,
> > > the existing comments, and Mel Gorman's book outline to identify what
> > > should be covered, then used AI to help draft the prose, which I reviewed
> > > and edited.
> > 
> > OK, so you're saying that you created the content and used an LLM to
> > assist in finishing it off?
> > 
> > > I'm happy to rework anything that's inaccurate or doesn't meet the bar.
> > > Should I add an Assisted-by tag to the commit?
> > 
> > Yes, Assisted-by: is appropriate and useful here.
> > 
> >  From a quick scan, this material appears to be helpful and I think it
> > would be good for us to get this into the tree in some fashion.  Which
> > will involve asking the relevant MM developers to review each change.
> 
> So, someone with an LLM but no proven experience with the code produced some
> doc, and maintainers/developers should dedicate their precious time to do
> the hard work of checking everything?
> 
> I'm all for documenting stuff, especially if newcomers start exploring that
> space by contributing small, carefully crafted documentation updates.
> 
> It's then a good learning experience for someone that wants to work on the
> code to really have to understand the code in detail, and what is actually
> worth documenting (and what's an implementation detail).
> 
> I see 7 doc updates for 7 different MM subsystems in my inbox, including

Heh, it's wider:
https://lore.kernel.org/all/?q=Kit+Dallege

> So naturally, I get skeptical when it comes to "I read through the
> implementation, the existing comments".

I skimmed through bootmem doc, it's, well, inaccurate. And with tens of
documentation patches at the same day, I really doubt there was enough
effort to understand the code. 
 
> -- 
> Cheers,
> David

-- 
Sincerely yours,
Mike.

