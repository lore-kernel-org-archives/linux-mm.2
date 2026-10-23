Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C76B606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 03:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=czzNPX1q
Received: by kanga.kvack.org (Postfix)
	id 4A6DB6B032F; Thu, 22 Oct 2026 23:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47EC26B0331; Thu, 22 Oct 2026 23:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB496B0332; Thu, 22 Oct 2026 23:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0BA8E6B032F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:19:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6FB53C0188
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:19:25 +0000 (UTC)
X-FDA: 85352435490.20.3F89D06
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id AAF951A0006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:19:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=czzNPX1q;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792725563;
	b=aWopJN4Z/m0tRmjpXSPXE1lbZrGc4YgZX6h6FBOr5iuc51swHAvroxdYqx6Kr891BZFzwf
	1N5miR2h4s99U+itWzoviv4BOWzBeL7Iusihy7+Zpb4S740DXbNqXiO8cXpFhgo+EJH4Gz
	flwMmULyKVSb0COxz8V750YplXYqjoA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=czzNPX1q;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792725563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wxf6VcWVYeDuwwRp0i4M/JreyaoXeCjGc7I8ozu8W/I=;
	b=YnS/LDV7lbWlBAVMbx8+FmyVR0nglY8M8I9FhpEUb8AaKvY1CtNlnWCoezEm/DDl/ljTOu
	qFfof8SKYH0xuQny0pXIvif5appJjBcRk0hqlAS/5dD0O1P9WJCEShuuSKFmWau3Ldrdzh
	PzFQjw9X/Essy7QfFCi8TkY+Kbh72sw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D20CA63E83;
	Fri, 23 Oct 2026 03:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6F91F01828;
	Fri, 23 Oct 2026 03:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792725562;
	bh=Wxf6VcWVYeDuwwRp0i4M/JreyaoXeCjGc7I8ozu8W/I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=czzNPX1qDw0hEzblUzLG4mY4jMqGFO9wUYBLvjI7WNcg8xoSFGnXLCeVfkQh7QkFE
	 uOGV31XC1bcSaneMRWDPZHqnjb9s1DPQrZmCHJfStx1q2PC5n4raDN+/MuXI585ZfG
	 ARyGpQK5VRoKfVvMvwSwLCOt7pSbg+TIRAD/p/uU=
Date: Thu, 22 Oct 2026 20:19:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
Cc: Uladzislau Rezki <urezki@gmail.com>, Nicholas Piggin
 <npiggin@gmail.com>, Shubhang Kaushik <shubhang@os.amperecomputing.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: reject overflowing vm_map_ram page counts
