Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B709CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 18:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E1CE8E0066; Mon, 25 Aug 2025 14:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891938E0038; Mon, 25 Aug 2025 14:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77FF38E0066; Mon, 25 Aug 2025 14:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61EA58E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:57:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 167B61604F6
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 18:57:46 +0000 (UTC)
X-FDA: 83816188932.27.41F608B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8122C1C0010
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 18:57:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r3Zra8lO;
	spf=pass (imf21.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756148264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5lC+bv9TUZNrtVC1TMb2PhLOkLr3TYdwIbH/7JgUAI=;
	b=kR6uJ5pxyCs4L6PQTnuLgPp66Wo+A6A5r2cKxNe05zdlu4MHsptXgCei9zrO8Mr7Esvz+f
	rRoq6SyyQM+EffwdUCKRTsvoO/oOXA/0x9VNbB4vUjxrBs/UEp6o7+DQqjIHzTPi2PpG+u
	AHI6ZS11aILX34xRAkQMn84yBWRYwHg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r3Zra8lO;
	spf=pass (imf21.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756148264; a=rsa-sha256;
	cv=none;
	b=096RUmyczid+thYt+FOkSIurATNsiq2QW8N88rROLULd6mOC20H3apT5U2g/CQh3ZKFKPb
	RnmtLk+5DHGO4+7nNlSRxTf/pjp5w20HesSe5qAu2i8xs5nqQqqkwVpgozl+pCJeBvnSH5
	szP+662QqgZJDSPwAvp6wzVSZS2H3sE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9184460244;
	Mon, 25 Aug 2025 18:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B45CC4CEED;
	Mon, 25 Aug 2025 18:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756148263;
	bh=/mJuxFdTQE1L3kaxSOXwl3RZpWFZMZRe4dIbwAoXMw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r3Zra8lOZKgIjBJAZ9oshWQ4h1NZkRdzLLTmgjirzNyb2s2rvUHH8ZsxXGOcxkmBg
	 l5OTGIYXD6RzAbEy3AUB4IdjFKwIY5JIVCY6ajUuTTNGlH7QXTlHSuDJDY7S+0Vxm8
	 xzLeHdw3+wVPDja1Hkr6nZsYUHXz9oHIxoJG9YXxc1LJtucNcgvJMqqZtReMFxMwMa
	 u77/7wFPGSsaGzw6Iz5vFe66d31IiwkuMfMjjINSauymNiypQ2QrJG2usbFwkOgOh+
	 8OzG8sn5q51Di3y8G7106ttIJIwLge+7AMSW90DgZZzTpY7SC1I961CacfxomhlRYE
	 9hUReuldZfkzg==
Date: Mon, 25 Aug 2025 08:57:41 -1000
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Julian Sun <sunjunchao@bytedance.com>, linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, axboe@kernel.dk
Subject: Re: [External] Re: [PATCH] memcg: Don't wait writeback completion
 when release memcg.
Message-ID: <aKyyJZOwdJ6CNNjg@slm.duckdns.org>
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
 <20250820111940.4105766-4-sunjunchao@bytedance.com>
 <aKY2-sTc5qQmdea4@slm.duckdns.org>
 <CAHSKhtf--qn3TH3LFMrwqb-Nng2ABwV2gOX0PyAerd7h612X5Q@mail.gmail.com>
 <lvycz43vcro2cwjun4tswjv67tz5sg4tans3hragwils3gvnbh@hxbjk6x6v5zk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lvycz43vcro2cwjun4tswjv67tz5sg4tans3hragwils3gvnbh@hxbjk6x6v5zk>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8122C1C0010
X-Stat-Signature: kjf65q839ikf9ytcb5d1qu3fgfx438p3
X-Rspam-User: 
X-HE-Tag: 1756148264-908364
X-HE-Meta: U2FsdGVkX1/H5cq7l0ChWZ1JaY3s3DYuQ4BuDNAdnt7AjpClcqDvojS8AFOqLaiWNZridB1WkJeDV9I0OHn5yGqf2i3K2Hhwma5RCC0Hysqc4G9sCCTNpCh2TRGR+B4WY2P5QSK6g78Mt371G+G+iLqRhB57IFdod4UviJCcvFZsMPSEBJAZhP61Vj01fClMKqgiqoHOBeKIGK8GqXbNMfcEx/KpDgq88VuSG5EhyvEuYOJ86YIOu5rRHEXr2sj1BsxIpzxdHmb7khcTmC0pMUIVwDvqFVkXMvoOgB7MY9uKP1J3nYmJISvnZIAcbnUwoNrsMMsc53kBGZuzIr0WgkyDlbiD9vdwKUoLFUQdtqURpetiI8hni7a7aEiZsivGS+GGgGKAJnnys1EbBVdY++blToLrfDyBALxQ/5lMSqknVssUm2fNXJWOISxfraJCsUFX6pYotYuogjAvH1dI5PuOEWAu6xbxAj1y/ArXI5TrN2GM6XkCQ4t6wCNLgqyNQ7nXzk2M3qUBcgNMJoK89O7UsFB6EvQlitrasBKfRYT3fduSi3dch870mnL+Wngg7bitBBx7wTnEA8d4CnCmxTCPj7aXqGdSBSVYO2d7xwSWHnadeeKFFt2wYLERatS/nwK+mytZByy+3jzJk/PLV72nM5lR5YvL6nB3kiT84b5X5vwc+vxGT/3y2tdIxgisa/m1E9fnxERzR5vXL6GNnlYtKQ7b+9FmS7TSc3SKlsrXbO82z48NCPxl3pDn4dt5SFGXf3E+jdsUC66Z6CMhxa8IKbMNmsSWLt5Q2eG2z3CIjr5VwWB+RlzjD5S5Nqo05QeXcx8GnSTgfg9o37xwv0cUWMZTgYVus3BEgt68DOoW2WwFzTA6PocTSChhnWMPttZP+dufbQM6xQtSz8tPcUxnww9KTOgn173h8QreW3f2yG5pv+wQxEueQiI10lJWkBWJosfjU1Dby10pQw3
 pg4zZh7A
 WPkGifqMUsHRn1ud4uquBM53gryiYue+rfJrjaKqG9U/tHMoa6jduJNy++NEcGUevRSNiY8BXIGaxtlkPQvMT9miuJyrqvy0CoIxCtRuIlb71N87xtEegpfb1olgKJ0CJ/aAO3y5deSljlM35iC0b/r6tg1DVkFRxQIRLb32K8QfN5juFWszYcGZvYIWiXr813tVCxE0+FmZcppU6f2+YjrlT7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Mon, Aug 25, 2025 at 12:13:53PM +0200, Jan Kara wrote:
> True, but is that mechanism really needed? Given the approximate nature of
> foreign flushing, couldn't we just always replace the oldest foreign entry
> regardless of whether the writeback is running or not? I didn't give too
> deep thought to this but from a quick look this should work just fine...

Maybe, it's a bit difficult to predict. The thing was built to work around
real cases of problem and FWIW we haven't heard of similar issues
afterwards. Given the peculiarity and subtlety of the problem, I wonder
keeping the behavior unchanged, if reasonably possible, is an easier path to
follow here.

Thanks.

-- 
tejun

