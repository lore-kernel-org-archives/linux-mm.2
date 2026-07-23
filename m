Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35D7FC531D4
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D99F86B00AC; Thu, 23 Jul 2026 10:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4B9B6B00AE; Thu, 23 Jul 2026 10:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3B546B00AF; Thu, 23 Jul 2026 10:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 943D66B00AC
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:50:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16F43404F3
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:50:29 +0000 (UTC)
X-FDA: 85020327378.12.1962B96
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3FB5C40002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:50:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GA4jIjgl;
	spf=pass (imf04.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784818227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sMNX+3I4sgI7mC5rRPgv1P42neSWIMRKOJpGLsqrlQ8=;
	b=nts6ajAQ6DsvddPkvUXvIJ09fuSceoYX/Bhd2q8br1p14huNPsbOIk+LurhYTEyeNkuaTc
	9viMtrpBmGvlCJ37aZcm2tZf9vUWXS61H5s/O/heUoF8sxE97YwYxkEqpCe/oCHEdnv/8y
	jbzWsXGk30hN+oksMOvY+Px6mGnIGh4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784818227;
	b=S/Dny8NdlL8O43sVlCTvb0ozEfwiwulo0Dp57h1uztGKvTADBrrF965W0oJ5iGBQnDq0NE
	azUY/XqLxKvhdhqAAFFqPri94OHyuKglxefZgNUpUi8agOwB0SNvgbO01uTHk0rvwkjbMO
	KYqH/lkWTruNvqaoN5iCDIpBqD4sUqs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GA4jIjgl;
	spf=pass (imf04.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-69e5f8a193bso1012187a12.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784818226; x=1785423026; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sMNX+3I4sgI7mC5rRPgv1P42neSWIMRKOJpGLsqrlQ8=;
        b=GA4jIjglxUunCwXGBSTaZ2Fr9rM827xJkuebrAFd1OAksFojw6uRvCJzzEu5yL5H3C
         EULvL0hYZxpd4zwQoaVGwnbABt75FZu1M7HE82TxoqaKnIRo3CovRtompPNZrqCQvsIS
         qlPWXUSEKssgOIXJH6HCGUoVj047uIts0GrQ5sbya22UO5jeuIXbgEBw6NrqckV/ojbf
         w4n85dFcbeafAYybkV2ZR+xmRLHR1+khat+L4nO1IxWimtm6RS1iyt5W8p99zQp7zt5o
         cU7KGZynKD7qyh00P95cwQ0UjYTVW1b8uDNSInUrda9Sax3BXHK1o0EWsfYu719xa+oV
         Wsaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784818226; x=1785423026;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sMNX+3I4sgI7mC5rRPgv1P42neSWIMRKOJpGLsqrlQ8=;
        b=gN5zUKXcfg+4GgfjbAR+25n8aBR7RrA1O8vcMorFeKOhXYSW493IqjYZAcDI8lI97x
         hmc3xAwlZ5H6kZxg8JvNt+nIWKiaZ5ePryOZNlw+yznEQ1kV9QK6iuPxX4/p6WQ+jhB8
         Drn+lMuKeh+zH9CBU6Uvpf6Ot/hL8/pOKUdrJXYSgzU6QEME5wO5HkeIdTVFFp6kSb/e
         0PftC2EDXL4NWFC8RmXNLPRCR7xcNkRGtCzLsTFr4eU7oIDlBpgxTcCVV/3WVGNektg/
         jE2dI6wepn9m1eHNe0ANpkTiueLICaGqfu389uAGaqSezHHE6yczkLl2CUCcZQx3oxQ5
         jISA==
X-Forwarded-Encrypted: i=1; AHgh+RqrxxvDzq0UG2ag22x2vP+XthM0KTcfo8waeCk2T0G5p/NWycha0mLQwdsR/pb+T8/el0syMOlv0w==@kvack.org
X-Gm-Message-State: AOJu0YxStN4MSXG2Fv1c/DIO9MiekUSN3pNN9d11UksG4vqEty7MMu4m
	fa9FejuTelzfYirxf3yNs1rTvcnuhpG3WOms3ibuPgVMgqU9SxDTie60
X-Gm-Gg: AR+sD10k+dgwMukTSYx6pJGotGXgFKzyD0lFDlCi3692uctoKqLLnA/nEHFpYqJBmH6
	xJz7tlhNpkCmCWakmG+HpWGB+ItypI+xJEp78fChnCeMcGkQMHVHMj/ezYxGILvNyHEbbXRohDS
	Mmi42Jsbs19FlZaT2zmS389ykmHAE+IuZ8HK7+AmiuTD8cKePzZ87kDWPTz18j8xsjepszpm+oM
	gt7q84z9GsQicly9QcVZdj1TKVCWXM98evqb8xJE6/9jijE9M2LL4t7M0hvlx7PsCYNTu0IvdAE
	/pQM0uCipJsBphQuD/mhjhCjMThGCwCOWa/+daZGQZjtaW/z61kFPI11HAbGKt7IIe+zTNPY5uZ
	bvDEHm24WCTThCu4FDgLuA9GesiLlbfTKxV0vvIHlRBdKCUbmqDs8e1ib6/SAg0fonbwk3uPCSM
	qSTlravgfPqNb1KGA3tYDb5iLb+wZcWsjrYYg35fBBC6NxYtDaOOG6/Brh3VroFIh35A==
X-Received: by 2002:a17:907:d649:b0:c16:e3b:7d6 with SMTP id a640c23a62f3a-c1c50d8eacdmr161031766b.54.1784818225309;
        Thu, 23 Jul 2026 07:50:25 -0700 (PDT)
Received: from debian.lan ([155.117.85.25])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32ac6ff3sm245282166b.19.2026.07.23.07.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 07:50:23 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: baohua@kernel.org
Cc: xueyuan.chen21@gmail.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com
Subject: Re: [RFC PATCH v3 2/4] mm: distinguish large folio swap allocation failures
Date: Thu, 23 Jul 2026 22:49:55 +0800
Message-ID: <20260723144955.374136-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAGsJ_4xv2AGrLY2PBA77fZiqctPEt_ERcUXUvFOdOG72LD_usQ@mail.gmail.com>
References: <CAGsJ_4xv2AGrLY2PBA77fZiqctPEt_ERcUXUvFOdOG72LD_usQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3FB5C40002
X-Stat-Signature: 4ixwxw91ngo61x46ykuhqait4te48x8c
X-Rspam-User: 
X-HE-Tag: 1784818227-703832
X-HE-Meta: U2FsdGVkX19L+VTPHAcuJJx1dsZGXIosPryXcpgTgh/cWxYvg6VPEH4RhxBJrE3f66XPttH67lMY7psgkMRUlIpGS7xKO/AqOCRTUhJQlepwNE3vT/HJa+ki0OaQKeryHRJIiqOwYV4jzCJd0PyheLreCsfJfrpUccyEAZaZbqs4ae/uv8U6Rbqkz70hjbx/HUb7HeX6aZ9tbs+AnnLD1cO6cz0U+T/zQL/35tWsa3ItkVXupzDjxCeZgeNsROU1GFOaxjl+P10hUUS7jxyHs0rzEFrTL4+ea4QBd4s2z52KGQoonYT/yxIcAEN/XStlrkgfuqKgTeCc5hsr0D+ZhAV5ZGNAvP29gBNd6zEQct3NwbSyRl6R5tXFg3764xwySvpNyEKFW4ulAg4wIZOxJ4mQF1D3qfBXw/81s02jfjzAzJkI0YXIqvPku7q05FpvVG02Q40/ATGmjgJfepPvlojdo+L02EjmkSjawYa5WPy85OSBEtA8WYXF8YnJdLtBHymBB2AvObKon85L8BcYfR7LT+uRAm/+RIPFsyg23KTS/Dz4NmE7h/aDbX7Zl2V3Agl6LpJ2ScAq7lIIcfmYR1RvekdqW3yQMidmBTmrc16TG4CvzqgsT9vn0QYBdCcZMj3DBf8rg939fyqDjX106G27ELXGpI2ekYI5ZLTeHoX3mOwuJmkSwmYI0AxGX+RViJfk3/JUr+69crZXsGFbTlqp0WmAkcTqxi5z+HNhJLfkt7mCXG4YZurbKXICefi8ZOhqmHiVPaMHVwlirQXBG8LwvFBrD/hWDocfK0K1nb3KUFJOO9GLi+myrsEqvlZK1PaQgl3Yv1QBpHuxdBpgvSAgtUAeZJmN5+Bs8H9Vp+hWJlmvyqAO3XU71YqquLUKL0pyeGCrrN/a7Uyx7TNNFg/zrnaCxkSFT6EnIV6liM7RHxWNXeD4gcWibcthM4XbXhKPPuaWX8KDmG0g50X
 VwTuC29O
 vCJ0P8KufmvfUhr/W1zolofhQ7NIpUa1REkKMnbHwKkgtQsFkY+wSQg5XXhF6OvshpoaFsZaS7NOYlq+JPO+jiVdWhwXhAVAjxa5ISp5aM4yjRX6jtuG96NL0DAUWiAhZ/BymsdnWIdM7MzW+QPg+/p4yQDZ4HXChzyzewlYN9hW/9Q2j098lizZ9AR6rZkm7+Pk1sikC/s5GR9JajAOuyg3fI9Xpqpmxlq/yRWNR/12TYMMEoDVGpak3h7cNvHFNAT+8ByXXDoA+tWqhHKsPH9VMuLgAkiSs1WoM+ijgfUN01m4gmlr3yuHSRwETEIX+5OGbnXPca+LM6+97AIXsq7cYa8eP3DjzVX/YvQTle2zOuMiIIrPmM5l2haTPvn1ImdT2ZLJ6dSx1gQaN1E6i9CODAoBFfyPOKlnroMqPcR/tIhBphoNweE6GqcABVvns7AYKB0vcxiHbEreYRr52DCMNCVwR1UH7dHOIs5B4jue3ESvUTq2lhDF9w6kEAN8mVdOPh3lJmLpt+q3lpAa08R2Rdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jul 21, 2026 at 04:15:13PM +0800, Barry Song wrote:
>On Fri, Jul 17, 2026 at 8:25 PM Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:
>>
>> folio_alloc_swap() reports most allocation failures with a generic
>> negative error code. Reclaim cannot tell whether splitting a large folio
>> could make progress or whether there is no backing space at all.
>>
>> Track the global free swap count around the allocation attempt and let the
>> memcg swap charge path cap it by the remaining hierarchical swap margin.
>> Return -E2BIG for large folios when a smaller allocation might still fit,
>> -ENOSPC when no swap space is available, and -ENOMEM when the failure is
>> not helped by splitting.
>>
>> This only refines folio_alloc_swap() return codes. The reclaim caller is
>> updated separately.
>>
>> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
>> ---
>>  include/linux/swap.h | 10 ++++++----
>>  mm/memcontrol.c      | 10 +++++++++-
>>  mm/swapfile.c        | 21 +++++++++++++++------
>>  3 files changed, 30 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>> index 7a09df6977a5..0695ac56457f 100644
>> --- a/include/linux/swap.h
>> +++ b/include/linux/swap.h
>> @@ -571,13 +571,14 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
>>  #endif
>>
>>  #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
>> -int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry);
>> +int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry,
>> +                                long *nr_swap_pages);
>>  static inline int mem_cgroup_try_charge_swap(struct folio *folio,
>> -               swp_entry_t entry)
>> +               swp_entry_t entry, long *nr_swap_pages)
>>  {
>>         if (mem_cgroup_disabled())
>>                 return 0;
>> -       return __mem_cgroup_try_charge_swap(folio, entry);
>> +       return __mem_cgroup_try_charge_swap(folio, entry, nr_swap_pages);
>>  }
>>
>>  extern void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages);
>> @@ -592,7 +593,8 @@ extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
>>  extern bool mem_cgroup_swap_full(struct folio *folio);
>>  #else
>>  static inline int mem_cgroup_try_charge_swap(struct folio *folio,
>> -                                            swp_entry_t entry)
>> +                                            swp_entry_t entry,
>> +                                            long *nr_swap_pages)
>>  {
>>         return 0;
>>  }
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 1e10f493d2a9..7c9e7072fb39 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -5472,12 +5472,14 @@ int __init mem_cgroup_init(void)
>>   * __mem_cgroup_try_charge_swap - try charging swap space for a folio
>>   * @folio: folio being added to swap
>>   * @entry: swap entry to charge
>> + * @nr_swap_pages: optional swap availability to cap by memcg margin
>>   *
>>   * Try to charge @folio's memcg for the swap space at @entry.
>>   *
>>   * Returns 0 on success, -ENOMEM on failure.
>>   */
>> -int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
>> +int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry,
>> +                                long *nr_swap_pages)
>>  {
>>         unsigned int nr_pages = folio_nr_pages(folio);
>>         struct page_counter *counter;
>> @@ -5495,6 +5497,9 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
>>         rcu_read_lock();
>>         memcg = obj_cgroup_memcg(objcg);
>>         if (!entry.val) {
>> +               if (nr_swap_pages && !mem_cgroup_is_root(memcg))
>> +                       *nr_swap_pages = min(*nr_swap_pages,
>> +                                            page_counter_margin(&memcg->swap));
>
>This looks a bit odd. Could we decouple *nr_swap_pages from margin and
>have the function always return margin instead?
>
>I don't think this function needs to care about the initial value returned by
>get_nr_swap_pages(). While folio_alloc_swap() may depend on it, they're
>different software layers, and we shouldn't couple them together.
>
>
>>                 memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
>>                 rcu_read_unlock();
>>                 return 0;
>> @@ -5509,6 +5514,9 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
>>                 memcg_memory_event(memcg, MEMCG_SWAP_MAX);
>>                 memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
>>                 mem_cgroup_private_id_put(memcg, nr_pages);
>> +               if (nr_swap_pages)
>> +                       *nr_swap_pages = min(*nr_swap_pages,
>> +                                            page_counter_margin(counter));
>>                 return -ENOMEM;
>>         }
>>         mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>> index 9174f1eeffb0..53a921ca099a 100644
>> --- a/mm/swapfile.c
>> +++ b/mm/swapfile.c
>> @@ -1690,12 +1690,14 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
>>   * swap cache.
>>   *
>>   * Context: Caller needs to hold the folio lock.
>> - * Return: Whether the folio was added to the swap cache.
>> + * Return: 0 on success, -E2BIG if splitting the folio might allow swapout,
>> + * or another negative error code if splitting would not help.
>>   */
>>  int folio_alloc_swap(struct folio *folio)
>>  {
>>         unsigned int order = folio_order(folio);
>>         unsigned int size = 1 << order;
>> +       long nr_swap_pages;
>>
>>         VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>>         VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
>> @@ -1706,7 +1708,7 @@ int folio_alloc_swap(struct folio *folio)
>>                  * the caller should split the folio and try again.
>>                  */
>>                 if (!IS_ENABLED(CONFIG_THP_SWAP))
>> -                       return -EAGAIN;
>> +                       return -E2BIG;
>
>We could also have the case where we're running out of swap space and it's not
>worth splitting, even when THP_SWAP is disabled.
>
>>
>>                 /*
>>                  * Allocation size should never exceed cluster size
>> @@ -1714,10 +1716,12 @@ int folio_alloc_swap(struct folio *folio)
>>                  */
>>                 if (size > SWAPFILE_CLUSTER) {
>>                         VM_WARN_ON_ONCE(1);
>> -                       return -EINVAL;
>> +                       return -E2BIG;
>
>Similar to the above.
>
>>                 }
>>         }
>>
>> +       nr_swap_pages = get_nr_swap_pages();
>> +
>>  again:
>>         local_lock(&percpu_swap_cluster.lock);
>>         if (!swap_alloc_fast(folio))
>> @@ -1730,11 +1734,16 @@ int folio_alloc_swap(struct folio *folio)
>>         }
>>
>>         /* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
>> -       if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
>> +       if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap,
>> +                                               &nr_swap_pages))) {
>
>As explained above, we shouldn't couple two different software layers.
>don't use nr_swap_pages() as the initial value of memcg charge.
>
>Best Regards
>Barry
>

Thank you very much for the careful review, Barry. You're right that
passing the value from get_nr_swap_pages() into the memcg charge path
unnecessarily couples two separate layers.

How about the patch below?

This version keeps global swap availability and the memcg swap margin
separate. When swap allocation or charging fails, the memcg charge path
reports only the remaining margin in its own hierarchy.
folio_alloc_swap() checks global swap availability separately and uses
the two results to select the return code.

If swap slot allocation succeeds but the memcg charge fails, the global
allocation has already succeeded. In that case, folio_alloc_swap() uses
the remaining memcg margin alone to choose between -E2BIG and -ENOMEM.

The early rejection paths now return -E2BIG only when splitting may
still make progress, addressing the cases you pointed out for
CONFIG_THP_SWAP=n and size > SWAPFILE_CLUSTER.

I added mem_cgroup_get_folio_swap_margin() to return the minimum
remaining swap capacity across the memcg hierarchy associated with a
folio. Unlike mem_cgroup_get_nr_swap_pages(), it reports only the memcg
constraint and does not combine it with the global free swap count.

I also added folio_alloc_swap_error() to avoid duplicating the checks
that decide whether to return -ENOSPC, -ENOMEM, or -E2BIG. Do you think
this helper is worthwhile, or would it be clearer to keep these checks
directly in folio_alloc_swap()?

Thanks again for pointing this out.

The updated patch follows:

 include/linux/swap.h | 16 ++++++++++++----
 mm/memcontrol.c      | 33 ++++++++++++++++++++++++++++++++-
 mm/swapfile.c        | 31 ++++++++++++++++++++++++-------
 3 files changed, 68 insertions(+), 12 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7a09df6977a5..87c58f69d11d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -571,13 +571,14 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
-int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry);
+int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry,
+				 long *swap_margin);
 static inline int mem_cgroup_try_charge_swap(struct folio *folio,
-		swp_entry_t entry)
+		swp_entry_t entry, long *swap_margin)
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	return __mem_cgroup_try_charge_swap(folio, entry);
+	return __mem_cgroup_try_charge_swap(folio, entry, swap_margin);
 }
 
 extern void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages);
@@ -588,11 +589,13 @@ static inline void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_p
 	__mem_cgroup_uncharge_swap(entry, nr_pages);
 }
 
+long mem_cgroup_get_folio_swap_margin(struct folio *folio);
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
 static inline int mem_cgroup_try_charge_swap(struct folio *folio,
-					     swp_entry_t entry)
+					     swp_entry_t entry,
+					     long *swap_margin)
 {
 	return 0;
 }
@@ -602,6 +605,11 @@ static inline void mem_cgroup_uncharge_swap(swp_entry_t entry,
 {
 }
 
+static inline long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+{
+	return PAGE_COUNTER_MAX;
+}
+
 static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
 	return get_nr_swap_pages();
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1e10f493d2a9..0ebbbaffb522 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5472,12 +5472,14 @@ int __init mem_cgroup_init(void)
  * __mem_cgroup_try_charge_swap - try charging swap space for a folio
  * @folio: folio being added to swap
  * @entry: swap entry to charge
+ * @swap_margin: remaining memcg swap margin if allocation or charge fails
  *
  * Try to charge @folio's memcg for the swap space at @entry.
  *
  * Returns 0 on success, -ENOMEM on failure.
  */
