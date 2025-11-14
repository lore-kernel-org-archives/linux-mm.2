Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67671CEACC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 20:06:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C45188E002C; Fri, 14 Nov 2025 15:06:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCE738E000A; Fri, 14 Nov 2025 15:06:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABD378E002C; Fri, 14 Nov 2025 15:06:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 93E5A8E000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:06:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B07D1A0502
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 20:06:40 +0000 (UTC)
X-FDA: 84110295360.08.34BB383
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2379E2000D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 20:06:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=YK9eEZEa;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=1Zyc6PyP;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf03.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763150798; a=rsa-sha256;
	cv=none;
	b=izLzn0RQtvOYwLFVB8CPxIGBe1DZj6ESOYwCL88QtnEwg7gYTqH9YnkJhDF/40haKOoEuw
	u/5cIxg4uT0Wze0Fj9RVg9xXkds2hUVkgofcVpy1KArCkAHiWvCjztv1cK6HmhnO4mg4O5
	S1kDq1JE6X/A3FQUQ6z8T9L3KC/r84w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=YK9eEZEa;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=1Zyc6PyP;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf03.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763150798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JOqB4C/lS20t6tPC5FIrQm+ReT0eGwkkWKV6KUVlY+c=;
	b=Trm5WnszEIGOthRT3PLK+wdCG616DbqqRwm15DXCQxZsIZg/zXA6Z99UYZzQduuk1I82js
	qXfTB+QDz9O0CMamNzBYrDtEz8D6P5JvcXzF2FRaf8pdAu/lowehi+d1tTD7eGoDSUQUsI
	PCkxLeIVKa4JHKFPZoaDTfgFSh1P+90=
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1763150795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JOqB4C/lS20t6tPC5FIrQm+ReT0eGwkkWKV6KUVlY+c=;
	b=YK9eEZEalWaKmf+x8aV4nBEexkqfsmiKreG3Y2jkPgAgLWTY9R8IBAqeSpkzvcfTlK/5vT
	+O81wGsZ0UIeJ5jBhUw4Eoayfv/X/R8/YAkUQfbLySwBD+nR9giKh2lTUX2IuXR2sbXviX
	FoDaeDfQYEVnADDuXPIQ/3NYR3mHOmWH0metLgocPmrm5KlONkA2MI+xuHLeh3MThztb1A
	kXnDdCaO2sDMKHkhrx9itHQBX0xVNdyadNovuurLFgsetAEAqd8BZzCxmcKF/5SsAQ1SuC
	9Fvj3cEHnJH7K5iz+x8gAJ7PDgm0830h9iPB4luicMqudfO8UPSUoF00Q35K7Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1763150795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JOqB4C/lS20t6tPC5FIrQm+ReT0eGwkkWKV6KUVlY+c=;
	b=1Zyc6PyPyhUajFuS2x9XsSMHMGTgSzQMRTnNoHUVo4zlrqPxJr60WPV70Jazg4G37kJhwh
	jOcgXkNRpr6vopAw==
To: Andy Lutomirski <luto@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>
Cc: Valentin Schneider <vschneid@redhat.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, rcu@vger.kernel.org,
 the arch/x86 maintainers <x86@kernel.org>,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
 <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Josh
 Poimboeuf <jpoimboe@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Arnd
 Bergmann <arnd@arndb.de>, Frederic Weisbecker <frederic@kernel.org>, Jason
 Baron <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, Ard
 Biesheuvel <ardb@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 "David S. Miller" <davem@davemloft.net>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Mel Gorman <mgorman@suse.de>, Andrew
 Morton <akpm@linux-foundation.org>, Masahiro Yamada
 <masahiroy@kernel.org>, Han Shen <shenhan@google.com>, Rik van Riel
 <riel@surriel.com>, Jann Horn <jannh@google.com>, Dan Carpenter
 <dan.carpenter@linaro.org>, Oleg Nesterov <oleg@redhat.com>, Juri Lelli
 <juri.lelli@redhat.com>, Clark Williams <williams@redhat.com>, Yair
 Podemsky <ypodemsk@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: Re: [PATCH v7 00/31] context_tracking,x86: Defer some IPIs until a
 user->kernel transition
