Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA1B4CA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 09:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8430B6B0088; Sat, 10 Oct 2026 05:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81AF46B008A; Sat, 10 Oct 2026 05:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7304D6B008C; Sat, 10 Oct 2026 05:58:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 536BB6B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 05:58:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0D0EA84A8
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:58:25 +0000 (UTC)
X-FDA: 85306266570.09.34E8D58
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3A6DD80007
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:58:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OoWXNSPm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791626304;
	b=3BvaaduP3kdWZIyI53sjbVEiUIYAzdCC6uPUNjV2B1SF/Kt7VwkJqPbohBsPfPZvI24wXY
	stBBbZQwjbFLu8jboE2tHaumqeIhV2OXCmntO4e4JOD72YeAiNqaYAHhGFvRRBuriQmabI
	9ckAc3yb+vNAKPSdU0wNmTG/jiczEAI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OoWXNSPm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791626304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QvnkvLtda/rMoARtnwYn7sNzYphFVMCDdG5HrVdsEsE=;
	b=2DFPEhtGh9t4xnIHpm22Ymvu/A2WnFS6vVWZxCITxhcbxsMBqFYx4IemJIGEmOadzqM1Aw
	66IilgTBRRRcyh+fS/bSk+BCx+HLo05cvp2AoNCMKc5A5oeMUelpoCwkqa228/1jV6/UNG
	L4JpJ2Hpd7ghxxgMGJUsaT5cStAKa4s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24314437AC;
	Sat, 10 Oct 2026 09:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC8E1F000FF;
	Sat, 10 Oct 2026 09:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791626303;
	bh=QvnkvLtda/rMoARtnwYn7sNzYphFVMCDdG5HrVdsEsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OoWXNSPmC7aomO/qL5FrCOYGUk0MjGnEvvS67qACxOjUNH3ibjhLX9Nq8BunMAM6c
	 IpWgnn8nCsJZgc1iisSfTDUBg+w2Er0od02JE3A3L0EAIEX54dJ8fuA5zs8T6HZ4eP
	 5dDZGQ2UUR//Gvmrw/NEj+hNEqrz8bZF9GcWzdi1RTYvMCKvfcIfs+FqsVfpvQOCNL
	 NtHwWMNR/aZ5rvbXyDlyzO11KP1B4lLEJjdzgGk0AULtyAL3vCw/DNt8WqIifzhadY
	 jkBh+EOgJKQnOp6G2LdCynMkuT/rfkdntoC8zzVFbIIz3hLEWCfz/BLBfnPsPNmytU
	 uo+NxkfMgn4FQ==
Date: Sat, 10 Oct 2026 11:58:15 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 6/6] mm/mm_init: add zone mismatch warning during page
 init
Message-ID: <asoMN5F-3qvaW5w0@kernel.org>
References: <20261010075755.83339-1-songmuchun@bytedance.com>
 <20261010075755.83339-7-songmuchun@bytedance.com>
 <434B0573-BF18-4413-9BDF-C5873CC13206@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <434B0573-BF18-4413-9BDF-C5873CC13206@linux.dev>
X-Stat-Signature: d447yy3r7hpiwz4kbjfbwhzsh6jk7gdd
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3A6DD80007
X-HE-Tag: 1791626304-835224
X-HE-Meta: U2FsdGVkX19+5LRn1qLaevF+1FUHrlSC7iZ6sqLvFzYK7o4dGSx/n+kR+KZ4om0ci83xORQJavG5X2YGsC/7FRvx0EpcHapR0sCQhc5qa0fN+6pgxj10eHn/Ql+c31BdEDGcroOq5+Xetr5RVOWaWnQyXr5M9WVSn8RumMGpHhlyz7dKmFP4VxPlhgT+YZ62Lmkeh2FFBIVNRzgpD4f01XGNXN7dTLgid2Yw6b4PwegCrbwUX3z8lyB7Oa/bcWhUjv3TC+bKBnUl8eSQM3i3duEXktSNag5NucNWxTxBXuclERwq2qR8d8YxAtUW5J+un1QopwRyNuZU1zGvPRAww4Zl/cqrS6UYrQtlTkiqYGwqAb3MIOgxlZhXH0DngOa94IAwNVQhMehBv7l0GKfYsBD0STFv/8kToaX/NdG87UjxTAv74zKRcIpf5KwcVwf7IyDXi4f/Vvml6thT5zFXJwwoxr0+xHeDWe3SL+lBktNTJfllBXgfWw2/WsnsV4cOuSHfOT/rlKchx/qjB+A0SsCRiT5ffiLnHMiuveziWcGkx9usEdvYG36V3LnivBjUTbTSsKZRusumvBoNV8G2OWQwDhJ9KojeWBXiNP74iWwHF5nZkMEgUf3dYxDZ5j/X7QhBj5244LhwQg+KYbvgr+omId5cUU9D0dPc0DSfD1wP8U3MePOZkRlM2gOvF9DjAXhRIhCJjCCsbME7tGFkeCu/E0syBwqh8zPzUjGP1wnpmnS3WKB3m6Qpo2bxz4SuuEwZunjp0XTVHjF3GPtMpcVg2E4rCcbZGOQpddkZ/BIvqacPygv01ur8sHygEhkbXtN8m0eJLP2N5ncChzTEjHji3uIt6PQsCQSp3SkD6sCoX0ySTiEMemUxF6FR1M39ywbkhIsqPb0zHT3qIGfddfGavUdE3/RsNOlqFscLhiH+KkxQG1vpCzM8cJ48phS/QvwP/rNA1ysp7sMlCZw
 43BrPLkf
 gjddPKegWvtwqAMssAsTQ2h+WyQKDsZu8gbmwPbDPIPJmhM0LVgLbZjYYZGxHCaYvvOuZBHClWZJ/55zlqKDwEdTsaA2BHRlNrWsyr8j47tJ1yAVsCxLw7CmO/s25Tx/sqgd+w0lbAlx+LC7MJuKqSQMb9tg1oX7k5YRxIp8ANWfiQwvJguYYGxHGrCuEHJo6HOck2yFdpypi8fd7A+AQAWmaWhOdAp5YdS8Eb4wU3F5tQTh86QsYkMJNWlNFTpCDQeD5xIoIp3XBJp2j3codvEICAJ+y61RIbmAS3gm9KICudIE0L0O6wmONPA5rmqSJOWqX0+q1DWMe1AxUPsXp/vffVinUw5J+Qx9tq7zojihBxN8H64TGJR24hSsZxi2ND6yiOHCqMv9PfzV/a3FC1OlbqvZht4BYghVKWLWmQ2cKAVDm9bBVTi43spe/EADcpl8Q5Ff0LK8nhj2JatmQ29Shvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 05:32:59PM +0800, Muchun Song wrote:
> 
> 
> > On Oct 10, 2026, at 15:57, Muchun Song <songmuchun@bytedance.com> wrote:
> > 
> > For vmemmap-optimized sections, tail struct pages may be backed by
> > shared vmemmap pages. Those shared pages must carry the same page zone
> > ID as the struct pages initialized for the section.
> > 
> > Warn in __init_single_page() if the shared tail page has a different
> > page_zone_id(), which would indicate inconsistent initialization.
> 
> Please ignore Sashiko's report [1], both are false positive. It didn't
> realize that shared vmemmap pages are initialized early before __init_single_page().

I didn't realize it too when I read this first :)
 
How about a short comment above vmemmap_optimization_verify_zone()?

> [1] https://sashiko.dev/#/patchset/20261010075755.83339-1-songmuchun%40bytedance.com?part=6
> 
> Thanks.

-- 
Sincerely yours,
Mike.

