Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34F17CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 13:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B3646B009E; Thu, 28 May 2026 09:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964466B009F; Thu, 28 May 2026 09:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1086B00A0; Thu, 28 May 2026 09:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CDD46B009E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:11:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25EC61407B5
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:11:54 +0000 (UTC)
X-FDA: 84816866148.23.BF41289
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 833844000D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:11:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OiY5Kxs2;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779973912; a=rsa-sha256;
	cv=none;
	b=YFp6mZbFkjKoa3qHlYWSieOBUDiOF1pLHIZQjfCZ/0lQeaI/5TyCZ8MvqrwAPQ+Djh0XnJ
	ZirxRQdU8vheaYH3lH+2Cu6Q5OG3NjnJGmfRXyzge0p7nGniGbLOPU3ukjO4BGqtWwUR0n
	0DdhEcQvgWcZyjo75vQWTDnoWn85W7k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OiY5Kxs2;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779973912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VrpnDjUd1QiX7kPJn7TspldNReCZfbhP7mEDa/yWeoI=;
	b=M3v+2sCnSh4JbGMnuDYqac6lvQ75ZYHqUxalcicYTYz8czYoRHKafhoNi0WfNzkf6uI8zL
	kKQXCJUeTQRYVd4sVbXaEYaOEnyFDdbm7oKcjzYjivYh91d5lbJQN55qDuVfmgztTKpoHh
	A6VR9oP8wapvTz+0urHL7kNxn5sBOFI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CBEE41740;
	Thu, 28 May 2026 13:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AACA1F00A3A;
	Thu, 28 May 2026 13:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779973911;
	bh=VrpnDjUd1QiX7kPJn7TspldNReCZfbhP7mEDa/yWeoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OiY5Kxs2GV7tgu8Kq3IkS2SUr98NUb33Gwex3B73v3E9f5nE2xgBY2Qw4LPdiyOJf
	 vuzhEGUwj6TbNEIbWnVqe05DVqCmzq6FE3wUnVP7bOMncHPVgKmjsJEO/Q8EWcziap
	 xCUu2kgggG5hhXEnacE6dAFCQMxdUnIPTomJgcDij6uKjP7ZG1BFSsqJHHkkaH0V0j
	 X1ajrOM1L5jgg6T8IZM24y9Q5kJLL/ZphHN/h2F+N4AJdRaw9wZzsDHzGLvqcbwaol
	 r2K6HY4q65Eav1cB7Se7AriKHJsHmxmX6uA9HWb2NBUpmYhfOMO7jTh0/GDcNUmm+i
	 mAz22JGspXxKQ==
Date: Thu, 28 May 2026 14:11:45 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Carlier <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Heechan Kang <gganji11@naver.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Michael Bommarito <michael.bommarito@gmail.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] userfaultfd: refuse to __mfill_atomic_pte() for
 unsupported VMAs
Message-ID: <ahg_BenHg_d1TwUv@lucifer>
References: <20260527184751.4147364-1-rppt@kernel.org>
 <20260527184751.4147364-3-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527184751.4147364-3-rppt@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 833844000D
X-Stat-Signature: fkbzx1aehgozjo6garwzq9j4nkto5168
X-HE-Tag: 1779973912-72051
X-HE-Meta: U2FsdGVkX19LjBabkMJ3AzNLuHlwbK6cKHFTxl+pOzF0gnyn9atVY7quxiW8YfT1zUxVx7n9ynO9e6BOZTqoLYJzfCSXBUoMvYoDh1Z3b6ySr+mS6SJMMYSDt5jPH8OfPqfkCL6IwDOdVP336MUAr2HwaWDwkLYlH1M541RnbG7OUgCcdvU3XL3Jzx0Py4QyVU33nr7Ae+OSa7mcxiQN3y4wRNtWxFWNwmPPvA/rLOxiZN078RkT5HvmVyWVFwF4kJ9YW/adFkCcfTjaqnrIX//irgYgs64jwRsHTzcUQHvDAbHCf0qnqg2CkOez5V/gFmNGUqZmvy0z2bOHVkZfWNBbaNSuMQyux49PlxUm+QipzaAIsCR4sMionz469KJVEtXIcB2qf7e4iWiRePvdDJS3omtAvj9TJ8s10fJBQ19ak8ZFsO53VzdyQKeCArsqCwQkfRSz7aK5emXOkq5i6MtwOEp4kUjj4MgTCr4Wwt2mEZqV4fx4r90SOszibYvk5KZq+mg/rAI3k3O7o3j/7OtH131TTs94tPINHIjzvbxtA13SMhpEXMSCiQdtt7GCMfsxSQjK/rIBEf2NZeW9ZdZVhjmmqSa0RTz3CHpnuuBZScGOiO24OyN/LJipcla1/1c5liVO0Q6E8TCMZ91S+X5re4fYuTuqLAJE53b6rXUuDlb7XS7cUIfxsvh2ZplC+qnbCj8Xt2i6ClLK7k0Ely3Zw8ALUpYqghaPXPI5T7Ov9szOP434/9eou/N3pae82lFIryc/nr1hPB9eDCHzBWTslZKkPPOSCoXAiCoNqmB/4muIPadKUsx1U2SLIfaNEHJ4ZMFF7LaepmZS1W282iwNwWlU/uRgsASL5zinTe6PaYqyUuqFzvAvZ4qqYOPKUVheiTMAv1LjJrHyZc9ZdN+9gWoJrndRqVHPX85PvxRnOAR9jdmzfgPjvZGAgOuy1uICkhdIHN+hGdw6qnt
 tMtjVqww
 ZIx6CQjaufvfnt80tho4p+pYrLy5MMktQa+0qaEl/y8h4ASIGYTZkYaLUD7q2jQeubqmbTtYmu1fP/pEf5VurgSf51Q3K5qJUKZK1mKjcK8lgUZ+tInhDDuvf/x7heybhMO3WiFGqx+Gk7aN6NnQ1NSNFFB2VGKyG4mwdn5CryeorF63HOBIBrfrvVqQxsiAnXDogCVMm7Z/b7mn+/gs7HZ9mO8E6hmrNrTBRtao6Sb83Zj6b9J6JWABU0mgBrwkYuLiUSiKukfN2QhvHsAuAlDUSMixR4/iEB6YMSNmSFNVqaFcejqtPNFrz+UzH1s6VxQ++yDN1YpKxS6mb+MyOdNC4j73oCzrQg8qmyW/ACxnvduVXeF++CD/IfA4UsUlslYvprsvYABbXsAw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 09:47:50PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> __mfill_atomic_pte() unconditionally dereferences ops because there is an
> assumption that VMAs that can undergo mfill_* operations are vetted on
> registration and must have valid vm_uffd_ops.
>
> Add a guard against potential bugs and make sure __mfill_atomic_pte() bails
> out if ops is NULL.
>
> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> Fixes: ad9ac3081332 ("userfaultfd: introduce vm_uffd_ops->alloc_folio()")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  mm/userfaultfd.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index e5d2fb3ce2c1..2872c71bbf36 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -552,6 +552,11 @@ static int __mfill_atomic_pte(struct mfill_state *state,
>  	struct folio *folio;
>  	int ret;
>
> +	if (!ops) {
> +		VM_WARN_ONCE(1, "UFFDIO_COPY for unsupported VMA");
> +		return -EOPNOTSUPP;
> +	}
> +
>  	folio = ops->alloc_folio(state->vma, state->dst_addr);
>  	if (!folio)
>  		return -ENOMEM;
> --
> 2.53.0
>

