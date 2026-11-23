Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B75F1606A336
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=w0a5j+QV
Received: by kanga.kvack.org (Postfix)
	id B576C6B05BB; Mon, 23 Nov 2026 04:40:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2E296B05C1; Mon, 23 Nov 2026 04:40:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6BBB6B05C9; Mon, 23 Nov 2026 04:40:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83DBA6B05BB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:40:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 179EFA84F5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:40:04 +0000 (UTC)
X-FDA: 85465887528.11.538ACD9
Received: from mta1.migadu.com (out-227.mta1.migadu.com [95.215.58.227])
	by imf01.hostedemail.com (Postfix) with ESMTP id 57A1B40006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:40:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w0a5j+QV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.227 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426802;
	b=pGTSfuqa5JLfGk5SFWkA+V0M3NIKEA4xv0EOVfa+QncEE3AYaYjJItDqp/2bLIdOi9gLKu
	QfRhmR5YSk0YraN18zROppobz22Nox+fpSpe1l6jjmV2zCAhsr/6lQ2jacZ6R6tsJpcr2p
	R45hsEPLv9h20TgdB05hs3dRuPEhf5s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+eMkEpTzD81tZmWhd1BLHyxg3x1lR4H2TnpzoCNaEA=;
	b=n6kAfjeHupiZbC/2PkC1Y+u6+8zkpnEsUwgdv8UXhy+YwwK31Le0KJp/D2XdsVyKCNVgqw
	CY3y82ZD2RTTtqpNIAzSjA+1bIBjMQzy+G+ws/T1/988Q8EYfiVRCBy3O/xd6IvSw4I5WI
	XTtBGGAduy1+fC8VkWImMFlnlG/h5N8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w0a5j+QV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.227 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AKOZmr7uaBmqal/sCBWQH1DHrEHxf/qcqO9hy6TaXp0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795426800; v=1; x=1796031600;
 b=w0a5j+QVLgQnt8AxWCGmG4nvMdNOuSXGtXmaXT/ocu6Qjd/ZJuTwUYg1qEDsI1es1gLhmca9
 S8lcCBiFGeZu4872r6/YddxNKBz1WRpYliZwTU8bRG8Yekunbn5DKMXk5jzYOvPOhGMnXvj8dXl
 drW8MbgzJ5S5np45RfXwAtW0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f66f58c573959892;
	Mon, 23 Nov 2026 09:39:59 +0000
X-Mizu-Trace-ID: f66f58c573959892
X-Migadu-Flow: FLOW_OUT
Message-ID: <1d0e349a-9f9d-496b-8e86-9d4fccc14d72@linux.dev>
Date: Mon, 23 Nov 2026 17:39:54 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/11] mm/vmalloc: undo what vmap_page_range() mapped
 on failure
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Dev Jain <dev.jain@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20261116071325.263682-1-hao.ge@linux.dev>
 <20261116071325.263682-7-hao.ge@linux.dev> <av4BbLb6SxEcRe-8@milan>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <av4BbLb6SxEcRe-8@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 57A1B40006
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-Stat-Signature: sfez7m7a6xwed13w1u6nm1umuhpbhunc
X-HE-Tag: 1795426801-820586
X-HE-Meta: U2FsdGVkX18G9Oqjfcq/NIWw4IZE+ZMRLZtPCNqIAWKcIvxIukLzM04da2/41ZvngyDD4IZaqLN4OrMKSvWQV0esCTpkAdXZrtp/kECep/Cyx+sjlwdPCZb6ZWm+/wYmeElR+1zjWhz8fxoKt7J9m398ofpqfxQ0CX0fw5ERBXoozcmLwyr2F1ET2w9cscjjkUXm3ca479JjEkURy6IRPBY0fA3Qgq5mU7N53CUcS8OvGFo4UeTYwBL20hmCDAu2NFv1HhLMwLUcyNpIYTa5oZHn+usf9Rd03lcLQy9iWG3uhPFS+L/kOZADavwIjqaBwz/rDSN2z/Sv46JbcmhbnJaKU0qgMT7WZgXPSSpNfqn3RRSsIvMrDfostAaSMCvWnafa8GEX2044mStcEIJLlxAmO6qiRVLaIm3y+QXSSci+APVm1llkwvefQfivVTk+H7RuNyo5bdo8a2Yc0w9Nv0dsOKnhSogotqSVqCYPTfOIW3cnWGw1BYnpTcorXaihhk0PC9XtwTX8Lf+g3qClBnI7RsB0o3zT0IduOhGhhuEXE0Kdyrxq0YBXLAAceRfIEowLKQ/Kh16m9NQBJEQaymkv1BdaMHWj29D/xpx+p7xLa+G1MZtKCUhWgb5/9aGBcf60lmFhMQ7DJMViBImvOxPJIi9xD26mXgikv2ydx9KWN5C9ahYVeNiuScYqra4ARr2fW9OEloxPGFHsI6ICHcjMm0hp8qXEqayYuJSBMB3kJqzh9KWTTAbbT9WWMRw//LCBCLGlLDlh4DSOOq0zW/gVRm8eL/qFJbpVEgiSobpNneiYyPwWvBN1NvsKqH8+s8s76/jfrzOmsLgptRI9eTMaB9YjJj/qvIVHWua2AALfESD8W0J0h1nCQ3BlAfrAxYVHBgVQ/cy9xOI/hCLwp7t3OrX2v/hA055PpA/YBN0yPuQrO6a3YroPy11+8UszoZkplb1uOo6AuyjnsmQ
 rkuUjMPo
 nzlt6DmPxHfKrM7wh/SdsNMVzbhapNQ3oQN7n399KEUTSiTRWj3xRXUMsqk4IvBzUzysTCPhcofUO1Aj1SGx+yWm223sFztHrmLjTgqFJaX9qFrLXbPa2zq7ME/AsQrh9DKd1nHiPOQOR7jRQZVldjVhgXPvh4arhZI5yKELKmw9vFB19z/Kqx+KTUYas9A9i4l9+K0BAfl+nzv3XlpL8OiAQLxjzb2tmEtF3ANM073yYkYF//SpG2+blPkTHiz0Q79aW1WsCwn1P5K+71gNv00LO4P36zwg4MyhyBrPoBw+fNdYhnQP5DZRtVXqZVPpB7OdIBx3xdelDLUjXsr9Om4cErdg/M+O6zvwm64TQWLO56ieRijozmFiZVsxriTD01qnUa11e2fkrLmw+hFaa/Fjwp38yJZ/qlfSBcaYYjQx1WmIBI+HRTnBhnuKzh8yoB+fjNOypYjr7XymBYsYC9kbxUZ0vqL9tOz792E+zQFo8mFsiqUsyPshcUh3jJoXpE/yeBobjkrscwWFQa6/JNz+QrKkJF6SYB2IN2w5ngJxuuZQ7jYmVqdMafzVTyBzBnLIjpxy+C4QB2OSit/Yotk1zA6NqkW2IdzrbGh9GBKcyYtk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Ulad

