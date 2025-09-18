Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E18F2CAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 08:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BEDA8E00DF; Thu, 18 Sep 2025 04:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46FC08E0093; Thu, 18 Sep 2025 04:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD138E00DF; Thu, 18 Sep 2025 04:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 286CC8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:57:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D171D13BC3D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:57:06 +0000 (UTC)
X-FDA: 83901766452.18.56B05DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2B5C3A0007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:57:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FIpu3YQa;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758185825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B70MIfxMGJL9Ne4uGgRJnWS8tEvRme4ZSBW8Cy1kRko=;
	b=NhELBCXk5WGyhLLUbiV61rWaB4I0wUo+lVQIuhIXLNqdiP9XnSwVh0vJbeCH6zGQJQthni
	wTCdocFOGeGwQseE+oODHvJqE+4cv36i3FAANG55bqESeKig3yX+8cBTYTvJhPXJ/OxlT7
	sDcbERDmC0+kqB1mVAfR+WMHEGTbu3s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758185825; a=rsa-sha256;
	cv=none;
	b=OEqfgQwdoZsF58yDZxGVl/vLc9lP+xtQLlNv6i0uXltZE0Q7UfQtqRuDtYQjF2/JGE4m7D
	Ibr0qXPwCmZXoahatNfLOiBkPpOQKsMw47ibPcjIAXrc8K0D7iNvy7vwtM9GfGaZjqa9Vs
	xwgd/ABB8ToFFVngIjg25Nb98BJ1u6A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FIpu3YQa;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 170C7442A6;
	Thu, 18 Sep 2025 08:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68A4C4CEE7;
	Thu, 18 Sep 2025 08:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758185824;
	bh=yxVfx5vksXDs9huAM4+ZQ9ZyJNmrE6WNGXBbv/HqT44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIpu3YQaEHDt818JLn/nm2GtOYrzyhdhz83htetfkYXX6SkNWnA27Ed6d7kfqctDl
	 w8vd+J+NGkBYxCi6K5+2x7Gh7Bcoc7wWp7dH25eD+6B2jn3FjZgO7PDND3TotLoy4y
	 4MNePD7xijGTBV9FQWDU0l7IsSF86fJ7V+RC4Ux1FCY1Z/fFE2JsFZWYz5dDMB+g1N
	 TPHf53GH4+yWYDOG7uKDawE9o2N1T+2GiungfCsM8LL4AP/f635yUz+QdiUWjTY5xg
	 yBsXvKT3gJV06lsfFfS/J/I9njYtM04lmqEjq83f6/tphV9MkRWhfiIuX5PT5n0DZC
	 Q0obo36sVHc4A==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Xinyu Zheng <zhengxinyu6@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zouyipeng@huawei.com,
	Hugh Dickins <hughd@google.com>
Subject: Re: [BUG REPORT] mm/damon: softlockup when kdamond walk page with cpu hotplug
Date: Thu, 18 Sep 2025 01:57:00 -0700
Message-Id: <20250918085701.59085-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250918085249.58966-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p1b7eat1x6je6ibgkx6co6miuu3jbics
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B5C3A0007
X-Rspamd-Server: rspam10
X-HE-Tag: 1758185824-342773
X-HE-Meta: U2FsdGVkX19ZzJkPl8GFbR16VXDtykJYAEEK3c3nWPEgPQBSewNjkaAWuxNEYcoKtfoXNeF/2/C512aP+21jxhSM7mORXKBsgigaLFujhmOmMg03+w87z/Is+AAXsYNkLDqVM46dpGYEd+0ugSntiu5sx3tGt2Yx341q+oewvMsTScH2+Q+QxA2/6mAozIv/5uBmMTaavh6gdvx9xt6HNNDncja3rfAjHZm9wMawpB3+k3qIxdcyi1m2ddw5eGkYTN2F9ntwHXvbrb7JfUSJ+a8kyTstbuKZqaotYWH9j4F2vaGzCCirkvracA/XBl85Qlz/6VDeQtGn6ozxqb14fVlV00XUkilthqJTVrlHlaX73BjY3Oztn5BZbqsSKslL9aofcb5SGe5auGslJoM9p2JX3HkFMjad3XkVdWD1gUOfFKNSGh+ekizOSYDooO5NlwUB+pKdBzGVbs6dPVJ/HSiQZx3EoW2Iwl7Sk6YSB/03ljvZaq+fevZMc4obo4cXmHzPwubH8ZwSb7cPBJaaSU1q8Wp+xx0fSrkvmI2zQcEurtCYkI43bLRRH7CTuhYCOnbWz9lp5fUrzcS4YKZizmUWCMEjB3v5T1/KpTBGEhP+6VkI80yPK0derP7aLm0vkCK6vDHZleaZYDJKdiJkkrSo599gsOLqSuKCnvl12YU+liueWk4ai2FDF6pUhH8Rh+PaJDZFDXHNnSBVnaKym5NqsTG5C3LwuaXXocZkRUBvT60tWjEo+kBJ94j6TDW+37bBNvSUdHYS2etoG/Gw3egpAEmoL3ycEcp0OzGS4fYJof30f5/MifdGElkcN9/8czeH2rYThm+ytAtPIgSmQzqoXfvTgnCBz00LXPZF1sx8VJdlrF6BWGVVWrBGRnTJxG9x+YIStH74+uMhhiqvwcckG101ZdEL9rZaSafar0JEqE4E8fmH1+gCOfrVMfBA1Wy1z1NYZg3WcVQUzBM
 uFZdp8yj
 ThRrZgHVvX8j842EuJrqbktHqobrTsHH7WyPw7wdbd72TdDoo5SbwavgLj1xjDLbcgkBKVfvbWPleu5+vzDO8ItBjHxZavG/K8N1BJIQgkv6KIdoi/G+dDelDeKZ+6ahOir2uPfnLzDX5JfaTxnPvVe+7l6uQ/lPw08CyYZ5BR0QqcWtwzRfwAtg+mWpddcrOQOiGy92ErdszyGXOfy+GcNgiuyeM37Hzppbhrj6aqNqj0Ieo7KYMELEknyQCk7mABKNX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Sep 2025 01:52:49 -0700 SeongJae Park <sj@kernel.org> wrote:

> Hello,
> 
> On Thu, 18 Sep 2025 03:00:29 +0000 Xinyu Zheng <zhengxinyu6@huawei.com> wrote:
> 
> > A softlockup issue was found with stress test:
[...]
> damon_mkold_pmd_entry() calls pte_offset_map_lock().  If the call returns an
> error, damon_mkold_pmd_entry() sets walk->action as ACTION_AGAIN, to retry.  If
> the pte_offset_map_lock() continues fails, infinite loop can happen.  I
> understand the loop you mentioned above is this case.
> 
> The error handling (retrying) was introduced by commit 7780d04046a2
> ("mm/pagewalkers: ACTION_AGAIN if pte_offset_map_lock() fails").

I added Hugh to this thread from the original mail of this reply, because he is
the author of the commit.  I should clarified this on the original mail but
forgot saying that, sorry.


Thanks,
SJ

[...]

