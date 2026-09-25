Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E50F4C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 13:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3D8C6B008A; Fri, 25 Sep 2026 09:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7216B008C; Fri, 25 Sep 2026 09:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 892536B0092; Fri, 25 Sep 2026 09:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 575CF6B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:20:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4167D404F9
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:20:40 +0000 (UTC)
X-FDA: 85252344240.07.C5451F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id AA6BA10000E
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:20:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a/uR9vXh";
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790342438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NR172yVIih/zfu1yzA8kSDN8MpChBZ8zgP9NIckvtHU=;
	b=Kp2JGUSHT+TG/dvXOTRxLQJMh4/wyT9vuPTv0IfpSUgA9fqO6ksFEHxcf/ZsRhwX1Zx/kJ
	Wkn3y6zvxbs/wHOvSHeuSoxE/6PipQe5usPkZEwUSUExIIAymm5iyROOe0pQnFC7TXODnk
	FWrxAEEKWw4m1eeBmNGxC8Rwjp9fJ1E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a/uR9vXh";
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790342438;
	b=O/gll9/JijURYRRjY+z3QUlZUNhZBXASZFhRCOwg7K5j/BXundDcLfcE9FS+Olwy79Dexu
	hidcArPqLPaDdOc85A5JpHB1ut5IXL0feK4IZBVTiiLjh4BPrd2R+xjMrokCdl4VAWP1ud
	IHAb3mUoyjN7JXoIp5PTQ9lidO5rFHk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D19D342ABD;
	Fri, 25 Sep 2026 13:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A261F000FF;
	Fri, 25 Sep 2026 13:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790342437;
	bh=NR172yVIih/zfu1yzA8kSDN8MpChBZ8zgP9NIckvtHU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a/uR9vXhx9AxJeRoIXw2P+Xo6eJbkLGU0etqDWBpGV6MBGmZwlfcngoU3R65Wk3WS
	 bd8L7pSd2vcI1dis8rUXnt4RbrloYsbagJ+yfzBE7KCHCp3er4QWjxUiX6Hn3pwmEW
	 UqN4/BCOWololLqxWTfKi5vfkHJjQJ4h4N6A2mArBTp4v8vQlwCyCfl7KPFLOD95IA
	 fOE5cVENbX9+0ZBd8PGw6PXoFkC3errgcJRbeWIAdb5wEk8hWH+D3ikmwjuHONzroA
	 9X6snFPs4dIFUezVArlndAMhAtJRvm3s0VkU6oNc+KQmmxw5Y+Bv3mp2Tw4IhBy+Rd
	 g44fFDKG+cCEA==
Date: Fri, 25 Sep 2026 14:20:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, liam@infradead.org, 
	bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/nommu: Reject wrapping ranges in access_remote_vm()
