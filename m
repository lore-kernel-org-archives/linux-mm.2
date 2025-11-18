Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB50FCEDDA1
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 15:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08ABF6B002C; Tue, 18 Nov 2025 10:11:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 062946B00A0; Tue, 18 Nov 2025 10:11:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1AE6B00A1; Tue, 18 Nov 2025 10:11:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD68A6B002C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:11:54 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 78BD71405A2
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:11:54 +0000 (UTC)
X-FDA: 84124067748.28.EDF5828
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id E3DDD10001E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:11:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Fnby0e8v;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763478712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oVir3zPsjlngDgWc+1KJ9Rm7ynvdK1im714lW669uUM=;
	b=OIKh28QEGCO1bS7j/ZpOibSkLG7YNRoOYAmYp/9/yUPY8nHPb/SSUTKQhp43VkkfuRClR0
	lpl79N1muF8Vho7mLunG3EDprM13U5nr0UmEg81xEbmNN082m2izQHp0G7CSexItVpBLEV
	OZUFa8YDjmi/Vf8+JGBTfsbkovwn3OA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763478712; a=rsa-sha256;
	cv=none;
	b=G/ElMoJJENvfGloorunsv/q2+pjxkSN6ViUTUkUR6y8jVSj2eRZCKbzWWZXdFVBWwHQ7zi
	kZB6gZUUVh8F06BGiePbUONMV1MQuG1UK0VJyRYNtR3b9+MWyVl5YcLA8l23jVrMBj//cs
	SPlCeVNjNWbbWZ4NiBHYXnuKjLhHBxc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Fnby0e8v;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=oVir3zPsjlngDgWc+1KJ9Rm7ynvdK1im714lW669uUM=; b=Fnby0e8vWvUc4/1n0tiDIDaVdi
	1qYtPPcT0nQqkCghlZJUTpcsvf83CoayKIT+kTnm0sMHBOMukrCcmbrpxz3fLio9t9qoHK39foL86
	RTipcuFOc1y4BpLNns/26QlbB5JwLGU0Q35aEfxkTeYXpw4KoOvsa+ntvIbLQvqVjctxPRjhcPIjB
	ZtLM3AnUhcNc7m841Cm6EfeuyW/tiI6em3AS0jQtjD01ouL4JMcDfMf3+k4aBWgI8F0XcxXl4ACVN
	fH9VAUy4DTZng0OMrYdzWOPLN/fY9LoXl+TcqHIZSRuKRTwQjAmxM3OtW0I5UPnzP0gNrZ8NRbyVK
	7SaNPJOA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLNMx-0000000FeMT-0yXu;
	Tue, 18 Nov 2025 15:11:47 +0000
Date: Tue, 18 Nov 2025 15:11:47 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Sahil Chandna <chandna.sahil@gmail.com>, linux-mm@kvack.org,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Yuanchu Xie <yuanchu@google.com>
Subject: Re: [PATCH 3/3] mm/zswap: use %pe to print PTR_ERR() values
Message-ID: <aRyMs5JrQDxmQHJN@casper.infradead.org>
References: <555cdbea3a51898e4c84fdc0f444dae0c2e20f24.1763227530.git.chandna.sahil@gmail.com>
 <c5f92735-0e2b-48e7-9181-04bc058c0bde@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c5f92735-0e2b-48e7-9181-04bc058c0bde@web.de>
