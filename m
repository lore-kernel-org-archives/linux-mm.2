Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0902DCA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 23:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D62E8E0008; Mon,  8 Sep 2025 19:17:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AE178E0007; Mon,  8 Sep 2025 19:17:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F05E68E0008; Mon,  8 Sep 2025 19:17:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E04DC8E0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 19:17:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E2C1B8253
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 23:17:46 +0000 (UTC)
X-FDA: 83867647332.06.1E1888F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id 49F4480003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 23:17:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="o/yhZAT6"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757373464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CMlqYlKj+ILUokIqP1ABAMFD7Ot5oBLbcsJFMFm2zE0=;
	b=hwfPV8vV3EbADKElha6qG0ROWWqUPHnM2DaQnGlwaI75KBJyy4lXwcYxY2uqUZQgJs3w66
	NIgjiwlrd5Bvs5mSP92hvueIF/erpHnC34DYiAzFINcwtvFBgk/nRiR6YkCoMgs7n/wOEs
	fCo452jL1HnJrYo07gTr7Z5Z13O6Zis=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="o/yhZAT6";
	spf=none (imf02.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757373464; a=rsa-sha256;
	cv=none;
	b=mFHE0Mjk3I3OHqded63VaxxxNZ6x2aUF+4Dj9IdQmWmV/5dWFGwQ2i9FzX1oBZV7RUzAL+
	R74yaMQvsRU2vJOlOM48ob0KdjlgA0zug7lxlpfx12nL0fgEn9NlC2QQOZ5SYgPW4XwdwN
	ZjsMIO5kOD4JVuu312FeBlGoPMxd4ow=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=CMlqYlKj+ILUokIqP1ABAMFD7Ot5oBLbcsJFMFm2zE0=; b=o/yhZAT6Pleqpfj3cap4+Ocr0X
	SQndNm93uEb+a4QqInydfI6lMJSJFzsSu3/0qeMTKdhPtlmWw3TUQRbR6L2wKk2W3Fv+UH9KsOJEg
	9qPRFInLAK8DjwwP3kbclODQZmsO+zdGm2eIzKDYqjx3wV8Z9WwBemPbQiE4A+eNMuh7m64z6qIdV
	KXBfJtcalLtNb7nUQOkOJ5v6vc4bBx6ZTya7R+MDIox9Nxyg/2OCB4wbhLPO78J0Opb4io0rwvic4
	NDpaGlW9vP1blgirQfaegykINHE1UsAXggKwlIZNRbsS5mNDQybb9YhDkcTYBLtgKyHdfGed+PEsS
	przXJOJw==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uvl6s-00000002unf-1xHe;
	Mon, 08 Sep 2025 23:17:18 +0000
Message-ID: <c0d7df5f-ac43-4e15-8400-155bf87d5e77@infradead.org>
Date: Mon, 8 Sep 2025 16:17:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/16] doc: update porting, vfs documentation for
 mmap_[complete, abort]
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
 Guo Ren <guoren@kernel.org>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
 Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 kexec@lists.infradead.org, kasan-dev@googlegroups.com,
 Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <1ceb56fec97f891df5070b24344bf2009aca6655.1757329751.git.lorenzo.stoakes@oracle.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <1ceb56fec97f891df5070b24344bf2009aca6655.1757329751.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 49F4480003
