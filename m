Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA28EC5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 03:30:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F062A6B0194; Mon, 17 Aug 2026 23:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDFDF6B0374; Mon, 17 Aug 2026 23:30:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF79D6B05CA; Mon, 17 Aug 2026 23:30:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B60D16B0194
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:30:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DFF61A0ABF
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:30:45 +0000 (UTC)
X-FDA: 85112963250.26.FBEACF7
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id 63A0018000C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:30:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ckX0z/0O";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787023843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=22vWpSEv9L/aT9IWL8DC5f6j4F4SFI3rpTeWjfdb9og=;
	b=rXQz/487EHWN7/ODahqVnIP6KBzg/pib3QQhBLf9LgLiuNPgqxwhMKjP0d5TSLHDQMn1+y
	kCJMBhYXs21xX4ONcna3Xt/5qz3tKHgp3RkVwK58hq0/56x1oKu7+J2/EyQTzuD9CdlSMi
	uwv6MXEktxiSVvWDHLK76ychTCx/W1A=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ckX0z/0O";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787023843;
	b=1XfnPA9G9ciV7SJVQwxqogqbphQUzdH383YY8118DWT39cwBdAft5sH6x1Z9Xe5jMv0fUY
	durezNaWnqUVB5I9asTis8uXZsjK7nE5Jzp374/LiXH5dO4aGauOwZ81m7pCWT81Ry89Kk
	nU/hQfrBgJnhMiahs3Y+NT9fXgmFrCU=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4996e2575dbso26665e9.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:30:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787023842; cv=none;
        d=google.com; s=arc-20260327;
        b=h6PLRU1exnHP1SUgpROPOm7RU1mkuNTTSZP/r05WS8gAp/20SsxePRbIZIIEKeF9AK
         CYPhVetqF7cJPMt3UuakId6jibd4Tyon2VBVl6y5hS22pLTFdfxB11Qhh9wz3neFJSxF
         WLTJEiz4mBQh2F/pdMHVxKSzf3la3rbV1A6eXi7kyL31Xj+QrIrP/z5YjOKk1HPUkLqn
         QifcvxfXZK3E3tKx6lLqc90F/UK+p0r7eM9KV+D+QbBVmAnfvJYMqJ2MSZWkO9xpoelX
         K3h61pALLoQMT2bvSpSr/Yl8wdvvttagJerTS1gyOgtugyROw5D16tboI86QCfLwLfcP
         EVMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=22vWpSEv9L/aT9IWL8DC5f6j4F4SFI3rpTeWjfdb9og=;
        fh=Y3PZHbwncHkBiYuAFsf0J41972Vpe30Rn2ZoldnTp3g=;
        b=GciL+qzF6EJIsLqz3vfc3jo+lfr7X/mjNsceKlem1H17BchnuVNvbWXf42j9eG3hVX
         odXwAAVHV77QCd5m/5CQp73N/DZ4rMJqkLhT3Kd3sFXVM8X5zHIDJRTXINCBEKmLw4c/
         Br7tguxBJh9qWubLWi8YrfcxSnmTwP4N3xQwDa4IoOXTJugx2vNhL3GrRAN39DT2I3yl
         KcHt/uKFrXXBi/UluM9P2VN+n6W+JjszHFsDC8h1Y5CqyvL6/pCLwLT48C4/8VmuZ0jo
         3MmBx975h4s1jNz2lFd2UdkGBmnsM/Jor255GAZSBF/dh3ujrvoT08ImpKWpm0BH/JDS
         eOlA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787023842; x=1787628642; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=22vWpSEv9L/aT9IWL8DC5f6j4F4SFI3rpTeWjfdb9og=;
        b=ckX0z/0OiG4GxVRD/KPkeb0sDGHnUekSdNsnSuj254tCcYQkPOeKvLijf4NiLC+d3a
         H6k4KA/SV8WrXqNvyNcfd3j6zpPVwJBZz4/sU4SX/2AedHIPPCwh5T3oKsRKuwlXncez
         21s6uUS6+0/guvk0dd/VcOFhchpHl69yHbRTvVvPdLSNyHNrrbhtn8uM8McZcmK8a89X
         Y1Lk4mgkWQeodthelxmKB4zyCEmobZZXGPVYsOTfxMzMHnJS5pH/JNs/0vLseJOevONP
         3PSOuB23/7qY1Mo2cLBLajhUiXg4RkaEPdA6niopTnrxkFy1yS5Mpy/TKixarrT+IkNc
         /ejw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787023842; x=1787628642;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=22vWpSEv9L/aT9IWL8DC5f6j4F4SFI3rpTeWjfdb9og=;
        b=fQTHDXTaH3h017ctWL3mkB7diCzscbI4I9GBGmzTigpWsxHPGsU2C8wvF8fOmYZydD
         JLUqqxUw4U7C4u40zVBOYQNkeMrgyoJ8DWLgIqr1+EE3+bKblPHQpxVWnKTjEM7tlRQr
         oIjnXBhM7phFJVXRJQZPM5F3xzwz7bwr6c2qHWqo4ZsyBJya7xELkdRkcTyKl+/DJLmM
         8Rj6DygllY5c6ATyn5Vp0Jb58qWdSdds12F44ORQTZmWuWMJZU4Tdy3QtLoF/5qVzErH
         81mHzI+U1UL54snMICxnvxZLl1htX85g+2cORQSiT4NhLvkb0u4ChpuyPW4S0/dsDG2K
         xAHw==
