Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF628606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=MYFQzskI
Received: by kanga.kvack.org (Postfix)
	id CC33D6B05E9; Tue, 27 Oct 2026 03:26:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9A5F6B05EB; Tue, 27 Oct 2026 03:26:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDB676B05EC; Tue, 27 Oct 2026 03:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E88B6B05E9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:26:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 33EF81A08F8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:26:21 +0000 (UTC)
X-FDA: 85367572962.07.6A02FD1
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9819AC0002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:26:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MYFQzskI;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793085979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Voi00V0tdXCD/BPkPI2PBi2izLO04MVewLq5+Eoz9wA=;
	b=eyTvD5JazcE8siySxE+BnkH28lGl6wS0SbXPOCUBTYdnT6jHYvJDsH/atvMDoQ6Px+Xk61
	HLVFh8MsI0g8/wsHBB4tH7MFxPdDpvB44MKZxqnBGgU3QFYd1nUeVYR7s3saZuVLGd478y
	NqYhlGcbFTA8A9YG6YowDRUfLQIvfkg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MYFQzskI;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793085979;
	b=TcbBF2i3mAVg+K1eXcumCvf6V2CaXcJKYpEqn+6Q250sjcNli0AGBmzLplqE1gnNMW4p/L
	mZsVHfrSBQ6N8ZC8HSdlXptHm0QzSH9JsjODdSSauKORkVEsmqg1ruz3mE9icLf9APBXbc
	1HGmxXUiw4jBikwxTX92EvHkweQWMuU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793085973; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Voi00V0tdXCD/BPkPI2PBi2izLO04MVewLq5+Eoz9wA=;
	b=MYFQzskItQC/i4x/0bsJ9JcPM5OfxSv4QW3bwB3I3AROp/mRJercbUep2fjoJr8tlUw4M17kuulmMhg+PF1kyB8VDjRzZwgNYOYs11uzvdDBBPXHBrzv/HSxYpC7/upQPs80uW51lP+iYFCvXcVTox9pHGVsaj4UsE0/5DFxRc8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0XDcwS4h_1793085971;
Received: from 30.74.144.191(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDcwS4h_1793085971 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 15:26:12 +0800
Message-ID: <e1aa3fb6-a557-420d-88b5-9864ddfcec2f@linux.alibaba.com>
Date: Tue, 27 Oct 2026 15:26:10 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/16] mm/shmem: discard whole new large folios on
 fallocate rollback
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
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-10-703206d5fa0c@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261026-fixes_shmem-v1-10-703206d5fa0c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9819AC0002
X-Stat-Signature: 3q816fn66jywzouodqihgjb6mebz53b7
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793085977-922327
X-HE-Meta: U2FsdGVkX1/adXhZsdIf2auaag3s+e1BouxPj3vbgnYuz8Rg7Wb623GDoSaCwxQDdLn9fv3+3uBLwV9J0oA/lbmKi/0oPWaeWJlK1G5i1tFAmnXqRKlqD81YPbD8tg2Cei7yVX3S4XQYZ3A8lbvBTPx+CsVkVzSYH0oSziGpg2IFEEcW/hqn+HEzgPL4Dcl3LBoY5EVSzCAyZW/T6apbl/Tnb9Fx/OHFrbvVesjW/xN9BsM00D72GSTfZPQcurur9KIO/9QWunQAocGa+maIvkVWqhmUW/rzqi/Bbd6jpLgYotgwQdjtz01t4OBM14PAhcGo7MwBt0odfAxl/lT/wpJQU3zgi7I/Njnil74ZpmZ2O/83nGrSRj8bLV6HCpDv7NnlfeGRX0Mi2nKUL6XsdFf0KNXWJxWxhDYNgyYJMCSQF/spwcT+1cO4Ct81vSsxHT3XFKf41948caLB/n+DIXIavDvQsqSqRTdxV52KS5wUb3yvtw9woHCi5NRAa1ZQ7B57SRC4HM8Jy1qsB0gSvaU1FxCULsphiiPzxxExtCE+prGqTDgPT3IZrpaZxofWma154howbPIzDtFI+3PJtYXrsBv8p2QKFX+8/rKVkL3CEJrcfP+U/ewUhEOlteb5qf/QfEkeCX2BT5O3J357lJQ8shF/yeVhRcuYt8aKdyy6X7PUmWTyt4RMUMNHFdV5qtsXXnrUE0WMCTteajCbYNqn5lxTE5WgGZs3A3Mjpkn1G8j7pkxLlT2LwqfNi27XNMdiJemwBGRDprCa4cZS2xVIsax6ePpAGrRFxJbUzBeMgjBc/GQgqYQfeeox3nPvPbVfTYYbHp7ClDjR7A0/Hy4uQTPQH4hl1865vUXBONAaUzliDkqv/J4OAQWnlioUv5GFAGV2cep8GjLmOCYJFpMNA60thZ5Z+9R/ieV3G+0q7sx0X67tOGQK2f0tAg2sdym5pKffrW3mJwAL5G4
 c0Ar4hmi
 fuYhKFDQKXBcUUTSlySRCg2Ifdjdb+5fdylwUBLC3qqI6O4VkNDVUe0n8emKvRC+r6rc2VVLpvwJh/R4Xwp8qRin6/sZSb+uOe1ynGnL9TCT+BuO9j3VTBcCDFEMNm4RuJ8DhDBovdjdRwptjBxPIfX/EqtXcTfC03bcHf4r+v3ROAZaHK2if2uRsQKjd7aJhUvqVBKy5nwApZ4JpFUsa7EA5UK5tryFiTYCKUCg3RpodvJ9cpARtOj46AKuRmZbcMVEaYZH+4JTAg15fyEFuo5vFnOVhvn6Va9KbzhHN6kxXPZmhtRLp+kWGZFN+xMJA2KXXbZAaun/0oe+WZZmcdphEGTV7cqagYv9HhebHRAxsGrOD4rdperYx6/7I0czVwpVuiBfK6ehZMk3GFNvWpptaLboFHN71ObePhtE4jyjrNAI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/26/26 5:40 PM, David Hildenbrand (Arm) wrote:
> When undoing a failed fallocate(), shmem_undo_range() must discard each
> newly allocated folio. Its second scan instead passes large
> folios to truncate_inode_partial_folio(), which does not necessarily
> discard the entire large folio, but instead tries splitting it to
> discard only the requested range.
> 
> For example, with huge=always, a failed allocation starting at offset
> 4 KiB can leave page 0 allocated in an otherwise empty file.
> 
> Discard the whole folio when unfalloc is set. Note that we enter this
> path only for folios that are not uptodate, and can consequently be
> dropped without losing any data.
> 
> Fixes: 55ac8bbe358b ("mm/shmem: fix race in shmem_undo_range w/THP")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Good catch. LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

