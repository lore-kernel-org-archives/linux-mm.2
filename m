Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97C40606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fy/QdRra
Received: by kanga.kvack.org (Postfix)
	id A79C06B05B1; Thu, 12 Nov 2026 03:05:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2A086B05B2; Thu, 12 Nov 2026 03:05:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967196B05B3; Thu, 12 Nov 2026 03:05:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 720466B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:05:21 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE20A1203DF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:05:20 +0000 (UTC)
X-FDA: 85425732000.13.58557D2
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9F96A140004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:05:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="fy/QdRra";
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794470719;
	b=lPZRkyb2BeL4Yt3Hitcaoh0+UM4LdfjtPuZt39Ci7bDCQq0C+ym3ge5sU8QN82pEsF+sGp
	qrVXGvs//rk6Bdcz+WpjFcylGe1kfh9i/WoQ92o6pFtGOwJj617XR596VY2g7rijuKnLcK
	8gkBE+wflfRYR/6kiXZyaCm7B4+BqVA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="fy/QdRra";
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794470719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbKyXXPEsHUw7FHzXJao5FJ2QpebW01qg7WPK2+9SIg=;
	b=U4gm1dNVPgu5iy996BIe5+uO8orMUOixcLpPn1Rh7qGMgvOHyXKIZLgXIduEz4vi1nDgrr
	KMHYAZrnA0KQ+/9eGBdHFBn0urhLEvntMhEEG5e8BD/bV+lCneBt2jMxYxdxG7cSkOI6F1
	OQtUO0E2NlRX0Np0N1019HUqZE9pD/w=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794470710; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wbKyXXPEsHUw7FHzXJao5FJ2QpebW01qg7WPK2+9SIg=;
	b=fy/QdRraoZ3DWUdUf+/rvpVeYGY1wBK6acx2MOesqC5rc+mj43RlvteAptK0ItqNl/lzvHOYt3Yt/j/lzZWyoIdce5pecTSO8IymmS1lIYZ/UkDGjsjMUiUHvzQZv+rzqM9dSpWgejBJqEkYD/ryDKmSS4oN2Zuj2G6SZk9QWxU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XEbNi01_1794470708;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEbNi01_1794470708 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Nov 2026 16:05:09 +0800
Message-ID: <787a1ba3-df93-45f9-abe1-3fcdefbe41cc@linux.alibaba.com>
Date: Thu, 12 Nov 2026 16:05:08 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: drop the second folio batch from
 shmem_undo_range()
To: Qiliang Yuan <qiliang.yuan@linux.dev>, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
 Qiliang Yuan <odys.yuan@gmail.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 kernel test robot <lkp@intel.com>
