Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F0E6C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3442D6B00A6; Fri, 10 Jul 2026 10:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31B1E6B00A7; Fri, 10 Jul 2026 10:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20AFA6B00A9; Fri, 10 Jul 2026 10:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D52D26B00A6
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:54:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AE5F16965E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:54:17 +0000 (UTC)
X-FDA: 84973162554.15.8675DDE
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4FD1680008
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:54:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AFG67O+3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783695255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2lMcEgUfrouAqfuHqw8FymiRDR1t3DKONMu9zjnR0Ao=;
	b=zQ1lq5/hJkism31E2t5RyRGMyM1i2mfxada7XxAagtdomhEDPaJQCaZBnf/osZv/w8lrGP
	AI1U54kA3xVPga6eC/hce3+QqyjMGKEMUATfJeyMGlavNVX6FmQF4gX/0iTqEISnsZOvrL
	zQOTnnnEEPLYKULhpZ1ny+rlua4392E=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AFG67O+3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783695255;
	b=ocrbypGRwZySuVf9ii1bRAxe8Td01Louk22xsMzvxDwt0riKLKHXO0iyX7oC+XT3RovyaM
	H+OhtGJEpQa+9t1m5Q/sU39C2mWMTkUTNR0ybEvxskJhIKiE5AfDY8yX54aJuHVrKZQoM5
	/+dbiMTYtTFmX5dZk3usVzg+vbEW9vg=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c10e86e52so300401cf.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:54:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783695254; cv=none;
        d=google.com; s=arc-20260327;
        b=X/wQz55OH+x0vng5cxiP/zAd2wmzVDzHQHlaw+TBYxxZNpRU2l/UAJhObTNLhMOfql
         SZoSh6/nZHJHetwDtP9YYpv4bAp1BlC6qGeGByC1MOTAC/cP30DLfnNJEdUx0WnIlh4U
         RkO7MtQzhny6VFaZRI1OR+24tqsTc6ALSTPsH3JdKKLMujFub8+qoCLk2TAWbawQzFAo
         wn+KuCWwkjh27h2ujZ4I9h7Qi+tgMTgFFj0+iJkW/QJQCKcc4vxhCiokniYDc8R0S5iv
         5NtEFMidOsyvkf6Dyn6Hj5xip/2bZEvxpDcuaNFDGQMMzAs/NjFYf5/8YnrA05ZZG+oD
         5plA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2lMcEgUfrouAqfuHqw8FymiRDR1t3DKONMu9zjnR0Ao=;
        fh=Bb95nOxbFmS2rf04SK6Mrjud2jM+yi4AcL0ht/jlRSI=;
        b=sFSUBF/MMv2I6pbimIVVdgTIQr3G23w6PHjp2u5OV49yQCitV1jNseRU1u2TBawK2c
         A6L0oN5aMNoOk5n4cPkqsEgUNcwDwayDH/YgWFFv9QtAUDeZvzyx002hVecM1GSmEQdn
         PxNI/5dLxpVGoxOvaIeKWMXP+0VjqMRpt4gLsOU5s/VeJabV+gvMSiTgt2I/0fxSOLnY
         LNX40ir283zRJ1RUGyuvrabBiWmmvammtRO+qYplER6bjEdjMnLmyGwIX8wbYdkX1pwW
         CVeXRZVEdSHbyiabDXpe9oJAlI9RlEgfYFY6zLUoVc8N9N7yn4zhzgzxW13txUvnhW9f
         TNMQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783695254; x=1784300054; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2lMcEgUfrouAqfuHqw8FymiRDR1t3DKONMu9zjnR0Ao=;
        b=AFG67O+3oK96SiG+BBf3Unju/xDiJ1RQ2VJrpE7cQmqgIh2dgLutxVdgLtO6+161oZ
         KAUrXWVPvOcwdeOvsjV8L1S2sq7uanE2GW/AptGxZtrhbwURJ1c4uzeMR4eX30BoSrvV
         ZnBDEg++2NihTx3UhndUBEnjqrF4VaTzIC+cjVcORQRF48WC5LT52mAAzm/BKwUvc8Zn
         0gJsu1yqktDhI/q56sVODS7uvnBE9Q96VVTbqhGRMUz0YXHfzxQMeh0RlYIrFAbKAnWH
         rPCWaTvt7UZVMZKOzZFqSqD7qMGRDv3xEw67LKyUg50UiMj8XP9HXbWdqYcvM4kWIkYd
         h2hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783695254; x=1784300054;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2lMcEgUfrouAqfuHqw8FymiRDR1t3DKONMu9zjnR0Ao=;
        b=OyLv2Q1kbMianeHJRAK2uj4xkgeQulgffjhjrCVcpaJGEpQjiSVkKDmrC0JKJ7G9qw
         MckScTyD4MQJmm1XtCBJRZ3IiR5yQbs2Fb4ZGWNrI6XIc/s0/E8Q+R8j4S1Zax1JiHdi
         asqW5YRMLq63hoMt4e0jnbM85qyU2+sdMsG4VXSBSKQs1yib6D2JrgyRIJeZY8BBBVK4
         JsE3bHlovWBqXQHgpTBRu7fQuCBwDJxU0OPRdvlo4kzS5Lm3BTDpeUJAWsP1PP7zV9wB
         3X9KXLhGabKwzkeVG7sO17ZK1R1LAL0tSpjllNmdmZ4D9L58CwzjnqTyuyIh6bR//75f
         cz7w==
