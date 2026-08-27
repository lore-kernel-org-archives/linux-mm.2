Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B787C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 14:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8227D6B008A; Thu, 27 Aug 2026 10:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2B76B008C; Thu, 27 Aug 2026 10:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E8D96B0092; Thu, 27 Aug 2026 10:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 447626B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:15:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 784DE1C1938
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:15:56 +0000 (UTC)
X-FDA: 85147248312.20.F95965A
Received: from mta0.migadu.com (out-64.mta0.migadu.com [91.218.175.64])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3DF1EC0004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:15:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iLHX51vp;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.64 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787840154;
	b=kj3t4je0CNws6bvFRrCgNuQdj/9+sBzbAKQ9JBzCZk4gxoB30ftMJqD6yI/n5KHW0upFoM
	QJQ+wE0+5RvRj1MyV4RiF9G7A+z1UDlSuRc8Nx7p1Qegjsl/GptHSukh7yS1DNhkTfwY+y
	FT4G7+hrNRTnZdpbizHfq+9XE6JRJ0U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iLHX51vp;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.64 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787840154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZxARVqj71l3Bw4B9s9n3O97GmK9w3N5nJSMk72Wp/cg=;
	b=3byxDXPR+ubpLim3qdy4Hzw9uECbXesoDSinz8AToChVFl5e1TN781NjNNsePLH+omXlr8
	IlG4yGDtIkc675y23pdftepuchpcT0cpik6XRuZgpeJ7u0HtJXolT56BdqrrO/SjlhkRnb
	Y/fH1H9TGJ2eeH2q9nOYECyGmBYpStA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=pYxzxiVIv97dsu9o1IPWOaoWIFUoz77FptywMtdz7fA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787840152; v=1; x=1788444952;
 b=iLHX51vp3UwAoHMtL4qMUeE9O4wJkxougkvpEwGWxRSJqQY2zE3RTiAOOMO4EDnaOS/c6ubN
 iP3jLdH5AW/pqIUIDr/pQw1dTP4idbgAGd+LdNd3PSt93+u6r8cQh/D7+lpW5YqIYcMcCC0KS9p
 wWnCLTgR3PX4cQ4Ijn8vMhR0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 643b2ed66c62ca54;
	Thu, 27 Aug 2026 14:15:52 +0000
X-Mizu-Trace-ID: 643b2ed66c62ca54
X-Migadu-Flow: FLOW_OUT
Message-ID: <054cf257-f5d6-4041-8c83-902af87c736d@linux.dev>
Date: Thu, 27 Aug 2026 15:15:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
 <ao7Nr_FALfP7cTY5@gremlin>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <ao7Nr_FALfP7cTY5@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3DF1EC0004
X-Stat-Signature: ijwbamco7w4qcisf6h3mam8daa9ii74n
X-Rspam-User: 
X-HE-Tag: 1787840154-267780
X-HE-Meta: U2FsdGVkX18eGqbsApHkxdiKne3GFoI79lx4c1RwwTd7xxiu1dpFPPBFtjTjPUSkLMsX7mWyDyHtwV72hQBkaWpDDdS9aeYmg29tIHH6Obm/rb1eRTSVqSrtoHnh68wrNGe76Vs58fQplCI5QPvaB0fRcoKYf9n70DPYyhMPfagte+XJjjzcPyTaIw3nYELnQahdzTA32SL+6UiXLyxu0g/uCa3R2hDJuKkaTcgEWPUEj8yB0KvHBix/OOUbTOVMVmr2JuOubTDzQ3Bp3O+zuG0dC4CzlKGniXRqoHBirohJkGpIkh7FRP8URA+KLPkFKmiwb4qiGXC7HmYe+7Z3ae8OOuTcC1lvYf9BcCn9/iKx/C2ko0dFMfVFLM5wc4225PqI3vGUGrAWJOO8zbbpu40BNOU02JLcLZzvJc6XDQqeqf2mSWsGS+2CoHI54n1ggNSzbk6ty9iLNpEH8ThsTGDVchLHDAIKYDltRp8BHov93RfuGrhZuDD7pXR5SBMo+5IOPU0OJQJegSqrsTRIYI5ZfKlkF3xPhCsQbizJIMv0bT7+PAuNQqtEtypFiE3QoUzoCdhui0MnD5RtdXnWTs4miqLnZjb0c4nB3ZHxbRbJZ5UMgY44cEBkKT7uMzlNpOwZHV/fi4q8dG/FVxGTA5HBzJpZeSGbD4G9kzpIXERO/cQ/xiGfOjGvZCmLhtA+KbMUaHrFXpmX7LVXC2veeeplZFNV/cfaU0U2afdEYnY42nEnuYrYUpDXeD7JaAsg47BLR1gM0qxDgMVNypcJqC18AxipRMGX98wz1FKEEU9ifgNNK+RC1iEIPX1ZXrG9zbZC+THy7sNvJpyHBp1bdfCdsBaYrqEsJ+66xTITGvHvWtQ585gzBE+hoUgBS+1suZcph+IbhK2nR/CCP/uXjljaTnpdLCgxBQBz8yxuY9ltRIkentyoCkigaXT7y5TWv0gwKNkCu6BBd2jrM2W
 uGXyDnBG
 22iMnmBNSD8xQCtf+JPAGCpaX7d+sc/FSftVG6MaTbMuairaidkp+kkNgBnAZeZJLmcJAuZmuZ1BCDElmWFj2goLjtXN3Y44tww4Sy11hnxdTSZb2NDltidCDiG07GA06TSmAllT6ERIzpMYpu+5SAf7vBMG/RTggqSi3oQMO2QzR2BOH2/s09ogLizqfja+/TRl2zVXg6PNkfCCo9FJ8ejEUdKFCS2fRZiedO8e79mNshgOJ5lEd1RS7AiIsvucuhUW9YmS0jMaCPR1LwUkNnX98cOfKUALDp4ab1u7aTQsQRXPpr8zx4FH8cQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/08/2026 12:31, Lorenzo Stoakes (ARM) wrote:
> Since it's 2026 :) I asked Claude to look at my time as THP co-maintainer:
> 
> 	~107,000 words of review across 948 emails (in 279 distinct
> 	threads), counting only prose you actually wrote — quoted text,
> 	signatures and attribution lines stripped. That's a full novel's
> 	worth of review commentary.
> 
> 	Along the way you handed out 194 Reviewed-by and 15 Acked-by tags,
> 	and your longest single review was 2,404 words (mTHP collapse
> 	support, v12 — the khugepaged/mTHP collapse saga accounts for most
> 	of your top-10 longest reviews).
> 
> 	Estimated review time: roughly 300–500 hours, centred around ~400
> 	(i.e. ~7 hours/week for 14 months).
> 
> 	1,615 THP-related emails in the window: 948 reviews of others'
> 	work, 278 replies on your own THP-touching series threads (~31k
> 	more words responding to review), 382 patch emails, and a handful
> 	of MAINTAINERS bits. Busiest months: March 2026 (131 review
> 	emails), June 2026 (113), August 2026 (111); quietest was December
> 	2025 (5).
> 
> Think I can be happy with that!
> 
Ah so sorry to see you step down, you made THP genuinely better!

The numbers show the amount of effort you have put in, but they don't capture
how consistently useful and detailed your reviews are, with the aim of
always trying to make the patches and THP better!

Thanks for being an awesome maintainer and hopefully you will consider
coming back soon!

Thanks,
Usama

