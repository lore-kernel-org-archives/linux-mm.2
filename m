Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 439F310AB802
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 18:51:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFEB06B0088; Thu, 26 Mar 2026 14:51:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAF166B0089; Thu, 26 Mar 2026 14:51:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EC136B008A; Thu, 26 Mar 2026 14:51:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A27D6B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:51:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1FEB78D470
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:51:30 +0000 (UTC)
X-FDA: 84589107540.02.329A230
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 549F84000E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:51:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=StWwL22U;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774551088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K2/Ohfk88QPOV9Q8g1yBzERxS36uZy62jEw7san3PaE=;
	b=PlZRnd+4C2X/yvoOxW7FceS2E/JY4w3jt+HENlIgyV1Dd/FDB7A/WLHpOpJrUyQFY+bp1z
	lhTt2f5PrBREeFIo1pNw+ALT+0r/vKnNZ/rNaqFH+yXN8m1ZOg1NM6zgr3EN/MUK4SfMWR
	ou7Qf/bvJOzjFQMUVZ5W87e7IfShoag=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774551088; a=rsa-sha256;
	cv=none;
	b=COMRU0hf5w9G0dC+P7yHGa9TQq7drCXT+W/hkwADp6Grv8YxFCFlYK7DGxlinjJb2NzGVu
	087kBJTaQsUW0OZw0r8arktyYLaYL9AJsi5C+LGR1AsX3NHXUMuUGKgloB/xw4LvRvll9/
	SqU13pFLD+UOmxxny/tYpwqLWgGTSno=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=StWwL22U;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DF6943F29;
	Thu, 26 Mar 2026 18:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F271C116C6;
	Thu, 26 Mar 2026 18:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774551087;
	bh=E1Bn4wE+ForM1okF61IbTJZ3NK6qA+FdoyLPEmf/rog=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=StWwL22UITgdBBiB2J/jv68HVdlnDIsFMjORJ9eGxANUdtpcHlfA7t6bQdoukkX90
	 Mn8FlN34p+FVWxTbFunsofh4fK0Rzh7iOfhLLslhGw+QPA8INtTHAQ/1Uel/V7OCeL
	 db6V/clZQ2e5BH5orhrVEo44ZkO8PDTVhyAB0OqA=
Date: Thu, 26 Mar 2026 11:51:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/8] mm: use zone lock guard in
 reserve_highatomic_pageblock()
Message-Id: <20260326115125.923b6570bd18690897b82552@linux-foundation.org>
In-Reply-To: <acV1M3AcRqCVmIYh@shell.ilvokhin.com>
References: <cover.1772811429.git.d@ilvokhin.com>
	<cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
	<20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
	<acV1M3AcRqCVmIYh@shell.ilvokhin.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 549F84000E
