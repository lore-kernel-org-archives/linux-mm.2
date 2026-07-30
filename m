Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 208A8C55166
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 16:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9FF86B0088; Thu, 30 Jul 2026 12:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A512D6B008A; Thu, 30 Jul 2026 12:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940016B008C; Thu, 30 Jul 2026 12:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D00E6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:52:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1B01A01EA
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:52:51 +0000 (UTC)
X-FDA: 85046037342.30.25940A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2EC40A0012
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:52:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YZhTD0Fi;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785430370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ByJFvplBmnsE+3HoI4FUtVJ6hrxGXXZXGBa+hSPpPm8=;
	b=LcNAbo/YW/zsfafVeWiruukFpnH0DZNWo7aeAheRe+eXDI07lbVC/tAsnnJjqp3J+4hiLx
	OlCExX4cphgE5rJoejuFZ//yUrQA0Z+MZ1UVBJ22R7ISgorA9FlDbiCx26gsN6yHW3WYg6
	UXeuZ2zXYOTBIK2oQPSAQAydr23EUeU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785430370;
	b=LsmwvHMPHf1I11qIwPIXAOZR3lbgNPihP+8nsSoR1LU0vC0jHJaVQbnectpNGOXcE9G8mM
	8YW1mAMywxxnitmMt1XIZ4KG3msk1fH/IVJrlOJT+eCw0SsKg/m15FJu6cdHaovb88rtSb
	OtaRgkq/NQm47mt0f4F3mupnLfl3dB0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YZhTD0Fi;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F8A7600C8;
	Thu, 30 Jul 2026 16:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7D71F000E9;
	Thu, 30 Jul 2026 16:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785430369;
	bh=ByJFvplBmnsE+3HoI4FUtVJ6hrxGXXZXGBa+hSPpPm8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YZhTD0FiEpC1v9A9DTW8qLWaRrcKfDrjjLChQDcptBvKIsImsKEUKGBSKlJyfJmdd
	 I0QGMmdz3fjmS0soz1fMvxVU6KbwOFZ4F7wTgI+YaHBprRma5cClxEHuTFSgBbUTz9
	 342VtMTraCKl161ll1VexZdq5O2bF5VSE8b6W/1HGzt/yVGb7n62kTCduc3Xw2Wlfe
	 lccAhUuMK6Rx+zPALmV5y+eoVxNca3Cs9RRcNM6nPCnYZUV9SBPV1P/CI2aTonFhJS
	 Cv/9WMyy96aEXrZZhQZpAh93EtStoY57LcPz+4Hfp+Vo8q4d40QwS/zyrdqAnsTxSG
	 yV2cEM6w75MPg==
