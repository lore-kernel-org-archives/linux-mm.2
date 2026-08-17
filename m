Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4133C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3E536B013C; Mon, 17 Aug 2026 12:37:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16EF6B0150; Mon, 17 Aug 2026 12:37:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9525E6B02CA; Mon, 17 Aug 2026 12:37:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7366B013C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:37:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F03A8C082C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:37:20 +0000 (UTC)
X-FDA: 85111316640.13.716ABB7
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf09.hostedemail.com (Postfix) with ESMTP id D6412140003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:37:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=qH8gdYjc;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf09.hostedemail.com: domain of sh_def@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=sh_def@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786984639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pDp7Y6nKu7sVMOaPrZ7lmPO+gASpbZ/ff+zMKWjK5TQ=;
	b=RTPwgpLoTIYsYB+b3vLTt7/U02pB0lFww2NMJf6DtktB2awFIH8MSWqatpxb0c1o31CJWz
	JdvxilqtVths1O5vYGHU8L0ayWTWl/gPDhlb55uQjhlcUFyGTqybit4zt3wXj/qMaa2JTn
	QZ101oBL+YSfX6pBWpCjiq0dSxQYUho=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=qH8gdYjc;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf09.hostedemail.com: domain of sh_def@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=sh_def@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786984639;
	b=FSMV0DEfKoAnQw6xt4dUEEGnHe7BHzdpwiBuNzQsUdy6Ven6aNIM62aGSkZ5JDUwPFA0a7
	NokTVPkNE7v+VE+tCFE6SzE8h6gJSOI051apGhfvGzWDz4H+1AlsdYyCsR6rkngWfwC1G1
	qg8XAHg4Y5EC+J1q+GFlJl40MJX5bco=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=pD
	p7Y6nKu7sVMOaPrZ7lmPO+gASpbZ/ff+zMKWjK5TQ=; b=qH8gdYjcLNS1WpEpSx
	64baJWgiOugHZfLBoderdm9quEeiS3SOQVLKa8E9exg1MoHanzXBzgvZYmPwpjji
	Y8kDZr/vkHyZ70HTFR1DdykbYRmK16inibhvUNwrSZzY9M9LLzAIMeAlxQ2Ab7KV
	+SBirFLf0BCRL+UshEb8CWA84=
