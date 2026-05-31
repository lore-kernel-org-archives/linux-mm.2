Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC470CD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 13:47:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3F736B0145; Sun, 31 May 2026 09:47:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF0FA6B0146; Sun, 31 May 2026 09:47:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDF386B0147; Sun, 31 May 2026 09:47:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9F2E6B0145
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:47:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F61F1C098C
	for <linux-mm@kvack.org>; Sun, 31 May 2026 13:47:56 +0000 (UTC)
X-FDA: 84827843352.17.4A1218A
Received: from out203-205-221-164.mail.qq.com (out203-205-221-164.mail.qq.com [203.205.221.164])
	by imf08.hostedemail.com (Postfix) with ESMTP id 98F2B16000C
	for <linux-mm@kvack.org>; Sun, 31 May 2026 13:47:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=Lh9e10BA;
	spf=pass (imf08.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.164 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780235274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMgCALuI33oMq+NTpqWsYWT4BttSOIXYqL2dwKqfEiI=;
	b=KqUIYPF0X5GFsSvvbB9Rf6uXgNnrhGO2UI4VCc/VG05it9E9CW8ImI8tDlvipddtlbfT3u
	h0rjOrhaReC0Za2FIuaKTETo1Z5ucpY5QmFrcDCSxqLtmhQcXKtrOr0rEq2AK+HJIik5kc
	Hv9zH9J+iu4oW+w8uR3a4rDX2uAvAzQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=Lh9e10BA;
	spf=pass (imf08.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.164 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780235274; a=rsa-sha256;
	cv=none;
	b=hTdVsEK1NEDofS9iOjeA3SkIE5CmAStusKg6rtFNPp/jXmE0nApNfrwyfl0464nsOCyBPZ
	W6mPv1B0XyzgXXFWgDlXFht2Aqciuf7deqvn3D6lyB/Z+SFJqcPmSd+ZFwV/Z5bAtn1xzb
	YbWxb+9X0SNSCsuYa0shdzib3OgNPKI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1780235269; bh=dMgCALuI33oMq+NTpqWsYWT4BttSOIXYqL2dwKqfEiI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Lh9e10BAJ4VMtZOWUmPCoDX2fSZP9rFQEmqrZnaMMRsw2LK4BEGFiwVYGcbS7dK/p
	 cyX0Nbd7Qxe/OLXLtkrThD0rImN3hPDxBPWIGoYSVp9cXZPqA29nqORv4+FSX0mKZP
	 9X7H7PawVbC1bIf2qVXkOacDl9Fq83KNxri1vQmI=
Received: from [10.24.9.42] ([123.112.11.230])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id BEEADE90; Sun, 31 May 2026 21:47:46 +0800
X-QQ-mid: xmsmtpt1780235266tvu621kwx
Message-ID: <tencent_DAA37C24E8A6C1828BABF3B941517B3EC705@qq.com>
X-QQ-XMAILINFO: OOO9dHjlsLs75FAwwwY44DNcKKFwqpomfDQP8q14PQzqqsJzOVCnt5Tp2JaruF
	 MbHAtQZDHeT/fcqyFlm287Hzo8h+BPS0NgG+fuJ7SvJHKDl6L1FWRE9TO208w7IIBd/tjy526wk5
	 LHha8xpiX2poiESu2l2zm0SU9fkkz4++DnNFXvt4UirbGgppKWZe8q/5H0WI2oYkFbrvD87p1YyB
	 FKbqisQQO0pLpUjn/miviAxR5sXo58e+KhHOlGvFbQTL/gnOpinJPtBu6CT/4TUyhrMbndQNad+D
	 cux3V9Js/zVy66JxunhjPqDVAeSjhFljMNiRNXlIR3tAVfMtFS7SrXojqVBhTcf/HADXu7nDx51U
	 vLkY5fpR5kNnh+uEien1vCdIAE3TjHRZP8NxAZZMfO4fSVqgJOINnWlu1lkOxcl4fLB3BlBb9tYB
	 SMSaVRS1JduawaUVHUh1gIh3YS4riMC3FndEfHI2K6YskBy4I/r9iJxsytouVs59wykewx6skWuo
	 50/IN4lVWAreR6KXFrHuc1WqgrTwgcBC3pCFwW1qtzhhtG0z96KE1QTZtjctT4AdRdVoO9IyJ5AG
	 OuxRGkZ9pRzlJVtxEsjTUuD8bU7OzBaQQSQQAcgIVKCm0iZslUvap/GMDDtBk14lMx2yUpzTEm81
	 b4+LU+msuPDcSbNryY292W9z7Rn8JBvUqh35wdu6gIgsUc/nS/tHVIjaeViWNrLKvoganDMss832
	 kfVoMJaAzY2YVg+7vbCMsyuxrKzXLv1FuR2R/b22BdAh/ktL1Zkg0PmkWhOkTsDpodTlfhJZXRtt
	 +MoZl6wjems0prdQAA8wQw9Sc7A5L4WYQ6dN6HJrQCpGZ+huZ9QNqaU++UE6hwqDUSxQz/1rGuPd
	 NF1dpYVB3eU1oiek39tOwC7uSvUNIPrYULaGqnJKAoTyLbYTwcs0pxhefGg5zE/tKMpYoa2eMU1Z
	 S5nr/IXzZuVf6bQA215CO+FdafRvo700U51n54Qim8esxQYkD2QCiaQmXNbQ08sFnLhI8DoYF8kW
	 44g+pOVl2MDkPXmHWqdXVEp/c0D+D6a8qRcgnWcbS/jVHDZwbTQZG22JmDr5WaBbBzAt3BVW9qFH
	 kkfjB3Df9L9FEWP1AJJyC1dsdIig==
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-OQ-MSGID: <daad26e0-50c8-40ec-9142-a6c6fad3378a@qq.com>
Date: Sun, 31 May 2026 21:47:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/9] mm/zswap: expose range state for swapin policy
To: Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Alexandre Ghiti <alexghiti@meta.com>, Kairui Song <kasong@tencent.com>,
 Usama Arif <usamaarif642@gmail.com>, Chris Li <chrisl@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
 <tencent_C78A02F3C41E15233C371816825C7DCF8708@qq.com>
 <CAKEwX=NUQb5b4T49dbRV0_41QYRRuLkQNUg+FVDpJiobCCCh7g@mail.gmail.com>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <CAKEwX=NUQb5b4T49dbRV0_41QYRRuLkQNUg+FVDpJiobCCCh7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 98F2B16000C
X-Stat-Signature: 3whhow4csjhwb1oupcxm56ab5qi4pgos
X-HE-Tag: 1780235272-663504
X-HE-Meta: U2FsdGVkX1/cnYZDd6Qacq3pmCp5rr/nAhzjeKnlnzAXs6qydduJNj9mKcNdiJNtk5+oEEpyFROzgZYZbxubjymsWcYbB09gehaKTZ58AWitdaVqBx9vLYJEoPV8m+tEckPzO/Yy8hF0ZjGdSZZFtOrgn/PIOxIkwYt2zc7CJ75Ef+WXrkB5/IVX+ZK2gNZLBG2fcw49HxUKKC2MXnIc00g32IePmxarPMljVOlPcWvnkejs8+HucD5pdQ8ZQH3quIvRB40/HZ2n7i8R6Nrd94RsZawt6fteezQH1+XzlA9Resw0wyPJJeG9c9Uj89jFZGLsCrvjBgrfjh9FRh0ys2c72WJvtmhy6GA1kOxjSafRAvD6dAYoDC6KmL5cgm+KPAnu2vxtsU8wi6TPKnOmB/EytJph40L7K5KiiX1qIC+TLgOKiRi2COPv+CKykbqxfmZ4UBJeuWnpnIqVpAQhQu0yXXdJ/Bx5sDrc8aVum7SLA2ZUeiuc7bKSR6X1BdP5y5HJBa0FOYJ2jASU9vFSQdmz4jlyWP2WFfXbFa8HrflqaT6HSsP2zLTRdVgG4D7JW5Fx2ntSjqnkFKyrWkiu3DUTFbpBP6HofGtLwzPOmlcp6+DCeQI5Gqdz0qjh8WjZEE8GbyXGowKhiqh9xn1BMn1dnHhPvk0Qp4mAHYMTFBq7xYJPYsgG/6MQquRLYKw7Odg4BiRydCxU9/+0BaX2QU3H5dQsu0/d98RMIu6C3SrFMHd1bVK2KvdmR+PEg9kLEtQiPuHXyadVsNCdd38X7pqqaleYAhD4+DsTBYJN9tOUj18w8fBno1wKpSwhv4fMzbYo6ujNYyHX5pTDnjpmBLncRkdZwC+nyDqXvpqxZRlJMldYE4/cgcc5yZIS8WcOANsFffwO+W+MxRKBXJsNg7lh89+Uc1rF1ttPyVgpedVeY/WzH7QRUsr5zt7E11tA7ECvcmTJUbHrNEQMBEB
 q92x/Twu
 NSYXnCHySkEuOkRl+KsmUhA/CtExL72u2UiAN1j0cZmHJRPwVp4vwqjGRZFGqPkvWODdWkg2aD3CCCwKlDD4nnC4uc0y1rl6S4HEBrjvLVpQjKGAgm6lb0Px286rONbkgxsbbyjlMmdQX/JRFaI51sDWfseRXeu6sEenwaNoFmBdxfu5dQyrLNAdShJwm0HmJopQYQ1Isfo7LPOGMiwHl81/uSu8cf+zpr6yeH6/OZc45lpJooDBJMjaWb+/hQ5Ec/GERJ+zh/xVQZI1TFggh+2nG8RiIOT6t/WUte+lSb2QZN9jyRNHWamB+/WzR5za7mzImKrjv/0juXErxbKL029z5fGdkDhK1xtLjXfC02Glfo7D+zvXDvIpVKBmakxYhJxxg/KB3n5NYtrzedSbQhGo/DjdCIxBIYoOWl7GrhQ/BJ2yTPqHiXVz3QA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/30/2026 2:35 AM, Nhat Pham wrote:
> On Fri, May 29, 2026 at 5:19 AM fujunjie <fujunjie1@qq.com> wrote:
>>
>> Large folio swapin needs to know whether a candidate swap range is fully
>> backed by zswap before it can choose an order. That decision should stay
>> in common swapin code, not inside zswap.
>>
>> Export two zswap facts for that caller: a lockless range occupancy snapshot
>> and the current zswap reclaim-pressure state. The range state is
>> advisory only. Writeback or invalidation can change the backend after the
>> snapshot, so users must recheck before issuing large-folio IO.
>>
>> Signed-off-by: fujunjie <fujunjie1@qq.com>
>> ---
>>  include/linux/zswap.h | 26 +++++++++++++++++++++++++
>>  mm/zswap.c            | 44 +++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 70 insertions(+)
>>
>> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
>> index 30c193a1207e..8f9aee97517c 100644
>> --- a/include/linux/zswap.h
>> +++ b/include/linux/zswap.h
>> @@ -9,6 +9,18 @@ struct lruvec;
>>
>>  extern atomic_long_t zswap_stored_pages;
>>
>> +/*
>> + * Advisory zswap occupancy snapshot for a swap range. This is not a complete
>> + * backend classifier; callers must recheck before depending on ALL_ZSWAP for
>> + * large-folio IO.
>> + */
>> +enum zswap_range_state {
>> +       ZSWAP_RANGE_NEVER_ENABLED,
>> +       ZSWAP_RANGE_NO_ZSWAP,
>> +       ZSWAP_RANGE_ALL_ZSWAP,
>> +       ZSWAP_RANGE_MIXED,
>> +};
>> +
>>  #ifdef CONFIG_ZSWAP
>>
>>  struct zswap_lruvec_state {
>> @@ -27,6 +39,9 @@ struct zswap_lruvec_state {
>>  unsigned long zswap_total_pages(void);
>>  bool zswap_store(struct folio *folio);
>>  int zswap_load(struct folio *folio);
>> +enum zswap_range_state zswap_probe_range(swp_entry_t swp,
>> +                                        unsigned int nr_pages);
>> +bool zswap_pool_reclaim_pressure(void);
>>  void zswap_invalidate(swp_entry_t swp);
>>  int zswap_swapon(int type, unsigned long nr_pages);
>>  void zswap_swapoff(int type);
>> @@ -49,6 +64,17 @@ static inline int zswap_load(struct folio *folio)
>>         return -ENOENT;
>>  }
>>
>> +static inline enum zswap_range_state zswap_probe_range(swp_entry_t swp,
>> +                                                      unsigned int nr_pages)
>> +{
>> +       return ZSWAP_RANGE_NEVER_ENABLED;
>> +}
>> +
>> +static inline bool zswap_pool_reclaim_pressure(void)
>> +{
>> +       return false;
>> +}
>> +
>>  static inline void zswap_invalidate(swp_entry_t swp) {}
>>  static inline int zswap_swapon(int type, unsigned long nr_pages)
>>  {
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index 761cd699e0a3..da5297f7bd69 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -506,6 +506,19 @@ unsigned long zswap_total_pages(void)
>>         return total;
>>  }
>>
>> +/*
>> + * Expose whether zswap reclaim pressure is active. This is a backend fact:
>> + * zswap_check_limits() sets the state once the pool reaches the hard limit and
>> + * keeps it set until the pool falls below the accept threshold.
>> + */
>> +bool zswap_pool_reclaim_pressure(void)
>> +{
>> +       if (zswap_never_enabled())
>> +               return false;
>> +
>> +       return READ_ONCE(zswap_pool_reached_full);
>> +}
>> +
>>  static bool zswap_check_limits(void)
>>  {
>>         unsigned long cur_pages = zswap_total_pages();
>> @@ -1559,6 +1572,37 @@ bool zswap_store(struct folio *folio)
>>         return ret;
>>  }
>>
>> +enum zswap_range_state zswap_probe_range(swp_entry_t swp,
>> +                                        unsigned int nr_pages)
>> +{
>> +       unsigned int type = swp_type(swp);
>> +       pgoff_t offset = swp_offset(swp);
>> +       bool present = false, missing = false;
>> +       unsigned int i;
>> +
>> +       /*
>> +        * This is an advisory, lockless snapshot for common swapin admission.
>> +        * Callers must recheck before depending on an all-zswap range for IO:
>> +        * concurrent writeback or invalidation can change the backend state.
>> +        */
>> +       if (zswap_never_enabled())
>> +               return ZSWAP_RANGE_NEVER_ENABLED;
>> +
>> +       for (i = 0; i < nr_pages; i++) {
>> +               struct xarray *tree = swap_zswap_tree(swp_entry(type, offset + i));
>> +
>> +               if (xa_load(tree, offset + i))
>> +                       present = true;
>> +               else
>> +                       missing = true;
>> +
>> +               if (present && missing)
>> +                       return ZSWAP_RANGE_MIXED;
>> +       }
> 
> Can we use xas_load() to make this check more efficient? IIUC,
> xa_load() walks the tree every time.
> 
> (We used to use a bitmap here back in frontswap days. Good times....)

Thanks for your review.

I'll switch this to xas_load() in the v3 version.


