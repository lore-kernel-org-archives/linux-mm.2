Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF31CCCD184
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 02:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFB258E0003; Thu,  9 Oct 2025 22:15:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAB938E0002; Thu,  9 Oct 2025 22:15:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE8C18E0003; Thu,  9 Oct 2025 22:15:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC0818E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 22:15:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2858084905
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:15:01 +0000 (UTC)
X-FDA: 83980586802.30.95DA9A8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 364A51C0005
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:14:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gzV1S51t;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760062499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RqMDaYTQ6aiBvLiZTVAwgbQ3fh4XmOiRcj9WNu+cEXk=;
	b=xOC8VPOdZ91AFMb4wjYbUYjqjGS3EjYiCg9Y4JqcD4lOVSZ9umHAtg+IV91Eo7czYRREkk
	n3HBL7VIPkz4TmykAInKYonbQGEQu4B8nUmnFCqEIJnq4f87Co4S+5iP7VWskImW8dBzsA
	sSXs8fbZ8nquOINpiOFGzymvR8joQ2k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gzV1S51t;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760062499; a=rsa-sha256;
	cv=none;
	b=i0zDN1Qzp+/oBo0d8e5OxR/eZKCZ58UMlWwrhKzqgEXO4z20RQ/Y1Np/Scl249+vT3sT6c
	vhveq8arumBbVDP3jJKZP5tCJkC5MxHZtjgM81EqQnEHxmhHbseEvG9e5HvKn6Hb4T50Wv
	7z0eXuLrUyWTvgnrFJyFVyjSNhipuLw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760062498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RqMDaYTQ6aiBvLiZTVAwgbQ3fh4XmOiRcj9WNu+cEXk=;
	b=gzV1S51tDtIaw2pVopml+uOKY33U7KcvMf/E3dg+UMa96vpL7nwPruC8KWBPZ+vOP5A2rx
	aq7eixc4GYePArfh1j/Ux6LflOLXkK3ewHJxY8vMM9K+moqT59z3QUFpAhEStiMkzWiXwd
	8sl44Fx3w7ZO53ms8mcQ2OQ77nwT63E=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-449-NnW5UbArOPGjzSOySjXSSA-1; Thu,
 09 Oct 2025 22:14:55 -0400
X-MC-Unique: NnW5UbArOPGjzSOySjXSSA-1
X-Mimecast-MFC-AGG-ID: NnW5UbArOPGjzSOySjXSSA_1760062493
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E46E18004D4;
	Fri, 10 Oct 2025 02:14:53 +0000 (UTC)
Received: from localhost (unknown [10.72.112.35])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F06630002D0;
	Fri, 10 Oct 2025 02:14:51 +0000 (UTC)
Date: Fri, 10 Oct 2025 10:14:47 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, chrisl@kernel.org, kasong@tencent.com,
	baohua@kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com
