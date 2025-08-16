Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F61CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 16:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEBAE8E0025; Sat, 16 Aug 2025 12:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3EC8E000A; Sat, 16 Aug 2025 12:23:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD9D28E0025; Sat, 16 Aug 2025 12:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A90288E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 12:23:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1304CC03E9
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 16:23:49 +0000 (UTC)
X-FDA: 83783141778.02.C17F1F4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id A9F541C0004
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 16:23:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HMOGqysT
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755361427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+HWoCRfW0ZS3On5syAjsKZlW7if0MwQudqfkU82yqG0=;
	b=DoN6Gf/ssbbRkKJdk349vM/SVMiG7gwQrw+Md0JCCJRvNMQHhhWyLGy6LGrxCpOYQ9ym0B
	nKoh6Et8z3eJ4ZNEsiXOYoq9zeiaAmtXxarRJ8FLN4G4S/xxblsDQVNLpf4xn81ciGfqf7
	n3KpCinIJHaLWcxcPBKEhiF2SIg6HgU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HMOGqysT;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755361427; a=rsa-sha256;
	cv=none;
	b=ZZ+Hs9+huhcXQMAzDhAkKbkszZS1bT/JnBVXtUFypQmaT74jsSHm8eJ8ws8dQSPhgBD/hu
	P02Wu+CtKDrcyPZGhnOfead6esiRR1lsaQ3STeLpKyr/5xyc5yy0dMLYeL2OnHfBCoemSg
	vtKZ/c9Mg8gyYh2jC/iiAMXRviEzD08=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+HWoCRfW0ZS3On5syAjsKZlW7if0MwQudqfkU82yqG0=; b=HMOGqysTT3F9ZUtoBjslEpxSXf
	2fnpQ0k82dLplCoE0BwdsVAy4ZlphT/D5Gc2+VmttgWr2TF7flKJVz7VU7F5Xcf8IURFcUzF8w+Zc
	e0wWfuHrOU16HN7/npGnZAJvEZj6876pZIgdYwET0gutT27dTQ/yt97hGM/iE3jV/bBChcf+vwKQY
	6zRwV8Sc5aYb5LYPr5n0JE1UQJ+O1u1JmuW1n59ptIqeyuLgkFeANS9EJPKmYUqiG3LaY1AY1M4aV
	usd2JntfNIbuqZWe1cqbtCvNCZ3LTeqAboQzHrRCwLzm/QGY4qAHdk/AaG1b29z6ZxLMddcqMMse5
	gim6anmA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unJgy-0000000BceU-1n72;
	Sat, 16 Aug 2025 16:23:40 +0000
Date: Sat, 16 Aug 2025 17:23:40 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Hildenbrand <david@redhat.com>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>, linux-kernel@vger.kernel.org,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
Message-ID: <aKCwjCJTEhX4Q6wW@casper.infradead.org>
References: <20250815090539.1578484-1-chenhuacai@loongson.cn>
 <a20d605c-79a0-4d89-985b-9512a990b492@redhat.com>
 <CAAhV-H470h2HDEN_NY2qNBxUqQrSRQhLzwqZe9PB8GjnNsZVFQ@mail.gmail.com>
 <66ebc632-6704-4637-b62d-1cb11e5a4782@redhat.com>
 <9db98f7f-b90f-464b-ae7f-e94ac523bc28@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9db98f7f-b90f-464b-ae7f-e94ac523bc28@redhat.com>
