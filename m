Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88E4FEE20B8
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 16:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBC346B0092; Fri,  6 Feb 2026 11:26:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A3C6B0093; Fri,  6 Feb 2026 11:26:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D76716B0096; Fri,  6 Feb 2026 11:26:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C2BC86B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:26:52 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BA96C132A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:26:51 +0000 (UTC)
X-FDA: 84414560622.23.FC0275E
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf04.hostedemail.com (Postfix) with ESMTP id 791B740013
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:26:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770395209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=swYdSL3A8eqOPSi2GkmYXS2KZ+1Nz51NddJ0qeyLG4Y=;
	b=KIufzgocZdAHzweBme/IaPJPtCVt3JYt3vf7g0KUhpcWB2cUj3Fg8hjPzEdUG4/abxJKdY
	zbTbfE0WR+Z2M053uPut5yEYMZhYu/ls2Mej8cjNzLyW7wvA7U1V20KEgbLZ5BFSOUSUSp
	MSUTFL/tE06B8rb5Ga3wfmL4l6FXauQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770395209; a=rsa-sha256;
	cv=none;
	b=jy2JAr2mTbzu5Ng0ENop3y5ql8RCg0jA+qKX+uHhelUhhjpSHUvMGpAe15zzuPYXobBAo5
	EFIry09jW3ck00O71N6cG2meEJTzcEeGeu0Y2UVsYN4HWKeNkIhFd61daj1939QoI06rUB
	3L9fI5QE/N2Ioa+D50RmxxHF2tDztec=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f6zxY4tVlzHnGfl;
	Sat,  7 Feb 2026 00:26:41 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 6559B4056A;
	Sat,  7 Feb 2026 00:26:46 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 6 Feb
 2026 16:26:45 +0000
Date: Fri, 6 Feb 2026 16:26:44 +0000
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
Message-ID: <20260206162644.000050fe@huawei.com>
In-Reply-To: <aYYOZ1TK5dpX_h_Q@gourry-fedora-PF4VCD3F>
References: <20260115101858.85fd7b8e837c1c92a4fdc5f0@linux-foundation.org>
	<696944eca1837_34d2a10056@dwillia2-mobl4.notmuch>
	<2d1e23ad-7ec1-483b-88b3-70ce19b69106@phytium.com.cn>
	<aXOl9CN_66HywIjZ@gourry-fedora-PF4VCD3F>
	<a90bc6f2-105c-4ffc-99d9-4fa5eaa79c45@phytium.com.cn>
	<20260205145842.efb90572a902ae4c481e6ef6@linux-foundation.org>
	<aYUjf0OrD8f_bJCy@gourry-fedora-PF4VCD3F>
	<20260206110305.00001fbb@huawei.com>
	<aYXtHa4Y2y_5xgcS@gourry-fedora-PF4VCD3F>
	<20260206150941.000028ae@huawei.com>
	<aYYOZ1TK5dpX_h_Q@gourry-fedora-PF4VCD3F>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspamd-Queue-Id: 791B740013
