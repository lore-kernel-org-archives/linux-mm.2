Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3E88606D4F0
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yotTMath
Received: by kanga.kvack.org (Postfix)
	id B86B06B00EF; Wed,  4 Nov 2026 16:38:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38356B05B0; Wed,  4 Nov 2026 16:38:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4D546B05B1; Wed,  4 Nov 2026 16:38:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 796E36B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:38:37 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05ACFA0867
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:38:37 +0000 (UTC)
X-FDA: 85398751074.25.13D5AA9
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1E0EC40007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:38:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yotTMath;
	spf=pass (imf07.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793828315;
	b=e+aNZcR+QDzTc4L/pGRO0WRm00SsMJNXoOPN4hM4upthKVnR0W5SJ+KRGTsp2tS6L705Zw
	Hw+WC5+/Q0V0C9Q/sY95OnDB5VyLiue5rUbBsgSUqzt3CRaWKpOLVuHY8jhsO225apfzSz
	O7cTYiaDP5dP9LMBffA5vuhtfgPhfFQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yotTMath;
	spf=pass (imf07.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793828315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YHCMrhCX9qwCLtIcZFgPvqvF5+LnUpH344kbevzFH48=;
	b=5CmxW1CLNEYiTqUO1WI5zZ4r55N2mwaJH7ST3F+cUZJ5pWT98C1aqVxte0QHV8iuiPQzhU
	gXqaSRQZat07Th/JftFU1nMSxuVlat1CyBo/S+IZ1oayxIy8kpnlNTHJLq71/HJaOwv6EX
	3LJQ+rM74+ymjIkCA98+9y/H3kJAHaI=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so10724805e9.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 13:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793828314; x=1794433114; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YHCMrhCX9qwCLtIcZFgPvqvF5+LnUpH344kbevzFH48=;
        b=yotTMathoxH6NckoAsM17loMvzdDU3NmPtESUpmUMHRAZJiW6JNzYRA05rh2XYE0WY
         qe8tgGvUHAvUyVotpDnH8VDJj8Dq5w7xGj86CCAibyvJMB2A9d76F6Io1Us7xKFIQ1Vv
         HmcaoOJkqQuzylM4P+Cs6W+gV3JVqMpAA+mDv/mh7U/3kZzBLTdTHK553X2x77g8wxyL
         4B6EYRRlC/QMX6RfJUKQcnbLkvB6CsKB8RetukcyN+WQ8U07Q+9CyMRwSAzWCscrsGi7
         C08LjRTOLyHk/g0Wq5rJ5DRfvuXpJQl6Ah9ovD0uz+nQs5IQdeM6vAsy/+jwmqSxFWmo
         Nd6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793828314; x=1794433114;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YHCMrhCX9qwCLtIcZFgPvqvF5+LnUpH344kbevzFH48=;
        b=aFatYby/n6OvIW/cQzJlnk1raivl6LP6rlHEemMvEVcejDPCBwLLAFrf+8wa0z1xaD
         fbn9xk5AH8aS0H3Zif5aNA+NNVjirNQrBWrvnLkqbhBl+0zJkJcyDzEWXQ6Zny4IJoyJ
         ZlsMR7y90Ho7hBwhM4fV25+eMGt+4QqiKeFvK7vMtI4l/0JgDp9PGUdnxGd0QjUOkYn/
         3n8TxAjOQ/E/6l4RPWSTDlApsI1Rmfln4jESU8tKcx2SdqkASfcSNQw0Mo50ryeo+dqQ
         pbFQQZ8m1c4SyudxB4ucU7+guewEDx48U/cjKyxLmFAXrs/1B4RKXzDQhgf9V/3FZY1c
         tpPA==
X-Forwarded-Encrypted: i=1; AKwUvBwuNOxRAzUHUw0affy4JnUigL+kPi7injAoIW7X/KQh7fqpBPYzP0IjWjmARlp7WIsotHsy+8yncg==@kvack.org
X-Gm-Message-State: APuU4Z+RFC6pFxu4qVTPK2ev8tRhpLLhhShXD6O8KTOC/yjVqDB9a9wh
	mtxcHquLPRbiSxXBAeHM113O7IW0xxbSfijSzpaudmAKxKNaoCFYik3w
X-Gm-Gg: AYBFou3r9za9aYIkGXUUPvmoerNY8bpJCvr7+j9K6r+aOu8RSfpiojbM8WbC1m0aJA0
	wYpJZHguordX//l26N4ouN5AmOA1sDkt8JAVOZs0Y1zRezDvyHB/IVTOiuxsrFwV6Yz11nbxWno
	0aQcwzAz2UGQoi0gnenlkH0Nsu+rJ42h5p2V1vkiCL2GQfu/809H+sMNxz4GbTOVhtiqSC2pHeD
	SaAlitgAKyA/0PdOVv/ufz+hwcvKgzoW/mUKEO5gMt00LWgX5KesVl9RYoVCLuQ5EcolCPGxQLS
	0jhI7cZa0pF+Kg8+RxAk88eGwi/02hk66fxkiGM51K4MSXRx+F0GzHKumOmkVp6jtD1bFhSx4Pa
	P+uZdAgcCVfJOOS/ywO/4Ygz+UcMPiLs9gZTk4XFQsOyBxC/HFT3RZfQ2dDs1GzsLeo7b8Xm0Mn
	HJFPXLGuFon2BaCK0o0NVnNXslxsCuQ9DZmAu6YwhIv+ADMr5lIMj9FbA20js0QvLkuQRZiUT8h
	1ytH9jVRXyzuJH6nQgZMnteF4WOWWakJJvsQNRiop9wAILcU77C4fpjHVrZjrRgN5UnDmots4NA
	1r4CoXLfcDJaAIs=
X-Received: by 2002:a05:600c:524b:b0:4b2:612d:908c with SMTP id 5b1f17b1804b1-4b2612d90d4mr159560295e9.34.1793828313453;
        Wed, 04 Nov 2026 13:38:33 -0800 (PST)
Received: from krava ([176.74.159.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56eb4da1esm23736045e9.6.2026.11.04.13.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 13:38:32 -0800 (PST)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Wed, 4 Nov 2026 22:38:31 +0100
To: bot+bpf-ci@kernel.org
Cc: ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
	linux-mm@kvack.org, andrii@kernel.org, eddyz87@gmail.com,
	memxor@gmail.com, ljs@kernel.org, john.fastabend@gmail.com,
	nierro92@gmail.com, martin.lau@kernel.org, yonghong.song@linux.dev,
	mason@kernel.org, ihor.solodrai@linux.dev
Subject: Re: [PATCHv2 bpf-next 8/8] selftests/bpf: Test user memory kfunc
 errors
Message-ID: <auul10Zrq0WmmU5K@krava>
References: <20261103075916.100050-9-jolsa@kernel.org>
 <28b71b95a782f28f081233a18a48ab18cfb5483df6ec6980f8168cbecfd93543@mail.kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28b71b95a782f28f081233a18a48ab18cfb5483df6ec6980f8168cbecfd93543@mail.kernel.org>
X-Stat-Signature: 5jbu36ug7nqamcdieosqxsz5a8irj8az
X-Rspamd-Queue-Id: 1E0EC40007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793828314-241418
X-HE-Meta: U2FsdGVkX192vwoV87WR1MGrMUbql8Qv074nGyrU6QslUrqCSTBZ5GMKST61P0FjhXZOGyKBLv2oO2T69KHTChT159oI9dO1MRJkSCy1xlaQPmpbqFFwVnHvy9D0UJMIh649vFpEjIrVLNixYWKCUV5eEqjq8m6nDBhiNUrFiCCLsgC8/xizcjvjbtd/0vyIca/tWRa0dx2ig/KhlfmvhwWPJLSjQvO8bmpb3r5sN8UcTBg/NMUAr2xTnVWib5avk24v+6sWr0oGz3wCzwtWmMeIkmv/meGgrNEJrK1FdpkAJpDjgqWNUcMKjCrgdSsHA1uf3g7SufDLtiHquuQWKfrHBE2EyDVZokGlbvoBMof+7gN0DECzYp0ARmBMPD44uEO4EKcr4ax7AHSZbO4OgLZcQnI2HQ1t0t5hFQkpBv2D3ysCiML4RYmzJnBb64hX4zjAs0mIUPlAYGlAmupthzTxfZdooxbPopAaUZIFg6Rn5wu4wgcaq7+Hf/7FZwx9VT1xm9A2xwwnz1QyhomKjmtAoR+fLtOiD881KFRKSbwqkgSSooOw+eaJkqSl6VOoCETe5llimit49t6f2gNf4a1R49iddcnJNtp2RU4q0zASFnwgamplzHGpxtcfKJpsHjmqUyLSc3Dm56/JI9KZFpom3GXTcmok+2B28I79k+yMpd43W8xK73lIJklCh+1KyFqUnX030rZK7WqVPwK7Zz+laZXT1SXAr8cm7923Dc1K9vI+zdFdiwyu55+/w9y6CszUY9s2b4cqWnbbuWntqjCWgALfXTdNjni6m8+M5vZYVQcrvh64suVF56echakPvKa5IvQVqgUYuEDHU/zeZKn71dZS7g4KK8xvlUVLwVgLe36Vml1B7vNMGw+QMu9qZ5ztopPfUG5P1nqcSVMbNretOMh3g7MMPpqRUNVVgevpVhHpIOG8URgTNVpwtSl6UDSsXEjsb4pYtwOFQQW
 YFhlak6v
 2OUHC9+bbqDYQpyDcWst/1mXlTKfygxa62DEYCnKIriCIG1+Bv0vmDZXxCOtRQugfpStfscB5/BIJEpyOZWy98euY6KI+qrQtcSNzRXpMdRfRbdrSqGMoaDGVYjrQ/M4aK3jfB3GJ5440AO9rHfJ8jXXy0XcuvgYnJ0pdyE1+6oxR+gje/iCm6HnhWH3yU4hZhbGOqg8cd8AEPMBr5Ql3itML1SsmosRydhhnUjGXszarpE1bKOdgRd+SRhtjlPyMTdytNIUTAgicYY3rrbubQcfd158bZU+6QUp+fQ4P25M6n8jGl9yEeoHd6rZi6dCFkpEABS3k2LUNHrDQ9MsoK9m1MEi6n+mdnJPc0W2c9a+tcav9Ch2+462grLBSVaWxKg+qs1qYANLpXz8bgBcVaB/F7N1E79KCRDBczPBrHhYAYymE/1fyRhsBiFmiBK/3qkRUTG4Q3J4a/oreH17F7yTxXe9aCLcHL3VwRlQt3Kz7fUrvdHjuZdoc3eXHj2HtkKXQcJUrzGhLrTBcR1Fxtdp4X+7URLlpWVk131s5lrUS5skQ9HPkC8bATknwAmKJ/AH2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 08:39:48AM +0000, bot+bpf-ci@kernel.org wrote:
> > selftests/bpf: Test user memory kfunc errors
> 
> TL;DR: Test nit only: the user_mem_kprobe() selftest looks redundant with
> user_mem_nonsleepable(), since both have the same body and expected failure
> and load as the same program type. One may be droppable.
> 
> > diff --git a/tools/testing/selftests/bpf/progs/user_mem.c b/tools/testing/selftests/bpf/progs/user_mem.c
> > --- a/tools/testing/selftests/bpf/progs/user_mem.c
> > +++ b/tools/testing/selftests/bpf/progs/user_mem.c
> 
> [ ... ]
> 
> > @@ -80,3 +80,32 @@ int user_mem_test(struct pt_regs *ctx)
> > +SEC("?uprobe//proc/self/exe:user_mem_trigger")
> > +__failure
> > +__msg("program must be sleepable to call sleepable kfunc bpf_user_anon_mmap")
> > +__msg("cannot be used in non-sleepable program")
> > +int user_mem_nonsleepable(struct pt_regs *ctx)
> > +{
> > +	bpf_user_anon_mmap(4096, 1);
> > +	return 0;
> > +}
> > +
> > +SEC("?kprobe")
> > +__failure
> > +__msg("program must be sleepable to call sleepable kfunc bpf_user_anon_mmap")
> > +__msg("cannot be used in non-sleepable program")
> > +int user_mem_kprobe(struct pt_regs *ctx)
> > +{
> > +	bpf_user_anon_mmap(4096, 1);
> > +	return 0;
> > +}
> 
> This isn't a bug, but user_mem_kprobe() has the same body and the same
> __failure and __msg() annotations as user_mem_nonsleepable() above it.
> 
> Since SEC("kprobe") and SEC("uprobe") both load as BPF_PROG_TYPE_KPROBE
> and the attach target is not used at load time, does user_mem_kprobe()
> test anything that user_mem_nonsleepable() does not, or could one of the
> two be dropped?

yep, will drop one

jirka

