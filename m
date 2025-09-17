Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C70CDCAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 01:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C86B8E000C; Tue, 16 Sep 2025 21:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178F48E0001; Tue, 16 Sep 2025 21:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0684B8E000C; Tue, 16 Sep 2025 21:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6DEE8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:32:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C686117580
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:32:58 +0000 (UTC)
X-FDA: 83897018436.29.7A56FB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E0F822000B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:32:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Cz58pDdz;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758072777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PvexwmzCNrp51tkFXBAFmsX6wCYeaz9zSCCiWiVuAwY=;
	b=rSRJG0fWDdyndmd78qImrrgJ7wHQi+u7MWmodv48UaftqbdA74JM7KOwZD55MhW2KKqbgN
	TVVvFFx3o2PbvJtNofFeTd++1Vb4N/X+jv4h7QFCHQb5u3FWRg89oAJzoM0pkdnHSpREMJ
	CYSLfTSajQGs/tA5UQm7xvTYobZtYP8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758072777; a=rsa-sha256;
	cv=none;
	b=LNPDYFMRUPx7JwxRKtI/YB3IsQNSgvEGjn3CvI9J//LR6ycIu7o+4V2SFXi+ZgMKvKhn5T
	/oYilq+QQtF6wy0wZHG/HwJXfvHyH3WfQaspNnSCszlhwEAlsWPHy8xbAvjX8ZkYM3yn1W
	S3uyW2MBVAMhUfbPUGoM0gtPWUtAcP4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Cz58pDdz;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 839A343C6A;
	Wed, 17 Sep 2025 01:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CFFC4CEEB;
	Wed, 17 Sep 2025 01:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758072775;
	bh=VPxe/khPNBojBygLvAaLupb67EgQP1yBXlhF6g/LkIY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Cz58pDdzIZYmmzo1HFNNAI/yk1M/cOWjkyECmslTAF0/3PdlsvOf6t+VaaqFMj723
	 j+22m+BYb06quci5edCqkXAKoOvCNtTOG6bD3BJs854pxcHjlvyZO20jrNXGZ75yS8
	 WpG/k+1TgXypKIZ6/Ilu+GD9PEv4t2pV2hIAiytM=
Date: Tue, 16 Sep 2025 18:32:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
 Matthew Wilcox <willy@infradead.org>, Guo Ren <guoren@kernel.org>, Thomas
 Bogendoerfer <tsbogend@alpha.franken.de>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>,
 "David S . Miller" <davem@davemloft.net>, Andreas Larsson
 <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Baoquan He
 <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, Dave Young
 <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, James Morse
 <james.morse@arm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov
 <andreyknvl@gmail.com>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-csky@vger.kernel.org, linux-mips@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-mm@kvack.org,
 ntfs3@lists.linux.dev, kexec@lists.infradead.org,
 kasan-dev@googlegroups.com, iommu@lists.linux.dev, Kevin Tian
 <kevin.tian@intel.com>, Will Deacon <will@kernel.org>, Robin Murphy
 <robin.murphy@arm.com>
Subject: Re: [PATCH v3 13/13] iommufd: update to use mmap_prepare
Message-Id: <20250916183253.a966ce2ed67493b5bca85c59@linux-foundation.org>
In-Reply-To: <a2674243-86a2-435e-9add-3038c295e0c7@lucifer.local>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
	<59b8cf515e810e1f0e2a91d51fc3e82b01958644.1758031792.git.lorenzo.stoakes@oracle.com>
	<20250916154048.GG1086830@nvidia.com>
	<a2674243-86a2-435e-9add-3038c295e0c7@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E0F822000B
X-Stat-Signature: fzbug7ce19rgtz4poyc1rfu5bwzd5y4o
X-Rspam-User: 
X-HE-Tag: 1758072776-623738
X-HE-Meta: U2FsdGVkX19ZTWke15qPwM8s8fe0hHay8PznpqpTr1QhbOHL0XFHbg3KLjnfgatxalHNQO+L6PgVSwTVv6Rr7GWsv1xbTvoq21wfVKEpJDqnuH+ltYK5dwsQIpIUqL1iPfcZpms7HdQIf6xpryE6DdxxSd6oSoxDV6C9tR9yOUqhLpSw1JPF+5T2r1XadAmdugqcRkUGtQB0pSWVQ6vLWxNBjR8SIm8+KWslY1XpUWOevml0EgbBd5TJ104+DuMAK3CqIVzuFvD5ULfVjPeaOt/h457lbmKSwRKYM41lsfdON6VzxgzSNEEvEvfK3MtlFQZF3l/CW1MFC9o26PzblSbwACO40sqLR9l1/DGUH8Eg0a894OdLBgBto+DIoiVE+QHfzJNtVHCIj5i5I/lotyktYqt/G1unRMoj85HkOk+aHtzL1HhwrYExmkuTuK78M+xZbz1Q593TonHl84ivK5TElcf74Q0O6p5MHUoI0NWJbHCbwFeg21stZ17Knd4DG9dVgTQS7exxH0IHv1Raz6J0um/85EAUlV/TG7cPvhqBNjHxMd10jfMm7ybVjgc8pfHoeFYiSC03Q2vIh0nSFBffpyr/MLDb3JPAmoCWCBQfYAM5tncSlJ2uHIXP1h+Si5PAvCohchoBBjT9Ha9KojVt4v6PTuVPgt+nVVdRquIUERePHbw6czYFhQkCNZAwBix6gnRthkrJSFm5h50MtDL5NtHh6i2L1aOIvpi4PJWT1lDtWGWk6p7cfZkp+nKsigAMgiCEcF6FjmgbRAWLby4ulGaLWz0FRJw4976gdnug/sIUN0iIxmE2Fw6dgCyH8SpdedyRNjpSfFrNwmS9hGzuqYqjCF3qo7JfLpn4Mo1TZRziVFkPYKRyJlcWxCnaawe29BYdFiuAWSSF/mQfp7G9bbAKJaVATZ4gf261cmzVECJPoG+1xWxxvhPz+sUwcgvwL60K3wa+Oz50aGW
 oG1RPwBl
 EIvUo+bZ9pQedy3lVqFV1Dluz3vu1i8NB3CwAXN4HnK2ZeOumimNWmNfdws4jbq59FuemdaUD1s20STbeQYUd6QD+kC12vNx2eolkWyJl/xN0D2CLV4/U2DcEjkJim04NlgWdQOYGOeWNcoWMUN5Damd6HQV9WVBKKxiDROI5oZvfysSh/1Nth9FKFdiK9g+9eZ08ZaC7ah/tqrN3oKjT+wzlpc+tF0EfwRDafswzo3bxhDE0QLWd7JHUI2tA1ZpKJDhk1Xv6z1V2KqsZWUO+OSb7hKccn1jOHvQNq9vevu7Ta1ApRze3hXV/5ZzMFDW28e/7aq7aUnRj+Wjktm792Z117UdwYWEJQOlsFWEyOOm9tiE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Sep 2025 17:23:31 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Andrew - Jason has sent a conflicting patch against this file so it's not
> reasonable to include it in this series any more, please drop it.

No probs.

All added to mm-new, thanks.  emails suppressed due to mercy.

