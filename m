Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56B18CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2248E0013; Mon,  1 Sep 2025 08:46:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899988E000F; Mon,  1 Sep 2025 08:46:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787CF8E0013; Mon,  1 Sep 2025 08:46:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6393B8E000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:46:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F38895B998
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:46:10 +0000 (UTC)
X-FDA: 83840654100.04.F5B45AE
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	by imf04.hostedemail.com (Postfix) with ESMTP id DE2AC40005
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:46:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b="E4/UvYma";
	spf=pass (imf04.hostedemail.com: domain of natalie.vock@gmx.de designates 212.227.15.15 as permitted sender) smtp.mailfrom=natalie.vock@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756730769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vk19hrLmTMX1+o07BsugobTZFFY1uG8ZJ4maDm0wMWc=;
	b=FlcU6physKRt/etn27ZTvhAlIZUV/SPED/cNgn8EKUbycSIVh8joJBY3P4U68/EIw+96/K
	TGlapTJSHosxLwm0tg8+b4Ph3kcFvomA8r4yYOYPDaZKtLrPM6zD+yz/NUwYwLS4ICy7cS
	eerZCNSxVQwpzmYg6lifScyUnt5buAI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b="E4/UvYma";
	spf=pass (imf04.hostedemail.com: domain of natalie.vock@gmx.de designates 212.227.15.15 as permitted sender) smtp.mailfrom=natalie.vock@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756730769; a=rsa-sha256;
	cv=none;
	b=o5dC9etP7ITPvjMZaWX9ZlJ5gkPaZeulL4fuJuYaWtV4lNvoYK4txq8FuUV3pwGH6HaXT6
	pS5i8hqESn4ltWK/eMmDyVPrqWiCZa4VqMPsn6cL6FxTVCjFBdyfjvoB8exIHXElI/iMGS
	nu+ishkGeJHY59gisTj427YQV8A0vO8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1756730733; x=1757335533; i=natalie.vock@gmx.de;
	bh=vk19hrLmTMX1+o07BsugobTZFFY1uG8ZJ4maDm0wMWc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=E4/UvYmaKAFUAPb7HRhMVnenDOtQJ4PkllkSG20ti17my6nC1CvBao9VJ9+RoIWt
	 ay1+uT0Mow6bgbniCwXv0LTxoUHfDwLOrB9p6ivrOGmefcgDroJmCsJRKzt+Fyypo
	 kfgNkJrHtSAkbnfBNhQkhX/3ae1AyQgWwUXJP+cOpj+v0KgMwZL+I0g1D038G5ijP
	 vZjF76CNeyCSpJ4EfIDyLqDf7Tyl/2iAiU3uL3s6W0dKBwbVzqCbx+oTIY3YRTwhZ
	 s+ASx8AJitMt1/4zKWs0sJXvRvXzabNHBc2Ex9IvHfRhD/FOY0cZK4ngrjpt8GXGG
	 BlK6+++yY+2PX1+mUw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.0.3] ([109.91.201.165]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MA7Ka-1un3cl0fQw-00AguE; Mon, 01
 Sep 2025 14:45:33 +0200
Message-ID: <25b42c8e-7233-4121-b253-e044e022b327@gmx.de>
Date: Mon, 1 Sep 2025 14:45:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/3] cgroups: Add support for pinned device memory
To: Maarten Lankhorst <dev@lankhorst.se>,
 Lucas De Marchi <lucas.demarchi@intel.com>,
 =?UTF-8?Q?=27Thomas_Hellstr=C3=B6m=27?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Maxime Ripard <mripard@kernel.org>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?=27Michal_Koutn=C3=BD=27?= <mkoutny@suse.com>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "'Liam R . Howlett'" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Thomas Zimmermann <tzimmermann@suse.de>
Cc: Michal Hocko <mhocko@suse.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org
References: <20250819114932.597600-5-dev@lankhorst.se>
Content-Language: en-US
From: Natalie Vock <natalie.vock@gmx.de>
In-Reply-To: <20250819114932.597600-5-dev@lankhorst.se>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:RAl06NMOpU7f46c0WobJ33qXFn/0aYGSKvrRkX5ESDCqF/Tb6ix
 2grj9iQdjAGWbMyKVnIkaR0gfzsQfgZVneVcK4nXTGbdrBuKLQfOAHH8FncM3JMKYO44hb/
 BXiFGIjGezs/HoO7Kp7Np8OM2FstFzNBcerte5dUe+wrHU+9jyk/AUFBMzvS6TMdxRzz6K4
 WnLynZfSsJAqg8Ktv1gyw==
UI-OutboundReport: notjunk:1;M01:P0:U2xrOcMtXIc=;jh3Jz8lKaZo68OUS0Kk4/pKIoAz
 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
