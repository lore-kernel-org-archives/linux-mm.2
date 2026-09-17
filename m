Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E73F7C982CF
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 11:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93E26B008C; Thu, 17 Sep 2026 07:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6D1E6B0093; Thu, 17 Sep 2026 07:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D820A6B0095; Thu, 17 Sep 2026 07:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B590A6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:48:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A79BC02FE
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:48:36 +0000 (UTC)
X-FDA: 85223081832.15.674CB73
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5CB7B1C0002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:48:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WYbClPto;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of yizhang089@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=yizhang089@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789645714;
	b=niuZ1iHsTCsjj8NLjXsnUiAUS0yPJ14ZMf1N3PGdYrBCFEcziIA7JRdnDg+NAAF1N/WEp1
	e0E9Jm2LmlDlIPJEEChPn8TGeRvzGvL53ETozjQXpsw5xzqQIXuG0NShb59QF37qUSFbX2
	XhOqilbTBo6E8+Jpw6LOXpPuXE+Rsi8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WYbClPto;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of yizhang089@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=yizhang089@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789645714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0XIXiLce8oloEY4uUyIzwGoSl4i1s4G1pZ5kG8wUw3I=;
	b=ZFfXrMFMAF5yeUV3J+iDUM9kA+YhXIjn9wtm8KtUspJ6KxIewbY2SshgIEjeQwLOgXArik
	4wgZ1/uX3n2cCX0Xad39l/VAV0s+HZbRykaZ0lLG2nd/ivlMdFjz/XGRFL6wdcET9wWQqI
	2uu2XT9SAMrEzqqooSFmhF17r7RH5oA=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d8fdc579daso7353445ad.1
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789645713; x=1790250513; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0XIXiLce8oloEY4uUyIzwGoSl4i1s4G1pZ5kG8wUw3I=;
        b=WYbClPto06LfFllTTX7aoGsxj8shHL3seolhUYqDPRc0yg03y3FcSKOHXOogexs13R
         EDnwrI6w/CBsrb2mV6fVru+Mo+sX+PRJ86/CHOXKy8OZiBUb0RmJx0n6bZYaHhrnjN+R
         I+LtoiLcO2EqieC4vr/fdCyIrN20RPwhmfZkMIsSKdsAry2cqqAcXX5gkYXLRGpeLHen
         HMTBAgcWotAyjYeJSbVU+jqTfymI0CQ9ZXk7SkqoOsFEbyZB5RXgbvMi4EKwcPj0YH2Y
         e0XXdqvpcSUrsYfRLMlMXptPQJ/no/Rza5t0UFOB3LI9K67vNVS7utE756lp/tZFG/Fy
         6JqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789645713; x=1790250513;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0XIXiLce8oloEY4uUyIzwGoSl4i1s4G1pZ5kG8wUw3I=;
        b=vHxt/4E8giliW4ZfBP73H1d2m4A0ntzL0FUa/8nXn5TkTFQl9qazdlTMxeZsAimrN4
         4xDSMg+3VV4LyPIkIU/oD7Zx9LSWrQelqX8RcHPmgAcGq8YMJnr0TzV5WDmqw+ccwkPA
         FtmID4B+o6lfQU0FmwCzNLpppAYVFbkXTMdD6VI4au756G1VEILdhz6x3DTGFzykYdsK
         XTA8l48PJc/mf2mJ8XsYg8zkh6+ayj7tzxPNtsxIJ/5yjKw9kuNhhY1ibG+nadCriqtZ
         eY1N878JKzvGBQrQmDwRMkon4S7qj7eibLsXsj4stPmcTZrDSifcDwJqF2nkza7fYUS2
         Z5wA==
X-Gm-Message-State: AFuF++lX2ZM8RVm1MA+2L/3Pz7lJH3tzstcFYx0yHEsWV84tm8zrYKwk
	KRtaSLI3VOCEnjKi22GmR9vN8HhzinU52Faqdu1dBQUhjfLM1kdTNsTP
