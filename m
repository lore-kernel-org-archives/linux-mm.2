Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79F43C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:09:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C80F16B009F; Tue, 11 Aug 2026 13:09:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58696B00A0; Tue, 11 Aug 2026 13:09:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6DB76B00A5; Tue, 11 Aug 2026 13:09:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BC576B009F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:09:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 22AB840162
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:09:49 +0000 (UTC)
X-FDA: 85089625698.24.4B406CD
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id 508232000E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:09:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J6Ay+wzh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786468187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1d0Z6GiRpfaFJ122+PixKT54mSvnjy/SfDrP4mu65nU=;
	b=pkwxKcRPbEndbBrs+EmoVh4lnZNYcnKZJOqrRNeHMemFyWIj0ce0Q7YcYUQTfTZdjEgv2B
	GBRrIZ9LU96a+2HwkKtrxbvn+r5I9kaYjPzJfbr2jW0wc/LA17QmwJyMyBZOXJHlFi9mJP
	pmQq4IN+ZEV23tgby3KC+FTyyquiAPw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J6Ay+wzh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786468187;
	b=7CcU4g0mtIWBfogS1ICsDHJuHgHI+Krzqf83gmdLNdwAJ9fOUOxHFWrYzv+E1wTsNtoSRj
	rePEFnJ+LBlDbbUmTHG3TeNO3LiNhbmF724WPMhm6ByDNwI6FKKpQmVHfi13Jy88CFmx+1
	lrzlwM2ewpEcrV7AvyyvqaIU9ocbsC4=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38deea72eebso120456a91.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786468186; x=1787072986; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1d0Z6GiRpfaFJ122+PixKT54mSvnjy/SfDrP4mu65nU=;
        b=J6Ay+wzhmNA30Snw0C4oqKPiBtgQ/rdt1PsSL041io9o0LodxCAdqNAONwHk7cZvX2
         vB1b9r/bw5LsozDN7v7RtIV+3W5h5uXCBbi+lgvAWugQogHyf9Zkx+yN+7mPxZgBdGjV
         qAoyrz7zUHJjiIKtsViSsVT9Mcwl5+c9aXGm8uU7ksQe7McWgzsHdh6Wz9lbQm0RUKk9
         C4aGOTG2MgBWbGv4zrumfDXx3sxc/e+r9bimMb9Qi9mDAlspvG53y5OUHqfQ3RaPZtoF
         dkR270JXuev9sygdSVUJ/QvC0U3K6g0wJ2GQ6K2HWwgNWRPPsS2tXtoyTMxBPDe7jLo1
         XZyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786468186; x=1787072986;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1d0Z6GiRpfaFJ122+PixKT54mSvnjy/SfDrP4mu65nU=;
        b=dHAlvy0LMLgoPT3pQNXxSZNGtXWhQWTwZlHUDNRKy58Ttw/EPh4LKQuJKCMPR2imwF
         6BGDjsfCe1LniVNT8W1aAZ2z/GRPJ5c+4gyJt0OVRY4YRWKp88e5eESB1LIQKlOlHQDL
         qm/mrQYgN42vvzzaCY4sgPmu0y07VrgUiVKLTBJaqm8S8YCH4l/90Ow7PcIHo4rNMdgl
         FtE4cH1osi12RhXRtWDWn41jY74U1aMv4+EZmPzwO754TyWT6u9vjPZ7hNDoPAeG6kns
         bQ9qIzy6gXSZrUx457evW1elMPBNw5/agFjMD+VaCvvfBGcNpJZ+SoswZFOp2wldQ+5t
         ZZCw==
X-Forwarded-Encrypted: i=1; AHgh+RqLgwQfMdTXG/Msg9IUODmpZQqW+N/AFFuWkTqDOWvPKF5g3bVZMgDPUBDuQDL8NJrDR1QCbqPDxQ==@kvack.org
X-Gm-Message-State: AOJu0YwJgJ+n1nEYnpCHDRGiAgVIEcHfaUMlNDO2+e5ogjNgCX3Zd/PR
	22TDyKmwel/R088uuDicjqGwFMbQJtv93dV3dox49De5YlYa3TGRx4to
X-Gm-Gg: AR+sD126Wly43lc2U8CcRXMNFKL+49GLsTbmxV7WLGk4R34iGUUb0Pm3s5fS6KoqnKK
	+pZvQzsjlqCorXDTDwDMUJ9iu8N7cINFn1iBA3RImocbBUgHW4BAtjuS7gVWR4bA9zaWscdEzqI
	wHJU78rKsNB+BzPNd8FJsnQP9n3cmZv3vvnMxrBYtUy49+jhd7vGzOQfhOErCtJx3Zrwmh5G6Xy
	YRMKKwb0pcUheNTUtjD215r6KUAZ6cLUgnWzEOXi/pKsNlrGb/WwPSyo4RWcjxgnOS+JkSQHYHR
	34h+FSKsgLydpWgiLegMjD1+aZlnzw9V3Gp79u60H4lJeLBQwdLP12QxSurBGaHxWAYNAApNPUf
	uHQ/ce5vZJD6fSX9C9q5Nn7Xm1fJHXAb83P/wyVeV3FGdPqDLFEv2OZBbouL5OF2EnH28lQ+kQM
	Ow87Z+hjmfbO+JYqnZF9UykcgWmqyAQPLC88sLrDK+3qkTFcJaxEIJ4M8Q68P7Ln3UR2JEK6B49
	syH5wEp5LJ+bp+UD7qPyMuuyqx3OnTkZkI=
