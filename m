Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 524FACD342F
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 10:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B8126B0005; Tue,  5 May 2026 06:10:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468EA6B008A; Tue,  5 May 2026 06:10:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37EA56B008C; Tue,  5 May 2026 06:10:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 286CD6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:10:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BB9D7160352
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:10:48 +0000 (UTC)
X-FDA: 84732947376.05.C1F9871
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 043ECA0011
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:10:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l8d5dD7x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777975847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WwFT7AfVosr+kg8Ne5nxD4AoR1nCPtuTQOnTZxomO+8=;
	b=TQ/WOQgZXaVLTZf4Wo7c2n8lJmFT3FMjyQnL0/5gROP3o9/b6jA4Sncwk7WPmsEVQVoZ/Y
	v+s1zulNSwaFXoCdgTgDo03lF1OOgYhTAZdUbw2fk/WXPQ02EG0vVSNmfFt643c6IpGXbu
	Pg4Wxg0eYauWYOWL0hEIXlMSD5FpyZ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777975847; a=rsa-sha256;
	cv=none;
	b=OI5wLAyyHj5dsgxkTw3/krS0vdy43WLQqEfVJvZSRuAjf8xpwfFIAmP78rkTh01obAgSSB
	DFvXMDU/8HnXa4TX2j+jounxSAnhfJpHPN4E9TuWOhLMPs5I/1aCBnu8Es1pPkLJFfGmb8
	CuAMbJN61LknNhk8MIbXMRCdYD/2oQ0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l8d5dD7x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BAFBB408B6;
	Tue,  5 May 2026 10:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535BEC2BCB9;
	Tue,  5 May 2026 10:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777975845;
	bh=d8zJj4KQwNvVaZUWE7Gf1PYyAbDyUzahxPz+7fxw0A4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l8d5dD7x24SjKGXE/Xq1Qvp9eEplBYpU0UaymvU7snTL5H5EfPX3nDhPAFhCk3pqN
	 62g1BMrf7GhAbnP1VU8sbH+ZrwxVBip6Bn+x+wcB7n4Ap1uMwpvVy1zjFWUsG/9W90
	 34ZdRlhrUegm0yEkzz7ZRKyc+auISoxop9qRLW3RcpARVGBOgTKrDqe1gV9erW0fuj
	 Z8o5PeruxWCX3lT756NTIdrGwngrK92z1gjqwrvlANAb6hjyh/lHAtCUDQC50VbfmN
	 aLEZWomB+MGOgwKQBNXGTk8FyNQyey6+rrP9s7HIocsUgml2a1YW74R6B7588fRZp8
	 b5pHlGPivQQXw==
Date: Tue, 5 May 2026 11:10:40 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: "Denis M. Karpov" <komlomal@gmail.com>, rppt@kernel.org, 
	akpm@linux-foundation.org, Liam.Howlett@oracle.com, vbabka@kernel.org, jannh@google.com, 
	peterx@redhat.com, pfalcato@suse.de, brauner@kernel.org, viro@zeniv.linux.org.uk, 
	jack@suse.cz, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] userfaultfd: allow registration of ranges below
 mmap_min_addr
Message-ID: <afnCAnLSDXnLRhLq@lucifer>
References: <20260407081442.6256-1-komlomal@gmail.com>
 <20260408123700.1596800-1-usama.arif@linux.dev>
 <addcUpxfuR2llaiW@lucifer>
 <408fc657-94a2-4832-b5cd-7013c002403d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <408fc657-94a2-4832-b5cd-7013c002403d@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 043ECA0011
X-Stat-Signature: moamr44fcem787dux3yaa8pwkws6d46o
X-Rspam-User: 
X-HE-Tag: 1777975846-187255
X-HE-Meta: U2FsdGVkX18/3Rnu+G+MBUmQaDpiSNskvrHAoBTwiM3XhLDlfVfzxiz4l/WWKsDJF9f96P0egoglSrrmpJRxhlJOnS0DsILnr9fjQ4rX+fOkGJjZ8anKr6ABsLqLeNH5zX40TIE+SfrNQP99osxFeEsDHvbyEcjSdo2vMxSfFsfKObhgJqu1q4Opor+B/zRiW64Tf+N+O6s0Cv328tK8rxA2i3XTxasz5dYTiumgTEQ8ZZ+etaDOdyJKKALfhrHrMCKOs5TvsoG3Og1JE4V8IVN/MMTn4JZ5avnMOzAm23TBoutXOe02j9IhyBx0B0CiS6I9NMUX5CKoWBJxxE1ft0U3q9NQwjH/5PXs8zdPKgJnkm/tjFoYQKXom+DpytkkX1PS97PnnR47/b70+K3tNcyQonSG/E9ighW0vAqH4vTBK3C0w1KlzYVVUGgramnmJP3LyGtmax6nV10nOF81S4UDu3dvNTWGjE6J60oq5dWhXjgr1xXkcFUR81S9v6SSlRwu40nfhpm/7G6pFCHwqjazxRBtQimCPukvVK8qYErJNt2St9TWueNNfHfoWP04a74sHVx3f4S0VVduNeoXh+UznvPG/RUruWjsNwx8t4us1RQHSn3H2NrRyOd94+k0psKn3wquMtmSuvWoDlXJ5eF/D2mAclQnlJdVZDAHWOObcQiafvNUjG3ZJa8DsTmT7xM5XXhvSZaXmzu7gQyxvwqdAfm/INOxbB5TQnIs5JTzT2LPw5KuuHsSjzzaCmdFqlaN3bNRyE68lVarDIHUv8HdL+5Cq3Oo/YHPLTj7UILZsW1+eEYsWyglO31gF0iUuX1TqwEuRalCznCs2Mm544dXc0d/2Ha25pLJvKVLM/Y9nw+4nehsUOR7Bfc+Oz6Zffq9R9xrcfy6bxLSQ7Qghdco+ffUsknKHDOGNOYW4150daWCTBZeG8f1IDpmksxj9vvqkfXB4BEBsRmCgw/
 AynZ+ttn
 TzyW2hVqcZYj6Y+3/Rb3AmC+Ad8f5LzFvIe/iqWxyh+DF9ACn05xt5dEPaBNZZUGq4ZoTqxK+Z5VIaVRdsUQu3nsmwcmDob67DWsPrM4gzqC+7bIghuKMjCvRVZ/u0/X8c8lqP9co9pcmTUROZZR5d5pis9QPp98jjil09zWLUM+TDt6tm5FzB+8CDdnBPB9wbHeXCe68CT4lCPCxUnttvO6zDFfpG7P0A7wWfgjsV7EswrgqQ2bnE03xrrD2lZWEXgl1wQ7ApalFBFNBHpKYs5h9IfX4ZLBjxxYuhyIxP2NgvPE1HSLW7LSYhaI7SiqKvymScZ39pmNgBg/pvCsWf2apfaq146V05rXggt9ZcK2utUZ7IK6C5hpvp3d1gKRt82BGjIUjOIQeHtDfqplo5QxDE7Okv0yAqaHU8MLDO0cG1Q7aISaXbwh6NA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 11:52:12AM +0100, Usama Arif wrote:
>
>
> On 09/04/2026 09:01, Lorenzo Stoakes wrote:
> > On Wed, Apr 08, 2026 at 05:36:59AM -0700, Usama Arif wrote:
> >> On Tue,  7 Apr 2026 11:14:42 +0300 "Denis M. Karpov" <komlomal@gmail.com> wrote:
> >>
> >>> The current implementation of validate_range() in fs/userfaultfd.c
> >>> performs a hard check against mmap_min_addr without considering
> >>> capabilities, but the mmap() syscall uses security_mmap_addr()
> >>> which allows privileged processes (with CAP_SYS_RAWIO) to map below
> >>> mmap_min_addr. Furthermore, security_mmap_addr()->cap_mmap_addr() uses
> >>> dac_mmap_min_addr variable which can be changed with
> >>> /proc/sys/vm/mmap_min_addr.
> >>>
> >>> Because userfaultfd uses a different check, UFFDIO_REGISTER may fail
> >>> with -EINVAL for valid memory areas that were successfully mapped
> >>> below mmap_min_addr even with appropriate capabilities.
> >>>
> >>> This prevents apps like binary compilers from using UFFD for valid memory
> >>> regions mapped by application.
> >>>
> >>> Replace the rigid mmap_min_addr check with security_mmap_addr() to align
> >>> userfaultfd with the standard kernel memory mapping security policy.
> >>>
> >>> Signed-off-by: Denis M. Karpov <komlomal@gmail.com>
> >>>
> >>> ---
> >>> Initial RFC following the discussion on the [BUG] thread.
> >>> Link: https://lore.kernel.org/all/CADtiZd0tWysx5HMCUnOXfSHB7PXAuXg1Mh4eY_hUmH29S=sejg@mail.gmail.com/
> >>> ---
> >>>  fs/userfaultfd.c | 4 +---
> >>>  1 file changed, 1 insertion(+), 3 deletions(-)
> >>>
> >>> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> >>> index bdc84e521..dbfe5b2a0 100644
> >>> --- a/fs/userfaultfd.c
> >>> +++ b/fs/userfaultfd.c
> >>> @@ -1238,15 +1238,13 @@ static __always_inline int validate_unaligned_range(
> >>>  		return -EINVAL;
> >>>  	if (!len)
> >>>  		return -EINVAL;
> >>> -	if (start < mmap_min_addr)
> >>> -		return -EINVAL;
> >>>  	if (start >= task_size)
> >>>  		return -EINVAL;
> >>>  	if (len > task_size - start)
> >>>  		return -EINVAL;
> >>>  	if (start + len <= start)
> >>>  		return -EINVAL;
> >>> -	return 0;
> >>> +	return security_mmap_addr(start);
> >>
> >> Is this introducing an ABI change?
> >>
> >> The old code returned -EINVAL when start was below mmap_min_addr.
> >> The new code calls security_mmap_addr() which returns -EPERM when
> >> the caller lacks CAP_SYS_RAWIO. Existing userspace callers checking
> >> specifically for -EINVAL would see different behavior start is
> >> below mmap_min_addr.
> >
> > You mean API change? :) we don't guarantee ABI for kernel stuff anyway.
> >
>
> Ah no, I meant ABI, I hope :)
>
> The return value of validate_unaligned_range() flows directly back to the
> ioctl() return value, which is visible to userspace. The error code a program
> sees from ioctl(fd, UFFDIO_REGISTER, ...) changes from -EINVAL to -EPERM for
> the same input, right? Its probably not an issue, but we would need to update
> https://man7.org/linux/man-pages/man2/ioctl_userfaultfd.2.html
> right?

Ah right I see, yeah just a doc change then :)

Cheers, Lorenzo

