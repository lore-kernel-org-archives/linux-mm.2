Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89F93C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:13:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 861916B009E; Mon, 13 Jul 2026 12:13:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EB9F6B009F; Mon, 13 Jul 2026 12:13:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B36D6B00A0; Mon, 13 Jul 2026 12:13:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3ADB06B009E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:13:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1364F1201F4
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:58:11 +0000 (UTC)
X-FDA: 84984209982.25.E91C0FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 42088100013
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:58:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aeYsF86g;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783958289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7wJM8DAMKw46GCCUOJ84lZ1VhKPOJwTAzm+VqeGupW8=;
	b=piDg2COXSFXdpsrejMD+L/fWlttm6BrjMcUUOmMFFkux3oUWUEH/mgk8+UoyXiAic5gkmj
	F8w/nmmJVR5K/FahukIWKpo5osYxDWb8lz2v+pEtb/ktYKpKy2O/Kg52cgK5bO6kZGKV5c
	hgoBOzS0HHr5Jam60huN8VrBTywT3jk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aeYsF86g;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783958289;
	b=TNNCcaMqe2DQHmWH9RYbF1HQOkWD1bYbijyjM5eDnOO8W8Q51KTieg/4Fs8vSnyr4qMqBE
	eLabH4c/L2eaT9EFaUPZE0c+zz/Aj+cJPa5mdiKqHm1D7UiwnbRvOTV6KTG5opQwYMdg0z
	tINj5gGPF4ulbQ7kKxlMeTzHssxLnRk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C27DC600D8;
	Mon, 13 Jul 2026 15:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405271F00ADB;
	Mon, 13 Jul 2026 15:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783958288;
	bh=7wJM8DAMKw46GCCUOJ84lZ1VhKPOJwTAzm+VqeGupW8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=aeYsF86gJr53IfRDB1RqxivdjUIvzEMc74CYICJbuuLw/2SubhKRONGhF10y02Lkp
	 jV/9Z0boG1fR3xQa7N/s2ORvWWPb4F38nF1FYHaxG3OEY54gDKpBA0Kbnqq5ZGxpEB
	 rq3CZfewRRceQekqpp32X4ATzDl7hSJV+2QXNfmYEJllA4wFpGB1jg1+ZrADZaUM6E
	 gl83aR4yG7HhApOgNXIGTueLSOSZAxLobIak9OSxjZnfw6j2V/FKsNZHpnnFTV1ldm
	 wQEPtaYIkX/zFlhR/nYE0HnCZM2Sz0/lrrlQaAGkatqlQ3iVOAhgYnp1ESE6pLZo5C
	 pxFc0nAnBn5TA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 0/5] binfmt_misc: bpf-backed binary type handlers
From: Christian Brauner <brauner@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Shuah Khan <shuah@kernel.org>, 
 Andrii Nakryiko <andrii@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, Jann Horn <jannh@google.com>, 
 John Ericson <mail@johnericson.me>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
In-Reply-To: <DJXJM0838IJN.3AJ9MMQ89SUUR@gmail.com>
References: <20260711-binfmt-misc-bpf-v2-v2-0-d6591ceaf207@gmail.com>
 <20260712-abluft-brutkasten-aufladen-c8063a4a1a0a@brauner>
 <DJX4IFO55D9S.3IV3K5XICJAEV@gmail.com>
 <20260713-unerlaubt-luftkammer-kosmetik-46532d395f9b@brauner>
 <DJXJM0838IJN.3AJ9MMQ89SUUR@gmail.com>
Date: Mon, 13 Jul 2026 17:57:53 +0200
Message-Id: <20260713-gekreische-membran-samtpfoten-6e0eb34e2a41@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3021; i=brauner@kernel.org;
 h=from:subject:message-id; bh=W7eem1hxKBhR+qpjzH9sJ9OjOv3VJKcUDquaXYlqrJc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSFcrOc2nn2/tZvaXmvTeZkTFpuxnHv7D3Xa1O+fLnM9
 2Z31HoV/Y5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJdJszMvRu8XQ8odlSoLbg
 R9yru1zSvLEL93Lx9R6dMFfslWqImQgjw5weq6gb9nMM2Pe/CLVbr61ZMHVyiM+zwtQLyts3nrs
 rxwUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 42088100013
