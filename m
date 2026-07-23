Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB3DEC531D1
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 15:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69D896B0098; Thu, 23 Jul 2026 11:16:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F2E6B009E; Thu, 23 Jul 2026 11:16:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515FE6B009F; Thu, 23 Jul 2026 11:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DABCD6B0098
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:16:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A7BFC053C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:16:09 +0000 (UTC)
X-FDA: 85020392058.09.79DF62C
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2FC78C0004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:16:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of segher@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=segher@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784819767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=enmgVr9PISi1K5jH2HPI2RCziiUGCfxKtG+OtqZh+TE=;
	b=ESAbgvZhQKiBsRrLPCVzPVuA2cRThQaAX7dA9jG2YZ5pXVoH5o9FKEl6peyMXS4axTKjLn
	WqzqBkxrOEzDQnykQTfKwqstQVWe0bEGiMfQIjpehVDzz8X4Civk3oKULOrFWsMIG74ujt
	VvdRqGvUyAyVEy/ko043gtE+Dhgetrc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of segher@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=segher@kernel.crashing.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784819767;
	b=z9kS0BVYr9QV8Jo6GavAJrOK6YCKEqvZV2BBuMnNGsupzLOcuPT04M2mvUurLAQxqM0G0R
	CoVpiS9M1lYzSs0r6G+QjkSln9Ud1p8xVagGfEQgyx23X4Lz4Jm8WV6YwEGg4DwrHc2CAl
	t5I8GAqEngKQVQ+kAlBiGt0nqYH5NgY=
Received: from gate.crashing.org (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 66NFEMq5259803;
	Thu, 23 Jul 2026 10:14:22 -0500
Received: (from segher@localhost)
	by gate.crashing.org (8.18.1/8.18.1/Submit) id 66NFECrd259732;
	Thu, 23 Jul 2026 10:14:12 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Thu, 23 Jul 2026 10:14:12 -0500
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Markus Elfring <Markus.Elfring@web.de>, acpica-devel@lists.linux.dev,
        bpf@vger.kernel.org, coresight@lists.linaro.org, kvm@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-mm@kvack.org, linux-perf-users@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mptcp@lists.linux.dev,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        virtualization@lists.linux.dev,
        Adrian Hunter <adrian.hunter@intel.com>, Alex Mastro <amastro@fb.com>,
        Alex Williamson <alex@shazbot.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew+netdev@lunn.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Bobby Eshleman <bobbyeshleman@meta.com>,
        Christian =?iso-8859-1?Q?Borntr=E4ger?= <borntraeger@linux.ibm.com>,
        Christophe Leroy <chleroy@kernel.org>,
        Chun-Tse Shao <ctshao@google.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Costa Shulyupin <costa.shul@redhat.com>,
        Crystal Wood <crwood@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Daniel Lezcano <daniel.lezcano@kernel.org>,
        David Hildenbrand <david@kernel.org>,
        David Matlack <dmatlack@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Donald Hunter <donald.hunter@gmail.com>,
        Eduard Zingerman <eddyz87@gmail.com>,
        Emil Tsalapatis <emil@etsalapatis.com>,
        Eric Dumazet <edumazet@google.com>,
        Gabriele Monaco <gmonaco@redhat.com>,
        Geliang Tang <geliang@kernel.org>, Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Ivan Pravdin <ipravdin.official@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, James Clark <james.clark@linaro.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Jason Xing <kerneljasonxing@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Joe Damato <joe@dama.to>, John Garry <john.g.garry@oracle.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
        Kent Gibson <warthog618@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Len Brown <lenb@kernel.org>, Leo Yan <leo.yan@linux.dev>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mat Martineau <martineau@kernel.org>,
        Matthieu Baerts <matttbe@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>, Mike Leach <mike.leach@arm.com>,
        Mina Almasry <almasrymina@google.com>,
        Mykyta Yatsenko <yatsenko@meta.com>, Nam Cao <namcao@linutronix.de>,
        Namhyung Kim <namhyung@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Quentin Monnet <qmo@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Saket Dumbre <saket.dumbre@intel.com>, Shuah Khan <shuah@kernel.org>,
        Simon Horman <horms@kernel.org>, Song Liu <song@kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Swapnil Sapkal <swapnil.sapkal@amd.com>,
        Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
        Tomas Glozar <tglozar@redhat.com>, Vipin Sharma <vipinsh@google.com>,
        Wander Lairson Costa <wander@redhat.com>,
        Will Deacon <will@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Yonghong Song <yonghong.song@linux.dev>,
        Zhang Chujun <zhangchujun@cmss.chinamobile.com>,
        Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] tools: Use fputc() calls in some functions
