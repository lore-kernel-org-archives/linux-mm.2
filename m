Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3182C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552196B00D5; Thu,  3 Sep 2026 03:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529216B00D6; Thu,  3 Sep 2026 03:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467296B00D8; Thu,  3 Sep 2026 03:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25D216B00D5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:07:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8151B1C217A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:07:20 +0000 (UTC)
X-FDA: 85171569840.13.F320E74
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9EF764000A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:07:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=i93Q2PRU;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf12.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 54.206.16.166 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788419238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5X/G8cC7xn3LThCq50XdcwHXgoSMXjJw2BNtxxdYJK8=;
	b=BKN5tLi/D+EWS5Nldg9V6ODXWbrKXc0oOiLrc8+CMtX2Vah9u05EBLxD1aY6vcSylzzl60
	tiyw0UaysUQci64gEXx1ZFYdds2ISO097w52QFGIimcswKp+MB7ZwZzJa6WAI8QApbZ4hP
	wPTGgIXTN+7eKVWo75VbY4PBCPD3NoE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=i93Q2PRU;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf12.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 54.206.16.166 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788419238;
	b=QdKpvtcdsQmD5GH7H8IdFWf7qys6q/VfveFsHj1LlgWTch48qgzOBAk2o1ZWTk44NnDE38
	oUMyZ5zwWAXcO07LnwaEHDjpui8rb0K5v2z0rUUfoIxh6fiScmx6FCq6XAy6iC33hy/QJB
	n11IZ+FE48r44gAPpSxHv7pE2Bv2B98=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1788419178;
	bh=5X/G8cC7xn3LThCq50XdcwHXgoSMXjJw2BNtxxdYJK8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=i93Q2PRUr2OXOIMxuJkZYPrpuePLpwsNc1lVsi57uR6OREPQraMWQvPjGnaZWQAnj
	 F0Wa6Q6gdscii2Ngwnag5ULVnTVJu46c0Oo9HJ3CzIVM2T9CkRybjW+R3Zk+uTrdfb
	 q8B1a1B2tnZiDe/rjAwgDsuCCbige5HF4DCPDeaw=
X-QQ-mid: esmtpsz11t1788419175t66410874
X-QQ-Originating-IP: fK1jJDR2jE6E2FlSQAB+yzADaIPHcWLn0p/+0K49yB0=
Received: from zzz-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 03 Sep 2026 15:06:06 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3964727102774129270
From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
To: Mike Kaplinskiy <mike@recall.ai>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: [BUG/RFC] mm/madvise: MADV_WILLNEED skips swapped file-backed COW pages
Date: Thu,  3 Sep 2026 15:05:22 +0800
Message-ID: <55D30905BB95B9F8+20260903070523.2032364-1-zhaozhengzhuo@uniontech.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com>
References: <CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: Ns4o82esMDegoCihx5CVKsK8TgcpNv5HGt6nZ8j4Nc1rhjcUn1fqodTp
	K/I2ivI3g7fxGKOC5NRrKMcBI1FMp2VrIMSOzJ2AO/hzRGP7V5fDYH6J5kAaGwBNvAHe7Bg
	D6mtXMyesAdF/9YQHVIuA0CfEkPpi4TS5/lqMCoTRUCEOritJTdsiK0pI+Q9pHNvHsd+2dB
	1QFcavf6wIbpx9bww/NJr1ldMAoNYoVgJx+ywvBEXLilZ46Za72/IWZPTrD9bj9D7mX+Hs9
	OAB42TObef0HEOQYmMQ4cywIjKpx6MtL7g0skMAToLnmcWpL9Xg0sytOkwyocru7AkBJxwh
	7n/U9ryTNdES3ZIo4tTCk44WHrzIh8eCn03YDkEiZWg6E3R5mhFUoA+IZ7sV77S8PuqrlOF
	30nII/P5tabjORMifm1ZxXQ/dzKYmwvOIHCK5GnGBkkDAvpOS6BUzu7r4up51Tvji8bes77
	0xkJ4xcGiTmJihUVQxIzSMoOWw1cOBxxtYQ5Gin3cJnSl4ErFf6iZUngPWloSOJZnnTTYvA
	Ii2H43/jwhC8xOYxOuQ+YIHEKDbUKVQPKs1WFcPvt70Lm73KOGveAh1J5aRTjH5sV97B3Ww
	qcWkBq+nAcQPMhUEbiak4uRPGQsUS1a8PlpvvOBmiXS7/qowF8wmrl6e67dzKkRr+pzxci8
	1xSAWeLFRkWdRhY3uM4lXshv6355EL1BslbtlOwdgZAlrsq9z4QISa+o2E8vCD2138t28Sl
	JJ8eRGODhd/E6Kuy4Nxbn/RgkQEzDy3L5ODfW/LZ4iidDBPMXwcjQxF6U0h/dVEsKhipzEh
	BnmYUWBWVDhN4FDzURc2uKAbwx9ntD2CWm+RXX1+aZHDD+ukkjX6z7ZePhdKIyfljq+H5iL
	mLCYtolFc1hVU98+l+2CZO5roqjPRta+H/VoEoz0DLCGOm9PTv8AoLQXLBqnXacSuCLoBi2
	tmFA3Do8Ee7FccWwAyuC9fx7sdHEKCoL6dQoaLXLGKC6TBofQaAYpnJn5K1J4MF3vJqRG96
	F+A+SH28X9oIQg7JGPqW8eNSRRNPWkxNfQAvhxjg==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9EF764000A
