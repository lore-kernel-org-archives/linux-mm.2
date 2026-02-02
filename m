Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B813E7DF0F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 18:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D35246B009D; Mon,  2 Feb 2026 13:46:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2FB6B009E; Mon,  2 Feb 2026 13:46:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE8F6B00A3; Mon,  2 Feb 2026 13:46:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE0DE6B009D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:46:18 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64192B73C1
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:46:18 +0000 (UTC)
X-FDA: 84400396836.11.008B0C7
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id 91EFEC000C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:46:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770057976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FFHniYltMMBLNkB8k789ARXuKpdZq5GB0BhK3NPyc48=;
	b=5PlBzx+YQfwfMVNyb/9OlNqKGHyjusCHpSv9vvVVknP9gfr3xwS0/8JElKNnVf8ZRJEg6n
	kfjoCrx4T474q92VB4pdN+N4iOqX6I6KZr5q7e1w45y5UDKwWnTgmjAv8o0p3JU6lrmyLP
	ekrmvOn365kvr5C8VaxBANcPy7ZMdtg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770057976; a=rsa-sha256;
	cv=none;
	b=elrgPXwD5t8OyDVHlaiV+EFlVDhRHyXwsKQ4csgnZaiU2hEM2z/h3XXeZ9HWugzyDE85ST
	OG9k99zruxhlS/MmKoUmkznO8hQny6Meq6YAxmG3gvvWEHJhHZiK70mbJ0+K1/no3HIZMT
	TqYxf35M1ZzXgDA6FcfCJCk4YJTnN3M=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f4bCV0H9xzJ467X;
	Tue,  3 Feb 2026 02:45:26 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 30AC040565;
	Tue,  3 Feb 2026 02:46:12 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 2 Feb
 2026 18:46:11 +0000
Date: Mon, 2 Feb 2026 18:46:09 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: <linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<kernel-team@meta.com>, <dave@stgolabs.net>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <willy@infradead.org>,
	<jack@suse.cz>, <terry.bowman@amd.com>, <john@jagalactic.com>, David
 Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Andrew
 Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/9] mm/memory_hotplug: add
 __add_memory_driver_managed() with online_type arg
Message-ID: <20260202184609.00004a02@huawei.com>
In-Reply-To: <aYDmor_ruasxaZ-7@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
	<20260129210442.3951412-3-gourry@gourry.net>
	<20260202172524.00000c6d@huawei.com>
	<aYDmor_ruasxaZ-7@gourry-fedora-PF4VCD3F>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Stat-Signature: 1uoymyk6oyk1b5q5s43cj19te7deeegk
X-Rspamd-Queue-Id: 91EFEC000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770057975-118419
X-HE-Meta: U2FsdGVkX18cRFV1FP8IFEX6vH+2aQOwT/Im9ppzx5VMull4hyEv5ETbec1GFEDUusTdvJYcsN/acgeLohMgjbXNnq2eWeqDWbPgk2cja3bRiQfnDK6OKfU9RMOxkQZtl0LxV3OVzC/sNRFq+wSNS5ESsoxLDu+nYDvl8sCDqqC5hpcnjAvg3teSBTJWW8yKrRU5K5x++o07w/c/mbxT8pJjJhGi0cGB+hL3JqnPqK6SZFQC8kvo4/Fe57Y4feuy9ohZKgmqSpsUjJi3UwSes3tGoCuBAuUKeBTIGsygsV0bXUE+dtc+1L9dnNAzMBd89tauoDV4R7X/5J3f6N0IjKv1SRtZbZd0IJLVCZSgXLWLGs/b9CkhI2lWxoOPWTtSPYbOKmBcMvD0hQAiWJFlDybqeURY9zNJwL5ajRzBOx3prGHc3ptTg6YYvxK9pUvRSBrkuq2u2MWkYxn+pQZJOyieqxB7u2gVsM3AyKQHvTldArqA2dAeigxLYiwyLfbkA8Y8po2xrtmgM4tXFQw0RtyuE8Zpzf/Cz98TLcliwTPQFJXur24pGKVPY7oeRz1i/mima493gnGVSEzdapbneXG/eLwToDb9RrXiiu+SOxwy4L8QvXynB9nxeaMIUtkgu3TYI9bBkKM5F4Hxa1rJFtsYWok0FAImFQpfZMcRzmbLMNQz3aOk2izpMJ+f3x9AgEwwEZvyxorpAgk3FsS6/qhmIug3RiDhbDr3qDGt4zxSX+mLNodMHR/NKvUj818jLLnP1tz5FwvuuksnU5BUpIMpAzYoOHelHzaBdwdts+S7iR1iZkJRxTPMRsDdi2YbkiZVILwgrsIX48q1f+WjNqOMgWACjYAcKt+wVi2pGHcYFUERrxVFdqwsumupwynTRMR3j3pdAKncXUrQF+UGZLo8nrD3o/RSZAF7A4TdrzE+VpePdEs8iUXSlZpeUmfucx0QGrU7NC3dJ5S2Zez
 DKn4CmAD
 AlbUmg+6tDkRANsPtzSSKb1iXxxcsuRl8Yn8+lmpe5dsjVTEmpU+lDMfQbnOY4UhxmMoW7DPLpV4mgZZptKJLyVMhfQ8h33/ey7z37slMdAjSITvt9dojesmu+JrRi3iWuR+K+hKIzm2HIRDi9Vyv8yuwEHtZ9CaFGi63F0iVqrE4/QVNUP0XdyDsyc5OG5KLpojOACiQUx+3usLqwszy3DYaB8C5he139iLS0acKC0/wKe6gum+Z278tnyc9YZMlekCV8MIgq5DsbKNrUvWd8KSXo9u3c+ezps3edUXDGg+DDici2/VSnVl/PVpfBryvmh4D7+vEA7hnqUU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2 Feb 2026 13:02:10 -0500