X-Stat-Signature: hnfajewitpin7i8umn4w1yreqw5q51r4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770395208-777735
X-HE-Meta: U2FsdGVkX1/TMw17u8jd19pnVvi7I6U8wskZIZ4Rqv0CrWDrha1hX+PwXnP1VPkIbLCOl4eGiLo7mOB70oFv/2v90kmlUUTb7RH4SgAZpqaFQDpr/PBMn5attfoRMptBBH1zlZPPabEc9EhvsqnGPirMER5yf28/FRXbuXZi8JAZJCDrDxrGhfokj8ujBkBx6pGM9D92mc0+KpbYqEUnjPMtxD/vxo8rQ1kfMlf/X7MEbOS843wDzqDQtVJIZzyzFjKEH7L6zJpEoG4zT4RS77LMoXB9v2qgb1vwofiCHJPDmqm1Hkb+Nhr6I7hr4PVm9YcsWwTcLtgE/eeY47ubBusdYc3VPIhLX9hD+1fzQDbrTPNAnq2czO9rmmxpEnyFATv5x3J3Vc4hPSapkh0YGsbgWvU6/fCXB6socU0Pi4LTMKg16t3gCq/flMpArzs5SuH1xiw2xc9RM6hwn1uJ7IVGyXfKzJ1mt0k9zsMduE+u3+HFkb5BxFywXM3UWroC9quc0/FFcs2AYENrZY/+Cb7bDQCEEDxpgAhHUzjwfIDz8N+uCshfIBdRvECAejzskFcydvgBnrlvYb1DJlBP++jTiCdSVNbcYpqdu306GfNnYJVNNdbTbL+/y4UNNwoR4oNF4rgEzyyQLfHcdHbMVDB6CTT3/NySVbYnmiSZMypi7KxDi/RoZGNZJXJW2C47aHvhs6ZJQYjon1tRAXwJaA8lmubfO43IoOMt5GG65PShdaXRw7OhAkXzl1fzlkj6T38p4CZslB4/MVOtqzqVg7TfxmdYJ/EZzdtoUoYl922r+6dQqi5mE6EE8LOQcaT5Ayn4cSDlO8ICwbG09188Gr+U1t9MhxokmZWEZzPdXcmVHIMTTvx37oAGq8pRqEvYfkSiZ288XgC1LMaYMLaN4DVsqYEzias7C8U0B7hd3y1wY3bX8cwSxSK/9YnYcfzxa/k2UoQ5FYjl1507DEe
 2zlWwWF4
 DJlZFn7KZNLxhOjeWaLYrw4U2Y7SrZ2YpC0VigDM8OYQcWv8/WIcL+tWX542k55p170QhYlOVkH06DTW4deGEbtJjmr8kV4VBUVWGZChUnrUfFDX+BWekQoXhZx4R0YRAeGkQ9XdLV/zi5JMBdXp0EpGXnDKbCCW8OAwZr8PDtV21/RFKDl04A5glJdo+ZHlTbkryK530EcXRc6NPzs6XOldRz6v3V5rmQsNOJssMnnPy9zxR23uzGiltdIpw9NyQFbluDn70Gdc9Pav4fcyavONxncc3DFc3oAjHHrGBtPiNCul8w+d9+2BE8u+LS/+2m6ZQR9ws3P84sJs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 6 Feb 2026 10:53:11 -0500
Gregory Price <gourry@gourry.net> wrote:

> On Fri, Feb 06, 2026 at 03:09:41PM +0000, Jonathan Cameron wrote:
> > On Fri, 6 Feb 2026 08:31:09 -0500
> > Gregory Price <gourry@gourry.net> wrote:
> > 
> > Now a fun corner is that a node isn't created unless there is something
> > in it - the whole SRAT is the source of truth for what nodes exist
> > - so we need 'something' in it - a cpu will do, or a GI, probably a GP.
> > Otherwise memory ends up in node0.  However, fallback lists etc happen
> > as normal when first mem in a node is added.
> >   
> ...
> > For now I 'suspect' we could hack things to provide lots of waiting numa nodes
> > and merrily assign HPA into them as we like whatever SRAT provides
> > in the way of 'hints' :) 
> >   
> 
> look at ACPI MSCT - "Maximum Proximity Domain Information Structure" ;]
> 
> I don't remember reading anything in the ACPI spec that says something
> has to be ON any of these PXMs for it to be accounted for in the MSCT.
> 
> Platforms can just say "Reserve that many Nodes".
> 
> (Linux does not read this value, and on my existing systems, this number
> always reflects the number of actually present PXMs)
> 
> ---
> 
> We probably want to ignore that and just add this:
> 
> CONFIG_ACPI_NUMA_NODES_PER_CFMWS
>     int
>     range 1 4
>     help
>         This option determines the number of NUMA nodes that will be
> 	added for each CEDT CFMWS entry.
> 
> 	By default ACPI reserves 1 per unique PXM entry in the SRAT,
> 	or 1 for a CXL Fixed Memory Window without SRAT mappings.
> 
> 	This will reserve up to N nodes per CEDT entry, even if that
> 	CEDT has one or more SRAT entries.
> 
> then in the acpi/numa/srat.c code that parses srat/cedt, just track
> the number of nodes over a CEDT range.
> 
> for each srat:
>    account_unique_pxm(pxm, srat_range)
> 
> for each cedt:
>    nr_nodes = unique_pxms(cedt_range)
>    while (nr_nodes < CONFIG_ACPI_NUMA_NODES_PER_CFMWS)
>       node = acpi_map_pxm_to_node(*fake_pxm++);
>       if (node == NUMA_NO_NODE):
>       	err("Unable to reserve additional nodes for CXL windows")
> 	break;
>       node_set(node, numa_nodes_parsed);
>       nr_nodes++
> 
> This should fall out cleanly.
> 
> The additional nodes won't be associated with anything, but could be
> used for hotplug - I imagine.
> 

That aligns with what I was thinking as a first solution to allowing this
to be more dynamic.   We can get clever later if this doesn't prove sufficient.

Jonathan

> ~Gregory


