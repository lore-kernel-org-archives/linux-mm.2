Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CF09606D822
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 17:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=FWx28JJk
Received: by kanga.kvack.org (Postfix)
	id 563786B05B3; Tue,  3 Nov 2026 12:49:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53AD96B05B5; Tue,  3 Nov 2026 12:49:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 450B36B05B6; Tue,  3 Nov 2026 12:49:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D7B16B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:49:24 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EEAFC160287
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:49:22 +0000 (UTC)
X-FDA: 85394544564.27.24AE44A
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0A6EA18000C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:49:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=FWx28JJk;
	spf=pass (imf24.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793728161;
	b=HWfGpwqsGGP+4PiIiRLs97ZQmZNyieFo5rjjJV6WOmowsTf+7TdreXLMueSnh7UQ/A40De
	iGSkmpvXSWCE/hMXtRyUmvF0Vlh77r8cwB7E86TCUU/j7Fq0U3kohIA7V1hSN5dDw6aWI8
	5YTPFBeuUEYGdzrlHofJqTg0+MnATfY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=FWx28JJk;
	spf=pass (imf24.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793728161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HaiyNOaAuQa6ZOZsdJi3zkNAl8c9fizH8Hxx07wxITA=;
	b=t1PgqzIr0crllveVQH3kRcpMKyJfvKO8vL1OFOQfM8Why42XV2n6FV7Bx7hqAR2vNacTXG
	q9vmCj2nfJ0XNT6naNZC6sqc74BZfdCo8Q6L7/SBX+wO7do8ZSjPISMC1FkBgPPIIwVNDM
	qpzh65AEtSAqsqwxqqI+eT/3JsMPZOQ=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-54492d8a988so591cf.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 09:49:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793728160; cv=none;
        d=google.com; s=arc-20260327;
        b=rYgBOee8z9h2ynHfYbXuW6/XaNfo7mbZlcjle1krde+pHxiQSs4rFJd1BpRgyf/l/f
         JZ+RbjCqVnMuColNRzOfSfCNd3rKbaMS+U9Vx/C3VDO0Bwed0VUmp84oKs6butYemdbB
         6DhfiaAQTlTa+SyvR5MtNtjxdAH9tWsUUt96OJBRcelMpYClXIIUr5DqO/mYiVisjePd
         jho6kJ8N+47UX2v47VAJfxxGQZDO3X4FEBNvLFCqpzHkZUwWTeSgU/z+d1wY7m1Z1THi
         sFGdqyoWXeI0+7tuQNxDGV0IEQiinq5dJ6bN+R6YHlD0m0rfAMSVe4qmyoErtkts4HS0
         4iIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HaiyNOaAuQa6ZOZsdJi3zkNAl8c9fizH8Hxx07wxITA=;
        fh=80kGe3kATSSpgvDvT6fT3esH/xbe3PEWv0HBtTZISsI=;
        b=ZPd1f04ag7yGz9QQD2AmwGJXJYDJiVVvxv5vq3K+dU9JpK+1Nrbph1L/HWADUJ4BDr
         FWCSgK+dFSMPSlZIkxoRnKwkx0Ss5M4xvz6hbFmKu7owVQv93EwIJUOKPAxulpug+rfV
         Qy9UJyZMCkQfTX/w46u7DSruo4Z9uEjTTg84DnVUmNHAPKxjXHMp+cF+tVb+4Si0Q8qM
         ZbWfGRzGiXGEjxX9jJZBN4T96Bp85GnfLEsseA6BRoUqjFJ7VHjBbIvWF/tSvkF+uQyn
         C1w3/7aFixBGhyf//2fdTK2HLBgXmRKSA7+m5hFun0AZT3Pg92Y/LmgX3QbTU8In8Uhe
         W1OA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793728160; x=1794332960; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HaiyNOaAuQa6ZOZsdJi3zkNAl8c9fizH8Hxx07wxITA=;
        b=FWx28JJkrMpC2UMpwYJrjhhgid+Xcadti9kzse/yHu5EPKmV3hJaN7rvnjpJaAqGYW
         Lkz9mOf1ZoifskMKqvVk9A6c68Wkw4ELPj1l5X2ttD3OdakjZuNE6FVast32njJYIAR/
         odhnwsrH6kJeMR2bmCA1kTmHPTMbJQN0U8VUsdDIbqC1eWbE2osw6OIOY2LwRVYrHNQi
         gmDUs137CQPLjyjwdGSJ3cwv1nVQYsIrwND7JONzNoSTqmeCm6o317P3IApVkbSB/ivp
         xM5AH/iftmrOy2rmXERNf6Pq2t1O02Sj1BmNRdUb69agWm6A08nxrlUNkFpoLV66rgYl
         9i1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793728160; x=1794332960;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HaiyNOaAuQa6ZOZsdJi3zkNAl8c9fizH8Hxx07wxITA=;
        b=pML/AtWdwFcBQoTnQeGd4BmHbWyx9q7H7lYs7UHgflF8qlpp/ExSHHvTUgJzS5+duy
         1a5WqBfPiMrt8vBR6UYLAiowBSJVYFNUi7+zgiEjxqK1QAIaDcN3j0IbpVbD668RkvZi
         338PBkFzrqdv5GjaZn6zxz2q7eYN4D2ysCiyX+NT4nwAAuPp4LZdxWV8t/onUcHePA8z
         uAFkHa42HE8Llbwa7PSS3z/I4aZegVEBC4+k/ZYpm6s7cl0XcCoz9CUnzNX5I/rj27K4
         +JWPU801i+VuUyWPgR3B++B6u/xI9Tr5eEkaOe3SRnZecm+r1D7CNZD4UFdXWBo8SXaN
         S8EQ==
X-Forwarded-Encrypted: i=1; AKwUvByblq6j+PaKSdCUGOBfKu4gcycXY6OEnBXuxyqGWlJAizQXnjl5oDCFsemuOoaJH9iPwtch/Vig1g==@kvack.org
X-Gm-Message-State: APuU4Z8P+vKDEtAyIkajd3+AWLapN/cppN0bnVFlfouJ+NEgDWsxLWAr
	0Pe0Ol0XOw3mZ0eWxkMGgCZs4yCtAMu/62k0lnMa2XBHpdnGS0hfXqV3j2wVOQCrgNxoZVXsgrc
	123NVYw1wvJHc8fO9h2aDN03rNRx2vlNXOZcS1TOY
X-Gm-Gg: AYBFou1Ze8Tf8//Xn8ATUe8FzzKhFfS12z659iJSLCs27aCqVdio6QKCgxSDsugq1m1
	miwWbX37H3ypmAjT3PmCcDuxTbCFBMrKdOqXbakSdqsSlg1XXGWA/t0grJasKUuSLDMWJI1ZvDt
	V7u+JbjLWK3bb1Ho23UHB0Wahc/Dt4lRjGdr/xxEgs7SwgvyO8CFXHcIgwOFPF0RQ2u5Njjk3sE
	OuYRWPJQ3hWhE08jEvKddvos/EhbGbAvSMe5laSMIrNPmRrC9ddrHfg86ZBrf896GT6WOdOmmk7
	Oq+d15f+5u+TzyzfpdPCA5/XCpNay2UWJRu1aqYJEN18QQ1aEC+evYHM0it1iXVghPwd/vIPcHa
	Yi3LnH6U68wztAJ6TxOVmWftkAgFn73YPCvSia75sench2SJo6N1uZA5/oo64LadkazLx3ispY5
	U2YRYWf1ajVw==
X-Received: by 2002:a05:622a:2447:b0:530:e335:4ef with SMTP id
 d75a77b69052e-549ba0e24f1mr24262071cf.2.1793728159250; Tue, 03 Nov 2026
 09:49:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260705180714.3708947-1-jiaqiyan@google.com> <20260705180714.3708947-5-jiaqiyan@google.com>
 <c5d4a1e4-cc3f-5cee-2ec3-53d5eb01bbb2@huawei.com> <CACw3F52RfFR4gZ9+kAmi6fkq39t6Sk1oUW0jqiXOFAAgn0iOyQ@mail.gmail.com>
 <d908b3d6-e3db-6eaf-100f-ffc1dd765c55@huawei.com> <CACw3F537_QTg8eax-aB2jDv+tEqgg8GqsP=T9wEfpH+zNttanw@mail.gmail.com>
 <b7319726-4621-1896-07d0-f83a7fc37258@huawei.com>
In-Reply-To: <b7319726-4621-1896-07d0-f83a7fc37258@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 3 Nov 2026 09:49:02 -0800
X-Gm-Features: AclHuK_v_z4Y5l6gQ9sQwU8ESG-N9nhXyXZaDd_ADZi26NE2v0VyKjxUdHSgXLU
Message-ID: <CACw3F51sDrZCWoNOhUnv3Sbs-FHztOQdhuouAfYBjPpaBYmX=g@mail.gmail.com>
Subject: Re: [PATCH v6 4/5] mm/memory-failure: skip take_page_off_buddy after
 dissolving HWPoison HugeTLB page
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: osalvador@kernel.org, willy@infradead.org, osalvador@suse.de, 
	jackmanb@google.com, hannes@cmpxchg.org, nao.horiguchi@gmail.com, 
	david@kernel.org, william.roche@oracle.com, tony.luck@intel.com, 
	wangkefeng.wang@huawei.com, jane.chu@oracle.com, akpm@linux-foundation.org, 
	muchun.song@linux.dev, liam@infradead.org, rientjes@google.com, 
	duenwen@google.com, jthoughton@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org, 
	shuah@kernel.org, surenb@google.com, mhocko@suse.com, 
	boudewijn@delta-utec.com, ljs@kernel.org, ziy@nvidia.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: y384ydt8mn1j8u65ymgeou7qqesakqkr
X-Rspamd-Queue-Id: 0A6EA18000C
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793728160-131446
X-HE-Meta: U2FsdGVkX19q6W8xGdWkwx+XC7t4DTVP7I+2m78gntHN1S40w0O084uHQCzvXaI4jSEeui68ZJ82KNjmLSI7BawR3Xzd4z/tSeJE6aDgB6c+S+YRVxvfz6R2rY4wulS4a07ZCRuZNQmw2Z1WDzYDhA0qiJMSRpkB6J3e1CkGkmkDzA6+hW+7R80IvXhuE210lzI5Jk2XVUVyx8MTdSJ82WU1/Tv4zPIl9tFM6WaaUsyiVd82ZUtfFFTPcFlLVjEOzEy4PAdy4IqnDZA9g7mKf56m4yqmaiDnleIhA9JdlrxgyPwCA6m1wWYm1yUPR4xSOz8BNFl2+xwUiu6DEWOIVseBW50nHA2JHr1Tx+1v2sXmNKuBsCldPljZQYFD5UV4FIvQMVYpFKJPxHn17dJqNKig+JI2IOB8VJo1VLQRO4O24HuPZ7SimUeDWgTF//fq+MUKtthl/1pI12HYIkRh3nK5OuTBV9c4qwGWQX6pLlY2FQZobcIFtKWXbsNW9tbMs7ZUh6KgwNs9LEKyYOV72mVOamhjAnbzUm74LYWtz3Qojpu7Gfw7BHwHEf9o4hqUy2bBgy9Vl0oT4RpjkCaU0nAkckBpAth94TPhOlFiFhd6FyXDJpba46mNFL01AonVGiICLDP+FR74aF9GyXoGklgxYhkZSRZcWRZ2BKay64k7jsWEYf3bazfBGDVmduJX6KH7LF0i+IekfE56sTAdyWlb+RB1b4m0a+mD4AzNJr7IprcNtS3T+fetfmsP/3RwO8I8aKZnmXLhwKI0/2G1FZ3j9/PV0bLuIfbdy/TWfvWTsJ+cJapNDwwJ1+FvSvtaUT0bsXiiDz3oGqU5bxAO6uHRImQn2BS735xEo2KnrNtaeVMfNEid0Ubwy/eRE8w+O4ceTQlA06kSYJokk8fLMcgZ/UZ/Iaus4/g4Nj0kxAdz0NHsAdghN15A7gkQZpZ5dcG7dtKNKIVwvgKZJie
 wuU0rhoD
 9Vxx+HJErespi956/jeto+4CaBoGEYCxRADRMbfUX2AEWRViwcZD6t+uF2fIXw58PnEQ+UbcBLsiL0705LBXq/FSUjleypAQpKx/LPZ10jo9yVdMlLkD0qQ29DrBjXBA/wrQCW1XlD1jaZs2OS/GEHt3Lwm4h0MQ/bjA3y0iEGLnqBZWOK0cmmjNRP6pdtMhLtaZF8q3ecvC6iWNg9i95l27ETf64fSJhqDWj9tFzBi9jjJqy3LVAIHpuK/ouIn+KbCd+lj26oeaobYE0yVM5kEFTR/t0uNN2Fp4/2ZDq9ld/rwgjioZqtWTW/DdtKYvaiaqslSRG8JfayYfmi4d2x9TReYYSk6N7tnXJcddYbOW/YB6on922p0Ukkh3JH/ejd4qw8N5+cYm2//SEyVLApP2ROpyAjT2zVXwE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Aug 18, 2026 at 2:06=E2=80=AFAM Miaohe Lin <linmiaohe@huawei.com> w=
rote:
>
> On 2026/8/18 11:30, Jiaqi Yan wrote:
> > On Mon, Aug 17, 2026 at 12:23=E2=80=AFAM Miaohe Lin <linmiaohe@huawei.c=
om> wrote:
> >>
> >> On 2026/8/17 8:29, Jiaqi Yan wrote:
> >>> On Fri, Jul 17, 2026 at 12:37=E2=80=AFAM Miaohe Lin <linmiaohe@huawei=
.com> wrote:
> >>>>
> >>>> On 2026/7/6 2:07, Jiaqi Yan wrote:
> >>>>> Now that HWPoison subpage(s) within HugeTLB page will be rejected b=
y
> >>>>> buddy allocator during dissolve_free_hugetlb_folio(), there is no
> >>>>> need to drain_all_pages() and take_page_off_buddy() anymore. In fac=
t,
> >>>>> calling take_page_off_buddy() after dissolve_free_hugetlb_folio()
> >>>>> succeeded returns false, making caller think __page_handle_poison()
> >>>>> failed.
> >>>>>
> >>>>> Add __hugepage_handle_poison() and replace __page_handle_poison() a=
t
> >>>>> HugeTLB specific call sites. The being handled HugeTLB page either
> >>>>> is free at the moment of try_memory_failure_hugetlb(), or becomes
> >>>>> free at the moment of me_huge_page().
> >>>>>
> >>>>> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> >>>>> ---
> >>>>>  mm/memory-failure.c | 36 ++++++++++++++++++++++++++++++------
> >>>>>  1 file changed, 30 insertions(+), 6 deletions(-)
> >>>>>
> >>>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> >>>>> index 3d15b4c1b694..a37b67550718 100644
> >>>>> --- a/mm/memory-failure.c
> >>>>> +++ b/mm/memory-failure.c
> >>>>> @@ -174,6 +174,30 @@ static struct rb_root_cached pfn_space_itree =
=3D RB_ROOT_CACHED;
> >>>>>  static DEFINE_MUTEX(pfn_space_lock);
> >>>>>
> >>>>>  /*
> >>>>> + * Only for a HugeTLB page being handled by memory_failure(). The =
key
> >>>>> + * difference to soft_offline() is that, no HWPoison subpage will =
make
> >>>>> + * into buddy allocator after a successful dissolve_free_hugetlb_f=
olio(),
> >>>>> + * so take_page_off_buddy() is unnecessary.
> >>>>> + */
> >>>>> +static int __hugepage_handle_poison(struct page *page)
> >>>>> +{
> >>>>> +     struct folio *folio =3D page_folio(page);
> >>>>> +
> >>>>> +     /*
> >>>>> +      * Can't use dissolve_free_hugetlb_folio() without a reliable
> >>>>> +      * raw_hwp_list telling which subpage is HWPoison. So do not =
free
> >>>>> +      * them to the buddy allocator. dequeue_hugetlb_folio_node_ex=
act()
> >>>>> +      * will ensure to never re-allocate this hugepage.
> >>>>> +      */
> >>>>> +     if (folio_test_hugetlb_raw_hwp_unreliable(folio))
> >>>>> +             /* raw_hwp_list becomes unreliable when kmalloc() fai=
ls. */
> >>>>> +             return -ENOMEM;
> >>>>
> >>>> There are some branches in __update_and_free_hugetlb_folio that will=
 leave hugetlb
> >>>> folio untouched:
> >>>>
> >>>> static void __update_and_free_hugetlb_folio(struct hstate *h,
> >>>>                                                 struct folio *folio)
> >>>> {
> >>>>         bool clear_flag =3D folio_test_hugetlb_vmemmap_optimized(fol=
io);
> >>>>
> >>>>         if (hstate_is_gigantic_no_runtime(h))
> >>>>                 return;<-- 1
> >>>
> >>> Thanks for catching this, Miaohe.
> >>>
> >>> I think the most challenging part is that
> >>> update_and_free_hugetlb_folio() must support deferring freeing (via
> >>> schedule_work()), so adding a return value isn't that straightforward
> >>> without some refactoring...
> >>>
> >>> If making __hugepage_handle_poison() check
> >>> hstate_is_gigantic_no_runtime() =3D=3D 0 (or
> >>> gigantic_page_runtime_supported() =3D=3D 1) isn't an absurd idea, we =
can
> >>
> >> I'm afraid this might not be a good idea. Maybe we could re-check page=
 state after
> >
> > Any specific reason? It seems to me that code that included
> > "hugetlb.h" can access gigantic_page_runtime_supported().
>
> I am concerned that with the changes of the implementation of
> dissolve_free_hugetlb_folio(), gigantic_page_runtime_supported()
> might not be the sole reason causing dissolve_free_hugetlb_folio()
> to fail. This would require __hugepage_handle_poison() to be modified
> accordingly but we might miss that in the future... But still no strong
> opinion here. :)

Coming back from a long vacation and catching up with this conversation....

I found commit a363c62a653c ("mm/hugetlb: do not dissolve gigantic
pages without runtime support") has landed in akpm/mm-unstable, adding
"if (hstate_is_gigantic_no_runtime(h)) goto out;" directly inside
dissolve_free_hugetlb_folio(). So for this particular case, I think no
more checking is necessary.

Your concern in general still holds. Usually or at least sometimes,
caller of dissolve_free_hugetlb_folio() expects its return value
reflects the true results of dissolving and freeing; however,
update_and_free_hugetlb_folio() can bail out silently.

>
> Thanks.
> .
>
> >
> > I feel checking gigantic_page_runtime_supported() upfront is cleaner
> > than checking page state after dissolve:
> >
> > if (!gigantic_page_runtime_supported())
> >     return -EOPNOTSUPP;
> >
> > vs
> >
> > /* Direct state check after dissolve */
> > rc =3D dissolve_free_hugetlb_folio(folio);
> > if (!rc && folio_test_hugetlb(folio)) {
> >     /* Dissolve failed silently due to unsupported gigantic runtime fre=
eing */
> >     rc =3D -EOPNOTSUPP;
> > }
> >
> >
> >> calling dissolve_free_hugetlb_folio?
> >>
> >>> just do that and avoid adding return value to
> >>> __update_and_free_hugetlb_folio().
> >>>
> >>>>
> >>>>         /*
> >>>>          * If we don't know which subpages are hwpoisoned, we can't =
free
> >>>>          * the hugepage, so it's leaked intentionally.
> >>>>          */
> >>>>         if (folio_test_hugetlb_raw_hwp_unreliable(folio))
> >>>>                 return;<-- 2
> >>>
> >>> __hugepage_handle_poison() already checked this, and with mf_mutex no
> >>> one can set raw_hwp_unreliable.
> >>
> >> Agreed.
> >>
> >>>
> >>>>
> >>>>         /*
> >>>>          * If folio is not vmemmap optimized (!clear_flag), then the=
 folio
> >>>>          * is no longer identified as a hugetlb page.  hugetlb_vmemm=
ap_restore_folio
> >>>>          * can only be passed hugetlb pages and will BUG otherwise.
> >>>>          */
> >>>>         if (clear_flag && hugetlb_vmemmap_restore_folio(h, folio)) {
> >>>>                 spin_lock_irq(&hugetlb_lock);
> >>>>                 /*
> >>>>                  * If we cannot allocate vmemmap pages, just refuse =
to free the
> >>>>                  * page and put the page back on the hugetlb free li=
st and treat
> >>>>                  * as a surplus page.
> >>>>                  */
> >>>>                 add_hugetlb_folio(h, folio, true);
> >>>>                 spin_unlock_irq(&hugetlb_lock);
> >>>>                 return;<-- 3
> >>>
> >>> __hugepage_handle_poison() should not get into this if-block because
> >>> dissolve_free_hugetlb_folio() must have
> >>> hugetlb_vmemmap_restore_folio()-ed successfully, so clear_flag must b=
e
> >>> false here. Otherwise dissolve_free_hugetlb_folio() already returns
> >>> early without update_and_free_hugetlb_folio().
> >>
> >> Agreed.
> >>
> >> Thanks.
> >> .
> > .
> >
>