-int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
+int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry,
+				 long *swap_margin)
 {
 	unsigned int nr_pages = folio_nr_pages(folio);
 	struct page_counter *counter;
@@ -5495,6 +5497,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	if (!entry.val) {
+		*swap_margin = page_counter_margin(&memcg->swap);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		rcu_read_unlock();
 		return 0;
@@ -5509,6 +5512,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		mem_cgroup_private_id_put(memcg, nr_pages);
+		*swap_margin = page_counter_margin(counter);
 		return -ENOMEM;
 	}
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
@@ -5554,6 +5558,33 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 	return nr_swap_pages;
 }
 
+/**
+ * mem_cgroup_get_folio_swap_margin - get a folio's memcg swap margin
+ * @folio: folio whose memcg margin is queried
+ *
+ * Return: Remaining chargeable pages in the folio's memcg hierarchy.
+ */
+long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+{
+	long swap_margin = PAGE_COUNTER_MAX;
+	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
+
+	if (mem_cgroup_disabled() || do_memsw_account())
+		return swap_margin;
+
+	objcg = folio_objcg(folio);
+	if (!objcg)
+		return swap_margin;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	swap_margin = page_counter_margin(&memcg->swap);
+	rcu_read_unlock();
+
+	return swap_margin;
+}
+
 bool mem_cgroup_swap_full(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9174f1eeffb0..f90ee2de53fa 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1682,6 +1682,16 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 	return err;
 }
 
