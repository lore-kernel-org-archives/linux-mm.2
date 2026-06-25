Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEB08CDE00E
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 21:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DA9C6B00BB; Thu, 25 Jun 2026 17:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B076B00BC; Thu, 25 Jun 2026 17:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3556B00BD; Thu, 25 Jun 2026 17:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51E7D6B00BB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 17:07:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD0C11C0D04
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:07:29 +0000 (UTC)
X-FDA: 84919671018.22.31BB7DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7CDD9140013
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:07:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tNo9mlwv;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782421648;
	b=fNkxmcyh3+tm4/0O9fYAYmCyAO2AFJHy7S9c2zYQ/vy/Gq+2FArDprpwESFDWicRUyzu6q
	I3jzb5TPMvj9PrDDKOrK5OcW2uuwIJFwcyWttvMXDlKkZ2Y6tWA8gsIx4+fpUiODGdrRk0
	i1kd6GRDmZcoWutE3aYpmVY4J+6pvXg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782421648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCf31iXVjV/xmKk4RzROAt3XMkVH30g6uJirV06m81Y=;
	b=P3IaGOXKeNjr867jlHYTTG51qtvqaWdmZQ6GC0TtH4KtTWDEL9oWYDlMpyxOlvGTKUXnVB
	EyKd2SCIEDz0ATgi5QvT/bSenfmy8vGRGlYQx6YfbD8ZPZKaL/CsN6+zGxI1L/mnRDqtct
	htZMxnxqUFZrx5tpwIBmUnp9l3JS3iA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tNo9mlwv;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59E85417C5;
	Thu, 25 Jun 2026 21:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89AD1F000E9;
	Thu, 25 Jun 2026 21:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782421646;
	bh=XCf31iXVjV/xmKk4RzROAt3XMkVH30g6uJirV06m81Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=tNo9mlwvZrMW09CQHCsb1IqYR+uR1kIeFNoUrsmo9Zt2VKQXPUkk/Hn9oMr3EkDi9
	 kB1its+rg+gu3WKtHfTJjhW8G0dmcMuqT4p8sqcVYm+UrUDoQIhKjUrtyIFoVf6+1/
	 o4x58Mc4ANn9xd6n5H31c7cqP4+ToM4YN+XhTnqg=
Date: Thu, 25 Jun 2026 14:07:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: richard.weiyang@gmail.com, david@kernel.org, balbirs@nvidia.com,
 ljs@kernel.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, ziy@nvidia.com, sj@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private
 PMD handling
Message-Id: <20260625140725.15fdfe5a48b6d7f0d667c948@linux-foundation.org>
In-Reply-To: <20260625114235.40611-1-lance.yang@linux.dev>
References: <20260624085756.6598-1-lance.yang@linux.dev>
	<20260625114235.40611-1-lance.yang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gczwf91p9p5uq3ajagsk4di86bzhdhzy
X-Rspamd-Queue-Id: 7CDD9140013
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782421647-772234
X-HE-Meta: U2FsdGVkX1+bO6cBJqtzWdK94jmCrvYJyh0HEU2MKkTDSDKu9e0FdVeNovHm/yb4EkaPqZa9odhKSJk2pKk0g1DRv5Rres56Osg4NwY643GV8NXAaMdGB7FsZntBqimsCZC38ayR+4Pv1rM/iYmW2MzZ8OSpcNSzqisj3yYcBxxvfFDjGB/YZwhJFRZ3q2Ml5C0ZG1+IV0kJW/KKsJETad4cQ1Unr36J9eTU4osdzOzcP/BGQirxPlMbhwQMHzeO4rmGoZSdOYpwHkKVVU0/lKdM8U8po/eC5+ccfPNhZO6EimsxNFKN3wS+TCbFNntdJUWqOmrRhjYDy/RWyX1EUOYCRIShT5wUEFmwOC1pLIIdzob81VpMYuUGhI2giiS/HEbjX4C2XqIZASTMtcBOvZ4viIVXVb/uQx9bnThn1AihrggdJB4jv/8I/tLUWwuanwNTS8wNtigAUU8xUCnCl97hHbqhFE9ajaG7JhlG5EYaQPuYagz7QNAuvbTBS9JsYiAn30zqlRF2eoYJFL4tQsWkaDN97fLusR+hZMX7Oc7MmAJzkZsYkJanwBM6hIntfFsMcNS/kasO8x83BUh85Hl/NZIc3NFvRQvSSFPul7UwZQcdNLbXobp8m6mw2VB5zN4XuLlJcCYWkJJX7zvEaCLwdPyyR9lVqpFHNSYzKZbXzIz8UOunnbKBjqqSKqpmZ4juypVKieZBKKTNlr9IqNTd0wYFFUxvYM1rb+DlslYtJUjnLMQ3tMqVcQTmX9xrtkacn9/oWxevsf1INHxqv+WjPwdoGtAv5ckkENGUz9AnesgTfJSq5c2qrY0I/bVHE84fakMXEBY1VSSMyt9yHkWWYgu2hRZJtXfS7c4lQadvHMvCQGaLZNdMxmmKw9juB/8/1zV7vy0TqVGzOSRjOK3a9V7i4xB35iG8CMxhoprkpKoBJOLgFGpIHDro83DEPlJYt2TeIce+h7fUXSb
 BKMeFEyp
 j3hyQf1UNVlzuZXQfOlmVXkKBG2I8j9ShWBza+FAjjeUm9VTLkASqnuxok5mrIJ1riZeiTuFpoklAIjHYyfG2jGrGXxjhpMG6ItTgKewUb0n9TlqLr6iiacbnzYla3zmERqbqaWyQJnegNBMH4wBCZUjKCM4jNhW8raAu/YLFIHTDM3BF9Gpjq6w4hQI9NnV6439o9VmEmZBxDBdrE5VD5IXfW049PTU2IYQXruT/7E/cCIYDemyTN51shGsVZwo+VuUzfzY5TWW8/V1xJQ9Rc2KtiKeGookIAj2ULM4HsO9s3BwoNK9pYRA7nGasOBk7S3EDttffta6hA44IiZaVsxabJWKMqF3WcB5YV+NECjFi0pJcJgLYedG7zwrnhhW/r3vnmb2zvswxakzKryt7ZZwQ/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 19:42:35 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> >Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> >
> >as well?
> 
> No need to resend. I think Andrew can add this when applying :)

I managed.

Thanks, I'll queue this as a hotfix.  Somewhat tentatively - it's
unclear whether we'll be seeing a v2?


