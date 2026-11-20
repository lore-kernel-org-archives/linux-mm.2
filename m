Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889AE606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MT90aUeJ
Received: by kanga.kvack.org (Postfix)
	id B57736B05B9; Fri, 20 Nov 2026 05:33:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2EFE6B05C2; Fri, 20 Nov 2026 05:33:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1DA86B05C7; Fri, 20 Nov 2026 05:33:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7EA486B05B9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:33:28 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B63E120E68
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:33:28 +0000 (UTC)
X-FDA: 85455135696.26.78B88F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4F8D81C0003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:33:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MT90aUeJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170806;
	b=LM/5wpSuVDZevZn18h8pvM02/W+n5GWjXJIw/58Z6BmCl1X4osWW1xzyR6geR4Aoqtr9gB
	XETTA5TqC3AFCmYFmiZfGJ/UP6LmkOWbK3ATtf/Gg8KjkeggPhoR3/KHUuTYjqRNmW2QoE
	gcT824p5ywuE66F9M9hSMaD3lI6sD1c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9oeuZg5SOFELh61DhL9TrcyeFMUL5FVI7HyV9D7ONM=;
	b=Fv+hZTd3qhp8kL8UwK3EeYCv+Mbib0hQTqQ+rST2qfGsEIkIzNQLeHDtW1G+eVus4jBKsH
	I7UORytSV+wW0EGanUr3NG3DSRG2KjiSAsWeHiTBB3QJ4gU11ud2slAlCDvEQvBx/77W+t
	61reFeYzBPXJ2UwZYzn2IW1Hln1kwmA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MT90aUeJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 359CB45F29;
	Fri, 20 Nov 2026 10:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 180BE1F000C4;
	Fri, 20 Nov 2026 10:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170804;
	bh=t9oeuZg5SOFELh61DhL9TrcyeFMUL5FVI7HyV9D7ONM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MT90aUeJnbBLoxSnli8tTtBlsoFe45xxYq7FCMaOJfqXCyODpNpspWc3hSd8SkzQT
	 m9HM/m7tfYasOLIuMLno+XIBkfnsJritn1I35Hs+G85PGyOWo2aqbx01Nb546s3l7J
	 BWGnwVJYoBUhcgV1FsrIjpajqeru0eyjz/AssVQJQzDpJuh5zNs0pxZtz1D7YPzYAN
	 ZzYDSSj8TvhhBVhbzNJkR/DPNP3NVKgSci50dNMucuDoqkdGwZpbuLzlHRwDlI3yq2
	 oowRyN8OH4AiBudC5DwdHeH70QNVCNAH2foLQpSDv5FnrOZ2vP8EWoxiV4qmR5D1+m
	 a8ZBginKlEPFg==
Date: Fri, 20 Nov 2026 12:33:21 +0200
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
Message-ID: <awAh8chFM-9WtNKP@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
 <20261119224312.1037966-8-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119224312.1037966-8-jarkko@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F8D81C0003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: m16rss68q3ubhuazzaszhgtff919cgtb
