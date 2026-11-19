Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F353B60A260E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 09:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Ah8BCvTV
Received: by kanga.kvack.org (Postfix)
	id 2CB2B6B05E4; Thu, 19 Nov 2026 04:12:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1866B05E5; Thu, 19 Nov 2026 04:12:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B7BA6B05E6; Thu, 19 Nov 2026 04:12:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F39076B05E4
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:12:29 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B51B1A09DA
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:12:29 +0000 (UTC)
X-FDA: 85451302818.03.CDD7CFD
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0FD49180007
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:12:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Ah8BCvTV;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795079547;
	b=uc+RECtKRoyS2Aj2j8D6/hM/ePSrgTOjRxDDybj831oVA7VVXa8sp7T462EbglgiCH6Xfg
	LOuh+X4iIgwNB7ti4DDbH8D1jm+DQQUNwf1bo9HRUa7mOH47PsjDCkyEJ7aI4PbihahG9K
	jX5qXDywFFbmtaC/utq+WC2ULnuRRlg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795079547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DQVUIfTjyV/zT6b5LnIlqNRkGkCMXg+vDOe4jFDkTfQ=;
	b=BueaELKhAAQY+Szqngb/Z4LWdpReAdH68KZw0CdEbQm6LbZNyjsdi10lKSBhuQ2cv8+5i4
	LerSYusb6bQ3ThNZEsDnVSGUlUuOf05WXEkzLKSk39cFZkfbg+j2t1gDQHZ3u+CVuqcjt7
	RDhYmPsMktwszK5oqw/Osg5U+vSgOfU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Ah8BCvTV;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DQVUIfTjyV/zT6b5LnIlqNRkGkCMXg+vDOe4jFDkTfQ=;
	b=Ah8BCvTVxFkBn+99vLEoi0NpQx2/6dH81cRbEnu/aS90eDjGXolCY/aMRA7VR+/YSiSuJynZM
	Bhx4RJwa/C6gLhdwmIyLlIM155bn0IiOfduwnJt/t79fd9gSfYiOdtlm8QR9WT2udmKqDMo0pPb
	NR/F0XhKSxmB53/K1r+9j+Y=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4jVXlG1Wc4znTbG;
	Thu, 19 Nov 2026 17:11:22 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id B73B34057C;
	Thu, 19 Nov 2026 17:12:14 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 19 Nov 2026 17:12:13 +0800
Subject: Re: [PATCH v3 1/3] mm/hugetlb_vmemmap: fix HWPoison state races
 during optimization
To: Muchun Song <songmuchun@bytedance.com>
CC: Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Joao Martins <joao.m.martins@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>,
	Sashiko <sashiko-bot@kernel.org>, Jiaqi Yan <jiaqiyan@google.com>, "Jose A .
 Perez de Azpillaga" <azpijr@gmail.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>
References: <20261114112523.75208-1-songmuchun@bytedance.com>
 <20261114112523.75208-2-songmuchun@bytedance.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <4970cb14-6f75-a63c-7f7b-67470a770b22@huawei.com>
