Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ECF1CCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 19:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6478A8E001B; Sat,  1 Nov 2025 15:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61F728E0015; Sat,  1 Nov 2025 15:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C5C8E001B; Sat,  1 Nov 2025 15:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 424B88E0015
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 15:12:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE2921A03E5
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 19:12:58 +0000 (UTC)
X-FDA: 84062985636.22.330F809
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0272C18000F
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 19:12:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sg3P/247";
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762024377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zpm1mESM3/oA5bThlDFirqG8Q0DiFOKq9b3r3tGgUWU=;
	b=GRrBraSmMjR96iUhVaheT5a7Afbb9fmrds2uP5c3UfiaNwC2t07p6beYKKCLU15kaAee6H
	tmHhJOXIyRgDGtwcdkM3cP0cpVkxdki+X4LK7SKs7K3ZbHh7PfnyxnEOa/4NyuYC515l3r
	E0/8H7IqEFHqKATWwkR4rKNx379BU6I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sg3P/247";
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762024377; a=rsa-sha256;
	cv=none;
	b=7aAguanxnjXREjzq5phFBaVEUFiJo6EPg4pJl7ND6fHBqU0jvp53GTFkg3SwvE/vQz/MvB
	zLPO1wV5BXv+vu9+TXPBtEGZ2jftz21n6RMgH1OiBqWcZNoULe6FVqfy6t9tEZR0BJsPpl
	dDl2q7P32Q+1nXfK5FabJBlWa9hbRwM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E23C601FF
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 19:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6267C116C6
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 19:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762024375;
	bh=VtMrJvAEomhT9hGcgHveYpITdp1VB+e2RMoVqAhOaUQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sg3P/247bkXFcbeYk2tS94WeLZcSbqnBXAnmI4tf8tuQsWEDfSG/HOYrkknUgC+yw
	 Hj0dxCxg1+ztvk7rOMo7uR3VLRlfvR/0kSGxIBSVJ05qTK1duBiF+WBNlamvWkv+Nd
	 Q5atdogBJm1j2U1kD7kIUdDal1Nmfk70J8LIPUFL+TcM0hRRa2fQiNIuwdJdFi/pja
	 M+EkrvlPlI3j1syGJ5FcxQQQCyd6sg/zqhWv+I79RA7DwFW8j+YZ1kVaxbUD/5RqNn
	 gnpiOAZTlXYkgIh/RHD9QhYrehhD7V4WtxnMTwrNtoSW02PCwXkJONSPyJ20vs7PJR
	 bFJ56r2cJX92Q==
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-786572c14e3so13225547b3.2
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 12:12:55 -0700 (PDT)
X-Gm-Message-State: AOJu0YxeZ/KzMHVBxX5z4AEUv9F/paaiGchvYKbWc2lPtQu/DfP8XE1Z
	aJZuyXGolYDc5j8jFgpP/1xzYSIfsnYyRY4D9t5Nkg5hfnLMfnYd/MKHaV7AbwsSBeCGLVl2O8D
	QmIhMDC6BU6qLE0/MWz3O+FTHXDcwO/skIvf7aYBNAg==
X-Google-Smtp-Source: AGHT+IH0HZ1QTTyDOzoxc0ks5C1nssC/fgZ/u8kSK0n0raMAiGgRlyScUcmLqwRgIISaE/371wR0Ijbo/LyRoWq3GMQ=
X-Received: by 2002:a05:690c:ec2:b0:781:177f:9dd6 with SMTP id
 00721157ae682-78648528901mr74876387b3.52.1762024374920; Sat, 01 Nov 2025
 12:12:54 -0700 (PDT)
