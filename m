Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A6A7C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 08:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51DB76B008A; Thu, 30 Jul 2026 04:45:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CDAC6B008C; Thu, 30 Jul 2026 04:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39C1B6B0092; Thu, 30 Jul 2026 04:45:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0AD0F6B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:45:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8358512063C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:45:31 +0000 (UTC)
X-FDA: 85044809262.18.CCCC071
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf03.hostedemail.com (Postfix) with ESMTP id E6FDC20004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:45:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=kOdY4uRR;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785401129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLcQXwTnnn0iFIM9gIERPFamyUUa2bsoWp0iHYmRCW8=;
	b=8RVxhTjwhp8TYTotKtHQuwIkNs93INdTrIFJzYQiGW6CL3q515zyU5MSQ1bZsyNAFyTD+e
	lMAcUovqocIo8NE0+LUewFjeuUIyMUM5HMvwVLCn+Hn3yUaLGwKz7Gez3G6UEUD0UQ9iVB
	gCMHfmICD59ZYXshYfqxMttZ1LyWEN8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=kOdY4uRR;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785401129;
	b=sIUZLka266D8zvfdtaocBm9a+GtpeGP4b2NuEhPWSD+MYz+RDpNnr/0fNoo8QUuFKVjngv
	0AZOVFTcL3uvoIpx+0/45DzLhW8VFldY3b7gRyAoPdvBIS2MOoZ1yO+BcIl7BfipwJV7Wm
	P8Kxu3KxbJ3DN10wCcC43s1QDb67muI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nLcQXwTnnn0iFIM9gIERPFamyUUa2bsoWp0iHYmRCW8=;
	b=kOdY4uRRvDlabYess5TZ7yu/oTjrBnvoK3+k+6v8BWULoPDPFfFmWBca9bcsM4nIGXmyAQxZU
	dNswgt5evN91g7MTVatZJxbKAneeIT8Ezjy2y5JZkgGBlPbo8D6rSNVzSuEkwlaCOJJ5KHcoDb4
	ZDD2gofeh59MBQRv30zS4II=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4h9jG24VXyz1cyV9;
	Thu, 30 Jul 2026 16:35:54 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id CAFD240572;
	Thu, 30 Jul 2026 16:45:20 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Jul 2026 16:45:20 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Jul 2026 16:45:19 +0800
Subject: Re: [PATCH v7 01/13] memory-failure: Fix hardware poison check in
 unpoison_memory() again
To: Matthew Wilcox <willy@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Jane Chu <jane.chu@oracle.com>,
	<linux-mm@kvack.org>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
	<osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	<linux-fsdevel@vger.kernel.org>, Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>, <stable@vger.kernel.org>, Gregory Price
	<gourry@gourry.net>
References: <20260728204409.3396238-1-willy@infradead.org>
 <20260728204409.3396238-2-willy@infradead.org>
 <amlKHkemYQBxFESG@gourry-fedora-PF4VCD3F>
 <amlav1zfVy-9fLw5@casper.infradead.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <ccce5d73-b5d8-3e23-8e49-bb154af023d4@huawei.com>