X-Received: by 2002:a17:90a:e7c6:b0:38d:e0c4:c955 with SMTP id 98e67ed59e1d1-392ec626baemr5074302a91.15.1786468186142;
        Tue, 11 Aug 2026 10:09:46 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392f88d239esm348021a91.6.2026.08.11.10.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 10:09:45 -0700 (PDT)
Date: Wed, 12 Aug 2026 01:09:28 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Jianyue Wu <wujianyue000@gmail.com>, her0gyugyu@gmail.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] mm, swap: drop the swap cache guard and reclaim
 in swap_free_hibernation_slot()
Message-ID: <antScyyChj0XfXJy@KASONG-MC4>
References: <20260811132209.2862708-1-youngjun.park@lge.com>
 <20260811132209.2862708-5-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811132209.2862708-5-youngjun.park@lge.com>
X-Rspam-User: 
X-Stat-Signature: a9ygboemjxyuaf5miquwznb8n1yzkkm4
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 508232000E
X-HE-Tag: 1786468187-950276
X-HE-Meta: U2FsdGVkX18kqGBU+rcsaNtjs/8a5Xw/nOSJkxKeenYiCi9/dy4aPAS3trraFUehIuL33DPiZDP1iw2vJnzlUBNBeH4Stf8QobFIuXopa6kxUlVywrX4dyx8symsnpaqxrxeBH35YpssoYpaPgrRuGZK2ycIwGIJ3SCY1iUiZmv8eL2MnUvYrTfLmQ8OrJuoyHoL/Y3DomDSSQ86qkDyXBGB5fqTlivkS+2vyEBhSIVASK46KOFX1xR4FPYtnw5WeZH29UQ+deGUro4W9AaPB49INKZDMKtLmR8rienAiPHGUx2Io43YYsNwDO9jxXbMDuSGLgZ2xz4guEaD1wcYB/vFjBcWh0RILEkkg+djAM0dPxo88Iyk/CUUpOjNeDJuE6PSy2gZTWs/oaOpvyHnVzZ+vZU8xsv1XJGvqM9tj9F5PMggeybhOJSi+44j5BIk3/ciqf70qED3XW3zxhmczEpdCT4k+8KTjMNZzDwpIXHkv2T+lIWdGH686iQejH3P+88vNr4kL3RbwVr/WtS9iyozHNToXOYhVEWePNlu5EmnmvCO/WFNR8embl9sJx/bZiRJovEB9T1JtnQzewD7263YUxcWetXMVJOGm7eCBkmghUvbLdq48J6fsKf45HhgIwgLRgRHs5MDzjG64vEDiYMuWMGsgqcJmFkD4ZdbtrnkGu7fJKWOZj/y7hwPL+beDBBdLQ3dr6hhRHBYZgAW/7YJXf1QYr7B6/v/7QXC1LQ2JV8+zWQnoD3t/trbxIs8djyQBkCUiRxV4ZMWorXG7+QC8AHoIEjVY9uysVEEauF2YszePS05iknr7MqbfBmrFp/qhvS2NTIiVCdkZl1eMnFQJeKbULdAGP0p7YaSKKLy8vAQG24/k+qm9BMFKKv8GFBTazmbvt9shic74WwhEQAhkJ9oFc/GzTEblDuVBKgb3grj2Q0VmGiblwjTP4ZOeO6HiVTKWAYV87bK6OH
 KsQZYotc
 1Lngf8ziYGyntRlae6mba/nYih/jhSBazHTugrggwP2OhpgFGWNMnOxm7tRZbI6eforJ0oESncnyOZPVzp9WWGwwHl9PPJS/Fpc+XP6eTzfdhkHcVZBgIFI9JhknHRX9W+VzXqFQAj6wqFFv+P8aw7Ko1pL+WsI6jyvtpJrbxkT1gsIrGef0h0jLQbNJAgfY9+z/I1LyHuoM6JcFWJ/Ue0AtDD4pFLTqXGkHA1xEph07ENoBEbzkHiJaJVuC5MKxlHkePkaXKhsIuNGd51dwy3FlP6Z9Wla2yo9ddeNfMiuj1HspI+K2AJTtxq64EqBYb7J0ck/rhGZfy3RP4b6ZmH//39Q1A8fUbG07Becao0rpnnGnKf8d4m3vCTupTu/ISoZjEEelFQbLeYGq4K/tK7SogV42HSGNpYFm5dfaDXTsxtyNRJ/FplnD/VNBCk+zpvvAu9+j9ZGTCLOj6eWa8gkvji5CP9JTZUVNBR1dxmRavQ+4H1G3GXyZt7mw6JRT6UTZUsrawMnDI2m18XYMULypPQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 10:22:09PM +0800, Youngjun Park wrote:
> Both are there for a folio that readahead might have put on the slot.  A
> hibernation entry is not a shadow and has no swap count, so the swap cache
> turns it away and no such folio can exist.
> 
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swapfile.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index a337387f7431..4fba1770ce61 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2203,18 +2203,8 @@ void swap_free_hibernation_slot(swp_entry_t entry)
>  	pgoff_t offset = swp_offset(entry);
>  
>  	ci = swap_cluster_lock(si, offset);
> -	/*
> -	 * A slot with a folio in the swap cache is freed when the folio
> -	 * leaves the cache, the same rule swap_put_entries_cluster() follows.
> -	 * Readahead can put a folio here, and freeing the slot now would
> -	 * leave that folio with no entry behind it.
> -	 */
> -	if (!swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER)))
> -		__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
> +	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
>  	swap_cluster_unlock(ci);
> -
> -	/* In theory readahead might add it to the swap cache by accident */
> -	__try_to_reclaim_swap(si, offset, TTRS_ANYWAY);

Nice to see this gets cleaned up.

Acked-by: Kairui Song <kasong@tencent.com>

