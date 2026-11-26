Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D9A606A680
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A2AF6B05F3; Thu, 26 Nov 2026 06:20:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82D776B05F4; Thu, 26 Nov 2026 06:20:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741506B05F5; Thu, 26 Nov 2026 06:20:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7266B05F3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:20:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C1FEC0278
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:20:02 +0000 (UTC)
X-FDA: 85477025844.24.35F4177
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf15.hostedemail.com (Postfix) with ESMTP id 27FCCA000B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:19:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692000;
	b=WKUs8Duqole+6v5ZK1T/Lbok9srYFhrT/lEbzo3BVkCtUGeoKx8Rokn2IA8+kkJ60ihoyg
	/IJrNGFnlTa/Uy1FFaBSP30MxLpc6R9KbZ5YpSwfkUkVh4JuLIQ7e117wTUSGVqD7xS8V3
	Y0nGFZR43ya9fYmmZZnG8O/yfwg4XFc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oy20coKOo4RVez7QDzR5SPGemys71Bilu2eltbE7agM=;
	b=OMdzeYHzBzbgghosEJEClOJRmBRw5mi47GbZVJayJl35YYI77vGDwIIfDx7fcWkKeDMSq5
	bpDbllKhQwVsd/jI9XxmIutBc+fT1lM+FuD+lhRxaJ3RdXkBV0SJsMxVItZGYoenPLa/lz
	LIczPgSjEmR0QdDNQP9upDHl2wJcRwU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
X-UUID: 49a4ca20e98b11f19a56ed5b684f684d-20261126
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_TXT, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_MAILER_MTBG, HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS
	HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED
	IP_UNFAMILIAR, SRC_UNFAMILIAR, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD_SPF, CIE_UNKNOWN, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:5164b479-3906-4282-8c19-e641c61d65a5,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:5164b479-3906-4282-8c19-e641c61d65a5,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:0a6e950a75cdc679f99637ba237caaba,BulkI
	D:26112610033528PJVL0O,BulkQuantity:4,SF:10|38|64|66|78|80|81|82|83|102|12
	7|153|841|865|898,TC:nil,Content:0|15|52|99,EDM:-3,IP:-2,URL:0,File:nil,RT
	:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:
	0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 49a4ca20e98b11f19a56ed5b684f684d-20261126
X-User: lihongfu@kylinos.cn
Received: from [192.168.43.7] [(114.246.238.190)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 2135561116; Thu, 26 Nov 2026 19:19:47 +0800
Message-ID: <a7bb101b-e9d9-4e03-9854-33ccc6d6eda9@kylinos.cn>
Date: Thu, 26 Nov 2026 19:19:41 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/21] mm/hugetlb: fix truncated copy result in
 UFFDIO_COPY
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jinmeng Zhou <jinmengzhou22@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dave Airlie
 <airlied@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 Mel Gorman <mel@csn.ul.ie>, Dave McCracken <dave.mccracken@oracle.com>,
 Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Lance Yang <lance.yang@linux.dev>, James Houghton <jthoughton@google.com>,
 Yang Shi <shy828301@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>,
 Alistair Popple <apopple@nvidia.com>, Wanpeng Li
 <liwanp@linux.vnet.ibm.com>, Andi Kleen <ak@linux.intel.com>,
 Kenneth W Chen <kenneth.w.chen@intel.com>, Hugh Dickins <hugh@veritas.com>,
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Joern Engel <joern@logfs.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
 "Kirill A. Shutemov" <kirill@shutemov.name>,
 Sasha Levin <sasha.levin@oracle.com>, Guillaume Morin
 <guillaume@morinfr.org>, Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@osdl.org>, linux-doc@vger.kernel.org,
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org,
 Hongfu Li <hongfu.li@linux.dev>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
 <20261125-hugetlb_fixes_2-v1-2-db27fd2f71a8@kernel.org>
