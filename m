Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B00D2C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:03:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8B546B008A; Mon, 28 Sep 2026 04:03:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3C636B008C; Mon, 28 Sep 2026 04:03:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92B1A6B0092; Mon, 28 Sep 2026 04:03:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B92E6B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:03:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8CBAA0129
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:03:14 +0000 (UTC)
X-FDA: 85262430708.16.E52C361
Received: from mta1.migadu.com (out-233.mta1.migadu.com [95.215.58.233])
	by imf04.hostedemail.com (Postfix) with ESMTP id C0F3E40011
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:03:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C+V5Fg7y;
	spf=pass (imf04.hostedemail.com: domain of ruirui.yang@linux.dev designates 95.215.58.233 as permitted sender) smtp.mailfrom=ruirui.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790582593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O6oX7WoY9qy+38lv9uTWDEFP6iRKHKXco4d1bWNWC4k=;
	b=vx0rD127nsKni/FOO29LDpVo1zIYsSHiSuj6EN5a3LDUnmtARaPsPa4sm94oFROkEYPZYX
	ndE7wDBI/S8GSdfJjsgGcDOAlj/J+OsQ9OHsuWfDgE+dFfW8MzU6j7l24Jzk1uiyzibyuH
	+aNuTo3ayPQ/tTkOAYrSm06LQY6qb44=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C+V5Fg7y;
	spf=pass (imf04.hostedemail.com: domain of ruirui.yang@linux.dev designates 95.215.58.233 as permitted sender) smtp.mailfrom=ruirui.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790582593;
	b=Z0/Cyh2VSoQQnHO1VtTgInd6rkfaFzkboFSKPoCbGTuuRCiet5zJnsZRLsRMCgQNuNdIHw
	ARtdqAyfHz8qtYjzxqBi80kMRqj4YLf/HXofX3FDc1p2+NAv0ziX/qIuVrcAZ1aH7VhUEF
	gFdnxMXVL8YOjHHlUfJQpnGNMapJMmk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=u6pM4Q2lirOQrXvVOmhw6eCdvf86YRNbjnR3yNkFQzk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790582588; v=1; x=1791187388;
 b=C+V5Fg7yUDtnG95PdYyQlpKrqN/I0S/X42BAIMYGwTLCGzp4vAUZid0wtjsNCaEZFEsjqFB+
 y46+C0Knmw9IqwGouFl4z0q9eUZEllrBPQRgyYhcIQKi9YaOwn5MwUkGYSVRKEaW8FzJnOV8jZZ
 PolBC5842VTOJPZssiW6x/6g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6cea94b206c11561;
	Mon, 28 Sep 2026 08:03:07 +0000
X-Mizu-Trace-ID: 6cea94b206c11561
X-Migadu-Flow: FLOW_OUT
Date: Mon, 28 Sep 2026 16:01:16 +0800
From: Dave Young <ruirui.yang@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: David Carlier <devnexen@gmail.com>, akpm@linux-foundation.org,
	axelrasmussen@google.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev,
	brendan.jackman@linux.dev, dakr@kernel.org,
	driver-core@lists.linux.dev, gregkh@linuxfoundation.org,
	hannes@cmpxchg.org, jan.kiszka@siemens.com, kasong@tencent.com,
	kbingham@kernel.org, liam@infradead.org, linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com,
	osalvador@suse.de, qi.zheng@linux.dev, rafael@kernel.org,
	rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com,
	vbabka@kernel.org, weixugc@google.com, yuanchu@google.com,
	ziy@nvidia.com, devel@lists.crash-utility.osci.io,
	kexec@lists.infradead.org
Subject: Re: [PATCH v2 10/13] mm/sparse: remove SECTION_MARKED_PRESENT
Message-ID: <aroezLexo1WoeYI7@darkstar>
References: <20260921-b4-sparsemem_cleanups-v2-10-54d81d65e125@kernel.org>
 <20260927192013.144672-1-devnexen@gmail.com>
 <655c509e-318f-48bc-8183-2b1274dd05ac@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <655c509e-318f-48bc-8183-2b1274dd05ac@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C0F3E40011
