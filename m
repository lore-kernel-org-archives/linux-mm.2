Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 658A8C88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 19:55:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFC436B0092; Mon, 14 Sep 2026 15:55:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DACFA6B0093; Mon, 14 Sep 2026 15:55:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50FE6B0095; Mon, 14 Sep 2026 15:55:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8288A6B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:55:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 514D512020C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:55:24 +0000 (UTC)
X-FDA: 85213422168.03.257A9DA
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8E904C0008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:55:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=d05Hvsfm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of hughd@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789415722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Laxp0Q4fdbSsx/bSE8DTPChd1Qoi2LY7exp/DnLxEmU=;
	b=SyVfWCx2GSfx+68b6W74YqNSk+iJfcqXRgtuRtADbhxiwu/35nrB418mrRMILtHFvJu5RK
	+4kgv3G1R4P1zTX6Jf9Fyg0y08PAid4AyzuJx19fLGIKFUust5gx3HeS7j3g7XFdvYFJSY
	ub/QwaLBhih/F09MVd9fb0L468UpDTE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789415722;
	b=DMYPBuJHIHRWetbmn9/TmXfMm3rRsmmmHvGEdXMHo89enclLgGZHtAD0ZnS9fSkxAX6/iQ
	h8U6lGWLdkdxzakeLYGeD5oc56LlKKn2pHz+jb1PntHvxb6+eZOtDnm58vwldVtvMtXnyJ
	Wh+zyk1CW7jUq54VFBjecgR5oLwf3gU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=d05Hvsfm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of hughd@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=hughd@google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49e6e69d528so24974895e9.2
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789415721; x=1790020521; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Laxp0Q4fdbSsx/bSE8DTPChd1Qoi2LY7exp/DnLxEmU=;
        b=d05HvsfmeaZP6etlJ6D3ejDO+F1++5RMOZudmnAkeAtEGgvKWsAVR1PUxov4rPUifV
         jL891n+vzlPHeqEghF5CyPzeZ6j8TBowePhocu7+1LtkhTNTKByjtr9wq41KDT27O8mB
         WXlS8BEO3vpRBHPz6xI0a2BBAxFoNTbuoxYd+v1p24nSja5K5hmCqMSVCKT+DJdD2KXY
         EVEIV30f+jJ9xKbXIv/UENjzRusvJxuutppIbMXql85ToHg4O6a2gR4kS/Hkb5S9xr+h
         b/h/K9mCeEqw8CvfvhdZqmvdLKhO3eP2Qx+gPQmVOrQW2IML7cLXfajUZJO1I/ceOEvm
         bu6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789415721; x=1790020521;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Laxp0Q4fdbSsx/bSE8DTPChd1Qoi2LY7exp/DnLxEmU=;
        b=YKRjmLQpUH/wc0miSlhXnlocyF7dL8MaUP86o4wVI5lOLNb9mrSx0Tn61Lx0Ew3B7E
         9mCEhzOsqKSqjjoK31I35SWRB+KZuKqv879HC382c3cmpIxnnND9A1vswWtgdgWzQrKa
         nFwmH/mVCErlxxNR3XMDet7rqK24ozXjs+Tyum+GLH0xd5yiklIjgmTLv2Ci40XIyJmS
         i0+oai4uVMRFALhUcUke1p86wfEDYiYE9ibWnUB2/KIamDLS4J9mpVu2ljvLe1BRz39w
         EcLWCTxWoKgUU25aEZQPBEsZCBuSn+HtjBcPLZf2fAkBzJi+Zw14B7ZjvMV2lTVElIeK
         gJRQ==
X-Forwarded-Encrypted: i=1; AKwUvBzn3K1w1vOCvxWun6IM/1hKcC2XdaPfWsurWmlzWRXMXHaLcg5bfRT9TPsFpS00NzczJHBO34/ZMg==@kvack.org
X-Gm-Message-State: AFuF++muZdYj+tAu6F1ze84sWmGjMotsTSHgnVHETNyolRtlqgjoTgsU
	91z+UfIxaip/DTbW+MCcVcH6a4ZVU+ni5aC60qdZB3zXaCiEgqD3NGIWccCi6fdyEA==
X-Gm-Gg: AYBFou0Ln+qtu2JnW8uYuiLgM1PoMmRWDlKmEhvRg2oM1R4P70J9OZQq0oVqlMlIkG6
	iZmHrKnsT06OiK4Ny51gH/JcokT+EGC0NE/jkCA1nxMS2IGYL0YZsavDLwBCOkfHw6f5UlMFJle
	6/aAchlyZy8ybTFmvR0rG8KLvrKi7F0kiOBrbnKPFpsqkNTOSRCuZuA8q/NhxNLbgNuxkA2nm60
	CPVx6kM03+LF9yvtpRivb84tqHstcBBY7Lp1VZlZX1PxHdzTVhYEIYFHu+0vzs+3xiwmlwl97VT
	tBc5yBfCkgYQC7i0qiLtjqd0x/xwnSJUSkP0O/oNIhQq48rx1p5n9YJ2SdUs5g0JDI4GiLspr4r
	lsIEHyat6Cia7M9ZNgEPXFVuNBSf75TdWKYDro57+LTLqQncmnmSqm8BbgJXmmO4zhmIhJfxjqj
	O4B+hW2RFEoWCb5IAtRZfY9UXyOKJY6kSvZyJzPYuciTLD+yKz150EGi00bddDT0MDh3j9OHEkD
	N/pNlFF1XFq8fnu45YmIg==
X-Received: by 2002:a05:600c:3b1d:b0:49e:74b6:740f with SMTP id 5b1f17b1804b1-49e7a685a5cmr49653885e9.17.1789415720432;
        Mon, 14 Sep 2026 12:55:20 -0700 (PDT)
