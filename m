Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C3D9C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 12:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5346B0092; Wed,  8 Jul 2026 08:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D666A6B0095; Wed,  8 Jul 2026 08:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7C8C6B0099; Wed,  8 Jul 2026 08:10:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B4906B0092
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:10:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E2461C3CDB
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:10:00 +0000 (UTC)
X-FDA: 84965490960.13.71F6B79
Received: from mail-24425.protonmail.ch (mail-24425.protonmail.ch [109.224.244.25])
	by imf11.hostedemail.com (Postfix) with ESMTP id 86C3640005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:09:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=proton.me header.s=protonmail header.b=YD9yfCLz;
	spf=pass (imf11.hostedemail.com: domain of BoxStrikesTeam@proton.me designates 109.224.244.25 as permitted sender) smtp.mailfrom=BoxStrikesTeam@proton.me;
	dmarc=pass (policy=quarantine) header.from=proton.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783512598;
	b=3uEsErFfQdQUzbmTYgpMklGE2/l7P5NSLU3jQ0cr7KacCRKbhhK0wzzbIBISbcDGA+WUfh
	G+l09yIxI7rGfkzQklbP30f/wv8p4SjVm/kb9Ai7xts3+zLJ9OCZcnHFWAVmj0UI/miV+E
	hHGUSdemeoFUbTZVFXv1AhAPUTcXl3w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=proton.me header.s=protonmail header.b=YD9yfCLz;
	spf=pass (imf11.hostedemail.com: domain of BoxStrikesTeam@proton.me designates 109.224.244.25 as permitted sender) smtp.mailfrom=BoxStrikesTeam@proton.me;
	dmarc=pass (policy=quarantine) header.from=proton.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783512598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=q7pq4RkyXliE5Piwh20/AqpvrmpVs1qnGP8atekwzHY=;
	b=4/7q39lkGAhHn0zca8PclEMDb7UqRD0Atyo9SHyrOT30kQ+t9AZwf+wYLfUyosVrO9HfSw
	X/96bs7OYcdAl3bAk1sSo8QXqvUKmJu44HaWTtQp9dNxCEnMl1cbRBTtkkLyBjFpeXbdS5
	wYlOG0X4DYXVxOsBJ2/hI5s1Cm0flQs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1783512596; x=1783771796;
	bh=q7pq4RkyXliE5Piwh20/AqpvrmpVs1qnGP8atekwzHY=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=YD9yfCLzoIFry2/9wAWOPUe1DhmxUilPdLJvtKYgtJat9bErrH05KsicV7g6g0hiC
	 PvHUO4gUm5h+UaLkJ1NxZFlJj9fFdKyecBOP4lU3pTFvDT/n7Ei0U4f7YRCJUun8aQ
	 Z3PTwM6UlcNq+0W2VMUyxf4v9aiuooBRq6ehhGZW4MrXZ5/rLNQhgd7AqD82wUZtzw
	 5AQ4D8J5xyS3QioetrO6DO+tWlgQUxjJKqsOaeQX7MEWOa2ErqCmwBDzghopSY5YWe
	 i3gZ2qVHVrOzs71UD19MHs1vh3+QPJa+PqDgx6FVAXWMFgadMFYlca48qK/jToZrXw
	 PKzXX6xIVJVlA==