X-Forwarded-Encrypted: i=1; AHgh+RqJfuv7o6g+8dLHu+XWf5q9Fv3pR1sk5cp4G/5LybepB+MJPT7Z+YRLoEVCpyTNVWyaV8rYINPwvQ==@kvack.org
X-Gm-Message-State: AOJu0Yy3KynS0Ptv/kgb46og4yblyCh13CRbyddjQW4EY4AloD4jm0hY
	yU/x1QpwMaYM59zuW+GA+axcMRflWT4esl0B3geEDuMSDRc2QaPN6qzRr8PKCvbqkuvXzvZF8xA
	q2kZ3N5JPv6lUGmub9Xd+AurPlPsC1q0bw1DSVD/Z
X-Gm-Gg: AR+sD12wWYFu55mr6V+qtb85Da5/wf11AJw5A3/PAATSrDRT+9qQfftuNFwf0zZ6lrl
	zjMLvG8rqQzc2KkrAGL6qcTGpz0xd8QjahlFCMQPN/iVfKPMbPTWOrwePnUVCyspTQRc7kh+rbO
	SZ6yHNuF8lc0lRq5WdpkM+ezEHVUOEH1CI55xm0nFmZse+S2DI0dj9ebn5F8+glt6EbCfpQgvjB
	plQawLXXlmVU37W8FeK8nU3f939rLLO+OUDgHDN4DWHhUu2OVLWT06fGXgW3D3sSYTrSG4Ih/Z6
	ocbxX1krVTfvo0nq2JgratybcmNaSZK1Djp0IzpEv20scTDZhPSiY5BIH7v+b5FXPcw3Xi8lI+l
	NDw==
X-Received: by 2002:a05:600c:e556:20b0:499:8ed2:d358 with SMTP id
 5b1f17b1804b1-499a0e46171mr599785e9.2.1787023841369; Mon, 17 Aug 2026
 20:30:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260705180714.3708947-1-jiaqiyan@google.com> <20260705180714.3708947-5-jiaqiyan@google.com>
 <c5d4a1e4-cc3f-5cee-2ec3-53d5eb01bbb2@huawei.com> <CACw3F52RfFR4gZ9+kAmi6fkq39t6Sk1oUW0jqiXOFAAgn0iOyQ@mail.gmail.com>
 <d908b3d6-e3db-6eaf-100f-ffc1dd765c55@huawei.com>
