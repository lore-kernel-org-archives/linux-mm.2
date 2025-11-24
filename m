Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4C6ECFD317
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 10:54:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 027A76B0007; Mon, 24 Nov 2025 05:54:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41B86B002F; Mon, 24 Nov 2025 05:54:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7E946B0062; Mon, 24 Nov 2025 05:54:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D340A6B0007
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:54:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6EDED13A791
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:54:02 +0000 (UTC)
X-FDA: 84145190724.17.6B9763B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id C1A261C0011
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:54:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ogaqLF0V;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763981640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZBx0c5mPiDmNyWrXhA0OqRz0W/9nm8gjgusX9D5nLo=;
	b=dA4c4cePyZOE3CvSfmU8a3nrmT65l9njRx1nyzdjU9+gEFByJic4eGUVqTzl3vhq9b2601
	aQv1RD4XlNqBeqZVYluuTIAaXunQeesZ4imdI/Ror8+t03n9o8Vg1h2Yvf5DJ/NDEtDBqh
	ktF74n31ocIUq3r9GCkzmXbz7HyzspA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ogaqLF0V;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763981640; a=rsa-sha256;
	cv=none;
	b=nWRWH2S/AP46R8LdEZaObw/KaF4oC7dVaSIQ3GVMiPZsR+NmzctJ8/uPbiNctjHXhQsdWc
	UtnkeBdLWotu9vBi9AGB+5ycqfLf2Ra0JxeDd6ebwPbpia43BDwV1umqEXS/25/PrvOe4j
	xx5CxplEW0EdISjIC9RV9pNBBzmE0p0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 10E0C601B6;
	Mon, 24 Nov 2025 10:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C24C16AAE;
	Mon, 24 Nov 2025 10:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763981639;
	bh=JY2i1yUY0cE28oKluKky0lLNF6J76RvUJnJzF/fAa00=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ogaqLF0Voug39wKOhJtK4TsUUWxh59FWw1iP4IujGRJhLAC3V2EXjmLM/PiiL2VYJ
	 MWmVd/Wamu2gks+AU4hWCJwnBj44KvVJHwAXY1vF+ELd6btuFXKuCBuM5EXnpcZ+ek
	 NgLoC1YMrRRYDb+j2YKBUelXA3ExAL65/RVXbtgx42GZ5zCEt66d2YUWAyN/yp2gnV
	 OAFhkitfkbVOgIXveO1zPMctsDGk3e8tVgiYA3ZGm3OYWQT+56QxQ6PC9E1dUsGS4g
	 TMlcjhjEy0DMm1FmXFqiQ2eE3QCepKau9Gmc+7jdsYh3u2hJcVCts4Oso6uuW3nPzQ
	 qicHb9z26SMbw==
Message-ID: <aea7ec01-bf81-4172-b44c-5c43e347f479@kernel.org>
Date: Mon, 24 Nov 2025 11:53:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm: pagewalk: simplify hugepage boundary
 calculation using min()
To: Sahil Chandna <chandna.sahil@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, zhengqi.arch@bytedance.com, Liam.Howlett@oracle.com,
 weixugc@google.com, axelrasmussen@google.com, yuanchu@google.com,
 yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@infradead.org>,
 David Laight <david.laight.linux@gmail.com>
References: <cover.1763796152.git.chandna.sahil@gmail.com>
 <f802959f58865371ba1b10081bced98e3784c5e4.1763796152.git.chandna.sahil@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <f802959f58865371ba1b10081bced98e3784c5e4.1763796152.git.chandna.sahil@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C1A261C0011
