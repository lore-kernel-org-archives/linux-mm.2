Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D65F5606A32F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 20:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=onx2Fe3/
Received: by kanga.kvack.org (Postfix)
	id DA9B56B05B0; Fri,  6 Nov 2026 15:31:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5AFA6B05B1; Fri,  6 Nov 2026 15:31:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C48F56B05B2; Fri,  6 Nov 2026 15:31:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 895E76B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:31:52 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2255140155
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:31:51 +0000 (UTC)
X-FDA: 85405840422.08.64F7E40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2655B40008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:31:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="onx2Fe3/";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793997110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xq9yFMohso02mTNk00VqD923K83qztQ5KJV4mLYhzhs=;
	b=7AYWJZHFZDPn+x4gx3CH1TDilmjQJExFWdTLancSPrKdPE2fUf8sbMR6sBnLTdFMlE4QBs
	hpj6yoaubUojoKjtLorGDIJoq/iLfnd9sQXFhUv2/Hb3MoIJ5x23d+HY4KcY6tZGPDRDay
	t+f26nqUmp/y5tt5fBHHB6QkB4MudhY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="onx2Fe3/";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793997110;
	b=52uLPOXaLhTIW8Y00aU76EmvhxLxVeJLXEFKsUF6UMjQw0Bcnm4hFmF1hnvaKUczoS2OEv
	0bL1YI4hc7B2YQr6ng6rx8nWdhaC0SMjU3iOq+dRSJIYq/i2ydNCyK+LtNn/52oZ4uROgf
	ttLbVe48f7T8fN4o9kPr++0aAjOb2fs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A7A940877;
	Fri,  6 Nov 2026 20:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D371F0089F;
	Fri,  6 Nov 2026 20:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793997109;
	bh=Xq9yFMohso02mTNk00VqD923K83qztQ5KJV4mLYhzhs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=onx2Fe3/b1WKTp5swB/L4MGSd/EdFj14Ek4ih88s3c7F4zetFTEb2NfAHCtEW8l4+
	 gzSUGvEr/M5n6ncDMjAF6g6AqZRfsfhSKOoUgTbhchFlv7Ib0YOn72yNSwIPtXyLzB
	 UCm+IunXjY++n+yHh+c9ZRWwJVKniDegMUI/M7iMFggg55ROyyoI/3vV5jXW6INm4R
	 QbnaVKskXdhf6VPOFNtybnIBJTtIWcfupuKoStKXWFmPOpnKOGn7JGKgIR3AB1j/ac
	 IVa2CBSTN+KkIYa55J/Nv0weCJXbd10CjTrzjNbuBnWtz5TWeO07Zh6/ORnAhSseGb
	 OexmN4msddMzQ==
Message-ID: <238194a3-6a68-4508-adcc-d6e52004d3aa@kernel.org>
Date: Fri, 6 Nov 2026 21:31:43 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] mm: limit pagecache folio refcount
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Mason
 <mason@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, iommu@lists.linux.dev
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
 <2ab3b9da1c31ecfb5880542efa6508c8.josef@toxicpanda.com>
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
In-Reply-To: <2ab3b9da1c31ecfb5880542efa6508c8.josef@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6b933waip4ioes5j5ajg399bx5u1q77t
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2655B40008
X-HE-Tag: 1793997109-523302
X-HE-Meta: U2FsdGVkX1+i/8VEJayiYuya7Drhe4cSYFyxGjxTNQxKNBMWV7ciLcHpEBqB0mIFDYCtXaQEOdOpRn5NehPMycM9nMTK2e6rPnNGCwaPHQ7C8hW8oKkhltzH8eAIPENtGSwzVCBOVBbBKLNN7zaD//OG8Cm7aLJJ8Z/LWqZGAF4pLJ2+ZiH+faw94sWxJ9CR9lsxPkiSydXM8nVblS2OL0e1oRbGuYGJedl3N3AQ/ePWfWQ5xXAyo27/yR7UzO8l2XKSne00heQfCFFFpxm3qnxAx1Q9QpLfZMgeNa/hnC6LJMgbxHiagwj3FZwIcf5iR5U6dBWYyFTJBtIuzHcM8FoHkdrQzkUGqj8N5zhV1fBFV49yWYjOdIVYnPKytAVu9NJIcQNSoZDsRKIcvzF+mLGaQe/w/fzqR63m4Kz4Kh+XfjvvwStXId+vcTqs7Cxl0tb1GUIuWx4JXyUmHUNuaJdtRNZ7dfKqS2wcVRG6B9cwiI4+74wGbXqdfg7kzz7RHWTuyopCIECgGzLIq6aBjcGzJbyT+LyQL94DIu7dKngSvp+wbd1U7X87rjww75IjOx5YdFdsmR0RBWaA/EWeARJSUhtlNxGBXvWCWAyyLpmWZLl7TVZmcXJRuPPiG6gIw+7jn3oE/mbrhfhtXuq6hb1hgS1osiMlBtS0JL67YjMgxi3zcQUJROoAxrUdm8UI6PQsY0/HKya300GDpGirMlaHWytmXUqZQd0BjN3t1u6CYpR/L9wtDU0MirSGXB4bZMrbvvVSfsent8XhyitBZHAy9B1sUL56ER76VXOyIJONGY5kowaO7gt6DXcDo8K56Ize1n3YgAoyH0ToUcUQz3UChikiz1oYkD1NnVI8CSpFJ6CNmzEh3IaLN7ckSH/Sv8Jl5WqutMWB85RmrBaJlYJ35XRdi75HnY4e3aPcjN1jh1s0RWYyllvAeWC7rhngdGUvxB4DEWWCHldxwuT
 0yNbxEZx
 691mwZr35/NFICmwu7I0txU5KY8QrXY1/C47LEv/J+u+s2O/QZJKM4f1jmsPeJkQ0trmg1M4a6hBxdtjOMp+3rKu2fLksgbHxTllFmsvLvyInIQLf3WMxXOv/yWj0K0ZjjD1PvJR4Ua4ta3qIDYVw7txMRExMiKaBG3z+jcPw9fvCHl5MjuuXKQThKn3cvWEfamXdyXhWWbyx4C9bybUqckw8RJkpsl6ThlaXkVvVTHVJ0AxV34TYrCuS7lhCnr7BW2bE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 20:49, Josef Bacik wrote:
> On Thu, Nov 05, 2026 at 02:10:09PM +0100, David Hildenbrand (Arm) wrote:
>> Users can create a lot of folio references to pagecache folios, making
>> it possible to overflow the refcount of large folios.
> 
> This is a summary of my Claude review of everything, minus what has
> already been said on the thread.  The numbers are from a TCG guest with
> the limits lowered to user 6000 and admin 9000.

Thanks.

> 
> 1) Small folios, 1/5 and 5/5
> 
> On an order-0 folio one FOLL_PIN is worth GUP_PIN_COUNTING_BIAS
> references, so about 2M pins reach the limit.  That used to make GUP
> refuse more pins, now it is also SIGBUS on new faults and failing fork
> and splice for everybody else.  6 io_uring registered buffers on one
> order-0 shmem page (ref 6146) and another task gets SIGBUS mapping it.
> Mappings alone can't get a small folio near the limit, so could the
> mapping and splice sites skip small folios?

Sure, our limit slightly lower, but not as much as we would care for small
folios? I assume your LLM is confused about the actual limits vs. your fake limits?

> 
> 2) Migration, 1/5
> 
> remove_migration_pte() and remove_migration_pmd() check the limit for
> whoever migrates, not for the owner of the mapping, and kcompactd always
> gets the user limit.  With mappings in the admin reserve the next
> migration drops whatever is over the user limit, in rmap walk order.

Right.

> 
> At ref 7681, move_pages(MPOL_MF_MOVE_ALL) without CAP_SYS_RESOURCE left
> 1682 of 7168 PTEs unrestored, including all 512 of an mlock()ed VMA, and
> touching them again got SIGBUS for all 1682.  Could the restore check
> against the admin limit only?

An actual admin access would, however, not SIGBUS. Sure, we harm mlock() as well
but that's just expected.

I don't see why the extra complexity for this temporary solution would be warranted.

> 
> 3) fork, 1/5
> 
> If the VMA is only copied because it has an anon rmap, the pagecache
> PTEs could be left out to refault in the child, like copy_huge_pmd()
> does, instead of failing the fork.  Only the VM_COPY_ON_FORK cases need
> the error.

That could be done indeed, although I am not sure if really relevant in practice.

I'll see if it can easily be done.

> 
> 4) splice, 2/5
> 
> filemap_splice_read() fails where read() still works.  sendfile(), the
> copy_file_range() fallback and overlayfs copy-up get -ENOMEM, and nfsd
> turns it into nfserr_jukebox so the client retries for as long as the
> folio stays at the limit.  Could do_splice_read() fall back to
> copy_splice_read(), like it does for O_DIRECT and DAX?

Same as the above. This solution here is not going to be the solution we'll have
upstream soon, so I try to keep it as small as possible.

I'll see if it can easily be done.

> 
> backing_file_splice_read() runs capable() under ctx->cred.  overlayfs
> lowers CAP_SYS_RESOURCE there, so root never gets the reserve, and fuse
> passthrough uses the server's cred, so an unprivileged reader may.
> 
> 5) Errors
> 
> The one condition comes out as SIGBUS, -ENOMEM, -EFAULT (tee, pipe to
> pipe, MADV_POPULATE_READ, process_vm_readv), -EIO (/proc/pid/mem),
> -EOVERFLOW (vm_insert_page) and -EINVAL (memfd_pin_folios,
> fuse_dev_splice_write).  Nothing is logged or counted, so there is
> nothing that points at the folio.

Right, again, a temporary solution which we can reasonably backport to stable.

> 
> 6) khugepaged, 1/5
> 
> try_collapse_pte_mapped_thp() clears the PTEs and drops their
> references, and then do_set_pmd() can refuse, so the mapping is gone
> although the collapse would have lowered the refcount.

Am I wrong or #nobodycares?

> 
> 7) Changelogs, comments, stable
> 
> - 3/5 doesn't say what goes wrong without it.  It is tagged for
>   10ebac4f95e7 (v6.9) while 1, 2 and 5 go back to v4.8, so 6.6 and older
>   get the limits without the flush, and it doesn't say why that is fine.

Yeah, probably it should go further back. The PTE batching case was just one
scenario. It was possible when batching over VMAs before (which my commit
handles properly).


> - 3/5 leaves the "queue is (now) full" comments in asm-generic/tlb.h and
>   above __tlb_remove_folio_pages_size() stale.

That seems easy to fix.

> - The ufolios_count fix in 4/5 doesn't depend on the rest of the series,
>   so it could be its own patch for stable.

5/5 makes it easier to trigger. Which is how it was found in the first place.

> - 5/5 needs 1/5 and 4/5, which isn't stated for stable.

lol, they have the same Fixes tags, that sure is good enough in one series.

> - After 5/5 the check is the only guard for pins on small folios, the
>   kernel-doc calls it "mostly unnecessary" for them.  The comment in
>   folio_maybe_dma_pinned() still describes the negative refcount scheme.

Yeah, I'm trying not to change to much becuase the while thing will get ripped
out soon again.

-- 
Cheers,

David

