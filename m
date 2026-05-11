Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8528CD3427
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 02:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E27B26B0088; Sun, 10 May 2026 22:53:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8366B008A; Sun, 10 May 2026 22:53:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEEEC6B008C; Sun, 10 May 2026 22:53:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC6BE6B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 22:53:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48EB2C205D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:53:31 +0000 (UTC)
X-FDA: 84753618222.11.3A608A8
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5F542140002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:53:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nMjpoihw;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778468009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9E4dgEeb51SKnCEhl5hwbIRce027DTh3vHWFtSjNSoI=;
	b=hZ/pBGnuhezm5fX5awQWCAuMi9cuer/1HwLes+G5NHrcQ9DOiXT88O7us8O78pc15Qs3aD
	S80aX3p4Pdf0vKzU4d0VoYbQSIzfFm5DpX3OruHBmHxwU7c03461edIwNYhRJ30cqNzmZG
	6TrR/QA289kDk8sAlJ1gc2/7iII4fKs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nMjpoihw;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778468009; a=rsa-sha256;
	cv=none;
	b=VaLoHWLEm3e+7jQdkouHoZEePeo/0/S9C8hugsb7noR+Hn3Fq4RAIYWJfUHnku0n1JJr67
	/arUoETdjqGPOtZr5SkJkXkj8InChPdAyo6PC3ge+vdxpeI4t1wfSxdq0UTIzO+Y4mwW3n
	Z0Cdr8fzc9iEmflYKN00mM7j2SlZums=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778468008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9E4dgEeb51SKnCEhl5hwbIRce027DTh3vHWFtSjNSoI=;
	b=nMjpoihweTGekmpgzfDvmMh+y/UzoyxL9t24jPPBhMPAcI+H7FMV+cs4/IteG+cxMweW0W
	RNugMCC9I37fmHCrMRodQnhClG1/Tov2n2IaZvfnPR3Gj62JKtLqYoQoU9a1qs+Hx0i7Tl
	jwtH6WDNXrLuGU2etJzSdA1JITcm04U=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH] mm/hugetlb_cma: restrict hugetlb_cma parameter to
 gigantic-page alignment
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260503084225.415980-1-ekffu200098@gmail.com>
Date: Mon, 11 May 2026 10:52:59 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7A1AFE39-BDA3-4919-9D3F-81ECC734F6CB@linux.dev>
References: <20260503084225.415980-1-ekffu200098@gmail.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F542140002
X-Rspamd-Server: rspam06
X-Stat-Signature: ujzobtaxe8dp9getyfxmehc754wdzhua
X-HE-Tag: 1778468009-781453
X-HE-Meta: U2FsdGVkX184mGHDRnZqbixw1qDBvwIysvPVNvp9wB7hOmQ4eI4GNO5P1gaV84NcpG0SJmy2gJQ/Rn6wdTzzqcOPuDIgLoiSkP1sbXM44GgVe7OA0g/NEOjoS4+94e63ZbBsMVGI1KbCxFyf7zphzfMQvOaLZHwEJ0wGKrkmeinq08vT/uRSbZoZ0i0wCn9w4NWRG9ksIe8qCPaQzNaUAPE5wLcwJzE8ZWtmskgokAEuPl32TV8/P/D8bsbmXxmLusAH9MYZS6GftXzlwmO2S131PyBM+8hscFYbaE3L0089PNU1mHdtWpLUhe80JSZ9gWr2GgkL6ttqiSLI+0m63/GrRS21YLkKvgLusErGEY6XXtRNgMvQQhgRjJDFaBQHUAs2noDXgZ8MzXI8oPpfm/YaDqefuTzY/tKj+TNfBViqFFiXIJrjgG9gErFLVBWz1QxoYuMaiKBZamHPACuFQS0O6ueRyU1Y3KTI1vOggTseApzcUt/EVYc2LoiPzPVImyMCBtloncLpUyk6GdXoaXFLT5k5UxhGsNcXLf7NMXJKEDk03sioNgO7/Or2JY85WJkyPN8LnNB7TYHga3tyCJsemiGlAa4aPtb7bQ/yNAJAiEozs5Q3McqOOH9/CyUiviHwPE5ukE94tilMv7biv05Va9cZgGoCSaiknuFTmOMvePuCEp1W8lp4Nao8iN2Oz7mNlipZdKYaOY/syx54JLhBya1oR4cLDC//Gig43Z/e2+LemGEbzu+CePQPWHYQNda+2HoLuzYVFJUS7wWckBw8lmQnmcZ+D+pjdO1igvp82Pb72Wjmc3Oz0yXDnrIj2lAZ62mO1AO/j8oNSunQ3h/mo1+pFnurqcp6/KYeMApfZ3qj0u9seVj/MsDI1vTBBqgJfDOmfkdpF6q7KmWbq8gpdWivysZCGw6cXAqYo/uxvexF0+khqxrrsUtR0RIMveHsV5FXRVfv9FovG3U
 mgdHI9Qu
 CpF2JREoE/DU9myG1INZO0QVZg7BvLg/c1PbufS3fON8fEFwFh4Xw3id2AHzJkoJY89TEOaC19AJS7x0VuxazO5YK1COIZiUWTR1gEnO3YJIreWgEPiFIPoLvKORRQ1Vrf+7of4bro7j/ILBX0SpDZPGZQQzeuGZQPrCr6qZ9iW1Gaxmx32s6zFqaY0bwGEjE/oYGGRO5Mper44CImWM+EQkeT8nq55XD6XNGcRXKVuMML32U/pcbUgkwZA9zeN1Sc2UI0FjR5dX/FNW+Ur5xj3qwKrDjb/fZS7nv2N4iXdCDkaZqTA8VzZN2rbTUU7lUG5eMBfO0CtN1Iz8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 3, 2026, at 16:42, Sang-Heon Jeon <ekffu200098@gmail.com> =
