Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 544F7CAC581
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 03:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 615776B0007; Mon,  8 Sep 2025 23:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ECAE6B000C; Mon,  8 Sep 2025 23:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529DF6B000E; Mon,  8 Sep 2025 23:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4249C6B0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 23:19:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7473C031F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:19:27 +0000 (UTC)
X-FDA: 83868256374.20.66967E4
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id F09F940007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:19:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pQ1FQQjo;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757387966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kp/49YwOqYc4XSnECrXc1wc8q5JFsR73JTB4gmB0H9s=;
	b=hs+IF9xV2C2+FxyJ+cUkmWLp8nXCoICBDi5rbjvGtMYaEoHT/ZvRVskpYi77lr2Nd2idCm
	C1fBpfTyMbFNy874LMOGjcrKFL9I6TW6M2JuFFNiDVxQ70zEKFjwb4/2rMPbp8/2UYZbCa
	e/F9jkqgnpvlf7zNwLvgOvlYv1VwVOs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pQ1FQQjo;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757387966; a=rsa-sha256;
	cv=none;
	b=xqKjyECA3aP7vxX56t0a1sq1Wr0fHQipv6CMmXg9evCDf74p9QfMauwzuhvEDKuXAmlvrK
	6WAM4Lg86qH00UPGkiItWl3PUHF3/o2Rs/v9OILHXkGsqgQ/kYGN6icELr4G7WHo2AvMhX
	CgxK8e+uObnpkEA9NSGgCRLS01CYk/Y=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757387961; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kp/49YwOqYc4XSnECrXc1wc8q5JFsR73JTB4gmB0H9s=;
	b=pQ1FQQjoRCYT/XJfjHBsul3f9gzHgN3A4zKiG9UlWO3dgkR4eAfIqgpFJMYKU5viU+f4gX9O9OdJ+5Evxt4DxbE33NLXgOQ2z/wChM1jaWLXuUzUWMTOVHMD/a9knwKKT5rkwm6sJJz51sfrqLC0ru0DZzH6ibF16lIKEN3bnE4=
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wnc5f31_1757387957 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 09 Sep 2025 11:19:18 +0800
Message-ID: <2a08292a-fdad-49f1-8ad9-550bf3129b2f@linux.alibaba.com>
Date: Tue, 9 Sep 2025 11:19:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/16] mm/shmem: update shmem to use mmap_prepare
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
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>,
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
 Hugh Dickins <hughd@google.com>, Uladzislau Rezki <urezki@gmail.com>,
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
 <2f84230f9087db1c62860c1a03a90416b8d7742e.1757329751.git.lorenzo.stoakes@oracle.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <2f84230f9087db1c62860c1a03a90416b8d7742e.1757329751.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F09F940007
