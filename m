Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B558DCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 16:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 079DC6B009F; Thu, 21 Aug 2025 12:51:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02A8B6B00A2; Thu, 21 Aug 2025 12:51:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82976B00A3; Thu, 21 Aug 2025 12:51:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D48706B009F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:51:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B7C5C0485
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:51:50 +0000 (UTC)
X-FDA: 83801356380.12.1A5222B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D095F100009
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:51:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EP4thFQH;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755795109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8W+GTt+fPIsw1oYSaDSYIx+UBDLWvIQSAwrsYLyrpa8=;
	b=WTkV2F0maHSDKPhj+rng06HkxVFZ67f/qRxwbsvEn08BKsGmsgr1JulRaUg3N/75xZdiTK
	PnZpemleu8JfB0WXDB9rCxLd3/zdt5nrdxDc2iEftlrOwvPM7JvrJzjWp96mjRkxLxsm1c
	SsUnQliUG/B2RYINHDzhsb+Tb4rEV7c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EP4thFQH;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755795109; a=rsa-sha256;
	cv=none;
	b=2Ieltmy+vXjWF4Sgqc72uym4tby7/eQQpjbAMZDGjz4EGBe6OV83mbv+TLGR5fCHGd2CIK
	tTIMwKjCgzvwBri4fspQ0oyScI3+53c8d4u7Vf3iiCUDGNPRIa7ZzEIalSJZf3ttKPxTPp
	dGdc67oP5kn428ehTmTyPTn4I5rUXfU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F484419AC;
	Thu, 21 Aug 2025 16:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3706BC4CEEB;
	Thu, 21 Aug 2025 16:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755795107;
	bh=NiOlFmdevKS6VWgKWMk0VHghGAr9+/QG4GrazUo/thY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EP4thFQH0VsRbjF7HLHpYini3V97AaDZfOUIcT04U8+ld+l3E8sggPMXbWSIP9r0R
	 ThbIPdcEiNi/Ifd7TM96NklAuB5ucjYBPigKg44+R3JzIsM/wQYGa1OJ/Z39FhTdKq
	 b2JOWoGvrqsmrHZNrQqXiLjAV9QdmfDPDv1MitEqFgNSnnmTG4YNBfku1JtB+ur0XW
	 MusChySB/U2nkgcnu7tzGjRoMCZYIh3xFZce+sXmNJsvNmjHlwYd/Fe4CMNbPaW3qh
	 WQAbgpjRXD6AEuBhp1aosnXBOqOegWubbORtVFUML7TaQm4w3cVjfO8rbq9j2EMMv/
	 MuX/KzUijO1Kw==
From: SeongJae Park <sj@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/huge_memory: remove enforce_sysfs from __thp_vma_allowable_orders
Date: Thu, 21 Aug 2025 09:51:45 -0700
Message-Id: <20250821165145.78779-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821150038.2025521-1-usamaarif642@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D095F100009
X-Stat-Signature: rtr8hqcaaao6e15brqd9qmqok197k8sh
X-Rspam-User: 
X-HE-Tag: 1755795108-466994
X-HE-Meta: U2FsdGVkX19delP/luDGElj/dm86EVJzJm0DC6j0Ujx2DG9MiPEPOClqKzkPVSXOeio7V7mPIa9Ym6lILlKoP0/rmtPyXvzAz0rE95KIZdjAMcyIyi8ACPQEoVLmxFtnfv3n5vgfWM9TIrz8voAJOnHx7rCZpzClzVF98JbPR+b7xXv+5GUCwK7+iUiy6NgARvyjfQ60mGz/m6XIyW/vCwMHOJzXzJ5gIdkKLHK96GfRjsOn3+WHVEOnYAma1DBrSvsRXUzczYsenY0wwrKDk8VujCBejX4Kn8CU4RJ/+FQDBntW/Uvec2YkiNWwbE/Uwb2eir2YAQaAZdj6ZL2dKlQYOZTCIZLOimiXORBxeD6jRci8lZq3Jfx11vM3or5cZHhfCkpjNaPXb2iYOgrK6NrMYzv6/GgUrZHRICQEaRodj/09Rjz3hpp6UfBuF1QN1J1ndELTxM5xaUhK0Yfov0SkciXpis4rn7k1fbPQlNe4vpGZ5/xpX7o9bkYu3N2fRmFI9F1cOlCnQjuUe9uQ/55qb+d0270tHpkG4kYJJj87R7IaWuwWX2hIzmglWxt4V4VhRApnFt5ve01eqth7D++qzq1WJ6xCPdat3upg7bB3UOrxKfiMvrBmqVzZv84TjfFv74jgDO70UYzFfgazZwEszMy9+qh+3KQxjBqTxZlSqr5dfeE7enGlc+O+yWersMfKKI/QmoVdj9BwcHdHEjGhSrI5CnHqJffXRbzw8M5R6SbYssdz2WAwAhlGJkLJGQ2DDChJMyv6DbfapBtZMpFTWRHsKy0LjD9PnaSMZqKIQDGJ18y+J+eSX+jl2NGXWxfRlwr5bYfSJuW7t3mRNRRa/qXuSimkZB/+1WBwvChpSnvyTPHXKpI5PAoBz4v7bfSF5Vtw4F3dvK4ZFudxMneJI+W68vp06IGboFgif8hYQbFUJtKNBkhnponr7sahy6Vq3bV0xRpuRAN0a7V
 MqSGZ+9i
 CLCYGNELDykgoA08GH4Kegisko1ioZX8fHuaHVuSFXAGx7tc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 16:00:38 +0100 Usama Arif <usamaarif642@gmail.com> wrote:

> Using forced_collapse directly is clearer and enforce_sysfs is not
> really needed.

Nice cleanup!

> 
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

