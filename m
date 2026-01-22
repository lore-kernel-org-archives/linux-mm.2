Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE5F3D4695A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 01:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C6A86B009E; Wed, 21 Jan 2026 20:30:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39E8B6B009F; Wed, 21 Jan 2026 20:30:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4CA6B00A0; Wed, 21 Jan 2026 20:30:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1DCC96B009E
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:30:50 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F99716151A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:30:49 +0000 (UTC)
X-FDA: 84357870618.29.84980EE
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id A8FDA1C0009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:30:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FvS2215S;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769045448; a=rsa-sha256;
	cv=none;
	b=QIAxBrEH9wlVzwJ5pRJXMRLKDCkUjrxfn75V6e+Hi6MWQRf39cttMHXk74jKNxMoa7MeiJ
	TOBj/BJgSIq28Vltr22xHkd1tJ3YGRzGvKCAYlGD0zMCYRvZlSnQFtXJ5Ydk8CUb0swQIt
	d5Uyv8qVzGQxMMq7SMHIHtn+Monk9V8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FvS2215S;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769045447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKl8Jno7lJhkwOUwcQTSrgeBn0gJ6jgSqCy+B19d98w=;
	b=CTP0BsU25s+9bIP1pjH2dLFqb4v/W8zQUsXwkV89fuSmnfzAYoleSCXXKIteTjwEfc2Ex8
	0s4mqs1KUu33ZZvZL2T0D17SCWjySkPekDkKigRDny7ws22HBOs7HJA/enXqXQa7JMq5F2
	WFWqhP4lMwf97npOyZ4toGfWmuF6yog=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769045445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tKl8Jno7lJhkwOUwcQTSrgeBn0gJ6jgSqCy+B19d98w=;
	b=FvS2215SGQI3qb3MxlQhDug5Iwy0pKGdkZjE8IYX1wUcCvvUTVLSs6JXqKXQVILcdBQVcT
	CHcTDiv58zSvLIoyTtyxj+VMlPducNqMBBXfjtMF2n/AlZ3mINeUXahO0xRMukNo3I33Rn
	IdBPVprLxk0CZvf9fsB7j5FiweWlJXo=
Date: Thu, 22 Jan 2026 01:30:42 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <bac18fc5600a0e8a2f0f5d1e46191ef1e6b64962@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH 0/3] mm/lru_gen: add memory.lru_gen interface for
 cgroup v2
To: "Shakeel Butt" <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, "Tejun Heo" <tj@kernel.org>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "=?utf-8?B?TWljaGFsIEtvdXRuw70=?="
 <mkoutny@suse.com>, "Jonathan Corbet" <corbet@lwn.net>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Axel Rasmussen" <axelrasmussen@google.com>,
 "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Vlastimil Babka" <vbabka@suse.cz>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Qi
 Zheng" <zhengqi.arch@bytedance.com>, cgroups@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <aXFPhnOn4oGllq_Q@linux.dev>
References: <20260121123955.84806-1-jiayuan.chen@linux.dev>
 <aXFPhnOn4oGllq_Q@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A8FDA1C0009
