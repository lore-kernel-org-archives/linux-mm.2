Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F5C2C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 06:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6839B6B0093; Thu,  6 Aug 2026 02:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65B816B0095; Thu,  6 Aug 2026 02:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 597E26B0096; Thu,  6 Aug 2026 02:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3641B6B0093
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:29:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B5BAD140689
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:29:44 +0000 (UTC)
X-FDA: 85069868688.17.61381E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id CF95F40002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:29:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GRWypgQm;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785997783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1oY8lbXTomFFABlq28RvaAPiO8AnqoSfHSvFMVUFi9o=;
	b=cDmGvfsPomStv/nH+cFg5nauKk2WzlbanljnjxH5S981t09JPJacNK/hBQ5DtQ16WHe30u
	+ejV1zAkU1/gq6UK3LDpT0NVBKNrFl7Ofr1XyGRUtiGlcd+n2UMCejpdLfmo2Fv2tUUtiD
	4JVjYIvoRH8pC/xId58BJ9R3ShE4xWw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GRWypgQm;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785997783;
	b=y59uyngvdGzFSf7vCA1m0wIFKRwVvijmJpEZsLrWSZu6ReqKb/aEbF3ygU+yFojKlhFPrs
	r5wwu3hxZX1QRSKpcal2ekXk9xIzCHyZ9wyAGFzVBWc01+g1xFJ4lm61fuQcwb5/hNpe+u
	I+nos5E9DOFi54dPTB+U5zmCbf5DVzU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 696CC60A8C;
	Thu,  6 Aug 2026 06:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3EB1F000E9;
	Thu,  6 Aug 2026 06:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785997782;
	bh=1oY8lbXTomFFABlq28RvaAPiO8AnqoSfHSvFMVUFi9o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GRWypgQmsQpH+Mr5K0BFXBFwozD5Xie44p36cirnIl/qe72fnBCZqqUi3XnTAuvsW
	 k9fEWGIjXwyguJ+5OSp+EhtwwZ0qrXbsVwKJwtq9YWjWnf5Zc4hDaP+wj96ig25pDi
	 bUdceVvm/e4XvKCrCl79UjiyHFU0mf6m+9Im2Mow=
Date: Wed, 5 Aug 2026 23:29:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: liam@infradead.org, ljs@kernel.org, david@kernel.org, vbabka@kernel.org,
 jannh@google.com, 00moses.alexander00@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/madvise: avoid skipping pages after splitting
 large folios
Message-Id: <20260805232941.e89e96269472ce5106967bda@linux-foundation.org>
In-Reply-To: <20260806055501.56761-1-cuiyunhui@bytedance.com>
References: <20260806055501.56761-1-cuiyunhui@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 6q8o673kmq7ejonax15uj8hm4op6kau7
X-Rspamd-Queue-Id: CF95F40002
X-HE-Tag: 1785997782-327924
X-HE-Meta: U2FsdGVkX188u4q1rtH95ki1+uuIWFLFPVy3FVywV9mxs147iuCRrlZRJyY1mHz6n+vg/JLtXXdgewdMWE1egIeN8DUDghuHUWZ0WBIKPCJlE5lX0trEi5BrgaxqVUyVYCLYLwbOOu9Lj8FsK2AcC5mApaiTCdMpYl0I8ErKnRDNwH52dyR74J8sjJLZkBxCk+JUxuAn6q5JENwM/mbONcEMhbgPK6M+2C0HTGUzFYsySG5bRX60u7UPYdO/eXTFDbzdkcrxmij2JGK8GsyF0oYu7aKv1P8KMZxieJHGDjrmg1LfIGFPquO4brUtJ+j1F+nBcXvqSXLviBn/JenKAOUvvXv9+quGTXo3PSBk+X1AvRw7wwzExkxD0R04nwO3sVX0bLJVtjTFt7INjUhNWAJLuF6t7JLe5sq9qOoLxh+tTx/MZZ/Gb/oxR2LHRROPKah9VE2YJRgyyj2+iqhy+Z7x1imOAX+FMbjL/Da78d+/wzUs9J3H7Dsksx2NSjqwaTAiTpodaygmsWxstJsl4ZeJ7Obpn840vSmFp62x6yXYq/wCrvU1meOpGasEcf6nymFSsBieO33mmlO6TrC+qrREsOSPkE5QJfGpN7LfloPYrlubn3ohbrAoFBsmf31qI1nZLK/32TDTovdyj+2bGB6NHLkFdBfPj00h+P9BZHLG0KEeoF6DwyEOPeKWy5cI6V2LThJw9KgoXrcWAFzSgs01+8LnQHh3vELyv8qe3Sj6/KITC2yM5f2oEQNxg0LHqMfPaI8F7b6lrXZ3gG+wR2BmUQr9PiPN6GN3xe/Q0U5Paf0RZgRnAG/IuUvxcvT7zVBvu39A5WLMAG3rDafvqe+D2EYL2xIvrtFxDlqQVDoi8QziOVKnTkNCzmLfxkU+w9GAAW1mI2+VydDZWdIRqR6dU29GbV51/g1WSQmlTcyPACC4tjT3YQW7MXOzcU5w766whnRN4m4yzIBbzF3
 H+l+gi4t
 E4cP5cDwdHdpVaO0QNMWybgy/j35/52IzVThHdAlIHxo1Foh96y6ZNG+aW+pj0H3bsTnr7JaG2nDKIQSwv9LYQZ7bXcc8oKu9Hd+zrQ6ZiyTTou05puj01MF9U3d96zPyrGk0qqRDCqN08NPR4QhJLIPuybJL26EDiH5TDA9AD219P4Hbz/IwOjnSy98CCnv5ASoGokIWtZTY9uiAcDix5DMqSRIrcMMi9IaNtVaJ77SqLleb0uXY16A/9pV8oyVU80KX4gEoYDAsfSVbsYO6ytmPzK3zkeiKraEUG8hQHfSz1dCyTMZVHCJe0xuuhuyd9FUqdoGhN/jLgXuwzm1x8j5sNYvjflm1++ltUsQ24SeCjF2eUy5n7n+DZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  6 Aug 2026 13:55:01 +0800 Yunhui Cui <cuiyunhui@bytedance.com> wrote:

> madvise_inject_error() advances through the requested range using the
> size of the page returned by get_user_pages_fast(). Saving the size
> before error injection is required for hugetlb pages because successful
> soft offlining can dissolve the source huge page.
> 
> That stride is incorrect for non-hugetlb large folios in system memory.
> The memory failure handlers split such a folio and handle only the base
> page for the supplied PFN. Advancing by the pre-split folio size then
> skips the remaining pages in the requested range while madvise() still
> reports success.
> 
> Advance by PAGE_SIZE for non-hugetlb folios in system memory. Retain
> folio_size() for hugetlb and ZONE_DEVICE folios, as compound Device DAX
> folios are handled as a whole.

Thanks.

> Fixes: 19bfbe22f59a ("mm, hugetlb, soft_offline: save compound page order before page migration")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>

Should there be an Assisted-by: here?

When fixing a bug, please always describe the userspace-visible runtime
effects of that bug.  Especially when proposing a -stable backport.


I asked Gemini this question and then pasted in your email.  It told me
stuff, but I don't know if it's correct.  In this case it would be good
to hear that description in your own words, please.

And perhaps a means of reproducing the bug - clearly our selftests/
coverage here is poor.

