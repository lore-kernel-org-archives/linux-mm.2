Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A98ACAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 02:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 735E48E0005; Thu,  2 Oct 2025 22:31:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E6C28E0001; Thu,  2 Oct 2025 22:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D5688E0005; Thu,  2 Oct 2025 22:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 431CD8E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:31:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E852C13B97A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 02:31:25 +0000 (UTC)
X-FDA: 83955226530.07.5597067
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf08.hostedemail.com (Postfix) with ESMTP id 54BC116000D
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 02:31:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759458684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5zKzeERmICX66ipUeN2ZZQVcp5YXRLnWzLejVXzVC2I=;
	b=LhDU3tr1CgDcbjGgbVnYFk57qw+b5HWNIqX7Q+v/WGgzFHz1sI5diBQBNAqssMFoxECGTW
	EhPgnqsWjI3ZB+NC7e+l+qihkNrAvYBBnNIXwn6T6TTto9/4oKGNvBpTjtozHhutp0tpS1
	EUmvaiCoLrUu154bpEuFNNk1UF8nRKA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759458684; a=rsa-sha256;
	cv=none;
	b=y92qDMqXOBuNZRBR3WsWGHp/JBABwJASswPkz6dlb9EuiGpDbUKXLxnXEiRDLW3iyb8YG9
	e2L9rqNSN76YrStQqeI6vw17nnN93omRkt0Ofl94Irjh5Wa1zt2f8g34EYE53FaB0IAy6D
	s7Drc6orDq72bsHlN21A9DGC51XhJLQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c2dff70000001609-f1-68df3579b3c0
Date: Fri, 3 Oct 2025 11:31:16 +0900
From: Byungchul Park <byungchul@sk.com>
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, gourry@gourry.net,
	ying.huang@linux.alibaba.com, apopple@nvidia.com, clameter@sgi.com,
	kravetz@us.ibm.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, max.byungchul.park@gmail.com,
	kernel_team@skhynix.com, harry.yoo@oracle.com,
	gwan-gyeong.mun@intel.com, yeoreum.yun@arm.com,
	syzkaller@googlegroups.com, ysk@kzalloc.com,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC] mm/migrate: make sure folio_unlock() before
 folio_wait_writeback()
Message-ID: <20251003023116.GB29748@system.software.com>
References: <20251002081612.53281-1-byungchul@sk.com>
 <9a586b5b-c47f-45eb-83c8-1e86431fc83d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a586b5b-c47f-45eb-83c8-1e86431fc83d@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsXC9ZZnoW6l6f0Mg1OLLCzmrF/DZrHrRojF
	+sZ17BZf1/9itvh59zi7xcXXf5gs7i97xmJxfOs8dovra48yWVzeNYfN4t6a/6wW3/qkLS5M
	7GW1OPKmm9ni9w+g+Nwvhhar12RYfFm9is1i9tF77A7CHmvmrWH02DnrLrvHnokn2Ty62y6z
	e2xeoeWxeM9LJo9Nnyaxeyz8/YLZ48SM3yweOx9aevQ2v2Pz+Pj0FovH+31X2TzuXgcqO3et
	j9nj8ya5AIEoLpuU1JzMstQifbsEroyDb1+zFNwVrDjycRlTA2MvTxcjJ4eEgInEydVtzDD2
	mYdnWEBsFgEViftt+xhBbDYBdYkbN36C1YgIaEhsatsAZHNxMAu8Y5Y4umIVWIOwQLjE9PZz
	YDavgIVE+9Q/YLaQQKbE6Y4ZTBBxQYmTM5+AxZkFtCRu/HsJFOcAsqUllv/jAAlzCthJTP/0
	FWyXqICyxIFtx5lAdkkInGKXON48mxXiUEmJgytusExgFJiFZOwsJGNnIYxdwMi8ilEoM68s
	NzEzx0QvozIvs0IvOT93EyMwbpfV/onewfjpQvAhRgEORiUeXo+CexlCrIllxZW5hxglOJiV
	RHgTVtzJEOJNSaysSi3Kjy8qzUktPsQozcGiJM5r9K08RUggPbEkNTs1tSC1CCbLxMEp1cBo
	t5XpVJTr48tRjoLbam90xLE0M28937Rq/9bMFm9zHd9+9mvlWx6KV7D/2Jmg+MdsSpCCpl7c
	WXfR/4t1+38ZmfxZLrzFdkLMZdmACqFbNSf9PlxYKPHM2a2S6aNzT4+UduGN/+nc6dPWJr4P
	yVkkoXNDz1+yw9O+obHbd5Ghy67ZTzTuZSuxFGckGmoxFxUnAgD+MoZN1wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsXC5WfdrFtpej/D4GanpsWc9WvYLHbdCLFY
	37iO3eLr+l/MFj/vHme3uPj6D5PF/WXPWCyOb53HbnF47klWi+trjzJZXN41h83i3pr/rBbf
	+qQtLkzsZbU4dO05q8WRN93MFr9/ACXnfjG0WL0mw+LL6lVsFrOP3mN3EPVYM28No8fOWXfZ
	PfZMPMnm0d12md1j8wotj8V7XjJ5bPo0id1j4e8XzB4nZvxm8dj50NKjt/kdm8fHp7dYPN7v
	u8rmcfc6UNm32x4ei198YAoQiuKySUnNySxLLdK3S+DKOPj2NUvBXcGKIx+XMTUw9vJ0MXJy
	SAiYSJx5eIYFxGYRUJG437aPEcRmE1CXuHHjJzOILSKgIbGpbQOQzcXBLPCOWeLoilVgDcIC
	4RLT28+B2bwCFhLtU/+A2UICmRKnO2YwQcQFJU7OfAIWZxbQkrjx7yVQnAPIlpZY/o8DJMwp
	YCcx/dNXsF2iAsoSB7YdZ5rAyDsLSfcsJN2zELoXMDKvYhTJzCvLTczMMdUrzs6ozMus0EvO
	z93ECIzCZbV/Ju5g/HLZ/RCjAAejEg+vR8G9DCHWxLLiytxDjBIczEoivAkr7mQI8aYkVlal
	FuXHF5XmpBYfYpTmYFES5/UKT00QEkhPLEnNTk0tSC2CyTJxcEo1MLZsuqQfb2GRoHvSu23p
	vy8RV+dpv3Zdc7JzXbGbsIHYwsDU1C9Pm5j36MeUhXtVHv24/fa2rQfuy/TvNWKfpf981rZH
	DR2b9KtU3q6R6LK+oymidfpYX779gvDw3I4p3q/7zVfHvGux/ekhePrThOnHn4ZviOhfXlXA
	e/PfHbnZsTFStyt/n1JiKc5INNRiLipOBAAgnFyIvgIAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: uggm7n47o1pcq6m9jrkttn5xja9ms59z