X-Forwarded-Encrypted: i=1; AHgh+RoNXLqqg1BxM9dgTe5IDCDUpt3N77G3A0nrbSfvS2bogzTWiJ8sUqCi4AK75bZWL9gB+bTiz9EfHA==@kvack.org
X-Gm-Message-State: AOJu0YzOODizioK0CjhTK6OKOapY2ICBwrmN4DGapGYgoEowNNnhKC2u
	Gk+XwdJZj1W09DAT6W/W/1dQ2kwMtO2hW3U8udfayRmF5YTCyhSvLDrTwFwglp/YVhCv1YfsYoN
	m6m0KTVetZDYfaV3Pu7t6FQ3ed3YZd9uNMjhfdOwx
X-Gm-Gg: AfdE7cnTSdsvoj3I3RfpmTLraeH+b7NKHOIK2RoCqiCEhomk1uL78KtxxaKDlHtyrp0
	qmj9faqcfmBH6epepIgRcKQ5xYzgbQyLHrWEAPT1JaEMp4WqoBa8XIWw2fXwLJXlHrtlEWOW98U
	kpv50moDpJwKqCr4XxGIiPm1inadk4G0qBgemoyGrDUivRoQ4AtqNVBQSdbDwKjTjLFlH7agmsU
	o+BtPU/Z9ASwwkl9SrlMPYH0XSAVuyAnN6NUTmoVILCvT48V18KWu0znKMN+KeoUl63EWrngZd9
	d7cuRg==
X-Received: by 2002:a05:622a:22a8:b0:51c:9ad:d76 with SMTP id
 d75a77b69052e-51cac55248amr8235981cf.19.1783695253420; Fri, 10 Jul 2026
 07:54:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260626075019.1833065-1-zhanghongru@xiaomi.com> <ak0Xl6q52exX9sBH@lucifer>
In-Reply-To: <ak0Xl6q52exX9sBH@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 10 Jul 2026 07:54:01 -0700
X-Gm-Features: AUfX_mzELtiYgnEvQKzFQOlEK1YaEae7FJQ6Fh__Q-TMLISiYa4WqwvXLpp82KY
Message-ID: <CAJuCfpFqQc+XbkpOiFb9Xap3VME1BevndWi-XyVAVKAfGMhRNg@mail.gmail.com>
Subject: Re: [RFC PATCH v3] mm: retry page faults under per-VMA lock when
 mmap_lock is not required
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Hongru Zhang <zhanghongru06@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	mhocko@suse.com, baohua@kernel.org, shakeel.butt@linux.dev, 
	linux-kernel@vger.kernel.org, Hongru Zhang <zhanghongru@xiaomi.com>, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4FD1680008
