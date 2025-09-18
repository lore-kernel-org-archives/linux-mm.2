Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF24ACAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 16:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A4528E0107; Thu, 18 Sep 2025 12:04:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17CEA8E00F6; Thu, 18 Sep 2025 12:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 092288E0107; Thu, 18 Sep 2025 12:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9EBB8E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:04:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C07B8567D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 16:04:11 +0000 (UTC)
X-FDA: 83902842702.19.477FB5F
Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9B218160013
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 16:04:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=Mf0M1J8U;
	spf=pass (imf08.hostedemail.com: domain of bvanassche@acm.org designates 199.89.3.6 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758211449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wzWm6RSRc1tNocFJFpFoox7GYZLGguM76hcy5QnMFw=;
	b=XoBkkt4zuF2M0ljRiGrqHxwUwcY5rrYCZXJGPfj1Bf61Hke2OEfYYGR5NfSjwBXIvdb1uC
	CQyzw0DGT2yUcjFoSr3PijX1uqSiIzBj8M39K3mQpkCWhI7vMekle9r5tmrTRKWXjVJ0J+
	WCe3y3C74/wEveCdnLU+fVFEzhP1PJ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758211449; a=rsa-sha256;
	cv=none;
	b=eBDzU0pp12VTxrLFfMO8PkMs9OSIyaASkRxsUpzUGFVeO3tEcfBsm+WKTYg0i21F4lQTig
	icxD5SWsmZUQX9a6MycqJ3fSMLzGhHUxGLVPoK8P4iLNGP6oU/C/ZPH1ZmIjH3nVMKnPfs
	T1DRCU0JdPQh+UHaI+iwOYJD47H7dQk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=Mf0M1J8U;
	spf=pass (imf08.hostedemail.com: domain of bvanassche@acm.org designates 199.89.3.6 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cSL6c3snqzlgn8k;
	Thu, 18 Sep 2025 16:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758211439; x=1760803440; bh=4wzWm6RSRc1tNocFJFpFoox7
	GYZLGguM76hcy5QnMFw=; b=Mf0M1J8U6wTLeu2gHoc5SUiGtJ7IvGYk8UZ6fQtQ
	F2HzXxFsv2wJKVo3E3itBcK5M7HBPy7vs16rMQdZNtkdtlpHUdAB6gp5zElM1tQv
	X44SkYoj7S3blZaRVlzHiogKzJP7RsYrM9zFM9RqFriOFHgBvgFNCVmVWHjXbnfj
	BCNxjhZ/nIKCSqWA5KRGlBXCj8ouY534Wu4SFzXm9YsWLm1w6mkQLx3XVjEv5N0J
	qYICjPTqTk8g9G9tSYHje0mRJLCaVRl0Qo98o58MrF9E6yTEcWnwOiMsYBacC9iZ
	WV8PxWTT8jpLUWJ3lpx2TSzx7JNYmCOfRmR8oXeNulu1CA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6L6n7UbPW0mK; Thu, 18 Sep 2025 16:03:59 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cSL5g10BTzltKG9;
	Thu, 18 Sep 2025 16:03:18 +0000 (UTC)
Message-ID: <1ca90ba0-7bdc-43d1-af12-bba73dd3234a@acm.org>
Date: Thu, 18 Sep 2025 09:03:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/35] compiler-capability-analysis: Add infrastructure
 for Clang's capability analysis
To: Ian Rogers <irogers@google.com>, Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>,
 Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Bill Wendling <morbo@google.com>, Christoph Hellwig <hch@lst.de>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>,
 Frederic Weisbecker <frederic@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Jann Horn <jannh@google.com>,
 Joel Fernandes <joelagnelf@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
 Josh Triplett <josh@joshtriplett.org>, Justin Stitt
 <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
 Kentaro Takeda <takedakn@nttdata.co.jp>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
 Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
 kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
 llvm@lists.linux.dev, rcu@vger.kernel.org,
 Steven Rostedt <rostedt@goodmis.org>
References: <20250918140451.1289454-1-elver@google.com>
 <20250918140451.1289454-3-elver@google.com>
 <CAP-5=fUfbMAKrLC_z04o9r0kGZ02tpHfv8cOecQAQaYPx44awA@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAP-5=fUfbMAKrLC_z04o9r0kGZ02tpHfv8cOecQAQaYPx44awA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9B218160013
X-Stat-Signature: axe311uzjiwrqit5u9mncuihgkeodyzi
X-Rspam-User: 
X-HE-Tag: 1758211449-903599
X-HE-Meta: U2FsdGVkX1+wNTRYyZPYUDZ27E9sRWb3tLJe3PoHCWgPrr6Q2DgyfXPCWh4RbFrXck7c9Sc8JNXMw+umQBxvMiyIB4CpPUgbSQihSfNfSxFtTPIO5lJ+pTd3yyyVrJCq+Ouwx9VE31Sd/IY88e6vDhlaZifrkffTGMSB8ogyIsR+AZ79adBHEnlmn8Ex/QqxhuJEUfrXN6IFI3MDqC2Mzc2lHP+ht7X2ZZCsfOpC6sROnLJ4x9yrjXU3NYZILON9GpuE9osyio7u5Jl8NoMdta3PGaVhgdJTGGCyvU+/Zl/k9afxurKMxfjBoe7NRhjDzAWYq2jBwrAwfwZj2V870LHJGKlE+YX6mOcPofOcjCTYLSDiYKVlR+418BfC9sStg+UuYCvaPPJSorR+kb5HfLcpgTta3SqvvAPRASTL1fHi8zfST4PHhkT1pbqH8h/U6/ONWkXpsCsk1ZqCbQkg/pZzxF5MpJEPxjI2z+UTpJ+GuWJuiTo19mCA+r5jtbJ3Q79dU+Vpjjul/LAmmFZoqD8Yv8+WBAyGyg0R2lM/65A+jLGeIBThUJvrhd/7GiNDbTRJx8jjqIO6/zh+YTTBPjCZUJvK4FQDOPUnY9Ffdhk9ekkbkX9L+O6GDc4CiKCqfJxPVF7GQUQc+hFpS9+PHojhbtzIr3hPZrzVr6CFchxes97UuMfCZLt/P20RGjYVWVAuldN0FC+dYSMi26S5mqb76u+29ncz3XdQ1cHPNaAR4wYLuNPv0TqdR9KixMVhpvRTiTL4hlKsnybeFRh81WJXi/UWvo7b/qWTthg+1GfaHY86Ya249GRLDvUH6Ve43mW6tF/72ZJo8EfUI20omc9r0E38p79GsQLD756nSeMv2M5WDTZdcdTkStzHUQpXI7SuXAHnXoYfkP7tsJR/kfn23ERij2i41c5mTpAPQRxmXVwQVqraBjewkBrpxKBFa35CB+dqYnrAmNeAAaW
 92GKCNiL
 6koDXAccdlheqi5wDwAhgzaVf2/XWI1kCxAlNUzEbIDL+7Q4WWC+LcLFpu/qOJWvvynEWhR/lQTavDozjffvaJ1MEOdd2ZzvdnUufMX9xGNcqktbe4FHmfepZ+zzblbh+/gpLgklO+As0G6OQFWA7YfBSudvnS1KdudGtOSnvEBxrsJg2jPJ6GE/YyfkQ7yEwKhx+By2NQxL0xCPWUAJYqOvkbec1BpvpNauscM1EyxrWy8qogmq4v1wGC6dASusivHFI0NWxrDJYpISzKLVzw8+AlowXKzITslKXWlH1AS4zFgOQ6RPqUbP2qayY322eid117bZ35es4eVB2Ge+7yBSO9pwsX37RaCgpqwHmD6BzTCg7IspqsR/JFt+uLFRQtdc0Pges3hXoRNVS6FywXNtowdyK+XHrvoaII5Spmp88CANfxfnXfdfEeuhvk3XHIUP4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/25 8:58 AM, Ian Rogers wrote:
> On Thu, Sep 18, 2025 at 7:05=E2=80=AFAM Marco Elver <elver@google.com> =
wrote:
>> +config WARN_CAPABILITY_ANALYSIS
>> +       bool "Compiler capability-analysis warnings"
>> +       depends on CC_IS_CLANG && CLANG_VERSION >=3D 220000
>> +       # Branch profiling re-defines "if", which messes with the comp=
iler's
>> +       # ability to analyze __cond_acquires(..), resulting in false p=
ositives.
>> +       depends on !TRACE_BRANCH_PROFILING
>=20
> Err, wow! What and huh, and why? Crikes. I'm amazed you found such an
> option exists. I must be very naive to have never heard of it and now
> I wonder if it is needed and load bearing?

(+Steven)

This is an old option. I think this commit introduced it:

commit 52f232cb720a7babb752849cbc2cab2d24021209
Author: Steven Rostedt <rostedt@goodmis.org>
Date:   Wed Nov 12 00:14:40 2008 -0500

     tracing: likely/unlikely branch annotation tracer

Bart.

