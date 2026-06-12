Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 009FECD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 08:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A8DD6B0005; Fri, 12 Jun 2026 04:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 559D26B0088; Fri, 12 Jun 2026 04:27:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470126B008C; Fri, 12 Jun 2026 04:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38AEF6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:27:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD2EA1C3A22
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:27:12 +0000 (UTC)
X-FDA: 84870580704.08.6E8417A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 11CFE40007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:27:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fwxo2+Mq;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781252831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xSXyYCehVzjZ6VWy2CdERbEJQJPls+dlCik6nw/DEmU=;
	b=TtheXppEZHHf+nakejt4+4Wok/zpdZyP4isixsdJsVGa+c+7wB7CRR4calthaks42IkJBm
	TUlerpQfmpoPtBXq4aygXWMTBfgbm0/0pByQBYL37IO1MbX0/ZPHR0cdNRmu2ZRAeJgqKw
	Okhx0NgWHqZFUoGJ0avmVIH8P6RiVRs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fwxo2+Mq;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781252831;
	b=jJhyM3nCoJ2j4ioZPSxaMIH3qJ3xbCNyqu2T/39lVIX/u0bLGUCX3pIa8NaeDWpZ4u/eJG
	Yw6ShnFYUUR9gJGfJc6yG6A2CiE4Mlsdj47AyF3Qh+iBHFNJURYXkBSJZH0xacbqGfELXu
	BBjnIOnM6LJrGruNrS1gVYdFNoILs0w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 076CC41B13;
	Fri, 12 Jun 2026 08:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF1B1F00A3A;
	Fri, 12 Jun 2026 08:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781252829;
	bh=xSXyYCehVzjZ6VWy2CdERbEJQJPls+dlCik6nw/DEmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Fwxo2+MqdsBp0HUK7sEkG667rVMSi+0oB4i0/a7Q5FZ1Np7JummQHadI0olhtS+VW
	 00AS7CCa/GUluWmq/EfI1QHKwI7kcAskqcOCZkM639As8iYGhoJ7ss54RtZVBTk8xM
	 dU9qL3Vp/e0n81SAiuGW9nhIszvJrhOyZmumzEKDEgqpLvOpg9K70pXxbxF/uyGpbm
	 7e+n0ZclKeqB253uRefKsPWrv4VVhadDEFna6pUArf9keMw6jp7js7dmwy+A0MAdM1
	 Iq72q3TDMzQrCxry6J6EKqmPwHa0oiy9acGthOuqdTpGO2E1phr68mS7xw+0HSzACH
	 Q3YJunl0JVnFA==
Date: Fri, 12 Jun 2026 09:26:59 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	"Jason A. Donenfeld" <Jason@zx2c4.com>, Anthony Yznaga <anthony.yznaga@oracle.com>, 
	Mark Brown <broonie@kernel.org>, Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Subject: Re: [PATCH] selftests: mm: fix and speedup "droppable" test
Message-ID: <aivCvvj_Ztezkrie@lucifer>
References: <20260611-droppable_test-v1-1-b6a73d99f658@kernel.org>
 <aiu39cOX1w9ICe_U@lucifer>
 <2cf7bff8-1681-4344-8bbc-16bf4306ade3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cf7bff8-1681-4344-8bbc-16bf4306ade3@kernel.org>
X-Rspamd-Queue-Id: 11CFE40007
X-Stat-Signature: xgktqtf38x933tqohshptoiqhyozjy9s
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781252830-762066
X-HE-Meta: U2FsdGVkX1+L6HdatCTROqhzhliN9lfV4KQdaMg3KDDsKRg942NTtbMh+GIS633OvM+SmYo/6yEhLOQILlgaToU87c9rwdGaCFxBHkFA05QN+2A8Zby0JxPJZBCwADC5VAhPhHTenKjfrB6HHJt7M7NhRMqNFVHphwMxpo7MDz6JlLcfP0OceVpOlb1uwC06IOsGqEcTBeYlus2jAObkRxtrC4Ur0pr7bf6Xz280/dP6AgxpsT8JXJb0sG9UKVG6x0Q7Y44wB9OtHKoo1YBc2xBkzMKaEjYBXWIW7QDshK/YHhozFnUoV9RKhCBOh5Kpj/WqSAmAIN2aU3+H813H40FTTsb1dFHalc0sq1iAzrfXY6HdvrV7PFTmJdIVKm+0UzAMPK3CMotnM48XiU/bt7SaGtCrKbv3DttBkH4hHgyer7MwoAfQPNu58U/6lNVUz6osA5gH4R1GRo6FB8Oszu8vNzgL+gI9xPzHr6qMjXXjvku3F/F7pQjYpsj0rUmE7Ua13UyAH/ZgCcitEeI+pPWHvHIWbEHakUtBnEpyZ7smxMPq/bxpv/Wyz1o7nDzFTARJSNqhPWl9WjBJf7FVSx6zdEuPmhO6KWv5r9h2G7L+sccMY+iWYG6UCcok5iBHLMahK2YrAAVVXupUyVxtdzU/0oO1LJoA9IRA7Z32k09t2eTn3Zc1RsWojySc9TY/o7eQAs/s0kN+76kibQocDBBLq8WC6Ecf688FLNsTNQDEh7E8JHwO0OGIcGpqQBJ4sYoGun+qTXeHnK5QfyJhwdUdu9ik4DAkf80u8nDFp1f+HWW2B+wvvHnd6vPZzYjEzdC/SJG3ub4dwUIghcolGgPhScIZhTbrqVdUM+JkF4A6kXwtSbIdoLN7dHkn2ifPoYUyFvTyZM8slOCxewBKuFs78n/oaDsouzBHSiQ/yGFi6cQlbceMcN9ePiAVHRttWk7bL18pB8XjNcdkMl2
 W00YjIhD
 DIsrctJ7u4aMHWe6SkcaZTdWxJloCcoTVuN00ajQmUwUSOKEOY6duHax+IC9gHXR66WqybjojWN2rPIK5p+wusllDRJp1ovkNGdZSRyyiFbdDLUDZJp6SeVRQ6uUhmw97J4s0dmuqud/Y4dtFqoeATyR2UFC/4qxEAfrXm7ws0C5T0Co5ixLhAABpFquP2Py4bwu5o7X6CBg81U/w1UhByvJEVVPjDcU+1Aoy3M7t0/3ZDJ+5aXpMN3DRVMz9QMIRJSJR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 10:00:29AM +0200, David Hildenbrand (Arm) wrote:
> >>  tools/testing/selftests/mm/droppable.c | 46 +++++++++++++++++++---------------
> >>  1 file changed, 26 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/tools/testing/selftests/mm/droppable.c b/tools/testing/selftests/mm/droppable.c
> >> index 30c8be37fcb9..57e1b6fc5569 100644
> >> --- a/tools/testing/selftests/mm/droppable.c
> >> +++ b/tools/testing/selftests/mm/droppable.c
> >> @@ -17,10 +17,10 @@
> >>
> >>  int main(int argc, char *argv[])
> >>  {
> >> -	size_t alloc_size = 134217728;
> >> -	size_t page_size = getpagesize();
> >> +	const size_t alloc_size = 2 * 1024 * 1024;
> >
> > I guess regardless of page size this suffices as an arbitrary range over which
> > to check things work.
>
> Yes, that was my thinking. "some pages".
>
> I was briefly wondering whether to add separate tests for THP vs. !THP, but
> decided to leave that for another day :)

Yeah we (or Claude ;) can expand and extend later, key thing here is to get the
slowness sorted... :)

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

