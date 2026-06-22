Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C96DDCDB470
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 13:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 645F56B0096; Mon, 22 Jun 2026 09:58:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6F76B0098; Mon, 22 Jun 2026 09:58:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534CB6B0099; Mon, 22 Jun 2026 09:58:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C1BD6B0096
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:58:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D3641C0CEB
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:58:55 +0000 (UTC)
X-FDA: 84907704630.27.C0CF49B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id CD9F2A0010
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:58:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Me7/eH+Y";
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782136733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7WunNKZumC36tWFYnv1B0H/OcASaVCEPhh8ZR04/OI=;
	b=tE9V4Qhbuoh+3/RUtjoD1oBq6nYmTiJMvkvg03wZob5ARIh0Qu+vtzkSpje97rVbqS73tK
	WgzcyOAcOytpWnss/6R5N9VCYuROaxV4c6BQZkOOt5PvWGiNzojbm7efd8sn8o8zXf7vUn
	yJudW3LOr/06RqtWk0ux0NwYSgq3V2Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782136733;
	b=dgSe2VanBB+iqNC+mlXERgiLEgudaJL7xvhVyOmUxUCJ6ax9WU6x8i6ON8VBX/Dk+Bvpcd
	xG74fonTPXeuND0u4I8XgBzWz1iZ2ersU5z5FGOo0fPtLagj92BRxWg9iocnepSZDZEXks
	dyF4tmaNa7G66W/0yxKThU0t7SioMJM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Me7/eH+Y";
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF59B438DF;
	Mon, 22 Jun 2026 13:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD961F000E9;
	Mon, 22 Jun 2026 13:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782136732;
	bh=T7WunNKZumC36tWFYnv1B0H/OcASaVCEPhh8ZR04/OI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Me7/eH+YNuhFegkkm4+Fe43rlOaONG+UJxBQqMEcZnL5cK31MmYnfCmRecPaS5rBe
	 KBYG1Esv+I9fg19hZGP6sEtjtptqg2dA0r2YJhz1Py/KKi+3zJpZBXbuii5/4jN2Rw
	 loWjyEmbURdpZhSo/FNVMm14JUnOsIyDB7J764D+yftVte2RG5q/joIr7pVIgxdl4j
	 yhtX+P8gE03i8F4NiUCvogRkhnuALZlQnNlo2AqDUkA4d2amNLUWx1bR9NR0IbK68P
	 ed/DyMVIJhxATbpzj5aQch0Tu9qL701KJqH/xwOpkurxTwAz3rotUE9PYh7rp6glD2
	 /VYQJ2BGi/ggw==
Date: Mon, 22 Jun 2026 16:58:47 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, izumi.taku@jp.fujitsu.com,
	linux-mm@kvack.org, Yuan Liu <yuan1.liu@intel.com>
Subject: Re: [PATCH] mm/mm_init: fix incorrect node_spanned_pages
Message-ID: <ajk_l8cT0mIyhs4r@kernel.org>
References: <20260622022403.16375-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622022403.16375-1-richard.weiyang@gmail.com>
X-Stat-Signature: xezrxoyijjddsza778cssbftytu14rx4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CD9F2A0010
X-HE-Tag: 1782136733-275813
X-HE-Meta: U2FsdGVkX188DyOge7fh8YRANbcfpPWRcCYUbY+9EFlJhsvmE6KhL8L4WNHwOqeu2pIAFzaoukdAGH6un9qoSt4Yc0O0pOEEjhwNZADLZ8YE9lGET3xawMZOTtrMprtifiFTByZA10tGZQ4+nxD95ShuStlKSaca7lqwQOaAOy47uMKDQib21kcX2i9hKooyGNDKGK6HyAfpXWRxp2KSBGIweacCt98Dhzj24msFys4OpwUlPKRgO0wg3RQJ35cZcfGMt72a6Cz9Ja+ytInHnGXEnyl4p8LDTLfNdmdWmMnJqXCYXiwmIOButs2Zb+5/jHGQ7r/RVSGlg6o/jUnUk3JmdnwKQVbUTkQq5HugC22ScFqAKfAcgwgPVZ/HekJjXCMYUGm4E87VIVAd3zFUFTzKI96KuYAUV/EiMP+kgPuwh+/8pSeKj3qFnGsZljuTVu0SlF3iWfingtIUCdWye0IFpr5sdq2FwB3JkviIZFxVNXWAdhab12p3a1uX3SU8vWPJG8S4lNJ4t+MhtsXPh2WVz2IK09kaxd9pvOTLqDTBIB9BN4MqLwejmFcO2FC4diRlQxWEN5eX4Ya3cNG5/03V4jjrzWqobuE9dtYO1BLcIZw+CQvD5CH8k1VVz94b/gbcHffx7dSmPt3x12pIe7paPEhGeAZUsIewTQvr6tU+be83e+k5YQPcpRxN9yOr0gCvTtwq3Q/V4NGTvBafNV4qLT6SSMktvrSBzSxpgkDpOwXHqYFrqim6SLwJEnIL1WwMdepihHl+Mx67NjRtrvL6BE+cVUcFb6To2PdCEWwEOCTkCm0fFYZl84x4AmQzRyPn6hO8+HQkCl13mQK8f0/orpGp5BoEtsFU0U51kX+DElBAgsY3E7pMHQcKw0T0+Ldog0AbOJylLHfKNaEAbIgg4cPzFGxDTXXK9fA7/PKfrnqS+YlBM1NIxf1AQAzz/A0V4e3rZgsFdE72IX7
 j01569h8
 J0nTJhOOA73agjJllQxgF1T3MVlIcOpqwcQ5rzfy0QnMXBsRnHLMMHk9M3GaiHWshfU4o7DhbblL/NwZ8shWRnijpjWgOH8d2YkkYxc/HxLd8CgeJNX89qAzGolceoWKaZJHZz+PQ0zy96RiZbxnK+NeiW5Z/+1dxs8qm5U28OmvF8ALqjIjZOmIBAf9oLrWhwFuHbUB3if+28D+l0ZqOrBMzzCvdn/qFBTnkbNFjXPWo0C2AFY2qAlPCHxfvTis+NQa+h4/UCl+vUS3W+7Ycrf7kV8PHYWAWgf0OfoLTFQoibsbj64tn/Qm19LBt/QzwM3pNRb1sgBcYKVPFkkW1A+Q4m5E1APWZZIM4f+85gA8FDS2cJTJ5/T+FgzXDOitpAoyiWhXIlcxwqsNK/P+oGAty848OlEkPD/z+PamScCROLK8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Wei,

On Mon, Jun 22, 2026 at 02:24:03AM +0000, Wei Yang wrote:
> Current node_spanned_pages is got as a summation of all zone's spanned page
> in calculate_node_totalpages(). Generally this is good, but if we use
> kernelcore=mirror, it is would be wrong.
>
> As we already passed in node_start_pfn and node_end_pfn, fix this by get it
> from (node_start_pfn - node_end_pfn) directly.
> 
> Fixes: 342332e6a925 ("mm/page_alloc.c: introduce kernelcore=mirror option")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Yuan Liu <yuan1.liu@intel.com>

I queued it for now, will push to one of memblock branches after merge
window closes.

> ---
>  mm/mm_init.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

-- 
Sincerely yours,
Mike.

