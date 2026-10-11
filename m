Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A34BCA9EC7
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 13:14:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDD6C6B0088; Sun, 11 Oct 2026 09:14:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8F026B008A; Sun, 11 Oct 2026 09:14:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D556B008C; Sun, 11 Oct 2026 09:14:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADB066B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 09:14:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3FEA91A0770
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 13:14:53 +0000 (UTC)
X-FDA: 85310390466.18.AB23EEF
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7103340008
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 13:14:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fxWRXjyG;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791724491;
	b=3CXpsr3c/lCkKf+ur6ut9GMyjweIwXTMqjSD5PvYFkAr0KT6qFgrrRj8d824tkPmKLhOg/
	ijhz4fZ2QbOdFbxOKw/q+BJJABFaho9dKOcl3AQuW/1LUTu5efAcDsLwOR6MqQGBC9kFuF
	I8+zSJikkJUDwqb9Q1ebB1AQGqrN2xQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fxWRXjyG;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791724491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNQ5DbYdzL7ALCQqnfip1aC0MxoL7NSH7AFsKCWEGRk=;
	b=yKNLtt1EzqspJJx1QFEnAwr1Ni0U/GzVRDjrAbIarUWC08tPrRPvJbbmqwnux7yKRZVpPv
	5rZlVeKprWFcDGsx3gMZ+pK+vnsJLcJgnwCitHGXRfB7tZC8npwulZ5rTUi0gv4LCxHVOW
	e9VtJMcG+6d3+JsbKFzTnUlCUXDu1SY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791724484; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=CNQ5DbYdzL7ALCQqnfip1aC0MxoL7NSH7AFsKCWEGRk=;
	b=fxWRXjyGR9c4uVpghVOR/hUuWZEWqGNb+7saBZbSL1jM4Ak975tSlcvXsA9UuS8j1tsjuqUnnRga0vV/vWwwvpjw+LJQafJNLeEovDFDvlsi/q7RXUfItIqh2awa/xknCcGw/Ayy47M1L7yaz6Gcx+boKkApss6p3+/WdrXBYss=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XCYCFd4_1791724473;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0XCYCFd4_1791724473 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 11 Oct 2026 21:14:42 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: david@kernel.org,  akpm@linux-foundation.org,  vbabka@kernel.org,
  linmiaohe@huawei.com,  nao.horiguchi@gmail.com,  ziy@nvidia.com,
  wangkefeng.wang@huawei.com,  tujinjiang@huawei.com,
  mgorman@techsingularity.net,  kaitao.cheng@linux.dev,
  chengkaitao@kylinos.cn,  muchun.song@linux.dev,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/compaction: skip folios containing hwpoisoned pages
In-Reply-To: <20260929034123.2705745-1-xiangzao@linux.alibaba.com> (Yuanhe
	Shu's message of "Tue, 29 Sep 2026 11:41:23 +0800")
References: <20260928105805.1215770-1-xiangzao@linux.alibaba.com>
	<20260928105805.1215770-2-xiangzao@linux.alibaba.com>
	<99cbd960-439d-4672-aba9-6b49697db8b3@kernel.org>
	<20260929034123.2705745-1-xiangzao@linux.alibaba.com>
Date: Sun, 11 Oct 2026 21:14:33 +0800
Message-ID: <877bjowf9i.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: toq6chdz55imawcf5exp9oguma7ya6my
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7103340008
X-HE-Tag: 1791724488-268748
X-HE-Meta: U2FsdGVkX19J4LyQEpRp9JOI4eRXgqpYwIpwRFt+C4plOZTwRNf4+e0dK84Z+at3OMVh7NMvSuXjUlxhePh+W0jLAU0lNGKIK7AbBgYOzLSbA7UsOuOF0oPBx3jcqv1MzWPOk1XoEXlDEx5L5Kl/lZx5u2Cj7msXjV0l5w6xpAFjdMwccku7eMgUlyhLKwFaxJr9sTJH8N09oGE5G10qp0ljMl28Af5vVCmbIxgHkC7bvRaJ4N/Un3GTGZAyQWSNhe86lXPYtMcKY9uPdGFuZNPhOx3zReHdhWjYXKLirC6ax75wET913nL4rORit3940vj/nJGsXzTX+TGPRaHO5y3Kv+muIg5kfrUH1W9U4Cpl5jw3crHvJI0CoSiFPuboNnZRhEUFFrOnsisJcwcQ22KOdWUw376tF+R59urK3XFoE8OuiKMnWqjjkqbi1CAi8GVNhbxalZvPRcn5spWGb0uqRLKK0CJKdByulcRg0ZJHnjqxQ2/eMpGYrLjKblyq9O82q7OCVr399MlIlmKVO4qxvAKFyTx2258HC0HmLnwljfTf04Fx7SACjPhrFtDbTj40uDQGpX6v5OtvsV3JQnlmQ4IpHpAhrOhZty8UlTbPz3nNJPI5/ry83rGZwhmKHrE0YiwpG9FBg7RG6P16esjSCFGzDLWpMKoiwoERXpfQQQdBj9NOUqWqBV/24m3KVJObmNsdde/NY9dAvMkirLjzJa96NsYSh5HkPEoP/heaCe/koamGqTjx/Oa9sfsNhK0BkpANoVvLJ12l/JylO3bAnIVa7KBzziaj2np/gAQKeqVAffH42qg5ZAhSDiw6KHBFIMA8ZOauIdW6ABf8Ko3DdcpitNqm89FZ5i0ZlFIhhVozb2I8OsxvY1KnODIj4nkjnuOB8vF4+Uv2V6cYvC8QmljGhCQ3u1e2B/hqbVmUWs8ph3uDUWiu+cxngZdqgXvltD+F276rJ01cPCy
 AoWYB3Dc
 Rl0Atfwz6ewMewRZsHeWe644e4tdQ4+Z+nVd0B654oI7eUpEbW0SKEU/Psb70GHPPFZHVRwNfhM4pXG3MmbYJAByLVDrgly2zYm/tZONDLWhQRVSqGNGR9qkuwTUnixIq4ONnMI/f5xn4vKOyIXburCa9t4GtYg1xZJdPllCjLierEDv8VuwcyoQmoVBHYI+qYdjn3XmfA1dMwIDZPvTmUPEdXn8EFSX7ggKqUoHSTkfxabvFxyRlFM+kSLNKnXM4xQQm/nY9CVo8pKWNluJuPfsHLktGGs1LnNASY6Os/jS02EjA746rul2iDF7cq3jQ+vtF0qHdEBW8u/w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yuanhe Shu <xiangzao@linux.alibaba.com> writes:

> On 9/28/26 20:12, David Hildenbrand wrote:
>> On 9/28/26 12:58, Yuanhe Shu wrote:
>>> folio_mc_copy() does not close this hole: it only detects corruption
>>> at copy time and only where ARCH_HAS_COPY_MC is implemented (x86_64
>>> and PPC64; elsewhere copy_mc_highpage() degrades to a plain copy).
>>
>> Then they should implement it.
>
> Agreed, and nothing here replaces copy_mc.  Two things the check adds
> while that work is pending: on archs without copy_mc the plain copy
> does not fail, it consumes the poison - the same poison consumption
> commit 841a8bfcbad9 ("mm: prevent poison consumption when splitting
> THP") refused to risk on the split path, at your suggestion; and the
> refusal happens before the copy is attempted at all, while copy_mc
> recovers only during the read.  The check and copy_mc compose.
>

Is it good to implement the trick in copy_mc_user_highpage() and
copy_mc_highpage() if the macro copy_mc_to_kernel is undefined?

---
Best Regards,
Huang, Ying

