Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 947D8CE9D65
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04BA86B008A; Tue,  6 Jan 2026 10:41:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3AAC6B0093; Tue,  6 Jan 2026 10:41:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D9E6B0095; Tue,  6 Jan 2026 10:41:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D3BDE6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:41:55 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7887658852
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:41:55 +0000 (UTC)
X-FDA: 84301954590.06.45B2000
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id B7C4740005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:41:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g3oqSPRr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767714112; a=rsa-sha256;
	cv=none;
	b=ZEkc/6Ljthd/hkkI4Eq5Hj4sXc5dFEFsPgrJ9OtgaeuMdFJL7y7OFGqCGDPyLd71z5A6+/
	ljwgKS60x+0e2hNRIuMiTI/k/f9oxLVXOIcVLpFaust9OMSmJotNoCI+R+wCcR39z9+DWV
	KHLEodqXSrMEsN53GGI4TTwFanifVuY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g3oqSPRr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767714112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S6vXfan0Wf0wObOzKXxZdAP1tsQ2rha+wzbrGhBlCTQ=;
	b=cimWYR1585UtrP8OnrXAZIb7G+jCnWOkNudzTiJsIauR/YuVwcRlDk6f3DCh1+CuNSPYR3
	9gDlW+osP6qC7mMuqVTZf6fItpCep6zhznQiS7tFk1sxnmM1MWJSix/Mjr50rl7+DoM7Gb
	g7Av4a1ByZBJxm061HbZy91V0bFTgHk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2708160008;
	Tue,  6 Jan 2026 15:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC48C116C6;
	Tue,  6 Jan 2026 15:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767714111;
	bh=lLS8KmtOZp2zZZScnCqYpBIcm1XXF9y6DjF8nyQEl2k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=g3oqSPRrkU8q7sONds5Cf2OqAY/lUYNmQljRgD2wu+PLkdCs7+5lpK02C3YF2wcOy
	 KXpMmdJ+qc96quWHQW6pIOk+RWVePLuLHW0J3pxbMNeJFbT+mOv9a+cxksjTrGbIQ1
	 H1E1dy1AmyLWTtQYUHnNq4LAG3CvOFHB8eUzN8J4/DrB6dL4c4ivpUZVHGUu9HZoQG
	 O07TtVhyC4IXPUzFkblGph3FTi08R2Wr1y7Y3iBaaGO7zw13sCtFRdCWHwqq4yGt3/
	 O73JmTX9H1tfnccCgB0x5C8t+Kxfxf6vDHGLp6wL/2X4ZUZy4RjBAI8S0g8++Tpbrh
	 dqzGbcx8AkGYg==
Message-ID: <c39232ea-8cf0-45e6-9a5a-e2abae60134c@kernel.org>
Date: Tue, 6 Jan 2026 16:41:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.cz>, Joanne Koong <joannelkoong@gmail.com>,
 akpm@linux-foundation.org, linux-mm@kvack.org,
 athul.krishna.kr@protonmail.com, j.neuschaefer@gmx.net, carnil@debian.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
 <20251215030043.1431306-2-joannelkoong@gmail.com>
 <ypyumqgv5p7dnxmq34q33keb6kzqnp66r33gtbm4pglgdmhma6@3oleltql2qgp>
 <616c2e51-ff69-4ef9-9637-41f3ff8691dd@kernel.org>
 <CAJfpeguBuHBGUq45bOFvypsyd8XXekLKycRBGO1eeqLxz3L0eA@mail.gmail.com>
 <238ef4ab-7ea3-442a-a344-a683dd64f818@kernel.org>
 <CAJfpegvUP5MK-xB2=djmGo4iYzmsn9LLWV3ZJXFbyyft_LsA_Q@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <CAJfpegvUP5MK-xB2=djmGo4iYzmsn9LLWV3ZJXFbyyft_LsA_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B7C4740005