X-Rspamd-Queue-Id: 54BC116000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759458682-261532
X-HE-Meta: U2FsdGVkX1+83FtGX2fDxmdKkyZaXexMhaUlkBilxu722TDYtQenntzkKqQIW7M3REesr1rUymSXNJNhN9WAt8eYQkOpQ1meKTvUdwjDpRduhgMlWwxhbjV+FAEtkH03TboRlVHLnl1c9MYv2fTr/TVE8lRdLOB46eTVhuJhcUYNX44K+TLqJhoNJxr2Uhq0gbv/igehsBzFCy1LbWY8ZqP9h91zJPxnobSut4gYjQUGjf1LRQSVbOTFb+cSkPFNYeYIjtm3VAYvTjmeHbtEv/WTuU8ynvK7dRT1EDwjmLCQNn7EdLlAdxX4ug/FktKqfbVItS6eQ9mv6As8lDqHD3McyW8/0+OSddmrbsk4yA4x4S9TYAZwEqzmOY5yY3rAW0MmU/Kb8RDgJSE3CY66/PRTGvPSupeQWQLiupEunLv/JjmDXkH3Ffev6gJfZ2PJBChE5JTOKnVGGumsD7jHBL89qMTuBNAWxNApooYxo9Q1vulDgTWs5Lnfbfswn1wqcpBath9RF6Y4PtSf8F6G+PWhMlR5EZupg15WIwbG0zwwhvyJuV4kMDSI3zFj4+4zic5SsEK46xuAkU5gj4+lgMelZ/UDBDS3IJ5Tg2LfWctmSFSWGdxZjDHdi/yPNz0ZxNSrpL35+pOZm/Y9y+k3Dzw4YSNE36XVMqO9v3SpXbpKjxsMp8SRxRzzaamoq433FswHIde61JhXo0MRDKkULhna46fz8NC/oEtRR62+kQIDRRHhxke5cQNRu6zNtc0igFeXRS+V2pG0j0o3HpAioKUe6v37KhsQqWgMrhJLJwXOR2vW6ofNFcfnBgpjGedOk5GyVAVl8ui0I55Ajk8igg4g0ujsAtN4b7PYmFVHCzhrvqja6B3ooSbULU6HzpwuyqhpNUIWRyUbKOlOh5vTQA/GYP+uBEU5ayIfNujc3M+HpQKXpJ6Hj3BfDYAPc22gqLrJkGpkB6DygYKAXcU
 af8gXwls
 p30lPCnTJrF80CCtl5yyd+gTVrIxEPuGZ+5LG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 02, 2025 at 01:38:59PM +0200, David Hildenbrand wrote:
> > To simplify the scenario:
> > 
> 
> Just curious, where is the __folio_start_writeback() to complete the
> picture?

ext4_end_io_end() was running as a wq worker after the io completion.

DEPT report can tell that the following scenario happened with
__folio_start_writeback() called far earlier, at least, before
folio_test_writeback() was seen as true, but unfortunately DEPT doesn't
capture the exact location of __folio_start_writeback().

	Byungchul

> >     context X (wq worker)     context Y (process context)
> > 
> >                               migrate_pages_batch()
> >     ext4_end_io_end()           ...
> >       ...                       migrate_folio_unmap()
> >       ext4_get_inode_loc()        ...
> >         ...                       folio_lock() // hold the folio lock
> >         bdev_getblk()             ...
> >           ...                     folio_wait_writeback() // wait forever
> >           __find_get_block_slow()
> >             ...                           ...
> >             folio_lock() // wait forever
> >             folio_unlock()      migrate_folio_undo_src()
> >                                   ...
> >       ...                         folio_unlock() // never reachable
> >       ext4_finish_bio()
> >       ...
> >       folio_end_writeback() // never reachable
> > 
> 
> But aren't you implying that it should from this point on be disallowed
> to call folio_wait_writeback() with the folio lock held? That sounds ...
> a bit wrong.
> 
> Note that it is currently explicitly allowed: folio_wait_writeback()
> documents "If the folio is not locked, writeback may start again after
> writeback has finished.". So there is no way to prevent writeback from
> immediately starting again.
> 
> In particular, wouldn't we have to fixup other callsites to make this
> consistent and then VM_WARN_ON_ONCE() assert that in folio_wait_writeback()?
> 
> Of course, as we've never seen this deadlock before in practice, I do
> wonder if something else prevents it?
> 
> If it's a real issue, I wonder if a trylock on the writeback path could
> be an option.
> 
> --
> Cheers
> 
> David / dhildenb
> 

