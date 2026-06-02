Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AB4ECD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 00:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86B266B04DE; Mon,  1 Jun 2026 20:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4B16B04DF; Mon,  1 Jun 2026 20:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3B16B04E0; Mon,  1 Jun 2026 20:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C1406B04DE
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:39:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0011B407C9
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:39:33 +0000 (UTC)
X-FDA: 84833114226.29.AB7E805
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 37FDE20004
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:39:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JPxKSqcS;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780360772;
	b=57jGBrbzv4/lw4wnU7FPw4f6JrVtmLNPWZuTIph73cwLYwix8jfJ7zbV1UR8w03xrvPJDy
	fT2d88x0Z4Tlz8vLggcYTK9c9ac8VQpTMQby1ml8wp+GI6YqSqOi8nPslKxgmrbjFirMQZ
	OK2BZLyrvzm16BwRLteW6IoFGxDOwE8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JPxKSqcS;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780360772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZLruH0m3W08KnNTLHRjnVrTL7t6nQJJg42epmFol5Qg=;
	b=HnwB8+cHpEd5UKbay/y0tHaQPl3vcbMd5lflkMvb0778vp6Q6SuubNbNDrI/nQyvcxiVBz
	s/VDYDkARr1oi9nggkXZ0vvz6sWJRe+UPoRcjLKRkUdzWCermZOg9c0lu/ktI7Bt1xrOcl
	oxzifF0vm/poDOZKMj/rBSQSyHZcn9Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4643A44025;
	Tue,  2 Jun 2026 00:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2511F00893;
	Tue,  2 Jun 2026 00:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780360771;
	bh=ZLruH0m3W08KnNTLHRjnVrTL7t6nQJJg42epmFol5Qg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=JPxKSqcSscNTfuwfvLBv8utgcJoa6sDT/q374gqHLlMLkLxdJ00mrPdM7AXzLUwwQ
	 OFcFSqi5SQEf82OeNoWtIYGXA7zDnW5rPAbSiyf+DRdVhwpoemoHzCc0QsFdA2gyER
	 h9zcquT27k/N11bEOs3cAWFnbBlFrhexYz/xP8kM=
Date: Mon, 1 Jun 2026 17:39:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Mark Brown
 <broonie@kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/5] tools/lib/mm: add shared file helpers
Message-Id: <20260601173929.aa5141c274c351ccbcabc767@linux-foundation.org>
In-Reply-To: <2fb753d0-a9cd-48f3-a24d-ea0b54330279@arm.com>
References: <20260527142432.230127-1-sarthak.sharma@arm.com>
	<20260527142432.230127-3-sarthak.sharma@arm.com>
	<2fb753d0-a9cd-48f3-a24d-ea0b54330279@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 37FDE20004
X-Rspam-User: 
X-Stat-Signature: nq77mhak9yghmoacfyspwyew5o3e9ng8
X-HE-Tag: 1780360772-216968
X-HE-Meta: U2FsdGVkX1+fn0pFRSjGuVm3cUHGBe3GIJmk3kMlF1gaPNK01gzc12+w+FojhJbehDm8fQ0ldUYP5TJpQ4k0zJ7zK06PqRx2KHkXQsSN5+/mVbrbt+33XLhOInfya0fkaRJqfPwpC9ZPnbtC26StXtqDWVCPbhSHNOYwj+iRNaVUzNJk15pWfHhi4q1APBDLd3SoEmnFg9QA1HcUQtDzXNiDGA9+G1bpVPwzHFtRhG/hP0CJaKauw3Jkm6heTAudWkVFWw7/cO0r/csHAK7twwWrlZHiuLz/cVKgcWx8HYZarEHso3jrmZNlecWwH9dH6S1awknEj9JEn1g0NO5eCQwOXIC+IhPsfD7I2B+/ostdzcldPvNMA8xl5TYGHg7caK3maT6sw9xhlawjPGSdzLTawEUW7GexBLZbSiEoCodRACHx34eJM/nLvANUwCC2UcYKGlGsBLNnDmMZ4SxAtkXk5m9/QgcqcIKB7b1WIjPU2iOPznzjD6VHffPJFseepaDqH4ED6/S/KxAirxHUHzLtq9SOLC9jQ5U3RHKOGGZJi36AUDFewSYODHmqJ5UMN3WiufBrx/JzanexpdDQ3ATrgnpVBTiPDkz/7CMVS6WYZC7w+oyOz1mW3PJ39uNzV4IY1TagTBZqlX6XBYp19YD7zmGNg+45oHNP55RaH6A61Vb49RJChTOvoy7qPmia4Xru7fjlYzUZjLYwd2W9U3kNFf2A78KpXktZIKl5LBTbem4u1ydO34pXqJeWbiG4KvLsE0OAgQ7RxQ5A3kNUUtlF27Z/Djx7Tv7qJw4AvxWGQiwWWFVUGlmJWDTXZTZF6MWtn0Y9a++byfx3ubuRudWVPgYzwbCX6v4gMIv1v6vzschPU52bDPtWjk2kAQjBrqzGiYmiCzJWfjaLfdkY90hbACy35eX4sTqtH1hHytvLT7TJgSXr4WIQg/nPrV/y0+60nUqJF8u7rrePHFQ
 oQUe+KKe
 33pjOC4KGmCmcbTocK8jvCdthFw64zI78RDTrLDTQeX0snusWB2bt8Iqwv80sfgGUtneDWKXzYnXDHlM6VLZ4AVKCPlmCzUcmhdPkBws8z1FfgRlZe6mpAHKBZTFzpd33kwRoLpxkzrOQjzYrvf10quSziIRARECCgmZmSKOd0DKMXb5WiYb10d74l54tdE2+bGZPSKo/B5Gyt0Tw8vzl/OH1K0VtDUUkuwNjNoA4zklUuZjqt4/dLmTnkhV3PEVJM8sXWO33ryLt9GQlJMDbJgvMxZvESh3B9EPYM6qpKcARbxs1HPK6W3l6Ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Jun 2026 11:40:52 +0530 Sarthak Sharma <sarthak.sharma@arm.com> wrote:

> On 5/27/26 7:54 PM, Sarthak Sharma wrote:
> > Move read_file(), write_file(), read_num(), and write_num() out of
> > tools/testing/selftests/mm/vm_util.c into a new shared helper under
> > tools/lib/mm/.
> > 
> > These helpers are used by mm selftests today and will also be needed by
> > shared hugepage helpers in subsequent patches. Move them to a generic
> > location so they can be reused outside selftests as well.
> > 
> > Keep the helpers exposed to mm selftests through vm_util.h by including
> > the new shared header there, and link the new helper into the
> > selftests/mm build.
> > 
> > Add tools/lib/mm/ to the MEMORY MANAGEMENT - MISC entry in MAINTAINERS.
> > 
> > Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> > ---
> 
> Hi Andrew!
> 
> Can you please fold the below fixlet into patch 2, as suggested by
> Sashiko.

Thanks.  Please incorporate this (and the bisection fixlet and anything
else) into a v5 series, after 7.2-rc1?

Because it's late in 7.1-rcX and there is still much reviewing and
testing to be done (please).


