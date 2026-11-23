Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E463606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=EhVlDbiJ
Received: by kanga.kvack.org (Postfix)
	id 2636E6B00EF; Sun, 22 Nov 2026 22:07:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ED826B05B2; Sun, 22 Nov 2026 22:07:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BD446B05B3; Sun, 22 Nov 2026 22:07:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE69C6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:07:01 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 382B18074C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:07:01 +0000 (UTC)
X-FDA: 85464897042.30.D256B11
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf31.hostedemail.com (Postfix) with ESMTP id 393CA20002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:06:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EhVlDbiJ;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf31.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795403219;
	b=cFecHud8Rh5O3V+FNor5YfdJlZcIYUQv7KSqax2twxeP+dVOr/3yoHdz9YJUel1ocP4VRf
	Yut8POeT/Pp3yRS8R6Aw6wlzOnD8YHSftGLH1ultbc9VaWfelXOSb5CtHD9rPGxfv/XzKR
	N3AqF7khgnyvtGPd9nqV9KwWC1giivk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795403219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXAyZ0hsJbhvQY501e19qPPambdBmSK7h3/bB0F7/ZI=;
	b=rs/jxOiYhuy8NelDzaZ3eBYymnBqoa9KiIS/qmgWvrhPy+H5bmVL/YK5prax3q/+U1QHA8
	dek3AR/aS+8rMvniUQMUsZTImsuMjprOz5YJzrgrLhiXA7Bk+4/xuhK3AfaOnEuoFvHoJY
	b04rGiN+6yt+CW5i/LQCgTY5qTkDvw0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EhVlDbiJ;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf31.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NXAyZ0hsJbhvQY501e19qPPambdBmSK7h3/bB0F7/ZI=;
	b=EhVlDbiJ9arsbzJbWLHXae9h9HA0VIwcidIZHWyFTsC6bKPjBBXxyMciPpKLIIQ0/KoWErFuV
	QoA7uDDyldSsdn8N6w5Fv4IibDYNmilbpc27tANruBX/OfPZEd96U2i+2pn27Ne+rVsxIMwugAy
	XNn2IC4ous5PP8/h76RlWRc=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4jXrRp2nQQz12LDW;
	Mon, 23 Nov 2026 11:05:58 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id D72774056E;
	Mon, 23 Nov 2026 11:06:47 +0800 (CST)
Received: from [10.173.98.163] (10.173.98.163) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 23 Nov 2026 11:06:46 +0800
Subject: Re: [PATCH] selftests/mm: skip hard dirty page-cache test on FUSE
To: Kurt Lin <lylin1023@gmail.com>
CC: <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>, Muhammad Usama
 Anjum <usama.anjum@arm.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
	<vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko
	<mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
