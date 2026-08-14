Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB9C0C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 13:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3616B030C; Fri, 14 Aug 2026 09:53:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD31B6B0310; Fri, 14 Aug 2026 09:53:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08BD6B0312; Fri, 14 Aug 2026 09:53:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7726B030C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:53:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 38E7180141
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:53:55 +0000 (UTC)
X-FDA: 85100018430.26.0BBCA30
Received: from mta0.migadu.com (out-51.mta0.migadu.com [91.218.175.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id CA9071C0007
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:53:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pwsFu35l;
	spf=pass (imf20.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.51 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786715633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O4jKen4WafWoGDgs6IIGZ5zpt/U3zpVz4Ds4B8aHHMU=;
	b=nMssG/QzsSx5qJwThxw9fHtJrhde7ctftO6//wNmizr0e6Q4T10Bp1XflZCKFecfCEsbrX
	SEnS3emISOwM4RjtVT2TODXcGH8aL1WUnM6yLlKLwRe+RPnMr1x5hibyEJok2l0RYm/PMv
	dvcm4eqcIHZ4vhn94fTG4g37ewFQYxU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pwsFu35l;
	spf=pass (imf20.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.51 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786715633;
	b=k94n9YbkCJHyj6RghDGlPs39e8Tukz6fjzCBLWkptIrat7ZntWxdPMiO18UadUbNh5SM6W
	eelKnF7WoDvqubpycuIcBapX/Xo7erFC/jTeyE1ceIUWKxMlTMkI5fKTFZXAqaaGzKPTT/
	MpnRd9SQk6GPSSP5VwTlu9lpHKybU8U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Uw1XdTbk5Kq6ysdI0CcZpaMs4SveoGhVuvQt1IuZqOA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786715627; v=1; x=1787320427;
 b=pwsFu35lPdxFtMIR130cYdi0nGYRa2f0xCi/ferJg3JEKtWF20jvRgP+ZVVVuA3Rtxxz5pua
 duq+UpUqEmG4kyBstCm3AgvBxqYir4LzYAFZvVPrcGChxz8OLchn7nf/HUlRvfFYGhQrQa8r7sY
 28uXXdcdahgRXQM6zy/w/OBk=
X-Envelope-To: linux-mm@kvack.org
Received: from smtpclient.apple (37.66.176.2)
	by mta10.migadu.com with ESMTPS id d654dc1ab1e3ac93;
	Fri, 14 Aug 2026 13:53:47 +0000
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (1.0)
Subject: Re: fixing sashiko failure to apply (was Re: [PATCH v5 00/16] mm/rmap: index MAP_PRIVATE file-backed folios by anonymous pgoff)
From: Roman Gushchin <roman.gushchin@linux.dev>
In-Reply-To: <an7ewWbMwN20xklN@lucifer>
Date: Fri, 14 Aug 2026 15:53:36 +0200
Cc: Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-Id: <F700B4F3-2068-4DFD-975A-6324DAAB384F@linux.dev>
References: <an7ewWbMwN20xklN@lucifer>
To: Lorenzo Stoakes <ljs@kernel.org>
X-Mailer: iPad Mail (23G71)
X-Stat-Signature: 588ptkso77gb96s1szimud9y3t1cfkfp
X-Rspamd-Queue-Id: CA9071C0007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786715630-957085
X-HE-Meta: U2FsdGVkX1/KuamkKkLbtbKRswdRcBAcJ28ku2g9ZlYkCdQ1++EECuwT1VlbCkOEPXrdlSzQ+WqE9VC+vtMDth3z/KG5hZPIWY6MlLta+UsCUUNtOvRdasAOF98AJQ22veb1A4uXoAeTU+ufWVnhUuCqd4Ntc7FG1SQrKcCCceboiYMrt9AlXRYlVehyT4wdj4gOFN2JxUon6zlz7HNrrY9jEGWDPA0qm3qJL5Cs3ke5oGp8t7if5Bg5qofJxJ3N8csxgehi+NSbHgnUUz180O/jpOj47GhLnLib2Djs/ndRGGzOGDIaPzTVsaBCUd5X/AxHqBIEKC2yh97GMSKMcj9sV/NT2jQlIVdA5fbj296oT4g1wgdx658kmS4KwfRxgQjUauEeYByLy9vcjod2m5NfB2V2EUjhazHUbH8t8lRL5yZerTcCSzJnpSEtuJRbzfUjWcL928v/au9LbcvsNL/J7M7ncJc1NU/MDZNXt/2Uk8MGfQO46G16bjJ9NfYKJJbRp+E/Kkems1XNOxCPIwyqMojuG5dv3bSOTTJ+L1ZuFSWgnWPVMuxKWG+dAhn4SlrnHZLskROrKjLlx3U9VYdzqxOwE3R395DfqjNiGm257L0mF6o2JEtZ5kF7LsXx47bVTLyoPmCovNZ1EOl+gmECURwFAhvs5RRYgMWD/8OyaCycpZmWLQFblOsUi0taSVByhvf3qI9v1M0yuZeWez8qFAqLiTuOt+MzNTdwNHZvAwRAOLkaZ6QJY+fl+KOcPci97EXqiC/TUgiLj4JQIBeNNlUS5jVVutWWvKyie/Ji0MysL2WW2Nufus6tDxwSJpxL+fdeV3d7+MLaAeJK8l9gtOcGjb6+li1yzJM9raJ3NQyk/CLYGQq1X8/T9jvLljGcRY/e2Pl/5qFUC4u66v0ni2aGB+REFfwch9MvPJyJGcl9QbYKWCaXvd1ehBcXrF6H18pZie9DcfGBMMa
 HjLCKhad
 RRlwLGyv/co7gZnnKKMHRDMzhqjjwzcW1jsOmZgSAsKQRbE3jyD6O7Qf2uYH18ao8OmuLP/h7/zSIfAX8dXuD9fjNRrG2q22ilHGznVsn3E5T+AuR3tCR5CDpIro7aB1VT9ddYK6bh5PliHw94nwJhbAXZUGsofBr9A9ghaExTDFiXHanXR3yRtxoI+6buVJHmEj11jmIGW4kuwvsHIsq8suNPFv+DSP8nFLIrdcVHk8KvLfjSefHOAzOc72FS+IClrYHVotQdE9aeRyzO7dmXm9xmcFnopMmYZLbg0KUt3iRJcTKv/QmK05yr/nT36Y1OzkLag5/dbbC4xQDjQOsJSDphtPQzhTVAHp5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 14, 2026, at 11:30=E2=80=AFAM, Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>=20
> =EF=BB=BF[ trim cc list ]
>=20
> +cc Roman
>=20
>> On Fri, Aug 14, 2026 at 02:13:51AM -0700, Matthew Brost wrote:
>>> On Fri, Aug 14, 2026 at 10:01:19AM +0100, Lorenzo Stoakes (ARM) wrote:
>>> On Thu, Aug 13, 2026 at 11:53:46AM -0700, Andrew Morton wrote:
>>>> You'll be mortified to hear that Sashiko wasn't able to find anything
>>>> to which to apply this.
>>>=20
>>> :))
>>>=20
>>> Well, when it's right it's useful, when it's wrong or suggesting unrelat=
ed
>>> what-nots it's less useful :>)
>>>=20
>>=20
>> Questioning your assumptions is useful, even when they turn out to be wro=
ng.
>> Show more lines
>>=20
>>> I do locally put things through claude + Chris Mason's prompts a lot, I
>>> don't always invoke local sashiko as it's very slow and token-heavy or h=
as
>>> been so far, but am planning to do that more also in future.
>>>=20
>>=20
>> Yes, it's kind of odd that Sashiko burns more tokens than a full day of
>> breakfast, lunch, and dinner service. Running Sashiko is a bottleneck in
>> my workflow, so I'll defer to others on this list.
>=20
> Yup, not sure if there are recommended configs for something saner :)
>=20
> Maybe Roman has some advice on that?

Sorry, no magic way to save tokens without hurting the quality. But I am cur=
ious what are your numbers?
Can be model-dependent too. In prod on average it burns 3-4M tokens per patc=
h with Gemini 3.1 Pro,=20
but maybe mm patches are more complex than average, Idk.

One option is to run only some discovery stages (=E2=80=94stages), but this u=
nlikely will save you that much.
I=E2=80=99d say use a cheaper and faster model for the development, but it h=
as it=E2=80=99s downsides too.

If you have an example of a patch(set) which is particularly token-hungry, I=
 can take a look.
>=20
>>=20
>>>>=20
>>>> Sashiko can be guided with a base-commit: tag but I'm not sure how to
>>>> tell it what tree/branch to try, or even if that's necessary.  Perhaps
>>>> someone can figure this out sometime.
>>>=20
>>> b4 gives a base commit, but I think because the trees are rebased it end=
s
>>> up being the incorrect one.
>>>=20
>>> Not sure what the solution is!
>>>=20
>>=20
>> We have seen this on the Xe list (our list is based on drm-tip),
>> typically with cross-subsystem patches. Some cross-subsystem patches
>> apply and run correctly, while others do not but public CI flows run
>> based on drm-tip. I do not have a bisect or a clear understanding of
>> what works and what doesn't, but I think it would be very useful if the
>> community could better understand the root cause.
>=20
> As Mike said, mm-unstable/mm-new is heavily rebased and also carries the o=
ld
> version of the series before the new one is applied, so it's super unclear=
 what
> the base commit should be there.
>=20
> But in general, I wonder if it's possible that we could tell sashiko
> after-the-fact what base commit to look at once the series is in, or re-tr=
igger
> it somehow once it's in-tree?
>=20
> Roman - any suggestions on what we could do to help sashiko find things?
>=20
> (Once mm-next is in place everything with change again, but can address th=
at
> then :)

I can implement any reasonable logic here, the problem is that my understand=
ing is
the current mm process is a bit vague here. Which likely will be also an iss=
ue for the mm ci.
I=E2=80=99ll merge a support for b4-like dependencies specification soon.

Re re-starting with manual selection it=E2=80=99s on my todo list, but maybe=
 a bit lfurther away, as it requires
an authorization, etc.

Thanks=

