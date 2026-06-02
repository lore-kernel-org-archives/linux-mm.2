Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87325CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 15:42:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7AC6B0099; Tue,  2 Jun 2026 11:42:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9FA76B009B; Tue,  2 Jun 2026 11:42:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDCCF6B009D; Tue,  2 Jun 2026 11:42:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D23A46B0099
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:42:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F5571209BE
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:42:02 +0000 (UTC)
X-FDA: 84835388484.20.6A98A13
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 938E2A001A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:42:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U5nLAucj;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780414920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vjyqcof3ur0VsBuQ27nsiijAuIUGnyHJR2TBn7uQ1bA=;
	b=6flve0JsgE4YKxA1kDoJCDwV5G3VHvGbQ394CTlVfpFTB0+1Lrcovp7TcA1UbhMAkoOvdN
	gHnI3hdWW4e58tJQ0z5hFYnDqpibEPxrfj0teqCejg7E/CQC8WdioCwh/c6cjXkpHlcpGh
	EWi2HFi4KOJcaaNSzyYW0gUjamwcx0Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780414920;
	b=fQwH0Mf0yDrJz68saqLVQ1EPrHOBqG3Md5Vxl/Yvqssw2F8j+o5iSmnIZ7Xy3XwCFvAoxy
	NLbmxmQjM30TpQhnm5xcgfsjC7JqJcXaRfLVtOKqeHNnqxxlGmZPp2PQFIYTJ3P49OC+Ox
	9iEEqI1W9qk+TPrPtETjQas3owQ0XOE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U5nLAucj;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 269CD601EE;
	Tue,  2 Jun 2026 15:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A3E1F00898;
	Tue,  2 Jun 2026 15:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780414919;
	bh=Vjyqcof3ur0VsBuQ27nsiijAuIUGnyHJR2TBn7uQ1bA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=U5nLAucjBQDIwq7yJtoAo3oZmrJdkEqlXpFMLCL0wCgSNs56Q1QG8UQ2nIM4l71kh
	 Fea2t+TqzlJ90MjzHpqV9BMz8BgdQna2uruvigNJp70yVRAfr6LJbthE5RxUeVcD0/
	 LOES8GA3Aj6LYog7tXS+tu1fMxb4SznjqNZjkQAxS4BhwdEZbpgGFeepkOv6SxLxXK
	 GW2Qp26bTTYyKVDktap1k545sMZyoRjtoeLq0jZOcf4Bl8Ju5HWmwLOl6zemPklVON
	 OoIaFKEJHR6a9dx/8booAcrG4au9Cjgih+fkkVA/wBJvrA58JX72Jj0RffeydvtvSV
	 tfnhUtwxe2qjQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 18/19] mm/hugetlb: Remove unused bootmem cma field
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, 
 linuxppc-dev@lists.ozlabs.org, Mike Kravetz <mike.kravetz@oracle.com>
In-Reply-To: <20260602101039.1867613-19-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
 <20260602101039.1867613-19-songmuchun@bytedance.com>
Date: Tue, 02 Jun 2026 18:41:34 +0300
Message-Id: <178041489401.457517.7510742037477989122.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 938E2A001A
X-Stat-Signature: sq1mtn8bwxewj71uhxp1gp18n5cpmi9q
X-HE-Tag: 1780414920-494755
X-HE-Meta: U2FsdGVkX1/VjXFsPkxHbW+b7lOyUGfDF7bzVqO3ud8nunO/RbBzEeWGXDV3FcqmQIVqQTdjUFpX8QPXn8KxNSZJAw/rOVRWbwZJ8JGBXiziWGXHt59LP7FQlDnrNCaSR2yAlgUU65tchAsify9By4Zs9AD/g15Zq/xoYM4h1Cd5AHf65m9MBOFkRg9Gpm0pwWlJCcv7GdOe7fmzoPEFrZo1oTq+Kpksc7IeQhsal7LzqzEzR3nte5xrg2x5UnM0HC/TjjjQbnRlqjhe8e7AI/8wMZuBfIRaVzlj9dq9wQXRdDw2H0q8Tv0kzJOGcJVWym0GoxdkwBV4g1qzD6KtaWBh+jm54ZJeZsmA6F6+MB/XLOK9r39Sn6+Iq7NKnvraLwdr3/IsziGu3lwvdk4jtpzPVyArRUqHuYXbCHp5ancxD4SZ9zMuI3p+cGhG7/NntX3954JyZvbL/S4xoXooMj06yBapswSCfyo0IDK825K/TnaFsv24ifudoBGbcpLlR+iTwR6dJ9ExDJTaZQl2weH4UwCEOEAqlQfvz64yJErEohFnP1pQltBg+U1fmihxK2Z3zPDV0C5Z+isWH2pR74xaTDizHKnjRiNCXd0+vyDMU/E1nJ8iAkhwX1WLMOpdp3/oDvncIw6rOZT4li5Az43HbAMfaJ+05D6t+FRLoz6GClru5rQF6192KINLZsHY55JqxcQh8nh+2ytSV3lofg6A69+gcIQ6M1AV1ZWaoiG4pTf6Bbyk36V+JVX/FF1oTbr0knMtyDh1bJBrgnfYvRuKWkfpYV3EcyJNYQ5L/vEQJqmawQ8/g6x+C0qfUPt+rxFdALIi6893ONJA026aHQnXxlQ94m85a8PevGxZF1UVbtE3aXi2EvQy4s9QO5pLeOXBvyAoA9V8zFZROXhoGTsCsgev6BgjrmFTFdAA55zpbqmYEC9UCOlJ2J235ba3ivmMC4ZyI90hX/qLqIO
 I1sCW+oK
 G4qngrwvupVWLLV5FGpMmE7nVlVXFzexPddp0SpKA8l9C4xlHqbTG+juS2hqZpphvF0T9/jQFDfPLVCPmXbvIF/HEoA8nxfrwHBPRpFubawaNtkv72eie6agi4plDX8/qpp4iS9mXG/hKnZZaKBrl8jsVxxMlXRHofvgOLPgAJifB4vRXFEZvOaCZn216qv8DtOimlm8sRw3BtVg3e+I7JBges8PZ1O3qryTkrc6hTPHdditVNZt8mgE87F5W0Milci2eWAG66p2f1Cfa+Tm5t/XISsSO3dRf2MW7hmVDEUVJmus/9hQAqIJx33XhKLLUjjws
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 02 Jun 2026 18:10:38 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> struct huge_bootmem_page no longer needs to keep the CMA pointer. The
> bootmem path only needs to remember whether a huge page came from CMA,
> which is already encoded in the flags field.
> 
> Set HUGE_BOOTMEM_CMA when the page is allocated and drop the unused cma
> field together with the redundant assignments.

It looks like the commit does more refactoring, please mention it in the
changelog.

-- 
Sincerely yours,
Mike.


