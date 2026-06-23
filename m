Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 547B8CDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 15:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17EE86B0088; Tue, 23 Jun 2026 11:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 130666B008A; Tue, 23 Jun 2026 11:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047E16B008C; Tue, 23 Jun 2026 11:53:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0BB36B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:53:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 529141A056E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:53:03 +0000 (UTC)
X-FDA: 84911621046.02.7555753
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf10.hostedemail.com (Postfix) with ESMTP id 027AEC0011
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:52:53 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782229974;
	b=viy3G83bEjvtPNkW7LszzE2no00WESJCjcclb6xUjj9On7EhXlYOELyNNZwgPU3qiAOTqN
	jt8Xtre9IbZXgbSO25UAdzRjSku7333AqyBtLfhWnz+4+H6OdD8r1EPVNHeoGahoRfcbtf
	7J5BW4Eh6WJAKJdiZ/D5MtL46Eikak4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782229974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ua4j5GBXNOkGX42ExDvBgVqDmDW8AmJPXIJ7k+n0iYk=;
	b=0tR/Qa4i2FuaXUturFWTLdqS4PgnFPpg7xOcBOfekZQtmAwaY6OZCpaK0mr3vZWmA1VIIe
	7gfcQah/5fbN5+QkC0EinOeGPbqLgdCsL+dRmm7QCQvgIkvleYCd95itVi1FvKd4GamUpU
	nfG7ogilTIRG6bXhj0NSWDQfSjHfwuI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DB3u7kbw;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782229971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ua4j5GBXNOkGX42ExDvBgVqDmDW8AmJPXIJ7k+n0iYk=;
	b=DB3u7kbwQ8G/G8wvrF139lEMxeDLjo+MQJMU96fjyHg3/seXkdzO/+4aZrAAsAXWk+k8r3
	Gm9exvxrhrz9u5ZLKH8ydZnErKCgLExqq4P62lWfzbICgGWaOGEgXQ/1lRmj8VNTQZGFYm
	A4yO7TxejcJewnxdJZ5wIvIQBwygvkE=
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	lance.yang@linux.dev,
	david@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	sj@kernel.org,
	dev.jain@arm.com,
	baohua@kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add Lance as an rmap reviewer
Date: Tue, 23 Jun 2026 23:52:28 +0800
Message-Id: <20260623155228.52695-1-lance.yang@linux.dev>
In-Reply-To: <20260622155913.280355-1-ljs@kernel.org>
References: <20260622155913.280355-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-HE-Tag: 1782229973-315426
X-HE-Meta: U2FsdGVkX1+x4dwsS3a38TmN/JduVVK2Z8yK/SdCN+lMJnwLSAu6+D/OHpgJgkgcJTdb3A3IBvc44pj0h65l26j02FzIdZplKA4YuvYx4LlCnFsJHYaJR9UOsI+4L0qIig5X3k8+EUQrkJNHDBmLikMEN8KFtVdy0WfdQV3cnDP0Wp0LA9OQLXsZW40Hacf4x5gUNSN8kZ0QLzgm06OyVpxMO7EguXLRHMzSFYB68yAeYwFrazxheUvGENaRTevSbsyRAdRIRYziVRGEVVmuj08dJacDaxDrnfPsDFqM7jJffgvhb/7g5DDEtylfScuKVmJ1KzqDquI8I00gYv3QvqePCzUocfUNfqzzBS7X6QjxcXJzoK01q6nCPEzvjNQ74aOeX04zyA/lAnhKOzBo1r6T9WykD6N3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Jun 22, 2026 at 04:59:13PM +0100, Lorenzo Stoakes wrote:
>Lance has been doing excellent work reviewing rmap series and has proven
>himself to be a great member of the community in general, so add him as an
>rmap reviewer.
>
>Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>---

Thanks a ton, Lorenzo, and thanks everyone for the kind words! Really
happy to jump into the rmap party!

Acked-by: Lance Yang <lance.yang@linux.dev>

