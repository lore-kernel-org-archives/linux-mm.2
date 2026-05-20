Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9872CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 03:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 349F86B0005; Tue, 19 May 2026 23:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FA636B0088; Tue, 19 May 2026 23:21:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210606B008A; Tue, 19 May 2026 23:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10E716B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 23:21:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CE79120145
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:21:37 +0000 (UTC)
X-FDA: 84786348234.20.7EA714C
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf20.hostedemail.com (Postfix) with ESMTP id F22051C0004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:21:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S3vnyAn9;
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779247295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QNMwdoa0LlYtMoqIK5S8Dh6GrHLXivHDLFIZ2WwXCbs=;
	b=d5R9KMFRk9bWr/y7dWVFjIx3WJI0LBu93ZswQohRoBqbw0L1rXPOYnptIDb6qcpB+ep4j3
	zvEgY94d3JqMtQs8C7zJ2gfDEiRTIkFf+mt1eS7OXtAErUEPnbCUki7XPBr33BTKv669b9
	G5xX1AGbyfC8xTVNveM5iQKJxYk2WA4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779247295; a=rsa-sha256;
	cv=none;
	b=42vnVowkFF7FQxwpd3sqaP5w5mIopByiH3PXaRTIL8cfF4sfHU/CiHWnkrSaMb1RJI3zLv
	gOvs8/eYrxEhq6CA5tASKO30R4XzbR/O0wV3LTE3Smh+hOKD9+jgs8ADPGp+JhbUWJYr5j
	nKX7XWGDg9oys6IbFL5XF1ttJOhrUNY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S3vnyAn9;
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 20 May 2026 11:21:21 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779247291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QNMwdoa0LlYtMoqIK5S8Dh6GrHLXivHDLFIZ2WwXCbs=;
	b=S3vnyAn97qkANlwQnCto3no2q7tfR3m0ldvWiTUHrQE3RbAFIZn16kOJcJRouccAqFxSZh
	xiq9GVkluhJJLGWCKoiMxi1A5IXjiBUR/k6D+3dGrmMSXWo/oGZa/UbH3u6mfMi/Xftrnq
	f6VfVBErnwzUAtsYrlrmGfJcaBO9Bfg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hugh Dickins <hugh@veritas.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab: fix probable issue of dentries registration
 under /sys/kernel/slab
Message-ID: <ag0n27-TUg6BwKfK@fedora>
References: <20260520011019.1707010-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520011019.1707010-1-vladimir.zapolskiy@linaro.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F22051C0004
X-Rspam-User: 
X-Stat-Signature: 6u7g7eoa7kz1fs4r988p3nyf811zi3xe
X-HE-Tag: 1779247293-763209
X-HE-Meta: U2FsdGVkX19GBE49jwBM6YYRX8yTKjyMgJLLQJ6EkpYdqhKqep4U0vNj8zCFbFqoLL4JIvVkfmH98PXNiGR9ofJcNhgXitWKpRvdGoemmevgC092WN/+IlmtYCFLcpY7Nz/NFRo/0lK2bkZSElMfJdcB6oZsJ4BW+lKBK8xfDaZrgfmDdEqSfTKa2VAzjfax6xYzr4wdY1JUe9KkB6XUsIqe8ilM1xQ/KI/aBewzLcNrtpk+tvrhFyOF3oEN9RcUi6WREupTFQHF/uDg2HQAK51AtAeZ6Y+JMmeYLWkw7wEF/JNuflwEGKxcUqACW/MW3bWpmzeBk45LoJ47Kuag1l/9bpzb9GGd5huYBV8426uo60ki9f7fU2TYt73ExwmiD6Ptsoh80QSYPNsy3pJb2Qx2l39Egb365tJXCohH63XueOg9YEpHg+3AaC8o86pqhciM6YFwAgTk4fM2xNrE6lvjyup/PL8JpAzKS0FAUEauChklZjumfHqmDVMshs8rbGrC41k33LDOYo+mAYlhkfUmOW3g5TZvIeN2/V8HM93pyCuBCVN4/M4EWsrLBxRDW/OP9GJ327SW0eVfOFAc3p/OVGdVP3sIgGGtV9KwyVPhpobCVuxPMTgmR3uQXEP9raEHnYRHxqqaavv6m0kZR7+Z7bF9vrzvwjdt9hWcYbeuEifRKpAE32WWlQ3o7JsY6zHgeLmbqPeTc0prwPgQ0AkG1SPBUPxeh7pwm3ZkwN22WErXyaqLF/SC9BizRKT6mEj973xPi7vhhVup+XskJpmjEBk2YOy+LJhO9VXiJkMyxaD8cspGVOsmCIOKWZHDORIiPtcQTxgwAMyJT6mkFwOXbSOzYCr7rw5DApSCVu1NBnVKLHeXLf1kzQUreLy0YY0FGp2WrT2q74KDvtKd4o6cfaF2Yqaxd9J/XDv445k3Zhvtn5gZzcnYm7XK86JxhRTc2mHkOxIEJ9P4Piu
 KbqGA6cr
 0jVaAR84SGF+OQQ4nIfYsNQjFVi8/980WsUQeeG581qgvdb9qPwD8G21p6pp5NVOHBHnatrLxMkiGooeuCbK//vJH+fIzSvxJz9Jo4bu1EifzpwODmwYW3i1sTBe36APQUI411hFihiiVrKEJFF9JpZVPTF9VSxIE8AU8Fpk+SDtHpxCW3e0cJyYZlVBvGw9OOI2v/7XlpK1/xp0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 04:10:19AM +0300, Vladimir Zapolskiy wrote:
> L2TP/IP and L2TP/IPv6 protocol names contain a slash symbol, however these
> names are blindly used as symlinks to slab cache objects registered under
> /sys/kernel/slab. This kind of symlink creation is successful, but its
> dentry is obviously broken, as well it breaks the access to the list of
> /sys/kernel/slab dentries.
> 
> Likely L2TP protocol renames cannot be done, since the defined protocol
> names are exposed over /proc/net/protocols for years, but the symlink
> names can be renamed, because they are yet to be properly created, and
> this should be eventually done by this change.
> 
> The problem manifests itself, if CONFIG_L2TP_IP build symbol is selected.

Hello, thanks for the patch.

Could L2TP possibly be loaded as a module? I noticed that
__kmem_cache_create_args can also call into sysfs_slab_alias. If L2TP is loaded
as a module after boot and dynamically creates a slub cache, it may bypass your
fix..

-- 
Thanks,
Hao

