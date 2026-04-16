Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 805E7F8A143
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 08:09:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B84826B0005; Thu, 16 Apr 2026 04:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35AE6B0089; Thu, 16 Apr 2026 04:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4B4F6B008A; Thu, 16 Apr 2026 04:09:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 945FC6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:09:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3543016078D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:09:16 +0000 (UTC)
X-FDA: 84663693912.12.9A51C3A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4782E4000B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:09:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vQcDjpaf;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776326954; a=rsa-sha256;
	cv=none;
	b=cKpH+GHEOfNJg4Mb5T4N/5A1xdRVHhZfALGaW5cshlaNoLcMDW3CClHyP8ti/zalYojE/+
	GJ+m7qadohaTweIAdt9bh7GkGVte/jzoDW5cUbib9fN/fwrgwkLcDFdbAnNkoMrCOlNNHh
	lF/pY5le9REedSZ1bMeIGCivdn8aLRg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vQcDjpaf;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776326954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+6E5L/DAt0NztgNlJggDMsjuoH48nUdyhLuE9/Pm8o=;
	b=dzPvvEqkGLLLsIayhjreO+VTk+rXdAWe0pjT6JJYbz7gcJIpJ3ms/YE+tP5/xda0atPmbm
	LmxHf0wZ/6vflJL/xR6g67u8A4+9VMlNAtSadq3K0DFblG1PMZ06LEcV6TwE7YzNFaojhv
	/4sDuMs3se9jh/nC5FkDhyjc8LbsPV0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D4DF60127
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DA5C2BCB8
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776326953;
	bh=OWjwJArMxxnuWCNcVjFmcPIsiycq2qmQ6eEqyuLfs8s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=vQcDjpafhjSPyLMUbB0g/MeIsax/hB0tHYmEDA4FSK1TOOpNpTloVkpFrmMreA/8l
	 cen4amP3/KQ69Xq2rSh9ytCMzj8/54ADWVAXOHSBeBzXZP0KgH8A5SGapW8ETmbE8o
	 8NfD6zs7vsyC1gsakGJJ93lZjLcPAyTIpn+yhyd/VxuzfhI1SYH1IBa2IJ+pwhRiNB
	 TLT7mW/XD9TI4u5fVd5nXC2F6EInDrMtexJlsrb5+l5QZ4I1eRqKwXufbUI6pZfFHT
	 2QbI8HYzYII5ZGJ2uIT9UL7BAjJ0jD3TAvPlNZRvlwre+V16cBX7/pe5/sDtOAekti
	 xB2Yo62FmjLZQ==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8a016799d2cso83147106d6.1
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:09:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/w7ik8ysbCn0mWkQMiC/qLCyodQcAoyvl9V+7VIfkXhNuG8iGM0t/WTIxi5cwic1OvIVo1/VENqA==@kvack.org
X-Gm-Message-State: AOJu0YzjVKP6e+mMS9/qVL9EGROQTWbkxZqcE7+UsAaomUZqD+APo9NZ
	7+9klyqB+o6HbvAR5xwWKEPjs5XythFQJkk16XpC5mat22IntXW7pOWFKwMPzxfPMcLKWxvVKT4
	TmwfP2h7MBSGd6rhxPgSrMUB4SdkVeFY=
X-Received: by 2002:a05:6214:f2b:b0:8ae:660a:be74 with SMTP id
 6a1803df08f44-8ae660ac6b8mr126936876d6.7.1776326951804; Thu, 16 Apr 2026
 01:09:11 -0700 (PDT)
MIME-Version: 1.0
References: <adt3Q_SRToF6fb3W@KASONG-MC4> <20260414054930.225853-1-xueyuan.chen21@gmail.com>
 <aeCRnAhfg3fNi6Ey@google.com>
