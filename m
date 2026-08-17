Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6032AC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 00:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0DFA6B08C9; Sun, 16 Aug 2026 20:29:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE48B6B08CB; Sun, 16 Aug 2026 20:29:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3A96B08CC; Sun, 16 Aug 2026 20:29:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6606B08C9
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 20:29:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 18A61A0621
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:29:32 +0000 (UTC)
X-FDA: 85108877784.26.2A8CEB4
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2C85240002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:29:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=F3CrVo+J;
	spf=pass (imf11.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786926570;
	b=hW9TE2PBU8Z19+5BqIU4Vb2L0upICpZWrZ7XyB2pEdOoFl07SXMHE+OtKbLyhz4cmaxJtj
	iyrgIj7GbFGqtXhjwdudZZRtlOFSAuvdhQWOWXQtlQylxZjrAOyCrmrp5gQQThSzYsibJ4
	HZM/YHFHjy/kQ37Mkj3P6uID+LjTwEw=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=F3CrVo+J;
	spf=pass (imf11.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786926570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=isn6HdNAuHUYg47UPl5+Ny0iT08WidXyLHjL5whsUGg=;
	b=mfOmFBGJJHSWDq+QJlj0vClO2lZW9bYTAKPpcHmxdm6TZeWWYXaxrdGNIBIJjWoV02uFSD
	W23wofrJoRPkhbyHlz3WFfQG8GsEd/lsDj2IjRcY+67lDXGAyBwwfnadL+boDmm145RKf3
	63SgqSJIzv9AcgV5Lrypvjq6P+rQiaE=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-495509b08ebso93255e9.1
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 17:29:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786926569; cv=none;
        d=google.com; s=arc-20260327;
        b=DO55VO6cSTiKPhPFRSnLorMZ01zFzULD7ToXylEzniOZLbbTOz8adURxGFA7DoIaF1
         ZkPNs8lLnZZW8c7Hl7X58UC5q4HmkcMbSa2ccnfjg/0pUosxz1UmksiuHlOQ9O3RU6re
         aHtW5oHnhvIaJKxBxBfe+d8tzSnDixT7/KcQZ8VqhtJpF7386DWU2eS6fOQNCN8tlPnN
         WUeZg23WqjEN/hpdcc0I+7lJAC3wXWeov3gzD0zXqo5jXGrUhD1X9LCDGZPfo94tnp6+
         7nDcR+ymF8atk0TwCLmCyolnQ8/jm9GTl3l6b2X+rFbZ9rU2FZQGSjyWuGexLahTPZYt
         Wbaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=isn6HdNAuHUYg47UPl5+Ny0iT08WidXyLHjL5whsUGg=;
        fh=6+tmSccJBplHEhDpJ3Y4Un6CIqApPfejCweHoXKAgZw=;
        b=sokNFZShuBik/IpiZ7FtXqBVk1sIMhpU2/35HFwzEG4m14llzu4ieyANw8nUepcYVi
         D/GSZyTUU5b3JWfz7t2ZNfvFIoywHsem65iPz7PgnHbgM8jWw2PMHMAcL2yRZNWFdlfo
         0TYPlWFiumG+fp+iq6NuxeEJ1+hOUFkgoGRI7Xb9TRarh5N4i6F2K/OB/7MflueJJQER
         1lmzX9BDmdUhvhlzblW2fhc9gXeay0oCdwHpEaOkMkssmwGDpeXVUC7SDCKFwrGAsgUe
         6CrYuH922WH0CYX9O3qgmSZD9fxtwGxs57fsFSByghWVbpjgvbul9OBRa4lauIgdNAqJ
         xdFw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786926569; x=1787531369; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=isn6HdNAuHUYg47UPl5+Ny0iT08WidXyLHjL5whsUGg=;
        b=F3CrVo+JuS4boCET1vkq5nQps+4JXANVg0mA7apsu0c+bnj5RKMvsCdzGAXuSMPiaL
         pbK+somuwRMt0JOFBU/Q1gJ76jzI4nfcLfiRYCLh+vSLmQh9gZnzZL9AzqBT6bbTWliz
         K62DtD6JqZBtuq7H0AVaYQe3w3UbLuExP3Tp2+R9icxpR8AcFv/F/E2NLIljpCgSlP04
         Wiop5Ghc9plrSVnUuhHCf9V/2B4DNWEQrEaFqpiH/LN4Ww/SEg5MUD/GFrR+wJ/Nqf5X
         VfFGhXg/ryMpTkMyZHYuUy0soFibWxCHC0fXrJVQW2SS862GTuz3bNbEmtHYlCntX7m8
         nv9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786926569; x=1787531369;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=isn6HdNAuHUYg47UPl5+Ny0iT08WidXyLHjL5whsUGg=;
        b=oDTDEHVgapB8J2ntZoyjOjnxDHJL1XrNfIXyUuSkVOb6uuLPgNIZW7EFo2YxXPNCeR
         edW50Ylek6Pl7HWE5vNyErXkrRkO+LcqoQLSC5ZXgtqKbHGBaFKRZm3G8xt+btX6vHNs
         xuA4sT1EZxhDZ8ROsfAmcQaIYnQJfdCjjmMUno7xTdXAkchBqUd2gt0nxpkgHZSurEsH
         4MQECmMbcbhaVseMT+JrEpCeR6lG+U3ZG9qVA27HBP28mzV/CUPFwWgV363y+MLQ/izh
         10fLoHeFquvota6E+WVgf2jBoa+yt3RTWlP7dmX6SU6xXzGWENdohoY6Jj5wdwxaMpXf
         LEXQ==
X-Forwarded-Encrypted: i=1; AHgh+RqqV0unBSQirVydHre/jEmEXL/C0EQ8lE1THhDTmKKX0wWEMrb8qYPh3b5k7vKkr4nqM/V8FSADaA==@kvack.org
X-Gm-Message-State: AOJu0YxhDz07/z/+geouV+dirscHvPBjLHMdFUK4EYiQBuiwJBJYtSTw
	YAfWi9C9ULtssuXNITJYrHigGbNXl/IRuOGUnnuV28gC1Ht522ceX8/gEZQxBGBN2L9VtxQNyt9
	lT5OKpcWm/lf3F+BUsdk7a0Kv0/bJU3UGewfSfjFa
X-Gm-Gg: AR+sD10W/q2Jlg30OBsq06FFk8+U9ewbMzUmuQSf2wTXUeJwMzPh+N1k+A1M2SKUqR+
	k/XUquZ9SAUG8WRimaLlkHX9+XY3gbjBNRCz9qQxbgtAyp3moQWMFLP6t7xEkpmBicJdEgo4zcM
	f9SUqMfKf+ontGDoJp0pv7GTF/iQNZibB+XFDMnlo8UXkk5FYRplhXiYAbFwpP5LksHdcYbo9RK
	LKNPIXvrncl+E3RMYq3Ab+W0uFQNeo+ax1PkH/BJTTIg5KAgCEEnbAhuIijZcB1JIYpJZA5U6sl
	pCwGxV8x0/tjVYrc9FG9wMWAUz+edJ6FkbDjhp2FTfxGIgKArCjDf2k4TkSUombOwgCEBs3b0OL
	Lveh5C7diUEnL
X-Received: by 2002:a05:600c:2942:b0:495:51b1:3b7c with SMTP id
 5b1f17b1804b1-49999f0eb74mr438495e9.8.1786926568431; Sun, 16 Aug 2026
 17:29:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260705180714.3708947-1-jiaqiyan@google.com> <20260705180714.3708947-5-jiaqiyan@google.com>
 <c5d4a1e4-cc3f-5cee-2ec3-53d5eb01bbb2@huawei.com>
In-Reply-To: <c5d4a1e4-cc3f-5cee-2ec3-53d5eb01bbb2@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sun, 16 Aug 2026 17:29:16 -0700
X-Gm-Features: AcwNN1VIC9W3oey-H6jV3nLMm-2EZFv5fMgfhXQj5iQz_Zfa0MrX44DY9gguctc
Message-ID: <CACw3F52RfFR4gZ9+kAmi6fkq39t6Sk1oUW0jqiXOFAAgn0iOyQ@mail.gmail.com>
Subject: Re: [PATCH v6 4/5] mm/memory-failure: skip take_page_off_buddy after
 dissolving HWPoison HugeTLB page
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org, 
	osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	nao.horiguchi@gmail.com, david@kernel.org, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, muchun.song@linux.dev, liam@infradead.org, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@suse.cz, 
	rppt@kernel.org, shuah@kernel.org, surenb@google.com, mhocko@suse.com, 
	boudewijn@delta-utec.com, ljs@kernel.org, ziy@nvidia.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2C85240002
X-Stat-Signature: 5tijp8n9basp4uik47gbghqzedas6azn
X-HE-Tag: 1786926570-92438
X-HE-Meta: U2FsdGVkX18y3/5m8y5/zCcsqI0IXaFzmNXnEqvA9iGvVjp1YZ4OOA/MSRZLtaS/bbNJpZ7KUg0dpV9KDCp9sx0b8iRSwAHqC/W1DwXk1BGBYOywyI9+oTXzWWhXQF5CUTaw+iLkR5y50w5UeQ7Xvt77PjQrYVsINxYzbc7tADzN4FNpWbU7I9NkD8TEnlJ/3HnAE4IRMgw5CtJJ6YhP/W1f8PL1DTTf6J3DfEHth0yzXsH+kX+w+qp6kWFQh9bp8djfEKoeZTMbpKmhuEelDsSXS/Cf38DwVM5zP18aPgz8ERf5Eb4dcCtvNH/fBeVlsjzYYUTMIgezAQUkveVK3oY+Ws8/XTZQyY0drtsHIMhp2nqADpbW5YpzBxhKy6muh4tiCi/jMHXbJCM1+T8ZwmxZ6DRyXKkt3ZIRRi3PAlBOcfIB2N06nz2dwXlTlpFk2HD5ZgubBUVNEW46255f5qpTWci37Zj5MvF/HG4Xhe21JK+s2TxzldcfEVeP3jTYzfgA7ARcSOge360hhSkDV+qxfE53EX6ngYkQgByJCUIhbpssLuTt+wvUchgMby/NcubE2kcn8Ifnh1a8keQbKB3aqlTTyIEyB4w/whn5PgkABOLhaqhSRhjge8fjLQ5rW6UBx52p5hxjXEGiu1EJqEYcPGNyinjOGD9hTl9UBSTfy1vL/QARcX7uTdZs2qeewGRDxP87Iqflj3FltVOOrNE9biD6ubt6jVeIFfwBtYncoUPF1wdwAVAgyIZ1wDIUKj+l+hf+IT8ytg7L2HmUfU0whipsymnpRvWpKZwTgeGbi1Wx0lkax7d2jMAYCV2Kt+Iz6OQUFCYWZSmj2NGAaFk0Ixh3DLLipel+DamUmyfWzeYg6P4kOfkGyThL+okjpJ4/7v1TJ0uXmmiCL6nJnl91+SRW/IP2hbIR6BZ1AWvPekieoiTtD7jKtUYK/vfDSTHPO9ZFoW26q4mDxV5
 /cw/v4/w
 COoudI3tthnfgQ4vvglZqGSc65n0Csx8jzFnLkCy+A3dWU4yEllgCvufGgNt1pJFK+txWA5qt0IdnQXrwuxnuK9U03fcm4peHMnph1XLmRkxixqHLMNNdXA6d5P3cOsZaHpF4fZPkddkO+OCpFzFllUgiwAKq1FRlwepB5iMElRdB8E+SHVRJN2LIvoH/qTUvDn/Bc+QXTvynG/SLj0F5ZzzZPPUDsRPlU94wyy1ERmNn4mVG4ZFQT1KPRsZHmwAwP+uqR7W3bPo2FR7AdKxyucFv9OClV4ZF4UBz2sadYpSmfk52NOnGxbi5ZpQmq1bgYnE+0OYhfLgcIL6lWK88+3Xq0yJSQDIKgSGWhYnWfktctB0IjZm9fVdweu+W5d7t5RGIEKzokRGkJSC3lhmTUNV4Fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 12:37=E2=80=AFAM Miaohe Lin <linmiaohe@huawei.com> =
wrote:
>
> On 2026/7/6 2:07, Jiaqi Yan wrote:
> > Now that HWPoison subpage(s) within HugeTLB page will be rejected by
> > buddy allocator during dissolve_free_hugetlb_folio(), there is no
> > need to drain_all_pages() and take_page_off_buddy() anymore. In fact,
> > calling take_page_off_buddy() after dissolve_free_hugetlb_folio()
> > succeeded returns false, making caller think __page_handle_poison()
> > failed.
> >
> > Add __hugepage_handle_poison() and replace __page_handle_poison() at
> > HugeTLB specific call sites. The being handled HugeTLB page either
> > is free at the moment of try_memory_failure_hugetlb(), or becomes
> > free at the moment of me_huge_page().
> >
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > ---
> >  mm/memory-failure.c | 36 ++++++++++++++++++++++++++++++------
> >  1 file changed, 30 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index 3d15b4c1b694..a37b67550718 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -174,6 +174,30 @@ static struct rb_root_cached pfn_space_itree =3D R=
B_ROOT_CACHED;
> >  static DEFINE_MUTEX(pfn_space_lock);
> >
> >  /*
> > + * Only for a HugeTLB page being handled by memory_failure(). The key
> > + * difference to soft_offline() is that, no HWPoison subpage will make
> > + * into buddy allocator after a successful dissolve_free_hugetlb_folio=
(),
> > + * so take_page_off_buddy() is unnecessary.
> > + */
> > +static int __hugepage_handle_poison(struct page *page)
> > +{
> > +     struct folio *folio =3D page_folio(page);
> > +
> > +     /*
> > +      * Can't use dissolve_free_hugetlb_folio() without a reliable
> > +      * raw_hwp_list telling which subpage is HWPoison. So do not free
> > +      * them to the buddy allocator. dequeue_hugetlb_folio_node_exact(=
)
> > +      * will ensure to never re-allocate this hugepage.
> > +      */
> > +     if (folio_test_hugetlb_raw_hwp_unreliable(folio))
> > +             /* raw_hwp_list becomes unreliable when kmalloc() fails. =
*/
> > +             return -ENOMEM;
>
> There are some branches in __update_and_free_hugetlb_folio that will leav=
e hugetlb
> folio untouched:
>
> static void __update_and_free_hugetlb_folio(struct hstate *h,
>                                                 struct folio *folio)
> {
>         bool clear_flag =3D folio_test_hugetlb_vmemmap_optimized(folio);
>
>         if (hstate_is_gigantic_no_runtime(h))
>                 return;<-- 1

Thanks for catching this, Miaohe.

I think the most challenging part is that
update_and_free_hugetlb_folio() must support deferring freeing (via
schedule_work()), so adding a return value isn't that straightforward
without some refactoring...

If making __hugepage_handle_poison() check
hstate_is_gigantic_no_runtime() =3D=3D 0 (or
gigantic_page_runtime_supported() =3D=3D 1) isn't an absurd idea, we can
just do that and avoid adding return value to
__update_and_free_hugetlb_folio().

>
>         /*
>          * If we don't know which subpages are hwpoisoned, we can't free
>          * the hugepage, so it's leaked intentionally.
>          */
>         if (folio_test_hugetlb_raw_hwp_unreliable(folio))
>                 return;<-- 2

__hugepage_handle_poison() already checked this, and with mf_mutex no
one can set raw_hwp_unreliable.

>
>         /*
>          * If folio is not vmemmap optimized (!clear_flag), then the foli=
o
>          * is no longer identified as a hugetlb page.  hugetlb_vmemmap_re=
store_folio
>          * can only be passed hugetlb pages and will BUG otherwise.
>          */
>         if (clear_flag && hugetlb_vmemmap_restore_folio(h, folio)) {
>                 spin_lock_irq(&hugetlb_lock);
>                 /*
>                  * If we cannot allocate vmemmap pages, just refuse to fr=
ee the
>                  * page and put the page back on the hugetlb free list an=
d treat
>                  * as a surplus page.
>                  */
>                 add_hugetlb_folio(h, folio, true);
>                 spin_unlock_irq(&hugetlb_lock);
>                 return;<-- 3

__hugepage_handle_poison() should not get into this if-block because
dissolve_free_hugetlb_folio() must have
hugetlb_vmemmap_restore_folio()-ed successfully, so clear_flag must be
false here. Otherwise dissolve_free_hugetlb_folio() already returns
early without update_and_free_hugetlb_folio().

>         }
>
> But __update_and_free_hugetlb_folio has no return value. So caller can't =
know exactly
> whether hugetlb folio is indeed dissolved. So maybe we need a way to dete=
ct whether
> hugetlb folio is indeed dissolved?
>
> Note before this patch, take_page_off_buddy will fail if hugetlb folio is=
 not dissolved.
>
> Thanks.
> .
>

