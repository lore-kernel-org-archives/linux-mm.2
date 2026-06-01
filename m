Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D00A5CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:55:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CE576B03ED; Mon,  1 Jun 2026 10:55:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158056B03EF; Mon,  1 Jun 2026 10:55:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06E346B03F0; Mon,  1 Jun 2026 10:55:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E67466B03ED
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:55:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC82B1C0C2B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:55:07 +0000 (UTC)
X-FDA: 84831641454.26.690BB19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1FB674000E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:55:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dWA01ekr;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780325706;
	b=gPIRmLYVSIrlROWeFns7JP/hIf1x8o7GOPA6JYHLGX7HHeEAtk4kT4wtbwkdtXGH56BzTJ
	ftm9QB7ukPNcBU6ASnLgHyclu+jzQ5Oq2zUMfhvkx+nXtqJCPDPq7QSAmrLsnynWM/8uK1
	dT9MUd3oE0ZMqZha2xLf1SPWSTIbwE8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dWA01ekr;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780325706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XG5RfpJwti7dylwLwxXSrJ1QM98QSD9PaVrRVudv0Hs=;
	b=kTUAvKHzApenGlYoJkPZpIfRkbe8yv0XJNK9RK81jcZzvhzAV7oVokljZ94LFx/qseBJyf
	/R2okYIC1qB+EZNZG0i/IE7Lo454nHZDkEGgOiJU3pliDK81NZxSM4xBA8Zpsi0AN+KLuZ
	x1l6Yg9BDEzq7O25cbQ5BvMf6Q7r4ZY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 42EE242DFE;
	Mon,  1 Jun 2026 14:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB751F00893;
	Mon,  1 Jun 2026 14:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780325705;
	bh=XG5RfpJwti7dylwLwxXSrJ1QM98QSD9PaVrRVudv0Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWA01ekriVpl9LuiMtnhLBxVRpoAQnrdChloT38CbGJDV3n46PNj9lXgod7r7P1TR
	 vQr2c7hP3Stey87+7vLgfxaJ/wkIuejsS8ukh+QSf9PPPc2fWoZ/5ruLFKkjHjomyG
	 7YvvnFHrNssF9j31/K3Pvfi97TIV+gUiIDHQFeprTz+DFnSDwRX06x+qPEPn1goxFW
	 7PwV4gJLoWq86CSywNOXMq2Tf9/vgQNtlwOgFPHxOEvdTqfkZb23MwWCrC0ScUl/uL
	 4KqIiRiTTV9t+z/dqXuehSsauPWhwHy4sLZTByGhnifdJvJ6QEsIm9FVf9zfp0LQpB
	 I26fQQqcCx6Eg==
