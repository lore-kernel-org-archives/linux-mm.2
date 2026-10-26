Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 871B960A3820
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 16:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=oJmC6Xsf;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=Cb1maXTk
Received: by kanga.kvack.org (Postfix)
	id A36F06B05B7; Mon, 26 Oct 2026 12:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1036B05B5; Mon, 26 Oct 2026 12:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 860766B05B6; Mon, 26 Oct 2026 12:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3296B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:13:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8DD7A07D6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:13:32 +0000 (UTC)
X-FDA: 85365272664.18.2ADC411
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf17.hostedemail.com (Postfix) with ESMTP id AB5094000B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:13:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="o JmC6Xs";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Cb1maXTk;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793031210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SuEMA61PD8ypCGtu9RwAMCLG5YHaMT/lSDKBxP64Lpw=;
	b=twqXGcNRwrwFkROEagL54lVMVfHlweWD0uaW6qNSJKQcDpN9CPYC6/I4ci4uc2MgEVf4Or
	0wYDpJC7mE6MYI+CP0dKMOwiAXBi7hYxzEbn3X2elrMSsQBWi55LZQ/26YEpk34RAY8S1/
	WnJfxC0bJNidSonvFLz3ygqrPdnVv5M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793031210;
	b=McKD69n/4hfXCWylwXw3DuHbMsClgFQvA4KPETRC+hVax8B0ryFMlwz2xPTZSolk/tZ4C9
	BYcM6lcniWDn0UnGV0+ZvFsuRn3KbT6YebUHiIlWHuqHbv8SMckF3sDptHbxC/y65qowWA
	Fox4x2GTGJXH3eU0t3i0n5lAKrgydoo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="o JmC6Xs";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Cb1maXTk;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id 25617138007E
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:13:30 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 26 Oct 2026 12:13:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1793031209; x=
	1793038409; bh=SuEMA61PD8ypCGtu9RwAMCLG5YHaMT/lSDKBxP64Lpw=; b=o
	JmC6Xsfow1yjAZvNP33bJMXf5QY+i5XLHravTrgfuUCsaWbIpBFuTAyiBGRWfzjV
	1dlqnm623/dOTK6ZeM9oXZ012Glr2ZzTSWB5cbMUYaQNOhfvSb+br37HHzad7Mew
	YSoqZ1bQIt+/HrK86GlC0l8ihnxPo++AyQVR/CL6z4c4B7H/j6hEts7HjWqmCYi6
	Dij5oR+kOfo7I4m9b0H0RIgf1Y8DVcG4zMb0gtKvFxUiCssnLsTAUw7wBN8CSXun
	Rv27Eex5wPm0gULIAO7uqy45Bl7M2JvPMmURWBRR4YgwcAZFygUuOmXf3GL5fwVp
	HGLRFuIjafJGovqd/yD5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793031209; x=1793038409; bh=SuEMA61PD8ypCGtu9RwAMCLG5YHaMT/lSDK
	BxP64Lpw=; b=Cb1maXTkRxdSrJDSeCUZhRNJVEOAhC0nIyYPlubphV/2InsX1vj
	CKga3SeUmjNJb6ZRxYxf7o75fVEESWgnYk2DFP2D0JHiEZA07AN2P0/b9PYWyKoW
	5ZS83JtRizqFf7/rbcjXl2BmOFBs7RweB/9A4QBfclyL+Y6NQQWXVl+k58gwZPj6
	oyg8vo+1lkXqSiEFI1opSznaGLXkVzNf3HVhXZzqF5WLE+2w4WTptzclGxpCACJC
	fUhhD1p2/DXENyImJ9kxipMuSKZFpOPZZBl6O7q6sLLHyid/Xyr9Vk8r0K6xBsrV
	fripqVEVRosLWlqDqD1IQIDUzY5kxMZm0SA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793031209; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:oPc47HClo1RvIt+2dbvddZYZrkWcbRjZp8WgcHglc/e0BZE
	aQfr0zhX6KcTHzrModzjLM3U0MH+Rn1mdgPmWAPG+aUApmLazlfHGmONGI1aeiWU
	BGuCjHU5ecgwYeNh5u2j51DEmY7YL9Mcd1E8vX7DNXPmspV4XDRzINK7QwnmIDD7
	c8gbXFZBQkGrBzzMNIXVtuJpsiyZ9mjk2O3POkUFaJ8Abb438DnhFBDXv8JAgD0u
	Y/yezzq4u7gPpmiw1UMQvlpL6vHz4oqqhZsOooK91IGa7iFIoPgvITPVO2MWl5ay
	ZKkgqRZj5CNfPDGBISdKKSqYXIkFXhPKphMs/+Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:P9tqkjtr7xJ0LZI83z6SZ6DETyMxibEyw+1uHfVj6Zg=:JLuqQrk98leSnt6vv9Cw5t0oqfF/5BKxz1YFDI+HSBc=;
