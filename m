Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE3C9CA5FFC
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 09:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D768C6B0093; Mon,  5 Oct 2026 05:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D283C6B0095; Mon,  5 Oct 2026 05:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16EE6B0096; Mon,  5 Oct 2026 05:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EEC86B0093
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 05:11:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14A8FA56AD
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 09:11:34 +0000 (UTC)
X-FDA: 85288004508.26.49CBE6B
Received: from mail-dl2-f3.google.com (mail-dl2-f3.google.com [74.125.229.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2F9D7180002
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 09:11:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y17XURaR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.229.131 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791191492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nltl/oeRao/6F+EabSYNj0oW56X0G3LfHyr3jad4pvA=;
	b=mYEUOARbB5cwJaSrr1ui1XxvCCa/Goc7BqNXiVEhj/ZBiWA33TlFQ5DO2YKOhBiXc3STbV
	iYk2am3AlMX+gxYi+jK2y1F3XYGVOGPH6bJ21/8CnzQ174L3U9YV0OEmTo5dScK9rqaIGJ
	fZoVq2WAmMNMNyR2WmLUA3tPQf5cOjc=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y17XURaR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.229.131 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791191492;
	b=D+SDgsEVNUPd678eZwKpToVeZwhhLFm5kIlzAatMT2O2cnaugM1B+S2F6r30SoInwAQ5RP
	Ps14SZRX2gnw+Vk4gh+KKSPIJvKHBsRFYlk3bWVj4ADHYHuij1zbKN6OtLgmOYsbVbR01z
	BNAXF8CcEH1WqNmmKbLXZ1fXScKFPCU=
Received: by mail-dl2-f3.google.com with SMTP id a92af1059eb24-15188ffe131so116774c88.1
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 02:11:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791191491; cv=none;
        d=google.com; s=arc-20260327;
        b=GiegKUBxrE6kfQ6A4NaXg8kzNx0ay89PZrU93knnC3SZzQReHmgW9FXijNNuzHCdZN
         Y6pr4DPY1RQ4JDDrLFaPfJpBqaSisxOIlBNsgteFR9grTrUeWpWfk2x4WYNQ8y0BddVY
         W7GDpKRJDEji12/qDZgDq0ayjeCBPkFEjn2a4E1VbwCCzdLBZEAht3pazGKPLrMI5yLe
         aw3gnl+DUiAj1YXPZfFLWHKEbyzzi7eUIy/8Uf84dritDcoikNhkuwiTwV/APk54ZcSw
         ybC8HQHUhJmMt98cS8/EnTV1G/uEcYNJ5Usx/Pe6gjsowz+/Zs4Ws0v236TLMRd4pKIC
         TNSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=nltl/oeRao/6F+EabSYNj0oW56X0G3LfHyr3jad4pvA=;
        fh=jWykXLebmTvTyJkQSbmo2mvp/MC5Is/CGPCAbMFmYmg=;
        b=ECXvmci0l0p8t8TZCx5l42p15iFrdebub3rgJh5rwN9lEh0PTmI55nz8GiIStviXfs
         dd/I8HW/53hX1QMlVNVw/LwPKB82AyL8/JpE/9ELudJ/nLbwCIIyLvoVs+dFvbutWyZ1
         CFPesRqqFkcV0WPoCpxm1Wt93gsD7T2rlWFYj7pQlMeyNOuC3KWw238Uv/t6acbOTB6p
         Snn5ih69k17BhPz1SfWqzf7lotZ+x8bdQytbOPXY8i6SPsnN6mZiWG7fr2rzetaO0ewQ
         u2VYyvpxFu3zgX5XfsMIG76/3Rx8SSgKw/k4O/X53RejSkQ3Ti1319X9Ym9hE7kT0Z36
         /vbA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791191491; x=1791796291; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nltl/oeRao/6F+EabSYNj0oW56X0G3LfHyr3jad4pvA=;
        b=Y17XURaRzdAad4WbeSvaFW+SyA3lMLd32UQLxZJk5FI7d3FiMMcQHnP+ik4ejfPk0B
         bLtMoP1c6v+soRE4jGskv8U5D5+st29AnAI58QVJNiIwaaBkq1BLmQcU3NK7TvNLRl+9
         w4SeZ27bJ990f22wLpIOKvdEURkoqhaYrg5Mnhs4U1xL99kafpVYwzEBo3hDqW5Tfcg5
         mBhO9+8RzXbw+6mvKU4sp9FqGIoxs5Mo4x4egHr6lkeZvohUB3zMHwMD1jzBdFZCIV9o
         A4x15uukLrUAYJ6C6Fp4TKavA03mPt2Kr9IMcKxYSsHvG8j6N2CFqp0kzbHYiqRcPpfy
         /UjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791191491; x=1791796291;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nltl/oeRao/6F+EabSYNj0oW56X0G3LfHyr3jad4pvA=;
        b=w6Cck83jbLXv31pOgbj0I7gpsea6wFAFaxElXLT2EBnepmxRO906RC/Uz90IIKsz9e
         7VZxOBp8C0XpfpGigwIuTIe3gBSX/Q4dXXiD9PNv34gSFKBSwlsOJS5sMF7JzNX0zOp/
         0asITOxO0aDqik8Tvy0JnCylMzMmyk312kskKvl3M6egTMPiqpHjF44Zd5ioROtOIika
         fE2l8pSqq71KpVn/MpJi6manOiKgOnD+4pIsw/1knSMjxMpsWGsZnrHu1toHRXUAIzCj
         1E5B7s1FICFy9c251SFvobZhnk8SCERJlTdlP15Hp9/fC7Lb+qHvkCE6yUJGMd0GnYGa
         FZiQ==
X-Forwarded-Encrypted: i=1; AKwUvBwx8fcGU7XTXZspOrwUGeTRPFJANRTFTFD9+l1mpVkkBOlzY5P3AKa944yEIoQn0u1bnlED7z+t3Q==@kvack.org
X-Gm-Message-State: AFuF++n3GQK5SMWfOMaHp38F9NGQ5nq2omrKOpeg9JELZB0/sx5jbcoK
	tnWJgETmztjZk0CleWB73dxipze5NbP5ZBFkwVNXd7iKyvStBg4sk4NcZgWzb8uUc+Cq3WxZ2j6
	Hmr0iAeKqjSSuZbqccg0U5GNgtpUmyfrcwdJ5L16G
X-Gm-Gg: AYBFou1+iGO+UTX7sJajbh7hZNgi7ZwA2DtxRHbBpdWZUo5VLEqfipSckEfYQICmkJ9
	D+J9PAkeXJPX5ZN0rmxuBiXT/gY5wndS0sQ8y7D8+ZSG1UWxyNVn6TeyIntUhw07mK9NC15djNQ
	iExLKmGkzFoToazi0vWVXekZQLy2aOYRSwXCvosJfKbnaxdpXNJibPM3LQ2oyIm635FE/anV4fd
	woNJnSB7XGEPlGiW051F5Mc42myBha7D4HdbpVkS8elNBxmODPjxfbbPtika0CCBUaUn9igxJqw
	+szKWm8k2x4UJWKgiTRDTmwkR0WMm4wQN7ArHrdgCHH4WFzqDkOYLjaY4w==
X-Received: by 2002:a05:7022:fa9:b0:14b:ff40:af3e with SMTP id
 a92af1059eb24-151c0b1c634mr16870099c88.5.1791191490914; Mon, 05 Oct 2026
 02:11:30 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-2-0f00417b41bc@gmail.com>
 <20261004091023.630362-1-kunwu.chan@gmail.com>
In-Reply-To: <20261004091023.630362-1-kunwu.chan@gmail.com>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Mon, 5 Oct 2026 02:11:18 -0700
X-Gm-Features: AclHuK9SLpvLjJzhBJihMA5kXTwHPEKQErl28l-hclZyIPjWGE7kxoL_9Ju2DmY
Message-ID: <CALa+Y14isN3HmsY9Mgtdi3O3zxOH33uTtajSbJcxm9FO4Uon=g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/9] mm/damon/core: replace the access report
 buffer with per-context rings
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Gregory Price <gourry@gourry.net>, David Rientjes <rientjes@google.com>, Wei Xu <weixugc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Bijan Tabatabai <bijan311@gmail.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	Honggyu Kim <honggyu.kim@sk.com>, Yunjeong Mun <yunjeong.mun@sk.com>, 
	Akinobu Mita <akinobu.mita@gmail.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Jonathan Cameron <jic23@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2F9D7180002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: e1zo17jgffppaegip8y8qbw64ofx3ybz
X-HE-Tag: 1791191492-734980
X-HE-Meta: U2FsdGVkX18TpHKRnbV2LaBj0pBvX7clP63i1hceuD0KO7vUoK1hfVUoEIU+OjtZrLClvzil94TSl8X6OTrR+0T4HCUDdnB0vE4Qi4YG4bMIcpOuHpNQOhlra/2yFOcs99WastXVdng1pAlF/lSWrANZqxY9Q3U/pvW1kI3BM9i97nwEtkWME8hKUZeeJb662jyHcvITopz/TIyY48cPwkm23/mPjSw8ZPFl2UFNEIjjEUaT48P9BxmOaRgeW3Ugr/N/1+OwZ8PVnt6erW+jn3vuhZhhUYI6wd4jgJTP40LQpNJicto+V7+LwR+VjfW7WAVoZtGB+9qHykCB26o2f+m1p7Ow0bBESIm9rfazg+fy51krvkVVGutaX9oMBSsMJlgtc8gDcn7E7009dJ8UBUp7Tzr/F4HpNwbBjGEUG3wFEsYLrBHxY7APkvLu1py2BGYwRoNuI8vKmf8gfmZt576t9iBxjGkXXP7/jDBcZq18KacRZQeQGXJsUcIJ0VZxMMJEusRwTdk/ATallcKNN20kxcDMju8AqUWCk61bUMoURZOCy3eVkmZV2P+VhTtcHCmCMEoEx2V6l/s6rQlfndW/YauyieAcsuzXVcfkPE8/JXD2PNuhIM3KIg1XaPtX8zOL4FfvbAIVWmtb3f/Gax8gi7EDXlwyN4Pauyw48nymDfx03ngFofPCrcF2VOeXcrz6e5+XE1F6skVnLoeKAPZRWB3ioB4RpZkXI57BZcm+VVoV2wOWjuZRS6mLrD7mrxWOVcSQfvQZDamPWivCVKZUmKdLOZxdmVETiQcZp4h67UKCUeF3mCliGyopG0srfljkLnO3XviKUu5SQf9kVNTMYKMLWBFLzT0NK/VPYcQDXQ1t2tIHXySSGGXp64SfpdUccfeSwXCpahbRNKokCqT6x+ycSwslGPcmQ9IakxpIFrYyciLNSxPPXd4z5RcUEbAbS9TP7PYJKanZO+D
 qjYmltuD
 SVYDA4E1Hsq6Zr9AUPZdPvvO2m9P3HtJkITJbgPUXxHPLR6KAoCGELzF0gFZRKWlYhy4/ffWJotNdgeNQCvfGMIUQ1+r5VyqyVbgvMuCo6deBdw63urLtFHVW/KsJG7mhhc79xxeTC+FcCc63qvV4gGx5rIzrUs7FdyV1kdw1HtW8mQLiaaUW5xqQpvja/IHZXXex7fXukDD9mqxN18FoXp64Pt1tnsDnhc1RkamWPJxuR7Kjk51GS1pcL8no8V5fZ0K6kniyfyz0I4/kCL9dTxsOQoOc7Wj57EVE2NqjBHtSj5X6H+sWZOfSm5ghYTBEJc+WWxqN48J+gxbXI0IKt8guZlCBzNTVkFGC7lZpvzpEhENe76hrJYNCLAs82G9cFrJc3Y4SDKphwpRed4Vynqzvv9SL+BLzoFKdEMu9HUhIOA1izXk6FjhkY4aBZS5DsWuxPAViXgbOoU97jeUW8xqJSLjqFMH+TZ2wFLbWDfUXI6x7Ne5tmDHRQPJr4KCp3MDhGCxNuld2Svc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> Hi Ravi,
>
> I noticed that ring overflow drops reports and updates an
> internal counter.
>
> Since hardware sampling is used as an access observation source,
> could userspace get any indication that reports were lost during
> an aggregation window?

Hi Kunwu,

Not in this RFC.  While developing the series, I used a developer-only
commit that exposed these counters through debugfs, purely for my own
testing; it was never meant for upstream, so the RFC keeps only the
in-kernel accessors that the kunit tests use.  v4 [1] is the same in
this respect.

> Without such visibility, users cannot distinguish an aggregation
> result affected by report loss from one collected without loss.
> This may make it difficult to evaluate the reliability of the
> observed access information.

I agree that userspace should be able to see dropped reports.  Two
things to note before exposing them: the counters are global per-CPU
counters today, not per context, so a per-context interface needs
per-context accounting first; and when perf throttles a source,
samples are lost without any drop being counted.

I see two options:

a) a read-only file under the context or probe sysfs directory, once
   the counters are per context, or
b) the drop counts through a tracepoint, per aggregation window.

Your PMU-agnostic observability series may be a natural home for (b).
What do you think?

[1] https://lore.kernel.org/all/20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com/

Thanks,
Ravi

