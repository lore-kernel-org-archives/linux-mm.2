Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3DAFC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95B4E6B00B0; Tue, 30 Jun 2026 03:03:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B796B00B1; Tue, 30 Jun 2026 03:03:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84BE16B00B2; Tue, 30 Jun 2026 03:03:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62CCD6B00B0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:03:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CDF3E8D90E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:03:37 +0000 (UTC)
X-FDA: 84935688474.06.91461FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 014821A0008
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:03:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BISDlVt3;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782803016;
	b=KUAd9vJcePbm0cHZ+wLp9QfDn4upURQ8lWPPlmhgpvYYQovJX6z5dAa5975jAE+P6VYeVS
	YMOhgVUXAr5EJSFhJZMrBOyCdXlHumNRAOd/iicWG4cq6/Le7rGg+GFNAWp1FkHHe1MsDP
	QoF5URqeDe4Lk4cJ1DbfKS3GUMe4DQ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782803016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BvvAxU3Xhs1Nl4+swhpYpIdDxd5Qh16KvC3SDvRrWRM=;
	b=iv0kis9YVCSbuNBpP/zSIIZE8ez+m54JKg7SWbpPHcP6PedME1nCMY8K5RwOnonO4SijED
	91pL2Aqd0kUpeSJt2TB2rqOB2XnMlzY4v8oUwI+irefyP723GElgp5tZLTlRh13v6W/U5H
	2m96WCDdsPsNsQn0dnf0512zeVDx5GQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BISDlVt3;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 30D3E43CE1;
	Tue, 30 Jun 2026 07:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135BF1F000E9;
	Tue, 30 Jun 2026 07:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782803015;
	bh=BvvAxU3Xhs1Nl4+swhpYpIdDxd5Qh16KvC3SDvRrWRM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BISDlVt34tQXPrwEDT7E7/nW8oeXQPA38ljBMwE4zojQaX4JFuzucmQK0iO0qAYNy
	 PkFD+w/IMV6+ptXpp7JjsvIsJRK6Jam9RFcv8c1C3MktexPxGLP4WVUSgoIvALH2es
	 BKEBK4wqTpqDV3BpOhm+rhTGgSqd+DshHRZ7eJcTIefsVjgAUlz2akw+bNEd8y3UZM
	 b8IqcdTAtC2VyfpzeOpw9InB9WioyZlOvU0NZYU0ml4JKZP6oEAaLnf96ywtMtZ0ef
	 0RxaqNub19UUjpfZM+eyr/cfZ6QfFVWDk2WzSnJTnAeyK6GLhGz6TSIiZPnc+9GmVF
	 fx8e+ZDI5GwRg==
Message-ID: <5ebd3c4a-5c06-43b4-ab0a-7a8f0396c84c@kernel.org>
Date: Tue, 30 Jun 2026 16:03:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Danielle Costantino <dcostantino@meta.com>, Kees Cook <kees@kernel.org>
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
 <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>
 <akCJRTnmA2um3CIy@linux.dev> <akCSftF6mrsKsz1V@linux.dev>
 <e6ca6ac6-92c8-4db6-a82b-cbb92ceaa4ea@kernel.org>
 <68122038-e8e0-47ed-82f8-cb6a23e4658e@kernel.org>
 <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org>
 <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org>
 <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
 <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com>
 <39a79576-dcae-4b66-9478-c81dfe676699@kernel.org>
 <CAJuCfpGRC7NPxcODUsb3YS5nV=qG+-SbSYj1Fwm-QPqgKSVWAA@mail.gmail.com>
 <c5c4208d-a6f0-413e-bad9-49be12f12d55@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <c5c4208d-a6f0-413e-bad9-49be12f12d55@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: t9wys47u1i9a5opcno8w19kj71zkyuwc
