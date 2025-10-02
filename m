Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72A71CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 13:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 724DA8E0003; Thu,  2 Oct 2025 09:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D59A8E0002; Thu,  2 Oct 2025 09:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB348E0003; Thu,  2 Oct 2025 09:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B1D18E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 09:09:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE219140507
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:09:29 +0000 (UTC)
X-FDA: 83953205658.09.DB4E2D4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id EA7EE80019
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:09:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DnaUtH2B;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759410568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GWUDNEuVsrVCuZ4aXT8MiKkM6HaWCbvQq8AyvQB9qsY=;
	b=lIKnOXgs0fsmtvj+vbj4pV3QfcYTE4CgvqhnYREV+NNRbSqTLzm+EMG7cPh0a2iEluwpoZ
	lxwAcfzYSjLitejWZ7ctvd4zR2IAjqoSE6SlMTzeQOC+nhkgILdhcQgAd+1dx0WlcpCWzN
	7+WiB15mGdr1sZv17eaVtLntIsABHRM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DnaUtH2B;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759410568; a=rsa-sha256;
	cv=none;
	b=fsvvJVej77jm3OTnLjjedS2q+4SIvqDN1yrakUvjf0LKe98VrmFbZg6TZQMHLBIB+bBdS7
	nxHojmXQ3tupcnP3MxbHgcnciLSBoSVkurxiE4PSHfOg2fyUj+O9LdlgzRIBrvPWrQUQfc
	1EP0iVuumsBrIxq8uf8CABk66ZcrI1Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759410567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GWUDNEuVsrVCuZ4aXT8MiKkM6HaWCbvQq8AyvQB9qsY=;
	b=DnaUtH2BUW+oK4pwUt1nRLI4nKNg0LlyfLP7Jbm/AGGM7vLj04kAk7MtE1Gc79rc+SM/+4
	OUVDx3QCUB6nMa0FUG9jNY3E5A6wErXNpS7uj4UqNG6lfIBXewhgS0eFzJk6J7Cub7E2LY
	Z49ZlmEWihM5N4vLDIcfH6no/5Ty+1k=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-HEVvXC-zOBGGxQtVAfkgKw-1; Thu,
 02 Oct 2025 09:09:21 -0400
X-MC-Unique: HEVvXC-zOBGGxQtVAfkgKw-1
X-Mimecast-MFC-AGG-ID: HEVvXC-zOBGGxQtVAfkgKw_1759410560
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D7B90195608F;
	Thu,  2 Oct 2025 13:09:19 +0000 (UTC)
Received: from localhost (unknown [10.72.112.47])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9EE5A19560B1;
	Thu,  2 Oct 2025 13:09:17 +0000 (UTC)
Date: Thu, 2 Oct 2025 21:09:11 +0800
From: Baoquan He <bhe@redhat.com>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com,
	baohua@kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com
Subject: Re: [PATCH 0/3] mm/swap: remove plist swap_active_head
Message-ID: <aN55dzagMDhZEAQV@localhost>
References: <20251001043436.41338-1-bhe@redhat.com>
 <CACePvbXjLqcz+Smz+woQEKbGdCP3DwgPYvJfLRLPiuHsv7-q_A@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACePvbXjLqcz+Smz+woQEKbGdCP3DwgPYvJfLRLPiuHsv7-q_A@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ioOQc21wOZ2GE85PLmbVxLkKhFJdlZdmUAw7bJDWs7M_1759410560
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EA7EE80019
X-Stat-Signature: mcsjmu154d8xgnjw3t7cn6eth3djub7m
X-HE-Tag: 1759410567-463615
X-HE-Meta: U2FsdGVkX19fzBTLHeajr0kAZb5Igryddo8i0+1sSwuNO2EehApwQkUZY1F9bJhHhSmtH4YU2G3+o5VqEPkZsofPKtSrJ8z5/a4uf7FKYhu4GYbjUzyu5XVB78M/0Qy3x8lCF+KIw5I55iV9t5MotMsjePaxK7FSr6r++ztIw+cQjZBaj3o+8rJqDUQTGnRTVnGaROYwgjkiCp8QyWJB9FJj6B+9ScwugL8n6CUQIIgpYoS/HmpSHQ314vkhtRKEGt3Q1zAvk+VNTGPsplBgPWby40gwoXFuPLv2UCxpfssvYF2+DsmPqOnBodtBmd6nr02kIeazTNZTklCXLtkq8t06OuubqZvgB9oDZBM/vrMLXt/OSVZRZ+odUWmUXaXY1o0dtPseMHXuwVC+XTrMpKvRjosneoHruelpXrgVqGnMkjkOWH6oi7+5PCJk5IPeUgMn/9vlo0c1Pk1goUAZLVl50Cqv+5HkrMUE+Atq6CqOuXIk3sPBGlGXiJo00KkZEIvTruQFsXJaB8vyj4BMfSkGWJrHLxmEQO2f6m3g8Tgx+9dX8D1wG+6Bkb6t566SjLpRM58B7EhpW4KgCuTxP3CCzTQ1TW7uT4oh0SQZSennmVSZNFaR4p3l2uW82JnKfRQNnicmsu/iD5H28wFv8OGLL94joW9UNenGbMJrZujFvkrYF99jtu66sRvor8lhnMin8O38OGyzAKV3uMRPtSO4krBLEo75mzA8PAuCVly4P7ZC/XgOcnhSRwj/jat5N63/Vqf5Qfb0lZk0PsjNw/7I4upi/NZ6sRFdvvvf0LjiVOVng8REMx7Vlw65GcGQTYY1kP02Y7eq+yrM4r20sFiPCqr3KC5b6tpV8q7kqYoTb/l71xLEiaBLToFrL5JVy0g1bue++8lVFtN7/MFkNC40onOig7scrKFtt7GQt/FwReUpB+DKVICg2PHWpnKVan2jyOCWAVu1B2Wr7FO
 lhSmamQA
 UmlOYjiPSqC7GX1UIG7so4jM/04TOKlIsXojnhf8iO60TUcrPGG44e4IVfyvLGt3tgybSKrChmV8N27wz8WCPPRUQMV26Ksp8QcuCLEhLlRaDVSk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/01/25 at 11:04pm, Chris Li wrote:
