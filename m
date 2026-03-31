Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30350109B489
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 610A66B008C; Tue, 31 Mar 2026 11:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8756B0095; Tue, 31 Mar 2026 11:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5252D6B0096; Tue, 31 Mar 2026 11:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 418206B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:55:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABDC5E029B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:55:12 +0000 (UTC)
X-FDA: 84606807264.22.B88FB60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 07879C0005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:55:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=smEqOJma;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774972511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2yjpozHBunKkDGh2uqt+UOFslYBBEDGWfFtcIf/cJWM=;
	b=mVaw8hxjdw4VkQnJ6NpVfv3N8Axlo47ruo9LqRXFrxRkhTOLtTL1MhjMCLzzPvCnH6fJnI
	UkKxEeOaikaBk7CfPgRlg9r6GA9UqKKVZdwOxU/IU4wPv9MutK2rQtGRNNq+kvJOIoPRN2
	Lebl8Epqa2QyQ8myJzwOZHadgdknCbs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=smEqOJma;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774972511; a=rsa-sha256;
	cv=none;
	b=MWXWXsHHE30S6L89gCxptexounI5Tjnt/51LpOWlTFAGZQN3yyX+ixUYcJ2TbdP0e+Yamt
	tD9eOcOKeNujlDNZIWbc2nxYQZLwHWWpbJwQ/+/+bkq4OTPJDjVRyAKMHHEg2R1LuPTWC+
	Dr7bWaga9jQi3tTGHybV463zBtUi2yM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C279243892;
	Tue, 31 Mar 2026 15:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCB7C19423;
	Tue, 31 Mar 2026 15:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774972509;
	bh=aDprB0j2xJvFThcBl3Af0grhX/iIzs5DFB/VWB2U/7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smEqOJma4I5FxSVuk1qKqNI84owp9C38/avG+tPtkBmAtprNzYCdqS/r2O8esNOXg
	 S7ZUAnTOcU9x7n3y35chh7HeEXf3o9k0YxpGYBLBNDXdm9abb5mmbMNsobZPYr62B7
	 U1e+C0O6aWIT81qlzRRrb9VewH7+5oVJ40ff4ET8NwyNt2BBSQwcDwh775CFLrA8wM
	 CmFcMeZrjj5W3rtzzaVUpGgnk1ONnohgiLnJVI6zUksTnSlXm5z4hxxvJrBrFrkLvQ
	 ZD60YjKOcD8yNOEXL/WQKcD0+CFDXy8XxPVZMnZUIoTRkDH0FS46KqS18IpBqFGi0Y
	 nRYPgg5zLzi6Q==
From: SeongJae Park <sj@kernel.org>
To: "Theodore Tso" <tytso@mit.edu>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: (sashiko status) [PATCH 0/2] Docs/admin-guide/mm/damon: warn commit_inputs vs other params race
Date: Tue, 31 Mar 2026 08:55:06 -0700
Message-ID: <20260331155507.79720-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331121943.GA74409@macsyma-wired.lan>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ahnrdx3916drs86rgqq5tc45bndfadud
X-Rspamd-Queue-Id: 07879C0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1774972510-580019
X-HE-Meta: U2FsdGVkX1+9P4VSMmZRCEn5zuDNNEWldwd3DfKKoSRRZVmt4b8wSS2QYbhyjP1f8zXgeJ6gzn9wIj+nYsLug3jperUv2saSSFEy7B+9CNgzyFHCR7/xx71PCW2KOOZPGm7+dxDu9o0mZEAbg4hXjLfIBwetjv8wwJF3C1BZIZ2npjUMnMGXfZQRKIyo934RCO9b37xzEISN/BdRX0KNnMUCjuKR+bur6QTao1H1i0jpYy3MnGGTTUP9Oq/C9XKVONq4I756fXg9UI5f9loeuBttb98LnoxBQvRSp2HY1bVpaxSmmqkEvLV4U6zb8pipTm2QWm9WXE7Sd/ggtY0E7YM6raSnSxaCE/uf6rWd8R/SfskmNIVwR9+oOkIlonNR53U/dmalfGFwK87JHox4JzWUYn+vtv8AKrp/ltm/Ha3FpQKXMi6CNQG8XvIVeU1xlhAZ4RstfXlJw1GsaGV45RulA9olmNmKb2XxRCb28LtX7Ew+iScfvf6sVdTK4q93O74WwANaJL092nPWjY5tLs4Dx4GM3w/pNfi2jOI/Zl7f0ydaTURC9ZgE2c9vATpsH7A9OzreniYFNd1RhpC78iZH3LrH3PxX5iLjwiGuEK8ArjYs5gZG2eMaor/xldVLDRFeqNj+WZQOq6tDvZExnY4hbwjmjbcdUgQnoPn23CemZUt2M0dMz+SA13zVnRbCBZnol//Euy4nLtzrJ+/Cx2d/RkZvwTtn25iBMiRCu2CH0rebv7aBHCNyA7J3O6pq+bQiXdaHFkTzmhu9RnlcpBsvphdqysVK9tYKdMnC5CSj/U1ZWynOO+mhsCCB0kCvrlrk26phOIl0sHqib7seoeeZBpMrUOEciX9nWrUJheJbb4TWLx3cS1wEgAF/799kI0jG03EbspbL1ORFo6qPxBKl8g37hXrxR9wsvo60ZD4VF4Kr77JrNDctbL2/yhaDsXD46IvgFNXHPcfn5lp
 CSlU8kjW
 g6JFmarjatRmE8RZPKaK2NJipMb67bHxEeK+LxMO/3GBmWgoNUo+gxMhlJJPx5wBQEw/8dAWMjNkwDkRO2LaqAACX5zas7mrneWe9lA17nzFfhdSLipLvcOOA3YKd/p2wclK4Dwk+LxyWqsssHXq3ZkpWK+uMMpYwD+ccJk1lE/JqlcavpbNWHMHn9EczV88ixA+Zl8RLdnWhkxbl3QH/nCMezGNxrmT29EhOp3PGe123kXhosJQ9g7vs88ba+EcaD7Wr7/5gQRf7Ibz2eZ9Dwo4dNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 08:19:43 -0400 "Theodore Tso" <tytso@mit.edu> wrote:

> On Mon, Mar 30, 2026 at 02:22:05PM -0700, Andrew Morton wrote:
> > 
> > I view Sashiko as primarily an author tool.  Sometimes I call it
> > checkpatch++.  In a better world, author would be able to sort out
> > Sashiko issues before ever sending out the patchset.  But in this
> > world, a public send is needed to obtain that review.
> 
> Note that Sashiko is fully open source and the prompts are available
> in third_party/prompts in the git repo:
> 
> 	https://github.com/sashiko-dev/sashiko
> 
> So people can run it privately, although they will need to provide
> their own LLM credits.

That's unfortunately a barrier to some people.  To me, what makes sashiko
special and different from other AI review tools is the fact that it is
automatically reviewing nearly every kernel patch for free and publicly sharing
the results.


Thanks,
SJ

[...]

