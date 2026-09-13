Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FCDDC88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 22:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605186B0088; Sun, 13 Sep 2026 18:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DE046B008C; Sun, 13 Sep 2026 18:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F1DB6B0092; Sun, 13 Sep 2026 18:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 238EC6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 18:47:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 89E9540C0D
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:47:30 +0000 (UTC)
X-FDA: 85210227060.17.1672D69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id D3AA5140005
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:47:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GX2L01Iw;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789339649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oc0kz/Lcz/Yn57rNNFxonjfaQnrj/yxO/lHTbtb3iGA=;
	b=N1/qsaioBiXp5Rz16c+oRZEprkEuXNB311HkAFnz0i+Xu+04jgYQTzFsXkhck7k198IjlX
	U/hRWNvBiz/82fQ/WtUAS6BSaT2XjzLbE0yTd2j8dVS55zyMtl/WMWisDDKhQBA7XNsm4D
	cDkw40NxZ4fADtPlgVI1qNO3wkAme58=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789339649;
	b=UXz1pEQW7QfNNWx8qgXeOgAK70W8TyLXFvIIyxe8S6jJQhL3riJ7pG3995PliGymv/SP7e
	Uof0kBs085mKsSY+mjbcabgrFiZMjgrBgqTYjVBM82jS/FQ2O8t4pLyAwsdmS80qvfJmj9
	3F+i8wcBueLcL0QnRU1OCZsB8kRPF2o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GX2L01Iw;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 122EC61002;
	Sun, 13 Sep 2026 22:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610AD1F000FF;
	Sun, 13 Sep 2026 22:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789339647;
	bh=oc0kz/Lcz/Yn57rNNFxonjfaQnrj/yxO/lHTbtb3iGA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GX2L01IwIepGX/OpWrrq1g1pz9hcsLKwHhp6MlxZAmZeAZO4+EKEVTQLTKQpMhGg3
	 eGhyJ0Pf+TTd9QAE1RBh5HsR2rM7B5SuaQe5na1glgmg6JOwWtyxq4riHNCiO7h4PW
	 BMzvX8RXR85eJmDDMYzOw9cmYD9HzpD5eZ/StjwY=
Date: Sun, 13 Sep 2026 15:47:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yuan Tan <yuant@nebusec.ai>
Cc: linux-mm@kvack.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, notasas@gmail.com, rakukuip@gmail.com, Ren Wei
 <weir@nebusec.ai>
Subject: Re: [PATCH v3 1/1] mm/memory: constrain generic_access_phys() to
 page boundary
Message-Id: <20260913154726.be94acada0a925cf6dabfbcd@linux-foundation.org>
In-Reply-To: <1146fc8a-94c8-4e28-aa38-cd0322bea9a4@nebusec.ai>
References: <cover.1788842306.git.rakukuip@gmail.com>
	<e06e28a46c2a176238f03b5740df0913e57c2861.1788842306.git.rakukuip@gmail.com>
	<20260909231815.bcb1ca6091ae0ba1b5ba54e1@linux-foundation.org>
	<1146fc8a-94c8-4e28-aa38-cd0322bea9a4@nebusec.ai>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D3AA5140005
