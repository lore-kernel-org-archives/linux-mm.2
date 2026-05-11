Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07B59CD37B2
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69A286B00E5; Mon, 11 May 2026 11:41:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A6E6B00E6; Mon, 11 May 2026 11:41:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539456B00E7; Mon, 11 May 2026 11:41:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 429996B00E5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:41:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E8FD71C02FF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:41:04 +0000 (UTC)
X-FDA: 84755552448.03.E4E300D
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id DEAE01C0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:41:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mndghXp0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of jannh@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778514063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ufOOEfTlvP04cNgy2oV7GSg0scHY29TiT5FrCMkncRQ=;
	b=74APvQmcMgX5mwoHYk3v5zNy+ARhqiTeIbSNSeo9VZTVbKluZo7X90Zc46DgjW0VpDeuie
	zWqMCCmG9Kl8c6SYPqO6kHr39konm2YJ0RdmwUn5RacaBYLsjtGnvpLfAuIjKYhqXhJj6I
	BP0zPeCYZOjSvP/1PUTh9rnxXuQzhqI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778514063; a=rsa-sha256;
	cv=pass;
	b=LBYWRP1Z76JCTUDGVImqbZNjGPfUDonRzzI3fH459Tti/r08U7J6ApICvbYgU1UK5x0Ijm
	sgFqDOSITK1KPOn0YrjEsX/iX3ZVMQQGaIDPpKUhWBakQ++GikB49Rn9ukcgmE9Xy9bOTs
	CNQasgKuJLr2AMqSXPgeO0hisXNO7sk=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mndghXp0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of jannh@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-671588ab0cfso179a12.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 08:41:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778514061; cv=none;
        d=google.com; s=arc-20240605;
        b=LTO+8vx2tsrnnAjk5wmYXgJ0HFzgxJSP2GjRjReDFL46OIMUKYX+PpwbURJpMfIxy4
         npha/AkN/2sysPlYV2GQCLIFNXYfJWuNj6FxV0rZfMCWYU2aqgovRi18I978Ddms7srS
         NXOauCe5jAatMbI/5ICxii0Xtuv97PyW3Jfuk9eljsquOOj7TEkHwYsFXfyWuX6O2QrC
         F0sTm5ePqkkAjAS9BPvlet0PWLlwIi45WnwMTk6hQwUuDIaFMK3/iK5RQoinkwA5wJt2
         /mZumRf2Hby9QZVG31+EG7xNQS78IZzDCkPg0tKSpx07rLEDqjYwgZkxnRNw7kBWFdbw
         CzwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ufOOEfTlvP04cNgy2oV7GSg0scHY29TiT5FrCMkncRQ=;
        fh=HB1LxqXxNdqB0ew1TWqBKkoBylE+BiEPUbBZ5ECH60g=;
        b=Qx5P6n639c6Dyfc7AaWNXfsCe/NVbwDfLKL7piIckSu8bmu+M0fNaqxXI0rWjSteSP
         FlibZVkr8gawdVG83cVQiWrEFf74oO7mURQCCNGj2FZNsn+VnOWWnz7xAuvSqD+SJWZ+
         S/8vxpO8C5wW9kOU2k8rNeJXZbK7qfrWSwNpPohxJecuKwzQIAAHayjrwUaV6dkm72Rb
         9UPZN00ozebE7Jia3RVoQee45iFx/dNOXdCEl/BGbvnRQmOMJESsli7JVxji82pSUzy/
         i3GYrxj0MXm6q53gKX4lbKWwYAYtJhfi8PMzCTHLXq4C690KIigj68RBRJvNK63RpVMI
         tBkg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778514061; x=1779118861; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ufOOEfTlvP04cNgy2oV7GSg0scHY29TiT5FrCMkncRQ=;
        b=mndghXp0nxym//bNkOttZFi7jgDfW858rv11nEW6rYYxJZEFCYdO6M2wdysD/f5kvv
         BS1q9DB3+x52glOxBHwqSqqFxRT/ZHSAAfo/P9LN1floOH9MLCouXILOqFSDwsEAIRgI
         S4698fgQnz/elwMP5/dQR06qHdhCC+d+WEXIyC2l7WWkgYJ55U08UdYvnITeutmsDKAa
         D7PDOyuCo8NbgCAK9dGkTtIYISKc5iCXMovwUEFsLDtZLIhDlNJArrhlG7QmgF733JRF
         qo+UCjf+SH3+KW0j+Fgq7NQslEDF9kZS0mJrbrZdo+VKDLLYVgPTost+RfDqNcP4epke
         BG1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778514061; x=1779118861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ufOOEfTlvP04cNgy2oV7GSg0scHY29TiT5FrCMkncRQ=;
        b=BDXcLEHgJ73lP2FOMKTWAh3CH4Cy9d/L+g2hL9sO2W0k/TUx0J7BrcWQlnRceVb3rK
         lp25NFy0re+3A/I1Xq87i9RLTRtQkhdvmP+fZ7X8VMlk+s+L75bkPRKnizgowZKKi9bd
         eILcTVf0nVfspa1ErHkdAM1FruWKUWGsO1RFlyaADTSrgn+7+fqS/bTA1CVeZ+Um3kwx
         niT9pYH9uqoblFA7ldyZJbWQp0TxtihqqUdMbZAV/IQsfQnFtQfOyNs0Hm3JmWG+noaj
         le+CkGYLcQEzP6bB78dZXTeyIOWeztkskC5biVFPacnBinlKYSe0EbvlL4LP33FPBdcy
         Tg1A==
