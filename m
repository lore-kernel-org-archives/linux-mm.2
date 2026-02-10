Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 508A9EF0702
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 04:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0008C6B008A; Mon,  9 Feb 2026 23:47:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E95206B008C; Mon,  9 Feb 2026 23:47:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CED696B0092; Mon,  9 Feb 2026 23:47:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC4586B008A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 23:47:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 67F0C139308
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:47:17 +0000 (UTC)
X-FDA: 84427312914.28.AF344CC
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 643B3C0002
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:47:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=p8gbPXwC;
	spf=pass (imf28.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770698835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NaTvCCyL2SECSfcnxtPR3yusX8hMpPBJMqgLEmTvlFU=;
	b=YpoVmfYyFA6w9a/GEaWZnfE0cqN9+36mSVvSx5OtdsDjjwcAT/7r1kjgUrN17+55AHrARX
	OahG+W8TSBgfUSNyVGdmLDuJceZXH5ztyQJuNQVgxRcp9/xHZteay9u4LHkXGEEpGBjZw5
	sqwjj5iIceMsPEEd+KeaJmVa+f8tbWM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=p8gbPXwC;
	spf=pass (imf28.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770698835; a=rsa-sha256;
	cv=pass;
	b=nYU5Y0HRq9+66GFAlVyrM6TDfmlzXGg5SKRf2hVvwSVIstR3UmHx2uMzlvgOvTQr8ZKGmk
	Y4XNWQoOE22Weoyyt31B6AA0fIoWXVkD7qxf7RZSbjD7xudrel0F77uF7yRKr4+A1UYxCK
	oNNTozV8OREZyBJVoWkUBAU7cV1jKRc=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48318d08ec2so25485e9.1
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 20:47:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770698834; cv=none;
        d=google.com; s=arc-20240605;
        b=F8q2xmYtjRveYfybReIBd/cYA5kDW/XnoVPnCzd00Wc6ThMmcGqNE9CLybu047F3w6
         eA1s/DCOOHJrKaZS+n8r6k8C39NcrlT1mudysFJlASyMxIJQo2GoIgXv3MjmoheQtcvn
         1Qy1lcVAOfyY3d5poKqLW2522ssYwc9qP6bjNFnwelFT89r+8EeRw8j7KGxj3VaIeNek
         N8gVzdjEmwJr80KvQqpq/bRoMjxku+trMiu6fPUXyQ6MAEWfPX6FyjgfV9bMRAkGlVVK
         4ciSH/WgGXRMubO6PQT9jK4eiDBBRa5b1sZPw49GHnQ4+Y11mF5H+EIi4uxNFlpFE6pN
         ergA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NaTvCCyL2SECSfcnxtPR3yusX8hMpPBJMqgLEmTvlFU=;
        fh=CHa92bSh0BYog1ZGOmBq7/IQ9zjfHmEkLlNXlaVpSuo=;
        b=hlrBgR8+ozbAyD0JQv1SBi6+lDQrYqrnEfD+AppT5AXt7OzVCN+FcNSsD3oSpDUZLQ
         4whjPHi00C2DFlp8eWUz3qpXTN2Ac6aJt6RBbmeiJoPl5AahoLPxIuonAlstUMcQ5jbn
         rjpmPnzNQTORrsZd1AaDXC4MSeRZ2uWfLjEL34CaHFG6skq9LIwcgtced5Ns0Ig0GZVC
         xNxYXe00SUY1zG49h6WMYSKAFyziaARRNgWX1AP3j+1qCS9FH4qRep7U6tN3bDFbHAgR
         t4C7qFqpXYBQI5GiCL4rc1xwgacjiQ/NP25QWNWQcS1dqvgsJQyPZIFavH2Sr3wDaOKG
         fhqw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770698834; x=1771303634; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NaTvCCyL2SECSfcnxtPR3yusX8hMpPBJMqgLEmTvlFU=;
        b=p8gbPXwCvScSmgNa0w8b13uUMp9qcaJ6asI9KkP0vOoO5z/+t/UfTUWZompA8Sds/+
         6581P2MAG8AGcq4xAR2KzmEiLIoJCYoq5FQ6Sb0uoLcFcCe97cHwPZ1nqv1WkUiPE8gw
         hgvwHziAciqg6SV8xOy8Wc6qZClbbMR1He91W0WMTxrkrH9HVWzQA0xi8c0hk2UioV7C
         DiKpEF6x65R+/8Kua1VRZQfplsJDSyP3wDsNLJNFo75bxpHdSH4eqkgYWcHNq80ECcVH
         Qc0DfaxxyItV9hg3k71qgoC63dpNt1riovvXmvl8yLi7ZyH4JfYgYjHK98fCKLssmPS1
         pWVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770698834; x=1771303634;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NaTvCCyL2SECSfcnxtPR3yusX8hMpPBJMqgLEmTvlFU=;
        b=prwx7rkJFbgfZALyVx2MnespJKUgRG/oj2ugZUwujXvIaPnZvYqPk8sBlObeW58M3D
         lemPMrQFy0uNy11hXMHViStkJHOjMFRUS+msw3E4Nq0uM+Jd9VdoldLbDB9Xst7p5KV2
         r8AWRSQdyD4t8cUGG+DuMoz81CYWsrptVrbviD8RzYwP/dkSB6R/i5XQlWxR7iP/LTfs
         4TcxS1e1E5ziD2Ti/Zt32tAvv8DAHiRljzSCSpY3q++xz3MrcP1zea5lLC0DNTQE+NKP
         jR8JURR7EKxlJGCNuSmR/rcvKLV1sOL7JShtTebU14dyFGju+hwzA6osfhIG10zX03JQ
         aNWg==
X-Forwarded-Encrypted: i=1; AJvYcCWs1d2xSXCffly1O4+6Qhf6JnbIUdaeqRTkzgG6cAEn/bZ6Ld8y8p6FFTVrVdA9luzKuEvJoEQ/Qw==@kvack.org
X-Gm-Message-State: AOJu0YxsWjc0vk6+pkafAnh043WMbUbC0Uqp25a9VzGOJCaBRZd6SUJa
	q4czlxrlyG38zChNYCVdD5qdEuyOWL7Ks2os3IwXPWQZwXO+kDJBr5BV2EDhY8ay6AAFlsqFV+1
	0mEeufwZZJbNPOBC2lc/OPMJhMFxlRrJJxgNs2Ezo
X-Gm-Gg: AZuq6aJRQnzZNPj+BJmLdbLtHklZMcd2b4ojr3Ccd95SGinkvkiJT6UrvMmA45toBv6
	oN8hDgvWcDFsa3ZQDL5hYxRrHK1+oFdGk12L5nqiSu6B84h7rTCoNjp1PIGD+dW+hZAWNknBgnX
	i+I9GVsAdVSjDHvw6cl6Fnf40DcbR2buGq9YlIvItJt9xiuVWyziKylspMt3azXKa58OQt/BcAu
	q0WIYW68OSUXaQaVJydH9pWCcq+N99/qsRIYb57SK00jcoLLHMs82yYtYmNCL+SF3FlkrrlkcUM
	dU1mxE/kBDdDZpMOhQPKW9+o2KB6XJXuXNbN3ic8
X-Received: by 2002:a05:600c:17c3:b0:477:b358:d7aa with SMTP id
 5b1f17b1804b1-4834efc30c2mr283185e9.18.1770698833730; Mon, 09 Feb 2026
 20:47:13 -0800 (PST)
MIME-Version: 1.0
References: <20260203192352.2674184-1-jiaqiyan@google.com> <20260203192352.2674184-2-jiaqiyan@google.com>
 <7ad34b69-2fb4-770b-14e5-bea13cf63d2f@huawei.com>
In-Reply-To: <7ad34b69-2fb4-770b-14e5-bea13cf63d2f@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 9 Feb 2026 20:47:01 -0800
X-Gm-Features: AZwV_QjdqW_fxGf25INcby_KBRQEkpKFKpIh5TStYvQvKDlNDRUknJQJqJFGxlQ
Message-ID: <CACw3F50PwJ+sSOX0wySQgBzrEW2XOctxuX5jM37OG0HS_kHdbQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm: memfd/hugetlb: introduce memfd-based userspace
 MFR policy
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, david@redhat.com, 
	dave.hansen@linux.intel.com, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	william.roche@oracle.com, harry.yoo@oracle.com, jane.chu@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 643B3C0002
X-Stat-Signature: h4hb89tt8sk4f7kesduy9nyt59auexrx
X-Rspam-User: 
X-HE-Tag: 1770698835-238523
X-HE-Meta: U2FsdGVkX1+D/QH5WdYJq5Ey1+zLQc6GQ1tt47eO0k3gofm3MLTpED9JCEA+/+rG+Gh8cDCDZ//mJbzzXocCyTfqApOwZ3Sq4r7/qBa9lrJFj148CeYj1tarh5kpCzM7Ii6+xiqACGsYchZ7upBcv6K5aZx4hodsB/YI/a4Fsp8dC7nBhoAgNgQTnzoMWYbSnPqyKE9MvSrXq2XYoImem/vAC630GuwDDDGly9yPKJYvTS+b5bDYH9NC5ezQ60aQ3XTJiAY9AUgu6lSWjVUAeZUkKcZmV8gJugzPBQS6GtZrZW3ms3+iacCy+qmaox9qIp6qwGNpfBsfTJI/YwcufHeCvp4Dh0x2YIuYhCl6GXA39hXiOdHib7xjU+4PphZqYsYPBboJMVFBVso+x0/Q9sXrP/0fyNXn37G6zFron5ed8BdAQcBZwq+FYMdr+mP5qv6zkD+oCHu4eaMkqD85qJaBxLvGOFih3tzPkDsxkqyghUdOY3GRSZI2jzTLEkb6b41FvF82SLGmvLAaBLJws0T0n0czm1/fft1nX6I3PwK82QTqabktGz/AYh9Q93dFYKDIZ4U/4qi5X8yxUmKBzBPqAC/4c1Us7JlS6ObrxfFIVj3fqIjhQfLEzctcepTo3QsohD1u3s4lnOvqJjc3Kallz4G1AwtW8htjAKCXRuX692GnEBAElz5eEt23fC6yFjkMOviNZt8DE3SzAj75sUmsg4kvkiOKZdAQ3wjUZozC6VsEDHVBKF9VFPtiP1pihRT9rRkIRf2cLS/2ytuHO1tZypIRMjg0m1ZkrcddUji9Z7yaZUJk0vnNqLCalkEsOpJoBK42EUZLE1EpzdkOWYGXE8v14Zpn4pifD69q9b1E4fTAuSPsyjnYcF6O1EfVN7a9JKdnmaQwAgKTgOLo09hNtYm7UDQO0FWP8mWNpu65fYRFbX++8/sGLmgkG+dNE7QvbZ1+rKO02MUuuXW
 43pBXM3u
 r6DPclxvcFRrCEwac78An4EtPQK1rh2EcT7hXkOQ8preNQyWB9wGXZAlKJR5vutcIZhDPs7Ljwms0cgP5DpeHMU8q54BqZnabC/S6qEP20266XB0F6C3GI0Ux6NMIiwVkw2TEi20L11Y9ismqh3ZxMmuef+pTYRpBXtZgneAtxFahBdsw2AbQpkGyNVahS/4b5wNwRgC1m9yzGyt/pYedSGuYJk61tglIMsDwzhTtBEd0tqCUZud6GFKFUnIBpNzKUK6BOWzPt8PdL1YD/DWhlQDsb1Vrt6Ek2YScB9tDMfrxCoL7Y/Ebgmbn8GA6kgPt5iPA+k4ovrNJLlr2w6EaDWRYFvyW0c9ATlTquF2feSJCvTvcY2bOKuEAMl363y0sWTc4c8X4JZ4sEoctj1rW7S2duqYiolbNJtnW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 9, 2026 at 3:54=E2=80=AFAM Miaohe Lin <linmiaohe@huawei.com> wr=
ote:
>
> On 2026/2/4 3:23, Jiaqi Yan wrote:
> > Sometimes immediately hard offlining a large chunk of contigous memory
> > having uncorrected memory errors (UE) may not be the best option.
> > Cloud providers usually serve capacity- and performance-critical guest
> > memory with 1G HugeTLB hugepages, as this significantly reduces the
> > overhead associated with managing page tables and TLB misses. However,
> > for today's HugeTLB system, once a byte of memory in a hugepage is
> > hardware corrupted, the kernel discards the whole hugepage, including
> > the healthy portion. Customer workload running in the VM can hardly
> > recover from such a great loss of memory.
>
> Thanks for your patch. Some questions below.
>
> >
> > Therefore keeping or discarding a large chunk of contiguous memory
> > owned by userspace (particularly to serve guest memory) due to
> > recoverable UE may better be controlled by userspace process
> > that owns the memory, e.g. VMM in the Cloud environment.
> >
> > Introduce a memfd-based userspace memory failure (MFR) policy,
> > MFD_MF_KEEP_UE_MAPPED. It is possible to support for other memfd,
> > but the current implementation only covers HugeTLB.
> >
> > For a hugepage associated with MFD_MF_KEEP_UE_MAPPED enabled memfd,
> > whenever it runs into a new UE,
> >
> > * MFR defers hard offline operations, i.e., unmapping and
>
> So the folio can't be unpoisoned until hugetlb folio becomes free?

Are you asking from testing perspective, are we still able to clean up
injected test errors via unpoison_memory() with MFD_MF_KEEP_UE_MAPPED?

If so, unpoison_memory() can't turn the HWPoison hugetlb page to
normal hugetlb page as MFD_MF_KEEP_UE_MAPPED automatically dissolves
it. unpoison_memory(pfn) can probably still turn the HWPoison raw page
back to a normal one, but you already lost the hugetlb page.

>
> >   dissolving. MFR still sets HWPoison flag, holds a refcount
> >   for every raw HWPoison page, record them in a list, sends SIGBUS
> >   to the consuming thread, but si_addr_lsb is reduced to PAGE_SHIFT.
> >   If userspace is able to handle the SIGBUS, the HWPoison hugepage
> >   remains accessible via the mapping created with that memfd.
> >
> > * If the memory was not faulted in yet, the fault handler also
> >   allows fault in the HWPoison folio.
> >
> > For a MFD_MF_KEEP_UE_MAPPED enabled memfd, when it is closed, or
> > when userspace process truncates its hugepages:
> >
> > * When the HugeTLB in-memory file system removes the filemap's
> >   folios one by one, it asks MFR to deal with HWPoison folios
> >   on the fly, implemented by filemap_offline_hwpoison_folio().
> >
> > * MFR drops the refcounts being held for the raw HWPoison
> >   pages within the folio. Now that the HWPoison folio becomes
> >   free, MFR dissolves it into a set of raw pages. The healthy pages
> >   are recycled into buddy allocator, while the HWPoison ones are
> >   prevented from re-allocation.
> >
> ...
>
> >
> > +static void filemap_offline_hwpoison_folio_hugetlb(struct folio *folio=
)
> > +{
> > +     int ret;
> > +     struct llist_node *head;
> > +     struct raw_hwp_page *curr, *next;
> > +
> > +     /*
> > +      * Since folio is still in the folio_batch, drop the refcount
> > +      * elevated by filemap_get_folios.
> > +      */
> > +     folio_put_refs(folio, 1);
> > +     head =3D llist_del_all(raw_hwp_list_head(folio));
>
> We might race with get_huge_page_for_hwpoison()? llist_add() might be cal=
led
> by folio_set_hugetlb_hwpoison() just after llist_del_all()?

Oh, when there is a new UE while we releasing the folio here, right?
In that case, would mutex_lock(&mf_mutex) eliminate potential race?

>
> > +
> > +     /*
> > +      * Release refcounts held by try_memory_failure_hugetlb, one per
> > +      * HWPoison-ed page in the raw hwp list.
> > +      *
> > +      * Set HWPoison flag on each page so that free_has_hwpoisoned()
> > +      * can exclude them during dissolve_free_hugetlb_folio().
> > +      */
> > +     llist_for_each_entry_safe(curr, next, head, node) {
> > +             folio_put(folio);
>
> The hugetlb folio refcnt will only be increased once even if it contains =
multiple UE sub-pages.
> See __get_huge_page_for_hwpoison() for details. So folio_put() might be c=
alled more times than
> folio_try_get() in __get_huge_page_for_hwpoison().

The changes in folio_set_hugetlb_hwpoison() should make
__get_huge_page_for_hwpoison() not to take the "out" path which
decrease the increased refcount for folio. IOW, every time a new UE
happens, we handle the hugetlb page as if it is an in-use hugetlb
page.

>
> > +             SetPageHWPoison(curr->page);
>
> If hugetlb folio vmemmap is optimized, I think SetPageHWPoison might trig=
ger BUG.

Ah, I see, vmemmap optimization doesn't allow us to move flags from
raw_hwp_list to tail pages. I guess the best I can do is to bail out
if vmemmap is enabled like folio_clear_hugetlb_hwpoison().

>
> > +             kfree(curr);
> > +     }
>
> Above logic is almost same as folio_clear_hugetlb_hwpoison. Maybe we can =
reuse that?

Will give it a try.

>
> > +
> > +     /* Refcount now should be zero and ready to dissolve folio. */
> > +     ret =3D dissolve_free_hugetlb_folio(folio);
> > +     if (ret)
> > +             pr_err("failed to dissolve hugetlb folio: %d\n", ret);
> > +}
> > +
>
> Thanks.
> .
>

