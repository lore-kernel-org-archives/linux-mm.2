Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C5FC87FCF
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 17:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59AB66B00A8; Sun, 10 Aug 2025 13:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 572366B00C3; Sun, 10 Aug 2025 13:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487DD6B00AB; Sun, 10 Aug 2025 13:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7196B00C3
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 13:59:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82FC716056F
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 17:59:39 +0000 (UTC)
X-FDA: 83761610478.24.8DF923B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D58481A0003
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 17:59:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lx5H9vs6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754848778; a=rsa-sha256;
	cv=none;
	b=xFZEWX788uGtxP6Jt9GTmvleJ/zYO7VWhKyaHDy9feMAxat0J/SvOZ8OjVSejTGWlzi0EG
	J4LspuL2I9RW6A7v9Ya+qj4R7jfI6f2kAJyA7dSUiEKGRdoVh4NAiT4hHz0aO3vdGYjiAM
	e6+evqA2xlqwV/nsxu0P4VWoPA8LOCY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lx5H9vs6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754848778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HRUwz2fq1JP1GMsMe11ZelKRNKkapWYljIw4KOn0mHg=;
	b=QwzRGhxnFgikfgySNTVCrGjU+/tEF3M6ZWR3xgDuNczpZGwVg+U8CbMANLJ4S/wnUu3ujX
	uCCw5Lmf8m9mhNssMkzYOiuU8ZiYnsJBoIHrDpukIhSk8xe/5oqErpQPDJTnEu3/7e943c
	b6z85jzvLDAre0o3zVO+AY9ET6S7Ick=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A14C545851;
	Sun, 10 Aug 2025 17:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CF2C4CEEB;
	Sun, 10 Aug 2025 17:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754848776;
	bh=HRUwz2fq1JP1GMsMe11ZelKRNKkapWYljIw4KOn0mHg=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=lx5H9vs6vrbgHptM9+HhKsU62R0SrZDySXhhribT5ghSYyoLEwnAVbY/wxlKFe/VS
	 vRuIDIvUkMuKL6STahHy5UdBy/eSQL/vvD45AnPH4/rQ8AOGARMtVM+H/6CF05kX8v
	 1ll4ToGkjrD5zIkUQiaTWRJwM/HqfyNCBupPgz+qsETF/cddzOLO4MBJ4oZqEaWhkx
	 bsXahkp0cLbDuDkszWfmDd3xv61MIPpARI03njshXOID6C0S7dVXgqnFaSQOtH9Cxd
	 cfTCplM2gakLhsQ3slLDnFMwUwnkPhFWl+40OeTVCebLyb2bCFal87E4wIe7vZiqjb
	 FWVrF88XHrTMg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 10 Aug 2025 19:59:32 +0200
Message-Id: <DBYXZ0RQ58Z7.2UBHDTZ2LCT2B@kernel.org>
Subject: Re: [PATCH] mm/vmscan: fix inverted polarity in lru_gen_seq_show()
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Matthew Wilcox" <willy@infradead.org>
To: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>, <david@redhat.com>,
 <mhocko@kernel.org>, <zhengqi.arch@bytedance.com>,
 <shakeel.butt@linux.dev>, <lorenzo.stoakes@oracle.com>,
 <gregkh@linuxfoundation.org>, <rafael@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250727105937.7480-1-dakr@kernel.org>
