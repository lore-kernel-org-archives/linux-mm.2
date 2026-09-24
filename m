Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEFEBC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C41516B008A; Thu, 24 Sep 2026 06:19:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1FD6B008C; Thu, 24 Sep 2026 06:19:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2EBC6B0092; Thu, 24 Sep 2026 06:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 935A06B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:19:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 25691802B6
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:19:52 +0000 (UTC)
X-FDA: 85248259824.03.2771DC5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4827740009
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:19:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ESQY3yno;
	spf=pass (imf17.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790245190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCKNP1/0Rmn/MpEJDFlfeRm+6kBNel4+d5ZQMPI2k9c=;
	b=Psib++e2seDXz6ZQ1atcvUShGtU7sLmzWrbXzWW2AEaNgdDOqQMkwbwTtT7dtQyfGM4lix
	mnP+xLUpQqO3JGbK4LTpLxf76hT6VLkPCqwgJwFazZA+GfCSeNaosnWPxKyM1mUoHNOnnU
	Fd7jPAxSp727KJrNfKMqN6qzvXCsAFk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790245190;
	b=zWR6YACuXf7eDG8RQh8QJLRs4pjvGivacNoT0IY0K3PXyTAiS3ZwtHXFS1ppTErBIdERB5
	cipEQc7dQ9iY34qL6D0vnwmKtD3/4UbyXEX0oC2+SVULYNkpWnbIxLixZz3uFLoz6Fe/Pz
	UiFS6yU9JV0n0MbiO5DbKcSAnC7jW3o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ESQY3yno;
	spf=pass (imf17.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2FDD1516;
	Thu, 24 Sep 2026 03:19:45 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EDBE23F86C;
	Thu, 24 Sep 2026 03:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790245189; bh=H6qyIMrYe7iz8AdnWWG5WmMCCAcRYN1m8wWC3Jo6rHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ESQY3ynobYcSFvJBweaWPCannUZiil7EoNCgE+R4PbydTgpus0xNezG8/nolmGUWL
	 b7NvGrhlB+zRMF4BFEVy1qvd2wIJAcvY7KvGIvFvXie4xaumiZ3tI1pkPMh66ylagf
	 iQDYSyAyJD1vFph1jUsqQtWSfK616sYEggvla6AY=
Date: Thu, 24 Sep 2026 11:19:45 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Will Deacon <will@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V3 0/2] arm64/mm: Standardize printing for pgtable entries
Message-ID: <arT5QXAXFD6u9tOB@arm.com>
References: <20260916044933.2689426-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916044933.2689426-1-anshuman.khandual@arm.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4827740009
X-Stat-Signature: fzp675auedm3eze8fjgzgz7akhmsz3ti
X-Rspam-User: 
X-HE-Tag: 1790245190-134728
X-HE-Meta: U2FsdGVkX1/WZgnllG1MD5rYT8Xy0ZgADzDjIz5Z7at68Q1bGE6yhdzisfBXouh2SmuN1N4eUEFZIACKx9PQxh4TmcSJTdE1YnR/xyXLoEqJBFvKXweU3PUOzS0nA/aP0tM64GcDsL1Ejo7O6DT29xy+bRsRMNmoEqlSpiVCJfC39eSoGsfk+doQOB4Cw/A6ZnrefNsM2dSl94vrzXQ6Gn6+ttPb7KsevXEUYnOVM4nCaY5paHE4fc+kuX3fB0kxwSipOQfre2rBfEJ+PdV6CWu05K+BnTU85hzd2qvMC5r7lAMPG7zQpzl2TL9Hjb2aVRKBUla0IYeNuE4ay75sOdK3hcMLAzsSGnSokAoiowX59iPhsbC0y1gqX/sFE7PYW0patdhNSx7urmbA9DRAL3hhpT9qZVjQecCN78g9iEWSOunmSmZ+fAgs55U03ttNNS2lkHh0rt2bsxSQLOAK6RlUai+/CUJh1NYvqP/aaHDmzaVWuGnKfHhQwj0fChCS782iQXXHUxoNRYviiPmPdkBsuYAMVWW02KW32Ong5yM7+mVvYCseoQztuCcrKzn9402AEvFWFCVEfyC48BUu2MDy6IrsVFTl5KdjhnTUG7kZPxykr7RrASWtIt6N/wQsBj6arhNJ86TWNufTZIMyteHvVm1d2cuuhAnEJvkHLP/lv2RG5qKUTqUuPzxz68FnBtXxtmbE+jFrY+YZhxcESnLk+c+XLHGmxFhGcvycKW4+z0HLyCZd+7POX/qpEWkaCvVJMQQgXmteLV+4rokR7yypDFoI+lQw6cXeiKIOK8MR+Y+wmVfDAnZHbsxTkMhxXUrePu+KRY6JCG5iYBGe5Az7ghpLn/oxoqe/ZGf+PrCOArF0yVSTnoYwQUY8mahSBaBlttNzk6/CY0AD3OHYcTj1NYR7NntjNL5hm2NzkIMbLfEg2w+EvfNN4AG3PiDRGOa87K2ldS9n22NzSMf
 KDBZPR92
 Jln/QC1mdxY3djqTpjYw3lNYNCjepQkv12rxaO6jBb8vsFbahOVTUx81ygrTrsU5dfvzKdrdllTogznr0Yn51GsBJfxZo3lmvkqPPZcnlZGuKFH7jhi4yjQrzPOPwLHpzqATyB4PEDjBe2IGsl+7/EdH8aO+TbRuWOazo20fWXi0FUTSw3cO2PLDIK3N00YcOgfPs1eomJ0nwTFLJhDEaAHg69nrMVu9zAACi1JxXAqMh8oVnUjYjODGHZ77Sm4mlAUd0+ipbOnGZUOjYbzMMem9FQqDRcmWc6KBxp71t9NuvCPF0eRmzxOgoCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 10:19:31AM +0530, Anshuman Khandual wrote:
> Standardize printing for pgtable entries using recently introduced generic
> helper ptval_bytes_to_hex_str() in core MM which automatically enables 128
> bits entries when added later.
> 
> But first move __check_safe_pte_update() outside <asm/pgtable.h> to avoid
> a cyclic dependency while accessing these afore mentioned core MM helpers
> defined in <linux/pgtable.h>. This replaces the original page table entry
> print standardisation proposal which was part of the D128 series.
> 
> https://lore.kernel.org/linux-mm/20260729122452.3797443-11-anshuman.khandual@arm.com/
> 
> This series applies on v7.3-rc3 but after the following.
> 
> https://lore.kernel.org/linux-mm/20260831054331.625505-1-anshuman.khandual@arm.com/

I think this one was queued by Andrew, so I can't take these two patches
via the arm64 tree. I'm fine with Andrew picking them up as long as
there are no serious conflicts (I just started queuing stuff for arm64,
so can't tell for sure).

For this series,

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

