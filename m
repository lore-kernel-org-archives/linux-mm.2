Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72C68C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51A4C6B008A; Mon, 29 Jun 2026 14:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F15A6B0093; Mon, 29 Jun 2026 14:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E29D6B00F6; Mon, 29 Jun 2026 14:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DBC06B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:29:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E8A040209
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:29:27 +0000 (UTC)
X-FDA: 84933787974.26.CDA843A
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id A83BAA0004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:29:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WZ2n3yfQ;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782757765;
	b=W64oKYjR6w6gmnZkwVCbtj/AWOTeXwiagz1ZPDD1lcFsp7iWyzX+ekf85gessdkCWtY0Hf
	4wBQuWqw9ZnWg0KXrT8+xca7dXfXwQkLEpGhGmxEQu3UktXhb9wOG67sjvBNlmjlUZRXTk
	TZdGuHY3MRWkJJzpjs2W5EYoyjbAR6k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782757765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wTW0XC8dEWZiwseOxkoyBChQncFjhrJXjY1B/hyy8Y0=;
	b=DFb9ETJbv/RTmf/vo23feNButNOnRRaqgg/XeGXJNffS30p7atAVy07Jth3iqxv5l6WUa5
	yu25AMysHxq+zwaSZbpH06t60Mc5BBaRaw5d7WVqDx1jdXChMDDmHQAeJuzdPdjmkHC1uB
	1yz0jEEu/DkM8qkfpw09zvCgn6yk/vM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WZ2n3yfQ;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 29 Jun 2026 11:28:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782757760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wTW0XC8dEWZiwseOxkoyBChQncFjhrJXjY1B/hyy8Y0=;
	b=WZ2n3yfQsB7DAqunz7QrD8IzF/yt614EZi2fR064jPUt4e9EAcc3D0fbB5foVguLFClapW
	wDomh3rSE0EY0PDDI765Q6N5DIWs/kdrEOlBAl9NZeOvFRIQxvIhXSpUycwmJs9yKBWP8O
	Q47xDrZ41Cy1506mCfNsXUPNbhntU0I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, linux-mm@kvack.org, tj@kernel.org, 
	mkoutny@suse.com, roman.gushchin@linux.dev, liam@infradead.org, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org, 
	surenb@google.com, vbabka@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/vmpressure: split v1 userspace eventfd code
 into vmpressure-v1.c
Message-ID: <akK5QOLJMElZz5iw@linux.dev>
References: <20260629130042.2649505-1-usama.arif@linux.dev>
 <20260629130042.2649505-3-usama.arif@linux.dev>
 <akKhzR8uHh-wzrx2@cmpxchg.org>
 <b84a497d-9159-4967-b355-44913a3865cf@linux.dev>
 <akK1lm7mVUXEmIZm@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akK1lm7mVUXEmIZm@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: q1yfp8yqpsuxitgsc9fjwh6gx7cr4axn
X-Rspam-User: 
X-Rspamd-Queue-Id: A83BAA0004
X-Rspamd-Server: rspam02
X-HE-Tag: 1782757763-771106
X-HE-Meta: U2FsdGVkX19WQf5xhHtZpAzSfKsa5efoOcp/4QF9+4hZLW3hsj8hjx7vitxaQdabEaXOYZRaQHhO0NE0+bbOQqMnwuG4wiMtmMubV4/8L4a87sdWvFnRoaA+R173xM1i3XXJg7nzDjcW5XU/YB0nxuM0vz3pvlX1O1dFoXL97xg74aQTeyMiUvc1Ub57BKsT1UY9kPXzX0IRhKpVuqXlfWtYEfk3HBTuaFc+mROJzEP/TZz5ffT9M141MOp5ulVnolnUodFj5gQKibvcFWrfOqWCm6OtTyNiEuafsCmT8R0bHfRD9PU2eYbOvNtWpME2RaQbDTVFSmiMWXo4cjdCq3UzHjNAhy4o1vLLdd7Ibu6Pxgs24BUiRH6BjmBNxNYxHVVGj0IOdNHVm3zdSt4fOPHuoWnL+Bp6MUWXyHDBsIOaPlbnyVhzTQoP9eqBgkreQT0HL76/fPDdpPieLKRSX9gNGcAkNKFaJ7+PGP8ZLfXEas3vl9gsLSxyZpcO5tJXfFXRERAlqFv4nbF/4+DtGd7VoRty1jtkDFdB6cZmVUYNCxAgqecRCCy4qv6LB4RiA7bXfkUf4jzvOYezxGixuL+Al/jNK/+Fo8/4rIZkUAJsDpiigA5k6WxRd62Hsy5QiQJGKToyWmfIaHgqS2yC3zMZS59SOSv+cC1p7P48OhaulqJngXQeCHG+9FFROPn/KKS7R8zCKytsmtpNOaGSRWbV+V1AnA43SgIE7BNGSYC7WXqvd+Rs96Hu9dboVXnF6n7TlxpXdqCagaxp0pE3gRazaoX+FJZwfOYrfTO6E642xtzvHW9p8GQGML9UN2L1B40WTJMMPRzH3XcmqdbZlSIRsxNu107r/97a/h+0vpzaeijPaKbigr6eBhFcLt+oXqhTt4Ote5+VfzC0oEkM3iItDRk0G7mW83wPKlKeFBsbokLVbLlFilKYVwl6+3QTg654SpzOe0gB/oR27mY
 tYNqY1bi
 BvEq0GrYpnOwv0S4wSWAPFN19gQsuGkQH5GCt/eeb1su0zR7zYuGAoD5eck1X0HL4tNl3uY1FNZursZBGpmyy6xH9gajCl8Lluwa8QDtKEDCutLveHwN3EY0p6inc0WXzZpY6QVvTl4oQJjNMs0iYxJF56IFlL2+2CAW9rMuibWrZO4l3CKp9WA8/9b3bexZ0DvBUOxsxIWyeiqf6E1RmAnhyzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 02:12:38PM -0400, Johannes Weiner wrote:
> On Mon, Jun 29, 2026 at 06:23:58PM +0100, Usama Arif wrote:
> > 
> > 
> > On 29/06/2026 17:48, Johannes Weiner wrote:
> > > On Mon, Jun 29, 2026 at 05:59:37AM -0700, Usama Arif wrote:
> > >> @@ -101,7 +101,7 @@ obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
> > >>  obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
> > >>  obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
> > >>  obj-$(CONFIG_LIVEUPDATE_MEMFD) += memfd_luo.o
> > >> -obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
> > >> +obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o vmpressure-v1.o
> > > 
> > > Might as well move the interface part to memcontrol-v1.c instead of
> > > creating a new file.
> > > 
> > 
> > I think it would make it easier once we move cgroup v2 off of
> > vmpressure. Then we can rename vmpressure-v1.c to just vmpressure.c
> > and gate it to CONFIG_MEMCG_V1. The other option would be everything
> > living in memcontrol-v1.c?
> 
> Hm? I just mean move whatever you move into that new vmpressure-v1.c
> into memcontrol-v1.c instead.
> 
> > I think its nice to keep it separate as
> > memcontrol-v1.c is already 2K+ lines and this is standalone feature
> > that can sit in a separate file.
> 
> It's all deprecated code with no active development. Containing it and
> making it easy to see the footprint of the cgroup1 option is the
> higher priority, more than maintaining neat component separation.
> 
> No need to work it naturally into the file either - decls/variables up
> top, functions somewhere further down etc. Just paste it into one
> contiguous vmpressure block under memcg1_oom_finish(). That's how that
> file is already structured with the other components in there.

Yup, this makes sense.

