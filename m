Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DBDDC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 08:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4819F6B0005; Mon, 13 Jul 2026 04:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459896B0088; Mon, 13 Jul 2026 04:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36FBC6B008A; Mon, 13 Jul 2026 04:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 198726B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:20:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B285A1C43AB
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:20:39 +0000 (UTC)
X-FDA: 84983056998.15.1E4D322
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id E1C3918000D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:20:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H/i7JmHx";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783930838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AVaWRHxuOp1xucpt25y4qXpngLUErNt80kcT84Gj6Ec=;
	b=WTiZWEMhPy9lg0ZkQAqmIQl5hlj+X1bXQUzDT+D6QdjGjrHCHHgWTbnzdgo5m7mvop6sUw
	vDPGgiKNW3JJNdHPK6N30e0VlljWuHadZNFnFMILh/UR5h95jv/YusgTlIzmm4ln7eP/4d
	Uc5FF6sWji77COEjoWKBRS4i56QOjbw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H/i7JmHx";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783930838;
	b=6Qk3u0GfjVv+cldSZQV/oYVQkafpZYJTpuyRMUyRTejmTuEWT6gHR14s6ODa5OEql/Dsp6
	9XMLEHHV1E5Bl8uWIV51QVZTgPHnZJxAytY2AQ+MaH15rzf2Jw0y/jnetlzvIxbeAt2bEZ
	qfY6xa/N7eBJLjKyu1uWorB7Zx+0sN8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F6964151A;
	Mon, 13 Jul 2026 08:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F210D1F000E9;
	Mon, 13 Jul 2026 08:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783930837;
	bh=AVaWRHxuOp1xucpt25y4qXpngLUErNt80kcT84Gj6Ec=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=H/i7JmHx+nL/+drkYk9FHiWsCAuDyQ/lPRCv3RvInE9zuSQcynJrwktJsvbx35+ap
	 7xdiCe1oidtsult+mT39XvQW4KYxQ+8Osc4VpdrsvGZJmnuOCI8RonPzzOpzs1+z/r
	 9AWTVcc+C97niunSyfVT6zPHFenfQnBoI+oD1diAvgemGBA+RAofP5Dz19+v21kVuw
	 Wq1dv7fruhvIgzxVcUDpcsJVZHLgQg2AOghsPkd0UUKmMUQDoDAGqHOAMfKvt5keEF
	 ktEC+w2rFmZmbWPccRFgK+9fCpbErPEvtXykxrLMr22psUB7in+u2srp1/DxPqPgZv
	 UHbIVXfIH5NKg==
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
In-Reply-To: <DJX4IFO55D9S.3IV3K5XICJAEV@gmail.com>
References: <20260711-binfmt-misc-bpf-v2-v2-0-d6591ceaf207@gmail.com>
 <20260712-abluft-brutkasten-aufladen-c8063a4a1a0a@brauner>
 <DJX4IFO55D9S.3IV3K5XICJAEV@gmail.com>
Date: Mon, 13 Jul 2026 10:20:02 +0200
Message-Id: <20260713-unerlaubt-luftkammer-kosmetik-46532d395f9b@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=5642; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/i2syicifZJ3USjcLrnHL97T2+UWubEpCuWxspQutOo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSFzN968Y6VOqPC9JsP9qWHs0noxn0/3R4ZH2xSFH5/T
 +jLjDjmjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlEqjL805+XauBhdHPVDt1v
 W60mzUieca+zv+rN4bQrZutUPzxez8HI0O3Kn/RRkL+DZ7vs7TmH/lrt1betv7l9Ti6nlWDRspV
 /2AE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: E1C3918000D
