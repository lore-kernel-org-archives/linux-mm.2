Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55EBFC44501
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 12:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120D06B0005; Sun, 12 Jul 2026 08:32:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1A56B0088; Sun, 12 Jul 2026 08:32:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F05926B008A; Sun, 12 Jul 2026 08:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BAFCA6B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:32:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5461A1A0923
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 12:32:36 +0000 (UTC)
X-FDA: 84980063112.19.19926BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 822651C0002
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 12:32:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=geJcKo8l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783859554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MtkGjiGoIClKqYf6WbMTADgvs1VSC4RCPwgWlBMIBnc=;
	b=w5+cGTBT+kVeFkHCAggQfu8vJ/h18Oy/n/ik8h/GWuFYqgQdngo87ZAmrLE3KChBuIDd37
	D0mvjQwv3A3lGKTB7QwlodvkQle6ztePYKfeu1KkQ2krxCDal6WOYIQA10HxADheMEaOVh
	2SkwyRLAX56Iuel11BeVqssFU3NMH3o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=geJcKo8l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783859554;
	b=zHY2s947YPc8fBG4R1WhaVQLPRyWNVU1FbAlRKacYy9xZQmc8essVg2MhYSQZlRN6StPnL
	fqyXNtZJ+eEPgp33+spvbBxmjjqI3JIGSbegm8lkVAFJ4HyzB2q0jS2qjGwEZMGbI8lclb
	HhrhP9XPcm3K027XJLFjnP+9m29Uuj8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7347840E5D;
	Sun, 12 Jul 2026 12:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625101F000E9;
	Sun, 12 Jul 2026 12:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783859553;
	bh=MtkGjiGoIClKqYf6WbMTADgvs1VSC4RCPwgWlBMIBnc=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=geJcKo8lmOCwLH8xvS3pjM6MSkf7G28eQyFiSG6nCT2g2bYC/iGbTzTX5BCP6XbKF
	 8Rf5ExjwECx/W8ibPyCuvsaX6aIkGQeiXyzKVftKkSGaYcFpgb74pWSYDni7dIY711
	 YwWiczEPH1l/JKVndl2Wd6OPsX5pkefjuJUQ8pQ58zGRZyM7GKVo50Yg5UJNXFZksh
	 lgbpBhkNVQtqTbIFDCgXAbTjGE8fS3Ko6ejgWF4SOtfEweQ1AuICRDoUYLG8ex795L
	 Ib/03fjU59OzPmCxaypFwa3282e1OH6uu7kpx0M0YeW+mz2cd0LFmQ3Pnx4DR9/8gE
	 qc/wwrqo7bpwA==
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
In-Reply-To: <20260711-binfmt-misc-bpf-v2-v2-0-d6591ceaf207@gmail.com>
References: <20260711-binfmt-misc-bpf-v2-v2-0-d6591ceaf207@gmail.com>
Date: Sun, 12 Jul 2026 14:32:22 +0200
Message-Id: <20260712-abluft-brutkasten-aufladen-c8063a4a1a0a@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=4203; i=brauner@kernel.org;
 h=from:subject:message-id; bh=VU5CHIyaoqNRjqMq+N8FVvGRvPUNlYegA5+LAVSgSdo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFd8ZM3PJB2fnw3h2pDk1m9m0T/M/E6025wn7fzfpOW
 d7C5AbXjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkI/GNkeHPQiL3GYesmrc1v
 tSZ2fPxUztu58LPf8We7040t9978e57hr8j8bbGpuRPkD7t/1zq2+011XTWvyL61nwVVJl7m3fb
 NmAMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 822651C0002
X-Stat-Signature: iyqrigi7g49omfdnnnq6pbe699p8dfne
X-Rspam-User: 
X-HE-Tag: 1783859554-292857
X-HE-Meta: U2FsdGVkX1/J22rJb2mgO+UsqCYY2xvLOvA8T9aCMnv3HRZxkJey8pR4VVV3lKwYpAqjAP0BfJBhPDgDbnzaVAtmRiiOQZnxjTvXul6BCx4KNI0cEeR9zi/FXjPxK3wWvQ6rSP5mnqCf91+FeVL1WDzdJagc8sxkHXiJXoIk4Zo5TbxNsjNixWFiZk8nuZITMx2a2WtlGLdA/IGogSj6KztTJv70ffUYhrPotVIsoq4g2YaKXgqSXzL0j328CDchoCgb7bwfjW5lb3ieMRJ0pGq9G8stVnVTGNV5NtbWEib0CslfZoZcCIp2hC5ru3FdzcpQIezX074Y3c7+pfs7eGidq2zNyRhy1kK18dWfRap8dw2Fvcmu72ZHEqbSfd0ppi6xLnMM0XivvRUeALikDQO2UOgyo2/v3G+c1EY8WYNpg301YrOinDPxVGb4tFB2sk7yEqy1DowP3vKgQwfVFTWw1Q02qYNDuO2JlIIxIuF/36UreKwnfgGsfp4sgxgznFVkAjj/uBbX7XCGEhAutfluh9zShO1UQYSD8kuPs/peu9CSdZUe62CarQpiqDywmnj/M2/naYShZRfn8EZzcA6fiym8AqjH6Mkhq34bsB+F7GQPqTAdDndEuzMliGqxrh2KH2rV1jP4dfcYIdmPLHBTawBEssg9JTWaPiXv/asVFYWlYaySEHub3IsenodstMK1OHXDiIDHPzQZyNJcSM09ubBVZTmAq9Z2gpa9KrHqQ5N/F5Ns/sDVX78c1FX5xMzQhTPN7JJfnPfCLNmQ18B3Fkc/GKQiFygSd/4B/56dEuSIIgPTPb+hKCxnLqqoAVbFpE5apD7wVujCI9uNCqSIiJkK46z16W50nggZPID4f4bs3KmRX/hdMxNKMDGUYewjATYsEbRZ1JKJnCq5Wj1WkCVNASREr6KxeiTLjw+VgfdK2rwMARcC9/LDT+mJ4bOJDY73lvgoZlETDJ5
 d7s/dyeI
 0VkN1GZvL4oaYnJpUehDVzmEb6rEfSbuzKCRXxYYXgCVnU+zX96EM7UpNpu4t95jyX6AVHNBV5bWyr/gTaerRI/+VHwmkg55f+PTwflncNbUMTQA+9a3GQi+ZXk02dT5fNXVGb6BkqNlrzU+JqaJEiAQGn4mHmvnKd1EwlGXKi8LhntvIgfw3ZSFBY2vMd6/y8IaarQ/64fBheMSTkgVMDcRbS1V30hPAwiuDaS++WpzbWx9qONLK4ELgqNWWP1ZikUY5Py2PIGWOMR1DWPstyHt2sU4qpICNqJ8W+iVhNprfahK1JVMbSbVYDJTEheK//vwvT7unqC3C3ap6ytbinIXiqN5trr3iYoMBb88auGGJpk5rasyq3dq3r5T0ylr3ai0sv7vWxa7KUgKnukKMPJZUFxn4upqlmaGA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> This is a continuation of Christian's bpf-backed binfmt_misc POC [1], which he offered
