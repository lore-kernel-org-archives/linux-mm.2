Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2797C55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 09:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A972A6B0088; Fri, 31 Jul 2026 05:41:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1F8A6B008A; Fri, 31 Jul 2026 05:41:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E8C66B008C; Fri, 31 Jul 2026 05:41:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 595206B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 05:41:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E33F12038F
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:41:29 +0000 (UTC)
X-FDA: 85048579098.25.D9BA580
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7DDA640009
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:41:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MHyBtkKN;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785490887;
	b=AshRrNS207mBiUjf2iYHCErJa7MMAxdchx4nyqdzeG21iGZ+l023cpPB/VCcHo7NqtqQsK
	OChESvxe5uxeZG8qnq3haOPKxv0zyolNGqOVdomFK4F3mmIkonH4zxd9Jw8KMErnAd61/M
	JDeiPC367Abl3Fzn7qrs2V0oTTP+Pkk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MHyBtkKN;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785490887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5swYhhwmDsY2I9Ui+t/EYKiUCwSQ//1AdDb9h151IAQ=;
	b=ZDM8PDGyCQgOpRtYAuI26b8yI4LYmcmvs1H8xTE76XDRwfz65urlvOQm1O3NvRKi4NRd/q
	pFPPUatBglYb9J4qTHUqta8xsjpze/z4PD1TLEraF3HZh0YzkAIR9WHHYlcA21bH3j8V9M
	kx39hXlzTbz0OTnQeM69jSm8DkeTFvM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3CDC06004E;
	Fri, 31 Jul 2026 09:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DE71F000E9;
	Fri, 31 Jul 2026 09:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785490885;
	bh=5swYhhwmDsY2I9Ui+t/EYKiUCwSQ//1AdDb9h151IAQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=MHyBtkKNKk3PEr5OOfeeq8QoOqdVgZebFzrICCA4sG84mDkQi7+EaB6HoTGaQyshu
	 0znkSDBjxiq9NNhR9e/hSLDQ3SvrjizbYbnZ4UuT4lWFuFUXYiJZPPcl2JxBufqJ+y
	 +GWnAAk1f27gj71hMC+fop9oXfWuUzUI4EjN2EjjyPHF0oga/Pv9zs0FdpcQ3QGonX
	 lp6W8b9RLCCbWvOR1fHg+M6dzgwYEjmaeqCqEYDc3CtEDnRMbbKng9wYbp13Jakh8K
	 1TK5gR4ZpdCqF9o2U5nEPtet1EUK+sdVdoXp7uEVMRSX/KvOSNieu8qbN99DB/R++t
	 S70FvHl+p+XQw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH] fs: binfmt_misc: introduce eBPF-based matching and
 interpreter selection
From: Christian Brauner <brauner@kernel.org>
To: Alessandro Di Federico <ale@rev.ng>
Cc: Christian Brauner <brauner@kernel.org>, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, david.laight.linux@gmail.com, 
 jack@suse.cz, jannh@google.com, kees@kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mail@johnericson.me, 
 shuah@kernel.org, viro@zeniv.linux.org.uk, Gemini <assistant@google.com>
In-Reply-To: <20260731004604.53c66732@spawn>
References: <20260704-kochkunst-hauswand-blass-7226e9443a9f@brauner>
 <20260704211409.1978485-1-farid.m.zakaria@gmail.com>
 <20260706-uhren-raubbau-sinnkrise-e40a8337414b@brauner>
 <CACCo2jm5=xrQNfak=TdO=2oh0DC5pe+atj=UfuTa8Y9s8GVkqg@mail.gmail.com>
 <20260707-campieren-fingen-himbeeren-e4b682bd8e63@brauner>
 <20260722011217.45e79a08@spawn>
 <20260722-raser-leselust-konsolidieren-05f8e36a0782@brauner>
 <20260731004604.53c66732@spawn>
Date: Fri, 31 Jul 2026 11:41:20 +0200
Message-Id: <20260731-batterie-galant-zumachen-d4b91acf8af0@brauner>
X-Mailer: b4 0.16-dev-af865
X-Developer-Signature: v=1; a=openpgp-sha256; l=7481; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5swYhhwmDsY2I9Ui+t/EYKiUCwSQ//1AdDb9h151IAQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTl5B5KWTjLcrO8T5fsZTvlOXIRH1qbIkvP+GafUQs8U
 WzxWnxeRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwESqVjMybGf+PC3smJ7QM7cv
 dSV95xlSZ7jfEmVdcvjNwYkzow0YPRj+ae3obLgz9/5Gwbmn9Qz/NGyfnxh+7IDyVN7geYnZBpo
 WXAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7DDA640009
