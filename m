Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9525CCDE006
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6055E6B008A; Thu, 25 Jun 2026 04:51:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD236B0092; Thu, 25 Jun 2026 04:51:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5195D6B0093; Thu, 25 Jun 2026 04:51:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 228C66B008A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:51:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BC848FDAB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:50:59 +0000 (UTC)
X-FDA: 84917815038.22.3559609
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D6107C0009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:50:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mit2xoCJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782377457;
	b=nnBj9t+T3ML27acMtYzl0Jnwr+hm/EmfagyRsZ/wdBVBshZLWzIXy1qF/esd7RqQ3PJvIR
	rXmrDBo+CJahMdDCkhBWCmrTDzqtPXYLBuzp1ioe21TCU6GqRvexe3jG/VfMMFl3jpkMs7
	SoT4o7UfwISnihuAMtVPbs4LBZVeuXw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782377457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2OPM2QsERty8ncczG0J+oScu2vAmciLsKe1D4GkLBlw=;
	b=q1XGIn7dvaeNgBwsTJ61VD3EvAK3FSyuFEiL6HHwIIoSKBaS+FjhiQ9YBSC92Qfcrvk1vi
	JGf4XQKZrrjJn4NNl09eicqluZMaFmyEI72xPaXH8BJ/V7f0uXuUAA1ZE0zoQFqqDzzSH7
	IrILMuYyl22fj3FobkdvnUqWd/9vbwM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mit2xoCJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D8AA60217;
	Thu, 25 Jun 2026 08:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD931F00A3A;
	Thu, 25 Jun 2026 08:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782377457;
	bh=2OPM2QsERty8ncczG0J+oScu2vAmciLsKe1D4GkLBlw=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Mit2xoCJBPEjBNx0LAYKxG3Cj3APh7/SkQ5Ko2v0NtcvZNcFPqpYoQiAvNwsLX1tJ
	 U4Jn66pXvAalZ5osrav9nyxvrhb19PCq5cEWHWKt1VkLezWyVh+RKC7P0R6Xx5KY5X
	 hdlsN6mDxbF8Ice+x5WO7sgORA5SEFX5gzDrGBBiOyqplfaogfRLMOcZwwWWRdenwH
	 q4iq+BpK5UyGIAfO5gUXEUnGUqDVDAEZUAjiTrJX/W8ahqugi9vBKJUe/wYnsWtXr0
	 vfbIK6qTPpk9/tJY05vcccFsN1HiQMHZzc0uy0VckYBNpOOd3YJzAa9OXd0BQdxyPT
	 2U/RCre0IQP4g==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] fs: support $ORIGIN in ELF interpreter paths
From: Christian Brauner <brauner@kernel.org>
To: John Ericson <mail@johnericson.me>
Cc: Farid Zakaria <farid.m.zakaria@gmail.com>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>, 
 Al Viro <viro@zeniv.linux.org.uk>, shuah@kernel.org, 
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
 linux-mm <linux-mm@kvack.org>, 
 linux-kselftest <linux-kselftest@vger.kernel.org>, 
 LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <24420045-a6eb-4999-ab19-1e344eaba8a4@app.fastmail.com>
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
 <sfv7zc6jboy2oxv7zuyofysas4ncbzenwsuzveiyduisfr6i7q@mx23er7uxdbg>
 <CACCo2jkDuwy5w_yhX8833m+s-rY736pk8xtKjxg3_y_7BCOHeg@mail.gmail.com>
 <24420045-a6eb-4999-ab19-1e344eaba8a4@app.fastmail.com>
Date: Thu, 25 Jun 2026 10:50:52 +0200
Message-Id: <20260625-atomkraftgegner-hunger-kursbuch-b452ff2becab@brauner>
X-Mailer: b4 0.16-dev-d9d01
X-Developer-Signature: v=1; a=openpgp-sha256; l=6562; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YWjLajG3jUSlfnNHIHqvQH7npOW2FoDppQt4WSwGrdY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTZvH4nE7tbujU0/s/WsOh44XiL7RvXiPQUNz/+taiyQ
 fEY95kFHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN5JsDI0NwWeqnwedgvs+Nf
 NPVn5cp2q1b41m/SMf/y3mmPSf0FU4b/iYxZEdvvRB0RLM7ZqLxfvfPybl4Oya6D7IEKjqvPfdj
 ODwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D6107C0009
