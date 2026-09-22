Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E3DAC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 086A76B009D; Tue, 22 Sep 2026 08:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05EF16B009E; Tue, 22 Sep 2026 08:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDD276B009F; Tue, 22 Sep 2026 08:30:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBF0B6B009D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:30:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E735A047D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:30:50 +0000 (UTC)
X-FDA: 85241332260.30.9F3AB99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B5C5840015
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:30:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O4TcHUGv;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790080248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ic/h6nB8JUlBM8zaXvVjgvTf0SPmAf0fMbuRRf6h1OU=;
	b=x7gFD7JL3wT4X8zQMQC1KGHLUhL4L6hDFuR/SToklxbgjEeRH+sI1bsxyutPkrfpYKdEwX
	g7o5x+bWxTLGAPs54ILA7Z+r+ugtRYf6mFPc8H8lE3SqPeMko0THh2dV+R6K/MlP+ZYMsR
	oNVSYI8LnaQ7Fnomt6Py9PS9M2cqskk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790080248;
	b=pC656Jd/pMRK737H1ftLe2BWWqHhfzCrsFuTeJJmM5+6tlWP3aZfFZHgeSiVfxh+yVXvrZ
	ZWTBuVYzr1IfVzojLoqLQ7d98bKKMaSs/mhcz+3VK+1udUMRWz0hNLIcOzNOZ5dk90mF2V
	U5GeiWJpbxRnpEAUVseJ7OOB62aZ44Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O4TcHUGv;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AAF2B43E20;
	Tue, 22 Sep 2026 12:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E541F000FF;
	Tue, 22 Sep 2026 12:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790080247;
	bh=Ic/h6nB8JUlBM8zaXvVjgvTf0SPmAf0fMbuRRf6h1OU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=O4TcHUGvDUaiZAcbWB6yDzYBqy/coJnW/7scfWIrPA9JZxubQUqIJf+7nKN83DAvz
	 U3rD2gr4++NFyoHbWT7OGBHQAnistbtAfT9opp3pPyes8L3+xOT//5ld67ttl0foKz
	 nXPLSXKR+pImSUOXClFkHmJBrLLIrFeQMPqtNcb9BryKjXCfhBjEnN9oi8UW7pkOYA
	 Hq+AfNeeC/W59e3rt+G6pf9lVI8MhGhbKvOoZk761TLTZJ9xR5xBsZNMSg2dNWGc8+
	 FIGiRNf6VjsnCN/LNVHx/rSj4nVE7vE+zwGwcigogdyg+GL6/GP2A9eRl5QX8kga0z
	 ZSCN83j72ugfQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org,  pasha.tatashin@soleen.com,  pratyush@kernel.org,
  chenhuacai@kernel.org,  ardb@kernel.org,  shuah@kernel.org,
  ilias.apalodimas@linaro.org,  akpm@linux-foundation.org,
  baoquan.he@linux.dev,  ruirui.yang@linux.dev,  guodongtai@kylinos.cn,
  kernel@xen0n.name,  graf@amazon.com,  liukexin@kylinos.cn,
  loongarch@lists.linux.dev,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kselftest@vger.kernel.org,  linux-efi@vger.kernel.org
Subject: Re: [PATCH v5 3/5] liveupdate: kho_block: include linux/mm.h for
 virt/phys translation
In-Reply-To: <20260904100852.26006-4-dongtai.guo@linux.dev> (George Guo's
	message of "Fri, 4 Sep 2026 18:08:50 +0800")
References: <20260904100852.26006-1-dongtai.guo@linux.dev>
	<20260904100852.26006-4-dongtai.guo@linux.dev>
