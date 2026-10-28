Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D0D5606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 02:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=G2rf5+X7
Received: by kanga.kvack.org (Postfix)
	id 9F08F6B0945; Tue, 27 Oct 2026 22:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97A6B6B0947; Tue, 27 Oct 2026 22:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 841D26B0948; Tue, 27 Oct 2026 22:19:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62A9A6B0945
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:19:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C463940B41
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:19:19 +0000 (UTC)
X-FDA: 85370428038.04.E49C9D9
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6C22F180003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:19:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=G2rf5+X7;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793153958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I4S1rdiwU6IQT/YUtWpzMqdCXUjRwC7w0Jq5xGo329U=;
	b=W/0JqidlrGuCflDFIsImAM5eLGJ4Ddsq6Q8zL256Y9U2/LuScZqjQRHV8q2gemw0QLKAEJ
	ovkOQen1LcTsvb13ZyP6qqgNePQMKXQfeA5184uAqfV1UYu9tXHnJpII/F65igxbUjnkG3
	QQqY8gIJyn31fd9p1pO62T8DYkAAohk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=G2rf5+X7;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793153958;
	b=Az5VyIcaTYphSATYfJ837EEgjj6zW/HsnmE8dn8SFOaoSyzQEDQj5L5MCRqLGmFNUM4K+/
	rbQ0CWsY839YtYOvmlCILv4jFBVeBiSBcANQPQc/l1p33yrwvbZLmzewncibM4xMcxssAK
	CxcqQYAXg9GifB8S5MSmaR8OWXJMM9c=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793153952; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=I4S1rdiwU6IQT/YUtWpzMqdCXUjRwC7w0Jq5xGo329U=;
	b=G2rf5+X7pIKvlScTkobl8eH0OpoMSo4yVNrM2PkNPe97JGyMaOsV0ccWRGjhWg9b4WyVnhxziXwPOmofAKJ4xNZz5t+TQwry0gkrt/iXq/YOQtZ8QfP7tnuNoFR1jvxtB2X13DkF0aU1fDPuYvnrPutSmLl+4Jie2YOhLmUsL/w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0XDfMfYx_1793153949;
Received: from 30.74.144.137(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDfMfYx_1793153949 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 28 Oct 2026 10:19:11 +0800
Message-ID: <93624f6f-7f7b-463f-954c-273b7a15ab5c@linux.alibaba.com>
Date: Wed, 28 Oct 2026 10:19:09 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/14] mm/shmem: fix truncation of files containing
 only swapin-error markers
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Gregory Price
 <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
 <20261027-fixes_shmem-v2-14-86a00952acb9@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261027-fixes_shmem-v2-14-86a00952acb9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6C22F180003
X-Stat-Signature: eexyd54dpnugcfxeohuqrbf7469a6tfp
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793153955-41465
X-HE-Meta: U2FsdGVkX19S5gfp7AQEOHeR2mBGe13BBpb18/A3xzgi3HhdxTZ1ImyxWUCtYbbK9qZZnm7LbxMLFISSq9a/HkXUUb9F1fZr3am7eXu/W2yPdxel567wqWI/JWR6ir0fqrPoSuSLn84FbFl6fAAczpJYVCrqJ+qk0s2OO7eEfAp5OtMF/c8rJ97PhfIynDcMkKGgcY9qK/TlivN/rdRpaquNvKRW0z3pFzHdM2ek1L38DK93FL5PDxVlhxsj15oC9ywRunSXuhQ+Lc3wA82j/ZXQWb4bA7doXz4mYsskzFEDephna2e9lBW7kMA1YvvrmKhyi8YS+sPj1HOQfp7bl9DEkl2RU3cswLnxxUn4mnmnJZ0VnS/ih4HkPAYVa4H9oZ+QwWA47p4QlQvrw40cmypujdYDRqQ6ETvfTsm6X6AibNyirASZSirOAU7VqCxhfO4HjnByZv4gFxasfw/WYs926jk2lxC4O4GNMQsPHbXzmeQHKBQ/bClpnpv8zixk+rDswdioPqhcFhIReWYXHXuCBBkBGfa1+B4kwexm1T5IsYVVQZtMJ2mfCaSWXVWMTbqBGbeWd/7wjdu85xtsCmGnvNhoKc3uZ6jPcLUSF1qxkRULMo0hCTATmtiCkPhzH3RrS1RdjXh+QXwnFOY+GCbHPsmf+XBiNihUnvDSyAs5yAYLef8aD5nUlRWHT0CZ3GeFaNC5/qh5TJtQ5GxGmfuU2Kg9jL98YO69jHBD5KBKc79/APh1Dg2V55Q83tlK1OBn+VCZSN6eYPChP84iZUs29R1YuCUzF9ADhbJYqaeEw6uDV6i84hXNhLzv3CLBlfDk5bGgW2fAK7nFhUt9c+zeAcEhMnWkIZsfxJ+cJ08jogzfZz9wXojX0xImdKrBqfyjJA0PINA+qeOdvB4YmHjV1IAtGqz8nz84US6tooeePrBSYJDhWzFSyWHmXvDjgW4A8D4mlOJmWSUxs2g
 Xvzjzu05
 qC6WEt1s0iy3YRrO98l4JR7ya3ImW9eebeOpC3Xa0m72tt4Qqjyk/pf23ZUR/xUlrZmUTmES1JAPWwZZi0/xypjjjRbM87+We8C1Kr2IQjsXHhI4VNvsPmLWhpVRdIq9H8gmgIddes4pFhiJd7TahnJrKlfIFTcLctAz9V53xsrShLi7SunGIiAkgi92lePr+CRVnwYC0ehM4+bQzePhsEhsjEerG/XJZ+Y8kCBI/ZLLSsNBCte/Ba9jBJZOqj/8rHi7FHEU5RfQSWxqNiZLI4kU2UoW08s7lqDYlGVjKtw7yNBf6fjaxgKXYtKe1f98sUI62Qb2rWEbwfAsCaBUebBSi207CXDtzdUf82RgtOCeuv60dMcvyNfRrKnmcNz3RWXyFhmrE3aE7JycC/A7vNprB3+mq7EZkF57xh55uRia7Wt0bXwDXZTBXGQGL1kq56n1AIXvSkEqI7Ek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/27/26 9:03 PM, David Hildenbrand (Arm) wrote:
> It might not be very common, but we can end up with shmem files that are
> composed only of swapin-error/poison markers.
> 
> Such markers are not counted in info->alloced. Consequently,
> shmem_setattr() can skip shmem_truncate_range(), leaving the markers
> behind.
> 
> Truncating the file to zero and growing it again will result in reads
> failing with -EIO instead of returning zeroes.
> 
> Check whether the mapping contains entries, in addition to
> info->alloced, before skipping the truncation. Keep the info->alloced
> check so that shmem_recalc_inode(), called at the end of
> shmem_undo_range(), can fix up accounting after reclaim has emptied the
> mapping.
> 
> Fixes: 6cec2b95dadf ("mm/shmem: fix infinite loop when swap in shmem error at swapoff time")
> Cc: stable@vger.kernel.org
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

