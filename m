Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C73FCD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 08:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 189AB6B0088; Thu, 21 May 2026 04:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13A776B008A; Thu, 21 May 2026 04:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 050B96B008C; Thu, 21 May 2026 04:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB7346B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:40:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 61977A049A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:40:17 +0000 (UTC)
X-FDA: 84790780074.27.8C3B531
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf27.hostedemail.com (Postfix) with ESMTP id A927040003
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:40:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="I0/Fo/D6";
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779352815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4k19jfrGZognz9ylmmH1ahmwrZE9nXMy8Z2zTJ2/qk=;
	b=JdnFVxvZ6r34YlL/TQ+67bccw5qHsefYTOsIXPc6DYtWyUUodK3up/+uKTNn/GHQ6fVpPy
	UnJA7bZNgz+Ny+D0NCls3SwDgSV/FxU9p269xrQpIu/ru5JCeXEid+vb5asF7ND8ZkVGj7
	Nv2EUNvKQBoWHucj3cCbgbhMZgmvsuw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="I0/Fo/D6";
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779352815; a=rsa-sha256;
	cv=none;
	b=F2c0E9N8121CPV1vU+4ViF563DiKGAlY6g7ODxPaf8qFIDZVo7iqxxKO3GdfXURyllzEj4
	64clO73qtVprr4hsP8n4GmaQkHjBTuBEGKuKuormZd+27CEZ2Y4h8+jk+L6Ju5I8lkiAo3
	RdEhiAxe0FnImMpVVOCKzqFlO7wbEDU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779352813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E4k19jfrGZognz9ylmmH1ahmwrZE9nXMy8Z2zTJ2/qk=;
	b=I0/Fo/D6//GbWeFmyAxHEQejv6UqxNMM8i7TkpHyaSI9zoZcVjqtoUQJPFhUfu3nEYOP0V
	zr3OmOhOtORbSm2LamS6JBJ20lMiTgfL/wTSv1FNzblIQYdQf2s6waidmpIDqHZvB/ies0
	V3l/d4fkK8ZMWZulCQedS9XqNROMfZs=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: davem@davemloft.net,
	andreas@gaisler.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 7/8] s390/mm: use free_reserved_page() in vmem_free_pages()
Date: Thu, 21 May 2026 16:39:35 +0800
Message-Id: <20260521083935.28252-1-lance.yang@linux.dev>
In-Reply-To: <20260511-bootmem_info_prep-v1-7-3fb0be6fc688@kernel.org>
References: <20260511-bootmem_info_prep-v1-7-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A927040003
X-Rspam-User: 
X-Stat-Signature: ebcsdgr6rajixe5mg4t91t3nuxxci1up
X-HE-Tag: 1779352815-185739
X-HE-Meta: U2FsdGVkX1/kNiRgxbGzMb++AFdnvNINa+Lht6wUirc0MsWOnm557Df5vnIWynJL8Xn53PrNEwP7bKn4MMT0iVVyBknxiJmJAk/fMgVJ3NDhhFahynalukV01U71ehfPtSM1NADRGTlW0uoAiu8PWr9bOcdzM6U9v21UEi9qv70In+HDOu5EZQWieQugf6mAP3YUGK1O32Y46b0vKOe1FpQncszFWxX1ydc8eemf+IqYSkcvAsjv/r+IIli0hwk6GWX8hWP/3W7TUQYv8vOlZzZ+d3leOuedgjMJOggC0v0tBN4ZHfqnweRLS+dhOJJOXPtBdCovommCkbk3EA7YNkTAxUy3ArSlkyJZ48YlWVaw+9fOT0RsP6RakC51iOSlPp+Y7wATQwbxX5EPxG0l8MS6zun1PaQg4uetARNDR2oArHbTk7+pIYspk2BaZhCkbJ/3VcvKIaym3fExQt6n8EtdHXjrddTYnXM1sgv+I6rlxiNRjcho4kMTa4IEkkdNX7QpPTCXND4NCJAAj3AG3Y8errLqe6jwImmBM+/W9IMTfUb9dyssB5smNHbqdVG07eMOA5QmwWmukCQVS4YLqiT8U18h0LokyihgtlaIUoQkHVtX5GalkdgItx8xHwuUYmOn7VAzlYq3e3X6Y/Zz+vhnB2fM4Auqc+vF8NIRRzhVBVMQCn4s+ffKvIArOkH2lkYRaAvkIlVeb+8UTLFHXApNqq+XFW+Cj1WEX+3XzcNs7JJg4P2aCLVAMAj806Sx9wQpHoeYqP2GT35K63vWxCAn1q+lU+AcTc0CS146eJYt3x7xXzGgh4RmGq0WWBIdYANdCbe5ul0noNKBi7YURam867xuV2i7ebyP9sx9xlipacqV5K2DlBgSaz39XGFkTQz8QJ2MRut/ZfHaRh3NSdcMYyCIV9YTtPqbeP5pK/JKNR7PyZlBe3JbodOpDdWFpvjAbjE95ZxxnQ+uiAs
 WvQ7fHqS
 DCyyQpcbUCC/o2G1LcM0LEyPaLxMKITcbdnqAN9XCr9yCgSi+KLS1sjeisbCBEZ4J6Lqfs/3ziPXf8HiV1hcMIyEzptqdzkISH7QlJPSLA+ZPPZFuZZ8C1JkFL+8s2MFlkIUbWkid5DheFEiDdz14S5oYssH030z880MDxpHxLCg2r/0H6k5NiIOAaioqPf/Wc/WlS1nRgs1GtbqRRO5O7vMfpdq56qGQkEifOh6IAAsT8+6j/8NKALoW50vFVquu7LxKgM7vOTljUmFDDDPqie2sag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, May 11, 2026 at 04:05:35PM +0200, David Hildenbrand (Arm) wrote:
>We never select CONFIG_HAVE_BOOTMEM_INFO_NODE on s390. Therefore,
>free_bootmem_page() nowadays always translates to free_reserved_page().

Yeah. After patch #04 there is no kmemleak handling left in
free_bootmem_page(), and on s390 it is just a wrapper around
free_reserved_page() :)

>Let's use free_reserved_page() to replace the free_bootmem_page() loop.
>We can stop including bootmem_info.h.
>
>Likely, vmemmap freeing code could be factored out into the core in the
>future.
>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Nice cleanup, feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

