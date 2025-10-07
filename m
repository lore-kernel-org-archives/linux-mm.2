Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDE3CCCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 04:06:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E201F8E000E; Tue,  7 Oct 2025 00:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1158E000C; Tue,  7 Oct 2025 00:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0E148E000E; Tue,  7 Oct 2025 00:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C13908E000C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 00:06:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54EEE5B661
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 04:06:50 +0000 (UTC)
X-FDA: 83969982180.14.519BEFC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9548D10000A
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 04:06:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759810008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2dc70FQQzaYeT+DVMhuBs4JWfZHcl3DmfS+VKnuEPeY=;
	b=GltDqBqW3AGU6fVkn9EHsTjljvuGp99NNhRSaDL/XxHVrSr9g7Pa7HDjQ7U1yGnohSS0TH
	Wkq7Q0b+TFbnfSopQm59o7f42yHJdliTw1Uc8I2QQZ5SLzwIvdPBoeOOatPRHZfy3R9SGg
	gkf7usC27fRTO4Xvanx2YnAJtwWBtD0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759810008; a=rsa-sha256;
	cv=none;
	b=TVx+tvl0/sV0bsjhVY0s3xlxTjMUYwR4Pj/hzzDDr1WvAQYWyjzW5lY1A2nazhg4wtskIN
	4Dip5tzhGEW9kIQKIHxvNgbkMd/vYOykV/xMVtM+jAWq2XkgGrh1hDQvhI4/37Yr2MXh/z
	tQcQAJxX2cI3dhztWCXQKG5PvrlXd1s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7064F14BF;
	Mon,  6 Oct 2025 21:06:39 -0700 (PDT)
Received: from [10.164.18.47] (unknown [10.164.18.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 533733F59E;
	Mon,  6 Oct 2025 21:06:43 -0700 (PDT)
Message-ID: <ed17533d-912c-46a1-8407-29fd989f22b3@arm.com>
Date: Tue, 7 Oct 2025 09:36:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/khugepaged: unify pmd folio installation with
 map_anon_folio_pmd()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev
Cc: linux-mm@kvack.org, Usama Arif <usamaarif642@gmail.com>,
 Matthew Wilcox <willy@infradead.org>
References: <20251007005022.24413-1-richard.weiyang@gmail.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251007005022.24413-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9548D10000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8nesoy7xihxhb6azgozaqmywc6its65x
X-HE-Tag: 1759810008-311275
X-HE-Meta: U2FsdGVkX19DrSgsET73bRjCPIn4RCIGHyYPSkM1ZFakyld6ccoeFRPvJw5ORvbV6HAAjjEldX5q8LgeijknRnUJbI3Hr6cCyM3Qavy23ftssdue+ff1eZfZJMrGRlRQ9LfzM6NGrNVPnnyZGs3H2SPOVMP9qVHFiqg0RkFNapaopltvUREaO2lE/oMZFOqrUft+V1TDibkQBLVGqoHqlENSQp2aNnk6xpOl+aU6MSMHLYjZHLhFEMb1w1Z2STOX+AFLwg27cIG7zAFTrzVd/VsjkM+1akUunnIAPIMNCtDCI499afObufVpdULPMWqlw9/81ODhcl7lQGbuzzEPDbv7g0imCGpq9UZsVvABb4/gkWpw3jlHloRV5P9aIeYwQVICJRQ4IqHHvQbDg1LWMTJzzaW+yE0bjoJFoHYBuD/IuV18cN4v71lLeGVnM2ZJi+UYEOvavfwUA9iOHroXHcKnsJyf9sQHweeEexLd6jnh32d1OHiEc63xwZ1LZXZt+5sEhaktDONZQWL1plTcg9NfH5NAamuksfsz/nNqCBr8XEnBeAXHm7nbphI33AJUn12LBahWLIcKrTtiU0LYwh5cc+h88Yw9+Jn0ft1FKBjmCgoQpvtsJXWsY2ubseFyrgLfH+uyxcZlG+MQIN59OLX7Z5Pr+FbnvrvKMMtBOGVY0bEhRXstYe6p7qaGqjakjDzrFkjA59PjBdQUOT1b3st1dRAIFQ8jOgUcLXkhvY35z9BKuRlsySNVXFcZIDE8yq/oWH1CWXxY2trx2Z+Xwt1IbfabGFn7ubKn1u167cbUicxWA7KV9FdrLkZRPQG2qUsUA6eJtfmaw0XOsNOMFjTqdTiEx1e2pLBxKL0d/XfXFLDm2SHQbsKSFPpaIiAHPq28Bw/40tNTV2nUTL075qfrMP6QZVKITyk6hC57PdLgyV1dJ/Y9bGwdRrwhnjCg0vbLN9ek8a8O2ArlB+K
 1dS/x4x/
 FgabJ0sqrjOGO83hMSwvTpnArHt3kRZw5E1BXSCu6D8aAgAnE7+AE0e0VQvkiTy4+GMqpXzQm8bYBhMwp+lTueLd8x0uzcSTwjuGek/+RWiwimu9J3UuWIk8bR7jCGvlgqrTL9VK73MebTPFd7NwsJtn/lqMLhMfzjLHZ8FlTt3USXYr19cjzOnqzqXHOwlhDwa9kZ/JJgXCmY47k4KVnCoCkQMdyl54znmvMaOEwx7xtgm3ozOo4j35FB4yPoQWixg1cxZGICWhMWkm48ih8hYpnAf5Ea9cBIQeXk/AvlieZDo6vjmZDlVThOn1o978HdGqhvI5RxMJ0S4gia05G+BVPl2h772mvx+n9da2Pb1b/MOZTdjA2GBni65N/PYlH2fFwC2Qj6gXm6H4/nxd0U0rrGCqltC3/GhD77e+sSKXHdOsEvLHkeA/FO49UB3w55r/K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/10/25 6:20 AM, Wei Yang wrote:
> Currently we install pmd folio with map_anon_folio_pmd() in
> __do_huge_pmd_anonymous_page() and do_huge_zero_wp_pmd(). While in
> collapse_huge_page(), it is done with identical code except statistics
> adjustment.
> 
> Unify the process with map_anon_folio_pmd() to install pmd folio. Split
> it to map_anon_folio_pmd_pf() and map_anon_folio_pmd_nopf() to be used
> in page fault or not respectively.
> 
> No functional change is intended.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> 
> ---
> v2:
>   * split to map_anon_folio_pmd_[no]pf() suggested by Matthew

On which branch this patch applies against ?


