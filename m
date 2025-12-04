Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A75D8D1F9A3
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 10:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C45686B0024; Thu,  4 Dec 2025 05:02:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1D1A6B0026; Thu,  4 Dec 2025 05:02:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5A5A6B0027; Thu,  4 Dec 2025 05:02:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A7A4A6B0024
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 05:02:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46B4E1A0998
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:02:36 +0000 (UTC)
X-FDA: 84181349112.01.C0102BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id AAB3540008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:02:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HQAH8YeD;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764842554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h1b9VQZItanm4Sna1L5f3xqMevQLT5D/Omn0P4XgDLY=;
	b=E/5ESUPqnZdVLI2Zge5k9WR1DJ1X+HOQT15t6/ANjGJ4oi6E4sjcuMrBuhbdjrzWaJFxAx
	GE6+i9tbLdVICllEiY9qtK9FbrgSAh+owdk2Jyvmm3qGQ3JhaAjlxDdu1uWeqFEMhd5KlT
	c+boK7KoSJGuSbGcEbgDNePGdwTxu/Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764842554; a=rsa-sha256;
	cv=none;
	b=niaE+SQZ2fl/B0pCfe/7KpnrJMyak86OyhI5AdhnD0ickTdbvp8hqi1HcjSCQQvVmf5yIP
	uiLWfAZFnF8G/kQwZi4UpwNGn08XU4gE/niiiF41XgfIlhH0M95FX1Ei6b7de6hTPcq/Iv
	eDDqOv66VQ7mQA9Vc09LdpCDLL4LzS4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HQAH8YeD;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AFA060128;
	Thu,  4 Dec 2025 10:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BADC4CEFB;
	Thu,  4 Dec 2025 10:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764842553;
	bh=APMg9IMKLDeVUcBosODe5rgOnSNLvIaubmEmIh251lU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=HQAH8YeDgnuexMhj6l5uqKOJvu/4J6NCdoeY0XaBN+hfIqRxU3UMV3Ka6ia4rN3tT
	 3AZmMvzr5d42MP5lRabrfeJqB9HbEuOWLLtgvYXGbnv06dAJVbWBje9GyQwtTESc/U
	 UGpp8765MD81nAqO5cSiCUESSAfDjBmmoqpl9kNTo4cxakmQef/Vd1ejTOCPkzMus+
	 U8u6/5QsnZXnTjPyCn3W9LH9aXm7kqcEMBzvC2VhEIJYnh1BHf+0i0XYmQibUkuxln
	 t/lnOJBQcFn8QDX+Tf/6UHwVvTCKwJxtPCvf38xn6uXhwcrZTzX2VMglk4qqsqgxcd
	 GIS4V6Fid3okg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Hugh Dickins <hughd@google.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  "Mike Rapoport (Microsoft)"
 <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  Arnd Bergmann <arnd@arndb.de>,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Kairui Song <kasong@tencent.com>,  David
 Hildenbrand <david@kernel.org>,  Christian Brauner <brauner@kernel.org>,
  Kemeng Shi <shikemeng@huaweicloud.com>,  Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>,  Guo Weikang <guoweikang.kernel@gmail.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: shmem: avoid build warning for CONFIG_SHMEM=n
In-Reply-To: <20251204094444.1030143-1-arnd@kernel.org> (Arnd Bergmann's
	message of "Thu, 4 Dec 2025 10:44:40 +0100")