In-Reply-To: <d908b3d6-e3db-6eaf-100f-ffc1dd765c55@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 17 Aug 2026 20:30:29 -0700
X-Gm-Features: AcwNN1U9hzi5ZWD7Mpz-DW5c2fD3lFZLcVDqyn2zIKvbLp364lyU3HSKvWO6JZA
Message-ID: <CACw3F537_QTg8eax-aB2jDv+tEqgg8GqsP=T9wEfpH+zNttanw@mail.gmail.com>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 63A0018000C
X-Stat-Signature: 6wdeao3sxzjrmub8y19akf466bx8tx9g
X-Rspam-User: 
X-HE-Tag: 1787023843-186006
X-HE-Meta: U2FsdGVkX1+xpiUEzyVBglcvw5e3SzCa/v9cTDMAFV7exFa/WoO37OmKQ/z+1l/GpK7EgBI9u1Xj2olPyO171ZTtMCIqOhhZ3GY3a7TUQDmGNPcbARL/Bqjm06OC/O1Alia3DZLxKqtjyF1+hBA1uWZISbsHev3hhvDA+qEKvDBB7JKG0MHM2/+t8M7DQpq7IkueJqcSKqQpjoambjjcDSe7nanLtVF/ig8AHsZHbplSE5KwcJSGGr8/ADugQkC45bBr0//tm2pE3IzGasEtKX1Mtb1kKwo0hgQATrx3Udn7ERHuZ8VWTGWQl8rJn19N2OQ72ZVlp1qLSNkx1GW3VCOI7imOYBzwd91arP2+HNiATw/1f/l0itKWrucqlmHL8+CvLgr30wllAWF/wyMlVeTfV9aoQ0EH/Oqoro63ziTB2xAM8F3wVzYVACa18hQa+ioQwEJocoOr/ro2+AtsOrJYQe6zYzokWP3opqjktILV/6feZ1G8U9aySKlCRfYysuHCXqY3A+fVoLK9IyhjALrjFlBLMP7P6bW7vZ/0w5OB4wIJ14MtmJK7nIWG/NoUkS8XeoIRlKZeyXhaKtFG2wVuXkpP8kUHrLCXRgNroXBRyGm+5JJHLKts0SUswDac0xyOCO+CdgId179vfKXxFJTycFPrIUI3pf+lS3DZZz6HDTUnmLJk9NneuoeNI+p58qd7Ik3tkyfcxi/i4ssZ6u1UXrQthFlzVrnkdqzbPA79Op7FmV6FrShlNBRjC44Lm/qW3WdYP7ETbq1W6S4Qbe4WeDHi7sUCcfIxqK1lEjekNTTT5fXlkBIa0z9zgBOFKWebOAmwUgQ7fFy1Z9DLg71X21yDQwI6LKREKzgEhczs5qBjtiLiRct3wpfzrRo65iTn9LJHRhKB2brtLpHiaIXLXBeEzgCynmQibU2JL7HsnZa/fV2ttEuaD4LirIdvbvWpprRrRZ8M/YYWRKy
 NmOtS+8I
 aUT7jUkeDrMTVOidZmrz3DRC88QSF/HRrMxfCHq0Z0ClxEUTo3QiQhZqmtcro3J2LOhEiClcymK9c9aR9xrNrwQcsMbmM084UpmfrMgRQ3cnvdPNES9oTclya9nBFyl5tZvvseS58aPXINoMpQNVkLBAoKgzK5Wy9vh6CvHmEZJgh0hb6N5zrU1n/CogBWsD3T2u7jeSx4K3YqArBYBNUF7G6+5nkp7eVAleEGK+huYnHHverEkv2JdEo5nYg5zdW3+6Zx57jPYFUkL7/E+2ZkNzAIBiO9J64/chh/0Wb5OD5/z+ypwLAj/lH3MVeT0oy9gfKOIKUyUiVwEYHYrO2mdEVjfGwjmOEn23B/YyR84lnlLU7tE1BXeRQoDSFnYHGlNTjzDX6JUmkft3GU3ww4VIESzJ8HwDi6oOJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 12:23=E2=80=AFAM Miaohe Lin <linmiaohe@huawei.com> =
wrote:
>
> On 2026/8/17 8:29, Jiaqi Yan wrote:
> > On Fri, Jul 17, 2026 at 12:37=E2=80=AFAM Miaohe Lin <linmiaohe@huawei.c=
om> wrote:
> >>
> >> On 2026/7/6 2:07, Jiaqi Yan wrote:
> >>> Now that HWPoison subpage(s) within HugeTLB page will be rejected by
> >>> buddy allocator during dissolve_free_hugetlb_folio(), there is no
> >>> need to drain_all_pages() and take_page_off_buddy() anymore. In fact,
> >>> calling take_page_off_buddy() after dissolve_free_hugetlb_folio()
> >>> succeeded returns false, making caller think __page_handle_poison()
> >>> failed.
> >>>
> >>> Add __hugepage_handle_poison() and replace __page_handle_poison() at
> >>> HugeTLB specific call sites. The being handled HugeTLB page either
> >>> is free at the moment of try_memory_failure_hugetlb(), or becomes
> >>> free at the moment of me_huge_page().
> >>>
> >>> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> >>> ---
> >>>  mm/memory-failure.c | 36 ++++++++++++++++++++++++++++++------
> >>>  1 file changed, 30 insertions(+), 6 deletions(-)
> >>>
> >>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> >>> index 3d15b4c1b694..a37b67550718 100644
> >>> --- a/mm/memory-failure.c
> >>> +++ b/mm/memory-failure.c
> >>> @@ -174,6 +174,30 @@ static struct rb_root_cached pfn_space_itree =3D=
 RB_ROOT_CACHED;
