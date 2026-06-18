Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB0B5CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 20:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57EB96B0088; Thu, 18 Jun 2026 16:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52F826B008A; Thu, 18 Jun 2026 16:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4474A6B008C; Thu, 18 Jun 2026 16:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA016B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:58:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 914EA1C171E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:58:56 +0000 (UTC)
X-FDA: 84894247872.30.B59E0D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id C9AA140006
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:58:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=14nCRR0b;
	spf=pass (imf12.hostedemail.com: domain of konstantin@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=konstantin@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781816335;
	b=TwztH4qrmgn/HSCPYA6SPt1J20/6dyMOm/0tdEmhsGpirIpau47aO7GbQL2C23nXwD4cbP
	Xwr4amOfSXv0dmxSIR+PT9qjLfzu8KP/QHnkJqP2OhfklheZo/vYjR8PNk9iBr9s5nOfg1
	XVRNcW6e+bWr6IHSqpdQXg/USFLJAIE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=14nCRR0b;
	spf=pass (imf12.hostedemail.com: domain of konstantin@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=konstantin@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781816334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zljnJf5HQ/OchNgTmG7P8Dn2J1XlofQvwnuh99sRKhw=;
	b=eYseR5gspf6GI7z5qXxvl6d5ePij0OdeI2SVHiCegIFbgXxeFPzz9m5SQgSpBJc2lug5mG
	clPi7ZnzoIJsTKokuOOg6MqvRVK0lpzmc5mLhWiAFliRtoSPQNzl/LkyEM6fTcIiEGibOu
	7g9+wNLFm+mAJLNt9VfVxdnr96OHv14=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA7CC439E4;
	Thu, 18 Jun 2026 20:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABCF1F000E9;
	Thu, 18 Jun 2026 20:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781816333;
	bh=zljnJf5HQ/OchNgTmG7P8Dn2J1XlofQvwnuh99sRKhw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=14nCRR0b5Pj1LekQo1SNTGbmG92AW/Q7K7Qx8i1tT4iBid+jV1StR1z7LwYvuQ/yL
	 jJzgKYa/fxPEdC/TYjiN1t9ZN10RTqs5WV0RMuvKXYAJdvs3Ip2thSRhx3ELwqoqUe
	 u2S3Pw7myyvQNlACXAr3DajINMW8m+u7cX7fom+Y=
Date: Thu, 18 Jun 2026 16:58:52 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: pr-tracker-bot@kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] MM updates for 7.2-rc1
Message-ID: <20260618-first-aspiring-wapiti-71c024@meerkat>
References: <20260617153144.acead3f2795da15f1e56005c@linux-foundation.org>
 <178179616355.2947725.4377157124023044624.pr-tracker-bot@kernel.org>
 <CAHk-=whn39dQtoMeJrz++nAnZpgnrooU0dgzOZXdn1LyxQ+f2w@mail.gmail.com>
 <20260618-generous-sceptical-jackdaw-3d32db@meerkat>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260618-generous-sceptical-jackdaw-3d32db@meerkat>
X-Stat-Signature: t6t86yug3xxq7ythgd8u767yfyptdr66
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C9AA140006
X-HE-Tag: 1781816334-115424
X-HE-Meta: U2FsdGVkX18NJM8Xq52jB+a1mlSgG0rbclNVEH5OUGdfGUZwV7nI9SQNooWlXOnCccX6dp4KGxRCDbQKVveo/wu+Iq1k/9MgcsL0j3bnkKpweLWdDXDetYu/37eX4pjA7ikUhkvQAZkPAWAh4RO7U4wa51A8zSpG7X0OXBgb9F/l/XgdivGfN0WfDOWW9GlMcaTxq5L8Q78PFIAHic7qt9+YgQbjGR1P6ZPH3y0uhHjZknSnWm2Uz/hZP0egrOb8XajVuoogFN2z3+782Y0pxcVtuYjybNCBzInQ27iDoHV76HV+VJ4Z5HeZ72JOkGpe9YbtK84y9t4W58uznniNg92J2aN+QBm/upe+mgvqlvmVoHIHVy0tfYIElTvK9ODP8zA5v5mwzvQy8WFPtsgG7utILmwuFX7Tus+RVQXE94Uk9wFNdQaB2H+nNlSZRM2Gsy7+jSwEiM+iC/tyJtMZajfj4EPOJxCiDr/VJfb8LgZuamf1LaNOm8yJFUQJgeLB/6Qw8fKdFjkgd3dXWo12bVgQ2CMYBNFLZXaaFquAjG1S+OGU+fbGmcxst4BkDNB3tsMkHdJeRoEHjeVaEjy3+bdt+Pteun1sl5924XGTt2d+T98bX+dgIf9XuAIabxkWdCwnR5WRPZxgsrG/nN659jTc37j8t6RjdIRa/WOw8PWuDwAnRc6j22yHkztgCeLuu30Ec9M0YdhXFzHOslzz8IBovbXZHfHwQh6S2aevMJriVqOR0StLiJ7hCQQ9nmvfAqyt5Y9mAYZJQ9uEXACm05ViYUujZDx2o79XgMQtHsAlIJdZQVJG9C97kPU+lbZGxu+G4WNLKMg3z3nu26k8KJGFNmJXr/JoHl/bB3mpMGwbr5TDhIFeGQQ993kEFT6VBG6HwI1FvuwyzGav9D+SSj9efwzBuAbpOTpPIKU0EwELFW9dUhe7grIafrSsstsDqB8J62Rz/LehhoZJBbA
 O19Z8xyf
 SOCh3zawXq17i8/GSISMmSuf6Gy+f4pnNmkbn9LHyha0yeq5i2Ec+Cm9T/Q48CNMuFGxVeTNJqE05tjJge3l1jSID+6RX0Ob57G0epuEZ4nIqeznFsFKwU9VCCtCKB79hDwnpnGiU1fkYcIpFg8wbZv0JkyRReRd2C3xJFNGf/xCVFl83BNuuHMG1ZJl8VCR8/alpQIkY46xPTOKeOo3dDTNBXBTYu1JHocZejA/XNNKUhnBkeD8p2kPsiyd8T9AUIkqCiZYvroynG7g/CjcE4wI7+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 04:37:52PM -0400, Konstantin Ryabitsev wrote:
> On Thu, Jun 18, 2026 at 09:02:06AM -0700, Linus Torvalds wrote:
> > This is very wrong. That merge (2f9f5887b427) is merging Jens'
> > io_uring epoll cleanup. Not Andrew's MM tree, which I haven't gotten
> > to yet.
> > 
> > I wonder why pr-tracker-bot got this wrong.
> > 
> > [ Goes off and looks ]
> > 
> > Oh. Andrew's pull request is confused. It says
> > 
> >    The following changes since commit e771677...
> >      ...
> >    for you to fetch changes up to e771677....
> > 
> > and note how the "since" commit and "up to" commits are the same (and
> > is my iommufd merge). So then pr-tracker bot thinks it's merged when
> > the "since" commit was merged.
> 
> Let me at least handle this situation -- it's clearly an oversight.

The bot should now properly recognize when the start and end of the range are
the same sha and ignore the message (it seemed a safer logic than trying to do
anything else).

> > That doesn't explain why pr-tracker-bot thinks it got merged in what
> > was me merging Jens' tree, but whatever.

It's "bad assumptions snowballing." The merge commit in the notification isn't
taken from the pull request at all -- it's computed. Once the bot believes a
commit is merged, it runs:

    git rev-list <commit>.. --ancestry-path

and then takes the oldest commit in that range. With <commit> being e771677,
that is simply the next merge you made after the iommufd pull:

    $ git rev-list e771677c937d.. --ancestry-path | tail -1
    2f9f5887b42711595e768b9dc0582dccfdf60c3b

...which is your merge of Jens' io_uring epoll tree. So the bot wasn't
associating Andrew's MM tree with Jens' work; it just tried to do its best
with bad data, with predictably bad outcomes. :)

-K