X-Stat-Signature: ywntr55tc8t99ir8sj65gsr6m3joc5yi
X-HE-Tag: 1783695255-780307
X-HE-Meta: U2FsdGVkX1+IQq7HPvYT3Q8VU4YE1GDDaOAeoFFhVVC9NtkovwEMlzMJb9A9fPdIveaYOYF5rrXYXsA/RGAKj0k/kziEbgWs7IHgqfSyOp1NNlaXg63eHbY8je2cy+CC2UnR/48KD0Bt2vANA7AQUk61kcBk9yks3yhc2wHEGMosoB+flpMpYHV+1UqajkPhcOZYVMeLzOGQvmWUXO9/LS+b3kqngOX+YIng9UvbgpmOMPTb4XuXoepXic7n0Q99ZWUCDXB9dNs+aClSmTAG1SrEy0WfyYwSRRnI64V8SJTBCxCJgT1RqO9IrWbhdsJ03rzKXIb/Pyl7QC+nqVAdonOFj5UKm76nRrmfGkVdDKbbd3pzDBnDhlLKf7y1qu+NBdjbWcW9fqzwEWq8cdn22DO3gUhgmDv235U3j6Re+Ggi/at7z33hOPm1ceDyX/drOMzieRD6/p8Uf4Y1y4y18qg3xGchC4Cgh9YoJMPpME9fT5BT4qaIvuZ63MjYo2vzqyhbiZLbXeu2bDZvPwayMsSmyPhhkllEkS+j/D5PZf+RnEhK+certVFWmina9VZAPxVRw40hhGYq40/027OZYx06pcips/O0cwGKRDvfLLfn8OqqnL/VkR2Xsv/aa2B0zQT+eEXWwE9zl85koT0RpczVdH7rkUBiXvFNMiSDjVPM61wEpRebjgIdiBNfk3KhuIX1yd8rP79BytVUL83HlsLPhsZ9+AvJv79J5NEDxm5tpo28kSs8MQe231hnuOWMzo9j5r1R4GECayAX5ihtpkgnvy67s+MtgWzx0wiyZhvjNBXjskj54gL4g7/HF0po+wHrNxrw9Q9Kbd+llfGR/D2jk2ajbN+1LnKIvgkWvneNCaoJipU1W7g7PeBBI5+iZa5j/ey3nXPFtuTV96jNUBJGrPxGaWPBUNndZGWS6f8hjaarpptsq9LqsVoAZkcDMjVu4SNqbes5P1lEZon
 cA4nfWO8
 vRRV2Cuj++VahymGFKQZT/Gl98kCGmHPlXNJ2RO5gQqSQViuvTWqQpS6ZWc6zEBSLfyuZnF8YqBHZQ3GPRpRaQ1ZZ0liqVH/TJsY7uN4yRDUHuGseSITaNebDLosgYiPpfZ7V3k0ZnwDcYDYvXRqtnnXM1MMRCWdarJhrHGZE+Ab5o9OoT6tS7i9fclB5mUnzYU9i3sRnt8OVZ3X1Jc3Sds6ZaFH4iTKn190SMRpdeIi/ryxi9L5ZDs2JAm1VzaF1+CnAkeg0OmxzAmeCqqMcAjzmFyTU1FEBhvzLpDGHypBOzdxE9Ptdq2I6gJ2a8nwj1uZA6KuyRNqaotGJgZtDzobExFLg+3K51yxK/16fNkTC0qnO1ys04gcvwVuYrIofstTHIQt2pazavqDW5FBzpmtR2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 7, 2026 at 9:52=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wro=
