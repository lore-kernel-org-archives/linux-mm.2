Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1735606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 03:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SUUc4n8Y
Received: by kanga.kvack.org (Postfix)
	id C14736B05B1; Thu, 29 Oct 2026 23:55:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBCDF6B05B2; Thu, 29 Oct 2026 23:55:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD2996B05B3; Thu, 29 Oct 2026 23:55:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 84B246B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:55:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16BA3C05CF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:55:46 +0000 (UTC)
X-FDA: 85377928692.07.9326E53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4DDAF100004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:55:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SUUc4n8Y;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793332544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZkxPW2ruqc0Icv4y+99LJtMWacocG51kIhVn5Ect5og=;
	b=30Xq3ugZ+njeSO2NDWGhAh6eXPYSvA1eeky7VgyR1oshcDiFC7P9M05oHQ5N+w8IQWUUmu
	HszwMcFdwdOepCHn3tYVyal3sf87eIGyRZNuuHm9VGlALV2zcrcXY+KtosjmftllS9Q5cA
	ZNBbnjuXCDCyXH0QymwnKo4mXHALvSk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793332544;
	b=OBl0Bh/J//hzFSbXDIToIiDPq2CXUgiuZgrBcV2x9yFNMn+OHOJ2Iocg3DjePDFh2/4foZ
	DPVPCLB2SBQiCSGHntwwD8g7SadQvA12Ulzul23Li9FIGnd9G/rGez+JZ5YbUsJvoj9xAb
	vOdeyR3OASrYduBXE/ow87zzk/5ySRI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SUUc4n8Y;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A2EB9600DA;
	Fri, 30 Oct 2026 03:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086BE1F000C1;
	Fri, 30 Oct 2026 03:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793332543;
	bh=ZkxPW2ruqc0Icv4y+99LJtMWacocG51kIhVn5Ect5og=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SUUc4n8Y9twmxefBBWPSiCCNBbkgwNw0CVmf2ItyOZEJv/Y4ha7kDBDwxKdnsbO6J
	 x1mVLqVUUk290osQYZrec+8tVOIwha/pI8nYNLtqj2PfxUsi1D06/Kx82fUHwiaCFw
	 9vxMZCneEVL2rlsuJSF/dRDkhIdigfovQ/L2GNrU=
Date: Thu, 29 Oct 2026 20:55:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
Cc: Uladzislau Rezki <urezki@gmail.com>, Nicholas Piggin
 <npiggin@gmail.com>, Shubhang Kaushik <shubhang@os.amperecomputing.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, Dev Jain
 <dev.jain@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH v2] mm/vmalloc: reject overflowing vm_map_ram page
 counts
Message-Id: <20261029205542.1fdef1d121d9eb720950b67d@linux-foundation.org>
In-Reply-To: <20261022-vmalloc-reject-overflow-v2-1-0db7a20c53f0@gentwo.org>
References: <20261022-vmalloc-reject-overflow-v2-1-0db7a20c53f0@gentwo.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4DDAF100004
X-Stat-Signature: a3cr9rpdexagww8ad1tfndp9gn6uor75
X-Rspam-User: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793332544-34285
X-HE-Meta: U2FsdGVkX1971o+GpEu6T2nP4AUiW8U7QMGmAMp3fTx3aH9DxOcM3qDaucUxRzCnLYfZ8xHOqgF87shZ16DCXeV2ItKOAW348MmpPbcuoBOHQXpAq3yPTbBKPLXcXBpeqjJ/3nPUBPDshPUbCDrsRizIVzWU/yjl1FvTDqSe4UrEH0hbA2Ei4URIxop+CXQyVmqrEt2C31ByQFwrQtpiA11URRd0YI471ycDO1tGvhxFndH0BRVeUF61KWqIelJaL4Mm04mLdo1zAyA/vH6adOkyOSpsvrI7thjrj75JHra1Ng43wqpdFdagPc+0racuOPVkDA+iWs9YncqEUEC3ueW9kKP1zhBPE5GjbfXD104lsymHQmnMPWzav3mSFhJpjPw3fDfJLL1rJbvGyPA8Aqs4i9yLiGfFH/AU2T2te3yIu5nRLmBoO4/SdVy3Iysh2kx6NTrYEUwr2pXlU6f517zOwPN11ttcxUM4SMthsQwsausjUqj7VkntvwV79ygXOkJ7ubiJgYZp/RC1+9isCEvZAsWL+CT816NKlKLvz03k7mxYQENL5O9RYjUk6JEVPYiTNug1Bb+1NRbt887XNjsY8Eb6z86MNvr4XkESTl3OR98umTf9DbK93qQBPSo3S2YV42VLQs2iv7ys1TRDQ2el+QHa/PNF6kmz4WLeDeSSytx2kiRVy9IjOg8UJV4TsQOfO3PNd0tBzuZ4tJQSEptF8EQq7pBfbaZKpgbXnLNfMhYTgxMIMjNjFJDEKqrZM1uxPyI/w07Yaij/aLC9ruL9J96R9cMZvYb8eVUQyq3JJebgzrnSzExQdTSmNwHwTu3qEOuYmK9PG20Ve4VTHmg4mnUfFNCD1EGHzhEU0wMXdxTZYElYsIaGVWpokn7CEw+4X4/HJNrmI68R6nD8+V+VaftIEjd7NLD/ds79wARuVAgN7YFyetWH/zLkpKMKOUhbJHmMTz/Dn3hg4h5
 RXs1exef
 zr9+W/8G/lJwPf/3ReOtADfuq7Epw5M/ju6EPxiQyl9b58byaCq5KecLVB7q8G4LGT3QCYoyZd9aADEsex0TKZS2ghRbpE82TE+pSGvbezONvmQ/PH5u3Mwt0b+5g6vle4jaVhzq5kAoq89K+WF6RZUntf4XR7uBH5nfW8XLB07IIyk29iqQDrghELdSV06Rz193n1asbetRH9eW/8fRA4+GZ4JwhxAW3Bmepit0APRb0NXlfytImifvCphYDN9Fg0D2BMqgde8VAfX83VAV0+28zyyAdLJhtOlslHfyfwh3Z0X2dIEmWuagAPFVrU2XYkJ73h4qdNZv5J7CRjH8BH+YOF34aroZcHRWiiEIQBgOvFDicLJ+BsPye+ZRPGeV04gxf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 22 Oct 2026 23:43:47 -0700 "Shubhang Kaushik (Ampere)" <sh@gentwo.org> wrote:

