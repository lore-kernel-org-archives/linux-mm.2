Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5939CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 13:04:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A43D16B0088; Fri, 19 Jun 2026 09:04:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3A66B008A; Fri, 19 Jun 2026 09:04:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90BAE6B008C; Fri, 19 Jun 2026 09:04:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B4B36B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 09:04:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B787C1C220B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:04:56 +0000 (UTC)
X-FDA: 84896682192.14.16BBFA4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id B2A62140014
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:04:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lQUOPpbA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781874295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uvTg08fHdCJ2zWVngIJfipizxXJP2af00IlPHh9eNhU=;
	b=3wBNZJys76Ea+Y6ixh0hZqce0p0Yr/hOhDB7AgORaTiKbIzuXXZcN8FRnxMPpzwhNu+snH
	FmW1HqL4kJA5xlSwxYTcQ03uFvQGh/7JvC7LdqljSGStDU557OyziO3RQm1JiXjlK8BArS
	AnayGuiZCQo9TLM6u+AHz8uwDbKnqpE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lQUOPpbA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781874295;
	b=4emMdVPuFADkhGw7ai9K0spgUEkDqR5peBRBbqIMXE/T3QcCdTbDF1Sc0VRTPRwefYOsGj
	5NTeDLmZObNqOwm1fWqq+gSagqo0V6y5IeZMXe5OcKCSFA5HCo/dJGZbrzX8YTDWCFqfbI
	5P9QImGksUPBhIb+yB8GVPxEL689oVY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E85D24A92;
	Fri, 19 Jun 2026 06:04:48 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E4AD3F763;
	Fri, 19 Jun 2026 06:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781874293; bh=e9pfEYbv59UVNvg5pd3j1Yh0i55qXWOlAw6aQXf2fiI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lQUOPpbAmN6Zr1EYJgextc9Lnki8Ehn68EA514fFROJG93hMv4r2Cfa/r8NEkWg3n
	 w7/Zq2/WnP0TUUTs/hsA6wrxV4sm6R2stNIFSF+9iXhA2oqOiIZLzOIr6XQovIdoEu
	 /E9iWQPaERn1E4Z9+FmbsevKh/DyS57CcpVOvJzY=
Date: Fri, 19 Jun 2026 14:04:47 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Harry Yoo <harry@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, ryabinin.a.a@gmail.com,
	akpm@linux-foundation.org, corbet@lwn.net, glider@google.com,
	andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, kaleshsingh@google.com,
	21cnbao@gmail.com, david@kernel.org, will@kernel.org
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at
 allocation time
Message-ID: <ajU-b32dmwS7XOg4@arm.com>
References: <20260612044425.763060-1-dev.jain@arm.com>
 <b1502a60-09a1-4699-886b-93d041de7023@kernel.org>
 <2a7d21fa-28c1-446c-97f5-2513f29157d3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a7d21fa-28c1-446c-97f5-2513f29157d3@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B2A62140014
X-Stat-Signature: 5fg9s9uyfeyjqfogtwby7jbejq6x1upq
X-Rspam-User: 
X-HE-Tag: 1781874294-572965
X-HE-Meta: U2FsdGVkX18LJGvuKkxbnoYROgZHUVNYlYxsR46hgY+vRZhOaUymgjZJ42sgpimFoxLwMsQrzFrh/VVsQYrVzUsgNz7LTuRzbnWg21mjR4tWOGTcHHmhxgIZivaCcoXp4Z3lcv6IZrIPpRgJZUfDlfKMkRGrHu3AgzPumC1PB0TTzwoE++Dx3zh+8uzoAtY3kVBQ0JD+7Kkxq2jjPxjPZglEWqmVrQscH4sGiaPT0dyJJ3xOxp0VC/1UuudbboxM573KyVPuXcUdzK1s9CxzmJkWktm4UHlFPmniK4AJfP7ewongv+az6etDyWVEQd0h3IL2nP+LzQm1K5JJ0Qtmul3TlxqSkXnDY26Zt6xRzrdOC+laOv0q5aGh++wTcCSnCSTcBiKJkGri041i6z+VxSlx5fpI5KuDp/bGRprqJX7GtUhWXIrShD3MQb68J9KnT4aggNv/YLPu20PBCA1oEl3FhcVpWM7GaH7uNmDvSceG98iO08zEczDkxnUbSYyet5uSG8qBwcWas1lRLz4ncZm7QZ1vvYbQqdyy14eu9SJVxilZJjrM4/qF3KPYqwloW0x1x3sbxnbwzSG+hMAQlJkMt0czcPqq/kCLf/WuAccQEqxr4MQ5d9HPq5BD1jNub2A6uq9amQvpV2GCaHS+800dU1RGjLDh9dDGJ3zRKOc9U1Pey3j4+xMc3QvAbBvx3y3OCII1rCsNNSdD25FVZRG2/XCodO/ABh+b4not4FpnivDYf5yws8zQFASRNufWSGLCxJkCI/FNYFuEcSRYkJFAndBMzAZ5mNRxD0GpR21lSSf0vMkrmHvsLloCiOTdyyujjsRq3zAbrEpal9UGx+obnrsSNtprU5rf0UM+nR3vIRwpAkR17MaAt0U2a8aLG52vuacI8SROy1EbNLxHtumncaXuosR7PjfocU3L+G7pO4i572DyoyK8WOC19WqYz7lOqCKDh2Cb1uF9JiX
 Lyt/Ly/C
 qo/VN7pD7d0BTIcW7xflZtS84P2mkHJBBp3XYk+mdFQZYiPihc8nmSf/QZ5Z9/LSRKU6RCUIbT36mgweGYyZvTJuO5zsKbQeJc0gXKeWoDpZ1abpjXzp9yJFDhZL+0bGoZnO1o7QtZAdOjk2rybNsxywIRm39+6v9SAd2IEfXIYRCml00SSfkxYJTp+QVFFUFvbhKUrajLl2Z8fRH1Gxz1A6lrhbrQDg8AILhLn4KdWPvLYrky2FDDz0zdYOdrmOWlh52PSLhvXF8JuWAyFNvnRQhjTmfVVzmEcizf71dwVY1DTByFxVVIX4RKlh34j2aPRzCfmycJoc+Dgn0Hn1ulzxTtfNMAl2bHTkv+FP3xPD/AEilSvV0Z/sr6uYEByZO0VKN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 11:05:43PM +0900, Harry Yoo wrote:
> On 6/18/26 10:35 PM, Harry Yoo wrote:
> > On 6/12/26 1:44 PM, Dev Jain wrote:
> >> Introduce a boot option to tag only at allocation time of the objects. This
> >> reduces KASAN MTE overhead, the tradeoff being reduced ability of
> >> catching bugs.
> > 
> > I think most of overhead when enabling MTE comes from loading and
> > validing tags for every memory access (either in SYNC or ASYNC mode),
> > rather than from storing tags.
> 
> Is there any reason not to use STGM instead of STG + DC GVA when
> setting/clearing tags for large sizes when we know they are properly
> aligned?

STGM is intended for copying tags when paired with LDGM. Have you seen
hardware where STGM is faster than STG or DC GVA? For properly aligned
buffers, I'd expect DC GVA to behave at least on par with STGM.

-- 
Catalin

