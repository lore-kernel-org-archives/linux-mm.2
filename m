Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4866AC5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 21:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E687E6B007B; Mon, 10 Aug 2026 17:39:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E19806B008A; Mon, 10 Aug 2026 17:39:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2FBE6B008C; Mon, 10 Aug 2026 17:39:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0A476B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:39:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 514681602AE
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 21:39:26 +0000 (UTC)
X-FDA: 85086676332.18.E726435
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7D36A80008
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 21:39:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+VbGGgq;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786397964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IKlgkwmqQvFQgP1jW3huTn67mI/yisVdRtgWnxplUeg=;
	b=l+dxHHDtI+PY0+mViAgz1gUmjC8FphARKnLnYUwn1b+XoglcDSIfEO3xaW5rRyXDfO6sco
	QXuKRVhy7MKslTefSJDfkv+CBZ/vk6Cp842oTm3Q01ciSoWFTednrRldEqRYjI50Ct4PaL
	x/fCTPd494vNbz1bDxKdeGQXe5gdhEE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+VbGGgq;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786397964;
	b=uVjHA2Ung4BJFn5zIiOw5r0P5PyioIpct1WdHlndCACz9XAetNeEAo1AhwBGck+x4GMICe
	QxHE5ImGBSkDGi+HA9sPd7vOrPasPs1CXGXCPUojV8g8X4iWVeonnuHfeyxd7NzfWd9RnG
	oWssbJG0p5Wl0jBrVhTeGh6VaH4I6KY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 634D944005
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 21:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6041F000E9
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 21:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786397963;
	bh=IKlgkwmqQvFQgP1jW3huTn67mI/yisVdRtgWnxplUeg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=L+VbGGgqX8+Q7nhcjxlZ/X4H0EXcTC+ehvRSk3cg1++LjXMyixyrSDSTiFDdII0sZ
	 Q8bFhHl2lAc566PDV5GMMY78Bea+JORoKB5l5AjpONr1Ouvw3L72JPpC2AmvQFcSm/
	 51UvLjkSf5UrHtvnJuyxuiWIyjCtsNDwzGF/m98zSq53wg8tbM0ZG6OoONraKRQ5UI
	 ZxBlOVg2l4I6veGZ9hTLQgceUYmSCd0txp4LSl5/Gu+l8p6Mc/mSxcAEjO642l2BBa
	 40rydWYTxdOpnrfZKovCGiBLwf5vkdaEdyHXrTCs4GJio8b4nE04wMsu0rnH4o5dJV
	 A7yiFnIGAk19Q==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c20363107f4so250399466b.2
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:39:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr1aKHZjshpfGEVQ1XMAXvdwRG72sofQCdpIw75JYJ23H+JIpuW3zMt7sqs9NFVEvSp22Ux32T43Q==@kvack.org
X-Gm-Message-State: AOJu0YzfK78VFkPuuRA1ZQeuSXBBuk+khljuZ6wGV4bmk8ISTAFQqZP/
	FZ+x+ImL7Vz25VKONKDv1zaCgFf7aX+7okNelG/HOTNg9f75bLbGTl5QrHhbD+gd+pT7Bxnoi/V
	Aiu30mdSYPKBUireZzO0ChbuItYIi8kM=
X-Received: by 2002:a17:906:9fc6:b0:c1f:983f:d8a with SMTP id
 a640c23a62f3a-c20c6aa5cc6mr229262466b.24.1786397962175; Mon, 10 Aug 2026
 14:39:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
 <amu5v-e39GKpgFG4@google.com> <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev>
 <amz0jzVPZo_eBeRV@google.com> <DKJM4XXSPQLA.13XE36MX0650H@linux.dev>
