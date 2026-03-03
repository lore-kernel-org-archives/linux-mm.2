Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD2FE67A85
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 07:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C04926B0088; Tue,  3 Mar 2026 02:14:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2F86B0089; Tue,  3 Mar 2026 02:14:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8A676B008A; Tue,  3 Mar 2026 02:14:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9AA4E6B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:14:55 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 32D241C8F7
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:14:55 +0000 (UTC)
X-FDA: 84503889750.30.B76D437
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id EC9B440010
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:14:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jJ2X0MwT;
	spf=pass (imf11.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772522093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9B1vm61hQWMqh1uv5nPphqUFUMsCP3FqVuJ4rL+XdWY=;
	b=Ef25dH4FDlZFahcflDkkT/TUlCRmMilbHEUzOLuJAL8t5qlkHd+Y7tOuFKBXsVV/OlWDHw
	Hnyqv8kbI5U8sc4bHdG2Ic3WAE1CYB4SHV2Xugbyu6I/84ONiJOZ5q8EtH5R+4eolkDyYo
	phzMgwDdu88zaImobzTMlfXQodswIHI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772522093; a=rsa-sha256;
	cv=none;
	b=0kL5REQgRDrHvfgQw+v64gTko45DiUWQilHO3Gz23sVPiYUFTF67GPHir6tgy7A8q9uEay
	1t3N0m6dFeV+pPUADluqry8MOnQYuPybtXeReDfY4hi/G5oE82fIUkZ7ZPlUgdl7baIem1
	tQ2qm/Xzy1WC+5JhPV7BNJJt0TUMuws=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jJ2X0MwT;
	spf=pass (imf11.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772522092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9B1vm61hQWMqh1uv5nPphqUFUMsCP3FqVuJ4rL+XdWY=;
	b=jJ2X0MwT101PdOwCR141VtHFcO7tBxsJQYyWboizPXtINGWTYxdvEn+zFfT6iTLJrJj2CW
	64Z1CYFfI2sYbV8hvUVUFAIp/GD6m1RJhdIWBYsloVZLyXeouAoyB1nxxxWfEbGHhw+W+u
	D/sSNhrG4bqC2gOu+5YK3qcgx/rE9ss=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-688-spsLqiq6ONmkJVbZdMMAEA-1; Tue,
 03 Mar 2026 02:14:49 -0500
X-MC-Unique: spsLqiq6ONmkJVbZdMMAEA-1
X-Mimecast-MFC-AGG-ID: spsLqiq6ONmkJVbZdMMAEA_1772522087
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F7001956096;
	Tue,  3 Mar 2026 07:14:47 +0000 (UTC)
Received: from localhost (unknown [10.72.112.42])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A89FB19560A3;
	Tue,  3 Mar 2026 07:14:44 +0000 (UTC)
Date: Tue, 3 Mar 2026 15:14:28 +0800
From: Baoquan He <bhe@redhat.com>
To: YoungJun Park <youngjun.park@lge.com>, Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org
Subject: Re: [PATCH 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <aaaKVKltqhdoWreP@MiWiFi-R3L-srv>
References: <20260302104016.163542-1-bhe@redhat.com>
 <20260302104016.163542-3-bhe@redhat.com>
 <aaWaM57jui+iuEj1@yjaykim-PowerEdge-T330>
 <CACePvbUr+xEs3zM_g6ZhwosF=Qt2=2W5fjYPs4gDL6MTo9rmrw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACePvbUr+xEs3zM_g6ZhwosF=Qt2=2W5fjYPs4gDL6MTo9rmrw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hjyaYaQXNiByJ49J_BLCgKxf-CS8-aCWJndbmAIcOL0_1772522087
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wjeiaegjipijzbjzij3jnfjiayc5onm3
X-Rspamd-Queue-Id: EC9B440010
X-Rspamd-Server: rspam03
X-HE-Tag: 1772522092-860860
X-HE-Meta: U2FsdGVkX1+CPPPa4odfn0VWM1AsKWnppAtMps1vKRltvlGkE23TmtKrXvkIkKvM76uJlge+NhV9Rz3mJs1K+G3ZDxwrrfcTvXXek5BqgLF1TiS30b+iI387nh37KwtwigjtGHe2stwfrDCC780OhKjOTjorRCCyjbZB4WoRb0+lABUMo0GmNxgIODZKWrCiHqE91GIthgRFKBy8ZUc6ZQXzP4XyQAZmRejYsNNaSUzICn2kuCKw7qUaROPp/EsjY+3Q5KeIUJXmsp2kUh5cFhr7kc86WHkqPLvYCyoXJOuHVZ5gAasscXzrozOJwE+tGSHi4u54T0Kbrdc+/Vg94BkWZuoc+kyUJMtZrObANKFPSHbWikU7M38pO0Y1t5+mnbJiwxpFtS0JYddfoZriNMV8Fb0G0ywwOkT6HrFJtC00ce84qJqnkSVgwPDDnTwwolmr1M0ytFR3wrApbwOSiSOwksA17E+eoIvoN54QTRs/zGugmOS4RWwAPjZmtzlkkFnQVElp2ihBHyppBlmrtIR8DcpATJnwBfOVQigmJ5brpIPTK97iksJPXtU4PLli3ykaFxnJpvvXkze2eqqb1DQw0MF/dgDuSYVums3J1DP9EUOI4qS/Yr/IY7ELm+M5O4YU4p8bqrmiguQy+rHsJrXNVDKU0GxsYO5bb74097y5czGzBeWwf3gqz1c4YHe3nKiGmfmT3Z23DNG0FymO9+sATPF/V0Wi9eVF5eFUkgyt1/0z8fs47LZEcySlh0o13wdqoMCMYOcQqU4NjOJmgbKoeRlGqM08hZdOVFguQKha3MyGxWhkmaSG6K2ICSRf9LJ7Cm4peTU5mS+JoNzfXvwapc3cs3UARUhaaie4nyLYL6qZ23IoGvMEPxIHigBFoD0Y9D/VVe3nA5+fBW+ge3jqZbSJ9EsnMk/0xYmA9Uj4nEwPlTQLHMfDgewQLBperJkiEzGTmcxOsC7Sptr
 uFNFb2vD
 TXTXu8xMxll/VjZJQPOlnqJa7evtjEXK+Xu51LhZlxbYe9nABR+Jf5MTAXAGRH64iYWsELmACl2bpD60GB1LOhrlyKllkGRdKh4IiweNlr9VUAbKcdqIvMvFmot99tiWxMxL8U0c7q4d5UtTr6Ity9Y4GZLcj4NvdZu++JiuQFK9wBH8kwboDzlHwkAZU92iIpxL4toVlzJWFlVvDWq/utKxM1icAJRJ0ePUm2QBES5jXJ9/ncHpFFa80uzJNe+G8JgysyK6G03POf4YVeiq9V191YDtDg2SaUZjxNjxLDkppWNsDa/icEF+ItIxAkz2TI98eq3M/TZpYBwQbTC6UXk+BMWo2pTN097n2tHGP/xqWknY7APmZA3G4rlJaMjmYe9zytyEWQwVmk0LceULYyuJ4KKQ3BzK3FTsSqtxLmaaA+jS4uYflmqF8RQMRx5Vu9akGmiCcVIgttpwqF32IP2YGB76vSbYXx4Ce0CiuRrHpuog=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/02/26 at 11:35am, Chris Li wrote:
> On Mon, Mar 2, 2026 at 6:10 AM YoungJun Park <youngjun.park@lge.com> wrote:
> >
> > On Mon, Mar 02, 2026 at 06:40:15PM +0800, Baoquan He wrote:
> > > This simplifies codes and makes logic clearer. And also makes later any
> > > new swap device type being added easier to handle.
> > >
> > > Currently there are three types of swap devices: bdev_fs, bdev_sync
> > > and bdev_async, and only operations read_folio and write_folio are
> > > included. In the future, there could be more swap device types added
> > > and more appropriate opeations adapted into swap_ops.
> > >
> > > Signed-off-by: Baoquan He <bhe@redhat.com>
> > > ---
> > >  include/linux/swap.h |  13 ++++++
> > >  mm/swap.h            |   1 -
> > >  mm/swap_io.c         | 102 +++++++++++++++++++++++++------------------
> > >  mm/swapfile.c        |   2 +
> > >  mm/zswap.c           |   3 +-
> > >  5 files changed, 76 insertions(+), 45 deletions(-)
> > >
> > > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > > index 0effe3cc50f5..448e5e66ec5c 100644
> > > --- a/include/linux/swap.h
> > > +++ b/include/linux/swap.h
> > > @@ -19,6 +19,7 @@
> > >  struct notifier_block;
> > >
> > >  struct bio;
> > > +struct swap_iocb;
> > >
> > >  struct pagevec;
> > >
> > > @@ -222,6 +223,17 @@ enum {
> > >  #define SWAP_CLUSTER_MAX_SKIPPED (SWAP_CLUSTER_MAX << 10)
> > >  #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
> > >
> > > +struct swap_ops {
> > > +     void (*read_folio)(struct swap_info_struct *sis,
> > > +                        struct folio *folio,
> > > +                        struct swap_iocb **plug);
> > > +     void (*write_folio)(struct swap_info_struct *sis,
> > > +                         struct folio *folio,
> > > +                         struct swap_iocb **plug);
> > > +};
> >
> > I think swap_iocb is only required for fs-swap
> > (swap_folio_read_fs/swap_folio_write_fs).
> >
> > If the goal is to support fs-swap through swap_ops, it might be worth
> 
> Consider this series as a starting point for discussion. Nothing is
> set to stone.
> 
> > considering a more complete integration, including activate/deactivate
> > and swap_rw from aops, rather than only adding read/write hooks.
> 
> Can be add as follow up patches to introduce active/deactive and
> swap_rw from aops. In fact I want to see it as incremental patches
> rather than add every possible swap_ops in one go. It is likely easier
> to review as well.

Ack. And thanks for bring this up to Chris, I should add Chris's
Suggested-by.

> >
> > So.. we could keep SWP_FS_OPS as-is for now and just split
> > sync/async paths, and revisit a cleaner fs-swap integration later.
> > (I mean removing fs ops, and call swap_read/write_folio_fs on sync/async ops.)
> 
> You can propose incremental patches to add your additional swap ops
> and into the series as the later iteration.
> The sync/async split is just a MVP to introduce the first step of the swap_ops.

Agree.


