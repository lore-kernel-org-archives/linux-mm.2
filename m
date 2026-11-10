Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C524360A6F4C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UHn0uj+s
Received: by kanga.kvack.org (Postfix)
	id BB65E6B05B3; Tue, 10 Nov 2026 11:55:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8DFA6B05B4; Tue, 10 Nov 2026 11:55:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7CEB6B05B5; Tue, 10 Nov 2026 11:55:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D4906B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:55:11 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34A401C435C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:55:11 +0000 (UTC)
X-FDA: 85419809622.21.D218AC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8D22120002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:55:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UHn0uj+s;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794329709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fX75Z40RlddIrDkoWsoAk3U6fOiHoJGDsJ5/Aw5b1AE=;
	b=HqOj0Dfw+7h7tslpMkfbzTt5AHSz40sLewhAWgW5C2sjnMHENIVr/hdI4/M38j9HoB609z
	YsN+CndtaNmVWjkdMcoAsLI9Njruu2Sy0aiquY02N/WxpfebsFbygMmWGx57W7+1B7GsJf
	KlO/AuJDn6Cwvdxo0RJSwTZ47252iC8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794329709;
	b=eykl3h7k9CDLGo0ft3fBMlENNsSnPNvBga/zw1ou7849oGbVRQACga5mb9of76+mwG2oie
	FB1RU1jdLpcJzv61/PLjtHj1yLxD3wK7CYhV38PcwDps0aaswLlkq4LR6+uTGz4Vky6+wF
	xEkASV7a94879JvbS0UC4pjqBf6Qi98=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UHn0uj+s;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75F5247298;
	Tue, 10 Nov 2026 16:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEFF1F008A1;
	Tue, 10 Nov 2026 16:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794329708;
	bh=fX75Z40RlddIrDkoWsoAk3U6fOiHoJGDsJ5/Aw5b1AE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=UHn0uj+sFtGKGaLst/9muipxKqjAxKUpZ+JoQnL+duqe8G78dsi/abK5ag6CP9hJm
	 OP5wzOYOlDurhfr842HXp3hCAWB8YDNogKdbp/kzN6pDU7wNgpzn5749pSO1boCZlt
	 6wKejwWgFp+/su6c8JaDG20/CEgau226J8buSe7UDs9TKi6Sya0uZAbn2NkUxGa0fo
	 Et6Ef7UU2hOmBhoAKI5VBA2QYe5TXWmSOwZBsfBCWaIAh+OEfwpcnPN03mNODB/uDY
	 ZVJy6DuuviuuIuoQaLsxRS67TEQW/x2dI791szWv2aYwJ9hb0qxQUwxo47LjbLxQwd
	 9MBtuukDIdtTw==
From: Pratyush Yadav <pratyush@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Chen Pei <cp0613@linux.alibaba.com>,  George
 Guo <guodongtai@kylinos.cn>,  Kexin Liu <liukexin@kylinos.cn>,  Sourabh
 Jain <sourabhjain@linux.ibm.com>,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH v2 2/3] kho: skip zero-sized lowmem and global bootmem
 areas
In-Reply-To: <20261104-kho-bootmem-sizing-v2-2-b0d1a834780f@kernel.org> (Mike
	Rapoport's message of "Wed, 04 Nov 2026 18:50:10 +0200")
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
	<20261104-kho-bootmem-sizing-v2-2-b0d1a834780f@kernel.org>
Date: Tue, 10 Nov 2026 17:55:04 +0100
Message-ID: <2vxzy0b0hbiv.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Stat-Signature: 9jus9je3g58qobd7gd8hhg7fgi419m6x
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 8D22120002
X-Rspam-User: 
X-HE-Tag: 1794329709-959111
X-HE-Meta: U2FsdGVkX1+LflujlOxZRH4R1K6F2ZAu0rrUqZ3nwX1x9MPSqnP7eQFZYxh7ovybq3FAtuQV6657lAzJVih8XRonNG8zpQg6lI9KsoYCaRmOQO31Rn/OEs5AS1zwi0ZHpCDJSeiJSyRkBX5edn4bQJKRXNs0bHiD1gFA964wAsaKNa2WvMGYKnSaxcubVcqh0W2AQSOfbTspJbx9IcoRR22+8Bc5K5xnbfBWL1Qgxm6pMH230ztkDZXWCogQPE18PBaGGo8cOhKGYKn8SCvkrR3sXk+TNp6I+s2SRSqPCBmyXTdrdn7DI0EQa+IV0kETJtF5XJ/kRLCIIfUqiwz6sQi/5p+V1XmDMEwjv+j0v+Z+YKK/fgvUJruxuWPap5OtUT66Pk8AJu2sZ/ze53SFBRp+vZHkfgpAAOJCZyTomsk/Vd7l2JTD+q9RUXSCvuMh2+G9dS5QygzNf98V6/RG26RP8cWLhAoqkP7EO7ZOyjlE0BcnjsmUS16NMApY0uHgfpOVG1ssyLA7Y43MEI+0FuamqRzrd+q5GUjW6lOtJmbV5BdYV/rcVa2F5ui0L2oPOc8a6JWK0ZZbIoqIZnAyk6PsN/79y8IEUTlLNUMGoLfc2qrprSKQ/idAk07Cz6W/V3b0zCdhp+oYrhoZwMndKMbY0zvXGLoc9YqeZREH1RN+L7q8w9KOUI5lUqnLcRXIIzsdOvSui0R2o0DDy73ANYRvPuRLutRyvzGLLyOv36yiWCdFUYOvN7RnTVmFCS6Fc2PI53LC0yv+/Y4W6TqrETAwrqR6SHHitl5c/JoHdw8oTG/z4JgmKZ4Hj2Kr0FLb9RgeYt1HtqyyyUmB6FAJSD6iR5ZJZhr/NCc78H8rdrFW/eTZP+aFK+hnT542SidGkkQczwiMzu+kWSkDSDYXvRAORvkPwm+QwIxjRX3yOHH+oXm3kQINHL+Nyxdsbz9Vhy6lGxUB7vMVXIxRxAe
 5xNhVgJC
 3yK03FW1mcvSbo8c83NRCiaptAsu1VUQ9PNSHiZGGLm0fqlCHl9RJM/3an0ysSoU0DhbhyS4L7p43S9PigPduQW+qgJ5qpQHK1cvsFUCH1Nj9qQOE+m3YkS1PNX2Ymo12BzZ7N8j4tg+imoYLwN+LXX91wAHsuIuShlx3WEGf6ofOWubQwfqY2UvyLZ/IA7A/k0kGTwqxAQq0yNnt8pyjKdNDvRK9RmLshMJaLPUOe4iERkOy6Xg4XvFYDcKvIrP06B+H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04 2026, Mike Rapoport (Microsoft) wrote:

> The lowmem and the global bootmem areas can have zero size, for example
> when none or all of the memory is below ARCH_LOW_ADDRESS_LIMIT, or when
> either of those areas is explicitly set to zero with kho_bootmem=.
>
> For a zero-sized allocation memblock returns an address without reserving
> anything, and that empty area is recorded in kho_bootmem. If there is no
> memory below ARCH_LOW_ADDRESS_LIMIT, allocation of the empty lowmem area
> fails and KHO gets disabled.
>
> Extract a helper that checks for zero size and allocates memory from
> memblock, and use it to skip empty areas the same way as empty per-node
> areas are skipped.
>
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Reported-by: Chen Pei <cp0613@linux.alibaba.com>
> Closes: https://lore.kernel.org/all/20261026131851.9942-1-cp0613@linux.alibaba.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