References: <20261123-memory-failure-fuse-skip-v1-1-19dcbda6e2e8@gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <25ecd9ad-7c5c-16ff-5197-5703622a88b1@huawei.com>
Date: Mon, 23 Nov 2026 11:06:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261123-memory-failure-fuse-skip-v1-1-19dcbda6e2e8@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Stat-Signature: xtiajqzy6bheuw33sq5x681omgkrz6hg
X-Rspam-User:
X-Rspamd-Queue-Id: 393CA20002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795403217-963647
X-HE-Meta: U2FsdGVkX18xaNUSZpAS++yOa7l4SRkTbd8Uyi0A2OM1uxPqDp/a9g/OomS+3nH2OgC5RdJwQxZYuHOuxUDHxnPoyRjWPC5ouPEztJKY0yVH8RyF1Y7WPmf9OCZFEh5MXslHmjytpyhk//xAAvgaBm8eaZOodymXT8y6lDyy5KVhXvNNgpx5JCRwpx5k7YoCBbg61IhJOy3puawXuOAyeKfse/qmmGzrO3aaSrZLhkTMbEyDI3991blsEk42rGsJ57Joqt9qNnu+RmTe41NmnXiuCZ1BvmYDg9rEIIZi1TCHjpCCRcqBdTH37xqFgFhcxVRO+MQlyfwTn7uaFI73gnXzuFYkS9/nnMZT80da3fAi3SzYesUw6/aPUcZ2zcUfb8KLYEdJ5d7tCYx73uBYSznFA2S4W2/fgyJlUqLxHEs5+U/SlpISB3BZdapV7xt/JFLDcX9r1hs69QHLxsgpx8ZoXpi6KFRnjAyIrg8mV/skCJ29C5e73hwIaKqNeSPxk3UL7Hs8C5l1hwCkkH6HxjYF1pwhEjOozEA1TJ+xxNhrKi/0Yj8CIfpHKpATRAv+WRW5F/QNByKfViSkQW7mnPOfk7rcJv8cXbjiNc0Q1ZwhucQYEnP41niMi0Q39JtpBoB+ihWNpWw6N9IA7V/XdsCbAWjy0sNvKlDBDIUCYKr2rmzZ/rcQQOv2bK1CiquBlZL2XG6tiIOtVEnzO5Veh+49FCD47np/k9I3K4ZgbH9190CkCws/S7bQJwkh0Gnm9oHAEIj8lt7qEZLPfGjopMc2zQScT7t6KfbER2FXDN10WAUJhq7jOGbtJTqIoLJjn43J+Ctkk1eknw3lBCzIi5kR8mcNXkokdDMDMPUXL80tFdK9E0ceOEetY8kbt+xuoKBVECvyoGPmznV6Q9DJII5goQhzH7SYp82Czhz0fo12SZfBUhXpy9EjHGaDtvGaZuC/3QsT7s2g8R98p/z
 1DgyopyR
 JYs1Hl8h0xQ6FM3jFptVXootH6POzr8UtYbgySGJNdbPPHH01aLDoyBo9J6zIYjFoFXuTlzTBViicwik4ppi/zEvCqYT7zoQtwQxoBflOLdEn7HSa0Ug7H+VIZ6ZAr03yYKjEsZtUwc4Fsce64qQxw3wwBZD8hGQJgMg5p+eZwWCJRR0UlLwkq/SQIZLbi5nW9NknP0hIAugKpKLco3ccrYGzeuiURcxcgdan3bqEwS+y09b343EgNw6XrGrgRr6eqWd2nJTr7K36TvoJtqqEQpRjxUU7R6bQ0DWapNz87ml+sqdlZo+tWKsitR5xha/X20W5IDSadubRfLiLX1K2/IQG2NS9D/v+mnvAw0Ykav3GdJiWNOFBSCC7SN/ZHri7g6XEKUBSBHjPxvKlc8i7Z6eOn63awVR4HuTBTfZxlAlX8YjuxeIaNEiMo1fIS8Zk7hp0b21Hs7QmcUUV0Fjex4+d/35Ky6BUkozJiLPpriY2IPr+ha6qv5gU8t91iJJmFfbKqNaSFKfyqRYAei4DL+6ZiTf83/JxoGP4TU7K35HRTIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/23 1:58, Kurt Lin wrote:
> Like NFS, FUSE reports on close() the -EIO that MADV_HWPOISON records
> in the mapping of a dirty page-cache page, as fuse_flush() calls
> filemap_check_errors(). Run from a virtiofs directory, e.g. in a
> virtme-ng guest, the hard dirty_pagecache variant fails on its final
> close():
> 
>   memory-failure.c:389:dirty_pagecache:Expected close(fd) (-1) == 0 (0)
> 
> Skip it on FUSE, as commit e14e52a7ce02 ("selftests/mm: skip hard dirty
> page-cache test on NFS") does for NFS.
> 
> An AI coding assistant (Claude) was used to find the failure, write the
> fix and draft this changelog.
> 
> Fixes: d51b5076c746 ("selftests/mm: add memory failure dirty pagecache test")
> Signed-off-by: Kurt Lin <lylin1023@gmail.com>
> ---
> Tested in a virtme-ng guest, memory-failure built from mm-new with and
> without this patch, hwpoison_inject loaded:
> 
>   cwd on       before                  after
>   virtiofs     9 pass, 1 fail          9 pass, 1 skip
>   ext4 (loop)  10 pass                 10 pass
> 
> run_vmtests.sh -t memory-failure from the virtiofs directory passes
> with the patch. The soft dirty_pagecache variant keeps running on
> FUSE and passes.
> 
> FUSE servers that open files with FOPEN_NOFLUSH do not report the error
> on close(), so the variant could run there; it is skipped with the rest.
> ---
>  tools/testing/selftests/mm/memory-failure.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
> index 135a2e8069ba..72a29ec19692 100644
> --- a/tools/testing/selftests/mm/memory-failure.c
> +++ b/tools/testing/selftests/mm/memory-failure.c
> @@ -355,11 +355,12 @@ TEST_F(memory_failure, dirty_pagecache)
>  	fs_type = get_fs_type(fd);
>  	/*
>  	 * MADV_HARD poisoning of dirty page-cache data records an expected
> -	 * -EIO in the file mapping. NFS reports this error on close(), so
> -	 * skip this variant.
> +	 * -EIO in the file mapping. NFS and FUSE report this error on
> +	 * close(), so skip this variant.
>  	 */
>  	if (!fs_type || fs_type == TMPFS_MAGIC ||
> -	    (fs_type == NFS_SUPER_MAGIC && variant->type == MADV_HARD)) {
> +	    ((fs_type == NFS_SUPER_MAGIC || fs_type == FUSE_SUPER_MAGIC) &&
> +	     variant->type == MADV_HARD)) {

Would it be better to add a helper? I doubt there might be more unsupported filesystem.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

