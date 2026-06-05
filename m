Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF0CDCD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 09:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13BB66B0005; Fri,  5 Jun 2026 05:22:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ED356B0088; Fri,  5 Jun 2026 05:22:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1D6D6B008A; Fri,  5 Jun 2026 05:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF4646B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:22:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B2B0C2327
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:22:13 +0000 (UTC)
X-FDA: 84845317746.04.50EB61D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B059140011
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:22:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mKURoMZu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780651331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jhbbJw1+8nFdKF7iBjsal2tsKrPYztqe8jkFrRv+M4s=;
	b=qKuA19I4D4dIw0wL1YjBX5R76HXRGHy9hldvlXy8UQW+pkYV0YC8dZi7yh6ooonmUzU3RT
	a2KRo2sBKik0y7Ec2A/KQhrGMUwLUbdbt288rqKhCtWnd1rZ7i0UZglLrUFeNY+Hct5Pxm
	U5vUHDLD7hrVPmTnmTovy3ct2s3mHXA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mKURoMZu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780651331;
	b=evph6+O13jdV+2LvYrxbeEawSz5opTVH52aYem5u/a2FVu1J5fGTRL27PbPjVtC7cu4lk4
	BC+lmWDQ/x0+q1IyskthOjG3EtVq8KMGzejyf7tO/GYVvNZaNpaEVkRBQFdgGEcVe5oaWf
	rTIIqEjynUKCldUKcD0Sa9IQR7Sm6v8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D34604174E;
	Fri,  5 Jun 2026 09:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC011F00898;
	Fri,  5 Jun 2026 09:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780651330;
	bh=jhbbJw1+8nFdKF7iBjsal2tsKrPYztqe8jkFrRv+M4s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mKURoMZue+AtZNQKf0EPlAVQIq/zNoBQrF7LiX9aEP+WS86xWR6WnRLEn3wOeRgcA
	 GC09liXgi2keglH9pGZYTeUF9WczP0XQjt43Gk5Muv62Pp+vQnum/z71pcd5eA4CBQ
	 haOZ6ebeEstgl9txZF9Ew69ygrgHdb52t0J74yAwq7N8OUu5whr8zy4ct67eMXuF3B
	 Ur+jh4Ka+PeVXepAPbzvpkrKRszkORT0Agwu4Y11HJwwOf5sdW13Gdnw1hAYqYdGuA
	 3a7TodSNgosYBiAerJETY1esejSTngZgpFSyJNMxxW9MXrXqxopBPZmnyrg1YI2vRr
	 fB2UABqeIUcgw==
Message-ID: <5aae8c80-e886-47b1-a1e1-4e91771f3492@kernel.org>
Date: Fri, 5 Jun 2026 11:22:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: fix GUP-fast fallback for NULL-mapping order-0
 folios
To: Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Peter Xu <peterx@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
 Sourab Gupta <sougupta@nvidia.com>, Zi Yan <ziy@nvidia.com>
References: <20260409014647.397515-1-jhubbard@nvidia.com>
 <4d6c1af0-dee5-4f1b-b74c-2ebc23de7baf@kernel.org>
 <08afbec2-bbe7-4e8a-8d99-8a5eaecaeee7@nvidia.com>
 <aiJbJVbD4W-y1XDg@nvdebian.thelocal>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aiJbJVbD4W-y1XDg@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wbmw1txb89hnzsohnhbc1tpb1cuor9jx
