Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8654C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBB546B00B1; Mon,  3 Aug 2026 09:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91F26B00B2; Mon,  3 Aug 2026 09:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA82D6B00B7; Mon,  3 Aug 2026 09:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 986766B00B1
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:32:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9450B406A3
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:04:44 +0000 (UTC)
X-FDA: 85059675288.10.D60BD9C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id EBE8980005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:04:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SbnvzZMl;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785755082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eljn8Ny6rhPTzrLYH+abslck/G8K3E0nYOeGDjQhH0s=;
	b=J4vaThPa9YS33qywUI7zR8DAumaxMGq8sqB3RUsUgk8qCqBN9Uepr5RLc7HiqtGkIJudPO
	DgPR2pZhwQwkFlXvzHw3mnSPC/JclgmoOJ2Z9cEP9iVbkWETPyg8DwfW/xOIM8Lo0QamXB
	mNnq2IJr8y5RHh8fhLUA4ULqlHvd6rs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785755082;
	b=EBCGDnUSGDt8zT7X3SKzWIDuTuV1wbuNVwyJTDbzZMdhik9A5B1860WPaZPrmroysyRCyO
	B6zBb5W6QqiotBYQT5R1v59xK7ylIMB48AZNqKJ06112NJtyOVHC6zC8HZoH/PZcmS5c90
	vnXG8lgfE8gioZDr1xaDlci15/eYvfM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SbnvzZMl;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78BA160A84;
	Mon,  3 Aug 2026 11:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6591F00A3A;
	Mon,  3 Aug 2026 11:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785755082;
	bh=Eljn8Ny6rhPTzrLYH+abslck/G8K3E0nYOeGDjQhH0s=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=SbnvzZMlM/voSC7+sBfc7otUzGuJs5uZzzFTrVXzuurPl1aDwibu4lf+ckuMsBoHu
	 z3zd8CsNBXdKp83z/0oGh6x2tuGeO9ZyWyT2LmgH7d5vkBov167h1XwmHYyoRbkAce
	 aPYiQd8Mh097JYBn1YrVEmVe/KOmpd37QeZ5VJu+Y30XkltL5iO1zFHZ59I5EkCK5W
	 SitiSkw/jA1JlJeGPikvUrKqZgqtUrrl7fP+8K4Rji0525a6ZPrzKd1sO3qMDvpm1X
	 7gelXVBLkh+wS2A2lbDkftGdUYiLEi/BmKS7QJ9J8s/RlA1BEKn3kQwCTqcTrXzdgG
	 YG5How9yhG9tQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 01/16] selftests/mm: move is_backed_by_folio() into
 vm_util
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
In-Reply-To: <20260802195254.1937477-2-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
 <20260802195254.1937477-2-kirill@shutemov.name>
Date: Mon, 03 Aug 2026 14:04:23 +0300
Message-Id: <178575506323.1561566.15724813374821403024.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EBE8980005
X-Stat-Signature: 89tptji4c3dy7etfjpbj7piwmcwg5ub4
X-Rspam-User: 
X-HE-Tag: 1785755082-509619
X-HE-Meta: U2FsdGVkX1//c+iSlhDw07jKtmTIW/5NxlGTbMTFbAa6lPbkNXILQqeiCCMdH/OI63dSf2PYfEmF1gzdlKdrv8n4b+EmuvDbRlWiK2/7lxgSBUMq16TUPLVxRatZqpS4avO7an0eIoi04vpVLObsm8fw9Ca+c2DSctyNbAle7SdznOVRmZnYchzEtjBSHlKbWfex7L/u1B4nR6MHb1YcaTYvTMOmloNUA48GA217dl9RolAVflAHN4n20vHBe2G1o+YEvlZlk+6c7kJgIaskU/o0IyQDIaybkzR4oQSTUtSSvE2YG7+zVeyhHZBPNKt/WpeH1HTrjgbhVzkVazy68JGanF+W/lepXoWJ0huMmHs7+ifJ86njaB053Jvl70DPENm0Qu7BS6Kv/QAmZHnFeGJnrtV7bcVvEjNUcoEfjHBNsuosOxj59yQI8KqWMVrkaNj+eRqMxCXnHSv6QoZ7osFRP5TcjuVA4ME4MYemdk/WEm/sXMKwkhiO6R6kwfRTGJwIPMCl/JXGLHLSbYStyMRoL8TIctgAX7/bDmUwnvPul05U9pAUKb/nrzkGokhvHu3q1QioAJVrlZ1Rm4WdqpXMV3mlHk35spsxmO7WJurQhu6e68QqWOPWTW4OobaJlHmrY5StyhmBW4lzhmKr5pIrlSulQaKRidGm18EiRnFGcxezfKkqpD1aksuOQd4XmVhs30TU8p3Sx5B/zEe1b4jjHMLLIm5pteoIcdl4Vq/q8rSmwK/+rC4EPzT3vpnK96NkUYxq4G1TEwYujrqV5LMcbYARgxM4CudUsa+PoIG/GB7K1WE9fzU2jtblKgneILT4K1L1bgZ6psIIp0tzGNl1RuC9sRSQDFu8zzVyfiPzFYzN0Nem52CAnmyiEOycowlw4tcREu8pz0AA7Sd5XVdymzQapKSZUQwPcoj2q3U4wzEfy2hRa1bxeNaO5XMU+bPOyKrTJmNrj4Z1z9b
 KeevR3e+
 VwO9lDsFw8z+TSZz3eMwzr5sbRRogXdEE2T/R6Ei10BhJMHW/bhemWIT0CWsntyy8kvKrXBmuFfRIhmbrOUcmamdprau/O/HK0n61YJjKXSdO86OPbkTBQPCIGLfXW4FeB3qWsUiN3M8idJ8nEj/41om9iZPFEkurjjRpeYddwRkwshZ8EFwgilqTYoYj09aQlRvxL3tw6Et+x9QRtDCd9W/fBmQnvoTgn88rBVypjgHmJYagOC8lkdGdDWAWv8zXOc/jYvTQ1nPag9EiFT8Rxc6C4YVwRKasJuSLhnbUJGIOyuMgXMyjcYPyAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 02 Aug 2026 20:52:33 +0100, Kiryl Shutsemau <kirill@shutemov.name> wrote:
> The khugepaged selftest is about to gain mTHP collapse coverage, which
> needs to verify that a VA range is backed by a folio of a given order.
> split_huge_page_test.c already has the building block for that:
> is_backed_by_folio() classifies the folio backing a page via
> /proc/kpageflags compound head/tail flags.
> 
> Move it into vm_util so other tests can use it. No functional change.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


