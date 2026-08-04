Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 461A2C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 546F26B0115; Tue,  4 Aug 2026 11:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51C426B0117; Tue,  4 Aug 2026 11:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45C846B0119; Tue,  4 Aug 2026 11:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FA786B0115
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:07:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3BD6160179
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:07:25 +0000 (UTC)
X-FDA: 85063915650.21.22D0ADC
Received: from va-2-54.ptr.blmpb.com (va-2-54.ptr.blmpb.com [209.127.231.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id A784D40014
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:07:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b="hWciGx/n";
	spf=pass (imf12.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.54 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785856043;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTkMnMJBZbmBk8aXgbvQ0jabgPpSOlUfMkXtPY+IHFY=;
	b=15iLv1sbqNsB9QbsWQUuF51iyFwehiHcCZ5qhGzv8JdsURzhpE9Oh7NuFqH6443i/TRXKg
	VVNTJVtMwJEr0D1iGTJ7v5tSBUioikiCgWYVioAq38R15vfO9B2JrzXTVCsADmIOBTk5gq
	bDnVfLqbGm9iuCOIL7ytdBPepl9SFhI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785856043;
	b=SsE8agQSP/6hXt0GsctbVaSzjaPQ363xzJMTN9K4ifw6LEnVdIgAXrSSR6eCCEvExZ0GS9
	9dyTfppMBCqhuWglQxNaLO+7p6voXpl5BI1fDMmmsVqemwYlEzS2TEF9kuSj5ScCRB3lkA
	Ut7rig0oawnXiTFI4SZN8qdIQloQbFc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b="hWciGx/n";
	spf=pass (imf12.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.54 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785856033;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=aTkMnMJBZbmBk8aXgbvQ0jabgPpSOlUfMkXtPY+IHFY=;
 b=hWciGx/nfSr6Hw5Z64Z2T3Z5ANa+tTAGOmZIvBkd9YhOh9q5nVKiFYBbmu2+8mwtGf7Rpr
 v6ZKlDEVMbUd6752vqSdIZxr8aGtnx1gp0KOOfPc8CfEMIv3l6xB9LaL1gDEGxnvxtzFd3
 2DiI/V4z0yWJYiCRcKLnrhkdkO0/7v42/ljEU3GGL6rMpqB4ztTeOOz9wQXY0lHQuXTiPD
 2ZKXLeD7kBDLDrn3KoKExk/wd5Y6haSQlj89wFXxRZTGCJEWmyaL/sZcTiMGqgw+jjbNgo
 Su7dhb354fuaJvhWkgCzW4p0RJXstOl7HrscXFC91/s8ZMUNAlouz74tYp59Gw==
X-Original-From: yu kuai <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
To: "Christoph Hellwig" <hch@lst.de>, "Jan Kara" <jack@suse.cz>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Date: Tue, 4 Aug 2026 23:07:03 +0800
In-Reply-To: <20260804132527.GA8078@lst.de>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a720020+d3308d+kvack.org+yukuai@fygo.io>
References: <20260804065313.2092022-1-yukuai@kernel.org> <20260804065313.2092022-2-yukuai@kernel.org> <prx5s4rwbgoeh7wtgyo7vwydh5iwqn6qc2utamowirsplspfmp@e3eteq5xwuyf> <20260804132527.GA8078@lst.de>
Cc: "Yu Kuai" <yukuai@kernel.org>, "Jens Axboe" <axboe@kernel.dk>, 
	"Tejun Heo" <tj@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	"Jonathan Corbet" <corbet@lwn.net>, "Josef Bacik" <josef@toxicpanda.com>, 
	"Coly Li" <colyli@fygo.io>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, "Song Liu" <song@kernel.org>, 
	"Dan Williams" <djbw@kernel.org>, 
	"Vishal Verma" <vishal.l.verma@intel.com>, 
	"Dave Jiang" <dave.jiang@intel.com>, 
	"Alison Schofield" <alison.schofield@intel.com>, 
	"Pankaj Gupta" <pankaj.gupta.linux@gmail.com>, 
	"Andreas Gruenbacher" <agruenba@redhat.com>, 
	"Matthew Wilcox" <willy@infradead.org>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	"Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, 
	"Nilay Shroff" <nilay@linux.ibm.com>, "Tao Cui" <cui.tao@linux.dev>, 
	<cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>, 
	<linux-bcache@vger.kernel.org>, <dm-devel@lists.linux.dev>, 
	<linux-raid@vger.kernel.org>, <nvdimm@lists.linux.dev>, 
	<virtualization@lists.linux.dev>, <gfs2@lists.linux.dev>, 
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Message-Id: <a780016f-8f94-4337-b700-786f5487ca3f@fygo.io>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH v1 1/3] blk-cgroup: add helpers for bio cgroup state
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Tue, 04 Aug 2026 15:07:11 +0000
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-Stat-Signature: 1zhp958hbkk1ps3jnzjjkomth6a74okf
X-Rspamd-Queue-Id: A784D40014
X-HE-Tag: 1785856042-609377
X-HE-Meta: U2FsdGVkX1/eds586pYz6i86lRnqEjp84AIc91uDRzmGYhz9FO4oK1NmA9oX0LrxfMsCISdBVYo+zCQbR00cZwH9462NntMbWAi05RqckZ5V2GCNCLEXGIrPszcGMECXwEybsGCMzetWlf06H4bYFpLT+bUhVQG4ZWv66xY3ESr3bnMaGmZ/l1hLBCSHMy1KBildhsY80LWK3GICBx1J3KJH338x8fiG6NJy7ZtoHOTaBRntyOeBYIGtsORO0ddJwWzyuBcHdkhelpIdGcW+JxSoxrs29JWLMiPr6FKDykaNv5qOD2xUEuOW16pSj2cmT/pxJzd7vdxqxZquWtvdnsllDV9SiYEc2IKj7shEVACebl7DCrNvTRVV6sDMq8mTJk/2FeEA6VIPY5c0NZLR4uCQ65QNMfFNFwHb6hDr4QkzdkaABwMyPuRqNumaKYop5DePCXd9u2FzGvLQMtBCAEcxtyCSYorYUrx3W5IJHaFS8iL9Z7RZFmI9Inf6R+QJyefdiTiW6Xh65i7JmsW1k4OR9tjbyg7CHf/TMnCI63MdgxnAvLvMOYuQU2VZmD8mWP2owmtB6mf6UZ9faz0hYcNiQdb2YFmMUcU/bm57qwZpG6pMRqwaPfWzCVOVZeZ0l/+k5yHlIUsA2vvlYmPtgBJzpjzRzTG9K9M15eAdymG7+s7hqqFV1FM8ucFnlC2nbJqXcUHfMqiwghK8jBA09HHs0ijLyXbbTi9O2OtE6GFRT1O9nBHAr81jTSOvc51JAv2wF1YNtwZ7ofWeVdX5gdtg5ZKUSbXEDPfhhC0VOJ1W4MvKtElcyCrqbZ0m8lS8kaNJbK0Aaw43aT2znI3W0QIztuCWwyBqZkTiReDqDRe11tSWdrstwjJOD8Uwz7YAM/+Rsagy9vL1Dz0LqVB3S813ShmAkvv8ODpNlIjgU5EgdFzaBogeQyEIVehRRgLAO2VCVkCt/Ggn+ox/T5P
 b+r4CNv/
 kfZoyxc1ZwuAMcEkU55uV9DvO8vOnhaFZ3QJWUy7V3ysk/mBA+l+LHuwb+b6rC9H+vaniAGRi8mtTXR5q59+5gkvWJMUl2Ijt0oZpL15fOjwicoX0uqwdlCCrOulTJDlNfRrQuMHV75mFhZezxhpUH/AflIpp3yxklKY+/DAA1TPyHOURqqPNB6yT1fkxfurgH1DyPn5wpjUJf3ryG+PEIjZsTiVsBDEWGIDBxpg3LP6Em2W1E0MryWXiEECJNiGQyYfnp/TC7SCxgwtFV0xF+W/e54TwYvbCbiBnivu8Yvpjk7yZOKu+cAryrOTh9yaH9g0x+VU2kolLd/idOsyqPnLFhQwAJY7XElGIAgChBnBCZhjJfYlgI1IXToHL/Wlztm3enJKJ4P4X+uzUYYqjSqvtUCJYd4HN79vMFHUKvjnlAk4/am/id0jS6U+PB67/w5tswOfD2fXKRo6kX8yQgQ8CtzcG53Fa7FV/C+AlvD1pPK6dqVt+7ebafOUJa0JBT6R3JS5LBHdz6mtrMsLb4Unlg3jb6FknFSBERsGPC+bAYjPAlbItQ4k6nhfkpWymTu+sJRDpdHxZa9oiaLDv/DuG3XscbKb71+pzKqGb1sV1WEtyuFIgIvxcXpX92iXmZuh1kQLhFZd+S7LQRmpW5KcP/BzDpS96zZTJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

=E5=9C=A8 2026/8/4 21:25, Christoph Hellwig =E5=86=99=E9=81=93:
> On Tue, Aug 04, 2026 at 12:52:16PM +0200, Jan Kara wrote:
>> Mostly looks good. Just I think bio_blkcg() should gracefully handle the
>> case where bio->bi_blkg is NULL (and return NULL in that case). That way
>> you can also get rid of somewhat odd pattern:
>>
>> 	if (!bio_blkg(bio))
>> 		return ...;
>> 	do something with bio_blkcg(bio)
>>
>> You can then just check bio_blkcg(bio) directly which is much more obvio=
us.
> Yes.  Looking at the whole series I'm also not sure that this makes too
> much sense as a split out patch as the next one touches more than half
> of the callsite anyway.

Yes, this make sense, I'm trying not to cook a huge patch, but patch 2 is g=
row
much bigger than I was expected. Unless I figure out a nicer way to split p=
atch 2,
I'll merge them in the next version.

>
--=20
Thanks,
Kuai

