Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C080CC61DBE
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 10:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7CF06B0096; Wed, 26 Aug 2026 06:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2E0B6B0098; Wed, 26 Aug 2026 06:26:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6B1A6B0099; Wed, 26 Aug 2026 06:26:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8380B6B0096
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:26:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7643B12030F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 10:26:54 +0000 (UTC)
X-FDA: 85143042348.02.2E33DB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D532780003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 10:26:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YNGEHSCO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787740012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+T9apJN+jyTN6a6IUkbzHwV2sRP7V+n7AL7iT54GeKk=;
	b=RBZFhZs7QapjODJumBCK3POZT/M0fK4mOI5BQxMniANT1vEpcs+kYdfim/591ws6oHSN69
	YAh8WxfGYvpo5zVpq3JzAFoYKmnoHTgmy5kyjIo6HaSPVVX5k9ryXEnelbVjnhe3SuJoLT
	M1Hen8hyoWGQZ1WJmglu8BB7bdEXz0g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YNGEHSCO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787740012;
	b=yYoxeyJkanVwDBzMwGZhxOyIGpVsHGiReIIbdpFgEdjeL4mr6IGsGw/9QRl67Qgdjm4h+P
	gTdQmvW0CGDoovN4kzbSnAyfAz8GcUrp2N2/hS/fxWrG5KmfWQN4jzYgDxAP7CrpobCC73
	nGJ3aV5B0MK3wTiBeSj8ab4JvbIRBik=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7074B601E9;
	Wed, 26 Aug 2026 10:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332DB1F000E9;
	Wed, 26 Aug 2026 10:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787740012;
	bh=+T9apJN+jyTN6a6IUkbzHwV2sRP7V+n7AL7iT54GeKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YNGEHSCOS9VijyeMWszSZJT8Fx0pJ+dSCcQUBKcEy73C3jvCS3Z+Sw5bRDsd88kaa
	 g5lymxlbgSUPpuQSmVrVyMSOYbGSbgY2ecQx3KFZ21BUnGCwu4BQY/XarUA8rpzIt7
	 fMYpYprfVeJUkzrKtykSh8FamU/JkWdYbV1XhsSjIBaWxURZJc9Av/4ZVkAoVDoGJc
	 SYGhhFo6mFdNki4p+xWxm9h43YILjEvd1V8Kp3SIrR8jsGaX5UrTYO3igvjhsVkwS8
	 UsxVaCvfQwreicdVqO/h8MzROS8YY1SrVCQmcCKdNRy1kJkwbfrMIDgXEUIKhF0ITc
	 TjANFOACnZ3gw==
Date: Wed, 26 Aug 2026 12:26:44 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?utf-8?B?VGhpw6liYXVk?= Weksteen <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] proc: query LSMs for introspective mem access (if
 PROC_MEM_FORCE_ALWAYS)
Message-ID: <20260826-allseits-winzig-hypochonder-1b36f3af087c@brauner>
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com>
 <20260825-passt-semmel-primitiv-37712c04e6c6@brauner>
 <CAG48ez22J6tYZv6cG0TEoUFBrbhtWh6BHrZYBWuD-ee1hVr4ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez22J6tYZv6cG0TEoUFBrbhtWh6BHrZYBWuD-ee1hVr4ZA@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D532780003
