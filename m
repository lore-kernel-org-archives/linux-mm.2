Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2C85C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937D56B00B6; Fri,  3 Jul 2026 13:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E0656B00B7; Fri,  3 Jul 2026 13:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CF4B6B00B8; Fri,  3 Jul 2026 13:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5AFD56B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:48:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D93FEA01BD
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:48:42 +0000 (UTC)
X-FDA: 84948200484.19.6252A23
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2C00914000A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:48:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KSn3XOkj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783100921;
	b=rbRIXJN9lq3UJNhGhWFPxch7k/CUy4gPmudLGxrxdyh7lwSuoCpbuzLc1ZVqFOz8XU1o6F
	d8ATHRCdx0Lb3yt53mViAzvzSTDehD3RPZP/SLkvhEz5BMzbiUN0yE9sNGBvR92zUdUH9j
	662c98sFXjPEuSC7Znj4smqGPTDvGP8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783100921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GGBqB1i2lcxh2kKfWJFTM0BG47cF97dz2YCl8fcmHhA=;
	b=XHoio1KmHw8DHHl+wYBf81wi/IJFwX6dKM0EcMLAzTbsCAUmVaEzkw6JctskdlcJwIHyWw
	DOy7p95e6eGyeEHi3DM0yAnd/AHX8sNaAih9VBgN8HqdGtBhgU17nYBCebs9fFeodhnPIf
	esRTqnymo7X+q7kwDuG1LV3f9Aet2Gg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KSn3XOkj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783100919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GGBqB1i2lcxh2kKfWJFTM0BG47cF97dz2YCl8fcmHhA=;
	b=KSn3XOkjMucwzDecl7TvcRBT8YSow4vMTBeBCySRuzCzQCzp7tHuTZ2QJjMFv/gmxapQGH
	spQwWO0+HKj7dS4T0tBQ2NGkVWSRLunZVotR+HvkHWzJzoEldfJh5fi6/38CgsrV9bx1yP
	vlRDLRa8Zxke8Y/10hD7Eyl/ChPjZEQ=
From: Usama Arif <usama.arif@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	"Liam R . Howlett" <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com
Subject: Re: [PATCH 0/6] mm: preparatory patches for PMD level swap entries
Date: Fri,  3 Jul 2026 10:48:31 -0700
Message-ID: <20260703174832.55655-1-usama.arif@linux.dev>
In-Reply-To: <20260630164143.1595669-1-usama.arif@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: yrqz36714q9h166ft5yi4tugsryi3an3
X-Rspamd-Queue-Id: 2C00914000A
X-HE-Tag: 1783100920-887659
X-HE-Meta: U2FsdGVkX1+DK+JU31mYEqD+ZPBTD734DZoeHJxLopmSRjLgPGL2gokWl9CxSl4HJZjlmH82inLxSX0oRe1p++iH3B4ROtTu8Cqll1kBWU3TIzUMvqbUlR/qYoK8/4rUV1mKB9PfgETWCYbZknWXKlAmjmyFb9Jw9dTvL/J+3IQQBIOybsSHAG5mUHcfdCxcgsFDq2R+UD8yXt/QAm1ze4E2ET9JdgVCqGozvPXq+d9X1EDHTl8tJ0XPSJH6QV33HA1tio9PbTHKCeRQ6x3+4/Jb4L6JsC9vibcL4L5gWKeYbp3jWHihTPlI5gvJyys9krkbjv7aMigFdkBCY/DoiNxdfp1foJMehki5g8voGGz65+8cpGd6H36qRQB571cM5totgSyJCahzYs9agfGUsH4cGwivObZDQFFGanQ5PqIbzYleEfy06U1jOwLm5nctUXSi75Qgeu1avrPiwn3yg+otlmbOtBDSEyDIGTwlbDxklfzh4CWpTgYdCCpdFFH5ZmSuXedvsX9ZetfigIokzHToGbtenWXxYU9sHKqeNSGjP33sJV8RdQxb/JEHzz0iH1lz3ghRSEmNouglOEJOLpDzfbKHFss73OVivojEprPs/Jdgzv8E/vATZCcihsH38etqNgOVH3jafukO2nRIRboWSzrrH+E52d/cTakaRRb0MxlHnX9YErcUar7WzgFnF5o2PFBmkOGXfllIwYa/9igD4cQdmM4BpCZdItR4HQBN+4a0MXrJKKWU42yfKPRwwy2i4gqHOXPnaszsbArWz+AzJta8mwV5nEVcvmCBIQl50dU1YL+QBALiWzYXEYuAYtoll7GFCNyuF2ai+DjQpaagVB7sOmNYBgGU8ORX+ClZT9wTmEgf61xom8Lb21NuzprgtsvwBB6trN+PwOM2YwmcMppUSAlWJtTyKqu0nB9KaoGUMKXRfMK2CiPMhNHUVDzxYzRnCjovPCYHLx7
 phnIUs2X
 IgIF3FwtmxlM8ONFeenmWASzj/6IgVRs25lJXewJ2w5vgE0ZLNPfSMhFmG7i7+GEGBecXRDCUZ7JBueAvb5YSNYasGHhL5W7hG1fDJ3u2oHPtVCRbN3GhfZbXGHu2k4GR6lquIKI6TebNQ4+aXoRn7RL+TppdPs4tYkSN2T13skbgXjPKYf6vNCzh67BamDNkgyjRW8pJKVKf0r+bjBQDOSqagJSkyR8H22T9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 09:34:37 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> This is the preparatory part of the PMD page table swapin work.  The
> full PMD swap entry series has been split into two parts:
> 
>   1. this preparatory series, which contains the first 6 patches. Zi [1]
>      and Lance [2] suggested to separate this out from the core series.
>   2. the PMD swap entry core series, which depends on this one. I will
>      send this once the preparatory series is merged in mm-new as v3
>      as the combined is currently at v2 [1].
>      I have not marked this prep series as v3, as its not really adding
>      support for PMD swap entries.
> 
> This series does not introduce PMD swap entries and does not install any
> new page-table entry type.  It only cleans up existing PMD softleaf
> helpers and call sites so the follow-up PMD swap entry series can be
> smaller and easier to review.
> 

Hi Andrew,

The series only needs 2 small changes:

Removing a comment:
https://lore.kernel.org/all/157838aa-1518-46b5-8734-feab2c42ee2a@kernel.org/

and s/CONFIG_ARCH_SUPPORTS_PMD/CONFIG_ARCH_HAS_PMD_SOFTLEAVES/
in the last patch:
https://lore.kernel.org/all/e37df165-8de0-4924-ba19-0d43a6b7d36e@kernel.org/

I am always torn between sending a fixlet on the existing series or a
new revision.
Just wanted to check what is easiest for you and your preference
in situations like above?

Thanks!
Usama