X-Stat-Signature: q3fgt3ayfm8su4swztfnir47q71hnzky
X-Rspam-User: 
X-HE-Tag: 1789339648-228903
X-HE-Meta: U2FsdGVkX1+Vy6L45cvJWZeehG3q1xKWqPNWa6qQ8pJKJmi0bLORDKYMEHXGrLmfEszoamK50ijBtC34i64Zzhu3upWF4rmpD62yy8T8o49Rw4AkbkHfHRkKymsIqwF1RsmVBra4lzXzzgDRdEvnhoMbZNWLQLgMNICqHrBuyRB3rL3o9+H+x4o94OwlPkDbX6NLN9vFZxQYSVusKc2fHsLKPnDJ+2L/t2arMbGcrS+oH45OrFu5R+n1lbzt50a1/+9CyXsXaSsdGspgEJtDV7xCWrIz3oyb5m7RMmXge2h5h5GNyG0sQYYqd/6hmMCON2S7xm2dL1JpTMJ9FjooEql5I1NUa1FGINIjQN+2p1bwkASBKGdEVRwVWQpZi+OZ9e2TccpOStgWQdAkKHWA3xcO8Zf4Ep69A/uGh3U1vwhgbrt+4OwPfrZ8lZ/f5KSWmrOnAhQNRJgzbDmCQ5vmTWPlmd0F8x7hvJvcIyL6MajBpgabzmyfGBvmSNPjvTCMLL8x39xvPNJM29GZsvRKuMnHUgjN7CXI+E9pANsmj1FL5Xy5PiEu6P+dAcfeZL6e6bAyZTEqyxol+NEppUZJK49pDBVeJiBCAnZJOWVe+zXT4RDMLtia+WZUelg21d5dwJoTbeQnH3AS2gKzl9qqGqkvL9Uj4MEQoRcPqgiH69gTNa6W3AYqJMBqakMn4dnKqNJKh8bvuu2Dg3VuQXQeoU9+R5ZAmmHhkvRbzGvQwPxL3aYD+yeK3mk/wvUi/RQ/g1YNF/ZCXf3yNQeMasR9dEEdurtpB+/lZ74Ww8XeE2PL1YqUgY0r3kzvueY93Q2UKuk0d9yOahy3y/jxS3i4mXyTnLbUPvSwKYmrhwoOmxskMCL5X5gCQOvr3Fau37MZLFmULVAkAAJAyjHBrygRpqOKZbuz7MBdlVNcz7cRdUYeaxIFLH+Wl5KRQfbd/kSfpO0rJQoHcDV/PE8F2xq
 1V1rXlIG
 n6dOacHY/4legBppepFESj460DMCIOzOI7FL+mLWrhSlNPTh9ICqkTrJi+a+dtesFNFld5j5Zd5uQAHBj80793VcjWQolbDxD+Hqh6ixTdEji0ihur7SIHjl3AVnuYD8sUQ3UzCyeOaYVdiWvNaxLbyyp0Gx9ioBNgasZVgKTeJ8NKkW7t22/NZuSr/xxNbtkHAYbovzq915n/Do7iVVMw+dQCL571nwvqNYwD1KCoOeRlS3tEesfUiHsBhqIXC+0N2IWzqhU1U4kxhlP8+Dlc8hCaDQMre74jG+a27hGD6X2XhZ9i299hq8n34x6DI6qZE8FB/EEpVAdN95y78W70pH8ZOcb/Go5UH4LJ3YWln42Pr+aHEbBt4baSaQYPDwz+XdFGjPGBR3af3E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 13 Sep 2026 01:28:18 -0700 Yuan Tan <yuant@nebusec.ai> wrote:

> 
> >> +	    (phys_addr != ((resource_size_t)args.pfn << PAGE_SHIFT)) ||
> > hoo boy we've made a mess of the types in there, but I don't see a
> > feasible improvement in the context of this patch.
> >
> > Also, a [0/N] isn't needed or desirable when N==1!  I'll consolidate
> > both into a singleton patch.
> 
> Hi,
> 
> 
> Luxiao is helping us fix some of the bugs found by our bug finding tool. 
> 
> 
> Normally, our patch series includes a reproducer in the cover letter, so
> we usually send these patches with a cover letter. I believe Luxiao
> simply forgot to include the reproducer in this version. The reproducer
> for this bug can be found here:
> https://lore.kernel.org/all/cover.1784428532.git.rakukuip@gmail.com/ 

Great, thanks.

See, what I'm always looking for in bug fixes is a solid description
of the significance/impact/risk which that bug has upon our users. 

This impact ranges between "Impossibly improbable thing which some AI
scan found but which nobody is ever going to hit" through to "this
crashes our entire fleet 12 times per day".

The range really is that broad and this information matters.  And
people care about it.  I look to authors to help us understand and
assess this impact.  So please do whatever you can (organization-wide)
to ensure that this info is made available to its potential audience.


> For future patches, if we are sending a single patch without a cover
> letter, what would be the preferred way to include the reproducer?
> Should we put it directly in the commit message, or place it below the
> --- separator so that the reproducer itself does not become part of the
> permanent git history? 

It depends.

Formally, the reproducer should be made part of selftests/, so the bug
can never reappear.  I think that's excessive for this project and the
risk of reintroduction is so low that this isn't worthwhile.

Pasting it in to the formal changelog is reasonable.  Putting it below
the --- is probably better, as long as the permanent changelog mentions
its existence.  Then highly motivated people can follow the Link: and
find the reproducer.

The main value in the reproducer is knowing that it exists!  That this
bug can really be hit from userspace.

> 
> Also, I have been collecting the bug report by llm into a syzbot-like
> tracking system[1].
> The tracker aggregates bug reports from multiple sources, including
> Sashiko, and then attempts to validate the reports and generate
> reproducers to make sure it is not a false positive . It also
> automatically tracks whether a bug has been fixed. 

That's a great initiative, thanks.

> 
> For the networking side, I have already imported the Sashiko reports
> into the bug tracker and shared it with the net maintainers. I am
> planning to do the same for mm, but haven't gotten to it yet. There are
> already a few mm bugs in the tracker that were found by our own tool,
> and none of them seem to have security implications.
> 
> If you have a chance, I'd be interested to hear what you think. Any
> suggestions on how to make it more useful for mm maintainers would be
> very welcome.

I saw.  I'd love to spend time with this but you know how it is.  We're
all overwhelmed by the bot invasion at present, and none more than me. 
I view your contributions as "parallelization of effort".  Keep the
fixes coming and I'll do my best to get them through our pipeline and
out to our users.