Message-ID: <amIvxECTIM5paT94@gate>
References: <48f2d61f-d468-49b7-881e-f00777db073f@web.de>
 <amIbVOIsOeZgcBZF@tassilo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <amIbVOIsOeZgcBZF@tassilo>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2FC78C0004
X-Stat-Signature: dmjooyz8rs8ss5pz3bm8fztwffsaqwpq
X-HE-Tag: 1784819765-596878
X-HE-Meta: U2FsdGVkX1+ERVnRumOPC3tID/jSiVnpYamwBvQWOkIlTO653WCPPf7LhxJ2YIjKS64gyZXmfsXhyyxO+m5RAQxGn2zBNhE0bTvacypkr+yVqI0j0RQh1PoPOSsjwgfdF1Lf37mLT3vLhiAULPLCCWDZM31lM1aMinkjOXpkSEb6wVuvU43/Kv5yEQiYhJm23TpYqGTpFlcVtccpihXddY/Q2VdKx7aFX7kt3LPMhsxsqSDlc/oG2HxEGXKjI8hLiG4dxSzRo5kN6dfKUWalQbCiU4KtpUP4Z1aSduXjrTp40RSmOhrt3C7rZ8bZPbBb8A2lxqOlnrcHlRuqR18vFNvh8aijse1oDotHbIGKsZmzLxp/cjGobQLjkUm8x+oDDY26TGz7Si28qth51Fy19Qe3W3VFpNHdzdA2WvpscZjC+m2JPKOiHWQdOd+DfHhbxBgm3F2on4+BSWIiTNaAU+YR637ae1NzuDTqvStAPCzh6NEp8wpdUfzwj9C8XmeqYUI72LYKw8YBxLMMe1zdqKGdKUqHjD9bV8aY3Xpvo7fMkyss3qsNtmAfG3ggrHHvmeDYnzjFsuGQRH7uhWzxSb+zq5Ey5LrzosZVQoub2v1+sq+5PrjAzVXCPnOn5utxR/q28/wadqGbI/RSGnSykTfDdsmW27ScIUPkbu9999dwM/BJFvF0XqEEmfB4rKEwN8Qi7BfnDekz6+I1r3y7pVSuoyYQDENvnGxxFaPgMRw5xuap6aGdWXQgptQ4aTpV7AnTAwbKHz0lF0fOnTZ2h/ZPHzuHfWfz/2nzztJpaiVnxM/v+JEhtrsRpK9Tp1C8X8NzH27+vLpYA9Tt6uazkyY1tX5cvae9Loa7vGqK5Ty/ay2fefyEwSE09EVIoU81MjBfgbO9mbnD3NzlidFQXn9mcOqgRflzWM+48N++6dJOohMAAmOacYNoke5smoK2jDDNH3/q6KK5q+sRG4P
 9/WY+LcB
 simXOPqkx44SADz4uSiPTGRf7oN9fG6Myf/T7MSDe+7X8pqTK5zLDyFp0G1w08nPJaiAeOBQ0V3/cg9C8fvym4LIe8jIxNHGURqFcHGPE7+o8UQw6VFNFNV6Oin/ZAttGm5j30aNhZEr/NGqz7uB9r6v2/Y4KxkBkbvgFohAXH5R/0ILHQI+L05Knp8O1CNZSJVasPUVxVpw/BS9Hh/WljBBHoLcGM5nX5trI1RlpfVPJZ0ozBrGckekJkzAtcXYOHP9frjHrdiOGX9M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 06:47:00AM -0700, Andi Kleen wrote:
> On Thu, Jul 23, 2026 at 12:25:25PM +0200, Markus Elfring wrote:
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Thu, 23 Jul 2026 11:13:30 +0200
> > Subject: [PATCH] tools: Use fputc() calls in some functions
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=UTF-8
> > Content-Transfer-Encoding: 8bit
> > 
> > Single characters should occasionally be transferred into the output.
> > Thus use the corresponding function “fputc” (or even “putchar”).
> > 
> > The source code was transformed by using the Coccinelle software.
> 
> gcc already does this transformation automatically.

Yup.  And the printf() form is much more regular, expected, readable.
The primary consumers of source code are human beings, all programs
should be written with that in mind!


Segher