X-Stat-Signature: 7yk6r9txxju6sfxeyiumhuydxphttfdn
X-HE-Tag: 1757387964-301217
X-HE-Meta: U2FsdGVkX1/dVSsKCBk0lw5eebTDJDeulduCIDeP3M1N9CjlgHaR26Et15zuCgPQArSuZmt5WM/rBrp3Kht9Oz+xaUqpSNZ3XDVjeRzhwJs7NXuL4WmOyltWjPtJJ8Irgkp3LOuuqO6EPzFy3PBW+itkQfCynu/RVwABaQ27UXTc8B32fioYATBS0ZJbTQMupjZd+FrfuZxD7ax77Gz8xrGR0Cp/JdIcQLIxuiWtS0DfSB7d5WIMWzJDKjYPLklgQS+vbfEpdfFiGgTG3K0iqaQ6D2BpzQsmyzUZSLWo/ZUJL/KnpkBz7esAANBRMCpz4kxFhF75oQshBOMnBpOhg4rXOfMtdLLfQDAj19q4GQnbC0bwtXGxXk0jafge5FZsgmNKsxek0smmQ6pEt/9QOBvPx8lxlkpdRFlt/ZPYPF2KdMk8wbJM98w2yTiaQDPgEWPN/XSv32dUjT1jqNtcenlBkkBl0NbnjU5Npm38u+mEyDB9MrcK2nIhfUrzxlg1tKFFGg39SHjyEUqroLfYddhc9axkTgzGWgSR2T8ljf9UXH9YJ6YSOnUl8qsycsa8yDcGJx+fphkZa0YpVDkDv/2MvKUNuu2wZKatIsB7BHfYrnEZYYzTFJ3Yym4bsogcm7dR749T6cuUpO141kf8f/I8iBN398O9/JxICpRMZQ9zOAeKnsRhrbaezhqUoDpG01DvE5xlhZR9hNKmDibiK7wLLoruJ/57oiVL8rLDY8o81lgZpT2fPP0o3FK3Yyeap56VHrKZ9yULRpqCLV3dvoE5dwdq+SV6gnO5buFkyGx9YedZfS31jLm4hErnQKPS12IJMK7moYy2RfLRb1aK1/KVk/o1pvBMoT/5iJvwfQO4gVAkLOFpdaEfwdjeGBxqkOSdZ22i+zN1uRHWckRmaeWPwds8DfPmg89GSmqs57QlIjbjPOUJUMhYPDL8oqpz3/JaRUou8ph9k9Gx346
 6OD9qNGt
 0dIp36YnijdmuJHLkpDQtebE4d/OkJj+UNo4FqTzIBNCjLr4d2TmaaCBz6DTtWHj185Yu9AHR9aD7USLsP/IHZcw8L0bQ8G3IsGOIQo2Yy9HqJSMkUEgX8w0mSvYvlni9WF5mF0a7OtWtYdTI6L/Cq4ZiSKTsmIzVsr8miulSHpdpoInwCHK82TVTHJ1MSoDA6tY3QWTMP04SEfgB6yPAa8EP8iO/i7FZ6ZFIRwCgXtdVS6QEORXBMFXW1H42YFpBjeNNwB4QFrdMZs5rLwQJIfPEfL2kmW0v/u9JpCFsRja2ytriNaaxz7Uyv0eZIU6NTOvnndiZKX/Z46se1qUkWAxCqJaeoSAB1ApDkrWMhcVAZAsnA9Ogbe4Amz0gUx0HLtfXAxX1tsyIsotZtIlwPoSFek1YfCo2gbIo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/8 19:10, Lorenzo Stoakes wrote:
> This simply assigns the vm_ops so is easily updated - do so.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/shmem.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 29e1eb690125..cfc33b99a23a 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2950,16 +2950,17 @@ int shmem_lock(struct file *file, int lock, struct ucounts *ucounts)
>   	return retval;
>   }
>   
> -static int shmem_mmap(struct file *file, struct vm_area_struct *vma)
> +static int shmem_mmap_prepare(struct vm_area_desc *desc)
>   {
> +	struct file *file = desc->file;
>   	struct inode *inode = file_inode(file);
>   
>   	file_accessed(file);
>   	/* This is anonymous shared memory if it is unlinked at the time of mmap */
>   	if (inode->i_nlink)
> -		vma->vm_ops = &shmem_vm_ops;
> +		desc->vm_ops = &shmem_vm_ops;
>   	else
> -		vma->vm_ops = &shmem_anon_vm_ops;
> +		desc->vm_ops = &shmem_anon_vm_ops;
>   	return 0;
>   }
>   
> @@ -5229,7 +5230,7 @@ static const struct address_space_operations shmem_aops = {
>   };
>   
>   static const struct file_operations shmem_file_operations = {
> -	.mmap		= shmem_mmap,
> +	.mmap_prepare	= shmem_mmap_prepare,
>   	.open		= shmem_file_open,
>   	.get_unmapped_area = shmem_get_unmapped_area,
>   #ifdef CONFIG_TMPFS