X-Stat-Signature: 7brg5ha6p8zxpdrgdhc73ped6jb63oeo
X-Rspam-User: 
X-Rspamd-Queue-Id: DE2AC40005
X-Rspamd-Server: rspam05
X-HE-Tag: 1756730768-441194
X-HE-Meta: U2FsdGVkX194ZT/0pPA+02VOQpnhAV3zaf3Yh09jJYSpP2ZjTV5oQ6SM9IRiOK0DH4WZq4eb6463eB/V5d79A651ffnx6gTI+C1fDFTDlzwJkB3YZRgzrjnCDHmQd0eOhfRbufZfBX4xTGuDZa/3ipRRBYpCL3yZK/YxYHChJsjevLgDDKdMRjhI9no+nXB11uRrBzKrTzCKS03nRhk/xHHR1SogRTNwygobVnDmkriuYM1thKUeaBq1Cx5rtfB9HivGy6u9gbCp354qvsas0W46BeNeKIAuGWlmItl11RlrdhrCGmgM6GYU7eFOeU/j6owcepzTqhg139qyjt17mAMLlX9O0VnRBfV4vjObX49xZEYNFIT7lof6jBQqF1+R3J59mX4P2Wwip+Lsf0TPAVVHyuFy8f65S6TEf/IM3rQPYMemZcPOjjIJUQe6biX20HGThvUSiAZ2Jqc937GMbn1L+Dxv8J048D4loufTdvDkEi2nWLk7xrYWSIHtIRyuMDDhFtm4jkkMRZYy5T8mJN1DJ94KZxmyStPQvClWExLO0euIPdsOOJQ0xALc9etnzrn9Rwqw6gTmddLRrlkOHGgpvitmOPw2UJgnteBM8Alf0p4MzbFazgIxkqdD36bTLC+X30iD5+ieCpfqtcFnVn+R3AHNdqklvqPzaU0D0M+c9Voc1hdeAog7TaV2fNBp3iloZ8R9FfOvkINqEZVjwXUrmFHPFGckqmCSWxR2xpPwQEnIJvlP3LzddtXv8IW5HRPbmpTAPSLWzeTxsrPRSsDapB+R4EGHb6t0YyCCusuvvo1lY78wsSoEPcBYdFe4URj4nsv8BdDzAWywkBjowsQCeQKoBeKfI5mD5Lc4cSHO5MrbcasMPI91SBiNGbwLPG6TKYshWe4ARwTmiotImpRW55z/50ZmEL3D67qZTbNnMMGNigrxkhpfjMXJQ3HECzn7MuJ7r0J7bsucdk9
 ObsISV5C
 sFruroU1hHY6ery6n24cRl3KulKeA+9jvvnSq4sW1ME0ktOpO7nRy9ee/Jya43UbsFB/VGb4t9wDj6Z5cR88+AwPuz/1YJ2AEtzkA7iBizLm90rOaRFWwoPI352XmUcfDq85A3KIcTTkknscciyJZa8ej0w1AzJuLTgmOYHRjCDMwawtUYiUDJipmnXmWyBjGdiX/O7IyruepVGsLa0FXQRyxWSCR2orbe0I5VvchVRJl7Aa5d0iBU1c+2ae50wv8lyzUGxnv9vDu/wkgFJmm/R9l2VRfvEb5w/+//2IrzXI3LjkZoXgP3oDwCBzRmsN1vTHgDH4m9PV7XI1KWFhQ6NkUDyfBiQhyyBfKCINnOC/CBQEt6J4Xhc1whQFfMW3y3mDkwrrn/xdoMVelAxxUDiVCAKgqb1KDbENaNgDaZYqqQAp5FlF54rXnEkg8j2/Qwkkz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 8/19/25 13:49, Maarten Lankhorst wrote:
> When exporting dma-bufs to other devices, even when it is allowed to use
> move_notify in some drivers, performance will degrade severely when
> eviction happens.
>=20
> A perticular example where this can happen is in a multi-card setup,
> where PCI-E peer-to-peer is used to prevent using access to system memor=
y.
>=20
> If the buffer is evicted to system memory, not only the evicting GPU whe=
r
> the buffer resided is affected, but it will also stall the GPU that is
> waiting on the buffer.
>=20
> It also makes sense for long running jobs not to be preempted by having
> its buffers evicted, so it will make sense to have the ability to pin
> from system memory too.
>=20
> This is dependant on patches by Dave Airlie, so it's not part of this
> series yet. But I'm planning on extending pinning to the memory cgroup
> controller in the future to handle this case.
>=20
> Implementation details:
>=20
> For each cgroup up until the root cgroup, the 'min' limit is checked
> against currently effectively pinned value. If the value will go above
> 'min', the pinning attempt is rejected.

Why do you want to reject pins in this case? What happens in desktop=20
usecases (e.g. PRIME buffer sharing)? AFAIU, you kind of need to be able=
=20
to pin buffers and export them to other devices for that whole thing to=20
work, right? If the user doesn't explicitly set a min value, wouldn't=20
the value being zero mean any pins will be rejected (and thus PRIME=20
would break)?

If your objective is to prevent pinned buffers from being evicted,=20
perhaps you could instead make TTM try to avoid evicting pinned buffers=20
and prefer unpinned buffers as long as there are unpinned buffers to=20
evict? As long as the total amount of pinned memory stays below min, no=20
pinned buffers should get evicted with that either.

Best,
Natalie

>=20
> Pinned memory is handled slightly different and affects calculating
> effective min/low values. Pinned memory is subtracted from both,
> and needs to be added afterwards when calculating.
>=20
> This is because increasing the amount of pinned memory, the amount of
> free min/low memory decreases for all cgroups that are part of the
> hierarchy.
>=20
> Maarten Lankhorst (3):
>    page_counter: Allow for pinning some amount of memory
>    cgroup/dmem: Implement pinning device memory
>    drm/xe: Add DRM_XE_GEM_CREATE_FLAG_PINNED flag and implementation
>=20
>   drivers/gpu/drm/xe/xe_bo.c      | 66 +++++++++++++++++++++-
>   drivers/gpu/drm/xe/xe_dma_buf.c | 10 +++-
>   include/linux/cgroup_dmem.h     |  2 +
>   include/linux/page_counter.h    |  8 +++
>   include/uapi/drm/xe_drm.h       | 10 +++-
>   kernel/cgroup/dmem.c            | 57 ++++++++++++++++++-
>   mm/page_counter.c               | 98 ++++++++++++++++++++++++++++++---
>   7 files changed, 237 insertions(+), 14 deletions(-)
>=20


