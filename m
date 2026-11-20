Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72D5A606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nFvAWVF4
Received: by kanga.kvack.org (Postfix)
	id 8889A6B05B8; Fri, 20 Nov 2026 05:24:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85F146B05B9; Fri, 20 Nov 2026 05:24:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726E66B05BA; Fri, 20 Nov 2026 05:24:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 460586B05B8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:24:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B9E771C486B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:24:34 +0000 (UTC)
X-FDA: 85455113268.19.0C53001
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1D62740002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:24:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nFvAWVF4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170273;
	b=DHR5Ci1uDr5qwH7/uZMjOrE0f25NqcE/0gaN+sKcX+SziMa6fJYNoJK3cqqfZdQBcuvfQT
	mP9TgXX6ZJo9KVRsZQjAGwjGygsAEl01tmnrC+oUXctwNQUINKaJlG9wK9xcBLuSEiZeEJ
	beFQLsLKSZ7OTPXVg2sEFb7/rkgEYxM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qNbHXGTNMLkg4zeH+TBnXHN+GFSzA5rFIxrp9YgCBoY=;
	b=nXGFcc7XWY6ESsnj28KMlU/xaJPqMcxdl6EHH6z7f5wSFqZmnDXJk0FpzD+0vOfRXmB9wh
	qS0VvySHPXEK1sXEAi8tngC9h4SZTvwVyxeJ51ZVJPLgZR6S/1CSx0dmy7OTMCKCs0svE8
	Ot8XoIo6gNPjQO+Gt8CsqBcuucCL6YI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nFvAWVF4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 6E5C9626C7;
	Fri, 20 Nov 2026 10:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 751731F000C4;
	Fri, 20 Nov 2026 10:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170272;
	bh=qNbHXGTNMLkg4zeH+TBnXHN+GFSzA5rFIxrp9YgCBoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nFvAWVF4Odb1RhPoYQyAGaD1llD8ahxydiIGjR1jelNSPSgIf5xjqkDTBfAjpXIGN
	 HMgOw7YokKejMzcXGcjsrExLH5iKsBGzTzT8kmQC7Q+ELR86L+96iltCT96Dyfj40V
	 JhiOaYe3t5rBBPSAjsQGbvjZShZ9o4hyP2abX4qDIMrY3ao+VFF9Kg1yNliPXKeUaV
	 PWfKIB+dxk5s2RQA6jVpo5hXvdf8uzEHHFO1zbIQJr76jtyCNlwvHbGxfKxSHi67gy
	 grRk1NX6j8MGwYTcMsKqtJk4JQyz2c/nq6Tstr4nUVMpqKwUzsYytvv2KugLAb8agk
	 zByiywEJOG23g==
Date: Fri, 20 Nov 2026 12:24:28 +0200
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
Subject: Re: [RFC PATCH v4 00/14] Namespace for namespace roots
Message-ID: <awAf3G6LxDJj_xYe@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
 <av_hbgzwo-1FcAPZ@kernel.org>
 <awAcpPQtM4hYHP-D@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awAcpPQtM4hYHP-D@kernel.org>
