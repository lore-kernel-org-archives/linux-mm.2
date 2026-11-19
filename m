Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3852606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 06:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e7xa1Dpj
Received: by kanga.kvack.org (Postfix)
	id D02A86B05B3; Thu, 19 Nov 2026 01:21:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB4106B05B4; Thu, 19 Nov 2026 01:21:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C466B05B5; Thu, 19 Nov 2026 01:21:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B7F06B05B3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 01:21:34 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0915E140932
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:21:34 +0000 (UTC)
X-FDA: 85450872108.30.3CBCD78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4C863180002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:21:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e7xa1Dpj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795069292;
	b=D4pbRRBlO+nj787gY1NkHeHUtQp23Oi2uy0ELTPWmXlTKUiEeoQsGQInOivNvc9RxK0BHX
	TsrZfEg5t7McvPCTgUmvl857TGAW+gKKvfJumr3Wn5a54MALQY/6wR1eyKhrw3pJt16IBw
	OM3sItmbqWcbP9IMD9ugrEuDdy1YFjQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795069292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=btZ2TprQHQojMwnDwVX6xxEuU+pesarzzPhbHJEdoGg=;
	b=vSJXRHXBdWysloNhSsWOjEvj7ix7GA9rEwPci/t/ZBpwGzRLGOR4c3ks5kIKuWfgydcnev
	cFZLe6Fivl1xUxXfXtZCTTFiLVo2XsRf3jsLu+b7Yfwaw0iaaaIWmOj1Y1+ZCWJbfMFHqJ
	1EhgHNv2MHZaHy8gPbwqfyZiZEc5kak=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e7xa1Dpj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 75CB547936;
	Thu, 19 Nov 2026 06:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 99E921F000C4;
	Thu, 19 Nov 2026 06:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795069291;
	bh=btZ2TprQHQojMwnDwVX6xxEuU+pesarzzPhbHJEdoGg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e7xa1Dpj4IV+gGquktCuwkP8uLbLXtGks3wuXwt/tSMkOsmBjJ/0z/lSi6xpEE1if
	 M+ClMf07lAH8kSdnFi7nUiv7E1oRGPNtacMDB0C9ZyZ9nVvpOERjMX8QaAKZ7lKRn4
	 M1z2+y5hTJxFCzzBM0zcOMJWoXKpQIZjVMenn5ZU2BG85Fmxa/pgerSdcdz7kbKLdA
	 QCVfwXzNN8zWPDBlSNSXrmUbYCk3O1GsxodMLXYujCtnvsjSw4DQj4SWvGVet8sWJk
	 gjUyqjq21Sc89moWlZp69HUgI6J3icvNRaTO40aErPOsiyV3xe7t6GSDpp7+hZ+Auj
	 I9xdx3hVfOiUQ==
Date: Thu, 19 Nov 2026 08:21:27 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v3 00/13] Namespace for namespace roots
Message-ID: <av6VZ5NQG4GwYvPl@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
 <av4CdM-eW73oO4wB@kernel.org>
 <av4NonrcCxzMoDyz@kernel.org>
 <av5-Zc4xhgkPxb7p@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <av5-Zc4xhgkPxb7p@kernel.org>