MIME-Version: 1.0
References: <20251101134158.69908-1-youngjun.park@lge.com>
In-Reply-To: <20251101134158.69908-1-youngjun.park@lge.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 1 Nov 2025 12:12:44 -0700
X-Gmail-Original-Message-ID: <CACePvbV=Br5yiaXOdyC43Dz+6eUV6GfyxqCsGPG0e6kggT84ig@mail.gmail.com>
X-Gm-Features: AWmQ_bmXVOd_FFWvXDjxJz8x_VF0n4gvcjXVG229dcG8BP-OEDJSM1ekUyB1OZ8
Message-ID: <CACePvbV=Br5yiaXOdyC43Dz+6eUV6GfyxqCsGPG0e6kggT84ig@mail.gmail.com>
Subject: Re: [PATCH] mm: swap: remove duplicate nr_swap_pages decrement in get_swap_page_of_type()
To: Youngjun Park <youngjun.park@lge.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: md4npqifpr8y9amjbj7piq4firorngob
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0272C18000F
X-HE-Tag: 1762024376-398544
X-HE-Meta: U2FsdGVkX19f0MzvbRkEo5YZyXt/b6/VVV6IAypHjDOtGSB8no8BnKl1mKSFji1ID5AnxlQoJrkhelkeVRbldalJZd9cyvpuiWgKcUIL1M6EzNXjvf+guL20P81dcvyVLhDZMV9BKzk0WKJd7Yqhs4IULmth2cYnhgc4GY5SKPNO6iEJAB0e9EnKTYQWqeP7cQg6wXA5xO0QjSfyrWeElYiUN7yzFyeK785nHD/5aOuu5HrrczzciN+2LXCgOxN+8R1XYPeZIMbapVekBrRNBv1NBbLJ7loDZ7H3lk5lAwXGDrGhPv9op2msIjYJ0E6Vfm2GDQ3j3a1NSwt14hSey7u6B5jgrIw8jkYUhKHiC+Mr04NwUenIfRk6DUws+r+FScsjRtiu1Zk8ugdnCrelJcMlf0oNM58NcUKqQ2Lu5n3tDKODKSvLbyVMZ8dDHwy7EFg0CRnsrqxHoFL4DRaALwp+RN4AGec+ysZfJoZ5L6/6ZyCGf2S9OUyVZLp0t1N9iDMwW/2KvFiq27xwF1JrAENct9WGss/v1m1QZhtukRELHTl+MxXbWtpwIfbr//cWWzQXAVdbPKqay+vDXtfD35BroJXsz7eYmbCHFMBKpL05MJ7knpmckZ7EdU0BVsBa34iruD4vbYkYhkYUTBI1mMfw8LQXnutzGXAMBS/fEMArrENQxyhGN8ZXl7bMlwBPOwiDfO10oJhFNNsM1nfOBx6FedlomIIgE78CzoyPeaZ6bRl2wSlnNOUH6mCCdX2X3IGwcqownjmfIwlIvjYBI/LhV+/HYJWBgjqtW6/bM877ID8z/cE2wflEZULsEqfj5r3K0FU1sk/gq0LfPJhceiim+T7o3y09pufuHcpn7fyalCHq7m7xbY6Hr1dYh/PBepqkaDHqUS+onn4d0LT/ggSHzkgeK6JJs2/FZ97slIje2J4FMQEVFKUlcTwSa8TU+mfk9lwlvcYpat2Ktev
 lOaeP1l3
 pokNvAHElXATVHMZAuszKDR+XRsUO0Qsk9ZP561u9r078KAHLiAXOQtCjaI2e3cK24hESc1PzJ+SaHKs3risCDh+HY3jpG+yoxbbKxNGGyiVWIfRQsoJ9IoV2TV7oApEQD4eTBqCMapCgRQWb62X+83gjS622qQAhVzERxCn5/r6Lq1Y8HHKIWx7gqbie3oEOBMvoJM1U7T+AgiVYLrJfadUnijY3/xy4hjOSzFJCIiSuJuRgqe3fMmxERbirSR6ufXa68ZnwrQ5vfxRD50oCy/eD/9UG0vNE62G4JxO3hHTfUTg1Ifwf7vRlroCN/zKpMyIo6/vAiBNViB8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 1, 2025 at 6:42=E2=80=AFAM Youngjun Park <youngjun.park@lge.com=
> wrote:
>
> After commit 4f78252da887, nr_swap_pages is decremented in
> swap_range_alloc(). Since cluster_alloc_swap_entry() calls
> swap_range_alloc() internally, the decrement in get_swap_page_of_type()
> causes double-decrementing.
>
> Remove the duplicate decrement.

Acked-by: Chris Li <chrisl@kernel.org>

Thanks for the good catch. Indeed there is duplication, but only
affects the hibernation usage of swap as far as I can tell.
This bug is in v6.17-rc1 upwards including v6.17 as well. You might
want to add the stable tag:

Cc: stable@vger.kernel.org # v6.17-rc1

Hi Andrew,

Please apply. Can you add the above line or Youngjun needs to send out
a new version to include the stable line?

Chris

>
> Fixes: 4f78252da887 ("mm: swap: move nr_swap_pages counter decrement from=
 folio_alloc_swap() to swap_range_alloc()")
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 543f303f101d..66a502cd747b 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2020,10 +2020,8 @@ swp_entry_t get_swap_page_of_type(int type)
>                         local_lock(&percpu_swap_cluster.lock);
>                         offset =3D cluster_alloc_swap_entry(si, 0, 1);
>                         local_unlock(&percpu_swap_cluster.lock);
> -                       if (offset) {
> +                       if (offset)
>                                 entry =3D swp_entry(si->type, offset);
> -                               atomic_long_dec(&nr_swap_pages);
> -                       }
>                 }
>                 put_swap_device(si);
>         }
> --
> 2.34.1
>

