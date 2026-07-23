Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15018C4452B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 03:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4F3B6B0098; Wed, 22 Jul 2026 23:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FFF76B009B; Wed, 22 Jul 2026 23:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EE816B009D; Wed, 22 Jul 2026 23:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5229B6B0098
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:52:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE105120387
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:52:40 +0000 (UTC)
X-FDA: 85018669680.01.5C9EA2A
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id DE00A1C0007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:52:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MDkWPNm5;
	spf=pass (imf20.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784778758;
	b=s9u7RQqv8Ck1BksSW/L39DY5FNgzDSDLg8UVXGaW71l+eAL7EwPdnB08+hCze9Ce0c0ORE
	JUZIXwuL/z+nafH0V1YL89NNOS8sYnCdtmbexVnFn8yfE11GaJ624EmEl44+TQlemJSXE8
	l6tFOnH1WYKWA95+WBd55ZQNiQQUumQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MDkWPNm5;
	spf=pass (imf20.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784778758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PWkIzav5w9B0mJTOhCHnbrafABGdOuy3WTC0cILRB3o=;
	b=eyEoMUKTZRQ3879iUqQj3ZyPAA3NQ6ndB8bVQiDSAPuNqfkJV/WWIDADATG2m1B9577eBx
	lFs7vlS/Ob0Efa8GYxBtLh7/PO0dfXYRddHS7CF++lI3B7U3EZalHnKPSg/aTEVI3thZ8I
	sZtheF+xLR7ZtVVh9iVHXInQs1ETd5Y=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso128741a91.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784778758; x=1785383558; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PWkIzav5w9B0mJTOhCHnbrafABGdOuy3WTC0cILRB3o=;
        b=MDkWPNm5OgJV5SEzRaCUKZwuloKE6yoCj3zpvLkkARfSeilIzna5nco7p71UHUmtvG
         ArjGfYpI3ds1Wleo8BVe7kS/8WNCHLyZueAQeKdfP8u5zq1018Cm8rn3B0RqSaY01SSY
         h9ic1nACJQW8tZuH0w7YQ5H9Qg4FuVHu7F5fTIRiciT/R0p2seFEUYCJG+E0dtSXC1TY
         QfMlH9aMV2gsFNa/hT+hFqCrd5lihwg+skwVEg9PY4QTK6mw8vnj4JgT/pb/4kMbX+CD
         9/DvYmJzilQe4ljeQmkUTP6Sp3GmRuvrpzTqnsXnffdntYEV+DziYwtSe0OGn3B3YGgl
         FxxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784778758; x=1785383558;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PWkIzav5w9B0mJTOhCHnbrafABGdOuy3WTC0cILRB3o=;
        b=sd1ozvUp+rHLqkN/SVsCbC09Byxrv0LUwiAzz9k3ybkbdPYgaj0I66BafXj5cn7qKY
         k3bt6y6Iciv24iC7USN5ZYCx8HZsVT7KrKotheQi69VlQpCT6pw5OvECqMl2UOErSu3x
         Br4QjUUyHYQSQeE1GiprvFiZ+6yWVz7xbXceMJd+u2m54qQ1JgKY+v4+VKSqOObWYnEz
         3On3ceOWenZKArB6rSCgRVECLicAeT3pg8g5VF9p8yTVpBSjMjVtpyh1r3QSROM1Fluu
         huhVLnmoNUzREoNdTODoPmdpT7GSpWt9hVheWvWZLWPOiNqmspmaGANuQ2uV1rKikYMd
         n4mA==
X-Forwarded-Encrypted: i=1; AHgh+Rp/IK0Yq8Q16ezB3+ybD2M9c8gc5MYOmt5J2fW1aO7B+PftX15ZN4ssTCAwaXxZwjev3UgA87L4Zg==@kvack.org
X-Gm-Message-State: AOJu0YyV1WV3Mu0vkCZ1sdy0cMd+50T4qInLZxZMs9PuNFSLXqIEXFXr
	S1I9z/vfGT3i9SXpKOT4b2tVMNN976lAFWOtxoXwX7sdlg95oEg5I7/7
X-Gm-Gg: AR+sD115QP4MD5W4K9jdkoLAIFiXMMpUmYGItT1xEQrXbuxB3Q//imXovts8a80Qp54
	E9IeoedQVpsRM0x+tGmnj2Di/0lbggY4sgamUq0gIfJHZwWZt4ki8A77dbBx1+puISvD3btvo4T
	bq8Mk9Ib2aafrd7fxZNwtw3KEvwv//MK+mSKUTerHtswffZem/u0HjESCl3gV0VkxDe07W9pOty
	hjMS02DH4Hobdcw0DjJGkHwiKsmas5JrKYRBAUtyzreZstIYgxva02fXm6Q49WlSYp/+knWnkrZ
	Bu/V3eYkYsS6K6yobkJ8I1azsmV4ErSloqnxe3LgIU9Po9pal8JXf2c2s0KpVXJhMoVx/iYmTa4
	lyzQxhtsE7VlXGbg4z2cqa1f2QUHfr1zmqOn/AAqOnw5uVBmvZJSAZwMj2zsBm+hyOwN28+xvAA
	D16EspOw==
X-Received: by 2002:a17:90b:3803:b0:37f:e1b6:4c7d with SMTP id 98e67ed59e1d1-38ec64958f1mr1552625a91.6.1784778757821;
        Wed, 22 Jul 2026 20:52:37 -0700 (PDT)
Received: from [127.0.0.2] ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d12f267fdsm11497359c88.0.2026.07.22.20.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 20:52:37 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 03/21] binfmt_misc: table-drive the register string
 flags
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me
In-Reply-To: <20260721-work-bpf-binfmt_misc-ptinterp-v2-3-e57866e4ae0f@kernel.org>
References: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
 <20260721-work-bpf-binfmt_misc-ptinterp-v2-3-e57866e4ae0f@kernel.org>
Date: Wed, 22 Jul 2026 20:52:07 -0700
Message-Id: <178477872730.254289.11746442109631976813.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DE00A1C0007
X-Stat-Signature: 1gq5zy3y4s9t34o7ktamscnbq5sm31m4
X-Rspam-User: 
X-HE-Tag: 1784778758-698512
X-HE-Meta: U2FsdGVkX19lQ/f1vj4RbFVyi/B1bzN26s6porw7JgoG1p8yhw3MZh2TteINO9Mvf0oC0dpK6kuDRPNpCq50kHLTEDzlcuMzfi/aWaCBhJA+X0etBVImB59p2UMW6ZeVJ+LBOa6nLfkqr1+dKTBJctfsn4uReuh0DjjRVa7eWOAC2dS3irTIy5nxF4QR3aajpvPh2oT9EOxK8QcE6srIwfbMtAKycnIPfkWteqaP+sD6I39n6xSrF60OJriLPoodq4xv+J8RPVCcz3HiQWoyyHwRD0bOw2MPVB213E7dcdHjVrD3XNuKBvVff8UldhSbxQFxPp0yhDnpX/F8QdxKQx2z64KZ6Sup13Pdw03c5R22vKBqIG56tY6A1gdOECySwgEaLpzz8WAZC9+kD3WI9r93TV75B4gxNGYQOorms8LwOc/swQH91jYWXk08O7Xj0jNd2tv9O8REpALqAk1JTyCFqQa8NTWmPxChnbnBIykaI/Uvz3zY3OX7PHV1sxkvXwMsSyXr1DvYrT3y3C9QLsfr98junubcZiUv1OYnP20iQW1l1ohAo565ayCmbkSQWJKMwywPBlUTZyjo5HswgLPwgKeqHAQAOu+SOSHrEnmgsiIRD9K3Ai+4BUf9okZ88Qwg36IljC6aUNiiTqwkHTXb+MmLjWsHvqGF9cJS/ZhEPeXK2Ey4V7CQeT2FZaDbWvsLEq2sqqqK/g5VYjhxynf+xrAdgZURLXQE+cjzFc2p2dACUSfY47xeMY+u2yhFiW7JNjb8UeeAOS5HgWBMLhpNi7I4eE/QlTf1j+sfHcgKWZDrZ0ekzwHm5tZBjef+9aAaW6WGxuxcxG9I4yjOhlmshF+2yOLn30IK7ntRfnkfTi+IAvw4SsPmu2Sytkmpx6sP4HBPRnV3gQna1+y4eQL1DHUBHZMRsyh5YKLmnwy0Cps/M+lbVn+5+XnP5lEiSVf9vAHYG13nlb4rLu4
 OULB6Djd
 9x/VBkEg5kyVOVO03a27myyhnvXHl8yJuJ3428lrZYDApR4ZrQe4imXjireTvbMGEd4T1zfVm8M4NZb+ozWz+G+4U0+SuvPgAuW58n4I/BF1Lyp93v0bJGi2ffNzXJazzaNpMfeAi/7QZQxaC0b3WzSPcofNvvI9E15dX7vAW9a+RcoJv0osDdM6bpamPfjrN31ZHKVSoBT1HMavlU2HYqwaJ0295G8//s72KqZWJrdrEdwZrFV42MLc1q9IYHXqhKfxD1suoRBTm6W8YI7L/QbIsp5UGns1JEh9dld9Qq932YxOYx+FVI0npLL/Cheu+O2wxEUzQTDAArq1VTWOJEgJK9FR/6u8ZCgJ8lmvaBU10R3B/w9ah2oU9MFtVvx2P4xR29o65XuEUt2GGM9f69MME5YDtUhNtvJHrpZaHs81j+7xXaO43PhpPU2nXCs/GZ1fSyGjPVizbxTCIYScz2ojiEjAodebpmCDT7yAXfQj+rSWU7qYo4zPS/9P/bHwBH1+LSgqLSOw5CW+3EYPMZTyGnOgZ0jy3afTY6swcaq8Zu/l+3o/3Ox97NuNL1cgLKOvF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 16:13:45 +0200, Christian Brauner <brauner@kernel.org> wrote:

Nice sensible refactor.

>
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index bfe30fe53..c0a3b42a3 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -51,6 +52,36 @@ enum binfmt_misc_entry_flags {
> [ ... skip 11 lines ... ]
> +	char		c;
> +	unsigned long	flag;
> +	unsigned long	implies;
> +	const char	*desc;
> +};
> +

I know this is a direct 1:1 of the doc but implies seems unecessary
rather than on a single flags field.

> @@ -749,14 +766,9 @@ static int bm_entry_show(struct seq_file *m, void *unused)
>  
>  	/* print the special flags */
>  	seq_puts(m, "flags: ");
> -	if (e->flags & MISC_FMT_PRESERVE_ARGV0)
> -		seq_putc(m, 'P');
> -	if (e->flags & MISC_FMT_OPEN_BINARY)
> -		seq_putc(m, 'O');
> -	if (e->flags & MISC_FMT_CREDENTIALS)
> -		seq_putc(m, 'C');
> -	if (e->flags & MISC_FMT_OPEN_FILE)
> -		seq_putc(m, 'F');
> +	for (int i = 0; i < ARRAY_SIZE(misc_flags); i++)
> +		if (e->flags & misc_flags[i].flag)
> +			seq_putc(m, misc_flags[i].c);

Should this check for implies?

Reviewed-by: Farid Zakaria <farid.m.zakaria@gmail.com>

-- 
Farid Zakaria <farid.m.zakaria@gmail.com>

