Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FB02F532CA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 03:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B9816B0089; Mon, 23 Mar 2026 23:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46A8D6B008A; Mon, 23 Mar 2026 23:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 380726B008C; Mon, 23 Mar 2026 23:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 202516B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:03:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B103E8DDDB
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 03:03:36 +0000 (UTC)
X-FDA: 84579461232.20.6503DF9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E217F4000E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 03:03:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VItKk1Lt;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774321415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OmOVXPe1Nlvds8Orb8qTL2BbAKCb1vf8/bP6nts1Yt8=;
	b=DI0S6uabTmATJjuQpaNwPgHq2ROO5v98ycU40uEzzDZyugVASZQVsvAHBfD9Y2+15Y+v8L
	j+KyGzM/Tm/jDxDU9QDsJ7jcsn031+F7hdOCiAmqp3RuFjt8QEj+f0IcnEn5e3OvQLkXLu
	OWguaw+hFREUkR0S0k4SJqrHcMhzrrg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774321415; a=rsa-sha256;
	cv=none;
	b=r0qYBk3BprZuGObvmvnP7pwBIzgs3QyFZzp1ixxusz7REO/C+NGtGxGpKE1eBmFj0SvLTZ
	BAu1yL1n2kMEUqkGOvusGehXjTlNDlGF7I37838ZrIiYRF7y0BN8cboqpPkIp542Oj/G2i
	SkyoZ92hjxEAxRLNEXsCcyxB9B4yPEk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VItKk1Lt;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 92417440AC;
	Tue, 24 Mar 2026 03:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F343C4CEF7;
	Tue, 24 Mar 2026 03:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774321413;
	bh=mbffRXJqfeHte+9FqyeO0hvUKNPE3a2bHTWGX7bo13U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VItKk1LtX/WIJFoGz5ssYX377NIxD1Yoj+OYROfdFqcpdSijoq+VkKNbeENZHQsLK
	 i8oVDm7ZHyW6hA1yc8Vehd8FtA84/5Hq8X97dym8BqYYWk6f+TLeV3iELU2W6dTLeN
	 EnHJmcK2mVB7X759JaPwYtbBI+1zGhHU1qRkXnko=
Date: Mon, 23 Mar 2026 20:03:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: YoungJun Park <youngjun.park@lge.com>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Pavel Machek <pavel@kernel.org>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Usama Arif
 <usama.arif@linux.dev>, linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v8 0/2] mm/swap, PM: hibernate: fix swapoff race in
 uswsusp by pinning swap device
Message-Id: <20260323200332.75962255d46fd06be3a23511@linux-foundation.org>
In-Reply-To: <acH8IKWyv9gW9YFU@yjaykim-PowerEdge-T330>
References: <20260323160822.1409904-1-youngjun.park@lge.com>
	<20260323154833.045b732a5865b11b5b4e539e@linux-foundation.org>
	<acH8IKWyv9gW9YFU@yjaykim-PowerEdge-T330>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: o5hc37c1u6crzd3womgguznsumzi9aqe
X-Rspamd-Queue-Id: E217F4000E
X-Rspam-User: 
X-HE-Tag: 1774321414-677294
X-HE-Meta: U2FsdGVkX18MjMU9RVTwnPHUeUrnXZzrrOwF0aE3Q2fKOicP2TMwlzQ1MIj/Pfpx/dw4zIB1yCaum7mS7umE/eqsaQPa96tm+FDqsw41IUl6HkUOPWolGFINliqAoUtdgGyg6ZpesFMS3Yq8fiIAowH2ZoDZE1mkR3kf8famUH9k7eoIVQf0LbfjqiqG4Y07Bm94Y6BbXAh/dRLzcZxLKbEhy65qiDZ5nZkz9aqW+2ZruOY/5rD2JzbHWfH32seaPG66GALX29rR1b3p3JHDOMAySEr90kDA4vGiIoPAAIzul9/NeNgdQwZRKzlAGUtbZUAGqlLZY08S/fb9m4i0cs2PLTWR8AHgHkAtuoKk+E/IM0Vg3Evz1zpyAJOejoAF0G1T6sD2nss0lkSm4KG7DDTP0c/uAA6KwuyF1VcWNxG/0DoVaPL+ww1e1X+6jBCPryu20lFjpMUFROuDLwmy7qQ4qdL7K69nb4hiBfpRC2Kpjd4EH7YCTCl8wjwr5i7OBNWrcli+9T8Mvk67bRAu5Wa1CBobfVs0sGf3zyO4sEuXDSTZqZLIMjLsD60w140ArA5LJIlCfAja6UIi4DJ//3w3Fqk9xBJRg5kzN+QKn9o0wVXZF+KjQM55dOwbYrk8reTlujeBqV8Jnj5hy1LUsNyrPi4Fw8er7JqVVuJzP/6iTYBfx7FBvtP5/WtRKNtkh9GFbNepFaO+E7iFPyJhn7iIC3HlhPklqu5IOgE+IRLIxaGQSZVsyu9Iz0IOT/tytCw9tb3B9iLI8OgCSFhLmLEIUrWloTWnBNJRH8l62tZfNpCloI4ad7CpkhXf0fO4obS1VpkCminOY5fmhO1tS6LmFA3XP12AzNqcOeB2u+svn0wwHQ6Nix1Uo3tXJQjur4pp36MaE/okKGo5V5hOQAztQXKPQPKJONa8HP1ipqinwf9e0taU07cCrjV2aS83/vWj67K5myVy9eJ5e0N
 jhiWnGix
 F7EL7zpVxwimJJA2CpdfASNlXEA1XqUwTYMgQG5Kxq3sxR2tRFjkbcNLPPNgzi1VrfDBQg4QT6Nm4hnJjZdD2UxPrZn23l/NYGJ2yeiapQJWMohnprT0aQL3/sWmo9v+nExkNQPfyhZf9NJRLtj1rKoUUv0kLC+8LslvBw2LPQ+u+v7RQl8TcjpfeZWxBlUqkY+guEtOHS92dnxdjFhLtOE8Wiipd2k/tpME8PC+BUtHKnCD7rWfXsTqBHWbvHgH99x04edbm/JjmeK6e5fWwSWK3sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 11:51:12 +0900 YoungJun Park <youngjun.park@lge.com> wrote:

> > We'll hit a conflict in linux-next and Mark will tell us and we can
> > flag that to Linus when merging into mainline, usual stuff.
> > 
> > Or we can park this until the next cycle, depends on how serious the
> > bug is.  How serious is the bug?
> 
> Hi Andrew,
> 
> In my opinion, this bug is unlikely to occur and does not appear to be serious. 
> It may be better to park this for the next cycle.

Great, thanks.  I'll await Rafael's input and let's see how much damage
Mark encounters.


