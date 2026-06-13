Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BF2CCD98D2
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 02:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792EE6B0005; Fri, 12 Jun 2026 22:02:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743976B008A; Fri, 12 Jun 2026 22:02:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681CB6B008C; Fri, 12 Jun 2026 22:02:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 571276B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 22:02:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E56FA1402B9
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 02:02:11 +0000 (UTC)
X-FDA: 84873239262.13.7D7F3CE
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id DBB5540002
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 02:02:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CIDRqTS9;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781316130;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ppBG8HHL394aG57L0uToj+2v9Gmpu/GgEZ+lqP5+24=;
	b=qbyRPWgW1FdznxbAQJcxOU84HnftatGjb9/ZWhUaSjohR1Btpww0sGMXlLE+kerS1JQ8z2
	DIUhmq2Pv1sSfR2ik7f7qcj+4SAlXtiNUsDydJNp6qC9h626jHgQOlD+tk1nM103/PRFqb
	V391KIaAwnxFtj3tIlw6Xf7cvl4a1yo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CIDRqTS9;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781316130;
	b=RR99T/06l7TgpLi/kChDOP+0zXMgDw23GYy6bo/6MEixhwE+nKDf46wneg9hgfUPv5lJTg
	xtc5/BE12LCQzRI8096A6ZtPpFwStGK1kuYNC1iRrHc/QtCCPjv1Lt/tTX/QvhLZjetF9c
	5Zc+J95kXnF9dtupSyWhWhf1qCOuaO8=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-68cc6c7df99so2400487a12.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781316128; x=1781920928; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ppBG8HHL394aG57L0uToj+2v9Gmpu/GgEZ+lqP5+24=;
        b=CIDRqTS9PtVqSZhzkBZKAP6ak8o9zy1OMaSXMuaZGil1JsXAcQO9PMQfdOhjxJsVEs
         P8qgcihKadypgfL1YONTOJ0ADF66Xk0BSv28RPz2AO0nRkwffy33qXrGPnfgVp05N1wb
         EuJgESTJYumb2lApD9oPK69syOE/NmZ5NpfdUBniwEuB3iDqPBwyrxG5aCXUi6iZvgFB
         ZdRj1wpqKYaeVG/PTBZ63fS2wPQ7OGCH+cH0DcsfsNPnF8T4rZkZ9O1tWpNg1BPgqrYg
         Thdj/OUpNTDUectu8lgkeWijbITGQl9lqxRrshUZS3E4QhmrU0FH09qWLwmB9RTdP7rQ
         dASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781316128; x=1781920928;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ppBG8HHL394aG57L0uToj+2v9Gmpu/GgEZ+lqP5+24=;
        b=OO2e97khRWSdeP/DbV8icZ1bdvQ3HvSc307MUNg99c7RqrK+ZZjGNMg3tqs6OcPQ9A
         VRhSZhepwoFaYEP4Izgjid3ixjzyX9GKllUmZ20eROo3CYPHtyt8WIUySCbvoolwchEy
         m7doM8WGZPW69Og+T/EdCpD+LAVqw6irhbaTKiZ9M5shLOvlJLiWpqttgf2ZHr1/NQw8
         cnd1pm27QGv83nz325N6T8z8NcP1WhoMCcAAf5W6u8qNysS5GEhJdPnPpBjcdgR0SMZZ
         QcuqgBisTZz/9HlgRrqmHitnaPcqeEz2RPzP3XyqmZPpV3Y35NRMZnHS4V1C3TQ9qG6U
         rVMw==
X-Forwarded-Encrypted: i=1; AFNElJ9eq+dnAqlPaBP1/fQdpEUh4AvqQgTIX8nGvWrcKU/YBSDCAE7BOWNiYmUPUdkLExY8VwJrHCdIFQ==@kvack.org
X-Gm-Message-State: AOJu0YyEWltk8lCHYxC/+psn1rsaCsEt9Ck9KcAVsMgq4WGLnNukb61M
	FWF2qvujbfMDmLAg1JCYyBWUoewv5Th/VOmElob/bKumNX5dEfP7+LBl
