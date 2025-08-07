Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC27C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 23:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D01348E0002; Thu,  7 Aug 2025 19:54:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8AAE8E0001; Thu,  7 Aug 2025 19:54:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B52488E0002; Thu,  7 Aug 2025 19:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A24FA8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:54:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A2741A033F
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 23:54:34 +0000 (UTC)
X-FDA: 83751618468.13.ACF11FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 75BB31C0008
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 23:54:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sv2aohvv;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754610872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JyWGAG/dPC0bpWAmwlYju0LKA2Xe07/DJLht8zkW6FU=;
	b=fkxBJH1CEwKhP9RbUHOF/xFAY4vpTUh7E0eMkixmttDqQexddvzyya6c5p/uOto6oyTMYb
	zL6unLQqcfJJSBgOelYUMdklc8V6HCCNUHGlpbgtIqzmxf6+H3NjAHXmLT3GvdOT+n60vB
	suDF2fXPIqmgofyzxKZsYfEhy0cdsNM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754610872; a=rsa-sha256;
	cv=none;
	b=sVuDrM8WnM49Rwaz4U6EXSZwRp2XqdpHuysXQF24ANh6mRC+WfdQ/MyFh2Zrhybv0iIiwD
	fpkR0wVuiHv6Udhl8uABJ0B8AYcZE5M+Hnss2HZyzhPtgQK+Hslduv/xbhBbg+CUnaWZvZ
	a2wxILs3zSMgqim+i4efs5yIFX9UjmY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sv2aohvv;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4554E43D3D;
	Thu,  7 Aug 2025 23:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28D8C4CEEB;
	Thu,  7 Aug 2025 23:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754610871;
	bh=vEYB2B88OUYFZ5LJS94X33b1uoKVdexcX7humGXPCHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sv2aohvvZW0xLewCgqt06zb9IoeAT+DQJcnmMDk786BqmJTklbJgsXvZ+/cqpsNkd
	 XpCelYCWtt0JX1PPLRRmTs10zZ0ouua/199VULrZHsOrGItZNNpDthibBzCIzxHgsu
	 e4NqEzn6t3aO9fYnJe+QH4bjNIA67rI785ZMPFHGEVEiArWlNLdiM9ytZ6aWMAZC0e
	 mAm+uWxpOD0OdwOMJtKki2q+AIOMc8lSroIu8MpS+E51GFZqRnsNgnVx0w6Plu2wbG
	 93PiAmEZGPGJADVeosEwk6PZ0ZR0+I/JfiZOFT/shobVXEX21H2JmJtnbhL7IAOdna
	 Fnz4gS835X+Zw==
