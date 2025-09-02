Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21456CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 09:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 800888E000F; Tue,  2 Sep 2025 05:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1698E0001; Tue,  2 Sep 2025 05:55:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE318E000F; Tue,  2 Sep 2025 05:55:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 594688E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:55:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0620B5CD48
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:55:42 +0000 (UTC)
X-FDA: 83843853324.06.F608D77
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5A94840008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:55:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gnNBXARM;
	spf=pass (imf01.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756806940; a=rsa-sha256;
	cv=none;
	b=g9+NiunFQgDqlQm4xbLIzeUfrsUE/ltc/3eMt/Mjr41RuPq+hjp7SrWanPgaCWfm78MEbl
	tjmzfPTbA+1coth6RQ6TJCmc+cw5bqgeitjgUoFykuEC+3uK9/94gs88ww9Tdj7ng19Tas
	AtPMydEpUFDF56nu2l6GHO5VRxBk6vs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gnNBXARM;
	spf=pass (imf01.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756806940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gKxrWfhHC2C3xRmL6LvcZpN3YLRP1h6fc19HOwfkXiw=;
	b=eHUFib1PN+w4FgUNmyF7yMMnrEV/1Q9iWRHLXZe/Llc7cISrv69VHIGaONDO1AAlMzEmWR
	I32PYdti22CZmrNZZT4cdAM/Jf5h2L2YIQHIKV6l/vUC58rQOruyQiQGFxUGJVX4F6KvNA
	DS2PG2HvTIYfxSQQ8U9F4fjNSivyBO0=
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-52a5b6016baso2620943137.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 02:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756806939; x=1757411739; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gKxrWfhHC2C3xRmL6LvcZpN3YLRP1h6fc19HOwfkXiw=;
        b=gnNBXARMNzzhWaWNBTt9nlq1r6OVtsR0u4WbJ4EnNjxjCNXvWEBj8f2GtcbI6U+oEa
         N0n8fjropBRd2cRTqZLjFv5HM5xsEXz8OCG622vKzgHivRxD7q+k872r/08yNmqh1qTY
         HUi22tLh2knr+0MSP7ihSlJ+DigAvgPSuzZG8clLgzO5h9g7KbNHyNoaopesq9kF6w8k
         UT9hlVGcNDcibJt9XqBZD0SvLOeJRNpohvF4PgUlpJZLNjcg4ZlE0TxtAXh6odcM8TPl
         jXFEI8Jljx7Ms2GUqTNgAyu0nIS2sRI3dp1OzpCZiptzLEiB3yoWq2dVs4wy2hom2iQ5
         uQdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756806939; x=1757411739;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gKxrWfhHC2C3xRmL6LvcZpN3YLRP1h6fc19HOwfkXiw=;
        b=pAtY0KuQt0KbbVHPP6F/XYlJcIUxbt4ox4uvo4k2336iD9GcSJOrSj4jk+DwSEVvdA
         0AOgN00xEFzPf//Q1QZWaLMO3lkzJ4pnA3QWIqOYTSAL9hsppypJFtQLSfbbd4gp/QQk
         8XEusQy8tnmfcHCbPNkkr6Vj0/tFkrdhUgvGI0lUuDwSuyh8ndOLlKvtZaa2xIBbio0p
         abAmSFc3Q9JR5WqHqUjNL6nO3hCnwZrzc0wXkUyKa/ndxZwXmXi5+/NuDwgUyIsnmvIt
         DThFH42jmQxIFPE798UKi/FwiecaP9IWEY5PvTBryJUei3vX3tTcATIUBqpDvNE89ERB
         usCA==
X-Gm-Message-State: AOJu0YzQs1RD0oji1EJPoGId7TQQHzvDML/Lxxcu3N5X9+gXpcV7xNc3
	qZ1okoUKcyIthQ0JFrSdnOwTFAofmbwWS0hI0jFgpDiHApYgNsvuUhDh1R+QclGEHzaibxzCh8C
	8N6oOxVgKGgvOa6WB2ISWyLLKN/p8ygE=
X-Gm-Gg: ASbGncuGTs/CzDXqNgw4q7KJYZcCy56ZnVW5KtJMkCPM35aIhbP4xq4F/PkNRlZ47Mg
	P0eYjGc1MJOoyA+XBxm4NoRbKmmpCtNVNyBWsUWF87o2ahAVhe2pYHyVnjVMII+cMM1AcYSdhuV
	9uEqxZ1KS7gfij4ZxjUH/sFcBlvdC3SyRpazX0q0EkCqt/pbFuyMR0GyR97NVN1H4Hp/8qtoH6P
	JgpL58f0RZyEJIpnQ==
X-Google-Smtp-Source: AGHT+IGMmik5TyrlyuE4RR8Ka3YV/vug+vCKrCh4aJKu7j2UH+hFmE+M6JoAk2k5wtHMN7tJ+U54772t0OLJN4gWEoY=
X-Received: by 2002:a05:6102:c4f:b0:51e:609d:316c with SMTP id
 ada2fe7eead31-52b19435191mr3421265137.4.1756806939367; Tue, 02 Sep 2025
 02:55:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-7-ryncsn@gmail.com>
In-Reply-To: <20250822192023.13477-7-ryncsn@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 2 Sep 2025 17:55:26 +0800
X-Gm-Features: Ac12FXwlqVH04N2I3ixY3ZLjS5V-FXn4ZrhEjnHyji21ZZqBEmu0Hd-OTtthbYw
Message-ID: <CAGsJ_4yRa65ogB0d90LmtOigGTqQ9mM-eUU6VbmcX63j6vgHEg@mail.gmail.com>
Subject: Re: [PATCH 6/9] mm, swap: use the swap table for the swap cache and
 switch API
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5A94840008
X-Stat-Signature: b8ruqb5m18wx8a8b9igzfqwque8r5qab
X-Rspam-User: 
X-HE-Tag: 1756806940-662267
X-HE-Meta: U2FsdGVkX18gR1kPMfO+mBP8Eo9rfJF6wSLLUvvQhdsy4o5J+L4PdQkuxfx/MlR0NY6tNxKSUu7NTbLV70IwLF8GTRRtMHbXgPBA9/E68uktn/c1RqvbPh7cCO0aYcI9a70j2XauR2anQgwN09tus4vY0BUDClLkUuGjTEcfYcU93nA+tsQYpny9L5WsoevAOi8I26XenEY8Z8DlK9g2XWdEBJPx7ZNb+gSvyjn4a7N/AlBjzM6s9qs+lKbhazjrmvbf62sxwQyEJeNGXDh0PgsM4A+dY1S0qSGECD5qpF8wy5EhNi54Q+GoHkIjIYiiTol4473b+q4oEosHPG7BhD60uqdAmIrJych7oO7/hv91dMk6EEyLfBWS/hvQtT82Z5CW9lCyjvtFWfwshJAjiTzzqqNcwM7C7lNP6vsLLzucPvkAIydhamztPHj7RViJqYmJmd6nfON9j0s/iLv0gGFT2bDGW8cihD4ZmAbaWn/RwzfSPYjgWTJxVq3QsGv8TCxGUU9f2onp3ww/RVJiKNL19yHvJd4O4NiQ6QUgYdYtv2x0skgq40SzoY7xLy4KptlWIM2sJujc96MKH/qCEggG21H7FVSSB2pd4jRfWYNwhCShi+QHEOfv8EcMHZTkvJ/uybYF5qMSdVvyzVTfTdJT/mmMjtl/hksOKZHtGFp075XV32Kp8K80LqYlLpqb3V25QGvPuuXNzMvq0fAb7qvqBFgphnBA8DZd9HTGqYfSVZYM7U2fIkM88+MeEY7u98cyIgMMpE5uO3s7KYqN8Ec2m2KFf3fkLuR1lVv+IegGMDbDLwGAo3Rh9Fsoln/v3FNmHMaxk+KALLdnO0/GJQKD4kkhSb2HRqrJ/D0CyDV3L/DfQOz22cSrJzH9RTkiLCaXYoZOAIP3sGSqGbO9O3ZkSODeZjWNACyoucl3WZx5JQhpwI4i769Po+9dRxfweS20nzZdg1ftPQom4dE
 yXgDztgl
 B9S9P2x72b4/pxj8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +
> +/*
> + * Helpers for accessing or modifying the swap table of a cluster,
> + * the swap cluster must be locked.
> + */
> +static inline void __swap_table_set(struct swap_cluster_info *ci,
> +                                   unsigned int off, unsigned long swp_tb)
> +{
> +       VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
> +       atomic_long_set(&ci->table[off], swp_tb);
> +}
> +
> +static inline unsigned long __swap_table_get(struct swap_cluster_info *ci,
> +                                            unsigned int off)
> +{
> +       VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
> +       return atomic_long_read(&ci->table[off]);
> +}
> +

Why should this use atomic_long instead of just WRITE_ONCE and
READ_ONCE?

Thanks
Barry

