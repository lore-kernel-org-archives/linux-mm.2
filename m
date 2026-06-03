Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5AB8CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE16C6B0092; Wed,  3 Jun 2026 09:40:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6AC36B0096; Wed,  3 Jun 2026 09:40:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D32AA6B0098; Wed,  3 Jun 2026 09:40:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BBA8B6B0092
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:40:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5ACA912031B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:40:45 +0000 (UTC)
X-FDA: 84838711650.13.AC97954
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C1E5E1A0003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:40:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c1ouCCeO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780494043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KGsTHKQ9mld7YxQe3rajH7wvD+M6DWrkXFM9QhfOh6M=;
	b=qpz1XzLed53rxkM9vUAG8MWakZIKebiyE+EYvZUmWgX4u4sPhrN/QoJ2LDCHhK/BZt6FBs
	YZ/7T0KEi9aCkt+ajs3lxuquSwIpFJ9mSeTmVJ6Xz8s2P+ismDj6ku/ZGiHm+Lbc81xHoH
	PPht1jDN/PLVz9v2DSxk2LrRGY8FEbc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c1ouCCeO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780494043;
	b=7IbUutwsX+R8Ri9YZFn/zcEBQLecgkIvP99N7eVTrlocisFn6HyGmLo7FIep1fIYSuEbTM
	8XIdQd36rd9UoTb6EVh+fstbnAIQ+bPauQQmb6AtogHRXSh2G2Dl8sFQoAN2OlElrvynQI
	DNBhQm5EzjVosxuecT/0ZDyUeSEtssE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4316B601DD;
	Wed,  3 Jun 2026 13:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4C61F00898;
	Wed,  3 Jun 2026 13:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780494043;
	bh=KGsTHKQ9mld7YxQe3rajH7wvD+M6DWrkXFM9QhfOh6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c1ouCCeOfGsSWLGNkvvoOa5gTYM0YWhQ2YWKcMokI4OUSVIQBt0LDWDEXGXgdOBhk
	 RcRyl93QyEJ9JLW5AoFWnCmqBcXY4cK06cakG8SwHN1xGxeQjB9bXeW0akqq75vk2P
	 s1CIE2PyGQkPbaRlS08LsLJsqwRjPSYYv9Co1tKaf2nz1vK6+dOTW+wW6ZJys66m7i
	 l/CfFgBOqWkhIpv51rSLKkHcHCfO99JTOGnqyq9fBQ5yu+2Nk4F/mwwgwhNKVUGHUE
	 NbEKOEm1HAbHTIt1WY4dqDDq5U04q5ORt1Vz6IqwcdFYPqakOw4Ejt1EIbx3TDx8mS
	 7EOkXsCAM9FvQ==
Date: Wed, 3 Jun 2026 15:40:36 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, 
	Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, david@kernel.org, 
	dhowells@redhat.com, hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	miklos@szeredi.hu, netdev@vger.kernel.org, patches@lists.linux.dev, 
	pfalcato@suse.de, viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260603-raumfahrt-unmerklich-ertrugen-c4ecae70d5f9@brauner>
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com>
 <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
 <20260603-navigieren-pleite-stilvoll-60e6da66b1d4@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260603-navigieren-pleite-stilvoll-60e6da66b1d4@brauner>
X-Rspamd-Queue-Id: C1E5E1A0003
X-Rspam-User: 
X-Stat-Signature: eqszjutbpur9wca99u1x5b48rs74bh7i
X-Rspamd-Server: rspam09
X-HE-Tag: 1780494043-226670
X-HE-Meta: U2FsdGVkX18NUQGCpqDPKj5oQ4aoHhTBwej/03oaIPXyvE6QNqbdKMvy0Zm2zsOc1h9ODTv9jfEtTTFgog2wMPVIAfC+nOYqr2ji9fpDpZcbbgoXyCMLceEXcdFJCbptLPVcLlX6Ql4IGcnXL6Wsme0MKL+2flTURkn7Cb3x8I3kzJ6xk3HaWUZyBLRZqBOkgvReeKFcM/W7Tf6LiFOs2F+RgkitjdUVLazCjKwD1Beu03z1s5q2TbOeqpGE1CqvS+40gqY36EmbgtYcc9C1X6OR03eih/AhjnZMIJbFDuIBPutGI3LEuFFGJeCJBRPEdnqVUdWRqsmZ/4ng7imOa7y7fRNbgEwVvgMYASMAss0bv4uF67K+2MOwMO/rzsGnjKdUWdqVNCn/FOI5ruYqAdnBUWtcLOtoK/R8E5kL7SDANweAzp3EACyjN1SkexGtXTsT4+IiyXlBdTzIHZFgrzh4rX/4a+7Yl3LtzNyOujtEo324de7g/z3ZZ0karwEMjIxsByuj49fwmscf5VYtqGPLoYZ9T2xgccxcuozdFSKvBWRZB4KSNXRQk5P40d6qOufYU1bID/picQQS7maFxwNrQeqASSqm1XlxGWEOjsayQIPIcf7yJgLfIBEDBjPuRORiMz3Edk2iYbN//0zZj2zwlUvrGQjpwAz9qcncNPIEMDJ9hrze9EWKRnSa2AZkveqI+ofgoVfAiuKYHA2XNh3D8kVuSEbQnqEhcAOBPbG/Yqb58Oj0N6QQtqLnJ7HZ9JFQX37ALzV53Sj0gkRBOd2DwtxaW2TBInpB9iuhv4kqnytgqj0woAOEGfMKtzfJLDFBPWiD1yjrFZeHhEeLSkf86sL1rmGN9bzC9UxnT90HbQTsypRHFX9l/N0iilhu8EcPnVNXzVmYC/TrgclirTJZj73weSAOwJVTeERQNcJReGD/8kX0Eqh+3OWXZvuwF9fQSQC0cKtdi43SFgd
 8Xdze296
 BlB+V3eOCwOmGzANT0pNZY+WOye8uudobR7iacmtdX6vUEShbe0dGHOOXQ9bRZLR58V6wbJfDVyg89kSx8pE5vU+9AF8cUAdmntZIA3HIlwD98aDeLuKg0qTPAlE32cvs+1qyBQv1QhlyublLvzrQJdI6O9njvfTr0vJIZjuVr4xY9DKonC781phlSKuoinbAaC1AcCZzs7JUfiTZOS/sktrCvk/Z4xamrGBP7kGcOP0A3/EtzArBzb6+c8CkHVXLNfOIsy6b4FaHL7AfBm3++TYIowC6poymdilHxOLCiU3FkwBju091qon8ge6boFBhdvWbJPNZa02OwyStVrd+cHE2HfncyMDkwQiaxYi7pHJqCew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 08:45:18AM +0200, Christian Brauner wrote:
> On Tue, Jun 02, 2026 at 09:20:13PM -0700, Linus Torvalds wrote:
> > On Tue, 2 Jun 2026 at 20:51, Andy Lutomirski <luto@amacapital.net> wrote:
> > >
> > > Am I understanding correctly that this will completely break zerocopy
> > > sendfile?
> > 
> > Very much, yes.
> > 
> > And it's worth making it very very clear that ABSOLUTELY NONE of the
> > recent big security bugs were in splice.
> > 
> > They were all in the networking and crypto code that just didn't deal
> > with shared data correctly.
> > 
> > So in that sense, it's a bit sad to discuss castrating splice.
> 
> Well, we're completely ignoring the fact that splice()'s locking and
> interactions with pipe_lock() are complete insanity. So unless someone
> sits down and really thinks about how to rework the locking I think
> degrading splice() is just fine.
> 
> > But it's probably still the right thing to at least try.
> 
> Yes.
> 
> > I just suspect we'll never get real answers without going the "let's
> > just see what happens" route...
> 
> Yes.

Reading this thread again I'm really amazed how willingly people argue
to remain locked into a really broken API even if they're giving a risk
but worthwhile chance to kill it for good. Anway, odd-userspace behavior
time:

David reported vmsplice01 failing in the LTP testsuite after the change:

11297 20:41:02.548383  <LAVA_SIGNAL_STARTTC vmsplice01>
11298 20:41:02.548518  tst_tmpdir.c:316: TINFO: Using /tmp/LTP_vmsZ13ZQj as tmpdir (tmpfs filesystem)
11299 20:41:02.548656  tst_test.c:2047: TINFO: LTP version: 20260130
11300 20:41:02.548793  tst_test.c:2050: TINFO: Tested kernel: 7.1.0-rc6-next-20260602 #1 SMP PREEMPT Tue Jun  2 18:13:29 UTC 2026 aarch64
11301 20:41:02.548932  tst_kconfig.c:88: TINFO: Parsing kernel config '/proc/config.gz'
11302 20:41:02.549069  tst_test.c:1875: TINFO: Overall timeout per run is 0h 01m 30s
11303 20:41:02.549205  tst_test.c:1632: TINFO: tmpfs is supported by the test
11304 20:41:02.549340  Test timeouted, sending SIGKILL!
11305 20:41:02.549477  tst_test.c:1947: TINFO: If you are running on slow machine, try exporting LTP_TIMEOUT_MUL > 1
11306 20:41:02.549614  tst_test.c:1949: TBROK: Test killed! (timeout?)
11307 20:41:02.549751  
11308 20:41:02.549887  Summary:
11309 20:41:02.550021  passed   0
11310 20:41:02.550155  failed   0
11311 20:41:02.550290  broken   1
11312 20:41:02.550450  skipped  0
11313 20:41:02.550582  warnings 0
11314 20:41:02.550710  
11315 20:41:02.550838  <LAVA_SIGNAL_ENDTC vmsplice01>

So I looked at the test:

	while (v.iov_len) {
		/*
		 * in a real app you'd be more clever with poll of course,
		 * here we are basically just blocking on output room and
		 * not using the free time for anything interesting.
		 */
		if (poll(&pfd, 1, -1) < 0)
			tst_brk(TBROK | TERRNO, "poll() failed");

		written = vmsplice(pipes[1], &v, 1, 0);
		if (written < 0) {
			tst_brk(TBROK | TERRNO, "vmsplice() failed");
		} else {
			if (written == 0) {
				break;
			} else {
				v.iov_base += written;
				v.iov_len -= written;
			}
		}

		SAFE_SPLICE(pipes[0], NULL, fd_out, &offset, written, 0);
		//printf("offset = %lld\n", (long long)offset);
	}

Prior to the change add_to_pipe() returns -EAGAIN the moment the pipe is
full. So iter_to_pipe stops and returns a partial count capped at pipe
capacity. For a 128K buffer over a 64K pipe the first call returns 64K,
the test drains it, call 2 returns the remaining 64K. Done.

After this change do_writev(... flags & SPLICE_F_NONBLOCK ? RWF_NOWAIT :
0) then calls pipe_write which does not stop when the pipe fills. It
blocks until the entire iovec is consumed.

I kinda think we need to preserve similar semantics.

