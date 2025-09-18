Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D52FACA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21CF8E0146; Thu, 18 Sep 2025 10:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF9EB8E0145; Thu, 18 Sep 2025 10:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D36188E0146; Thu, 18 Sep 2025 10:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C3E0A8E0145
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:31:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78BF01601DD
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:31:36 +0000 (UTC)
X-FDA: 83902609392.04.B364BAB
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8DAE2100014
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:31:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eqsnGJA3;
	spf=pass (imf14.hostedemail.com: domain of elver@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758205894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7wpgOqV2jwxbf7nUbBy2XlSiAc50BZhVeubzU1uvBU=;
	b=Rw8jp8iEJ/HbvZ9U/tDiXztCUc3PbeR7pf6Q419XL1X7poL6aUD3cdOOVttcH2lniwwvHS
	PvA9Gw/6zLDEnj3jYFkBFI+My5plFIWeZdhaMWe0r4CdTG0y6xcje8T8Ptu5ONPzXLp67g
	L2cWQrNVozu3qjLxw/HhPN3cKwmeRKg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758205894; a=rsa-sha256;
	cv=none;
	b=cgkj9PoLuFrIFZ9InuZjdzZrpJYdac7I/dkZ0RO/rijH+Qbgq2SIqDDEVu95OvhmY0YEab
	biH9J0bZEsycEqFvWbAIRNarbiW589KGOyAV//R3JIBu+F7vhSahP8yieJJxXCsL1B0kww
	32N7/KVdEh/4MM9uTaYUexAu30ep9WU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eqsnGJA3;
	spf=pass (imf14.hostedemail.com: domain of elver@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-33067909400so584065a91.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758205893; x=1758810693; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x7wpgOqV2jwxbf7nUbBy2XlSiAc50BZhVeubzU1uvBU=;
        b=eqsnGJA364q3Ab9oDtZrCFXbIRvPWKjXP5KGrho5audkiO3Br3FQhFuFvrr/pgmK5j
         nPZf0x/eASrdV0CRFh7d9rLyZXogUKEOma2cUWQM69p8sUgEU/eTbHRmsYmJ7AEijfug
         mHT7XddIn7aF9hNjii0H4xcQLTx1kbQbtRCcEMcx9+TM4kl1IucXRqj9niJokJPFv7lq
         PKkYXGYu4dilYp6v4DDERZZlo3zoWAiC2HO1CFd9J4ZWr8zf0ZIatLlANaJAIU3Qzq0I
         PE6zFCst+hhECeViTnEFTu0Ui2JXRHJsrE+I+hN8Htw4CxptGUu6atIRfJ7Jr75iI1zG
         BJSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758205893; x=1758810693;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x7wpgOqV2jwxbf7nUbBy2XlSiAc50BZhVeubzU1uvBU=;
        b=hyQ5exDLgk2d11GXKKqMgx0VVJbj6t6XN4bRKQMdh+wjgy7py4DSwxlklw1SxYOMFR
         gbLL7X7IEed7Uw+RSVfFfMvLk0UGYDjXeckQfsh3TLeXm0awY0xSxGZQ4jsDmbpXn2zG
         lZNbuTubc6cH9E7rjq2OrvZnAytO4sSLW5MlxXNCPz1dbTPtbuzbK2O4BYNWrI3bNjJq
         ZUrBoTRv2AAuWsCMwYoDY86IrHn2gkay6NcOXZDW+K02TMP7OqrrtgoqkvKIa9/iM57C
         SAGXqH+Njogx51A/o89CZpcTN1ubh1P6ETDAaQmpOMoq0QTyR3wudClMubFDDEWayoEB
         IPsg==
X-Forwarded-Encrypted: i=1; AJvYcCW7S3Lt0Rr3iEZfc3QTwiImH8pNI12CkbypUR+1OOJfVSRgAa6YCjeEOxo5UuTkbNPpc54Meel0Mw==@kvack.org
X-Gm-Message-State: AOJu0Ywa9f5+rIXSewaKKuO067+8rgL2i6hq73n8EHB7fP1DbvSUwehy
	H6nxJlCjErrvGPMTf5NNG8lkkdHEIC6Y70ZLa2GdPCnlSGt6fsFww3THs2DYeqS2Uk3UnR2ronb
	QoUi63HDoTvQERb5dpaZtRHoLuNz43Ft/fYfMb2eY
X-Gm-Gg: ASbGncuNVPLytcn5nzA9NCr2UsFfL1eUAmQ0adpDEUkI00iZPa25i+WsvruSD6McHRJ
	V7QMIv46bXqU5I6/RfbdBIS4hq6mDH30n7RzafP79GTGzdJBqMH7ByJKGwx0bzRrBymsMSWn2NH
	LftpsjGdI0apdOJCIKSRsv2maKZfcDby0DBFd/XYSoWU21zuhrDeehzsrfDJQXCZaqMbFu6gnOn
	CrcwAFDDwO2lO9EkX35J2yg2pWOCgBFlJG1Gti2m5rLHNB9TYV5psrmIwhSoA==
X-Google-Smtp-Source: AGHT+IHYGUcixIR/dwWsgGEgFB1TOwlgrZ0O4FlqafV2iJGSlcEq1KnUzPyMPrhTBrvu1VqtuDJ2xHHxKwyBuVmjxY4=
X-Received: by 2002:a17:90a:e184:b0:32e:b2f8:8dc1 with SMTP id
 98e67ed59e1d1-32ee3ee55c5mr7425841a91.10.1758205892532; Thu, 18 Sep 2025
 07:31:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com> <20250918141511.GA30263@lst.de>
In-Reply-To: <20250918141511.GA30263@lst.de>
From: Marco Elver <elver@google.com>
Date: Thu, 18 Sep 2025 16:30:55 +0200
X-Gm-Features: AS18NWD0SUeFqGV9WlY2IdwTn_KEVlrUb6EWkUXQGUd586AZF2O57bI6Ojf1TCc
Message-ID: <CANpmjNN8Vx5p+0xZAjHA4s6HaGaEdMf_u1c1jiOf=ZKqYYz9Nw@mail.gmail.com>
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and Locking-Analysis
To: Christoph Hellwig <hch@lst.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, 
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
X-Stat-Signature: e6p917uzb9gdqcwcp1ogrkcztykjadyr
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DAE2100014
X-Rspamd-Server: rspam10
X-HE-Tag: 1758205894-666509
X-HE-Meta: U2FsdGVkX18qWHPCt7bWxdxm6gXM1jZ8sgInMrovZU+VqWIsols4xUzZVWUZfvHNNFURskTTxiShg/B7dJ1g5onRceIPtIHf1Cod2XH3w7oTTRxFP79Iemcm1PhEO0Nuuy8NqVRoQnM9w7x/xTPgPyK2U1xhqZJJn8jWeWMGl23qB1zD9OLjccywwhiAVRVTHeBSm8f70jYC2rNq1XYbIEUXNe3fKWZKbvul8AApOhEr5sgT+ysQ3xN7xGOCqk/gEg436EtxJD7GR01WdAVSg5NgsIRLI6zp7kqJwWQESXl9nmdG3Jnl+W0U50290zmbt6dmgt6PeUrA/mzW5+TykVQ+jxcagEb+4mDg9tO3QfANNa5ZIdnOcY7l4WXVVUHkaXT46yMIXqTInH243QOrRScMU0zLjUTSi6NjTgjSjFwnIxLPJ4DZUumR63/AMLiGU03eFsuLXRS7sg8qZfdbbLUsY+l42qhd5IvOBxqV3eVNchd8OMv95KzzgQhZ0I4BoG9iRKg4LmMBmOtIhgwefw1Sn98uCJqpweC8jWL5oUwt5TnhJnz4kYLZMzLSbHCjcEEbvqXNYnKQgioOi91r13BF+/u1aY9Qkl83UsHk0NR3h/Z8lPaU5juoUrVkvpmb1yH1PjkEckmwIH6HaEDd/OTAlhmi3MMXPkMWJgTwr0LOUGVxJ9MWCqEJCC51PL4okWeVOVgHY/nEATdn+DlnNxDpk0skicgtBU8llGYW9QPDZLHOXbD4pdygPVgioCA9a9lg/HunEnSdi03xWDIQJ5aFCo6Ywm/kmSYvJf1pykRLJhi+5Jn0J+dCbfFHsVXaZd5rmoMlslt3Jc4XvRliyLPAPaTylLcgh38FaG3SZO4Cba2rgMPKkvkOddTNXpYBhludozmD3JBIopBEIYRepwLQwuJPanBTzU8AY5cOUmm4e1w2l6AaiFu4kn7agta7cKSh8HgWgnITGBOJEPS
 QfFlUwMQ
 huaMH+zQiDJm4mhygTONDBprCeIPCLL5GVDsKdUTXHQNrImlm/JlWOlFDb0MfVBVjRdxW1qplMUbKFrRWF6d0yFHKPYDq+E9eHEuSS63BaUNnBpuXHztNiAwnY5MlxGc+BL+zD5rqOIS7j+5zmQcs1iBTJsUFCOCRAIISEndEyXmKxWILYS6WdJpwehZbYlXcV/BJebRIlBDm7BJpRBo3R0y9DPf9iY1U5cRcPbIFXqvMgjaJbKgpPVA31eC8wzVd40nhQgNJdHqIqLUMgIwuo5bKAXJmwjeIp/C2uUlbg+84ohw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Sept 2025 at 16:15, Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Sep 18, 2025 at 03:59:11PM +0200, Marco Elver wrote:
> > A Clang version that supports `-Wthread-safety-pointer` and the new
> > alias-analysis of capability pointers is required (from this version
> > onwards):
> >
> >       https://github.com/llvm/llvm-project/commit/b4c98fcbe1504841203e610c351a3227f36c92a4 [3]
>
> There's no chance to make say x86 pre-built binaries for that available?

Not officially, but I can try to build something to share if you prefer.
Or a script that automatically pulls and builds clang for you - I have
this old script I just updated to the above commit:
https://gist.github.com/melver/fe8a5fd9e43e21fab569ee24fc9c6072
Does that help?

