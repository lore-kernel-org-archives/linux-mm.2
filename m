Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D4C8606A334
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 11:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dX/0MpPr
Received: by kanga.kvack.org (Postfix)
	id CE7566B05B0; Sat, 28 Nov 2026 06:26:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C983A6B05B1; Sat, 28 Nov 2026 06:26:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAD666B05B2; Sat, 28 Nov 2026 06:26:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 477B86B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:26:17 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86F21140625
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 11:26:16 +0000 (UTC)
X-FDA: 85484299152.22.0DBAF33
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E5DE820008
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 11:26:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dX/0MpPr";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795865175;
	b=X0u8hUqXCHN3+Fqrqjoan6fnX08WSzNxRrQZoaDHPhcJgLMsyV9n5GXpBORNJO2QO7FN7A
	OnG4TVGA9lDBhqjuuQf52aDPdUZcsvEQ5c6rXH++iJe/3nvEAOkibT1ZCnEL7hy2NhMQRO
	5kRMW1Hdr165eb29e+UZADgNHcu9uNU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795865175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KleLQMep/ikw4l22dunyzk0OW7JrxNRSqCmyhew0bn8=;
	b=Kw+e+sYDiX2BVyW1wHEcw7cAyZFGyRT9VrD9rW2CCL0PSOKHQcUQIjqLuU+yaqSwIa512Q
	iHP/LV1h0jPDm1fjBTZTd/LmRxTuNUHs2BAD8VvDiCb1t56ZPMxmd1n5QvJMb4s9cNSR5E
	E49k6N/RA85oY072LGl/IIFBS6ZtFh0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dX/0MpPr";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id A56426128D;
	Sat, 28 Nov 2026 11:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A14C91F00919;
	Sat, 28 Nov 2026 11:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795865173;
	bh=KleLQMep/ikw4l22dunyzk0OW7JrxNRSqCmyhew0bn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dX/0MpPrnSdz78o1T/PxNhqtu2r3DoNwoRBz44tLf+5obQ2HIKuWyBogTE8yATYqf
	 PvZtAEUPlcWWrh2QsYKHgbBNx6hLM+Hh5XJj0jv4NrO9VatW2715WZ/uJn/UtDk9nL
	 cvKzyN4a+Zurt0NbdZAmGX76PtVIJ8SpBplJixw5SgRT3Wb2qrH1bB4aam3uvF1Ci6
	 lV4+C1VUq/6GLaxJqQNibuoOTI+GbCeEz1fkXsauRv6zUnfa0tQODeQbqJ47LyziJf
	 PACLGJbeUdbkeO02ICL/RvuHPM1bJuGKz59wWd1d7YEBiCg5aHftwtHeolG7KBnl1O
	 +66cHW3diWvDQ==
Date: Sat, 28 Nov 2026 13:26:09 +0200
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
Message-ID: <awq6UXILgmgWY3Fn@kernel.org>
References: <awOQDOel_72Xwjm7@kernel.org>
 <20261127214103.542291-1-safinaskar@gmail.com>
 <awn-ioAuksHNV-Rc@kernel.org>
 <awn_Y7oI4ckfsjSv@kernel.org>
 <awoHex4LVst2JwkO@kernel.org>
 <awoO9R7YF_5_6dHA@kernel.org>
 <CAPnZJGBnFyrmr88OsYkMwtLiR93z4g0NAuoMurcnhcYFXz51jg@mail.gmail.com>
 <awqkft-e6Tbj7dbJ@kernel.org>
 <awqut63HdrL97iu3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <awqut63HdrL97iu3@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E5DE820008
