Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B04D3CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 18:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7FE06B0005; Fri,  1 May 2026 14:59:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57416B008A; Fri,  1 May 2026 14:59:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B936D6B008C; Fri,  1 May 2026 14:59:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA22D6B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:59:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2EBFE1A0237
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:59:52 +0000 (UTC)
X-FDA: 84719765424.26.9C22729
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 510A516000C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:59:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MfLfO6tu;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777661990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C3umcs7hPnTIt6bZruKgswwIksEQkK1T++wSCt9dAno=;
	b=unWSOUqdHwHO3naQyYD6drX1wzarbFIrVf796ZkblEqCHjzqVFubJwcorSlVNi5j6H4QTy
	Y1rHszVarT6dEVS0nXxCsqGnlRob0OkF+7YyIS/G0/kyNNF3OWKynpqkTAYrsfL3PFKvA0
	Y/n/3aLcw7XsvdNhCzBKQ4HCSBmyTHg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MfLfO6tu;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777661990; a=rsa-sha256;
	cv=none;
	b=mtWET8z40NtUroWsFk6RejN5Tuewj81aLBnFvpUZPAnybCn5gBa3tkMQr7o5w1eEpcEfx5
	XJkCZL3hdWsjDK3LZZsCri0qOjbKLY9Ce84CS4KwCVbGsZ4uZFFDldGdVybJQcsAKMmSwQ
	z6ovNh4mSTjJz8IOJR1dkk6McNMM1WE=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50d6ab4476eso20314871cf.2
        for <linux-mm@kvack.org>; Fri, 01 May 2026 11:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777661989; x=1778266789; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C3umcs7hPnTIt6bZruKgswwIksEQkK1T++wSCt9dAno=;
        b=MfLfO6tuoQwykz2YoZqNMNpHPnytzlETtcc56+67gkgZBlkz08YMCYQCwVugcPq1wA
         HzDp50QMb5PjMYvafMYCqqSTcSeRsMgrlx4K+xjb5A1eGNebye7BiuZjCvKlbu0b/nap
         UqOBfxSIFM6OodToKNDy1NegcKmO07asw5C/2FBPjrYoyQHlGO/kvUyAGw1x8pPwp/yU
         7O1XDmDcK6snVeqnDrrOmkvuxBt7gRAlzK4/Pd5DFq8XaXWdNeTMKqpqq8mHpa9TbVJl
         IMT9jQX+a8lDD3ZchIt2YUGStpDFvqPg8T9E/31ojvIo1BOpGSZSQYQZwoVruWWEbjFm
         XdXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777661989; x=1778266789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C3umcs7hPnTIt6bZruKgswwIksEQkK1T++wSCt9dAno=;
        b=Y/lHnXNItVC1Bzg238cN62zI5qgyc8BZ8QapIqQkV/TBjXyTbgvpjIkRBK00HcrMgE
         k/4CGcgJXKmgiLJuAVp16bQmY4GJpTGEfBox8DRyolMVVqx3RvHhuZ7ULNdZ43CVZTOh
         jskwJ0eD6NRhIpRcKIhAFrYbFMmye7WMmCFMRILaOjGVHJfX3qJl/oJNzN+sIZUAqUo8
         hlakL+m5kvrGXhrcNQpVOrD0u0yY9Dorw986iKqCDe6hTRif6kmLT912S8MVJPDpdOYG
         U+ASRew73elbvQ5cqnkKPXNscxgNYnwtNcOBac6hyE2LPE7LmpCbdz5c20qgQCaiKbFF
         mQjQ==
X-Forwarded-Encrypted: i=1; AFNElJ+z8f9T1ndXUVAXgJcwWHb4EPMGV+J8IEwSec1CRRID4vH+6Up5siHY5gmQXCeO+NGrsh0oKOvMkw==@kvack.org
X-Gm-Message-State: AOJu0YzBxRYnSWxYpasSo2q+KwByHXDbsDBhccuXQx9zzIpxrhOolykb
	VCrsjqF1iMR8QJbn+8Lp10TEviv+aupf++wLcoRUiKYB3s4NA3gRphOikVUItJsI0Z0=
