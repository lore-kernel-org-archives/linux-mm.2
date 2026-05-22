Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0DD7CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 468556B009B; Fri, 22 May 2026 09:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420106B009D; Fri, 22 May 2026 09:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32F476B009E; Fri, 22 May 2026 09:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1FD6A6B009B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:11:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D823B120161
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:11:18 +0000 (UTC)
X-FDA: 84795091836.24.0727D6F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 486914000E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:11:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nnn6LREn;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779455477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nrj1M7t7JdiUm31R6wOAJFhKfFY3UAipdy+ym3Mbjk8=;
	b=6w72FK+RKskA2VVrIJn9FsprfJ7ugeXInoX9xh7KxUNlN3w4AT+8Pevu9oBPqyKn/FVDMh
	cMuvMJwQyHygwCELpmYwRlbhD1ZIu+Fe0NNTlq7ZIiNN2pjWFtWErpCNS+lMQFF9fSo4UC
	nyk5hbG9l7zg/2ixuKJa3dCkQ5gmQQE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779455477; a=rsa-sha256;
	cv=none;
	b=Kr2w68Kk4miOjD8xRWYNJNs+GcI3sXDHuTZ18qGYVeKvQdEHc3AlWPEBC4yvQ87RbTOW1+
	qCPvjzYN4K1DC1SpeDjIUFWcohDHYX2sfqZDFZ5raDpBtFtVxckoQrBC0RxVYNkzrEqKw2
	l8DS2f33wd6txvgbhREJIN1lZGtga4c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nnn6LREn;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC7E8601E8;
	Fri, 22 May 2026 13:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD09D1F000E9;
	Fri, 22 May 2026 13:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779455476;
	bh=Nrj1M7t7JdiUm31R6wOAJFhKfFY3UAipdy+ym3Mbjk8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nnn6LREn6/bKi8ue8FsN6NzABofKHHhWhj0eDDZKPN0gZAbnxKO41Zk0931LtkEuD
	 RTWoM6MjferN2trIWxeogd1ghjN35n8EzjCXzlDz5D2mfPH5P8XuwjuJZ2YjaV50E7
	 mBq6MenX93+6+aK72iVdc88QS2g8AHCBPNcSBWhxYEQWPtK8UwpvSIF4f++U0b1D2I
	 NMKbhQ2nm5JA/UTW/+yQB/qBq5Rvu9eMq4zNSZTRe+rwJtpLjK3qZUU9yTHSgeXcEH
	 Bh6yQjx5ePW4RHVFMs1YZKqkwBwtjKvoG9F+urOozEDp34XlUnWGaz4XMEkEpHaqrQ
	 SFwWMpRBQcWhw==
Date: Fri, 22 May 2026 15:11:11 +0200
From: Christian Brauner <brauner@kernel.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with
 read-only files
Message-ID: <20260522-haltestelle-laufpass-volltreffer-3c69a6d84fc4@brauner>
References: <20260516182126.530498-1-pfalcato@suse.de>
 <20260518-starten-messdaten-3b8aa670ec85@brauner>
 <CAG48ez0jbSUgT3ZxPKZP7Eu=K7ce2cX7k2NzHCHNMOxQjOGT9w@mail.gmail.com>
 <177918418452.771415.4371785688744608623.b4-reply@b4>
 <CAGudoHFtecdkcYpFrtM5RAAPSU11eL_ALPGp_jhtHW=WxyHE4Q@mail.gmail.com>
 <177918837114.804096.3977912252785122973.b4-reply@b4>
 <CAGudoHGSZOEzbXHOAGqrdp6D06JQQ5Af759TQ+HiQx7=ruQa-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGudoHGSZOEzbXHOAGqrdp6D06JQQ5Af759TQ+HiQx7=ruQa-Q@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 486914000E
