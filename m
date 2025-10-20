Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE823CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 18:16:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2D318E0010; Mon, 20 Oct 2025 14:16:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE1B8E0002; Mon, 20 Oct 2025 14:16:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCD288E0010; Mon, 20 Oct 2025 14:16:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAED48E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:16:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F3CF86230
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:16:14 +0000 (UTC)
X-FDA: 84019297068.07.26AF82B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id BD191180007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:16:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SFAdAhGZ;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760984172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Ajt0HVVq8ZKPdL86X9rKEhtCiIfSqXtFposI8V9XtI=;
	b=kazsYN4G0GJlZXPfhg3P9n5tZT7wI4bHKCpKxHjo5/EwMBjhVyZeyS5jnIenHOh60wUJN3
	G5y85pdCNQ01kS9rniK1v3d4KtF5uXCjVSOV4yrujevJM1pUYuZ8TQzDUILG8cTPUSPqUq
	+RRxEPPtCyIrZ4ICpqWJ2KwzTlcM1Sc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SFAdAhGZ;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760984172; a=rsa-sha256;
	cv=none;
	b=M4cj7Hj9Bpjlpf/7gqzDVpVwcosJQVxcoFNySNBjgBPLUj8HCGUcP+BeWt3Zv1DHVrgBG6
	sFllyJlMiaZjU7tcGmD/SDQIdEb+tFZXPqUCfhyfI1svWWVl988+lg9lXaWBhj97CQw35w
	GKmz8eFXB+tZ33h0nu5kCXuWtBz61QA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E790A620DF;
	Mon, 20 Oct 2025 18:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C732AC4CEF9;
	Mon, 20 Oct 2025 18:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760984171;
	bh=g+2VpaD+FlA761mradaWnF6yVcLyinIaa0PWYsivwMA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SFAdAhGZ6XAI3/OSlRoUNUAwPSszkFJ5X78HTOFq1+uod1XbAgAQik0Ms/FVZwL8b
	 s288oOWO3uGPngOYPSt2YpIWz3iBNwzxaqaJwbvYDnbDsjcDdrwTO7g030gpdL1GAy
	 kdB06SO/8MeAHhERgECXjIJ5lY1Qda/IfEWb/rTg=
Date: Mon, 20 Oct 2025 11:16:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
 Guo Ren <guoren@kernel.org>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, "David S . Miller" <davem@davemloft.net>, Andreas
 Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams
 <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Nicolas Pitre <nico@fluxnic.net>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@redhat.com>, Konstantin Komarov
 <almaz.alexandrovich@paragon-software.com>, Baoquan He <bhe@redhat.com>,
 Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>, Tony Luck
 <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, Dave
 Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan
 Kara <jack@suse.cz>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh
 Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Uladzislau Rezki <urezki@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-csky@vger.kernel.org, linux-mips@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-mm@kvack.org,
 ntfs3@lists.linux.dev, kexec@lists.infradead.org,
 kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>,
 iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, Will Deacon
 <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Sumanth Korikkar
 <sumanthk@linux.ibm.com>
Subject: Re: [PATCH v5 00/15] expand mmap_prepare functionality, port more
 users
Message-Id: <20251020111609.cfafaa22c20ac33be573898f@linux-foundation.org>
In-Reply-To: <cover.1760959441.git.lorenzo.stoakes@oracle.com>
References: <cover.1760959441.git.lorenzo.stoakes@oracle.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: okqzhciewnzaybkaywui1xrokrke9i8x
X-Rspamd-Queue-Id: BD191180007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760984172-848575
X-HE-Meta: U2FsdGVkX1+9pFtJTVhWqqAqgdC4rNBU1OShctFK6ciM1xH3H4I8kLhCioaigUQYjBXfOsQp9T/P/8gdY1VGx/tnFl7RrexxWKVMNmggx5j0MYCoeVzg33rzqFePYiDq1zWSnuTmpJT4DWl/tode4i8P+aeI+3omx1vn92EYvoXrv4pDzWxowhJ2nQ1PJtoY34EUWoZaOXiXLl8mRRoSkYKRuOkAKmm8f6RuSVjpeZjA2nMCLSf2BKralflMZLO6hKFWPgRWPFiSv3RYiTHSlF/ggMV8Wfs4e5udFS8AwD9aJFQ4SIK7ymnqU27FpA6Pq3APax4/aAlH55NYwFKdeLc52tFZRCZDNBTmwK7TxiQf8cLyxO+cFDzSoV7EjKp+lCRt5zXRkj1/ONx1GynYJmbQpLl+fNc8zqj9Ns4uwEiZUwee/Sh0R3yUi8G25GYQhbFFnJ4sa6U5Fa/53nOn6+SMAUQjfF9enUrgz6+I9MGU5ykb645VDtcJim9XTJkOaMJqXaZPepJVCGuup9cB8Pgzi7ZktqPTREOGcfnLcFjiIGKi671cXRnItTvqqBsWNQSQRLNWO/J+toMFQeLx5Wll2TjKlD4bv/zv2MQ0tgsiz8dvhwwfUqioqhPq6X28IKo5f2CjFqqhio70QTomaPA9WGCeT/qZwd9jVRi0YUQ6AzjFI0g4jpNj03FxmfsoGyotu5iZQOWDDhVn+xEhRrq7d/RFGweWQAYA1DN5yoJdmPSJ0bbb9F4GwjRUiItuKnTNX5QaAN10ZNbb1isn7bh3Hcfq1vb2LC99JO442ra39/493Xo4j/sQ2pvNYp1lTT49atmEOfQhJqL2cx9cLSldck77/TpWeMw8WKjnpamobTfSI7dU4Or1q+aXN/scEdsrsTcRjRDinJX7VwEkERI5K2RskT0uhuJ6BrVDYrOl9dXzabLmv5Xguf4o5spB5Xk9HOK83vMdLvdC2ZY
 gXLHbmh/
 DhKVrX3OaYbuu0ApP5/WT0eXHxi4WZ1/v/NvjlgitBLMQXwIdIFK+fW0c+HPc/YGVzQ7RxTbtom0hIkZPCF3WIq6PQDnkVUZ7rIMlIRfj8OJmQA7XmEaHTzoq0Fmjfu1YoAxQjecBZfwo+bAnvXuRA8oPaCl/QsTspGphpryX5iklcBGrSEs9GWSbTswDl54o1ngMBhcvMPzuydNTZQhLXeyyE062u+NC6MjIcdMxMUYjmhR8sYqn8qKyc8wo6BYvinqf21cmNcfwBwgvOYAWuGi2sQjvq5RGTJuGB458GsP2eMcUF9zxcSFJjKhIWJN4UrpUf4E8eS3iniUL+1/xUQomY9LEbLQHnVZBQizHSgWxxS8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Oct 2025 13:11:17 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Since commit c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file
> callback"), The f_op->mmap hook has been deprecated in favour of
> f_op->mmap_prepare.
> 
> This was introduced in order to make it possible for us to eventually
> eliminate the f_op->mmap hook which is highly problematic as it allows
> drivers and filesystems raw access to a VMA which is not yet correctly
> initialised.
> 
> This hook also introduced complexity for the memory mapping operation, as
> we must correctly unwind what we do should an error arises.
> 
> Overall this interface being so open has caused significant problems for
> us, including security issues, it is important for us to simply eliminate
> this as a source of problems.
> 
> Therefore this series continues what was established by extending the
> functionality further to permit more drivers and filesystems to use
> mmap_prepare.

Thanks, I (re-)added this series to mm.git.  I suppressed the usual
emails.

