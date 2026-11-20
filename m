Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4374A606A33E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LxHJ1pgZ
Received: by kanga.kvack.org (Postfix)
	id 535AC6B05B1; Fri, 20 Nov 2026 08:30:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6B16B05B2; Fri, 20 Nov 2026 08:30:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 387406B05B3; Fri, 20 Nov 2026 08:30:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10B0C6B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:30:25 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 86750120DE4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:30:24 +0000 (UTC)
X-FDA: 85455581568.12.B1F72EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id D4FF51C0007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:30:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LxHJ1pgZ;
	spf=pass (imf21.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795181423;
	b=Zxj0lHdDDZRwYEQVfw8cru5L5J1dublGKxY5cMDXL0AjjkShwbXvlfPIPKSiRVyy5qeQ2F
	okKdQvwDxHQy1WmPuBL10lKqhyXooE496q9BaVT8Z7ie0deYlPx3jsjSkPWK+PvhBKQwTB
	or1f4yl8XQHao/GqVyS0MLhyMDXmmLY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795181423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r0yepTevnFJpzt2r2drCfhbGwH1m5XYOTRjJ/I5L2oA=;
	b=u/6KenOTDW2iWKYb+YN/rdj/cH5Ln4vAfbeI2HsmOxybSLn32WzrbqRo7Mr/i5UCM6E/A8
	XtUm860kqkcMQHM8J46KHxP0IdZ4sPIRhyeO11xXF2TkL/RACxoiBqAZh0BKGzjN/IU5/Z
	QknaXIKVr0HbEPb71V1UZTYrhNHhPQ0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LxHJ1pgZ;
	spf=pass (imf21.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id CE71161DEF;
	Fri, 20 Nov 2026 13:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5BFB11F000D2;
	Fri, 20 Nov 2026 13:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795181421;
	bh=r0yepTevnFJpzt2r2drCfhbGwH1m5XYOTRjJ/I5L2oA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LxHJ1pgZMRnjgm2kTX3LFJJa+QJ+pe4P0CEN40l/PzhoI4P8panaY+0Q3U0aDuZqY
	 d6XFuKi4YyOzKCDyY6Fpy81BvYcjjeknCdisgEAM6IWExeb3iW1nhJEJD4KaBAW+bD
	 r5iJicgG91dzqk9nzBZ8D2/JbAlMgawKAhCSuL3ug4K1sos2GJ4t7TiWGQh22c59DM
	 wVnhMwGWXmBTp2MeJ5zHRxb9ZPYDyJPmjlhQXY3V7wh+jRIoGhfeMZWEgSkpntxOIX
	 O5p3EmJ9RssCoXPKlmpEXhy+NrYqURd5KZrMIRYhlRKm4oS7b0Ay023KIpW8vNYQ1h
	 LgzIrz39Ee1bw==
Date: Fri, 20 Nov 2026 15:30:17 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Alexander Mikhalitsyn <alex@amutable.com>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
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
Subject: Re: [RFC PATCH v4 03/14] rootns: Track init lifecycle via
 copy_process() and pid_namespace
Message-ID: <awBLafK4jqB8fTF2@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
 <20261119224312.1037966-4-jarkko@kernel.org>
 <e376c8f0ec5c50b417375197a5589a210f151d9b.camel@amutable.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e376c8f0ec5c50b417375197a5589a210f151d9b.camel@amutable.com>
X-Stat-Signature: 731hq99k7if4ay38mrnjr9eggkrb7tk3
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D4FF51C0007
X-HE-Tag: 1795181422-99794
X-HE-Meta: U2FsdGVkX18bniBEHFZhPfo/rOYShDXrGXKECguhXPakr0Y+FinWJ7vsBwPUndmQgDqGv7fYeZJi8HSFhhMoVOWfB0NMuRst6jys9AVLpKp5qgZcM4tiQOAwLhixhvQK2nBH9AAjXjj9CRiqONeEIpJ+Q/nX2LNIHz6FEaiNpCezUO76h9SIiXSKOz+gd1dsZ1VNItMVhEasrP3bAceYdl9cAc/LERT6r5S7FEsbVWnjaT7PNqkruYcwK+Fh4XowInrifI3ZQrifmDa1wCUh7q0VdDYACdKQdtzFq+6OYnMjjeNL+44FZ9ceGOcE/U3tvsVUYFrcg/8u3xnJpraUmZExfCRj5nHhUkNzfnKMiH2jM8R+hifKoWUIc2AH5Jh+Ki/ExgTv7dmEyoLMEQokHSf5PX7wMBPLWZZeMShgb6+PZKOKNt+jsUYRJ2qCsgadIDKV0mi326Wp/BV+Ci++bEv8dllxOYbn3G//WmpYVN4d2edd4lz1boZpDbLbr7cXwIUBrnDAE06wza21cR1I05uRD6yxE5QN16r89bMEJUxCC/DajvSFnRrNxHVs5XOKXcKJTpng9h1pmuJ9m8kXnbb3LSG2Y1hAkv0qxtNjQaghOPkW9+FRD28roSpoM1bcGosPuTtwpz58wz+sClcvpBLD/VwpbODgFJpEzq1ktCwpF6r5lG7DaWOTvsHLNCJh8hRVSiy4eKuVMWODlRBjOyMHe959Cky7vo30TrJMgdSpmVrTxKo4QTki5nm+k1OOuD8yLWUrvySKzv4zUbk0oEqQEC9+nn0LnYQp79p18D9+R+DXN7hXDhODsD4M2gDZZJcjmL1saUT1Cs2kFFg9MmwciYzKycrogvxIGclKzy1sllXaOg8yhszLQ6U9AiH2aoCOPK0wT0PIF0mANX8o4pr0rXIpq37DmkFMW7hddNZGSw6lVAWOYjLOKFv3YCt7Q8GmjBpHaoSMYw1CPd3
 ff170J7U
 PxkbuoiZEPkzug/xfzHxqeiuAXP93TA/me9TlARfRF3TzuxR732oiktKnJLvdLK9Xbkj2uY1zxoBKroXd/1soGfXSWGcracVdeu+n72Id3I22JyLU5gy6mqPa+oLWQ8Qzs1NzGHtuS//ek+rr6OOOkC5PANUySKvMsx82vXsCoV09VjUXE7jxzSgzw8XQg+nu1jBkzX3YhB68mOnFTbajeyLMGXTmYUHBg9rPzWYaTS5yJ428pLuR+JoT+8Z0OYm/IfsUt68bz6Wbo4TFk5cX+/GejvGZdmDSBHJa1eQ/nHs/XX8Kmi2HvK8IBxc97nLcTZaH24eWee+xBpYtH3v1Uy6+MDN6ISczf2aaDT0k3Lw2QKh86dXTFjFPa0PXANu4dRe1yZ7PCpdQK56lpO6ozBDRVFOOrgcBIAVfwLlzXrd6VmzsKC6DfBpLPbTbawXVcdFNaVj/WSi0nmjSLKowEW8HsEvjBJ48Ct6yS+BY0/Z8vh4SSy0cYUJHbxkOajBTH+MpQ90tJmRrD+joBVc5cjv55MsDhLcc3TQWE/bT9nErrt34lJWtYakSGKLF0JFmx76NpqQ7XbAi48E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 02:18:43PM +0100, Alexander Mikhalitsyn wrote:
> Dear Jarkko,
> 
> >  	acct_exit_ns(pid_ns);
> > +	exit_rootns(pid_ns, me);
> 
> We have a very similar mechanism around pidfd's to track exit
> information for a task. As far as I can see we already have (struct
> rootns *)->init_pid reference, so we can get exit information for free
> (look for PIDFD_INFO_EXIT).

Thanks for mentioning. I'll see if I can leverage it.

If something like this is found, it is partly due long history of this
code i.e., not planned/opionated choice :-) 

> 
> Kind regards,
> Alex

Br, Jarkko

