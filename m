Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3D70CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 13:53:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7F858E0014; Fri,  5 Sep 2025 09:53:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E57428E0003; Fri,  5 Sep 2025 09:53:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D93D28E0014; Fri,  5 Sep 2025 09:53:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8C928E0003
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:53:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 575321189EC
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:53:24 +0000 (UTC)
X-FDA: 83855338728.04.CE410BB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2A014140011
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:53:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NV8s46If
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757080402; a=rsa-sha256;
	cv=none;
	b=L01yZp8lBo0Q++L/geiss1BTORw3F9kZqns1LtGxSRRCA5z8njGSRMJXDbKZgXuizK0hBH
	BuzXc0WpMYVE/VRXUE1Uirz0RovD2HhGs0PHzvzBfJj50tZOf7tBIw0FEhSpTeCEGtTazU
	0iDUZbYOyiiiGg/yiXiQRlBmqNYScnQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NV8s46If;
	dmarc=none;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757080402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1pCvM6whJF4g8toP+FeR/YSNKgWlTWUXFE1HrnRQrF4=;
	b=Oj6p/s9vVRjb84n8B5W/ANoO92U0KxuSvM6z56TjdLnPTfq7eyE/RV8OzDJPse58xFL1+h
	g0Nt/BZXe9A2XWLkhdxXI0y1du5JG20xMkgtTU4zaGXRDxqsZA9+DCvc0KhjJIkxckknkH
	jLAq40jm2HpzSA7fsHkFwvimLSG5Eno=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1pCvM6whJF4g8toP+FeR/YSNKgWlTWUXFE1HrnRQrF4=; b=NV8s46IfJJW0zYiKPHL+fAQCow
	yvwfySzz1yr9xPH/iL4sMdoovrll+IXi/iVJYi3M4SinOH3f2iGszvZwGpMfmTjTSyRvp7IEMfygz
	qgZ/a/ouxqyPxPjtSX7OkjRcqO0UGR4AmWB1NptVEe/fJWzoPsHiVYdtteaODdBYKqv0CwNVtIjLU
	DNfR7vYiv7nox2mhCG0nUhI1CZEBm5VcVS1vVf2fCmVeEZGqlmRKuyIC5cPA/X85rjBchI0neM00I
	yfi30TgDGHcC0c82zLkCWY/mtZ8OuabXail6KDS6v1JOiumUl0atYm51Yv7QdAQZf1BSdyJlD2kvk
	+W4SVECw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uuWsC-0000000HD8k-2G9m;
	Fri, 05 Sep 2025 13:53:04 +0000
Date: Fri, 5 Sep 2025 14:53:04 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: David Hildenbrand <david@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mcgrof@kernel.org,
	gost.dev@samsung.com, Pankaj Raghav <p.raghav@samsung.com>,
	Kiryl Shutsemau <kas@kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3] huge_memory: return -EINVAL in folio split functions
 when THP is disabled
Message-ID: <aLrrQDCBzaMwwmA-@casper.infradead.org>
References: <20250905131352.88069-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905131352.88069-1-kernel@pankajraghav.com>
X-Rspamd-Queue-Id: 2A014140011
X-Stat-Signature: g3zk5p6pdcrhe34csqaxaya3zu8hoju6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757080400-688199
X-HE-Meta: U2FsdGVkX1+Bs+0sldUFrEfFEyxyPATgnZASiLTPxsr3iEhxle/hKkmG+7c+ATud2ouBvkglrVt4k0Ybs0jrSgmsTrHo5nBlF/OumR3F/u53LSlWkw+kvgXKdj4ILnlEszCBVmIzZDiqtI32fBKvUEPurqxYTFAwt759P4tandrZL6qMsfNxRQ4WnP+pwaU3s9d9NrKRMmMIrqpHJKnlTbfIXjQKZ8pvCntZxvBUzVPIT8gyxiewuZZhzwAdUh77vy981pxkv7IwWyrKUQpALCMtNt0Hc0fxSupO/JkCbVCwVeZHRVw1qWjbS6ZR2dkGbHuyWG6/8D6C7kLo150UHKdQO7cgR7tWGMWUovE796sMOxsN1Yt1+UBleIF0G7GXUvNhftwHLs92Ils1n201OJ428WtMc3+4K9o9Rz7BYo27Qe4jsClJXap7G5+8O0l+tPXkQDPqak6C5D7XLiqRYulpAd47XBJBqCCSCa7biBXXOXuan2AYO2A/ejuBiUHrIw/zAsqi6NkADXTcqa71V/bf3AYlnr+UMIOd/L/SIoKY5jfBNPjK5sJqyjYrshNtpsY2MH03/vUnBFumRXURgBiPOToee3UJR8U7bzeQ0v8AkqBxcGjmJzGVTClBRiPeavB8yR7T8j81x2QP94NtXCD5tYm+6gIJac5zXubwLNlUm+XW+r3u0KDa8rDCx6yGSlFi4+6+ayuLfvDuzcfeWglX2voogcb561WQMELEfTkrLs+7L/4rsSyDGmxTpe6cZetkU0XR1RZqUwR77a0JHFlBbNUX4VCkgP/7SEstShr1cyI9znJu5+SeAXKyUKk+xKU0EfVqCcaHFnqmefFRri0clvaSmhFocRyTLuLDW7iDK534hJlqzZBsyIRNFFsGU3O7Q1xeI4nMH/fjQJoOh+Ly7y8TrXNblu51V9M1j/UqUYOP1GbOz+EsvB7Ea/u7cYM3mzv1WwvSeKUXF6w
 xyRgnYsV
 ys24aggPcgITeZgWIWJqg6YbuO8wKbTh6lMg2MUGpffFxRki6or14Uv+QDi+TMu1COIUroRK7c5NY7SuqhwXcHL3uwePrNgrPKl9/nLbo5z0SqriOI7ytzag84IxNTmJ6SUyEDAg0bopomCK2+Wb1qtwy+LPv+Fav1uyCqvJu7AlA0VUa41cPpz8X+QUu5v7Y23WL0vc14bKQ0l+lHD12i9OYnB1aTJB98Lrz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 03:13:52PM +0200, Pankaj Raghav (Samsung) wrote:
> Changes since v2:
>   - use page_folio(page) directly in VM_WARN_ON_ONCE_FOLIO

... why not use VM_WARN_ON_ONCE_PAGE?

