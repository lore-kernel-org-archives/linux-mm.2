Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F85BC43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 14:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 710DE6B00DE; Fri,  3 Jul 2026 10:52:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8CD6B00E2; Fri,  3 Jul 2026 10:52:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 600C96B00E3; Fri,  3 Jul 2026 10:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3ACB26B00DE
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:52:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B426912018D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:52:56 +0000 (UTC)
X-FDA: 84947757552.12.E659319
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id 88F6D140003
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:52:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mydS1cG0;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783090375;
	b=CHiH8PRbfh6MITLayisgXYlVNmD2IN6EzcmJpbVYkKb+Wh1A1k6MtbTY3GXvVQjhbs3vZ0
	dAYA2uIzgRZhQH2Y0PNzFSWUS9DP1gwLUmOFwlXbiq7/Sz8BJAfha4OA4VoQhhkNIItDw4
	eWev8GgAIW/Q8AuPj9xwFzRcTIvgUno=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783090375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78pFcvGqBsTyEx7R+SOnLGnzaGBXiO97ypFlieLOwVk=;
	b=blNJkqtou5YgLZAYQLZtD+COgELRbcyhufN4NUnA9I1dAJwLcNcRWRHkmP0yyZLa+4x2ik
	GwsZXfnnQYqjOBCDaWWufmo5A1Q77wVeKA4tzbmjoY6VwjKfig8fJaKVakIHNgqngFbpx5
	hvOM4fV547iNpnm6nPGnyl0IcxV3g6A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mydS1cG0;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <1f9e4322-1c5e-4409-9a12-ead280bfa4bd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783090372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=78pFcvGqBsTyEx7R+SOnLGnzaGBXiO97ypFlieLOwVk=;
	b=mydS1cG0VikRlAPagxdsHIFdCh2aej7rbmihV5PMR9Pk5I2mabCesa9j97GUksl0CxTJUi
	YLw6g7RU+UGOpukqE4gmXAQqPTOHWHg/+HnMaM3rN+i3Z8AY5nchHjk+iAqyLc+sFE3TCQ
	sEDbRSpgdlHolEzoreltzIkrO2bKZ2A=
Date: Fri, 3 Jul 2026 22:52:32 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 5/5] mm/page_alloc: remove set_page_private() in
 prep_compound_tail()
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Barry Song <baohua@kernel.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Mike Rapoport <rppt@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Alistair Popple <apopple@nvidia.com>,
 Dev Jain <dev.jain@arm.com>, Brendan Jackman <jackmanb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>,
 Nico Pache <npache@redhat.com>, Suren Baghdasaryan <surenb@google.com>
References: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
 <20260703-keep-subpage-private-zero-at-free-v2-5-2970fe777dd6@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260703-keep-subpage-private-zero-at-free-v2-5-2970fe777dd6@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 88F6D140003
X-Stat-Signature: 45uarhan9hpbsxpizrfzoibmzstb7u7t
X-HE-Tag: 1783090374-331106
X-HE-Meta: U2FsdGVkX1+fmrulPNX/GR036PYIfjPAGKXcCbEiaMPfzoWnXQfK7NPcdFFXF0B/CFEReu39+yFd74k7xF4kZdr9oI1NFyQ5wsWk04CvpGybEOIKEW8WXb1afldeQQLKHAqOWM74FPPW/nRkarEn7L8JeBhm5rnW8qK4hUkF62OONTi5NHZ3/cG07TGZYpEZcUR1flae7bVvh7xgv7iXEMrmFACidw+fRyjUPKOYwIuTf+Hn+Z0nDGwnMBTd8hg4s3lRMBlDZdpPpGIHLEu8dugk26u1diipYdXD5AVLqEN+gFHkjNi84j3X+Rp6a/riRxztsnE6BT/EyUjgi+4Ggs0lc4feuXAY6tWhVa6lGER1kV6J//HiaM7dyDxW/wLvHuafQOgHB2UyhvQR6SJmYoA5xYGmiHbPi3lskRc8xKtQQi45kZMZshKGl0qF1jqeLmgFiwJITnG/2gfeeOWGRXD57tUYMwNAdCqbjiEBqAVBFe1mWQhVLr8Nx9za1cQcFX3mhAKg25zE8D8Z+zBYjHfhEcdQdRfyuWOzKIq7upDUD8WiTDyFWQQGrT+uZELY+aFyL1wUE57vIzSdZTHqka5ww+UxkWfUuruX5daNECNdkMsV0Z1mZ/TDN45llDCT78LEocUY7sF7akW13G76xv3dIzLE+1AlnuZa6uL96yRcjspoDFciC01G2BEPseMIozn9znKMEgE+DwCpxD8ofhR96sliIUrvadc9Mh8+WU/HhViTW+W1pypz9Yb4clF7so5f53qkXTMmOHHTfkhYm8JHUSpHCEhLjzkFcrumKhbnHuAaP9cau+Jmn4AjHGQOgco/rsLv/WjcZHCeM8tllrMWDu7x6p0WwIf1BALIfhOL7XKw7Yn41RPFr3CIxu8M5T+bk0WssfInPhrS8xacq4l9SSQD10chdZSGPOVHKHVX+5gBUGjOT2kxskZAakVNc/3/WFkC8aw88gySOy0
 6D2EwkBk
 vi5exmWB71IIBLpDcjGpVWse5tn6OJG4zFzZciPsXY0Kvyr4BRe92oKMJm4cZ5kG6lmQaqKLuBU0xL2UuDQlpQpiIhH21qvQ0scHIDlHf5yKWhTpvFJ3bCPPNVu1Jc3Dd40MTAdkXJ8zJqLj8M2tsN1JyZdxp/zhNm/9FgJvZ+X5+SX+ou/uSyi/pm45akqtTqXOqONq5NER90u3HS2oXMpwT/7FSYKF50BLZ5WdbZIUgdd3n4Mb4Yug1xDPfeqPPhu5NxlFUN+26Jgx+bXK9r+Wo3nY7msuZ+u8ztbUozZu35liXVfKBkZ1jqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/3 21:47, Zi Yan wrote:
> Tail pages are expected to have (and optionally be checked) zeroed
> ->private when they are freed. It stays true during subsequent
> reallocation, so replace the tail_page->private initialization with a
> VM_WARN_ON_ONCE() in compound page preparation.
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM. Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

>   mm/internal.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index fa4fb69444ecd..fbd9fb84341bc 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -902,7 +902,7 @@ static inline void prep_compound_tail(struct page *tail,
>   {
>   	tail->mapping = TAIL_MAPPING;
>   	set_compound_head(tail, head, order);
> -	set_page_private(tail, 0);
> +	VM_WARN_ON_ONCE(tail->private);
>   }
>   
>   static inline void init_compound_tail(struct page *tail,
> 


