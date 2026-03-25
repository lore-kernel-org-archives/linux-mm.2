Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56FE3FEA824
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 10:24:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A44BC6B009E; Wed, 25 Mar 2026 06:24:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5B26B009F; Wed, 25 Mar 2026 06:24:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4616B00A0; Wed, 25 Mar 2026 06:24:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2106B009E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:24:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 21DC7140143
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:24:36 +0000 (UTC)
X-FDA: 84584201352.30.84213DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 55DC12000C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:24:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rltdof9W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774434274; a=rsa-sha256;
	cv=none;
	b=q+rB/OhwnUUqB7SJULRnt145nljXF7XBgibAKbArVK9vv+QsSnirGbhd8WLX9H8oidHo2C
	GszQyd33gCIz4WC8NJeHl1ktgPwL99sfhNUNWk5azXbRwWzna+sOKK5MIG/drSa+tCs7Yl
	jTAZ6gEeIj1RhzRCABYB3v4kZ25ERzc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rltdof9W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774434274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KkUgwbZwkrT7tZGP8SVFvMdfTmBvKHFMz2IyzenIXMs=;
	b=DKVTdOSylXgxz0/iStgYtoxpDbK1ZfpBjQvQ91NSwQ7aGYbC1vpZf6wDrtFGyVHnkhxiI9
	jtwr+7NXt7wzpKg6EDIEQqirQxv85ngeBZ39M0AfbmcV9mIip8+7wJrNJMDPKfoGjOMoZU
	/nlHOTfO0THewsD8ice320Vdi5CWk8s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6302F42B44;
	Wed, 25 Mar 2026 10:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E4BC4CEF7;
	Wed, 25 Mar 2026 10:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774434273;
	bh=p4SW4OpQ2gx0HoB77aBSsnjwhDuxQYBolk+cHDEmzKU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rltdof9WVS1oLv7QKy5GNxKTX8mlW2HgTiPkyXeuRV8FNUrkT4uU+tfK1KoQf3TX1
	 xP+TliwzDp1e4MLsTqESjen2eS+wbB81pAShhC6mK28s3pqWxaEs2Mb+IrYppT8eZH
	 TPC02Kd1mT9gqJydmCpD2Qwh0LJu38txLVjjjeMo4FGzB6IPFOWufdRWT40wn8htYz
	 +f7Lm0aCjnia373FFBJqr5enbiSEeSfPNX/qtxpQrXBVpJ+mBWIgTTGoeDmwXCrtrR
	 u/m4V4mFx7bCyD2IP4UzNrOTYy2mol024IH/vOfvsdtvhAH41ttZAmOrAXSl4Ravy0
	 Nyg1aFmIMxaew==
Message-ID: <325b874f-55f5-4e9d-a924-11efa95b8ec8@kernel.org>
Date: Wed, 25 Mar 2026 11:24:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 15/21] stm: replace deprecated mmap hook with
 mmap_prepare
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
 <9f3d559a264a83cf45518fcf35cc7ef1d7dfd500.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <9f3d559a264a83cf45518fcf35cc7ef1d7dfd500.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ksyx9mprxrmgo1bm1q1aopc6x1f116zb
X-Rspamd-Queue-Id: 55DC12000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774434274-774793
X-HE-Meta: U2FsdGVkX1/AaG8+WKvvshLoizmjuLJ7/IbWtQEOFZNZUEt1CFZUxPK5DExrn5OIFLBp4IPmd+ZmllP0TKzK0yFNDpeCcgDDkHuWp+AtMqYEmmHIHgPvfbweH8eZ/oTVTDlJXbUJ2A+hym65ZRYs9UfZ326vJf3eOsHT4pO/zdjKaOS8mAmNnAUU+v7GBzNT7WOWfkq1hKKJItdKGB06YwWHn8TbQwVa81zrWw0vVM7obiRylmrlESPCj1Uu1HQ1cgVFt2lkl8KPBUeRyXquF4nz7cEwI0K0O1oi/rlG0aopSygAhRlvJRl7sncfmWc61zo1HMiSWR10OoNDC/R18JxJkBp4WyohtHR3yTjr54UaTVGWsj7HlEoxCxC/3dL24YrBLvTOho6F4oZsLJAy2GllNNupT5VzEkB9i6KZKcg3yKmMcaYbpoeqUDPREyN1KmKPt5/m51ys+QcCL6U0sSKyzmwdlhNxEtSllhOXbGThHHhfL4BFBMnLC1VIcWjxlX//fkt3CCSUejuIS39Zv+UUu1x0uDduoRKAbufYIGpKBvE3Y9EJDPw4DcS/3MbSFgPntIRYdMSdYD/yq0wNK+XGqZI99QHnK6bt/hfm8GHMe1kfdhi5AviyQK/Ma/x50AQIfBKnYu8DOupvrL2nSuXhwqwkuzyVoEqKzaZNjpsjcxOQgjgtBU3A2qqZOEv+UfjnLuuKS/T6WqoYj5IGo0PqJG2NIK61dcmjyPISCJqhNVNpWd/Che418V4YsKLD3/UhoY1aV8K7Ls/+iSu1npEtQpPOmmhQGYvMUIsYV/HHqBCYlr5DCnaORAca+W8rMDJazPpoh36Eso31BV4qmsM/uuj/oQyaGQPmgI5ijm5MekAYMOw5taFKgt2TJsBD3GBoBwzl6DkJ8s35IzbNu2dx5XFNvudMuRYsR9kCLldfZmsfFqQKPeRntIxgFgziqr7KNW8tw+6lfLEo2na
 i9OBc1io
 JLGCW4s1usdssjsaDbFyidxEGvmfIyX9TxsOHiHwGxUwKqoOE4DANA9+bJimtaFh8HMgY4SBwlpXtxWxfpaYWb+nA1WgNYKLFfwZKNY3nTWAmWghf2Dp8+O1RSsbsDpQzAuDYcC2dkfIwiKGaUZiRvSmB1xwEvL69f7HJ19kJk7kiqN5w1arki+xf5xP1ib35pvZvtBWHD/1cxpySAjT3zOYvYzS/KfwxtLsgDx1Pv731Te4q5wCKAKE09XyYrVwXyWmo8jdWDxdJrMtZ5BRzCIuqTjyhbT1ywr4irj5vR6Qd1Lni98SOIzIS0OZKEuUYxrszAmJiJ/xcy3ma+/YHv6cX62erBEFGjuDfsU17hDWDFR09F7EEIW3LeTUNNg9NbzEGlYmNyqKjqamjtBfyz2go3ELRaD0Hf7KZsPIwxQBZ5LE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> The f_op->mmap interface is deprecated, so update driver to use its