te:
>
> +cc Vlata, the only one from the MEMORY MAPPING - LOCKING people excluded=
,
> and Willy as he's been heavily involved. But see below you need to cc- wa=
y
> more.
>
> (nitty I know) Maybe subject should be 'mm: default to VMA lock on
> VM_FAULT_RETRY' or something just to make it clear it's about the retry
> path?
>
> Also I guess you and Barry agreed to you taking this over? :)
>
> You missed a million people from cc- by the way. This time I really canno=
t
> be bothered to add them all as I usually do, but it is MANDATORY to cc
> maintainers and really you should be cc'ing reviewers too every time.
>
> Again I feel I need to write a bot that just autoreplies about this :)
>
> $ scripts/get_maintainer.pl --nogit --nogit-fallback your-patch.patch
> <... ~36 people in total ...>
> < lists >
> < etc. >
>
> Please fix this on respin.
>
> On Fri, Jun 26, 2026 at 03:50:19PM +0800, Hongru Zhang wrote:
> > From: Hongru Zhang <zhanghongru@xiaomi.com>
> >
> > Currently, when a page fault returns VM_FAULT_RETRY under the per-VMA
> > lock due to folio_lock() failing, mainly because the folio is under
> > I/O, the architecture fault handler unconditionally falls back to
> > retrying with mmap_lock. This leads to mmap_lock contention.
> >
> > This patch introduces VM_FAULT_RETRY_HARD to mark the paths that
>
> I'm going to have to bikeshed the name :)
>
> While I like the idea of 'retry hard' like the movie 'die hard' :P I thin=
k,
> since this is explicitly about the mmap lock, we should reference that?
>
> So maybe VM_FAULT_RETRY_MMAP?
>
> or VM_FAULT_RETRY_HARDER_WITH_A_VENGEANCE? ;)
>
> > require mmap_lock. Retries now stay under the per-VMA lock by default,
> > and only marked paths fall back to the mmap_lock retry path.
>
> I think the commit message should be much clearer about the logic here.
>
> You are making it such that VM_FAULT_RETRY does its retry pass using a VM=
A
> lock, but it retains the same 'retry and set FAULT_FLAG_TRIED' logic as
> before.
>
> HOWEVER.
>
> On the VMA lock path the retry flag is only set if VM_FAULT_MAJOR. So now
> you're allowing _unbounded_ VMA lock attempts (which is concerning and I
> don't think intended by the lock code).
>
> None of this is clear right now, you need to documment it.
>
> >
> > Based on the stress model from Kunwu Chan and Wang Lian in v2, we
> > adapted a benchmark for a 20-core desktop environment (reduced thread
> > count, adjusted memcg limits, 20-core Intel i7-12700). The benchmark
> > uses concurrent page faults under memcg pressure (forcing reclaim and
> > VM_FAULT_RETRY) with parallel munmap to amplify mmap_lock read-write
> > contention.
> >
> > Throughput (higher is better):
> > +---------+------------+------------+-------------+
> > | Threads |  Vanilla   |  Patched   | Improvement |
> > +---------+------------+------------+-------------+
> > |   40    | 1071.11 /s | 1301.11 /s |   +21.5%    |
> > +---------+------------+------------+-------------+
> > |   60    | 1043.15 /s | 1472.36 /s |   +41.1%    |
> > +---------+------------+------------+-------------+
> > |   80    | 1049.39 /s | 1665.65 /s |   +58.7%    |
> > +---------+------------+------------+-------------+
> >
> > mmap_lock contention count (lower is better):
> > +---------+-----------+---------+-----------+
> > | Threads |  Vanilla  | Patched | Reduction |
> > +---------+-----------+---------+-----------+
> > |   40    | 3,217,904 |  51,201 |  -98.4%   |
> > +---------+-----------+---------+-----------+
> > |   60    | 4,419,149 |  55,711 |  -98.7%   |
> > +---------+-----------+---------+-----------+
> > |   80    | 5,395,730 |  66,184 |  -98.8%   |
> > +---------+-----------+---------+-----------+
>
> Yeah I worry a bit about the unbounded nature of things here, the fact
> we're seeing such a difference could also be offset by extreme busy waiti=
ng
> with the unbounded VMA lock retries.
>
> Let's experiment based on limiting this surely?
>
> >
> > Benchmark and test scripts:
> > https://gist.github.com/zhr250/c36c2c54d9351df37e12fd072d4926ef
> >
> > Suggested-by: Barry Song <baohua@kernel.org>
> > Suggested-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Hongru Zhang <zhanghongru@xiaomi.com>
> > ---
> > Changes since v2:
> > - v2 required each retry path to explicitly opt in to VMA lock retry
> >   (VM_FAULT_RETRY_VMA). This patch inverts the logic: retries default
> >   to VMA lock, and only paths requiring mmap_lock opt out
> >   (VM_FAULT_RETRY_HARD)
> > - This patch corresponds to v2 patch 1/5; the remaining optimizations
> >   will be submitted separately
> > - Rebased on mm-unstable
> >
> > Link to v2:
> > https://lore.kernel.org/all/20260430040427.4672-1-baohua@kernel.org/
> >
> > Link to v1:
> > https://lore.kernel.org/all/20251127011438.6918-1-21cnbao@gmail.com/
>
> Hmm it's a bit odd for you to send an independent series and link to
> somebody else's series as v1/v2 but anyway as long as Barry and you agree
> with that approach that's fine!
>
> >
> >  arch/arm/mm/fault.c       | 4 ++++
> >  arch/arm64/mm/fault.c     | 4 ++++
> >  arch/loongarch/mm/fault.c | 4 ++++
> >  arch/powerpc/mm/fault.c   | 4 ++++
> >  arch/riscv/mm/fault.c     | 4 ++++
> >  arch/s390/mm/fault.c      | 4 ++++
> >  arch/x86/mm/fault.c       | 4 ++++
> >  include/linux/mm_types.h  | 9 +++++----
> >  mm/huge_memory.c          | 2 +-
> >  mm/memory.c               | 6 +++---
> >  10 files changed, 37 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> > index e62cc4be5adf..2f909fb4f7db 100644
> > --- a/arch/arm/mm/fault.c
> > +++ b/arch/arm/mm/fault.c
> > @@ -391,6 +391,7 @@ do_page_fault(unsigned long addr, unsigned int fsr,=
 struct pt_regs *regs)