X-Stat-Signature: tenisbddyf7y8wtroe1sqerd9cez6it8
X-Rspamd-Server: rspam06
X-HE-Tag: 1779455477-888751
X-HE-Meta: U2FsdGVkX194YinhUEpm8AdD4vPejQyNayj1bRHgwVT3CvAro1Y13qYLE5P5qlUeESp0LXUgavOoACR/W2pYiuG7hb+siqHrzfh3rl2g/LhDjQWqKmKqMw2P/arJJs2e08O7ePgj3+9kgBW2zLX7jPLudEruAJDq9DY/RoBcCC8tMxKGYF0bGVosoAMEHqnevB6pn0+PGK+ooWBYjrML9G8u582AxXV6v8vRedUmHsmi03tgAZ0G6ptdCDOF3qRV8bhq+YDpIqpJaoJOvq/6m6vGzEOdof4HYTv7po0VtObv9rNaKbJiAyiFfYjPare4ASZyRxO/JHnAZnTf5rji3HDwSt1OlfWzvVEqkXRkzXlY2OgnLrL6dJcZutaZxXIdQTvoxw/UIYd/nzNl16dPLrWg/JQsalpq6/HpZ3H/Q6T+PeNGvwBiMiXDJlyMaGLa3dZmS9yav8Yq2hcPWcjWG/rJv89V8rGT1XRq+dX3sKdyk46PQeXo9EaXzlMmJVwKy8XdtSzRpFKE4HSLrJd7MdjyWETpawqiKm69s1tusK3/+42F22BZ/3VhckrlUOouFxucp9zQA0wZCYN2G0FQ7U0lfkADGmIcw47DozCcT3UnxghrnBHqq6CpE/tktCKyH9njpNlfeKXRbR5fm3x+m9n6g3DnbMHHq8A8kLXA7WPq1AIAZ+J0FLxQkoTdkCSnZ2J/a1iekMS+wfiHWbbLb5XmThkK4walVAM0vMjX2Zsbkee4XkGqd6r5GSb/ftfMn+nnmPDp4m10tZJcemKAbxKvonpIXhkLdXVpE8TbRlYnpv1oOw331ReSKwG44jxMGmgj05N3LLEsFarHo0fskV12mrkSB5qRqJEF0cQS3YBqBXkZTaJp253BqFy+MslsgFuypaF8UIcQFA2U66xeG7N9mmWb1eS8rKT4tjtpA+lE6M9vKcS7nB8KSCYknp5Pd31+OkduCYODfuhr8x/
 G+O7i0nD
 AWjdxHZsPqNavQbQNFLMXz/ozeXpCT1xt1DMhJtKm4cnrS8KtU7TIbZaPqBVe7PHPqbRCWTEwEIEdttuTuLniVODNBqDT33gJJ6UMcNYhFMId3gF1Fc+YnAfhzVHNXoGq6q7vvoouQAhbDkXSdG2oID7jxB9+X7chX0kHK5s6kPwNAvKq5DmVo3jBo20BSeRLQu5ExTelJalLzw4atLLsxGtrAIqOx+xDQOTgi0cvh//av4lJt5aj4PgspE7vTl4UBCXklXASx14FFyn1EB5r72kMn19nGpEEuQexqy4ZRYgPL8GD5hsKP7XLv9Rjy4wDwxVbLdCtjh25pfBGjnvcn52Va6Rzjhq0/I+my6bA0ilqGkv23nHYtvR7xeMptDR/wy1u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 01:56:42PM +0200, Mateusz Guzik wrote:
> On Tue, May 19, 2026 at 12:59 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On 2026-05-19 12:51 +0200, Mateusz Guzik wrote:
> > > How about denial of splice usage or degradation to copy are still on
> > > the table, but based on a different criterion: whether code involved
> > > is "known good" for lack of a better description. iow the kernel would
> > > maintain a whitelist of "safe" cases. Random-ass AF_NOBODYEVERHEARDOF
> > > does not make the cut.
> >
> > I had thought about that to but I felt a bit iffy about it. You could
> > envision an FOP_* flag for this:
> >
> >   /* Module may use splice-like apis */
> >   #define FOP_MAY_SPLICE          ((__force fop_flags_t)(1 << 8))
> >
> > But that doesn't address how fundamentally broken vmsplice() for example
> > really is and that probably no one should get to use it in its current
> > form.
> 
> I never looked into the area on Linux, I am willing to take claims of
> breakage on face value.
> 
> In this context I'm saying the functionality is used in the real world
> for performance reasons and just whacking imo does not cut it.
> 
> >
> > > Common-case usage would have to be audited of course, but this sounds
> > > rather actionable and would provide hardening without much friction.
> >
> > And that's the usual problem where rando module will just raise the
> > flag. Maybe that's fine and we will keep up.
> >
> 
> If this is a genuine worry the whitelist can still be introduced and
> managed by one person (Linus?) very easily. The implementation is only
> mildly cumbersome to get going and trivial to spread afterwards.
> 
> You could have something like this:
> struct file_operations funky_ops = {
> ....
> };
> VFS_FILE_OPS_REGISTER(funky_ops);

Unless someone is going to do that work a sysctl to force degrade all
the APIs into copies should be ok.

