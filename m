Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69549CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C83D86B0088; Mon, 25 May 2026 11:01:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5B856B008A; Mon, 25 May 2026 11:01:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98276B00A0; Mon, 25 May 2026 11:01:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA6CA6B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:01:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B8A31C006A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:01:47 +0000 (UTC)
X-FDA: 84806256654.27.21D14A4
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4C4B9160021
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:01:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fsSvL3R+;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779721305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AzwE9k9QJF7DUyRnk+qmGDQkXJ2+kA/q8Ntjxx3//vI=;
	b=6tMKOdiQfRVv1oke8VNjDqTVC8WSICfgf9g7y2iEm9/Do+KT89gonz2Xs11u19E+40rKha
	SZAy9n7wUQPOm7K09mST/MsdeVldtRH0242YccJtVL5ZeYBVmRCX2WA2JVNE/Z5dJmK7Cd
	NpQu1YMxy6YpAPVabqeMDA2/+R0ETdc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fsSvL3R+;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779721305; a=rsa-sha256;
	cv=none;
	b=qvAYC9fYc9rwfm596XwbkhwaZNDWNVr7xMdcLyRJsYTkNe7pswhw6CZmdRIn/5mGZWo5Qr
	0/4CmzAtfLDFAYY6NI//ceD274c0AiWI93zCbBKsVbB4kXYtev/soLZngt86H3Vss54QbP
	6bL87eMsvnmEHy2Vu4M3Cbm8vNnaGvw=
Message-ID: <8edc8cd0-f65c-4456-9b3f-362e744c9a96@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779721303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AzwE9k9QJF7DUyRnk+qmGDQkXJ2+kA/q8Ntjxx3//vI=;
	b=fsSvL3R+HyOLiJBlzetIGjmPzu1GfueYA9lAtGy2Z8SL3+P0kPz1vyGsKd+ewF7+yPqqfC
	/iuy4xlG2sBfvGWm8UGvpe2AWMCyGuQUPrUGljCAmlQ3kSIJHpayjMw01YvtZ7vJP62/sE
	FqH9kKksxanHmBQ196JOJTJSIlyErtA=
Date: Mon, 25 May 2026 16:01:19 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v5 0/2] mm: improve large folio readahead for exec memory
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, willy@infradead.org, ryan.roberts@arm.com,
 linux-mm@kvack.org, r@hev.cc, jack@suse.cz,
 Andrew Donnellan <andrew+kernel@donnellan.id.au>, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
 catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
 kevin.brodsky@arm.com, lance.yang@linux.dev,
 "Liam R.Howlett" <liam@infradead.org>, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, ljs@kernel.org,
 mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com,
 rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com,
 vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 wilts.infradead.org@hp2.hsd1.ca.comcast.net, ziy@nvidia.com,
 hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 kernel-team@meta.com
References: <20260522162422.3856502-1-usama.arif@linux.dev>
 <20260522122052.7b4ad7c482a0e4826296e392@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260522122052.7b4ad7c482a0e4826296e392@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5o8twnjup1qyd3zar4yx8r9au15u9wio
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4C4B9160021
X-HE-Tag: 1779721305-76680
X-HE-Meta: U2FsdGVkX19L/BDLokQw84v9atxFVem/O0wDpvLE7HfzARFAp5rZslgveMFF0zl+xfRTVTW+0nKMKb97y6UI2xi7HgH/8mbMqL+f8ZJeu6+J/Bk6mi8kEC/s26SKvVGUGaaiUd/WqW0LQV8JPqDIOyaEDd8nQPxCGro3UbQTfqT7uee6YeqroKNKLRbYvYjQDNksPAX6+WU/jo43Pmpi37RomEqs4GZnXmplU4XP/gLeRoJLhFVAtg7RR/uJ2Gv3JubA4tbBaE2LRs5Z/LvLDBh+iSbcRe4hidqOWVVobE22V9vbwqXDwvpqvBA0hmPUSMnfTIbIAX22V288ZTLTSwofmh0EVA0bnSCQsMvWmRWGLGnsXzCu65Jr7rYio97ss2FlHHiMZvUPUX/Q+y2V3B78q5FX1H/7FkHwFpoVgCdgnqHntj69+jI2HgPSwyvHDmW3WAV4zSB/5l4hYnSjGKGRJ7mwLfpxDwfWbAebq+QSHfF5+2py84Q/pNrp7gj8Ny+bOJC5rGoBFyl3XB0/+GoJ0f+9UFG8BsMdCXycMH25P0Brfgwr9PgJwlZDkigv5pVggCrfxjk+9Hk8krBdPpTxYfv7DUoL69H8T9f4PW7hbS58WB+UpWJMuLn/4b1BbzS/Bz3gEsrqQmGOsVkJF+JmLQsuAE/c6CWsS/z/KPypzA9ClWvM3xuhfgoonlvq9bKYLadrSAa4Lb/y+UsuX3MltGEqHJxglv96unS04yg8JER9qurAuKO7gGbTLjgLCsm7kFO+zza6iTHa7jWX42PG0m4ODCTgw1y9rPV850rKJ8yRbV0ZjJh6gR5ZLOvZYM3t75dyZaNgDYA5F1iMqNe1fCLY/Uu0bM2SrDoduw7r48wg7AKYcrI6tgcLs4NR6Iv0+HjRRo5yovpvhfOJPNeNtK4jPvIk08BT1YB+8V6WVjgDMj+Yf7i3ayb7i7jkav0DKRI1+kkso2rPT8I
 5+LEg8mK
 GdqlMMTAZvgkqzwJsR24NiTFwpulL2K0WpbhViVg5pSjX3DPQDnUnaZQR/LkFqSTYsJZUwGQ0G3Cl3lKSdgtUFKqHMDMJRWBKNB/vNoPvxC7oPuTPKCB3RHRcJliQSA+kNn5q/6rMafKoCKSTO+4p1/9qGxPayJlzn9bGueurhciZ0fbKLG6ygoUkubtUyZL3O7CjRlVz8r94kRzOOExji75ptFeoH7ZyBHo4PUMcnHtyapbYtBmw+qx9uOsJLEcg0Y/yZpczi9HreyEgU+DUXW+IUQ3VrxoX3BSG9T0E/qKAHisgr0X+PWJ3r3uRlE4/Lc1lYsiAqx4SPIglMjCK8GCJuCpY3Bns79R5L7exrpbXDNnE4V1bLzPpGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/05/2026 20:20, Andrew Morton wrote:
