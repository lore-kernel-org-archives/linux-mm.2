Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4FBEC9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 21:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DD116B008C; Sat, 26 Sep 2026 17:48:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98CB16B0092; Sat, 26 Sep 2026 17:48:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A3076B0093; Sat, 26 Sep 2026 17:48:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DA616B008C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 17:48:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8E22408CE
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 21:48:06 +0000 (UTC)
X-FDA: 85257251772.11.4D832A6
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id EC9601C0003
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 21:48:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TWxhuT2t;
	spf=pass (imf20.hostedemail.com: domain of rientjes@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790459284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4qgEs2vcdrIkc6zyBU9wFP2ey+NlO6hQzMcCWB2MTqU=;
	b=2V75PkZ0FHwADJ2mswe/5sC5Drh4ZE4NCXH0A+nEGm2RMKe15KmUREIjtrGDOMRl+Pe5FE
	yN4Z28Pnyr6e7xbV5JcrN3IRVA3rW1M7h2LtqmyvE5STXtchM2AhrL4MVWoPEEdaZ2zFC3
	oFAkxzPZeR4mARU8wxDmW9Oe8JZUZjE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TWxhuT2t;
	spf=pass (imf20.hostedemail.com: domain of rientjes@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790459285;
	b=LFBm1RWeCtPcpN33JoWWXIQJcBobVdJ6OSEoSXsc+Pztzr/YilWG57Y1sTKHgGrRtiydlf
	giRXRYuc2G+xzMtMf2yDV08WGP3nhX+0ER8YLa40Ta+qWebBqh4BO8roRjpIQzjsaiHkSN
	v7erpdb1ikQrq2J0XsVCDReICP2N4IU=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2d3b445a84fso34055ad.1
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 14:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790459284; x=1791064084; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4qgEs2vcdrIkc6zyBU9wFP2ey+NlO6hQzMcCWB2MTqU=;
        b=TWxhuT2t7Lg3RXTfB6BLZN2Gqu/ixkE7YInIWSwMaaBnDSz362wUioWWzN3w0iZBG2
         4Pl0/xzSwiM9jQEg+nQU26G77oeE/6fNp3caU60/cnVSejOXbEFMQ3zHV023ti2CMVpk
         vMwCrnd1K0fFz3PZxyJDVS3Q6got+xEwfUGdRPz87atEb/FcFOFWJNz3cP+12hU6E0eQ
         sbaiHbVJ1h3TIY6Uv3oXLYZvCy/3IQfTd9Q6xD1UC7TLCODlvZMYHdMMieizlmVbl8HR
         sFGqydzULy0ygWa5vWJf5eOkLtGv9KdQsP7o3MzmkZLnOdzLI0Kblle4Pz1ZfBNMIjzh
         SUaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790459284; x=1791064084;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4qgEs2vcdrIkc6zyBU9wFP2ey+NlO6hQzMcCWB2MTqU=;
        b=oBkXa3EsMe3YwGzCGAgv6RL/iBClQkwfdNwLlRGd2/Q9RLNvZT9S3HNHJJ4+1PonMg
         MQNZFsVqQDXZgltj0QxaWyXNiZ2LQwmLgoJ9Kkc3jeCduhH4/OIArIk4I3J+qJXai70k
         Gyyvcz5Ml4dp00UyEcDdJpTo0CoEMSvbAxteGnbAiLNIN4KNZ+76U3T0q9PoXEIjut3R
         d3ho9P8aEGoGEh9QG+uTgdY/WBfEKUtovWuEp7eYO4mu42K2MCb68scwNamPyeER8ZWr
         WZuZCLYQSYVQgFUf1O3eVCNUQq3BJUs+Cigx8PUVm81zuoTWfeIBZNnSycSE3US7KVU0
         dQjA==
X-Forwarded-Encrypted: i=1; AKwUvByAgbwuiZaoRV+3cbqewxcZBCG6io78rHNjvA0EkXNRiG2dER+WIbMWSYeR+PxK4SzNrZ7K5uKuYA==@kvack.org
X-Gm-Message-State: AFq9FYKc9+9UMqju607XAfIIiqn1o4Tm6LGeeb7aCRk/XVMAJpZT43uw
	OuB+0MZIXQKIkciCNIweO0FVr2E+PKhKVMlXC66+pthn4ve5ok56cCW8+d7YT9/Y+yF+pVi3o8+
	UGi/mp0BN
X-Gm-Gg: AYBFou1ejXIgMazidAt7gDdxECt5OHDmH+WQit55DzoWVnkq/N4UWQYMj1aL7pQR4gt
	jiKK/HqHlzY9i25o5P4PnJoKwm8snpTUTHadqvHibZe1dZ67UzO64/QM5Cejejkv56Mcfm9d45e
	6iwaZQmJ6vQVvNPU0M1jE+wfrgqBeaQ9G8m0sI4uF7pt7E21FiLJM+nHPjcWXOdX4YweyaqyTlM
	t67+jufEXbzUFto+jF95jLMw/MLN0P4aWil2OdxVpJYTPYN1M9SdrvJKjpk8LzyThWHMK5PNzWA
	k2oH/SWFRJn9Xtm/X6MK7NMhW4M5XQ24uT9XN7Bczzn71WnICsb93JIDmiiBLoGsoNb6ml9UsYj
	HDYElOqHcKbPzhtvGSyPLkdizO86jEXcCBUp8BMal0Wau31ET/ZQ/tkCy9Mkj0GPFrHpiNMkAlG
	xVEoFaOGr78aTO1dmxVAGPsrDLqQsHjve77CvqHkFxR17fPqez1CGeiYfXuf3HwYVqVd0lVkUj3
	ebMq8wrhTxcqth5IUsMo0HnsIpwiT+JssTBYCJFrmkoZV5+1k3Gn+pweozNaxzPlF+hRWDcD80C
	uRUnr3i4BXXpSj10akjyATQUcc1T2MtOA0KwIG2G6ZjIPHA4s0WA7MZY+P/50ubRfJy/O7i86ik
	bMcF7Z1c=
X-Received: by 2002:a17:902:f684:b0:2c7:f0cc:dafa with SMTP id d9443c01a7336-2dfa973eef0mr2554795ad.5.1790459283114;
        Sat, 26 Sep 2026 14:48:03 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:125b:13f7:c69d:3887] ([2a00:79e0:2eb4:9:125b:13f7:c69d:3887])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0c719f86fsm9058892a91.7.2026.09.26.14.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 14:48:02 -0700 (PDT)
Date: Sat, 26 Sep 2026 14:48:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    "David Hildenbrand (Arm)" <david@kernel.org>
cc: Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [patch v4] mm: vmstat_kunit: add synthetic benchmark for vm
 stats
In-Reply-To: <cfc1edae-8aaa-8fd0-95de-af3d4774c6dd@google.com>
Message-ID: <88982723-cf05-52e2-92fb-f14c0dc4dc77@google.com>
References: <cfc1edae-8aaa-8fd0-95de-af3d4774c6dd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EC9601C0003
X-Stat-Signature: 94ndbo4rbb8wsfdruo9iohjocgf4gya7
X-Rspam-User: 
X-HE-Tag: 1790459284-10537
X-HE-Meta: U2FsdGVkX1+OGz8uizqHvbIZfxbZK5iGzPGHiuFzkkiop0qeTzsa6yn7YoxNdgzp0j6OsnzyKpYCcKIpBP5fLsPBl8bv0X9ymC+P2cuy99NGIcNMbbG9/fQXY6PR1++J1gsE6fOasz7ppj2E4j8YxSyf410/yXnIqjeqIqrBe2CrReaYssVpbN1O+9QvYxywmxkscmtgM/MzmNgwIkeDG6ZcPcfi9qYugYyPaMFJX9VqHoST9yMYqx4KfKwsxucHVeAD85Ly22rTyiHZY3XtcXmGJRxHIF3BV5nM97VLu0UQhduQEow46DYKzYuJMGm6jVqdceCgi3Vl6bPv1FjJV2gv5OwBd+DFyfn+EMQxR24tIdjRAMwp0+e/J74fqqtw/vxqSo0v/rdc3GzReeGHXic9vRIuHvkKTjGMdVikXA1miJeiKF1W1QR71+AY9ljHvCxMnX1nW2Y9otfKumYu0fmYBQQ186ZXvpftw51U4U6rbwDWiNhKhDRaexgyUfKhYgpXta3dNThlAZCmj1wmvcVzMTbAMmpDb6nlyCJJb/7WQ8N3ARdX+3vI9OM1RptenCgp6VGEHjZuOEU+FSSwepmnAv6N6sKjVzvl153Z0gfNwEx1wV2sPPskBfQ/UpXsDF2jiX1U7IHe6SsDZE3HQgBFKubgg5VnqBoTI2szr74XUwDbR/iSzE2ySDuVij3wVGrk+qlZ+8v3MOpVuDqDJxLVuNdegM8LgpnvKk8HQ9Ibq1TFGby2P2Qzkvt06JvFr6R3nFEzdQbOWOd0Jhq4/yPp2dabWpTzEqZbB+m5azxjIDXd1kFo7fBALeFuMuKxn0VQkDtCojl6IpoOB08Cj2Inv81dOBsl0vdtYxaF27vNBFYceq0KAgNKosGPB53PDkYi/1D2dHC7WEY+uKet5n7RONGgjybnBP5d769Vrucn2ZOr0CT0IBmKBpFaZQ8WbsVRtH8eg7M4BepF87i
 tT/NT3hL
 tBYLrIv8PpfrjDf1GL7oALoJwVr5Rq4MhoRIl+Vq8pw1e7UYnuNBaA5FCbSRwu8qCka/s8UQgKb3g2jndlr1kjMh+voaHrIaaEtypIVrWtBc1nPCAszO9o4GcXG2BVvXvJ2Lit646VtBIJOy4sQy0Gpt9kFjlixHypFcN/5Zkk/vP1k4AA82PpEOScfdR9n9V4Z38aorsYC1gZqIlCjvAJd65J3riKcwyYzfGbjDr4jmgoM3tMp6BGGdbBrTIV0hTLEf1pk3yUBTAoRJFJFUu7sCEDBXII5YMIUu+98+8W3CCKEiYdKILtCnmbxXd14HIyUyLvVa6D8jr6hjkLw+Lk73HWzrYgVpp6+f6tz48Ol8lniptBoefHWCdVUyP2qJAVBQB9+cO+yPjOpAfHviQojncDIV2yYVrx9cveTaAnhM8r+E8wwHWxK10HHYA07Sxga7B7hURSJr1WsRKBcPX3kybTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026, David Rientjes wrote:

> From: Christoph Lameter <cl@gentwo.org>
> 
> Add a synthetic benchmark that can be used to measure performance of VM
> statistics.  This is used to analyze any improvements or regressions in
> functions that are frequently used in hot code paths.
> 
> The test is run by KUnit or doing modprobe vmstat_kunit directly.
> 
> Sample output:
>  KTAP version 1
>  1..1
>  KTAP version 1
>  # Subtest: vmstat
>  # module: vmstat_kunit
>       1..3
>       # vmstat_test_inc_dec_zone_page_state: 10000 ops: inc_zone_page_state -> 8 cycles (4 ns/op), dec_zone_page_state -> 9 cycles (4 ns/op)
>       ok 1 vmstat_test_inc_dec_zone_page_state
>       # vmstat_test_interleaved_zone_page_state: 10000 ops: inc/dec pair -> 17 cycles (8 ns/op)
>       ok 2 vmstat_test_interleaved_zone_page_state
>       # vmstat_test_count_vm_event: 10000 ops: count_vm_event -> 4 cycles (2 ns/op)
>       ok 3 vmstat_test_count_vm_event
>  # vmstat: pass:3 fail:0 skip:0 total:3
>  # Totals: pass:3 fail:0 skip:0 total:3
>  ok 1 vmstat
> 
> Assisted-by: Gemini:gemini-3.8-flash
> Signed-off-by: Christoph Lameter <cl@gentwo.org>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
> v4:
>  - included sample output in the commit description
>  - switched to NR_MLOCK which is display only so no side effects
>  - remove unnecessary "rem" variable
> 
> Once we're happy with this change, I'll apply the same treatment to the
> proposed pgalloc and slab tests.
> 

Andrew, let me know if there is any additional feedback for this one and 
I'd be happy to integrate it.  I've got the other two test cases converted 
over to kunit tests as well per the feedback so will send this out as soon 
as we're happy with this one.  Thanks!

