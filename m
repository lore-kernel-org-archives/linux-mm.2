Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9252FC83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 10:00:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E52796B0088; Fri, 25 Jul 2025 06:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2AB06B008A; Fri, 25 Jul 2025 06:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D41586B008C; Fri, 25 Jul 2025 06:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C39DB6B0088
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:00:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77F34C06BA
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:00:15 +0000 (UTC)
X-FDA: 83702341590.24.9B45B28
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf04.hostedemail.com (Postfix) with ESMTP id C8D8340017
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:00:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dq1RaMdh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753437613; a=rsa-sha256;
	cv=none;
	b=5zYgbvhKNFn49glHB9koIlhJcCcwr6aXVYuDNRDSAih7lJSAOXQN5BNKsb/1CWGJxl4qwS
	VN2TDJKhvq0c6PECUn7+ZMOU+4qI+n9cVnffOpjpoueJzfGL6pgYs4mFOhGIb7Q4nkBs4b
	pMObMjOWAEAhvalFCOLwJNH15RpBzKQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dq1RaMdh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753437613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9kuhThGCsw+CqTYvWEf+KmovZ/C5TpNJFC/9k14NjzM=;
	b=o4XJDAUSDmEhPoZeAl4PLCmHyMiQUTniDXkUfRmFtafC5creMU01Z15k2L57GKnmSGmMC4
	nx5mh3eGWYC1AyxshG5c5533Ls/xqOYS1gpxUrh1YB/V4W5/0V5x65WBZWiZkf7haqr1md
	eUVTutmXGnJscUIlLIR2hX+6gLfce80=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 9A01A5C4BC5;
	Fri, 25 Jul 2025 10:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30589C4CEE7;
	Fri, 25 Jul 2025 10:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753437612;
	bh=SAzJ4Rh9xtuKNmwLY5cQXz+97kzVuVRtBbRTweajerk=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=Dq1RaMdhMyl/1HeX4QMl8OlCABNE7EKtzMs1O+mlrREgWBavM6jiI6RMPKGdQxY2Y
	 x+y98/amXhamsi+kLeCv/0b2WRLiyglvKv0WDCJXZn96lVE0f1Z2wyj+LfVpZ2RZkT
	 WLtgRKeMulLCEZF9XqiXTGePW5Uniw6UHi0gX14kD9LZY/5JIGRsiCK2Ro1WNa8ggn
	 jnqpWzGW8j4ljk15MssEINb6QdFOny165vSHE4eL77OHGH5ZEl0ZTlG1suCDW2OLw9
	 NlIF4b/E8gnc3lnCFZgMvknyvwOF1wNbKdIlNsnXNxiKI16Nj8I1Gz0kiuguFH7dvf
	 k3WwUfNhhubiA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 25 Jul 2025 12:00:07 +0200
Message-Id: <DBL1R8JJ38M1.21F7MRUUUX4U4@kernel.org>
Subject: Re: [PATCH v13 0/4] support large align and nid in Rust allocators
Cc: "Vitaly Wool" <vitaly.wool@konsulko.se>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, "Uladzislau Rezki" <urezki@gmail.com>,
 "Alice Ryhl" <aliceryhl@google.com>, "Vlastimil Babka" <vbabka@suse.cz>,
 <rust-for-linux@vger.kernel.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 "Kent Overstreet" <kent.overstreet@linux.dev>,
 <linux-bcachefs@vger.kernel.org>, <bpf@vger.kernel.org>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "Jann Horn" <jannh@google.com>, "Pedro
 Falcato" <pfalcato@suse.de>, "Hui Zhu" <hui.zhu@linux.dev>
To: "Andrew Morton" <akpm@linux-foundation.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250715135645.2230065-1-vitaly.wool@konsulko.se>
 <20250724135449.2cb6457b90926cce1b903481@linux-foundation.org>
