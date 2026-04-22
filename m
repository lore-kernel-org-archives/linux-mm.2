Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB196F94CC1
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 03:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D75456B0088; Tue, 21 Apr 2026 23:43:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D25556B008A; Tue, 21 Apr 2026 23:43:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3D236B008C; Tue, 21 Apr 2026 23:43:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B287B6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:43:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A0935D6D1
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:43:28 +0000 (UTC)
X-FDA: 84684796896.21.90AD814
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7BFF040009
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:43:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RfLSOn7h;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776829406; a=rsa-sha256;
	cv=none;
	b=qisiTRYjV+rz/+LFwksgr0korMLXNRhdMoxPrfcKqJUx8yT0+uqT2OdAD77EWaUznDRmSJ
	hGWufaxGZwWXqo2c+AMGmItpXxTTd0ZmtP1NGsjmCQ6ISUioogJoKFLtIqxINFAKp8HvMD
	kJNj0auU+3tJmhvtVMFMZVOMoGMFhCk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RfLSOn7h;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776829406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OjwCt4nXBG5AAWzAicOYlXQgrFBK6YRkDyXLUyFVbWA=;
	b=zE4dDYIncuDp1nxZRLjPuUyrdYkhmackgN247Hh/1NU11+bSJO5HhqOmfitQ5bXW7xsxtf
	hbi5RCEM5iXoPkjbRXn0EoWX1ZSR77uOuJUhVvgoxXPDz8BXQeTB/PmrnDxYaEavow1Jq3
	DVUe88Qghx7HVv1XCGVo7nHTwzSxAkY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=OjwCt4nXBG5AAWzAicOYlXQgrFBK6YRkDyXLUyFVbWA=;
	b=RfLSOn7hatQETGPVKmpKXJitrg67J1xGPlxUXp9UCF+U+Y0tG5z+DuZcFve3awjZStrKCy9Em
	vERY697X+51AZmiNsMMtNl1mjYEFCfPeoKjQwAczIIVgcmsb4lVNIt3jVp+i1gpUkOXbkNgNN8h
	srXSp1Ny1er783qNxMOGVF4=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4g0lJz6XKpz1T4Gh;
	Wed, 22 Apr 2026 11:37:07 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 1B1EF40571;
	Wed, 22 Apr 2026 11:43:18 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Apr 2026 11:43:17 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Apr 2026 11:43:16 +0800
Subject: Re: [PATCH v4 3/3] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <kernel-team@meta.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
References: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
 <20260415-ecc_panic-v4-3-2d0277f8f601@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <7b4a6659-e2e5-5e63-2952-c7a840ffcdec@huawei.com>
