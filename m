Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBEF8C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B253B6B0099; Wed,  2 Sep 2026 13:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFD106B009D; Wed,  2 Sep 2026 13:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A14156B009E; Wed,  2 Sep 2026 13:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 728606B0099
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:24:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA3C0A02E5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:24:18 +0000 (UTC)
X-FDA: 85169495796.26.7A22C36
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8660F8000A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:24:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=03rCOCR3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IfFvlNMJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AkTpR+om;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qEFrmQyu;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788369856;
	b=3inXg+ElAtegkoAx6wPkBDJbU9YiBycqn8Wz8FLp5kSd8IM3lsO5mtvbxYzOHxZ1A9fkp6
	EyyBrZ2mOVMJvPeVOHO1g0QRqhM/Bwrx/nkc1Z1kbtAg0Vbcjs624M/8suA0nkBBvqWUJR
	N3//5fy1y4qtkzBg0esSbP/TS/dpS34=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788369856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUNdLzt3B+obmz0/uvc7ZdYLsj2rpEauUH6Zj9gRlpI=;
	b=0C/A6vLK3vAN7wgM/0K3Xc5qS6idz6XdyqiUpZO/C7WKsABFJOo3HPWrWf8hWDIbBs+viz
	+j6AvypbEOVILsBalizD+xLKBU6wDpXDHNt/ECIspugWGxkR93jgciBpl7JrndP2YUCYo3
	BjxrgP/ak9twVSGJxhgIg5CsFDVXXqk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=03rCOCR3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IfFvlNMJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AkTpR+om;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qEFrmQyu;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DDDFB1F7D2;
	Wed,  2 Sep 2026 17:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788369851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AUNdLzt3B+obmz0/uvc7ZdYLsj2rpEauUH6Zj9gRlpI=;
	b=03rCOCR3BJoIbHiyGjBeKHdAVeDMPmvPjXyURPTcm1m6e/0sMuj4n2uxAWYhvzsME5GkwD
	HLIR5GUx0WKPddST1Uhx1Ed03Mox3J7C6PO/wT8WkjniwtVH+v0zX/MQsVDBUKu5tg/PZZ
	oeKu+l/J0myBGSwYiP7E5Q0D/Dk0jbk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788369851;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AUNdLzt3B+obmz0/uvc7ZdYLsj2rpEauUH6Zj9gRlpI=;
	b=IfFvlNMJ336DEZD0B2zekR042jrjDTSsfnmDPWqEnFqEFGrcDwcZxuCsWnv9VQpO0J3wEy
	QQZ+BC659ED+HcCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788369846; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AUNdLzt3B+obmz0/uvc7ZdYLsj2rpEauUH6Zj9gRlpI=;
	b=AkTpR+om/+RHTyIo9ZrFpob1Un2lZA1KA+j16m2SWmu3JErFMnpR5LwrTlULGkCOrN1uuC
	vZiJRuvzIJDGU8R6LLc3rR0POFS6AWBhGVrx+DXTkO6/LUnzcdi7wQsBlWZr9zk6xhQ/PD
	8qfYc72Q/yDVCFVPOhlrrhT4O/QDHdA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788369846;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AUNdLzt3B+obmz0/uvc7ZdYLsj2rpEauUH6Zj9gRlpI=;
	b=qEFrmQyu1Fa010wKUTd69A8LjemcSjMJKU1KSAtIA7Ir4GJ/UsYSHuc+tujzauHcjCnYNF
	VzZt4CpxsL+5C3DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 95B8C13515;
	Wed,  2 Sep 2026 17:24:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hbITJLZbmGo+RwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 17:24:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2C9A7A13B5; Wed, 02 Sep 2026 19:24:06 +0200 (CEST)
Date: Wed, 2 Sep 2026 19:24:06 +0200
From: Jan Kara <jack@suse.cz>
To: ayhan =?utf-8?B?YXlkxLFu?= <nsd.project.dev@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Neural Storage Driver - learning page cache
 prefetcher
