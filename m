Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98960FF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 05:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E06F6B0088; Sun, 26 Apr 2026 01:29:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569706B0092; Sun, 26 Apr 2026 01:29:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4031B6B008C; Sun, 26 Apr 2026 01:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 290336B0088
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 01:29:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42B1F404A3
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 05:29:07 +0000 (UTC)
X-FDA: 84699578334.26.1191473
Received: from out203-205-221-242.mail.qq.com (out203-205-221-242.mail.qq.com [203.205.221.242])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7E82040007
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 05:29:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=kYLA3gHp;
	spf=pass (imf27.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.242 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777181345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fJzK7fYSTENSwy7tb5eInzJUIcvx0OrIylZwUTjYx3o=;
	b=NZHOzsLxlm2bWyxzTOdEj2ORn9Mq6lg0dwASf/l6kdWvnjslyMFfG0YY/zZFt4/EnQv0W+
	5BrH7PYSkCsLAYjmWAWESwlCwV6Ztv92nMWNoW3UfJS+XsugK2dfe1xuWzfdsmSsk/Xy+r
	YEHeMInzacFuF1CeVHcjsosNmKa8WtA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=kYLA3gHp;
	spf=pass (imf27.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.242 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777181345; a=rsa-sha256;
	cv=none;
	b=DV7+rvZzq9KTmtFHwo+wIWyNHvXl9bWG6cR4WzDwrtCea6KFDVT6AOz581Y8DCeYWvoFMy
	amZ0qnzLMa3l78SFmoI5vz+tP192K2B2q0HE4WLvnlzF95OYeoLZqYM0Wzqi+DLlFqm6De
	dG/DN9Kk2SKZQTyk6g4H3Byzp0DOddc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777181339; bh=fJzK7fYSTENSwy7tb5eInzJUIcvx0OrIylZwUTjYx3o=;
	h=From:To:Cc:Subject:Date;
	b=kYLA3gHpU62/rT2nakExAhuZNADlk41miFQQPqw28OcIt9PPhDm/C6XBlCF8xV2g+
	 vZvPdzfZU1DHOsk25ZRaFsidnIwSex2G5LGLD9nHFG9vbqKziqljG181Q531+vibro
	 xyciBgRY5VHImjjZ0FcHFDqahiOOS+zC0Xgb8fGw=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 7391CC41; Sun, 26 Apr 2026 13:28:57 +0800
X-QQ-mid: xmsmtpt1777181337tx3x3duaf
Message-ID: <tencent_824873CD3C7F2A76CD237A308C00DF18580A@qq.com>
X-QQ-XMAILINFO: MMwjR1C73eIssL4KMfUOf3T/tY8xwb1Uz0J+7c1nlVnjDmueEDWiJJpaKsXwRd
	 SMEf/RhCqQQWvyZtJXudSG04zsVabcaJbcqRjRKz8Wb5GKPbMmGh2Fkvuv0felwl3MpOiKPrmykd
	 GdkSAAxv6/zYiLM5vzGm4/CsKs/evYBHO74HwPKWa++xoTxF+ArgLAlhm13QASQbWylGsp6caUGC
	 zk8tfXhgQUdEIpLgmjtKRxbPoqgYqjkjznv2dX3u+qAPgk3G5iGp3jHkUHaDBHCbbiaqeeX5d5RQ
	 zx57G6kM0KiObP5K34jk7+I6hBaQaybEZC7+ddtet1wWYOntW1AaVhfaPhUpDK/C3Z2PWsC0i8UP
	 MGYbptXuGJezmZMkDjW4D4UWT9ZV7LiJyCblVQKufGms1w/gD+P8N6JYoM+V+LtxKdem/h6Zx4uA
	 9BD7dJW3G9Yc5rZpGClcRv04h+vpgL+6yl7VL8hs9/1axyIUGaRIOxgYxsKUSkXQFjyvRfjy6hN6
	 mYUvDYKyfR7Keeugy6wEo2ZnRY08FOuaCqA/shtg64r43teM+HwUm6oUD4VzsKa1BkSC1hpUok+V
	 4jMoYp49Mf+aK728JiVfTZ5p+XlMjU3vXk8ti+/DqROPnztkF8g0oQTloyj5QLRA5ZdzedQvTT1+
	 P3Z56Q6Wy7tJ5O/RdUJFwyPTpiJBGmE5qv6ZTZgF4orB6DF/Vs/SAvBcVQ1WBa1Fx6BCkqsGpXEg
	 SG4UbCkUH7bPWxb+y8IBfJJgAPyAIAXH3e19NcuXb08RlpT6KXCquKrvsAOxysHuf/6Og4l6NUJ1
	 G0rLDfb4iFMQP7bx5VJhgUn0Nj10crps93zcIwwXw5xjbw5696CwecXAdlqZAphqmeflnfiVL5++
	 x3OP7j8qBuc3DBtvLrMwKk0TpFTq+SWpwcx7b+ytI6PA0cPpATYCmBYkKT2pqj8Ay/7kpU6hGrCX
	 +t3AhDCZyvy92szfvGJHKtU4Y7xkck5yp8rLafVLJtPa0BiMes19yHdGIDNQVe94sgm9RLkvepPd
	 IiiV8N3A==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: fujunjie <fujunjie1@qq.com>
To: akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	fujunjie <fujunjie1@qq.com>
Subject: [RFC PATCH 0/1] mm/vmalloc: reclaim tail resources on large vrealloc() shrink
Date: Sun, 26 Apr 2026 05:28:56 +0000
X-OQ-MSGID: <cover.1777181243.git.fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7E82040007
X-Stat-Signature: 9anrhobagyunt4hmqqb6ixfzn56bh73u
X-HE-Tag: 1777181343-177018
X-HE-Meta: U2FsdGVkX1/dmmpowXpwllA6z0jkdO5xnzLsFvNy8zmC6H5P1chSX91CbqixDkHbl+zijHGv4G8BEPDlPLlR3lYxzkIcKG32Ph2r/m0/9t4u5WTnWTHv7Kf4CpP6RMfMk+mDMP6lum6PblUsm4xTg0nMjAvVmYpy0vNwCX65g8AB4/OhLy+sGTyb3JffgYAv0GGXWouwi8/txhikgqqhx1ue+IuMR8xr6Nmg+DvwLpfsrCHRet1lNfo5i6/jqr2ThO/zRE+1gfIHpMaRYiM7LdFStSZGDv+dDjrSycKTFaUNuH3WdcuR4VnXszhL/XXz0f+xqWTMkJ22dlo/g6eoRl57VU73fslXQeX3wQcif29g2jc7OPrQXogXAxJ2dqUgPhb/sgGm8rUPrBgYv2nWUndZrGmPOE9AM9NAaF09S7Uj0/3BDF3fK4cDc1r/G5pRggodlVsXA1rbsxLehMUGK6YPMkBGV/WebAZV1Ym3YyAUXkxQf8jt7WjPcBrxEOOdj2NyESD33+jfDhGk6YiRnDFLcAWrSaOAf/5wMfoHBdDb7Vop548JIld1QvXDZowSTRlXpQ4ryPzsnVBP5VRP5XgTo9agWNFp3XHzo/+/wC/Kj9oewFzZozVZAB+PfOrN0TTQli5IM/SxpYJcukdcrYoLZ+QnXXGjMqfsnPqbFWfm+UTkp3lcAfvNipooSngdMBE1cpCNKuIx9sEXc8kyXUw73wRr6Eso4CuYAo60SAdc3qywn4npIkRK3QcV79AAFgBB7tTseDeztgnboQ7bAxU/zHabygFR5SOIuRDta0JsuU0Pz8TNXpW2mH6SzjREpA3TTh1vxvET0EpPMeJ9ZKhdQV5oHHPCMMp8WJUocu4GI9I+vOtSFnD/oV50cIN0ObbnDdoslisvVSviJvbbfr4nQ26FSaR7dl4yfxHu+Al+oKgDsL3UR+NG/tbCFbpYcmBByBtkvkNQhabtYsE
 k7j1e+rH
 hkujWRlV0hFiVLHk+joF19sZzmcWjoRY+BbK8P6Uy3sXjMfO1mKGFrn205IYNjS/3pc2JyWKxrcn5q4wBfjL98x95iSM2mJcVXX/mQwgaRXibR8U8QzsFBFU0eaibBd0avMa6Pnoxrv9xjFdPILiBMRLXDeHgnIU0yoIQeV/Kb4mpmctTGRSvZquidHdZBSYwCOJGZLfeUoJxvfutQeCk1EOzp9zp4UrCnEeFydddkqfcsliEnNJGSpBA7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This RFC explores closing the resource retention gap in the vmalloc-backed
shrink path of vrealloc().

Today, when a vmalloc-backed allocation is shrunk, vrealloc() updates the
requested size but can keep most of the old vmalloc mapping and backing pages
alive. For sufficiently large shrink operations, this can retain a large amount
of tail resources even though the logical object became much smaller.

This first RFC keeps the scope intentionally conservative:

- only ordinary VM_ALLOC areas
- only page_order == 0 allocations
- skip more complex vmalloc object types
- only reclaim tail resources when the retained waste is at least PMD_SIZE

The current evidence supports this as a resource reclamation fix rather than a
workload-tuned performance optimization. Local validation currently covers:

- synthetic large shrink correctness
- shrink-then-grow regression
- threshold boundary correctness for the current heuristic
- KASAN run-rootfs vmalloc_oob regression coverage

I would especially appreciate feedback on:

1. whether this shrink direction is desirable upstream at all
2. whether the initial object-type restrictions are reasonable
3. whether a conservative PMD_SIZE threshold is an acceptable first heuristic
4. what kind of in-tree regression test would be preferred

Thanks.

fujunjie (1):
  mm/vmalloc: reclaim tail resources on large vrealloc() shrink

 mm/vmalloc.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 100 insertions(+), 5 deletions(-)

-- 
2.34.1


