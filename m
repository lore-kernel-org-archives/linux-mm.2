Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F0B9CF34B2
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 14:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6A26B00B3; Wed, 19 Nov 2025 09:31:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7DFC6B00B4; Wed, 19 Nov 2025 09:31:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D236B00B5; Wed, 19 Nov 2025 09:31:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A44FB6B00B3
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:31:59 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B05E5C04B6
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:31:57 +0000 (UTC)
X-FDA: 84127595874.24.1151374
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C5DF34001C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:31:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ea4bojU3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of luto@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=luto@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763562715; a=rsa-sha256;
	cv=none;
	b=AEKmoB6OjbQ+6AC8nN8365UhCgsXn4hlfZQGgsP68YPhQ659ywZj2I69rwBx/VvO/dYlcN
	Y6ZOrnVJmc03F+CockB08ZGPe4x5jAMsaovmNXELtz7pNbpKFGAO1SJ0WhMbTSn75j3A8n
	16jSGWM+/Tf++6pf7Ar/lK5wHQXHwkM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ea4bojU3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of luto@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=luto@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763562715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6D6QeZI1FMy5FBGvryMzW9jVA/82yWzAxvTxR3x6wk=;
	b=7rC+72oEGuscoZB77OocftTkEOGIXADKFRaEwfr8nasQ9CWsc42KdMdzImVjYXnFqXXJh3
	PeFKKnducON4HNINSqSg+U1HHNPMUkdK/qid6UVZzfpaPt9Hg3laK1PUL0rRicR5eDFExz
	8reXtc0k0KIH0i2up3AObml+oyBJw7s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E80C26016B;
	Wed, 19 Nov 2025 14:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EC7C2BCB1;
	Wed, 19 Nov 2025 14:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763562714;
	bh=t7JHEvub1bQJal+g6fm+oWNxS6WRDvkPwGmxdErav44=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=Ea4bojU3b4uuNYkYVwnmXHYKrqlrEyIaRN7/uuLqQ0tjPkP+0CBl8L7OWP74jMhkR
	 6BEZWebMdOXDsVMaFdTA/3c4Ol/FfmWfZJ7I77nIstjY/8MxmX60jwnojnAv9c5OB6
	 yiaxqYjeyx5Rbc+bcCTpfw9nnAVkEBGMQ7n8TQ68Sdv8V0/fXWca/2aZJ+PdDOCe1Z
	 fgqUw43kE8xbSlEr9OaiWF6IUiQPM10iJQo0m7vG74uwaC7eKHKSOTyPWFK+IxX8Cr
	 NCsa459K8S2l9VNSLvncI+/+4fDDtvhtPnwSSP5VIBtd53subUnkzEeGp3uNl9yo2f
	 QaAOeHd7myqGw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 560CFF4008D;
	Wed, 19 Nov 2025 09:31:51 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 19 Nov 2025 09:31:51 -0500
