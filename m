Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05CCDCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 16:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 273946B000D; Wed, 27 Aug 2025 12:18:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24B246B000E; Wed, 27 Aug 2025 12:18:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187E86B002A; Wed, 27 Aug 2025 12:18:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05A616B000D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:18:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A67B7BA8F0
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:18:37 +0000 (UTC)
X-FDA: 83823045474.25.FEA8D95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D18BB180019
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:18:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nmDWPNTe;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756311516; a=rsa-sha256;
	cv=none;
	b=yjq5eB4VutdFmsde0AhRXNaMVSzJ+AgHdqXNQsXnGVyYFbq9QrPaC0x4nkIOpcbV8xrmNN
	SAkIg4/9A/9Rx6U+zKlhvBHHGR3o1rjIDQL4buXOau+B/0rKDfgrern/DKToHVhj5SSCwG
	JmOzUBrZlS3G21UNHcI5SwQcFqsaASQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nmDWPNTe;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756311516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tfoPaaeOIRNCfEepHGnQn4iKbImNgrLO4uQ+UyF8jpM=;
	b=07L/4pJO5gmddID2UxqWKyvbCTebuXFEjjtdxfUo6B0/AMy1VPQi7+hkJpAcXTrDmOb9Af
	xoRabiYKqiYLRDmlg+49TwbYe1be0cZ+0X/9yxM+NJo7Uw3xTw5XJObmCI4Rk/MLqJW0yb
	G5ALJDZ7qfy2WFFty2Zh6njZsryGSYA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A5981401C8;
	Wed, 27 Aug 2025 16:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFF3C4CEEB;
	Wed, 27 Aug 2025 16:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756311514;
	bh=28j+S/AtE11EZh6wqHFI1d6l2NcH4n7hMOYZwMPL8LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmDWPNTelfD/NRgVrsRxG+nJkWkrNTMjTXii7PepcV7C18daPPt/ALdgDI2p7+XUw
	 ieYdCH9jmTvedk7vUbDgqllmQnTRK4FttkqI54pIqjkKtfhRp8OQnkmgv4BgcbgjmE
	 xP5oUmn//0iXEWd9BxE37u4+sB6ED0viyMOtvnUKVxiTb9ox3uFGAHegnUX0nyIZW+
	 FmSfEfmNfgYMnA9wcsH0bSRPnn0T5XIAofLHahCQSY2iAA1nf98EIPk2xP7KDsznnq
	 ybV/gyWx8zwZ+OM0lFkCS+mAG6s+cmJ6RIrdHSHak+ljOyu8JlXgUSja+36wMfMCgq
	 eJCp8MN4yd9QQ==