Message-Id: <20261022201921.e418c25c44fd24e46405a3ba@linux-foundation.org>
In-Reply-To: <20261022-vmalloc-reject-overflow-v1-1-5fde0042ffb9@gentwo.org>
References: <20261022-vmalloc-reject-overflow-v1-1-5fde0042ffb9@gentwo.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uzccr36rtup8qatp9tf96f6kzh835b39
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AAF951A0006
X-Rspam-User: 
X-HE-Tag: 1792725563-224400
X-HE-Meta: U2FsdGVkX19PRXnh1gQ0nrXCqdgAmuEKWNjEmnZDwQqI7Fbonl2e2p3uZm8qqRkkU/crv1cQHarmRbweJNQqCJAey/cQhOQq40byHkhyvJXw2uTBLFfnuIffRh5gxe9L0slGziElKG8BN/IL23Vv0YLGYRKTL9ej4Ag6WySGmSEccgYixl+Npvha8lLDHJpurXZ/oT2GayRtyE4fm8aqdL9sFSToPY0sJG8EnylGQzYQ/ujVTWSlPjkCtJr/lfitAXyIsAZtbvMqikkA/Mzsv35sojsUQyU8g3DTTCDXYrmD7TbSYfH0pd7QZpIkl2+Hp1XmugiW4UBdMX6lb2spHvCFcCrQQ4q4bxdqoWuY8O7GzgBxYAzpNBUADd7zr+iE0TBe3Xj7WDzrTkcpUoB/pCYuar7O09tfE6PZ2nu7owFNHp7T1hbQMUA7NxWR7aZzcto9AuDgdFXWjoqERZRXOuMog3KhqF6jWTNQIlvLF6eXpVwEZqOBqfsVTGIf++UVa22TYTCZ1PPZp+wZfCNF0ASvWBU2g49k7w5Rvj4bKPTsTkECuPRQpcGpfk5BwHbhDHzS0fZFRDEV1hyBoQpsEsR4kGgY95KRpUGy9ljYiCrUKHFGP8xCkmCoYnYW03GoVARYtDjqRBj7h3KDSQG1pr80WLroGSssf452YX8mpiWuFfebPEpKw8539dD+XG8BJZGEdFi6Ka1rsyoEWIi+zwDN+hv/C7obzOdCF1N79vAEdixxEHTQgYfpYe1zniXXAzAJgAskHal39U592pN2GB2OZfbL9ai1uyx+ty1XQXeMozJfItL1kSfbSzCP915PLweUFDqiWaAjRKCy4G/OqIc1odwLuAHrZ/gizi5Ui7fPg6xtONV2mUJ6FoNCsiyRcSVb4NxVxeYgG7u+Eu/oysiqT/ErmIToQI0sV8JhpToW/S23gpdUmW76fHY97Tju4Xh3BpImmOtN3G7X8KN
 FNyMMdrD
 q3yb+i2e1+oAYXGUBdLRNWTDbdzwmBTY4ZtvXK/VXaIAgVTZDuveWiITLX3doTPiBbBi1y0D1ocyzfgjjUPEo86z01ex4pHq3B5i2eGtoe1qYCtIy7FHEmPelNmpOmgQDGtBNNKd2WxRfRu1h5NZL97dgH+FP2MuZG1Mn2jH/rni3xJ3fYw/B5tM0bDxmSM1qrxva3c7VKCr60gvfwHnty5iEHnn6DBy8KUkYzMinHUTGUkV2bwtlQFg2/JHKAQ9qtbhaBjz9LnC9ZBrIYknotErnUqIo+iIXqCbZyMlt4Mdewc8OnTIZzMDgZHvKbWDUGDGUvhlytUtrFaMtzhi8IeFl79ZkcPLolqqv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 22 Oct 2026 16:35:20 -0700 "Shubhang Kaushik (Ampere)" <sh@gentwo.org> wrote:

> vm_map_ram() converts its unsigned int page count to an unsigned long
> byte size without checking for overflow.
> 
> On 32-bit kernels, a count greater than ULONG_MAX >> PAGE_SHIFT wraps
> the byte size.  vm_map_ram() passes that size to both alloc_vmap_area()
> and vmap_pages_range(), so it can allocate and map only the wrapped
> number of pages while returning success for the original larger request.
> 
> For example, with 4 KiB pages, a count of 1048577 produces a
> PAGE_SIZE byte size after wrapping, allowing a one-page mapping.
> 
> Reject page counts whose byte size cannot be represented.

Thanks,

When fixing a bug, please always fully describe the worst-case
userspace-visible runtime effects of that bug.

AI tells me:

: On 32-bit kernels an overflowing count can currently cause vm_map_ram()
: to return a non-NULL pointer to a mapping smaller than requested.  The
: patch makes such requests fail before allocating anything.
:
: However, I haven't identified a kernel caller through which
: userspace can trigger this condition. The callers I've examined
: appear to constrain the page count appropriately.
:
: So I'd describe this as hardening against invalid kernel API
: arguments rather than fixing a demonstrated userspace-visible
: failure.


Also,

: On 64-bit kernels count is an unsigned int, so the comparison against
: ULONG_MAX >> PAGE_SHIFT is always false.  Clang W=1 can warn about
: this, potentially breaking WERROR builds.
:
: Could we instead use:
:
:	if (check_mul_overflow((unsigned long)count, PAGE_SIZE, &size))
:		return NULL;