On 2026/11/19 03:50, Uladzislau Rezki wrote:
> On Mon, Nov 16, 2026 at 03:13:20PM +0800, Hao Ge wrote:
>> ioremap and arch setup code map their ranges with vmap_page_range().
>> When the walk fails half way, or the KMSAN metadata fails after the
>> walk, the ptes installed so far stay behind. The caller frees the
>> vm_area on the error path, so the next mapping that lands on the same
>> range trips the BUG() in vmap_pte_range().
>>
>> vmap_range_noflush() now takes a mapped_end argument that the walk
>> levels advance as they install, and vmap_pte_range() BUG()s before
>> it installs over a pte that is already set. The ptes below mapped_end
>> are therefore all ours, while a pte above it can only have been put
>> there by somebody else, for example when the caller's range overlaps
>> an existing mapping. On a walk failure the undo is limited to
>> [addr, mapped_end), going further would clear ptes that are not
>> ours. If the walk completed and only the KMSAN metadata failed, the
>> whole range was installed by this call and all of it is undone.
>>
>> All callers are sleepable, the teardown passes can_resched = true.
>>
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>  mm/vmalloc.c | 52 +++++++++++++++++++++++++++++++++++++++-------------
>>  1 file changed, 39 insertions(+), 13 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index d99d7710e1ba..5c1eacc2a0ac 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -117,7 +117,8 @@ static __always_inline unsigned long vmap_set_ptes(pte_t *ptep,
>>  
>>  static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>  			phys_addr_t phys_addr, pgprot_t prot,
>> -			unsigned int max_page_shift, pgtbl_mod_mask *mask)
>> +			unsigned int max_page_shift, pgtbl_mod_mask *mask,
>> +			unsigned long *mapped_end)
>>  {
>>  	pte_t *pte;
>>  	u64 pfn;
>> @@ -143,6 +144,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>  
>>  		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
>>  		nr_pages = PFN_DOWN(size);
>> +		*mapped_end = addr + size;
>>  	} while (pte += nr_pages, pfn += nr_pages, addr += size, addr != end);
>>  
> vmap_pte_range() either s=install everything or nothing. At least if i
> do not miss anything.

Right, vmap_pte_range() either installs the whole range or nothing.

I will drop the mapped_end argument from it, and vmap_pmd_range() will
advance *mapped_end = next after the call succeeds.

Thanks
Best Regards
Hao

> 
> --
> Uladzislau Rezki
> 
> --
> Uladzislau Rezki

