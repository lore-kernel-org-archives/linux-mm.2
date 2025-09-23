Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 479C4CAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 21:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F23C8E0005; Tue, 23 Sep 2025 17:17:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CA6D8E0001; Tue, 23 Sep 2025 17:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0178E0005; Tue, 23 Sep 2025 17:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2ADFC8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:17:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB7D4C01A7
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 21:17:10 +0000 (UTC)
X-FDA: 83921775420.18.AEB05D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id DB99D180003
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 21:17:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YQt4yJD4;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758662229; a=rsa-sha256;
	cv=none;
	b=OUkUGClFQnnufoQI6MiCqVrLkqVwb3LNDJnYsmnkrtkN7wpdntbBRZiMcfktF74GqxucRN
	TN9a/4ZcgUXXW+4RlqR3l2upFRfT5ahqLlnmmDw9OMinG4n0bIi+nfWARA7a+mDp/h3gU5
	lfHIWx8A3Wn/c/NGj8NHQhbx3YwrpZo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YQt4yJD4;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758662229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yje1Tz9SaEGw6dlz8jsIVamZUDeUt5rPgw2qC2XPSGI=;
	b=ZYrhWT66MRYP0rj8f9XvCoAib9jWVr5dPKPAqnfgMPyV4K66GoawlHHJI76dJMoK03go1Z
	5sKIbYSG5Ubd7tWTqriQDStplaKnUjntU4hpbec/XVMmCQDSnZlHq3WJkJtNU0rlzKXNJB
	0U36jeNNzieBakrb1ZcC5OH/WZLcxbc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 61BEB42B86;
	Tue, 23 Sep 2025 21:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CB1C4CEF5;
	Tue, 23 Sep 2025 21:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758662227;
	bh=9maMwx7/tfxHiKFTD825WGlX9Scv4cfcxvOcT74ZDTg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YQt4yJD4LLyMB/AA7fhRdzHKMMyKrYX7tPYO7bcgLcaYZEMTEEDS+V/u87paR8mvk
	 vaZ6Hf5HJhiz4iN6UcpLvuzXo0K/kulYjPZuGmcFLhgj45aLOuctbBJIR6+SoLAoCq
	 q1aNHSIO3K1aKeAi1QD+S0yrDrsK77/N3Jf/bOOk=
Date: Tue, 23 Sep 2025 14:17:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jonathan Corbet
 <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, Guo Ren
 <guoren@kernel.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Heiko
 Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander
 Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger
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
 kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>,
 iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, Will Deacon
 <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v4 11/14] mm/hugetlbfs: update hugetlbfs to use
 mmap_prepare
Message-Id: <20250923141704.90fba5bdf8c790e0496e6ac1@linux-foundation.org>
In-Reply-To: <aNKJ6b7kmT_u0A4c@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
References: <cover.1758135681.git.lorenzo.stoakes@oracle.com>
	<e5532a0aff1991a1b5435dcb358b7d35abc80f3b.1758135681.git.lorenzo.stoakes@oracle.com>
	<aNKJ6b7kmT_u0A4c@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DB99D180003
