Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2EF3FEA824
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 10:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C676B0093; Wed, 25 Mar 2026 06:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6376B0096; Wed, 25 Mar 2026 06:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29D446B0099; Wed, 25 Mar 2026 06:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 162146B0093
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:21:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CCB825B2A9
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:21:10 +0000 (UTC)
X-FDA: 84584192700.12.95456D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 09BCEC0008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:21:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DZVmn8Ix;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774434069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rE7qmZV1HsjBNJazv7yslxH56lDIVT2C68J05A3H3Qo=;
	b=3Fyw9j9nfty4sMMNan7GYvNhB1oalBuIJbu2XI2c7ukbaGfsENz6WSn+xKcGpEy/Cmi02N
	bh59jWQtBGIFT4Js81RXIKtR6xOYyYGJyQW5QA+AFh1dIukuyBexxZjM6lPfudyW7ZeJnp
	eh2Zis6ebGMnC4FuZxMssZUcPzekEhA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774434069; a=rsa-sha256;
	cv=none;
	b=ePUx4K4fAnvq2DOnkG77b5poopoopgeggPF0Hhkcp8O1lp3IgGraliswadXSKdkPKu0VDK
	iAFdaTBKaZb2kv2/s5kIzUxCbxWF1FoOqLAMxdgsQGaemoci6yCAPUwM3LNVOVkUJ2KFS6
	wtgwudasJmxH5xq9/qc3CeyFLVMOz0Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DZVmn8Ix;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 511AE60121;
	Wed, 25 Mar 2026 10:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE9CC4CEF7;
	Wed, 25 Mar 2026 10:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774434068;
	bh=RwCKSiFjpQQG+EZJNqN0KyvxsrmGDZdhVKBOE/Aaduc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DZVmn8IxFYfhF8HzW7FdXHkwuvW4yhgRak70Foc0vLl1eakxYnHkDHZjUe6OelBMN
	 YrH79MiaqsFIgMBT9jA4780GQHimOe4Cv+sPzqrEw3TuC6LhDvBflKVhc6rP/hCTZ0
	 OkAtwV5P48v9lio9wSNInQxkePOmt3TugwsUQB8vPjl/zhKytLDeu/bDPGr0rtRwKf
	 5Q0Z39eqjOGm4G6rq5+oLonltaHsNJV4rmuGcNpEtABhyQ+gaiGiYGh/lQSeHB2D/D
	 pZ5uYQuilIxryf4YM/itDGepxaKc8ZzRoKiSBNAMWRegHKeDyNslHKiZ/RNKFJ+IKs
	 rWnmdaorTDm+g==
Message-ID: <05d59b49-fa53-413b-a306-feb21594f6a6@kernel.org>
Date: Wed, 25 Mar 2026 11:20:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 14/21] mtdchar: replace deprecated mmap hook with
 mmap_prepare, clean up
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1774045440.git.ljs@kernel.org>
 <d036855c21962c58ace0eb24ecd6d973d77424fe.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <d036855c21962c58ace0eb24ecd6d973d77424fe.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 09BCEC0008
