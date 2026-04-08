Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77B8CFF513A
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 02:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C5BA6B008A; Tue,  7 Apr 2026 22:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776376B008C; Tue,  7 Apr 2026 22:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68BE76B0092; Tue,  7 Apr 2026 22:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 586B26B008A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:49:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8AA9BC1CA
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:49:27 +0000 (UTC)
X-FDA: 84633857574.09.A6F5714
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id AEFCC1C0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:49:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PzTrlYX8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775616565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XAHOhaZnMi2g4QNdL7Fre1v9gU9ZPxngZ75akcpvl5w=;
	b=dj6asfYa3CQQ3kvrgmpbWGXOq+gWDDIRKZfdCDaNBts2waLkmikWBdlBDxLqqLVODRPSSx
	dpcmJEVrDDaeNZ8Ftwyi/mG8PeuxYJbjMs2mSauPIqNhVSzZ+2BacYS1b95JU1vgtQIR6m
	SUYcr8RsSYHH9/ZWV/o2FZwzmNA48HE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775616565; a=rsa-sha256;
	cv=none;
	b=qHmlJI6nBQI7+gdOMnSHeHTKvEmEuugDnth6CnU73kuml6IY+cNTaJBO3Ym7FawpVemI2p
	21QqvIf5P7FLBW7hVYf4k0jhIaSgj0jg4xYC9oyGse/y+yIuLL7E3SXSK0i2MW/CAXAaxT
	EaaslU+fgMm87TDjQensdV5s1ubKN6A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PzTrlYX8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775616565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XAHOhaZnMi2g4QNdL7Fre1v9gU9ZPxngZ75akcpvl5w=;
	b=PzTrlYX8uj3PSQdfcvjm7MWPFF9BAjexJkaUFjCZeDqcr947cY+5z37/PNuJxCGa25WknS
	bVDa+hUn9Fuv/VAzgDu0nJb4gGZS6/68V6nKN2XEIodDFaIxztgFDxG2mOFunBpq9vDXP/
	QNueG4eJ6EcS88lDx+ZkYXgIMlwQY5c=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-662-byPuJsC6NNafl8IYg_Ar7w-1; Tue,
 07 Apr 2026 22:49:21 -0400
X-MC-Unique: byPuJsC6NNafl8IYg_Ar7w-1
X-Mimecast-MFC-AGG-ID: byPuJsC6NNafl8IYg_Ar7w_1775616559
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CBC3B1956094;
	Wed,  8 Apr 2026 02:49:17 +0000 (UTC)
Received: from localhost (unknown [10.72.112.14])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5A6CE300019F;
	Wed,  8 Apr 2026 02:49:15 +0000 (UTC)
