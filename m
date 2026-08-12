Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2114AC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 15:15:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7A166B02B2; Wed, 12 Aug 2026 11:15:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFC446B02B3; Wed, 12 Aug 2026 11:15:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB6D6B02B4; Wed, 12 Aug 2026 11:15:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 873A86B02B2
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:15:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 02F114043B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:15:54 +0000 (UTC)
X-FDA: 85092967470.16.92DB6CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 62DF140006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:15:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GHTlujo+;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786547753;
	b=XhPTd66CnlTgbK/9jsyfc4EhP0VukMQ9IqfqihwbMhhspPgYWWIptoTKyK2h2M6YARQRfj
	G1pw7GG9FYeN2ytEIoGa7+GVmRtbnhT9HZV4eRZViQojbmulu80rSUKxqcAEDe9JB2AkI/
	J24cdbEv5TQSDcHCDssxC1OVzIwUiPA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GHTlujo+;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786547753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lPh6g5iGS2WA0/mUV2gpwWeFGaucRmMGFZUtCeA+ObU=;
	b=B6X7ju7vSurVL+Gzw/VepH6xUsC+zTjShjXhtca651Sh3hMDtVAf8iBd+NbhMvl3jbP7+z
	SMWvc0V6mwYzAQobaCwz9coWhgUhyFW97oAO2ZXC0k0xn3RXXNvOU24TSlebyC13rBq+hV
	LJdzdr+5T27Uvt+uXEK+sKlb0PEJzaQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C549860A92;
	Wed, 12 Aug 2026 15:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008BC1F00A3F;
	Wed, 12 Aug 2026 15:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786547752;
	bh=lPh6g5iGS2WA0/mUV2gpwWeFGaucRmMGFZUtCeA+ObU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GHTlujo+BUk2vYYvApA/At9WHYcS7dfyrj1YiE1mvYOM7GM0fv23hslpd7x1OO8zW
	 wTiQCxVEmf4xbV71gl4VNve+a7mhG/wg0AINZVJXshFlDjvmkd9MAkiovyCwP9t1pQ
	 LJJA1rhMImJXrBZlq1rB4HpGE95EW4qEtsNz0sYSOFTqIitPsQ5ciVrMRDStX8R1SE
	 8OE1obJb4jSajGyZFxSFFb4XuoeATEsGJuHDk9oGTFuJigl6RK6KQjEwgd741BzNKT
	 2XtVNk/hM7PldF3d6neux8mWAC6PtobkW+ahB1meoeN5bCJzI8qbSDbKHiRzym6Rj6
	 Tpn9tyLCEaajw==
Date: Wed, 12 Aug 2026 18:15:41 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Steffen Dirkwinkel <lists@steffen.cc>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Denis V. Lunev" <den@openvz.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	David CARLIER <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org,
	syzbot@syzkaller.appspotmail.com, Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH 0/5] x86/mm/pat: CPA fixes
Message-ID: <anyOHfbXJAAmbcdi@kernel.org>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <555ea1d43a12c30a8f1eaf10c899b3790d728f33.camel@dirkwinkel.cc>
 <anCK3eWFMwZqq5ka@pedro-suse>
 <anXvODEvV4f_Taj7@lucifer>
 <anxbSdxDlyq__-T1@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anxbSdxDlyq__-T1@pedro-suse.lan>
X-Rspamd-Queue-Id: 62DF140006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: zicp3jpjxmtkwg5d7dmdxmnx8rge7n16
X-HE-Tag: 1786547753-518117
X-HE-Meta: U2FsdGVkX1+Ji4XdQ8Hor+Q+ukl6O8lxE9v0yTT4NU+6+EOZWh4LBb3EqMD4v0OCSHlSupZvSDKeVl7A9MiGeVuUUTaZL0djwYj7LU166ePI7008JHf2ZQFDNCt4HT1+VQuqj/Hr+gyP3iAKQzggTMIztaoRYmfNHdLlDNbOWjKa3g7uFF7h+cynQ8fk4UEhivBPTI8ja4BZSiWATcB5YyKPMTerRY7lBch70yQ3hQxRqRFTIBeprDmEkNFNR9QzMg6ndm30kC5aM9cMqc1l2n3S4oAq/IOnQGPGHfdrPJOjRJIsZZS7ehHp7EGfvEkelwKQOXj4bsYxVPPBZwihwC5O0l6kNKIB9qD2AnfhOxjLYhmZnQZMI/BpbofU7xbXTwk7gLHOD30LRLm1e5Kmo6bs5mciUn9L4djKaWWnvZYmXMzpdDpe4cfeNgtzoSqu+lIdIjBWWE9Zwi2PHwvufMJHm9+bxA4TDJR/M4NP0MoggZv/Humkf8oQUIjzeEmVg3hSuHjvYBxNJQPSW2y+Upph613NXBkfhEUnftPa5ZSJ+1XWqsD8WZLn+w0YIC6myuPGd6OesZCjGtyC/DAXxvfuz96TDbyGkWtAF2R9ykMHerhLcZg7hG5NQWaZpKO637dROcMrYX49iDqYRGa3CAzkmKBdqawjynyre/GAbgJHIPjVWkLOkfPoGNfHxHEr0rvJn9WpsMxVLNzQOeEH5S/VtdLh7DlMKejYl8Z7YMGSRFFu8fR6HvY7+O0Js4vr1Pd7FBZlNWq2+MFH7sfTtoq4N48ocZWcEijxMcZFPMpQT7IL6luiLzah2wraPMYYgxnb9ubrexKRKnO9tcXxkNppQlaN68/7OCF80CNj+AAL3KUj+ZeB+6ra8DklnFQIYGLvu7u5YvwgAH/f+KG1xN276O7fQf3uyhmKNNCqpZSMveyWcaGAt9RxgaYpILZuuNIkB2/4sB3GeD6W9tE
 MORpwJrT
 zq+Joz24pEmHdBe018M6LLXdAltGPhwNFoJh3vPKNamfVHdblppM70W6yzzNirwInJL+/VQrfwDzdQ2uv1P21ylFpnx3w4P1bGZBUCcmCyqBdRpp2ZWpXy7FmqCa409qhtZLDPbCajbjt4tQhdxTY1vTWIRYUIkmD2yL2hWwHst0mtdfrSpup95AqLdc+IHpVfYdIqo0tiPXjHuxUP1achoZTQh41Mv+Hy/kK5zt86vJsL8kS9NuP2ULKcV1en3J0Fqfm/N62ieHaGV5DRs1jnRN2+xWIScDNQVYhkwqrwvbJMMsx7xCJhvMGkzWMyRd9S43FMMrX1DX+xO4jVqHqtlWVIlxrsDq1VLB4zh3lpAzQNCGW0/d3vo32NQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 12:46:09PM +0100, Pedro Falcato wrote:
 Just Hold the mmap lock on callers, but it becomes messy quite quickly)
> 
> Mike, if you get to queue up my patch then please replace the diff with
> Lorenzo's (with a Co-developed-by:, I guess, since he went to the trouble
> of moving quite a few things around). Otherwise, I'll figure out how to
> re-submit it after your series lands.

I moved some things around as well and here's what I've got:

https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=cpa-fixes

Build tested only for now.
 
> -- 
> Pedro

-- 
Sincerely yours,
Mike.

