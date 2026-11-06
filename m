Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A58606A330
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jy9Y8X+2
Received: by kanga.kvack.org (Postfix)
	id 894A46B05B7; Fri,  6 Nov 2026 05:13:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C726B05C5; Fri,  6 Nov 2026 05:13:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 781E46B05C6; Fri,  6 Nov 2026 05:13:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2FA6B05B7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:13:48 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C2350120C98
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:13:47 +0000 (UTC)
X-FDA: 85404282894.16.9BF3663
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D7295180002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:13:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jy9Y8X+2;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793960026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J8DWbEnPAvibk1bD9gvCT78ILufZqiZXXD4dsM8vnzo=;
	b=vaQuNsTJ89Ta2g6ouKCoXbn40EZWycXps5TXGHRjR6jlKpxujMDWgB5P31kiEUur9OjCKN
	5TyqTMV7xll8JQe9VRSwv/53bhkVhgSuZl1xJidvfB90Lpb6QiNp+Ubt9xa1pnGF0rjR2O
	k6Dae/bNQ0CrhJBveizWyJK5Kts2FnY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793960026;
	b=qiNM5c3CH6NralxbE9p1jwUZpcKmNQkBUN5jqPGz4XJbHxeIw63HCbyr7ao5MveoNNxPbq
	7n/7X/RSHvICrCYKTPimfkIsIYFVOnCZbmjgNlXdI67btBUjNQ5Hvkvq/zQJs9Er2XDwRU
	n42xi+aGr65rVSGhyTXGoCmpp7Y/8L0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jy9Y8X+2;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C33CD40E01;
	Fri,  6 Nov 2026 10:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4341F0089F;
	Fri,  6 Nov 2026 10:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793960024;
	bh=J8DWbEnPAvibk1bD9gvCT78ILufZqiZXXD4dsM8vnzo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jy9Y8X+2igspgW/hjjz5MplnQY7bUSZeuDlGxIBm99iiHu3N59k9d9pyyqtNLVLUJ
	 imE49bvKblRZH9yoI00b8vp5qqnpUGe+Hg0bDmPWJeRUzNVyf1kv8/+hFFKcwed7y5
	 AwjQ/fI9i9ULfFZFuIRvqN9bgSksCG24YGZ36BN0qHZP/oUMkPlnet+TEkj07ANRbT
	 MK3+m7wCRDp3MQETiYvwu5h/gAXvABjgmeT2yRCW0dTGXb5xsAYVY3B+rBkg99Blef
	 stb6hFYLcvZzBNahaQYFYvUnFMsD2FNpYnGEP2zvNzDtZbfCEIPLUtNAybf/7z3VG5
	 02OugBvqChxeg==
Message-ID: <6b7efcd9-1a26-4e2d-bbae-e0a85618a5d7@kernel.org>
Date: Fri, 6 Nov 2026 11:13:34 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: split out memory-failure declarations from internal.h
To: Breno Leitao <leitao@debian.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>, Oscar Salvador
 <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, kernel-team@meta.com
References: <20261104-memory-failure-split-v1-1-3b0a85f0b7e7@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261104-memory-failure-split-v1-1-3b0a85f0b7e7@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: o81inkhx6o8io8azrb1buirihdra8jfq
X-Rspamd-Queue-Id: D7295180002
X-Rspam-User: 
X-HE-Tag: 1793960025-646756
X-HE-Meta: U2FsdGVkX1/MWeY6WQMtu86MUvPUhAc1pmHK5cJm26W23L5cHjwYhzPwJc5zTN+C268WrTQBLgHRBKyyR2wIM1mbwjbIO+uGFK/6Su4Sbrl2KkLAn4nh7zFY0QhVXHfLibPxaSWVePb+l426cT10OhrZSt5S4elV6RedkiUOoI5Y+0IHTWIi8QFmD6uM5twoQcd/KX+ovSf8wiY9cz4ftn2psi8GzqIDKtQCxzETOQ+dd3v8cvrM7z9tmDx+dF7BM+25LVsNsZkLVPwMKE33VhJEh8bkpmJ+enO069rzwZV5YCXF/7bpIFrkOk2mxVSdc25RXTy4WUAQCiObSngsbYjmklWNI2YQbCxj6+2wxIWKo0B6WS22fCt1IYxiNrqEzICHf1O5Cwf5zLGdV2+7WAl9zD56NwbtdQUehVwTw37WPnkE5QlHE3gLMsKp6e0DT+m5J3oNoHRnsEE5eGHwDYp4Nr/IL8sV4WkL603iBEUOVEDHC7pbWlfCJMeQVVIQ5XZE8oxwp6aGGgXG8SHhjObGxqe3Oe3YGepTziNlkaEKkhQVPvvvXj8Pf/F7gPBw0xtuP7AgKHYMxMN/y91TM4LJW94TGrMJszch9sHooIu8j4gVJwbbt37aOWeobIwrg0cPcJa5r5o9++FA5rzGmG8iwAKvLZqH95LrTGgHSMxtTkWi3r7yGDP6+A1unXqMUlNP46issD2Rfdih+t9826CSjKBbNlHqhhseIACeAJleyjo0VbROzbPdyJzL4ZoYq+QWTNHcsFp6PXg5ie0puMZJgnfTydLHYR94WA5MDWnzbVFoFoy8P16ZhJn9AZA4fcIYGDR60x//JKWAKmmsHGw03VlsYIAQ3Xh5V+RIG7PS4Ch1+LDfXycciH2dKvnLnpEUhx1z98yViVCwMKIlxMCMF4nD47K7hKVpUgaCFvWXS9CZjzxVpju8b4dAwofkS5TlLT6elGIiTT35auc
 D3b+RAGF
 FaN5gm9XubFbWCIqE0iTYXTATOjY+uaa0UWxrih5A0CdKGLsr31FRFfT0Kq5dhpmlpthVHYwIrGtaCfXOnLvVKNSIenrCg53LeqKkB0H2g/0XDVj52E+hYvAlkk62uOrI4vfRqxR06rzLJmKGk/VCq2kOqnrYsa3xPfvQnTkqPXdP9T5ReaB1ob+XZXeQHuueD4cDotqscZbFSKSdTZOz9+nDD0dNoIfN5Baqdv0/SPe0KYbQFk6/UgA3Hz5HrhUYPyjoDTpXnX1wV21MYESXMvBMyQrUFLSuIZpFI/KoxLrJWwMibbgdmoZ6E4Vcj+VATNgeKbVccDu9NxYqQ8MInbV3OuqBIq5SnLmGE/lnFdh2H1s+nEeYsapl6zKPNazXQ+MP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 17:45, Breno Leitao wrote:
> mm/internal.h carries the memory failure declarations, but only seven
> of the 81 .c files that include it use them.
> 
> Move memory failure declarations to a new mm/memory-failure.h and
> include that from those seven files that need them.
> 
> Move the block as is, including take_page_off_buddy(),
> put_page_back_buddy() and page_mapped_in_vma(): they live in
> page_alloc.c and page_vma_mapped.c, but are built only for
> CONFIG_MEMORY_FAILURE and called only from memory-failure.c.
> 
> Keep the declarations private to mm/.
> 
> No functional change.
> 
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Link: https://lore.kernel.org/all/aumt-4kfGGtoXuh-@kernel.org/
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

This can go through Andrew's tree.

-- 
Cheers,

David