Message-ID: <arZzn0bwWqp7xTE5@gremlin>
References: <20260909064231.18693-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909064231.18693-1-tasos.papagiannnis@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AA6BA10000E
X-Stat-Signature: 8sm7ztqsrb8rkmayhf1578wubzsh1n1o
X-HE-Tag: 1790342438-199427
X-HE-Meta: U2FsdGVkX19ohuABTJltnppQL4Vo9hq/FA+1dDXO6C46/0AZLGcLpav5p6gYaMPqzua5aFUzEYcACKAthKP5jbOdkwNkHP02eHOpkwRjnCzz77DbBDlLXmaGXx93FE3sl3Cdp7G6m5jT8p6hJofdq8SYWo8mo1lu6Rz6b7mQ2kregdGaImQnL8hlDHH1vXGBjpK/jss9469mJ9UVmSHSNv8M7qTdVyeH//sCKo5w63wiydfDrrehNiCFSyXtvF2kh2llijCkzzQjd4U8B3fXx9dZgubB0qkGk/8z7WVy05vDojVl24f4A6USJdPS3BMTbuyRBugQc2S060LV3+4BFxCn5joQhoevwkgl41ZDRYbTHV763ShhGwvElqHDI3VN8JudLvRj89PUbJlxr1ef3TbIHQ/FynMc+MxgAjPX6Od5vzg1/X70k+Itbb6rX15NSzsyeWqHsrS92AOlQRjZ9h692yzR78Y1fbWnd+bqsLXc2IRmfSmnoiG1zd9d/SCUJCk5pto3zU9VFodzryI0Fm1U7JLa1+nQYBEYwZp8yYvbf7yaTm24TCWIIEHUjosLqAHGy+6S7akMRKJ3NSBP2knm1T92MLeYnrg5jgSONjRobTrZvW3oQMBsQhPabK9OH3BgPyCV+E+E8kmizcNqgRUWF/UHWdw+73IDm7nEqXSQN3xBebDXtRHoPKdh3v9LMLcA8fP2OKPdfpzViLT6rxhITvQKzwI7XYmLtnhv0yo6NAtTQ4G9in4jXPFO1bQX6I0Y1YH2K0kVfyb0cWGP6Uh7h96Y735+rRTxUuTEYN+juMtnwtYd8dr2dp4opLtm2KrUxqwIO3DLYXIwp5cw2ylMj4UmVVO1UjXsHfKLZ45wEwvcc6Cn4pmDLixcSi6cj6j4LyBbmntCrI+9QVKjToDR5zrHydR3tYUDf5hZdpTBeCUM3W+NAOTKLDiPLYyF6Zp0jEmn/4tNESWi0p5
 aW1bAJ+M
 9soiI+frstnkQCqrl7F00+fHLXdC9kJ+Wp790kOWOKJZ5uQWjaD4ONF/4iDobYv1niKxMfpgSK8hEDTsrF5PMcWTGQdBO2gSh3QKegg9TE542iX4eCs6gvhOh8/mkZsAO9qXxKvQ8uTvAyG9Cwd7Zv3UfxaI2y4jATlBicL9ODJr8uDZMbTJtG+vglbU1gPR9Uu8oPyXDBNsXtd8cBmPBYi25MzuPfWjbRLe5jBc04HLME4ufVjrBvoFzUFwoAMDX+EOqHLQHSUINnj1RFvz0LdmoQNR8gqcdV7zwc3ms6A0VAOa5S5fpWL5RPz/VYAGa8VnFf2lcChnMRQLMndittW5kM6ul+vlMCTxPHBHADPzzfVugRSkdotB1e8i7EMzTCJQFr4+rIJESL3MDIe0NVp7oON+4KEm1FSxe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

BTW always feel free to nag if you're not getting review! Something things
get missed. (Though I'd say wait at least a couple weeks before doing
that!)

On Wed, Sep 09, 2026 at 09:42:31AM +0300, Anastasios Papagiannis wrote:
> The NOMMU implementation of access_process_vm() rejects address ranges
> whose end wraps around, but access_remote_vm() bypasses this check even
> though both functions delegate to __access_remote_vm().
>
> Move the wraparound check into __access_remote_vm() so it applies to
> both entry points.
>
> This is originally reported in [1].
>
> [1] https://lore.kernel.org/bpf/4ef240a5bea36ff84df9589671367832860795159386a4c8fba546a0fa8b786f@mail.kernel.org/

Probably better to drop this big and make this a Link: tag.

>
> Fixes: f55f199b7d76 ("NOMMU: implement access_remote_vm")

Cc: stable I think?

> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>

Seems reasonable to me! So:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/nommu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 498e01ee40b0..ed44510e3770 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1674,6 +1674,9 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
>  	struct vm_area_struct *vma;
>  	int write = gup_flags & FOLL_WRITE;
>
> +	if (addr + len < addr)
> +		return 0;
> +
>  	if (mmap_read_lock_killable(mm))
>  		return 0;
>
> @@ -1727,9 +1730,6 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
>  {
>  	struct mm_struct *mm;
>
> -	if (addr + len < addr)
> -		return 0;
> -
>  	mm = get_task_mm(tsk);
>  	if (!mm)
>  		return 0;
>
> base-commit: 0d9ff90a5422cc7509258aaaba1e7481df4d332a
> --
> 2.55.0
>

--
Cheers, Lorenzo