X-Stat-Signature: pf8ru1i9mx8ms1crf8mwpj9ba78rbs88
X-HE-Tag: 1769045447-803479
X-HE-Meta: U2FsdGVkX1/aEQ9jSIWVyem+dyvFC9L2quh7hVJYir1Z2UpSUHjgkYIVoj4Qx1j3V0YMQHLF2P4opht+USL5Lu73SgAjOBmfAB7wvSl3+YOIWWH+UoRatK3Lb/rusr8tYP+rH9aXQ7UxpXofXjFo0VDVQ0RZHeJZ64RUcrqIq2ABYoROAwLCrJas7hLcu3gCTqt96o1cm7uU5UFMudQtxvTv7EXsTBWc96KYlHgVCZiwBxqQtCoSy+wLJTaPlbSy6KV4AmNukNKh2y9HFx2U2A3RrjLI/veS5NxbgGFsgfwDc+EZMzFFYCJyeKuymGfUvi22i8mvi5dO5LRENFVqk3YFC7R63T6Z8jJsAy3e9qq12lnKR0cCv7u8X71eMCLmVRa1sf4lUZQS1Q3cR0Z1hMJALCC/zQ76yhxXY0GQGbN4XE+CjydRvIJ7DK4EhlRb5q02pwm/u5FNaLKOCdWx62H/ZHiZf+0pQV/mNNlE575nOeo4XQI2y7qEzBShrUIJvaQiPAtai5LMoIdZZKHvzWnceNwFx3+ssfKfbR1SfhqLAfbom0mZB/RvtEt0p1InV4V6mw3y1ZJFRURswjhWK5/YhCiVbJCCbLX5ndeC3BHZKRzDEr/DDFZufDdK2WTJUsA2HDV1Ul7ABc0kYBreNwBi3CXLYuq2eRunpc7H6UTfFeXDpz9PDxxmD+q8tsCR8QS7PIMaBV+4HFHtlG2pkC2QIIwVY1n+wAGe9YB22RkfJ8DFGBewWHTq7BjxA7yf+ScPnyrkL/OhQPPX2jfiihKNOqfqZVaMDFzYjHTLuLuwKLjZHlu4apm4qQ3s5BCUaZEmjo6HsgayQNcv0G1ulqu/Jf6Jk6EayykJyTahflVmazPuTG6aSDuTzv75/xsefMJOzFCBZ6UFWeNr+Ppd+IRK2JrMG222lUxt2dnsNnfjd3pyTcsAnFybHe3vaGkKLj8siVwCJO0FAsjRHGg
 eDQnRBLA
 uDvcdQ7f78qUsHn6CMsCB29yHkyEmemEb/UKFpFcDh/K5669Tv682XGACuS2LWYXgvNf7j0wyx+bbw+c69cYQSkzjuzlky1nOGJVkYVxOIoB7q/1JRnmBaHdQv57Ip0bC7unA6TmU7JFTTBULoF32ViDRbLQ2OuUFBO1VNlgF21uPOGsUCvzxSH78SUYDZ6lcVlj+TOHn+DECNjZojQWI5ru+H7TO0P1BO8tqARrxnZ3JL63PzWngL/LvAbX1oY8t6+N+ERwjpy3EdaNt9myspdrwBsbVZgNzCfsSOH2Ebeoj6wwNkeJVqzdNu0jKi5LR2FGm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

January 22, 2026 at 06:19, "Shakeel Butt" <shakeel.butt@linux.dev mailto:=
shakeel.butt@linux.dev?to=3D%22Shakeel%20Butt%22%20%3Cshakeel.butt%40linu=
x.dev%3E > wrote:


>=20
>=20On Wed, Jan 21, 2026 at 08:39:46PM +0800, Jiayuan Chen wrote:
>=20
>=20>=20
>=20> This patchset adds a memory.lru_gen interface to cgroup v2, allowin=
g users
> >  to interact with MGLRU directly on a specific cgroup without needing=
 to
> >  know the internal memcg_id.
> >=20
>=20Unfortunetely we don't want to expose reclaim implementation specific
> interface to a cgroup.=20
>=20
> >=20
>=20> Motivation
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >  Currently, the only way to perform aging or eviction on a specific m=
emcg
> >  is through the debugfs interface (/sys/kernel/debug/lru_gen), which
> >  requires the memcg_id. However, there's no straightforward way to ge=
t the
> >  memcg_id for a given cgroup path. This makes it difficult for users =
to
> >  leverage MGLRU's proactive reclaim capabilities on specific cgroups.
> >=20
>=20From the next kernel version, this memcg_id will be inode number of t=
he
> cgroup for this interface. So, a simple 'ls -id cgroup_path' would be
> sufficient for your use-case.
>=20
>=20The relevant series [1] is in mm-tree at the moment and if you want, =
you
> can backport it to your kernels.
>=20
>=20[1] https://lkml.kernel.org/r/20251225232116.294540-1-shakeel.butt@li=
nux.dev
>

Hi Shakeel,

Thanks for the review and the pointer to the inode-based memcg_id series.

I agree that using the cgroup inode number as memcg_id will simplify the
write operations (aging/eviction) through the debugfs interface.

However, I'd like to point out that the read operation (viewing lru_gen
info for a specific cgroup) is still not convenient. Currently, users
would need to parse the full debugfs output and grep for the specific
memcg_id, which can be cumbersome especially on systems with many cgroups=
.

Would it be acceptable to add a read-only command to /lru_gen that only d=
isplays
the lru_gen information for the specified cgroup?

Alternatively, if exposing any lru_gen info in cgroup is not desired, I
understand and will use the debugfs approach with scripting.

Thanks,
chenjiayuan

