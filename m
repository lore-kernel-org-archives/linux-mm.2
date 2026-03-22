Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A32CBFC72AD
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 13:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48536B00A9; Sun, 22 Mar 2026 09:13:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF93E6B00AA; Sun, 22 Mar 2026 09:13:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F5A6B00AB; Sun, 22 Mar 2026 09:13:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 944C16B00A9
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 09:13:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA2761E718
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 13:13:47 +0000 (UTC)
X-FDA: 84573741294.19.1DFEC1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 26F821C0008
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 13:13:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RCoipx0U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774185226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gWzq+qFOgauKlZNJsjDtQalZOAPyKmDFm6B0Okj57yM=;
	b=UX/LPg7obAEuiZOr6U55NbCVfVkivG2oOtRjm0CT7D5qXSNbo//XjJUzBpyI9up9qAsGtf
	ivXxErFQKWnRxTCCTB5DJzLc59KBsoaL3w0byoizhDlklq0jMBHregf+vwj6bx4pc8c825
	aJ0otDXa8N5liwsGKBX18fpVLIIt8Yw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RCoipx0U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774185226; a=rsa-sha256;
	cv=none;
	b=BhPXiUWNKBBw25Rmuw26aWynk8QfDMk/l/OIC4Ry9hnZ4Rq2whPImk0f/XTjHOGPvnspYp
	5bmjbtDDSEi5YAwvbvzuMAcOL63awHPQU646Kmr4MplMfYffnmNAxS9SuiY75iVpcPExtj
	2Xy4QpZRNrTmfK3zIa5FLqvl3rao9Iw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFC0D4017B;
	Sun, 22 Mar 2026 13:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78903C19424;
	Sun, 22 Mar 2026 13:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774185224;
	bh=5taCrRbCiZRabK14Jhz8fQtqNTWry3OlVCQeaw+8hs4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RCoipx0UMevyhY4HjT8WikkfX13R/rbDAklImxeVQt9zLguwFXcjdg+lp87L4nh3+
	 W8Abb74RvPmAd5rU1xO+1PByqlxxI3LMl0L+AmaDfzRxQF37zZuIardfHqWRPY60HX
	 hfpFupf6MZ5TELHsjPGT8ah1LgOeSylEVcrqgMOohADc7Zso8Y6sjjrK9u/59NwTVh
	 IEv4pP6Q4t+ub3663Ohu0CcwGnQzjWR+IN3zHULUj8LupvT31xw55JuLs4XMY3bFiT
	 gC61TzuGoEH5bdJXPty98AbX1KbkOlIu6Vckf68nE8FgdmPwcAzpnknY9PQ2vgOBLf
	 Vf4G74ucogEEQ==
Date: Sun, 22 Mar 2026 15:13:38 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	pratyush@kernel.org
Subject: Re: [PATCH v2 1/8] liveupdate: Protect file handler list with rwsem
Message-ID: <ab_rAg80Fjp8N5A5@kernel.org>
References: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
 <20260318141637.1870220-11-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318141637.1870220-11-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 26F821C0008
