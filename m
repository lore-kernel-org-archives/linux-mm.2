Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 272DA109C032
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9038B6B008A; Wed, 25 Mar 2026 11:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B4EB6B008C; Wed, 25 Mar 2026 11:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C9F76B0093; Wed, 25 Mar 2026 11:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EC836B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:32:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34FA3160A1E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:32:04 +0000 (UTC)
X-FDA: 84584976168.06.924E902
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C67361C0007
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:32:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZsZWKOkJ;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774452722; a=rsa-sha256;
	cv=none;
	b=1D0/MZhOMP72IQJnULAjkdU3gxKzlV/sQRpGcpEZOnWcgg8XYqfu9IypzWmokjZ0RLEAFl
	DT7wZXJq49L31ulqAeS8/nCw8mZ7YMAiPBAFhi/J+OFmpa4lburdDs0cLYbWDfjXjCXfbd
	e+HOOvZTDLm96JdhwTE03s4DJISG6PI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774452722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1IDagVuEPQNVKbabEkXF3K2/ywzeU5kMPPwERvfdTSw=;
	b=yCx6HxftqxiWCzuLWGZzFsLFdW2CIltsBTqouXWbkCn+VsWKZN3E/6t5WMVTykeItfFVda
	DZr2pzJQsBVo3v9ZGFlBr9/Rxo0/7DQt7rS3Qq2CipAtCXUZzGtc6jpKh9ZccmME05CAi8
	Gdbw/nxgiUKqibOK5EHrV1rHaTZWTK8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZsZWKOkJ;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4544C600AC;
	Wed, 25 Mar 2026 15:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400DEC4CEF7;
	Wed, 25 Mar 2026 15:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774452722;
	bh=zavK1MEnQ0juash2NLp1KSrYuJJR9QPka+RrrXclKds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZsZWKOkJgJN6VqUXPGcISCukGP5honyevSk8AS/B+bWxtJFv7QZCDWQyCQsJHMc4U
	 2eV1QrnfKEu/+7oU3156EpQ6OMQPkpLOzJs4xJHucP4axS6QiqmaHSt8v5kF4U9G2P
	 EwWLmCyI1y1aIPv4tbkP2gMngzm1wnDi/wBedxOnDi7+shE+OFva9AcSYdHCzsCP+f
	 UNuF5os36XDfZ8hQ3pH1+oaQCoPFY99PEac9WklN6EJYe/CjHgMLgq6ir83VuRSYJy
	 xBFrAQtOrGFbqGhSPQTe3JALVvFMf98lgHfLzXqtRDTZwWKOwkQsbfdQtkbZ0rqyby
	 HnXPG4xNsJ88A==
Date: Wed, 25 Mar 2026 17:31:55 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v2 1/2] liveupdate: prevent double management of files
Message-ID: <acP_6wY_HVMyTLHk@kernel.org>
References: <20260323203145.148057-1-pasha.tatashin@soleen.com>
 <20260323203145.148057-2-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323203145.148057-2-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C67361C0007
X-Stat-Signature: zqsjwos5u51dks8f1fn8o8i7w5g1gz46
X-HE-Tag: 1774452722-692273
X-HE-Meta: U2FsdGVkX1+wWLKDSVZ97x6YOaEvESWnLBx+wcdqwAAqjYCrLv/myqdHaVqWv8Zj+OhDy/eFNw11lLTZv6A4bqq2Slbw8+KCvUCrBv1wWNfKCycG6w2p6hC/KP0mVmowRSyuYJGFDVhseYkBucNwvU0XWcrZc9+knMo7RHC4Yxa14JUUY+JA8gmHjffua0uoeASKI/wW7cs8TQwv0twITcGgeMZ8ZMh5AqxCJCuIUcZvHAgzT0inC08nDu/GFrxOAyZB4k/TmZwLTW/ZZwQr5Ylo+lRFNUUh5hzGkCoHSUWWqhA+Vgke64lW5SgTgu3TJZUfXmWEru5pEzo6ZWK6/+9zPUHkQQsebbDY9unBtyHUKTVhb/wnlPSM+CHwNxU0NuwiStOWJkOi+agaz/e5St9VcJokOh2mjkazzl4IrGM4d1BdRuvVACeFKot6rX3EGZRfrkYJwKwM+TG7HYywusqchxnKYADlfqvQd7UZOMXceFtmYNvAugpOspNNKsSjAy9+vUlnpeYlT7oAyPXOg8jmhE5gOpbKPHIJpv6evGwS0ChQWeT+chAHdJfBveW2jEoq2IcFR6J6nGwXB+R4gymMxuMJYuQITe6rEDUqDXYd3QpGiwskQ5LgaXczw9oLsFdP03hMRMfiFtL9IuO+bF9ubVKM7kdD4B4AVpvplGnh/UemLfsLfHRN7Alk6HrXZ2C2/KfeDefWMeZ3b3p6Hmo4V0bMUOEx9KgPiSlUgytF2a+nqNV2ohF1vbgSS+vRQhMEflmb4LELW9/UOFeV6HEkhWSn9ZWw1hL0knnDf3VhP55xx24w4ORGSLOplao1X5p1W/H+yHoL2byZpkgdzdsxIAoaALxm28gEkcigLZI3Mmdsro3PFPLmndez4GHNTLPZI7Fi0WmfSpn54GVuvmdKwW6gUj5OAm8OHh3ZsNUnedYO0YOStJmx1S7FVsAM4mwWM7vkpsejnx6Kv4K
 NnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 08:31:44PM +0000, Pasha Tatashin wrote:
> Currently, LUO does not prevent the same file from being managed twice
> across different active sessions.
> 
> Use a global xarray `luo_preserved_files_xa` to keep track of file

Do we really need _xa suffix?

> pointers being preserved by LUO. Update luo_preserve_file() to check and
> insert the file pointer into this xarray when it is preserved, and
> erase it in luo_file_unpreserve_files() when it is released.
> 
> This ensures that the same file (struct file) cannot be managed by
> multiple sessions. If another session attempts to preserve an already
> managed file, it will now fail with -EBUSY.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/luo_file.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index a38ea4975824..5f48c3c8c561 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -110,11 +110,15 @@
>  #include <linux/sizes.h>
>  #include <linux/slab.h>
>  #include <linux/string.h>
> +#include <linux/xarray.h>
>  #include "luo_internal.h"
>  
>  static DECLARE_RWSEM(luo_file_handler_lock);
>  static LIST_HEAD(luo_file_handler_list);
>  
> +/* Keep track of files being preserved by LUO */
> +static DEFINE_XARRAY(luo_preserved_files_xa);
> +
>  /* 2 4K pages, give space for 128 files per file_set */
>  #define LUO_FILE_PGCNT		2ul
>  #define LUO_FILE_MAX							\
> @@ -249,6 +253,7 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
>   * Context: Can be called from an ioctl handler during normal system operation.
>   * Return: 0 on success. Returns a negative errno on failure:
>   *         -EEXIST if the token is already used.
> + *         -EBUSY if the file descriptor is already preserved by another session.
>   *         -EBADF if the file descriptor is invalid.
>   *         -ENOSPC if the file_set is full.
>   *         -ENOENT if no compatible handler is found.
> @@ -277,6 +282,11 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
>  	if (err)
>  		goto  err_fput;
>  
> +	err = xa_insert(&luo_preserved_files_xa, (unsigned long)file,
> +			file, GFP_KERNEL);
> +	if (err)
> +		goto err_free_files_mem;
> +
>  	err = -ENOENT;
>  	scoped_guard(rwsem_read, &luo_file_handler_lock) {
>  		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
> @@ -289,11 +299,11 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
>  
>  	/* err is still -ENOENT if no handler was found */
>  	if (err)
> -		goto err_free_files_mem;
> +		goto err_erase_xa;
>  
>  	err = luo_flb_file_preserve(fh);
>  	if (err)
> -		goto err_free_files_mem;
> +		goto err_erase_xa;
>  
>  	luo_file = kzalloc_obj(*luo_file);
>  	if (!luo_file) {
> @@ -323,6 +333,8 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
>  	kfree(luo_file);
>  err_flb_unpreserve:
>  	luo_flb_file_unpreserve(fh);
> +err_erase_xa:
> +	xa_erase(&luo_preserved_files_xa, (unsigned long)file);
>  err_free_files_mem:
>  	luo_free_files_mem(file_set);
>  err_fput:
> @@ -366,6 +378,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
>  		luo_file->fh->ops->unpreserve(&args);
>  		luo_flb_file_unpreserve(luo_file->fh);
>  
> +		xa_erase(&luo_preserved_files_xa, (unsigned long)luo_file->file);
>  		list_del(&luo_file->list);
>  		file_set->count--;
>  
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

