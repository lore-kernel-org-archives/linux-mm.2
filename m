Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473E9CA0EE6
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 00:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA5F86B00AB; Tue, 19 Aug 2025 20:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7DA36B00AC; Tue, 19 Aug 2025 20:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA1C6B00AD; Tue, 19 Aug 2025 20:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8A55E6B00AB
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 20:31:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B89AC137FD8
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 00:31:19 +0000 (UTC)
X-FDA: 83795256678.17.896F0F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E135E14000C
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 00:31:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vviL69Pa;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755649878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=26K95M80qCqKAeWh7436x5EWuUaOzqVI9wzg5yCE1Us=;
	b=3SsbiiPFYVfeecaj7J83mZntGZNPqOk8lrcEM7i0+TWlbZGyv8/WYs1MG3dAQ3rwWl1v0i
	dJJgTY7UhvA/Da8A/GZFSr8wUyXGFxE5IrLkWuIq7iC73Os5P/oK3kvk+/xVDU/+RJDDzY
	Ce78zXnKQqivLRCgGemV/I/363X/jKY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vviL69Pa;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755649878; a=rsa-sha256;
	cv=none;
	b=Ry0bdD7u15jOMR9z/6h5/mPJFCppLpTOrU07tltCWcnacZdNw158gkq0BOPNJgAMyHukdx
	jR9QC9vq9yWYc78I4CoTLay73EnTwz5Ruaz19+TF6Qzc2ZFX8/RVeCyaj9dxDhz09/zXEu
	rSnIYM4Bq9wUceOfTKvNuyDy/iMVAN4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 77AD1454B4;
	Wed, 20 Aug 2025 00:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083A3C113CF;
	Wed, 20 Aug 2025 00:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755649876;
	bh=a+rr+2zL+DBv7am64i01iujgX7lpz9V+YnwpK1m1TL0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vviL69PaWq7ODy8RB7mn+u98Ymj7LRjtV+zSdyl5/BjX/YcJUxQASuMYO1De5A+BJ
	 5OI3NBA6tgOvf9ZXdisrYykHZ0zICR52Bjg7btgyFO7pfTaqM/MKmjvqmJWRXCMYdv
	 42Y/prdSa8yQx4UZVPmg4pvMSqyjGaW0tQaZiAlc=
Date: Tue, 19 Aug 2025 17:31:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiang Gao <gxxa03070307@gmail.com>
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, gaoxiang17
 <gaoxiang17@xiaomi.com>
Subject: Re: [PATCH] mm/cma: add 'available count' and 'total count' to
 trace_cma_alloc_start
Message-Id: <20250819173115.55194150617998021b4130b9@linux-foundation.org>
In-Reply-To: <20250819134817.247495-1-gxxa03070307@gmail.com>
References: <20250819134817.247495-1-gxxa03070307@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E135E14000C
X-Stat-Signature: j9pguskjjxy74thfiehhbe7rxf3bwres
X-Rspam-User: 
X-HE-Tag: 1755649877-515548
X-HE-Meta: U2FsdGVkX1+7wSvFcdVX7bOn/vMVfDkHzFlWO7HExBZEBsQaxtn5UWFN+j2e+cqO/vxU8mPhROUItkR5mvvWUjsLPwn2OK9CnZ/mdDMm99pfd9VUsOaAW6vNV9KG3UtGPwQT2263+9J9CurTi8lSM0/AhPQHCej8bNXZBIYzSUzSpuHJr+Fj89a8Vw5BC8pyVDI8HK5gdqrk9o1oYND/7ZAGzrthHQsNZ7LSR5K+nY2oxc30Htl8vNCEIppbZVq9aPpQjg7iNzufFQ9nwlxv5dH/058M8chfKHMwtVeWnP13KNXThQFhOmm1PfoiSiFT6iYWH5UxPA498R75oDP2OH7/Y/cvatPJJRYHRgwBXOwLAtpJRSBWQAnAZP2erC7L6RyN5YqzipCCPqGQAtGI2+CGZ8xJsnDODpk8vU7cpCUxCnPBOIGVvZ95BXezhAuTTDIctk/0ii5p7BSBaDgc6fSUQpOJE3z7ugis7XNlQg8u2uOPo4h/W4TPsQ8J+qUBCjIpW2X06wRMYP5Tg2O+D3DZLKyYL/NGpNyUYJTX7SXLc7s3vV4QyMmzohjcLQVCGqaKzV9jwPm7y5T6noLFuMBTVtBZk/BKQTLmJita5+7nVyf/gUKzI2raBI3yf8ZLmI5riY0yKZ3Tg1wSI0SrMzSejqP4cEOQxDBIPjq6uPF8oPLCqXzokXDgHFYaW42ZLbzV2Cb+qq91SlWneSOV+1+GCAfiyf8RBWoN5imhqrolEFkVBHe9wAO+A/RHy1d7WbSCd4fs9GGXQCIxslhnBgLqqzsK7EaitrfueOips5xZgFqqJ3a97wcuK7k+3qbgqvGAFJlfo4bbvB6068cLquMbPnekT2ea6vBdKzH0/47KJ/YJnK19AaCvfcfeHYD1v6BUmTHP0dh/lxGAMwh7siHnmZ6i5F01xEl8PF0Z5foDLZ/q7I0NZTnOKF7d/fN/ZQyhW7Q9fkXJq3Jbg30
 JJIhR/Fa
 nTMnB9lbODsnPdTkkfrfOjGKnF+uO4kxow5mSdx+HEdOqmPb1UjsYgqVR00pvJDnso8hsmyOhRadjofJTkQireJoCYScqz08DPCIDRg5s90R2n0Crj42izGTWXCBWZOdJOhNC+QyYanTR7bycuBCBwWQnRm9sh15u5aOVEsJnu+VNy4dbSJz6pFhZOJdQ/cFu1dkStE8R6+GUrudCwrkVkzGVYiq/Eu2zC4WwZwRftHxLbJywUnV8T3foPJlMTUO/QCU8pRW2uzhz+SWJgGKvHA3STXAffAxsLrRNgJ/QpD2Grr+6vYMB6Kr+fHaWWdyFkHxVAmBwXEYsRkKH61Vv7wdPKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 Aug 2025 21:48:17 +0800 Xiang Gao <gxxa03070307@gmail.com> wrote:

> From: gaoxiang17 <gaoxiang17@xiaomi.com>
> 
> This makes cma info more intuitive during debugging.
> 
> ...
>
> --- a/include/trace/events/cma.h
> +++ b/include/trace/events/cma.h
>
> ...
>
>  	TP_STRUCT__entry(
>  		__string(name, name)
> -		__field(unsigned long, count)
> +		__field(unsigned long, request_count)
> +		__field(unsigned long, available_count)
> +		__field(unsigned long, total_count)
>  		__field(unsigned int, align)
>  	),
>  
>  	TP_fast_assign(
>  		__assign_str(name);
> -		__entry->count = count;
> +		__entry->count = request_count;
> +		__entry->available_count = available_count;
> +		__entry->total_count = total_count;
>  		__entry->align = align;
>  	),
>  
>  	TP_printk("name=%s count=%lu align=%u",
>  		  __get_str(name),
> -		  __entry->count,
> +		  __entry->request_count,
> +		  __entry->available_count,
> +		  __entry->total_count,
>  		  __entry->align)

adds three args to the printk but didn't add their conversions to the
printk control string?



