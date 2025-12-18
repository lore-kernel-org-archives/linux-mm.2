Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF65AD68BE3
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 07:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45ADF6B008A; Thu, 18 Dec 2025 02:15:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DE336B008C; Thu, 18 Dec 2025 02:15:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0866B0092; Thu, 18 Dec 2025 02:15:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1F66B008A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:15:15 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D0229140CB8
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:15:14 +0000 (UTC)
X-FDA: 84231730548.14.3FE1A3E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1CDCA80006
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:15:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YDdm6kiF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766042113; a=rsa-sha256;
	cv=none;
	b=wO6s7QJqb+EaVxSIcVA3nTJ4TST/YbaSrMmiH/RlJrzjC46Ij7fIQmZ70bVjxr1EIi5zg/
	HgI44apGsUvsSlZpHH8pP90Tvvd21xx/ZXzU2CQ0/jM7pzrCp5Kgb/Lm9xfHoZ5h80u+QY
	C8GaD4ui1PDuwvxopEa5iMJEu5/0UUE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YDdm6kiF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766042113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wI5zk1ieSLi83vyHBIeG7fn4tK1biWM9ivGz3DLAadA=;
	b=1r9af5plehC3rQZpemyf4yeBZ525LGOCn+lYUTM+McDzO6xOrSXTeJbQEp/yG715b1gqrb
	iYrkLIF78nCCzjObmXY77QnuFuPQZXNyMduWdfGo0x7oDn9WXOuYUuToAoSWTOCZ65zbn7
	mopIJwi7UFX382WR9WHA5RIlwkqzPt0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ED3B643A23;
	Thu, 18 Dec 2025 07:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67ADC4CEFB;
	Thu, 18 Dec 2025 07:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766042111;
	bh=xsSR5/gROtCj621epPFc8z9dY6QJQQ7gGEk35KMHxK0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YDdm6kiFrsHFIigCgTMUyicseMcXv/IwcfId/8Rfq9RBAKmGHk/dxaVfSmWuLOgx8
	 LqVEMmq+y42Fnad8K0nLh7urq/CzvVo+Ha7Jj4DcwPHGvcc4QilPG3MiwPu4N/fua6
	 td/XPdO5yVny/RhgUqN1GFnUN5Oe/3HTmoBZib3pCqI+oY2rwCXCyhwBPEWky6vSDj
	 uCTxKrHQMVgT1awg/XR5WSy1Sta9e2f3yJiXFb9E/H+G76ard2Xd0HEtNiNRWeoeaC
	 k1cVyHklkL5q3iRH5jMeXEEMDnCz2Xo2rGxcTJbwhjxvvgQlNxBNcDubXQHLndxrX9
	 HLbKAjrWdqEFQ==
Message-ID: <e9033bc2-9a85-45de-a005-b9d12eb81f66@kernel.org>
Date: Thu, 18 Dec 2025 08:15:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 4/8] highmem: do range clearing in
 clear_user_highpages()
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
 <20251215204922.475324-5-ankur.a.arora@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251215204922.475324-5-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1CDCA80006
X-Stat-Signature: k7fca3h5o9jptzwha3rqdksjzs99mssr
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766042112-802883
X-HE-Meta: U2FsdGVkX1+DivO+j4xP7NTjCiXagvl2VHQguuq2jn9RP3HLbbsnfppTafs7AEnQnjpNE8cpCTPEu0J8kJUD7H4FZUE743Z7XhIsXvOhgPq0LxRV/RhfTOCxoRXc5BvaJONViVKzJRTvTYjGxLVRTOg02e9JyKBHmCK7Y4RiK1i+wfP6VoUXnDf6XoS3p6WovoQFDBDcwKKS9XxBtOaAowOreli2boR4lOlfbhFlkQjDa/hd825tm/zDNsCpfkeyTH+lCkhyt3puFsOLgDCesCU/+M6JPBQlDlglejU6OAZ3pi+E/xRt8WODPYBxP1E3XH0R35vqMZnvSmnYSP+ImzC/TeF2xX4OFeoIrzXf9XmMvAkMpH3g9qxyFi2XW9iHGo+pU+nLnHlW5IobY4brsgrR7/9dfOR5MyCIm3mDuOCtDUuEi3fxfzcaucEPhY1vWI8ZvIalVOclq1szaDUiobZN8ZO33D8c61u5xHCRA/GEcDSX+8bhFHo2iyHBLgvx+FkGqJPpl60Hw6LSINatGB4K7YKMof6vfpuc/FlQQ8dLw0oy+ldbtLurFBJZkg/COdud9F2HHUvR8TrwxaMgZ0GJL8v7QaY/YdExiHoFUo7kdkGkgaLTa0xwYUHQOtiJ6FVgn5TUcQ4dU1B7s6eHVtxMj+DQCyFt+BlqMpZzdFn5ttYDuMgRL0OdqdomxN55AQ2sovy1cgiKZqASw0FyumVV7QFGI4niiAHGi3HtMe3gZknBWHc05Qi4PfFdrZC14Y8sFg6Ms/reYjew9Y4Qwc/cHNm7n2FebwQwdqIpGHSu7viIC1eYj0TwxGYGv/DGGcizWG7JJL8p3/sLUIGbf2MHl76kRy9qV1Egnzn230/ruepuQ84QLAoqbVQ3rhUvbhAv17wwKkRNLwYIPCfCRdlkvbYb0qkirPtBDUAmlfdkb9QRTXOU7XhM4IdlcJNheHyPNrWO7pvLvyO2JNP
 0+R0rtLQ
 eEMgajjhRcUuz0NSpOAIy58MnzJ6+ZoI5/FwvCE7XTHrdwO4i/4ur+YB9DBYEfuncqMsYSscztQRrIawgIaxlland/oUUSbE/n4QiPWBtmHh0dJIBEt9pjo9oy751Ye2sk7wEgCzIhf8/4cWmm9aSVVn/MLxhCCuOL62ZQb5M76lchD2do+3oHbdD7gEeT5JirFEmuEoujIY16LMqmnWF7qbZTRINcL7Bewap7BGx3Sg+Gzc3hlY9pD1xmA8Xrdci8scE5zlCQWJFjx+8J/xUWC46VaabzAmjjXaAkmVfYTpS0nvO6cUNFZn/72Ua/wLU0mB4O+n5T4NFObw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 21:49, Ankur Arora wrote:
> Use the range clearing primitive clear_user_pages() when clearing
> contiguous pages in clear_user_highpages().
> 
> We can safely do that when we have !CONFIG_HIGHMEM and when the
> architecture does not have clear_user_highpage.
> 
> The first is necessary because not doing intermediate maps for
> pages lets contiguous page ranges stay contiguous. The second,
> because if the architecture has clear_user_highpage(), it likely
> needs flushing magic when clearing the page, magic that we aren't
> privy to.
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---

Can't you squash #4 into #2 if you move #3 in front of them? Or is there 
a dependency with #2 that I am missing?

-- 
Cheers

David

