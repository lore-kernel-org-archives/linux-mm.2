Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B3E108B8E4
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C30736B0005; Fri, 20 Mar 2026 06:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE1CC6B0088; Fri, 20 Mar 2026 06:02:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6CE6B0089; Fri, 20 Mar 2026 06:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A015A6B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:02:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 419B586838
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:02:56 +0000 (UTC)
X-FDA: 84566002752.18.C291F59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7B0094000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:02:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IFlwAlOA;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774000974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1tWed0JPdnMZ02Qpxgx0ygPxxtVQHekptS66W3AepHc=;
	b=nIBbifbbrTapxxPHxfmZkhk4mf5YbwTb8I6+bvHAtm0/KQl7u+P6NOxorE6AFc9zrP0Gor
	VsUyYZJOEXBK6FU4WzLs3A+1NinrXHdmwlrjl4I46b+OfoYf9qUPeYVg5wdNloclLCnRs+
	BnvTu31Vfso3owRRCVAnAvqDkr/tbWQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IFlwAlOA;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774000974; a=rsa-sha256;
	cv=none;
	b=Db2j5E40sOZxtDnSMZQ581URDm7OMIDQHYblbaQfQFfeffLZDdhC94erBUpdvl1ry1QGPa
	eF6UU0uq4ybGno5SsIhDF5BG7nljb1VvcOZCbIx77aIkkd/Tf5CR4ZH9eacwG81qPeBags
	Ji4hCPnrV36bi2zqknr1wIZgDQjjj/g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9141743998;
	Fri, 20 Mar 2026 10:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBAFC4CEF7;
	Fri, 20 Mar 2026 10:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774000973;
	bh=U6xZIHEFtVRU4Lo9nyPvzlr8eePYqnne5MPeP9lGDHw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=IFlwAlOACBc1t0eTA75hgfLQoomakaAr0V++zYog30tub5f0bGHHlgXjZfX7+lx+m
	 8L7n5fUfkLsF3nQU/Smmq0LqztVRyoxyiFMKDY0eERzbsa5CJprVeK9S+B5Gq9BaPz
	 j2ld+5pBA+XBGCSMXVOJgeRgbM4XcqSrKC+Iqc6okQRlL6VGPOyofdCrF0b1yJ3TiK
	 QEwy1gdo27047Db308U+70mAo3nnS3DIOWsfliNrDNw5Ui0Ucea2ksVRlMfm20mmEj
	 ygjUhnEYFctt/oHQVvtVDZOMAnRjgZ+auCvDtpHomOLQ1T718lwE9yjUa4kFJD300s
	 ZCXBClMgfZyMA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: pasha.tatashin@soleen.com,  rppt@kernel.org,  pratyush@kernel.org,
  akpm@linux-foundation.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  jianghaoran@kylinos.cn
Subject: Re: [PATCH v1 1/3] mm/memfd_luo: optimize shmem_recalc_inode calls
 in retrieve path
In-Reply-To: <20260319012845.29570-2-duanchenghao@kylinos.cn> (Chenghao Duan's
	message of "Thu, 19 Mar 2026 09:28:43 +0800")
References: <20260319012845.29570-1-duanchenghao@kylinos.cn>
	<20260319012845.29570-2-duanchenghao@kylinos.cn>
