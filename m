Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 775E0C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D7CC6B008C; Fri, 10 Jul 2026 05:15:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 661DD6B0092; Fri, 10 Jul 2026 05:15:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529126B0093; Fri, 10 Jul 2026 05:15:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E8A26B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:15:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 739891694B2
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:15:19 +0000 (UTC)
X-FDA: 84972308358.21.DF63645
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9151C20007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:15:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dDfZEO0R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783674917;
	b=w7/yf2ryzXsCj7pEIXeBsrSHqNTR0EYzp6nx+6CfIDcacakozuFWF2/ou1j4ipFF8npK0c
	vqs6Xoqsg7Qmq/8U5e5ZAB7OQ9jR3U0vo/3Bk+98IQkux/Ns41ug0KuK/HVLdA3H4MNiO/
	znAjoCwtc4CqgIbbitVtf42tE3X2ZTc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dDfZEO0R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783674917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0nEVyVR7Jpl+dPmv9FjJm0kEBMJe99wCLcmY9sQtfK8=;
	b=RYzDk5XBtQrmbn84bDQV4K2JRMqUsYRQDeqkRAJDOQubHCIXAVSFMBaH8K9J0aTJAIn2ky
	pnJbvnr0mZ4lnuko2PA8CntJxH5O+e2OyHbXxozntXurwCXQkjdUki5BgD2xW5ucod11G3
	WW5hXH6bH6sJzcfi+YcpLApb1nx5y/Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B536343C17
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7341F00ACF
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783674916;
	bh=0nEVyVR7Jpl+dPmv9FjJm0kEBMJe99wCLcmY9sQtfK8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dDfZEO0RjJSPZMo9nP+UoRAQ5EUnnRfpwBz1k0xKudhWKSksXd2gomzbhJdkuHOK9
	 n42ADkJzM01mTbCjx3RqpzZ6xB1B3Vfy3zJHWh+2grIIsBxBs8RL0lgkX+qDqTPZQs
	 oTjtsq0KTH3sqr5gdtd0ZgcoFSYcu3P185AU8ogX0ME7rUDIfw1IBB/fs2P9d6Wqkk
	 7QYSqss/c3nNxxZR44XcI9Z2/GmJanPc/FaSQ3v7+9/h8CSY22PlmnfsAtDRFQvTOk
	 8YvmmpKv8caQvrIX9I8jeaC8gAhbapJwkwBTPn/tH838YWC+3q5qZg/a3jKSGeJNbU
	 3FL762YTPFJxA==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e4fd65b2bso31876085a.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:15:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoOXl/c8lMl05bu3smwNi73WXJD4m03xesgDiEuKNaatuBKmNjHetvB22QflZQ2F75pTpQhpum+mw==@kvack.org
X-Gm-Message-State: AOJu0YxeGI3YDD1jbg3kAT66yzEI/6iZm3Z1+kE6vzV+yyra8HCxxqsR
	mB7vCN6ryao/3Ke75tlg0ckjZHZSzoCcpRPR76ml+Ea/4oHU5DKU5foIxmgaZFB6jVEmVqeoKCB
	H3HPpWeBx2c9pXlDIRKLUj0LXTJHDP0o=
X-Received: by 2002:a05:620a:2854:b0:92e:c118:18d3 with SMTP id
 af79cd13be357-92ecf9087c6mr1179574985a.94.1783674915990; Fri, 10 Jul 2026
 02:15:15 -0700 (PDT)
MIME-Version: 1.0
References: <c0b158fe3f25709543b48a9d81b1933120a9e2ba.1783648317.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <c0b158fe3f25709543b48a9d81b1933120a9e2ba.1783648317.git.baolin.wang@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 10 Jul 2026 17:15:03 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xbPocaA9wmJD38+YLs8uaZeH5hek-98BM9fxY6s3oswA@mail.gmail.com>
X-Gm-Features: AUfX_mxGjaF2IWoQumKPG2G9y9iws7zBVU_BVLYKb1ptJAwHQVowr3oZzbY8uEY
Message-ID: <CAGsJ_4xbPocaA9wmJD38+YLs8uaZeH5hek-98BM9fxY6s3oswA@mail.gmail.com>
Subject: Re: [PATCH 6.18.y v2] mm: shmem: fix potential livelock issue for
 shmem direct swapin
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hughd@google.com, stable@vger.kernel.org, 
	kasong@tencent.com, machao26@xiaomi.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9151C20007
