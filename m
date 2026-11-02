Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 132D860A3801
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hUQHE3Aq
Received: by kanga.kvack.org (Postfix)
	id 262FE6B05BA; Mon,  2 Nov 2026 05:18:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2134E6B05BB; Mon,  2 Nov 2026 05:18:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DBF46B05BC; Mon,  2 Nov 2026 05:18:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE2776B05BA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:18:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68C82A0C2B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:52 +0000 (UTC)
X-FDA: 85389780504.20.F0DF805
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id C9D5DC0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hUQHE3Aq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793614730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wLYuXZLrkSF8tuj4uJ0Ku2nwORxJolw9wfJ5H0UQkaU=;
	b=G4nCrxJZNFmED50cOYJziFvPt0ISvb9+BCi2p/AZ0ZHo6OhvUqOQhzHHCrcxjJm0SxXzig
	DUStXXHPMyxlyePsnNl+c3U3WoVKmVARhM4ntkyNZ2DPmoE76Tgpfhvkwzgopz7UieoZTV
	zDIPrtI5LS7lKmZ3Udx0d0MkG/rdE6w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hUQHE3Aq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793614730;
	b=HkfZLyKJsiqDHNkMrOQLTTH3gPXSgK6Ch3XQRcgdO/zHtaE30Vky1/WCuoyrxVE2UsEMhO
	R4+MjsCjsSUi5B0L786ry2ylwyqXm6xwPkcsioE8FCIiYS+1MV3cQv43Cf1IqxCWyVo9UY
	7Oot7019U7wYu4aaXnt9pjw8qO2cMBI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CCF460F4A;
	Mon,  2 Nov 2026 10:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F361F00A16;
	Mon,  2 Nov 2026 10:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793614730;
	bh=wLYuXZLrkSF8tuj4uJ0Ku2nwORxJolw9wfJ5H0UQkaU=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=hUQHE3AqaekfXEulWwApjfQHGl6K7JNL60I+JKjUuB4ENBybwwCcng1W5bnkCNnWG
	 Tf/DZQ0qyFE3onRG8472pjkQZ00j3+5gbsZxIDWRF4zwYmzxrg34LIQfiooGEFl+UP
	 n6MKukYQalENMdeszyGK7ZrWp5SFQgNXnRypSfc/let6ab1wg49TVWNNcAmLz4lYfu
	 OWOnASPV4i1IcWSn0SM7t8EOCqehOnG2TWxd69TV2d8JveSfiv2QOHjhno6rzaw/rc
	 W9eJDuk+LEzK+NNAc/j/vet5yikK2LPRPDVJMXd34WJ89t9vRzZJXMLACb3Ejo77Kh
	 u1jCybtLW3y3w==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 05/12] mm: hugetlb_vmemmap: unify writable vmemmap
 page preparation
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
 James Houghton <jthoughton@google.com>, 
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261102032525.3597743-6-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-6-songmuchun@bytedance.com>
Date: Mon, 02 Nov 2026 12:18:31 +0200
Message-Id: <179361471104.1337633.15027622366207216056.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspamd-Queue-Id: C9D5DC0005
X-Rspam-User: 
X-Stat-Signature: 93ttcbkrmsjnh9despxx78xj3hzx3iit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793614730-855849
X-HE-Meta: U2FsdGVkX1/Qplv3VbdAKm1ZCnTuqINvjFPzrZ2NPuwg6SlmZZIvVdaGcOJwQPj88RDdrI+mhC6u2LL9TMRG1BNiL/cf93eG2FDc+Md6UOxIJiTR9EFFs0O8m7pOu067jw6E3QdoK+yMvn7u/ZUVFdxivre8qghZtAnKhyn9rSNHsGTLQRNrGDYq9R3JwobyEo3lthEVhKlG9rHUr3OdGn9TzFKU1aubVfJ4+k7HrY7kQIu+zTEAEZTG4UepeVt4GDL1e+K2yv2LKHw1Fj5pRwx7kZzzNdIhxb4x48rNSsfvWz6LCh2RWgbQfd1NCtiElFuapFFVBXHTuBo+VeRx3YWzNCF0RVwvqT/yXn+IJuiODQzMRrUqqJWewYshPIq91UmhpANs8uKlRY0O77qFZ2vfD5mIQmWKW8Ys/DqLE7OrTP6R1BYCzYRw922j2emiCI52dW6rzLvV7CIN7Q3Y4U+sfVAW+EqbUMQ9Egu5tNrryH1CekXbtNpsOwJ0W4AGkpyUhe6O74nJRLciQYrQdznYEbOE40xa4LlLk/AZBBoppX9COIexDsijXqIy5fBQo0Zt2fx/gghuqp6tFBIfdo4trfsHhqFNwnwGqRY8A2wVPFGlOHmXuq1ApbmEX7Kfyyr9Dx1PfhUlK3y7m+dCz4YZMAUOHH4O4QigyZL2bl77od6cr9qApdtM+WNPij2v7N9KcfXQ8rRCUhPUeKlCdMW+MrDl2LB7C1zZE6NCNyTGTUwLQGzMLJTyvTV3gySFUdV2YiHLrPxe3IuXe0qereNgZm4HhvlDiUXZUV2PYe3Vrn/Kn5B6DAAn+o/Xrh6lHNlPuKYd3zfPatx+2EfrmPvqpqKqg/i/HF6gVMRUm7/OahtEr6Fdvg8BwTPaVIaEvz4s+adkZsiWXHMDk7rtAQnIo/zTmem9P5fLfqmA/DlC4qDDfrQKaKBWpffNGxaFV9gmLCE3ctxYq7qpYJ3
 dYhza3/c
 Yk6rrE1r+ZsbcyXIakCA6ACz+E3NwysSX/Q/jubXMmZN8Rh1yIPDIJzPw4TeJe0OnS/HI1wRQMiHen9SfHqmTrpdawS2kz6xVlYhx+CqVofnH9TvHa+/4zKyHAdNcTyn+NwUH4qQPuQt1fNTz5LB+vwlGqrvx/H6ei1GKUF6ec1hZAC+L4k7qGXP/fP7dQf4BpkTWp0K6lbXRYjgYXhi6JdO0xV485NCcFIyAfAzTKnRwsIg9Rghx2YoP72J3n0AVeAKIbb2XloQW/oOPeXAdoJg8Vd4WD1YsrUAKoX5JWHQ24o7z8lsodc428A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 11:25:18 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> Installing a writable vmemmap page requires consuming a replacement page,
> copying the current contents into it and making the copy visible before
> publishing the new mapping.  HVO currently splits this sequence between
> the page-table walker and its caller depending on the remap path.
> 
> Centralize the sequence in the walker so all writable replacements follow
> the same copy-and-publish protocol.  This keeps page preparation with the
> mapping update and removes path-specific handling from higher-level HVO
> code.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