X-Rspam-User:
X-Stat-Signature: picphciri3p1g67nn678qubqsdzq95o5
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795865174-420234
X-HE-Meta: U2FsdGVkX18tmjyu2vVAupN5GIlTIMde/yqYJBIGN3rTbGMHy9FD46SqdViSVyTy+PfTtwTH6XaHRAWsiOofDn2q4vf/lCKeM4O/6KydNQck79IySTTTnDsk+JeUBXlxx8RgCDrbAelugRkN8Ow87D7CfNhbTuVhdb7dMFFlcs13vBkdlpd6E4b+6yiAZutcdpn3o35VaWJvgPg1mhxPw6euCc9DkOltbMNIwMwbc47x3fPvKMCz8n50rvvravBsB0DS8QuOqwp1CODAKUK4t8WNxEfwDCp9C1cgIE/3TrOX/of3CAVNnvUWRGI6vZMM2tc+0H9X2p/oL3AL/J/w99Ep6TRzfVBT8tYm6EmW4vWd8cTNzcPOP7N4t96+KAjLbLtFrB4OgZpElI1Slyo9eLNNMUfpEzLjmFqMQnpk2D3LlGbi2qLyCO0JiiF65NODILRb9AMGNTmSVjKZjSYUEQaXbAhdgLYpLBeQa3f8CXSsBwC7FMyCIR5fG/cHBAh42+W0+RblEdHMaArtM2Ei+FlLi6YGtZ5KBVkdLfAMaZ3aEBeEEXfhqL0ZQPXedmmTfR85/9s+RcsCGV7xAPq/nt0qLzmuzy7C2exM/KDSY5dctQ/nXfJTccKEhvdjCAAzEcUUEBo0wDod8CxC1DQ/cYJ3zfU7hc0dwEADRa3zHM6jGxvOU836HSeX3CXcS6L+qhXy+qcyP0HOds8hI0nZl3YsBIZewoHxkJn74JXQXNLFPQnnCA/5pBgViDizbsuAu9EEtuNNGyAHkJ7SoHlndch36wGClsft4BFfD0FfaEeakzsHdpSQ6E9wHC+2poF31t3I9wgJl/qHA93w5+1pU0/IRV/DVhcRbR/DEZC3gzCNP835UqVMAWY2IBFHDIawtOqvzUBrgsWUmggCB0rzATQovxzxVmlo6DVX1JlRBpb/sxDGlIEgyZuUyrd7S9v34+SlMZ+PKEswCqJn0TC
 cA5z3va9
 ZMW5vibm2QCliwdRrHlv2cLY3wSoxrq3WFssQ94osKhdYKswGtUVfEklP6imXLtlqyQPZwJt45xWFIEvUMO9D8Veva6VLmg9Gl/nAWXVbI2xvJ86z7u/YUDZIQ/XTv4rdzUrqPZvtykWWmYaP0KKgi4VIXYwMjxqIqRT4CD57kxpVGdV2w4aYJaRpC97eZ6o2xzI/Q8mXbZrVfSjlJM1Leon4BFpLO2xMKyC9mOu77eAK+ZkX4Mg354KZTpSNHgtprHVUWwfmELFl6DOv9x1YmhQRdJ2CfaiDBoC0CR9sXIV+r57ONg4acG5/pmdyyYTfKg43USl3W8Tj2Qks4BVS5svADptNGeGuBFkLSFUYRmR4qD0G99wjMne1rW4VosSF9TroC0A3VQHlgCrmu+xm7hmzUUlWe7cytMM3r0nV07mDOZhuvtQUKIQ/EwKL+hdc8tAL+OOWCOgBdSg9Q3bIIjFf+DPUUZo9kgRk2AALuxS92aWey4az6IJVEOKW/Ir41RUB/CAvbGvL0gobBW/CmBOaTEVTBD+GDU9AkoPfAH1xRO4C+Qb8Zi8gmFsD0mXkEPd4lainRrWZYDkGW2BULFDWPgXX60DjlMqt9kljH3uLzfjwciCrOQgxrdEN9V0nVhimx/DXGziW784=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 28, 2026 at 12:36:43PM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 28, 2026 at 11:53:06AM +0200, Jarkko Sakkinen wrote:
> > On Sat, Nov 28, 2026 at 04:50:42AM +0300, Askar Safin wrote:
> > > On Sat, Nov 28, 2026 at 2:15 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > > > thinking more sequencing than data structures. I.e. I have a game where
> > > > I need to end up to process creation without embryonic state, and add
> > > > just enough weight to kernel to support that outcome, and that leads
> > > > to ~2K'ish LOC of extra kernel complexity.
> > > 
> > > So you don't have embryonic state? I don't like this.
> > > 
> > > Let's assume the following situation. Userland's PID 1 is already running.
> > > Our container manager attempts to spawn yet another process into userland.
> > > As well as I understand, it should do clone3 with CLONE_INTO_USERLAND,
> > > and then execve.
> > > This creates time hole when there is process, which already runs inside
> > > userland (i. e. its PID namespace and other namespaces), but runs
> > > container manager's binary and have container manager's mm.
> > > This invites for bugs. Other processes, which already run inside userland,
> > > may somehow take advantage of this.
> > > For example, see section "CVE-2019-5736 Is a Very Very Very Bad
> > > Privilege Escalation to Host Root"
> > > of https://brauner.io/2019/02/12/privileged-containers.html .
> > > So, here I like embryos.
> > 
> > We all have things that I like but let's talk about facts instead.
> > 
> > CVE-2019-5736 was also not a sibling process racing the pre-execve
> > window: it happened inside execve() itself via binfmt_script resolving
> > container-controlled #!/proc/self/exe.
> > 
> > CLONE_INTO_USERLAND rejects CLONE_VM, CLONE_FILES, CLONE_FS, and
> > CLONE_SIGHAND, keeps exec_state->user_ns in the caller's outer user
> > namespace, and resets exec_state->dumpable to suid_dumpable (0) when
> > installing userland->user_ns. Until execve(), ptrace_may_access() checks
> > CAP_SYS_PTRACE against the outer user_ns, so processes inside the
> > userland cannot ptrace the child or access /proc/<pid>/{exe,mem,fd}.
> 
> The build phase on struct userland (USERLAND_INIT, before any task
> exists) lets clone3(CLONE_INTO_USERLAND) stay an atomic copy_process()
> step and execve() stay as it is.
> 
> It fully lives in the *pre-existing syscall paths*".

Noteworthy addition: this is also optimal for pre-existing LSM
infrastructure, as less you diverge better the pre-existing policies
can protect (and less there's need for change in e.g., SELinux
policies).

Br, Jarkko

