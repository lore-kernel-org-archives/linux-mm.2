Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49437C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45468E0006; Tue,  5 Aug 2025 10:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1D978E0001; Tue,  5 Aug 2025 10:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A198E0006; Tue,  5 Aug 2025 10:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C617B8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:21:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8739C1142AA
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:21:48 +0000 (UTC)
X-FDA: 83742917496.14.D04F6D4
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf01.hostedemail.com (Postfix) with ESMTP id 06FAD40010
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:21:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754403706; a=rsa-sha256;
	cv=none;
	b=R9oiyI5kgHptZyPE0ybHxqQfN7h5dgALuc3XDv4tMDn3noAPBFnWL/naWyOZRzOiTRg4+B
	NlXNLJDJ7w6ShY1gZdccuOlYJxKM4l5TwLt5LhuN4DYX4leOE0rteXNzU/gSNSycyrfaSy
	Sqp8Ee3SrHm+WT3L5DRnxe6XE3TG9kE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754403706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QKLt0NLFzYo8xXJTkoNZ58Uw/p3yyAalk6DAm/QqCbo=;
	b=noaYntzlDwEiJCcI5+09TgAMEdy1RgXRFIWIpegdd9HzsuER0FCNDwlgXkNshLubq/vwHD
	sLSJyCZ1fiAAUuwljHb51Ekij4V1ji6ccLxE8Uxl4ijZ1V8WIywrHuedPuXBzcddah/1eM
	AwpHnolqoih37h7PZTDrfh0j3XrYars=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bxFvW1PKHztScR;
	Tue,  5 Aug 2025 22:20:39 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id C9BEE140278;
	Tue,  5 Aug 2025 22:21:40 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 5 Aug 2025 22:21:40 +0800
Message-ID: <74c98ca8-724b-4744-b5a7-36101942fcc5@huawei.com>
Date: Tue, 5 Aug 2025 22:21:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] mm: hugetlb: convert to
 prep_account_new_hugetlb_folio()
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@redhat.com>, <linux-mm@kvack.org>
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-3-wangkefeng.wang@huawei.com>
 <aJEZ08orJ3jrBTH1@fedora>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aJEZ08orJ3jrBTH1@fedora>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 06FAD40010
X-Stat-Signature: m6r6sqrdym9tkao7murpkw68q75m5d5r
X-HE-Tag: 1754403705-526571
X-HE-Meta: U2FsdGVkX1/2FTb36eGhRMuq1Q/uA5TEorLkT0+vXzPnd27WZFnuSAWgI3t//JaX11ik5dB9w3MX76+InY2cKHDYcCrEgSEjbCA8D/q+SaQyNM1Qzz2bqHJEkhbCTsgpmTToLOeo378q80xMUiFaLbpQYfaiBdAHLyk7cfr8vZ39cHZFoNbIcjOnjSy1mdR44Z1qS4fKlyJatPiY/MWdz3M34hb1AIXmGEFFgRfY9BaaGNxwhgEp1Ks7m3hUHAWwIYCe4x4kElYK1S4EsYTSvyIPGJcF5N14JwAr373I+TFESGkwfoNcJhVDdQNAWaVJtwmHeXB1ZFD9Q54Y2IQBvkBFcZuEVzan9EN2BpiR7b1bHkckCeY47rWFaIEjfxUFSrJoVD4iXXXjEH6Ann8plXHinQyskUY/aAtaIGhayZ4BJPjoZE4XeB41iGuPuAovT9+pjRpJW7g1VTl5FQD2Dc6ZVQLIv15TABG6QGZhlzuN2bXKYXOiJRWK76t1cBDgVA/j+yqgt5OsMCkw6+7LQYgdVU9yES3qwU/gGjoUDxEQk6TEnZ3n6TbXQ6DUkbMiXBGUqLsejDRC664HHu1CcOn5eS58GAPb+ja/S8NxJ/Uw5uXOf26lbQ3/IAI/vlsVdPBO4+btNEM0EhUhRUqALNgtDJafAojIzQrUC/gRMOjpZtyzo0n20o+GVrTioKYRflv9LhphhFrxcTK3h5ddvqCGmC0S7ds/qM6cRyQ9uoD/KTmsFiSgMH37+raxCMFDRodc/RbL2DVfGm8zEJqGxi8shLcx4yNKVG+J3UCU2x7/pgvIp/wokfkT1R9eGEPFT2K+aY9y3bxFUeYi/MvzygGQD9W7w8U+4B/3FD1KOO9Y0sRfMkEB4t+e1zJEadD01Mk+n1SlU9fLAPDmtcSKiOwGjTOYXXLu3SbIhFAG4OonVFMgbrxTfNDVJZYLxUmJGV6Uwjr3XXG3vf6soAq
 jbViWKkv
 +Akgizu8AOMGFuy5AdxRHYi2fGLlNZgWFTt06uEawVFKpDjUEu5sFiNj/cV+QS8tg7D6k7vFheii5FlPdWKWkWrtIMM6eFB2tgcZoG2Ktg3/MRlKJ7mskOG/6umwSywzFFGXZNC0oA8GG61xs9qYFW0xaG+zvgi4KBABuWeX7QEqz5XZArZJ7uBGeOAgCW1KDJ6BnLSnUHayyKUZen9ljcizdPRjH1AwMbTEG4Ys17p7Aamvdgyed37VSKj7yNXHInp04FY11WXl+bUvahwx72bcdVmJtQf+aiRmgERrtRWYh/o3GnkZFud20QuCJuUGc0A4s3k1yWDnhAuWEDD1FmlHEvTw7x9QnIxRaO+kXsZ0QfPjbjFnlh8ETaYQ3jh1NqEm8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/5 4:36, Vishal Moola (Oracle) wrote:
> On Sat, Aug 02, 2025 at 03:31:02PM +0800, Kefeng Wang wrote:
>> In order to avoid the wrong nid passed into the account, it's better
>> to move folio_nid() into prep_account_new_hugetlb_folio().
> 
> I like the patch, but I think we can rename prep_account_new_huge_page()
> something better. I don't think we need the "prep" part anymore, could
> we go with something like account_new_hugetlb_folio()?

OK, will update in next version.


