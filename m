Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC489CD98C5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 01:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1A4D6B0005; Wed, 10 Jun 2026 21:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCAEC6B0088; Wed, 10 Jun 2026 21:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C92966B008C; Wed, 10 Jun 2026 21:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5F986B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:20:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4094940178
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 01:20:08 +0000 (UTC)
X-FDA: 84865875696.20.ADEECBD
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id 24A9E1C000B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 01:20:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kpatvz6F;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781140806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=scSjPWWOjeCOLprmb3DPEGTo5b5uKBQjLRTFGKInqnk=;
	b=iHbXXezaYPzQxaiIFKuqqY9Elt8//eggfx1DIBZS2MXGavPwSgXgFvh7ydUxnlWfUPIY13
	aVPdtFrwVj1h/SUDSSpgR0PsIzy6vbw2i9+BUHVNpE+M9VC0mrKZoah+vs7CZFFDrcW1/3
	A0BjDU8sc3WU/ivq0o7s1QlI2p32BFM=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kpatvz6F;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781140806;
	b=oUPqY2yicuiSNhghUlbC7AW12glzxKvxiMpW3xqq2YVGcjZ3rROICwvdtKDHP8ZmgUmERg
	akgYheUyosqneYtxw5t3iUia+Kt2ZMoTsl8trp5JcUzKhWVA5VrVgxn15Rd0+7xT2eTChg
	w2JZyGPMxVrdi8qakfBDaFjZJm/C07M=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5aa6145f230so458669e87.3
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:20:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781140804; cv=none;
        d=google.com; s=arc-20240605;
        b=RyDtsDPVI2v+HR/SVa7IRqmuX3IA5XhYEqjrLSlJKjjq0qU6h25tTXN8dkL9kpo814
         HiBfNR/RFmRTu51a6mAD4yltopbfGhJZxvWkMmDVJrhv3BEGqlo+fkhHeA1HS0R+rVOx
         idTntYq3B6ZAxJfmIPoZxKQlM8RRDBPt2jy+7YfLB9WhDVaLUOdgGTxMU/uSR2uzXzSF
         inoL4t5Hy7GNVdWI+8QzTJKF9/NGlq4YFJRnFOMsoifP2c5uTaUYsa6C4rGuSllpJQKG
         KAB6e+LrRsPMJPFnBPyPIZjaJQEK9jDELCxsL+HXc4fIO09P2pjj2ORykWDKw3jbcIlG
         sluA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=scSjPWWOjeCOLprmb3DPEGTo5b5uKBQjLRTFGKInqnk=;
        fh=PnWkVEuReNyMol3P55bzVw7x/sklvGGbi4fCEEvJxdE=;
        b=Tt5hjimqZ+3NmKn/3ah7buX6+iALmuwUZgrLbPtJ43Q09RvlK8V3I/PAHA45Qyp5pr
         +iNVWVYJxlDy1K3Fd3T9uVRPloVW4d74xOy+oQ5rLp2PH0e1s5cJJf6KG/HPWUfF9IfK
         TSjZD1rGXeZKSzOaKrm1m3tJ+WNnokCsQLCsO+I0zYHwtNs2DehBt1l6xTY31Usv7UBf
         ikQmo1m7EbvJ0KaVY8pQBIu2Lz/NvPrqgEtlhSP2NXJ7X8Kju6DL2KBy/0F10yYdxf8+
         XBsZC55x+/zKnfDdx2C0eXCq/ztjDnBRR3lxj8f63/fKcyFRmSVIrxKNW49w5h9QK2MA
         l6bg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781140804; x=1781745604; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=scSjPWWOjeCOLprmb3DPEGTo5b5uKBQjLRTFGKInqnk=;
        b=Kpatvz6FBk4n3gh+2NN4ZELcerKrLNOzhMuHBUNplt3Q8T7gIdF7R2wc2pDm/R7tcg
         FJ0bLUT2zWEu+UpPtpxqsG147gB1GLJ3Bfpb8THPhRQ8Zyx/4zkoXO4DdfDA6wS5AEn7
         rxm0PTVnTAb9gvqSIuyUlxRT5h/wHiCJNXOik+Sfi/tbi3ml2UfGRiIPg4KaYWSr/Hzc
         SiJyT3YEB0A2w6HQUSPPETeYHQBYBETitAq/Ql4oJJSPHu5Rwp+bXsLu4bFhm2eZgkWb
         EderlTBw7iFmZWKiMFhoIA28wAAHVnzAmIF4uE3+J462I1UX5ZMkjLi7PZSs/KOjCaV5
         /iIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781140804; x=1781745604;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=scSjPWWOjeCOLprmb3DPEGTo5b5uKBQjLRTFGKInqnk=;
        b=LXcr/G/pGnoW8U/N+vQ7QgID54gu0milYFxb+uPtoj3LSvzvRAxf0zpfFstb7o9UcD
         qFHYIRcXfvOY45eGCKOfH1jcjvl3tkH/aJRHZ06gA2yQqSiXDiILoxCTEH176OIKDBJc
         FFAzDhlDsl4kKltBI9IUGvJcKNTAHKeOWoIrqyPzPRDYz7R8FSHyzLk6BmqCtTdpDsSd
         6wFeeq6GU4u/YALQs8Y3NyTgwwn6eI5i8LdbTsx7Nt7pUq9+M9jKPDf95MNnKoBttD6U
         4xHw20SIFcp5a1lEypfk9PklqPAeM3UpVLLhMEZ6fEfyLK8XjCWRcNM4hRvHSP57wRKl
         ZYVg==
