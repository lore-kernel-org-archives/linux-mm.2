Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D17BE9A04A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 14:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18F916B0088; Thu, 19 Feb 2026 09:19:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167926B0089; Thu, 19 Feb 2026 09:19:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09E4A6B008A; Thu, 19 Feb 2026 09:19:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ECF1C6B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:19:39 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 810171C40B
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 14:19:39 +0000 (UTC)
X-FDA: 84461414478.06.A31E042
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id 77D5D4000D
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 14:19:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771510777; a=rsa-sha256;
	cv=none;
	b=jbWf9R3VeUfLl1ZgA604VH09TSUjVY84Y+a7BwJSpVWaTNYW7neITLcJJMO9UMutMK8Jpr
	sBym+Apv1ohk9hzkIME6EOCZJIAff/4lQstYqTnBIkq0FueYw4odn7fZmuAK+SEfKyY83m
	M3ZyYL35hd+aUqHrIwTRaXixvNDdE6M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771510777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1odQz2KgmPi+plwh23qCjejMmbe+Qj2ViPYmxxCrusw=;
	b=Nx9GyfoNBfIbULJ952SQqqyDuyH1itudDZbMiC4V3LqrhZiNLvIpUCjBefHBix9UGD+5yC
	Wu8UpTYof9jpz7J/yJigeboKUeiFJuLJbz5DlL5ShFo89RQP8gU2Nwxc6t7oQVpdmvsxI7
	pnlvTBEF1Ywgwo9Vw5SGp0Ka4JIXN2M=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fGwVG3kLfzHnGj5;
	Thu, 19 Feb 2026 22:19:02 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id B24FA40086;
	Thu, 19 Feb 2026 22:19:32 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 19 Feb
 2026 14:19:32 +0000
Date: Thu, 19 Feb 2026 14:19:30 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: Andrew Morton <akpm@linux-foundation.org>, Cui Chao
	<cuichao1753@phytium.com.cn>, <dan.j.williams@intel.com>, Mike Rapoport
	<rppt@kernel.org>, Wang Yinfeng <wangyinfeng@phytium.com.cn>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <qemu-devel@nongnu.org>, "David Hildenbrand (Arm)"
	<david@kernel.org>
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID
 of CFMW
Message-ID: <20260219141930.0000124a@huawei.com>
In-Reply-To: <aYYXif7IPXnXZPnn@gourry-fedora-PF4VCD3F>
References: <2d1e23ad-7ec1-483b-88b3-70ce19b69106@phytium.com.cn>
	<aXOl9CN_66HywIjZ@gourry-fedora-PF4VCD3F>
	<a90bc6f2-105c-4ffc-99d9-4fa5eaa79c45@phytium.com.cn>
	<20260205145842.efb90572a902ae4c481e6ef6@linux-foundation.org>
	<aYUjf0OrD8f_bJCy@gourry-fedora-PF4VCD3F>
	<20260206110305.00001fbb@huawei.com>
	<aYXtHa4Y2y_5xgcS@gourry-fedora-PF4VCD3F>
	<20260206150941.000028ae@huawei.com>
	<aYYOZ1TK5dpX_h_Q@gourry-fedora-PF4VCD3F>
	<20260206162644.000050fe@huawei.com>
	<aYYXif7IPXnXZPnn@gourry-fedora-PF4VCD3F>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 77D5D4000D
