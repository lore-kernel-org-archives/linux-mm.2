Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD935CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 09:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58A6B6B00DB; Thu, 21 Aug 2025 05:07:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 561FE6B00DD; Thu, 21 Aug 2025 05:07:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478546B00E0; Thu, 21 Aug 2025 05:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35F806B00DB
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 05:07:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6A361173D4
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:07:05 +0000 (UTC)
X-FDA: 83800185210.18.D05DD6F
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1E8B2100010
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:07:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755767223; a=rsa-sha256;
	cv=none;
	b=0/b9arb7xd89hMmSldXI//xHFHJkzmqC5S4dSvv8juf8IWxxuCVAh5nhYjsmvxxGFlkO8o
	BAB+YW/xaj21T2+I6vMqgSswvH9jrbpl1eKPkiM1W4nwKwsW4XofuBUHJRQaSK7UQGqVEn
	Mi31KkGFlo4KI9xkRaEeBzGPAQ8ufQ4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755767223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P6KHGN++9B0cHzCAf7lktA/0F6sC9E6N1flDJmOjn2c=;
	b=uanNUc32Dh05cWm//NtHFRP+u0IAkxysTHLG25vYFF45SUul+2T66Eid5dsz60alPY+uMm
	nNndyfW6oIU/+3iov2Yn28vO9ME9ufDvi/n0AR4PrC8B0zAMdHmCfJRqm2eAXtJRAcV4rS
	P9X+gpgfKJYxYx8RUMVcfHZ47p+6I8o=
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c6y9t4GNYz6JBWR;
	Thu, 21 Aug 2025 17:06:42 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 43D6A1400DB;
	Thu, 21 Aug 2025 17:06:58 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 21 Aug
 2025 11:06:56 +0200
Date: Thu, 21 Aug 2025 10:06:55 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Mike Rapoport <rppt@kernel.org>
CC: Shiju Jose <shiju.jose@huawei.com>, "rafael@kernel.org"
	<rafael@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"dferguson@amperecomputing.com" <dferguson@amperecomputing.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "tony.luck@intel.com" <tony.luck@intel.com>,
	"lenb@kernel.org" <lenb@kernel.org>, "leo.duran@amd.com" <leo.duran@amd.com>,
	"Yazen.Ghannam@amd.com" <Yazen.Ghannam@amd.com>, "mchehab@kernel.org"
	<mchehab@kernel.org>, Linuxarm <linuxarm@huawei.com>, "rientjes@google.com"
	<rientjes@google.com>, "jiaqiyan@google.com" <jiaqiyan@google.com>,
	"Jon.Grimm@amd.com" <Jon.Grimm@amd.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "naoya.horiguchi@nec.com"
	<naoya.horiguchi@nec.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"jthoughton@google.com" <jthoughton@google.com>, "somasundaram.a@hpe.com"
	<somasundaram.a@hpe.com>, "erdemaktas@google.com" <erdemaktas@google.com>,
	"pgonda@google.com" <pgonda@google.com>, "duenwen@google.com"
	<duenwen@google.com>, "gthelen@google.com" <gthelen@google.com>,
	"wschwartz@amperecomputing.com" <wschwartz@amperecomputing.com>,
	"wbs@os.amperecomputing.com" <wbs@os.amperecomputing.com>,
	"nifan.cxl@gmail.com" <nifan.cxl@gmail.com>, tanxiaofei
	<tanxiaofei@huawei.com>, "Zengtao (B)" <prime.zeng@hisilicon.com>, Roberto
 Sassu <roberto.sassu@huawei.com>, "kangkang.shen@futurewei.com"
	<kangkang.shen@futurewei.com>, wanghuiqiang <wanghuiqiang@huawei.com>
Subject: Re: [PATCH v11 1/3] mm: Add support to retrieve physical address
 range of memory from the node ID
