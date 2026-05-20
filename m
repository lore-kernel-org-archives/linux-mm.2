Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73DB3CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 05:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E48A6B0005; Wed, 20 May 2026 01:09:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 795D96B0088; Wed, 20 May 2026 01:09:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB566B008A; Wed, 20 May 2026 01:09:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D0A96B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:09:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE4E912015C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:09:45 +0000 (UTC)
X-FDA: 84786620730.29.E08F84F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 275E21C000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:09:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L/DWnFDf";
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779253784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7/jZW1N9MI/xVxMIZT7q6FGbksoc2YLmCYf5xpAjm9s=;
	b=2rzcnV8MBWt7sfR3Dvek5P1yEi7GAXhMZ6+SoERYxRw7owvjUGgRFlcRj1eGzZXzlAFawC
	kawBNLo9Rat/xblUIo1sgVrLP2cUxotpWJEddbfvMDtg0b1EithwGF3FPNBBM7p+BpIRge
	kZk0Vc479a6jeIKt77CRj6a2hoYWZGM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779253784; a=rsa-sha256;
	cv=none;
	b=rsVn19oFGkYE67sfstNZgKK0v9QsBUtd7eJ755hwqAak1cuW0zlTMgKoaxRRiibVn4/187
	i/jCrQ4UdApyICtT/fNt76GYB4qe1yabwvcAhSucthBv70/rD8beB5SovYcgsNcX3rsCw6
	/BjFHjNeP8TTx+TzMfXZ56S5SM3/ez4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L/DWnFDf";
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A27C160120;
	Wed, 20 May 2026 05:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E478B1F000E9;
	Wed, 20 May 2026 05:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779253783;
	bh=7/jZW1N9MI/xVxMIZT7q6FGbksoc2YLmCYf5xpAjm9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/DWnFDfeVPs6tLar6fdfdg7BrzlH3ea97UPQmkAHb07Irdej/Mq8D1gq90TU4oU2
	 I6RvfgNnKkNiHQG+reepBNBDRoq9Htwo6TWcEXda8oEOUIF+AD7all8JDsqMS8MLNu
	 pM8Ork79MF8VciT07zLXLI1B/+HV1y3IrLD1nRdHVg6G4m/eA7tkqB+hgsDkifWcys
	 bmwwp7E3YwSHR+A4/KL/nC2szgUuEJu3/CUmEJt4A/McTcpHCpDp0nEJmk/lHaaHgb
	 WESlMs4MMvAv5nCZEsF5xvchPkLEf+di6+w+2Dr70gxaVgyBNUW2l9TwmYL7ddGPMe
	 7ryaAnUAOXalg==
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] kho: fix order calculation for kho_unpreserve_pages()
Date: Wed, 20 May 2026 08:09:26 +0300
Message-ID: <177925371880.3535040.4659421700056655477.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260519133332.2498092-1-pratyush@kernel.org>
References: <20260519133332.2498092-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 275E21C000A
X-Rspam-User: 
X-Stat-Signature: 6a6pn96izoeyqqpcd6a5yfpb3dsekptk
X-HE-Tag: 1779253784-330112
X-HE-Meta: U2FsdGVkX181M+Yy022egNHJQ6fztP6lLNzOqlUMrkvek7VgPJxkKFYyxklheOC8rWR8J9pzJ0m4PWnBlXFNorJv2BrpkIpBZeJ6aAgCgVZrAoQv4q1K8xvqRSxHMicWUVJD0Xx9O55bED0k+VgPyqaQ7x1I826BdBUzKmy6WJgVjzwMvRw7oiWcKaZTGn4tAsRhf9OtdXfXQRlQFk57FmXCL0DL9I7yF8Z1TzvuVCUpMqMcECSkSqxzSMXCoLv/7kB6fqW1fGGjzvzOzUSx2KbQNzU4UBo1zc1ChJFWua3rL2EmqBOZLCN7Tl34P1KlTS88CJBSDWZwzCLyVa9xjPSOxABL8ukVbHch5G9ohMXltAkoPDGsu/HqfVOAWXDQLF6Pdnl/UVRMZ/AddUc585647fwoUUYx+w7pohAuCw3xve//jJ8HiHq+bfaYIZq48aOQw07WX3dHrr8e4igyGZSqa8wvRp2ZrS/bqZBH2/yFsW1x4faq0npObtodms7WCl3L92LMZfiYSoL1sD9AAaLuw26+SnQIu1e5RDbCBegIXHEAb+/ZNBrFIdKFDWcocb7NSkMdAeUDJOz2K5tZrzzRewnnsZ4iLQ9OYiqNiQSi2tVUTpruEXw6t0Ig37Oxf5OtFtdy4hbNfVNEIycpBP4rwYq7n8cSXgq8l2q5ohHvHFVtaw/n+FB3ka85hVj+524XsShTrD7hywqdff1luwJohRuSYRcPDyMNZ6p2Q+VZhU29UNmjJOfYUl2YoQiGphh3vrC+YzoJJixJJhAdJTbwOt/gIRaPH/12Xyb0lL1VHHLnGAtlUXqahKO/NrtGD3Aj4VPc9hpT4h/6i7gNnHiIEftYcykX6v3OLogEatHgKWArSHiHrHAT4tIOMSr2q5/eZXewQQT6aA7Wb93SQFypJNY6le0PiuVHs0fA90azLAY9Hrgrm5VzCQPQzXQoWoVzj24p/jZpgWIB7SI
 s+ewRyQt
 N/SZVT4nukF+e4Ya1jqM3daXCnGmeqJq2M0G/KjpgBYhnMHQMhosStRPvPrzsupZxqzta9quRV0gc1MNYL+lH12sukfNFBErqQqcXH3e1LSbe0c1tessiDqUInWJYMDWQknW7QHh4lVOUE8PeHOjW63apgNpcop6zuXUtXs5r11GtThC1noa5TR1HDkAD7PHC3C8AuEAZrWi52e+/UIsQXCiXTm3IgwGya4SSE/DtKtD6CqVdgPWVldFNSWV1LSO/wIWT6Wqhbnt2DsWF7wnYMh8OuKDyHT+Jznz7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 15:33:30 +0200, Pratyush Yadav wrote:
> Commit 91e74fa8b1bc ("kho: make sure preservations do not span multiple
> NUMA nodes") made sure preservations from kho_preserve_pages() do not
> span multiple NUMA nodes. If they do, the order is reduced and tried
> again.
> 
> The same logic was not implemented for kho_unpreserve_pages(). This can
> result in unpreserve calculating a different order than preserve, and
> thus not actually unpreserving the pages.
> 
> [...]

Applied to fixes branch of liveupdate/linux.git tree, thanks!

[1/1] kho: fix order calculation for kho_unpreserve_pages()
      commit: ec4084bc445027a52f600e30a976928be1ba1950

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: fixes

--
Sincerely yours,
Mike.


