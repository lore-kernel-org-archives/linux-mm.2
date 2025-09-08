Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70EBCCA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D06A58E0014; Mon,  8 Sep 2025 11:10:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB75D8E0001; Mon,  8 Sep 2025 11:10:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B31298E0014; Mon,  8 Sep 2025 11:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9EB548E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:10:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C9B1B6AD7
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:10:30 +0000 (UTC)
X-FDA: 83866419420.03.7739C4E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 150591C0010
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:10:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IxlJwd85;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757344228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MWs38ipt6qYVKPoOaNWVE9IjFwNAzWbj0IVoNQpA9LM=;
	b=nNuLw6iYenUGSKFbvMm8P1cnpa4ysnGbpVTfpIwqC5pfFcNBdGvIfyuUMKshoJTVSpIkDM
	M4e/5in16bQGuTje8Px5s/bbuI2g95KaWiCDsV4PB7NiCtRxqmTj22zXuUABNU0vw8emDi
	oSRv5GnkLsC7UyLMcAbC/WVMttOB9V0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IxlJwd85;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757344228; a=rsa-sha256;
	cv=none;
	b=x1r7IX82XhhIbROoQ1hLtWDf1ag7iTSJKxOK9dnw9W1+uShBKDOKlsdD8V2U794MRoAo7y
	uPj/dhpo62lP7KXqzwEYEL/+/mIZkKS/M+wst5kFWB2/fKeVPTLArAfGiXqdRr1YKyUp6X
	ObRKVfbihxcetbxnWGhEX8X7KhV7OlA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757344227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MWs38ipt6qYVKPoOaNWVE9IjFwNAzWbj0IVoNQpA9LM=;
	b=IxlJwd85W8ETsrzW7AjcvsBhpiYuR17lSYKAsXpJ9dGGl7vn+efkWJZCFU+QneYGvGksAW
	8bVLdShnMQ1nKA/VAEv0p+XACbVqloh82JUv0S6RQhBmqCLV9iYNBO2Kj6os2q1mA7KBTD
	lwNF8wv0674UL/v0tYuQPb2O4B/tQFo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-X8mtVnhnNwCodTtoB18QAg-1; Mon, 08 Sep 2025 11:10:26 -0400
X-MC-Unique: X8mtVnhnNwCodTtoB18QAg-1
X-Mimecast-MFC-AGG-ID: X8mtVnhnNwCodTtoB18QAg_1757344225
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b990eb77cso32840795e9.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:10:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757344225; x=1757949025;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MWs38ipt6qYVKPoOaNWVE9IjFwNAzWbj0IVoNQpA9LM=;
        b=sQ1a0+3501ovo9TYKPxK+a5GZDa+TdCVMSpSEiBWI3zV+JVu5g9Twgdspb/yBT7Tn7
         j/J135BN26boqJ+2ImScY7Yd5/6Y3K+YK19HyWtMcoZpytXkWaa6EzU5CXJuHHodPewJ
         +tGbkkkuJis1A0E+2BY17qV67xiGz37LIXxwMlLDvPOflfcycY0TcdFT56zyJ0liAO5Q
         yfWdfxkyd6WE3jGkggsZmwYoR9rLJ0TkDxIgreIYviMWBht7II23bwooXe62uZp7U8kB
         UMSxFH2Dnd3fP+lwKYhsRy2ydnSWwIFTWvEBpVi+ieXgGWReRKiB4hf6CjmA/PbdhJEb
         SiBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOuGfVgXLMzf8yT7MLQ7nM/L49fZQsJ/S3Jm0+fB9yMRtP0/3eM58gIS6oAqUUj92fEnI+kAcoYw==@kvack.org
X-Gm-Message-State: AOJu0Yz9ndFoQUIw1/1osH4+agumZy8RwSeYh7GA2eEWiAnEeevQf78N
	hfbQ03FxcgRsVEydE5gakNbX6RDELpUUF+UhBY8Ogpr58cL+XxIUuz1SUff4VikfKGy5D6iyNx+
	tJk2x8CQbaxHlVXkipkD1GHXUbKxJoBQt4GHuIC4l2VgTn2CtAup9