X-Stat-Signature: q9t1meb5kzuit69dhc4hfsq67aw97s9h
X-Rspam-User: 
X-HE-Tag: 1787740012-132895
X-HE-Meta: U2FsdGVkX196tWTd0P1TjvmukJg4fzhen0cx5ZyHAxQPoadizNRuqq6xOndZ9+hEkzu3Mq+w+ZGoHRhLP/mGGAtGcUp2NwEqWxwwgJmTc76Em5myajgft4v4Yr8+L3W3F/uO2J1gkeMdk5iBbX2fBICFM5IRutfZgA9aVTiVy59M26tVyJxEElp/CK9YmcI14SVcZCVs2mJevU3uuI9J94GY1CfGxCjkX8YhN0J6aP/fLd3XrvvvcSU0mk6zi01v9Ye1fQJNwtx6zKew+SjCftFNtAQ3WHt5xM1Z3KrSbi2FhBtWPE/cRa4inzjX/JfcJSRfXTUrXYkGPNj5I/m1VbWOFdRvkCB5nayGgPBImVGh4DsM9+wWYUqyHuW3UgGrUAs6IoOxempIJQ85iYlG63wS8qmdk3vnIYh4WSmLEsGovlbuyinc4WQeBFwj5+rcRCCaxi7wDQ6xbeDEstS8Km54VDi2UqhtUsk7iBil3dScYuADmD+2rhTPuGrKs1l1g+zpbaDMRd1l6v2LwKOCYwq5DU+GuH0bIftvCXhWCLXdlupcgRPj+Ikltz0AU6AjnGzdvjCCaIz//evGhFGXkOgWEblpXOu6w838ON8uNM+F4dglDb2Lk9CB2VC1mWv2F35M+bCpgzHQvc1NPVgwx2+iwE4FspkBvjVVth+vmfPzQWpUPH/JARZY1WhhmiAaVab0cnQzWpd/zmSaubbNeDcSYrRjDGIjUCxXK3l3byGpjc7FOD4BoP83wushSrCdoWh5ER6AgwA/4/4Ucva0myFD5Zd6ZlhvMG7HB2RMiguDSI2qKjhlS0gxz5+1Cg1wZZvQTUfNBXsr8SoJnlmW2JboPlKzv89Xi+NCOwp2c34gQSpk49KIwSCA2r4Q7YQxHSCs4bdwqoZcwFC6u0q43o08DGY+3lFV6M95isjN6vyRgIy2UbIbiuP+rWELR+cpt44Usdi/KXSiBg1TOok
 DapoxkqX
 Utowqb4SJNuG7GJ/O2JPClOMUR1SQZU9bKOMZhQBJ2QKDkrgLTIN431N+4QR+vb3BtXdrD2IfZgKBlG+HRpjcBe19t0ecsB9N92WoQltQqYiUgq+ylNUKaMZ0f6NaOXga+R8XPq62ik+px8PmymqULV0B18WUeKTn5vcv/m9n4xpo7jqaV98xKPNkuwdfEfZJTfxyjbcAaV/sRTt4weIxcI/KKFTKcl85gb15rk6Y3QvIfsCwXv6Qad6u7fa4YjB7upJgRlszuVfyDCJiiQlPiKSAORLr6zmHUTnS6cbb7LDMqgjZq98IKJj/vwQHJSL9GR5qmMIYre8h54mrGwgnzq7ZDF0ikW5YV680bzCfgfZL2+orCaHWh1zs63/xb4MYtGJdJYiloqw10LvxLHGaGXIZeyFq+ONPY1ff8xVX4CGXE8SOdTqGGCz3hKoqV1FBqVSuYyArpkvnmYce+ccIv+9fVYubS1cTQmsRAgQhj9OUu6bBfHfQrx5MVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 03:46:50PM +0200, Jann Horn wrote:
> On Tue, Aug 25, 2026 at 3:13 PM Christian Brauner <brauner@kernel.org> wrote:
> > On Tue, Aug 18, 2026 at 09:51:06PM +0200, Jann Horn wrote:
> > > If the system is running with PROC_MEM_FORCE_ALWAYS, LSMs currently have no
> > > good opportunity to block a process from overwriting read-only code in its
> > > own address space through FOLL_FORCE writes via /proc/self/mem.
> > > The security_ptrace_access_check() LSM hook is bypassed when a process
> > > opens /proc/self/mem because this is considered "introspection".
> >
> > Useful. I ran into this issue just yesterday in:
> >
> > https://github.com/systemd/systemd/pull/43511
> >
> > Btw, it's kinda annoying that PTRACE_POKE{TEXT,DATA} still allows foll
> > force writes even if PROC_MEM_FORCE_NEVER is enabled. So ideally there'd
> > also be a hook for that option.
> 
> You need either /proc/$pid/mem or PTRACE_POKETEXT for installing
> software breakpoints. I think if you want to completely block

This won't be enabled for general-purpose systems. But for a lot of
other systems with a lot stricter requirements this is very useful. And
you can always allow a mode where you intentionally degrade to an
audited "debug" mode where you can turn of the restrictions. Which btw,
isn't possible with seccomp.

> FOLL_FORCE through ptrace, you're probably in a scenario where ptrace
> should either be blocked completely, or at least restricted to
> mostly-read-only operations?

Yes but the list of ptrace() options is prctl()-like. They even have
interactions. Also seccomp isn't necessarily the right tool for this
because it doesn't allow dynamic policies. That would be lsm territory.

> 
> > The other thing - though not directly FOLL_FORCE related - is that
> > process_vm_writev() isn't subject to any security restrictions other
> > than seccomp filtering either.
> 
> It does go through mm_access() and ptrace_may_access() unless the
> access is same-MM, so it can be blocked by LSMs like Yama.

I think ptrace_may_access() is way to coarse to be really useful. It's a
very frustrating tool. It's easy to use because everyone knows "you need
to access properties of another task, ptrace_may_access() is your guy".
But it prevents better policies. TL;DR you never know _why_ you were
called specifically.

