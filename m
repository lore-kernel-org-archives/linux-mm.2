Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD93106FD9D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 08:41:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBF5B6B0089; Fri, 13 Mar 2026 04:41:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B96CB6B008A; Fri, 13 Mar 2026 04:41:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A99356B008C; Fri, 13 Mar 2026 04:41:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96AB56B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:41:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A85C5AFBE
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:41:50 +0000 (UTC)
X-FDA: 84540396780.11.BA6128D
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf10.hostedemail.com (Postfix) with ESMTP id A0476C000E
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:41:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="C5D//YGM";
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773391308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CN48FU1i1sUqZBxESLMVXkFpxzJXnKPZ1jbKm0REr3U=;
	b=jGx1qPjqnAu9spDw/N/P6kmfhctn4mQDyeEQmlFc3Sk3GRqbgHPfxgft601fuzRrPPjBJv
	lmrFd3ytzK9abGxeYn+9gYItw/iXBGcy+JwhEywCDKdRs2uyECHEgqJX0P8DkFher/CBxM
	uluw3U3XxFhoNeDcL60/g0DQ+Wfob38=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773391308; a=rsa-sha256;
	cv=none;
	b=JSLSr3DvPzwifLz7kTAlVeW8OrZ0ldZ5SUKOM/DzPC4Un153i5cjvbDANvtM7HB2atAUzf
	CX6HnN1WcjP3bFElYDzD8mLT7MD2k5CS1dfKXSVG+CYeXla6S/VQ5phNgQfoJPTqm116TZ
	cSsFXtGIjt71WpmLn2B/lyq5UqvBNtc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="C5D//YGM";
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773391303; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=CN48FU1i1sUqZBxESLMVXkFpxzJXnKPZ1jbKm0REr3U=;
	b=C5D//YGMUY68VlQmt2cc8wlqm+Cf6e/BNFCup+w+GBI2xR8YfetJYTG4YYFM3dHI81nPPlLyNv8tjlAVZwQ8Q7BlVQT+AZUOSs2M/5DwHq14nFbA9kAF5t+BKofZAGHjSnm2DQnXSzkNOPP1osb9+J0+2mW8NopXrVdmh3jxzTM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X-rhBv5_1773391301;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-rhBv5_1773391301 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Mar 2026 16:41:42 +0800
Message-ID: <349671d5-f5aa-48a2-9bba-00aef167b836@linux.alibaba.com>
Date: Fri, 13 Mar 2026 16:41:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] binfmt_elf: Align eligible read-only PT_LOAD
 segments to PMD_SIZE for THP
To: WANG Rui <r@hev.cc>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>,
 Christian Brauner <brauner@kernel.org>, David Hildenbrand
 <david@kernel.org>, Dev Jain <dev.jain@arm.com>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>,
 usama.arif@linux.dev
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260310031138.509730-1-r@hev.cc>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260310031138.509730-1-r@hev.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A0476C000E
X-Stat-Signature: ubocoug483phuas49uzz6y6tyucbzpdk
X-HE-Tag: 1773391306-582485
X-HE-Meta: U2FsdGVkX1+Iyc6xMGKM6yBlGgynq/+f50IWroaXhoUwOuvaDz8WcmW2fEbBOPMzt5E2J4LoBQDOSTqkekrUR2Ixj+0Lfi2YIF5jAhWAc+lzMCSJNQ1iJdUl3WYTMzBnarUHGwuYDNG6s9tVsqc8V8qSCX1SjC86+qzYpZdwpdJH2BetvJpY6V/q6Xa/3C5uqpk1lyGByJtW6N6dk1jtHlxcHa82Uui3K7FGFJipceyArUIraCMRlXzhZqI8RMOgXk5mgZkOylFqze19LaLQlBUxZ+q5POOHLJDWHfk3BOBs8IW2FS2Fd5Ts4RZ5SqmqKy5q6J/hCdyONLXxX02Chrnw9tF7KOHdZJh4WeOoxJMVFAbMEnteJkUC2JahzDJyaxhhGJ6T/r8z2QjBqt3MvkSNmhO2+ahCuRwSYtKAIJ8obk+9/nhprg+15ubExrwSlvzupSPrX7FBHcWUCnfn3hnO94OjwzvQw8erTypz8fNccF08zff82gJ7dhscjfVvyJSEQd3Dsy9MOh6XGvbRx+VAJyqVqwUbPksPFPyn7ZIhOHIzHdbzY2ree1IKztwIF4Pw7zNmafKCQra9W1ysa2bl/7UZEFTyqWCrvscJzYCb3pnZ/5OlWS6EbcwTwAFTUM2vA/H0WNskGtdo/kZYrWAcFP8C8234VAyziRGtzSWl4g+HUrRULuxStPFGuXk05vvHK2Wwahk3IozhDv1avcDgRHyPm5d/0zfDDMsck6XS+7j+f+NCWXPi2r2YX7VRXG2nq9N6AUaE1UaZHtm8UDlXa0cRgE1ihbyVVD2xbnhqxtlwO7yKMHtuf1rUE/kWVGby/oLXHPYx0Tc9xZ7x9xuF7ZTingoxtgqE5vFWCF4rydqWpwE8+OBCGyVlvEaSR0qRhI/codSE+BsFnwFEaHq4qokyS6W+oTmdvx5sxFjpiz8C+Rw+ZvLvkkbo0bAbv/nhwVfunkfLPEvSt4P
 y4PdjBGd
 yZ0YvVsQcb2lsw8YsY/5HOqyB1fE2I+ysG0FwiMTdwv+y4QsaF/YWz2tT6Dmz8SbI8UEZTUhPR0pw9+KNyUyKm4Gq6Vi9d55/gBsjakML1dDc5oCQLRMusxtJobJQjRmn1T8f/qeyjoregHJ76MGKL7AFzczw92QC2t0fDbc0QnI2Nkzr+1sS+iMBLybLVTvl7Q3BVsmQoaCrG98X9fk847YZWz2GXd4XKkC0FVU46C3MYWkF4DfEbHfnXO/iNjRt7zecxyBQcsDY+pR1rhfKB7xRH9LOFINy7hmw8vQCiJ1V7Jg3hjaes14Hx9cSlJB56xwmWaOjUoAm5Husq4nnmU/E+RJy89H/ZHqa39FA9rl59rEiTdETJdNYA6Fenx2KGYRsoqyQ6aNfStKgi7a9sWkceMGT95dnx1eP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CC Usama