References: <20251204094444.1030143-1-arnd@kernel.org>
Date: Thu, 04 Dec 2025 11:02:27 +0100
Message-ID: <861plamuoc.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AAB3540008
X-Stat-Signature: bk13p5yhqf6k81oyp9e38upo6s1s36ku
X-Rspam-User: 
X-HE-Tag: 1764842554-829713
X-HE-Meta: U2FsdGVkX1/BhW1kegc6B102nENqmJlTzFYKfpV/nUl275vY6M9hz1jFTX+PHXywP677Kks1rjXxK9qticZ4G0OODmxHM3cnSd3I17fPHNRan6PBsuIAD41BsMbyUPPKvEhWA4kazPsZi2oqffw7ZAXHpJtSAxqw6keKdGR4lpB6uw7MR4icL4i9RYAKMu6LxCN9T1ngmIP1zaWSWuBk0ed2Jj+toNSUfwA7+x3py68tv0wWDUR+L12YWJlojN1aaX+WHyBTP94TF+jVT9LP7FB787l3d1pKac+cbruqOlO1CXd+Szwg4xr6oId2VbsmJ7KBG52u/utsGYz0sKV6zsu3hT8axpmXQb1/meZ1q/sDbxkwvYsTxkiDPs0i2GRVVsOQLyxcG2wEJcoZML5hBZ2Xbzxom6mksCIv8HXsuerPSU4/WNGUvNMLUioU1ya10QZrv7T5v1qSjKVQDXgOHm6X7NWk/shcDeDj4k2Wvp2prGD1x/E3HjFf7Sqm32ZkLJOSLD+uMSJEwHKx5BzDXLlCiIqq/9xQWCv5/IrDcHeAPq5SonxRQdf/GOsYJS3X8KhyOjeJCJVKmNKtfjlwGgZWZ4qXjov+4O4Ltf37q3J9mD6coCPacHPGPOUf1oXKh2Lwtcwh6PlwnhL2q2H9t7Exi1+t9UynjU+eCclF3iznzOp2rpajccYcJfu0tDr2jyO7o+ATeLsVVtz0TNz2KCkXjFE0CbUfToMuFMNh7yUDFU6RJ0sbrd1xQJwcm+d6gzwgdUc19iI5doRyOuRaws0ve6Zv7GFz/b8D8vpZD9dMnOyctT8G2WX620QA24J3jy+EhKGg+kpWhZOEdavHm9Evocb+1ktUAwT3CT4ePe5GFXn+WCER6RxTpAjurMQI0vPelqXtXQKuNzDvanOrTiy0PaZZ3lHu8zzUR6pljeqrMHwZF2gq15zyHYeqmlfIJtNPaQcP+qSiUzEe7Um
 HS9bt7t1
 Fd8FH6UkEM36oYdIdy/9vIFkixfW2OEt/HJQbV6FvcphpHerRcTrGk9vrmPd5CJq0katI5IUo8CTwn0VQPEKldd7Q25MO6bhCIajxLymYEOorLdsTIL+6dVoQmCKrU3aF4/pJZGF+TaZLKf3P9RZ4LMreNMCKnDkebuNC0YI8XUC1HiZsTCp1gOd8Qd1MHEnHi3fU99JlY8olRwyRKTS+KYtOL4cfBm2ckwO0mCz9DpZAObTnx+AYuC7OupVTrJ9ggGj+xGHRUM7CWPAX5fckAx/J8LvmBgdHzQhV+z84Mu4CKGVjEngqwXdpPFqicQJqpzqtdZk8mX0ma+w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Arnd,

On Thu, Dec 04 2025, Arnd Bergmann wrote:

> From: Arnd Bergmann <arnd@arndb.de>
>
> The newly added 'flags' variable is unused and causes a warning if
> CONFIG_SHMEM is disabled, since the shmem_acct_size() macro it is passed
> into does nothing:
>
> mm/shmem.c: In function '__shmem_file_setup':
> mm/shmem.c:5816:23: error: unused variable 'flags' [-Werror=unused-variable]
>  5816 |         unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
>       |                       ^~~~~
>
> Replace the macro with an equivalent inline function to get the
> argument checking.
>
> Fixes: 6ff1610ced56 ("mm: shmem: use SHMEM_F_* flags instead of VM_* flags")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks for the fix!

I recall that the kernel test robot also reported something similar, and
Andrew sent out a fix for that [0]. But I guess it got dropped in the
later re-rolls of the patchset.

> ---
>  mm/shmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3f194c9842a8..93746270c459 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5794,7 +5794,7 @@ EXPORT_SYMBOL_GPL(shmem_truncate_range);
>  #define shmem_vm_ops				generic_file_vm_ops
>  #define shmem_anon_vm_ops			generic_file_vm_ops
>  #define shmem_file_operations			ramfs_file_operations
> -#define shmem_acct_size(flags, size)		0
> +static inline int shmem_acct_size(unsigned long flags, loff_t size) { return 0; }
>  #define shmem_unacct_size(flags, size)		do {} while (0)

Can you please also make shmem_unacct_size() an inline function for
consistency?

>  
>  static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,

[0] https://lore.kernel.org/all/20251108084308.8640699dc4f737c520841391@linux-foundation.org/

-- 
Regards,
Pratyush Yadav

