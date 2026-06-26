Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97D9ECDE013
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 08:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9DF6B00A7; Fri, 26 Jun 2026 04:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681766B00A9; Fri, 26 Jun 2026 04:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BF466B00AA; Fri, 26 Jun 2026 04:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25A506B00A7
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:21:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81C0B1A0358
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:21:30 +0000 (UTC)
X-FDA: 84921369540.08.27D27EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id CAF101A0006
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:21:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P2rMods2;
	spf=pass (imf19.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782462088;
	b=n6ShBOfydqbp1nFXil9kJu36zo9Cbk2js3jfet4BKnp/Xg+2rhTMaL4FebxSVeP8CmIh8v
	VJPqP92wPX8LNt8DfQoxc4qbykF/WoC3UQXprrIQ6N77/0kQ4lu44GXHCGQ1pFUVtDhZCw
	1ePooONueFCBSjWDpFNJRRv55Aqs3o8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782462088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Gh35kQAbF9NJda9I6lHvwWhKBgWUfcBmP3w8KkXOio=;
	b=phm+J4LSfNf6UrLPfWKEw26Wrf1h/knyHqDC8hzeGRbAp4tsNG6b3SZe77pHRuzQ9UJEWT
	KWAZsB5WwibGwIPDdjeBEv3At3tLBxJUT3GZlytmzHSnDQzgtUNBdiT/eylPZHCwp8wvZh
	jjyiZ1gv61DaaugrDZWapkGgoYDCZno=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P2rMods2;
	spf=pass (imf19.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FB9F60132;
	Fri, 26 Jun 2026 08:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A8B1F00A3A;
	Fri, 26 Jun 2026 08:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782462087;
	bh=8Gh35kQAbF9NJda9I6lHvwWhKBgWUfcBmP3w8KkXOio=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=P2rMods2RZJ2WUH9fceMLGk+MpRiyzpYQRjH4L1pJ6AqR61HFQvucLW938qDFyqSa
	 FrkrECMukEjHEVzuIjf3V5yv1Q9p5xzHWGE+6HTZgD9e8Q+Z7nOezHkV6X/Sw+wiEW
	 UPxEJFogBt7IvXPhQEsLsvxrjA2ZUZ+sJUU/SjGsUQqENcjHgmsRWXaKB8JJOigNrD
	 z/e7SPqqHF1NDBLkiCfywon1PNKm2pb6Q3QrCHZx2g16/jVLKpx0YZhOf14SdseVff
	 79jb5rym05v6a+Y09V7n67Wwd7zqoPAjo6ZU1rDj2vUgGPcpWRf3ejlG4/+MASOcl2
	 CdcLmqI3QOqjA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199D739389E8;
	Fri, 26 Jun 2026 08:21:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/5] mm/sparse-vmemmap: provide generic vmemmap_set_pmd()
 and
 vmemmap_check_pmd()
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <178246207479.3816447.9419541647213093704.git-patchwork-notify@kernel.org>
Date: Fri, 26 Jun 2026 08:21:14 +0000
References: <20260404071720.3577290-1-songmuchun@bytedance.com>
In-Reply-To: <20260404071720.3577290-1-songmuchun@bytedance.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: linux-riscv@lists.infradead.org, catalin.marinas@arm.com, will@kernel.org,
 chenhuacai@kernel.org, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, davem@davemloft.net, andreas@gaisler.com,
 akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
 kernel@xen0n.name, alex@ghiti.fr, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 ryan.roberts@arm.com, kevin.brodsky@arm.com, dev.jain@arm.com,
 anshuman.khandual@arm.com, yang@os.amperecomputing.com,
 chaitanyas.prakash@arm.com, wangyuquan1236@phytium.com.cn, ptesarik@suse.com,
 austin.kim@lge.com, vishal.moola@gmail.com, junhui.liu@pigmoral.tech,
 willy@infradead.org, alexs@kernel.org, chengkaitao@kylinos.cn,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, sparclinux@vger.kernel.org, linux-mm@kvack.org
X-Stat-Signature: i9p57gtdrbdq3punmqnemqwuwcy3q5qo
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CAF101A0006
X-HE-Tag: 1782462088-111788
X-HE-Meta: U2FsdGVkX1+M29uHl0A/gZShASwbHUmzNZt1Zpd6Us4KiVghhb1bBXW1WsHV04mqUTluufx65hf4pQ2eQb4sK6SYHCx/GxS93Yb3muKt+I3XtKj37SZCnzAnWFt+HBqJzAypumqQ/ov4Kg0x7R1706OaY7wtmo1xH9BYYAg1RUyLslCLJPLYFpzkr8htMOikhcTMxa3O8icHz0SCU83ygMiPEh1c0MLykqO62Bk3rQkhC1x1Rr0EaIPLt2vWpeC95K+RmSX/1MexTtSogMXAefP0zgTQZsGWVqkT9bMqaDPazjJ8bX94y98s7Se8FcVDV3TAsAq2JWOv/t11nv1LyIVY8VLfJz5ZYP1Vv3727bibda6X10EOVSg0fiKfW79RsfaeHxDbQUEPCK0bRFOAXJCLp8Fi53fQIa/gkBqiwhZSS8WEuhHTqAvuQ6OiwVxjkG2h7lSJJW0+HtpOhRCg1hnIjGFu41W+grxvR26UJyuCAYWOcVjIIIMf/XoKjrPri4nlLXxGLcSqiBTPLYKyqD2WKe/sqVppTqxa6cY/l9Qcv7fruxmGOjzPBmvhIo4YgzrPP+tmXulUQIa7eLlylyKegzaD5Xa5BYc2ugLT04IilXdXMQEF9sIsPoDrJPIgtSxccnUBTrjxBCgSqZwbLU5q5ZWocQPsHg+CYlX9G4YMr47unVzsNg6aMlRgn9DMxVyEjGzB+hr103XBQ8hFISEsN5F2aPf5EfA+c9tt1bEcuwzcQgyXUb+26dTgbB0wSPdaqk8L8aNMlSChkHBa4XXdw9uWzoJxEdv1XcAHilWYLMbjaFirlpRWaV/UFYne6LlRGxsebASOH2cEsCxO4Ds2KW3z5qHFgNMRH+Y/b0DuVMaU92P6kbdFH7lAGDd8Yv5VgjsUpslfKdJ1Lql8C1FPiUY+un5X45TDS7ZArJehhuo2bIFdFlrks0Eg37gUKUMhlgiiSFdtpftUgXv
 /gBbkTJT
 gorxMzX9AfrdeOt9bSFERoLdJqhJhkVLkX/SQNlSJRqnzxwRRaJn2QTkZkEg/0ynPl3R3g5JM2pE+KA0h061uoJVHXeFYbVBBuUZT21gIipf4u8YQZCCrnX1NWs8JVGqdZkiByjgqAx+Xo4VxIehSJEZhx/E6j2GO/EhMd/8QeCFHk3d35hWwy6JPpcDQYoZR/bHemSPzFnL3I5GN+Wd3938NFdAW1iSaB9YEwdw026vCBT/illgkLwUP8N6Zv7XjYNzNe1FtE7ulO0Pl90Dsw7weYr+T4zQa+MMy9SYjHvsBAglfs5LJTvNbGb35VZkK1jhRONt1qePA6zF7LZklnPZZ/OKnBhy86HB6S2dC44SicY53dBVMqyLy+myxVkn7hjAdY1cV6omyp1rud9AxRu8HeOW3vNlegSSGFp9luQOoHPAZ3DuyKPX8U4KxFs0lDRpxYF/MC8n5/Jm0lwN2iq9IAOCLA/tToOcqJmrTqFYTfcOOpEBAJsrW6uFa6WGvV08RW9jzjRTl4o20vda0+vH0JP2S8+fhKiHarMkiTGAe5as=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Sat,  4 Apr 2026 15:17:04 +0800 you wrote:
> The two weak functions vmemmap_set_pmd() and vmemmap_check_pmd() are
> currently no-ops on every architecture, forcing each platform that needs
> them to duplicate the same handful of lines. Provide a generic implementation:
> 
> - vmemmap_set_pmd() simply sets a huge PMD with PAGE_KERNEL protection.
> 
> - vmemmap_check_pmd() verifies that the PMD is present and leaf,
>   then calls the existing vmemmap_verify() helper.
> 
> [...]

Here is the summary with links:
  - [2/4] riscv/mm: drop vmemmap_pmd helpers and use generic code
    https://git.kernel.org/riscv/c/abff0ecf7602
  - [3/5] riscv/mm: drop vmemmap_pmd helpers and use generic code
    https://git.kernel.org/riscv/c/abff0ecf7602

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



