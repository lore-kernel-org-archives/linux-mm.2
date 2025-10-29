Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4BAECCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 21:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C76E68E0103; Wed, 29 Oct 2025 17:18:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C27608E00B2; Wed, 29 Oct 2025 17:18:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65378E0103; Wed, 29 Oct 2025 17:18:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3CEE8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:18:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4B9BFBBEA4
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:18:15 +0000 (UTC)
X-FDA: 84052414950.19.DB5BAF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5D2ED140007
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:18:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oz2iWWUE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of song@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=song@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761772693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cuFb2Bmsds1bYdOqwF51q8ehVD++6Lbcv+GiUD2iDHY=;
	b=44vxw7x2fYDZ7u7l9NAZQbG8ebvlr8m2IJYhk+ka8AbSMLxjV+Tcty7WQtUdMEwBwId1Wc
	Ap1GCR96gavmSQlJwwdpkxiuiYwqQc1nlvQ82OG7w968ZX5iMhLpZYebiyAR0PINvWXcCD
	CaJ3j6fBXnJtYm58tkdbIf5bXq3dFOc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761772693; a=rsa-sha256;
	cv=none;
	b=Yqa+To27/p0pLXJQnWSNqeV7laWWiBsY8YxhNBwMp3LdWJ8G7A/eLgzb8A0gyQPC6vbC0b
	dVDqgGLIQNQs7h0f2pjVBi1nV51sScX63vw5ohE34To+rsySr6TJLUO99Zb92KOcZ33frw
	B0ClM+7Bw9ICCjuJMRyW5kKaQrgwXEM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oz2iWWUE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of song@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=song@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 82F06605D0
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282C5C4CEFF
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761772692;
	bh=cuFb2Bmsds1bYdOqwF51q8ehVD++6Lbcv+GiUD2iDHY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Oz2iWWUE7hccwyVGlEF3r6UTArZdg3Xoc4kGN6SnOifGAXUy5nnqNQpdT1ZZYdhNH
	 n7+ARHzP8KA+6dSTBrMwfQ0nsRTVRfgWX7NvskV9ShfYoZTTn+3YYQSL4Z/fb6cJ0O
	 mhQ3UVOvBzUkbS5ndtq3H6f+lDO+qhoUVWMZImaARjltrf1JStNbt2/uBOET8EGvHv
	 qyzDnipgv3z2ZnOVqbqM/5SH0DTN/Ompe0TdBSDrfcDV1Eui4DfmOQxfNr5nNaUwph
	 kxVRN5GyKlndyD7SYqPlKuvEWIEHdYQaW9aSOxcoEfounAFW5HAnpa+bo6pDMsQydH
	 7iZ7rqV3LttIw==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-87dfba1b278so4151606d6.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:18:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUKW7cdty7J6ILiPJI/PeCuREPUV4x4fOyEqNx/2aUBs8GXNyIhsx+4iczJrve6VFT6l2hNoyDopw==@kvack.org
X-Gm-Message-State: AOJu0YygcSTzQAN3Qx472yGLxlrsjqMelvprsQdOS+e4HyKoa5UyoWxn
	mNw7c0/tU+NI7hm/urHljc/SAVSic1oPCo30bivn22hDw78LGWaDPDViZnE+ERejvW08wNffjpe
	CX9DZEjZeOLKTBQN1vtQfGX+HA1RXLgM=
X-Google-Smtp-Source: AGHT+IGqt5WH9bVZjwQ7L0MKNy5u5e+ux4TrQuXYXpXYL2H3wSTNJxaAS/0+3Z8ip9WwmuFtQYIJYHWO7C9BhxfqNAU=
X-Received: by 2002:a05:6214:d81:b0:87f:fc07:c51d with SMTP id
 6a1803df08f44-88009c13947mr49538016d6.64.1761772691101; Wed, 29 Oct 2025
 14:18:11 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev> <aQJZgd8-xXpK-Af8@slm.duckdns.org>
 <87ldkte9pr.fsf@linux.dev> <aQJ61wC0mvzc7qIU@slm.duckdns.org>
