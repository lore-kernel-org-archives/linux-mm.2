Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7142FF54AC5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 14:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7A3E6B0005; Tue, 24 Mar 2026 10:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2A636B0089; Tue, 24 Mar 2026 10:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19B76B008C; Tue, 24 Mar 2026 10:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF2036B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:28:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 579E9141C70
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:28:00 +0000 (UTC)
X-FDA: 84581185920.27.D4D726F
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8986E40002
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:27:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774362478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EwvnJwW81aaSbvr6ogfXxcPr4F9qI2u/lM83PmYUlAk=;
	b=iU3VMqcQCMkSrTG6T6abELlA7bYvrFIG8bjP9Qqw6LxY9Jh7WmPE3dr1GTWPB+HKV80qk2
	bLI2x/sTcKIsA/5mKUvBMDuFUDsn/qGDpl/c6VerZhK8f1cPbuekT14ZmiUXU5BxyLrcxV
	JBoGLCCxHqj2Obf/c/Ew3tAtBQ37hZE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774362478; a=rsa-sha256;
	cv=none;
	b=HJv1CHlmr0rWDSFtNLfXvDes9OLzbT+fubbVVh252LIutQE/Pxcb361HCdFrnb646qerwh
	nB1YDgRfdNy6tpEB/r72QIdE99sjJQzlPTp0uj24KqH/q6xsf4PZjLLjuWZsr2LfXkNuYD
	d6FX/xrlokx+s/LODUJnBrrGC3rXf7I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	none
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1BB3AC3B50;
	Tue, 24 Mar 2026 14:27:53 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id DC83180011;
	Tue, 24 Mar 2026 14:27:20 +0000 (UTC)
Date: Tue, 24 Mar 2026 10:28:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Dmitry Ilvokhin <d@ilvokhin.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, Jens
 Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Alexei Starovoitov
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Marcelo Ricardo
 Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, Jon
 Maloy <jmaloy@redhat.com>, Aaron Conole <aconole@redhat.com>, Eelco
 Chaudron <echaudro@redhat.com>, Ilya Maximets <i.maximets@ovn.org>,
 netdev@vger.kernel.org, bpf@vger.kernel.org, linux-sctp@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, dev@openvswitch.org, Jiri Pirko
 <jiri@resnulli.us>, Oded Gabbay <ogabbay@kernel.org>, Koby Elbaz
 <koby.elbaz@intel.com>, dri-devel@lists.freedesktop.org, "Rafael J.
 Wysocki" <rafael@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>,
 "Gautham R. Shenoy" <gautham.shenoy@amd.com>, Huang Rui
 <ray.huang@amd.com>, Mario Limonciello <mario.limonciello@amd.com>, Len
 Brown <lenb@kernel.org>, Srinivas Pandruvada
 <srinivas.pandruvada@linux.intel.com>, linux-pm@vger.kernel.org, MyungJoo
 Ham <myungjoo.ham@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>,
 Chanwoo Choi <cw00.choi@samsung.com>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 linaro-mm-sig@lists.linaro.org, Eddie James <eajames@linux.ibm.com>, Andrew
 Jeffery <andrew@codeconstruct.com.au>, Joel Stanley <joel@jms.id.au>,
 linux-fsi@lists.ozlabs.org, David Airlie <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Alex Deucher <alexander.deucher@amd.com>, Danilo
 Krummrich <dakr@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Philipp Stanner <phasta@kernel.org>, Harry Wentland
 <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>,
 amd-gfx@lists.freedesktop.org, Jiri Kosina <jikos@kernel.org>, Benjamin
 Tissoires <bentiss@kernel.org>, linux-input@vger.kernel.org, Wolfram Sang
 <wsa+renesas@sang-engineering.com>, linux-i2c@vger.kernel.org, Mark Brown
 <broonie@kernel.org>, Michael Hennerich <michael.hennerich@analog.com>,
 Nuno =?UTF-8?B?U8Oh?= <nuno.sa@analog.com>, linux-spi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Chris
 Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andrew
 Morton <akpm@linux-foundation.org>, SeongJae Park <sj@kernel.org>,
 linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/19] tracepoint: Avoid double static_branch
 evaluation at guarded call sites
