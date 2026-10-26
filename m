Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20718606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 07:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23DF56B05B0; Mon, 26 Oct 2026 03:47:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE936B05B1; Mon, 26 Oct 2026 03:47:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DDAE6B05B2; Mon, 26 Oct 2026 03:47:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DEEBB6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 03:47:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 89F7FA8269
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:47:21 +0000 (UTC)
X-FDA: 85363997082.28.B261431
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf02.hostedemail.com (Postfix) with ESMTP id 443D980005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:47:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793000839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=efvClWXmzSCJ2hWGmB2r4EDae9BDwVMUS1T+/Zenuoc=;
	b=5uMZu/Qm3UJ+XKXo6VYHvESdTC9sb0649mIt9X11OgLGnaAFLYQuVnki31fOL9rxEaPbD9
	K+smHgt8XksDSMTGJDmZ/zrcJyGyO4BN1dOQKqocOTjk0Naqum5V/u/vZaK+3q8qC0Rw7a
	i7sW++DAbAWQR0WW2dTa/itSGvgocvk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793000839;
	b=DYh7tRcgsw+9eh6z99GIkT6IghP21UkN7IWzPvj1N2rlmC05JEC/pJIt0El5aN6+3hfG45
	aQ27UaZI+yizrz3H9HLHR+xQJNbf0WNeChiAvS9lQakK52SIgmdRQW89+lIBq/TxUedhFQ
	ZDYoKUD7vG1mLVXNJicFprolQuO81rI=
X-UUID: 6fbdeb0cd11111f19a56ed5b684f684d-20261026
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:aa9a0a8f-2a65-4209-83bf-e5d80d96e8ee,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.19,REQID:aa9a0a8f-2a65-4209-83bf-e5d80d96e8ee,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:7db8b62,CLOUDID:4a10ed235e5d1ca5ec8e33e3e9b6f124,BulkI
	D:261024181021U0XYGX9T,BulkQuantity:4,SF:17|19|64|66|78|80|81|82|83|102|12
	7|841|865|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil
	,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6fbdeb0cd11111f19a56ed5b684f684d-20261026
X-User: lienze@kylinos.cn
Received: from [192.168.111.179] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 654595180; Mon, 26 Oct 2026 15:47:04 +0800
Message-ID: <dd64df01-da75-483e-92f1-8a19a995f610@kylinos.cn>
Date: Mon, 26 Oct 2026 15:47:01 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: hugetlbpage.rst: clarify HugePages_Total in
 hugetlbpage.rst
To: Daniel Pereira <danielmaraboo@gmail.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 akpm@linux-foundation.org, corbet@lwn.net, linux-mm@kvack.org,
 linux-doc@vger.kernel.org
References: <20261023100859.70744-1-lienze@kylinos.cn>
 <1792998249167036.77.seg@mailgw.kylinos.cn>
Content-Language: en-US
From: Enze Li <lienze@kylinos.cn>
In-Reply-To: <1792998249167036.77.seg@mailgw.kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 443D980005
X-Stat-Signature: 99dsxhmiz53jhmdw64rnezns7hpce31p
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793000836-477322
X-HE-Meta: U2FsdGVkX1/muySJ428ByuwBYy9UK0xmJI/TwEEIMyChdMcPbTKgw7sU9L2DOo4TywZnNrnfo+Tg7Usd45IcuQ11UVnOnnMGctyfjSsQ++T4ZjkJ/Vm4eLm8jWaO8BAywQUjNXd4NX6cbh96evXaBz36vT1whTdNizp0+hJycqIuTfX+IRz8M+Dli0jwT8s6YUnU/HnDrkGUFoo25US6YFcwyXtGhBKDxmoGIzalSHABMJ+gpgR1M3cVDwjp4wX6FxGFhiso7tqz10Vw4JL1IRb8bkvVxmzHRu1HdL9yvCjy3LLGmmrKKR6sI1q3UxpZ4bmL/zeSu6kkrcMCdoN3aRAY+AdHgXq7cI9OLlrgcdVGG9O4vdT7QeT774sk+0FCtI9AXe/zxCa0DGW3iFkIQvQprliJoXZEqaKA8KlulwVGO3XV5/GS8mFNIFsQI0rOAOJzmcrOIlzu/fEuLD+9JNSZC/Gt+XtypKjC/oHSJsd4e23z3lts5IxAYcCEuXaCYHxk5PovDjtfJMxDmkPxvYoKp44408O6QdSGCBX6dJZ28N/qSopweQnKWlALtuHC0sGZzYs/5M8nVH1f3ed/uXGkTZZ3YsT9L0BP0arBF8Qw3CN+Au7Ac+CN9TK6sZNH0umfOBsOOaB2VbcXOb0OBPaFyHFJcEzs/gGfrWeJpIEDqgp6dtw73NjtJp2bT17zzRTrPj579O53sd0RxL0hRWUCn7L+oyeZLS3FaaXVuaI7DVZu2z3106kR5yemkmVGO0Q6ujEB2PjrhzPqNatW9vBphZs1iFyqsty13tG/b5286XvUwPU+nxF7BskoSQbKFwUExYMS9FPYaLodIYFYAo5GXa+aM7RmSJfiSKgMRNfHzsgQs2GFYidX/7C3Ml+mjXRg7P5FxLYxvHCiGStuRSWoag6y6UNRcJkpBAaEAOI3tjSahpKRzxxtCGwfuAtnq7gxXhsHT0h7COsaGP5
 /3teQPWS
 lRq+4yKVQ0rlh+1b/od1+le/xoyDfux3iEskmbfMCAi3R4MzAzzqHlEdJfiLFlJGnALsw6h/pkbkcvWqX2gXLtPtwWjw/lppquUbcJHYIeN/p25+IZNCmTEPf3KG/C7+P2QxT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Daniel,

