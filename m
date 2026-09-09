Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE028C79FAA
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 07:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F01D96B0093; Wed,  9 Sep 2026 03:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E89876B0095; Wed,  9 Sep 2026 03:43:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D52746B0096; Wed,  9 Sep 2026 03:43:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA6A46B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:43:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28397C012E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:43:10 +0000 (UTC)
X-FDA: 85193432940.01.7534EEE
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf21.hostedemail.com (Postfix) with ESMTP id 125561C0007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:43:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TUQpKDe0;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788939788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOgvdKpRTZOCys2xyo5CegR4febhPvynV69GyvBCGg8=;
	b=iJv1DSLt2mhHyBjE/bN1+74siwJlrFYFhyoT4efvBuVqN9zPc0mJ/vRf5sQgGZ9BQLWYVO
	VzI074qdpFC/UEWn2L6zT44yPFUWzr/UM4ItEJHH9XW2AV25KzPk/2aI3vA2+1tTZIHic/
	cfwXCnZSdz+veI8F1bG4imRtHbra/lc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TUQpKDe0;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788939788;
	b=L85W12uHrDqywt0wxMC7OB9JP4cg/9itxcJYf/56+WPneDg5FXezNTWQnEmrouBBPTGQBG
	3u+wOFgPQQKTl1ZCtJTRpYOMW7kT4DdCHKgYoSFHLY/dN6fFP+F/q/9bfxyNxc1aKoguRc
	9REjqBSHYG5dY/IVGtIe5jlOPycea/k=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788939782; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GOgvdKpRTZOCys2xyo5CegR4febhPvynV69GyvBCGg8=;
	b=TUQpKDe0rmt2JFNHEBPA8+lxHrr0A0NDPBDOnFnb1j8Ayj4NdAlE4+1xQzQ9btDWBiay6jeuLdpT5jPTfKpa1TR58Zermwag0KvESNAU5NDDtmWmfMK4CyCbn/55xM1kWnVj71th1wVCgA+iCFFwbSpwpItexB6cm5E1WN8DDNI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XAeJlun_1788939778;
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAeJlun_1788939778 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 09 Sep 2026 15:42:59 +0800
Message-ID: <d78db281-ba00-42ea-9ecd-6d36f77cd4a5@linux.alibaba.com>
Date: Wed, 9 Sep 2026 15:42:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/19] selftests/mm: raise the khugepaged test-case cap
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, rppt@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev,
 nico.pache@linux.dev, ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, agordeev@linux.ibm.com, jgg@ziepe.ca, leon@kernel.org,
 kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-2-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260908125105.1510704-2-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 125561C0007
X-Stat-Signature: opfj819ej3qub5phdtqgdozp5aydyhr3
X-Rspam-User: 
X-HE-Tag: 1788939785-242711
X-HE-Meta: U2FsdGVkX18od7zhCKVxB357NnktILBtY/IGXJS2Q8laa59HzplPmX1oPYuNrUKRXcKVHql4eseOoPwXqopeK0bnt3wQsqkL7Jg9CKJ6g8559y6DPXa3KnNl/lJOX5Sscr+e7B8aW/+lF3Y6Pl5lIwToPtsIsyNwXO6o+4N2pRCEVzQ51pDESKiO03SxxQ7OfmZsB9cXJ7S19UG2eS8X+fFGMDsHp5cxXu3HMk17qi/ByTL4Y+Kho3p2o2kdM3li2q+rjeeJRWtgawTUeBMdLXfJUcxBWeEYANiZRcsG/qGptoYBRkNHBlzwsSEDKAZOmZIg0zt3WtbeDYs5JEZOtJYGdhGYTLIY5JZB3U+UJPBBc6nPj8SQ94dOwlPq8evWnq0rN6iYd7/PLFQDCoz3yFi+UHdaabGi0WUMrjMVCJ3NuHHn2VcXiLXabXMA78/dDVzRrrdbaBKskDDqMX4cQpLdKELra3hqqLKBcQ/ih5xU90jQrCA+p/9MREGC2XZndCL9/oHOevn7OiklvA9tbrqnHHOCMLOl3qBTnfrHM9dSAajM57q4eAIIEC7cjk2Sn2yu6tYKoZbe8J1nrC0spi66RYDu5nNwh53/m+lzQMntfnRKsgqz/hjkOFfBVe2wMWBFwnZ4VAYDy1gEmV1T7u8DKMWQc7CFNunUHXl2sxdivDraJcgHb0EL+9rsCTJSMMiLqQs3HBogvJX+uTqiWNSGsk3G4PaWgOkbedL+iiAJXOIcQN0gxop5eSk0E4y9b7nf31V94H4mueESk8cZu73wYTxrovSb/ExYouXJGdYR9qnKUQHKHV+DPmibnXS8HAWq10CuZWzcWoAlJRNUl4pO1pb7/dNxUxjEtPNrKCqcovesUBjIdMDj41Om9e/rOpGGOCghKdi4FR6oZsG2GeD0geG9sv0aPB+vtlJJCwQRF30VvechbMh2DVkz/Y3jZDDV3JW7RMUCG3WIPkm
 mzi2Otnj
 kOdMItRKPW3BtkIYDsLwp3IcMMrmECJN3PCTkIzt9FHToim5s3Kx6aqc8kcQVxkdBubpqTuzpbnQTzDCWUhKccGhv22anyPewSdLmN4KAI3ADDjVkK4LhZK0Igqz/eoBPwv5a2IvnBHnmHYdA/8vX8wwuCq4Wucr2C41DUW2906+HG9kh3yIGVtOyq16FWEVCtKK3tbN3dBq5O4tjZVoCRspb1RRXAu14wXLhJiQr2X8BxY+7E/0k6FFj62cPsT45H+BK4xnqR/WLWSgLWy4ub4VmoAHbLZlHPVCaNuLETLi2kZJyPeh6xcMWqa9MP5NOWxKAFP67zw+hlxc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> TEST() ends the run with "MAX_TEST_CASES is too small" when the table
> fills, and the table holds 64.  A full invocation already registers 63, so
> the next case added anywhere aborts the whole suite before a single test
> runs.
> 
> Raise the cap to 256.  The table is a static array of small structs, so the
> room costs nothing worth counting.
> 
> Assisted-by: LLM
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

