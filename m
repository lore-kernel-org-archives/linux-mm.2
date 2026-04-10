Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D300F44846
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8135D6B0089; Fri, 10 Apr 2026 08:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C43B6B008A; Fri, 10 Apr 2026 08:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DA1D6B0092; Fri, 10 Apr 2026 08:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF626B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:05:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 27324E2F71
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:05:57 +0000 (UTC)
X-FDA: 84642517554.17.77A8ADF
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2C3D310000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:05:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S1IPhLac;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775822755; a=rsa-sha256;
	cv=none;
	b=DhAsJrjeG785afehktNz1qhBCXYJq3HxppR4+hZL6nD9NfvACEFy1QzKX7Jz2unBRA78YP
	+E7QddTuYAgg9Tu8iSO61YGrv7TeDQROGrnybdNBWV+x8KBI3ALJSAuzxvvT2vnlxIq/q1
	hvMIWqg8RojGH5B/os7BdDCXIhiueN0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775822755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UciXY4UpwF/PVQ55Oa+nceO1l3r0LRhzvlDseaImpoY=;
	b=reBT56Gkh3BWlTHyg17JbgtqWXXTDUCD+aLnnoXw3TXJFGjcGBXV4DBsIf3DBJnLLAQ+uC
	Zb8JAKhL1DS3f+A+KKNvoci9ikYvgFNRvgtv7ZxJnprIigJXRCLLdzVdPFU5Lwj4jNU/m/
	or3B7WLIGKSfoJLQlmLxQEvtpitePeQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S1IPhLac;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <262a41db-a425-4362-bb67-df61119625d5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775822752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UciXY4UpwF/PVQ55Oa+nceO1l3r0LRhzvlDseaImpoY=;
	b=S1IPhLac5GLe8aWkzUNhPX1PlP9fq5z3WRAjL+vGJS6PRIGTZh7B7rKGP6zR510zSkjeYf
	K2QNdKANEbpRs7f7uwGklMZu8fyrnR1UsL3rCWPzJNLUoi6SJAO92EUU22rkQ1qumaPnr5
	nnM4xvZ//KZw8+pWbEggmfs0orX141o=
Date: Fri, 10 Apr 2026 13:05:40 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/4] mm: improve large folio readahead and alignment
 for exec memory
Content-Language: en-GB
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc,
 jack@suse.cz, ajd@linux.ibm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com,
 dev.jain@arm.com, kees@kernel.org, kevin.brodsky@arm.com,
 lance.yang@linux.dev, Liam.Howlett@oracle.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, mhocko@suse.com, npache@redhat.com,
 pasha.tatashin@soleen.com, rmclure@linux.ibm.com, rppt@kernel.org,
 surenb@google.com, vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 leitao@debian.org, kernel-team@meta.com
References: <20260402181326.3107102-1-usama.arif@linux.dev>
 <803a0c15-0a6a-4c00-b6b3-eaae56d5fc15@linux.dev> <adjkCOiLgZ_-zovg@lucifer>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <adjkCOiLgZ_-zovg@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2C3D310000A
