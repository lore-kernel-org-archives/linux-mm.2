Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE1A7606A336
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 045316B05B1; Mon, 23 Nov 2026 12:15:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F38B06B05B2; Mon, 23 Nov 2026 12:15:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4E8C6B05B4; Mon, 23 Nov 2026 12:15:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF1046B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:15:43 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D79E160959
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:15:43 +0000 (UTC)
X-FDA: 85467035766.10.F6E0F5D
Received: from mail-10631.protonmail.ch (mail-10631.protonmail.ch [79.135.106.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 67BDD2000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:15:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=proton.me header.s=25dmbq7bpzavbgtopbw5vfp47y.protonmail2 header.b=JlbDNWdm;
	dmarc=pass (policy=quarantine) header.from=proton.me;
	spf=pass (imf31.hostedemail.com: domain of dockseed@proton.me designates 79.135.106.31 as permitted sender) smtp.mailfrom=dockseed@proton.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795454141;
	b=FqQZwVsnugrtkbHoCbPAMbiE369D+P16lP3xY0NwE36evQhqjT9ZXvrF2l9mQZOEdrQ95P
	t47Y9Uv4Dd6rT1rQ1kOE7+rSTONCAb32HfayqawOZoMVGmFtw6QE28tTAr/qPkei8HS3rd
	BHKQ+wC8V1ZzNMMJ4m5J5GovAodelxI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795454141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PITGhazHaoDO3YT2izy4iM0YntQzWkgZ3YK2dN09pI8=;
	b=fiC0fzICrzhvXjRyvWyMHmTNwhWikm+ld7DGn8SgK99F83Q7Y0nq5fd1cLW8wqDN0CRYVa
	WRYsYd9L2JB/C34ButJejC9Gd9J5f+YJuPQtl9bjnH7/tZ+KZGbuN+0mEkIA74G1aODhFZ
	WV0WzlHQDKgbBh9e05L221SfYiqSVN4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=proton.me header.s=25dmbq7bpzavbgtopbw5vfp47y.protonmail2 header.b=JlbDNWdm;
	dmarc=pass (policy=quarantine) header.from=proton.me;
	spf=pass (imf31.hostedemail.com: domain of dockseed@proton.me designates 79.135.106.31 as permitted sender) smtp.mailfrom=dockseed@proton.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=25dmbq7bpzavbgtopbw5vfp47y.protonmail2; t=1795454139;
	x=1795713339; bh=PITGhazHaoDO3YT2izy4iM0YntQzWkgZ3YK2dN09pI8=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=JlbDNWdmFWeHXQweISJrRAStoF26zZx24VC/WvCYGp6luquvjei8uvOkB/bxV43W/
	 WvX9uVHN3zo8CugONqtQts7C6ryarGVRaX6ksEArqGrZak/YmcYbh7/QHLCmchFWOG
	 yrKzw09rAdzWxbj9jyeUX8WeTSy0O+bGFzdap/2ATcbR7jxWpe5KVSdlmfgM5PNJk+
	 vJbmZ49x6I7d7Xp69W8FEO1ULZE3skfhtxwkQFRymElDul/ZxaoGTQ367ekaVji5/H
	 Ed/io1T9WzCmTf8akCaNPg0Il8RJYZQLStN8MuRfnCC1Ms5/zX3+27guGrK8SwGepa
	 Silp7YAtKFI9A==
Date: Mon, 23 Nov 2026 17:15:28 +0000
To: Mike Rapoport <rppt@kernel.org>
From: Norman Herms <dockseed@proton.me>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: mm/memtest: the reserved-region array is reallocated inside the range under test
Message-ID: <vMVJLf0yL6RHmJWxcxQ7lNvjqBtYE1RxWk6wBUnmhLH5gDbJc1d_b0q5AA6Nz6VJcnNkIw8gStVV925IyeYEvNYiiIChUiaYhMRao8V8zps=@proton.me>
Feedback-ID: 144388465:user:proton
X-Pm-Message-ID: b6844be21a8c1d299c6de324ff64d0d3244400aa
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 67BDD2000A
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: arydszoce1ass6aeiw6udpkew1di7bxn
X-HE-Tag: 1795454141-157221
X-HE-Meta: U2FsdGVkX1/Pl6n3EhaBF7DdtXJudhWVBDC0T8LoCqcNUVVQaO0Fs9iW8CPBw4uMJKvgTWQYq238Gv+v7/pDO/nr5XsBYMW7mhWPLMjFcryHy34ERPulx2sysAeY2O945yeSRl8GM1ZUEJsy6U9rKpk1AU2SExCXWJwN7dcWUAStFTHeLtov/2BaB3XylRFdcWJ5iSsC2LhGOHHQt8vZuEu22sp22ItFVrbzmnuN+gx4PsE7yLAaxfnysQ4e11x+H3FoDVdLi+OUYBXAPcCmSBc64eo5WzgztjMzYXyy86CpVK3L0PwhEElUAVMz7H5mglBMuYMy4RjFTQt5PRK63DO8XLjBJVpQENBA3ONJKUQsdPASVubxNmM2HWbnuX1DhhHdecqiMHGbWw8kLl0/e7n5LfgOEb4bMqt+l2UjBUv3eZgIVopMaMkVkEcT20ekDsYd1bli04OSJCAWQTp2py20HM+L9sWwkWDB15guVv0EFid1P+V3v68wOOBa9hk2tpQkAl5LFY68QcEGAyO79mYxrN+1iGLbtxJvTka5v31Z8ORYvuzUHUGwbtVqDdZO7wK9BF6ovlhibQpv6EvyE1MC39HeCtrLvfYp7AfwQSjQ2L/npoTfJrd+og7SADpo4Lv7NzGSefvgmhw0cMcKs6+Unq2JVISPVISXiRX7bv0RYrm2HugyWOxg6yrrlR+XQMXt4mhTF6becL8bkHI4VFWRc/4z43fnI7yvZlo7L10iCF7T29K76j/xkP6zagvW9iorjhVkEEPk4lj5Zxhb1pdvlOeOM3wJMMmiuJqkF35D4DUZDHfUSi0UABE28DSYzOpOEkUAHm1dVHqRyFlx/qnRv6xfzDArRUCYzQI83UI9Vtj/Mb2L54OWhpRi8ATJOiFc90Fu0FXsef3k3yRDw8G6TMz0kbeuhNFQ1WDbecdF27ssslQ9T5XnW4tDoB5qoX69BVGVE4p6Gmqt9ka
 clU4LcNs
 yeznMDQ4OWRRkJe1Uz8O7VOp2Qb5kdy/aqGzrlA4bh89vWouiHNuOwIEZRqcFBvoz58eAbnqFOoliwNzGXuh0S9f+Mu4TqPi3CJR/oWRJakq2VP+7avR2Q7MV90YoziYaDUBtZf64JqUKsL+ub0Opx83cmP63up3cnC3yDafrgq7cObCp8QUXwmNeTwVAaylHhuNcjbIUBv/ekxQEuvQhp8Mq6iA0FlVCghLqOP51d1cS5oy6Q88yA74VhbHEZxz2tgTNg9AGopHt6yQF65u4x0p27AHyX83NMdaNRdN13YIIfQFoM+rwDGGHEl+3wL4IGI/7/bSvNokRKGAS3TSjQ8V1nuls0AIgdK+kj6vFEoB6jLT6Og7PKKVKi9Z/S46v9mMSfAcaHNDv7GfHL5sf0LdfWSCsy8678aljdkCKPpP5/khye4/15yqhPrD6QRa2dAbQOa0dU7eT+406+TvSj0KZxmcdPXnFeetSnWwkKbFj+0cYXscHo09cBnOUkIPxbRCa8Ouq/W1tChi5lyDk4WDTwxF7NnoDsdsOnWrI8A1FIOr2aOzV1tr8lDHRQfDeIAnIX8ZrBmNkwa147h6O7OE55ZnwVV7lgxdNd6YSA2i22s0ZrNmx9E0kyR4yMxVgKoneV7V8Og33azjSAA1ihfBAmhfI2qNUOC7XN9LZd0w980g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mike,

On a board whose DRAM fails one word in every 256 bytes, memtest()
reserves every failing word on its own, 512 reservations over 1.6 MiB.
Past the 128 static entries, memblock_double_array() allocates the new
reserved array from free memory inside the range memtest() is still
reading back, and the array's own entries then fail the compare:
another 42 KiB at the top of RAM (0x1bf3c2000-0x1bf3cc800 here, inside
the tested range 0x60100000-0x1bf3cd040) is reserved as bad, in runs
of 16 bytes every 24 bytes, the size of struct memblock_region.

With memtest=3D4 the next pattern is written over the live array, and
the board resets during that pattern; we have not separated that from
a 16 s boot watchdog.

Coalescing nearby bad words, or reserving only after a range's verify
pass, would avoid it. Seen on 6.18.54 (arm64, Allwinner A733, 6 GiB);
mm/memtest.c is unchanged in linux-next.

Measured on my board by AI agents, analysis with an AI assistant;
a report, not a Tested-by.

Norman


