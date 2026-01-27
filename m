Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60161D2D8E4
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 10:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA0496B008A; Tue, 27 Jan 2026 05:18:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C746A6B008C; Tue, 27 Jan 2026 05:18:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76A26B0092; Tue, 27 Jan 2026 05:18:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A87686B008A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:18:05 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54CEB5C35A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:18:05 +0000 (UTC)
X-FDA: 84377343330.27.44C1245
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 699EA40006
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:18:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yG+o9E9z;
	spf=pass (imf01.hostedemail.com: domain of elver@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769509083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9eWZA1QTRdZDTddGYL8SlE552QBQW/sLGGoi37wJCfo=;
	b=ylXEQ8CLF1t1RVWT2Pv67tj2D1OkRtHq5sK98XaRuspvU3GzgqOIvdISaxbTEdsumQJWVq
	Nfd1uy9P0nrbwjz68QFPmWg9ycEnZYsyV7V9IGc7+wyqek8jqRtC6UNGcEzQFmxxfGCTU8
	DzAgB8hP3m4LpZIxThKqawQBNWG0Yw4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yG+o9E9z;
	spf=pass (imf01.hostedemail.com: domain of elver@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769509083; a=rsa-sha256;
	cv=pass;
	b=dqbHTYtyRmyfULFx7ZtaoJ4SRz2+k/XjEESiW80o5w6rahDu72gy9P9dBesb1iN0vnTZp2
	8ugmUMPfYVyJMkJRRwn2fDJPe3zZ/Am82Jfjinr6HqC0HWsNm/CSwAwIjSkOFaxOL0iyQk
	Qr4FzkAOGoLOU+6vr8FO23WHWvx8pRg=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-12332910300so2129450c88.0
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:18:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769509082; cv=none;
        d=google.com; s=arc-20240605;
        b=evYAGduBAHFPxIWl716V2EuvNo/JNsM0aHQ+7KHRc0hsMWZVxmX0ezzGUkiSBhTvPV
         iLwlUGmSy1JKkzWtFI5z/CMLMqJuJ7R2sBbXe5jizzBd7UDX2jpJFs1H1cVJ8+kqBoLD
         YfZxtMwzcZuGrji3t926i/ORgf45JLnDpGP6LoEymOTqBrfPRpvakS9Dwv/DoRkP0SNN
         Kkjwv6twJl+ULpYaeQVG+WWtsca7N1R5TYbDjiqFsRHAM3wNI5ObfzO3qQmEv0+r/vpR
         Q/7JRkNnXlHk0nFnU1/XlGb6o3AHbn9fjCwtCImPFcvYv5q11KafsiC0BCSk2HIpnEMN
         w/Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9eWZA1QTRdZDTddGYL8SlE552QBQW/sLGGoi37wJCfo=;
        fh=kr492k8kqB+Z3C/06prih+MX60idkIaeVF+GJB8kF4w=;
        b=NgwfxG/euUn2srBFuiKWnoyawFhFzE6rNM6nDPLcfvHpj5LbTLBuHlYV/ejZEY4j8X
         P5HcF5fcHKjzf9V6qGmu9UQRRvM3yzd5eSYcBZVaDuz6foZAH+yn+py3hG/ZIuGhKyRq
         wDsXDoEqnowOvxbB82ERwgXmWGpwQ1/Rcp7Ooq+k6m/NTh4YrhfhEt516JKlgPVgRyAP
         dN9SvCGD6UgGK90d8eDEP1c91mSwc5qeA7ysp7GJrA5YECdcm2yX2aHefYjna76je/Gp
         39Trlfu8XdM7qr4lbEH1rGmIWf+qsdb25rYTrRqlEtcbKVx2tdr8VMFvhvDCe10J0GPD
         fwBg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769509082; x=1770113882; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9eWZA1QTRdZDTddGYL8SlE552QBQW/sLGGoi37wJCfo=;
        b=yG+o9E9zACZngVvK6NNl0ZdgYqrGjL10M7JLuSRmNSMABBPtNKHzWSNcSZWi8GcWwf
         +R6g7/IkhIa2DvLXNZnCw7OJ3ZNqF5jVvsmVO3szt5m/y1wZnEA4c7Bds8i034kYRMwl
         Se5eM9oiU2MZBuVADgoewwfYM5kwu0kYxIiXI9P6Uj6SL6NRd2Xxx0I092NYzVhRrb01
         R+Swx+wK6YISwMhIVCeoHJyZTySXJUWnECrzuOXw4982gNx7wPMa7MBASdZALbjqWdTi
         I52nEixZtW21IG1ApXqainhBnoRcgzEOf+SUBFZsHDgMVe8QYoBe6ZB0qfOlvr90C1sc
         VX1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769509082; x=1770113882;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9eWZA1QTRdZDTddGYL8SlE552QBQW/sLGGoi37wJCfo=;
        b=k1Pv9plAoKadAjgMVEPUmOwrDmJmfzIFeY6KleWHGeqO3eF2RUMUAJml6kEbuzhzUn
         8VP+F21OKxcWDdKYyudz1slNyZ7BSZs50pDMPCYisAR/Q+5mNiHqytdNcjVKwpvJF+QR
         PhBJg9IwN4vVfd6tUT5wIlhy+NRA7uDRdNd4Mkl71AW6CI48QUKNyDAzKcVwtN3MDxht
         cWF77PNz0xd4oJ4e0prUEUrYHDBgxyS3POmzoWoberqB+BYULDPTMPXSW4DoGLsUTebU
         1EqgAjsE35QDh5q6jzSywd9ZbKXQXYeV9bfhqiN/QGZSNNhz6uXzocZJaezk2jtYTGF4
         ggRQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/+vytT4vq9v+YhlLRwN/IBc0aTu1QlTQBVcVf9xT7Sp5T0pElJ2yDk3FskiRSjD5H3yMdRSFuOg==@kvack.org
X-Gm-Message-State: AOJu0YwJj6B/3zo3oyLr6G39uMzsF/F/W5e2RQrRk3J4vwuM45cMk4AX
	sKaI5ZPZp94G43FsRwx1C3vxzp8XppzWFzOb/bPpnK+I9e0vPJ+GAjj0sb5onuf88DaPXFC3wIQ
	uoOCZ8BBS5pSmer3G3w628ahs6Thv7zXC9fnlbt24
X-Gm-Gg: AZuq6aLvRTk4iUN1C+I1NpBpoc94ZKKjZd5Si2sCBMFUMhjCEBhFvCTPezfWc489UDP
	QbmrmCBKzABaGCg8vFU4PhRRYAiQyYHvnWiHLNlz7ILZCgeN00tWc16LNzMBEtXoS8FJhLQofTd
	mymCO1F0I9nikB/OKZlCxOTxuxXy3hAW1ZF/hrw46DoKT+VEboqAKwKvsjvox1+O1QbY/iEQPtC
	XrkwCbEoXCcsxPPgSdGvI5Uxz5WzFT2UHJFl3e4NAT5L4YwdzFq3E1hmfQdYC3aysGs3oxjyZeK
	uq22LEda7/xHCe2OQmgRDJhCCQ==
X-Received: by 2002:a05:7022:6985:b0:11e:f6ef:4988 with SMTP id
 a92af1059eb24-124a00cd55dmr806676c88.36.1769509081547; Tue, 27 Jan 2026
 02:18:01 -0800 (PST)
MIME-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com> <20251219154418.3592607-7-elver@google.com>
 <0c2d9b69-c052-4075-8a4b-023d277b8509@lucifer.local>
In-Reply-To: <0c2d9b69-c052-4075-8a4b-023d277b8509@lucifer.local>
From: Marco Elver <elver@google.com>
Date: Tue, 27 Jan 2026 11:17:24 +0100
X-Gm-Features: AZwV_Qj2UVNnjgQTvKRMxq0N2rMz8K4yMXQyPWTkZbJrWul7iRYbem2vd2u4cZs
Message-ID: <CANpmjNNHmOzaCSc9hQJNuzNVHXA=LRgXB4Q69FNk6wBuuJGdAg@mail.gmail.com>
Subject: Re: [PATCH v5 06/36] cleanup: Basic compatibility with context analysis
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>, 
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Stat-Signature: yozdbst7gezh1kaimi5wwz6dfk1ifn9g
X-Rspam-User: 
X-Rspamd-Queue-Id: 699EA40006
X-HE-Tag: 1769509083-384885
X-HE-Meta: U2FsdGVkX1823SGRRrSFyh1oJWUBV6WxzoQ2IdFnD3t5ES1cvmmQvqkShNouzaBm1SGNdDdxYn0JkIQLFwXTWmnNHHL4puSXUWJGfWiNwqZW4bCyoAdzvILYX+2g3gvENUNN13QZFvUl6u3tyciGk91/b+ao6jl8mA0rhOEIKWYris4gQz/O0ubKc2kITyFDv78mcTEjsK7HTNvWXsMEI+mjlX2+iQGVGgUjD9SIrqgo+V+DvpEqGQ/wH2U7D8Vsw8DOShC179cGemnukzkxAwbMHMDNSCixBhZZPbneFVU1ezeimaMaU1VVI56hCDNTl/hfsDmChotCtLFyX+Gh5wvQ22zz7+/zAcX0RgrfzRITdZLABTKfTOCZLSfYcLhwPMhovpka49G87JLPqKp3yolEqxaG/NiTQmP7udFkImzyvRNECBd29obf8aIzeXHjn8WNAsk66S6aLETc3WV+UugPf6LlROyPTuqS5xkPPZvtzsNQVlv9n6DmezusjNP0YzKYcftVG6kYOooOkaT3Czo04C1qF5hiQoDzV5oq+DY/huN7fsHp7R3Zxu8O7ftKGH2jjAYIQoZiONJCmI/pcOXVJgsydPoc6geINVdKwRixFl/FBECbBc69qXwsfVAO3FleP226J70cRJJxBRDVvcuBFdbWBE9Z9Gui5/K/S0CqUY/fKmAx4oAPmSIQ7l4OBKhMzNcN127DzNItyn+opw+Ys00lsSJfN1u8WtDmSRNZv6+bB3n68mNR5oDSFhtDoyKlr7HwwaiSuMZxw784OOSZg+fcg68Wvi1mA6muaEaunUD+CrOgjYQK5EQWqDAGdFYo/OMGeMSFcPIdNAjiU+UZfkEhU2OBaD66I98ZRo7lbbQnsyvIvIR8RCSL9gl1rGMBsWagh771xuuVhtwgGjt58zkiPwAuKJoGIKaWRdjBJnzpYV8SJQQ0+4g8L3BAwypapXpKu6Davp+MYZX
 utFeBmvN
 mc9+B/PeF/Sfd5NqbqfieXEZD7bsEsHlVHQOATl8ut2uHhQxfoX33YEjXDVIiNaM4uRhgqtWVgeZur3GfI/bdlv4LHjSk+rnxMbblX0iymfmjaQyymPRxX1hAf7YPAYfjPDiBNiNkex3R5kWA+coyTHrJBfs8XeVrhhrSW/QFo+E2MzbObmtl4vlsohv4i2VgcbCbtDN/bG/6qCdqxo6vFyDZbZnnuuO+PcaUS3H50TYPM3H0UHl5E/YdE3scKaN9jTZM78zFLUoNCxfqwC1hPmThw5Ill1OdRIleDeKaV/Z4ffo4hfVal391S6JgTgypL89Y1pWpl8xWjyMvi3y4h1Acptj245CiUvBkyXwPpVD6oRNJqru9FRfmBV7OP4S1TRpS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 27 Jan 2026 at 11:14, Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> +cc Sid for awareness
>
> Hi,
>
> This patch breaks the radix tree and VMA userland tests. The next bots didn't
> catch it but it seems now they're building the userland VMA tests
> (e.g. https://lore.kernel.all/202601271308.b8d3fcb6-lkp@intel.com/) but maybe
> not caught up to the issue this one caused (fails build in tools/testing/vma and
> tools/testing/radix-tree).
>
> Anyway it's a really easy fix, just need to stub out __no_context_analysis in
> the tools/include copy of compiler_types.h, fix-patch provided below.
>
> To avoid bisection hazard it'd be nice if it could be folded into this series
> before this patch, but if we're too late in the cycle for that I can submit a
> fix separately.

Thanks, I saw. I have a more complete fix I'm about to send.

