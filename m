Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E78DCEE4992
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 18:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8BC6B0088; Tue, 30 Dec 2025 13:37:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A6B36B0089; Tue, 30 Dec 2025 13:37:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B4E16B008A; Tue, 30 Dec 2025 13:37:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 06CB46B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 13:37:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A06B988C46
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 18:37:17 +0000 (UTC)
X-FDA: 84276994914.26.2F8DE1E
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf20.hostedemail.com (Postfix) with ESMTP id AF8541C000F
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 18:37:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=exi8BjG6;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767119836; a=rsa-sha256;
	cv=none;
	b=gWE2TRz+F8DAPS0yBF4Y4+pCOe/XezmHDGRbaV1/aPyJSzmq073bbcZnkI544GbtIfS7tf
	+7isSHxUPqBYTx8wfbtve/70VNRIXQk0njQZT9dKJ75nEdUFrvDIsMs9wy6gPNXo6w1n0V
	XwpYppxTtc9wpPpuPHlEy8QRHlxXj/A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=exi8BjG6;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767119836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WjKuCchTH1xnyesy5Y7W++gREJWVmWR7Q8qqs0R1xXM=;
	b=nxynkVH4TtIb/Z7Dg0vC95ZoHTXyt9fzH8mSjyJT9GkzZZAkGVXMGyw6OiHzFCBYM1EP0w
	tLtsdEfMm3GLAHio8+NwU1j+q2v4W+Kk77IqtKzmLQZN3Zs3JCXRkYHDIFpUNUI7GZm61k
	3q1JegurUaetIYi7pYkYWEOwD+88KYQ=
Date: Tue, 30 Dec 2025 10:36:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767119833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WjKuCchTH1xnyesy5Y7W++gREJWVmWR7Q8qqs0R1xXM=;
	b=exi8BjG6MQu3+rZ3ssu9K/wV7Ggm35Z/xgkj/Ygcat2a6gCtsQ4+VMYdr0NdcCzhdQLQk5
	VSdEnqTY1Z027iP3CE735hgw+CeARkDFIGpikjMGWkdwdDVoQkv1CB/89ox7eKdp/xfonT
	JdZHVLrvReNj0iuAykK300dAhwXTrEA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Message-ID: <6o2gnpjd7z7hxl2lu2lyevawtkcas6xar6z4zip4zc3unq27cf@k4bhpnfclnkj>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <7ia4ldikrbsj.fsf@castle.c.googlers.com>
 <423puqc6tesx7y6l4oqmslbby2rfjenfnw5pn5mgi63aq74jwj@jwgorel2uj3m>
 <87ecoc7gnp.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ecoc7gnp.fsf@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: AF8541C000F
X-Rspamd-Server: rspam04
X-Stat-Signature: tf8jyyzqhg7few4eutqabd5dde8hwr7z
X-HE-Tag: 1767119835-255921
X-HE-Meta: U2FsdGVkX19Ne4+PPIv71YvKc5BXA9EVVU3PhUc0XBf3FJanjjZP7TTUef2GAyidO7a1PGZt/WAzvoCBX/vfXwdeD8rVphm8JFW/JhQwllpyLU59GhZBYej9pgXwbpQ//sHouv5gf0FtFqQtGJZK1T+fK6cGQO9gn3v5trSin92A9fELEQnzpOv3VSLvssSdeMBRx/DUGAMg8Dl4xeGfBKcCNxtLMkqmfo+2RKfH21D5ofcTfjmGRkIccR6nmJilU9kIbyGMdp025eGMBeGR8lDmCt60OVdOk07DOrU04yYZY0iaQQ0WQlkVnNE8wv7DHSccgMfAc3W2rOShE7iQz+Ca+2y1K5H0duYNVBB/CNFroNo/Y8VDIBtuN1X08fnssE7t8NQy+UymshrS+iA77wQ7JurPt0tgjdoPsL7MIZZ2ZNnjN1YAInE89zm9DvqvxwP6ZEtX5Aa8MJWmHCkh8JI95Vk4ARGDolSXZzxEs0mBwmmT5kC9KbK/wIeC6sRDhwzkNuFw+bTG/JIFPSKVEhT37uSM0olTI2lFSyqEmCQtLJH/yccnRQ6wuUF0IIQ6CU/xkEkv3HGNj6tNO4MA4hjc8MwtvfxogjNvE9bJBZOfA08xl5pr6OvCNhulnuLh8KqxF2W0oOi1X1qPH8ykOTgoA2cWX1T3PrL8iw1Wi1txbFaLI4M+a7zRVNO2PXNgA2xRLReAAMZl6jaXtnfFqON8+12eBml6mmx0TFPgsssn8ggm1LbmRNsRmROblMHtiezUBA/cYyRJsZS1oQ9ICQMmLCNUYHBaQCgxQCgU66GuFHwrz3+44CUewAQFMXbT2fbBb1rNZcWH7WcGWv8E5LisSRovuppy+pBU2fB5Pn43BkQzPVTRs+j2wE0THDnS1CsH48MihSRPBqdxmUUj2z3Ai3tBNctR9dFDy0XJs0kLU1iKlaX6K43ltgDBYPl04YLGlctnvCgZNbesfNw
 ZD/TtVEL
 KjNA9NLEdtzJC56p4k8tSnYg4RRFYZ4/SzIEoL6i59CIUEYUTH4QJkq2Kjz861ioNA6PP5nG/MAQcEgzVExYI8CZAxu0NvZEZAsI1appDfsFWMDr5a8GGrPSW/2I+83Xg3CthhRG/Bew8SRyDcL/8FxS3LvaRXb2sQZ5gYcAIERCzUGO8UyaelFh+tg4yG3DoPsMi5jocK57G2vE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 08:11:22PM -0800, Roman Gushchin wrote:
> Shakeel Butt <shakeel.butt@linux.dev> writes:
> 
> > On Tue, Dec 30, 2025 at 01:36:12AM +0000, Roman Gushchin wrote:
> >> Qi Zheng <qi.zheng@linux.dev> writes:
> >> 
> >> Hey!
> >> 
> >> I ran this patchset through AI review and it found few regression (which
> >> can of course be false positives). When you'll have time, can you,
> >> please, take a look and comment on which are real and which are not?
> >> 
> >> Thank you!
> >
> > Hi Roman, this is really good. I assume this is Gemini model. I see BPF
> > and networking folks have automated the AI review process which is
> > really good. I think MM should also adopt that model. Are you looking
> > into automating MM review bot?
> 
> Yes, absolutely. We're working on it, hopefully in January/February we
> can have something reasonably solid.

Can you share a bit more about the plan? Are you working more on the
infra side of things or also iterating on the prompts? (I assume you are
using Chris Mason's review prompts)

On the infra side, one thing I would love to have is to get early
feedback/review on my patches before posting on the list. Will it be
possible to support such a scenario?

On the prompt side, what kind of experiments are you doing to reduce the
false positives? I wonder if we can comeup with some recommendations
which help maintainers to describe relevant prompts for their sub-area
and be helpful for AI reviews.

On the automation side, I assume we will start with some manual process.
I definitely see back-and-forth to improve prompts for MM and someone
needs to manually review the results generated by AI and may have to
update prompts for better results. Also we can start with opt-in
approach i.e. someone adds a tag to the subject for AI to review the
series.

Anyways a good topic to start a separete email for discussion.

