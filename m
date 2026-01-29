Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A911D46C01
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 02:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C49B36B0088; Wed, 28 Jan 2026 21:52:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF7C36B0089; Wed, 28 Jan 2026 21:52:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD93D6B008A; Wed, 28 Jan 2026 21:52:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F68C6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 21:52:39 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 650B91A087C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 02:52:39 +0000 (UTC)
X-FDA: 84383478438.15.B72F8E0
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf23.hostedemail.com (Postfix) with ESMTP id B05D2140006
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 02:52:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zsd8oPGy;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769655157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUUCdyLNfxqZr/JB01jIM2hS9AGiun290KshO5xiDNo=;
	b=vGdABjPZJwGE7WXxiQrxrEaNPCkhgQAMuKyvnlqQfK1irYRwVnwCWAA5SJ66My71o5EH/f
	6iL83j+ioNTR3d697H19fmTpbPlM/w60O+gwOE/5XhturCBgVVzknw3osI+yz/6+bwjMzM
	UISiKU+ujzxhugAaQiYteF7X/0cyx7o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zsd8oPGy;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769655157; a=rsa-sha256;
	cv=none;
	b=CgFsCxN/r+PmbZW7DlTWTlAKTbOsW6w+BJg2i+Re6ZdouzTvhowbji+3/8/vBEBNKztRzr
	6eibHipuSzsR0jug+yra3bhzkplH2+hEOuFx0aOzNww4o3Xvd7iOgu21sVDl9Qeg1JXxUS
	rE7dJOjmPS09MH4biUBjSLb54AB2fwU=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769655155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zUUCdyLNfxqZr/JB01jIM2hS9AGiun290KshO5xiDNo=;
	b=Zsd8oPGyu5Uk7qrMcCaR8as8UdOPm0CloBX4g8v2jaMMG87yYzKAcVcuJedg4e4kWo99Sa
	NPGVL+lCQu5BYDf4/XNR/VoyJqvKO5RNqOfvzWLYF1jd7rZlr/qOld56WiPELa5NB9KUBH
	hkDYJGOnOocrlW7Cn5jC7PQp16cezk4=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv5 10/17] mm/hugetlb: Refactor code around vmemmap_walk
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260128135500.22121-11-kas@kernel.org>
Date: Thu, 29 Jan 2026 10:51:48 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org
Content-Transfer-Encoding: 7bit
Message-Id: <1E5F65B7-59C0-463D-95EA-808520C14B85@linux.dev>
References: <20260128135500.22121-1-kas@kernel.org>
 <20260128135500.22121-11-kas@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ieohntjfcibba4y3hhcyqayhggroqher
X-Rspamd-Queue-Id: B05D2140006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769655157-342321
X-HE-Meta: U2FsdGVkX19InJa0No5NoL4LifPyD7L6swsAmRbWQXCiMh+ukXzlwTCC4XnaQLXM5EjnOItvt0EPF7+rzwlq6HQOMyZaoBcsGyZvIgBLMbAtf1HmhhkAYXtY8q/s5diOSxcM1eXQneO0OEW9CyHWgvw1NWOD/d5hNBNa7iULuKv3+t5htgfGiXM/LiDr8BzsWgI/BQD7ThAA4IyaOdyOZDAuG36H6XMuGekZWilXB+jAHYvbaqIIY8TdIDu99LJBWA/H9xdK0Lw/x+J297KrSziE0DQUalLhV3uSEVUGUzuuTGRPZmUnZqxXLbiRx9YxG+0wOykNF+7vcA4wXQIE/dmqEFugSPtZ9Z5yqxPhO15RvT3+zP/uojyc0rbA94bzGvpA2OqJLeP0cM9GxoTLoDOZ5gN0Y8puxGsLrCNImKg29BXjRyvE5St4oRINwD91tLLFGdEC0zBp31YugkSmTyXkyvfyELHzSqic6jitQhCePwiHLJoJ73vhMTM/CFctdRYsu6DeP3+VeL+4r6I1/qOAs/Z3mgoTJKsTqhFgirYLxqGVp+spzKgNk/O+WpTnHviYFe7gKhrTaS8JIblJiAy/3DKs5VsARsnZd/oR4zm/rg/qC/jgd1TkauHQxExnJxepiXLyiDiCJB18MFR4y7p3uzAqVFHTgXN9uhiAbpK+yR6XI0wF4chAd8CHxLccB+1/8uU47vc4AlvJhzGudayDHkZTHutYStiSoLM4eR4RUl2Ui1zzmN1WD6RZCBxzhRaWYal7beMXvixbQzckTe2xxyqJP47wVEXq5TbvKFwxiWJLBrjdZqij5B+rULgRZlBzJ3EyAFfjj6q6WtrCOWfXEvwdI9DjblVlpWSd5ib3YncFqSCg3sPGCiNPK1x4ENm4yy8VFziVHpCRyThUubbaHLLie+P0MyYynIs2oJ52ZZ8h+dpafYyAB2W8kYyO+X4F97lr6gbZ6KbtF61
 pnmuPojF
 eIGNKlP+3+L/p5aA8ZDJYjpRaRke/GjbBAS+msKLPYVOpNd8VAadBDtRLZ7+vUsz+oI1yfa9hUamlO8uxVzNUo2ZAmqbSpaYXRyEn5rVcc5Z5UayH6KDPAjG85CW6C6j4ZV68bOroV99gpWbwvC3M3AFvNL1yln/4egg2UvSyjGe2AY8fRztygDR0WxeMvSvfxF4io8ySVzam2Rhep2VwT5FgW1w5xv1v5FgQlmA81GoyAyKEOhOzR+0xoJBYFwF+T1Ci5WBKWpZeTqEV6lKB216F39iW9xGtZaCe1+7U+2U+0cODXSJZxrYSsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 28, 2026, at 21:54, Kiryl Shutsemau <kas@kernel.org> wrote:
> 
> To prepare for removing fake head pages, the vmemmap_walk code is being
> reworked.
> 
> The reuse_page and reuse_addr variables are being eliminated. There will
> no longer be an expectation regarding the reuse address in relation to
> the operated range. Instead, the caller will provide head and tail
> vmemmap pages.
> 
> Currently, vmemmap_head and vmemmap_tail are set to the same page, but
> this will change in the future.
> 
> The only functional change is that __hugetlb_vmemmap_optimize_folio()
> will abandon optimization if memory allocation fails.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