X-Gm-Gg: AYBFou1ksvgG8lI5BDMfQWGgISAYLPFLWnXHTZ6lhIO1T8zQkPwuBz64WB+8bkbgGw0
	hTa1/03vFMhxb8ZtlJR5haZ1jvIyx2M+lO3tTnLo4KDoQ6AskNcql9t4Pcmw4GNXtOd7lDRODvN
	ekm/VSmQp/sjXwiBJ3TEvX0UQDEo9urJBRPnZdQHtqoKwfaPQ0ii0wCPHZzp0NMKqHmD/elOaLO
	zw3EbCQlPVttzc6Drj5gwpUr1dLi0LGjKzAarP1P78LOI7yqnBg0+wkOWO5yY5Gds1/6Ai0jpRF
	RdYznaFk9lwuS89rfkYUmUIiL++Gi7EuWx5/VQXi6HXnBX7mqQv6Zddz8OBlxSuw7bR3esA6I9U
	vpTmiwnGx5k6nCl4fk4pYZinDvxBpqKmkTKP8l3xR81E9VwzJqi8EUiaGFzHAKFDrnKPo9EPsSY
	lcVEyTAOgKnC0u3vO2PJUpuRYtpvN+Wmjm3HwWgXf57xIb46mMEdrVUal/SMkd8aLyMpMLLnXEe
	+/6aTOCWZpDvTMKQj0=
X-Received: by 2002:a17:902:f549:b0:2d8:d4cc:5bb1 with SMTP id d9443c01a7336-2dd8e5244bbmr129000285ad.17.1789645712939;
        Thu, 17 Sep 2026 04:48:32 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89d8e6a3sm25444085ad.7.2026.09.17.04.48.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 04:48:32 -0700 (PDT)
Message-ID: <fd49e71a-34e9-4e72-9510-1b1692bbfca3@gmail.com>
Date: Thu, 17 Sep 2026 19:48:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] mm/truncate: fix data loss when splitting
 straddling large folios fails
To: Brian Foster <bfoster@redhat.com>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, jack@suse.cz, ziy@nvidia.com, joannelkoong@gmail.com,
 djwong@kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 chengzhihao1@huawei.com, wangkefeng.wang@huawei.com, yukuai@fnnas.com
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
 <20260916092450.654408-2-yi.zhang@huaweicloud.com> <aqrUGRd0JClEZNzN@bfoster>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <aqrUGRd0JClEZNzN@bfoster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5CB7B1C0002
X-Stat-Signature: ugxf97b6mqpdnbcmhfrx5171wkcks9b7
X-HE-Tag: 1789645714-655930
X-HE-Meta: U2FsdGVkX1+t8UjabwkNUpc1Sk7jNKaFEHmnK+509f6eE3hZbuaovHhUTCOXvwifl/T31WDVdm2ALA07w0QfltD2UEXZSKCej+1D1YJHtjKtSKVQQK2pwDcMR5igdKgpp56qLakiWceR8fs7piUmsrCSS+LhDPB2JMrUohjINtNaTypZ/t1ah8mcR0lqVP08qJvRqSJueMvbTkTQnhY/tbcHWGe5wN4bxjOWa8siCZ8txsfcJJ1B2xQPztu6NYx6OWwe3cB/MWOaWYoQepntHQtido4D2+sJhmGeY4dgNaNaNtgRsm0lcUGGGYdi1ZRzb94p1QKVuwU31cT2LxdM911bWEojtJp5h71qk30fyEFnRAMadY4DeyMudyOfDVLOIajsqcGbsAcDHhLTzyZ988KCpmwVLiNH2HxKttfSx30/7U4S93++AEpnvnBkjarWQ2VElXVBWnjsa/7LLZWH+ZfIma+AWR3S7nmH0V+6xyFuRjqH5plFSNomTVz5B0NRTRwjo9fm8FYledFLVdIdCi6/bBi4i7bSac0yE734uAjtW1+ggZRC8O35po5v9Slg6Y39buCrfeLCcfWV2m+IrjvffkoZhwdAPAxGwqQNs+nE6GRpQqabQFFBZrgECZTvY9gd0JtvCaBT5FnY3hEPetvcLgnmowxyJkHePF6WH/xmrydNyJlsQyGsiUFI+gdvFJYlfEJAjVYSLo254uQoeojtp3Hs41vcJpomLPANqj14CddlT4MHnE66L0u6Y7lQKJvXUkfbGICXJPdow5MTV+XGasWdT8PBfjU30IAQyZkLFPBDm3ca26XPsZmN7YN8K2JitwC5ni+F2tUlo+6uSnG+8CFPF0s4B84wRLnc7sXY9pyR85yjoqAjphKTfDBpoSLkFLcwVEPXlDCH4GWf8/0uoLL/8iJ3e4Al1iDA71eNvl3rz5/r6nfx/YfqXL8wZiskJWoK47CLGLCuRUM
 eD6wlhMU
 tsBbNPZuHlEhoR5i47T6cFtZYjVm0k6hHJPUtrkMerefHSRnBwubwvYrviYTdKkU1qeV5pD3ek+maxBhHv4S6ZRg3+TSKk4n+2lAp8zp7ogyejrUsceye0ORJwXUE0QSpo18FXpLBqXeKevooJydvqCI+tdjU4UUEu8KRdE4GOYzpPVz/NrrxNnJFoqKwvaADoIyK7myuhGj9s/rhhwfO0Q1YiIz06AJhZppHgd2WxQwgvLqzlRPz88ZtbtIdO2hXlD58t8cH4aFcehoJ44pF35eM4roBrApSdzt3lgrDjtoI1viHouZCUE3u27QVQzso47G7yoTLyLT9gU2w8BLCOqTEdDbnzMXqdyrNIizwJlPsyENWqD/+zXRCnqgJfbg86yOeTtWvq+WM/YVIMxsJYNbvV1kC0pmkSesijsYrMsm4pwdOhp/ans4aItl9otXdjQJdiQ3AilC+Ou83T+9K2JhwaymDaxeyT0oLoOUFY7GL0iw60WK9/JE6cOxr5tQLRwmS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/2026 1:38 AM, Brian Foster wrote:
> On Wed, Sep 16, 2026 at 05:24:48PM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> truncate_inode_partial_folio() splits a large folio so that the caller's
>> truncate loop can drop the in-range sub-folios while keeping the
>> out-of-range tail. The first split at the punch start edge is
>> non-uniform, which leaves the sub-folio at the truncation end edge as
>> large as possible, this means it may still straddle the range, holding
>> both zeroed in-range and valid out-of-range data. The function then
>> attempts a second split at offset + length to isolate that tail.
>>
>> If the second split fails the straddling sub-folio stays merged. The
>> function returned true unconditionally on all exit paths of the success
>> block, telling the caller it was fully handled. The caller kept its
>> default end and the truncate loop truncated every sub-folio below it,
>> including the merged straddler, discarding the valid out-of-range tail.
>>
>> For example, a 4-page order-2 folio punched from offset 0 to the middle
>> of the last page:
>>
>>    truncate_inode_pages_range()
>>      truncate_inode_partial_folio()      # same_folio == true
>>        1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>>        folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>>        2nd split of folio2 fails / cannot lock
>>        return true                       # BUG: caller keeps default end
>>      end = 3
>>      loop truncates p0, p1, p2-3        # p3's valid tail is lost
>>
>> This became reachable after commit 7460b470a131 ("mm/truncate: use
>> folio_split() in truncate operation") replaced the atomic split_folio()
>> with folio_split(), whose non-uniform split can partially split a folio
>> and leave the end edge merged.
>>
>> It has gone unnoticed because a dirty large folio normally carries the
>> filesystem's private data, for example buffer_head, so
>> filemap_release_folio() -> iomap_release_folio() returns false on a
>> dirty folio and folio_split() aborts with -EBUSY before any split,
>> leaving the straddler safely unsplit. The bug is only reachable on paths
>> that produce dirty large folios without filesystem private data, and it
>> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
>> attached.
>>
>> Rework the contract so the caller is told the page range to discard:
>>
>>    - Add pgoff_t *pstart and *pend out-parameters that receive the page
>>      range fully covered by [lstart, lend] after any split (or none),
>>      i.e. the pages wholly within the range and safe to discard.
>>
>>    - Adjust the ordering of the validate check when splitting folio2.
>>      folio2->index is only reliable after the reference count and lock
>>      have been successfully acquired, since it may have been split
>>      concurrently, or freed and recycled to an unrelated mapping. On any
>>      failure to obtain a reliable end position, fall back to
>>      folio->index, which is safe but leaves the sub-folios split off at
>>      the offset edge in the page cache.
>>
>>    - Rename the byte-range parameters start/end to lstart/lend to better
>>      express their semantics.
>>
>> Callers in truncate_inode_pages_range() and shmem_undo_range() pass
>> &pstart for the folio at the start edge and &pend for the folio at the
>> end edge, so the truncate loop drops exactly the fully covered pages and
>> never touches a straddling folio that still holds valid out-of-range
>> data.
>>
>> Suggested-by: Brian Foster <bfoster@redhat.com>
>> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
>> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
>>   mm/internal.h |  4 +--
>>   mm/shmem.c    | 13 +++-----
>>   mm/truncate.c | 89 ++++++++++++++++++++++++++++++++++++---------------
>>   3 files changed, 71 insertions(+), 35 deletions(-)
>>
> ...
>> diff --git a/mm/truncate.c b/mm/truncate.c
>> index b58ba940be47..bec6d881d022 100644
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
> ...
>> @@ -259,32 +271,62 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>   		 * for shmem truncate
>>   		 */
>>   		struct folio *folio2;
>> +		pgoff_t end, aligned_end = (pos + offset + length) >>
>> +					   PAGE_SHIFT;
>>   
>> -		if (offset + length == size)
>> -			goto no_split;
>> +		if (pstart)
>> +			*pstart = round_up(pos + offset, PAGE_SIZE) >>
>> +				  PAGE_SHIFT;
>> +
>> +		if (offset + length == size) {
>> +			end = aligned_end;
>> +			goto out;
>> +		}
>>   
>>   		split_at2 = folio_page(folio,
>>   				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
>>   		folio2 = page_folio(split_at2);
>>   
>> +		/*
>> +		 * folio2 may become stale due to a concurrent split or
>> +		 * freeing, so validate it before and after taking its lock.
>> +		 * If it fails, we can't get an accurate end position and fall
>> +		 * back to folio->index, which may leave sub-folios split off
>> +		 * at the offset edge in the page cache this round.
>> +		 */
>> +		end = folio->index;
>>   		if (!folio_try_get(folio2))
>> -			goto no_split;
>> -
>> -		if (!folio_test_large(folio2))
>>   			goto out;
>>   
>> +		if (folio2->mapping != folio->mapping ||
>> +		    !folio_test_large(folio2))
>> +			goto out_put;
>> +
> 
> Hi Zhang,
> 
> The only thing that sticks out to me in this version is the
> !folio_test_large() check above. If we split (or something happens) such
> that folio2 is no longer large, wouldn't it be more likely to catch it
> here and fail to update end like we do in the same check a bit further
> down after the folio lock? Maybe I'm missing something here, but it
> seems a little odd for the same condition to return two possible states
> like this. Otherwise I like the changes you've made and the rest of the
> patch LGTM.
> 
> Brian

Yes, you're right! That check should be dropped, I got myself
confused with all these complicated checks. Fortunately Jan and Zi Yan
suggested using __filemap_get_folio(), and with that I think we can
get rid of all these convoluted checks.

Thanks,
Yi.

> 
>>   		if (!folio_trylock(folio2))
>> -			goto out;
>> +			goto out_put;
>>   
>> -		/* make sure folio2 is large and does not change its mapping */
>> -		if (folio_test_large(folio2) &&
>> -		    folio2->mapping == folio->mapping)
>> -			folio_split_or_unmap(folio2, split_at2, min_order);
>> +		if (page_folio(split_at2) != folio2) {
>> +			folio_unlock(folio2);
>> +			goto out_put;
>> +		}
>> +		if (!folio_test_large(folio2)) {
>> +			end = aligned_end;
>> +			folio_unlock(folio2);
>> +			goto out_put;
>> +		}
>> +
>> +		/* Split failed: back off to the head of the straddler */
>> +		if (folio_split_or_unmap(folio2, split_at2, min_order))
>> +			end = folio2->index;
>> +		else
>> +			end = aligned_end;
>>   
>>   		folio_unlock(folio2);
>> -out:
>> +out_put:
>>   		folio_put(folio2);
>> -no_split:
>> +out:
>> +		if (pend)
>> +			*pend = end;
>>   		return true;
>>   	}
>>   	if (folio_test_dirty(folio))
>> @@ -413,11 +455,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
>>   	folio = __filemap_get_folio(mapping, lstart >> PAGE_SHIFT, FGP_LOCK, 0);
>>   	if (!IS_ERR(folio)) {
>>   		same_folio = lend < folio_next_pos(folio);
>> -		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
>> -			start = folio_next_index(folio);
>> -			if (same_folio)
>> -				end = folio->index;
>> -		}
>> +		truncate_inode_partial_folio(folio, lstart, lend, &start,
>> +					     same_folio ? &end : NULL);
>>   		folio_unlock(folio);
>>   		folio_put(folio);
>>   		folio = NULL;
>> @@ -427,8 +466,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
>>   		folio = __filemap_get_folio(mapping, lend >> PAGE_SHIFT,
>>   						FGP_LOCK, 0);
>>   		if (!IS_ERR(folio)) {
>> -			if (!truncate_inode_partial_folio(folio, lstart, lend))
>> -				end = folio->index;
>> +			truncate_inode_partial_folio(folio, lstart, lend,
>> +						     NULL, &end);
>>   			folio_unlock(folio);
>>   			folio_put(folio);
>>   		}
>> -- 
>> 2.52.0
>>
> 