X-ME-Sender: <xms:19Qdaap8BjsJbFtssqDUjnsMU_LQS_YP23cqGo1hqasAALMZnLH2Jw>
    <xme:19QdaTekCirxoT8xxcC2RnapN71lsrezhBKHk9cWFJTrytiWHrCnoOSQ_WG25jLgz
    VLVYir4VtevPFlszmb_dX0zPBndPMUq9wQrH4t08wLIbtcqw1mEIP0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvvdeggeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedftehnugih
    ucfnuhhtohhmihhrshhkihdfuceolhhuthhosehkvghrnhgvlhdrohhrgheqnecuggftrf
    grthhtvghrnhepjeejvddvtdehffdtgfejjeefgefgjeeggfeuteeiuedvtefgfffhvdej
    iefguedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnugihodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduudeiudekheei
    fedvqddvieefudeiiedtkedqlhhuthhopeepkhgvrhhnvghlrdhorhhgsehlihhnuhigrd
    hluhhtohdruhhspdhnsggprhgtphhtthhopeegkedpmhhouggvpehsmhhtphhouhhtpdhr
    tghpthhtohepjhgsrghrohhnsegrkhgrmhgrihdrtghomhdprhgtphhtthhopegsphesrg
    hlihgvnhekrdguvgdprhgtphhtthhopegrrhhnugesrghrnhgusgdruggvpdhrtghpthht
    ohepuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvthdprhgtphhtthhopehmrghthhhivg
    hurdguvghsnhhohigvrhhssegvfhhfihgtihhoshdrtghomhdprhgtphhtthhopegsohhq
    uhhnrdhfvghnghesghhmrghilhdrtghomhdprhgtphhtthhopehurhgviihkihesghhmrg
    hilhdrtghomhdprhgtphhtthhopehrohhsthgvughtsehgohhoughmihhsrdhorhhgpdhr
    tghpthhtohepjhgrnhhnhhesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:19QdaSQxr3HQaS5D5svYtdioLzJ9DrcJWaaCXygndJcKZTp8DQA1XQ>
    <xmx:19QdaRuKJfSzLCcUvQaFs6zUjI1C5yzQpwXIrnbakBUBZf6Go7P5Dw>
    <xmx:19QdaRsZ04AgZVVF3BYyQvlnngCHXui5cx1xuooIBwrJs48FrjqOhQ>
    <xmx:19QdaZdxW-cnpAjF52S13LU5nKqG8Kl70x0BiZJ1Wz-zYL2XACcj4g>
    <xmx:19QdaU7njPzMtRawVt5wHwKl1sfmi7DCVtIMkE__tcglxZK-V1ApZbUe>
Feedback-ID: ieff94742:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 1FAFE700054; Wed, 19 Nov 2025 09:31:51 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A2ZwPDH9FoLc
Date: Wed, 19 Nov 2025 06:31:30 -0800
From: "Andy Lutomirski" <luto@kernel.org>
To: "Valentin Schneider" <vschneid@redhat.com>,
 "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
 linux-mm@kvack.org, rcu@vger.kernel.org,
 "the arch/x86 maintainers" <x86@kernel.org>,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>,
 "Josh Poimboeuf" <jpoimboe@kernel.org>,
 "Paolo Bonzini" <pbonzini@redhat.com>, "Arnd Bergmann" <arnd@arndb.de>,
 "Frederic Weisbecker" <frederic@kernel.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 "Jason Baron" <jbaron@akamai.com>,
 "Steven Rostedt" <rostedt@goodmis.org>,
 "Ard Biesheuvel" <ardb@kernel.org>,
 "Sami Tolvanen" <samitolvanen@google.com>,
 "David S. Miller" <davem@davemloft.net>,
 "Neeraj Upadhyay" <neeraj.upadhyay@kernel.org>,
 "Joel Fernandes" <joelagnelf@nvidia.com>,
 "Josh Triplett" <josh@joshtriplett.org>,
 "Boqun Feng" <boqun.feng@gmail.com>,
 "Uladzislau Rezki" <urezki@gmail.com>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
 "Mel Gorman" <mgorman@suse.de>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Masahiro Yamada" <masahiroy@kernel.org>,
 "Han Shen" <shenhan@google.com>, "Rik van Riel" <riel@surriel.com>,
 "Jann Horn" <jannh@google.com>,
 "Dan Carpenter" <dan.carpenter@linaro.org>,
 "Oleg Nesterov" <oleg@redhat.com>, "Juri Lelli" <juri.lelli@redhat.com>,
 "Clark Williams" <williams@redhat.com>,
 "Yair Podemsky" <ypodemsk@redhat.com>,
 "Marcelo Tosatti" <mtosatti@redhat.com>,
 "Daniel Wagner" <dwagner@suse.de>, "Petr Tesarik" <ptesarik@suse.com>,
 "Shrikanth Hegde" <sshegde@linux.ibm.com>
Message-Id: <65ae9404-5d7d-42a3-969e-7e2ceb56c433@app.fastmail.com>
In-Reply-To: <20251114151428.1064524-9-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
 <20251114151428.1064524-9-vschneid@redhat.com>
