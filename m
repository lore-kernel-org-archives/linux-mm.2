Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95507CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 03:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5ADB8E001B; Tue, 14 Oct 2025 23:06:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D32498E0005; Tue, 14 Oct 2025 23:06:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6F418E001B; Tue, 14 Oct 2025 23:06:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B78DC8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:06:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E7CB47A73
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:06:51 +0000 (UTC)
X-FDA: 83998861422.02.ECC1B5B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5ACD240012
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:06:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OqJin37f;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760497609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2IvZFH1GlxbOlwBO0vn3PVp3T0hjKi4CU/igwLjmMB4=;
	b=Km4bDXqH/CdrmPVo36WNWTKT5SwcImGNjsNlQfQKoIta2ifeqxY175n1+Q+njeEpltbgmp
	WThudYCjnX6v25y6CMEQGxfp9I8hcGnG7nUZIDUd+2Z2db87mbKq/kDjvW+sRPBGX7qQ7q
	lC5Y0K2ZrOFKRK40gnpzSGlYzXWjcpw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OqJin37f;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760497609; a=rsa-sha256;
	cv=none;
	b=lxhf1D3Lw3u10nupeBsqrSAFCMxl5t+47Ok9bbtM/FmAr3bLn49OZwct4Ns699C5T/jvPV
	utCTJHjXkW7gAsDZXI1KHEnlkysyyb1AV9QH1qxdEYuwD06irPbUnpr15+hc8n35k0KTED
	YPD356aDk7JlzMx5RaA419v//gWcMCk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760497605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2IvZFH1GlxbOlwBO0vn3PVp3T0hjKi4CU/igwLjmMB4=;
	b=OqJin37fHF/jmDY2VWfWQDuFLtlTv67+1iB6FkMrngbN93y+2Iho29SsN7qzhu2vSzInpc
	/fAIx7s5ah/zAjB145dLBCSnn+OlqGNcrC8WCUyDdTj5PFeL72VZ3TC8/IMNQIr6qXMFjq
	cf+O0zCltRNKuDa6sLecAHLP+HZB37E=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-641-Rq0xx_EWMPaH60t9QpDTlQ-1; Tue,
 14 Oct 2025 23:06:42 -0400
X-MC-Unique: Rq0xx_EWMPaH60t9QpDTlQ-1
X-Mimecast-MFC-AGG-ID: Rq0xx_EWMPaH60t9QpDTlQ_1760497601
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 761871800350;
	Wed, 15 Oct 2025 03:06:40 +0000 (UTC)
Received: from localhost (unknown [10.72.112.19])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4743D1801AD7;
	Wed, 15 Oct 2025 03:06:37 +0000 (UTC)
Date: Wed, 15 Oct 2025 11:06:34 +0800
From: Baoquan He <bhe@redhat.com>
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, youngjun.park@lge.com, aaron.lu@intel.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Subject: Re: [PATCH v4 mm-new 1/2] mm/swap: do not choose swap device
 according to numa node
