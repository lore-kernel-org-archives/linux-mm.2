Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77CECC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 09:18:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 642376B00AD; Tue, 21 Jul 2026 05:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F2506B00AE; Tue, 21 Jul 2026 05:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B526B00AF; Tue, 21 Jul 2026 05:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2DF1C6B00AD
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:18:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AFB211A043A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:18:12 +0000 (UTC)
X-FDA: 85012232424.30.75BAD38
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf07.hostedemail.com (Postfix) with ESMTP id 57CB040007
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:18:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784625490;
	b=Q7p5KDH+2Zt/cB9fSPh/WNvvH9FllEjYQ8tr4MMb4i/W17NMoPCZXcfcMWOIRHDybZ1J2W
	Ehy8od6Zq/Y9BSTg8YxG7ZsuCd+x0iLPpWc4RulLszJkkfeeNgCD5RwLEPLw0JibMPGGkJ
	DHEMJCnZ0WXyOMQS7Nkb6EUR0sru5kU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784625490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oGZgo2lAyLytkVgMW6gwwi4KNzLuALFKb1WfLU/9jac=;
	b=UzJpSIjtQCQcRDfL7ojO5QehiOj6nLMUZrkQrppnuroxt8mTBu2zIuo4ZjXjcfoxDgIgjY
	EyUDk+PZIAniCu+Bnf/Nv4FH4mg2V4tPatBK5z8D/CVZpfG/oU3RM2gdvPhcwZHOa7qL8O
	Yc+eaQ/zxL/1dnI5TBbz0CS/QkuksgI=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4h4Bcq4TNFz55RJ4;
	Tue, 21 Jul 2026 17:18:03 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 66L9Hpwm082167;
	Tue, 21 Jul 2026 17:17:51 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 21 Jul 2026 17:17:53 +0800 (CST)
