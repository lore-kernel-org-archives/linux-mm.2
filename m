Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6243B606A331
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 06:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pn5hlMQ1
Received: by kanga.kvack.org (Postfix)
	id 5C0DD6B0602; Tue, 24 Nov 2026 01:34:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598BC6B0603; Tue, 24 Nov 2026 01:34:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AE0F6B0604; Tue, 24 Nov 2026 01:34:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1EF3E6B0602
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:34:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 820B9C0695
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:34:38 +0000 (UTC)
X-FDA: 85469049036.05.D57BB70
Received: from mta1.migadu.com (out-109.mta1.migadu.com [95.215.58.109])
	by imf25.hostedemail.com (Postfix) with ESMTP id 44A5AA000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:34:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pn5hlMQ1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.109 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795502076;
	b=I/mhccwbG9IewxnUlEDf4oHmT3GyrumVheDdRwEA/K3y7B16/Xkqjf8bccaRclnTijLM5N
	hvtHOEzLFHSGE4u3txjw5d/Sdj1dBmxe8Fp1qlkpYme9qdUksv6HeRvJVZfvpHWQ63JDNq
	vwT+eFSbrY53CQzL/gHVNCI+ZwDc++g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795502076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXbi9yNhidHwh55GelyFmLkRwoKv3QmTo7vFxn6GgFE=;
	b=p2J8EXiraTqpiKF/fAo+yQTIXU5QwB6rVh9rgYjXggWfVLEpa0w5EjqAqGna8ZUMMG/N++
	c3L8p2ZUwxEW/Ao3CNJOdK3RadtS8v+g3Dt5deActa2zuOa/LdtcXllhW2Mr35Do5msqaV
	5vTTK8LJuOeIWRSnD1zphqCWtUrTiqg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pn5hlMQ1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.109 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NXbi9yNhidHwh55GelyFmLkRwoKv3QmTo7vFxn6GgFE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795502073; v=1; x=1796106873;
 b=pn5hlMQ1435ibB7vGL17lTJywWV1OMBli3vks0P/9aPI/NQGQH9MCfI1TTZnymEUdL3qTsJX
 e3csdSHtE0ulpNSUeTGPoZOmkGwODmJ+rHgaIHP8KOCPoXMrvUZcGRPlUXANNBPh87dNuhsfehS
 cOtFlBlRGSjfDbr1SpUsaESo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 80c8d8955432b0c9;
	Tue, 24 Nov 2026 06:34:33 +0000
X-Mizu-Trace-ID: 80c8d8955432b0c9
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] memcg: free the private ID of a memcg that never comes
 online
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261124052054.GC555944@shakeel.butt@linux.dev>
Date: Tue, 24 Nov 2026 14:34:18 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutny <mkoutny@suse.com>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <67C04BF9-9F11-41D8-AC98-1D6465FEE36F@linux.dev>
References: <20261124000439.967403-1-shakeel.butt@linux.dev>
 <F39B4A81-BB17-4C5D-851E-2740EBBBBA8B@linux.dev> <awUTKy9tx8nWJgXf@linux.dev>
 <2FE2D209-FB57-4191-A324-F179B2394DB1@linux.dev>
 <20261124052054.GC555944@shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 44A5AA000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: sawzdwir7i5nzn5o8he89jth5c8beigw
