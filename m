Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32EAD606A335
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 23:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=irxaE76T
Received: by kanga.kvack.org (Postfix)
	id 2F6446B05B2; Sun, 15 Nov 2026 18:27:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CE3B6B05B3; Sun, 15 Nov 2026 18:27:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20AFC6B05B4; Sun, 15 Nov 2026 18:27:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC3EC6B05B2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 18:27:49 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C54F120816
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:27:49 +0000 (UTC)
X-FDA: 85438943058.07.0EB7FFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 775BD100003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:27:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=irxaE76T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794785267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4e2r44nu6mA3b6XLEZGRw9TnvEFy49nMx0rS5f2LA3o=;
	b=2tfbI6Bmp2TfZkqc6s+vbVOU224bmtcvmaQlVYowsxHWFVs+PLK1WsXAFz5jbl8PcJxo0o
	NgzovFKDLKv7HczwqK23VE/2iJfS2yazkwVNdQuKxYc+j/BN6OYDbMeb1Hd8CNmkZJN4SZ
	qgJu+FKugrCNViV6JLdr8o3mZ7J2q8U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=irxaE76T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794785267;
	b=6iJqY920VgfT6ptCHB3nNQNsJIF7XAoqFappPB/CVt8KdBjAYGQt3z/dp2kSAiABuAn0D+
	eIaVJdGsH49T5BGXMTvb/mOXnf4rMoH32/rEGGzwNly/DdXSRZqTNKYuQu9kMkjQ/O5VCe
	040v/rfr6Jc0gsPQ+W/zcjdo+Mp74nY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BF1245A76
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507B71F000C9
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794785266;
	bh=4e2r44nu6mA3b6XLEZGRw9TnvEFy49nMx0rS5f2LA3o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=irxaE76TZjaVoncSE9tYDvA035iKo0NS6IFrvq0soJjDMJcqKfUabYXayabxsA11J
	 qu8i1rWFTkh9fdw0DsuLmkjq1imog+nzXDJXFowNScocCCuYBBEqn7abpRKOdQ6MdY
	 7eaLXm/kawL9b0IJwxHVioB12iKCTVIUVLJ0/BBrDp64LXvByHLKlAK9ipEuP538gv
	 6dBb33RlpplulWrSbLviKV+2CIL447/faQzIGAUxjn2PQtHY0gbtTVgCprgGSeO6vk
	 N4X+Qlq0F4PuJgnLeLlRlVkTuqhU8yNi1cdgKlDpmH00fALA4dBQ0oPcopZXHVzkh0
	 PTt+JKVVmWang==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9497a167a6aso53208085a.1
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:27:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFa8wdJDBNBEZIOowk4jL4js6xjw9xo5IcykTNFXB4YLrudQlk5AMbVkJR0eute+Mr08wM8K9lJbg==@kvack.org
X-Gm-Message-State: APuU4Z8hLHlOT689s4YxmwmStCKMd6mIrtPmb94mukmmjRZAMvB1Qrts
	7FByyV6zVfCMCGryQc36hz3ngU8s+zdDK3FkzbUUQp0YFpcN81jFo+hVriBSM/ZEeUvr9TsrrkL
	wE1ojY9sp6yh7ruquqbqa4SRDTKKatPk=
X-Received: by 2002:a05:620a:172b:b0:949:6f45:8244 with SMTP id
 af79cd13be357-9496f4590bcmr630546285a.40.1794785265663; Sun, 15 Nov 2026
 15:27:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com> <20261115230231.21194-1-baohua@kernel.org>
