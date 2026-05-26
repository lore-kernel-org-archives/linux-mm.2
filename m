Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F4182CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:17:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CBB96B00A6; Tue, 26 May 2026 13:17:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A3DD6B00A7; Tue, 26 May 2026 13:17:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E09C6B00A8; Tue, 26 May 2026 13:17:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 121EE6B00A6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:17:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D8A3120413
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:17:56 +0000 (UTC)
X-FDA: 84810228552.02.09A9F0C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D1B3E4000F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:17:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FsNQLQmH;
	spf=pass (imf12.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779815874; a=rsa-sha256;
	cv=none;
	b=0Xd4bsaD3kYSBoBlC7aq+4+UGezPEPbXzr7XE4yZldtUl7gxj1xY+479d3bUF80Og+LVoT
	wLG+lOajPnFp52fGfAJ4u0cMJv+v1H5YssqhPKuOOSaukyu8kkEQMqMEcXk8BTm+8kYj2/
	e5xuswX3KQWBazqUXe7NTwtwBNO7W0g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FsNQLQmH;
	spf=pass (imf12.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779815874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jTa8BEPEIR0zIy3+1hqdlrSykKWNssPHZWW374vpg+w=;
	b=hUTemygXqt74iy3ly1E7qE5QO0JLPpBPscNxp1oBctgSDcjPT0go5f6JhGYU/O+/gSCFkI
	2iIDPxJByYr5vz1XbKmaJIC1+k0BLIao6BS/FBKdS2uBghvtnU3nPST1mZJUBb4LMOM1gg
	+wT1jiOfIaNAPWv1GrazK39hzBg3JTI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C394C407BD;
	Tue, 26 May 2026 17:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27421F000E9;
	Tue, 26 May 2026 17:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779815873;
	bh=jTa8BEPEIR0zIy3+1hqdlrSykKWNssPHZWW374vpg+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FsNQLQmHM3YoqdEPoYTWQosukk0C4oSBXiFI1a9Zs2bWx7ur5Fnry3jju0V470wUD
	 mWk2Uz+z/EBISkPblWHFUAaa0ZSP1AYbW8aYdFEzkaU1X51GvVU8XkuvlMxUf5hOr8
	 Xn4wQ6phNgDZICGb8Tz3h4KzmBpP0wEWrgk6H4jigs/Dqz56OsQSFW3hQeh0a2AHjp
	 3b8eqtrt9m0yIyDUP2NaKEKiTz11zJMI+KhmVgVee6UKFLAMtPy8hO4wY8/vxVJcTd
	 4VAAi73fMDIaKcniE+qLv62wSahti5ZvFei7W2dwFjRptDCA/jNpUEvr7hAAs0TIjt
	 tuxEo80IJRyjA==
Date: Tue, 26 May 2026 19:17:44 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Jiaqi Yan <jiaqiyan@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	nao.horiguchi@gmail.com, william.roche@oracle.com,
	tony.luck@intel.com, wangkefeng.wang@huawei.com,
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de,
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com,
	jthoughton@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	boudewijn@delta-utec.com, ziy@nvidia.com, harry.yoo@oracle.com,
	willy@infradead.org, linmiaohe@huawei.com, hannes@cmpxchg.org,
	jackmanb@google.com
Subject: Re: [PATCH v4 0/3] Only free healthy pages in high-order
 has_hwpoisoned folio
Message-ID: <ahXVuBoNUeEvLRrb@localhost.localdomain>
References: <20260202194125.2191216-1-jiaqiyan@google.com>
 <CACw3F53U8xNTHJkdJMo-74_t0a2dX2cJtQOjpjizU8=UNLQRqg@mail.gmail.com>
 <ahXFPh-a_Zt1Q_r_@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahXFPh-a_Zt1Q_r_@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D1B3E4000F
X-Stat-Signature: mpws3ptj438w49ddmbtoeedeka4bgnha
X-HE-Tag: 1779815874-833734
X-HE-Meta: U2FsdGVkX1++6W+h7FnKxvD6wzpfblapElYQmOhdBFWap/awHtlBYFjfC+SMbC3ceHZJGBUNMDzOhN3wCFwtYdSBWCPDq/vhNiUANoL4nVvs25ZPPU5V9Mpbq+Pjw7ALS1XZcxfRO2begfyPlIuJ+9reUBMQCVgmKLDuqsuK2BjfxDWIZzjKfWDbxq3nHWAzg2AwCp7d6xNqIqh5h4irsOf4gLMHVGNN/2hv/MgOSYgay/NmtBtM0QG8SaTH9i1I/FT88estdW+eXZJyl95Xs88t8mj7GBMcvYu4BZI6woCEFEzcmUYeXQUxNakH39WS4Zn1Ii9PM+O+NBdCW90rliwT+0E4f5c6QZlcLtBNIESpRVA9+MhBXnCCzLFO6hTKF6JPZb4faF2FbFNIj04+N9MnjnfbjKsQCO3QKka8sJnWSsCSRw14YiYFqswGftibW2+o+M1RQDs4iGoGwWAm+Uu1CuzXNupqZOz0Emq6pomF57MmNYiPYwQdhubIHlFuqu8+EetLtKlFUr/QWFwoqSOQZJG7DSjMCqDmFtAIaeeX3v6/Kb/T+RenOtR6g2/vlw1EnTHBDAgfU+EqIqdLkXDITigZtYraQbVVzBygQYR6YWHVBYF2JmWfqwnSki7awWqzyZuvfxbirfhUny6u6E5GkfvwjdT797HMNzCHeT0qudYd8bpOHnzkpJg4/9MFi8f+rKRvd2kCffkMS7UIzU89Oi/DEivSw5CelI2tgyqebDqWfHA5CDI5OFhi0X0bhabpD6itN73p3L2fnTxWs/fxMgoi2BqFmfj2o6m+8yuat2dxavP9YRBYDdhxXf1cJ9o5crPq1+tPLRZ+FtRuuPr1JpndzXvKGiO4J9aemMed0lHcomZWW6124NfH0F5P3XX8RGjkKGhU+JgYmFZfrqTZlvszN7b2YSt14YjhgOaKS05Wf82iYjdj0U+PPKw1Dx9YHoWKgPZhwdw6mu8
 ZGg3n7tl
 h3fIbD2S2KhlC2Gd8Yix997OEGI7KN9Hkkj5VTw+zae2m8yz8A3wv6i/x3WDvBdP0TTyOyDwmhWyAn0x9p6qkSFeYF/OXRN6I2q/nYEOmiQ8U7TSJA8ohdLmtB9bZKMiis+2xkIPVTxOsdVT7PAYTjkPI24TCYkADneP6sFteOwQGY5GRa/FQygCHF9xOng8FYO93/LddVEHkBtN1fwkvk4+B9glRMkR8V2BPOe1MrYrKcu1Uns73MeIoryrOoybPYFfVFjPWMbcoXZ4Cl+5crUZGGs0uxboXeVHJ/DoQfwYY2iF7y+gHMgdFuxV3plqIdOzNusjyaniC8T01uzeBSB6HICRx+wJNayP/sLjjr6yS2QI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 05:09:28PM +0100, Lorenzo Stoakes wrote:
> On Mon, Feb 23, 2026 at 03:17:57PM -0800, Jiaqi Yan wrote:
> > Hi Vlastimil,
> >
> > Could you and other page_alloc.c reviewers share your thoughts on this
> > patchset? Thanks!
> 
> Hi Jiaqi,
> 
> I guess you are blocked on review here, did you intend to return to this?
> 
> I'd suggest attempted a respin to get some movement here as clearly this slipped
> through the gaps last cycle.

This fell off my radar, I plan to have a look this week/early next week.


-- 
Oscar Salvador
SUSE Labs