X-HE-Tag: 1795502076-542979
X-HE-Meta: U2FsdGVkX1+Ib9IarMa1Gauoe8KjUV06WAUyzZxsVRJrHReOMTgZ1P41jQcpXKDXWHA4wpxj1e7Hx28O733nzhj/vwVKt0GTeCOPGVUf9rbfLmtpM+ixGjt2aB7x0MGRJR7sHa/Gy/9yHwo1VBEzsMjAeGRGzZVL/NUumps3on7YE/sExZXTVbDWQKU/F/7rJX8074WVH5SUMHUy2CNX0O4LgnxT7+v8KbJ3e8gICw/6sMLezVZkASLhd6nlBCmABWwkTB4dqhVC+6ZrhjMxsBBIEPJ3lK9YKMkEGkbHLSsc14QhsWUZm2UwDqlhiqfvXUCapjVBHDkA1Gy0ueXd650xsB2XcgBhr64isgWA4lh4PExhMf3gvqv1JiGVo4/zBG94jYC6MU/l5700GFceZ80JylkTuXqQnYYJgn8myouqACXx7cJaJYuH5fxDsqtlHrAGxtkJBytnDX7jsgDsMJmwPzIM5HISGwmwJYwjhyj6TfOvS7OwzWqC6lk7V0B4B8jcD/a8U+ilsQOk0Bu2MnB7+A5uyyAIqQg6YF4O4fxxeOd4Wd11QhqAoz5DR2/G/1LZvCDXS3Kpam4vqBhJkDHdfpSSTFdIKBZ2FEpVj5/IWTme+j2bupsfOlTZaKD3TVWfctKzEl5h+XBSQuIx4ufGxyycbPXAEfKo/Aq1jJ7RhLatrfLsMxPvm7bq+bzUIifBkHHGe4WhIlG4Kts0LnGjHS58JnhewFTRqsobfMM8lDZl+/3Q9hej1biMOlKjrMBTlWrRE2TN3tONwgdPglvvJwxyAoTQTLhZoU5rbL8uSGN5woxrZ6D3oRHy+3CSVClaFsOxf+t1UyfCiQfkEn6TKisLM4QxG+TiponV9C7IC+SsfqGoWrswsptmYicer2+/5RFnrt++YV0oTXb4DUksurp8cwxbGGPTO4nQqhnXQjet+oACs/+op54KAIEjj+K2skr9mQiDV61CsNS
 OfQoDYDK
 POZzV4TdFJaUE7sAMCt8Iu8/SZd9LfduDxYJC7MUAsvomKfPQqhZVNDXg6t5DhO4EjVI69kxmZBx9jDdvWZHkYo5N7WGf+QKSuFuR0yNqyond1rpZPcz0I2nGr1dM24GY6Mo9/sG1viLkOeU9UGli3SKEmmDjT64kNyFCbtR9D1l6GSKRta5B4H9n2Ksb0EcRcb8Oj9TyScEy6UVP5+SLEzgXho+Mp6rTiK+MRrKBYB/BHDpMn1ak7YpibEIPZ1hLyxYhEcXHw+EGk+urThPSJSeBqbgb4eL2VjJTte5NFZqhqA+/7U7tbWZjCau06v0LFyIGvO0+90BlaJUbisJihDnE9nt1HbhtZ38Ia5iMcHS5AVncLhvIOXsKD4mTwgs9W24TnG14Bv6us5x1MxcZ9wkuDGlwHI2p1Ne7+x0jKG6qiJkGS6Mkdh/hQywxieo/dM/QPiZqAeC7s/kL5LaVn+RuHqeFtgBxhSdLfzauVLMDoLUyQROk1YNmbpo3vZaUHrQM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 24, 2026, at 13:24, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>=20
> On Tue, Nov 24, 2026 at 12:52:41PM +0800, Muchun Song wrote:
>>=20
>>=20
>>> On Nov 24, 2026, at 12:33, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>>>=20
>>> On Tue, Nov 24, 2026 at 10:50:00AM +0800, Muchun Song wrote:
>>>>=20
>>>>=20
>>>>> On Nov 24, 2026, at 08:04, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>>>>>=20
>>> [...]
>>>>=20
>>>> The leak analysis and the fix look correct to me. However, using
>>>> CSS_RELEASED here makes the private ID cleanup depend on a generic =
CSS
>>>> teardown state, and adds an accessor solely for this failure path.
>>>>=20
>>>> The private ID is not needed until mem_cgroup_css_online(), so =
could we
>>>> instead reserve it at the beginning of that callback? Failures in
>>>> css_create() before ->css_online() would then never own a private =
ID,
>>>> while failures after the reservation would continue to use the =
existing
>>>> mem_cgroup_private_id_remove() cleanup.
>>>>=20
>>>> This would also make the private ID lifecycle more explicit: =
reserve and
>>>> publish it during online, then drop the initial reference during =
offline.
>>>> It would avoid both the new css_is_released() helper and special =
handling
>>>> in mem_cgroup_css_free().
>>>=20
>>> Thanks Muchun. Nothing needs the private ID before ->css_online(), =
so
>>> reserving it there would work. But it moves the out-of-IDs failure =
from
>>> ->css_alloc() to ->css_online(). By then css_create() has linked the
>>> css into the parent's children list and css_idr, so =
mem_cgroup_iter()
>>> can css_tryget() it and cache it in iter->position. A css that fails
>>> online is freed without ->css_released(), so
>>> invalidate_reclaim_iterators() never runs, and the free does not =
wait
>>> for those references. Today memcg's ->css_online() fails only when a
>>> small allocation fails. With the move, every mkdir on a system that =
is
>>> out of IDs would take that path. I would rather keep failing in
>>> ->css_alloc(), before anything is visible.
>>>=20
>>> To drop the CSS_RELEASED dependency, I can test the ID's own state:
>>> !memcg->private_id_objcg means the ID was never published and the =
memcg
>>> still owns the reservation. Let me know if that works for you.
>>=20
>> You're right. I missed that the css is visible to mem_cgroup_iter()
>> before ->css_online() completes. Using private_id_objcg to track =
whether
>> the reservation was published makes sense to me. Thanks Shakeel!
>>=20
>=20
> Oh I just noticed that private_id_objcg is introduced in 7.4, so to
> backport the fix to previous stable kernels, we will still need to use
> CSS_RELEASED or something else there.

Agreed. Keeping CSS_RELEASED in the fix makes sense for backporting.

So:

Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>


