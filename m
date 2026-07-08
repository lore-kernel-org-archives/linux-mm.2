Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00A91C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 06:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2D446B0093; Wed,  8 Jul 2026 02:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0C26B0095; Wed,  8 Jul 2026 02:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9E996B0096; Wed,  8 Jul 2026 02:35:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78F6F6B0093
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:35:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EAB831C3A32
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:35:44 +0000 (UTC)
X-FDA: 84964648608.05.44E1B13
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6B298A0008
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:35:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ary3czBU;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783492543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XWmw6MhRs0t0z19SkOsOO9Camu8gGn8nD1+tXIB2gPU=;
	b=WET9XmU+qBodhkBCOuLptsnKLWAsVpuOILlN5tfnv8Xz/nJ8qHd/5p4ibIlF8dIprn72OB
	iK+E1L999YJsWvcUAgZvsKLEmWUfg0lPxZBNM/uC5inbtp4cXPi0L+bQOdckNX3b0iF4jN
	+NSXsoWeeVk1z2Tk87QhBNkuHOWigH4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ary3czBU;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783492543;
	b=bsK0W8ufrG7A/WXYnvxSNaeG+xi0xyZFgD25QjWfKa3GqpC+kcEQlrU0m7faqA3XTis7sz
	TENqp5Evf4zkdy9g8R6YLC/8S0JIO8MTITnKBw5YX/mW1l7h1kELG1sDYIM81qbqK8yw3w
	aeTObiudTOvjAAOxzZ2qGARaFE91h5w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E594E6111A;
	Wed,  8 Jul 2026 06:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A611F00A3D;
	Wed,  8 Jul 2026 06:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783492542;
	bh=XWmw6MhRs0t0z19SkOsOO9Camu8gGn8nD1+tXIB2gPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ary3czBUrY5BcdJ3bPJlEhOFr7Qcw04lGjDc9MQsKZGy5g1+Dp/Ez09GzJmArhggm
	 tleNdg56kmZuj3eGJ2O5/pzrHjYhaBICFkjn6pHDMqP6q/UTcyS025e43edF6cH+uM
	 f1gXic3Gx44bPepct+tpNB7qDbE6hHVN1WUd9CQPkYrOIw0igHwe0CY3qxyTWTk2Ut
	 I+iqjyhG3QRvZFTD9Ns0Pxuc1yjYyz27HY0UBeT3Spwl8jYgid3Ad/kFtEO/X/oz+c
	 qKMkS7odNKVVb0eJew/2nh7nPJgDR6oyrQpWvgolblZHNv0Y0nGb6yJqYOzWnEZsqE
	 0B5Q6JJuonTJQ==
Date: Wed, 8 Jul 2026 07:35:29 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, akpm@linux-foundation.org, 
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, david@kernel.org, liam@infradead.org, rppt@kernel.org, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, Alexander.Krabler@kuka.com
Subject: Re: [RFC PATCH 0/3] mm/compaction: honour
 compact_unevictable_allowed in mlock race and alloc_contig path
Message-ID: <ak3vmMYh2dzO28wJ@lucifer>
References: <20260604023812.3700316-1-chenwandun1@gmail.com>
 <ak3uV7L5EEi3aKyD@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak3uV7L5EEi3aKyD@lucifer>
