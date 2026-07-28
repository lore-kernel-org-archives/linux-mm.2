Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 234CFC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 14:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C90B36B0095; Tue, 28 Jul 2026 10:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68916B0096; Tue, 28 Jul 2026 10:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA7546B0098; Tue, 28 Jul 2026 10:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9876D6B0095
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:46:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 128B11C0924
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:46:59 +0000 (UTC)
X-FDA: 85038462558.04.EA4D3F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6BD8414000B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:46:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGgRF5u1;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785250017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T/PYqlUQvMrIaurasbg8b4ywEHZqwHL+68ciOIACLtc=;
	b=Zq+cqkedEMBnccBxt5g9mZiVPS7KDyYhZJxgyvlCv7SGhGPS/yPN12cKbv+UJ1TJHLoAgR
	DckcN6HG37i4tN0hkKJRUeQaQ4bUgDkG7MNUeV5mdkGAuTNaA1ZaRkCvSMwNddwSY3Hifb
	z71ANiyemg5mkOgEvWVWB6A5+zOr9d4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGgRF5u1;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785250017;
	b=3Tyz2ayJ8zJvf2NRkGAqxPDAJ6dKHcWTB9R1jRbFz7VjEKWkEsxzhk5ByZTo+3n9maxUfH
	/MZPzX1sHPds2J9N7JJm7Vy4apw/BlfcCr8mR24Ignn1RixI3qzni+mz0SJBpaBc5vpZ0r
	MHusA85CWKRNQHpKMdnTgW49QoSj0Yo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9828741794;
	Tue, 28 Jul 2026 14:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432E91F000E9;
	Tue, 28 Jul 2026 14:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785250016;
	bh=T/PYqlUQvMrIaurasbg8b4ywEHZqwHL+68ciOIACLtc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UGgRF5u1U4by0nLiLfP39GKxGfrY7/hLGmK3WsMwoAaxmz1Fr6XPKj1wsg6TTfQfs
	 Ntv5ZVCPucM9jmAhFxWIwH6CJpg+GLiafzUgJ1/ysZdzaCTCFDK/IGk+GsZfqnFYDU
	 9LLK5jbSEQZzqOHLO4UrgX19H4VoBgOD4YMnnTlfXSGfHxlfm3MWby92Q973JjdxjV
	 iVuIIjLsNdBXjKN5Ugww82/wqm0/oP/jitDWlvdPLFY17CFds3DggIWMbXk1gJo0Mt
	 SEw6Yh8abyfigH9ahxFFA7UticnT8QAUKjyvQ2YuAR6BtEMbpP4HN8DdCU5YYodK49
	 ESnjBAIorlCCA==
Date: Tue, 28 Jul 2026 15:46:36 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Christian Koenig <christian.koenig@amd.com>, 
	Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>, Dave Airlie <airlied@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/3] mm/huge_memory: add folio_split_driver_managed()
Message-ID: <amjAtdJjBnHmA1Fr@lucifer>
References: <20260722044220.1110278-1-matthew.brost@intel.com>
 <amiyPLdgHGK25X48@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amiyPLdgHGK25X48@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6BD8414000B
X-Stat-Signature: ntbdsz67swdrm3o7ofzkmczziw7f5heq
X-HE-Tag: 1785250017-126739
X-HE-Meta: U2FsdGVkX1/eurIC9gKt2ZXJmsc/QBAHKBZJP5nS0BTGdWQyJqU7i6HTOq7KJmWAr1Y1682c6Opcy3HslZUBtYB5f9l3m+xx3eWTfSsK1e+DNhjH7Nw/hH3zdwHPitTUOnWQ9i/zyxl1ceHsdndQuPRaRLnGgTj7C00yboizj0hrMkSnEjJQCE6i06cRLNfi4pHaSq0ZSTAxzphjnbSetbU5h/7HT7B5EiVVHd0CXUkhM2IuO2582ggOJ/Cctl9rkUVLSwQCJhFV1+/93RRRrhTtZSPFoeoQSdn9DFbKlB2H81I9iUYNJbHT+/WXU4nWzErF4NUXQrk/boL2+H9atzFm9dwfCqK6UPAaVs5RcbKVG/zsoY/tTtGmAjD4akUOG8G452nOhaoIb7Y3mhwPOC5rasiDyYAACwo6EglQ0+w5aabaljjatSOMajieBACvXJUa4w03uodxuo62twx3NtM3z12soaFieROcKvRkxwd0liZvz1enDRhHxOb56PIIBwy0O2262t0kKm1KFBaaXUN7H8siTD1luXGRx92G68dbXGvOq51PfEmVmlG9StYey8JIKxqcKJJsc8uvpzA1Xvk3WokxIjaTLN2unOCUPQJoUuS4LVloRuoRl03W6hnUSd37r1RPPQn8VS/IKq8Vt7QMVNVXUE2RZsKfs/ZRzJ+yaLutzJIBm/M9bzK8sFIFykgbvo3bzhuJKY18q5P9Yz4nBicgKPOBLQNO9qp3KHqxDDmyUrKZpTu0lREsh1zavYi+d6ofwyjTNqzp4MFnwq2Z8j0m5sxkcMMkjDmVYkPv06FmerSffIsNwBhgEpiORdxwj3dAFL7awpCH+m6KE1/zZzIHesLoDZGfCvK6rdncYD6mcTpfQFQI5Y2VTaH+FLHsN7vatM92Z4RZnD7PtFF5JkBBtWVnKi98+rLdT+ga/tuPB0M6Vv66cq8Nqh6xYjikLqEgrGS3kJFSEkG
 oXwr6TAu
 7KW4C6ErUR7UPoUyhutRxuLcrXszv7PESwoHsq7gB6XK2rnEk+/dTKLODgE2dBq5JhSgcAqOBskggfN4QSvNZTbdeypurBsQeq81Np64MoDA6U18mbqSOPx5VkEJLKGiTiPhB0B6VY3sN6JUaA9r5PYLLemkorz2vKXyiG6SNanGN4FDdfsDLNXsBtGiRD/DCyItlOw2M+f6vWHCFVT/j330pf+Onjv7zBQYeJ2zAR+RInBwfKFJcSP/BTMSEnlj0dJ3dB3JWQMwHwhulfDJkxbi65uKn2lN6gCXmA+0jOOhWk7L7dokwcTo0mnvIk/OY1EOa0KOmuEsd8yE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 03:40:55PM +0100, Lorenzo Stoakes (ARM) wrote:
> I know different people have different approaches but PLEASE cc- everybody
> on the whole series for context :)
>
> You may annoy the odd few who want less mail > context but that's the best
> way I think.

OK sorry either I wasn't paying attention, the mail sent slow, or I am blind :P
but I see I'm cc'd on the rest.

Apologies!

Cheers, Lorenzo