+static int folio_alloc_swap_error(struct folio *folio, long swap_margin)
+{
+	if (get_nr_swap_pages() <= 0)
+		return -ENOSPC;
+	if (swap_margin <= 0)
+		return -ENOMEM;
+
+	return folio_test_large(folio) ? -E2BIG : -ENOMEM;
+}
+
 /**
  * folio_alloc_swap - allocate swap space for a folio
  * @folio: folio we want to move to swap
@@ -1690,23 +1700,26 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
  * swap cache.
  *
  * Context: Caller needs to hold the folio lock.
- * Return: Whether the folio was added to the swap cache.
+ * Return: 0 on success, -E2BIG if splitting the folio might allow swapout,
+ * or another negative error code if splitting would not help.
  */
 int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
+	long swap_margin = PAGE_COUNTER_MAX;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
 
 	if (order) {
 		/*
-		 * Reject large allocation when THP_SWAP is disabled,
-		 * the caller should split the folio and try again.
+		 * Reject large allocation when THP_SWAP is disabled. The error
+		 * classifier decides whether the caller should split and retry.
 		 */
 		if (!IS_ENABLED(CONFIG_THP_SWAP))
-			return -EAGAIN;
+			return folio_alloc_swap_error(folio,
+				mem_cgroup_get_folio_swap_margin(folio));
 
 		/*
 		 * Allocation size should never exceed cluster size
@@ -1714,7 +1727,8 @@ int folio_alloc_swap(struct folio *folio)
 		 */
 		if (size > SWAPFILE_CLUSTER) {
 			VM_WARN_ON_ONCE(1);
-			return -EINVAL;
+			return folio_alloc_swap_error(folio,
+				mem_cgroup_get_folio_swap_margin(folio));
 		}
 	}
 
@@ -1730,11 +1744,14 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
+	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap,
+						&swap_margin))) {
 		swap_cache_del_folio(folio);
+		return order && swap_margin > 0 ? -E2BIG : -ENOMEM;
+	}
 
 	if (unlikely(!folio_test_swapcache(folio)))
-		return -ENOMEM;
+		return folio_alloc_swap_error(folio, swap_margin);
 
 	return 0;
 }
-- 
2.47.3


