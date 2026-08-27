Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5945C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3B896B0098; Thu, 27 Aug 2026 07:02:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEC416B0099; Thu, 27 Aug 2026 07:02:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDE176B009B; Thu, 27 Aug 2026 07:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD6C46B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:02:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 288961203FD
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:02:23 +0000 (UTC)
X-FDA: 85146760566.23.FC41745
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5A9831A0012
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:02:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mr+/HmmZ";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787828541;
	b=yZX7pgg8LPDvODC2NPtwrapKTY6Zqwwv5P+fnwk07EZ9mFaWYmXk7lWtnI9oYZ4j3b4JF6
	38HOsAhHqXUhdT6606smkrm4JZww1XRnVj2+Sc1DKTDs9rae+V35Rkb5ShZPunzyupG9hg
	KxHpR3RWEjkK3+dlCVAYZMzqdBYYanY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mr+/HmmZ";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787828541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLIRcVOWfTseBqG4X/yqouMd/v5TmZVhVosxsSNTTjc=;
	b=VEuYZKYVhLR375ScG4lUTQKQTjlNbZ+IqqAuJF4fBpJMLeBwD/NfvVpJAogC74ER0dXBTS
	Kavb09R4ljnzfkfCGylEjPuzRdllpSSTAUPoSNsyPIMYc9FayIZAGAASR9guNQxA2ejPGC
	5/VpAzsJxCsvemPgoq/FGjvkOIyN1fQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EDB4416DC;
	Thu, 27 Aug 2026 11:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CC91F000E9;
	Thu, 27 Aug 2026 11:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787828540;
	bh=eLIRcVOWfTseBqG4X/yqouMd/v5TmZVhVosxsSNTTjc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mr+/HmmZjb5W5rBqUGOiTQ7Xcr/MauAgqshgo9EmJKxsbl+C5nMu5ldO+gcslLtzx
	 MOTzjVofqLkjWOc2I05GvmkbFSda8IaML+vuu4wu4D6LDJuuDmadpEWJOYkERChS7a
	 UXPu94YSYeXlr0xOles18O30kBdu5DvSqdlK38yxO+xhincETJGzwmJStirMgoTjKH
	 2Cx3dBAJUAUPjmLYYAUmoSW237MH6bfq86dGKxbi75Z6ht1GU+oSSYGPUejLUfPH5H
	 uFM9Enj0+I63jeq1vmSCu5OqyMT9m1YI+KZlSc5iinSFBEIIcgwruFBtrvjhOliJkC
	 xnGjDbJsiwbYQ==
Message-ID: <d02405a5-1d0d-49d5-9056-1a34ccdeef10@kernel.org>
Date: Thu, 27 Aug 2026 13:02:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-stable] mm/khugepaged: avoid unnecessary checking for
 swap entries when collapsing a mTHP
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260825192433.3185880-1-pedrodemargomes@gmail.com>
 <1ec4ef97-47e4-48af-a8c8-4e50faf781f0@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1ec4ef97-47e4-48af-a8c8-4e50faf781f0@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5A9831A0012
X-Stat-Signature: jrm7izgubbha3cowfboopqj4mynrwuuw
X-Rspam-User: 
X-HE-Tag: 1787828541-269949
X-HE-Meta: U2FsdGVkX19uyl8TWiX5mAG0wsPirr0jIBBsrxqQc4rFpeRCCp7m8dIbMLHxAPNFAwQ5ihDGXt7vRosLDEml+Wrvvz1GHSZ80JGwg8zV3VQ5Y0GH2Mu0o89fIxLqAew/iBUi2FH0/CSyqFFAXeCpsYA+5Xwg7D2CrtLzaxUYGsXsEnZjKug3I+2ZYEgpDbmznDpVQwalFycHLbRc584BPw+JPdWXVeDzbWWEJ/iyfN+/GWUVVpVd2+iMkZDdti7MMJk0+6WL3s53RkEKilneg4R4rFqwUtCfQ0WmHpMBSZ5uzvOlXtX+5Sz00j1RAKJDBBlwgfw/hgh2nyivOvGYtnARXfgaJHM7wpIaIUTSliHcYOuGhusqQKFg2m9XHyQVmSzJuCsjZTO68d6dUF6xXEbdxTlMCAGAzyupq+giz/yBdtVq410lIp6hphiCdOosTPNR+oKVwOG2YX7wYS8vuRhODwy13jqAQexL6YKL7yBzx66ss2L8xBio47fmatGtOL6Fm6lOk3X/p7n6SsT0pvQVP9w27U8CutuqIkPFxX8pqE518ESnsYHSVVfPdoLQ8l0PNV0GqSIddwa//MR7GJCPJ3ZhhDK7yZVFSd1MtgnvuXlMruSnR5g3Ehih8x4vl85ANicfqevclm02hclMjpW1QVxaiCd4WNT2CpxAvLTr6izOWPlDEq8OGmxVZCJRj+nM79d66ygMc5OSXn3z7qNZnnU3Lqz/HugL2nBbDpXL9r1SLMsowVOyoPEZq8vT7cOoy7mZZhzeWLcIYYTUxMVhZQRu4aCjgV2ujONSl04dmtp5h+E2QBak9UNAunyc7h+HVGRL1GgtoqJVuRXC4zNhQE/OWP7i84rMuRVF+NfHR8Gr4zPon9RSHPsB2ykX8aYd/Igt/EiKaG7xsn4KJ1FzYAdxXB742Osskrv6/8vsezIwOvAYLgyaJaAiWnAQ/NHnMDQO5l2qIxTlVGr
 Jj+NWDCH
 j3u5yoi/g4OewxS9Kjp3ZRm4hY6TEY02QE1R6KrxrJzXZdV0yPWbHWsKUl92Ivr1lcSd4n+eALBWtd/PfgzTGzSJqaX8AnY0XkCD1Cb0HFkZZ9ZtxoudWPVImVQsK78h16nHBhWv2jtAJ11d4tN9IAPZWeutCmRbvf5CNhW6vafDQHxBuO4eOWkFxXAWVssSvkb8xS87jK76/TExgCEIyMwRanRkNs2JlXZyS9IJkw3mFQy5o771ca1CAtbKKn7dRvY9Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 10:06, Baolin Wang wrote:
> 
> 
> On 8/26/26 3:24 AM, Pedro Demarchi Gomes wrote:
>> mthp_collapse() tries to swap in PTEs when collapsing a mTHP if there are any
>> swap PTEs in the PMD range, even if none of those swap PTEs are
>> actually part of the mTHP's range.
> 
> Are you sure? I wonder how you tested your patch? Because we never swapin PTEs
> for mTHP collapse, see the code in __collapse_huge_page_swapin():

I'm confused as well, this doesn't really make sense.

-- 
Cheers,

David

