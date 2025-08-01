Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D96C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 22:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978EE6B007B; Fri,  1 Aug 2025 18:02:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92A026B0089; Fri,  1 Aug 2025 18:02:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866CF6B008A; Fri,  1 Aug 2025 18:02:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74E2A6B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 18:02:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 40BC8113B7F
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 22:02:29 +0000 (UTC)
X-FDA: 83729563218.19.5FAFB5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 883854000D
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 22:02:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OE8yYfkl;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754085747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gv0daDqYl3yFE8Pb++EctJOUqoqWOe2FcCXUxom5ywg=;
	b=zFdurUxfqMuX5ceIUcLrqSG4/cMGBaoC/ke39CD4ANd309LsE5d6Ms9cnNv0wR4R/4Dis8
	EoeNj2E8XOjXVNiZ2L81CDt5nWB/rP7HAyJnQf6hxFn7kB7kj9WJoTxagI+RxYH6FAwt0A
	fmAnIt1brn7+pvgoZDS1g8+0Gp2ZN0c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OE8yYfkl;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754085747; a=rsa-sha256;
	cv=none;
	b=cJc5o7QD2iS/bCLiavZfPLGCJ1u+MyEOWChPxuL7sfyjgopPjM7sm22slTYen0zLR47iAj
	Nfuj5/i7LXF0Lw6kuY5svuKJF1h7q/aXRutgIkDagPVGGNlk7x4lqDqoYvp4siH5LHFQxq
	wHZsbo2mlEgNcqeBlUumj1tgUg0YlwA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C667C61130;
	Fri,  1 Aug 2025 22:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E024C4CEE7;
	Fri,  1 Aug 2025 22:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754085746;
	bh=4F6coz0MQMZE0I8tpxLsayuZ26sod/oOCtXdM8eyugE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OE8yYfkltKGteePz9G6PQt3VxFdg6L088voeIglN9qAsQFxrfGJnCXKjV3w1PhX+h
	 sxPtJ+WjjTLeAl3/ZOpip4gQT7E0Ei88WWhjaqaYOfHJZBF4DQ/vA7BV9jdpqc+g5j
	 7vljBY63yUCgmmA3MXQ/5ZB68kH/esIk5rMvsRuE=
