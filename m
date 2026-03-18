Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD5B2103E173
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 13:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E1A66B01FE; Wed, 18 Mar 2026 09:29:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B89E6B0200; Wed, 18 Mar 2026 09:29:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F6506B0201; Wed, 18 Mar 2026 09:29:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF38B6B01FE
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:29:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9442DBB07D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:29:12 +0000 (UTC)
X-FDA: 84559264944.10.228E0F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C0DD020008
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:29:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QM8LHZaY;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773840550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kogbB/8tAsq+sYJ+vWAJ2Fk4lfQj+9D3IP+7QXn8wlQ=;
	b=A6YCp33o3gZ4s0Uiledjqs64u1nDJl3GgCIrcnm9ulGHgyP/zK3vRjjRsOUjd0ovFFyKVm
	u4YNJ1/G0X5CxsfGr9Mj/S/GlWuvVOvWds8/Qn4KvUBK3lPVDJ5f31Q2IK8PTKXg4UuEyL
	rVqDjNR30ul51AGPoGx1yDabqtPsPXI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QM8LHZaY;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773840550; a=rsa-sha256;
	cv=none;
	b=1KKRe6Jw8fTarycXIi09ixh5Srh6cnHvgYkYW23607dyKCO72j7XSpQ1uHHqYl5B0UibFJ
	aYeRlSxnHP0pv+r9SxnJ3MdqKWXS3svJ/8sssN81HnJJ5CVnsvOdJvspoeTsCRZDwPcCGA
	yYiKVehnzYiTE0QW6lZ5IauAh/mzpx0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DFC640688;
	Wed, 18 Mar 2026 13:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B4AC19421;
	Wed, 18 Mar 2026 13:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773840549;
	bh=laWeUr6lgGK+Rk6Mc1+rANAvR/Y/XEHDielWETb3IvY=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=QM8LHZaY1JS5ior7T24ylVC+SfrKbaRRr9RndQJ/GaeqA86du7OIy4nn5rz/XdKVg
	 oK7ELaw5x/ekqMbVtLDN70088oycqLIlgoAeLI0JsvQrcMiIcpWiGR7baN/UHNw5fF
	 IQMcloccssqd1jFxs/QA0pV2dnvknoHWQ4f/dIzPf42MATTRIEuU3o3P9NsNpeh7VF
	 YAG6wfZSl7TeDCqsmsgi7L++qVMWtadq6saRkflfAaZNASWay3nz0WHl1fOaDWx3mW
	 w9ntK3Ds7QJMGt+4QU94UkS5KC6u1U52bwCHQg1P3cLSxxssLpPsQy7myDZic7GliK
	 I5dBnLxbAt/7g==
Message-ID: <63f4a898-5f12-4496-89a5-f7e8df1227ef@kernel.org>
Date: Wed, 18 Mar 2026 14:29:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH mm-hotfixes] mm/rmap: clear vma->anon_vma on error
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
 Sasha Levin <sashal@kernel.org>, Jiakai Xu <jiakaipeanut@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260318122632.63404-1-ljs@kernel.org>
