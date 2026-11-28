Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DE99606A32A
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 10:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cfjJUrS3
Received: by kanga.kvack.org (Postfix)
	id 1CD376B05B0; Sat, 28 Nov 2026 05:36:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17BCA6B05B1; Sat, 28 Nov 2026 05:36:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091F56B05B2; Sat, 28 Nov 2026 05:36:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 977B36B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 05:36:45 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E1DC1A05CF
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 10:36:45 +0000 (UTC)
X-FDA: 85484174370.21.774CF32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8535A40005
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 10:36:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cfjJUrS3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795862203;
	b=uza73XhqukK2FeHQ4/ydd3expKY1gDFxlDKGyaqPrjdakGNk4X9Mr7TqEayr8ZoblUe714
	yxRZXG8lk5aXyHbVtEKO770Qxwq4Iu+mol+XDLGio11jgtAzsioqFb76saTCTUFhKWWd7n
	zPvZs4gKQRIziM4jXg78Ay7MDHm5xWY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795862203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3C9fX4TIO80ht8xlUhmpeoykwcnqNbqprrFt/B+wKJc=;
	b=m/pDIZWd80LdihyhCPf1EpUqP8MR+x3V5CJgeLgtDzE3WCclR/zTA49RM8NcuMsOH9hqMu
	2eBb6yww+Yr8F3dKWvW4SUuEh58oQ4X9nFP0bycxUibkdcNQMPw0Qi/cY8QLBcErMKrFx1
	+tk3FbgreHYy22Nubd8gKJdgb8LeV1M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cfjJUrS3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 1042B60DE9;
	Sat, 28 Nov 2026 10:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 057F61F00893;
	Sat, 28 Nov 2026 10:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795862202;
	bh=3C9fX4TIO80ht8xlUhmpeoykwcnqNbqprrFt/B+wKJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cfjJUrS3gUBp7Dj8bg4xSg/pcM8dtIiFwpRZtQI3hkfgOAOpj1rtAPl8EcrkgC6Yi
	 zF07mAyFPCnZBzmmYeYAJwOQBoS+Zm3JsVmcaKjKX3kQZUkiY+4E4oOgfiGSGsYo8D
	 sqv5rnd8NE4FuW168wtBtZ5sx3OUiC4ISi3UeCtp8USTmKeJN7zvOdUYZ/Wv8IPeKW
	 06Dk8OPl+36CxYkf8QRtAGB2kqhRbNtcSWPsNh5fFRMVGM627+sc3qaANYIHviDCqf
	 j+QZkklHBewmwUrwk9T2v6rua/o6Wrozl99k9QloP7arJXXV0RSFJnE2PNyYxhWrvZ
	 SnPGJ2wfA5hPA==
Date: Sat, 28 Nov 2026 12:36:39 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: aleksa@amutable.com, alex@amutable.com, alexei.starovoitov@gmail.com,
	arnd@arndb.de, bpf@vger.kernel.org, brauner@kernel.org,
	containers@lists.linux.dev, corbet@lwn.net, dhowells@redhat.com,
	ebiggers@kernel.org, giuseppe@scrivano.org, hughd@google.com,
	jack@suse.cz, jlayton@kernel.org, josef@toxicpanda.com,
	kees@kernel.org, kpsingh@kernel.org, lennart@poettering.net,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	luto@amacapital.net, neal@gompa.dev, oleg@redhat.com,
	paul@paul-moore.com, ptikhomirov@virtuozzo.com, sergeh@kernel.org,
	skhan@linuxfoundation.org, viro@zeniv.linux.org.uk,
	zygmunt.krynicki@canonical.com
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awqut63HdrL97iu3@kernel.org>
References: <awOQDOel_72Xwjm7@kernel.org>
 <20261127214103.542291-1-safinaskar@gmail.com>
 <awn-ioAuksHNV-Rc@kernel.org>
 <awn_Y7oI4ckfsjSv@kernel.org>
 <awoHex4LVst2JwkO@kernel.org>
 <awoO9R7YF_5_6dHA@kernel.org>
 <CAPnZJGBnFyrmr88OsYkMwtLiR93z4g0NAuoMurcnhcYFXz51jg@mail.gmail.com>
 <awqkft-e6Tbj7dbJ@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <awqkft-e6Tbj7dbJ@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8535A40005
