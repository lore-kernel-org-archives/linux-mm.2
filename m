Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D716D1039A
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 09:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66CC76B000E; Wed, 26 Nov 2025 04:46:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6447B6B0010; Wed, 26 Nov 2025 04:46:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 559D06B0011; Wed, 26 Nov 2025 04:46:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4690F6B000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 04:46:23 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1CC4160499
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:46:22 +0000 (UTC)
X-FDA: 84152277804.09.10DDE33
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5A14D4000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:46:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YwpnJgsZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n5YuunwS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YwpnJgsZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n5YuunwS;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764150380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=71oeEgOrLPKpQvX3jEg/a7qJc2VeX37MUB5MPj4Q5IE=;
	b=Ny9j9mm3pKSESTIDVJg/KzuiV8at7UrBPx3x5LBmStcS1UobyDKAu2cCGZ601XrJxF3Pmw
	R8UrWLbQgiph3V9vR0mfqwOVRzullPIq7zEf0kLyLGUHlw5nyqyO+3B+lVGw/k61+/sMM1
	1gKLaaSjetNBsmaCng1Z06z7S5P0hLs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764150380; a=rsa-sha256;
	cv=none;
	b=UplKoCwqs0swAMwHEsaXyuEWo0SPoIHwVHCzqoX0nckxleQdSqyTFcrekf1mhuSjFUxEc3
	9a/iMVpbWSE4vcDwfwfVkFeph3mGrvb7CO9PkYMydIg/OIA2unkf4Unlo2SLD7mm6XY1EX
	7EH+q2CZeqrIXq18ud99y6aXqMmE55E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YwpnJgsZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n5YuunwS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YwpnJgsZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n5YuunwS;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6EA505BDE8;
	Wed, 26 Nov 2025 09:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764150378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=71oeEgOrLPKpQvX3jEg/a7qJc2VeX37MUB5MPj4Q5IE=;
	b=YwpnJgsZldJUTmngUPc2nOKl4IE/U8Lh4Dd/iFEuI8fIm6Oums0d37XzCi/FWVns2nLWmf
	NBZgO/HnhWmoVWBlcjwcC9CGPB9QD+3OYd9x7fxClJSTLCszGIIIxR7Ng5J82SGUd8euV+
	pClwwa+kdyeifiYucMvedd3TCMGsulM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764150378;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=71oeEgOrLPKpQvX3jEg/a7qJc2VeX37MUB5MPj4Q5IE=;
	b=n5YuunwSXDFAtrxKN+T/4TpTLKzhWv5rD6r/90m5bm2sQSvhPQY80LOKQw0dNXLQGvxD78
	UvH/7NTnjihSgKBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764150378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=71oeEgOrLPKpQvX3jEg/a7qJc2VeX37MUB5MPj4Q5IE=;
	b=YwpnJgsZldJUTmngUPc2nOKl4IE/U8Lh4Dd/iFEuI8fIm6Oums0d37XzCi/FWVns2nLWmf
	NBZgO/HnhWmoVWBlcjwcC9CGPB9QD+3OYd9x7fxClJSTLCszGIIIxR7Ng5J82SGUd8euV+
	pClwwa+kdyeifiYucMvedd3TCMGsulM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764150378;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=71oeEgOrLPKpQvX3jEg/a7qJc2VeX37MUB5MPj4Q5IE=;
	b=n5YuunwSXDFAtrxKN+T/4TpTLKzhWv5rD6r/90m5bm2sQSvhPQY80LOKQw0dNXLQGvxD78
	UvH/7NTnjihSgKBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 53E353EA65;
	Wed, 26 Nov 2025 09:46:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vjkXFGrMJmmwJQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 26 Nov 2025 09:46:18 +0000
