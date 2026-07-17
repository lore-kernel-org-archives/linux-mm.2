Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4092BC44507
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 07:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F17436B0096; Fri, 17 Jul 2026 03:17:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0296B0099; Fri, 17 Jul 2026 03:17:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2F6B6B009B; Fri, 17 Jul 2026 03:17:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA9056B0096
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 03:17:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 397121C0554
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 07:17:13 +0000 (UTC)
X-FDA: 84997412346.25.B271CC6
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf16.hostedemail.com (Postfix) with ESMTP id 10A3E180002
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 07:17:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Nbz7XIQ3;
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784272631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O35vjd1SR6ZVSLxnkW6dqYrRQCrgj2fUSxcFsujseus=;
	b=RvfrbIh9TaNZLmOHxB5tJRzXqKl70MMptt5/Tk6nroI6cOBcy8CklQHRpBPTA8VfBiWJ4c
	Izz/txk4bj2pOg/WD0FOjpgWCWenEqUc+ppTVYxP+r43p9QghgeEn2IQowsANHpRqIfL/8
	TwWBXMbM8Al0/N7HkB++hukKWWYj8HQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784272631;
	b=rzVZZkLBMdrQW+bMXq//PDJ9S2UJa1z3yvnjHfqMgV3ilngktn2+qymUbEK8Z2BPVoUfrq
	VSTSH5HpQSj2q8chbQmyGwN/Xmiu1f8l97BJgCSydwf95qKVyAPu5w88oM9pwKAfTVCtzE
	2/LhkfM8xI3/HlHJ3UgXR48O+UP+0xI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Nbz7XIQ3;
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=O35vjd1SR6ZVSLxnkW6dqYrRQCrgj2fUSxcFsujseus=;
	b=Nbz7XIQ3R27VwE2oO9uRkwO2uffyJWZ/WUgazsKuyIc3S2aASmVIs0ZgRxNSMcQ6EZi96xCM9
	Vi3Rd4VEfiJopsgwkRlBJpC9GUw8EXxlJKZnu3Tcc1mSHqGAExuQDtkN6adOSJx6TpP+XjQLHbs
	JoXbTyXSBkButzes9y3y/j4=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4h1gw26NXtznTVv;
	Fri, 17 Jul 2026 15:07:30 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 0814240586;
	Fri, 17 Jul 2026 15:17:05 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 17 Jul 2026 15:17:04 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 17 Jul 2026 15:17:03 +0800
Subject: Re: [PATCH v6 1/5] mm/page_alloc: introduce
 __free_prepared_contig_range() with fpi_t
To: Jiaqi Yan <jiaqiyan@google.com>
CC: <osalvador@kernel.org>, <harry.yoo@oracle.com>, <willy@infradead.org>,
	<osalvador@suse.de>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
	<nao.horiguchi@gmail.com>, <david@kernel.org>, <william.roche@oracle.com>,
	<tony.luck@intel.com>, <wangkefeng.wang@huawei.com>, <jane.chu@oracle.com>,
	<akpm@linux-foundation.org>, <muchun.song@linux.dev>, <liam@infradead.org>,
	<rientjes@google.com>, <duenwen@google.com>, <jthoughton@google.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <shuah@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <boudewijn@delta-utec.com>, <ljs@kernel.org>,
	<ziy@nvidia.com>, <vbabka@kernel.org>
References: <20260705180714.3708947-1-jiaqiyan@google.com>
 <20260705180714.3708947-2-jiaqiyan@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <de417e47-049b-8f32-e983-efcd63424136@huawei.com>
