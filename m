Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1446FCCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 15:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638578E001C; Thu, 16 Oct 2025 11:20:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610878E0002; Thu, 16 Oct 2025 11:20:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54D218E001C; Thu, 16 Oct 2025 11:20:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 45C258E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:20:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F264F14032C
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:20:01 +0000 (UTC)
X-FDA: 84004337802.16.73948D0
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf17.hostedemail.com (Postfix) with ESMTP id 100E540011
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:19:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oOhTfCH5;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760628000; a=rsa-sha256;
	cv=none;
	b=2agPazxSs9Gi8MiGrWtdWFpt7Kvqft+L5QMYEghgLhGYZDj+7mJZEkqkvk28lD0OOdA3VZ
	Y5L1GT7BsVfjJVyB8hDguGftpA6v0tjlZXvLSpIjaEW0SLmGruKf3JujP4blmg+ps81Up7
	H6HviAzZaPZVdIw0rJXjopc+YJtbxY4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oOhTfCH5;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760628000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QydR/KidQ4HbXgklyLOEDbEgV2E+0HwjNzOJIhpMJek=;
	b=z+Pq1MYx3mtpFZK4cMUD/AkhGSy5DZqWaRcZRlUwV3kFFTcZjod9sZFlBC+ghO1ozFA6b2
	EgmSjYFyx3i4ti+BUnfY4o8A5E0pdahf5vxVAyY+ACDExG0CowRLybzdkEY1bn1yKew6jG
	dZJfnS+nfiZgX3lg9bn1TEFt4us2/I8=
Date: Thu, 16 Oct 2025 08:19:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760627997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QydR/KidQ4HbXgklyLOEDbEgV2E+0HwjNzOJIhpMJek=;
	b=oOhTfCH5EcpmQIxThSointcsUzwwnMSWi2CVXUO3PAtN+tFAYj9JaQ83LL0qfezHl/X4qC
	KcOGJaj4y5BDDBHzk/TWudw0ZtGEMPKwxQ/S+/COqxS4zKQi77ZoqvSATgBXPxLOpLCJz8
	b1rMJc0HzKqMJEI24QKprikEqPRDCDA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Matyas Hurtik <matyas.hurtik@cdn77.com>, 
	Daniel Sedlak <daniel.sedlak@cdn77.com>, Simon Horman <horms@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Wei Wang <weibunny@meta.com>, netdev@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: net: track network throttling due to memcg memory
 pressure
Message-ID: <ucymjttvagptmpmf623q3zhsoxfhes6kprsgfbdtr5rf3otat7@trcc4vhtyswa>
References: <20251016013116.3093530-1-shakeel.butt@linux.dev>
 <87o6q77hfn.fsf@linux.dev>
 <CAAVpQUBXzBKfbH_iqn78k6d7ys9DNrXTVbnYSD4ecuKwgCwk8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVpQUBXzBKfbH_iqn78k6d7ys9DNrXTVbnYSD4ecuKwgCwk8A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: d35pi5zjgqww4whcaq5n6u1km8wsmhtc