X-Forwarded-Encrypted: i=1; AFNElJ92YGCpphDpbEbNVJDwqSXrZa/1FWbeAcjjOgwxHsZytHWrJn0vCThWUVQ4L5gkQesR+FmUqWhfHg==@kvack.org
X-Gm-Message-State: AOJu0YzhytwjMv0u4ggoF6/ema9eDdpDsrweS5rR1E9CFg/Rm+AJTiEx
	Y0Jb9RcnkUuQpef2T4t2m4tJuExxxtbDJ7aBDs4g23WbSgTHqCQJJh+DkAuJbR2paS2i8VVd/aa
	T4JuorTywmDN3w9he73yBhhw47qoI2/w=
X-Gm-Gg: Acq92OFlF9z7Lr0v+5aYY473BZKvDrPxcCe0S39U34pQ8h5B/Hx8lPeQuhsmdET7nk3
	WCLNbPFhC5oTYXVsW5pmjFdTstRCe9tlzmwUJEwev9TqL7WnPk2FdMeIg4xBXMtEPo1uFdbCuKU
	zJdUvdVmoFamIdOXzqDjzLZqcwWvbtwYu2UZ39pRiba4PIKMiU71bebxcgeObTmTJ7uqYoHcu9C
	OP/KnuVZFS12QQ8hZ0PCMq1KhOOWPJgzx4z67s6J6x0lv22SqpAEP4Sxi8J+MTOfauLL7hIIqpq
	znC+Xs/eM5pN7pZqa20=
X-Received: by 2002:a05:651c:18cb:b0:396:831a:ef36 with SMTP id
 38308e7fff4ca-3991a0a910amr390191fa.5.1781140803695; Wed, 10 Jun 2026
 18:20:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
 <b5393993-e75d-4e67-8dc2-85c9659ad27e@kernel.org> <4348A64F-30F9-4497-A839-A80BCFFCFFE0@nvidia.com>
 <12FE92F3-B8C3-4D4E-B86A-CC2034734466@nvidia.com> <F21E44A9-0FB7-47F8-86CC-6D38FD2CD24B@nvidia.com>
In-Reply-To: <F21E44A9-0FB7-47F8-86CC-6D38FD2CD24B@nvidia.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Thu, 11 Jun 2026 09:19:51 +0800
X-Gm-Features: AVVi8CfA5KxXx7IaNDC3w_SJfc17C_hxMEakIfQyeYCGZqEGfLO6OOqYNgxPsN8
Message-ID: <CAGWkznFfRnPg_FC9mjHKSUOJaj4Gjm5VQkMQ2tgY7fZ8Xuju9Q@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/huge_memory: do not add dropped split tail folios
 to LRU
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, steve.kang@unisoc.com, 
	"xiuhong.wang@unisoc.com" <xiuhong.wang@unisoc.com>, hao_hao.wang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 24A9E1C000B
