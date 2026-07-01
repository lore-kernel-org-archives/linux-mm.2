Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E052C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 18:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3386B00A8; Wed,  1 Jul 2026 14:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 153DF6B00A9; Wed,  1 Jul 2026 14:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 044616B00AB; Wed,  1 Jul 2026 14:38:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CDC346B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:38:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 587C41204A4
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 18:38:06 +0000 (UTC)
X-FDA: 84941067372.09.27D6EA0
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf09.hostedemail.com (Postfix) with ESMTP id BF21B140004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 18:38:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FJf2w7Qs;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782931084;
	b=OgIdaMqXQ9r1X7ViZew33Bh/K/w+PRMPTVwhb3f27n9xItripzufeEfnAowHIx/U2ZnzlQ
	mcCikRnMbzjLx/ct/K1+DwzrqgnJOhtvEGXIbtq6Ue11znGEvbNpKH5pafg+p75WGVOXOj
	0yjn8UkLrioxbYDi90HA/s005oPUTgQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782931084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3K3cr4GsxbzT0LmEahJpkYwclSkV+OAI4Yq9jQe85c=;
	b=6CIMJYqSe2QroKY6zEjPbTBW3AcsHR3CAQpobt9ucZ2P2W8Ra558UM3Q18c02A/LaGhAG3
	NKFd/0LhZvmqnjgl01ub284pTLdfDnF/C5IZRgneyqr2gKwC/mvVAoanmPwcP/LA2MAg/H
	pWt4K6Hg4Yvdke8067YrBNAb+w6zCTs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FJf2w7Qs;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 1 Jul 2026 11:37:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782931080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z3K3cr4GsxbzT0LmEahJpkYwclSkV+OAI4Yq9jQe85c=;
	b=FJf2w7Qsiza1XaLAkJ8Wm7awSxXqDErp9N/xH9vKUYx112nque7r4ATs4c8aNdlIqTnlYQ
	s+LekgOIQ+TVL0++bWzqD4xBwbHENzpX85YyGY1lqjX3s//u5nu0Ge52Ewe0/UNPevdkNF
	x9r9vtviqSnZa6pX32d3S1onCMCDbJs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: gfp_types: fix __GFP_ACCOUNT, GFP_KERNEL_ACCOUNT
 documentation
Message-ID: <akVeVIkoqfT40QlX@linux.dev>
References: <20260701182102.1586784-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701182102.1586784-1-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ayqxk8petnihtpoqo3k6fzuyahyyssp8
X-Rspamd-Queue-Id: BF21B140004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782931082-283482
X-HE-Meta: U2FsdGVkX19SJFw4Pou8i9xYgTIMiHBkgrk3feuG/iCu1ogeI3a5suSmv6TUqIUEDAYXWZzP/MPH7+cJBN/2ExGlVFaLNkdSsb2h1reosTw7kWNwD827ybz+brubWb4bwHhuKA6cn/X+2CeiyNqH27JCnzm5NzJH626i26XJ/eYrZIGXbzu7sqdm5QbV56TUvm2CyqLuS3SeS73IqttLJCeOSBamdqTqqdW+/7sQVTenDFsDG3L6hqKB/dwmR8338v52gMI37dYSIobdldlOH01ACX+4IGpKVsDvYtk24NAgOQmRNZnm2YsEjHwuZsh7oVrXwggcviDA2DANV7jm4h5VhGkrUeOMLgbdw3BNq+hFP4cd7vtgaHNZpziD6YjzVU8vnZnakZwiA/HshjT8cQX4bv5JFKi+7mfjHakvAjxWR6pij/ABAzUXEInXJRSR+2IyhuQvZW2JSP822Z0Ze9LE8EJqcUi/iMzXHTtpyuDeEi38GxEaB/4fdTw4MQbHAjDzQGx1BZPvgs1aONjmzr4ydRrV6+NKuDMXAnuiGGPYzIH8oNQBeX1Seld7+9OFls791MSYQQDycp96X5OkLGwerZAp17rnXJsCB3gq1fjUzP/OYNtDk5CWvTtMBx551yjD5zm5ee7BgZt9J/A5DjBT1MQptemxy6c077vjm3CgIZsOKQsUu9Ab/jW1i0kA6B5KkccvYhyqAH7IzJHt9H5xEBURnpQ5iM2brkRPe2wtU5O/eNaOf8Hcphr4z8MUMIxIi7V9cHddFRpu7l8ubcCY0zPqF+jmGDGwIvcbs5+0Ot0txE/oZM5iYK4GIZsqvWd5WL3EPLCwrv61K/5ZyTk1REkdjXerYsingL2do0bE16csT22ddktE6w0tNFeer5/AkVL7H4PxEKjgYtgnyfXenfbAEAhWv0P7DOgO+uVrbFF6SG51dEP7h6hGPD8hgWpHm3iI27P0yRxg2oZ
 +8ClxOJh
 NheqI5f8Bs6zFgYy7zgyj+MMT3TVeCggifveQkpM86R9EIh3eRD23HRpPST77071Zfiqmt4s3MbtXIIdP7gpOKbJg1B5YwjnyoRPkPd0xk0PyUmRvebTzlln891U96IiV1nWZgEATS4yuF5Pr75O2ByE3Y9sDjncqkqFeFtcLELUrQSkrqwiJ+1L/mUoKwT1x163vtnVfORjxkMgv++JeGSh7Wk2pN4I1rsahC+T6phdgn4EPtkPb+U0gwi1zqBpj5wVgnt5mgwLBTDm7KvS0PHcCTM2NtNvJOh7Z77QeXmoMc+2LQrEjZddrqN98NmpV7M5yCy0Ydq+4CNAUjF5/S1xX/tTOee94MRyFc5GUx5PsBdnGYNOrc33DPG02h3kxCTro
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 02:21:02PM -0400, Johannes Weiner wrote:
> Gregory points out that these descriptions are cursed and confusing,
> considering what these flags actually do. This is mostly due to
> historic implementation choices and cgroup1 baggage. Improve the
> description of their actual effects.
> 
> Reported-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

