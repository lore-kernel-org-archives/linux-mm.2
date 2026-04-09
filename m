Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E811E9DE63
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 08:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C172E6B0005; Thu,  9 Apr 2026 04:01:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC84C6B0088; Thu,  9 Apr 2026 04:01:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADE636B008A; Thu,  9 Apr 2026 04:01:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1BA6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:01:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FA6BE294C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:01:28 +0000 (UTC)
X-FDA: 84638272656.29.91B5447
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id BA3A61C0013
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:01:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rOTz9tLV;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775721686; a=rsa-sha256;
	cv=none;
	b=P3L3Pqfj4cwsyDSIni+36L55/dpfwjyZSKFIkiLtZlfw3g3Vtq+KxvYgFO2CnGvCmqVw5D
	qHhkKmPDIn/yw0jLl6lvgp6NRc0WmqlwNnjcRnuKLlUKfEtYsy55v6pxYRpY7mSB8FFj47
	/1p9Zl3jYUUlmUcHnfdCYDBbW3PVssQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775721686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NtIM8rEfbYq0bFQF3BN/n22f+0/+mv7d7fE3g7f4/d4=;
	b=Pn1ipCDvYgUBpt3JocW8/LJaze4vEbMNfu8SK+2mM2wjRjdut0pTQZR3Hza3ditL1p8lzg
	f1roJM9TpU+qUzUwoBYG6Z6jmCEvllnFx+LfxUhldT8ispf8t1KxL8pTU55Y3k49+W2lPe
	qzcwAGCqKDoJEM9sIyQRSfvEjZJ1y4M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rOTz9tLV;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D852600AD;
	Thu,  9 Apr 2026 08:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933BFC2BC9E;
	Thu,  9 Apr 2026 08:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775721685;
	bh=RGmpNngIfJC7vsE/AA6AGxc8jF7BEr2rUsoHZzp8PsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rOTz9tLV6I6aNdusDm3HswNPIWXdRp/W6DkRosUNvQIzX9eaIsc5Tbz0x7b4UcVJD
	 VghAjUDqOJFDCdxJWd6SUI9/j/6Ib9lheDAoTXVwEbTbxh69QWEZ28y3Uj0PaniLm8
	 eLCzJ9OnW71vIFeqfBTsPsf7/n5c5f4d6sxAWDTKB1Kd7U2Jx9X/sliZ4ru/t8xybV
	 Hngi1RQTrPDym8ZFVyYzNfVv88ValdoNCYPc7mNPNEyZL6YlHovTNGUlGIZfbyelGm
	 cWIZka/2Kf5Nu6Kh7areDqyG7LuzyK1U5AKAPK1Pio5MDnq19kTt+XsB8sbiO/H5B7
	 KeLJ25ueK/PNA==
Date: Thu, 9 Apr 2026 09:01:20 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: "Denis M. Karpov" <komlomal@gmail.com>, rppt@kernel.org, 
	akpm@linux-foundation.org, Liam.Howlett@oracle.com, vbabka@kernel.org, jannh@google.com, 
	peterx@redhat.com, pfalcato@suse.de, brauner@kernel.org, viro@zeniv.linux.org.uk, 
	jack@suse.cz, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] userfaultfd: allow registration of ranges below
 mmap_min_addr
Message-ID: <addcUpxfuR2llaiW@lucifer>
References: <20260407081442.6256-1-komlomal@gmail.com>
 <20260408123700.1596800-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408123700.1596800-1-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BA3A61C0013
