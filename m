Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD4C7C55174
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 18:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B19DF6B0095; Fri, 31 Jul 2026 14:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACAD86B0096; Fri, 31 Jul 2026 14:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E0986B0099; Fri, 31 Jul 2026 14:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9516B0095
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:25:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0B68D1404F6
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:25:45 +0000 (UTC)
X-FDA: 85049900250.10.BDB01AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id F3ECBC000C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:25:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eTH+JeyK;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785522343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4n5dbvA0+vX+AHOmVHzfOZ4kB7eze3wEWZu9Bo3HESs=;
	b=lJkgdH5QIPkjG48pP259nWp963rbAC3KMY4oTSC54hk0nGghzY4fydoRGJbq25ec8wsWTr
	K7/K/ejtW51bBNjKtXyNKRPKriIUYaRrG07KRbrJ9/GFlAnDQHWaLhNVP+0wBXr6WBBuYj
	Din+lbnIfu/7hw5lZ2zEAMuX7y64Dbs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785522343;
	b=IQjCs/6NiVd5dA8uu3hOb+9C7TtJloMshlswAjdtthdWsFkt3kadCJXlGYAtvHekW6iepy
	AsnN20/NkWufy9RDyGLcbHRg58EXuU1HsS0FrpIn6pcfq7dvm74pouDJMDocyT4ghyjrm6
	XeHU/NFHDlu/JmMnMzUP0GbUcgi8X5E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eTH+JeyK;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D611600C3;
	Fri, 31 Jul 2026 18:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F5E1F00AC4;
	Fri, 31 Jul 2026 18:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785522342;
	bh=4n5dbvA0+vX+AHOmVHzfOZ4kB7eze3wEWZu9Bo3HESs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eTH+JeyKhRO+vLnHWTdX17PA3TtGas2fFriy/V6a5UVDkCdwKuqPRQsBu2DcGufPV
	 MXEC2Q2dtveqxUPRW3+bOjnNVQIuRRVN0hGae4Tz7V8SsMDbS+uypZCzs7ei59F/c+
	 SWRe04RbqrXEFBBVCd5ngbdS5DGKoE7nFsFJPII4=
Date: Fri, 31 Jul 2026 11:25:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Jakov Novak <jakovnovak30@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan
 <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "\\  Liam R . Howlett \\ " <liam@infradead.org>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Shuah Khan
 <skhan@linuxfoundation.org>
Subject: Re: [PATCH v3] mm/khugepaged: replace mutex_lock/mutex_unlock usage
 with guard macro
Message-Id: <20260731112541.6098017d442451a8b54345ec@linux-foundation.org>
In-Reply-To: <amx5XdMQ7S_krjNA@pedro-suse>
References: <20260730204724.16912-1-jakovnovak30@gmail.com>
	<amx5XdMQ7S_krjNA@pedro-suse>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wk4o7qb69istxs4fzyfa4z7w78nqsiwu
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F3ECBC000C
X-HE-Tag: 1785522342-779995
X-HE-Meta: U2FsdGVkX19S4Q32PScrhBkQEDcoQHuyrVLQA55WGbdzH8vRengbqXEKqsIYNsfoZPgkt2hYd29dO7eBB9i7ERptULRrmu6/Q+mjkBsGaIbvSD0IycShTir+myHhDSBIwra+g6KPuzZ879/3+kUamhwIYFj1A2/nJgNzqxzcw6RdidbOOL3sQ+oZAxAnws4qhYZtfxvtQLTgcycx1NmRKFHyK8KZsm+fHprPF3BgzAxXM5HSQPpiljSHY0UAuDuQeo1taLGx4+795cNIavuJrkAED7lM28ig8yr8DhhXF29btNb7mkxuKhQ+TMVA1kdjIZTzZCpHzMzSsPnUyUsA2CcTTAgM2Gjjr/tlJ6Fhl5IPA3b51GnXyKSf64zBRcm/2Nq1yqXoOFwj9n3b4FpYAf3xccLyZZOX6qUcYUKi9fYxWvO88pbpe1zAQFxiqmHloBzWRU7wi556C8RIiTCNmhqxwQK/90D/eZIEJQKL2LyfZj5Eqo20Cow6LiQQK2vAI0GYXd4L7ZcaYpUJjXuYeLIKUc1TKuXtv7BGh+d94FwwjQFggMzqQZKd+uwMeimlEep0Hgs6PQNpKCziRvtLH8aMrTn41J5IFiJjXGDXDsNjPHSC2Ao9dMYXXg6YFM9yjkaSqDlGuOZBq1eyNFlrpa69iJjBkSUINB9eOOqL6XR+0EWB0yz4KgV1w28b1m9x/GGTuPjjdAvOENWlen7qY4zwwJP221LRkouS7llShwvdY++95zG+pWwL8i6faDhZ4nNoDMvdMhJpxiI1YYmNQOst3ytsfzif+crBIgjc7xtnV9DOdiGwZefFQAbOHKDcsbUMsVBWlV4/ndgmsq7TX8Tt64LT6+4zShERGONtlfCV2XYJffhdl6IcMSEtI9tDbbULpWqVisaoT76ZmiZTX1ndZHIaCw1Xz9IklDuLvjRoJ+izIv1UhMEmFbCpAJAxS1aeGgtm0ZscW+UzFN3
 n4qYPq/2
 IElLEFNppJuUe5Lyj6FnGA+oS0hUNw8vLbXMt+NGSf3vuuEjQfNhP/OS6skOWxFixgNdx4X7tr3zuP8Ju0Bs54OaTISTfPVhXbk63KzGnyf6pI5ILseBGeP+mVNFq+nPZLn/wFz3L7pA1zZu6uj1Ss1SGAFkarjAFwHVlIdHaZi2AXFMTEDEQjLEbFJsJepzmsW5xTIQoK3U4voE4r3OL9+QUJMKV3loo5V6UFOznnBe0JtVoKXSAZiP7lJPB3VAFc2PGhoUKKiPv/8cNMB4+0aF8cDU8yWv25NsETWbaG0WDMaq2NQGzuCQoEPA1HLG3TAv1Qz4kJeXVqUr7E8WkJ/eGZrH1FNRazXJgZbhD+fmG0RXqEcQen2tpSt9nbFRLTjISCHwNCklbu6IE0pkW5qFaCAbkLwmCIdyjsQOHDR208zAGrkO0HyMWS3FT0Tknkq8mjitr5WSNLSc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Jul 2026 11:33:47 +0100 Pedro Falcato <pfalcato@suse.de> wrote:

> On Thu, Jul 30, 2026 at 10:47:24PM +0200, Jakov Novak wrote:
> > Currently, khugepaged locks the khugepaged_mutex in two functions:
> > start_stop_khugepaged and khugepaged_min_free_kbytes_update. Remove
> > mutex_lock/mutex_unlock usage in these functions and replace it with the
> > guard macro. This makes the code more readable (removing a goto statement)
> > and makes it harder to introduce bugs in the future.
> > No functional changes introduced.
> > 
> > Signed-off-by: Jakov Novak <jakovnovak30@gmail.com>
> > Reviewed-by: Dev Jain <dev.jain@arm.com>
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Hmm, did Andrew actually give this R-b tag out? I can't find it on-list. 

I don't think so.  Hallucination ;)

I do sometimes sneak in an offlist R-b when I'm looking at things but
I'm pretty inconsistent and lazy about it.

<looks at it again>

Reviewed-by: Andrew Morton <akpm@linux-foundation.org>