X-Gm-Gg: ASbGncuPPXaFquGW4Hv15gYl3xEoX/f1lkDwcs/q9fFUv8pLe0n87Crxpo3M3NTdvRw
	i509THnIB6OOpuk9AuiZw6yuyawNaVYoWjj3Ntp7doYA6RrWDkJ6OOWZB/YEiufqiMzGKrdiN8u
	DF4uqo+8pOPZ3fzgKWdkh9F++ENpF+EeZMrz104Ul3MKQQlzVBKlBfACTLfKhSCzNW3RxaTA2oM
	+dI+CdeMFRtFakhSpGBJwKmxXADUpL+yZN0iOW50cXmnXdnfHy4LqlUxgXuSG+e6m9eIKAHaplT
	FmnXX0z2xPNOq7DOJ4f4Wz9QMoQbVTJyKAs4oZzchv5uz5QdMVryapGqnGKetXjJwH+fKR5ejr0
	t562/6qz9JD3Ie0M+J3cddiOpil/FKDx4bI9N1wNwHddvkhuKO5zRAGGYgoEZOSUN
X-Received: by 2002:a05:600d:f:b0:45d:e775:d8b8 with SMTP id 5b1f17b1804b1-45de775e1famr26225635e9.1.1757344224873;
        Mon, 08 Sep 2025 08:10:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGe7ZTfhfsgtooC3/5pep0igJoOBuPGNNCiAINQdm3uwOco5gprVmhHIhPkct+pdrN1/wAPVA==
X-Received: by 2002:a05:600d:f:b0:45d:e775:d8b8 with SMTP id 5b1f17b1804b1-45de775e1famr26224795e9.1.1757344224275;
        Mon, 08 Sep 2025 08:10:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dddf8c51dsm109133275e9.20.2025.09.08.08.10.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 08:10:23 -0700 (PDT)
Message-ID: <076658ac-78bc-4d4b-bf3b-d04cd3f0fa21@redhat.com>
Date: Mon, 8 Sep 2025 17:10:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/16] mm: add vma_desc_size(), vma_desc_pages() helpers
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
 Guo Ren <guoren@kernel.org>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
 Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 kexec@lists.infradead.org, kasan-dev@googlegroups.com,
 Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <d8767cda1afd04133e841a819bcedf1e8dda4436.1757329751.git.lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <d8767cda1afd04133e841a819bcedf1e8dda4436.1757329751.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -o7k3YMiQU9C-9QFC66ZgTFFqbrsRKJzf36Ss0O3SVQ_1757344225
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 150591C0010
X-Stat-Signature: ope3t74gf7gbt4ebdgb64ztb1ir8s1mn
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757344227-527692
X-HE-Meta: U2FsdGVkX1/f6oAAjHyzHQKYbZhvziaAuuLEjsJxMDYuhmA8u2ijqGEL6DFQ6btIcDhKljKpj1I4Bd+2MHez6f6EP9UN/eeaVw8mTvRQTZ7Cm9C2667rP74b7uM2TxM940ZrgRZeIKc3Bk9iRlDZaDgeZxLAYml23MPcp7G2t2knhe90Idwzi/UjV64/VGtasCDUlO5zbMsgXogXd5nYdwDVPSYlwmcTeZyMytKETC5o13xfFeJts/J9gTH1jdeqpskXoaaligl76ay7U5Lo3Nhd1KxavrLqd9NdLC1saPI7DjwpcrYGLjP4WkqbmNaPfmcSJAMSjuxkq30syeQ6d2kUM4W++sFjlBdBI+nyCkp68wo26iEHUg19NQGaqAzzkrspX8G4apNkWUMPO7ewJo9QMxxZebH1a4iekTZIV7J26skuTgE3SRsGLBpqllTuKQsuPM1g1l/geboPUaf3KrnU00Ny5YBtHL8hZFwUC5E7bdNoTjenaDCYQbHwV06TqyXIScxKlubKlF+lkbdbrnP8NlAL8SjcQsN9RlID1EMUdgXodoRcCUAEWVy35opwC2HA5/MbKqdJ7Gjy8JCNu1aQaS3iS9Z+LcxbKPW7V+827Z9jOPqb9yDbRK9QeaL7J4GdeJr3rUn7aiOCQbHllWssBxYgcWmbheChgWb32c4xOTfA58zx88z1OHFGCKp5SGLitAEFkbxarK2mOmG99OYs7xND1t/JwpN2O03J2ySypt35tiSvJNkdDMCIEIjzKpNZ+YgoUF12Jnw9r4ylYPtuAfmgGbO9zfES6ZNY3u4FdOuJpfnRTHfG5EYl3ZHzyOmvh+Noq/MKOuM3GjHJVnxXwla9l1IEwb7Xjfzv0Bt9rzOY2WJ6SSXwJCgo0KaV5CJYJaDXqy5VVeqzcUJvQ90iy7XB27gbOZThWkXHNImROIXHBWrRt5IrujtAJudhPRdS/2LuhSTVdMw7fNo
 7yZRRDT9
 lNDAGycmk+MP1gjGKT6lBY5nHMbnGM7eGl8UOhANcxm5nVfEx1JQd6Dz1HaoJP+D/X3yVMQi8PYaRJqrp7K16YHpTl+pCCrgjU/HlOwvc9DlUAaXTDrD2lBx7JHtQ4FKFHVrXheCMe9RB9m7dDx7Bsqq9+yKVzejTgrC/PmNBs2kSjKL3UdzaWKNUntuigV8/300HjuXqdfoYiAnEfBu9rVGDPKtO/wk0QG1TJO4keEYbXfjYNATkNcxo9SyO4XBwOBnhqz6z8J7aBWNN77/10a1HfI6W5D0TGnJksiB+pfLCNlmC5jR3/SdVy6T70qafboHzBBecv7ugbRcuHxrCxPTlc+OAxdIHMDpz7MEf8Zry4GppevWmHybvqYJasfNgC09MTYQToG/mf2t4qEIkvbzuiXrGfQ7+a0P38+dmZsiLLUy64zlmf3gR+oudPxDulqul0HH/c35HoB3yQgG4t+GSF9haPXKuNNVA0uLiuTSoOFq43H05PmtU+T7/6et3SQ26C2C3YqN5Xfy2FV8CGF2xGBJBEB+pbKzSBRiWTI8up6aknHZqOYiNyjVtlOvgTEyd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 13:10, Lorenzo Stoakes wrote:
> It's useful to be able to determine the size of a VMA descriptor range used
> on f_op->mmap_prepare, expressed both in bytes and pages, so add helpers
> for both and update code that could make use of it to do so.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>   fs/ntfs3/file.c    |  2 +-
>   include/linux/mm.h | 10 ++++++++++
>   mm/secretmem.c     |  2 +-
>   3 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
> index c1ece707b195..86eb88f62714 100644
> --- a/fs/ntfs3/file.c
> +++ b/fs/ntfs3/file.c
> @@ -304,7 +304,7 @@ static int ntfs_file_mmap_prepare(struct vm_area_desc *desc)
>   
>   	if (rw) {
>   		u64 to = min_t(loff_t, i_size_read(inode),
> -			       from + desc->end - desc->start);
> +			       from + vma_desc_size(desc));
>   
>   		if (is_sparsed(ni)) {
>   			/* Allocate clusters for rw map. */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a6bfa46937a8..9d4508b20be3 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3560,6 +3560,16 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
>   	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>   }
>   
> +static inline unsigned long vma_desc_size(struct vm_area_desc *desc)
> +{
> +	return desc->end - desc->start;
> +}
> +
> +static inline unsigned long vma_desc_pages(struct vm_area_desc *desc)
> +{
> +	return vma_desc_size(desc) >> PAGE_SHIFT;
> +}

"const struct vm_area_desc *" in both cases?

> +
>   /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
>   static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
>   				unsigned long vm_start, unsigned long vm_end)
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index 60137305bc20..62066ddb1e9c 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -120,7 +120,7 @@ static int secretmem_release(struct inode *inode, struct file *file)
>   
>   static int secretmem_mmap_prepare(struct vm_area_desc *desc)
>   {
> -	const unsigned long len = desc->end - desc->start;
> +	const unsigned long len = vma_desc_size(desc);
>   
>   	if ((desc->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
>   		return -EINVAL;

We really want to forbid any private mappings here, independent of cow.

Maybe a is_private_mapping() helper

or a

vma_desc_is_private_mapping()

helper if we really need it

-- 
Cheers

David / dhildenb


