Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F8F9C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 12:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFB566B008A; Fri,  8 Aug 2025 08:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD34F6B008C; Fri,  8 Aug 2025 08:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10D46B0092; Fri,  8 Aug 2025 08:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F9D66B008A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:48:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2079D1601EC
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:48:03 +0000 (UTC)
X-FDA: 83753567646.22.9F8B41A
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf11.hostedemail.com (Postfix) with ESMTP id 57BF940013
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:48:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=AWHt8fvS;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf11.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754657281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pkMYJ2o4F1aHWTWOscA3VXFDMI9SeAOXtPgcMzAcYs8=;
	b=Hd/SR1KDqDTSaKeDng11/Z1FC47D31tVVZwGC4iWxoYcXFvWG4XPaapev2UEgnKtjYGMOn
	TjILYp1fOd6U1mAf8BTIk8j135VlNbEB0COcD0EGdesLITiDov8zQi3oEjReX3oClkPW+l
	f4XNCmtU9lG0HORhoNgMkicyQBmw2ek=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754657281; a=rsa-sha256;
	cv=none;
	b=lbCNgmuijKIFXZadK2onhajawE4XXF8qVxD6egm6V/LPjRFfwkyAzszc+5jXMOR4GYf/UI
	RyW+JgBfiYuUkO8HJU6I4o+3RJHK4S42eNHw8LnWOG1ghqtL6In2whDWNgzOZ2PAGiJVd9
	I0Tfvo/nULu6ozcTFoAtko1JDv7YcaU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=AWHt8fvS;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf11.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4bz3j93hX9z9tHh;
	Fri,  8 Aug 2025 14:47:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754657277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pkMYJ2o4F1aHWTWOscA3VXFDMI9SeAOXtPgcMzAcYs8=;
	b=AWHt8fvS0AlKB3qZ9GpjYc0BYsf9nEejwvWvkSXOYHgvNHxfmBHZbANDdmbDY4R+x4oxx4
	wn/8KiYDOD9RPkpwsTOTfxHHbnVR8fdu49EvKFLWpC84XXP4//tzmgPx3oDCAds2B/Tqyc
	VA/urPVj9d1rqLEY55/S2NaQiq9x0e8chaRU1WvQw1TFJONvhiJEl4m6sxwX4nqAo2xNPk
	Zwjz1G41FuBkw83SV4E+v9n8lpWaZJrUkpiv3BvdT0QYReq6+ssdiJtHrH0GuQKBiy3a6e
	DrNaQOP8fHx/w1BVRSpG6arLYRvIzXl9kS6GKhH+athZYNb4KdZCBu5NcTiNXw==
Date: Fri, 8 Aug 2025 14:47:42 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org, 
	Ritesh Harjani <ritesh.list@gmail.com>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v2 3/5] mm: add persistent huge zero folio
Message-ID: <jd6qvb6erqjmsn6b7imwcsktthbvn6tefwdgfsseakra62t7yh@w5ju2gvvp2mj>
References: <20250808121141.624469-1-kernel@pankajraghav.com>
 <20250808121141.624469-4-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250808121141.624469-4-kernel@pankajraghav.com>
X-Rspamd-Queue-Id: 57BF940013
X-Stat-Signature: ngg589nbquupdmy88p9sy93if49kid1f
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754657281-229798
X-HE-Meta: U2FsdGVkX18NgHUWpXRiizjoTXe996YBhdiIwohvhDXX1GLo/WiIjB599RGh5RRTF4ALlnWE86jdM0SiRmJKpdoVTrb7s31kminrGjYHkMX5v5s3uovXZpvLN1ps4AixR22OhFFOOEJ9RsxsyMOnocjvgo21ziz8KrauIUPV/0Dn328IKCspN6Iwcu8emcOYfey5jAiY/gotkOEQCAw6r/dHX5nnjvAwD0FZczVaNEqg/wtvqVIlEc0ityHr1SkyvnSInMwi9v1qyTYM/6MnrMivLCYPDoUbHM72Rc8hdV8KmgXbwz2lN3vF3/RRSFYbYOIqiFSC9INjFF8qyOToMOhT+MU3XmdTU6BBzal4PCs7tVcE/R3grc35iWl02X4TQrTPR1PtnwVealkCWSDumVDcTKks3T5iFRMttpYOzAC8zn9qJN8W0tKAMinUoWMpegVb4/A+ci+qN+tMAGpIwEMOVfyRe+UFRfX2EY4xztzRXBxZR+ArC8YtI+HkKdk2JiDuALWU4vPoPyExlebeRwkizq8/KGdUrWRMdiW0LCqhRG+qhtE5TB10yuJ5QHxNHIul/vGajiu+6xYH2TRMgrN3dhQrEPsSyyZwPABEkvKzoP7Kpg2sipWsdPscNv0zlVPJJU1EQeZVUq7WWiOkkx/vcqpBNFWxqBjAyM3nFffjhGFaqCmWN3n2SxrT73FSQDoD3z5MxCaeeMMeSy4lvJGHCtm1My+ixwu6waDIcJql2sONuNbaFP84mWkodNsrmLp5Dh22LIqqs6CBX9wqJX7HW2CcJyL2JbWteTKpAxicmB4GpekYxxeehawWMEXOK23bv36YXzTdsfKD+LuOmoovuGfzzdMD3sqf94ESaPRU8fg9s5GcaKtwhhyQwhQnWRjbGEcjkqUe+kxlWph8qt3wJb9caj614DfktckQ8QB9zHJfEued/C6Ryj1SEJlnBPRKuldFSnA85Bjk0WQ
 zuQb+Gr6
 71zvj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +		if (!get_huge_zero_folio())
> +			pr_warn("Allocating static huge zero folio failed\n");

Oops, forgot to do s/static/persistent/ here.

I can fold this in the next version after receiving the comments.