Message-ID: <4cb9f727-734b-43fa-92d2-80559df76c84@suse.cz>
Date: Wed, 26 Nov 2025 10:46:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] WARNING in __alloc_frozen_pages_noprof
To: Xianying Wang <wangxianying546@gmail.com>, akpm@linux-foundation.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 "Liang, Kan" <kan.liang@linux.intel.com>, linux-perf-users@vger.kernel.org
References: <CAOU40uAHO9-59HB2VmCBfC5OiNg3BZBd-32jphtRd-nkvhD6Dg@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <CAOU40uAHO9-59HB2VmCBfC5OiNg3BZBd-32jphtRd-nkvhD6Dg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A14D4000E
X-Stat-Signature: igq8rmsfiek3se3135odo876r7jrg77b
X-HE-Tag: 1764150380-747571
X-HE-Meta: U2FsdGVkX19Yed5UjIV7i/Pi0GHXY0HW4AJibHev1vRgFr56DSCvEFNBl6u1tTbh2u1oWmOSesmK74hvDXrhG1h03eMOU4iZZGUSJdrv6pTv7dv2feyaFGVMtlZMcvrI679Te59NF4xeI966hA/JBhb69+UxBkbh4c6lQERlMxxIJU+xmifWnrykJlVFmkjd4CbGebB/iWStnRRpoqy6rkQPTAbpNbqX0ijYYVQET2s+I+eneb1PLwfolZxC71PpupbIUoTxCW5fNEZnq7eNAEvhD01Z6zLXYSrl9jeba7PPoqhrQZrsd2jaa0OzwVfSqxR2FlkgjnHu0P14WHmWawP34gI4xYj4W9st/OUtPpi4sJWsL+NPSEM8bNHU4zHgzoL9SG4GalDFgbU8tQg7YNAV36IIxWZSCbiIGAYzv4e7BAGVtIFnumIfgP2sFHlPhTKbxKz3akNAZh1P/rLav5xh74hx7Slte17xaCyo0BoJLmM6nRQySHIGBfS17l99iM4Ff+8Bl3HiRfzKi/UUBrd5Tdd4sar6WyhaEr0d38fzt1b110bvU0AR+YWhEagJw0nY5CEBzDjg0xsZQluSKqHO/XM7Uo0czu/qJ/b4MsXhu6PD4tFoy0boF5/luCD4FYgyYZt5m91aTbzeK8WraEX/U6PYU/pa7gcIpDh52XSBqzshJKWdwhNw+oxxx+IFDO64UwUW09hx9dgQoVnap0hmw2nzrbjSk5m7Xd8mANPdV1RmMi/7Zv1H1JvUKliuW3BKWJAIyNjYS+tng0u/0x69Vg6cERDG0jdJXcvAMPUyoKuWUgqujCS0ImpDrQueYflRet+FbIOm0e1DdqpsFhTnaU6FA9k02hLcTTUye7wEelI30WZdxA1HifdRA8NP65S4tnVUdqSfR8kPfd7JJEeoDTQPFi92Q6vyAVDcyXTTzzhgimqK5roQpG+17dDqWHON2hErje4QdE51Z7w
 zfQ8rhSP
 99cTBFNgL01HwQpGzvfz7mIYZsaz5JEPu952jjaZ25qu/YjG84gHXYc/mY/MGDv3Khy4YysaBymA6pZ1mO8syZ/3vjikvlZ4ddmRdyUa+BACt+xYTqcSQidw8tWCvC3BKFS2NtLfzVV9qIHl2dLqL52AvAzKHDnl8Ccf4CmRto4Nl+Z71uT4Y23FDlrs5PQ0jeObhmolQJOSwc6dbYRmWS+O0haOFDsMIQZRcL/NA0mRWQ1xEYc7QGGmlXjShZoRxLsoFWS5GuK4CVCE4LNi4yZDXNJRdZtwrrQhAgWYUFzpnAh4vbbwWJsx3KGpUDqqH6dY8Bdz53Fka2e+pzCIcfuDpSOazg48LNQgGSdYhLawNWNY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+CC perf people as AFAIU the problem originates there. Should the limit
be lowered, or the allocations e.g. switched to kvmalloc, to avoid
requesting impossibly high order allocations?

        /*
         * There are several places where we assume that the order value is sane
         * so bail out early if the request is out of bound.
         */
        if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp))
                return NULL;



On 11/19/25 10:07 AM, Xianying Wang wrote:
> Hi,
> 
> I hit the following warning in the page allocator when opening a perf
> event with callchain sampling after increasing
> kernel.perf_event_max_stack.This warning can be triggered by first
> writing a large value into kernel.perf_event_max_stack and then
> opening a perf event with callchain sampling enabled.
> 
> The reproducer does two things:
> 
> 1) It writes a large (but still accepted) value to the sysctl:
> 
> echo 0x40132 > /proc/sys/kernel/perf_event_max_stack
> 
> (0x40132 = 262450 in decimal. This is below the current upper bound
> 
> enforced by perf_event_max_stack_handler(), which uses 640 * 1024
> 
> as extra2.)
> 
> 2) It calls perf_event_open() with callchain sampling:
> 
> struct perf_event_attr attr = {
> 
> .type = PERF_TYPE_HARDWARE,
> 
> .size = sizeof(attr),
> 
> .config = PERF_COUNT_HW_CPU_CYCLES,
> 
> .sample_type = PERF_SAMPLE_CALLCHAIN,
> 
> .sample_period = 1,
> 
> .disabled = 1,
> 
> };
> 
> fd = syscall(__NR_perf_event_open, &attr, -1, 0, -1, 0);
> 
> The same warning is reproducible on both v6.17.0 and v6.18-rc2
> (6.18.0-rc2-00120 g6fab32bb6508), only the line numbers in
> __alloc_frozen_pages_noprof() differ slightly.
> 
> The suspected cause is that alloc_callchain_buffers() uses
> sysctl_perf_event_max_stack directly when computing the size of the
> per-CPU callchain buffers. For large but valid values of
> kernel.perf_event_max_stack, perf_callchain_entry__sizeof() grows to
> several megabytes, and alloc_callchain_buffers() ends up doing a very
> large contiguous kmalloc_node() per CPU. This high-order allocation
> then triggers the warning in __alloc_frozen_pages_noprof() in the page
> allocator.
> 
> This can be reproduced on:
> 
> HEAD commit:
> 
> e5f0a698b34ed76002dc5cff3804a61c80233a7a
> 
> 6fab32bb6508abbb8b7b1c5498e44f0c32320ed5
> 
> report: https://pastebin.com/raw/bCq3d4KR
> 
> console output : https://pastebin.com/raw/5hfk57Vd
> 
> kernel config : https://pastebin.com/raw/1grwrT16
> 
> C reproducer :https://pastebin.com/raw/GADWbwKN
> 
> Let me know if you need more details or testing.
> 
> Best regards,
> 
> Xianying


