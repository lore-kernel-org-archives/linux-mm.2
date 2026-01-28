Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A68D6D46BEF
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 19:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15B886B0089; Wed, 28 Jan 2026 14:03:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FFE16B008A; Wed, 28 Jan 2026 14:03:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2DA16B0092; Wed, 28 Jan 2026 14:03:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DED846B008A
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:03:28 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B0E5013BA48
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 19:03:28 +0000 (UTC)
X-FDA: 84382296096.25.602C194
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf08.hostedemail.com (Postfix) with ESMTP id D712316000F
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 19:03:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C6gp1MPX;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769627007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NayTqK6ydu31eZz8Rz8GMezBVcxg1OL2qPKc9sxAYY=;
	b=YSXGjoCKtsmpNHkwYMTKxZ9vv8ZBwXuiKKE6FFZPe4N+E6NCvFubcbtSoKpH64vtYFVchT
	1OeB52LO19tIY7JKmeNqkC7fTorKzFBuMKs0XZc68zX4hSVI5e1Bzj1E6zRKLaUv/RfTtC
	6ZiisXLBXNqwt+CrcKjX4NoKyXzNm8s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C6gp1MPX;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769627007; a=rsa-sha256;
	cv=none;
	b=KdfEhajs0HTj/K7+9c/rNaWZOPuUW6BWQDmKV2qsPLfxQ5kJDVofxflLgte9zc7UMad5Lw
	PYsLDCfFrSHau5rhYrKTtdDsOMjfIZdhTA3pbbtlmI3pJ3dAeYgPsvJFBnDI4G6IlX08jM
	msdnUvfFUIaFxBRMd/Ay9TLwGvFmAOI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769627002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4NayTqK6ydu31eZz8Rz8GMezBVcxg1OL2qPKc9sxAYY=;
	b=C6gp1MPXOXBOyUaULt7xIiQQq9atvXBscBI7+zuY5sWgavBkmdnsEqBxaDsObhlyHb83Lf
	WinP/QWVMuQOC2Gl36aiP7atmDPAthGEuudtxX54DkJ1OB0wSE3drjvs9kgjhEzT7Sk6tE
	o2iKyHxpcm3KJzQ6GnzUspUbQXcBdT8=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Josh Don <joshdon@google.com>
Cc: bpf@vger.kernel.org,  Michal Hocko <mhocko@suse.com>,  Alexei
 Starovoitov <ast@kernel.org>,  Matt Bobrowski <mattbobrowski@google.com>,
  Shakeel Butt <shakeel.butt@linux.dev>,  JP Kobryn
 <inwardvessel@gmail.com>,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  Suren Baghdasaryan <surenb@google.com>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 07/17] mm: introduce BPF OOM struct ops
