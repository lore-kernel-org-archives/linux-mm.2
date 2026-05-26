Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41EDCCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C49F6B0005; Tue, 26 May 2026 07:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673C86B008C; Tue, 26 May 2026 07:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562166B0093; Tue, 26 May 2026 07:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43F6D6B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:13:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDC481402E9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:13:18 +0000 (UTC)
X-FDA: 84809309676.13.1C53FBC
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id B6CC8C0010
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:13:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tJNfFhBb;
	spf=pass (imf22.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779793997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjpF0orjvF0V7w7odDBpl4riq79fYXZGW3boLcM3Ji8=;
	b=3R6h6oGeXpkA3fk5ofr5hiqyID69WuwuqLDkvQizH2jo72Nvz+Gp70ScjzKjVIgGRzmvj8
	jMb2PMFsH7JBY2ZVP04xoni/CUDrSfkNLjBLhPl20QhsgWUbYLeYrhO/HTzBjGtLtR8bpm
	KAmoQJZS//gEJ+kqm+vlZH2MofQ0G7I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tJNfFhBb;
	spf=pass (imf22.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779793997; a=rsa-sha256;
	cv=none;
	b=gWlkMGuqOgeyBd2baS+rIJgaiWuVRXP0Lrs8ndYRFsd6gDUcOyfAfG2KxKicf/SIGFrLJX
	i8/RSvudyj/yhyCbEVFToE210tITiPw6yct86b/2zDkOfvz0BQ/bQn4Bw1aWI8U5+QA4bb
	PUx3HzZyfuVXwzhHMOLZH8lZphYqQQM=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779793992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TjpF0orjvF0V7w7odDBpl4riq79fYXZGW3boLcM3Ji8=;
	b=tJNfFhBb6nEZkjaV1nORtu55FFe2fYeAVJ4+u4AENQjmULOJXH9njHDAvgtJGgUE0hUv0o
	0Q2BpR/Shg0RjQmXJSdKpM4bEwKinKU742K3ZAoozqHT8nCTlfifnDfU15QwxWOH2sYP9L
	5AhJJcaHC7uZjY8bLBqNgU1qKdXBBks=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 26 May 2026 13:13:07 +0200
Message-Id: <DISKBALN21QH.32PUYTB5LZLJ1@linux.dev>
Subject: Re: [PATCH 0/4] mm: misc cleanups from __GFP_UNMAPPED series
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>
Cc: "Brendan Jackman" <jackmanb@google.com>, "Kairui Song"
 <kasong@tencent.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Barry Song" <baohua@kernel.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>,
 "Wei Xu" <weixugc@google.com>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Rafael J. Wysocki"
 <rafael@kernel.org>, "Pavel Machek" <pavel@kernel.org>, "Len Brown"
 <lenb@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan"
 <ziy@nvidia.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-pm@vger.kernel.org>
References: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
 <20260518111546.3baebae99dc3f2a4fd65e605@linux-foundation.org>
 <DIM2YAI5ORUU.2YLTV7PWKE516@google.com>
 <20260518134811.b2b78352779d7519e8123597@linux-foundation.org>
 <CA+i-1C1THr6fH=wdTKEngbCSD_DMS5tGroN64BEf3L56DH2XWA@mail.gmail.com>
 <cd721e44-05cf-470b-ae92-d86791778c28@kernel.org>
 <20260522201154.26bc14524c36df15e40c3470@linux-foundation.org>
In-Reply-To: <20260522201154.26bc14524c36df15e40c3470@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: gpq5up6rj6eurioftirzzs7jdomkegnk
X-Rspamd-Queue-Id: B6CC8C0010
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779793995-558213
X-HE-Meta: U2FsdGVkX1+LGI9POHB5vW0MZQQNC9jRHwg5S5l+iyr+TuSiaOWzP4H/+LC+jIFO8g7nDWriOgER1EUSkbyoA4Q7nVLnQcgYCLgpxMjwc39AT98ZV1bur6YOwIn3HQMdM/WI/rBMMO+ChlJFwvr8mZggczpfQnnUBCuT0nLHekgqWP8VPdQUHG4rlojLkbE5qXXIPu1rev4Jvk8ctPpWkj9ny7/ZA8eqjTghspAiDHvw5Y6somlfvyJ2Ay+EMTb2H1wNSIsV4+vh3lYpDoJZ2T5KGEf3IUM9aALR4f/gptqR0SSr8Ybn0izy8CPPxSoqAgwB3Va5E6oo4i5zs/fYc24Tmp0eBmHroBUPlZqqzr2WjNDTfFT1H0VflwEd7z1uTSL8Akh374iaN2FTwWyl2EoEmIGcx6pS8ixU4FqEB2c+AE9fWgj5l9iBnCXnaI1t6paQ/PIlollznpO30IXZylk60k0C+tfTcOHQu6l+0cF1WHLdm2YOseECATRZk27X3OZtOJDLpm9LnYP1UGTsRClLsfS+G0o+xDcu5DGOAJsdcO7b1ork77RG2BK9WI/54rCvH2QBfvuKEw908Xaew2fFH928ngo1S5jiSZTNcHeBGoQqVJC9sNlj4bbP85UOzuJBP3CFolZ5tQVXBfnfq9JFuYvR7XWJ2drzrwiIOinz8egXH9gp1sZu9IuLCzYVYf+hFLvpt5boIzfN8tUmp+o58xAkX2fvhmoRilhk03GGKw08LNR0OOXomLaIMn8j+us4jLdaVJZTqIDvAe2SvUOYEbOAT2p/7awuaTBre79tlEuXgF5cT0d0FBQFZVqV01QMBLgRL9cKvbpNhDSd1k4L7WC3Y+/ZvTlrCFigAUGrC9HavJwwBob2VhuXXDfyd1ULBnUYMjCu8bEI1T8fXod7xLOoYubBfBELdIBgs3SSWkCvsG7aUVVWK4Bv6TY24f1q9kyKAwLVUogntI1
 9Ut97aZH
 FTDCPfi/BrhqeFg0jwwugS9cQXuw0+l4odpJwN4mzUXABhqfmFTjGoR7/NZtR6BX6H3tXyA2sW6vTgw2nFLj9HVmjcX57KuOjKHh4mxsNHtslng4NQoJoDiLbXn7ocLkqHxYJjPKMsMF93iDRoG0e/FDo45Fej4pSerG9/cZ4YYSSjX5HqMuztI8bl67r1BnLRbgUxaXKRKAD+0UCaFaY6p7NsIwVvE/wZCWkv/QZ4jeiXyLrVMT8Sb6fTVthw0Su/qfca6lGNBpfVhBWiFaD5xdpUNUu89PmmAQW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat May 23, 2026 at 5:11 AM CEST, Andrew Morton wrote:
> On Fri, 22 May 2026 09:59:49 +0200 "Vlastimil Babka (SUSE)" <vbabka@kerne=
l.org> wrote:
>
>> >> > Cool thanks, (also I got the "added to mm-new branch notification" =
and
>> >> > realised why I missed it last time, broken mail filter).
>> >> >
>> >> > The 4/4 update is already up, in reply to the thread.
>> >>
>> >> Is that "mm/page_alloc: tidy up pindex helpers"?
>> >>
>> >> For some reason I didn't receive that email, directly or via any
>> >> mailing list.  I do have the similar "mm/page_alloc: remove ifdefs fr=
om
>> >> pindex helpers" from May 13.
>>=20
>> Found it, seems to be threaded well with In-reply-to: too, maybe it's th=
e
>> different subject?
>>=20
>> https://lore.kernel.org/all/20260517230556.590677-1-jackmanb@google.com/
>>=20
>> Should be fine to replace the current "mm/page_alloc: remove ifdefs from
>> pindex helpers" in mm.git with that.
>
> I could attempt to do that by my confidence that I got it right would
> be low.
>
> Brendan, please send us a v2 of the series "mm: misc cleanups from
> __GFP_UNMAPPED series", thanks.

Sorry for the delay, was travelling - it looks like you have already
applied the current patches, I will send a separate patch to remove
the VM_BUG_ONs.

