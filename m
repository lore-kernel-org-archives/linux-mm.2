Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB1AA606A886
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 18:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=oueHp7CO
Received: by kanga.kvack.org (Postfix)
	id E48216B05B1; Sat, 14 Nov 2026 13:00:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF7EC6B05B2; Sat, 14 Nov 2026 13:00:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0CB6B05B3; Sat, 14 Nov 2026 13:00:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BCA06B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:00:04 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 197D0C044C
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:00:04 +0000 (UTC)
X-FDA: 85434488328.24.75F667F
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 19C7A20002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:00:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oueHp7CO;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794679202;
	b=PoDAAPH4pvoPSsWCwApRyPL3NCvwiI9ibJVBYsZ8DQYCBfFo2y7hgWLybCzk7UFf1fSSIm
	REBzKWq2pqilghBgyAoSsMDGZjeMgeQNRT7YfVlSYpFERQj8C6s5QPBFf/kCf0Dz7EgOf4
	UzxUceO3C7nbPkk4uAzn8BgOvf+OpPo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oueHp7CO;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794679202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/31rYS+RTknGml0ZJpQj3HlEE/4E8Z8X4z83aN0X9Bw=;
	b=q20XiwLRk7ePkI7GrQqvmR4cGSNlt8bqyEnfdfYoinKJknQhYmbKaa+1VtgXNwBjEekZBF
	KHn7zP79JumtDHYFOzA+omzz5iTIFaoL7Q0r2YHCcYUikBu0Dk8sELpAEdg6/2NTKCDO9k
	GGO9fXPPLJafb6juARpa+jnmPjp0Bmg=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-55c5b6584ceso5652321cf.2
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794679201; x=1795284001; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/31rYS+RTknGml0ZJpQj3HlEE/4E8Z8X4z83aN0X9Bw=;
        b=oueHp7COm4bjhFOEUSnBw/UWSiKIZkI9ke1Z47W5nb5fow95EQtIEpMjtqqlS8l5S7
         paVWe/Z66aPbQVCWrIWxVbHxHTZc/kAf0Mdaj7ARdvvwNOaUOp4Uq6MJtw7wnH7kSoB8
         WzD9kH72vPnkfzhcJ1/lynDKZqttRqPrIEL3wb8ODly189MyxgWCRaBuviT/P0QHr5es
         NrD+xiUJfR4zdld/aJYpe7/Yp/iWbsnvdSrDViBMrT6cv4PZiePSmB7ylWVboK4k/8W0
         7dpY8JzdQ8pYCKVU9QcJcsXuxFoKbsZSZA4fBke6Y+XC48DW636qfpXkKFvGwhgtjCVV
         C9OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794679201; x=1795284001;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/31rYS+RTknGml0ZJpQj3HlEE/4E8Z8X4z83aN0X9Bw=;
        b=c2+bRBmL0DW4i3MYXsTMH5kKf44xS224LYq4j1uJnd8FQOXXdomRRMPHIw+SdeDHro
         Ha+KcuhHne1A/C63fgLB/LaVK1hBWfwQdsT8MkeKv1nd3f0gqnrHYu+pKlRxeJ9H6SEy
         aUx7o10MDCeBQyNt+qNncVqA+CqGKT5RncflT4ZYkX//vjWPw69aO4/meh3zG0fszAxj
         TKYRPnGCc5jvp+UZWgMV7CqBGatM/eZWdTRPN+H7IbOf+dObL0EgiwitOK3gxTtQ/+ps
         fJXZH0nq5MKjRNCKaNqMXXKGRU/ebZ+cOPABHgX5oPx6Z7s4Z/1NCmglJHpUyRmu4vWC
         VCEA==
X-Forwarded-Encrypted: i=1; AL+hErGpD4+tRvl+LAQe53I2jb0CG2dJ8ySXHjVQDqKp5fwt0vZzYO3gLCytTC+ZEqy1/xvN5JQDjGpcWw==@kvack.org
X-Gm-Message-State: APuU4Z+DKUGutsXlozrMdwSYpedSNrqo80WLv32nf33Af7U0w6fcMPD1
	/4NEiu/RJ5QrQqewPpCOVhdtaxtTRn6EwMSY4UrZd05GnfMrggKuNEnu92HZ7ASdD4I=
