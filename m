Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8894606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 06:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R56ZS/zX
Received: by kanga.kvack.org (Postfix)
	id 94A536B05B4; Thu, 19 Nov 2026 01:55:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 921916B05B5; Thu, 19 Nov 2026 01:55:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85F1F6B05B6; Thu, 19 Nov 2026 01:55:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55DF66B05B4
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 01:55:30 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A913EA8745
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:55:29 +0000 (UTC)
X-FDA: 85450957578.09.35A225E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 139BB180009
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:55:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="R56ZS/zX";
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795071328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zFxcU5zYSC3fy7jvAyHH9IJziWPqLOSZv6SHBUvMXok=;
	b=LvnNjiic0WqPleF9jEa4J9GrwkCc+SnLhAbNmY0ZxCwJrYDTBV6eZdzX17FXSPFcX6OjiN
	dcAB/Nx2GxCPvAIoc1sTkR0sQzr04dZ2LCydaJpo31sd9V/kztTw6Qjsh09RZaMzjbwpQI
	34xemwDjSPXkujUbREGpVctAyd2Smcc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795071328;
	b=TMFolaYbJmZhvcMfcDvgxEeh3qdAKxet0i9jY+62Lt5hH+qAO7DvPgW8kCziowl6fUzhSb
	mpDxd7PKkXf18YTijJUIB0Ya14j4j4TSbGrX0+Qju5Niiew2+VAy+J3K/Q82v8KYtA+ZdG
	97pclBToyCgDSf0UAHbEazK6eP1o1c0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="R56ZS/zX";
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C24E7433BD;
	Thu, 19 Nov 2026 06:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E181F000C4;
	Thu, 19 Nov 2026 06:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795071326;
	bh=zFxcU5zYSC3fy7jvAyHH9IJziWPqLOSZv6SHBUvMXok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R56ZS/zXPsRSJk1DKjEviB7Z2rxsc9BUUyYD32OLNBP4Eh6z+nw+hXJmTeiowgjd5
	 fo3+99UW61nPfaequD5XbIm7j2yveeTkjZGp84pP26xOLo4lHyel/EIOtEshGXeV1B
	 5hYDPUB0VPpI7N0HKMzPh/t2fhRq3B+2oPHbHtsov10Kz2rP7PfUvidEDVqp+yludA
	 JywgcS40+J2mP10HvWVE+nHTefKhu182C89FyCLssRGrpQoO8o+q8H83n439lZq+h1
	 zJWHZ/RMae+EtrPvh2nMlCfeofkm5+yVQnR94fK6JoPG93uLzNm8s/cSOAAQNRCGtr
	 J7w/98HsQlERg==
Date: Thu, 19 Nov 2026 08:55:18 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>, Jann Horn <jannh@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: consolidate the memory mapping entries into
 a VMA entry
Message-ID: <av6dVr_VR5i07VL9@kernel.org>
References: <20261118-maintainers-consolidate-vma-entry-v1-1-8019b0e9928f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118-maintainers-consolidate-vma-entry-v1-1-8019b0e9928f@kernel.org>
X-Stat-Signature: n3kt6jdc3cgnwz6ka3ip98uaa8dkfpyp
X-Rspam-User: 
X-Rspamd-Queue-Id: 139BB180009
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795071327-614569
X-HE-Meta: U2FsdGVkX18NNKZfi5ddxoljZEauhv4eBxki2ZvXRtLwb7CRq73Hv2bM90P9QS78jubTJaguRsDitOH680taMa7pSZgANHKcvAOO0rkLVncerTDEnRn2dPj7gO9a9GI5xghmLDSBSrVZ0DHTENDkRNaCtrM9EtVRS7iVnJdvxT3MS0JFjsyL4jg5WP0pOd3dvFCBX/HVqYd0I0tFvrXJOfxmXqNlFyC7pys4ls2MBHC0UKZ5uG83JOtz6mjDZ58SBpuKi5G3rIj0pIBRnplPLwwCrZKR6JAR5XJSENlBb0Yem1Y00TVrWdvYAtGloRUimbHVrv3gWlZlZ7gm6Lu5IWB+tlm0uf387rPvUIDz+Vb8u8gdEIu65TiFQPA7QvjfCa6CQn3l1ZvQrBLbZdh9QyoKRsxfw/b5PnPQbDoybSdOyxncmgWXv1kMW0zk2gqmCLomlCMXoG3ctkSsw/B3gsx5dRbiza2iLyKVuRxLFXXzsfYH2hDbb6G9zdHbC0F87guprAo853fkD4LHa0QvYn3vaGUAf6tItQg6NCnrH3/F8CUftFdDcf1+SHNVLOoLlmz4K17izSfdLhIkYxKLqQqDKjVcrBnLIWqSlVvqfEzJwc11dkSwVwgMM5dVwqhOeHJ9ht24yLsLIG2PSG95JK97Ng5j3FfkCezd7dgmcHleQf89KnehIJeOxu/zQLTeZyiODjS5nS+t92x1Oq8FR9qiThHESgid6U7etlBk4TzYa0hs03jWaO1DG+FbQj0Z3J1wWjAckkNgOzUgTr1SI2GHUoamyGuw4d1995oCuHg7MqON4YL8+Le25+NX5Oi96zQiOcmrt13m/jH4pdP+bn9xulXQc6xJBNSJn2vuPV4OJny/ljQIq2L9vUqsgaFwgzr6TJBQU6iwQzzcqJgkFv8MokHoWrMqB7NsBfjNgoXMp+YjQBHGOWvaWkE2fB6yyeGB3wo/S8D+pgwwHoT
 UmoTGMZv
 caxeVDSj6QEVNBLoA6SmnDVKp6HVE8ftgt+qbWD21dKXOWMhA1EhAN6S5CBixAhts6ILXSeBZOLBBNc/LPllaFTFcZyJsFIxvcwW2lkLYUv2426u2PcMTUiaMfc+rkYlwnSFFmZ2BBZB9lxJ7u0G46BkGyIoxLZghQ8BVbCXqLfpuYTl8HohiCXw7Rk8sgr8g2DWB1eRq/PURGxHUymgQwfrmuoDfjuM0WJDfgt77ezRESBizC/aAZVgQ9nZj3LQMOcEZ8Zh33CPd5HJDBaBvp9bcjhDUxWOhmHyZg4mpX5XSM18=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 06:22:10PM +0000, Lorenzo Stoakes (ARM) wrote:
> Memory mapping entries were kept in three different sections in order that
> those maintaining/reviewing each distinct part would be made responsible
> for/cc'd on only those parts.
> 
> However this creates confusion as to what files belong to which component,
> so simplify things by consolidating them into one.
> 
> Expand Suren's maintainership to the entire component, as he is a trusted
> and valued member of the VMA kernel team and very much deserving of the
> position.
> 
> Additionally, drop Suren's core and misc reviewerships in order to focus
> upon VMA.
> 
> As David is receiving pull requests directly, make him a reviewer, purely
> as an administrative change.
> 
> Also specify the new tree location in preparation for the tree being
> established for next cycle, and remove the link to the not so regularly
> updated linux-mm website.
> 
> Given that, from next cycle, the tree will sit outside of Andrew's current
> process, remove his entry, also purely as an administrative change.
> 
> With that said, I'd like to take the opportunity to express gratitude for
> Andrew's huge contribution to mm, and for his being both generous and
> gracious throughout this period of change in the subsystem.
> 
> Co-developed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  MAINTAINERS | 51 +++++++++++++--------------------------------------
>  1 file changed, 13 insertions(+), 38 deletions(-)

-- 
Sincerely yours,
Mike.