X-Forwarded-Encrypted: i=1; AFNElJ9WyNKgUHpoiMjw5LWy99H+FvjkgZHF4mCrwp0strJ3vHxFDcxcom1EbhV1npr5zLarUjl3zWlHgw==@kvack.org
X-Gm-Message-State: AOJu0YzLFgZ9sLi6/jVM9tCv2s3e0RX+CG8cV9BiwUCJD4ajB9/sI5Yz
	YphteB9NpEgX+WZXVbFVkp47kqg4hlQmePe0kFS4OBzTAc8y0MhRgr/yyX+X5augsvRboNCSzpo
	37B4YeisqW+O7v2kfKfpbDMgLRithh6JGA4RQMLNw
X-Gm-Gg: Acq92OGoQweHcJRKOLmVDMxGyydb6lRtkyvz4nn/q99LUfjVZT/OBymWnpa+XSjCk5b
	DkWMUPLSKSiEYZ83ggBiu5XsMZbe3HZ4CpGavbdCWmNAs0NTxbRtDFp6YAFQt/tK+FOYSAAttre
	ZrejY1zDVgVyWr5YDXmSge2CwFmD1Xw159AiJzQ4nFlQOYKPAihIJ4e3RycdmNPQli9rWZkhDoa
	1A7kD56BLRJz7Qz1okFq2R2FfxXIUJQi00T0iR54lgYji+YgzCJDBg4iwZq7BUNtZNmZ2asy027
	gH1UfIkNmwt6XfCEZTSAB2UQbheWIexp2WtcE9QfAkKTysB/
X-Received: by 2002:a05:6402:614:b0:670:2007:668c with SMTP id
 4fb4d7f45d1cf-67f59b78c3dmr88770a12.4.1778514060584; Mon, 11 May 2026
 08:41:00 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_863C8A01F3C81EBA238F375B16065CBACF08@qq.com>
 <agHmO4i4YUhs3cSG@lucifer> <CAG48ez1sLtSKVQLHbLO5usBgMgjyOGhbX29pKEfku4Ht05HffA@mail.gmail.com>
 <agH1ZSdX_7QF8P_I@lucifer>