References: <20261111-bug-mm-shmem-undo-frame-v1-1-e50a95b8f9b2@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261111-bug-mm-shmem-undo-frame-v1-1-e50a95b8f9b2@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h4ew1h9c7pkcwdsju3jk5qi5p3smiosg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9F96A140004
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794470715-111
X-HE-Meta: U2FsdGVkX1+PW7JwWsAgzFAaHLCpYnrmlubX81hoFgiY6Mg2j9U5Ohci7QdgjUCP/liXgQ9tlkDQaQbm36ROGuUo+SAWlqxGB5l9fqmWcVug2LeknDmHp5igWHKgMmAj94fDUQrT2A7ZaBSUMAxsCoH0zo1UfHbxJis/oibdDyBOeeiYNo1IIuEKPKvYP05H76mq2b1XJ/Rexi1ndXLWcaG0BlQazpy8JXCPI2n5UEtspb1AmTNc5g5cIhD1IT9aUo1Q1M+p/BtmoXAIhMaNAGmAzhE/DJxsehJRjhuLzZ0jHUlNZttphjA1P4Y0qXcXeq9+qM5GEGF+5fOsdq9Z4afA++VXBAxLZDpnKP/Hcz/svDRrmRMRrJnidNYNMIqtIQdJuSFvMKUQ1g7sMabMWUJ1VHj/CFfH4FHkpcAElNe9CdhQ1SEHS7LMxePcpQcW3eP9s1YVjZPgX3Kr5jKqdAv5A7dv9Ilrw5IeCEe5z821EfbU0R7eY3SnI9rJl6Ilq8OFGzuxi8QSohcQBVhcnOH1VKmFdYFXaudS3eoUDTgSRGIDa8ZFWsIpla37yCe+LQHNk4xT6zHfI98T4jXwdqHYjEtI8j9ApqfUw9J09h4qH7pvHpX1qQEqrIPMWnNsJbz+p7BmVOl11bDdmvnTo5vpv4aS8ERlgsqRpU+zmxHkXXH1JqEdL2CKbAREKOhkZPWHRqRNmtAVkPds2wjli0upOyk+4yJGi0JEerDlmBb01rJvhKQJ7dFMM+hNZRToN4q/zZ5K5+CU3gQUOeKWAcEFYivC8MAyj710LmdPflSYuiGF0mIBJ3xpo8tbZZ3PV8Wp/9HsLZLlQM/EAvqOW0wxV15agcEd8+HeW2mpJuRZYyjgmRB+MDM8FJiDn6jiewkEmpz55Mp1KcArCc3iifj8BpX6PM3EOrJy9ji83eNeIbsmiYyOJFo5rwBaQD8nS7QkeNLYZ9NIaU3uTgY
 kswOqkIE
 nustf/lDa4XBK+wswAb67AB6cmF+8aSJ/eShj8f9gqbDmJ/0/naMYygJVoWZt6l24fSENvuvg/Il15WqdLJk0E8ua4g9T/3NdDXTkEI4nDKJ2howuewEsl7awnUGJosBcSBppmK/NphgHi2F2z3RKkt2HdSMOVRN/mv0WDB2HiGi+xzXP4+yfaeb38VY4rLvFwuDHfb4BnnMH6ublxlYAQ2jcLFy3Ikwrh8EgVrzzGkB/PDgWwBqO96gZLS/G/zojbhgtgfDYyccDYTNvHtSObh5hfKowhPXbzO2w821QkziJfeaJ4rH58ODyiE9uLCzrHxOTRJ0qRi1d0c/Vr4eoVmlqFn8iK4E63pqYUVO3IxvBJaps0RP6p58gvDipoRucoWfWac35P5DFV5mvA46xOTNsrO7dpNKRymJXFW4zSk/6LYTW3r5Ffw+oWFlVat5DhxmP3tz36Wp5wWVq0RuRkB/0LEMSa47OsSTc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/12/26 11:39 AM, Qiliang Yuan wrote:
> shmem_undo_range() keeps a folio_batch and an array of FOLIO_BATCH_SIZE
> indices on its stack. Removing truncated folios from the page cache in
> batches added a second folio_batch to collect the folios to delete.
> 
> That grows the stack frame by about 200 bytes, past the 1024 byte limit
> of mips eyeq6_defconfig built with clang.
> 
> Pass fbatch itself to delete_from_page_cache_batch() once the swap
> entries are gone, as truncate_inode_pages_range() does. Undoing a failed
> fallocate() only removes the folios that are not uptodate, so remove
> those one at a time with truncate_inode_folio() as before.
> 
> Stack frame of shmem_undo_range() built with clang 18:
> 
>    config                before (bytes)  after (bytes)  change
>    mips eyeq6_defconfig             928            720    -22%
>    x86_64                           920            712    -23%
> 
> Fixes: b97fbd541ecba ("mm/shmem: remove truncated folios from the page cache in batches")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202611112032.TMyPU6Rm-lkp@intel.com/
> Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
> ---
> David, this applies on top of b97fbd541ecba in shmem-7.5.misc; please
> fold it in if you prefer.
> ---

I think you should send out a complete v2, and David could queue your 
new version.

