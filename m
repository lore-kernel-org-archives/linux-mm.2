Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBEEBCA5FA8
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 16:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DE346B045C; Tue, 20 Jan 2026 11:32:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B53E6B045E; Tue, 20 Jan 2026 11:32:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3032E6B045F; Tue, 20 Jan 2026 11:32:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 204DB6B045C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:32:39 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CEB571A061C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:32:38 +0000 (UTC)
X-FDA: 84352885596.14.C7C01CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1ABD640011
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:32:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M15qmp5z;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768926757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2zko+Zb4bPzkw+/TAVgPBIZvS5AM/HE7Ar8QGiBe6cM=;
	b=qtUcg/4AwoCmY/gfgdfVMF/hlZf6AFPfblapyFzZhyRBvuCxtOUMJKsJtLLsH54vNeDN31
	SGkwBRlIlp4mLux4Voau9C7uOsGZ7yPvKCnqV6ofFrOF+jQN1IegjV4HdCS/R5sRlUE1VS
	Jy2EBcPZPo+2dE3SlSOm4WYgJY7YD1Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768926757; a=rsa-sha256;
	cv=none;
	b=7QloaFhHxa04ueuqrkO+fKrn71bLfcVs+8VPh3Lzi8Gg1L8hOy0neWJKCItUk9DtjJ2ucu
	jy8P1TkwCHIy7Uo/2E23pB49AecfRqx3R5ZmmOxQo52ItEQ1PL3ien50UxCpijfUigwLJW
	sW4ePT16XpuAR9BCVN0P2+R32aCIjp8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M15qmp5z;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1934242A4E;
	Tue, 20 Jan 2026 16:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF72C16AAE;
	Tue, 20 Jan 2026 16:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768926756;
	bh=BkuoYdiOjEdaSxlt18GMMC+iBXjttPiaqaXPWhOTAOg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=M15qmp5zcgPGZax3J+ZpO3YDXmk7U0i6dtAhX2uoznBFQL6z5+MRRhW9PsqcRm1qP
	 oL33nkA/ilfO744wGvuCqNvPRWbuskm3T9vocCqHZoMXP3wuH19kiHhQJ7AX9YYL5g
	 ANehmWMB5hXgbPWRvRn3jXjgOHfvCWhlFiHmRerz+D52DzvXq6rgdViR5uplteyW3z
	 Q1Nm/DQLL/ois8KKJ2sqoNfliwN0DFQMdwRV0+29Ok0CNq6xiSr73DLWWTl3wvxeku
	 KrBOWFA4RZ3lBbyc2JG+BJ1aF2eB57Uyw2VkRpycAgiOSy2yDKJwTbW0bQFVriPBdu
	 pvNuc20XRJrHQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  Jason Miu <jasonmiu@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH 0/6] kho: ABI headers and Documentation updates
In-Reply-To: <20260105165839.285270-1-rppt@kernel.org> (Mike Rapoport's
	message of "Mon, 5 Jan 2026 18:58:33 +0200")
References: <20260105165839.285270-1-rppt@kernel.org>
Date: Tue, 20 Jan 2026 16:32:32 +0000
Message-ID: <2vxzms28ckin.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1ABD640011
X-Rspam-User: 
X-Stat-Signature: 4krmrd7omnkef6rayc1xeesgqy8i6ken
X-HE-Tag: 1768926756-285816
X-HE-Meta: U2FsdGVkX19Rglw1vikGY+8xNZWAF4LUcY5lM1fYugSNzeFv9rOuzqqu9lmWUt5k5DiQ0xr81aG7yFtT6nSgkWeWi74+2X0gqUIh6oukiAfgc5CSJ8luzBQVQQmBp6AbLjydVqWpFHQbcPRbObg1nnNIA5zwSTgxSoW0rMO499nJNOpvoebtjwIIHvvUifp43mhd68TZCzrB4EKbXW8csPjwu7N6FPHHYIr4IN8PrmNiLzkSk1lLE4HHE1sKyl/k7i4VCpjN07YLVbmMLUT9TRT60bWod/XzZNyIfpme4g7CCs/0zgRIUQRxFTa6HVZJn3lhnp7iqaZuP4VRRd2xn0X67k80dqsi0lLTRuIVp/Veoxs8HQ0hIsb6YWxtasO7XtHcuADczNJ4swUVZ1pAMMUbtYyELCdpnKTbTuUwTou+CoO9acH0tchynFGwTNqjQkN+bXLwMl8pD9ZtGoWiD5k95wuzXmGHGquP4kzQn4xhB7kLcnZzv1GNk620s5tRluCOxVbGJIHs1PaG5dxVFttFy0k/cS+vgNdAuHDLcjDM5EA90Fic31xCbV9tk6uKlUbqcxav827h8lYQmOxjzMvbuqDmLafEh3tXWZAbelFcJnm1TyRA7NPOx33Z/LZAjioJDRchFJqbynvaIuZ3MdoI0hqRLr0kFeJLM1IHO8epzyZPfFmk3FGFeDuWJEjdBFtAn7lg9+GFQ0xM30V7w5oWh5GFNclcTXphdKKg3Z8xhfyEA16qmdPSRawEns9AnLX1nTmHp0Ox+mBO0Jl1uctHR3IHxVWjaFEjqLJ9Ro7x9RyUuN04NwaQevXQqMdxVYxoriln3Vlb1qhkX8Z0tbc3a5bczJAgYPPABzcDhLMhx6kB40AzX1aQfMzMsxH+Y6qgBSmNt1n4C/WrfrpFrr1NGAmG1pIGf/b/DO95jbSTEX2cTlqY7EaQl4BZaTFZXzc3hpvmvW/ovfMYwK9
 +lqRKF6+
 ReFuADakeci+/ppIBEeN9Y+UzQOU2LXQHB9IaQnK3dnp+y4G7jzvvcGuEt00/rYzR111zYWMljwlRbUNd2Ws5LlCeNEBS5+tAAJiR8W0l3BBWqLzZKP7frjnH5C2IMNef1l0nwqzE7iFEwO8QE4yG4BrLyqLNgLUBwHIYuM+88+juW8g8xaDqIpSckTu78RaYMCaz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05 2026, Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Hi,
>
> LUO started adding KHO ABI headers to include/linux/kho/abi, but the
> core parts of KHO and memblock are still using the old way for
> descriptions on their ABIs.
>
> Let's consolidate all things KHO in include/linux/kho/abi.
>
> And while on that, make some documentation updates to have more coherent
> KHO docs.

Thanks for working on this! It is nice to have the ABI consolidated and
cleaned.

[...]

-- 
Regards,
Pratyush Yadav

