Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D029CEE342
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 17:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4D536B009D; Tue, 18 Nov 2025 12:33:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFD666B009E; Tue, 18 Nov 2025 12:33:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEC746B009F; Tue, 18 Nov 2025 12:33:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 991716B009D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:33:55 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3FDA5138AF6
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:33:55 +0000 (UTC)
X-FDA: 84124425630.07.D5BD169
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 810F940014
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:33:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fxn7giCz;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763487233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=usC0flk7GgYgbibr5mJLj+o6TFk3qPlgDE/q/BlwQuM=;
	b=wnUK+R7J89e+umsA3w/+PdGQGeez1pc7tuk3pmLeTIXbAkUmIp3+svtzLntSzvzoXfqoTh
	EUWDyoXSiZOn/8rayUky4Z2OXlqB1JcC84lW3oMsaXAuHPxoLF5GACyaumIbbMq2GNlVWA
	Z6kSiMUJ0aw3JhvFYh0KU9ybHbre1Sk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763487233; a=rsa-sha256;
	cv=none;
	b=zMFa7eIGV/elMpwoTqMXD7mxpuT31ZjI6UFMHA2GAy9WWDVISmHEx/o5SoiFAv8n9nfQsv
	xZyVpBES7ZEwqw8VUwXa+XoY4fnPdh/5Q/rRkhALU4Q5juOIVf983EiGTHD6h5chokv43J
	anDZOrs7eGIpiHesgoSzX85Mu3/8ms4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fxn7giCz;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D6DB408E3;
	Tue, 18 Nov 2025 17:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62976C4AF12;
	Tue, 18 Nov 2025 17:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763487231;
	bh=lMCMay4OPV+EPmMwOUTyyXs4Bv2SJ+rfqLlyshkGMVk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fxn7giCzujVYHabc0Viil4nTOhRJkJImVxhMvBoYAZm8UMdE8WkL0IEmq48z8t4q/
	 2L2usb0jNNPAQ+9QHlFn7d61iFAcqDEi0YpMl75gJrIP88ywm+ohXHafRwoO1KPuzV
	 5JyBNmd4VcM+XKpcGhTJV6aTZoOgXDRyNa8YOa2A=
Date: Tue, 18 Nov 2025 09:33:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrei
 Vagin <avagin@gmail.com>
Subject: Re: [PATCH v4 0/9] introduce VM_MAYBE_GUARD and make it sticky
Message-Id: <20251118093348.9dac5d7142dc6df182833612@linux-foundation.org>
In-Reply-To: <cover.1763460113.git.lorenzo.stoakes@oracle.com>
References: <cover.1763460113.git.lorenzo.stoakes@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o6che8ayt31j6gygjgcw88trmeynmubc
X-Rspam-User: 
X-Rspamd-Queue-Id: 810F940014
X-Rspamd-Server: rspam10
X-HE-Tag: 1763487233-336435
X-HE-Meta: U2FsdGVkX18LSu8yWYXVrB3Rau34HUBwEv86YKK8y5j7vnFt272Zv3yEi6orubC0om+GlyPbsYmcNAmRfTwIkd3MN6NoVc/he4V6Nizcn8nGypJGflPFiZNsuz8rkpYBEXIcO8cDfe9koiDvXs4uilP9bq0Byw9PhNDFZVK/ogygzJTHt8xYmleH73SdTGxOCrZYT10Dd6q8Cdrn9SU/gs7MT+iLiAI5S1NyKUtDdGSJtMAd2QaD2AZISqPfXeFNpP40PUYVW2oel5WwPMm4Qglgx8XS8qqef+3QpqFDlRy7GHTj3UvtmwOoH5dmBGZNc/YF2jbLRcTrjQ4I3XeoLme/R2bL9iknPZi8hNt5xGTpmEPT1LrYGdpX8UUxC/8c5um6eTp77bENPTZhNKKM3Ad3OX/CsGxMJhEG35XyExQV6fnUlJlZE1usbO7nrXG7iWyB9f1CclzpogYv8dJr+UlxySDcS922N8SU9UZRFSKqjUOpg5i9fJTb5btvbdIvvWht/mecKrtrxsl1Y0hysS2UHkMNBuKSzpCqyaEGV8CU5DFxEBWHX5tlqqAjNBtP0Hmr/IKSUT0T+TAY8q+AlTrAb7nUjmPE7xzPj1LSuQuM4UYWaARtJfDFvdfkcEbyZhs1uHqsBncBa8AVbuNysxS61sPehRZbNjzN4ahKR4hb1wio/UamqTy28/cpW56qaZaqyXM7UKKyafR+mr7fxRWHX7/1LR8F9U4zGSkOSQ2L6qyCHsKx0T6+9nxpfPOM6wFXankKp/xMUr83TixZjrsUOyS8yAVTZqTDzoXNJca7lHo16beX8YNkHYodjkhbYP+a/XNkO75aJQoYcaHs2aVFdPx9bqQxhZl3qm1s/TmwugoHI7Raa9a8ge2gyaQ+cseL26SxIV4+LJadePHUtSRg9Do+u40UCcP/sy+m1aI7BFHLpAxqsZr5un+DnkAgWU1lCFTFmFWQFZT45ol
 a8PNdl44
 fF8nBV1tYrp2uDVOYKDeljlAUg4DHYMBUgHbhQ5PkXfpG3StUdZlT7LX8WCHsSm3FLhkG5dzLBE8cjfVCbP3DoUInBeQAoMfEO+D6Rj4my7yc/zhvqNff63MfWHCNohHoPxK9eRs2zv0lxXGrZdGWt0U0KN+U4yIpAYYJPDEvoJknoHHD9MzuAlNK5aEAleX1bC/ImKex4zfjUVOIx9is8xXPwTzIg7AenOiP/vVVD3hH8Sc0qktGntMlXgvzuipxKv59B2+oHO41vi2vUwfwfrlX66tlpEfPYdY6M45BnwixKjgwZOq2rqT9ZOaSKb2GAj/6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Nov 2025 10:17:42 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Currently, guard regions are not visible to users except through
> /proc/$pid/pagemap, with no explicit visibility at the VMA level.
> 
> This makes the feature less useful, as it isn't entirely apparent which
> VMAs may have these entries present, especially when performing actions
> which walk through memory regions such as those performed by CRIU.
> 
> This series addresses this issue by introducing the VM_MAYBE_GUARD flag
> which fulfils this role, updating the smaps logic to display an entry for
> these.

I updated mm-unstable to this version.

