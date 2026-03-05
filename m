Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB083EFCE5F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 05:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC39B6B0088; Thu,  5 Mar 2026 00:18:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D71316B0089; Thu,  5 Mar 2026 00:18:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7DF86B008A; Thu,  5 Mar 2026 00:18:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B42B06B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 00:18:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 548971403F6
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:18:44 +0000 (UTC)
X-FDA: 84510854568.16.74C1BF9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 24A0740005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:18:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VuPkcQoy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772687922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2eWaG4AAm/ZvG/U11Toj0Ut+QJaBBSiqacL51yLdDNY=;
	b=I9FvyFETO5tqgepGh8WCVU2Vc4UOT+W5GTMaLad8czccjrL00H8mmgnUpyHKyvLC18Gx9d
	kM8IYojSla0GaTB5JQHMNiYdRH1B/YUq2N885fSWv5CB1xbK7pw2CkKF/Z7xijZimd2D8j
	jEIBxAyEJCqxtjCrHevxa+/ybMtXKcM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VuPkcQoy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772687922; a=rsa-sha256;
	cv=none;
	b=Weul2UXZxDL6u3XBDicpbAkKvcBgsYYYSSsODTsLQ5uqoYfsRnc+eqzA6088x3bOoAuQYc
	1EbGwfUohFIp2640oZ9lt783JT2gAhzsIOnqGAjvbtxd/DHOrooK7rkPm9mHwdgnCtTSWq
	qalSZxWKoIvSF1PObRVCCNLqSZQ+x8o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772687921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2eWaG4AAm/ZvG/U11Toj0Ut+QJaBBSiqacL51yLdDNY=;
	b=VuPkcQoyiV0TvrTFX+x/DrjXtGzcG89EdveDrdrIfODZJVAEjo6uYAH2A0EqGExeQ34TeK
	NXVPyAXFriTuF2tX/Y4KxsaKq4grbrMA3cE5V5OpQVJmcFeWpHWQteyg3fl11tTRSPWscS
	4QyXAMjCC3mdJMs2RA0hll3rhDW4RHE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-277-iDQZbk7NObijYi5gBKIu4Q-1; Thu,
 05 Mar 2026 00:18:37 -0500
X-MC-Unique: iDQZbk7NObijYi5gBKIu4Q-1
X-Mimecast-MFC-AGG-ID: iDQZbk7NObijYi5gBKIu4Q_1772687916
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C9B21800561;
	Thu,  5 Mar 2026 05:18:35 +0000 (UTC)
Received: from localhost (unknown [10.72.112.118])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6FC6C1800576;
	Thu,  5 Mar 2026 05:18:33 +0000 (UTC)
