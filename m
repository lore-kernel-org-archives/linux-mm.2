Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F4A9CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 22:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C55358E000F; Thu,  2 Oct 2025 18:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2D3F8E0005; Thu,  2 Oct 2025 18:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69CC8E000F; Thu,  2 Oct 2025 18:02:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6D948E0005
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 18:02:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 44AA65A0ED
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:02:31 +0000 (UTC)
X-FDA: 83954548902.20.0CF752F
Received: from r3-18.sinamail.sina.com.cn (r3-18.sinamail.sina.com.cn [202.108.3.18])
	by imf30.hostedemail.com (Postfix) with ESMTP id D4C478000E
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:02:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=syuDgx6y;
	spf=pass (imf30.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.18 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759442549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VtJew5ZCdvV97iI5B/3Arl4KX8tS6megboe+TBYge0M=;
	b=185qTGtLceCJ7C2GHMryWMIqoxfKPza5PYvwqAS8wmJa4TnpuCv4QzhPY/Kj1Tbgvm7IRs
	5IfjnHS6lKWvT52ZwumywD8iNMmKRWaDyi7738619nlG677y1sgPPdWimOVKngdE1yoW6d
	YZMeTfJtXfibXYRHDx97HTogKMD7B/Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759442549; a=rsa-sha256;
	cv=none;
	b=6jlkLfKVO0FMI/VSekZ+8SRleS0YxyhRk7hRFc1sQF01NqT7RxDxUD4c5sVptqWo3Z6l0A
	v1GT2QkrMjf+uBGzfry/lL7Umk21FcuuJfj2WXkLk8oobMw3d7b0fjMyjFjiM5rKZ+AYnT
	aCX7aZmaMbLp/3e+xhSYAoxNNOVOX8s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=syuDgx6y;
	spf=pass (imf30.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.18 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1759442548;
	bh=VtJew5ZCdvV97iI5B/3Arl4KX8tS6megboe+TBYge0M=;
	h=From:Subject:Date:Message-ID;
	b=syuDgx6y0jR8y1Jnu/6Vs5QLy63hccjRTGO1l0nG5eCZnl6eJLWvvLJaaX9j4EBLd
	 GAeT9iaIixw96wnrqoAA5KtW1ncHiaZK7/VhTrOaWJtilQi4daw9qtXvqP7k1Itlws
	 uYgFPdMRAuSb47d9uJg3We2lk5w2UjJvRWzu/ITo=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.32) with ESMTP
	id 68DEF66D000023A6; Thu, 3 Oct 2025 06:02:23 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 181394456620
X-SMAIL-UIID: 2201C5466FD8454B870603BEF434F690-20251003-060223-1
From: Hillf Danton <hdanton@sina.com>
To: David Hildenbrand <david@redhat.com>
Cc: Byungchul Park <byungchul@sk.com>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC] mm/migrate: make sure folio_unlock() before folio_wait_writeback()
Date: Fri,  3 Oct 2025 06:02:10 +0800
Message-ID: <20251002220211.8009-1-hdanton@sina.com>
In-Reply-To: <9a586b5b-c47f-45eb-83c8-1e86431fc83d@redhat.com>
References: <20251002081612.53281-1-byungchul@sk.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D4C478000E
X-Stat-Signature: cgyjp1u173rdhrxayfaa7wa87omd9bot
X-Rspam-User: 
X-HE-Tag: 1759442547-372599
X-HE-Meta: U2FsdGVkX18KRtVSutQntny0QjZFyDIxDHPackqCkbwKN8QYnYYpB6iS9QdW8LRBmSNW34WCPCRLq1wAZck7uT7Jbfi6mgIz+tuPFC8FukwdXG0pIYdRO+Nw5wlhxbs9w8tTTTZQOOO8EnEgZqYXcjjbVMxF4E8ZurmCwiMGfFOT4m4wCsuT1o6jDWuuBgAn3I3Mfwjvkzo5G3cFtJATbWCCU2tSb9pUxwRXErNBQyu0LPp+s3bkZPxqjVf+EIT8Yr10MJ1ifwNFjNkjEWL2qQkE+U9s+Uk3A5jXyo6aLr02iG3TTnftx5qDAquLWNNpXC6N0wqXBgbcv2WnhoiB75CvH+pghmKJp9w3ilHZLJC6Pqd8tWkmDF66wLnKNwAMHKX7grYHcV7UckBLxU9MuDO3I7kjJ//NhHOyRecxaazxb6XGf/E5AzH706WCejL/n2TX4A9fVOMlKeMfK15SDr7OMfeyaHMPUJQVAjg+g9/dlyQqQwxP8o7iuEC0LhfC1mhJbSCFf+iisv0zTtcD355ym6GktVjFxGxu0V3ymAOpeliBOX/AeQ/bIL68dFh4dn41OaZAUPIjPxDQbQM7VVrbJRZfHEGWjdgLqzQ2td9dsCrs9hfuVdDJbKsGMPHaslUFYJ54GU+XbMTd258Ue9f8lEYJ5TMF76YyenUoQo3OQ7vnOFryQFjUCKnqp1iahtmg55/MUGQkVOvrinq9t3VGIWC5JS9QkTjBBIn5jpEdehnvjA1sOamoHHKRHfzFAdS3wa2UFDJcEk9Zy07WbW4CUjGTU7t8XKH/Lc95+vOJrjR8q5c8hYJkEZqKuT/FxKLHaDJekCXoelROYuhEP04vuCu5UXhmKlYciUNKn+xx2BJIJYUYzqkRcRsMd0UYtI2Fa6Cj5g8OuEPqVLhjluaQromlrsBmwE7LYPlk7r8h9YCNgJHYeNyY99rzGDKY58hL4cGrU2EnQ4iwGCK
 ZwjfMHiZ
 5Btoc/n1j+X4FJ3gpIVoDqVvBQ6c0ajKUVlbvkb3dLP9cBsQ9zR6rTmnt2O6InvPO/gqNPByUWMWaZ6ekB5Fmf6tU5xQtFix1PceXd0G6xtqfpp+p6O2/1Hin+rALACYHKFfxqr71ZQjF/iXOj+L+KWkwWkUslY9NfQivIXvOAoIONYSswmXNzJIsE8PMIxQM4FkzlRcEUTI4NxEpACAudHPWLtIP7BrZly4uqtduu587sEUZAE3QUWd8MgaolsOnmRK/I3Ql792lq1E/sx5Ree08icOXXJ6ZnNYbErRkf/imuHqQq6TG4vGzGg1i3FcMOi5h1bAv+6RazuMO4Ozj6nhuF7eiclUhENjj2xltgIN4kub9SgHWx7Z9nl8XMoJhApE26i+qX5dRv1g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2 Oct 2025 13:38:59 +0200 David Hildenbrand wrote:
> 
> If it's a real issue, I wonder if a trylock on the writeback path could 
> be an option.
> 
Given Thanks to Yunseong for reporting the issue, testing, and confirming if
this patch can resolve the issue, could you share your reproducer with
reviewers Byungchul?

