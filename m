Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2012BC88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 08:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35B0B6B0096; Mon, 14 Sep 2026 04:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3090B6B0098; Mon, 14 Sep 2026 04:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 227E16B0099; Mon, 14 Sep 2026 04:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB5176B0096
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:10:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 22DCB141240
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:10:56 +0000 (UTC)
X-FDA: 85211646912.21.9C62838
Received: from mta0.migadu.com (out-245.mta0.migadu.com [91.218.175.245])
	by imf19.hostedemail.com (Postfix) with ESMTP id F19531A0002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:10:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tPMIuf5d;
	spf=pass (imf19.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.245 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789373454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JLJxhHpd5N8ph3CeyO4nJNpPMU8JS85zBvaLS4DATz4=;
	b=GjDDP5gDFZmCbYXP5/gd2o8gYHeGR1kAfLxRMGXwNP5wlIoPYYMRQXKk3dvCewxlB7XHLE
	glexkwZE9bGvjwWQa+WJEBH/GfOggEwR/IX6R3ALMOb5e57gxXp16/w/UYpql9wkVYAkmu
	5FxenYiqvIQ1+lDjC2G+SaZOKdd5np4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tPMIuf5d;
	spf=pass (imf19.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.245 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789373454;
	b=RFNENKLp/DoXvb2cLJsms0r2sggjFQFz/ujsuaooWQFxMfg9yPiStnRX4imilTruKVy8xd
	V9sDwh6Zbcj7mFkq0cv/ILh3WqMCDvRlju4CM7k6gsfGrzYytMdHTEmyppJzuNw3LfBTd5
	3AIHPPavGmKCIHNv9Ri4Cel8Bj1lPoI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EL2qahOVs7kqmkuolw57KcCn+w2OQJ2wG5ZeSucQNgc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789373452; v=1; x=1789978252;
 b=tPMIuf5ddQ4bI1YHqUaevVrR2ioofLPaT0FRmcOVWWNeWHkne0wilCeInoAs7hqkkcOR7GiS
 e+wMxXRyjZgozstexfNzuxGw5f06mJzgCnkFmodAdfdCLbCC5J3qXKAsgzVY6k0zVdL5e+SUEta
 3apOrUedxvnm5SbbDuq3bNbc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 24b3c16a06c37a0f;
	Mon, 14 Sep 2026 08:10:52 +0000
X-Mizu-Trace-ID: 24b3c16a06c37a0f
X-Migadu-Flow: FLOW_OUT
MIME-Version: 1.0
Date: Mon, 14 Sep 2026 08:10:52 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Ilya Gladyshev" <ilya.gladyshev@linux.dev>
Message-ID: <9af33e1222c6836df1039eb42b6c0f0514e6f0f4@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v6 0/3] mm: improve folio refcount scalability
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: andrew+netdev@lunn.ch, apopple@nvidia.com, artem.kuzin@huawei.com,
 baolin.wang@linux.alibaba.com, david@kernel.org, Liam.Howlett@oracle.com,
 edumazet@google.com, harry.yoo@oracle.com, hramamurthy@google.com,
 ivgorbunov@me.com, joshwash@google.com, kirill@shutemov.name,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 pfalcato@suse.de, rppt@kernel.org, surenb@google.com,
 torvalds@linuxfoundation.org, vbabka@suse.cz, willy@infradead.org,
 yuzhao@google.com, ziy@nvidia.com, ilya.gladyshev@linux.dev
In-Reply-To: <20260913170615.cd43348e579d8dde5d556fb8@linux-foundation.org>
References: <cover.1789239015.git.ilya.gladyshev@linux.dev>
 <20260913170615.cd43348e579d8dde5d556fb8@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: we34wy3j1zk788c1kwjem51g6f58taxz
X-Rspamd-Queue-Id: F19531A0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789373453-132606
X-HE-Meta: U2FsdGVkX1+DY4SO+ydETRy9tIbMfC8bVzbOz0MddjSg6cSh5OJPtnPLXF1ki2jPZGgrzmv2EY7sM3t+UeA6zPd41DUsgMAqUQJ+kJYvgy1lNjhmQ0msZeuIM23HtBg3UEQ1DD4S5afG28Pwnoep4m5LzjpZUAaejZ7jBR9NulWMXIGJ7tAr0fOnC4YsOF1PjU1jj6iCLF60ApL8oSBZ4SS8SvS6PDQCIPk4Spuyf1RufksOopbXPx+9bZ4Io6/hN7aNcIRAjXidQXUsN4WFX0lwqFspTjz/qfz3vz6PuQyTSjT+LY4DBTmtNDMwOqS4OgS/ZdoV7VLDG56wdInrsTnzqtX5uScaK2cZJcAmcB2BdQdw+jYStOscTNZOgFxewqgfOKtfO0gQEkuYzlVkfPePJMbJAJfV1z1tl7suBk2ZNFILscLscfpJKe8t+lRbABHWCG6MxY9DhYUHtEEIdNXxNry/J1nTkMuRVV6tVoWKEckWDQpVe83uYeE/5RIaz9ew7WNjdUZJZbMzqMoebizUlYGAOkrMA54Jxl1EqbZ+kW5oMCcRb8IwkbJVFe4S9UONlq9/wkrBHXZeQNCVXhaBlvPgTQEksiS+zfxwz9ciSwLu022utmrAmkpzUeSglaDyZje1CI4HdNxycdmsM9o2eSPrDOI3KQNZJ40y6k0TvORFFRkSHMoCMMWh/NrI+LAd8dVp7EmYP55ufE1V5Re+D6x8908dWpatFnbvE39rGslXfX3y0yQhPeCtuelar52sWVVbaHgj1sZ5jgS7e1yS0liH0PWn7SaFfP7SYBjoQlx2f6CjBTQ+4QkJxNEtfeudXrsQSsra9WJK05vr2qfvhpkr1gjHs8kwT7/xZ7OW1gTCTga0AwOt/NHvButUDN7AJW7bE5lpZ1qjjHYp8x7qVLtuIh9cnTNNzdLGqXU3DIaqtUUPNPRwtTBSsIn38Nq0iJWWBuBB4n2GXxS
 7UjcsZWO
 USRLD48fsxPiZ+0WxSu55odW8TCEp9Ww96TKIsalDL2ZyTq2t0OH+UzvQHNScHmlpJ1xkPXxC/LY7fOU/hxtj6aTukZiUikb4tacGAhEojHUE/9+A+SKCH9SEKSyX1EC3eChhoSRprutuQXlPLzzInWZtYoRI6JQVlAHGuQuFjdSkdi/ZnCQOaYxLUpzPS0shFhd7l7sKLp5ZeiWhNakRJk0HQz26freU8TatwhG9/A3HgXVTXbYF//F/fpG3VEdGzbt1SZpJAMdvU2YO2rk08QbkwKfBORFn4Gx3lvHaK675oFphWUIk21X7wZkWYWgod2ZSmXNljqNw1149hRTWMynF8BpB4K3HjynatpM+PKfdkHpa0SJYfBMm2CSOAuMYjsWLnU1EkX7ZfVtWcpVl3VhY/cCp1gpoBWnxvhs9oMh5KfQuNgIQZsjJaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 03:06, Andrew Morton wrote:
> On Sat, 12 Sep 2026 22:50:07 +0300 Ilya Gladyshev <ilya.gladyshev@linux=
.dev> wrote:
> >> From: Gladyshev Ilya <ilya.gladyshev@linux.dev>
>>
>> Recap
>> -----
>>
>> This patchset addresses a scalability issue of a folio's add_unless() =
operation,
>> noticeable during contended IO reads from the same page [folio_try_get=
()]. The
>> main idea is to replace CAS loop with optimistic increment (and deal w=
ith
>> failure later). This requires splitting refcount into counter and sepa=
rate
>> "dead/frozen" bit.
>>
>> To allow for such modification, this patchset also slightly refactors =
page_ref
>> API, consolidating all implementation logic inside mm headers. For mor=
e
>> information, check individual commit messages. The original performanc=
e issue
>> and previous attempts by other people can be found in [1][2].
>>
>> Performance
>> -----------
>>
>> To my regret, I don't have any access to high-core CPUs that I can
>> benchmark on, and a 12 vcpu laptop isn't really a scalability test. So=
,
>> here I can only paste my previous measurements on Linux 6.15. To be fa=
ir,
>> none of the related code paths really changed, so I don't expect any c=
hanges in the
>> numbers here.
>
> From a quick eyeballing, this patchset seems to provide performance
> gains which are similar to Kiryl's ill-fated "mm/filemap: Implement
> fast short reads" [2].  Is that accurate?

Yes, since both patches aim to optimize the same refcount CAS contention,=
 just in
different ways. This patch is probably less scalable than Kiryl's seqlock=
 because
there is still refcount cache-line bouncing. That said, I haven't analyze=
d the code
deeply, and the benchmark numbers are very simular.

>> [1]: https://lore.kernel.org/linux-mm/CAHk-=3Dwj00-nGmXEkxY=3D-=3DZ_qP=
6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com/
>> [2]: https://lore.kernel.org/linux-mm/20251017141536.577466-1-kirill@s=
hutemov.name/
>> [3]: https://lore.kernel.org/all/aqAIFV4nOGPbWiDS@thinkstation/
>