From: SeongJae Park <sj@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>
Subject: Re: [PATCH] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Thu,  7 Aug 2025 16:54:27 -0700
Message-Id: <20250807235427.4743-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CAKEwX=Nm08xZVR0Zk2fOvXBmeWe5wggvTXN6+hD84S7T9L=eBQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 75BB31C0008
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ddz5gyqex6gujycpymxjd1sctnw8xjfs
X-HE-Tag: 1754610872-247314
X-HE-Meta: U2FsdGVkX18ujfywyGPWMwUr4DYxh5KINha3+vM1nrLVDKBpQcn9A8/TrYhhfD/AMM9wEHq1HbNyxj47jBJ6k87/pQYDSa0X74uedI2DPnrcYLpnQ0/sSTTFdjcpwIcO8YdB1h19AhBX6O3N11A0kFMJrkt4g7u3jbYY3gyKI/lJJUC0a0PQMR4nAJ/nlVVCh6n2jFrpj7zYv6zUcyb2V6NdIdZ0bhX35IDZA2HgSmzrbEnB75Cz1DSaudJEp1Kc65Dz+P0hg1ZFCXoOlCFtLpMUPxu2sx5a54TSFb7v4W7nZfEJ4FoEYJBqDusvxLEVe5N31qkvC/sT5nw/feZfTyVO4DketX/qKiM0YBusdu74YBAfbJs1Wn8+/jR8rQ5wcmOseDakt8XNuAr5/OIRieMsQMZeUEawdi5zaib0VR3Mla+l8DN0KITyfQLXgYovxg2TktU/mjY0BtT2bnfodSH9yGZkvFCooyZsa/07ucXNht8sfByQJZ2mJkKIMtu7LdVfAHl4g1gWxXB+Tn7G4Y43hQBk49ZxOHa02g2vheh8lBNlMg1PuL70LjLSwwMPm/Q3glg+2ulIy3MlPsyC2IjuE2ytvPgOW3Ex6GSEUdlgTo7uqqqZVC/8SPo9W2BlBUoxyQvx3c6elf9R9jt8IrtuVjuML8CPnVgM+pJuDbP8nf6nhklQIqhgBOIIY2EZTthY0sEbzkhbo9q5P4avnVcqXoI9qHg/DoiBuePkK0MVHT1PudpdliiqerScxOgaQi+aPJ+FySxaCMb8Zx43R+Bvagu3Lw55TZC5EqIcitpvbDX0HM9ywz7ALReNOYJCr7fTrfhaeiKMUROr9M/U+px3RU08eWIqLMQDqZVtnC6vY6SH7ACMWBUhhdxnfdNfh1k0Ak8bbYDq0ZtTkEmHxJee3bInuyi9k0QbGzFSL9qQIuxigDZf0K9ZKAzuif3bQ9oOFZgodkXIb0Adu78
 y25emt+A
 nTiV7snAAPSo7JUOpMNrZf84hTpOlqS0GkxN2vCFcbxwYsDYd1LVt7bivbcACPW8cYDi9l7a6QQhja70O7wk05t26/hMsM54s6ECDLp+E7BdXAYAGtNRYI01U1MrkIyy53riNzy+DbeEzBAXhBsJ3SPaEsvKBFEGLZJJAMTkQzlGCy0n+W0SooZawWWSz0r+aVUs1VFzqqsJnEEIgzpEHdMdZ8AiWipyDLGH5wH5y9CnrQ7zItyCtMDoznaf7Hc/HYVbQ6q1NhWeoMKALTHiO64G/eW1nQc2AzWFXxMqHxQcBs510iexOi0zqD9wul4QGbOIaEWFIbvWCS+FTYXIRwOohRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 Aug 2025 16:03:54 -0700 Nhat Pham <nphamcs@gmail.com> wrote:

> On Thu, Aug 7, 2025 at 11:16 AM SeongJae Park <sj@kernel.org> wrote:
> >
> > When zswap writeback is enabled and it fails compressing a given page,
> > the page is swapped out to the backing swap device.  This behavior
> > breaks the zswap's writeback LRU order, and hence users can experience
> > unexpected latency spikes.  If the page is compressed without failure,
> > but results in a size of PAGE_SIZE, the LRU order is kept, but the
> > decompression overhead for loading the page back on the later access is
> > unnecessary.
> 
> Maybe add the writeback disabled story - we added to get around this
> latency issue, but that solution was not satisfactory either: wasting
> cpu cycles retrying incompressible pages, especially when we're under
> reclaim/memory pressure, and we've reclaimed most if not all other
> sources.
> 
> This problem was pointed out by Yosry:
> 
> https://lore.kernel.org/all/CAJD7tkZXS-UJVAFfvxJ0nNgTzWBiqepPYA4hEozi01_qktkitg@mail.gmail.com/

Thank you for sharing the detailed context, I will add this history with the
link to the last paragraph of this section, or the 'Related Works' section.