X-Gm-Gg: Acq92OEbcInHB6+7RsWWz/Mt3B32MqoVJdQ2R4BXaiLkOt/Ck06EnokFaaDDm2u1ZbU
	tDBt9NHlzQU8Wm8dmjKUWRXkYKNDvKvRGMbqDf8vC7T6OxIoxFXFLGvvSYMtNXIOVqy66uVp2A3
	UfxkwMNC+S66t0TpdJku0DDaJxURlFgzoEeJH2JEnxu+2Hyvp29OCMijCCAv7lDJZ/hNeRH7Nmz
	efHnp5nqoqT3X8ome89zZYmN+w0SZ7CKvyMmvA9iYB4oNzQ3xm8BflM8khD1vKvu1bBBL5BdPMw
	S8EmdPJOntsYkOsvUAuynSoeGsb74o2dE37QUYPZWmP97djNjGzcCLJbSEUfTPFaJ59wScpLlAC
	Cd5S0CVCha8+AZwsfid8T0USMxBXGXvVsy5vORA0Oy4Hu2LdryWkxXKpfbVYJggMFvibNPbSJfs
	4p8FP9fM+icN2Q7ewp5mxzVjF9iyQCEAfD
X-Received: by 2002:a17:906:8463:b0:bec:7ab2:9128 with SMTP id a640c23a62f3a-bfe27f0f67fmr170595566b.8.1781316127892;
        Fri, 12 Jun 2026 19:02:07 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfdb83428a8sm169980966b.44.2026.06.12.19.02.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Jun 2026 19:02:06 -0700 (PDT)
Date: Sat, 13 Jun 2026 02:02:05 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
	ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-unstable 1/1] mm/khugepaged: fix PMD collapse swap PTE
 accounting
Message-ID: <20260613020205.dwdvox5wget4aitz@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260609120443.71864-1-lance.yang@linux.dev>
 <7d081256-5b30-4e3c-b948-85ba76ad0e1d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d081256-5b30-4e3c-b948-85ba76ad0e1d@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DBB5540002
X-Stat-Signature: beqqz39jbr7jb3i9xn37qtooe7o8d9dt
X-Rspam-User: 
X-HE-Tag: 1781316129-321519
X-HE-Meta: U2FsdGVkX19gABDpXp4mgltldu9Fbd3dW3Mag6SOP+TjBEQTT6rjzsq8i1UHbKGZnpiokq2hG2oSO2lYmU6bKTinD0bwQHPesCOyFETIDkg8B/LsnN4kl4JM7MEr8DadcJDaUujCPdjMdFSHr+VS1HBnhkJ9fLoRv1I/GGra9r25Fw4OSPbOl3VZn6QXOxKRnXaSr7WrDp9Q2i1PAlwi6m8x6TBnoS+/6XYhD/xgYHHCjWtcgq5kuNc3fmBgLVelVV3OjH2eTZ7dAPo4nbONabXKaPWaTQguyf/J8bRH2OrQKROevTr1Mdpd4ZOikMNKnuflxi+hiqNYwWfJpeVrFy66192+AQa8fsEiKHxbETy6B/D9lrd4mBQM/WULAPGRR4Ntr4tagHXkQX3gFRetwi7ADcDWXtBamCxgmim2OuI/l97Uc9fYaS7+s7NG4WpqsHSMWnREgvSKJ91+YyWK7tx8S5lGw2WKMNDGOzdUeBpFzAb31FzU2XLxrVlJ9f4fzhOF/tDyg+o/lrBbgHXwnFvkvCJJf/sWUlyDSxmBhVDIva967xSBZ1sMfw1vJffy58alNtJihXw/GExtw+Ho4Vduj3Yu5Tyy4AX9g2vkKrwz4PEiD6U0syIAP/BzidfFaEnpgANV/J8hsT4/CbFDqbEIjofWEcZERdjMcXSpSvh1WO9+rsT4ZlhKeOLNTVL2IpC/rbh4jNuu7VjbrTS/U/fkUVv2+90KJhVUnHvLZlhiRNErFOp1FxFSVJk909Xr6dUzjc65ln+n7SQ/F0sqMr34f52e02bSQwpQA4R220bpaJcoF51DDeCyhfG4TRnROaFlcHURc/HEX20c49YTrwvSrHZETOJj2oXNF3S8Ey3l4kebbDRyzsNHVX3ysNK97GWGoBZk/AHwxhJ1JANN//UvBeIfYGF6vQZeidEIswFRr0CP5AYGOqtWOpjWZnbqhbDOUgfzjGfYceCN01o
 BZzN7BKO
 Z0mKs7FBG2fbWU6tJg1mZRxae6NyDYf3RudGcYLQONtuwJZapCFmFtHTNkXrz8tvRZpoOcXVA76fGQ/R9L4gaBp8e4KiBBDHGhIFH7eRvIRZIN9vtjEgpFCz/KPM++Q+SI6JVb9CWREXkrS4/G3q9i3burngp/Yd0fEbgMcI4DTPGX8iXM8C2/Ofg4wl9pYSLACPUAr2TOq/gebC8c6QbIT7KWBFdIrlst2VbtslH1oZY/QM4wLPYzz0ShkP/jQYl0gCogeKZTIEIsHf+6sq3zEL73gFHG9sSlJVFVeL06tQELeqjLKkDqN4HRg4kSgc0VI4yPIWJHU70U0JB5SOT6Ki9bRMliI8FZCPkYFmSic3P17b8Zd2tl+6/ibdMgfetpd/DH3yfRAjUz+HKr6U8S8RmPbYXvUh19jzWIUiWiB26JcXnRh5tRLrkDF9izpZy39EHEcbaDUYzbSc7cXS0ZYn7lhU+kdSSm8XR1VRtaO4PMOXxNfsSZZ72s1PFQpO1FFP9eotT9X7kZ4GLPmcVgOtnXwJwFx6wq71Ssm/XjZpwytPxKLsBeZKLIPeamcL9zeYwmONpZO3v8sP95GhdGE1m0hHhJxsfz7sCT1bN8SWJbMNX+soOFZu1rj1y2Gaqx4cXs+4/ZCi+/puIG/mKvFfNsMbT/c+ELklnmIwsepjgnho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 03:16:10PM +0200, David Hildenbrand (Arm) wrote:
>On 6/9/26 14:04, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>> 
>> mthp_collapse() uses mthp_present_ptes to decide whether a range has
>> enough occupied PTEs to try collapse. Swap PTEs accepted by
>> collapse_scan_pmd() are counted in unmapped, but are not represented in
>> mthp_present_ptes.
>> 
>> When lower orders are enabled, collapse_scan_pmd() relaxes max_ptes_none
>> so the scan can cover the whole PMD and build the bitmap. mthp_collapse()
>> then checks the PMD-order candidate using the bitmap.
>> 
>> With max_ptes_none set to 0, a range with 511 present PTEs and one swap
>> PTE no longer reaches collapse_huge_page(), even though PMD collapse can
>> handle swap PTEs up to max_ptes_swap.
>> 
>> Account unmapped PTEs only for PMD order. PMD collapse supports swap PTEs
>> through max_ptes_swap, while lower-order mTHP collapse does not currently
>> support non-present PTEs. Keep non-present PTEs out of the lower-order
>> eligibility check.
>> 
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>> Sent separately, as discussed in [1], to spell out the PMD-order swap PTE
>> case. Patch [2] is still only in mm-unstable, so no Fixes: tag.
>> 
>> [1] https://lore.kernel.org/linux-mm/CAA1CXcD7WAiA1b9GTLAuNZ+kHaFx0SzZwpBkqAZ=s+RHsTUaow@mail.gmail.com/
>> [2] https://lore.kernel.org/linux-mm/20260605161422.213817-12-npache@redhat.com/
>> 
>>  mm/khugepaged.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>> 
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index b12187709f6d..617bca76db49 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1508,6 +1508,14 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>>  		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
>>  						      offset + nr_ptes);
>>  
>> +		/*
>> +		 * Swap PTEs accepted during the scan are counted in @unmapped,
>> +		 * not in the present-PTE bitmap. Account them for the PMD-order
>> +		 * candidate.
>> +		 */
>> +		if (is_pmd_order(order))
>> +			nr_occupied_ptes += unmapped;
>> +
>
>LGTM, there is a bit of opportunity for cleanup in the future :)
>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
>
>For example, as we no longer have the VMA here, collapse_max_ptes_none is
>imprecise in uffd VMAs. We might try collapsing where there sure is nothing to
>collapse.

I mentioned it in [1] too.

[1]: https://lore.kernel.org/linux-mm/20260512154431.jxcs632mqqatqtsw@master/

>
>We could likely handle the userfaultfd_armed() part easier: some indication that
>we must not have any pte_none() would be sufficient.
>
>Also, I don't see a good reason why uffd would not be allowed to collapse with
>zeropages ... it's really just about missing faults due to pte_none().
>
>-- 
>Cheers,
>
>David

-- 
Wei Yang
Help you, Help me

