Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD193F4180E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 16:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37F416B0089; Mon,  9 Mar 2026 12:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329C96B008A; Mon,  9 Mar 2026 12:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22C3C6B008C; Mon,  9 Mar 2026 12:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0E69E6B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:47:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CCBAC139FE4
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:47:37 +0000 (UTC)
X-FDA: 84527105754.14.88882FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1B95A40008
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:47:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bd5kx7Iv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773074856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGJPCyJcaDVpAKGOBr5M86HiZ7UCQEGUjpLMIpJgzp8=;
	b=6ID9KmuqXElcXxULdGqGiRS2tUb1Iix+xxB1JqkZZ5g97e6rubsp7lQ19+Q7CExRWHxvUi
	+A5W2jOg6TFbtcSzmmU5OYRM3hU80W4hYZlBBzTxXKJnJ2W+mmbFGEsQ7lFz+/yjcPlu3y
	3UKW8BSS/YzyxqRPQcRF0Ea9JxXpp0U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bd5kx7Iv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773074856; a=rsa-sha256;
	cv=none;
	b=btbtgJ7xhxEcv6v10MyxNuesBaZyeHQAWIlZdKJqoXo8sESp1WmsQmC/dk9TMvLM0g4trs
	LzSqmBi/T3SQEgSTRVGsBhCxi9SGApj9D5Htuva1OGbfbbIbURjdybmTzu4d7nv3+J6sBB
	8q0VFVhg5CwDMOm2gwKu0PDDdkw7xOY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 64C4B60054;
	Mon,  9 Mar 2026 16:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C74C4CEF7;
	Mon,  9 Mar 2026 16:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773074855;
	bh=w0oBKdjbNxuaeDRrRHZ7GwNRlXTe6xkr+Bdf92ElWpM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bd5kx7IvEw+rWYIKHq3E7XvsvgDedOF54tSeaPF602OgNkrcRDTPwIvNzJQmYbDUx
	 mjfdD/dVFrI7IbeF+JtzM2opsHQI/I9hlKyO2rY1Cv7DtMJZvTaFGmCIZsddzEXx1+
	 If0adF4oyckIsmOU+HU/DjYWIDTbUR5RQQnQ8Nki5s0R4WWvf31AgP2vZlulGZAuUg
	 k4cxHmvBzTJ1lKhizo3sdWE1d/rbvLwwoBHP2OSETJQH0rWxkAP6SGGe+UqIg2zIEr
	 rhTvyc6kIDl/m1f+F2nqKsKoOuuCs9+pmONLeHAmOt79HVik66rLseCxRrFd9NP0L8
	 LAcX9dweDr9Sw==
Message-ID: <ae1bd46a-c5b6-4b74-b861-eefca84979ce@kernel.org>
Date: Mon, 9 Mar 2026 17:47:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/userfaultfd: fix hugetlb fault mutex hash
 calculation
To: Jianhui Zhou <jianhuizzzzz@gmail.com>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 Mike Kravetz <mike.kravetz@oracle.com>, SeongJae Park <sj@kernel.org>,
 Jonas Zhou <jonaszhou@zhaoxin.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
References: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
 <20260307143542.179953-1-jianhuizzzzz@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260307143542.179953-1-jianhuizzzzz@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1B95A40008