> 
> >
> > Keep the LRU order and optimize unnecessary decompression overheads in
> > those cases, by storing the original content as-is in zpool.  The length
> > field of zswap_entry will be set appropriately, as PAGE_SIZE,  Hence
> > whether it is saved as-is or not (whether decompression is unnecessary)
> > is identified by 'zswap_entry->length = PAGE_SIZE'.
> >
> > Because the uncompressed data is saved in zpool, same to the compressed
> > ones, this introduces no change in terms of memory management including
> > movability and migratability of involved pages.
> >
> > This change is also not increasing per zswap entry metadata overhead.
> > But as the number of incompressible pages increases, total zswap
> > metadata overhead is proportionally increased.  The overhead should not
> > be problematic in usual cases, since the zswap metadata for single zswap
> > entry is much smaller than PAGE_SIZE, and in common zswap use cases
> > there should be a sufficient amount of compressible pages.  Also it can
> > be mitigated by the zswap writeback.
> >
> > When the writeback is disabled, the additional overhead could be
> > problematic.  For the case, keep the current behavior that just returns
> > the failure and let swap_writeout() put the page back to the active LRU
> > list in the case.  It is known to be suboptimal when the incompressible
> > pages are cold, since the incompressible pages will continuously be
> > tried to be zswapped out, and burn CPU cycles for compression attempts
> > that will anyway fails.  One imaginable solution for the problem is
> > reusing the swapped-out page and its struct page to store in the zswap
> > pool.  But that's out of the scope of this patch.
> >
> > Tests
> > -----
[...]
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -976,8 +976,25 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
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
> > +       if (comp_ret || dlen >= PAGE_SIZE) {
> > +               if (mem_cgroup_zswap_writeback_enabled(
> > +                                       folio_memcg(page_folio(page)))) {
> > +                       comp_ret = 0;
> > +                       dlen = PAGE_SIZE;
> > +                       memcpy_from_page(dst, page, 0, dlen);
> 
> I wonder if we can save one memcpy here. Would it be safe to map the page:
> 
> dst = kmap_local_page(page);

Sounds good, I will do so in the next version.

> 
> then, after we're done with storing (i.e after zpool_obj_write()), do:
> 
> if (dlen = PAGE_SIZE)
>     kunmap(dst);
> 
> (don't forget to unmap the page in the failure paths too!)

Sure, I think the 'unlock' label would be appropriate part to add the unmap
code.  I also got your correction of s/kunmap/kunmap_local() in the reply.  I
will not miss that on the next version.

> 
> > +               } else {
> > +                       comp_ret = comp_ret ? : -EINVAL;
> 
> Does this keep the value of comp_ret if comp_ret != 0 lol.

Yes.

> Syntax
> looks weird to me.

I agree it could look weird.  I prefer keeping the code in a way more familiar
to ones who will keep maintain the file.  So I will modify this as below, in
the next version.

    comp_ret ? comp_ret : -EINVAL

> 
> > +                       goto unlock;
> > +               }
> > +       }
> 
> Also, can we fix the counter value?
> 
> I assume we want:
> 
> else if (comp_ret || dlen = PAGE_SIZE)
>      zswap_reject_compress_fail++;
> 
> or something like that.

I'm not very clearly getting your point.

I was thinking we should increase the counter if we "reject" the page (does not
save the content in the zpool) due to failing at compressing the page's content
into a size smaller than PAGE_SIZE.  This patch implements the behavior.

Am I missing a mis-implementation of the behavior in this patch, or the
behavior is not what you think it should be?  More elaboration of your point
would be helpful for me.

> 
> And what happened to the incompressible page stored counter? :)

I don't get what counter you are asking about.  Could you please elaborate?

> 
> 
> >
> >         zpool = pool->zpool;
> >         gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
> > @@ -1012,6 +1029,14 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
> >         acomp_ctx = acomp_ctx_get_cpu_lock(entry->pool);
> >         obj = zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buffer);
> >
> > +       /* zswap entries of PAGE_SIZE are not compressed. */
> of length?

Thank you for this nice suggestion, I will change the comment so, in the next
version.

> 
> 
> > +       if (entry->length = PAGE_SIZE) {
> > +               memcpy_to_folio(folio, 0, obj, entry->length);
> > +               zpool_obj_read_end(zpool, entry->handle, obj);
> > +               acomp_ctx_put_unlock(acomp_ctx);
> > +               return true;
> > +       }
> > +
> >         /*
> >          * zpool_obj_read_begin() might return a kmap address of highmem when
> >          * acomp_ctx->buffer is not used.  However, sg_init_one() does not
> >
> > base-commit: 2ec534125ae474292175ae198483c545eac2161d
> > --
> > 2.39.5
> 

Thank you for your nice review and comments :)


Thanks,
SJ

