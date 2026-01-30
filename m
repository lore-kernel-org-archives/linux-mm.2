Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C035D73EBA
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 03:38:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 478156B0005; Thu, 29 Jan 2026 22:38:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FB8A6B0089; Thu, 29 Jan 2026 22:38:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3072F6B008A; Thu, 29 Jan 2026 22:38:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2129C6B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:38:54 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 535EE5871C
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:38:53 +0000 (UTC)
X-FDA: 84387223746.28.B43FE25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7AAEC1C0002
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:38:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o+vNnYoK;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769744331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i0hy2STFvDAOLZFnt95zmIQcmb4aCFwsUiotZK26ksI=;
	b=pM/x/QeCHJ6ufoUYrH8Wjc9nGEtKLTICQRKHul2AJpcxIhBzb1UXIehmsvt+RwM2KQaHiI
	NwEJniT4HpPB2/uqsNQTd3T1in0Y7gvHm6qozqpzYD0hHkaTSJD2d6lyA++04OI69ptmbb
	oElwbCtFy4tuueFysWNoT1hC3Qinth8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o+vNnYoK;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769744331; a=rsa-sha256;
	cv=none;
	b=Y2DOVWkqVBstgWXIoBRR2DyAx0H2ZROjbMti7PYGZvbeqKayi1/mW+JOP34dMdmg8D7JZd
	0P5Sazwmh7OdXHM7+P2XpJlW1o7h4DHMm0lz0Uews+P+35lwhrevr2jHNXw2/LC+TDTK5C
	ox8pnA5AHAPXI0jK6OT63FXo1U7sdfg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 57D6540491;
	Fri, 30 Jan 2026 03:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADB5C4CEF7;
	Fri, 30 Jan 2026 03:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769744330;
	bh=PcU4J+1T8KCZw9aj5ccmBmFCCv5uz3Z87kxcvNbBpmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+vNnYoKX83+BZ/wrxS60O9cONAosp/uo1vSJBonytXxClVKjSFgEgx3RfADWJBks
	 AiuKWttCkk6fsIIGrCZvosh4VUoQuiGHiArQU8ObOa5ceZNdDVwFmfAj1C7YKih2nk
	 ihU9jOWvwc9jjvDwuwJDFoasPenrWZ8UioojNaLJtB/BOEYOx9gLWhxwlVEX7nb9QW
	 hU5aNCBij6uzl5MQM0jGgz+GZANhqqb/syOk6DgMz3h8+fTsL158y/4D6dKwP4r7Uf
	 K6fSEei4xoRSPuocW2Pb6Lc2CISLuMMwsI4DGTOsMCWAZqTFKXENHxdKmPCsKvZuVF
	 1RJx1tfeEOFzg==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	sunnanyong@huawei.com,
	Enze Li <lienze@kylinos.cn>
Subject: Re: [PATCH] mm/damon: unify address range representation with damon_addr_range
Date: Thu, 29 Jan 2026 19:38:45 -0800
Message-ID: <20260130033847.52289-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <71e02d8a-94b7-4b9c-877e-5efd4f7aba44@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: qws6i6zrcisqpo4rxpdom6q71wcu6nna
X-Rspam-User: 
X-Rspamd-Queue-Id: 7AAEC1C0002
X-HE-Tag: 1769744331-701637
X-HE-Meta: U2FsdGVkX19G0khOMvWooKYQqZO1MUnylPlJ8XePYJbbDxIwArXQzv/2zVcJhFmjCjTDsAGIN82oUDbeWE28P4u2XD20fmiUt9h0lULrqQhu5w/VL0mRz/du4s+Xo8ZYk/XhBFTqFTCdXsDBSrICZ29u2NTX+WnCR+tabtYlBS3HS+qqWcwDj4zFCi/+vtApNQzNnqHK1Ckjgw86yVu1/xpPKeFjO+Ejl/mYBag7E5BB0V/lW98AnXR2pQ4Tkn+uegHhzny1g2d8Hn0eswEq75Kjz634zVzbcKx5F6qrL3qXtMuXTglR8tTkREuIY5l3e5Jvlxkx4y+A1q2NBcg1o+acoul/uvrzAPpbeeyGgiWbjr9dDsI2vK94pe65tfrQO30zHn0wy2h/IqcNLZoEECC91Qe5wdZfotGGAxl8QMdkVDiAuAIb6/IZCxbs0+nHPOddu1koMMXl1QtDtNRgwUbhVb2TETlDhrgXWRO0/1sSvShdT9DgKj79fY2sVGv1A8CuzO01cbmWKnrGJVJus0E3q8o89+MKqTgYXp5P+DKvsq/hSZ2EiZc4H1uR4QiAKHUcnbWw1aoDWpewdRbbrQq41L1E8q0XWwfvQbyso6cyB64a+1ZMN7pc1nS8mNhA5d58D5fuEACT6+Ddt3VLtb6u/8hxgZ52RBk1QFtdNXj5cYJBX3DcqkiaUG+DYTcmFMkttXYxzkauuQY5V6OkLmcIBNQrFjBrWQ/6xt1Kod0woMrPWNcDfCkwXKC2nnhpE+8WWMc26sVPvTs0R0Cm/gQo56/Nbaur/uVVXIHB4h5OFmzlIAOjEX8jhb/AYUAZ8t6kQgcSaizMNx5FpvstFBkpdhiB2tScKV1DzmNNLl4ZxxVZ0q9pqGzQgtRoB8E9pjHN+ZkKyxvKrHrBqcKovGYvKLFZXRUARPO5doTl4cXPcUB5s8KZ9YK9XV1Ec4jZqT0Smpr7Lpw7lwBY6Jr
 3pexdv9F
 Lufu9babg8eawgtnNFX32gecYwZvczaHjuy+QGApIIg5L9BoinDkErOeHqMzvOrcaUEoDfHoDrpwiCiRC7HmRw83xJYs+vipPwMbe8gs2J4/8La4MN2jW/nQsDTLOJNSuYjX8h8igvAke70GJO7PPs9sQCSjZLC/+eK3woa+VTJLFrs2vYC5Z3p17G4YH5VrtKxNz10PZG0GkWElZhoAUm3rnbaX54x/39et/KGsnClhkFey+jjrNCZ5zaI/Rfj9HfkTn2USBgwKNd+uAvwC+OblaCO24FimJJty1BS4Ny8IGNMsrMM56BL/KTDFEMZu+XYKF95B5E9frhaVyeTvKdQ93dQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Quanmin,

