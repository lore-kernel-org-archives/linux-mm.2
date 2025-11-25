Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D80AD0EE00
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 17:45:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 838C86B00AB; Tue, 25 Nov 2025 12:45:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9346B00AC; Tue, 25 Nov 2025 12:45:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7FB6B00AD; Tue, 25 Nov 2025 12:45:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A34A6B00AB
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:45:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F02FC0348
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:45:04 +0000 (UTC)
X-FDA: 84149855328.04.E37444C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 67DE74001F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:45:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VZHX3MXu;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764092702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=asAb1Q6ZmwN1jjCdxe71iqm6CC7vdqFs0hv2ZExK3ww=;
	b=jkFtnO6Nv8yU5MddmwiCm6YZAY66Ixn/+EOZv7iHiH1fGXWYCB3wYCihtxdDy/2eIymj2e
	mL7M+BTs+5rwombw4YOlXBeKR9bG0hcvUgCGhrPZ6tKRpVwLNG+ItJfM8dnxYxgYuKZ0XG
	dLugMn5tqZqJZVZbJQiupnc2vr0tlfo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764092702; a=rsa-sha256;
	cv=none;
	b=XsOE/Eyzh0ZBi0O5uUFF5w80ewcBb/IxYv7aOFeOKjQsjXqkzXbqUMgVWkPxhEv0/V2k8k
	VhBIIl5CVcUHdrIuNLAILaB5Qah5cbG5+irlAR4ScQLirOQ38FveFMIoqmZwU03L8NxFQd
	EA4zoneC/UjAKszxnAT4ylnngIxTuus=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VZHX3MXu;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6807D41761;
	Tue, 25 Nov 2025 17:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC939C4CEF1;
	Tue, 25 Nov 2025 17:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764092701;
	bh=6MjkRoP4KxQJr+bGxbbmNLcKblvkslWo6AD5hzFT+7A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VZHX3MXuUJbaIP/03cfPB3m2zz+aI32MRUB+0az3g0J0DyuFi+V1/9TDbA7GU29Rm
	 2m8CSzSSnqW590XSa0mQ3Qlg5Xx3mZif3tGde9PaMllTJZeGPKZQTdCir0UgokR7Jq
	 L0oU/9SiEHEiIow4mbbt39RwA6yDrofzLUL+jNLE=
Date: Tue, 25 Nov 2025 09:44:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Miaohe Lin
 <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, Wei Yang
 <richard.weiyang@gmail.com>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm/huge_memory: change folio_split_supported()
 to folio_check_splittable()
Message-Id: <20251125094446.c78c5139f00ad8e00e9bd5d9@linux-foundation.org>
In-Reply-To: <e5118fe1-7963-4f09-a80b-e6185ffcb366@kernel.org>
References: <20251122025529.1562592-1-ziy@nvidia.com>
	<20251122025529.1562592-2-ziy@nvidia.com>
	<e5118fe1-7963-4f09-a80b-e6185ffcb366@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 67DE74001F
X-Stat-Signature: nmps7gsnaz37zoq3emp31fs4iuejadfc
X-Rspam-User: 
X-HE-Tag: 1764092702-552827
X-HE-Meta: U2FsdGVkX18AK4rvry8mWEgw6GUFtdu6x2+tc7SgLO7UAvI+sjrl0Ueaa4wuhoFqWL/VeRE6DMMmBQ7inFal5SWnsac+bBFT+fSKAqE6rC7KpYiz7ovJcWL7YlC0dXdvGsCUB+pJM+CN4uihMIEIyZKT5ZvEBUn5Zgh5Pk7+Cd4dGSPjKyVOrRogDe7dxd9Y8/YVZIImUyfJH6maAcjgkEFGkTMLqNGlgU2LZTSCTHAPjmt5m334DCmyAYnzZSR3VR+EDyGPQh94+iV80CATvt84XoYMUjof85RUVSexG5yocgy7dHlD++asEL7AujRC9sIabfrxwtSPc6FrImMt5wIDDLpNTp1TfYdiFFaofLxXQ/lO8EmLcxnChrPvl2yLfjkhXAviWumf2QeGJzxqaMpPmU7qpAtUVjiJ9zfAjhp1csmlL+6TJdYyFiiFi5j+Ya1pXCorRJkbghsqPWFx5GJzdOCGV9CtB8Uj9g3rJEHUj37JQVa6x/gtY5GztYuQrV1kvH8yil8qYu7jLrBpXzjOm/iYgsBeM+Syr+XsxgfwBa10OonKfgJmW/SzCRBSlA4LK29wTyacT/EmpWBBi6MfxII1XP4nKsUW5SwfObcpfTMCROgIDtuPX98L5KOWsQMKCfu+Rrte0IX7eFx48lkfVJ10SWXWr/Azef5zE6t3Ah5XVVJtz+41lTtI0VBr/pdsWmJlM28IXO2yU8umOAmFvyJrhvCUEuOnzAr7gteMAc7JSKseQz+3uShd3Oz6YQENWYwvI8UMyAmWwIgITEATGIMC8AkpkMQ5Mm8Fu/UaADfeUpSnc9R/yiZNoUFmgYqwtZp6aUGpKqgnxEeOBN6NARTm8+djfs67ymcY+ryQi1mHh+bykJxyA9PrCI0mrXcsdOl3ZOm+pOHbCOhnAgaazG2+mcNt5ZPlvTmz8B30OGO4z4XgRV/K0kAtLAAiwTQQLKi5h3/tf0z9LRi
 wEmkbpou
 kTAAcO3DOp/cTv7GzSu4SYNBt9QrShDJl/X9x90djVjy4Gst7DSJEhiN542g4ZzqbORqJf0gD7UJU2ctbk7K5qRcJmM4QqhxXZtiGAW/9aYG10J4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Nov 2025 09:58:03 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> > + * Return: 0 - @folio can be split to @new_order, otherwise an error number is
> > + * returned.
> > + */
> > +int folio_check_splittable(struct folio *folio, unsigned int new_order,
> > +			   enum split_type split_type, bool warns)
> >   {
> > +	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> > +	/*
> > +	 * Folios that just got truncated cannot get split. Signal to the
> > +	 * caller that there was a race.
> > +	 *
> > +	 * TODO: this will also currently refuse shmem folios that are in the
> > +	 * swapcache.
> > +	 */
> 
> Per the other discussion, should this even be:
> 
> "this will also currently refuse folios without a mapping in the 
> swapcache (shmem or to-be-anon folios)"
> 
> IOW, to spell out that anon folios that were read into the swapcache but 
> not mapped yet into page tables (where we set folio->mapping).

This?

--- a/mm/huge_memory.c~mm-huge_memory-change-folio_split_supported-to-folio_check_splittable-fix
+++ a/mm/huge_memory.c
@@ -3714,7 +3714,8 @@ int folio_check_splittable(struct folio
 	 * caller that there was a race.
 	 *
 	 * TODO: this will also currently refuse shmem folios that are in the
-	 * swapcache.
+	 * swapcache.  Currently it will also refuse folios without a mapping
+	 * in the swapcache (shmem or to-be-anon folios).
 	 */
 	if (!folio_test_anon(folio) && !folio->mapping)
 		return -EBUSY;
_