Message-ID: <o5ihhfa252cjfspqlag65xhnmehz3a5feyclmlyy4xlrcmceck@njmhyu7oom3d>
References: <20260725182628.221603-1-nsd.project.dev@gmail.com>
 <CAFLp9PEQQVuDpJPwrNvLN1-u3w3TMwZPUUrf0+rOBrvDjBBf1A@mail.gmail.com>
 <anlByPDZmvEhWeXI@casper.infradead.org>
 <ffcij36vnozf3rginqd2opd2dwqyki7xhtdo4veuty734hhgba@utjav2k263o6>
 <nsd.1787001235.35928@mail.gmail.com>
 <w7vte4itudtkw2yf4vbmuofiumfffmp2y52dpu2bqvqtdgjvpd@5femyiozss3e>
 <CAFLp9PGkVYZcQT5qAx-RKFOF-urZ92m417zpAeF7ZQempbS1HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFLp9PGkVYZcQT5qAx-RKFOF-urZ92m417zpAeF7ZQempbS1HQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8660F8000A
X-Stat-Signature: zz4ie8j4qithogbi9rtsb1tsmwzoh5ra
X-HE-Tag: 1788369856-468153
X-HE-Meta: U2FsdGVkX1/OQzve1jum2UI0tptDttj75NvXwGhRxuqS21k1b2ubBQzrzEvVwopoZlGW3h9fbVAOezCT8GhZPBmDr8VTgQnKBmbg2Y5EiXWfxSssv1wFuJrzM+dtaJxE+I9op8NwzCpxV70jEtFKMQXKXdSldgMoaMxU3RAfZIPOOo9RlMGEqqC+pKAZZI4Y/s04bLRsgL8rBatJtaF2bTEXIYau5jZ2g5hCafluaR0SGlreCT0sCP6QZ23iqq/hdbd0d3fKE7kpI6+GojLfRAbH5FSuD4MGJfLb7LX5Noycc6Cjr6dDuZ1ozQ4Eum3XLVXVKEUD9ZrZWXaKq46zS0mpZY9k/+6LpmRt/XLsQmcpNr6UKsSB2MyXf7Ve4cuMEhe06q1Imbr6RGm9vq7t5YdAhAMNSCoqsDHIzFMwu1QDSldBCN8+sBKR31qOdXeQLe2vIZImVmgUftKG8Mj6+FNLjDHpPwetPePul6yWfQbZ6vfCi4xo8N18Hk8SX+beQmggxT19fKOgsqzZDMuWEk89NFOJMLf7MqI+Rr87UxIa7bIuT1xQ+4OR/J6ozA3uR6cZPkOyT/rFhWrNqUn1m0AO0hChSxsRdo9DY3yBK8iNduk7BqyXzapol0YON5mTuKiC/qxyNRmWJC5l+JtRCDiKaOtQduuKLCidox7r+LHS1FZNn0zNI9WbhliGseKaj8tvW3yRUeRUSq0B3GeScSrarBRFBjNC2/9p/Er4cZyaS30uo0z6JI9vbPB/UgGByitCa5RDtrAKcW0zotgyjAVNRUN3StJ8zG+tTcUUfhytZpMDIylXazegqR7vcTSu64qqV4EEKgZJOQG/SLNLzINm5a8E9qoUZLOSBiIbgYSqLNdvyat24VK6eWhUowVlAQuPl9DB6olvL3Bw3nrN5sqdtMg/zt3qcEEt5GDRYVeEnJ3p/tNTBqRx81+Hanc18oTEoFYIzJ3S21CWj2q
 bJKD5OPn
 iNWkjvRFLuPH3w2TBjCcxk3mH9QOvisCUzTPSAN/bkdlQ0HR86NXJIh5m9aVGphMRkzGPLrHJtXH2Bc7YpeqqtW+X/h1VvWPt5H9ivWUaRORdgIVQ9MfyVpQmyhAYf6ZfR2EgEaD2XigRF/p/G5lwrY0MJ9AMQyps4/2GuEioIHahwa1wnTNrwgGsxEghFXqZtgk8DJNqZMpb3trUEF7+KPB8TS/BLF74/XuTIvWosL+gjd+sE3TRkSW9Bt11KxBhW2H2xFdYufRezmWU0mIyu/U3fmfKe+ToCfVQc1wv8HowjE6E8QGjCwFhr/CtkpX3+ANMZoRspKQtvaK2JVcat/M66JsSQ7EPAJNGiB7ht62B8pZyNrubb7UtzbemPuvcrncHwK2a8K+2aqrqZVQaIitpulwydKgmTHNSHrOBdLuBMq3vEY719kqmoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ayhan,