Received: from darker.lan (104.157.125.91.dyn.plus.net. [91.125.157.104])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb32e6f1sm28315322f8f.6.2026.09.14.12.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 12:55:19 -0700 (PDT)
Date: Mon, 14 Sep 2026 12:55:08 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 07/26] mm/fbatch: LRU_NEXT_ACTIVATE bit to optimize
 folio_activate()
In-Reply-To: <bbf33dc0-6812-f204-188f-f2176a4faf4c@google.com>
Message-ID: <60bac57a-e486-c0af-1a8e-583fd6e939cc@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com> <c44a34f8-ea3c-48cd-27d5-02df129be685@google.com> <ddab52d0-48c7-4d2c-b403-45f11e041654@kernel.org> <bbf33dc0-6812-f204-188f-f2176a4faf4c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8E904C0008
X-Stat-Signature: hkdxrrw99c5kro3pf1fkbmjtocx6ws4k
X-HE-Tag: 1789415722-229165
X-HE-Meta: U2FsdGVkX18l9XJxC/Y8b7YMoFIOt5TwpNEhMDV4hdI+KqZ4BcEBp2zEsuRQFcmOt9/MkOZ405+YIHB9KyjUw4qZSqeoQsmtFUagn6PYvWoB5kZVc4UEVHS5s+qPFkxniI+rv+ULMHNg15/XBfvSeqyD7PMAQpmEKoPfZ90UBl41YA1vGIQcCvLTmPXneOqfySLSMOQaibSE0icI5HBPGfTtZAqlN+2+/XkbnnrF8PXwKuWxKwNyKJXWMTyH5VH7jr7yjvzvoWqQOzvwLkKGqU1juwbIRKijtdplwyLIsU0gKZu69/gU/mCtazW4uccfEzwAP7yES3Im7YQ7wFMf8j1iGjjganaGtuaM39h3T9TkvEeP505ai8zXFueYzrY2WBr29dTcSQ9x4GuWrlq97gZZsJU53y/5McG4UsDrYQ90UFzQLXpwSpvfbSKZRvcmqz1EfuTLYYfZARfcFmDB34IjaySuFWzzE5Eqz9KS8WWBbIRTMGOReaxpdltUezfbYLrGvs4cST4AstpWM7xvae95FQioM86WUq8h0KCidCNNwSp6oUVsRxfWIcJk5QNVzutcKxFj/2EC+MItUrPPwBndUqF5+fAapvH1sj0yYGucI4WQmNsiuEJSPc44GnMRVcu4IXeufLKOqpsfoTXKRB8aPaAtNu5P47TBLOGJMfLb6S6CQMYqAmenjg2yhiJ/VozdrBVlsLOY9tPju7IHs62PGa+nbaPvwjA74L2O6JAfB8eL4L4pQ38kSnh2ETtbDLA8YabS2m2PsEoklbKyp/a05r9wDGwF3d8dMl9Z3gvwBg9E0OoVsDncs8N7pnMIKnl5ooENtoreUZ2OTuDNWB5nf/paObVu0dRH2r5dq20OZ3tkSKAR7Gaz0xDY6F1h0iBcq+agKwnXvNOy7VHjCLnedTthk6djzynapCy3sKv+2q3qYtzd5EgYTunVUGCgCSLw1P1BUY/gYyFiv3L
 ocdHDfo3
 T6YBNcZMiWoNreJTMGkI4g/4CJ3qBa35jzXXXMQVWvmzNl+h+VV6yPvK8ovPjBf9EELiMw/HQzmdK4NCmizJaEZk3dwkISTJrHM4s9dDQy9iiwJyiJhlL5ez0Nil1aJOlcMJvX5ZQYah+ucvwgrNYi0/vsNfVv2Mw/Y0V5cUru67OaWSmHlZjLXUUZg1lt+7Ox8Or7UT+RhYxu2WJVxcZD307sE3BXjNbWs7/nxYdpjZa1MXvaX4bw4faxSgMA2Eb+8JB7LexgaNqx42L7m/Gta85oQ9jbwLoVyyjEBQdIphYk75F6iYE1gHfRMqYn8SKaaFZyxljyz3qiEofVOzJYaHNbO1HEGtNdQsb5n6dmH4OySceYHgB1nONaM095U/FMlhHwDntdaDvmJSyrfYdd5lvE/SQH3zNs/CgBCXLBa4Il3J3OoseGPme02wH+G8RaafvDcu/JnvAyU8guOwAN4G3ADmD+sm1OBOSlpCAvnAOnzQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 12 Sep 2026, Hugh Dickins wrote:
...
> I have kept the address for debugging, and do put it to some use in
> the paranoid vmstats patch 27/26. On 32-bit, with 4-byte pointers,
> this LRU_NEXT_ACTIVATE bit does then leave one pointer covering two
> adjacent entries, when it's deciding whether the folio points back
> to this lru_add entry. Is it possible for two adjacent entries to
> hold the same folio (and so perhaps miscount the stat)? Yes, it is
> possible (if that folio is freed and reused and readded immediately);
> but so unlikely that it's of no importance when gathering stats.

It doesn't matter at all, it doesn't affect the choices made here,
but I do want to correct my estimation of the likelihood of identical
adjacent entries. Perhaps the most common occurrence would be, not
when freed+reused+readded, but when isolate_migratepages_block() does
that little lru_add_del_folio() + folio_add_lru() dance. It could be
that the entry it "deletes" (by breaking the linkage from folio to
fbatch) is the one most recently added to that fbatch, then
folio_add_lru() will fill the next slot with that same folio.

Hugh

