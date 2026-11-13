Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 769CD606A884
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B1b3Gxm7
Received: by kanga.kvack.org (Postfix)
	id 7638C6B05B2; Fri, 13 Nov 2026 12:20:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 714616B05B4; Fri, 13 Nov 2026 12:20:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651516B05BD; Fri, 13 Nov 2026 12:20:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47F0E6B05B2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:20:22 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D27D18022F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:20:21 +0000 (UTC)
X-FDA: 85430759442.13.67AD637
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2ED87140009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:20:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B1b3Gxm7;
	spf=pass (imf23.hostedemail.com: domain of roman@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=roman@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794590420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4SrH4RVDNtmZG2ZRDPtfT86JlaE5VwGit9tIKv3JJQ=;
	b=IEfcE6ypUkWVL2ghP/5KqS0w9dAmiFy6zvThMSfUfgbC8wOW0ebRxOiYcojaV1bbcj8dxv
	WSJoi/xGshJxYpVPN62cq5rNMyAoPLm6Zec/2bN7b5QTMbY0RcUWrlVQwi97qu4b/mCwlo
	kM2Nu55quCfkuXyHjuVq3UA3y5sWN3c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794590420;
	b=NvygiwScLPH9I1TED4CcSI1m7uSEIkzk0E6wSBl1TobJTtI3QUStRtn70gFP9QHJCi7DsJ
	eQkP/UhNJgWru8/kXzdLbOlEmu84FQwwl87LgUx7vnjErsj3RgmuWlTD0l4cEToUtqJfXT
	/eJF6wMB5P/gsZdUYjw8FuKd+JEXAEs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B1b3Gxm7;
	spf=pass (imf23.hostedemail.com: domain of roman@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=roman@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5AAA946BBA;
	Fri, 13 Nov 2026 17:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9C41F000C9;
	Fri, 13 Nov 2026 17:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794590419;
	bh=Z4SrH4RVDNtmZG2ZRDPtfT86JlaE5VwGit9tIKv3JJQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=B1b3Gxm77W9VqDxwBwV3lHzY0TWR1gYFbDnKPMD8LxLeaZpBZ2ZYzt14vw0cqRmTp
	 wj3Ybj26v7A1nHm76aBOFUQD1vOYEzyefBXlhx5+9dfYCSD5zqhrgTWS6UBkId/j43
	 sV05M9HMz+gwNk2rKShUN4yQFxptFZRq79/1QN/UNi4rQd0ODaGZ2P+U+j/6UbUg81
	 yqNWsrh898VwZm5ofdrjnV1aBm39i5pgKhoC5ps/3YqdCQK6FFL6N5jQ+eqSwArwmV
	 TubhdfmaS5Lc00xq/VVt14jB2QN/5SsWoIuhfZCrazb9AX4VRSSTMFf+bYBdPrzn3F
	 tWy0h3fOXQ5fQ==
From: Roman Gushchin <roman@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: sashiko-reviews@lists.linux.dev,  =?utf-8?B?SsOpcsOpbXk=?= Jean
 <Jeremy.Jean@oss.cyber.gouv.fr>,  Zi Yan <ziy@nvidia.com>,  Roman Gushchin
 <roman.gushchin@linux.dev>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  "Liam R. Howlett" <liam@infradead.org>,  Nico Pache
 <nico.pache@linux.dev>,  Ryan Roberts <ryan.roberts@arm.com>,  Dev Jain
 <dev.jain@arm.com>,  Barry Song <baohua@kernel.org>,  Lance Yang
 <lance.yang@linux.dev>,  Usama Arif <usama.arif@linux.dev>,  Kiryl
 Shutsemau <kas@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  linux-mm@kvack.org
Subject: Re: [PATCH] mm/khugepaged: reject shmem collapse ranges beyond i_size
In-Reply-To: <5f3dec4f-0416-4550-a980-b464a90aeb11@kernel.org>
References: <20261112142335.2749597-2-Jeremy.Jean@oss.cyber.gouv.fr>
	<sashiko-outbox-212974@kernel.org>
	<5f3dec4f-0416-4550-a980-b464a90aeb11@kernel.org>
User-Agent: mu4e 1.12.12; emacs 31.1
Date: Fri, 13 Nov 2026 09:20:17 -0800
Message-ID: <87y0aw8x7y.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2ED87140009
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: f5w4gfrqur9kthzam6mn9o1y6xm5op1y
X-Rspam-User: 
X-HE-Tag: 1794590420-809797
X-HE-Meta: U2FsdGVkX1++Z50nsQqezY4gUx5NrTt7wJ9EaX4K+TU3TAPuKZuz7YLsldXwn6tIkyLYUNpG0qXMhffzqP2FM2ar0wW2h1LJ3a1Vt/Fke0qKjOKHTKrhxHLDVKSFFcrKv++VUGop4YaOEwQDkpZIQ8H7R5fnpttUb2xugdMXAv0T56uuMZzoMk/NHtBognnzfvcD97lSbpUKBIF5DXn3BHUA9wFS/aMlXRJL5tSYJVHoY/X4M7HkGym+Lbu/0BvxfzxBnWfnwc6NFWe07htMyvEWeWAFlwc7l/VOhwu9kJuphNX+f4j8kB8hYmu2uDRF4+o8HOnXiswzs0FJEM0uJIQaK9zSALXScvvC/fLN0aZx67/RIQJHCYCas0oUK9IBhw3YEe9ZHVRrhL004gj8oeiGd2f97ARy9NFDZP/R20dNdGmPrggu+cEa9ytBdoJ8rtexMA0iWFKlYCWFJ+jqPbMCgo7whWFnZKORgu81/XmiNPpJ0gXkQZYVyf0zdAvks2VDAMJZ9+duF2W8lA2aN0DGsMWPP7p5sNUjmFeCEsGjJ5oikFQo7raIm8yZon2XPqU61mdbs0MIJaCuNnn2nk87ZFb41auKg+GAT68BhF/ZSHdqgJZX/iP0IRv300q2s8yfCQTgDJfNqAAJve/z5wud+h4nmJyjtibxQXbFWGyjQRqTbbp6KwfzfpGzpTCcF2JFfBhwS9u8Jk22mh9oMb67TsoMDRU57gl1ybiABYuNuFkVjC7nUw0f3quAEqVpdyzVyl3oZJ952knOAThH9njnvvTjvcNpMCutBGZ0dEKyFf5PCxrrnYmPaikUqoBubXEjWYlOdYaVFbo95BQdwd3ZSQ22FeaxXmDbmm9mZ5imNM3gX+fzMbgQR/hIjGWmpDFi+qI3A55XfKS+fBVBQEsDcVXu5NtaCY38ulB+WCH16oadV+9qjiY8s0xvqYZ2035w2PXswezCcfNHvmp
 43zaijCA
 tbER2e6qnMKCkcDzvBfYQWmGB37VP+EUj02s1/jExDE//0x1Dk0aNaiRdLzeYf1CCCPG6NQCNIgQyyqI0d4QH3GBg78VMVNlFMPUt4W7ebQyJmdMOJwH33pJbWPE1TuoelMds854cBXivSsRpzD+aoq6H7xYnbCCxKBUNw8SFVY49UGsdRUvEMvwypau0mQGOoaPqyYeT190K1YI7sxVFmsjCTME20xUNX5LobczzHWgRKXVxdSVdwKjCpvXqTe9I1sJruxyOB9Rq4KJGEzva9Z9BE8ja9g3VTeDnUhPdEIELEYLhhpVJIa6SFJ5V+txSctkPcOuCyHwRR3n1fSGq14ceIgRSqHwG2nOpjTqVLntBSJ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 11/13/26 15:25, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found no new issues
>> in this patch, but noticed 1 related pre-existing issue it does not
>> introduce:
>> - [Medium] mm: xarray node memory leak in collapse_file() [1]
> Ignore this shit from Sashiko.
>
> Roman, make it stop.

David, will do.

But also it's not how I want to interact on mailing lists tbh. I
understand everybody is stressed and overwhelmed by llms etc. Including
myself. If sashiko is not appreciated in mm lands, I can turn it off,
no problems from me.

Thanks

