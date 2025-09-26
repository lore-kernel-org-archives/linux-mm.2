Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FA46CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 16:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5F2F8E0010; Fri, 26 Sep 2025 12:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B11F38E0001; Fri, 26 Sep 2025 12:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4CDB8E0010; Fri, 26 Sep 2025 12:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 910698E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:47:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2FB5311ABC1
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:47:31 +0000 (UTC)
X-FDA: 83931982302.14.7F7445C
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id CAA0F40011
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:47:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=ljXSG67H;
	spf=pass (imf01.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758905249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkJDBXqcTBkhFi7bi5uYOrbxPVdpxGs1mDpjP3yjmjA=;
	b=JYMiux2pL0DBXfnoA+tAGeqFPKt2Q/f/caTf56amtzlCQcQuQcYoipHqfrNSt0gW42blMf
	7GDLB4rfoFlhCrP2vWEcUaIb+F1dK3y2wDUwYl2pBDl1HvbwFpMV7iGNzCcDwEmDPYBbCt
	Rf/8jlGUIoMOGV51hd8ZJfhawmidJzw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758905249; a=rsa-sha256;
	cv=none;
	b=zMXTmGdDwxoCflG1MyHozlOXLs7kaHTirGurkgoXCvbf8CTGCTzSW79PrpthGmrSLugGYp
	awBznDcEK+FRK8yK5COpo1CKJfvyMvaf64FLTYjgvFh2FbuOi+HHqdpBXbQkuUIgi4zjBg
	TR0eFLuCCe6olSeppxtt1lhDx3QdKKg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=ljXSG67H;
	spf=pass (imf01.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:Message-ID:References:
	In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kkJDBXqcTBkhFi7bi5uYOrbxPVdpxGs1mDpjP3yjmjA=; b=ljXSG67HJCSdMt+v99g66xPI3h
	mzfwaGEtzzmi0+C17cEPOGCSKs0fLLtWDnqW5sPYZfVSzrIFsfBiRXOIgZ6uW2iGiJrwY2kJw9eQP
	BCjpT3v4Qwknyx2U0KBL+TL6I9udxPEhyonFAm+ttIGYKPYAKLF03L71FgAxoZOW3IwRrL3vQcwPb
	CPh72OQkpjtqMCr+v5eY7TUECiQLBC8/fXowZcWCBXDUMUwArKSlCayGPccdoI1khlWcmRIS7/TMi
	drF6o5nlIKcpu6CKIwqDkjBRzKP9Ja4dPVp71DTtODpM0seNR+3oexWxXNlsVbUglrawv6kIw1r5l
	gJC5XADw==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
	by fanzine2.igalia.com with esmtps 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1v2BbK-000jlo-5o; Fri, 26 Sep 2025 18:47:18 +0200
Received: from webmail.service.igalia.com ([192.168.21.45])
	by mail.igalia.com with esmtp (Exim)
	id 1v2BbH-00FPgX-8f; Fri, 26 Sep 2025 18:47:18 +0200
Received: from localhost ([127.0.0.1] helo=webmail.igalia.com)
	by webmail with esmtp (Exim 4.96)
	(envelope-from <mfo@igalia.com>)
	id 1v2BbG-00BzAS-2B;
	Fri, 26 Sep 2025 18:47:15 +0200
MIME-Version: 1.0
Date: Fri, 26 Sep 2025 13:47:15 -0300
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
 <vbabka@suse.cz>, Oscar Salvador <osalvador@suse.de>, Suren Baghdasaryan
 <surenb@google.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-dev@igalia.com
Subject: Re: [PATCH 0/3] mm/page_owner: add options 'print_handle' and
 'print_stack' for 'show_stacks'
In-Reply-To: <aNY49sdoFVe03m_Y@tiehlicka>
References: <20250924174023.261125-1-mfo@igalia.com>
 <aNVpFn9W0jYYr9vs@tiehlicka> <4c2a467113efd085530eb055e4a4e1fe@igalia.com>
 <aNY49sdoFVe03m_Y@tiehlicka>
Message-ID: <d9af42d5cb9d427632087c5f51e50501@igalia.com>
X-Sender: mfo@igalia.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CAA0F40011
X-Stat-Signature: md8jkbgd7rjot3og5pzminh5esq8r9se
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758905248-537281
X-HE-Meta: U2FsdGVkX18O6pAhCk0y+k34VBVc2aArlZglmrmpj1+Up7GYm+rFzGPmHEH5idp42THfP43WRX9zenGAa8NWVhTEGHcgvWMSfwGMthelar7Uh2mX7L3/ecZCfS8gbiJoKw68tLeqSa/mWx31zfqC9rfSlw9kKkl4fWunEYYlttKyeOxFFmsknST2GBUAFgbC55RqL/gHV5G0icCLd1jPF/0r/Ql0UDlpZka/9+dBpvgBp/rQ4jrg1OBQJIKROp/ZDhRtyqly/1xU25X/B6nXjI63q086Le1A/GLZ6htWo63z0HyocGPCa+vsJvbbTSMj9fvlAQJmJw2zyMxTinkD5dzzml+AXOrd4SOmkfyWMxD7fR00yPJ1E/1iRYDCyBU4Pv6CfItJUcmyOTISYo/f10CIA59uzPGStWgo6XjkWCC5d7cVCTpU4vjlNRJ7hS9ORpGmh0hY7JVgOkYpiZXBCPXWexrO8G1IJIVX4g5b59jwiZ5AUoLShF+/GAlHC6VYQofhpomKBA5bMd1lfDfpiSIFiCdSw/wFmTsoSk5vw6nZ9Ac8v1tNHPXPpdZ3IbkV8YBDv9bUw5k+buzHX9GvcYrtfVnXtgM0Bpzg0crH+mBef2PmU4p6in7RWj34GXPbIHUfugIessK2M1fxqrY6fKrEGgd3ahQjEaI+ILLAospb9t+rtX3upsOiSErW1FziCNnEZ/sqM+Up33s+54akuWE6I+8mB3z1kHOCwFOiFeqWqNFmOUvfXY/CgdgS168cI/FX/O4cYrNI5m9zx6ktzXGpEPS8pzKm9i47uz+bgw7MlzsE64J1fcK1l1idY58MaVCIfh/01O/Na6f+ZBsxjwppsqL7iWrVNSt5pCXqb4D/wNWPsTALvOuxRpi4nV2sv+ZzmbRh2hsPuw1p+INGzJS9jKfyS5ugaXhGj38uURNr2vHMTiByh2h+hAAbmqVNEYwvbIlEtn2QIQIvR56
 zcNF1yTU
 zIdzs0Fmqd2LDwAYIFTNfYWlI0F8Af4H8FYxIs7BEvnXtuJZCN8ZXkEwpZ4VKZsZnW5i1MxQtItHkZ7pL5TEoT4GPJhyAxZ8r/jm7H0Z+YQEFUIccpakZ47QH08J5Pu3F7xMWeagcuYfsoXo3tWpd/DO09aCfsdkM1QhuyoPJZTC0AXVwZt3W6/JUBR/KjUH2eIvfvosEqYTINwnSgpu8UOGJedB1RYr5c0hy332XjslF939zg5X+Nnj95A0amPRtKIs+fBxY1L1wH2KdMXEs8nUUbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-26 03:55, Michal Hocko wrote:
> On Thu 25-09-25 16:38:46, Mauricio Faria de Oliveira wrote:
>> On 2025-09-25 13:08, Michal Hocko wrote:
> [...]
>> > Could you elaborate some more on why the performance really matters here?
>> 
>> Sure.
>> 
>> One reason is optimizing data processing.
>> 
>> Currently, the step to obtain the key of a strack trace (e.g., hashing)
>> incurs
>> a considerable work (done for all stack traces, on every sample) that
>> actually
>> is duplicated work (the same result for each stack trace, on every
>> sample).
> 
> OK, that was not really clear to me but the above seems to suggest that
> by hashing you really mean hashing in the userspace when trying to
> create a key so that you can watch memory consumption trends per stack
> trace (hash in this case) without post processing.

Yes.

> Stating that more explicitly in the changelog along with an example on
> how you are using this would be really helpful. 

Sure. Thanks for pointing that out, and making the effort to understand.

> When the interface was originally introduced the primary usecase was to
> examine biggest memory consumers - e.g. when memory counters do not add
> up to counters that track most common users (e.g. userspace memory, slab
> caches etc.). In those case you need to see those stack traces as those
> are giving you the most valuable information.
> 
> I can see you are coming from a different direction and you want to
> collect data repeatedly and watch for trends rather than analyzing a
> particular situation. This seems like a useful usecase in itself.

Precisely. I can make that more explicit in the changelog as well.

> My main question is whether this should squashed into the existing file
> with a rather strange semantic of controling the file content depending
> on a different file content. Instead, would it make more sense to add
> two more files, one to display your requested key:value data and another
> to resolve key -> stack trace?

I see your point. Either way works for me, honestly.
Let me justify the current way, but it's certainly OK to change it, if
that is preferred.

The use of option files has precedents in page_owner itself
(count_threshould) and ftrace (/sys/kernel/debug/trace/options/*).

The use of output files needs more code/complexity for a similar result,
AFAICT (I actually started it this way, but changed it to minimize
changes). 
The reason is debugfs_create_bool() is more specialized/simpler to
handle than debugfs_create_file().

It ends up with a similar pattern in a common "__stack_print()" to avoid
duplicate code (conditions on parameters to configure the output), and
it adds:
- 2 ops structs per file (file_operations and seq_operations, as in
'show_stacks'), for plumbing different behaviors down to different
functions, to call the common function with different parameters.
- It should be possible to reduce it with private fields (from
debugfs_create_file(data) to seq_file.private), however, since
seq_file.private is used (iterator in stack_start|next()), this needs
more code: a new struct for the private field (to store the current
iterator and add the new parameters).

So, I went for the (IMHO) simpler and smaller implementation with option
files instead of output files.

Please let me know which way is preferred, and I'll send v2 with that
(in addition to the changelog suggestions).

Thanks,

-- 
Mauricio

