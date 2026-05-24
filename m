Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39851CD5BB1
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 16:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 274D36B0092; Sun, 24 May 2026 12:57:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2253F6B0095; Sun, 24 May 2026 12:57:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B686B0096; Sun, 24 May 2026 12:57:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F33E56B0092
	for <linux-mm@kvack.org>; Sun, 24 May 2026 12:57:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 962F0946B2
	for <linux-mm@kvack.org>; Sun, 24 May 2026 16:57:33 +0000 (UTC)
X-FDA: 84802919586.28.F40E0A2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id A48A01C000B
	for <linux-mm@kvack.org>; Sun, 24 May 2026 16:57:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U14FSkIr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779641851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qlnZNmmNlDSDOzEVC/JXlr5fypXMAtESKL2+6Sj/9E8=;
	b=W5lKN+XzRXjK6ZlH5BwUXm8xJAsMybL4p7T7ocFY78D8V/yLNkGUVY3JCrEkqsTejZ06pi
	oP3Yc3tV2cPGAb59DDcgN0eLj1lAe3OR2VEe8Dli4OF6Dttewx6gDQwkkdF2UJUnNyS/E+
	J5qDyRW8X1eEU5cNhOkhctVIQh3BHkc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U14FSkIr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779641851; a=rsa-sha256;
	cv=none;
	b=OWJ6hnruiNJAhAD4g85w9waThapj9gDsy3AwXD0ff31hmiPhqIclTF83zRii3OSJGEeGZS
	N8XsenuNwoAA4cJEPF7/h/c07vylCBeaXwq8G5dp2oBFAHwCsiWEzHpHIu6GFFAGs5KgCM
	WEwoqsmiggBj1ESlcIJTtNDp28LfMnA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779641851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=qlnZNmmNlDSDOzEVC/JXlr5fypXMAtESKL2+6Sj/9E8=;
	b=U14FSkIrhFkmB9uHbU77FLVzyh3BkAJKkWFa7rl7VONHB24ceZB2Czzol7w0F1TdJVCaqh
	aY1yncYqOYiWrCf+DjrYw5bz0yhDe50/QBDRP7AyYDX/nr2gyUlynYQ5bnlogxHrLxfxZ1
	GxuY97dnmUGHGbPn9y+95D4XjX8j+Zw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-ZVnxxkzRNxidHtldGDtDUg-1; Sun,
 24 May 2026 12:57:24 -0400
X-MC-Unique: ZVnxxkzRNxidHtldGDtDUg-1
X-Mimecast-MFC-AGG-ID: ZVnxxkzRNxidHtldGDtDUg_1779641842
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB506180044D;
	Sun, 24 May 2026 16:57:21 +0000 (UTC)
Received: from fedora (unknown [10.44.48.14])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id B73B1300019F;
	Sun, 24 May 2026 16:57:16 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun, 24 May 2026 18:57:21 +0200 (CEST)
Date: Sun, 24 May 2026 18:57:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>
Cc: Jann Horn <jannh@google.com>, Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] mm/mempolicy: kernel_migrate_pages: fix race between
 security checks and suid exec
Message-ID: <ahMt6xyUNnacZU8-@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 4cuvwQN9lcdxKXAdMbzuOHucn-WzrInlLNuOtdlIPDQ_1779641842
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A48A01C000B
X-Stat-Signature: effzxt86raxdqhgkyi1hfztnbizk7p4o
X-Rspam-User: 
X-HE-Tag: 1779641851-907994
X-HE-Meta: U2FsdGVkX1+w+nFSFIis0CwldJNhBoDpAXEZt47ZWPp70z8XSRz/NlXkJWpnoPkZzlEfQTiX579i/hMF/uR4LuqyEnATw2hkG7SieQN+iR9XT2FDFG7CFIesd09AVoeEF7cdTAeO4fu6TiHWscLW7XsfmlWgDp0PfYCYDcrmVaRaj6IkejQHdvOkf1LHcJ5wVhq5Vap28m39umpkilfm281ibKTQ/9nZPmyI3ZupqUIEh1DYAHO0kZdhAts3GO28Svk/71x7Dw0XvH2Uly0uZNMXk1xco2/ZovaaCc+lAhrTXW3F/1aDBVVMPvQ0WOepFEQxEklEKf6CaH8mZ77VU1zkXBCJRsSHhf/6k3xTopPncn6IQbaWMGWN51xHLYX02X7g6QvrWCd2KLxqgHauldSCcY8+fFG9BdzjPWUewLIEk1P0/PUqRmi6lA7/vve4y8961sSmub1pvMOmslGzYY/tThC+GNhoIaGB0RfPh4he/NOyiTcy3wxES51W1kuA51vIPu5tPQs9QuDSw39xeD+T9ONtrkvG5vGvAhWVs5fByby/q2tf/raQ9/s6jNUk9sdULZk+JJaTxSN99ajhKLWPLtAbfan5/678cluV0kAqcXoxsMihCB1p4ntNA1dIKaOt7Lh8quTaXSaYZGgeRaUrQLdLnE2zWdYks2NUloLt7lpvazLYKsvzg/wI3ow63oNs7Z26xjS6qfhhSv7k4YO4wnJjrR5y80H0nMBq1Ius5p3ajGWf+aS2METnWwbQBOIqM/Ygwl7osKfcTfwakmji1IlGSWrLSuU76p2nd+fMQNWv4SZv6XtwJ1m/0Q8ZeHeEoLp2usuF3iGk0OB9IJQcggZPixeIZV1CxAU21y5jNKiBsG3cYDB1M6yoqaPIbf7zDsbT5c27fGwl8a2fNs3sWz8fLTf8knLwBAEQwSXh4Prwyctrcdshr7Oyn5+JeryVA+/X+1aPYnQwHK7
 NFZOSJiT
 K65W0Op77/srf03FBUY/Tq37vK8mLZlVvJexl4eseIDN0ZrEgfqYKkgb6T8no2yj/tWsdzK9euFfqqyROmulFdy+CeiDIvwENwX1/bNkkI7DpBCwRWX2CyDXeB0mWxwEhQxpFcLANGyaBDbBEIJh24UVnARmkW9t3+4fJPFMJLIgKLKVQQOE/GGRDTwAMbBPF1rKQ/vPM/XBiIF49Wyhx/GxR26mZ+okohiqXOmCZld4oXdZmE/Z76nhybgrOeeW7ScKSz9tGrkgLmV6PvGGhSaSjfHrfpLMFaWzUFu5H/Ajhi66gHdW76XTbeoDnwY/38InEsLW4p35ynHIwhzBjudZIZV33EfX0eNjzw6eSas8WS4ESQusgxMlEE66yKVRDGZTCEXcH/GW9mQM1sII9z/gXza8Qrk3Oh1TKay94R2UmR8P2xAi1aeMoB2fVR7/RKloUAnlfWJzcm/ulgZvOmrh1uZoQX03a0DOEOpTAMLGzb9podzrs3OEFuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

Sorry, I have no idea how to test these changes. Please review.
Hopefully sashiko.dev will take a look too ;)

find_mm_struct() has the same problem, will send a patch tomorrow.
Unless you tell me this race doesn't need a fix.

Oleg.
---

 mm/mempolicy.c | 53 +++++++++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 28 deletions(-)