In-Reply-To: <20250724135449.2cb6457b90926cce1b903481@linux-foundation.org>
X-Stat-Signature: 81za5oyy5otgg8mgcnmf9x4dxry89xyw
X-Rspam-User: 
X-Rspamd-Queue-Id: C8D8340017
X-Rspamd-Server: rspam02
X-HE-Tag: 1753437613-739742
X-HE-Meta: U2FsdGVkX19auqL+VT0kEoWshgS8dYLOQg5jH65C+xaptXYPp5O5Wc5Rnk9nsBjpN07hYymYTSQtvuolvjpceQQZ56OxtNAyzzwEDJNmiyLv/0Noib6tKsJMZhFBqZ19jb345rczxukjJHlZHh0ARP8SQRC2gUFWVyprTM2ZShB1JieMocBrEmXTDPRKzd3AwD1kezgmiErjbcyo/410Ciqj2Rs1+8B8CgTJZkXHdwdjq4Z6EWkXckyiT1ILdOABd7mxr0j7BzoGellA9MANbgVDJpoNu24JCxq1igwWHTuni+9sUNbqVwabemwtudPIY64ImkiFIgdjljjbkhRR8IkYw8koUKOSuTx3ElAw4xCYTluGtz/s1t3iR2jb0aKtx/WTn291I5eze3dUoCA23vC/ZZOFUCWf7lacNgo8nknT0Wh7qbsOXz6GYoySCrGYLi9a9epx6rxIvK8IU4y7n+5kDuJOlBVqxfLZ/3LIHqEr41QvHUyNVyzYkymQyPk61dvAgt+zjqw2c+qqIAsv8h4OZsDJrvIprZ6sPpRwISnAYh49K/EXCzjYTMRlCeYTrgRgCfZ7kVmTr+PzGEskefvJYNDhfB85mniTuXBxlEkJxMJDhLE/MdljfmS30FxlXtoIyeQb20latYfq6kmDgA8Dk3Bm5NBfYi6HOROqKoP3TSdG3mNeMdawOulqZOkQXcMhpdebGbg3OdWTlA+nWTyjbziIzeYNGVbCA+Smt1+flxyHYXwMHH9rMeCOEqt7px0WESHk21mEFJGS9WUPFmSFvoysfLszE0+ljnGyq08/jjCyL0qLelHfCk7g1cU/KFFw1qyyhtecX5qzEUUjHT4nyDsoWUYLU/pMbw6sOPR5WIvqligZtjygBT25EX+i5040gHW6f/KGBKHa/JcT9P1z8Ze5FuPyCnTHndp7o5066xXJzJHa6sl/JVI31p28vFipoQY0KbaLJ5fjZCg
 nWxzhGw/
 LP50WGVL89aCju/1bgZ2xhjrQV0fVsoe9m7La9aVlLf/FC56Yjs1vuPGH1SOIJc1TTm1bHRMsknj4rC9MQMLJrzTlVqGnm9v7fxmHYuyCaKQxqOcwibfbr4048Y9LxUz0NnQyQi3ixr77nK2Bkf4gq7urB+BAMABwJjIvzEGbLA6VgmwupcIRY190LEt0RydMnZrHeUdZ//111y7Anwb3pNRIhtzokUdnhBL+YZi69/ZV4jSCSKRLhT+V93zJSJICMNmRxTj2MWIOIuHstBonFoMS8BOpTPvr51F0tw4dje59r4179SBi6ZHzzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Cc: Hui)

On Thu Jul 24, 2025 at 10:54 PM CEST, Andrew Morton wrote:
> On Tue, 15 Jul 2025 15:56:45 +0200 Vitaly Wool <vitaly.wool@konsulko.se> =
wrote:
>
>> The coming patches provide the ability for Rust allocators to set
>> NUMA node and large alignment.
>>=20
>> ...
>>
>>  fs/bcachefs/darray.c           |    2 -
>>  fs/bcachefs/util.h             |    2 -
>>  include/linux/bpfptr.h         |    2 -
>>  include/linux/slab.h           |   39 ++++++++++++++++++++++-----------=
----
>>  include/linux/vmalloc.h        |   12 ++++++++---
>>  lib/rhashtable.c               |    4 +--
>>  mm/nommu.c                     |    3 +-
>>  mm/slub.c                      |   64 +++++++++++++++++++++++++++++++++=
++++++++--------------------
>>  mm/vmalloc.c                   |   29 ++++++++++++++++++++++-----
>>  rust/helpers/slab.c            |   10 +++++----
>>  rust/helpers/vmalloc.c         |    5 ++--
>>  rust/kernel/alloc.rs           |   54 +++++++++++++++++++++++++++++++++=
+++++++++++++-----
>>  rust/kernel/alloc/allocator.rs |   49 +++++++++++++++++++++------------=
-------------
>>  rust/kernel/alloc/kbox.rs      |    4 +--
>>  rust/kernel/alloc/kvec.rs      |   11 ++++++++--
>>  15 files changed, 200 insertions(+), 90 deletions(-)
>
> I assume we're looking for a merge into mm.git?

Yes, I think that's what we agreed in v1 -- the bits I maintain should carr=
y my
Acked-by already.

> We're at -rc7 so let's target 6.17.  Please resend around the end of
> the upcoming merge window?

Yes, this is too late for this cycle. Given that we target the next one, th=
ere's
a patch in my queue [1] that interacts with this series.

It would be good if you could pick up [1] (once ready) after this series la=
nds.
I asked Hui to rebase onto this series and Cc you for subsequent submission=
s for
this purpose.

[1] https://lore.kernel.org/lkml/da9b2afca02124ec14fc9ac7f2a2a85e5be96bc7.1=
753423953.git.zhuhui@kylinos.cn/

