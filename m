Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6272A606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 05:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aJ6xIdcg
Received: by kanga.kvack.org (Postfix)
	id 82F076B061D; Thu, 19 Nov 2026 00:25:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0766B061E; Thu, 19 Nov 2026 00:25:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6306B068A; Thu, 19 Nov 2026 00:25:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 506AE6B061D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:25:43 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB458120926
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:25:42 +0000 (UTC)
X-FDA: 85450731324.24.BFCA92A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1EDA41C0004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:25:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aJ6xIdcg;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795065941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LXiVx5mLfIEzf8hjDa0If8oOJDW92Rz35E1HYThx7/0=;
	b=yowuKSnaiJFmwapQGz7UYzRq0S2SHrxWp8VGjNyfbSCNtQPtm5aDcEMVGJAVuYlQSLq7kg
	G8LSNGGDv7vnLJHwKF8BkVaNEOGiyQxyr+Z5p2cZNkTdXsCeCxwAXM419yzHEnnn39JH+k
	KWH4e3m2NPQf3AWz1F2qxLpJlMcgfyQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795065941;
	b=8kIgIesMafgsIvPrhG8154McsgMkpZRrzsddRPLRoPcnDJ1S7waLpGS1rRH3QOoL4uXyOC
	H2alU/hlL5sjwHxYJrP2BLVEXd2sUoXHV+fo3Hu0EpEvY+4ofvlJZLLcnjIsDVYo6eKc7L
	oAbcchiMOLwTOxJZY7z+Zx5kcMXHm/8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aJ6xIdcg;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3773C618FA
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38B71F000C7;
	Thu, 19 Nov 2026 05:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795065939;
	bh=LXiVx5mLfIEzf8hjDa0If8oOJDW92Rz35E1HYThx7/0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aJ6xIdcgedPDRCF/mKWnxOazcpJHvxbcUw5IdV6SzstqdpaM98o6c1KUQ1WY67bgP
	 iNSaLrM2Iu1tiCFmFFGYeFWbuGiRsGtBFF7LN+SGB8ElAd+BGDRhVSXAxljcuht4dC
	 knG/iBv++4lngncXhm4Tk2nRchNsXPG6BadUbrkk=