> On Fri, 22 May 2026 09:23:46 -0700 Usama Arif <usama.arif@linux.dev> wrote:
> 
>> Two checks in do_sync_mmap_readahead() limit large-folio readahead:
>>
>>   1. The mmap_miss heuristic is meant to throttle wasteful speculative
>>      readahead. It is currently also applied to the VM_EXEC readahead
>>      path, which is targeted rather than speculative. Once mmap_miss exceeds
>>      MMAP_LOTSAMISS, exec readahead - including the large-folio
>>      order requested by exec_folio_order() - is disabled. On
>>      configurations where the mmap_miss decrement paths are not
>>      active (see patch 1) the counter only grows, so exec readahead
>>      is permanently disabled after the first 100 faults.
>>
>>   2. The force_thp_readahead path is gated only on
>>      HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER and always drives the
>>      readahead at HPAGE_PMD_ORDER. Configurations where
>>      HPAGE_PMD_ORDER exceeds MAX_PAGECACHE_ORDER never reach this
>>      path, even when the mapping itself supports usefully large
>>      folios well below the cap.
>>
>> Both issues are most visible on arm64 with a 64K base page size,
>> where HPAGE_PMD_ORDER is 13 (512MB) -- above MAX_PAGECACHE_ORDER
>> (11) -- and where fault_around_pages collapses to 1 disabling
>> should_fault_around() (one of the two mmap_miss decrement sites).
>> However the fixes are architecture-agnostic: patch 1 reflects the
>> nature of VM_EXEC readahead regardless of base page size, and
>> patch 2 generalises the gate so any mapping advertising a usefully
>> large maximum folio order can benefit.
>>
>> I created a benchmark that mmaps a large executable file and calls
>> RET-stub functions at PAGE_SIZE offsets across it. "Cold" measures
>> fault + readahead cost. "Random" first faults in all pages with a
>> sequential sweep (not measured), then measures time for calling random
>> offsets, isolating iTLB miss cost for scattered execution.
>>
>> The benchmark results on Neoverse V2 (Grace), arm64 with 64K base pages,
>> 512MB executable file on ext4, averaged over 3 runs:
>>
>>   Phase      | Baseline     | Patched      | Improvement
>>   -----------|--------------|--------------|------------------
>>   Cold fault | 83.4 ms      | 41.3 ms      | 50% faster
>>   Random     | 76.0 ms      | 58.3 ms      | 23% faster
> 
> Well that's nice.
> 
> AI review might have found a few things:
> 	https://sashiko.dev/#/patchset/20260522162422.3856502-1-usama.arif@linux.dev
> 

Thanks Andrew! So sashiko seems to have brought out some interesting problems,
some of which are pre-existing. For example, the decrement sites for mmap_miss
in do_async_mmap_readahead() and filemap_map_pages() dont skip for VM_SEQ_READ.

I have sent this as an independent patch in [1].

I will send the next version of this series on top of [1] in a few days
addressing the rest of the issues raised by sashiko.

[1] https://lore.kernel.org/all/20260525145751.2671248-1-usama.arif@linux.dev/



