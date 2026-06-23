Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30701CDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 20:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF1856B0088; Tue, 23 Jun 2026 16:33:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2486B008A; Tue, 23 Jun 2026 16:33:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBA006B008C; Tue, 23 Jun 2026 16:33:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A79346B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:33:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 224FC1C3A59
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:33:29 +0000 (UTC)
X-FDA: 84912327738.28.1E7C82B
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf04.hostedemail.com (Postfix) with ESMTP id D9A3440006
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:33:19 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782246800;
	b=ZgG6QVHQUEJQzbXzqLc2jBSyuRMwUHpL1u+4LCcMOwRjQdvWRA3Ddj+r8rwgX8ZQKtuhM3
	VyGhzadwH8pXSjK3qHizXSRj93+9gxoOsEmKGh5TKhrVxMCTgjWYptfYx5OOrhtVDauK4L
	uPPVIZhSBgwyDVFWd4KNzGGsX4vfJ/0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782246800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YR60LGaxkOt8ZSGPKed3yDDLoZe4TukhQORz2oIXlfE=;
	b=zLd+3VPFJi0Xx4Iue9mPPWIA9VMPrKRV9SCT+zLeow6CWTx0bBw+rM1ao3JeBUFlJwHDJs
	fcEsx4O22NXieCAlAkp4PLMZbuKlEVvMjxpKsF9yWNTlbn+c43OK5E4Ub5KPmdeW2TkDit
	2xHQugowbgm4omwL2piXMNw/twLlj6w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=DySyMg74;
	spf=pass (imf04.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 3B42F40430
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1782246798; bh=YR60LGaxkOt8ZSGPKed3yDDLoZe4TukhQORz2oIXlfE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=DySyMg74NGDt0oc1UNthON+QQc2FiMKWBqogeDrmCUfQr1UiL0Y1Jbm6n0WKGokSR
	 6jKJ01QEJFnJbQ1NusQOif/D3xDAEC60RD9b9DmlTC73zHbZENj8lFAA8bJ76puK0/
	 bzKCPSyN9bUIehvLNy8Vfp0dO9hopx9Pv96IKw2czw6lCXwr8A/qGliMVbttJZ5S1c
	 0J8t7Hvv4W3XRALoH80xKv30KxNgqOpKcu6TddRupQc54nSEZX2dLVjTEFnoVnExJx
	 zULli7x8dLAfv0ZWrMMMNuypfapZXPpEqJHS58/FkjJbCHOkmbybX4z3wVsuJ+Ms1G
	 FT0d+SYf8kzlw==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 3B42F40430;
	Tue, 23 Jun 2026 20:33:18 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah
 Khan <skhan@linuxfoundation.org>, Matthew Wilcox <willy@infradead.org>,
 Harry Yoo <harry@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs/mm: clarify that we are not looking for LLM
 generated content
In-Reply-To: <1cbdb3a3-b8db-4ae2-aa66-9042c1033745@kernel.org>
References: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
 <d421c081-8686-4d46-8452-e543401b0503@kernel.org>
 <87wlvpct0b.fsf@trenco.lwn.net>
 <1cbdb3a3-b8db-4ae2-aa66-9042c1033745@kernel.org>
Date: Tue, 23 Jun 2026 14:33:17 -0600
Message-ID: <87mrwlatf6.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-HE-Tag: 1782246799-6597
X-HE-Meta: U2FsdGVkX1/zfp0XaSeg3/OKB4vQwZCKD8gSy1UUMhJ37rIcuHTENZqR480CGzBXCaiAMXMO5o2Kip+BCtzI7fvFHouy37oBkkgtHqgyzoZeb+Tp4eSHr2MuCx86ZUZsBYzQ+mSkYB4qMdIplB49gJW0+m2vUL+w/QPFRnRMayZyul4NKJrkxsosvt6tA6gEFelFsoYuMTnnDGAr9SKyykp4H22RVo+rgyaNUiJ7Zsyw2EKAy+y6M7lkhKPN6pfKd0RDeSo/No54NnrQJkWUs5SGX8UC3sKGJkKQ3Mk+taaB/hx+cpWq4HZ0vLeMi6Z/n0RaWGWjOfKtuETNdjaQDttcDueS9I8/y4O4TZZy+/3njdhxG8B14IlBP1frNeYpZfm5o1VfutaC88Bg9BD+pA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

>>> I assume this was not picked up yet? (via documentation or mm tree?)
>> 
>> I had figured Andrew would grab it; I can certainly do so if you'd like.
>
> yes please. I guess I'll soon start grabbing stuff myself. Stay tuned. :)

OK, done.

Let me know how you would like to handle things going forward.  I'm
happy to pick up MM docs changes or to leave them for you, whatever
works best.

Thanks,

jon

