Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30BD6C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:37:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1490A6B00A1; Tue,  7 Jul 2026 09:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11FEB6B00A2; Tue,  7 Jul 2026 09:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 036B96B00A3; Tue,  7 Jul 2026 09:37:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D327E6B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:37:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 33EA61C2E53
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:37:03 +0000 (UTC)
X-FDA: 84962081526.28.4283AFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8A77310000D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:37:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUwTJQX7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783431421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vTs7v8zsu7whrsyWYprIzwZsShGkshSeH1mdnWeQhDk=;
	b=ZnqwAcLNdwPJWBUjWTcey+lHoUVApOMIGNoVF/3lABds4DLEHOKpjJJnL0n8Ai3GUEWnb1
	CHnl/FMNwl63CULmh5ImSV2ibi5ms2XpGrc+GyBLVA6OroNNwVJFc1d7ziLrqyFestCPAo
	qNNRMSYhR1nQCNhtJuhzZrMykDZP8PQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUwTJQX7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783431421;
	b=bsn1pBGuTgx9It3d1XG3zvC1cTkobeoPgGb5lClGbJVG8gaR5qztJA3tdIFuL00/T3uuAY
	4ji0sFqg64Xt+Vzft3YIahK/76IW2r7eg9UmwvfIklTnOBS5ITIUWqiRZ7DYGEnF0yNXWK
	+l4jEQevbeTLYi4TqT4paYjKd+TKI5w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC08642EA7;
	Tue,  7 Jul 2026 13:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E271F00A3A;
	Tue,  7 Jul 2026 13:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783431420;
	bh=vTs7v8zsu7whrsyWYprIzwZsShGkshSeH1mdnWeQhDk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kUwTJQX71bILcSB7SmskFWmkhK3TGF8YHFkyzQY17WlEUAM8I+JqGhzvo55X7PZDi
	 oNje6D+myo2INszEVM2+lfsi+C0YTOUvQd8LQ6wAhpcKtd1hSyiihaQKnBkeNV4GNZ
	 5/3ulew7PLDZljlcalvW+jw7W3SqxgElQzYMRTnDAV7mG6O1GMwabMWgRGCkympsPW
	 1RpMFJA/eH96zKbocqhlAzgaIjPRn+rPf4mrjkia4fALw+u63xKvDyGhiNKwawd808
	 fZfwtvsYxWNpieAutJUVIs8936x82mFXpOxy8SGgRrCjLSRSD8AtbD3lO570OfQ5nP
	 hhaRyoXYh5eFQ==
Date: Tue, 7 Jul 2026 16:36:41 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Thierry Reding <thierry.reding@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sowjanya Komatineni <skomatineni@nvidia.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Russell King <linux@armlinux.org.uk>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org,
	linux-trace-kernel@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>, Chun Ng <chunn@nvidia.com>
Subject: Re: [PATCH v3 04/11] arm64/mm: Add set_memory_device() and
 set_memory_normal()
Message-ID: <ak0A6eLp0Pw8iKK0@kernel.org>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-4-d80f7b871bb4@nvidia.com>
 <akYs91INHMXMTI-t@willie-the-truck>
 <akZkuwktaXFTrASP@orome>
 <akaSJ5D98w2cHqb6@orome>
 <akftuw9NyRy36fXA@willie-the-truck>
 <akuvyu1Pq0ZVMZV0@orome>
 <akzikTrmhMsvkNVY@willie-the-truck>
 <b0a1bdd7-46ab-4025-8775-c9273892444e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0a1bdd7-46ab-4025-8775-c9273892444e@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8A77310000D
X-Stat-Signature: u5aszaqma861gyp6qyzt6qej44634fqy
X-HE-Tag: 1783431421-125902
X-HE-Meta: U2FsdGVkX191Gm10iz+EEeTLAuy4qPjUNM/jMR55aUfsgwN4F6Z8TsfTPA96aKYjSW8uTKKcqQleRuwK8JzvqLThIab2tsPHvc5AkavqFveQUF6slaHksyF9XwavYciRULX04aeU3hNzjscw7/OlAqq4J7Ebv9bt5VbikcWiYCF6TWU3CG8kbfSLj9XEGQxKhhJml0OtWl2DGvmHP7GN8TV/4uwdEEmMR5XSxwP6LzRe0LRLZkrZ0cZQfWxYEt1pDv7sSEJmRWYKMMUN+qaUZHsOB4ZcfH6QK/BZZR79wu+HDdmBWaiKotT7bb7/paNmMZN75aRj/lXKCq5styq429M2GnnFHlcPPc7SycFleYkAQT2bX6MEDbaJvqG80ZlIdflxkjg0pD1JHzCjduNv71fi/HD1nVwraWjJ7Oi2NoVmbSKTgxKFOrse62I/kJaHjmsTpiyGlqwSR8LiiImWaZ0jOCuuiKbY71Zl5yD4Vsger04aKJ3nu0AEXBKL7morZSKszInC98EWUDDX/ZmPZ32OgU0FTmyudORsk+EBlym+LYoZyNTKJqoeZzKLFGiQ9qLvCc+k1zDDvLkyLNn9Xu3JsmfLD6N7x5RKWxEKPuS2UNpVlPGR0YviBz2KaIs3RJP7deYIbZSM3FR2V2D8dzIqrekgLUDs+0Md3fG72H0QMvfJdsR2Qlq2YdmIalpRBhtey3KoW9fRhOwTOLY8+DoFy6uX4bWxOQIM/PsWxeiIyQF0AL0mr0I/0awmlO+6LM6bOKiqrAVjpiMpfQtT38Q4uVSg8Xys4fG+t2+1j2JSROwn1JKlMCTYcDxZXSI5yPk/TE0MKFLmFZQrv2GHd3Ge7/4jDLCAyZHYYM72MD/vAekcg3rHfi5gnBwCx0m2MuqDK/afSW8W3/+UZKFcMFsqhJtQaqlwe75PMtEnliuDAJVFHKqHW5Tw0R3vOvaLcvmnt/S/NH9XFkGXez9
 5ZPH3KwQ
 q7lCNvTNa6xQg0kXR1++MfxSQF5NsyapCdcFtngyQLS7CoXCMKGwj9W8ypJsjdUDfzWSrUSMH4cAtRx1YtgqVW1bU3Uq35mhN1rIlnz0tmSowsmdG22kOoU0lF+ZFCHZFpQUfZjLEsMaY3EG2yW7KJbLXQaKzKehAL1eBfJqlyd46iHcAkNM60lp/748eO31i355+laa3CyFClFGlQ6IgPToIo4sEPj2m/Lf3Fu9hdAt/2BHnJ8pTovu9UtVlDu8uoLEAXtM2iQENUyoH80U/cuyOtyLS0nS1hoAyi6/PEsrE2td5WqDFeBVgMwfuf+vWJWfyiZQXmRek194UY/e7dXZ/0Z8OTRUs0cn7HYjOBjcLo/ABB8CwvKDSOE+g8FbYBLIaWYOzV6cSV2nC2tp3xI+UD/o2b91d01CN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 02:17:29PM +0100, Robin Murphy wrote:
> 
> Given the precedent of memblock_mark_nomap(), as long as the reusable
> reserved-memory regions also get split into distinct memblocks, then it
> seems like in principle we ought to be able to give them a new
> MEMBLOCK_PTEMAP (or whatever) flag which could then be picked up in
> map_mem() without needing to override force_pte_mapping() globally?

Please don't. _nomap() caused enough pain.
 
> Cheers,
> Robin.

-- 
Sincerely yours,
Mike.