> On Tue, Sep 30, 2025 at 9:34 PM Baoquan He <bhe@redhat.com> wrote:
> >
> 
> Can you please confirm or deny this series is depend on the "[PATCH v3
> 0/2] mm/swapfile.c: select the swap device with default priority round
> robin" series.

Thanks a lot for reviewing this carefully. This series depends on
patchset [PATCH v3 0/2] mm/swapfile.c: select the swap device with default
priority round robin" series.

> 
> If it is depend on that series, you need to declare that in the
> beginning, so Andrew will not try to apply it without the depended
> series.

Sorry, I should have told that clearly at the beginning.

> 
> > In mm/swapfile.c, there are two plist variables, swap_active_head and
> > swap_avail_head. swap_avail_head contains all available (active, not full)
> > swap_info_structs orderred by priority. While swap_active_head contains
> 
> Nit: spelling : orderred -> ordered

Thanks.

> 
> > all active swap_info_structs (active, nor full and full) orderred by
> 
> Same here, ordered.
> 
> > priority. Earlier, it serves three purposes:
> >
> > 1) When swapoff one swap device in the middle, swap devices of priority
> >    lower than the swapped off swap device will be promoted up value one,
> >    e.g, I swapped off zram1 of priority '-3', then zram2 promoted to
> >    have priority '-3', zram3 has priority '-4'. This is done via plist
> >    swap_active_head.
> >    - This code has been taken off in
> >      - [PATCH v3 0/2] mm/swapfile.c: select the swap device with default priority round robin
> 
> See above, if there is patch dependency, declare it early.

Agree, will do in future posting.

> 
> > # swapon
> > NAME       TYPE      SIZE USED PRIO
> > /dev/zram0 partition  16G   0B   -2
> > /dev/zram1 partition  16G   0B   -3
> > /dev/zram2 partition  16G   0B   -4
> > /dev/zram3 partition  16G   0B   -5
> 
> I am a bit confused. If the "[PATCH v3 0/2] mm/swapfile.c: select the
> swap device with default priority round robin" series already change
> the default priority to -1. How does it get the -2 -3 -4 -5? You seems
> describe the behavior before that revert series. Can you please
> clarify.

In the given example, It demonstrates every device will get +1 priority
promotion after the swapped off device. 

I just intended to tell the purposes of swap_active_head in the current
kernel, since my patches haven't been merged. I also had a feeling this
description is messy before posting, diddn't expect it could cause these
confusion.

I should have mentioned this series depends on "[PATCH v3 0/2] mm/swapfile.c:
select the swap device with default priority round robin" series, then I
don't need to mention this purpose of swap_active_head, that could make
the describing easier.

> 
> > # swapoff /dev/zram1
> > # swapon
> > NAME       TYPE      SIZE USED PRIO
> > /dev/zram0 partition  16G   0B   -2
> > /dev/zram2 partition  16G   0B   -3
> > /dev/zram3 partition  16G   0B   -4
> 
> Is that the behavior before your reverting node id for swapfile series?
> Assume it has patch dependency on the earlier series. Wouldn't better
> you describe the behavior after the round robin series and how you can
> do better?

Right, I agree. 
> 
> > 2) Find a swap device in swap_active_head when swap off.
> >    - This can be done through iterating swap_info[] instead. Change is
> >      done in patch 2.
> 
> Can you please clarify what is the benefit of remove plist swap_active_head?
> e.g. Does it simply the code or make swap code perform better.

After series "[PATCH v3 0/2] mm/swapfile.c: select the swap device with
default priority round robin", plist swap_active_head is only used in
swapoff api to scan it to find a swap device according to the device
name. It can be replaced with scanning swap_info[], and there's no
efficiency degradation. And we can remove field "struct plist_node
list;" in struct swap_info_struct, and the relevant handling code which
is unnecessary. 

> 
> > 3) Judge if there's any active swap device via __has_usable_swap().
> >    - This can be done by checking total_swap_pages instead. Change is
> >      done in patch 1.
> >
> > Among them, the purpose 1) is the most important, while it has been
> > taken off in below patchset. So this patchset removing swap_active_head
> > sits on top of it.
> > - [PATCH v3 0/2] mm/swapfile.c: select the swap device with default priority round robin
> >   - https://lore.kernel.org/all/20250930063311.14126-1-bhe@redhat.com/T/#u
> 
> It seems you mean to say this patch series is depend on that PATCH v3 series.

Yeah, I should have mentioned this at the beginning to make the log
clearer.


