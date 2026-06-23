Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0A10CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 05:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 794CC6B0088; Tue, 23 Jun 2026 01:21:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745016B008A; Tue, 23 Jun 2026 01:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633F86B008C; Tue, 23 Jun 2026 01:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E90B6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:21:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5EF28D5EF
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:21:21 +0000 (UTC)
X-FDA: 84910029162.14.B995502
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id EEF2320008
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:21:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cbdCyaDc;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782192080;
	b=DQk/qePo+vWehxaYSHJmdXRdNk41Zit5lirdbZWdgHvR6UM3JGAAYNArIfgTooiKSWuN/V
	td3jcEQZGLcW/rYHEnu37ZO+N0EWyAmrA39qit/ILjT/owiPAIPCR90/7X7lL7Q4KXBueE
	gdsDRDPHSJ0NGWS4emrYiVlV2/3dkvI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782192080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9xcHL0zKeHdVldIVcal4xWYBnpP9GoKJfV/vtggwPM=;
	b=gK8HsCNLt2Kxoj+Vz9gMS8hea29mz3N2x2mb7S7Ac2o6JCxEYJWzDZMslkj47T+F3r2unO
	Bi73N9q29JqkszsJLWwXLcWpxzvsSxunyMnfrfcIW4E8qsiT/X6Wc7YimR+sJW3QwBXe8+
	IHBeJJjIrccdST1SYDRu575TfkLiqHI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cbdCyaDc;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4ECFB60208
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DA31F00ADE
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782192079;
	bh=f9xcHL0zKeHdVldIVcal4xWYBnpP9GoKJfV/vtggwPM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cbdCyaDcakBo8y9Qy5UWuhk2O2aw58n25cBDhw/DKga8b94ePDG9vyz/zA//HlwRG
	 u2W3SZnGiAxtcyX+mFvPozlLMw/erAzgkVkpqQsLUcpMbSoq2q80+MSeNYhuA30ysb
	 e5eWQtfKGxvBDIF96wiWEusH3E1xGCP3h9glQKv4INS4CcNWDia2GugQmE8cVlAgoQ
	 PBLSLSoNiHNU1KzNlzimAlUJGhIPYcSz8vH4yaWAHLabmOw8SPvESa2X1zuDHcvlmZ
	 kZEwZQ3+Bz72a8O8+DmulSV1YY2OBr6+hdZjMB9LT+SmfGhuK6bEcqI3zgTlqW717B
	 CUwK+paWj9syw==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8dd6e530061so77823096d6.2
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:21:18 -0700 (PDT)
X-Gm-Message-State: AOJu0YxWef8omOLG+ZOg1S47FOYBk701eUZLf2fqJDmCZ+hK5LiMrthu
	4VwA+bUH98aIwemKIASdWBm/GQmSMjwSPCwxI6dvM9diq7I4yL++IRiicQIg9WuzKPVrnotr2aM
	x5NSVT1IWpHk5NH8VbMkUJlG3F/l8KM4=
X-Received: by 2002:a05:6214:3d13:b0:8ce:ee76:1597 with SMTP id
 6a1803df08f44-8e43709599amr15409076d6.43.1782192078434; Mon, 22 Jun 2026
 22:21:18 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781843449.git.ritesh.list@gmail.com> <ecbca3be3fa8bd7e213d013a2ec6ff9a11c6e0d1.1781843449.git.ritesh.list@gmail.com>
