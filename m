Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35AFACD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BF5A6B009E; Wed, 13 May 2026 11:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 370256B009F; Wed, 13 May 2026 11:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286876B00A0; Wed, 13 May 2026 11:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13CAD6B009E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:07:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F76C1C00B2
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:07:34 +0000 (UTC)
X-FDA: 84762725628.18.84B9B74
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 071D8180009
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:07:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="NE/mD9WC";
	spf=pass (imf24.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778684852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U5FgpYdWutcIouGicjgojW9gOVO0tiNobAoLydLLHpI=;
	b=Dnd5pLO+DbdpK/hMD2GTDNTaRo0cID0DZtzLytGHunvYEInevxqgM/iX9Ne0mSijzP4WgO
	7S4MyZgc7HeGcA37xC9ZimeY4HiBcU/8lXkS1uR9mcw+Uvo6CvQvspcf/C1tOb86sHFeMY
	7DMDzLHMYzR/oRdlzgDs5E/u6lZ9NuA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="NE/mD9WC";
	spf=pass (imf24.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778684853; a=rsa-sha256;
	cv=none;
	b=4nJSZ5aGfjT00/YrbnJ3ezH7kBQ3g6ZlsjjDPiCuOxJTjC2xFxRo8bJOa6GdAJ5XjTHxq4
	5mZmynqnuLE/99aTXlqYcFw0D5fxc+XL1m4ctczPRW+91K7LVboTrvre52CO0O4BtjiYiz
	gI6TSyYzwcIZd6ki+fjVWpoFzOK2YMk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778684848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U5FgpYdWutcIouGicjgojW9gOVO0tiNobAoLydLLHpI=;
	b=NE/mD9WC9zOAcd3zhlSYl0Cqj9YZsIOlgArz6a2uSxTzDzgPNbdatWQb46xgsRMfDyQyuO
	FbhokL+ZCFFbeOjECotujV7IQL/rnfpmKH9ArHa+ck4pceT+KZILLm/yK/zSjPk4buHBk5
	/v8g66veXLhfQVWNf+k3kxmXnoKJajI=
From: George Guo <dongtai.guo@linux.dev>
To: pratyush@kernel.org
Cc: akpm@linux-foundation.org,
	dongtai.guo@linux.dev,
	graf@amazon.com,
	guodongtai@kylinos.cn,
	jasonmiu@google.com,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liukexin@kylinos.cn,
	pasha.tatashin@soleen.com,
	ran.xiaokai@zte.com.cn,
	rppt@kernel.org
Subject: Re: [PATCH 1/1] kho: fix KHO_TREE_MAX_DEPTH for non-4KB page sizes
Date: Wed, 13 May 2026 23:07:18 +0800
Message-Id: <20260513150718.182224-1-dongtai.guo@linux.dev>
In-Reply-To: <2vxzcxz2dybi.fsf@kernel.org>
References: <2vxzcxz2dybi.fsf@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kue9zbbb1b9m3xstseyug6ozbcke4rgc
X-Rspamd-Queue-Id: 071D8180009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778684850-456691
X-HE-Meta: U2FsdGVkX1+rnoq3fI6XUmLqezzL7MfCjXPxbMAsf0FdiumnThZd1mJXTWUOWjDZV5JQ7vlZppoi+dRDsRT0/ehNT0ZSI2o4NmVsvcaHvLqJAX8jEmpUhiOOuTrlAwPEFsGQIoSXaVsU1azYnTT1eYp/QBig1RlAWOvrOgYbZ2U6FdUvBZh06kPc+pKAdbJyvbS1PZefJMrPA+M/ExwiarbYCc7DeIXUKAsbIuccQH+tCIvLlTLu0HKvyRS+qM6+mwjhELqRddlPISHFuVo6LkBCMUIjJJdp9MHd+9TkAJ7cH5mstU4AfI7VDG7FHWJ5MC7Na2QAjxPKNjM8WosPfDFKo6z4RvosmL1TzulrhyrzJMv8qI60jKC8TmnC+L35y75v9hOE9/tW5QJ4LEIKNF4RYwpkAki6gaYnMNzWICKh6YbGfUEsCRaR/kMBeGsI1s/BYuyYvy91GBZhsVEb7VYfRsDFD7Fx2bqte6UnaWDm7ubBq3NDMpF0afq3+dPJF+qzc7yy/9fb4W+8s0E5SlpC2FAoGP8pA+Kcismjr+rEZgTJoND1SdkHpNHNV0lQjvQ/wYj5LO8L0JSQDzRcRXqABOyFoSn3PpH0L5eZR/d440ya9gp+WVctUG4qq284mlU3KpOUK0+RyPbinLiRdu3zOUjTEOCGLvVgwm50CUV6V3zStt5jVOYzb7y7hWs9/8V6G9zYAyRiwlpwvlYL6QxjP/Vb+X/U8fpWOSGYfm7/K/fRb2yQdIZVCZx+VbPKwQAHBTFz3FRUwelav/+zaSweoGs/8ZYR007mL4WjdOMjmi+GI3aA2xB3axjfeYas5N6yxkg+AT3AKc3Rz7adQACC1KyHlGQ5FvvQv8H9e+J9T4eWlTilLkZ5zd02QrKePV7BE8ii1H5OuO3+JeNwNN2Wbkpp/7vZnaiIxB9QJvaa2JFMzNnHQcjOiUCw+GqRd/6VLXf7QtIllwoRtL7
 RGtKf5f4
 B1D2Cy3l7Scazdbz4H4YgfV9OPcH7bKxeyrww2BEdJ4eKwI4mzdCpeENtLPuViz97+xkANseAeq2YTCKbVuI2ideGOh6X2yZcex6ewofRNX+HWebp7mWUfiH2wd5qejTA9I66TbKleyRD2DY2vy23YH6GLtd4u778ZCa7G5uCN6xAn9XQDLAn11kPXnoWL3tdo5vA0mXericfJAwWNxpL6Qkqi2jrAJDp6ermhxu+Qe8vB90hbmOCtjw2Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for the late reply.

On Mon, May 11 2026, Pratyush Yadav wrote:

> As of now, we only support KHO on x86 and arm64. Are you working on
> supporting it for LoongArch? What is your use case?

Yes, we are adding KHO support for LoongArch (16KB page size). The
LoongArch patches are being prepared separately. This fix is a
prerequisite.

> Maybe I don't understand the math so well, but I can't see the problem.
> ...
> level = 4, s = 50, idx = 1
> What am I missing?

The issue is that all three operations start the traversal at
KHO_TREE_MAX_DEPTH - 1, not KHO_TREE_MAX_DEPTH:

  kho_radix_add_page()  line 180: for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--)
  kho_radix_del_page()  line 255: for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--)
  kho_radix_walk_tree() line 356: __kho_radix_walk_tree(..., KHO_TREE_MAX_DEPTH - 1, ...)

