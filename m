Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41FAC606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wJ5bWs0N
Received: by kanga.kvack.org (Postfix)
	id 51ADA6B05B1; Wed, 18 Nov 2026 14:01:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CB9A6B05B2; Wed, 18 Nov 2026 14:01:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2A36B05B3; Wed, 18 Nov 2026 14:01:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6616B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:01:59 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F8E81A02F7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:01:58 +0000 (UTC)
X-FDA: 85449159516.16.2487AC4
Received: from mta1.migadu.com (out-190.mta1.migadu.com [95.215.58.190])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7BBBFA0005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:01:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wJ5bWs0N;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.190 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795028517;
	b=atKNs+swYn8cCUY4gUo7jb6DQNKXaaqhj/t3eyBcmIOgodGPCGxv5d6LCcAnmfCico16SI
	WnVvUNRo8gRGcOmE3pK28c8zenRbWQMvc56N2egOPDL4ncyU369M2wPJrnSJ21wDIbBUSS
	wnqoNbOG6J+5kVjPqlyagZbHxX52Qfc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wJ5bWs0N;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.190 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795028517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EjJbHgwgcxNqW53fLeTodrRy7NHl4fRdnICBXCMuA2o=;
	b=x4zU+SWkx1ygFLfT1blQbnJW6H5GyF7l+RClgznqvEJ97mDrhR9LVx06VaHGtx3K8J5v9K
	R2kejfKZBplp9vtXsj5U5IX0Azif0JsYSHLuh5CskBAp57aZaEKKS6DxgWpxGhJ84blKRl
	FSLGJBDG3N06+PtHFH0HiANtD3AW9J0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=397Fnwjs2OurSvX7XPzQR9J6ItOjTstfYOqYmvEYocc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795028514; v=1; x=1795633314;
 b=wJ5bWs0NOU86zeHVo/NtoIlqGFV46EZcFtQLVsnXWkh80QXDlGr1Rjv05QpQuhOTl4uk4onL
 SAvzihVKc4rf70ZXJZdzlvV2igzTyBlAiWSMou5Omj2I4geMZSWJCF52drXy/pak7otTP04YNv6
 ida5+ahWRceh71Z8SbtMIldU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0fa632777596c450;
	Wed, 18 Nov 2026 19:01:54 +0000
X-Mizu-Trace-ID: 0fa632777596c450
X-Migadu-Flow: FLOW_OUT
Date: Wed, 18 Nov 2026 11:01:49 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: consolidate the memory mapping entries into
 a VMA entry
Message-ID: <av32Bb3OAouItkpf@linux.dev>
References: <20261118-maintainers-consolidate-vma-entry-v1-1-8019b0e9928f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118-maintainers-consolidate-vma-entry-v1-1-8019b0e9928f@kernel.org>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7BBBFA0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qtsiesgo1dxiah5xqyad7qzbmfbbksuq
X-Rspam-User: 
X-HE-Tag: 1795028516-274330
X-HE-Meta: U2FsdGVkX1+6JKG9EKpUFgnovE76+CWxPQiwwClFcXVFlDs0heT0z9jsemHwrOjldJmuPXM3Dbvhg+bUzUlyQw/fl8/g5PDMT9oPMCH7uSYKpPap294QrCfHN5PSV7BPBC2E6OaA7fp1DbsJRI0V/orQ1bg4TZwxg8JVGzleitnJVgqQF7M6ZJhPoPkO57FOHvoyofmI4AATKBcil7eqFfwj4cylQtLwz1kE2qcTXSldD76EosyW4AsEbAdP5/75TPmdPjFsuskIE1Ia/uCw1NKlOMMw86AZd0UMt4MQLQoNfPikDn0Wgy+ig56am38oZ4d/VcpTZSU6dl11kZvhRtVvrjsi6RuXm/FWXzAEUvGu81lgziM+n8IJY1ukwLox6F80N9j4h3Wc6reYut1JGdj+Og6iK/LSR/2PUC2Svg1XLgZW7AuhkKQeip+nl1Yi64YRBGx4rJN3vKrwtPmq72d/RgANdrWW45r24bL9g2Z1gliVJz88z7CyoMENKj+ajqF9Fi9QwteUTWcbpzauaIA776LYLH+5chko8GHex8D8CbQtCA6c+Tv2G1xSY/HMR/rGquSdsP2xhAlLHiQywCjCor5YbWKJb9KnFCNM3YeFZUsDEVw/WT1gReDbn/NpDdjG7aGKKv2+7t5iHKzhq0Od7+lbOJuGnFZYMFktSVBbKdN4cuFb3XZTibf/ejImvDNx5b0SgqC/bjDm4oKVlTr0RzPIemG2dBbfmHap2E4HeV8mflOQovEPrQ8cYMAbmBEeifM8MVZq2tsvexKotvDnKOL0WwILYvEFt70zls2leTFXVV1/z2NmGaJZnhlw/cvfPWZ4vD/tDci9sPr8pG3OD+qOf/xrWUsSMlx1o3zdO1bz9dn9aJz8AklNcy/ZGCvJDk5MM1/rCZbx3vMd+4X/kKHqnMIQV+LwWdVM0AB1wOe6E7qTuLL1mjiO1jHbM8ds47RvqtRaYC2vpdI
 fYsqAF7L
 md0T3EiefoEQN5D7DfNLH4UlcNeIeKxJY8srFvmHLV9cb+DaR6Bz/603Cror+6MXXOyQcM/vZA3JMpN8cKwfigncxHE8ZmBaHWEMG4HBMV+rigBxH28CIYNmjxPI8klArbRVAhtYvzArRZ59/FZcneaW2dMuDF/eBVXoxKTKY55Xj60Ld2StveHkZUk9NiQV2QJcD/zo67hKJYX3Gk2opOIRyKyXDpIC2Ra0FX2dc3yfwzkir7pYiCdirXMI/EQpAGNjOuAG6us8mPCzr5v/abBSU13zDXiOBE69H5ntATxVsSHi2Y9exqs8fWFUafepBpGGJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 06:22:10PM +0000, Lorenzo Stoakes (ARM) wrote:
> Memory mapping entries were kept in three different sections in order that
> those maintaining/reviewing each distinct part would be made responsible
> for/cc'd on only those parts.
> 
> However this creates confusion as to what files belong to which component,
> so simplify things by consolidating them into one.
> 
> Expand Suren's maintainership to the entire component, as he is a trusted
> and valued member of the VMA kernel team and very much deserving of the
> position.
> 
> Additionally, drop Suren's core and misc reviewerships in order to focus
> upon VMA.
> 
> As David is receiving pull requests directly, make him a reviewer, purely
> as an administrative change.
> 
> Also specify the new tree location in preparation for the tree being
> established for next cycle, and remove the link to the not so regularly
> updated linux-mm website.
> 
> Given that, from next cycle, the tree will sit outside of Andrew's current
> process, remove his entry, also purely as an administrative change.
> 
> With that said, I'd like to take the opportunity to express gratitude for
> Andrew's huge contribution to mm, and for his being both generous and
> gracious throughout this period of change in the subsystem.
> 
> Co-developed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

