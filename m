Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C83CF606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 02:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iM19STD2
Received: by kanga.kvack.org (Postfix)
	id C01FB6B05B6; Sun,  1 Nov 2026 21:58:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD9A76B05B7; Sun,  1 Nov 2026 21:58:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACB8C6B05B8; Sun,  1 Nov 2026 21:58:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A2736B05B6
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:58:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1A65120B27
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:58:30 +0000 (UTC)
X-FDA: 85388670780.03.A01FA17
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0A78FA0006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:58:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iM19STD2;
	spf=pass (imf25.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793588309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbhM51MkwqyzYIK/l0MrHOeAdqnx2rbbHcfO8pxxmSY=;
	b=nZ7UqkXXCf+tL9gtuVSS8SzA8p9EHlgMeP0cfJrqo7OB9ZTyrJxzU2KdInSbNUyAi10Y8m
	UW7juDerDVPRG9MJ+0Lwc6TgtTqvVMcj844PwlyrJ5p0bqx2KiOZl1MBcY7kwAZC8C7Mcb
	5eU6oh0jbOMxspdfDbeoPWVKVP0n+d8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iM19STD2;
	spf=pass (imf25.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793588309;
	b=G0NfaeOc+GQldkz4fT3owmHtJ7H5ThIp8Eb7iultFe8zlNmQiT5P4VpKRiQmT7KWawPj/d
	aGkVy4JKTDA0a+fAE/hAVKnW4PEDRe+WzhGEVZLG9TEATWdZHedWQb5eJch3E1rM87cQ09
	ZQetVxOm4ZHA736UJUwE1ceH7zt2Zew=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-36a6ee9c59aso45132eec.3
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 18:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793588307; x=1794193107; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vbhM51MkwqyzYIK/l0MrHOeAdqnx2rbbHcfO8pxxmSY=;
        b=iM19STD2j2TmhZ69YVfDVvCyOqvV7rcbLPyz3TxS7y0APanP2pZwm+v8EYFehBT6rK
         fMbA6YGvnU90mkMJZ4OaKFmQyYPm3dOahtzkrJYgYDeqQWR8cQe+zLYrYdGad4+pzhQ9
         vPHsCCR5ViuGhg5JkjMv2EsM2MzsZmmU4oQsZHtDUp1PA7f1/SyITqqiQDeFu+COxh6M
         MWclS3C/FdLFgoabojTJY86ukd4i/W08qGhQs2WZrFCj1FFTuOfWWKsZ2Ck2BcVw8CQp
         Mvq0n59GSxSzOPoSUPPbq50Bn6KbZLz7ydNprqd4kDqfmRZDcbsDs6PMjgbehJdIj9qk
         vlcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793588307; x=1794193107;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vbhM51MkwqyzYIK/l0MrHOeAdqnx2rbbHcfO8pxxmSY=;
        b=kq2PUm7EVp6EHF5yeL+W9aDPlcK9oC6ISxd//4hmf9PxU/DxqPKQ7fVAprvxFPjP+U
         zZclj9OyxBeXkxrVZmKjgw+d7kdNR0osqvWcSnVLmBsb9sOD4dXXWQsOvTLHfR7czc2G
         PZvniJUyWzJ83bkDbt5D+IJfefG7qwwTLPetv+qyYAo3w8Pg17IGhoOvSqkUe9BDMgtj
         DayNkKR0++vm2rI/JTcT8/egTsyv6AzBGvfGpT+h1AuveJ9LTzaWOd51AcSv2xFUvNlo
         kuVhXcYxQ56LvDdWkgsxShAKLJb1CCtK0/Ms0cRPQNx0yEYu69JCjL+0cbpHoni3mcyG
         1r5A==
X-Forwarded-Encrypted: i=1; AKwUvBx32Rryd49/lSQg1ktPIaXm126R9sVVOeCaP26ewJCxGByi9FiK+K9lrao2LtPkrxWrc7QXX0odfQ==@kvack.org
X-Gm-Message-State: AFq9FYIb88AQrx+bdtJZCDxasmtGQuoTRsnnRzXI0Xtc9iM+/wJsrAtK
	qCBumSyurMuG6kyWVTSwu/c06F/aL6SSNjEfmLFiBJAq3oyg8q82GUim
X-Gm-Gg: AYBFou0zXm1CtJ7RJItTpEwhs7O7ow79WmBNh3YwdI5wouED9+1U0yN7K+7nt/SFeND
	v/O90cAOZTsRviBUFAGt/zJsxr5DefMS4m94TeN/5yg0QZNqpS0zempHaFGwVHnAUzQ5X/iODZG
	4xYf/xGdBbY66rmqpaGiS2U/6+dx8wRcc13Qv8z3cZgEnmXrQ42/2X7F1L1Z2pssEXOv92JBhac
	MqQwAw2u1N1+VFTMskNxGoqkz5na5nrftg4pPlefLUB2WRkRKObeLv8wFgoCtoNpizkUcm+M3UQ
	OKh0NrBYqTDmKfqHMq3crN2a31v8Zcxl4VP2E8EM94sTUYRwoYSkNrwE30sGi1uQz6qbE+iQh12
	BEeVBVjmLRbIMtzcAfTUrR8RmNoenbqo1q3gpIsfDxBG9PdfcidZzEZWJdwhFyiCxHz6aGw35Tj
	E1xjRgEXwCXK0uudtXSoquBIPR3b6i6lVicu0HID7rMg/8THFWZGeUneGWaseLrszgeAb+agp2H
	ylJPmJtQps/INCFPT74fR8T3cgjIaq94sFKJktvGZXgH33XSbgJUluM3DFfmKlgmcKJbRBr2jeE
	1t/FMfpv8NtoNJ4j1s/2gWVz0tE/w5EWrMRUfMDhPu805VvfmE9vxdMrCCF0kcz+Cdfc
X-Received: by 2002:a05:701b:2302:b0:183:d275:cf76 with SMTP id a92af1059eb24-1ac59dd0e2emr19891581c88.2.1793588307274;
        Sun, 01 Nov 2026 18:58:27 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1abcf67csm29779410c88.21.2026.11.01.18.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 18:58:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Xueyuan Chen <xueyuan.chen@vivo.com>, 
 Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
 Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com
In-Reply-To: <auKlTdFbOZmAuheo@google.com>
References: <cover.1786003779.git.xueyuan.chen@vivo.com>
 <anVWZVOt-xeD0dMH@google.com>
 <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKjuiRxQwtsZF_0@google.com> <auKlTdFbOZmAuheo@google.com>
Date: Mon, 02 Nov 2026 10:58:21 +0800
Message-Id: <179358830137.300028.11084163850071476613.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0A78FA0006
X-Stat-Signature: q7dfqnnt78x5xj6q3zthhtidi7z4z8gj
X-Rspam-User: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793588308-660755
X-HE-Meta: U2FsdGVkX19+Hg2JKCVvxi+hSGMAeNGOAmis8Seu921ATYUNAGhdQjjJwXH5Qkrguwr4Ss4JwPesOB1WaEiBrqNlcYZX8kdfeyopEGjqOABma8D2YSSBIDAHzFPx0UZ+W4UsfT1Qv+05cQA7Yq6TSXKAf+o6UDtser9KyFV3h+gF0YmDZADBDU9AZXNm8J9dgUww3D0Zq7e28XtxH7HsAFdjlQQzp1YT99MAQmAFceDSOeH4OWZL+nDoEjs1qmIJBjRQws4ty1SzxZFnqqwQR/S7ycizvvDzYuTEPBSvdnr8bU4LmM6EmeLskVHCZexHanBjUTE5YcegbSimekHEaOz82z45tDrBGMo9Rice3twWREqKw4AfnLoSrhs+4geXMqBRLJMhoywQGaWDtjIBh0or5MKA+yEux9N1PrF20HhgckMc4v1RgLn4fzNJzwTusbv1r1BSdBNl37OeAuG22DLBGS5cjlBKEBh1iYYmAnsA5itygD4PV1b+LHJ4orrWLz6w/0Ehz/lsGHVY3d0tIhjF1hT9ijEJt2JoTYzRFXnEIw84UcXeZomdpVu9DAsJ57WIsQuV/e94hTxGY/sJXrwx2NsbI+aVWMDQ+/Rjv1NtW959IUNIbuJb4QJmzNGbv+Zz4JGE1hTNvT5W0nyxWmKS8BJZNpaicxKNggEBX+yVVnfIcvwxEV/vJzwzkVLWoBy2nzbAi/KCPQpYLKvmQm5qg+ykoMj9Onp/Md4aAxgnV9WBcVSfrKQRTjBIha7w7nbtHVIGjWYO+5caGBm//fzFNsX6Ac6ziL4DnNl6aqaqiPztLs2OSOH4L9mMOALBa53IMlTrQlCcSD2F+nr4K7YaP4Ouzc3sEG4NetsVQFV/dTGC+4A6T/VcGypVyuLtvYDE6n29eFkGgXn5geC/4w5b1286lZxHFboFkQunRnpbdaSG5El7oNhwF6rKsrYoO3/czLmkZ403jojNhoM
 eKSgBuiC
 jxv9Nn46gYsMmmcSVXvkStwnrepZveVnpglrpA/Gd2cL7hUnCNG5iiMG8yYAJfApXjD0Uj6VTY99jANzpkRv0AXC433qnrSqRXdXjUFzhgZixZ/9hylFs6Lvfr1fjtygy+AvERq5VUwQ4bJL6TbsAwz4MYPCQu9G3Nibyuw4UKdsWzglOCZRfJe/2Y6qXD7Ukj1ZM1NA5Et+sv/Jc/fVIewp42LtuKzGuPohNjn3FfbPG0+LxPDyvw1hCwL7NNUJyR7a6fq2tMd3GYMyyVS+w1I8y0d2Nq1PY/plTHkNZvTX6rE0cqhdzvOZtUiG8K7HOvmeDtzgbzhv+oSg11RZVXDG23U6nByd8qOtYwZpf220Qiv4jgezEttrFY5foIkdsi2rnu1F72FVsDaPVcWgVyuUEQWq2xgYLjnaRlzrrcSxhSljIEKncKIWhdlmCFvj1xDKOTLLL/MLGqZA/33TvqntMkZvVQyPmKX/nnOA9WERmA77d8Y6zUfeUJ+DkyjjKK0KL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-29 10:48 +0900, Sergey Senozhatsky wrote:
> On (26/10/29 10:43), Sergey Senozhatsky wrote:
> [..]
> > > Hmm we'd need to collect more data in our workloads to determine, but
> > > if we can compute compactable ratio (freeable_pages / total_pages) on
> > > a per size class basis, can we just skip the size class whose ratio is
> > > too bad? Would that at least cut down on the vast majority of
> > > fruitless memcpys and lock acquisitions etc?
> > > 
> > > I'm always a bit hesitant to over-rely on userspace, especially when
> > > kernel has information to do something smart about it. It might not
> > > react in time, and many proactive reclaiming schemes back off under
> > > heavy memory pressure.
> > 
> > Apologies for the delay.
> > 
> > The thing about shrinker compaction is that it's sort of on the
> > wrong end.  It doesn't trigger compaction when memory is plentiful,
> > no matter the internal fragmentation rate, and start firing compaction
> > scans when memory pressure hits.  The problem with this is that, now
> > compaction moves objects (if can compact zspages) and releases empty
> > zspages, in parallel with potentially heavy swapping out activities,
> > which can simply allocate those released pages back.  Which seems like
> > a useless exercise and needless memcpy-s.  So I was thinking about
> > either putting it under config or just removing it (this might be a
> > harder decision).
> 
> In embedded (android/bookOS/etc.) there is a daemon, that triggers
> various zram activities.  We can wire in pool-compaction (once under
> memory pressure), which is a zram sysfs device attribute, instead
> of pondering zsmalloc with scan callbacks.
> 

What triggering policy do you have in mind for the daemon?

If compaction is still triggered when the system is under memory
pressure, wouldn't it still overlap with heavy swap-out? The shrinker
can already run from kswapd, so moving it to a daemon alone would not
necessarily change that timing.



