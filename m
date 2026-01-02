Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7C0DFA3741
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 13:47:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AAC46B0088; Fri,  2 Jan 2026 08:47:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858336B0089; Fri,  2 Jan 2026 08:47:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73ECA6B008A; Fri,  2 Jan 2026 08:47:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 615A86B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 08:47:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E614A1A794B
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 13:47:01 +0000 (UTC)
X-FDA: 84287149842.14.C79F6F1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id F270580007
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 13:46:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D8DUnaly;
	spf=pass (imf30.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767361620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1i20b/Mjn1bqQD3Dx3TUmWUZ2VJRP6JCW5L9UDKlzFc=;
	b=o8bVIqH5wphUAtmfXLsEV5oekimMViEMqgxN/qXlU3Z6KZ2Yf+nRx3RnlQdMuaOXjpOCB6
	QKVYyS+kUF8cQi1/OpjhJ55QDqvKoay0PplmYmlejGw+bEaUJIS/yCM5YFrNJE50AhNkfo
	2kHbPVtfLlDPA7Xn7pDiolc44cqg3Lk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D8DUnaly;
	spf=pass (imf30.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767361620; a=rsa-sha256;
	cv=none;
	b=SEUITNIS6CEZcRomv4JHHRMpU0ul5RUTohHYaVpWPtZWBCjv1tITvEC9a5td+y2bcyKOr4
	gJw4Cgf7LYGoas5ozl2yRcQjv/ZequtGR1grjfrSVV0apA8REfxpoKlflaOxSLZZ4/GUX0
	uT6vy+Ay8yaoYBD+VvRvftE5KrpRgQc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767361619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1i20b/Mjn1bqQD3Dx3TUmWUZ2VJRP6JCW5L9UDKlzFc=;
	b=D8DUnalymLz/H1sQ9Jc2FSZDbz89pGHZuzx7JDE/snZatbGxdtLN9O+hdJ1FHx9z+U4JdD
	BdP3w7pZSRj7B7G9xUlUieevs8CDZojyb6Ndp80yDMXmURGTMdYoq1ar+YSjs8aCgLSRLe
	z2tqvc50mOHyIBhLaZk7Pus241Z4oY4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-439-62FfLU-aMZixtLHflc2r_Q-1; Fri,
 02 Jan 2026 08:46:52 -0500
X-MC-Unique: 62FfLU-aMZixtLHflc2r_Q-1
X-Mimecast-MFC-AGG-ID: 62FfLU-aMZixtLHflc2r_Q_1767361611
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BEB119560B2;
	Fri,  2 Jan 2026 13:46:50 +0000 (UTC)
Received: from [10.44.33.27] (unknown [10.44.33.27])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 34A4A1800576;
	Fri,  2 Jan 2026 13:46:48 +0000 (UTC)
Date: Fri, 2 Jan 2026 14:46:44 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Askar Safin <safinaskar@gmail.com>
cc: adrelanos@whonix.org, arraybolt3@gmail.com, cryptsetup@lists.linux.dev, 
    dm-devel@lists.linux.dev, gmazyland@gmail.com, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is
 exhausted
In-Reply-To: <20251211182429.3300562-1-safinaskar@gmail.com>
Message-ID: <eb3a9746-83a0-8271-6bd6-867ecfa49aad@redhat.com>
References: <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com> <20251211182429.3300562-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam02
X-Stat-Signature: 1dyo18mh5biiu3iubt9gkhkkpsmcoqy4
X-Rspam-User: 
X-Rspamd-Queue-Id: F270580007
X-HE-Tag: 1767361619-595757
X-HE-Meta: U2FsdGVkX1/H623gKDz2eRUExJoPCXuWygbucPuK7j+2u0T5t685oYs44qrP9zb4oZSWXHv951XByNTE628nNMvBIIyrJZAfG2Z5oJADbyCp8LxqdyygdKYA0QtWKefsl2sMOd13YPToEXbP96xp7maioQTNFqkX6hvjiWIpozgFCMQ0TR6HEuvf2aWgU2sO8IoWWZoCl+k0cPgr6oLCgdiSmarFY/9wowZomTLwzQL0GsdfyVBsyRUM+h400uMX2M++ajv8ok/1r3ZJiiHPX13XgxXK1qVg7+oozbIeNdLnBIjho1vzyQP9tVYOooVeBkFGd4F2esGs+65+NuiQnubFi7CXQsj1Hd96L1WQpT4ArHM3/X+P9lKD+oXtRnDHolTvXAd58GNSV0BfIdChX5+/T+GXobZI4NXLIkE0WBb9J/7V5NUdOQPPMfmxJA7qAFb7YeOrpnoTyEXhLtkOFN1VIusDKc4CubEf9t/FNnLMbCvG7ggXTMy+zED8QrMhdvJtmQ5wPSW4XN8vPk4KrJ/apCAcPTJfOfJBMFzA77zcuDdCI0MUiAI+HYgfgAKPx4bG02w+7yFlttcvDQg31nD+h0QLLnwFlfzOjVYiOehIkFjzjxghiNOx3yX6Hw1zc4HcwzSroyAvw2ZzjQCfWxxzQe23isRcMpz7mLwBe7hUPuMtDMKLMuOuQ6Rs1TceQenB8P9Pd7VHs5pKbc+pqjvWafnJ6Vb/ZlBZMIdbVFzzY6shFNbgaxFhgoTy+11xjGZuG7wEGIafnT+4q7oRHwrR2qUcxAoVw87F43irNcbxTKkWvytNMuT7fSf40aLaykTK3pUDRGmYmE3IpHNa2FUWLmU5YdPnmUUs8dyw+YXN2ZlSCJcMnTLfQYDS7jBrmeEVGfqBn+MB3K4wWZ5IsbF4+2kLBCTCMQMnEcPLbmRcYrJqOJcgDh6MMZYvki5YDqIs8NHiZqMiMpMioih
 OBPoO7rZ
 lmKNSTsPioBnrkwAgj9e1zgSEtgGq41g5oMjTKKy6HU3DqUxn1Ogeky3DUHILrCs4X1+JuMmqOhY/YmA2dp8KDIBZ6gptl8Qq15fgnUIt64ayLZeh1RMmwWSr8I69I5Ec2nteDjyTc94nCBJFvZFjjBXfatauUgi2wTP/8i2U6y9rx8i10PIgy147Z6jH+RVuxew9cWG3ejvLT14BXa5hCBf7IXlrgKtXJn940gQx1K4yznucyWpTXpUlM8/wQDCrbLJpxT8oKQ2Qsg4fG2yURGI6kXtFjpzjArR8AgVz9umRsMOfJO4sV7d8CRPerIxlDIQbRoshivK51fOMrYimz3DvVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Thu, 11 Dec 2025, Askar Safin wrote:

> Mikulas Patocka <mpatocka@redhat.com>:
> > So, this is what happened to you - the machine runs out of memory, it 
> > needs to swap out some pages, dm-crypt encrypts the pages and generates 
> > write bios, the write bios are directed to the loop device, the loop 
> > device directs them to the filesystem, the filesystem attempts to allocate 
> > more memory => deadlock.
> 
> Does similar thing happen in my case? I. e. swap on top of dm-integrity on
> top of partition? Is my use case supported? (I'm not talking about
> hibernation now, just about swap.)
> 
> -- 
> Askar Safin

Hi

Dm integrity doesn't need to allocate memory when processing I/O requests 
(it reserves some memory using mempools). So, dm-integrity on the top of a 
partition should be safe.

Mikulas