X-Rspam-User: 
X-Stat-Signature: m8775cqep6c1nc9x6drtc9x5tgw7fsx6
X-Rspamd-Server: rspam03
X-HE-Tag: 1783674917-551216
X-HE-Meta: U2FsdGVkX1+LPqNLU51XaVC60L4I5nVFIjANp+ZdtYmYp6TelAxwFQM148Y+iEu4IlSTJ2QELlbpVNdwoxrdeIIr9tGSRThnNTtg6pTEjnpIAMMHj/qckyuWQl7VSkN9C1/CDv8ThkLsH/cCcEY6Hsmj63WwGnoAhxmS+KU41gYOeqxAsdDcjTMzy3JjDg57qmrQbYNXvvA7e1rasG2mphxMd/1XOfe5RqkUd9Q3UxiLkxT6IOU5JdhT/4UzAAd5O8Nv+WfVoo4qIMc4obO+c7vGZHDsB+Z0eqxGjR4ryxdivUzwC35ayhsi2DNVEqn5YklbmieAmgSxoEQ/BkjJqDwxzo8MFVHbYLlf70XLSvPelZvPX3UXpyDcLJIa2nJHMjOQ17PPxciU8x426GgrQJb8smL8y4WRh2JfquAF/6cQXEhSOjek3R0ajm2zGwSZaFSP4yn/0nIbGtsog9E1bfpLNdPEEG68xdnDAPO6WwjFI+TQ8sxDnN0UXwDDzJZTDQBHadPDwX3lU5LzZcM00h3U1hXvSTnON4A6Tdu/QEpR0EB9xr3y3IRNaTMN5HFUvTAnimE5eW0/6Py0qB/HOCNcWY1Mlks8KFTqJdNSqJjYtu7oF9pQZFRZ7AwvRy3irfnehb7sRwHYw7FnApFYDhW06hIrmlUzNyKp9kinz5VkizoSPW/hV7Gmj4ZJWM0PlkTC38MWK0us0CQY5Y3Um786I2L92b6MBj4ET40vKDc1aRcf30vu9OQvZ1aFuuya9wMwIEio3gpjJSay6ANtdZIQAXgKf+iCD0dmxHR3WooT0DnZtPWzkwhtThhESYMqKZzgXNYvWgn742h3Cwu03JJjLL0laQ7emy/sd1n37tFKstIvEBaOYDhu4RwH6JSvmBors7Be1zwXdwR3q/Bzej+G12OLFePXD42hiZoAKRhwRB7n5GsuJPb2CuMsMFn4FHl/V/TLlJ5KTHxJFyb
 7DRnE7BJ
 3gYDlKh7UVREUu1COD63vKzdyxMxoeD2/18NJEAPGfvcz5G2sJEMkM5BAm8IX9tn85JRs+CJUWo+/QqqntcEYmxeCxHpIwpH77qTvWtriU39e38D8TTLlZZo5WTbso6nARqnBTwqvrIxspj0x2/pvd2F4gxXUuhtd4aYqknu2v5cfsLBb+Slxy6HiBlDHIMco5PV6USDDH9uxzBlsYArYCP1L55fzD+N8ieHBzGtYPZrDCUWQCEWh+vcQc5UhKQmfySGksckQBsZwFXk1y/nl0fBwJm/3fSzeRE/4BS7cPVU0NifrRIPv8ohq42N84UZCL6hXxezAVLCVwppR8AOSkX2mfumrs+jc1Amnz+ssv8MhhsqHDbXCC1F6uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 10:09=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> When skipping swapcache for synchronous IO swap devices, swapcache_prepar=
e()
> is used to prevent parallel swapin from proceeding with the swap cache fl=
ag.
> However, on PREEMPT kernels this can lead to a livelock, as reported by C=
hao[1]:
>
> Thread A starts direct swapin of a shmem folio and calls swapcache_prepar=
e()
> to set SWAP_HAS_CACHE. It may then be preempted inside workingset_refault=
().
> Meanwhile, a higher priority thread B also attempts direct swapin of the =
same
> shmem swap entry. Since swapcache_prepare() already marks the entry, thre=
ad B
> repeatedly gets -EEXIST and busy-loops waiting for thread A to finish. Bu=
t as
> thread B runs at higher priority, thread A cannot preempt it, resulting i=
n
> starvation and a livelock.
>
> Fix it by yielding the CPU with schedule_timeout_uninterruptible(1) when
> swapcache_prepare() fails, following the same approach used in commit
> 029c4628b2eb ("mm: swap: get rid of livelock in swapin readahead") and
> commit 13ddaf26be32 ("mm/swap: fix race when skipping swapcache").
>
> However, commit 01626a1823 ("mm: avoid unconditional one-tick sleep when
> swapcache_prepare fails") found that the unconditional one-tick sleep can
> cause UI stuttering on latency-sensitive Android devices. So we can follo=
w
> the same approach by adding a waitqueue to wake up tasks when needed,
> instead of always sleeping for a full tick.
>
> Note that mainline does not have this potential issue, which has already =
been
> resolved by Kairui's swap refactoring work[2].
>
> [1] https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiaomi.c=
om/
> [2] https://lore.kernel.org/all/20260517-swap-table-p4-v5-0-88ae43e064c7@=
tencent.com/
> Fixes: 1dd44c0af4fa ("mm: shmem: skip swapcache for swapin of synchronous=
 swap device")
> Reported-by: Ma Chao <machao26@xiaomi.com>
> Closes: https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiao=
mi.com/
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

LGTM,
Acked-by: Barry Song <baohua@kernel.org>

