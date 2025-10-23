Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6465CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 14:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D72128E0003; Thu, 23 Oct 2025 10:23:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4F0A8E0002; Thu, 23 Oct 2025 10:23:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C86638E0003; Thu, 23 Oct 2025 10:23:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B67F58E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:23:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6372487BFA
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 14:23:26 +0000 (UTC)
X-FDA: 84029596812.11.39D3B69
Received: from relay.hostedemail.com (unirelay06 [10.200.18.69])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7671514000B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 14:23:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761229403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9XPfcex3hX8Yq51hvEdZq8mkmLnOVqxEUgFWlRSCmx0=;
	b=EcJuMXnXKoe/1MsZbVBToRAohYErDNmx+8UIgHyNPQryjMp3gxql0SdR4WPjGrz7X2cUJJ
	OrRQbAAvtExbkMrnooBz23H4qbwljLaa4h30mmhDPPsMZNotnPg5cXEdG6hMQC2+3n6v8e
	NZiJSomOhJkn7EoVvhRuJIQUXSrUFv8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761229403; a=rsa-sha256;
	cv=none;
	b=1/LSSq1k1Ol0cO+EivPJdxv1RvOOa8g180BUbfEkqYgKh0nYE/gWnyrKF9L51W0HN3BVfN
	QPjVT1mxAS4NzN74E3xWXI7cQwfw6Hz+CIUAhKoumkff8ZYh/ngRnWB8dtUEDQLehM6fta
	uIJZkUP3Vc0BIolWycu21BfY/PWoEHw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	none
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8138129BC6;
	Thu, 23 Oct 2025 14:23:17 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id 5E7336000B;
	Thu, 23 Oct 2025 14:23:06 +0000 (UTC)
Date: Thu, 23 Oct 2025 10:23:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Fangrui Song <maskray@sourceware.org>
Cc: Jens Remus <jremus@linux.ibm.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, x86@kernel.org,
 linux-mm@kvack.org, Steven Rostedt <rostedt@kernel.org>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Jiri Olsa
 <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung
 Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andrii
 Nakryiko <andrii@kernel.org>, Indu Bhagat <indu.bhagat@oracle.com>, "Jose
 E. Marchesi" <jemarch@gnu.org>, Beau Belgrave <beaub@linux.microsoft.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton
 <akpm@linux-foundation.org>, Florian Weimer <fweimer@redhat.com>, Kees Cook
 <kees@kernel.org>, Carlos O'Donell <codonell@redhat.com>, Sam James
 <sam@gentoo.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, David Hildenbrand <david@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v11 00/15] unwind_deferred: Implement sframe handling
Message-ID: <20251023102332.7b7f1241@gandalf.local.home>
In-Reply-To: <mzqhpduikzpeczmmxh5uyfzjpvdeae3ityqyp2rno4myujzb6y@ey346eksvoyf>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
	<mzqhpduikzpeczmmxh5uyfzjpvdeae3ityqyp2rno4myujzb6y@ey346eksvoyf>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/B9JQTNbR4QP1SUw0zmZnqU0dFZXkG9bs=
