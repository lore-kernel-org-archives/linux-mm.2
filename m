Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78B36606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 06:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ldk6v/fq
Received: by kanga.kvack.org (Postfix)
	id 6CA026B05F9; Tue, 24 Nov 2026 01:11:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2876B05FB; Tue, 24 Nov 2026 01:11:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DE566B05FC; Tue, 24 Nov 2026 01:11:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33AD96B05F9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:11:26 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A2221C44A2
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:11:25 +0000 (UTC)
X-FDA: 85468990530.15.C6B9CD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9A6E740002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:11:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ldk6v/fq";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795500683;
	b=kt+4vcCorJaoepvkJSShbf371sSWQHa1B32ijKPX73Aw1BDdyn3yj83daK2vyuDCUtpTbx
	kE/TJX0XFe7czAH+41npVNrC2vNx8sZ8qLA/D6x7piUcG9kscXgrf9bbC9mCIHIYAIRKAX
	K4Jw91dZoClILQOysP2ThxSNbk+Zff4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795500683;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVWYT+ReEjp92DC/COPfTT4+iY+7/LKwunieQrCYZRs=;
	b=32bomKpDehuB3OGiGX0Yk/99iCv7yYXw8pqE/qZYIeQxW8VgBhgyannUsbybBxE7KaBVgQ
	j+UcZ4qg8keqogfTnYYhj44azpJoiwLCn2717LeghIRD0eAF+fqFAhbRp41s9zKM7/2wrW
	7594GCmoywcOX1iP/eeXog2iuNnNFPk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ldk6v/fq";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CCD9443A3;
	Tue, 24 Nov 2026 06:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B185E1F000C0;
	Tue, 24 Nov 2026 06:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795500682;
	bh=iVWYT+ReEjp92DC/COPfTT4+iY+7/LKwunieQrCYZRs=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Ldk6v/fqGLh4UU8tyr0PpPqolMjgBCj1T7glBs4eAhEz/xhfnabHBUoRM+Xxx0H6O
	 4oEqnAilstUOj6rCrwYUKygfuPefnAW/XBSrh7AaGArHULVLbo/+N+r1hGzMOFqfvg
	 nC9l5eUyNRZJmlkLOmA8aGTfVOZTkO0uUMPdKugb8XCblH79BPQkvxtDSry5P3nFKN
	 mAfFxbHWRjA/kAPD1wLnHCO0WJXPKfG9gl2CtHAU2TX+fbT0Z0kyW6oyU8M9qEgQCl
	 Tv2SWu36VsR8tP2AlgQ4ZwnU7nAQ+x20Eo7p9I13nlZNwJYEgC8rYaZpCJx0e4vwaw
	 5Di63bjNpeCNA==
Message-ID: <sashiko-outbox-230577@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: net: act_gate bug. was: [syzbot] [tomoyo?] [mm?] INFO: rcu
 detected stall in security_file_ioctl (9)
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>, syzbot <syzbot+b6f8640465bdf47ca708@syzkaller.appspotmail.com>, akpm@linux-foundation.org, andrii@kernel.org, bpf@vger.kernel.org, brauner@kernel.org, daniel@iogearbox.net, jack@suse.cz, jmorris@namei.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, paul@paul-moore.com, penguin-kernel@I-love.SAKURA.ne.jp, serge@hallyn.com, syzkaller-bugs@googlegroups.com, takedakn@nttdata.co.jp, jhs@mojatatu.com, viro@zeniv.linux.org.uk
In-Reply-To: <DN37NBGPJJG9.2DSVDCKS3UYTV@gmail.com>
References: <6b051681.58b41460.7037.0590.GAE@google.com>
 <DN37NBGPJJG9.2DSVDCKS3UYTV@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 06:11:20 +0000