X-Rspamd-Queue-Id: 100E540011
X-Rspamd-Server: rspam09
X-HE-Tag: 1760627999-640391
X-HE-Meta: U2FsdGVkX1/Go5wHTFHmnnvtodtem2bEW9UAvli9CyPCbul+iXG8tEDk2kSl7ImtBV4C/9UcTF++M1cEWYLVNkfQ2K+AZanFVjdLtxn8twoCYLkHiuU76J2Ug7D4RFwyViiloj96SAqMeb4aZ41oIyqa25xqekdu/21QbXEsl4UxKK5JT6VYWl6vINXXI7hJghod9zCm4XYYWo+fwZ0UrX7x9Js8rowe1RsT93KopMhY1qo96V2K/9o8+jw9VtXa2AQMQLqhAxMVXXElC2Pf4N9c7eQ6bLhdm5QfU++aGUk8y/jGnnyNzThiLUiXfquD1KNezWl7EymiQVxB1WMb17NJjeYih3Wgbd54Qg67W9shON3Otk7KYxNsTRPCqyI1+LUiLJxI9Ile3KA4VDDg1Hu0GV9Xm9Sm75oSp+EWsgJMjwIP8yeJinH3V+lyKH23Muvtlg+7aKsp97hk9++JoTM+5AS9xspdM65B2HIcDxbbYhcwwMUBmkSrVjjb0mVdMmOKVv53aPNVa9EgdcsC6nxhgANVWTTI6daHLxC5YNNaJL+9B8eeEWM4v285SBp+7HJmt7wsmvOqZKL55/GaEFQUn9xM95W1mUxzCco5Cu1VChXKIS4gXXbseanNp+GjP/BIRKQHLs9YOG0S0oMVaSqDIbWGyha2ejVLufx8juora6f1xenPHpuVKvvFRSNTQPpUwphWqiaumBxDYKYB9MC21a87B6Wz5vBYm7vgeeY5nF6PnJ5AZ1kCbNYtH7IpNljnYAWyVHGk2j7D4mPJTzyJ9lsX/vKxwCcPrYsnFuJs3LVMMQU7lrDOUxY5S4DBRXUrgII/5I/1s8vnYAKfD69yGMHTXLFacBvShlpIHbI7FWZxlhyT6JS7PSD/mOXJrX3xA5Dd808N69E7qGrZxirc5y5O748GiAuy9/WYsn0/ZNG1uM7AjOsrZun/naORSuFjHOkC66v3tOp9Ows
 SYMjer3I
 T4XdEwRvxBApq16FUZbi/VMFfK1rv6KUBK4mS9B0ZzHFF7HgtAUjcsKr8fvLofmRHpkqA+XcLuDoZVg8+u2bydiryBEn/MgVOn6QkYQfMBVr0q4Ll3BTIrI0LnNU9ONIqDoBy2tZzWRj096rWQjqKvNmGBZig1DTM5u5giwAm2v+8pkfsGHHh+6C1J0hOvfvF393ZCZjoSWMrFbHJg4o+mVccp7MPhU4mMU0IaTZOhecCvpfRIYRltYtvpk5w8Q6lKX28xdcaX3GUvPZ0uH0ifHPQiqEIU1wHoH9yvwa5juYba6s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 10:46:54PM -0700, Kuniyuki Iwashima wrote:
> On Wed, Oct 15, 2025 at 6:40 PM Roman Gushchin <roman.gushchin@linux.dev> wrote:
> >
> > Shakeel Butt <shakeel.butt@linux.dev> writes:
> >
> > > The kernel can throttle network sockets if the memory cgroup associated
> > > with the corresponding socket is under memory pressure. The throttling
> > > actions include clamping the transmit window, failing to expand receive
> > > or send buffers, aggressively prune out-of-order receive queue, FIN
> > > deferred to a retransmitted packet and more. Let's add memcg metric to
> > > indicate track such throttling actions.
> > >
> > > At the moment memcg memory pressure is defined through vmpressure and in
> > > future it may be defined using PSI or we may add more flexible way for
> > > the users to define memory pressure, maybe through ebpf. However the
> > > potential throttling actions will remain the same, so this newly
> > > introduced metric will continue to track throttling actions irrespective
> > > of how memcg memory pressure is defined.
> > >
> > > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > ---
> > >  Documentation/admin-guide/cgroup-v2.rst | 4 ++++
> > >  include/linux/memcontrol.h              | 1 +
> > >  include/net/sock.h                      | 6 +++++-
> > >  kernel/cgroup/cgroup.c                  | 1 +
> > >  mm/memcontrol.c                         | 3 +++
> > >  5 files changed, 14 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > > index 0e6c67ac585a..057ee95e43ef 100644
> > > --- a/Documentation/admin-guide/cgroup-v2.rst
> > > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > > @@ -1515,6 +1515,10 @@ The following nested keys are defined.
> > >            oom_group_kill
> > >                  The number of times a group OOM has occurred.
> > >
> > > +          socks_throttled
> > > +                The number of times network sockets associated with
> > > +                this cgroup are throttled.
> >
> > I'd prefer sockets_throttled or sock_throttled. And same for the
> > constant name.
> >
> > Otherwise,
> > Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
> 
> +1 for sock_ like "sock" in memory.stat and its MEMCG_SOCK.
> 
> Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
> 

Thanks Roman and Kuniyuki, will change the name to sock_throttled in v2.

