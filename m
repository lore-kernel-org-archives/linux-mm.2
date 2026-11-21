Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DD85606A33B
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 04:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=x8GICWD4
Received: by kanga.kvack.org (Postfix)
	id C662A6B00EF; Fri, 20 Nov 2026 23:10:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C171B6B05B0; Fri, 20 Nov 2026 23:10:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2DB36B05B1; Fri, 20 Nov 2026 23:10:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 266F76B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:10:16 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5365D120301
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 04:10:15 +0000 (UTC)
X-FDA: 85457798790.17.5C57D42
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	by imf14.hostedemail.com (Postfix) with ESMTP id 50AB2100005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 04:10:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=x8GICWD4;
	dmarc=fail reason="No valid SPF" header.from=linux-m68k.org (policy=none);
	spf=none (imf14.hostedemail.com: domain of fthain@linux-m68k.org has no SPF policy when checking 103.168.172.145) smtp.mailfrom=fthain@linux-m68k.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795234213;
	b=YApdcxYriEbtinEHETWlAGWtvjXnfiUtAY/omppGz51rnFdeOdUPkRKMFNqJ6ocvA+tbZ8
	9cyDz6VdHOLI+fYBnlEYqLN8Bf6O3IWpnCOb1r1Fj+uO4UoRmkaAHtne5dwa+OmnuQ+ftD
	aZy+LDhKWw/jI1ff0bJ5IweIsUSqKdM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795234213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V/ZfUxjm7VkyBHyByjR7jRTw9kA/DfQjZiBXJ4WYVbw=;
	b=wdSkzcdbAgoAZJC9U4sdYAcZoxQ6ppwNtySRVUPZDt6ySzW3iNkAInWZsg5Rr7avisMHuW
	g2JrC1z/iHuopebFDWFe6MN81nVohb5hg/re7FJXKVnwaLnh9lF1DeIoQumWrsUQ5sbTDC
	8Yr9on+I+lnlU5+jiYKprk/0Pk8USeM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=x8GICWD4;
	dmarc=fail reason="No valid SPF" header.from=linux-m68k.org (policy=none);
	spf=none (imf14.hostedemail.com: domain of fthain@linux-m68k.org has no SPF policy when checking 103.168.172.145) smtp.mailfrom=fthain@linux-m68k.org
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 85CD8EC0C22;
	Fri, 20 Nov 2026 23:10:12 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 20 Nov 2026 23:10:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795234212; x=1795320612; bh=V/ZfUxjm7VkyBHyByjR7jRTw9kA/DfQjZiB
	XJ4WYVbw=; b=x8GICWD4UoDMvXS68x4O4raIRV//lKadGXkbR+0GkMwSLKHNN3a
	l65ZMHAOpoRExR7pAIvihhPjQGT3B+CeCPEqupiPdS+y8m4qWGZ0gFpOiAf3WOyQ
	HXEPJYXyYELOEC6BDLHbodcnTwzVV3AE1F7UpDMoJby54p6nhGHYXquXPb2CJU5w
	jYZKsTebidgw58LYURef+XgVl2Vvo0E0IHKmrSBdHyUYlRxcToqjV9PzNEE2to69
	9SiQnb828hKNRHd/0vTC9yk7rdxaIXohwi80VCCcKKU8Oq7mBsVOUl4cZeajtcfZ
	YTBS3+mVttGKchkvH2ImD7jWE+U1EC5PLLw==
X-ME-Sender: <xms:oxkBa3_mj_f_gnNZhkN3ShMI9QrSQF8vMo8R673cBuK0m2EVP3DZkg>
    <xme:oxkBa9CtXDTbRboHpek_vq2QxNVXphewrT1_3YqsK2S2sYZ8AgrCsexDWypt8KOs7
    An0ZVmTZSlTXZtRd21vXqRaX0sswChd5bVReTsoWaXbyefruZSL1n0>
X-ME-Received: <xmr:oxkBa8Sw1JHyWSpg0ZGJunlZh2DyuYd5kKA4PTgFCfkO4O0XltAeKO-oT8hj89JEMpKCoyr_LD2OfzuTy7M61nZKhGlg1c0YH5A>
X-ME-Proxy-Cause: dmFkZTGD4fLbFmQBkWa7VJDwENrHmzx1MAeeBGv5VgoUdl7GYZCUtedTAG5hE6WZtkUvp2
    jAxj0aDLHn5ZP0N9STxC5xdAbnE0dTF3qbtjthBjKPJ8Xsg3BQKLzjqyD6oP3zVt3yoPRR
    vNfzy4cMdcP814aPPyf/BWEw8HV2TY/g0kehcIDNvbT1J5MpDpxMMSdo3VH7ucRWfBF/Vy
    GZz+6B1N9UgoWYOU6ZK0DviVw9YdJhilwDMtQCMhN4cEAWiNbwHxYR9iyQ6mNgMN85GVZk
    QAOliH/uQm3sqP7RJJsYaZ9dt5fbOXYVQzeMVjmtVn+hF0yO5K3Iw5fCUS41YyOlTc5LBM
    smdKMjYaK+8NATKUP2Xdh1tgnP5RghKgOENnJ3sSyIqkf7N5MrdULnt9MMPtaDzG9OJdqD
    PLjiEE+l19d/S1OL9XToIkbZrI7c0RVSl/g/aoaUewq9zXhvua/NuT3GsZA4XTt0GqxaYI
    9zUxhmWzhxREwooMd8UeI0kW1XmyJ581hXq4X57YbBbQYwuKroBTAvrSkrjXS1IYhGJt8V
    iTPHzuj4vtNYyCyjma9N7uuEFw9teoFZAcOYTJfCx888gRUlxRBZP78R2Ti4PgJTuuWfSQ
    wK4/4NtKUGUCxVqKwprh9irouxF+izv1AN5Am/1bYfPQV3gfEhrtcAcfT2WQ