X-Stat-Signature: z9kywsr1xnhrrc9a6ioycrck3b9bcyas
X-HE-Tag: 1781140805-546072
X-HE-Meta: U2FsdGVkX1/OVp1WSK79wJ3T4R5ivuFbEPgY8+AyRwavX5WmPoOjwn/YYixwnOmuggO/0xzfRLoKLNPuvFocZrLuJ9s9anr+e/AM/u7kPYnU0ttZjewVfaZwt6up644hMl/yBf4fKDzKF4EbgZlsWeVEWVqCiR8ZTXUSVGpyQd2bpFHy+J0tiUMHPFq/aQtOXlu30My42CcWlf89Bt8GpxjX2qijbUZjFjs+GZ96e9cQg+egvKniaRpjRju2GFT3GVNDCl0+QpIiWKJnLdhShtoTWaC3ENDxBb/14gPp0NLqOU/0K4EbFC93Ep7p1aPdnSDjH3MkGueGgeI3WXWlmGPEfijJ80vd7tAVDXmN2BsQZnWFSO1B2NQmQE6wDw8O4F2cARmVqsmOhek55g/osN/Ycl1fVDef6yumBDKVLLuipQS8+oIOGC4ZNd6fc/IPeB5/SZMPIleHZ6EnZ9+OQOvbno7uphqYaDky38Tp8wlCOxBdP9hPqMNa0z0vYvCtNv3bSpF1MNfNQEgBmZ7jP+rOppQfd6swTDQGO6bxLtkoFOcOiInW9kFB4zf5z2ir2pE9W/YhevPBc0p/uJgad4A7C8QAgekuuUnyo0NW2QFvY0onOl6Pfdqzl3/7nZpY9X2HHCqQ0o5ei2rcZD/4fl4kZWY3vU8IfsiK0Cny3V3RnJsdlBjMvm2oIB9vqIxOfK8N9FBq5eI6mUdfKdae+YNG8jeaqgMdC9XoTMe5UWulaaV72PJSJe1LaSvrSirjsOIg4L1lK/JrdsOdAIEbMzLQ9qYwtnVhsbjau/GknNf1HF+MEvQpl8u1FRcnlU63A6ZnAzxK7OMDrwY5ZzSNod+3GmpvwjcA7EBs5KfkXegmub6VsuHgen+do9wgcMp4BH36JtuGExjceo6N+tk8krOscwve6vA55IqGUixwF0O3nCgNgvvSw/InGhxskUpBK8WL7NaqxqTXRlTYKWw
 d1rRGD6K
 n0wXk4EratlLIaIUrfbfGJZsIrdGHBsWwhi9Rsy9xUQoPjxMZEJXKMsS9A87N0YOgAiBxNdeFdgUPUS+1eMbkbqB4mt0GvrML0ZaFNdFvhhXrpBId22nESU1Xdx4Xh1HtBAuozXGSQTixLCmg0L/zkr8Td2n2GFnsGHgh0t2/kWko3OjMRZQeTnduEOK7TAbn29y+r1Dp7Os8D4M5wTU/LQgt4lrqavB40rHg9lbf3ajq4S8sl3H70obyTbvJxziKb2E6ENMNM6oJW2Qf6SW2ugtA/OOhgklV6QA0RLjXQCeoQfRXzVeU5y/26F5ErlByDxfPGJjfj2aN3Z6Jn19pHh1WEtMUaP2fPEmQxXzHFmqr1ObxHXC1TWbSu5+afwQDWYG1+GbXygloA2XLU3sAkDCquxjGuZKL04NtMe4ZhKEEPyN5504v5FREMW8KLODOKlfk+91wkzN/AiZyVLuHL/y7KBvJiKHV+HwLPQZndEjkfij9cboUZWYCZy/4IlDS1jOlRxeBNjrm5K0a0ngqNuQoMK6RmUE7bIYnpc7xF1Q2WaN74z5VHITtF2gSEqiPRe84
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 2:44=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On 10 Jun 2026, at 13:25, Zi Yan wrote:
>
> > On 10 Jun 2026, at 10:38, Zi Yan wrote:
> >
> >> On 10 Jun 2026, at 8:50, David Hildenbrand (Arm) wrote:
> >>
> >>> On 6/10/26 14:05, zhaoyang.huang wrote:
> >>>> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >>>>
> >>>> The kernel panics are keeping to be reported especially when the f2f=
s
> >>>> partition get almost full. By investigation, we find that the reason=
 is
