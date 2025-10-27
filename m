Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECE65CCF9EE
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 08:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46E4180023; Mon, 27 Oct 2025 04:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41DC48000A; Mon, 27 Oct 2025 04:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30D3C80023; Mon, 27 Oct 2025 04:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19C278000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 04:42:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8C20488D1
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:42:43 +0000 (UTC)
X-FDA: 84043253406.27.55956B1
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0CA91100014
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:42:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZzCUMpk1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761554562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S8OiplbvxRK3PGzaWxhrNct+/g/8F7ug0XbeVAkGeME=;
	b=Bp6donjUtKVHef8nAaB8rPynz9OyMR3EXXKMsR2odtexW4dlDGLde1K19rFz9jI4w/z/+H
	FCsLTvtAh4Mm4+i+lW4JSiRblCmK2RBKxM88YIIGLoaHg06BqKtrbttRKnz63so/kGSJF/
	zv4fPm3zT17a7yjUmfgKSqLHUqRVee4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761554562; a=rsa-sha256;
	cv=none;
	b=hr9RrOl477o48ul+ZvDfnmEsR6GBDaXVx4GS/td0+j5Mm+oj9DMW0B2XrGRMmUU+uLU2pg
	Z5h+sv2KfS4Jom2sWFc3JGq+dQAMNTCJ1v+ZdvlJqbz0hdm+4jbK8Uwx2AIrQnc75femcG
	83ccu7GX5OhCHtD8htxzWuMO8kFgmDI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZzCUMpk1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-85a4ceb4c3dso421834985a.3
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 01:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761554561; x=1762159361; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S8OiplbvxRK3PGzaWxhrNct+/g/8F7ug0XbeVAkGeME=;
        b=ZzCUMpk1Vi697mlMKYa/Iq201WixKefCbUbfmeSe81Rr/bKsdQFTx7tCY1STo6mGYZ
         e88zZkBxdrbFLdm5MyBG5eLbRPsjGKJGz9Utzc+NxY+8E2Rj7Dh0QOQMQEfrCYkvSkB1
         t7fUNqMb/8AwgJYRi1TGyS+Mo5rOVDtKW/aIVycwvEHqMXWp0tnC2Pmx6sytDAuBz7RV
         i6jmBOOeQCD3e6QTqf6p/nhzIg8Wam+HOr6o46eSOK/iQr6h06PuSx7F+4pBxWhVHZNM
         KjYb/I1fAHyUv4Q8tGSfx0+oPeXKFFQoZM4JrylBPgJj011aaxRkXWXowjaWgS7T/3Sz
         mYcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761554561; x=1762159361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S8OiplbvxRK3PGzaWxhrNct+/g/8F7ug0XbeVAkGeME=;
        b=m+a5J1spYDE3EqZmYTDxECrCSND4H1Ruhskt1Ur/UGyKvo8D2Bjp5g6kqjO9d+0H9Q
         91RaEPUMVEqgsFrWwwIDZkmkDGA4Fpfs32LIhm9uY2pEAksMx6fzI4sr3TcasunQsPKV
         1dbI5x9+1PBSkgDnlzGXjFiEloH7bnky62821anJ77kqAKuXwSK1q+Gh0oGgGZo9lQ4d
         AkHh9qgP0BrmZsS2Hk0lwYV+uX+nTN5y+gA9D23wC2e3II+skwkQdPsZt1c16oD9YtTR
         cbE9ZkcKJNUrTvcc/cW7W1o9vFp5qcekeKIm1/68MocmoipoxrvDcNujjX7WTmboP0Ab
         wgDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFaW4nMllZZ1Ca8a85rz2Z4PkLcFl9vr4r29uFU4ajNXViW2L2ntS2WLjM+6J28bc+tFUCRpD6UQ==@kvack.org
X-Gm-Message-State: AOJu0YyRUZmbe9yeL7CejmdzfQXKir51UgwsnO+WQvRldRHe8aNuiN+b
	Wh1fAw3FjPgnwOfbIjl3kmmxjdqDv/n2hlygBuyMEIrD1dkQf4iGlufsVbNOnQ3pS9GlkgYHBhV
	rgQ1v6slL5eEiiSxftnogdSQGXPFncy8=
