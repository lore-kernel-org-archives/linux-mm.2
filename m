Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76EB2EE01F6
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 22:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD12B6B0088; Tue, 30 Dec 2025 17:03:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D921C6B0089; Tue, 30 Dec 2025 17:03:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94F36B008A; Tue, 30 Dec 2025 17:03:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B9EDA6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 17:03:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60989160388
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 22:03:35 +0000 (UTC)
X-FDA: 84277514790.05.627436F
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6BB9D1A000C
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 22:03:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="s/zWljl2";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767132213; a=rsa-sha256;
	cv=none;
	b=JQGg6huR2bsaNlKUKmzIoWT+tYLOXOq/VLaLc2I9mJOpy2O2WiDjKiZIWXGIfIfM+p5PH6
	5RIDAlbeXcmNLe6wL9uyqlsDj0rwQYq1uy62+RBpvIsnED5jL3itOS/1ItAO4a4520xB9l
	PWNZTe3yUuW+0Q9SWgB+kjczDcTHYWY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="s/zWljl2";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767132213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NYw6PYyW0VlKW2REqOCLoq1sRa2/WhNEmjyXvfT6fN4=;
	b=gt8VAxBEMhIIXzoF3Zujv+l//bKwB2f6VKm7JkQ6scnezNT7GWbCvH4/ctaXln35n83uQ1
	YtBOCIeNX/MxRGj+qTsND3Beq1xdzl87rv42rpzDrL17ra/8XwB1aNTAAOL0O+jGK2yKRI
	XiwVnqEWDvfbZCLWDVwy+o9ptu1TWmY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767132209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NYw6PYyW0VlKW2REqOCLoq1sRa2/WhNEmjyXvfT6fN4=;
	b=s/zWljl2wXMXniaZyBwbMB8GBHWkU4sfoAwrP2HJEFJ+U1LakGQRmyb9UXbaY9TJNK7tXs
	ZVx3Qk8+pTdn2Mlz54fZkPsJPv1nTqxBZ0Vz1MKS1a0weNxoNBNVd/TzDEDO6EXaBw0tUa
	8y3vGtXc5oO/g6DHH1lUPmSH2VC6DJs=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Chris Mason <clm@meta.com>,  Shakeel Butt <shakeel.butt@linux.dev>,  Zi
 Yan <ziy@nvidia.com>,  Qi Zheng <qi.zheng@linux.dev>,  hannes@cmpxchg.org,
  hughd@google.com,  mhocko@suse.com,  muchun.song@linux.dev,
  david@kernel.org,  lorenzo.stoakes@oracle.com,  harry.yoo@oracle.com,
  imran.f.khan@oracle.com,  kamalesh.babulal@oracle.com,
  axelrasmussen@google.com,  yuanchu@google.com,  weixugc@google.com,
  chenridong@huaweicloud.com,  mkoutny@suse.com,
  akpm@linux-foundation.org,  hamzamahfooz@linux.microsoft.com,
  apais@linux.microsoft.com,  lance.yang@linux.dev,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  cgroups@vger.kernel.org,  Qi Zheng
 <zhengqi.arch@bytedance.com>,  Chris Mason <clm@fb.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
In-Reply-To: <aVQ7RwxRaXC5kAG2@casper.infradead.org> (Matthew Wilcox's message
	of "Tue, 30 Dec 2025 20:51:19 +0000")
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
	<7ia4ldikrbsj.fsf@castle.c.googlers.com>
	<1fe35038-abe1-4103-b5de-81e2b422bd21@linux.dev>
	<87tsx861o5.fsf@linux.dev>
	<c3ee4091-b50c-449e-bc93-9b7893094082@linux.dev>
	<krpcb6uc5yu75eje7ypq46oamkobmd5maqfbn266vbroyltika@td6kecoz4lzu>
	<03C3C4D4-DC37-4A2F-AFFA-AACC32BAEBEF@nvidia.com>
	<slvvzxjhawqb5kkgfe2tll3owxjwtq2qkwd7m3lmpdslss73lo@hkewnkbik3qr>
	<59098b4f-c3bf-4b6c-80fb-604e6e1c755e@meta.com>
	<aVQ7RwxRaXC5kAG2@casper.infradead.org>