X-Stat-Signature: 3u4rib8swx3wqyuhp4zwmo7s7sn14onf
X-Rspam-User: 
X-HE-Tag: 1773074855-66708
X-HE-Meta: U2FsdGVkX1+80pcuRLmgU5wOJNv9pvLm5Sa1X6Th2ujEZs4sJLWoKeh11IXKl2EYuDDtlnBIwksj5j/gIrFen2vxzh5E26XLSv1/BnDiEQUv+4r1BTJMIKi3m8dyljIHv+k9dIqJwCpgWUauEo6ka+3KOeQ2xFDPNQrL5h+NISSfM3Sh0PQBIljW2yuNYAlxjQdrQwp8Pvd4Ftj4zZDwyTj32CbBlN6eA9ou2WHdtCZbOoYCqVb/h7CASevir6Ucwbi+cB3qRU0km86pVh2ysJg5Ea6T/EiezqxSDW2o82agjw9O4CIGScoyiufKs5vS4eqbmKvajN2MDR1Z6Q49mSoFKaMQ1uyXi5cPbT9/xmkCN5SqTzA5x0kjUDE5rrGQVedaS/Mj4DngvV0JqkYc210s1gfl4/rbiR1yZ75LFGahgSLSww6+Jv6lkiBVEkpAH/N77Gsn+LoC82gqRsu+vq+x0T6CSsRYEqz+YV2HhP6nKdEeADgrUz3iVR87UFU0yri0nJc3T8ANpeMIg9gGLpNPVSLGrt1LNH7eYGJQTNgUfJsRwfQ1+M9imN3Z6Cgm+9hHukGERT+YvFTnmclq0Ws5o/PqIYYGZqezMm6uVWmbqTlGeUy4JrTAaKhA+EZ85kXTV+k0laAqPkRQO0s/xwZmuVZt1IKOp6M6crJhgNlwYtvaxFsDQvMOND2RAEcVw63bVCOrG27fhm37EsUapKI6lNkhNzZZnAvncEcFQkW6wzCpUsUNEuFxLetrPamgJdlYx37MdkHRMwZJFCZ3/n5qePbVWSXtlHO7Bj6MOrM58uxxVv4zLColLVrS2CIJB5YNuSodSJsskJ9iHImJk+nHvNbIwn+1ZEl9XhuHqyY8SKO+9UssVZ/PktA5IC4G0SHuyNGgWT9hNBNnly6nP9+MB8HlLMR2UoIBEev+zZilEoEHWuIji+vKlH3m+VQlut4DIwdUI9fdjPGH8lO
 fOsysOSu
 kdw4ucSqPJm7d2PjhM/o2e0Om2NnM7QmMLe2zr+pWJTYRsngETyLjOtZ1JWbtdyHMWaN37xG/W+Bh9IENVYdLvTPLs66Xra95YadJTDtc0Oot5g3h6uOZU2kOJdpGxykTOu5xppViWpppsMdpc+tQzzOesKT4Mz0NN1kwufqcCPtAokdsIvoiqqVq9mEu3cH17FZqsJeN67SEpDcydw5h1tJsStVtz7zNPGa2kJo5IgUhRdy3uPIerv7Jq8fQJ6Y39Ib97yWTGCg9hmdWdozWZ+bWnfyc6LoVKN7ERIbLEWenu0gQYZbp+nwfBMGWpu8UIlAzNAgX/cU0IccQK72zSHhYQuODhE5H57E+nNleDRSDkkMkd2LhDicuZ8HzNabewztagovckNUyec/5i1RoRC0KdvxY/66Qt7O1nndtggNyGuhWwqFlEUoemN2iI5ruchFBlkgzIIAWaBxxrf8vCxaTbrjoTVT/HGPPviJDKT9tfxpqY0rI7BLTi+Z5WH6WkgSMnNhn0Yel/670PTce0FVvJEV36ergFR8iQcF/vZd5gvY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/7/26 15:35, Jianhui Zhou wrote:
> In mfill_atomic_hugetlb(), linear_page_index() is used to calculate the
> page index for hugetlb_fault_mutex_hash(). However, linear_page_index()
> returns the index in PAGE_SIZE units, while hugetlb_fault_mutex_hash()
> expects the index in huge page units (as calculated by
> vma_hugecache_offset()). This mismatch means that different addresses
> within the same huge page can produce different hash values, leading to
> the use of different mutexes for the same huge page. This can cause
> races between faulting threads, which can corrupt the reservation map
> and trigger the BUG_ON in resv_map_release().
> 
> Fix this by replacing linear_page_index() with vma_hugecache_offset()
> and applying huge_page_mask() to align the address properly. To make
> vma_hugecache_offset() available outside of mm/hugetlb.c, move it to
> include/linux/hugetlb.h as a static inline function.
> 
> Fixes: 60d4d2d2b40e ("userfaultfd: hugetlbfs: add __mcopy_atomic_hugetlb for huge page UFFDIO_COPY")
> Reported-by: syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f525fd79634858f478e7
> Cc: stable@vger.kernel.org
> Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>
> ---
> v2:
> - Remove unnecessary !CONFIG_HUGETLB_PAGE stub for vma_hugecache_offset()
>   (Peter Xu, SeongJae Park)
> 
>  include/linux/hugetlb.h | 11 +++++++++++
>  mm/hugetlb.c            | 11 -----------
>  mm/userfaultfd.c        |  5 ++++-
>  3 files changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 65910437be1c..f003afe0cc91 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -796,6 +796,17 @@ static inline unsigned huge_page_shift(struct hstate *h)
>  	return h->order + PAGE_SHIFT;
>  }
>  
> +/*
> + * Convert the address within this vma to the page offset within
> + * the mapping, huge page units here.
> + */
> +static inline pgoff_t vma_hugecache_offset(struct hstate *h,
> +		struct vm_area_struct *vma, unsigned long address)
> +{
> +	return ((address - vma->vm_start) >> huge_page_shift(h)) +
> +		(vma->vm_pgoff >> huge_page_order(h));
> +}

It's hard to put my disgust about the terminology "hugecache" into
words. Not your fault, but we should do better :)

If you're starting to use that from other MM code then hugetlb.c, please
find a better name.

Further, I wonder whether we can avoid passing in "struct hstate *h" and
simply call hstate_vma() internally.

Something like the following to mimic linear_page_index() ?

/**
 * hugetlb_linear_page_index - linear_page_index() but in hugetlb page
 *			       size granularity
 * @vma: ...
 * @address: ...
 *
 * Returns: ...
 */
static inline void hugetlb_linear_page_index(struct vm_area_struct *vma,
		unsigned long address)
{
	struct hstate *h = hstate_vma(vma);

	...
}

-- 
Cheers,

David