X-Gm-Gg: ASbGncu+QS7S3cKUCHfqLJAKzDbHfvP7gdRWujaRw+CwTOxpZ7YZyDJSEhjNJFd2iCF
	KTVj0BFS9UD3cK0eLw8JUCkEYdvu9wGGQsPSFXJdnxaZ3241tRR8KdOQW3mPkOyZAzoLnLtARuX
	jZRldrSx7ZH2lQWLT+26nJNmB9KwFkKhKVxWFxH2sR+3xIr8hM4q43lKChNdg1NlWgiY90m0V4E
	cm9VogIz00YA6gjkgp9ZXeQimBE5nbHa39FxpDB7p0Cyj6YI2fKpkWx8yWFYUenPI3kprjxDf6X
	pYnmrBP+lfPC3T2lDM58PerzKQU=
X-Google-Smtp-Source: AGHT+IFX+mR137xrvZDcqT/67/gVBqUrAWDajbuXrFM2dAwerxuXEYH48nepHi6uQYXhfp0Am9+yzl1UMhOb2c+aXlg=
X-Received: by 2002:a05:620a:294f:b0:8a4:6ac1:ae9 with SMTP id
 af79cd13be357-8a46ac112f4mr279316485a.3.1761554560864; Mon, 27 Oct 2025
 01:42:40 -0700 (PDT)