X-Rspamd-Queue-Id: 014821A0008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782803015-799139
X-HE-Meta: U2FsdGVkX1/SQ92LnuqTvRBG5m2tue+kK5GC/b0Pt76vEmJqElAR6TPPHxzbVts6vrS5ue7sI//g0SbhERvwWtinqJ3VKwTnCegFMPyOrCWtUnGtljxyefKprv6BE4HyCsczcm13H4siFBmgIONOPpXlkoFSt3aaEikzS+oxnwAdqra+dj2QjhAfhIUtF1fYCIgDnX3ZfaynH6spyBE3OlU9OAyP3eqdoKFj1JjEfozDzCRPlaEIzznatdyRTMuf86H3vxSOYBZu78uN/Ni9zcHKeTFE7Z7VxGWC7EMXFlQX65wpGfY70AF/CkYIu0uMHQeMFFOpBn7BjGGqVuAdhRBkfl5s9OdJc/X1lHti+EguUuhE0Lmxnig9ph+o2YgPAskpQ/DB9wGh4SovJCK5WLEA4Uz1ux9O912q4aUKFgvQophp6Jo7grlDg77M56UYnfM3+UiRaYKr4haVmjt87/5BoLBD5+xFzQB4+gt038zRqeN1BL/VzhKsmFWYhCl9olbm5Vsw76XDZKUGZeSTSt0UmqEkEDo/4a/2tXi0JsTY+h7PNxQBeKJNWN2YbXCfIwBXU40HTNhrV1JajbnccDzJdv189qqpgti8aGzlF2qK3nQ0cQ5805AZoRMgPQ+Wt0oRp1koz7HE3G0Ny3HSSpgREpug2dMP48dXoxNNkijrELWTAWw7dNFj6ttnQSC4UoO/pLaTUfym8pmQkZUC6aNjJlOsAgjaRDyVNUw8TfO70llhXI6a2uvxLntI0cdo+0yhNX/C7tJKUMWUvu9P1Nfmc1IIcJtekAdMTMFtVaolpYuNMRW2bm+6fsPulxCqbg0yMpSICeyNKkjVT80tpUjNKNozGRgE1fZkVE6XM5EQ13iCF0JR7i0Z7l6ux0N3UfpE5BWfGKub+6UDkejq+owGVk9Ps3/NtNquoTIb6CfIT9e1RucanLJroazp4hyNO5e79yYSrSm1IPyS4mU
 quuwmPZg
 L5oYrB0YDTOT8IkDW5h0rwedBig3Fjwc8dcr+JiPEEIa5wdjnhH7fwL5eYddRllTzVEZeS9CsscS0W/EVJRR/PsGidi2b9IfwtkhdkDJi/beDcxXOklOeoqBaTRETS1rGSOyBAubOk77pNDVGBvZFkR1KuI/X1bMNvp3q5ordju4gRnAfITq+4a/RPQQvfJktCSepv+LnpD9AxG7ganu2MsJN8vwzm4X/8JRP7G+F5kFa+cjVKdKy7dVhsmqqH0/eLVZlJubVj03PRAe398Y9DHM1VYRI0qw03Xu1hBwDlV2o6KaGlNvTGFlYTclNfZu5L9RL8oFBWB3zKtcKptp+TtTwz0rU7/oR9Bt+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/30/26 3:12 PM, Vlastimil Babka (SUSE) wrote:
> On 6/30/26 07:29, Suren Baghdasaryan wrote:
>> On Mon, Jun 29, 2026 at 9:42=E2=80=AFPM Harry Yoo <harry@kernel.org> w=
rote:
>>>
>>>
>>>
>>> On 6/30/26 1:39 PM, Suren Baghdasaryan wrote:
>>>> On Mon, Jun 29, 2026 at 9:38=E2=80=AFPM Suren Baghdasaryan <surenb@g=
oogle.com> wrote:
>>>>>
>>>
>>> Ah, here I meant backporting either the kmalloc_flags()+KMALLOC_TYPE =
or
>>> SLAB_BUCKETS approach.
>>>
>>>>> Yes, it's worth backporting, so we can merge Shakeel's change as is=

>>>
>>> Right.
>>>
>>>>> and then once Vlastimil's patch is merged we can implement the new
>>>
>>> Vlastimil's patch has already landed mainline, by the way :)
>>
>> Nice! I suggest posting Shakeel's patch CC'ing stable for backports
>> and then following up with the fix using KMALLOC_TYPE. Vlastimil,
>> WDYT?
>=20
> Sounded like a plan, but then I realized I misunderstood the amount of =
the
> wastage. E.g. on my system kmalloc-8k with 4 objects per slab would hav=
e
> obj_ext size of 64, but now it's 16k? That's ridiculous.

Right.

=2E..which is why I was assuming either the KMALLOC_TYPE or SLAB_BUCKETS
approach would be backported as a follow-up. Err, should have
communicated clearly, apologies.

> I think it will> even self-amplify to some extent? kmalloc-8 would
have 512 objects per slab,
> so its obj_ext is 8k. It will not recursively create an obj_ext for the=
> obj_ext, but other 8k allocation in the same kmalloc-8k slab could then=

> trigger it, right?

True, assuming that by 'self-amplifying' you meant this patch creates
more kmalloc-8k objects, and also now kmalloc-8k wastes memory memory.

> We could say it's for a debugging feature, but also it's running in
> production fleets (and Android?), so probably not that easy to dismiss.=


I think a key factor is when it's enabled in production.

kconfigs says Android selects MEM_ALLOC_PROFILING, but not
MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT.

I assumed that turning it on by default in the entire fleet
would be bit hard to justify... (please correct me,
if it's not the case)

> Sudden memory increase in a LTS due to this backport doesn't sound nice=
 to me.

--=20
Cheers,
Harry / Hyeonggon