Date: Wed, 8 Apr 2026 10:49:12 +0800
From: Baoquan He <bhe@redhat.com>
To: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Jianyue Wu <wujianyue000@gmail.com>, linux-mm@kvack.org,
	akpm@linux-foundation.org, david@kernel.org, mhocko@suse.com,
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: move folio LRU helpers out of swap
Message-ID: <adXCKGN_9jFgLqI6@MiWiFi-R3L-srv>
References: <20260407110002.204755-1-wujianyue000@gmail.com>
 <adUTC-7iyOAUlhR7@cmpxchg.org>
 <adWxonmfjvcwXMg8@MiWiFi-R3L-srv>
 <CAGsJ_4yNZiRpgyTbooJEkkefVxgWOywkcVd2BeY5Dq2wuicNNA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4yNZiRpgyTbooJEkkefVxgWOywkcVd2BeY5Dq2wuicNNA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: fSIIbYGmPJhknmXOzE6gxViUQfBrB0XB0Nbls4MFKGI_1775616559
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AEFCC1C0005
X-Stat-Signature: xs8xwutujuaxtpqk1cggfp1xazyosi3g
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775616565-251654
X-HE-Meta: U2FsdGVkX1+AQCoThYGKRjM+RzFkmuU0Byn0XZpYRo++n5NYauthmf9pvKxvcLCOBR/wZdP9VjOAzUIPrjlrM5aLBY//2/0Rf+aUqXi2a6tYTvBhN4pI5wh2BEDG9WVPnwGFC+AquHQgvb2jjsH4GX4nQe1aPs6x9M8C6PUkBIV8Ytsy4YjXbTNIp+Man/2RjLm4fDzblblWSOgxacOZSK4GRi4BMSo/M9JFJYqgBJUsTEprODlAnSSEQpm7t5N564VaktRA0bBO+5B/fvYlQn/7fFsA/c3MPg82yJ2WjJJa5/hI2qQMnUuFwh2D7pyOn9Vdhnu1OaNlqqnzeFH/OijOEyeGw1hzLqSMUKcKQG7izQuEU/GC7+9xS3raPQe5HmylYmGVmUUfNcyT3XRUxtqWE+8hvQfN1lgZ8U+MKqSPDgPdq0IfTQbndQ2q/1xjJRO+RnHXbQth6iyvwe81FVG6nIMFIo8OYLRk/MKRAhM/9KemdhcTHYvjREB4wTAqWq0wBOCACTBQQz/CGxqWxKew67z4a6rto2KLXJSsLsBrEWwkOvzL7yfBFnJfrUn6+/vTcdz+sxmx1kaGAPfXlOXTN8t9NtHKzDnJua1ZqK4r54LuObJ/4AWboYibgo5Z6MNd8kD4fTiqfzfRq2xPMQP8LGzt/2dBJ+iDPvFS4cv4/VkfXlNpqO7d3XsC33HQIKCCZaCq+a59FGYVTPqLJUfQySGCZjkblEK+dDMPpECjUK8TBb2SspDT0c/VNgkRQR+QsnfdcGsE6KWacyBSUc4+YtQ/tQDZ9WPbEpEPL0DnQLd7eJQOwcy878yImFLOTy4m4oV2eW6Z7cp5DprX5cKaJnC1HAd0dNCjm9b9J5Blq55GnFlUHr+Hm8WQVBc6+uPNUAaK5dr/pBSP5s5bwrW8aVJlPQbai6JWMm5k2+CbD6VYAjtf5A5CVaGjLTiqQDyY92zO0itCTJsmDa/
 b0JO/VWg
 1f3RF2XLR+9oZFyf3YXnPSWGwJUPOqW//HbbfDGEiTolmE20DlCYh8FwCbF/Gm8a/NPDl2JqnXc8dO7T5CoCw0Qe2ZwnJ1ar7WktqOB/8wUz9v9dco2zwxzsgctcouB1CmL97PWLZp3uKc45YR6qOq0pwcUgfiopfJX8Dj8zluxaJie03HyTdotcZ5VXEdSoURVpQndkg3kkmjhBRU8QJDiW9wrZzseSwstG6Hk6nRFMk/avCd1yr0pIbjZMxgsMlSh7fkgLAHxtBKyvb0WX6A0ZEG/sXVnqxQN+Q+S55Al+GxAbltDX78vdxDWNaRBwdOqfprvCLq/TEdFteaZcj+UAtD53xcc5iRFd+/Kr1cqO0oVzKovd4E5WM6IGeJvPHk3zHJqXJGElP5rKRP/SENyZ4dJtiZiXZG4KEzezq6QWJwgtWERBNGmxsuaU79WmpW9vaIJ7WPcvS2gs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/08/26 at 10:20am, Barry Song wrote:
> On Wed, Apr 8, 2026 at 9:39 AM Baoquan He <bhe@redhat.com> wrote:
> >
> > On 04/07/26 at 10:22am, Johannes Weiner wrote:
> > > On Tue, Apr 07, 2026 at 07:00:02PM +0800, Jianyue Wu wrote:
> > > > All allocated folios are added into lru lists for later reclaim whether
> > > > they are file or anonymous folios. However those folio lru operation codes
> > > > are put in mm/swap.c which is not so appropriate. Because swap code is
> > > > only for anonymous folios.
> > >
> > > Ironically, the only thing that doesn't fit in this file is the swap
> > > stuff. The page_cluster & sysctl should be static in swap_state.c.
> > >
> > > The rest seems thematically relatively clean - infrastructure for
> > > managing folio lifetime. swap.c is not the best name for it, but short
> > > of finding a very clear improvement I'd just leave it alone.
> >
> > Can't agree more. We should move page_cluster & sysctl and swap_setup()
> > to mm/swap_state.c, and rename mm/swap.c to mm/folio_lru.c or something
> > like that.
> 
> Another issue is that many MM-internal items are placed in the
> top-level include/linux/swap.h, which is supposed to be used by
> code outside the MM subsystem as well.
> 
> For example, the following are actually MM-internal:
> 
> extern int vm_swappiness;
> swap_setup();
> workingset_*();
> try_to_free_pages();
> zone_reclaimable_pages();
> lruvec_lru_size();
> try_to_free_mem_cgroup_pages();
> ...

Ah, indeed. Seems we have been putting generic code related to reclaim into
swap.h|.c due to historic reason. From discussion, I think the below
three things are doable.

1) move page_cluster & sysctl and swap_setup() into mm/swap_state.c
because page_cluster is only used in mm/swap_state.c as Johannes
suggestd. And swap_setup() may need be renamed too?

2) rename mm/swap.c to mm/folio_lru.c or something like that to reflect
its real content;

3) Just Barry pointed out, move generic code related to reclaim out of
include/linux/swap.h  e.g move into mm/internal.h if they are only
called inside mm/ folder,

Thanks
Baoquan