X-Stat-Signature: 8cyrtujmb9a741dpar6eyyc7n3cep3ti
X-HE-Tag: 1775822754-949323
X-HE-Meta: U2FsdGVkX1/TZlGCjiGZj8Tu8Nyg+H+vANQnkJhgInt0xjb35qMCB4jlWfIjq7ymlBX0TRkbNzlxg6zMDBRFrs5i6MvvqSLcYj87p43FWhalV01ZOv+SbKg60rFkpfDiC40XvLRUgQQp5DEGpUKv1xQAxVLhdmvDYKi49YEjyA1yp32/WOktsTRyNSA62ePgknm4Nmt/AjOPgf1XewlYRkhPBhLaD3WqOXRhdTf3fL+I6g5ze1HSK39HtZ1PPXkz0xmN0Gvt8bSaEVpB1F7FNrGgbh2miqQOQ/89GB5g6R87wh2VZ0g09zB0OEg0C0lpy1jRZJ204UVvECkSaa8jB+QsCJtzOFoHnFsrkU6xq1hHK9fg/OFlbBWqvymOcce0cPcBC4T0r4nA2pByZVKgDJUsNvQpEXHlmWDcyJtl6OlPIo9lMnDsgoCcFhrZtmp6aPITcs/N9245zDwV1ZxpBqbJK66aaRvPiQdwGddR3JRx4ypp+ZoEZF5d+r0uglKB2VVvy2akNL3GZxiGo652pWPR9jAIc8LrqRYBgJ8KX+DBQYP670eahNeu8UC5tv/QtEdPpy0wMI9IPqXe2agAjAu1RF8DV+3TVST/sJauKVfpVHCUaxDGsjqmViKRMSoSgbQxxudd8LY/xP8cTAiD4w3mg8wjf2EcdOvjAbgkc5/47ojtdDhFaFCMaClex1ckVAcmZ5IoxqGUU5ReBDoGAKTBQt98ygz54TWS8nov0pLGCQeuxx23eLnjvOurOOvI+m0mnDcqrOoNSmCA7fjtts7Rg4xG7jrJ6wFSrKda+h8BkjMOtgqCT6fUXy8noo6bm37Ak/hxaTwn2wxjV/b/9DqM916Q14/Rk8mrGt64BVeCumZFI/0PXSpQmVLfNLqlzhqXpCQJLEv2SqiPxGl7SJNzOB1AWB6261JdPiIGXWby4mAsUocLt0GMlGfxiGq2SsJg7q+F2+fAv11wEQ9
 jJZfVT5K
 bgfyzu3RbOVc5dWfoJOkf/fRjkjwx+aWV/NIdQ+5SD0VbGi7o/S8oCm1wZJwHTXrIIHPAhqQUX34r6JJQgEZohpqKR9MMtC7qt7xYttfjh6GaXOyIEj90Fr1Gp7I6+7cgWUUfU9LHojAXAq35/q950uGdrCY/r04uJOIhqBUxk0CWzO7gI+zh2yX+7mjKSAuFwE28DHhX1AEQrMDiezI3+JRwg3ox59fwbB3BzdnvFdytfEw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/04/2026 12:55, Lorenzo Stoakes wrote:
> On Fri, Apr 10, 2026 at 12:03:03PM +0100, Usama Arif wrote:
>>
>>
>> On 02/04/2026 19:08, Usama Arif wrote:
>>> v2 -> v3: https://lore.kernel.org/all/20260320140315.979307-1-usama.arif@linux.dev/
>>> - Take into account READ_ONLY_THP_FOR_FS for elf alignment by aligning
>>>   to HPAGE_PMD_SIZE limited to 2M (Rui)
>>> - Reviewed-by tags for patch 1 from Kiryl and Jan
>>> - Remove preferred_exec_order() (Jan)
>>> - Change ra->order to HPAGE_PMD_ORDER if vma_pages(vma) >= HPAGE_PMD_NR
>>>   otherwise use exec_folio_order() with gfp &= ~__GFP_RECLAIM for
>>>   do_sync_mmap_readahead().
>>> - Change exec_folio_order() to return 2M (cont-pte size) for 64K base
>>>   page size for arm64.
>>> - remove bprm->file NULL check (Matthew)
>>> - Change filp to file (Matthew)
>>> - Improve checking of p_vaddr and p_vaddr (Rui and Matthew)
>>>
>>
>> Hello!
>>
>> Just wanted to check if there was any feedback/review on the latest
>> revision?
> 
> It's -rc7, this is definitely something for next cycle :)
> 

Yeah no worries! Just wanted to check what people thought about it!

> On my part, my upstream bandwidth has drastically reduced, and review is
> probably going to have to be a hobbyist thing at least for now.
> 
> Also, not to be mean but:
> 
> $ git log -E -i --grep "(Reviewed|Acked)-by: Usama Arif" --oneline | wc -l
> 21
> 
> So... :)
> 
> Review in mm is very lop-sided, let's try to balance it out a bit!
> 

Ah yeah actually I have been reviewing a lot over the last few months.
I dont ack patches that have already been acked-by/reviewed-by maintainers.
as I am not sure if it adds anything. I never really cared about Reviewed/Acked
by/patch count but I can start adding tags if it helps in stats.

The reviews I have done over the last week alone:
https://lore.kernel.org/all/20260408122307.1360475-1-usama.arif@linux.dev/ 
https://lore.kernel.org/all/20260408123700.1596800-1-usama.arif@linux.dev/ 
https://lore.kernel.org/all/20260409142256.131676-1-usama.arif@linux.dev/ 
https://lore.kernel.org/all/20260410114809.3592720-1-usama.arif@linux.dev/ 
https://lore.kernel.org/all/20260410112433.3248586-1-usama.arif@linux.dev/ 
https://lore.kernel.org/all/20260331103451.1070175-1-usama.arif@linux.dev/T/#t 
https://lore.kernel.org/all/20260401152343.3294686-1-usama.arif@linux.dev/ 






