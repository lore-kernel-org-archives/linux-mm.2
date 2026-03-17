Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C09A7FB5E93
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 00:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF786B03C9; Mon, 16 Mar 2026 20:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 081236B03CA; Mon, 16 Mar 2026 20:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8E96B03CB; Mon, 16 Mar 2026 20:38:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D58DA6B03C9
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 20:38:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 788B21C504
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 00:38:12 +0000 (UTC)
X-FDA: 84553693224.23.E0C4C1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E441118000E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 00:38:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LLFZVYwd;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773707890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AWREopsOMXmUIKruLlb75+6U391VwaIZecuCS19SxAY=;
	b=fg/4iG3/yzfnnCv7Zt9mYR7a/WQQfLclpj738+moJtISLaC5n5v2F0IfFowZJ4YPy1Noll
	PQOWYF5I68G/5IQ0ZIyY5hLC7chRucWtpkMh7JTbypRBHV9CAZqAIoWeRGox/JXYRV24Yf
	qxQbb5CXTNvkE8I/9C3/4zguvRdG4X4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773707890; a=rsa-sha256;
	cv=none;
	b=ZkyAjG/e33DICDAmh2m1qN8SRVneT6h/Xh7PVx8y7jmosHh8gAGYn370/KC8XgKqf4w0cd
	Z1Bkt7glfMlygh9rSpAuQHpTB7H5MwGnTU2fEpMsoSFNM8OvtLgqy4udCE6M0EqN99ldI5
	UKJnCD0uTZ46MqDy+PfrawxtmjxajyA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LLFZVYwd;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 575C160018;
	Tue, 17 Mar 2026 00:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83C8C19425;
	Tue, 17 Mar 2026 00:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773707890;
	bh=mZHx5DcjeRrffIZU8QhIytqAzGsXs8r26tpr+jy+FEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLFZVYwdRQRn5LS9+rcV07qD/UHANjm3rQURxV/A/h0lUkTiFrAtI7nDn5foYS6N+
	 G4b1u2kDHw7TxZBpfFPVF7rmbjCozhcGY4gOt/NzJg2/CsIJLvl8kdmEC5KSJBNe/t
	 Ei/y6LWzSC6gpJ+oV3eof8Vh8mAM8+pAQE3TAGQ7QizjWjyVwwd9ts3mHTwXweSbMT
	 lyjsYBvZPf0gcpmEaWtcvgQ/7gtbYAHWh4tRPSlYaQr4VmgI3HeMRnfQuzff7FrmBK
	 krSmSqQvGfzxyX8ofsI/zCaJfnXzChUltPqDagN4lT+/vew6Fi0rRXs3n64Kd2ZZ9e
	 SYrcg/dQtuotA==
From: SeongJae Park <sj@kernel.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/zswap: add missing kunmap_local()
Date: Mon, 16 Mar 2026 17:38:02 -0700
Message-ID: <20260317003803.89459-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260316140122.339697-1-ljs@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E441118000E
X-Stat-Signature: nx1o411sckdddeejpd7aojxmfjrhud9w
X-HE-Tag: 1773707890-663707
X-HE-Meta: U2FsdGVkX1+K03PDSkvjsx5EHdyLjPqx+xk3OUb5JumTZ1kKZf8L+ByEyzBK+dg3jLwFKtDWzzIqnzuVwhN4CPsM0+DR+93VK3uXNAr5+3234gSUIu+UupCO5ZhpJrNevQ5CrrQirIIM//2vfrAY/BatB+TDk8k9o27B+wiWeSYHxt4EgNGSJlA2eJKEANERJZYsf1HBZvjF5zETxSTLk/yKzbG5+otohuPMx2JZgE//ZXjPB+6mHd7RQWvjdeNlCNy8mR6mE2hvI4n4hLq29g78K7LRBaGuWmeMqc/fJ3JxSxiYlkICtqe0SCN0oRH/KNTMPOQ/t1CVnniDVeOm38dKlvx9UeQhVVak0wG5sVqtOWAWpr61NTAIW0YuxaOQ334cflge4lAzisa/t8wENsSp6YvyMtmWD2iM/9weqjHTpyydB2cayrMKe8UmB2rxdLCNT44yx5GLaa45S4a/XjnSasJO1vJLasNKiEPA0/o2qpueFOzuAE1Ugadqguw/dIPEK9DRyyfy+tpA7OXsNuQziGvHlPIXqkpIaoSwF1/rYnkVMGNS2kxAPELmvTUIAoCSOoBfPP/WE6gfwPeuFpuE9rmyLkhhSGJVjmgePGtjubFFUeFRvsyod06zyc+iji5rZrq61SzNpVSQGsRtxYQO+iKaRHEKnEUhh5o2ph8J48XJ69ilGFNPk6F795xG79M4+2aaBLC4zYmzq8Bm/9sSH6sRNKaNYqpZ2QAFiGuEv1gJzdIgGH0gYOhfDC54to2lX8WnD/kxvo/2NnfW6MsRV1BpfnyP/BQQhxUqmihYYv91XlUyXCC1doGA1R0l+eT4tNH3iOytGa6QsTApZcMM8QSptWkjHUhxXZJV9hk5QhC6wL8YDkFtrVz2+1xu0jjfo/tihcuLnd24Pp/HveksNvvbjyFo481y2oEePp4+d2ApKIGUqShkIxWUn9eUi7Ya+9XRYxIsFT5DA1I
 aS55LkKb
 YlllUxg4+WJ6Pc2iB+dYUYCLPTu3r/jAfoHfK3LOJrT7y7LK+zhaxgonQGLEWo2R0a47Yu0ZDfmjATAVk4wAlQaXkXowvDJyE0KSLBlJ4g56m1aYehSr8f+A44DoeRu7IhimwGCP3JjZULzlwvqau+NmAMj2kuH56dgaQY4xw29/l27U0iVc6MoufptSnO6un6JmfIwBFRfTpuq8faoC6ZaU0GI/dY0KCLfi4gzGYlmruTqt/yDu9RCEFsmpokD/uDAmDJAAsVtB2QX3FG7Q5lV0b6K8RAsmBwqLMBkMsQQtP9x6IBblglzkHGZHFhsuZ6i1LFQ9AkeE7C/HaMMQwVJ5FpK+T+AjIZE7e9A7eprk5JJU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 14:01:22 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> Commit e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from
> zsmalloc") updated zswap_decompress() to use the scatterwalk API to copy
> data for uncompressed pages.
> 
> In doing so, it mapped kernel memory locally for 32-bit kernels using
> kmap_local_folio(), however it never unmapped this memory.
> 
> This resulted in the linked syzbot report where a BUG_ON() is triggered due
> to leaking the kmap slot.
> 
> This patch fixes the issue by explicitly unmapping the established kmap.

Nice catch, thank you for this fix!

> 
> Reported-by: syzbot+fe426bef95363177631d@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/69b75e2c.050a0220.12d28.015a.GAE@google.com
> Fixes: e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from zsmalloc")
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

