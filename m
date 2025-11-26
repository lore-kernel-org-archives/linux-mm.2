Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ADDCD10F4F
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 14:15:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A25426B000E; Wed, 26 Nov 2025 09:15:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D58A6B0011; Wed, 26 Nov 2025 09:15:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EB8A6B0012; Wed, 26 Nov 2025 09:15:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7FA176B000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:15:11 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D53ABC0604
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:15:09 +0000 (UTC)
X-FDA: 84152955138.05.E89D181
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 27FF24001B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:15:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dt6+rkFk;
	spf=pass (imf17.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764166508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LPbw8nmfdRPx1gStO3WJpiNvVHScxPjMArVC8Gf7Rpg=;
	b=sz28/jmBGfwsdieUz7WoUhmG5kco/eK4dWnNn1LdVZ7cJTmaDPHrJ5upYTeBwfPNe355DL
	Ip/QowiG8YZ4LAncScKbIcnNFtkXSr2y3mvu2hs6nzVGY7f3bV0SjVTHRdeZP9dOe0uqBa
	t7IEpn+52U9azvT5kE7u/JpCGXThxn4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764166508; a=rsa-sha256;
	cv=none;
	b=pXc7R5UYgs/Hyc0c8Us7loQYfwdhm0jg76NUK6DkM2+lyHVkhVxhgqu9MUBJkGPmu+YiTO
	6GEHnnIgeGvjXY/nr0Syq1Lux58FeNxt+nxVpLvQKxvKv4x1lf7VqxUj3Y5q6fmPYYxdU1
	vNDxue23QSqMx9ysYXyAwOltchYZuRo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dt6+rkFk;
	spf=pass (imf17.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EBA7143E43;
	Wed, 26 Nov 2025 14:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01548C4CEF7;
	Wed, 26 Nov 2025 14:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764166506;
	bh=LPbw8nmfdRPx1gStO3WJpiNvVHScxPjMArVC8Gf7Rpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dt6+rkFk/OkjQNJu4djTVzI+3i7UKwCheMXZISxY1MfYYkIo4yNEW6pwz67VbLH/N
	 eyktQYM7DLV0wcZ5pvqKMXSQDMgthOIsJS7XBe3ID8eNc6I/ZUd5FLeHdyE50WjU8B
	 8M66WtgjIcazejcFEE9rI6XwRoaAxw53+XeZBuKZdKwuOhHPmVqGuW8gYHqz6ISoSl
	 yzyKrX2hL5b3OA6f38P5dEKa6alNwIWRHsqQpatSix9Uv661JI5n8AnJNMs0B31TER
	 kXDi6GljJ/WZrf38fl59e4YjPJTU21Y1gP3aSGQNa9m79zCviU214D/iuxmtI4eX92
	 X080TWI4wBa2Q==
From: Sasha Levin <sashal@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: stable@vger.kernel.org,
	Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	jane.chu@oracle.com,
	jannh@google.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	ziy@nvidia.com,
	Peter Xu <peterx@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	James Houghton <jthoughton@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Nadav Amit <nadav.amit@gmail.com>
Subject: Re: [PATCH V1 5.15.y 1/2] mm/mprotect: use long for page accountings and retval
Date: Wed, 26 Nov 2025 09:15:02 -0500
Message-ID: <20251126141502.1386669-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251125044646.1074524-2-harry.yoo@oracle.com>
References: <20251125044646.1074524-2-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: w9wro4qtxrjb6zcrbdu8ojamzjio5cte
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 27FF24001B
X-HE-Tag: 1764166507-629166
X-HE-Meta: U2FsdGVkX18//OQyNu+ZGKzd+xWuISVf6UEed9WEbB6UhXuwK30ulWGULYzvurlBshy5yJ8dz9YGYX+YxS35JJABXBS6LVVQlRSYs69wHNExw1N3KRajROYsARDfHFtHoe7NX+0zqMmaFFuKnTaZXr+16fVVJGvWT/f5erIM6skOWfa65X0tk5o+7MyDsfezL1V9IeZGUdZ3ooEjr9OZBr5GE/+bd+UCzsB0sDDLNwIQ7oPrzPCu+cq1Q6KaCL8cgtJFWSjHTu+Zj7IEdcQuzeiDwxkWM2zsBp2C13MK9Y7jVuAqkAmombX5VEbKvSqckXosMmQFt40kMTRw1NPfwRzA8CInA6M2nAcpFBTol38vPoC7oQtI2ZKd22sA2+xTybMt5mDNcibZ8+6nn5jh/tfZv1Notk0jb2HmAhqo3Wa5yjJCDB3ccWxekFz5/Bdzzf556W1kaJHUGackMmMcltOjTJYk3l47dhu5mUurcBBWg3O4pIFn5Rmd64RoU2zAakE672ONPh1KWGsFs/EAxQVFZzmMLEVfxlJjN6guWV/CPtnWeYeJJRhv+5+NuVE83yzSi9LayEIwAfqeupw0EnS6u4SWrWJV3lwx4HE5kjycJznNzwat+Qin3V+1t+HGp7G5XJ8ciijkAoAtXQgu23iCiZoNIHXs8AVGrJeCdIL7VT4IWNVGf+FCvfIkPgb+zeoJR2eXP/7B8gEYBiiIfqfiacamDyR4t0c6W7fHdI4peqz+cgf9zlPykkEE+SDxAp6MxOvoAxNl90hDjY4ELSojGPBM/dYYbWDEfG+eZ9NdI3d3MkeVWcfduqHG+rknnKUwyLU3vfJUMV03wAvH2hJVevvt1k7jeZkO1WlHSlVf8jqUe1YoBUHyoEL7Uf7mSLnBzRm2jqboUQpXAarYtZcDUZOK2gCuB4tDXCbapts9zeZRvcQ5BZlB5wDM+KrL1eDiEyJfsQZJK0YN98z
 d49I9XsT
 fimGrm4RDMTpBqnAmDwK+VJY65ovoL/oMCqOYD0x/dIZpe13yuysQFrsJBtdlxxumMOzMQBu4r32AmlqcJKEPGC5ZV5RRlBSHz98APFRx47bBlhyfkV2sr3UL36qF2m054pNmrZyH8UCcihIO9XUhEcgPXo3PuasyhUJcJ4wqOgfcYMXDgh4q7Mi9RCCLc4Wv691QJJttIwVdFhX960kllaN/6nkYWE+agqISm4t+kRqFQZXjnU9uto/dLmpd+hQUOKNOWtudS3q6HLWxppDiOdwtiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch has been queued up for the 5.15 stable tree.

Subject: mm/mprotect: use long for page accountings and retval
Queue: 5.15

Thanks for the backport!

