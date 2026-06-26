Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F239C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 14:24:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CDCE6B009B; Fri, 26 Jun 2026 10:24:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A55E6B009D; Fri, 26 Jun 2026 10:24:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BD236B009E; Fri, 26 Jun 2026 10:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14D916B009B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:24:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 907F08E03D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:24:01 +0000 (UTC)
X-FDA: 84922283082.23.BB22E13
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf30.hostedemail.com (Postfix) with ESMTP id E3C738000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:23:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=uHabhH9I;
	spf=pass (imf30.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782483840;
	b=0q5zXnE7/F0twkaBtaHZ/cpuwUcABigLEcxyTgcHLsHsootheYfd+e0UQ0I4Gj4DSbggko
	xQoX1t7Y9LpXRDjHdvBjEyCmL94B7SrvMuEwEoXJFBDyvjZQGs3sU6qbUHQpznKPEJRSEM
	/FsvhAxB0xf8Y9fUTJNwPf1lraYxRc0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782483840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GnX817I9Dn5YTTh2YnnLw/KGmBvjVUzH+Qx51nCzAQ4=;
	b=GgZdVhv7btDor2OkQj7035wjFus+SYwsoYEQN66yby0ht+wq9adwz53PMELJLRRl8ub9FB
	Kml6kwMigM8e/wXZA+FoEhjtnksku7P+cWwS+3Y01uER63uwPXGl86JEdYNGM/uGgesf1b
	Rj314IcSgGCR6yDT6dGcq50K0rWdK+4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=uHabhH9I;
	spf=pass (imf30.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GnX817I9Dn5YTTh2YnnLw/KGmBvjVUzH+Qx51nCzAQ4=; b=uHabhH9I316qhbMCfxGzmP2TIC
	9m6XaBd276OkV8dmxvQelKHMdkmB5WsEuAOm/WnOkBD7tUUWiYSKb0PNq1FBebLAG+kE9kZuaebES
	rYXcumoGRLjHBVxJW7vZRmrQxugV23OimSmn+Mts0EraNRGWhvbL6kvjYQ7JwqA+J08atLVM40DAO
	b7V0e/OjI01LNSSUvWWPpU7D6M+7LcDeavirD7KIBSsHlXzrV2CspO3eng8wu6wkfhkeENmXBnpfP
	f6p0ss+g19B8nXdzwEj0LMplm5B3q6BXDUprHTUpPkZ9tZJ4mBzJWRf+BteMwlWIUomyp5HJ1LHlI
	OiO98WRg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wd7TE-0041xv-1W;
	Fri, 26 Jun 2026 14:23:52 +0000
Date: Fri, 26 Jun 2026 07:23:47 -0700
From: Breno Leitao <leitao@debian.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcg: initialize *locked in memcg1_oom_prepare()
 stub
Message-ID: <aj6LKHe0ONwelBmI@gmail.com>
References: <20260626-memcg-oom-uninit-locked-v1-1-a00175936b39@debian.org>
 <20260626135612.3697893-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626135612.3697893-1-joshua.hahnjy@gmail.com>
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: 4pjmqzmdunf1wmzmnwrwa8asanpwgb63
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E3C738000B
X-HE-Tag: 1782483839-898663
X-HE-Meta: U2FsdGVkX1/h1jUNPJ35Q2LYTAboKo2UgLbDpF7LPFb8ML+Wo0jpNu7eemWpSZ2US4pAVDPQT9WpfgUYs4jvCAnaZb63/AVyryhbAyaGZVtQLmgnXWy/j6+MTV3byDbA1iIPecP6IykAL5Cx2NB9BjH8dn03mmB0ujVkVfczqoYJ+ljaHlfaoFb2NMNkVnOUVywEL/co9T0mBSii91uCmPJY6sVWO9McqUWt23311Y3GX0efQYnVRrBOIfvg0SPW+wygKW8lYTjDHgvvENKzpVY5oNqbO+KKvzwerRw6Uk+FtXaBrKEv3g56H1QvAuY7ZZTRENjdcsUvaw7oXnudDB171N7qtr4e0y4HF0KxUMBD5PCouXvAEJZzHwqjutCVg2PyqO7UfLZGq0HPdrj3Cm4BMSIO7HvRK42ReovRDnoFSVR0K6CZVSBxD8Ols9JDs2CqpYUW0JWuBnfUaiGDqL4gwkq1lE9FuAVfZsx24kjYHXtCObTcpa9d8Ji42OvI5JRwuGmNSyCJK7ycfJvyJnO2AjPP1gHu9GTMSKMq2ljbYRgKDpJcHCwEFL6z33S/ZgY6UqiJ5GAsx8pe0TKkIGiZxW/NfyrZYKMl+F1y0PquPwfyZEcMyHDAfYDo3hZAtur3V6W+cjxfYhpz8Gmm1NSmwStl+r5w9OkvjTJIpNlku1w9TgVTUiauZhYlbFFl+yvLkeVfanpoP5fBHeTBOJORHcF9pbUsaXd1EOj001AjWc5gEU9LNk3lUqO3x/9vXUqY0Kq2mKPyqXxSChe2O7CDAaJm56GPyx2FxuksZ8VjiFXn8/vBTUGfBtVU5tLa4iM2VhJ3h8cELnAY6rFt+f3S7+iuJp/sxCyc8c/jVL+qAf5jh4vcGn+5GaxUX7vT0rC5Rh4JQpf/1cJsSQD4ONKh8wQJDXLXjxSCZvBpM3WnHDm+1wDyrgPr5N5tCtPp0gAHlFns0VDrNSTnh1S
 hxZaF2u3
 DSOZiBbNyoNAY6Op0Y1O+HiQ/6aAim+R2mOukOMHLm+kX3yZpS91UGQeEjWsspU0BuP3U0c4wga9OUc5XMi60rad6C335IMFsgwLHLgBn1mExnYYg6QteTDGppXJE5PGEodKGaoiuNnTusX1/ANG57n2HBbdkd72QE1V3CgVthKkzmMl+pByhZ5bHPu6IuLW65WOH9mCewB07eJ4isak3jd55zMSZFQUstEZAsgf/IHtyUpL8sS+NZDwsxS1z3CiGdWPmA1X5aL9d+tLxeXed6/mh68lmFPm+96omFEbiEexFBYbBGTxmWfpIFjdiz25fy2lIQAP372BRGB6vNTDM6yOMT+/jV/6UCqT9sBpkohHy8ZEUp38NU+oKdJe7p9D1EEniHmFupVduaJchGnwoh8VOxv7EIUfF0hqfGBYync91MPtwZNi2++FeNwtqVTnVaMTk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Joshua,

On Fri, Jun 26, 2026 at 06:56:11AM -0700, Joshua Hahn wrote:
> Part of me wonders if we should just initialize locked = false in the
> caller (mem_cgroup_oom) as to not make the stub have side effects,
> but your chnage looks correct and this is a fix so perhaps that is
> not so important.

Nice, your approach seems to be even better than my silly one. I will
wait for further review and respin with your approach.

Thanks,
--breno