In-Reply-To: <DKJM4XXSPQLA.13XE36MX0650H@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 10 Aug 2026 14:39:09 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMMqSV5Bf1+qKXCG4x0X9ZK_RMq=X=2ccjpo4D2mEU-qA@mail.gmail.com>
X-Gm-Features: AUfX_myn6HHHohB0-7Zk_Qkiprp8JAXUumJQ_Ah4Fo4AQkl9ZI37wo7-6h3jTQg
Message-ID: <CAO9r8zMMqSV5Bf1+qKXCG4x0X9ZK_RMq=X=2ccjpo4D2mEU-qA@mail.gmail.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, 
	rientjes@google.com, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: chq8girg9f7a6rqkxx8csdtm1j56rjqr
X-Rspamd-Queue-Id: 7D36A80008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786397964-731694
X-HE-Meta: U2FsdGVkX19ddiPQjZ5XDB9+SJndMvhq6HyKUmA8TPmZDknRgqJxiWmFxnqbVa8ZSFMUqZ9c1bj8q3w/W1Xl4o62ra7KyEaTqapOL5FFg5swh5VdHucf+ckyvd9KTzKIUOlxM5K16JHk78Es4s5AjBBDJha4NY/3Edr/WkV9FOeyAK8j7/EzbnxtKr5lLDT6fqAfSFPDp02nxH9AQuzL34G8bRaGwUFNtu8dPUHUXuLY0ZQKDp6duntXDEgw/mPirqGUuz01RSP7WdemNmnGjSaQOTV6DMFM1AxPzQ7Vnj3rnEvZGKfLkYwUhqedQFQ06V7F4fB0UZ21Z+riDbfob0WbSwjFu7fMPiuvIxszCu65FiAVKax5IQTm5Jl9Xcl+K6FSITMtkkeroEPKY0ZhXGlcPJLprUpTHs44wcOzEWDhL6okd6oFqeyjSV295TiiW4G56DIaJ3YQ92vbiizS1AdksCU4u16mIBBpj9ZITMZ4cZHjEfz8xZUY9OwCan+BEH59gtSOUjRMNYHV3bIRg/5aJ7LA0xn0wHMrHnO6dDAnnxyg6EfG/tj9jzaG/u+1LMIA79GjO/8WdxlU08rhLP4wfcPk5m12YLK1eP9ZMSueGr7/g3xlMtim1Uxn1nQVVz2PUGZqlBW4OJGkIpgRITzdqynJ1eCaVAYz/Ocfk56OSY1RVG6+QJbGivPBxvPZGCEBnmoZAt5y1QueGr2BJVOUAASJZU/9759SgrSi2GB/CLOBtmq25xWJC9rmLSrc36RpMQSZ2a/4x6xrRU1udxCqUNiBT8SnRnxVimfe3SRkMpD2rn9+sZm67Yatlr69VQ2BGUcvjJ8hFZRw/YuNofs5rESCP8mTzXAfswBVgkMFgkavtxSJ5ZxdiFNofjlQwx44qT4qG+2zHaNHY1XXJprJMgernHJXX1XD44aAMUGyMkz8A/azBoUO5kRBqJEM1/9xd5wr0gmhrpakuXd
 XcX5sMz2
 4qc2+doDqHnp0syeUydpKtxPdCvb+BomzTk5pHcnQHAGiuHY1TMJCLJ2uD573FpbIjcnGkS8h6IMbZoRpnTWH+dvLtUgfSdmBAVKlZkPmSSJWF2mfIzqXn89hB5Hqx47qXiEqHRvAMoKbdjjntUzN4o7DEAVLIupvfgqU/WjANm8ioMFld+g2J5k+AF2UAJusovIN3s2TUunKkgjq1fjFw1T3V1B9PWkHpVIP33L9C9q25xWJuqUYj4Y1gwpZuWHvi+VqzoFEBNAQaemR6OO5rFOVehnbQPFFFu+WeT3+trsZFLmRTMJiBmAJ4p17699SV7YFsyUG1Y5GL+LUXLqM2NYJx0EymOrraHW2yoM1d5i02KF8ehmBtD2b8Ee8Eeri6Sbkyz7DEWKBi74JcZC73Jo5eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I don't actually see any inline responses in your email or on lore:
https://lore.kernel.org/all/DKJM4XXSPQLA.13XE36MX0650H@linux.dev/.

