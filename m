Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E73AEC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 00:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A40AD6B0005; Mon, 13 Jul 2026 20:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A18696B0088; Mon, 13 Jul 2026 20:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930576B0092; Mon, 13 Jul 2026 20:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E30D6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:51:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A5451A0229
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:51:47 +0000 (UTC)
X-FDA: 84985554654.18.A45C2C5
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf16.hostedemail.com (Postfix) with ESMTP id 897B4180004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:51:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783990305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6SgeOYOoX1fhFCzRFM5989J5RW61Wlyp4grkx/Gw+Fw=;
	b=Al+9W0DQ4bP3bjTKQ7oyPqsqYrp8NuT/EGrDkFfMiXYLm5JU0s2K3x6Y3qSFsDRm/UwP77
	+SjkjTaJ3ZOeVELtDh4JdXFBmSK/ivZ4TTCMW2mBN1gbwpvh3D0aPeHX9r+jU3DS7KE0ao
	r+sLiJU5mFXtKsm6rXGl+5BZ4HCwUpo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783990305;
	b=f1OFB5NZQxwG1W8zZMisdiDfF8i6/SQPdq9TjwP3CXyhasXPVkLdl8j23tTr2iLfNGUUjw
	TSdKpbD3q7uClCJvf1xwTJlHYm5JiM6ynqA+xqITD7EDmfWXuEhHpTnKKMJfOlYdj+uSMX
	a13brHOgwmwrjt8juYdRadI+spaU7pQ=
X-UUID: 2b27ce767f1e11f1aa26b74ffac11d73-20260714
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_TXT, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_MAILER_MTBG, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED
	SA_EXISTED, SN_UNTRUSTED, SN_LOWREP, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_COMM, GTI_C_CI, GTI_FG_IT, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:f2b77259-a3d1-4e87-aa3f-b6b6caac5e42,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:f2b77259-a3d1-4e87-aa3f-b6b6caac5e42,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:da258d8c0d687a3c02eccc0ff0f78cbf,BulkI
	D:260713224606VYPSDRI6,BulkQuantity:3,Recheck:0,SF:17|19|38|64|66|78|80|81
	|82|83|102|127|136|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:99|
	1,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
	NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2b27ce767f1e11f1aa26b74ffac11d73-20260714
X-User: husong@kylinos.cn
Received: from [192.168.110.173] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1114977333; Tue, 14 Jul 2026 08:51:37 +0800
Message-ID: <515454fa-9be7-4537-87b3-1fd6ee364ccc@kylinos.cn>
Date: Tue, 14 Jul 2026 08:51:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: husong@kylinos.cn, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Wupeng Ma <mawupeng1@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Zhao Li <enderaoelyther@gmail.com>, David Carlier <devnexen@gmail.com>
Subject: Re: [PATCH] mm/hugetlb: restore failed global reservations to subpool
 in alloc_hugetlb_folio
To: Ackerley Tng <ackerleytng@google.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>
References: <20260713144557.3845941-1-joshua.hahnjy@gmail.com>
 <CAEvNRgHMsva75JcJBEw2UdmNwAvKOZb44w0-Z_dq14D8QT2LAQ@mail.gmail.com>
From: Song Hu <husong@kylinos.cn>
In-Reply-To: <CAEvNRgHMsva75JcJBEw2UdmNwAvKOZb44w0-Z_dq14D8QT2LAQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 897B4180004
X-Stat-Signature: uqcdh46swqxwdjnb3kwo7397eqat4fru
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783990304-787342
X-HE-Meta: U2FsdGVkX19siUfhP883JkRczlzguj63fbDtHlka+8os1paFFtO1nnCmrJ9XEtAJqNiPjZYn+C2eCjfW+TzvzISesIzh+GHqo5ua+XC9IqvL9BhF5wv88fJAUQSbAbHPf7bEBIWMKM8dx5fbZNmTMrWn3YsFoxkR34yV8vM6clLOAcVRgLcqhscT7bl+wFbtW0V2m6uWL7zH0WIiIWqLmnED47aeCGHjywARPjddw2b/moJb9mRn591WMvjQmUdlVtVSnbdfM3lYtunWTGQRJXNk4H+4oAiCG6keHbTEtbzRzIzCXd95JueDXUYAA54VHSgMvduisseX9Vud8LWhXK3W/NGzA4etVnSzt3YS0JnKpo12DOZwYveP8AG4UFF92YQ2T+W7q9cI+zlhWMqhLOlxE+QlBupSp2v4DKN2/JVLsz8Isa0cG5meNGFYTJsl+1klhXICb5aFfNxsGcqMT2Dzw77e1+rS4s1H6Y/4yFBUnrLAoLsWXvJ/knPNy5amhgA1av9EjB4ACvthZea+0l5Sgt+EnwbLyiwZExR4OIqIxBsOhdmJgn+dt4kCUtSaukNBnHLwYF/KTtNM0SsCVAmaSlrCLI4i8qN9iZbtHhpI+KlJrezObaumOWvkDxSE5SxkfFtaTpalFOPhPcdqdc8u2/XJR5AJ1uwwzApyD6QN+ddnz9meT5OBSthMJ85IGLXugpEVUot0Sy9syD9bqLumvVBvraMGRG9yZXotuwm1dvhTjhUftMx0y0DtLJR8yr0/55dqcpcyg88dqQFBJWvR7qdAQVGMCQmURotzwDavluqwQmRdzJnfoWE1AQIntGVkQGcpl7S5qIHwJGvBeL8NyoJxDKF1xeq72Ysd8avoDQZZl1euiwLrKDAhaYh42zihx2H3tomL+vvBPrNHocArZObl9fdP90RvQhxI3LUEjTW37bAUGB6Zp25+UtIMVKUzsehdZ3yYkIB6fYS
 hgJNeRAF
 K4DswLDF6keHspnwZxITeB0lvFzvM3eFqVTl+HZWR8tDUCYjYxbi56Z/uVhCyxC7Xb2picDFWdYBOwBj01eCAswB0LTukr9NQlE3Nbeq3yLONUt/L9gmureDdY9C9ZbRLFl1oElShS3RgHFFI59CI2fg4LX2rNaR25Qh4N5agKLER+TerUgvYZV9+vW1rD77t2JzfvQ5C00fHUa3md2KJaCvarY0kX6fBYhnm5L55cRiVELxBRJRzrWFW9UowkovUHBBVZJBip79kDCItbmXSRQNb8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/7/13 23:49, Ackerley Tng 写道:
> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
>
>> On Mon, 13 Jul 2026 19:50:08 +0800 Song Hu <husong@kylinos.cn> wrote:
>>
>> Hi Song, thank you for the patch.
>>
>>> When hugetlb_alloc_folio() fails, alloc_hugetlb_folio() only rolls back
>>> spool->used_hpages in the out_subpool_put path when gbl_chg == 0. For
>>> gbl_chg > 0 (e.g. a size= hugetlbfs mount), hugepage_subpool_get_pages()
>>> has already incremented used_hpages, but the error path skips the
>>> rollback, so each failed fault permanently leaks one used_hpage until
>>> the subpool is exhausted and hugepage_subpool_get_pages() itself fails.
>>>
>>> Decrement used_hpages for the gbl_chg > 0 case too, mirroring the
>>> hugetlb_reserve_pages() fix.
>> So something is clearly wrong with this codepath here; there are now 4
>> competing fixes in the mailing list currently being discussed [1] [2] [3]
>> including this one and they all do things slightly differently.
>> Let's please agree on what the correct solution is,
>> I've CC-ed the authors of those 3 other solutions to discuss here.
>>
> Thanks for connecting us!
>
> I'd like to make a pitch for centralizing the fix into the subpool [1]
> :) I think it will also let us clean up the existing codepaths where
> each path does its own open-coding and reaching into the subpool. Also,
> if that cleanup is centralized into the subpool, we might be able to
> track availability instead of reservations [4], which I think simplifies
> HugeTLB reservations and removes some possible races (for keeping
> rsv_hpages and resv_huge_pages in sync) completely.
>
> [4] https://lore.kernel.org/all/CAEvNRgGN0HSJ2iLSDD2haSKOxifa-uhkO9Hwossh0+Q_d9fzOw@mail.gmail.com/
>
> I understand the above solution is a deeper change, does anyone have any
> thoughts on the approach, or existing tests other than libhugetlbfs and
> tools/testing/selftests/mm/ksft_hugetlb.sh (which pass) that I could use
> to prove this works?
Hi Ackerley,

Thanks for the write-up. The centralization reads cleanly, and tracking
availability instead of reservations does look like it would remove a real
class of the rsv_hpages / resv_huge_pages sync races, so I don't have an
objection to that direction for mainline.

On tests — I put together a small reproducer while debugging this, which
might be useful regardless of which fix lands: a size= hugetlbfs mount (so
the subpool has a max_hpages), with nr_hugepages churned 10 -> 2 -> 10
around a MAP_NORESERVE fault loop. Without a fix the subpool permanently
loses capacity (it maps 2/10 pages even with 10 global pages free); with a
fix it recovers to 10/10.

One thing worth flagging for -stable: a833a693a490 is already in 6.x
-stable, so the leak is live there too, and a larger refactor probably is
not backportable — so a minimal fix may still be wanted on the stable
branches even if centralization goes in for mainline.

Thanks,
Song
>>> Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
>>> Signed-off-by: Song Hu <husong@kylinos.cn>
>>> ---
>>>  mm/hugetlb.c | 13 +++++++++++++
>>>  1 file changed, 13 insertions(+)
>>>
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index d6c812d1857b..8413ec92d836 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -3073,6 +3073,19 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>>>  	if (map_chg && !gbl_chg) {
>>>  		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
>>>  		hugetlb_acct_memory(h, -gbl_reserve);
>>> +	} else if (map_chg && gbl_chg > 0 && spool) {
>>> +		/*
>>> +		 * Restore used_hpages for the globally-requested page that
>>> +		 * hugepage_subpool_get_pages() counted against the subpool's
>>> +		 * maximum, but which we failed to back from the global pool.
>>> +		 * Mirrors the fix in hugetlb_reserve_pages() (1d3f9bb4c8af).
>>> +		 */
>>> +		unsigned long flags;
>>> +
>>> +		spin_lock_irqsave(&spool->lock, flags);
>>> +		if (spool->max_hpages != -1)
>>> +			spool->used_hpages -= gbl_chg;
>>> +		unlock_or_release_subpool(spool, flags);
>> Why are we unlocking or releasing the subpool here?
>>
>>>  	}
>>>
>>>  out_end_reservation:
>>> --
>>> 2.43.0
>> Thanks again for the patch,
>> Joshua
>>
>> [1] https://lore.kernel.org/all/20260708-hugetlb-alloc-failure-fixes-v2-2-c7f27cbb462b@google.com/
>> [2] https://lore.kernel.org/linux-mm/20260428113037.88766-2-enderaoelyther@gmail.com/
>> [3] https://lore.kernel.org/linux-mm/20260515202902.461539-1-devnexen@gmail.com/

