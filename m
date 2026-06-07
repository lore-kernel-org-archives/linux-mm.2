Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09806CD8C8C
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 13:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2C996B0088; Sun,  7 Jun 2026 09:22:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E04866B008A; Sun,  7 Jun 2026 09:22:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8D86B008C; Sun,  7 Jun 2026 09:22:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD8046B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 09:22:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58FB0A07F1
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 13:22:39 +0000 (UTC)
X-FDA: 84853181238.24.DA0ED8D
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf11.hostedemail.com (Postfix) with ESMTP id A2DA540011
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 13:22:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=cgw0GxaV;
	dmarc=pass (policy=none) header.from=linux.beauty;
	spf=pass (imf11.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780838557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c8zi6w1KcsLgtdWmWEW8oBFp/uYrjVYwQ27JP33BSQM=;
	b=qze8LESka7misvWNcQc+27Wd1XoRzcy9WC3XW10zKtXnCr+PI9LTkUhUJupzYN+njs+iAx
	QuOr4pxDUzBNu1tgSKr6IQVe2+80Skmm9/4i1/tFvWtDGRea5AyVWOJLVK0DUT0RK8Dgti
	VM3cfTXSz1cCfVBJnu7yHBa7a89hGZY=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=cgw0GxaV;
	dmarc=pass (policy=none) header.from=linux.beauty;
	spf=pass (imf11.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780838557;
	b=T4c4S2Qlc3rnmG40GakHGeq+f2wwHfal5GIqZiNWOVr2Ko+xoiwIJws4tMOMnjFY2hq5EK
	FLglWptx9cc0ZI5mK59TmslcDfM9At8ZD/8bszB0GBdRXyQqvdSd8haZzT7ST/mmvIFhmU
	K1Qi5tfkT88U28jxBBGNaPB+Imcxc6o=
ARC-Seal: i=1; a=rsa-sha256; t=1780838536; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=MhU2rKZcEEU4udEPdDeHuLN9IlYwnt1p1/BhVzyVWRkVzSIMjcuoTafZOgiH08LKW5tOayVimc+zfePrURes2I/kprNOhOsL/V0uhNN5+XWk2EcB1aqWgJ4YtGabseH1Rc94HShkFdc4qnlNfoUcAdQkkqEKZbn86QiF1YgtBVg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1780838536; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=c8zi6w1KcsLgtdWmWEW8oBFp/uYrjVYwQ27JP33BSQM=; 
	b=S3tZ0w/s2zYTLwp3GqEggDnjZgmSnbwvdHqh0YZ+0CB7jJBKO+qpK7XRkYgPAGKhjTGsuBu8JUioUj/2nO5LLShZj3glTwXz0JT05YnI7vPzb6teO7yNRvgedNb0Jt6Wt5allYMC5PC5BybmzMFZM+x0/VSS4mNvGqjifCAFi3w=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1780838536;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=c8zi6w1KcsLgtdWmWEW8oBFp/uYrjVYwQ27JP33BSQM=;
	b=cgw0GxaVBsHNzQoMY2MyrEEQjFILrEJA00aC3ra1p7FfWUPdXTPiajC+DwSpWUA2
	DoBTiGfVhkanWL4SqIICdl8RSTY/V0t8imtak2NetUogKCKaO3A6TxUMiiyzZrM2Jyb
	7uBB/7qUc3VifqFHlJrFnuxJsZq2WVvnQwBm5WRo=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1780838529335809.7321442050796; Sun, 7 Jun 2026 06:22:09 -0700 (PDT)
Date: Sun, 07 Jun 2026 21:22:09 +0800
From: Li Chen <me@linux.beauty>
To: "Gabriel Krisman Bertazi" <krisman@suse.de>
Cc: "Christian Brauner" <brauner@kernel.org>, "Kees Cook" <kees@kernel.org>,
	"Alexander Viro" <viro@zeniv.linux.org.uk>,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	"linux-api" <linux-api@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-mm" <linux-mm@kvack.org>,
	"linux-arch" <linux-arch@vger.kernel.org>,
	"linux-doc" <linux-doc@vger.kernel.org>,
	"linux-kselftest" <linux-kselftest@vger.kernel.org>,
	"x86" <x86@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>,
	"Andy Lutomirski" <luto@kernel.org>,
	"Thomas Gleixner" <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
	"Dave Hansen" <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, "Jan Kara" <jack@suse.cz>,
	"Jonathan Corbet" <corbet@lwn.net>,
	"Shuah Khan" <skhan@linuxfoundation.org>
Message-ID: <19ea23f7926.45a052d5738848.4069075037120141318@linux.beauty>
In-Reply-To: <87fr31xdz3.fsf@mailhost.krisman.be>
References: <20260528095235.2491226-1-me@linux.beauty> <87fr31xdz3.fsf@mailhost.krisman.be>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A2DA540011
X-Stat-Signature: hnbdd15pue49oremwg1sgydqu7fxtwid
X-Rspam-User: 
X-HE-Tag: 1780838555-164909
X-HE-Meta: U2FsdGVkX18E2B1v0HoISdtdRmEwZ43AtbZpN4XD9L6ku0CUaRO8frLm4nso7RHlWqACFtVCOOs/Vpckj5IT2+wbt8RCx96f3dLei+hF+2FXhEkcZHewuM14X7sE/NzNAIG8QGLRZUsDpw9eAevxB6CjdumzuTCylb/vAsGb/Vej0TPJCcDN4qGT4qjN6WRf+ZTyxfh2QTsRS4o34gbUEoK/E9ph+XeWj+JQunzF4XLT7eP3UklIr3WNi+n9rbVCpE+nsa/aKvLgWGWNrCK5yicpGw9WufbZSkAOXYPSIbefR+3BQ4Z4dNwrFI9BqUjHnZCxR7kZu2JkoHD3gu1bkPBJ5FLm+ssDyoDt4fqV+rOtla7Lcg2pVpGUlbBY0V82BG2AZTJvuNGzh72lm2fcITtv69D4n3PKKbpl5x2XyKReOhRYhFgP6hc+0l+WYvmPQZI615fYzlyTIS5FRQlFFRtU7t7XtrTZ53V0EEBtM7o2xIo2PXsCvEm9V/6OiLsx5Vu3IWxjsuaHsP/6ClrgT3K0GayxnRxITdjft6GWw5uSPl7p36EocJzMfc4Em+K6lYbftLapfNAsF0DJ12pqp44c4rONpwCyBiZz3uPJm95DyVEgUl+Z6GEpPjlXVQvdB56D9Hi7S7xTIozoNuU8DcugZA82T/5r2mXqaWpYQsUzZl/AjPU3yVpjCbVxlQodk4zgx78FnzWpnkKKgH+dWw1ezkD4CwDlovqdIr+tQkqs+Z+pz42uCSlK26EgKXk6NQCpy7mzmi2cO20uUQ0WpMaLDfQ7x15ieayMp7DFZ/RCKDvSuT3IlUV15b/IabHSG6b96a3tX1UB79m9HKMj5i0mNb6RKwsHvM7DcC8QN+yARBfUTylSDtfUY6E7/TSbAJtFzmqiIIqohB4KSDR6sbCzipljlXXWuDIFH0ILrOTwPAi8BGeyg4ZM4oyTk8YLGfO6su44+lsRgHn0sfs
 7ANq0JeH
 AEMIo2eQOKMlV1oBP6aTPE1Wj4NXO5TAUSy5MChMZyxw24OFYb0uOiGH/UXZFm3nyJsTWgG3lJ06o5J238HX6yGLPVFvDNLHGmhqpNDngSuAQJ9XNtOCf8OW/bbbFTOJrLl3z8fbe3/Vx2rZW8nbhCWlQbfdVid+l/vyTQKxpIOBBbYo+f9nGIr8TQywq//zpkJ+LurbJn32jv752QNytR260vf4dv40rhL92kUkowRlVHdZIBhs3vVhs5wxHtFQ/aC2vWTzPLIwpSRcXIBKNehugjLUvshKJQu0hQ8EwFbipjBOpdHeRifSKbJxsYe8oEC2Z9+fAFezZk/qra337x0RELp+PQRcSeduuP/EiWVinjGiPHHY2ib6WVl7yTBEYomKlB9gPtnC1e9Zvda6OLWXdeP/RzrWq81FzQgZvHoMAG004zlSTu92ZYxaQCWCMDy8K3WHHFA/ueHs8ivg22+WdQHkJATkKZVoIWozd7deKg8W2MfVPP9W5m6TNTpv3Wo5MCsOI9YhPDsldP0MzCVWhyr3Nt+otF9xk26bTJMCrr4Zo7JXJZSyTO1gNS6Wzb2NWxUt2c0C282buIJn7iH8ML3EPNt3UG7nf0HdBkEhZwLnnZMgrDKuS8LDqT7Z485q2JDV9M3FE2ZO5woJyeFzeYHNACQYJrXNl2xz8fhejoHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Gabriel,

Yes, I looked at Josh's slides and your RFC a few days ago.

I agree that io_uring is a very interesting direction, and I can see why it
fits the "ordered setup operations before exec" model.

My current preference is still to first explore a pidfd/pidfs-based builder=
,
modeled roughly like fsconfig(). Process creation feels like a core process
lifecycle API, and I think a normal fd-based syscall interface may be easie=
r
for libc, language runtimes, shells,and sandboxing tools to adopt.

My hesitation is practical rather than conceptual.Some important
deployments still disable io_uring entirely; Docker's default seccomp
profile blocks the io_uring syscalls, and Google has disabled or restricted
io_uring in ChromeOS, Android app processes, and production servers.

I will study your io_uring work more carefully and compare the two directio=
ns.
One possible outcome is that io_uring can drive/share the same builder obje=
ct later;
I do not know that yet.

Thanks for pointing this out.

 ---- On Fri, 05 Jun 2026 22:24:00 +0800  Gabriel Krisman Bertazi <krisman@=
suse.de> wrote ---=20
 > Li Chen <me@linux.beauty> writes:
 >=20
 > > Hi,
 > >
 > > This is an early RFC for an idea that is probably still rough in both =
the
 > > UAPI and implementation details. Sorry for the rough edges; I am sendi=
ng
 > > it now to check whether this direction is worth pursuing and to get
 > > feedback on the kernel/userspace boundary.
 > >
 > > The series is based on linux-next version 20260518.
 > >
 > > This RFC adds spawn_template, a userspace-controlled exec acceleration
 > > mechanism for runtimes that repeatedly start the same executable with
 > > different argv, envp, and per-spawn file descriptor setup.
 >=20
 > Have you looked at Josh's proposal to do this over io_uring [1] and my
 > implementation of it at [2]?  I think io_uring is a very natural
 > interface for something like this, it will avoid adding a larger API,
 > since you could, in theory, set up the entire new task context using
 > regular io_uring operations in an io workqueue and then starting it woul=
d
 > be a matter of forking the pre-configured io thread with a new io_uring
 > operation.
 >=20
 > [1]
 > https://lpc.events/event/16/contributions/1213/attachments/1012/1945/io-=
uring-spawn.pdf
 > [2] https://lwn.net/Articles/1001622/
 >=20
 > >
 > > The main target is agent runtimes. Modern coding agents repeatedly sta=
rt
 > > short-lived helper tools such as rg, git, sed, awk, python, node, and
 > > shell wrappers while they inspect and edit a workspace. Those runtimes
 > > already know which tools are hot, and they are also the right place to
 > > decide policy. The kernel does not choose names such as rg, git, or se=
d.
 > > Userspace opts in by creating a template fd for one executable, then u=
ses
 > > that fd for later spawns. Launchers, shells, and build systems have a
 > > similar repeated-startup shape and could use the same primitive, but t=
he
 > > agent runtime case is the main motivation for this RFC.
 > >
 > > The mechanism applies to the executable that userspace asks the kernel=
 to
 > > start. If an agent runtime directly starts /usr/bin/rg, the rg executa=
ble
 > > is the template target. If the runtime starts /usr/bin/bash -c "rg ...=
 |
 > > head", the shell is the template target unless the shell itself opts i=
n
 > > when it starts rg and head. The kernel does not parse the shell comman=
d
 > > string or rewrite inner commands into template spawns. Userspace has t=
o
 > > call spawn_template for those inner commands explicitly:
 > >
 > >     direct exec                 shell wrapper
 > >     -----------                 -------------
 > >     agent                       agent
 > >       template("/usr/bin/rg")     template("/usr/bin/bash")
 > >       spawn rg argv              spawn bash -c "rg ... | head"
 > >
 > >     kernel target: rg          kernel target: bash
 > >     rg startup benefits        rg/head need shell opt-in
 > >
 > > Several agent runtime discussions are moving toward direct argv-style
 > > exec tools for both security and policy clarity. For example, opencode
 > > issue #2206 proposes an exec tool as a safer alternative to a shell-on=
ly
 > > bash tool:
 > >
 > > https://github.com/anomalyco/opencode/issues/2206
 > >
 > > spawn_template is meant to support both models. Direct exec users can
 > > cache the actual hot tool. Shell-wrapper users can cache the shell and
 > > still reduce shell startup cost. If a shell or an agent runtime later
 > > uses the same API for commands started inside a shell command, those
 > > inner tools can benefit too.
 > >
 > > Each spawn still goes through the normal exec path. The template reuse=
s
 > > only metadata that can be revalidated before use. Credential preparati=
on,
 > > permission checks, binary handler checks, secure-exec handling, and LS=
M
 > > hooks remain on the normal execve path.
 > >
 > > The UAPI has two operations. spawn_template_create() creates an
 > > anonymous-inode template fd from either an executable fd or an absolut=
e
 > > executable path. spawn_template_spawn() starts one child from that
 > > template, applies per-spawn fd, cwd, and signal actions, and returns b=
oth
 > > pid and pidfd.
 > >
 > > fd inheritance is deliberately conservative. By default, after the
 > > requested per-spawn actions have run, the child closes fds above stder=
r.
 > > An agent runtime can still request traditional inheritance explicitly,
 > > but helper tools do not inherit unrelated secret files or sockets by
 > > accident. The create-time actions fields are reserved and rejected in
 > > this RFC because fd numbers are per-process state, not stable reusable
 > > objects. The caller supplies fd actions for each spawn instead.
 > >
 > > A typical agent runtime would keep one template per hot executable and
 > > still build argv, envp, cwd, and pipe wiring for each tool call:
 > >
 > >     rg_tmpl =3D spawn_template_create("/usr/bin/rg");
 > >
 > >     for each search request:
 > >         out_r, out_w =3D pipe_cloexec();
 > >         err_r, err_w =3D pipe_cloexec();
 > >         actions =3D [
 > >             FCHDIR(worktree_fd),
 > >             DUP2(out_w, STDOUT_FILENO),
 > >             DUP2(err_w, STDERR_FILENO),
 > >         ];
 > >         child =3D spawn_template_spawn(rg_tmpl, rg_argv, envp, actions=
);
 > >         close(out_w);
 > >         close(err_w);
 > >         read out_r and err_r;
 > >         waitid(P_PIDFD, child.pidfd, ...);
 > >
 > > A shell-wrapper runtime would use the same shape with a template for
 > > /usr/bin/bash and argv such as ["/usr/bin/bash", "-c", command]. That
 > > reduces shell startup cost, but it does not cache rg or head inside th=
at
 > > command unless the shell also opts into spawn_template for commands it
 > > starts internally.
 > >
 > > The template pins the executable and denies writes to that file while =
the
 > > template fd is alive, so cached executable metadata cannot race with a
 > > writer changing the same inode. This means direct in-place writes to t=
he
 > > executable can fail while a runtime keeps a template open. It does not
 > > block the common package-manager update pattern where a new inode is
 > > written and then atomically renamed over the old path. In that case th=
e
 > > old path-created template becomes stale, spawn_template_spawn() reject=
s
 > > it with ESTALE, and the runtime should close and recreate the template
 > > for the new executable.
 > >
 > >     in-place write              package-manager update
 > >     --------------              ----------------------
 > >     template pins old inode     write new inode
 > >     write(old inode) denied     rename(new, "/usr/bin/rg")
 > >
 > >     cached metadata safe        old template sees path mismatch
 > >                                 spawn_template_spawn() =3D -ESTALE
 > >                                 recreate template for new inode
 > >
 > > Each spawn revalidates executable identity before cached metadata is
 > > used. Path-created templates only accept absolute paths: a relative pa=
th
 > > such as ./tool depends on cwd, and the same string can name a differen=
t
 > > file after chdir. For an absolute path template, each spawn reopens th=
e
 > > path and checks that it still resolves to the executable recorded when
 > > the template was created. If the path now names a replaced file, the
 > > template is stale and userspace should close and recreate it.
 > >
 > > A template fd can be passed over SCM_RIGHTS like any other fd, but thi=
s
 > > RFC does not treat that as delegation. spawn_template_spawn() only wor=
ks
 > > while the caller still has the same struct cred object that created th=
e
 > > template. If another task, or the same task after a credential change,
 > > receives the fd, spawn fails instead of running the executable using t=
he
 > > creator's launch authority:
 > >
 > >     ordinary fd                         spawn_template fd
 > >     -----------                         -----------------
 > >     A: open log                         A: create rg template
 > >     A -> B: SCM_RIGHTS(fd)              A -> B: SCM_RIGHTS(tfd)
 > >
 > >     B: read(fd) =3D ok                    B: spawn(tfd) =3D -EACCES
 > >                                         B: create own rg template
 > >                                         B: spawn(own_tfd) =3D ok
 > >
 > >     open-file use is delegated          spawn authority is not delegat=
ed
 > >
 > > The cached state is intentionally small. The template fd keeps the ope=
ned
 > > main executable file, an optional absolute path string, the creator
 > > credential pointer, and the deny-write state. The executable identity =
key
 > > records device, inode, size, mode, owner, ctime, and mtime, and is
 > > rechecked before cached metadata is used. The ELF cache keeps only the
 > > main executable's ELF header, program header table, and program header
 > > count.
 > >
 > >     cached in this RFC          not cached in this RFC
 > >     ------------------          ----------------------
 > >     opened main executable      PT_INTERP metadata
 > >     executable identity key     shared-library graph
 > >     main ELF header             VMA layout metadata
 > >     main ELF program headers    cross-process metadata sharing
 > >     creator cred pointer
 > >     deny-write state
 > >
 > > This RFC does not cache ELF interpreter metadata, shared-library
 > > dependency state, or derived mapping-layout state. Shared-library
 > > resolution is dynamic linker policy and depends on LD_LIBRARY_PATH,
 > > RPATH, RUNPATH, /etc/ld.so.cache, mount namespaces, and secure-exec
 > > state. It also does not share cached executable metadata between templ=
ate
 > > fds created by different processes. Each template owns its small cache=
d
 > > metadata object in this RFC.
 > >
 > > Performance
 > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 > >
 > > The numbers below come from my separate local autogen-bench project.
 > > autogen-bench uses AutoGen [1] Core as the agent harness: RoutedAgent
 > > instances run under SingleThreadedAgentRuntime, and RPC-style dispatch
 > > fans out concurrent tool-call requests to worker agents. The workload
 > > definitions, generated test files, and subprocess/spawn_template backe=
nds
 > > are local to autogen-bench.
 > >
 > > The agent-tools preset includes direct tool calls and shell-wrapper fo=
rms
 > > for:
 > >
 > > rg, grep, sed, awk, cat, head, tail, find, stat, ls, git-status, git-d=
iff,
 > > python-small, node-small, sh-c, and bash-c.
 > >
 > > The benchmark is launch-heavy but not no-op: it searches generated
 > > Python-like source files, reads sample files, runs small Python and
 > > Node.js programs, and runs git status and git diff in a small reposito=
ry.
 > > It does not include model inference or long-running tool work, so the
 > > numbers mainly describe the short-tool regime.
 > >
 > > The subprocess column starts each tool call through the existing
 > > userspace launch path. The spawn_template column creates templates for
 > > hot executables and uses spawn_template_spawn() for later calls.
 > >
 > > Total in-flight tool calls stay at 16; only the worker-process split
 > > changes. For example, 4x4 means 4 worker processes with 4 in-flight to=
ol
 > > calls each. The two time_s values are subprocess/spawn_template wall
 > > times.
 > >
 > > Workload     Calls  subprocess  spawn_template  time_s       Delta
 > > (workers)    calls  calls/s     calls/s         seconds
 > > 1x16         6144      411.04          420.32   14.95/14.62  +2.26%
 > > 2x8          6144      666.78          690.08    9.21/8.90   +3.49%
 > > 4x4          6144      955.61         1003.25    6.43/6.12   +4.99%
 > > 8x2          6144     1048.25         1069.18    5.86/5.75   +2.00%
 > >
 > > The table measures the whole mixed workload, including both process
 > > startup and the short tool work done after exec. Since this workload i=
s
 > > launch-heavy, the possible launch-side savings include:
 > >
 > > - the template fd keeps an opened executable, avoiding repeated ordina=
ry
 > >   open/path setup for that executable;
 > > - the kernel can reuse cached main-executable ELF header and program
 > >   header metadata after revalidation;
 > > - the fork-and-exec-style launch is submitted as one
 > >   spawn_template_spawn() operation;
 > > - fd, cwd, and signal actions run in the child kernel path instead of
 > >   being driven one syscall at a time by userspace child glue;
 > > - pid and pidfd are returned by the same operation, reducing some
 > >   runtime-side bookkeeping.
 > >
 > > In local experiments before this RFC, I also tried caching ELF
 > > interpreter metadata and derived ELF mapping-layout metadata. A focuse=
d
 > > repeated-exec benchmark did not show a stable standalone throughput ga=
in
 > > for those two optimizations, so this RFC leaves them out and keeps onl=
y
 > > the main executable metadata cache.
 > >
 > > I also tried sharing main-executable ELF metadata across template fds
 > > created by different processes for the same executable identity. That =
can
 > > reduce duplicated metadata memory when many agent worker processes cre=
ate
 > > their own templates for /usr/bin/rg, /usr/bin/git, and similar tools, =
but
 > > it did not show a stable throughput win in local multi-agent tests. It
 > > also adds cache keying, lifetime, invalidation, credential, and namesp=
ace
 > > questions to the RFC. This version therefore keeps per-template metada=
ta
 > > ownership and leaves cross-process sharing out.
 > >
 > > Sorry again for the rough edges in this RFC. I would appreciate feedba=
ck
 > > on whether this direction is useful and what the right API boundary
 > > should be.
 > >
 > > Thanks,
 > > Li
 > >
 > > [1]: https://github.com/microsoft/autogen
 > >
 > > Li Chen (13):
 > >   exec: factor argument setup out of do_execveat_common()
 > >   exec: add an internal helper for opened executables
 > >   file: expose helpers for in-kernel fd actions
 > >   exec: add spawn template UAPI definitions
 > >   exec: add spawn template file descriptors
 > >   exec: add spawn_template_spawn()
 > >   exec: validate spawn template executable identity
 > >   binfmt_elf: cache ELF metadata for spawn templates
 > >   Documentation: describe spawn templates
 > >   exec: require absolute paths for path-created templates
 > >   exec: let close-range actions target the max fd
 > >   syscalls: add generic spawn template entries
 > >   selftests/exec: cover spawn template basics
 > >
 > >  Documentation/userspace-api/index.rst         |   1 +
 > >  .../userspace-api/spawn_template.rst          | 153 +++
 > >  MAINTAINERS                                   |   6 +
 > >  arch/x86/entry/syscalls/syscall_64.tbl        |   3 +-
 > >  fs/Makefile                                   |   2 +-
 > >  fs/binfmt_elf.c                               | 104 +-
 > >  fs/exec.c                                     | 162 ++-
 > >  fs/file.c                                     |  11 +-
 > >  fs/spawn_template.c                           | 619 +++++++++++
 > >  include/linux/binfmts.h                       |  10 +
 > >  include/linux/fdtable.h                       |   2 +
 > >  include/linux/spawn_template.h                |  72 ++
 > >  include/linux/syscalls.h                      |   7 +
 > >  include/uapi/asm-generic/unistd.h             |   7 +-
 > >  include/uapi/linux/spawn_template.h           |  62 ++
 > >  scripts/syscall.tbl                           |   2 +
 > >  tools/testing/selftests/exec/Makefile         |   1 +
 > >  tools/testing/selftests/exec/spawn_template.c | 997 +++++++++++++++++=
+
 > >  18 files changed, 2179 insertions(+), 42 deletions(-)
 > >  create mode 100644 Documentation/userspace-api/spawn_template.rst
 > >  create mode 100644 fs/spawn_template.c
 > >  create mode 100644 include/linux/spawn_template.h
 > >  create mode 100644 include/uapi/linux/spawn_template.h
 > >  create mode 100644 tools/testing/selftests/exec/spawn_template.c
 >=20
 > --=20
 > Gabriel Krisman Bertazi
 >=20

Regards,
Li=E2=80=8B


