Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4F9DC55184
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 00:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE0C6B008A; Tue,  4 Aug 2026 20:58:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6006B0092; Tue,  4 Aug 2026 20:58:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEBCB6B0093; Tue,  4 Aug 2026 20:58:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B09056B008A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:58:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3461FC031D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 00:58:56 +0000 (UTC)
X-FDA: 85065406272.02.7FB8771
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf17.hostedemail.com (Postfix) with ESMTP id DDFB34000E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 00:58:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UKD+o0Q9;
	spf=pass (imf17.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785891534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXCZx29YWK0KuSZTNZlcIo3NjcMPu1Ep/GSGxvMq9+g=;
	b=jq+c0IvjaAVtHHuCS0aD6G9Q9YzdhRc0difDAtdhpG3SkCAT6PLU011E7v+BTL4+8v3Yyh
	USMLBugMf0AFXOFFQ/UPkuZye5ClY5CqxjL0YGlOTWRz0UyxrX82bCd6pQKo2815V6qQdR
	HyGZhU6a/KsvUGwAgWiXnW45DZeB0sU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785891534;
	b=anTcW/xtNThDZXRuS56+hxODhuznab8fxbH6gy82myzdNiRrJ7j6b32eD4A/n9V4zileAY
	TsDrfocaXMnev1APN2ih1eZyNRfS78YOhPecVDob3lV3Mb0VCDsutPD+CMD2EZSPpICoTI
	MXIBQIyeOONx66BGlbcsyiZTX1nVrWs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UKD+o0Q9;
	spf=pass (imf17.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <a340d525-5713-4cf4-b88c-77773ae349d7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785891530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kXCZx29YWK0KuSZTNZlcIo3NjcMPu1Ep/GSGxvMq9+g=;
	b=UKD+o0Q9O0GP/b1+xVPt8DW6AJyHnKdGgtR0kNlepREPLrvPQUsgmz6uhTn2BgsnwwgsW7
	6FERSa+9CQu0aEvQy/RHASDL9rD1MgLiRdBkudQn0F5tsVVNDL9YEXbEVMFS961KB/SsYE
	mzNcNjONJWNh0bFcrOTll82xxRN0PX0=
Date: Wed, 5 Aug 2026 08:58:09 +0800
MIME-Version: 1.0
Cc: cui.tao@linux.dev, Yu Kuai <yukuai@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@fygo.io>,
 Kent Overstreet <kent.overstreet@linux.dev>, Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
 Andreas Gruenbacher <agruenba@redhat.com>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Nilay Shroff <nilay@linux.ibm.com>,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
 virtualization@lists.linux.dev, gfs2@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 2/3] blk-cgroup: store blkcg in bio instead of blkg
To: yukuai@fygo.io, Christoph Hellwig <hch@lst.de>
References: <20260804065313.2092022-1-yukuai@kernel.org>
 <20260804065313.2092022-3-yukuai@kernel.org>
 <a677f581-344b-4d99-846d-a00801e26033@linux.dev>
 <20260804133208.GB8078@lst.de> <0fc5dd22-7a8d-43f0-8555-d2ca966efff6@fygo.io>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <0fc5dd22-7a8d-43f0-8555-d2ca966efff6@fygo.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: wiwhboecze6n9k143xnw3ch7wqk19peo
X-Rspamd-Queue-Id: DDFB34000E
X-HE-Tag: 1785891533-370780
X-HE-Meta: U2FsdGVkX1+v+PUKCQpuwFkyf6ERuSZUgWXufBW6t2R1w9uQB3IcDHixGn7hB7aW0mtMmsHuMiP9AX8fB8mw8LHfhkiX2ZzrVQ+upANiNg2op2xpnEMy6GgdOiz6J+QxpwJMCebgyprnhzbkjrjZzrAa0hQD2IJxRuNwa9z2vNRLA8cty/itzzcV7xPPniOhIRBV6SIF2ivzQzG+kVcy1DKdahKDVXrYfKL6Y0Fq1rV+Pn8QCZ3rO52LeWqdQUqVGMnPRxcMycclzFC2ma6lywaVMSsxwSEx3THaHDcL3KxfXi6+mfg//RPz+r/rBnGkzo2HpKswcYY6eGmKTZ7HlhFrLdhsdIbgpI/kjas6rKSSUQLGceHY6/oYmODKGTMD5/OHp2UzM7vzJQLJVnysyHrbF1E7noGRj1i9ej73G+IO1nqLCin8fip/E4E6Y1R5p+YeOTDhh23hLmq4INYqe5ZmFoSm5gud0muiM6yJdfVFSxMSAbMA6qVesG71Xp2uxiHJpD8UOe90d64/Vih+ANflHbYi6vA1tSwvToGrMhpirvEaUEqiPB2P7PBkEVNyr5z4430KtM05FvxQfLfERukNNrWY87itRwHpyZUUZ4FxUF0zWP/gtF75zxjpsvRpDeY9p+23QYkf8aCjTnX64NLvDGevJLhZnNyyG72nMFRWR8rnXzwIITezwY5HpmS3YCoqObiXFFUe4fLKljJPdGAY+SkMDFHKz947fre2++89c96P+a8QzvUtXBFyOuPzkDN0HnUykIafIl+nyr39ApOKSpCH1Q5qpt4qGtK2DDe6TBMpD54Uav/K0omU/YehXWOr2KncY2MJINlRVT1ZgN1zybfJbkNJ7xJUmWlg5JcLjfUF+3LH5iRrVyIdx/+eR97B57oInRjEmpn3ayxDPGtWVl0fZqW8OQp7pTA6oZ47rGDxZ3bZdqrdQ1rlmn/k43mVUFW8g09N0Orh57h
 qDpcILKT
 7o5zk1zG8/2H3x6n28LY3SbFGeQW1aK9VW6bzbLl2yPxBQQLJRk/r3EBuMLzIfMfNZPkY6/8XmMyCTnEmVZNMCyqNhWAuETJ251UkdZNRu1Za6cBO+we79Wh7A9+o26fTTCQOQj+Mbxj0oFykb9MGnmH1oj80vi+UGPbDr5ybVQHv/IfId4htI71NorgwinIltwJgPEVMgbIwMUdHxgIxgZp6Qni6j9W5/JfQVfnYlj+vksi3RXdnxGvJW+kjVatxbg7OmzpzAlnBuecQLdTf/qqajQpcoGYp0mm6pzgDh8AeZ62O4YJpDee5UQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Kuai,Christoph,
在 2026/8/4 23:30, yu kuai 写道:
> Hi,
> 
> 在 2026/8/4 21:32, Christoph Hellwig 写道:
>> On Tue, Aug 04, 2026 at 05:19:24PM +0800, Tao Cui wrote:
>>> While reading 2/3, one spot in bio_pinned_blkg() made me wonder, so I
>>> gave it a try — and the WARN_ON_ONCE triggers every time for me.
>>>
>>> I may well be missing something, but my worry is that the bio's ref on
>>> the blkg keeps the object alive, not its entry in the radix tree.
>>> blkg_destroy() runs throtl_pd_offline (which only schedules an async
>>> flush) before radix_tree_delete(), so the queued bio ends up dispatched
>>> (blk_throtl_dispatch_work_fn -> blk_cgroup_bio_start ->
>>> bio_pinned_blkg) after the blkg is already gone from the tree, and
>>> blkg_lookup() returns NULL.
>>>
>>> I applied the series and wrote a small reproducer:
>>>
>>>    - null_blk, cgroup v2, a child cgroup with io.max rbps=4096;
>>>    - a read issued in the child cgroup gets throttled and queued, pinning
>>>      the blkg;
>>>    - migrate the reader out and rmdir the cgroup; the queued bio is then
>>>      flushed after the blkg has left the tree.
>> Can you add this to blktests?
>>

yes, I'll turn the reproducer into a blktests case and send
it out. 

>>> Maybe keeping the pinned blkg pointer in the bio would sidestep this, so
>>> the lookup can't miss?
> 
> The problem here is that blkg_destroy can be called while blkg is still pinned
> by blkg_get, in this case remove the cgroup directly remove the blkg from radix
> tree, that's why blkg_lookup can't find this blkg anymore, and the extra blkg ref
> is leaked :(
> 
>> That would grow the bio, which we try hard to avoid.  I think the way to
>> avoid this is to have active/passive refcounts on the blkg, where an
>> active one keeps it in the radix tree, but a 0 passive one would prevent
>> the caller from getting a new reference to it.  The users who rely on the
>> pin for the I/O completion path would then just keep the active reference
>> and use a pure lookup without getting a new passive reference in the
>> completion path.  This would remove the need for BIO_BLKG_REF which
>> feels a bit kludgy and eats up precious bio flag space.
> 
> The problem here is that remove a cgroup can also remove the blkg from radix tree,
> even through it still has active refcounts. I think this can be fixed by checking
> the cgroup online_pin first, if it's zero, we can search the blkg from the
> request_queue blkg list, where blkg will not be removed until blkg_free_workfn().
> What's better, if we can convert the blkg list to hash table with key as blk-cgroup,
> it will be much better as we can lookup from this table instead of blkcg radix tree.
> 

Both of your approaches go further than my store-the-pointer idea;
looking forward to the next version.

Thanks,
Tao

>>


