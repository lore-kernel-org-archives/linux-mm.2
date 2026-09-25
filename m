Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0684C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 15:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE59D6B008A; Fri, 25 Sep 2026 11:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A96C36B008C; Fri, 25 Sep 2026 11:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC136B0092; Fri, 25 Sep 2026 11:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7419F6B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:12:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15130A6D02
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:12:25 +0000 (UTC)
X-FDA: 85252625850.11.F2A4010
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6885C40010
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:12:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BAhy/v8T";
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790349143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c5yS4K3YB4cbDqechSUZ/Ihi+uzGED0jeEp/TnJEBhA=;
	b=XNjDyAzTsutHSUifX51O4NeEBqeNg+wqwEtGDqQEcNl1ptJj3T63Ge9xs2u2C/Wc3zLf3r
	vg99Ug0a1UdWbBT4tENqe7JUHv5YiWNIGl+jkD/bvJq1ZeZQ/SDFXmYPqEdyySiZHns7f0
	T8pUl9xxeYivEQYmlD2e/BpeWDK3Kos=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BAhy/v8T";
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790349143;
	b=XFI/wYn1ZkTuQb0jnSEhTkWd8cYA4ArOL9uB6tZS7PAyzMKgBYjw2d7t3npUnsc73ZIk+3
	xH9auvv12bg2ndTrCMnG1joRkKT4S/rSW90p4wHzqtOFgBK8T2njKdOshK1V8FWm99XNj+
	5Y8d5mj7FQscMvEoSFqID9F/NVY4ZMo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E803660136;
	Fri, 25 Sep 2026 15:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6DD1F000FF;
	Fri, 25 Sep 2026 15:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790349141;
	bh=c5yS4K3YB4cbDqechSUZ/Ihi+uzGED0jeEp/TnJEBhA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BAhy/v8TxG6BFYuCpIAX+zhkeekEHZwQXxuuF9RW92bIf3O/Be8NmqqdEryfJWALg
	 U/D9uKVRaM8f3sG74RyDOjAda0blaOWoy7xbb/potO1QU2j1USwNVqlH9++InDJfTi
	 OQooqgeolp/H7pt+snwrdA3psFqDp1p1jH1q/8+fl2CmKEJacXTOHI4UuvnEHcwWaS
	 9atvlZX1qGtA6vt4u7uCDpOt88XcpdJcfljswhb+S7Pqbdgpmg6HXAfTUgkvzuz14F
	 J1F0aD/9ILLkNRnzjRGWsCjD3sAVn06mCxk0/Lm5hVsE0LcCBGMCS0ivJqjT9unVI5
	 mXlhb7B3qE4+g==
Date: Fri, 25 Sep 2026 17:12:11 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Chen Linxuan <me@black-desk.cn>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Georgia Garcia <georgia.garcia@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v2 0/3] pidfd: add task path ioctls
Message-ID: <20260925-gewischt-auftrag-tierzucht-c153cb3f9f74@brauner>
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
 <20260831-tauwetter-werkbank-dramen-b37eb4025283@brauner>
 <CAC1kPDMK_D4nhyRmBHg6KC7SmmCkH73Xtc5DhXeJbSvf3LcqcQ@mail.gmail.com>
 <CAG48ez1T5-tUHVK_iHsgUtWa-inVdrZxA3E-ZCW0iENJvasKfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez1T5-tUHVK_iHsgUtWa-inVdrZxA3E-ZCW0iENJvasKfg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6885C40010
X-Stat-Signature: b3jumcrfqkh43kad849d8tx1e58ryyom
X-HE-Tag: 1790349143-973224
X-HE-Meta: U2FsdGVkX19caShvg/bjReL0IQGlmPxJjTf277+9A34KWeWRjg1cF5uj+cLVKlNCoTlUtVb2l6OQhgFEN3zSLEK2m2SvaqyAyq1TXk/yHZ4/AHgSV5hKKgO6jZamPaNZiJ0DoWwMGDhNMWq23jh3bZ7oYTzxqBjazL2eF6NLbT7Gs6A7c3D20ruB02fUN46wVwFCkNTsbUJryeDFODUHana8qlt5XKL6oTOfwUo+qgdZuiZFdk9QxUFaNsPnPz1QjJX85PlXbuxlZg/HAx50n3sNKsPC/Ylt7iB+2It6d376Zp/2K9R4UEOo7KXSZKS2s6yw7YB3eQGSGqmBreclJtfJb23p7BQqIkXD0ctpkMRYF1PUeO/Gm2P5IMraf2z6Y0dHMcv+82M4y8gRei7QD2dHI/G5/POWLkyNClJ7ePB7Mpts9bofiR7Qn1gNxczAxcZmTxPuv8MkI14Mp+Yz27Fw1ZAv7M4RdvImHk7CFP44NIhPPsWAXCBaBqPJwB/3ZVBH/VVqLcuy4R3UP6tcQPHie+WhXEl8SXILefr9XOLzqKILcmYmikOQBoj/4SIJtn2ohwOf9UnZqUYtVdFx2ddaebWV8Fr9cCycs/dBtjKZRY+X46D74w+70FrHuI79q2uVBTnGJrw7DOvS+N3y3NKmCFxEbS6+3uBylVOGYysi0GOEFceNAOL4WXQ6hOT/sCnMupQY2JJcP2RmAk/AuNt/sFcrEJ7iml2jdw4xKDqtQaPwbjanhf38+/ox0lPpJaBAE+e4Bk3bokV3HpHbfLHbp/RoKcEiXJ6YT/nNuj93WKF6FKBdgT9FqDO4QJQFIPP7814p4gjKmBfxTXodlrOR2YYTXfQ91NbO7FVkINfC2VduV+qJetaVbdO2j/gMhaWiMNdgHn1Fso8txm3Uk47qSLRzxSX7KAQis5Imm/PbemTVUtv0K5Zypam5lo1MObl+fFpfhMpJNrEpNID
 ZCCCqAs3
 R4k5q599y4h6SQAyMHsZQGUh0wgQmFSFdYoEnLbWcNXTaSElcS0t0keYsFlG5eFSocFE5UVOxrL+xBBpRmVeEUAucrlK+Vk5UDstVZnQjsQL6HjeYOhYqJgMim9vKKwVmPUQ/pyasVy0F0spO9gekShDcyFL+AAM9AGPb5UqvDKd0oIjbv5hPRon8aPj9yQGqsDLMDJ7VqDstjjBonTGSQRrvGM+eJatAFE5ae+Knj+u4HN0bRZWWBKTAX0gBnGPfC2mmxKvAwpPS3qLsiDD6ZTURuSCHC+AaVpxYEmfxGeMTzWS6rM58YIPAuVNnr25VcQeOOlt7yx0TzUvQcBmMb3OOfkSNmAcYS0mSPvClpeEJ45avxcLBI4w20C/32g4PNMr0BJ34pvXDap4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 10:22:11PM +0200, Jann Horn wrote:
