Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F94CC8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1EDA8E006B; Mon, 25 Aug 2025 16:18:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF4E88E0038; Mon, 25 Aug 2025 16:18:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31CE8E006B; Mon, 25 Aug 2025 16:18:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F037E8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:18:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7859C1A0568
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:18:19 +0000 (UTC)
X-FDA: 83816391918.18.DC44E4B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id DA83614000F
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:18:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hFlxFsri;
	spf=pass (imf09.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756153097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNerjuxI+KYbw3mNCEHMV8i09CJJK9GCt86H4fr7e/g=;
	b=e2t2SnYorU2dJkV41EvBrMRKHuuXgMiQMaCSMEN83I4ChDo8mqJyTDlzvdkuoHuiG2iRKT
	XIlFP5Cjy8jQsZqpu5pj2taw8+aPp7IxEpZaL06zWviJsYQkOjqeyiN8xAugft0TG0rnjJ
	t9dq7U04t8fjeJTzmCuiOy1z6Hg8JnA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hFlxFsri;
	spf=pass (imf09.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756153097; a=rsa-sha256;
	cv=none;
	b=hP2Z39Pop/sXWxFu8vjJqB2STFVR3NAKpNK3hDy8UXdM7GqcMtkRP31w8IDIBMfQFLhNF5
	BQ5Dz9zFZ09UtMRjDBJhZyUkJP3hGnororuErEJsc38Nk7VmKQ+8VdqeBd89jKP258F3AJ
	XYQEO2FVrys+gWVyz0su6MK0L1MLq0g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 47722601E5;
	Mon, 25 Aug 2025 20:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51237C4CEED;
	Mon, 25 Aug 2025 20:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756153097;
	bh=yNerjuxI+KYbw3mNCEHMV8i09CJJK9GCt86H4fr7e/g=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=hFlxFsrioVHoPBVPmP1nQAdWfA6sGqieK/3eJIPNwb/fgHtGy72TnnSEvhYryibRv
	 GFKFFoV8oSOgWAtWyCNJNocRKr9FJwZ2ZGpaUfnsOhsyI0kupY0SZiqYyBfPilEvcE
	 lC8u05P6vI385iou8sEtH/JARLmrK/KjWR9Gq8DplgFKfLbZgXtCTwPYWtcQRGEdVk
	 RPbLgoMWeYCoQ2qRe5bF0p/PlmOi7wwTGbEdmACDi9xjXr3qRzKZgG4IvzRNF2m7fK
	 PHyxc8DoAeOJeLn60+cbpo9WKw0T1FU8V8yljOwRUbnW4SHutpvZMkzdJxcZLgjaNC
	 4b0+vQDoj+Kgw==
Date: Mon, 25 Aug 2025 16:17:53 -0400
From: Kees Cook <kees@kernel.org>
To: Marco Elver <elver@google.com>, elver@google.com
CC: linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrey Konovalov <andreyknvl@gmail.com>,
 David Hildenbrand <david@redhat.com>, David Rientjes <rientjes@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Florent Revest <revest@google.com>,
 GONG Ruiqi <gongruiqi@huaweicloud.com>, Harry Yoo <harry.yoo@oracle.com>,
 Jann Horn <jannh@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matteo Rizzo <matteorizzo@google.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-hardening@vger.kernel.org, linux-mm@kvack.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_RFC=5D_slab=3A_support_for_compiler-?=
 =?US-ASCII?Q?assisted_type-based_slab_cache_partitioning?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20250825154505.1558444-1-elver@google.com>
References: <20250825154505.1558444-1-elver@google.com>
Message-ID: <0DC67CE5-6006-4949-A81D-882DBDF4DAC4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DA83614000F
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 3nko8go6op9a4esusep1wbzahobubqh7
X-HE-Tag: 1756153097-411714
X-HE-Meta: U2FsdGVkX1+g0ZeLcpkkuRQOytXAgAVGqr+oR9eeJna30oLv3O9w0A3UYMNyZsz56ABloAaLS5mSIfxOP79Tw6FTXU+w5U5tVpucDH5dRywo3IzSgvwmWPuQfe77LFoBnJjwgWA5E4yr5PuWVjh1DNbwu+4JRAuLhnd8W9Yz3VGjReeTzLhIkQ0+kMdb3dME+LzZqvtqVLBDv7KVwIyWRKtUTqzLC1tt05TdnK4gDw9DtvEO7EGcUjscGp+84KfKSm3LhgQD1GlEMXI7drEpfzTsD63OPr7cW2KlgNx+ZnahJxzAYqynXCHYeaaNTamMqf4AbZatyPH5UezfLY1RTWCAdgvBMQQtHLUflXJUSyVg1DDunjtaP7mQ4HB5EA9CMzj0NXXd3BJ0sxsKq9h01HYeU2+ZPSAdWDUzwida7ElqecZo8ej279cV4qDcadiBRIP6/aROulniBUUInTaP6T5Qdz6xJvgmkCEqv2XIuKfIRQqZQM4RIMMuamt+XkryPtTzcMsbkq7Jjf9XFDGovg6xxf/t+YtvYflICitn3IyEiOhLSnKeGz9CcLS1KjVw9hBiLeRzcs2IF1zoptp0sETf2kfeZv/LKmDP7pe1c8OQeucPrwLzJc/EEYSZ7RvMnpKhlhW7v9DsltvD4qDF1Zwz0oPTC0vQxwaEo/J98zqmqOQ9hhIfwet8XPD/HIfEbV4YnOG4HQfzgwUElfvmI6L7mTwfpp7WZfLwKnOuXD63ioAjH6yfVM8eKx/ky78PsN48ka0lWwG0l4Vh89jAgaCkE/bGv9V7PD2t6oZMMcjgWt20NqKEQeMIZqMbkIJA3BT0eDCwmXAVRu3skeYRxdh2k4oXFfC/Q/LdHm9pFKmp0ewGqobf8rPkPmsDkXZr9cnzm11lzXqw7HL8/vxeWMHrrjXYvtzBDHHvHTOiYM+QftR2ULZMn0iluYdYCps2DaAf68E98QiLBRQMXWQ
 wef+Au1F
 9yStExhnvbQLN4B93haJtTXJaC6Hs0w11C9EhiTmMq0FLpPtqVQJj6iUHvVLLwfGY01JsS/ZDjqtiRzqqedT1/3oRCbbDSvma2ISjmt/i0X/q5uWFUu2FBIGl31PhxRxWuhGwpektGXZuePg0TZbJyAeolaf8ZLdLsMy9YGQFU1rQyjDe7dNuqTY67TyDDLAzxWa+UdsdD2GRaz9HxWv7oWWnwy07VIpHqggn9R5z9na2oS3i1AM2a6x/qUmRe8vK+pLtfQ2rqNV0H63pX+0JJNI3MTibGoeQtvmzl3+92iAsnzs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On August 25, 2025 11:44:40 AM EDT, Marco Elver <elver@google=2Ecom> wrote=
:
>Additionally, when I compile my kernel with -Rpass=3Dalloc-token, which
>provides diagnostics where (after dead-code elimination) type inference
>failed, I see 966 allocation sites where the compiler failed to identify
>a type=2E Some initial review confirms these are mostly variable sized
>buffers, but also include structs with trailing flexible length arrays
>(the latter could be recognized by the compiler by teaching it to look
>more deeply into complex expressions such as those generated by
>struct_size)=2E

Can the type be extracted from an AST analysis of the lhs?

struct foo *p =3D kmalloc(bytes, gfp);

Doesn't tell us much from "bytes", but typeof(*p) does=2E=2E=2E

--=20
Kees Cook