Date: Tue, 30 Dec 2025 22:03:19 +0000
Message-ID: <7ia4tsx7ocew.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BB9D1A000C
X-Rspamd-Server: rspam10
X-Stat-Signature: 8r4x16xw8nzjyz4wnd4cywdry38rtkp5
X-HE-Tag: 1767132213-411402
X-HE-Meta: U2FsdGVkX187A5ODTxXfP4Prr7vI+aY2dmjGS1x8mhYsHXkKOBTUihoEHfk+E9UEocRPUXABZzlS1sPpGTp217z8SmDdK1WuJMzxEWPO+Gc9PmzAAmQRP2/ehqi84Ugsr6sBBiDHvKzA3RNKtV2qajA2N3HKXOlLUSYd+3WVZ00diCqtFHYCjBsiL7ByAvAExhNzr+rl1F+1aX3fd/P9D5r+0RobhsLlaYrHNTrDXx2Ds3kBKGEpSnWU909/G/8pJ0LXCaYrLWA5jzeZC92E+My9KZ0GG01tDFUwhcZloI8iub5EF0YYaw0jDF9ZigcVa2RdrnbkPtk3NAi/e0eDNXcmrakr+wBRQb5KTTRjFzutXaGyTYZdvLBA4RHCvE0gZCCq9WE1ASb1R5vV0quYW5W8TclEo3zLrxmDK18yvwVU1+IkOGTIjLMs4jcXREGj9e+GsmKbQQydhrNeODigtLIM474Jy3Sp2py/gmOVE9uiadgeSHJ+WLRZzEDTaVT8AS44ZqLz9MpdJ+omea6df35u09RPepP5G+WBhckKTVy2XAyPbhGuv7kLdt7xaZP/rVd4b7m4/BUgxUpJB3LR0yxzZmemAGIF9C2q/d8x4v21V+0DR7BHn+gvKEq8ypsiQzaNFFqtQBbZE0MnI4llO/Mh7kxLQVGH6oWz9de1SRNeDKrdqXvBcEu8L26bqy2qFwZXfMT+gkrXZ7bfBNetpflNSuoahagkCWwco4NxXYQlF5l8R7NiOGwbRyQvI91tUbrt8XUnnE+B0vuh2RAtjyzCHPnclwDZVHr36JXFHmT2bF5OEDHUsod4/kgnZYJh6uOyoJTl4PCtAzuX/DLcBlajCbH+PP4z6z9+3cssbbOlnqtwffiqJAlnYzulavLiYIliFMoEPM0hGsP5p6Yq7AV4aQvG98E0WVthg+jtXhkoANJ7TQ3dcQPZg2kcdvFMZpsCsLC2Sc94nxySrln
 GkuPCa5N
 yx6wiIUCv/FfosYMs08WJNijzS4SOmoAMzmmnoN+nTKWkIum6OTFZ+ZnE09YymKnAxN5C50Mwkny+prX6QkzXZxdQbGl1boAEPzTQ+tq7DbGlxjzsTgEDK63nL6cD+uTvrPmVm41iQZ1dsLvnBZSQLlPZ3LR5kbCgKAEDf/lz2bCxQrcR+EpnmXQPx27VqpL60laT3XOGXHP93ebKoia9zub3b7P5wVkMm23DEeA7hjKfbcM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matthew Wilcox <willy@infradead.org> writes:

> On Tue, Dec 30, 2025 at 02:18:51PM -0500, Chris Mason wrote:
>> >>>> I just think you should do a preliminary review of the AI =E2=80=8B=
=E2=80=8Breview results
>> >>>> instead of sending them out directly. Otherwise, if everyone does t=
his,
>> >>>> the community will be full of bots.
>>=20
>> I do think it's awkward to dump the whole review output for the patch
>> series in a single message.  It looks like there's a sudden jump to
>> XML?
>> It's better to reply to the individual patches with the comments
>> inline, which I think is where Roman is trying to go long term.
>
> I don't know what Roman's trying to do long-term, but his email
> that started this thread was so badly written that it was offensive.
> Had it been sent to me, I would have responded in the style of Arkell
> v Pressdram.

It felt awkward to send a bunch of emails from myself, all beginning
with the "I ran the ai review and here is the output" header.
Once we have a bot, obviously it's better to answer individual emails,
as the bpf subsystem does.