X-ME-Proxy: <xmx:oxkBa0t6P6pw-Udkc6dfiSa5yNT73qkgqAfAJMkl2BSqo3iIMduBNQ>
    <xmx:oxkBa43qElqcSN6y_5x8IPKnFPpP0M-AtQ2SWPu9L0c76O3bOsE5jA>
    <xmx:oxkBa1WQktdHrofSNid1wbZlxky8UhzYTZBX75sAWpnroo8lYqT0lg>
    <xmx:oxkBazKusyYOQSnaO7tLQPZUNByO6OqtMiJaGRr9nje1FBji1FpzFA>
    <xmx:pBkBa3_ka8wtlkl1H0cTDIoa3OHUpoP06-hjcafN-uO9spnFcy3lYCjQ>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Nov 2026 23:10:09 -0500 (EST)
Date: Sat, 21 Nov 2026 15:10:04 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: kernel test robot <lkp@intel.com>
cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Linux Memory Management List <linux-mm@kvack.org>, 
    Arnd Bergmann <arnd@arndb.de>
Subject: Re: include/linux/compiler_types.h:631:45: error: call to
 '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
In-Reply-To: <20261121034304.2dPxVKzk-lkp@intel.com>
Message-ID: <0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org>
References: <20261121034304.2dPxVKzk-lkp@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 50AB2100005
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 18sr3zzd9n9fp3zfqs3peeq7jry6ye4h
X-Rspam-User:
X-HE-Tag: 1795234213-495863
X-HE-Meta: U2FsdGVkX1+J+hZeTF4zdXqk9WCENkg28PnWUUh9yGUWejH3Q3TJQPipn8OW2OyF1CwEgfz0t6Ezp5nMPDRWXUaDCU0djs03oClKV3OpEb5G/emxr8YJSagHq2UGFerqg+Nkv+gGvnwPvpjG7cM9xwjPJQl6uQaEamone1Gkj8JcYtCPikxwTSPklwW9wJ2iFmkOzAGIxeCqiTOsaRQFR1IDRS/zE+UcoB++hFuY19dj/lkd+7ohGt0Y3TD0G38UM6WOwlOdbjsoDCVdc1+GJRKD1DFn7nGFlk/82YICwUkhSVkCexcOUrZioScUYgcvRxd6cML6uB3c4cgA+nqwWuaHqm3qAUcq/qM6pzxpnjCBSz4D2GqPi806Qz+fTNnUArXcVcKroW8FxJ7izxXq0w7VlfJjeLdEGohPgi/PRAvjTnjxYUg2ZWdjZ1lb4ahPW8mgDsqQowOk7WvsF9wnf0VuuhrIU8/Mf5ufz4eESRHyTUTgGQ/VSmysh1jGzUoXHGrXyVGmO8X9p/Xwtc33uwPOlXGLQic10ZS9fTD9Lj9ld+/l96gV0OCwsZQkLn2OaoyZUH42g2uTuBn0z2rAjn10d/0wyHv9Eh00mszOl6CVPxjjGIGMHzWyqYNM9CTQL9EsOcTt2NA8UUOsitdJfbu9s7EAlfo+LyRuUopHrRjY4LV6D31RLTa1Z38RnQwPvNSo9U3MTqIGN8+T3/ljrbMAcrp9BHiejoMPT9Xq6MSrcudxz1btExBPkgr4YJny4od9f3At20XJkaIzK7AGZDF1+p0IFcvW6QEg/qE2sV3UKx3l6X+UkffBP1G/QJvYgnfpwJfOqQmTrTX33xzFsxDCFm50+TkEex2s5+J3S9I/WeiAmJ5wKvPWmNr1oO4hib6Qw4R0sD9lDcwfc5xL+523Yd9OgehVt2sYrbufrySTHnPyXTWLYL4ZZW6JgzU0PvzilRI0bDc9v34XVpr
 hQkTrXMl
 jhlXNnD02VkGW02NGfpMu4doam+smboyYK1KN0GIvl7Z1orzURCe9zRMr4ANeaE5bELFUt/UpV72V5dCUDtdtukoR9e7d9cpJAhw1fagmHZQNkxYsLJQIKn0cizLMbVNeyuAPiGTsMgiZfOvvmBN56WdW7/ua/iPqlnyyoC0mgZGyMTTd3/QkIkPL/E5sg5M/x1GghTOmxLY1a7HUZ3PahWdMXRhWxMINivUx3RgjPrBTEMWYDKnfsXMB0IbFDgdRQ8oeB7XmYw7qREDRSrFDSwYaPIWHY8JrVF/FWIC1pGDUu/pADY3CxrnodpZosTHIcpELYIPcNmiXrUM+h/ZVDG5lZsj6HPkKuvXKnxTztsfanRtv5ER64OQKpAuMlMU62TYBmp0A/L7NyrT0XkqREQUUHcikh2pXR5Hgh5EkC47fIHsKberyNj2Jz0En5e7srrDK6Lrr4qufcbrOiKFkdPgh8BVcGVK2COIXJSC9n48pXciemFzi2F7TKMKyL/vElRPnvcrrToADDRrZ5dOPLDIgYe/7qXYdNO/sUwI42jhmnRM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, 21 Nov 2026, kernel test robot wrote:

> FYI, the error/warning still remains.
> 

That's because the qla2xxx maintainers at Marvell did not respond to any 
of the three fixes I sent. I'm not a paying customer so all bets are off.

