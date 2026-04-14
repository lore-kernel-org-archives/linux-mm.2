Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D59FEF531D0
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 03:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A1B36B0088; Mon, 13 Apr 2026 23:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279166B008A; Mon, 13 Apr 2026 23:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5B76B0092; Mon, 13 Apr 2026 23:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0CC806B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 23:04:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F4DB13A989
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:04:02 +0000 (UTC)
X-FDA: 84655667124.05.C753C51
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id CEF032000B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:04:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tobz5XxS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776135841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ciso2AWjvBYztbs3BLR9p/CMgpuF4vlx9bslXu0LY7Y=;
	b=frUeaf9Z+ev0yLx2O8gE5MW9EtVPi10dCDhQD4jSEfqf2PKE0dhUUbxl5vb6HPI+w2h6h1
	630re9B+8ggIQBRGDNSuVW+iYAT9c9AdzxGiXdjI0QJk+/GO3I55037sj7t1pGa63PSHPF
	2ty/JcgtRlw7BUWzAUL2tk5O0ksgkZ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776135841; a=rsa-sha256;
	cv=none;
	b=Ojna75j/ThA7e3QfLyqhDXo3oeTt006D9CY3pKbFi/rGZWPfZD7RFsMHOqMHK/woYi/5tA
	HoaMuiOtO7X/OIs0nEk8hQXgJNxBwkVvjY0oANiaPCPROpW4oTEksmp1Rq+VXq6voZbJIv
	63WhjWBdHZZOoyEa/RIAaxMXuFEc2D4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tobz5XxS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776135838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ciso2AWjvBYztbs3BLR9p/CMgpuF4vlx9bslXu0LY7Y=;
	b=Tobz5XxSRsi9ARWqmEcgmiOa3dSNzREEH+4KLg2B8Lwg/NzF7mQwVhrFOQd0ZgZs/xNmvg
	jWz/oQHSJ6TprcZb/Fqxg8G7aVFlThSaj1LmzdAzo/yVyKSqpbpVu8MvjIwtO/5s4LdP+U
	oyegkg75cyXyxBg+99X7Q1AdM6w8rNU=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 01/49] mm/sparse: fix vmemmap accounting imbalance on
 memory hotplug error
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <2f092c37-95b3-4206-9866-f844273ed1bd@kernel.org>
Date: Tue, 14 Apr 2026 11:03:08 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B4F03CE5-83B7-40C6-A385-BF3BAD9AE858@linux.dev>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-2-songmuchun@bytedance.com>
 <2f092c37-95b3-4206-9866-f844273ed1bd@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CEF032000B
X-Stat-Signature: hq8beqnbf51nmst79bxzx6showjsgzdy
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776135840-439481
X-HE-Meta: U2FsdGVkX18F94u0kJMJ/bBjtQ7kF69+E9WplRBByG6xhzs7TB2LS9UBlJ6+QsM54JDZDni/MOA0cJsRQC/ONcu9xRKS267pyG9g/5VBbf2IFWQC3vf321+RObb1BB3WzKyb0NuwS4PK/4obsq7aq6YPqMlILq7n/m1rL1M431unvtjS/XxGyaHJxkmnlYjmLXvqXcsN8/d/R8RyXYxxvwVzymRQulUV9Qb1LWVNTy6KzSYaI3axeFY1c/9tJuDwVjK0QqgL08tpoSD9YA7bGZmxSUhIQsdcHRSVyKBdWjMRiZxxeDEPC03WgSqpHp1AGuTQlm9i+a9mAzflmOC31E7/MhTdZBYAgF52z8qOFwORasM/jfhSMHHGp7QhdmlmnaAlKS7BjLcrK30W5BAMSblFBLY/Rd5aKSezmreYAPLcCunq/PBTTkN6G4+TXfN2soLHzpljQTMKhR7kH5nQbVEnqmpZzEhAFfQKn0DLqNpSKwstRQaAv+FiiqiYcv7jXwN8VNWUWVhwQxQOnKBq4g7I+RE5LqAgFHp0KzfWT9mRQ/YcH1nMXcUM/fAK0yEsaB0VOvkFN8/5gwx/HWHsbrf8jDFSSeqaCcaq5FfIz+8TvX3n0qcuMBk7pq9/w0MNh0xIOZfIjpBZXHpLnLiPaX0oLR8krsx/Phv96xvnZyUOoETIk76BLH0Wa9A+uyaGBlsFLgPvltECcXiFZs2duH7DVztidAeKdsGgVZ9iXl0eB6L0eng9fk+BptQYPSLN79O9+u11ll+PC8CdadtQ5+yUf9TA5lXjpmbSqI69rC1xeF+AgIhbNu4MZqMCE/Czq3CutV1cszVI8zO68cocn78eWsgS6J7AGyU6/eEsI3iKKJrWdcOljXGp0VcCRXAoLcbQt8R8iHiIkcddaVQB40X/UX9eJJ8jXobAHZgWZb4lY0OPXKi4BVDmhRregJunnQpbviPcQZIIpaG8Ocd
 G5+4L+h4
 rpdyc8gTLsoKJdF9KsbzMbaUyM3obiTHnFrO8XiXFBQ/mDS1V0SlOAKBdcxWj1pKAElt3bXxmOSmtHYxrlfDuAsDDiih/WkVK0F2PMwpe6T7f366KAFYuS8fRefstuJIHuxV3deUBayjBSebR2OZl1jsL+ka6369wI0sFIfq9zYyMNHr6JPLTmpo0tJzJeZQxh1rJTOg6vxDlGLmp0zdWvAIkSeM5LVnZRIoqHBQTPA9ZGTbSBBobWjTgC8dyH28q1/JbDigDR/p1AHs5tv8/mV8dfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 14, 2026, at 02:35, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/5/26 14:51, Muchun Song wrote:
>> In section_activate(), if populate_section_memmap() fails, the error
>> handling path calls section_deactivate() to roll back the state. This
>> approach introduces an accounting imbalance.
>>=20
>> Since the commit c3576889d87b ("mm: fix accounting of memmap pages"),
>> memmap pages are accounted for only after populate_section_memmap()
>> succeeds. However, section_deactivate() unconditionally decrements =
the
>> vmemmap account. Consequently, a failure in populate_section_memmap()
>> leads to a negative offset (underflow) in the system's vmemmap =
tracking.
>>=20
>> We can fix this by ensuring that the vmemmap accounting is =
incremented
>> immediately before checking for the success of =
populate_section_memmap().
>> If populate_section_memmap() fails, the subsequent call to
>> section_deactivate() will decrement the accounting, perfectly =
offsetting
>> the increment and maintaining balance.
>>=20
>> Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>=20
> Can you send the revised fix separately, please?

No problem.

Muchun,
Thanks.

>=20
> AI review flagged that recently on one of my series that touched the
> code, thanks for taking it off my todo list :)
>=20
> --=20
> Cheers,
>=20
> David