Date: Thu, 5 Mar 2026 13:18:27 +0800
From: Baoquan He <bhe@redhat.com>
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	baohua@kernel.org
Subject: Re: [PATCH 0/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <aakSI_0O0G6arjZO@MiWiFi-R3L-srv>
References: <20260302104016.163542-1-bhe@redhat.com>
 <aaWiBaeSCILBCzqd@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
In-Reply-To: <aaWiBaeSCILBCzqd@yjaykim-PowerEdge-T330>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SHSzm2k4pOLoXHqC5Gu-jJ_ZY1ZwGh5tMNk-s0ANopI_1772687916
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 24A0740005
X-Stat-Signature: jxy3ghna8rdza7z53kidpf4z9hgm4wdr
X-Rspam-User: 
X-HE-Tag: 1772687921-225338
X-HE-Meta: U2FsdGVkX18TKdm+/P0M1OFZOeP/KSelj1E1nm9bTnwSCXZIt31hUhRlG1hogF11/NBJfgkFaoamN+bn04+d12hm4hkGeF8dhL8+VK23Q3NBohdBOBcQSX86qERlofasEwP3X7N106X3drQY3vDuGla8Pv0X0jMReo0LgDA3XLXAaBMd51jQTQQvL3XKphI++dDeFpVidHqgF4MRBG1WWSdZUFhOJ/xbCrufnBzWKlqBjLvVYi63T76DIwsScjhuEIXWzlOnh+FUibjq7LjYVwz73Z+wPMKsiyxZULG7J1TifIM5e9MvlpZ2h4QfUvGaUjYWUJOs62sFCNRdnwwTw20n9qcv66l5tnTVeEWyiMyNYWa7IbJEN7nAgbq5RffoErbfGhXh7Esrk+jdfcX7FT30YGhn+Fpn4QuvMjaEQnkiALeaicJQyB8ElNcMb5RaMqrjhvlilatRK8JPafVO6utxLHb/ZZRHlmca2lklezfxxfGD4lCBrKc0ETHzk1hlh0CymIUJBVOz6YzJNolQ363JBtytnW9rikZZ7d1uziP4aXjaUfORelSreD2ct7BtM9zAYr1uedKVRJ5yj+CV2ivN4Ufk2KsRb8Hyqvkg9l+redR2i508KXmR93nff+J8/IIXYKcq+dvJlVnLnvxaFFX2c421KzOjXjbTZbaaz0TAydtkQ82rP0OukGtLcZEJh77sIykMyA3tJ7Xd9rFW4OHP7kbzp/RduXStJf/xPcTW4ZOQPheSpKvFPZve8P+AD6IEpg/Y29bD/jeLxLYpFxKA+QlQdQlPzFKKeOKy7ZIHC6/j0W6D4O75RrmTp2+t7wjPF2+BqUE2EFoTTdbWVdCh3RusldN3WcEcrk/zbyXKQee87P4KvvN2iyh402ohHcLJ1J7ku8rkvbeix554LdSUrXlVJDEKcC/qJKgm637tY6Lupp5KOg8gIyCzDJKaQ6zvCGJY+210Xut/KmS
 Ory6ViW9
 hFx74eq9EVlSmLtp7fP1ZFiI2igjxU0hQqiQ8GzS2p7qQ+mQpC3ya7bz3X2ZvnrdrZ34voSlDraJwvGHHNfPHPMYoqQ/mic0bNOhtIywmmIf8cM4qUYOGJV1gaz45zDFR0RGeWdFSLfP7J4fRfUyUGJvFYKYq3Q79oQEBaerLrjjd82w/POpY8YQaA0WS2DSfjTN8mVD9ViGQAqqahpq7gfA7RJl2umwpJp4+hqm5VIYKj1B2EVS0WWFj5c+lYDbiGTZH/Ce3GK7EL66rI9RXsr6uuoA7E4xU0Dhy2IDiCXJ6aaqA8TG5+rhQ9qoC3X9dHGNOHxt/dBHl1KN6xUavQabW15nR3CzkytnafNy9D1uDcCDY/3cZzRcmXcyPfsWrLH4M22WpmD8RnmZ6s/ZInTk8HrF1GbzctC5ARbQ+2Okbn5yaqv8N8glLPXVkt67Eazict/MJG+U1flMq4128TFGr4qXIMkdnLbcP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/02/26 at 11:43pm, YoungJun Park wrote:
> On Mon, Mar 02, 2026 at 06:40:13PM +0800, Baoquan He wrote:
> > This can simplify the code logic and benefit any new type of swap device
> > added later.
> > 
> > And also do renaming in this patchset:
> > -------
> >    file renaming:
> >    ---
> >    mm/page_io.c to mm/swap_io.c
> > 
> >    function renaming:
> >    ---
> >    swap_writepage_* to swap_write_folio_* in file mm/swap_io.c 
> > 
> > 
> > Baoquan He (3):
> >   mm/swap: rename mm/page_io.c to mm/swap_io.c
> >   mm/swap: use swap_ops to register swap device's methods
> >   mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*
> > 
> >  MAINTAINERS                 |   2 +-
> >  include/linux/swap.h        |  13 +++++
> >  mm/Makefile                 |   2 +-
> >  mm/swap.h                   |   3 +-
> >  mm/{page_io.c => swap_io.c} | 104 +++++++++++++++++++++---------------
> >  mm/swapfile.c               |   2 +
> >  mm/zswap.c                  |   3 +-
> >  7 files changed, 80 insertions(+), 49 deletions(-)
> >  rename mm/{page_io.c => swap_io.c} (91%)
> > 
> > -- 
> > 2.52.0
> 
> Hi Baoquan,
> 
> Thank you for the swap_ops infrastructure patch. This is very
> relevant to our flash swap work, and I believe it could
> significantly help with our future contributions if the framework
> is extended further.
> 
> As I understand it, the current patch serves as a foundation for
> future infrastructure. However, from our perspective, the swap ops
> are currently configured statically, and we would need a way to
> apply or register custom ops for our use case.

Thanks a lot for your input about the future potential use cases of
swap_ops, they are very valuable.

Yes, this patchset is posted as a infrastructure of swap_ops and a
thread where we collect any potential extention or use case. The
change is made based on the current kernel.

> 
> I have a few suggestions (mixed with questions) regarding
> extensibility.
> 
> 1) Could the ops be replaced at activation time, similar to how
>    SWP_FS_OPS works — i.e., giving block device drivers an
>    opportunity to override the ops when the swap device is
>    activated?
> 
>    This would allow block devices to handle swap read/write
>    through swap_ops rather than doing it in submit_bio, which
>    feels more generalized and leaves room for future extension.
> 
>    This direction would be the best fit for our use case.
>    However, considering ongoing swap work that may involve
>    managing multiple swap devices, I wonder whether binding ops
>    to a single block device would still be appropriate in that
>    scenario.

I think it's doable and make swap_ops more flexible and versatile to
support different swap back ends.

As for binding ops to a swap devices conflicting with managing multiple
swap devices, I may not get your point very clearly. Could you give a
concrete use case to demonstrate?

> 
> 2) Would it be possible to defer swap device activation via a
>    lazy registration interface, so that the ops can be registered
>    before the device is fully activated?
> 
>    This would open the door for entities other than block
>    devices — such as kernel modules or other forms — to act as
>    swap backends. (Of course, block devices could also benefit
>    from this path.)

Yes, I think it's doable. I will make change and send a draft to you for 
evaluation. By the way, do you have actual use case in which deferring
swap activation is needed for justification?

> 
> 3) Alternatively, are there any plans for a static binding
>    mechanism, or any other extensibility approach you have in
>    mind?
> 
> As an additional thought, if this ops framework could eventually
> be extended to cover cluster allocation as well, it might enable
> a model where base swap functionality is provided by the core,
> while each vendor can freely plug in their own additional use
> cases on top — making the swap device truly extensible.

Yes, this is planned task as I have mentioned in the LSF/MM topic mail.


> 
> Any thoughts on these would be greatly appreciated.
> 
> Best regards,
> Youngjun Park 
> 


