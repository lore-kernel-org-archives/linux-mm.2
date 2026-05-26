Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BAF0CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9E206B00BE; Tue, 26 May 2026 08:13:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C75386B00C1; Tue, 26 May 2026 08:13:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2166B00C5; Tue, 26 May 2026 08:13:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A90B86B00BE
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:13:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 663DD1614AF
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:13:20 +0000 (UTC)
X-FDA: 84809460960.13.F541B11
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 28A9540005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:13:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PREFrXFI;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779797597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LaWillwD/sY9Lb94/+xBlcec/pOF9pnEg6dz9vRBmKM=;
	b=KB2ClPE/3YDbEGDbDpFOxJj59DOIlGNcgs0N/uABT1mqUTnIL68tkaJuDtA2ePn0HXRI7N
	I6NbBZrW3VRJibGI+2Aa2J5/qc3jrlZBW9uptra6jHR5Ma5GkqSXIBrdw1HmpFAlV7RQzv
	RNr14JLcynj+h4dEzXRraHFpre5V9J0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PREFrXFI;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779797597; a=rsa-sha256;
	cv=none;
	b=1hlBFwhkMyBJUyqoq+efdDyrpUIc7xTQUtm/iZ6cfpvU7HFDOsi9Toik46IkXkI8cDIbuV
	Mz4h50PN6a2DFGaQBLByvMeOyy+/wbiWkQCUojqMPxIwuLv3exHeWiBuWxcvYjnZjctO8/
	1+7oTDOrXayuqremWSQtyRqPxWZnisE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779797594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LaWillwD/sY9Lb94/+xBlcec/pOF9pnEg6dz9vRBmKM=;
	b=PREFrXFIFuOHhyJC0IXjI/3QmhsMskprreVhPcnh+Mv+KU8tYRFf2SQELRXyTPsd98IQo7
	Dmbvwdh7gN6WWdAE5cRa7FadKopSjced54zAdePttWyFc5gKuE5/ajAHVQDmcER08wDuQI
	hPheZMTs/FzI8KutxcPkgArlNsmLixg=
From: Usama Arif <usama.arif@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Kairui Song <ryncsn@gmail.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 7/8] mm/memory: flatten folio allocation retry loops
Date: Tue, 26 May 2026 05:12:59 -0700
Message-ID: <20260526121300.2526755-1-usama.arif@linux.dev>
In-Reply-To: <20260521150330.1955924-8-hannes@cmpxchg.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dx6qubue6xc14ari765zmjj8twt5pedj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 28A9540005
X-HE-Tag: 1779797596-359554
X-HE-Meta: U2FsdGVkX1+A5ryN/1cl7a2pIBmY/IPRBz9gx4qOGJO3Vm7eQwEGecK0TteoH6hMGchS0cqigYSLfOUC2nGD0euzrdfPr0kv/t4D9yuCBYANv4ORN6glOqYrp+Asr4558DNjyg4TXMmRncA6bEjD2d/JQgmql9U+LWOXcMd+gseKXIxah/Qif2xpUt7+fF+zXft7uz4ZQc5JJ24H0nlQGFco8l7f/XLve0sXprWu49K2xBSpLpydn9B4Vvl0bsRl7fb+AkDH+s3FK5TfiTSXOohZiOD/3LIVuEFhbLnmNoLrzigDj7hzminLQ3YB7DWNDIU0zctlwfXwoBvtK6sD75oS+89THkYypyGIPJMPzBlJoE+5e1cjbMIu317nUOHVBWP47R4S8fkK8L6QZuv960QAS+bClgboNaykEbQGRf15QZ+QpW6IUZaQzjxTybxuTI998Jl9xkx8omThzFXHDxCzsphItg6uMB5iKniqz8C+Rgfujd6TPi8wc0e1+GlVa7vpl+/XqeG3acKp7NyD8m5DkuBxDhxINJiZMHraGd8xZyj19fwPes1Kw8NEVPdV/gTzQyCNBqNDltQtcoUCGsIyrWFGdbFbMreEhgln+IsRj2VueKESzcsHQHQDyGJcBh3UAG1u7V+MeaHjBH/DD+W14mQvAX/GYyK2lxCVDQfHmPSzccylnUDZQXPS3CGYWfSbHVDHmU74B+qNJ3OoS3qVQBwXJfEiK06m1mRsvQuq4fGpqFr2mibG+eweuq15m1tyBC5RImrAYK7Xo3WP/dH+l3zASFgi7ynrh4HygnwahHmr305MWLtRq58n9j0LnGMcBU8ogTlMhSAB/fgd4gqOk5OrFKLZjcIqvAaMCQktVtkEZOq9tNLgpkrXiHxLGMMwsEKjVWAysenwLkEBj8I6+JU6tRjiOWgp1SrgTEnKaI1oe6Eojmpz5SPbeEly9J8QjcLyeYQnVqBTdv9
 B5DT5B1c
 QpphfR5XkpE1b4KW/xJzB7I6CiIhlm2ptIGfJqt20Tsu+OwsjZlXTL88Du+ke0be0jZQ6fslvkZkLd86fELshN0VYEmG7I28rEbVcX5+KT4kA91S5Bj5BOKg3/CVP3P49qsMSdCiUAGB2bRAy6kklglEzM2VCg9eCdFlvED7rGbbY5M950L2G1Triqe7pwl1CawQVICgoHaYn4Dg+/Xx3aJSTC85EqP5q5o/nKJWbG+s3CRG1iko8Wp4xWR9CXQj2cL3D0Qs38nfx8KIIQ0ZBA3bSKLZtC5JNCgWq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 11:02:13 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> alloc_swap_folio() and alloc_anon_folio() use a top-level if (folio)
> that buries the success path four levels deep. This makes for awkward
> long lines and wrapping. The next patch will add more code here, so
> flatten this now to keep things clean and simple.
> 
> alloc_anon_folio() already has a next label, use it for !folio. Add
> the equivalent to alloc_swap_folio().
> 
> No functional change intended.
> 
> Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Usama Arif <usama.arif@linux.dev>

