Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DCEC607577B
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 22:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UM2QO2gp
Received: by kanga.kvack.org (Postfix)
	id A99EC6B05BB; Sun,  1 Nov 2026 17:17:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A77766B05BC; Sun,  1 Nov 2026 17:17:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987C06B05BD; Sun,  1 Nov 2026 17:17:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4DD936B05BB
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:17:11 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 91703120A65
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:17:10 +0000 (UTC)
X-FDA: 85387961820.18.4CB216C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0C68C20006
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:17:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UM2QO2gp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793571429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nBcby+831tnh65V15hxneU/5jEcnLn3vcSSp3uQCZhw=;
	b=lhi0lb78KHsld6NHzLMpFQLoSffetaQiOEHCHqm4lZMm7hL3gq6MxWwVKsduZCARMD9rIv
	apmskxJV0PK3E1Qgt+RJvdXgicixt1FHZsgznfNuA+hOeTz7VvLj+BdnS1CAobqmGP25Y/
	2UFHu5fiVGZ2o87cyzV5uOoIuQgYs+4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UM2QO2gp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793571429;
	b=mRvv2bJ5HSZjJRJQE3Ydw44HmOUPbkiUsu2hy249L7QWuU3Fld6qvBHIwKVUGZtdhJkvv6
	qvUXQtYmHCAX2nGA6+E8PP8C6fdUCr3yBI8RlG2r3BiFUWQQUR/Eh1JdhL/vxLFBKy+Mc/
	+qyqanCgmRdcxaSc1eJA53u5RTI5Nco=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9479C60616;
	Sun,  1 Nov 2026 22:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481E11F0093A;
	Sun,  1 Nov 2026 22:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793571428;
	bh=nBcby+831tnh65V15hxneU/5jEcnLn3vcSSp3uQCZhw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=UM2QO2gpOUFN7K4kaI4CIv+BCK/BlsbtUXc6McRUkNmpG/SqfTu/HEOHHHo5l4CAn
	 OAo8AnZs0Sb+cGM4YF5L+tBa9M8+83JeELgaprjspGt5zewixeNEj9lGKtF/wxuJcq
	 nqFa1ziN/TB9BQ8COwY1bBL9x8JoYWXOucfN47kcCgGzgba13gLvHBtqKqqol+Gxin
	 KlO9N2iIUP+He2LtIwhX4zwsEHj/beQQcb8/KZzwY3agVlLdILI3RAFYLV4EJVa1Kv
	 szaWAjNYBIygMKL1K/v9ObhGNjQWniwA8IN3l77UViN+j0jjxIopZtDHj40xfy+6T4
	 Oj0uSH7v+Yt2g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 401C638003B8;
	Sun,  1 Nov 2026 22:17:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/2] mm/vmalloc: fix vmalloc_dump_obj VA lookup
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <179357142679.2624073.3195794229721502682.git-patchwork-notify@kernel.org>
Date: Sun, 01 Nov 2026 22:17:06 +0000
References: <20260928-vmalloc_dump_obj-v4-0-6f288a431edc@linux.dev>
In-Reply-To: <20260928-vmalloc_dump_obj-v4-0-6f288a431edc@linux.dev>
To: Ye Liu <ye.liu@linux.dev>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 urezki@gmail.com, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 alex@ghiti.fr, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 liuye@kylinos.cn
X-Rspamd-Queue-Id: 0C68C20006
X-Stat-Signature: bt1a57myficsb7xe7gpiz57dazyjxypa
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793571429-216564
X-HE-Meta: U2FsdGVkX1+e/uUmX2Bcd6qdCASWr7oBu9Ix0DrqYtNfedagHtxQ2M9GW/+67XVQ25cn8nZmH2bFdbemfAUuysvHeDU9ePEadkIxuKBbvUqo+xJSxcFvovtaZbZDazPXVN5rM8Lk2mY2pjX/Ny7Oz1XXxYHbEvEVnZ/B10/Xds6UbzUNsXZ7Jo1Y5BX4vWCevCFz1GL5kLhIDy5Yp1hfIBSfndYVvUHWRsnXMOAgSQBpFJaOcM634IMGEDBLfW4pmXA8kSc7QMofEUU/FyS0KHZcw5/Be4GZbcLwRYabjDz+xybrFKM6mjMJLljM/k+1fWllYjO9O9G+6Rk7lm/7esUi5Ct7mSTLIl35KKRWq9ZD6Hvq3sT9dYh/PfUBcJapSGj6oV/LGBPx8mvr0C/j2txncEtrDBzBi9pRarVS9eOIiiEi5Pfq0O2siiPt/1JKeJxe31PmsTfDoHPNx3VsAece+Et0Mq7IdRdnsNtJgYU9cNIoFpvDTLn86IIOwoML1PuTRb7auS9GZD2zihDlR0hRucOPQuL8EujR1FSwbubN6AA+Z2fI3GqxXyavzvziR2UqUJsgtX97fqH++RknTN5K+bNt9qeHlfIGv6XA3ak2CIVR2IG0LWq0qq4LIcxuTSaN6/0u6A6XlWFGEFKbUHE6XjQ5JKL9vmAYCRw0j1kiicfKswoRWn5ZlTZQi77nT5igyqi/7MaS0ycCxOsVFMRjlo37hmt6hFZvVTX7fFTanrzIdgjlWCxhhxblv8kxciXWb/G4paveMOxNL3SVZSh7jhRo5TxUNMplh1EKgymuyCxynTwS+4/HX6Y6FIy1cSaYOuDYgYc05h2n7KToR2cBg357gZz2Opcp7LZsjhN9IiksjVY9uvHMxCgXwLqB/rCcI+XMcJigaG7MU02pHU8dslM5C1yjKscIYZJs5tAte8+6P/gaYnKwPoXpebmzbqpvW1LGPBrdfvqlzaR
 a+JRSAVf
 V9DrWET1AYRY+HKpc4azqqshOdCr+y4cygwZbTiMJ81cdrKi4cJdn2ZPf3OHj5XP3aJruQaIWi5HdLGaG9CHzxfq4QofFVcAthDqxDqY3yyvUJ0fXwNAP6HqfQfkaUBbUEH6F994PqcjbHytGylDunkA6ze40p/aDsbpH/oHQPHgOGMbaDpxeaxvV9qqyeQQAb5Wy21Ws1GGJUaf89lsgNn1N5myUc3EQXNe3NcSg0fF8cZZ3L/Su8s0REEfLArV3Eh/Dow+fO7TeW6SmsU2yG/QQ55JGueov0rPpTw9W1upBoZ6aXqcOhDqu0PVukAWzRJWsY4d5/qfnyT4sjPRB98JMsBJ5oopps184vsMzKyvEIv/XtXjY6aPld3Li5quBdFBEUvmXYMz4LqizitQK9CAVPBFmrLb+J2u0ta1mH5wzGhcSoP9DEaZfWRzoFLBKzYia316yz4d7+c2iQOTec7dTjuhP9TN6JRjgsIA8oynFEiq6sMAmGjhofm5AScweXLikpakAtpr8UAE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello:

This series was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Mon, 28 Sep 2026 16:15:53 +0800 you wrote:
> vmalloc_dump_obj() has two bugs that cause it to miss vmalloc
> allocations.
> 
>   1. PAGE_ALIGN() rounds up, pushing last-page addresses to va_end
>      and outside the VA lookup range.
> 
>   2. The function searches only one vmap node, but allocations
>      larger than 64 KiB may span multiple vmap zones whose VA
>      is stored in a different node's rb-tree.
> 
> [...]

Here is the summary with links:
  - [v4,1/2] mm/vmalloc: fix vmalloc_dump_obj address alignment for last-page lookups
    https://git.kernel.org/riscv/c/f4399c9927c4
  - [v4,2/2] mm/vmalloc: fix vmalloc_dump_obj cross-zone VA lookup
    https://git.kernel.org/riscv/c/4b52da012040

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



