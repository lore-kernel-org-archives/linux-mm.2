Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E6EED3C526
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 03:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7453B6B0006; Tue,  9 Dec 2025 22:45:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6576B0007; Tue,  9 Dec 2025 22:45:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60C1D6B0008; Tue,  9 Dec 2025 22:45:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B40C6B0006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 22:45:37 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F2DA21A036C
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 03:45:36 +0000 (UTC)
X-FDA: 84202171872.02.0CB8150
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3D0E118000F
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 03:45:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=U9x+IGn5;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765338335; a=rsa-sha256;
	cv=none;
	b=dyRayQgyMEiyOwJE156znnGqHd+06HcPNNQCbmkUs+l7+Vkqa/tds1Uqw8p4Xzj3ZBCGbE
	iDucovxc0ErTbzo4YY531goeD2UlzMI6ITUsAtAPSGT5KQS0JFJOYdpGKnmN4BQbwdtR/5
	4nmYMcih2pKp4Cqu6HMuZl/iLZwlRyM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=U9x+IGn5;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765338335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2WfPHKWV90Obax8RTD9RFUwZWIeyEw9VQINnpBPSgNY=;
	b=uh/eougMk34zYvhTrlxLSUR7eQiO69FwDcIAp0sqQSWj7dEdLHx61aeh2lJjxcdWv697BJ
	tfpVCcEHGNulcwRXFZlmW/1ab4BVhhFDxSPNqxf1jfUj4c+a4xow36nDkgsGgu8TwA1s94
	/ioPC7BNV3eo9U60mBhFt5e+Tu2MLkw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=2WfPHKWV90Obax8RTD9RFUwZWIeyEw9VQINnpBPSgNY=; b=U9x+IGn5W1mmlUNCKdY3oBzgfa
	dBvV4S7RUrdrsWiyg6cjobIIlA7KBSKd48cey+QhZfBUFOI1xJWeGg3eEE+Wv2nzR6hmhXF18RNq3
	toSeAB1HLH6+CJ8CqJFsfO4z4aANquDYUslPYCjqwnima/2taQYPUI4ASSlArWfyD6AgcglCOnqfK
	pYXK0w5HWSjcFT89IPdDG9gTAJfDVFPohHoaiOrKz5QgGmEMBzuyEa0BqKEuTE07BkuelHiZOC5Ja
	8gzp+d5SJPrUl7znOgnfXSRb8v4W7h/coLg0SigbuCXRo7JV+MF2oBlQymDBSCFNNJf2wG0rmBudr
	RYNQVnkA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTB8u-0000000CH5R-168S;
	Wed, 10 Dec 2025 03:45:32 +0000
Date: Wed, 10 Dec 2025 03:45:32 +0000
From: Matthew Wilcox <willy@infradead.org>
To: linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>
Subject: Plumbers Memory Management Microconference Tomorrow
Message-ID: <aTjs3EZL_-eAA8nW@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: o4c9jsqu4ybzi976qxhobdun6b5a3cep
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D0E118000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1765338334-240550
X-HE-Meta: U2FsdGVkX1/oZowBawi+c3YNl5pMiyB6sfNPC4NbHAuqCgkMeZ3wfmhPLzw0zC+j0RLYyLpXiv5SHcBUO26jN0goNoYKrMmyKVXeRzWkI9f2hoqdMV6Ptmt44iYBji3VXlBe8jRS2QX3il9p6Ai4nQuaqGjbOKyNzQGSTuiXa/pqoY1WJRmha0ezJ3oB429Q86OIFGEss9c4RbU/fkdgv1MNMG1oVCd1k2aQF3Lp1TGuhbBSKEdjAg1TgYZS6Jj5PYdfDN4JCDagWclfcZ84Egg7ake4dwKva3dDyj17jHrXeEY9SE2pM70FGhjcE0OrMnSdk9+2R65/Zuf+z4Pa0yB9Ydif6x86rquJFpxpYD4vvhDao+mMxOXA1KY3KWqxme6iZQ6s29NA+OTu5nUbVsctyvyvNfaaDyTyuZ14buQdHUaP7ZCXBiUisyG1kWD96ZZG6BRzRr6T8xMvezKFp29sf+O0IlU71QcYtTddZ2LbRa7hsUldkOgU9PqjX6Owl4G6w8BX4ILgL3kQuE2k/wWNkXECn/D3S+8+MM5TqGLnkfaXbhlkkULodgOSgKHBms0t3nJnfuwCu7XXGc/Txcq486NQobiQAr73mcmY1yDuk1HUaXBfQXQJ8akZWm5b4ovtXNG6BiO3HNKQZtoqaa1yJSzLDok7R6ij9Zv+InlvFA8dBvFudtuDAlL37noZgWNeBlQ54I2X7mpguUwRWmHxAV9XkUSGWYlQEoBesRy0EJrpKCAo1+JhqRa/fVviYiVemGlMd75jjfyM3i23+KtFSp257q7lzSb0C3NPHIiES0qnNevs91tuFpz3SQ06sbTWEs0GT2041WdnEBJw68D3O30MX5Z7NmHVeYG7OsxB/7UkzWkonCZMnpsYbVFTf4YOsQJBehDQZyBYunV0i2zNgtm28WnCxgwAf0BnCGO8tW0GD7u29K1KbvGSTs6xUGrNlHQCAXcwAaCMU9Q
 SvUsBYqu
 CA3bGVvv3roAoYcOFFpmXXOaL/ghaBJdBTuaEM/JCOe0x3LnxYTqc5QAbg943SMRoCbkNP0wrLuHb+EWmZyUYgaK3fE7k0U32yO6xA8RSOM6Jx2KRBBZOzEbB/uC7jLmWngdtPN8NYgFIcbazhfKtl3BQRKU2dcK2QhiV/7oBrXR4qDZPGk3nmrSGIZvM4S/20VYNTeTz2DUJmSe6/mdCkySHG+3LaCn7IB2zh5wGKp1vEWU2Ow4qz+h07mvIonyXszrsZw1PRD63wQaA63MXJSLy9napW0Iw7qBMZCnXubiOrIA/U2u3K8TYrYh5f2n25qKffXBe4N3MS/A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!  David Hildenbrand & I are co-hosting the Kernel Memory
Management MC at Plumbers tomorrow.  While in-person attendance
is full, you can still register to attend virtually at
https://lpc.events/event/19/page/245-attend

The schedule is available here:
https://lpc.events/event/19/sessions/222/#20251211
The conference is being held in Tokyo so make sure the times on the
schedule work for you; 15:00 Tokyo time is 7am in Paris, 6am in London,
1am in New York, and 10pm in Los Angeles.



