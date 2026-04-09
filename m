Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8218AEA3C4C
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 10:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A24A96B0005; Thu,  9 Apr 2026 06:43:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5C26B0088; Thu,  9 Apr 2026 06:43:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EB056B008A; Thu,  9 Apr 2026 06:43:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D78B6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:43:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 287891B841A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:43:46 +0000 (UTC)
X-FDA: 84638681652.12.88534D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7935240002
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:43:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q1mGk+uV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775731424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jwPYPiqvk2ZFIe1ouQWppxxtenc5NiuK1evhIvndwWI=;
	b=u1A+mHmvJ5Qr45puytLkWQX3AaR5PNkdYjJTq8PCr+gE3x/0yn2X+4KmGuWb7Cvci1xVld
	+28OWM5JDjQYhQxeKDUD1q/Y52RDMvO7GqlT1DrTtv3h1AmZfnPG7e/GcjnCLY5LIyPY9l
	dRZCv3rdylvFQsquqU9gWuDOWLFWCGk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775731424; a=rsa-sha256;
	cv=none;
	b=0jlE6iLSSysk6tBI+Alq+Pzr/SvTy7J9Pq2QQ0eOHnPuYgLj/d1Qld8sQv/SGwSxIYJg6W
	FntbdJN+I7KEhoR5LAMdkVd2GOKa5Oop79lxn1XIDCtqqlKHIRGTtYrv3+SlfhP3kzw714
	IkpA2Sq96o7KrzNhX1mAATpUGjy9dy0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q1mGk+uV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E4F2439DF;
	Thu,  9 Apr 2026 10:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C869FC4CEF7;
	Thu,  9 Apr 2026 10:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775731423;
	bh=5ml8mhhklm4HBRD0vDuN9qP5ofPgl4kjNMeUuK18QGc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q1mGk+uVsWVNNwAuFFURUf9UZHih8sBBd4h80F2ws7Tq9q+/Jto0fxGGLVvf+JRHA
	 CjfTETaNUEXPjrlE3a+FuxugUUMxCNJw7koLBXE80KdImHw7TBsovAyAO0rjrjUzw7
	 67ZAuIl92UvVjlryJjQPf68g9kb+Nw7QvnLqVFzhgp+JDT2Q9wCyZ33f5SRhvhJRDj
	 0j6+n69s2Yw+UENuNAA3BlEQdqm5EHUvsPjly9dIYXKnZ3fygeqjMI9Wu9SKFRzdS1
	 8XudLwhctfto2SuTccbP1+UdzVZSRD5HXBYkYVlHWg8ZJNsLbjpUgLZ+QCXcLvKIsY
	 RWTYoAK12wh2A==
Date: Thu, 9 Apr 2026 11:43:37 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Denis M. Karpov" <komlomal@gmail.com>
Cc: harry@kernel.org, rppt@kernel.org, akpm@linux-foundation.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, jannh@google.com, peterx@redhat.com, 
	pfalcato@suse.de, brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	usama.arif@linux.dev
Subject: Re: [PATCH v2] userfaultfd: allow registration of ranges below
 mmap_min_addr
