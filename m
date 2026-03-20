Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2965F108B91C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 12:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692F96B0089; Fri, 20 Mar 2026 08:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 669FE6B008A; Fri, 20 Mar 2026 08:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5804C6B008C; Fri, 20 Mar 2026 08:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4902F6B0089
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:43:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC2F214015E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:43:12 +0000 (UTC)
X-FDA: 84566406624.20.A2AED2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0B1D61C0007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:43:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MbsJYEaf;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774010591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/FRuC1ooTniKyZ4t9QIby2phm8SpZXS4nkl6+MWe55w=;
	b=gqFetCjDAMeBf/prdTVKPsLOvNllH8dfR7x2BW82r9rdjkHuO3JY2vLvF1Mhbv3Vx7U/fV
	6Ad8Dg3Q+QFh1c3diXvOYGQyb+GAi//9VfXGqyOO742W7K5EMtE5Flr1rKJLynuP40DKNh
	JFU3kE5MhhvDK7ZyvEjbwbH7DJoJkJU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MbsJYEaf;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774010591; a=rsa-sha256;
	cv=none;
	b=bSAFPQOLKL0LZReNfprelAyWupdGv9nqd84xiZR5eEf08WUq2+Q8E6vU6fxpTOOrwR/IxY
	HsAVVhMQoPJ1Ee8/8oB2MHaW3g5O7EwVX3yKvyLMUl0xWG9SVRYHeUDXhiZs+qyZBPLIQt
	M/iwXpXMNJUvWVEempJl2PI+KX2iBCE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 23F4543982;
	Fri, 20 Mar 2026 12:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC3AC4CEF7;
	Fri, 20 Mar 2026 12:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774010590;
	bh=9e/Btx0YFRFKC21pnkUbnvkuOGkqidzpB8uwJ5aHo+M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MbsJYEafGQcgi0CIm/IhXRs1E/dRqUnHQhLQWI8uSPNo7vXEpMEx7VMeMbSwSfoPr
	 we+RH7A5Fl5UmaVGz6iFvCuLb4PUlkj2/imsRa6vbCLbYQU6K5WBaHs4S04jHvzFIx
	 8KtAZe08vXmsD5w58I+HJUYroTiWysNql/QMxXFQ+t4zZ5l2pKnDCcLUOVEZCZ90CU
	 FiAlZzjmR8YSbQ+VtSsKOIJznigfEaVak4nOY0FPz4lN6+ZWhoLm61NBKcoeaGottG
	 YRLdcOEkgELJyW+tgap2s+pHmaixBlAkktovvtBf4B9p1LK1V6+cqKWlDkDHkT4Uwc
	 uoF3OisVCUc5w==
Message-ID: <cf190f78-3f5f-499a-aa78-35261850b01a@kernel.org>
Date: Fri, 20 Mar 2026 13:43:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/15] userfaultfd: introduce struct mfill_state
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, James Houghton <jthoughton@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Nikita Kalyazin <kalyazin@amazon.com>, Oscar Salvador <osalvador@suse.de>,
 Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260306171815.3160826-1-rppt@kernel.org>
 <20260306171815.3160826-3-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260306171815.3160826-3-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0B1D61C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: h8bkzz8jbuupaqtts4gxeq48ni9buuuo