X-Stat-Signature: ekqrsjk6jyz4d7a9cyfk7q53jzo1jg5c
X-Rspam-User: 
X-HE-Tag: 1758662228-925233
X-HE-Meta: U2FsdGVkX1+4JCLPqjIa+2LRogvn4AadFhq54ITiTAYvAp74bfDYW6LbL1/nFO28t2jMdlb28R1TSx/+4hA74gf38DLx28/4JYSsAHhna0dmYszVa9gryZnaLgcgLcObimBqQ3O4a0J3Tl+DIxoht3QHyECOsN7Bpd2ceYIByWjNKOv0osANN5gQDFt7bqD6/H78jkLeMWYA8+GbIL1EhYjWP++r8SonMlkCstCdvYsIzbEGh/ETtWezEC7if/ZghdcRab3wPEltVbaM+8k0/X3GSRR5UyE5EtUJsJF97oCG4JFcT/t7ksncNR6/4uduXf7Bi3J+L7XYm3dwrW6cT7MfqpxMgvju62NH3fGgAJgp++b04U+xQebnXbivaMJD4BXGuTZ6N7FutkobuIe0qvDe+9lTq79aaA7LJD+9ggruJmGTTCSNbVbTPI6J4umjzQ31UtX4iGtSidqpLFvjMq0oDC1BTPfWKFeLdHEXl2rE4zBe6wHgrJ5jyY71nN/7EwIcNF8R77YdtVb083+xfdu2NCjExjUY7Ls/1MZwDXRAU+T5w8iPiZO/3158UQobMi8v3WlT9ZfLQ5FrS9MspatRwJw+bt2T3r5sRhqkL0eYdHpKl5ftFWNmBEVpahhSjBjkY4VGWw3WiPoi+4oxhfTgd+mWIIAZ9Mnl5WnHvWhOl1yPZzrQgfOG2GK7EmPf4MjWYDxUdk+uIOzRREecqqYFGsbErGDmvzuwjQz1f6CXtYbiGd9V+OjWPl2QdEdorYdetmySCyjdfjJnd5LJjzWek1zprwxdD0w7D7Catop1xGUXjWUkT8LMd1esz2dM0Xmh2WcyB0HSG+clpUmiBk21IlgepNG2Q9Zq/yi3ROJGG1vnEIYaUMr2e1DUYoJtrtTH2GkLxW50LdWeeoZsvmPYRhgg8HC62SCyB+BMoBMs3UqR5qzyU05FmIcIpJrZ2Y5cQlJA2QHdUj2QKUV
 ZcrUoA+o
 Y9Zp5u2ZZzG+c0HRcgTbcMk1gj3gfKGRkycug+PXepckepmhW8wk53PmxOunbA35xD9TrlnboRa2R9kZdQs91dJZ6pDh/QD0CjRuzS3O6gCOZWkVpguAbPN4m9TcozZsO+e8IWdThVJdUo+xQPFqeWItomGhd8gTSscOIDgpt9/ZwrOqFpzSXjSw5Ta2LodbqOsWbCog8p6MNx99KqNXx/gXOeniLqUmHuDGe/1Lng1rPLt7W6/A4RSdHKkm2Et/wi/0Cq/kl0oGwwyxOqraOgxkMSyeoFjTFalS3KE6w2iTTA5h0Gas+AS1VizYFeLXQj+klGJTEcHl1XxCmzjXLiXd0iYdZMcF8hHGT4eW8iNt8MvlZfFDOKUeaSdfHdaYl9liX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Sep 2025 13:52:09 +0200 Sumanth Korikkar <sumanthk@linux.ibm.com> wrote:

> > --- a/fs/hugetlbfs/inode.c
> > +++ b/fs/hugetlbfs/inode.c
> > @@ -96,8 +96,15 @@ static const struct fs_parameter_spec hugetlb_fs_parameters[] = {
> >  #define PGOFF_LOFFT_MAX \
> >  	(((1UL << (PAGE_SHIFT + 1)) - 1) <<  (BITS_PER_LONG - (PAGE_SHIFT + 1)))
> >  
> > -static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
> > +static int hugetlb_file_mmap_prepare_success(const struct vm_area_struct *vma)
> >  {
> > +	/* Unfortunate we have to reassign vma->vm_private_data. */
> > +	return hugetlb_vma_lock_alloc((struct vm_area_struct *)vma);
> > +}
> 
> Hi Lorenzo,
> 
> The following tests causes the kernel to enter a blocked state,
> suggesting an issue related to locking order. I was able to reproduce
> this behavior in certain test runs.

Thanks.  I pulled this series out of mm.git's mm-stable branch, put it
back into mm-unstable.

