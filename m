Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09121CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 21:38:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14D388E0002; Wed, 10 Sep 2025 17:38:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FDC48E0001; Wed, 10 Sep 2025 17:38:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F078B8E0002; Wed, 10 Sep 2025 17:38:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEB388E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 17:38:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D0AA1402CE
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 21:38:51 +0000 (UTC)
X-FDA: 83874655662.22.D51061A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7D79840006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 21:38:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ERlNyzA+;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757540329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S4ITsVV/t8NbwT/7z/WdcHjGwXQmr80hXTyJJR6KQFs=;
	b=jUSwU1VpzBNpIeah1g7iJzyq+FkPiGVVFwQkNkUB4rlGrxISX10a6UyR7J8aysbPQxn4sY
	wp4B6+9GIe6Kyoz9X4qKoh6hzfwdrOFEmEnk9rclkRhEa0lnyH5SsPCuSrVQmAcMHUllNO
	ClRw9Kpe9eP3ZiZTWQVfyQ0qChrEFPU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757540329; a=rsa-sha256;
	cv=none;
	b=6YSFcgLCtXd6EGQuwFTzoJy/VfbslSkP4I5qLyCA8fNuyei1NAO+6G6XJPq/wy9gTtequr
	EuPli5ToVrDDQgqitytOTmejlZBVjnQRw2WRweyLkMg+wmzk8HEn3m2Y4oN/pScCC1x4ho
	MV2uO/hp3L8BEtDcqRQmMuGaLm3/55E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ERlNyzA+;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 012C8444CE;
	Wed, 10 Sep 2025 21:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16257C4CEEB;
	Wed, 10 Sep 2025 21:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757540327;
	bh=M0egxu8FbVh7lEFbI9KpqlK3Xem+oaa7R3cdZDtUNQQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ERlNyzA+aJCVNQscjQFOcHN3rHi5u0odDg8HJ53DGP17XEJUpaKk2IgWSZVS/hpeF
	 5p1Ihuc6sdEVaV7cYZYmFtUpA2LlaeGvkTYNkZIfig/XRZmY6YJGSG8lm1Xuk3QIE8
	 jwrcsmPjtEE9QD5hE3bNL3Ol+tJm9HLfh0DU00FI=
Date: Wed, 10 Sep 2025 14:38:45 -0700
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
 kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 00/16] expand mmap_prepare functionality, port more
 users
Message-Id: <20250910143845.7ecfed713e436ed532c93491@linux-foundation.org>
In-Reply-To: <cover.1757534913.git.lorenzo.stoakes@oracle.com>
References: <cover.1757534913.git.lorenzo.stoakes@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7D79840006
X-Stat-Signature: 7hkap1bdq1zgu38tu8x4bp8ysbecofck
X-Rspam-User: 
X-HE-Tag: 1757540329-722406
X-HE-Meta: U2FsdGVkX1+qjnNZV9XT7J86aJ0UDlf/jxpt1cZelyFAW3GDHaUKKo4AZ+sgFfuVtWKm4yLgbsS7179TbHSkV9iCjn6Tq2yyv9PQU1gFfU97pPHdsND6CHwoRg5P80klW7hP84tREa7CoAPvt251jG02bV8a3p0LBXV/1d/at/fjVoZVPGaRbiMnGPjml0bvzdek5iwTGLIyw24Io1BrAybyEsRkBbN4elUgm601eYg9qTlNzib4FaFliwRw7tyhIqo6xEeDL4M7gf4tPpUtqoqAu/7UDsQhkV45P32qyLHAJ69Twj+WdIBTxtlS8yLIvZIc6Hn0zmee4GJ7Cb1DrvBKBFPzTdM4J0QTcgV/Zit2nFdZAya4kkMtc4xWIIFqXnovERt7EKjWJOjQ+OhTbpSgK0LGKldxSFf3oqDH2d+0wy1V3Wd8bui8t4Ljk/n0G3edOqryuD3/7HA4lQaUIcE5Eb2ycgijFHXNCJIghOQFvEeK9jBUv7cJsyh6TaB6tgZrYyrdCBVZR11yzrlyIr8osRVNgFdd3W3PKai6lTTD6UFBzFb3J9C8ymuEbGHe5epBGvjpOv1Dy5jKpyYdjFdJjsZ8DRz4E+0WWcIN/SeMXq3/Ieqs5iuUztHRzUQN+07RbyYLLxpctMnUptzNq0ZmC03kvOWEgyVQ5mSvaAs8lclzOk2mO1SNWugyyJvxSYjFwbwAupnEsOnn1G2KvYb7JSsoHli6TkysrW3RciKYHltLNf4N2K9f0W2/D7QpZPB1MbZ+4/VYLma0EoAgKHKwEoaEIyM8qYMs7v4UYE/vtol4e4FLpBBp87rTdF5dSMLYUEzCnayc3fFPq4Aa9esN89najDPGenlVFmTZJ7yUiW5D7Q2ZifSI6qDSe2j/HgV6f9HmZ2JcswZ8YX148OoiX3l/NXQrqayLgC01iTDwj0a9VevdGRjkkNgOlQnac1C9wp96TQZY3iDyFd0
 rgXGpGHp
 Nn1aEcOKoYwLSvcZAicmzUij8mAoTJBAKCn3wrQdql54Mk02sikzAVgknfDtDxl6yAaIJk1iAP/FnaoA5fPs6FzVZHN8WKjGhwwS4S8YUTc1FzdnOag9Vz3wpYTTlXl2Uu45DZBQ1pjsh+11jL7NOxJGRvmAiGy8HOsSPTZkxd5pg9ahP/JnhKnfT5zf5k4up94/e9P9UEd9Gw3Mk8jCBJqI3ida77ARtXtxR57ur+MYjrfrB586aYQyZkEqiuHHzwtJVY5BYesnAN3PR1vV2zjhZli+BWpOyEh0oVMd5CpXfOyosA8KlQK9aMKtVE6sL25R7mJN75x7sBgMSeC0UIakY+OnmN9rGZ1/ym/Cy6H6UwPQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025 21:21:55 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

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

Cool, I'll add this to mm-new but I'll suppress the usual emails.

