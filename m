Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE986CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D91366B0088; Mon, 12 Oct 2026 11:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67FA6B0092; Mon, 12 Oct 2026 11:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D716B0095; Mon, 12 Oct 2026 11:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A506A6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:22:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 095E71C49DC
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:22:52 +0000 (UTC)
X-FDA: 85314341826.21.1825FC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5A450140007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:22:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E+Q5xuvH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791818571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1pPzW7bAAqdCipDrvBuW6zUDyI/nx3IHVJIuif6myvY=;
	b=sku66hCfW0pqfYSOzmsbdtLw93VA8PMpIDt8Oza1bEI9rZCcymB9z9WZJZU7Grjt6/QA2O
	rJnZmraT5r1rzD+rLEyFqw6cLQq+lnv7Or1u2mRdWr/KTZ+P+0BM1uRv49S+QfAGrA1Qds
	ujlaaeQT3aTGAwuNIohFkNDAu2oD7DM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E+Q5xuvH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791818571;
	b=CN5sK7EiQYVJ222oYwNB73udCfsIspOa+LRVZAlUXN9aZ1NCeKTjVp+EuxiSx/ftLAVSBZ
	GWholsdrm1saERy9y+jeoS7vGhBS/iEK8bv4KP1Hob6upnxxdQJqGqCW9bjS+IaY/x1Kv0
	Ks0/ePpl7iicHHQGem4hR/xzS8FdxRc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 817A2414AE;
	Mon, 12 Oct 2026 15:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017F01F0089B;
	Mon, 12 Oct 2026 15:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791818570;
	bh=1pPzW7bAAqdCipDrvBuW6zUDyI/nx3IHVJIuif6myvY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E+Q5xuvHEC5Chf9m05/NcxBNZ5uFubAUsH9Ov3RGE8jxH1vlB8Sb5xcnRXulUhNWO
	 KD1IBzoN8ESgl3dEbUj9mna+IfFHFuNc+3Bo2o+TKvL46QBhs8a4XibxU2ob09eufD
	 zedBAkmHP7dGaI21tWtcUHi+eRptSZ+/ZoMdPjcCl6o9w1A15YfJX7MxUcYZFSbZRR
	 v1+GHzRQlh5YKBqq+atDUO19pSDOF+r/26rYBPBIuAfZnVVrtisWMAB5XCZLZlOfgW
	 j+D0ldOJWjMtzryj5mqF/WknhAASbrVR+m0KSy+iEs9bFKxL9bMSDuPTkjmwb4FQDn
	 voGhJo1HL9T/g==
Date: Mon, 12 Oct 2026 16:22:44 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
	Lance Yang <lance.yang@linux.dev>, Kyle Zeng <kylebot@openai.com>, stable@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: don't discard lazyfree THPs at PMD level
Message-ID: <asz7Nz7wGtGSG-Wa@gremlin>
References: <20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com>
 <asy445BYRhcsGDE9@gremlin>
 <8B17F897-40BE-4834-8078-949DA951B46F@nvidia.com>
 <5a52d615-8eb0-4ed1-b63a-f9016041a23a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a52d615-8eb0-4ed1-b63a-f9016041a23a@kernel.org>
X-Stat-Signature: 6mfdzos1yjkmy38ed8dkurfafyapft4a
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A450140007
X-Rspamd-Server: rspam08
X-HE-Tag: 1791818571-256487
X-HE-Meta: U2FsdGVkX1/6M2PXVt2JjFTQ+mCuI5WQhwVMyqjLEE+fWPPXQtQ4/wOqYTRHQju3nV73SN7cQufWQ8Vv/AqKL0qOLwzgwbgxWcgTejS7+g93KjufRXbr8PQBpKPby4coZ/TSBa8AtaTAXT+UQpcsbaPor/oSTbWetkl4S9kU8TUpREbXVz04v6mgwekcONc7e/Q+pAFLFklSp1e/Yr7pPb4lVkmI+YmMkF3wuDq49FrbCAgEeuOR1WTQcsZJlc37uO6OgOPCLPk8dCOkCY8oYbXbY0klLI4/RcSWOz83rZNOQ0m4u6Xr116KkcJMQzz9pLHNZNzj82A1gEilMOKIch3pYE3RHQ7gxQoteuouGyiI/DWN7ATEulvoqMcGnw6WHAGaQIG6+3EC9FjiOkjeTM+LaXzmybtmScV6ap2GjsCrTwjCq1Y8AEoxreCnjlPGtxQCfNZQHTlpmStCZ0OBO8TSZlWf/ZZLyXPrQfnaqMgxJDDVgf1HqYucxsCli4a7KJJ2VZ1qqCH6yV4kbr6Yuh4usTJu6WLUyLcnq5td0865GtVhzG92bKKkKY4kzyt8vYuwVOQQS8ziYKEyDW5lhMjMP2w0tddsX1Ov1eOv78WRqYJdYQGCl/l39mgu2ZI3ylEZLdaQ0gwdKqUJNEAH7XmYq4W/xX9tBD/EKoFsKivZOaW4DNn5prdW5itQqiLZYnnzeWaffyTSmk1pryr5moIsrM71sROw23sskjb0ud/f7DwnxtVfl15WCA0Ew1uGP0NUQ/bWVoVQi2NUB4j3HJgtK3ThN3jBO5P5GkUJpzLr8bDcpJjGswQQov6Hcs1Coz4p0wr6qvfE7piNl495yCZus7qX2TBmKymJoEp5vMqfNSt1o9F9yCX9HB61SZONmnakTBZk+8J73LevYRTFx+/C9HX76jJqlKcTWA1cgoSuvuTaBq6LGZQND3RYSmLTzjcYxfWcI+KMwU197fB
 BjxWIEt2
 9ohVzLT7z+N005J52C6Ff3Mw2uYHC0MYBebaLhy6r9SqfJTVpbt3c1myzreUm9GmhPnI6bDqaJVRhNcCkUbm/QGo5FndQ+9fOxjYueu9gE9fwbN9wsVqn5b5Pn0vPHsvdYphab1RLqvR6+r/kaH/q+8uUyPOBHBSbyUTqhvcEHJg4r5wfPtWL4lY1PjFCpXn/7hrlJGEwLqKZ4zrRMrViDySu/14TxKLN5i/U86G8wvfUc0u1UyH6RHI3Bqpdsxw6ysiS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 04:39:03PM +0200, David Hildenbrand (Arm) wrote:

> > I can remove the dead code if you think that is better.
>
> Leave it in and let's clarify that we'll restore the functionality shortly.

Yup as long as there's something in the commit msg that's fine.

--
Cheers, Lorenzo

