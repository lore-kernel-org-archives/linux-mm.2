Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 497B31088E7D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 05:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E3DD6B03DD; Thu, 19 Mar 2026 01:10:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1465B6B03DE; Thu, 19 Mar 2026 01:10:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29356B03DF; Thu, 19 Mar 2026 01:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA9E56B03DD
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:10:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63D2C1B77D5
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:10:25 +0000 (UTC)
X-FDA: 84561636810.08.86F666F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id B90D3180002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:10:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VdPCI4FH;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773897023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m6s5jbJ1DVHNI2fz/sJa+swXTcSE9V5+T1wI8p3g+Fs=;
	b=Ce6ZP4KecT6WPoCCGAK7EncSMA0w2X8h6NfYGNlS9q59cLp12rOcqfc+N7Uqq8Z4mSM6tF
	pC1lHUcHY/v4Lq+UPI5pVX/xj8VgF55KuCqbB1RwlRG8xnuxdnnuXJqbPsHSbEoozUZo8h
	Nf/hEaapQvwZCmz7g1XExSHE15oBGN0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773897023; a=rsa-sha256;
	cv=none;
	b=TFSk1wGb59JWkeylj+uU5aXAU81emSSagfuNDmdGS3Io/jElne3uEJezA9Vx+YWD5yw1TL
	Gs9c4hrMi+tyEjmqDJJMwnSJaTeukI+IUo5tSoSUwTG+rg6LiMLgPJhcxOHraWyW4j/a4e
	jvG/6zpbA4VtOXrIyjJjzl/aDxYBDo8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VdPCI4FH;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C64C6011F;
	Thu, 19 Mar 2026 05:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E596C19425;
	Thu, 19 Mar 2026 05:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773897022;
	bh=GP7xsX5ztcYNzeY7jiTdYXA5ELT7cnQ6/syxssXl7oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VdPCI4FHof0PGZEuyoS2CILpHqb/DJAxvTZlLi3lCZJP1rydNTF0bajuQpzt6OaHC
	 Ji1q1qIoF00ZqZ41ht6rg+DlXUdfrpXPh0PKZRW8ZG9pr8Z+EheSmU6rqAxIPY5wqH
	 dR4HdQXb6gioOAQSHrgPp+Pt+lxkqtW2OJHeNVe1n7On0dfEiXmGKFy6GynkhqRlLH
	 IIC6uWkhGmElZPvylavpcX4pvzAFcwbCKb7kfG0EKX7VKuszUlBq727K+6SMTL6EiX
	 12Gw3kOond/vC7Jexnd5fmdK60JXOR17edfA+trJgxGw5/cDa7c575NoGd/Divi5/z
	 lF918/d8jnWwQ==
From: SeongJae Park <sj@kernel.org>
To: Chen Ni <nichen@iscas.ac.cn>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com
Subject: Re: [PATCH] mm/swapfile: remove duplicate include of swap_table.h
Date: Wed, 18 Mar 2026 22:10:13 -0700
Message-ID: <20260319051014.98845-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260318043849.399266-1-nichen@iscas.ac.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h8iieq8fcncey4skmi1o8eiczpqgnx3x
X-Rspam-User: 
X-Rspamd-Queue-Id: B90D3180002
X-Rspamd-Server: rspam12
X-HE-Tag: 1773897023-228766
X-HE-Meta: U2FsdGVkX19dN6RocfbeS2GITXc/ONzUyTVZAwRiA0mI1ML7LC5SfeWCT2885IisEhkPLLSuZrxa4tY4amjIfasik8eqgOtjVK2hTZMN6voWblw9ykD8CNlq4OuiQmBgQp4GZOP/br9fNM+lpkcYUVhiqUHzRE8zXwhmSN1Vpd4ybQbiZQXo3lIOVPO66ANsYg6U1cw5uXB0OXc9NwrljgJM5BSzyPqzH8lG1ggrRfpgXL2PN51Up0BiQAj0q+qs5fBtqXPzPX+JWuB9W5gprCcxl1P11dNGpn0gO+uh6TmYB/qPYDQuCFNi0sDgZmQRpjN7/VXhYisc+bXy2P+qc62o2wswH9QjnZFFF6IqT4ibj4DGiTbvwL6AgcP/IgUtEXtz9UtYcAucSjctQEn+s/IFYLpQUzdEc5tvMXqOJIkxTny06jBts2MOULoWKTcuGfuxqNdHuuwESvTbr4HQGd09FLmXIQXWYJZP9edOe9SRyGsfdw7raRjeDB9Iy4JNXqI8jYPCFmREn1ZEliME+tfi/YM6FqMWdjy+FqHmqR5YoGt2d1ODnnHbkERrXPqsSGE2zPV/BAI0pzzNiHF1OsaGch8JJ9xE4ojJygiYV0/rRFPRfFbTEfxSWxvZs0wHXslU2Vce8dlqOxc0iCWCzDPlRz4EXdPxWhd9cQFigVGBj5jbh2kvaXqJexXCWb7u+gJrgHfnTD0hvCWbHPDQ6ctv1LU1Dxkfuow/sv0n5gNV9T7vac7hDMPvd7h1Zy21DfMYBh9i0XWdRFMj5B5x62P+kx/LaPTiL4gulH5vRtLFJTNfKQZb04RUUrTQ4XgzmXf8Z2lU+UwTUHIOqNXsgrOUuObAEI2KEoCsgsRxPTNjZDLsEY8BYhR6YaDSbuCpkBazj1OG/g8tlfsBG4U5ustAyvet5ltsRCLqDChwR+cchi5k+98vPY1/+xkv0PqE4ZpLkWF4zxEjyzdhi8X
 6xo02YST
 w56obldE1rUXMLUxmqDk82YgBcNW+krhiPK5zBDtKeEj00vAOD9NtnYQF2VNtoA1p0vSdEA/8vhA9NZzg0WjoWVX4kpNFgt0waK9X4ptpmIW10nryRNrgHgIbeuFqQ1B79mXxeqSQqVHoee9BY986ltMVPkcRNx3ovd6p/vJouYcRPrwGnK6gRXeVBBjW7MnDxbB1bcpwQ561iCDlz8n/BNKGblWAVgcfpnhXubd/Kxq3ZuTqFIPy7SyNQg5oivKznY6qJtqE8Q3ICLEq1zIYlpwC6hUtsz4Swy8APS91Cca2wdwQglhtT6laACW+Bhns3uVrhl0kjImgX7p6MD+bHBUMCUFHRXmfdGEh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 18 Mar 2026 12:38:49 +0800 Chen Ni <nichen@iscas.ac.cn> wrote:

> Remove duplicate inclusion of swap_table.h in swapfile.c to clean up
> redundant code.
> 
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
>  mm/swapfile.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 35f1b58d0bb1..9174f1eeffb0 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -48,7 +48,6 @@
>  #include <linux/swap_cgroup.h>
>  #include "swap_table.h"
>  #include "internal.h"
> -#include "swap_table.h"
>  #include "swap.h"

FWIW, I once thought it might better to remove the upper duplicate, because it
will make the files look alphabetically sorted and therefore easier to read.
But I realized "swap.h" should come before "swap_table.h" to really
alphabetically sorted.  Anyway that's trivial and I don't really care that, so
decided to just give my Reviewed-by: as above.


Thanks,
SJ

[...]