In-Reply-To: <20250727105937.7480-1-dakr@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D58481A0003
X-Stat-Signature: hre1dc6ftkfbenj66ardsgp8py1dt3tp
X-Rspam-User: 
X-HE-Tag: 1754848777-432874
X-HE-Meta: U2FsdGVkX18BZJ3rOvjaaGgdYdr8kvdXF7FBLX7jj4//l1GLXRzCJLZrCxYq7c46mN6NELc1Yqy24vYGBxKSKfGrxqj3Xvl+RxrTbqepMeYtcCHeHPkshosHMzvecyVYqnAXGuRNSO87NzKp4QBuEmCcqWpwmQEfjOY8jMum+mHu3w5Pdn247X5Nalp6peSByTevh03BkrdZwv6bW+o8GU9MwKNL4ZItAx3hZ9OCSNTjKicOwBfSqwMv4Kflh9f2KUhYHFhBdZ0tMWOHyD0i+tGDLzbqGwkDY0TlHZg9yDwPcoTQi+TX0Ysz+tU0nc2sdPmAK90MfWqrM5UxYbs8Gz3xY81D1DD2d1f09TYS/Uv1gH8laflwo14UOSOne4Qq/bcPXsuNHPkGvuirixp+0cVSkSnyg8GwSkzzcXw/NZ0uJhiAEVX0Q6JPYQNdc74ayJfIBSAhMQNaNfwcD/7qdD5qFS0qM0txZIx3V2H9amntMNi26lnPIw8Zd5qbHeek4qrMmKoXaoUKH7xO3GslmMn1X9jByxh2kQYojfiaqL3DKViNcK1fdnYmveiD//SWJCNhZvvAMIZOX57jT7Oj36Ngw9ZA3gyv3QH6EoYSOMvRxGaNtkXkhjmAkcYzYsUU6Hcf4mUIRDfxZheJL4VIgbmkYJ3L6VdIqKZE54oxWLR5jc+pCUMjlqHkFivrjiWV/CjI9UA1ZNSzajivqW5J5zud1vwI7Qs2gH5qwQYrI1QyBRHb5J7ISSn6lqSNN5YRXzE0rEkrSO7RKx8azdPDdEtcWD9tLiudTCiT7C6XT3CTb1EJE4W6PdLuqXZSkqBNRjFvHyHmDaI/OG04dqlm7YqM50JLnA3mYKGgJZ423hydrbxZVycAU0Ix00DOvtn8+dWyTASpb7GT8eG4OY5XWGgRZeSjJyd1mKGCNuAC2B6uksfTqZ6DBoSwJsoJsJjNDLlkIqnxHCKQYV+FBDW
 py1KdPjY
 3CgVPvi/19r5xtjTUJgefmXcHYN6A6mB0akk7L6N8tTcy2cDWyMjhdGMtq6hflXOd1vY2/7zGxIpDWyIWi4QvsSy/n1+yEt5Ob7qXJ5hpPBZLZ9iQ50t7jnHFrmboxhpvmGpVVWw8tx1RNXd3MO0VdxcYzApuWPdRZ11EN7WpyIGxhswVgMW5LLxi6WtOCPVxveS26jmjXNMgcznR4vHlzfnTxTYATaRCqsTwyethBVSiwkPE8HNB2K6GrDYeKOyKGiTo+MQ7rnEh+IUL+wDRUHUs7BO9I9UfiuAmwRHVWcJwa/tMWunSzH3uVPqOjM1X+qj7g//S8F2GtqJyB2Nqgf4NkVo9U+jDr+18Q4o/mBohWxeBeJinzG0J1c1GSaMwzTaccJ9t2EB8RIdPwbDH0n+jQM1tsbhbTF9tATA/3NrcBqxLHv1beUQNW2LHIjaj1+Xcid7+xYntrfsu9DkwCBOLmoUaBD8uG+lndRVGgBZcmBakOpb+Xjf9dTuDEXquvk/1zY6iBYfB9eg5X7UKAjXBKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Jul 27, 2025 at 12:59 PM CEST, Danilo Krummrich wrote:
> Commit a7694ff11aa9 ("vmscan: don't bother with debugfs_real_fops()")
> started using debugfs_get_aux_num() to distinguish between the RW
> "lru_gen" and the RO "lru_gen_full" file [1].
>
> Willy reported the inverted polarity [2] and Al fixed it up in [3].
>
> However, the patch in [1] was applied. Hence, fix this up accordingly.
>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Link: https://lore.kernel.org/all/20250704040720.GP1880847@ZenIV/ [1]
> Link: https://lore.kernel.org/all/aGZu3Z730FQtqxsE@casper.infradead.org/ =
[2]
> Link: https://lore.kernel.org/all/20250704040720.GP1880847@ZenIV/ [3]
> Fixes: a7694ff11aa9 ("vmscan: don't bother with debugfs_real_fops()")
> Signed-off-by: Danilo Krummrich <dakr@kernel.org>

Applied to driver-core-linus, thanks!

