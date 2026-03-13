Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07BE4105F781
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 09:20:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CFA86B0005; Fri, 13 Mar 2026 05:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D8C6B0088; Fri, 13 Mar 2026 05:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3C56B0089; Fri, 13 Mar 2026 05:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0B4C26B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:20:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E27E13BC07
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:20:30 +0000 (UTC)
X-FDA: 84540494220.02.875AE07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id BE9EB20005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:20:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GOgCDnG7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773393628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=N+9SPXQmuvXlDb3raI6mdQkp5IDWn/LgLI2wxktYHQo=;
	b=uYm4o+1Tyq1cq8qFfU+88SVsmNGNaE7yCQXz0HqfXrHc6gmB7d12waXWHP/u13E7bgkn8P
	21kt8yo87Y1BzptJU10PETjcbIx+vkpeOHnQASRZk1Wuii8HneDnDTRTUsmwYPkvQhJmQA
	tARa2jNYS8NTGl9w1y7LIWJHFBoGvHs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773393628; a=rsa-sha256;
	cv=none;
	b=QVv7IONx/GhwKQ5iLLuu3aaba/ySklH8evIwkGSmD7cZkpTlhz1UaUM14Mew2WShSAKQom
	rZmExjgrQRDO9gazW/OnnE9/jhrmy1dMVSY1Kt9Jr9CB2k9xKHPWw6ABGi14F+jF9BQV6y
	elaNU7EpcvvuUMDUlhVH5OJ6IffRN4E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GOgCDnG7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 73A5743650;
	Fri, 13 Mar 2026 09:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF4DC19421;
	Fri, 13 Mar 2026 09:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773393627;
	bh=HsNnN1Pn91LzaF3IAb3xI53vglIsVSL5eymXeouw0sQ=;
	h=Date:From:Subject:To:Cc:From;
	b=GOgCDnG7X1VCoYONbw4nrOC+zzPrCKPo3NlD2qA3R+OvlTGVZZrShrrPhuusfc5ug
	 Cg5Pw3MySATuRaLTe7OmKfwMe3gC9sKXOo4yeS3YCC96qBsrbJwlRYhWDfTS161KXt
	 5hs94BcG2IkGjm8FgP4Ky6iqUx06X9U9h+ZAYnH/qndPwGAkzO7QyaY33XupcAgFW6
	 fQTc1gUENgx11iv4nrr7v5E4E67FmrSYe9JwTC5HxBaERju1WXbWoVjzihaNMa6u2z
	 IaZtLKvgRiZoa94Kp88p85d3i6R+hJaiAQPHsWfDPJ8Iu1rM1m+18Ntf3qwajlquvl
	 UVZBrI1E2lViw==
Message-ID: <77adefa6-8aa8-44ad-bb01-9f1fe33c8f7d@kernel.org>
Date: Fri, 13 Mar 2026 10:20:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [GIT PULL] slab fixes for 7.0-rc3
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, Hao Li <hao.li@linux.dev>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BE9EB20005
X-Stat-Signature: nc4is1ioeukwmbrcd674ezhm5khp7b9w
X-Rspam-User: 
X-HE-Tag: 1773393628-387377
X-HE-Meta: U2FsdGVkX1+XaGcKB6mYp1al7yV2w71vFdgwKn2l/655v911ZlyAQIxsQk4UO21R23AefJR15qHe9qtFyUUCQszh4E/LvG2zZDK7w4E3C5/hSGqTgc5QTusOTMj/LFTuEiI88DvgoUKNDoxv/8FOpOqeO2gFOKnJwksuzuJpY9WYiMUmPMOgRg0vpCewOPUBHMJ3B4CneAd9PIocAdVZPSak6rBTBY5ZFwvX/C6LpZ+V229EVKIsebaPh0h+Mc4+uhKmZLHsPRrk9c9otHX3fltbs6IeYuqSyR3fZUrA4KAeQGRPHIf8ucWLZ53EYwNYGpdLE2lxeeK8ee+gt62M2jcpxLLG1cgSX4fgKLh0SPcpPeNXhmz2qtt91TQEGg6JlSj+btkyMk768ziSZkCOHF4MNMp98fpTOW68glzxT9iGeBvc9lRYX9edoU9Bkvq2EMhTgL8S4UuSz0Owb68z3JSUvzoZyazdsEzK1HcRoASYOaNfz8R/GrZFZLLsIAWX+9XcTjCt/t1ctUPsPkCfxgMxJqVd6ZRgEE0JahCbxlRufCnmiPR5+Bi7bQJrbsPX9E7nJGynBVFZsEoQtlnrs/oQyhJTgdT7YQlCJbo1SBCfnG6auWmJ9mCsGyZqDY2wWEVJNcAdXjauHokKJ2XZPEMNZW9L7aSy3fjoo3NR/x5uhG9wpnp8Vlq5+3jjUGigRLbRDDsDf7XMqKQ+AHlm7SIPqc8O2/tqd4G0doMcPlmy7URiVPKt/6jP6uACAcj9+pMNez3nn0kT2cgM9/IWra8GLTahQRwJjue0lN0hmAmvjkNgrnP6baIMZyGysi3d5RkGIXZ9Pkv2mHvKWvXq7Hd7c+TosxV1sKnfTC66f5EehPbXedQVSQI2vK4/Vi2aU3bdoz2zwvsRnYKzLPGQxtizs+NQk4QSGPJxRql7jtqdTFg3RN2JtPYus7NNAzJ+cweqRrm8KVaJS8EFwHW
 p8ZDGcTz
 8JJxGAcLu23DDM6lhCKt8WO73BnJ/J2JvozLqUfsxdHDVXTrFn/d8qNob0VlWX6J/blkmilvGY6g5pfQ4l3VpUIL1bEFz3NgEiTza6SaE2tuze2928LSKTmRHU0Peb4sPngZZmHghKNrQ9MuQI7EOMpR7/tpwLsN47jEMo4YQvuZSVKv7gKlgA8zYZBBqdIbWSSbYbPlYhkPWUYUooNTnXImXsqGBfDFlCsUYvgAlKzGvPXillivdFgnfJamQi3EncC1TRZNsGAAyOS0224aDtBDP56Uy2ghp1TvJCjhW37/LmHNhT2ZfDxVbZsp45kaMToNT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-rc3

Thanks,
Vlastimil

======================================

- Fix for a memory leak that can occur when already so low on memory that we
  can't allocate a new slab anymore. (Qing Wang)

- Fix for a case where slabobj_ext array for a slab might be allocated from
  the same slab, making it permanently non-freeable. (Harry Yoo)

----------------------------------------------------------------
The following changes since commit 6432f15c818cb30eec7c4ca378ecdebd9796f741:

  mm/slab: change stride type from unsigned short to unsigned int (2026-03-04 11:05:57 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-rc3

for you to fetch changes up to 464b1c115852fe025635ae2065e00caced184d92:

  slab: fix memory leak when refill_sheaf() fails (2026-03-11 17:55:26 +0100)

----------------------------------------------------------------
slab fixes for 7.0-rc3

----------------------------------------------------------------
Harry Yoo (1):
      mm/slab: fix an incorrect check in obj_exts_alloc_size()

Qing Wang (1):
      slab: fix memory leak when refill_sheaf() fails

 mm/slub.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