Message-ID: <aO8PuhNfKOQ8SJUV@MiWiFi-R3L-srv>
References: <20251011081624.224202-1-bhe@redhat.com>
 <20251011081624.224202-2-bhe@redhat.com>
 <CAGsJ_4zvtdqzvBNmQjMy0L6JAz_XpvR=rGgNC_Xdo36QVW-g4g@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4zvtdqzvBNmQjMy0L6JAz_XpvR=rGgNC_Xdo36QVW-g4g@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R-G776QySuhDHCIgRkndJH-uLGYWfxoMg8o1_SI_UBo_1760497601
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5ACD240012
X-Stat-Signature: 9nrcmrezpwp4j18o1ror3cewq9m869g5
X-Rspam-User: 
X-HE-Tag: 1760497606-71398
X-HE-Meta: U2FsdGVkX19+3/hlnm5nK6UNulvaOXokhj6FJf1i3NsgeKGMFyTDD0p6kfFJNQUUBwDJ8JY6IExnN5fY/42ZH/pfAjLNIpOj3RXMsMpX8k5ycbZLx2mC49SFB+FmQ4EZJEG+LROyX4WyZamZpqfiuDMsCCjwdl8svJ/2HX5oA8XP+uQuBmY89mQIKBVTw2PSo2nYeYXqmgDWvnL+QCQh9IHAZ2NpBcjh+zMXN1DRi08dMwEYNpgkF1shsEEsEaAduKeugHx4laaE7isGBkRvW6R/OaZksofjB6u/w0zoiZa9GsE87Q/cd/n0ebULpOgtOdu+aRCou3UdonRAQuKp1lCZclpEjhCPtKtZWy0jjt94clH56UXCijOIDoLCwK2CbXthUjnzsm/9Tu5FVIH7vTe6slw+2A62mHiYRvutjpH8cnv6qL3jWjhw1pO8zb0nIJdAo2jgTMHG5+7gdCqYfYNF7lv4mKV1fIxO8l3zCL958SCpr5ELnbpP5fRc6ApE7VVdED9R3POoQWMVR4eR4uldlfOIbulIu0zmy97QMRUOydsexnMoUoiN1FnuxqBultnzpecZx+mW84TsgrIA58+PGgNCT0969sOKMWFpTkZ2mbgyH9SPxq4zd8PcSiwMkUqP9Eq1C1NGoHexVKtZ0LAQ7mDKQxZsvJZctObMZuppyRw7JG5z97raXkzY+crLbN6FmA0LVIXpJluJ3to5wUUbzz3LbwG78ityXpBzzioF+fbFMiomydc47ruNtJOC0vdPg6gv9W0dwmOMeuBMizIrfCAs2V79XLVi0r6zPx/PMukzDTDQzGA9kstGWblCpOWaNQ5UG+vyk81Ksc2bHfOtsVTQx5JDOJj2syXU0CZvJHhgSkoraSILnoW5jBfMtYr5FwuSFN667WjLEy4niOJ3C+qb2JIx3zxfCPucFQn5+jpXf/OxR8VlkcvDJUrTGCX+xs+apUPn7HQMTzV
 m0Z+LmCu
 kX4fp84N9r52pWJWf6r3JXUmyjqGmgv4tS5p5+7SzyO/C0RGYbBFqpIb8G/r1N129vY8u0BM2Sdi0bGtNA4E+qfEVjkjKOt96drL+w29Erhh9PvKR7dWAjAOume7jLvuKw6qClhmaSRyyhSqsooZ4hryvmkDoT92PfubK1dwSA8T7zewXkZ1hD2khnc74lP/CO5+cnfKJ7jJMc9m3LIYkbgZ8Wk0EC5z0P8hRF/wPOrQwWNSmtLw8KLhvHQtUYPRzvNd1XHEkxq1+ZDJSTw2CmhgPYQkJ9yIIN5X31VKEYLEmUtoGHP5CoKbJfgBFydGtKuzqFh2lthjE3Pij+KQyjog8Lso+wN0IhLKjcskrnQh/GEguzP1UIlrgvDZG3PafRHPj28hNPxvKOyE0muEcukE1Nq3m19kcGVurHApyybpGH8UeublQjDi/tZERr9K6s1tWUs5ngK0brL1sqqnur03oV7zQfvv9KjIi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/25 at 02:09pm, Barry Song wrote:
> > -static int swap_node(struct swap_info_struct *si)
> > -{
> > -       struct block_device *bdev;
> > -
> > -       if (si->bdev)
> > -               bdev = si->bdev;
> > -       else
> > -               bdev = si->swap_file->f_inode->i_sb->s_bdev;
> > -
> > -       return bdev ? bdev->bd_disk->node_id : NUMA_NO_NODE;
> > -}
> > -
> 
> Looking at the code, it seems to have some hardware affinity awareness,
> as it uses the swapfile’s bdev’s node_id. Are we regressing cases where
> each node has a closer block device?

I had talked about this with Chris before I posted v1. We don't need to
worry about this because:

1) Kernel code rarely set disk->node_id, all disks just assign
NUMA_NO_NODE to it except of these:

drivers/nvdimm/pmem.c <<pmem_attach_disk>>
drivers/md/dm.c <<alloc_dev>>

For intel ssd Aaron introduced the node based si choosing is for, it
should be Optane which has been discontinued. It could be wrong, then
hope intel can help test so that we can see what impact is brought in.

2) The gap between disk io and memory accessing
Usually memory accessing is nanosecond level, while disk io is
microsecond level, HDD even could be at millisecond. The node affinity
saving nanoseconds is negligible compared to the disk's own acessing
speed. This includes pmem, its io is more than ten times or even more
than memory accessing.

If there's a real system which owns disks belonging to NUMA nodes, we
can test to see if the new round robin way is better or worse then the
node based way.

Thanks
Baoquan