Received: from localhost (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgBHJh6dOINqPL8UMw--.63394S2;
	Tue, 18 Aug 2026 00:36:46 +0800 (CST)
From: Hui Su <sh_def@163.com>
To: akpm@linux-foundation.org
Cc: apopple@nvidia.com,
	balbirs@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matthew.brost@intel.com,
	rakie.kim@sk.com,
	sh_def@163.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com
Subject: Re: [PATCH] mm/migrate_device: fix cache flush when replacing huge zero PMD
Date: Tue, 18 Aug 2026 00:36:46 +0800
Message-ID: <20260817163646.929678-1-sh_def@163.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260817090640.287a9a415da49e3974797aa4@linux-foundation.org>
References: <20260817090640.287a9a415da49e3974797aa4@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgBHJh6dOINqPL8UMw--.63394S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFykGr4xKF1xWF15AF43Wrg_yoW8uw4kpr
	WxGa1Iy397GryUCFn3XFnrJr1Y9ws7ta1fGrn5Jw109398ZFy5KryIgas0gF45Jr48Jr4x
	Zr4UKa4xZF98Z3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUx-BtUUUUU=
X-Originating-IP: [183.192.101.80]
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbC6h6wEGqDOJ49GwAA39
X-Rspam-User: 
X-Rspamd-Queue-Id: D6412140003
X-Rspamd-Server: rspam07
X-Stat-Signature: 4bhb9kpd857duztskc6dbddgnccso4b4
X-HE-Tag: 1786984637-696972
X-HE-Meta: U2FsdGVkX1+uuqkHOEtRq5BjWcPP0oPph1FsF/TDuHg/ZxcMAkK0VoyNUM0W/oWDnGZwveQ9HQrOD5yz04Ad4gfdy6UtIYFo1DuTQIM1C6vEB/A3/47HniQO9OBK/tf1JTw82KDGPKrLJJdxulixlIdLb1QX0nk1SShuC7jt5OMx0Bq/eAra9IgdMi1XgunV1UN2K8M5buXgd7CyyB+5bRsoF0iIYwoICozqYfeqLC21cNlWIz9ZTCnsFeGRQD3HVspoQX3X7TYzZCudowWpoJIDY7dYddWYao4Trf9MTJlJcb+RtFcxfdGkq/xQLd2zWmAu8eFhTqwNv27By2nNqW1n+2XobF7ZZVIIOEHehRID9BbPRVxHajmSNGezEnLf5yKyXSYOX7Pv7ZwBLe1SyWmybduZQkuhPidzcdsGcKnTUBI5Lc2ZHuKVdYZMt4mTxoKWY5DmR6oYaVQcCsiotd9ro0Dr8guSw3iGt7ZEXGrhC6vNdWlfA8Pg8Xi0r4yPcnNRCWX3RdcCEQUNYfnqwawkm6YkwRbLzHVi0x7/aZWAspAYktdTkgzI++2WDAALtudOA8njKbeRJ4uimuXCn2cw47/MM2pklnjuM89Xh1v1WpzPiAHwBt/Z1GVcGTC94ums03/dR5QXrDE+TiVIr1QHGUm4guqpcYopZ7iFc9ka15G75fjyBjLGutLROghjhVZapIrPylzaJup9LdrbBFL7GyMIblsaO7d3Puu+HJqXgMZHcCSbgjEaqMpIhftIXPFLDfEJMd0MYg/QCS0JHZAtU5ErH1Yf+NTf6rr4VQ+58BXg1KOhYKVLu/1NR0eiQXfWC1/jPypP0c0TwWFVR4KMVhw/T+C2d8EtZuOSOHdMVO/jZZjN7pfEUaCtQJJPu2rgUBL4E7l6wmkkC78tv7AQqRcXetLfcni6EQUdmBAQKWSYSDihgU2q9491wZnHd/nIkLeOsGrQG1K3K3p
 og8FxNdY
 J5stF7+jdQjytpmUBTlmn1Nkb0ohvzyATLLBFOtaw+w3ouBzAZAAE9tBmdTr1FfCw9slwrIKioGVd8doGF8fb7rNwoQ09hKJ1IGhk840xZDSVsytN5lgMDx3frBYRmhiOwaGB/MvCwe/7W55hl/kvTWfoaTWlDI6J9kDmYuDeMnQfPk7T43uLVxnz1WQTdvpzhutxrq9GhKnGNyeJy3xGFyoiOE2tQvwU7cgC3sNnyN92tI/SB5uD4YpZIAvj9ELLnGMbMMEP4f+fuQLRum2zrS/mDAR1Fp9qoUgBK8mSd0G7EANTC2z3tXKTvGxkL1mf1t/zA374ESa+3L+i5osKvswnIGp4tYOFyDmZsNuZ83pilr/29cgXMDH6TEn524giG3SlTuUTgqa0k9t8aSkKghUHdvvCeNNwAGT2TmomGUrNGLvPKC138GIueLc92w6axoVGcYJvEzF5IWPUeb5lYCqhado7OKoJhelKE2gfSlolVZGEJR8YpmiBOqNJiP6IhjJj6K8KJb0U/6Nmtu17dCVDezKqb23OMuCrYWnfLYX9uef7vCQAo7Al9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Mon, 17 Aug 2026 17:35:53 +1000 Balbir Singh <balbirs@nvidia.com> wrote:
> 
> > On 8/17/26 4:08 PM, Hui Su wrote:
> > > migrate_vma_insert_huge_pmd_page() calls flush_cache_page() before
> > > replacing an existing huge zero PMD. However, the third argument to
> > > flush_cache_page() is a PFN, while addr + HPAGE_PMD_SIZE is an end
> > > virtual address.
> > > 
> > > More importantly, the mapping being invalidated is PMD-sized rather
> > > than PAGE_SIZE-sized. Flush the whole PMD range with
> > > flush_cache_range(), matching other huge PMD invalidation paths.
> > > 
> > > Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> > > Signed-off-by: Hui Su <sh_def@163.com>
> > > ---
> > >  mm/migrate_device.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> > > index 908d2d4ec43a..098c04c1b124 100644
> > > --- a/mm/migrate_device.c
> > > +++ b/mm/migrate_device.c
> > > @@ -872,7 +872,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
> > >  
> > >  	if (flush) {
> > >  		pte_free(vma->vm_mm, pgtable);
> > > -		flush_cache_page(vma, addr, addr + HPAGE_PMD_SIZE);
> > > +		flush_cache_range(vma, addr, addr + HPAGE_PMD_SIZE);
> > >  		pmdp_invalidate(vma, addr, pmdp);
> > >  	} else {
> > >  		pgtable_trans_huge_deposit(vma->vm_mm, pmdp, pgtable);
> > 
> > Reviewed-by: Balbir Singh <balbirs@nvidia.com>
> 
> doh.  It's a shame this actually compiled...
> 
> Can we add some speculation about the userspace-visible effects of the
> bug?
> 
> I'm assuming we should backport the fix?

Hi,

I took a closer look at this, there is no userspace-visible effect today.

The architectures that currently enable ARCH_ENABLE_THP_MIGRATION use
no-op implementations of flush_cache_page()/flush_cache_range().
32-bit ARM has non-trivial implementations, but does not enable
ARCH_ENABLE_THP_MIGRATION.

So this appears to be a latent API misuse rather than a currently
observable bug, and I don't think a stable backport is necessary.

Should I resend a v2 clarifying the userspace-visible effect in the
changelog?

Thanks,
Hui