X-Stat-Signature: qsmi9fkd7uzpk4cy5u8cwzt8yaamm7f9
X-Rspam-User: 
X-HE-Tag: 1785490887-488985
X-HE-Meta: U2FsdGVkX18ippxYQ31XLqitryowIcb01MoIjuhOR134P7nR4t8eV9tuWtJ6r5nGQ5YARyV9hwVgr6uMFphKcVRCed8/zyW8/aNzzbd0fqJXfF5+oVAuXIqoqEUU2Ub5OHAf60G7aNPNPsB4lNZ5ONFWXvafrPT/N2W0D9q4XnK3ymDxvLHUaSIRKLpWygSShGanesygkv8PwzYzeNwdS74D4D0gmAJnDIdbk+jy6+ENdkVEoXL2lO83nq3GCZOIOpcBzxQKEvkZr7VQOcPgkieRXSnsGOHpHqlqRN+MeBxuwTajReM5EiwwBg1kN6rUS9fLXJSO3FxPE0uAwfGFxQ7bbdBvHHiABwgahdfQBVK30X11aRkp8s4SCgw9jkNdiI5rUsQloivzj24yCOq9gu7HbEexIOjuB0cMPdMOyZtRj95y4CdrQDwhnKhj94X7APewPPhaAbtEKYcrPkrZzzUoTqAbNNwzaPVTihYj57nmTuih+ijrpwxe8EG1ApnwiOQ2nzKxtr/IAEX7g0FckE7U2Rm7bVBKD9NZ7iDOi8+7gL30WxVBUjvPJroHRlvX61k+f9E6rzODxHaHFuhlmgVIHAswZ7AgRfHnt5fRmmByPcXN9xGPhw5xKIUDWUaP/CumYqiL9+KZgitwCkXqnTPgsnQbdrCGXvI4pTZxLgb2zKhXHqgEL/9UHIQBCQsEX/Opt/i+a098mhXiHQaqtK+th8SpQ0F1DwFsNoBujqS0dvCRAlMaSjn+cCiE2WgdU3sbaV0XZ4X19lT3b03MhFwaKuCWUOYsFO0pz3IngYgdtNpbymhyazMvDm+HhP3QkbB/vYkdJ08sDBs+SdEQzyWxeWFU2GlLo1nvYfQTAVsLQq1C9FgOPwT5NE8FtcvwG12hbmG4WpfwZT2A/5sZ5okQ4CeJ71BhdzO/9ih9oCyUL6bZ18P07mizzkwt5TTffo2GBsv60SnRCgcsTLs
 2VcW3CNR
 8FQRSyRsbgqLwzGcSHfkgZxCs+l6xuCBxn8Bqg0fFbyLDGBNxZH+wft6UDJ0KapzyTmkP45T4Y/25r5qjnigk6fQvGYM8qiAoZ/83Whx/ArFfTQq+f3m5wO5Eaw4rMfcvFHUVKo2EdchZllX9Nod6j/dy7eF/t7jRC/eE+VFgMykK4i4oWnoWJg4Ii4NhJeXDfm8V6j73cOk+NM0KpZb/aw/R8lE9FdXjlHDXp8WZPBKEqeR7DGoiIB60KCLkHkzaRa88TXODZyaoHuYuoYJd7Ak03WnKu8TGuWGk8N/E95Upqu+UOYPfGh/hGmR45B4YGky6JOOA1XB+hfQ7M41ecZjHX5d/35cso8yMWGdpyxrbmGyllnM5qVWnqh0nrGZkT9/lku9ViYNSzk0b1D5db/8vOV0R7vDWONwk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 12:46:04AM +0200, Alessandro Di Federico wrote:
> One could delegate the feature to user space, but that makes it much
> harder to get adopted in a uniform way.
>
> Will systemd, Android [1] and OpenWrt implement this? In the same way?
> If so, at that point it could have just been a feature of the Linux ELF
> extension.

Whether systemd, Android or OpenWrt adopt something isn't a decision the
kernel gets to make and it isn't one it has to make. Merging code doesn't
create adoption. It creates an obligation to keep the behavior working
forever. That includes the machines whose owners never asked for it.

It's also not how ELF conventions get established. PT_GNU_STACK and
PT_GNU_PROPERTY are the two OS-range headers our loader acts on. And
they came out of the toolchain and we implemented them afterwards.

The one time we picked a program header type ourselves ahead of the ABI
PT_ARM_MEMTAG_MTE in 761b9b366cec we collided with PT_AARCH64_UNWIND
and had to change the name and the value three months later. We got away
with it because it's a coredump segment that gdb reads, not the exec
behavior of every binary on the system.

If you want systemd, Android and OpenWrt to agree on one marker, the
thing that produces that agreement is generic-abi with binutils and
glibc/musl on board, and then we can implement it.

So we don't actually disagree about there being an ELF feature. We
disagree about what the header means. My position is that the header
names the intent and userspace implements the resolution. Yours is that
the kernel does both.

> Of course the Android people could disable the feature even if it's
> in the kernel, but if the convention is established by the kernel,
> there's really no reason to deviate from it in the way it's implemented.