X-Zmail-TransId: 2afc6a5f39411af-0ec2d
X-Mailer: Zmail v1.0
Message-ID: <20260721171753509I9L8xNy2kiOGQFKloTnrG@zte.com.cn>
In-Reply-To: <17fe32e3-6761-4101-9d5f-2b22c8a83d7b@kernel.org>
References: 20260721084522552ZPa16p1SRj3PYat3sqxuN@zte.com.cn,17fe32e3-6761-4101-9d5f-2b22c8a83d7b@kernel.org
Date: Tue, 21 Jul 2026 17:17:53 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <harry@kernel.org>
Cc: <akpm@linux-foundation.org>, <hao.li@linux.dev>, <cl@gentwo.org>,
        <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2M10gbW0vc2x1YjogcHJldmVudCBwZm1lbWFsbG9jIG9iamVjdHMgZnJvbSBlbnRlcmluZyB0aGUgYmFybg==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66L9Hpwm082167
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 21 Jul 2026 17:18:03 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A5F394B.000/4h4Bcq4TNFz55RJ4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 57CB040007
X-Stat-Signature: dsiunmk5rbrewducxm57ghiij8zw74eo
X-Rspam-User: 
X-HE-Tag: 1784625490-705630
X-HE-Meta: U2FsdGVkX18D895uwO1d9XCeootLRqCw8gtnHh4feI8XpvFLC1ORCZivDSpWjikGvUzrpfXEeT/QYwjBEXuvyLSFC/jaqGW0JheEDAsp/RvdG6t0kAbpZoSTr5vYKeis5FLG6WOH+5mn/UyB/b7WIOvTl8v8ru6l0E8cy6iHT+qG5ZE1u7F6dhM39OzmAHe+z5/QfyQQVILta3XzLBU4EV4BQ2JS5RMBjFyoyzM46WeB1peNKrrYcc5Ju1La0xcTTYMOTe1L9L5lkiThgs+ffxirR8imhA4G4Qv3Xk/tHpBlHdNLXn5Xko+FwoyZRwa6RU0dgDyz/saQmiwC+Y1Yi30FqfEcItfcqVq5ndvnbIONXoJMXdTlZg0S9BfTgHmEQm391Ni4l4NnzUDyPK4H6ID4dOU/AO0pnk0qsmAb3yxJiUp+JZvs8xEx9hQ8PeSyPgsGpnGXPg17g2/SSjlR62i7aExX6op8uMLeGeWwZzmFUIJ9RjHbDf2Y/WLxh9UrX+HU+18sE+vuc9FiJkOL+LJ7xjkTtUXKD3Bi80xPQIfArjpMie2OKMP4krjnBLa1WuyOJici6ITh/ETzNtZFm0yEitagqBJTHP4QUDutozljpcRIrWl/bSKZT6TcgMyR42h0hBMx0xBxPgAyiXIWe7KHJeR1Ra+MWvALQYKw6UsY1cYv/LlA2lEXZOrGbWFu8WKLpyvKEHdJ7l1/mDdP9MKCWTLhr3h1GpMMAkkcazGnzF28755+LAN+9KBFOshuijJN/8NTRbMD5ZsfGIRPTOfUA1JQZ/FZzL9U4UdGqk4hjDZbSCSsYqnCox7X/fBowyMXuSujfpklSUSm+N9ipprNkzk0AoNiKMxnoqK7DqLBzDmupfhc7q2c/dV2UGF7bppjQvFkRn31Nb6h1YajfPRW4FHQAVSrEsxqgAlYCX6Y84k3HXVvD1gxYEe5Pb3TJhw2WOat5+n49vZLrd2
 XC1Tk8FI
 wvaQhhHWvh0q1siSkpLSovqlS6lgn7p9W82M3iREj5e2zJXEXn9ft5680aAL+vswKCu+cQpS1pxMXMzGDMoriX7rsEv7M+k9Ng6Tv0/DqW5qCZetZvPmb4u0WekPk5a34M6UF8rTBA6YSmzZZsEvRO0HiQYlZanaTCX1n491TsHBeh1hojDzbZ1jC5RE+cQWjCSjtTL84RXQxYBvkoB6WoFPd2EapDhMDhU1Jx0CfkbW+SQxgKTwEVVz/AVU+eAsTUybC5d2TwyCiUY5LoOLOWQ6SXwu4bCu55wnVIpd5uRXq2mc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vlastimil wrote:
> On 7/21/26 02:45, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> > 
> > kmem_cache_return_sheaf() may refill a partially consumed sheaf before
> > placing it in the barn. Without an explicit restriction, this refill may
> > draw objects from pfmemalloc slabs and consume emergency reserves.
> > 
> > Add __GFP_NOMEMALLOC so that returned sheaves are refilled only from
> > non-pfmemalloc slabs. Also add __GFP_NOWARN, as suggested by Hao Li,
> > because this refill is a best-effort attempt and failure is acceptable.
> > If the refill fails, flush and free the sheaf instead.
> > 
> > Fixes: 3c1ea5c5019f ("slab: sheaf prefilling for guaranteed allocations")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> 
> Ah so per sashiko [1] we should consider adding also a __GFP_NORETRY to
> avoid an OOM kill. Seems reasonable that an API for returning memory should
> not cause an OOM kill... it's unusual enough that it takes gfp flags but I
> thought defaulting to GFP_NOWAIT would be an unnecessary limitation.
> 
> I can add __GFP_NORETRY locally if others agree.
> 
> [1]
> https://sashiko.dev/#/patchset/20260721084522552ZPa16p1SRj3PYat3sqxuN%40zte.com.cn

Agreed, adding __GFP_NORETRY seems reasonable, since this best-effort
refill should not trigger the OOM killer.

However, I wonder whether the same scope consideration that Harry raised
for __GFP_NOFAIL also applies here, and whether __GFP_NORETRY should be
discussed separately rather than folded into this pfmemalloc fix.

The earlier discussion is here:

[2]
https://lore.kernel.org/linux-mm/33a1cb67-8d23-4b51-b4d8-9e95e8de00c7@kernel.org/

--
With Best Regards,
Shengming

