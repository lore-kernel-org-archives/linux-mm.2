Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72DA5CD4F25
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC7C76B0092; Tue, 12 May 2026 10:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78FD6B0095; Tue, 12 May 2026 10:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A68036B0098; Tue, 12 May 2026 10:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 91C176B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:10:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5602A1C0FB7
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:10:54 +0000 (UTC)
X-FDA: 84758954028.23.AF38E01
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9FA9380002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:10:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SLBC9DHS;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778595052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9vgovai2qZ4+GTWVA7dNoj3PLQixVC0z5zMzu0oHkk=;
	b=GMnbsqKMSnFjJJys6KOowXUtt09R+H70H0WlqmRohCwJkfy2XT+GQ4DrinWRcl+OfYkQpM
	+9s1QXuugEIttnxkB5RRwoYtRZIXZPI6KS1daSZiWDV7QwEVHdwzYeB9azJswBE+zS0y8R
	NdXDA3V+KHjRIMnsqeeaBiujjG0oSgI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778595052; a=rsa-sha256;
	cv=none;
	b=0GxfTHzHEZa7PPFbceDPK0Ky8wtLwFGz84ouhybkOc99gNUUqtcpcNTrWncOZoqS0ItmOP
	mW3+fQ1sIdA9qocMHnrDXmITXe9rEBAwJbZAy1Xo9J0Du9QT9G3heoN3aZhMm00Y+zpIWb
	F4GNCzlPrffLxpayyp2P9FEyBDfd7p4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SLBC9DHS;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 29B966183F;
	Tue, 12 May 2026 14:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B8FC2BCB0;
	Tue, 12 May 2026 14:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778595051;
	bh=anjlqCUoPbEaiZ19uaavn8uvI4scPPxpypmtBvx16XE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=SLBC9DHS28emqubhd4NrBcWrLVdJZKmDve1jZ/ycL5EUF0aCngHlZRI7Q+ac4+jSv
	 Fn/COdzXAZxzZoGd4N3+4cx7wtfAB39uxiA0ZmaTK3W8m70vm8n2mobaZyty34a4OK
	 Y5FIlJVilBNancIc9JKK3hr/zQX/zMPxLno5EEwZLXsFPQ5EgnzArTx9kbyPvViC/G
	 y2t5JuwbDOG2KGkTSdS/GpJHTH/AwDH+mqQujcjeiIECewbsH4UltssS2a1fRwkGwh
	 4adPzZgqCLoD/37zMVOHgPk6OfIFV7IeqWy9V/9evzeGcFrZkvXklp2Cv8JB3jmq+I
	 xddlA+mWYRhcg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  skhawaja@google.com,
  graf@amazon.com
Subject: Re: [PATCH 5/5] selftests/liveupdate: Add stress-files kexec test
In-Reply-To: <20260414200237.444170-6-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Tue, 14 Apr 2026 20:02:37 +0000")
References: <20260414200237.444170-1-pasha.tatashin@soleen.com>
	<20260414200237.444170-6-pasha.tatashin@soleen.com>
Date: Tue, 12 May 2026 16:10:48 +0200
Message-ID: <2vxzh5ocafbr.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9FA9380002
X-Rspam-User: 
X-Stat-Signature: t737oy64d5eztxkmmyjpp14xhps4rzzq
X-HE-Tag: 1778595052-995649
X-HE-Meta: U2FsdGVkX18q31V7brcmIxvaxzjKqoiNHhUkB/vWJJEEFenuXaWVrghX1nbPreinAKYXYAtairnjoctF/V+KZovZ8kWoFiSZBAhsVU2NyQTxrkZYeP5sSmzAHaohKu1WrmFQ0lhmxj74EFv0SOsU0a6mhD+m+qN89Ero5Pm/g2Ww+Lj5ctw45jkQcvO687BpYgxnvz/vFku7g+/7qjTCN/w3+CuArAp79Oc3ayWDAnsM2rw7kLoRxp80D7nZMQVncj75gVtVM9NoOCYfBQaFjP31pOvBBTSqChr5F0iJkIPC3SU5In7a/gO8lPx4z/bwOrUnD/dm60gHYPgc5FkPR/dX/ihlmseVW+tQS0hMp9eMVk6HY1ULx0HQe5X7X71XpKiCsLu9FOvQliGBhwK+QvOKs4uA0GvHftIhK/nvG6nLEup51aqJGsKriLCzqLPQYkdyu4edtwwHBd8WTKCJgaNR8girU08AWgAkQCNbHwEX2GiIpfqTQoaLXGAL5PafimQ+IOmQoOAzNXB5ljXfgX4pu6Oz5aiiop8WgIyJc2snNo9Lm0AIS4T/3YNM9h8aEcA8AoMb6eEBjmh0h+WJ5B3BsLWzrL9BhV9k+o4zpdB0h5xvfC8f+KZ87WRCXdxqBFNI7VuZoqL7Kedeszx5Jxz9qPnkVQa30FrCM0e5DQY5gWMBluDv4J9iVgBTPtqyZ+28f6nqHgotL+/Bclme4RVwnlemB3FpF7gS6QIcoyb7mfjABTHa9ZSx1EqxcYAb7cEu7XP9i1fWv2thEUbN/VdY6XkZ9+BYjrCq8xx7C0Lhe+QG6HbO/i7xmniv+V5N9g4ibYtl/TAAs24nQE6rzBCJFPqXdcavYKoSWQ2YfKBBv9Q+uY+our+uzYKOpJ0jf3NRSBVnoddiFeeGxBtiiRU06FVDg48pKv5flMLQZhgFagcu7v6t2hBr65JktOQY756+SufXnl5EuLXsLvO
 p8ins1Qp
 MGbmdeLR+FdcMAxyPGN1TA8Fr7UmbqOLmQlyKw0ox7OyuI+37sf/1K5XBPeRP5Jn5N4njBhhSRA0UjQhow9Pryt21wWwTtKTJ+wvQUEz9lI1xEdz+P1mPDbQ8Dq2RdEiNy51TGlx5qD+pb+29gtpo4QfsNDPlx6jZLe5jRq6tvjpp31DcoJvWVloCCTZGBTtkC5GKpbUNLdoB/8BvI5SKB3n1qR8RPTodfdu/KTA/JFGKDmQF4m1JmEMJOaYpQnv7/Fhd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14 2026, Pasha Tatashin wrote:

> Add a new luo_stress_files kexec test that verifies preserving and
> retrieving 500 files across a kexec reboot.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

-- 
Regards,
Pratyush Yadav

