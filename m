Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 208D3CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 17:57:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796838E000B; Fri, 12 Sep 2025 13:56:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7202A8E0007; Fri, 12 Sep 2025 13:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C1168E000B; Fri, 12 Sep 2025 13:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43E1A8E0007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:56:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B3125BA19
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:56:59 +0000 (UTC)
X-FDA: 83881354158.07.A090A64
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id C16D4100002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:56:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DTBQvbwY;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757699817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1WFUlnErlcGz3KGoSgWtaZOcBftKtTBkFfUxb/98m8k=;
	b=ewJ5Jfg0aeP8x78oVTfdiUftYUdJ6CgK9fxy2NbwAfr9IjaTILl8SkUbnwYddUImXSNNvC
	8mY0sXE530JPnnJu8hImQitdJVluXRVCB6KNoiPJaETXZqxMDyC2Zc4IpKIltUm683Z/9K
	8Lq3XGUTrKyzxQjSZL9FEC6zOgpVjkA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DTBQvbwY;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757699817; a=rsa-sha256;
	cv=none;
	b=Iu0apYeLykYkjrzoc923MoECbNwN3x6eoLsReoAkBxtPbbCBfXmoStWOwPtTvSgIfAcvz0
	Xq12cclNU3+kz0ByZMx0FKM35TYdFuukkTK0ldltbXol2yxXWV6wddwe/UxwcEh9d6mcHB
	ygkBrNZ6u1gqhyJ3ZEfL1Iu/6Ky1X48=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757699816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1WFUlnErlcGz3KGoSgWtaZOcBftKtTBkFfUxb/98m8k=;
	b=DTBQvbwY5BhdlOaE64Jr172RkCRE7c4rgGU/Yn9B5i7b522x7EKIfbRCiGivsy5AzfBFFf
	//OkkL1HVQQDtFcF4N6RYRQEgFnzlFfpokjctM/JBptacW55qqhHZYXms/NftNJ06SLbrV
	92FvnryeG0fOw7fFrAifqM9p+XMNYzQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-GOaJpqyQMWCgsAewgLDCnw-1; Fri, 12 Sep 2025 13:56:52 -0400
X-MC-Unique: GOaJpqyQMWCgsAewgLDCnw-1
X-Mimecast-MFC-AGG-ID: GOaJpqyQMWCgsAewgLDCnw_1757699811
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b9a856d58so20213955e9.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:56:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757699811; x=1758304611;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1WFUlnErlcGz3KGoSgWtaZOcBftKtTBkFfUxb/98m8k=;
        b=hOQgx+ot4s91a7l61EBU0dcOxzilujT+J8Z7euimC85qmVCgvayHcnnzski2eMLn4k
         839XAfShoc51wKodMUL4i61ZOhTrKwuZapnAMVznzXsQhIKN18NJz4+QAzIOR9e43kMC
         DQ+recQx3RQUYnOjFy3TDAYOTBkysJvR21gyD5hVlCwXFiD4tqEhw4LrM2WooR8JaYSF
         wp67Tni1XznPq92TSP4XAH3w7WCMuFY42EMlETqvUYL6Yl+L9NB0/FdhrEF9uZBjtxAh
         zwhAVrtRxAWUiQI/tw+9zty6zO5IQbRNaNEYu6wFcyPg9dN0WLzKCry19UaD4lT/cvmH
         cZnA==
X-Forwarded-Encrypted: i=1; AJvYcCVCysaj5VNqJiQXOkDV3vbyEgcrSjXvlKyrqdXRW3jjY2kqPTyFTnDnoW6E5UAu1RoJjWigr22b3A==@kvack.org
X-Gm-Message-State: AOJu0Yw6iruIR/VjkrqTtGKwZ4FYytnA+2sri7SB6wGKYRCq8HgYTBmE
	A396IXxiMvYRiEyYz5HE8S1LIODhwN60SqOvLia8d4sloQriMFvH32Zi47o+37j1gtRNAMHF5U2
	suVNMDau9Hz7tQNhl6EvEu4Zu4SeUs07awnCglvS5roCb60m6bCvz
X-Gm-Gg: ASbGncuZra/cGW9RVKcEej5octOqjdholDNNyXX+H4lab8dv0WOaJv7LhsQcW9oCUSf
	vKa/mU+wy+JHbUl6bAMdxYyDQlQ2/ImVluy5elALv25NqCfDdL2l1VHui8JYV8OfXtUE4xbG8Ym
	OcTMTvjXUELk6WtyGGkCTtGiaVhF6ulG7ZonxMfCgyfUo5V+FKl1NmstrnxFHeQH9hEpDpK0nXi
	SNxQ+qHCplVFfTtK+cX8YYAkr4Q2CSoyKkYIUx4noMeSC8iazYoS/Oduv9M/O+OKQzkPxcchFZa
	75rEZya7AYNuvgUVCk/bonvEhGxksF/pmlM6iMc/NE/NQ6bO6IE2nrGaBtixDLtSTuYxRS9GKNy
	DBjtTnmU8HmtezJsw+T8Vx6qQfcLkASR9VEmIAWU+GpZrimFOQXlXYYS2CCvyWELwjg0=