Date: Thu, 30 Jul 2026 16:45:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <amlav1zfVy-9fLw5@casper.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E6FDC20004
X-Rspam-User: 
X-Stat-Signature: 9hcgwr5t4f6j7r6b69oij5jrdprsa9ad
X-HE-Tag: 1785401127-62433
X-HE-Meta: U2FsdGVkX18N9+5+2RoiUluy0Y9p/HCjFZERjhaETClTPe2K4H+ZzmrueXJQy+uD8BctWig45a7AhepbK4uzzsyZHEvtUOVzCI8L/gHmOfpIeVQo3pwclStZ7w+wAyN3NxhuPuU+NYaDatoVm+XOcIlp7V4Fv5I3FCx2tAgM214BWCmTNayM2lr5C/Iw1INTMIwi93Xe5m42tg2jEbAjhqRHtLlJ6sI46UUp9AyhziRU04Ke71ogwonbZ9nbE9Ph1dYOxPCUPjcPi8lVE05CIMyAJZK9AVIpnM+QCQ8iXExi5UoPVm4JUqtn86cVXVFOBUlbTjlceVIMrW0Nv5v9AV4RtCK5jZeXaAwyc9kvM7SidKvQDFNezbD80MJoRhc1Do37iLESFazlGXH+9rcdNZz3eBsZNmNnu20V+rMH2VXhZBCRmgIDYuMNJ9GiHW4jVVvRSBIXaiD2GqeernSDDobaGhlRMzP0ZYKIf+z8Y4bsjCDr4CKG4c64/oIxfHAjfiWvxt1jT9zvLfW8A4xsJHFCr9QCwluIarI6+paYVNLWLdHlViAu+m93Y01iN/9tz7xAhuiUnAvRvkhehyNrWipz+POpoV0k5VJ33JJXTK2sNQ5WXy/EGEbMYLO1vXWt4w6xXxRuVIPnx6S7fXfRNWnf7yRVynzjViRD/tUl7S4hCVta0blLx7jDxH4G4/DNnwZ1uBw+teS6yyjxTEx7Pqus1YhQ3IoXxAhDPCMja4kKCTLgH/XVdalRrLPC9nJeAOoNOEEx/Wc/ZbR0iGqiKontXn1qOJn4/xmnb/95cXrOr6bPLS6yLBVH0jC3uukfYdVg0ffV6w5BClVJEeTfH3kXEUZqSQFIXfIOVxPuWJLlf3K4M6fFuCGZyoW7hSgmvqyhPgjwUIAC/cxtuLyghdniLoRwXEBPdPuopTCtnTQKanG66uWdRNFDMkhNUmvjvIwXlGCKuNPHiDhvLbq
 nliXvI9S
 SqIgnDvBHC3IcBY2PyTotU9FA6NJtNLGWmMw71fAzisXCYmuO7PHKiY6Svm3lH1iNqp236MGnToFBCvlBl2h2iHvU/yWRnbfTjcKPlTbexb6w5USh3SkwcVJqYMLuIrOTJDGzK7o7tl94Ps9AbobYJGnxBHDH6qw6k3gO0lkqMdC2ak0cHANijXDHh1eOlegUZJASbCZB3/7Z+TufezlB1sUKxVJqFZth+ZPG6YZMCWEowy7PbrYxkn1AGceR8RJE742jH4XoZcV4c5khbVsPWzj1J/wUWjdqo6GunRF261Caj3MhCaiDS/Xd4QDM6PrmkCvFiup4pt6ttojeDxTxnn0Kdul0EHI+O3rRCKqwgHaWaYcnLTtzD+XuwSm1fcgqEYoIfZjgypnthGpTiXDPua7oNtOIt5CxzMynL9+PHN/P32TMV9YBSyvhzYE5WMkUPvMTkqcPhs6YRBLWBYpSCFihQAoEYRpXps0yOT84YrFSiCpWs2lDHL97LqH7XH2xG7o4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/29 9:43, Matthew Wilcox wrote:
> On Tue, Jul 28, 2026 at 08:39:29PM -0400, Gregory Price wrote:
>> On Tue, Jul 28, 2026 at 09:43:53PM +0100, Matthew Wilcox (Oracle) wrote:
>>> The earlier patch (6c54312f9689) that attempted to fix unpoison_memory()
>>> was incorrect for hugetlb folios.  Before a6fddef49eef, we checked
>>> the head page for poison (which was correct for hugetlb and incorrect
>>> for THP).  We are currently incapable of unpoisoning pages (other than
>>> the first page) in a hugetlb folio.
>>>
>>> Use is_page_hwpoison() which handles hugetlb pages sufficiently well for
>>> this purpose.  This is racy as we don't have a reference on the folio at
>>> this point, but fixing that properly requires deeper surgery and this
>>> is a CAP_SYS_ADMIN path only so this will do for the moment and can be
>>> easily backported.  It's no worse than the situation before a6fddef49eef.
>>>
>>> The other bug in a6fddef49eef is that we currently clear the HWPoison
>>> flag on the precise page, which is wrong for hugetlb.  Fix that too.
>>>
>>> Fixes: a6fddef49eef ("mm/memory-failure: convert unpoison_memory() to folios")
>>> Cc: stable@vger.kernel.org
>>> Cc: Miaohe Lin <linmiaohe@huawei.com>
>>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>>
>> Just trying to wrap my head around the state before/after, assuming
>> the following is correct then LGTM:
>>
>> prior:
>>    pfn_to_online_page(pfn) -> p = precise page
>>    PageHWPoison(page)      -> checks precise page. Poison for hugetlb
>>                               is only set only on the head, so bug.
>> after:
>>    is_page_hwpoison(page)  -> checks precise page AND head (if hugetlb)
>>    p = folio->page         -> now TestClearPageHWPoison() explicitly
>>                               clears the head page poison if hugetlb
> 
> Exactly.  That was how it worked before a6fddef49eef; it used to do
> p = compound_head(p) (which wasn't great _either_ but had different
> problems ...)
> 
> The careful reader will observe that injecting two memory failures
> into the same hugetlb causes ... problems.  That's true before and after

Could you elaborate on what problems this might cause? IIUC, second memory
failure on the same hugetlb folio will make try_memory_failure_hugetlb() return
-EHWPOISON without holding another refcnt. Raw error pages will be added to
raw_hwp_page list. Then in unpoison_memory(), raw_hwp_page list will be cleaned
and extra refcnt held by memory_failure will be released and PageHWPoison will be
cleared. So it looks work to me. Or am I miss something?

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.


