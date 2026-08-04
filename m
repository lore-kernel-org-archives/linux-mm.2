Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBF7AC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0166B00AD; Tue,  4 Aug 2026 00:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 959BA6B00AF; Tue,  4 Aug 2026 00:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86F366B00B1; Tue,  4 Aug 2026 00:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 675286B00AD
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:13:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFB24A198B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:13:18 +0000 (UTC)
X-FDA: 85062267276.30.30671BD
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id A83FD1C000A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:13:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xc0etAQ7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785816797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tGAcbF/aClnVAzYmccj+436eDJyX2PUbjNzvGxNNzNM=;
	b=dKB5rkgm3lJzZ7wKqLc5q9+kdtLHKqOMG64BxChU2hbkAasYZAC2YVckcxjmloAse5oGBj
	Og9Pk1uPDitqi/SuXWucn1Md1IVxQCr8GWFV9EtZ6zwNmHgRqCbkt/tJl36QKA3vnJ0hPv
	PxrQRp5EVwZhWQMxC9tO5kVAsxanSsw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xc0etAQ7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785816797;
	b=P05kFq1JvWe/yvup3d8u5hlUaUX0cEVU9WUUyE8uXDMaY/bggkFX3evRxmk/DvbMLfICAD
	BhS9Tm7zxjMNYo6x5vDHsyAqky/NcwAhqc6Lx3b7MWUpuuKxhGJ9eHtZY1eTq4LMR4fQx2
	UthgpKItkJRU3cKLtqBlsLh7LLQRd3g=
Message-ID: <0b95c0df-8cf6-4ad9-9552-d7c4a657a25c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785809723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tGAcbF/aClnVAzYmccj+436eDJyX2PUbjNzvGxNNzNM=;
	b=xc0etAQ70reFjdwiMXEOqTEtJx6A2/3WI8/bK+VG3j+U4CkeKUzhIY+Brak0CZTxmxz+9n
	UmbG3q06FTSxw/KCM02eZh+Bm7Jg60zh2t6h1s93dClDyTEWmSA6jM85mvoFV9Nqlgmfee
	aKgHON3ewX2AUm6enbrGDd77vFVYI2A=
Date: Tue, 4 Aug 2026 10:15:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3] alloc_tag: expose profiling and compression states
To: Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <d635115cfafcd35c8e3344b418acb1020aba1052.1785794035.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <d635115cfafcd35c8e3344b418acb1020aba1052.1785794035.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3os18wjcex6krt6o683337ewxbkrdj57
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A83FD1C000A
X-Rspam-User: 
X-HE-Tag: 1785816796-141221
X-HE-Meta: U2FsdGVkX19971sgc2rqycYuv4XWZro5+Tk0dfNXxH4Vh5fnO8LmITN6F0NJwEGyxKIpQflyIFUfns74ef75GwZ5IZgPWfUAEUNRK6k2m6XzK4cj7BLUM6iuoHBkutn5gcA/gDKXHw1XeVTaG4+m+OHfVcEifu9HRyq0DVskM+xs+ShR9SxfIMT6iKrOJjU4zW74lhk2uq9glZtRJkPwu3oVXMyJ6bsj7eMWzZ3/X/+ono5OzsZUAA9imC1XeFZHIqabMxbKlmT8TjEr8nQ77Z+lR+VsJCksxjwxE90vGFn7vkx03h7kKO/NSB7Ri84pAm/iTNXnSCGxDLGB2HUlmK+ghHe+YCUG2xm13NrHmmibVBtIASfRMCgEZ1e8buczJLNmhsAZnCItpfJfG86+3H2dy405eNRJUU9C8jRP2NylEGhNbStRSVXjii8DtiYm2F3s14TKnZ9ivz0OYMuRqdUZpwOkNDY1l1rYFXN78iEEurlKj9UWj3krvQV5L2EtIyJHg97Vh9HL+X6GQfFeziNH68mEDyK6ShzOnj66YTKCQJ2CudTwvfGzTvgZKLLl7DV+C8P9tLNQigRCBgCLTkUtrzvIZn3BS8DsR06gc8MXohtHkDW36nOf0Hh6+M6Pmga3YPUw5sk1nFibPrujl7EzDAeJozCGjksS8NVd7SBj90dl7bBvjcKpoZwvpiwQOswHcqxjefGiBvakZLFXszcfqd9CrcGjDevziqeAO2s0r7slbTCZGlFkveWOjvPVSMCnjUguVozWcxEnqIut14d+umEAsMB3DlNl6RtaFnOQm8o2AvIZqq4nHO4fSSwX/KJJmhPEAGPiYggA+HLy44DxLErxkY4RS0kW3V1BY9DhusQU/X2iPrsAvzrTuejFgLRKuZRpZK0m0tkGzmSLQUuRm+A9/CpzGmUM8Uz6yN6JDAUEhVNvqtirbIfUaPcZqGITL5ZPTdm60h82SGE
 RB38WY2l
 1VotNuLBLY6kivjBjqbXmL+oPcyCju4fRy1B30uxTXKlCBjktelZ5aTszTT+gfIQgWH1a2FmuUaYndIC3B0sD1mlct+wqC7fkvwT3II5h8JBOs297AzHiEVidHK7yszfPEisCENCUFSgufPq3/tGC116oQ+/ss2wWq1u8cujDTR5TLAeMR6rCNT8zv1lfAvGr3FYopDVbhFoPyQARFwqJZ8wuBSriGxynMVFgcwgCwrC9B4TA4bwqk7v9AaHtL5PmidcSdulYTSON1TJZS6qhKlFB3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