> On Wed, Sep 2, 2026 at 8:47 AM Chen Linxuan <me@black-desk.cn> wrote:
> > On Mon, Aug 31, 2026 at 4:49 PM Christian Brauner <brauner@kernel.org> wrote:
> > > On 2026-08-31 10:59 +0800, Chen Linxuan wrote:
> > > > Obtaining a target task's executable, working directory, or root
> > > > currently requires walking procfs symlinks such as /proc/<pid>/exe,
> > > > /proc/<pid>/cwd, and /proc/<pid>/root.  That makes the operation depend
> > > > on procfs being mounted and visible to the caller, even when it already
> > > > holds a pidfd for the target.
> > > >
> > > > This series adds PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT. Each
> > > > ioctl takes no argument and returns a close-on-exec O_PATH file
> > > > descriptor referencing the corresponding task path.  The new ioctls use
> > > > the same ptrace permission check and nonzero-argument rejection as the
> > > > existing pidfd namespace ioctls.
> > > >
> > > > The target task is sampled while holding its exec_update_lock. This
> > > > keeps the access decision and the task-state read in the same exec
> > > > critical section, preventing a concurrent execve() from changing the
> > > > credentials or target state between the check and the use.
> > > >
> > > > The first patch factors out helpers for acquiring referenced task paths
> > > > and reuses them in procfs and AppArmor.  The second patch introduces
> > > > scoped cleanup for privileged pidfd task access and separates namespace
> > > > lookup from namespace fd creation.  The final patch uses these pieces to
> > > > implement the three new ioctls.
> > > >
> > > > Signed-off-by: Chen Linxuan <me@black-desk.cn>
> > > > ---
> > >
> > > I really have difficulties forming an opinion on this. So this sounds
> > > very useful but it has implications.
> > >
> > > Right now, pidfd ioctls are available even in situations where the task
> > > in question would not be accessible via procfs, e.g., when procfs is
> > > mounted with "hidepid" options or similar. So this would expand the
> >
> > One point regarding hidepid: for callers that can pass
> > PTRACE_MODE_READ_FSCREDS, hidepid does not provide an additional
> > restriction. With hidepid=1 or hidepid=2, has_pid_permissions() falls
> > back to ptrace_may_access(..., PTRACE_MODE_READ_FSCREDS), and
> > hidepid=ptraceable uses that check directly. In addition, the
> > /proc/<pid>/{exe,cwd,root} links independently perform the same
> > PTRACE_MODE_READ_FSCREDS check in call_proc_get_link(), regardless of
> > the hidepid mode.
> >
> > So for these specific path lookups, hidepid does not block a caller who
> > would already pass the check used by the proposed pidfd ioctls.
> 
> Agreed, I think with regards to hidepid there should be no issue here.
> 
> If I try to come up with scenarios in which this could introduce
> additional danger, the main one I can think of would be: A task T1 is
> running inside a pid namespace and has a unix domain socket connection
> to a task T2 outside the namespace, with both running as the same
> EUID; T1 sets SO_PASSPIDFD on its socket to obtain a pidfd pointing to
> T2 on the next message sent by T2, then T1 uses that to get access to
> the mount namespace of T2.
> 
> Christian, is there some mechanism that already protects against using
> something like SO_PASSPIDFD to get a pidfd to a process in a parent
> namespace?
> Otherwise, should we add something like a "pid_vnr(pid) != 0" check
> either in these new operations or in SO_PASSPIDFD?

Right now we don't place any hierarchical restrictions on SO_PASSPIDFD
or SO_PEERPIDFD at all and this is in use by varlink iirc.

What about requiring pid_vnr(pid != 0 for any operations that grant
access to additional resources. IOW, make the icotl for any ns
descriptor or cwd/root fail if the caller is outside the pidns
hierarchy?