X-Stat-Signature: hipo5gpbbj6cqi9udshfyxg413m8rcm8
X-Rspamd-Queue-Id: 9A6E740002
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795500683-790007
X-HE-Meta: U2FsdGVkX19m8Hq7l98wBI5rXbW/psLdttg24HIh0xiauMh+7sdqODo9oNULyFNrKaWlVxTPlt1T0W9QxBbFL0pfPAAo69wa8X/JgDnN+pN6B6zWyKCd3q9BoBu3pNC790GCcjjzCY9XpJPu0CgBH45NWY2IHPFmXBF4NAuuKiVHsdkdyNyVGW82fnTXy32bVd7erIjszJvpS20trg5zypzp/qmqEI2lOcrmT5RX2HH/Ncp6I8f3f8uQAwuNlp3vwJLF3iK6W6RO2q7xsAaAZ6CU+RZ/2i65b7IE5F5UghTeXSKU1P9AY9/cYL9viuagem00RklBZJJQfFulBmXPWFhyBPEV/76TMNulwgz+GE4CrOUhPwNeJEnFXCnC6ICMzWGbHVZqD7BLv8bFxHCX8WgyJbPhbd04l/rJP+qrt1KWp1LflvFnAXxvNwTgGxueUz7Z4L+HPbp6WSzrAMDa/z1TzgJHPHxYiS2u9AAV7dDssdky8VjuyfAZjBezaZ0+Ngd80LGX+QqPEtqZPraS+Vi/0zAKABqAV6ZWSzX1mdQxbSG0VGD6ENbnu6ZdEKekvSg327wBpjwXsCzlwjLl9JNGaVNXWMjgn76n1lu3WWacI4egYMNm8l+8hyyVBiUh6qlY9GyLAoZGxfQt9wcLdh6U9Ocdp6VFRvLzgJh8W+JxFRkuqEhhILoFEZs9hOvJlelyhvXT1Bd/vX+VJeDBwnUndBY90jZXSWliDg0MYjhy+1WKxe7DIV89FbE3bB9nNPoZuhEaLuX/zL7VN+4tQDn9HghbejaQsaDTygGk4birk8laiP+zDSETD8YKqexeYxzVPWJiYghysWM/VWLsNvj2zaJkP6MKtjBWX9meCb6ul8gczVEVRlVh/DUGPEwX92bobXFmH7PwcGxgiYPYyUsyQzohXjyDIFjn6h4SlCmFmhZmFz6J127rx9xjK1HuRgaYWHIS/RhPcq/izwo
 RmOVvXt1
 fuNw+uusqXEXGiV8qXsi8/s4UZquPk9bcWZe7m8NGRcgSL0wHj1cmZjYi4WpVV8J5y+oXKHem+2ZR8srJu97mG1dDMS/DWM3+TNBLjk8yUGgdgGHUFPpfyPmmvTC7NizRebcG0AQ08SNp16+yWKyijlCfwiS8qjhtA7w1sn5jy62MMBE+DONbObw0+4c+BihFNQ5tsQ7RD6lqzezuphGyHdTSDtb6upONiRFgooZkJNKnYDlxYy+PTFrYvMZf2+2pRbg4ModNl8iEFdV6F2QkW31o0mmpwvoEUBjF1qJQlbjkW5XOsUeA/AS9mTy92cFm/7i9btNn/36/dvYi+HSN3JXP8Tig4zM4U6oQwOIlgOA5tUDQ/aKyc2VKFSUSfI97Vz8ewshxLtfqvYtRBouINPEvR4o52kt8v/aN9vGR/Tpe5pZOq+qdBBcrhVmhRzeB0F+KDzlv3uWOJA8X0Rs/SZ0rDwiwV3aG6v/9IzfVmHOtmfi6CjANO2+Ghx+XpWzq7XOOhgXWQYCbHbAfikHJeDtOuPL/fTl2+kwEQ4jNJItuXMdbNUaVV1IckbazGjOEmzvnpvwhS9QIk0hY9UYToY9XRC2/VJaBVfuLShxA8rPOSo2+J6ZfGIYiMbPGG2dD9yS4YHLRP6c1ktEsfIzFpB32MfUYfSj21fRapYCC95r61htzO0UPTWZdEVmuNWIoDqFYOKwI/UqJPXyEiG/Pr9MtP84jEYkojv0fxgY21lsWDAPb9fdFpP2ho4Gkh3MjLuf/lL+6yaE7njXqQZakZ64l3lgi43jLp6Zt1qlEV4r7CKdaEE7CroIADne1Yp914ASgm0T2Kjcn+98r5rLQZsCF4jn3oi5cNn5YhbdC7gTiLpv3t/GfOA0rNAPILdN5AEEngkkwra2Lv6YZ4xe1PObBfJyLd9FthfDuX2yK3mTIGQOq78/R6sYfw/CBzV65jPYUj7tpWF+ZaJuii4+2EzVxKz2m
 +UO9qTQv
 Oq9SVP1J+5DXyvrzONbM5scNS2/lH/08YMnVdNtJL8IShONU2fIlUhq37gKYnHVbmfCVhkVnECEq9IWOgRHZbF9QCG6sroCAWN7aSAr/2928PX6AzAAXkn9WMOlo9jNg8lfqe5+WJ1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] net/sched: act_gate: missing Signed-off-by trailer in commit
  message