In-Reply-To: <aeCRnAhfg3fNi6Ey@google.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 16 Apr 2026 16:09:00 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z-3WQQR6f_mMYHNEMAc07h+JPMxQTsoR0+GWgkvQVRTg@mail.gmail.com>
X-Gm-Features: AQROBzAxRhEQrDRQPKtEY2UjI7ERhEcteUuBlCcyMo8dNRYtEUx3JeOHDKYsMK0
Message-ID: <CAGsJ_4z-3WQQR6f_mMYHNEMAc07h+JPMxQTsoR0+GWgkvQVRTg@mail.gmail.com>
Subject: Re: [RFC PATCH] zram: support asynchronous GC for lazy slot freeing
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, ryncsn@gmail.com, minchan@kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, axboe@kernel.dk, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	chrisl@kernel.org, justinjiang@vivo.com, liulei.rjpt@vivo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4782E4000B
X-Stat-Signature: yfjs8asogrd6n4qwebr9txjdsiiaex58
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776326954-312742
X-HE-Meta: U2FsdGVkX18pfYSWz+/SkEB0Rvhe8SQkv3DKqpye7XDhp9QK9aAOcikNY/lJCEaCbbEt0H9bjdlsMFrwOeEX4FdiqB4b+2LLFGcuirWNatWOkDKHSySsaaawh5gun8mZVGL+LE1cNsNRITEx5V5ZE5HfmrIvYODOVDWe8BpCDDS1nu3l/72UamQliKMOKt+VqnZUt/Z1zvRms7pxx8I7wSAS3VJh3F9QwHHSaSedkqsbKZG2nOzt/7dJuSrhcW2DhFbvGkq8VIPErfX1SVwDPFY9AVY6/bd/iXv5nmQ/w2sX1v7klFJSUtKrWkEUnW5cNcXel+M/udG1g1Y+w5E3nnpGbB/UTw/MowdTvzei1J85Y5Q+FRDazxKnNrVCnUfRbVUAU/tiTn0LufGlhGe9XNI7k3DG7v57YpaQQL5itklqK2JgS3BlIibfvNF5ecPGfmFKQvQF0P6oMUWwcUCktchfuiZa/OCogPZYYjiBxo4ZdNgwTSQZ4WQrj5k3IE/XVRgt1xgxWFQ2lfPkG33MQyl9tKpFNM9K0x+LRH43JT9RRkCS+sC5Aj61NEFVIr+wT6b7u1inNoDnqTKYFs/mH6+sg7X4Lgnv/uSpr6FIYF8GE5dzPZo/2eAT+u2ZQmqLuly4pGrpxD6A2XVR4MVHZ2uuJ4PRcy1UQseqVAuevn+LV5g3GYplz6L9hdA63isleRG1NuoixK6zYfbcvm7Jmk/Lhw6aqIkGGxoI8KB3tj0ZpuKlTsWl7qHnbPzjU2bxn05WA1XudZiM8OR/uJC86DVtKVo/aotFD4t8tyZcQiR3HsIyxJY4s804uAt2frlTZ2FBas5/S0JhgwvhDKrY7UBz4dVE1DOKCx6I9g4KEeifZqTbFlsaDTRT+jHuxRjCs7MhLOlHXhQ1colZhd2xxLWfSEnVW094rm+S3qQgEgstt6SCR3bsdwJKOTXGqeFn0gFUXwI/ZNVSslkjL2b
 vDPnMzVQ
 KhD9AHiQKvxjA4q/EwmWO4CPUXYdx1mRNUicdhsgbBl3d6C2srqCzw31G5E9UZISeWmZB/UsL+4/YK46vDlCm+SXKOiALtRJyzxvqw+6QsKS3izMRTc1oBkrn5f+Hm5CU7VUt/M+vw5jUpoM8ft0v2/vaQHUrZ4c5BJFNLXl9DPo+vot2sDu6V5pf4S0IyoeNo00WKW/Dt3QgwkBrvbYZHMg666cl2lErYA9iGI9dwxAQD5Xo/UnGRhjeO044em3LbRVpeJXMB7wqECVjqLorv2F37gBHoggrTcMCFnbNw2m0Ca6GsBdp6NxcEsPUA6EC/i/g2seqd6K5UUNO4TskHde/SmUN9WJXew8tXGlSgN4LK4lWr3UdVhIjOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 3:41=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> On (26/04/14 13:49), Xueyuan Chen wrote:
> > On Sun, Apr 12, 2026 at 07:48:48PM +0800, Kairui Song wrote:
> > [...]
> > >What is making this slot_free so costly? zs_free?
> >
> > Yes, I've captured some perf data on RK3588 cpu2:
> >
> >   -    3.79%     0.42%  zram  [zram]  [k] slot_free
> >      - 89.04% slot_free
> >         - 65.40% zs_free
> >            + 77.29% free_zspage
> >            + 21.75% kmem_cache_free
> >              0.68% __kern_my_cpu_offset
> >         + 13.19% _raw_spin_unlock
> >         + 4.86% _raw_read_unlock
> >           4.75% obj_free
> >         + 4.72% _raw_read_lock
> >           3.64% fix_fullness_group
> >         + 2.02% _raw_spin_lock
> >         + 1.31% kmem_cache_free
> >
> > It's clear that zs_free is the primary hotspot, accounting for ~65.40%
> > of the total slot_free cycles. Beyond that, have some read and spin loc=
k
> > in slot_free.
>
> Just a random thought, if zs_free() is costly then it likely also affects
> zswap, which makes me wonder if doing something on the zsmalloc side is a
> "batter" way forward.

Xueyuan's perf shows that 65.4% of slot_free is spent in
zs_free, so there is still around 35% elsewhere. However, this
might be a measurement issue. If we confirm the number is >=3D90%
or so, moving GC into zsmalloc seems like a better option. My
real use case is zram rather than zswap in the Android industry,
but this would benefit both zswap and zram.

Meanwhile, I would also like to try whether combining many bit
operations, such as clear_slot_flag(), can further help.

Thanks
Barry

