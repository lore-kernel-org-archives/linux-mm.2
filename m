Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5792C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 23:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2013E6B00D9; Sun, 20 Sep 2026 19:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B1D36B00DB; Sun, 20 Sep 2026 19:54:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F01A6B00DD; Sun, 20 Sep 2026 19:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE8916B00D9
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:54:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 489D080500
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 23:54:29 +0000 (UTC)
X-FDA: 85235797458.27.902FD61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 74DC7140004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 23:54:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VCCAtqw2;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789948467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iS4LQFnsJmlvJPHkPjXPa4amCgBnl2XHspJTXkSxb8w=;
	b=pu1s/BQRxKLa45UritGv4V+gMDDSJQufcVbeHSEZ4eJ4pFvGw/gSI6sfsY0WJ2jkXPCA/w
	sefKwT3dhZdMMeDUm1KHNvDnimzU/sRpTcxdQRJUhefAJ/3GyklGE9jTfvDbCGKlQ515xn
	SomItyb2Jlbcqe9FXRXfIvVriZNOSQA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VCCAtqw2;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789948467;
	b=RMD1ngklu/JLhPXdUmYmyuYYenq8vK8w9IsSLZu0NSffW4mcrOaRrQWE1YAKGvtGRm7UkS
	kOcWIcCntk2qJ20fMKWwof7/TcQG1k/d3oDgWj1QSxM7hmzYk6eQ6uirwFQaYKNhQEAr7z
	JViXoZd5NMbSnAVbbIeSkCg1FUMegGc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 389D141973;
	Sun, 20 Sep 2026 23:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E221F000FF;
	Sun, 20 Sep 2026 23:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789948466;
	bh=iS4LQFnsJmlvJPHkPjXPa4amCgBnl2XHspJTXkSxb8w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VCCAtqw2MeukxIzYrka53zfuZGq0IiY7H/UF9D6LJhE5JQuxgezRG3Oxq+CZDlEkB
	 kaW3KpymCyJSES5Ri+Xi0+v4Ex6Tac3CSrpCT6cNgsGgKydR/0T89LCU/NnFAmf36i
	 nA1LJTwBGecjbDsaVD0QzqoXA7Nw3dbGMruqxSbA=
Date: Sun, 20 Sep 2026 16:54:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Usama Arif <usama.arif@linux.dev>, "Nico Pache (Red Hat)"
 <nico.pache@linux.dev>, Zi Yan <ziy@nvidia.com>, Barry Song
 <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Hugh Dickins
 <hughd@google.com>, Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett"
 <liam@infradead.org>, Michal Hocko <mhocko@suse.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, kernel-team@meta.com
Subject: Re: [PATCH v6 00/19] selftests/mm: improve khugepaged coverage
Message-Id: <20260920165424.adbd45ccfc6162ffb0e4b424@linux-foundation.org>
In-Reply-To: <20260919002451.496763-1-kirill@shutemov.name>
References: <20260919002451.496763-1-kirill@shutemov.name>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 74DC7140004
X-Stat-Signature: 1bzs761xsnj15aau4nhbyqmp5u6m3kk8
X-Rspam-User: 
X-HE-Tag: 1789948467-229068
X-HE-Meta: U2FsdGVkX185qADKbiugybq8ilHJUtIcZ17zLHDERHiKpz40S095LXsUT1C2YQ9y6TlCvHzdKWhVJpF/4mqs30r9J3E/AfkWS1DbFbBywXjDl6cISJUupyH6rLQWJES4dGXvQB4Z4nLZSbKQD0DS2f2JtM02LuvpQxWOx9iZKdXI9NvlAV/kLKuK0H3GhUDReY/TbTszZnhWdudPN6e9vi25rmvohzQPF4M8tR1dBBbQgvmDrP2D5XhbQ4lj+zVsZSsNRjrPe8NUxO+XLdGx71XVQz0HvVsH1k7PBWNtSAJHj90XfCKgGTyklJcVjyHxevmqXcXbRP54Em4sU6UEmS4wH6ilyG96EiIC+RVOCIapn396oAPj1qguho1T3a9MnmWW8EWVnl1F5Kj9OKpL+NncP2aNNkvsWor3FeGBTBb7PkxbmKrOWJ2fqVVuQ9AvV3RKRuERBLQMX5p8A4z8zkqDKq13ncRMDrEOXL83iwefqGr350otpsEsiS2JE3BwHdzhTIcMOIx3xcg4VpOtOHkRtwGA7SK2PBpTzVtA5e0mcf4djX5xYKdP4Y5QM8uIvWHke5AzR3lVjH7imuIdHGxTIS0E6UXskdNXqrChGQbT2Cz4qW3P0hk/IXaXMVRebBq7Z5DjKTa/rrGSDnuny8Qmre9i1EnEi/8lVg7Fy2zWQE3x6rzbuxMAlMKqhfRfsbEFPQe0AVZdOLzdwLN524SMs1HOhkoQT069FZtXl9+WkdQbRR+5QxV7sq1331bN1uhSsz5SCnOrlIENVTtDoS5qvfMbid3C4ThhgVtyPoPdY+EqI2rB2EzW+1MYPrc894k7RSqIZKfStqnLguv6XpUC8h02vckfTd3+LuoakGoO1AqmXRECoqtmK04STNYSpn5u19RMZ8P3gOpdtxb2rimBeR0In+TRjxKTFJt9HDshJxBJgi6HphaV4cMWZNpNB/waKyD9DvOpwoBe2rR
 CScRfLa4
 MAhgwJyzEMD2HO0XaoxBa9SKiQnLajFx7+1hzOqs165tP6Gnl8dl4ttHp0yrLwQgFECW5tWOPVNNtHEtToVsz7ujHGbM74faLNNIPFxPTP7xtZ9Mucgu3S0CLl9uG9230AdADa44KXsSc1dSmZkv7o/mULtka3TuIaCUQV+xVA/Lip/zGrQo7cr4KmCp9yOBnTDbRJwk1M4fLpKfPYbpVO18UA0DagZ5CJUU2Xs1P/3SAnELqX7wrChihWSVRx66Vj6lLbWK8WXvn1cv/QQeFnXt3UA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 19 Sep 2026 01:24:30 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> khugepaged collapses to mTHP orders since 7.2, and 7.3 added three
> selftest cases for it: the generic collapse cases run at one order named
> by -c, with the result detected by counting folios of that order.
> 
> That leaves the collapse path largely untested.  The suite does not run
> where a PMD is 512M.  A folio count cannot say where a collapse landed.
> Fixed sleeps cannot tell "not collapsed" from "not scanned yet".  And
> nothing exercises collapse under contention.
> 
> Close those gaps in order:
> 

Thanks, I've added this to mm-new.

I'd previous added v5 but it never really got testing exposure due to a
messy interaction with other changes which I didn't get onto fixing.


