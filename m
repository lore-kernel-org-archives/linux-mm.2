Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7233AC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69C9E6B0088; Thu,  9 Jul 2026 02:27:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64C586B008A; Thu,  9 Jul 2026 02:27:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 517EA6B0093; Thu,  9 Jul 2026 02:27:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27C296B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:27:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AC5761A03DB
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:27:53 +0000 (UTC)
X-FDA: 84968257626.16.93FC660
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1702B40005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:27:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uH2GjKKm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783578472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5f7ovyMeuQBVxzk16nR6Y77IhINRfWNNovgtJ4wsQcg=;
	b=SqwPdzDidJDgLU7LNZPmED4Dy4mdfltHatzNjZr/FmdzM2omytGK+/IIWbRRKbsspIen+Q
	D73tMg/F+f8S5VVoT0XO8GYFjNurWQyKb/4U34buA9rpwhm7liuG/DFVnjJg/fy2bPyfD0
	kDSQ/2sYt0jy6E9Xh8vwG7E/x188DJw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uH2GjKKm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783578472;
	b=M2aUxrVgGuKaa9Vl9D8oJ4UIYvPT/dahVTggcxowfYo2a6mrukoz3SUyboJ2d5BfegcdCE
	yzvImlz8Jb9kMZaYH/Kr36IdSJqHT29Db3Koqf7oy8D8aSZh+DzjUnRN6XsiG8TKM9zSi4
	VtjKD0mkUBethoYPFIZtimLJs/BNeGg=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783578469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5f7ovyMeuQBVxzk16nR6Y77IhINRfWNNovgtJ4wsQcg=;
	b=uH2GjKKm56PnMZShIt+1lrIf+5AznCpyBkxqE2QoDu1RAb9Yuv28fvS4g0ETk6HpbJBAac
	vmxvZgGRgg1TLanQrXAOBHc8N4sqAj/Yf8sxqNBkW1K2qfXq+8yckgEviizJAhV72w1xy/
	DSqKxINvzwgjhaPNy3qeAEBRCyjDZ48=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 10/10] mm/bootmem_info: remove
 CONFIG_HAVE_BOOTMEM_INFO_NODE
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260708-bootmem_info_part2-v1-10-156ce4986598@kernel.org>
Date: Thu, 9 Jul 2026 14:27:09 +0800
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 linux-s390@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <CC6D5FDB-E447-482B-98A3-072136A03FD0@linux.dev>
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
 <20260708-bootmem_info_part2-v1-10-156ce4986598@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1702B40005
X-Stat-Signature: ghco7upja4c3wqbrgh86ymmyqj8stonj
X-HE-Tag: 1783578471-217684
X-HE-Meta: U2FsdGVkX19JP8STFHBDkS93/VL++aNaCFyH9WEaxYrSlaadlSjJJsLW7kn+QD8GXRUiLloXdqVUWI9eK6EN2EteVhRHMlIUnSydPgXBGLpZRfyPOl3UfEimHTJDHx1VFEfsnGySuuiga+hbKCQJyPWBwBEjc0YammSjLqv2iTuvzb/bidTorcL3r1PE718ho5boTqt+/I+2yEg+1NNY4VV2MC8tGALHlfFq2kWpwZRnlYaykS7Az9vHV68FfS2D8bn37vCs0iGSB47ILhLRtaL5mgAvmmKDAdaR4tfwGVqPsVlugM5pq69FtD695q9mYs6TsCtFdQ+Sv2syUiKgV7rUh1oRE5y0q/idrOqr7n/8QcDc+hkP+F25axrKnO5KuZX2ptAV7qONoAWYSZ1ZJ2ouYT29ubWRINGtxOC/OmGpJjotuW+p//81e6W0aGeQeXTMjXEoTI85dpZeJJ/Pi1amif1uTs1ZXPKX9HmOrj9NoNElgwjIrwaL9eVyQOTrpKYjP0El91W30qxSAiv1ZW5esE6zc32jm9EUaYK1RQy7Ii6rp+6vSYpXwR4gb387c8gOju93rKHtqTefpUpXdHyFxjcjwI5ShKhiDDecQC0129C88QbrXsjJ+53fWtMKmKMgKpKfabcC8kUTkLKZ6PmAr8eNmEXetxzK3N0qEDmIlWi4GLP3u/gOolRk6GHrCAgytAYFuaoUg9rL2028W9gUO2jp6pKaMoQvuO2oMyizHkOtr1bGBrhpPo94z22BhUkpwoRUf7tauS5KbHM4ASgRGRFUi5CCeKCkkOLpVO93T3bSLWh0s/ghX4NwyZIEw4qeCrP3kGCQgmjNH26W1Qa/Gcjyx29i9xFG8o3Rm/zQAqyAE0MG5W8Gz0sSXze7rrHRvNk9+k+LMO9BXWvUji0DIYKrJ43FAwsGfcLL2bbpt22EkMjUdNsRDjvkEfhrBUg/vEgNpqoojmR/MRC
 wkdSss/K
 GgC+vaeGzOPfOHAbu6qpewbyDnMR2wgXnaAi43u53K9xsfWnNUOk4H/zRBFSH094bIKRIM/Z54dapb14fakBk1+89+IJrrCBB9iIdWluEbKd5hmkHFx8FyNQVV4Yrfcy0g8nRBgN9TdeHQbqbws+2jFAC0iKAY7Mo/+MxKNd4Cv/xXg3azKs//SLq9T//5SgWmt1YMygJlc2amBJ1cvlLfnLIgFc/Pj2JVuWkjVZGnjiHaA8N0mZ/9CXTEkftNm+YiI5087gNzyQnzfZlBy5LrhHlZPWgZyZUIx2Zlwb5mFWDKKkoijrRhIb9Rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 8, 2026, at 22:11, David Hildenbrand (Arm) <david@kernel.org> wrote:
> 
> The whole infrastructure is unused now. Let's remove the config option
> along with mm/bootmem_info. + include/linux/bootmem_info.h.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


