Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F409CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A54AE8E0018; Mon,  1 Sep 2025 04:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05428E0013; Mon,  1 Sep 2025 04:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CCE98E0018; Mon,  1 Sep 2025 04:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 770B98E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:13:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F8EDC0715
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:13:59 +0000 (UTC)
X-FDA: 83839968198.01.14730BF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id A7A3740005
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:13:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iLPEkaqU;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756714436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X5b17MvTYOYiz7nd1INMHbVaUmIAu2Q8XQbX6U7l4O8=;
	b=K3lhTwBZyLYfKy2Waly/nY1DIQz9ev/Fo1UwUtKs/6kPQMii0PDGV/1TNyTY9cAAtNHljM
	4fB+mFrK9q7VB05zaLgLjjB27J+Dken4bym1x9UgvIwJCl0+V2aiMnLT118K/E5mM403EI
	nQHExkq34t2YtZMy931kJx3C4SY6NeE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iLPEkaqU;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756714436; a=rsa-sha256;
	cv=none;
	b=EoieZ8jUTFB8vUAvACZxoaiaLYJeRJzaXsiwHZIKl2EdiKGDZVlsMWvmyguZENol3sE93p
	15zJbVFcnv0RnPiXrcrjaM8KgSYUIWh87M3BkXUNXWuzpmBN0LrgPqCkjjZ3a6GK2nsppm
	78Fs0K7FuuSxMVQV09Uao3cYrRGit+4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756714436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X5b17MvTYOYiz7nd1INMHbVaUmIAu2Q8XQbX6U7l4O8=;
	b=iLPEkaqU+lnlcBlif7vaRBKvByFc3ID2s0l2DWV+RKKDR8KJl4pq3OQVZzhzvE5s+SDGob
	r5kXrrv48t70V96IL2zwLZm3PpayrxNt0SRSoU0RS5R2mtfMMBYTcdvAMYBIugXMLtjnT0
	gy7Uc5ULCWZTkHLf0cPpAhGdK7sLzWY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-MIHjqNXTPe6HtReMfnlv3w-1; Mon, 01 Sep 2025 04:13:54 -0400
X-MC-Unique: MIHjqNXTPe6HtReMfnlv3w-1
X-Mimecast-MFC-AGG-ID: MIHjqNXTPe6HtReMfnlv3w_1756714434
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3d160b611fdso1185859f8f.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:13:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756714433; x=1757319233;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X5b17MvTYOYiz7nd1INMHbVaUmIAu2Q8XQbX6U7l4O8=;
        b=nIh/V0hS0N2PWeV34MJBco9kbwPyUa/41ZHF/oTNRg/Bml3zV/shMivG8h9OCe1ZXk
         r3k4UZHs8klTweYccN00YjSucFqrQ3tdbNE68GpuxdnujE5epaMhcqCijWPANFrnYveF
         rAFEVjMxSUhewdjd1rv7/VCgD6xmUuuMj8Y7iGdS46x8rF+KVBZHmWnhugP7hrG1YSX2
         DamlMmnHYFs44JJy2MJXcCc0fRK4nTN/i4SGkDFjjN3vO8MDVAkSE0jnLe7EjTQNFFWm
         qf2xOQWqgUtqhYaDxJEjx6pRl08fL83etGvH+hWUvVbvlCu1ZLHtIoaAB7VdWMc71X8C
         /IVQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3XQQyBirwl4U8zyq9+kHeW/YSs8OublBSMZ7SK6JxsMimJ+gWgcq1UkG2pXJ5nwV2rMfdQNbvyQ==@kvack.org
X-Gm-Message-State: AOJu0YyoCNivSIe5ibrIVO7LsOD5SuiZouezCXEPQYxmrvmur8pZH+YI
	zttoxOtQX9PFNsqKhYk9nZib30iC5Tzvt1bfFPEqFAgq4l2xmeOL+tTUhpAVGGAC4dwiD55yJAv
	+Qw0JhW8tjk+E3KTkrbWNA6/ske+tKmm0P8vASyms0n6DdEDOfRDt