> >>>  static DEFINE_MUTEX(pfn_space_lock);
> >>>
> >>>  /*
> >>> + * Only for a HugeTLB page being handled by memory_failure(). The ke=
y
> >>> + * difference to soft_offline() is that, no HWPoison subpage will ma=
ke
> >>> + * into buddy allocator after a successful dissolve_free_hugetlb_fol=
io(),
> >>> + * so take_page_off_buddy() is unnecessary.
> >>> + */
> >>> +static int __hugepage_handle_poison(struct page *page)
> >>> +{
> >>> +     struct folio *folio =3D page_folio(page);
> >>> +
> >>> +     /*
> >>> +      * Can't use dissolve_free_hugetlb_folio() without a reliable
> >>> +      * raw_hwp_list telling which subpage is HWPoison. So do not fr=
ee
> >>> +      * them to the buddy allocator. dequeue_hugetlb_folio_node_exac=
t()
> >>> +      * will ensure to never re-allocate this hugepage.
> >>> +      */
> >>> +     if (folio_test_hugetlb_raw_hwp_unreliable(folio))
> >>> +             /* raw_hwp_list becomes unreliable when kmalloc() fails=
. */
> >>> +             return -ENOMEM;
> >>
> >> There are some branches in __update_and_free_hugetlb_folio that will l=
eave hugetlb
> >> folio untouched:
> >>
> >> static void __update_and_free_hugetlb_folio(struct hstate *h,
> >>                                                 struct folio *folio)
> >> {
> >>         bool clear_flag =3D folio_test_hugetlb_vmemmap_optimized(folio=
);
> >>
> >>         if (hstate_is_gigantic_no_runtime(h))
> >>                 return;<-- 1
> >
> > Thanks for catching this, Miaohe.
> >
> > I think the most challenging part is that
> > update_and_free_hugetlb_folio() must support deferring freeing (via
> > schedule_work()), so adding a return value isn't that straightforward
> > without some refactoring...
> >
> > If making __hugepage_handle_poison() check
> > hstate_is_gigantic_no_runtime() =3D=3D 0 (or
> > gigantic_page_runtime_supported() =3D=3D 1) isn't an absurd idea, we ca=
n
>
> I'm afraid this might not be a good idea. Maybe we could re-check page st=
ate after

Any specific reason? It seems to me that code that included
"hugetlb.h" can access gigantic_page_runtime_supported().

I feel checking gigantic_page_runtime_supported() upfront is cleaner
than checking page state after dissolve:

if (!gigantic_page_runtime_supported())
    return -EOPNOTSUPP;

vs

/* Direct state check after dissolve */
rc =3D dissolve_free_hugetlb_folio(folio);
if (!rc && folio_test_hugetlb(folio)) {
    /* Dissolve failed silently due to unsupported gigantic runtime freeing=
 */
    rc =3D -EOPNOTSUPP;
}


> calling dissolve_free_hugetlb_folio?
>
> > just do that and avoid adding return value to
> > __update_and_free_hugetlb_folio().
> >
> >>
> >>         /*
> >>          * If we don't know which subpages are hwpoisoned, we can't fr=
ee
> >>          * the hugepage, so it's leaked intentionally.
> >>          */
> >>         if (folio_test_hugetlb_raw_hwp_unreliable(folio))
> >>                 return;<-- 2
> >
> > __hugepage_handle_poison() already checked this, and with mf_mutex no
> > one can set raw_hwp_unreliable.
>
> Agreed.
>
> >
> >>
> >>         /*
> >>          * If folio is not vmemmap optimized (!clear_flag), then the f=
olio
> >>          * is no longer identified as a hugetlb page.  hugetlb_vmemmap=
_restore_folio
> >>          * can only be passed hugetlb pages and will BUG otherwise.
> >>          */
> >>         if (clear_flag && hugetlb_vmemmap_restore_folio(h, folio)) {
> >>                 spin_lock_irq(&hugetlb_lock);
> >>                 /*
> >>                  * If we cannot allocate vmemmap pages, just refuse to=
 free the
> >>                  * page and put the page back on the hugetlb free list=
 and treat
> >>                  * as a surplus page.
> >>                  */
> >>                 add_hugetlb_folio(h, folio, true);
> >>                 spin_unlock_irq(&hugetlb_lock);
> >>                 return;<-- 3
> >
> > __hugepage_handle_poison() should not get into this if-block because
> > dissolve_free_hugetlb_folio() must have
> > hugetlb_vmemmap_restore_folio()-ed successfully, so clear_flag must be
> > false here. Otherwise dissolve_free_hugetlb_folio() already returns
> > early without update_and_free_hugetlb_folio().
>
> Agreed.
>
> Thanks.
> .

