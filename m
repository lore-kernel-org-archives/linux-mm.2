Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A6CEC44524
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 02:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E90496B008A; Mon, 20 Jul 2026 22:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1B656B0092; Mon, 20 Jul 2026 22:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD956B0093; Mon, 20 Jul 2026 22:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A54FE6B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:30:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 387D3A03AB
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:30:48 +0000 (UTC)
X-FDA: 85011205776.10.56CB5A1
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2BDF2A0008
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:30:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MSqSNz4V;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784601046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqpkdQj+7qvi4skqZqI1ASqK0ghmKIC3He//asuLC98=;
	b=VSGqu9UVW5fqdpzVHtkoeFaZfHZWAaUonr0jN2Ps/INZsl8Qjyp4BBueetXiqMGkmEwlFz
	YK5BNR3OW6WHI20H2KratcBQPXbvC0Fed70NreQLLxG9Z3br3DOFP8sxvjy7mRUtWRV0O5
	1awP1Rm4M4WfMVWF8Za4UW6lXzKTwA8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784601046;
	b=P6SrPQ5S3sthDqmB+siXzEABhYhZlNAG2Op0JmvPQrhkp530hj2u18q4ihyEJ5tnkJMVCv
	QF3fXJ6nqP09Egssn49rJxQezLcdFY0kmIpDLOOdsNKpMktQrdWrWE4PLwBQ2aobie42gO
	O2hlmY5DLv1qPjlVeofzn3eKjl7OrTw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MSqSNz4V;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784601043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uqpkdQj+7qvi4skqZqI1ASqK0ghmKIC3He//asuLC98=;
	b=MSqSNz4Vj3kzhzaJ0O98ooGg/Sc1TB36RgXR0TxbuPJ6aUn9fymZhWXZLcaYL9eggSaW0a
	G2so9EUVJGkos/7YuUcAJsREUXx4yKSput+DUFM6dNfj2cTaHLqybsCUm8I7RSQfwR0U/D
	whU7CS0UZLMkd/k+c3MYsM9Awb8A3AA=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3] mm/hugetlb: Fix null nodemask in
 alloc_fresh_hugetlb_folio
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260720173707.47616938378bc26a41650b6a@linux-foundation.org>
Date: Tue, 21 Jul 2026 10:30:20 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 fvdl@google.com,
 gthelen@google.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E8AB5D4D-E781-45B5-B06C-4AAFB2518977@linux.dev>
References: <20260705175119.440599-1-souravpanda@google.com>
 <B8DC1E3C-24B1-4608-86B1-5F12B2FF4DBE@linux.dev>
 <CANruzcTi8+37K=YQwpZ51MxzDUKiX-gF6BdFMXax=ozzZw86eg@mail.gmail.com>
 <20260720173707.47616938378bc26a41650b6a@linux-foundation.org>
To: Sourav Panda <souravpanda@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2BDF2A0008
X-Stat-Signature: 4fmnuszzj8yyrbqn6mf1h39xkgi1sfx6
X-HE-Tag: 1784601046-887029
X-HE-Meta: U2FsdGVkX1/8tt+rLjvlBmGsK6o17RrXpJA/aytQ8SaBYEzqjpTuRHBY5tW/uwzg4S/tBboOcQoEsw+NfWUxIcZUGBpHw+kked+xAHJVNz34gwCA8FVf8l94t1lqnb5cguyIhpnYgbFhRoWCnQpb1lnbKeQbUi4z04t6dbAnqnRIlsB52B/RNrtrXieH0pyEdPSMSRXGfaMI28ud1GOyNycxK8vR1CGXqD/DOKC8aKhwIYJI4xuWBV9zuA3DDPz6U++XffMrZ/FinhpEILifeUv5G8otXJRTKjP7ihm53PM8o7GuuQerhOzzr+bbmKFYtGDOHA+agSXq34D2iDjXyN/b5KZToCNyUyUHCZUC5AulwoNxNcOFdJLlbLZYirMNlZDjfVmCAjF0UoDrnY/hW/YpRRt5+CeIjAuWgQTayAuWtFZOiVrpTfC0ejOmcifswWFUpBYMRldF4DcSvi8H2MKyocoyYH4WumCKhVt6KSDN9rBdNmuF4lXhbXThYIANrGtYlxlafQCQTP9HkOlvfS87u6HiG0AMAuUW/JO2uDPpQcwdOwuhTJQEoeuTOI325xvY8ds41ys7+GIGdARVeUgv1xLNatVtNyDcEK2B5a0w6a4PdXc2xSPcm4KxiLF/Si0scTvZuia42RQudcxQxBdmVJwpsDLAbiqHoBxQ3snm4lZ9UrdKpItbKnCTAm4wod+ctwzPW/21R0Vsm2/Dxl99XohlnC8V7yTej0rfUoBEtEFsBskjjLtqDAvchYe8Yra0mdf4AuIFEC9K8RaGVUqIsYP50QHqd1kLjjkD9pFLSY7oF0fMXdFo09oNBOBccibIDP2PuYS0/NhZJn0qsfei39NUAaFS9V7eWLzwt0QkysyzblkCiaL7QLy/2NODhjqIgf5OhPwfFe3sjT07IE82uf+YSpKEvrzZb7HwXYP2O4/hoTaeWjfWjl3tyPELWFl+UE1I8LCkwiLDyCK
 V4BKWDDU
 xMCfO5xTmILf+euu5YVYjWNwM4+r57DReryKHfYARagt6ttSFloPNakRIxoDSHOforRnRt7fnYqMD3+bwGRE9i8EIZMb/QzW5ItphXkFlbrHyCVBSbn/aUq10h3TOxbIUXhU3Y5OzP+gJuCJxtulLvIRMBeVPY7glQMK3wA3JrzSflXMtMLR6xuGidyH38yylsTcvl5gl+nuGlBLT3C8vKh9awSGaUNl26r2OvNef0+90NuDG0M2lAwSKJOhUaZBB7HktfWBZqZhfiRInOA50yZv1RPQLYeaKi/087TN62RGbT5ZVX5CqbFjLzu8NjvXwlxoW6swMLSjj+JiKzKFBA43iQjikgGzxVNzE2DKkc51GcIw3lhq7DZ+pvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 21, 2026, at 08:37, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Sun, 5 Jul 2026 23:55:31 -0700 Sourav Panda =
<souravpanda@google.com> wrote:
>=20
>>> - Option 1: Fix it directly within alloc_gigantic_frozen_folio().
>>>  This would centrally cover both of its underlying allocation paths:
>>>  hugetlb_cma_alloc_frozen_folio() and alloc_contig_frozen_pages().
>>>=20
>>> - Option 2: Fix hugetlb_cma_alloc_frozen_folio() and =
alloc_contig_frozen_pages()
>>>  separately. The rationale here is that since the buddy allocator
>>>  already handles this case internally, and =
alloc_contig_frozen_pages()
>>>  is also a low-level allocator, it would be better to keep their =
behaviors
>>>  consistent.
>>>=20
>>> Both approaches are viable from my perspective. I'm CCing more MM =
maintainers
>>> and reviewers to gather your insights and decide on the best path =
forward.
>>>=20
>>> Muchun,
>>> Thanks.
>>=20
>> Gotcha! Thanks Andrew and Muchun!
>>=20
>> I shall wait for the decision and then send the subsequent version :)
>=20
> 15 days: no decision shall be forthcoming.
>=20
> Please code up whatever you consider best then send it out.  This will
> trigger a great outpouring of decisions ;)

Hi Sourav,

Please select Option 2 first, as I'd prefer not to make HugeTLB a =
special case
again.

Thanks.


