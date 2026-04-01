Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E09810F92EC
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 02:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78ADC6B0096; Tue, 31 Mar 2026 22:37:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7628E6B0098; Tue, 31 Mar 2026 22:37:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69FA36B0099; Tue, 31 Mar 2026 22:37:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 587E66B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:37:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8A7DB9AE6
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:37:49 +0000 (UTC)
X-FDA: 84608426658.20.36837C8
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id EFEA414000A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:37:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eUkfkE49;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775011068; a=rsa-sha256;
	cv=none;
	b=gvqSGLYqj53kyNsyJbJhLohqQSjdlBogCw8P+EWhArrChICWjLC6mnyprlzNY4xtI5gPJl
	gziMOXyYnZptWmhXZx/3v+f3XqdZruDGLZtfzhaBzckaS/pOL0QQykDMn0j0dVRO4Tnvvr
	6S1oMhHfmzDdSCfDxOghygBDVyTN2Vk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eUkfkE49;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775011068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V/AgBuplD7pnvBkbFJrPZhea+7Gp1573Ry9VeaVLzLo=;
	b=8Mvr7W7Yl89MSQR3ZYdatnk3bF68qsMhfJ3R2JMPhOTpC/aoyOHkFUmvPHKeyLNNQAxFTz
	b/1SW4S6zZH+0oukt6Z3YM6VdCH/lN/dFoHPM7NLvnUt2V32k9kSURXX1gpIy9ZDbLI2nX
	foc6vlYIx01wTot1Rr/BkRfZQII5Z6M=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775011065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V/AgBuplD7pnvBkbFJrPZhea+7Gp1573Ry9VeaVLzLo=;
	b=eUkfkE494scS5DpjMexgKp4GRacwUJesJZUh/YUI7JSBAtUQhARYvX74hu0/pEuhyfXYLU
	0H7/S25yVJQZZJiWmyxagB95WKmdz/rPUGK9GdYAolRCAslHL3Ue7048AxPW2HhY8NbtB+
	HJFc2mJ/zryp76I6GeQyjHWKY778Z7Y=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH] mm/sparse: fix preinited section_mem_map clobbering on
 failure path
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260331131054.0164f3b3ab6f7868add37cd3@linux-foundation.org>
Date: Wed, 1 Apr 2026 10:37:01 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Frank van der Linden <fvdl@google.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0D1D7025-7DF4-41DB-83A4-6AA800FBAAD6@linux.dev>
References: <20260331113724.2080833-1-songmuchun@bytedance.com>
 <20260331131054.0164f3b3ab6f7868add37cd3@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: EFEA414000A
X-Stat-Signature: oh157553nbqub1cmypnp6pkaq535x6gc
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775011067-438778
X-HE-Meta: U2FsdGVkX1/67zwtAjbK3lZNhuYgr1TDTVNBpUf1RBpBSPNb51fV29itGQIqm2enZe3TAoD6GrtOWvPvqsSbiCR6QKfJ6D+S13/+AKJh1iL0kuEYUP/zXzGTMDbXzMiPOxdxEtUTy7gVtbtx8zyAmKi9XyxRkmQkbF+YevsTjhH1knFlDarb6X7bMjZuV1HnfYTZLl4oA3By1oyyfZm4S2uc99095IK2e69PeswPdRhn/W89Lpb5x+Pufpk4GaUKjy73HjBAhmFY+b7CNQg80fDto46Yl0pONW5VHfN3bJOcKP5Sk+xvQkMZS/lKoMgInhJBHx4tOvjonVPGJGaK/BXjyjsv9c/FamkNlnLE1fzSk4hflJBEZ9bQme8kT/OOyMFrP175xMjnjmwuLgCJQJA5DegBxokPmdy3c1/9KPAJE4wbHMKi7mvv7/audciE/HJQYKbWOgRDzq4vrO76n16INBPD9FqEmgW4Aaz3g6j4Hdmxkx9VvmTqfEnZ03G1eI6rMUznPHa1wznWsl6W1Nd0JnPR6LVjbjBw9k/kyWaRYe34xCNxcqU49G2/RwFSnLBJWsWOL4/WhT852iDB8wZLv+KW/965AyB4xVlUzTLrwjX2wtGJxZ83koOw+KtA4NEEo4Ms1rNvWhBHISJsAzTrS03a1tYstYkzgFQCvS+BHyHpZAoLWnFuZvFvRugl/kIEKKpZIly++mL2R7yDiiqWDo0ZswipzbJZHjaGwsmfwqCazCPE36kEh3u91M2909IOmKlUBAT+s0tmyIthjZN5MXCv5wG22WUvF55lrhCr2/vgdaO9EibP3T+kDS1UONJW4XDGZRZXRevSb4JWZ0VZ8dyi9zRu2mbpgrBnqqtSq3pbg/ROOKCVfWZ43s16uFYSlF5JY6+LD+jy6F9BRIJ2Msi+unMf+ek8Uq5Ca3AwcBc8wyFyGh4xEF4juLNpOI+JWFtAHP4t9plAFIk
 FT3D6ThX
 Y0pmFcEqMBqyBz8W765eFYFLOWwycFcnrWXQb6bfX+9Ks8yMe53RXFzMXKk+6FJr5iBViH38iYMx3gNQYQriYoUIzN07k2T3lUyrTC2Wmh2T0Vq+P2bukz9Fkgb1c/6Kpsd1+ZaiE9lZzLfdaM0v7lg8K5evv/ThX550tTV6sEHVWXHvtcC1w0wOgv9xuLTNRTy47/oKHbtdLVx/z4+0V7scF02k0NRCPKepHlDo2AWCstZKKmmS0L3qySZU11/GcVhAt8Fr69qqwBsfD++FAtTUjXiA7wBQ8gcbkJeXILX77TQ998Nz6/0mOmlTDHFQn4j3/rui/51WWxNe84B6wAuHcb7x2fvWwwK+TUIDnQs1q+oKrx3/uuius943rkAyNcD/qX5rk/pWIw22ztAyLWBzwIfnR9cSMHyxemo8zmlHP44U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 1, 2026, at 04:10, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Tue, 31 Mar 2026 19:37:24 +0800 Muchun Song =
<songmuchun@bytedance.com> wrote:
>=20
>> sparse_init_nid() is careful to leave alone every section whose =
vmemmap
>> has already been set up by sparse_vmemmap_init_nid_early(); it only
>> clears section_mem_map for the rest:
>>=20
>>        if (!preinited_vmemmap_section(ms))
>>                ms->section_mem_map =3D 0;
>>=20
>> A leftover line after that conditional block
>>=20
>>        ms->section_mem_map =3D 0;
>>=20
>> was supposed to be deleted but was missed in the failure path, =
causing the
>> field to be overwritten for all sections when memory allocation =
fails,
>> effectively destroying the pre-initialization check.
>>=20
>> Drop the stray assignment so that preinited sections retain their
>> already valid state.
>=20
> Here I go again ;)  Are there userspace impacts?

Those pre-inited sections (HugeTLB pages) are not activated. However, =
such
failures are extremely rare, so I don't see any major issues.

>=20
> AI review thinks it found a different bug:
> =
https://sashiko.dev/#/patchset/20260331113724.2080833-1-songmuchun@bytedan=
ce.com

I don't think the issue reported by AI is a real problem, because the
allocation of sparse_usagebuf has already taken these hugetlb sections
into account.

Thanks.