wrote:
>=20
> Existing hugetlb_cma parameter handling logic rejects sizes smaller =
than
> one gigantic page, but rounds up larger sizes that are not a multiple
> of it. The two behaviors are inconsistent and neither is documented.
>=20
> To remove existing inconsistent and undefined behavior, restrict
> hugetlb_cma parameter to only accept multiples of the gigantic page =
size.
>=20
> After this restriction, the redundant round_up() in the allocation =
loop
> can be removed.
>=20
> The new restriction is also documented in kernel-parameters.txt.
>=20
> Also, including other minor changes for readability improvement with =
no
> functional change.
>=20
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
> QEMU based test result
>=20
> 1) hugetlb_cma=3D1300M
>  a) AS-IS : total 2G reserved
> [    0.000000] hugetlb_cma: reserve 1300 MiB, up to 1024 MiB per node
> [    0.000000] cma: Reserved 1024 MiB in 1 range
> [    0.000000] hugetlb_cma: reserved 1024 MiB on node 0
> [    0.000000] cma: Reserved 1024 MiB in 1 range
> [    0.000000] hugetlb_cma: reserved 1024 MiB on node 1
>=20
>  b) TO-BE : rejected
> [    0.000000] hugetlb_cma: cma area must be a multiple of 1024 MiB
>=20
> 2) hugetlb_cma=3D0:1300M,1:1G
>  a) AS-IS : 2G reserved on node 0, 1G reserved on node 1
> [    0.000000] cma: Reserved 2048 MiB in 1 range
> [    0.000000] hugetlb_cma: reserved 2048 MiB on node 0
> [    0.000000] cma: Reserved 1024 MiB in 1 range
> [    0.000000] hugetlb_cma: reserved 1024 MiB on node 1
>=20
>  b) TO-BE : 1G reserved on node 1
> [    0.000000] hugetlb_cma: cma area of node 0 must be a multiple of =
1024 MiB
> [    0.000000] cma: Reserved 1024 MiB in 1 range
> [    0.000000] hugetlb_cma: reserved 1024 MiB on node 1
> ---
> Hello,
>=20
> This patch implements a new restriction to hugetlb_cma parameter that
> was suggested during the review of the previous patch [1].
> Thanks to Muchun for the guidance.
>=20
> [1] =
https://lore.kernel.org/all/BFB1F124-B599-4832-A9DA-F4931999BAF9@linux.dev=
/
>=20
> Best Regards,
> Sang-Heon Jeon
> ---
> .../admin-guide/kernel-parameters.txt         |  4 +++
> mm/hugetlb_cma.c                              | 35 +++++++++----------
> 2 files changed, 20 insertions(+), 19 deletions(-)
>=20
> diff --git a/Documentation/admin-guide/kernel-parameters.txt =
b/Documentation/admin-guide/kernel-parameters.txt
> index 4d0f545fb3ec..23be2f64439c 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2100,6 +2100,10 @@ Kernel parameters
> 			Format: nn[KMGTPE] or (node format)
> 			<node>:nn[KMGTPE][,<node>:nn[KMGTPE]]
>=20
> + 			The size must be a multiple of the gigantic page =
size.
> + 			When using node format, this applies to each =
per-node size.
> + 			Missaligned values are dropped with a warning.
                            ^
			 Misaligned

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.=