X-Stat-Signature: 33dkydx6eogg157tidbf4b43se8sbjee
X-HE-Tag: 1757373464-943304
X-HE-Meta: U2FsdGVkX194wghVx6Y3mFZQJjGuafVAUS9tw6sewglsKVtSAToqsj+/IrcaeuqXYB9U05heM/3KV8jUJGKHlnK/YSR5/DogR3m2YFj/vpB27F2v+75wZ/PpaNHNsXkuy9sRAPmO+7atgLyXjGGTlP3gavMvqSoGhnDcI3UNqVh41iQ4FkHdEtREdX7m6VDmu0gngDWNt0kEtAEWnGDCCz2iNxdai73ol1I8D0oUw1wwTWSoPhdhnV7DOxo7GF+vRlgeZtJJSZGZ76p97HmCNK3sUaMX1Dl/p3Vt/S8l5Xcl8sT7G8gPuV/0/UthqAfSP3aJ08CSQOuzjPiVHQo4dqdZV2XqR8ir3jQL8Wlb3aeaZ4O2WstNs6RzSYjAiiETlpT8rsdyvkBhz7OaJfAAt+UNbo2iwbV11F3YhrAuzxRhrb5tLdUXP+yCJ8u6JrfvGuQeQkQPFtJnM28IUUHs0UEe1ww+ZZEsk81ucLhDzD+OC9kmwFS/F8fM9bKuw0DWE4mcIsovWfHTb8/LHpUhTVNt7ehceCBAdlP9zmqfOkIwbszx2M6meATiiv7S7098jG7ThdpejKVRLKz8dD+elxZagK2X+ZKRVt5m5VMl/hbUn3opEUVOOi59qp/k4pNE3gMt1DloQdrb7NXQLCVrRy2KQCPvKRclWh0yBHXtpTXrGw0YQD5Whg25BYvUrcQfdIJkiCv5rx+H1EFYqnaR59sqjEtc9avR+DRClhyAPknYQPRIs78OdhcgBotqSHYvH2J1zGh8qb/mO+caLzhL+TKCjrcz3fHNJhMzYb/DPgKMMUqwp8wEGqG43vRxT8SHC1LexIVrlqv8Y3my+BrrHnfYmoW9nyb43I19AogGM0gpRw3ytJxMnjUvs2FMoDDansP0Dmcsc52rSmvS26tIE9gcIvomOKQCiVX+TR4Q3YvJVWG393cnG4UVXaVCIFG50G+I0UHr4UXICV6fJxg
 P+LXTJlS
 Id8kBfy2UjzSYfIkR7bx69LaTNPWRGSBIC4u9e7NvTfLw9TizrhxM3zukILvAmONuTwtFNLIOw4KQTNsDi/rDB5lIs9u8XK80dimLTrilFJVelUD0nOTp/y3KhXYaL0SLLR50XkcaRlP7RLBZ+RkStblHIemBiDb4vKozDrhRLDcNOH0G5lELA2uzjFPrMCv+jtoTOJqjbePpFg2HdCknTaoIRCxJdATEHW7h68+GVpRuuUOVysJyxZtKxXKrgE9oBL4i+VCJXm1NETq2qfzB7/DeBlcRkpJ5hXe2uDlm0VmA0Z9ie2VLMUd9AA5/wA1V6OxvonKt9Hgz8LE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi--

On 9/8/25 4:10 AM, Lorenzo Stoakes wrote:
> We have introduced the mmap_complete() and mmap_abort() callbacks, which
> work in conjunction with mmap_prepare(), so describe what they used for.
> 
> We update both the VFS documentation and the porting guide.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  Documentation/filesystems/porting.rst |  9 +++++++
>  Documentation/filesystems/vfs.rst     | 35 +++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+)
> 

> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index 486a91633474..172d36a13e13 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst

> @@ -1236,6 +1240,37 @@ otherwise noted.
>  	file-backed memory mapping, most notably establishing relevant
>  	private state and VMA callbacks.
>  
> +``mmap_complete``
> +	If mmap_prepare is provided, will be invoked after the mapping is fully

s/mmap_prepare/mmap_complete/ ??

> +	established, with the mmap and VMA write locks held.
> +
> +	It is useful for prepopulating VMAs before they may be accessed by
> +	users.
> +
> +	The hook MUST NOT release either the VMA or mmap write locks. This is

You could also do **bold** above:

	The hook **MUST NOT** release ...


> +	asserted by the mmap logic.
> +
> +	If an error is returned by the hook, the VMA is unmapped and the
> +	mmap() operation fails with that error.
> +
> +	It is not valid to specify this hook if mmap_prepare is not also
> +	specified, doing so will result in an error upon mapping.

-- 
~Randy


