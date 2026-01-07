Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3BEDD0D15D
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 18:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40CD66B0092; Wed,  7 Jan 2026 13:17:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA606B0093; Wed,  7 Jan 2026 13:17:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29C956B0095; Wed,  7 Jan 2026 13:17:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 192FE6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:17:10 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9816EC1E54
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:17:09 +0000 (UTC)
X-FDA: 84305974578.26.1EA5FD3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id D242E1C0018
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:17:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=diheGpgP;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767809828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ArOcOm9+JyoDwSZ/YYA50/BhfDDwlY9pFdWcaX2oZU=;
	b=Q0Xft275TnDibPLebz+zk4KBi1PRZ5RN7M6fkDvJor7Q4gDuKeJCIz9wnpCuukYmHOOYXb
	/NZof0Uw930dQ8iJ8nNVIMRQGNHOMeYmauLex6OdENgz8rMEGRrMR7k8qOiE066FA/oRgm
	jPUNGiyLVbP4XZlg2qBvwF7yLOcI450=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=diheGpgP;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767809828; a=rsa-sha256;
	cv=none;
	b=7oM+EHyhGZFnO7OGXZ6vWMj+rPnnAjJ/hzG7CPzYFqrtCXhYNefTm/ZlObm8+mnWkkxU0z
	gt+dnvSn0g4sZleqfs9SVE4/NorjV1qHC1oRZQ//7zPWeASghsK4C5nrr+wkyQEG+Vg0jo
	ye7jhtcL5f6p8FVmiFp/6X3+2MUOE6I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BD152435A9;
	Wed,  7 Jan 2026 18:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2ECC4CEF1;
	Wed,  7 Jan 2026 18:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767809826;
	bh=cXjWywB4AwxOwxQEEwNp0jBxQVQk5T0xDGIAVw1JYhU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=diheGpgPUKqCl+iO1SQwee6L5Zv83Ncg2IJmb5ABH2Auwt+Di7ntrQoI8eD4h2++b
	 DGFfemN9I2SvNlXTDBufys1bE2xCr+R39WsFHdAaCvCA5Q+yQvTvloHxL25XX9O1Yn
	 FRJYxnZjFGArAFcTnWqcBcm2mY6PNptXfJJI/+1U=
Date: Wed, 7 Jan 2026 10:17:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCHv2 2/2] zsmalloc: simplify read begin/end logic
Message-Id: <20260107101705.0469e87ffc60120120500e76@linux-foundation.org>
In-Reply-To: <20260107052145.3586917-2-senozhatsky@chromium.org>
References: <20260107052145.3586917-1-senozhatsky@chromium.org>
	<20260107052145.3586917-2-senozhatsky@chromium.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D242E1C0018
X-Stat-Signature: w9rqazb1zms7t4i5b8nkwq8gqgfmbmze
X-Rspam-User: 
X-HE-Tag: 1767809827-294586
X-HE-Meta: U2FsdGVkX1/BFj6qUfDgFn32wvl8UCS2sRs6MvkWAMG5qLJJSsRmCHN/dw8g3bSJQ872F9P78Dg4CxpZ/LwXoZaNw51docrzY8rwvO2r543wE4Es4xeMzvoc1hVNarSwyk03Bm4mxV2rsMLT+rANM4u2KzMGp9bURjinq3IP/LCfLONofsi9r6gblfdc7TiXingQQR0NKxLLDXOKsAASmqjyek7sD2WyzSm2YgZ6zhHcI3WnQXc4CuWto0e0SL35AQnhs60iQ1kXwJUhHb2j8SlO2upLIhz2HUCRo4D8BryVqWEsX2GIs5eyP1T7Hr8oM94Lml1Y19lL5v8FTFS5ViEjcsqa+S9kd9i2pSiaG3y3Y7FzSKVUi8iKlUEEGr5TMoyFe8/lmwtIo53ZM/jd/mpzqVY00VtSJ+Sp3kgbmdj5N+iLXRtfFLMC1fnvM46Uj/QJRcBrcEQkWtb3pKcB/eOX24/FLT67yCMBueh41qDGGWUWlHEE5TSiIz/8R+0xbITjcYVv/afRoQWPoGp2LCcX6KwDB8jWC4iZhD1fKlqlAOOtlDIuDiKpQ6g6ISAhnjT17cdHG94XQMnEgvCsB1TqmcKkOyc/BVhcLoW619KxZtFZHVIyNWYIH/ianHoVpO6GhLJlAZ1/9DsOlpGk1koo0y9ldUvwbEGe9ZyXIuRijpFGjS/wQXhAdXl2PnwlOVI/xPcWg3FzK8nHj5RDfuA5hfRpgXqaNeGsJMK/4Wtc2IjmRvFrrXz8ukBwRIrMS1OHyLqBcTZ5uqwzZ/KDcMHnWS7m610UfK6AC2VmXXByHLDguzR26HPLj+LFv0fQbj/Z8szNmtXeQzKrRzKfQubLH64dxfCbcQVEX1nHRWlpPLfa7eNCBXdX/fclxFW3/SuUVr9OsAW9PtEQVMd92SC+8r+thyStOyHSOWY39hf/1bmhMZleAcHBAajVGptvhluIYEE6BKOMywe8imO
 vjCngJK/
 mu4JkcEW2GTPAncI5ykfZIvxNfhjODAB5gaG9G8ZuT1a/zsMWjUM4IUll7aRk/lNPcPibp/NCDfpsmWl6amVrmAG2+c9ALAEaXkbZ/dhR11vprT9lyz1qtfEfKNbP1+bpEmT2W1MnsucdAINxAhdfGRnmuPPPZ7BSPnjj1/gxDCs/v/V0LscGc1APuwRhe24Jwlab7AIMpFFu6mjtT6XYhZ+v0EBYbjaOgjR6fAthpVz4YXxo4DJoZ/jgUeB1VVwxoXXY4J5jJIcj36k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  7 Jan 2026 14:21:45 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> 
> When we switched from using class->size (for spans detection)
> to actual compressed object size, we had to compensate for
> the fact that class->size implicitly took inlined handle
> into consideration.  In fact, instead of adjusting the size
> of compressed object (adding handle offset for non-huge size
> classes), we can move some lines around and simplify the
> code: there are already paths in read_begin/end that compensate
> for inlined object handle offset.

Updated, thanks.

> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---

This patch should have had your Signed-off-by: also, as you were on the
delivery path.  I have made that change to the mm.gt copy.


