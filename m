Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3651CA9ED2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 12:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03D5A6B0088; Tue, 13 Oct 2026 08:30:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F30776B008A; Tue, 13 Oct 2026 08:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E467A6B008C; Tue, 13 Oct 2026 08:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFD4A6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:30:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 53EDD1C4623
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:30:08 +0000 (UTC)
X-FDA: 85317535296.02.983CAF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id BDEEE8000F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:30:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mlnL/hy1";
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791894606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1KVneCgXArp9zppiaGo3yxvYAKNVn0jTmgz8OZUh50=;
	b=Vx1IeoBVXnyQotwJA86L84dmHvM60KTQ5nC+133p+sB4boEJb+MC1LaJzgN5ugMGVnd3bB
	9aA04nWPD60PNQxGG5apuFlt3uSOUNU0WuQ/bUSDLMGI/qW48o/KVQEnQFtb1Vorp3dxYG
	CRpp+0D47FQCgCvr6kVz8CjrzCE2e5s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mlnL/hy1";
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791894606;
	b=d451lRo+FBOyRQ/zmup5lwAWcfo7Eseqgx6I5BK4XnBZ4UxF0zL2PTiNKX4Lc9MzyHz6Pp
	zxejoZGsOnfPlMh8YnrEl4RZuN4HlbIFWdvtYOz2Dt2p5e+28kH/LADJyAetVL+PjiO7XR
	htfCtQq8tfHfNgiy2N16I5zHwwWQNJg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 32B1A60A5E;
	Tue, 13 Oct 2026 12:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B6A1F000FF;
	Tue, 13 Oct 2026 12:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791894605;
	bh=W1KVneCgXArp9zppiaGo3yxvYAKNVn0jTmgz8OZUh50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mlnL/hy1yfvWUPlwGgRpNziga7S536l9AtbIIdBcPDHXBeex7a011lJvl3QJXrpMu
	 nq6wqtcldjoLyPz/FTp5XqzlgoJgG5dWHc6bsSDy+MEx+ANP417gSJh5G6lAcq1qRE
	 6f1EwkqpiyhFHQPbIWhLSgacm20PByzywuye3tWz8c5fpvSku3CQ3mPKQEE1A7jZqQ
	 6S3cQIqOGKQtxiRTQfcwm/VBqUHillXFZ/xXLZikhv5ezLwt5GHzxb7PkJXR5WFmYG
	 dfM42lXX+JVdBLra9GjTF9b+Q/gRT0T8qG8h4w/Wqq6+Uv3PSm4KDYkOqBR/aF1IQY
	 MLoI8E6342m+Q==
Date: Tue, 13 Oct 2026 13:29:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Benjamin Herrensmidt <benh@kernel.crashing.org>, 
	Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>, 
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm: disallow ioremap'ing ordinary RAM in
 generic_access_phys()
