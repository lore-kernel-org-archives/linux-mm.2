Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5308AC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 11:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580E46B008C; Thu, 17 Sep 2026 07:38:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531B76B0093; Thu, 17 Sep 2026 07:38:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D46D6B0095; Thu, 17 Sep 2026 07:38:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 083426B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:38:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 880FE402F7
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:38:57 +0000 (UTC)
X-FDA: 85223057514.16.841AC32
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf10.hostedemail.com (Postfix) with ESMTP id A552AC0008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:38:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nuTsoAh+;
	spf=pass (imf10.hostedemail.com: domain of yizhang089@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=yizhang089@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789645135;
	b=XK11Ybk8kGq9C2CZlZ91cettf6azjMXyGoP4EZ5FHKeqp0Q6YfsKqHX8XaPhXsdqnpREK5
	f0joNyM8Azv7/xV9Q8I5Lz9J61QHFXj4r63qdshnB1TetpECeVFN25UoUsYLptgDnHrj+V
	KH/gmm5nTLDwYy1HHe7PnKyz0iq3rPc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nuTsoAh+;
	spf=pass (imf10.hostedemail.com: domain of yizhang089@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=yizhang089@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789645135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qax2Y7ONpWhvJcoWb2lMaau5W7EezZJfLvrgASjSPV0=;
	b=2NuYk8L3J1Y2hzU22F1b+/w2cR2+6WMi8WY57b7wm0Utku2akQPs1QPRN0pW9AFIfHPeGV
	1L6W6YrBY8EeFvghoJJ4N6oYAu4CKlrvZWfb9Z74xqnL98dxaympASmu+GdxrPi6GjLDqR
	E7c0gI/6qqBzVjlIIx+0Auo2VqhUcr0=
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469b2e1d7so542755b3a.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789645134; x=1790249934; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qax2Y7ONpWhvJcoWb2lMaau5W7EezZJfLvrgASjSPV0=;
        b=nuTsoAh+nPkbZgHkXFR+vuxirY2ZZFqWhZdd5Z83AWWDVmMo4MgS2QraVDwbdhqTnb
         qt99ugC7z2nxFkN5MEDohJQmczd0BxWhUeIprzb9SrH1PRVtNTmdZim076qhdpySTiWD
         H76To03mKN7h5TSUxdJflGLKeRfr5uo5faEkeOcBm0OJCQV5wx5Z3b9lS51zpV/j+65X
         rJDEcjczJonrocSgvlRUS0hw1Ht/+gePMvm2Z43r2tbU84c5AoguBwm0qv3O1FH0RGf/
         TPTip5FhvEFOHKnadsIp+jp/gwBrjDx/7XJ9wzt1zhdL5m+lPXs6Kg0iESoF/ZFRSYZV
         3SNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789645134; x=1790249934;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qax2Y7ONpWhvJcoWb2lMaau5W7EezZJfLvrgASjSPV0=;
        b=ou/Ow2TQIpX35I19UTnIQ1EqNFVJOMf68d9cQfIIKNC1mV/u8TVn+JOVPd70v6N6O+
         JVfyILID0Tz/y5/Toow/T/lz9D449+WUcIrZrQVaA8kpLhtnqMUEefrszd+8YsIzO5Nl
         DFfg9HK8Vd+J8dFJfPym6+J7O+YqDTfJ284AZj7VnYOzkP1ZOKIKndvlaGaDLDhQGzpI
         8ceGXp3ahuJGunEClB61MjmJccvclqDfnHRTCbfHReNOkRfyWBrCs9OXbt+gYxJQ/Dje
         Va4CVbbBdE3ahyMcZ4zbCUbcS3r2Q3N27nq1Oo7yAxY63jVv7ssm8E3o9FbrRDvGtwz3
         nxtA==
X-Gm-Message-State: AFuF++k1RGO2ZVjnHgzdBwNY+XDjB8/6EgA7eZucH7xsKgoMH/n4Gkcm
	7xMu5NyGif13ndGTqGUPLZ5JVpJjjOVk7aMRXrcc8pDdGF/U8hOVfJ+J
X-Gm-Gg: AYBFou3XYCVcHWilD1lKmaweVK7bWAPJCF88xqlfQgnIGvDNvUnYQNrori+oF0XTXpF
	Torz1B4jIw7/yjTBEpz05DxCySPaso8Gk/NPAYQETtIj8jdLo58iqMeZCVTVIrdvEyYQr/AJoS8
	dhFn2Y1ARdX+tSBy+fyi1p8bzVww//5+MfRIOU8f2VN50BGyLs/Wr0UVZM5U6Ac4rd/ARkOMr2g
	NkRUBGKzQpi1XA9StbRWEFXdKByfy3pvntQlwCEPGG3fXZW/YZ0Yi9/PZwD5wDAxY78NpczJmD4
	VBzoFFQXgfegVYeiY50OqZCj3xnFCeSXJdiyvC5suqmAjmAmRZzZY1C0nfkhfag887BsvFAkLzp
	0y3/30KTQbvtVQ7qED0fVqA5TcvroZuBAMb1pylMxiuzo1X0aauUu/D6BYAlK/5YNeBKNhkcLAi
	ThtzW7+EhIxRKRUJ0BGMpvSEEcxMRNGz6zTpkN3UIxtno2jnlzi0F5GaAz5rz2B/vmNvs9XrEBT
	o1XTd2dFlifBwpEcpw=
X-Received: by 2002:a05:6a00:1813:b0:871:b1b0:e49b with SMTP id d2e1a72fcca58-872378b3d61mr12425061b3a.10.1789645134016;
        Thu, 17 Sep 2026 04:38:54 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87201733075sm2650941b3a.40.2026.09.17.04.38.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 04:38:53 -0700 (PDT)
Message-ID: <9d931f5e-cb34-4721-9def-7aeeda48700c@gmail.com>
Date: Thu, 17 Sep 2026 19:38:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] mm/truncate: fix data loss when splitting
 straddling large folios fails
To: Zi Yan <ziy@nvidia.com>, Jan Kara <jack@suse.cz>,
 Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, bfoster@redhat.com, joannelkoong@gmail.com,
 djwong@kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 chengzhihao1@huawei.com, wangkefeng.wang@huawei.com, yukuai@fnnas.com
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
 <20260916092450.654408-2-yi.zhang@huaweicloud.com>
 <xl2rtnntlxoxoozkddgrlkcsgukcngvvcwazm7gb7q5g32yxir@ef5ltcwueboh>
 <DLGXT0ERY79Z.3C5DYVJVX6S9Z@nvidia.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <DLGXT0ERY79Z.3C5DYVJVX6S9Z@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A552AC0008
X-Stat-Signature: e8d7b9jcfdmwkqqyka6xwmwyfmu1rt81
X-HE-Tag: 1789645135-895003
X-HE-Meta: U2FsdGVkX1/Vb/Q9kVNep5oCF9My3xFIbt+voSvOOLy8jxJMJdWXeGf8GgDpB+8NbIU27PQFy5eBxVXB1HrhxI25bnsuTvQ3mGZ3MYBakivqnhSJVUm+t7ust6RXxToE/rx7pN+3uH66IhPYx4nSwiY9/auFrFW1eHcl+5zv6l9u7KmQbKAQ/q7GwNuRSVQiwiBH7vzzv9IxhG/Aqgn9ZqGJEiYSsORbCA4g0sDxw2uy5s3ENwgju1RIfZnrF7z3uNOoXPwdPcJIeXtUGnHUQP1Cu3oX9lUppxtGs0NSvG/LyAXhFCkMkf95UuoblyrB7at1bPsTEFX11sn1YsECrNDGy7ghJ3aGPAEXDoVnEcRxWY92Uz20mhROAirLw5B4fbSyhWGWsIDe1YDczap97YGUbXc8OrjU8ipvNqOPsH72TYGqR7QH8TjqxhOPDLEM1rG8s1722UQID1us1mxg1AYHwLsfl3iNDt0H0yDxnMZBVW6zBsyy9LcJAr+3t05w9Z04uduRLGxXFjKjtggHczBDKGEmDJITV8cldKQV0a0AIlnOX84Nk0hdwIMhWYWoX0DWWgyeW+00T4fSgc2cW414MknTKwIeMimdX8Ap9lMna8iZdNxJ5vzSwOA9z1PlreOuM8egzkwU0yAFogE3uWZsf7diLHv5lXoX6faSH18UOKSa+mf+SA9Jxv8j3lb8spDtfO4i9TwVmA+YEUdcDt/e9YBkb0KarT0guSXWvqp2j8tXLkSUKaJa0hAFGhVCGBmLO7hx7lyiWtLguODnvDYTHfrGQVAGTLURtc8DhqMFeRli4UrM7BQQSARoXcYKetE0w6n7aee1Om3koUevm3u/9XyMFTz7KK1cq1VbxOujnhXCedDsY1tOIOOal3DVDgNiT2OOYu0D7sdc05hYX5mXSD79tInSIUTqpIFhTWbQUudaZuSxrVNnSHOhbVbhen2vQePQQ+LE6oqu3Ga
 U6O+k6v1
 J/yXe0S9kmtin9UrK039kNAxO2obL3CptZKpJarvivLwHfGPnO9zhLdXXvsJHNb+vmtQVlT6EoojE8Ef1XQzqd2RmxqKfSRM3TDxyC5xnUt2GCL3CxApm9DKyNMUfcgJ3WL5THSfYbzXNdhLHDwkqE+kqB+m1WneC3ncxoufubE2C2aeMpWv1ZtxCb6gnJyVIraOQz741YKIiNkso7H/O9y8/O4MKLJfbjl9SehyC/JrBoNPgJg9uv8GrGgS7QlLEoOCZMBhSPLn4x8IWM8IMFos0Se9Itp15qJRK00Ocfw9X9P9HLSlhVSiOlwAXpPseI0s7OuMaqmkijT+vQE5CWfJTuuK7s5cJHWTLHYdZVDtGIQ54oTdyc/al0DYoN8OdCBCz3+QKtMMr/biC6ri8RVG3zbUAIjReN6HgsjXP7HIwqxuZVvA6/+VFP2EPJQD1Fj413Sn2ppBqQAmLlR8ke6WQfAEn+VK/EscpAl7ONAIV3YddVRm2FjN+bDEHe8GlSR3J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/2026 2:03 AM, Zi Yan wrote:
> On Wed Sep 16, 2026 at 8:02 AM EDT, Jan Kara wrote:
>> On Wed 16-09-26 17:24:48, Zhang Yi wrote:
>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>
>>> truncate_inode_partial_folio() splits a large folio so that the caller's
>>> truncate loop can drop the in-range sub-folios while keeping the
>>> out-of-range tail. The first split at the punch start edge is
>>> non-uniform, which leaves the sub-folio at the truncation end edge as
>>> large as possible, this means it may still straddle the range, holding
>>> both zeroed in-range and valid out-of-range data. The function then
>>> attempts a second split at offset + length to isolate that tail.
>>>
>>> If the second split fails the straddling sub-folio stays merged. The
>>> function returned true unconditionally on all exit paths of the success
>>> block, telling the caller it was fully handled. The caller kept its
>>> default end and the truncate loop truncated every sub-folio below it,
>>> including the merged straddler, discarding the valid out-of-range tail.
>>>
>>> For example, a 4-page order-2 folio punched from offset 0 to the middle
>>> of the last page:
>>>
>>>    truncate_inode_pages_range()
>>>      truncate_inode_partial_folio()      # same_folio == true
>>>        1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>>>        folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>>>        2nd split of folio2 fails / cannot lock
>>>        return true                       # BUG: caller keeps default end
>>>      end = 3
>>>      loop truncates p0, p1, p2-3        # p3's valid tail is lost
>>>
>>> This became reachable after commit 7460b470a131 ("mm/truncate: use
>>> folio_split() in truncate operation") replaced the atomic split_folio()
>>> with folio_split(), whose non-uniform split can partially split a folio
>>> and leave the end edge merged.
>>>
>>> It has gone unnoticed because a dirty large folio normally carries the
>>> filesystem's private data, for example buffer_head, so
>>> filemap_release_folio() -> iomap_release_folio() returns false on a
>>> dirty folio and folio_split() aborts with -EBUSY before any split,
>>> leaving the straddler safely unsplit. The bug is only reachable on paths
>>> that produce dirty large folios without filesystem private data, and it
>>> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
>>> attached.
>>>
>>> Rework the contract so the caller is told the page range to discard:
>>>
>>>    - Add pgoff_t *pstart and *pend out-parameters that receive the page
>>>      range fully covered by [lstart, lend] after any split (or none),
>>>      i.e. the pages wholly within the range and safe to discard.
>>>
>>>    - Adjust the ordering of the validate check when splitting folio2.
>>>      folio2->index is only reliable after the reference count and lock
>>>      have been successfully acquired, since it may have been split
>>>      concurrently, or freed and recycled to an unrelated mapping. On any
>>>      failure to obtain a reliable end position, fall back to
>>>      folio->index, which is safe but leaves the sub-folios split off at
>>>      the offset edge in the page cache.
>>>
>>>    - Rename the byte-range parameters start/end to lstart/lend to better
>>>      express their semantics.
>>>
>>> Callers in truncate_inode_pages_range() and shmem_undo_range() pass
>>> &pstart for the folio at the start edge and &pend for the folio at the
>>> end edge, so the truncate loop drops exactly the fully covered pages and
>>> never touches a straddling folio that still holds valid out-of-range
>>> data.
>>>
>>> Suggested-by: Brian Foster <bfoster@redhat.com>
>>> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
>>> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>
>> The changes mostly look good to me but I have some confusion around the
>> folio2 splitting below.
>>
>>> @@ -259,32 +271,62 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>>   		 * for shmem truncate
>>>   		 */
>>>   		struct folio *folio2;
>>> +		pgoff_t end, aligned_end = (pos + offset + length) >>
>>> +					   PAGE_SHIFT;
>>>   
>>> -		if (offset + length == size)
>>> -			goto no_split;
>>> +		if (pstart)
>>> +			*pstart = round_up(pos + offset, PAGE_SIZE) >>
>>> +				  PAGE_SHIFT;
>>> +
>>> +		if (offset + length == size) {
>>> +			end = aligned_end;
>>> +			goto out;
>>> +		}
>>>   
>>>   		split_at2 = folio_page(folio,
>>>   				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
>>>   		folio2 = page_folio(split_at2);
>>>   
>>> +		/*
>>> +		 * folio2 may become stale due to a concurrent split or
>>> +		 * freeing, so validate it before and after taking its lock.
>>> +		 * If it fails, we can't get an accurate end position and fall
>>> +		 * back to folio->index, which may leave sub-folios split off
>>> +		 * at the offset edge in the page cache this round.
>>> +		 */
>>> +		end = folio->index;
>>>   		if (!folio_try_get(folio2))
>>> -			goto no_split;
>>> -
>>> -		if (!folio_test_large(folio2))
>>>   			goto out;
>>>   
>>> +		if (folio2->mapping != folio->mapping ||
>>> +		    !folio_test_large(folio2))
>>> +			goto out_put;
>>> +
>>>   		if (!folio_trylock(folio2))
>>> -			goto out;
>>> +			goto out_put;
>>>   
>>> -		/* make sure folio2 is large and does not change its mapping */
>>> -		if (folio_test_large(folio2) &&
>>> -		    folio2->mapping == folio->mapping)
>>> -			folio_split_or_unmap(folio2, split_at2, min_order);
>>> +		if (page_folio(split_at2) != folio2) {
>>> +			folio_unlock(folio2);
>>> +			goto out_put;
>>> +		}
>>> +		if (!folio_test_large(folio2)) {
>>> +			end = aligned_end;
>>> +			folio_unlock(folio2);
>>> +			goto out_put;
>>> +		}
>>
>> So I always found this folio2 lookup and revalidation somewhat suspicious
>> and now that we're digging into it I'll ask: As you note in the changelog,
>> by the time we compute split_at2 the page can be already freed and reused
>> because it was split off from the original 'folio'. It can be for example a
>> slab page or anything else. So is it guaranteed that page_folio() actually
> 
> For a slab or unrelated page, folio->mapping check rejects them.
> 
>> returns something sensible? What guarantees we properly detect the "reuse
> 
> No, but folio_try_get() prevents non ref'd folios.
> 
>> for something else" case in all possible cases for which the page can be
>> reused? I understand this is mostly a preexisting issue so maybe these
>> questions are more for MM guys than you...
> 
> I agree with you that trying to split a unlocked and not ref'd folio2 is
> flaky. And it almost does a __filemap_get_folio() like you proposed
> below.
> 

I think this is indeed a pre-existing issue, as Sashiko pointed out:

 > [Severity: Critical]
 > Does this speculative lookup handle the reallocation race correctly 
if the
 > folio is reallocated to a different file offset?
 >
 > After the first split, the tail pages are added to the page cache and
 > unlocked. During speculative lookup, the tail page could be concurrently
 > reclaimed, freed, and reallocated as a new large folio in the same 
mapping
 > but at a completely different file offset.
 >
 > The validation checks earlier and the page_folio check here will all pass
 > because the physical page split_at2 is part of the new allocation.
 >
 > However, the file index of the folio is not verified. If this 
unrelated large
 > folio fails to split, the fallback path assigns its index to end here:
 >
 >     if (folio_split_or_unmap(folio2, split_at2, min_order))
 >         end = folio2->index;
 >
 > This unrelated file offset is then returned to the caller via pend, which
 > can cause the hole punch loop to truncate an unrelated segment of the 
file.
 >
 > Should we verify that the file index of folio2 matches the expected index
 > (e.g. folio2->index + folio_page_idx(folio2, split_at2) == 
expected_index)
 > before using it?

the current mapping check on the folio2 and the folio !=
page_folio(split_at) check in __folio_split() are not able to catch this
problem, which could then cause folio2 to be split at the wrong
position. Does that sound right?

>>
>> So for me as an filesystem guy I'd appreciate some comment in this code
>> explaining why grabbing folio2 this way is actually safe. The really safe
>> way of getting to folio2 would be to use
>>    __filemap_get_folio(mapping, (offset+length) >> PAGE_SHIFT, FGP_LOCK, 0)
>> but I suppose we don't use the mapping lookup as it is more expensive?
> 
> __filemap_get_folio() is a better version of the existing folio2 finding
> code. When I wrote the code, I never thought about using
> __filemap_get_folio(), but I probably should have done it.
> 
> BTW,
> __filemap_get_folio(mapping, folio->index + (offset+length) >> PAGE_SHIFT,
> 		FGP_LOCK | FGP_NOWAIT, 0)
> might be better:
> 1. folio->index is needed to get the right folio2,
> 2. nowait can us nonblocking.
> 
> 

Following your suggestion, I reworked my existing patch to use
__filemap_get_folio(), and it ends up looking roughly like the
following(not tested yet). What do you think?

Besides, if the issue Sashiko pointed out does indeed exist, I can
extract the __filemap_get_folio() change into a separate patch to fix it
on its own.

Thanks,
Yi.

diff --git a/mm/truncate.c b/mm/truncate.c
index 23c90f00b530..b5e5bdf5f9ef 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -279,51 +279,46 @@ bool truncate_inode_partial_folio(struct folio 
*folio, loff_t lstart,
  			*pstart = round_up(pos + offset,
  					   min_nrbytes) >> PAGE_SHIFT;

-		if (offset + length == size) {
-			end = aligned_end;
+		end = aligned_end;
+		if (offset + length == size)
  			goto out;
-		}
-
-		split_at2 = folio_page(folio,
-				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
-		folio2 = page_folio(split_at2);

  		/*
-		 * folio2 may become stale due to a concurrent split or
-		 * freeing, so validate it before and after taking its lock.
-		 * If it fails, we can't get an accurate end position and fall
-		 * back to folio->index, which may leave sub-folios split off
-		 * at the offset edge in the page cache this round.
+		 * After the first split at the start edge, the folio at the
+		 * end edge may be freed and reused concurrently.
+		 * __filemap_get_folio() looks up the straddler at
+		 * aligned_end and returns it locked and ref'd with the
+		 * mapping validated.
  		 */
-		end = folio->index;
-		if (!folio_try_get(folio2))
+		folio2 = __filemap_get_folio(folio->mapping, aligned_end,
+					     FGP_LOCK | FGP_NOWAIT, 0);
+		if (IS_ERR(folio2)) {
+			/*
+			 * No sub-folio straddles the boundary when aligned_end
+			 * is empty so discarding up to it is safe.  Otherwise
+			 * the straddler is locked by someone else and we
+			 * cannot obtain a reliable end position, so we fall
+			 * back to folio->index.  This is safe but may leave
+			 * pages split off at the offset edge lingering in the
+			 * page cache this round.
+			 */
+			if (PTR_ERR(folio2) != -ENOENT)
+				end = folio->index;
  			goto out;
-
-		if (folio2->mapping != folio->mapping ||
-		    !folio_test_large(folio2))
-			goto out_put;
-
-		if (!folio_trylock(folio2))
-			goto out_put;
-
-		if (page_folio(split_at2) != folio2) {
-			folio_unlock(folio2);
-			goto out_put;
-		}
-		if (!folio_test_large(folio2)) {
-			end = aligned_end;
-			folio_unlock(folio2);
-			goto out_put;
  		}

-		/* Split failed: back off to the head of the straddler */
+		/* Already at the minimum order, nothing to split */
+		if (folio_order(folio2) == min_order)
+			goto out_put;
+
+		split_at2 = folio_page(folio2, (aligned_end - folio2->index));
+
+		/* Split failed, keep the straddler intact */
  		if (folio_split_or_unmap(folio2, split_at2, min_order))
  			end = folio2->index;
-		else
-			end = aligned_end;

-		folio_unlock(folio2);
  out_put:
+		folio_unlock(folio2);
  		folio_put(folio2);
  out:
  		if (pend)



