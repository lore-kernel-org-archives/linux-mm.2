Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D846606A339
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 06:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aiUUzn6v
Received: by kanga.kvack.org (Postfix)
	id 2BC626B05B5; Mon,  2 Nov 2026 01:50:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26DD46B05B6; Mon,  2 Nov 2026 01:50:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 183A36B05B7; Mon,  2 Nov 2026 01:50:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5E326B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:50:40 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C32C140B8D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:50:40 +0000 (UTC)
X-FDA: 85389255840.10.D11609B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 928C480004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:50:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aiUUzn6v;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793602238;
	b=LCpXs8kN51de8MF4h6e67w55ZRwgdsrUx17KQ6tQsumB7DnUHnC4v+m/RnbForbs5cW08j
	F+GHuAvOwMSGQcuXEr+TsC0iYmForhbhnCEhSUQGg4rvLBiyB2ZtAC9aTARdgSYU8EsoZZ
	v5o6LYX9Gq6pe5YNpSYkWs+zcpD13oE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aiUUzn6v;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793602238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:dkim-signature;
	bh=HtL+dUx5zijYY0B+lc0w6A3fJyitr/WFBbFcx2fVy0w=;
	b=21FtE0rgXm9hKfIm2kDYlVAF4/DeaWG/fQvUxP1uKqvrbjwO6zs4ni03aPIoiFk+o28t25
	LVeptq2690ud6RnCgvWg5X5Vy5omsaAf1npnys5cxGTK9xAFU8v+K3pW4cMj24SpV9Hl+m
	jl+A1pk5/l56YrzOWauqwh0rvhIK4jE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB87B43B0C;
	Mon,  2 Nov 2026 06:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CF01F000C1;
	Mon,  2 Nov 2026 06:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793602237;
	bh=HtL+dUx5zijYY0B+lc0w6A3fJyitr/WFBbFcx2fVy0w=;
	h=Date:Subject:List-Id:To:Cc:References:From:In-Reply-To;
	b=aiUUzn6v7lPyJuBR/8K4DSaWmIZxkxL2xuN5GHlkfQc1PvtcIO4pUGsVGvz+V4CRZ
	 /+KnnBdTbIBSJFZBvNeFrFyAg0lqpe3Q/xc4QOfP1FjGWQoGLLVADDtH5ITUdw/Dbl
	 yHXF2V7WjQsNXI5HERbWp8uHdNgepUfOgmz+VZiGwCPy2UgnoXPLDmbalWWdKJyIQ6
	 Y6bgtLA0uhIo004gm/eVsgFV+/4jYzduNwueSQ4BjC1jWdV7ZGz8q7ar2ytYQJfZBr
	 Kojp04d4gIvpdPLGbUE5fsvPGolAalIyIP19Yqs5mw/CtCnvUZAGzi6XtmKMlWrIXc
	 kaS6aQUNPYtsA==
