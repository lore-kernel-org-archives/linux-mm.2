Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5635EEA852F
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 22:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E0176B0005; Sun,  8 Mar 2026 18:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98DC76B0089; Sun,  8 Mar 2026 18:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86F266B008A; Sun,  8 Mar 2026 18:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77C126B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 18:57:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1812E8CE57
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 22:57:38 +0000 (UTC)
X-FDA: 84524409396.14.F811EAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 71B3B180007
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 22:57:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l+5HlSG6;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773010656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iBgvvSP27h9yQLAInNEQs4WnLdTvJd5IGiJ/+X2ywA0=;
	b=GBWlzqNVsI3KJ+Q9XVhjXUhJcgP7+qyqwtaiO2zj/xXG+fvlBwXFvmB+T3tQiw7Au6x9f6
	3/vboBj3pT5/X9aaAL5TROLHacJRhrQ/7KXJmSuPY5Trsc5Z/fs4TmkPsX8aWCEnmDuMXJ
	BTyUcwfckwQoSsVHiSQdDzN4G8OFTD8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773010656; a=rsa-sha256;
	cv=none;
	b=C4T3NclqzcbJrA2apMh1/2yTXCGfbyDVZ7K0+h8+668reSdVayZwq45ekzN5P2u/rK4sgt
	w3WpoBR3wVVRTjsv0mo4DaevYw1t4kmqPRFCOzjRB6zu5t8qjcepHgnckAew+3d7pCNm+L
	W2c+ryswcfQ32uigLQxn6z3JnPwdwoc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l+5HlSG6;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A8CC160008;
	Sun,  8 Mar 2026 22:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7D8C116C6;
	Sun,  8 Mar 2026 22:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773010655;
	bh=ZOJ72oPZsRu+xMwquAb+ZZVrruw6imeSEYptHT8O3Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+5HlSG6e94taQUfx8yhbisqeha0oQZ3NyJXNiW4uzmYqOCb1NNym9XzAIbwlQsw2
	 mszbzooN5/3Dh952IevwDmafn4SimCe3vUYLhfNMEwFSaPgy6MMd1SceDxdMv5D8C3
	 TL+/4sIhqzeCuj4BxPgdhXmF4ck6uG1KQN+sUDnHmLA9GqNH9Xp7DU1z8wX2wSjk6a
	 VD+hZuWFis3HvGnn6pB2aKvTZoz7GFDNpEw0pcWxZhmNqAosPG97ZzPOoaKsp6iv7y
	 JZj5AilQm/PnpPt2E9yMTLr1sdHahGG6dWX1sKMwMnnp/i0ohM6BHZGRzKkPZ2qxZg
	 66HGufW9gPDug==
From: SeongJae Park <sj@kernel.org>
To: Jianhui Zhou <jianhuizzzzz@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	jonaszhou@zhaoxin.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mike.kravetz@oracle.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	peterx@redhat.com,
	rppt@kernel.org,
	stable@vger.kernel.org,
	syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/userfaultfd: fix hugetlb fault mutex hash calculation
Date: Sun,  8 Mar 2026 15:57:27 -0700
Message-ID: <20260308225727.77058-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260308134152.6877-1-jianhuizzzzz@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mejyx7cb6mohbrqxa5bwi4y5wbwt43ki
X-Rspam-User: 
X-Rspamd-Queue-Id: 71B3B180007
X-Rspamd-Server: rspam12
X-HE-Tag: 1773010656-762175
X-HE-Meta: U2FsdGVkX1/mAPaxrnXY0uVpcuKZd/c5vG4onmtJbZLIZpgsFzoSvjW0OhhERXFqW3OIcy1OdrMqJMBFDyARdNvjltbmX3daWlY143UAFmE2x5MQLBYx2V6KrajX9FaMAwvOaIGG65vVOo8UtgkRD3bNwvRB8cUoJKHVNJdG4lzzquxpWl0EfQQzCsaqXfJGSfLhwfq3V8kXjv0G3sfcgQc8LleNFZiO4W+4/o20grA6x9Oi6+ECkgFU7k96L5upunMb8p+H4JUnEa3FetQfzwqec4iJecwJCszDfRuvuU3RX5NP37pCy/aBsBSkgM86Pi92YxwD7nd+5yiBgMZAu9Zaga9oZhsZX4VI4U9YNEh7VLg6eqOD+Y7O6DQc+WRHhchQgXM8HfKOjOxXTUMQ3ysnb4QnSMQTBoFY2Amq87f7Ss0GptF4qpbkOMptPRQLwWwIMiUAvBv4G6aJC0pm7XeH42edJaxO8U1xLtK61T1PokUE+mYS2QQPXNRDeHsmhPBuHY6RjN/HCkNUaGvl7ETJ/KfS4M7B9AGHUaW4Ao+lbU9/Wj6N4cKl2933cFOg3Liu9DiVwO4hvvEf13FNJuUsnUsuCBR/I0l2ZOwNpZXrmvF+FpZgx7sjPOejBiEbdKck4uGxXqcAflVoRyWrX/DG4ZLiDOQyOWUihEXeSIfYq1Cp1PdGf7fPoogCpdLK5KQNJ3Za1qmw+M8XaRUYjAqf7csYZNiXABjPx4SVJG5rp8lGBGbjdm422vIrGSBVFQJWyU/anD8Prkz20OaaPTq0CoG3BgIOC3MyKmkwPkwxHiZSk+SZZH3oUaVSyTa+ucPit1Tysh+vaYELsKaZu5U1Ht7zT0DaFSzsQj6EG50R7zEHt7Gd55B8DKswZmM3Wen+CJ/H03K15fbO5k+YDs5X5t4r2DpJuEuFc1EdoPqv/McGXwALYSz7RecOaFgratiAydr0en2q1S359O1
 eVcK5cCF
 9oQrwXYcWsZDOl7SqpeJpyLMQCaYvksMDo14Svxu5iEM8ZFnP7J0D1V0AfwQUnuFoytNqlJiftw1Y8r+g+tx6j2gj+JOessHzpGMD1t99vjbNTSofykNR+d4S1k2Ow52Oi2UVregadjfSjlT/M76AhTaOuZ4hzR97VBtZ6Qv5XGE6I5EuPv+dAlE/Czxu7kn8BV7WNHDi47SKVOgM0zoLbN1dC5FCVnar3JQihOzavEOuIzFRGcTmqBkTrTNH8rcfDVHy47G/2in8fJv1C1cNqQQDEh1WYUGhdkLoneBMuFX4mzSj1m2vzuRIoTV5IaLYTcPmoZegi4s0EA0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  8 Mar 2026 21:41:51 +0800 Jianhui Zhou <jianhuizzzzz@gmail.com> wrote:

> On Fri, Mar 07, 2026 at 03:27:00AM +0000, SeongJae Park wrote:
> > I just found this patch makes UML build fails as below.
> >
> >     ../include/linux/hugetlb.h:1214:16: error: implicit declaration of
> >     function 'linear_page_index' [-Wimplicit-function-declaration]
> 
> Thanks for catching this! As Peter pointed out, the
> !CONFIG_HUGETLB_PAGE stub is actually unnecessary since
> mfill_atomic_hugetlb() is only compiled when CONFIG_HUGETLB_PAGE is
> enabled. I have removed it in v2, which also fixes this build error.

Makes sense, thank you for the kind update, Jianhui!

I also confirmed mm-new that updated with the v2 doesn't cause the build error.


Thanks,
SJ

[...]

