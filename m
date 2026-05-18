Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ADE0CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 11:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A316B008C; Mon, 18 May 2026 07:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063956B0092; Mon, 18 May 2026 07:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE2936B0093; Mon, 18 May 2026 07:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD61F6B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:54:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F51D1616CB
	for <linux-mm@kvack.org>; Mon, 18 May 2026 11:54:16 +0000 (UTC)
X-FDA: 84780382512.11.C7AC53F
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9B48040004
	for <linux-mm@kvack.org>; Mon, 18 May 2026 11:54:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UQOPsdJR;
	spf=pass (imf04.hostedemail.com: domain of william.kucharski@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=william.kucharski@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779105254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DNTRcHpJnCPUP+T3e8e3jYIUQU1ahRjyodrhYJFqx7g=;
	b=mvBeQOrpT03TfORA1yQAVTLAPHwNNqCzpxW0oqDv3yWap4CddbYPXAWf26jYyWVth9lb4E
	QCTJGCDYx/HveQw7yuRLcJSWNmTWqbz+G5Y6zaIj9rNoMxT//oM2kXzWb3jWK2mg9Eb79L
	l6ZFFSyDH70jC5RBK3+sdx5h9RJCADE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779105254; a=rsa-sha256;
	cv=none;
	b=mOs9jR/7Zx6tw6wj6CpvZmVvnfjw8ODVf6XGjs735sZb46J/oaMmxtrpZvrToX7gWFp5pJ
	woX1GXQ0iCnYfypUtEZS+U44cMfRdLKgwjmuXDAQ1x/5p+2nzlqBFNCprGWjBTwPWkY/3V
	i0W0atd0OaU8EnnQGG10o567nfM6/G0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UQOPsdJR;
	spf=pass (imf04.hostedemail.com: domain of william.kucharski@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=william.kucharski@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779105252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DNTRcHpJnCPUP+T3e8e3jYIUQU1ahRjyodrhYJFqx7g=;
	b=UQOPsdJRu83gqkQaOCeL2NIVWeK1LG+6BtYR+OlkKZb3XXXO4nvD3p//svgzuGgTF3FB/S
	HTkdMUFDtyQlSpwpVuj5iEmpZPRu32nqZP37jV8naBuN4Etpy1vwrjP7ucxUh5kR+zmOcX
	8r8mxf9g5E2CxYLYiZ264UtdugDdPN8=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 2/3] mm: add bytes_to_page_end() helper
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: William Kucharski <william.kucharski@linux.dev>
In-Reply-To: <agrmeROd6Xu9m680@lucifer>
Date: Mon, 18 May 2026 05:53:56 -0600
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>,
 Yury Norov <ynorov@nvidia.com>,
 Thorsten Blum <thorsten.blum@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Yury Norov <yury.norov@gmail.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <775CA5CF-27DF-4495-9FFF-0A0C3A650F87@linux.dev>
References: <20260517123428.1181981-4-thorsten.blum@linux.dev>
 <20260517123428.1181981-5-thorsten.blum@linux.dev> <agnehRPd6SeoO9ie@yury>
 <agq2QNwd0n6OK6fN@ashevche-desk.local> <agrmeROd6Xu9m680@lucifer>
To: Lorenzo Stoakes <ljs@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9B48040004
X-Rspam-User: 
X-Stat-Signature: pjh9hgxpwf8gtfec3reh98nzg18eqfma
X-HE-Tag: 1779105254-944953
X-HE-Meta: U2FsdGVkX18adh07mdptR3kFBtviXBjqtpaPyywiPIy1GhiO9y+k9DNtmVOhjpr3bF/c3JXdysjxzVAR0Vx+v7QwMANkDSlSjcgLW9BacfF2vCNyvHrYTFvGQbil/3D9MyHwyZW1rIKCNiQR0Y8z0WATB9zZCCTjuwSCTETrKWGtyiQwX3OdgL5UR1Hct8IEhR+qcKWqPRrdQz5mYecYRHw91zE81HGbnpYrVlwxkZHLHtLYJiNOr50YGNFnqrsA+U9Iy/3WXmD9DAnOmdG2A1lMYhuKStzCR3bfjhRvK484w43KwkgsIt4jBx+ImFOzqNNJRYD2wY2K/Jink2SUcghO/dXkZch2VLHYC3x1kRVcbn7/QtwD8a10fWyK3/630Y3lwU5TCwxcORCf4b9w/hgK1wjfFid0CKJqyJV46AN45QtMbG3wdYtsWUkLoBRlJ1IjGCeHgUHtkzFFGL5fye8Z17j3XbZud6FRiaqrjrLkSrspcxSYchPWJmhpIK3l77SYKTCXufywfr1wh+oo1epozLcD7vnV9d6/SKNltsRY4yQWn9QB2SbYUecFcoXZxQLVVFhgikgel+qO5dbUPVKPjj9J6+xflsxR+9PEqwSP2DiLta+F2LCIKD9Mp4jJz+WjoDx7L/NrHhas+RQcx3dxsrLuBY/JdUcrd+4rlRZ0/EGX2L4hblFHS3WFkuxitsboer9/Uml9tOi30QLQ2DT9KYULHND5BajI2VQETSBiEUJDou7/Sqo306HWElMJsb5oexHSF5PPihd300rsUlquNGtGYKyyFc03sFT2yP8FnfxggM4o78D90rWUzDuXxO0IAWLn4f7pH+SMmmuJImW3SqxkJb7mA9ioulF/BNcm/HE+NUNr8YY0Mzq0SmINjuRyYb+eRYT+CXq++wB58JEBqPZz+Virq1HWLnztZEqv2jY8aihw4ZnMx1NFeHkhx1WsgqBcLPQ+bQWUUfl
 ayMFZ6Rt
 Eb6UJI5g/n5L3Rto5bAejQ9m1MMd5EOFWcq0/SU9/2RnCFfeFaR4Xp8vtP4TtZgSywt8jSoQ6ZEAeRlARvHjkcTH+i4rbkJ3wLASZ2o1MblY+8B+wKC8iAfINkz8Zsyhj04ufkYgxHPRlQWLLTGZuelyW8vx3qHFLRZGd9OLxyl91W4YBl0fkKKv9QxjBYrNWjzLy0odnDiC1/m4exDMzYBOjUMMs8aQ1B3i8rxCL+SY4epQXUkRVjYXY3/ILWZjNdSeXiQE0yE5HeqQrOSNCynFyD8VnuS6Gv51o2xAMY+YJrs4ig+XZAM852hXRj0WqnE0SobDN519rIGK8NjBmYukkOHc3KLW0ZWnGDf+3LknUskgGJ0JuS/TOnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(My apologies for the earlier HTML encoding.)

As with Lorenzo's concerns, my biggest issue with this change is that it
becomes unclear what "page" means in this context.

Is it a base PAGE_SIZE page? A 2 MB "large" page? A 1 GB "huge" page on
architectures that support it?

The "rest_of_page()" macro masks that distinction, where the current =
code=E2=80=99s
explicit reference to PAGE_SIZE makes the basis of the calculation =
obvious.

I don=E2=80=99t see why we would want to obscure that behind a macro, =
especially
when it makes the code harder to follow.

Thanks,
    Bill

> On May 18, 2026, at 04:23, Lorenzo Stoakes <ljs@kernel.org> wrote:
>=20
> On Mon, May 18, 2026 at 09:48:32AM +0300, Andy Shevchenko wrote:
>> On Sun, May 17, 2026 at 11:28:05AM -0400, Yury Norov wrote:
>>> On Sun, May 17, 2026 at 02:34:30PM +0200, Thorsten Blum wrote:
>>=20
>> ...
>>=20
>>> I've got a series for this
>>>=20
>>> https://lore.kernel.org/all/20260303182845.250bb2de@kernel.org/
>>>=20
>>> The feedback is surprisingly negative. Please add people from that
>>> thread. Maybe you'll be more successful convincing them.
>=20
> There's a cost to adding yet more super-specific headers where stuff =
gets hidden
> and people don't know where to put what, things quickly become a mess =
and header
> dependencies are already a nightmare.
>=20
> Also in the case of this helper, I don't see the value in adding a =
vague,
> untyped, confusingly-named macro when PAGE_SIZE - offset_in_page() is =
perfectly
> cromulent and clear in what it's doing?
>=20
>>=20
>> We always can simply fork, but I truly do not understand the =
pushback.
>=20
> Well, be my guest? This isn't a hugely helpful or friendly comment.
>=20
>> These are simple macros that are way spread in the kernel, "include =
everything"
>> kinda linux/mm.h is not needed in vast majority of the users, hence =
the
>> split is logical step.
>=20
> Right but that's completely orthogonal to adding this macro?
>=20
> I'm fine with moving offset_in_page() to e.g. mm_types.h.
>=20
> But a series that doesn't even give any actual motivation for the =
change is not
> convicing, and we aren't required to just accept any change.
>=20
>>=20
>> I'm in favour of this series.
>=20
> OK, I'm not :)
>=20
>>=20
>> --
>> With Best Regards,
>> Andy Shevchenko
>>=20
>>=20
>=20
> Thanks, Lorenzo
>=20


