Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F386D2168B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBBBF6B00D4; Thu,  4 Dec 2025 10:19:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6BEC6B00D5; Thu,  4 Dec 2025 10:19:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34136B00D6; Thu,  4 Dec 2025 10:19:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AEC446B00D4
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:19:53 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 591155634D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:19:53 +0000 (UTC)
X-FDA: 84182148666.04.A3EF6AB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id B626BC000B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:19:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D1bL5yyE;
	spf=pass (imf10.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764861591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wiOfEEXvCCotAmgC8KaiTgZUJrgAulq2O8EihiUvjps=;
	b=N8XB9j37yVa3rX15/JeJ1STk46kJMWZ9M+JGG0Sws30ImmQZkXTO9yP+fgkS6fh82prkpy
	Tei1Eqo0E2G5/5JkNa4sfOOtNF/gBtGoIQlqkZN5uMoZUYK7JOcR51L56mRvfub8HS0kW0
	IxRnUz8ty4T4Dok/NZZSTouKEBm3pmU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764861591; a=rsa-sha256;
	cv=none;
	b=Hhb2/03ODse+sdKKDJV/jAopwCJz9Rklsa0Vl43K74m22Se/LzA77zmE1xx6/mnRRmWd8J
	HasIYDRtTsW2GzL20UWiT6sztpfR3uLXBq5PMMW9wHNYNS5ZSlrCnZNyIeYrmuUZNA+BYz
	D7an/IpoL+2qh3+4C/gqFqbrvoHn7wg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D1bL5yyE;
	spf=pass (imf10.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764861589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wiOfEEXvCCotAmgC8KaiTgZUJrgAulq2O8EihiUvjps=;
	b=D1bL5yyEWbRP+30z7cQriR+Zcv02q/yRofLDCDbi+yVT+1EuXP07Y76S7UGLHgoR9AyyTM
	TlDP7jeHAoWfiOULArqiHiYM7RPa0p4jqtWgKrJs1jWOndpr/3/XAozasNw3bEvtcnm3Cm
	dBORwhZ4GUYZvQayg48DBiV5c389boQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-mzrSQfN5Pdmw4W5Oven6Sw-1; Thu, 04 Dec 2025 10:19:48 -0500
X-MC-Unique: mzrSQfN5Pdmw4W5Oven6Sw-1
X-Mimecast-MFC-AGG-ID: mzrSQfN5Pdmw4W5Oven6Sw_1764861588
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ee3dfe072dso23700521cf.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:19:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764861588; x=1765466388;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wiOfEEXvCCotAmgC8KaiTgZUJrgAulq2O8EihiUvjps=;
        b=XqDu+ICHp8x6+Yv+N8u6+cpuHE00UpYb0M5xXeNaJcGJJxzUUTlAv+VeWyl0EEn8YD
         SuS7iR/EYfHAhPElXtrcZ3WcUftGb0HGYNw331fo6U9vq+Dcgn23+2BtYYb3Xx1SOKap
         /8mRI5qBpQn1HNkTVs3moIdnPCThrOGda5M6vnVxb06MkUGDRh5GEgotao2EoETmgZ2S
         q0wvqTc4qiV0lF2Y+AQOgM+w6cGyH0r0OUzI1NwR8Jc9ZHWx7nj9CAT2FQV8OLGzll+H
         nRJ5v8cjqslns9lrL6z7doQSi3KvsqLwykTdrji3qdo98CKfQkxiT50mixasVqXN7Eo2
         II3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVplqEE6a7+h5w3PKTf/xMDuY9LVbsDXR1F5zNip5S4kz/IS5VBsB7dHNTyP34HmiXdOYrq2z78Kw==@kvack.org
X-Gm-Message-State: AOJu0YwKsBNpH0+YcCvlDD5/gBBnqdconpfnD8T/y/MpWa0YWL/t960a
	SUlwu+p4LWlSjnb35TR4blln2HHdc2+BgiuDcNtgpC3VG1IUP0S2DtyuN+31TzXpXVPOc9FhM6A
	JsebvIi+wRszWb77z6eeWhflCiDcxaBIqRY89Ll0aMKy5eG/pL1Cb
X-Gm-Gg: ASbGncs3fkfJmKwdbm9y79b4rQutxEmyj32BPFhwBccn5BRuW25xrQbCAJ9wjr4Y3xZ
	VjOPlejMYeHAweyYPHuo2SBXbS3E/nxmgz84OLUsVb87+vp6mEQgdwLK6K+7VCaR08spCZJiK0t
	o9mdRrziaUp/jFTURmsYplig4YNWqAb39gC8AiQeQrY3DU1V7lZJFjpEOjvupbX2uXY1CI5etON
	BIQJiDf0DXuwho08ZSTCKRZ0PVylwsTzNr8yg1Fb9+eAkbonPbdQanSRUOkh8fnrzd+qJsqFHke
	j8idqFunAepQBCEdTNT3ON/ZFJBUqFxCXB7xaQ/zXAmC29oYIO/jD1r6m6dLuvIcOipE+CgXby8
	Zd60=
X-Received: by 2002:a05:622a:19a7:b0:4ed:6831:56bf with SMTP id d75a77b69052e-4f017506180mr83114781cf.13.1764861587804;
        Thu, 04 Dec 2025 07:19:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGDTQQzmp0P2GzLYzoOuzd5XiTJUMbQ9wDiRy2GwNjmSgFIr2k4OGOJR0lcg/JspoRQXCmtBg==
X-Received: by 2002:a05:622a:19a7:b0:4ed:6831:56bf with SMTP id d75a77b69052e-4f017506180mr83114131cf.13.1764861587171;
        Thu, 04 Dec 2025 07:19:47 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f0276b04b8sm10255141cf.11.2025.12.04.07.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 07:19:46 -0800 (PST)
Date: Thu, 4 Dec 2025 10:19:44 -0500
From: Peter Xu <peterx@redhat.com>
To: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>, Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <aTGmkHsRSsnneW0G@x1.local>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20251204151003.171039-3-peterx@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2Giuve4PJlvTFALYTUHSpi9mMAO2WG5Ktkk3LJrNJ0w_1764861588
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B626BC000B
X-Stat-Signature: ux6ewsqgoytm961nj95qmp5afppw81dp
X-Rspam-User: 
X-HE-Tag: 1764861590-524045
X-HE-Meta: U2FsdGVkX1/rbbVBpYmJJBmf2xOr9XJEE6nEsviJSlgAwn/Xbb1wTRg+WpgyfSuSXJ0vKSKZwdHm9Pu5ofI9piFnrmQczMNb8wGrVuG3uDHNy//yXp8yQWTUHDlWAda/Pg51yXbmsE3Z7OOl7Dmqe9PmBGiHY9LJd4nzig5J5CQJlay2Uo7esF2Dl+zkrwpb+qrfRVSQXS0WsvNBvJI1SKuvsUo3V1YY2Hq0seCb9VECuh7eBpltu1OD9Reit4xDFPBwWu96i+b+WE8m0LYb+Q197yNBvCzIDVzR7z8aMIPBKq3voxfjqCbH71FPP7KOCFhlkMvCwrFwXGVWL75BFbWy5uL8cCINQh1Hm2Z97/lMhFCg3ucz94OSLqVWpI7/sEwO9pNwnfdVPyfzQAoWFzRdMeoKthOGlraOzkaC1a1CH0HhNMUfeq8kg29fpYw6LhLpaMXsr2PvH3YOfYWDnAP/5xW202Jg5bMXCad8+8E8ilQ3tPlsQZ+F/vUUQLHOl/B6hlYSlG6V7eo4YgLfLvmPOZy0HgzK3G69tlEzBU+St9vEPlQN42fkXSrvgDGSyYAL+jmYLnQkTIY5JwN31uuaJT/gci/WTO1SxflszqWeHTnb6CnRgh1AsUoKkDOVYJtl2+BvWIwAodPRkE3dEPHfV6/iW6ZMxLhZqHcUpqILCr9UvfTbwXtbTVl2SWiAdZo7AH7372zE7Q1l9BRd4VGAUc+/2TqKG6QIOUHPGyG4hejzR3z2WBGI7CoICfaN4QbdHHmq4zIjvtHrEQh0KQ2iKTDhPA7ksesp0clOerr8TMAjYO7PlFuaMYN15xCMJ62GsGubP0nuDiFM9Q37HxdB5ELGpGWUicIam9PQ3wcz+I8UaA3ykMrLit3F/SC07qeGIx3Z8IfGX1wdSjWNckgXYB4eAUcyeMchUsClM1QU5SP9MzaGYKwVXJcwiGlr7R1Qfden9Dt39xzUOnY
 yRTzD6P5
 qFjAZJsgpyWvdRmMCnlSvzsDAYi9fjekKzY/45eOPI6iVa25rHIU9hAj/4Wbb+qSJGQaQCL3OPx3JxkYTyW++Q+MbPqbGtF69uo2fa76pAWmGWTCxjahxCfBToAgN/wdHMcQphj/vlKl5QQ7eqktXecCFPnn3yspn15iSBI69wG62WP3SIRa5sKsDmestR5Le/MrdApBm9mL80/qSGjKaH//hrbjkksUQFEs/HQWvxmnZ0ixz0qnloqoS1f1Hmm0daJrHYAQpJtEZZhU1m2w9lW5JsKyor0sE7dUXuM+nX4cw5mDFaehTB3l22F4g9RaLBjcnFu8qR9ZiNZFudhsGQWnJUXEvXoVvzn5pl5ML9fivW2fstTG83yFL+oQdL8MxkgRLRDaAJCtXYGkGkeikmoT294pJdnzBy+/14oESId3pfZUXd/OStLKDTzfS1IETwYcTy8AK/h1EI6nzgXLwbaTcRnW0ojRPYGTQvmROrwcz7EPx8Mu++uIZvBKWTCSV1+HmLGHaHvsLGCOy4HFIG45cu6qwIohpNqh38X0fUsTPeQj1ChDZK82MWukiDaeSEgs+TIqGBhI/nyPdOXEWj8fvEtY4on+VH5nWyzr4OcLR4D8a60egY2qzF2YtUguKmMUwJ3eVUh+aDO1ov2x5rHE52g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I forgot to copy mm/fs maintainers for the 1st/2nd patches in this series,
my apologies.  Whole series can be found here:

https://lore.kernel.org/r/20251204151003.171039-1-peterx@redhat.com

I'll modify the cc list when repost.

Thanks,

On Thu, Dec 04, 2025 at 10:10:01AM -0500, Peter Xu wrote:
> Add one new file operation, get_mapping_order().  It can be used by file
> backends to report mapping order hints.
> 
> By default, Linux assumed we will map in PAGE_SIZE chunks.  With this hint,
> the driver can report the possibility of mapping chunks that are larger
> than PAGE_SIZE.  Then, the VA allocator will try to use that as alignment
> when allocating the VA ranges.
> 
> This is useful because when chunks to be mapped are larger than PAGE_SIZE,
> VA alignment matters and it needs to be aligned with the size of the chunk
> to be mapped.
> 
> Said that, no matter what is the alignment used for the VA allocation, the
> driver can still decide which size to map the chunks.  It is also not an
> issue if it keeps mapping in PAGE_SIZE.
> 
> get_mapping_order() is defined to take three parameters.  Besides the 1st
> parameter which will be the file object pointer, the 2nd + 3rd parameters
> being the pgoff + size of the mmap() request.  Its retval is defined as the
> order, which must be non-negative to enable the alignment.  When zero is
> returned, it should behave like when the hint is not provided, IOW,
> alignment will still be PAGE_SIZE.
> 
> When the order is too big, ignore the hint.  Normally drivers are trusted,
> so it's more of an extra layer of safety measure.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  Documentation/filesystems/vfs.rst |  4 +++
>  include/linux/fs.h                |  1 +
>  mm/mmap.c                         | 59 +++++++++++++++++++++++++++----
>  3 files changed, 57 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index 4f13b01e42eb5..b707ddbebbf52 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -1069,6 +1069,7 @@ This describes how the VFS can manipulate an open file.  As of kernel
>  		int (*fasync) (int, struct file *, int);
>  		int (*lock) (struct file *, int, struct file_lock *);
>  		unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
> +		int (*get_mapping_order)(struct file *, unsigned long, size_t);
>  		int (*check_flags)(int);
>  		int (*flock) (struct file *, int, struct file_lock *);
>  		ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
> @@ -1165,6 +1166,9 @@ otherwise noted.
>  ``get_unmapped_area``
>  	called by the mmap(2) system call
>  
> +``get_mapping_order``
> +	called by the mmap(2) system call to get mapping order hint
> +
>  ``check_flags``
>  	called by the fcntl(2) system call for F_SETFL command
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index dd3b57cfadeeb..5ba373576bfe5 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2287,6 +2287,7 @@ struct file_operations {
>  	int (*fasync) (int, struct file *, int);
>  	int (*lock) (struct file *, int, struct file_lock *);
>  	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
> +	int (*get_mapping_order)(struct file *file, unsigned long pgoff, size_t len);
>  	int (*check_flags)(int);
>  	int (*flock) (struct file *, int, struct file_lock *);
>  	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 8fa397a18252e..be3dd0623f00c 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -808,6 +808,33 @@ unsigned long mm_get_unmapped_area_vmflags(struct mm_struct *mm, struct file *fi
>  	return arch_get_unmapped_area(filp, addr, len, pgoff, flags, vm_flags);
>  }
>  
> +static inline bool file_has_mmap_order_hint(struct file *file)
> +{
> +	return file && file->f_op && file->f_op->get_mapping_order;
> +}
> +
> +static inline bool
> +mmap_should_align(struct file *file, unsigned long addr, unsigned long len)
> +{
> +	/* When THP not enabled at all, skip */
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +		return false;
> +
> +	/* Never try any alignment if the mmap() address hint is provided */
> +	if (addr)
> +		return false;
> +
> +	/* Anonymous THP could use some better alignment when len aligned */
> +	if (!file)
> +		return IS_ALIGNED(len, PMD_SIZE);
> +
> +	/*
> +	 * It's a file mapping, no address hint provided by caller, try any
> +	 * alignment if the file backend would provide a hint
> +	 */
> +	return file_has_mmap_order_hint(file);
> +}
> +
>  unsigned long
>  __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
>  		unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
> @@ -815,8 +842,9 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
>  	unsigned long (*get_area)(struct file *, unsigned long,
>  				  unsigned long, unsigned long, unsigned long)
>  				  = NULL;
> -
>  	unsigned long error = arch_mmap_check(addr, len, flags);
> +	unsigned long align;
> +
>  	if (error)
>  		return error;
>  
> @@ -841,13 +869,30 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
>  
>  	if (get_area) {
>  		addr = get_area(file, addr, len, pgoff, flags);
> -	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && !file
> -		   && !addr /* no hint */
> -		   && IS_ALIGNED(len, PMD_SIZE)) {
> -		/* Ensures that larger anonymous mappings are THP aligned. */
> +	} else if (mmap_should_align(file, addr, len)) {
> +		if (file_has_mmap_order_hint(file)) {
> +			int order;
> +			/*
> +			 * Allow driver to opt-in on the order hint.
> +			 *
> +			 * Sanity check on the order returned. Treating
> +			 * either negative or too big order to be invalid,
> +			 * where alignment will be skipped.
> +			 */
> +			order = file->f_op->get_mapping_order(file, pgoff, len);
> +			if (order < 0)
> +				order = 0;
> +			if (check_shl_overflow(PAGE_SIZE, order, &align))
> +				/* No alignment applied */
> +				align = PAGE_SIZE;
> +		} else {
> +			/* Default alignment for anonymous THPs */
> +			align = PMD_SIZE;
> +		}
> +
>  		addr = thp_get_unmapped_area_vmflags(file, addr, len,
> -						     pgoff, flags, PMD_SIZE,
> -						     vm_flags);
> +						     pgoff, flags,
> +						     align, vm_flags);
>  	} else {
>  		addr = mm_get_unmapped_area_vmflags(current->mm, file, addr, len,
>  						    pgoff, flags, vm_flags);
> -- 
> 2.50.1
> 

-- 
Peter Xu


