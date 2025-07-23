Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ABBDC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 03:40:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95D8D6B0088; Tue, 22 Jul 2025 23:40:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90E136B0089; Tue, 22 Jul 2025 23:40:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823B16B008A; Tue, 22 Jul 2025 23:40:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC916B0088
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 23:40:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E64E11DB000
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:40:42 +0000 (UTC)
X-FDA: 83694127524.07.4AD852C
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf19.hostedemail.com (Postfix) with ESMTP id D0E0A1A0004
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:40:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=j+OzK77G;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753242041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jf6FIqfTcFlhEp/DPUJUJMRfNEyNlTHHmVvqed14Bjg=;
	b=YMSRFTKM74o8mdBsPcVEPWZWBluNMrsXGVNeDtWQ6Jy3oEbkhZwVtcY3V+YnOox6fZEToi
	pYKZY/00d08OSaVnes3gauKEXfpG6EO4OPFU0zbIEoxbYYqcgxL9o5qcKbXyaTn57k/EId
	+OoHpKWvTfafBNqfiTOoxiFo3uI1SFE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753242041; a=rsa-sha256;
	cv=none;
	b=mrSDxGWZQEJwOKInDmhzyzVQAh+D6c1FPLbu0ubbUhtodhv018X27JRb6wi4dD2ywVyrgm
	ZZ8mIRWOWpRXZBqAOeGLckC3kzHesra81dXhvA2RnOBeIY3bza4LgR29exxr9iaHRAYjOk
	rzndJWOUC7aIirdtjYrx3mCBBGrzbCE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=j+OzK77G;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753242036; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Jf6FIqfTcFlhEp/DPUJUJMRfNEyNlTHHmVvqed14Bjg=;
	b=j+OzK77G2e8Md4G/UgaOifb3Pt88JPrs+axE0ATLCvcotl7AH0Y8t8yw19nAi6hXQMHx25T7e+Oz8Uoz3kxlwQJExy+7chsEhrJ3WdptcrhCZWDy5+eLfu1qbMv0vFuw2HJpjRPkkVRNQ8ZLDShKyFYNP2+f+gO2cy08R6aMQsY=
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WjZl3P._1753242034 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Jul 2025 11:40:35 +0800
Message-ID: <7387c4f3-d495-4f31-8222-27a782844473@linux.alibaba.com>
Date: Wed, 23 Jul 2025 11:40:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] khugepaged: Optimize
 __collapse_huge_page_copy_succeeded() by PTE batching
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, david@redhat.com
Cc: ziy@nvidia.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250722150559.96465-1-dev.jain@arm.com>
 <20250722150559.96465-3-dev.jain@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250722150559.96465-3-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n1bkgskbsases9hgo9ps343ap7gbagu7
X-Rspamd-Queue-Id: D0E0A1A0004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753242039-895506
X-HE-Meta: U2FsdGVkX19eacz0yG1CxJtDz5DoVBZTUB+8794Rtsd2hAJG/+IgJ/wi/a8f+0owKsK9pPKBz5C8J6ORyLdB+abd/rnvoQ3VFHaGvA6t4k/ygFmzpdP2xsiKhbzlVpS6JWQ30dLlLYekKBtTZu9wjSG0cQ+UX6y4dMSc9lJB86E3hF7Pne6u+d14u5sY4nm9zn1ZCzD0yPptjbl2y377VxKC9PWCb8pKr3EerpvoZw8XM13hJ9YP8p4Xaugdk85vtUOZV0Q7q35p32Rh1jWdspdWF4XTm4gD96QtpETp3KWsZ8kZPW0mLslZixYLvAf8uHp/kgfav5rW/+an8ckgFwjygbbLWLul9pDBoUXAFG8CWRVco6GRFwSIV/wVOhS3N7yw6MUUw3m0aBF2epd+bxsE1xujoGtwZ/AlZnKrr5LYV7cYzQp36F2KjfqJ+sNAQdZ5R78aFAoVWVcYd1/cOJGI89qwzoxaWZ0pbdm07HunyOcY82GwDnwLq1vQhnNXXZO4FMWKt/WRV5mr4iggVlvTJDtBjd4a/eCxzshDjGW4KsTHH9ISGP4TRsd3QJF8Y03DtjIgnqnup1gy7kewnUSCNMu+V6HGcu/dMhe7+6lYyITcwma40KxFtVwp3jJGVaJQVZZm16EZgLIGygwj9n6I9ekNppShA+QVkzZRsAwUtdqdTGNhUgyA1xzUUiGTdrKIYMYVSujbg/PK40WF9J4KvfHU2RyUNXzT4ccB1xLCAOC3yEDMQDPYUlduy3YZrANshlvq32w9+GZHd32KkYVDTcOwtPZzQ7JteIPUZP3+3ySmAO1yTI3g98erjQ0XxPZkB3Gw062qeFt6rQfZTfld6Rne+zQTf22KtHj7s8CamJu8V52tqxANjePLrnlHe6Gz0NlcGKtITK2ojd2jzjqo5fJjc/ao5ijg8VD8fjSAaCrXAHa8mP3xL/W9fS7Mlkr0kvQ9fg9BjSUiEPw
 LvqQDUvl
 Py93dpmK8HYQwNkaBy5xaNQjnIZswPncXaqb0ySEwQCB9h0wsYu9c+TgFHz6qzfEBkQI3mzVX0KlpR2A/6craDR4quQwdnPzJ+KBZFfqC5uZ/lIZJEr9b3O1cz5h27CzngcbJR0C0gqwNCUJdtyVFjUPEXIitUIxgGTf7qLTOLWHquG+p5AiPQ38X8IsCAevpQZ0BvLGqRjSXLiwQ80e6o3+jENb4tXY+cQdT4thAsN/Bmu7Fqct+aAl+Sc7aA/bHOqD3Jd24j9pxkxUA+2gOJ8f1RniKb/30lvFeYpXT0f19iFEWHAIPqWaBxb+aaraNuojy9RaIQ0MluJU+Bres33CLg9LTAgIhLqis2YjZCC0dHgu1//vaMyk2TEf5/0PTVS6km3SE9FLM78qkoMEooSoQZH1racw9fd2d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/7/22 23:05, Dev Jain wrote:
> Use PTE batching to optimize __collapse_huge_page_copy_succeeded().
> 
> On arm64, suppose khugepaged is scanning a pte-mapped 2MB THP for collapse.
> Then, calling ptep_clear() for every pte will cause a TLB flush for every
> contpte block. Instead, clear_ptes() does a contpte_try_unfold_partial()
> which will flush the TLB only for the (if any) starting and ending contpte
> block, if they partially overlap with the range khugepaged is looking at.
> 
> For all arches, there should be a benefit due to batching atomic operations
> on mapcounts due to folio_remove_rmap_ptes() and saving some calls.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>

With David's comments addressed, LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

