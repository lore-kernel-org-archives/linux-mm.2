Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA837FA0C46
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 08:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28EF66B0092; Wed, 15 Apr 2026 04:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23F916B0093; Wed, 15 Apr 2026 04:47:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E5F6B0095; Wed, 15 Apr 2026 04:47:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F316D6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:47:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 881CF590BB
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:47:09 +0000 (UTC)
X-FDA: 84660160578.18.BB85CBE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9FB1816000B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:47:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hINMi0D4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776242827; a=rsa-sha256;
	cv=none;
	b=Duhn93a7Yym7R7FjE8dNuiSSs0xiYj+ULgtXoIs+BcS5jPPcsKVdfudv5Rqg4ErdW6Vjh4
	/SpGGfnpoXyEtLJnU/RmjKCYnP87ZJV8fhXi3diFcPRH1ydwQnv55GCpdu8H3yO9y7qu7g
	j0HE5o6D+zGjCExETtTWjbEgHKoeGNk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hINMi0D4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776242827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FQYiK8Me1q7A+UmC6hjJJzfoaqa3mXyQbISXjSBwrK0=;
	b=4UAjSH/3suxP/NhCknf6JyrD26XvxPxiT0bqvUFlUtRxIxR7sUJOOQtkG9mO+QWHs2VliI
	GvfUPdLZQ6ka8wIvgXR0V0bhoYdnF34PNiU9+UV83j38EWbKW4Vi6z64U8MBOGRCJzyqEh
	9gXoxgRHROavQVxetpHjjm8W+mw4A1E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46F8D41A70;
	Wed, 15 Apr 2026 08:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D5DC19424;
	Wed, 15 Apr 2026 08:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776242826;
	bh=YSYR/Ui/7QGCekywXf7bwFmRwPsJlsugZ+u5yIbM8+0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hINMi0D4FSTabBL82Z9bpaM7m8YRIafA7NzBoGo3uNQ8bli5dovabMELHuqbgX//n
	 LEWdP5HdyZdwuuCcnHZqQnJ4cUooHstTvO24Tm4ydwqm47R7T9ljIx+OHQyvagbxTV
	 UCzdW8aaSlPDtOwgbjfSA9SGeSyL4LH610VxllackL0IoQK2HVwxVR9ys1USFeKUzj
	 KfpVcWO+ch4/G8XymgkgOTjsBi92rYmS3CpuhN+T+AxOzVF3HG4up6vBfjjPmiQjvs
	 heAyxusbbvriJ2hh6BLBifUpLycwI1dP11fqvz0pimrJWGWaVO6ILRpqhaYmhmuijF
	 rUVn+xAVvU8KQ==