The kernel can't establish this convention. It can only implement one.
If binutils won't emit the header and no loader cooperates, we've shipped
uapi that nothing uses and that we still can't remove.

> The whole point of the portability thing is to reduce the assumptions
> you make about the target system. Ideally, you just want to use
> features widely available in kernels in the wild.

Sure, but nothing merged today is widely available tomorrow. Both need a
new kernel. Uniform-by-default doesn't arrive sooner because it went
into core elf.

And a new phdr doesn't degrade nicely. On any kernel that doesn't know
it the binary has no PT_INTERP it loads as static. Dies horribly at an
unrelocated _start.

And keeping a literal $ORIGIN fallback in PT_INTERP instead and old
kernels or gVisor open it cwd-relative, so an attacker who controls cwd
plants ./$ORIGIN/ld.so.

> But from what I understand from another thread, your intention is to
> use userspace as testbench, correct?

Not testbench as in "go away and come back later". The difference is
where the semantics live once they turn out to be wrong. Get a corner
case wrong in a bpf handler and the distro ships a fix in the next
update. Get it wrong in load_elf_binary() and it's the exec behavior of
arbitrary binaries... which we can't change afterwards.

> > This is policy that the admin should decide
>
> Agreed, but the admin is probably satisfied with enabling/disabling,
> not deciding whether the program header type is `PT_INTERP_WITH_ORIGIN`
> or `PT_ORIGIN_ENABLED_INTERP`. Same for the distro maintainers.

Nobody is asking an admin to name a program header type. The distro ships
the handler and a file in /etc/binfmt.d and the admin never sees either.

But note what you argued here... If it needs an enable/disable switch
then it is policy. And the only question left is what the switch looks
like. A global boot-time on/off is the worst available version of it.
It's one bit, machine-wide and can't be scoped to a subtree, can't be
delegated.

> Then, from a security perspective, AFAIU, implementing this in
> eBPF does not solve the problems that have been discussed.
>
> For instance, `selftests/exec: add binfmt_misc bpf-backed handler test`
> does string manipulation (no `openat`).

The handler doing nothing but string manipulation isn't a simplification
in the example. It's the design. The program never opens anything. It
computes a path and hands it back, and the kernel opens it with
open_exec() under the credentials of whoever called execve(). There is
no openat() to add. And fwiw, it also supports pre-opened binaries for
really crazy use-cases where you want to pin a set of loaders once.

The module RFC resolved $ORIGIN in kernel code opened the interpreter
itself with file_open_root(..., O_RDONLY, 0).
That skips everything open_exec() does and it achors path resolution at
the binary's directory. .. clamps there and absolute symlinks resolve
inside it. $ORIGIN/../lib/ld.so, which is the RPATH idiom everyone
actually writes, silently means <bindir>/lib/ld.so.

I'm not holding an RFC to final-code standards. The point is that this
is fiddly.

> Overall, I feel like the current proposal pushes back on having a new
> ELF feature for security reasons, but then delegates to distro
> maintainers who want to use the feature to take those risks.

It doesn't delegate the risk. It binds it to whoever wants the feature.

Whether resolving the loader relative to the binary is safe depends on
invariants of the deployment. Is the tree immutable, who may write to it,
which prefixes are trusted. The kernel doesn't know any of that.
/nix/store is root-owned and immutable, so the policy is safe there. The
same semantics pointed at a directory the user can write to is a hole.
Only the deployment can tell those two apart.

Userspace arrived at the same answer, incidentally. glibc expands $ORIGIN
under __libc_enable_secure only when it is the first path component and
the result is rooted in a trusted directory. That trusted-directory
notion is exactly what an in-kernel implementation would have to invent.
And it is deployment-specific.

> But also, distro maintainers don't really need this feature because
> they can just write /nix.

Right, and that's the honest core of it. The people who need this are
users on machines that someone else administers.

But "default-enabled ELF feature" is a strange shape of fix for it.
Because the machines you'd be enabling it on belong to the people who
never asked. This proposals is to change what exec does for everyone
else in order to serve some use-cases.

> I'd be happy to try to work on the example eBPF program using openat,
> address the various security concerns that have been mentioned until it
> looks right and then it could be loaded by default, but with an option
> to disable it. But I'm not sure whether there's such a thing as "default
> loaded eBPF program".

And there is such a thing. The distro ships the object plus a file in
/etc/binfmt.d and systemd loads it at boot. That is a default-loaded
program with an option to disable, it just lives in the distro image
rather than in vmlinux. If one handler ends up being what everybody
ships, that's the uniformity you're after, and nobody had to freeze
resolution semantics to get it. Could even be upstream in systemd.

> Alternatively, I could extend the ELF core as a parallel feature of
> the eBPF-based mechanism, reviving some patches from previous
> iterations.

I'd rather not, for the reasons above.