X-Stat-Signature: i5dp64bzsmg7nzkypk9xw4yshkhydbyu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774434068-432188
X-HE-Meta: U2FsdGVkX18pXi/NVccSh4w1IIsNMgLwghaCLrPluZ5R8Ou5xrD3ateJn7BTuQr6Ov/cUXbSWR4M+m0ro6MrfzMKTK8WybqJzY4fhGz9SRRM41ci5Fcd1zHtfa/oSRkMDqr5bXuTb1H4sdfnLbUyF+XVzyx39iJNDd8QPhKO08kXd2+x0DhN46jtCrc6L6cG/QkCM4g9VnCgP2vCFwxF/fa+lppNqAml4H72CG5aRu/9Tj4IXcLfUeLUH/Hum9txhdeGml4SSPCzc/Ip7QXHfJ7oqD2TFti/JFBFRG+SnvDyA0inQLzZFZJcRqKyuB8J6wvGAuToQv59LLE54r0/Vcq6rWR1B3Mj8rgm4SRtYk+mKJt9B3wT4UV71T0NmtsZA4HJRmevTuRyfFASZBtGGUfO3b2947fNehBhXFWuw4h7b/ZyY0xmL6LSDEvO5rnfGA8s0JCnp97se7Cd6FRvUclvIYNXZtQYHDhW+2iiC1We3fhgrC7R4Da9x0H5YuE7OIFxn6QDsWwo1ND4at/hpZJRjHpf8aO8egUg7J7Rg9yOZ+fXVndLwqGD1+MYXF4XG1PYSF2bdLLvT9c6YdWLVaWYOeI25mECpoK8oFd+vY1GkIq0tf95r6ULeoO9HqtjmGITAj7piDS1JazuLW/yHz2BywJmhaKRDwqAfKOfP7Xti5iXkEzJOen+5/06VgE66GpqS8E6mAm4Wj+fEX13QjR2LtmwaixHGudSACv5dgV+IGpAL7EBe7lX14QSp/ICObzfXCYAb3mgg5j2ZlRWr/hV+SWPnJ74Eov6yeI2Fvr7WdKqDDUk6qNORfwbZcBKpSCWiBxRnOuhAz0G+447AhQrLXx82eggzgwm/BNpN+8GE/C1+HrB10QbwcFJO3/TD346spnrc1yUtqTkqbu5Bu+bScAOyw0JrnUUXbCSvDOzXQmYVeJuKHvdlSuw7Fy3Q6/Es7cYtTWlFLjpRGd
 y4KtcV0n
 UOOtpfqO0sWoynwUUVHqES2Q13lkDWLB/Zi+gjB7zytZmDTQhNPOIOhyZ9hHLDUB5GCycpgKSxZQfZGuZ/8XRvkUXAw1EoCdH0qshPEFhtK1TvmKOcQ3srU8InQG8g21+TrlQImVwL17UK8QeUC8An0O/k6KUZvkvkxc7PBYzMpNm0/7p/QQNww6Y/W6o1/P5NswE8IDyEos9ZHSlSXqh38doLq7tFPxmbtoNXvQv9DoLOtNAhKY6QRm+atM3F9JGuJpUQLNXkUHvTPWuWOu3PNCzZcSULtwS/4eOnECJM52u3o2hEmdxOuZl2c+F4uyKQ09/DYC+Ar41G9mrBsSBF+X3tCGSMj/MHltgZbfX4LbqzJcLNurKdaEVnYwe+CmiE4UqCN1MiIvMOWiVod8Rn1LnJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> Replace the deprecated mmap callback with mmap_prepare.
> 
> Commit f5cf8f07423b ("mtd: Disable mtdchar mmap on MMU systems") commented
> out the CONFIG_MMU part of this function back in 2012, so after ~14 years
> it's probably reasonable to remove this altogether rather than updating
> dead code.
> 
> Acked-by: Richard Weinberger <richard@nod.at>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  drivers/mtd/mtdchar.c | 21 +++------------------
>  1 file changed, 3 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
> index 55a43682c567..bf01e6ac7293 100644
> --- a/drivers/mtd/mtdchar.c
> +++ b/drivers/mtd/mtdchar.c
> @@ -1376,27 +1376,12 @@ static unsigned mtdchar_mmap_capabilities(struct file *file)
>  /*
>   * set up a mapping for shared memory segments
>   */
> -static int mtdchar_mmap(struct file *file, struct vm_area_struct *vma)
> +static int mtdchar_mmap_prepare(struct vm_area_desc *desc)
>  {
>  #ifdef CONFIG_MMU
> -	struct mtd_file_info *mfi = file->private_data;
> -	struct mtd_info *mtd = mfi->mtd;
> -	struct map_info *map = mtd->priv;
> -
> -        /* This is broken because it assumes the MTD device is map-based
> -	   and that mtd->priv is a valid struct map_info.  It should be
> -	   replaced with something that uses the mtd_get_unmapped_area()
> -	   operation properly. */
> -	if (0 /*mtd->type == MTD_RAM || mtd->type == MTD_ROM*/) {
> -#ifdef pgprot_noncached
> -		if (file->f_flags & O_DSYNC || map->phys >= __pa(high_memory))
> -			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> -#endif
> -		return vm_iomap_memory(vma, map->phys, map->size);
> -	}
>  	return -ENODEV;
>  #else
> -	return vma->vm_flags & VM_SHARED ? 0 : -EACCES;
> +	return vma_desc_test(desc, VMA_SHARED_BIT) ? 0 : -EACCES;
>  #endif
>  }
>  
> @@ -1411,7 +1396,7 @@ static const struct file_operations mtd_fops = {
>  #endif
>  	.open		= mtdchar_open,
>  	.release	= mtdchar_close,
> -	.mmap		= mtdchar_mmap,
> +	.mmap_prepare	= mtdchar_mmap_prepare,
>  #ifndef CONFIG_MMU
>  	.get_unmapped_area = mtdchar_get_unmapped_area,
>  	.mmap_capabilities = mtdchar_mmap_capabilities,


