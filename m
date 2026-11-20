Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB0E606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 15:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XCQUtSSf
Received: by kanga.kvack.org (Postfix)
	id 370066B05B3; Fri, 20 Nov 2026 10:24:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9C76B05B4; Fri, 20 Nov 2026 10:24:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19AC96B05B5; Fri, 20 Nov 2026 10:24:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5ABE6B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:24:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C88180FC8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:24:39 +0000 (UTC)
X-FDA: 85455869478.05.1793B7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A6EA64000D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:24:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XCQUtSSf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795188277;
	b=QEVp71clhYwHzHCmwYnpENXfkt2BNf3EzKznZra7TUr03hXsdA8Pepzc3ct1P7Y7YOqQSd
	oZBq+tImpX1ovwHa/OEBF06LPsZZZwUx3V8/mM6UvFBX5cy5TmARXo3RgaggpYQ9aji3ue
	TEEjwCp1MC0nxE6ExrFuypjg8y0gEIE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795188277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zOo2EfGngcl3fu/kIhqZadaO75pP0lk1DR/lRHlyrtU=;
	b=tC9nl8RqXCGfnItNILpmwb73nvQ3re33hEJ1VuaOkSE9M4Zp1/k6lwgrVtene1Bo7TpBEE
	e4V3Ic9WGkpQ10wU/ER4SNgY0JG2z+dxwMdNxw4E2uaoSfNXMYl84fentydA46BstRdOXH
	irVH3Hng8plA8pZbHS0/nEovU3Gmtew=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XCQUtSSf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id C130340852;
	Fri, 20 Nov 2026 15:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9CC851F000CA;
	Fri, 20 Nov 2026 15:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795188275;
	bh=zOo2EfGngcl3fu/kIhqZadaO75pP0lk1DR/lRHlyrtU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XCQUtSSf00g2G/Jpzjl9LRNQEFXNNRnYGZWzdtuiZBHk7dosmqWBMrC+L7eGsuwT3
	 6Y8qXJypfh+8W03R5Msm4iQvi0clPna6Y5oqS1fK2fMBPqPJtncagCqPrZrgwYA61c
	 Ir7DESMb/dns84I6WWtY5IQnf73sTx8SIKL9bvZjYjcc9pfyT2D4A8Rsc/CYWyagj2
	 DltATLAp/YBb7+MwnvRYS7P7+HT3f1+jlJHOL7W4kb+l4QjcUeVm9fOWhMSveLYD4Q
	 IO8nsOvMP1W4FNm+RhhQIMrsrDM1nc6imjdTxfwsnAexYb35pl8AoQ1Ir88SqmYiNe
	 v0OZ/2yfr0Tjg==
Date: Fri, 20 Nov 2026 17:24:31 +0200
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
Message-ID: <awBmL_4VqwinHuVN@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
 <20261119224312.1037966-4-jarkko@kernel.org>
 <e376c8f0ec5c50b417375197a5589a210f151d9b.camel@amutable.com>
 <awBLafK4jqB8fTF2@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <awBLafK4jqB8fTF2@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A6EA64000D