X-HE-Meta: U2FsdGVkX18AsgT3wUjnPBgCWRK1PjrNucH0m2er7H8Y7F02PT+qJ2ECLo7Ib0sBuZv2V/AmogulDS/KBAtvdQqooEV2x+ikzFX8qozMGkU5h5Gbl6z6BdLKTPXIEyrlcddrSO0JS/kivrcu3ukW3wJCaBEJM4Eo7yrui2JrnbZKctgvKboz+o96sHa1VryuzA5CUCC/TZnERfu3DVdozVgG05orV2OIYN67RfaDv8zGwXhTK7WLAc3E9+eN30bv/znwWjVdTYHX6md1vdHUhP/iIRhBaotU4mG1COOyBpbdua7yyMUz0Qc0ArxE4BKxPX4foEDDQHm/Mng95sJXPt6Z4Tqf/bJDVTm4YcVvPsJ2Xb3G36C9IxxdWR9N5lOkbC398iuadGedSQUziFjuEasHxohtdqk6Rd7+m49RUfHPGb10X4nAqG4b9GaSpwiC7KBsfXAHBWyaQHTGd9xMIw==
X-HE-Tag-Orig: 1761229386-657495
X-Rspamd-Server: rspam05
X-Stat-Signature: ywywgk4jin8a8ru9j8rnqecapusdnye7
X-Rspam-User: 
X-Rspamd-Queue-Id: 7671514000B
X-HE-Tag: 1761229403-642003
X-HE-Meta: U2FsdGVkX19gkwBjSxzvvoKC3iUKKdXLSrfvfb5O/2Nrc9vPN4npSfenM8376ZbHKdTX8v0ldS0FBl3opIBYRyGZMi9jLFfuCQc+Nh2n/oI7MTwV7dMuQlHmK2im+kkmYyg1GmBKG0DBONWRmIU61qa5KD9pY/2/1UczI/iSwkTxYv4I1mQCMWe9fsSycjQe6cSmezx8ptktl3uWmjnbvoj8yu2+WnVz1P5h1o8gxYScGuqqgoPfm69LGGJr0o7L5Bmx1DSaFVxlZGI9mVEEppYW1sMJgMcRclPU8RDna817zOaD2Z37Y73gS2OXKjpUqjS2mNzBXyLutUq3aDr7i8lslw9EN3Jtp28W9XOgYHjwQd9aCa3dn0rZhWIhFdHnp0R/1/llSnuf325alTGUmAnvDhG1JUZdNXNnuSQMmwOE5nfB3b1hP3zNEhnJvbOv1hXSI62wHiktK/4m1OSPqL4/DVP260B5u0gPNaBFmHf2cSnIt/OG0YMFcJs45B7Nz6jpi930N671vMt9k3p09spkwQmCvfrch51xyeAb1BOIMKMRBykWWUBF4YMwdnGhHAqIWCYR1Yd7elm5qo1j4aM82jJzKKeBgFJ9zNu0xKMT49Geybe7CNqyTcOoRcBzhdaJZ0UrKjFUYTAVqbrtxaL8K0aVSvTMHYZaShr9EzknhcI6FRJbsqUjhYw5Wku+nbPtHoQnHUIlgYLyx1VWG1ZyEww4pWoQZFoGw5DJDHUMQeNcxqga+0YWzPuTverY/n14HzXXK5n10jDeZ14PTIZxI/PcJFEV8LktDivwsRjPm7s2WQ38o9+mbf3EczvV6mVVDZh1nAoMuMMNL3eCdpVZ1GCIgqE9x/TzfW3anGEmQm6BHs8jUf6lTg/7PWzyMtanL/yZ0yRoXE+EsWfL2B7lIoGutcvWk7sRCVMgDT8pnFsw1NOvHXZS14dbqsNjByhPB/z9Psyk7y4aSo9
 2KbDj/tP
 vExQr0elP8dK50OAl8BV7V8CE+XibBVmX7pI9yvsEkoe1mg8twFcEq7oBS26WYC1i/hwdOoaevNUF9iw4kS8S+9od7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Oct 2025 01:09:02 -0700
Fangrui Song <maskray@sourceware.org> wrote:

> Please consider dropping the statement, "soon will also be supported by LLVM."
> Speaking as LLVM's MC, lld/ELF, and binary utilities maintainer, I have
> significant concerns about the v2 format, specifically its apparent
> disregard for standard ELF and linker conventions
> (https://maskray.me/blog/2025-09-28-remarks-on-sframe#linking-and-execution-views)

Please note, v2 can be dropped entirely. There's no plans to have the Linux
kernel ship with v2. The patches for v2 for the Linux kernel are for
testing purposes only (which was what help find the issues with v2).

The plan is to have v3 be the first versions supported by an official
release of the Linux kernel with the assumptions that changes after v3 will
be minimal.

The reason there was such a big difference between v2 and v3 is because v2
was the first version to have a consumer try to use it in a more production
like environment. This found several corner cases that needed to be
addressed, and that the current layout of v2 was not acceptable.

No linker needs to support v2 as there will be no consumers of it.

-- Steve

