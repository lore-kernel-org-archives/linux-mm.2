Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF98AFF885D
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 01:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB1076B0005; Sun, 26 Apr 2026 21:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E61936B0088; Sun, 26 Apr 2026 21:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D77996B008A; Sun, 26 Apr 2026 21:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C654A6B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:51:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70C6CA06E7
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 01:51:03 +0000 (UTC)
X-FDA: 84702657606.05.2246CB8
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6902E100006
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 01:51:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZJIyZvDl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777254661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ILvVMY9IinAdmagfVEGFpLv9wga0zWj49+q4fH7Cbs=;
	b=hK2zafV2Re3VyUefNIl3oJCn33D2JSWMXpHNc5QXwaEWWE9nvDoc0aaFfgcnh6Ux4dBZV7
	gJES27H5SMbcy8//BLGCkz9mswZA2O+9BV2hfCpqsBHDco7a/hU3eusVmc8CXMfDER32jK
	Fwx5sXK2BaMiehEJSC8kYTDjYymQ/RU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777254661; a=rsa-sha256;
	cv=none;
	b=ILEEgcs6yceYTUz5GajN4MT7/jagU7nrRq8WaxgZE6UMSMe6Ds6I18mutF3TSzFNAG1Qk9
	BnsVvR4oGj4Vka/DQpUH8QIuFzKtj+3nmM+wsS003/iDO57TXDZsy3rwZYGZIL6vUojj9H
	PKLpePrAV9qOoNYXRDR4xiOpddvip8A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZJIyZvDl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: multipart/alternative; boundary=Apple-Mail-050A2CCA-0B25-444E-BA9B-12E28AE2505E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777254658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ILvVMY9IinAdmagfVEGFpLv9wga0zWj49+q4fH7Cbs=;
	b=ZJIyZvDlFL8EkayOo3eQtFY5LXrE+m7TDlJJmDBQzf7BrJgx95FnAd+AwFcOM58twrSDie
	1DIyRtZp+dNLLMRod0HMAjWIIx0jTT/n0ZURNh5g9g3srlXBDqt7brWnNNogIyPIJkazcL
	LFUAHGxOKk8/twwDWJyMG2+LvRAzM2E=
Content-Transfer-Encoding: 7bit
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v7 0/6] mm: Fix vmemmap optimization accounting and initialization
Date: Mon, 27 Apr 2026 09:50:18 +0800
Message-Id: <C8490179-1774-4051-B4D1-46F97841317B@linux.dev>
References: <20260426125422.f9fa79ec47db2e552d75e29b@linux-foundation.org>
Cc: Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Liam R Howlett <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260426125422.f9fa79ec47db2e552d75e29b@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6902E100006
X-Stat-Signature: bbpqgzakw55cgf6e9exn68u5juggycyy
X-Rspam-User: 
X-HE-Tag: 1777254661-916580
X-HE-Meta: U2FsdGVkX1/0UOfgYR/fL8HedpASVvx1lFl3PZNieVSglu6egRWTLRvPyx8EdCyUGMQT5BnaS61iVxRtlAWbHe/nVqZ9FgFeiZHrVV35+K6EKMGsQkIh417RdXff6hcIVS/3gZRPKmLERPs9M3jd0kKrEbbH4hKWYdJXDfscJwjhQ/72QajR9uzXeuUaQ4H+zVgYTakXVPOnM8rMN+caVFOjHr9ZKOQjnAJO95DssvIGGL5xBlNyJ4jnLitU3Wm3YCAFAWEu0R4HeCtKTKF3UBu4jNLHHYIUbKsZ/OhYjm7tKwERFwulGlgS3VOsVGdYJrXyiKQz/TOz0mfAagj3fIRh879kNHe9ZGdN9Higd16uhahNPBvwpPBXVVya18YCblblUrDUYZzDc9zx5r1YvywIQdVlIQ+5RwuVbwHgjinlWo9cmH4topboi1O+Cczn7Tsn4GZkdgzH12fafHxLc4fZ1d9+WkRhvQrCyJvE6tq3tmZxfxfz9SLB0VGqe5N5utN2kK0/YesN+FqWhnbtjOtxIugZ6Dzb1IC16r8esCGXmkn3vyrE74W2cKtW9Nlsn3Ve8T/aGseGAFgWlo77slaSyzn+1h1Xn5ADUcoL+rymsGFMGH6H0WeqihgLfI9jSjroldVquRzCW1vJ4jYhqnqSVZyWX02igi7bES0iPKom6kTDgAsXVfIwj5ocxVW2QCW8YT6BuAGpMway8zvALHrCqHGDjbmSmKcEA7SqHELjc841aT2GIMHGDUx8yZ1RDCVVc+Tin5kb4Vk7pfD0oSNWlNdcxOh9QiZE7wmSo2h337KXH1egrY5uenkFHXVEDV1kwecy0lYADAJH5NyYqePJujudpExgsSNCMeH0jjnfiD3rQXZmd1v73wpBn0h5NWzQG1pDmtoCnJqn5IeJE6PK4uVYwP4gQEeHrZR+a63j2ypmKpMdZ17FWd+1cyyFDRmgrtOFUbvP6EQR9Xb
 zJKLaWPK
 kddmLArO5CKfjHVBg31HbPvdTk01Hp0Xd7IlCYU5wEGFdgIHkuNpEgAtKRD2TX0TFS9COogChDdnXjwO2cRHFvRLb/owCbHg4xmcMGvFVLAEbLCgX9OkSUuhWShaLAsNR5PlJhqurQbQwWOOGUf7tPye844CYRNd54YZ2FxAyMPFDKlQA3MfADa+KG20kyERfV5HN+Chc7GriPtAXGOLiSGPpEYi4I05U1Ufvh2zGKvu2Gv3MFwd/bWkVIugR9ArowzvyGmXbO4FM6+eQ563LbRIJqYGkF+UbVte+FMELWobfx9/DExvKiIp3t9bvXptRfgWUCWISx+eFFeV/j9LrYgv9KomuJWPinp9XNqMQYNsCvkJTMpF3ZwjpPJ0waMM1FMV8cVnJlVG51bff3w7Son2KmK7lQMUx1oEISZmToDBjDsPAfKZm8PbL8hl1sd89Akv+80OaDG471GvtjoSfiMhdgz26LnpUSK+9Bbpg7bd0ZwQ28vQ5KB+quyr5pTFU5wR+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Apple-Mail-050A2CCA-0B25-444E-BA9B-12E28AE2505E
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable



> On Apr 27, 2026, at 03:54, Andrew Morton <akpm@linux-foundation.org> wrote=
:
>=20
> =EF=BB=BFOn Sun, 26 Apr 2026 17:26:34 +0800 Muchun Song <songmuchun@byteda=
nce.com> wrote:
>=20
>> The series fixes several bugs in vmemmap optimization, mainly around
>> incorrect page accounting and memmap initialization in DAX and memory
>> hotplug paths. It also fixes pageblock migratetype initialization and
>> struct page initialization for ZONE_DEVICE compound pages.
>=20
> Thanks.  I'm assuming that none of this is urgent, so there's no need
> to fast-track any of these fixes into 7.1-rcX?

Not urgent.

>=20
> So the cc:stable patches will be offered to -stable maintainers after
> 7.2-rc1 is released?

No problem.

>=20
> Sashiko might have found another bug in there btw
>    https://sashiko.dev/#/patchset/20260426092640.375967-1-songmuchun@byted=
ance.com

I see. it=E2=80=99s a real issue, but not introduced by this series.
I=E2=80=99ve sent a separate series to fix this issue.

See https://lore.kernel.org/linux-mm/20260426144447.817722-1-songmuchun@byte=
dance.com/

Thanks.=

--Apple-Mail-050A2CCA-0B25-444E-BA9B-12E28AE2505E
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html class=3D"apple-mail-supports-explicit-dark-mode"><head><meta http-equi=
v=3D"content-type" content=3D"text/html; charset=3Dutf-8"></head><body dir=3D=
"auto"><div dir=3D"ltr"></div><div dir=3D"ltr"><br></div><div dir=3D"ltr"><b=
r><blockquote type=3D"cite">On Apr 27, 2026, at 03:54, Andrew Morton &lt;akp=
m@linux-foundation.org&gt; wrote:<br><br></blockquote></div><blockquote type=
=3D"cite"><div dir=3D"ltr">=EF=BB=BF<span>On Sun, 26 Apr 2026 17:26:34 +0800=
 Muchun Song &lt;songmuchun@bytedance.com&gt; wrote:</span><br><span></span>=
<br><blockquote type=3D"cite"><span>The series fixes several bugs in vmemmap=
 optimization, mainly around</span><br></blockquote><blockquote type=3D"cite=
"><span>incorrect page accounting and memmap initialization in DAX and memor=
y</span><br></blockquote><blockquote type=3D"cite"><span>hotplug paths. It a=
lso fixes pageblock migratetype initialization and</span><br></blockquote><b=
lockquote type=3D"cite"><span>struct page initialization for ZONE_DEVICE com=
pound pages.</span><br></blockquote><span></span><br><span>Thanks. &nbsp;I'm=
 assuming that none of this is urgent, so there's no need</span><br><span>to=
 fast-track any of these fixes into 7.1-rcX?</span><br></div></blockquote><d=
iv><br></div><div>Not urgent.</div><br><blockquote type=3D"cite"><div dir=3D=
"ltr"><span></span><br><span>So the cc:stable patches will be offered to -st=
able maintainers after</span><br><span>7.2-rc1 is released?</span><br></div>=
</blockquote><div><br></div><div>No problem.</div><br><blockquote type=3D"ci=
te"><div dir=3D"ltr"><span></span><br><span>Sashiko might have found another=
 bug in there btw</span><br><span> &nbsp; &nbsp;https://sashiko.dev/#/patchs=
et/20260426092640.375967-1-songmuchun@bytedance.com</span><br></div></blockq=
uote><br><div>I see. it=E2=80=99s a real issue, but not introduced by this s=
eries.</div><div>I=E2=80=99ve sent a separate series to fix this issue.</div=
><div><br></div><div>See&nbsp;<a href=3D"https://lore.kernel.org/linux-mm/20=
260426144447.817722-1-songmuchun@bytedance.com/">https://lore.kernel.org/lin=
ux-mm/20260426144447.817722-1-songmuchun@bytedance.com/</a></div><div><br></=
div><div>Thanks.</div></body></html>=

--Apple-Mail-050A2CCA-0B25-444E-BA9B-12E28AE2505E--

