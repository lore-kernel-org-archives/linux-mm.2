Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F97B1094480
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 17:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EC156B0095; Sat, 21 Mar 2026 13:00:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99D386B00D4; Sat, 21 Mar 2026 13:00:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B2DF6B00D5; Sat, 21 Mar 2026 13:00:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7BE276B0095
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:00:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A1461DF93
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:00:10 +0000 (UTC)
X-FDA: 84570682980.09.5139276
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4E71A18000B
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:00:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nsGAaC8L;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774112408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uKskGFqbdMNYOtnaTgYByNIaM+va8ttcIKBf4zlB/Ak=;
	b=cRCjLQwVq0R7vf/IvEUnDBp6fLYUSKeYnTIMoa0gPkHkBqXq1K+h4CvM+gXJ65w5SpAfFy
	yBo7MVF+kIpZZN0Q3lpUOwgywv2mBxZ3JGW6m+vRSWKSTAYICPZlXR/742N4scdw+IWuly
	vd57jm1g9YfTFx+vVYXmnE9NhEQcouQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774112408; a=rsa-sha256;
	cv=none;
	b=JsUyFdWtWee701pTve3fJYpseHDU7oaqpbueacmezd18dN8T85j/lVehLRuNN69oxQ1aL3
	JHXW/hSTgN2IBkO34kZ4ypSTzz+/tPemgiBl1dMfyPDr/7Ivl8ouqAQmHoBCDlCQLwQDfe
	nnNhMx2+MUySWvCCJbX+gPnsSW9MxjM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nsGAaC8L;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F2A2E44145;
	Sat, 21 Mar 2026 17:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB866C19421;
	Sat, 21 Mar 2026 17:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774112406;
	bh=eCmvNHuziGX7LpG5TC/FzLyTEMjUA4/4sz21VSdCK2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsGAaC8LkGN5P2wQQ/ruWYpiDvyVrUt86oFOVU0UYoCugrxgans+jwT6qFQRR9nrk
	 +l6Ein0ah7v1Bu5WWvv6uVAsayI7iRSsbq9IXQidGiowFMyY2sPcELB+Crpa5SdNlj
	 etAmvAtcJKTwigu3Kb4920xZf/dkdCjF59+IcpH6tkzNc2SQnP4r9apNf48KXT3nTP
	 2ZqQEY6fxaQun2EatGV+pJmRjhBnJHvKflu5/Qe8D/dxxIkC6RgYF7XEzVXrFO9xEE
	 2DzM6MjisdkgdaUMnWyqh/KGLS0mfeaVfoxYNhAWZhCeKBo05Z1w7bmv2t86Tq1h3p
	 r9GmAdzkJgX8w==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon/lru_sort: add synchronous validation for commit_inputs
Date: Sat, 21 Mar 2026 10:00:04 -0700
Message-ID: <20260321170004.84505-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321002642.22712-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4E71A18000B
X-Stat-Signature: shch54nd37mdqtnwhnjsojbnimd46pyq
X-HE-Tag: 1774112408-286838
X-HE-Meta: U2FsdGVkX1+YVfVVjbuO/zOvLFlis1faip6BS1RTxNG3V3V9aZJWvmL4xQSkKfnnNN2FIyEpdiQxrXDW15wlIFo8MLU4xy30U419yMWgtF5GgVwAxCo70/7zMBcUZbPMxlWSZnuA0BfN2jWpPAY5776xV3PMFZvMV9Aowv6dKM6FA4rUfxEV2FttXAIDBgEvKsi+5sQMmrkSgOmmhuYNM9OUHA4+2I7Oymi0KLJ8bFgaU0+4zuOGINy2v/5zyuwuqJdFc9T90UfRB7U4UYq6HUanspnPXa3DZID2PmxRXn2b2/spgEZ4FkjXysrztQDVrtCDVJv0m0XmWXXlVHgDFEz1Z8ClnerOphhx07YN45EFEXAKPNymHqbm4IK8J4RCXEkyFT6tcE69zBXXlfxX+G5A4FFJZDzDqgCcwDyyO9COgyeaFLXe9h2huepPxgcQt/bjqvpl+l8i1RrfB/Tu70cYTrdh2v+JvdH+Tvim+VUxYDwDsXIMQpounkGZmfXlalSEV4Zu6JSA1zeB7otkekB9Yo8162W0EF9DkT1YEsEeZh9ETNYvI1EDzBBI3k1XRbCmuLvlXj79X5rmyEr0YYsHNORJPZMPEFolsEjyWx0UXP/xKrygwY4RjOURnVCwQGaAENKr6+oDyyaPSrNaM6jMUqxpYdghXLWsVCRjw29o++vM1KqVAiGW2oycEPb26ZooAn/f6KJpzxEj+2bq4VWi96hf/ozVg4ADMWWPK/OFsgBLmYSryCP1+j8N7PvOYB0MaUjjh7riapniqp5RAmbor+w6Q0J+01+pPeyXzIl7dsag6THkUJUWy7m9oEw72U4Nbbb5NUHjHVcQrpKYxE0N2qMUBR86u/DcjifVY+0ET5QCHDmNKDaTi+/UML2KX5tbHDPK95W9s+KZagHpw0Qj15iAc9CgzMBmMrTv2YALJD+nX4C+sIduioylHudvAVlIIcmN4sz8mbp6Guq
 VInNCpbp
 wWDRIyFrYEr/qMqE5sA9la8m7mzFR8JnFjuk9rCK15pgAnAsRjdjY4C5uLXuiCuzDxqVzRzaDlIKQkAnkxfegxJHUMN6OTC/koX7qidlY6PovRlI9iKdYL1HiiRFcUKZhqVDoXh0b+WMxt+wzKaPgyzbcvqGyzTQfXUpePI5CihdPNuJjr2uqS8RYbNnwVip6jb6/gScUEBHW14uWkODb/VMivSxC2r3aZEvNEhcJtx/bCcYhCowOmjJWQfFeqsUL8VX7q7yuCqN1j+6F1Bu+QKgipCg1SzKrUEY4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Liew,

I saw the v2 [1] of this patch.  So I will skip reviewing this one.  Let me
know if I'm missing something.

[1] https://lore.kernel.org/20260321140926.22163-1-aethernet65535@gmail.com


Thanks,
SJ

[...]