Date: Fri, 1 Aug 2025 15:02:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Fix typos and improve output messages
Message-Id: <20250801150225.2f32b042735d68f8aec203a5@linux-foundation.org>
In-Reply-To: <20250731000251.5412-1-swarajgaikwad1925@gmail.com>
References: <20250731000251.5412-1-swarajgaikwad1925@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hcgjy7kgfwdtmtpsz8byof538sahpxc5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 883854000D
X-Rspam-User: 
X-HE-Tag: 1754085747-868505
X-HE-Meta: U2FsdGVkX18mYEyxGxEdjsTnZwE8G/rIoi0Zntt2Mpv1tr5yDRMLUAp7e19lMlzusJElD//XuUws4j1OwQ1UtSWZHr9+75Ht/skM5w+vsKBF/xdnq8/eiqqzWpZnjm1UNE8bnjRxwjpWFiUOAcPQLZrcPg2WYMMIojZbE4ULVdB30Z1693sdZoC0LNt0rLoA/KbUD/ahI1QnngjD4Si5noO+TS/Lga1uu9mwQtn9GXDBdkWOYAEtIXMAdNJ6/PPaPxmfXxshPV4jnlIlxCzCTxS/ZU/CAa5jqiu0Ro+NO3URCZsA/v8KfHkmOK7d9rUyEkSJYJF+Pi+US1Tfkbg9fDJyH7fbiO/+A+HaivI+Q6AfIphL2WoQzmc5GkO/Ee50uKrmGnGStSxMgsyppcX89ePWrJvbgg9WNAbyrxBrxvj0I908BYxVD8x7oYGkhrKNjsSJKdPvfT5cTbcprRhUL9W1B/sA3N6QyTeI/E3JIgRQkU943cNy5OMdwRvEMARWX1FXNErUisffZXT7093f+sJjsJMi2SjeecvJq2u704sGBvsyBTeP0C2l1jeVTvzQRNOTMkQVTjJ1Ek1ONVfir0NeL+q3TvQejA867GVv81RA+EG/JvFUeNZqef6jfF6C/h9zhiKUD9T2/FHWQ5rQmS9jSLS5nBDRsHmT10cWyA0BQo2E1pzddJlHxr3K8AymY6GEbew5iLvNqIPBSo0obUI/HStdR3MyGVJlxa5L6hi76BQvp0WVr83SQyG08ZTlD9JmY8B+o66qK0G46s7+UDV66y9xzmG+J+53ZpocjdWTmAi5cX1lmo7KHG8MxYXdY5dUCBM1eRulVNgqy3dMFT+In2vV+LlGg9aM6Tsv1NoJ2xv9StbzgO/QfnAAltVPu4Rr9ak9teK0i1De5aIV4wZ70O3sOvhcBRBLDIxpos9aLQTQNy2Pur4PWGfk+oG+oDGNPcFPRrNgh5Ps7xu
 21NFkdkk
 s4DXW8Z4fxFmlqdmpOCfvMNZTp198haYvw59mQ/H3SAR3uFIRBrOGKXr6WbWIBuVyhx/eRhz3m6yPWSUX8BCiSfXazJBbjFibgYzi34yBA1gji/L2K7qsQnI7hueoqKvAW0t1PSsOBmC24JWj2mNfUFNDwApMrNydY74V+NW4Yl3sZUX1+cLoZDoJhc8c6RYMta+Ow8j6LbgJxs8Tg1RqNFgPWwrYPTl+NpVcFEF9P+Fll0FdVEhtedHUuMZpYdzZfbj+ZelUhuLW06s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 31 Jul 2025 00:02:51 +0000 Swaraj Gaikwad <swarajgaikwad1925@gmail.com> wrote:

> From: Swaraj-1925 <swarajgaikwad1925@gmail.com>

We prefer that real names be used, please.

> Fixed spelling and grammar issues in test output messages
> to improve readability.
> 
> Signed-off-by: swarajgaikwad1925@gmail.com

Ditto.

> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -48,10 +48,10 @@ ifneq (,$(wildcard $(KDIR)/Module.symvers))
>  ifneq (,$(wildcard $(KDIR)/include/linux/page_frag_cache.h))
>  TEST_GEN_MODS_DIR := page_frag
>  else
> -PAGE_FRAG_WARNING = "missing page_frag_cache.h, please use a newer kernel"
> +PAGE_FRAG_WARNING = "Missing page_frag_cache.h, Please use a newer kernel"

A capital letter after a comma is incorrect.

>  endif
>  else
> -PAGE_FRAG_WARNING = "missing Module.symvers, please have the kernel built first"
> +PAGE_FRAG_WARNING = "Missing Module.symvers, Please build the kernel first"
>  endif
>  
>  TEST_GEN_FILES = cow
> @@ -202,8 +202,8 @@ ifeq ($(CAN_BUILD_I386)$(CAN_BUILD_X86_64),01)
>  all: warn_32bit_failure
>  
>  warn_32bit_failure:
> -	@echo "Warning: you seem to have a broken 32-bit build" 2>&1;		\
> -	echo  "environment. This will reduce test coverage of 64-bit" 2>&1;	\
> +	@echo "Warning: you seem to have a broken 32-bit build environment." 2>&1;		\
> +	echo  "This will reduce test coverage of 64-bit" 2>&1;	\
>  	echo  "kernels. If you are using a Debian-like distribution," 2>&1;	\
>  	echo  "try:"; 2>&1;							\
>  	echo  "";								\

Overall, this patch is hitting the too-trivial-to-merge threshold, sorry.