Date: Tue, 22 Sep 2026 14:30:43 +0200
Message-ID: <2vxz5wzx5uz0.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B5C5840015
X-Stat-Signature: dpkwx5izf7y5picj79jq1kiapmfohbfi
X-HE-Tag: 1790080248-73541
X-HE-Meta: U2FsdGVkX19b3PIdAK1hL6VaBQek408MhYNNWHC4HXeyte9XgKIb1UHYLRMIUpOAsC36t48RKtHmI8eRsPa1UoGYtncoirvXjcWtdHwYYirUTyua4Eal86bou1+jciR6BT9BBjFP5AJ/v2G6yr6aQ6+GTrF8ja43yvJLN/FsdyRzzofBWzLtr9aE8yyqG1pkeee3b0Enc1TCG0ely9m+QpQ8fzOfrftpxNXobMI8oJ30jTBdFQYT2svZPeHW+SIVDV+yItRRhS3sUzgNLS0LAjgQxG6ZHbtQYyOkh8ZWPEKuSutCfKDDXnJA6CdkNezM66Um/JQQQxmXnwcDIA/EzSg48fU9FcecN5h+4dam9T4y1KIP5mbRXgEEFf/7cGtGmj6J78CO2P+SG/e2skXzvxoPmkxPQI5FbahUALN3FFOzjCGC/ItYhv26ZIZdqe7NHDB6eSDmIlMDXm3sdfMTTjQaVBzF/tD4dRfs5ej5t13qXTHCHheLZw4YUIzs6LSRC2l6Kt0Vrk1fXw0MFBtPAa0VetZkQTdAsFU9P9gW+UeqtOzH7C7tFZqXtmmu/Ufu54AZfZriV8KKKa0trZpABW5+Isg8I49XZ0MXOh5i3rrqOB30osw3iihHeIC0FyNWRWIi/KYkwuuQFYkPIjC8IEBGzwZ8rH9lzOqJC1T/EJptG9q2hZfXcSMr31zrxdIqCzT3Je3r6xPVKx9VMNC3JuVccja3sT57qLd/9xDSTh6zZTMpRrgpgagWLUloUuRohJdm7/Yzqp29yp8/189g2epxp3fC8iUOSK05Bzlmpr+l4ef2jl/mhEqWMOUG4zq2gtWkFN1n9vzzye5J3fuA5nj11Vj7CzFSfMSDRTv/hCus9N1aAqBDTcJywAWP9z4fgVrNrAdVXWTZhLA7M89jdBqr2kBXfNuZ0vZb1P7C4NliuylXJ+4CiFGOfEE+L6R7ruaz/5NdfCqt51+djOX
 jnLWyxfa
 yW6MMqAdeY2rF2Qjaw8e6TL6wW8vp0sLOqBrbSRCgR/2pgbl/yxRMZgM0Gs5u4FSFJcK7BpCAYPtDFNFNUu68PA4cGPjIlSdTHiDXkc6WkhnSJCqAsxJUF1zVvt/UWywmQKO7lSIa7HAwZG9lKsjEUkERd67uLu+KzrxdIqyx43YXBZm6oFSeutnusSBDxWb1xjitZH4WPeNCnmjg1kImNXP3NgKK3zpl0cy0uOFTaUtucDTUZdr2xBuISihDSXOrOeRfMmukMKJ+LS7Smej83u0dGf4pJLnHmUHeX85+qeEMTmEEPAFETkO/kB3DSCWc21GI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04 2026, George Guo wrote:

> From: George Guo <guodongtai@kylinos.cn>
>
> kho_block.c calls virt_to_phys() and phys_to_virt(). On LoongArch with
> CONFIG_KFENCE=y, these macros (in arch/loongarch/include/asm/io.h) expand
> to offset_in_page() and page_address(), both declared in <linux/mm.h>.
>
> Since kho_block.c does not include <linux/mm.h>, the translation unit
> fails to build with CONFIG_KFENCE=y:
>
>   asm/io.h: error: implicit declaration of function 'offset_in_page'
>   asm/io.h: error: implicit declaration of function 'page_address'
>
> Add the missing include to fix these build errors.
>
> This is the same root cause as the luo_session.c build fix previously
> acked by Mike Rapoport [1]; the virt_to_phys()/phys_to_virt() calls have
> since been refactored from luo_session.c into kho_block.c, so the fix
> moves with it.
>
> [1] https://lore.kernel.org/r/ai5nYlbERQBXRHSp@kernel.org/

Drop this paragraph please. History of previous patch postings doesn't
belong in the commit message. You should write this kind of things below
the "---".

>
> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  kernel/liveupdate/kho_block.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
> index 0d2a342ef422..0d56891b2f4c 100644
> --- a/kernel/liveupdate/kho_block.c
> +++ b/kernel/liveupdate/kho_block.c
> @@ -25,6 +25,7 @@
>  #include <linux/kho/abi/block.h>
>  #include <linux/kho_block.h>
>  #include <linux/slab.h>
> +#include <linux/mm.h>
>  
>  /*
>   * Safeguard limit for the number of serialization blocks. This is used to

-- 
Regards,
Pratyush Yadav