In-Reply-To: <20261115230231.21194-1-baohua@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 16 Nov 2026 07:27:34 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zrBrNGa9Maw07s7DCSYc1VHM5-46tb6JiTom4-aEQQyA@mail.gmail.com>
X-Gm-Features: AclHuK-BHmlNrclwISN8ugTRlIUZLjtm3btle4oaGFFiLuEic3eqQoXD008317M
Message-ID: <CAGsJ_4zrBrNGa9Maw07s7DCSYc1VHM5-46tb6JiTom4-aEQQyA@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] mm: batch TLB flushing for dirty folios in vmscan
To: zippermonkey@icloud.com
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, bruzzhang@tencent.com, 
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	weixugc@google.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 775BD100003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: wpco6ejqxc36f6ibds3n4t6pxeje8kkq
X-HE-Tag: 1794785267-102502
X-HE-Meta: U2FsdGVkX1/Z0xsKRa67dT05ROJyswisa6u2H61wbLiF4augUrIe/b+qR6OTExBHYGKLEgi/5zRDNv8elwhib6rEeaXr4bJsmMvuslcX04pzrOQYvjtriyAE2s9LU7Rifq4ya60eGWRHWawlW2lS0gZvkCwf7XHouwSCCPdSlLtNBojgBfyB5ynLN13awJ/NkM029WssO8ZCCpPDtdNjPcthMBERzNRRE8iO0LkFwDlSYYBqiXOOC35DVm+28I3VF/kR2Cy4QguwIn1fiw9XwkIyXiHA8tUMRHNCqGic0+lrBVfQA+TX+SBWF9S+stxEwliYr89jMXhEPxl3fifJDQ8iYsmcA9GgLxQezxU/r8yhiph9LYioAyFAX97u5C57o53Toiykz5+1sY9zO3tDEEzvydBZ767ofenoH5UEYI5o00dXuAx3/j9ep+kxB8MKkOh3tCf5xwTPqnQ8KBdcUNrzURqQ2jouahcbM/K5pr6Voco7Zs1t4+xPDFl6lxTH7QCKOJ5yaHGw92gr1cp753ZbWPWTyOhyCCpXeCJ/prJyIMEAnIDKymwL9zNC5T95hTeIpebQzJhu1t0Jl9bxoxkPlytsw6h+eP2DBLp8ELW01k0BnpembpJubp065v4uAXi+lfCnpRkbAHtEmitsak/KoImZod64QJDVDnmHERMBEH3SNg2r8SXCT8OxIM4EIiqhKKV0bXDg7xWfrdtLKn1ypa2Dmk4BRMwsDSBmTuQkCcdoBgq0iKbsVBlZN7ZFSzS18wlktYyLU83R1t9cZVhwZnJ0aBCs6UwTnIYqWSdt+xOdQFXVUUnQW+KQyqMHZwsWtIk92Vq+e+pdxF7/6mkUAX9J4tItp+B9Xmt5Oz6+PYwgPocdtX+9zQ9y4a8zlxomJ/IztNwdyuDoUq8aiyfQaChOnvj7QLPHH4Lu7b+jHSP16NVcteF20G8oKlZVX6kBAeS6aFT5NRZflqC
 a9K0H3fx
 C1S97BwOmo/0m15XgS+TgHFS9/Zhr6gCKNOhAQb+XQqjIvyEjuM8526RShLYDE/NFYQE3dVxpJWIUV+2BfrltfW9ZwqlIo1OmJZP8zGFe9/IVkpajL7TfqPTtzWYW//LsJtmLo7F1n1F2+BAXEh7WusgbjxEUraB0uhoS+KRkCJJNN2HRql4it0nxtP/yEfUUcYP3j0l3kyERCZbmYasQdLJ1UqoczAGc/RLc8hCnuciMOgdy90dFWqFWr5flQNl4A4mkiW8JM5KjNUOqX9way9JLLRWJXJXfQhDu9jFh1937yE1EitbQWb93uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 7:02=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
[...]
> > ---
>
> Hi Peng,
>
> Just a quick update: this patch is still on my radar. I ran a
> quick perf test while building the kernel. Without your patch,
> try_to_unmap_flush_dirty() accounted for 1.75% of CPU cycles.
>
> I guess there could be workloads where try_to_unmap_flush_dirty()
> accounts for an even larger share of CPU cycles.
>
> # Children      Self  Command  Shared Object      Symbol
> # ........  ........  .......  .................  .......................=
.....
> #
>
>      1.75%     0.01%  cc1              [kernel.kallsyms]  [.] try_to_unma=
p_flush_dirty
>             |
>              --1.74%--try_to_unmap_flush_dirty

It's also worth mentioning that 1.75% may look small because
most CPU time during a kernel build is spent in GCC. However,
relative to shrink_folio_list(), try_to_unmap_flush_dirty()
accounts for roughly 10% of the CPU cycles in my test, which
is quite significant.

The following shows the CPU hotspot distribution among the
functions called by shrink_folio_list() without your patch:

swap_writeout                 56.93%
folio_referenced              21.76%
try_to_unmap_flush_dirty       9.60%
try_to_unmap                   5.10%
folio_alloc_swap               2.80%
__remove_mapping               1.42%
free_unref_folios              0.46%
Other / self                   1.93%

Thanks,
Barry

