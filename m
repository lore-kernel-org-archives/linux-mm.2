Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3FEAC88E52
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 12:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8F226B0088; Mon, 26 Jan 2026 07:47:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39266B0089; Mon, 26 Jan 2026 07:47:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D696D6B008A; Mon, 26 Jan 2026 07:47:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C5A786B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 07:47:27 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75A0F1AFF2D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:47:27 +0000 (UTC)
X-FDA: 84374090934.06.31525F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 17ABC160005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:47:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KfvbgkvC;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769431646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0yWEB3MC/IwOdZRTqjXn596FY/5KcgKt/UNJOXmLQQk=;
	b=ZcB0KALOwFyXAEyLgI62omIl09jjEGKI94+OBGNCSIfgsZGx0STbAsZrYcF7RFZi+Npp12
	0gYsB98wWnuhU2jl8J1CUipQlCoXBQ5FGlol7St3F/zwbkZ7Ftj72VDW7+PrpQDBUHWjiK
	YFPw38oLwPs5pyKETTYTGRuMZJb4CyI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KfvbgkvC;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769431646; a=rsa-sha256;
	cv=none;
	b=szxHlw/IFzucupDkqlfVIIwHorMdnX3qlatRUF3dy8lDW8bt6rFmkhbwCgU2ynVBdI19du
	U7JoNGaFxetQm2mKtbZOXPn3GS5bL2H8CbRrstGPM9nuizqJkGKH0Kq61MvvDN6UpQf6Lp
	+qDpZZxmfIlwkWHJhIGYooW/gSl4C2I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8761160051;
	Mon, 26 Jan 2026 12:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E1AC116C6;
	Mon, 26 Jan 2026 12:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769431645;
	bh=6wAT8ti4QCa4aLuMEWb3Z0RxEKoJVGK3uZ0wJAMvvnQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=KfvbgkvCznk1tlJ4lZzsg2eEdrMAvgO7UG8TYLAUCLREEOBLo49BuFec7Tqa2OdsC
	 AUY10n5LHMRvMmsZ4eZnNHSzvfjn79Wt2sm/OPIGlvBUsZj41efLMT1PJFH8bVRKnq
	 cZGM0WpMCyMM+9RYv2LoPzNGLAjatqnehL8W4mX3pbDKRv/JKwP3GxFZnJ5Fz+LDs4
	 lKGF1QioOvg/9OfZjRUvozT4QixNbDT3ic07rT9uDqg2LyaxehJnhoUleUepQLw1N+
	 ph9v8qTWtLAd6IDK8XQZdfD12svL9ITDrwsSknk9Z4p5YI0bNOJGKbdXmB0ps9n3kp
	 iUusOazWScZ1Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Hugh Dickins
 <hughd@google.com>,  Baolin Wang <baolin.wang@linux.alibaba.com>,  Andrew
 Morton <akpm@linux-foundation.org>,  Jason Gunthorpe <jgg@nvidia.com>,
  Samiullah Khawaja <skhawaja@google.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memfd_luo: preserve file seals