X-Gm-Gg: AYBFou2W/RO+Yr69j3P0AAGZ8cjJiJlDDBT5HyvzNur4wE26mDW6rr6EydikXrYmwtF
	IlOwbbsjoUAT58n3XWxyYc160b0rhbefJ9hrSRtEkzMvVHBVqw+M9XDOUoMN13VORhyKtITDC/D
	TCqsmOapUzND9ekm4Ltdw7oa4031ZKMXmL6VA2zmgMUhL+4V6nm4c4yY/M/qyl1JjIXa74dquZz
	YghiG4lvOud6dJqVAbRjq/tAtA87AXGIx9WjwoEUt/YX6fhdEioIhSDSRtR75cQz/N3zBTGZA71
	aVKuK6x16HWfrzGfsvkJB3FPSVnb8otE8au056wFcFEHfvRjhElOu8o19BD5+NXS0IsP9rehfdg
	xijX9BQBXpfmFVzRLrKBHfQsDj23Q1Lz/FspJBpBomyA8ffscFuqC63w4nfv4DGO9lEA5AGbEWq
	ebbzBKLdYtZktLOXOCYV+MCYYcmLvG6hFoIm6bfd+S5pKIDzztpMTEkyuXVt+endqv1PHxY9vNm
	XpHr6dwfOe/4FEXuAgaM1gvc8Y6duKZ5AG2WQlLehB+nZavRtL18xB8DWW8vmvjhhzPJ1yGquc6
	bGEXRZbIunD4BQA7R8vw49bJqEqR93zdPRXDBtueTqu2yx38siBlTLQfA+rlVzUwK7IWh38RG3F
	X+pBWW28=
X-Received: by 2002:a05:622a:349:b0:55c:abad:a72c with SMTP id d75a77b69052e-55cc6d16ad3mr26820281cf.56.1794679201165;
        Sat, 14 Nov 2026 10:00:01 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d614b4sm47945926d6.18.2026.11.14.09.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 10:00:00 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 13/15] mm/hugetlb: fix reservation leak on min_size=
 mounts
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
In-Reply-To: <20261028-fixes_hugetlb-v1-13-a0a033db180f@kernel.org>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-13-a0a033db180f@kernel.org>
Date: Sat, 14 Nov 2026 12:59:59 -0500
Message-Id: <179467919954.482102.5381456550239958011.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 19C7A20002
X-Stat-Signature: p663spkjz5ggy7w3brq7hcuswff8jymb
X-Rspam-User: 
X-HE-Tag: 1794679201-388550
X-HE-Meta: U2FsdGVkX1/HRXKbW1HssfSuoeVVVUAUP5s+grhylxziHMYJSNH5QSr24s7a5wjQ5nkDu1SezmqKopkjssA4wIrIfxKBxhgfmbj07vXLjWtA9LMO7QaNjnnU+zpGQny01Ph4f6VCTsYgmChCgURv6cJHApWO1r3tTD25jGE2KrUTCMDgLWMbKDcx9r4LXOQ/hjal10ho1oHPaVB15e35jbTBRtljAMzCJro7ALK2p3X2eGn8BxeB8omNj7ql+K4F2Bqx3HJIWJ3Zig7VqhylKCxO/CCAn0jelKPtdgFvChNGoLWSkzROKtMJk8uoBjCCTHAoPLWqnTFH6puPeGCVaFePP1IalizwNI5nG3XWEiPOTR+fy2qYX81f4c3s4+xOnY8295wDUTrlaGR3gxXQ/uVJpxLhDkOoSTGWJIu6y0A1+n3H8hDorOePGnMORX69mfTRI6aByba3EJ8R6pnKN2tmXKhwDkx41yt8BpCt+XOMufzHvU7LWtxHsPNb1F/Ammt0b5gHDq+Y8R40LPWf9PRUBnT+xttJJSQipFF6r/ZPzLbYP3vKkWYnxzAFdcVUp7tkdRSmkERyMBgfVI5MP3/qpaBFNfUai+LVwnbtujkly/Hfmq3mxLXwDeu/GQvQao/h6U/MEEx0lDD7zmRX9JjzYfKISTgZJuHBdDhPsktSdIN4nIploBeMoBI+Ml4agom4qlR0PQh4zyurPtrXiS85+fmaSH4I3BAcJsr9qM2pBu6JdhMiOu/7WsWqnlEik2aaxieagIHOZx9YGfE4pV6UGB1119X88nLrBcwSfr1W54J8M9HJQjFXYa4jBqVRi6YxyKh85ofYjWuOad6qIyfPpRcN7JJo9etOJsDTs0dyowPTpRlOzzxha1MPlqEqO0HIrLLcBDYconmHADc/9W+neskAcjAqxaRmCalQryTgwqROJ9F81H+pg/2FlAqwaxMZ1wJcKI7WyGM13+H
 Vhtgzirv
 +Qkqn4iUkeoaEodjy+EYumZEP7hAhoA4lAKmCnGDa+V1dgbnSrx/m6SNX2yqBy/AoP6l1wIuAlM0fSlDLyZTU88SKxVpM47/Vnv6F4e+fiFLonfdI7B8pSg4iUYEzMimQz6pZpzpK8VketADgnvdAMuG+maj1XeAbgecHXjrOh9MZ5sbete/L5UQwXDloSZ3xpCDXxdTrJCQtNFQK+90n4DQ+FiK0jYj9TiJidn2tJLx7J/uv477jreHvcdqaed+OAcF/p/p0TVsKu4jR4PUiwKMTzAOAAjxRvgPqCgJSn5DUHF22doXYrjgGWT6dkVj7bj84onUDjKf4HInbj1w6spNq7ZS/60BO22kHLe6WSTdPXKI6n+3jWWT2q25uEmlWFiqVhMxhdVQb0h+ETJw+PiF7QYmR2OdMqpx6B410j+X4CYVM19CScF3nxRCOCmimTn2BMxEG301D6s0T5S/DgY9rPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-28 21:13 +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> Failed allocations for CoW mappings can leak reservations on hugetlbfs
