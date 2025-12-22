Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9071D711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 05:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 526C26B0089; Mon, 22 Dec 2025 00:57:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4266B008A; Mon, 22 Dec 2025 00:57:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401A16B008C; Mon, 22 Dec 2025 00:57:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 310916B0089
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:57:17 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD78C1A0A1B
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:57:16 +0000 (UTC)
X-FDA: 84246049272.10.DFD79C2
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 81D2840008
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:57:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n6bo2KzN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766383033; a=rsa-sha256;
	cv=none;
	b=0248N9N2a8+OZDQj5+iFS3PLle5cUftP/i+hoP9m21bw92L3uUIaJiXEqRYnVwlXc7o0w7
	uybNwfab3UjZlttCRN9b9PGUgycW6sTFd82LksYtrKj2CnK3fpN2aaA86zT1Zfsj9hHf7X
	0WMaAJAAE4sFvW4QdoQHK4rO/5Wj4nM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n6bo2KzN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766383033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WVeKoBMBLx8hWDfGjFnYOboKEJqD6vtX332hwypLAQ0=;
	b=13z8b9ZfYpZ1uD9OEy9k7G+cGhPcH7w93JistH6Hq1K0mKePUYEt+drDuPuymhiOy2mOz+
	eovn616Ui1dtlQMOqF2dSxXCXP8qH3/IdqQGK5ogIN/ykrtawMypsXu2UzeNQgbX6h7+57
	Z0bzJHuU9yWa0YqaAfeG2WmpWPDa4tY=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766383026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WVeKoBMBLx8hWDfGjFnYOboKEJqD6vtX332hwypLAQ0=;
	b=n6bo2KzNzuDV0QONoVz74ohKZIircu59lQvoar4w+OorHluDTi7UO0Dq7AFwG1RJSbgBYT
	PoUnqvTvlaiw5wUIO3/B9F68bvudg/HyQVtfhaCujlDVg8b5tRH5pqykc7Ib70+3JaMe2k
	+sVT61EDxvLxAVL1lHKLS55E1Lm9CQg=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCHv2 10/14] mm: Drop fake head checks
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251218150949.721480-11-kas@kernel.org>
Date: Mon, 22 Dec 2025 13:56:25 +0800
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
Message-Id: <976A9938-0228-4230-92B2-7F6708E96199@linux.dev>
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-11-kas@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 81D2840008
X-Stat-Signature: ej8p65mhuyhhof54xt41u8stk9ri5gw7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766383033-291388
X-HE-Meta: U2FsdGVkX18UqMm0Zj5eLwDWnyvevFuRSi6/8JdOVY3MjceJX41OmzagATAU+JdCjMRYHu+P4kge8Xys2QPDd2QPg+J1cjdyF4RPC5JIiQRtlW52rgFgvZG4PHJxKS2ydcLb5JpR+sTShOU8k4LSiZsScuWEoan57iz22oTQnhSzp1GabcA0S7k6acW5F27eAuui59tvb5sXIg4iezrexN4pZ6iTlvp6Lo+nsS1W/+zgfk0Zr/p5f7paJLmcL6BJCSXDsc77VAOHUzDngN3AwZ0OFjkcPYk0omxELr1J94QVw+Jkb1myYJGpr7jbe54Akmy7TXw9sfE/3pYFFB2/PRHEwUUk25ZqIYTxYCXQX4LXSZkSYVHk72b5RMaXkGzap+bHlgPHG8mTsvakhk69zhFIaEvjbeTr4udZEfOXSmNhaISAldtsI8AHkyuGNF8L/L1OfGl7iJEomHr7wGP4GwfsF/n5G6sAV0qq3aTNj0wnPi3kdNMbMX+7EZaQs3bzfc0mL7kfktIR9uN8mNMeWCJynDK6KTqvo5Si9AYwQ9vAqmcrjnjQokQsTYpyEqJ84z7VTcs6/qQ5OBAPrrpzDdFVLlA4T6xQDotLI9bRPr/uQpNlxU8CHjL6LpHSMb2IeKvbBu4cztoQK/cG5KJoPXrzADY4wiS3uYaiepfc0epc0krBX57IrjdQ5xMVfntwr5ywNWnP3DoqHbN10QavIXsNo7kTXTRi2wDswvp2G6ie1TKE4idTulSoz4Yv9yNc8SOnqPeu5tjGEv/cK8Vjnrg2XWUkhz3ZGdto6r6sPyPj2FFULhIoCy95rkMwoKGSSxEnAUoP7/eUm5tfojDMKax9We5e0w19/zPAKBSc+vr8uXD/V+oZKLqGqRY2AlO0ivfkHuOV8nPUmjPyoHnoxc/6KOVjfryGV8uxLNgi81PF87pkFVQ2uHh9MkQbm7YUY3DNwNQahGgh+ffra4/
 EOVa3F4f
 39jBd7yt+Re+ScAXFWYxKheTFXhdLve+1XytYuJZ230KEJ6KiS5w0DcNVTDKd0dFISztCdEo/ddT+8QSLvBB5TxTbTn4IMT5DcGgR9Au+zBcntYfebPMUIOQdYF/kxFhmtYXg274nvYZx92sheKmsCSFhubF41/oNwLeQiK27EV9rGkABUoWGOgiEsDMSwG3Pnm1af49zujOuaKe7+yx4tARkKf43f4245xERGEQJUpRfISSlq0bUDRqxUgkp3iMm8lPg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 18, 2025, at 23:09, Kiryl Shutsemau <kas@kernel.org> wrote:
> 
> With fake head pages eliminated in the previous commit, remove the
> supporting infrastructure:
> 
>  - page_fixed_fake_head(): no longer needed to detect fake heads;
>  - page_is_fake_head(): no longer needed;
>  - page_count_writable(): no longer needed for RCU protection;
>  - RCU read_lock in page_ref_add_unless(): no longer needed;
> 
> This substantially simplifies compound_head() and page_ref_add_unless(),
> removing both branches and RCU overhead from these hot paths.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