X-Rspamd-Server: rspam10
X-Stat-Signature: wc5twiyq5e5mcjgkh5zsic8ikea6fpf3
X-HE-Tag: 1767714112-21346
X-HE-Meta: U2FsdGVkX1/5wGx51IxoGy5sgC6gH+QhRyI1jPiekcHqQVYXKELv6LtlY7Vlw61iXIH0nx/vbYGlJajexCvrotuO3O3BYJ1eo/1tHsZf2yfsUvkwrXxut++4ActZ87qDowDlE9hZtpglACpBiv4CSQs70Nkr06FVw/cCZuqLHnYEzOJkSt5wU1zG/owc5w/8yZbWXno7Qzax65kZAZkbBvzT0HI5+Vgoiu9EBtAQ0MkWXZvuvL92gBNhvQQEAX/qklhDUQde2O9w18+bKjXXq6P2iUECyB1Du33dYBz7MlvwMJn6KsH3UVfOKuRtAQ4qrToNh/wdetLc2+piMsGMRtmi3kZg4jG1J7/nDxLfSgDoCnJJQqVjKutcoEN9GLMhsagy1cs7SSvrbWGqpf2pvFJA60U8k7FdqcWwnPjkvSoZFZGrCGz92rP/1GUNjj6d0IhUpPIsRe+fbKAckSIak+QbMVVgYMp2dvoeFGVcnqocy/lLOMcwAyyLPrD4iaI/DoGBCA/cqciLr8OslCojl+GLalgirtGAbA1aim6aclYzll1oMiRTUBsCIa5d9udHUCrUPDp28MY1Ow+xpPjqMnqHo5unLHCcgxVbCegBi1ZYxz2DFdm8ZL1+T36lRgnvE/4BpDDFbBHgv68ysyrrza3SRdCNbYKk+99PnpiUZbcg5Dgt2q+5fUMLl38kQlA04JkfESiEjKilrk1gD/iAo95tQCRAANbNqDTG6KX/yGbW13PJai4rXwM1VpdcorVENwE5cLUV20qYZF2D2perftDAuOnsUbHramUrDVuhD1jhnwDDXxyqKCxGfq5UHsf/U8PSX/DPpiPeQ9MENjmxgjRcjmSYBJcDLypUtqZcsa7gISbPdkrR+85VcdT1xvO+OFgtWBni9dGxmJKNo+f0jJa78VVMlWvRotMHTGucljqnc42eteZfrgZ5eQu/vac6U7RI6avkYt0MxAAbWGk
 ePANovEJ
 gGbuDxxO1n8vbmy7a/hGnLp3j9FPMGWPrdnxJIohNkko9wrGefZzMfUT+9o4BfCovuX37LqMDiyYZHyS+q/knGAOZOa1Q4oS928cCn0BNiXIVpFmC5BR0xMkEBYV2TwGdr4iAcNblaG9dk/fWKeGCqJ8R8rUW1TFohYLe3FxdUaj61cMShc8XpDQxSmRnsxtqD4d0tspsoIpwAzx6rP/DECRk6oIxzW5AdvA2lzvc+F4hc6m5OnzTaG4LBFy8MnSv3lBOuJD4U9oiMY99+Xjak9ahjnAW6MgyUYotLmcMTkaDjCRUFMXJRFDrRxl1czO8sHeKrbNQCYEPkrM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 16:21, Miklos Szeredi wrote:
> On Tue, 6 Jan 2026 at 15:34, David Hildenbrand (Red Hat)
> <david@kernel.org> wrote:
> 
>> I don't recall all the details, but I think that we might end up holding
>> the folio lock forever while the fuse user space daemon is supposed to
>> fill the page with data; anybody trying to lock the folio would
>> similarly deadlock.
> 
> Right.
> 
>> Maybe only compaction/migration is affected by that, hard to tell.
> 
> Can't imagine anything beyond actual I/O and folio logistics
> (reclaim/compaction) that would want to touch the page lock.

I assume the usual suspects, including mm/memory-failure.c.

memory_failure() not only contains a folio_wait_writeback() but also a 
folio_lock(), so twice the fun :)

-- 
Cheers

David

