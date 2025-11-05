Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0943ECCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 18:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 296738E0005; Wed,  5 Nov 2025 13:16:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247248E0002; Wed,  5 Nov 2025 13:16:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1104E8E0005; Wed,  5 Nov 2025 13:16:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F12AD8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:16:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA9DC1A0213
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:16:53 +0000 (UTC)
X-FDA: 84077359506.28.343F4FE
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id B5FFB80004
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:16:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=DVUHtcIM;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.43 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762366611; a=rsa-sha256;
	cv=none;
	b=loXnfHYgVDXu7LpZHG3tswtM9DVF5tG8uDnnW57jamE5QkIAYOVfL+JVg+U6y8HfrZz+V6
	i4o8Xt18QR8VKlcsMbYBKlkZ0S0R2OSsC4AmUNzw2aQcTYOflYLVhYZJq7Iqacw2MNT+FU
	xWtebnKo/soiqKBbSoLcj0GnukRYmlU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=DVUHtcIM;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.43 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762366611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CHsVV9xGLdeBVjQzQ+KO9Y00h83ZIy5yu3puOCqoV9g=;
	b=a8z1BZ7+2ii+enwZDTaDy0ctcZIr26i76hucHxBB3/7xufcWCxvZNXy99zGt/+5MzyLepP
	A6BZRwYbXoGZsiqLtGipyiDswRXIA/9UmxnVqsq6lQ9t8/jrsWO93cPP6bgmMaY/VnlySe
	hWjVxHbJXZWiieQTstwJ8G0nihJaVTE=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-880503ab181so2201026d6.2
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 10:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1762366611; x=1762971411; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CHsVV9xGLdeBVjQzQ+KO9Y00h83ZIy5yu3puOCqoV9g=;
        b=DVUHtcIMT4/DRkkBbKwgXMT4oikUvF2s6AZOtJlRmpLzw1euCSbT1EYme3+yMPqxmt
         R6M/v9fP3Dd8nOzjMQ4AQfbO3PIpGoQ7egUElfiqixtXFLOD/blyfmebcfa20JFYPqH7
         fqov0q65Xn7VN8VNSIYH7luVtXXiJWW1e+uMV8u5lJzhARgTH61LfXLdEaYsUZCFLtwi
         THEON+fPA7B0JtZtwRTZANYLNQBJ28TLH6vtr+864JwUHjd318gsVMTMIoP3OeY8k9QQ
         CiLD63kMJ0tx8T6TYofyGZyTqt6dBhdEedrv1u4zn7NzNSEYbmjJf7M4sHX9utBnewoN
         Dk3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762366611; x=1762971411;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CHsVV9xGLdeBVjQzQ+KO9Y00h83ZIy5yu3puOCqoV9g=;
        b=nJ0JTRQREYU4iV7CrYnf19Vo8YN/jVeZMpEwkWwAVwSYud8/qDIJtDw2TmpUQ1i2jC
         /Lf9v8mbe9BA62RgwGtOq6LOQcpMcHmYT6D9XOSUXP/1ZQLXwEzhFfw6YiE7TBDLtSvo
         7JkTGLeX49RgmnbZ9lreORHYWCK+MZPCY908qoTVnqvhnNMStExW+zdO7ya45GjPw154
         zzdGMKisvnprEA6RGnQ7OEHJTi7GQwPl3tXYvSEgaZnIK/kIBaiuaXBuddTMdSUFgHWu
         WZBfKmezT6t4nPJk+H8IkuB+xKongEAq4uOhUlKpFZoHUmqoMYO4fT2ggNJDy6fy1dw2
         gZoA==
X-Forwarded-Encrypted: i=1; AJvYcCV1aEekTyENBOPy0D4TSwqSqOC0vpJQBe2H4am8k5CWsXktXlCriXyaDsEfCGVlb7WRA5Px4i010g==@kvack.org
X-Gm-Message-State: AOJu0YxEOW4XiV7uttCpnpOJNpYHYYWx5xVXsusjSM3JA/k8+XlBnUgs
	7lh/HrZ+cY2GWxtQdJJyyTVJaao+yjlGf1+U8NDTye7KvDVxAKg8lhQEnoARtxenfww=
X-Gm-Gg: ASbGncuL6Yeoi80/qCHtetdS5idmorM4oy0u2nHcpImU6ejvQKBvsfdlZ2oJNssyXmo
	uyY9/DyfnWBlTnDJzts2gNybQM+ZKU4UrxVK9cLdEoZf8Cpd1byGeRHS+T7H+0yqHt5s+NaK37N
	8FOCuAqDjKsLIkTCtpfg71i5I8TlGMJs9j7y1hCkJcodZqvD7c56Y6ESy9Uk07LYflOEnwH4scr
	7u3uJI+vSRUKTp3Hf/lEAXrgZ/rpcaOJ/RbvqSiUAC1kG4Y2ofUsfpDAEKU1HK1OO+ch0OB5Zkx
	3Io655B5dI9AfZ+DD9n+7R+Bg93bH6VwOTT3artzJtsWLfONej4u6Ke/XWtuJVQIsaOcyRd7kkD
	sibc6PwkPaob0z9BRvcq6YT+Dr/iGmHS/tpR3ShOeP0DzPTeikWVkOGJ2z1QuFF42dfu+iS9NID
	hhKZlIWdQuTAcWYFd+o74SgZn4fZmGz4ynr3hcAjklQdrsVA==
