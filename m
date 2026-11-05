Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF924606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dxKzc6mj
Received: by kanga.kvack.org (Postfix)
	id 0B4F06B05B5; Thu,  5 Nov 2026 07:57:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08D7D6B05B7; Thu,  5 Nov 2026 07:57:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0C5F6B05B8; Thu,  5 Nov 2026 07:57:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF2866B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:57:14 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78DF3A0A0E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:57:14 +0000 (UTC)
X-FDA: 85401065988.16.F3F4F9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id DBD4440007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:57:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dxKzc6mj;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793883432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ReGNOaOBCMvIg7gK/G7qltHWui+c1mv7BQpRUdRVU2o=;
	b=LvNobnSjTorMc86DnBOWnlE1a6nwFYLU0BqbIOUhesIf3WPpZLfGgT+aOXKUnsDxSWdK0p
	eP/TRzNubJSem+130tXbaeFNOjL0zuaXLBBVSHxFK1liVOR88SnB3WMAb7KZujsaI77Iqu
	ftH0EOo3OBV/0DTWNOy1oizIEw2N5hY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793883432;
	b=U5shRobRTBOZQ+ZPuuqZpIcanDTk4383BfBN6Sh3bulFP1w72lXIVt0iLH/7tMqVp7Kvwj
	9RRn0TbMlkEKfhUlY5cOfvitYyLoFOw3TRfgEOQFdLsMcNGSqedKVCzED6mjoAM+pFDdsj
	+XAyC4kc041ske5PLRzp5WvuujAoxIc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dxKzc6mj;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D882605F4;
	Thu,  5 Nov 2026 12:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010D61F00A1C;
	Thu,  5 Nov 2026 12:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883432;
	bh=ReGNOaOBCMvIg7gK/G7qltHWui+c1mv7BQpRUdRVU2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dxKzc6mjgpEI/gtpOZyuQeLjQvddHurnQsGDoMpXnjknrfY2hKAiYfqUmgA557koH
	 e7jmaCP+YJaAZRcy5orhOkgHcEFid9SLfIXq5prOVlqYQVEZZwtmz9vUtd5273iQxI
	 UKxAfeO0bjeO9WLaog9V0U61zMaIpiIZ7UeSyqBH9eym1B0XA4KlbnQtdJ0bW7qW6B
	 Z1EHYFW28+7LtXyj9olREmKA7WH/g4bDfXZqlXZTqiELFDFk2194EltzQCAk3l7bUi
	 BrmfDnlOnDQgNxM40UatpYAMCFdANbrAM6XbiFTbSkp5ZSQsr91noJlmtNvMpPf0XO
	 IQZ1KqUo2KWEA==
Date: Thu, 5 Nov 2026 14:57:02 +0200
From: Mike Rapoport <rppt@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: pasha.tatashin@soleen.com, pratyush@kernel.org, chenhuacai@kernel.org,
	ardb@kernel.org, shuah@kernel.org, ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org, baoquan.he@linux.dev,
	ruirui.yang@linux.dev, guodongtai@kylinos.cn, kernel@xen0n.name,
	graf@amazon.com, liukexin@kylinos.cn, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v6 5/8] LoongArch: Allow memblock arrays to resize
Message-ID: <aux9Hm0QFJLUDPWv@kernel.org>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
 <20261029172956.20791-6-dongtai.guo@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029172956.20791-6-dongtai.guo@linux.dev>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 8zsi46hufrfgbkdr16gwqfifsxbxjcmg
X-Rspamd-Queue-Id: DBD4440007
X-Rspam-User: 
X-HE-Tag: 1793883432-10735
X-HE-Meta: U2FsdGVkX1/z4x1oNVkSgP6bkI5lqTFMD0r8SNRkigXCRlRfXjAkXlrad1yQlmdWyj8pjB7yDEim824k08CJbuWrch7tSfZ5yhXww228OxbvcJZYZIKu1Qv7OfUT6GF037TKR/DPJdNj2blWYxRCrtm5O8vS0dh+zPCHPpaPkHjs5hjlJcRgXS9aIFsK1U2l/toTDsnUGMD0Tjqwe9rozYnTcZTGdHFt8jNnbvT8sIgd+4MLkYxVTprsuizwrhb66YpA9LqDMiDS66PgiU02XF3D7V30/8qqCPNFzFmjrjyc9LpWoeLtXAr2crt9lrMTRNsJYtelPlEABBiP7Wn9qTyWfwIWcu3KDWeGsAwAVVqAk/sye1Ipx9bnjnwc28RYl/NzUy+XNPW4m3sbvBrN0iSCftUZ8uamReT1W+ckYlCqvC7ULdIgDTQ9p5iU35ExBBBUnVfaf3LTe6QDnwekU9D+I8ILlDaGUMGw0Vug+lcZi3fNnHbm+HLNa6dXBC7NZf0I750n4K76oGuqJR2OCsjDsIRaFbjk1XlZG/gr3H60YO0JkfSjtnZYfN/o7Gq5quXEM7XY3r15yqtz+TfdKFBHQz0QaMKfPCLUatc0XfdEq09oISQcJm+KEpV2VNjqEb2GByFS3v3ZCmVUDXXUlKjg1VyDI34FEGCWtGOwTUS3fnDcRT9KTmqwtbKvBa+79bo8Hpg8Etkk5u8YhSKfOF9hzqbWOj2AhLAR/mM+CCOTB7tdU3r3EPr0MRoiKimwNH+8l9qF0bdOz2ag4Tkj21ZwD01x0q1MUKUZ7ADJA5Z4MeL038pY6a9jbbOhaITnfMo0g2adD6dgxLoiOUPkNjf0JsWdFWGJ8sGTAEYKq9DCBtYbRQdXFfEQDNUGz214Y6ZAp6ZgYbkFXsC/P/UtUMNLvmZ0MJ8ummT56HmRz/Pgf0IQRjDuhpqQrCoWhD5vqvm8y9W1Pmj9WdgAbkl
 +82sz6AO
 agBjthAWh05n8Az95rrpXVQAJeliVRCkX591WoayZ38PTw9DL1xUV4PhBxKOBJjydkHXyQyRBooGG1T+GX2ynxCSd7b19wYs+lQ825gtNKjNyxuz2WETQagCdUkR/MR/jom2V0V2rz9m8yoGkLov13QhjOgCoprQ2LaKhXDfMTonv+J2I5NO74yGTEsb4OSiGlIsAK6/H04iDQZBE8ztmUE1ckIilQ2fcmpsPUr1GKc6bFkSw6TnB4e5m3DRYTA9Ww0yr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 02:29:52AM +0900, George Guo wrote:
> From: George Guo <guodongtai@kylinos.cn>
> 
> LoongArch never calls memblock_allow_resize(), so the reserved region
> array cannot grow beyond INIT_MEMBLOCK_RESERVED_REGIONS entries
> (INIT_MEMBLOCK_REGIONS + NR_CPUS).

This might be something to fix independent of KHO.

Huacai,

What's the reason LoongArch never enables memblock resizing and why it
defines INIT_MEMBLOCK_RESERVED_REGIONS to include NR_CPUS?

-- 
Sincerely yours,
Mike.