Date: Fri, 20 Mar 2026 10:02:49 +0000
Message-ID: <2vxzikaqbyye.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: qbpgai9o5xmms333rdggneqj46hnf9mf
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B0094000E
X-HE-Tag: 1774000974-601775
X-HE-Meta: U2FsdGVkX1+5vlyR38m33aQntUqxIMNMF9n9Wnyxk5WHWYe6Xigq6ta9S6i1oFYgdPZI+RSLhF1Eg7NNgTorQA7TlUVw7MITMq7Oo3Q91wHE/gUT0s+AMgBmYhJ9x7QY2lrgBUNEAe2RggJxXL484j0YgMNkyzAs/jp8ZzTDDRruzJe7XBpJgLmOu4aC/lyWH5IdT7TUvg0ehtr+n6ItOxot5HUia3u+SU593iK+pGEAmURjmGDBaKhZ2wmHJq/fzsvu0paY1KIxAndRbJ5//MRDXJ07jTXLffXvIl8a7/oQ1PrdtBFyB8lMJrrKH1BaCSlzg3VBHE632pgMTngZ0OSQEjdqA2oQAPjCul24336XU/oAU/pDsCm8A2Dt2vdwqQAuFf6ZPqBsdiw+OWLIX6vY5ZT2YVuRcHZ+AtqJ2DhgdiZ+UaBb8E5CsT2extjcI1yVOZCQ8yhPnd7+duBthQoXoGo0EYKgaDlIl1cp6ygj09Q0ddBux8c+ZTPpGMSmMwziSaJ4eP5Fh3hz9p1YqHgAi33RUUuMUtoGxQSOE5qldUCq7udIPhNfMwkBmyJ/jaUixW3iWWkhKlU0OtH/fuW6kWTShpMid6uobXaIMC1wIfxYQPwNoQ1zESNbA+Pjv6t/b2kVraU6EGyLa/LzlVLhxHSbUSVaLX48b/PCUaKZqhtYQXBPv52qhDPJpgfna8V108ULo2yOTT9N2mRPjzn9DM6nS62r8K1nxYV4jIG5RQ1BF6iYHgoPP1zFy4rbgRBR67JX8TxF9IJyhazILSkW+PVE36VbkovNS+8FA3pQgttmgu4PqG6/3NSBfbnGqw3bjgTrlfBLc4FfcYYkttQnCTJfLTmQvnnw+vsbv1UVgT+pW6IKN4HZPrLVtpu6oPzuXXD0Q+IDmDIezArKydg+ls/n2CnfMjNKTPm/uFvEOpTCm58UhmC7h/M4i4FX3o8VJpxw+PP+2Uc04tC
 LUav0euC
 wmmrQDFWVGkxKyJLFg6nxrBxgu1Li2YPDixUcTrZJtce/cktJjofJNpXHBVUEWDvgwS37L+LaJW2+Z1gBkhKrRS9UELF+V83GL8WSua893hracvUQwwVWoyWTf68v/bYrkZL8WSDp+MOcT4Swf3d2AZcWUNwDB9FEjBbBxaAk5fmxKyzO94LE62w1nvkk/Txx9IVqxQcOix1MMEGL7LS3uVeRwlcVvFDTM2qsmRrFmTuuzillzYHdP6cd7sgz6WylqCdO/NP2cHG1np7bqdsto09zzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19 2026, Chenghao Duan wrote:

> Move shmem_recalc_inode() out of the loop in memfd_luo_retrieve_folios()
> to improve performance when restoring large memfds.
>
> Currently, shmem_recalc_inode() is called for each folio during restore,
> which is O(n) expensive operations. This patch collects the number of
> successfully added folios and calls shmem_recalc_inode() once after the
> loop completes, reducing complexity to O(1).
>
> Additionally, fix the error path to also call shmem_recalc_inode() for
> the folios that were successfully added before the error occurred.
>
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
> ---
>  mm/memfd_luo.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index b8edb9f981d7..5ddd3657d8be 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -397,6 +397,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
>  	struct folio *folio;
>  	int err = -EIO;
>  	long i;
> +	u64 nr_added = 0;
>  
>  	for (i = 0; i < nr_folios; i++) {
>  		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
> @@ -448,12 +449,15 @@ static int memfd_luo_retrieve_folios(struct file *file,
>  			goto unlock_folio;
>  		}
>  
> -		shmem_recalc_inode(inode, 1, 0);
> +		nr_added++;

https://sashiko.dev/#/patchset/20260319012845.29570-1-duanchenghao%40kylinos.cn

AI review picked up a real bug here:

    Since memfd files can use large folios, should nr_added track the
    number of pages instead of the number of folios?

    shmem_recalc_inode() expects the number of pages. Passing the number
    of folios might under-account blocks and bypass tmpfs limits or
    quotas.

    Also, shmem_inode_acct_blocks() earlier in the loop is hardcoded to
    1, which might have the same issue.

If THP is being used, we should account for nr_pages instead of
nr_folios. Can you please also add a fix for this with your series? Just
so we fix the bugs the code already has before refactoring it.

>  		folio_add_lru(folio);
>  		folio_unlock(folio);
>  		folio_put(folio);
>  	}
>  
> +	if (nr_added)
> +		shmem_recalc_inode(inode, nr_added, 0);

Nit: it is very very likely that nr_added > 0. And shmem_recalc_inode()
can deal with 0 nr_added. So please drop this if check and call it
directly.

Other than this, the patch LGTM. Thanks for working on this!

> +
>  	return 0;
>  
>  unlock_folio:
> @@ -472,6 +476,9 @@ static int memfd_luo_retrieve_folios(struct file *file,
>  			folio_put(folio);
>  	}
>  
> +	if (nr_added)
> +		shmem_recalc_inode(inode, nr_added, 0);
> +
>  	return err;
>  }

-- 
Regards,
Pratyush Yadav

