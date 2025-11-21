Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11171CFA469
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 02:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34DC56B0005; Thu, 20 Nov 2025 21:51:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324D26B0031; Thu, 20 Nov 2025 21:51:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2622F6B0032; Thu, 20 Nov 2025 21:51:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 17CDB6B0005
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:51:00 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56A584E4EF
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:50:56 +0000 (UTC)
X-FDA: 84133086912.19.33BB566
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D550F1C000E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:50:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hibCGmj3;
	spf=pass (imf20.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763693454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oi7rXRekku2FkYQU/YCRzv/bLtrIa6NxAbl0wrz7bAk=;
	b=cN3SGXephuJTqliIkiS537D01ceWROibIlxWWZ/20R3iEVblNnqjzACvgK4ZwwIMWbEbjB
	vpCCVzFlDP5RqBqlI9FfS4PyOMBSw8JIGCGTL2gBx1hvLf9TSCcRSl01646XFm5X0IPXOl
	1J7ThzrV/7IVih6B2PkQ1rTb7c3zb8I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hibCGmj3;
	spf=pass (imf20.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763693454; a=rsa-sha256;
	cv=none;
	b=PhLJPJzMnmD2QhqH71LN4HjIBPAsgCHa4+GIleggVy3AsXX8oKhhl8IfVUzv4AE2jrOutI
	FsJlsa+dFXvMeTgcUxzk33N+v18kVEtsA2xVPHL7L0SxGX9SWTQTkTc5GyakVagbEe54Ur
	MiHKhMrbgQxLLZ50wtxRemVOopAV4C8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A24D60216;
	Fri, 21 Nov 2025 02:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23BAC4CEF1;
	Fri, 21 Nov 2025 02:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763693453;
	bh=fW79ECj4gYUE3wXYsVqsjNH+UzaRyxd4gP0zjMFaqqQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=hibCGmj39McTgjLX1g+JxkW9BxR0oHsm78C5sDRxntra3ZL9+BLLBOgm5iqkoGMLo
	 Bq16CXHsJuZf5slcQcawH+eP6Byvvr5+HennhikltlO/aYp/rJUBIPQITu9zBFxvRk
	 Nr1KpN+bCGPRPkjKt0mWK9twGPAQ43gejjKjZ2n5ZQHtNdDVIYpSOuOSFrMyMAEH3y
	 swI7NX6byOoqrWfQdYuPoLdRDHoYprjMem3L8PIDg8J75rzWiD8q/DX1pFhDq+lkkL
	 BaaC+lYZwgN8jqJ9OygeLIkU0ObUxVbgLyXR49YBGrBHBagx0tyLzkm1c57BP4m5v8
	 zCUOYaRThj2mg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB1513A41003;
	Fri, 21 Nov 2025 02:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] eth: fbnic: access @pp through netmem_desc
 instead
 of page
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176369341849.1872917.8450711459019683493.git-patchwork-notify@kernel.org>
Date: Fri, 21 Nov 2025 02:50:18 +0000
References: <20251120011118.73253-1-byungchul@sk.com>
In-Reply-To: <20251120011118.73253-1-byungchul@sk.com>
To: Byungchul Park <byungchul@sk.com>
Cc: kuba@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kernel_team@skhynix.com, harry.yoo@oracle.com,
 hawk@kernel.org, andrew+netdev@lunn.ch, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 ziy@nvidia.com, willy@infradead.org, toke@redhat.com, asml.silence@gmail.com,
 alexanderduyck@fb.com, kernel-team@meta.com, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, mohsin.bashr@gmail.com,
 almasrymina@google.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D550F1C000E
X-Stat-Signature: 1yt5h5sjtthptri7yuhsdamnwoug6i7y
X-Rspam-User: 
X-HE-Tag: 1763693454-275107
X-HE-Meta: U2FsdGVkX1+E9Cu838Tyoxn6i06+MgxGmVWwgnv/C0XqQC2PiE1ypwCDppANstWNGSPgGacpGSNxFaEMHe3EnCz5mtE+nf8fh1jiCugPwv0uCIYChdDszNnnDqsg2ou5zlru217N2p1VFtTbop3T1rWmtFHHnsywjhwfVJ0pa5KBqmmDucpuWaZyeMUUXMqY8UUIEwWGnrqAtzH6nhvtfeRLlERPb1jlSsgKNzxBJfY8urO5C/4LXsjlw3DVoiEHXavGg5/PMFJ26AQx6FodYrwHITXADaVeHnK/9zqNTs+3mUa45U1UeslT7Q5ucOGASzQi64Zuu4TtfE9erk8PXF5qo/0mbUy6FV10kcVegVINKQmBD6QVYk85YFNSOO1CwoBymIS/KSzErHzxlab+VUD3vUNXseLPiQbjeG16QOGwZ3ZJC+srlEGrVMjSkcd1b/2YGjv51APYCKpxHCHsIu1GrtqS1YIFrvgCXqTXRsTixJXkdBrZ3uHMIUVYp4J1Hq6LtomOeGsIePR0C1vh9OrXLweFhBxbICKElrMtl7MuV9dHCJfSszAMyWyZnZM6MJSRVIwyuuIZ4z61J2hkQfgcXL2Yw0rVXXb4OeTT13rrDnlKsSi+aq/css2jpTJfrnh3GWYVcl7sqEqf3ajOzj9mmYtSswFjWWBO2jSL3wCQokzCbxxw1T71dOolYwLBe1oNDGvobK8rjPokzn3bZM3IG0B3wf08OuYxZ2Or1WyD6ghaqMacHZ0d/ZbBaJwE1ImW5MVGcG9iwvX15rgBDpeIxtwpcONduACLLwm8ZfKR52jNRjPoDZhNjYClbp7Haur4LpjBS9HRt3AjLPBhBIr7FKpcMaWmDviSHk5dMrN/qOOlOAat0LrdnwwPZmC3ZCW6iQXLE6mFfpAPzJEydaMCObvVDOxh5MQ3TatUoP6mPHP92Hjr7OrjdixHokP4HRb8nwJpbLpj7qSbiSB
 cIN5f/yk
 gcnk+TeOSFQnxOWaS4sq3It0CKtg5yhOxPdoEuyf4W3rKFTNp+FC8PnewrjDJTqY/dHLimAZoFdxzqCH+AjU0R1iMkMjtZJyzwSUBk+iySCycXzdkzxausNJ5p5eGfywmcsLV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Nov 2025 10:11:18 +0900 you wrote:
> To eliminate the use of struct page in page pool, the page pool users
> should use netmem descriptor and APIs instead.
> 
> Make fbnic access @pp through netmem_desc instead of page.
> 
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> 
> [...]

Here is the summary with links:
  - [net-next] eth: fbnic: access @pp through netmem_desc instead of page
    https://git.kernel.org/netdev/net-next/c/920fa394dcda

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