> >       if (!(flags & FAULT_FLAG_USER))
> >               goto lock_mmap;
> >
> > +retry_vma:
> >       vma =3D lock_vma_under_rcu(mm, addr);
> >       if (!vma)
> >               goto lock_mmap;
> > @@ -420,6 +421,9 @@ do_page_fault(unsigned long addr, unsigned int fsr,=
 struct pt_regs *regs)
> >                       goto no_context;
> >               return 0;
> >       }
>
> OK so this is really important - and it seems to be the case regardless o=
f
> arch.
>
> When VM_FAULT_RETRY is encountered under the VMA lock, we do:
>
>         if (fault & VM_FAULT_MAJOR)
>                 flags |=3D FAULT_FLAG_TRIED;
>
> Which then allows _under the mmap lock_ 2 more retries.
>
> You're now (silently!) going to:
>
>         if (!(fault & VM_FAULT_MAJOR))
>                 /* unbounded infinite VMA lock retries */
>
> This seems very unwise (TM).
>
> We should bound this somehow. A maximum number of retries? Only do the
> minor fault thing once?
>
> Could you benchmark how it looks at different retry counts? We could also
> consider other strategies, but unbounded attempts here seems not good.
>
> Another thing - is there any way to dedupe this code...? We're open codin=
g
> a lot of crap now in each of the arches and it's not good.
>
> A series like this is the place to fix stuff like that, not keep adding t=
o
> the technical debt.
>
> Hongru - could you see if that's possible as preceeding patches please?
>
> > +     if (!(fault & VM_FAULT_RETRY_HARD))
> > +             goto retry_vma;
>
> Maybe it's worth being explicit that this is the VM_FAULT_RETRY path? Oth=
erwise
> it's not so clear.
>
> You happen to only fall through here if VM_FAULT_RETRY is set.
>
> So e.g.:
>
> /**
>  * fault_can_retry_vma_lock() - Are we able to retry a page fault holding
>  * only the VMA lock?
>  * @fault: The fault to check.
>  *
>  * We default to performing the VM_FAULT_RETRY/FAULT_FLAG_TRIED dance und=
er
>  * VMA lock. This allows us to avoid mmap contention on the likely case
>  * that we encountered an ephemeral inability to VMA lock (e.g. the VMA w=
as
>  * write locked at the time).
>  *
>  * Returns: true if we can retry under the VMA lock, false otherwise.
>  */
> static bool fault_can_retry_vma_lock(vm_fault_t fault)
> {
>         VM_WARN_ON_ONCE(!(fault & VM_FAULT_RETRY));
>
>         return fault & VM_FAULT_RETRY_HARD;
> }
>
> And put that somewhere all the arch fault logic can access.
>
> Then:
>
>         if (fault_can_retry_vma_lock(fault))
>                 goto retry_vma;
>
> Is self-documenting, and the assert assures that no mistake was made with
> it.
>
> Same comments for all the arches, obviously.
>
> > +
> >  lock_mmap:
> >
> >  retry:
> > diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> > index 739800835920..695a09486795 100644
> > --- a/arch/arm64/mm/fault.c
> > +++ b/arch/arm64/mm/fault.c
> > @@ -673,6 +673,7 @@ static int __kprobes do_page_fault(unsigned long fa=
r, unsigned long esr,
> >       if (!(mm_flags & FAULT_FLAG_USER))
> >               goto lock_mmap;
> >
> > +retry_vma:
> >       vma =3D lock_vma_under_rcu(mm, addr);
> >       if (!vma)
> >               goto lock_mmap;
> > @@ -719,6 +720,9 @@ static int __kprobes do_page_fault(unsigned long fa=
r, unsigned long esr,
> >                       goto no_context;
> >               return 0;
> >       }
> > +     if (!(fault & VM_FAULT_RETRY_HARD))
> > +             goto retry_vma;
> > +
> >  lock_mmap:
> >
> >  retry:
> > diff --git a/arch/loongarch/mm/fault.c b/arch/loongarch/mm/fault.c
> > index 2c93d33356e5..d7dd55722e52 100644
> > --- a/arch/loongarch/mm/fault.c
> > +++ b/arch/loongarch/mm/fault.c
> > @@ -219,6 +219,7 @@ static void __kprobes __do_page_fault(struct pt_reg=
s *regs,
> >       if (!(flags & FAULT_FLAG_USER))
> >               goto lock_mmap;
> >
> > +retry_vma:
> >       vma =3D lock_vma_under_rcu(mm, address);
> >       if (!vma)
> >               goto lock_mmap;
> > @@ -265,6 +266,9 @@ static void __kprobes __do_page_fault(struct pt_reg=
s *regs,
> >                       no_context(regs, write, address);
> >               return;
> >       }
> > +     if (!(fault & VM_FAULT_RETRY_HARD))
> > +             goto retry_vma;
> > +
> >  lock_mmap:
> >
> >  retry:
> > diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
> > index 806c74e0d5ab..65ec9a8252e7 100644
> > --- a/arch/powerpc/mm/fault.c
> > +++ b/arch/powerpc/mm/fault.c
> > @@ -487,6 +487,7 @@ static int ___do_page_fault(struct pt_regs *regs, u=
nsigned long address,
> >       if (!(flags & FAULT_FLAG_USER))
> >               goto lock_mmap;
> >
> > +retry_vma:
> >       vma =3D lock_vma_under_rcu(mm, address);
> >       if (!vma)
> >               goto lock_mmap;
> > @@ -517,6 +518,9 @@ static int ___do_page_fault(struct pt_regs *regs, u=
nsigned long address,
> >       if (fault_signal_pending(fault, regs))
> >               return user_mode(regs) ? 0 : SIGBUS;
> >
> > +     if (!(fault & VM_FAULT_RETRY_HARD))
> > +             goto retry_vma;
> > +
> >  lock_mmap:
> >
> >       /* When running in the kernel we expect faults to occur only to
> > diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
> > index 04ed6f8acae4..6c68414a1224 100644
> > --- a/arch/riscv/mm/fault.c
> > +++ b/arch/riscv/mm/fault.c
> > @@ -347,6 +347,7 @@ void handle_page_fault(struct pt_regs *regs)
> >       if (!(flags & FAULT_FLAG_USER))
> >               goto lock_mmap;
> >
> > +retry_vma:
> >       vma =3D lock_vma_under_rcu(mm, addr);
> >       if (!vma)
> >               goto lock_mmap;
> > @@ -376,6 +377,9 @@ void handle_page_fault(struct pt_regs *regs)
> >                       no_context(regs, addr);
> >               return;
> >       }
> > +     if (!(fault & VM_FAULT_RETRY_HARD))
> > +             goto retry_vma;
> > +
> >  lock_mmap:
> >
> >  retry:
> > diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> > index 028aeb9c48d6..45a6c35044cc 100644
> > --- a/arch/s390/mm/fault.c
> > +++ b/arch/s390/mm/fault.c
> > @@ -294,6 +294,7 @@ static void do_exception(struct pt_regs *regs, int =
access)
> >               flags |=3D FAULT_FLAG_WRITE;
> >       if (!(flags & FAULT_FLAG_USER))
> >               goto lock_mmap;
> > +retry_vma:
> >       vma =3D lock_vma_under_rcu(mm, address);
> >       if (!vma)
> >               goto lock_mmap;
> > @@ -318,6 +319,9 @@ static void do_exception(struct pt_regs *regs, int =
access)
> >                       handle_fault_error_nolock(regs, 0);
> >               return;
> >       }
> > +     if (!(fault & VM_FAULT_RETRY_HARD))
> > +             goto retry_vma;
> > +
> >  lock_mmap:
> >  retry:
> >       vma =3D lock_mm_and_find_vma(mm, address, regs);
> > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > index 63de8e8684f2..cb80070271d0 100644
> > --- a/arch/x86/mm/fault.c
> > +++ b/arch/x86/mm/fault.c
> > @@ -1322,6 +1322,7 @@ void do_user_addr_fault(struct pt_regs *regs,
> >       if (!(flags & FAULT_FLAG_USER))
> >               goto lock_mmap;
> >
> > +retry_vma:
> >       vma =3D lock_vma_under_rcu(mm, address);
> >       if (!vma)
> >               goto lock_mmap;
> > @@ -1351,6 +1352,9 @@ void do_user_addr_fault(struct pt_regs *regs,
> >                                                ARCH_DEFAULT_PKEY);
> >               return;
> >       }
> > +     if (!(fault & VM_FAULT_RETRY_HARD))
> > +             goto retry_vma;
> > +
> >  lock_mmap:
> >
> >  retry:
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 5ef78617ce93..58db6f0af6fd 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
>
> Please also update the comment block to add the new flag.
>
> > @@ -1665,10 +1665,11 @@ enum vm_fault_reason {
> >       VM_FAULT_NOPAGE         =3D (__force vm_fault_t)0x000100,
> >       VM_FAULT_LOCKED         =3D (__force vm_fault_t)0x000200,
> >       VM_FAULT_RETRY          =3D (__force vm_fault_t)0x000400,
> > -     VM_FAULT_FALLBACK       =3D (__force vm_fault_t)0x000800,
> > -     VM_FAULT_DONE_COW       =3D (__force vm_fault_t)0x001000,
> > -     VM_FAULT_NEEDDSYNC      =3D (__force vm_fault_t)0x002000,
> > -     VM_FAULT_COMPLETED      =3D (__force vm_fault_t)0x004000,
> > +     VM_FAULT_RETRY_HARD     =3D (__force vm_fault_t)0x000800,
> > +     VM_FAULT_FALLBACK       =3D (__force vm_fault_t)0x001000,
> > +     VM_FAULT_DONE_COW       =3D (__force vm_fault_t)0x002000,
> > +     VM_FAULT_NEEDDSYNC      =3D (__force vm_fault_t)0x004000,
> > +     VM_FAULT_COMPLETED      =3D (__force vm_fault_t)0x008000,
>
> Hmm I suppose there's no harm in renumbering here to keep the retries
> together :)
>
> I wonder if we shouldn't invert this VM_FAULT_RETRY | VM_FAULT_RETRY_HARD
> thing though and instead have:
>
> #define VM_FAULT_RETRY_MASK (VM_FAULT_RETRY | VM_FAULT_RETRY_MMAP)
>
> And convert code that checks VM_FAULT_RETRY to check VM_FAULT_RETRY_MASK
> instead, then there'd be no need for an awkward check/or confusion around
> the need for VM_FAULT_RETRY to always be set in both cases.
>
> You're already basically touching all the files that reference
> VM_FAULT_RETRY so it's not actually much more churn.
>
> >       VM_FAULT_HINDEX_MASK    =3D (__force vm_fault_t)0x0f0000,
> >  };
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 94bd656eeaf8..ad0129d579bc 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -1398,7 +1398,7 @@ vm_fault_t do_huge_pmd_device_private(struct vm_f=
ault *vmf)
> >
> >       if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
> >               vma_end_read(vma);
> > -             return VM_FAULT_RETRY;
> > +             return VM_FAULT_RETRY | VM_FAULT_RETRY_HARD;
>
> Why are we specifically wanting this for PMD device private entries?
>
> You should add a comment, and the commit message should say why.
>
> Actually, maybe in this common case of vmf->flags & FAULT_FLAG_VMA_LOCK -=
>
> harder you can make a helper?
>
> Like:
>
> /** blahhhh some kdoc comment */
> static vm_fault_t retry_under_mmap_if_vma_locked(struct vm_fault *vmf)
> {
>         if (!(vmf->flags & FAULT_FLAG_VMA_LOCK))
>                 return 0;
>
>         vma_end_read(vma);
>         return VM_FAULT_RETRY | VM_FAULT_RETRY_HARD;
> }
>
> And:
>
>         vm_fault_t ret;
>
>         ret =3D retry_under_mmap_if_vma_locked(vmf);
>         if (ret)
>                 return ret;
>
> Or something like this.
>
> >       }
> >
> >       ptl =3D pmd_lock(vma->vm_mm, vmf->pmd);
> > diff --git a/mm/memory.c b/mm/memory.c
> > index ff338c2abe92..7f2a30b5efca 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -3797,7 +3797,7 @@ static inline vm_fault_t vmf_can_call_fault(const=
 struct vm_fault *vmf)
> >       if (vma->vm_ops->map_pages || !(vmf->flags & FAULT_FLAG_VMA_LOCK)=
)
> >               return 0;
> >       vma_end_read(vma);
> > -     return VM_FAULT_RETRY;
> > +     return VM_FAULT_RETRY | VM_FAULT_RETRY_HARD;
>
> You could use my helper like above.
>
> >  }
> >
> >  /**
> > @@ -3824,7 +3824,7 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vm=
f)
> >               return 0;
> >       if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
> >               if (!mmap_read_trylock(vma->vm_mm))
> > -                     return VM_FAULT_RETRY;
> > +                     return VM_FAULT_RETRY | VM_FAULT_RETRY_HARD;
>
> This really makes me think VM_FAULT_RETRY_MMAP or something explicit woul=
d
> be better, otherwise you have to add a comment explaining you're doing th=
is
> because you need the mmap read lock here since the VMA lock + speculative
> mmap read lock acquisition didn't work out.
>
> >       }
> >       if (__anon_vma_prepare(vma))
> >               ret =3D VM_FAULT_OOM;
> > @@ -4778,7 +4778,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >                                * under VMA lock.
> >                                */
> >                               vma_end_read(vma);
> > -                             ret =3D VM_FAULT_RETRY;
> > +                             ret =3D VM_FAULT_RETRY | VM_FAULT_RETRY_H=
ARD;
>
> Again, helper above self-documents.
>
> >                               goto out;
> >                       }
> >
> >
> > base-commit: 81652c5a65d4ae28e9b18c16ef917a40025c3653
> > --
> > 2.43.0
> >
>
> Have you audited every single VM_FAULT_RETRY case? Because getting this
> wrong could be a serious problem and break things. You should include a
> list of call sites in your patch and explain why it's fine in each case.

That's my main worry with this patch as well. I think a better
approach would keep VM_FAULT_RETRY as is (falling back to mmap_lock),
introduce VM_FAULT_RETRY_VMA (or whatever is best to indicate a retry
with VMA lock) and then convert individual VM_FAULT_RETRY cases to
VM_FAULT_RETRY_VMA with proper reasoning and explanation why it is
safe. Less churn, gradual conversion, and happy reviewers.

>
> One case I noticed is uffd:
>
>         ret =3D VM_FAULT_RETRY;
>         ...
>         if (unlikely(READ_ONCE(ctx->released))) {
>                 /*
>                  * If a concurrent release is detected, do not return
>                  * VM_FAULT_SIGBUS or VM_FAULT_NOPAGE, but instead always
>                  * return VM_FAULT_RETRY with lock released proactively.
> .       ...
>                  * If we were to return VM_FAULT_NOPAGE, it would work fo=
r
>                  * the fault path, in which the lock will be released
>                  * later.  However for GUP, faultin_page() does nothing
>                  * special on NOPAGE, so GUP would spin retrying without
>                  * releasing the mmap read lock, causing possible liveloc=
k.
>                  *
>                  * Here only VM_FAULT_RETRY would make sure the mmap lock
>                  * be released immediately, so that the thread concurrent=
ly
>                  * releasing the userfault would always make progress.
>                  */
>                  release_fault_lock(vmf);
>                  goto out;
>         }
>
> The comment needs updating (Suren?) to reflect the VMA lock, basically wi=
th
> VMA lock held this is meaningless.

Right, I missed it when enabling per-VMA locks for userfaultfd faults
in [1]. The comment is true if we already fell back to mmap_lock but
not if we are handling the fault under VMA lock. I should amend it.

[1] https://lore.kernel.org/all/20230630211957.1341547-1-surenb@google.com/

>
> We're actually safe here in general as if the VMA lock is contended on a
> competing write lock we drop to mmap lock.
>
> A racing uffd release thread does an unconditional vma_start_write()
> _after_ setting ctx->released:
>
> static int userfaultfd_release(struct inode *inode, struct file *file)
> {
>         ...
>         WRITE_ONCE(ctx->released, true);
>         userfaultfd_release_all(mm, ctx);
>         ...
> }
>
> userfaultfd_release_all()
> <mmap write lock>
> -> userfaultfd_clear_vma()
> -> vma_modify_flags_uffd()
> -> vma_modify()
> -> vma_merge_existing_range()   -> vma_start_write() LIVELOCK
> OR split_vma() -> __split_vma() -> vma_start_write() LIVELOCK
>
> So yeah, not sure on this one, maybe we're fine just to use VMA lock stil=
l?
>
> Suren - any thoughts?

If we retry without falling back to mmap_lock then
userfaultfd_release() can end up write-locking mmap_lock but losing
the race for VMA lock to the retrying pagefault handler. This means it
would block while holding mmap_lock for write - not good.
With pagefault handler falling back to mmap_lock, either
userfaultfd_release() wins the race for mmap_lock or pagefault
handler, so I think we are safe.

>
> You definitely need to explain your reasoning in the commit message at
> least.
>
> Also commit 29a22b9e08d7 ("mm: handle userfaults under VMA lock") did fai=
l
> to update this comment to reflect VMA locks - we should fix that too -
> Suren? :)

Yes, I will correct my mistake and send a small fixup.

>
>
> Also another thought - should we allow FAULT_FLAG_RETRY_NOWAIT to retry
> with the VMA lock? As this could also be some unbounded spinning? But the=
n
> again, if we bound the spinning that might be ok.

Hmm. If we do that, let's make it a separate series. Too many moving
parts is never a good idea.

>
> Thanks, Lorenzo

