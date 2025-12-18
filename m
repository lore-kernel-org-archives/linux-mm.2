Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA90D711C3
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 21:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EAB16B0088; Thu, 18 Dec 2025 16:21:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 397906B0089; Thu, 18 Dec 2025 16:21:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A42D6B008A; Thu, 18 Dec 2025 16:21:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1907F6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:21:20 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE57289AE9
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:21:19 +0000 (UTC)
X-FDA: 84233862678.26.3339050
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 180F240006
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:21:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SEBytomn;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766092878; a=rsa-sha256;
	cv=none;
	b=HlnTzN0JGrSKjzzycjsQ+A1O8fNg/mm0O6zST/zw9b02g903RK/J7rwLpmSpWS2UjKo0hi
	5LiGfMhaShNz0bYIBAq+zMR2qZ1gNGd+OMw+3C4Ylu/OUjKl/UmU5bALY+il32EeDQSE89
	iF18CluiDQfH60JR+7gbYyzkaSEY2t8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SEBytomn;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766092878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMWylm4EjduT6aotwCuXNn5VCR9uTWu2qJdbswsfUHU=;
	b=qrSUicL0QUn/AIfqd4wm0qsDhuyAK66Pya2O95f4JMLn2BHSS44FgX6UJVj4vkFOJ/COKu
	5esoTr2k4CUHjRl87Na3bngDFk52Ao1605QBUMIo1xSv0KxlQLUW+kmsC4m58lSCvqCZnL
	D2dAcOGJGD9ElCUeb22Zk2017iZSEYc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6491F60097;
	Thu, 18 Dec 2025 21:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98754C4CEFB;
	Thu, 18 Dec 2025 21:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766092877;
	bh=2QxZ3eI3kgiomXWTwHaqixPIsDeJcNn8cyYTgWzVg/w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SEBytomnYuljvMejgFs8ipzlTDlgRK+8pBd15nJa0wmfn9W6MwFCxxsSVQHdgXsoO
	 zHuCld1a8EXWan1iysITOyAe28IwuwYNeTSNEjCc9J0DFsYqN1V596Tn2Fs7xrbjI6
	 +uE/ePcwfaOfzt0aTPVM1ztOnSKv8ju9xaX5rAGQ=
Date: Thu, 18 Dec 2025 13:21:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>, Andrii Nakryiko
 <andrii@kernel.org>, Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
 "Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig
 <hch@infradead.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Meta kernel team <kernel-team@meta.com>,
 bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com, Christoph Hellwig
 <hch@lst.de>
Subject: Re: [PATCH bpf v2] lib/buildid: use __kernel_read() for sleepable
 context