X-Stat-Signature: f66bc8ak4sf1mndckahtwjga8mfp6rri
X-HE-Tag: 1771510776-881799
X-HE-Meta: U2FsdGVkX1/syuQzEUJ9/I5XdhTVOVyuo/HFnQPsglYpryLLFlJ1Y2GPdNlk3Xe/wKTMVi8Pkp29znzc0M3WSrKplPEQ0NIx+fHYvs/fOMLA3mMeMtTkUjl5Df49Ia5CJ8MI1ufmDSfhHW5EprJgAf1NDLVnZaUn24wzdqLLp5xI9nYktd29f8/OuOzwu934CrhEeLc6VEvdCFFh6CYUCgLx3IC3TTMliL3RJFC3/XBA3F7YRYidxvyQ9A8Z5iSs+1YfCa3C0DfKHRJIgETMAJeGeP/4fpJzLLBbaMxxR7aQT1tqrW7/jM74F8Qxs8ylakt/tiGy1p2lnjT94wEaB6PJUwqU7iyi00aR08a+95bF+AfsuNQVPPqsNAeBIxBSYtcQXxZlv27n5Nu+3naT2Hefu0PaIy3ijHBe+E+veg578DRU4NWzx729TZIawTmjsBqkpUIxmPVj6KJ2DcgDhQ7kEKEzth505YhdUsiCVoKrVSgxtgm9ynifYGH/uw3uVq33pg2e/ue9v4HRTPdygAVAY6puv1S27pUNNgEiaaAcb+fDUIVSzy1LSg6sMSnkUB2QKyhNXr9XIs8h57+isIl/WyevOLAVLRRtK5WryN+o/LhO5PvS8mEqI/3SU1SwlTGeiEnsHDHtE7XLDHz5xwmgz8goH34psT/7I0dh8dFGo4VdWpWFU5ahZ7hFg86DjVMU+Hk5eBEawvluEKGOKHnD0xi9dANLVw1GSawFbh3QkE27YGoqybUZm58BXbY3ttTP0nUI5bR+Yxf6o+GXVexNGiuS7zBewo+3xPHCusdgFMJnGjFO5XxnUEmTxuDTg6TAXwVYbC+gFZZ0qJvrPj6z8SMpitPUR0SWBtbPBzJ+uwb6+4sB+3ejnD2/TU1y8XocBzHFY7ZQhVFejcZBCcxoOiPHi+KmGN9PBkQ95yxmOQU78KZj0/VCsB0jY8SkVuQOXlOAbIfRr2uUXLc
 o5LXCcW9
 bvCDNIiknwmC5DGqlkQH9Z87gSfF01Am6mmi8USeKTstbPW19TFM7mq10C2to7W4mcnlfVGYCzX++xs+sMeLDk5iXhteJYU30NfaG53UOXq6o4jfqSA8+nLbs/nn0K2Elhnh5I6f+g3ty9y2xLMGNNYUnkFyswddsm2xmrM5QgBF36ZJrZqBw3xqdWpmKJUiIh2M9tdTUp35eEW4ENu7ayc3//wkblftgAFhDzZn7RxB99JH6jbrAQ+sWrPb9uQPCrzGZIUzaV8yb/qxlH9IMzbPBYe7/JqLkhxMWFBhYtnxUFN7fA2CSNkr0/u+5u1yD7fMZpyJN1vohmD8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 6 Feb 2026 11:32:09 -0500
Gregory Price <gourry@gourry.net> wrote:

> On Fri, Feb 06, 2026 at 04:26:44PM +0000, Jonathan Cameron wrote:
> > > 
> > > This should fall out cleanly.
> > > 
> > > The additional nodes won't be associated with anything, but could be
> > > used for hotplug - I imagine.
> > >   
> > 
> > That aligns with what I was thinking as a first solution to allowing this
> > to be more dynamic.   We can get clever later if this doesn't prove sufficient.
> >   
> 
> I can get this out pretty quickly, hopefully sometime next week.
> 
> I had a long talk with Dan about this topic previously, and I'm not sure
> how we get more dynamic than this to be honest.  nr_possible_nodes is
> *definitely* expected to be immutable after __init all over the kernel,
> it's used to allocate a memory.

Indeed. But that doesn't mean to say they are all in use after __init.

You end up allocating a bunch of space, that is not used until there
is some memory there.  Not a problem.

So dynamic nr_possible_nodes is tricky.  Dynamic allocation of stuff into
those nodes is fine. That happens with memory hotplug today.

J
> 
> Surface area is very large here.
> 
> ~Gregory