From: SeongJae Park <sj@kernel.org>
To: Chris Li <chrisl@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v5] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Wed, 27 Aug 2025 09:18:32 -0700
Message-Id: <20250827161832.164192-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CACePvbWGPApYr7G29FzbmWzRw-BJE39WH7kUHSaHs+Lnw8=-qQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D18BB180019
X-Stat-Signature: 811izpzjzd1d474rja4p9jkyzjy544d9
X-Rspam-User: 
X-HE-Tag: 1756311515-953058
X-HE-Meta: U2FsdGVkX19kl4JVjcXYY+sdpUpQN9rMN5DWJogiB3SOKdQG0Kisq6QQVreoME4bTTqXNNKY07BUpGggsOxlG2X9/Lv2ENdE/j6rrl+k5Hzyu6HIFfQ/WaSX2XHkFnuhysfSi01f5s8BtbVM2LjyraKl6jZK1t9Mc5HfkRAeZdppBErCoGBcrVlRhpEct0ioY3cWHVzeeE5IpTgAdwjuCCtHIHDNWGsDjZlaTS40y6eO5y42muzwWHeIkFwBmhec2IDpjaSXOWLo+9d+iqCwhqGSlRPmzXUh01ak6275KjBDDpiiOj7T6x/P23zTxPIGH9I1Sn/CLWfLzT4LUjt8oyj7ujTOepCwSMArc3ERZWWFjehPrgasdHc+O4pOXGGzEggj5yRlVjaJahwJPkKmtP5MnHiSBKQHphCpuIINwxK8hGVlq/uFktcknKtGbOk2Czotyc3fXkRzczEioul4uZ5Jy2mgMrT5iZw+VSWDR4L2u8Yxkvt03M8d/qPWff0U85Hh/Om/tkaaiQGEdb3WKIrnxZihCSGjr1ahuPRYFfWRhGaShXqeaIm/4cZA8B2o36ADlsVFYgX8yAa8jFsJCLxqXKWM4JEE+ZBkFDDjHCnGok5aR+9LZwSdccGABqtqDGR+nt+mE8lulhteP96pNofSTIgiGZx5eHXVcUtWU6DQZXcBxq5/XW/WjgY7OVgdVSauFOTAVKN9A4nssxlKgpXw/xm8sYmtFlUEGPnGOelrYZIIzYL0B9268AL9WCVeMGk8IvcEm+pveE8fDTjam2D2SPIyr+spaqvObB3zxu68w+eE+66UGvSBJT68yoBMHviQDri7aAl0zPNNYGCPJN0cH8YGR0BLk5M5cAqiCs0GSQBezit0ouKfucnIfIsEivL/S+8NniBKHVulMF+7uPsboU6WUoBhgAZm7pG6heQ2LdPzn+8wfaqju2gEXV1JaUXb9R+w4L+MR4ev1xP
 o7MBgqJw
 2vxLB5ZEUDPkGkZDoVLvjXjVNnOB64b2Rl4NcbLwZJv6c3vdnhXL4iWxjJw97mtzUcusPKaDpmyWpM5LPDM5d/KTkAz2bHBBCGrN/gENaywMQeoZN4GoJyuyE3LrDHBBmwEYR/Vqkb4DWyq6dr4BgFQF5OEe1LLHaphb41k9Hr7MVeTfWzrLyglsNc92By2e3lj8cHU7gxcyx9/8nVW7LPdw5xa/yfMmO/6/OW2tPGuju7a4inK7VlE3dud0FtWDLfQngwTSx1dPYIkxqEEGXX1n9J6Y4lECsH23eh4jXPkivEPzchvmQJjb78A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 Aug 2025 08:52:35 -0700 Chris Li <chrisl@kernel.org> wrote:

> Hi SeongJae,
> 
> I did another pass review on it. This time with the editor so I saw
> more source code context and had more feedback.
> Mostly just nitpicks. See the detailed comments below.

Thank you for your review!

> 
> On Fri, Aug 22, 2025 at 12:08 PM SeongJae Park <sj@kernel.org> wrote:
> > @@ -971,8 +975,26 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> >          */
> >         comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
> >         dlen = acomp_ctx->req->dlen;
> > -       if (comp_ret)
> > -               goto unlock;
> > +
> > +       /*
> > +        * If a page cannot be compressed into a size smaller than PAGE_SIZE,
> > +        * save the content as is without a compression, to keep the LRU order
> > +        * of writebacks.  If writeback is disabled, reject the page since it
> > +        * only adds metadata overhead.  swap_writeout() will put the page back
> > +        * to the active LRU list in the case.
> > +        */
> > +       if (comp_ret || !dlen)
> > +               dlen = PAGE_SIZE;
> > +       if (dlen >= PAGE_SIZE) {
> 
> I think these two if can be simplify as:
> 
> if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
>               dlen = PAGE_SIZE;
> 
> then you do the following check.
> That way when goto unlock happens, you have dlen = PAGE_SIZE related
> to my other feedback in kunmap_local()
> 
> > +               if (!mem_cgroup_zswap_writeback_enabled(
> > +                                       folio_memcg(page_folio(page)))) {
> > +                       comp_ret = comp_ret ? comp_ret : -EINVAL;
> > +                       goto unlock;
> > +               }
> > +               comp_ret = 0;
> > +               dlen = PAGE_SIZE;
> 
> Delete this line if you use the above suggestion on: dlen = PAGE_SIZE;

Thank you for nice suggestion!

> 
> > +               dst = kmap_local_page(page);
> > +       }
> >
> >         zpool = pool->zpool;
> >         gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
> > @@ -985,6 +1007,8 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> >         entry->length = dlen;
> >
> >  unlock:
> > +       if (dst != acomp_ctx->buffer)
> > +               kunmap_local(dst);
> 
> I think this has a hidden assumption that kmap_local_page() will
> return a different value than acomp_ctx->buffer. That might be true. I
> haven't checked the internals. Otherwise you are missing a
> kunmap_local(). It also looks a bit strange in the sense that
> kumap_local() should be paired with kmap_local_page() in the same
> condition. The same condition is not obvious here.

