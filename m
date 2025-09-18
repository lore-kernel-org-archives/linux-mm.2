Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 599F7CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 16:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95CB28E0149; Thu, 18 Sep 2025 12:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B288E00F6; Thu, 18 Sep 2025 12:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 847F28E0149; Thu, 18 Sep 2025 12:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 703E28E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:13:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1FCE2C0240
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 16:13:27 +0000 (UTC)
X-FDA: 83902866054.21.0134C95
Received: from relay.hostedemail.com (unirelay06 [10.200.18.69])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3FDD1100012
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 16:13:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758212005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QYza+B6UX/oNghkY805fNwVtOdXsgka//Us/2M2ST3g=;
	b=tzs2AjyZRzFhiYmLtaZmHYcSh/al+evM7djqIDgPYdRqSGVwRU+uPSgq4q8NjxV1KdrVUD
	4H2sFH6spfQE+Xie6wzUEJRzoGYV0vlMUB1x/mBJQu6p3L3ISGPzUUANgvV3me5ltDTuxg
	BRU+FRLmrZoCyXzTubnht6No6RLv26s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758212005; a=rsa-sha256;
	cv=none;
	b=ljdrs/RhMytaEGkjhfvz/Crna4rVbTKsDWjx8XmvXxRsh7twaql0ft8lVbYPfWpzrATf78
	ZVtXq2oUpb7GOHP3pK8JXwHQ5lU7Hi0fapjMEflSUI4tGyC6oH1+itMi1XJ70YyRedW+U4
	mzzDr2ZKLJRt+2yA8mEt2fhRGqOCKGU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	none
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D508118E89;
	Thu, 18 Sep 2025 16:13:21 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id 2846618;
	Thu, 18 Sep 2025 16:13:08 +0000 (UTC)
Date: Thu, 18 Sep 2025 12:14:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Ian Rogers <irogers@google.com>, Marco Elver <elver@google.com>, Peter
 Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, Ingo
 Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
 "Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko
 <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Bill Wendling
 <morbo@google.com>, Christoph Hellwig <hch@lst.de>, Dmitry Vyukov
 <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, Frederic
 Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Herbert Xu <herbert@gondor.apana.org.au>,
 Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>,
 Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, Kentaro
 Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
 Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, Nathan
 Chancellor <nathan@kernel.org>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Nick Desaulniers
 <nick.desaulniers+lkml@gmail.com>, Tetsuo Handa
 <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>,
 Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman
 Long <longman@redhat.com>, kasan-dev@googlegroups.com,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-security-module@vger.kernel.org,
 linux-sparse@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Subject: Re: [PATCH v3 02/35] compiler-capability-analysis: Add
 infrastructure for Clang's capability analysis
Message-ID: <20250918121416.19a8041e@gandalf.local.home>
In-Reply-To: <1ca90ba0-7bdc-43d1-af12-bba73dd3234a@acm.org>
References: <20250918140451.1289454-1-elver@google.com>
	<20250918140451.1289454-3-elver@google.com>
	<CAP-5=fUfbMAKrLC_z04o9r0kGZ02tpHfv8cOecQAQaYPx44awA@mail.gmail.com>
	<1ca90ba0-7bdc-43d1-af12-bba73dd3234a@acm.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX187tFXsL5Le7f+OEdXPb8EfevPMdYJjxao=