X-Gm-Gg: AeBDietyODrLO26tm57AVslIlQ+PTXkuOadpwD5D5XoCIkpAV/1Jj0RqhdEa9mo8pB+
	TkLeISelXmHSER5XVp+Zs/XD91ZNIMqZ1QNh8MguiM1V93NiX2CJwZE6S/jJyupj+yZNerpYun2
	ngyqE9BKTIzYLJfIAKSgvYgZlg/P6H7xp8sfv2IY11QNTU/KXD42qtzM2gudbbMzgtqjX2oLTz7
	IWJj4Yc9jAon8khDNXyvHzBmkWRvnBUFHflqOY79kXTv7g+Tm/M4v+N5zRVb7XfjU0ui2ElsNgd
	N5xCpEa3uTcXXtrsfBqAN4oL/xVsagoS7AD+E6EnuBBISCUenN+gftdXfjmFCj2fLoNJK3XDrOZ
	x2i8dtV+238dN1ssvB3oLN0BD9YPCFFyP2lK3z+VXzH8Gyy/SPka2Hba2eZld/3aOqFnFMvADNa
	qV72HgjNGb0z8BBxlUmygjeaeEQOpWaYTlMqFJ5PAOZ5N1EzZPMit/6eHKT7gbpg==
X-Received: by 2002:a05:622a:408f:b0:50f:be8b:f803 with SMTP id d75a77b69052e-5104bf0a257mr8184361cf.29.1777661989331;
        Fri, 01 May 2026 11:59:49 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51040908d6bsm21660101cf.7.2026.05.01.11.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 11:59:48 -0700 (PDT)
Date: Fri, 1 May 2026 18:59:47 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Carlier <devnexen@gmail.com>
Cc: akpm@linux-foundation.org, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/memfd_luo: reject memfds whose page count exceeds
 UINT_MAX
Message-ID: <afT3no4OkYxnQ6zJ@plex>
References: <20260423125648.152113-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423125648.152113-1-devnexen@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 510A516000C
X-Rspamd-Server: rspam06
X-Stat-Signature: gdpqi9e3o86czkbwdkc15ycwexp5bqo6
X-HE-Tag: 1777661990-377560
X-HE-Meta: U2FsdGVkX1+9XtPw3N5BsPnooXJ9DsrCXije2BZ2t8ffLoooommMIbcI3118Qm6rfVdZeqv2pBSOINpaZp121C9lHCVBaC61Jbd8cGnlLjtUI1SlsE9AjGU/AOeXb948xeBPxx9F17lwUnnuiN8GjUhmyzppjdPvxkOScX6TEZ/5eBTqA4cqcyrn4aTRpV0Cp7RGfRKIhtZncOA+DzvOpL0yp7GxlCsTT+hmzdEFRUv0YtbqtDR3EkQlsulQGti/Pf1FKmPiqiqYgimkQiRLK11eE2kxEI11uax0wXrSWiGCPYIsXTOQcsCmgYkSRD6ITK9LXwx8Ku0ehxsDU7Ek1O7/ZmNZTBsnNiNqxrUUDysitOb1YKjQMC9h7XziB5SGXRHxwIOsIfP/tuTMNwx11UcJvIXZU5K3zCWhQA/daJK4TkBmB1XeWcIV1CQUythLlgVv+FjaUU4Jf/4uP65nMvqqg3leewwYqFH2k96gfAN8bM7gCH+HAouGRh2YjR+/rSGrxAapLpETbKle942kTQ6BYVytTV1NKitvOQL9z+XZT49Bzz99DZWbWjqsSQVqv6VnUTitPK7fXWOvz3u6ox0z7vkBqrv2H9PM5IdlJg45PeG042SWp9iJgjRI1lzDO0WFj+knXeSijOqrITpi+x01Qd+X4UyXUIEyXI6h4BPMzdIz0za+l5t7wVea43rL/B6CGg9iVWfO12dOYgLqoxDO2Y7yknfuL64uq3yX7IxtE46Uk9pwqXLtW2bujWlyMiX3rkcrGfrggt8/yzRzpui+7R+7MbhSDvcqreTwxGJ+bRiligG9hS7CYFMBnOmJ9ZSs6NIq72wrrJhO0RQ16IaZsx0rGMFbCmbU7/O6SpbSW7AxNLTAuizBqkHZazNryOiD85lqAqyfDEY43szJQrcRuhjlTMy0xFh2YRSZlKNLheqnSnzextadEoq+J2tAhTdUm6kVpRP33MflLm3
 0V9jjjkj
 3f32bs/OgNN3ibXlStfkb0kBF12EwNHEX8SizEY36qUSxRi+2xIuu21XKXU46up6CrzthwRPLGABU9iOzcRxWcTECBiXY6XnrEuRSQAQZUhTtH37eVrX0J4uAUS+Crg5TUkHNB9EhPb3f/aDe4V4fWp1kS9fztf510qxdF2Rw+rOGCk6dFf/oSTeDS9sG5SrbpNGUsRPO/P/jXFe10OM8iymlqfVerBvr/HbsJ9fxPDXDxNwGzZxNXUlzDYX+1hc3hDSofcUIgBYxj22f7wbCUIYnUsWQxlZk2rH6wRn9b4gYIQ+x66dxBZvC9iOGLdUlv2TqBJTCUuXjWstQTNUUHf7U2ZgaEbZJrws+fOESbpaj9kVoRlfDl0PaRo/UInIMgHyV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-23 13:56, David Carlier wrote:
