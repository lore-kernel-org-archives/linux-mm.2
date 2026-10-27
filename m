Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0BA9606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 10:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB3BF6B067F; Tue, 27 Oct 2026 06:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64746B0681; Tue, 27 Oct 2026 06:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 953846B0682; Tue, 27 Oct 2026 06:01:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7B55D6B067F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:01:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0AB361209EA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:01:51 +0000 (UTC)
X-FDA: 85367964822.09.E4532DE
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0FD70160006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:01:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793095309;
	b=nOU65qHGU1mXsd08uEwx/RK5U5N9H2Q+Kifeiqaa2xDLsl8t2YAycvQ0FZPIhs/fVtB1jW
	50EHt0VEyiY+86oAI7Z5LRH4Cd6HNMoSma4IxUd7S07zUlXa96RiWKKsSNk6qZKnk2KpkO
	czE3vu4/Lk8BQzKLkF3kFqWwn+muOJY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793095308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/jOd+AgYfw6nxbi4UGnEo0jvwbuD+ph9VhPS13MAFhc=;
	b=lElS3pd4jCvXsegLzw+q2ukK/avlH5JCWJutNE3kYUXHZ9ZfJORkCNf88LfaFOlAH2P0wE
	VFfphVyXLc28BQm8Pnxd/ZNadiiCRg9ypjrOt9uS9xaKuQMO93SGT/xdSfsUW60urto1Jo
	7rgMzr4ESIyPxlK2fUiJshLJ7ndgmDc=
X-UUID: 67921674d1ed11f19a56ed5b684f684d-20261027
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:bee8eac9-b92d-45bf-9ea9-54c8557f6ea3,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:bee8eac9-b92d-45bf-9ea9-54c8557f6ea3,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:3171a5526d3680502bcd63212733496b,BulkI
	D:261027142655OV85Z989,BulkQuantity:4,SF:17|19|64|66|78|80|81|82|83|102|12
	7|136|841|865|898,TC:nil,Content:0|15|50|99|100|101|112|11211,EDM:-3|-100,
	IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 67921674d1ed11f19a56ed5b684f684d-20261027
X-User: lienze@kylinos.cn
Received: from [192.168.111.179] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 485128601; Tue, 27 Oct 2026 18:01:40 +0800
Message-ID: <33a5582e-3d27-4f34-abb4-eebbc7c34ca4@kylinos.cn>
Date: Tue, 27 Oct 2026 18:01:35 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: use account_new_hugetlb_folio() in
 add_hugetlb_folio()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org
References: <20261027060446.289404-1-lienze@kylinos.cn>
 <d2738c37-7801-4804-bc86-2beb81256171@kernel.org>
Content-Language: en-US
From: Enze Li <lienze@kylinos.cn>
In-Reply-To: <d2738c37-7801-4804-bc86-2beb81256171@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FD70160006
X-Stat-Signature: u4s9oxz1xfwhcctxf35gmkmj3xqdtcyk
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793095307-535254
X-HE-Meta: U2FsdGVkX1/2uS89PoDCk+Zm6uZxZ62p/qJXbnDqL8E4dltaivOBKaDWbgTl2kJ4piPFl6wm+6xlZfPezWlZckkFmU5Xu3v3gHB0bfnm0mI9M+AbDtlJ5b6IUvYBlfiDyyIW9UpkL9ln8YdNeOEJ+JGLCns3Bl45Nam9ejZmKgesktJej8IOJGYwoqkWul9thacVBJ0vuHSkcxrSl3dD9dH8NFeUJ/p4VC4M262BW9OfiDacZWvjDIq2uUyfPywKJFlI44b9LcTVQmuUt0QuGVCIsHPu5jDpKeb9dWs9LZI1QJHIuUr2y8WymJfA3vzyAyBrw8kPkIRq7bcL4njLY+bGoEGNARPQtkUMcMTIXMhj5jOTVU0z65loap6XXvx4uKbyHcCrtEQjIfv4ELtkA8/1/eqsEiAy3xJ46kSFPqpdIKCZXg+GKjPH0sldE3HS+Nk4CxctNqi0moywFDnQw05tyt6cDlMFfvcauatZtzMyuL4LEcpIp5EYFvfBEUCiJ0zpKXykhVcHor81/QXwoBenILxOas+K/NpgtKYWE+zCa2KSHV/BYcksPS0TnFUx2w6SuM0UKfUCEZL+KgUMZfLt1+P1/0abKRtVN4JoCiEd6t3Rk7co/TCOYiyaUAN/75CvGSDO/Hd/8NMeBr99umaX5kZ+cftBb5gRR7tjRr9zw4MQ+Wgs/qR4gLT20EFKvrIhHAD8E8qshhcmjQd2W1H4skEg4lz0+rWxeJRClAPvdmxcc73zX62Un0udJrbxVVpwHEWxy6Ro3hqCLFBwzkt0ta8wL/bhvJR/fYeB64yjXPN6REudoxuMXdVNJgpgKhoJjpm07mbH0y394xP6ZXzYD3o/47/1l32zIfiQGw0MI/2IV6c0qzT406jYsusCgKZpi8ikPOvEzufpb+AjCzZr5JC8/CXUgMqznfS/DOx4xaNHCm492kFTW4SvEv/CJTRTTZZUhDppXESOw3c
 B4kAJYtE
 IHjhIw9Pkgmc7xxPxvHuwz080AaniOa3xTRGpj/EcJ3ZMo7FgW7ij1591925PAkjEoG8S5ZYC68g++Igv0DBFHIkuPki1Vhwcw+sW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/27/26 5:03 PM, David Hildenbrand (Arm) wrote:
> On 10/27/26 07:04, Enze Li wrote:
>> Every other place that accounts a new huge page already calls
>> account_new_hugetlb_folio(), and add_hugetlb_folio() was the odd one
>> out, still open-coding the same two increments.  Swap it over.
>>
>> The helper is defined further down the file, so add a forward
>> declaration for it.
>>
>> No functional change intended.
>>
>> Signed-off-by: Enze Li <lienze@kylinos.cn>
>> ---
>>  mm/hugetlb.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 4a008afaedf9..a8d162449daa 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -142,6 +142,7 @@ static void hugetlb_unmap_range(struct mmu_gather *tlb,
>>  				unsigned long end, struct folio *folio,
>>  				zap_flags_t zap_flags);
>>  static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
>> +static void account_new_hugetlb_folio(struct hstate *h, struct folio *folio);
>>  
>>  static inline bool subpool_is_free(struct hugepage_subpool *spool)
>>  {
>> @@ -1444,8 +1445,7 @@ void add_hugetlb_folio(struct hstate *h, struct folio *folio,
>>  	lockdep_assert_held(&hugetlb_lock);
>>  
>>  	INIT_LIST_HEAD(&folio->lru);
>> -	h->nr_huge_pages++;
>> -	h->nr_huge_pages_node[nid]++;
>> +	account_new_hugetlb_folio(h, folio);
>>  
>>  	if (adjust_surplus) {
>>  		h->surplus_huge_pages++;
>>
>> base-commit: bae9a042b03b27924c6fd5bdc00a20d6a44d6041
> 
> I have a fix in that area planned. So let's revisit that in a couple of weeks.
> 

Thanks for the heads-up.  I'll hold off on this one and resend in a
couple of weeks once your changes land, if it's still needed.

Best regards,
Enze


