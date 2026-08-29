Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EF1AC61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 12:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 501E76B008C; Sat, 29 Aug 2026 08:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2E06B0092; Sat, 29 Aug 2026 08:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0E56B0095; Sat, 29 Aug 2026 08:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10B1B6B008C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 08:11:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0EB871206BD
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:10:59 +0000 (UTC)
X-FDA: 85154191038.03.4DA56BC
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id 26BB740008
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:10:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kpGxqSVB;
	spf=pass (imf17.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788005457;
	b=QAn4OzBl1Wbm2BTZKXIR/GcqAZ0y+Farf4YEN2z/QZO9RrupX9X9QwscWwWppDQQWHov13
	cRaaA8+x+4UOxQu8GK59K7vAx4Uk0ROyh1HVFlb8t7LDuxD2Dr/xRlFpGjhmFc7ylsx+ul
	PSt6uKtslK91pbLOBSZze5pmG8TQYCg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788005457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YdSf9m2n91aamefLP8qGKuKu6/Pkf1L7aKMLcZgsGmY=;
	b=Wh1wokDosgHDSF7GWJ0Z3CeRw5GigylDvt6K1aa/VcRNIYA6fBCc3yuTKL/ay5FsIV+Bzl
	s7aQrGT4tzc6RGWmI+upQSQX27n8f8lT1hOOE09+dmvQiv2leS0qfTaqRaxQWLyKRGSPCy
	uCvpxpWVOZo/jhRBRvzaUbL+wCdZv0Q=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kpGxqSVB;
	spf=pass (imf17.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5b4ab0e4da6so1674551e87.3
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 05:10:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788005455; cv=none;
        d=google.com; s=arc-20260327;
        b=Ma40hSm4A1nNqc6zwJlbYNHqGN2KKl7OB8XbNK/LBPYL02kWDScwd7M+xORzbvjAdp
         3Bqp+pT7unsaVDfQW/5HYUOX5ZsBvc6UM3N2h8VM9luZKRqE3sszV39n4hydy8HrlmIr
         9r6x6nzBXpEx3IgjTLls92V8XQDJ44y5ouZNukNHDIo3YO9NJuv21UnqMNpGoxg1SrDj
         yMicu8RdE4py10c7vMBrhdmtSyTTO9SCuQ9aD+MGTPHNWAudhl41InytYkk1MIuqW7DW
         c10A1jv+klWRQbV/CfssWJwEdHl48HYM98C9sKmqgQYe0/TG4J7IHWQqGeY2sHcP4uxA
         Uy0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YdSf9m2n91aamefLP8qGKuKu6/Pkf1L7aKMLcZgsGmY=;
        fh=D9EXyWpVXJPhRF+GSPdiEzwZ0yzd1+my7Oh9E7yJ0bw=;
        b=RbfM3FeY4qIABHvfljByknLKyMU23ARR2+yjNwg/tJoYT7bl4mHmS87mQX/Bx6zxxm
         gynh98o7/rcY6GyyuHkR/JE1rGhY8uAFtc5ZwJS3E+NdOkk5WpLZMVdUa/MF0vj6dpo3
         9a6rmBXbzk6vdDT2OYcqcI2WZ0ZeGyKJCC3lAd1R7thbfb8f4AVtAu1eoBrCYRgPCn7A
         /OVUx74U1Ofsxj1zoQBLTFHc6q2mxYQJckP6CYDSjYhevnizzQlSJYdf11YNWN8lXdLv
         /5uFcMKSXg0rsjJw8UKISZg5xwsT3+B8qLM+4WVxsOse5LfVHbFAodiBD5TV0zcNqefR
         AdTA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788005455; x=1788610255; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YdSf9m2n91aamefLP8qGKuKu6/Pkf1L7aKMLcZgsGmY=;
        b=kpGxqSVBQyhiILsIKxhFqgVMKDttod8XxvPAlkJZJ+L9BtONFEUbTwZqMm8h1Tm/v5
         /TQajUjKg4ITFZXbRSyW8jiAgsE+5NPSJjM4mqGlzgp4wbiHwSr5Tw723jCzVcemmNhb
         n4lMCJ9aqiBW24QDScBTZMEcH+iUQKNadXmZpS2InFnUO8HUjv/WniA/1+6qJYRBaMmZ
         Z7bavFlZ2uWwNI4CNx7c/4owjXUzXSSgfxCQQd+TgB16LJK5NKpNTReocbDJ75EcDzDZ
         dPEPMTC5Et/v4aMoqgEOsPydLbN7OQ3y+H8d/ZylGbwyXq7SCbrL/TrgUNKQmCtTBtRX
         SpGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788005455; x=1788610255;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YdSf9m2n91aamefLP8qGKuKu6/Pkf1L7aKMLcZgsGmY=;
        b=HHMwHq95g7NOyFxFoariO0lMdyIhRKHz9JsgK8XdOwqQPy1bSTk5Dt4T9ROpMls3J1
         YhZdy/8m73rS94JyTaFKgP57bBP1ahqbBl2CMBZy3xZtTf4jaHc/x/JNe0hDfdO44DWV
         e9VXxIbMXIdm/bmS4Fg2Wna3f34cXW216Ff5ksFDtzw0BK6vyEIb8mLEILAwKpJtU2Z8
         Da732IFE6Ui2ABcz/fWktfM5Ug72Tlo2+YBeruFl+myHXx9WewmqXYrXgYjLsUYtzMUT
         k5wXEPl/cIee/aSTWhjcZmhNW0nFPDEVmVhNk7ntQ9sMO7+g2TXOAazSsvcFnRznMNms
         DmKA==
X-Forwarded-Encrypted: i=1; AKwUvBwC4tKWwRGqHkUvROu6h8L/SQzMSIpynkOjyN569g+l5f8OXbLmvjkmZ11laZlFP5bwSSBHUIiHiw==@kvack.org
X-Gm-Message-State: AFuF++kLz7SnfYQUvProTLzeeTjqvCXdTs7L7RueNpF6xBQbqtGPu/Hb
	yjVIBqA+4yySeL8OLZe2t2uAGJvf/FUCkP0m19ApGJ2H8b6Oz+yEqvpMQcsVkhRULEE5ypNJ29t
	j9XImUYibZGmvrIlSyDdyZlk7lzUfTRU=
X-Gm-Gg: AYBFou1mK7hMUU97VFtPTzTXeJbBVagIVAglIzqH3M2zr3ZOAbkdHZmeiVdQnmWGM6Q
	xw7eBOuW7mxMPysHWeWElr02JYHLK2ecn5pMOFXSRRq7lKacTJXTj7BxBH3b9hG2r3lovzeedDE
	RhFErnHnoVEKrOdmPMyGhwlMo2JW69Nm8whbtgetWUJC0Yyr9nyvrXA1ccH3do9jXjiACz72uSd
	zoOeP7wh6YjY9HW7WAavgINresQS5PsQq0Dcbke7LUq1Hx7Y1BEtMY7SmDSfXC0GNEMnRD5V2Nh
	VubKXBlXGl9YOdqwddHjtxqQ0FXpJboYf4c+M2TEq4ufLg91ifGJo3v65fPfizbwt5+oNF2wsMk
	=
X-Received: by 2002:a05:6512:400c:b0:5ae:a0b4:5013 with SMTP id
 2adb3069b0e04-5b5e685c15dmr4390991e87.0.1788005455037; Sat, 29 Aug 2026
 05:10:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260815-shrink_zswap_entry_0815_v2-v3-0-0171bd86a667@gmail.com>
 <20260815-shrink_zswap_entry_0815_v2-v3-2-0171bd86a667@gmail.com>
 <CAO9r8zNFYM1bry0DwDRNtpnEL9yyXQ3h=1wcLbGsO1sFtGgvjg@mail.gmail.com>
 <CAJxJ_jgihBLy2mbPAN-uqup2mGq+hurKkH=W4RGo4Ad0Eki5sQ@mail.gmail.com> <CAO9r8zP6+6jZ7qOxOy1fyd=UgR3yYP20Db9KghW1zJ3bNqoREg@mail.gmail.com>
In-Reply-To: <CAO9r8zP6+6jZ7qOxOy1fyd=UgR3yYP20Db9KghW1zJ3bNqoREg@mail.gmail.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sat, 29 Aug 2026 20:10:44 +0800
X-Gm-Features: AcwNN1VS1whBYUNjVaenQNu2AZucmtbOSqkRNtiG9piXAGBmW3esKLM09pafUWw
Message-ID: <CAJxJ_jh6J5N0vbFfi2139vnTVZEECJoq-AV4VVNew6a0Bkwk_w@mail.gmail.com>
Subject: Re: [PATCH RFC v3 2/3] mm/zswap: replace the zswap_pools list with a
 fixed pools array
To: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 26BB740008
X-Stat-Signature: 8ko1khqtimtiy4rom6f39iqam3z691o3
X-HE-Tag: 1788005457-520831
X-HE-Meta: U2FsdGVkX18VePh0sK5dKZ92r7dIbxWzrkO8TdtX4RwiKXuk9bKKzFqJ0DasxcDquuyL1uzHcbGnQZJChb6y6gVGpqTPIYdsdm7ylk8D/F9BgrF7YieWnIdSeJ3yYGABecJQh3vAtJnoTGs7VSDHjiwyXOb7INv6ppSDsICFKzrCfBY+6IwbZKI2ljPMqY9Mu0JY4q0BtUiWgTH2FoHuWslGGVRPHOq22dPn5uB74m9kz2TPGL8hRPjrXpk/P+5Z9/uHVOKzQ7JAOT2DxkKPkO2yb5dibgZkxE7F1AWQ+KuMlX9FtFSXAUe6+5DEI05hCaPNEXzqWzhdL+8Gg0fVw+lPLr8RPvAT+TCnVvKR+rwABj4BJlwpUpF2JEbxjRdIbjSRBYcxo7RtsttwOI+F7zOU2eEIRQPFxwHh1sFypbsgRzv5kSrmRFZrRectqDw/b38KufkUFznuJs3sDTHvMjXbbtO0CLfMMchsEXYWuk/rMS7OjRdSf7u/L7x887I8kaby+ILKnemcrT0UJr3gTZ1MouEtYeML6dI6VeZhaD3txOMeaxsPSsfIaQ2wWgf39ksIidlNOD/wFjfI+INDsWUlccrR7Ft+HQ1pq9lv2wVjMMwKmJu1U4NWYzMPb9x5coHQc2rInwJfxolhDnvDQxtaM1wS3Ks6MfFSpyoVGEdw1hOuWe4XLpPwyGek2Vz10wlZbi3hLCBdrLFqZa4xlI9b9qneEU4YE6kZV6mCNMpuNgUVGUwIyfyuXwgNdDuhNte4qHNDFdHHjlS/xAeLFmJLFB43zHHQvKrMv3qZv1gb9mTGDHv9fvIHPHe5Ow74pECmNFzZG0LKPxS7aOrOnhTR89VFtU9ObdSLJJp8j01nw/429niW1aPb2tfKzSe3TYI/JuxZwGMATbrridKBVnxP6jkEp8tvTP8QbOZ7sIgtvoTkF/TnNp0xSL+1MPo2JfD/DBHegn14eVUdVPd
 1e0CObtd
 OG/TSrkO6d1blCif+8B1hviPAZjigAE973EqEuleVMPnmX1DxfXQeCxx4HJ5vUJ5fA2xnbVEPqYI8iEkd9IwO+zUsFVUYIjokedigkXekIIerEseWdUSxJdLncvyqu7aKtStwOs0KMlE2Q/NYJOQdwBKjRDzWQEGfCGhhM+Jwt1rXV3/DymVEVpaK7Fqe82UdHtn9D7kktl/x5oqLvQC/U86XGNeAhfr/f01tNSUd22SgPZEu+YZZ04zkomqCz2Xg4cPE9vrm9ga/7I9P6tuUdXU2H6jBzu1sHubTXz3HG9A3MwVXTz9pyO/8atW2kli3Eyf5VrJ1UEIV6s54bvLiV88KghdNt6nFR0LC6svSOOq0qomOlr3t1rIaEsLQ1SeJNmgFJVleJBE8QvWL3hlLwI/vR0UMTD0nNxf9wr5VopeOSm+C63gKiqdGxIW/Hv8vNTJ+PHINMAL3a3m6dFMFYPycKBjJ+UzmYVizOetHtUABMQn5DSC7KDgXFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 12:56 AM Yosry Ahmed <yosry@kernel.org> wrote:
>
> Makes sense.
>
> Actually, this led me to rethink the slots reservation mechanism we
> came up with and the issue that Sashiko brought up initially. I
> initially thought it still existed, as two racing threads setting the
> compressor could try to resurrect a newly created pool. However, I
> realized that's not possible because a module-wide mutex is held while
> any module param is set. This also covers zswap_enabled_param_set().
>
> So IIUC, we cannot really have any concurrency here. Pool creation
> either happens through params setting (protected by a module-wide
> mutex) or during initialization. Does this mean that Sashiko's review
> was a false positive and we can go back to directly assigning array
> slots at pool creation? If that's the case I am happy we can avoid the
> complexity (but sorry I led you astray).

Thanks for the patience here. I wanted to check the details before replying.

Agreed, and I confirmed it. param_attr_store() takes
kernel_param_lock(mk->mod) around ->set, and for a built-in module
(zswap) that resolves to the single global param_lock
(KPARAM_MUTEX(mod) -> &param_lock, "Protects all built-in parameters"
in kernel/params.c). So zswap_compressor_param_set() and
zswap_enabled_param_set() are mutually serialized, and the only other
pool-creation path is single-threaded init. There is no window for two
threads to resurrect or create the same pool concurrently. Sashiko's
concern was a false positive.

I also tried dropping the slot reserve and went back to assigning
the real pointer directly at creation. The only invariant that matters
is that the slot store happens after the pool is fully constructed,
it's the last step of zswap_pool_create(). So array walkers only ever
see a NULL slot or a ready pool. zswap_pools_lock
still serializes that store against a retiring pool clearing its slot
in __zswap_pool_empty().

I tested with LOCKDEP + PROVE_RCU + DEBUG_ATOMIC_SLEEP: an e2e
store/load workload + compressor switch (lzo -> zstd -> lzo) that
exercises both the pool-retire and the pool-reuse/resurrect paths. All
passed, no lockdep splats and no suspicious-RCU or sleeping-in-atomic
warnings. These are functional tests only, 2 writer races can't be triggered,
since param_lock already serializes concurrent param writes.

No problem, the discussion made the concurrency model clearer, and we
can drop the complexity. I'll refactor the code and send out the patch
in the next version.

> It also makes me wonder if we can just drop zswap_init_lock, but
> that's a separate project. Most of the zswap init code needs to be
> reworked imo.

Agreed it's separate. zswap_init_lock guards the zswap_init_state
machine and coordinates the two zswap_setup() entry points (the
late_initcall vs. zswap_enabled_param_set()); the param lock doesn't
cover the initcall path, so it can't just be dropped. I'll leave that
out of this series.

Best regards,
Jianyue

