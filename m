Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDEB3606A33B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 12:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DqoZLySG
Received: by kanga.kvack.org (Postfix)
	id D96EF6B05B1; Fri, 20 Nov 2026 07:47:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47B66B05B2; Fri, 20 Nov 2026 07:47:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C36406B05B3; Fri, 20 Nov 2026 07:47:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 928176B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:47:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1714C140E7F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:47:07 +0000 (UTC)
X-FDA: 85455472494.17.AA92F37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 644131A0006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:47:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DqoZLySG;
	spf=pass (imf19.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795178825;
	b=wsqV8WkgN5WpTRpucABblW+rLTprS/cOexjs/ibzhHZzNOTT1cbM07z9ZHb5t42W+r9dXI
	zsvvj3eksPErua6hIo3oNpNOPBThFR1wikvV0fL/VgsDKa77cxNji/P/dzmmDrqeQfBWAg
	goOG8KQuoztZ4UWyVMMp8xYJCjHmk78=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795178825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ulF/F82puM5FYsSJ0g59/1wc8Edn/NytcDM7FiJ8jc=;
	b=rUFd0ViKTljL0PHIkKP7fGIZU+eZ54X+KQk0cE2AXjvpgyB9eWmtHVfXWEENN8+V1uBY76
	O3076fVB32sPsDDy2oxTIVmpTgdYPQ+PY4k+4EynDDRGtJtJkqb6xm1JQHXzO1W5p+8+Fd
	O+FcnxNYHn5ssfcSIou+9/GsXdc7yPw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DqoZLySG;
	spf=pass (imf19.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 658A961D38;
	Fri, 20 Nov 2026 12:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1F3B61F01816;
	Fri, 20 Nov 2026 12:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795178823;
	bh=0ulF/F82puM5FYsSJ0g59/1wc8Edn/NytcDM7FiJ8jc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DqoZLySG6tbEny6oIUE/axFh/2wx4W5GHzOkvhTlgcaY4EZUTlRys71s81y3ij2s+
	 Rx6evb1/Oa+v4+RmHdPnlMI8p3/9Vk2Qlijco1EtXlIo6+Uox0MEXkH/j5p22LtJG8
	 O+pAzJgjaL1XHgOBkbBGKjTQJ9BhUBlib22F8c7LUzIeRP0B3hW1yyMckmXfB09V3/
	 pb0B13DLnURH0RN2WYu1RtEzVFvz+D8QM0Yu59J9hZtbKvXjbGvXTuwegQcAfBSTXZ
	 ryU1OkE2JtMJpTX6AEDJ3anQ8K5ylpOqcKArjol4ky4NYsELzEC9Sl23cE4WQ60q2T
	 OvpwQRIevpNOw==
Date: Fri, 20 Nov 2026 14:47:00 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Andy Lutomirski <luto@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>, Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Hallgrimur H. Gunnarsson" <halg@google.com>,
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
	Mel Gorman <mgorman@suse.de>, Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Moore <paul@paul-moore.com>, Paul Walmsley <pjw@kernel.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Rich Felker <dalias@libc.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Serge Hallyn <sergeh@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v4 07/14] fork: Support CLONE_INTO_ROOTNS in clone3()
Message-ID: <awBBRDaILtH11wgW@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
 <20261119224312.1037966-8-jarkko@kernel.org>
 <awAh8chFM-9WtNKP@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awAh8chFM-9WtNKP@kernel.org>
X-Stat-Signature: pgg1ffaqjmp7ogwz9owg4mn5iir7fasj
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 644131A0006
X-HE-Tag: 1795178825-562731
X-HE-Meta: U2FsdGVkX1/8BWrH6LWJ6+k4IEiXGarM7wQl0D4eGjSeK++32EPJwLz9pvUaQnBr5qg1qb+xzrDpmUAi5J+lZrGL6LIvHuVXZMqxbfc5tfVT50oyArJlwJKMSVisWTqlNoBfwIBDiJcVBP50EUHWoR2nTD628MBJstgomAW5IQIjK25rzPPiXSApArSOkDGsOT1AzZsinMQpvfpoHaWDXe2QIxo69nSHwAysb3klA4mj0Dc/Wjy2Xa1z1TKPAohuBicajVPOeE6EdS2Tg4zn2VtvK/hjZordHVlmTdfH5RlaDk4R3f/4PBJru8yXKojDEDf2n/EE/4UfRNrv3NaLgfdjZmVLnDa0GZVnCzN3efR0KC7K9CvI6mbAV7iY7lTGEpVSOlXbONjn3AnGKnZoMvl0y77Cs9937XF87x3S+OOKU3pamuVth7Y0n/sVb6lu+PX/RzrmGkFwGNkorpqKEgFZtFCz10PrMiLvT+HxTWJnJ78TN8jUn4v/Eq5IVyxIP4LSFhbiF+6Tbq+AYxgNzfDmSXSToOtj0zj8W/RWXxMjVwEIajIcJvTaEQ7be/3jytxFtlTnNbUHEJ35x1DtPyf/HSUAh8DTsIPxjzCvKLPUq2WydltYKoDxLSjdiaym+/mFqHh/dv0ntU82fNjs1pASyvwIcEj6gNhyDpgVpIbJ3kAVGT78lZ2eSUppQhy26miEJlwEJxGC40RhwSqQYUD1kI4d7CsaBB1pOaacmbtManKwgbTg9GFM0fKuZDyBqTKO58GKUj8YXtXYxTO/IY/oDtZ5yAjnbPMw+wVpow39D/U3m5FA/MbHZqUcmWaL5l0AZNDYeL3nbnAlFTvVKkzQZwldh33b0pnmqG7Hjg//LCGh+Tqrv+veP3F/0WS3jysF7xL6P7zDzDKnwEc8eK15bWAzSgTpcZlwm+JAuZuUsq/YScrgS4Pjmv0bKG2oVZONrlYdckmeMgF0tk7
 tHwRooU3
 PMhKKRbamSX/aSQGV/kDGh4MlJkAu+HUO6wRlrFjTnRoPEfVxm5xi1zOcu6b1p12fe8ii8uoI26gLp/TfS9cn3TX84cL2A3+X102WFOMBaulZW4FC+kJkwlXeXKFws0lbyGAOZNaVkS+Y9BKW5YnfGa9HGvL7TpLEd6XoR3gVZExkk+P74XbFny87i4VgeUK0iX6qRiDStsBTLGfcvP2GpfTXEnwyCwdMFS6cXvmbTuYkxE20jsakkDjeSHkwiH1uJa1q9lFskIYI26vybu1b4ue6aidDGs4V07EOcm3SaM6lkEwJyYvLWYuAJ6OwlMgtxJREWNhXMXwxNV+jFSZEW+rkiG2X1tDpitDPVCtyX7UhgTkW6sX8WmYDOr/WxV2kC2Z32XCAoZ4s8TTplwmacdU/dA2cM6W2nCqxJzcW6H0obc5BAFpNDwx4uzqT9Kv1e7pjSFT7sOxfl/2BzgZo6jkU2Ez+50aX4LoGikmnfadqjsI3hBOQh+7VNPNXXq0NNAnKrMicqHe5C+gNFpXDnHYkhtlFgoIuZ7aZFhH07M0zEmF1fbDbr0JTYKhpZxnwQLduWHGWDfZ6rEJfzR4vaY/3tcwj8QjZVpev
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 12:33:25PM +0200, Jarkko Sakkinen wrote:
> On Fri, Nov 20, 2026 at 12:43:05AM +0200, Jarkko Sakkinen wrote:
> > Multithreaded userspace daemons cannot call setns(CLONE_NEWUSER) or
> > safely mutate process-wide filesystem state in place before spawning a
> > child into a target namespace set.
> > 
> > Add CLONE_INTO_ROOTNS and struct clone_args.rootns (CLONE_ARGS_SIZE_VER3)
> > to spawn a child process directly into a rootns whose root mount has
> > been installed. Transition the rootns from ROOTNS_INIT through
> > ROOTNS_FORKING to ROOTNS_RUNNING for the first process so it becomes
> > PID 1, serialize concurrent entrants on waitq until bootstrap resolves,
> > and admit subsequent callers into the running PID namespace until
> > teardown begins.
> > 
> > Derive child credentials from current, require CAP_SYS_ADMIN and
> > CAP_SYS_CHROOT in the target user namespace and an ancestor active PID
> > namespace, preserve caller umask, reset dumpability across user namespace
> > transitions, commit time namespace vvar mappings after copy_process()
> > succeeds, and look up the live mount namespace root. Restrict companion
> > flags to CLONE_VFORK, CLONE_PIDFD, CLONE_PIDFD_AUTOKILL, CLONE_AUTOREAP,
> > CLONE_CLEAR_SIGHAND, CLONE_INTO_CGROUP, and CLONE_NNP.
> > 
> > Co-developed-by: David Howells <dhowells@redhat.com>
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> Being fd-bound object the gist is that the first clone3() binds
> cgroups, which could e.g., different process than who build the
> container.
> 
> CLONE_INTO_CGROUPS is of course available as an optional flag when
> using CLONE_INTO_ROOTNS.

The major benefit over Cells is that there is no embryonic task state
and nothing from the host mount table is inherited unless explicitly
moved in. Also, unshare() cannot ascend from the rootns() created
hierarchy.

Shooting yourself in the foot is an explicit and planned action taken.

And further, it has provably more defence in depth than Cells because
LSM hooks accurately populate the data crossings.

Br, Jarkko

