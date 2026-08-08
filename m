Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1BD7C55174
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 05:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF2EF6B009F; Sat,  8 Aug 2026 01:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA4A06B00A0; Sat,  8 Aug 2026 01:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB9E36B00A1; Sat,  8 Aug 2026 01:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B6BF6B009F
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 01:56:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BA901602E6
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 05:56:09 +0000 (UTC)
X-FDA: 85077041658.23.DB09A3C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0B73D140002
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 05:56:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DlUG588I;
	spf=pass (imf09.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786168567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7KLdu5uE6R81g5U1iRPk0cqe3X/yRt9IJYdbtNaS8kk=;
	b=IcLRhjBmFqmjgYDcFaXNDfndoEfqTqfaube/uNETxIjWZkoATJ26qeP0TIRcFyr/w8t8Kc
	4PlzMNNDod3idtUnwXFJdFr1QA2/cuhljoO8WYymoipzzLqEa4nrDfRKmJWkkJkA/3ia0l
	5KCr1lPhvvM2aH6iQMQ5F+7jvkZNYVE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786168567;
	b=eNgCkVKc+/pJFUkcB2IfsmcCZEZLJ2xiH0O65XMAyT6VoNp5ZFXDiCfXqYw2MHCqDE9nLD
	EZnMAsA3gF+rM8d2J+dtF57hMRnyltODTEUcDXakAB1SQqs7iW19VPMsMuAWYPo2Id40Mi
	kSbDs2LxTuyziyLf/dPTxEScCy6no9I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DlUG588I;
	spf=pass (imf09.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=7KLdu5uE6R81g5U1iRPk0cqe3X/yRt9IJYdbtNaS8kk=; b=DlUG588IRRw+WNQZ3SS4c9jYol
	VobwQaT+Ow7xBvSq74Wpm7SPwmybUyfKNj8PYdNvIXjB/+cdh27sh5HKHf//DgUHpwq4Z4e7vZApA
	FT8AkIhtHrLOoHonFQ7UPfxOi8cczP8kpIy98JXttfyKBT7XMTx+AmZa/+07DARO8Bnpk9f1jsBYa
	i7RTC7XugfDeeksJpFogZ7e7aHADaWlPa02Yp5cBcepnNAp5TvBmplHWTQvFOQx5RGGak9juN+tc+
	uGlVc64+rcj7M5UOVLdyz7iVWRlh7sa/TtWJXtRDfyms1feiqDqea/wkpUckMTl9DESD0mCJK5Csm
	nePzbl/g==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wsa23-000000094rQ-1UNG;
	Sat, 08 Aug 2026 05:55:43 +0000
Message-ID: <f3bcf9e5-89eb-4885-a671-910722782ca8@infradead.org>
Date: Fri, 7 Aug 2026 22:55:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] coredump: Add bit 9 of coredump_filter for pre-exit
 files before dumping
To: Xin Zhao <jackzxcui1989@163.com>, david@kernel.org, brauner@kernel.org,
 ljs@kernel.org, rppt@kernel.org, pfalcato@suse.de, viro@zeniv.linux.org.uk,
 corbet@lwn.net, skhan@linuxfoundation.org, akpm@linux-foundation.org,
 liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, mjguzik@gmail.com, ebiederm@xmission.com,
 jack@suse.cz, jlayton@kernel.org, chuck.lever@oracle.com,
 alex.aring@gmail.com, arnd@arndb.de, keescook@chromium.org,
 mcgrof@kernel.org, j.granados@samsung.com, allen.lkml@gmail.com
Cc: kuba@kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org
References: <20260808052732.2589657-1-jackzxcui1989@163.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260808052732.2589657-1-jackzxcui1989@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0B73D140002
X-Stat-Signature: 53ii7w1f6r1ou3g4dz938e9gpzd1irg4
X-HE-Tag: 1786168565-943766
X-HE-Meta: U2FsdGVkX18f9o3WUr6fz+jjHENpXdLQhtd6YG+dOAyOmce9SIBo3rH/fvyHu++AjsittmR+Z2Q7ruNcLfuOmr/B/iS5Tjt8sNGRUUuWM9Zy8kni2zs1o3f41kwAZ+OICaBTsbB278r/6JU/ll1nA25U0L887xgx8f38HkZ3rE/Ycvlska+crVYJUIy0uecxrFa2du33K8OP+xYWBGYADsLCHcifI0VsydxtKkZTdTqhsRfMu5o/tyhATQx/God3OA/T9f2O+z448Rytgj01B3iZEvzy7pXtf48g+MlJzNi+KRQtO/m0hY1FlbgXcFei6KjfeBeR93TdxDtjS99xUd/OM9AkSYh797Umq3/Noez+HTDYxYiUzH2ablUII8HYAnCgUXbXMpxr6yXfswyv1ZM92gvvGINY6R8qNJW0e/C8orJb1AO9h5dRRC6ATAfsmrq+6fxDwIKk6LhpqoaijLRpVNBdNAXSyBU0UHvqCISdrKcH+SbetARhTX+yQpSJb2aec1oUqBGcNNzZHWZHEaTw+SzHbH9feqdXg2zyWGgpvySx3qySe2bwHS+GymZD15ke3jy3Tfbs0LoOb1Rs4vbXNVMk6SCBRrcJ6/qf0cVAfq76MLs0w3c1CJ98zNXaPRUEW1dolpbJjntt70wvuzpybJb/M7rlZ86dxa6y1q7Gqd94kOc7JmPVktxLNwNw/KPEt3SCQsTjqOVjZ0nyEdMnLfjvTDQdMwKYaUVFsn1iCz8oZmoE4Yd3OU9+M8+ETqNkxTV255xr+I1wtHmuQ/z8LbElV/iMPFsia17P5/gs1pOIOwdadxc5O6u8hDqwb13dfg70K5JSfV22v6dFCqtOUTn9aOpU/F0Wp71HwD39Q5zdKIapvGDThxD80KGZ/4PO+J53x2u5A27c6HG72GMx8wBS54ZLD5xnY4Mvs010Tm7UtTLtu5AR2JO6qHBoldnf1ekAoDXfBmQQt04
 7uDaC2RJ
 T0pRKnBlgWlfzKMI3lGH57i+G4p11TjKdvGXpC9JepfBRUVPcI2gvOX5OT6NC/GbZv5LswNXL2erJcv+HGJAR4G1GTR/az/ww6a7NaP2m5QbRhzrE6YdoU/ma2H4u+ZjVbFfxKw9e6a3J9cMDppXCmhxDG59Pkyw6Np9x7Bvoh50/tXlBKuEhjade42Zw+CDtkdyYwMG2BGG0lrx36hli8QWO+Ri+kR1xND5kgp06gvl3LQPq1Sc7D/8aDbNH63pYlqZezzjSPCnmqgJoAGoZAn/6o1SOKV36c44Gd2XxapcpjqqdQV/M21t+2Im6TbRSTX2MbA5Kz4q1IGzgud5ji7od1UOxV7lp3TWz94cbqP9WJl6z7UgJp8mKCf29Rg8HH2CvlqRgCCKgwBQsRLBrSaQ53C6okL94EkNxHXHi3PAfVXMuDTaPinAIf1xWYix3xzWxYe95YFIIzraCajDda+rh2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 8/7/26 10:27 PM, Xin Zhao wrote:
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index db6167bef..aee03858b 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -1927,7 +1927,7 @@ will be dumped when the <pid> process is dumped. coredump_filter is a bitmask
>  of memory types. If a bit of the bitmask is set, memory segments of the
>  corresponding memory type are dumped, otherwise they are not dumped.
>  
> -The following 9 memory types are supported:
> +The following 10 memory types are supported:
>  
>    - (bit 0) anonymous private memory
>    - (bit 1) anonymous shared memory
> @@ -1939,6 +1939,7 @@ The following 9 memory types are supported:
>    - (bit 6) hugetlb shared memory
>    - (bit 7) DAX private memory
>    - (bit 8) DAX shared memory
> +  - (bit 9) fd list
>  
>    Note that MMIO pages such as frame buffer are never dumped and vDSO pages
>    are always dumped regardless of the bitmask status.
> @@ -1946,13 +1947,19 @@ The following 9 memory types are supported:
>    Note that bits 0-4 don't affect hugetlb or DAX memory. hugetlb memory is
>    only affected by bit 5-6, and DAX is only affected by bits 7-8.
>  
> -The default value of coredump_filter is 0x33; this means all anonymous memory
> -segments, ELF header pages and hugetlb private memory are dumped.
> +  Note that bit 9 is set by default because tools like systemd-coredump go
> +  through the fds. If you do not set bit 9, files that are not referenced by
> +  any VMA are released before dumping core. Some file release logic, such as
> +  exiting flock or releasing references to shared buffers is executed much
> +  earlier.
> +
> +The default value of coredump_filter is 0x233; this means all anonymous memory
> +segments, ELF header pages, hugetlb private memory and fd list are dumped.
>  
>  If you don't want to dump all shared memory segments attached to pid 1234,
> -write 0x31 to the process's proc file::
> +write 0x231 to the process's proc file::
>  
> -  $ echo 0x31 > /proc/1234/coredump_filter
> +  $ echo 0x231 > /proc/1234/coredump_filter
>  
>  When a new process is created, the process inherits the bitmask status from its
>  parent. It is useful to set up coredump_filter before the program runs.

The proc.rst update LGTM. Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org> # for proc.rst

-- 
~Randy