From: Hongfu Li <lihongfu@kylinos.cn>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-2-db27fd2f71a8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 27FCCA000B
X-Rspam-User:
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: szga3sfnke7ih1oyntsijncupu56a7w8
X-HE-Tag: 1795691997-483330
X-HE-Meta: U2FsdGVkX1+ucZi7U8sRTKfPWgVei8NB3NlSFtfJZEMh01G6rvL7ZGlJ+ww5E0uhuOyTXBfBgUH1AACRXQb/hSLnb/YuEQSIj6As6DkA79wu4XcLvmLq/NXVGJhhZbZpcuhA1w+XAt4tAgg8u4KTClKamsJ/RiLB4cgGjccuKCsjervsPA7idjIuoatFYqDwEPkXCdZxVUr9rgkk7oYPTgrFDoErvS0xix1I7si2G0jvzazZslVHCr4Oszxuw5g4ghgmUlraxIkFcrUCpPmCXXN3/DWjy8/ooox9UF/2BDK5TuqlI3RNuPzMwaE8+Rt2tTf1mlk8F4RScLAEI7KEb1l1qoKUs5oVpCnpUr8dniWpEFFBe8UnFwRj3AWP4J//SoQmP7kx/PtAPxuLfrwl7MzTlCqrfigGJM8g+jZhfstwdcV2F+6/iQ+ZTH1mLeKK+PZbFMWdF0jnrpFc7HTOidk0GHM9ZCz90GFmTwqs/Z8xrlwMeA2Dw/CGsZ4gGwCr3n0iK75Toq4dUvgmZwrd9fEnFNvZggEco2gv/lGwitcLmk4gJjVlae5ssgs8x9PmN/C3vqBb/+mfqW6lMDsCkBMJcYjTcoX571aFZb3DDX86KDtbY9/nREEvFIotCH88OLFbrgn11xCa8xj5vEcT/Hh8kD7wkZ4pYCHBM2/SLxud8S65FODaviaEsVKotDzpY4kUNJyrTraiFyAwMBuxoPp4Cl5i8z1RVftqTelFvLGTtzws9lfWqrnqEgFB2fE+Ch8LctogYfNa/kJao9NulO2FLIvHNXx8pK6eraxfLQk8KkCvjNK/7irLZmHAiMO7aFDSH2VHzi/MfieBU7C4T18X+Mn7yyIXIzhXjgwI7fsdONZGU7Im6Gp4TOd/kNBXJIj0+gNjCrSo7wu8K5fuOUbEuiA+FoWZm1k+YB3/NdRwa1FPjsYkBkSFKRoQjHKWUr3GN+UpbdK/VYOv0kE
 7ogeaOPh
 GpGYSDiwTwQzWd6HMI2nKBMq4T32vvN9WjDDoS732i6I5TrbQDVYO9RP8q7niVR6BgPkdsvju9aJkiUBFzqtBGLtbFdc7uuMUkQ9/l+IxepoKdVJLYMQzJY0jrEgMKUKzm8nlugJkVKNh2LPmSDF1ljnS/e6wIA6vV/U5iCqW8sIXkSyGBx2lIu2Y511ocO2mm0HjFO2Kie9Pouyb3BvHjkcF4xFiWT10INTrjOuOFP/vNjoHDO4j+SNxKYrQwbUIEuhvUgj1lHUnqq9DF4LQyrLuGXWVKRYfFR5RSI0g3YTt/YFONGBvLfHRHa7Zs6jeTTBe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 11/26/26 06:33, David Hildenbrand (Arm) 写道:
> From: Chris Mason <mason@kernel.org>
>
> Folios that span more bytes than can fit into an unsigned integer (e.g.,
> 16 GiB folios on arm64) are problematic with UFFDIO_COPY: the result
> from copy_folio_from_user() can be truncated, possibly indicating
> success instead of an error.
>
> We will then continue with the folio that has stale data, and make it
> accessible to user space.
>
> For example, if copy_folio_from_user() fails such that the number of
> bytes not copied is a multiple of 4 GiB, we'll get an effective ret ==
> 0.
>
> Let's fix it by simply testing the return value directly.
>
> This has medium urgency, as it's an information leak.
>
> Fixes: 8fb5debc5fcd ("userfaultfd: hugetlbfs: add hugetlb_mcopy_atomic_pte for userfaultfd support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: cleanup code and description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Hongfu Li <lihongfu@kylinos.cn>

> ---
>   mm/hugetlb.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index f46c85fc0cd0b..d57964914e18a 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6568,11 +6568,8 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
>   			goto out;
>   		}
>   
> -		ret = copy_folio_from_user(folio, (const void __user *) src_addr,
> -					   false);
> -
>   		/* fallback to copy_from_user outside mmap_lock */
> -		if (unlikely(ret)) {
> +		if (unlikely(copy_folio_from_user(folio, (const void __user *)src_addr, false))) {
>   			ret = -ENOENT;
>   			/* Free the allocated folio which may have
>   			 * consumed a reservation.
>

