Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C61ED58B29
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 13:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6D1A6B0005; Sun, 15 Mar 2026 09:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C13F66B0089; Sun, 15 Mar 2026 09:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20426B008A; Sun, 15 Mar 2026 09:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A34326B0005
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 09:12:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F00F1CCDD
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 13:12:16 +0000 (UTC)
X-FDA: 84548335872.13.ADD9C29
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4D6A68000E
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 13:12:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o2amTglJ;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773580334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=26yBis00uiMPtDS8aUzlNEkKNIcpZ/qQQw/Qafqh+68=;
	b=JcRgndQ2yFZpmkYpZ1NoM8ApjmUtRISu2SdNcj6nwDLhQnpZ3aQ2TdGMnzcXIVIeI6Ewu4
	vCdhiGLwyQVTc25jZ9GrsteOFkIeB7ToniKQSe6MYVfPG3ZCWWVE7WiYaL9MDCyKp/lusJ
	i8sqgKa1U6SmFBSKhTJEpXlmCRipSeY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o2amTglJ;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773580334; a=rsa-sha256;
	cv=none;
	b=3JcPCKI3FPduEmAc32ZuOVfUYOpU8kubGYMDJZUBWUC9g3+cSwXzWkZMJlHicSgl1i7DjF
	Fj+plYJh3xLkJ3qt4rxd7hOOFl07qVQPHBtBuzpjlqW3mxBLEGljYAE5pw8wxG4sMmR5zi
	ZA1GPd7t/CqK8sLDdnI4qJPi5481jvo=
Message-ID: <0c2bd25d-1577-4935-8ebe-0762b480abfc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773580331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=26yBis00uiMPtDS8aUzlNEkKNIcpZ/qQQw/Qafqh+68=;
	b=o2amTglJM3JAnBL6XV4rgGAEVqgVrlFKflEOc3Ws/663wYLicZXtcSTQH/CQ0q1REGRYv7
	mGvwb23SMOEbTqnr41lCerM107hhoFBtbAjKPHTtYT3pQe/gOvLCwEtJ/RqlAFkasmWRHd
	scrDdVGDWCGhUBisO8rX4k/SyQwUvEo=
Date: Sun, 15 Mar 2026 16:12:02 +0300
MIME-Version: 1.0
Subject: Re: [PATCH v5] binfmt_elf: Align eligible read-only PT_LOAD segments
 to PMD_SIZE for THP
Content-Language: en-GB
To: Lance Yang <lance.yang@linux.dev>, r@hev.cc,
 Ryan Roberts <ryan.roberts@arm.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, david@kernel.org,
 jack@suse.cz, kees@kernel.org, willy@infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, baolin.wang@linux.alibaba.com
References: <20260313005211.882831-1-r@hev.cc>
 <20260315034647.8462-1-lance.yang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260315034647.8462-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4D6A68000E
X-Stat-Signature: 3iwggzwnmiitjzd4tm8wnkdfmqxj1b4f
X-Rspam-User: 
X-HE-Tag: 1773580334-461480
X-HE-Meta: U2FsdGVkX1+OV8TPSwYLSCaz35lVCEHA7bxFy2LA4bHzmz3WFqH1m/ZQI955WHcL+tklkyxm3io/UBGpcaEhhaa5RozLC1JoVzGSA3k6WV6R7+Gu2NHafgmQ11/P27ryXe5keTv84lfgoAvCqnPfdUE+zsmqkaVdo8MfB/sB71sYvkUQXneMxLdbfkk/o3wqndSczbetj8VTkQ9lCG6rw1uWX/N4+dTK3TtbXwCASeSAmVeMU4TRhOh8+Zggx31PWrhqABc8qUCFD7BpuDfVUHrRFlbcs/bBE/b08HLDl/mRbs2UOIp1gnTa7N42WiiGV/ieJ42+LTCAs20wZmUaRSOdl17EAJqfzkyR3ZIYzJLmcmQ9caAQ8ZAx+JbtUeRH8Y7Z6s+8NyLNGiopMQVC0KkKvVA9kdtZLYMaUjHh+BR8ShPeQh3OKA89PpB7pqnVuUhmUMpGwNG+3W9GOaRcGXvPA4+AqTEvvjt9iODompTNJjGcwPjS3GfhOauNitJ6nZt/AY5wgd9gl9t83GupvzqAT+/Ltl2qKlUrHr4iH1jxhF5UECcbaM6bPWJdamzQ8b5jJE1GeiPF1qE6bwXR4M5vypQhPubyh9VULmou6W+7c/wKkmASCnj3qkBQgX3lr41ioT1o9HTMOHLCDK6dXZkUxKIIxEXkuirxPtFOluC1H0sYw557qZT/ENTnD70FdleWdD4tBQ+e3bxB2tWhHnHaeZUKzUG/+FugpguyV83ztCJvqKzlkKCRzByLb4aoBEhq05enrzqmYRqeMrzLCcLLPg24P70XoHuCGD7puvMLz7AWT1/UJvo1jVPMtckqVKLo7UfNBJHFvCmKvucPJGMTrmZqQR07o6enD74pZ/wrOFi84G7Oww1pvOdjEUTXxay2dJ7cGWU+jd0Tjd0mKA3+wrtm7KQle8i0dgOl0BA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/03/2026 06:46, Lance Yang wrote:
> Hi Rui,
> 
> CC Baolin and Usama
> 
> It would be better to keep earlier CC list across revisions, especially
> for people who have already reviewed or were explicitly include before.
> Otherwise, they may simply never see subsequent revisions, and from
> their side the discussion just stops there ...
> 
> Thanks,
> Lance
> 
Thanks! Also adding Ryan who did the exec_folio_order() work for ARM,
and also raised good concerns in [1]

The problem is not just alignment for elf, we need to fix more things like
mmap heuristics [2] and how unmapped areas are gotten [3].

[1] https://lore.kernel.org/all/cfdfca9c-4752-4037-a289-03e6e7a00d47@arm.com/
[2] https://lore.kernel.org/all/20260310145406.3073394-3-usama.arif@linux.dev/
[3] https://lore.kernel.org/all/20260310145406.3073394-5-usama.arif@linux.dev/