X-Stat-Signature: rfttawdwym61j9heb917fq4j6a54e746
X-HE-Tag: 1783958289-910163
X-HE-Meta: U2FsdGVkX18dQAT7YogP8vUblDN1+bG4MGVJrNFVxiqw0ykzJQfs4Q3uj5runAKci6nC3KF4CNckCxadx0KKPbGQAGZl7hzXxldZfO7eIXTvM1MJ0BPS+IJxfmYUvf9aOHYIVxsBwY5aFccxzOoidQ01L47lNp8WZ9TkcmLewBhluT9OW0htbKRILCVE5p83SzP9PJ5/MI3IjK6u3mjX56G6qShrv3753ADo+8ilG70Egw1zZx7D7x0dAHBHxwO7fLoJby6SfM1mt/S155mGpkxizQ+2GyyRAbV5Ab3TH9mUygFGOfNS9qgSnuIW9aNQ+x+T/m2A3T7I2Ukn3HOvUL+YxODws9Ow3IHADZT+UGQaO7M6skpg8VxiOBsL7r2ru7PK4S3wjg9sWJxwEAnKNV7FXHmpX0pzcIA+nXGAa85WT6tj2LYo5fSMY4DR3rQCMfIgP/PV7gTjbXXbtutocdt7sS64AduJ0ycmyKmJU0ppQPCdCkYDsRrEVCSJDgt4yRzfz2aR2qYf4AldO7gd0ILmcagvp/sOJ2/QbdVamcQRoOlXWyY9EQiWUehOKjveG7GJF1hEqS/cQrhqIwSGg9kxGk1D7SRsUA90P/PC9Ly/ASnio4eolPwuRjzp/6N1kkCJhsCZqp0/uvguNNu8enV4TvqohdT2xohC3C7dnMTuJFc+KULkjPNgNxMXcQaTE9FuKiCZpiDhSHgGSg+CW6a3Ks0wgidDoCp7xXAKxJT9RiV+kzGmXXqWoPRJIViHbfJgpt14LBkk5wlod/dr1Kn4w0AuvTbzyE8BSMN1Bxa1OUnrjfaaELLOOT7UdHl83LxqVT6rJneErQSKhmbLumo+xU12mdekAF+55wwk+HVL1jWe4fXQCRC3Dvn33G0SRqasefURbk6Yn7u5GYRhuz1EAVT+gVeeatpYQjOazrHpNWsgCZnHNp3/T3oCeo40yWYNVxKy11mikIeyoro
 m5j38iXr
 tL5Kr+wEqyZjoDKKfdCcFC+zpwu8u4hCmzsyJYAAsSG+rvin8pOkWglB87sT4lrLSN4ET8LX6xXwlPOqp2Q6NYQp12tA1pwZR5oE1S9cDXAUJr3tnPcGUuRkvPt63dEOaCjFHDO/+J3l0a0OJTyj1A2vJZ9bDinpwk1Ff4SViNrOJt1XFeIWhTQGikPBf4o6odnKsVFWNFJhi8X9BCOm4aSwC2OpGCdB9l8FK9UsW/jkT33TQEAOPteOEd0bZjUimnxayZGjpVeExJTn9Ccc1Ypw3Kbd06ypgY03lyK80bM8cRG4m8crglSxaqkXb6fkfidQRQO9PFHNiXebkFVzkIFhU3m2amq9W/ivsg4iKzmTb2XDMN053WUj/mJ+v/rYD/DCuu+sa/T12XAI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-13 08:19 -0700, Farid Zakaria wrote:
> On Mon Jul 13, 2026 at 1:20 AM PDT, Christian Brauner wrote:
> >> > - The single sleepable load op is split into two ops:
> >> >
> >> >       struct binfmt_misc_ops {
> >> >       	bool (*match)(struct linux_binprm *bprm);
> >> >       	int (*load)(struct linux_binprm *bprm);
> >> >       	char name[BINFMT_MISC_OPS_NAME_MAX];
> >> >       };
> >> >
> >> >   The non-sleepable match program runs from the RCU entry lookup
> >> >   walk itself, exactly like magic and extension matching: same
> >> >   registration order, same first-match-wins semantics, and it can
> >> >   only rely on the prefetched bprm->buf. It must be free of side
> >> >   effects since the walk may be restarted.
> >> >
> >> 
> >> Is relying on brpm->buf enough?
> >> Right now that's only 256 bytes I think, which is not enough to read
> >> segments we might care about. That worked fine when it was just a magic
> >> number but the idea with the eBPF program is to make decisions based on
> >> more data.
> >> 
> >> In the selftest I provided, the `PT_INTERP` segment is already at file
> >> offset 0x318 (792). I was imaginging NixOS having to support
> >> `PT_INTERP_NIX` in order for the produced binaries to be backwards
> >> compatible with older kernels.
> >> 
> >> The other idea would be to make the `match()` broad and select
> >> everything but then nearly all ELF64 binaries would match and then pay
> >> the price to `load()` and ultimately `-ENOEXEC`. Seems like it would
> >> make multiple BPF binfmt programs less useful.
> >
> > Ok, so your idea is to have multiple bpf programs that look for
> > different interpreters. Yeah, then you have to be able to sleep because
> > you need to be able to fault. It makes the code uglier but I can see how
> > that's useful. I'll see how nice I can make that.
> >
> 
> I mean... I thought that's the intent to binfmt_misc, to have multiple
> handlers -- with the expressiveness of eBPF vs. the limited

I was thinking of having one bpf program per type (elf, python, etc) but
I can see how it's useful to have multiple elf bpf handlers...

> > Ah, fun. binfmt_misc wasn't able to express this at all. It's good to
> > close that gap. This can just be done by adding
> > bpf_binprm_set_interp_arg().
> 
> What is "cool" about this is now it's also a net-new feature for shebags
> which the "old" binfmt_misc didn't support. Anyways, I was thining ahead
> about what I would need to support $ORIGIN fully and this was
> a remaining gap. We also explored this idea in a patch pre-BPF [1] but
> now that we've settled on this solution it seems much more natural.
> 
> 
> I was recently reached out by some Bazel people who are also interested
> in this $ORIGIN support. Interestingly they let me know that

Yeah, for build systemd it's very nice ofc.

> IllumOS/Solaris had support for it as well.

The whole $ORIGIN thing comes from Illumos/Solaris afair. So no big
surprise.


