Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15F34C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 08:10:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6F46B00BF; Sat, 27 Jun 2026 04:10:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAEAF6B00C0; Sat, 27 Jun 2026 04:10:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9DE76B00C1; Sat, 27 Jun 2026 04:10:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D21C6B00BF
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 04:10:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 28E73907A4
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 08:10:40 +0000 (UTC)
X-FDA: 84924971040.18.5AFB734
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 92AD140003
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 08:10:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QKpWqi5J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782547838;
	b=vY8RQQx0Z49NwXhLUxKR35e7NDlA6fb+afCa91tcS3GHoCVASQ4Z8bMKGCfcPcMfPWVubW
	GnDBbrhZb4CTueLxNBNouyCLhXXpQyNkM4pn8QXUaDJYXA2N7ADzXm4qwwy0JtCuOlEf2U
	w5wj4q26qbK0tSAKzThrBoYDSj1Wt70=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782547838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eTAIgWxGNpSg69lMclaqMrON/rAaetWWrjF7qKqNzt4=;
	b=tXIOloJvWYdDB7sz+SCUqt0gdzig8PbtFcLZYcvLkWh0p0dpyeXpIBWBIaUxKXhGupaXv0
	5fEw5amXO+hkn/StVt7KhQ78abqWq5/pCj2NmMZXEo+AbI9NXYdfGYuIYuBkjv6lydI9B8
	2XBIRHmUoDU6kDKFC7bvOh8KkQWxB4Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QKpWqi5J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7920600C8;
	Sat, 27 Jun 2026 08:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FAE1F000E9;
	Sat, 27 Jun 2026 08:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782547837;
	bh=eTAIgWxGNpSg69lMclaqMrON/rAaetWWrjF7qKqNzt4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QKpWqi5JrQfOQROMv2OSoXTAaY7IRR3sO0WfuN1qvx1l2b0oHysMy4PHVXzw+V8Rr
	 Brc0qkFTaSTrRE8sPsc+TWz6aiPQ8SLd687MoNACrxWKQ3qM+Bu7wpx5DRbwjRLbnC
	 A93OT2JhcsDrBwwC7LzPA0McritfSWefHzc7a1loENR2MEi4uUZi+U4R/9cZwhGJzo
	 8AQJS7jL/xYrUW7rx/x+gB+nsuHYcCizs1eqt14X6rq6DJ0VnPv6tnNqoj8Pj1PTHJ
	 E0PsLlxHputgytZLZP4n3mT5N0I1ZTN1kHM95ZbK0NSQAaCXsqJjHLnq2fvjtokAD4
	 +h0iN8Cvnz85A==
Date: Sat, 27 Jun 2026 11:10:27 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Gladyshev Ilya <ilya.gladyshev@linux.dev>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>, ivgorbunov@me.com,
	Liam.Howlett@oracle.com, apopple@nvidia.com, artem.kuzin@huawei.com,
	baolin.wang@linux.alibaba.com, foxido@foxido.dev,
	harry.yoo@oracle.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
	muchun.song@linux.dev, surenb@google.com, vbabka@suse.cz,
	yuzhao@google.com, ziy@nvidia.com, pfalcato@suse.de,
	kirill@shutemov.name
Subject: Re: [PATCH v5 0/2] mm: improve folio refcount scalability
Message-ID: <aj-Fc9hCSj51RYbP@kernel.org>
References: <bb1cb750157733f897df2e261cad3d5c42acc172@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb1cb750157733f897df2e261cad3d5c42acc172@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 92AD140003
X-Rspam-User: 
X-Stat-Signature: h9f68ujnw8ifhq975t5agmwhr18nzhnp
X-HE-Tag: 1782547838-857224
X-HE-Meta: U2FsdGVkX19iZndFD1tFvIuAUUMU7a3saEaApGBMFAuS11nEgtGjppWs6/+uZ7oA0QoFDNpSWsMOkziSFr306If5kxv5986cJW+0UtHQf5+YfSKscO7YkiBN4v2mk1CyDWtj+UNrxP6t1v+XmWoc2Zz8h9F1wyf/aijmV3SdMiwgw6nzD8LpZbKGBx+HrBgWOobZiQNyEikMhAxwNXTlLUwYt8K7NS/+jge9hDDgevOTCq8e+mDsWE7hQGfDs93KWuLrSwD8Q3QrpvIADLoMIMokx0CgUdByP7lO7OWJ6sMthw3vqCbOTxI7UmXbjQ5cukCeq0QesmQ2fsq0vc/ihOeTzJA2KyUwCW0iYafBnAL9ZtrfxxJ6pXZFuKqghdBDj6GYZgs/n5EWmYKpPVnDS6D/z7Bt3qyaWrtZ4G8CV4IidaKkjVJ2Zt7v8ySTSNwvDVy69qNQqL8IfaYWrNO6kuo4VhpRbvzr9x+gjj2YwFPBWIzDgyhZJ4TGXSJEALzEyxQ4e/Hg5meQ/8eKd4KPLCDL06kBj746eAHSMZsXWcT9Kv35ou6YV1K1JpKiUHFS7z7BPd7zDVU06OLHQe1fSc+DwbaLGjUgd/Vc/KJpWQAg+4Sm6AHK6EwRPP8HSKswbcPWbRDwHDeKa3zArdn3WhFR6LY6t3+q5Jv/JwwoA2RdVoxyECYQTuh7RffiJuezaaqLj+gTNxVchzKJTcTJPc00V446gOZlsrYJPHl9dig6XrG6aw8bolgwueKWxkNifuIHHBgwZbCOLivqMpIbh70L3VgGMKKp1pYDjmJGHL7MuUnqH2uJOouavbvvDkA3pZX4ikhyuJYnrTYZbK1g97k6kcwpLfCxPU/66AI+fVT6y84YUHPCvT4x/qYskjk+bStQS1b5RldyXyq7XdXSpdW4vSzIYeAz2qt7vE85j+rzHIIAqZ1jsDPEVMJSZsdmeSYtSjGAtiRnHy73uzM
 /ixMKXgt
 a7He+43DwTxsQ4sf2d74LjzUBxazon3QeBHlxLvE6b+oBYyDTd9mNR3fMyGhajJ6GNmeiq8/tZCJY72oqxOANJdnVrb4haQMDOB42a6c6NBtKa90upOf4DsY/G8yUMIvyazjwndIALi83UkDteqRnJ7HWeiYhz68cJ6r9z4R1YFlTlUFwYsMS9a/9MdhDy7jRVuB4spKx5/fee4oVLOLs7lmKexo70wammFH/fFeW0XqJuYv4WFjcveKwPbrCrkITj/UEEn4ZyOISdT2lcNgXycOyQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 06:44:58PM +0000, Gladyshev Ilya wrote:
>
> This patch optimizes small file read performance and overall folio refcount
> scalability by refactoring page_ref_add_unless [core of folio_try_get].
> This is alternative approach to previous attempts to fix small read
> performance by avoiding refcount bumps [1][2].
 
Looks like memory-failure selftest is not happy:
https://github.com/linux-mm/linux-mm/actions/runs/28259343162/job/83730467505

-- 
Sincerely yours,
Mike.

