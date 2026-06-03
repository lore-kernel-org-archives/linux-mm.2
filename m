Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B3E9CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 19:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9180C6B00AF; Wed,  3 Jun 2026 15:22:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EFD96B00B0; Wed,  3 Jun 2026 15:22:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82BE76B00B1; Wed,  3 Jun 2026 15:22:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 729536B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:22:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 172F4A05A2
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:22:34 +0000 (UTC)
X-FDA: 84839573028.16.B924504
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id D2C4640012
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:22:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="i3/CeXQw";
	spf=pass (imf17.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780514552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SzfTa5HCL1jfcKZlB3EuMMBtnPEwh0opU3X/4Q5o0kA=;
	b=g8eh/NjNsbN0r7TLcB6BjLRcCcaVTEh5TjWYXRvoIvRORSsGkLM5AbBbWLDgHXgAE6iqde
	RlU35bDRCJD2VWeyNAESGIB3QJ4q+YihFby6H2ZyRO0jbBuarWsKYwvWvCUfwUHCJrrkTu
	S9wNA6u3Aqadee+/qoNvlfgkHlMYo/I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780514552;
	b=NmLHO94hj9ltCcw8Osvy81HS6tlU2Y5IK1N01CvkcGbvqTZLwYdnv5+2o9wa+I95kS9W/v
	nq41HJDYnpGNNZeQsPVfyG8fZ2ygJZpVGiS3SEMyKAI7JC/u2ENXBV2mJNSWUHWJ/Brmtc
	0QUJbJSKoZ9NLzWRR6JkdOO6dep3QL0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="i3/CeXQw";
	spf=pass (imf17.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780514551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SzfTa5HCL1jfcKZlB3EuMMBtnPEwh0opU3X/4Q5o0kA=;
	b=i3/CeXQwYTAB/lF01W86EyYgx77uXSMR+bmEHBAEWjx/e9YHLz7COnJpnC4LYS1x/AcWEb
	+UUg3PCFgTyEiHpaAki/JHjk0eERQ6MjT5d1FMXg6+cQoQz5qwlBVtDcGy1DIYzie7j1ZV
	/mNz2FuzhjUUdOXbCgUC54HKkVyrGTA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-aQ1vVfH5Ndq95wd2x-ZPOw-1; Wed,
 03 Jun 2026 15:22:27 -0400
X-MC-Unique: aQ1vVfH5Ndq95wd2x-ZPOw-1
X-Mimecast-MFC-AGG-ID: aQ1vVfH5Ndq95wd2x-ZPOw_1780514545
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E63FE1956095;
	Wed,  3 Jun 2026 19:22:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.48.52])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 75C3219560AD;
	Wed,  3 Jun 2026 19:22:16 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
References: <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com> <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com> <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com> <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com> <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com> <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Andy Lutomirski <luto@amacapital.net>,
    Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org,
    axboe@kernel.dk, brauner@kernel.org, david@kernel.org,
    hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
    linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org,
    patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk,
    willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
MIME-Version: 1.0
From: David Howells <dhowells@redhat.com>
Date: Wed, 03 Jun 2026 20:22:15 +0100
Message-ID: <22766.1780514535@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: N3vkM-5m548d0M4bg-3Nda7FIrWpuM4rrxy4R8dq2m8_1780514545
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22677.1780514496.1@warthog.procyon.org.uk>
X-Rspamd-Queue-Id: D2C4640012
X-Rspam-User: 
X-Stat-Signature: oxthjcskw1ii1cb1qbxpe31585xdpuny
X-Rspamd-Server: rspam08
X-HE-Tag: 1780514551-37727
X-HE-Meta: U2FsdGVkX1/Qi5rJqkNo+X3xMlLF53X8dtO6Hu77yNbAurYQxz9Xu4fcCwnuAFqj4OIrA2wALZ351Y3T4x0SZbZVMIJUeEIiIpT/dpCw96UUF5cVvGqf9VYKaujd3VjQpwgTlJSPE0C4QkkeLVqwoaZ6qK+SA47OfGmXtbGbYL9UM8oAeMn/5qfCHLw/GEbfGHMi94ZT12Y8Q5mFP9rR9bIx93TFWFzTEKl0NXiJ3JDX87nkt4wHj0jmhm5YOSwngoxbGkxyRK0JSHF4GWCS5vPcpFagPdoepbETWoQmF4IKKn17pfX26DLklrIJLx3MJAHvG4KBgkCLgh9FYthKdMbouDIKMf90QMxuZ2PSdxFxrCZBT+Mm+wto5HHdjk5qPXngRl+ZsDRsePPNVr7Kr00O5n34oo6s7SYC1W8hW9yAropqW80fEyYFtW8MdWaYrtj3scFKlcoybGtSCy+jH7nGiVkZrwB2x/OE+/Rrrgt3t6tDRm+Qis80lyEFoMkqoF4AeVsl0UwbEHVw2S+y6Ob0FDja2N+0+aj5G/XAbFFtX0W/7AEhr2o0H31ZwX0R4RnEHxOrfTjmS/jky6LscRJJZqM9NjPNVLM1+tiWmyHkfzXWjaTCbhqNzRx4r3NhWnlMKHkAkbc29iWz8Yikwu5iDTQ2Rugnc6q13yW0ZyaKvGF9p56j6K6gvITvAByBhsknuk0XawUE8DJ/XGOPjA9+Dwy8cEmekEtMawbEgfAUAhZQmp1DbUU8/CztQ7luLuH6pj3BZAQPd4MMlbVzksnAAJJ4ESv6dggODdHclq6zSWldNw+PA3fDZ24pphcrQwHs0ROo6I7N3lF7wYNUyYXfrXiNKfBhFd/DSUuV2UUZ7VeIVO/4ZH0Lr8uD1fxYfBiYycF2HWYW06FKqVaq6bHLujZI/QkTg2YdZmr9TOvKe32vXqLLiPunZZEVPyITqFhJdmzAnT54O+SRcMx
 hAq3pDqz
 WjVdqg9g6yLAZMvoCOPejNkC/IHFN/pGsRVVRT8eDg3t06Q0MtkgiFUWqlMzRUWGZwJpE0oC2I2yTKKy5fcqkdembmMboFIEAeuPhqHcttsbOfY3d5il8sw6FzSMv18r9rNzOErWD7LBXA5fJfdXNTTJHXQTQH6Vx76DmSG6AmdxicoOZUqzvh5zxtB+eMGVQj7KH6ueseJS60Y7RWqbWrK9zh1sz4nyjAI1JPmT4/VM0CkloS9dIryQ225v4WEb/XlSczrPPb0zqcNKpHfUnegalgDT5kLRms2kh6M7jakWy5S+Vqcwiq0ONmUm5yCcEnYnb3SkJIjrvJzQ073xQlTTskSyn5jAmcODE9AK7rT3gKqlIvOixZ0oLHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Because if people think splice is complicated, you haven't looked at
> the skb rules. They are completely arbitrary and complex and spread
> all over the tree.

Yeah - I fell foul of the net loopback driver just reflecting the outgoing
packet back, complete with all the original spliced bufferage.  I was
wondering if the loopback driver needs to look at the skbuff, see if it has
zerocopy elements of some sort and, if so, copy it (or drop it if ENOMEM).

David