X-HE-Meta: U2FsdGVkX19m1tAn22PHk3kX2Wk2POBgAZFzgAQIMCx/TzKCFJHSRgy7lqGNU4t4JpUf2LxrofFc8Ml/SzvQUemqI2s/M2eVv2TcCTTofn0gFGf1qiKnggle2+rBi9jozqgLP+w5zmTzD8j5BYGNETdC7HYpSCmlxzgRl1HmUDgT6vBPRbNQKlew/GiSPntamWI4BN+3BQMlrQzHKrw2Hd44nH0TJbDzGUvq4EnHN5l77wWkx8yamYKm0wF/UonjU1auAq1+e+AHgLIMHgDBTy/q+l9/HvzB2gWDjclvwsnGTS+Jv2LDmjZbgWOiLNXP1sp9TafIX1LTwyRs55KIsTFDvD2gur62c5R5bpv6t02yJBvS9Pt6FACmEbxkfSaUp1nLcDU5Q19B7Ha8v33a91ClwZlXoj1UYYAtqvo6OkbX+GZwbhQ0RoFfAYIW3JVWEzxWKbCA0qFysRVjwJOtsFC2FqAYNCgDAkEhxNFg1LQ=
X-Stat-Signature: oyrrhu7nbq6ifkoonpoonkjsywp67qgd
X-HE-Tag-Orig: 1758211988-794253
X-Rspamd-Queue-Id: 3FDD1100012
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758212005-681569
X-HE-Meta: U2FsdGVkX18cTc6DCiKYqdfbmVx+bdmePbED9M7h0dhK/xOVm3IXagul/nH4DjFJw9dZn2xOs+Z0wmR393o3LTxzS9/lXr9rnYv9xgD9IHoN2NWkdh43tejHQ9X+Xail6lvgQOejjYqTmRla7XQhv4wzwNFxeGesEK1fYUUpRJpKGe7+XMw7UAmqp9RbhHII04S+sLAQCcJ1jxMslivBM6tO5WPeUOo4oTZUu2S0OOBoTFNm96ZpJYfTL4g+/Qti5wZOTClMikdxAzzxTJcU6uYnD8UiXqLGIdf9r2HX4SN0cb8GNfMSVomtMN40kFLMHb43nXHki8jyv0W/T5ao4FmzNVqZ8iZtc9Kse92JszV/pIa3jgWF+jqXGdlP70vEqDmimUQ6+sb10ToAF9q9idkUsFcQ2yYkt30LjIZamJ7x3wumvD1IVU6bCHJPT5xIDlewiQxHijs6C/3iFp1Nt8hRf9safFgYihVSbDZIl24qE4Fzr/bAz5iGXfaPz68ANyW2EhnbJVE3zSxwJzn4gicFNQXRHILdliojptq3q7OeK0msMRAApcbJh4nnc/go8qCI8J3W05vYrLWDTgMRXvVO/CeWKyj3Exj6P2TNuEQvDFUKql4RI8WM/tusXB/IhrZOiE00INUa/2DEbliSSAyLDB/+SBWyKcoyKJxnV2wdJzG4u6jrCZ5ElpAVI2uwmR2JED78Fk6PlI/Ie7wTnaralQko98BbkQIal6gmXF8K+9fv6RBOaojLOHu2yWFxLr7I247rd5a/g/C4deaHOqAS4FzMFhzOp3qXmdAcEbpLEvQY8yAN4BJCcnunabKubczun+X6tVZ0OkVBoPL+PlwsKZn9StM+TM3+0qDTZ0EWMpXOv9MKmlE3XGKRDK6PZ0t4ZPsqgJcf/RVUOP+R8w/87o8bSADekdOhW1ZHtTRWD5+SnOOsqM7AeThKMYUsbdo26aQAnAf8rcHI/5T
 uMa2Al9N
 pxD2B3E6WIUXr13hn7zxL1MpgnqCJEpctkVgZAyrhueAvnDU7zktNMNABD1S8VxvSCNaB8IjX0Oi+d4cUC+aHKKTVMlQU9eY3ZeRyWhTIDG1nUqzGQMZN4amdQfZSiA7D4aUdM404Dd7N6wTZNNp1iUh6hbFnNcBMcyOfAYNNbm0gSI4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Sep 2025 09:03:17 -0700
Bart Van Assche <bvanassche@acm.org> wrote:

> On 9/18/25 8:58 AM, Ian Rogers wrote:
> > On Thu, Sep 18, 2025 at 7:05=E2=80=AFAM Marco Elver <elver@google.com> =
wrote: =20
> >> +config WARN_CAPABILITY_ANALYSIS
> >> +       bool "Compiler capability-analysis warnings"
> >> +       depends on CC_IS_CLANG && CLANG_VERSION >=3D 220000
> >> +       # Branch profiling re-defines "if", which messes with the comp=
iler's
> >> +       # ability to analyze __cond_acquires(..), resulting in false p=
ositives.
> >> +       depends on !TRACE_BRANCH_PROFILING =20
> >=20
> > Err, wow! What and huh, and why? Crikes. I'm amazed you found such an
> > option exists. I must be very naive to have never heard of it and now
> > I wonder if it is needed and load bearing? =20
>=20
> (+Steven)
>=20
> This is an old option. I think this commit introduced it:
>=20
> commit 52f232cb720a7babb752849cbc2cab2d24021209
> Author: Steven Rostedt <rostedt@goodmis.org>
> Date:   Wed Nov 12 00:14:40 2008 -0500
>=20
>      tracing: likely/unlikely branch annotation tracer
>=20

I still use it every year (enable it during December for a few weeks on my
workstation and server) and post the results publicly. When I get time, I
try to fix (add / remove) likely/unlikely statements. Unfortunately, I
haven't had time to look deeper at them.

 https://rostedt.org/branches/current/

This year I missed December and ended up running it in January instead.

-- Steve

