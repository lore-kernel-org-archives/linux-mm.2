Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28FD7CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 01:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 642786B0005; Tue, 12 May 2026 21:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F37D6B008A; Tue, 12 May 2026 21:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50A496B008C; Tue, 12 May 2026 21:24:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3DD386B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:24:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE2D81405BE
	for <linux-mm@kvack.org>; Wed, 13 May 2026 01:24:37 +0000 (UTC)
X-FDA: 84760651794.26.79E595B
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id ECDA6180004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 01:24:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MmLYRPKS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778635476; a=rsa-sha256;
	cv=none;
	b=K0XsmkIjVw4mB2x0hoIe8fJXqv7jhuWF/MMIZgYL8HJVEN1JX3qCDZYisTZqj0jLfYimau
	z9s0D/lrsGDBuwbs+JAHkVtbHjQhENXmTfS8SuLvrQwcdmg5+fVRlExJWZ0uPJax016qQC
	GwuB3n0X3xOmXSqC88GHVzjdzAfYAfI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MmLYRPKS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778635476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V//WEgvYvOtQzork1SgoHWYWyLIW2uok/IJueBniAeU=;
	b=ACdrhtx2aOBULQuJ6u5p31EjFgTlvKbArn7d0Pu6AxIpgXq1AAX/aReNR5XeItBwIw1gfG
	gvBlc6/xFe04VMigpqgOljqVeFDv6PEol7i3ITnlnbNQZY+zvmwtEFUTqNj8vtwlTzV/gB
	z4dq6p14MUvV7vjtpBcVbEmMEgdX8hk=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778635473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V//WEgvYvOtQzork1SgoHWYWyLIW2uok/IJueBniAeU=;
	b=MmLYRPKSxaHspbs3HhvziuF1lVZKSQrugOXH7GXQuYOPxbxGWC+uamUsGqsqb00PbnziHp
	Y+eXsc1BwbO3MM2k7SWKWzm3AlB6OGteDf7za+X2nvhyfAjt0Xl3uE+FtR2b4zwLCHb7Wx
	066H2ekrgGPlJ1Z3/q93irgSGVlFA6o=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH] Revert "mm/hugetlbfs: update hugetlbfs to use
 mmap_prepare"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260512160643.266960-1-ljs@kernel.org>
Date: Wed, 13 May 2026 09:23:51 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>,
 "Liam R . Howlett" <liam@infradead.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <732AB0FD-230B-4160-9C6E-5CF7F5FFD737@linux.dev>
References: <20260512160643.266960-1-ljs@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: mhe3jf5jiefiw4n8mcsbo4gm87u5wuik
X-Rspam-User: 
X-Rspamd-Queue-Id: ECDA6180004
X-Rspamd-Server: rspam07
X-HE-Tag: 1778635475-171103
X-HE-Meta: U2FsdGVkX1+aKBS+mWEKwX/GngGUAUZISzHk8VJuzGy8r+xR0HbmAlU4c5RiUlleMWWy2AAT82X0AjzvB01mg5LMqWj+V494pgpi8Geh2BJIoI1EHJkRyXw6x32XTTUQLme2LW0s/nJj0W9oKk7TAEHAYXfXMJr2CG7UsQ2pjX6shzOWlbytwVi9Gy+RFDpbuT+glwGtB5IjmmWVMuu2zKi7QTPq52RFvZgnazH6pgM1XUjGxjrxP4A+OoJ+Ix0fOmQaAnIVenbUS9KTZiOtaQymqoxD9zqrNO+JIB6mdrkteFDh3qdvL0sXUjIjhjA/aikH/AnGcMPAXK7fv6hE8qIz7tsPR6WavpmrGUumX4CvixM7s2ijtrYKKV8Z+sothZiOpL4yCmvx7wxBlcZ4QvbVImqdpX7uMTECh2lyWuo1pfX7VkxTjjBxFNFpyh9jOqX/WA9JwCaRQfQ/H6YYo8GTwuFW3VeCKBlLZJd3jcY/L6dUBLh44iltUfl1RHTZwl7C/dk2sZ4vhQGiKNBKvEXDrlqRlpyzU/8YGaCCH8WwRFgII/dLuHK3csWuwm0JnsBYyR1PYQp5/MT5fhnBcTErECp02NnuCn+UKG5Fzk8wD1+oPN3lG19eBWAxCcRNmckrbTlZHVQLIylnLiqwMaQ5rKYNYglBV6quKYohokN8xF/IUaErP+wtRsHu0KkWT5LZ82gxz8FMUeYZT8wx+18jMYScRuCAdQb053OWCaIi5yn6x44UJmhouQD0WAYi5W5F3GZKZ8qeFaawFD6fIGyeuztSOKHpy0FwxVf6obifsS9uvR1e7nrKnzPdewkE+KYB8jRwO/gkJjHSphoMboaibR/JYHCJ61dYLSJg9QK+2GxeXdr+AAsuF8TFiYxDejDS3S6MNARexTiNrTucYvfi4hSsM72PVv8yt/zVC30cGuX/z6GccH0Y7wfV+xeJkura9Ylr7y9Xzuz65xh
 C6B6i48X
 HuqjetoH21e3raqlXR/ML8IHoO1RqdWl3lk4ecVbmEV73p3Sa1du85yc6MDqALMoFgVo6pImfLePfeoWacjPXPC9TWKcA/dRCJVWkAlfEYWKGh737JrvrFvEcuV2twO4Ta+wQprU1kkfv2Lm2P4/+Ez9oOk0xnc7c6rHwIT9OnzD4pl0xqIiWvEKxjEQJhsO/puzH7ghmYwDqqM+j9BKrldRVoJg0ePH6qb3c6fDlKYUTRgVlwvR8YTZfxe0lcsY0u2mUiJlDZB5sKFJF6XpP/JT5mGWnrDOks+zJBkX5L7dWbc5f3jp4cEMtkQCZPCGzPQ1c3I2PAocg0+osK12omizgeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 13, 2026, at 00:06, Lorenzo Stoakes <ljs@kernel.org> wrote:
>=20
> This reverts commit ea52cb24cd3f ("mm/hugetlbfs: update hugetlbfs to =
use
> mmap_prepare") with conflict resolution to account for changes in =
commit
> ea52cb24cd3f ("mm/hugetlbfs: update hugetlbfs to use mmap_prepare").
>=20
> The patch incorrectly handled hugetlb VMA lock allocation at the
> mmap_prepare stage, where a failed allocation occurring after =
mmap_prepare
> is called might result in the lock leaking.
>=20
> There is no risk of a merge causing a similar issues, as =
VMA_DONTEXPAND_BIT
> is set for hugetlb mappings.
>=20
> As a first step in addressing this issue, simply revert the change so =
we
> can rework how we do this having corrected the underlying issues.
>=20
> We maintain the VMA flags changes as best we can, accounting for the =
fact
> that we were working with a VMA descriptor previously and propagating
> like-for-like changes for this.
>=20
> Note that we invoke vma_set_flags() and do not call vma_start_write() =
as
> vm_flags_set() does. This is OK as it's being done in an .mmap hook =
where
> the VMA is not yet linked into the tree so nobody else can be =
accessing it.
>=20
> Fixes: ea52cb24cd3f ("mm/hugetlbfs: update hugetlbfs to use =
mmap_prepare")
> Reported-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
> Closes: =
https://lore.kernel.org/linux-mm/20260425070700.562229-1-25181214217@stu.x=
idian.edu.cn/
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


