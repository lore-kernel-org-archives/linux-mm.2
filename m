Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31826CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90A636B0088; Tue, 12 May 2026 04:05:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E15B6B008A; Tue, 12 May 2026 04:05:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D63A6B008C; Tue, 12 May 2026 04:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 682266B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:05:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C9ACC1ABF
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:05:23 +0000 (UTC)
X-FDA: 84758032926.23.C3F9175
Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1B2F840012
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:05:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="sYozq4I/";
	spf=pass (imf27.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.252 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778573121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KcpIvgZUbFNoS8r0GW4szT56n0Mg9GCZ0+fOzZnZjyY=;
	b=cQet3vJ9VMiBOQiRMCopjjPW9XcoQLzuO7zloEUi2bJC+Pp16lPNfEFMZACQOZluTlgD3X
	EgUel7tOElrFLsC6DBwCVYMWFb5Xd4yfCmVXk/5sb4uMrS2ssTbzTaYe0l7Tcrr5aYZpjd
	r0AU98hd7VdxM5ZrCIrCa0mgZt4uzIo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="sYozq4I/";
	spf=pass (imf27.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.252 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778573121; a=rsa-sha256;
	cv=none;
	b=LA54xAKjcL2K/NotaatpKzhRYqD7liwHi7Wyme/zzusGobO9s6Uqz5u+0iLY9E/nmzkJlk
	WQnmByFdQz+vE4LDutlItqmTUGBwyWMr24G9wQoZ1UzFITGMR+G8obgCUl/sQlc6sNCr/n
	QjKwRoqkOSxc7NXi9nEr7Z+VawzCmAA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778573112; bh=KcpIvgZUbFNoS8r0GW4szT56n0Mg9GCZ0+fOzZnZjyY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=sYozq4I/OykM5Txm/gNOKpKPOF43vgcysco0nxTTzN2S07QfGdLdSjThEhfmVEdDV
	 TkhmyJWz9cMvbPBuAFpfbPZhQ8rAWVM7mq2X1Sq3vI55FKrHfUWms2b6vhhXW/E/iu
	 lf4zfivbtv1+mNdcG4koIHiyyWUFPkYJd+Qm5XJg=
Received: from [10.46.141.45] ([36.112.3.68])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id 14893C62; Tue, 12 May 2026 16:05:08 +0800
X-QQ-mid: xmsmtpt1778573108tfenon2c7
Message-ID: <tencent_FBED118A1B0D8B472EF76729C5A8F9458F07@qq.com>
X-QQ-XMAILINFO: NmRjDopJZVxOXHPVtWVa8/KAWV9Eqko2dJ6n40ru9JaaP4LMkEDuJ8JO4f0HHF
	 Dn/q35+n57AcS9hh98vAEvU/EDAUbFjFzR2RwYPgv4GkCCvK/wwzyXwTI7OLfYcKzXQ3IynoMm4G
	 yN2+xh6prQePMxFpgiNBeCa/ILPTppvNgR7z1ab1pcoPNKlC91xNGodPeHcw5gXmdWYwgmchxTCT
	 IffzfpPXOhhwxtlLOeBxwL9gxJTmRxoitJryU3P/XS38yMT7XYjgys2rbXtg1yS8/LIkjdIPWanT
	 8t4jmlhFN7MwdKv/8+GeaWltm7huBjnYZwxoA50eTa8fsBjgiQZDDel7W+jLTykcdEx8zN4zh6CN
	 l2Y7ycvvOhdBiSNM/yYEIs+WQ/YwlCD8ZF0s+fgCpKahGQC4b9Cyho51iYnqA31gfBcv5KPLp9Br
	 EYbk77cJ6G9MxDBlL6WSjTuyvS+wWJUjpSyuNJ09t7wNUFWbqJQMglkPrcwfTkFkvHmxTqkzSzdS
	 WW8gIU8ZgkDF+Aij/doQpZFH0TD+fFZGCp2yGbEHAx9/m7dRGKFeUSljx1U/rYPslMgWgfN98Y73
	 DGCnuTwYSQSCIe687AE/cq+x+k85B71ei5wNLxbY4YK/fJnzxKg2kKl+qe3MbGgAtzCad0I4aSJb
	 RFDtePz8qaGHFq7Ah3Iyz39dHrD/Pf3kDIwg6kmIY/SB/VnutDBMSFKKO+KJGShLVe1/3aWdiSEh
	 9bYqv6/8rzp7cZnqNaiJEq1jKOM2ldMul1+S2aDyCGF1EbqrEDdQ7BT7XbldMIbDh9PSinjb2IVw
	 6IcBypFNuMSKm3tE9RixOSbbJvGvtkHuQcv/5TtgbZTzrDOqpH38um6jlnW+p+6hVM5pFY0VDp80
	 vRlKvcyOSDqOWLU6nHbWoGmB3ovBiMFokH3vMur5THl4xv0yp2Ch9pNteakIuHcsQUPVdPI6yS9+
	 kuHrdlW7fs/6inslTDBL0bL5/riwS1zIA5uaZzI1N0kLNmaAcYoMd/4Tdhbc6y/DAULOMu98/AQA
	 YBJPLjkjQUD/8AoNwy9EukRXW7VA8UngiNMSejgIM6VrMDD4Ne+1eBbFYuoak=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-OQ-MSGID: <a93db167-64c2-4588-8290-4f32a212a9dd@qq.com>
Date: Tue, 12 May 2026 16:05:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/5] mm: zswap: load fully stored large folios
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chengming Zhou <chengming.zhou@linux.dev>, Baoquan He <bhe@redhat.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>
References: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
 <tencent_69E7E93D1E47766E922D48B9EA9FD1140D09@qq.com>
 <agJV-73LaAzMqDBg@google.com>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <agJV-73LaAzMqDBg@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c1g39t1agre8z74k5y5i455wkc76auyx
X-Rspamd-Queue-Id: 1B2F840012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778573116-898776
X-HE-Meta: U2FsdGVkX1/IjLAk4q8nuztzaVecnHWWViYL14JP4a4hvtmrNgir9VOQf40v25qSeTQf870oWtWXYBuvxPtzza4VX8qXeAu+bMxxSUX5qyNMJpMoxs+IdMRDsphWux7QpQ0SI06XA5VcccDkhf/P3hXSRg7z4cqYMs/1udmFXYP12VKt8W1kp2YUAroBuQqkWwZsgJQ29m90blFN0hMS8G16VYxWwwPyttR+zQuEgatOHFnvO+3kjBu2gPp2EHQG4lGifDzIA9Cddae/4JBBK+DgPn0iYx7LjOqLR7G1cReaXrdC8L1mx1lSPZ/kkOa7TTYmw68bc79RtlkLbMs14cGm8N0+gs8E816bFpBoMgfmE6HjR+lEn6Aos9iW7vRRxnuiwIgsn8R6K8cBZgNBHH1S6ffV+l8BX5AdHbKFuLouD4y0RqSQ2i/1OwTKQstjdhb+nXcsTjBxNv6Eo/AV14vm/EQjVL/aa31lvXAfSzle8q95kDLFol8woKlf5ux1Jycb9mRJB+qWWBeGTk301iOuG/fxuCnFy/M5FGNNsNldj5Z6PyW0qL/dVbcyHr/VLkfoODEcH3KeMCN0q48JzuldC12MuFZ4T6U5so33ItxVMmYUaqCSVig0Dg+Jwc7Y7FESMW57V5vGT598FHxQ05uY7brOMTw6cCsBMEbSNCsVd+h5m/qrCHa0Qtb2HyVEyWPKkWKUSdXj/yzvSUTV8QcEqaCIWt2kYY0KWX/y8XZAQqKnc04A4FDLlP7b6Ycrm4a52G6GE227G1SPbcUt4haAZ+4F17MDOUJqwLfWcn0gGLnSrqHAqokrCCn8WxhJ5aBE8dO/a64PVZ/r17qvQIBo1k2wmH2SBYp5f0KGsbbhoHk+x4RTnT559YOdaDEn5ep+Y4zpdKmrVGIDCyOspssD6v8qKLDHp3KV6ODf6fTAtT4P/+pOBRzlX+F13UX9LhG8dzj5OQXs0pT1STv
 ueqonbzi
 vw0wvp0u/JigSAxbf5uRzPReb7Cu7JfT4I6tecxcnTkGuFn6PSvmT64bWWB0eFOo88vosq4d7gQns8cJ/1bpnjh153KKmtZlql2fmyblJjpR2fJyoUNQIXuYo+v/SuI9qbDU5//XxK4I9DSZn8oU2801MPfEbWA1V+vTj9S2WxZRbw4UbeB+SsqsdAuaYPLNdlHtGXfjoiRy17Qki8QolLSIWztYqcnNt4ajYVQhWdGcp0/WTzJ2Xi7Ebg7EZvtXw8bzgJx6eUlYXMZgEIiB2yezi5zLmzp5GsDKc1374Ii6f3wy/xjhxRSDTEnQ6ZP2K9SUa1oXYr2xkDP5579AZC2WfWyMUFByI33q3lzqdbVgd+UHBJdHkplz/+J+432Q4Z+XApDnFTPSmJKQ8lB1RlWTWL22nd3+ft+m7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/12/2026 6:38 AM, Yosry Ahmed wrote:
> On Fri, May 08, 2026 at 08:20:31PM +0000, fujunjie wrote:
>> zswap_store() already stores every base page of a large folio as a
>> separate zswap entry and tears the whole folio back down on store
>> failure. The load side still rejects any large folio, which forces the
>> swapin path to avoid mTHP swapin once zswap has ever been enabled.
>>
>> Use zswap_entry_batch() to distinguish three cases: the whole range is
>> absent from zswap and should fall through to the disk backend, the whole
>> range is present and can be decompressed one base page at a time, or the
>> range is mixed and must be treated as an invalid large-folio backend
>> selection.
>>
>> After all entries decompress successfully, mark the folio uptodate and
>> dirty, account the mTHP swpin stat once for the folio, account one ZSWPIN
>> event per base page, and invalidate each zswap entry because the
>> swapcache folio becomes authoritative.
>>
>> Signed-off-by: fujunjie <fujunjie1@qq.com>
>> ---
>>  Documentation/admin-guide/mm/transhuge.rst |  4 +-
>>  mm/zswap.c                                 | 65 ++++++++++++++--------
>>  2 files changed, 45 insertions(+), 24 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
>> index 5fbc3d89bb07..05456906aff6 100644
>> --- a/Documentation/admin-guide/mm/transhuge.rst
>> +++ b/Documentation/admin-guide/mm/transhuge.rst
>> @@ -644,8 +644,8 @@ zswpout
>>  	piece without splitting.
>>  
>>  swpin
>> -	is incremented every time a huge page is swapped in from a non-zswap
>> -	swap device in one piece.
>> +	is incremented every time a huge page is swapped in from swap I/O or
>> +	zswap in one piece.
>>  
>>  swpin_fallback
>>  	is incremented if swapin fails to allocate or charge a huge page
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index 27c14b8edd15..863ca1e896ed 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -28,6 +28,7 @@
>>  #include <crypto/acompress.h>
>>  #include <crypto/scatterwalk.h>
>>  #include <linux/zswap.h>
>> +#include <linux/huge_mm.h>
>>  #include <linux/mm_types.h>
>>  #include <linux/page-flags.h>
>>  #include <linux/swapops.h>
>> @@ -1614,20 +1615,23 @@ bool zswap_store(struct folio *folio)
>>   *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
>>   *  will SIGBUS).
>>   *
>> - *  -EINVAL: if the swapped out content was in zswap, but the page belongs
>> - *  to a large folio, which is not supported by zswap. The folio is unlocked,
>> - *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
>> - *  do_swap_page() will SIGBUS).
>> + *  -EINVAL: if the folio spans a mix of zswap and non-zswap entries. The
>> + *  folio is unlocked, but NOT marked up-to-date, so that an IO error is
>> + *  emitted (e.g. do_swap_page() will SIGBUS). Large folio swapin should
>> + *  reject such ranges before calling zswap_load().
>>   *
>> - *  -ENOENT: if the swapped out content was not in zswap. The folio remains
>> + *  -ENOENT: if the swapped out content was not in zswap. For a large folio,
>> + *  this means the whole folio range was not in zswap. The folio remains
>>   *  locked on return.
>>   */
>>  int zswap_load(struct folio *folio)
>>  {
>>  	swp_entry_t swp = folio->swap;
>>  	pgoff_t offset = swp_offset(swp);
>> -	struct xarray *tree = swap_zswap_tree(swp);
>>  	struct zswap_entry *entry;
>> +	int nr_pages = folio_nr_pages(folio);
>> +	bool is_zswap;
>> +	int index;
>>  
>>  	VM_WARN_ON_ONCE(!folio_test_locked(folio));
>>  	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
>> @@ -1635,30 +1639,36 @@ int zswap_load(struct folio *folio)
>>  	if (zswap_never_enabled())
>>  		return -ENOENT;
>>  
>> -	/*
>> -	 * Large folios should not be swapped in while zswap is being used, as
>> -	 * they are not properly handled. Zswap does not properly load large
>> -	 * folios, and a large folio may only be partially in zswap.
>> -	 */
>> -	if (WARN_ON_ONCE(folio_test_large(folio))) {
>> +	if (zswap_entry_batch(swp, nr_pages, &is_zswap) != nr_pages) {
>> +		WARN_ON_ONCE(folio_test_large(folio));
> 
> IIUC the condition can only be true for large folios, so I think just
> WARN_ON_ONCE() in the if statement itself?
> 
> Taking a step back, this is doing xa_load() lookups that are repeated
> again below. Maybe we should drop this check here and integrate the
> check into the loop below (either all entries exist or don't)?
> 
> We might end up with a case where we decompress some parts of the folio
> then return a failure, but this possibility already exists (e.g.
> decompression failures).
> 
>>  		folio_unlock(folio);
>>  		return -EINVAL;
>>  	}
>>  
>> -	entry = xa_load(tree, offset);
>> -	if (!entry)
>> +	if (!is_zswap)
>>  		return -ENOENT;
>>  
>> -	if (!zswap_decompress(entry, folio, 0)) {
>> -		folio_unlock(folio);
>> -		return -EIO;
>> +	for (index = 0; index < nr_pages; index++) {
>> +		swp_entry_t entry_swp = swp_entry(swp_type(swp),
>> +						  offset + index);
>> +		struct xarray *tree = swap_zswap_tree(entry_swp);
>> +
>> +		entry = xa_load(tree, offset + index);
>> +		if (WARN_ON_ONCE(!entry)) {
>> +			folio_unlock(folio);
>> +			return -EINVAL;
>> +		}
>> +
>> +		if (!zswap_decompress(entry, folio, index)) {
>> +			folio_unlock(folio);
>> +			return -EIO;
>> +		}
>>  	}
>>  
>>  	folio_mark_uptodate(folio);
>>  
>> -	count_vm_event(ZSWPIN);
>> -	if (entry->objcg)
>> -		count_objcg_events(entry->objcg, ZSWPIN, 1);
>> +	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
> 
> Not a problem with this patch, but I wonder why different swapin
> implementations are making this call instead of putting it in a
> higher-level (e.g. alloc_swap_folio()).
> 
>> +	count_vm_events(ZSWPIN, nr_pages);
>>  
>>  	/*
>>  	 * We are reading into the swapcache, invalidate zswap entry.
>> @@ -1668,8 +1678,19 @@ int zswap_load(struct folio *folio)
>>  	 * compression work.
>>  	 */
>>  	folio_mark_dirty(folio);
>> -	xa_erase(tree, offset);
>> -	zswap_entry_free(entry);
>> +
>> +	for (index = 0; index < nr_pages; index++) {
>> +		swp_entry_t entry_swp = swp_entry(swp_type(swp),
>> +						  offset + index);
>> +		struct xarray *tree = swap_zswap_tree(entry_swp);
>> +
>> +		entry = xa_erase(tree, offset + index);
>> +		if (WARN_ON_ONCE(!entry))
>> +			continue;
>> +		if (entry->objcg)
>> +			count_objcg_events(entry->objcg, ZSWPIN, 1);
> 
> Hmm I was wondering how the stat update should be handled here. It is
> possible that a folio was swapped out from one memcg and is being
> swapped in by a process in a different memcg. For order-0 folios, the
> folio gets charged to the swapout memcg.
> 
> However, looking at alloc_swap_folio() ->
> mem_cgroup_swapin_charge_folio(), it seems like we charge mTHP folios to
> the swapout memcg of the first swap entry. This seems a bit arbitrary.
> 
> Focusing at the code here, seems like we'll count the swapin against the
> swapout memcg, which is good in terms of keeping ZSWPIN and ZSWPOUT
> balanced. However, it seems like it's possible that the folio is being
> charged to a different memcg here than the swapout memcg, so we may end
> up counting ZSWPIN in one memcg but charging the folio in another.
> 
> I am not sure if this is practically a problem, but something doesn't
> sound right. Johannes (and other memcg folks), were these the intended
> charging semantics for mTHP swapin? Is it reasonable to count ZSWPIN in
> one memcg and charge the folio in another?
> 
>> +		zswap_entry_free(entry);
>> +	}
>>  
>>  	folio_unlock(folio);
>>  	return 0;
>> -- 
>> 2.34.1
>>
>>

Agreed on the duplicated xa_load() lookups; that should be folded into
the load loop if this is picked up again.

The MTHP_STAT_SWPIN and memcg accounting points also make sense. I will
avoid defining those semantics in this RFC and revisit them if there is a
future version based on the common swapin path.

Thanks.


