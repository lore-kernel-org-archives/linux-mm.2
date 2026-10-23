Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF77606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 11:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ixSxhJ1+
Received: by kanga.kvack.org (Postfix)
	id AA8D86B0346; Fri, 23 Oct 2026 07:22:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59796B0B44; Fri, 23 Oct 2026 07:22:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96F7F6B0B45; Fri, 23 Oct 2026 07:22:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 775F76B0346
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:22:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB9E812039A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:22:18 +0000 (UTC)
X-FDA: 85353652356.25.D871E24
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2B36C140007
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:22:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ixSxhJ1+;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792754537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2JIr32shhDAdFV4wsdsTH1dxV1roHF7U6GHSm//gPNQ=;
	b=4sZH2G1lMl9OZRiG2PWTfB0FDUjjih9ea8kGcjA+6oxvD6pKRGzVqBRBnAcFX3e4blyl5h
	b6jvnZ0NVzXPtvud3Ny9TksHNQsHdtyPwzqCtq9IUcgjZYwDCJ1wYAIv9BjqhLDy7nv2KI
	aaRjjzahuurNg3W6gI7O74AeUBIrmX8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ixSxhJ1+;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792754537;
	b=HKeT/izF9s42cPgMR8ZfPfdTHj7pqB4hlTkMKKcIA68B+x9Ib4VpZmjR+iNiFCxOJ2ywhG
	3VFhiJSlJvtXPAxs24MTH5HYlt468S5pg3OXi7/GOvPW9WTovLuOtO9VgBFgdWkH/Jrtzx
	iofDBNfkVQ9hRwR8f1CioU+vG6OwSFc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED3F11691;
	Fri, 23 Oct 2026 04:22:12 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6BE893F7B4;
	Fri, 23 Oct 2026 04:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792754536; bh=pEs3PZgwiPiqg6sjwJKr14el93Iv6edM6dGsgzxNJl0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ixSxhJ1+Dmcvys/GZodc/+Jt78DSK1F+KDsahqOP1t17iU5/s1dFp6AHOvHfZ0RX8
	 zUkOa7zeXfylmXrT6WH7q1TN9ptVS9xK92BqBWue/SJ7NrlKTjjUFLhfanIEp3hAJg
	 F59g27ySewmTyN0ZYl4/69ocRJLGqL+8SEJBX6HY=
