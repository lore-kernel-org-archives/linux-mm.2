Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 775BA106B53F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 13:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF7156B0089; Wed, 25 Mar 2026 09:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE4F6B008A; Wed, 25 Mar 2026 09:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4626B008C; Wed, 25 Mar 2026 09:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD9256B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:58:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E6FE5B900
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:58:10 +0000 (UTC)
X-FDA: 84584739540.19.D78EF73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8E95714001A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:58:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="a/Isf1Nn";
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774447088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5C26zCJLmThL5P9gL0eaNPwT8Ft4vwHwAr08kkFcwE=;
	b=uCyzkeimgR1Q5UFmb1DZi8qDL3l6zBJ7MmBk22NwOWkIQQn+ETwI9C8T7nYSk0whj41wt8
	/tIw5kSsjO2KDts53GEstoFGHWedKBcz4wnxrloyrQNx9q9c0zV6wVrDwgPpke7VfioL3q
	jUonYH8v7wPxLZ9H46+C5L7P8lJsRTc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="a/Isf1Nn";
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774447088; a=rsa-sha256;
	cv=none;
	b=AiAd64iGG/F4zYxjkE+b0CFKKAGew6YRYQN/LV78UTWJ/xQ9gTFws5z7oNAtBejmY9S0FM
	kA6Gog2KoUyFZbuACLl68X1GbIitJa18P2bnGf0YFjhU7LP24jGcjeqXelq3csYrEaAKyd
	U5EiYtkWcdPrDGJ3mFGDkSjgl8hy7x0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DF39C600C4;
	Wed, 25 Mar 2026 13:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A8AC4CEF7;
	Wed, 25 Mar 2026 13:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774447087;
	bh=KyjiwAokSYk7ozvT6M+V8CAJzdrqAh71WLKooyLlGIw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a/Isf1Nn7bbzilJ+WFOdPoPwPnR5v6LhxMrlFuBsyYg2XAwIEm2QemKRxXZjHN5Nu
	 AChgjyjIk7vb33QJ6oLak9yHuJmn9pok4FzY118/Z+xhCYL9ZvqY/49+WryhvTm+9I
	 H/uz07412nF3UDASUIjgPac3fueYVdb60S7vSKmq1WNoCwue6s87ja2S3Tsh5l+e3f
	 64SHJjpAkfwmhNBTPQZWk39ka/fPMUqC0l5Alm8rDrmCIyjXRQby1EnxD/KFHZR4nK
	 FM9Uffh/ooy89oUPe3IV97KvalyzhwV1CHWkx0R4J2p9nJcR4wxJQ24/KPk84FZbM0
	 vIlUGx35sv7Jg==
Message-ID: <b1b682fb-9d79-4388-8499-4623d0785ec0@kernel.org>
Date: Wed, 25 Mar 2026 14:57:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 18/21] drivers: hv: vmbus: replace deprecated mmap hook
 with mmap_prepare
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1774045440.git.ljs@kernel.org>
 <05467cb62267d750e5c770147517d4df0246cda6.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <05467cb62267d750e5c770147517d4df0246cda6.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: oi56fwjf59rpewdur95ycpond9nnnhai
X-Rspamd-Queue-Id: 8E95714001A
X-Rspamd-Server: rspam09
X-HE-Tag: 1774447088-163578
X-HE-Meta: U2FsdGVkX187D9iPSDDSP4WVyJbg4+AQL3OY6Eq9Gv7nCc8OayGteeZL65EI3DfIxdyNPum0Ss0sH1w6cXCjU9LytHgllALtZrRPvJ77A5SEYzVdKEpei275OXBmrMl7k3VtfyONNx5EAw3aEnzpk3l0dhUSdnBZQ3AplRuSkAMPyGBpfQkV+vDuQ22UW08REo5DPeavcyYl0oKDs/sFH6Hb5XUwxYlhc7TUeZCS6R7rXoRFN+f3hYyZVdjYxl08XTL8JwhvY3MqhD+SQ6yG8Zl3KgisYQjuyt0NiUFPFBJqlc1M8D4kFfni50N2jjzsLBqQX5mEE7YT0mMowx45/v/FgBzcJoYJbv2z5LVt7zsRR45ZJx/IRxVK3NhsbY8oqLyJPlNGmFOd6bhTKnya+Yfno9KKQK/Rm0xAIqdc1MFzgerTRQ3pcyNwu3mvPfa4heFxI0XRO0qmX0F/TSWqDE/3O3y7+F/TCnoSEV/QBL+RBGkpz1QPMWUpHhfEPdL6vaRpxypp2M0D55HcbLdi8FVi+lm4xFzVzfy7iltthq+PrmHYpujBK+eAkz9OYysnN2ejJ94KayxVPOb3cR4WsghNYBGJLMZnPtK4QmDYe64njYSynArVaJhrrtORu4u7+gcMh4R/CgnJ9i4pOTIZCWP3DJv/qHhs4o/uGW1+SgxscF9X4mOnYoFA/WM82cQVLqC1anPtfGNX5r7s801cYt8KWbFrlKJF3JrMHSD/M/9SSD8GXV3fO0WzqPQxTnzFLCKbh3q3oTqWc7PxJCkj+v9Aq/w8zEpyYR9SPDfTw/QoJ/kFcI3r9+rgoBw2qjyAWOL92n9uX9MTlXEpgj8lmgIR54PMKOwcrRUOA15NBkDyfsOONKme/nmNPtI6xfJAVM/MAGcpbsH08RS78xwGIcoW/yiQHOgJrZYtVHyNk+FNsoAl4gl5H7Kp3/gcBGcWrFp6/TyFg2DfHxCziEm
 SGbidWdH
 lVM/MMJ2Blh7kvWXAcfv7UZadvm0ShhpicNO22ht7VKHHxirOt0obKx54fTs3dbLn5EwtbyHm5ztzvMxv9p+JYfynvsIc8LxqBtZoMdmru7YJmdPC1ACZezh3hROh5aQgOLLBfjj75Fa0KAjQXUnJWmf1BJNR+500LukSXK4TuCl2MLyWznhB73htHkxohQ+UXU0V7NHKe7oHudKa5Q9dO1r52Ba7Eyahod9/z5lN1wOgVzgsqhWeiLj0HMZ6e2qEk4KYe0fuKfUf1BdGWv0odMFH7sZzrR2OWhVxLwxJ3ZeJgwxmu+1/DDFGPvOPZaFubMjWHt3SgY7Otsq6OZLRJus7c7HcnZauhSJK6RdJmkB7GnX6G6P4xAOMqSK3+rVICc2qhUdbXmJQH3eN90paJSipGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> The f_op->mmap interface is deprecated, so update the vmbus driver to use
> its successor, mmap_prepare.
> 
> This updates all callbacks which referenced the function pointer
> hv_mmap_ring_buffer to instead reference hv_mmap_prepare_ring_buffer,
> utilising the newly introduced compat_set_desc_from_vma() and
> __compat_vma_mmap() to be able to implement this change.
> 
> The UIO HV generic driver is the only user of hv_create_ring_sysfs(),
> which is the only function which references
> vmbus_channel->mmap_prepare_ring_buffer which, in turn, is the only
> external interface to hv_mmap_prepare_ring_buffer.
> 
> This patch therefore updates this caller to use mmap_prepare instead,
> which also previously used vm_iomap_memory(), so this change replaces it
> with its mmap_prepare equivalent, mmap_action_simple_ioremap().
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


