Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A81EEC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B51856B0088; Fri, 10 Jul 2026 09:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB36F6B008A; Fri, 10 Jul 2026 09:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97D626B008C; Fri, 10 Jul 2026 09:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71E106B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:40:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 051988E705
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:40:30 +0000 (UTC)
X-FDA: 84972976662.24.54E72A8
Received: from mail-10696.protonmail.ch (mail-10696.protonmail.ch [79.135.106.96])
	by imf06.hostedemail.com (Postfix) with ESMTP id 359C418000E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:40:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=proton.me header.s=protonmail header.b=hMk7Alrl;
	spf=pass (imf06.hostedemail.com: domain of BoxStrikesTeam@proton.me designates 79.135.106.96 as permitted sender) smtp.mailfrom=BoxStrikesTeam@proton.me;
	dmarc=pass (policy=quarantine) header.from=proton.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783690829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vIiiJ+cCf8lqAIOs514qP+AoBMOvT7LpG/tOo8gCmII=;
	b=8Es5osqccuKJqSdpBOFTT40Bp1OQFkND2jkWDPghCuu5zIJpVpBnoK02rFy/PiH3v4y+6s
	ADoYg+tjcT+NAncArpVEdqtb5NigFQYdGHVo6eeKPwa1olU0E9AX/Ojnwi0yX24vLJbjYk
	ea4pGciMirUFUZ5ezmAQMZFVtP1Mfe0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783690829;
	b=VITVzBfmMc0r2lGeUFRVtXaU0at0u5j3mMOVhiGAgMax8Bc7KGM5QfdXsd9uEVt/lx5TIL
	W7y+mKdk00Awx1ybAFSYWi5dj6e/OmxrD/1teXYg2xTS5nyLNR89wnS80EE9/t9wWRpiQ1
	qQdKi0OmyNQQUOvHNQ9wyDQa/l6bgmc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=proton.me header.s=protonmail header.b=hMk7Alrl;
	spf=pass (imf06.hostedemail.com: domain of BoxStrikesTeam@proton.me designates 79.135.106.96 as permitted sender) smtp.mailfrom=BoxStrikesTeam@proton.me;
	dmarc=pass (policy=quarantine) header.from=proton.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1783690824; x=1783950024;
	bh=vIiiJ+cCf8lqAIOs514qP+AoBMOvT7LpG/tOo8gCmII=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=hMk7Alrlqw7r1hFNUhRlV1qHOjskMYC3pW0uNzpxYGV8k1v3L73TCrSshT9w+bbhD
	 ThbiHw4Dw1y3uFJzlZyYvHiuLmsaSM4ZqL4stx7Sbdg/KxdOFbatEL531tuolLxpU/
	 fXpC7dgE263LggkjoXBG2dDecdbp/q0nbCkQlHekjD/QCkqlTowEjGbQBIvlFNK4Ze
	 gmYaXBVo6e2Ga7sOofmFH1W/3YVyOsr0u7Fs7hm30E1+aXCL5H4nEYfwQWdq2Tt9tH
	 KGpsZQz1VaNYl6mYdxlJ6D59Nt0pKR+/zVwRAV+lZ5klOw9jtU2lsbnj+De7GPBcH+
	 lp6vqOyucVd8g==