Date: Fri, 23 Oct 2026 16:52:12 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Shubhang Kaushik <shubhang@os.amperecomputing.com>, "Christoph Lameter (Ampere)" <cl@gentwo.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: reject overflowing vm_map_ram page counts
Message-ID: <y5yuwnmvq5nouoitqj6lloz6hepha6cf6vmh42rer2zhgv32au@vbvr3ohn24tf>
References: <20261022-vmalloc-reject-overflow-v1-1-5fde0042ffb9@gentwo.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022-vmalloc-reject-overflow-v1-1-5fde0042ffb9@gentwo.org>
X-Rspamd-Queue-Id: 2B36C140007
X-Rspam-User: 
X-Stat-Signature: o41qy86adtdnocgqr5ry9yg9qbcts9yg
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792754537-891359
X-HE-Meta: U2FsdGVkX18Ca+8ZwKSk5ohiCW3jcNV54hB6ivBaTbU4R9eyKgd6pfHsg+DcZKWj8BAIQFpPZpoOMuOGvhrpCfI5JdL8WgntdmkLG51RPG8idP5euUQeycWZ6F5LboSscWtlLJ8IZw4b+j65dGcgRh7o6s0SyoRijTPqBJLoNDecCyBkbz3eF6GLUtBHuXg33YyQtEA94HZ7I6EN3W0DXx7qVTka1xB/iiqmVbjpQuaDT2Ga3sVAlCs6LDq48MNUValwwFVt6fSSEgD494YnNqf96qyI5pRMncvp+g9bZuMRJ/c4lD7lx6oUtcvSkJcimjj631fOAfKrj54InRkqUJ8iXmP0ijEHHiknZ55/mj2Oviz/c9eOF6kJIae0Ed4Y4l7cPVn+AU8DQpQruKhSHXYvekQ/TbSt/nPcxgjKK9kpL/p+hi+j8x60hK7e6vgaNnFLQPlneke2AUVj2xDqMf16PNgbRlWIh7/1sSaSTVTWrR8wG52rbYAh9ovvjt7uSuQ26n14QehqsFsa8KB3hBWHtrIrvpGUPyZkiH5OiZlNVffFwHF8vax5i0lknedueaPOfcB8EytBEqHCNcwil1kj5Vlz5p6chC1TjMEgUyecGclnSOI59ZKIXmU3NhbX1+PVEja6UttXBxTem7/QemXx6/GTt7EFzEn8yVJez1HLMhxnug0Ec9Zfk11mohCZZTsX5rZyIlIltX2SdCE/Pm3P/Slc58/2y2bC/1wtxVAcZXCknEfCE42TZG0qk/slVksOa+D0kUPxQ7ienfZa1gcsxV8cXlwF5j7crn8v3+Nklf3+Tpzlc6YGqeL77zljy788f2NRdoxCtaxtc5lmq8NVS8OJ5aN4yKIG9yXD1XUtP3pjvZ8W+1FvJGXBmS9eeMOLeg1kLl3OtAL8um7jvS6TakMiUl8BOqBSlYX3fwfNUf6KLXD7ogJ2g8z4JLNWID6G/ct+/LxxVIooaEw
 XcPF92Uo
 Lh39JI19qXgCqesxWzjV0VHtxmmo3ogTmscGi4+nCnegqdkhe9ss+8Ec06OLG30s3WcNBS6y7rzviu0fzYuAcKWdbcL922EH+WFYxwElyQNXHyXo804WCb9Yn9aivDzctJPpbT2lkpeNOz7bEFXb2itoyzD0ul8QjGKF9W2mJA2O2tUROuCfpRG2elnhBKMtpGjj6VjOzRx3zsVWOC3yYj1okt32VBI6PwOF7FUjvea9M4boBSmv2DdF85SWlbLAsMAM/6aSb3Dk1GTC4g9PzGyS7Ejn26Em3ERUHCfjb/HmZZiKmTvluzScJ77vfcB/rl4Uuaw8CdMxW0KJ806OnXLh4to+FX/eSgAzmp9P0Y4dGizswHDISmJtow+BkN4kyS4Ix
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 04:35:20PM -0700, Shubhang Kaushik (Ampere) wrote:
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
> 
> Fixes: db64fe02258f ("mm: rewrite vmap layer")
> Signed-off-by: Shubhang Kaushik (Ampere) <sh@gentwo.org>
> ---
>  mm/vmalloc.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index bea9f76ed7e74247d4ce919250c2f02dd5c36483..e98d3aa551fe205ebd9826daad9ad6bd578b91ea 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3083,10 +3083,15 @@ EXPORT_SYMBOL(vm_unmap_ram);
>   */
>  void *vm_map_ram(struct page **pages, unsigned int count, int node)
>  {
> -	unsigned long size = (unsigned long)count << PAGE_SHIFT;
> +	unsigned long size;
>  	unsigned long addr;
>  	void *mem;
>  
> +	if (count > ULONG_MAX >> PAGE_SHIFT)
> +		return NULL;

Could vm_map_ram() ever be called with such a large number as count ?

> +
> +	size = (unsigned long)count << PAGE_SHIFT;
> +
>  	if (likely(count <= VMAP_MAX_ALLOC)) {
>  		mem = vb_alloc(size, GFP_KERNEL);
>  		if (IS_ERR(mem))
> 
> ---
> base-commit: 7be4bc52fd9e0e55dc9a2e0232b89427d2c4b614
> change-id: 20261022-vmalloc-reject-overflow-e532c556f3fa
> 
> Best regards,
> -- 
> Shubhang Kaushik (Ampere) <sh@gentwo.org>
> 

