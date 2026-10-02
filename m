Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABF59CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 16:25:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76DB46B0088; Fri,  2 Oct 2026 12:25:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71E406B008A; Fri,  2 Oct 2026 12:25:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60D3F6B008C; Fri,  2 Oct 2026 12:25:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 434A66B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:25:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF008807CA
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:25:12 +0000 (UTC)
X-FDA: 85278210864.08.2465879
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1BBF9C0004
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:25:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a7P4HPag;
	spf=pass (imf22.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790958311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k9QBgyctyjf1wUE5+IyBS6H1P6fbF3GcIg9RGUe3MH4=;
	b=kWWZWd/Tes7mMHT45w2JeD4GXoM3mjVR8YAqdWbLlRW2/UCegaYcwnoBgpxcg4VuX5VjrU
	x9goU2ZxFrtvEp/rR3s4lojIGrLFZ42TKcK7LV40paCx3qS1eoc5QKHOZ6xfctfc5xj0Uk
	9fVfu5nEwCoIBC2zPwOueyDS8g7EJbo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790958311;
	b=z6DbwblJADoY2ohh1A2r7yIMVp2B+5UEM3VyzB/wg8c5sG7/hrKCvLDolmBkRfVEJwziub
	/zoeQPr5/Rl16z/u99tiEisYBMZcyfTW5BvWuSujw5vGXA/v4KNA/wsfX6YC26FjJV3yAT
	ZzE4TuvLkI/dkB7jlKUsODcakALWuP8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a7P4HPag;
	spf=pass (imf22.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C2B442AB9;
	Fri,  2 Oct 2026 16:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4FA1F00898;
	Fri,  2 Oct 2026 16:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790958309;
	bh=k9QBgyctyjf1wUE5+IyBS6H1P6fbF3GcIg9RGUe3MH4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=a7P4HPag2l40BDyWAf0RSYqJLQ/nRiZl8oKP85Fm+8ZeQciaNQMy6de5OJpy4VGYr
	 XTKl6O7W0XS26UEspaVQI2vXQect500KbWu4Bw30HLL6+aX7HP/BiJa4G2pOOaRnPm
	 pph0MsVHgwOjr1yhliCEDQPeyuKaDmyoDsM6jBspi12905W8LJSIBPHfXa9FachT3X
	 3Umn16tD4BV9Rxh3R7rDxkbR8vf77K9rDbAH84SPatjsGTJH+uzzyCP6z9xq0FqyTC
	 RpXOWeNNAJceJj/8CGMl9ACsjcGVfLuF70TFiy2NVp0Gue3Z6eeuZaueKG18GGLsh8
	 tnIIXY55lrs4Q==
Date: Fri, 02 Oct 2026 06:25:08 -1000
Message-ID: <c1fdbe4f99352a102b38c7d131215d5a@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 JP Kobryn <jp.kobryn@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>,
 Emil Tsalapatis <emil@etsalapatis.com>, Jiri Olsa <jolsa@kernel.org>,
 Ihor Solodrai <ihor.solodrai@linux.dev>,
 John Fastabend <john.fastabend@gmail.com>,
 Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev,
 Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached
 struct_ops
In-Reply-To: <ar7H__jzvWVtqSn5@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <bda525506b3fb3e61da28a112f28abba@kernel.org>
 <arw4rjVkm2ob9ioL@linux.dev>
 <bc6815954b8d08e75deadd43e1a2192c@kernel.org>
 <ar2kvmCPR9q31V8M@linux.dev>
 <31a871a07fccc99e953a2d633fc51edc@kernel.org>
 <ar7H__jzvWVtqSn5@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1BBF9C0004
X-Stat-Signature: tihttbrortd5c3m7uzoqb35q33561pwi
X-Rspam-User: 
X-HE-Tag: 1790958310-205588
X-HE-Meta: U2FsdGVkX1/m0m5XLb1Ox7Qe8X0B+wva9r+eary6sKDGkgOyIQCuEkQd78Dfa/d4UtoVnVuTOLCb1iIgC60Ql1n4xI4n4pBYVuDBvMeQU7gAEHIQEijcv40GffJgQbdDY5UKbLQnpybN1SaoF7W1DG24h/crYdlfEG/7XKzJK6z9ZnDR57/ZuCG1Hl7W0x4f9wX5ejp+xfxuWRuLHFtyVeTcQrrEVftQTHNkWtaR37cEvlKsVIZcxFbquM/kXccGMWCbXKvwCY8TtkhT2WK8Xngy5DWTRVUFKDsvRzOcgSNK/gUV0nkwYxBPcGPrAwSmLMO5Xbp5GpK4q2FxE4gu58JFPfU9ciSOt1ENYFeQs1xwhv05xnE0desUAlo66xgvk+iMuwtBmTueXHoJM4cDbj64Jr8lUMb8Ta/YIWsvYmBMCQuFXPBDCqlI6OEWUDmFTZ0pjpFd43fFJScCmKTMVUcz5I5R3Lu/vNuVGeXTOIWUfrDf6xwT/SM05AYrkI10oq13OJHShLJGVSjl+pWySWG4VO94XO9F4+zXiwb3HaiVQ8KQHpzfOFs5r+TJKPCErjgNdabh7WUn65YLqHQ1wXQxBfmqIHIGXCCbpc+cW1+9Q7rdDiUBH5cL2S6FyQUFuP18q7YGTClhLttApPjkdpmpk3k498Bdmy0OdqntbQnaIDiQLhU5wBpSjDB9MZOT3c8/F8cuyJ8NaxTxpxGeHqHCEWB7JAdopWZZrOrLCyEfiMGe/fS7YmkPUQOv7hgYekspJ3zt5vxACnKc9uRZEteen+Xbxj0y+/NtfMqFKLt9JY7oJJtzsQUeiL+tx+dyJt2j6uX5qv0xv6ACWnBOj5pII1niXdSQVKBmgK0LqhSiwsWzMTsyKMAnRIr1XCxt3nkbT3+QDX/t1rkxKP5bKA3kjvUzNa1/6pGGJmywoOH5UXoHrw566i7mRtlU47L9We0txXtx+ZCjqnmPaG4
 qQtNupOL
 5M1bssJZDBLiKrRcRaT8ZRjUIsf7cUrpwSfE7D4wnn5bLKvjvacEBOgWQLkoNi3jv+849bMXcJ0aHLubQZMLB5zE11BrUd7RIlismUaUWZlWRRJtb6vIBSqUHhm+oO9Qq58z82jcUrJyidnivS4TRvUgnJEydNzst5qHBUpgULs6hW5NzW4fWHOGrM6GEqxNVJgQJISo1LIpwXDtcPAcOW8VEFc9+nymP8prhYGyVue5kPtiNDtZWTbAlJfTVDn2CtY0sla/pKJ5vsH/eJJzPTVOz2w6GM+iP1JlONOE4J9gSqN/6vKj2l3ryypi9jq7v6jYQNzxtawQzJm30xirrl7qefKx4vomg4PHun01BcqnKlIdhxVATzmWrbq2uBFnZJWg0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Shakeel.

On Thu, Oct 01, 2026 at 03:56:47PM -0700, Shakeel Butt wrote:
> We are in agreement on (1) and (2) completely. For (3), I am fine with removing
> the sync enforcement, but for throttling points for bulk operation sites,
> I think we should only add them when there is an actual use case for that
> or someone complains about overrun from those sites.

On (3), if removing synchronous enforcement wouldn't regress anything,
that's fine, but why was it added in the first place?

> Now, setting aside the default behavior of memory.high, I want to provide
> additional flexibility to users for (3) specifically. One specific case is
> letting users opt in to async reclaim instead of the other forms of memory.high
> enforcement. Basically, users can specify that instead of having their
> application threads throttled, they would prefer async reclaim to bring their
> usage back below memory.high.

As for flexibility, we already have a gradient of enforcement around
memory.high. Is the need here to make the shape of that gradient
configurable? Can you give specific examples where this is needed?

Thanks.

-- 
tejun