Message-ID: <20260324102802.4f8af148@gandalf.local.home>
In-Reply-To: <20260323160052.17528-1-vineeth@bitbyteword.org>
References: <20260323160052.17528-1-vineeth@bitbyteword.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19u4yDoihzmlvbQbp4GBKk4Sx0FsrK0H8g=
X-HE-Meta: U2FsdGVkX18Kg3NfvHLPV0rnp3UrERb/HeySVgjR0PuCDys+LVJ4s2L8fsy1rJHv82yu9UO4h+xU9iEx3z3YFKVS1OFx2Vvti4rEmq0enV2xaTwbpZ+YWf60TFzb8QMlheid4NsXOVqOYcFPHCn+ZrWqPDCdrmq0l+tkyLSeYhbpJixFuANIjXhtSBZInyEBtAAqHPqUuWZ3PdZupXAY7JMTASH2KNw+CMFxYOXnDTbb38gpzJzBKiUcyoxK6GlO0db0aEPLlOAMHWKzcQEu5msgaweBGFFWtD9G0uWRbe+OcS9gBl+SI1CDJFvGCt0Z8gh5xinNWW7KF0gSIEh3ZlA0AO0+B5wCRjivVxgdquYH5bWbk7CtReb5es0u0tOp
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8986E40002
X-Stat-Signature: wutuyypd43jh3n1f4rz7o3irx38o95pw
X-Rspam-User: 
X-HE-Tag-Orig: 1774362440-296898
X-HE-Tag: 1774362478-443510
X-HE-Meta: U2FsdGVkX1/iE1B1jRq4wCZGgpW5Wa73+7CnsYbfihqaKOkaQW4RDSlH5HCS/VV6iTtomjux2sn0sVC+VCQB1dtbqPbCu8KvzwPEQ/aNx0aFS77U9ank8fW66QHWSEGnnwvdDhnR42HwpBZ5JCFxXHiV+e8kCbLLbC+5kerbo8dtZFqAwSJHZ+dhUEA1JdaE+tt0ZzZ5Aj452qT09i48bP0oaI5xUr1uMaON/ph1Xd32vWgcE27qlxZ6kfpZzm2TgYKXaDOEZKW68GfkkGYrl64YYGl1hz5BBO81S16Pac3rIOgGIXMzaft+hyTpXm6bxdQPfjcFh2Lbe3O+FqbtyhiFMssjSGA9xtNWHj0DSb1A1P6s7pa3VRzdf1fSH+Kpbx0A0aweyteB62FmH3zvfFxguhnFu3bu1UuSSB+A4EwMnYENR8DtbSrMzZRN0pp7P00/2d/MhneOtpdvcLACRpDKNVzVg2KJfPepQsU1ArCC1tcu1olrORueoqjwr3hWaC5PK6NU5gDykWQk2y0BDAWsKhIAgXvcYKJFB4ZIo2xTn4p5XuA2JXlA5HtcugJ7Hgnk5oJKXIEOtFK6Ls1qzRJ5a0npb1cg5YwZg0qILhucclLfwEsNiQo41cVWclvYTLx8AE76qnfus+iG1WjPosnPqE2fVMlWjD4bQ9op4ay5x5nI/JBvYRd+XIgICGGKmdARWH2GYVPaOAkrp4u6uPaGNxC4F8vRa1dT3Y9DIHHHXxJIahcezZYR/uPxj2vaEuBDmN+6j9641oLDbImtelc+Z8uBEp00/loSG4mKVH/tUy6OA3IRuXhuyS5+jiX87e4R34Vq1wrHD27ezZ+c288EnfMOQO5Y9f3MPqttafzFEFEhAQbQxgKfWyAq2HNZ6A30aBab9D1UxKKoN73Dylz/0QHKzNqgQXGN0qj6Xci5pI8m6wWku/TEeZs0wH/NEIBZ3FzbEOCj8nl7gwl
 JfHfPuov
 TWPof/6HQRVZYbUdStYIXPwE6628h7DTJnLpX2Dp//lUKi9ATMmoOiBajDJmkU+pLat5KD4aD1d//4AVoNqTpoZqoWs+KTTQgPJio9zW7lBp+kO8BlWXn9spd4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 12:00:19 -0400
"Vineeth Pillai (Google)" <vineeth@bitbyteword.org> wrote:

> When a caller already guards a tracepoint with an explicit enabled check:
> 
>   if (trace_foo_enabled() && cond)
>       trace_foo(args);

Thanks Vineeth!

I'm going to start pulling in this series. I'll take the first patch, and
then any patch that has an Acked-by or Reviewed-by from the maintainer.

For patches without acks, I'll leave alone and then after the first patch
gets merged into mainline, the maintainers could pull in their own patches
at their own convenience. Unless of course they speak up now if they want
me to take them ;-)

-- Steve