Subject: Re: [RFC PATCH v7 29/31] x86/mm/pti: Implement a TLB flush immediately after a
 switch to kernel CR3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C5DF34001C
X-Stat-Signature: u6q45js7u9bfai73s8gx7t5onkcbwcz6
X-Rspam-User: 
X-HE-Tag: 1763562715-211200
X-HE-Meta: U2FsdGVkX18WX7/d8PjxzUzfXqLeLLilmnxx3G5vGvPJVry99usOXVYtOFfgG92l2/Xe//9sSDjrJ3bIL4sL3i6CKX7rftxhmWtGAndfR3YUloRebMA9Nc0EAqrCwA7/hQUeQOxu9eJBHPyPso7R4XzsuoMH2AMZhwn7QWePpV5vSVHijTZIn7g38jQBv93DZxrbmImjKX4hmhytkzPAK0eIGc2AyGe0U48PJyyI8HKBcEYjxRPq6ncSotwnRJGKzznqyCL4NnpMwrxdFRPi/7gLrYZow+PX9z0Bc/bLCeg4jk0JcXZCNEwZ5wTnemKdUBU7gKzvkI04Tos/E7PQRHNz4YiB6JHM9Tj1xW22LkR856LZwQ56lWxid2ITUM8q5wUO6iy6bMAcBTt7tVRUPrRrchR/4vY6qLaqnklL8Uo5W3/gRGeVHYKAWQ41QWBueF6v2wqdDS5mPLEIV05Yrpa19vuh/n0BF6lj74K+a8uDjOWXztTTr7r1m/jdOGsRGcyu+X0K5fnElV7Or7H8EBCjOCsg56dlEjwUYtugH+u6yS9ezcyjM7iV/cbvaZZ31ANfjoyACgop1Bgk9eLALypNJQXHFTS1RkB9jnTW78o29woPdiHkbJfpVpeQF7hNgL3wYsYPjDa49ZGgJIszF6SY5AyGxOTRQmysxNuihDRPQttP02+MBS2APXYrS/wEbrpKuia2yTRA0Zk+07+Q9a0OcG/L3yQBUERCsMMpglYK9OKkMDG0pnqxZOt66MZrp1ujSPN4gIJoWSkcfMyOn1FhxEVnHmr0RO48XQtZBC7R2OtZ3jXlV/ePXZC36CRtgxTnhG0UOM9R6KxwLdtJ7oQjNs7R4X1QCZnGLgy3c3VjiL7UW/IrnVDFsyKj6jQJmWLdOD/9D5uZQLeHAfvv+YAqM5XanpPQhySdNVE6y8njA1yDKdAGANHOobGl95nEegBUxOirtjoqhcyWsj5
 Vow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Fri, Nov 14, 2025, at 7:14 AM, Valentin Schneider wrote:
> Deferring kernel range TLB flushes requires the guarantee that upon
> entering the kernel, no stale entry may be accessed. The simplest way =
to
> provide such a guarantee is to issue an unconditional flush upon switc=
hing
> to the kernel CR3, as this is the pivoting point where such stale entr=
ies
> may be accessed.
>

Doing this together with the PTI CR3 switch has no actual benefit: MOV C=
R3 doesn=E2=80=99t flush global pages. And doing this in asm is pretty g=
ross.  We don=E2=80=99t even get a free sync_core() out of it because IN=
VPCID is not documented as being serializing.

Why can=E2=80=99t we do it in C?  What=E2=80=99s the actual risk?  In or=
der to trip over a stale TLB entry, we would need to deference a pointer=
 to newly allocated kernel virtual memory that was not valid prior to ou=
r entry into user mode. I can imagine BPF doing this, but plain noinstr =
C in the entry path?  Especially noinstr C *that has RCU disabled*?  We =
already can=E2=80=99t follow an RCU pointer, and ISTM the only style of =
kernel code that might do this would use RCU to protect the pointer, and=
 we are already doomed if we follow an RCU pointer to any sort of memory.

We do need to watch out for NMI/MCE hitting before we flush.

