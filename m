Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EA64D0D171
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 21:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 996656B0092; Wed,  7 Jan 2026 16:30:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977CD6B0093; Wed,  7 Jan 2026 16:30:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F486B0095; Wed,  7 Jan 2026 16:30:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 726246B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:30:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C1731604FF
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:30:00 +0000 (UTC)
X-FDA: 84306460560.24.B01FA41
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 48548C0002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:29:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JhXvBhXX;
	spf=pass (imf22.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767821398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ow7ejlnL76blgGovBd3isSBtOAsvSD2Rawb77QSvQFQ=;
	b=G9fJJ7rnnB0o9Yx6QPeCJ+hrW9D8NCXZ7bGd4jxmx3D+v5RAs2HBWZ0KaBL0p4T4c2e3Ae
	SkZNTXNwyLpiodP+O/rgewKmGKRHQ8kXs6f8gWhLQZn/LOyCyGBZu0MxUh4uBPX5gHOHw4
	SLYGAezEU6tagA27AJnfsZbGJLy+aBU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767821398; a=rsa-sha256;
	cv=none;
	b=5GS8I8lilcsxfqdCJ00B0rxnvg3anLqEihFoaOteUrXZpCL/0TxIRsZHqUgzyJKsWqmb1T
	amxTFhvZbpnK8zVFAxzVGkACsSxEiG3AB2+5cE8ZH1sl1MaUzQ6d8yhVla+Dl32xAUX3EY
	fwZ0dAu7SwFdUCPiVXBB0/PcttJDg+M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JhXvBhXX;
	spf=pass (imf22.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767821397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ow7ejlnL76blgGovBd3isSBtOAsvSD2Rawb77QSvQFQ=;
	b=JhXvBhXXvEeTqPFU8p4O6qfXvdq46v72e6P68PpZKUlNUn6ic0ln20XqnZQY1UQQzePJuB
	6bDI8gXt/HibfqLri8JgwWFN8Vu4hi4I7HkF9eBHBT+DePsY5JJmHJHEr4LfbXNWlU/isX
	5HE2tE7ld6jGwq+g/ZFKerC5k9S+XTE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-497-ENzFtFryNKKpqRGMa8A-nA-1; Wed,
 07 Jan 2026 16:29:53 -0500
X-MC-Unique: ENzFtFryNKKpqRGMa8A-nA-1
X-Mimecast-MFC-AGG-ID: ENzFtFryNKKpqRGMa8A-nA_1767821391
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2CC6E195608F;
	Wed,  7 Jan 2026 21:29:51 +0000 (UTC)
Received: from [10.44.33.27] (unknown [10.44.33.27])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7950919560A2;
	Wed,  7 Jan 2026 21:29:46 +0000 (UTC)
Date: Wed, 7 Jan 2026 22:29:44 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Matthew Wilcox <willy@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Pedro Falcato <pfalcato@suse.de>, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    Alex Deucher <alexander.deucher@amd.com>, 
    =?ISO-8859-15?Q?Christian_K=F6nig?= <christian.koenig@amd.com>, 
    David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org, 
    linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
    Jann Horn <jannh@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v4 1/2] mm_take_all_locks: change -EINTR to
 -ERESTARTSYS
In-Reply-To: <aV7IO8-trMSI1twA@casper.infradead.org>
Message-ID: <d3d77df6-931a-b97c-d551-a69ee5ca9493@redhat.com>
References: <20260107203113.690118053@debian4.vm> <20260107203224.969740802@debian4.vm> <aV7IO8-trMSI1twA@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: d855o4heytbukb434hfjcapspee359yh
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 48548C0002
X-Rspam-User: 
X-HE-Tag: 1767821398-23641
X-HE-Meta: U2FsdGVkX19JeRCg6IsqPjLl870BRx5h164Hom/q0//gp2K7RptR+r8/eg0lLWVvYfzwaHq7A5jpI/z/VAsfeKTVgi7SYR/ntZJ7zbWfe9GDGIAzKU2WAH/ZS4YquSoc7ZotjXlu4S7mdv75EAKoczBRpWRdawYP7rnRBuPWfkDwgQJAsICnxcDbS+NfVjG8vJPXFPEhByYY7yvs9pHe9n/AWPA6vkFLJyKT0eaOuLTyYbk0whJ5db1t8m+riW2I7KDXusTNeXNaD9KqNrbCjb0Lt3a3DmCp7WqKVN9o3vM8Y6z0qATXhNgzwsAIdSsYcK/3VI6Epv/9TOC/65C/kk0qVIV1Alqbm/0t8ojnPByBmdAIX1LD7aIEP619E3YgkfgvfwtqAr7yQfdJl9d6IAvLTJpdWDUkXL0UrBpL9v259fGJkPbA2Yk9v2IQgTtB+vAYu6OJDXe0hY+FGzXgI+NwCfHXOQ2Q+VhazBXCmh3FO1FayAiHaFh8M3TfnBgTvWMiyUgVGbcvcQN4W+wdrzmBpHoIY5GBQ9vOyTe5u3w1sTdDn4zISRajASw5bwJAy/Izo/gC7IcwWrda1+faz9cDLjnfIm18ZIwwUJQuKLBswZSmm/U9yyYgWlXdMZ9GYpEO+5wpUqnTkoDJs0nxErLQULJ6dCpj+LsenyDq8XeTNpOMnn49Lpr5Rj6p7R8ElSITEP11XuMf3b2X0QhEWgOPDa+22hIsBjuiiOYOv94l2Fni5iGXYkSBYZkOYyay3f65tEK2aMoWmsKHMblkJ1JzehxfQOYPje9Lr3YBapaM2qjChs8lWZEFWNLIziX3e2gWawE3blCt9yOtJMVEIdDW6u+t0eI22kUCZ4G9bXlS3xoiQ+OUdadBKBHaaLedpIPLWXvL+P9DNIGfmZKYRXgQxMGoQtSPUwlIDKrnP+ZG4kOGHySCebMGwYB4Z0VZ3amDu09lZDB+a4VhTKu
 i8T7frGs
 nkOTdCyrkvaeBEqvac//n+8odrtwQ0WNTEqFBz3XHvBs3VzcEVwUHnqRj6FBVByks3tAmhu6RygP78ACbJDr26gbNkoX2dGvG2HoOPGyjdZBKJ/phimqRzQOYJ1MzX4/8qtBVoGfg5GzSQDl/hmCLRBmDHBVnqM45pw9al/0jf/DlYRAT0iHdN5FWfNs2N074bO/BYWl3JdRFiMV8yxhNKKg8TOngKdN2iWDYuaQSl0e11eRPPZIjeE7CGs0wM+ZdluTfPC2rZLbrWpGmeLN1g1F6JdSnd6hKSpXMeHj9CMwN5MPXIVfu3uLGj2dbE2IpqiYMXOec67AYUqfKLfu9JiNnS4tKCWdkuDNbEdBjaSrHHRS08vwik7XQow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Wed, 7 Jan 2026, Matthew Wilcox wrote:

> On Wed, Jan 07, 2026 at 09:31:14PM +0100, Mikulas Patocka wrote:
> > This commit changes -EINTR to -ERESTARTSYS, so that if the signal handler
> > was installed with the SA_RESTART flag, the operation is automatically
> > restarted.
> 
> No, this is bonkers.  If you get a signal, you return -EINTR.

Why?

fifo_open returns -ERESTARTSYS, so why not here?

Mikulas