Message-ID: <20250821100655.00003942@huawei.com>
In-Reply-To: <aKX_rk0DasbDgJrS@kernel.org>
References: <20250812142616.2330-1-shiju.jose@huawei.com>
	<20250812142616.2330-2-shiju.jose@huawei.com>
	<20250819175420.00007ce6@huawei.com>
	<aKV6dVkPiBPw595T@kernel.org>
	<20250820095413.00003bd7@huawei.com>
	<964fc2721fb7499daa5f49eddfed54ff@huawei.com>
	<aKX_rk0DasbDgJrS@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.66]
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 frapeml500008.china.huawei.com (7.182.85.71)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1E8B2100010
X-Stat-Signature: ruytua3y3fdxitu4pcc5h89uauf3surw
X-Rspam-User: 
X-HE-Tag: 1755767222-454099
X-HE-Meta: U2FsdGVkX1/uq05OVgBrj0EXeTho9E8exd/2SFg3kd0JvZSsCeL+rnR1KX4ghxrsS0pzVP/T3K9Jd88B/+WOoBiklIVK2cnsoTcRaHA2u4u+StSf3WyPpdAlC0rC7eb3Pp9y0qdpFze/jLUYGeNlMKyr+hqlhCxX2NIWWUUshvOOSt7LmJFirf5kex+TPjozsiEi5Zu6Kdn0BbpC32SQDgZ5AEGZuj+gokyfZpLvtabE7YjfqKVf6jzOzx0k0Hl6EwK7KMLskGdEno3nW2Y/YyeLCYQzjeSLPqL4qSrDbTN790l6GucxC9S5vxDC86vz+Ai2dUsCR6GazvFmcUBKkp80oqeUObdCziNqm09JOurzLDWepLHbH2w23sgy5/aNfx6XHlcxoU7PfR4QcKHp44JT75zUu+ER1+Xy1wA6ImEScVGeqNYe7Bo29XACL7EWjBYLjcVMyDuSE1KKnIPOkAmlGuWXmGDhn8+p+LREsKSpiZG3sUC0AJmO+mDACYNvCyUF61YBL/0t0vKX88bZhlZ4P/elGR3fAsDGLNZqcNvvN1XWt61lUImhnBNssGh9yrLKl08wBI5h9ku2lafeoJrQBDFCA+Ls4DKJxS7irtbYFT3OI7HU+Iqa53XHtsmGdO9MGjAFQOV3TFTMQBv6o/AVFzWaeJL/1c7RczNndDi4mPlJzUZZqhqeLL9S1nsEBtb/PLORyuYn9OhY/fEu+2mHfhycbwWDjbrU3OnAilpcp7Rry2jyc34eNXRX/Wxva4KhvFwvcuBfL2WhkDrINeKou0V3ByXky5i1gkFdalAwD5QR1CwPInUoadjCBy3CS0DAc2NKq92b/YS2DVJ72qK6oW3XgLIHNLwOjbXla+UguKybKbZmHZ+mSC573pVxW2UUkhtdSv5yHky2W6VY+CQUcIik6Ukm454wuc/SvWW94gtaoNRsmjl08tntm/j8EjDOFUNxGqhEwySH54B
 +QuOBy4l
 Ct+nY8QAzKf64EDKiE7733GyRU24UgFr1Q83CUjPkLtadQib89NdTUtu2W2Pd/lOReJNvHAVKgcSeJ7V03+zDXkff1OgT6W9B+THSDnPIrpD/h7V/ORhtoqVNcXUbAMduN+rkKisrqzQ6Fu3H3xgz7TqLO5f2hPxMtvO8CEuFpb6BkfS6bu1T0E2th4bBnJFp7vZePXWoJO5gqMZ36Dg1WtB1zKiyoOBTX3d6BFDybX1iuWB9Ws/xdaN436UUzlClAoJfDyBRWA9jTZ+IFDop4H4O5XS5ZPoDmdrQRDbHd+xGChUx9iX9pt0ppbitq8zc5MXbnK1LmNhBf4a2I6cDJSOKuKMZ3JpDGUqIVemCcD2m5UrJRII/gfmtPxxio/db98XVBljBhD33V/CjKcLY4wRqMdBpzsinmm5YazBJCEnvk5yWuI9M5BAdwC+TrMQfCvEb4LoMRpYzJTR0oWneFHZqzX+gvmjiuJTd2ZLU241KFSKOYIThJ+Lxg7RL6wXUjPxxQIiGb81hl8xQWA+ADyCvLVO7z82rJZpJfWx2lUHtkZOewkW2I/O2bGxeudirCrrjfoGIHFV4jCIyJIq3PXpuhIsNSzdyx3Pzkqtv5K8AiSUQLBb4WGni73jn9pVuXju3vNezRScXpQ1Lh3x+Ge0b1PhEVPCyfxE9pgB8lrrtNWrlgbCBIUb/9AhC4sgbcOnhPH443WR5uRmMffKpiz/HC0P5+rPjkBk5HlpdMLV8w9qcwKniNFoGros19FMWPp/DwbcKtL4TfAwFVyq2zrXrbXLH+jU41Gl9O9WqG2iNSjavT5QWmd9yaZFqCfScmMzvcPCamp2leqc5pWmyEUvZIZ7jMe0+TMVPuqGI1daQUd15LI16CWKpAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 Aug 2025 20:02:38 +0300
Mike Rapoport <rppt@kernel.org> wrote:

> On Wed, Aug 20, 2025 at 10:00:50AM +0000, Shiju Jose wrote:
> > >-----Original Message-----
> > >From: Jonathan Cameron <jonathan.cameron@huawei.com>
> > >Sent: 20 August 2025 09:54
> > >To: Mike Rapoport <rppt@kernel.org>
> > >Cc: Shiju Jose <shiju.jose@huawei.com>; rafael@kernel.org; bp@alien8.de;
> > >akpm@linux-foundation.org; dferguson@amperecomputing.com; linux-
> > >edac@vger.kernel.org; linux-acpi@vger.kernel.org; linux-mm@kvack.org; linux-
> > >doc@vger.kernel.org; tony.luck@intel.com; lenb@kernel.org;
> > >leo.duran@amd.com; Yazen.Ghannam@amd.com; mchehab@kernel.org;
> > >Linuxarm <linuxarm@huawei.com>; rientjes@google.com;
> > >jiaqiyan@google.com; Jon.Grimm@amd.com; dave.hansen@linux.intel.com;
> > >naoya.horiguchi@nec.com; james.morse@arm.com; jthoughton@google.com;
> > >somasundaram.a@hpe.com; erdemaktas@google.com; pgonda@google.com;
> > >duenwen@google.com; gthelen@google.com;
> > >wschwartz@amperecomputing.com; wbs@os.amperecomputing.com;
> > >nifan.cxl@gmail.com; tanxiaofei <tanxiaofei@huawei.com>; Zengtao (B)
> > ><prime.zeng@hisilicon.com>; Roberto Sassu <roberto.sassu@huawei.com>;
> > >kangkang.shen@futurewei.com; wanghuiqiang <wanghuiqiang@huawei.com>
> > >Subject: Re: [PATCH v11 1/3] mm: Add support to retrieve physical address
> > >range of memory from the node ID
> > >
> > >On Wed, 20 Aug 2025 10:34:13 +0300
> > >Mike Rapoport <rppt@kernel.org> wrote:
> > >  
> > >> On Tue, Aug 19, 2025 at 05:54:20PM +0100, Jonathan Cameron wrote:  
> > >> > On Tue, 12 Aug 2025 15:26:13 +0100
> > >> > <shiju.jose@huawei.com> wrote:
> > >> >  
> > >> > > From: Shiju Jose <shiju.jose@huawei.com>
> > >> > >
> > >> > > In the numa_memblks, a lookup facility is required to retrieve the
> > >> > > physical address range of memory in a NUMA node. ACPI RAS2 memory
> > >> > > features are among the use cases.
> > >> > >
> > >> > > Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> > >> > > Signed-off-by: Shiju Jose <shiju.jose@huawei.com>  
> > >> >
> > >> > Looks fine to me.  Mike, what do you think?  
> > >>
> > >> I still don't see why we can't use existing functions like
> > >> get_pfn_range_for_nid() or memblock_search_pfn_nid().
> > >>
> > >> Or even node_start_pfn() and node_spanned_pages().  
> > >
> > >Good point.  No reason anyone would scrub this on memory that hasn't been
> > >hotplugged yet, so no need to use numa-memblk to get the info.
> > >I guess I was thinking of the wrong hammer :)
> > >
> > >I'm not sure node_spanned_pages() works though as we need not to include
> > >ranges that might be on another node as we'd give a wrong impression of what
> > >was being scrubbed.  
> 
> If nodes are not interleaved node_spanned_pages() would work, even if there
> are holes inside the node, like e.g. e820-reserved memory.
> So with non-interleaved nodes node_start_pfn() and either
> node_spanned_pages() or node_end_pfn() will give the node extents and they
> are faster than get_pfn_range_for_nid().
> 
> If the nodes are interleaved, though, a single mem_base, mem_size are not
> enough for a node as there are a few contiguous ranges in that node, e.g.
> 
>   0              4G              8G             12G            16G
>   +-------------+ +-------------+ +-------------+ +-------------+
>   |    node 0   | |    node 1   | |    node 0   | |    node 1   |
>   +-------------+ +-------------+ +-------------+ +-------------+
> 
> I didn't look into the details of the RAS2 driver, but isn't it's something
> it should handle?

The aim here is that a query prior to setting a specific range returns
data for at least a range that the scrub controller covers and nothing
it doesn't. So just presenting the first chunk for a node is fine.
There is plenty of info for userspace to figure things out if it wants
to trigger a scrub on 8-12G in your example, but until it does we want
to return 0-4G for the default range.

I hacked up some SRAT tables to give something like the above for testing.
> 
> > >Should be able to use some combination of node_start_pfn() and maybe
> > >memblock_search_pfn_nid() to get it though (that also gets the nid we already
> > >know but meh, no ral harm in that.)  
> > 
> > Thanks Mike and Jonathan.
> > 
> > The following approaches were tried as you suggested, instead of newly proposed
> > nid_get_mem_physaddr_range().
> > Methods 1 to 3 give the same result as nid_get_mem_physaddr_range(), but
> > Method 4 gives a different value for the size.  
> 
> I believe that's because on x86 the node 0 is really scrambled because of
> e820/efi reservations that never make it to memblock.

Fun question of whether we should take any notice of those.
Would depend on whether anyone's scrub firmware gets confused if we scrub
them and they aren't backed by memory.  If they are we can rely on system
constraints refusing to scrub that stuff at an 'unsafe' level and if we
set it higher than it otherwise would be only possibility is we see earlier
error detections in those and have to deal with them.

Jonathan


>  
> > Please advise which method should be used for the RAS2?
> > 
> > Thanks,
> > Shiju
> >   
> 


