Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D3AEC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 14:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A23226B00FC; Mon, 17 Aug 2026 10:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4366B016E; Mon, 17 Aug 2026 10:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E8A16B081A; Mon, 17 Aug 2026 10:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 703136B00FC
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:17:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C965316076A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:17:13 +0000 (UTC)
X-FDA: 85110963546.29.4A4B397
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0DA8340010
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:17:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vt9Ak3Qw;
	spf=pass (imf01.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786976232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oin+/NxTReK8f88sQ7DY4WS5rjyj5lUgHxy+oFnck10=;
	b=l7vrXdvEMwGm0xp5OxdLqs1umhRfchfAS9RyoAmicP/Axc/Os13oh8JZis6vpNoh7U4H6g
	gXa/wg4qHirk79bkU/FZlBTopUNPbWhwe6Rp8DgomC6Gty1mXwn5Ndq/C6at2ogZhz3eMx
	66ASgyQICpk5SU4/aRG7i9Bq9hkBVXQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786976232;
	b=fm591+WvsjaHqK3+42rd0KnXkaG/hBjpueZg8vtahHiyCP0TCoLfdXCAfCPjEkBMVtfLvY
	lMa80xLUo5FYSLDGlTSeNAa51LEQgh9NbGM5sLhVdSBIctEzflk09Kd5RPptJHVeOFXURY
	datP/rQ9w3xcR6p9FEhH5+VjTuU/Wi0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vt9Ak3Qw;
	spf=pass (imf01.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Oin+/NxTReK8f88sQ7DY4WS5rjyj5lUgHxy+oFnck10=; b=vt9Ak3QwaXmfDVJN3LvPGMLLEl
	2G2jpDcw6WNe75xbZGaY6kAOusCAslccEzU6hiVAnURbuOelJvBGjNm0N3ePn7hWvmvMGI0s0sT6X
	Lsinvy9Yj/kOG48fXMc0LDd2MOAqiy3XgHVKmIRshORRJ1wg1h+O/RWoCgUS5dZmddnoJkvZA/x3h
	/GXN8YsWXbKV8pliZzmVCqY/XdkKh4/DrGwnwdvdF73aTjPVwXoGMySK2NBqFamgYVuAmtVUiih8e
	to6mDXzYfTWJugce9OjjnyP7w0pdJWI+RB1qfSod52XHjoCFUdhNmOV7zef0oG0WMqapdZAk/Ij/k
	bSZgdfUw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wvy9F-00000006Hg1-1NmK;
	Mon, 17 Aug 2026 14:17:09 +0000
Date: Mon, 17 Aug 2026 10:17:03 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Mark Sercombe <sercombe.joel.mark@gmail.com>
Cc: akpm@linux-foundation.org, aliceryhl@google.com, 
	andrewjballance@gmail.com, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] maple_tree: fix comment typo
Message-ID: <32auhvmka7wasz4fopvdffujrommsum3uc4gv3qxoakcdexkdc@zxbesu6wrz3s>
References: <20260813183847.474357-1-sercombe.joel.mark@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813183847.474357-1-sercombe.joel.mark@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 6g3yrycqf4p1istxycarp1kywdag1r7k
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0DA8340010
X-HE-Tag: 1786976230-872580
X-HE-Meta: U2FsdGVkX18kHKvz7fiZOvPknlbf1ADwunhS2gtXqC4SE1lkLxCRh9JlBAqVMX8NNryUDyjxgsfrW0ZFVoDMOnzXIh360AGRIw7TbuUFVOssZ41Rrpk+IBo2lvgZKqb6yFm7hMWJU1VnRouMzlunuyFqcej9j+xJmiCjpfqCD4MiFjmT2no94Oopy3ETJCVOTSW/LhaoaOt9/0SEgc/SuFyCt8GH0R/ljoVf87qcpEI/AM5y47fuNjBBO1VxuAB8eFcL8sa8qOE4rrezjlR9SwP3p4xF7bb8F8jNCTinYRTH7vuB25AZwNcYZ0bjeRa821X1OggbOkWO40qibmgM3HWiPmx5AC8HO9kjj9oSUApv7KaFbSbi4cfuCW2VY1f0A3ESh7YdqKra+mKBhUAgdt1g5nzIPbKIM3AyiJujPafrNNI84O8ZnPAZFtEK8+9q1SYDxMhjY98jT505Y8ml4LJ16gGt7mipVRulDgqwSjKZQMehmMQtZ9TSupIBo1+PXOux41cqRmqBKggvBiV28m18sPhAO8483EQjrX1qliTeY8+25YZ1NWzlXq4Z59RU2F5iYD+YAqObMscVmYQXzHq4W17oTuT2KVypopilwAAjnXCA6rJ3nskuCFbTNPXQ0k9t+h1U9L89jPBz1pTOXRzYBrRWeJaBcvrZ1b37QFYbyAlxpIUtGlFmf/h8tvj+ass0XNMD8yxGh3vNLPxvVM7tFEvdZ3dWYVk33zd7j4ODKrLKxX1arA1x6conFIPOUE3T9o1mkyA3ZoP3fDWD7gLdCQWuOSetkmMu+wcGACHuEnN8L169TjoApMxhTMfXRlTbjta6AOPWxl2F2M+2p7xfGAjR96b9rF3zXGYsKSQtLwBWqdpyvNL/3KXYaWojtPJ5DhoR8YOVlJghnJDhDF2bWhVD4bOiKjLhGL1yt4BNAQ/A7I1xQzUyOVMnMR+fENEFiwFm73IELzaJqDJ
 u9a1vNX/
 gXtD6FVTDpyRj+8HK/UGtYbFqgFQwr1Op14MeLaAY77jHsYIwf/G6Zl/K4E1iuFeJnKVi1olyvFJcc3Eqrv4t1O6hXVsa0ZnZ04L1RpCY/YV8pW/iOh3GniDI9k8XM0jy4QS7uILfFNKHgZ2HOam8tN0AvA3KtQk2EuuoXYwZkEU89O5vN6eD+ZpjvDst1sK362gzS7S6c4kz3wJPUMTb8Tgm3TI9JA+s2KIAw7zihXTaBK2T07LLB5qRCkZ0ezMTRu2eCgqMEjpcUChieTGuDGgVTm5X90RE+yUHl3X13tHcFnEcYY5Fb7VWynzLds0zseUSFVN9PV38O4NSjAodRclFqu9jmbCyr668IvUT/7XZ7hvzeIJIYbNmuxzKeZQ3phXhLxZQJfeexO2w5x8Z9w165mpQFFvDS/BfaQw9qY/XHICMWEoRP8AgbN81NiR/+wMgWF/0DFBIJQggwYFzhefMqIsfp6MjK7zpm24TMaJWm2c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/08/13 08:38PM, Mark Sercombe wrote:
> Fix a spelling mistake n a code comment. This is a comment only
> change with no functional impact.
> 
> Signed-off-by: Mark Sercombe <sercombe.joel.mark@gmail.com>

Thanks!

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  lib/maple_tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index e52876435b77..9e47f21286b4 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -3595,7 +3595,7 @@ static inline void mas_wr_prealloc_setup(struct ma_wr_state *wr_mas)
>  
>  /**
>   * mas_prealloc_calc() - Calculate number of nodes needed for a
> - * given store oepration
> + * given store operation
>   * @wr_mas: The maple write state
>   * @entry: The entry to store into the tree
>   *
> -- 
> 2.55.0
> 

