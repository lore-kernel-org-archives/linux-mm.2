Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93ED4C79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93A736B0098; Mon,  7 Sep 2026 12:15:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912516B0099; Mon,  7 Sep 2026 12:15:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8013A6B009B; Mon,  7 Sep 2026 12:15:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 643FB6B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:15:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0479C01DE
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:15:29 +0000 (UTC)
X-FDA: 85187466378.22.892277D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4AAA74000E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:15:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RVmLGkdi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788797728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3HHTxEmMDrd4mbz2CZq7LOhyZdOeqzcmC/xXR4emUF8=;
	b=kdbkogVxc1ROB15Wjv/0yjktRYLOt8iqkr0BQvcz5efH/cbDCk/vDFhQDJBB9VVAbu3707
	wRfXY/C8ftNEzjnWWwS8XFDhvKY/h7PMtKOSZZuX2h932yKGRaGx/d5MXKDw07gaRtVn20
	/m4VRN4tn49RHbPxVCc6EqDxhgIqll0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788797728;
	b=7TKXSfgaXRFQX2mdiWaFMZEKbJ4ho2V8kLvQSGyQ+oXmJtTXw0PmwPg4J9rfONv7ZPmrrN
	trWVZUS2ZnGQksyWgT8UaI92kD0AYoVKSyAYeUlytycsfeF9iea3lU5p09FteFrl9QzNAP
	M5Syhj/SogjaBf7e5J9xb7d5S7Q3QfQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RVmLGkdi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 676244167C;
	Mon,  7 Sep 2026 16:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8871F00A3A;
	Mon,  7 Sep 2026 16:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788797727;
	bh=3HHTxEmMDrd4mbz2CZq7LOhyZdOeqzcmC/xXR4emUF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RVmLGkdiqRDy/Qv/2DAiQkxmtVGnTbk9SrBFJA8m7sVJMLS24Ypdg7O4mYULExi1l
	 ApPOtLm8uIeEorzY0nM29nueqklM237uqHI71Ddu6TczR3NxCwCAEa6saFLf9BJnvp
	 kx8OmnL4LKcbmQGHnO7CeBOWbjRfNcwFsbxAeqqExg/3FicAkvHmMXP8DHF1kYRs/R
	 8TNeOwZKxjD4AJlaOeLLE0n5LufydDGO1sK3NfBPuWeT2rpkuyGWAArwW7+IkfseKf
	 vYNGZujXRwUQYfqCcM4ZJhq2UKtsMQH/Tb/vVdHuIq/2uMOwRXSqeeH0IeuUS2voXZ
	 V4oZrKyLNuiow==
Date: Mon, 7 Sep 2026 17:15:20 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Cedric Le Goater <clg@redhat.com>, 
	Saravanan D <saravanand@crusoe.ai>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: bypass THP tuneables for huge pfnmap
 mappings
Message-ID: <ap7i1vLkfZj4rbNM@gremlin>
References: <20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org>
 <DL08J4JGJ4UK.2G92WO0NK8XU3@nvidia.com>
 <apEzvfGgsvbc3vBI@gremlin>
 <dc52dd1d-f62d-4278-ab4d-95746383fd50@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc52dd1d-f62d-4278-ab4d-95746383fd50@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4AAA74000E
X-Stat-Signature: ugjfudar1nq1n5ioa9133mj95aq41ejd
X-Rspam-User: 
X-HE-Tag: 1788797728-239446
X-HE-Meta: U2FsdGVkX19KJVVlvj4JCO7zdJe1hSjXpGZV4oweax+P7iZ5YdhI7gshJ1dkMLpBGbZMer9LtoHT5MFDHMD0g9+caDUX23fYnjF2/1IX7yavhJ4E1z3cmi/wiqz56Z2NZUNW/RoixiPNsfLA3/de9ZDtaSxgQ29e5Har2YbWsc+HcE6mffvFudXeeVRm4C9D9HhgmAbMSJytLnBhhXymXx7T1cvCpOHe+sXFbaCoelTX6hLEGYtycayES2jif0TUlTuSjs5zEHN7/LoDB/QR7xhnWUTXbMUjPm+fmMdPObOMW5NJVtTtTQV4HEizV6RL/6lk72b+UblVXcPk76QmkuZtb3UcxvU6u3PThRqxHQ9aEEOEk4o6mq2iX1Ny+kOYwpoxQH3v74uCeH36aAISqnqk8bZciiscWp5EUoMJ+K8UmLjwFcmFjwmmgpPC3jPqaJCkdeaFjjBiRD0BloEhIyRbethWUBIF6ZwA1s9kjrP7Oh6TpZqqDbLfVVq2e6mIK1gLmSrEJDUa/h6Gul850A6JmaxzpaH2X5ONvz2zD1mH1JLjpjJ/mHvnGJDclXdXycp3nFlugILpSRxM0FDNuyQOBBsZ1LBj/EWYf6+QkvwWLQMIlfANf9MbBfR52eiMTou82E/Td47Ghe2grCfxIgpotCSpqj4AGmnAFC7ATjF2D76vwLu6kYfMGwxPdi7BHG8ew2x8xjwIqjRcD3/m15OwNbRuVepzfXq4UIveb268HxDe8NvirYWlMmqDAHI8jC6y+t6lDcwG40Gl8T3YFU4+aaFoKXrbFyobRG9NjDY1QzpX6tvy/g7WkivMpIGlqx03384I2YeY8fx6G6lhFLve/dH3GX2pa4Q4ZXswOCw2uHjmd9e0jZekwLwAw1r9/WZWs6B3x1HSWs/4+sBdt0mDJMTO0EWmyXq5q9sfEBbbrFeDfHSX+QNvM6OVBjtF4/Uv6rLs7QPOfQeJY6a
 wVtVqV2d
 ADvSvrvmZgQvh9rwjLQb3joRGQxiyGaGTnj2cMRxxqwoTwCZNCqK8gFYSQT8fv6vtNQuT2TCezmI+2QVpcXJ7tdUdWoLZdMf45bnB1h7MdhaeAa4A8sVZjqlaDUMq4674XEXrccdchzrVV+pirKoruXCk1wnA0VUQ9r9VqrWlK8zy6e8vK1zpoqhBtdwAPXQh1PAeYctlVZy0qHYgZ4NVaxWjOB5LyZ88jodQLbewoQ4L/APR7nC/DNS9IJ/T1ybXxvD/boB+SpAfis/DNKnL27JD1kOyW2sUZ16aPwl1q1VAkL4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 06:08:31PM +0200, David Hildenbrand (Arm) wrote:
>
> >> 1. is vma_allow_thp_tuneables_file() better? Then all three helpers are
> >> vma + a verb + thp_tuneables_file().
> >
> > That's a good idea! Much better thanks.
> >
> >>
> >> 2. is vma_file_ a better prefix than putting file at the end?
> >
> > Yeah, it's an annoying one as kinda want to say 'file-backed VMA' but I think
> > you're right vma_xxx_file() -> vma_file_xxx() is better.
> >
> > Andrew - could you fix that up in place?
> >
> > Obviously if there's further feedback I can respin as well.
>
> Just as a general note I really hate these in-place updates.
>
> For a reviewer perspective (like me stumbling over this) this is just a mess.
>
> Resending with b4 is as easy as it gets.

Ack, you are right to be honest, and I do empathise obviously.

I will respin these in future!

Let me know if you want me to respin this to make life a bit easier?

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