In-Reply-To: <ecbca3be3fa8bd7e213d013a2ec6ff9a11c6e0d1.1781843449.git.ritesh.list@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 23 Jun 2026 13:21:07 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zxcp-jdnRTn09b8ZfxT0P7suFq3BEpyiUzA2C_iRRUGw@mail.gmail.com>
X-Gm-Features: AVVi8CeiUTUaiIcSdVYVOkLXA4Apo1fqvv-IRKNsnhGzJmhGJPkOscl1sBGYS6M
Message-ID: <CAGsJ_4zxcp-jdnRTn09b8ZfxT0P7suFq3BEpyiUzA2C_iRRUGw@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] powerpc: Kconfig: Enable THP_SWAP on Book3S64
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9cs8yrtwo9594odyepnc16a4kkydixnj
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EEF2320008
X-HE-Tag: 1782192079-414078
X-HE-Meta: U2FsdGVkX19haYoQcrGZLkDUNTzRYqZ3cqNZzB4xCXOU2UVfeOxm+BdWesWo7qqIuicpU3c2R9jhvjgNvd0LMnetpChwtW6hzBrBwERdXxzotrDU3/QOrC9Y+tjylrUMZXkKeyE5FdAuQ7YuP/Des09V7qY4f/qceYNtLfJSm1iORoVnuBqSQ1/31Tyb6foOfT+72I20b9sgmEg121F74LHxFcn2g/q1L2g2x49B4s7gO9TbZLwwD2pI78F7sKAitQHUQT5EfUJ0f2Jw6Tb5kdx3gw7N1lnIeO7XccPfmL+kYCUWYPpZ67O2stY5Qpxeu+0KJMooe9AwX0cpQFNsdkhwqK+JFLFR54PASxADH8EfKc3sDy0XRaX6DKJ9IyaFnseLbA7FjWM2KpZ2VOS+qLrNvg/KdNVx7FVr9eY8Y1HM7HiebQabVqpCqQuigzYVzhPvdOlv36DVty53ee/S1BID1EQDogD/KyUBoJzbuYfECIe4/3Qht/kcEUtrVF/2b2PIeynslkevlzf7GvAWm06PAe/WeEiJhXfMIdHXcL2F/q4Jr+OUrluTJ4OMJfH4+KdXHb8BACJtAupA7y/2i6xV3/pNkcnf3TUEWEKSy6JreJapmIHOzFVu6MU/6WxMle/LRiaMPeRNFzanrZQY7WSI7Ojg/+mgTL2L3bdSTK0Q8YshvqxntgMkkHKAa7noYfdUX5pcoGX9qPZ5oAG1EizFO65RyjPxf5c7liCYNN57EDDx+oPNRGg6W7G2fYWLY1V5oeXegYP+hKMY4pToml5+HwLguJBPUQHiuw+feAUcyw8RW4PDHPrC7eKsZo4RIsAS2wzUOzkOB6VCOPke8udzNz2BPFRPeBUdGRQGc+rma0HA4spuecaQicEzOfUFUrQUC4eS1DqHylTCSnTq4avYlZDlv97tQneMUIw/WptaRrxYNfvfL3ik6TaUN19NgjTfMw6Hj/m0GinpSe8
 Rk1xMNix
 S1ChgPYYyNlim9klp0gr2/o+JFNZ4UrB2Emtm2Qu4GIjY/TvJQ0I8N5VfbUGm02KGsInAeVrM3zk6wfVvMcAKSHwFbpWQBgBr3zEvYU1oupYQVOnQ6+H95lGwr85Tl+XX4dB71ECcDb67Fmc99bP/ul6YrcgRhQRMzJhuS45a4YqZZMW+YLAo5KQnGylnDLGcYnAGOpyjcgOnAYI8G/TTD0tsDLDTojovxV6G2fNcCG1NDGdR7azB00cjvvZ1D4Yicn9b6+7te7Xkpiq6N7sTniSXZ77eamRchbZyCk+p66olM0WPWNZjRWJEXplA+pwP7TP/3AS0piml9gbRIXjm9rj0E3fxBHPJxy6+6UIFaNp+RjlK1kVMcg4Rq48icDAeFmX73GQZKbuipQ9yCYiJJIspx/vT5ibE6Wq1l6pBrTA2YytNrbNKVnfgIF7ORrkEwBU376yGDXSnSexbyNWtmC2+x66YJWUZFpO8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 12:41=E2=80=AFPM Ritesh Harjani (IBM)
<ritesh.list@gmail.com> wrote:
>
> THP_SWAP avoids splitting of a transparent huge folio into 32 smaller
> 64K folios (Radix-64K pagesize / 2M PMD) or into 256 smaller 64K folios
> (Hash-64K pagesize / 16M PMD), during swapout. This improves the
> swapping performance since all the bookking & I/O submission happens
> once per large folio. More details at [1].
>
> PowerPC Book3S64 could not enable this before because PMD_ORDER is
> selected at runtime depending upon the chosen MMU. The earlier patches
> in this series turn SWAPFILE_CLUSTER into a runtime value and introduce
> an ARCH_MAX_PMD_ORDER upperbound override for SWAP_NR_ORDERS. With those
> changes, we can now enable THP SWAP for Book3S64.
>
> This increases bandwidth throughput with zram backend for swapout by
> 40-50% with Radix and 100-130% with Hash (Tested by Sayali)

Thanks!

I am curious about the contents of the anonymous memory being tested
and the compression algorithm used by zram.

>
> [1]: https://lore.kernel.org/all/20170515112522.32457-2-ying.huang@intel.=
com/

Best Regards
Barry

