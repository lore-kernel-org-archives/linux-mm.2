Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 715F8C79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52F176B0095; Wed,  9 Sep 2026 13:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DEE26B0098; Wed,  9 Sep 2026 13:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5CA6B00A0; Wed,  9 Sep 2026 13:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 20F9E6B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:23:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A9D521C1CC2
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:22:59 +0000 (UTC)
X-FDA: 85194894078.15.B29E992
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 127291C0003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:22:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WR7t8OlH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788974578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=APFjnB8AM36hLAYS9rCRFu3o1ig09AcvIwPP4JmZhlo=;
	b=B6QfsT6o0gj5db0vheCOgxjxOeFetJrPnvz+C5H0SeVx0m9GM4i4O/WBwC4u0zqwyKSftD
	iFLWapqRzrbQcnMSFtDy+H+GZEkfz0dxVNgbXtZ+S980syS9VIZp798AdcQ3XUzxadsdBq
	VBXw7BxcMxn8VJ+GvDZ1L+0c+fnEO38=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788974578;
	b=SrEXQHCz81W5tNEJDAnrrH5PvjssM/oBstzVAFN85gaSSx1+WPetffcFRnXNp1fIy/3G5o
	LrIywSbZ9YG03jeR+qGQwUe7F7DCCV/WE8F8O2hOYx5ami5bhxp9WVTxk1YHePWn5sZx8o
	WfTE9SKrO2vygJf6IvzbljUKsLdEbUs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WR7t8OlH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4662142DCF;
	Wed,  9 Sep 2026 17:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963121F000FF;
	Wed,  9 Sep 2026 17:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788974577;
	bh=APFjnB8AM36hLAYS9rCRFu3o1ig09AcvIwPP4JmZhlo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WR7t8OlHQCRXlT5je2S1lLwbE8AzuJZBKD/8FK3wkq5Fir3ksRyBj2zMBwpsqYgrO
	 U1fmgjXiWynIo4WdB1D8oXxw6jHkuOqLmp3ftm/vO2NIg2PmXKxcaIdiJta/knURAY
	 lAceIrP6EZKyszeO0snH+/ydcGLLMI9epoQ78DAygI+dviHOmBB7ucRFFQdtOlnRMf
	 6v9+ScTBkVopWm+GwwJmvyReMTjK/TBNXcEhOranbgn8mtYnWckfC5hQWiY5q5ptFO
	 kZ8O1UE988pLxsCSvlNeDmGAWmfWmiYEJiV/vylICesLReEZxQZK/9HQ63+FWFP6Z3
	 0g5BfbncEglHA==
Date: Wed, 9 Sep 2026 19:22:48 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/12] mm/sparse: move initialization of section metadata
 to sparse_metadata_init()
Message-ID: <aqGV6JDZwfWa-UD7@localhost.localdomain>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-3-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-3-008fc8d579fe@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 127291C0003
X-Stat-Signature: d8se5smgt1a67bdwdtd5wjt7t1gyqyje
X-HE-Tag: 1788974577-368648
X-HE-Meta: U2FsdGVkX18qYgmB6c5inY6T/XpKN0M69vnGdR6i7h24JzXeY12zseW6p7wx0v18Rtj48ght/nKnpOIwvqOJaNdK7jRRpqAPVV3Vu+CI8IUfAEm0aQ3JCOy3TkpiJoaXFYAa4mGJqXhALa9BznzMFZdjx7DCREt8cePtsGHehSI7afbH54CcWs+ofLT1ti6FAyy3JLCO8/1wZ6/zpPMjs9DytrN7urfVD402gG7pjkBKllS8gWNMNtaNa/lAmOYs7Pzn3S5GPP0DJvYi/zsnIssMwd8QAV17CJCS4dzCLB/SACGW6XtGlx7dHholXsYAgQ0mPGVRVR/MwqwvveQJdl+rcQpZliXTfyv/1VTSay83Ah6g8QMziOKMhpHbYDWu1lw/g6pl0dPz89shkl3ZGAbUZHY+eExkyBuFaC4id0lvdAlhcnFmen2579cvRPSjutavk0zTqmgH8XYJd0tgGVeaYPQPaVve3wx58A6Y44vGF/COyvuAliOeL0UcZi49vFuWaX8lbugGQFpJq7rdKZNS2Epe2Cp3Rrzuyih0jAKTS8ieKWoi+xbfak/ppdvSB39BP8hbGVty6b51pJ9jGafDWz40KV2uriFH5dNZ5QOZvo71/wkt3vUtUZLhTgOSd3BLCWzsrgrwZQ87P1T3KFGTol5qNHEgvfouVTUYqg6+Zt+aOBTZwVOY0hvGciix0YhXP2r8aIcN3cX4bIpYmnS1Rw6nu+9XpuToQH0IydPdd2GAm4/cP2rX+gqxlZryOKaTvBKBfuQ9XDarpfCAVe+bcp0IErz1gsjlou1i2+DaLMgY7xO8lLqIN85Bxsc8vP40ZX6gGbv9IisuD8WkXrnUz18dhmtNvhYTbNDYPfALB4P0jE+G5jvD/6X8Ux+MzcA4zrgwuHL6NgZ6SNvDUIDbRk4nQOZKcIyO32oPjb4u4kLg/WxRv4/OQ3qRK3vaE4jo94yb5ecOyfu4p+X
 ianAvnXr
 QOMBEn+8Ya5TkE6hSYpbpfv1C7bTsnBEqMfVa+Xhai75xtfGlzkbC66JTJ9s92+l6UWVEV7EnNDYGm5xYez4QUehm2iWOWxNhZwNJBn73dg8kaDarPpX0Yb0lSHivL7OeRJeWVNDEUQ/xy9qU3sLm2FEuMCYUyIxtvoiL+4v9nFrhfYi+rXMOD8Sc519UQCTvqEaVD5gGfGCDf8rgjgRMMy9PqdNEIYoNS2IpOMAyAqVvUEdGW1FbRvMbnjuZ6zZ+Z2HuYa5ULtM7VqPWuxAAiT4I7jGyKwLLYRD3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:32:56PM +0200, David Hildenbrand (Arm) wrote:
> Let's move the code responsible for initializing sparse metadata (usemap,
> memmap) into a helper. Cleanup the variable while at it (e.g.,
> "map_count").
> 
> Drop the rather obvious code comments.
> 
> No functional change intended.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

