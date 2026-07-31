Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E26B6C55162
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 02:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA00E6B008C; Thu, 30 Jul 2026 22:42:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4BBA6B0093; Thu, 30 Jul 2026 22:42:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3A576B0092; Thu, 30 Jul 2026 22:42:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA4C6B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:42:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2845B801EA
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 02:42:23 +0000 (UTC)
X-FDA: 85047522966.20.E908A0A
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf18.hostedemail.com (Postfix) with ESMTP id 072D01C0006
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 02:42:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L4fSBc1D;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785465741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5vd8Y68OMp3ByY8Fv4tlZIkUBxHvZtmlUKnrS2bYAc=;
	b=zwkwLe6kStoiufg4lyHmlTCqLUbB5HX6KVn+d6+Im1Bj349pkh01RtHqJN92pu8H9N3UP9
	2Rmhh29dnFTMjA+c+ABQ3vZVpudoryFa5l0XmlKa5WZ7yRe0ZxewZ8CCpg5aAkzpiB7Iri
	wqUR449JKRLOLnuI9lVXM/9wpxL5Mgs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785465741;
	b=hRfBoMmsd4a5X0baKob+Za5G0+TKegqlHZUO0xEwNaLZHq9x/hoDyC0ORWL+4K69vXDTNk
	ft2A+sP0WODiFj1V3AESW6hsYOWiCIe4YwIItim6toXpVtMPTuwgRRTle+5Qm7B3GNbIDi
	RkBZUpi0QfHlqBJn25lmGC404dVHGts=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L4fSBc1D;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <0dcd8c2c-d841-47c2-997a-640d1937a77a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785465739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+5vd8Y68OMp3ByY8Fv4tlZIkUBxHvZtmlUKnrS2bYAc=;
	b=L4fSBc1DvMrziitlgcvvYvoyw+1c+owjsre19jDjKLmbac9gNbGjJza6q2XyhHXK4PdIxp
	5HVFgNrXnpAsAqrDG3bQNXoFzu0DKejya/6H1/GUswGQnlp+X1OYKgOPxrCakdQZ7k4QL4
	k1/qplv5HTcXShgA+3l5floNc6hHmyQ=
Date: Fri, 31 Jul 2026 10:41:52 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] alloc_tag: expose profiling and compression states in
 /proc/allocinfo
