Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A473D2502D
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 00:28:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98A06B009E; Sat, 10 Jan 2026 19:28:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B46216B009F; Sat, 10 Jan 2026 19:28:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51FF6B00A0; Sat, 10 Jan 2026 19:28:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 965736B009E
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 19:28:47 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 342205860B
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 00:28:47 +0000 (UTC)
X-FDA: 84317797494.21.8D7272A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 90CA0C000D
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 00:28:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CpjTXcE3;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768091325; a=rsa-sha256;
	cv=none;
	b=s1Z9zmXvXVcI/lwnlgxp9dCoXjg0EffB/aC9KclwQ7Odoo0FyrSpAiJb+N6Woh8LzTxy7m
	/lfJNsBtZJjRuwof32lnMCzNmnzAdAe2A/WXrxjRWRhAoEF2c+cSXqb6iRF8uUhyWekYuH
	QCcQPs4R4BYykAFAB/QoZamgJJrwZkU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CpjTXcE3;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768091325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqK3HOg0vNq9f3TZyYs6Ctlm/q7dF5v31DWjp/N6no0=;
	b=DqClYrlAoZ+oe4/87cHao5lhinOLA8vvySwSPECiv8HESKtOQlF2ix/jDJeNzkyVOfTE4c
	CJrvRm+rHxRhOCF/X9b7AOapBMqVed4poUqVQOCKZ5OpWPwRktDekjwcMA/iGSn6aQuGos
	glrBwsjBojg7qfDAMRJ9CXfLCjmeyS0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E402560010;
	Sun, 11 Jan 2026 00:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E054DC4CEF1;
	Sun, 11 Jan 2026 00:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768091324;
	bh=MOScAOAfndrqdtTOZduWfCA2cVTB83JchOtZuxyo5fM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CpjTXcE3G/BfnjwGI+AlE5LJjHCT5gEInJ20H9uD2UP8SpQN+3xUghnmNVsLAyGJ0
	 GwbhCaddbPfDXRJIyQepD15l4iKgpc7/e1+jJJdbDQqhC8n/n4a7YEym3hVFQfm4lJ
	 vDrZYulVe+w1R/BuAaxiGCeCLDJgGOESbBkytWns=
Date: Sat, 10 Jan 2026 16:28:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ranxiaokai627@163.com
Cc: graf@amazon.com, rppt@kernel.org, pasha.tatashin@soleen.com,
 pratyush@kernel.org, surenb@google.com, kexec@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH] kho: init alloc tags when restoring pages from reserved
 memory
Message-Id: <20260110162843.ecd8e731bdc281f4cd8e4764@linux-foundation.org>
In-Reply-To: <20260109104251.157767-1-ranxiaokai627@163.com>
References: <20260109104251.157767-1-ranxiaokai627@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 90CA0C000D
X-Rspamd-Server: rspam06
X-Stat-Signature: 9hzzhkbo98hzkyuf839qgtfatfr95bdi
X-Rspam-User: 
X-HE-Tag: 1768091325-883002
X-HE-Meta: U2FsdGVkX1/O+Io0v5jJdz2JojAF/IPbwcGa5kJMfzczZIpt1rgIk1PoU/zKQTomB97Kp/E419vSfUrZPC8LIHIZ0Pt5G5Xfb/4wMfzCynZtxQsZrMPOffthbjhru4fQqZlLvyntSOy1pSMoXwQWIhKDOPiNtME6HtpARd1ygwYkZWQiM2ybvIJBO0/b+A+8ESsLxDSUZsIwimP6s0BY/DtBxIjclJxDEnlJOY+sbwvtLQzYxbfqXZ7bynZIPL7ORHH9NyGScHRcQ1TkXGEXgijj/1zGYDdxIwAwKzGDBdQyFOX6bvAXNhiqckzKveEhtpB9g3sB8y4KXIzq/VG3pQ3NNhiMgS3sFcNOOa2A6IZ3GZpeETRsE2sndn23lmQImJFSt/Gl2zAue/4WS2ECopgXBN+OqUBjg9EtPkqHrlN7xKRc8Oc1C6R9Bc+QMp1uI2yzH/8Y+1ZwRWOtLfQ/Z4KlQC59zKdDD0oh4f39NNPD5nezzuWuzgHcwnEJJCb08QdxQhG16uL/T3keTT87qVqxghRwk/0o59NpXaZVKblRZpQr1JigZwtQzslZ0tZYReW4jy8kgBFMOdeUrvlvuC40mWXz1BaN43XAJj79otLnzgMSknbwB79Ib82fRluo6YpAB/AmWaw/otPRM+yGyeUc8lJvKdcUj3wRGIlMDJbwUx3nRDcTA/rC0inCB4z2BK3PWtgPk47bLuhVKvohnuTiCxNeQB2DDfhXixJXvF5a3YkHRrlKGyH3FbrNdYHNh6DQZg2lfqUr/nbFsyiIKEPmMv7uDQmOlKoAImR7w3DNMuUlB99l8G5Tac0Dg34IOftjoV4ql1IPQToru5t3EaMGvAJN/yEcVYNkIM+Dk5U6uNPa2dS/ZAys/qeQev+TXlZDKeNvDwLSylDVX1TvIIW9T4y7Xa1jbqWwbGeAL09624KOnCRkUWn/kvGskIi1Z5I3mSzZ/fGJxGT1zzz
 XnGLZC+t
 8GHZK29M+PsPYMobJHXQNGJvqP0NVD1EiiBzX/i3JSboPMJHi15TasvzKK35aOyXVb/VVabNIBZRUAnb0s/vhEN/y8mAXZoDhk6M12KJ2Cz/1OvHLPofgJVmahIyiWp0hGzPI+1tM7amWf+W4dWjxCdMAB25tsU4/p/UBc7c17MvN5jOkZ45fmrhT3o1QrOLg2J+hKNVgGtk9VSdnusAzC6lHuWFOsc4Ku/8shPWQ4svFkKdEf1TrygJE9+bKO6U9OEqTrk/tnMJSfZof/fAt3aMg9wy15fmgNxRAReJ8xjAyaJASFB3gzungO7u9eJXYcO8i3Sg3AgagJf4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  9 Jan 2026 10:42:51 +0000 ranxiaokai627@163.com wrote:

> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> Memblock pages (including reserved memory) should have their allocation
> tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before being
> released to the page allocator. When kho restores pages through
> kho_restore_page(), missing this call causes mismatched
> allocation/deallocation tracking and warning message:
> alloc_tag was not set.
> 
> Add missing clear_page_tag_ref() annotation in kho_restore_page() to
> fix this.

Great, thanks.

It would be helpful to quote that warning message in the patch
changelog, please.

> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -268,6 +268,7 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
>  	else
>  		kho_init_pages(page, nr_pages);
>  
> +	clear_page_tag_ref(page);
>  	adjust_managed_page_count(page, nr_pages);
>  	return page;
>  }

Warning splats are pretty bad and it's desirable to fix this in
previous kernel versions.

To do that it's best for us to identify which kernel version(s) should
be patched, via a Fixes: tag in the changelog.

From a quick look, it appears that Pratyush's 12b9a2c05d1b ("kho:
initialize tail pages for higher order folios properly") is a suitable
anchor, what do people think?

Meanwhile I'll queue this up for some testing while awaiting maintainer
feedback.