X-Stat-Signature: w7ybib1cfgn4nneusnxzptm8spsocm4j
X-HE-Tag: 1775721686-992630
X-HE-Meta: U2FsdGVkX18TEf5lhLryL+xiSXPXdn4IGvhatq6qjg/IjxuCVu8mz+cn4XqhJ9z3vVxwZYNH5GFerkCeF7GDBr4W3iaTClArdDeTPsqUSqu5QK3XY0lMTVSTGuT4G2/WGVv1+TAYsaAuOcuTdavM8qhkMiJtNG0x8NuuSwrS8CyKNsfDgyaLjt8COF3KntvxPJnn/UsdvS7Omt0+okMdu8xPaVCAFdBTqVFIaVIgAB1v588Vx9bojqicdVoPj+o6VAqUydXfu2+qOL9wS8uBmBKTL/OIK1rFci9e9Ld0iWZbJY5LYW8ZhPAkAQu031O6fMVjCDMAEcREY4Z2L6PXqfk0CT5YUw915bNHmKlxO8PxXhjGNoTCPi0g4FkFx9rcbVQygsu+X3R+GN8AG8pWUcYIBz6W/sP9BOYNA58t0I6+k25lZupzLPvNtdeS2w/6jozYFXAvyl6HCByj/6wxAHPjV3SGFayIssPy9MAW+JZa1iQCKqhmjElTmaccMM3fi9Bk8eFDYwjsLlCWtse1wuFrP7l2IVRwL2rTQPWzfhQZQ/6UyRNrPdOHLc4KbbAJXY5keFFEXSN5gG4P6jx1Wap19k5Z15ksDq0x7F0/XJ9bGw6kWsXUxecooyfwky8RcoaDJr6UUkG8O0ojxW/P4xB0l9cziVya3BewCHqZtha3HRpB6jc4s/NX9MZYBAhWvq1WL/FRjOzZJZ7IR7aPAdEhiCFjrzedwXMjDe2yE9uyxiPqhbe0CSDx4b2WACgX/6ehmAGoc7YiSCyNFwZ0r4WHcY89P06Mz34dHg6sk7qZ/Qx/aYVin7yDJroL0E+Lu2J8xQ8GTs7RX6kYBRb//iGTQ+zm7l13eis3gtHKT1D6sgUHbgX0qQg3YtWL6pHgYMWhYm+prJcVTNaqnlSQIzeesE6szsRV87aIQIEYhA3FRnPsYTyBzV6TNAwROVeKT6deb1478UJtrkOX4NM
 e2EShStK
 D8waNZh3b+DAvMLIiE2DelDsiE3nOevgjLwEcyFdiBS4+Hd1M830UcGcl5YCBpTafBZ2YzCXFvgu4frclQbrtYM6La1QXncVsFsvigFV8nofY9XKyaEvv+MbH4/GnM4dD5H2EqRQZWmg8AScAFEMvf9CLmt9zaB/wMIcUryLbywuUFOEXaNB4Yblgz/IxkWupqMIndt/8Q15qrUxcgx4ubzVMA33FcnPkoRpXsA2tFus1kd884DdiLCpVd46WNthseYTKktVKphdiGMPRlnBtuT3X+y/dv1HCd5XJu4iuUZh+mCFWIqqDQnsVQeOQHr9IKvWD6oIaxvz7DI5EdOUZqnZk5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 05:36:59AM -0700, Usama Arif wrote:
> On Tue,  7 Apr 2026 11:14:42 +0300 "Denis M. Karpov" <komlomal@gmail.com> wrote:
>
> > The current implementation of validate_range() in fs/userfaultfd.c
> > performs a hard check against mmap_min_addr without considering
> > capabilities, but the mmap() syscall uses security_mmap_addr()
> > which allows privileged processes (with CAP_SYS_RAWIO) to map below
> > mmap_min_addr. Furthermore, security_mmap_addr()->cap_mmap_addr() uses
> > dac_mmap_min_addr variable which can be changed with
> > /proc/sys/vm/mmap_min_addr.
> >
> > Because userfaultfd uses a different check, UFFDIO_REGISTER may fail
> > with -EINVAL for valid memory areas that were successfully mapped
> > below mmap_min_addr even with appropriate capabilities.
> >
> > This prevents apps like binary compilers from using UFFD for valid memory
> > regions mapped by application.
> >
> > Replace the rigid mmap_min_addr check with security_mmap_addr() to align
> > userfaultfd with the standard kernel memory mapping security policy.
> >
> > Signed-off-by: Denis M. Karpov <komlomal@gmail.com>
> >
> > ---
> > Initial RFC following the discussion on the [BUG] thread.
> > Link: https://lore.kernel.org/all/CADtiZd0tWysx5HMCUnOXfSHB7PXAuXg1Mh4eY_hUmH29S=sejg@mail.gmail.com/
> > ---
> >  fs/userfaultfd.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> > index bdc84e521..dbfe5b2a0 100644
> > --- a/fs/userfaultfd.c
> > +++ b/fs/userfaultfd.c
> > @@ -1238,15 +1238,13 @@ static __always_inline int validate_unaligned_range(
> >  		return -EINVAL;
> >  	if (!len)
> >  		return -EINVAL;
> > -	if (start < mmap_min_addr)
> > -		return -EINVAL;
> >  	if (start >= task_size)
> >  		return -EINVAL;
> >  	if (len > task_size - start)
> >  		return -EINVAL;
> >  	if (start + len <= start)
> >  		return -EINVAL;
> > -	return 0;
> > +	return security_mmap_addr(start);
>
> Is this introducing an ABI change?
>
> The old code returned -EINVAL when start was below mmap_min_addr.
> The new code calls security_mmap_addr() which returns -EPERM when
> the caller lacks CAP_SYS_RAWIO. Existing userspace callers checking
> specifically for -EINVAL would see different behavior start is
> below mmap_min_addr.

You mean API change? :) we don't guarantee ABI for kernel stuff anyway.

Firstly, as with Harry, I don't believe we should be duplicating checks here
anyway. UFFD is duplicative enough as it is.

And this is such a silly edge case that I don't think it is valid or reasonable
for us to account for whichever totally insane user relies on a pointless
re-check being done there and _then_ relies on the error code
being... -EINVAL... which is overloaded for a million other possible failures.

Let's let it be -EFAULT and remove this silly check altogether.

>
> >  }
> >
> >  static __always_inline int validate_range(struct mm_struct *mm,
> > --
> > 2.47.3
> >
> >

Thanks, Lorenzo

