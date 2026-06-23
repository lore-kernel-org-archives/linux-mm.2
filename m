Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 021F2CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 07:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B82A6B008C; Tue, 23 Jun 2026 03:40:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94FE96B0092; Tue, 23 Jun 2026 03:40:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818D06B0093; Tue, 23 Jun 2026 03:40:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 593896B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:40:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF4AE1C293A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:40:28 +0000 (UTC)
X-FDA: 84910379736.10.BA9B9AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 14D361A000D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:40:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jUN98Gg4;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782200427;
	b=57uC4Z1ceEYnlBN0rDQZkt4OnYhkh4iB0rUHDUYPcrQ+wcB8tgKTwwN1Ig7MWEa16FJr8b
	/334qlfMHIsXq7eEoAlQzceDPHxCVx5NEu2g3/KIdGJMHuB9w5McS0Y5i096tJvb53Bk66
	Umo6mEcDsDTOu7mlk//8vreMvu0bxc4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782200427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oyg6CAUUbml8XR5h/JGxf4pAB7jc3o92v0essj1CDgE=;
	b=yb9kWlaAwVTrnlj6IMNEfA+gUBzYcpQxYilAEaChUoVVPjTdimRQ6fFS+4hJvI2CAi5fHZ
	0sh54lQIIjtKX4GSzBJRjAswhyIw/96l3YZpB7AbPZIUbYJTHI48qsNMB/oLBCx17Ts/TN
	R7rgA1ZvLpM8lNbpIw7pIZ0tYnlIih8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jUN98Gg4;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94F216001D;
	Tue, 23 Jun 2026 07:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD021F000E9;
	Tue, 23 Jun 2026 07:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782200426;
	bh=Oyg6CAUUbml8XR5h/JGxf4pAB7jc3o92v0essj1CDgE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jUN98Gg43uE081ZaDsL1XvDVhQsld0vjLeEUg7umDG+BHArnaO/Wp1LMo2RR9kCfu
	 5JFe3w5OJTptAUQrxUA21japkIClK5HV9pX8p8i/R2ZAL6e/g5NDYvzJA2dfb27m+O
	 72ZtVNHBkzz15KCvCIeuttjeHxMUc030NazejjnvAbR6MRYWIdwIcDo1exNkoitS6b
	 o/88tcAYlgkdxA9fQm+ffuHbH+Pp7agP5rxGhU/tx/Ecy0/w3du5De5qC7JEGzXEeu
	 sNdqF3BNpyf+21QNZ9hD7YRKBzGAN3t2xzG5veTPmAUEnwlGuozKtel9scafqn1qgv
	 AAWqOp3Dzj/WA==
Message-ID: <76ae84e1-d8e2-43b2-972c-f6ba026c93fd@kernel.org>
Date: Tue, 23 Jun 2026 09:40:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: hugetlb: correct CONFIG_CGROUP_HUGETLB macro name in
 comment
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Pedro Falcato <pfalcato@suse.de>, Anthony Yznaga <anthony.yznaga@oracle.com>
References: <20260616000135.62815-1-enelsonmoore@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260616000135.62815-1-enelsonmoore@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 14D361A000D
X-Stat-Signature: a445i1cerqsgs3os56ceg8k8amsz1fai
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782200426-907477
X-HE-Meta: U2FsdGVkX1+u1FvHJtEafcme0pa4GDbwU9NiPK9YOC2Dld78CnUTpP6yi7PPi99aoDknn2CJBs7JfaDagCP7VItuadO2nqRguiUeaFSfC68qbm+Giyk4IzUTbytRpV0iwxM9Q5k46PUrrW/T3n5mns4cjaafCzzvZ/eYkeTUz3U3qJQzBxLcJfYlOk1vkj2H4Vj9V1NR8bFpixB2pqR1k6yLxBpRiiHGVHu1R9vgk91j8VE6cXmEH2sLVPyUaaBIS8K5QQCkwc3YT/nA74BQPMta1d+5V5NgnHnx9RX4fheqxW8HRQpXTUCN3dboNYsHpR7KRMvUSuoO1X0B/fqvsUCJViIAeeP7c8xR9ILUBvdC9y4WzdhL7zneM5oPsg0KcZNCvSkf1Lw+8WqSKyn0kn3bxTE7z5qIU8LsO86Pr8+j7SZvNA5wUM3m/6/vbwiE+m8T01eI9gG34mGS5g5qpZgbcSzmFNck47VbpVCJhLC/NQ3sWm9eI6MheXgyy3esEQqe4oQIjC2RzAYQVxLcYtMo4kV8LcNVcgfp1bkfBnKUoI3E5JDAAWXxJYMXHBC72lgXV324iEB18QKJNbZvvz2/3AnA1xVwNuudPHH0ppu2E3IpE0b3js9mmI0jYT4+0cRqi2HAeGIZpIH0fMpHsVPI/DBteSJ4m5NmtSGNe4gilkw1HAeZnvz1wEh4oTqktJwyU6MnDw6gADVW/oUDfvjpDBeEl9k50vcSGyjGng0MERQjRfFAyxod0dzdV3aaomPMfoZs00Lh3JWk0OnWlR6K4HcMbo/8QMGDAewkbY13w2sEhm6yOS75IOHIMpxZjnRbun3lwMtMf/QR7offXgt9lLHezvnEA4iINgqLh9CXtqPpgCGo4xWpM9rtof8tzLFSrELJYSRNaTj6QukRkBQuztpl11WF1aeJP+2yyM/N3pgx3MKQnVRcJgs6sIFK9xzhurWbsoci4rKA0Zt
 gP8ic5jM
 gk3mA2la/UhwKN8w2k4CMw+FSGOldoWQ3r8+4cEDOANXuF+3ASBkPdb/RnGhVonq396Oatdnkl/v+OkxLINlr1vJiirROMny1ISXnnuS+G+aJWSgEGfk2mc1KC+/XuOQQLnmxj0BnUKda1jIEglto4ggP2R75ThTc1fIr4GeLvf+n+5GXpz1nWWK6sRv2wEFOOZYWP/aBCrBZW9D/VXvotKuc2MPAhamO2iLrgqa5rsE2fLe6IUgSelAQ42U3isq5gjaPh9pzJBi1GQ63uwp8nE7it+F8KRh2G4XovMRCYqoopN1Fv+qvnUj+7aMLPU/Dmk+OAEzFePbJwMnke6FKocHeXCyrYKqcLqJk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/16/26 02:01, Ethan Nelson-Moore wrote:
> A comment in <linux/hugetlb_cgroup.h> incorrectly refers to
> CONFIG_MEM_RES_CTLR_HUGETLB, which has never existed in the kernel,
> instead of CONFIG_CGROUP_HUGETLB. Correct it.
> 
> Discovered while searching for CONFIG_* symbols referenced in code but
> not defined in any Kconfig file.
> 
> Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
> ---
>  include/linux/hugetlb_cgroup.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
> index e5d64b8b59c2..16d72c8c71f6 100644
> --- a/include/linux/hugetlb_cgroup.h
> +++ b/include/linux/hugetlb_cgroup.h
> @@ -267,5 +267,5 @@ static inline void hugetlb_cgroup_migrate(struct folio *old_folio,
>  {
>  }
>  
> -#endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
> +#endif  /* CONFIG_CGROUP_HUGETLB */
>  #endif

Right, commit 2bc64a204697 ("mm/hugetlb: add new HugeTLB cgroup") introduced
that. Probably a leftover after reworks.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

