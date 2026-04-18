Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA013F99C9B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 23:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3116B02F1; Sat, 18 Apr 2026 19:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 173D46B02F2; Sat, 18 Apr 2026 19:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A5F6B02F3; Sat, 18 Apr 2026 19:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB3B86B02F1
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 19:05:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 79FE0E4A42
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 23:05:41 +0000 (UTC)
X-FDA: 84673210482.03.5A74948
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf23.hostedemail.com (Postfix) with ESMTP id B0503140004
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 23:05:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776553539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RQFxtJiRVdga6qiFhe6BWPSU5Szmx4eczrx5pi2g/dI=;
	b=zF4zxT0hbx9V0Pg/52DfU54ByKU5RSF7Pi3VmMO9jK0BCoq9Ar5zvRT4gmtmKH8MAyDRxE
	iOo1pFrv2xsGy3wm4opXhYCxeEuESrhVklAhW6iNKMQmxBCu1Nl+wDY0M11CGrxhO9LmuG
	w3gypigtH5fSTTcylr2iKPEknwmZ+xs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776553539; a=rsa-sha256;
	cv=none;
	b=XSi91TaFEr8WekILgJKD79cwVc7em5e/asIUHiZy9R7b7jzQcWiH2YDJNvL4KlK94emLRt
	ympFZrOsHnGHdJCt4Hl0tZD5tgtwt/kCH7pRgVF8feJazwhXLuov6YLz7PTRFy7IMPwkrJ
	PXzhdX88ml/og2aTPxkyY4nfu1bws00=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	none
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3AF8813B3B7;
	Sat, 18 Apr 2026 23:05:34 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf17.hostedemail.com (Postfix) with ESMTPA id D63C017;
	Sat, 18 Apr 2026 23:05:02 +0000 (UTC)
Date: Sat, 18 Apr 2026 19:04:56 -0400
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
Message-ID: <20260418190456.631df6f3@fedora>
In-Reply-To: <20260323160052.17528-1-vineeth@bitbyteword.org>
References: <20260323160052.17528-1-vineeth@bitbyteword.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18uI1/Yo7/rI1+CwnTJAuzOiDhDTcHCmFM=
X-HE-Meta: U2FsdGVkX19V5aRBuQVgNrwFYqJny3DiV29cPCLORtmFjnJgNsHv2iodpq+DK7eFwvzFvhgzZ+I=
X-Stat-Signature: 14j39sducs3tg3aey13ys76m4wq4pf1a
X-Rspamd-Server: rspam04
X-HE-Tag-Orig: 1776553502-227936
X-Rspam-User: 
X-Rspamd-Queue-Id: B0503140004
X-HE-Tag: 1776553539-628318
X-HE-Meta: U2FsdGVkX1/gz7TeI7tFXdlijzlM2RM2dkzNeuQaGM27Z0BQshbK8euycwee949AEk31vdH+Rr3hHpVJXqzcl4RFavvBy840aAjQSHBFIUzDuqztG3cPjwDQafPLigZZjkGncyrMggnQYh2sY09i9SvyHZtqGMvA7v9xToi506q1ATRpkOlL/q4AnYCbfeY3FZ44wTxHKPC2Gt6jr4OTYoETOr03Dr1Q01A3hd+gSzfltXRoYpXiSxbUXn/TIJVjZxe+mQrPnOg23qXPO8f5Dz/1U/15mfI/GlVwiwfaN5yk4/5iMaz1fcMFhv/ZB88T0tChM7f9RbjNryW0WyJYwdD9ahhLhgIXaOttbmfOPURpNXk7oFpWiracYoBqLdvjXA08tpmKhCio5BGau0/J0UNI3HUpv8kPnfbdTiblPDSJ2GIWn78Z7Vg/ZxLiwj2AfeqtunGNnDAhLN7Vn43d4NELshh3fGOv1UoO3od2C1k+Jbk5Zb5cMWeSF0/RTHsr8M0EnrkJizDZYtKXTczYU+YGLYpXQ90VOiFKclho0NurOuPz0Gc4yLwgMQgl1CKXnjIhBjrCyOJW2XF9sMKo39s8hzyEM1960VyVe6IFMXmBRkge/0mIvBXGjuOpbICsu3oWlC1/f7au31jaJehfQeL1NMbY1q4oBl7sj1belc3kza0aPoX9Ym5vfyKym49MQIO7c7mIu8mcg6HGXrQJhBMk6lnd3jRd4nS6KZt0r6Ue10KJgGuCYviaDFWESUXTmnbSbvMlKMSi/Yb466ovreGOZG4PYV/UBCQxh3XAtbEI6AA6ikZIg/gRn4/y8Ga1pA3PG5a3JNno/NjNROFq6vXbIodPW8/q/IDVIg7v0Nto+tcANZA1CtR68r4cYPtTbWkk1Dc8Xq5E5k3oSnuf6gcdvWE73YZ8/WLmPN1JTPN15ZEPFz1L8pJqEY7Cfbu/tpwwhOclZ5a0T/LjNlG
 TRjG3YTf
 azrM1u8wVLPMCC+VNBRuhM2/oNbZpzoUt2O5Wik0rxY6YbtLVB2AvMqjdi3FUgI2oJVnLKBM8XT56Ke3dCh8vLuaCSpFNFELJm9F6oZXY10LvUz7ql02E7xDuod5i7/bgS5b0VipdeGei28DQgnxky89SyDbkYJcBDz7f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 12:00:19 -0400
"Vineeth Pillai (Google)" <vineeth@bitbyteword.org> wrote:

>   if (trace_foo_enabled() && cond)
>       trace_call__foo(args);   /* calls __do_trace_foo() directly */

Hi Vineeth,

Could you rebase this series on top of 7.1-rc1 when it comes out?
Several of these patches were accepted already. Obviously drop those.
They were the patches that added the feature, and any where the
maintainer acked the patch.

Now that the feature has been accepted, if you post the patch series
again after 7.1-rc1 with all the patches that haven't been accepted
yet, then the maintainers can simply take them directly. As the feature
is now accepted, there's no dependency on it, and they don't need to go
through the tracing tree.

Thanks,

-- Steve