X-Rspam-User:
X-HE-Tag: 1795170806-77905
X-HE-Meta: U2FsdGVkX1+QiLd/4nqf4DHRwW4C6g6XuPRHv7Tl6Uqt3Eyytcn9vR4fY10PosGKvEYXSA0EIGcPLy+Gn6K6Hy3q+60wYuiQnw0gp6i99EhNFwum4B8jAEemg2oTfDED1CeW3JDzWYuJqAPS1JHTZ0EW5lC53o+S9AQUIGfWMsyyc9cLZlRFxFbUbwEOjdNnMeflgKqkmkS+nlz4Vz2qlQK8vGg5HRIrtko1tyo81owNpVB7Ez2G1Dy5c+ApE0aNzbUVNT8TLr6FB+PcTM2Cf+ZjLNDGDRPrtObWVt4V51F7JTDXie7giYeIRspee/gWkaXyq/FMpG9xKt5ESYFxIo05UfoOQhCWvVrIbytU5J5Eb6py0NzJ2TWUhRPUdjaxsNeHvHv/EGEgiE7up98dRjs+EPW42mRGCRKZtH7hhJD9YI64+wcaIs9h32M8NM72d/7yaVUTC6mvadgyRRhINAex2RZE/DE7GEaDfVxtqBMG8m5CXpiKJzTbWyRoGYxRP3sg28rZ1ZTnX+/ldtF56Ln2MwzXLaOuh4FGdLeeijjaOS997Cx62hbgFShPgNOC3dYiIZvFcUislSLM+3N8fbpG5q87YUh0GlYvV4EG/cZCKVSmhduYYf06j7MiTDggCDaYeq/micw6zgcYgfDRDYoq9f+iydsAVyzFGnagXADDUkM+qNG2EZxvBPT7j5yT+XruPR/SRtCj4vSXgIE7/23dM2ijtrJCzHG4aj6R8BvYEH36ucf05avh4MnE67fHssfy+f/Ias5j9skjIzn8BzUOpfxeCWcsn+CZgakemTfOgrvDzEiLo4ueGgaMc02qR/q2RGaNxAecJpm9LtiWbOp3mf9jBgJDaF+K9XZos1+8/Ed9lkBa3dCNAAAnKAYzQyupZlBTfhIIB5v6V3WWMxPQ3/UbyzKNVg4Epbiy/0trWN6Pgm0bZWbVYInVTO3lKq3xuE4MIqsBmJH6F4k
 nBL+r1Ca
 43fP53QQ4txgypJ6uISsw4sQN7makihexYQJ9PGIOJX9DOdGB3QZN0x1fUJc0YomhxLJegCf9uiURuhT6YnzUWT2l4HTfZabGv4M+/6r7DTJkPhkQQiUVIwrfKv5MG6ZCaEn1G9XWPgwBHwiexHS8eDBdtytRQV/vC5jt6gO9kgPFNbE/b27QydbgcHpGvbIMVqtDdHACD+rzL6b89yGWSv4bGRk5Gnd6euJUVuV8bIy+7Ap2qeu6GW4sh5ibDqiHR/SYljfTd4QxH4ckeL5/xCw6zaZbmmGXNr4+rG348BSeLeYv75xWTE0PVpiDK66iBqhM7/z7QTlWqvV3QaAlwMPcbplMHXxkF7i1yOD/qyhSNss7+xaVVCxQO5+f4X0X8NHw/zZ3b3k99rm+4HtuLi8FdBDEN5osbnIGZP2b8txSDxhQmgLb7gj+GNO96kJR4VLfBwquY+Hig3kwHi8OY8QaZUddpK6RijJJAwLpOOz/c27/hSAnKxAw4wmXsi2ix/rR1KYhhTmuSgSbXWW8DW34nP728Hiw07xGrm4f8vNRdTcij2ANLNq76gUeUqka0XM0ZsXF5MdNICw8DF3cY84TUKspGP2WgP0Adlwp9Vgxu3E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 12:43:05AM +0200, Jarkko Sakkinen wrote:
> Multithreaded userspace daemons cannot call setns(CLONE_NEWUSER) or
> safely mutate process-wide filesystem state in place before spawning a
> child into a target namespace set.
> 
> Add CLONE_INTO_ROOTNS and struct clone_args.rootns (CLONE_ARGS_SIZE_VER3)
> to spawn a child process directly into a rootns whose root mount has
> been installed. Transition the rootns from ROOTNS_INIT through
> ROOTNS_FORKING to ROOTNS_RUNNING for the first process so it becomes
> PID 1, serialize concurrent entrants on waitq until bootstrap resolves,
> and admit subsequent callers into the running PID namespace until
> teardown begins.
> 
> Derive child credentials from current, require CAP_SYS_ADMIN and
> CAP_SYS_CHROOT in the target user namespace and an ancestor active PID
> namespace, preserve caller umask, reset dumpability across user namespace
> transitions, commit time namespace vvar mappings after copy_process()
> succeeds, and look up the live mount namespace root. Restrict companion
> flags to CLONE_VFORK, CLONE_PIDFD, CLONE_PIDFD_AUTOKILL, CLONE_AUTOREAP,
> CLONE_CLEAR_SIGHAND, CLONE_INTO_CGROUP, and CLONE_NNP.
> 
> Co-developed-by: David Howells <dhowells@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

Being fd-bound object the gist is that the first clone3() binds
cgroups, which could e.g., different process than who build the
container.

CLONE_INTO_CGROUPS is of course available as an optional flag when
using CLONE_INTO_ROOTNS.

Br, Jarkko