In-Reply-To: <CABk29NvSku-zb5sodOYjWhW253EHGu52VNQ6+pQ8QuvEoVQYRA@mail.gmail.com>
	(Josh Don's message of "Tue, 27 Jan 2026 19:26:57 -0800")
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
	<20260127024421.494929-8-roman.gushchin@linux.dev>
	<CABk29NvSku-zb5sodOYjWhW253EHGu52VNQ6+pQ8QuvEoVQYRA@mail.gmail.com>
Date: Wed, 28 Jan 2026 11:03:16 -0800
Message-ID: <87jyx1zhjf.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D712316000F
X-Stat-Signature: bmhi7ac3bync89n6bjycecca5szz4qmg
X-Rspam-User: 
X-HE-Tag: 1769627004-973443
X-HE-Meta: U2FsdGVkX1+teLaEiaqJJN600RB40ZScEWLrhmtndcBqKFFVm4UJ5nCTRyfPWvb9Ff+XJa5FZJDoGz8XHemoj9pguV3xzPdPAKFXVmW43UU+cS3GX307CszibmDxeRBXhXwK+Cw3umPaoGNs1Zzjt/eOkki2oiQrQLiGj9Qc4fggEP8KacgcMeXRgfiqsTM38t6UusTBuYYJI8auk/LoBNTGsQKFVgANKTtgs4tls4GxHpvENoj4a+DnUI48jx63l0Rj0oi6Uu3WUIey0DhPds2XvlDPBpUpbewV/RXM6cMYQYCY6nXSqdBWgt1SaBX+Rfd/5E3QFhS598QicNsK/jK7hao9YcpjLpEQgd+QJS4dLMbaFkrVjbVF/wEdGQO4FHTjSqxAzMsOhXWgo4PdINJRm8qXo4ZAPTVhMCS7wMyfvJF6E4DzwnYwK/9WXSN/xeBff744vMiyUzmpCrN9X1uC5Cc8wmou9kQqfdOI6xvvAKdXftHJIv1V3XrwRdEhl4UhIGuS21TbJ5Nz/QvNeC9XBRwvuYoXw2IFlLJd/9FE+r0NiM9sr2ZIQ7QZ7YmcUAk5t1oRydwpy8/xbXCGhWMGuTdimASZUaGK2t8duHrYyGjLudw4mh3qiyyPvmNe6IzJwB2I4aZgB54L0mDhPUOiM1FBmgZMkOkMmVW9V5DMRNMsdSrISlMUau3l0PBFnGqCYGMF63GJVfsti3A0qlVfZE4TglIwIsuKt3dC7GVoL0QSC1SxmyjTHoaGeh4+5q3iBxtc8mFwcYpuwv1KDxUmuB+gHQise4crQPywVZHFS0VhXyQJQAdn0ZUtbZssAqtY4qHLhSwigYFSRwqhgsAyjNtg9kQDDhyoQwHXyJ1bQV89stLo6JraALwvBuc9lD6GOzoGjUKlr0t/Rb+SmFp+UrikYiYvl5TU6XtCHwhdQQ4xOIXXHPKLzfTAdvNkXdN4Kpg2SJmjMuLJFDu
 /Psjnm2r
 4ZLMeKkgcVK4Tl49c0ex83BD/jQdO+JDkQm3ILqE1SFBded8m4m72+uxhO1L5gK26QAaPvpMIh19z8tnD2S2AVLY+bxQzi3GNaDAUqj9j2nVrLeZ+oxUq62TLW/yK76sadCm1Nfy2s04fIwU7TbH7R3sDAPbjs7wslWWwAV+n+jEV3h+ZunPUTtkX9149fmEkp4TyAChRHZS1w1g3vSLqEZgF3yS8gnfF2D22YAKCkk6TSpI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Josh Don <joshdon@google.com> writes:

> Thanks Roman!
>
> On Mon, Jan 26, 2026 at 6:51=E2=80=AFPM Roman Gushchin <roman.gushchin@li=
nux.dev> wrote:
>>
>> Introduce a bpf struct ops for implementing custom OOM handling
>> policies.
>>
>> +bool bpf_handle_oom(struct oom_control *oc)
>> +{
>> +       struct bpf_struct_ops_link *st_link;
>> +       struct bpf_oom_ops *bpf_oom_ops;
>> +       struct mem_cgroup *memcg;
>> +       struct bpf_map *map;
>> +       int ret =3D 0;
>> +
>> +       /*
>> +        * System-wide OOMs are handled by the struct ops attached
>> +        * to the root memory cgroup
>> +        */
>> +       memcg =3D oc->memcg ? oc->memcg : root_mem_cgroup;
>> +
>> +       rcu_read_lock_trace();
>> +
>> +       /* Find the nearest bpf_oom_ops traversing the cgroup tree upwar=
ds */
>> +       for (; memcg; memcg =3D parent_mem_cgroup(memcg)) {
>> +               st_link =3D rcu_dereference_check(memcg->css.cgroup->bpf=
.bpf_oom_link,
>> +                                               rcu_read_lock_trace_held=
());
>> +               if (!st_link)
>> +                       continue;
>> +
>> +               map =3D rcu_dereference_check((st_link->map),
>> +                                           rcu_read_lock_trace_held());
>> +               if (!map)
>> +                       continue;
>> +
>> +               /* Call BPF OOM handler */
>> +               bpf_oom_ops =3D bpf_struct_ops_data(map);
>> +               ret =3D bpf_ops_handle_oom(bpf_oom_ops, st_link, oc);
>> +               if (ret && oc->bpf_memory_freed)
>> +                       break;
>> +               ret =3D 0;
>> +       }
>> +
>> +       rcu_read_unlock_trace();
>> +
>> +       return ret && oc->bpf_memory_freed;
>
> If bpf claims to have freed memory but didn't actually do so, that
> seems like something potentially worth alerting to. Perhaps something
> to add to the oom header output?

Michal pointed at a more fundamental problem: if a bpf handler performed
some actions (e.g. killed a program), how to safely allow other bpf
handlers to exit without performing redundant destructive operations?
Now it works on marking victim processes, so that subsequent kernel
oom handlers just bail out if they see a marked process.

I don't know to extend it to generic actions. E.g. we can have an atomic
counter attached to the bpf oom instance (link), we can bump it on
performing a destructive operation, but it's not clear when to clear it.

So maybe it's not worth it at all and it's better to drop this
protection mechanism altogether.

Thanks!