X-Stat-Signature: 3n9benagqa14d198e8rgdq11oywaru6r
X-Rspamd-Queue-Id: 6B298A0008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783492543-913319
X-HE-Meta: U2FsdGVkX1/7jfu6BLOJ4aQBv87RU/zp1WivL3bynB60dkcA8wnIMudkbsLRFC/2IH+9bPxMUSWQWQSU67GdJaqaTEj8T2FYK4evGZofJyP/VWcu0JEgVHsmPlWrM1Ij1r8RguMMfWKxorZ6QrHgsbLjkHfN+jcMXK/5dguGyWCjPdGrcnbZG9d8MNNLkHZ+M4PCn4OeyjVIOdse/BQjgRScWPHoYm+NkzGwlnIaS4S+n2WyG5YTmbxVDTb9E7fF9f0WW0kp27K6oy7ANTGBCzt/fserqLo/fMXmxiF55GgBCvKHx55wj6jZfKNMx1me0zya+eeeJugkP1u9OxwSMYPfkWXIUovum5He9y90AjRLUo03dAO+0wdP245zrM2SEsnb5CQxHPusbzpO0Trz6McHXECwrnPzvqzplmqWwXEg349TRIgInnl3E6SrLhipMzzPTyCUgb97VgyM3r1u0ShfTMcwyjrGiVmrt8Ar+C+wn0U4KzdQDM7CTyRmE2zlwA6TJzIDG/SEC7DN4xz0FWVd4Sg3dadpgm58mJDPrTyx3m2xZipnKJUWXSj18IYfspxiOR1hsl8nqBjwInsZ4jERO/ucW7v3x78qcjXJNN3Bcn1wnnWWVdPxxSSYPGEO8IZvqBkxH8dv37spVn2q/G7MqKiPZw7790A4skwuzrtJcd1W5qUfVLg37z54o1hpLSW9CoWkjc2PCE8tCqX/IXSSW93i+O2CXP0LvpWHbMGnnlDmtJJGyM+2y8NTtYViI0i1+55YAbP2JhaYztu/fLkpIPrn9MkMdwYafTiUATeoNuS9nh+6g6s2mGMXiQUI5VXUD/jXKzPk290vl956yI0iQQe7aye6YWeZszTvRV2JYcOzZXM9HlCviVxJ67OFRnnoBe2eqV9GyGca3zm1UfzmNI7gP3MtpDrmkkvflM862Ix7cLfO6zzwcLAcBpLo3cVmgU+b0T2ggHCZ0wD
 lz6I2Ibm
 so0rmQvvo+HhabIHaeYJ8Hi5ic27y2OJOFf1q1IK15Y+FQcApgtQhy+7mLtUoLl+u+8UZh2slqg0fQxyr9fK814abufXWDQE/vDq8Bvy/EixhEyVO1eQwLJAgUHHaBbJYdSbnb6uqMigGmHitaL3MwShOkGTe02hkqnj4Sqha7ALwrUIoU+ge5d9+PCeyyouLPhWDNUwxLGtiZS7oDLZms0ZPMFiYfNBiftaq25NpwnbLtt2fij0OjSYo1GYqJwUrNdmzv9/O4erWgVNxgMRAuxzoky8/KHp9EZtdWPhjSUJ+BntNFAUnB307c7N0VXJtKMT4gUPpIouz3Zq44l4VtjKgA4yN1HVIAJEc/HV2SP/RNBsxQQaL+Z/HnNr1BiSLV/5gxzxGZvYr8bdb4+kCwH02xm7a9oDbgzTG8sLjVdxwgm5eU2sobgCc72foBAfvzZi3UWmOZ2mXPEtYUX65WhErD453RXq5h55+2WRToR5YF2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 07:31:26AM +0100, Lorenzo Stoakes wrote:
> Errr... how does this relate to your other, non-RFC patch series [0] "mm: honour
> compact_unevictable_allowed in mlock and CMA paths"?
>
> Why did you send this separately and why do you not mention the other series
> here or there?
>
> And why is one RFC and the other not?
>
> You really need to add more context like this, I spent quite a bit of time
> reviewing [0] and don't want to find out that actually you are abandoning that
> for this or something?...

Oh hang on... this is old, and [0] is new, my bad.

It just got pinged up my mail client because of recent replies :>)

Thanks, Lorenzo

>
> On Thu, Jun 04, 2026 at 10:38:09AM +0800, Wandun Chen wrote:
> > From: Wandun Chen <chenwandun@lixiang.com>
> >
> > vm.compact_unevictable_allowed=0 is meant to keep compaction from
> > touching unevictable folios. In practice there are still two paths
> > where it does not take effect. This series fixes them and adds a
> > tracepoint to make such issues easier to diagnose in the future.
> >
> > Wandun Chen (3):
> >   mm/compaction: skip isolate mlocked folios when
> >     compact_unevictable_allowed=0
> >   mm/compaction: add per-folio isolation tracepoint
> >   mm/compaction: respect compact_unevictable_allowed in alloc_contig
> >     path
> >
> >  include/linux/compaction.h        |  6 ++++++
> >  include/trace/events/compaction.h | 26 ++++++++++++++++++++++++++
> >  mm/compaction.c                   | 14 +++++++++++---
> >  mm/internal.h                     |  1 +
> >  mm/page_alloc.c                   |  2 ++
> >  5 files changed, 46 insertions(+), 3 deletions(-)
> >
> > --
> > 2.43.0
> >
>
> Thanks, Lorenzo
>
> [0]:https://lore.kernel.org/all/20260707125925.3725177-1-chenwandun1@gmail.com/

