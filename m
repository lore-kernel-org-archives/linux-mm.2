Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69570CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9165B6B009B; Mon, 11 May 2026 08:44:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0126B009D; Mon, 11 May 2026 08:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768AB6B009F; Mon, 11 May 2026 08:44:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60BC96B009B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:44:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B50C91406F8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:44:23 +0000 (UTC)
X-FDA: 84755107206.04.5F8BE6A
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id D43D71C0009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:44:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=roAoad8W;
	spf=pass (imf18.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778503461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bHitmBP8USNGMLAXOmkdJpRqduMwp3sFGN+yTzeTwUQ=;
	b=RnI1hB9dlYjDPlJ+yhDRzCGAZrYECAnXxMX+XZBPtt/zYzDmaGVVctu33Fzu6i4OuGkRPD
	VL9vOLbYVtd5PpnFUpTKMu/6FcVxNGjFathK5YuisiwfE/XKZrwPDivAviXZBwKFGOdB+V
	/svQIZWZfvOYyQyQmLcWAbray8z0MiQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=roAoad8W;
	spf=pass (imf18.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778503461; a=rsa-sha256;
	cv=none;
	b=rQAi7vWCuWIoS3BPSojHo4KLtmcB4zY89c5F6pg2gg0nEz2LV61PQL8Y6JvQBMsLV9/GjW
	MvkxojkL1pnCzh0WyyQZ4lnlAxJG27H9/sCy22MpJN2GZwsXGXKH4BMS//MnwS4RYTE4O2
	9Xw8J6keMnHUAal/h1fc1MKXXdscJjk=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4891c00e7aeso36078335e9.2
        for <linux-mm@kvack.org>; Mon, 11 May 2026 05:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778503460; x=1779108260; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bHitmBP8USNGMLAXOmkdJpRqduMwp3sFGN+yTzeTwUQ=;
        b=roAoad8Wg+XphzGanAzju+wE+S6rSSbzzP35t2eNySKdHd30wGMmx2jR6m0s9flMqC
         8rA+eDc4zSoY+478D19Bb9rYjtcyUcgzzUb8RJ3FCBo5VBBycxZQ0MHI5Pj0gKK+WJTj
         tcQzJ/mfKA07Ow00QhWBdo8yGzKioKyvKd6BYP9xnf1doE7yk2w9wEXkCvaIC/LmP/vo
         gxo4Mywq+y8gUZBA+7TgeooUTT/IWKau6DS0k2yFPvDfoilJuMb9Gl9GOMGvOqmTaKGe
         u+GmdyzWTZx4CSQJXIKfxBMmm/ktNwQaUrOsgId3aOp++LYcrW0jZ71n6yx3ZhklTX/4
         nOVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778503460; x=1779108260;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bHitmBP8USNGMLAXOmkdJpRqduMwp3sFGN+yTzeTwUQ=;
        b=okD+W/+o9jhrCLrTIAZpUsKn0nRo7p3fcAJ+SmbS8Yq/tY6763lnsr4yCKkG1sMmiK
         TUGyOunWQL9zFMi75rwCLTCG+sVvT45QbiUryof5bsTCkPsdhqBeB1t/2Mz/xmDLAe3k
         dC5umdkyUtVKLVsDu3TTNUtxHnigA9pyqeQZWddC+ywZ3iLTQaK1mhQ5Ga36352irlzU
         8SbPS3T1ljXWqgM9HVbEkKY0Y8rIYMoLKcFz0JG1FkFGDFqBafmAMBd5bgEkYayTuBg3
         zDO49Oy5O5lUyRs2R1GFUC3M4CESIPi0Mg7ubonmq9o4Nv0bkgPulRAjrTZZl7410nLL
         EJxw==
X-Forwarded-Encrypted: i=1; AFNElJ/Y2JwzD57vIcvGUo6d23s/TPg+eVEWIpUknXU7TrXuU9mjuJM8EUf0zr+4R1BaWvx2BpTiaTDn9g==@kvack.org
X-Gm-Message-State: AOJu0YztFocNYmogXKIGh9/BwCZCOqnYplGfVxLMygscIQa6a6NmG6wk
	Zn0X0+B5GTzTz55sPdJgdNbOZaoME+zTBTNlCyGU5BTnYL2eGE6jtoi4
X-Gm-Gg: Acq92OED+77+mdGXqDczX/VoyiCY0IaYoG4iWvirHivenO2HJ8n3JjP3nKN5e+3338P
	fRaIP22s4mXOSuhcNmLjV/WNb5D0C7RXE3O5rpAi2CXUIRSfQZbbV7UOQOApjYGOT7UpSSvjT7H
	kDrV++4EMtsHFF3H1WRFgkihRxO0Hf8Yc3k6vQJZ7ebpHKUFRsUCsyLL1fWequ6eBBcB6LXCWLe
	4o11cMsBwxIGFju/UhfDDkgYIBB8YULH7fEpnnwSBivHGUrVvgYOzFwC1luBEf+bPAS2Ae4tREj
	LQXJIM2mj2egBrOH0Cf5FImc3CP7vR5TxfC+bYAnAWeyvhp3iUcangTS3SfIRDtqFZr69K7lOW7
	0JF18ZZIg/sUY+Rcsfzk/WdPiWt2dvdipvuO9Uvrtcxnf/CDhFgCB5F/EYVJVdbxDx3b3vAXCQ4
	BNsT7qz9jr8Z6r3o5UdXMYXClKx7CtUABDrKSvkg1lqm9KCseLWSfP3zC2s8w1gYgUVDlRJDkxJ
	5IWkYTLcUag
X-Received: by 2002:a05:600c:3548:b0:485:3abe:ab86 with SMTP id 5b1f17b1804b1-48e51e0a6a2mr360497845e9.4.1778503459729;
        Mon, 11 May 2026 05:44:19 -0700 (PDT)
Received: from fedora ([185.193.234.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e702e6d41sm234731455e9.7.2026.05.11.05.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 05:44:19 -0700 (PDT)
Date: Mon, 11 May 2026 13:44:17 +0100
From: Vishal Moola <vishal.moola@gmail.com>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/filemap: fix page_cache_prev_miss() when no hole is
 found
Message-ID: <agHPIcZHHyzBjcGN@fedora>
References: <20260510-prev_miss_fix-v1-1-755bb123145a@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260510-prev_miss_fix-v1-1-755bb123145a@columbia.edu>
X-Rspam-User: 
X-Rspamd-Queue-Id: D43D71C0009
X-Rspamd-Server: rspam06
X-Stat-Signature: qux5nmp5dzm9cbkaikpmmk8a4owa58f4
X-HE-Tag: 1778503461-169168
X-HE-Meta: U2FsdGVkX1+YGk0OhjtoCc/q5CBhFTOmpMCUgVEyML/4PoGXnembEi2F7Sm81TTuSyCx/+oKdcvrj64nLwm/d9y4Kz2hOpDy97/sSuXj+Pg9CIqvGW1gLgutLZC2hxzVUOK1SMQglDEdjPQYE5SgC3Qfg81kpb6QiYfiZCIxVZshGKGaqoGCslU0MoDecrHZF1WupN5n/L+3D7TYNI3pQIMaavJ3QpNGdZ7mobpCmRcO91T0LYihWVgyUExTt11rieo3Hb+R4ZnaWnAZ/nAFPHQiEr4ldxW7xS1Gp/FhiOUyua2z8E1ONwzjsCPn1mI0hTjdxNI9Vtx9+XNbAcSDBj+XX0xm2s0T6YGVx1APJjRueQPCr5a8F6nO8GiAx65ciP9xDWmiSUzswn7eapmZL2aJ3Ukm66f17fqlbHEns89uBXJHs0kZ22eUivmHSFrw6Um/Z4SrwkcLXzMAB0ku3gYhfmuAvaXd3TlrpWcJXc2/NxdwjA8Ayv6hsRxogvXl6JddLiDpt/uGeTPc/iNOSaQPAZA9oC3/aKxhsS41cZViJczyu5a8QcgnR0mZ3cJrxtxWpuTYm1usWJdwwv+mw1g+1YIZIFCXutqXPaI2DSTCCyPoo8jXDu+WqL1n1Dw39aFTcWSFbMdThd+bzpwwDWFM43Xvk74VvkfNPOvdqKNK4WdpwKqAwZVmYc7dnWPqOs4UMvUWYFiAHCB8S81xWe8FnONX8jdxbMI5FlrRQ1xQ+SvBkk255RnpqvNi/zU3L29E/jbXsV91+6FTnB8bWwA4OQi9h78M0j1Mkmghga7sL+nw60bvjFkFnrlwz63wyurV9i3sQ4XlLiNTgXmDOT3+kUaTVUWiCtVi5HG/B82MvhC5wkVLZHTq7OJHbfbWSSyap+ZBgvURhBYOqFU9PDubusMmGgUMTFYryVFaBdBAWVfapQUMzrptTvbrk1SkuI0+R0BG6/EtjoFJIMj
 sfT5to66
 CfQkXOzbnNqXZkZrZyM66pzKJJn60VeQjkZlwp72nIUDHdes2jBItnk9XhTBXGGQMkfJmOTwVDMFQgvoEechPID9J7sr+M8d0DruIYHXQbJK0TbMXJcSoCysRD2LuGV7YG1wtVAgTvGjjIWlZ7jOw3YWUMJPqG9cVzvQ/DmlrdEJL30mXj2F+PlF2XATJIaRrTl/+PrQ5rYyeg1k/JqENS1NAhegva93ZFCzjjojm3kuCZt+QoFnpw+0zPWpUCHuds6xuw8Zr4sesVx45vRr029TY9fGqMr1dWw0UInZouZSvHrmsaUao48jqsztt/o4FKzD0Ambuh7mlpomM7cIGVJznmzx9/xeQtcywJclSJLIkziWb659j0QC2SICXp8mtj5v7Z7pt7L8x/5161fSYl0a5IUUHqz7rlwaM+rA6QQqz8UPaEvtY3b39+FpO1XkWv5RvMSaiIr+olWpdJtBRNbVHEC9grw/URghhkbbV8D5by5r1az1MLaLbJ5mXuUg8WfRz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 10, 2026 at 05:54:17PM -0400, Tal Zussman wrote:
> page_cache_prev_miss() is documented to return a value outside the
> searched range when no gap is found. However, the no-gap-found path
> returns xas.xa_index, which after a successful loop is the first index
> in the range. As such, that index is misreported as a gap.
> 
> The sole caller, page_cache_sync_ra(), uses the return value to estimate
> the cached run preceding a sequential read. In some cases, the buggy
> return value can undercount the contiguous range by one, shrinking the
> readahead window or pushing borderline requests into the
> small-random-read branch.
> 
> Mirror the fix in commit bbcaee20e03e ("readahead: fix return value of
> page_cache_next_miss() when no hole is found"): preserve max_scan in a
> separate variable across the loop and return `index - max_scan` from the
> no-gap-found path.

IMO, this way of fixing it hurts the readability. I'd prefer something
similar to the fix in the original commit. Or...

> -	while (max_scan--) {
> +	while (nr--) {
>  		void *entry = xas_prev(&xas);
>  		if (!entry || xa_is_value(entry))
> -			break;
> +			return xas.xa_index;
>  		if (xas.xa_index == ULONG_MAX)
> -			break;
> +			return ULONG_MAX;
>  	}

If I understand this correctly, couldn't we just do something like:
if (!max_scan)
	return xas.xa_index - 1;

> -	return xas.xa_index;
> +	return index - max_scan;
>  }
>  EXPORT_SYMBOL(page_cache_prev_miss);
>  
> 
> ---
> base-commit: e9dd96806dbc2d50a66770b6a86962bd5d601153
> change-id: 20260510-prev_miss_fix-fcb308472131
> 
> Best regards,
> -- 
> Tal Zussman <tz2294@columbia.edu>
> 