In-Reply-To: <1a911310-4ca5-45a4-b9bf-5f37c6ab238e@app.fastmail.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
 <c4768cf3-f131-44e6-9b25-ebeb633f32ee@app.fastmail.com>
 <beb46a02-b902-438b-8b6d-b5f0d7ad0ae6@app.fastmail.com>
 <89398bdf-4dad-4976-8eb9-1e86032c8794@paulmck-laptop>
 <1a911310-4ca5-45a4-b9bf-5f37c6ab238e@app.fastmail.com>
Date: Fri, 14 Nov 2025 21:06:34 +0100
Message-ID: <87zf8o9y5x.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2379E2000D
X-Stat-Signature: rq99itoyfnps3rq6nq8ehcycwngk53ie
X-HE-Tag: 1763150797-476132
X-HE-Meta: U2FsdGVkX19QF2d72XfRFxgig1DqiCVfgvP7rLP1VaVDh3R1o6pSYPDkJxle9OUf2IKDfQehxK3YVajaS41HuVZMkXSBZcxrzpPQu9KrzXg2Au3QMGczIlRY+WF3DRnIDSq2GF4zrGBlksYWieV/Mcip1x2B/ulPc664v+LTIuvs8BRs5WmFnni+qCsNeYfbg01+mPeW+nMuZFDBTtINlT9xzXf6a+eR8wgnIwu646ZbPbX6Y2juME65d/rB/9VcyBtfTTzrI6EAS3jtf9S11C6E0P/EHXk1+two+RHAWDNcAPfKirVQVYRigRhkL1K6+t9vwINeTl4lYDfpUpOunGXbD7Pz/Cd0sHZnQsddclBLImtFOkUz0Q1vBHFJJ6xFScC0nAMk0BWcYXlDmWXwkda00FxjHbopvq9SGd/rs+mPJgbvTdgeUcm1whAd8F5eDGRIDLBfdSWVNdo/R/ZSAdD7c7I/BdxXaIA6hRjb+9F+rx6vrvwYts0b5WXsaAD8qBJ/w6ZHsueR6LnR2fxDUaCS8uRLmWpz02QHbMTCAOvFozprJIL7Us8c0dIE/mpvcz2ou/qexWkmdwEPwPZDY9eJqzM1p9A5TCG7oNC20n2Xnv+CANfimY3zcE3uUS++8NkbbC/rOeRRYXTM2OFqwvMKPmuk/tTYfSYZqvCmmxBvQTugvx/b9clyuD44gAnRWw/PGCYTfPqJelyIgiyPDSXoKCTZYHOoLm9+i8h8AhdFyTTfVIQonVdPc/g1eLLZg58K8Ja3TWfA+FMkS0kx9dlaOlOhjZpdH3JpfsoZfsnDmzFJQCTlEzcsSRLX1hVul3mPmud8thIqLYM+wgc8kG5wJnGrGO+H3vMAJ3iYt2KA/BBcXrYo0PHJeVAoKXnDFu2xhGCkSNt8kyTLSAyEKh4YC8/ioPDazyMThRWI//UshtlnfeYQe6hjPosSxRB0CyVe6Qg61KPnmzOaISE
 un+YRWBu
 U3xzMRXlwa+wBsg699IP/2Kp2jiiOk89PLc4UXppMU/6FkgMdFQ7FV02SlGElgLsAygPHf+eo/khti75lXmBO8kovx/ul4Lm/BSMN/WUg/18+KG6Et9x8Qvy1LGr6AeQrvaxZKMomhBflAL0C2LpkfqQFqT3PtqAewGXuY+9Bl4/8TRgXj9U2Qx89FyMBQNPecdZRmNvBF6georUFJOBnKhEsOrwzhMF2iz40wD5Ji/GblMpnq4C0bqUWYWeLOsJ3Ats6u+WkaEtemEA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025 at 10:45, Andy Lutomirski wrote:
> But I did that test on a machine that would absolutely benefit from
> the IPI suppression that the OP is talking about here, and I think it
> would be really quite nice if a default distro kernel with a more or
> less default distribution could be easily convinced to run a user
> thread without interrupting it.  It's a little bit had that NO_HZ_FULL
> is still an exotic non-default thing, IMO.

Feel free to help with getting it over the finish line. Feeling sad/bad
(or whatever you wanted to say with 'had') does not change anything as
you should know :)

Thanks,

        tglx