I'm sorry for a bit delayed reply.

On Thu 20-08-26 08:26:31, ayhan aydın wrote:
> Thanks for the review and for the questions — they pushed us to go back
> and measure this properly. Since the last exchange we ran a full
> window-size matrix with complete latency and overhead numbers, and it
> answers directly what both of you asked. Let me start with the data.
> 
> These results come from our current in-development tree. We wanted to
> share them with you before pushing anything, so the tree referenced in
> the RFC (upstream-prep-v1, 2026-08-17) is still the earlier snapshot.
> Since that snapshot we made three changes that led to these numbers:
> 
>   1. Jump handling — when a prediction lands outside the kernel's
>      readahead window we now always issue WILLNEED|NOREUSE explicitly,
>      instead of leaving the strategy branch to decide.
>   2. Kernel-window awareness — when the kernel's own readahead window
>      is already >= 1MB the module detects this and completely silences
>      itself (confirmed by its own counters), so it never competes with
>      or disturbs a kernel window that is already sufficient.

Err, ok. I guess I'm somewhat missing the intended purpose of your changes
then. Is your idea that if read_ahead_kb (i.e., maximum allowed readahead)
is set too low, your algorithm will fix it up?

How I was understanding your intention is that your algorithm aims to
provide a better guess for appropriate readahead given the workload *within
the bounds set by read_ahead_kb*. Because read_ahead_kb is there for
sysadmin to allow restricting readahead (e.g. to avoid excessive memory
consumption from readahead).

>   3. Full instrumentation — per-run p50/p95/p99/p999 latency, per-pass
>      usr/sys CPU overhead, and disk-I/O accounting.
> 
> We'll push the updated tree to GitHub once this discussion settles.
> 
> Full metrics matrix — methodology: interleaved ON/OFF on the same
> machine, drop_caches before every run, 3 runs per configuration, 6.2 GB
> SQLite database and an 8 GB sequential file. Disk I/O is byte-identical
> between ON and OFF in all 96 runs — NSD never issues extra I/O.
> 
> seq64 — 8 GB sequential file, 64k requests, n=131K/run:
> 
>   kb    | OFF avg  ON avg   diff  | p50 OFF->ON  | p99 OFF->ON   |
> overhead (usr+sys)
>   128   | 22.02s   17.11s   -22%  | 50->23 us     | 812->805 us   | 5.94->4.33s
>   256   | 17.08s   17.22s   +1%   | 20->15 us     | 824->1129 us  | 4.07->4.13s
>   512   | 16.81s   16.96s   +1%   | 16->14 us     | 1092->1903 us | 4.24->3.60s
>   1024  | 17.25s   17.03s   -1%   | 15->16 us     | 1903->1883 us | 3.67->3.74s

OK, so for read_ahead_kb >= 256k the difference disappears with your disk.

> SQLite Q2 full-table scan — 6.2 GB:
> 
>   kb    | OFF avg  ON avg   diff  | overhead (usr+sys)
>   128   | 24.51s   20.48s   -16%  | +0.95s
>   256   | 20.05s   16.60s   -17%  | +1.26s
>   512   | 15.31s   12.18s   -20%  | +1.06s
>   1024  | 12.22s   12.09s   -1%   | +0.26s

Interesting that here the difference disappears only with read_ahead_kb =
1024k. Isn't it because based on 2. above your algorithm disabled itself?
Also how come when your algorithm is enabled, results were still improving
as you were increasing read_ahead_kb?

