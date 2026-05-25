Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0E7DCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 17:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 147826B0005; Mon, 25 May 2026 13:49:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F9026B0088; Mon, 25 May 2026 13:49:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00EC66B008A; Mon, 25 May 2026 13:49:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E34D76B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:49:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 81601120143
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:49:34 +0000 (UTC)
X-FDA: 84806679468.17.10DA5F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id E5949C000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:49:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=itXByRbw;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779731372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34eaHJRXGUxn6aCaWNiWQiEzep2YC7iFCHhas4g5QaM=;
	b=pIJ5WSxqfjyfz9/qH4WlROJ+NjHs0Dw+ybexCde4vsvkMHuW3/PSx3Lkxw9s5L05F8F6Fm
	Xp5QinfI5uCnTyypKErRQIaniazt+jBArjXMmSdCJeRWb4OjpqyLKmrcUKJHL7N+HEaM/Y
	prLIa69PN4w4nPM9Ye1Ln9ZOvk13DjQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=itXByRbw;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779731373; a=rsa-sha256;
	cv=none;
	b=Z2vr8XmKHy9ob9J0IDiv0oAFMxpYz912NlfHyxhKVrE2aq1EO7o42vJswPN4DltIiAeqCU
	+S7ppjmIyAeQC1dX4RPcK217Ozm7cKDLwpoHQ/Wags4ZVFGTjpCCf7ADOBeqtSYYWhVRlp
	g3sbbFJOZ6/vjROsDOYayo1enqCsYw4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6705E60008;
	Mon, 25 May 2026 17:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24B01F000E9;
	Mon, 25 May 2026 17:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779731372;
	bh=34eaHJRXGUxn6aCaWNiWQiEzep2YC7iFCHhas4g5QaM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=itXByRbw+mP3n0WYUFSgOvuNWwiQkJMyZndGej1Q+qst31PJZbH6hK5bKQPa8pye+
	 8z8HSlCAtj0uObcAzFM41I0i1eME3B6Bi8ajwvxrJYfYLrghnHBDvJdiJzElpB6dgx
	 6udxDWvfBe/N7Wnl4Rg3vu7KbiWdMEYlpoOK3B2DJ+t01suWb5DaAsMMK3B1krviAH
	 GxhO/AdojFJgoYBSOPNzAhbQgIYy8pkvAB/sTodPhcLgM7fa7Xy/FT1idtC3pqgPAF
	 zAo5rkvorkJD1JryB7ndb0kXfNlZDrLT21DM1MHfbYKs+V+EtGAisgsYyQwcWj+KKU
	 ozSnoW+MLfQsA==
From: Pratyush Yadav <pratyush@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: chenhuacai@kernel.org,  rppt@kernel.org,  pasha.tatashin@soleen.com,
  pratyush@kernel.org,  kernel@xen0n.name,  graf@amazon.com,
  shuah@kernel.org,  loongarch@lists.linux.dev,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kselftest@vger.kernel.org,
  linux-kernel@vger.kernel.org,  George Guo <guodongtai@kylinos.cn>
Subject: Re: [PATCH 2/7] LoongArch: kho: strip stale kho_handover= from
 reused cmdline
In-Reply-To: <20260525062810.103367-3-dongtai.guo@linux.dev> (George Guo's
	message of "Mon, 25 May 2026 14:28:05 +0800")
References: <20260525062810.103367-1-dongtai.guo@linux.dev>
	<20260525062810.103367-3-dongtai.guo@linux.dev>
Date: Mon, 25 May 2026 19:49:28 +0200
Message-ID: <2vxzpl2j5qhj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 5ws7kfsbszg7wupoxnj5wsqao19urtkg
X-Rspamd-Queue-Id: E5949C000D
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779731372-767163
X-HE-Meta: U2FsdGVkX1+vmzxAJAa0FuAu/hxXATFzC4C3hzqSLoU/ng35z5Qu3N6uXWtGdnksNcB4DuHkx+rfca1XzHGFSNclQEgKuXCbPw5M5hwe+88ghXAW+KeGUP3BKEbWoN4pdlHKU04gCtWugEe5MYRkdkjnc80MbdTYzhT3DsIJ9r9tXUv95OtBeOAIvwOSq/YFty1DMwO/I3RDgw2f2YOkEOwn6Kst5W9ukM72rUTPIAY2s32c7lt2ADQiyrkAi0bqmxW52nyDZkoWC2okLW68exgMdEvt5RfClPdM/gvK/AVTgm3pydq30CqrwVcvKXRzekjGKsuSIjZRCn5GE9s9BAtPdMl1pKXTxZk9i+ERkp5KR/a4IIlf9sC9QN0OvXjDqJZxdwwe3Yf0O745KuvD2QXOuKoi1Xnf8wmqDHI9ZSHv50ixYKVclYyoaHSDYoIntkmIJDKPJLLQ/2evo99SJOFwOfmTSpa+8XL4fxZXMlgMUfiwX51i/2TvR3M9O+4zwM9vi2646IfuO8R/q8zW/2Tz9DlXfJ77f9olzOQqu5r9xKTTA14ECHzm0JxYTfjUlrcQthPvs5uZibsStNyGdSDh+GlX/kSljNPxam32ijEonelwK7pFUXi1sKGrMXRIBSQjLYGp6lLXfTiZKE4NNkBBMeKP3bLG9jWLq9LfPgfyhi9wBCfaOpTaiS15WvULzjPFcapZmaUhmSpyeSNEeFjn/HFTmCxV+fM146pJy1Otv82IjWYC9wB9Q2rJk8D1fkmQ+6Wx0CPCjUHYgB8SXlNgm8opa6NWWC25n5xRexvOf1RPT3n7qJFxVzGtC9ZXZdzJ/VPQ8aJzD77UcVGbHR0Eis9SDJPZhZd4l/9RjI8S772OAWB9sXMEwFrOLzbdbbyEPwoQf6dFmpHy4jmuxpeS8E05vxr7hs9VsJiqDT75WZpLTK+awDuqSudVzk25ooBWnsZI89De2IILY7a
 YReFuExX
 SQEkRHj1uwZ6EcJnJGGEwGID0nimo39K36ogfgoSsPSJuZC0S13NKiV8ncXBm8LQBmgE6n9iGqqlP2jp9UHKOWaVcJpfJ5TeTjXwv6pa8KlS8myUpsjcToy4Dca0adTDifTEPlr/J8Pe4JfBqoTuTLBH7awGlVuEia/fmTUm+x0A8Sz/6y6w6SDd+eu7gxObnceWlXg+rWVgrlJkSUGRmEHRyUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25 2026, George Guo wrote:

> From: George Guo <guodongtai@kylinos.cn>
>
> When kexec is invoked with --reuse-cmdline after a liveupdate boot, the
> running kernel's command line already contains a kho_handover= parameter
> from the previous kexec load.  load_other_segments() prepends a fresh
> kho_handover= for the new handover FDT but then appends the original
> cmdline verbatim, resulting in two kho_handover= entries:
>
>   kho_handover=0x4000@<new_fdt>,... kho_handover=0x4000@<stale_fdt>,...
>
> early_param() calls early_parse_kho() for each occurrence in order, so
> kho_populate() is invoked twice and the second call overwrites the first
> with the stale FDT address.  The stale address no longer holds a valid
> KHO FDT, causing __kho_radix_walk_tree() to dereference a garbage
> pointer and panic early in mm_core_init().
>
> Fix this by adding the new kho_handover= to the cmdline prefix first,
> then stripping any stale kho_handover= tokens from the appended original
> cmdline portion, so only the freshly generated entry survives.
>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  arch/loongarch/kernel/machine_kexec_file.c | 35 ++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
>
> diff --git a/arch/loongarch/kernel/machine_kexec_file.c b/arch/loongarch/kernel/machine_kexec_file.c
> index ddf4d0e0e7fd..ffaedd055e62 100644
> --- a/arch/loongarch/kernel/machine_kexec_file.c
> +++ b/arch/loongarch/kernel/machine_kexec_file.c
> @@ -71,6 +71,37 @@ static void cmdline_add_kho(struct kimage *image, unsigned long *cmdline_tmplen,
>  	    image->kho.scratch->bufsz,    (u64)image->kho.scratch->mem);
>  	*cmdline_tmplen += n;
>  }
> +
> +/*
> + * Remove all "kho_handover=..." tokens from cmdline.  Needed when
> + * --reuse-cmdline is used: the running kernel's cmdline already carries a
> + * stale kho_handover= from the previous kexec load; without removal the new
> + * kernel sees two entries and kho_populate() ends up using the wrong (stale)
> + * FDT address.
> + */
> +static void cmdline_remove_kho(char *cmdline)
> +{
> +	const char *key = "kho_handover=";
> +	size_t key_len = strlen(key);
> +	char *p = cmdline;
> +
> +	while ((p = strstr(p, key)) != NULL) {
> +		char *start = p;
> +		char *end;
> +
> +		/* Only match at a token boundary */
> +		if (start != cmdline && *(start - 1) != ' ') {
> +			p += key_len;
> +			continue;
> +		}
> +		end = start + key_len;
> +		while (*end && *end != ' ')
> +			end++;
> +		while (*end == ' ')
> +			end++;
> +		memmove(start, end, strlen(end) + 1);
> +	}
> +}

Ugh, modifying the commandline supplied by userspace feels odd... Can
you at all do this via device tree?

If not, would it make more sense to reject kexec_load if command line
has kho_handover= and teach kexec-tools to strip it on its side?

>  #endif
>  
>  #ifdef CONFIG_CRASH_DUMP
> @@ -249,6 +280,10 @@ int load_other_segments(struct kimage *image,
>  	}
>  
>  	memcpy(modified_cmdline + cmdline_tmplen, cmdline, cmdline_len);
> +#ifdef CONFIG_KEXEC_HANDOVER
> +	/* Strip stale kho_handover= that --reuse-cmdline may have carried over */
> +	cmdline_remove_kho(modified_cmdline + cmdline_tmplen);
> +#endif
>  	cmdline = modified_cmdline;
>  	image->arch.cmdline_ptr = (unsigned long)cmdline;

-- 
Regards,
Pratyush Yadav

