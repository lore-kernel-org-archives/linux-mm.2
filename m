Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A5BEE668A3
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 21:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 560726B0096; Fri, 19 Dec 2025 16:47:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50DCC6B0099; Fri, 19 Dec 2025 16:47:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 419E76B009B; Fri, 19 Dec 2025 16:47:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F1EC6B0096
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:47:47 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A8F201A029C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:47:46 +0000 (UTC)
X-FDA: 84237558132.08.228FA86
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id CA8424000B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:47:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kO6mDNcj;
	spf=pass (imf17.hostedemail.com: domain of elver@google.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766180864; a=rsa-sha256;
	cv=none;
	b=aQ0PHyJmSIm65DkoEQpGswfGdlcwGqFD2cTlStG8gxmjHmlHRMo6cdSQ9x4GFRjxljvIrk
	CICmsJjBRAQMz2wZUCeWR4/9AfkM22FmAe5u81stvPbyRsFOX10ENm78Fp6VYSUZyXBbJh
	4KLXGo2B2VSlOgqVu/JpN9UKTKZth7o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kO6mDNcj;
	spf=pass (imf17.hostedemail.com: domain of elver@google.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766180864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ms51wSRYcNMLU08U6XlitTxavoeEVdn7PylZ66BFoeI=;
	b=d27ftdI0uTFwEcvxkOA2SO/JTFX3lwtMwB3jssOJwIiPa4rTlyBLlKsRrNjdu2jbRGWUzD
	dCB8zgqqj1JcRGe7onC8WTN7eTKIvwxXXOM/UEBZWw/pW0/PGtRrqrPep42PJF9Xwoe1S8
	m+SEDY6Yzgb9/5xXyzwqprGscpKw7iM=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-bc17d39ccd2so1358949a12.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766180864; x=1766785664; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ms51wSRYcNMLU08U6XlitTxavoeEVdn7PylZ66BFoeI=;
        b=kO6mDNcjN/dLwdTk9d6bj6/QBEjKiNEhNX6axgpncjIC20fL6aFz9AlV5A3lx1ufPH
         4jcilWPmPtHt+lg9ngCiGIzi9XIeprNub3nra78UdqOl6w4fZqp9lVsVTqu0RLUdDCpM
         AjKLKTem/YxMwGrB0dTlHXFWOJZrTo9uE2edlhDQKljmTTlbC0rWALsbI/v+g0ErThZ9
         mb877J2G68KKAYbsLXKhfHjrQcZWQCKvlv75OL2px+5pR4gWnHV6B78f0Mc1VuAX+PyA
         iBOGlCysmwF7UXqCm8Uj5jgPlhpoY+J8/8pETb9YvqqGQ2bigfuja+lEfaNRiydJgMKp
         Uj1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766180864; x=1766785664;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ms51wSRYcNMLU08U6XlitTxavoeEVdn7PylZ66BFoeI=;
        b=WBAzf5G/chnl31zMYDmhR2RtCqsIdScfxIi4vh7zc/Lvh6aCrpeF5pgRkOtQMfAHuj
         sYtqmFmBHzkuDFMdSApE+cZCfV9dZOQhgKdiksJgin28l2vhGerevN9/hTkb4xuwWi4z
         PSRnE6Tpw2v2eIRjBHcC4jX1diDsliCAwO+am1UE6qKhazcabuMhDC/1QehGqs01OAJS
         4dyjBXykCF9HRpsCEh+ANgP/T8hKsWiNhRYD0DCdfQxqjQ2bZi+nZmAvq3vS5+WO9fAy
         6smoIZQS/p0ZJxfhcUpGAo4RET91WuAtbg39bb0ebdUnf3RL0rppGUp24G3W4CjGbdhj
         yYxg==
X-Forwarded-Encrypted: i=1; AJvYcCXr5m5pOfqAR2QDAkzw/tmQ04ioSSY79I3671lCerUzigKOnwafH1mBF3vthJDNhQ6VNwZ4QgHTww==@kvack.org
X-Gm-Message-State: AOJu0YxnYk+rpH16Dotq9sZU7oz0IMTg7dcBfFQ6M5DHg0ALhMxdStGb
	9yiufFiVO+ak+k19eKJ4IvK+PDrBisQVsaWHeNSCir2C1VvLYqdG/3SuL92m3DvuJrNv2fB9Uh8
	W+B4VziFrmJAYFlrEcucdbNHimS5LVLXvUTS1WVNF
X-Gm-Gg: AY/fxX7q9XpGmUcsb7+Bbku0KWC44sTgDZoFTqFhK1qfuHL0sPQdLBdsDvxkL/xV1ix
	bdQjIDnNaP7/wpzFWIgV2iH291qe20qqhOdQgJMwseoeM4cb4EbBQ7jXzzL/jyFjgRMz5KVIYOa
	Yxe6B1eSN472bI1xVYh8Mk2thXX4Bi+KOpp2LuGEozojaN/RX2GIc9nU7FZWrMYi55KpXqFlmOl
	txCJIor/KDSn1Cmi4D8k2byvunvTKy66iYfVx+gjkETofdxiXYM4l95NM6SuxUy81LJWRhD47h7
	1ssRbosr/24X9falj5U3I19ATFk=
X-Google-Smtp-Source: AGHT+IFIxJn1IGPy0nHsxYCQasesjc20OB/If1nT0iJGZS/3DeBiPOVvBE4Lni1iekMVipiY5AEcIb2ButU5L5/gdvQ=
X-Received: by 2002:a05:7022:5f0b:b0:11b:9d52:9102 with SMTP id
 a92af1059eb24-121721aaff1mr2914480c88.6.1766180863274; Fri, 19 Dec 2025
 13:47:43 -0800 (PST)
MIME-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com> <20251219154418.3592607-8-elver@google.com>
 <cdde6c60-7f6f-4715-a249-5aab39438b57@acm.org> <CANpmjNPJXVtZgT96PP--eNAkHNOvw1MrYzWt5f2aA0LUeK8iGA@mail.gmail.com>
 <ecb35204-ea13-488b-8d60-e21d4812902a@gmail.com>
In-Reply-To: <ecb35204-ea13-488b-8d60-e21d4812902a@gmail.com>
From: Marco Elver <elver@google.com>
Date: Fri, 19 Dec 2025 22:47:06 +0100
X-Gm-Features: AQt7F2oOvMMB1QIst16kG-Ehhh_fmZRMYn3rIRXwuCNiu1TQ-QKGkuW-c2bqFwM
Message-ID: <CANpmjNPp6Gkz3rdaD0V7EkPrm60sA5tPpw+m8Xg3u8MTXuc2mg@mail.gmail.com>
Subject: Re: [PATCH v5 07/36] lockdep: Annotate lockdep assertions for context analysis
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
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
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: CA8424000B
X-Rspamd-Server: rspam04
X-Stat-Signature: 56zicmrhez9w7roy9rdqexy3trtkket9
X-HE-Tag: 1766180864-976639
X-HE-Meta: U2FsdGVkX184dEwzJvoGpponQou9fJM153KehsfZAIMYQyT9/h8rW/YhPoNJMjEOK4Deu5k1Vc7Vo5ZvgSKQ9OyjaX00SosJb98lqZfwMSQj/wDWaAluGqAFKMZNz8muhZhrqsKBu5oB4Kkm0ooc09STpjrtFKllEtO7Wk4BMGimGpPKShSxSd9G59faL0il0CQ64qMec8tJKlr17uokky6XQBK4S+kYnsSOtaf8JxF57DNc/vOCjCAPXJindhsz13dqe0PyTKAQlhDC3A3rGK1zW2KieetO4Dmq/MSXkpoDhl/o6P6oyCRbvPkcxCoGVp3rnKx1Mx2e/g6PhtDQ9ug1Y56ddynwk36dkWsI74glWSPjyq5QmLCAYFxzwNqJtvD6wrnWvpVCYDMLuhWCpdyr4dhot8iikFy4Q0zMZ4dsndcuF4niQtJsq5+fvSf/ES5qWh8aGdMCz7XhR96QUqms3ojxtvvZTOl+wDnLeXTd42yk9HZ5RlwpLMCcw1m3fvbqAc5QaXIHokwpUtPMr25Avz///Z1LKZHhA11872JDLcZbgQhLc1fdV6upITfcp/eNFITSD/7ZVsc6hdTs02a5ux1tvJbhSjEBrrA/7yIlvx+jhk/tJGlix5erzwUUJ9PqGKktbcSgKrvUC+/OOflY0BB0EHguW9zhpfLBYQIK0gXC2ijaDLrc0ZzK8wpCud1h1AimShkCxpKU4ba6Wag1KSiY1bjUuqEpTWrW01rDYcCNn0O/fukZBn3iN54cXsFDPmhaTOeSANjtXSJSWwV3yazw0wdNvBfeSo+mOwKSGP7c9bP4uxmrfnpCPLBGE1g5bcvhvbd8FAxD9mmPVMawBDZd885bvsoLQrW5PQHG6F8VfRNX+4w4KkAglwYZbOzSOVPtz0h9yYIIvCW0HR4SY/5txaREvQMHLmvxSP1Y/yhTmvfWD9bcO+2QxvfSSlCrgnGMM1wV+VvK6M+
 CBjO/RGI
 n/ZDFifG1azM1Gw7zaDI9PUSovqPEZrWL/mn3WpK+fDmj2z4XMMSbh6b+VL81UlbPXha4fRLUECfJZAmC1x8TEqGXeDkgtIJd+Eaa/w20IF+SIpz/UgzTTEVLttWnXJV7PxZbM0rG2dTKZPAPUlrIqaQ1igMnCPCcTlOd0GOvnBm5HrprgK4/Lp5BJeb97a6pnQ+NO+eE3OfI4mFMnszSPfkluQ7Vy6SawtAZj8EWH2QX4pYG4K28gyZgeU4oHhdwUT74hjjE3JghMU2P+DNU9qPgd7VgMr5ZzY39oSEtg2omNY3ybgW73id3KPiOIfOgXqWJjHGngb0jkvcspEJWbi0RCT8X5/RAd6KC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Dec 2025 at 22:28, Bart Van Assche <bart.vanassche@gmail.com> wrote:
>
> On 12/19/25 2:16 PM, Marco Elver wrote:
> > It's basically an escape hatch to defer to dynamic analysis where the
> > limits of the static analysis are reached.
>
> That's not how lockdep_assert_held() is used in the kernel.

Because there had not been any static analysis like this, and dynamic
analysis is the only reasonable option.

> This macro
> is more often than not used to document assumptions that can be verified
> at compile time.

In that case the lockdep_assert can be dropped.

> This patch seems like a step in the wrong direction to me because it
> *suppresses* compile time analysis compile-time analysis is useful. I
> think that this patch either should be dropped or that the __assume()
> annotations should be changed into __must_hold() annotations.

If we drop this patch, e.g. the "sched: Enable context analysis for
core.c and fair.c" will no longer compile.

It's a trade-off: more false positives vs. more complete analysis. For
an analysis to be useful, these trade-offs make or break the analysis
depending on the system they are applied to.

In the kernel, our experience with developer tooling has been that any
efforts to reduce false positives will help a tool succeed at scale.
Later you can claw back some completeness, but focusing on
completeness first will kill the tool if false positives cannot
reasonably be dealt with.

From the user space world we know that "assert lock held" [1] as this
kind of escape hatch is valuable to deal with cases the static
analysis just can't deal with. Sure, here we can make our own rules,
but I'd argue we're in a worse position than most user space code, in
that kernel code is significantly more complex (which is the reason I
spent over half a year banging my head to make Clang's analysis
significantly more capable).

[1] https://github.com/abseil/abseil-cpp/blob/a8960c053bf4adadac097c1101d0028742d8042f/absl/synchronization/mutex.h#L210
(ASSERT_EXCLUSIVE_LOCK() == __assume_ctx_lock())