Thanks for the careful review and for building the docs.

On 10/25/26 9:25 PM, Daniel Pereira wrote:
> On Fri, Oct 23, 2026, Enze Li wrote:
>> HugePages_Total
>> - is the size of the pool of huge pages.
>> + is the number of persistent huge pages of the default size
>> + in the pool. Pools of other huge page sizes are not shown
>> + here; see ``/sys/kernel/mm/hugepages`` described below.
> 
> Hi Enze,
> 
> Thanks for this, the current wording is indeed confusing. I checked the
> new text against mm/hugetlb.c and have two comments.
> 
> 1) "persistent" is not accurate. hugetlb_report_meminfo() prints
> h->nr_huge_pages for the default hstate, and that counter includes
> the surplus pages: alloc_surplus_hugetlb_folio() accounts the new
> folio in nr_huge_pages and bumps surplus_huge_pages in the same lock
> cycle (persistent_huge_pages() is defined as the difference). The
> HugePages_Surp entry just below already says that surplus pages are
> "in the pool above the value in /proc/sys/vm/nr_hugepages". So with
> overcommit in use, HugePages_Total can be larger than nr_hugepages,
> and describing it as the number of persistent pages would be wrong.

Good catch on "persistent" -- I forgot nr_huge_pages includes surplus pages.

> 
> 2) "Pools of other huge page sizes are not shown here" is not quite
> right either. The Hugetlb: line, a few entries below, accounts for
> pages of all sizes (as a total in kB) and already points to
> /sys/kernel/mm/hugepages. What is missing is only the per-size
> count.

On "here": I only meant the HugePages_Total line itself, which only
prints the default hstate's count, but I agree "here" reads as the
whole /proc/meminfo output and clashes with the Hugetlb line.  Your
wording is more accurate.

> 
> Something like this would fix the confusion and stay accurate:
> 
> HugePages_Total
> is the number of huge pages of the default size in the pool,
> both persistent and surplus. Counts for the other huge page
> sizes are available in ``/sys/kernel/mm/hugepages`` (described
> below).

I'll send a v2 using your wording and add your Suggested-by tag.

Best regards,
Enze

> 
> I built the admin-guide/mm documentation with your patch applied and it
> adds no new warnings, so my comments are only about the wording.
> 
> Thanks,
> Daniel
> 
> 
> Em sex., 23 de out. de 2026 às 07:10, Enze Li <lienze@kylinos.cn> escreveu:
>>
>> "the size of the pool of huge pages" confused me, since it sounds
>> like a size in bytes.  It's actually the number of persistent huge
>> pages of the default size, and pools of other sizes aren't shown
>> here at all.  Reword it and point to /sys/kernel/mm/hugepages for
>> those.
>>
>> Signed-off-by: Enze Li <lienze@kylinos.cn>
>> ---
>>  Documentation/admin-guide/mm/hugetlbpage.rst | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/admin-guide/mm/hugetlbpage.rst b/Documentation/admin-guide/mm/hugetlbpage.rst
>> index 2075f1f14a42..01fa9f61c9a9 100644
>> --- a/Documentation/admin-guide/mm/hugetlbpage.rst
>> +++ b/Documentation/admin-guide/mm/hugetlbpage.rst
>> @@ -43,7 +43,9 @@ The output of ``cat /proc/meminfo`` will include lines like::
>>  where:
>>
>>  HugePages_Total
>> -       is the size of the pool of huge pages.
>> +       is the number of persistent huge pages of the default size
>> +       in the pool.  Pools of other huge page sizes are not shown
>> +       here; see ``/sys/kernel/mm/hugepages`` described below.
>>  HugePages_Free
>>         is the number of huge pages in the pool that are not yet
>>          allocated.
>>
>> base-commit: 3fdcce698abd9193752ee89fb1a440cdceb1b74a
>> --
>> 2.56.0
>>
>>