X-Stat-Signature: fg7ttxb4ut7wyrpan5tyiwmtw91m51g4
X-Rspam-User: 
X-Rspamd-Queue-Id: A9F541C0004
X-Rspamd-Server: rspam05
X-HE-Tag: 1755361426-880894
X-HE-Meta: U2FsdGVkX1+HYQpFXz/WnB3g/DvPp3M3WG23zLumX7BXOrDzsuKo7oarV3xqX67OUdmRJ1Ix0tSKT9aiakca1MG2R4rT/pASrI0/xizFjBzGGwivbrFrq5L2kBSRtf+CvQeMVlT762MTFo0bfgpuSPU3+cttsyY2pQhzsutzXgFrTLvA2IqgugZ6OX6PxUom6KCJJafCc0uVn13310vh7aRUu2xiw0pANF6Iw08KDK3Hn0ki6pwtYj5fYv0yPRUkDXyekNu9dhwg/wJzuAq5GiW+GzeNrgFBeGLwXr7WKcm9ZcOwo9aS4+MObknFnjlrWJqaW8653temiAFqhLmqIoJL6ZjO/MUHmzWOBqeDcpvJpjYbZt7Pd3HKSN10mPD5c5oDZu2MAs9BLgTx35LockSNjBd6KB2FNhE42dhyoDExg2D66HLQRCvGyBTUt4pob2wLyxmQ4T8CpUi6ZFjNcDBOfE85VR0s1yEZsMnQ6/qZ7oCmv2sB7LiA+cqO5kjEa7bCLp5lLp47C6ZYPVRdsfHoBS4OVKxvw3CznQHGRy3GxNvp+o6w8O7FLqpO6fMBJwyFUSBg+a3YT0zDBhSB7LyVLwqnjfa/jGkc71z3QDZgfBeuCehxDrOhsMHFxeJjAYikho+2cNXtSFViT+lQyH0ySyqNbZnDqX5RNXpcMwFAD2NVgPs0M+6t9Iw5nnSzGvh+35X+wePCiQ+fgk9Kr6NLaKc2FOx0KuvgtlM+BER9DXXzZVwyYi1LKGCGnDbqPZnhMyNarkYH/v17pxKyKIkSbnWW6A6VXjl3tliHqeU+5xEy6LKIgbSqoyjpa22mDtITGj78VdxdZATjoNJqevXj+jFkN7enQH//neb+FGB/CWzGLE2QhAsNoa2818v9yQmqCFa1qBjddb0rmkrqOsJY5mYSU7d3RkxlfIK1Esuxn8GlY9ZtmJ15XAAVHzjz+Is7YWeOBhQs/KpGBc6
 8pFP81Qn
 HFIeIG6apy3/dlwZUyIT1NGqaEoqOTwJz7AI43aBDJfeTg7G5T/BlmHq3bE8/4khv1NwEblKZATgnsBxAGOO7Xt7Ajj5ynRjF9fTJIwVCgH2Eni3vy0MqL3Uchyc456QJeoDalil1PF2AuDerYS2k7tqesnrgttaq0ebuXXQqY9Bi9RpcPN+ZDQlcRYqa9e0v7nB4mpmkXg8pLihmjeqovMqzLXGGZ8CNj2bp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 16, 2025 at 12:54:52PM +0200, David Hildenbrand wrote:
> +++ b/mm/balloon_compaction.c
> @@ -256,8 +256,10 @@ const struct movable_operations balloon_mops = {
>  static int __init balloon_init(void)
>  {
> -	movable_ops[MOVABLE_BALLOON] = &balloon_mops;
> -	return 0;
> +	int rc;
> +
> +	rc = register_movable_ops(&balloon_mops, PGTY_offline);
> +	return rc;

Using 'rc' as the name of this variable is an anti-pattern.  All it
tells you is "this is the return value".  Calling it 'err' is far
better because now we know it's an error number (or zero for success,
of course).

It seems to be a particularly IBM derived antipattern ;-)
Some internal style guide, perhaps?

> +void unregister_movable_ops(const struct movable_operations *ops, enum pagetype type)
> +{
> +	switch (type) {
> +	case PGTY_offline:
> +		WARN_ON_ONCE(offline_movable_ops != ops);
> +		offline_movable_ops = NULL;
> +		break;
> +	case PGTY_zsmalloc:
> +		WARN_ON_ONCE(zsmalloc_movable_ops != ops);
> +		zsmalloc_movable_ops = NULL;
> +		break;

This might be a bit excessive ... just passing the pagetype and not
having the sanity checks should be enough for the tiny number of users
this interface will have.


