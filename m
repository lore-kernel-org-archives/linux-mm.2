Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E388C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 07:14:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47D106B00D4; Fri,  3 Jul 2026 03:14:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4540C6B00D6; Fri,  3 Jul 2026 03:14:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369936B00D9; Fri,  3 Jul 2026 03:14:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0FA526B00D4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 03:14:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 833A1120464
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:14:09 +0000 (UTC)
X-FDA: 84946601418.09.2B76390
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id AC235180006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:14:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EfzPfzJh;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783062847;
	b=AqeBPM4mfA2seY7LcHThW6BL7YskGzPmjXiJ5AfoORVC/O6wogtChqqE1JlfXEhEk1QiST
	3yu7bSjwC4InJrojUt27Z4Mxzr4aAk4zseuJuFzbMWYjHHdba4B5ANfHnKprS5lophap6S
	H8FSk35+pG8RR2kd0ZNEUt4j7zCmbaQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783062847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sdwGMcIU09gTpDWPA1KnQIa/TOC4FmKSrATda7zEOCk=;
	b=zOh9LEYgqiM0WnMGqvcrMxVFNVPpZBSa7GrGfGyDvJ0JNo4NRVuj3DppeyojmRNtOVaOeW
	wPxkpRVfVmNePGFkU3+qznKa71iYMkADqOS4gKCzFOnk3EpaVZR69Ie6u4v+Dac5SIIvcd
	eWermhicfeQ0XeJy7O0io0yKSaqcAyA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EfzPfzJh;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9ABFC40841;
	Fri,  3 Jul 2026 07:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E831F000E9;
	Fri,  3 Jul 2026 07:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783062846;
	bh=sdwGMcIU09gTpDWPA1KnQIa/TOC4FmKSrATda7zEOCk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EfzPfzJhrs/DcDGpdZ5+DAFM4EShhoQnzAjIm+qpobG5JJqPx5ypYeTS97Pf2W2fk
	 MXB0HXJDWShx9T+2/TDqN2t+zJCtMpZmwr9fJc95xyVL/zT9V+8EWbmEe7JYPVpeAE
	 xEDQ7jqwROA2mmv5ncKbNAvd0bmh9gPKHREEGYT0PpwyGTS0lSDBFampLZXQLecXtY
	 3nZD2Epl8wq9Kuy33zU+8Z3IIWh4bS2Fqj89ojZw5b2X6o5jhI2YZmH3C6+mvzRoDi
	 CI86CCNjfZO557U7asDOh2CVrUihU+qTWKo8BE198cuD1n5lNVI76Cy1PqIeKYempL
	 YH+0xI8FNxc5A==
Message-ID: <cda9bbdf-5ea6-41d5-8a68-629c2c4ce465@kernel.org>
Date: Fri, 3 Jul 2026 09:13:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/migrate: exclude hugetlb folios from
 MTHP_STAT_NR_ANON accounting
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Barry Song <baohua@kernel.org>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: ljs@kernel.org, willy@infradead.org, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>
References: <20260702172548.37075-1-npache@redhat.com>
 <20260702172548.37075-3-npache@redhat.com>
 <4c67ac7b-e021-4e4c-ae5c-07bfc0fba9c6@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4c67ac7b-e021-4e4c-ae5c-07bfc0fba9c6@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AC235180006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ct3zrnhhwz4s5c9kttaww58b7b6nbo66
X-HE-Tag: 1783062847-167810
X-HE-Meta: U2FsdGVkX1+9t+GMoBia21Nw+XhSuwC2kM53uZ7BeidMikfL1/u3UE8zkHWZdYsgsOJyQ1N4VNHyIMunVNuwSQbsA9HvzwSEPj0hb2X+4AzBElGlXfE8uM8eiw1doyAe2ugGqTse7BsDgk/JH5m98qXYtIavQMb8NzUAYTUfuEHwCh3bUnOboNLWYg5VsJNyK7FUkKSSyEkE2iVetEiHZmCZsWPaOpXJDfeSUp9bEM+2XeN1MWY1UhkXcY9muP6bu1R3qYjLARSbzeSih/CiKwq09KVbIOTaVMTdFUMaK6YjUZZ1qj7PL1+kniNPOB2JPHJQDCB3Zc/At9iu0iPyja83M++vCbVKlJsQ2Fmex1F3fofD6GshIDFcZ+ljwtHu0g3hLmzBStMrk4aNnFPeyCbVoLEZWUzHTc6FlcQW2hOSgSMKa8whMAKdgy5fpc8nwAfbRiqYOAkFH0TCfZBkELMogvz3btSFege0e5CkoEl8qeRFxITbG6DBP5c1oPCy/xExBzSW878egJEHaMfNqYK4bwIDnAOfxBMULJrN4h+Y/fXgZLjBRMcdOzqCWF4AWZkmub8NRJTza9+GeatopC7/wIMKxLknGtNo2uDC8lFCxskm/T+z6QVaX2mlFPn8fN7FV/H/LuRlalSC836ovg1W8d6sXOAI9w4GWkoJLMvdUuN3O07XGsjuEmUYIBGz5yzKiHAN+FBeag6c6waPNGz3992UR99oJFFvO6X9WBddDDqp+bdCpVr/db4aKe7SLLPynpT8lCOixvQS+2RV34fOEpkCDj67chl0jknWShnkKYuEyYY2PO6/OyCgoeapfg7I5M73zFkqBR9gmFdRc6lkIo8C4nWhTn3FIZIYVaXVkq5AZInu561+cw9ZJ0xZhxey09BA4EJ9Fe6huE64I2dEBekC7wgdzwLzL0ErdoyA61zj0yZJSS5U6y+XEc9TjDwCjnSjzFH2OBeH5Q8
 Yf24c4A9
 WIfT2MX9NDhiGViVn4y5FzDgZ2ld2skmUDbjt5/JjDtBR2P1IjlCfU57rRrD5ti8FJ53YfrChVWkqvt8pqylKiyM+M1NieLIyeY0e4GKpa3smCQOMFC2UmvnFkwM8d0nWKfP/H1SZUsWayW4X06BvvllVxSi8xlyxYMxCECIEVz2ISHbv6r+3mA2pmDccHHPOvaGkIn4i/7etjTKXuJ4rj0A5grEw/7c86B6CnrnAZ72iBBOnKMd/1Pft/HusQRUAvcHPdTjGzvTPZldSyjgB+I+Qai24jbf21w2Aef0YJgzO21JAqVGWBzhrsqqjWVITde721BzOXpvDbv9EoUrIg6k4cOh56uN4wVbnL+wV5yM918KYIoD1FmEyV9zz1ywJZXumFp+0T3GC+GY9b1YZVC50FA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>       newfolio->index = folio->index;
>>       newfolio->mapping = folio->mapping;
>> -    if (folio_test_anon(folio) && folio_test_large(folio))
>> +    if (folio_test_anon(folio) && folio_test_large(folio) &&
>> +        !folio_test_hugetlb(folio))
> 
> If the hugetlb folio has a non-NULL mapping (i.e., it's a shared mapping), we
> should migrate it via hugetlbfs_migrate_folio()-
>>migrate_huge_page_move_mapping(). In other words, shared hugetlb mappings
> should not reach this path, so this hugetlb check can be dropped. Or am I
> missing something?

Good point: we should only reach here with anonymous folios that are in the
swapcache. That doesn't apply to hugetlb.

-- 
Cheers,

David