Subject says "profiling and compression states", but this

patch only adds the compression sysctl. The profiling state was

already exposed via mem_profiling and is untouched here.

I think we should make this more precise, like:

alloc_tag: expose boot-time compression configuration


On 2026/8/4 05:54, Abhishek Bapat wrote:
> Currently, userspace has limited visibility into the exact active
> runtime state of memory allocation profiling and its page extension
> compression ('sysctl.vm.mem_profiling={0|1|never}[,compressed]').


Profiling state is already readable via mem_profiling. The gap is

only compression. Also, as we discussed, this sysctl reports

what the user requested at boot rather than the actual runtime state.


> While reading the sysctl provides basic on/off status, it is currently
> impossible for userspace to natively determine whether page-tag
> compression was successfully enabled without scraping dmesg boot logs.
>
> Resolve this ambiguity by exposing the active compression state by
> adding a new read-only sysctl `vm.mem_profiling_compressed` to output the
> state.
>
> v3 change:
> - Added documentation about the behaviour details of the new sysctl.
>
> v2 change:
> - Moved from displaying the state in /proc/allocinfo to a new read-only
> sysctl.


As this is a standalone patch, please put the v2/v3 changelog below the 
--- line

instead of inside the commit message.


Thanks

Best Regards

Hao


> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> ---
>   Documentation/mm/allocation-profiling.rst | 13 +++++++++++++
>   mm/alloc_tag.c                            |  6 ++++++
>   2 files changed, 19 insertions(+)
>
> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
> index c3a28467955f..3ad1e9aacb9a 100644
> --- a/Documentation/mm/allocation-profiling.rst
> +++ b/Documentation/mm/allocation-profiling.rst
> @@ -43,6 +43,19 @@ sysctl:
>     warnings produced by allocations made while profiling is disabled and freed
>     when it's enabled.
>   
> +  /proc/sys/vm/mem_profiling_compressed
> +
> +  1: Page extension compression is enabled.
> +
> +  0: Page extension compression is disabled.
> +
> +  This control is read-only and reflects the compression status initialized at boot.
> +  Note that, unlike `mem_profiling`, which represents the current state of profiling,
> +  `mem_profiling_compressed` represents the state configured at boot time. Turning off
> +  profiling at runtime will implicitly make this sysctl effectively dormant. However, if
> +  profiling is toggled off and then toggled on again, it will resume with compression
> +  still enabled as long as the value of `mem_profiling_compressed` is 1.
> +
>   Runtime info:
>     /proc/allocinfo
>   
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 52aece27b00e..877068241f06 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -1303,6 +1303,12 @@ static const struct ctl_table memory_allocation_profiling_sysctls[] = {
>   		.mode		= 0644,
>   		.proc_handler	= proc_mem_profiling_handler,
>   	},
> +	{
> +		.procname	= "mem_profiling_compressed",
> +		.data		= &mem_profiling_compressed,
> +		.mode		= 0444,
> +		.proc_handler	= proc_do_static_key,
> +	},
>   };
>   
>   static void __init sysctl_init(void)
>
> base-commit: 94f9b3980dd446b56acf1dfed649e9b32a9f3813