Date: Thu, 19 Nov 2026 17:12:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261114112523.75208-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Stat-Signature: d7a8xd7ib3of8udbtyc3oy5psbq5tcfr
X-Rspam-User:
X-Rspamd-Queue-Id: 0FD49180007
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795079545-442296
X-HE-Meta: U2FsdGVkX18kdFHgBfIYSMFu8+RlmctgKRjDMSKn3vKnkJCEJHYtBIUyhWjGGYbfTfLQ5foTwem/DsqOTxHuToUJF3UpelA7LqwdWiG3e9Y+y6JLiwtJ84lKUgaQL7HoDnKO3h2JRMgElmVwfaZtI+6dQWT8G7AbfsveLShtcD2k4eKqX6DvOKCmYga3joskXia1rrE5G1gO9yvIUzmjL0P/abEvx2r6oitxNynmiNWC9ou2qaHsus/auUNp8tsebL8S/eVBGIoTJ8LJiyE6ukGh0MV+UBnumwrFklV8QuMzuQ9xwTYfFc51WBhbfiL7jT8Hrsy5noxDCCMefvXWHASGFccRyJ9VotvQeri31y2UgC49kP4ALCdzg0GU+vkqparB5NxE1EsAZEddjFCnjUI14ycanqbzmm477yyQtYmTgc0Kos335sPZTbscIHB5HGxt7U+23eLt92DIsMyTOopbPUxhrwu0U3M9gkM6ScZeS7M87tylHav5jF4V4lUf4FhMrf7WhQd3+xuZ9ER0dnIiYWkH+ND9uPKl5yyFZDBL6b5FIPlx2ZU5xrX4f5tsm4VtGhE2XJvsBM/5R3XoVE6reOGt4Ftt/Za0HrMrkKmfDClFK+dlqnKafZK4PYoewihcNxky6u2yPspbDES4PgSlRYV/b3TTlt5O5PV085haFCkhBAzqn7GgJ5YLWiI4ZuqSoOMGaV3hOIKyTV0E/YNqRpnPpqjd0uk1tukuZGbGVHveJbtmozehLiE26SFQYRK5LNOhqsAK4yfUDoZzttCUx9xutv6MUIdNfxepe//wq/5kdHqxT1mtENH4c5nIdIrxtbhUJh/TQhcLJm4+JH6mDbbiT8vVNzsT4SX/7HRjdTiG4qeg10eYNluzXYSLfpbQf+3CoogEQ63i6b9Xqj1LO3vT1jXXg6deSEnFCKO4Edd1oTE7Ds7yinmuAciooS+hyJdNMYTMk46YxbO
 V++FWNYO
 29pNnHmhWI6HydBdJ0EabxZsHAda7QUmaAxFTWInIP5cCxdXdX6GnBzsuzlElWTo1LHNShuv+hufCUDG/Oscm1syzZqFmP0PuRJH9P/p7mfCV8FVuIHmTFzWey8JmHPAPQj+sDcgQVc1WVwWKKfMiid85UWnLzm4TrrwcCclvMRieByK5tHpP0BIH3d8I/ks9wpMdPZI56cG+7eu2ggI36XGqB2J29t3pNrmI0a2g3Gd4gkxKiVEIXWjycjNAR74e58A42lbarwVYnj1SYIt+hRPRudBGwDYku4SfB7gW4emQFiYJstzlg7Gfvwk6zYU1GTokAPEf2BdNpK44JNWh9yr8bjP1R1pXFCSGN7qrzRfaZ4xd4zaJ9SxMMfPqOBeiVfZwTdYiNqw7n5x5ksgf0hqLaJyIW7LAaRZGnT/OeCqnLayP4js798bFNWvf1Cmu3g4uSVeS0bpauR1Ss4is6PSJlXqKXqURtK6ectxkF3HjuT9fKivhwIt/JNP9rC1BD735c2vTnsjsxIZZT0MY+GuLB96kALWrmJzArN51kfiX0c9X4lFWfEvA/wLH3yP2abKjCfGPvPDfn7PJ7fb0ATEyJoGrfmL6bRyl/K9QpuGLFwLC17g1mhcj1TlhaBZc11ulCsWMR9Yw6pX38OSMX0AOUOO+QIslbSsk8xitJ7fvl4LAWKg6GzhZ36M5/4zI9RLUHkhyYoVoEjlCCVfCg8kB1bOX+6Sc3hME
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/14 19:25, Muchun Song wrote:
> HVO copies the vmemmap head page before remapping it to a newly allocated
> backing page. Memory failure can update the old head page after the copy
> but before the remap's TLB invalidation completes:
> 
> CPU 0                            CPU 1
> init_new_hugetlb_folio()
> __hugetlb_vmemmap_optimize_folio()
>   vmemmap_optimize_pte()
>     copy_page(old_head, new_head)
>                                  try_memory_failure_hugetlb()
>                                    get_huge_page_for_hwpoison()
>                                      hugetlb_update_hwpoison(old_head)
>   set_pte_at(..., new_head)
>   flush_tlb_all()
> free_vmemmap_page_list(old_head)
> 
> The raw_hwp_page linked to the old head is then leaked and the folio's
> HWPoison state is lost when the obsolete backing page is freed, allowing
> the poisoned huge page to be allocated later.
> 
> Unpoisoning has a similar race: unpoison_memory() can free the
> raw_hwp_page and clear PG_hwpoison from the old head after it is copied,
> leaving the new head with stale HWPoison state and a freed pointer.
> 
> Serialize HVO remapping against HWPoison updates and removal. This
> ensures that an update is either copied to the new vmemmap head page or
> applied after HVO installs the new mapping and completes the TLB flush,
> and prevents unpoisoning from modifying the old head while HVO installs
> its replacement.
> 
> Fixes: 11aad2631bf7 ("mm/hugetlb_vmemmap: remap head page to newly allocated page")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/bug/linux-18e93f17-529b-4d84-ba44-a41829f4be64
> Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

