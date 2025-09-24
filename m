Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41633CAC5A7
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 08:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 695008E0002; Wed, 24 Sep 2025 04:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66E628E0001; Wed, 24 Sep 2025 04:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A99F8E0002; Wed, 24 Sep 2025 04:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41EE88E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:50:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8CEECBB459
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:50:12 +0000 (UTC)
X-FDA: 83923521864.15.C67A4F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1EC5F1A000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:50:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758703811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J4cKTSeea7/czdVYO122nuGfInlG59hXiu0r7c4Sres=;
	b=QzoQB/WcF2DHZQ2WOUH9d1QeNlgZ5uoK2YebdL7Gn8GqzcRv3qbzRuF7djVWoTFZ/Q1cMg
	aYt5fHLgL40wtHgHTcjtrc/8fUh5bJgrdeiWej9KcAJxTz62bbFOvv9AkTIjg3lbqcaqLd
	aIAsSOMPdgSXNWq+tPBim+dIwCsmPOk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758703811; a=rsa-sha256;
	cv=none;
	b=ToXmGgISLWp+KvmY8vEnHQ4U96w/62u8L11HSt+eArodArmUjpN7dQoCx8w41swgWhRHky
	a0RSZQtSNpvTTYJK7Zxh+OHl2BDuYVx9RKSl05prk1jurd1vL4LPx0C4rIGz1xmcJu6nfO
	HyxPIDuWW5Gl7a/O5+NzucdyXy3ynAY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91B4643CCC;
	Wed, 24 Sep 2025 08:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E087DC4CEE7;
	Wed, 24 Sep 2025 08:50:02 +0000 (UTC)
Date: Wed, 24 Sep 2025 09:50:00 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, usamaarif642@gmail.com,
	yuzhao@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	baohua@kernel.org, voidice@gmail.com, Liam.Howlett@oracle.com,
	cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
	kaleshsingh@google.com, npache@redhat.com, riel@surriel.com,
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com,
	dev.jain@arm.com, ryncsn@gmail.com, shakeel.butt@linux.dev,
	surenb@google.com, hughd@google.com, willy@infradead.org,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, qun-wei.lin@mediatek.com,
	Andrew.Yang@mediatek.com, casper.li@mediatek.com,
	chinwen.chang@mediatek.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-mm@kvack.org, ioworker0@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
Message-ID: <aNOwuKmbAaMaEMb7@arm.com>
References: <20250922021458.68123-1-lance.yang@linux.dev>
 <aNGGUXLCn_bWlne5@arm.com>
 <a3412715-6d9d-4809-9588-ba08da450d16@redhat.com>
 <aNKJ5glToE4hMhWA@arm.com>
 <aNLHexcNI53HQ46A@arm.com>
 <f2fe9c01-2a8d-4de9-abd5-dbb86d15a37b@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2fe9c01-2a8d-4de9-abd5-dbb86d15a37b@linux.dev>
X-Rspamd-Queue-Id: 1EC5F1A000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: hdp7nfya8a3jjcfstxjz3ez9w9hqtexi
X-HE-Tag: 1758703810-420660
X-HE-Meta: U2FsdGVkX1/Fgmyodmfd4MtoedAmpAXaQZYu/qQnGSg2BPqYms1IYlIwGYUqMU83ZlFVxpEOYF4iKTgNbibipiIsVD3uax+ba1jiE7GXIUDwJi5Xw0Eap+wpgy24uboLAk/5SNBzvBezrX2Hwh+RKjsSIrWN0icgx0HqQS4wMJZ5jrB4tJjzvR1AKJ9K/KmlN0XrwzMKTNV+KNKISesfH5VBnASwGPfC2sGw7C98sqBNR7IW/DnuP/bKeC42RIr7BWfsXMiOlpMgsx3VZ2BClfhvkakTlxgFs9oA4uIUjtjlxS0XPc0/3WwlMH79ryYp9is6VkyFFmUkIa9jONa0zo9sP59hpn+VNxKlaHOXqWPghmYNR3815zv5YqfWAHeKOhSSv7Pxq2arpyp/NyjyeL1KTUaKkQ8M/+qo3dE4RcXlr6b3VdhXlKRnfMUjwnr0JCPm4bkYHQYOTIaKELlAf5qrpISVbQNtt2fRy8w9GnfQpjsClGgFPmZDHb6WZK+Uz65gHu9lLTN1ZRFhbBcymA3H7bVXcLwcptqHspeSDD24+KLf0wfkD80/CmMluWa5Lgweqh/m4XLviKp1dp0Dh9LxU77cD0Y7gUxOP5puyI0h3ezEdPqXarUrSuYPqOnAbK7MQpFgMlA1NQ9eDR+AzwzG8kFX+Ql9+7fu8Gp7fWyJI/oDy1e7xN3dY74Xj431gQVtRXkpI/fnxHvxWToGOSIUo3idsX3CCEFLV/Qds1ScxP0W/c+xDMm8agGijYVEej5YMzZgk9D0qOX16OKqPWxe1JCTEodPSmrloevWlCT7NpKSZhs2p8DVKm+k6nq8685vfohyXpaMm/4Vt56MHyw0s2gKINtw+U7l01yjcKcIEu6Xuyst8+EhEn2ZBn8Eie8swFKmzu+xR7qNGUe6VdvMvILJoVYaXs8dNAzvs0wTAaDk64MFVxEYlU4IOTAdV0Gvpg7iPwE1dvUk2G9
 zngqVoSg
 hE11YsrqXVYFmGgT4dwNOYwsYMiXxPautNzOE/ck1FYlZKgI5kM0bjugubNdysCdOlLNoLwy6GwPmSX6OYakcv4iKTdh9+FPV53Pg33EMpSuRvCMjrx5Ow+Ra3X6SItvDsBOUtkSyM+tUdXs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 10:49:27AM +0800, Lance Yang wrote:
> On 2025/9/24 00:14, Catalin Marinas wrote:
> > So alternative patch that also fixes the deferred struct page init (on
> > the assumptions that the zero page is always mapped as pte_special():
> 
> I can confirm that this alternative patch also works correctly; my tests
> for MTE all pass ;)

Thanks Lance for testing. I'll post one of the variants today.

> This looks like a better fix since it solves the boot hang issue too.

In principle, yes, until I tracked down why I changed it in the first
place - 68d54ceeec0e ("arm64: mte: Allow PTRACE_PEEKMTETAGS access to
the zero page"). ptrace() can read tags from PROT_MTE mappings and we
want to allow reading zeroes as well if the page points to the zero
page. Not flagging the page as PG_mte_tagged caused issues.

I can change the logic in the ptrace() code, I just need to figure out
what happens to the huge zero page. Ideally we should treat both in the
same way but, AFAICT, we don't use pmd_mkspecial() on the huge zero
page, so it gets flagged with PG_mte_tagged.

If I go with the first fix for the page merging, I'll look to defer the
zero page initialisation post page_alloc_init_late() in a separate
patch.

-- 
Catalin