X-Stat-Signature: 4dqbj8zw563erzxeysxy6r7qb65nutcg
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795862203-71383
X-HE-Meta: U2FsdGVkX19byT0YFL9wjnZAHE6CKo6UXUD92e79nHxbSUfXD2xEnq+asGxOKZiOnrSL4tuwobHHyewBtcP2e+JzTT+uSUUKfcCx93vJgnRUi6pypNGvNm1oHR9MEfdw2aq2RCzA83sl2DoOXT2wdhcn1xP33PRCyHVE/cignu9zvkTW3XB3rhQ7xQ4Z5b61AEgtPKA60t9nr8sFboP8vtOM9WjSFvJI+z1rff/ukNmoZxOKHx0QKWVJcj5PemSEk+BbpMuBuqvT03PFLy+JeiStkA5Ez/SOH1o3um02fqkX605gebDFzJSdJS49jqSHVk3JwVViW3Rca/v0LUrGBbHPhmMe6EMGCXQ9x1BDvqjlFJfqOwnx+K82TsMirThSBL5fGhSSMguYh6gino68mBF1rKg61qrTp2StCwEVMMyQihDQVYK9rCaMXIMol4o3rYLxgBraGYG3/89Wu0TwCyG1tr9mkxNN1xGx7Ze/49UG1zPnYFdgRjh8THDzIM4GInMf6EofQhQ9btRkvIpA23Syw4mKegzXP4471tQqOCODmNqIyeFVUwglA80gPuBeSaQMIezTPnR/4fsmkieeIfY9OIDxGK48wLaQDOUW61zvWhL7IpOGw6hqYbhcdIAWKGP6r4Rkiwsizh40dsjwjksVs8WsHVJ+7Wkgk2ovp6+DAk0JtCj9Mej5EEjBTgUX+7IL2dqo2dAnyqJA6hOKN4T5wtwaTnyx+ydU5pw2T7EajcSwl3TnP9dt8bUsJ8pwiAH7ZDdyfslsV8aCerFvARtrCmQnJJAOyKMpbTRCeGYVhDD1JwGsB9Oc4FAOgx84HrSTJwKnMHU2jOUAA6g/dbQRyecUO01Xiw5Sw+Yxwcv81RF9G4HjJwn7xvdweLpxxMul7wxyOVeirHNO22tKv64potaROGvKJ9uQTFzDP0SpLzZOijs6fLTsi7s2hxWXC9+TDAqE9vwPoO7ovzw
 4Ls+1/vs
 qFJNyJpLhVlxGKcCfZrI8M/Zlvbzh8Lp2l786hp9nOqYBtBrgtpCymVlS+d8QiTfa4QKQl6zERIGQ4YiCRi5IiXhByBcvZhrk4d3kgA8rcgteOx/mDypKfWTr/zUjhR7asKyMkK9z8fy7EY6M3Tsa2WZZkK21/ptOL4MEbyZetl39I1B4eXQHksHf8GLh4g2HB6F1Jr/nooub2cQnftjK9QzcL9k6Lzg4vYpPbmoYTeZtB0lli0OvCjN8jev7zevBMszXic8oKYtMs7JXMDrZ9zCnUkAKkjiW/BCSKkUfytiUbwW/aHtuc47H9SMiXmjQZoXvqC0BHtbwi2DLDEmqVQagb6U48zwMZieOgDElQDiFC6et8+I16Aqe7eof/4vUqeVgGuWvYsWn3vK8uO3VBzthFMldBjgBFHngmxyOBzWnIaWB5DgHm4wrWejb/exy5g/xEdkU5fZjkYAab+VNSm1JAM9thr340KsfJypCfqnng3I65ok6UgftBYxPcnhLZTUJFfcKOcieoCTmbrWyaNhIHUGkVcDeq4uqr7S8h2/M1sUYluCCSw9pmHNY7qSw3cq7m2Es1vOdypm2uG9FX4wmVxEcuPDowW26uijGgsFx0kBihCaCAJqXrlBlFWBrvRgAHdIllhNPvTo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 28, 2026 at 11:53:06AM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 28, 2026 at 04:50:42AM +0300, Askar Safin wrote:
> > On Sat, Nov 28, 2026 at 2:15 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > > thinking more sequencing than data structures. I.e. I have a game where
> > > I need to end up to process creation without embryonic state, and add
> > > just enough weight to kernel to support that outcome, and that leads
> > > to ~2K'ish LOC of extra kernel complexity.
> > 
> > So you don't have embryonic state? I don't like this.
> > 
> > Let's assume the following situation. Userland's PID 1 is already running.
> > Our container manager attempts to spawn yet another process into userland.
> > As well as I understand, it should do clone3 with CLONE_INTO_USERLAND,
> > and then execve.
> > This creates time hole when there is process, which already runs inside
> > userland (i. e. its PID namespace and other namespaces), but runs
> > container manager's binary and have container manager's mm.
> > This invites for bugs. Other processes, which already run inside userland,
> > may somehow take advantage of this.
> > For example, see section "CVE-2019-5736 Is a Very Very Very Bad
> > Privilege Escalation to Host Root"
> > of https://brauner.io/2019/02/12/privileged-containers.html .
> > So, here I like embryos.
> 
> We all have things that I like but let's talk about facts instead.
> 
> CVE-2019-5736 was also not a sibling process racing the pre-execve
> window: it happened inside execve() itself via binfmt_script resolving
> container-controlled #!/proc/self/exe.
> 
> CLONE_INTO_USERLAND rejects CLONE_VM, CLONE_FILES, CLONE_FS, and
> CLONE_SIGHAND, keeps exec_state->user_ns in the caller's outer user
> namespace, and resets exec_state->dumpable to suid_dumpable (0) when
> installing userland->user_ns. Until execve(), ptrace_may_access() checks
> CAP_SYS_PTRACE against the outer user_ns, so processes inside the
> userland cannot ptrace the child or access /proc/<pid>/{exe,mem,fd}.

The build phase on struct userland (USERLAND_INIT, before any task
exists) lets clone3(CLONE_INTO_USERLAND) stay an atomic copy_process()
step and execve() stay as it is.

It fully lives in the *pre-existing syscall paths*".

Br, Jarkko