From: SeongJae Park <sj@kernel.org>
To: Cheng Nie <niecheng1@uniontech.com>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 0/2] selftests/damon: fix memcg_path staging handling
Date: Mon,  1 Jun 2026 07:55:00 -0700
Message-ID: <20260601145501.116884-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <7E6EAB7C1BE04DEA+20260601090119.238457-1-niecheng1@uniontech.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1FB674000E
X-Stat-Signature: jubxbcrsm43h9b4b8wbp5ypew9rei61t
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780325705-272311
X-HE-Meta: U2FsdGVkX18OE5F10KPZLDSK0ZgfWbwnpczsi54GQtN/KuFyHM3j/suKwLjHlWUBo+6MBFbeQfs9o6HwB3L7fv1BssEVtvIuH3Xt6zeWogWl4xeZrNU5iGc4IvYnFsbWZ2gBElxwsArp6oVKXzKBGVj77BHZUsywCQ54qq2JNggmFhQusRXbS/3jclzAh7C04jJwEv7Ng/Ny+kGaIw0kslKs9xq8sRAeJUa9JmbS868c8HbgfNqrx3NlmpmT06tusTAijUUVc4TiNt1cIhHG0PhaVg5rk4wOB1xg7h6ikw0Y3NmQL9MOHpYJRXimDZGjV1Gj5bxir2ln7nJy0jKi2p4E/oo49E4ivEiyb6R7sNQ+cF/2V2/PVkHQcoFzt1Hep3wgiIIhpCXlyrhWniiP+7HJeV5o6kbkjQZKkSXYR2vwE9+tD3LGbcS0y4+yA6tlYi7/6VyDwBKJhYDRoPI50K+fmsd3bi33oLSLKhyUczJRKy0oJvqEHy9eKhPisESS0/Fzd+GGyMVvSByGJTmcqOhguTONS0/RtAdtnB/GXGo42YkztaRcummb1oUWkbfO/qL5f3iHi9ygfpdCuW88LQbw2j93wxwmRLqiMpMxHTldsUqAaQbkyk3eO2x0D0e6wkiAJvl7pEmhBudUfI46eRqMye7d4OPAW5uWL2UzR2vfGkE4zLiFVRCKphS8Xciqp/VERRZcZ8KLdqtyjn/j8LVfRJj4saujFirklrk+lCj2TH03wjJKIZJo4aMtmS6vMlGX2UrYakJyOCLlLd7u+OMO7MXY6Cq0EVU+Xhs03l8ogoOjSMmoFqIzqXMpd9hxGKCkgxLD17kwfTyflJlQCPlNHBpe5gMxp5jKE+KYP4zuJFq8jb+BBsQob7U+h+Q2MKUXcahnH+dAsEz5+HmJGWr0nCn8RCEojr81CpJqskXuY1jegOgsdeuG7KHTFVwEXkqstVr15Y91p55BM/s
 5X5R0iuN
 XlRnTHz1DhTykVaB9IwZ7dHf5LolJTWfEFLV6c9fFcF8fL9guZ/9zBDPn8d9Z+qG8L3q2t+5dDZ1gEkJvbQkC9lecGPAvmQRjl1tVfFoczwUkXthxJ5LwgSAZMEiAlQx6Z4ZFuWREc04ayIx9OTjxY6a/tMUkM1ZhA6hFok5LIVugVXbIYEGSid8pmGaDMgcy3ewMys4cT6ZVz5mcoXsOky3vM7B9ID7x2Jp/VQdwMMgwO0cKnAAICFYku8Whhqzbn3HUoI61A07uhfgGChnnxbKTxIqay2RltzXmlccbDxlvhqziEt+2qSYXoyW9pj8kc8ISH7xkGiBBgHtR8aRBek+iy57bY1UH7d1aRbjHtYAEw3RCI4mAW80wnvDmTML7F80C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Jun 2026 17:01:19 +0800 Cheng Nie <niecheng1@uniontech.com> wrote:

Having a sentence for the cover letter would be nice.  E.g.,

'''
Fix a bug in _damon_sysfs.py for damos_filter memcg_path setup, and add a test
case of it in sysfs.py.
'''

> Changes from v3:
> - call stop() for cleanup without checking its return value
> 
> Changes from v2:
> - configure memcg filter before start(), remove commit(), ignore
>   start() failure, verify memcg_path staging readback only
> - use print-style error messages as suggested
> 
> Cheng Nie (2):
>   selftests/damon/_damon_sysfs.py: fix memcg_path assignment
>   selftests/damon/sysfs.py: validate memcg_path staging readback

From the next time, please add links to the previous revisions [1].

For other readers,
v3: https://lore.kernel.org/E4B88E7D4879D1B1+20260601074250.203583-1-niecheng1@uniontech.com
v2: https://lore.kernel.org/4CDA28DC581FDCF8+20260529090845.1696845-1-niecheng1@uniontech.com
v1: https://lore.kernel.org/406BD1BA0F6AE326+20260528081039.1192194-3-niecheng1@uniontech.com

I applied this series with the cover letter sentence change to damon/next [2]
tree.  If this patch is not added to mm.git in short term (~1 week?), I will
ask mm.git maintainer (Andrew Morton) to pick this.

Andrew might want us to repost this series after next rc1, though, as we are
apparently wanting to make mm.git more stabilized at this point.  Andrew, pleae
let me know if so.

So, no action from your side is needed for now.  If it seems I also forgot
doing that or you cannot wait for my action, please feel free to directly ask
that to Andrew.

[1] https://docs.kernel.org/process/submitting-patches.html#commentary
[2] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