Message-ID: <440fbabf-636d-4a8e-a720-3fe6f5f268da@kernel.org>
Date: Thu, 30 Jul 2026 18:52:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: make libnuma-dependent tests optional
To: Jiangshan Yi <yijiangshan@kylinos.cn>
Cc: 13667453960@163.com, akpm@linux-foundation.org, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, surenb@google.com, vbabka@kernel.org
References: <fdfdf7ac-8ef5-457a-ad9e-c92f6df33ab1@kernel.org>
 <20260730153344.3149433-1-yijiangshan@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260730153344.3149433-1-yijiangshan@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pu1187xpbmizccf1hjwh8nw7hd5nh44y
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2EC40A0012
X-HE-Tag: 1785430370-346342
X-HE-Meta: U2FsdGVkX18Yfr19razUAsvGqPe2o8sKjp3zmvg2rcuNj4fgEqDatXIXeWNEQ74t3f6aBNQIPJSThCBY3lfJuLi6Rt2m6OK8YCP3TcDasfw0QJ5685f1q1uor++MG16rsHNzmCCw8GgeqoztGlPPOHNaIDGKyBYRP53u0Wt67aa2YZrtpK+HzwJW7YcHxz+MZt6L17ASGKSLrKtV7vWjMB7iwpF46FxLsCjZzWODs173hkFqnTwPpq7eIaoxgkyCzAdC9ONWxc+LVJMXt29A1scGRgxuVvG6698iL7nQQe88SO/M9wTfyppUmpwqAGVNFOM4cOHN17hfL/qz0sOzRWFDz814teJ5mAdVgMTChL75DrZDIAPQSjVac5MIySJLq2p04LAAg5mDDcUFxyvx4IcfrTfwuzqb/6PtvZOF/KIV4VS2ZNwinYh32Vwwy/ZDrzrbbCrLTavkOkL/4oUeRka5q+jiJAZh3tt5OkcoHCOdQSQc7Gdg54fr/Z7GagfWFJVAlF4tsoVnfvrghLd1DNY1hCTkxU9DNNuddSK5FCFhvhXsFSg4nJ1j0hMlg/BMFzddm8+jUWxycP1eIk4jKIej3BuCC4OgLRJKJAyTs35/e1TZMnflxWlMo6E+Tjgljekcp0qgrPN8IosvYv2NCbNkBNaQzzlHUEpYZn//g8sHfL5a4fOQTCQrHchPSdmbzFq9SmOrqSJo2bR3nDWzE5zFvQTY0Doe3zCOcFeILHyNxMbkiT0YXDr7aXYB6qIZATMINNxIBpyoDbO13CYz/Tv9rbDYH1eEeTsCq4WQOPGX51MIfPCsPzQ844GwfDTOOjnDbCpslCAoY3D/CSknkbk5stqGQSmTu2sEMNZaAWp2tsYuAkaY1vWRvjrsNu4NNf0o9vYnMli06n9CW/mBdfm44kYN4IXh1vy1ySzLiMl3K/6vVYL6dg9ezFM/RkyuKftJFhbLuo3QN+0C0YY
 q524aHig
 QBpDKDA24Ifm9s4w4apivPzZgUkoYVs/4YvfpNDLxVwsnX00W+rVAWD+Wb2aOgKhFp2nTLtk6RxhhlFth+FTvY4H+MrM6OPIo0/0us+aFdm5TT+T6+RwujeaKHr/TjrNf+W+y2XtjJVSNyR73yzZCpkAxELEyTKutNYD7EX+FqPaSHwLTMk8HNhUNJZEufiURrHPrej44fYfWOWY+gBC8gTjA5j8t2rZP4zuRCzqpYNoudSM18QueZvAqQfW1dWL4lfS17Q4889B5Pup7Jeb8Yi0YXTLo39eo8eN0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 17:33, Jiangshan Yi wrote:
> Hi David,
> 
> Thanks for the review and the historical context — very helpful.
> 
> You're right that the situations aren't parallel: liburing was made optional
> because it wasn't universally easy to obtain at the time, whereas libnuma is
> well established and trivial to install on most setups. My cover letter leaned
> too heavily on that analogy without articulating the actual motivation — my
> mistake.
> 
> The scenario I'm trying to address is the *minimal container / cross-build*
> one: some CI images and embedded build environments deliberately omit
> libnuma-dev to keep the footprint small, or because the target has no NUMA
> topology. There, `migration`, `ksm_tests`, and `rmap` fail at **compile** time
> (`#include <numa.h>` not found), and `make` exits non-zero — so the CI step is
> judged failed even though the dozens of NUMA-independent tests would build
> fine. The goal isn't to spare users the install, but to stop a missing optional
> library from failing the whole `make`.
> 
> That said, your comment makes me reconsider whether silent skipping is the
> right policy for selftests. I'd be happy to switch to: keep the tests
> enabled-by-default, but on missing libnuma print a clear notice ("install
> libnuma-dev to enable NUMA-dependent tests") and continue building the rest,
> rather than aborting. This stays closer to the "run as much as possible"
> philosophy while still guiding the user to the missing dependency.
> 
> If neither direction is of interest, I'll drop the patch — no point adding
> maintenance surface for a problem that isn't real in practice. But if the
> minimal-container scenario resonates, I'll respin a v2 with proper motivation
> in the commit message.

I'd say we just keep it as is: the more you remove, the less you test, the less
helpful the test result is as a whole?

-- 
Cheers,

David

