Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9BF1F43834
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09CF86B0092; Wed, 15 Apr 2026 11:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027336B0095; Wed, 15 Apr 2026 11:24:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7E6C6B0099; Wed, 15 Apr 2026 11:24:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D27836B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:24:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6996E1A04F3
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:24:56 +0000 (UTC)
X-FDA: 84661162992.30.169BF38
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6C4E9A000E
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:24:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kcGyWJCT;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776266694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRMRmyy9EWk8CIIPpL2LFE86JxkN0Rgl8uTe98Wyi+g=;
	b=hJibYf9dRFCyUQEz+ZDzlDCj5edFVtGN+pu1QERlwRzKs1R2Vh1HdBuOrfWFeb8N/XSBVU
	BGzm0Q66en1DPUru3exWfcnhKF5xJJjXE/r3DKT35oMeRq/TfjYUJupZzU19AfwjpDEHe0
	8E0o5wNLessnhY3WQ+2Pk5oFOdP2eNQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kcGyWJCT;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776266694; a=rsa-sha256;
	cv=none;
	b=1XArXyWjQWZ79ImtXR/ZbGeGrWj5h95Zpcm8FNjcF6D7VY1u50JHZzTONt9zgQHt0kUJxv
	Ku70x6q4Z38u35ixcTQJJ3pOjDqOnDuOt2oXzXctcpqdtgoJ2kcntoqaee6AUhigpSYyOq
	LOQRRaqpe00QeAEhcTWIPPiZ4Pa50Fw=
Date: Wed, 15 Apr 2026 23:24:43 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776266691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zRMRmyy9EWk8CIIPpL2LFE86JxkN0Rgl8uTe98Wyi+g=;
	b=kcGyWJCTD2OLfde0AeTZ55okox+Pnkciu73MjFRJ1zIV5E2AwF6UEHJ9ZYIEbAtmrc0g8L
	SH3hcXYZoNhWkjsAcsmqxjgu0slt/o/s4WqiqcjS7tpcLOiHOHIbMhmzTNbf3dUd/eoMjo
	58m34J5LjDMs/5UYneSKpzAZOJ36RZ4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, baohua@kernel.org,
	chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <ad-tuwdq_AeVRuIr@MiWiFi-R3L-srv>
References: <20260415085658.993859-3-baoquan.he@linux.dev>
 <20260415150550.3616172-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415150550.3616172-1-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6C4E9A000E
X-Stat-Signature: 47nqrnyhir6x8k9z3z4arb8rtyt6ccwo
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1776266694-24799
X-HE-Meta: U2FsdGVkX18ATP8fjwaqVFrGZ0U9GRIrOAZ59X4rCfih689hfx89LUtHkLiL+QsW+Aui3RstMtKQtr8nV24E9BKzrS1+jMcUAnDQdQqEnIFsZ7Qz46bR4OcuCh37Ly8gLBl8NngKQv0oLZTdM+wzDUoa3K9dOMX8AWZptImHSpvVWtJ/ekLrq9msMqZOW2CX0XH0gNsKVccp/jOcgyVSbQKYigNopHck307622lhhmNuRFPQxMioR39UVLpsJyvRdW1Xrp3Cy1Aa5Z1eW/W2pW277ezuIh6GY4IU80q+dEdpgPIc99O4uuIlHJjD8RY70M6IKuXXdj6rw3iHEa6CzBXIz8XQ8i9/tf/MqgcYIh798MRHm1cMMCQgL3J6zakFyzLpWPyDQRLQyo+AXgp8rgBVOBbWl2TbZumnWJzDUsrz136SwupWYwNhcNsn7aKY9nMY6kGB0MprpdoSrE6wPrfD4lvZg8fNkvf92fUP2179Yivtk0eZpyEX3YvKd6INsY3njsOI30qK+vj1LTQjDiRun+QalkcwNdAXLhVxqMKeR+If0iqLObK7mFk8s3si3xyaEnFMKao/m9gE7w6yXjtMy5tFGrMJPK0zmpAiGCr0wcizySd37S5DvlO/lxo6EuE28MmYg7JlM02DaRymrrcXvIqsHDjTHjOWZA3AkW3fKUpMKjkh6E9ZuOeawecBCyzDLL+7nHkmrBbIYrKZJdJBzqpoFDaDogndvS7YwagIamLUKDNw5nB2ua0Oeu30G4Z4Eu3+Ma+HiWkZidGAyTiTiTJYd1YDhsBwfgoWSrpfWGRJecOa/25YZme1o2gcAZ6z00dT1cFDitbMR2LD0dMXfrwKzVyYCjjiAictAQT1c5OLtYSvajMnR0Q9cY1wwvXRPDJ31kb8z2wGz+Vnw1vHiy9CftuvxedLeNeZCe5siturNetXsEKG1XLLjNkb1w4T0agionr8LZrZYEy
 yb9W/8NL
 hmQJDbmw3kgQh0xn0SmQKp/i0Ya6LYahsMt6oVdoQpZu3NuiYYkFNajmMzOHvnx/TqkV/PzsL2ar2nTEOWiql8RIqH57DDHG8W6vhwipbyx1tqMBgrGNmizZcJLKQ/RQBpMKTxeCjKXvp4E6X091JIX2p9Wl1TO+2NuNO8B13V44AAjQRnpmLnsMgH7hm69Pq/FnH8Ly9v2TbebMQf862VPs7GPsx/XBaCkkRsqpMGdWSDjwV6qeQ+KFq8H4BzoO4ydxooIUipg0hhc8RCCAyZfEtrQOZc4dYTjBFwwEY4XYN3m6MAPOFylTsquYsgn6rugVvz/j2tsO5T3fZtGO2WgwBOqytilj3NBoe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/15/26 at 08:05am, Usama Arif wrote:
> On Wed, 15 Apr 2026 16:56:57 +0800 Baoquan He <baoquan.he@linux.dev> wrote:
> 
> > This simplifies codes and makes logic clearer. And also makes later any
> > new swap device type being added easier to handle.
> > 
> > Currently there are three types of swap devices: bdev_fs, bdev_sync
> > and bdev_async, and only operations read_folio and write_folio are
> > included. In the future, there could be more swap device types added
> > and more appropriate opeations adapted into swap_ops.
> 
> s/opeations/operations/

Good catch, thanks.

> 
> > 
> > Suggested-by: Chris Li <chrisl@kernel.org>
> > Co-developed-by: Barry Song <baohua@kernel.org>
> > Signed-off-by: Barry Song <baohua@kernel.org>
> > Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> > ---
> >  include/linux/swap.h |   2 +
> >  mm/swap.h            |  10 ++++-
> >  mm/swap_io.c         | 102 +++++++++++++++++++++++++------------------
> >  mm/swapfile.c        |   5 +++
> >  mm/zswap.c           |   2 +-
> >  5 files changed, 76 insertions(+), 45 deletions(-)
> > 
...snip...
> > diff --git a/mm/swap_io.c b/mm/swap_io.c
> > index 4bf210bd677e..602e9b871b30 100644
> > --- a/mm/swap_io.c
> > +++ b/mm/swap_io.c
...snip...  
> > @@ -604,6 +588,44 @@ static void swap_read_folio_bdev_async(struct folio *folio,
> >  	submit_bio(bio);
> >  }
> >  
> > +static const struct swap_ops bdev_fs_swap_ops = {
> > +	.read_folio = swap_read_folio_fs,
> > +	.write_folio = swap_writepage_fs,
> > +};
> > +
> > +static const struct swap_ops bdev_sync_swap_ops = {
> > +	.read_folio = swap_read_folio_bdev_sync,
> > +	.write_folio = swap_writepage_bdev_sync,
> > +};
> > +
> > +static const struct swap_ops bdev_async_swap_ops = {
> > +	.read_folio = swap_read_folio_bdev_async,
> > +	.write_folio = swap_writepage_bdev_async,
> > +};
> > +
> > +int init_swap_ops(struct swap_info_struct *sis)
> > +{
> > +	/*
> > +	 * ->flags can be updated non-atomically, but that will
> > +	 * never affect SWP_FS_OPS, so the data_race is safe.
> > +	 */
> > +	if (data_race(sis->flags & SWP_FS_OPS))
> > +		sis->ops = &bdev_fs_swap_ops;
> > +	/*
> > +	 * ->flags can be updated non-atomically, but that will
> > +	 * never affect SWP_SYNCHRONOUS_IO, so the data_race is safe.
> > +	 */
> > +	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> > +		sis->ops = &bdev_sync_swap_ops;
> > +	else
> > +		sis->ops = &bdev_async_swap_ops;
> > +
> > +	if (sis->ops || sis->ops->read_folio || sis->ops->write_folio)
> > +		return -1;
> 
> sis->ops is always non-NULL, and you will return -1 here and
> swapon will always fail with -EINVAL.
> 
> You probably wanted?
> 
>       if (!sis->ops || !sis->ops->read_folio || !sis->ops->write_folio)
>           return -1;

You are right. Think one thing, write another. Will fix it in v4.
Thanks a lot for your careful reviewing.

> 
> > +
> > +	return 0;
> > +}
> > +
> >  void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
> >  {
> >  	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);

