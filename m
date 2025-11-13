Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 393E4CD6E71
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 14:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E92D8E000D; Thu, 13 Nov 2025 09:30:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1088E000A; Thu, 13 Nov 2025 09:30:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FDF58E000D; Thu, 13 Nov 2025 09:30:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6EE1F8E000A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:30:48 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 10F281A09BC
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:30:48 +0000 (UTC)
X-FDA: 84105820176.21.B58309F
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 295B0C0010
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:30:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SEqkZFNL;
	spf=pass (imf10.hostedemail.com: domain of elver@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763044246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MBXryWsSo8WBJYsfFQQsezl+bvHfvcNsNG0PI/C7tiU=;
	b=Wr5b4Bm/F0C1CvR2VdU5kf5qdGAUUm+ihYcNltAdyx12LdLJboq0NHy7GGAE7OuIl/Epsq
	elDib84Q1+i3d5zgS81ELoR027Pj5sikpRF3PmMNKALDtfi0zZ+IANL6qsE+x8iBLLw4RL
	pNIMVn5INd9zuE3hIHtOBucpGU7N/Gs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SEqkZFNL;
	spf=pass (imf10.hostedemail.com: domain of elver@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763044246; a=rsa-sha256;
	cv=none;
	b=3Sk1TB4ki6Jd4KgCjY5dAHsDgCJJ0oHkLZsjjZ7Xgr+APA5BrHPT2tRHjCFYKq7HPULO3K
	5QCjaryERqXXCkGPf2X7gn8h955NS9lhn1YMdRnJZsAJF0TOwlLwFS7vpNiXzYJL8LStXU
	7iAI4iORsef8z2IP5WESbE6Hfs27bNI=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-297d4a56f97so8117005ad.1
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763044245; x=1763649045; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MBXryWsSo8WBJYsfFQQsezl+bvHfvcNsNG0PI/C7tiU=;
        b=SEqkZFNLvnoaCs9OKtW9oyI9sXcpuawWNxy41/iAtrwpU/nQtxPYCEEb64BpEClh9x
         kNYEz1GVvkWYJeQ9x0m8TV7dPsFmtSSeIaaWhrCDrmy/L3sEdxVqh/l69epXYJn8jlo6
         rlur6ByBX6Ldn7O0gH6NPoOU5bN1alrgSKej6k2fsYiwTGOnQxLAwNr5Ynj1gjCCpNnE
         +FU/ZCFmT++S6gMujcqibfnbRuIT1yLG4OME/qjpP+eT+qLpEE2NZiMjwORkwhL6QIXx
         6gAQGzdpLerE14l8Ur4+0qyviZKfTgpZdqj+CbeT3nX9tDAxs82NylXuIiEjgMi5KnwL
         1ykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763044245; x=1763649045;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MBXryWsSo8WBJYsfFQQsezl+bvHfvcNsNG0PI/C7tiU=;
        b=Y2i3Ktyjwy31cbmGJlv66BIG+hzUxfGztx1/0+p4/9EApPSfm7/Cx2B7NS00V7XUdh
         TO8IgyAKUBp2F/XftfwXmGEYmMNNjio/aOrQdVywbJ3cLowqg6QeQbZGeE3083w3MI+P
         QaLuLbVtaBWL26Pprc57Jjey1q91cSmWg2M52HB+7nyVCJDBRWyAdUMIoN4Wmd9zGS4B
         3tIvbDyxBH3heCO+0KOiZ4PRq13M0EgwnxklDwfLSnz+nxsSFV4roG4AiD/sHZj+o4Eh
         lJujSjkvwZnN23VaI3iMFb/I2vlEcg5cs2p796Icj9Bof/vM74f9qn3nYI95c1rjfs2v
         DaCw==
X-Forwarded-Encrypted: i=1; AJvYcCVIscwwt2hHfOQC82Tj3gX9wfuXD5xYkYzWn5/Zk46zkjxoeW6zFj4kzyy7BGJPq7wTklVkNOJ8zQ==@kvack.org
X-Gm-Message-State: AOJu0YzR1G7UNCmctuUEPR8ACXfiFT/dxQfnzhCdSvpp+BVqCm5u0Fa2
	H7Mp5j3ukj9GbBdCAp2M7JjmnH4wa31IRIV5aqJd6bvaQm3wIxcvNWWGOmdm1va96A/Ullp2FRI
	BkHdzZkEFMuG+wkBadryuJnhLXPHkoU5u2TnEq51i
X-Gm-Gg: ASbGncvYtQ3leonNaNre7vA+hwhZR+mrlf563/9BxCoVvC+FvI9mN2CS35MMnU44II/
	9FP9bVFpTNLEH8bB+bcITtWB3tHvxcSX/IHYJNrhFFdF4OwbkiH+NKfqDu3tbzOZogYvw3FXaus
	6c5j6WqrOvNs8LevTyz40X1cvGJmOfcNAy2rgOZNcToxmRK09XWgOqv/wG0XzX0y7aHkR9qO9L5
	Wic+coTuIUcPhvi964Ndb/bcc6710WiqgpiQ5WW3MG03lqX/ykg6FgnMvXJBogQkk3vlsWzs80W
	SRwY5WiabP192e97yMXX2yQ=
X-Google-Smtp-Source: AGHT+IFnNFIlMm9/L/bcyHMVah+51vkdm0T/jdjxqhLQ7LFy8/zaHzLzvotK4qxuC0MECLmidBODybpZNRr9UFx4Cuk=
X-Received: by 2002:a17:903:fa7:b0:294:f6b4:9a42 with SMTP id
 d9443c01a7336-2984ed2b5edmr67173465ad.9.1763044244630; Thu, 13 Nov 2025
 06:30:44 -0800 (PST)
MIME-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com> <CAHk-=wgd-Wcp0GpYaQnU7S9ci+FvFmaNw1gm75mzf0ZWdNLxvw@mail.gmail.com>
 <aMx4-B_WAtX2aiKx@elver.google.com> <CAHk-=wgQO7c0zc8_VwaVSzG3fEVFFcjWzVBKM4jYjv8UiD2dkg@mail.gmail.com>
 <aM0eAk12fWsr9ZnV@elver.google.com>
In-Reply-To: <aM0eAk12fWsr9ZnV@elver.google.com>
From: Marco Elver <elver@google.com>
Date: Thu, 13 Nov 2025 15:30:08 +0100
X-Gm-Features: AWmQ_bmFh2aVYHZwkaHdVYkb7IeD9B_c5E9TrUEhRxSr8kO14B_rxSCEK8GKI2o
Message-ID: <CANpmjNNoKiFEW2VfGM7rdak7O8__U3S+Esub9yM=9Tq=02d_ag@mail.gmail.com>
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and Locking-Analysis
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 295B0C0010
X-Stat-Signature: warmktfidunf39tmny45xtdiudimsn7c
X-Rspam-User: 
X-HE-Tag: 1763044245-965171
X-HE-Meta: U2FsdGVkX18VDL2p3I5584I3BhRJ1lk3e0gwsn5VyMJ6B0x4r95pjlgYJWcxsfwj5ChjlWSMo5tpxSfuNkOLXTZrAw6ibD8fJY2fzYvRGwtS7d2cxFFFJzJdi6FGanU5lbem1ahCMHai7GWiGOLi5jyfuPozSByZy0bwSBISIXlkGAL04uGQxN/u26rWT1bBPerlmVbK2+rm+ksvyO9+MPiu104U197lVPkZfwxwhdzG32Ju1QsGJWxtzYSNGyzbmBgGpVyqGRZzfMtKnBjZcDpD5G3Ykj4nynbTosu1kccELst1cTUVlz32yI5V736FfIng/VYoEJT/A3YMCG9cu2klGaukuGY39Fp3HoraCNwwSKXVdL3mbamlhVBafoRB/Ri+KlK413Da4/6KdULvLBGs/YBxRZxWnnL2k9i/1ylPCtbw4BykdhbNp5mkXfoMWRfj4uD4e36WMGqS96uFI0MJaiTL5gWpuytoGXHTYjxnL053RSSj05yo7iDyMSSvnyhO608yuLiwC3hmHQSlu7TPuxEyo25A20eQFKs/ALRSjEC5b23G9ca1yxxfVNaAc6DmfWv/iO3TyJ6EbwfxAxGbZRCKSGRUS9w0jk0j/G0XekeOctQrfI/cGBmyyXXlQi5Z674ACWMI+KOZf0liAomvCe2PPuu3aEVfX2AsO/m6liayeQBEf2x60HL6MWz/xR2jJkGpiZtgsbiGdkVPJReReSojmqp51wpPuPy9egXb8zrVBSCQSSkH/2U9O25i3VTMdkRynKTbPfbgTcOD6CdfnVnJckMYMf9ekgxphPOCojZu2iC3+TXX2VwDpIiZtBpTzbZlX9vVbkrIDWYQx/dd0TsXqiZv8QEBSAveNU6ksK1E8lvdsHvpWS7ZNCZen/ZktGO9VbVCL9R2nfg4iuuUpx8Nn8EYkunk1WSQVVelVxQGnLqHXfyhCXe0p6T1s5fzKgSSRK6t47cmOmK
 kr4kKkSA
 F3kQmdNoRJaGAfnUHlwlXNrTxoe6TQ4nIzIfGrZMfSu9Cv95B4nuAEtAADHdL85LMrYQ1JWrzDAuXh5nT4VyDxQg8vsZY59dQwN/cZhKjbgrY0P8xtixT5mCh8dot+Tv2qlGwXPdf8+yEE/HTxLt7XD50+Il3BqMfNzrr+4ho+kdlNHU4zVhxCVqDpQt06H/7LN+rKI2pfURhDWdEhESL3tGQIQL5GvG9A+PcwwMu/nHIUSkg3CpEB8xNgwVnAs1uX7QzMsgrftGlzA+b+H7vUYSEDCAcqOvERGjNPWYWJXFwy4/PNkQBaDP2PJJ10vUKPaVUSTMuTmIzHwfLdJWsaNsKglDQ4eTlU05gdQH9+Ku3wScTKbzbHlupGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Sept 2025 at 11:10, Marco Elver <elver@google.com> wrote:
[..]
> I went with "context guard" to refer to the objects themselves, as that
> doesn't look too odd. It does match the concept of "guard" in
> <linux/cleanup.h>.
>
> See second attempt below.
[..]

I finally got around baking this into a renamed series, that now calls
it "Context Analysis" - here's a preview:
https://git.kernel.org/pub/scm/linux/kernel/git/melver/linux.git/log/?h=ctx-analysis/dev

As for when we should give this v4 another try: I'm 50/50 on sending
this now vs. waiting for final Clang 22 to be released (~March 2026).

Preferences?