In-Reply-To: <agH1ZSdX_7QF8P_I@lucifer>
From: Jann Horn <jannh@google.com>
Date: Mon, 11 May 2026 17:40:24 +0200
X-Gm-Features: AVHnY4JxEXoj7n_mRqXAKWqPwktvE7KbhSXwMMRM-MFeHT-iUzf-b5d6qJOEOUg
Message-ID: <CAG48ez17evhhcoDKF6AoPqzYZwGuFCkVAsc-0bBzevf0LHYNxA@mail.gmail.com>
Subject: Re: [PATCH] mm/mremap: unmap full fixed target for multi-VMA moves
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: fujunjie <fujunjie1@qq.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DEAE01C0005
X-Stat-Signature: a411j1fahuzem739zwwor6yjtx7z8qsk
X-Rspam-User: 
X-HE-Tag: 1778514062-566063
X-HE-Meta: U2FsdGVkX1+fo7Q7sDVSCAH/pKVK6QU36wjt7kFjDeLhw6EwLu2yhnycNWSbYda7iwuhzI0F0Yl63Dg6SR3NRsexE9xlSIhdZjSTHUduKcBDVqkPpLZpL0kbKIQBBiCgNo21zWAr1uIVI82sHWYdUB+G3MV9CNCxsjLYZnAMhcIH7yRzRnuadwr11gGeC5yNoiHnQUZDFqFjUrW5CK93L/4W/aTQLZJ5c883OAs/NcjEIe1G2y1U+YCO8smeavQfbp1ECi9oGldYRSAn3MT2KFOdR5qLhUwk9g2kbc3R+Wm6lkNpxgEHJCnWGOsXOAmxQOEEfrgqLrIa5W9xa4/ko3ZdILDuo88yE92IuwMb8S+BIukPZiU96k1Pc6LDFoU1UQpZW/zBrrgbmON2oXrWMk9fLE3KwTyjxlopzMkHACs01dLvu1aJecNNPFKFJiiEOvtWDkamaz05ni0mPGQ38/fmpQZnvo5tiJcv9O/kXa16RLAbmjHTgqQs/MQGMRxaS2boqUFsdECkKFq0L485mWZsRtIyEGmhcZqgDmJMvqzTxHzuApcaQbX7080C/k17DqmNaAjt/6mW8ZZalg+CJ8HmxODkDLritUOpFDN/HXJtAcUCHdlMdOUwHGI0tWefGlUv51hVOfPEznksMlQHCjM+R2TwBNQGpVKB31NwNAzDfAXUWycs4Cnr3Gkyw0Ry8ot2HFz1xIQgkgAx9E2TM4FnvsIS5F/MUB6aLxpWYTjPADcPFPPvV39h1KRzwKeyu8DOmI9joz0StN3moqhC3ZP8s0xav/Zmq9REz6haZJ1/nIVhWdi5WqkK7tQRmtkZv3zQAPNLdthiHvNtv/oEjikMoyBbXUDfv8+Gv7vzXg4bbXrA/fCj9+J9cuJd2c3Wik+Z2gtYcFibUMWZNpCWBhcNoySLh/KfpVsu5SRgFnhe6X2/TTxa+COszRJEPjynoW5ueXKJz2hFY1vq0eZ
 3mtOJZRQ
 Sog3G/GY+kA8eCtwVharuPwIa29pUZlGvTrB9TrlJ+/exrRx7rucPb4kczRbWF+Ef0ZDj0Hao9fHAjqTYHHM+hjAGM2MYmdveV9lRW3kVeOsW+AMC8TSN4QdSXW15Ho2eu2myY2Q4/tlwhtDsaKn74dGOad/zvys1lkCWseG0Wp4JXydRHQLFbCdIwMgZbD7rLxrSfDh3ClmRigayr4F5bRnzgmjnlWg4A76Fr6Nt+jgD7kSO3ikZMeeHDgmi418r2G9I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 5:32=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
> On Mon, May 11, 2026 at 05:19:50PM +0200, Jann Horn wrote:
> > On Mon, May 11, 2026 at 5:05=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org=
> wrote:
> > > Hmmm I think it's a bit debateable honestly. The ability to handle th=
ere being
> > > gaps is a _new thing_, so there are no semantics to speak of. Prevoiu=
sly
> > > mremap() simply required that you only span across a single VMA.
> >
> > FWIW, I think mremap() on a source region with gaps is such a
> > hazardous operation that nearly no userspace code should be doing it -
> > gaps are areas in which any mmap() call without a fixed address could
> > place unrelated mappings (unless stack VMAs are involved, which would
> > also be a weird scenario), so to use it safely, you have to, among
> > other things, make sure not to use libc malloc() at a time when that
> > could place an allocation in the gap (which means you also can't use
> > printf(), and so on, unless you have swapped out the memory
> > allocator), and make sure that you have no other threads that could be
> > doing that, and so on. There are rare circumstances under which it
> > could be safe, but I think it is almost always better to have a
> > PROT_NONE anonymous VMA or such as a placeholder.
>
> Well, we're holding the mmap write lock so none of that could happen
> _during_ the operation right?

Not during the operation, but right before the operation. So from the
userspace perspective, you have to know that there are no concurrent
threads that could be creating memory mappings at non-fixed addresses,
and you have to know that no mappings can have been created in the
memory range between when you checked that it's empty and when you
make the syscall.

> You might debate also the fact we hold that for an extended period.

Eh, I mean, that's also true if you call mmap() with MAP_FIXED on a
gigantic virtual address region with lots of populated PTEs in it or
such, or if you call mprotect() on a big region. I don't think it is
problematic that there are some very chonky MM syscalls you can make
that will hold the mmap_lock for a long time, as long as we don't
expect heavily multithreaded code to be doing those operations
frequently. (Being able to keep the mmap lock held in write mode for a
long time can be useful as an exploitation trick in some cases, but I
don't think that's easy enough to fix to be worth the trouble of
addressing it.)

> Honestly I probably shouldn't have allowed for this, I've had to do at
> least one fixup relating to it I seem to recall and the semantics are
> _clearly_ confusing.
>
> >
> > I think the right documentation for this is "do not use this on a
> > source region with gaps, it is technically possible but extremely
> > hazardous".
>
> Yeah, I mean on reflection, allowing it was probably a mistake.
>
> The real use case was 'my VMAs are fragmented and I don't want to have to
> know about VMA merge rules in order to move them', i.e. no gaps.
>
> I will do a manpage update and indicate that it probably shouldn't be use=
d
> but if it is, the sematics are such that gaps are not propagated (i.e. it
> is as if you mremap()'d each individually).

Thanks!

