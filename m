Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD546D711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 06:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22D316B0088; Mon, 22 Dec 2025 01:32:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202876B0089; Mon, 22 Dec 2025 01:32:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138116B008A; Mon, 22 Dec 2025 01:32:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2DC26B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 01:32:09 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6DB3A13BFB1
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:32:09 +0000 (UTC)
X-FDA: 84246137178.19.97BA0F0
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf29.hostedemail.com (Postfix) with ESMTP id BFE83120012
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:32:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iu4ZcA1i;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766385128; a=rsa-sha256;
	cv=none;
	b=Q0VBmxjl2smez3N6XN7iGBfeqgyteJ/kGfRnX2KWgWbbmmYlC2CRbl9yPWb2aslOliTfh7
	vWd+3N6Mez5lmXKchE/PMzizvjbOUKAGHshRdUafWbMN9A5lQFsd9Y1SMhmuf+oQB9xboP
	jK3+IV50hj5ISJQ6ZvW/Lry7qv/A1ow=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iu4ZcA1i;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766385128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s6iPmwXAnw1MIWCXIq9iloY9ziGZIeahgVzOqeL0Kjg=;
	b=d2e8r0tG0u+IEiB0NoPgySJ2HYUYgfwKpB5HBehHh6Aq2jV/LO0YsV6dBPJDUdsChVe1ex
	Cmh9XVTmvXRxJEribJo5BIoZKfIou/+P6GM5JgMN828dlCriE509w5PFGN1bD1LAjyGLVR
	gIpXK+Zcj+lrD4+w1XDnAQAOlEkckYU=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766385125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s6iPmwXAnw1MIWCXIq9iloY9ziGZIeahgVzOqeL0Kjg=;
	b=iu4ZcA1iAiPki2z1YLVNViP6Cn9KukP7/o5NwVLvj5FHWny5OWV6yoY+8ucbVUH0Bwea2P
	/c2OfBuzYkhGjx/u0kwMaigW+hlLLt0hwIOxRLse0k8Az0vcl5JOduVDHHPZ6XbtAvXfQE
	7PnuTIBKJB+YBgiVZYr8nDf4WjrsL5U=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCHv2 13/14] mm: Remove the branch from compound_head()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251218150949.721480-14-kas@kernel.org>
Date: Mon, 22 Dec 2025 14:30:56 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
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
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <324C52CD-0E8C-412F-BA33-0F605C1B7AC3@linux.dev>
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-14-kas@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BFE83120012
X-Stat-Signature: kfph6ctx9i3mr1cedjo5gjurcibhd5gh
X-Rspam-User: 
X-HE-Tag: 1766385127-948492
X-HE-Meta: U2FsdGVkX188D8I4lYNPGxbHW/RVGVRNwmlByrxLZHYD5LY1ze/7Su0/PQ+MU6VeF1HxPB8O5Xa/KMPJy1WmUH1WI26LX9yUkOhczl3Us/hdwJMyXwT/hauC44QRe4ShLtKiC8+EeB0ko8T7cHnSfoNb710uY52FOLx93j9mufx1oAxFnHJGS/jjPD0dhcnZhX6G7tlcnQTHZeRuvVfaQW3BKEt9HRk6Ln/Zvq3GYFXquXG8TJnJTW6KQwB+yBoRKZGjofhvZRtWYx856eXqKQkrlvaIEMuqtYMRA7I7Six7y5Sk+AbQRvltufTaLiIjjNcs35/rORW7KqCpLzRAeHXq6erlhNuzmUgV7HkIdWXVS1EEXEVg3uF/acfoKRjoVdpPqJmRDxDNVKulPq14jOzAMsM9eNuuSq5RRt/EoZCGDuXmgnA7yydeODLfHNqGz26UYBjht0TYuL9ASXxc/XcX/wB7hkF4ISN9Cl7pqBLBo48YRxH/gMzDgWw+ND4LKzzXidmJSW1p7qcSUHsZdQcFoc44BRS/rn2LB79FPOFe947qjm318FK4cCluA46Xq0qXeGvXLhcYBwWqJYjudXkHWrxTOMCsTz3S4PNetMmFU1jODJZen1eKuo9s9HXscEaKk0FtOSHSpDTvu/E2L0OucgF1h1BudXo96vBU2Au8Gacl9muW5ygOU2YvY/ZzHaTJW4CHKJWidseZzYVlRPtGvpop96BVda5ABeUrUuBzXKSExoqYhTvERfJLuuP3eRSa9FlaGo3EEHXm3M8Mu6lU+pTS46d2tsbGqGILldDlozxtzhrViX9aC09kY3Z51YQMU1jkCsErtPJS7jQdA+ftWox9g/eyeGL/jJ1OUtAAO4H9RniFuY5yCnGSsICAgLCYqEvgwA4VGjBrI1Ug3pTm6icA4JCUQ8NfDUU5s4NeagRZSvBEuGxeb84CcTPA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 18, 2025, at 23:09, Kiryl Shutsemau <kas@kernel.org> wrote:
> 
> The compound_head() function is a hot path. For example, the zap path
> calls it for every leaf page table entry.
> 
> Rewrite the helper function in a branchless manner to eliminate the risk
> of CPU branch misprediction.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


