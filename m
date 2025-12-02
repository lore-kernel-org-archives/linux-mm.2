Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44B88D116F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 13:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10F06B000C; Tue,  2 Dec 2025 08:13:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8A76B0024; Tue,  2 Dec 2025 08:13:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FEC56B0026; Tue,  2 Dec 2025 08:13:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2CA6B000C
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 08:13:41 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1E0F91A0129
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 13:13:41 +0000 (UTC)
X-FDA: 84174573042.01.4CF6046
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3F6B740018
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 13:13:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="E6NDEt/W";
	spf=pass (imf17.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764681219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JsdSONDsYowfbOUGFHoi6ZdWvnnwkrdvfymRkfV+MPY=;
	b=rkp5nuX07AvLrnzNvHGmC5YYmI6gHr+606m1WQrovlfHVtlvXhuffRnDTtsZqZhCcUeoB7
	Zi+celWgpP/3mB6rQWo2yXVuGsJqgKpK/5+IEEzFEJbr6UgKzWr+PFmjQ5yiEiR5u/3VYy
	y7IR9kRBGCi3iTSJ2YVnJi66zmEI8+A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764681219; a=rsa-sha256;
	cv=none;
	b=2CtLR6xKohY6YcjPjeSoBbxRxsryGZSWchBXBLcR2ivR/9o6/4PJ4XHCyjx+PtQ2MCitiW
	qgBpEp0f8OVmzUgQC0xPMAXQAUiNOci0Xo6qhXnTOpr1nWuXd9piGtgeAraFDLv/Erd0kU
	i7TeGqXtckM+fLWrjxKMEGjl2oOpUkk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="E6NDEt/W";
	spf=pass (imf17.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764681218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JsdSONDsYowfbOUGFHoi6ZdWvnnwkrdvfymRkfV+MPY=;
	b=E6NDEt/WlW4I5DzIA9C7v91IPKDFnfslqKZ+W+MQUjYNIt2/eoEUq58UGlo0duB0j7+osv
	hShmDHbSauZpvVkVmskmQ+zxhRkLfImWcDLsI6q2ue0ReV1IzV+6BisXBMRGfy2n6yFO90
	1Tnr92dJ1Sy6IvhouEAzw7swbMDT7wc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-604-q8bW6AE0Mo2R_347Dw_DuA-1; Tue,
 02 Dec 2025 08:13:35 -0500
X-MC-Unique: q8bW6AE0Mo2R_347Dw_DuA-1
X-Mimecast-MFC-AGG-ID: q8bW6AE0Mo2R_347Dw_DuA_1764681211
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61C7C1977016;
	Tue,  2 Dec 2025 13:13:23 +0000 (UTC)
Received: from localhost (unknown [10.72.112.62])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C472918009A9;
	Tue,  2 Dec 2025 13:13:20 +0000 (UTC)
Date: Tue, 2 Dec 2025 21:13:14 +0800
From: Baoquan He <bhe@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, andreyknvl@gmail.com,
	glider@google.com, dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	elver@google.com, sj@kernel.org, lorenzo.stoakes@oracle.com,
	snovitoll@gmail.com, christophe.leroy@csgroup.eu,
	linux-um@lists.infradead.org
Subject: Re: [PATCH v4 11/12] arch/um: don't initialize kasan if it's disabled
Message-ID: <aS7l6gfOWvVpFWy9@MiWiFi-R3L-srv>
References: <20251128033320.1349620-1-bhe@redhat.com>
 <20251128033320.1349620-12-bhe@redhat.com>
 <86d982368a85ab9dde17e52b45e77f5f76efea08.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86d982368a85ab9dde17e52b45e77f5f76efea08.camel@sipsolutions.net>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3F6B740018
X-Stat-Signature: ewzdgdo6rdhb9homekcoxofhenriw6gx
X-HE-Tag: 1764681219-255586
X-HE-Meta: U2FsdGVkX19WHstSz5L9CQK+B7Cfz5H4rb1Bi8byQXKQzsBa1kFlO4E0F3L0q/76C9kd6FawxTcf5m+qOQu+MduAWUuiOojrpI2mPuS8TXC84aWj9KSAKTG2zi3SXgdzOFGOL01A032+U3JOZyDK+SRqyTk/9GelTRsEcnvYOzfeQ0ppSeN+VzGwTLCKjIq3D4Hspxwim/m354qJAnxMt4xL7KIH/B++U3yDn3k+nEiMOYoAFzFbrPZQqJGmgfL6kUinlA4Mx0E/IzxoegarE2mmceSDp+603+ES/aBkLevhHcXaaFNq6pO/Jk1g/8xa9noyKZ4vGq+stiEu0TlH4gOEb9xaUvhoVd3A/y8+HORIJaLFjzbfYTqt3UyV0IopStTDVXtMW3JuKkKMr6zcLHSFvkntTBtinLyTs1JtxrIHCUUjwhy7hOC9a8IA9/zfTgLuGZsy6/M41YmAjGtzDMno2/cRk+sLfIsvRVZOE9OAQ+KpBVLcA8Pyra/vPeGcx4A+vLv9cOG8aqTaiRYG80iVLLslt1/F89BCZzumuIp0PJwNq6nEqXJ3EYk7/1nAQ6bnZfUcPVzlRiew0sXc6t+D/uuwant/m+alv7Rg5dzJmgNJOSy5Y/xTdXjdi6nsHTsf0tKDkxTzY1VVqq+sML1PVOHTByQd2WuxllOY/NpsSBimmGwIsxLf5eNYVpzqegz6Z6v9k54w6xOJ/Ht5xjiwU2Nntw4vuc8YFPwh/qR+Pjzw2QDEQW7yQHODWMna6vEEAbhnsm27fvM4wIbia0ouB+ADHttoLO8nJEuA1j/qyPp8NBlHoLrJJ4GhXzqaO2wqR8Oe1yzPiwwRddd/H+0+MyU9BJ2u4LsZkETA1JlyLjoddE4JhdS0NpPJmcUT0+Xi8Dj++UjIoclmuDkx7OFeM5KDmZRDDXZitJHgwIMMSrinUe5c8NGlGtJ++zyB/qVdRYm8frgOksCrBRL
 d74tEsD4
 O8GtrvK/XCVTQReZSrSSyqhMJvXrZkRnlqSD1mEN+3le8xYsRLXjcwSUTilOsMYKkMZ9ZHtFRftuiHeQsRjbD66q3rXMjCkbaIe70q1aCLQQNTzIdQywY/7RG2Hs/S1Q6mxzhcdbKQothNR9xBxnxA8VK7s3dbuEgCl1rUf7tpCyAaPU2i2vy2Jo5jA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/01/25 at 11:56am, Johannes Berg wrote:
> On Fri, 2025-11-28 at 11:33 +0800, Baoquan He wrote:
> > And also do the kasan_arg_disabled chekcing before kasan_flag_enabled
>                                      ^^^^^^^^
> 
> typo

Thanks, will fix.

> 
> > enabling to make sure kernel parameter kasan=on|off has been parsed.
> 
> But I'm not sure how to understand that sentence.
> 
> And I have no idea what to do with this patch, with it being random CC
> of the middle of the series.

Sorry for the inconvenience. I am worried several rounds of posting
could bomb receivers's mail box, so only add arch's mailing list to 
CC in each arch's relevant patch. The whole patchset can be found at
below link. And the whole patchset are sent to linux-mm, lkml and kexec
mailing lists if subscribed any of them.

[PATCH v4 00/12] mm/kasan: make kasan=on|off work for all three modes
https://lore.kernel.org/all/20251128033320.1349620-1-bhe@redhat.com/T/#u

Thanks
Baoquan


