Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ABD9C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 05:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5A16B008C; Wed, 23 Sep 2026 01:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E526B0092; Wed, 23 Sep 2026 01:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A49576B0093; Wed, 23 Sep 2026 01:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7806B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:47:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58FCB1206C2
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:47:41 +0000 (UTC)
X-FDA: 85243945122.13.7CAC955
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7455E1C0002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:47:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="K+0/BO9e";
	spf=pass (imf21.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790142459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jZS6Cblmkz4hu5U49pdKFJZxwFchldwCDe/Bhlw1gGU=;
	b=G3/bW1sirqHDDQq7PR+UjYbFxvg5AP8CS6IK7+RaUaIZUP0bEENVhoDSCbeleenhjv50W7
	dXpgUhmB6pkVLtJj3qUV6LzTcF6UvklN8gDZuQAh/etgr7/3fXeORnMnht3mEl6WQ/G1Ld
	vKy/OD82kwZzTWFhkbrkVuk2iZyxkgw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="K+0/BO9e";
	spf=pass (imf21.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790142459;
	b=ykeQCFC1VH33jBLHxYRS80q4lTePJ5Hjj3X49TUWXChgAxaDtkS+zTbDJhWZtlyR21V06h
	0fuMT8lMlMtTmp1nI2BlHjs0IXPRkZpB5p7/o15uEscAuH8Cu8YutchO8B/BjsDcqnPdLJ
	OIZXI/U9mN2OEWJP5aj0/AEFrC7wgEQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B60E21A25;
	Tue, 22 Sep 2026 22:47:34 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7F6F93F86F;
	Tue, 22 Sep 2026 22:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790142458; bh=LfZUCcHckxwBJGbXWgZ4XVVNUFEQGrpJOjc9kpc6S74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K+0/BO9eHcs0DtUDS329tW9XVTJxbIwhHYUt8ybGAQtlN9shZxIup/w6+bQ1hYTwL
	 Zv5NnrL68/vFEp533lZgzZZwe63LJx5LID+7GX5UxdHI3EgQBf0WZMIvybeQPRisVh
	 +qK1VQ3VrJfrmL3B46G7ikIh47D6qvgotmhH9+/I=
Date: Wed, 23 Sep 2026 11:17:34 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Muchun Song <muchun.song@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH] mm: Add CONFIG_SPARSEMEM_CLASSIC
Message-ID: <e3neqdb2bym2kq5prnpz7og3lcnbtzg3o4ya22v77t35s3u5jx@tmmx35jhc46k>
References: <20260920070406.95354-1-kaitao.cheng@linux.dev>
 <0baf8c5f-1327-4cb1-867c-e0b08085b9d3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0baf8c5f-1327-4cb1-867c-e0b08085b9d3@kernel.org>
X-Stat-Signature: 9uygop7q4itejc6n71znd1yp1jewxhwc
X-Rspamd-Queue-Id: 7455E1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790142459-467741
X-HE-Meta: U2FsdGVkX19XtBcbklZJbU0w8S+6aUbZAzH1bGU51z52x1RkB3Nko3tlVnYFBazQIYh/5Z05fb91evIJ7AAi37w3Tml63oRMKUDxXIT6yAsGA5Eevb4eLzpTPd/xKYmbPS1fAsy929PqnF4FndSHVQJULyQ+a13BWQPwxY/pfB2HKWMm5qqXQYi5TzrdGEttZxsUArKvYyxBCWAeMlKQ8yjk9z4GBNvFycuB2cTPmXp9vrrA8P8MCHbQL2zyaSiO1IJVmxYyQRPpDZLF3xSu074ccH8VTCi5Q4PbDnOxSWkD0BfrLQwzOhtmwlgX1DonRA9WA+fKPXWUIjNR1PXTvSslnVTfNQEJhqYpcKZW9kjwaUg5l2fx+JZYbCmIwpfGHMxJWlkaJCMIryKsV7iajeyqDD5HkSbxMzd2xTQ8Qvqb85xr2U/M/vkVzvfgEo3tQUr7Qt4j4o4iw7vumJszA1CodTf1LjKHnDKv/8/k9FJ67D95xpEISUZRaz5/F+gNhL6fHz0ybXhJRKn8rBNNfcW0N7p3Gn5mS3X/i0Nuor5QEl+smQ7y1k1tNOI7uR3WxCBoy5ecYutSYBYR08BaZXx16u5gJCj6xmZxzkGw683XXwUNQcdPcugkBx3sSwedlwRTMO3vNMpsfFBtq7ezvWaxZRH0ICsdlU7/Tvo42afoKjjHdGN02ka/GslcXmp5tS0KxmN+l4upSlaW5bnUGOLzDxa5DvYVi5ldmtj2incZ9YFsFd6Ul/PBHPplD3JmAqgvO2mBmfBj4PJzXdFS4jGLcURaCITiY8ylBtU5ALtQJiFielwiOxhgquWJBwbnGJzbJ2ZHP/+8gNilJalQjPAawFhtVj7KHbC60gHbPTNVpZIfDLRMSqlP5SXawLqUe2niDG6ipV+xavJx77aSnJ0Px5AD5KOpWolJ/UDs/vfPvVY+q/R/lYQIK6pvO9aKfmFM8aydhAEmsky/ZMm
 I0arewQD
 uvhTWvpX46uFnsJnifH5JQZxr2YTTW4/UmC0TMUWFe6EfxWsKZ1NS5IWGyoCrdo+7Kgk07FsBQZeHzAd/KK/TGpMg8IBcGZEQodKkZ7Ul4JaybQneCAIP5grxjWMgt+GZS4V6tJZHSddRo8jWmkseNIhFzZPXZUsbK4GGFvCZryG0T8rEvzEvXM3ZO7ZXS/Pn9yX0OninfKWDimshd8RJyTYe/pFxu/1fXIUBKVw8qDhGQCWffVlnFLHgfK1hva8Wf8KietWiPSJ60Jf0evJglXv7HxgGmTfIe3h6FwUTYj7unUe2lJ3q9Ae22/5OwsFPSdbS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 12:34:48PM +0200, David Hildenbrand (Arm) wrote:
> On 9/20/26 09:04, Kaitao Cheng wrote:
> > From: Kaitao Cheng <chengkaitao@kylinos.cn>
> > 
> > Several MM paths identify classic sparse memory by testing
> > CONFIG_SPARSEMEM while also testing that CONFIG_SPARSEMEM_VMEMMAP is
> > disabled. Repeating the compound condition obscures the memory model being
> > selected and requires the local SECTION_IN_PAGE_FLAGS alias for the same
> > state.
> > 
> > Add CONFIG_SPARSEMEM_CLASSIC as a hidden derived option and use it at the
> > conditional sites. Remove SECTION_IN_PAGE_FLAGS and test the new option
> > directly.
> 
> Sorry, but reading CONFIG_SPARSEMEM_CLASSIC I would have no idea how it relates
> to VMEMMAP.
> 
> CONFIG_SPARSEMEM && !CONFIG_SPARSEMEM_VMEMMAP
> 
> is pretty clear in comparison.

Probably there could be an argument to clearly differentiate base and vmemmmap
sparsemem mechanisms, but the proposed patch here does not make it any better.

> 
> -- 
> Cheers,
> 
> David

