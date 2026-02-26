Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83BE3FC590A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 08:01:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA9086B0088; Thu, 26 Feb 2026 03:01:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8B0E6B0089; Thu, 26 Feb 2026 03:01:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5716B008A; Thu, 26 Feb 2026 03:01:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97F426B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:01:31 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E9BF1CE93
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:01:31 +0000 (UTC)
X-FDA: 84485863182.04.8BF87C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D11684000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:01:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s6rw1H6y;
	spf=pass (imf17.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772092889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HCLl1BZNHyu3OheJzxeaprHQvKigKSpbYYDtda12R38=;
	b=A8OlLH9NU73A/w5FQc+XgYnmb4ygAquPrUtBnQPSp4nAbAj1YN1QmPE+50TZQ6G4ArVz8c
	uCjW0PhMiWfMugq909xGAObiK/vLPpS7FMOHAkeiMYcNtOAf1Vr3anL8IxEAKNrUl7LqUO
	WHRcqTRFcTXtkQg1oj9Niv3PFnsZ4r4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772092889; a=rsa-sha256;
	cv=none;
	b=oErFTgGT/V8ZFQ8YIuv0u5UrKckiWNURBbv7ZO+tFw9CZ7jQ83HZYqy0cbseqLwHnDFP5v
	OP8dmo0xyeOcd1AMc5UUJuCOuJL4teNUttYIo0AVQE7ARne97tIqQeSwuzS/G/6zzmmnqr
	zyJ4qc5YOVSgXiA9btX96TjhQTolNJE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s6rw1H6y;
	spf=pass (imf17.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 331DE60097;
	Thu, 26 Feb 2026 08:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7A6C19422;
	Thu, 26 Feb 2026 08:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772092888;
	bh=3sfrdCB29oEXL3KJoL+J5uaz+wquoAS1wW/bgZeqLzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s6rw1H6y+vqnuONK6Ysu4jhs1mtWgILyhWX8bkvjNuDWTNWJeY1kZ2SS4YKjpc8LI
	 FHcKTU3VS5txnq2yS9u0CzzWjkdfg/G0GzxpgnA0MIIG0LClu6Tc57h4ezhaxkbICf
	 iS+OH+/nfIYWOzK/be/qhYjSi5jydhVOUM8YBXRMZwCYOXMKS69JInmD3oJC7O9eTT
	 FK4aFl4YMMllcrVPJIiat+0ZFX7NoYAGEn3V1vkvVKtRSN4Mmi2na/iWXdKEzeHOPM
	 D3x8gyB4NAnASl9JDNjaUOA7YjXaZqh4FKt2grwkSrMxbXz/Gs5GJoJMd6qV+LO7AO
	 bXvBpLcRvEtyA==
Date: Thu, 26 Feb 2026 00:01:27 -0800
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, Brian Geffon <bgeffon@google.com>,
	Richard Chang <richardycc@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH] zram: rename writeback_compressed device attr
Message-ID: <aZ_91zBGSKfpsUii@google.com>
References: <20260226025429.1042083-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226025429.1042083-1-senozhatsky@chromium.org>
X-Rspamd-Queue-Id: D11684000B
X-Stat-Signature: toidqrurji5q9uumk9rw6tfhnh3iqfdi
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772092889-966917
X-HE-Meta: U2FsdGVkX1/X4Zjmql8Xd2r7HXXk+AZSbWQO0SkPzqZzTHL3KD0HO+uaUVW4fzIlyyC/zC+fxYdaroqkMgj5BuMfuhbHsCCWE3NOktEy+eS1DDZ6OLGezMYR9GjJffqAabdMPLJkNOxfqXopMH63jX1nalqR56EmdlKl7OBCkUSGI7heP2fCsQU/jnH0Zw1k01LWZ0ZgkVlCSS9qXhhKPIs9aYfy8SWNK8/VLxuFj+aNHjdNaxHceEcvWCk+D0hclI633mKEy++ZkKR7mPvep0pR9e3e9SvGzn7PUZ7wcxujpvb5x1Hz2u1oFA55A4KQ1jI1FkfyBx+chS/P1T4/WMMvachAp4D6A/bTqQtZNq+J2ZaYYndonYdRk3vIfC0Xvcw9PnmAMOJ2zZmNXBfMocj29pflp0QANcr6LqO4ZtPst6X4lG8x175jTyjqdeUWxIrRLo2gbQKambCs1YnfUQQxEu6ZOMQ4xIZiZsDoYcwjq3xfXeJ0Jok4bH5XIobbYelUjIP/r/CcbhspAGnSwrNzOJ2i2vOxwzp+g+eDetlHfNUp7xD9tu0QELL8RQpq3PwIwrOSZlHqQvRzh+qx6BNUYEQQ0m+bMOG9yUGZno9+7Hw94j/26rGsI8rRieORIY+mP+NVRY4iOMvHgNd9ZLInbYtlh/ULkPCJ/GHndF6nHerAq8sUM0xfSVyn+CqAsjmeZwe2tlfZhsajlB65mcAbB/imwBGrlRNgvrgSioMD9v7epKrLFwDizBf1BfTXN4RAcKdQVhSpRd7et3TbT0ktfgSkHYw3cjaX/w54t1cQV4Tj1qIgayskaCrBct1Yj3ClhmGnW/eu0TJYwzHlVbUDuK9Eaoo/JuQ2BsNw1pDfGNS7O2SZJKpGYuqkExA34w/J/U8Gvpp+5W2yrK0CmSlsotNlm2iuwSN9DDwxfwjyMgqwokAl2kYxCgRLDkjgYeqNwguA+F2hR0SkyR2
 0bCAVTX7
 +IFK4FnnYhkiXD0ixaCa9qcsSAXaWrH+MM83nXOWaeariv6uLAsVIJnfq+fwYSznqPoYtEd0tGe58KWD/VqYtjkfKPHfu3zBAzOMt22AdV5i4d6okynOrw96PV70geouwO82hzBFtmMpVoRlPpdtBUtKr+9XKoxU7HeBVFYtu+bHecDUlC5iaUJb6MfXscDnjExmCMiRqaGmmurk7NwPUybOPfeGzrvmVKQqHYli3LajD8Yfr36+z7fJugGYTpJx3Gwr0TwyJENBqiQzChideFS9EH84CLBIuaveOsRI+/MPXmVRBzeVlbird62BaCVX4kA4PdN+x6LaGf5suoBTK4jXetw/+M3jEmyO2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 11:54:21AM +0900, Sergey Senozhatsky wrote:
> Rename writeback_compressed attr to compressed_writeback
> to avoid possible confusion and have more natural naming.
> writeabck_compressed may look like an alternative version
> of writeback while in fact writeback_compressed only sets
> a writeback property.  Make this distinction more clear
> with a new compressed_writeback name.
> 
> Suggested-by: Minchan Kim <minchan@kernel.org>
> Cc: Brian Geffon <bgeffon@google.com>
> Cc: Richard Chang <richardycc@google.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>

Thanks for the quick fix, Sergey and Andrew.