> >>>> one f2fs page got freed to buddy without being deleted from LRU and =
the
> >>>> root cause is the race happened in [2] which is enrolled by this com=
mit.
> >>>> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: =
remove
> >>>> non-uptodate folio from the page cache in move_data_block").
> >>>
> >>> But I assume, that other FSes can trigger this as well? Any insights?
> >>>
> >>>>
> >>>> There are 3 race processes in this scenario, please find below for t=
heir
> >>>> main activities. However, by further investigation over the code, I
> >>>> think there is a common race window for the truncated folios between
> >>>> split_folio_to_order and folio_isolate_lru, where the folios lost th=
e
> >>>> refcount on page cache and remains the transient one of the split
> >>>> caller, under which the folio could enter free path and compete with=
 the
> >>>> isolation process. This commit would like to suggest to have the fol=
ios
> >>>> beyond EOF stay out of LRU.
> >>>>
> >>>> Truncate:
> >>>> The changed code in move_data_block() lets the GC path evict the tai=
l-end
> >>>> folio from the page cache through folio_end_dropbehind().  Once
> >>>> folio_unmap_invalidate() removes the folio from mapping->i_pages, th=
e
> >>>> page-cache references for all pages in the folio are dropped.  The f=
olio
> >>>> is then kept alive only by temporary external references, which allo=
ws a
> >>>> later split to operate on a folio whose subpages are no longer prote=
cted
> >>>> by page-cache references.
> >>>>
> >>>> Split:
> >>>> After the page-cache references are gone, split_folio_to_order() can
> >>>> split the big folio into individual pages and put the resulting subp=
ages
> >>>> back on the LRU.  For tail pages beyond EOF, split removes them from=
 the
> >>>> page cache and drops their page-cache references.  A tail page can t=
hen
> >>>> remain on the LRU with PG_lru set while holding only the split calle=
r's
> >>>> temporary reference.  When free_folio_and_swap_cache() drops that fi=
nal
> >>>> reference, the page enters the final folio_put() release path.
> >>>>
> >>>> Isolate:
> >>>> In parallel, folio_isolate_lru() can observe the same tail page with=
 a
> >>>> non-zero refcount and PG_lru set.  It clears PG_lru before taking it=
s own
> >>>> reference.  If this races with the final folio_put() from the split =
path,
> >>>> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio=
().
> >>>> The page is then freed back to the allocator while its lru links are
> >>>> still present in the LRU list.  A later LRU operation on a neighbori=
ng
> >>>> page detects the stale link and reports list corruption.
>
> Something is wrong here with the caller of folio_isolate_lru(), since
> folio_isolate_lru() requires the caller to take an elevated refcount.
> This means when entering folio_isolate_lru(), the EOF folio should have
> at least refcount =3D=3D 2, 1 from folio_split(), 1 from the caller of
> folio_isolate_lru(). This should prevent the EOF folio being freed
> by the parallel __folio_put().
This is one of the key points for this issue. Could the isolate caller
grab the refcount(by folio_get but not folio_try_get) after the
spliter's folio_put->folio_put_testzero? If it may, then the panic
happens

                    CPU1 (split_folio_to_order)          CPU2
(folio_isolate_lru)

                            split_folio_to_order(F)
                              folio_ref_freeze(F, 1)
                              ...
                              lru_add_split_folio(T)
                                list_add_tail(&T->lru, &F->lru)
                                folio_set_lru(T)
                              __filemap_remove_folio(T)
                              folio_put_refs(T, 1)
                              /* T refcount =3D=3D 1, PageLRU set */
                            free_folio_and_swap_cache(T)
                              folio_put(T)
                                /* refcount: 1 -> 0 */

//caller grab the refcount here?

folio_isolate_lru(T)

folio_test_clear_lru(T)
                                __folio_put(T)
                                  __page_cache_release(T)
                                    folio_test_lru(T) =3D=3D false
                                    /* skip lruvec_del_folio(T) */
                                  free_frozen_pages(T)
                                                                  folio_get=