In-Reply-To: <aQJ61wC0mvzc7qIU@slm.duckdns.org>
From: Song Liu <song@kernel.org>
Date: Wed, 29 Oct 2025 14:18:00 -0700
X-Gmail-Original-Message-ID: <CAHzjS_vhk6RM6pkfKNrDNeEC=eObofL=f9FZ51tyqrFFz9tn1w@mail.gmail.com>
X-Gm-Features: AWmQ_bkkCVXDFm03jUeATippuBWXlsBI6kcPhGNhj9qa68CaimgckVtdqRiaqvA
Message-ID: <CAHzjS_vhk6RM6pkfKNrDNeEC=eObofL=f9FZ51tyqrFFz9tn1w@mail.gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops to cgroups
To: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	Martin KaFai Lau <martin.lau@kernel.org>, Song Liu <song@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: j9fetycrrfxotishfguxjd5fb9ujjt17
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D2ED140007
X-HE-Tag: 1761772693-203018
X-HE-Meta: U2FsdGVkX18eMlrryf3MfdFWAW3iVQ4XGAY9o9RTVHm8/DcIAxxFtY3YwjGZ/OXgSWHt0rMJadB/VznV0ILBo+oZItKYGU4OA/tO9Vwrhqw1HXDjxwu7H7HUn682zl+GiL6epybBPlkc7gpRRs3TEnZGr2Ii4qQaN9AE+IvPnMix0zbCQd/koFHoWAJcKm7EEeZhDJFR5OWYAc9wP+O4Xgl8homcmYrLz8WEF6uVVvj6MieLixVIlPRAd9e82t/cO39/QNxXJUqI3bu3Ae62QmdErj3RPXAMHbic58ItrZ5fN4RSvOOzKLXbFt0AfO26YiVSuQl/cflhX2HgznHJ4eEYLlFfdQufO3WrHdplyjbHpgxEnkLajwKb1hbD69nCgCiaoBLR/sdg6fns52S2xPG8DlGPZ0nJxasLsrvW6Q7IMifh6KN9rUT1jMuWDBfz6O9BRtOSZwak+O3ZolzyCsJ3EBR1JP5+38CKS6ZjHo9Wgwxjii1xdEEnOwNgt5Vkh+/uo15sJgtDCQ7caYlRR5z4zp+iclY3pnVkQibeLD1IhtkhLFEdJx2ysGHIP7Dj5W74VQHa/bRfx8VgZlZxvnIHXdNM5vA6hviAOlCoQxCKznUi0jSTMYlL4fRmKE+V8I6n+hD57AcXCYQ0jEuvrhg8YGnZc3w5OOMRabTLDa2FYVPK08wlRhXTyuCSOr/RiOq3lOaUK7hpnF4FdnBXWYBpNOMXKnt6LXHPzj5UTr+uGCvR9ikpJhMYV+q+2oqtHvCcgkDj0cgBxMZ20ss0eestVZxXpefFgK1XgS6qZNcGKg3Q81F1pX2Z4O9H/pugMQXPmnCtdm+/Lwox11hCYZGpFitsGt8C8ff4gaqWInDAkuKIjso61017HN2ci5mayt9Q6zeC0bMeDHLhHHXxdxTXMm92OwY4gSMy/DIZDhe+PXmgY0bTJ/xcwA3GSVhail32caz4KD03O5cI1a8
 pSu9Qdwn
 0CIgXmbmmB/bl4HNlZauKVHYc/AXltBuALcJcM0tmozcNfTDlDt44LDUkVzUyXUGQM3t+S2jz4smqzm1wOZn5XBm5bWSTyosyU0QGhN8wNVMC3MKKhwbwkHVi1ypMZFrWIxgJglntyai+VMSnd2C6Ohy/wDV8/d3OQD9w2F9H32bJzsCoyQRON1uqvlDDq/pWR9HDN0jIXjfML7BXfsri4cDLJqBVBQlr9GodkOYYAHfLakchDcP5IqmbbmuzsPT2GRqb9srAyo0SEqJeJr+NTL7aRpclK24eLZwbSxfAugqKy6T/nkLPMCGkkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tejun,

On Wed, Oct 29, 2025 at 1:36=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> On Wed, Oct 29, 2025 at 01:25:52PM -0700, Roman Gushchin wrote:
> > > BTW, for sched_ext sub-sched support, I'm just adding cgroup_id to
> > > struct_ops, which seems to work fine. It'd be nice to align on the sa=
me
> > > approach. What are the benefits of doing this through fd?
> >
> > Then you can attach a single struct ops to multiple cgroups (or Idk
> > sockets or processes or some other objects in the future).
> > And IMO it's just a more generic solution.
>
> I'm not very convinced that sharing a single struct_ops instance across
> multiple cgroups would be all that useful. If you map this to normal
> userspace programs, a given struct_ops instance is package of code and al=
l
> the global data (maps). ie. it's not like running the same program multip=
le
> times against different targets. It's more akin to running a single progr=
am
> instance which can handle multiple targets.
>
> Maybe that's useful in some cases, but that program would have to explici=
tly
> distinguish the cgroups that it's attached to. I have a hard time imagini=
ng
> use cases where a single struct_ops has to service multiple disjoint cgro=
ups
> in the hierarchy and it ends up stepping outside of the usual operation
> model of cgroups - commonality being expressed through the hierarchical
> structure.

How about we pass a pointer to mem_cgroup (and/or related pointers)
to all the callbacks in the struct_ops? AFAICT, in-kernel _ops structures l=
ike
struct file_operations and struct tcp_congestion_ops use this method. And
we can actually implement struct tcp_congestion_ops in BPF. With the
struct tcp_congestion_ops model, the struct_ops map and the struct_ops
link are both shared among multiple instances (sockets).

With this model, the system admin with root access can load a bunch of
available oom handlers, and users in their container can pick a preferred
oom handler for the sub cgroup. AFAICT, the users in the container can
pick the proper OOM handler without CAP_BPF. Does this sound useful
for some cases?

Thanks,
Song