X-ME-Sender: <xms:J3zfalgYzmFLkjivWEpvSfZqG2OoqNdinomxBIXdw0khYzSPk8Ia0w>
    <xme:J3zfagu-Pz_FO68c6gFQ9AsJDcOloRLceN5gDhUDkwHZKXCfw5XH0j887loyEWRuM
    9xqnPBm-XR6YUT2AMrrN_APFTdTp27asP8TrpCG2-u7PUZSB0eEkD-w>
X-ME-Received: <xmr:J3zfavSa0XBfO4-iC9Ee1B3PxoCm5kctj88IxDRhA7pPrpGJrK-uOmVtTd4>
X-ME-Proxy-Cause: dmFkZTGBB2cNjuELTs67fGgvkDQEDSU8qux6+8nxtLoE35+WVs+aWAZCsMVW4zWZvl//3o
    d+Nts1yMBYhfz0A2pBdaxzFlZZaoafSDu63LVpeb+vxy9Vwm87V8WMyFLNk7rWQLoUa5/G
    k0yzKLjsyVStCe8yZI9HHv7vy5dspIr4hypntb/PIB9H4GNYku4+EG1lzv/wuo8fa87di9
    +CF8ONEHEzQPPZF0ighPmGYTs5ZHVZOXemZ2aI7j2mAiAgvuUBkiiwxC2GgD8XiB+Phzk7
    kD0l7xy/HxT+YKPa/yncQBqQq8O7UuH9+4cIXrnIxtjuWoj2OdbkHw4f/dvsCiGqt0GPJ6
    5XToz1kkUWDtBnx/w21CqNEaW1qZCvZGci3D50ojvkPRVd8HZEg01/INknz4HMFlhsZqAX
    BgPwRhczFxR3vNXil2moy+KyOZlL14BR/CppwtBzFCXgKpreiHrIjMKpLWLmW0aV/9ND7x
    o2+CZ0TyrN34nBMGfM1olHAEhI2/mxv3mkAWJHEz8epr0WELvKEStcO2gFrRIN1FQC7sPV
    RVysmrQ+pAibpu010ENwev3dXzBi0OYRiVIY3IoRKhCaAuO2k5glaEdwhGn+EUxT/nggPe
    OKKPMnGTGlBnPIt3aeIzpw/5QeNySULr6bW8Ff0Rm+pBvg06Se3/TBr3MdOw
X-ME-Proxy: <xmx:J3zfaq5Pa-KToeTPK8EsXreG0-ZZRQpQfP5oche3lz2EtpVZb99A5g>
    <xmx:J3zfamjKiP0dGK1Zh6_Z6YQcsHArXWREOXYSfXPzaUYkwyJfx7b1CA>
    <xmx:J3zfattvMyNG8zSYSZXeVAfaFOviFi2vceffpzvUOZP_SnZ6KiqLFA>
    <xmx:J3zfaii39xyfykCc74-fjNwcC1MJZwle20cXhV-3PTdJ2RtNOAXukg>
    <xmx:KXzfahsomsDyKod-euTcJeG0g_T_Ta9KwojHvoPH_natJJqeuGKu88An>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 12:13:26 -0400 (EDT)
Date: Mon, 26 Oct 2026 16:13:25 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>, 
	Carlos Maiolino <cmaiolino@redhat.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Stevens <stevensd@chromium.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Subject: Re: [PATCH 06/16] mm/shmem: hold off eviction in shmem_writeout()
