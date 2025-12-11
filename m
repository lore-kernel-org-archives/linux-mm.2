Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54A36D3E78F
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 06:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2EF36B0005; Thu, 11 Dec 2025 01:05:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DF146B0007; Thu, 11 Dec 2025 01:05:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5AC6B0008; Thu, 11 Dec 2025 01:05:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 80AC26B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 01:05:55 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01B3989E36
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 06:05:54 +0000 (UTC)
X-FDA: 84206154270.19.812CA87
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4FCB240005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 06:05:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AyntbrJj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765433153; a=rsa-sha256;
	cv=none;
	b=OeAoo90q9AQp1HYY8v6ZMprI0Jq8mTvHfNOuiUQl7H6+i5HRdEo7e2WTZb+jP2kVagWKsj
	1GWgjYC2TLyI3emkN/uMQ++OTOfnI+0zlZajwkheTb+WI5KJPq0HxUuLjLZqB+hBlIwwm6
	I9UVKixfp6QBSY9ny/81nX/9UOQe7hk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AyntbrJj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765433153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tTrSWQLyjAFT4AbE2eV+80Hl4muzdoL2lV9UU0u9274=;
	b=R17YWL8QYaCi6Xxgy0+nsDNuWHZqn4hXJlM8Cg6fQgALTrVBqO9SSIyookg+bjkrIMQSFS
	mRQ8THUrRWSS4eAw3lpdhImeRQb1I0z6/CawphA54mb3mKdNBVdIZ771TEXbgIe+hagfaS
	6ggJKIPuzuGK0GhfVbv/d1BxPhDHbsM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FE8C43EAA;
	Thu, 11 Dec 2025 06:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCD6C4CEFB;
	Thu, 11 Dec 2025 06:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765433152;
	bh=7Gc6odwQPHaTgsU2FCJIBG3liP08oRT8KS4tGYydvqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AyntbrJjb8YdKpboqST7GrJnEjz1l0RDixnpjegtQyFrcq1DiBZtxpOYIXOQuo2Km
	 5BUbRC7NlGoGU+C+K28sd+p23yjMOJ5x3ArgNswVR34QQKUpbWPEin+o+0MTkq/xfH
	 JZkoq69/JS9MHSg81kV3j9I0n9qSndQOT/L4rvrnS685MUg0p7rqggt4Q7TSh9/ak6
	 PRjj5DaNHIkGJbesD1Mqcq1+lbCx1ijvyFrR4QjwkkMwqkJDB0l67f8jEdKR2Ql6Gg
	 /hvVCc0vfr6S5OzHtNuK8/n/oGxw9XFWhDPpLbpLs3x7p+evvD/sxJLfy88hrwIzRt
	 SVGpqanE68U3Q==
From: SeongJae Park <sj@kernel.org>
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev (open list:DAMON),
	linux-mm@kvack.org (open list:DAMON),
	linux-kernel@vger.kernel.org (open list),
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com
Subject: Re: [PATCH v3] mm/damon/sysfs-schemes: Remove outdated TODO in target_nid_store()
Date: Wed, 10 Dec 2025 22:05:48 -0800
Message-ID: <20251211060548.73803-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251211032722.4928-2-swarajgaikwad1925@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FCB240005
X-Rspamd-Server: rspam10
X-Stat-Signature: u9wqh4iw9i9syj34yc4f97ez444a9qpn
X-HE-Tag: 1765433153-565303
X-HE-Meta: U2FsdGVkX19tbToUkhhDIYZvyeEGXgm1WGlOoZBmaRWWDIzG1QjxVnZrV3OOsZIQg6qxPOePbGZnV/3qyxeRav0pm99SEk1UPh+K6xTxEWVv6F8shHt5aLwg58T4V3Ow+g7NEpnBjbVtt88B9O3buEbYN3vTPeXPYmc0pKuHDHSskf8bvnv75rfIAYkEWyzjsHQhU0CTt8StoZp/oHAV8TUVfjao5gESAtf4WHxfksAS8ApXknqiuL7hcOJzakqr07yb/9XDu49SW3KpSajxze4se3Qo+vRs0Wb680p0rdE1221B6L+QNYbVuk1v8lDutQo9pRJ1ngBOE5ePIFHrQXqZRVAzK+EUkqb86m6jA0gdYyXgkNa+mo0BNyNAYNRSL2lcly5WAdoMi2Xh6m1QwlKCiBGm/tgUZuskWRYAnpTZMxI4ZCB2+pehH1XgyA3gf8hAs+Gp0W3V/wWmR5qIBsSyU+dyv2yR4ADZ6oiZH6SMrqP+FDPXFoUG3k/ZMCksfk7MwWeQEhv0dp07niDPlzbXjpnnm+57P8iairstMaFkEjjPP7+gffqyEUT75ml3eByT26pX+yvKx/tkYHg4aI1tSv5FjbQspNAzLNIOenF9yc5ZF5lBH8YIaCPGzwMU9RPKlJ0Cer3uNkpuO6aUwnb+cfuzjduu0upkzhx7P6ZGURsBPi4kwtJYR3/Nrt0gmxKo00H8eAKV6j+9b573HWlWGiAHc5ecbDQCxj11hT2YOcm+1wqBfCNZR4ZLrJo/nXKVoJK1AgiX2JJACVgCdhFE4Wx/vXpbMddjzPzcNEdA18louBe3rnSmexroNfQAE+5XnirERd2zo9HijzrLAlhHqUfMthH8RHVqkKRe5Gm3MhROQ/CsSzh9LejyGR7ELHaPopGyj7kPs5cE330pngI//vbcV2Wdrus7dIFXJVjq90iWinqye0pI9Dost7Q+S/V/oB3YZN4MLOT/GOf
 /8bvO/xL
 EgEVA7FWQbdRiir9a/7y8z8aECKIfS0h3vjFJjUdX31pBfESwZyQijG0WLKWarR/lkbtW2SMB/HHVaSHE1yfk3zGlFmlt6RkYjY9Oam3fOj25J4qN3uTfpkZ5+upPR04tKUPfzEGB87l11iP58zBr+yBXXIKQBddVN6NquPMYbmJOPI6z3R9OYiEUXrZqH0N5m4Py2V4FihP+fqHbN5+EUGyk+GC5KWye7BP757FHq+YL/miL826on/PMy7CBFuMg0Gk8ZyULTCbffFz8YXLE6VBkPqif/qqBzdJvHp1Z8ypM9VHkevVjF9+PFWsGyuQ5heCt8zxt5NHVVWxeB8wdf8+YIr9seVtk1Vue4l1MeGe7I0tEicBD07xSlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025 03:27:22 +0000 Swaraj Gaikwad <swarajgaikwad1925@gmail.com> wrote:

> The TODO comment in target_nid_store() suggested adding range validation
> for target_nid. As discussed in [1], the current behavior of accepting
> any integer value is intentional. DAMON sysfs aims to remain flexible,
> including supporting users who prepare node IDs before future NUMA hotplug
> events.
> 
> Because this behavior matches the broader design philosophy of the DAMON
> sysfs interface, the TODO comment is now misleading. This patch removes the
> comment without introducing any behavioral change.
> 
> No functional changes.
> 
> [1] https://lore.kernel.org/lkml/20251210150930.57679-1-sj@kernel.org/
> 
> Suggested-by: SeongJae Park <sj@kernel.org>
> Reviewed-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>

Looks all good, thank you for doing this, Swaraj!


Thanks,
SJ

[...]