X-Gm-Gg: ASbGncu2eR8iBD1sJojIarXEU2f5dEgUszTLqjbjMr+AnZiB/0KfIiCph5uWVJrzgCi
	jb6iU89XZpppYOfs60KAPG7pWT+n1TknPUiYInilblvU0m6jb37tQbWV4Yqp+Zu5Oak5+ADBGET
	v35QQKxx2zn62L6J0RmebwdUS3vYK2ZrdQsGJXvn9Ips6XsWnS2T8d6tVz0zojxBp2F8kQ88tHO
	Nc3x4a/45MEgoc8AuUWWyd+VZ5wCzhoLxWYXLg7z0+hl7Y3jwwx40A8USNNxeCkwSAm7/mwakos
	vKBhzlLqvNqK/Asycd7/5F+38MJhWjoLIKJdhcFhzJVhTpWas+JG3ty2OSDLQPYiUpCIjbnnI1S
	KYA3p0hThUuxttwM259sbce1XfDpPN53z7ByqneIR+ZkJVj1SWJKm6xper7tG9ZIAeiU=
X-Received: by 2002:a05:6000:25c1:b0:3c9:469d:c087 with SMTP id ffacd0b85a97d-3d1de4b9a49mr6221181f8f.25.1756714433495;
        Mon, 01 Sep 2025 01:13:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFO8tCu8gSVb6DBj+dyA9n9YoVsr5U3h2wTWJqo6mymjQ9wdVl2hktM0AWeXUSMDIMj92bqIA==
X-Received: by 2002:a05:6000:25c1:b0:3c9:469d:c087 with SMTP id ffacd0b85a97d-3d1de4b9a49mr6221145f8f.25.1756714432896;
        Mon, 01 Sep 2025 01:13:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b66bbcf19sm137207905e9.4.2025.09.01.01.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 01:13:52 -0700 (PDT)
Message-ID: <7fe2380f-a83e-4a9e-8c5e-8459c9af0d5f@redhat.com>
Date: Mon, 1 Sep 2025 10:13:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] mm: folio_may_be_cached() unless folio_test_large()
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Will Deacon <will@kernel.org>, Shivank Garg <shivankg@amd.com>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>,
 Peter Xu <peterx@redhat.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
 Alexander Krabler <Alexander.Krabler@kuka.com>, Ge Yang
 <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>,
 Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Konstantin Khlebnikov <koct9i@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
 <861c061c-51cd-b940-49df-9f55e1fee2c8@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <861c061c-51cd-b940-49df-9f55e1fee2c8@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: o49-0PPpaftuTo_QvPB2rPl25Vv2TadhVCZpymDWBv8_1756714434
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hdp4dhnmp1mc4n9f8r1noathefo4qn1d
X-Rspam-User: 
X-Rspamd-Queue-Id: A7A3740005
X-Rspamd-Server: rspam05
X-HE-Tag: 1756714436-995559
X-HE-Meta: U2FsdGVkX1/1tkMhhYzK82P/8oA8iZDASumnSOsJ4X71x/puz2hLVzTtYgZ0OAV9DWt2noMVBQ+a2hdZ+rXUDwoXAKJiuxV8FB/vIW8NG+j5mYuzW/78zw6GRkfM/p6C979fUbo0JgCZ9hYp2B/60AIOUfeELpJzSbPgE2w16TSIcbX7Durr3QlEvXErFB6a08glXxvtKqx+mLtLuAnrQsfQZsl31H1L92RWn+B9/c7Y90Q/7wS7RhL65dAsl2pZ/I3KUzwL5tNn+it9MV6pHLQm7ZySiX07jiDIuyPrPm3l9hTEmXjNFNk6+k6y3h2kmo1WDmcQvOkcI9lyrYWg5vzGjN7EvLzsy3lScCPsEGHH9ZyOFtjEL2WphzmaMiXqqnh9OA9qw+T4ZLD7J0X4UNxwe+5Bxp1Wm3y0tVxbonWoLTT3Jl77sWRcR+gwaVGI5onS0nfdxmf9yiK1bPvrliF9VJwntqUPZGI860Rr6nLshL6C8WUTtWUYJICIr4Z7n2sIqfdIBEk5l5gyLa/1RoYRw3JCmrNnG3MkBcd1Ja7BflM0TrlNczQUCYcEqoGeIVFzPlOJruCaMgJrl6ro9dDCokoGq0tYrcMyRGFliU5fFvsAcsM4P2x/d6hrgAaZgUvhX/pi1vLIyurtFFljlELC5aNWa7W5mFidc6Tjy1IgcCMvMtAN/5IGnHt7tz2WzA7DZCJRYbfIO9kZUYZ7YOwh4OBbyknLiHX+ajHRp3IFylvi5N2a1YarzIkTPbQoeGe+RvovMI+CiHPUwpufovAqKWhEQl8sdDS3U7A60RNWmG28FDJGqOJWRB3XWdWWddmU3wtoclYEobJ+QkPvYGXPL5JopGoPkw9OBoe05DOcGtM+d7sS97EuAI2UoNMzGGu+Mx6kC2HC22k1B+9m8bUwQlWaOKh6NGo+nhkRnbBpWIM3GwP+N4f9nKPYv/0qkrxv0/Jt1PunMurlWxJ
 VAshOtgm
 ysy3GFgYBBKmqAF6QokdA4PAQUQPayu0CFPgJiVDuaE3RjYvbCx/pLOu15bgoUR8DyUOXGWjMEJyZLbrUJN6a8th2puWWA8wRzEAwogRn1Kv2lDv1R/W8gNB6jVrGQWiPYBdO0eRpZ17XFtgziguQkJrhqPa12LGjZf9vS3i2qPXR7a4J2+8E4OiGxlqWwPMNKcI3qHWwdehzpWd9LA8xBW8ZOE2S6Zig0G5GkOlWuFmm4r7eGRduLbJ9e2L9pVqhbiUgLuo6c/hf4hfOhbcST729PqdyXR5RK+a/ERnjjAiYVdRNItn4TKYegj4RYaW8GQVOQ8Qt0az9R3GeBGjpJA6Mf6sErZwCPQ1KmoUL/INxO89LlioTmd9OXZIv6vlSYKgLXkGcDtca1FIRncB74k+wBAjhFfZcok8dhWdKLX+jph73Q6CQsJCXWW2kcVOrI3ZlY33J6b9SUBlAsAZPo/fqpdhbdyleE175Dsq2T7//n+aadqlBjhV37kj17vsPXYEpYiMcoFNJ4GnisG1laGPF1Ic8CHbVzDS78q5jcYbOGoy+aDsLHq1/1PBi9sBs2QrdjqupdRwVTKSNak+qXiZlSRK0VYgx+9k7GcIkKot5GR0XhdRzHNDF8XEHkIslM04s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.08.25 11:16, Hugh Dickins wrote:
> mm/swap.c and mm/mlock.c agree to drain any per-CPU batch as soon as
> a large folio is added: so collect_longterm_unpinnable_folios() just
> wastes effort when calling lru_add_drain_all() on a large folio.
> 
> But although there is good reason not to batch up PMD-sized folios,
> we might well benefit from batching a small number of low-order mTHPs
> (though unclear how that "small number" limitation will be implemented).
> 
> So ask if folio_may_be_cached() rather than !folio_test_large(), to
> insulate those particular checks from future change.  Name preferred
> to "folio_is_batchable" because large folios can well be put on a batch:
> it's just the per-CPU LRU caches, drained much later, which need care.
> 
> Marked for stable, to counter the increase in lru_add_drain_all()s
> from "mm/gup: check ref_count instead of lru before migration".
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: <stable@vger.kernel.org>
> ---
>   include/linux/swap.h | 10 ++++++++++
>   mm/gup.c             |  5 +++--
>   mm/mlock.c           |  6 +++---
>   mm/swap.c            |  2 +-
>   4 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 2fe6ed2cc3fd..b49a61c32238 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -385,6 +385,16 @@ void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
>   void mark_page_accessed(struct page *);
>   void folio_mark_accessed(struct folio *);
>   

Two smaller things:

(1) We have other "folio_maybe_*" functions, so this one should likely
     better start with that as well.

(2) With things like fscache in mind, the function can be a bit
     misleading.

So I wonder if (a) we should just add kerneldoc to document it clearly 
(lru cache, mlock cache?) and (b) maybe call it 
folio_may_be_lru_cached(). Not sure if we can find a better abstraction 
for these two caches.

Thinking again, "maybe_cached" might be a bit misleading because it 
implements a very very very bad heuristic for small folios.

Maybe it's more like "supports being cached".

folio_lru_caching_supported()

Something like that, maybe? (again, unclear about lru/mlock cache 
abstraction)


-- 
Cheers

David / dhildenb