X-Stat-Signature: knna1gybsh8euojbcecq8eq1rjnmckhy
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783930837-169082
X-HE-Meta: U2FsdGVkX1/4+YhTadp1TITAEYeRJQlD5lm8KaYUr+qlcpMvMKfGDtsPF3YeYbBUh35RT6VZL8YY1Z5GTgmOzEp9tIy2VFngLKi9R1HpY/LYGewklNuZGNQULwOaeWVICVFChk+qHYUDlxIBV7l4UhZidFoGOxuZLzfwKr9MLjoHrRz9A8t3NOukZaGNZ8XksT0gG+K2WFoACg/VlQqJMTnmm7lxBGXL3UhAIn6oxr9RuIbdWKlvBmWOYPDeOFtYEASlJ8v1icq3nm7oryw7mYnKsbIJbV+JvXKZEYWM6wMB/gtPrahHOzeSWVDTAgRpAi4IC0PfggxU2/CunuVIWD4il8Drh/ZC8pMMAdQ/zu+juGsL/O0waWLbuqzG3byewh8Gxi8XO9QUVoL3mEhwOVRxmV9LG2/scTbjsZdeDA2BYlSaZbVxY3NHanBEhTiFd1MQWk4Y2PxvCmxcCkoJrbsgCGw5b0tdqLDTBQQbQAKiSUpR21U2Qzzx5925roo4GPeABkBFDoef2/YploKU3Yzh7JoVo7m22Svj7czoeym6EnljUGy5Q+PuTyaDJxr1Ef9k99IdOkHra9IY6OQLMEJ/uD7eV8KXxoBuG0vNJ6QGQyDlYSgdTLl2pXEeg5aAa+T5ggZV4+ctlJNEkZCVpNl3vDDgsQ1ZT1YFRXyyYM2YmJaMKJL7+0F0jlw361TEjX4uVTMmMScW+NaRyuPUzLkWBS6mNJjv9d+MWkYeXhIBhYVahaYvLuA8HP8wVSLLmnmS6lpzsFbsQonyZgH+o5SxzgsOhCrIOUW42d9dmj8V9H60F0/zoTAIosHdVokJ32UrI/HhWEqUyYRm9sQKnh4+hxMLlw1D/FMYY0764IhCfcxCpUNo0HonnNhjaCONxGMWgnh5ykcteRcNdQW1NmgMs68xjNRIa3/CEQJlhUjcaSlRQE9riUJwinsxcOfTwY2LYPXG5+hCWxuo+fs
 YmYYNhXc
 sRKKY2w82ONRIYtYi4KDueL6xKBMRKq7a5A49BhtYHvI46naKC4/UQdGWQsPSKXzGO18U3yYAVOeLV5gX82HaFx7Qmcluk4o5H2x1CwJ8LLMcSTN69iJb3KcKpYVvF54ZpN+jOaxF44pp22tn1DAXL6uw43D5uW5RHKVxaBusyVXNwETYm96APbL771LzI/BtoLkDXugOgZwhkoTUHuuLWXo10Nj0deta0nV4imQOldk0vb9WhaeoXXfbObIlJWy6mgt95aJr4eFKDP5rRqPRzSTuly5Bmc+2mYSCFv23itv6QYozenFwaYcsCi5fyvwGg6FWXE7bBXtqWsSKNZ2B62xqvd7MwY5xSYwWp96ckx/u7jN9NKGmG67eoVNUAE0XeUPQ1cwnhUnxxgI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > - The single sleepable load op is split into two ops:
> >
> >       struct binfmt_misc_ops {
> >       	bool (*match)(struct linux_binprm *bprm);
> >       	int (*load)(struct linux_binprm *bprm);
> >       	char name[BINFMT_MISC_OPS_NAME_MAX];
> >       };
> >
> >   The non-sleepable match program runs from the RCU entry lookup
> >   walk itself, exactly like magic and extension matching: same
> >   registration order, same first-match-wins semantics, and it can
> >   only rely on the prefetched bprm->buf. It must be free of side
> >   effects since the walk may be restarted.
> >
> 
> Is relying on brpm->buf enough?
> Right now that's only 256 bytes I think, which is not enough to read
> segments we might care about. That worked fine when it was just a magic
> number but the idea with the eBPF program is to make decisions based on
> more data.
> 
> In the selftest I provided, the `PT_INTERP` segment is already at file
> offset 0x318 (792). I was imaginging NixOS having to support
> `PT_INTERP_NIX` in order for the produced binaries to be backwards
> compatible with older kernels.
> 
> The other idea would be to make the `match()` broad and select
> everything but then nearly all ELF64 binaries would match and then pay
> the price to `load()` and ultimately `-ENOEXEC`. Seems like it would
> make multiple BPF binfmt programs less useful.

