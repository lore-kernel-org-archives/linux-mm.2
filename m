Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4018BC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 17:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F3346B02DA; Mon, 17 Aug 2026 13:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3006B0644; Mon, 17 Aug 2026 13:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B9A16B088F; Mon, 17 Aug 2026 13:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D94326B02DA
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:54:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 535821C1CD2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:54:21 +0000 (UTC)
X-FDA: 85111510722.28.0F8EF17
Received: from mta0.migadu.com (out-194.mta0.migadu.com [91.218.175.194])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1680440004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:54:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RE0Eq1rl;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.194 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786989259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cv5L8kwL6B87EoZv16i+GOhfYvnN2n6+gPat/nD2Fbo=;
	b=Sbt+zFK2xRTQrHRwiqESxaWeMztu7/wH1WVrFHvzLK5N5OsxUZhy4RXp5Pkb8UL+02ST32
	3PQTEVO8JNkWINDKqblJFc14OfiU1tqat25FStNw+8dXMIH14+DoGpC6gRxoY2ApZptKcN
	nnnn3qIutz1ee/3UEULLiFl6BL2UJ8A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RE0Eq1rl;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.194 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786989259;
	b=2O6PyC9qfVd5Vt5bZPM2KM2sXrRNlAcDFr+yD6ab2pa3DZAohTldzdZOwYl4VDCO8q6p2q
	1u1/QxfQDQLx0sk9eeYlYZW0uMOs0YeVLTSxrl26/Kp/DgQri7/xus5o4ZKDbXAtRvPtar
	hGksDMb1R/c0CFpKjVk2XrF5vf3Di5Y=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m1ED9yFio5Z+HXwoOeZ7XuPsrrjwmftWHlmKu2Sgup0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786989257; v=1; x=1787594057;
 b=RE0Eq1rlYua2YPX00a/IdUGz2NVWXyNW6dnVNYqFeGZDoEjZtxkFwr5w2uvNa2UUkCiC3Mhm
 0YvLiJPzVLR7lcPmT6SUxMpTlxcWqeolSdzI8FIl4/Vuq2n5Bm/PJzLDbb0a3OcyUtjzwxiyY8+
 CNOKJd9Uny/vAqjM0fh0y3kY=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:58::)
	by smtp.migadu.com with ESMTPS id cd6362939fe0a13b;
	Mon, 17 Aug 2026 17:54:17 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 10:54:16 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usama.arif@linux.dev>, cgroups@vger.kernel.org, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@kernel.org, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	david@kernel.org, kernel-team@meta.com, kernel test robot <yi1.lai@intel.com>
Subject: Re: [PATCH] mm/memcontrol: avoid false sharing between vmstats and
 events
Message-ID: <aoNKX83dql7_kzFa@linux.dev>
References: <20260817103835.2937733-1-usama.arif@linux.dev>
 <20260817104340.c9bd2dae70d4fa31fd66b216@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817104340.c9bd2dae70d4fa31fd66b216@linux-foundation.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1680440004