On Fri, 30 Jan 2026 11:07:08 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

Thank you for jumping in and giving great comments!

> 在 2026/1/30 10:26, Quanmin Yan 写道:
> > Hi SJ,
> >
> > [...]
> >
> >> Actually, there is another bug that need to be fixed.  Nonetheless, 
> >> that's
> >> orthogonal to this patch, so it is not a blocker of this patch in my 
> >> opinion.
> >
> > Are you referring to the scenario where, on a 32-bit system with LPAE 
> > support, the biggest System RAM address found exceeds the range of 
> > unsigned long? Actually, DAMON only actively searches for the biggest 
> > System RAM address when the user does not set a monitoring region. In 
> > this case, we always reset addr_unit to 1, which essentially restricts 
> > DAMON’s monitorable address range to 0–UL. Therefore, the described 
> > situation does not occur. For details, please refer to commit [1]. 
> > However, we could perhaps further optimize this by finding any biggest 
> > System RAM address, setting damon_addr_range, and dynamically 
> > adjusting addr_unit. However, there are currently no specific 
> > requirements for this, so this work has been temporarily put on hold. 
> > [1] commit dfc02531f413 ("mm/damon/reclaim: use min_sz_region for core 
> > address alignment when setting regions") Thanks, Quanmin Yan
> >
> > [...] 
> 
> (Sorry there was an issue with my email client. I am resending now.)

No worry!

> 
> Are you referring to the scenario where, on a 32-bit system with LPAE
> support, the biggest System RAM address found exceeds the range of
> unsigned long?

You are right.

> 
> Actually, DAMON only actively searches for the biggest System RAM
> address when the user does not set a monitoring region. In this case,
> we always reset addr_unit to 1, which essentially restricts DAMON’s
> monitorable address range to 0–UL. Therefore, the described situation
> does not occur. For details, please refer to commit [1].

Again, you are correct.  There is no user scenario that can trigger the
problematic situation in the real world.  Nevertheless, assigning
'resource_size_t' value to 'unsigned long' storage makes no sense, so I'm
calling such things a bug.  Not impacting user world, but still a bug is a bug.
In my opinion, all bugs are better to be fixed unless it makes maintenance
overhead increased too much.  Also, who knows if I will introduce another code
calling it with >1 add_unit.

> 
> However, we could perhaps further optimize this by finding any biggest
> System RAM address, setting damon_addr_range, and dynamically adjusting
> addr_unit.

I agree.  I think we can fix the function first, and later consider further
allowing users to use its full power.

> However, there are currently no specific requirements for
> this, so this work has been temporarily put on hold.

You are right.  As long as there is no requirements, there is no reason to
expose the full power to users at the moment.

By the way, one thing that may better to be clear is that I requested you to
make the implementation in this way.  Nobody should be blamed, but if someone
has to be blamed for the current shape of the code, it is only me. :)

> 
> [1] commit dfc02531f413 ("mm/damon/reclaim: use min_sz_region for core
> address alignment when setting regions")


Thanks,
SJ

[...]