Date: Fri, 10 Jul 2026 13:40:17 +0000
To: "paul@paul-moore.com" <paul@paul-moore.com>
From: BoxStrikesTeam <BoxStrikesTeam@proton.me>
Cc: "rppt@kernel.org" <rppt@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "jmorris@namei.org" <jmorris@namei.org>, "serge@hallyn.com" <serge@hallyn.com>
Subject: =?utf-8?Q?=C4=B0lt:_Re:_[RFC/discuss]_memfd=5Fsecret():_opt-in_visibility_for_security_monitoring_(eBPF/audit)?=
Message-ID: <pciGBFzXU6ZhxcvS_9tWNr4oA-3uEmqoXh-B63mT0hsw3Deyl5pud2MXgRGQ6lHx59gqVkFekZjMMI3dhlkJemkaY63utKQplAIw1Tj-jS0=@proton.me>
In-Reply-To: <CAHC9VhRCo1nc2qLfq=Fk9Q26vjSOUBgfM8wV6U4S+Hv1KM9LNQ@mail.gmail.com>
References: <umQp9Qs18vw53oZDFIgYE4MyUWNemeNL8-Vbs-BOYEvQByiyPSZ3RrEvOpmdWUZ1YtjEHpjlgZnMo5DkJuJziwrKWTYS_A0QF_B3ixToMBY=@proton.me> <CAHC9VhRCo1nc2qLfq=Fk9Q26vjSOUBgfM8wV6U4S+Hv1KM9LNQ@mail.gmail.com>
Feedback-ID: 205449183:user:proton
X-Pm-Message-ID: 249e68c2716dbae997f0bb878229f5895b302bd6
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 359C418000E
X-Stat-Signature: to8rx4zru3befezgeqqmgcjfyop33huy
X-HE-Tag: 1783690829-907915
X-HE-Meta: U2FsdGVkX1+KfFd36ErmLY9/viAc4oF1QNDokzj2EgU+vGjZXLHDPQ7WmzwBAiIXCeoq+GfR+lVDVOSE0rIT6CGQeZh4Zpn1gp1TrZEitGLrT9u99nx5IC7sL7/JJdyAI0Afaitk76d6aRIoqnce7gszfmS2NXtd8nvusghz5Lp7ReThcWQw8dQXPSyZYX3vzrV2NqdxzlsZ9tYL0nANJJsEKsJYMK1mCXJObXwOhZOTF9kg34ep5ts1SMqg2oYOayU3g0UCt3Dv6jRtGOZrizOomlKp/vyyj+a0qw83T8KG8SQ22C9A10YdXL4WTFGjsGyHQzsyp5yJRaZiNbvaWF1x4j+tVW4GqxaeGMnUfEHQTHN+Yjeog6IaRSDGT6mg7IcCq+5V8G7aCm9tQTaq1f3eDgukxzuBROeI8D0BV04dh+teQ39gQReSNhoWXOtv7hx5Nbyp8jHWt83JNgvi9wV1V/gEO//UdyWWftpBaS1KXZGZXuhQgaV0NQn20Pk6e+9TJyOYM/WLzI6jCmwhDrHm3HL6Ha5pwiFvfmcvapQoDYP0CvAuRKpPxT+XtkyREZUSPIsKUMmBm+o9vyMVUns3rOL6i4Ijk+KAxN8bNwXkdY4rIDCr35dtwsoaU4rOVMUCBZcwIo0eix4aoVNjj9lTwJRFLN1m+lrlBPvywVbbuoV/kVj4Xje3FA0uhqeOdmCuC62D5XIESDCn9BAZOKi2Xy1pA8X9UoSdNk2FDiGTUa0IO2S3/0s+dZWT4zGa9ynTVjXzfCMjdw5zKvExNBi8brhVb8dy2Nb/eZaQKM9Eb8o0KeqWWUWKViPuqMlqvbdJN8+cKPBPWFPTd3+Iz5wfp5XOc1rc0rW0y3tf68bWsFZd3GwdehqISpasz1GV3l9zkddDNtqjngmy0hpFhHc/jfNWZwxdlXaIotk2FqI3+bFpPgZMyB0TEk7jUMldFVNjHU2EHILHjjBQMlN
 mYK1UG46
 6GKH1cyk9E8WODF4pNnctmFXUyFAVVDFTgXAjrMc71kIc/6s0OCwhSuJTLxajeQazlXOEXftw8TDhmbQmIX0pDKiAiQ37FrbNtn47d1v2cfg/EN5kxQ1Hl1B4JnCIXH3/yZekZB+9wxeo9ishcZCL/GDcHZPC8REcSKgdAMJ8t+/gp82JDryKthLzf3x6ETom5pfcfRbqFbMyyM1xWkHYBNbRnElgb2RXZNnIixotLpV6ZcgkzTEniEgPUg9Za5bk822GtSBJb+5yfW3sMfdMg+PHjF2CXVoUKz7dLCjZCqqO229Or31eCHxAVBFkOjkQCS6yLb+6Ijl5PQowjwnMoxTYEV9nrl+4Z4Vrh326tUr7rndq8i3jwVGT5kJCKfnISdeR1gWYsBRYlWCeCI5rBSBSISlvVBPIB4nVe5BqfXNLDpnHrhc86Il4aq8c65056jmAu2T8Ep2ye5DHQkHWIFEsZAWedvkt4pHdgGMrd2wLXyw1SqNp9Wt486LEu7Hf5znc4/IDdhqP9ulYJV5DlMisaub8xEKxqcxqB+TahZTK2hP0qNvDzMi1RMMRw5Ovgx7BM6WUDto4Ou4gsIqF81cHySl+oi0HbNHlpziq2a0AaJNrcjPtYGlpaL+NWa0z2sB41zdHDZvbHKuJ8W56vkl0mfZCHAI7TEhVPCUyZJJwkWc1o05sWfKtb/c1ua2zx9Ym/Um/T767pAGuV26RT7TGJC2sVFY3Tz5yrqwKr8AcMoKAeEV6tWjZxrcDpHi7zNfMqdfG4+JZjzvHM6FZ3DYqhrOrb49lHhG/W/9tbJ9FZEJGjkBcEW7l9sW8uSAqt/VKrLZaBRgH5jA20P4iIQB7gq2CZTPQMoexdjAtGSCRmAxlhz4zI+bFux9HPCrmkwsNbZ3QcjydYrdr0sErNonSDKLGlJBK7umrun5kju6lVdsPWXBRSxV1ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Proton Mail g=C3=BCvenli e-posta ile g=C3=B6nderildi.