> to hand off to me. I am carrying it forward. The kernel design is his and is
> unchanged. This series rebases it onto his binfmt_misc locking/cleanup series [2]
> and adds selftests (+ fixed from the one's shared), and therefore does
> not apply to mainline alone.
> 
> As for motivation for this whole change, Christian did a great VL;MR;
> write-up [1].
> 
> TL;DR: binfmt_misc can match a binary and hand it to a fixed interpreter,
> but it can't match programmatically or compute the interpreter per binary.
> The Nix community would love to support relocatable binaries, where the
> correct loader can only be found relative to the binary itself.
> This adds a 'B' handler type: a binfmt_misc_ops struct_ops program that
> inspects the binary and picks the interpreter with one new kfunc,
> bpf_binprm_set_interp().
> 
>   bpftool struct_ops register nix_origin.bpf.o /sys/fs/bpf
>   echo ':nix-origin:B:nix_origin::::' > /proc/sys/fs/binfmt_misc/register

Thanks! So I've spent some more time working on this because I had some
future ideas that I needed to make sure could be accomodated by this
(currently on vacation but hey...). So the version I have givex this a
better design and has future extensibility in mind:

- The single sleepable load op is split into two ops:

      struct binfmt_misc_ops {
      	bool (*match)(struct linux_binprm *bprm);
      	int (*load)(struct linux_binprm *bprm);
      	char name[BINFMT_MISC_OPS_NAME_MAX];
      };

  The non-sleepable match program runs from the RCU entry lookup
  walk itself, exactly like magic and extension matching: same
  registration order, same first-match-wins semantics, and it can
  only rely on the prefetched bprm->buf. It must be free of side
  effects since the walk may be restarted.

  The sleepable load program runs once the walk has committed to the
  entry and does the file reading and the interpreter selection. Both
  ops are mandatory, the struct_ops plumbing enforces the sleepability
  of each, and since bpf_binprm_set_interp() is KF_SLEEPABLE a match
  program cannot select an interpreter by construction.

- A match is a commitment. A failing load program fails the exec instead
  of falling through to later entries. -ENOEXEC keeps its usual meaning
  and hands the binary to the remaining binary formats, for a handler
  that discovers it cannot serve the binary after all.

  This kills the part of v1 I disliked the most: the skip cursor and the
  leave-and-rescan loop in load_misc_binary() are gone. The walk is
  never left and re-entered, and 'B' entries need no special semantics
  against concurrent (un)registration anymore.

  Your v2 changelog note about keeping the bpf retry loop in the
  __free() style is moot as a consequence. The loop no longer exists.

- The load return convention flipped: 0 now means success after the
  program called bpf_binprm_set_interp(). Returning 0 without having
  selected an interpreter or returning a positive value is treated as
  -ENOEXEC, other negative errnos fail the exec.

  So the "return bpf_binprm_set_interp(...) ?: 1" idiom from the v1-era
  programs becomes plain "return bpf_binprm_set_interp(...)".

- The handler name moved from the offset field to the interpreter field
  that field consistently names whoever supplies the interpreter, a path
  for static entries, a handler for 'B' entries. Offset, magic, and mask
  must be empty:

	echo ':nix-origin:B::::nix_origin:' > register

- 'C' is allowed now, v1 rejected it. It behaves exactly as for a static
   entry. The setuid transition stays gated by vfsuid_has_mapping() in
   the caller's user namespace. Which makes 'B' handlers usable for a
   per-binary loader over setuid binaries. 'F' stays rejected as there
   is no fixed interpreter to pre-open (I have other ideas how we'll do
   something like it later.).

Nothing changed in the exec patch, the fs kfuncs patch, the kfunc
itself, or the registry/namespacing model.

I can send v3 in a bit if that's ok.

-- 
Christian Brauner <brauner@kernel.org>