X-Stat-Signature: y5fg74uygk6a8ymq71fq9k8obkfwo3ic
X-HE-Tag: 1782377457-445077
X-HE-Meta: U2FsdGVkX19Qdhs/BRF76VnWE7SG6soCJHt/me02hGQpdnVAp94tvCMjiKERmu0DOa1mWGw9MEy8N2HZ7tJaNNJO8auroX0E+DnNSOEU821/oGTS6qM5/AtLcbdn//Rh7xOqjbUKJ65ed7nJtLgpfv6IqVPcO2Pv3xJUrT6PTlJtvs61lZyy9IOjTnsAfYDN4+8AxwT/jU9FIgO/5FCzWIATr9+JaXyBsO2VS93ssYh1OkKvKDKVL5GqZHvRFZI0SLiHGAhm4AdQKiWdxJa26CNH3reW2VQJFCqimaaMDsfBkGb7wgP6dYwm2czOsu+sTVEY/6kxalubM/vK6Sial74sEoK2lwYlu1yvZGZhq0Sd1dT/lqng4WyMksewiTWwhwyGOZH6Bgy5N9d4guma0gCVFqfBsLtUdMQsEIBbNHZbf57MGqQVPscaZ5UEXJK5tgIIia7/+nG9EQu63cAAJk7zLjQsUQEQICTnq18z2JzyAb6q6TWJMkqFFUCS9m295ZqzyAOrYQjfCqgaO+GTpIzBGJHxG4cvnbm9gD7fF84Sty4/4J/MN3sOeAviuIN3d6trNgXVTQZpepd9wex30EHqnTMe3T1n5g68ZZMbtXGwczPXto/3FSkx8tA+nALX3WLt6m4x4VHJQcsosdjhFE8gkjMKM3Fk1HcDJcE5qjrEpwsuqVDmzZIxjKm+U64yZSPFHVnbxSkArZyakbfkPS9RC8PLG54yCCRhj3NaYilWciVdrV++bFoBxu2r3ZkAU9pY2gFVvCdTN6GH6BG7P+UpdSgm8nRKirCPN7LYmF0yet7l3ueHdwW/yZ8LmEXGMIMVZ19div7f+Yij9T3Sx/gb4WBdU/vYlRxi1BV5nAzOQZvnYO9KWx77nFS54n/4HLysf0cn/5egvPXtAVsBrZOaEodMbUIj3Xi9EURjCI66zSLQdZNfp/s9GiLOsQ20GkmaVi+uS6h2SxmR2O0
 fosCUQ0t
 PXGDmwp/SM33mCAtA4xSqDfpA1JPiNqycHyNV62nN6eUATAyOtqk4CA98d3bkkuiUpbszdzbXPfjAQc/oEZkgHDpGh5NlK4fq1i3ZLdlsrRx2pFVWMCP5a7/dCOK//eVwhlUXikSnSx+4AfhWsbpzE3M1yxEfMOK9gX9sAWPPdLoPERKvNppuQcwvoB8AsiCOztZnYs/Cy4L87OyScFpjZLuvohp9TS/LLp3+bFNqjN7XWWrVeGkLia+cqHUaTxzjNspyONousLClygKSlxhcDrfdPFaFZn+VJpxg/gMEoXRIZjLsbBAfEYYdLp060lMwvJXEoK1Xd9B1l3xFQPru2mFfe5V/HOvC+kgb6CQW7wfsDUm2qRC27p11FH1++EmIfqcQffcOy6NA6iHgb3Be08JZdiUu1PcaPYL3Go09xlLY6dHqf/szqabik1qLgOdJId9zzjI/ZWeTZSi8XyPfNVwEz/KIGbvQTKr2rVEYHVojfXhPbuTEfdbYrirU2PiU8ubVUMHgeij/GVU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-22 17:08:55-04:00, John Ericson wrote:
> Hi, I am another Nix developer, and have participated in some LKML
> discussions in the (recent and distant) past, and thought I should weigh
> in here too.
> 
> On Mon, Jun 22, 2026, at 1:15 PM, Farid Zakaria wrote:
> 
> > On Mon, Jun 22, 2026 at 3:40 AM Jan Kara <jack@suse.cz> wrote:
> >
> > Having put forward the patch, I'm clearly biased toward thinking this
> > support should exist in the kernel.
> > If I had to think to strengthen my argument would be that the kernel
> > should not be imposing how the interpreter is found on userland.
> > Finding the interpreter relative to the binary would be useful for
> > package deployment scenarios similar to app-bundles beyond systems
> > like Nix -- which is the originating reason why $ORIGIN exists in the
> > dynamic linker.
> 
> Yes, the idea of making "relocatable software" is not a new one, and
> indeed it is why `$ORIGIN` is supported in the RPATH etc. in the first
> place.
> 
> Most of the programming model for writing relocatable software is fixed
> at this point. For example, /proc/self/exe made it much easier to look
> up arbitrary stuff relevant to the current executable. It is just some
> initial entry point stuff (the ELF interpreter, and shebangs) which is a
> glaring exception. Those should support `$ORIGIN` too. There is no good
> technical justification (that I can think of) for some but not all of
> these supporting `$ORIGIN` --- either it makes sense everywhere, or it
> makes sense nowhere.
> 
> (I suspect the only reason it didn't happen was pure inertia/Conway's
> law --- easier for whoever was excited about `$ORIGIN` to change the
> glibc loader than the kernel.)
> 
> > To me, the gap is that prior to systems like Nix, the idea of wanting
> > your dynamic linker to be part of your app bundle was not necessary
> > but Nix models the dependency chain down to the loader. Such
> > functionality would be even more correct for these other bundled
> > solutions as well, making them portable across userspace glibc
> > versions for instance.
> 
> Yes, exactly. Traditionally people thought "eh `/lib/ld-linux.so.*`
> doesn't change too much", and decided relocatable software that
> nonetheless hard-coded that absolute path to an unknown system-provided
> ELF interpreter was good enough. (Or if they weren't good enough, they
> went with static linking, but that imposes other costs.)
> 
> Now there do exist purely-user-space work-arounds, like
> https://github.com/Mic92/wrap-buddy, but they are quite complex, and
> involve various patching trickery that is likely to scare a lot of
> security analysis tools. A kernel-based solution that allows clean
> declarative expression of intent with `$ORIGIN` is much more elegant.
> 
> > > In particular the
> 
> I think it is good to see what Conda does as documented in
> <https://docs.conda.io/projects/conda-build/en/stable/resources/make-relocatable.html>
> and consider why relying on namespaces vs good old-fashioned relocatable
> isn't good enough for them either.
> 
> (I don't doubt that Conda would find this approach more robust than
> their sedding tricks, and prefer to use it where possible.)
> 
> The short answer is while all of us in the build system space love
> sandboxing during the build, we don't want that to lead to *requiring*
> run time sandboxing of the built artifacts. For example, we can
> certainly arrange sandboxing so `/lib/ld-linux.so.*` is the one that
> some executable expects now, but every time that executable is run, it
> *must* be run in a root filesystem where `/lib/ld-linux.so.*` is the
> loader it expects.
> 
> If you have multiple programs that (for whatever reasons) expect
> multiple different loaders, all spawning one another, it would
> potentially incur quite the development cost to ensure that they all do
> the proper unsharing to make everything work.
> 
> Relocatability recognizes that whether or not namespaces exist, in an
> "open world" scenario where we don't know how the software we are
> writing will be combined with other software for deployment downstream
> in different ways, it is easiest to adopt an idiom where different
> things can be placed at different absolute paths, at the user's
> discretion, and so conflicts are always avoidable.
> 
> > > Anyway I'm pretty sure Christian will have more educated answer than me but
> 
> Waiting makes sense, I am curious too what he will have to say.

The arguments I have heard from various people so far are:

(1) Userspace would be able to clone a random chroot to /woot and run a
    binary from it without having to set up a complicated sandbox
    effectively making dynamically linked binaries more like static
    binaries in a sense.

(2) Quote:
    "If you debootstrap/dnf a chroot to some location in your
    home dir and try to run a binary from it, that it tries to load the
    libraries from your /usr is a pretty unintuitive and not at all
    useful behavior."

(3) Quote:
    "[Various remote execution things run in locked down containers that
    disable userns, which makes the sandbox impossible and hence our
    builds wouldn't work there."

I'm discounting "Oh, userspace already allows this so why not the
kernel.". I think that's generally a bad argument. Kernel and userspace
aren't really alike in that regard.

The userspace ORIGIN concept is guarded behind AT_SECURE. The kernel has
to enforce the same rule. That means the loader now depends on the type
of binary. I think this is a rather serious issue.

First, it creates confusion in userspace what loader is used. Second, it
means anything that any build/chroot that uses AT_SECURE binaries now
has to use the sandboxing solution anyway or risk that some binaries use
the system loader and others the chroot loader.

Ignoring AT_SECURE, LSMs likely will need a say in whether that ORIGIN
thing gets honored or not introducing yet another vector where this can
be overriden or ignored.

Also, we change long-standing kernel behavior which will be very
surprising for any userspace that might implicitly rely on the fact that
the system loader is used. So even if we were to do something like this
it would very likely have to be configurable in some way.

This makes this all ripe for malicious loader injection attacks. And we
need to consider this possibility.

So I'm not enthusiastic about this. I want this to be consistent.


