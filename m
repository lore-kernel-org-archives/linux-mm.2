Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8378CD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 17:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9B96B0005; Sat, 16 May 2026 13:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8BA36B0088; Sat, 16 May 2026 13:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA14C6B008C; Sat, 16 May 2026 13:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A84DC6B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 13:08:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3A5261403E3
	for <linux-mm@kvack.org>; Sat, 16 May 2026 17:08:59 +0000 (UTC)
X-FDA: 84773917998.02.EDAC395
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 894AA140007
	for <linux-mm@kvack.org>; Sat, 16 May 2026 17:08:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gWcZta16;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778951337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uFMjgW4m+sEmgr8Y/ef6ZdpWJi2oEoQD0jZvP38Ycus=;
	b=ZIyRqkW7B+qTId1MY5njIXDNEPgAN96qi2vYrLypGKApABSr0x+E6awQeVY2XCpXo045wM
	eLzKxPv2NXCMjy6yzpmboJMJS5n679ec1Nzw0IoqI2WhbPquASNcGm6Dw+dZ5bApMz5CK5
	s648W3f89CP2YeTJehKGkB6SjWPr8KA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778951337; a=rsa-sha256;
	cv=none;
	b=WwjqUi1ElS6br92Sni8vazN11O4uPArvP1Ag9iiMHrQXJYkGbYaQx81leaNJDBof0Qjxto
	o5cgRUBa3qKjIbsnn/yWsqQ8TYFuhuIv67xgFT80FaHfaHyOWJsBZBN5z1OdT/uPq5eVcD
	jv+L5uxetlboIAHLwBbKvtBWSixzrOs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gWcZta16;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 574AE43A8B;
	Sat, 16 May 2026 17:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A25FC19425;
	Sat, 16 May 2026 17:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778951336;
	bh=BKQDoDJsXC439gUolHkssDteieDPq4StZKKZEfqYp3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWcZta16u/92H3aK2QjZQO3xAoa+TkIkwQDbEdzLFkd9A9rMwW2BkF7ciNWSo5AnJ
	 X9RKfj4S+e5yCwow6MLU12oY5LI7ccmoLaNE13KqBuJ7eo/KQaPr7hz9N5++ho3GNC
	 Xj5mol82GI6pP3R7uY9zSTSNNuNOObOfYtwlmralmQtONdxvENwEb+tglaJXqmBIsd
	 tHGS96TH2F0jduPUeqUDG/y84G/WOo7QlXHEbe7/L//6sAhzJuCvE8xOfoRCu9VEBC
	 88jdSwOqwvius+kNtzcTeF2lvrt1T/QFqeox52dWdajzEBWPTBs5muYBjDexcluapy
	 KFPkCFkfwAqrg==
From: SeongJae Park <sj@kernel.org>
To: Cheesecake <cheesecake2960@icloud.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: fix typos in design.rst
Date: Sat, 16 May 2026 10:08:46 -0700
Message-ID: <20260516170847.146524-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516093552.8404-1-cheesecake2960@icloud.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 894AA140007
X-Stat-Signature: rh5wacwg1zzgih6bi77w8jo57uiepkey
X-Rspam-User: 
X-HE-Tag: 1778951337-797807
X-HE-Meta: U2FsdGVkX19MdXc9qOyX1kaZ44O6GIw0Rjd/QEvipjn2lVx4V+HWoMgzMkuVr99THP1dZfmLHrNIiv30KM4R7QoRn5eobVM/tnFeyoZMZeU/eh/Ja82WpBSrTNBjYxfZ+2f6yAtemqmV9kRCvOQnZuUoHx1Er5OhkKiUzSKT90XknfbRPtoR840lb/voSo0DdlWu2tkQFoheOWsDNjjk4WOXaXGiqkZgdC09B5fYGIBp5ICx76ntKT+lIBISit6/drfp0TDSUqt0Nrv5CtPv9J5UNbZ13eMsmYOpTdkYUA2AxWxAKYW7iwAl7wu+F3C+ATaL+7bcooFfQ+t8jxnvPjxW2T0JXn0WUnpVoeRQk6uiSLcz/kYHXcJdKO/sDoF0b3pQhjJYbyeJM+ZlN5SLm1gLw7IKx9UT51IEvc0rB2Xob8FaScHPpR63GUEnRi5F6orFXPxpmIl+RSXiNd6ZM53BJstGRCnLhSGVcvGwR8i2qmSbE94rJbFHGJCWJj8CYJcjaWrX6UM6YcaiL776NXbMUakojdu1xpufl6n8WWQKjMRrwlWJJtvM5nsQ+gnA8zjeOAXisKDDZ30AUnGzkHDlTPNLT3PkhKeJf/nVFpkxA/KJEjGfDdd5wSMhXvYDUkTox7K51NDzZu7T3BOEB5pKoTpPHs+Amv1151DbA4t/GFYuLdRkvCSDd4GEf37VRtbmU0EaiOsqqgcVEJLDJlHEQsPqn7Ly5RSX/Fx5A6qRb6elJz5QT/XFD+OkRKJDRHZ+QsMt4Gk0qawMh3KRcDvAIFC1ULmn44TCU9QKpOstHOjaHy/KG06y/bD8+tCfHM1a8s9dBP5aP/Ztc0tL2b9TfZbZw/vgpTg8+OIV5FyR3gPBMs3L1eku73RTKEGXI7exo6A+1k81w9Ii5QnZC/6Yh7ZEdpSod7u2FAXQCPATD8opvbmC1Kh1vorFT4Dq0pK8ixffrsKLw+vSZkb
 5jbvM98f
 rNSTd0cJWMaP28gErIJzrrEzIObhRz0oVKO1q8LRcLNeftnRjkuCU9GlUOH+K1wbDHOFKv3VDseb20vsTPMyttkqHQqcEWFGfooMciSLFbtzKVmuaLE7t5Flzf7RiInqcgMpb21wuHILNQwMlD8HJN2UjDSvo9MmzMw0bejijmwjnra5OMCZ+IG6wqXgdKOrHHitQBUwl36K1D8Yeigk0Qz9oq7CIZCd1tjdXCBBdcw1yhzA6UWtUu6Leiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Cheesecake,

Thank you for this patch!

For the consistency, let's use 'Docs/mm/damon/design:' as the prefix of the
subject.  E.g., Docs/mm/damon/design: fix three typos

On Sat, 16 May 2026 18:35:37 +0900 Cheesecake <cheesecake2960@icloud.com> wrote:

> L140: "unsinged" -> "unsigned"
> L371: "sampleing" -> "sampling"
> L387: "multipled" -> "multiplied"

Thank you for finding and fixing these!

> 
> Signed-off-by: Cheesecake <cheesecake2960@icloud.com>

Is Cheesecake your real name or known identity?  We don't allow anonymous
contributions [1], and mm community prefer to use real names.

[...]

The file changes look good.

Could you please send v2 of this patch with changed subject and the name (if
Cheesecake is not your real name or known identity)?

[1] https://docs.kernel.org/process/submitting-patches.html#developer-s-certificate-of-origin-1-1


Thanks,
SJ