So with depth=4 the effective top level is 3, not 4.

phys_to_page() of that address faults in kho_preserved_memory_reserve().

This is confirmed by a kernel panic on 7.1-rc3 LoongArch (16KB pages)
without the fix. With depth=5 the top level is 4 (shift=50):

  (key >> 50) % 2048 = 1   /* order bit correctly captured */

Signed-off-by: George Guo <guodongtai@kylinos.cn>

Panic log on 7.1-rc3 LoongArch (16KB pages) without the fix:

[    0.000000] CPU 0 Unable to handle kernel paging request at virtual address 00003d3ffe000028, era == 90000000c162f10c, ra == 90000000c162f0f8
[    0.000000] Oops[#1]:
...
[    0.000000] Call Trace:
[    0.000000] [<90000000c162f10c>] kho_preserved_memory_reserve+0xc4/0xe8
[    0.000000] [<90000000c0129f88>] __kho_radix_walk_tree+0xf0/0x138
[    0.000000] [<90000000c0129f10>] __kho_radix_walk_tree+0x78/0x138
[    0.000000] [<90000000c012b730>] kho_radix_walk_tree+0x88/0xe8
[    0.000000] [<90000000c162f874>] kho_memory_init+0x220/0x4e4
[    0.000000] [<90000000c1639b38>] mm_core_init+0x168/0x1a0
[    0.000000] [<90000000c1620d50>] start_kernel+0x5c4/0x778
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!

