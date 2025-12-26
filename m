Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5560AE8FDAC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 18:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88226B0005; Fri, 26 Dec 2025 13:23:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36D06B0089; Fri, 26 Dec 2025 13:23:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17336B008A; Fri, 26 Dec 2025 13:23:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DDA76B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 13:23:34 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E0FFB5795
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:23:34 +0000 (UTC)
X-FDA: 84262445148.25.E0F97EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4C50F80003
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:23:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z/IHzxXH";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766773411; a=rsa-sha256;
	cv=none;
	b=XvhefuVEAZW32YEFcDeZnEPimthVZt/JtYevWVDadRe/NA777Mtp8AxmwqdsU8vDi53fHE
	CukA62zOsNIs02PaundOUo9mt2Bz+T8GlmKQv9ShrQzMoGU9KtTTcDLB1BjeOPQdw3AJ7z
	KKhR1aSt/jA8dX/14s/7lxK2ohvfn+s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z/IHzxXH";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766773411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBVMACEPDC6pxjczPyO3DCqeAuzhV4taZSHJvGF9Kv0=;
	b=dqgDXiBV/jcjQJQWAQt8madQYc2GU9q4sa58xH9HRwAJe/9NJszL5BK/LEfEhl0HtjdIIT
	rPgLOIPGUh6Sw977Bodh+Za/QpZU/38LAJ82zIeMMaxijIcHh12swEVF3guwJPilbSrK2b
	7QFc3pHXVsWpnX5AF1M2lX3W+vF6uYg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 60473404E1;
	Fri, 26 Dec 2025 18:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D31C4CEF7;
	Fri, 26 Dec 2025 18:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766773410;
	bh=HKcf/FrOo4r2cMlrWajIA+xBQq8QQv76rSIhHCh2EJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/IHzxXH0B7ux0EIk0mXpM6cPMguYKa7IUt+jRIU4GIz0LS+Qw8urBxuTDlTpU54T
	 BU7UYOmb5ZoWgCrmRBIQ1tcMS+8rF7DVUvE2rhqXVZMae/nwsULIzmufuF1bopu3kb
	 goVEpP/+rLAysWLn3VeeBdogwLdn00a99eRbg5UV/lz6TUqaxwn1cvIGHBk6d742kH
	 FPMhP9GP7G/bRk95d9WnAyAgSKtJIlHuneBWPucQq543kS9Psyt2FgYz0S+4FGJzY4
	 2cbNep2RrbxwwYOb1HCntZcMHlYLK+mWfQXGDcY2icILBgXktEooQdfLrgnXqUe21c
	 GT5CbpYsGtTQQ==
From: SeongJae Park <sj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] mm/damon: use cgroup ID instead of private memcg ID
Date: Fri, 26 Dec 2025 10:23:16 -0800
Message-ID: <20251226182320.254424-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251225232116.294540-6-shakeel.butt@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C50F80003
X-Rspamd-Server: rspam04
X-Stat-Signature: uiyqpi9a8i4zrfp48niq3a5d31xbnzwy
X-HE-Tag: 1766773411-865984
X-HE-Meta: U2FsdGVkX19t8f4edFjKHgFNx3F9KRnx4ZarHkw3mj5/GyFY9TLJ+0mraIunm82j2wvKJeJmVOIgmzjAr3pPcVvag3GvKXouTp8cic8AMbwOm+JjxV18buXw8TLCUpt6S2HvHRPRJyO3R/uIsfrC3+pN1ny6Zk7EZrujKGMi6PubIk3xiyn2gMDwEy+C8fbZf1RVZEQGIFSmrU1HgiOuCKmXXmxAGQTX9R/GOgZmqDQ0sf1LCGuJHdF2lg9HHAYoUX/MSbvGrWEOMovVFz8gQUX6GoaRQb/ti8Mf04TLU15B4R35opLFyxV+HAvXtqRNPmU5gGYWn0tI9WZSPQ/uXKAmbBH4VhteCrLcP/EZOO0XcOmMt7AEmO0OdJNumk+fF5RRLSu4j5m2NIlWrGxJ9LOOvwcwjUuYOuZ/eVIrFgX841v5BDYZxDzVNP1x703vrfeK3BqS5BYWewW+usuFXw65L9cx32owVSoCXNaDJUeLahU2vQBsNJdW0u/48nAoM0zYHcKtr4lXEP3e3VSgC68BwhqFeqw0ARJOZuwsu+z1iivWzGM7LiI1B+N8122Odwnbv34gzrSW3GDNqOgcY33oCv/pLkjoQm/YX/YmEcAEMB0Gy8JltehWJ3IhOl/xdoG8TXfHMsJkKza1QeM1YRpCVxtRSO73wVVORAINRjZf1En/Hj4tKXxnJGCGK4KL6xSfQlWbXCbSmWEemNpx5A8mYTmhSndthMJ+JPq+UJSsmhhQ7Tsf8Q0Jx4+uzS4xhARdqb9USE7rkiCbDwNWF9ftBqAjF6KUOmfVgNyvAL+9hpbLUXM0qzFZeBtkXhsCH2lficiI3/pYzZLltB3YpvTiDjJMygifcY0vZUsE5GVBi40aRfZhWahRZmIdn2qhTjjnJsqSYmkvDerGOYC1D4QH6b4vYlyJa3cNUKwdEZ6XnFpfHgsTPPLRbUZzSqqNBHKgUPxOaN7f8sCXcPR
 RdPf2Pfy
 GIrctVHZ+lk3FgMNcy9eSmgg+4WrHNTGiO/ORH65mmIUqfgdZUivHvQSevvgVR2GXWmIqmcc2L6HirJ/wtzEQQ+NDH18hlWNvr+P+KOU+83QoaOgZpIlu2lQOWu0rC8Gt4q1586VPygpC9ZPISkiFRru6cZfQNgOSa0R+zDl+IDEXQdTw8fS4U4Ab2M+3ydso1M1gIe2KJRIt02SEqzCHrrK5IrND0PJ+Aqq6ZamwCujAQ7Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Dec 2025 15:21:13 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> DAMON was using the internal private memcg ID which is meant for
> tracking kernel objects that outlive their cgroup. Switch to using the
> public cgroup ID instead.

Thank you for catching and fixing this!

> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