> vm_map_ram() accepts a page count and must either map that many pages or
> fail. It currently converts the count to a byte size with:
> 
>         (unsigned long)count << PAGE_SHIFT
> 
> On 32-bit kernels, this conversion overflows when count is greater than
> ULONG_MAX >> PAGE_SHIFT. vm_map_ram() then allocates and maps only the
> wrapped byte size, but returns a non-NULL address to its caller.
> 
> For example, with 4 KiB pages, a count of 1048577 wraps to PAGE_SIZE.
> vm_map_ram() therefore returns a mapping containing one page instead of
> the requested 1048577 pages.
> 
> If a caller uses the successful result as a mapping of all requested
> pages, it can access beyond the allocated mapping. Such an access can
> fault. If the accessed virtual address is occupied by another vmalloc
> mapping, it can instead access and corrupt unrelated kernel memory. In a
> userspace-reachable call path, this can result in a failed operation, a
> kernel oops or panic, or the effects of corrupted kernel data.
> 
> Return NULL before allocating or mapping anything when count * PAGE_SIZE
> cannot be represented in an unsigned long.

Thanks.  Let's cc the developers who commented on the v1 patch.

> Fixes: db64fe02258f ("mm: rewrite vmap layer")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shubhang Kaushik (Ampere) <sh@gentwo.org>
> ---
> Changes in v2:
>   - Use check_mul_overflow() to validate the page-count-to-byte conversion.
>   - Describe the short-mapping failure mode and its worst-case effects.
> 
> Link to v1: https://lore.kernel.org/r/20261022-vmalloc-reject-overflow-v1-1-5fde0042ffb9@gentwo.org
> ---
>  mm/vmalloc.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index bea9f76ed7e74247d4ce919250c2f02dd5c36483..8a056e424a4f2c037c10f736002839014f1f57dc 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3083,10 +3083,13 @@ EXPORT_SYMBOL(vm_unmap_ram);
>   */
>  void *vm_map_ram(struct page **pages, unsigned int count, int node)
>  {
> -	unsigned long size = (unsigned long)count << PAGE_SHIFT;
> +	unsigned long size;
>  	unsigned long addr;
>  	void *mem;
>  
> +	if (check_mul_overflow((unsigned long)count, PAGE_SIZE, &size))
> +		return NULL;
> +
>  	if (likely(count <= VMAP_MAX_ALLOC)) {
>  		mem = vb_alloc(size, GFP_KERNEL);
>  		if (IS_ERR(mem))
> 
> ---
> base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
> change-id: 20261022-vmalloc-reject-overflow-e532c556f3fa
> 
> Best regards,
> -- 
> Shubhang Kaushik (Ampere) <sh@gentwo.org>

