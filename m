Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75EB2C88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 17:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7975F6B0092; Tue, 15 Sep 2026 13:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7484F6B0093; Tue, 15 Sep 2026 13:26:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638806B0095; Tue, 15 Sep 2026 13:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42E796B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:26:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB5A7A5661
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:26:37 +0000 (UTC)
X-FDA: 85216676034.15.DB7FE2C
Received: from mta0.migadu.com (out-226.mta0.migadu.com [91.218.175.226])
	by imf04.hostedemail.com (Postfix) with ESMTP id C1C1E40004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:26:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JW0QND0X;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.226 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789493196;
	b=vjZ0EURIbTGX2P6TjG5IORcSI1MklI6qWuoeULDKJHQmGzyv3htwskYzJo6s8h7VtCehaT
	fGR0N5LcLYuBWETDKxCY87HfSHY70AN6KRbHjGAHHijz5FR1Ug1wPNnbyMlPRV0QdTn74x
	E1rWWDDKDfAK/5Lg1pmNfKWVQ5vMv8I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JW0QND0X;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.226 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789493196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/ltWH2RzMlFW5fMkikYymBisCk5BZYQ2PSDR85ncEY=;
	b=v54u2MxFdSJFLjAWmmTRsI2id1yE/u2z6GkVqB74H/Gfbieb4Z1UZWETre+30j5nxV9cJS
	3AQOirA2PcVn4z70aoiUX4jw1PDruYXT5+z1PmmstxZ9mdwYfCHNw44pEGQ/LFw3NvauT7
	0ifO0shaK7nxUa+JGIFn+hL9YAJuukU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=z3VROCEjHUXLMEwm7jbMKvcs86CUi8SjcyFIWtgFK6k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789493194; v=1; x=1790097994;
 b=JW0QND0XDZORdiqlrs8XDHgqK3SNSsfQgDc9QrcVkSbMVtzB/a39wX4Cyl/3tiXmYvH0L0DL
 3nsKmvYMQ3k1pbNW7RxXJI8l2PoOZ7fTkSLqnSbDdjQxX2Vhc0CysTT0qchn5H+6KoNn6ACFX6p
 zR54Gt90d9miP64b6wOdxWSo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ad139adac85be7d6;
	Tue, 15 Sep 2026 17:26:33 +0000
X-Mizu-Trace-ID: ad139adac85be7d6
X-Migadu-Flow: FLOW_OUT
Date: Tue, 15 Sep 2026 10:26:28 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
	JP Kobryn <inwardvessel@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v11 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
Message-ID: <aql_rkQMtlLmMstC@linux.dev>
References: <cover.1789475073.git.zhuhui@kylinos.cn>
 <ee6bcf945910babab2200f05040975492aed21b3.1789475073.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee6bcf945910babab2200f05040975492aed21b3.1789475073.git.zhuhui@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C1C1E40004
X-Stat-Signature: r5kqeyqecmaiye7qu854hhdgjwjyqbrg
X-HE-Tag: 1789493195-393653
X-HE-Meta: U2FsdGVkX18aMD9ApEK5p60FrPk1rMF6T5Vnp/HJVWDTkJAez7f1gfNA1aK4vxkhbAXeWj6FMiQ1upf2oeUKtc7im06HtULXIwECDr5NPDbg3nE9mnooAzLNQME+Mn7rSnYKfQLwL11XIxCMkZGKqFIwSw5fTOYeOI+ZN+2s4gV7W3teKZuQlxO4Gne7u569vnWbFk0ZaGwkReYU1Wfe8N3qmdcd0HY21X77umbMBCBaeHodBBQQCR6EXX6k+IlShGWOvht+nFYr/qI3mnkx914nkMtbXfvZ6WB9qvMJpJGK8dMcFy0YBvsqpIN4JoiyIOjkXIG97sdoOKv4ESNNehIRm2jW02T48e7p2dwLTivpdpnIA3MoCuqtlgaHnQcvze6kppZs7kaI/xiip7eieQWjlHXhNTs77iKWbmb54myJwWIKwhQVESXU8liIA9ACkCDswiQzzhpGz5Qw7HarbxTGm2TD+akaKVg5mfpPM3KiPj9tQ6wU2skOudiKKAXrk0eSQaYaTrXH9L5lIhCVUwLh4Tfbyfo/GSwB/xHA7KLacR2R6fLYXbtHT82LNQuGZWc1b1boMx6c0JqTEUqaciRVGnVgG1YbQ0ePO6lYLrcNOPMeDTO9g7yaS5J/+F2SsnGQrJ4qUmV6SW0oEmYelgOA79RgQLOaAHZ1ZsZexFgpsJwahOUOyTvgliTHImAfjEiYunXWXFTvvocpwf0Tuzn0mUxCaMWYnXS27+doNqDVGMekWQu7VBNiGQI+44WFRB8ftx9iVBHHYQZigHOMXI2PLzjT98kb63TElTqqRogNGwHKGfSxjqkxyV6j9bWpI23MfNlPT/VoU3nuhLQM3KwkNA8Thax+hMKU4/6mqM4J0yaIev74+2bfg/bjcqnmHAPlX6LsaIaxN0DzaAbldzxO80tcHN8H0dRHpiM9+zlGwK1EyJC733L3oBfS1fgtea7Loy9CWLoywNTHZtR
 r2d4yFRL
 GmshiQXyQxWthAVqfjFqbqbrcrQ0StQjlkI60Rx+kWvv+sQ2FBa7vYPR4OO6rq69+Hw2bLD3u+FYSZiM2lsPDW1PEmcpgesWtkT2ZEpQUxUKkf21ObdTLUfKYWP/oCluSUTOXX5m/ovh5sXTByNjINy4pUwTTmSgKs3fbzCAd9u7y6mWWdhMPJueMRHOSjKFh+SWL/ak+u31tfRfpS8svOSdh4JVdW1EvFK/nAZJERFm/aRrBVBtfOyh7lUtzXNuGXImoOz1liGAypzM92IxsdvvXe67Y+lbBzFOkkRqXd3CpGNSLXW5+AI4ZsKsAXWR+z8Rx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 08:29:35PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> BPF programs can observe memory pressure on a cgroup, e.g. refault
> stats via bpf_mem_cgroup_page_state(), but cannot act on it:
> triggering reclaim requires writing to memory.reclaim, which BPF
> cannot do.
> 
> Add bpf_proactive_reclaim(), a sleepable kfunc performing one
> proactive reclaim pass on a memcg, like a write to memory.reclaim
> but without retrying until the target is reached, so that when and
> how hard to reclaim is BPF policy rather than hard-coded thresholds.
> The reclaim target of a single call is capped at MEMCG_CHARGE_BATCH,
> as high_work_func() does for memory.high; reclaiming more is left to
> the program, which can call the kfunc once per bpf_wq callback and
> stop at any point. It is limited to BPF_PROG_TYPE_SYSCALL, because
> other sleepable programs may run with filesystem locks held, on
> which the reclaim path could deadlock via filesystem shrinkers.
> 
> Convert MIN_SWAPPINESS, MAX_SWAPPINESS and SWAPPINESS_ANON_ONLY from
> macros to an enum so that they are emitted into BTF and usable from
> BPF programs via vmlinux.h.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

