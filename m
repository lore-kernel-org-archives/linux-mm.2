Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD50D606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 02:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZAZNT0gB
Received: by kanga.kvack.org (Postfix)
	id EAC1D6B05B7; Mon,  9 Nov 2026 21:30:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5DC76B05B8; Mon,  9 Nov 2026 21:30:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4EB26B05B9; Mon,  9 Nov 2026 21:30:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA2CE6B05B7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 21:30:30 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A2CD12064E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:30:30 +0000 (UTC)
X-FDA: 85417630620.11.DBF2CC2
Received: from mta0.migadu.com (out-221.mta0.migadu.com [91.218.175.221])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3EF4640004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:30:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZAZNT0gB;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.221 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794277828;
	b=gtcnjL6f44tFyXTNr4kTAPPCjicWMUaabS4kDmrMDH92sALUoIh4Ecszy+bK4lDeQaOZwP
	FEZLJVmTAVzG5GyYq8MNBwoRrC8t9mawnHEf6rk/qYWLzVWh7BoVK9Y+gieQlofJE7wl9w
	Ue5WSjOk8djprG85apICnoldye64zyI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZAZNT0gB;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.221 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794277828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V/gmZjOtCuDSQAnk9X0MMdk2XbOQ83sIc3JPpm8qHkQ=;
	b=GaCc3By61dxRFSERZCutkB1hwR8+p2XMqU1FZY4JbIlp4YHnLbw2rDaJfGes4X3ZsZCTI/
	XOtrczTZFU2MFsSPhtQ5HduARGPNaWrBsJwlUSi5O0uCNV4VU9pbyth4G467xkEdyPDth0
	2+3oXtI5tcfF7HX6cUs8M/1Gy9GYHUs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=V/gmZjOtCuDSQAnk9X0MMdk2XbOQ83sIc3JPpm8qHkQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794277826; v=1; x=1794882626;
 b=ZAZNT0gBMQr2NNUxNVF02MOkUv7IbfR8h75a7UYqFmtAPeGXD+OBPuUusqaRcsU1xnUHpoVx
 TNJyW/VnxNI0kCvdO4pD3fvaCw9mo2PSD7O9pnXzucMC3dWbLYOKno5IiTAEjKvLpuiY22GYsWm
 MiIY50Dpih0tF52PCiKTS+4Y=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id fb7a0a4d731dd829;
	Tue, 10 Nov 2026 02:30:24 +0000
X-Mizu-Trace-ID: fb7a0a4d731dd829
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 1/2] MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN
 LRU) update
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
Date: Tue, 10 Nov 2026 10:30:08 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Lance Yang <lance.yang@linux.dev>,
 Ridong Chen <ridong.chen@linux.dev>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <592C1134-FBA5-41B4-AB79-D6BF5B4883D8@linux.dev>
References: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org>
 <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3EF4640004
X-Stat-Signature: 3k1au39zgbyxnge6u69f5d3j5tfckhxd
X-Rspam-User: 
X-HE-Tag: 1794277828-634374
X-HE-Meta: U2FsdGVkX1+JY4BWp0VY6IPciYr/f3Ut9Pwz562d060zJH0zfgnwOlGS1N2pD/ExVGLM5n6n2q1gPUzcKE3aYXPEZysLPM3Gnf+2bH1fMzK0klMxxysp3rVKaCbEPWNW3KUkixarqk72zKtrM5MOltgfVp3k/OaKQjOnyIPiqYhO0fz7RR/G7VL7krepthFCcBBHQyTWmmzg1khNrcjgrCfInvLz7eInR6HrhiVkIGYODJ5rLezUF2NmXIXOyRpcgXgwhe2PSJS7jeD8QOGuevuirDjFyhtqbq4+R3rEs5VSTsE0IWIEvPChMaOK9TclQleN7/eR2s/MLv5QS00+8+Y26+DAQ3p8Xp/xFa86BgDdlocmssX8oFXApErdPKBe3BJGHNAYWu/3nnEwETsZ1emIcotCqq6mZ+T8O71nFPUn+p8OC12uQo9OhbAeDmRNbL2dM6Fmgcc7bcbfe+3GESl68UsjF8s0ks1uw4Qe7Y8jBmaSYGB86SLLeTH//qIfkNd2QwqX8FxB8sg1aLUib04BQ/kd2Cu6MxDjcq3tMqnzzJNrRjVgTCUJmOUew1c3lhM/SqSQKBeDEs8qieUGF7a9jKUEvbKzmbbUA51Q0noWdeFRIIKiiZb8hozca875U6vCFq6KOb7JdUS+FNcnwMMj7SjXr5v3u+HY6M1TJ6QJ5d2pH3ElDDwJQEY9hmJZRwLw3skzfU04S4kKdZesKfaUcPf4rO0DIHbsqJaMv215puQWYUr17NAinwmxPy3JPQCbZdU3c1zUbYDe27SdTVstpr1iQW+lXylDI0bmImbRj/Ak9M+cqDc6I+tz6xBSqqKa6u/bCtsuD+qJKuFRPE8fLH/YPsM4RPCDdWqDNw3Qg7HfK9iHyKh5CGXxf0/QerC3X3xFv0MaHaDNh0IY6gOQUdNUzd3+tWa19AIboOUlmr2QphF4Jc6D64YkjkGJaaqXBAENyeGNx1dIhy5
 YdTWw06D
 GdH1sf7dM3VQBO6VyYfZ7ADC003E326HhXw6L3TjxCQKyT4KjBOnkwnnicTBYWJP6EF4guF9B2JAxq92VYLiKJAO+x/1OqxxZmr3CryBrZq+Rmu94ySQT1ZQBcZiZRmmqZyWGeUhUk6GaQ9J1+dXpjDFugCx97iCZhoP1Q5/09y/U7oy/kJ8ENeEOAnVZOdxVFBIfVlVarUtJAO7ICt2X4JGKBpXxkT+WxI2RnvVrjRZMKpATt2scZVupuE+eOkQFdCLyUuo61uL/cJ9jFmp4ffap+XDKl/koqlWY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 10, 2026, at 02:31, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> MGLRU is currently the only MM component without a dedicated component
> maintainer. Fortunately, Kairui and Barry have been actively
> contributing to MGLRU and have volunteered to take on more =
responsibility
> by officially taking care of it.
>=20
> Given that Kairui is already an established MM component maintainer in
> a related MM component (SWAP), add him as an MGLRU maintainer right =
away.
>=20
> For Barry, the idea is to transition him towards a component =
maintainer
> role over the coming months, starting by moving him to the top of the
> reviewer list.
>=20
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


