Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34EFBCCFA18
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 02:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EB1D8E0008; Tue, 11 Nov 2025 21:21:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89BAF8E0003; Tue, 11 Nov 2025 21:21:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78B038E0008; Tue, 11 Nov 2025 21:21:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62F608E0003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:21:46 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 057971402EE
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:21:46 +0000 (UTC)
X-FDA: 84100354212.06.C304A24
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1555D40011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:21:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EarAueks;
	spf=pass (imf04.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762914104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kvK6l0Spby2Ufnh2o78Z5U1zll55EzgJKPTf2NI2yt4=;
	b=ldxZMwrPtZ0ey3uLbhzEt8Fqp8zOvTLXGCnDRPwIvjlfSHQHmlCTNZLC9NAsIQ3HFHnu9Y
	bVCUnVK0uB4s06A48byDJClOT71OLNDuxF8dGAPYhi7lVJZZJjsAhpQCYSIwshrm1Sq5nD
	mB18hsSlNT7IkhQ2tESD6AV1TO1u3c0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EarAueks;
	spf=pass (imf04.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762914104; a=rsa-sha256;
	cv=none;
	b=IHJvqXUUb0Tj63ILvQWkjfq8DmakoNu74ZJqrR5yMOCB9XiYC4tVQKKyIwAhGq6SYemHmn
	4Gz4vrMwOR+JChrWlm1noHg0umxrXtIqGMLkK4ecirbbACa/Ldn/+H42ZBBCD8RREfBkmk
	N+VJcghLUWrQ8N/eQfapiNZLzhqTqz0=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762914101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kvK6l0Spby2Ufnh2o78Z5U1zll55EzgJKPTf2NI2yt4=;
	b=EarAueksC5BoIPzUkMnwSVxkjYw3cjkzTp84rwgAyuj+Z9xxvSmzZj8+Swb6FIW8oJET0g
	wbmHxttRUtr4W7o/9nHChRXgMs/SYZdknRA6BtN1AVC0bLAJG6n/c5E9fYmICPF5GOkHWD
	Gf7TcIc+vefye2qurTC0PH3VRAGTd6Y=
Date: Wed, 12 Nov 2025 02:21:37 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <59f26b5b0c49f8d0f3bdb33f99d69dd3d442ed60@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2] mm/vmscan: skip increasing kswapd_failures when
 reclaim was boosted
To: "Shakeel Butt" <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, "Andrew Morton" <akpm@linux-foundation.org>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "David Hildenbrand"
 <david@redhat.com>, "Michal Hocko" <mhocko@kernel.org>, "Qi Zheng"
 <zhengqi.arch@bytedance.com>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <e5bdgvhyr6ainrwyfybt6szu23ucnsvlgn4pv2xdzikr4p3ka4@hyyhkudfcorw>
References: <20251024022711.382238-1-jiayuan.chen@linux.dev>
 <e5bdgvhyr6ainrwyfybt6szu23ucnsvlgn4pv2xdzikr4p3ka4@hyyhkudfcorw>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1555D40011
X-Stat-Signature: 7sb1ot5tqhoxoyakrctjd4sm5m3idwk7
X-Rspam-User: 
X-HE-Tag: 1762914103-443901
X-HE-Meta: U2FsdGVkX1/LE9eQDqHJLqeYWY7QPELw6T4xitJiwTd4lP1b2/GOZbEwrKAXvnlva/+fptq/HtSU+DxJh4n9FzsIRoCFuqnQjUVty1yCJcpEwg1997Di6Mj9xD7veUv5XkXqffLIzIrVjhegHVm/S74GfTFedMnAJRvo/3b9EF9n+2OFXvLeMNPf7SyN8+V1uiKVaZa8enXg2Jp6Qkv05j7Eo+d23rTH7AbrWHWAx/hQ6qZYSWC+IK98OkfXNiXkiAQ3gcSmyLGoYixY9uo0pz0lImPdNqvSRccJo9+L/gjECSbVq4dPCFx6s0TZOuLDi5/P4zJ/wuLBvTpTSEHvzkWCm4w682uqddEBKgEmnqN4JNe4mYZ7VHYuFBXqpWlCUch6X6oP89kRJin3ySN/gHsNLszpCLBPyUwbEQS6S/1j9jjM+Uf2Oz4Ja525GOUCUv1gl5dCYs5en3lbiP/lrkB/vRiROgK/EZXpj64uDRcvlIvo0rWyExfm2NnxpnD/NC52ggfwkRBvowihDsutq6kwfOz6Z31YpC0CvbSUSZocybP3hmg+4mjkvdXF1bhapcFHENZUkTHvHN3Ao9Lt8yQLZdRjgdFzEppJI0VJuGl9XNHuAKC2tC9OHoVy/Pcefp9+mCRvXfJ6A7hewCAM2SUNNDCr7gVSJXcoNFNv1I+2d0tcsqOyYAJy6IxlfZ14ES/ARNjfFH7Xse/Y2SgC0yHGpfy07OWWEKlj2HjU/tzfbkdcWnibrGwn9EjzrlNaSYC3xr57Tc2aHiwSmA4vmzU5SKl4pMau8d2LFJopltBMZe2PInFSH2OUvuUm0sioHHyDE2q0JqDuth4L/fGhR+h/lM+7bbLAoeDAleaxLJZwLzYx6ZGQum39zY+Pp7F9mn2Mkn6Fi9havtl48dnv+P3YXsl8DrUfArWZBQcV2OejUjb/itlEGc04mGaicM7E529ulwfs9PKQzW1JgG6
 r1IEFUQB
 h1J4eqRz+zxLIavWBfxXY2rDfy5kjpltNVs5y2q/IJD8tCMfICOQhv9NX9Cj9xUwthlKB59PWtGSu3qeomT69KgPxPjBfM4OQyblmUS0UMspdNS9HHk/C+8j+F/PKMGbxifu7144PsAerGK9VcGWVEE7tHcRT2sWLdV4+7ALElhx0FxYXSwLmWGfmmIKxNhDNZlMrAebzH1QOJ3BCGJWPN0ZSp+pQQpta0lBeCtzVP4tVkIpSoSXnW//USovJM8GZnDyb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2025/11/8 09:11, "Shakeel Butt" <shakeel.butt@linux.dev mailto:shakeel.bu=
tt@linux.dev?to=3D%22Shakeel%20Butt%22%20%3Cshakeel.butt%40linux.dev%3E >=
 wrote:


>=20
>=20On Fri, Oct 24, 2025 at 10:27:11AM +0800, Jiayuan Chen wrote:
[...]
> >=20
>=20Can you share the numa configuration of your system? How many nodes a=
re
> there?

My system has 2 nodes.


[...]

> >  if (nr_boost_reclaim && sc.priority =3D=3D DEF_PRIORITY - 2)
> >  raise_priority =3D false;
> >=20
>=20Am I understanding this correctly that watermark boost increase the
> chances of this issue but it can still happen?


Yes. In the case of watermark_boost, due to the priority having a lower l=
imit,
the scanning intensity is relatively low, making this issue more likely t=
o occur,
even if I haven't configured memory.low. However, this issue can theoreti=
cally happen
even without watermark_boost =E2=80=93 for example, if the memory.low val=
ues for all pods are
set very high. But I consider that a configuration error (based on the cu=
rrent logic
where kswapd does not attempt to reclaim memory whose usage is below memo=
ry.low,

[...]
> >  - if (!sc.nr_reclaimed)
> >  + /*
> >  + * If the reclaim was boosted, we might still be far from the
> >  + * watermark_high at this point. We need to avoid increasing the
> >  + * failure count to prevent the kswapd thread from stopping.
> >  + */
> >  + if (!sc.nr_reclaimed && !boosted)
> >  atomic_inc(&pgdat->kswapd_failures);
> >=20
>=20In general I think not incrementing the failure for boosted kswapd
> iteration is right.

Thanks. I applied a livepatch, and it indeed prevented the occurrence
of direct memory reclaim.


> If this issue (high protection causing kswap
> failures) happen on non-boosted case, I am not sure what should be righ=
t
> behavior i.e. allocators doing direct reclaim potentially below low
> protection or allowing kswapd to reclaim below low. For min, it is very
> clear that direct reclaimer has to reclaim as they may have to trigger
> oom-kill. For low protection, I am not sure.
>

We have also encountered this issue in non-boosted scenarios. For instanc=
e, when
we disabled swap (meaning only file pages are reclaimed, not anonymous pa=
ges), it
indeed occurred even without memory.low configured, especially when anony=
mous pages
constituted the majority.

Another scenario is misconfigured memory.low. However, in our production =
environment,
the memory.low configurations are generally reasonable =E2=80=93 the sum =
of all low values is
only about half of the system's total memory.

Regarding how to handle memory.low, I believe there is still room for opt=
imization in
kswapd. From an administrator's perspective, we typically calculate memor=
y.low as a
percentage of memory.max (applications often iterate quickly, and usually=
 no one knows
the exact optimal threshold for low).
Furthermore, to make the low protection as effective as possible, memory.=
low values tend
to be set on the higher side. This inevitably leads to a significant amou=
nt of reclaimable
memory not being reclaimed. In the scenarios I've encountered, memory.low=
, although intended
as a soft limit, doesn't seem very "soft" in practice. This was also the =
goal of the v1 patch,
although more refined work might still be needed.

