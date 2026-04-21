Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 382FDF89251
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 10:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ACE76B0092; Tue, 21 Apr 2026 06:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D896B0093; Tue, 21 Apr 2026 06:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64CF66B0095; Tue, 21 Apr 2026 06:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3416B0092
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:56:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 025851A0D2E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:56:11 +0000 (UTC)
X-FDA: 84682258584.29.BDE5018
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 28EE8100003
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:56:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bZGb2Ak9;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776768970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rsemHJ3fDNViSPKxQzPZn5/mznjb9La+x2dQ4Ib6EqQ=;
	b=IXrcU8xTU1PpVKjM7lDobvq4oGhilmeXonBeE3FJ4jLzqFhrwt11eVTTJfwYLWM4+1xPWh
	RXoGArx2Aalk+arAmurq3m3UuwPrfxvTpyaFXFnv9y6EYSNX2r1vb42AS73IWZV4ECrPg+
	hajIWQuxfbAa7K3JBa27zzxjfzdDDiw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776768970; a=rsa-sha256;
	cv=none;
	b=XwYjbsMrKAw3Se2x+P9r8MBoNWkffdRBoUkQbgd8lU04Z72jvd1qKAaavHBalojQ5Fcy7i
	NUO7DlPWluhtxU4ajVhlYovyGeET7XxAwtbz9RztLP3XEDVlimSzu2nTNp/7+TSJJFYExm
	xNsRszFfAv31Vl4CWAZmiBtj0FGUyAs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bZGb2Ak9;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 308B94438B;
	Tue, 21 Apr 2026 10:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F9CC2BCB0;
	Tue, 21 Apr 2026 10:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776768969;
	bh=28/Re2P3rtxWETUxEDmL+uBIuydZ6Cru3a7eY539SXs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bZGb2Ak9fyENYNy7XuwWvO992dL/SDpf5EkNQ0x+kt7nqAf/y6NyobrUgNZ7PbuEU
	 h81mOWgSnpl8RHh+Gb9/IS+BWGCCW9YOwb71OOF4S7/MB9cCXUMFOPLdJsJrCFFUNc
	 57AX0ENJKMop/N8T5y2Bly8BmI7X8Jcvrdx4ZidvitfnEmH3nmzvE1/kUoYe1em+ol
	 cSVs5QJEh9salbgGk72sWVOH7mmWby26YDHqHzkcP5naFpMzdVBZQhXZ0dRPj3alCG
	 4dqJ9XSYM9T1xiSziwcj4yEk40ids4G1nHwptuxGqa4JICWNJcukY8TS6oQ4yQeTID
	 10uPBb8BHqVFw==
Message-ID: <5f76af6e-9818-42ea-a305-c0fc1d920dca@kernel.org>
Date: Tue, 21 Apr 2026 12:56:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 17/18] mm: add free_frozen_pages_hint and
 put_page_hint APIs
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>
References: <cover.1776689093.git.mst@redhat.com>
 <c7094de807c0e963526686e1d245bc76193b1a92.1776689093.git.mst@redhat.com>
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
In-Reply-To: <c7094de807c0e963526686e1d245bc76193b1a92.1776689093.git.mst@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 28EE8100003
X-Rspamd-Server: rspam07
X-Stat-Signature: k7ic7841gxh5err1116o5t51dbnfzb6p
X-Rspam-User: 
X-HE-Tag: 1776768969-387572
X-HE-Meta: U2FsdGVkX18XlyKuf6rpk1Cc8kUCs6p6DXKD8R8ywqjDFCVyJT9uAKaXm/1pQnz+5zJo24VTObKphcd2FGWXI9SzwaRGHalogjFrlDDUUMpnCsI/sauFCj3JqYoHdGDvm9NwNKK5Gz8RX8flyo2s3RGofpw0MKH5tEUrU7qBiVAqB60ocBjXRu0C+cv9jJvJ5pf4ebm66Fmu12Wfws5g8Tfblqx3rHAzr4KIre9Yy1YqUUM4qDU8BWIN+HfsVVyOm+SrRjeqlS9yX7P9gUz1Qq0EU1pVc3EILq2TRbQBYzmcC2jguPc+vkyBpzE3oWquKyopuYkTbCx1XI4tmewsGs2ogaNWypJ2DsgCHN3PS7upQ9O/0Ls35sGToV+EhMG2bT2Vd+lIW/n2ne99XCaDbeSvYVsCEHs1TFvVtjg8710fTkrVnA2rw2uTgxU05Yg3TXStJGUM+iwJ5cOK3+yTeLjjqFQ+aAtZZQvXL0Ei1OJ/eMBkLNK7EJPpDK9yLMOLqIw+hfjiQ5aVpjKA+QPJHFu3xD2FgAcaSOIxCqW4pq+YYFoOwJVsWeAfrXuDAJBndeht7tMkN3dXCcNXUzDhkN3+4I4B9rgbkgjkSQEVZEuLlFipy3BmcAaGmJJL/q4+hoWw2fPdaMpaBLzw4MtBma4D3Bv1CKroHyzIZEZOA8tuJ4oayPGp2oUek4JWikXNwXbyAYJdECI5PJ/D+kdfjHyvdd/SE5G7jPKkSH1UThft981f+TtkKeVjg2nuhzlLRA8q8EETkzD0v5pHZERLSj6K0AaLrnpgoHefxpDasdoZNYWVj2uqibhUZO84o8LDAnCuzTTrFGmFzNiQtarYbYKhrbXLiBh3X5kYUU4ytPTGX4QigSgSp4JJMjN1cZf/0iDZYNEIh0sH4doJUlR+Yw5q3P5ATRorXwHzRHML5XUHKMJCy3sZdM4fBaajVKnRzzaW0rf9WYP91y2WrIf
 RDD0oZTF
 YykuV3fW8KBo8LyMyaMBSOrK35osSPT34zqp0eqKst4yIPl4WGpQX7FVmWjgxj0414kc9MMsy817DTFJcWGgq7dccmlu0T4Iaj3kJPjuFydsDvg4p6hOqQTsChRJI0NxkIhjZEcSVNsgP8KaTvLY+34cphbS3fGWVGlmp4pUgbtir97Sevia0o23XphGWem7wof1KvktiMtREgvFSrseZ9Z9Y70UhSOAmmNwGT9Rz1SK0nZzWh273aPricxEk1hGG5BOXToFUiddyX2hQRGkBX5X8w4BUIuaD9+JFGasBSWF5U6BkkrzfagxcEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/20/26 14:51, Michael S. Tsirkin wrote:
> Add free_frozen_pages_hint(page, order, hints) to free a page
> while marking it as pre-zeroed when PGHINT_ZEROED is set.
> The PG_zeroed flag is set after __free_pages_prepare so it
> survives on the free list.
> 
> Add __folio_put_hint(), folio_put_hint(), and put_page_hint()
> wrappers for the put_page path.

Can we defer that change?

Putting a page with a hint, when there might still be other users of the
page is a weird interface.

In the long term, all balloon pages (PG_offline pages) will be frozen
pages, and definitely not folios.

Frozen pages don't have a refcount.

It would then be sufficient to have the single owner of the page call
something like free_frozen_zeroed_page().

Now, to convert balloon pages to be frozen requires some more work,
primarily to balloon migration handling, unfortunately. I have it on my
todo list, but it will take a while.

-- 
Cheers,

David

