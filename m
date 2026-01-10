Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 340ACD277DA
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 09:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E89B36B0088; Sat, 10 Jan 2026 04:53:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21016B0089; Sat, 10 Jan 2026 04:53:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2C7B6B008A; Sat, 10 Jan 2026 04:53:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BEED76B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:53:06 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 447C98889D
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 09:53:06 +0000 (UTC)
X-FDA: 84315590772.13.E047F3D
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4B652140003
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 09:53:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=8bytes.org header.s=default header.b=yoiDrFVL;
	spf=pass (imf09.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768038784; a=rsa-sha256;
	cv=none;
	b=HWgRZfq6e4WDhthGG3ZKlkXmOafBpegkxxInTvhvKFcIOzJhz0IltDx1XrYZpv4+hfb1t/
	37FlQ5p27t7yA7Esqf328HO1uqEKvafuVMEkFyVN35nYPC378Fm8Gqh8xDjFvfEYiU/GHp
	waS+EsGmx83hy4w49r0TZ7/2VyS4HkU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=8bytes.org header.s=default header.b=yoiDrFVL;
	spf=pass (imf09.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768038784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tFZ5pnI9IzgKS9mNoqXMEFIGij+WP0+KRmavPJNHxBw=;
	b=JgrE/Rv7YgRz7vVY9OTnOuUz3kIyL1RDC6JY+a7PBlg8PyHQ/99hC4+7R+LptGE7I13AxA
	4Xlf8343g3OiejtVUFzOir6N2ilHZp+n7kU8PyA+6Ys4D05jnyzcURp4fOhYYIrPH+nCR9
	v7PfYkFhk2vJUmC/z7c56GiklKkyH6w=
Received: from 8bytes.org (p200300f6af1d9600dfc71246d978d903.dip0.t-ipconnect.de [IPv6:2003:f6:af1d:9600:dfc7:1246:d978:d903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 61A745ED0B;
	Sat, 10 Jan 2026 10:53:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1768038781;
	bh=8f2+IkGXwyU7O3VPRSlueHN7/p5N+Fr7AxEkYHrqvh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yoiDrFVLI2g7ITJQIFUgZo5GKLHt1TXSh+HKM2bHlpEATFs3zLxAycUoCSktsw5+M
	 m9DJ087QRHaxMvAUmrRI+0FNhIq5Ss9mD582PVPzJAZJXbKDqTViRZ1DfkR7frOinF
	 yPJfDuoZKnpyY3gB4krZijiB8i1ZkhoZxc82OhJy/qP44TvlxhePGwXLWJhGqlKnZB
	 9pDzITnoCE7YZFnaw75HbH+6eTnkxucmkpKj8u7vBIUFV+2QCykzPUkVW8zllWLnPv
	 ePyCUW8/l0hsnar9iSvV3Zc0eEv0B6Y0ejc4P0kwv26F/Sz3fqdp7WO9lom6oZ3JDC
	 XlgtPKTfgyDag==
Date: Sat, 10 Jan 2026 10:53:00 +0100
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net, will@kernel.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	rppt@kernel.org, xiaqinxin@huawei.com, baolu.lu@linux.intel.com, 
	rdunlap@infradead.org
Subject: Re: [PATCH v6 0/4] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
Message-ID: <hf3gfmaq673tvz6lc7mgip3m4y4o62b3nyqlofas252qr5776y@6oekozsrwea3>
References: <20260109171805.901995-1-smostafa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109171805.901995-1-smostafa@google.com>
X-Stat-Signature: 8mjwzsrm4eekt5hcpkoxkpc5w17rzeub
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4B652140003
X-Rspam-User: 
X-HE-Tag: 1768038784-910375
X-HE-Meta: U2FsdGVkX1/dw+V+s7ILJMVbAzqNKEZhlwYyH272TwuRMLBeFQrdqCUPyh+OedR3UqJ2qAjoHYnKdmusYTlZxjpXzn6gKtnjj6jd7LuOuCbGs1um/dwSTqaborMhIpYdH4qexB+m4HJeeKIFSqSnDugU3ltPG7RHg9d1Zks36X0KraZS+JXQvf4apj9Q7KfroT/1rFha2V+7veWrwOYJ+b+7g/Lpwr/E1IykspN5zO/scHXaQO4HysvN0dnf94jg9KcKSn9YqLwWbz8eYZCEAmuaOTBBy5jlcr4xd5TuJX3HIwhwpKjXR8MHs2zN3pglTChvgoJKvNAE3IxIjyLxRIO6HquBpvlJxO3lL1SFut4B3vp/ufcjPYgc26HEufRQfi2Ueobi/ykfGZ3CEMdfjPf0FIpzlEMoyLaNokFeZKGVrwZ4qQvLELPP8a5lXkuIEgveNCSLxfyL3qeEWV0gCxxeqZlZWQAmmHKlryDRFWzafw2x8v/5wkkS+nJDtz0IHL/Nmjv/Kivi4jn5MjEeJLX78mAEp63nDd71M71J5zVlKFAzjlkQ6OlWfjrtTbLmuHl7Aup5Cg2/OBfgD5lIGTH816DudCyGVd7FFdmnyf/WQeSb4FuW9XSIMZrxbTLZFo+p7Zk/C7gUiNFoEjgsL0gaRBa8qecY31aGult5lCAieIkfxYIfrtJlxMl4MUJ5QyX64d6orTdOyn49eTFoe/JYwTRK4yrYx4AhUK1h3RN8ogWvDKPLoj7URlUEz5TInDY9hIr9o1mmcnOJIbg06/zz7LjS+Oy278biZ1GhpqauMql8O4Npq+oTq6Nus+sQmPYDSSyD+n5nvacPa00MEpU8xyQjWbP/ktsTZEcGVnfW+CBN1fCBlOneoTxEKJA8yws8kxiYJYQcjFFKvoL1u8nV13fOzNK61ElbCl/DvAkJoP6mfDZNGngKulL9G/h1nCltbLPX93j2DDuxTwE
 5LbKyoue
 CKRsmzZndQIgzFb8V9frCYGufj9QaPsAVg0FMyobVKYWMym4zgklM3Bhr5z38e1hOI9LWN2lhd6uo6+AfW80Z+nYOUuTZwhxfHyL4Q286fzg5KjyeRetZ1cf/7kQ+QXXzuC328CElO80A/RRfzx/8X4r5QHhZU4/KX16jbcore3yI1PjAXRrVzBHiy5UURPzko/iVpbvAxtPhbQR+LN8p1pZtZdPLqh9ZAQyQ7tAA58bBEq+ev9Z46Z/l/zBL0A4NLUMCwiIadkzEnJcuyP8C2EoVM6z6Rprsj/7Sj5p/YGU9ZufnmslmM1SMtiZ52gW2SDXWWG+1T5EiiN7p79YLZ6xeNaCJ3bU/GydCj0VNwwCLLw9a4lRsQSlqDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 05:18:01PM +0000, Mostafa Saleh wrote:
> Mostafa Saleh (4):
>   iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
>   iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
>   iommu: debug-pagealloc: Track IOMMU pages
>   iommu: debug-pagealloc: Check mapped/unmapped kernel memory
> 
>  .../admin-guide/kernel-parameters.txt         |   9 +
>  drivers/iommu/Kconfig                         |  19 ++
>  drivers/iommu/Makefile                        |   1 +
>  drivers/iommu/iommu-debug-pagealloc.c         | 167 ++++++++++++++++++
>  drivers/iommu/iommu-priv.h                    |  58 ++++++
>  drivers/iommu/iommu.c                         |  11 +-
>  include/linux/iommu-debug-pagealloc.h         |  32 ++++
>  include/linux/mm.h                            |   5 +
>  mm/page_ext.c                                 |   4 +
>  9 files changed, 304 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
>  create mode 100644 include/linux/iommu-debug-pagealloc.h

Applied, thanks.