Good point, I agree.

> How about this to
> make it more obvious and get rid of that assumption above:
> 
> if (dlen = PAGE_SIZE)
>                kunmap_local(dst);

However, if the execution reached here because compression failed and writeback
was disabled, kmap_local_page() wouldn't be called, so we could try to unmap
unmapped memory.

What do you think about adding another bool vairable for recording if
kunmap_local() need to be executed?  For example,

"""
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -952,6 +952,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
        struct zpool *zpool;
        gfp_t gfp;
        u8 *dst;
+       bool dst_need_unmap = false;

        acomp_ctx = acomp_ctx_get_cpu_lock(pool);
        dst = acomp_ctx->buffer;
@@ -994,6 +995,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
                comp_ret = 0;
                dlen = PAGE_SIZE;
                dst = kmap_local_page(page);
+               dst_need_unmap = true;
        }

        zpool = pool->zpool;
@@ -1007,7 +1009,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
        entry->length = dlen;

 unlock:
-       if (dst != acomp_ctx->buffer)
+       if (dst_need_unmap)
                kunmap_local(dst);
        if (comp_ret == -ENOSPC || alloc_ret == -ENOSPC)
                zswap_reject_compress_poor++;
"""

> 
> That assumes you also take my suggestion above to assign dlen PAGE_SIZE earlier.
> 
> 
> >         if (comp_ret = -ENOSPC || alloc_ret = -ENOSPC)
> >                 zswap_reject_compress_poor++;
> >         else if (comp_ret)
> > @@ -1007,6 +1031,14 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
> >         acomp_ctx = acomp_ctx_get_cpu_lock(entry->pool);
> >         obj = zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buffer);
> >
> > +       /* zswap entries of length PAGE_SIZE are not compressed. */
> > +       if (entry->length = PAGE_SIZE) {
> > +               memcpy_to_folio(folio, 0, obj, entry->length);
> 
> The following read_end() followed by acomp unlock() duplicates the
> normal decompress ending sequence. It will create complications when
> we modify the normal ending sequence in the future, we need to match
> it here.How about just goto the ending sequence and share the same
> return path as normal:
> 
>  +                  goto read_done;
> 
> Then insert the read_done label at ending sequence:
> 
>         dlen = acomp_ctx->req->dlen;
> 
> + read_done:
>         zpool_obj_read_end(zpool, entry->handle, obj);
>         acomp_ctx_put_unlock(acomp_ctx);

I agree your concern and this looks good to me :)

> 
> If you adopt that, you also will need to init the comp_ret to "0"
> instead of no init value in the beginning of the function:
> 
>         struct crypto_acomp_ctx *acomp_ctx;
> -        int decomp_ret, dlen;
> +       int decomp_ret = 0, dlen;
>         u8 *src, *obj;

We may also need to initialize 'dlen' as PAGE_SIZE ?
> 
> 
> > +               zpool_obj_read_end(zpool, entry->handle, obj);
> > +               acomp_ctx_put_unlock(acomp_ctx);
> > +               return true;
> 
> Delete the above 3 lines inside uncompress if case.
> 
> Looks good otherwise.
> 
> Thanks for the good work.

Thank you for your kind review and nice suggestions!  Since the change is
simple, I will post a fixup patch as reply to this, for adopting your
suggestions with my additional changes (adding dst_need_unmap bool variable on
zswap_compress(), and initializing dlen on zswap_decompress()) if you have no
objection or different suggestions for the my addition of the changes.  Please
let me know if you have any concern or other suggestions for my suggested
additional changes.


Thanks,
SJ

> 
> Chris
> 

