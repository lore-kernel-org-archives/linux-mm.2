Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F24E606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i/qK1c/w
Received: by kanga.kvack.org (Postfix)
	id 613E06B05B0; Wed, 18 Nov 2026 09:07:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4636B05B1; Wed, 18 Nov 2026 09:07:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B6FE6B05B2; Wed, 18 Nov 2026 09:07:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5166B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:07:31 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3740807B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:07:30 +0000 (UTC)
X-FDA: 85448417460.22.384D30A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 34F6D1C0006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:07:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="i/qK1c/w";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795010849;
	b=chZsV5tLe/v4NtJ2Q89pgBDO5wAHL1yJEXu6+hJUulopCm2cIT38Q7FTEgfT66erOaZYOq
	UVaqsqBcEMRq3KYaptJLJCiwCjnwYeLLXqDaamBX0OxEL47AUf6zOB7/+Cvli02CI9QhLO
	UoAuA9dBpsAvgmyNVdJT1hfRWNLA4Ug=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="i/qK1c/w";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795010849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5lNlxAoGPg806PTxIoKtyPv+dx1Gfpw3t9P/RGtzac=;
	b=qY4npuN0ojAKg3W4nwlKZ7QPNrU4Wk1bdHX0WSsiQumR7DWBXkY8L3iJssFIZR+c/7lkJ3
	0XrrUH0OHaBI8DhLtIy8Eh9p5DKXiAZkNtsP53oA/rPAOohIdEEVcstEBNAiHl6JNkCTG7
	ndUAsFU/l9/3nGQ6XiHemIfJ/oQDr6k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B5406223A;
	Wed, 18 Nov 2026 14:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8272C1F000C4;
	Wed, 18 Nov 2026 14:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795010848;
	bh=k5lNlxAoGPg806PTxIoKtyPv+dx1Gfpw3t9P/RGtzac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i/qK1c/wDYDTdZDrhx9JaMqoN3swoPbXUD1ba1bvT++6dL51gYeXNUGjk906z7mNR
	 N5LunQHFijq2OsxbhpkGl8x4vTEiTlogtfEGDocavH0SHDxxHzu+3TQnqlGkS4omm+
	 +bDmYrQ7QInWgvSb4LnBz3ATcFuc6vOu9bGerA1kydBbmytp+KpFquhRzIieBKQNLv
	 IiHenjryKZh7DyXL4y22k4yfRthPyz+rcx4g6d1LtDFw/RoLtW4FYfzBjne5gVwMdP
	 ymyrHvS04VW8CQJVKsqBG8FzSxG2TImUyo17+tALc1Og71joQgK18heBqZHYLkE/bw
	 lnVG3mtOmkRxQ==
Date: Wed, 18 Nov 2026 14:07:18 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
	Roman Kisel <romank@linux.microsoft.com>, Saurabh Sengar <ssengar@linux.microsoft.com>, 
	Naman Jain <namjain@linux.microsoft.com>, Michael Kelley <mhklinux@outlook.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, Eliav Farber <farbere@amazon.com>, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>, "Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v2 0/4] mm: fix races between huge and non-huge faults in
 PFN mappings
Message-ID: <av2cagI4ccMR7jJz@gremlin>
References: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
 <d7edeec8-d9c8-4516-8426-de2d8854ae06@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7edeec8-d9c8-4516-8426-de2d8854ae06@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 34F6D1C0006
X-Stat-Signature: n5pk1o5r8kzcoqy83f6kegcqbwzcwxxa
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795010849-945478
X-HE-Meta: U2FsdGVkX19+aVAwAwNnttd39VF8NyL3pTG7VhlVKh7BY5Kk11PJXiVOnKIe7CGYb56f+Ln9N04hnagMUWkhisDlDrvBPFfz2DA6oUxb4H9PW1xWCsu9/8U/NUQgoBYQt8p4/V+YZL62zdfSMmXTvNe1mmwdKck+loSooPzaYmb4xiUy3Zdrwl44Gebf5u2d1evcyrnK4pUT6T1tR/B4gYRytZFNZrZK8wD1uhLCRPgXb1FTh/vSabcn1+jRC5CDv7u6bnWxmMortZNIK2e/xEz02E+1j5q7bMJ0taceNmjnSHC6kz6GfuvfdRrXdm1usC+7ShHyyHxfPj3sybh6bAPt00r+THPEXvO8lbup4awGaOJfGopfhEzqQCG8M0QepHngA9xzC7jGGy4sF5pXFr6cDy1lHAQ/kpFoM4MutYVid2SOYvLrc+uTlDunZxGdyjxBGw07kFRDSFIpxgN1MzIsIo3tRqhwOOllX1YorzaMTrB2vyYDkDuh02daYEMRt0zwWeH5XCPCu5mimLwknVhfdmbf/9SHzXN0JleeExQJdbh00iwJL6PzwyFo48frqxxkvHO2nXuwajHaUotCPrbGvOPqVb+o/d4re1jf4iRK1KmBJc26RkHtNEJNiNQzGlwjLJQpF5pFlkqHnSxWlinHEiSD7/6y1qqJY94Zt6uywWC2n49KsyHzbpFIICJlqQlyUyZOD5fmvWngoSecT4GeTO6Ja8/cOyKMPhfA8t+i+ocVR5E98XCkwZKFdFDKKn+NPHn9308LvTaeuXIuWPK4nwmbEGXSnSkZonaqFzX4HTLl6Z+lyy3Z5FuRytVLeZqaaodqJ7GV0YE+z6HgDoO2/697pi/1i0HZYnS6p0nS90N9uPmULMnhwia9ivs7+jJqhjcjW5Vd/KFeUdzc7Jf+VpO7SnLgvmNgKpCrwCdl53tCx/2mTy0ATvkom0C7aGW/GQQfAhozEiTVs9/
 a2DIXNEK
 RvGGOSdVGZPFtB2wzIKjEN2oLAbik2GORYth5MSmxZgtOwFMYz+fWgV/9TpePakMamPIWOrXP/JJY5B1nrzSXXF0YusUQbvl3a7CquNulEDXCRm6NzDNndI1Un9ZfYsV4zp2AaNK7fju8r9UZ3BSrvDG5avG1kWVE6kAgInl3A4KgeU8sFXLcgpOnilZXm7Yi+mF7j7zNIZoaQJhS/iD2WaCroQpRPsQftvhfE52moWPmF08J19kOav8uLSc0bJROmDwv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 10:47:48AM +0100, David Hildenbrand (Arm) wrote:
> Lorenzo,
>
> all of these are not super urgent and can wait for the next merge window, right?

Sure.

--
Cheers, Lorenzo