Message-ID: <c5d0643f-1850-47a2-87ac-a249b2463bb4@kernel.org>
Date: Wed, 15 Apr 2026 10:47:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: shmem: don't set large-order range for internal
 shmem mount
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9FB1816000B
X-Stat-Signature: 9r581nraqrx6fx1jhijn3um7uh5k94qb
X-HE-Tag: 1776242827-925827
X-HE-Meta: U2FsdGVkX18WXCJnx+3V06K3p2OViG/JayoURcfP1sBRmzDXXyiucHVYt3qz8O1W+cUSWuTDUVGdLjmPy353DrhHOlRfSg57Fw7M/bcvJ5c4a1KPrN1UfzInf0vZRvCZy0eh9fVMk6FhatBwjhyjMK2XD1ZFXPiQYw6JC5RTAmJmxdZjqKeq5Od+Xppy0xznlKdrJG7uqXLY8n9TEeMLEBcKH+IvYwQUvQtRVMFHIk7JLt7IacEigyudUv0b9OMB28LkjChDNPtqnEHfebV86U96XHLUgU8qsd+YOtB3TYDbX2t+FUbCOcahh0gpfUfqPbILJFZR/4nYaxuTxpVuMIogPGBR0+dbO+7rNkt6mAbNI1shdKfAH+zsaD0dsSOD+TRpv8+oIQU/ftzNPqnfLg9BM2nCEffx0Z132jqtHGk//QdwIgRy4+//Xgm/0O7FcaJ5+BLo7TdY8XUgn0h+RGdvu3C4KkgMKjNeYP0RlVxwOrG07mu4ER47It8JVk0cBLYWXYttD2jr3SEzghv0BDXNdZRp4t9XSCx25A3derqwdPDWzrmvcIhswGD97rFQRluOKbFAO53PhmHVIOizLVHX4CfNJ11CvwJPGfEId/xi6/4oM4l5n9VPPlsm2o3+UKsh4NusPYkQfVvc2SMugNTMne8zLNwKb9fWSOxhovn+qSNJdCHI7ZUGKS2TieKHmKFujNoR1eT18quz+3VKpPR2UT4H4TlS4edgNVqK7SzgmTJwUOUsyIB+2N4OKMn9jvR9PFmfrXOGF47SdDuNH6mDYk8R53iIRPjdSJ9iUIk22pyDb6IDtGgUwSKWIg19u9hJS/XSqWmyLlkVNChFJZ5S2oS3RuNgoAKOySa6u0kOx/UjfnLO69nc2tVxiWKz3Gtn4OCO1Cqs7URrndL2KYGPEB5TxQRqvISpcLC/LTHLelerecP1ReznEMv8MrnS/VchDpnFx8gD43JLNnC
 M6sWjF/Y
 ApnHIuog5CKR5vMYNPVLy/2UGFqHc1aAX/sWDGXlkfwkuUDk9G12g48GyoWRga5L+n24q1YQPRS+5tMd6S0RcrNxdzbGrxv4iZmwfvNEKPKoZ11l5ndFmv/3qqFsoUsesrRZXgMZOSWvyfkIna7sjB1fryBYt0ijC8Eumv/gGFyVWfU5A0z/KyUjT5+JUGi0OEVxG1opEaiRXoFkKHaMjXkrssyMzVTGis2wDFQgAiZcF9FuE3EYVIDsN32uw4F1BQMdbli2lbr4H8BqibT0heX+3ethlEi7Cq5rC6bcBSS6Y6gQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/26 10:22, Baolin Wang wrote:
> Anonymous shmem large order allocations are dynamically controlled via the
> global THP sysfs knob (/sys/kernel/mm/transparent_hugepage/shmem_enabled)
> and the per-size mTHP knobs (/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/shmem_enabled).
> 
> Therefore, anonymous shmem uses shmem_allowable_huge_orders() to check
> which large orders are allowed, rather than relying on mapping_max_folio_order().
> Moreover, mapping_max_folio_order() is intended to control large order
> allocations only for tmpfs mounts. Clarify this by not setting a large-order
> range for internal shmem mount (e.g. anonymous shmem), to avoid confusion,
> as discussed in the previous thread[1].
> 
> [1] https://lore.kernel.org/all/ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Changes from v1:
>  - Update the comments and commit message, per Lance.
> ---
>  mm/shmem.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 4ecefe02881d..568e1baee90d 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3088,8 +3088,16 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
>  	if (sbinfo->noswap)
>  		mapping_set_unevictable(inode->i_mapping);
>  
> -	/* Don't consider 'deny' for emergencies and 'force' for testing */
> -	if (sbinfo->huge)
> +	/*
> +	 * Only set the large order range for tmpfs mounts. The large order
> +	 * selection for the internal shmem mount is configured dynamically
> +	 * via the 'shmem_enabled' interfaces, so there is no need to set a
> +	 * large order range for the internal shmem mount's mapping.
> +	 *
> +	 * Note: Don't consider 'deny' for emergencies and 'force' for
> +	 * testing.
> +	 */
> +	if (sbinfo->huge && !(sb->s_flags & SB_KERNMOUNT))
>  		mapping_set_large_folios(inode->i_mapping);

I don't like that special casing. In an ideal world, any mapping that
supports large folios would indicate that.

Now, which large folios to allocate is a different question.

What's the problem with indicating for all shmem mappings that support
large folios that support, but handling *which* folio sizes to allocate
elsewhere?

-- 
Cheers,

David