In-Reply-To: <aXYGkb-QtYNaWYw4@kernel.org> (Mike Rapoport's message of "Sun,
	25 Jan 2026 14:03:29 +0200")
References: <20260123095854.535058-1-pratyush@kernel.org>
	<20260123095854.535058-3-pratyush@kernel.org>
	<aXYGkb-QtYNaWYw4@kernel.org>
Date: Mon, 26 Jan 2026 13:47:21 +0100
Message-ID: <2vxzqzrca6cm.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 17ABC160005
X-Stat-Signature: 3ocacghy55n314x6f8ijim53ns5p5175
X-Rspam-User: 
X-HE-Tag: 1769431645-271035
X-HE-Meta: U2FsdGVkX18Gn/L3wvvzgUH4xf3+Ff0Urnd8Oybf2fGOn+PSPebouv06QwYrNkurvWDyANeqL8uNZeIIBbk0rqs48Kuj6H5YyZaHkSTai30THGK+mvU2tB2ipCYJ3nO31IbTJkAfrkoax8J8HnxlvJrhxRkrd5J3AgLjODz9muBYm0cvAdZGSuiW+uk/2BobVW5psrxat/AfW8g53Al3EPX6KRFfEY87gmegieRExeWC0jKGS7ut/AtSryPWPV655TPsXYRWcpXVHdzM9EwVjVisFVKT83YSf63eZbO+SUnZgkPI8vCdlUQUqYKrhJSg86H34LBANS7i92/Hp5CZPfX02LYBHjBFHkAJAYFuDc9nIOooLwUnoIinZsSWrOLW3oWbWP6wpzl4InMk12nWU8IwuVbwEk0QRbYCc6o2w6pFrbf0vZi84k8vteBvlnrOVvg0sM65LJYjrC4FmO+3rd9WKojGweLizzU7jV6GEBDuqOuf8FXBCqY5bFPPBr2XXonpFEFFuE45pzag2rFlVFdvQeq1Tm9RJf34KcA/dzVGpN3z6jcV+Vhf3Tb2/AdjQndhZ02oqZKSF5WJbQYhyYYVHhCUycgI1TH3QhKCDqbiCmDw6OyKzyXKMsLpp/ezo02EkHXV+ZKMd8l6Ak0A8oNq3vRID7sIrHzvuC0sMnC/NItkd0QHA0XWEXScv6qbtvu3oPfG346MeZrW8A/Cf86vYubkS017LwtY7gktJjXEqFmBPy+vz39o4HZjQJueftwwlTlca4FJECmC6RTautorSBdvo9BpbThMeeUfEuQNDsHBqhvXY9ck3RnX48JyIluR6QrMzShkpdrkUCmwnQamqzd9RXMDTSg71qM5cf9Z+ytvDJJbIrgme8DCk91WjcRiF9TdVb+wb/dMtnYiCZ2LUeNDwa6QjXe60liD/WNOQehCcmeRR/OxNhg9RONE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Sun, Jan 25 2026, Mike Rapoport wrote:

> On Fri, Jan 23, 2026 at 10:58:51AM +0100, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> File seals are used on memfd for making shared memory communication with
>> untrusted peers safer and simpler. Seals provide a guarantee that
>> certain operations won't be allowed on the file such as writes or
>> truncations. Maintaining these guarantees across a live update will help
>> keeping such use cases secure.
>> 
>> These guarantees will also be needed for IOMMUFD preservation with LUO.
>> Normally when IOMMUFD maps a memfd, it pins all its pages to make sure
>> any truncation operations on the memfd don't lead to IOMMUFD using freed
>> memory. This doesn't work with LUO since the preserved memfd might have
>> completely different pages after a live update, and mapping them back to
>> the IOMMUFD will cause all sorts of problems. Using and preserving the
>> seals allows IOMMUFD preservation logic to trust the memfd.
>> 
>> Preserve the seals by introducing a new 8-bit-wide bitfield. There are
>> currently only 6 possible seals but 2 extra bits are used to provide
>> room for future expansion. Since the seals are UAPI, it is safe to use
>> them directly in the ABI.
>> 
>> Back the 8-bit field with a u64, leaving 56 unused bits. This is done to
>> keep the struct nice and aligned. The unused bits can be used to add new
>> flags later, potentially without even needing to bump the version
>> number.
>> 
>> Since the serialization structure is changed, bump the version number to
>> "memfd-v2".
>> 
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> ---
>>  include/linux/kho/abi/memfd.h |  9 ++++++++-
>>  mm/memfd_luo.c                | 23 +++++++++++++++++++++--
>>  2 files changed, 29 insertions(+), 3 deletions(-)
>> 
>> diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
>> index 68cb6303b846..bd549c81f1d2 100644
>> --- a/include/linux/kho/abi/memfd.h
>> +++ b/include/linux/kho/abi/memfd.h
>> @@ -60,6 +60,11 @@ struct memfd_luo_folio_ser {
>>   * struct memfd_luo_ser - Main serialization structure for a memfd.
>>   * @pos:       The file's current position (f_pos).
>>   * @size:      The total size of the file in bytes (i_size).
>> + * @seals:     The seals present on the memfd. The seals are UAPI so it is safe
>> + *             to directly use them in the ABI. Note: currently there are 6
>> + *             seals possible but this field is 8 bits to leave room for future
>> + *             expansion.
>> + * @__reserved: Reserved bits. May be used later to add more flags.
>>   * @nr_folios: Number of folios in the folios array.
>>   * @folios:    KHO vmalloc descriptor pointing to the array of
>>   *             struct memfd_luo_folio_ser.
>> @@ -67,11 +72,13 @@ struct memfd_luo_folio_ser {
>>  struct memfd_luo_ser {
>>  	u64 pos;
>>  	u64 size;
>> +	u64 seals:8;
>
> Kernel uABI defines seals as unsigned int, I think we can spare u32 for
> them and reserve a u32 flags for other memfd flags (MFD_CLOEXEC,
> MFD_HUGETLB etc).

Sure, will do.

>
>> +	u64 __reserved:56;
>>  	u64 nr_folios;
>>  	struct kho_vmalloc folios;
>>  } __packed;
>>  
>>  /* The compatibility string for memfd file handler */
>> -#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v1"
>> +#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
>>  
>>  #endif /* _LINUX_KHO_ABI_MEMFD_H */
>> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
>> index a34fccc23b6a..eb68e0b5457f 100644
>> --- a/mm/memfd_luo.c
>> +++ b/mm/memfd_luo.c
>> @@ -79,6 +79,8 @@
>>  #include <linux/shmem_fs.h>
>>  #include <linux/vmalloc.h>
>>  #include <linux/memfd.h>
>> +#include <uapi/linux/memfd.h>
>> +
>>  #include "internal.h"
>>  
>>  static int memfd_luo_preserve_folios(struct file *file,
>> @@ -222,7 +224,7 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
>>  	struct memfd_luo_folio_ser *folios_ser;
>>  	struct memfd_luo_ser *ser;
>>  	u64 nr_folios;
>> -	int err = 0;
>> +	int err = 0, seals;
>>  
>>  	inode_lock(inode);
>>  	shmem_freeze(inode, true);
>> @@ -234,8 +236,15 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
>>  		goto err_unlock;
>>  	}
>>  
>> +	seals = memfd_get_seals(args->file);
>> +	if (seals < 0) {
>> +		err = seals;
>> +		goto err_free_ser;
>> +	}
>> +
>>  	ser->pos = args->file->f_pos;
>>  	ser->size = i_size_read(inode);
>> +	ser->seals = seals;
>>  
>>  	err = memfd_luo_preserve_folios(args->file, &ser->folios,
>>  					&folios_ser, &nr_folios);
>> @@ -444,13 +453,23 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
>>  	if (!ser)
>>  		return -EINVAL;
>>  
>> -	file = memfd_alloc_file("", 0);
>> +	/*
>> +	 * The seals are preserved. Allow sealing here so they can be added
>> +	 * later.
>> +	 */
>> +	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
>
> I think we should select flags passed to memfd_alloc_file() based on
> ser->seals (and later based on ser->seals and ser->flags).

Not sure what you mean.

I think the only seal we can set via memfd_alloc_file() flags is
MFD_NOEXEC_SEAL, which is really a F_SEAL_EXEC and plus a change of the
inode's mode. And now that I think of it, that is a valid use case that
we might as well support. But I think that should be done by preserving
the mode of the inode directly, and then copying the seals back. The
main reason for that is that the mode can be changed after the memfd is
created too.

Other than that, all other seals are set by fcntl (via
memfd_add_seals()), so I don't see what else we can pass to
memfd_alloc_file().

>
>>  	if (IS_ERR(file)) {
>>  		pr_err("failed to setup file: %pe\n", file);
>>  		err = PTR_ERR(file);
>>  		goto free_ser;
>>  	}
>>  
>> +	err = memfd_add_seals(file, ser->seals);
>
> I'm not sure using MFD_ALLOW_SEALING is enough if there was F_SEAL_EXEC in
> seals.

Why not? memfd_add_seals() can handle F_SEAL_EXEC as far as I can tell.

>
>> +	if (err) {
>> +		pr_err("failed to add seals: %pe\n", ERR_PTR(err));
>> +		goto put_file;
>> +	}
>> +
>>  	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
>>  	file->f_inode->i_size = ser->size;
>>  
>> -- 
>> 2.52.0.457.g6b5491de43-goog
>> 

-- 
Regards,
Pratyush Yadav

