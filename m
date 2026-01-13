Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF89D29DC2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 04:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEC136B0005; Mon, 12 Jan 2026 23:31:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E99CD6B0089; Mon, 12 Jan 2026 23:31:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA59F6B008A; Mon, 12 Jan 2026 23:31:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CAE196B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 23:31:36 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 286D91A74D
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:31:36 +0000 (UTC)
X-FDA: 84325666992.17.45FEABE
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9B834C0010
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:31:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=BAkTdP8q;
	spf=pass (imf28.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768278694; a=rsa-sha256;
	cv=none;
	b=XhIBghRQeW8OT53pnBSYJlfF21p3rR/Ikxn/QtaKBUx7T1mdUKUNQko7QCXIjuUBrWbL8O
	y7JHs1336hE5GXr89CFsNWnuH8VJzkT0/Kjw3D3mjKpS+9Bgun8IBnv8kBi5IE3mQfJeTD
	GfW8p7tNQBwXjw71HREwnJUY7CB9H1k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=BAkTdP8q;
	spf=pass (imf28.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768278694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/pp81rQAMhtIyr/Wtg2fg/qbmVYAdF7/Cz7odtkofXs=;
	b=6JpuCfrNALZt+wMYLonuTiUG0Q2Ri5Q42MH+ArsbBCa+ZQ/w+bXr56u6V5mSr+JLYfyWjU
	fdS8Q29Jav0/ulrdcug4wOJM+e3IG8tEzkS+uhiPAFLM9x94DigmocgY8PKjDxaUNNXWl3
	+5Z0m19lqT/k1MLfQfCCRuExI9N5F0E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=/pp81rQAMhtIyr/Wtg2fg/qbmVYAdF7/Cz7odtkofXs=; 
	b=BAkTdP8qpghJLdcrfg0qrzk1VDQjiN1SUNcj+XKOLJV1UZR2nTD/vtJ25qL3/Ficf6nggqrAFRA
	P78UjgHnZoJ063amkA26uAG5/hW/GMF6wb80xQv/neI+nPNO+MZpxHGQYJnn2wwG9Q8CG13JhLASf
	M+YXgji5qx3H0rle2JIvZnfMakW5c/dWZ663CHt9xShu09k77ArMcPHQ+f4KUGMfidxNae57GDZ+i
	OKSpsE/6Z/pYeAoaawIY+bqqcQYQLT5HXfV1W0BipTzOziMEhGyvSuDoskklQY4l00KEAm0zpnIuN
	bNHBUApGlhS3zX6wHDEnLOl7y406uc8k73Yg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vfW3V-00GH2y-1T;
	Tue, 13 Jan 2026 12:30:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Jan 2026 12:30:57 +0800
Date: Tue, 13 Jan 2026 12:30:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Minchan Kim <minchan@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] zsmalloc: introduce SG-list based object read API
Message-ID: <aWXKgU_4jZghDBuC@gondor.apana.org.au>
References: <20260113034645.2729998-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113034645.2729998-1-senozhatsky@chromium.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9B834C0010
X-Stat-Signature: nfxm8633yj86nteenn3ttjzx1kapdrzn
X-Rspam-User: 
X-HE-Tag: 1768278693-708726
X-HE-Meta: U2FsdGVkX18gDjZC6TWN1kMWQsYEGbC0bknFTJUTgFKykp6FcBmQ/eqA7ND5iPjxzVXAkfKx1JmUVx31DCDRxvlaF7DCfG7f/1/pfqxPA7nupQhT5EHCyaV+uDhRmB6sfXdBMO4ewM3rnR0wBleTERQ4d5sw3dZuZFnWy77jxPPMZevXPXr02wsRXssIzGEGZdoCBbvS/0jyDx0yWsqslluuTtRemn2UAXrVjbnIo8SXULzcrNnaIjpRd4BcLtXZ94A5FMZQN14mx0nmnIg9K7/OMPuYIxi09+ha3t1X50IlQ69gMGMk+bzULF9Mz7TgHuWcNGrwCcSyKaXp5IOAJqC9KhkqDL++VQGO4prQdIJTphVBicZybGQrgB5LtqHa8Jyf2tHWo4pnx8Nku9rHV9iUMTyq520SwgUyZ1iijAGulU0rfLKeeN3D2Ao8Tz5BNgxnwqdXP6xNtMOxJHbDmFK6KJfSZE/PAwX99CH2r2pO0a6VqAlCmp81muBJTTOIOsugIzWcY6DgECT7tiVSdEpZVAJvzVwYzuX9HB3e13iMtwV2rRMw7LJbh40/koIbxZr2BZhXcil/UIbOBGfQ7t4tc8vvnKHyAcdMpdVUSq2PQJ/CU/xGYiqVmbVTRUuyWjOLS6McvuB3fJ3+W+TftcdoF4+8w6+z8W6ZTBz2rlGx4dLou9hiBYcvARn5Xk4a2wdq9mKII1pAntGveV5DV4i5d0h7+Jbjt/chmSgTtmXcyTPn7Da/kR58i3IslJt/1GbeqJrr0tS7/3ZKcqh/MgorNu38u2Lvn9Ye5ZTbGWYCJaUbbO58ueGr8Iu0uJVERAOYiuingb6YcyBgWyJd5W3avNzFJaSRXn8bXImCeq+nWvYJwYk7IAQNscnddotkocdUrK25Z7dqlfMIBDwKFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 12:46:45PM +0900, Sergey Senozhatsky wrote:
> Currently, zsmalloc performs address linearization on read
> (which sometimes requires memcpy() to a local buffer).
> Not all zsmalloc users need a linear address. For example,
> Crypto API supports SG-list, performing linearization under
> the hood, if needed. In addition, some compressors can have
> native SG-list support, completely avoiding the linearization
> step.
> 
> Provide an SG-list based zsmalloc read API:
> - zs_obj_read_sg_begin()
> - zs_obj_read_sg_end()
> 
> This API allows callers to obtain an SG representation
> of the object (one entry for objects that are contained
> in a single page and two entries for spanning objects),
> avoiding the need for a bounce buffer and memcpy.
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  include/linux/zsmalloc.h |  4 +++
>  mm/zsmalloc.c            | 65 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 69 insertions(+)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