> mounts with min_size= and no size=. The leaked reservations survive
> unmount.
> 
> HPG_restore_reserve makes free_huge_folio() restore the global
> reservation without returning it to the subpool. This assumes the
> reserve map holds the reservation. However, a CoW mapping may have no
> reserve map, or the map may already account for another folio at the
> same index.
> 
> Commit 58db7c5fbe7d ("mm/hugetlb: fix avoid_reserve to allow taking
> folio from subpool") allowed owner CoW allocations to consume subpool
> reservations. Commit 51e1de00acdb ("mm/hugetlb: simplify
> vma_has_reserves()") later extended this to CoW mappings without a
> reserve map.
> 
> For example, with a subpool minimum of one page and a
> MAP_PRIVATE|MAP_NORESERVE mapping:
> 
>                                       subpool       global
>                                       rsv_hpages    resv_huge_pages
>   1. Mount                             1             1
>   2. Allocate using subpool reserve    0             0
>   3. Free on error with flag set       0             1
>   4. Allocate without a reservation    0             1
>   5. Free and return to subpool        1             2
> 
> Call folio_clear_hugetlb_restore_reserve() for CoW mappings when
> map_chg != MAP_CHG_REUSE, meaning no reserve-map reservation was consumed.
> This lets free_huge_folio() return subpool reservations to the subpool
> on error.
> 
> Do not set the flag again if region-cache allocation fails during
> rollback: that would undo the flag clearing and skip returning the
> reservation to the subpool. This also fixes the older case where setting
> the flag invents a reservation for an unreserved allocation for a CoW
> mapping.
> 
> The doc still mentions PagePrivate at various places: future work should
> clean that up.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 846be08578ed ("mm/hugetlb: expand restore_reserve_on_error functionality")
> Fixes: 58db7c5fbe7d ("mm/hugetlb: fix avoid_reserve to allow taking folio from subpool")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify comments and improve description; updated Fixes ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Commit message is still hard to read :| (or maybe HugeTLB is just awful
and no amount of massaging the message will ever help this).

Maybe note - this is an accounting error only, the pages do not leak.

Was able to reproduce the issue with a UFFDIO_COPY the provides an invalid
invalid source address (src=0).

1. Create the pool and mapping (hugetlbfs w/ pagesize=2M,min_size=2M)
2. invalid UFFDIO_COPY  (kernel allocates, fails the, rolls back)
3. Close uffd, cause a normal fault
4. Unmap and truncate the file
5. Remove the file and unmount

                  Base                    Patch
step 2:  total=2 free=2 rsvd=1     total=2 free=2 rsvd=1
step 3:	 total=2 free=2 rsvd=2     total=2 free=2 rsvd=1*
step 5:  total=2 free=2 rsvd=1     total=2 free=2 rsvd=0*

Result looks correct to me.
The code hurts my brain but looks reasonable.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


