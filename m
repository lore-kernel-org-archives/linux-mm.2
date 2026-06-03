Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC75CCD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 19:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3578A6B00A8; Wed,  3 Jun 2026 15:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 308476B00B0; Wed,  3 Jun 2026 15:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F7316B00B1; Wed,  3 Jun 2026 15:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 092076B00A8
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:31:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A3A01405D8
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:31:22 +0000 (UTC)
X-FDA: 84839595204.03.BDC099A
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf20.hostedemail.com (Postfix) with ESMTP id D32151C0002
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:31:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780515080;
	b=buGJpwP/gWiu3QDMo/MS1dehQaFCJImdePE/S/Mt/Ob0oHBZCGniqni92TiW2Ww+Dd1Idi
	alqAMN84wtgP7HZH9hqmNh+PdjTVhfMTidQ0b79W58aNB3+5ektOnLgEPPEuhk4BTtfzF5
	oXabnGDDiPNzag7wR4z89HaBuO9ZuPk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780515080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oZvBXYfVAM8Q2VS5Ix7KUiMNqOgdDKAjuhcdJXw5BTQ=;
	b=tVvYCbiGfnzEUZfofBuBnCZpk+nCXIXZq03Xr9pwtn/u0dKa+SnHkpSbGnNmQzNaQ4xej5
	6S0ArOMiihg6jP4GlDj+fMW4ILmczW/NmQVVobkjxjii1yLCR9I8CRecSi9fKUJ/XlC5nb
	+kXIPNogiyePvxeesGfimT8c92jqBjg=
Received: from omf06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 16F391C1CDE;
	Wed,  3 Jun 2026 19:31:19 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf06.hostedemail.com (Postfix) with ESMTPA id 27B732000E;
	Wed,  3 Jun 2026 19:31:16 +0000 (UTC)
Date: Wed, 3 Jun 2026 15:31:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
 "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>, "Luck, Tony"
 <tony.luck@intel.com>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "xieyuanbin1@huawei.com" <xieyuanbin1@huawei.com>, "Lai, Yi1"
 <yi1.lai@intel.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-edac@vger.kernel.org"
 <linux-edac@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: mm/memory-failure tracepoint change breaks userspace rasdaemon
Message-ID: <20260603153115.775a2e81@fedora>
In-Reply-To: <b637ede2-73da-49f0-a7eb-70ec79e79624@kernel.org>
References: <CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.namprd11.prod.outlook.com>
	<b930678d-a1ae-458c-8705-7ca9680d4cb6@kernel.org>
	<20260603121707.7eccb9fb@gandalf.local.home>
	<20260603161947.GBaiBUI7C8WWPwD84S@fat_crate.local>
	<0c16bf3d-7c6d-4e28-b200-03b7d0ef714a@kernel.org>
	<20260603130006.7d2c4a62@gandalf.local.home>
	<b637ede2-73da-49f0-a7eb-70ec79e79624@kernel.org>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/v0JHug/fbEKbv0orzjsUgwqRSLAY4vfI=
X-HE-Meta: U2FsdGVkX18BS9WmFzYjXx1SEgGMWf6ubjVVWbxkrHXl/C+lfZyc1FY5NNDejF5/51RLVOu+dyiJyjXjGytmVlyD1dWzEqVx8QPcGtHRFRiiRsyVy2Wtj76dNjs0RLmjT3iRXEsS1MmRyxB7krYMay3dclmABmdtxLRZV7tgf3WNWNPrdJVjjREN04OTrq6wzDiPoWYZWgo90MB8u/h03etMedxCUVxuZECAyJ62EsifSXsgfsVLy6kYpM97IojMM0WdtYKJpWL45s6pRsNDuG9f1KzWfE5OTet3P61DSAP2jKGHj0jLFR9EXA2i9GjQSZmvuxbGiLUwCvieWoWn7+Pc2srt4cAY
X-HE-Tag-Orig: 1780515076-808314
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D32151C0002
X-Rspam-User: 
X-Stat-Signature: o1f9my7jggg5tdygakhbm7htic98hmto
X-HE-Tag: 1780515080-958830
X-HE-Meta: U2FsdGVkX1/VfQmwtCd1gw3j/2ZkzOAKtFmik1cmJexHHA9hh+37sSm/6A+/sqvwHXqOCBrc16CKYDsAE0XC12Iu4h7DcuRVCueAXw1DRG7KGUj9Yh2IrQGiD6mwPUBfLUFNsuTo6mEokqYsIqtyd5PRfnmolphMiZFz9m5Q4J1NIDdKZv8BtqLLqiDx53uRbBn6eDbDD2k2u3YnNNil3BTbt6MHsb7BT/3oR4lsy2hLgva6AeE1IjjOrA2x31pRn3FJ5yL7tSWGxuM2UzkR7yh+cVFpY2MVwr3rZfMu8F3BECKzc4NnzAmr/2Wc8hSF/59MrlekRZQlvXaE6M9O58SztV14ndb57JGLYUIPiA7JM+vqQ49zWIjH8w2TFy4cAjwx3iJkkApZ6sJg5y9mWHmJ5I1pHZOVIk47Gq9pz80N695xZ2rtJlPauyUPcO2iTLqx304kZ9T8hUpdIfSCxHaRmTHh95hnugcVeiNQ4J/eoE8oOhS8xr9K17ZUx0qTNA6fcX7kJL8j4cJSJI2hufvfO07/Ky0KyZX5L4LVCKAELOoNUIgOqwqJtnWduFYwCxDONHvolt+YmV4q+rm+SVkavwUpPhoskIoMdDdKaa+5n9SrTKRw7ozbvjfpU3UDC8t0nV2mgPpFTFEnjrYM7YQJvwhFh3x1ZTEW9uhxdc4+vm4el3IPPjjT4Rh4x44WOGdiDUYn88FH19Dh02z0e0HfZAPuo7c7nqYWN75Nmb87X7V2oZwVsWlLaMH0V5ozQVVyDLCaK5eVMrTsTVYb4tPjiQiO3MtZunYxfB4FURfbAt8TJTDeyubAwFJ2vkGMGvb54vZNKN6iEuytEmvRDercl1Q/s8s8eq5VsFmwE9twF89qZ2fjkQ8dpn/6ihRzwhQZ7iM5upYtO4rtWLY9d5IFkgVTHgMZJ+KuVuscd3qlxN7f5thR3Evz1iVqIGKdt+rxqFCffMLasXPy9WP
 GcNJoywZ
 JC5zr1A9y9RUYjmdKPwT9dRJwL3OV8T88gQ810XO9dnhlcOtaVkD4UDwjwH+1lAiFxQnBvj+f5dijO8MIGAPw8PFvaPn18Kz4x4pFm6vaga1/GpSkO9Y7gLju9ydzmbh1jJVSgTtvOBWUNCrTAEbEe+FFcnYCwQuzfN5cxEInaR/7Ck3sdMLpEM1xjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 21:13:30 +0200
"David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Thanks, that makes sense!
> 
> So, would it be fair to say that, in general, what's exposed through
> 
> 	/sys/kernel/tracing/events/
> 
> is stable ABI?

It's only stable if something depends on it. It changes all the time.
It's only when someone complains about it that it becomes "stable"!

-- Steve