Date: Fri, 17 Jul 2026 15:17:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260705180714.3708947-2-jiaqiyan@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 10A3E180002
X-Stat-Signature: 16jj8pc1mxk1xgn8bjpzmkyxhtn7o1z6
X-HE-Tag: 1784272629-106712
X-HE-Meta: U2FsdGVkX1+0UWVwi9+knq5f/iKXqTjKLkj8HwI6rfEbI1CsC2Gb6VI5SyCTxCmc5xYBvaqOdqBmj04iX7u7HwnIlGxjZn13WN+N07nKnOgiETmmqkqADSYLInPwULpYQR9smIoXGcWnrcgN2oLT7jGHRoVUlaqrjErqjRNeW9ndW0wYqsRrCzpk4QlXi1M1ovKeZFRjYQ0L74f9hIqTYx5B+AwEXH9ZO6xYKV0YeQkoJKUXFGCmqd38Et3ZLjW6xdzcLCDCe656WE8dg+VgOWflyfFgFCpRQYlIazci9kRKeN9j1We9W3x1NkxwaOawtfhxr2N8XQLu+McKDT94NZdq7J578Y+xFB5we8hMGg09p9Z+Vmw0erwfGbU0Gn3ifKZ24b6r/zEErKrtjQMTsFC4l+epZarNh9UntmgEQ8fiNM7e6jMA6nT/C6VcEt/cJ91fDHj0Autf98oOS4O2jFFszLjxrQ535o/A1vU/egQGCgHviIEkKTa4RhBH22y88L1jcRKd6tjkTiK2s0QdXUfScSg+jAhEbX3GwYkFDObwRDPAXc6yA7v3ZPlYyF6O1ezp4y/6YKddKcoHLJQqNkfBX7drN5hjj3FEhFYn22t6KMvQyKkL/KxFguKXpjAruobi4bBSaBWMlQiJjjxbbcRpVBL3SGFPOOe4x1cPc8bacicYy0NrunNn6DHYhi5zkCvw5+VlVCRQ+6vKts2oaASxrgQF2jOmXrW7Lq0d7BPfipBIeT2ZkfkLDvg5/NHN1vFWsImDf0X5rCe+4bNLYVXfV5138wS9vz+Z4DeLqvo7IUdGXEFjrT6YlHmT+BZZh2GVRbwCovQqMMLwmj+4OF8Wy5rsoTcX8+h3wxXrLPDRn/Di4pUL4DnnXmE1ETKcYXrzPzvTni2JCq49oFt2YII5OxZIAwaHwMENRilvaeMXLk2gGX8bag/rIWxFsYIfeVBSiJzIQsipz/lJvZX
 ACQuvo31
 qxhRRvwWqCpHDJ2nlrrVOf1wsInXoFYzVN9PN9H/YAH7otPUwOJAfQtc5lA9Lz94fTSP0C2Bujl7lzP73p47z9ngF3Jlguvg6kLO15qe4jO8z+QLojo8x/a+U7+CzJh9+CtbdCzFmgscAJzRHZYZXIbtvuNrNOOEqjsdHLkv6BuV9/bX9f76gGZtyNRP4sLxnW1ERvF2jmt+Nqil0fKYq0RbtPrZ6aQZzSLogpAjBpMmOl6DTQ2gPPstQmSTIpPi0CGqKOkIdc7L8ief83CcdDxlfcVbZL0S97Qroa2K227s1IhZv5Sf3pe9d8XqLm6MK3d7EQSwApE6qZeTfsVQYyfr5I+MTjhvzwBNXLupd9E0RjKfqz7CHzga33fT7B+iWJGnYAG8WNltMxz7Y2Byinsn/ezX3yMKKFBGSptfNnfYG4EVUGY/RZuGakWLOrkYcc+WS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/6 2:07, Jiaqi Yan wrote:
> A future commit introducing free_has_hwpoison() to be called within
> __free_pages_prepare() will need to pass specific fpi_t flags when
> freeing a contiguous range of pages. Currently,
> free_prepared_contig_range() hardcodes the FPI_PREPARED flag and
> does not accept any caller-provided flags.
> 
> Rename the core logic to __free_prepared_contig_range() to accept
> an fpi_t argument. It bitwise ORs with the required FPI_PREPARED
> flag.
> 
> This is a preparatory commit with no functional changes.
> 
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> ---
>  mm/page_alloc.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