Subject: Re: [PATCH 3/3] mm/swap: remove unneeded swap_active_head
Message-ID: <aOhsF3x3dXD/keki@MiWiFi-R3L-srv>
References: <20251001043436.41338-1-bhe@redhat.com>
 <20251001043436.41338-4-bhe@redhat.com>
 <20251008202623.1ef2ac29af9b9c3d53aca4b2@linux-foundation.org>
 <aOdoehPH1O2vJnqv@MiWiFi-R3L-srv>
 <20251009182840.55426eb0548e7da1b721d4fc@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20251009182840.55426eb0548e7da1b721d4fc@linux-foundation.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uPY1_9IuEKRT15_0kYUlt6Rq5TJkw745x0f7Xm3FSh8_1760062493
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: cp9unw9d8w3yztqkz17csdzdnn8zybum
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 364A51C0005
X-HE-Tag: 1760062499-721285
X-HE-Meta: U2FsdGVkX1+5eAB1ZFpIV5PsA0WKrbj/N24RS2PUWnd7MPOjjMWppHXLr/LGzZzkZb1kyoaEUzxzeCDqbgf3/FGlXv7/FOwpUX08+DLKOQW1Fx3fHH0s6+GzaHDdxLloAhPmOTOsMLjup0y/O2K4GwWdeJtSDod0kqp/XIUEcQCwC3d+V4vYn82xzKKLciIopdn3ULO9sXdl3Ys5BATsA31dTzJiaBr6WQCrXv/j5MlU3sV9Oq82lLbtphzggc/tYKENL0b/34pS5Mg1keS+ZYobH8+dm9OnVUIULyEMpAbd3TwOhBCaYkRXiODmSlP7oxd0rNkxHdsvxqu0gkE00Nxbore9MAWr67VYNkaBmoNYDZk920FpP9ddZC66ml4pb38lWkhcrp7HrT2SYRvt4aXTVt36sSbNDZZFyIvjukc8mZ2BgwbNea3mSYTl21QWhexUH1WZyVZEvfUmxJbozP6uMm0/G9YejfVpnwmBGn5oL+m+4fToYNMH1xEW2GT5SsTYDrdBX83ACbANAKkQ+ms3mLAAfm3MT/HbrMq6UvVU56oDTV+xd0pKcA2KfU7jNMlgllKxXFHcyIcIFVT2Up0mhZEbrbD6DSwBHT83+d9g63v23svv2v57RAme9cKvhZVaEOhC68W8Zx/Sx+BEWdDMcNqfU/Rh0iz7K7oqtqqLjVZhEHVFEUTX0NjkDhiXOze5QcBtK4wfNzCopUX/hIo4jl05UTUyGQwXUdu/7+iHzCfvwQYO864OFn395zt6WEDIb37ptNxyGBAQll2yf8JY70ylDY1QPmqFQYrNWmL437my2v3QmTZXwmAY0vze0Kw3bUa/uHshoBaRla+HjzdawApIMHr3q7uS0bV+57UhoaSaei1L8nW8E8hvtBxZTcBfnjkvfcQVsq2AlPafSYr6Nll7ZffDUp6iBceQK5mzgvcOGcsVqyUeAXuvo7AGW624RlhlrWVce3VxbLi
 dumQCRvz
 S2ywQhyekn/2O2nLev9oeJLWAhVg6ug6aPWLbJ0nrw57tGoCcpL+Nxy4JiE+Si3rYbv33jVjR8u9D99MOcwIh/K32u9LFuwhRH00A1qL4yLaDQ0wYmZ/JWKzV42VSL6M+R1BhsueDmhHEW35TFvAL/L8psYgo+Hh/dlv59MIMnVPva36CDjXSfYLD3iGnJ2pDfO3ZxLSaHCGtMuF/EjD0sD9ORHBnDRehAZzis0C8uH9fVuvyXxZWfj+0k+ipUh0jByHTb3QGV2Ju6umC41OFP3Gz0bJ6Owq/Z7SmQSRpS0l8YG/gMeFlPhly0fJ/yO8Vi+b12MrzmFN2qEN3ykey9unGcnh5yo1aWSA8Llx1jAoqSbJTQvEw8R7ZOfy8y6qIzz0AdgRiUo6gX9GF4vLdG1WXnF5zR3OeNEgALG7xVDovK316RQx9wLvc8OPVaIz8XKPWP4WQjdKZDD+lTiZ5y6aN9b5BryyMwyssKgMyMKnYCsDT3JcE6lRAP4D/NnPv21SZA22hG5tn28o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/09/25 at 06:28pm, Andrew Morton wrote:
> On Thu, 9 Oct 2025 15:47:06 +0800 Baoquan He <bhe@redhat.com> wrote:
> 
> > On 10/08/25 at 08:26pm, Andrew Morton wrote:
> > > On Wed,  1 Oct 2025 12:34:36 +0800 Baoquan He <bhe@redhat.com> wrote:
> > > 
> > > > There's no user of swap_active_head, remove it now.
> > > > 
> > > > ...
> > > >
> > > > @@ -2553,8 +2545,6 @@ static void _enable_swap_info(struct swap_info_struct *si)
> > > >  
> > > >  	assert_spin_locked(&swap_lock);
> > > >  
> > > > -	plist_add(&si->list, &swap_active_head);
> > > > -
> > > 
> > > There's a large comment in _enable_swap_info() which needs to be
> > > removed or updated?
> > 
> > This patchset depends on below patchset:
> > [PATCH v3 0/2] mm/swapfile.c: select the swap device with default priority round robin
> 
> Oh, OK, sorry, missed that.
> 
> (When I'm working on the post-merge-window patch pile (700+ emails) I
> go in reverse-time order, so highlighting dependencies like this helps!)

I see, will mention the dependency at the beginning of cover letter to
highlight this.

> 
> > By the way, Chris worried the plist swap_active_head could be reused by
> > the ongoing swap-tier work and suggested to hold off this patchset till
> > swap-tier work is clear. Now seems it won't impact swap-tier, I will
> > send a v2 against mm-new.
> 
> OK.
> 
> Is Baoquan's "[PATCH v3 0/2] mm/swapfile.c: select the swap device with
> default priority round robin" series still considered good to merge?

Up to now no objection received to the patchset and got ACK from Chris
for "[PATCH v3 0/2] mm/swapfile.c: select the swap device with default
priority round robin".


