Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6328DC531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 06:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B0FA6B007B; Sat, 25 Jul 2026 02:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 361DE6B0088; Sat, 25 Jul 2026 02:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 253BF6B008A; Sat, 25 Jul 2026 02:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E72B76B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 02:26:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60CE7A1074
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 06:26:32 +0000 (UTC)
X-FDA: 85026315024.20.2D2B1EB
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf20.hostedemail.com (Postfix) with ESMTP id 65C9C1C0007
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 06:26:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm3 header.b=G+mFIm8e;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="b pbAKQm";
	spf=pass (imf20.hostedemail.com: domain of boris@bur.io designates 202.12.124.154 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784960790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+fEzNHdT81nG+FD6y5g3w6OiXhQitOnL0cq79oUPrH0=;
	b=Up3BYOQe4bCnOop0iV5WKXzIxqI6F2dwjVUOtS11W6Jt2f60CUNBxyeG4o98QnxH1fntbG
	OUbNuDaOn4TApmJ1rib7uyNIS2hiQY1eImrB5R4hmCikr5subXucx+7eOTMpR8qJeI8NbA
	y9/0Lls+Hatc4AfP7H+u8GCl8tW2Mr0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784960790;
	b=KBOLRTrornDZ7rWjgoGaWIq/KKMsRWHiCZWF7C5TS7LYvQ8rY3h7Q2Y3bYKZTekHJc1G6T
	xPxuj3A3tnhKvyUQeWbR3zKcQhu9dia+J1S6TESyOX/MR4ootbEjW2AwmLhQEkKn/tCoXT
	exatN9lQ6I/NVzY9o+ln/3dcrK9r7Is=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm3 header.b=G+mFIm8e;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="b pbAKQm";
	spf=pass (imf20.hostedemail.com: domain of boris@bur.io designates 202.12.124.154 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 3CCC97A011F;
	Sat, 25 Jul 2026 02:26:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Sat, 25 Jul 2026 02:26:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1784960789;
	 x=1785047189; bh=+fEzNHdT81nG+FD6y5g3w6OiXhQitOnL0cq79oUPrH0=; b=
	G+mFIm8eeRJJJQH+OPn4mkczWnbar7bJUS7AKAUl4PL/V5FDCwo+XNmTpCBPgc/z
	3KHtLrbr6MAKumC+Em+deHhD2r4b6Y+AOYhjv6zQeB7vhalD/U/8oV2tn5G9vYUS
	eviQtsACIAYkPFIx1OmuaDrax9fGCiV7xu2BTTw4PIkW+6E5QAaj8k9inAp/r16f
	H+cCOjcSfZuWULYekuMIgT3g3NEaXBSRrTMCTgoDsgMqGu7M3TIceTj3E4xk265S
	CtoEkKQ3pcEViab+JLiBZ/Z10snIw4rSCthzV2v8D58y/GqqDVjdSbrxBV4P4TrW
	bHwA2L6PZfwTMu6xhtbrFg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1784960789; x=
	1785047189; bh=+fEzNHdT81nG+FD6y5g3w6OiXhQitOnL0cq79oUPrH0=; b=b
	pbAKQmcgggbwX8VKy5zNLlJ5RgexCNSbBNixh0ZN11eMNoR6qJiHZgbjV5UDf4TC
	+TUoZotcO5GjMIPjmFfvG2h2yx5JBlAmA0X4n6kd2U5sQxzl/GVKFgN8SQFnTkNa
	BXdHLwsrVRQphKOLaJQcD7KHuTuWO1j6m05h4Mb7ETBX2N5j9KHQyCNPv5zJhPD/
	rRseCZcPngIirNKrPk5dIQ82GT8v5TwZvz6CDEdYGerz9wXLLUfVx0coxMCio4tP
	kulYDcUeKCWokqmVDW4N/7RFP2wnoA8HRKx+Hn2gm2kTGp2NFNK0gv2b/ptsKk70
	vfB6Un9BZDHEFAp7lXspg==
X-ME-Sender: <xms:FFdkaoBsceelMrkoB7jAR7IbAFCYdYS2onj2E7HSLkU_Rgfd7pBXYA>
    <xme:FFdkaqFx5BbuOzedQcx_SKJw5VkaZyf0vcso3YPRb0eXq6o40lIt1YYONtcJEUW7_
    PAnD36dh2cbaa7fAsnqBWqpPZZRctUvshKVVrdT2if6bpVqA6qfQyQ>
X-ME-Received: <xmr:FFdkav6aQj4vf-tkOSP5wPgorfb5jpmnF8QMj3KIBOGTBfn6t6A4ZNdYx7-flMjPx4rdbt8k6C7UmLAuAMgfYtwjy6A>
X-ME-Proxy-Cause: dmFkZTE8yrcjtnQH/jhzrzda23ac5bU0bQYcxjJuKgWbVXlvRh3mIDt1sFwNj+VixV9UGv
    ZnG3WPL/BwuSab3UyYWdofQEa69n1FU9ktgikvh0yECfeyOxzbdNN9OeaaH7MtFdUOF2YO
    kDARzmfgJE+DlMlTiciRPcJPBIYvjrawciVgoqL1LDUNW2XLl8b/NZNNFFuX3eGJcNYN+Y
    Tb76ZP2aEz6vlX2wyfC+eHATQP5GJBZR6G+d+tp4GeOX2YkQRkKvfQbiswI+2ZoBt666KF
    YxGgUMUXNrIE6D2ryrjILlc6JZNgUpj3zwd6TYd+AmfDBye3FBO6RTBvYkAWsjDS02vBA7
    49/9NgTycaQORwnHMKkaV7HstnXpeZtCq1NxsdAxgynDilbyyOD0a2wyDKmukHcCvxXMcD
    dSaj8B5W5xCi+i0NBZ+K2YXaVHk9KqYhuwvXFeVdmBJAzPn70m85az9B2ClT7LZGmSYWeW
    nu/Q+Hs7Cv9yYpMw8+nvylBtiofiIhWZxvFaJ+N/nHL3KASxzKNbBjUKcpsw2Xu4fzYdeI
    ziwBDKIofA1RKg42tqIJWhuy9vfRcjMhDdBSWsIp3l1fgf/bMwRKp2FVna1ikQjvGJBJvK
    IrKMSUaRG7YIbpNiLQE7R7e7g86xzTgrps+ZYBKcNm74PReTGPwLGBvjmV1Q
X-ME-Proxy: <xmx:FFdkahSypMBe6riODKTib_JJgX2dM3R2HyPV6NPmlYcAc0ry1farrQ>
    <xmx:FFdkaq5bScPKG0IpAOWFYwSlmIQP5DVc9fuS-zvApYnMEdQshaakDw>
    <xmx:FFdkauRxN_7DBdlrfQppQmGf1l3UiLTl1fJma8V_IXx8dm69c-WEPw>
    <xmx:FFdkavn15HBFGl2I9YFzhbuvLsyOf35Cdo1PfHyzyMUy66-RbXHw1g>
    <xmx:FVdkahdoxsaXwRDBWTLp1u4v9O01as_SwHDOsG9hZ5jgiqpaninKazsj>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 25 Jul 2026 02:26:27 -0400 (EDT)
Date: Fri, 24 Jul 2026 23:26:14 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH/RFC] btrfs: fix folio lock leak in writepage_delalloc()
 for folios dirtied behind btrfs' back
Message-ID: <20260725062614.GA2792359@zen.localdomain>
References: <20260721191152.101118-1-borntraeger@linux.ibm.com>
 <20260721191152.101118-2-borntraeger@linux.ibm.com>
 <b226a6e9-fef2-49bd-b17e-9f9b015626c1@gmx.com>
 <83290932-cb8b-4741-bff0-6a7d8df2c637@linux.ibm.com>
 <224d56d2-fcad-41bf-afe3-6f5f5108172a@gmx.com>
 <f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com>
 <amC-J7yzwk4Z5tHW@casper.infradead.org>
 <ad6eebbd-07f8-41ce-b04c-edd50d91a6e3@gmx.com>
 <amICQYTK9Xu4KLtH@casper.infradead.org>
 <d948c88b-dec5-4e29-b30a-3ea368997ceb@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d948c88b-dec5-4e29-b30a-3ea368997ceb@gmx.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 65C9C1C0007
X-Stat-Signature: hqfz37snpqisp8m33s4e6cowxgg95bic
X-Rspam-User: 
X-HE-Tag: 1784960790-114287
X-HE-Meta: U2FsdGVkX194dww4e+KsqmxVC9jT3/WpZjkDuP2wmbSdFI8jcazmq4fWDRbnL7SM08dYlyI7dUAt3dPqnw/BLTpr4Wa6olcTb8DM8p0vQibeRifUs8liq7l7mBAS23k/YTxkNpFV4TH5Dc6GUo7sT40sUR7A2/yiAxnThFCDEdMP/7DOSJoJk46Bq3wDylAlLTA/NUutx/+Hmdu3sTLFTrqLilwSytZAfb7CAvB0dU8RiAJyaQXCSzUEo4CW38SVWSfwHJ7LHzcleOAXEgRoTgrqOFdYZpTfTn/ojEx72NqXuBZgbPuCv6qbU0U0O+WUIVdcKKT9/kGw2D68EtEf7iHnk7NY+UPL+4Xzeni9BlaqkIQshO5gjJ1nn9hDYPKJA4b5/z3upSOxWUAHK5DXzesbpf05GvnRRG2LrbOfeUXytcwV8wQGuQWaNZRh7GOgL4qNqfVfTlPI4QYM0IoeZYgNpQymALWuLxaPc3AX43Q2ah8BRoQ6wV8h2+DMvQ0ZPIvNZHYJJN5rKj6dKcpg0Bhd1f7gduRwNhImjdEOqkdH8dkVCeAG5d+40cIop21tVOTjdRTK3UN+sAbhtyLuxtm6fqP42rOtWsPKWmLvRM3V4NzF12KxaSVIBstubM2uDHz1I84WpQ1oNmHG9GjsFCsQ9Na2qb6+ZU1sH43EpMCgAJb3B7bcY7M0vJLU/Dam1bf94+P8ceeT/9BA6XwSV/2gq/oD9Z+OuS4vmvJIYD0m7bXtEg3da5N6ncC84U/dpjysI74Pwo/H4SSidLfOWi50eNoc3RrmRjYxK4fOrYmKKArR+FFmZC72tgqC+dDWC0VtqiC6vYWRCCw76X7wrsJ3PsU8hH9taqTkh22VEtP5/JA00NbeE+Dgfu2wagNQJWDuHS4a80uY52G/bvoCRmhgn0pkz4CPRs+JCFt9RR2ZS9ggfm3tOxcrXMcEiL3Ovx9C7CwlAPvSvaYux1T
 Dzi8sROe
 UVmFzkGhWknXPGdJxU5msYBWs8zsazwzPTHJw9yCSIU8YgS8F47BO2gl56asf13PXSvdFB0Vz3F7lIceKYxuw4chNJMsJSNqd9dSGrGtFLIVttks5wfdLovtpwdEo7LzK2+2/2RPpFq5L8HlAKrj+goezRopSVAV1fgUKwSvkUaM9q4TPsXgY1Cm3FsPAqOmNFNxKviLL7UGs3TesICcTyOrrAdEisKm+t9Tw4tBUeMv8qQkK38Vzn/PCW//OsxRlcv0rsUD8sDI0VmD+Uv/nkA4inV2FDJxl99keiaLR1gidAcv2Hd6jXZG2hOthKaIqxsAx84KiApiMM8rWWgqOi7RQlnheHN2cXmL8PxhNzyNPQLMW5noqxMT1QaGAIhgo2wL95EVG1EMN4N77pi6Xtgco95OGXH5kUF2t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 08:10:36AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/7/23 21:30, Matthew Wilcox 写道:
> > On Thu, Jul 23, 2026 at 10:12:27AM +0930, Qu Wenruo wrote:
> > > 
> > > 
> > > 在 2026/7/22 22:27, Matthew Wilcox 写道:
> > > > On Wed, Jul 22, 2026 at 11:29:36AM +0200, Christian Borntraeger wrote:
> > > > >    *   4. Thread B loops sync_file_range(WRITE|WAIT) on the target file.
> > > > >    *      Whenever a full clean cycle (clear_page_dirty_for_io(),
> > > > >    *      writeback, bits cleared) completes inside thread A's
> > > > >    *      submission->completion window, the completion-time
> > > > >    *      set_page_dirty_lock() hits a *clean* folio: filemap_dirty_folio()
> > > > >    *      sets only the folio flag and the xarray tag - no btrfs subpage
> > > > >    *      dirty bit, no delalloc reservation.  See the 20-year-old comment
> > > > >    *      above bio_set_pages_dirty() in block/bio.c describing exactly
> > > > >    *      this ("other code (eg, flusher threads) could clean the pages").
> > > > 
> > > > There's your problem.  filemap_dirty_folio() documents that btrfs is
> > > > doing it wrongly:
> > > > 
> > > >    * Filesystems which do not use buffer heads should call this function
> > > >    * from their dirty_folio address space operation.  It ignores the
> > > >    * contents of folio_get_private(), so if the filesystem marks individual
> > > >    * blocks as dirty, the filesystem should handle that itself.
> > > > 
> > > > fs/btrfs/inode.c:       .dirty_folio    = filemap_dirty_folio,
> > > > 
> > > > so btrfs should have its own btrfs_dirty_folio() which does whatever
> > > > metadata updates it needs to and then call filemap_dirty_folio() to
> > > > take care of the page cache business.  See iomap_dirty_folio() as
> > > > an example, but many other filesystems also do this.
> > > 
> > > Thanks a lot for the advice.
> > > 
> > > However it looks like the sub-folio dirty block tracking is a little
> > > different between iomap and btrfs.
> > 
> > My point is not that "you should do it the exact same way as iomap".
> > Rather "the dirty_folio op is the entry point to tell the filesystem
> > that a folio is being dirtied".
> And since dirty_folio() is not allowed to sleep, we should introduce some
> extra mechanism, e.g. page private 2/checked, to notify the fs that the
> folio is marked dirty without proper preparation.
> 
> Then during writeback, detect such folio and do needed preparation for it
> since at writeback we're allowed to sleep.
> 
> That sounds feasible, but I haven't seen anyone doing that (including the
> older btrfs cow fixup).
> 
> Will explore that path. Thanks a lot again for the dirty_folio() help.
> 
> Thanks,
> Qu

Here is my proposal for a candidate fix. It passes the reproducer in
this thread as well as several more intense reproducers (alluded to but
not yet included)

https://lore.kernel.org/linux-btrfs/6758d4f27be0bbdb865cee7dd5adc435c969f4a3.1784960646.git.boris@bur.io/T/#u

Thanks,
Boris