X-Stat-Signature: c1u7y1yfsmdbz4n8ybe8pfkrpxwyuuj8
X-Rspam-User:
X-Rspamd-Queue-Id: 4C863180002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795069292-277784
X-HE-Meta: U2FsdGVkX19cjw7W/NiPWuX7tJ4xwzznqR2LkO20wJpFzs+3xugcl4MAhU6T4Xbew4R/IFY8xj92y8qMC0eu86WefAjd8q76jcxUUx22k6ffBkL2DFvwsAwttDwgp36yTJvYAue1+/NOX+PcA5ZqPMJgI0Ern9LWVivlQrigFL++/9mGUvnKrGGtqxzxQt2XNd6IubjDlbqizDCwDh5lqh88XOwxDI5u7y94hTwRC/zP2zj+GMtLcd69yZEj9qTvzw1tOed5h0zfChGRxlplmR5D90XknkQQ+1wd9SiuQrnaxtMq1s6B1iubl8/TtlJEm/K9Hvpv2lFJyygw0zjidtcKuuoBXMHiS9LrIXizkgiQL0w2BLgx5MKcqKdT9IfUNjdP1O0CMG1Lt8lbLqhHBp4l5jS1AEZqidK94FXY2jVAqj0E/htBPdwynrhltNqCYxKeRQ6oBCJt4SvKyOobjcp2z/tjoHa/ngNH9Vq6zMn4hwQBSYZ+8FTtkiBBwyjPZqM0bHipVl0QL0RvoBJHyHEePcHPFWy4FXYxJLGxzsLDyvBKo14qGXRebjU7rO04n7zfR92F+18N131ylba3rIrFZ3UQMyGK/fXaUdfypPjCsjYVtAABB/Uwx5OiaSfUvL4E4XDc8YQ5KqZJc1nA1/GuxEQskkEVnDCaVrd+jgBYb25XAbTh3z866e1vCqGZYaxeG3YQ4lq/FhhboCffzUq4YzCg87++h2QwIJb/dDLzGObeYZTb6426eQ+Yr70S/p6+LtHcBfnDEn3N6Ge/89jCajKQLIZFvwI38abFwtpwHAZDlM/MZZHzb9huC9/pnDHQ22ppAKjI85glGP28GioonVx14Qb8T6JyE7uB7egIe43qeZ1cqlb0qkAc5r/Euw0X5mVAw7AeGJltIRO0lDCnjP7ktEXffgTg0Z7nO6QJLzwz/XqumTcbsDNcTrSWIVvyI+s0aiEiri3ShR1
 bwYjFjGV
 7ZUB3TtJZPxJOVb6jNH3/HhvLKa6MeVoCpl7zWFXW0Sk4XUgqBzgc0WjTuhvCFTrbgVCFwpMeZeJn26Qze5uWvQpFSLcRLdzlCEhNwwNYSbXaQ45ks/RKt0wWTmpbEOgDmIa5z5fo+F5IH+2IRZ0DNQ8+2lh1HSAedaigg19pMy2wpRvqm0YJSwKNilDQh1FxMo+EBdv/+hCVTemy9BUd/iUyGv2S0ZWATxsplN1f3hpU5zutEcHhBIM9+yOwuaOeuQH5Gdipon+qmEv3VQNUk2rE13wclF8thZBRKYYRUx0iX1giIuKCM9vPEVE9QKDyQImKXYbrzxHwQTDbCQYgYW5oH2DQZTqj+fGj9bofolxJhcIHEsYsIy4nW8jBG2M4LxcA/u1gdigyjt4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 06:43:21AM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 18, 2026 at 10:42:10PM +0200, Jarkko Sakkinen wrote:
> > > I.e. before PID 1 and /proc/<pid>/ns/* existss, nsfd for namespace other
> > > than root nsfd can be acquired as follows:
> > > 
> > > 	int mnts_fd = ioctl(root_fd, ROOTNS_GET_NSFD, CLONE_NEWNS);
> > 
> > 
> > Unprivileged caller becomes the owner of rootns->user_ns. Each mount
> > syscall then just checks CAP_SYS_ADMIN against rootns->user_ns.
> > 
> > The user space wiring goes along the lines of:
> > 
> >         int root_fd = rootns_create(ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC);
> >         int mntns_fd = ioctl(root_fd, ROOTNS_GET_NSFD, CLONE_NEWNS);
> > 
> >         int tmpfs_fd = fsopen("tmpfs", 0);
> >         fsconfig(tmpfs_fd, FSCONFIG_SET_ROOTNS, NULL, NULL, root_fd);
> >         fsconfig(tmpfs_fd, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
> >         int rootfs_fd = fsmount(tmpfs_fd, 0, 0);
> > 
> >         move_mount(rootfs_fd, "", mntns_fd, "/", MOVE_MOUNT_F_EMPTY_PATH | MOVE_MOUNT_T_MNTNS);
> > 
> >         struct clone_args args = {
> >                 .flags  = CLONE_INTO_ROOTNS,
> >                 .rootns = root_fd,
> >         };
> >         pid_t pid = clone3(&args, sizeof(args));
> 
> 
> [BTW, this patch set is pointed out to David and not fsdevel mailing by a
>  mishap, apologies.]
> 
> I reduced syscalls can be further to only a single syscall: rootns()
> 
> The complete API after this:
> 
> 1. rootns(flags)
> 2. ioctl(rootfs_fd, ROOTNS_GET_NSFD, ns)
> 3. ioctl(rootfs_fd, ROOTNS_WAIT, NULL)
> 4. ioctl(rootfs_fd, ROOTNS_KILL, signum)
> 
> An updated version of the patch set is available over here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=rootns
> 
> In order to find more evidence that the API is trimmed and code has no
> extra fat, I tried how LSM hooks size-fit.
> 
> Attached are the experimental LSM hooks and while possibly not exactly
> right they should not be at least in the ballpar (Paul?).
> 
> Not perfect, but very usable, and there's a steady track of convergence
> where resolving a bottleneck leads into a better symmetry and coherency
> overall.

Orthogonally, solely fd-local security model (as all is tied to fd) is
the best thing ever when defining mandatory access control policies  as
the full flow can be meaningfully described; i.e. roonts(), sendmsg()
and other calls track the fd's data flow with almost the highest
achievable granularity.

Br, Jarkko

