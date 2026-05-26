Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC360CD6E43
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 249306B00B6; Tue, 26 May 2026 08:44:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9326B00B8; Tue, 26 May 2026 08:44:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10FFB6B00BC; Tue, 26 May 2026 08:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFE9C6B00B6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:44:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A3A8A1C156D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:44:44 +0000 (UTC)
X-FDA: 84809540088.18.AD331FB
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf14.hostedemail.com (Postfix) with ESMTP id B1711100010
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:44:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lMS4QbMv;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779799483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZ+//Mss6s3qN1JOKyb8a9R/2rcpN6zHPDWF1XVoNaU=;
	b=R1PdqimoQGMqiVs2yVR3ZfZYhie2tbb+3Mxr9RG32YB3A0i5F9lIQB73vaMQd1mCa/4RJ4
	9T6O1mL0fRWMdV4SgVj9h7MvAc9xXfexnccZtVj2kQSSnD3FrEne7Z+HgFxgYlYu51+rdu
	KY0Lq3EQxoKBuGAjM1jdVIbtfXZgwUw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lMS4QbMv;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779799483; a=rsa-sha256;
	cv=none;
	b=8rdXEsYedo8w/bvVafMea1jiOCyGRyUD2A2w61hZTo4iCWCDLqu/2y3UYjo9u18sURgCFK
	a4cv3CHikZjUQ6KNYWwzAimEQKgA3QGIml16u+1bP0VOIFIm+2WcQDQeA+Ia/DWq7Bm3f/
	YhI58u8xJwiiUhtSUHe+FlxmcKbtcR0=
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779799480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aZ+//Mss6s3qN1JOKyb8a9R/2rcpN6zHPDWF1XVoNaU=;
	b=lMS4QbMv0ataQoK+t4dIGZlupkZyH7x6RZe3qqCqB4MaCzKmuAJRFdKp34LnWMyV5A2rnt
	Xof+1+4FqRBp1nKu5FFUgPY5sPYwUwkswp6lw6QrA8IRFyn8VvKWO73b2q05qk/HqUZsF6
	yNGeOe07/UT0urDqO25kBowxlNWmROQ=
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] mm/cma: fix reserved page leak on activation failure
Date: Tue, 26 May 2026 20:44:01 +0800
Message-Id: <9A340644-CD8D-44B0-BBC5-43D29E9D046E@linux.dev>
References: <ahWJMwG8xoQli_Q0@localhost.localdomain>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Frank van der Linden <fvdl@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <ahWJMwG8xoQli_Q0@localhost.localdomain>
To: Oscar Salvador <osalvador@kernel.org>,
 Usama Arif <usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B1711100010
X-Stat-Signature: ai8j4xjoumdas1mgiwjw4cwoe69iswam
X-HE-Tag: 1779799482-358501
X-HE-Meta: U2FsdGVkX1/h9u7nmB+6pPUHc0wc4wIXFEL1HgeVBMhNNuadG7n+sDTb3M06tyfpTJGuu6HgXDfq/M5iVZvK690J980iHJBgPvwUiwjkm3CPPHtIphXyskGKjU2/Q80ccNYUgR+p3vVq5XViXvl5QM0Tsz7V1WXPtr5BksjwbcHhMBjb2/BEa55m4qDF1GJ0xbPk4Nxrx4LqS99iC2aJ0baKxdmU92M4/vVZngQVVzqtbri3mRUImWQCN7KmUDBwk2OlCVp1XvsML0WJoJwuuQodT3wvyjxlX3DaGuKIvONj2zYxABQMFufrE6Df7FSHc842SqKk8b+SGfbFNF82QJEEMme+gm8XZFVyHtpvTiuPA/5MqNHlzM1qLsUKrOTnvUmBayF/N3h+dscPTiZgGuF6VtAZ0q9X5ZQpbYaJXCoL1z7Pmn+UQM1to5096/IQNRpn2lztWtQSVfQH6RDy/HV9zLBcutgh3Bh69FQa5aVZL0yUE/ob5JIeIqu/kopyX+zFWGrovQkc0dpu+YLRfjkc70mnRleCYYktd15IgApBi3S3M7QxAjTaCOugQLruBaw8bZTWVCJ8aYTcGTlaC5XzH8ocJTjSDIYb0lksigq346lX/z4JDLY5bdZufzXPVeSlKBOPdLUzRoLByVvlXBVB18UtRnPKZrgwMFHbnTnc/q5C1rhAq41tkTUkEr4iGpi6CBLvVsSrC7MZQ7Fb0mCAUDbz3u3LhO+gi/mSxC5tP3wUYYFnnO80/3oXCxgDQb6+yIxAuS1wsbYIh10GXL5Ii+TzBFGxatotRwaLSdZQpsmVbTpEKncuwNxqHDkCZCJAFLzhnP8gi1Z/KAurRCjKxM8EX0Pbv/+Lg5m+jSEwBABqTlzqhbcKVtVwSxctWvpsZPACz11yNpy8MGEmO+ZFx+Xs/e8SaArnmmiAtNzk0Iq0SrJ9RQ4dO8yuHm/iEyS7k4V5f35lw61TnhP
 /L1OdvVf
 fYkQL+Qi7iFm7NWoqj2AH/ybXcFgNRLSTsUPzJKxRnJWKgKowHL0EH7R72DYZTY2rnl/tFCw2oZIEyERlb0sMUdhua+tUbwpVZIXXDxmr+jLYunwmsORjZBc5JKVlHsK8QrTTWBm4T4guncWSaUVlnG2CDBQLnO+k1eupkqQP2f7b+CYRFIDcM9hxhlKuhu1ftgA7Q5UrQQ56/rPfvJ2oQKQC5PLJEPBrUdDmcW2k+sf91RcPHXHi8N/Skg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 26, 2026, at 19:51, Oscar Salvador (SUSE) <osalvador@kernel.org> wr=
ote:
>=20
> =EF=BB=BFOn Tue, May 26, 2026 at 04:30:03AM -0700, Usama Arif wrote:
>> On Fri, 22 May 2026 14:26:58 +0800 Muchun Song <songmuchun@bytedance.com>=
 wrote:
> ...
>>> diff --git a/mm/cma.c b/mm/cma.c
>>> index c7ca567f4c5c..a30075507d41 100644
>>> --- a/mm/cma.c
>>> +++ b/mm/cma.c
>>> @@ -188,10 +188,13 @@ static void __init cma_activate_area(struct cma *c=
ma)
>>>=20
>>>    /* Expose all pages to the buddy, they are useless for CMA. */
>>>    if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
>>> -        for (r =3D 0; r < allocrange; r++) {
>>> +        for (r =3D 0; r < cma->nranges; r++) {
>>> +            unsigned long start_pfn;
>>> +
>>>            cmr =3D &cma->ranges[r];
>>> +            start_pfn =3D r < allocrange ? early_pfn[r] : cmr->early_pf=
n;
>>=20
>> Should this be r <=3D allocrange?

Yes. So I sent a v2 to fix it last Saturday.

https://lore.kernel.org/linux-mm/20260523060123.2207992-1-songmuchun@bytedan=
ce.com/

Thanks.

>=20
> Yes, I think you are right. I missed that.
>=20
> early_pfn[alloc_range] holds the last assignment, so we should start
> from the next one reading cmr->early_pfn.
>=20
>=20
>=20
> --
> Oscar Salvador
> SUSE Labs

