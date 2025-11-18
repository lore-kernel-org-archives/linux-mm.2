Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 923E7CEE34D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 19:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE2C56B000A; Tue, 18 Nov 2025 14:26:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBA966B002D; Tue, 18 Nov 2025 14:26:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF70A6B00AD; Tue, 18 Nov 2025 14:26:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF1AB6B000A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:26:10 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6273D1DF943
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:26:10 +0000 (UTC)
X-FDA: 84124708500.12.AF78D4E
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9F7874000E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:26:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763493968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Drmjmt2fMsvwH+OurlcvQJHMCZHB3jWO37bEW6LQKZc=;
	b=SAuvWZI0K67Wk/5T1cY1mO6tgt0Nl0CUav4fSJz3gwNCYBid1/FAo/Da48IDvXhgbP5d8c
	G/zhfyQpBSeit07x9Qqv4C68goKalTz15V0hsBsci0ADhGlm0vgT/+dnSh1R27u5o5seG0
	BynVbeOFt9hLYETZfn7+6zqapJU+W/E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763493968; a=rsa-sha256;
	cv=none;
	b=RsGNpt5GAMXgbHvPhq2CVeD/MgJ7yV1B+yAqDq+7HifrjMmT7pL4IySA6/AUb8QFRaA8T0
	yhKjprW/xqlmRJgfhvbirT0uKhlxBSAW3ywweIrgvT5o1TXC9Ts4D/xU3oVHmUADwlXTLW
	G4vLG4wLw6iOK3JX5IiotMMzrKMHCjU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	none
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 49FED1A01AD;
	Tue, 18 Nov 2025 19:26:05 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id 6318220030;
	Tue, 18 Nov 2025 19:25:56 +0000 (UTC)
Date: Tue, 18 Nov 2025 14:26:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jens Remus <jremus@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, Steven Rostedt
 <rostedt@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>, Arnaldo
 Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>,
 Indu Bhagat <indu.bhagat@oracle.com>, "Jose E. Marchesi" <jemarch@gnu.org>,
 Beau Belgrave <beaub@linux.microsoft.com>, Linus Torvalds
 <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>,
 Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>, "Carlos
 O'Donell" <codonell@redhat.com>, Sam James <sam@gentoo.org>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, David
 Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka
 <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>
Subject: Re: [PATCH v11 03/15] unwind_user/sframe: Add support for reading
 .sframe headers
Message-ID: <20251118142623.57a60a62@gandalf.local.home>
In-Reply-To: <e5c5e17f-1efd-4f9e-be2d-c6f65003ba3d@linux.ibm.com>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
	<20251022144326.4082059-4-jremus@linux.ibm.com>
	<e5c5e17f-1efd-4f9e-be2d-c6f65003ba3d@linux.ibm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18kMxDuWA1tAF9m0DoMD/Jf6AhXJD9G9Y4=
X-HE-Meta: U2FsdGVkX187IrvkH90ckrHBgaHws/CDDckN7oWOSHQjYNUrMmyzebyXREW0G5QsO8LWPgB7KUXrlIl53TbVunkyTH7yH6013m9YXFffYOwssCNgJobXZ42EzqvfFBlvuBf1bDwTdo/cPGPnxjh7EcAhSP0F1bNcPPsTwG6CxpKVWybID+0QFOB0gq1aLVm1YKfNghJNuA7rARi3zkYltVvQULz7rE1Ewqmd0/GNKcO+e3P9xl+9pGtp+4dSugY0O4tKiekgg3+E9xuViKe0/aJvKMAdftbtsFgOa2PIxhuKrghkQmTozwPhe97I/b8vgxn0XYhcL7DlbF/TRMZC+t+3ihZyz2MU
X-HE-Tag-Orig: 1763493956-237256
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9F7874000E
X-Stat-Signature: g4pc9as7jrd8u1x46p5jdz3xuqpq7gjd
X-Rspam-User: 
X-HE-Tag: 1763493968-98382
X-HE-Meta: U2FsdGVkX19q90wHzcSzpRlA0lngaWX2VNzhED8LS3u/53y6hOJjL1VCW5UI9At/4T+maQJMVeDofKj6v/q+Vrtd+nRMLGDrGPOK+1390Y07BmmaL6SU/cVRVIWRhrpzp+f0m8EWuEjhYjVxLFBlA7Y/vZVis0mnIl+pxaq5hJfXMTgIHF0YLZA67krXfaIuQPxG631hxc/EW7zrDCm3vYgEuQBH6uRIoDU2jcP9ibEtDcbXLvJjjXZTQR4j5aH239bDebsXuaZzu/7tav6cmYWUi5dnpWFIKccSkUIaESKv+amHOw4LQNkqN+BBcNolnsnYt+2Br7ALeFvwv1wi1QWGyLmPXX5wnNK2JAx0FkEhfoaIJcSrZ65J6qhDXYYAKBIxauRrsHMaCwppbY9BFzQq8bOxhx5zHzl0/LU/c6sCpwUbjLaXYN/uS6gNHPYzfW6AhNBek5xxrkv7TPbcSpZrD9XLWhP5W6q+P0IhPcBUYzcci/+eudUt+KZrA5cJ5iJwqQrpYhQxjDrU4XQqd3tW6W4M8b6E7/CaWRy+grnwS2xtwNQfRAelIym9/bPN4oYBY5EO2IDZpb1LziSx0SX139MNOC4VpGmP5w3m+pPgbM1OIQ/5Xk3+p7pbuGtm/UkAIN8p3LBSEEbYWCdzjQVhPPT7D0oi1j5aM7h2XLSuMgA2OoCQdiS1lYFgD8HvdNjANoAIqZjQ9UwoJu30aGnI3sCbVfrjSuHIbXYJiXfj4HMaMqHVmtuSG6LtFNty1jI417KCXG8cG9mnQyBIWpltLWPREFWaxzhh7X5QFEUvZEWyp8haBj40dGIraxpiherhFnlA1PnW1jTcJ0p4Jy3GXBoI6KG101T4d3dH34lnEOprF1XXHkgV4e8ThZorxlSUqfsEpHHWX1RQzwfIFZ4DF3XWs2JnPcJTmynNhSz8y/U9UbeR9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Nov 2025 18:04:27 +0100
Jens Remus <jremus@linux.ibm.com> wrote:

> I wonder whether the series should be restructured as follows:
> 
> unwind_user/sframe: Store .sframe section data in per-mm maple tree
> unwind_user/sframe: Detect .sframe sections in executables
> unwind_user/sframe: Add support for reading .sframe headers
> unwind_user/sframe: Add support for reading .sframe contents
> unwind_user/sframe: Wire up unwind_user to sframe
> x86/uaccess: Add unsafe_copy_from_user() implementation
> unwind_user/sframe/x86: Enable sframe unwinding on x86
> unwind_user: Stop when reaching an outermost frame
> unwind_user/sframe: Add support for outermost frame indication
> unwind_user/sframe: Remove .sframe section on detected corruption
> unwind_user/sframe: Show file name in debug output
> unwind_user/sframe: Add .sframe validation option
> unwind_user/sframe: Add prctl() interface for registering .sframe sections
> 
> While moving sframe_add_section() and sframe_remove_section() from
> "unwind_user/sframe: Add support for reading .sframe headers" to
> "unwind_user/sframe: Store .sframe section data in per-mm maple tree" or
> into a new second patch, as they depend on the first and are required
> by the third.
> 
> What are your thoughts?  The reordering might be wasted effort.

If you feel it makes it better, sure, go ahead and do it.

-- Steve

