Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A02C44512
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 02:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E8446B0096; Sun, 19 Jul 2026 22:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9709A6B0098; Sun, 19 Jul 2026 22:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83C5D6B0099; Sun, 19 Jul 2026 22:36:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 583EA6B0096
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 22:36:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C4F011C0A02
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:36:42 +0000 (UTC)
X-FDA: 85007591844.10.41917E1
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf14.hostedemail.com (Postfix) with ESMTP id 12BCF100002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:36:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eOkJFHgM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784515001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KusPc2Cpip6sPBv9PieUVxeP0LYiRvmdBMosAeD5k90=;
	b=zLn+kjloXqEuiEF64UiXRtgmBTlzWCMXToTGa637Lg5FeHBC7f8piQyQ+UDt00l+ZRLNKL
	E1bJlYcsStihVE/43O6vRAVIVjavuUFxErKxxteVXIB+u2jOTApDCCXVcjaq4ngpPwAtbB
	7syTI3sdzwKp/Dp4/kfKuzJkw0iTkVo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eOkJFHgM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784515001;
	b=JTg86Svzv4U3Squ2U/TLR/1EFldakGMH2Q9qydQskyfiIbPg2853km9mwLd1K2kTulSXjy
	KNZsstNRQC4sWclXz5Wz0UWzMq5eDfZAwFF8vcY5llzSHmmRRea+vnrfqxs073MsS/0VAr
	8DKQO410lRgQuEFLUeeWK02sQQ4U+2E=
Message-ID: <c0265ec9-e983-4547-a166-7c1d30237b73@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784514998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KusPc2Cpip6sPBv9PieUVxeP0LYiRvmdBMosAeD5k90=;
	b=eOkJFHgM6kcMlXyh79+foKL5z5ba2DkfV7iAXPTnhaKpSyAfu+A4jkqQyailvUNMc/6G4M
	zWGbF8zey1Q6P6wxgRW81ZPZq542iHED+d3N/jM8OdRtPmCigRL/bxu5+GnNbEoTTCgObo
	hFa9uZ3fDfD2zOrYYfaVO6DiCuPlLV4=
Date: Mon, 20 Jul 2026 10:36:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/thp: expose deferred split folio memory usage in
 meminfo
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org
References: <20260717063025.168436-1-ye.liu@linux.dev>
 <46017e29-48a3-4a74-8c5a-0be9d912deaa@kernel.org>
 <dd037379-cf59-468e-8b42-51546bf2e28c@linux.dev>
 <f041f1e0-8ec4-48d4-8656-a6789c8ad379@kernel.org> <aln6SBHcxBY-9Vfl@lucifer>
 <41bc5ca5-08ed-4aba-86a3-d7f44b16e6f5@linux.dev>
 <b6b04cf2-30d0-4511-9bd4-042b176c1b31@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <b6b04cf2-30d0-4511-9bd4-042b176c1b31@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: sb8fzpsfupj8tb317tc91wpumfnr4kdd
X-Rspamd-Queue-Id: 12BCF100002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784515000-527991
X-HE-Meta: U2FsdGVkX18V3b4t0PROxPgh+EPPsPoieWYiwTdOSe3QBMW7dk4l6d+sVd4xVNw/0v350+XEXS7BD1JpOZiX26FjIjDlzwozZX7m3tOCAS5tKBmU/TKwDOda6nHyAQphEF1QHPmr3e3ybrkEyXwfGBVCFka18h+Tj2dFfzacH1Y5LBW/jPbfnJSuLD2q5kLnfnnrccQ2NtbTL1nWG1ny21QghJT1PCRpziOwjmzkAlWsRdP+DcltxqMZc0U20ojuQq+9QdpID6OEkcNKzpzKIj1ykmd6gvdukIA4XCnQD2cjtEDAdlfhQzqMtJkU64rCye+SH4VMZZ6RLlw05Ct2CmVbBKpjqVTRkPHZMm3mNrk+zZP6/P/TCtZLiHEjPqUOMx0pJ/MZcGFxpxQ2TZg5BOsbElGGixRp2MV92LYNZjNIKHFvOUC9+9gEJKijgJDmVEzPwQyWreIuegTKeEIMn0JMnO3NxPO53GNphJDclptonozc0bkSbOM7Qgm4T5nq5YuM8OUM8lyXiUGzm9jstgsw7JODCilENRFZtcipr9F5P8DJqSnG0ER7+hkRUGry+aocAOk+xotvqgNTs0GNz2niXEkkimoWa7W6de7N4JdCUohsJYZN5RUzSLpvSypsE2Ku4iP+ApiCWFxzTc3RdORx56FUoE8VFYSHBj+1ByKlqucNuDklOjc5R0YNMsdGAoyD0Obnrg53dkbSAqJQLObBRX7uoXrEOe8Dyvk9C54WAVyQMunQ65fRaK6Q43vlZiJsOEl1vuwLXf75ssdTDVEH2gxwQ959PDdlr0a9+4fFP3M1bCRVeIiC/3jZsrlofdt1WASGhn0OgqhoDx03mLoNvw7iKnPqFjAR4w+6+gUnRQl3kzP4F37jMesoxFuM8GkcftEKbd6Jdlyp1zEu7cYcybGHOoJ9/hjHzkBzRI/HuRvAMTeKr0daGuQucpFZb1byzpX7QHt11Tk+ujv
 1KE2/+Mz
 jBSWCQwMUazkOSzqEnCMMHrbsUQoEuJrZURohZVWo5QL5c+dwvBQMgMorwxzCSTwiko4f8zPdx6LSfLgSwm11Ajkq381NW6gNJh663ft4WT4SufEIhH6Bl5oy0jKTt5SPsm55FV3089JvgrKDvVlWCgq3RbviPX2QhAysn7BXQAkmzPjps1g+44i3Sgx3nN4c4WJXuWyN2ew8mlI7TWVEB0u8SeVENjgZO1aYhjMnxPgw0sU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/17 18:29, David Hildenbrand (Arm) 写道:
> On 7/17/26 11:54, Ye Liu wrote:
>>
>>
>> 在 2026/7/17 17:48, Lorenzo Stoakes (ARM) 写道:
>>> On Fri, Jul 17, 2026 at 11:33:05AM +0200, David Hildenbrand (Arm) wrote:
>>>>
>>>> Don't expose it to user space.
>>>
>>> Yeah please stop.
>>>
>>> We don't want this change, it exposes internal implementation details. It's a
>>> no.
>>>
>>> Next time send an RFC or a discussion thread.
>>>
>> Yes, sending an RFC would be more appropriate.                                                  
>>                                                                                                 
>> I'd also like to ask if it's possible to implement this in                                      
>> `/sys/kernel/debug/deferred_split_pages`, or are you completely against querying this statistic?
> 
> It's not pages. It's folios.
> 
> You don't know how much memory is there to reclaim. You don't know if it can
> even be reclaimed.
> 
> You don't even know if there can be any memory reclaimed *at all*, because there
> are scenarios where we add folios that are actually *not* partially mapped today.
> 
> You don't even know the relationship to memcgs.
> 
>>                                                                                                 
>> How can we quickly identify this situation?                                                     
>> I believe some people will still be confused: where did the memory go?                          
> 
> Just like other caches that are shrunk on memory pressure.
> 
> We do have a "split_deferred" and a "nr_anon_partially_mapped" counter in
> "/sys/kernel/mm/transparent_hugepage/hugepages-2048kB/", maybe that helps.
> 
Thank you, it really helped.

-- 
Thanks,
Ye Liu


