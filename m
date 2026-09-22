Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E2DFC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 04:31:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 785086B00A7; Tue, 22 Sep 2026 00:31:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73C2C6B00A9; Tue, 22 Sep 2026 00:31:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C406B00AA; Tue, 22 Sep 2026 00:31:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 406136B00A7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:31:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C77C0A60FF
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:31:01 +0000 (UTC)
X-FDA: 85240123122.19.AC78027
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3D0C71A0006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:31:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hldADQWq;
	spf=pass (imf19.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790051460;
	b=kKSibPhFabAIHeQBf5a3eTv05zT6kB4NwQHGdqvH/LWo7sPWZOwECK6EPe1HLjL+EgKilZ
	nX00nEr8BchzPzBSgj8Bedjwz2hcw8rne6Ro+PVmPCW4FP2kwZ4y2HcH2Vm1JDZthG1yA+
	Iph4z+PZ3Pfk7EcQ+mSCYhpt5LGoxY4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hldADQWq;
	spf=pass (imf19.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790051460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qdc5R7bjkdDuaNSCvOWojUk5Sg6yPCfSAhPuY0K7RNA=;
	b=p7/4tPufUvYW4e6ZdD89dAdo6OnEXwAQYoYH8fvVHcLeuSsiOhZOB4oO7KDp2qgHfs460d
	b7u7qAcbKrq6framHEipBP6oUwZ3qIx9uvp20+ad3Ch+4yvDXJyio2v0zrXLiUw5quISeT
	0xU2UKd12HbaVIxIgZzwxRVp2678roM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C977D60210;
	Tue, 22 Sep 2026 04:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FF51F000FF;
	Tue, 22 Sep 2026 04:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790051459;
	bh=Qdc5R7bjkdDuaNSCvOWojUk5Sg6yPCfSAhPuY0K7RNA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hldADQWqF/hfs8SN4fmi7i5kP1AZdSlkfbJB/gbHkmwAWaZLmLnTQI0XrNAhIWA47
	 SIQ27wxt5GZOGMjM+hGvIcsLZezM0IfAan3a+ojz5ys8lj83KgGWDmo3+KNlosiyzO
	 Iv65CgDxWAjl4ThF2wf0R3YuxZCpJ5P/LEkbLGIUXyj+Nj6hTfyninHN9PxUboAXj1
	 tosch+L2yJ3SvcbfAHkwv4RzLjJ92Ixhf9ABr9fittTCBl8UBNAekwKHaURP1h7l+8
	 cgr/k6MDgrv2IhX8a+N7Sz1HfNWKEVCRVCwc+mMXm/CFrWUpFcBvyTD9y/BRWZU62b
	 BWhX3kD4uHg8g==
Date: Tue, 22 Sep 2026 06:30:52 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Hongfu Li <hongfu.li@linux.dev>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>, Chris Down <chris@chrisdown.name>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
Message-ID: <arIEfJXYpspgX4-G@localhost.localdomain>
References: <arIAyyjYcCKHFmyD@localhost.localdomain>
 <20260922042054.3264663-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922042054.3264663-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3D0C71A0006
X-Rspam-User: 
X-Stat-Signature: a51zz4oc7pmt6386nemdanz7aqmnobww
X-HE-Tag: 1790051460-793396
X-HE-Meta: U2FsdGVkX18SdGr0Hx+dQxcjcRU0uKlEcLLq2Fhf5JVwfDTl01e5OAnxCPhhMcHGT9zU06qgaoEzmHiXMPzxHK/zaLMkrR9kOZMeB7Y/0VLP/bQ6JpmlEoyfE9DqWtEeuhdnGUgTH7658f/Y/J5ZYIdNQAHZtDJZfy7SGGUU/7Lwozcnolbh+GP3sJGOWo6LYQwpWF6WIUysn8g6t8oBsHeVxm6+F3RLKQXGNl8ZTLi161mIvoV+/9e6SXgh0XODyB04t4xIHW/DfZBdQqEUf+8YiuRrNG1LbPhoLQwgG+a+v/Qm9JcRDInA1QQXhnczSoy2TK6TdX863VHD0jw5+oqRGD3BUcJnve3Ng8DFu52wON8RMUIuTCzDZIlZl1qLgj7lfULnr/7We7VztpMqGklDLlK2P7aKyve/Hl0lTpotyEeDH/DEejyFf1Dj34Ib5MGaQ9U1dtsF6aHJcw+hmqyD2uo12/rgQTYUgQlOx02iEnrukkRItbbVPzKlEfl/DdNMDv2HNANeo3uySqA72iNcmjjqc7rBVd+yO3Wzh+mkTBz/Nq3U4lo7Qa5QQbTj/my6nrcq1Z6k0Pz3nISGI4PY5yx23wsXb5zBdV1ElS//S1wkMZXRISNmEUXzZELmQT9HFQyIkCykqz+IQ8Z6pbjjjDE4Bt9TU1F6isOs/NhALE0VFo/NYNZdEVBS/t+5vFYJ/cEk2p6QSOfb7S/lXAtE35RjrTIma6HaveT3iO9L54gWjJeu9TeBK/7KXh/CzbE9cvwg0jQ3AW+mA/U28VAWjd4GIduSuqOf7zTTpJmGRDonvrXFDg5aCGd7RXRqlZPJ+VCGPmD0hZpOYIWrBi4UHHltwsP/wN7Qzct6wlBEHc7C7IS3MMpzDMjEXVeVVvBJ94zSZc5ZqNayO1lFcRTLNSuqVFcJXBxKatSSxmqYuZjrEU58GkfqQXN8xTgfwMnbLNhp3Tc4jUgfGWL
 syeR0bZN
 Z9kdDXD3U+dpkDkDKQdBndBS5tTyBiMzYjBqQrgsevlUmwz0iE/QUkb9lqQjfq2QGjM1Q6ZTNGl/bLGOXHxUk7HNRfPhN4DwpXt3/euPazidEK3QvaEJkEdubTN/INx0Yexxx+muRgToEnHTn4NBbbhe+IkZDLa843GBrT+b4n9OB98ervrvEliQ/6p32MJENJ1WwPKfXQDg9k4vp/Fk7Y2K4rkRB2QuLdHMJ77PFwQtNW5CSQpNtrxCkXXbcaentVgFVzOB/0iqLn1J1s/KF5jJYfX1m6TY4k6hmS+kTknyKdpnOjVXqhGTJKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 09:20:53PM -0700, Joshua Hahn wrote:
> On Tue, 22 Sep 2026 06:15:07 +0200 "Oscar Salvador (SUSE)" <osalvador@kernel.org> wrote:

> > Why do we need the whole thing to be embraced by rcu?
> 
> Hi Oscar,

Hi Joshua,

> 
> I believe it's because now getting the memcg from the objcg requires
> an RCU lock to make sure it doesn't get removed while we work on the
> memcg. I think this is since Qi Zheng's "Eliminate Dying Memory
> Cgroup" series.

Yes, I understood that obj_cgroup_memcg might need the rcu-dance, but I was
unsure about the mod_memcg_lruvec_state() calls.


-- 
Oscar Salvador
SUSE Labs

