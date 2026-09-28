Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27307C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F30276B008A; Mon, 28 Sep 2026 04:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9E16B008C; Mon, 28 Sep 2026 04:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D81866B0092; Mon, 28 Sep 2026 04:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCB696B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:32:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3437612013D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:32:09 +0000 (UTC)
X-FDA: 85262503578.12.E3E13B9
Received: from mta1.migadu.com (out-31.mta1.migadu.com [95.215.58.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9093920004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:32:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tyjF0o3c;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.31 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790584327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ZKD2cGst8ZlgWmbhY/0EUSmp/ke0gx0ibIjGA51fr8=;
	b=eLT2j4drUnhB62Fiq1q5Dyu+Tw/cZ7jeeN/tXGT8GlWX/O0k9sMsmEeNO6kqqOMa+Uns0p
	tCG0vk6kA/oA6Q387YrPlRFkREruPnnBQlEugmjgKwmSC0NL/4dbCUsfOmoXqX2XFvRxLO
	m3XvHK9MDhgqkj+ROa4/SCDYrZPxHZk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790584327;
	b=zPon8dlKyMUZUnH8CFE6LQ0VWj5VIWv7zB5lqrPRCBIoi/QZvA+lVxOUCmgz4fz4zne7dg
	xoOy8L8XsUBKMfxdW1OswZXXttDqPEVLvz46ISnw7IxVnY2ueJVEP5sXT5+p8EwVVK9j68
	smeqkoc0pPPIXGVYhooT7a5su9VlCJk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tyjF0o3c;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.31 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0vsNUizkmzlbu8y8J+IZWSMNjN9v2l2Yufh8n4d8/RU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790584322; v=1; x=1791189122;
 b=tyjF0o3cR9ljeFX4XK3gL8z3b7xqobt2exvjAkbD+PvnbxNfg2F1GudPKGeS+nnZnBWsZe8e
 AEK7Cwjwz0O91OKfGmf/5KNZvAVKzBK9uEzR8gkDGuKYdlvX3ue6Aq1wiZnpSoUClPeZEUe3bhA
 4Klw25etPFVrQB63qCKJd9bo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 42d1b3bbabd087ec;
	Mon, 28 Sep 2026 08:32:01 +0000
X-Mizu-Trace-ID: 42d1b3bbabd087ec
X-Migadu-Flow: FLOW_OUT
Date: Mon, 28 Sep 2026 16:31:51 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>, k-hagio-ab@nec.com,
	ruirui.yang@linux.dev
Cc: David Carlier <devnexen@gmail.com>, akpm@linux-foundation.org,
	axelrasmussen@google.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, brendan.jackman@linux.dev,
	dakr@kernel.org, driver-core@lists.linux.dev,
	gregkh@linuxfoundation.org, hannes@cmpxchg.org,
	jan.kiszka@siemens.com, kasong@tencent.com, kbingham@kernel.org,
	liam@infradead.org, linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com,
	osalvador@suse.de, qi.zheng@linux.dev, rafael@kernel.org,
	rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com,
	vbabka@kernel.org, weixugc@google.com, yuanchu@google.com,
	ziy@nvidia.com, devel@lists.crash-utility.osci.io
Subject: Re: [PATCH v2 10/13] mm/sparse: remove SECTION_MARKED_PRESENT
Message-ID: <arol9w7G3vupIVZ7@MiWiFi-R3L-srv>
References: <20260921-b4-sparsemem_cleanups-v2-10-54d81d65e125@kernel.org>
 <20260927192013.144672-1-devnexen@gmail.com>
 <655c509e-318f-48bc-8183-2b1274dd05ac@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <655c509e-318f-48bc-8183-2b1274dd05ac@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9093920004
X-Stat-Signature: inzm9d9ursjms31z7kyigw9w64ucyij6
X-Rspam-User: 
X-HE-Tag: 1790584325-654655
X-HE-Meta: U2FsdGVkX1+NeS8y/pRA6KASd5oKH3kT3w+Tm+YUbEWxwHKpg2F2XfCu/SO3WmaUhO3TG0rIG1LfDxyZOiVRhtgCpeQxPRMbw/AJG161PHegpHkb4w5MvMnWDHMvaX3o19m1qE5vvzbzunLJpNCeCKRXeqgjkHfQgRADsQcQyUr+2zofVMPZfiqjlkETRT+lsxuh1R2gMSU5C7eGE7h0ucHxaUCdf/TEbA2DUeiX0d76aYnjRdOir2Jbu5kgyQhLss/cpI4hxuoRykj76eLLqm1y9NJA6K3nIM5t6eJJrys9iWaktoN1CsN4O/6u7SsI3+t9wmwn/JA7FjvOKfQhRbErM3wZAF4fuPYlN6DmzZWJkjepbduvgE2kuhVh+5bTOt0ici09AHhSIZhcTE5kwY7LdEV4lhH2iRQLoB5TG+9Kj3+Q+pX2wdwIgORUIVvyFdjw4gaqtH3hjaPUfRjJcpUn68ALFXwP6lfamuzeT1TQyCQJQTMsebrYHbj7UKfunr/ZIzO3bE3b7ctlnQ7/j2MtBo61FhmeQC1F1yNomVEQB6lFqYo9JsnqG/0+A6O3h7VLLN0T3wd2GOuOZUGG0DWm5cvy8UFT7x11TZHdO1a2KWUnRm+nhxrX1I566impz118SFSEJv4QWSGaScRbLoiT3nQhoLmjj66PFoQJadUaOBqtjuFSUzrEhQkIu+kqpnyvFfciEDHBr1M8sP3k9FU+0YvDmKNZ2RgIHJGCDhTW5fQDzApwXoo84C598RyayfEI4JzhO4LHBH86oC04/xljKCZaG+d4wiDoHQVIWR6gfzkiePQc8JvCyyzQ7iJh8hQ/DC4JD7S3fxZQ7BITsqknCjkV7Mr0a6a4jMm4mYWRkVyr6re3KSnIkoJ25we9o8Ic3tSSyoHbI9BHHsFxq87FOXBDLdQ7Z2DO64C4RfkRBDhKZpu0mFhyKjggRpQk/KLYnOO7zjBGysZQXxG
 ZhpO3Twg
 Rx4VeItz2R3S9fw62nArxMCZYOnHrlvBQh/dTuep8Rhz0UmkDzJnMA9zOKssSfTDeo2+0E79GLkFVFZHUG8Kt1OZko+/GWDqR8F78CbqSuFESeABUjq5O3RIkF6BCSlWb/7DzrjDtQFwrYk78x1CkwkZentBICwusC7fKVbjfOODEYPoL0FL7rgPuRSbmhL8jWvg4CRUfH7KVVskUqqMyaUdAq4Gwm9+iBMEzAMl2LGJ/5m5dKZaOqpT8HPsr04TAS6zNEMUm+Ru1w6/s+DzmA3aQv2IAyexNpOw05bqFfzfufL7KOecB8/3wTcDkZ8bgcgMIkZE0CXGIzv8fv3s2JmqwTJa6JM2pxVpG2UP/4XE5dbdzj/U8IBJHg9XsMWJ7mAXa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/28/26 at 09:28am, David Hildenbrand (Arm) wrote:
> On 9/27/26 21:20, David Carlier wrote:
> > On Mon, Sep 21, 2026 at 09:59:02PM +0200, David Hildenbrand (Arm) wrote:
> >>  enum {
> >> -	SECTION_MARKED_PRESENT_BIT,
> >>  	SECTION_HAS_MEM_MAP_BIT,
> >>  	SECTION_IS_ONLINE_BIT,
> >>  	SECTION_IS_EARLY_BIT,
> > 
> > Hi David,
> 
> Hi!
> 
> > 
> > It seems dropping SECTION_MARKED_PRESENT_BIT shifts the other section flags down
> > one bit. crash hardcodes SECTION_HAS_MEM_MAP as (1UL << 1) in
> > pfn_to_map(), so it now tests SECTION_IS_ONLINE: offline and
> > ZONE_DEVICE sections no longer resolve to a struct page. makedumpfile
> > only checks bit 0 and is fine.
> 
> Thanks. To be expected when relying on kernel internals.
> 
> Which makes me wonder why makedumpfile
> (https://github.com/makedumpfile/makedumpfile) not require any such information.

Makedumpfile requires it too, while it doesn't ask for HAS_MEM_MAP. So
checking MARKED_PRESENT becomes checking HAS_MEM_MAP's value, it luckily
works.

# git grep MARKED_PRESENT
makedumpfile.c:                 if (!(map_mask & SECTION_MARKED_PRESENT)) {
makedumpfile.h:#define SECTION_MARKED_PRESENT  (1UL<<0)


Add makedumpfile maintainer Kazu here.

And add Dave Young here since I heard he is taking over Crash maintenance
as a volunteer.

> 
> > 
> > Keep bit 0 reserved, or export the bits via vmcoreinfo?
> We could export it, or crash can simply detect the change based on the kernel
> version. I remember the latter was done in makedumpfile in the past (although we
> export it).
> 
> I can send a separate patch to export it.
> 
> -- 
> Cheers,
> 
> David

