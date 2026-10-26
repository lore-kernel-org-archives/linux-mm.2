Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76D23606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hwhsj8kN
Received: by kanga.kvack.org (Postfix)
	id 838406B05B2; Mon, 26 Oct 2026 17:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C1DA6B05B4; Mon, 26 Oct 2026 17:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 662D56B05B7; Mon, 26 Oct 2026 17:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2CF6B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:08:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6BF9B1608D3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:08:31 +0000 (UTC)
X-FDA: 85366016022.28.ECFD6E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id AE11440005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:08:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hwhsj8kN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793048909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZY6emueEsceME7nXNq6gUfKhqrQcT2cFezDIABkUGw=;
	b=O+sehghO3LGc9jHifgmptWHHQqZhF6UHC91aSo71FaKdezh9OSr/3zDlmhu5lauYwhKf0z
	92ZjpxMOpHDSV+yKi0CyxYkjCm+LZiiT3HdHSczNsGrnkeaVM5LSZCbtHRdvQ5n8HqOn1+
	qleHs74Pby+JpvRsconkiQunEL+2Q7U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hwhsj8kN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793048909;
	b=cv7NnHMuqeC4jnPNNZoro37ke9YfREbk6pJbcDFtiDUs3R5jwRDUTz/QRqtLP1ep7hVUQk
	jMkkqxSRwk1gae2pxKArDhZNbeNNDlSv38n+d5Y4wO+sRgp//3HW+gwJ7sdTWqVttB1kDp
	9U2WzgRxnCwJbKjXkutXxq7g6uWhCVA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3871F601EF;
	Mon, 26 Oct 2026 21:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4DF1F01828;
	Mon, 26 Oct 2026 21:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793048908;
	bh=aZY6emueEsceME7nXNq6gUfKhqrQcT2cFezDIABkUGw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Hwhsj8kNM/003xoVUCIY6kkGhTMwCG7vilt/Dph6Rs2EcwYc9BgMFYtM3gSdCLUv4
	 I+tMEzKtq5KAbamFFvZx7+ti1rXjRJsMZjvz0qerVCMxXjC93hhuyyMUiLAmtzc1/W
	 LR4Z/+Pq0jLyAo39zmyDSxqVjNIeiDuZTxpYCVfdxa8mhWwNuCyhOz1ppbvUAknygE
	 3GYifpJYvEc3MVOEyQZ5/oL5Xo0WCWkoroRzPUaoRpTDIFj7D2vLbekCufU0BWV8ka
	 oeA1q6H6o0L+DLOpROZC2NULQUuPdxHZ3YYT75nxwHQAPF+Dr37k+z7MxY7tkjCqzh
	 wc8fUODq2yO1Q==