Message-ID: <as4aeYkqZywLo4Gx@gremlin>
References: <20261013-generic_access_phys-v1-1-b3963ef76e37@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013-generic_access_phys-v1-1-b3963ef76e37@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BDEEE8000F
X-Rspam-User: 
X-Stat-Signature: 3pr38ik1z44foym8cyr9bbkcgmh4g7m3
X-HE-Tag: 1791894606-698875
X-HE-Meta: U2FsdGVkX1+9Q5v5RM08DsImc1A1QEBvH4arzaGKXNcPKLJsGdG4EKI0zfaH2quH3qzRo9SD/Z1732Ie64qcDCHYx/xQQ7RFS9N/7pfmaiYQAtf8ssOVQVu2Zey8Nm/LAq14BoTc97z1U32+T4Xz4FjyUAq7vOznsUUgTQcBvHeya6//qCIkHOlo+k5ycc1qfZGyjaCBGvbQZrvb5BD69EgxcmbvdzXCP7vq/hUpVfLDPxThZwreDthTqsvbHRFjT356WMg7FwtfStZ3nwLYi4KTiAOk/0cfeD9+N50bdT+bapk3O0b3NgA6H43qlwcwpfqPsv91VKRIv3uzSuruWNjTFB3AgT00awnHvUwD0qiJf0OeCvW+7NhAvNXLzTeJWpRGyk4V3TM2phQuAumv6bivSVSJ3ex2ye2ZVelugTFyaDf+5CFUdhdtlbHJzoaMcGLPH8DO5E3GgbjVZ8LEW+b1AkD281dryCEzjlVarIOnmv2VlnmZA4R9hX6Xm+IAA4tZig4gDYF7MtfeyXFiRyYIABQ5KYo5p1z6Ye7kClRI9vYPWhfrxLuloKcthFBK8EOC+PY5sTklfhA4NnZFpXgaqsYW2sLZyHBV2JZds3R+zb4PtdBZYmmpr7S3iqYZK63uuFn63wiVIv7e0vcZWtvAMNzRH+ysROvn2ioLrIk3/nuJzCciqdzi2ODT4Menu7d9TOtIBLK3N9f7fzep/dPHqCacn9eQ2QXPVCX+Q21YEHgacmZoZ1VpLCkJ04VxVCro3CmzlbW2oolJt6yCF70PL9CH3bS1c72h7qG24fM2cBIqMEyAzqHz+drCB04d6vNRPeU5yZPvAXL/PaZG9w1jkp2m2Lj0UpMQmVEAKii5MgqBCgtoNIp8YhwH1VgDzwlyJUCHC/TDs/LGSYqWkYU4G+/o1Y7SCG8S9ZVgMAkb0IvFTE42LB/V/VP1S2ruN+K9B4nA9+sWHZN/ZP5
 ly5+yQBZ
 NlWt+115L3CB8LW/qhdSNLydVuDwOkk5/Sp6++P9+HItnMSl8h1VJ50faEfis8IcSX5MbnivMcYyiWzXRhWqx032Tq0F2d8XDXtYv+MtoZrh8AWB1BamInBZWeo/dWVLE9a3D2q7rXZKLv938waZngVCygRyqhcaBl/uaZbEYljt5w2DodOZVA6mEMExSzj7tSh25nIgUwCqdfZZ9Y0vdtRRFhdbT9GmuVWTGhMXrsm1hD6gYOYwgXIgPK0FPjpGDDoq/FCseI/JkzSqBwCCXP5eDcRdHPrQcQIcgBtkokv5oh1qhwK9Q6cXD7btmIFXhDpp6iZB7Tlvs08jBwcqbt4ONcrb46OlqXm2NYxQjpdqWYCYed6k2f2Gbk8GAQSCwj4xBQlMgDGf82RsSZbC+YeNjYXf8gnKe5qCRyOYyCZ5DgUF1PsyOK8toLlkG8kUuMDCv3KraSGoGI4LDQzx0lvPv2GRyLDRDYW5dcgjrRWyUyTIbudHva4s2YWpGN1OzfEarfxi7btoDqKcWfpyiNBp8nxcRq9sKSHCt3see/GdzUmJZDXVKD0afAPpjMaakvz8jvBHxwTb7cllhHVF7MIJFHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 01:41:24PM +0200, David Hildenbrand (Arm) wrote:
> generic_access_phys() can end up getting called on CoW PFNMAP mappings,
> resulting in it trying to ioremap anonymous folios, which especially
> the x86 code doesn't enjoy, and which is in general just odd/wrong.

Ugh god.

>
> E.g., with a CoW mapping of a PCI BAR:
>
> ioremap on RAM at 0x0000000045623000 - 0x0000000045623fff
>   WARNING: arch/x86/mm/ioremap.c:216 at __ioremap_caller.isra.0+0x4c2/0x5f0
>   Call Trace:
>    generic_access_phys+0x130/0x4d0 mm/memory.c:7178
>    kernfs_vma_access+0x1ce/0x280 fs/kernfs/file.c:437
>    __access_remote_vm+0x58f/0x890 mm/memory.c:7256
>    mem_rw+0x2a1/0x670 fs/proc/base.c:912
>
> But more generically, we should disallow access to anything that looks
> like ordinary RAM in the system: including allocating memory (e.g.,
> alloc_pages) and mapping them in a VM_PFNMAP.

Yes.

>
> For pages with an online memmap, allow only pages marked as reserved
> (PageReserved). This also includes memblock allocations, however,
> distinguishing them from other MMIO is tricky, and nobody should really
> be mapping them in a PFNMAP (except someone abusing /dev/mem, which we
> do not care about).

Yeah I guess we shouldn't try too hard for weird edge cases, or at least
can revisit it later potentially.

>
> So only allow access if there is no online memmap, or if the pages are
> marked reserved. Reject other pages with -EINVAL.

Seems reasonable overall.

>
> Note that, just like other pfn_to_online_page() users, we won't care about
> concurrent memory offlining; mapping memory that can concurrently get
> offlined is highly dubious.

Yeah sounds like the user would be doing something crazy in this case,
therefore their problem!

>
> Reported-by: syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=49b1021becba70c1f3f6
> Reported-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
> Closes: https://lore.kernel.org/r/20261001152524.171115-1-ngocthang2710.1999@gmail.com/
> Fixes: 28b2ee20c7cb ("access_process_vm device memory infrastructure")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> I went back and forth 10 times and concluded that using PageReserved
> should be the right thing to check for now.

It seems the sensible choice, yes. And locally, AI review agrees with you, FWIW!

--
Cheers, Lorenzo