Message-ID: <3ba0259a-f675-4fc6-81ec-8ed49bd104f9@kernel.org>
Date: Mon, 2 Nov 2026 07:50:29 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] mm: Drop pxd_ERROR()
List-Id: <linux-riscv.lore.kernel.org>
To: patchwork-bot+linux-riscv@kernel.org,
 Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-riscv@lists.infradead.org, linux-mm@kvack.org,
 samuel.holland@sifive.com, rppt@kernel.org, akpm@linux-foundation.org,
 ljs@kernel.org, ysato@users.sourceforge.jp, dalias@libc.org,
 glaubitz@physik.fu-berlin.de, James.Bottomley@HansenPartnership.com,
 deller@gmx.de, chenhuacai@kernel.org, kernel@xen0n.name,
 linux-alpha@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260831054331.625505-1-anshuman.khandual@arm.com>
 <179357139104.2624073.10186400247460209292.git-patchwork-notify@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179357139104.2624073.10186400247460209292.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i1emkr9qdc5ncfewsn6gk8dbgf5s5zqd
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 928C480004
X-Rspam-User: 
X-HE-Bulk: true
X-HE-Tag: 1793602238-879358
X-HE-Meta: U2FsdGVkX19esfTa9ew4A/IpTJjZ7WFlR5Ry3Ad1BDSSQzSZzIxvHU2H7KFbpAanZfwpLFdCAb2dpKeMLLeZ1b47Os2uqEMfmtACB2q2sNNn5tlZbOn0NSYqlotqd6ajvaeY9SEPSOijOOMb53rA9Ml2zPmJc4R12UbmEB2w9aY6i8oHfYp8TD9vWqvh+UlQ0x51PUu6/kMBcamHgX0uyaZfBwwfb3sNImcif3C49+96wHIXHb2B5BM9FBkHUyAs/QBl1SIfnS2MeZPms8UJDOnQqTp0B/6jCfamwh6kaOleMXXN3qWi4JFMPK6mcXpcFCxa/PP3CqMX9lqsVvp34EpwgWvrf22djH8LdQowr5VhA3IoxCHEpfkSr+A/R4/3fUPRIHdTv88iuMCnw+TwCNYgGARM0MxM1NT/KG2uUbrmj4KAxJDZmFSkuY/VIB+MRn7EdZ3gRhZqKNu/iluzWFHrd9KWX6xnolBWxk3xvpUCOIjDI+1XhF//UNFipS7293Z4qY2+CLNZpmHd8HjaUis4QhVJjgR5QWGo7dVmj8Sp39hjI1UMdnKiLx68t0FzT46473Ms8zwr7lR0VbiRoeNei3owIl4O38i0WrLfTGDKgqf8gUghtZLCUtbCzy+1l9NVGXt69j+S4R/U8lPy/nUhRryBZ/B0wRCQf2Pqg/2MDLSyW+yDVNzQyh3Vyd2kXdzEXDEh6BVZ9Naz1i7WMGRrFY8zMngUXfwYyuevWNrR5AXj3Bqn/S7BWd9VOTysR2gM5ELNagivrxEqYpsY+IBg3R9CHhoj6TCX4wlfCWcjnFIyAeooxMtj6jBjFGph2pTyi0XNbrbaITVkPdtkoY5opNLx7kmPoYwy5PYcVw+fsGOwiGUQAwWm4afXKU4U4eNFPsluw1zoTE0XJ4vZGCjnznyrfQ1JDjwU7j+bamvpmENoodj+TFRiKmCjURLAyKvZc2/ybFcT0Skr0dD
 /bvZdP/2
 nrVrUhC13Ab5xeIFAABoNqKV1edaN/IQmSWXOkUb43Mr/+TqRKk/3epLainAn4ulZfOBYgJQaLnZb2jmRd7iDqYrsY2BIYmHS/QyREblpKP4XZwVvAROQGDbV47O+xTaFrZI73I7yr4yDGoLs5MVwOzJad+fAKqCBbhQStny+GkRoQfFZ8Yo6rq66vse3RGuea7H/MxCPja/mrzCMdbyrIdKRHPWudnC2dXH1hk8CSDEfNM2iEUBG7feyfajVWBJagD4aguiRuwsYvTopAW8ZXrss+0YZpJqPcIyzq3Tx4dYkQrT+N4+2FSVedW3uR2foWMc4suPGMLmKaoG2pLEz9UC2yZXqekdWrrqLmZN+pkXGf2t+PNBhekNyypc+xi1pDHl1y1KPiSVAhdZcrnWHxWYJ77Zr7c0m4kEQR9INgKt67hH5VFkCbmxcOUunZ+U6OJw3yvLxEBW9ya7IZMYtm5M3J9gZ+YXfKwM1bJX4dX1A/hm02ZQ2iyWfrx/EtNvPQkB/EJfojUNQNaJD27uluLCrjM1bvCWKMPYm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/1/26 23:16, patchwork-bot+linux-riscv@kernel.org wrote:
> Hello:
> 
> This series was applied to riscv/linux.git (fixes)
> by Andrew Morton <akpm@linux-foundation.org>:

What's up with these weird messages? Can we ... stop them please?

-- 
Cheers,

David