Message-ID: <at97dZY434e1maVl@thinkstation>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-6-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-fixes_shmem-v1-6-703206d5fa0c@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AB5094000B
X-Stat-Signature: pfp917eb5mq6h46utuzy77wumarsgndk
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793031210-330028
X-HE-Meta: U2FsdGVkX1/It4fHdSBnmyKd0LEFqKugGJHg/kqgEHsqmc4aEds7zuBK7NTvYSXrQq9zfopsGKZXyWOMOI0dcgf067O3TJR8ReX6NPBEiFuQQ0QwUjAUUIl6YDdmJplpgh9fmclvBj5PjiVlnannkB64e2joHgKQvhD9dbzPlhZixyiUoRXkO/rlgM3H5oxSxOhAhCWgtNOSPZ/DmStoAHmrV8D0xLLiJIJZI07XCA0YJ6uzy9CjYpWQs10NE7z+adflhhe97VOXuCh5Fz5hyAnEJEtM3YdZfqv/048X99cFYDlOKKFVVgsmqPRTLg/asxBKkG548luj9riRCxUAER1o8H22c3cTFddC4JIvhlz2lq/l6Nid4/nLKY+piaDZfFWqUa5i2axJnd0jQeE0FbwWko47DAkhwfbQ+zh5bPgS7zQ2fO2ZQsdRfC3h0Il22J9gc4hwdSwe4b4p3NTg5APrPj40c4tCVf+3CYSCmXE7wpRuiRWjfOsUvCEOKAZb8dJf+dRlDRSom2qYh8FCEvY/c/+j3NSAB5XDYTXWLXZVu/tOp+1wvXpqENedQsm1Hn1vwReD1CBhFUm53hdUxcxxGjI4RZ/yGkRh4GHw5esl9NOwTYfvpdqj70ezQiPGZew53fVMZgHenw6cgDRweW0on6wljDx3WneKIzFbTv1tqUTj20ICdrtR1DFSp5e5L1BWMcOE2w+Y28qSfEdqnKNIk6j2xVHDQV9uFJ7ZtIysYLXLFKj0KnGPbi1uOoO7NjlSdByuiZqW08OcmsrjhrpdHRdkyaa6Fs0ACXSSblXV6U+BrkmLG+p2PgcJOcpxwIube6zYrLCFGfnYC6apzd17Be5esNMEj0NOIv1f2ePRl0iSkCm0SWzliiRJ5jh9AqSS/N+ygM9GuEgOYI05BhLlEpF6ny2HhAoTVQaTtJTJzLI6bxVBucixKczGcALdGTpWL/lkkXB4Itpjvoz
 i2duA6If
 uC7RpKYFnfuRitmhgJD/5Kbi4wwNj/lGvtK1b6mWmEx79d/9em/HySiqcxjVbqJ282LwJnS6ioFYLyxjDNm90WGIlPXblJZdZFXaSZ9a36txpbL4DahbxUiJ+V+iDIcvg525/mO7qvUs4wFCAPcjtWnVomZr143TQhORV7DlupBm8KTMEDEV05ZWZPmVpOQ1SjanbDEf/+c+7Hs82YjGEwote/Eq2Ps1rW9j3KamdN9TFOekqx+u9Ep4p4RiIYmw1OxIQVXTolGz54I+Ein1vNWmPhRshy+Z9p2onB4Cxvb8ynY84ITaotXQ6Tk1lGmZdorsrYMSvETrBgnYDumx7wRABlvJijT0cEIdXsUeotMLHpddCwETxgMNPsjdW8ymVrkWrY2Moq6XmTHZ7PG1X4MLIJ23s2O3LTcvluvBX0PFWTxjibDOaNs24SCmggSJhJ26Xllf0EZ+OXOccjqQzIwIBATQCsZcvg9xS/7QGRfsJ658tispbJKxQX1oikV8pWppBJqcvQqrCZsTlb6Qfd1jTXwQdnQiRU7JpX67PsJ/XuM6g4/SWYOyO1gzHAjhUF1o4VgB63Go/FCbL5oXOC49YxguOsqQWwcdMZxSSCFV0CIIy+6a7iwLMwCsfQ9RUeLhs6jkkQV0b3nkv10olAoLXyN0+RlCfxXukVPjJ8+8l6FyVPHzPMP92EPeKNvjg5Al5NxHZrNNfykSXWlGVgp8Zbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:40:39AM +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Once shmem_writeout() has moved the folio from the page cache to the
> swap cache, the folio lock no longer keeps the inode alive: truncation
> and eviction find a swap entry, free it and do not wait for anybody.
> That did not matter as long as swap_writeout() was the last thing the
> function did.  But since it puts the folio back when swap_writeout()
> returns AOP_WRITEPAGE_ACTIVATE, it uses the mapping and the inode
> afterwards:
> 
>   reclaim                               last close of an unlinked file
>   shmem_writeout()
>     shmem_delete_from_page_cache()
>     swap_writeout()
>       zswap_store() fails               shmem_evict_inode()
>       writeback is disabled               shmem_truncate_range()
>       return AOP_WRITEPAGE_ACTIVATE         shmem_free_swap()
>                                         destroy_inode()
>                                         ... RCU grace period, freed
>     shmem_add_to_page_cache(mapping)
>       xas_lock_irq()            <- use after free
> 
> swap_writeout() behaves that way if zswap is enabled, cannot take the
> folio and the memcg or one of its ancestors has memory.zswap.writeback
> set to 0.
> 
> shmem_unuse() already added infrastructure to deal with that.
> Reuse info->stop_eviction to protect the inode during writeout. Increment
> it before removing the folio from the page cache, and decrement it after
> swap_writeout() and any attempted reinsertion and inode accounting.
> In shmem_evict_inode(), wait for the counter to reach zero even if
> swapoff has already removed the inode from the swap list. Add some helpers
> to make the code easier to digest.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: 6344a6d9ce13 ("mm/shmem: writeout free swap if swap_writeout() reactivates")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: code cleanups; improve description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

->stop_eviction is ugly, but, oh, well...

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

