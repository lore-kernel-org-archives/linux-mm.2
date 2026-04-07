Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ED55EDB7FD
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 11:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC20D6B0089; Tue,  7 Apr 2026 07:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E728E6B008A; Tue,  7 Apr 2026 07:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D88756B008C; Tue,  7 Apr 2026 07:05:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB4316B0089
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 07:05:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1AB3B8DA1
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:05:52 +0000 (UTC)
X-FDA: 84631479744.29.C2BAD7B
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf10.hostedemail.com (Postfix) with ESMTP id C9A43C0010
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:05:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=heuDZeyB;
	spf=pass (imf10.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775559950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNE2x3JmAW3eWAnXa+h3BOdOE/0+Bvws/q4YiLdz2ls=;
	b=AwTCgdZeM0HVkF2/vv2L5cJei69Kpuzg43DJOC6CW4IOG92SZOCgML7Zy/aLJQxGEZo40r
	iaQfj8OsSWNIm35frW7O9uBAYpvb3+zfij1v3jXP/n3Q0HdvWG1Qobe8m82CaH/gAIU4Dl
	JHbog6JHUQLKoGlbj3PIkdhpj9pPyOQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=heuDZeyB;
	spf=pass (imf10.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775559950; a=rsa-sha256;
	cv=pass;
	b=Qx6VeehJVHgzPpmzZlGgs2gRiJMBj1psO68xUtcAKZQVo5JdOd6pKsFL3UChoyMzmM6f/v
	/HvAiq1jSmnmVx7n1bHDYZshXu70J3dvj/JlgzQLNRt/4r0u8KJyZMpG6CQN4B1ZzZGUA0
	UI05BES0dlf0p/xeDCdPTUmrRGeWWB0=
ARC-Seal: i=1; a=rsa-sha256; t=1775559925; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=SpghdqFdIncdYEBBx88g1nszD//OvQ60j68EMTYzU7UaQwgprHaiS7aP/9tXCDNpTB61ALpHj7XDZS5d5IbVfFq3eNpmTZ4ZJhQmgCDRRAlGhQOlR70V+g5LfUYr7joQZOzNOt087m1W4sbPe1bzro/pFRAoAFH66l8Yj/VD9YY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1775559925; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=kNE2x3JmAW3eWAnXa+h3BOdOE/0+Bvws/q4YiLdz2ls=; 
	b=Nu8mNl8vDOQu+Aagc5RY2+61c703sLOBf7eewR2kqpyjElB66NbyAfJih9EeiEixp5Hjj+hggz9uHJ0sDUmd6JXDve6K87jdBUNTvGDDfN+socnRVCsGEDRJuEVaPDwZ6dy4l7wIZgoJbMTn1PJxdiD/6Grj6JjhYJjaLhU57tk=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1775559925;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=kNE2x3JmAW3eWAnXa+h3BOdOE/0+Bvws/q4YiLdz2ls=;
	b=heuDZeyBPvSyqJW6Q/4EZVkCctwOkNGOH24Erre5dxsHLvnTgNQXTfKx3GOiHfbm
	BObPxp6qS4JBR6S7Jmxe32CDiGuIpY1s82qmd2bdMUFKJVOmbBGJ9/eS/AOrRcHiW3Z
	4zSUV6Tdu5XO8n8zLIJhAJUlZqpE30hqaguLIptA=
Received: by mx.zoho.in with SMTPS id 1775559920916100.16589917728516;
	Tue, 7 Apr 2026 16:35:20 +0530 (IST)
Message-ID: <03be7666-7ec8-4fda-b9c5-7419b61252bc@zohomail.in>
Date: Tue, 7 Apr 2026 16:35:20 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/4] mm/vmalloc: free unused pages on vrealloc() shrink
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
References: <20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in>
 <20260401-vmalloc-shrink-v9-3-bf58dfb997d8@zohomail.in>
 <ac2L2VNExpp8t7oF@google.com>
 <7bc4bba9-24ed-4a69-b9bd-d45d647f48b7@zohomail.in>
 <31bb8a8e-2ca0-486b-888a-328e9b748ac4@zohomail.in>
 <adS7EDLby-977BAZ@google.com>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <adS7EDLby-977BAZ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C9A43C0010
X-Stat-Signature: 6wmichbzigftounk4pgjbkwfkib1yry8
X-Rspam-User: 
X-HE-Tag: 1775559949-936624
X-HE-Meta: U2FsdGVkX1+2xD0FsR72nTzx2rdRjJ8AMgbvFJpE3M66CinQzRzHjrtACJDfiMPryAdTrvXJZTrUo1l1SR2p0zfHAy3T50tSFQeT8DcCsp7dqNZUy1w6D/BPes1vnrsr2xIItfM2dROffRrZVs8A93BoCn2B/jcu1rr3ofi/Ac+Ei1E7JH6J7+uoxPb7Af93lpoIVvdbzemQFLvee9HhgFnOaf5i/rnrtBNs9UivJgyw0GyMu+a3qUcEqlFWjtY2sO6pI3HbZHV8f9XTofuu8GXt2vMKn+NLsUh8e/PXseK/iX17/GlLqqnVk3Y+BVhktVGegcFD6f+3/QuRKLA9a7ED2hhl+6eZJTPKVhSQI4CDfxWzDTzAIUZFygkhxFepTwN5BshlDnbfJ0dYj3KTxHRfiZ5wNbL2NDsVr3LwDAA1EF5wewWKYxb+kwCNzo5DJ300mBj9uJkBZrcb8XtNg0jqwLjlWutlVYhF92UYA3AhJxBhRV2Yu7AyL4Q6C3p1DcZRdqq9h/07vajrAeWVFcOth8kbbgwxVPLctX3o9iYeEKRToXooju5douTi+rNd3+/0YStdkwjXTedM6lsMiW/alnK30TIgBa/90ODRLcmx/YfrUK/3RB5tkkwfRrxa1LaHlnfvSDT4Y2tjyETFd7N/E9aoySb3eYLSCPoaTpJDc7Js7tHmxN1cKyg3rgUh0Bw65/+/3CCfI9NvYR1tFHiH+210vwPxbLBgncdbii13Us0y1LG0bCJV16Zy5G2+91sQn0omr1TmejU/dB2haRzkhyTBdvD0AcRfG7CXBYwGEr2k/YZxzB9zCL43ol5CRUT0d+6c6kHAUcjw8E12zUmeiO/p4hGKxzVEe7JuIxZd3RKyJlZoT0bJKrYnGIz4oeqaUSRNVskZy9Y14cAHi4bSqz1WXiZN1kR8gKmHE1Co/8PfXibvSA4jdu8iFYAG+EIWCMo3XN8lGgx6fnY
 tQtdj8dI
 kItNJ4S8V/HcEHlPuNgiDPaUOeKmZtz5j2q3ypuosoPraWp6u55QBRRWJtiztfIjOOwBjEem3fTzbG9m/d07ssQqlB5BRAqtnh6CNM6XO1ou4Eaw4s++f8MarFqQrYY5AYa3oaZxRbkKVJWRrwCvURFwI3JMEaChvEfGLg3kMqj8b+9ZEP+QmSjE60sz4bEdcILS8TEjV4yIqa9ylzEudnKv0XopNdaHlV+N0xswiofHlbUNZWpGfUG4N2xas+42cr/6hHO5q8NZgKnP4lnTYg5vG1UFF4USq1jrujKoNh7gBLg5bmuUCAV+PTxohw4BJzrGlrTSMzR2/2sdrERJxN8xetgBvaEiawJD/H7uXvlTri88=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/04/26 13:36, Alice Ryhl wrote:
> Yes, I mean that you should change nr_pages first, before you calling
> vunmap_range().
> 
> Alice
Addressed this concern in v10.