Ok, so your idea is to have multiple bpf programs that look for
different interpreters. Yeah, then you have to be able to sleep because
you need to be able to fault. It makes the code uglier but I can see how
that's useful. I'll see how nice I can make that.

> >   The sleepable load program runs once the walk has committed to the
> >   entry and does the file reading and the interpreter selection. Both
> >   ops are mandatory, the struct_ops plumbing enforces the sleepability
> >   of each, and since bpf_binprm_set_interp() is KF_SLEEPABLE a match
> >   program cannot select an interpreter by construction.
> >
> > - A match is a commitment. A failing load program fails the exec instead
> >   of falling through to later entries. -ENOEXEC keeps its usual meaning
> >   and hands the binary to the remaining binary formats, for a handler
> >   that discovers it cannot serve the binary after all.
> >
> >   This kills the part of v1 I disliked the most: the skip cursor and the
> >   leave-and-rescan loop in load_misc_binary() are gone. The walk is
> >   never left and re-entered, and 'B' entries need no special semantics
> >   against concurrent (un)registration anymore.
> >
> >   Your v2 changelog note about keeping the bpf retry loop in the
> >   __free() style is moot as a consequence. The loop no longer exists.
> >
> > - The load return convention flipped: 0 now means success after the
> >   program called bpf_binprm_set_interp(). Returning 0 without having
> >   selected an interpreter or returning a positive value is treated as
> >   -ENOEXEC, other negative errnos fail the exec.
> >
> >   So the "return bpf_binprm_set_interp(...) ?: 1" idiom from the v1-era
> >   programs becomes plain "return bpf_binprm_set_interp(...)".
> >
> > - The handler name moved from the offset field to the interpreter field
> >   that field consistently names whoever supplies the interpreter, a path
> >   for static entries, a handler for 'B' entries. Offset, magic, and mask
> >   must be empty:
> >
> > 	echo ':nix-origin:B::::nix_origin:' > register
> >
> > - 'C' is allowed now, v1 rejected it. It behaves exactly as for a static
> >    entry. The setuid transition stays gated by vfsuid_has_mapping() in
> >    the caller's user namespace. Which makes 'B' handlers usable for a
> >    per-binary loader over setuid binaries. 'F' stays rejected as there
> >    is no fixed interpreter to pre-open (I have other ideas how we'll do
> >    something like it later.).
> >
> > Nothing changed in the exec patch, the fs kfuncs patch, the kfunc
> > itself, or the registry/namespacing model.
> >
> > I can send v3 in a bit if that's ok.
> 
> I don't mind at all you sending v3 and in fact I've been enjoying your
> involvement. I didn't know what to expect when I offered this idea up to
> the community. 
> 
> I'm happy to keep co-developing this with you within a design you feel
> acceptable with. Please let me know how I can remain engaged and
> helpful.
> 
> One last thing I was thinking about is that we will also need to support
> $ORIGIN in the shebang path, however I just tested it and this current broad
> BPF solution can largely handle it [1], with a small wrinkle.
> 
>   $ printf '#!$ORIGIN/interp\n' > /opt/app/greet
>   $ cp ./interp /opt/app/interp     # any interpreter/loader
>   $ chmod +x /opt/app/greet /opt/app/interp
> 
>   # stock kernel: binfmt_script opens the literal "$ORIGIN/interp"
>   $ /opt/app/greet
>   bash: /opt/app/greet: $ORIGIN/interp: bad interpreter: No such file or directory
> 
>   # with the handler registered, $ORIGIN resolves to the script's dir
>   $ bpftool struct_ops register shebang_origin.bpf.o /sys/fs/bpf
>   $ echo ':shebang-origin:B:shebang_origin::::' > /proc/sys/fs/binfmt_misc/register
>   $ /opt/app/greet
>   <runs /opt/app/interp, the loader found next to the script>
> 
> The wrinkle is that it can't express today is the single optional argument.
> (i.e. `#!interp arg" -> argv[1]=arg`). We might ned a way to express
> that in the load.

Ah, fun. binfmt_misc wasn't able to express this at all. It's good to
close that gap. This can just be done by adding
bpf_binprm_set_interp_arg().