X-Rspam-User: 
X-Stat-Signature: wfcoyfziczjsufimkwdp8hyhkye8de1e
X-HE-Tag: 1790582592-952298
X-HE-Meta: U2FsdGVkX19+1K60TfWbTKWHm6qI5oWit32mpGndNpVsUun3eMgkCqcWdoc2t8C04nYnz7PbUo3rTxnZR3K2ZOxtYvdClPYKJoR2XjCOFdgxBacYB9KSFn/6t6ExddDefbYuiR24s2Cy0QtCqIffemG2axPheHMQUTIBZOMNZ7/22Al/RN8OZw8QPCVBm1lhgK901BulBr7evjKlj0PkF6EVYykFlh5Cz3gwmR9U0WGGOhgHApuytplzGHo9Bz9Van1CX3JlOHq21juORJCB5QLoBiaZ3ZPhvg8CFlk3ZnC8ewK2l9NSD+tckQf9Cp0BhGnaBh/Sq8Zf6LQQBMscMZ2Me7BiVr+J1czsnowYF7AAbKDVneWcbYVSDH7cGWrWFudGkjFHoIE8WAK2EOKI+MZAIc5rQltD5DZGyPihzExcbYzYJcHvD8KcEs+A1Px0rjd84b6z9LAjL40Va6goKL5UddR6jkVeg9hSAayd4jCoXaqqWg737mqotI+Tg5ArJLspkZCxAkSAzUqWpMLNRRMa1UcOPLEOGplF68KfeQ1lGleAfxCYQsWzCpu63FPLtLYTSZ7DpRal+BYtWAawWIq7I6aF9vexwOC/WUehMkKYPyOwIr5ntpekQLBy0waV0eFQCcpuQGqxkBFMiuUWJq8u6i6xQpaFw6mnpGnKLklm5FF7zWct1wOkqJHi4qgu2RPoldTKaP3EjKYdBzK1cqoCDt8dPEUWp2KYIbfnZHXCGeyeLtYEjJ3sqTr88r4XsUjIZjRA8t4wqRNT8CFY0HqDTQ4kCRcKYRTsPDh8b2m4tpkpUe7B2njDYGJJjP1Cw5Ep7glfVHLKDqWgq6YhDgyyBuQFn7WT98tHu3x6wlg2BDH/E+Y/4aWdJ/k2tB4OerwbcZCd+0B+RKpYl366D58rVOM6YNf6dwgzSuhOEY0DHU0vet/2V4NIbRmnEoH/wlhmNjYcF8mDLl9h2Jv
 hdwWDp2I
 f47McvAGULJ2dJSDTf+0fInRL+XJdjbS1BN9rJwKBH5vsVzu3yjAKkdjQiOzid7EGVr2MUins9RoI4zzL7mRZ+feCF0li2DYIiFBLNG8h5jilumHsNZzlj5d1dPfAi2yNxUbDzGwOeb53dSxyGdfVCPOnm/iNeIuLY3JCRMOUOq/EfTKyCKHqptbytLotgupg5YtTGCBfDmliiu8dsLo/vlCiCVp2eubnZ2GPZBcy78O0jt8sbGFOQeinLy5MWDZb813nyF26dN6VfwJ7kZGTMGRATnTbSELoVtfFwRUdB7V89qUx8RGvYZOjUiglZ7EHiqAHdccZePscxa4LIX8TTi+0sQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cced kexec list.

On Mon, Sep 28, 2026 at 09:28:08AM +0200, David Hildenbrand (Arm) wrote:
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
> 
> > 
> > Keep bit 0 reserved, or export the bits via vmcoreinfo?
> We could export it, or crash can simply detect the change based on the kernel
> version. I remember the latter was done in makedumpfile in the past (although we
> export it).
> 
> I can send a separate patch to export it.

Thanks David.   Checking kernel internals via kernel version is not a good idea
due to the downstream kernels.

> 
> -- 
> Cheers,
> 
> David