------- Forwarded Message -------
Kimden: Paul Moore paul@paul-moore.com

Tarih: 9 Temmuz 2026 Per=C5=9Fembe saat 05:21
Konu: Re: [RFC/discuss] memfd_secret(): opt-in visibility for security moni=
toring (eBPF/audit)
Kime: BoxStrikesTeam BoxStrikesTeam@proton.me

CC: rppt@kernel.org rppt@kernel.org, akpm@linux-foundation.org akpm@linux-f=
oundation.org, linux-mm@kvack.org linux-mm@kvack.org, linux-security-module=
@vger.kernel.org linux-security-module@vger.kernel.org, jmorris@namei.org j=
morris@namei.org, serge@hallyn.com serge@hallyn.com



> On Wed, Jul 8, 2026 at 8:09=E2=80=AFAM BoxStrikesTeam BoxStrikesTeam@prot=
on.me wrote:
>=20
> > Hi,
> >=20
> > While experimenting with mseal() and memfd_secret() together on a
> > recent kernel, I ran into what looks like a gap worth discussing:
> > content placed in memfd_secret()-backed memory is invisible not just
> > to other processes, but also to in-kernel tracing/observability
> > mechanisms such as eBPF's bpf_probe_read_user() (EFAULT, as expected,
> > since the region is removed from the direct map and kernel page
> > tables entirely).
> >=20
> > That's working as designed for the threat model memfd_secret targets
> > (protect secrets even from a compromised kernel / ROP-based
> > exfiltration). But it does mean a local, unprivileged process can
> > now allocate memory that:
> >=20
> > 1. Is invisible to kernel-side introspection (eBPF tracing,
> > /proc/<pid>/mem, ptrace-based tooling) once populated via
> > memfd_secret(), and
> > 2. Can additionally be sealed against mprotect()/munmap()/mremap()
> > via mseal() so its protection bits can't be relaxed either.
> >=20
> > Neither primitive alone is new or alarming - mseal() protects mapping
> > metadata, not confidentiality, and memfd_secret() is explicitly
> > opt-in and disabled by default. But combined, they let a process
> > carve out a region that a host-based EDR relying on eBPF
> > tracing/probe_read helpers cannot inspect, and cannot force back into
> > an inspectable state either. For userland security tooling that
> > assumes 'anything a tracing eBPF program can attach to, it can read',
> > this is a small blind spot.
> >=20
> > I want to be clear I'm not suggesting memfd_secret()'s core guarantee
> > should be weakened - the ability to keep data hidden from a
> > compromised kernel is the entire point, and forcibly exposing content
> > to tracing programs would undermine that model and create a new
> > attack surface via the eBPF verifier/helper path itself.
> >=20
> > What I'd like to raise for discussion instead is something closer to
> > what was already anticipated in the original series - Mike, your
> > commit message for memfd_secret() mentions: 'Once there will be a use
> > case that will require exposing secretmem to the kernel it will be an
> > opt-in request in the system call flags.' Two lighter-weight
> > directions that stay consistent with that opt-in philosophy:
> >=20
> > a) An LSM hook / audit event at memfd_secret() call time (this
> > echoes Christian Gottsche's 2022 RFC to label secretmem inodes
> > via inode_init_security_anon for SELinux). Even without content
> > visibility, logging 'process X created a N-byte kernel-invisible
> > mapping' gives EDR/audit systems a behavioral signal to alert on,
> > without touching the confidentiality guarantee at all.
> >=20
> > b) A distinct opt-in flag (as foreshadowed in the original commit)
> > that a process could set to allow a CAP_BPF/CAP_SYS_ADMIN-gated
> > tracing context to read the region for legitimate
> > monitoring/debugging - fully opt-in, off by default, and never
> > implicitly available to unprivileged tracers.
> >=20
> > Is (a) something that's been considered further since the 2022
> > secretmem-inode-labeling thread? And is there any existing tracking
> > issue for the kind of opt-in-visibility idea in (b), or was it
> > dropped as not worth the complexity?
>=20
> Modern kernels do allow LSM labeling of secretmem inodes, see
> secretmem_file_create().
>=20
> --
> paul-moore.com


Hello,

Option B caught my interest. Do you have any updates, disclosures, new idea=
s, or anything new to share?

By the way, I strengthened my finding with a proof of concept and have now =
disclosed it publicly.

Thank you.

https://github.com/BoxStrikesTeam/Counter-Attack-Injection-Method

https://boxstrikesteam.github.io/Bulgular/001/finding-001.html