In-Reply-To: <20260318122632.63404-1-ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C0DD020008
X-Rspamd-Server: rspam07
X-Stat-Signature: 7nat5y8xja94wmiqe6omdudpnyjoj8rs
X-Rspam-User: 
X-HE-Tag: 1773840550-171010
X-HE-Meta: U2FsdGVkX19ORelv1DP8KuTJn6eBnDh5ArPoL2l4LkrnLGVHjF8fP7gozlZ8W8lBcFhGx5MQt+DesS7cj/xLh7PfFTqCNQbgfgfbgqdXFVDU5ySoO3mGwH/OBXqcu1+Ttlw2z7mS/Y3zlIIr+mVmdEqwNwR2uW/+dVku2mYOdXLvV5R/UWLSpw8Q+fAXZG65aXHDH0b4LkZysVMbLN+HWBeaSpgZ/iLUyqvYYk6T30Li47iF5eZieQAtkEsDyQoqp1J15MQS7Fp/5i0vkWLNdy7qTf8bzuGJ/udAB1cBhIYxWJfxQ1LiZRbwzU/hiPae2kL5/IJeSYgE3e16lWnU/Xr9X749e7WqMa2GmW32d8gJh54gBmIej4fxnvCcNzgKCjLyubGgdKdGBfasotaoeeOcy01ZO/68mdy0vlMI3Vs6rOSyk5cwbE5gdTgZ9fM0oaiVMWgc9MRmwCTq86SZHN3Hq3wlUZnLp08KpUPKLYmVCaL19bs8zpouL+uoNA30n1CWOih+5WXT2Fgne42NWmTYA4eB+UHBG+zb9awTExWq7c+h1v8splnffHVcI07kjHXnHI6382UjIOobA5LDBVg8fkCzYbP+nXfat7QizcEk3bdwkrhp/TKmrpDkPg84XeASsmSnVjh1lFyEyoPNOWsQo0eqoLoXn4cK8/0tZsGK3UgKpw+KpcuWu2GHyXiFVKDThQwSjul5FHK/NQvlv0J8yL4AhXdscMlEGRHSfYSu3wUIK6d4+kDmeNgK16osBCvEBawz4gsl5tng5ZQhJecX6z7GZjSCvyWE+gADymlbzCkIsJFhSSl1jbmT3QZTEAHeZgiV0IXVRHklYQmq+C4EuXn0CU50CTGGTnhzgALOeyKX5k864EoSXVothSHk05dGB4Xi16LCzjsKr0ASDVjaEy1Z1v1DmYATcF/AwQfglAFrJkY4Ubokey5CE6rthLSadCttYnlAMWrP4Yu
 qFSLM7wz
 5i6j57f4qOCUJOCu/1TuGNpO+3Pj+LVGZT7ISvDuPRB9Nq0hG+lUPsN7T4Rl4q1cupI97KCJ1RrqSkfFZNY4zSRx6oE0s3+2infrjOM4hwJIlo8dM4T+A5qhY5uxZKFiGfGp2xT9mGRp/U8qGYEUb8mO9HcptYgFoUsjPir567G3HTKrfxxAjsEA2XDV51+4XHBvq/eZ4PvgbfFvYcQv0em3zcvm2o9dUOIvhebyIq2Eu7r8yzaCC0A2FXsfFRqErSmc5U3HPRWtXU4TcBnKU0UrmLrFrHMmidQpExM7Aysi+qkDNLI6ER7dQvTHhYOaWK+ul7S05+28BP1rJIBYrZPjawX+YkeUuQcH/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 13:26, Lorenzo Stoakes (Oracle) wrote:
> Commit 542eda1a8329 ("mm/rmap: improve anon_vma_clone(), unlink_anon_vmas()
> comments, add asserts") alters the way errors are handled, but overlooked
> one important aspect of clean up.
> 
> When a VMA encounters an error state in anon_vma_clone() (that is, on
> attempted allocation of anon_vma_chain objects), it cleans up partially
> established state in cleanup_partial_anon_vmas(), before returning an
> error.
> 
> However, this occurs prior to anon_vma->num_active_vmas being incremented,
> and it also fails to clear the VMA's vma->anon_vma field, which remains in
> place.
> 
> This is immediately an inconsistent state, because
> anon_vma->num_active_vmas is supposed to track the number of VMAs whose
> vma->anon_vma field references that anon_vma, and now that count is
> off-by-negative-1 for each VMA for which this error state has occurred.
> 
> When VMAs are unlinked from this anon_vma, unlink_anon_vmas() will
> eventually underflow anon_vma->num_active_vmas, which will trigger a
> warning.
> 
> This will always eventually happen, as we unlink anon_vma's at process
> teardown.
> 
> It could also cause maybe_reuse_anon_vma() to incorrectly permit the reuse
> of an anon_vma which has active VMAs attached, which will lead to a
> persistently invalid state.
> 
> The solution is to clear the VMA's anon_vma field when we clean up partial
> state, as the fact we are doing so indicates clearly that the VMA is not
> correctly integrated into the anon_vma tree and thus this field is invalid.
> 
> Reported-by: Sasha Levin <sashal@kernel.org>
> Closes: https://lore.kernel.org/linux-mm/20260302151547.2389070-1-sashal@kernel.org/
> Reported-by: Jiakai Xu <jiakaipeanut@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/CAFb8wJvRhatRD-9DVmr5v5pixTMPEr3UKjYBJjCd09OfH55CKg@mail.gmail.com/
> Fixes: 542eda1a8329 ("mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add asserts")
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

> ---
>  mm/rmap.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 6398d7eef393..abe4712a220c 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -457,6 +457,13 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
>  		list_del(&avc->same_vma);
>  		anon_vma_chain_free(avc);
>  	}
> +
> +	/*
> +	 * The anon_vma assigned to this VMA is no longer valid, as we were not
> +	 * able to correctly clone AVC state. Avoid inconsistent anon_vma tree
> +	 * state by resetting.
> +	 */
> +	vma->anon_vma = NULL;
>  }
> 
>  /**
> --
> 2.53.0


