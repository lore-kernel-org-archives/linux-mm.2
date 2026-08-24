Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C62FC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FD696B009B; Mon, 24 Aug 2026 03:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35A4A6B009D; Mon, 24 Aug 2026 03:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26F616B009F; Mon, 24 Aug 2026 03:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 06B5B6B009B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:59:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89800120463
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:59:37 +0000 (UTC)
X-FDA: 85135413594.16.1307088
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id E08B7180009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:59:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lMFV9AKJ;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787558375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QESuUejoif21xpk97k6427Fvu+YxzkM7GDXWk9VgdKE=;
	b=lfhLy4qrWhkZ0jPF0QrFBOKHcAkXEbmVgMy0wMG3J3aHwlQU0SgREocpZAhdM9unRN8Try
	+xGv6cWjESvoHVCa/jh/J0nYItkLUwqlIoLGEgM5YF08X0Ts76Kg2WnXTOX/BBf2dglXKa
	o76Gh3JoF+dlZQI9SZHlhKrV7YJqBnE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lMFV9AKJ;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787558375;
	b=1FQHsL/Rmz16VLFI31wq1NqU2eCiOn7+FkUrJruME3rXtufoMG447y/9onoXsm7G4uijn7
	uIWay7tcHYJ0EQT+8ThJmbI0lmoNdJQH/w2KetV3hsj+Qic/HdVZs92DBM5STd83aSSEo6
	bKJoa/EqdAQSId/fL7SKZcamC/VTyC0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 334BD43D81;
	Mon, 24 Aug 2026 07:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93F01F00A3A;
	Mon, 24 Aug 2026 07:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787558375;
	bh=QESuUejoif21xpk97k6427Fvu+YxzkM7GDXWk9VgdKE=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=lMFV9AKJpUzgDR2MoMR0GFxbAdwyj8PeKhtFdvRKi15qNTh3y5ASPNf3oi/I0YyTr
	 /anHzyDhj+8le4BthTbUd3SpUje00DSuPpnmfW0Yuxl2+3DrR2gZ/X2Wp3EVaRKb1R
	 5bacSFKuBovrNvUyL3+KWZHbjoNkesPD+pQ+uxJ9FsTVuToF6nsPM7/UWpCSolXN7M
	 0MZ6YQJjHuqmTcL+A0wdRV/M3Y/QjsoyNwo6Ux1F9+5XRgy2Hlta7FaI8UxRZybjy6
	 vjuEHHUwB1nQaY9wKR2dgUIhfMQVQCP6P/G5m2GLHZzFJsQszYKUxLjp8ydW3IGmDJ
	 s26qZPlp7WTpQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 4/6] tools/mm: move gup_test from selftests/mm to
 tools/mm
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Mark Brown <broonie@kernel.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260813181230.483746-5-sarthak.sharma@arm.com>
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
 <20260813181230.483746-5-sarthak.sharma@arm.com>
Date: Mon, 24 Aug 2026 10:59:05 +0300
Message-Id: <178755834511.3606540.11386137708509292188.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: 8cz7htn7zdw1r7z7yyypmjy5d7wozdzh
X-Rspamd-Queue-Id: E08B7180009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787558375-770624
X-HE-Meta: U2FsdGVkX18YP+xzxQjAlIEO5jWwfGGBykftw9vM8TJDkAN87can8RoowLv6k2vMyTPzOtUEWoWIoQGwjeTjw/9+RbwtQPERhfsbtguJOJvGdVIU5rAiA6iFwGFp2AEOtJguNWV8dvfzyzEI8wbu9Wuwzd39JET3HMW0uQ8koyCoTCLZa6QeqJYoUHiYpzY5IL7BDHQD22ROG99uv3ytgh3Yj0TPpq+AOqMi2UFjtkJ24PnUIwxLp4+8r0BvyVCjcl/LkjrkX5hjxDXqmoz2Vz8HQSfJSZ3g1KXnkPUPiJPusuRGA2rgK/XsmBz7IBklGv2ojoV5+zfxrgCetnlKzUEmrx0PJw5pFE0l29BcDto9rOqugg1cM4SUIwi/tuVLlAX/01cJRA4f1dvKQAmUtmeNH8HMBCnM6hXXlae2pTAx0y/i9gZ/9g696qfHZ9MJ0ExcV8n+Q7WkHIdE+utzotbZXzDGlDj8pJKJAyshBW+ibGgVKRqYNisen7CWqcZZCuDD4t3nm7iLsJanc+4DKm4OsI68vVMN3Ud8i9/IPnSthdKqPaaIbCMpSYCfywK1DpglGRN5xNdJxHtEj0iB2tBEocc/c2UwvubzotQ2IoQEb+UOjrmTLdgNavUILgkPvkU0m6jRawn9pvODXO6Ad8nC1eVl1TCtEHjWz/fv0l4CKgUhdKvAHru9s8pCZAQT9xP4kUKYtIn7N6e4LLLDp7kFDBwtLqMVZUKx2oXet42s95FfBs4tJAVwg97zrxDXm8h8t8yJzlindYhqVTN/8ejTtFld/o//6HtzmHeuy0Pchr8CXZhFs/MbJZhVROtq3o7ckbkGtcuosL6rUcnN+5EGPDA2QTUcoHQMQpmA6yd7iCDCnzu0Ys0ScpXIAp2CmiuY2dmj/jzTJh20aRsFz7Dibeoi96HEcUvZ/ssDt8l888pE2bBoyJritOukRwppC4vWBxaCgqpqvNbLFcT
 BycRgNsD
 tY9dXbv4JilkKLUuB/i+mkUnCHJb7HCyMLkHuuhc+JKuLE35HIRaVhsjEfD7do31dWEBO1Ei5k9Bvze5aItwR5LqUBoHBpdj0tOk/WgMlTB/hepGasv87+haFDoehFLRYY6OG5cG2hK8zotFt35qGBoxjJs/VbIA6DP18mxpyt5eyUwVu5cg0ex6rFDaWrJOFkpajNPkIbUDY5DRGyGhPNKkblh5Xq0zG9NP4PbkJ8RFBeBWw2LoEO57ET2+JDQv6iCjWewzqZ0wS5iVUsN6ICIu2wNEBW4xfd8IsJ53LWi7d2nE9mjDRV6gxk8kARaadcCIOmf6UQg/yzYMmtmv0dldTo3PszRwSWRXQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Aug 2026 23:42:28 +0530, Sarthak Sharma <sarthak.sharma@arm.com> wrote:
> Move tools/testing/selftests/mm/gup_test.c to tools/mm/gup_bench.c.
> This is the first step in separating its benchmarking and
> functional testing components. Later patches will make this a
> purely benchmarking tool and introduce a new functional selftest
> under selftests/mm.
> 
> Include hugepage_settings.h directly instead of vm_util.h and
> use getpagesize() instead of psize().
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