Gregory Price <gourry@gourry.net> wrote:

> On Mon, Feb 02, 2026 at 05:25:24PM +0000, Jonathan Cameron wrote:
> > On Thu, 29 Jan 2026 16:04:35 -0500
> > Gregory Price <gourry@gourry.net> wrote:
> >   
> > > Enable dax kmem driver to select how to online the memory rather than
> > > implicitly depending on the system default.  This will allow users of
> > > dax to plumb through a preferred auto-online policy for their region.
> > > 
> > > Refactor and new interface:
> > > Add __add_memory_driver_managed() which accepts an explicit online_type
> > > and export mhp_get_default_online_type() so callers can pass it when
> > > they want the default behavior.  
> > 
> > Hi Gregory,
> > 
> > I think maybe I'd have left the export for the first user outside of
> > memory_hotplug.c. Not particularly important however.
> > 
> > Maybe talk about why a caller of __add_memory_driver_managed() might want
> > the default?  Feels like that's for the people who don't...
> >  
> 
> Less about why they want the default, more about maintaining backward
> compatibility.
> 
> In the cxl driver, Ben pointed out something that made me realize we can
> change `region/bind()` to actually use the new `sysram/bind` path by
> just adding a one line `sysram_regionN->online_type = default()`
> 
> I can add this detail to the changelog.
> 
> > 
> > Other comments are mostly about using a named enum. I'm not sure
> > if there is some existing reason why that doesn't work?  -Errno pushed through
> > this variable or anything like that?
> >   
> 
> I can add a cleanup-patch prior to use the enum, but i don't think this
> actually enables the compiler to do anything new at the moment?

Good point. More coffee needed (or sleep)

It lets sparse do some checking, but sadly only for wrong enum assignment.
(Gcc has -Wenum-conversion as well which I think is effectively the same)
I.e. you can't assign a value from a different enum without casting.

It can't do anything if people just pass in an out of range int.

> 
> An enum just resolves to an int, and setting `enum thing val = -1` when
> the enum definition doesn't include -1 doesn't actually fire any errors
> (at least IIRC - maybe i'm just wrong). Same with
> 
>    function(enum) -> function(-1) wouldn't fire a compilation error
> 
> It might actually be worth adding `MMOP_NOT_CONFIGURED = -1` so that the
> cxl-sysram driver can set this explicitly rather than just setting -1
> as an implicit version of this - but then why would memory_hotplug.c
> ever want to expose a NOT_CONFIGURED option lol.
> 
> So, yeah, the enum looks nicer, but not sure how much it buys us beyond
> that.
> 
> > It's a little odd to add nice kernel-doc formatted documentation
> > when the non __ variant has free form docs.  Maybe tidy that up first
> > if we want to go kernel-doc in this file?  (I'm in favor, but no idea
> > on general feelings...)
> >  
> 
> ack.  Can add some more cleanups early in the series.
> 
> > > +	if (online_type < 0 || online_type > MMOP_ONLINE_MOVABLE)  
> > 
> > This is where using an enum would help compiler know what is going on
> > and maybe warn if anyone writes something that isn't defined.
> >  
> 
> I think you still have to sanity check this, but maybe the code looks
> cleaner, so will do. 

I'm in two minds about this. If it's an enum and someone writes an int
I take take the view it's not our problem that they shot themselves in
the foot.  Maybe we should be paranoid...

J


> 
> ~Gregory
> 