> memfd_luo_preserve_folios() declares max_folios as unsigned int and
> computes it from the inode size, then passes it to memfd_pin_folios()
> which itself caps max_folios at unsigned int.  For files whose base-page
> count exceeds UINT_MAX (larger than 16 TiB with 4 KiB pages), the
> assignment truncates silently: only a prefix of the file gets pinned and
> preserved, while memfd_luo_preserve() still records the full inode size
> in ser->size.  On retrieve the inode is restored to the full size but
> only the preserved prefix repopulates the page cache, so the tail comes
> back as holes and user data is silently lost across the live update.
> 
> Reject such files at preserve time with -EFBIG rather than chunk the
> pin loop, which would also require enlarging the preserved folios array
> well beyond what is practical.
> 
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---
>  mm/memfd_luo.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index b02b503c750d..f41d11053b7d 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -259,7 +259,7 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
>  	struct inode *inode = file_inode(args->file);
>  	struct memfd_luo_folio_ser *folios_ser;
>  	struct memfd_luo_ser *ser;
> -	u64 nr_folios;
> +	u64 nr_folios, inode_size;
>  	int err = 0, seals;
>  
>  	inode_lock(inode);
> @@ -285,7 +285,18 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
>  	}
>  
>  	ser->pos = args->file->f_pos;
> -	ser->size = i_size_read(inode);
> +	inode_size = i_size_read(inode);
> +
> +	/*
> +	 * memfd_pin_folios() caps at UINT_MAX folios; refuse larger
> +	 * files to avoid silently preserving only a prefix.
> +	 */

I think, the fix should be first done at memfd_pin_folios() to change 
max_folios to 'long' or 'unsigned long', and then just updated 
memfd_luo.c to match.

Pasha

> +	if (DIV_ROUND_UP_ULL(inode_size, PAGE_SIZE) > UINT_MAX) {
> +		err = -EFBIG;
> +		goto err_free_ser;
> +	}
> +
> +	ser->size = inode_size;
>  	ser->seals = seals;
>  
>  	err = memfd_luo_preserve_folios(args->file, &ser->folios,
> -- 
> 2.53.0
> 