To: Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>
References: <0d84763f140ea735d790e0b30a8e954536beb875.1785455267.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <0d84763f140ea735d790e0b30a8e954536beb875.1785455267.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 072D01C0006
X-Stat-Signature: kcoxynt5n5zh89gzh1ou1ctt58n789z7
X-HE-Tag: 1785465740-403663
X-HE-Meta: U2FsdGVkX18YLiuO3QQ1uShrWWn3mRGYRsvzsEEdozmSfWI4RLQjHftXamtB+V1aLj+7ZGsDNezhVwOtFWM4MWfbpnoS+qpjXXOalD18BpkhRlU90zThhahhixAg9NyFitRM9bHxTr1KnkLz9uFKl6iHOs32+hAiYMva9VMTT1Nqdt0c0Dw/58znJc8QJUNrcym0wj4kzvPM0hniXimRb66OVarjGwIsh388kz5aNk2FBGYOaVzSQoc2wSgz7r/kqXQszSZczZx46QIsJIgHmzBfC9jT3ovAW3BixmJoT69PbCo5tRRDIu3HDTiTDaLabE48OjvWVDbo0iv6On5EXDA4dONPXyY2ZTZeTM7JMA8lKd2a+zLlDc+UCcMkcudlnquRA27YFf6U8U1fyrlGiTxNr0p2V41mEf59sV1JIkv+rleeMABd6dN32UF8M1LMT/iWiJwnJMspsHOIXZXCNqg+nAEmAhLJHEVE+CN4cbkqNYcfviCCkdXaJ52+C2/XuYpIWgZn3xJ5KuB3xkiurayC3OLpSR29jtbWeLhbaxfIdyMzR5UuypkphTNZIx5zio2BaJKngau7Cto3EStHS9WEVrj6eYxIcoUW98FFN01rG3uh0cUS6Ks3u6XP9fIFHh2OV3A4eeJGhjRYvHUhX6tv+cxPR8gcTKleJ2Pj7wOYlK/jT7HN78STdmCsUCfO5QRHOMCc797Sv14cq1mXKcMrUpWvG6GavnjLCpzrOd2i1HkkKJBELHq+OiGbs/N2RZXSJKQQmAmTsmJ4wk2/GH3O9VUJxDtj5kO/5+owhfFNJQR6vPbKqg2xicu8AU+E+uiRwl+3DOo2x0WcLGp1QLliUF4sY2XL9Dj6XmOp6GzgVuxzYAFmO6ahPPssGAPms+Rte4yBXWrX2oiPzU6rojss3X4VTtpLAfx/lgq/cITquFd6hoKFzh0i7fzpqL4HtTMsoVvrZXkUrIQ6AZG
 Htewf7XG
 pKby0/G4FMwN9xrHVXT04rFk8hQpJj/aX+cfhb+ZqV8J2TgK3fr1I62+Y4BD4D8pfi8CPoJyvtC24aNhttujhuUm27p0k3ri4yyXqj8tgACvdfEB6c5wJGGjDmOi4/tEIls7CbkcdEhw5t0PIFRV0OFAPxkoE6y0j6O5LJ2kVdHipSRWB1twldiC7YtpCVvuWzTVBnGE3EnWLDUpN4x8U8kjTVVvvlmkIyqRREQ+7ONW4+DBYMl+sugLXnbSwe429Cv9KCw2dPzL1/fZx0WV3mZrlXWcF5zoVb9OQzWj6N1DQKDRcktvqtTlGtrxYvUKvoNo+FewWjPKdusP4Oh1rwc3TcNZZvbPcAxxRhkaJ64i8oeA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


Thanks for the v2 patch.


On 2026/7/31 07:48, Abhishek Bapat wrote:
> Currently, userspace has limited visibility into the exact active
> runtime state of memory allocation profiling and its page extension
> compression ('sysctl.vm.mem_profiling={0|1|never}[,compressed]').
>
> While reading the sysctl provides basic on/off status, it is currently
> impossible for userspace to natively determine whether page-tag
> compression was successfully enabled without scraping dmesg boot logs.
>
> Resolve this ambiguity by exposing the active compression state by
> adding a new read-only sysctl `vm.memprofiling_compressed` to output the
> state.


I think this should be vm.mem_profiling_compressed.

Otherwise, you will need to adjust the procname for this new sysctl 
accordingly.

Also, kindly add docs at the linked path.

https://elixir.bootlin.com/linux/v7.2-rc4/source/Documentation/mm/allocation-profiling.rst#L33


> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> ---
>   mm/alloc_tag.c | 6 ++++++
>   1 file changed, 6 insertions(+)
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


I think adding this sysctl alone won't be enough.

If we set boot arg sysctl.vm.mem_profiling=1,compressed but profiling 
gets disabled due to insufficient page flags,

this sysctl will still report 1 (compression enabled) even though 
profiling was shut down.

To verify this behavior, I have set up a test environment locally as 
shown below:


[    0.265503] 4046 allocation tags cannot be references using 5 
available page flag bits. Memory allocation profiling is disabled!

[root@localhost ~]# cat /proc/sys/vm/mem_profiling_compressed
1
[root@localhost ~]#


I'm unsure whether we should initialize this sysctl when profiling gets 
disabled at boot.
If we do, we should set mem_profiling_compressed to false in 
shutdown_mem_profiling.


Thanks

Best Regards

Hao


>   static void __init sysctl_init(void)
>
> base-commit: 2ed26e8a624f41887d64e2e37a2f6ab36a118d1f

