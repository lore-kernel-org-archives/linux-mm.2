Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B004CCA46C
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 02:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 547006B0092; Fri, 16 Oct 2026 22:26:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F7386B0095; Fri, 16 Oct 2026 22:26:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40E1B6B0096; Fri, 16 Oct 2026 22:26:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21A1C6B0092
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:26:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75427C01D7
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 02:26:04 +0000 (UTC)
X-FDA: 85330528248.11.A2EB372
Received: from mta1.migadu.com (out-43.mta1.migadu.com [95.215.58.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4C0221C0004
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 02:26:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jPKauD8A;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.43 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792203962;
	b=njisD9oTeX2TneHrTUrVPvfcbLScD3UF+emrUwBMThO3l5+hzijhM++InirSrl+nG5BFi1
	3x7T2DuVoBZUGPt7AjTINNvkVD3WjN0WiEFUxdyqp+wAehXr/AdTVs0uudqSXFYKjQVF8p
	MqbepPRjaI9AQn83wK5mjKF0kD9P6wE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jPKauD8A;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.43 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792203962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSPK+2XU0/xlJunjtlBCC61ykTPwt4ofg6fo3y2q1f8=;
	b=bio6HvmX0m9VQqKRi9otVDgnY0ec4PuwcAg93fF3qXQBy4cIUA43ILykgxMQz3qe9REfif
	8Dwd3Ae2BjFcttkxzTCHxBsEEW43/V3j3LQmWIudJzJfr5WHwr5pbkygBiOvGZBSeeja5x
	mcEU4+ESCVVZvT3gXIvvi7+Mt5+IYVw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kT73SQ9qrNBz4JQaoCwZQm7pd4IOO4YKtSqNYA+Lw7U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792203960; v=1; x=1792808760;
 b=jPKauD8AIHvxo3X9/Fm3sSHzHMe5+qfLBhsBokDqFJgwB7p862MKpb/YJ7V1l2E9evGlYDhV
 0chKnX1Yet1G4c4ffLv1DYC54l9N+3QZYvdLl7kRGz3hlIsiQ6LFR3iujOK/55R6K4j42hAeWAd
 Mvg2eqCCUP3XlHq5KwvhiV30=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 67a546fd69196711;
	Sat, 17 Oct 2026 02:26:00 +0000
X-Mizu-Trace-ID: 67a546fd69196711
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] mm: warn on unaligned compound zone device ranges
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261016192111.cf4b6477a13a711248a8a079@linux-foundation.org>
Date: Sat, 17 Oct 2026 10:25:42 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Mike Rapoport <rppt@kernel.org>,
 Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Joao Martins <joao.m.martins@oracle.com>,
 Ritesh Harjani <ritesh.list@gmail.com>,
 linux-mm@kvack.org,
 nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <869C8763-FB8C-41B2-957E-0AD1B22FCC57@linux.dev>
References: <20261016131334.3419393-1-songmuchun@bytedance.com>
 <20261016192111.cf4b6477a13a711248a8a079@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C0221C0004
X-Stat-Signature: 4pk4ymzeg8x7ow1o34rx5ooubx1sc49q
X-HE-Tag: 1792203962-305297
X-HE-Meta: U2FsdGVkX1/Of6BTIopG34HqZeg1d/2pKbViyp4wa2QvOf6duI1hkMjmssp3uZWIGWTN1oztj+OmrtM11XOaJ+641yP7vwA0KcjQ8NVGF4eunt+FKJUBP4Ssu7SmmH91seLN8YcUYosr8kdaMdq6taDGbfOw5ZRw4DjReoYb/bsEmszv0GwGFQ7/SX4v3PPaDMh4GA4UzI35srGLwZZxpO7UzzgdKoyb+EkPtzpZ7cuZ/ij4Afc+wVBZ8OSYtr1vbRRlOCPu1OZrgojR6O8xbUXIIdkXOpxtT3SbTZtqxcD92SEDU0YVzFSqe9OWCS3sJduxP3lgrF090h+JI0BKH7ODTXzOf4hpEtWVKr6UL4yzahcXlNVsXmRJJZ1RmF2i1c2FTF25roi0RNmNSDGHkjXIYb3bF+DUYNW8fDUtHlHW+BJKPRBLRqSy4zSC8q6RN/fWu212D2thXcDj33JKHsvdhi1ZS0cmOEbpz5cAC3sNi4BktSC2fHta/lk5TELqrOcnFGQcwcNBrshWndvcgy7KJ4SMEaDar+BeJbrhcMMHf1X9H/QZ1AFaDnGlORqI3/08UPTEjAOk0E9jLBdUeWCMIC3wqgU4aNRqkSIXjZEQ4LBPSWjY3EZ33vlr3tYwIOSCgYBcQOIm/5c3CRLVV95rcjg9BPv6hiLO4NWE4TgsFeABJo8nMOnN+SCrzAlicucx5P75gAX7USxQ35ZMeP5ReWlO5Edn3jlyie39ZdhGvgbBHEvYSlthccguQEbpLXZ9OJZi2Qs0D/bqXhHW4UoGxeqDu2Q9Ri4oM6NNXE3WpZC3DozE9O4HBrWLbBS3rKx/3yt48+8CpxjYHHxNxLhr0cavc/x0qSSmQGckqY+OIfGvmsTt0IOY5VQ0ns8RY5zeEBM/bAvp5RC/ZqaX8GKRBnF+H4+S5w0SK267sHdcarl4mChxlqsXYA9ToUnMxlziZKSFBLSdNlkrEBz
 RcmYdhzS
 6iPGBhG4v1nOT+iksbWYc9DvH5W0ULeum4RInnOfBHML7yG9zk6WB/V6+jrD/YUQ7UnuxKd+R9S8QXUFGibEK0WEGzA19XSDLFTs3y/9oi2pj5Xg/aQPKqxOg3dj5JIhfNu9909bUi3ytRvnRV9vpq1nBirQt3+ceK/q5wLEOmz57KrVsJlG8bVDAdLt6CuERQCkcQ/v+TEcrCQDBZDxrK6Ub0qZHxyq3yJNk7SLIVZLZZrC8iAGNjYeohjtNb7SQJExkAtoRWhUKZXxnm5gio9vgU9V7EvKrQzk7ttvQRW7ItFjuUxSlMaw8r2Wukc9RE1N6dQehT0QtCic+IkQFlFM7HBrGeV2LQf9jPlGugWMjJ4CSq4KT+ypemd+r/3ZEKMr2DO82KN5q5/zwS+ROI0o62zH9POB0iSmANLtr7Xlc1ok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 17, 2026, at 10:21, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Fri, 16 Oct 2026 21:13:34 +0800 Muchun Song =
<songmuchun@bytedance.com> wrote:
>=20
>> A compound page of order N must start at a PFN aligned to 2^N pages.
>> Therefore, a range used to initialize compound pages must start on a
>> compound-page boundary and contain an integral number of compound =
pages.
>>=20
>> Two recent Device DAX bugs were caused by ranges that violated this
>> invariant, but neither was detected by memmap_init_zone_device().
>>=20
>> Warn if the adjusted zone-device range violates this invariant so =
future
>> violations are reported when the compound pages are initialized.
>>=20
>> ...
>>=20
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -1142,6 +1142,8 @@ void __ref memmap_init_zone_device(struct zone =
*zone,
>> if (!nr_pages)
>> return;
>>=20
>> + 	VM_WARN_ON(!IS_ALIGNED(start_pfn | nr_pages, =
pfns_per_compound));
>=20
> Would VM_WARN_ON_ONCE() suffice?

What I was thinking is that this function won't be called frequently, so =
it
won't encounter a large volume of log flushing. Therefore, I didn't use =
the
ONCE interface, and this way it can continue to catch similar issues.

I'm OK if you prefer VM_WARN_ON_ONCE() though. Let me know what you =
think.

Thanks,
Muchun

>=20
>> +
>> 	/*
>>  	 * Seed the reusable head-page template from the first real =
struct
>>  	 * page. The normal page-init and refcount helpers must operate =
on
>>=20
>> base-commit: 63562804f25cb5b6f5e4f5e3a9f0d1c3c6868596
>> --=20
>> 2.54.0