X-Google-Smtp-Source: AGHT+IFaewYCh7lZ/e3jrLC+zJ6aPttGSWBIKbLkQBuHB0fmqLtXdWY7nE/Y+kB9ksn8kefKsppo3A==
X-Received: by 2002:ad4:5aa7:0:b0:880:5cc1:6923 with SMTP id 6a1803df08f44-880711d8255mr64437896d6.36.1762366610614;
        Wed, 05 Nov 2025 10:16:50 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-880828c457bsm1883826d6.5.2025.11.05.10.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 10:16:50 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vGi3s-00000007CLf-2PE0;
	Wed, 05 Nov 2025 14:16:48 -0400
Date: Wed, 5 Nov 2025 14:16:48 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Gregory Price <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	Leon Romanovsky <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH 02/16] mm: introduce leaf entry type and use to simplify
 leaf entry logic
Message-ID: <20251105181648.GR1204670@ziepe.ca>
References: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
 <2c75a316f1b91a502fad718de9b1bb151aafe717.1762171281.git.lorenzo.stoakes@oracle.com>
 <aQtiUPwhY5brDrna@gourry-fedora-PF4VCD3F>
 <20251105172115.GQ1204670@ziepe.ca>
 <03e363c3-638a-4017-99c2-b6668ca8d25a@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03e363c3-638a-4017-99c2-b6668ca8d25a@lucifer.local>
X-Rspamd-Queue-Id: B5FFB80004
X-Rspamd-Server: rspam07
X-Stat-Signature: 8iftbyn89zegz7yry5f344tmyxj19kf3
X-Rspam-User: 
X-HE-Tag: 1762366611-555632
X-HE-Meta: U2FsdGVkX18ggR+pPQJ0ObYkEPJQM9/2em7WeS8OGxDnAUiZizHQopScfn6WhTmGPvR9QAAuauT3PBVanGXjuUOu/NjGUxz3GPFuf+HZoTFDBqEyQLXGCx3OIRb/22mTc2PWydtFBig1MD2Qvf3NmhyjKw4v0WnPTH/LqSoh6AGdUy5zxvNFnA9LmSQL65fk16KE3O7BpSerRvZCl6KzqTH6PZB+st5OjtsfK0oFkkiZYpjn/h1p1PKhXGuX+dPAN4bo/1CkDXvtyE1Ltc02SCKy3hhAkpKifjVCY2D8Qn9ycWRJZ7gmv0MB3nuEQvtTfn+LA7UylwKIZ6RP6KxEwp8dx5B6M5CxTimbSLUC14oTBqKiIvHNt4A+4DMNxiaYleAcCvhynLysKNlYaVxIGLwX2VZCR0ahx/j2YaOPbg7DwooEIsURBRGUxFoOptXSJuWhLDID6zRRJk55B79hpaxhIaVs3nMv5nSOh/5D/bkEQI399xr9dPDAORC+mKiqpQviBzmfdgSnjHafZ6OHXaTksc5H9YTo05GO6KgEvC/mjELTPtGArH2hxLp3Jw8IKyzi98nfCYPT8SsDkdkXdcdIztujAmXkVAHxQPG5FwCzLZOoF2UGZ7QYjo5lkwXJyevlmTrjavfwzYo0OIaS1vK50Zk972RH4k6ZF/gW/gcKP1bcOtDWaWZxcchIYmPrto9YTr4wX7CVvYRES6HkXVW3v0MJIynda/U2TsDLbLP9L8P2Kmqd6hJx1Clgd3tHrZ8419hir6ba/JjuNjDcF6LR4JBdP5KhwkiSfQ2mFuYt3jQ1IaX3krnV2Ga2mbaUWv5y8kpS32uwJ/m2tt8HbKRU64PybMDtTaxGfpa+3UE+qXVnzFC5n6lif0Tm223O1UtclJDkz11yxxrC81m2YmcrYveknU9vC5xMf60smd02Sksrc5BmEusXqmZFe7VJYEb3p2IMVXcHzS7xVTF
 UHaKHR4k
 4EowCB2xXQv8gD4hHPC291LRZBdWZcUjEtm6j5M7V+4Yg8HHtbVsKF/pvOQjtPlXyhMv5pXLLSE9YhBnM3WAn34p07A9I/HCaqOsPymHEU0pyI0u9FYfCl0ZKPXynh+7vVHz2z6xgpaZnKRUiJCuEBqhHijQySInE8EzKWg0RRXST126pgLjLdK153OCe03k0FaDb4k7Z2KvLVVGUUoUXi5NMPMkMlNsa06bWCnfMXUJy+1ihQGjgXcsMsQb2nIBEwykHCeUUdHCHk9OjfJKoaeYxaoUjmFpEEJISrGml+rk+5YB4SK5tdvqXPGI0xi3X+qgsfb5NSX/zXO3GvG/1t1mqIFgFmJ9aWtde
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 05:32:29PM +0000, Lorenzo Stoakes wrote:

> Obviously heavily influenced by your great feedback, but I really did try to
> build it in a way that tried to simplify as much as possible.

My main remark, and it is not something you should necessarily do
anything about, but pte_none() can be given a consistent name too:

leafent_is_none_pte(pte)

Which is definted to be identical to:

leafent_is_none(leafent_from_pte(pte))

But presumably faster.

Jason