MIME-Version: 1.0
References: <20251023013524.100517-1-ying.huang@linux.alibaba.com> <20251023013524.100517-3-ying.huang@linux.alibaba.com>
In-Reply-To: <20251023013524.100517-3-ying.huang@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 27 Oct 2025 16:42:29 +0800
X-Gm-Features: AWmQ_bk9pI0TtC_0goeD9hHvk9ke19jrv2VrqxdCfcyf-qPwd6ST0IlyubPCsHY
Message-ID: <CAGsJ_4y46gUWNR_Gc8A12UkTPybR=dc-1vmH_f6WHEFih-CqnQ@mail.gmail.com>
Subject: Re: [PATCH -v3 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
To: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Yin Fengwei <fengwei_yin@linux.alibaba.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: 3wt9fbw5z3k8t93rpcdkti63ookeujjn
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CA91100014
X-HE-Tag: 1761554561-793952
X-HE-Meta: U2FsdGVkX19AJYju+Xnh3JHr1HY3XjEpvRHyNdS6WEePtsXdQXrSL7jJbUHh1/M09kinxQlJeWpGkHDWZa8IaeozE4I+FV4uQjgje7XUUYzMDjnaLTDIP6Ne228VSjeeD28bMdoJyyv6M76O+pdRJJYw5imCotGJAM66vA97O/snugan0lg2Q8MvUPLTjCchJlR/RYLC9fIQuC/JwGyzqTRgoBYCFkaZ2Arxw6S7T+hfDhxAHDKQuUKrEL8GngzmJ1Pkolq7ukD5ADsyiPhbsnegbCfGVersDgio7wL2DPs9jqOHFZLKr26tF3za92K/BQCabsyzH8VzAauEI+X7TIdbliCGVyrOzdoniMoM31J77zK3FkcgUS9Xis9bUHUjwaCahdK1xIXsMiI/o+u956hMOlpleHZbjb6KvBwCN+JI5RIcPUlCPaHMZCocTgvi7yX23w4SHwsxjvpAC2S/KqLN7A23UW6m0dvDvlG6LqucxNrXkESN9r2SieEPcO/CyM+lssidQ0pAIiPGOdFRG9FHbXUmnCCP0D/P1EVFXooTYfM4WT1z2TDYpp7QU3uSYM/VPGvYpZn5zxfXEKd5WQoed0LBQh8gD2Y5ETjRDupUgZyXSXiE3/ouBHADKFN9aKfCe5Mid6J3zXkT06CLQD7rhulayGXlUXijDYmdXZD/dKiJ7xj59HcjXS+UkWLTSIoQO9FtNn/Htxn//xFEfICUao/8pL61mC2bQkw/2ZPmwmjsR5XSmKidWLw+CC1t2+dpcwHpM5x33zIyn30HKP2sIDL/ArSvtdR/xGk0GPcJw9wXytw8tcp2HgxAq/xKLefhHxlDikF6oPup7yp2WuEfvKduOHJXIpR76FPPvHwWqwbwasvClZhT6QKYZHVLLZKCvpgAQdGqI0MDB2GYG4CL/h1akB+Es0OHaU5LVqZdl6FJpAt+pQfjbxx/zCjrA70gyuGkOu1a05f048u
 DUJgxH+a
 UMXuZsjc8DewWsDIR+79FGoCS9Wa+PL/y/cJViKVsMb5mZ6bSB3Ze9//p9BWdsid1g44Wr2zlYbeDFcQmyzIxoVf+/vcXKyhGmCDQMsvpnGU71bxOTTqDwfjqrk4Q0fCa4nJBh8hy5LVZ6bsDMcRmdC2VOmfQkChxLPG+VUpEvh/uKnBHlaINVmt+aUKstqJFo70Z4mmTCbaJCo/IN2zYun15MKCvKoe4mqsLSbKaogHlvOmJnnJHxsU2/AO4WlidyghKfJdjzng1ik88PSIOgeOwLSnbjvZeROmUO6wpAed6qqy1Ll6GcDKc2Uv2MXJlk0vSPoiakuKsZWzsiTuXfhPwLmBb4gnej6CarkN8pFSDsjf1nTAbw/100gI1BxsO4xXxSyVmttcFvw28l+oNgBv+sX2ClRcaNj1vmf4/9VM8YuwufAAuNRW9NRyJwLQvH1o/EnCyvQQzm234Y52jMOFpcKdX2VdLjihRK+6YrfFEP2GfQAEvJMSvtWSgLueBZ2wRBOv9MoyqLNHar4Vg8ji6/KIBv9xjOxFqN8bE6O3N+Zp6dVxpogbUM6TZj8Yv62QU54k9Cr/c2hbAJ21TWlUphXgfp+FRrEexP51RLKxliId1+kEnq+/0NXLcpqFGuTP3miCmfnsRq+zpzvnOVlE7ih/SkGn8P5xnQHjJvI8JewVCdWKJqP9WAYeyukb+k5sLWzFL/K53gPGEkrPIoK7q3LNCL6GvdWxqgFx+xKovph1dP2EIxN2g9tFgHtq9ySW973iwmKGxVRCUe2MZF8fJHuit8wl7cY6gIvj2J3MYLmF/O+dpOgPvoMlpS9BzaiYnQVNJVgVDS9RmL+d1FIR2/3Niy4L/3mUC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 2:23=E2=80=AFPM Huang Ying <ying.huang@linux.alibab=
a.com> wrote:
>
> A multi-thread customer workload with large memory footprint uses
> fork()/exec() to run some external programs every tens seconds.  When
> running the workload on an arm64 server machine, it's observed that
> quite some CPU cycles are spent in the TLB flushing functions.  While
> running the workload on the x86_64 server machine, it's not.  This
> causes the performance on arm64 to be much worse than that on x86_64.
>
> During the workload running, after fork()/exec() write-protects all
> pages in the parent process, memory writing in the parent process
> will cause a write protection fault.  Then the page fault handler
> will make the PTE/PDE writable if the page can be reused, which is
> almost always true in the workload.  On arm64, to avoid the write
> protection fault on other CPUs, the page fault handler flushes the TLB
> globally with TLBI broadcast after changing the PTE/PDE.  However, this
> isn't always necessary.  Firstly, it's safe to leave some stale
> read-only TLB entries as long as they will be flushed finally.
> Secondly, it's quite possible that the original read-only PTE/PDEs
> aren't cached in remote TLB at all if the memory footprint is large.
> In fact, on x86_64, the page fault handler doesn't flush the remote
> TLB in this situation, which benefits the performance a lot.
>
> To improve the performance on arm64, make the write protection fault
> handler flush the TLB locally instead of globally via TLBI broadcast
> after making the PTE/PDE writable.  If there are stale read-only TLB
> entries in the remote CPUs, the page fault handler on these CPUs will
> regard the page fault as spurious and flush the stale TLB entries.
>
> To test the patchset, make the usemem.c from
> vm-scalability (https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-sc=
alability.git).
> support calling fork()/exec() periodically.  To mimic the behavior of
> the customer workload, run usemem with 4 threads, access 100GB memory,
> and call fork()/exec() every 40 seconds.  Test results show that with
> the patchset the score of usemem improves ~40.6%.  The cycles% of TLB
> flush functions reduces from ~50.5% to ~0.3% in perf profile.
>
> Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Yang Shi <yang@os.amperecomputing.com>
> Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Kevin Brodsky <kevin.brodsky@arm.com>
> Cc: Yin Fengwei <fengwei_yin@linux.alibaba.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
>  arch/arm64/include/asm/pgtable.h  | 14 +++++---
>  arch/arm64/include/asm/tlbflush.h | 56 +++++++++++++++++++++++++++++++
>  arch/arm64/mm/contpte.c           |  3 +-
>  arch/arm64/mm/fault.c             |  2 +-
>  4 files changed, 67 insertions(+), 8 deletions(-)
>

Many thanks to Ryan and Ying for providing such a clear explanation to me i=
n v2.
The patch looks very reasonable to me now.

Reviewed-by: Barry Song <baohua@kernel.org>

Thanks
Barry