Message-ID: <adeCuu2ByxD3Sx1l@lucifer>
References: <20260409103345.15044-1-komlomal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409103345.15044-1-komlomal@gmail.com>
X-Rspamd-Queue-Id: 7935240002
X-Stat-Signature: 97y36edx78ozmpg96y6h9h6oxyjx3icr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775731424-893230
X-HE-Meta: U2FsdGVkX19H0isBHRlnfhs8SQs53C6wQkRz8uJPg4uQAr6Mk02jTTQv/f47KC15SJuhHFu47+rbcAez1LcETs2qZSyhU/lX7a0QqN5TRXHst3WX9I2MMxo+pP5JNHS9i9I3udQpWisKWoaQTQEf0Cvrg+p1p5v9fMhuMgGXQ78EMUVe4oJYWs/6XGgkYBT7LN2sF/dP9JddA3WFJgczjZ5hH9zSRTiVDCIB1P3pIKZuDkCRcsE257O+RKGyX5H+9tyzXIum8JS+IouQLtXZ/J1DcQOJesHw+0is8VD6cqvaPZCfjwVyFSIdFOcod236AVdMuDhGnIpX8Jzg/KOlm06Q/PE5iyoNJlAYGL2yHDjQ+3TafMcCNe/DnESCUb5O17JwrNcmLVqG2a/vVRbRI/mwnkx4bbZ47OxYnSCSNoX9wgZfcG9zZeJrKcgdyeonPaPuyjlDzSedc34Sy3BBSmyMaqLqh6Wf5Jmcs6nVEDDHdU0rNd9Lv+LDQuuB0RwZ6l7yzzMzUETfC45PCpm3ZqzTB6pmPKxVxGFLwyd7y4bdHVo3Ie9KDudN+HgBgQtzVzelvQDbtajOjsaxpLr+xdmG0HN10Cn6xJNn1FjWtHoWD5PE63XYy6VmYYlW1LUGd/TQNDDOV7RiVOZN09SS0C/F52r6Rhw7HJlkYU72wT5ImuejbI4q3hoLXIrFzc/qG4wkv6YeQiSCWuUoSfTN2O9jaGZpKw/+4y8aIgv3DabDe0La8igXmjFztLKwS16GFn0TSZInfFsEzH8WIDQMTS+YPoT+U3Fkmj8YuNeP3ZSYAqPUTNm765P2dPSZbXxsRF8AFifXShitPxkMwetDCq4RiPPnGoQQrU3k5lO/Jp64lQx+P/4oRhOBIBgoUtt1Zrg4/YdCuBp1eqFwmFWgJamrBTw+LnN1hIEYBqOlOgBxMDiz5SNtxgSPSVJC5c1mdSVQT6osc1J27kaXKQE
 wXkMr8YZ
 /pfYOhx8R+bL0s8jLgnFYWpAAvcGgNsReOGuHXFvz/X3eVc5MEeTHET5nN8zt1CovP+yaE6RXqgt3bPKScNS0irm6yqJytQ8/i71ykPdo9uhJDrgH2snkpJ+U3YTacN9fWPp3WuFi8z4Zo1WZyjTZ8C9RE3wl6No6e3EODcJmLLtYfzdz2p4SwjUyjeKjrlrHfVf1PK6Q+OEjzxYKZQ7g47x789zVzkdoKW6o0ZbotlAgn9zPCUejTLX1zpHps0HS0x5mRy/5xANjohmegHi5Ak8eDTG7xpGcUsYI2cjKqJ5lEQn6VlpJ7XHgjv2z+gBzTZxAOV4A1Hk32BuHEHvufIDLOmcrDQ4invOt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 01:33:45PM +0300, Denis M. Karpov wrote:
> The current implementation of validate_range() in fs/userfaultfd.c
> performs a hard check against mmap_min_addr. This is redundant because
> UFFDIO_REGISTER operates on memory ranges that must already be backed
> by a VMA.
>
> Enforcing mmap_min_addr or capability checks again in userfaultfd is
> unnecessary and prevents applications like binary compilers from
> using UFFD for valid memory regions mapped by application.
>
> Remove the redundant check for mmap_min_addr.
>
> Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory externalization")
> Signed-off-by: Denis M. Karpov <komlomal@gmail.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
> v2:
> - Remove the check entirely rather than replacing it, as suggested by
>   Harry Yoo and Lorenzo Stoakes.
> - Added Fixes tag.
> - Link to v1: https://lore.kernel.org/r/20260407081442.6256-1-komlomal@gmail.com
> ---
>  fs/userfaultfd.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index bdc84e521..4b53dc4a3 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -1238,8 +1238,6 @@ static __always_inline int validate_unaligned_range(
>  		return -EINVAL;
>  	if (!len)
>  		return -EINVAL;
> -	if (start < mmap_min_addr)
> -		return -EINVAL;
>  	if (start >= task_size)
>  		return -EINVAL;
>  	if (len > task_size - start)
> --
> 2.43.0
>