X-Rspam-User: 
X-HE-Tag: 1774010590-857591
X-HE-Meta: U2FsdGVkX1/Gf4jdYkyYebJWWpxk4lIU6Fk1sAEDMW8HGp4Lm3YRD20Vu/jMQTR4NJiju9LTkkM/9tacWgamhsSOX5Kqk4F1f5yGeHKaoWbU9N1ChEZAMonUF36tCARw5+Lk9sMgpCQ4xS0SvXh11y7Rc2WYKCB/Jvs2DgJ1vrwnXqhDCJi5pdMobUbix9j1ahNgyBDL6wGd9BYFhg3Pw4/1i9XW/fDL5EDyJlG/G+X3KeTbYtoIWR1gyptn2Cbtb/QNPrZ2enK/gvwisrh8+hhvNHsq9E0Q+TbQxPQdDijDRfydpw+wMhayW+pDQjG4OJrqsXIUrJkXJz4GPSczfmoe6tUS0A0hN5QhB78h4fXhybX3bDv1mhGox0DiTTrrnDJHGch/YXM1cSd019sLfiqpk/QUSOyeLcOuqK6zmAqi1OJ9qrUuGcCZIh/3Kq7aqWiF6NNKAaZqUKFY0KfowlDPwH7H7gsh/RFHYHYN2nLFRL/957UlKLUrR6LXhkFEaeM5Q1vqOt4lQy/llAvD5IY0fFHBta/boORUEJ4BFwa6B8QnsKMIULUkZJAowu8dlbpKS7MEPpr7TN0+svgHp2YeaPCDBiqSYLOlbsbruMUYXs3kCjEkRqrFGvn3aICAtDyePNmtGJTIqqFfCqdc5yv4T5MakQGIgyZ5RMXp5T/ecctn1ejOlsK7lh0fW66E7If+vInizY7vOjUtX5oiXCtWHdUDKyDjmlDL3lJ0M14dtIw+8dgevRKw1AQ0jttUWEunmCDu7z8pUopVxz9354zqIncHlux9rRpwgS6ZDqnCf6CqOrHr8rS78S70MVVdJnwV1P4NxQQc4oQTWBr3PtDOcA6j9ZdQKwmQw+8r5VL1xrMD+3SqHzyHtdeq5XLFr8nRp+bCA2i4LtYmdj6rly/BzZXD+22oe80A8GCvyXjpHKtIzDTr5G3kZdNHrnScl7KPsTUBQgYjIyxjlqN
 MaQewHkr
 t9kNbYlaTFdqp53oXQdAtqaDC7SSYsrW4euWDVGYaMHrJRHUs50vKfyyajdtGBKi14t3kQJSxxF6g4tlLrTb2J04OVikNfeDo+7cCKmwUziRiDRjHjaOTawnKc4YCe9hIByCKBcrj1v0MRO9H+Lrn1QKvJI2US8JPpqYQ3kWtDE3f0ugVYGhpOd49LLBLDTi4uUzw2thO27/3tqeZEDQpG47Gzb6CdkhJpOXYWEfhWXpQpvyd5ZGqO5kGrat0/yaTUbvWxzzdhIka6k9w/R4pnmBDnMkoc1kzQGqVR5j5TM56OwYpm7aHlGa7pnQaxykz7L6NznP50PiLWA8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 18:18, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> mfill_atomic() passes a lot of parameters down to its callees.
> 
> Aggregate them all into mfill_state structure and pass this structure to
> functions that implement various UFFDIO_ commands.
> 
> Tracking the state in a structure will allow moving the code that retries
> copying of data for UFFDIO_COPY into mfill_atomic_pte_copy() and make the
> loop in mfill_atomic() identical for all UFFDIO operations on PTE-mapped
> memory.
> 
> The mfill_state definition is deliberately local to mm/userfaultfd.c, hence
> shmem_mfill_atomic_pte() is not updated.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

[...]

>  			if (fatal_signal_pending(current))
> @@ -866,10 +882,10 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
>  
>  out_unlock:
>  	up_read(&ctx->map_changing_lock);
> -	uffd_mfill_unlock(dst_vma);
> +	uffd_mfill_unlock(state.vma);
>  out:
> -	if (folio)
> -		folio_put(folio);
> +	if (state.folio)
> +		folio_put(state.folio);
>  	VM_WARN_ON_ONCE(copied < 0);
>  	VM_WARN_ON_ONCE(err > 0);
>  	VM_WARN_ON_ONCE(!copied && !err);

I guess, "copied" could be easily avoided by
comparing state.src_addr with start_addr.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