X-Stat-Signature: 7t9qk7mj8dqbo5fa13nui3i9wyeha6rh
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795188277-792910
X-HE-Meta: U2FsdGVkX1+PAQnETJCB8N7m/zZvDcXccG0hYXR3PTViybTqaSUiMiEBz6W61upbFwjiD5zCve2v6/GF58xxkgvhBsmXtam/PE3u+M1EXDOmXXKtyKps/GrgPfD55VmE8Ed6o0nsLAEyaYto/zjka5WVFWLd64R5YSIgimxGFNsiuCrYTCyz19gPG74VvwagKBdWJDiIzy/4BgVCwyBKVQHFqew7J/k/++kyGwuagOauAlKnZ9sgRhHxNZViHPO5Nwv9KBS3asHAZA3FUSzpEHafwje9UNK30WTygc/6ZS7nv+CAjnFe5WjBkDJbycIkBAawCevs+h/DlOzyaAwv50e0uZrsIb2KI0GVeIRx8yX11btc2EgxoLd5bXge05Q2/wQBTbJm1qoGhjjgmHuC253ExMBHCLS+VAIvsLeW0D8X4QOLIY0kW44KTEQtyng9Ym9cVl4nUiiFej1qjKC1Gbx9ygpx/ovGw0tXDDtiYMwnX6y4wUit5oCSniy4kX6mUdkW9LFO+V1ZlsLbFi+EgQ1jUDwo8znr408A6yQBVc+1T9p/tfRYyShL7PqqD3fYzT+fS6by6MBYdva4f+baS6Nj2o6VkboJtlJZJBzzX3JAOTmKU4ZxPZNptHmrnD5pJJGh+fLHfIhDYNhSUHTViihq318hx0v4uizhBKBXgM2S5sfpS0L9Q8ODlBBEHqT9g5fdWkHLRnwXl1F3ze1nmhWoy0n7A0Bt1p0ULTuLXvZLzZZjOZJwGcy/d+P3aeGthzHUL4srHUJLdtcq/jYP5bkd5vQ25iYWQHxJk/wJEMqQyyVJ2eNqzDo10JzkwYPnE9WWjP+/hrbhNTjUIS8DvdHH9wpY0VEPl+a2ZxD73IbPcACOjwOQ0D5FMO07WKfNW96yE0W2fAE+rou87WQJK7T0wb4/p4WhyjL/+58rsYW/SncgOemxHOuLoBv3d4hq3TeXiCENqmIgmnjZARd
 wHY0a2FY
 Gpe+FfrcE5eOELc6pUaAlfkD03feAirlPw08hPJyDtcGDmiJsxoBc+BBm927ECSniJ5zCTDjYYtkqU0yB3abXc82pbHg64I6Leo0DTbFLks4/QBuZkci4RXJdEcXG22Vq2DneEsvpmXTK6bgzWSJj0b5+SLvAEiuZBcweW0uWeEHMKc8OYwJBel+4QMdbUkZiUhRCNOXpYyCRi0o6BFGvHmZ6tWunBysWk7NAYpPhkRUYlqZbAaYdNHFVn3aMXCF3MG19HPo0Ee401q+03cCAKjCsvBuSgc5H6aTTN9UrvAwgurLaBt5tIy9a5soFKbn0yyCk7ZX+IHSqhA9E816y8kkMxpCUOqSIIGglpZTXZ571tiVUuLpIDkLlsAV56bZPAxPfarYoFL2jlI6XEPaTfm2700YuGz2E0Kiua2c/HjKWOoiD4D9Fpit/08e60BCNV/EkVWR166w5Wws8f/NAsfUYXd7sstzg8BccBCunNCtmPLProkUC+clVx6vkq51yqwYaFZ5EPDwVhbL1kZ/vFmI83vZI21QjYjGmSfLHN8UBBa00IyUBRz7IupAH9ieQassIO8n5mFR/kfFUZrUkI1DFLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 03:30:21PM +0200, Jarkko Sakkinen wrote:
> On Fri, Nov 20, 2026 at 02:18:43PM +0100, Alexander Mikhalitsyn wrote:
> > Dear Jarkko,
> > 
> > >  	acct_exit_ns(pid_ns);
> > > +	exit_rootns(pid_ns, me);
> > 
> > We have a very similar mechanism around pidfd's to track exit
> > information for a task. As far as I can see we already have (struct
> > rootns *)->init_pid reference, so we can get exit information for free
> > (look for PIDFD_INFO_EXIT).
> 
> Thanks for mentioning. I'll see if I can leverage it.
> 
> If something like this is found, it is partly due long history of this
> code i.e., not planned/opionated choice :-) 

This non-doable or incompatible at least. I'm not sure if that would
have gain. I think this goes to acceptable redundancy. Or at least,
currently think this way.

Br, Jarkko