On 3/10/26 11:11 AM, WANG Rui wrote:
> Changes since [v3]:
> * Fixed compilation failure under !CONFIG_TRANSPARENT_HUGEPAGE.
> * No functional changes otherwise.
> 
> Changes since [v2]:
> * Renamed align_to_pmd() to should_align_to_pmd().
> * Added benchmark results to the commit message.
> 
> Changes since [v1]:
> * Dropped the Kconfig option CONFIG_ELF_RO_LOAD_THP_ALIGNMENT.
> * Moved the alignment logic into a helper align_to_pmd() for clarity.
> * Improved the comment explaining why we skip the optimization
>    when PMD_SIZE > 32MB.
> 
> When Transparent Huge Pages (THP) are enabled in "always" mode,
> file-backed read-only mappings can be backed by PMD-sized huge pages
> if they meet the alignment and size requirements.
> 
> For ELF executables loaded by the kernel ELF binary loader, PT_LOAD
> segments are normally aligned according to p_align, which is often
> only page-sized. As a result, large read-only segments that are
> otherwise eligible may fail to be mapped using PMD-sized THP.
> 
> A segment is considered eligible if:
> 
> * THP is in "always" mode,
> * it is not writable,
> * both p_vaddr and p_offset are PMD-aligned,
> * its file size is at least PMD_SIZE, and
> * its existing p_align is smaller than PMD_SIZE.
> 
> To avoid excessive address space padding on systems with very large
> PMD_SIZE values, this optimization is applied only when PMD_SIZE <= 32MB,
> since requiring larger alignments would be unreasonable, especially on
> 32-bit systems with a much more limited virtual address space.
> 
> This increases the likelihood that large text segments of ELF
> executables are backed by PMD-sized THP, reducing TLB pressure and
> improving performance for large binaries.
> 
> This only affects ELF executables loaded directly by the kernel
> binary loader. Shared libraries loaded by user space (e.g. via the
> dynamic linker) are not affected.

Usama posted a similar patchset[1], and I think using exec_folio_order() 
for exec-segment alignment is reasonable. In your case, you can override 
exec_folio_order() to return a PMD‑sized order.

[1] 
https://lore.kernel.org/all/20260310145406.3073394-1-usama.arif@linux.dev/

> Benchmark
> 
> Machine: AMD Ryzen 9 7950X (x86_64)
> Binutils: 2.46
> GCC: 15.2.1 (built with -z,noseparate-code + --enable-host-pie)
> 
> Workload: building Linux v7.0-rc1 vmlinux with x86_64_defconfig.
> 
>                  Without patch        With patch
> instructions    8,246,133,611,932    8,246,025,137,750
> cpu-cycles      8,001,028,142,928    7,565,925,107,502
> itlb-misses     3,672,158,331        26,821,242
> time elapsed    64.66 s              61.97 s
> 
> Instructions are basically unchanged. iTLB misses drop from ~3.67B to
> ~26M (~99.27% reduction), which results in about a ~5.44% reduction in
> cycles and ~4.18% shorter wall time for this workload.
> 
> [v3]: https://lore.kernel.org/linux-fsdevel/20260310013958.103636-1-r@hev.cc
> [v2]: https://lore.kernel.org/linux-fsdevel/20260304114727.384416-1-r@hev.cc
> [v1]: https://lore.kernel.org/linux-fsdevel/20260302155046.286650-1-r@hev.cc
> 
> WANG Rui (2):
>    huge_mm: add stubs for THP-disabled configs
>    binfmt_elf: Align eligible read-only PT_LOAD segments to PMD_SIZE for
>      THP
> 
>   fs/binfmt_elf.c         | 29 +++++++++++++++++++++++++++++
>   include/linux/huge_mm.h | 10 ++++++++++
>   2 files changed, 39 insertions(+)
> 