Date: Wed, 18 Nov 2026 21:25:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: Using In-reply-to: <patch posting> in mm-commits mails?
Message-Id: <20261118212538.7e6f11f0553d548a03c9c456@linux-foundation.org>
In-Reply-To: <9ba54069-3dc4-422f-8cf6-f81cb806e999@kernel.org>
References: <9ba54069-3dc4-422f-8cf6-f81cb806e999@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c6mszw981ftiyd41cosezjpzdzdcheof
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EDA41C0004
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795065940-317666
X-HE-Meta: U2FsdGVkX1+wq0sGggeE3vPYR90cbm2+9Y+NynRFfSmr/mRtWz0WdsU4m4ivpDovwPihLElpugtz47qSird94EyBiaTlwkkQDxNUErHXcjVT8MdpGdSPEIUf9IFObS7o6qdK4WfQWNupgXFNECai5OrdjJ+GIUNL1zJ1MEYslRHmNjHCPzg83XU8ZY0qWR6pz9Pj0Un2b9CkUcWihS8TPot2pkStV20U+mslwWdrrj/hZ/oaS8G6PKKRyXVixri0lMe9GSwIaJFkLM2Nkd0U31SnHnGIM/i7qogELRkiMA5hhHwnOp/Q5+RsC2bKqQFUxyH0QnauO7m/zVOu113p1EyIqNTvHn2GPA7zaL5sBISxpOcVR3bdKNpYuQaypfnpLQKlnCL/AgxGk/JemfItO9JipZmYjJFCpC3UTaWel19HO5OfZfjQuTMQQQ13QcXn19T42EhaNXERMRmqem0O+34pgs0hMrn5L9jrf2qKgS4LzMsLSoSLfRqYSMsMcckhbfCUfA04JngM879wZmHkN2lOmwStFmq0HHae76J6jSrofNqlC3EjNuluxK1V9YySDocvukGnGtdZVOLSmQwqgYNrtKs7NjK9ukEEIUlMberrP/c1paJa2mHHUBzakJpBX50/azezXPiTYwVw1fYlkoCkljJ38GFd5KgUHmIV0mdZtsHENSTXuUVaBU9RJ2yUA8RLPse2WBHhw2ya5wwe4tT3b/9pIdBHtKQ4azr7ohQwDK7Ar14Tr0i4fcIX/IG5TRItrp111VBHD8oiangYWgS14IU77L2t+P12ETUfUtd1iHle88ZB+oxhzWLV2eMWiqo1ZIkLYhGt/PF7VumWQ70qqnqIyoUh+FKNcA/9ym29x0i+3uMRZjPrPIXrQq/lIc51pHXu9zP3ygOgEYGcDMh4+rxV566BlQLEfWzDd4GXohKEVyHJptf8nR61oSf4O9rOOJ4lEc0YgCLDLHs
 xVto73pJ
 W/Ni3dk+/huy/NFZszRpoRAq2wrU3QQuv5RRxANu6tN1qWrq9lDuB/JFMCUBYkgC49t0huN66ko2PI+MOKXS4n1b1I6LKvF9kR7ewLSjGs5xh7zH5+b7JlY67j5moG2yDZiVp/6g8UnH73zAay8Py8WSqxnT9N+vesoIBkS9z2QLm9lV3cVzoGrJ5Oi6mwUWSG1Z02MfQHE1IOaADQXYIhxNmh8vQTX0NIfAQmTWnLh2BU5W4a/EjOFFnOXh7+goa4X3e6sFgeBwSgwBX9uaPRWHOO/gGMz+3wcSqTrZEBNTv5bwyYqYYULA47leiaWqEOorqKGxFucmJQqETnJ8Q5WuSWpzYgSrL+wtN2OUslgDsKxIiwqFvztwhpB9iS429Dbs12dXcg2tzOf9287zTIXMjSdpAXJCcM8AkMhbV/WlkrseeGluEFb1Vs3H0obXPLGkdt+/ohqGONLNCB8xkNTlBy9U7zGICRxwmbNsjZys1M5WfTn+dMy+v4BFUuCNO5Hca3RChjVhh+AhEZS8mvI8n/+Fu1moORwuXnF7Nb+ZJscX6MET10kPYD7Vd0ks2a2AN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 18 Nov 2026 11:21:47 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> Hi Andrew,
> 
> during some chat with Lorenzo, it occured me that it could be useful if your
> mm-commit mails (addition, merging to mm-stable, drop etc.) were replies to
> the respective patch postings, which would put them next to the patches in
> everyone's inboxes. I think Lorenzo started to doing that on his receive
> side with postprocessing.
> 
> While I haven't checked your scripts, I naively imagine it shouldn't be hard
> to add that In-reply-to: <msgid> header. You already have the msgid for the
> 
> Link: https://lore.kernel.org/<msgid>
> 
> part. Maybe it's tricky when there are more Link:'s than the patch posting
> itself. But actually after Linus initially hated these automatic Link:
> additions, he later settled on the Link: https://patch.msgid.link/ template
> as acceptable to him. It's sort of documented in
> Documentation/process/maintainer-tip.rst too. So changing to use that
> template should allow to easily grab the right msgid to reply to even for
> later actions on the patch, than the initial addition.

np, that should be working now.

I switched it to patch.msgid.link for just the Link: to the original.

Konstantin's
https://lore.kernel.org/all/20240619-docs-patch-msgid-link-v2-2-72dd272bfe37@linuxfoundation.org/
was helpful.

I hope patch.msgid.link is durable.  It's owned/operated by the LF so I
guess it'll be there for a while!