Date: Wed, 08 Jul 2026 12:09:51 +0000
To: "rppt@kernel.org" <rppt@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
From: BoxStrikesTeam <BoxStrikesTeam@proton.me>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "paul@paul-moore.com" <paul@paul-moore.com>, "jmorris@namei.org" <jmorris@namei.org>, "serge@hallyn.com" <serge@hallyn.com>
Subject: [RFC/discuss] memfd_secret(): opt-in visibility for security monitoring (eBPF/audit)
Message-ID: <umQp9Qs18vw53oZDFIgYE4MyUWNemeNL8-Vbs-BOYEvQByiyPSZ3RrEvOpmdWUZ1YtjEHpjlgZnMo5DkJuJziwrKWTYS_A0QF_B3ixToMBY=@proton.me>
Feedback-ID: 205449183:user:proton
X-Pm-Message-ID: 117239aa9462dde2ee42b831599a3a00f881cf9c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 86C3640005
X-Stat-Signature: i37p7mpc5rx9swc8kdxgt53fgb7ziu3y
X-HE-Tag: 1783512598-777945
X-HE-Meta: U2FsdGVkX1+vk46ycic6BHERQs1yNdfWNHlk42hbKykvvNMgbAhrmdNUbaxZ6MhqB8rqFjsE5puYUDZaE2vNC/kkHuIvUKvcS8Sw6e/M8lZg5Xubth9kGpNPUk8z8QZHElcGOijUHUwRXhJ98mO3ZgL5P/rRzXLDJf0KxYlHGsYNbLIztI4119cYtgfKaAPOKDv0+EjDEIZAmjUok/HULg+myzOf8kKcocb5vg4KODc3ScTTI+A8qOaQB4y1oXOijyCtru6RKirrq0qqxPT1RFugUi537iff/+9PErbOxQTJ7WFmXIIFxxQO/UkifNwiL+2mz5pEYI8TWiJCNYv97C5/zNM6LvWb+E1GGvcthnyMivsEswS4rBIM5Kdq7DzlIvIOLcN38CyBlhVkPJ2QNN3V+2xCSxszPH3yfn9s/bdBIz6nDf8mqEghNfHPDOJANxMLM8aL910hs7bOM+7bDncJP4N2igacomtVzN0mi54Yk8Fvt6cCHusoLbwyW323OdFmhfMKj5rxw9fP/JTMYIbfxO5PYwCRXJ2yPUc5Z8Ki/ZimsuQQl0vuM3SCUddZbTg6bIrOM3cusKSUZBTbw1C0pBVACJWaG34vVd6a53cc75Lb1Z78Vuzs8FLg/CXcX9s/lBw51mF7EURfXaEivacAR0/HXoa51tALYQRW4LQoPkzhRC1DpjiNFCj7gWtxqCN6/Ie8syE7mQBRmeaMe5egLBM3Zh+MbzlnZVa4l/EceN9T+qTrLpr2upB9mgNkaOzEP4R+KlyUEWvVPCoilb+/9AZ1PIxfCnu0pp/fUa20pykKjcEUa1jiwtNaahCIYhkzBBU4nhDs8tgIIfj0+Lp3LlQaFW7xg1RkTuCXwnpvwmx+FqDpwXDgTwSioGW61aS+LWZKPU9Vs6+6qsldCdikWuHs5yzDboXciCa6mvCeqaUwBlAXeWotoniPFRp5tMwO3gfBM82tiU/JYsS
 hdqSFhnw
 bs6B7xKQZGR0CnrFRDWkmjr8WS5lrMZULpuotkj9WGdbxVcVQB02tnzScWIQJXe+t+ZRYhNELEvYieBb7N3rZQwbsBVcXdMLX+S/vtvyohqvmw8ip9WCK4bYdsJmUlopg5ih1BCERAFp0xidWuzi/Q8UC3f0kR+RjdsP72paRVZV8Pv03vHRXaZv7iU0kFdfJ9Tt6itBnzM5LwKoLg/9f4TZoOnKeKu5mjrdg0Cfj+NR0pg4+uBi4loYBt/ZzUDjNMHcfVjJTPDp0dH5Ui8wcvseMz4VUQIG0iEjJNhWh21AQoxD/jXnmfGSt6uyn9kstbAbHDRd+0uK0SU6c+aKlBRoWTmYHfe5oc5AIN+8vSkEvXpOrwszi5sexrM89pBnjNIBAYz2xoe5vT5DaHcoSE3OuLzPeHlJZaJxGsZipPSMp+vlZ7qQ63gYMu52ab1nqR5Km
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hi,

While experimenting with mseal() and memfd_secret() together on a
recent kernel, I ran into what looks like a gap worth discussing:
content placed in memfd_secret()-backed memory is invisible not just
to other processes, but also to in-kernel tracing/observability
mechanisms such as eBPF's bpf_probe_read_user() (EFAULT, as expected,
since the region is removed from the direct map and kernel page
tables entirely).

That's working as designed for the threat model memfd_secret targets
(protect secrets even from a compromised kernel / ROP-based
exfiltration). But it does mean a local, unprivileged process can
now allocate memory that:

=C2=A01. Is invisible to kernel-side introspection (eBPF tracing,
=C2=A0/proc/<pid>/mem, ptrace-based tooling) once populated via
=C2=A0memfd_secret(), and
=C2=A02. Can additionally be sealed against mprotect()/munmap()/mremap()
=C2=A0via mseal() so its protection bits can't be relaxed either.

Neither primitive alone is new or alarming - mseal() protects mapping
metadata, not confidentiality, and memfd_secret() is explicitly
opt-in and disabled by default. But combined, they let a process
carve out a region that a host-based EDR relying on eBPF
tracing/probe_read helpers cannot inspect, and cannot force back into
an inspectable state either. For userland security tooling that
assumes 'anything a tracing eBPF program can attach to, it can read',
this is a small blind spot.

I want to be clear I'm not suggesting memfd_secret()'s core guarantee
should be weakened - the ability to keep data hidden from a
compromised kernel is the entire point, and forcibly exposing content
to tracing programs would undermine that model and create a new
attack surface via the eBPF verifier/helper path itself.

What I'd like to raise for discussion instead is something closer to
what was already anticipated in the original series - Mike, your
commit message for memfd_secret() mentions: 'Once there will be a use
case that will require exposing secretmem to the kernel it will be an
opt-in request in the system call flags.' Two lighter-weight
directions that stay consistent with that opt-in philosophy:

=C2=A0a) An LSM hook / audit event at memfd_secret() call time (this
=C2=A0echoes Christian Gottsche's 2022 RFC to label secretmem inodes
=C2=A0via inode_init_security_anon for SELinux). Even without content
=C2=A0visibility, logging 'process X created a N-byte kernel-invisible
=C2=A0mapping' gives EDR/audit systems a behavioral signal to alert on,
=C2=A0without touching the confidentiality guarantee at all.

=C2=A0b) A distinct opt-in flag (as foreshadowed in the original commit)
=C2=A0that a process could set to allow a CAP_BPF/CAP_SYS_ADMIN-gated
=C2=A0tracing context to read the region for legitimate
=C2=A0monitoring/debugging - fully opt-in, off by default, and never
=C2=A0implicitly available to unprivileged tracers.

Is (a) something that's been considered further since the 2022
secretmem-inode-labeling thread? And is there any existing tracking
issue for the kind of opt-in-visibility idea in (b), or was it
dropped as not worth the complexity?

Happy to help test/write a small selftest if there's interest in
pursuing either direction.

Thanks,
BoxStrike Team.
Researcher:Eneshan Erdo=C4=9Fan Karaca, Other ananymous


Researcher emails:cyberblackk@proton.me