> successor, mmap_prepare.
> 
> The driver previously used vm_iomap_memory(), so this change replaces it
> with its mmap_prepare equivalent, mmap_action_simple_ioremap().
> 
> Also, in order to correctly maintain reference counting, add a
> vm_ops->mapped callback to increment the reference count when successfully
> mapped.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  drivers/hwtracing/stm/core.c | 31 +++++++++++++++++++++----------
>  1 file changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
> index 37584e786bb5..f48c6a8a0654 100644
> --- a/drivers/hwtracing/stm/core.c
> +++ b/drivers/hwtracing/stm/core.c
> @@ -666,6 +666,16 @@ static ssize_t stm_char_write(struct file *file, const char __user *buf,
>  	return count;
>  }
>  
> +static int stm_mmap_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
> +			   const struct file *file, void **vm_private_data)
> +{
> +	struct stm_file *stmf = file->private_data;
> +	struct stm_device *stm = stmf->stm;
> +
> +	pm_runtime_get_sync(&stm->dev);
> +	return 0;
> +}
> +
>  static void stm_mmap_open(struct vm_area_struct *vma)
>  {
>  	struct stm_file *stmf = vma->vm_file->private_data;
> @@ -684,12 +694,14 @@ static void stm_mmap_close(struct vm_area_struct *vma)
>  }
>  
>  static const struct vm_operations_struct stm_mmap_vmops = {
> +	.mapped = stm_mmap_mapped,
>  	.open	= stm_mmap_open,
>  	.close	= stm_mmap_close,
>  };
>  
> -static int stm_char_mmap(struct file *file, struct vm_area_struct *vma)
> +static int stm_char_mmap_prepare(struct vm_area_desc *desc)
>  {
> +	struct file *file = desc->file;
>  	struct stm_file *stmf = file->private_data;
>  	struct stm_device *stm = stmf->stm;
>  	unsigned long size, phys;
> @@ -697,10 +709,10 @@ static int stm_char_mmap(struct file *file, struct vm_area_struct *vma)
>  	if (!stm->data->mmio_addr)
>  		return -EOPNOTSUPP;
>  
> -	if (vma->vm_pgoff)
> +	if (desc->pgoff)
>  		return -EINVAL;
>  
> -	size = vma->vm_end - vma->vm_start;
> +	size = vma_desc_size(desc);
>  
>  	if (stmf->output.nr_chans * stm->data->sw_mmiosz != size)
>  		return -EINVAL;
> @@ -712,13 +724,12 @@ static int stm_char_mmap(struct file *file, struct vm_area_struct *vma)
>  	if (!phys)
>  		return -EINVAL;
>  
> -	pm_runtime_get_sync(&stm->dev);
> -
> -	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> -	vm_flags_set(vma, VM_IO | VM_DONTEXPAND | VM_DONTDUMP);
> -	vma->vm_ops = &stm_mmap_vmops;
> -	vm_iomap_memory(vma, phys, size);
> +	desc->page_prot = pgprot_noncached(desc->page_prot);
> +	vma_desc_set_flags(desc, VMA_IO_BIT, VMA_DONTEXPAND_BIT,
> +			   VMA_DONTDUMP_BIT);
> +	desc->vm_ops = &stm_mmap_vmops;
>  
> +	mmap_action_simple_ioremap(desc, phys, size);
>  	return 0;
>  }
>  
> @@ -836,7 +847,7 @@ static const struct file_operations stm_fops = {
>  	.open		= stm_char_open,
>  	.release	= stm_char_release,
>  	.write		= stm_char_write,
> -	.mmap		= stm_char_mmap,
> +	.mmap_prepare	= stm_char_mmap_prepare,
>  	.unlocked_ioctl	= stm_char_ioctl,
>  	.compat_ioctl	= compat_ptr_ioctl,
>  };