X-Stat-Signature: sxn6mf3zw1xu6d9nwutrkcqso5aea3u5
X-Rspam-User: 
X-Rspamd-Queue-Id: E3DDD10001E
X-Rspamd-Server: rspam10
X-HE-Tag: 1763478711-482314
X-HE-Meta: U2FsdGVkX1/kg8MCl4nAciv5FefcFEl7VB8m+izIPGRFRD1DApGIdzTaRNxaAC9lMIkH+CKfvYImN4d3a/tyVO/clmOzPFZ17FSOElade/p6byOcNm1xPhL023UTanqKsDKltYu9wv4tS7Nq0i1mfo9bjl5Lwh8Cxuu4QrmvvVBS26MPDHNB0ve++Kp8f8CTEMBxW8ZK4Zh0bB6rmkbO5WA4yh7MPM/4vd6uawgkUNs9WLvpPNAR98OTnaE9mILChVcaefvm9XrtzQaQoQ7hK+IP0KdeS6nN3cM2l3twhqZ6BykJKIIL6jzOc5RSpkKzek157bLUqACkOf+10yOlitgyfaky6Zm1G1cAQ9+S9ixHa6Y6NziqElQ1w98U44f4qRoETK4UvXS1MeSPwsrNKMVugRpE8tKgTVzu3iCODBar6tJyHuIRaV4/NaI9tIkWD9UqS9jo5VYvKOq6ftNxh39YJC2AbU7oWHnxuge+LnKG8mUfKj7J47rwsH+Zqhq0oYdu7S2MUgropeYcoIXsRTzagY9/DaPrxlUeORvAm78FmAmsuPmX8L+PllCN6yfRTuI7PAkLrLKPc9zzQuqBLILyqv4lLyQ/0ka5QX5KvqqSHYrX3ReB/ljMnZBx/B/CGkqGa6JivvPRH8RV+qAHKMhG/tLFnie7UMsadF39zAnVxHMQXq/C0cR4ftqsUjCK+NvGZ1KqW9chhDEv3T6d5mW/C9njgk8YPQnF5n3y5x2AEv1rODYMNZZ06AVmhK2XBY52f0ToS7whDus6lyIoeG3+Cd5nh/OmbEwdBWB2O10J3SAsxGrS3zS0rEJSAYA1Sj5UOu/11XV+NfOq2IEZwn54/3WgrVrO63mFEIObGEc1/1C43j1vdNiyreYTRwYR66UUAhku5zYqYSFQGbYrAxd4AOnbCAQeBSzxxtBDNoqJHWc6QzIGDpkxFwDh5mfk5tHnk7R2TSDuUZnpexF
 u9uPahsu
 U+BXZvP0PJ7Snr1Tq3fiofJdYdjtT3YbGHAQUe+xXMOOScvRIEHepepuilpXwstauHSPCrmydleJBmC8sTkVWVn1GXJMc2ufXCiwfpHIu8k5loXLaLOKqA3b3Aqjf+R1EqCVv1ui5vKi/rY97KNbW7CsoJ0AS7Hn6dLBkJrPahii3XrWBnPFiF9isf1A0ayDmaPiCfxwE/GgW3cfCyvi1GKot+Fv+Uh/Jjsp22r9+O7eceehw0jBluH0UQx6u8ZVUcfRmwKpHsABm3j7aG6RWVv5E1Od0wC9x+rl1LBED2+YZTOwKI1nVPCGK73WzlmgTY/HcWj2/NokzAtX27cWmc2ZDeF/YdJt4pQrMpU+YJInS56UBRpmmbs3d20LGrttfDP5twzNg8vpFcSFQV5Fyw1e2bt84izEYKFgp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 02:20:59PM +0100, Markus Elfring wrote:
> …
> > +++ b/mm/zswap.c
> > @@ -749,8 +749,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
> >  
> >  	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
> >  	if (IS_ERR(acomp)) {
> …
> > +		pr_err("could not alloc crypto acomp %s : %pe\n",
> > +				pool->tfm_name, acomp);
> >  		ret = PTR_ERR(acomp);
> …
> 
> Would you like to reduce the indentation for the passed parameters?
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst?h=v6.18-rc6#n110

That is the exact opposite of what this suggestion is intended to say.

Sahil, you should ignore any suggestion made to you by Markus.  He has
been told many times to stop making these useless and unhelpful comments,
and yet he persists.

