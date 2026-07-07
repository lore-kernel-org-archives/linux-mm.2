Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEAD0C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E62296B00A7; Tue,  7 Jul 2026 15:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39B16B00B6; Tue,  7 Jul 2026 15:49:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D76AE6B00B7; Tue,  7 Jul 2026 15:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE5D86B00A7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:49:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44E0F1C8286
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:49:32 +0000 (UTC)
X-FDA: 84963020184.13.F07BCC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7A8B7A000C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:49:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SPFiXLkd;
	spf=pass (imf15.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qPvrbgBN5NOaJkwHcD5c8gYXF6Lb12qAhlcePlGcS6s=;
	b=r4g69BRZGiMzjUZUjE6lxOGACzYqcqNQaBEF7LITpmmNxzmBOFKA+VUrOll6OlKQ9z/EsI
	RV2sfGNGGS+o8DMkx6Negpl3iGnMOgS1WTWWMz+j0TkOSxD/FjWSQv51PeGpi9o/vnsifd
	MLAGqD5mjvcDTwp2EROR6T5IxA7x1VU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783453770;
	b=F/byog1GTv7H7UyhzSEqIqmfm9R7gLeemLpCcyQ4qppIMMYG3rDH6W7qnOlED6oiKZVLgl
	HBs1jjfoouftkrwmRslW5f5xEs3es9T/j4h7Vw49Z28rmfkI+NMaHglhHJbACEB5uidsvS
	sl/ZElsXG6cO09ABbKSMXwcmeAtgoEg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SPFiXLkd;
	spf=pass (imf15.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BAE9601ED
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73731F00A3A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783453769;
	bh=qPvrbgBN5NOaJkwHcD5c8gYXF6Lb12qAhlcePlGcS6s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SPFiXLkdIaqZoCwSDNao4R7bY5RWhqbOfPAF5cezml+SxMM+ps59NLY7lQUIcdZ2o
	 GY2KFk1Po4K/TG0Nsle7xKvt5QKJM7yK5OG5hGnK6FeaEV2JwNE9a0eWd/iuUtuapl
	 TsqgPc2ALZsOygxAYr7q4Wl8OyUdz3hGgbs9F9FxctVydsvY9hVhjEGgHqF26t8evl
	 svGovJIrfzS65K2ziYX9ufQRvy8xAi/Jm1Qxdyi+CECv7hvC8xxRFJQReIIOYcUChn
	 qEZIX2DYtkBDp79OUIILEUc/tAyn1g4hbIMWgaReKRsQri+s3WQfda/pB4xaMdYNvW
	 PsTJPrAh0Waow==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-697de23bd7dso5650301a12.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 12:49:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq66e9S09pP2U4mQ47PbEzP6x/26FE2iZg7vhnIoduci+H3m/PyON6kdI6pdllGtWTsazJgAconOg==@kvack.org
X-Gm-Message-State: AOJu0YxEh475PIDjPSEMJwVVwtjV981e1eeRqko2ZcRlwJwegSxXGEC8
	dnpEuekddQJTMMEK9ONlIjC6RnR3084yCkWdBJvNaZHxI8s4e6dtulcsrHoDTrLnYR+2dO5vcT6
	EeVUT7YFDSwhdKb8RnRyABgvvciSGV60=
X-Received: by 2002:a17:906:18aa:b0:c0b:e9c1:93a7 with SMTP id
 a640c23a62f3a-c15a68a1b6dmr281344366b.29.1783453768674; Tue, 07 Jul 2026
 12:49:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260707073215.72183-1-baoquan.he@linux.dev> <CAKEwX=OuikFwr-miW+HKfnk6djMU8ehiTQPnfchFCyVcfefDLg@mail.gmail.com>
In-Reply-To: <CAKEwX=OuikFwr-miW+HKfnk6djMU8ehiTQPnfchFCyVcfefDLg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 7 Jul 2026 12:49:17 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO-RwWH8Xuub48FD6i+o0GSiwEkmWtyY9TfhF1gNx51Bw@mail.gmail.com>
X-Gm-Features: AVVi8Cd-VVaoZaih6o7sudxZ7fUdfDEt8MgJQ6KSyoYBThoAlcgT3PXapgpkgpE
Message-ID: <CAO9r8zO-RwWH8Xuub48FD6i+o0GSiwEkmWtyY9TfhF1gNx51Bw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] mm: store zswap entries in swap table (Pointer entry)
To: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, chengming.zhou@linux.dev, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7A8B7A000C
X-Stat-Signature: bdkiuimyzem19qad54jk61mw5k7rtjtr
X-HE-Tag: 1783453770-120442
X-HE-Meta: U2FsdGVkX185Qi89mm9OcOWaNywKNIFeH2TfrDH5s/iGkcUFD3S+KtNSDZ5cXKZ+xHjf+5Q2/uXkMf7k/fQSJkz7EDzy9AJUYBQ6xKUGjLCucKhTFL9obbVX/d9mQhKmo9csLSLHd8oKbtr7JdbL/27ovu8EE2vgUS9rqvJxf0/MEEsq4+4KCm7Cw+LXGINwQlkqYiZw+QORD3+y5/oxw0YxJ3quuLOlvt/iaRM+XhhkgOJcFsQlLGC5IViBS9HEr12SXFYtWKuiaAgbex9zEnyzGINW3kYxe7t7TYDgOxuWUxkXpYIyz/16kvRvrX3dkQPH2kb4R9+l+pKyNo4BQF5BhOOF+NGUd8pt7dyvXwlITH86OnRkwmN4HZ6nZkERS4fNx4w0Mk9XoW/4kmpFMkHCGTEux3poprCEpcTDhFLWbN62er0El3JXIasFHNHw17l0Z2CA3GBEAK9O2lGDZntclqjsm5rexEX6ogjE9STScnCzhJftHyJ3EmLQ7gOdq7TdNzGm1FeJ9KHx2QHpzMur2a/i7BCxy0O8GwYDgDqvFF76N8t8qIaKgHjUe8s7X2gq9GSaLS0rxgSW1jN84vJsWXj+bmeC1t5f51epUCBn1dzuqmMhvhf6IdL8+uvN9hTclVpTXubCqkO6YQO63Si0I4KJOh7WjX05v3ElmVd8UBkQ+TeHjCtCr2jHzXLp4778jE8N9cVM2FpuiKfn/T+5BlcAsPqTTZkKBH+YppkA/Z+1dcTNsuj3jZCP5VqCJeawOjDQjHzzn54Vhd1XAwUhkvTNMEcddOhj2x3mXkx+Pxo+iXMclWLRSHkR4RlDYFge/reW0TPb4gVxryvn3QVxiqz5qj6CE9KLJtl8s50b+fOVsByCGj0p7lYkC6CUCwBpXXMBgJRP6MDDvg99b7CKzKZturB62pfGqLm0QJSz8phVcXnMIL+0RusZt2cX7eViLsJmxIViK2CpcY/
 RI6t57LM
 CkTMKJYWl/VSJ6pfOxe7iUZ3uxJ7rU1QkASQn97ovBpjSw//VHwPIUe2qG3ncLqRT901Ei4q4KY1dgEtlYxqb+fPbV/2xgN2ZDUkTuByuPi2erbTo+Z30bWAwxgt1+gi4TNkpI4IsPdpN/czL+aJYpt2vORIz4bQ8ZbUH+Zcsjah6AJnAVktomQGfnaLeD4LEL9Au3lq1K3uz+01VifMlC3xd2I0fp3vKfU0xnCAtlus9IhsKObcJwo/wNUC7BjJAs0IHqCoEbbqwe1WQt3DHu/FBBqjzgjaeAcSXR/MMTFZ2d9QSwxTifflZNfE/YJo1g0256+p5Oe3/h5g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 7, 2026 at 12:28=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Tue, Jul 7, 2026 at 12:32=E2=80=AFAM Baoquan He <baoquan.he@linux.dev>=
 wrote:
> >
> > Currently zswap uses a per-swap-device xarray to map swap offsets to
> > zswap_entry pointers. This introduces an additional tree walk on every
> > zswap entry access.
> >
> > This series replaces the xarray with a "Pointer" entry type stored
> > directly in the swap cluster table. The new swp_tb_t variant embeds
> > a zswap_entry pointer plus a entry count, eliminating the xarray and
> > its lookup overhead entirely.
> >
>
> Have you had the chance to review the virtual swap work (latest
> version in [1])? At a first glance, it bears a lot of similarity to
> this.
>
> We're envisioning this to be the future architecture for zswap :) Is
> there anything that is missing that would satisfy your use case too?
>
> [1]: https://lore.kernel.org/all/20260612193738.2183968-1-nphamcs@gmail.c=
om/

Yeah this doubles down on the dependency of zswap on a swapfile being
present, but I guess the goal is for this to be complimented by your
other series to add ghost swapfile support. This was discussed at
length, and we don't really want to have a user-facing ghost/virtual
swapfile concept, at least not for now. Nhat's latest proposal is
essentially a ghost/virtual swapfile implementation that is
transparent to userspace, AFAICT.

As Nhat mentioned, if there are deficiencies in his proposal that are
addressed by yours, I think the most productive way forward is to
start a discussion (here or on Nhat's proposal) to figure out the best
way forward for everyone.

