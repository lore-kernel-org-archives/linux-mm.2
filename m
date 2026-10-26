Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4380F606A328
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=YnCT/mJB;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=Z9BmjjcB
Received: by kanga.kvack.org (Postfix)
	id 0D1636B05B2; Mon, 26 Oct 2026 19:03:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 089016B05B8; Mon, 26 Oct 2026 19:03:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB4EE6B05B9; Mon, 26 Oct 2026 19:03:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB7C16B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:03:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 39E42806B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:03:26 +0000 (UTC)
X-FDA: 85366305612.09.65AABD1
Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	by imf31.hostedemail.com (Postfix) with ESMTP id B67A62000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:03:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b="YnCT/mJB";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Z 9Bmjjc";
	spf=pass (imf31.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.139 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793055804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D7+yWhNEfwBLVAnh4DVgwdCxL54hx3J7AhdglfNEalQ=;
	b=uIh91JP8a7SMYEetZDOVTs1WugTvF1BTs23ndvi1HEYOIcctfwNQdSDKTsNSbCa5+G3DR8
	i6E9z3U2rfAFJhnb2iKGTKK8eZVGbZTbMw7VZFK9OWKdPg5R+rEt7mdQ8UiNMUAT6iWlMX
	Kz4z3i1iHJqY/pe+6HAchNk9jYhiSNA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793055804;
	b=ZEP7StqXFhfjxx7vTrX92hEOrUsry8CHKBnKLzg2ggZ5gBlIYFsglWLMx0oZdr11vT/wzs
	xYkzTbvPp1yxsptE29yC5pRHEDSfPHEfiqHIui5Bnv9/7R0o7SI0LdaXL0qx73S7T/ffh0
	hjuBesp3ADSn/29qxT4u2+OFa2tAVkA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b="YnCT/mJB";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Z 9Bmjjc";
	spf=pass (imf31.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.139 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.phl.internal (Postfix) with ESMTP id 431CA13802B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:03:23 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Mon, 26 Oct 2026 19:03:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793055790;
	 x=1793062990; bh=D7+yWhNEfwBLVAnh4DVgwdCxL54hx3J7AhdglfNEalQ=; b=
	YnCT/mJB73FAGmQIu27ctvo5RESP4K+pTIiK9EhLFaGH8j7kXKQE+tSbzesbfDxs
	bV+9wV/9mJE87FIh60l/aPw0vUFP1oQOrI5riJBeeRGczFUwDyCLA8/y4BcBY12w
	wRegLgnRHobHCSF6BA6i0C+reNBRVR2FKTT/gbMwVrLZscUYxkn/44Vw8eG0qSvi
	tWJdiyjuyg2ickLmpnfR0RB/KUcSZm6NPyieIrb9GtPlZj+tCTyGrh4XFyNGGvj3
	0mNzbe0+txL9uJr9T4IbJyuT48LYOX1e+ZzKJe7AQTdcUWk+BiA6E+y23Kktm4eF
	0OdWKJ+MXJqpGpYEJntcLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1793055790; x=
	1793062990; bh=D7+yWhNEfwBLVAnh4DVgwdCxL54hx3J7AhdglfNEalQ=; b=Z
	9BmjjcB8Ht97U3XpSdkutzu7KGGU83nJYqys9fKA8A8LFo89cKjsWQGjTr4pUO1L
	aP9kjNesX0okG+vOVw+RbXwBhTP1dlNpD+KBb13+OcK03C9JQt4JuFOOxyE3GGLG
	ZspFTpPuZDfO6wPr4qEO2A5TQRvlMMTy9lXbOlVikLCqKHWaoSShkmyr2lAQA0MW
	I75SaI19xADFJtpVucfW5iXU1oSN1+WUXqV2eC8N5VxDvuOCOwE0yDQK4eXGJuSC
	Y9wL+SsocvtYeidK4mRb5GFh4Lq5vzciH3Z2KUk3zskK7IRDyEhPwx+HWzKZpC0W
	mE1pSP6ArkmhYFD6hOYlw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793055790; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:Z+uQ3+7bFMX/aBnq/k5G3/0uBby5fGl2chRhLBn8mML4bOL
	Iw2T6tPiW0OxgUBbyObj53ZkjLzt4Ye/we/l1cJe0IdoSYJ/sR6XkvEONvb81pZS
	NdsZ/XxYZg7WIl3KXsPMNSwY+UZ3PrW0teJSvWzWVVlHVDlYxa9ZS3bHCynzSC8f
	IhYLqFdQMD2wMbmTQilqIsiFivNmDtP/vL3MbjjgQOvleRK73qbOxjQudIOGZJmg
	sPYFcNbJZcs8CAvLwoxou9GunLApUAqs3TCSTgKFCdtzsmOM0CLxf8EyZMHgL/R1
	GDwHsj/sU1IRUy0bVCNUK+9iaYjvUgZtgxn6mvA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:t7TmO85uHz3Bu9BudK5SiRDodgnhLHm1Jzu0xBGeMzU=:nc6weggs1vuexqOORIgzQ+8Q4IQMXclbAa/HauyeO68=;
X-ME-Sender: <xms:I9zfarVlhcJ2BCr_X0f-Oqe3MJ-tfizxDxcVqqJu0UTFnur8n55_Vw>
    <xme:I9zfaua_l0AUV_QUaHlFQ6Xk6c6S9hDoF9LDP0z9ZWTiBfyLFB6bGMt2m3Qf-Wf2r
    Gp1aY7E3hmIDYnxO6ClUpLNdypmMNJMMAjKb_KTlIEA5DbBcFarl32S>
X-ME-Proxy-Cause: dmFkZTG2ipuQjn7o/dduxIouS3rexG2Fs38Yf1mgntfcBayDO96egVm+yZQ4lqIIentjs/
    mqWlr4cScm3wkM9Qig2xKeks6qaebjWFYjqSr1PEW0Un0mkdsaFkbg+xdJQiG2O2dvowLj
    8E21v7JskZMeciXQK6+wWU3W5TpMrftfB6Bs3P2KNxD6AlDYn9LdKl79i+Pap9CUN0lvH5
    Kmf7XF9ELL/4XciMlrED2crBvL0Cr1f1u2ohCkkGXPJJyr9NhF3TZ6Ev/Xhe+zrfxeWaDU
    CHzGxCZtrUFf0j+qOyVHd7hT7F2sM8dBpGw742e3r2mvfUUQKFeZdDheW6KomSHxo+nEDw
    iI6qO2cDvY1NeToTkMsmxh+Idwqe78oXaZf4JBivXyC6kcFQnAnTHzPS/v1istw/y4OU7I
    Ig5+4LcAMjuaK21mmbb4bb1DmpocpNGdDRw9yq3nlrcPMsuuD3uvsbn3xyT972zofrrKbr
    ymQ2KeWkMRr8lrdJKsZ996mCPszGebzucdgyrtSsUPulGKB9lpIv0RpYgf85X7CxFkC5mx
    0ahqqI390L+Dj1eTAd45HDhy64TtvMVlHqpgXnFPGAYR24gTjdAn2Wh1e+VqFY1QE9IKWw
    dT6VBuP/aA1R/oxwzZkn1goeGaMw0LOVAE7QiXpixIzvdkU0wv6eIJAHAEFA
X-ME-Proxy: <xmx:KdzfajHGJ6tf5pxLJ3v2PfbGRd6Rt6Io_8hyQBlkYOXCV7Lb2b01Vw>
    <xmx:Kdzfapg-6ACQ-dUEsnrl6Ji_ntio6Ly_-zbhQjCdP4T2kZZPc2mbjg>
    <xmx:KdzfapZpLCwDwzVm3OeHceISOSkLUArE0NE7AI0C6AgT-FmN177JAA>
    <xmx:Kdzfam27dS94lXZ5VmP_WcqDu7eLBRosip4J-91RpWhTlpq7UwmFJg>
    <xmx:LtzfasvLSVKrc-K83R8kLrDibnrCdXZT8NkkCjHCIPMKCuEvlTPp1urH>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id C999832A0097; Mon, 26 Oct 2026 19:02:59 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AmKN4IVPaSCN
Date: Tue, 27 Oct 2026 00:02:38 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "James Houghton" <jthoughton@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>
Cc: "Thomas Gleixner" <tglx@kernel.org>,
 "Peter Zijlstra" <peterz@infradead.org>, "Kees Cook" <kees@kernel.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Sean Christopherson" <seanjc@google.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, "Jim Mattson" <jmattson@google.com>,
 "Jens Axboe" <axboe@kernel.dk>, "Pavel Begunkov" <asml.silence@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, "David Sterba" <dsterba@suse.com>,
 "Chris Mason" <mason@kernel.org>, "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>,
 "John Fastabend" <john.fastabend@gmail.com>,
 "Josh Poimboeuf" <jpoimboe@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
 "Ingo Molnar" <mingo@redhat.com>,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>,
 "Namhyung Kim" <namhyung@kernel.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <3b0a8fc4-d140-4a90-b810-cbc1283fc083@app.fastmail.com>
In-Reply-To: <20261026215226.3713941-11-jthoughton@google.com>
References: <20261026215226.3713941-1-jthoughton@google.com>
 <20261026215226.3713941-11-jthoughton@google.com>
Subject: Re: [RFC PATCH 10/10] uaccess: Move the NULL mm warning out of line
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B67A62000A
X-Stat-Signature: wm3kgtwymtqkxbnkjbioobffo35fosg5
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793055804-259838
X-HE-Meta: U2FsdGVkX1/MzawlmB1hh3K6Y8kQdzD3JK5Hnzb2JOKZi2MxVU7yRC5Wvku5g5yvAmuOfmeCeeYUheJYXQzEusVOyV5q6kjG4VI68VtHY1g7JiXHtspKrL5/NGGCB5S6Evyh5ac9yI76TCbJvoxxjT/gijFbYbAgGndi4DUiaFe3In40Oum2I0VG4zHElskIzSsCbJpWToZHm6o9h3tCSy5sWZW8xBUFNiPavVdSY6ggMQW7XFMXBlb9d89mtI5rnHq5TKd25OhdRFWJoDhOj3z4YiIJEZ3IOkehDoPqChJTJgPnArE3H67zw0LLGa2XjjRAq6nUAwH5cQLD8ELLg3hjg0FmrMKy4sH+aPV92UmKBoZnoddZwFsSrUCJprT/kky93WmVEK+6FLY9dsExZOjaknPBxvcdY3TlGPY7nhQc0/xTCXTaW+14UA33SUIEnmeLf7BefBzf42GRyH7mlAOT8c9T3kocLK7k6Oon46Wq2dwtHCo5V+X0JlCnFYRIDwOOKGCkr36HnTvFZBbq+9dD5+47BM7pHjL+9yGgx+pXY7E7HQxpVmEcD3sLrQIXBepp545afqNAGFIuK5wbvr4ytFZjx1EjSZHfofHAHhN53cZ5YpLlQwMFpc8lym2ENVGuqn+V9PIRMdC0L6rk9lMBH05HA5egEG68+ux6qSTd98Pg9x+v3TnjgUZUjUziGFM/271MAoTW/N56zs4FSH0/Y6i7JND5KaEFAjZN9ehOpO2pF6dsQXW/3TndGUmniB8w/bGsO2K5xh50/iVRTFgMYv6PfVqACQJ4/sy+zm7V/m8WtbwLZO1NhuDxdgAJZWiab9F4VaKGyr0b1aM5An9rlFftrmmu3w7ELziXRTDT1w4eFDslQfuxhkRJtiPYiebUfH63WqK/k3h5Yne3+/kZ+QK24U4MrwwRT1HA17sYKjgHoTj6Ej4gzP3D31naRPIlO6JAaJndJ2PTrif
 qKvICYSV
 ZToEG5tgfjEjk8t3qjRdKd9v4Muf+y5a25+CgXrmB5BETByAYcJQdcQgXBmIg7MwweyemScgBPw9EqQkPxDnpWRBvGzOeUOz+47+MR5hVfE0td2acgMHz67fnVKoK8TYe6QxLly1Hay8x/QytjJlWUYOj/EdRgtahrd5Gcfw7MzQNztDEN9J/fsN0EIk/HEE5AyvOsEeMllps8pM/oaAMEPwgcj52JDBQYKE1VnjaHU7J4bbodB3dzRlm2qkjj7bsqZrRQjEU0SXc3YnA47v2lRKJVxVNIdMFqfBA5WvR2r1l97CFv+H23JYLgdGVSRd+QnutgbOgNe17kfCo/tNbWHuOLUg0lXgaP8JfL3rvrz0qatEc5KYAKm/KsY/g8WMxJwqOhRrD0kxZsqA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026, at 22:52, James Houghton wrote:
> uaccess_without_mm() is inlined into every user copy, including every
> copy_{to,from}_user() call site on architectures that define
> INLINE_COPY_USER, such as arm64. Each inlined WARN_ON_ONCE() adds its
> own __bug_table entry.
>
> Keep the NULL current->mm check inline, but move the warning into a
> single out-of-line, __cold function, uaccess_warn_without_mm().
>
> The trade-off is that only the first offending access in the system
> warns, rather than the first one from each call site. The stack trace
> still identifies the caller, and the access is refused either way.
>
> Compared to the base of this series, with defconfig + KVM:
>
>                      inline WARN_ON_ONCE()    out-of-line warning
>   x86_64 total       +5,884 B (+0.014%)       +9,714 B (+0.023%)
>   arm64  total      +40,948 B (+0.10%)       +24,609 B (+0.06%)
>
> On arm64, this removes the ~16 KB of __bug_table growth, while text
> size is unchanged, as a call is the same size as the inline brk. On
> x86_64, the call is larger than the inline ud2 and causes more .cold
> splitting, so this is a slight regression.
>
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
> NOTE: This patch is included for reference only, to show the cost of the
>       inline warning.

I would suspect that the growth is larger on architectures that
don't implement __WARN_FLAGS() but rely on the generic WARN_ON().

This would mainly affect 32-bit arm and mips machines, some of which
are very memory limited, most of the 64-bit architectures have it.

      Arnd