- [Low] net/sched: act_gate: missing Fixes trailer in commit message
--

commit 1dfca74c316eb54b3672929b3411874232eb4ee7
Author: Alexei Starovoitov <ast@kernel.org>

> net: act_gate bug. was: [syzbot] [tomoyo?] [mm?] INFO: rcu detected stall=
 in security_file_ioctl (9)
>
> On Mon, Nov 23, 2026 at 08:45 PM syzbot <syzbot+b6f8640465bdf47ca708@syzk=
aller.appspotmail.com> wrote:
> > rcu:           hardirqs   softirqs   csw/system
> > rcu:   number:     5264          0            0
> > rcu:  cputime:      138      52351           25   =3D=3D> 52490(ms)
>
> It's not tomoyo, mm or bpf. Looks like act_gate.
> Zero new softirqs in 52 sec, so one hrtimer_run_softirq() doesn't return.
>
> > RBP: ffff88807ed35538 R08: ffffffff91be1bbf R09: 1ffffffff237c377
> > R10: dffffc0000000000 R11: fffffbfff237c378 R12: ffff8880b8228600
> > R13: ffffffff89fd0480 R14: ffff8880b8228600 R15: 1ffff1101704514a
>
> The registers with lockdep struct sizes:
>
>   reg       value             points to
>   --------  ----------------  --------------------------------------
>   R14       ffff8880b8228600  cpu_base
>   R15 << 3  ffff8880b8228a50  clock_base[HRTIMER_BASE_TAI_SOFT].seq
>   RBP       ffff88807ed35538  kmalloc-512 + 0x138, tcf_gate->hitimer
>
> act_gate has the only soft hrtimer that can be on CLOCK_TAI.
> bpf_timer_init() rejects that clock.
>
> TCA_GATE_CYCLE_TIME is an unchecked u64. In gate_timer_func():
>
>   n =3D div64_u64(ktime_sub_ns(now, base), cycle);
>   close_time =3D ktime_add_ns(base, (n + 1) * cycle);
>
> With base =3D 0 and cycle =3D U64_MAX, n is 0 and close_time is -1.
> The timer restarts in the past and __hrtimer_run_queues() runs it again.
> It's there since
> commit a51c328df310 ("net: qos: introduce a gate control flow action").
>
> Jamal,
> taprio's INT_MAX limit doesn't fit. tdc uses cycle-time of 600 sec.
> The diff saturates the sum instead.
> Here is a potential fix:

[Severity: High]
The commit message is missing a Signed-off-by: trailer.

[Severity: Low]
Since this fixes an infinite softirq loop when TCA_GATE_CYCLE_TIME overflows
the timer expiration timestamp, should this include a Fixes: trailer?

  Fixes: a51c328df310 ("net: qos: introduce a gate control flow action")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/DN37NBGPJJG9.2DSVDC=
KS3UYTV@gmail.com?part=3D1

