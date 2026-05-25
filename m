Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5131BCD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 19:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D4096B0005; Mon, 25 May 2026 15:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 584156B0088; Mon, 25 May 2026 15:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 499DC6B008A; Mon, 25 May 2026 15:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3806D6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:54:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D50741C0E28
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:54:27 +0000 (UTC)
X-FDA: 84806994174.06.9A1E3EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5F3624000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:54:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SqGm8cye;
	spf=pass (imf04.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779738866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=dii3jeukr9ExIOwor2LDBx6O9OEuTAMnAAZyBHgb1+k=;
	b=eGUcw7ATVy/jGQp/eoeuWh9zLKeNdmVu4SCPKQtTRINRVC3SVLv6+j5fiLrMY+iYj8IhtF
	N0dK+tlPJ0OsdhCIatdnoclxnm7Pfg5yMyFUD9DdxzZp+KaS4f6BSp4LWBzWyqtopS6NRw
	OSCmWAEQO64irM7IVYtJAHpYrYFsccY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779738866; a=rsa-sha256;
	cv=none;
	b=OXLekEQMxD79zrjKt3TCpveLP98lHfNmdm/qj6IDrdBoQgTYoXiJyVeuI7fw6nefkKvT9A
	cJrkGus1FZkyAgUzOLwXFyxF/qcwMON34Xx2xeVresbg4qWFcYuyxJ6OAyr1xzv8tlyWZn
	wZG+DPRuBQRgeyJAYXh95ClVogMHGi0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SqGm8cye;
	spf=pass (imf04.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9068040630;
	Mon, 25 May 2026 19:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1241F000E9;
	Mon, 25 May 2026 19:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779738865;
	bh=dii3jeukr9ExIOwor2LDBx6O9OEuTAMnAAZyBHgb1+k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SqGm8cyerm1SAKBPfWzdO911EPlHOkLgLQxNL2YxIKlaa2m0/wIkdLGaWuQk+uw3A
	 G0G816Zc+XLJqqK1siV/8whKehjGCchy2oHMQybI8D6VxAGgQVAUZ+vcgQRLeAYQye
	 dWwIkfUAttGN+Wsn0GfAh/zvhzjAP/ItOgIemH25wTluWa6DsZan0Y76olOHNS5Sr4
	 1O6OhHpe8Tujbolu0VpDx2Iq0Hz5cjSu60j0wNILiZ92QyrouncjKvYvJS4zM4WeC8
	 xq9487/+ZwKDyziuUXNXpYKOVQwNYYTPa2ufLfi6pMzaq7gRCTDprZ0o9epjoJI8jG
	 zQZEOSY357XFw==
Date: Mon, 25 May 2026 09:54:24 -1000
Message-ID: <240ca6a938e38d2af591f09a721d6e9f@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
 Changwoo Min <changwoo@igalia.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>,
 sched-ext@lists.linux.dev, bpf@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET v4 sched_ext/for-7.2] bpf/arena: Direct kernel-side
 access
In-Reply-To: <20260522172219.1423324-1-tj@kernel.org>
References: <20260522172219.1423324-1-tj@kernel.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: icghc5n4rfwons1rynxuth8gt6fmmyqb
X-Rspamd-Queue-Id: 5F3624000D
X-Rspam-User: 
X-HE-Tag: 1779738866-639283
X-HE-Meta: U2FsdGVkX1/B2tMGuMrwF4e+jMfyxvPdFshN1wd7DIJuxykGGuyQf1WMBBWXJfxnPSNJ8u2xyc1Xpo1hG5gXL3vGJXcH1+Y/BI0+5E5cgj+2GPDQMC/c8/nWjqe0hg6d1O+UrRby53Zvah8Q3lryCxX4uIjTS/BRWTVGU4XYpfEeH+OVOkQuvUiTBmjKc2IMKxOiZTGipHIQ8B/wFKWZdWO6sZak9nFKNHd6kNZXD9ujbaVnwbbxMQVnPRVMNuntXrtCL/5TgxDcuFW0/KoWzZZitZDR2f0NY3LRI6AYDYDQHFPUSg2Y3GLaC4qnTzBfggUvCDk2PyRaA+g4eeyiiHVMPUh9wHI+Sx1vG1AmA2sBYo8pUIYyLVCslJvWrWJR/tIXG2AA7bASmPeSzLgTz67Bq3H2+cEROXZqQUna6hBFRV+yIB9CYZlE+iAjFgeyKVkwdiyeC2rFVrDhnBrrC8Y+yqRmo+xu4lmMxBPUI2MheV/NGWmT9myNQPDhOoKTqUXsiomkrTmsQNpQw/BAijUnsJb5w3AXTQankyV4SMzdEy+XK7uokXje0aUaSprV5lvh4rAIFN1YYRoleNl9GNnQCl5zaQ1l+TXaGgQRKfAuf0fjzC/zJaJOy60mKx+LxCM7XN0xnIU9+rbGG0juF3H/HM6yx0vDjQ0GMHIq5k5QNKSf2xb0d0jEjkx9qwKOsFQ9XPggSE40qiIC6Z+EpRCzKBL7c06Fk+buqlv2hfxZhnaWsHzmoxNlhsDe/1RwTBmOUsbtRQug8SEMknZpjMkBDn6J3aq6hXUiruxRzOn/VghV9c+iUSwYfpGMyoD83yks1434FbopXgwbg3Dfmmr/iOJoY5PwCj+kYbOsbdsan3RG56sfdvC7B5rWzqrWY2EX5dddYf8VlKq7hFUH7gWXJkEWbPyDFXSbEDdG/6VcS8lSvgJ9oA3hr3wngBiut5HLE1IuXTm7FGNBMkx
 x1kPjA1V
 prVhRLHAL5fYD+9BOzrNJHRGSvPYWQQXynF/HsbRzkqoGYrkIhz2Z65/XEnum4qfnN5chEwSg+qhnvcvFYB6pI2uMfuMl2Bqk0B78zboJkMBmfDt3l7YddnKd7HnkFb1s8ItetHU5TDJbj+LYRsgjEbfNnjzLpiErxE+SpoTXiIYSSY99JhsECNeEl4rFPPfgNtzgBEYk5Og2DuKl8/dk8a2Jhpd8HdxNYxwjyKvl73frjeWWtbzBpJF6v2nm4Mdj/u0o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

Patches 1-5 went through bpf-next and are pulled into sched_ext/for-7.2.
Applied 6-8 to for-7.2.

Thanks.

-- 
tejun