X-Stat-Signature: mfdbkwkomjy8fxqtc86zimhzuutczct6
X-Rspam-User: 
X-HE-Tag: 1786989258-425359
X-HE-Meta: U2FsdGVkX18V9aEBMAYgc+qZZsLEzl/x8X3PwFQf9piGKIJ49xhrpmE/kgcrynXMrJSwN2mK/9DNk5FzC0Pyr8kZ5AMxxmigF8Mv+InA/q7zHlTPmpOt909lw2R3cBSgQbdKsvpAo0viNRfubHinsaWT6eEkMG5b84IW5u5Dsre3wgo3ODR8IS6NDO9wZUw//0Fl6SkZt0uum/yZZ4sZW3hu+2NgaSUXnZiBeBSkgOpQbT/kTu4QCvGBmR1k+FE1NEAHrGI04GyF1ODvtogTg5Hpr18GNh8rTO7RuH8EhlgtWlFeAi52IhHKg96JAFIag/RboqLe+OkSGMNPZUO07kNPya5v3PV4EzJokTCySGJcUulMsQqEZXiCYqyuoaMMp+JvrZlnVzVBGduhhvL/rKUfsADeC4pT6uLIe4nnUPuRPYle9SNVy0D0ffUCkTCfazfpd3b6gQ5APXlSMdouqMGi1v6zj//TNyQIUUx5wUADNxaDzJAlndklfjQKkPz3QGUYRSlsr7xdLs7X5zuZ4D87DmF/6GRW5+MVSn9fEOVq9pX7K+GY6KTEiS8nhLsDNiIPDaxPV00JUmMxpxq3OgkqHo1K1mgFcKDvJR18dwLNLNGUgpSQ2MbehlGHR85nnSsLoAzHLHZmXrsq1ayWoHMyYieZ/EQOlvVc+tJcMKWlVUUZqVSGcstKRAlWOvYBJvmIVdsUZu061ny836WJm6FvXY2xAorNPJExXWK08xBRoNypNIAXwRjU2UhJbrNkP2CqBUy4FUub3tEF3myhC1F+CNoGc3LbUdIGVYyTEYeoYcEIkhMh3fNzaLAi2nT62XGFQRlQVFoh1tW5mmlRCTymCHKGNKFDhMnTEt83yFe1x9q3Tf0CSfzt9b+Szp/oQth8lZM1+jvDPJj1w5X5LNz9IZre4/nkUn9a9abPnaW+6PlAmSj+MPnxuEvufDLblPXzpfvh/9XGEowi/oI
 Xp6fFKAi
 39N0FKPJk+leUwYbUD/UeB9Bq71UYwHTap5V2Jv5qHRo7a9Qfx+oU6cDXM7iTmRFruf7GqXkW5NOoZSeGI++Ay9ulJf/SQQVLrID3NNQkhL8gu5YO5v0cIi/nwQ/vR/5hr1cvjQ17j0WZfN46i+ZACwG87udEaqkEyypEwbUCjpywE83V/b1bXxVnu+5JBxgsx7R2niuFwiAkKFnF3J2kUXn84qmncpY+vkj3QYsQ3dizXjBk1+dBkK/kBKBNKiPLTV/MFwUTDs8zFw3hocQdIC0LUF1JUbqTGbeHq183A8X7vMqsrivIABAYKX0tLLHzoCYszo1ic1xklnDgdMhFHXGfvZcjjp+6oKlGBqKS+za1cBngXtMF9dBgyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 10:43:40AM -0700, Andrew Morton wrote:
> On Mon, 17 Aug 2026 03:38:35 -0700 Usama Arif <usama.arif@linux.dev> wrote:
> 
> > Moving v1 userspace eventfd handling into memcontrol-v1.c shrank
> > struct vmpressure from 112 to 24 bytes when CONFIG_MEMCG_V1 is disabled.
> > This moved memory_events_local[MEMCG_SWAP_FAIL] and the hot
> > vmstats_percpu pointer onto the same cacheline.
> > 
> > The stress-ng mremap stressor exercises MADV_PAGEOUT with swap
> > disabled, generating about 20 million MEMCG_SWAP_FAIL updates per
> > 60-second run on a 176-CPU test system.  Those writes bounce the line
> > while memcg statistics paths load vmstats_percpu.
> > 
> > Move cgwb_list into the existing alignment gap and cacheline-align
> > vmstats_percpu.  This separates the pointer from the event counters
> > without increasing the size of struct mem_cgroup in the tested
> > configuration.
> > 
> > The blamed commit reduced median mremap throughput by 4.38% on the
> > test system with one socket. The patched kernel brings the performance
> > to within 0.5% of the parent which is within the observed boot-to-boot
> > spread (up to 1.2%).
> 
> Cool, thanks.
> 
> > Fixes: ea928e9e18da ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c")
> 
> That's in mm-stable so I'll squeeze this fix into next week's 7.3-rc1
> merge pile.

Thanks Andrew. We should also add the following tag due to http://lore.kernel.org/aoAABX59IzUXz/Rv@ly-workstation

Tested-by: kernel test robot <yi1.lai@intel.com>
> 
> 