X-Rspamd-Queue-Id: 1D62740002
X-Stat-Signature: kq7piyaaesc347979g4ny7563nqxwgg1
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795170272-843363
X-HE-Meta: U2FsdGVkX19cvxrV8Ts2zAEXlQHI/32lYQLtNRLabLHuMvfehvI6mYx8W+gqTmBVHsyWD/yPSCqVzPco3M/LxrfF9BlzLHmQbwvHiNI4JM2jsljVfIQ4DkCsf5jbaVMh3+xDR8rvX7/5FAxlUWRY/yM02kMLbhuTBOOICqlr5DNZGIpQa3/tavj+1FnoK769PJBwxJbe8iOiZDWnErkAaaAttms+/wA/iqd0Aq2xpwpqicdHqMfhTwQGLe9Ukry4smKIcp7f2lHDs0jiENgJWq8TaGyfbMDSIsdju+s0FADH0Xixki2JFT+FSRSKPNwAUGqHOsDsmOpN8+OpAZEKuyINzXCIbnnEvtVo7IDOywqMiCTVv+ZmSC/dCBEP3irOF76HQvGHoVDukARW1vtDVDMZuTzqEdM57gIiMUTyY+jDNKH04SrrKqoGF6GnoBHR3wDh16r2A3ggAqHNF+nJbgkcyXMQoc2lPJOBuCOz7F/IwXF1BFRAYYGJZ3LSGenZtSMTfhWgMe6iXvh4MeRw90Z8nQGUsuGFTYI73X518THN6qKxWO2nNfup27PLgkBGoj6I5huduDswYOtGp0py9r8u4hCSaxh1OEYHe9hNP23JUw2TZ/uhxloAD99bPYK8wjRf/bc1EEMHw6Xtb0qZskqtCysN4QqUlg7mNiMsGS/gbM0RWUhMEI5gjntpU7a1Z0cBIQssluMPHZhGVdq619Lrm+alvtZlPcwhmX9Wx+YovuFD/xT1zeuWSVSJFg0OjlZLzBRoLaunbLT7DtjrMbHm+U5OMW1FoD0gjQgwEmL2fBlJUAVpPxJRvg+qLp3vWHFudrti3wnHPDEUKbCqK2bspHJ/E9U78RkjeNPZC13PaP397vNXClzjcc1OYplfUhVI2gQwygVWIXdwEg0nFalXcFLr3VUc0/H8Fa/23enEXKTrKTW0ei+DlDtVHyreTJQT25IIGPuvd5AAvsh
 VCI4NwTS
 ljRgjCtu0wdi+AFpN3u2MN2iOrYyYMkAHRGeb1DsHid/gPgxGJOKBnndkwTSDHtElzcPDi5ajlcW8cZq87qcT/RQdIDc4hlcJmqMeTrDtaoc7NZhzpRO9+mmRIVTRy7jsd/GJBSFIirgricmUF2lFIT4vwZNnbtRZJrZAaGwQYhkSAjwUDM/neR32aHOSPMkD5UuwbI7reMSpIwvrEPQUzcHHIWqQp30c3zjjDmuGrsXc+QeOjv3X9ZYGor3U4ybAAzsJPEvnduN322FcrcU7LtNDdxS0Czd6MP1EYs4ytnm3ZamjGnSUM8F425n9/TJxJ1N+V+beCObHGei6nU3CMjFW8iFZPDPkgByffds/laBAdHKi6dCoIUEJ9JBof28oLdWWt85P926zL/Jy906xILC0BCN6a1q15isnDIG17KhKWeTXTRMbEvTvtk0enLiYV8oB4OW5qLvm7ZKqBPCcLn4RR3fqz2l2C+IvApd2knHsajHqX7CfET6dxI//OiQVG0014BE9RZcplj8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 12:10:48PM +0200, Jarkko Sakkinen wrote:
> On Fri, Nov 20, 2026 at 07:58:10AM +0200, Jarkko Sakkinen wrote:
> > I've now re-sliced these into a bit more sane pieces:
> > 
> > $ git log --oneline master..
> > d8e24a6bc14e (HEAD -> rootns, origin/rootns) MAINTAINERS: Add entry for ROOT NAMESPACE
> > f2569e56a267 selftests/rootns: Add root namespace test suite
> > bea05e758f8e docs: Document root namespace uAPI
> > dd05a49aff77 arch: Wire up rootns() system call
> > 2dee7a5fddec bpf: Register rootns LSM hooks
> > 73c51e02b830 security: Add rootns LSM hooks
> > 3cfd6576a037 mount: Support MOVE_MOUNT_T_MNTNS in move_mount()
> > 9ed7387038ea ipc/mqueue: Implement ->set_rootns() fs_context operation
> > 624f0ed9c1c7 proc: Implement ->set_rootns() fs_context operation
> > 1085e6ae2eb3 fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
> > d2898dbdc39b fork: Support CLONE_INTO_ROOTNS in clone3()
> > 42dbccb5890e rootns: Add ROOTNS_KILL ioctl
> > 14cbda3e5bca rootns: Add ROOTNS_WAIT ioctl
> > b2cc82539b75 rootns: Add rootns() system call
> > d29215aa7f0f rootns: Track init lifecycle via copy_process() and pid_namespace
> > 0f9ce7febb49 rootns: Add core infrastructure for root namespaces
> > 7a0e8f969fc7 mount: Enforce mount_too_revealing() for foreign mntns
> > 8c61aee3afbf mount: Add mnt_ns_get_root()
> > 07d239d0287c userns: Factor out install_user_ns_cred()
> > bf74588e706d nsfs: Add nsproxy_open_namespace()
> > 645d31a1c516 nsproxy: Pass nsproxy to create_new_namespaces()
> 
> A "small" fact correction: rootns itself is not actually a namespace. It
> was at some point during the course of doing something over alonger time
> span :-)
> 
> I'll adjust the language and documentation.
> 
> It's like SGX enclave i.e., an isolated and opaque object with *nothing*
> at Epoch. Similarly as enclaves there's a build phase for building the
> memory environment, and a live phase that follows.
> 
> Those are the glasses that I've looked at the topic all the time; not
> so much with namespace glasses, as it's not my main beef and actually
> doing this has very little to do with namespaces and so much more on how
> you manage and control the threads and memory.
> 
> This is more like cross-cutting feature with no obvious subsystem
> ownership more than anything else.

I'll also move config ROOTNS out of being inside config NAMESPACES. That
is a relic from the past (just noticed).

Br, Jarkko