Message-Id: <20251218132116.c1edb3ee6688605bd270a666@linux-foundation.org>
In-Reply-To: <20251218205505.2415840-1-shakeel.butt@linux.dev>
References: <20251218205505.2415840-1-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 180F240006
X-Rspamd-Server: rspam03
X-Stat-Signature: 3u6sua8cexyspee751zy6qhqjau3it4d
X-Rspam-User: 
X-HE-Tag: 1766092877-475908
X-HE-Meta: U2FsdGVkX1+qoNqvJg9vYEWSOwNl6WJPvbPFM5/a3mcuSluxRW4z1nWWFRvAMAcsxkdcOP5GWZE0TIRirgj8xr5O6ivuRAQVaIR4f9at0CKCQrvFIV9igk8ojHkxUiPP6CBl8t5KDUELV+k45uZILUDgr349KpE927Cyh/xbjFnOOOcwOUmmJj/yujISc/AlV6fRkYZT7RMF00F/YgWyQEllsHB+rMa/mQmhF0TAVa6iccngeCjBarF4BZKEnABsxpki/qmBsQABCi0dKcGsEUs0gJvVlf0y+GGWjr/ZvlG0h0uPmieByliHfn0Jbz6jE6sSQUyhfAh69jXbX9P/x4uRKAsAxfd6YEr8RW7ofZV6qmobOxHrDVAbPO+0pHeU7eNf7RlB+XoK9KsdOek9X57RvcWx9cEc1TPRbTt717fQkhRf6KPB5gI2JavhiAAjNevPUR05fjyMp1hvFsgAJYRLuRZJq9kNvj5TKLwew0N0cNr1VeU95OiE0nPufuapOEZlfw0QHseTOFyUwiZvqKZQONWrfyV4VxDLA6mTuzkS8TMJQMAx4RKwxQEroMxVr4nuJ5JV+fwp0ZxsheuotLYw4Mg/KibH9g0U0Gzvsg+VJwAgnb3cFGvo/7eF5URrig2tmt9bXDTN9zqpfJ/rmqid7alz4Djs8MfsDobpZ270SLBiTjn1WS1vkSVWD6iTqD5YSz7EqijD+SBJQjaTt8v14XhW2YjHuy8X7xAgXCnmRfAX7I+UjdRIlBZ0k0JSKLoM9jmfIaYk/tEXfQJ2wdGTRBGRKqoPJWqkV4DUxjYNgyXH+njefNjCY8AV6k/7WGq7YaTHs1AjPC0ZQ4JYaxfF6ds7m8wynULRr8w0b4NjwRE2xzEy+Qb+VLyrEVY+6Bp8nFTKBJUo7+Rz+hbkqRzrHOKJil8r5LZ1zA2l6KKATfIstHGumo0auhpj+TVZrKsLXOb8zWPSKbZrzo0
 2xt2oe4+
 8gZ3rXejCI+Sc1Fbc4+jyaAKGCGHXrr2XNy2yAVgxtH9aJd9qUSGeCcHT+EN3YcCfldHVavTfm5YKhPD9NWJqqQdJKDp3KRCK6LdOjtzmqmugUVgZ8nGZKMjrlQ9HRrWjIKvaX34e0xYkOephIBEzBvwrAHBoibrWxyIiMKPdDwbMpLVujorrsbm8tJODV6foRLWGyopvV9JLvuX6Ls0swJ/bhGAGzHFz4dcrelObhiMnSI8Q63DE4Zb64skwW01NQC+OZ4wm0MdsQWzllitg7fUrBVPP0FlHC3OsqNn7ge/DxG9ktrv0COABf46zRjnS/X9sjiJCdUXSHpvQi19Y4qIFoIAHBKpymx8K7JO3lcGKqe1+jSg1B1DpVdHvsvyE/JBTwuIsHHtlWIKRCopteaZN8zMbRPQfNr9CbvBMih8+H4yjEeyihFXbT/XBd7POA+t6PBJreOE2h6SC/02+/TqLzALQK90BhJw2IIegy2kEJXB5N1pBPVF1yUjdiGzs6ITH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Dec 2025 12:55:05 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> For the sleepable context, convert freader to use __kernel_read()
> instead of direct page cache access via read_cache_folio(). This
> simplifies the faultable code path by using the standard kernel file
> reading interface which handles all the complexity of reading file data.
> 
> At the moment we are not changing the code for non-sleepable context
> which uses filemap_get_folio() and only succeeds if the target folios
> are already in memory and up-to-date. The reason is to keep the patch
> simple and easier to backport to stable kernels.
> 
> Syzbot repro does not crash the kernel anymore and the selftests run
> successfully.
> 
> In the follow up we will make __kernel_read() with IOCB_NOWAIT work for
> non-sleepable contexts. In addition, I would like to replace the
> secretmem check with a more generic approach and will add fstest for the
> buildid code.
> 
> Reported-by: syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=09b7d050e4806540153d
> Fixes: ad41251c290d ("lib/buildid: implement sleepable build_id_parse() API")

v6.12.

> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks, I'll add cc:stable to this due to "crashes the kernel".


