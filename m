Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 862D0F46C7C
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 20:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A82C16B0005; Mon,  6 Apr 2026 16:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0CB86B0088; Mon,  6 Apr 2026 16:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D46D6B0089; Mon,  6 Apr 2026 16:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 789CF6B0005
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 16:00:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1CCDA1A0546
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 20:00:08 +0000 (UTC)
X-FDA: 84629197296.17.8A5F233
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id D0F71140012
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 20:00:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n1nM9vaY;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n1nM9vaY;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775505606; a=rsa-sha256;
	cv=none;
	b=2LfSwdlPisstJIpakzVCBbxh+tV9aFJ+Kn9b6E52YoNoNbbvqTrC2FoOkibStbiHsdqaUU
	4/F3AGl6g29IywENGTv6AF9yPRHxb8LxIw7fcf59/o7J/Lh6Gd6T2irEPadLYPCShRk9N9
	a9FnEgRVpqdzXmKsjiUqtrr5mz+3ZqQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775505606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8lSepcfezUyfVWPO6/o+vv7PeT7gQ4BceAX6uoFixys=;
	b=kZzd53+gk87zCry0FDuS5CFzZNJs6fD/NSEqKFnIEBkaA3UYtwfX2WOkxlnKqCMyZxdkUS
	sah26cuQrMRw+J5RZMnAYsb23MOuwu4nPw1vq29IPAMxk6UpZg44rde1HE91QApfQuV0j8
	ofe1Rc5KJKrece57d058vzei1u2an34=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A212D40213;
	Mon,  6 Apr 2026 20:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367E0C4CEF7;
	Mon,  6 Apr 2026 19:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775505604;
	bh=oXXTRWtylokrspf3p4NBzIMBwP6l46m0t1X082urXE4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=n1nM9vaYSpBZimPYya3Gc+mzwOH1z7TAHAlzYaOyLyS42/wKh1ssFegr5qf11Ja/J
	 x53RaCWD2nUx5ES9gxVk8CFtUKCYFJeC8BEdJJUVm+zBn95/58NxpmsrVrae40CZ+p
	 7vbGGgtpQHA1SPv2zRJlFNoNUzITatWeCnZqyheZMh9b9f+vTVAw8+2Kh8Pv4ia86n
	 VEXQN9NLPK5129HYzGp+oBqD3PX1LBCXV6ghYqoV0S/WIyZ8rQUrhY5zO5u1+qURLz
	 whRnFj6msJGKVfW4Ji8T4IcAnEnjLGuBR3LECZYVqZ11eNPXBkyrxxVEBosU4dNeZD
	 q5RJlVxXJ70/g==
Message-ID: <15f44756-c868-4b44-9846-1e2e27783d17@kernel.org>
Date: Mon, 6 Apr 2026 21:59:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/49] mm: Generalize vmemmap optimization for DAX and
 HugeTLB
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 Ackerley Tng <ackerleytng@google.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D0F71140012
X-Stat-Signature: mbcj4k1wo9a43nbw6wi3kxbnpom8n86o
X-Rspam-User: 
X-HE-Tag: 1775505605-119563
X-HE-Meta: U2FsdGVkX1/4ZuR9BQHJ2B3/116qoCmFL+M5ij8Ql0Qo9AYGnoIklk/b06Jck2lD1ybamm4kGmdnoxoGrcI2RYlN0s+cBKs4Ln2sElZECQ434E71jxH6bQCCCp3IjF4WF7kQ7KrN/6C3OAXYuKf1S7y8a/FR5lG7Eg891+iiWBUqLac1OUpAgYYSghlQLeNeJNVsAlCwrJqWdTS+u/SWuziTKlbgXoHg1bvNfjF6ncTUtFSB+1Vgi/5aBC0r6M9YsvzVEWntpeFmhilEdnrsX0zooh1dFgeXh046JC8UrajC8mUeY54KowjbZJziVj7XmVbeowVq3J8jKXgcWCrOKikDejH31jbCXmEUsqnxd9GaJTAy16Fv9tl4KsQ7SnKQJv8a8ueGKqvBKRmoTQO0WEdyqh+dptTdoRwdC5t8v8KORryZUB2HzClG1cGXZt0SrWVyRzC3z3mmG8MOxAEWLcee9zIZKyb2wZH/pgaJ7MocQWYa/JHmPU76ThJePFnYIat7RI8Vv4beXje1+CJslsbEOhnFKJJ0fJ8K4PkNPgaR03Q5uLfoLTZ5wBRSDhH6dfOuQYB0YC4NyJWb+yzLWq2qisWjUU+VsEN7flrT/QVaxW8VkdLOwmJhnGwFDaoaSAgzcP6j8IaqhWRiP1/49OkQ1G6Ki7uZhULLmqrLRhxFukOe7Hn0CeCt12e5ZD1FQsrLH5P1JfSTV6RFX2TQRfkJIhmz3yAE8ZqtumKXysoV1Gu/PXSlKqbivAFLP05zgvmzRjhPCUiWCznE+9qAHnFdRTzlYrE8DVdCslZE4qGy0DXDNd17sXGOiBvYxOrDpXsGBkJ0U0/9RoXrjS7nytd8bXQgjoQwQ770PDp0ellrbPk0AUYB69QkSlKItbHgWZZjqKnhBYFaDGLbCFJtnMhSSFJGpZKBSfyFqeXEAqrxAzD/pXH8zuOTf2Sc/L2RR3LhsCLPqFrryZBBLvU
 Z9LCe8Os
 tw9trDRWnlBl1nvl5AkNGmYyu4yv74mXMKx/+V27TYrr0aOlan50DC4A/Ib6qW6C/RqhV/OFfekKvxNZURvIgqMwwSVVGamWcNhOy6JFOOckcujXO6t/4L3rdaBQEPvkeuOmicI1QeiGOFghhPID34uYME5SdveRi5n65B9oauNLJWGKtfveQx2leGsCrd3hIfybl0sCWV7v03Ktc/2vIdnurginuIqEAhNeWbzdTaau7E4TOb2Dd2o7zGRpTIL5Z247H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/5/26 14:51, Muchun Song wrote:
> Overview:
> This patch series generalizes the HugeTLB Vmemmap Optimization (HVO)
> into a generic vmemmap optimization framework that can be used by both
> HugeTLB and DAX.
> 
> Background:
> Currently, the vmemmap optimization feature is highly coupled with
> HugeTLB. However, DAX also has similar requirements for optimizing vmemmap
> pages to save memory. 

guest_memfd also wants to make use of this (e.g., through folios 
allocated from hugetlb, where it might have to undo HVO).

CCing Ackerley.

-- 
Cheers,

David

