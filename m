Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32273CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 04:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592FF8E0002; Thu, 25 Sep 2025 00:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543618E0001; Thu, 25 Sep 2025 00:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 432A78E0002; Thu, 25 Sep 2025 00:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 301CD8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 00:24:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED0F5C02C9
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:24:25 +0000 (UTC)
X-FDA: 83926480890.15.D6A692E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 00EAA14000A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:24:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IH+3UrSy;
	spf=pass (imf09.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758774264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QpiP/D2G28QjDj2DqXsA2N/V+R2J0bIHlMlyqcqfUBA=;
	b=zB0pjBh0TYdSYUmX0MquZZiKHgQA5LoUyfq5+XWHRJO3u9m1uESlc4jH4+aJTWyVXaKA9a
	q0O0AnEKDhfPpbWF7hWMBkXAq+xJfkf2azh3vpAs8lydxm8MdlevS0tX1CKpS2QE2Wua4O
	o6A2w3I8phCTVvmWKRxP+0byJ9+jpDI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IH+3UrSy;
	spf=pass (imf09.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758774264; a=rsa-sha256;
	cv=none;
	b=vItfb53T7YlVDYD3ugkVJahwcC/H8Z+4uhl7CU5iwnnQge6K/sRXawyqCMjL1USs+01xoU
	ua4iloWiSVRl31QMytmZfw2IEVRGDBs8ytdpNCvvKK9QyvjpSyb/TfB7dSdHEOVF4Mqxm/
	f1hYngV2Jtczy5Cg9om5tC8HB5284mM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758774263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QpiP/D2G28QjDj2DqXsA2N/V+R2J0bIHlMlyqcqfUBA=;
	b=IH+3UrSy+xijTDZjZow14yZmoy7QLe7F+cVZcdsqfA6ipYwYK10fkcTGB8tP2c8FCQwSUy
	7thwyCCamcpMDjp6Wn5pPrGmfNp3bCVXY6wiNweOG2rnDXIst98gG1xlvXmQlG73Y/ddK3
	BO7GFUS0m7a0TWtghvh3/S0HBOr8iUs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-SNOQjPICO3Ot1cu1Wi2YmA-1; Thu,
 25 Sep 2025 00:23:43 -0400
X-MC-Unique: SNOQjPICO3Ot1cu1Wi2YmA-1
X-Mimecast-MFC-AGG-ID: SNOQjPICO3Ot1cu1Wi2YmA_1758774220
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A2DA619560A1;
	Thu, 25 Sep 2025 04:23:39 +0000 (UTC)
Received: from localhost (unknown [10.72.112.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F350C18003FC;
	Thu, 25 Sep 2025 04:23:37 +0000 (UTC)
Date: Thu, 25 Sep 2025 12:23:28 +0800
From: Baoquan He <bhe@redhat.com>
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, baohua@kernel.org, shikemeng@huaweicloud.com,
	nphamcs@gmail.com
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
Message-ID: <aNTDwFLkc6YnjPU7@MiWiFi-R3L-srv>
References: <20250924091746.146461-1-bhe@redhat.com>
 <aNQTw2JRYfYDcafv@yjaykim-PowerEdge-T330>
 <aNTAutSpmStbvLip@MiWiFi-R3L-srv>
MIME-Version: 1.0
In-Reply-To: <aNTAutSpmStbvLip@MiWiFi-R3L-srv>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SuF7ZLaUxBHV3UTr5bwe876JG2JC2biJBU29aWJG5pE_1758774220
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 00EAA14000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: h6wxmjw3juyxdn7y4bq7mwbxckua5yiw
X-HE-Tag: 1758774263-452815
X-HE-Meta: U2FsdGVkX183IzjQ3WHbQib1GU9wnQpz+3Tx7WFVaHNlb3k0VZXSYV+cx+fcJ9bgK4bMEUa7WeQdwyUo888XZdlPqYcXbFa84v93mRtg9CrTNfHimnwEbUz9V26i8gN+dqbcNNW4SzFMP94FoK4CPxZjrkdE9YQ+bCOufQ5xBRcbzP+Uo0DLjGottldz52CkS136gAyUhugdgNuT2CcnP7LP9zIRGodfBu73XbUYAqiO2/ErT9N5fXKhGYZdl54AVqwOnAlx+FF4CFmBUdzdqcjmkXGi4V4kprQIPTnH/74T72DjU2AX6RdZf8wTp43VgGAr4N5V6FJo14Q3Lfqc2Ais6wNWNFRQIR47tkwlG1a7ou5hqRBu5PiZ0+YcTFNdIlS/VACaOvavbhaKipZXwcJNdDXqQe6V6Xp6iY6ZeK2J+I7IDJky4LAMJC+Pt0025c3QCVpc3hjVb205kbLkz9nhJk8lQ71lGzumrHpK4e22Y1SySxvWd6oNi/DhDRXvStguIALW3KITZ9z/wGyN0hIEg1MYVEg9PqgvGsTc8/LHZNSvLP7sC2M4sr+OKG4y05HBWr6PApgRPRpGvifbLaSDcMukZwJ+ECFTXILjHHaymb98s9Qr4XMoPULCTv10nDQolVHk1Rsh1p8ZI7+eLo6tOuoIlTr0Yl87k/rqP2GotgFpG7H6iIyGABTn53joVPznmTY53zzni4ztUTvLaroa4wSQQ2+u2WzZ6nZJ/L/Mh1jkl0LgIPhsj8ZHX/BJrjCzqgRujYX3TwDcSaUby0Q/1PdG+Pg3ffF9e9/Jx40/CLY9MrkLsJyZjMaURwwPLarWoE17kNMRM/WebKoFghpLP9apznFxpBMM62C36nvUbfRfgxIDJWEsdw7nHdWh4crWw7o9++3rNALNwmpA3oQBQhi/iNwXjwV2xuYQhLJy1yl0iQNgXCSSA2BQQVvKKKU4IK2t9FP9Qqg/jvE
 4uZq4DSk
 G6lVcaQpcAY4CtQgVOccOj+bnUb3hbvFATGS7AcYrh3/EV/YaedIDof4FH1+W5QoH40Q4pOU9jBGC/yU0gzRfu8sehZvRgCEYAP5zhty12qXpwP8zZkcnB1pFhEIAdw4llZ723Xy+lCjV0o9jrlEmKv3W2PrVKK0KJovLrUlKR2KkRSaNnExRDSS4xnnGK0XxzOMUKDOx7rMpQK5mR42HDiKEwfpciQyExJhQ8AIW8v+qwtloGpxDV1/w60Ec+sP9TnAbXp08OrTgq1yK7vjGfZ88oiQeAfIqBvjrRrP2ZaapXx/lirQ7VQz+jbhwLpg0mJco0vGbEJhFx/o+FiGciPN10niigTQMBlOh00iKuNtQJJ/J80Tb0n9DGvrm+Hy9AQxyEjYtcD2T06pNdOg+F/wE7oz49HDQrUtCFgplBw4W7nhhLGYsax+W3ogbztixoxhHOlqPlVDCwpuKsCyK+CdUuNpWqo/m7zl1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/25/25 at 12:10pm, Baoquan He wrote:
> On 09/25/25 at 12:52am, YoungJun Park wrote:
> > On Wed, Sep 24, 2025 at 05:17:46PM +0800, Baoquan He wrote:
> > > -		lockdep_assert_held(&si->lock);
> > > +		//lockdep_assert_held(&si->lock);
> > >  		si->flags &= ~SWP_WRITEOK;
> > 
> > It seems that the commented line `//lockdep_assert_held(&si->lock);` 
> > should be removed.
> 
> Yes, it should be removed. During swapoff, si->lock is taken, while
> during swap_range_alloc(), only ci-> is taken. Thanks.

Sorry, I was wrong. That line should be kept. Because during swapoff(),
we need hold si->lock when we call del_from_avail_list().


