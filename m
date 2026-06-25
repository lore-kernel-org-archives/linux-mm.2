Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27069CDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:00:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D33A36B0088; Wed, 24 Jun 2026 21:00:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4A16B008A; Wed, 24 Jun 2026 21:00:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD48C6B0092; Wed, 24 Jun 2026 21:00:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 983BB6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:00:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05B798E4F6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:00:54 +0000 (UTC)
X-FDA: 84916630470.15.71A5F0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0932380008
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:00:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=A2YxHMT6;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782349253;
	b=K1bGbMV/lNfs3ZaATF69WejseUbQT4v6t0kWBhHwPT59gQsIHY8EY0auVQjWBvPmwuhXVZ
	Ur16h5P3hrJlC+akcO+onm9/2DE5Seqgu5WgGRUOI3yQMiJw+HevjjaNwrPAk5aDsdpHhl
	4wiKy+Fl/SxL4xDpvo9h79zx7TJ15CU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782349253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oj9mMOYBY8ngL22CLmtfBvnNJxVarI+p1U03u0pmCOM=;
	b=YuDQvhX3jc7vBEYxo1sXiUQ0mRnZ6vy+bL/jnul1uUBhMME6+C8vSRHhG9SouFWdgKOVca
	s//kcborkq7xJNTtPtoPs+X9uk7R/OpCliFnZXJd1nyP4BSj+jigsbEP2xAb7byVHObVkS
	wSDqmobdv6Z+0/bz3niiU5U91yt4Z2w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=A2YxHMT6;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1610541724;
	Thu, 25 Jun 2026 01:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1CD1F000E9;
	Thu, 25 Jun 2026 01:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782349251;
	bh=oj9mMOYBY8ngL22CLmtfBvnNJxVarI+p1U03u0pmCOM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=A2YxHMT6R/W8cj5JVYBHzylRScaxX8re6ESUJXmTTS3TlPC+zp96zusYCfBmHRHIH
	 oYpRwPmOv4HRSzULzt16HALnMArBaK5yk+zwnafUSAEHpi9hIzTXrkcM47tNVEj5wV
	 /vDsvYk0ICRjzQ0A89I4hewjyyc98sb3AIZRN/qA=
Date: Wed, 24 Jun 2026 18:00:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, <ziy@nvidia.com>,
 <luizcap@redhat.com>, <willy@infradead.org>, <linmiaohe@huawei.com>,
 <svetly.todorov@memverge.com>, <xu.xin16@zte.com.cn>,
 <chengming.zhou@linux.dev>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
Subject: Re: [PATCH] fs/proc: fix KPF_KSM reported for all anonymous pages
Message-Id: <20260624180051.134da6553b4f0c4c2785f730@linux-foundation.org>
In-Reply-To: <601fb5dd-18e1-4a6c-bc99-dc2a655240e2@huawei.com>
References: <20260622091539.836531-1-tujinjiang@huawei.com>
	<93e9c643-f6fb-4377-ac5a-d91e203ad1a6@kernel.org>
	<601fb5dd-18e1-4a6c-bc99-dc2a655240e2@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0932380008
X-Rspam-User: 
X-Stat-Signature: w9w7un8qst1r4y49dh55jyo6brk5fgud
X-HE-Tag: 1782349252-197747
X-HE-Meta: U2FsdGVkX18tEoyxInI6JSlAdoGMUMfS6nfo1ZLIGN4NggN1uN5+VulITZfGt2mwwTcWCw2n+pkFZklae0trNb6Oltc2Fvy6tjm7h58pGSetog0G2Uor4v7un1U47p4XMd+yYeMLydhyfktcQ7cfFBrJiZo6tH8pB6q7k+IqJHCPLUV3/jFqZhkicD5/0YpjyP4vIExNKOwRAZRO/nHcSkRzj8HyP/DAGBX85ussJP10izUXk5IfmIsFYS4JoiFgUQqmkZ/CfypUGuqTG0Q6fRe89+aUaEdL4VOMU4/zOAitn221zf5rJ8OJNXKJSX8rDfCYWjy+yT0o7CkLsZtm3Ceg+0nL9pBKHX1dwlyGaqbLegjezkY2DnsCIjJI2i4fYst69evS/P9nkts3I8fR5ZGZekml4Bpixi+1XDB4TrqA61rbeSVmTTE2BhZljz/7TLp0hDav1/XRQoVpwb9v6PogXkUSrieD/bK44ySHnWQVZVHcmlH8K1fTtD9vMwzzHCPfI7Y9re/nhkIQLMQy+VQzPzkitediAUDWyhGRIA5I+wLPRfgB22Z3EJvDf16lqKmnRfsPSGy4PwAZsjjIBDw0dhe30nGQcEUUOP3+fSpz9C98DDdklupCGdBR7OuXpitTTURlT7/cUTvXMAtOxy8QbMsvningtGIWCRbQKzJTnfx0uWyIoyzy5VhdIW+CPt8plA3ESkFBeNE6t6HseYrqcTtNnhC7BvCsyub8RzAXh2oES8vx///kxw4v30wfwliKYyNQq51ftgcM2SJJDXSLixmgPUOG+9paDDEnY8Qq5T0QnwQo+PFh2QLgarEi8CsdpQlxs3YydTWIT/D8wYLfwZAG1qRagU3XNb9DNU57Eb/yuw9pHh+bWWgMzSv87XhvJWM9enQKnVHA4+O4HKCdo2NeX6BzPwBA7YqMp/eSDxMgSD0HcTjH9qQ7Dq5NQxU6jRCzZQPF9QA4HmS
 dYaJvV/w
 AWlPCn5hPWA775QoHRWawfZxkBHFY6l1vpJctB+cZQ6aTYGbybU9HdR72oVNoaZCdv5HJwcqBO/xvOAUKakR/qwznNXvhtps51LjcsZWgWHhXKpoBYwyonbM9M79zdGOGL2MiVG6MVtXUVWx8D79DU8fZMXDXZTnZIQzOPfHcPxiu/gPv3QLAOH3o46ke0c6wJ0xcJtt4MK7pNbqMmi6T20YKdb13Sf1QByb+7xiiX/12DadI3sH790NYYiNtNQaoylea5PMc0DE0r7JSjoLXAqA/eGE9755DbPH8lh6RO6mbj4eO/4/iG838C0J93BvVbC6P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 09:37:57 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:

> > This only affects /proc/kpageflags (well, and hwpoison inject on a weird testing
> > interface), so it's not really that relevant for real workloads (debugging and
> > testing).
> >
> > So not sure whether we should CC:stable. Likely not.
> 
> /proc/kpageflags is generally used only for analysis and is unlikely to be
> used in production environments. I found this issue due to I was analyzing
> pfns allocated by which stacks are KSM-merged. So I think it's unnecessary
> to CC:stable.

Well, it's a bug.  The fix is super-simple so I think it's reasonable
to feed it back to users of earlier kernels.