Date: Wed, 22 Apr 2026 11:43:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260415-ecc_panic-v4-3-2d0277f8f601@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam10
X-Stat-Signature: eg6ura7gsfsfmhf8zrzn5mwgne97y8i1
X-Rspam-User: 
X-Rspamd-Queue-Id: 7BFF040009
X-HE-Tag: 1776829405-375500
X-HE-Meta: U2FsdGVkX18kt6H4N/T8MF+T+25OjkEGsSLXw2CcUt8tHAfKVRhW1tzuaUpiIdktRxiwc+3xlzSq5a1tD4rAqK+Lc3UCFwYSlMTVsyhMUe8zp/GGIFxjJa4enkBmxoBj64tMfHPGEtBTg+0L/MzBO/zDe64feyRfByPq6OuoGx44DaJS8FDp43bD2o9pW632djssCUK3Fwdy3bOOs2KnsPL6dYzPNbLTahClalMKE5LVTvg/zC/FRLeNcWnA13/vxq17rPvdRKLerqQuakO5Rz45tsNl2kBmVxrSrGG/vXFLhwbDB9WqDQX0Xp/0Dh5w4/UtD1HDqPWg8oJwUHXB4v7tCIe2IbxpEs9hRPTGBAeeveLjHY/4cGK1t4U0GHdo6Uj2tuVeolwZalBjA/HOwQF3vq8sokljxFhQ1cjdwiZq1o2ZuPAeDU83dOwu73ZojfjT1v1fZjftYlfbWyfAas/4hpJucj98ic2B1TadLqO9YwOeQ7iE8DJtifZmgEdr8TKfpxxKE1Guvsc4p2vLQLFhixeQgkBuMk/7TPUdCRoixCV7bppIjGXnWKVfJfwou5WESTKb5xmxjgLlAS7dDZd/9A8qn8SldRrI3AuN/3J2c1ihJZ3HBokb+6awLgR3ZJLV4E1UcaSxrFaUxlaUsu6HPeHOqAF6LgQa1uq+sbRInzvuK0tyQ8CAaoPSCt9eGrP2jqx5EzSMwgGwZqMrfip8SLx9twbvYCR8X8B4GrycH29Fsn8pnjRogmMsCerBoOFx1rArBSzdIfY1/thcgCq6GIoIkUof3WyjVnfZfWiQFZNuXU2daKu4183wU69yNMETQMXrYfpx+IgXdL1h0dxkbO9hWm8wU5SG60/NEWcdDLBG14ouuei621zmdKj12Rvn0/PSHgd41QnEH9moQP3+FZQxzE91OywmaeIePGrftNIMannaXvBPTtAaOj7HvANgeQwBgfMKeCa5Z82
 0sr7FPjv
 0DvPn9pjO8RPdMaFlXDf7bPjvXJO8XLlYqgSoczHfrR8zNeBl4H9m5B3FTHROHfR2dlMHh//qDSt0cmptUmOwjwvOgWNxTN1kk1jlg3f/Q0zexkrEMd+bNLsxh8clJRha9NW1x+lYZ2NlnnRNZy3KP6sH2B2MxgB7e/uLusR7DSiozc7qbsA5bGX54Su/nLui67Ky3mRXGpHpyV2jVyHfDNCkTBBQ5ObzJficu+Rmly6Csntf8gqNiM5DSP0w5q17rYNl2I+lBmUBoj1JqsWIV9HxcV00b/tLLtfSE0ptq/XV7xtrKEa+XqHjzcQBnLpUmX/InxJ8Lf/p2NuR6DQHcuCcBnrdIVESq8YQFruRYi4f5G/Z29Or15zu0EtMMqLVHPe5tU7OSykl+gOW2RV+O5nHIXmzi8A8+Woh4VsziL688VVAkcYy9tVEznv1RQq2oCwk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/15 20:55, Breno Leitao wrote:
> Add documentation for the new vm.panic_on_unrecoverable_memory_failure
> sysctl, describing the three categories of failures that trigger a
> panic and noting which kernel page types are not yet covered.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  Documentation/admin-guide/sysctl/vm.rst | 37 +++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> index 97e12359775c9..592ce9ec38c4b 100644
> --- a/Documentation/admin-guide/sysctl/vm.rst
> +++ b/Documentation/admin-guide/sysctl/vm.rst
> @@ -67,6 +67,7 @@ Currently, these files are in /proc/sys/vm:
>  - page-cluster
>  - page_lock_unfairness
>  - panic_on_oom
> +- panic_on_unrecoverable_memory_failure
>  - percpu_pagelist_high_fraction
>  - stat_interval
>  - stat_refresh
> @@ -925,6 +926,42 @@ panic_on_oom=2+kdump gives you very strong tool to investigate
>  why oom happens. You can get snapshot.
>  
>  
> +panic_on_unrecoverable_memory_failure
> +======================================
> +
> +When a hardware memory error (e.g. multi-bit ECC) hits a kernel page
> +that cannot be recovered by the memory failure handler, the default
> +behaviour is to ignore the error and continue operation.  This is
> +dangerous because the corrupted data remains accessible to the kernel,
> +risking silent data corruption or a delayed crash when the poisoned
> +memory is next accessed.
> +
> +When enabled, this sysctl triggers a panic on three categories of
> +unrecoverable failures: reserved kernel pages, non-buddy kernel pages
> +with zero refcount (e.g. tail pages of high-order allocations), and
> +pages whose state cannot be classified as recoverable.
> +
> +Note that some kernel page types — such as slab objects, vmalloc
> +allocations, kernel stacks, and page tables — share a failure path
> +with transient refcount races and are not currently covered by this
> +option. I.e, do not panic when not confident of the page status.
> +
> +For many environments it is preferable to panic immediately with a clean
> +crash dump that captures the original error context, rather than to
> +continue and face a random crash later whose cause is difficult to
> +diagnose.

Should we add some userful cases to show the real-world application scenarios?

Thanks.
.

> +
> += =====================================================================
> +0 Try to continue operation (default).
> +1 Panic immediately.  If the ``panic`` sysctl is also non-zero then the
> +  machine will be rebooted.
> += =====================================================================
> +
> +Example::
> +
> +     echo 1 > /proc/sys/vm/panic_on_unrecoverable_memory_failure
> +
> +
>  percpu_pagelist_high_fraction
>  =============================
>  
> 