X-Received: by 2002:a5d:64e6:0:b0:3cd:6cd:8c2 with SMTP id ffacd0b85a97d-3e765a22c28mr4163070f8f.60.1757699811034;
        Fri, 12 Sep 2025 10:56:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbQWWosXseBmiCDWHjZ+i8QCGCkijiPXS7J5DPAO7lPWNkZhPahOhzNwRV6nh+EFTyxM8bbQ==
X-Received: by 2002:a5d:64e6:0:b0:3cd:6cd:8c2 with SMTP id ffacd0b85a97d-3e765a22c28mr4163028f8f.60.1757699810512;
        Fri, 12 Sep 2025 10:56:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7c778f764sm1719041f8f.57.2025.09.12.10.56.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 10:56:49 -0700 (PDT)
Message-ID: <3f11cb3a-7f48-4fb8-a700-228fee3e4627@redhat.com>
Date: Fri, 12 Sep 2025 19:56:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/16] mm: add vma_desc_size(), vma_desc_pages()
 helpers
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
References: <cover.1757534913.git.lorenzo.stoakes@oracle.com>
 <5ac75e5ac627c06e62401dfda8c908eadac8dfec.1757534913.git.lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <5ac75e5ac627c06e62401dfda8c908eadac8dfec.1757534913.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: A62hz-w74Jm4ZCSgPV1H05QR1GPOQSYy5aIFW1uCfCo_1757699811
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C16D4100002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: yjycbbwqx6gnpd8eeiyju5x89edwywyu
X-HE-Tag: 1757699816-867335
X-HE-Meta: U2FsdGVkX19gCc09zPoRZzKRSBvnr+fyahYEIjyfmQSLndjieyrYgbiVONbouHnT0hWZmvl1U868rtLAtS/AozQb5xX10axxX/01BvrjD0QNrzpVL1JFrQ02Bkvtt2Gwq5YIH5HJaUtG0Sc8Vd3FEeLya3qFMFRc4Y7QwTW80sUlQZaMzHpz4LF/AhsZpDzL0NAqvH26eEFIBtazl0fSj5lGBH5lbkQLnoffOHCzTiZF6E2nXq8ATsOkpiHV3/qDWeMF+C/SWYWIa6fTcsBf3clY6NsVogG6uV38zvrrqWBaaV9SaKZXaLm33GZMXbzU0jmvvd05B0xzQSnzcJAWZSI20ghTFDTsLmep9Oxi80hctrs5NRnudmYPx4jwI+1XGzKsLzzJCAe/6so9udOy6r6V6g+g9V4rtCBx7xNxvc5kajQcBsmkPvQv417DsxdeqIEQVadjuRL6DBowf+F3zwKpuSc1Qy/JjoGbTtv+KmHarmAqhEtMqWONjGPBiFEttkA+BOHi4WynHPh48FhrSbOcxGa98YZ0oUd/hMMSVa7UWcjaTBzcZDSjRKHve+Ps4nzG7ZMVkTtaVMgwj+wvHe8dNQTczZQXv11nsWfr2ydXwfTBNOSrZ34ac/pgn4U3NJVGpq+LTmMXdXNH4zw6nWqZCmXBQRHlGLXejf/YYnRO2r7yXBf0g3o6mjnZQCOMek4F22AH53jZv9a+S6vDh9Lpy4bk5qWmlic9Ov3HUo/v555/taJMOmZZj0tR+sVz6dKlKTF6/JjhwU75+vy5ZwDXGTBeQLMCr3Q4KjrlJiuu7bIhQ5MOYriZpAg0YSqsle7IlgCfS0s2JXqnGQHHxbjW3coAm69UTcqzHNkmtk8PhvS09XlAyw9ewo3h/w0j/d6L8eujdDUBODH/K7l7G91D0n5KBiOrX/wq5txZ9FvIfSTSOqyN9J5a/lu1gLFl8S24yeQQp09T8l9Gptm
 wehs0DBc
 j25NWHSn6zFH/KiI/J9VyrECkkmfit2yIO660xoWotR8/ljQdz90Tkh/WZAHbM8OnHDv5U2E3jvUtvyB6MRL8yiTtGsmwy4vR2hVBf2L7mu9AjJAfvNaLoGqrGFEVzOLHZrqQzf7NZCDnnWp1ErS0D8Loav3GtQ8g5/+h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.09.25 22:21, Lorenzo Stoakes wrote:
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
> index 892fe5dbf9de..0b97589aec6d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3572,6 +3572,16 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
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

Should parameters in both functions be const * ?

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

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


