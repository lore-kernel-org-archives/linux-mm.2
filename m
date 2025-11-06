Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45CD7CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 17:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 898F48E000A; Thu,  6 Nov 2025 12:19:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872068E0002; Thu,  6 Nov 2025 12:19:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AF188E000A; Thu,  6 Nov 2025 12:19:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 66F8A8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 12:19:42 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 14A1B1A01FF
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 17:19:42 +0000 (UTC)
X-FDA: 84080844204.28.E0A95EE
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf08.hostedemail.com (Postfix) with ESMTP id 49DE716000C
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 17:19:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762449580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z7RG+RiuXtV9CX5M9LqAevfuJnpnJLsZrykCb1LAE4k=;
	b=OPxuChR2qCteZK/Y+5/SA1GXnc+bZ9SXULgLYDqg1J4P7luyk+Gnz/9tWcz3/tb3TAQ6jX
	TGUmibWQWWEdfSy0WquNsKH+C/9C/xXSrImWP/WpXX0xUE2zv/dw9oF24k7r/UaPDZG2y8
	/cmpDRsslm5Yz9tr79ZuwxA09QhXQvA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762449580; a=rsa-sha256;
	cv=none;
	b=dlw8kECf2fE/abGZ71PRVHvrBVF4R9Z7d9Z5cqqM0Ji/eoDNu+9N5HLd8i7OnrkEzxOZOd
	8wVLS+g8k0bMp52PH7LCp+8oORI95YOLH10exj7k4Nk4xrJ7LLNq/UA+nyZJnVB3AqF9wR
	CsdKHtyYpMZ50AAmgTEWxTpMXMrnO4w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	none
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF9D91DFA6C;
	Thu,  6 Nov 2025 17:19:38 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id A4EF22000F;
	Thu,  6 Nov 2025 17:19:36 +0000 (UTC)
Date: Thu, 6 Nov 2025 12:19:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: kernel test robot <lkp@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 oe-kbuild-all@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Linux Memory Management List
 <linux-mm@kvack.org>
Subject: Re: [PATCH 3/5] tracing: Have tracer option be instance specific
Message-ID: <20251106121935.3efdb61c@gandalf.local.home>
In-Reply-To: <202511062223.ocoUvCBI-lkp@intel.com>
References: <20251105161935.545400234@kernel.org>
	<202511062223.ocoUvCBI-lkp@intel.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18uWTdcXlyyoR3VMGpvOa0DxYvE6ud2xdM=
X-HE-Meta: U2FsdGVkX19ic/j+PnEM6rRsH3Typqk/8ymi/MDdxNp8zsI3g+yMWgsZVaBQhf/K8fSYw2rd+yY0fFCTOxTViutoUoQtmMoFHS7xQU4XtqKWPFcx2W/HTggJMu4c6XaVdg3YbK/6OskY/q/vONW0/S6wJKPHMatZH4c9kj0fjQIutME7kacdU+xjve0cNnl4RLuSurolzS0Wq63NEyQe1Aunq9N2OWWFaIxqf5IkEzpkXOlsNS7u6CLxxVWILPwPmkep0PwEq4Xk4vmXV30cJ0rwrLpkDSXhq2n0ooWXOIDLt5y9cc2SpwUIBNgPM6o4JeQsLrz7RkmVe02ZJy52EsXr7rXvkwhI
X-Rspamd-Server: rspam12
X-HE-Tag-Orig: 1762449576-625784
X-Rspam-User: 
X-Rspamd-Queue-Id: 49DE716000C
X-Stat-Signature: xnjacie3cxh3xgncwmqdz8inxp7rwbuy
X-HE-Tag: 1762449580-211910
X-HE-Meta: U2FsdGVkX18m42hDxhwD9X6nQwBMdop3lWqz0BAF5rbWK+8EW+MeofSd9WsuqS8TuIpuhMLodkCPfC6BNG4Wdj7cJynwnc0Ymlp995T3mgmDtmdLBgadg6a0A9fpMXaTy+BAGA3qnbyaSF5ByMk2PHPoy57Ebtx9oBeWBcPTmJgOXskdQCrn4X6C8Np5FZEwP5pcymvU0JqQEcaBX5ghVzwtfdGQ4SiQv2d20sw5Kv2EH/Yz4bS1epKK7qxbnP+KiWHPG/AnLB6eBJV3WbM9BLwxO7hmfcCsebauUON4Vbpg8LVJ2gXYMejjkqYWDjc8+E+owmw6JeJlGVpMxk5RdHbBDyIl699WvSmxGN5/zzMIMxb3IcErjs+9SgdUz/wfxHHT8NkgSRNuweI3wmGD+2IpXNzWKlThm6XycbYGXR0MQXsTMTxaKTqwTUeHaNpy4dr4neZRMo42d/4eatKRi6tMmolldvBE0JAHWRsv1nSHVgjucwYiTxJp1CY9wqZEGFR3NZvBC9LIdOyN9UHYhgGLuZF/P4RjQppgLYsKu99CO0zvvts0oNlOFKRF19gx5IuQy/4wrTK/fhIirX0aFMQVMRZIodcJ9iikg8iOZfeoyUoRHZBzXEoTOMoA7iQTd4K6Wm4s9Uy2PWZfRY7z/7tHitwcOx+1cGhukcqfTI0IbrMIfMM1Ege1DMJ4a8C8T31JB2WyWAU8i/WSMZS1ISQvbvu6WPKybQ/Xmm9KoB8yEJn29LNySnd5MB0+Jz5+2Zzd75Mned5FQPMnZn6Ma9m903qcLThAX8madRWtmc4ojUoiK2g3XqzLor9i8lUBDbJnZ0tMQpLy1das4ovPTephHsPIFG5uID6JX7Us3VJ7RjB9bCLiNgWaMvrPEgcE5DkbrhFB4l2Uy9dCLFJj1ORAlgAdzm0EyqneR/FtPos=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 6 Nov 2025 22:38:04 +0800
kernel test robot <lkp@intel.com> wrote:

> All error/warnings (new ones prefixed by >>):
> 
>    kernel/trace/trace.c: In function 'run_tracer_selftest':
> >> kernel/trace/trace.c:2174:30: error: 'type' redeclared as different kind of symbol  
>     2174 |         struct trace_tracer *type = tracers->trace;
>          |                              ^~~~
>    kernel/trace/trace.c:2171:47: note: previous definition of '

Yeah, I caught this last night during my more thorough tests. Silly me
turned off selftests to make a bisect go faster and never turned it back
on. :-p

-- Steve