X-Stat-Signature: 7b5oewajpfrkmepx3mhm3c73yxfsjegc
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763981640-997535
X-HE-Meta: U2FsdGVkX1/p1t4MQUkg/qCg7BPox/52OhXWYPEW2BBKoN7vmPoQ8HF0Fu9vNz1lh/B5BHsNov0fHSgu70fZdNMwlTnKwA1AN2tR4g72bMsDM/7v9HUqhwfNtw+Z2m9iEA+GPxzi8/iMozxe7pNiAVyYDs9SDVj788mfkT3tgVeOHXd7F3lPPsuTAcwvM5cv35PZYZ9oyXVBdNmjFm+tZaeD42OZYLiXy7/DEqLjpQGZ0zQsLi6I7iNHqzS6jGhy5EQoySbb2fVt+wWtboj24nrclPugDknlg5XVZPJLCNmZ4BX8xQvhkzw0gh4gHd4hYso3y0159CeO+0sM7BVlzVkvzbpgqEUChGT2MNi3+zevcgU2gqqTBid0jnrOkn6Y2UmsJ1n+O8Rq+vcdqaWVdMEQ3kB4SwQbI6V+V1+nk6AtlEf2oXG8isd6U2jS9Py3mZ2NNV3PTBdSPvjb55t6qaXSl0I7RbOKZ3BSEoxTw86jbgF0fvF9bq3/0so4zDZrY6Ay1sd+7tCSSpQ4gBMRWIXm4YNY5MoDTfmbdH5tXR0LEXy5nOND+Dag7b4wW/50Prvooj6vSCPRttn+olgCdkAeKYLiD4FTRizGyPFeUDpzpUrPAMWD4gqCexiRa+Tdz/OK1l2exz07SFRfykDKWlBx8tN+b7juy9Wd8jDdmi7W4KdYgjDNsDCbdUdWQUGSRDgha/AXAaZiX/3tHilLhDiQ7RvkKqrM7f5nwgeP5xBjCKfMU+srfNYRAtjbDz68vKgyy2QLEulIi/vtEhuVPJfH1hpdqc/RSz1Q9K8EuDPby+Z0zJgMw+qzBFkwyyElOGB2jlzQbClOTOpd5SQCseWccaM38MHHa/YxnRLbmEkGpCPR5XlvuAAWb1uSijwBFWIsxMTaFO1kP+r2r53pmIaKYjADkn+0be2LDlU6SspoHzXrZ0Am3hIH146OVhRDBi0GvFp69jJQtKfKWNn
 8OXjYLYB
 jpairquqf4VKghgu/EfNjLge81tKU7A3WNKKq6Ai7CMWCKK9VBVskao7qOQVNtW2BB47NjjztHH5GEkW9XhRVnrMRQkYuV6TZjtlqN3zudw3UEQxXg8wyK1wQgh8QtkH8tsrmE3i8+q8AMCgHjKq45VFxBrUysJG4KjdJn4uDUvWCrKDckzs5gGE9Ph8FWaGAVGDV9zgEjqMMooGYt0WC1I8mu4yHjT9EGAL2VkxXAswjU7dEqa3evakNMc+JtJ+8wdUiY3HsHjoC3lLVnuaKjUDN7x1z5j6qfG8+NXrBpvh8cyrqWdVwniG8cYUU8AochnKRqkbnS86RBOwPRwuuHSYCxQjrkWswRwkX6QNWrRMZdFEKba7IwmhQ4RZXA5wBCqZ4EMklpCgKW5XtB85N1K/hYsEGooovW+bwHabzteSN7U+v46pIjQDipg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/23/25 04:04, Sahil Chandna wrote:
> Use the kernel-provided min() macro to compute the minimum value instead
> of an explicit ternary expression. This improves readability and matches
> common kernel style. Also change the return hugepage boundary expression
> by using bitmask for better clarity.
> 
> This was flagged by Coccinelle
> (misc/minmax.cocci) as an opportunity to use min().
> 
> Found by: make coccicheck MODE=report M=mm/
> No functional change intended.
> 
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Suggested-by: David Laight <david.laight.linux@gmail.com>
> Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
> ---
> changes since v1:
> - Updated boundary calculation of huge page range for better clarity.
> - No Functional changes intended.
> link to v1: https://lore.kernel.org/all/ff24b3c573b766b187b55a38497fbad0a319b9f8.1763227530.git.chandna.sahil@gmail.com/
> ---
>   mm/pagewalk.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 9f91cf85a5be..1d38763a502a 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -312,8 +312,7 @@ static int walk_pgd_range(unsigned long addr, unsigned long end,
>   static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
>   				       unsigned long end)
>   {
> -	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
> -	return boundary < end ? boundary : end;
> +	return min((addr | ~huge_page_mask(h)) + 1, end);

I know Willy suggested that, but I wonder if we could simplify that to 
something a bit easier to digest:

	return min(ALIGN(addr, huge_page_size(h)), end);

At least I can make sense of that a bit faster.

(I don't think we're interested in micro-optimizations in this code here 
in particular :) )

-- 
Cheers

David