> random4k — 100k random 4k requests:
> 
>   kb    | OFF avg  ON avg   diff  | p99
>   128   | 25.0s    25.5s    +2%   | ~0.98ms
>   256   | 26.9s    26.0s    -3%   | ~0.99ms
>   512   | 25.7s    25.5s    -1%   | ~0.98ms
>   1024  | 25.4s    24.7s    -3%   | ~0.99ms
> 
> random_repeat — 100k offsets x 3 passes, n=300K:
> 
>   kb    | OFF avg  ON avg   diff  | p99
>   128   | 26.8s    25.1s    -6%   | 0.39ms
>   256   | 25.1s    24.0s    -4%   | 0.38ms
>   512   | 24.5s    24.4s    0%    | 0.37ms
>   1024  | 25.0s    24.7s    -1%   | 0.39ms

I'd say no matterial difference here with read_ahead_kb >= 256k

> Honza, you asked whether the difference goes away at 1M — and yes, it
> does, for both workloads. The 128k default is the dominant factor; at
> 1M the kernel alone already reaches this SSD's bandwidth ceiling, and
> NSD recognises that and silences itself entirely at >= 1M windows.
> 
> But the 512k row is the one I'd really like your view on. The kernel
> with a 512k window alone (15.31s) trails the kernel with 1M (12.22s)
> by about 25%, yet NSD with a 512k window reaches 12.18s — the same
> throughput at half the window. Our block-layer traces show OFF@512k
> keeps issuing ~512k requests, so the device is not the limit. It looks
> like the kernel's window growth is capped at ra_pages, while the
> fadvise-driven expansion NSD triggers is not — which, incidentally, is
> why distros end up hand-tuning this value. Is that cap deliberate, for
> latency or cache-pollution control, or is there room for the growth
> policy to self-adapt?

I'm not sure I correctly understand the question so please rephrase it if I
answer something else but it is deliberate, that explicit readahead (e.g.
through fadvise(2) but also if you just do large read(2)) is not bound by
read_ahead_kb.

> Willy, on the architecture: hooking only vfs_read and skipping the
> fault path was a deliberate choice to bound the first iteration, but
> you're right that it's a gap — filemap_fault bypasses vfs_read
> entirely, so we're currently blind to mmap'd workloads. Hooking it
> with the same fprobe is the next step. On replacing the PG_readahead
> folio marking: the matrix above convinced us this is the right
> direction. The kernel's growth policy, not the device, is the real
> bottleneck at default settings, so we're moving toward a design that
> manages ra_state directly and measures its own waste — per-file
> tracking of consumed versus expired prefetches with adaptive
> aggressiveness, which is really just replacing the implicit
> assumptions behind PG_readahead marking with explicit measurement.
> Backward access patterns are already handled by the stride predictor
> (negative deltas, forward/backward counted separately); a dedicated
> backward-pattern benchmark will be added to the suite.

Just one note here: I wouldn't focus too much on default settings because
most people tune them to different values with udev rules. What is
interesting is whether your algorithm beats current readahead algorithm
with proper read_ahead_kb for the device (i.e., usually 1m these days).

> Two things we're still working on, for honesty: at 256-512k the
> sequential p99 regresses (~0.8ms -> ~1.1ms and ~1.1ms -> ~1.9ms) as
> the prefetch regions push the device queue — the usage-tracking work
> above targets exactly that. And the random_repeat gains (4-6% at
> 128-256k) suggest the predictor does help beyond what window size can
> fix; p95 there improves from 296 to 243 us.
> 
> Questions we'd value your input on:
>   1. Is fadvise-driven expansion beyond ra_pages acceptable as a
>      mechanism, or should the growth policy itself change?

Not sure what Matthew thinks but my opinion is that automated readahead
(regardless of algorithm used for deciding it) simply should be limited to
read_ahead_kb. That is the long-term Linux behavior and that is the knob
sysadmin has to constrain readahead algorithm if he wishes and we should
not break it.

>   2. What would a minimal integrated design look like — replacing
>      PG_readahead marking with direct ra_state control?

I'll defer this to Matthew since I'm actually not sure how he imagined this
to work.

>   3. If we iterate: fault path first, or usage-tracking first?

I don't have a strong preference here :)

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