X-Stat-Signature: 564ro8deq33aokeaeg7s11roeuppyfor
X-Rspam-User: 
X-HE-Tag: 1788419236-913067
X-HE-Meta: U2FsdGVkX18t+vvuopVqfxfi6aWUUKdVKSaWApGdelhnd1NQRptZxTz0U60AEt9RbmQEv5+BzpNHkDno+FxJe8X/KtyOX7JC0Ef9ImEIHxhn3RfNusYF9mr5FM35WmAZKNT9oJKER5TWPcdYwUGgBYxRMPVT6yJSlMP7GM2XkClFeiT770M0ePqOWupj8ON1XYt9rVoNxZG8wBbzgDKMk4GGVs6XuOJ62hQRQGLitgeZQF9j3Pp2lOMEANwar/anFSAzJ+tQQI4PYpq8qEujE0peOVf64E5I8MXyMHrwfKeWX6RxVqvDBraAs1vIepfJsDQfsFbf572M1q4AJAbCFfm8UX/DaM92By3B5747PzNNDt16lUUpWdrmQlb6aO5C6IZ9s1rHlZ3FFpkZ3LAbTWmh3fQXiHoohvqDSYN/UeYVekOjXuFj3Mn0CatY+MQ+H1+piE52J+SeA42QEhD3JtzKTYmgeZIvZRk7V6PHsSKBXIq6qJLKk3CiMIB9FNSSR6yxQeHrXsdqYCiGu3rwzPoGALiEKaN1N5WpaRKRINgfbuK5BJ1MiBUce7wdPVuW705ZdRIYdC+y5ihts0er411+cV9UpPuZ5sSVC97YmuL2tKt+MSSExsHYhOvSs11oUXA8dnuLg+blvYQEUbmJRkkMqeEWmyTX87NQym3AWz6PZDOH5Inpjqz/cEKDvcsGElQQ4ZO7eAPtxqCT8hd9gUBXb556KRsrG5KLU86TEzcWg0wEVf+u4MLfEQ0ycmmMJYtcOUnE0cTkjysrDmrEKVLRlR32zUmyWucjexg3V96Woij8SmesMosDfgF36jZRails3tLwKaCaJuA+uaXaVA6vLkEJ9RlGZgpQ8gfE69pvYBgzivk3pMsVfRNT2yrENHE70vWQYnj0hmfmJy1lXvaBw49TpQ410OlZtTNmStJ8NxBjQhcuUK9JBBxKTAo7L45+PhxiRXAK3LjMIsF
 7PrCFnR8
 be5M3+yTT3lQfjO9KbWHVpt7ZuzQDebIQFpmE94YRxlzDuwhd1h3ou0cMPZAAKnEu8NGZpEllIjwlqFERlFIT2766mVIIwfHHs5swKu8UN5qAk2Kuz+nLfj1OhbrVXNSDOTrN2r6vFJhsNx8LoITZnjvTS8xpVOIpbSw2yw2w5uGLVWeO8R27yp1tnjNfhPGSKTIHFJOZsoPVSt5itxmuFQ7W+tbv9jI1mnHsTHGMG47uGFJuSbtcxws9yHMp6c0s2PxGgba3FnazuMqOWsCQEr/RlBPST5gtMtX0Dphquk/XO9SJLNtxkvthheVXenRusuqmmfDrMfpZIO4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

Thanks for the report. I reproduced this on x86-64 with the current
mm-unstable tree at:

  e3b5239afe1b ("mm: gup: cleanup the gup_fast_*() call chain")

The test used a 64 MiB ordinary file-backed MAP_PRIVATE mapping and
disk-backed swap. Since the test machine has 128 GiB of RAM, the pages
initially remained in swap cache after MADV_PAGEOUT. I therefore added
controlled memory pressure between MADV_PAGEOUT and MADV_WILLNEED so
that the swap-cache folios were actually reclaimed.

Across three runs, the pswpin deltas (in 4 KiB pages) were:

                        run 1     run 2     run 3
  after MADV_WILLNEED       2         0         0
  during subsequent touch 16327     15811     15676

The mapping still reported about 64 MiB in Swap after MADV_WILLNEED,
and almost all swap reads occurred only when the pages were touched.

This appears to confirm that madvise_willneed() skips the private swap
entries because the VMA still has vm_file and therefore takes the file
readahead path. vfs_fadvise(POSIX_FADV_WILLNEED) can prefetch the
underlying file contents, but not the modified private contents stored
in swap.

Are you already working on a fix? If testing or other help would be
useful, I would be happy to help.

Thanks,
zhaozhengzhuo

