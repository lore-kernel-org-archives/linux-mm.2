Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3129CE8D4F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 16:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 030CE8E0019; Fri, 14 Nov 2025 11:16:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0084F8E0005; Fri, 14 Nov 2025 11:16:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E611A8E0019; Fri, 14 Nov 2025 11:16:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4DFD8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:16:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81735B9630
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:16:10 +0000 (UTC)
X-FDA: 84109714500.16.6BEDE8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id CC1FDC000B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:16:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RyWrUZmi;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763136968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ve+WAMq8atN7a13urD4whY2gxe5IxNcUUoYARSAJDk=;
	b=hLP31BDmYrvyREhoYnw7YJKhmbhbG91lVoSynKgMbItAhgswojBHJlD4TfTYKOHLhjVojV
	88NkuD1I8suBzkACSPcZscS8DgIgXZy8yooBLxLjmCP8152to2jqZ0m22MkDf5mm9RJxK6
	u/a1wQh8wPag1TqefRSpcGYs2psiH4Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RyWrUZmi;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763136968; a=rsa-sha256;
	cv=none;
	b=rxvGGp0DKXUqtMqnzi9NrXYAH/8XKf1z8PK6bFwzXcy/ZkrPNKHavFwHA5uJFb5sWjlhuU
	sgF/HfT4mVpWW2aw1s617Ds7y/yitX4xBb5878NsYVL80qfWWwCN+lMEmBkkUA09vff3yF
	skEMsxzMGcVaHCbLs1pntjE96mPu6QY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D442540339;
	Fri, 14 Nov 2025 16:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AA4C116B1;
	Fri, 14 Nov 2025 16:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763136967;
	bh=tSxN8dD+nQ8F1DqUN5WT//XcohZgIvkWhnqveOTbdS4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RyWrUZmiPavdad5/L4Ku4XTi4TroUF34qqpGQ2vIK5Mb+GKYPyKWzhjiNLEd4eT2e
	 UVXjYV9X+p75gEgGgQGz51BDugj6dLOcRxf/VtpXcPTXatrH+9uNm5doI0218B3bwk
	 Y2Hg7roLrSqqgo25csIUK5gOEatcZZsUU3dkiavyuOFbjg48aE5Y2hvGJyyrDDRWsj
	 2xMxNTw5GvJRhE3w7q4MlB5q8T2wrOI7/qyovv4wx3MUPDtocUVMtWPmRVLXtriwQC
	 7MQ0J/Goo7rfaJLwR7Of0FxWUIrNKVvaNp8SDsUNbxX54AOCr97HvybItXlgCaUcSZ
	 u1xzn7yEwSdHw==
Date: Fri, 14 Nov 2025 18:15:59 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, bhe@redhat.com, jasonmiu@google.com,
	arnd@arndb.de, coxu@redhat.com, dave@vasilevsky.ca,
	ebiggers@google.com, graf@amazon.com, kees@kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v1 13/13] kho: Introduce high-level memory allocation API
Message-ID: <aRdVvxF2bDVjSN8f@kernel.org>
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
 <20251114155358.2884014-14-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114155358.2884014-14-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CC1FDC000B
X-Stat-Signature: k3tdk9xgsbhofobhz3bdjbjpwin1p3gn
X-Rspam-User: 
X-HE-Tag: 1763136968-10791
X-HE-Meta: U2FsdGVkX19K1BeM0f2LMaXToxtC5tA6wErFBJU8JA1L4OyVa0IRwcmy74FUb7Lv3RMkETgnJwwgwkV+xoFoLQTZPa1YHAIhej0hNksmZ3rmU0CvSXjxyzRmul1KAnhEDwsGWVTsS1b2n0UmD6gHo3UlNEfi8OPtc9WpEqKL1QjWGPv9USAG0u/SjLJYm0WoTQRR0Mzzx7RpIY95vB/BrPzj2oCnIdjrxh9LMIW4B4tXdaJeddVM5r6HzZ4cz5tGVkQ+bAe7dRRpzA6Q6vDrB6714Gc4tMt1DYnKJ/qrrFGqFRgnNMkPe9Wc7+crCM9BqpZH5dQNTOOkftecfHKj6muUgUQqyIaogFnhJ7qx82NIxHqZ6ijPOy5gQWOjGI9cu+gSjtmyJrfgPy+MaxpfAhJ7az1hmCXNfAcKVSF9CZPP3JAvMOQx6Djo8YNlspcVupZ3rMXUpwnsGHCoajDbjgCiBG10bDY6eHrJsRA167+LYgTKjKFcDdJM+7Lu3520U4XfMV+lbVqyfUC+YrBiVKuWoxbMh8iDDuO9jwGuXX8ml+OrgVaDECbugobhYrYTd5zbznQxJsZQXYLx3Jk7pA98wp2ra12axVWJ3OK1nsmDc6hwMr73eg/8k/fLSl9ZcjqJdUj4NRteKxslWThaplhSXT5vDXkPDKHXYHhA4G0X0wtpRk60lsjEhNxar1HeX6dicvtPq0qGThynYznhuVGsxFenxng/4PAUlkY7r9I6RWyTJf/xSjZjXZp6oN5xc0LY+b/K/4nT5AV0+3pnNb/+ocNy4Mj+aFKGLLQqD+O8Jk52eAAPpE7jLJcAzRn/C/CfTpyL6Oxfnpao4UqNNFj9p1hYICLCoGgU1eJC220xwNQifHplSiFHpcQ6EiPvJ6dQ2XiJS4giF2VN409GzeGLQadoHr7LPQwryakPmR/7hyi9NX6sMspx5fGtuWDMrv1hjW6pcpFKoUAJ4G8
 w8K4WqHz
 Iu/l8kYnUQdMBOZaVjbxVZYuZVPuLkqN7yLiN3FRCXpXuSwPOBTaZYGneukBaJEvuTk3SiZea2kYKAcjwS1jaCn1QypFyScijqh7Bk+qmMNckVByPHeuTdVWPn+ANXZtco1Ql2QoLSC6wxFJyFtXl/INyVgOPw1IRe7rFK/WwfXJBQE90HNoLr4NztKN7JLLm/CXg3DweijVzlvqLiUh+oYoZIsZR8sheLQ0/dca03FuBYjaw8n9DkcIspTRB6/Am16oWlQq4oyerGOqrJ4TQaNMLlx5+7i6xvZdRvUL8PHUXMUQYHVxibW4LlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 10:53:58AM -0500, Pasha Tatashin wrote:
> Currently, clients of KHO must manually allocate memory (e.g., via
> alloc_pages), calculate the page order, and explicitly call
> kho_preserve_folio(). Similarly, cleanup requires separate calls to
> unpreserve and free the memory.
> 
> Introduce a high-level API to streamline this common pattern:
> 
> - kho_alloc_preserve(size): Allocates physically contiguous, zeroed
>   memory and immediately marks it for preservation.
> - kho_free_unpreserve(ptr, size): Unpreserves and frees the memory
>   in the current kernel.
> - kho_free_restore(ptr, size): Restores the struct page state of
>   preserved memory in the new kernel and immediately frees it to the
>   page allocator.

It would have been nice to have it before patch 3 (Preserve FDT folio only
once during initialization) and use kho_alloc_preserve() for KHO's own FDT.

> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/kexec_handover.h     |  22 +++++--
>  kernel/liveupdate/kexec_handover.c | 101 +++++++++++++++++++++++++++++
>  2 files changed, 116 insertions(+), 7 deletions(-)

-- 
Sincerely yours,
Mike.