(T)

lruvec_del_folio(T)
>
> Hi Zhaoyang, can you elaborate on the folio_isolate_lru() caller?
Sorry, no. Split and isolate thing are merely assumption by the phenomenons=
.
>
> In addition (with the help of Claude), the race trace[2] below
> looks invalid. It says split happens after folio_end_dropbehind(),
> which sets folio->mapping to NULL, but __folio_split() returns -EBUSY
> when folio->mapping is NULL in filemap_release_folio() check.
> So the split cannot happen.
Could the folio_needs_release return false?

if (!folio_needs_release(folio))
return true;

>
> Now I am not sure if the bug report is valid or not. At least for
> folio_split() and folio_isolate_lru(), the race should not exist.
> But let me know if I miss anything.
>
> >>>
> >>> Complicated mess :(
> >>>
> >>> So, folio_isolate_lru() really only requires the caller to hold a fol=
io
> >>> reference, which can happen given that we did the folio_ref_unfreeze(=
). It can,
> >>> for example, be triggered by memory offlining or page migration.
> >>>
> >>> So we really want to not allow folio_isolate_lru() while we are still=
 processing
> >>> the folio.
> >>
> >> Or we should defer adding split folios to LRU after unfreeze.
> >>
> >>>
> >>> What your patch does is, simply not add folios that we will drop from=
 the page
> >>> cache to the LRU?
> >>>
> >>>
> >>> You should describe here how you are fixing it: "Let's fix it by..."
> >>>
> >>>>
> >>>> [1]
> >>>> [   22.486082] list_del corruption. next->prev should be fffffffec10=
e0ac8, but was dead000000000122. (next=3Dfffffffec10e0a88)
> >>>> [   22.486130] ------------[ cut here ]------------
> >>>> [   22.486134] kernel BUG at lib/list_debug.c:67!
> >>>> [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SM=
P
> >>>> [   22.488502] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE
> >>>> [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
> >>>> [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS=
 BTYPE=3D--)
> >>>> [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
> >>>> [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
> >>>> [   22.488539] sp : ffffffc08006b830
> >>>> [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 0000=
000000000000
> >>>> [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: ffff=
fffec10e0ac0
> >>>> [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead=
000000000122
> >>>> [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ffff=
ffc080061060
> >>>> [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 0000=
000000000058
> >>>> [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 0000=
000000000003
> >>>> [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe8=
5721f0e25f00
> >>>> [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c65=
645f7473696c
> >>>> [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 0000=
000000000010
> >>>> [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000=
00000000006d
> >>>> [   22.488647] Call trace:
> >>>> [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
> >>>> [   22.488661]  __folio_put+0x2bc/0x434
> >>>> [   22.488670]  folio_put+0x28/0x58
> >>>> [   22.488678]  do_garbage_collect+0x1a34/0x2584
> >>>> [   22.488689]  f2fs_gc+0x230/0x9b4
> >>>> [   22.488697]  f2fs_fallocate+0xb90/0xdf4
> >>>> [   22.488706]  vfs_fallocate+0x1b4/0x2bc
> >>>> [   22.488716]  __arm64_sys_fallocate+0x44/0x78
> >>>> [   22.488725]  invoke_syscall+0x58/0xe4
> >>>> [   22.488732]  do_el0_svc+0x48/0xdc
> >>>> [   22.488739]  el0_svc+0x3c/0x98
> >>>> [   22.488747]  el0t_64_sync_handler+0x20/0x130
> >>>> [   22.488754]  el0t_64_sync+0x1c4/0x1c8
> >>>>
> >>>> [2]
> >>>> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU=
2 (folio_isolate_lru)
> >>>>
> >>>> F: pagecache refs =3D n
> >>>> F: extra refs =3D GC + split
> >>>> F: PG_lru set
> >>>> move_data_block()
> >>>> folio =3D f2fs_grab_cache_folio(F)
> >>>> ...
> >>>> __folio_set_dropbehind(F)
> >>>> folio_unlock(F)
> >>>> folio_end_dropbehind(F)
> >>>>   folio_unmap_invalidate(F)
> >>>>     __filemap_remove_folio(F)
> >>>>     folio_put_refs(F, n)
> >>>> folio_put(F)
> >>>>                             split_folio_to_order(F)
> >>>>                               folio_ref_freeze(F, 1)
> >>>>                               ...
> >>>>                               lru_add_split_folio(T)
> >>>>                                 list_add_tail(&T->lru, &F->lru)
> >>>>                                 folio_set_lru(T)
> >>>>                               __filemap_remove_folio(T)
> >>>>                               folio_put_refs(T, 1)
> >>>>                               /* T refcount =3D=3D 1, PageLRU set */
> >>>>                             free_folio_and_swap_cache(T)
> >>>>                               folio_put(T)
> >>>>                                 /* refcount: 1 -> 0 */
> >>>>                                                                   fo=
lio_isolate_lru(T)
> >>
> >> If refcount is 0 at this point, VM_BUG_ON_FOLIO(!folio_ref_count(folio=
), folio) in
> >> folio_isolate_lru() would be triggered. Maybe we could just return fal=
se in that case.
> >>
> >>>>                                                                     =
folio_test_clear_lru(T)
> >>>>                                 __folio_put(T)
> >>>>                                   __page_cache_release(T)
> >>>>                                     folio_test_lru(T) =3D=3D false
> >>>>                                     /* skip lruvec_del_folio(T) */
> >>>>                                   free_frozen_pages(T)
> >>>>                                                                   fo=
lio_get(T)
> >>>>                                                                   lr=
uvec_del_folio(T)
> >>
> >> But in CPU2 (folio_isolate_lru), lruvec_del_folio(T) should remove T f=
rom LRU list.
> >>
> >>>> later:
> >>>>   list_del(adjacent->lru)
> >>>>     next =3D=3D &T->lru
> >>>>     next->prev =3D=3D LIST_POISON / PCP freelist
> >>>>     BUG
> >>>>
> >>
> >> Why does CPU0 still see the stale link from adjacent?
> >>
> >>>> Assisted-by: Cursor:claude-opus-4-8
> >>>> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >>>
> >>> I'm wondering if this has been broken the whole time, or if some rewo=
rk allowed
> >>> this to trigger.
> >>>
> >>> I assume the issue can be triggered for other FSes, and we want Fixes=
: + CC: stable?
> >>>
> >>> Looking into the history, I think we always unconditionally did the
> >>> lru_add_split_folio()/lru_add_page_tail().
> >>>
> >>>> ---
> >>>>  mm/huge_memory.c | 2 +-
> >>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >>>> index 970e077019b7..7465525a94a8 100644
> >>>> --- a/mm/huge_memory.c
> >>>> +++ b/mm/huge_memory.c
> >>>> @@ -3966,7 +3966,7 @@ static int __folio_freeze_and_split_unmapped(s=
truct folio *folio, unsigned int n
> >>>>                    folio_ref_unfreeze(new_folio,
> >>>>                                       folio_cache_ref_count(new_foli=
o) + 1);
> >>>>
> >>>> -                  if (do_lru)
> >>>> +                  if (do_lru && !(mapping && new_folio->index >=3D =
end))
> >>>
> >>> It might be clearer to write this as
> >>>
> >>>     do_lru && (!mapping || new_folio->index < end)
> >>>
> >>> To match the page-cache check further below
> >>>
> >>>     if (!mapping)
> >>>             continue
> >>>
> >>>     ...
> >>>     if (new_folio->index < end)
> >>>             ...
> >>>
> >>>>                            lru_add_split_folio(folio, new_folio, lru=
vec, list);
> >
> > Talked to Claude and find an accounting issue with this. Without puttin=
g
> > EOF after-split folios back to LRU, they are not going through lruvec_d=
el_folio(),
> > which decreases NR_*_LRU counter along with removing the folio from LRU
> > and it causes NR_*_LRU accounting errors. Note that the original folio
> > is on LRU all the time and LRU counters are not modified and after the =
split
> > the original folio size is decreased and the after-split folios need to
> > be added back to LRU to keep the LRU counters right. We will need to ad=
just
> > LRU accounting for (!mapping || new_folio->index < end) if we decide to
> > not add them back to LRU.
> >
> >
> > Best Regards,
> > Yan, Zi
>
>
> Best Regards,
> Yan, Zi