X-Stat-Signature: z5cypouh3i7syy14afskt6pz3utrgdsk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774551088-450714
X-HE-Meta: U2FsdGVkX18PmGQdo+pw520MJrhNRHjhnSrIogr/awB1LMWh05xusUOzDPwZ8Wi/FuV71WxjecHT0zKAhDvmVCedlFNNpp59EARVpIXBDo9cmnzmyNn2Mr5FfgDxiGi3eg+5LeK4nZwu22IkqV7m7V00KeNeFPFgd3t5UZflKV8BeTakYpNrw7VXpPHsh5SUwAzliZ19SWwaYffPSJ+HnlNRhfzl3l3D/hair9Q9XnhuP2PqwUj/eAamgT9iRujB+AXATR3qHuVMs2Y36XCNE36J9eDxc0fpyUoEHDMlKNUrzqnkhCj35xEGKoCj8Q5TLer4UhitOO2islRpRad84WdABAjsb9Vbi4cxjDoTM8+ZyJgr81MfxDk/iWox+3UjnJ7g4ZJq0c3RKD7r6N8nxf8kdRC3f7P8ZX7gkzutHxNWi35rN4stPtq2lIAUnqFULhK+R439YKo6upT+6gH427jFpUhUoGt+3AqdSbIVOLu2sK5SnCS3MupmRW2E3Zl7lYEICNDoNg55f6mb5OvTqgV+D2uBxSQcYimLKpETJ3xriCONAf2VPs6U9Z6b3OBGVLoqNTKemkHu7tnLQuX5hA1YtMscKcTZtPhcq5N3BPghksUD5mZXjDLt16G2TBDXrX0cho7UQrCg0XwlfT+HYt3r8aKNZ2ix0O+EhYOXaID/OABWyk2SIA9OQBkDsFI6LOeapNPvM7s/atAN21lGKJn11aUeGZF0uRoNjFLVeiiyJQPc6UzwTO/PhnTV9py+5X2TDW2Nil6aJ5V710J8FfNjQ+6kBS7IWTNqNvVsVbffgPnWe11Omg94mWOKjkfkIou6z3Bku9JAcU6yiqy0Ymaq+AEEo3la8wwvYNz7JBmHhaYlmpzQgaNYZPElclRanc/zSTb/2KBv0gKGf5wC8kGvTDevrRh7NqJNeDPVjSRBRAle4pWxf5GWz+4/9K2lPm24o0Q0O4+rvA8ch/7
 B9EZ5NtX
 mileTfWy5S3DgYg3EQ0nEnpCry75o2d7bLeB+lFnq7dlR91JvuoBhr1NdaM8nOGmea4J4yiSJzW26HBTshlXMFRiBG44dWhXJ/3sSB2cO59cnZudtTtxy1FB05SEEi+dJLNzyHLZwkBsnIJuJLzM6RXB4bPme/iKnXksSiVMwf3A178b368fdwerDc7HnIXfgUkmBfKwah8K7OWpwP4uc75SlrS75aHsPjDAJNHuHpYppcCKQ2V5EQ+j33jJvK38q7h+3U1QYfBehNSZaqDac1CucDsOND10QlHP5ZjF2eE5Gblnd2xZdYAwjt+xyeWzjlMzHw7Xc2A+9Nz1wi98Aa9co/YAfKO1p4/bDn0rBQnfvbQc1+KtT4hXiu9n0sF1xLrR2nJe+qmd6QprGs2ZC/N0s3BW7DaClkMx+eZLKu4lBzvXfxgprSQcx2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 18:04:35 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> On Fri, Mar 06, 2026 at 09:53:36AM -0800, Andrew Morton wrote:
> > On Fri,  6 Mar 2026 16:05:35 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> > 
> > > Use the newly introduced zone_lock_irqsave lock guard in
> > > reserve_highatomic_pageblock() to replace the explicit lock/unlock and
> > > goto out_unlock pattern with automatic scope-based cleanup.
> > > 
> > > ...
> > >
> > > -	zone_lock_irqsave(zone, flags);
> > > +	guard(zone_lock_irqsave)(zone);
> > 
> > guard() is cute, but this patch adds a little overhead - defconfig
> > page_alloc.o text increases by 32 bytes, presumably all in
> > reserve_highatomic_pageblock().  More instructions, larger cache
> > footprint.
> > 
> > So we're adding a little overhead to every user's Linux machine for all
> > time.  In return for which the developers get a little convenience and
> > maintainability.
> > 
> > Is it worth it?
> 
> Hi Andrew,
> 
> Before respinning this series, I wanted to check if it's worth pursuing.

Probably.  Much depends on the views of the people who regularly work
on this code.  Do they like guard(), or do they prefer the current
explicit open-coded locking?

> At the time you noted the text size increase and questioned whether the
> trade-off makes sense. Since then, the guard infrastructure was fixed by
> Peter, so the code generation situation has improved.

Great.

> The main benefit of the series is still simplifying control flow in
> these functions (removing multiple unlock paths, gotos, etc.).
> 
> Would you be open to this direction if the overhead is negligible, or
> would you prefer to avoid this kind of transformation regardless?
> 
> I can also limit the series to only the more complex cases if that
> helps.

Gee.  I think it would be helpful to prepare a respin which reflects
your current thinking, see what others think.

Please understand that I'm resisting adding new material during this
cycle
(https://lkml.kernel.org/r/20260323202941.08ddf2b0411501cae801ab4c@linux-foundation.org)
so you'd best be targeting 7.1-rc1 at the earliest.

But sending out a new version during this cycle for people to consider
would be a good step.


