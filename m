Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8470FCD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 16:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEBA96B00BF; Fri, 22 May 2026 12:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9B9E6B00C2; Fri, 22 May 2026 12:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8AB06B00C3; Fri, 22 May 2026 12:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 930F56B00BF
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:17:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43828161585
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:17:52 +0000 (UTC)
X-FDA: 84795561984.27.3305EB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 884AFC0015
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:17:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UNZ9koOS;
	spf=pass (imf22.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779466670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SD6FHiszBLtwk4oPX8InQw0Ejv5/nftEPeupI+z1+zo=;
	b=Z0nQTrkXW5VDhKiaZlnF5Xg0w9E8qOlTBbZPfK7VjyTP4CuBLi491EA4h64zaE7YUmK8UN
	Ch7Dx/eARPAib851jkyA0ZnIvzrG/9SEiqQ3BhLBOSjb7CDUa47wyHWxrRR+cxzsnLhH2+
	qGuVfOm/G/T1lRAIYPnXxtLN0E1rLIA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UNZ9koOS;
	spf=pass (imf22.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779466670; a=rsa-sha256;
	cv=none;
	b=DGciHQdknm4AIN5S6ijcbTDIJrhZDg7T+LGnq4JGXKCTg65Mte7otjbR7cM1LC23dJjvKB
	rzlTw5DwWB5+n7/dcsFjaLC9M5+HFiygSuRUx5Exm4WbsztxxwljgGZcOo99lhJCI37+A5
	7XnhczqOGmtbAgNwNEyx/M6uN6aIww0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 774D040931;
	Fri, 22 May 2026 16:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361211F000E9;
	Fri, 22 May 2026 16:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779466669;
	bh=SD6FHiszBLtwk4oPX8InQw0Ejv5/nftEPeupI+z1+zo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UNZ9koOScsHmXoJtud8jjPvCqZmXGk5F7XJiqVRW9I+QcBHUKyhlpphGq7RHWpkOe
	 kZUq3p36C57+V82JKNS+wUwZebdHmM1weNsJMQMFZez9LBu/Y8SqT/0WbX3PH4v8Le
	 RLn7mKe36FV+Os1VLtkUhR8eapTyd9JkGwFPPUeneAoSLgBuB13wvyBK97RvrOU7fb
	 bS/77qZBuHGcaKozTHF6jI7PiVYx+agJQisgb9xcwt8IQqr5A9zBmhBxMirdkGBJb8
	 5nGKoKccqtHdizfDCnIx+KT5wOuMT3qNJW5q9WHpawssisrMMuEG+f+S8Q5uuDNSJO
	 4nvyL5krx8a8w==
Date: Fri, 22 May 2026 06:17:48 -1000
From: Tejun Heo <tj@kernel.org>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Eric Chanudet <echanude@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <natalie.vock@gmx.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	"T.J. Mercier" <tjmercier@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Maxime Ripard <mripard@redhat.com>,
	Albert Esteve <aesteve@redhat.com>, Dave Airlie <airlied@gmail.com>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 2/2] cgroup/dmem: add dmem.memcg control file for
 double-charging to memcg
Message-ID: <ahCBrNfiLrh10Vtq@slm.duckdns.org>
References: <20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com>
 <20260519-cgroup-dmem-memcg-double-charge-v2-2-db4d1407062b@redhat.com>
 <ahBxB5a9sX9DEWvl@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ahBxB5a9sX9DEWvl@localhost.localdomain>
X-Stat-Signature: tecrcwm1bk6kzfbn65mpcx7nnmi7bi9b
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 884AFC0015
X-HE-Tag: 1779466670-273248
X-HE-Meta: U2FsdGVkX1+nuCEjxdGMVEjzdFGpvdS7WH8EnLLxmoggv489W7odPteAX8lVcIYEX0fFUvwpQkNwxxQ+p7I2Mifyw4pHp4qqPhBqJ9zAT32QNN/JpC/cph1ID52GsHBxUnJnbdCAigbHjePsZE83pUT9iR8H/hl0cDb8cVomixJf/KPV2kpH4TToOKWdhsvIyrfm9gQ2h2BCPLnq2mWqF3bYXxY8LIPST8WipQ/TAiTVRdpdykjSmAYcQI7Znw0CDo6AUZ8C4ulGxqVQYIzv4YLSFaFbPy+84HMPdIqXh0gQhRMtnx0HXkpZUb7Mu5S2HJbGoDmLiqF7aCWQYhkzs309GUJob1TbU28y4EjuSFpg87ZspejVIjDJKu78D+dHIYK6DP36nQ9ubDtyBEFq68/8zmt24lOHgOW6XDAX8heDI9nfGAVaZ31kDa6uJEfAdhJTUoS7GtGHwHAbATtwVvNqPn2+DWR475ps/ORkaKfbeyJkJRDhCKKB1qFNeTBv2zMFbPcuKBDMF7rdMXtRhzWD2X8Ba0fqSG8LN8XAWdFmWYSaKBRP8P66Z+r3FACGiilfDp48+q+BfQYBPnuLTH5CZDvGX+9xVItCnhSp/aJw9yu/nhj/vKfMCJRsmfrQ4D5Xw+vWIuEJ0k4N6BbtGii+WT7b8bvuxP27R/zfvHq3qpYCD/ynkVo3lVxGKz8HgHDmU6xA0BLvVgmQbwiGj6zeFOmPCaxgXZQWpf3gkz2dkFqdbRDxO8EJXVWBu1JY+ZkBcaFYVzoPyYHBArq9S33fMT5Xmwy4ukf7mBQ5SliIWxEX50aXw7CmofJwDAjeCtgJCm9pQp9l11R+GhmecQoImF41eFX+0ySdZvk7qaXwnP3WDFhbkOTHKqVEqi3WIMpBL2dWm1rzPrGOF6eqx2PIkjA1reVxe0DziiFwlqxk9DVocwN1gELf8PwUoc4F0gLDXzKSMNB6a1oYpDs
 mILV9OGR
 61jqbejIr4/LVKOSjWpA45et9mqCrTz0KPzxxZcEU063ky9M6Ds9srfsgwbj3jplKiOJAFuDDbOXYmoPyFb4aySGWBft2Gwc/fCuzYM2LhSk8srcI5RcyFJy7L3scEw6gLCcjH3kp3MyStLgOfOB3EZlP3bUoUnoONsaPclH4WkmDQUoG5+XxFlCZPsACKCJrpe8MQ/TJwV/riwuNWNEZ48Qmb2cLKv7R5IBHbbjxooSXveJvwe6jPTAWvOfa+Y/kFKioMDhsVX8PNsc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Fri, May 22, 2026 at 05:26:16PM +0200, Michal Koutný wrote:
> Hello Eric.
> 
> On Tue, May 19, 2026 at 11:59:02AM -0400, Eric Chanudet <echanude@redhat.com> wrote:
> > Add a root-only cgroupfs file "dmem.memcg" that lets an administrator
> > configure whether allocations in a dmem region should also be charged to
> > the memory controller.
> 
> This kinda makes sense as it is not unlike io.cost.* device
> configurators.
> 
> Just for my better understanding -- will there be a space for userspace
> to switch this? (No charged dmem allocations happen before responsible
> userspace runs, so that the attribute remains unlocked.)
> 
> (I'm rather indifferent about the actual double charging/non-charging
> matter.)

I wonder whether this would make more sense as a mount flag? What's the use
case for e.g. having different config for different devices? Wouldn't that
be really confusing?

Thanks.

-- 
tejun

