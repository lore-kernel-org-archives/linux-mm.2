Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03055C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 08:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07F386B0088; Thu, 30 Jul 2026 04:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031BF6B0093; Thu, 30 Jul 2026 04:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3A776B0095; Thu, 30 Jul 2026 04:40:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5CC56B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:40:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A2C5160654
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:40:34 +0000 (UTC)
X-FDA: 85044796788.30.2FE8435
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A44D5C0009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:40:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Am3w9iBb;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785400832;
	b=56ZDuEvNXLZEej/sclh/IY9M5kk3YAhc14z8csrG3EXH7p6b1sb+X4VNYyID6kBI8/8+M/
	diXxcseIqIhrBZm6Qxw98xwzGrlPkwfZH6NJhCcAJ6MW7/5LXSDEiQLgkmTHlYPQioaAYt
	srqGDH0LjpWhDml4FaFxACRsPt5RTU8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Am3w9iBb;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785400832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=55G67AD+bUlnQtHL1MJavniTLpGKt7vPc4y+cPkS8Qo=;
	b=vKH2JF9OrBUfk6WeDkT6+tRNt+uuViJGLylfKyaijhAlOq1o+MZ2jdPaHA5awLJPTRd2kt
	4DMsNUitewhQux9IZj3r4EEAGVz9TJJ6ro8gBuZvrQHOAKQhzrwB/WWKYGlJ/l8d67Z3Cg
	MU43LoIGKD8oOzCnncBDdWZ8C0og5QI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 193C5600BC;
	Thu, 30 Jul 2026 08:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499731F000E9;
	Thu, 30 Jul 2026 08:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785400831;
	bh=55G67AD+bUlnQtHL1MJavniTLpGKt7vPc4y+cPkS8Qo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Am3w9iBbksLZSYkGW+BC2SXWaPrsXS+3w0PfbAUiFLEio7Ojf0Mp6S5i+8TfgZJQ7
	 P0oEDWw3vSLdXYio4+t/tv5rqP3m3i6YA0+nbhUwJCvoZ2Aag+k6zPehyBKcXT7ir5
	 l7Egai/6QWPr4er0MIKnLmzK/p7t/cVDFc5YJWjzgGfGK6Tpuzmfkyug6zxOkJatZ6
	 nyjomqeZ/UizlLOFCXdwnG+WkTF7Wn8jaz4YvGRtw2fU+vEEjVRZ97lQiQn8+BcND8
	 W1BuAwvX2mVAHr5hud0roY3B9Tm1f2aipjudB63eKi0xt+KNbdCbNwjboFOq/scBOu
	 rkkhhxo0776pA==
Date: Thu, 30 Jul 2026 11:40:23 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/22] kho: generalize radix tree APIs
Message-ID: <amsN9_4LTNFBxaFE@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
 <20260729145610.2827231-2-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729145610.2827231-2-pratyush@kernel.org>
X-Stat-Signature: qprgfucfyxc89c7fwprdusaazuto6kpy
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A44D5C0009
X-Rspam-User: 
X-HE-Tag: 1785400832-137028
X-HE-Meta: U2FsdGVkX18lbJHEtdM1de/VpYkOxWfB8n6Qc4JnQnJXwcMAsQfIhU/j1y/voTpXpBURfYwdveKnTQanO9ZXrTPnvMtqS4XCOCqSg6gvBhfLkf6dPbom92fdXRVxhaR7Bi7iesl3X2k3UtxRg2iOn5ApmSN50P14ttqlj07M0cs34s0iSVpDg61uO1T6L3hA1RUZbDOfNFLb1o8kXOpKJ1ASb4CaZDd/LOGe+m9msVRP1PWkwNhW1NTA1Wt/8xwRMWJhIvzP31zsHFgqVNxsix6SV2wxIWNxugD7G/BQd79VxfSkA2F8h3XJkSislG9uaNQoq4f+p/r6CBB1eN6d6Sdh090dkaAm/Ye4ZydhN4NAmkDzCzBduIKzQv4irXY4n5IA1aiqfARCMtA5HrUUq6EEl20mR4JiWpc/+qYsVCaqszNWB2pm5/WymDHRPke+CTZVhtuPt5d4rxudc1Mcv8wsC+keFNL0KcwKAnKvE9TSGN2bfoDIn5v4jhvQFtdk3QXxcqTxKpNAokXAW4+5560jxWQmv7pbh2SNSyFiFfZ0awusCw2DjmC2+RrhDeOQ7IH+6B2fnDpY8sy8ucMo/QSfV2ALhypwIJLDUin5fInT6HaGi8Ej11s3c73/djipqMSoqhP81C2lHEly7xp+k6vH/sbx9iVC9808FcQ2Deg7BS45g0Qim+7TI59AKOJvn4PoFmjDv+L9buYJijtVQ/wHlqXRyDLCk6hzcX8fQSYt+BBOxicPCCRBztc4yxFsrtZ2ySpE4G9oiHz1ITwWvf5yTi9CzvfTjaURTFq7iyBkIeyxF6WY+E5nazf3tC35jBC2iBnLbB1oyZ3ZputgCeIo7bWNL2nLLmzD3fAv30Is31/vESJ3NU8i5zL1ubm7WEB8YTTw1nG8fTlzcXty7FzEanv0Wpm638TgHvQL5G8cj63U6pXAv3zXbGDaoSgy0c1HlARrPCkXJeqRPZD
 vU8kLrCO
 9V76ZegvmBbLHvZ63jsi9FBKTZUG6xptawqzoC114M6hVfVvl5oGP9V5vHJYHsrur88SIIWG6k/Exx2ALjb3Ffg0ns8rj22bVo0RmGUzPAw8C3tk1+s8vfpOSpJdkZSW2Q8T1gV1Woo+yAxX9kiqlgD469rb7I1gKBjTQnw0MP4hpz6ohxTT5s1EQ8BX+RV4CvxI+QXVhp8hEp3veD+crYbfq+B8JlhqEJRzeg/NqgZWuWtJzHhy8kESzUu60G2VazSLo3BCRwCloXQJLBF+I0M3uHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 04:55:46PM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Generalize the APIs by taking the key directly and doing the encoding at
> the callers. Rename the functions to kho_radix_add_key() and
> kho_radix_del_key(). In practice, this removes a line each from the
> functions and moves the encoding function call to the callers.
> Similarly, update kho_radix_tree_walk_callback_t to take the key
> directly.
>
> diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
> index 84e918b96e53..f368f3b9f923 100644
> --- a/include/linux/kho_radix_tree.h
> +++ b/include/linux/kho_radix_tree.h
> @@ -34,30 +34,24 @@ struct kho_radix_tree {
>  	struct mutex lock; /* protects the tree's structure and root pointer */
>  };

sashiko: This isn't a bug, but did you miss updating the kerneldoc for
struct kho_radix_tree?

And indeed "DOC: Kexec Handover Radix Tree" talks about addresses and
orders.

-- 
Sincerely yours,
Mike.

