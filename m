Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85D3DC79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:10:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BC0B6B00B0; Fri,  4 Sep 2026 12:10:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 993CB6B00B1; Fri,  4 Sep 2026 12:10:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AA826B00B2; Fri,  4 Sep 2026 12:10:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DA626B00B0
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:10:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F2711C014F
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:10:22 +0000 (UTC)
X-FDA: 85176567084.07.1F519EF
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id E13E21A0009
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:10:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RHT9oTQ9;
	spf=pass (imf19.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788538221;
	b=8YFdcB00AbVDEEFhvE0lP0nxQJ5OxSdqOIN0xAnTt0xhzF4WE5JDXwJ/gSKJ5RJ6sfJ2JR
	qYjpEDfqEj0yo/YuZRdGf93nElzg93MmYe0w4xlmrTVY4ayAbnQI1uqM9yBy/t5sLvYQn/
	EJGfZo/QsAfOm72Sno4t7vjE5jvg0NY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788538221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e1Eo3Xs09Cv3zHO+VFGveYQjtgcEc68O1MBEL+U3hM0=;
	b=Lqeto35p49e/YxFYI2zytBcYRTYmrpL91E+StdbVcEDq7Agw7txHfyuMQ5PDxsHGV2oBgz
	pG+o8voqFj4gXmu5p2Pv5UHD9CZ7Wk3vqVoRqVXWOxGY0sNwUNxOUNBV5cqY4TH/PcqL/V
	sogZe7YYhy2REu5fryqRzTEKfsXpmt8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RHT9oTQ9;
	spf=pass (imf19.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a7ea0046deso1381036a12.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 09:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788538219; x=1789143019; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e1Eo3Xs09Cv3zHO+VFGveYQjtgcEc68O1MBEL+U3hM0=;
        b=RHT9oTQ9UZgWLKb3qqCyeViPG6Xij5clhID4xiOJBc3uB/HZER1SWOdvtvCbDpgnQF
         ZbQmpYbxAYDN64mktlYJy4nyVIdZ4pbW85vazdId4+QwXnWgP+s3/tdMQZ0cDp9zJFbK
         JgBR4cuIjUmO5d5RrLyM+vqwCCaTtbuPplu5VIggQ42yg8/oZeHljEB+SLmAZg///+4o
         s8vDigHHkjyT16Ai11tKBSZZRQMLKdALlTkSp30bo2QCLVdFjx27zFvy1Q/rqTXACVrB
         FPBm5BzIK/O/Kw58PjUNpaq+eD+0BxqLIsG5NOekVDw5c4f3WHlLod9/K0XCeaI4B+JL
         MK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788538219; x=1789143019;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e1Eo3Xs09Cv3zHO+VFGveYQjtgcEc68O1MBEL+U3hM0=;
        b=kDJJK4KZQiRnH329y8mBuvgrmg5lTryV4bX1T1Wus+lDC8l7hq5Z+m9u74XJKGVhHe
         xpk+LWQLbjVT90nztVbxq8FfdUXJ3OIznRN5aS/4Ty3Cz+IKWxX996U8McC6ToOhPagD
         w2aUyrW5IXixHRRyz4hh2DhGf4wjaylbuF8ppIbFmdvtNlLaA0MTNNixMf+iSFP8pnRV
         wn0Tpf9zJ+DHs1FgjZTKoHVaKE9EQ9pEf7UpkJsunloLuIoJRkjiimZ1VJSIMgG/PGj0
         hjyfs8ZKKaY12P8JEXAlaHEKjOVH8w6r6wFOVdclS9nI2S3C8k8caFnMiMNseQJx/fVn
         7HTA==
X-Forwarded-Encrypted: i=1; AKwUvBycmj9NBj4KpQHn6d94kGne2veMsykKPQwGcMLc0Z9iBmlpm4NfYT9k5bmO+wzC4BMuL2nK2Vadcg==@kvack.org
X-Gm-Message-State: AFuF++k2E2ZYE5FI1C1heui2zrXeX8wRBNqxDzdr81VWG6BVTPdxhGGA
	nTQViqIWyBmxsE1hbJVRqNhRlMnlkEXBwYMW/nHK40JTV98xU0xQWoUitqKwutUEF18=
X-Gm-Gg: AYBFou0QS/K5gqOA5OFIhmZvicOY6WsGeMKR6/4uESB9j7Hrf7xWErc3+gvZ07Ipu9t
	kQb7zYo5RxNx0FgZOUS4zdW0U4x00YLsbL2tnFqv+Ro6pafjDs/Z+iCtzvibEzgnbKlDs9FG+hW
	Xbo8glAD9HS7VCcTtsMeHPDjegTu7tlRGM2NYoUnIymMaQY8kk3KfjoNolX0RZemDSosuDm3XSd
	CwrGny6IfCUCWcTZMfVJ8yJ2jrbJvPS1GMhOoYkgRMCrY9A/25zH1UMjErja23udYFtwRcAcESL
	nJpRg8yEhspJuNK1F/mQ5Ljw3H2eOrZ4CYMckR/IQ5I19mViHjdN9MgxTTnTQF93AJSpL90BThb
	0Aeul6z8VUads7fMf3bNoQlexyU0pTUKUAe/F21OEp62YRqcsDQ76Rij7MTiNpdYaMIEi16/5IF
	7gCwNiPJUGjuFDpfUjcdEbHNp0LpacJC5n/aN7LdEZTCAAgKHTcsGkAKISwBgjFsK2S5QDv50tm
	lvVW/ly0Mf2b3qAIPacJlXP
X-Received: by 2002:a17:907:c00e:b0:c25:254:292e with SMTP id a640c23a62f3a-c260c401012mr368173466b.0.1788538218984;
        Fri, 04 Sep 2026 09:10:18 -0700 (PDT)
Received: from ?IPV6:2a07:de40:8100:0:89a9:fd0e:583d:4a53? ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d53e0b1sm126030366b.33.2026.09.04.09.10.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 09:10:18 -0700 (PDT)
Message-ID: <d2159a62-d64b-4e47-9e5b-9c409ae4de9b@suse.com>
Date: Fri, 4 Sep 2026 18:10:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/4] module: introduce SH_ENTSIZE_STANDALONE for
 separately allocated sections
To: Hao Ge <hao.ge@linux.dev>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Daniel Gomez <da.gomez@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20260902081802.146145-1-hao.ge@linux.dev>
 <20260902081802.146145-3-hao.ge@linux.dev>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260902081802.146145-3-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E13E21A0009
X-Stat-Signature: w6zue1qbn9uqiesdmdzae8bgpjyj35iq
X-HE-Tag: 1788538220-909350
X-HE-Meta: U2FsdGVkX19nytpOg6IrCjxjBKDl1Hw18cEvqZl1vDjZRw4lE+dJjwespiI7M2EhgNUQNxlQs21J6xIsZoEA0bKIhLLqSX8owyYoeyhe5HvH5v2f+KKjfevSGmT5uWynhvR9LP6+CsZH0Tzl/31uZXbjYW2wSl5S7VTFMVrOJj2zRsach2hAYY7DR+oO/sqhY8DqugP5Co0sov64OpAHOxpm1A3MN5q5qIA/aeLhe78xeHJib/Ofg0SMqkDk4zxtkIAvJtoM+djoP6QjZnLqZ6POW4ltc9IlD0+44iryJpWrEhCxZkAAh8KI0NNITDX4xb3Dpk9hJuOWp5IYdS2P1OMEQytnsos2Y1lnQqUC1LaOVdemQbIPIAQK6etZGvCukKKTWRCjSHESYF6ApvM9JhIG9RNdC4IHbjHpZS5Ew1lT39mSrQXpSg+XsabMF9xozHFEgiCbmmxINieu5nbhcxSWSHVHsMHwC9wJBQkbJvYFqdFzhXJe5ZHVQVA7tbYKigGub766b3/+mVKiJEJTt/07oRRB6hSjIkRRDyM2PYjeRc6fPTYW9ZdTcK4Wrb123Dz8mgQZJe2Vl6w48mFYh7grnNYKK6n5yzwAYbf50F0QiysNMqTEVAClKqUftn9T3HR/w0w+vRuk5m1C4Pn4mDZaq4jCAgRcYHB66g6/Hgh70djyc1ASWwSvFouHm4dP4TVPkU07Q+tnvwJibEvc3wUbao2qlZVYuR6LC/hjRPzVmFi3Tykk+wFzpw5ZqOmw/ARkV3g1Ir0003Vt+QXEWfrOfYbwZDHzb+xjoy1NyGgF1j9H1Ax1IpOMrc2VQoZbVWuGbFn61nCP5FQLpTxHHxAVL1HN5D01clUjZmJA4I3v81anDZVg7aYeQSgcSV2OvRRrSczQeHxsD11zUv+Z+CtRzSF8bnAuIhcLT2/kkIPIviSX/cK4Q4eTORzAuPgL+MF+eGY7/RIfASuQTy3
 nFK6c1I/
 tbNTGm4aghrSBKs1uQK6PPRndDj2Uz+cD5LeHw1QgYdj68cBn6cDf3o/cWRHb0hbtqaAGHpiM2WBn4hSXv5g52lqLtS0Vr6wER1l5zHSvkPgSER+oVXDKNQt0ZhF4enfdS8+K5ztKaaGWv+dahIr5XI73NkJRw9tZkZH1Mz50gx9nQXM1R6Myk2EdyHazXSNlbgBmjfZw2kU1/1CH+WvaJPBFe4GpecoiH07TN4U+tkO1JpEnrOVt0X0HI0vFBOU6fZ2UZLUzprE6BNaFsg/BxElmDBQa+pogifvgPxhKgR3HtnsSIfFNwpxgJVXH60tn5c+4/Ooz3gM2UsIteUWo6zid7qEznoLAmLH8FCQ4tiTFijcwzw4aRRYP7aZdoo3xKJjdBqu/pJrD4h31tw+p8IVsKnuvvQWmlxq2utg7nqqH0wDbx485dnVhRtfm52VAFPs1Wp7ra9q38vc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 10:18 AM, Hao Ge wrote:
> SHF_ALLOC means, per the ELF spec, that a section occupies memory
> during process execution. Some module sections occupy memory
> outside the regular module layout, for example the percpu section
> with its per-CPU allocations. The loader currently excludes such
> a section from the layout by clearing its SHF_ALLOC, which
> overloads the flag with a loader-internal meaning.
> apply_relocations() needs a special case for the section, and
> find_sec(".data..percpu") returns different results before and
> after layout_and_allocate().
> 
> Introduce SH_ENTSIZE_STANDALONE to mark sections with a separate
> allocation. The percpu section is its first user. layout_sections()
> and move_module() skip marked sections, and apply_relocations() goes
> back to testing only SHF_ALLOC.
> 
> No functional change intended.
> 
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Based-on-a-patch-by: Petr Pavlu <petr.pavlu@suse.com>
> Link: https://lore.kernel.org/all/499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
> [...]
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index c32f1d370b73..078dae188aba 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -1618,14 +1618,8 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
>  		if (infosec >= info->hdr->e_shnum)
>  			continue;
>  
> -		/*
> -		 * Don't bother with non-allocated sections.
> -		 * An exception is the percpu section, which has separate allocations
> -		 * for individual CPUs. We relocate the percpu section in the initial
> -		 * ELF template and subsequently copy it to the per-CPU destinations.
> -		 */
> -		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC) &&
> -		    (!infosec || infosec != info->index.pcpu))
> +		/* Don't bother with non-allocated sections. */
> +		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
>  			continue;
>  
>  		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)

Please keep a comment about how .data..percpu is handled. This is not
obvious and should be described explicitly.

Something like the following:

		/*
		 * Don't bother with non-allocated sections.
		 *
		 * Note that .data..percpu has separate allocations for
		 * individual CPUs. We relocate the section in the
		 * initial ELF template and subsequently copy it to the
		 * per-CPU destinations.
		 */

-- 
Thanks,
Petr