X-Stat-Signature: cfx35p4ika6ydeanmny9jmhzc4rhrceh
X-Rspam-User: 
X-HE-Tag: 1774185225-968949
X-HE-Meta: U2FsdGVkX19mSR+IR4+nh/G20+ftUjv303egUMsbFbOpjB6x1a5tp3Q60NnVBU3CpgON+9B5y2tXUqgZ/ICrzUPjCOfF6J/0PVpJdMZ9BpArcivk4y0694Fg569mOsH2VkOVGH79+zG0KOquTANJq/owgyW2HO3MsXiT2rSX0CNHkjMkSYzMlj8APkQtKH915ExviP6u74snNTDpnQuR4URhUT4lg6nQiBtehUg4j4dnNEf+5G/DJ9WdL43oABGqxWRlaKnhXpOLYzu4DlEITJn6bSzFDsmIIzfaF1v+a88LR9+aVn7GtjqbC0z11Hq3skbdF5vnGcfmCQbaVv24GNdsMQ8m7NN7o/vXkLKN7tt3uR3whrO+Qs2zqXT3F+lV2O8yed5EmEDDkD62de2M2kARhcSNEhPYZjiMGdrrLL8aEvBOuNioUOHchENrOi6P2tKS1A/w3XqpZw9MGqoh7CFS+4T+i8RMzd032HBtCsaMoFRgbUxrFwibSLpZqQR9Yy8v0VW+4s64KQIdA9AmG0oEiFYJku66kcuG4Wel/LfuHImxd9ohjZn5yn4Bfb/KLcxP93R8SARVmBPpe7y2fYOkcXLG1IO/U3+GJwDSa7LWT43YaXs807syBrD+r4ifhPyC1PBGoLneFL+kkL58TnCigE81SokCEo7neHQv7lRr1FcRaROz/ReBQBmA4lPM8snXaGeYK6MjFRgMpif0+sgCTxL78kOf8IFbf7JRhlfZPalDW41AzGsDDzVJ+xDDWY6NsjnOwn0D7QknPU9w2L6VoyqxYsV21vYC+FFilHus9MeidI+Kp7ADpJjDxa96SuO2iE1bSsLp+tXWO+9Cb44gifLBMgbIOHuk+Iy5Uk119pCp+rtN2eCO6AOO0LLpB3EX8mJduVXAIgLLRO6OX21OV70XCNNcnDimpUduo6g6LC994nRjYL9mFThvuun237Zv5v7wUSTci4fBdRj
 A5ecZ9K8
 CmAzaxt+mAB7qYzrWGUjwf0+M585UvBBZdTTms4Oh6mzNz4Ar1Zk+/QfFLSlfRrx6FXS6JjzDUsXLcRFtfbiMiCEKjKzxjBk3zlq8QvWvd/aFbCTKYSbnj+95LbuSJyhuuKwv7q89KsdKc/FD7tKZPn7DaYjfkl272x8raNBZrCu+GvNewCrYf4dkUdT0Wbs4kPcmwbHsmULCNHgQtieQhUJMQbYbQquArAMAmDSCGZ1Oe6Zxbd2iRLcGV0eREhhwPvL/hzaHRc8kATOycn2XodamEGyP4dJcbAhMhvx5CUQkI3sn1Df9gqX3Qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Wed, Mar 18, 2026 at 10:16:39AM -0400, Pasha Tatashin wrote:
> Because liveupdate file handlers will no longer hold a
> module reference when registered, we must ensure that the access to
> the handler list is protected against concurrent module unloading.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/luo_file.c | 61 +++++++++++++++++++++---------------
>  1 file changed, 35 insertions(+), 26 deletions(-)
> 
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index 5acee4174bf0..6a0ae29c6a24 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -112,6 +112,7 @@
>  #include <linux/string.h>
>  #include "luo_internal.h"
>  
> +static DECLARE_RWSEM(luo_file_handler_lock);
>  static LIST_HEAD(luo_file_handler_list);
>  
>  /* 2 4K pages, give space for 128 files per file_set */
> @@ -277,10 +278,12 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
>  		goto  err_fput;
>  
>  	err = -ENOENT;
> -	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
> -		if (fh->ops->can_preserve(fh, file)) {
> -			err = 0;
> -			break;
> +	scoped_guard(rwsem_read, &luo_file_handler_lock) {

I'm not sure scoped_guard() here is better that lock before the loop and
unlock after. scoped_guard() would be useful if we were returning from the
guarded scope.

> +		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
> +			if (fh->ops->can_preserve(fh, file)) {
> +				err = 0;
> +				break;
> +			}
>  		}
>  	}
>  
> @@ -777,10 +780,12 @@ int luo_file_deserialize(struct luo_file_set *file_set,
>  		bool handler_found = false;
>  		struct luo_file *luo_file;
>  
> -		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
> -			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
> -				handler_found = true;
> -				break;
> +		scoped_guard(rwsem_read, &luo_file_handler_lock) {
> +			list_private_for_each_entry(fh, &luo_file_handler_list, list) {
> +				if (!strcmp(fh->compatible, file_ser[i].compatible)) {
> +					handler_found = true;
> +					break;
> +				}

Ditto.

>  			}
>  		}
>  
> @@ -850,25 +855,27 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
>  	if (!luo_session_quiesce())
>  		return -EBUSY;
>  
> -	/* Check for duplicate compatible strings */
> -	list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
> -		if (!strcmp(fh_iter->compatible, fh->compatible)) {
> -			pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
> -			       fh->compatible);
> -			err = -EEXIST;
> +	scoped_guard(rwsem_write, &luo_file_handler_lock) {
> +		/* Check for duplicate compatible strings */
> +		list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
> +			if (!strcmp(fh_iter->compatible, fh->compatible)) {
> +				pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
> +				       fh->compatible);
> +				err = -EEXIST;
> +				goto err_resume;

PeterZ advised against mixing guards() with goto, but unfortunately I can't
find lore link right now.

> +			}
> +		}
> +

-- 
Sincerely yours,
Mike.