X-Rspamd-Queue-Id: B059140011
X-HE-Tag: 1780651331-983927
X-HE-Meta: U2FsdGVkX1/v/qFqsXPEsw2mOYYhLwdO5/6dfVHEzxRvcVQ8CcvMnxheQDYg+yegJcJ5UzEeQ7DukIF16xgGUz+KePLH7bM/6Gc3TFDNogA6n2CX7YT3MmmyRb9rOyekqxzBU6pCjiiUs6AZbpmvOorxUCyRHhUbxTkjhN4k0qT6f50XMFQy4gOsL45xZh55fm8D41Jm1wCiHty8JfW/KzoNF0JgnARrcxppNP8A1LtoqVxqlOcewHrpd79KqQUJDeC3bw8Wv8zAKMr/7m4x7psMgd0Alj3lpxxrGlJdf0TdROz3Tqf7jmkkUiVZ8wYpH8OJfjm59D9iJUQ+XYlxbL39E8vwp/iaP0TZfrTSIdLNU6k+Qrko0mOL2daIB8k8loj9NoMseTPFsZOKScyII9+sUlRnqML9V3GpCJUu3TNStHCOcxuC3nvjLFfMWnE3M4TdK81ybL0DqnFI0+2AiCcLyc0bUF2/ytgb1Y7OgYMD+YI3BpBp0LMNEMzMFUp+zy5VH0Ue/DgDh15kZh8QzC6OLOVpDkaK1ChAh/4Ek0Ciw3EkHKsOcbQBF0UJrfpRg2+rqf5OKkM6T+cXVeSQSVixXTL3QaqVjxJH9nfN1vUMuMrTqjZ1XtAY8Ts7EA17O6VEOtL9RLlynb7E/Iz1GJ4QScHSD0kZQ13Xms7QMkCw/Gr7LkWcaSucIFM1qNLCkumlSV/5aijYVoyFEOXWWMyHKDY+XQmZfiqSWOGxTmuzi5mZujXTH2x4uNFEOWz23MgUro99hQCCnZzFj7Yg5WPbkVtet6lAiRoLAJrIEPRXvYcK7xxxxn5FalFrmTh738VJ6FLRjhehhc6r3pT3phkwJ4e++cDDEbXPjLHSyncSoBx5/nXWJ+65b0kzf1FYNLQ91/mZFleV3wdY7YAqnO6/LjsrCF5CjDK+Uv28EAdVL758L8FnEzUo1r8C5Qp40+Q1+s3btbGLghEoFkA
 I6pBNQwZ
 bfmk3F7bKhVmm/7r1nXw869dgy0NznyMknVWU4sS0IM12V14Tr8rnJ891orHtLhUF8CJlRnXa/QMS2usYmMfO8lH6Jc9etQIjCKjLaZYZNIHNs6GBkJygEpNIaZP1LLiSffhc8vVvvrmyXz718/+UzUK4sJJIOGyulfzrh3uMILfP33I3YUo+or70cgOGWe9/ivKEMcMb1ZH90c2fpEX6sjwdsiH726QQT7KhYmCUym/1Ku5fFPN9xl6wE9ANfiK5ekp0hGXs/hk+4GhpuUxXxqAXWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/5/26 07:17, Alistair Popple wrote:
> On 2026-05-15 at 10:09 +1000, Balbir Singh <balbirs@nvidia.com> wrote...
>> On 4/9/26 17:52, David Hildenbrand (Arm) wrote:
>>>
>>> Hm, what if secretmem folio just got truncated? I hate to rely on some
>>> handling in the caller to detect truncation differently during GUP-fast,
>>> but this function returning "true".
>>>
>>
>> Can secretmem folios be truncated? I assume you are referring to
>> ftruncate(), I am looking at the setattr implementation of secretmem
>> and it does not seem like it can be truncated.
>>
>>> Zi is working on a way to distinguish folios from non-folio things: that
>>> we can identify whatever was added through vm_insert_page().
>>>
>>> Because that's really the key problem here: vm_insert_page() pages are
>>> not actually folios, they just look like a folio today, but looking at
>>> fields like ->mapping does not make any sense.
>>>
>>
>> I still think this is a short term fix worth having until we get
>> Zi's fixes
> 
> Agreed - this clearly results in a performance regression and we have customers
> reporting it as such. I think Zi might be out of the office atm but when I last
> spoke to him he agreed this fix should go in for now and his approach will come
> later.

He should be back now. But yeah, let's get this fix in.

-- 
Cheers,

David