Message-ID: <5d441cff-ef78-4bdf-b727-9eb697ca7478@kernel.org>
Date: Mon, 26 Oct 2026 22:08:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hugetlbfs: enforce F_SEAL_EXEC on chmod
To: Samiullah Khawaja <skhawaja@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Jeff Xu <jeffxu@google.com>, Daniel Verkamp <dverkamp@chromium.org>,
 David Matlack <dmatlack@google.com>, Pasha Tatashin <tatashin@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261026205555.2918396-1-skhawaja@google.com>
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
In-Reply-To: <20261026205555.2918396-1-skhawaja@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AE11440005
X-Rspam-User: 
X-Stat-Signature: fznuhb4qufky1wh9gmu7ng7qnrt67o7b
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793048909-188489
X-HE-Meta: U2FsdGVkX1+LjZr80Sr2jTjBS8WLxTuWjf+q6q2xDb6mQd/dBgNH/u/rGeS6ALKzJ2ePtMAulVx1jAWZIepC2iNZB8KpM34odVv8uTf0hNPe+h8c+NoqTvG9FohP7aAqiePeBSwZUxXTqnQeW9h5zzOVxwAHhHp4HYshgTxp+AR2H+EKibStXGPxfaMe8qKvhKmecPXLfn4j402tJ0CMDOR92iFTN68MzDn9QF3R/AcHb+eP1nZFJfZIpj6kuodiaqrlVB2br99anEhGP/d0nRn6bzHDRT6CS+rtsTxxqpS5sz8yjubeq+H3g0Pt8xQAwo58NClB8ZH62FoV+ZOxBpwWqccVFuv4APi7NRXiE5bGtQGm/uhvG+VesiRea3OWbze7FZsq3zfOKx6Qs2h4r4A/e7JWbVVuHuuChgRdtY+iDn1Pp72+46qkcxq7Lue1CynvAIV/wQT/5suXbE7p6xyhfqiYkCrcLuOSjwytr+9GWuE0CjWB+3dmze4En1bYpXpr9tNiH4eDx51AD0Jf72RkTFv1vnBg1jZyBKnORkr42aB2YbT0Fc4rFlRzQ5w56BTOsnsT5KXt4cgW/4q2orJBhZ3bwuAPIQyiyAxd7J3ccqlcXsMcBDQPjosuQDqHzYojR5xKgT8qWEkkZ4k2ytalsGnxWI6udhApFODlwbZAHlimA9uTxN+HdPGK8DVTlKANLo5UfLIRmD+UdGqqnHp9DFbpjOdDrhbFAx+gzEeDQlBKX5wEOxEiWMfkPzPJQV3QsHct4kkojRGir1kfG/AqFBeCSIv+0EytuExlQ7Cw14KjFs7KmgT3f4i6HWLW5o72207eSzxwLbv7U1DtGN2ZP9AocKWNSz0+r8t0xZjUh2KI2fG5uPAqbOP/2UNQKFYCa2fK8JIEyELoHKr5MZeAwvrxinn9TcgyTtXqYTHL1BMw0Xfh9BS5tpFwo7ZkdfmIBtE0e4EKorBxhfU
 khHjknjm
 FSBPuDyuL5r6o4lzgKEjzDaWinuwLYz4CZhNmOP7HD9ZZuuY3RnOwqtu4MHNX+QixeLfKDomnMxbjseyxt3C5CLWgM6dloUhhZzus6YWcgHOwO4dy8s1dwbZdzR9SDRmQv6ULprkaGHmWyAi+jKqITT2ghRCyzngGEONgXTEDUR1+rr2AmT/lMfcJzQgyxlj8lstIgqAdj8ANwkli65TtmoPlLBHRt8QGaT+qfjGrHxdcbLSm9bhlXnSv3+0vcYYa3jk60ZmuhQbIy8yaYx7YcXMrI16j6lYBqkb5mm3c4mgbcxYfW32ltjxrFl2iiv8sj40jGnwnXoBsmhZuXIwNm/LpRPM9fZQ2N39F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 21:55, Samiullah Khawaja wrote:
> F_SEAL_EXEC prevents the exec bits of a memfd from being changed once
> the seal has been set. F_SEAL_EXEC is included in F_ALL_SEALS, so
> userspace can set it with F_ADD_SEALS on hugetlbfs memfds just like on
> shmem memfds, and F_GET_SEALS then reports it as set. However, the check
> that rejects the mode change was only added to shmem_setattr().
> hugetlbfs_setattr() never looks at the seal, so the owner of a sealed
> hugetlbfs memfd can still make it executable with chmod(). For the same
> reason, MFD_NOEXEC_SEAL provides no guarantee when it is combined with
> MFD_HUGETLB.
> 
> The memfd selftest already covers this, but only the shmem run passes.
> When run as "memfd_test hugetlbfs", the test aborts in SEAL-EXEC because
> fchmod() succeeds on a sealed file, and none of the remaining tests are
> executed.
> 
> Add the same check to hugetlbfs_setattr() that shmem_setattr() has, so
> that a mode change touching the exec bits fails with -EPERM while
> F_SEAL_EXEC is set.
> 
> Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
> Cc: stable@vger.kernel.org
> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
> ---
>  fs/hugetlbfs/inode.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 01c4d6f44ebe..56e0588d295d 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -842,6 +842,10 @@ static int hugetlbfs_setattr(const struct mnt_idmap *idmap,
>  
>  	trace_hugetlbfs_setattr(inode, dentry, attr);
>  
> +	if ((info->seals & F_SEAL_EXEC) && (ia_valid & ATTR_MODE) &&
> +	    ((inode->i_mode ^ attr->ia_mode) & 0111))
> +		return -EPERM;
> +
>  	if (ia_valid & ATTR_SIZE) {
>  		loff_t oldsize = inode->i_size;
>  		loff_t newsize = attr->ia_size;
> 
> base-commit: f1ac44c32cba88ad65dcecd4a279661d14e93651

https://lore.kernel.org/r/20261026-fixes_shmem-v1-5-703206d5fa0c@kernel.org

-- 
Cheers,

David

