Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83944CA5FAB
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 00:51:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 652616B0088; Mon, 28 Sep 2026 20:51:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DC976B008A; Mon, 28 Sep 2026 20:51:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F4E26B008C; Mon, 28 Sep 2026 20:51:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 273276B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:51:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C1FD1C2973
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:51:57 +0000 (UTC)
X-FDA: 85264972674.12.A4459D1
Received: from mta0.migadu.com (out-35.mta0.migadu.com [91.218.175.35])
	by imf20.hostedemail.com (Postfix) with ESMTP id 710BB1C0002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:51:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MTeuINsu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.35 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790643115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dxfGKXsjt22oMjT3e9zqK9vh34ayPH6ktSFXgULNLw4=;
	b=MNEhde66B5PQ8HKf/HtkiQDBJUFHXpJ1vym8KEs8nhVNqueGB0xlf77e8HUUYgIkwTEYrk
	q+qVVC5Rb9sBMVgbpGrVdAYhjHBA60oumxyNuwt6G95NKpJN69cMDNRZ4bHmDQyAqPfzag
	Ocoj/Y/dBFNHVw94zOLIFqXDt1uXNX8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MTeuINsu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.35 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790643115;
	b=5NP2Yud+j6HS5UZdU8cyKBQpLZHhCUs5Dp6jgbXvs/RIdIQUiTpJeWsHgaeAHro8jEBm7H
	QmkDxsc334ASGqtD15LxkCgRpM30WgGmmJYJNU3Dv1CqDBWYZR/dlXmj/k4amj2j7xd4cf
	3x8H01+L8purBj9n9PIPphGEnUvGLT4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dxfGKXsjt22oMjT3e9zqK9vh34ayPH6ktSFXgULNLw4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790643113; v=1; x=1791247913;
 b=MTeuINsuF52A64HtkeS9XsiohdQs8roZkjQliWVTYzVthb9Z5/zgWrW2H02RF2MQiP6CwmDb
 7oGCZtKa9j0Y/8OVOZf/VaUmOqCA1IJ89H2hG4qZrO/hSOjHYIPpxocgcWkGr1jSXfM4G9ivC/9
 3zdEOrDEFUADlB7B/mOKXIBg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id d9a95586af9c48c9;
	Tue, 29 Sep 2026 00:51:53 +0000
X-Mizu-Trace-ID: d9a95586af9c48c9
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v2 0/6] mm: Unify device DAX and HugeTLB vmemmap
 population paths
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <e36e8b24-81fc-45c7-8eb9-8b363e3d89be@kernel.org>
Date: Tue, 29 Sep 2026 08:51:37 +0800
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D999F950-DB51-477A-BECD-B68E8F414F81@linux.dev>
References: <20260924075259.2013039-1-songmuchun@bytedance.com>
 <607759bf-59f2-4ad6-b95b-e780ed2acba3@kernel.org>
 <8385F749-0F72-494E-9CA2-2E433A066712@linux.dev>
 <se2tjmpk.ritesh.list@gmail.com>
 <e36e8b24-81fc-45c7-8eb9-8b363e3d89be@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Stat-Signature: nfqsbf9is4koqy5adpatzk1of54ygwxh
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 710BB1C0002
X-HE-Tag: 1790643115-649138
X-HE-Meta: U2FsdGVkX1+XMjnEqjiNlm2ncpgfhMztbEZfs6FvuiK1f9FdAT/ToD8MDS5/hB6ZiBaUSCqhWO3gB/yyJ5yh30nUdLvKt6w3Oon3+8zKASX38BHtXlQRV+DYWB6abVgKc78zdPfq1IlCE0ZcWwsebBZKh1RLoP5Zp8lO8L/p3Sfd4BTiWzo3yfnmSC73N5GtqTCxyBdEypQrCdXItM2Se9NfU+RjCppA9RpDVKxtFHPY9ndMuGzlV272K/kAbQh2cJDSwPomCFj2k00eKLmoRLR+ptVFrpuFndBdbBZLLo5Oj/nIchZ4fx0Ozvgngh17OhvsxUuFIZ3A0+ariPunJ22WVqJO3FKSi4uOev3jraPDeBWzongAcx7RK2fQvUN3qgB+IzcgEIrYLw1R99cq7rir5uesLENtr1otAcN7dxv3Q56l0DYXCqKZZZfLgCi0I9c6WRTv0NjzdWI1I7t7BHQ6UZG+AqsqGGRY74E20oIKj8DYxFey9FpQUcKJ2fbotUK/G9HboPstYn48y+4PNjlkHPXZi1azSKo5yZssYvr005rHogz9rMB1g04AUFLc7vETUiy2LPMqmhzu0rRFrTIfukxqvRvxB+XGzD+wNX01NZiqIODppKb7DaW1b0L9T7k94DdayQFvLKN6J7yEX1wqq8/zckDEWNz87Bxks3+RxpLhVJn7R7pHry/tVDz78z0pQ5B7L6nMyYcJP3NRcqb6MpH+As17sxwCn2KxqCM31wLAfEGVEfYs2dKbAYOfpioRXJxffs7GkaxZcQhD3Y/24EQ8J7UD7ZrfeauQkBNOF2HJYdqArw8cpGhjcZVUEw7mweNBf3q6sI9Pp0ndf0Asxu0TSY5aWh2DCepdvtSb8ttYbDM8C10ke/yBl/pz1KL3SHwVuNYibfW7hglncmbmH29LW891PpG5Md6Bpz7Hr3T9mJbKV/W8Cd7+YtVeLjGfZxYMolQdP4X91Ol
 q01OZNG0
 TuJ2VtJXsvYR74YhkazG4tqBVmETvwsyBMlQXGhrME0qaOu+IfAsI8piNOwn3RksnZfSlvqpmw2jnSnBMXxymRDbdUdS3WMH455vBj3JR1JU+elxBRmwrL9ImLcpnHKnKD7Ol4JZ1N+mo8cjEfWrgMGjrYuNucqiLAO2kVEwKUB5s2AcESPTGX0ACdnAXbNyCVow9N2FtmlcbUSG6o0h1Udibjek++rSLDi8DSe7xyxrTZEI47q1BvtNtp5spyRfd8f0mvW2iOm8hA4JX+K9JbfH74cHkkb2T/pbakFfl87qU28BWn3Pc80pb+UcAVN8It7xPSDoRN3h21+PwVMXrdsIGB02PuD29+3rF3PKoRDxnWS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 29, 2026, at 03:03, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 9/28/26 19:43, Ritesh Harjani (IBM) wrote:
>> Muchun Song <muchun.song@linux.dev> writes:
>>=20
>>>=20
>>> If you're planning to review this series, I'd suggest waiting for my =
rebased
>>> version.
>>>=20
>>=20
>> Hello Muchun,
>>=20
>> Thanks for taking care of powerpc side of the changes. Is it possible =
to
>> share your git/github tree somewhere? Sorry, but it's hard to follow
>> which series is based on which and the overall multi-series is based =
on
>> which upstream tree. If you could share your updated tree somewhere -
>> that would make my life simpler.
>=20
> Yes, that usually helps. And next time better clearly spell out the =
current list
> of series, where they currently are (mm-new, mm-unstable, on list etc) =
and the
> dependencies.
>=20
> I was a bit confused :)

My bad. I will specify the exact branch dependency in a future version.
Thanks for your suggestion.

Muchun,
Thanks.

>=20
> --=20
> Cheers,
>=20
> David



